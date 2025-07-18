Return-Path: <kvm+bounces-52878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53120B0A0D2
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 12:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86FAD5A6A7E
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 10:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997402BCF4D;
	Fri, 18 Jul 2025 10:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUo3qd1J"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA96629B218;
	Fri, 18 Jul 2025 10:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752835206; cv=none; b=Mrnd792VH9n/NUD/zaPKFwqZKRYi9bIzS9aRt/mpfob40OeLJQcyNK45+Tsj0OnpvitqtnaXV9oBxHgL6zBh6G8MvBLjZ0SDv/wtCS4anPTgPVmegpUmNt08VWxtfr/Y664RVYeHDX5XCD31aIu53ZrBADkezDCaDaiJ7bh8sL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752835206; c=relaxed/simple;
	bh=XGz8ZhzbTwznyHWED45VJOm5rJlDzZ3hdJbtYJAImLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qRQbBcidU7h8igOByDWC7mu0JhyTzzyj7mCM3JLI5zqiiiuKG4YqEzOKG0ahrgn+pTPiYmSW+yncDJ/SyOfwaP6P01FNVIxJrKrT0Vn6irAM3rc6now+vCMX9UsPPR2pxPhFqTROg3xt1a+RRsKR3nDTwn26MiRaj8e6+jtIGI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUo3qd1J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7656C4CEEB;
	Fri, 18 Jul 2025 10:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752835206;
	bh=XGz8ZhzbTwznyHWED45VJOm5rJlDzZ3hdJbtYJAImLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZUo3qd1JztJCCHJFWaXXROHmddmYV1qxfrYVoyzrOagEdm1GMDGKvuRTxevbmf9lP
	 86f448eq14ml1Qc2prQO2rBZYbZNktJQRxE5tjAd20xj/bHmajArx0QJFfgcxrRTr6
	 SiqGC9Tn7X3V39pu2V/bx+h7klvwZY7MVNAfLeJcBv0Np7hXch7OpcbC8u3M/R5Ktt
	 2iALltoPay27sGDsGpVR+5yrNoepamigRdZfrlU10ZmeTrNFpk4Rx9vA/r1bBKj3FQ
	 fyOLfFixxFtdbIh5cezlGP3nnaFc1pSVmqn49npdSSnUgkq/8wFv7jeNKvVKhnRJIp
	 p5GIMf8UZkLUA==
Date: Fri, 18 Jul 2025 16:04:35 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v3 2/2] KVM: SVM: Limit AVIC physical max index based on
 configured max_vcpu_ids
Message-ID: <xojzhg3e6czqg6zqyt3wbnzfafwy7bd7fq43b3ttkhfcw3svot@rakzaalsslfz>
References: <cover.1740036492.git.naveen@kernel.org>
 <f4c832aef2f1bfb0eae314380171ece4693a67b2.1740036492.git.naveen@kernel.org>
 <aFnzf4SQqc9a2KcK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFnzf4SQqc9a2KcK@google.com>

On Mon, Jun 23, 2025 at 05:38:23PM -0700, Sean Christopherson wrote:
> On Thu, Feb 20, 2025, Naveen N Rao (AMD) wrote:
> > KVM allows VMMs to specify the maximum possible APIC ID for a virtual
> > machine through KVM_CAP_MAX_VCPU_ID capability so as to limit data
> > structures related to APIC/x2APIC. Utilize the same to set the AVIC
> > physical max index in the VMCB, similar to VMX. This helps hardware
> > limit the number of entries to be scanned in the physical APIC ID table
> > speeding up IPI broadcasts for virtual machines with smaller number of
> > vcpus.
> > 
> > The minimum allocation required for the Physical APIC ID table is one 4k
> > page supporting up to 512 entries. With AVIC support for 4096 vcpus
> > though, it is sufficient to only allocate memory to accommodate the
> > AVIC physical max index that will be programmed into the VMCB. Limit
> > memory allocated for the Physical APIC ID table accordingly.
> 
> Can you flip the order of the patches?  This seems like an easy "win" for
> performance, and so I can see people wanting to backport this to random kernels
> even if they don't care about running 4k vCPUs.
> 
> Speaking of which, is there a measurable performance win?

That was my first thought. But for VMs upto 512 vCPUs, I didn't see much 
of a performance difference with broadcast IPIs at all. But, I guess it 
shouldn't hurt, so I will prep a smaller patch that can go before the 4k 
vCPU support patch.

With 4k vCPU support enabled, yes, this makes a lot of difference. IIRC, 
ipi-bench for broadcast IPIs went from ~10-15 seconds down to 3 seconds.

> 
> > Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> > ---
> >  arch/x86/kvm/svm/avic.c | 53 ++++++++++++++++++++++++++++++-----------
> >  arch/x86/kvm/svm/svm.c  |  6 +++++
> >  arch/x86/kvm/svm/svm.h  |  1 +
> >  3 files changed, 46 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 1fb322d2ac18..dac4a6648919 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -85,6 +85,17 @@ struct amd_svm_iommu_ir {
> >  	void *data;		/* Storing pointer to struct amd_ir_data */
> >  };
> >  
> > +static inline u32 avic_get_max_physical_id(struct kvm *kvm, bool is_x2apic)
> 
> Formletter incoming...
> 
> Do not use "inline" for functions that are visible only to the local compilation
> unit.  "inline" is just a hint, and modern compilers are smart enough to inline
> functions when appropriate without a hint.
> 
> A longer explanation/rant here: https://lore.kernel.org/all/ZAdfX+S323JVWNZC@google.com

