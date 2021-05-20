Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2664E38B26D
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 17:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242771AbhETPET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 11:04:19 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:60157 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239730AbhETPEG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 11:04:06 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id ED3A01940A11;
        Thu, 20 May 2021 10:56:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 20 May 2021 10:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=srBFxlNijYMaSZLP7fEUIq/DXI6Tc+YZQbo62f99oLo=; b=LusbZ505
        8Nc5/n0P0S9KSPi1XxuCyHxshsUv1AAPbOW8h0+vY9E8AaJVfaucK1t5c8cgEM9/
        wAYFinyNgulp1Tt86WcpBgDmlHR0K8CPZBYhYgl+OzXOX7+RjfH18TySZid7r4pj
        59GO4KeJneJ8AoQyoWsVQEmWJpqi1N4cNHoR4uXV66a7gzwAH7inxK5XPK0oFCLY
        G25katQRGHR7+P0VnAW8lWXPxz7ziJaepcMsANMcMpO7A9rQ7sBFsqfxVifUIBz+
        NVEs4jHl3lra9TjhpH1hDChIY1LDwGAprtFCrvn01yT8STus6weROUPwP9FqPCZQ
        xNywFtsgKAbdCg==
X-ME-Sender: <xms:tnimYJ9NM_gna762UaPthw7LMWM0-ZeklP1XpUWvjxMJAsv6ighS-A>
    <xme:tnimYNsCH35RMHY-6GRS91m5cNbbpOpMcwx6iTtsMjES3PAvOEi1jCdPY0y-5I0a4
    7hMJVYSgPWw3Mxyhew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:tnimYHBRCROxca0Xx53fk9IPOZ8mNuriIFT_oVINeKJfd63oLq4X2w>
    <xmx:tnimYNe4RfLpxWJh9mC_9eA-kOt692aU6nZaRTC8dwl7eUTnkKSqCQ>
    <xmx:tnimYOOhOODXnKaEVx7IJqK4HRyZNI0KHRAOoiLKMyJmRCLQy17Dpw>
    <xmx:tnimYIuupIiClUrNGjaxUedpx67FBY__v8SN4e84lJIMHV1WKZfZOg>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 20 May 2021 10:56:53 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id d2f501d0;
        Thu, 20 May 2021 14:56:48 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Babu Moger <babu.moger@amd.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [RFC PATCH 7/7] target/i386: Manipulate only AMD XSAVE state on AMD
Date:   Thu, 20 May 2021 15:56:47 +0100
Message-Id: <20210520145647.3483809-8-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210520145647.3483809-1-david.edmondson@oracle.com>
References: <20210520145647.3483809-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On AMD CPUs, ensure to save/load only the relevant XSAVE state.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 target/i386/tcg/fpu_helper.c | 12 +++++--
 target/i386/xsave_helper.c   | 70 ++++++++++++++++++++++--------------
 2 files changed, 54 insertions(+), 28 deletions(-)

diff --git a/target/i386/tcg/fpu_helper.c b/target/i386/tcg/fpu_helper.c
index fba2de5b04..f1d4704b34 100644
--- a/target/i386/tcg/fpu_helper.c
+++ b/target/i386/tcg/fpu_helper.c
@@ -2643,7 +2643,11 @@ static void do_xsave(CPUX86State *env, target_ulong ptr, uint64_t rfbm,
         do_xsave_bndcsr(env, ptr + XO(intel.bndcsr_state), ra);
     }
     if (opt & XSTATE_PKRU_MASK) {
-        do_xsave_pkru(env, ptr + XO(intel.pkru_state), ra);
+        if (IS_AMD_CPU(env)) {
+            do_xsave_pkru(env, ptr + XO(amd.pkru_state), ra);
+        } else {
+            do_xsave_pkru(env, ptr + XO(intel.pkru_state), ra);
+        }
     }
 
     /* Update the XSTATE_BV field.  */
