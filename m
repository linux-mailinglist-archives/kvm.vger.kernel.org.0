Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1806C38D04
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 16:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbfFGO3g convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 7 Jun 2019 10:29:36 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:50189 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729080AbfFGO3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 10:29:35 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hZFro-00051M-7T; Fri, 07 Jun 2019 16:29:16 +0200
Date:   Fri, 7 Jun 2019 16:29:16 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Biggers <ebiggers@kernel.org>, x86-ml <x86@kernel.org>
Cc:     Borislav Petkov <bp@suse.de>, Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jann Horn <jannh@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        kvm ML <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/fpu: Update kernel's FPU state before using for the
 fsave header
Message-ID: <20190607142915.y52mfmgk5lvhll7n@linutronix.de>
References: <20190604185358.GA820@sol.localdomain>
 <20190605140405.2nnpqslnjpfe2ig2@linutronix.de>
 <20190605173256.GA86462@gmail.com>
 <20190606173026.ty7c4cvftrvfrwy3@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190606173026.ty7c4cvftrvfrwy3@linutronix.de>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In commit

  39388e80f9b0c ("x86/fpu: Don't save fxregs for ia32 frames in copy_fpstate_to_sigframe()")

I removed the statement
|       if (ia32_fxstate)
|               copy_fxregs_to_kernel(fpu);

and argued that is was wrongly merged because the content was already
saved in kernel's state and the content.
This was wrong: It is required to write it back because it is only saved
on the user-stack and save_fsave_header() reads it from task's
FPU-state. I missed that part…

Save x87 FPU state unless thread's FPU registers are already up to date.

Fixes: 39388e80f9b0c ("x86/fpu: Don't save fxregs for ia32 frames in copy_fpstate_to_sigframe()")
Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kernel/fpu/signal.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 060d6188b4533..0071b794ed193 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -62,6 +62,11 @@ static inline int save_fsave_header(struct task_struct *tsk, void __user *buf)
 		struct user_i387_ia32_struct env;
 		struct _fpstate_32 __user *fp = buf;
 
+		fpregs_lock();
+		if (!test_thread_flag(TIF_NEED_FPU_LOAD))
+			copy_fxregs_to_kernel(&tsk->thread.fpu);
+		fpregs_unlock();
+
 		convert_from_fxsr(&env, tsk);
 
 		if (__copy_to_user(buf, &env, sizeof(env)) ||
-- 
2.20.1