Ack.

> 
> > +{
> > +	u32 avic_max_physical_id = is_x2apic ? x2avic_max_physical_id : AVIC_MAX_PHYSICAL_ID;
> 
> Don't use a super long local variable.  For a helper like this, it's unnecessary,
> e.g. if the reader can't understand what arch_max or max_id is, then spelling it
> out entirely probably won't help them.
> 
> And practically, there's a danger to using long names like this: you're much more
> likely to unintentionally "shadow" a global variable.  Functionally, it won't be
> a problem, but it can create confusion.  E.g. if we ever added a global
> avic_max_physical_id, then this code would get rather confusing.

Sure, makes sense.

> 
> > +
> > +	/*
> > +	 * Assume vcpu_id is the same as APIC ID. Per KVM_CAP_MAX_VCPU_ID, max_vcpu_ids
> > +	 * represents the max APIC ID for this vm, rather than the max vcpus.
> > +	 */
> > +	return min(kvm->arch.max_vcpu_ids - 1, avic_max_physical_id);
> > +}
> > +
> >  static void avic_activate_vmcb(struct vcpu_svm *svm)
> >  {
> >  	struct vmcb *vmcb = svm->vmcb01.ptr;
> > @@ -103,7 +114,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
> >  	 */
> >  	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
> >  		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
> > -		vmcb->control.avic_physical_id |= x2avic_max_physical_id;
> > +		vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, true);
> 
> Don't pass hardcoded booleans when it is at all possible to do something else.
> For this case, I would either do:
> 
>   static u32 avic_get_max_physical_id(struct kvm_vcpu *vcpu)
>   {
> 	u32 arch_max;
> 	
> 	if (x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic))

This won't work since we want to use this during vCPU init and at that 
point, I don't think we can rely on the vCPU x2APIC mode to decide the 
size of the AVIC physical ID table.

> 		arch_max = x2avic_max_physical_id;
> 	else
> 		arch_max = AVIC_MAX_PHYSICAL_ID;
> 
> 	return min(kvm->arch.max_vcpu_ids - 1, arch_max);
>   }
>

<snip>

> 
>   static u32 avic_get_max_physical_id(struct kvm_vcpu *vcpu, u32 arch_max)
>   {
> 	return min(kvm->arch.max_vcpu_ids - 1, arch_max);
>   }
> 
>   static void avic_activate_vmcb(struct vcpu_svm *svm)
>   {
> 	struct vmcb *vmcb = svm->vmcb01.ptr;
> 	struct kvm_vcpu *vcpu = &svm->vcpu;
> 	u32 max_id;
> 
> 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
> 	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> 
> 	/*
> 	 * Note: KVM supports hybrid-AVIC mode, where KVM emulates x2APIC MSR
> 	 * accesses, while interrupt injection to a running vCPU can be
> 	 * achieved using AVIC doorbell.  KVM disables the APIC access page
> 	 * (deletes the memslot) if any vCPU has x2APIC enabled, thus 
> 	 enabling
> 	 * AVIC in hybrid mode activates only the doorbell mechanism.
> 	 */
> 	if (x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic)) {
> 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
> 		max_id = avic_get_max_physical_id(vcpu, x2avic_max_physical_id);
> 
> 		/* Disabling MSR intercept for x2APIC registers */
> 		svm_set_x2apic_msr_interception(svm, false);
> 	} else {
> 		max_id = avic_get_max_physical_id(vcpu, 
> 		AVIC_MAX_PHYSICAL_ID);
> 		/*
> 		 * Flush the TLB, the guest may have inserted a non-APIC
> 		 * mapping into the TLB while AVIC was disabled.
> 		 */
> 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> 
> 		/* Enabling MSR intercept for x2APIC registers */
> 		svm_set_x2apic_msr_interception(svm, true);
> 	}
> 
> 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
> 	vmcb->control.avic_physical_id |= max_id;
>   }
> 
> 
> I don't think I have a preference between the two?

I'm thinking of limiting the helper to just x2AVIC mode, since the 
x1AVIC use is limited to a single place. Let me see what I can come up 
with.

> > +static int svm_vcpu_precreate(struct kvm *kvm)
> > +{
> > +	return avic_alloc_physical_id_table(kvm);
> 
> Why is allocation being moved to svm_vcpu_precreate()?

This is because we want KVM_CAP_MAX_VCPU_ID to have been invoked by the 
VMM, and that is guaranteed to be set by the time the first vCPU is 
created. We restrict the AVIC physical ID table based on the maximum 
number of vCPUs set by the VMM.

This mirrors how Intel VMX uses this capability. I will call this out 
explicitly in the commit log.


Thanks,
Naveen


