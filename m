Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C336EA471
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjDUHQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjDUHQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:16:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A047DC
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 00:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682061412; x=1713597412;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kW0IwUNWx7o30RMXHoeUQZannoF+N/qSfK0aT3A6lXE=;
  b=DkZjzGhsdrojL9vv44LzlzFqNsasigE0NTlERp6Uzb0UaKXx+f5G+Lw9
   NU1Cpsu8XAkFFCANGCoNDnVqscViU2JE0KfVvfWUTCTyoehjs1DNPs+GU
   1HJTuss1AYi2UbkYrZr8Ks9S7yWexmU10vF0o6OmnBDKKc7W4J3glcwd2
   a9Bw0QtGRx45jqQff/sb44EVevFji6/SH0k17Hy3PBP2643NVG0+2SLRK
   wI5bqdORIad6z7R/YuO7zmm1fa/CoIxDNp4Fyyg08WGaT1tZaoJlLtMgE
   1anUdHsEJkesrMZeKQzSd+CSpZmy3A3bGtCBHQrgAgCeK9CV5JqdLIu7h
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="326260530"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="326260530"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:16:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="938385324"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="938385324"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:16:39 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, weijiang.yang@intel.com
Subject: [PATCH 1/4] target/i386: Enable XSAVES support for user mode CET states
Date:   Fri, 21 Apr 2023 00:12:24 -0400
Message-Id: <20230421041227.90915-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421041227.90915-1-weijiang.yang@intel.com>
References: <20230421041227.90915-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add CET_U bit support in XSS MSR and report data size in CPUID.
XSAVES/XRSTORS are used to boost CET states save/restore process,
XSS[bit 11] corresponds to user mode CET states.
CET Shadow Stack(SHSTK) and Indirect Branch Tracking(IBT) features
are enumerated via CPUID.(EAX=07H,ECX=0H):ECX[7] and EDX[20]
respectively, two featues share the same bit for user mode states.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/cpu.c | 39 +++++++++++++++++++++++++++++++--------
 target/i386/cpu.h | 13 +++++++++++++
 2 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index cab1e2a957..be86df8c1d 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -943,7 +943,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .feat_names = {
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, "cet-u",
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
@@ -1420,7 +1420,7 @@ static const X86RegisterInfo32 x86_reg_info_32[CPU_NB_REGS32] = {
 #undef REGISTER
 
 /* CPUID feature bits available in XSS */
-#define CPUID_XSTATE_XSS_MASK    (XSTATE_ARCH_LBR_MASK)
+#define CPUID_XSTATE_XSS_MASK    (XSTATE_ARCH_LBR_MASK | XSTATE_CET_U_MASK)
 
 ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
     [XSTATE_FP_BIT] = {
@@ -1438,7 +1438,7 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
             .size = sizeof(XSaveAVX) },
     [XSTATE_BNDREGS_BIT] =
           { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
-            .size = sizeof(XSaveBNDREG)  },
+            .size = sizeof(XSaveBNDREG) },
     [XSTATE_BNDCSR_BIT] =
           { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
             .size = sizeof(XSaveBNDCSR)  },
@@ -1458,14 +1458,20 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
             .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_ARCH_LBR,
             .offset = 0 /*supervisor mode component, offset = 0 */,
             .size = sizeof(XSavesArchLBR) },
+    [XSTATE_CET_U_BIT] = {
+        .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_CET_SHSTK,
+        /*
+         * The features enabled in XSS MSR always use compacted format
+         * to store the data, in this case .offset == 0.
+         */
+        .offset = 0,
+        .size = sizeof(XSavesCETU) },
     [XSTATE_XTILE_CFG_BIT] = {
         .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
-        .size = sizeof(XSaveXTILECFG),
-    },
+        .size = sizeof(XSaveXTILECFG) },
     [XSTATE_XTILE_DATA_BIT] = {
         .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
-        .size = sizeof(XSaveXTILEDATA)
-    },
+        .size = sizeof(XSaveXTILEDATA) }
 };
 
 uint32_t xsave_area_size(uint64_t mask, bool compacted)
@@ -6258,9 +6264,26 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
         if (env->features[esa->feature] & esa->bits) {
             mask |= (1ULL << i);
         }
