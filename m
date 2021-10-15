Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC94142E5DE
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhJOBS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46408 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbhJOBSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:16 -0400
Message-ID: <20211015011538.958107505@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=XXUejelorOMNKR3ap34rldZ7qd2OZMr2QmuOlk+A2D4=;
        b=BFrN+4JCDCbOhtdf1+IGbi9Mm/Gm5oN9UdBMIJP2KEJ/Jt3T2pFZ6I6FM1qIRa5lezUs64
        +hHk2XYjiHNmJT1GXUr+B2LXkc32eKMi6+IDOKc99HXUoKj0AnTcuM94tx+29HqodJw8a5
        1YLJseyfZlVbBYQlwgXUDFnqiEaILKyQrwROhE9bwXdmw06V1sM3YQG/LA9UolZEat52WC
        VePLh625I8UTjPb0rv1JFN96jJuq/h1GL/mLvSVjKaZFF17+WcBX3bHl8Ge8oD4z/HBW1q
        vLqAqBFBYwQ5074O9BVXA1yaR1nAKdsgNyRHD+BTWElKLHk+ONGCxp15g3MFtw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=XXUejelorOMNKR3ap34rldZ7qd2OZMr2QmuOlk+A2D4=;
        b=eYAFVa3kJuo/hMbF9eQ3EvpXXtxLKZtvX2YnD2N/W84AKOagRn/FdBX17bsyARqxj4bdZZ
        OZP1uDDBwTMLgUAw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 10/30] x86/fpu/xstate: Provide and use for_each_xfeature()
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:09 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These loops evaluating xfeature bits are really hard to read. Create an
iterator and use for_each_set_bit_from() inside which already does the right
thing.

No functional changes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V2: Update changelog - Boris
---
 arch/x86/kernel/fpu/xstate.c | 56 ++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 33 deletions(-)
---
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 259951d1eec5..a2bdc0cf8687 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -4,6 +4,7 @@
  *
  * Author: Suresh Siddha <suresh.b.siddha@intel.com>
  */
+#include <linux/bitops.h>
 #include <linux/compat.h>
 #include <linux/cpu.h>
 #include <linux/mman.h>
@@ -20,6 +21,10 @@
 
 #include "xstate.h"
 
+#define for_each_extended_xfeature(bit, mask)				\
+	(bit) = FIRST_EXTENDED_XFEATURE;				\
+	for_each_set_bit_from(bit, (unsigned long *)&(mask), 8 * sizeof(mask))
+
 /*
  * Although we spell it out in here, the Processor Trace
  * xfeature is completely unused.  We use other mechanisms
@@ -184,10 +189,7 @@ static void __init setup_xstate_features(void)
 	xstate_sizes[XFEATURE_SSE]	= sizeof_field(struct fxregs_state,
 						       xmm_space);
 
-	for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
-		if (!xfeature_enabled(i))
-			continue;
-
+	for_each_extended_xfeature(i, xfeatures_mask_all) {
 		cpuid_count(XSTATE_CPUID, i, &eax, &ebx, &ecx, &edx);
 
 		xstate_sizes[i] = eax;
@@ -291,20 +293,15 @@ static void __init setup_xstate_comp_offsets(void)
 	xstate_comp_offsets[XFEATURE_SSE] = offsetof(struct fxregs_state,
 						     xmm_space);
 
-	if (!boot_cpu_has(X86_FEATURE_XSAVES)) {
-		for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
-			if (xfeature_enabled(i))
-				xstate_comp_offsets[i] = xstate_offsets[i];
-		}
+	if (!cpu_feature_enabled(X86_FEATURE_XSAVES)) {
+		for_each_extended_xfeature(i, xfeatures_mask_all)
+			xstate_comp_offsets[i] = xstate_offsets[i];
 		return;
 	}
 
 	next_offset = FXSAVE_SIZE + XSAVE_HDR_SIZE;
 
-	for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
-		if (!xfeature_enabled(i))
-			continue;
-
+	for_each_extended_xfeature(i, xfeatures_mask_all) {
 		if (xfeature_is_aligned(i))
 			next_offset = ALIGN(next_offset, 64);
 
@@ -328,8 +325,8 @@ static void __init setup_supervisor_only_offsets(void)
 
 	next_offset = FXSAVE_SIZE + XSAVE_HDR_SIZE;
 
-	for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
-		if (!xfeature_enabled(i) || !xfeature_is_supervisor(i))
+	for_each_extended_xfeature(i, xfeatures_mask_all) {
+		if (!xfeature_is_supervisor(i))
 			continue;
 
 		if (xfeature_is_aligned(i))
@@ -347,9 +344,7 @@ static void __init print_xstate_offset_size(void)
 {
 	int i;
 
-	for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
-		if (!xfeature_enabled(i))
-			continue;
+	for_each_extended_xfeature(i, xfeatures_mask_all) {
 		pr_info("x86/fpu: xstate_offset[%d]: %4d, xstate_sizes[%d]: %4d\n",
 			 i, xstate_comp_offsets[i], i, xstate_sizes[i]);
 	}
@@ -554,10 +549,7 @@ static void do_extra_xstate_size_checks(void)
 	int paranoid_xstate_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
 	int i;
 
-	for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
-		if (!xfeature_enabled(i))
-			continue;
-
+	for_each_extended_xfeature(i, xfeatures_mask_all) {
 		check_xstate_against_struct(i);
 		/*
 		 * Supervisor state components can be managed only by
@@ -586,7 +578,6 @@ static void do_extra_xstate_size_checks(void)
 	XSTATE_WARN_ON(paranoid_xstate_size != fpu_kernel_xstate_size);
 }
 
-
 /*
  * Get total size of enabled xstates in XCR0 | IA32_XSS.
  *
@@ -969,6 +960,7 @@ void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 	struct xregs_state *xinit = &init_fpstate.xsave;
 	struct xstate_header header;
 	unsigned int zerofrom;
+	u64 mask;
 	int i;
 
 	memset(&header, 0, sizeof(header));
@@ -1022,17 +1014,15 @@ void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 
 	zerofrom = offsetof(struct xregs_state, extended_state_area);
 
-	for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
-		/*
-		 * The ptrace buffer is in non-compacted XSAVE format.
-		 * In non-compacted format disabled features still occupy
-		 * state space, but there is no state to copy from in the
-		 * compacted init_fpstate. The gap tracking will zero this
-		 * later.
-		 */
-		if (!(xfeatures_mask_uabi() & BIT_ULL(i)))
-			continue;
+	/*
+	 * The ptrace buffer is in non-compacted XSAVE format.  In
+	 * non-compacted format disabled features still occupy state space,
+	 * but there is no state to copy from in the compacted
+	 * init_fpstate. The gap tracking will zero these states.
+	 */
+	mask = xfeatures_mask_uabi();
 
+	for_each_extended_xfeature(i, mask) {
 		/*
 		 * If there was a feature or alignment gap, zero the space
 		 * in the destination buffer.

