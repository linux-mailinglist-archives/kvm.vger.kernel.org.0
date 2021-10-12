Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7B942AA2F
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 19:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhJLRCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 13:02:46 -0400
Received: from mail.skyhub.de ([5.9.137.197]:41632 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhJLRCp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 13:02:45 -0400
Received: from zn.tnic (p200300ec2f19420044c1262ed1e42b8c.dip0.t-ipconnect.de [IPv6:2003:ec:2f19:4200:44c1:262e:d1e4:2b8c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 77D621EC047E;
        Tue, 12 Oct 2021 19:00:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634058042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=VFiHaCYGS4PiGjz93clpXU/MkmM3x1XE+yI2Z0nSoWg=;
        b=S9X2n9BuZKq34hMHi4ZJuP4BixvlhC1HD6YbnXxn4lWa6x3N2oFksGJtDiBCBbYwy/CaUZ
        dXaBB+RTem3yu8WTEB5d911okymlF6Zwq93wTfkeArMLPapT7GDQDVCuYm8mK8C55PAVaE
        Z6Baqi7Af1i8uR6lncT9Uu1q3sMHeI4=
Date:   Tue, 12 Oct 2021 19:00:44 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 14/31] x86/fpu: Replace KVMs homebrewn FPU copy from user
Message-ID: <YWW/PEQyQAwS9/qv@zn.tnic>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.129308001@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211011223611.129308001@linutronix.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 02:00:19AM +0200, Thomas Gleixner wrote:
> Copying a user space buffer to the memory buffer is already available in
> the FPU core. The copy mechanism in KVM lacks sanity checks and needs to
> use cpuid() to lookup the offset of each component, while the FPU core has
> this information cached.
> 
> Make the FPU core variant accessible for KVM and replace the homebrewn
> mechanism.

I think you mean "homebred" in that patch... or "home brewed", that
works too, I think.

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: kvm@vger.kernel.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/fpu/api.h |    3 +
>  arch/x86/kernel/fpu/core.c     |   38 ++++++++++++++++++++-
>  arch/x86/kernel/fpu/xstate.c   |    3 -
>  arch/x86/kvm/x86.c             |   74 +----------------------------------------
>  4 files changed, 44 insertions(+), 74 deletions(-)
> 
> --- a/arch/x86/include/asm/fpu/api.h
> +++ b/arch/x86/include/asm/fpu/api.h
> @@ -116,4 +116,7 @@ extern void fpu_init_fpstate_user(struct
>  /* KVM specific functions */
>  extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
>  
> +struct kvm_vcpu;
> +extern int fpu_copy_kvm_uabi_to_vcpu(struct fpu *fpu, const void *buf, u64 xcr0, u32 *pkru);
> +
>  #endif /* _ASM_X86_FPU_API_H */
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -174,7 +174,43 @@ void fpu_swap_kvm_fpu(struct fpu *save,
>  	fpregs_unlock();
>  }
>  EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
> -#endif
> +
> +int fpu_copy_kvm_uabi_to_vcpu(struct fpu *fpu, const void *buf, u64 xcr0,
> +			      u32 *vpkru)

Right, except that there's no @vcpu in the args of that function. I
guess you could call it

fpu_copy_kvm_uabi_to_buf()

and that @buf can be

vcpu->arch.guest_fpu

...

Just a nitpick anyway.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
