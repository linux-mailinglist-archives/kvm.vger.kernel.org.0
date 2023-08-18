Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40966780938
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359510AbjHRJ7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359518AbjHRJ6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:58:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFC94205
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352697; x=1723888697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4pumGxfrijyUn0Q5nX1dtYuXDXgLxajixMrQt/+4nDw=;
  b=c1FOX2dp5mNNGp+00xD24O9At+uRpeLMBdsbMSKFaNDXhGKOubmy5VK3
   hSEGO5ZPr6G/DvCVrp5bWtytLB62voVVHn/BOGvHfTks/eBnmiNYVecbh
   XApMi/s6Hb9LdfUyHIPNwzQZOwP26FKeZGYaHUNEx1v6mAJGeOwm70n5E
   xCWDWR0vjizsDsv5bewpQngd2gK77jYD8O8DlmMjOiSkpQgO5Ptvhe7FW
   6cmPAGyLrW1FrqetwMFfg0lpNDme94Elo0y57vOEKfLZSfCW3iuzwiewB
   27BdGMM59jooEYBV0KDUup184BrutBsJ/14sSCqDhu29LX9ONM3uGBnVb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966125"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966125"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:56:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235208"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235208"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:56:32 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>, xiaoyao.li@intel.com,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v2 25/58] kvm/tdx: Don't complain when converting vMMIO region to shared
Date:   Fri, 18 Aug 2023 05:50:08 -0400
Message-Id: <20230818095041.1973309-26-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230818095041.1973309-1-xiaoyao.li@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because vMMIO region needs to be shared region, guest TD may explicitly
convert such region from private to shared.  Don't complain such
conversion.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index fceec7f2a83f..9d0aa8c97feb 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3094,8 +3094,24 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
          */
         ram_block_convert_range(rb, offset, size, to_private);
     } else {
-        warn_report("Convert non guest-memfd backed memory region (0x%"HWADDR_PRIx" ,+ 0x%"HWADDR_PRIx") to %s",
-                    start, size, to_private ? "private" : "shared");
+        MemoryRegion *mr = section.mr;
+
+        /*
+         * Because vMMIO region must be shared, guest TD may convert vMMIO
+         * region to shared explicitly.  Don't complain such case.  See
+         * memory_region_type() for checking if the region is MMIO region.
+         */
+        if (to_private ||
+            memory_region_is_ram(mr) ||
+            memory_region_is_ram_device(mr) ||
+            memory_region_is_rom(mr) ||
+            memory_region_is_romd(mr)) {
+            warn_report("Convert non guest-memfd backed memory region (0x%"HWADDR_PRIx" ,+ 0x%"HWADDR_PRIx") of %s to %s",
+                        start, size, mr->name, to_private ? "private" : "shared");
+	    } else {
+		    ret = 0;
+	    }
+
     }
 
     memory_region_unref(section.mr);
-- 
2.34.1