@@ -2854,7 +2858,11 @@ void helper_xrstor(CPUX86State *env, target_ulong ptr, uint64_t rfbm)
     if (rfbm & XSTATE_PKRU_MASK) {
         uint64_t old_pkru = env->pkru;
         if (xstate_bv & XSTATE_PKRU_MASK) {
-            do_xrstor_pkru(env, ptr + XO(intel.pkru_state), ra);
+            if (IS_AMD_CPU(env)) {
+                do_xrstor_pkru(env, ptr + XO(amd.pkru_state), ra);
+            } else {
+                do_xrstor_pkru(env, ptr + XO(intel.pkru_state), ra);
+            }
         } else {
             env->pkru = 0;
         }
diff --git a/target/i386/xsave_helper.c b/target/i386/xsave_helper.c
index 97dbab85d1..6b4501cf29 100644
--- a/target/i386/xsave_helper.c
+++ b/target/i386/xsave_helper.c
@@ -10,6 +10,7 @@ void x86_cpu_xsave_all_areas(X86CPU *cpu, X86XSaveArea *buf)
 {
     CPUX86State *env = &cpu->env;
     X86XSaveArea *xsave = buf;
+    const bool is_amd = IS_AMD_CPU(env);
 
     uint16_t cwd, swd, twd;
     int i;
@@ -31,30 +32,38 @@ void x86_cpu_xsave_all_areas(X86CPU *cpu, X86XSaveArea *buf)
             sizeof env->fpregs);
     xsave->legacy.mxcsr = env->mxcsr;
     xsave->header.xstate_bv = env->xstate_bv;
-    memcpy(&xsave->intel.bndreg_state.bnd_regs, env->bnd_regs,
-            sizeof env->bnd_regs);
-    xsave->intel.bndcsr_state.bndcsr = env->bndcs_regs;
-    memcpy(&xsave->intel.opmask_state.opmask_regs, env->opmask_regs,
-            sizeof env->opmask_regs);
+    if (!is_amd) {
+        memcpy(&xsave->intel.bndreg_state.bnd_regs, env->bnd_regs,
+               sizeof env->bnd_regs);
+        xsave->intel.bndcsr_state.bndcsr = env->bndcs_regs;
+        memcpy(&xsave->intel.opmask_state.opmask_regs, env->opmask_regs,
+               sizeof env->opmask_regs);
+    }
 
     for (i = 0; i < CPU_NB_REGS; i++) {
         uint8_t *xmm = xsave->legacy.xmm_regs[i];
         uint8_t *ymmh = xsave->avx_state.ymmh[i];
-        uint8_t *zmmh = xsave->intel.zmm_hi256_state.zmm_hi256[i];
         stq_p(xmm,     env->xmm_regs[i].ZMM_Q(0));
         stq_p(xmm+8,   env->xmm_regs[i].ZMM_Q(1));
         stq_p(ymmh,    env->xmm_regs[i].ZMM_Q(2));
         stq_p(ymmh+8,  env->xmm_regs[i].ZMM_Q(3));
-        stq_p(zmmh,    env->xmm_regs[i].ZMM_Q(4));
-        stq_p(zmmh+8,  env->xmm_regs[i].ZMM_Q(5));
-        stq_p(zmmh+16, env->xmm_regs[i].ZMM_Q(6));
-        stq_p(zmmh+24, env->xmm_regs[i].ZMM_Q(7));
+        if (!is_amd) {
+            uint8_t *zmmh = xsave->intel.zmm_hi256_state.zmm_hi256[i];
+            stq_p(zmmh,    env->xmm_regs[i].ZMM_Q(4));
+            stq_p(zmmh+8,  env->xmm_regs[i].ZMM_Q(5));
+            stq_p(zmmh+16, env->xmm_regs[i].ZMM_Q(6));
+            stq_p(zmmh+24, env->xmm_regs[i].ZMM_Q(7));
+        }
     }
 
 #ifdef TARGET_X86_64
-    memcpy(&xsave->intel.hi16_zmm_state.hi16_zmm, &env->xmm_regs[16],
-            16 * sizeof env->xmm_regs[16]);
-    memcpy(&xsave->intel.pkru_state, &env->pkru, sizeof env->pkru);
+    if (is_amd) {
+        memcpy(&xsave->amd.pkru_state, &env->pkru, sizeof env->pkru);
+    } else {
+        memcpy(&xsave->intel.hi16_zmm_state.hi16_zmm, &env->xmm_regs[16],
+               16 * sizeof env->xmm_regs[16]);
+        memcpy(&xsave->intel.pkru_state, &env->pkru, sizeof env->pkru);
+    }
 #endif
 
 }
