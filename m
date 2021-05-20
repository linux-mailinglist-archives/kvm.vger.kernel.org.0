Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B03F38B26F
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 17:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243040AbhETPEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 11:04:22 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:46303 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240068AbhETPEI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 11:04:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id A688F19409E7;
        Thu, 20 May 2021 10:56:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 20 May 2021 10:56:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=8I444d16Lc7oDOyG+INfqz7vdcwzDo1ckG61DIvMJcw=; b=uDfiqN6d
        x4zJGELcFfrAINbYtvQnSwhQV3jk91NqqbcrUShu7k1pjAxzKVdCB0m3xPPaCarE
        /ppSVhbY1KBfGaI9JjcLDqmvfzLh3Jy+jLjI5zhxMyzl1r3Yc3E/owo7jHSpHuup
        O3Z+pmSfRnRzFjpB1zkeBzg3cK+uCYHYtvFtW2YC8TIY6Gjav5FTBCDs35p78vdV
        TUn0RYhlpqxjNKPRx1cVYX490Lloy3t382a+E6IQb5NgzKhSxpBZe1eQwI45olcp
        duqjJeVBvaQnsknoKSO+yKGPRXKeMwskbSmCDbiuqIKpaZa+FRUp5bMuke9MwcYD
        qM4mZXWm2CnocQ==
X-ME-Sender: <xms:tXimYKUjP4SroapCKuq2TkyjmDVU-36pcjqPtrQv2WzMAl0Hp9qdvw>
    <xme:tXimYGmH-kLZet6JvB4eRv93dfXUCeXJ9AODNcO6QNcNEWsg1NP2PcE7qt9ISiX0a
    kRjBMBt_LG-Af6esI0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejuddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:tXimYOZVgHRqcGWzdpV92kiT9-PjksTJ612bM8BHCEUBCsyw6As8_w>
    <xmx:tXimYBWjvNAvFxmGBjU8vzOcdgHIAfpPTVn2CuW3PpmW6GfcC1eLDA>
    <xmx:tXimYEkSdiQkO1iROyJzZ5zB560Mn0kjf6-jt5rvC_Ei1FiJ140Kzw>
    <xmx:tXimYCmCe-XlK1jGiiLYGV7-vgtNeI49axsJ-JVF3dLe8aabxAzjVw>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 20 May 2021 10:56:52 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 5d3d0369;
        Thu, 20 May 2021 14:56:48 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Babu Moger <babu.moger@amd.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [RFC PATCH 4/7] target/i386: Prepare for per-vendor X86XSaveArea layout
