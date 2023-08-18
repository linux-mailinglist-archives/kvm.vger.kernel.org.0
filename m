Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3CF78096D
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359605AbjHRKAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 06:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359702AbjHRKAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 06:00:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45D144BE
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352795; x=1723888795;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uKwQoSbXr//1D14dA3RTbpiv2x0ORbeCziyXZilF0wo=;
  b=T4s5WUEtQPlSNLIDoW4zIx7xSM9C2j3pko4KG6Tf5FWWlbrQtapmOO86
   lDnnKp8oEAMzrga59iTwPwZkUUYvG5zggU1Gc83A7xbUvO1DHuH32sruS
   xRNKX5IXap8TOpOdmwZqve5lY89epmrGF27JvrFszeoLCX2MA09hvDNs2
   c5lfSxl+b7YKtbPOEryxXMo6p7tHMQEbUcXj2BqLqAm1SxzLhcsxIFyey
   PBktE6Y4T8HIlcPN5fh7XrFpDwkRzCMtwi5bNIA3u6WTkPRjJGChu5DQs
   NZJlj25W26jSxdwkuHXk/77yOD9fyESKXn51/Vg/WmRQkcdV6EZF3B1KZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966722"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966722"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:58:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235532"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235532"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:58:16 -0700
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
Subject: [PATCH v2 45/58] i386/tdx: Limit the range size for MapGPA
Date:   Fri, 18 Aug 2023 05:50:28 -0400
Message-Id: <20230818095041.1973309-46-xiaoyao.li@intel.com>
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

If the range for TDG.VP.VMCALL<MapGPA> is too large, process the limited
size and return retry error.  It's bad for VMM to take too long time,
e.g. second order, with blocking vcpu execution.  It results in too many
missing timer interrupts.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 0c43c1f7759f..ced55be506d1 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -994,12 +994,16 @@ static hwaddr tdx_shared_bit(X86CPU *cpu)
     return (cpu->phys_bits > 48) ? BIT_ULL(51) : BIT_ULL(47);
 }
 
+/* 64MB at most in one call. What value is appropriate? */
+#define TDX_MAP_GPA_MAX_LEN     (64 * 1024 * 1024)
+
 static void tdx_handle_map_gpa(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
 {
     hwaddr shared_bit = tdx_shared_bit(cpu);
     hwaddr gpa = vmcall->in_r12 & ~shared_bit;
     bool private = !(vmcall->in_r12 & shared_bit);
     hwaddr size = vmcall->in_r13;
+    bool retry = false;
     int ret = 0;
 
     vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
@@ -1018,12 +1022,25 @@ static void tdx_handle_map_gpa(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
         return;
     }
 
+    if (size > TDX_MAP_GPA_MAX_LEN) {
+        retry = true;
+        size = TDX_MAP_GPA_MAX_LEN;
+    }
+
     if (size > 0) {
         ret = kvm_convert_memory(gpa, size, private);
     }
 
     if (!ret) {
-        vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
+        if (retry) {
+            vmcall->status_code = TDG_VP_VMCALL_RETRY;
+            vmcall->out_r11 = gpa + size;
+            if (!private) {
+                vmcall->out_r11 |= shared_bit;
+            }
+        } else {
+            vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
+        }
     }
 }
 
-- 
2.34.1

