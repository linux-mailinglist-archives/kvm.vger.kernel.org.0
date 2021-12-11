Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8B4470F42
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 01:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345370AbhLKAO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 19:14:27 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51722 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237677AbhLKAO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 19:14:26 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639181448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UyP3TRH2iWjdq5r7E4NtaTCjbCea3W5A7JaubhEgR60=;
        b=tt4xN8CIwj4OENid7IXT63tCLVnDpex6pyMXFnXPTsP9ztIZ+J/cT/inMEad29mARgktUC
        CZFYoxBTQmo/XXc20tak+FLtpw4sBQqlTR/eWqr8wrvdtHlWLX8ZPYRDgO+4hGd+63wJjM
        1Q2JPZaPt2JfJyME5M8T32Xplk4YRaFA2dVny4uk0Ur8P6hhC5JzzaOIkK7YZUkEp0MmWp
        cZUGUPrIHA7GnKDPr5gXX/LPaSELecYp17CLL4VnTvz6dwslvsTp2Z2BSvI9ttuaZnOUyC
        C6vVeF5goAeUdJd+fhy0qpEpO2BfaPP80VyE/bkLkn62X2QS20cbYu+BnHt+Ew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639181448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UyP3TRH2iWjdq5r7E4NtaTCjbCea3W5A7JaubhEgR60=;
        b=K3f0EOt34Ew7ARu8PxC8R10wpkywTX74rU4HKWS+pcsps5ch7Fr1N4WV6XlBdnaAd2YXwd
        FftW5iUjxv/ZkpCA==
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
In-Reply-To: <20211208000359.2853257-16-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-16-yang.zhong@intel.com>
Date:   Sat, 11 Dec 2021 01:10:47 +0100
Message-ID: <87pmq4vw54.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07 2021 at 19:03, Yang Zhong wrote:
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 5089f2e7dc22..9811dc98d550 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -238,6 +238,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>  	fpstate->is_guest	= true;
>  
>  	gfpu->fpstate		= fpstate;
> +	gfpu->xfd_err           = XFD_ERR_GUEST_DISABLED;

This wants to be part of the previous patch, which introduces the field.

>  	gfpu->user_xfeatures	= fpu_user_cfg.default_features;
>  	gfpu->user_perm		= fpu_user_cfg.default_features;
>  	fpu_init_guest_permissions(gfpu);
> @@ -297,6 +298,7 @@ int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
>  		fpu->fpstate = guest_fps;
>  		guest_fps->in_use = true;
>  	} else {
> +		fpu_save_guest_xfd_err(guest_fpu);

Hmm. See below.

>  		guest_fps->in_use = false;
>  		fpu->fpstate = fpu->__task_fpstate;
>  		fpu->__task_fpstate = NULL;
> @@ -4550,6 +4550,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  		kvm_steal_time_set_preempted(vcpu);
>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  
> +	if (vcpu->preempted)
> +		fpu_save_guest_xfd_err(&vcpu->arch.guest_fpu);

I'm not really exited about the thought of an exception cause register
in guest clobbered state.

Aside of that I really have to ask the question why all this is needed?

#NM in the guest is slow path, right? So why are you trying to optimize
for it?

The straight forward solution to this is:

    1) Trap #NM and MSR_XFD_ERR write

    2) When the guest triggers #NM is takes an VMEXIT and the host
       does:

                rdmsrl(MSR_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);

       injects the #NM and goes on.

    3) When the guest writes to MSR_XFD_ERR it takes an VMEXIT and
       the host does:

           vcpu->arch.guest_fpu.xfd_err = msrval;
           wrmsrl(MSR_XFD_ERR, msrval);

      and goes back.

    4) Before entering the preemption disabled section of the VCPU loop
       do:
       
           if (vcpu->arch.guest_fpu.xfd_err)
                      wrmsrl(MSR_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);

    5) Before leaving the preemption disabled section of the VCPU loop
       do:
       
           if (vcpu->arch.guest_fpu.xfd_err)
                      wrmsrl(MSR_XFD_ERR, 0);

It's really that simple and pretty much 0 overhead for the regular case.

If the guest triggers #NM with a high frequency then taking the VMEXITs
is the least of the problems. That's not a realistic use case, really.

Hmm?

Thanks,

        tglx
