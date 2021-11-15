Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F9F45043A
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 13:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhKOMRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 07:17:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30455 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231293AbhKOMRZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 07:17:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636978469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z4e6bpLGEr3iQQ3o5fPZ7ShC8tMfHyyVzC6j2fINWX8=;
        b=JD18GnD0aPc8iDUXw/vBa7HwlkCwXgyekN4LARh4pruWtEwKKaNm7bk8iHifOOnJ/IFlcA
        ULoa9XCT7LOh67Hq3oCV2YpIH/bU1BrIZQbuftcp4Xz6t62oCc5tpPSaqJgXVn8ZQv5RFJ
        ZhP3ZQLtX1as4gprd/Dh3+2hU7GAJzA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-9i69A8ayNOuLMlz_K9UZbw-1; Mon, 15 Nov 2021 07:14:26 -0500
X-MC-Unique: 9i69A8ayNOuLMlz_K9UZbw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27C9B1023F4D;
        Mon, 15 Nov 2021 12:14:24 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 283152AF6D;
        Mon, 15 Nov 2021 12:14:18 +0000 (UTC)
Message-ID: <a4183197a51f101d37a9091c3139ffe24bbacaef.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: don't skip mmu initialization when
 mmu root level changes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Date:   Mon, 15 Nov 2021 14:14:17 +0200
In-Reply-To: <YYv/iH4M7vzmcj5u@google.com>
References: <20211110100018.367426-1-mlevitsk@redhat.com>
         <20211110100018.367426-4-mlevitsk@redhat.com>
         <87r1bom5h3.fsf@vitty.brq.redhat.com>
         <18d77c7a10f283848c4efe0370401c436869f3a2.camel@redhat.com>
         <YYv/iH4M7vzmcj5u@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-11-10 at 17:21 +0000, Sean Christopherson wrote:
> On Wed, Nov 10, 2021, Maxim Levitsky wrote:
> > On Wed, 2021-11-10 at 15:48 +0100, Vitaly Kuznetsov wrote:
> > > Maxim Levitsky <mlevitsk@redhat.com> writes:
> > > 
> > > > When running mix of 32 and 64 bit guests, it is possible to have mmu
> > > > reset with same mmu role but different root level (32 bit vs 64 bit paging)
> 
> Hmm, no, it's far more nuanced than just "running a mix of 32 and 64 bit guests".
> The changelog needs a much more in-depth explanation of exactly what and how
> things go awry.  I suspect that whatever bug is being hit is unique to the
> migration path.
> 
> This needs a Fixes and Cc: stable@vger.kernel.org, but which commit is fixed is
> TBD.
> 
> Simply running 32 and 64 bit guests is not sufficient to cause problems.  In
> that case, they are different VMs entirely, where as the MMU context is per-vCPU.
> So at minimum, this require running a mix of 32-bit and 64-bit _nested_ guests.



> 
> But even that isn't sufficient.  Ignoring migration for the moment:
This is the key point - without migration that bug can't happen.

> 
>   a) If shadow paging is enabled in L0, then EFER.LMA is captured in
>      kvm_mmu_page_role.level.  Ergo this flaw doesn't affect legacy shadow paging.
True. moreover if L1 doesn't use NPT/EPT, then there is nothing special in nested mode,
It just either normal NPT/EPT direct mode or if L0 also disabled NPT/EPT, then
it is normal shadow mmu, and the mmu context is indeed shared which means that
guest_mode should reset it well.

> 
>   b) If EPT is enabled in L0 _and_ L1, kvm_mmu_page_role.level tracks L1's EPT
>      level.  Ergo, this flaw doesn't affect nested EPT.
Well it does _after_ nested migration.

If you look at kvm_calc_tdp_mmu_root_page_role, you see that the role.base.level reflects
the NPT/EPT level which is on 64 bit hosts 4 or even 5, and it never changes,
regardless of 64/32 bitness of the L1 and/or L2.

