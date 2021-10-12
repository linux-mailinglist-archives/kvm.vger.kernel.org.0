Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542A8429A09
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhJLAI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbhJLAIX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:23 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D018C06161C;
        Mon, 11 Oct 2021 17:06:22 -0700 (PDT)
Message-ID: <20211011223610.950054267@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=4EHKPcl4JlAkis6eUZZQUW/49IdenRLk1IEf79GkDUo=;
        b=enbtcQDhqeYiyz2Z/05myFc/NHMseN8qMYLy5yOCCpOqN52G8ISj1qOxeT9Il4+UaXeWKi
        XlKiikJiVvSWqLo1ctNjytPyUsVMHmn5rRhgj21e3qOAsM7KByXJAYmd9sLoD8V5OfC1h0
        jFI7m5ACjVwiV1F8EISv0i+jPEN+JWA8mMWYcfooGjuwqdy4XDCiJ25inzPAaliPZ4PdsT
        c3YDTEJkW62G3//if7bALwTxKebY31+Py1GOAq85Ut6L4ImLiaT/mbxraTfuXXIJ9cbDwv
        mA6i1efdWgrCZNWl6MdTLiZufI9JEmaJJfVLmSQdeiw+t+Fq9ehPQnlo2jTdig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=4EHKPcl4JlAkis6eUZZQUW/49IdenRLk1IEf79GkDUo=;
        b=lMnZZ8wHxx2R97Q0c0pAzokvQkIx3zsYmLLWcxBqJ/wY/5kmxfcZecJvOjPG3gj3atdSOU
        y/3QXBAImZc9DSBA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 11/31] x86/fpu/xstate: Provide and use for_each_xfeature()
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:14 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These loops evaluating xfeature bits are really hard to read. Create an
iterator and use for_each_set_bit_from() inside which already does the right
thing.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/xstate.c |   56 +++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 33 deletions(-)

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
@@ -184,10 +189,7 @@ static void __init setup_xstate_features
 	xstate_sizes[XFEATURE_SSE]	= sizeof_field(struct fxregs_state,
 						       xmm_space);
 
-	for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
-		if (!xfeature_enabled(i))
-			continue;
-
+	for_each_extended_xfeature(i, xfeatures_mask_all) {
 		cpuid_count(XSTATE_CPUID, i, &eax, &ebx, &ecx, &edx);
 
 		xstate_sizes[i] = eax;
@@ -291,20 +293,15 @@ static void __init setup_xstate_comp_off
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
 
@@ -328,8 +325,8 @@ static void __init setup_supervisor_only
 
 	next_offset = FXSAVE_SIZE + XSAVE_HDR_SIZE;
 
-	for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
-		if (!xfeature_enabled(i) || !xfeature_is_supervisor(i))
+	for_each_extended_xfeature(i, xfeatures_mask_all) {
+		if (!xfeature_is_supervisor(i))
 			continue;
 
 		if (xfeature_is_aligned(i))
@@ -347,9 +344,7 @@ static void __init print_xstate_offset_s
 {
 	int i;
 
-	for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
-		if (!xfeature_enabled(i))
-			continue;
+	for_each_extended_xfeature(i, xfeatures_mask_all) {
 		pr_info("x86/fpu: xstate_offset[%d]: %4d, xstate_sizes[%d]: %4d\n",
 			 i, xstate_comp_offsets[i], i, xstate_sizes[i]);
 	}
@@ -554,10 +549,7 @@ static void do_extra_xstate_size_checks(
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
@@ -586,7 +578,6 @@ static void do_extra_xstate_size_checks(
 	XSTATE_WARN_ON(paranoid_xstate_size != fpu_kernel_xstate_size);
 }
 
-
 /*
  * Get total size of enabled xstates in XCR0 | IA32_XSS.
  *
@@ -969,6 +960,7 @@ void copy_xstate_to_uabi_buf(struct memb
 	struct xregs_state *xinit = &init_fpstate.xsave;
 	struct xstate_header header;
 	unsigned int zerofrom;
+	u64 mask;
 	int i;
 
 	memset(&header, 0, sizeof(header));
@@ -1022,17 +1014,15 @@ void copy_xstate_to_uabi_buf(struct memb
 
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

