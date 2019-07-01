Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71655F20C
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 10:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfD3Ibg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 04:31:36 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:45787 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbfD3Ibf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 04:31:35 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hLOAg-0007ho-Kj; Tue, 30 Apr 2019 10:31:26 +0200
Date:   Tue, 30 Apr 2019 10:31:26 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-kernel@vger.kernel.org
Cc:     x86@kernel.org, jannh@google.com, riel@surriel.com,
        mingo@redhat.com, bp@suse.de, Jason@zx2c4.com, luto@kernel.org,
        tglx@linutronix.de, rkrcmar@redhat.com, mingo@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, pbonzini@redhat.com,
        kurt.kanzenbach@linutronix.de, Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH] x86/fpu: Remove unneeded saving of FPU registers in
 copy_fpstate_to_sigframe()
Message-ID: <20190430083126.rilbb76yc27vrem5@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit

  eeec00d73be2e ("x86/fpu: Fault-in user stack if copy_fpstate_to_sigframe() fails")

there is no need to have FPU registers saved if
copy_fpregs_to_sigframe() fails because we retry it after we resolved
the fault condition.
Saving the registers is not wrong but it is not needed and it forces us
to load the FPU registers on the retry attempt.

Don't save the FPU registers if copy_fpstate_to_sigframe() fails.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kernel/fpu/signal.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 9834ff8b570b7..eaddb185cac95 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -134,10 +134,9 @@ static inline int copy_fpregs_to_sigframe(struct xregs_state __user *buf)
  */
 int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 {
-	struct fpu *fpu = &current->thread.fpu;
 	struct task_struct *tsk = current;
 	int ia32_fxstate = (buf != buf_fx);
-	int ret = -EFAULT;
+	int ret;
 
 	ia32_fxstate &= (IS_ENABLED(CONFIG_X86_32) ||
 			 IS_ENABLED(CONFIG_IA32_EMULATION));
@@ -164,9 +163,6 @@ int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 	pagefault_disable();
 	ret = copy_fpregs_to_sigframe(buf_fx);
 	pagefault_enable();
-	if (ret && !test_thread_flag(TIF_NEED_FPU_LOAD))
-		copy_fpregs_to_fpstate(fpu);
-	set_thread_flag(TIF_NEED_FPU_LOAD);
 	fpregs_unlock();
 
 	if (ret) {
-- 
2.20.1

