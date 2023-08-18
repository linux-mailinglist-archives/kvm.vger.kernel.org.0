Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0270478097A
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359629AbjHRKCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 06:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359603AbjHRKBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 06:01:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8639144A6
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 03:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352875; x=1723888875;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8NqFPqQKU0ASwWk0m1KQC1eMQXRmdpKPHoybh+5yWaU=;
  b=EjlKbYcrbLBrsjklMe8ppyvftKdMZvqTwBXKDjA+3oFiIEoHwK2sHfEz
   WszzlFtu8hru+/12FMBZBtAbQtKfWIKQs5ELZ1vIWG91Abc5Hgb46q7yb
   y1jNFkRIkONBT6FS0LMxdDchpXcNTCNXl17HerxXDyZJ/rUlHPiFU0gkR
   3EfJ63owW4ZEaqa8NJk4Tkq1A0EDmY7lRdRs7+z6HGsKt0LZ84uhym0ki
   xvkAjl6pHxR3EoYIm152FvcluGtirjskzTItTNIE2G09q7d48jXc5zfUS
   rdOG31/1cdKYdO7hYKiVFg60W8FzsKWPS/rzdKKGUlsNIIcT3Fa/iG376
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966968"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966968"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:59:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235832"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235832"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:59:13 -0700
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
Subject: [PATCH v2 56/58] i386/tdx: Skip kvm_put_apicbase() for TDs
Date:   Fri, 18 Aug 2023 05:50:39 -0400
Message-Id: <20230818095041.1973309-57-xiaoyao.li@intel.com>
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

KVM doesn't allow wirting to MSR_IA32_APICBASE for TDs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/kvm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 53d8d65f6667..d542351983cd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3208,6 +3208,11 @@ void kvm_put_apicbase(X86CPU *cpu, uint64_t value)
 {
     int ret;
 
+    /* TODO: Allow accessing guest state for debug TDs. */
+    if (is_tdx_vm()) {
+        return;
+    }
+
     ret = kvm_put_one_msr(cpu, MSR_IA32_APICBASE, value);
     assert(ret == 1);
 }
-- 
2.34.1

