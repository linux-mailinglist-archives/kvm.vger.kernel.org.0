Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35606392CF
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 19:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731212AbfFGRJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 13:09:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730196AbfFGRJw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 13:09:52 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1712B208E3;
        Fri,  7 Jun 2019 17:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559927391;
        bh=zTE9Vnc80prCH8PSEwnKTNhjRC5uBLiJcuWCP0FnZBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZgApmZjjjZArxNzMJS92zb1duXOLfAHnxFWRojQpdAga3W+RgadVqRoCPs2s886O9
         WexWxrHwX2eTwI87ZGkFjAOzQdHA71NFyKrqbDFaLMhyP+sGDlo9ITk+SkKm/mEv1Y
         zCNDruhQwMAkzM7sov7CcGUS7Weuon4IZXp/aAi4=
Date:   Fri, 7 Jun 2019 10:09:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     x86-ml <x86@kernel.org>, Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jann Horn <jannh@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        kvm ML <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/fpu: Update kernel's FPU state before using for the
 fsave header
Message-ID: <20190607170949.GA648@sol.localdomain>
References: <20190604185358.GA820@sol.localdomain>
 <20190605140405.2nnpqslnjpfe2ig2@linutronix.de>
 <20190605173256.GA86462@gmail.com>
 <20190606173026.ty7c4cvftrvfrwy3@linutronix.de>
 <20190607142915.y52mfmgk5lvhll7n@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190607142915.y52mfmgk5lvhll7n@linutronix.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 07, 2019 at 04:29:16PM +0200, Sebastian Andrzej Siewior wrote:
> In commit
> 
>   39388e80f9b0c ("x86/fpu: Don't save fxregs for ia32 frames in copy_fpstate_to_sigframe()")
> 
> I removed the statement
> |       if (ia32_fxstate)
> |               copy_fxregs_to_kernel(fpu);
> 
> and argued that is was wrongly merged because the content was already
> saved in kernel's state and the content.
> This was wrong: It is required to write it back because it is only saved
> on the user-stack and save_fsave_header() reads it from task's
> FPU-state. I missed that part…
> 
> Save x87 FPU state unless thread's FPU registers are already up to date.
> 
> Fixes: 39388e80f9b0c ("x86/fpu: Don't save fxregs for ia32 frames in copy_fpstate_to_sigframe()")
> Reported-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/x86/kernel/fpu/signal.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
> index 060d6188b4533..0071b794ed193 100644
> --- a/arch/x86/kernel/fpu/signal.c
> +++ b/arch/x86/kernel/fpu/signal.c
> @@ -62,6 +62,11 @@ static inline int save_fsave_header(struct task_struct *tsk, void __user *buf)
>  		struct user_i387_ia32_struct env;
>  		struct _fpstate_32 __user *fp = buf;
>  
> +		fpregs_lock();
> +		if (!test_thread_flag(TIF_NEED_FPU_LOAD))
> +			copy_fxregs_to_kernel(&tsk->thread.fpu);
> +		fpregs_unlock();
> +
>  		convert_from_fxsr(&env, tsk);
>  
>  		if (__copy_to_user(buf, &env, sizeof(env)) ||
> -- 
> 2.20.1
> 

Tested-by: Eric Biggers <ebiggers@kernel.org>

- Eric
