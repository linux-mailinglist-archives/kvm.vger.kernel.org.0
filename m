Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C50337B16
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 19:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbfFFRbA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 6 Jun 2019 13:31:00 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:47542 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfFFRbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 13:31:00 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hYwDn-0003iG-8I; Thu, 06 Jun 2019 19:30:39 +0200
Date:   Thu, 6 Jun 2019 19:30:39 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Borislav Petkov <bp@suse.de>, Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jann Horn <jannh@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        kvm ML <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Rik van Riel <riel@surriel.com>, x86-ml <x86@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [5.2 regression] copy_fpstate_to_sigframe() change causing crash
 in 32-bit process
Message-ID: <20190606173026.ty7c4cvftrvfrwy3@linutronix.de>
References: <20190604185358.GA820@sol.localdomain>
 <20190605140405.2nnpqslnjpfe2ig2@linutronix.de>
 <20190605173256.GA86462@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190605173256.GA86462@gmail.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-06-05 10:32:57 [-0700], Eric Biggers wrote:
> As I said, the commit looks broken to me.  save_fsave_header() reads from
> tsk->thread.fpu.state.fxsave, which due to that commit isn't being updated with
> the latest registers.  Am I missing something?  Note the comment you deleted:

So if your system uses fxsr() then that function shouldn't matter. If
your system uses xsave() (which I believe it does) then the first
section is the "fxregs state" which is the same as in fxsr's case (see
struct xregs_state). So it shouldn't make a difference and that is why I
strongly assumed it is a miss-merge. However it makes a difference…

So the hunk at the end should make things work again (my FPU test case
passes). I don't know why we convert things forth and back in the signal
handler but I think something here is different for xsave's legacy area
vs fxsave.

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 060d6188b4533..c653c9920c5e0 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -62,16 +62,7 @@ static inline int save_fsave_header(struct task_struct *tsk, void __user *buf)
 		struct user_i387_ia32_struct env;
 		struct _fpstate_32 __user *fp = buf;
 
-		convert_from_fxsr(&env, tsk);
-
-		if (__copy_to_user(buf, &env, sizeof(env)) ||
-		    __put_user(xsave->i387.swd, &fp->status) ||
-		    __put_user(X86_FXSR_MAGIC, &fp->magic))
-			return -1;
-	} else {
-		struct fregs_state __user *fp = buf;
-		u32 swd;
-		if (__get_user(swd, &fp->swd) || __put_user(swd, &fp->status))
+		if (__put_user(X86_FXSR_MAGIC, &fp->magic))
 			return -1;
 	}
 
@@ -236,9 +227,6 @@ sanitize_restored_xstate(union fpregs_state *state,
 		 * reasons.
 		 */
 		xsave->i387.mxcsr &= mxcsr_feature_mask;
-
-		if (ia32_env)
-			convert_to_fxsr(&state->fxsave, ia32_env);
 	}
 }
 

> - Eric

Sebastian