However, the 'context->root_level' reflects the L1's guest root level which
depends on L1's EFER, and after migration it is incorrectly initialized with
32 bit EFER, and that is not captured in the mmu role.

That MMU is incorrectly initialized right after nested migration when we are still not
nested and qemu uploads SREGS, and then it is supposed to be initialized again
after first nested VM exit to the host, but it doesn't as I explained above.

Note that I am here talking only about L1 mmu (aka root_mmu), so guest_mode doesn't apply here,
it is always false.


This problem does actually happen on SVM as well I see after I tested it now, 
in fact putting some printks, I see that L1 mmu is stuck in 
PAE mode forever (it supposed to be in 64 bit mode as L1 is 64 bit guest) 
after a nested migration.

The L1 guest just seems to somehow to 'work', but L2 does eventually hang, as opposed to 
wrong injected pagefault which kills L1 immediately on VMX.

It is either luck or slight differencies between EPT and NPT - the root level
is mostly used for page walks which happen usually on MMIO accesses.


> 
>   c) If NPT is enabled in L0 _and_ L1, then this flaw can does apply as
>      kvm_mmu_page_role.level tracks L0's NPT level, which does not incorporate
>      L1's NPT level because of the limitations of NPT.  But the cover letter
>      states these bugs are specific to VMX.  I suspect that's incorrect and that
>      in theory this particular bug does apply to SVM, but that it hasn't been
>      hit due to not running with nNPT and both 32-bit and 64-bit L2s on a single
>      vCPU.

To have different NPT level in L0 and L1, you have to run a 32 bit L1, which can
only run thankfully 32 bit nested guests, so no mixing at L2 level possible.

However mixing 5/4 level NPT I won't rule that as impossible. I don't yet test
this because I usually don't use hardware that has support for 5 level NPT/EPT.



> 
>   d) If TDP is enabled in L0 but _not_ L1, then L1 and L2 share an MMU context,
>      and that context is guaranteed to be reset on every nested transition due
>      to kvm_mmu_page_role.guest_mode.  Ergo this flaw doesn't affect this combo
>      since it's impossible to switch between two L2 vCPUs on a single L1 vCPU
>      without a context reset.
Yes.

> 
> The cover letter says:
> 
>   The second issue is that L2 IA32_EFER makes L1's mmu be initialized incorrectly
>   (with PAE paging). This itself isn't an immediate problem as we are going into the L2,
>   but when we exit it, we don't reset the L1's mmu back to 64 bit mode because,
>   It so happens that the mmu role doesn't change and the 64 bitness isn't part of the mmu role.
> 
> But that should be impossible because of kvm_mmu_page_role.guest_mode.  If that
> doesn't trigger a reset, then presumably is_guest_mode() is stale?
Since the bug affects only L1's mmu, the guest mode is always false for it.

> 
> Regarding (c), I believe this can be hit by running a 32-bit L2 and 64-bit L2 on
> SVM with nNPT.  I don't think that's a combination I've tested much, if at all.
I tested this just in case few times, seems to work very well and survives migration
of L1 as well.

