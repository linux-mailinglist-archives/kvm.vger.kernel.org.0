Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2A442AA0F
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 18:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhJLQzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 12:55:40 -0400
Received: from mail.skyhub.de ([5.9.137.197]:40386 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhJLQzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 12:55:39 -0400
Received: from zn.tnic (p200300ec2f19420044c1262ed1e42b8c.dip0.t-ipconnect.de [IPv6:2003:ec:2f19:4200:44c1:262e:d1e4:2b8c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3F02F1EC0295;
        Tue, 12 Oct 2021 18:53:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634057616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=XhG0eI6/ikMYsGMYYNFg1xgCN773kvIax9FWwldMVas=;
        b=jWVOsEy100GpEu+IIeuhPgEJ58dh4/hxgyIlnntXdfjIWzjnsjd4ApfxbbY2G1CYzcaFFr
        Rep+Dq5mvz4A0+MALuipfUhu7sMRpYXVwNe42fTSbs1pk4mu8luutkjqT1SbQOP2rXW5qh
        ThVF6chDcdr1+E0HMUonFD6yYlZqYdQ=
Date:   Tue, 12 Oct 2021 18:53:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Message-ID: <YWW9ksxtp4hpT0GI@zn.tnic>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.069324121@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211011223611.069324121@linutronix.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just typos:

On Tue, Oct 12, 2021 at 02:00:17AM +0200, Thomas Gleixner wrote:
> Swapping the host/guest FPU is directly fiddling with FPU internals which
> requires 5 exports. The upcoming support of dymanically enabled states

"dynamically"

>  /*
>   * Use kernel_fpu_begin/end() if you intend to use FPU in kernel context. It
>   * disables preemption so be careful if you intend to use it for long periods
> @@ -108,4 +110,10 @@ extern int cpu_has_xfeatures(u64 xfeatur
>  
>  static inline void update_pasid(void) { }
>  
> +/* FPSTATE related functions which are exported to KVM */

fpstate-related

> +extern void fpu_init_fpstate_user(struct fpu *fpu);
> +
> +/* KVM specific functions */
> +extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
> +
>  #endif /* _ASM_X86_FPU_API_H */

...

>  /* Swap (qemu) user FPU context for the guest FPU context. */
>  static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
>  {
> -	fpregs_lock();
> -
> -	kvm_save_current_fpu(vcpu->arch.user_fpu);
> -
>  	/*
> -	 * Guests with protected state can't have it set by the hypervisor,
> -	 * so skip trying to set it.
> +	 * Guest with protected state have guest_fpu == NULL which makes

"Guests ... "

> +	 * the swap only safe the host state. Exclude PKRU from restore as

"save"

> +	 * it is restored separately in kvm_x86_ops.run().
>  	 */
> -	if (vcpu->arch.guest_fpu)
> -		/* PKRU is separately restored in kvm_x86_ops.run. */
> -		__restore_fpregs_from_fpstate(&vcpu->arch.guest_fpu->state,
> -					~XFEATURE_MASK_PKRU);
> -
> -	fpregs_mark_activate();
> -	fpregs_unlock();
> -
> +	fpu_swap_kvm_fpu(vcpu->arch.user_fpu, vcpu->arch.guest_fpu,
> +			 ~XFEATURE_MASK_PKRU);
>  	trace_kvm_fpu(1);
>  }
>  
>  /* When vcpu_run ends, restore user space FPU context. */
>  static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
>  {
> -	fpregs_lock();
> -
>  	/*
> -	 * Guests with protected state can't have it read by the hypervisor,
> -	 * so skip trying to save it.
> +	 * Guest with protected state have guest_fpu == NULL which makes

"Guests ... "

> +	 * swap only restore the host state.
>  	 */
> -	if (vcpu->arch.guest_fpu)
> -		kvm_save_current_fpu(vcpu->arch.guest_fpu);
> -
> -	restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state);
> -
> -	fpregs_mark_activate();
> -	fpregs_unlock();
> -
> +	fpu_swap_kvm_fpu(vcpu->arch.guest_fpu, vcpu->arch.user_fpu, ~0ULL);
>  	++vcpu->stat.fpu_reload;
>  	trace_kvm_fpu(0);
>  }
> --- a/arch/x86/mm/extable.c
> +++ b/arch/x86/mm/extable.c
> @@ -47,7 +47,7 @@ static bool ex_handler_fprestore(const s
>  	WARN_ONCE(1, "Bad FPU state detected at %pB, reinitializing FPU registers.",
>  		  (void *)instruction_pointer(regs));
>  
> -	__restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
> +	restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
>  	return true;
>  }
>  
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
