Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A234442C431
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238590AbhJMO6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:58:13 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35424 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237413AbhJMO5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:52 -0400
Message-ID: <20211013145322.973518954@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=0Q+9WUCgebhBn6q9AbgpLS1YKzFFGoHVdAWxJSIgEHM=;
        b=zDplXaNvJYF/IEJmvHvQwnvYSfHZgzZ3KgWeSp7JoFFUGGKKmRy29fQgM8MRI0Pk7mKKq6
        kJKTzfqL184zKng6zcMpD1UPnmOwPexndBgNuh7fGYyhUZzxEWaVH6VrqZlAkcNBJoC5jD
        dLE4+gsW+j8ZOPj4Vim75pGLc4hLZaXywYYkmdvBeegkCZg4EH0+wpa4oMopcBoeq+CAJ4
        k/5uQfGFcAe4kgSKkdS3nHa+FIvZN/CGh2HljpgqdzHoT6B5ROIw6N/lN1QTPwxaJ4iQ9+
        1PRAUI0hsLCR4sRFp+ysEZD3WPvn/73ys20+RMIu2MzWQPEYwExIW1vhOfncPQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=0Q+9WUCgebhBn6q9AbgpLS1YKzFFGoHVdAWxJSIgEHM=;
        b=UODfQDhDAiVFz5uXhUpQ+rdAXzapQdjqAKZGmyuiNTs18pf3c8n4o+6NoE+iBcI2KLLFr+
        cR0AhvQO8eUWezAg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 15/21] x86/fpu: Use fpstate::size
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:48 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make use of fpstate::size in various places which require the buffer size
information for sanity checks or memcpy() sizing.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/core.c   |   13 ++++++-------
 arch/x86/kernel/fpu/signal.c |    7 +++----
 2 files changed, 9 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -166,13 +166,12 @@ void fpu_swap_kvm_fpu(struct fpu *save,
 	fpregs_lock();
 
 	if (save) {
-		if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
-			memcpy(&save->fpstate->regs,
-			       &current->thread.fpu.fpstate->regs,
-			       fpu_kernel_xstate_size);
-		} else {
+		struct fpstate *fpcur = current->thread.fpu.fpstate;
+
+		if (test_thread_flag(TIF_NEED_FPU_LOAD))
+			memcpy(&save->fpstate->regs, &fpcur->regs, fpcur->size);
+		else
 			save_fpregs_to_fpstate(save);
-		}
 	}
 
 	if (rstor) {
@@ -398,7 +397,7 @@ int fpu_clone(struct task_struct *dst)
 	fpregs_lock();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
 		memcpy(&dst_fpu->fpstate->regs, &src_fpu->fpstate->regs,
-		       fpu_kernel_xstate_size);
+		       dst_fpu->fpstate->size);
 	} else {
 		save_fpregs_to_fpstate(dst_fpu);
 	}
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -313,15 +313,13 @@ static bool restore_fpregs_from_user(voi
 static bool __fpu_restore_sig(void __user *buf, void __user *buf_fx,
 			      bool ia32_fxstate)
 {
-	int state_size = fpu_kernel_xstate_size;
 	struct task_struct *tsk = current;
 	struct fpu *fpu = &tsk->thread.fpu;
 	struct user_i387_ia32_struct env;
+	bool success, fx_only = false;
 	union fpregs_state *fpregs;
+	unsigned int state_size;
 	u64 user_xfeatures = 0;
-	bool fx_only = false;
-	bool success;
-
 
 	if (use_xsave()) {
 		struct _fpx_sw_bytes fx_sw_user;
@@ -334,6 +332,7 @@ static bool __fpu_restore_sig(void __use
 		user_xfeatures = fx_sw_user.xfeatures;
 	} else {
 		user_xfeatures = XFEATURE_MASK_FPSSE;
+		state_size = fpu->fpstate->size;
 	}
 
 	if (likely(!ia32_fxstate)) {

