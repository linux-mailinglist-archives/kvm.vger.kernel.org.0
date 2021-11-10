Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2604644C5EC
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 18:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhKJRYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 12:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbhKJRYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 12:24:07 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4EAC061764
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 09:21:19 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gt5so2114976pjb.1
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 09:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WhfnS5vDybFADKwJoIkInKN8uBvc9V9SVt1xhdhXjr0=;
        b=mviWWb54Tvs91XunxpR2VKWXKV8OKLf+7Zd+S0AxzaRTeXof8Qo67kU5v/yHXACjzb
         ndzkGHWfBfOcC9xCxRyE+AVDiubjJZuPMIpSyttUT81SYix85GU8W5mOFJR+meuzXsSK
         mheN4g1J1Fuw9uOi181c+KYQ960M6PSSxmzyut8lC4mULgENWxrwZdX5X1ra7dwT8qWs
         JZ4EU96iCUGvmvEQDBv5Bz3zwdH7IEJrhVmpWjLwkY8CT/d6QmmXkfnkiqygSIK95s8U
         fA8zpV2aLPVzaDgWLDXXJWLk07Q4liNaL5qJLChpHrp01dOhx++eo2Yd2acD0kV6d7Bj
         +1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WhfnS5vDybFADKwJoIkInKN8uBvc9V9SVt1xhdhXjr0=;
        b=XRSJGXRM1oGIa1Ant9g7ZB7iDhSGMhzaM6PYZbMbremDrt5XksX+zf/E2g1LxSr+Yw
         QybKj36y914Y+55pDJdMcALscgH6xzDi7exb1OFNtY3GGqXFwq6Q9EPxQZgdAlLkUXC+
         a00S6AWvBBbMF3+8K9XpLx4zmRPcq/1YYTpvkcHZvqBJdF3kfa+VhED7iAni4EOIb63N
         F1EHYrf+Lg3n7D6UXuX5xD244wM/qZ5UsnZeJb2U5v5KjrzNFRtmNTUMmPRr3Ca0PO1C
         6fjdgdUZ4EYbzO86JV6w0J7iYiY9C2jaY2OTI4ZhSEpAebB5K5NMk9DnGix+1QwAJ4zB
         OjJg==
X-Gm-Message-State: AOAM533GatAedhglE3iNNiiXoq8rSh64IJe81ESOkhGxP4s9PHBiS1bx
        u90F7d0avLC7qWQv3ri5dR5XJw==
X-Google-Smtp-Source: ABdhPJwhlqd0soHh6LmSwzTPlDK9wZquvzpB+xZU0CYE7gLNQcVlsfWVdAmcmt/nfMFmMqlxKdot7w==
X-Received: by 2002:a17:902:7fc5:b0:143:6d84:88eb with SMTP id t5-20020a1709027fc500b001436d8488ebmr237200plb.61.1636564878541;
        Wed, 10 Nov 2021 09:21:18 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l21sm237004pfu.213.2021.11.10.09.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 09:21:16 -0800 (PST)
Date:   Wed, 10 Nov 2021 17:21:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: don't skip mmu initialization when mmu
 root level changes
Message-ID: <YYv/iH4M7vzmcj5u@google.com>
References: <20211110100018.367426-1-mlevitsk@redhat.com>
 <20211110100018.367426-4-mlevitsk@redhat.com>
 <87r1bom5h3.fsf@vitty.brq.redhat.com>
 <18d77c7a10f283848c4efe0370401c436869f3a2.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18d77c7a10f283848c4efe0370401c436869f3a2.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021, Maxim Levitsky wrote:
> On Wed, 2021-11-10 at 15:48 +0100, Vitaly Kuznetsov wrote:
> > Maxim Levitsky <mlevitsk@redhat.com> writes:
> > 
> > > When running mix of 32 and 64 bit guests, it is possible to have mmu
> > > reset with same mmu role but different root level (32 bit vs 64 bit paging)

Hmm, no, it's far more nuanced than just "running a mix of 32 and 64 bit guests".
The changelog needs a much more in-depth explanation of exactly what and how
things go awry.  I suspect that whatever bug is being hit is unique to the
migration path.

This needs a Fixes and Cc: stable@vger.kernel.org, but which commit is fixed is
TBD.

Simply running 32 and 64 bit guests is not sufficient to cause problems.  In
that case, they are different VMs entirely, where as the MMU context is per-vCPU.
So at minimum, this require running a mix of 32-bit and 64-bit _nested_ guests.

But even that isn't sufficient.  Ignoring migration for the moment:

  a) If shadow paging is enabled in L0, then EFER.LMA is captured in
     kvm_mmu_page_role.level.  Ergo this flaw doesn't affect legacy shadow paging.

  b) If EPT is enabled in L0 _and_ L1, kvm_mmu_page_role.level tracks L1's EPT
     level.  Ergo, this flaw doesn't affect nested EPT.

  c) If NPT is enabled in L0 _and_ L1, then this flaw can does apply as
     kvm_mmu_page_role.level tracks L0's NPT level, which does not incorporate
     L1's NPT level because of the limitations of NPT.  But the cover letter
     states these bugs are specific to VMX.  I suspect that's incorrect and that
     in theory this particular bug does apply to SVM, but that it hasn't been
     hit due to not running with nNPT and both 32-bit and 64-bit L2s on a single
     vCPU.

  d) If TDP is enabled in L0 but _not_ L1, then L1 and L2 share an MMU context,
     and that context is guaranteed to be reset on every nested transition due
     to kvm_mmu_page_role.guest_mode.  Ergo this flaw doesn't affect this combo
     since it's impossible to switch between two L2 vCPUs on a single L1 vCPU
     without a context reset.

