Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F08780916
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359424AbjHRJzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359532AbjHRJzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:55:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E845130D1
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352539; x=1723888539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UNz7MOGRmZ0RCC7N+iMVEuoRo4KVjeIFiDHKv0D5kJ0=;
  b=HPOkvHc4cQD+o3DoDMxXjoQiqO7L9wf1doo5xB2sJG/U/UkEulwMPqcy
   Z2uayBA9i2xd34PtB89W3Q9Sr48RO4SecAEX6sGMGIuKtyItM/BukurAv
   /Utg4Xh0picnQGmyrK/PBUtrSqudRNI2MHBCw9/COHpY6rJrRAOJJpUcN
   kQIMz3heDA8KFbN1YNGBgzwnMDRFXF6ULCvu1t2pH/cIiTYFzfQd0Iyfu
   KmcvTz0Z8MjwOWxWh49oFVmmmzzGMt0MYSXFAk+8unssvzJfMyxqwBGfh
   M4+d88p3F8WRIi13rV8McshGwpPCQxylSD5bOnZM3N9odBe0aQH2aYvUG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371965788"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371965788"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:55:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849234866"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849234866"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:55:13 -0700
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
Subject: [PATCH v2 10/58] i386/tdx: Integrate tdx_caps->xfam_fixed0/1 into tdx_cpuid_lookup
Date:   Fri, 18 Aug 2023 05:49:53 -0400
Message-Id: <20230818095041.1973309-11-xiaoyao.li@intel.com>
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

KVM requires userspace to pass XFAM configuration via CPUID 0xD leaves.

Convert tdx_caps->xfam_fixed0/1 into corresponding
tdx_cpuid_lookup[].tdx_fixed0/1 field of CPUID 0xD leaves. Thus the
requirement can be applied naturally.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c     |  3 ---
 target/i386/cpu.h     |  3 +++
 target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 97ad229d8ba3..b8850a02539a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1568,9 +1568,6 @@ static const X86RegisterInfo32 x86_reg_info_32[CPU_NB_REGS32] = {
 };
 #undef REGISTER
 
-/* CPUID feature bits available in XSS */
-#define CPUID_XSTATE_XSS_MASK    (XSTATE_ARCH_LBR_MASK)
-
 ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
     [XSTATE_FP_BIT] = {
         /* x87 FP state component is always enabled if XSAVE is supported */
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index c93dcd274531..d4a7f9e3f54c 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -588,6 +588,9 @@ typedef enum X86Seg {
                                  XSTATE_Hi16_ZMM_MASK | XSTATE_PKRU_MASK | \
                                  XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK)
 
+/* CPUID feature bits available in XSS */
+#define CPUID_XSTATE_XSS_MASK    (XSTATE_ARCH_LBR_MASK)
+
 /* CPUID feature words */
 typedef enum FeatureWord {
     FEAT_1_EDX,         /* CPUID[1].EDX */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 4518c79aecc8..19aed03f12c6 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -395,6 +395,30 @@ static void update_tdx_cpuid_lookup_by_tdx_caps(void)
         entry->tdx_fixed0 &= ~config;
         entry->tdx_fixed1 &= ~config;
     }
+
+    /*
+     * Because KVM gets XFAM settings via CPUID leaves 0xD,  map
+     * tdx_caps->xfam_fixed{0, 1} into tdx_cpuid_lookup[].tdx_fixed{0, 1}.
+     *
+     * Then the enforment applies in tdx_get_configurable_cpuid() naturally.
+     */
+    tdx_cpuid_lookup[FEAT_XSAVE_XCR0_LO].tdx_fixed0 =
+            (uint32_t)~tdx_caps->xfam_fixed0 & CPUID_XSTATE_XCR0_MASK;
+    tdx_cpuid_lookup[FEAT_XSAVE_XCR0_LO].tdx_fixed1 =
+            (uint32_t)tdx_caps->xfam_fixed1 & CPUID_XSTATE_XCR0_MASK;
+    tdx_cpuid_lookup[FEAT_XSAVE_XCR0_HI].tdx_fixed0 =
+            (~tdx_caps->xfam_fixed0 & CPUID_XSTATE_XCR0_MASK) >> 32;
+    tdx_cpuid_lookup[FEAT_XSAVE_XCR0_HI].tdx_fixed1 =
+            (tdx_caps->xfam_fixed1 & CPUID_XSTATE_XCR0_MASK) >> 32;
+
+    tdx_cpuid_lookup[FEAT_XSAVE_XSS_LO].tdx_fixed0 =
+            (uint32_t)~tdx_caps->xfam_fixed0 & CPUID_XSTATE_XSS_MASK;
+    tdx_cpuid_lookup[FEAT_XSAVE_XSS_LO].tdx_fixed1 =
+            (uint32_t)tdx_caps->xfam_fixed1 & CPUID_XSTATE_XSS_MASK;
+    tdx_cpuid_lookup[FEAT_XSAVE_XSS_HI].tdx_fixed0 =
+            (~tdx_caps->xfam_fixed0 & CPUID_XSTATE_XSS_MASK) >> 32;
+    tdx_cpuid_lookup[FEAT_XSAVE_XSS_HI].tdx_fixed1 =
+            (tdx_caps->xfam_fixed1 & CPUID_XSTATE_XSS_MASK) >> 32;
 }
 
 int tdx_kvm_init(MachineState *ms, Error **errp)
-- 
2.34.1