> 
> Regarding (d), I believe the bug can rear its head if guest state is stuffed
> via KVM_SET_SREGS{2}.  kvm_mmu_reset_context() will re-init the MMU, but it
> doesn't purge the previous context.  I.e. the assumption that a switch between
> "two" L2s can be broken.
> 
> > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c | 14 ++++++++++----
> > > >  1 file changed, 10 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 354d2ca92df4d..763867475860f 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -4745,7 +4745,10 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
> > > >  	union kvm_mmu_role new_role =
> > > >  		kvm_calc_tdp_mmu_root_page_role(vcpu, &regs, false);
> > > >  
> > > > -	if (new_role.as_u64 == context->mmu_role.as_u64)
> > > > +	u8 new_root_level = role_regs_to_root_level(&regs);
> > > > +
> > > > +	if (new_role.as_u64 == context->mmu_role.as_u64 &&
> > > > +	    context->root_level == new_root_level)
> > > >  		return;
> > > 
> > > role_regs_to_root_level() uses 3 things: CR0.PG, EFER.LMA and CR4.PAE
> > > and two of these three are already encoded into extended mmu role
> > > (kvm_calc_mmu_role_ext()). Could we achieve the same result by adding
> > > EFER.LMA there?
> > 
> > Absolutely. I just wanted your feedback on this to see if there is any reason
> > to not do this.
> 
> Assuming my assessment above is correct, incorporating EFER.LMA into the
> extended role is the correct fix.  That will naturally do the right thing for
> nested EPT in the sense that kvm_calc_shadow_ept_root_page_role() will ignore
> EFER.LMA entirely.

Yes, and the patch is on the way.

> 
> > Also it seems that only basic role is compared here.
> 
> No, it's the full role.  "as_u64" is the overlay for the combined base+ext.
> 
> union kvm_mmu_role {
> 	u64 as_u64;
> 	struct {
> 		union kvm_mmu_page_role base;
> 		union kvm_mmu_extended_role ext;
> 	};
> };
> 
> > I don't 100% know the reason why we have basic and extended roles - there is a
> > comment about basic/extended mmu role to minimize the size of arch.gfn_track,
> > but I haven't yet studied in depth why.
> 
> The "base" role is used to identify which individual shadow pages are compatible
> with the current shadow/TDP paging context.  Using TDP as an example, KVM can
> reuse SPs at the correct level regardless of guest LA57.  The gfn_track thing
> tracks ever SP in existence for a given gfn.  To minimize the number of possible
> SPs, and thus minimize the storage capacity needed for gfn_track, the "base" role
> is kept as tiny as possible.
> 
> > > >  	context->mmu_role.as_u64 = new_role.as_u64;
> > > > @@ -4757,7 +4760,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
> > > >  	context->get_guest_pgd = get_cr3;
> > > >  	context->get_pdptr = kvm_pdptr_read;
> > > >  	context->inject_page_fault = kvm_inject_page_fault;
> > > > -	context->root_level = role_regs_to_root_level(&regs);
> > > > +	context->root_level = new_root_level;
> > > >  
> > > >  	if (!is_cr0_pg(context))
> > > >  		context->gva_to_gpa = nonpaging_gva_to_gpa;
> > > > @@ -4806,7 +4809,10 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
> > > >  				    struct kvm_mmu_role_regs *regs,
> > > >  				    union kvm_mmu_role new_role)
> > > >  {
> > > > -	if (new_role.as_u64 == context->mmu_role.as_u64)
> > > > +	u8 new_root_level = role_regs_to_root_level(regs);
> > > > +
> > > > +	if (new_role.as_u64 == context->mmu_role.as_u64 &&
> > > > +	    context->root_level == new_root_level)
> 
> Doesn't matter if EFER.LMA is added to the role, but this extra check shouldn't
> be necessary for shadow paging as LMA is factored into role.base.level in that
> case.  TDP is problematic because role.base.level holds the TDP root level, which
> doesn't depend on guest.EFER.LMA.
> 
> Nested EPT is also ok because shadow_root_level == root_level in that case.
> 
> > > >  		return;
> > > >  
> > > >  	context->mmu_role.as_u64 = new_role.as_u64;
> > > > @@ -4817,8 +4823,8 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
> > > >  		paging64_init_context(context);
> > > >  	else
> > > >  		paging32_init_context(context);
> > > > -	context->root_level = role_regs_to_root_level(regs);
> > > >  
> > > > +	context->root_level = new_root_level;
> > > >  	reset_guest_paging_metadata(vcpu, context);
> > > >  	context->shadow_root_level = new_role.base.level;


Thanks for the review!
	Best regards,
		Maxim Levitsky