@@ -64,6 +73,7 @@ void x86_cpu_xrstor_all_areas(X86CPU *cpu, const X86XSaveArea *buf)
 
     CPUX86State *env = &cpu->env;
     const X86XSaveArea *xsave = buf;
+    const bool is_amd = IS_AMD_CPU(env);
 
     int i;
     uint16_t cwd, swd, twd;
@@ -83,30 +93,38 @@ void x86_cpu_xrstor_all_areas(X86CPU *cpu, const X86XSaveArea *buf)
     memcpy(env->fpregs, &xsave->legacy.fpregs,
             sizeof env->fpregs);
     env->xstate_bv = xsave->header.xstate_bv;
-    memcpy(env->bnd_regs, &xsave->intel.bndreg_state.bnd_regs,
-            sizeof env->bnd_regs);
-    env->bndcs_regs = xsave->intel.bndcsr_state.bndcsr;
-    memcpy(env->opmask_regs, &xsave->intel.opmask_state.opmask_regs,
-            sizeof env->opmask_regs);
+    if (!is_amd) {
+        memcpy(env->bnd_regs, &xsave->intel.bndreg_state.bnd_regs,
+               sizeof env->bnd_regs);
+        env->bndcs_regs = xsave->intel.bndcsr_state.bndcsr;
+        memcpy(env->opmask_regs, &xsave->intel.opmask_state.opmask_regs,
+               sizeof env->opmask_regs);
+    }
 
     for (i = 0; i < CPU_NB_REGS; i++) {
         const uint8_t *xmm = xsave->legacy.xmm_regs[i];
         const uint8_t *ymmh = xsave->avx_state.ymmh[i];
-        const uint8_t *zmmh = xsave->intel.zmm_hi256_state.zmm_hi256[i];
         env->xmm_regs[i].ZMM_Q(0) = ldq_p(xmm);
         env->xmm_regs[i].ZMM_Q(1) = ldq_p(xmm+8);
         env->xmm_regs[i].ZMM_Q(2) = ldq_p(ymmh);
         env->xmm_regs[i].ZMM_Q(3) = ldq_p(ymmh+8);
-        env->xmm_regs[i].ZMM_Q(4) = ldq_p(zmmh);
-        env->xmm_regs[i].ZMM_Q(5) = ldq_p(zmmh+8);
-        env->xmm_regs[i].ZMM_Q(6) = ldq_p(zmmh+16);
-        env->xmm_regs[i].ZMM_Q(7) = ldq_p(zmmh+24);
+        if (!is_amd) {
+            const uint8_t *zmmh = xsave->intel.zmm_hi256_state.zmm_hi256[i];
+            env->xmm_regs[i].ZMM_Q(4) = ldq_p(zmmh);
+            env->xmm_regs[i].ZMM_Q(5) = ldq_p(zmmh+8);
+            env->xmm_regs[i].ZMM_Q(6) = ldq_p(zmmh+16);
+            env->xmm_regs[i].ZMM_Q(7) = ldq_p(zmmh+24);
+        }
     }
 
 #ifdef TARGET_X86_64
-    memcpy(&env->xmm_regs[16], &xsave->intel.hi16_zmm_state.hi16_zmm,
-           16 * sizeof env->xmm_regs[16]);
-    memcpy(&env->pkru, &xsave->intel.pkru_state, sizeof env->pkru);
+    if (is_amd) {
+        memcpy(&env->pkru, &xsave->amd.pkru_state, sizeof env->pkru);
+    } else {
+        memcpy(&env->xmm_regs[16], &xsave->intel.hi16_zmm_state.hi16_zmm,
+               16 * sizeof env->xmm_regs[16]);
+        memcpy(&env->pkru, &xsave->intel.pkru_state, sizeof env->pkru);
+    }
 #endif
 
 }
-- 
2.30.2

