Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B717DE7EF
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 18:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfD2QkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 12:40:12 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:42718 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbfD2QkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 12:40:12 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hL9Jq-0000dZ-2l; Mon, 29 Apr 2019 18:39:54 +0200
Date:   Mon, 29 Apr 2019 18:39:53 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, jannh@google.com,
        riel@surriel.com, mingo@redhat.com, bp@suse.de, Jason@zx2c4.com,
        luto@kernel.org, tglx@linutronix.de, rkrcmar@redhat.com,
        mingo@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        pbonzini@redhat.com, kurt.kanzenbach@linutronix.de
Subject: [PATCH] x86/fpu: Fault-in user stack if copy_fpstate_to_sigframe()
 fails
Message-ID: <20190429163953.gqxgsc5okqxp4olv@linutronix.de>
References: <20190425173545.sogxyptbaqvoofm6@linutronix.de>
 <cbb4c3de-1e12-c325-fa7f-40bc63c495e7@intel.com>
 <20190426072659.swew4mvfz7dfjyqq@linutronix.de>
 <89ed2d26-a73c-99ad-76d8-e4b46755c783@intel.com>
 <20190426165013.mdgd2ocmdgkhja7n@linutronix.de>
 <76afd2e7-40fb-15a4-d183-22e4b50de43d@intel.com>
 <20190426200509.3q5ngl44o64q2lg2@linutronix.de>
 <87871e60-4e64-2355-11b4-6201cab8bf75@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87871e60-4e64-2355-11b4-6201cab8bf75@intel.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the compacted form, the XSAVES may save only XMM+SSE but skip FP.
This is denoted by header->xfeatures = 6. The fastpath
(copy_fpregs_to_sigframe()) does that but _also_ initialises the FP
state (cwd to 0x37f, mxcsr as we do, remaining fields to 0).
The slowpath (copy_xstate_to_user()) leaves most of the FP untouched.
Only mxcsr and mxcsr_flags are set due to xfeatures_mxcsr_quirk().
Now that XFEATURE_MASK_FP is set unconditionally we load on return from
signal random garbage as the FP state.

Instead of utilizing copy_xstate_to_user() fault-in the user memory and
retry the fast path. Ideally the fast path succeeds on the second
attempt but may be retried again if the memory is swapped out due to
memory pressure. If the user memory can not be faulted-in then
get_user_pages() returns an error so we don't loop forever.

Fault in memory via get_user_pages() so copy_fpregs_to_sigframe()
succeeds without a fault.

Reported-by: Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Fixes: 69277c98f5eef ("x86/fpu: Always store the registers in copy_fpstate_to_sigframe()")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kernel/fpu/signal.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 7026f1c4e5e30..6d6c2d6afde42 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -158,7 +158,6 @@ static inline int copy_fpregs_to_sigframe(struct xregs_state __user *buf)
 int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 {
 	struct fpu *fpu = &current->thread.fpu;
-	struct xregs_state *xsave = &fpu->state.xsave;
 	struct task_struct *tsk = current;
 	int ia32_fxstate = (buf != buf_fx);
 	int ret = -EFAULT;
@@ -174,11 +173,12 @@ int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 			sizeof(struct user_i387_ia32_struct), NULL,
 			(struct _fpstate_32 __user *) buf) ? -1 : 1;
 
+retry:
 	/*
 	 * Load the FPU registers if they are not valid for the current task.
 	 * With a valid FPU state we can attempt to save the state directly to
-	 * userland's stack frame which will likely succeed. If it does not, do
-	 * the slowpath.
+	 * userland's stack frame which will likely succeed. If it does not,
+	 * resolve the fault in the user memory and try again.
 	 */
 	fpregs_lock();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
@@ -193,14 +193,17 @@ int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 	fpregs_unlock();
 
 	if (ret) {
-		if (using_compacted_format()) {
-			if (copy_xstate_to_user(buf_fx, xsave, 0, size))
-				return -1;
-		} else {
-			fpstate_sanitize_xstate(fpu);
-			if (__copy_to_user(buf_fx, xsave, fpu_user_xstate_size))
-				return -1;
-		}
+		int aligned_size;
+		int nr_pages;
+
+		aligned_size = offset_in_page(buf_fx) + fpu_user_xstate_size;
+		nr_pages = DIV_ROUND_UP(aligned_size, PAGE_SIZE);
+
+		ret = get_user_pages((unsigned long)buf_fx, nr_pages,
+				     FOLL_WRITE, NULL, NULL);
+		if (ret == nr_pages)
+			goto retry;
+		return -EFAULT;
 	}
 
 	/* Save the fsave header for the 32-bit frames. */
-- 
2.20.1