Date:   Thu, 20 May 2021 15:56:44 +0100
Message-Id: <20210520145647.3483809-5-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210520145647.3483809-1-david.edmondson@oracle.com>
References: <20210520145647.3483809-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move Intel specific components of X86XSaveArea into a sub-union.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 target/i386/cpu.c            | 12 ++++----
 target/i386/cpu.h            | 55 +++++++++++++++++++++---------------
 target/i386/kvm/kvm.c        | 12 ++++----
 target/i386/tcg/fpu_helper.c | 12 ++++----
 target/i386/xsave_helper.c   | 24 ++++++++--------
 5 files changed, 63 insertions(+), 52 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index c496bfa1c2..4f481691b4 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1418,27 +1418,27 @@ static const ExtSaveArea x86_ext_save_areas[] = {
             .size = sizeof(XSaveAVX) },
     [XSTATE_BNDREGS_BIT] =
           { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
-            .offset = offsetof(X86XSaveArea, bndreg_state),
+            .offset = offsetof(X86XSaveArea, intel.bndreg_state),
             .size = sizeof(XSaveBNDREG)  },
     [XSTATE_BNDCSR_BIT] =
           { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
-            .offset = offsetof(X86XSaveArea, bndcsr_state),
+            .offset = offsetof(X86XSaveArea, intel.bndcsr_state),
             .size = sizeof(XSaveBNDCSR)  },
     [XSTATE_OPMASK_BIT] =
           { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
-            .offset = offsetof(X86XSaveArea, opmask_state),
+            .offset = offsetof(X86XSaveArea, intel.opmask_state),
             .size = sizeof(XSaveOpmask) },
     [XSTATE_ZMM_Hi256_BIT] =
           { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
-            .offset = offsetof(X86XSaveArea, zmm_hi256_state),
+            .offset = offsetof(X86XSaveArea, intel.zmm_hi256_state),
             .size = sizeof(XSaveZMM_Hi256) },
     [XSTATE_Hi16_ZMM_BIT] =
           { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
-            .offset = offsetof(X86XSaveArea, hi16_zmm_state),
+            .offset = offsetof(X86XSaveArea, intel.hi16_zmm_state),
             .size = sizeof(XSaveHi16_ZMM) },
     [XSTATE_PKRU_BIT] =
           { .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_PKU,
-            .offset = offsetof(X86XSaveArea, pkru_state),
+            .offset = offsetof(X86XSaveArea, intel.pkru_state),
             .size = sizeof(XSavePKRU) },
 };
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 0bb365bddf..f1ce4e3008 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1330,36 +1330,47 @@ typedef struct X86XSaveArea {
     /* AVX State: */
     XSaveAVX avx_state;
 
-    /* Ensure that XSaveBNDREG is properly aligned. */
-    uint8_t padding[XSAVE_BNDREG_OFFSET
-                    - sizeof(X86LegacyXSaveArea)
-                    - sizeof(X86XSaveHeader)
-                    - sizeof(XSaveAVX)];
-
-    /* MPX State: */
-    XSaveBNDREG bndreg_state;
-    XSaveBNDCSR bndcsr_state;
-    /* AVX-512 State: */
-    XSaveOpmask opmask_state;
-    XSaveZMM_Hi256 zmm_hi256_state;
-    XSaveHi16_ZMM hi16_zmm_state;
-    /* PKRU State: */
-    XSavePKRU pkru_state;
+    union {
+        struct {
+            /* Ensure that XSaveBNDREG is properly aligned. */
+            uint8_t padding[XSAVE_BNDREG_OFFSET
+                            - sizeof(X86LegacyXSaveArea)
+                            - sizeof(X86XSaveHeader)
+                            - sizeof(XSaveAVX)];
+
+            /* MPX State: */
+            XSaveBNDREG bndreg_state;
+            XSaveBNDCSR bndcsr_state;
+            /* AVX-512 State: */
+            XSaveOpmask opmask_state;
+            XSaveZMM_Hi256 zmm_hi256_state;
+            XSaveHi16_ZMM hi16_zmm_state;
+            /* PKRU State: */
+            XSavePKRU pkru_state;
+        } intel;
+    };
 } X86XSaveArea;
 
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, avx_state) != XSAVE_AVX_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, avx_state)
+                  != XSAVE_AVX_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndreg_state) != XSAVE_BNDREG_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, intel.bndreg_state)
+                  != XSAVE_BNDREG_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, bndcsr_state) != XSAVE_BNDCSR_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, intel.bndcsr_state)
+                  != XSAVE_BNDCSR_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDCSR) != 0x40);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, opmask_state) != XSAVE_OPMASK_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, intel.opmask_state)
+                  != XSAVE_OPMASK_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSaveOpmask) != 0x40);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, zmm_hi256_state) != XSAVE_ZMM_HI256_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, intel.zmm_hi256_state)
+                  != XSAVE_ZMM_HI256_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSaveZMM_Hi256) != 0x200);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, hi16_zmm_state) != XSAVE_HI16_ZMM_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, intel.hi16_zmm_state)
+                  != XSAVE_HI16_ZMM_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
-QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, pkru_state) != XSAVE_PKRU_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, intel.pkru_state)
+                  != XSAVE_PKRU_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
 
 typedef enum TPRAccess {
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index aff0774fef..417776a635 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2409,12 +2409,12 @@ ASSERT_OFFSET(XSAVE_ST_SPACE_OFFSET, legacy.fpregs);
 ASSERT_OFFSET(XSAVE_XMM_SPACE_OFFSET, legacy.xmm_regs);
 ASSERT_OFFSET(XSAVE_XSTATE_BV_OFFSET, header.xstate_bv);
 ASSERT_OFFSET(XSAVE_AVX_OFFSET, avx_state);
-ASSERT_OFFSET(XSAVE_BNDREG_OFFSET, bndreg_state);
-ASSERT_OFFSET(XSAVE_BNDCSR_OFFSET, bndcsr_state);
-ASSERT_OFFSET(XSAVE_OPMASK_OFFSET, opmask_state);
-ASSERT_OFFSET(XSAVE_ZMM_HI256_OFFSET, zmm_hi256_state);
-ASSERT_OFFSET(XSAVE_HI16_ZMM_OFFSET, hi16_zmm_state);
-ASSERT_OFFSET(XSAVE_PKRU_OFFSET, pkru_state);
+ASSERT_OFFSET(XSAVE_BNDREG_OFFSET, intel.bndreg_state);
+ASSERT_OFFSET(XSAVE_BNDCSR_OFFSET, intel.bndcsr_state);
+ASSERT_OFFSET(XSAVE_OPMASK_OFFSET, intel.opmask_state);
+ASSERT_OFFSET(XSAVE_ZMM_HI256_OFFSET, intel.zmm_hi256_state);
+ASSERT_OFFSET(XSAVE_HI16_ZMM_OFFSET, intel.hi16_zmm_state);
+ASSERT_OFFSET(XSAVE_PKRU_OFFSET, intel.pkru_state);
 
 static int kvm_put_xsave(X86CPU *cpu)
 {
diff --git a/target/i386/tcg/fpu_helper.c b/target/i386/tcg/fpu_helper.c
index 1b30f1bb73..fba2de5b04 100644
--- a/target/i386/tcg/fpu_helper.c
+++ b/target/i386/tcg/fpu_helper.c
@@ -2637,13 +2637,13 @@ static void do_xsave(CPUX86State *env, target_ulong ptr, uint64_t rfbm,
         do_xsave_sse(env, ptr, ra);
     }
     if (opt & XSTATE_BNDREGS_MASK) {
-        do_xsave_bndregs(env, ptr + XO(bndreg_state), ra);
+        do_xsave_bndregs(env, ptr + XO(intel.bndreg_state), ra);
     }
     if (opt & XSTATE_BNDCSR_MASK) {
-        do_xsave_bndcsr(env, ptr + XO(bndcsr_state), ra);
+        do_xsave_bndcsr(env, ptr + XO(intel.bndcsr_state), ra);
     }
     if (opt & XSTATE_PKRU_MASK) {
-        do_xsave_pkru(env, ptr + XO(pkru_state), ra);
+        do_xsave_pkru(env, ptr + XO(intel.pkru_state), ra);
     }
 
     /* Update the XSTATE_BV field.  */
@@ -2836,7 +2836,7 @@ void helper_xrstor(CPUX86State *env, target_ulong ptr, uint64_t rfbm)
     }
     if (rfbm & XSTATE_BNDREGS_MASK) {
         if (xstate_bv & XSTATE_BNDREGS_MASK) {
-            do_xrstor_bndregs(env, ptr + XO(bndreg_state), ra);
+            do_xrstor_bndregs(env, ptr + XO(intel.bndreg_state), ra);
             env->hflags |= HF_MPX_IU_MASK;
         } else {
             memset(env->bnd_regs, 0, sizeof(env->bnd_regs));
@@ -2845,7 +2845,7 @@ void helper_xrstor(CPUX86State *env, target_ulong ptr, uint64_t rfbm)
     }
     if (rfbm & XSTATE_BNDCSR_MASK) {
         if (xstate_bv & XSTATE_BNDCSR_MASK) {
-            do_xrstor_bndcsr(env, ptr + XO(bndcsr_state), ra);
+            do_xrstor_bndcsr(env, ptr + XO(intel.bndcsr_state), ra);
         } else {
             memset(&env->bndcs_regs, 0, sizeof(env->bndcs_regs));
         }
@@ -2854,7 +2854,7 @@ void helper_xrstor(CPUX86State *env, target_ulong ptr, uint64_t rfbm)
     if (rfbm & XSTATE_PKRU_MASK) {
         uint64_t old_pkru = env->pkru;
         if (xstate_bv & XSTATE_PKRU_MASK) {
-            do_xrstor_pkru(env, ptr + XO(pkru_state), ra);
+            do_xrstor_pkru(env, ptr + XO(intel.pkru_state), ra);
         } else {
             env->pkru = 0;
         }
diff --git a/target/i386/xsave_helper.c b/target/i386/xsave_helper.c
index 818115e7d2..97dbab85d1 100644
--- a/target/i386/xsave_helper.c
+++ b/target/i386/xsave_helper.c
@@ -31,16 +31,16 @@ void x86_cpu_xsave_all_areas(X86CPU *cpu, X86XSaveArea *buf)
             sizeof env->fpregs);
     xsave->legacy.mxcsr = env->mxcsr;
     xsave->header.xstate_bv = env->xstate_bv;
-    memcpy(&xsave->bndreg_state.bnd_regs, env->bnd_regs,
+    memcpy(&xsave->intel.bndreg_state.bnd_regs, env->bnd_regs,
             sizeof env->bnd_regs);
-    xsave->bndcsr_state.bndcsr = env->bndcs_regs;
-    memcpy(&xsave->opmask_state.opmask_regs, env->opmask_regs,
+    xsave->intel.bndcsr_state.bndcsr = env->bndcs_regs;
+    memcpy(&xsave->intel.opmask_state.opmask_regs, env->opmask_regs,
             sizeof env->opmask_regs);
 
     for (i = 0; i < CPU_NB_REGS; i++) {
         uint8_t *xmm = xsave->legacy.xmm_regs[i];
         uint8_t *ymmh = xsave->avx_state.ymmh[i];
-        uint8_t *zmmh = xsave->zmm_hi256_state.zmm_hi256[i];
+        uint8_t *zmmh = xsave->intel.zmm_hi256_state.zmm_hi256[i];
         stq_p(xmm,     env->xmm_regs[i].ZMM_Q(0));
         stq_p(xmm+8,   env->xmm_regs[i].ZMM_Q(1));
         stq_p(ymmh,    env->xmm_regs[i].ZMM_Q(2));
@@ -52,9 +52,9 @@ void x86_cpu_xsave_all_areas(X86CPU *cpu, X86XSaveArea *buf)
     }
 
 #ifdef TARGET_X86_64
-    memcpy(&xsave->hi16_zmm_state.hi16_zmm, &env->xmm_regs[16],
+    memcpy(&xsave->intel.hi16_zmm_state.hi16_zmm, &env->xmm_regs[16],
             16 * sizeof env->xmm_regs[16]);
-    memcpy(&xsave->pkru_state, &env->pkru, sizeof env->pkru);
+    memcpy(&xsave->intel.pkru_state, &env->pkru, sizeof env->pkru);
 #endif
 
 }
@@ -83,16 +83,16 @@ void x86_cpu_xrstor_all_areas(X86CPU *cpu, const X86XSaveArea *buf)
     memcpy(env->fpregs, &xsave->legacy.fpregs,
             sizeof env->fpregs);
     env->xstate_bv = xsave->header.xstate_bv;
-    memcpy(env->bnd_regs, &xsave->bndreg_state.bnd_regs,
+    memcpy(env->bnd_regs, &xsave->intel.bndreg_state.bnd_regs,
             sizeof env->bnd_regs);
-    env->bndcs_regs = xsave->bndcsr_state.bndcsr;
-    memcpy(env->opmask_regs, &xsave->opmask_state.opmask_regs,
+    env->bndcs_regs = xsave->intel.bndcsr_state.bndcsr;
+    memcpy(env->opmask_regs, &xsave->intel.opmask_state.opmask_regs,
             sizeof env->opmask_regs);
 
     for (i = 0; i < CPU_NB_REGS; i++) {
         const uint8_t *xmm = xsave->legacy.xmm_regs[i];
         const uint8_t *ymmh = xsave->avx_state.ymmh[i];
-        const uint8_t *zmmh = xsave->zmm_hi256_state.zmm_hi256[i];
+        const uint8_t *zmmh = xsave->intel.zmm_hi256_state.zmm_hi256[i];
         env->xmm_regs[i].ZMM_Q(0) = ldq_p(xmm);
         env->xmm_regs[i].ZMM_Q(1) = ldq_p(xmm+8);
         env->xmm_regs[i].ZMM_Q(2) = ldq_p(ymmh);
@@ -104,9 +104,9 @@ void x86_cpu_xrstor_all_areas(X86CPU *cpu, const X86XSaveArea *buf)
     }
 
 #ifdef TARGET_X86_64
-    memcpy(&env->xmm_regs[16], &xsave->hi16_zmm_state.hi16_zmm,
+    memcpy(&env->xmm_regs[16], &xsave->intel.hi16_zmm_state.hi16_zmm,
            16 * sizeof env->xmm_regs[16]);
-    memcpy(&env->pkru, &xsave->pkru_state, sizeof env->pkru);
+    memcpy(&env->pkru, &xsave->intel.pkru_state, sizeof env->pkru);
 #endif
 
 }
-- 
2.30.2