+
+        /*
+         * Both CET SHSTK and IBT feature requires XSAVES support, but two
+         * features can be controlled independently by kernel, and we only
+         * have one correlated bit set in x86_ext_save_areas, so if either
+         * of two features is enabled, we set the XSAVES support bit to make
+         * the enabled feature work.
+         */
+        if (i == XSTATE_CET_U_BIT) {
+            uint64_t ecx = env->features[FEAT_7_0_ECX];
+            uint64_t edx = env->features[FEAT_7_0_EDX];
+
+            if ((ecx & CPUID_7_0_ECX_CET_SHSTK) ||
+                (edx & CPUID_7_0_EDX_CET_IBT)) {
+                mask |= (1ULL << i);
+            }
+        }
     }
 
-    /* Only request permission for first vcpu */
+    /* Only request permission from fisrt vcpu. */
     if (kvm_enabled() && !request_perm) {
         kvm_request_xsave_components(cpu, mask);
         request_perm = true;
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index d243e290d3..6526a03206 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -554,6 +554,7 @@ typedef enum X86Seg {
 #define XSTATE_ZMM_Hi256_BIT            6
 #define XSTATE_Hi16_ZMM_BIT             7
 #define XSTATE_PKRU_BIT                 9
+#define XSTATE_CET_U_BIT                11
 #define XSTATE_ARCH_LBR_BIT             15
 #define XSTATE_XTILE_CFG_BIT            17
 #define XSTATE_XTILE_DATA_BIT           18
@@ -567,6 +568,7 @@ typedef enum X86Seg {
 #define XSTATE_ZMM_Hi256_MASK           (1ULL << XSTATE_ZMM_Hi256_BIT)
 #define XSTATE_Hi16_ZMM_MASK            (1ULL << XSTATE_Hi16_ZMM_BIT)
 #define XSTATE_PKRU_MASK                (1ULL << XSTATE_PKRU_BIT)
+#define XSTATE_CET_U_MASK               (1ULL << XSTATE_CET_U_BIT)
 #define XSTATE_ARCH_LBR_MASK            (1ULL << XSTATE_ARCH_LBR_BIT)
 #define XSTATE_XTILE_CFG_MASK           (1ULL << XSTATE_XTILE_CFG_BIT)
 #define XSTATE_XTILE_DATA_MASK          (1ULL << XSTATE_XTILE_DATA_BIT)
@@ -841,6 +843,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_7_0_ECX_WAITPKG           (1U << 5)
 /* Additional AVX-512 Vector Byte Manipulation Instruction */
 #define CPUID_7_0_ECX_AVX512_VBMI2      (1U << 6)
+/* CET SHSTK feature */
+#define CPUID_7_0_ECX_CET_SHSTK         (1U << 7)
 /* Galois Field New Instructions */
 #define CPUID_7_0_ECX_GFNI              (1U << 8)
 /* Vector AES Instructions */
@@ -884,6 +888,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_7_0_EDX_TSX_LDTRK         (1U << 16)
 /* Architectural LBRs */
 #define CPUID_7_0_EDX_ARCH_LBR          (1U << 19)
+/* CET IBT feature */
+#define CPUID_7_0_EDX_CET_IBT           (1U << 20)
 /* AMX_BF16 instruction */
 #define CPUID_7_0_EDX_AMX_BF16          (1U << 22)
 /* AVX512_FP16 instruction */
@@ -1428,6 +1434,12 @@ typedef struct XSavePKRU {
     uint32_t padding;
 } XSavePKRU;
 
+/* Ext. save area 11: User mode CET state */
+typedef struct XSavesCETU {
+    uint64_t u_cet;
+    uint64_t user_ssp;
+} XSavesCETU;
+
 /* Ext. save area 17: AMX XTILECFG state */
 typedef struct XSaveXTILECFG {
     uint8_t xtilecfg[64];
@@ -1463,6 +1475,7 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveOpmask) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveZMM_Hi256) != 0x200);
 QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
 QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
+QEMU_BUILD_BUG_ON(sizeof(XSavesCETU) != 0x10);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
 QEMU_BUILD_BUG_ON(sizeof(XSavesArchLBR) != 0x328);
-- 
2.27.0