The cover letter says:

  The second issue is that L2 IA32_EFER makes L1's mmu be initialized incorrectly
  (with PAE paging). This itself isn't an immediate problem as we are going into the L2,
  but when we exit it, we don't reset the L1's mmu back to 64 bit mode because,
  It so happens that the mmu role doesn't change and the 64 bitness isn't part of the mmu role.

But that should be impossible because of kvm_mmu_page_role.guest_mode.  If that
doesn't trigger a reset, then presumably is_guest_mode() is stale?

Regarding (c), I believe this can be hit by running a 32-bit L2 and 64-bit L2 on
SVM with nNPT.  I don't think that's a combination I've tested much, if at all.

Regarding (d), I believe the bug can rear its head if guest state is stuffed
via KVM_SET_SREGS{2}.  kvm_mmu_reset_context() will re-init the MMU, but it
doesn't purge the previous context.  I.e. the assumption that a switch between
"two" L2s can be broken.

> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 14 ++++++++++----
> > >  1 file changed, 10 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 354d2ca92df4d..763867475860f 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4745,7 +4745,10 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
> > >  	union kvm_mmu_role new_role =
> > >  		kvm_calc_tdp_mmu_root_page_role(vcpu, &regs, false);
> > >  
> > > -	if (new_role.as_u64 == context->mmu_role.as_u64)
> > > +	u8 new_root_level = role_regs_to_root_level(&regs);
> > > +
> > > +	if (new_role.as_u64 == context->mmu_role.as_u64 &&
> > > +	    context->root_level == new_root_level)
> > >  		return;
> > 
> > role_regs_to_root_level() uses 3 things: CR0.PG, EFER.LMA and CR4.PAE
> > and two of these three are already encoded into extended mmu role
> > (kvm_calc_mmu_role_ext()). Could we achieve the same result by adding
> > EFER.LMA there?
> 
> Absolutely. I just wanted your feedback on this to see if there is any reason
> to not do this.

Assuming my assessment above is correct, incorporating EFER.LMA into the
extended role is the correct fix.  That will naturally do the right thing for
nested EPT in the sense that kvm_calc_shadow_ept_root_page_role() will ignore
EFER.LMA entirely.

> Also it seems that only basic role is compared here.

No, it's the full role.  "as_u64" is the overlay for the combined base+ext.

union kvm_mmu_role {
	u64 as_u64;
	struct {
		union kvm_mmu_page_role base;
		union kvm_mmu_extended_role ext;
	};
};

> I don't 100% know the reason why we have basic and extended roles - there is a
> comment about basic/extended mmu role to minimize the size of arch.gfn_track,
> but I haven't yet studied in depth why.

The "base" role is used to identify which individual shadow pages are compatible
with the current shadow/TDP paging context.  Using TDP as an example, KVM can
reuse SPs at the correct level regardless of guest LA57.  The gfn_track thing
tracks ever SP in existence for a given gfn.  To minimize the number of possible
SPs, and thus minimize the storage capacity needed for gfn_track, the "base" role
is kept as tiny as possible.

> > >  	context->mmu_role.as_u64 = new_role.as_u64;
> > > @@ -4757,7 +4760,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
> > >  	context->get_guest_pgd = get_cr3;
> > >  	context->get_pdptr = kvm_pdptr_read;
> > >  	context->inject_page_fault = kvm_inject_page_fault;
> > > -	context->root_level = role_regs_to_root_level(&regs);
> > > +	context->root_level = new_root_level;
> > >  
> > >  	if (!is_cr0_pg(context))
> > >  		context->gva_to_gpa = nonpaging_gva_to_gpa;
> > > @@ -4806,7 +4809,10 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
> > >  				    struct kvm_mmu_role_regs *regs,
> > >  				    union kvm_mmu_role new_role)
> > >  {
> > > -	if (new_role.as_u64 == context->mmu_role.as_u64)
> > > +	u8 new_root_level = role_regs_to_root_level(regs);
> > > +
> > > +	if (new_role.as_u64 == context->mmu_role.as_u64 &&
> > > +	    context->root_level == new_root_level)

Doesn't matter if EFER.LMA is added to the role, but this extra check shouldn't
be necessary for shadow paging as LMA is factored into role.base.level in that
case.  TDP is problematic because role.base.level holds the TDP root level, which
doesn't depend on guest.EFER.LMA.

Nested EPT is also ok because shadow_root_level == root_level in that case.

> > >  		return;
> > >  
> > >  	context->mmu_role.as_u64 = new_role.as_u64;
> > > @@ -4817,8 +4823,8 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
> > >  		paging64_init_context(context);
> > >  	else
> > >  		paging32_init_context(context);
> > > -	context->root_level = role_regs_to_root_level(regs);
> > >  
> > > +	context->root_level = new_root_level;
> > >  	reset_guest_paging_metadata(vcpu, context);
> > >  	context->shadow_root_level = new_role.base.level;
> 
> 
