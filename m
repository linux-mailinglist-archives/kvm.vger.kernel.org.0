Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEB942E49B
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 01:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhJNXLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 19:11:50 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45642 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbhJNXLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 19:11:39 -0400
Message-ID: <20211014230739.241223689@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634252973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=yzWB5E4wnJvvvoyzC0APWr55A2ww99SfT84mV6LalVo=;
        b=WQ4jnPPcqxlCjfyrdXzypN7icKZH8Zm40c6vJOA11bNjIrl+ltECGtYgadMGmcmPvcNoYm
        oLdqMWmY9tuVqMg0ZfsGGoZZHmV8LNqFftThUhMqE79Oy1P4uVmV8uGMTAJj3tMvteT6rG
        bjJKuHhitB8umdM77aZ+fMczmfZCQWA4ejcQ2l0qP09/cKGQqUvZnQl1q7VIzzNiB43A/w
        2zZztOMgjSfUGGUgsG1/V519zfL11JyUp9OiCDmRkkBH4sPS6aEAm9KbFOX3xT922J7SRg
        wBI6NrHLTZpoGaaWmkIAg6HKZ37lEfFwFNhyx2SP6kllbzQH8hnuc0GzG88oSg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634252973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=yzWB5E4wnJvvvoyzC0APWr55A2ww99SfT84mV6LalVo=;
        b=DCy/2I8lYGn8n31xnIsai6T0H0N5iTnvpXMmwzcLKsEXE2F3IkSR3853+axXRpxg/54PS7
        p0oBVAagHv4WyABg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 3/8] x86/fpu/xstate: Cleanup size calculations
References: <20211014225711.615197738@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 01:09:32 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The size calculations are partially unreadable gunk. Clean them up.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/xstate.c |   82 ++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 36 deletions(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -527,7 +527,7 @@ static void __init __xstate_dump_leaves(
  * that our software representation matches what the CPU
  * tells us about the state's size.
  */
-static void __init check_xstate_against_struct(int nr)
+static bool __init check_xstate_against_struct(int nr)
 {
 	/*
 	 * Ask the CPU for the size of the state.
@@ -557,7 +557,9 @@ static void __init check_xstate_against_
 	    ((nr >= XFEATURE_RSRVD_COMP_11) && (nr <= XFEATURE_LBR))) {
 		WARN_ONCE(1, "no structure for xstate: %d\n", nr);
 		XSTATE_WARN_ON(1);
+		return false;
 	}
+	return true;
 }
 
 /*
@@ -569,38 +571,44 @@ static void __init check_xstate_against_
  * covered by these checks. Only the size of the buffer for task->fpu
  * is checked here.
  */
-static void __init do_extra_xstate_size_checks(void)
+static bool __init paranoid_xstate_size_valid(unsigned int kernel_size)
 {
-	int paranoid_xstate_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
+	bool compacted = cpu_feature_enabled(X86_FEATURE_XSAVES);
+	unsigned int size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
 	int i;
 
 	for_each_extended_xfeature(i, xfeatures_mask_all) {
-		check_xstate_against_struct(i);
+		if (!check_xstate_against_struct(i))
+			return false;
 		/*
 		 * Supervisor state components can be managed only by
 		 * XSAVES.
 		 */
-		if (!cpu_feature_enabled(X86_FEATURE_XSAVES))
-			XSTATE_WARN_ON(xfeature_is_supervisor(i));
+		if (!compacted && xfeature_is_supervisor(i)) {
+			XSTATE_WARN_ON(1);
+			return false;
+		}
 
 		/* Align from the end of the previous feature */
 		if (xfeature_is_aligned(i))
-			paranoid_xstate_size = ALIGN(paranoid_xstate_size, 64);
+			size = ALIGN(size, 64);
 		/*
-		 * The offset of a given state in the non-compacted
-		 * format is given to us in a CPUID leaf.  We check
-		 * them for being ordered (increasing offsets) in
-		 * setup_xstate_features(). XSAVES uses compacted format.
+		 * In compacted format the enabled features are packed,
+		 * i.e. disabled features do not occupy space.
+		 *
+		 * In non-compacted format the offsets are fixed and
+		 * disabled states still occupy space in the memory buffer.
 		 */
-		if (!cpu_feature_enabled(X86_FEATURE_XSAVES))
-			paranoid_xstate_size = xfeature_uncompacted_offset(i);
+		if (!compacted)
+			size = xfeature_uncompacted_offset(i);
 		/*
-		 * The compacted-format offset always depends on where
-		 * the previous state ended.
+		 * Add the feature size even for non-compacted format
+		 * to make the end result correct
 		 */
-		paranoid_xstate_size += xfeature_size(i);
+		size += xfeature_size(i);
 	}
-	XSTATE_WARN_ON(paranoid_xstate_size != fpu_kernel_xstate_size);
+	XSTATE_WARN_ON(size != kernel_size);
+	return size == kernel_size;
 }
 
 /*
@@ -653,7 +661,7 @@ static unsigned int __init get_xsaves_si
 	return size;
 }
 
-static unsigned int __init get_xsave_size(void)
+static unsigned int __init get_xsave_size_user(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 	/*
@@ -684,31 +692,33 @@ static bool __init is_supported_xstate_s
 static int __init init_xstate_size(void)
 {
 	/* Recompute the context size for enabled features: */
-	unsigned int possible_xstate_size;
-	unsigned int xsave_size;
+	unsigned int user_size, kernel_size;
 
-	xsave_size = get_xsave_size();
+	/* Uncompacted user space size */
+	user_size = get_xsave_size_user();
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		possible_xstate_size = get_xsaves_size_no_independent();
+	/*
+	 * XSAVES kernel size includes supervisor states and
+	 * uses compacted format.
+	 *
+	 * XSAVE does not support supervisor states so
+	 * kernel and user size is identical.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_XSAVES))
+		kernel_size = get_xsaves_size_no_independent();
 	else
-		possible_xstate_size = xsave_size;
+		kernel_size = user_size;
 
-	/* Ensure we have the space to store all enabled: */
-	if (!is_supported_xstate_size(possible_xstate_size))
+	/* Ensure we have the space to store all enabled features. */
+	if (!is_supported_xstate_size(kernel_size))
 		return -EINVAL;
 
-	/*
-	 * The size is OK, we are definitely going to use xsave,
-	 * make it known to the world that we need more space.
-	 */
-	fpu_kernel_xstate_size = possible_xstate_size;
-	do_extra_xstate_size_checks();
+	if (!paranoid_xstate_size_valid(kernel_size))
+		return -EINVAL;
+
+	fpu_kernel_xstate_size = kernel_size;
+	fpu_user_xstate_size = user_size;
 
-	/*
-	 * User space is always in standard format.
-	 */
-	fpu_user_xstate_size = xsave_size;
 	return 0;
 }
 

