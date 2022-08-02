Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4344587840
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbiHBHtK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbiHBHsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:48:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC314D166
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659426518; x=1690962518;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jiLB+yy7m6C+jDieidpZlkmlj/B0gBUa+QDy54xtpXo=;
  b=ADM/yOeS2CYOMeRhQs3jduYHcTrpb+OqFMSo31ijY4Tbx2LLyhoDABj/
   PLXPZ7ge0UaPGXZX2e3K9MpvHJaPytOccGGZEpGLEg7hp1j5VPYyBkCq2
   WOV34CV5UORT8RBkWqgVKuxpFEwrff6wPm4k0HCdmc1Wm9z8RN599wXKK
   VIoKnPOory+SqpokEBfoAPVB6X3zvo43FadFaNicJ2EMDYKj6EIIRuQC/
   LjBTTbCFpbgUDX1MXjJnEWHTolFPdqbSojpzPwDTIRRe5/cOq1W4rSVWZ
   Kyww/cRvbIhgwx4eZSpFF0aClvLpDnKcx18bv3l/9M+Dq+b37PIhFVTId
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="286908519"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="286908519"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 00:48:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="630603926"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by orsmga008.jf.intel.com with ESMTP; 02 Aug 2022 00:48:34 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com,
        xiaoyao.li@intel.com
Subject: [PATCH v1 10/40] i386/tdx: Integrate tdx_caps->xfam_fixed0/1 into tdx_cpuid_lookup
Date:   Tue,  2 Aug 2022 15:47:20 +0800
Message-Id: <20220802074750.2581308-11-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220802074750.2581308-1-xiaoyao.li@intel.com>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVMM requires userspace to pass XFAM configuration via CPUID leaves 0xDs.

Convert tdx_caps->xfam_fixed0/1 into corresponding
tdx_cpuid_lookup[].tdx_fixed0/1 field of CPUID leaves 0xD. Thus the
requirement can applied naturally.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c     |  3 ---
 target/i386/cpu.h     |  3 +++
 target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 194b5a31afac..45652bb2fd7c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1418,9 +1418,6 @@ static const X86RegisterInfo32 x86_reg_info_32[CPU_NB_REGS32] = {
 };
 #undef REGISTER
 
-/* CPUID feature bits available in XSS */
-#define CPUID_XSTATE_XSS_MASK    (XSTATE_ARCH_LBR_MASK)
-
 ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
     [XSTATE_FP_BIT] = {
         /* x87 FP state component is always enabled if XSAVE is supported */
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index cc9da9fc4318..90f403aecd8b 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -583,6 +583,9 @@ typedef enum X86Seg {
                                  XSTATE_Hi16_ZMM_MASK | XSTATE_PKRU_MASK | \
                                  XSTATE_XTILE_CFG_MASK | XSTATE_XTILE_DATA_MASK)
 
+/* CPUID feature bits available in XSS */
+#define CPUID_XSTATE_XSS_MASK    (XSTATE_ARCH_LBR_MASK)
+
 /* CPUID feature words */
 typedef enum FeatureWord {
     FEAT_1_EDX,         /* CPUID[1].EDX */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index d12b03fa05c9..dffaa533f899 100644
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
2.27.0

