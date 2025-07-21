Return-Path: <kvm+bounces-52993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1BBAB0C61A
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:21:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 540404E6DA5
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C08C2DC321;
	Mon, 21 Jul 2025 14:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OEEovLXW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3596E2D9793;
	Mon, 21 Jul 2025 14:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753107654; cv=none; b=nRZMCIKqZYYgGVkdUQEK92FS584LdBI7j96qQLmTGEqnq7d/rD51Tsekq2oJOs+O4kL0BkY8u2ak17TVHX2ewkZnSrevnVyorcUgyQ6Zow25+zlrR3tyZm3fIBmOZ7JLK+AGA5sKVFpoE4wgHnZTU44hVATKnKZpOJF1FypWUR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753107654; c=relaxed/simple;
	bh=WcM5wnpA64wCgG/368jaVvQHP7W1DVk6Z5ShRjWoQf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RmW1ggED6mio5hWl6Jm3a8O3WG7wPAM4b6+Eld5QAYXoZHxLw86VbPILLLwMVs8LEfS3uIJ9CZyPocSDtS2w7Iv6YcdxRUVtmlRRSEN7Q3pmJa3rZ32XDgLP4Kb1Vv74gT3BcmRuj37+T2V1FOWCDJ1nihrNfdye6DgZluv8S9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OEEovLXW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B2DC4CEED;
	Mon, 21 Jul 2025 14:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753107653;
	bh=WcM5wnpA64wCgG/368jaVvQHP7W1DVk6Z5ShRjWoQf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OEEovLXWEWOQBx6GbXKxq+FBPFIRjoM+BjL7HxUoTmugU3y3OVuO0crplkSuEA4aF
	 pDk32SXYRJg3gZDGeP568IZRTP3Rop9hZgfYxTCTGQubM3aOlVaCYNqDVsQI/5EtJY
	 3pPm1lrX7TKkFV9F4poj02Jn3x4oikT174oBP587e5Or3gd1/eh+ER+fv7+VGVri0Z
	 5rUC01K7z2KBrYtwcAo8oytELLisrvHLSymUrTB+IPZCSfcJZzTGer1Kib2+No8hhX
	 /cqArrraelelItBz+i0Z3lGRF8eNrfYzV4qrQ2jwh6P0JwV8yZU/8VHuEVlXwWfOzb
	 UauSpHgIxqIEQ==
Date: Mon, 21 Jul 2025 19:42:24 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v3 2/2] KVM: SVM: Limit AVIC physical max index based on
 configured max_vcpu_ids
Message-ID: <ap7276xfys3zweihirs6xnrvd53u3zlndqghju4sckysi53sli@r27e6jlo2kdw>
References: <cover.1740036492.git.naveen@kernel.org>
 <f4c832aef2f1bfb0eae314380171ece4693a67b2.1740036492.git.naveen@kernel.org>
 <aFnzf4SQqc9a2KcK@google.com>
 <xojzhg3e6czqg6zqyt3wbnzfafwy7bd7fq43b3ttkhfcw3svot@rakzaalsslfz>
 <aHplblJxJ-7FuaTH@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHplblJxJ-7FuaTH@google.com>

On Fri, Jul 18, 2025 at 08:17:02AM -0700, Sean Christopherson wrote:
> On Fri, Jul 18, 2025, Naveen N Rao wrote:
> > On Mon, Jun 23, 2025 at 05:38:23PM -0700, Sean Christopherson wrote:
> > > > @@ -103,7 +114,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
> > > >  	 */
> > > >  	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
> > > >  		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
> > > > -		vmcb->control.avic_physical_id |= x2avic_max_physical_id;
> > > > +		vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, true);
> > > 
> > > Don't pass hardcoded booleans when it is at all possible to do something else.
> > > For this case, I would either do:
> > > 
> > >   static u32 avic_get_max_physical_id(struct kvm_vcpu *vcpu)
> > >   {
> > > 	u32 arch_max;
> > > 	
> > > 	if (x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic))
> > 
> > This won't work since we want to use this during vCPU init and at that 
> > point, I don't think we can rely on the vCPU x2APIC mode to decide the 
> > size of the AVIC physical ID table.
> 
> Ah, I missed that this is used by avic_get_physical_id_table_order().  How about
> this?
> 
> static u32 __avic_get_max_physical_id(struct kvm *kvm, struct kvm_vcpu *vcpu)
> {
> 	u32 arch_max;
> 
> 	if (x2avic_enabled && (!vcpu || apic_x2apic_mode(vcpu->arch.apic)))
> 		arch_max = x2avic_max_physical_id;
> 	else
> 		arch_max = AVIC_MAX_PHYSICAL_ID;
> 
> 	return min(kvm->arch.max_vcpu_ids - 1, arch_max);
> }
> 
> static u32 avic_get_max_physical_id(struct kvm_vcpu *vcpu)
> {
> 	return __avic_get_max_physical_id(vcpu->kvm, vcpu);
> }
> 
> static void avic_activate_vmcb(struct vcpu_svm *svm)
> {
> 	struct vmcb *vmcb = svm->vmcb01.ptr;
> 	struct kvm_vcpu *vcpu = &svm->vcpu;
> 
> 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
> 
> 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
> 	vmcb->control.avic_physical_id |= avic_get_max_physical_id(vcpu);
> 
> 	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> 
> 	/*
> 	 * Note: KVM supports hybrid-AVIC mode, where KVM emulates x2APIC MSR
> 	 * accesses, while interrupt injection to a running vCPU can be
> 	 * achieved using AVIC doorbell.  KVM disables the APIC access page
> 	 * (deletes the memslot) if any vCPU has x2APIC enabled, thus enabling
> 	 * AVIC in hybrid mode activates only the doorbell mechanism.
> 	 */
> 	if (x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic)) {
> 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
> 		/* Disabling MSR intercept for x2APIC registers */
> 		svm_set_x2apic_msr_interception(svm, false);
> 	} else {
> 		/*
> 		 * Flush the TLB, the guest may have inserted a non-APIC
> 		 * mapping into the TLB while AVIC was disabled.
> 		 */
> 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> 
> 		/* Enabling MSR intercept for x2APIC registers */
> 		svm_set_x2apic_msr_interception(svm, true);
> 	}
> }
> 
> static int avic_get_physical_id_table_order(struct kvm *kvm)
> {
> 	/* Limit to the maximum physical ID supported in x2avic mode */
> 	return get_order((__avic_get_max_physical_id(kvm, NULL) + 1) * sizeof(u64));
> }

This LGTM, I will incorporate this.

> 
> > > > +static int svm_vcpu_precreate(struct kvm *kvm)
> > > > +{
> > > > +	return avic_alloc_physical_id_table(kvm);
> > > 
> > > Why is allocation being moved to svm_vcpu_precreate()?
> > 
> > This is because we want KVM_CAP_MAX_VCPU_ID to have been invoked by the 
> > VMM, and that is guaranteed to be set by the time the first vCPU is 
> > created. We restrict the AVIC physical ID table based on the maximum 
> > number of vCPUs set by the VMM.
> > 
> > This mirrors how Intel VMX uses this capability. I will call this out 
> > explicitly in the commit log.
> 
> Do it as a separate patch.  Then you pretty much *have* to write a changelog,
> and the changes that are specific to 4k support are even more isolated.

Sure.


Thanks,
Naveen


