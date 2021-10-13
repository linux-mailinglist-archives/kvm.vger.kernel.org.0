Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B52742C439
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbhJMO6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:58:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35462 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238334AbhJMO6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:58:01 -0400
Message-ID: <20211013145323.285696382@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=1C1rPf7NVgZwm5o/B8NVWJ5bZQaS4NDUuXblws5cGwI=;
        b=XeyxWzpHFDA/b/D67cS7bRkWvUMmTjWBvMb/xZnANmZkbvV9f+ouwfIPQ2MYHbKCNXhU8J
        pZg3H0QdNHLMJHjAcSdQ2teC5Bebb5sX5qgnjeTEeV3JkexpD0Qf1ttux2ej9a1P/TaXFh
        8q5Y0ZGGsgQioSUDnebplK6eBljV8hfDey7506Rn/CEk6FU7iTI2ERFRnsvRuy6AR1Bqr4
        EjlaYhu96f52cvJy0I7cXCe03PWNZNZEw1Qt7GyZA9MVdSVKR9vjthfY2iPOeefOTwJgsW
        jqTeebKyxTQmvbWYh/j8khisRqD6x8uuCJD10O5Jxz4VQ1omQL5qLa4jyavIVQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=1C1rPf7NVgZwm5o/B8NVWJ5bZQaS4NDUuXblws5cGwI=;
        b=5kar4zVy3b4jB631a4qzi5gxpLOb5cTnhqB9perPNiQEQ+a5h5A2BhK3qUXtNZ0xQkDIdB
        OkYXpQtixoF/9JDQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 21/21] x86/fpu/signal: Use fpstate for size and features
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:57 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For dynamically enabled features it's required to get the features which
are enabled for that context when restoring from sigframe.

The same applies for all signal frame size calculations.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/signal.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -41,7 +41,7 @@ static inline bool check_xstate_in_sigfr
 	/* Check for the first magic field and other error scenarios. */
 	if (fx_sw->magic1 != FP_XSTATE_MAGIC1 ||
 	    fx_sw->xstate_size < min_xstate_size ||
-	    fx_sw->xstate_size > fpu_user_xstate_size ||
+	    fx_sw->xstate_size > current->thread.fpu.fpstate->user_size ||
 	    fx_sw->xstate_size > fx_sw->extended_size)
 		goto setfx;
 
@@ -230,11 +230,11 @@ bool copy_fpstate_to_sigframe(void __use
 	return true;
 }
 
-static int __restore_fpregs_from_user(void __user *buf, u64 xrestore,
-				      bool fx_only)
+static int __restore_fpregs_from_user(void __user *buf, u64 ufeatures,
+				      u64 xrestore, bool fx_only)
 {
 	if (use_xsave()) {
-		u64 init_bv = xfeatures_mask_uabi() & ~xrestore;
+		u64 init_bv = ufeatures & ~xrestore;
 		int ret;
 
 		if (likely(!fx_only))
@@ -265,7 +265,8 @@ static bool restore_fpregs_from_user(voi
 retry:
 	fpregs_lock();
 	pagefault_disable();
-	ret = __restore_fpregs_from_user(buf, xrestore, fx_only);
+	ret = __restore_fpregs_from_user(buf, fpu->fpstate->user_xfeatures,
+					 xrestore, fx_only);
 	pagefault_enable();
 
 	if (unlikely(ret)) {
@@ -425,10 +426,11 @@ static bool __fpu_restore_sig(void __use
 	return success;
 }
 
-static inline int xstate_sigframe_size(void)
+static inline unsigned int xstate_sigframe_size(struct fpstate *fpstate)
 {
-	return use_xsave() ? fpu_user_xstate_size + FP_XSTATE_MAGIC2_SIZE :
-			fpu_user_xstate_size;
+	unsigned int size = fpstate->user_size;
+
+	return use_xsave() ? size + FP_XSTATE_MAGIC2_SIZE : size;
 }
 
 /*
@@ -436,17 +438,19 @@ static inline int xstate_sigframe_size(v
  */
 bool fpu__restore_sig(void __user *buf, int ia32_frame)
 {
-	unsigned int size = xstate_sigframe_size();
 	struct fpu *fpu = &current->thread.fpu;
 	void __user *buf_fx = buf;
 	bool ia32_fxstate = false;
 	bool success = false;
+	unsigned int size;
 
 	if (unlikely(!buf)) {
 		fpu__clear_user_states(fpu);
 		return true;
 	}
 
+	size = xstate_sigframe_size(fpu->fpstate);
+
 	ia32_frame &= (IS_ENABLED(CONFIG_X86_32) ||
 		       IS_ENABLED(CONFIG_IA32_EMULATION));
 
@@ -481,7 +485,7 @@ unsigned long
 fpu__alloc_mathframe(unsigned long sp, int ia32_frame,
 		     unsigned long *buf_fx, unsigned long *size)
 {
-	unsigned long frame_size = xstate_sigframe_size();
+	unsigned long frame_size = xstate_sigframe_size(current->thread.fpu.fpstate);
 
 	*buf_fx = sp = round_down(sp - frame_size, 64);
 	if (ia32_frame && use_fxsr()) {
@@ -494,9 +498,12 @@ fpu__alloc_mathframe(unsigned long sp, i
 	return sp;
 }
 
-unsigned long fpu__get_fpstate_size(void)
+unsigned long __init fpu__get_fpstate_size(void)
 {
-	unsigned long ret = xstate_sigframe_size();
+	unsigned long ret = fpu_user_xstate_size;
+
+	if (use_xsave())
+		ret += FP_XSTATE_MAGIC2_SIZE;
 
 	/*
 	 * This space is needed on (most) 32-bit kernels, or when a 32-bit

