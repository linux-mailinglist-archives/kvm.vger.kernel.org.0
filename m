Return-Path: <kvm+bounces-52907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B76CB0A6F4
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:17:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E243B5A506B
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A682DCBF7;
	Fri, 18 Jul 2025 15:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yteaprA6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05D5171CD
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 15:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752851826; cv=none; b=X8srX7N4poEyt0VeC7kIwVx/Fi8jPh2+O6MJ2VIUvyaCMvsU1ktiSmaNiukwwgkSZUCyIPJzPPqyLNiSIDqUVRzx8bLbFOAfrMfTfdnNjFDpsopFlw6mtBKAEajDMsSVIt9egkkR6MrpZimY2jkmeLcXhaLoLiJFKmY6Yog9F14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752851826; c=relaxed/simple;
	bh=8eDdgWLC+QIReMatPvM0XTGT4Sm31nC4WBC0WmvOhpI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QJxRDTFL7zVFn0aqbJHvALutknd591ZXnE4Xp+JYIPxFSDym5VTmTF+8y+kkXFheHj1uO6tGpkV+DR7QCUQXGNmcgnN/Nfq60CfRdgdfYLDpQoBxxJ4h+vtPBLTt50Bqujnc5nIo8C/qp/nJ1LwbYE2NlpLTzxsDED4132Q8Atg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yteaprA6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313d6d671ffso2337615a91.2
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 08:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752851824; x=1753456624; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1L+XboiYZgwrDs9t+19i/kb8Oa/gCwS5XH8+lxsNAlM=;
        b=yteaprA63Q3LLOnoz5Bd1LS5ShP6wDmEi9D1KaH1eeIFzDp7tQ/YL4o79SPIsOwomM
         Lf5iO7hGuaLNP1xG69zc3HDjeq3SZ4Sc92Khw4eGQVbnGnJm9YWW7jnWFx8icoPyfeD7
         GTVG0jQbrH3haFP4U3qwCx1Kl2RiwWabPI0Tc+/AXBJHw2sIfcx7lnL6+f1h2hodKaZP
         SfejvRTd5URbfDzWoZeC6cKKU3iPD/MIE9TP2qXGz9D0Z6mBR5qMv6Xq8aU+vYH8Bb5r
         gQoJhe2Du02VIy4ZecJzbaWmRSjCU9PemLGYsWxGbeH3ukTF4aKD0dqH4mTTHWrNscDT
         T5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752851824; x=1753456624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1L+XboiYZgwrDs9t+19i/kb8Oa/gCwS5XH8+lxsNAlM=;
        b=Fw+gk7p/x3nxlcXkO7vy6/zDQ0pmrxBe6I+07XkNTeme07bdzfTdoxzYap7eJ0tgF+
         TxtmQ/wLht6I8SUCRe1BsutgunXYElPq7axwDqb5+ONk8+/uvy0sFedkjqjgovQ0MjQw
         POmdBj6Iz5dB1Hy1ONkXA4ZbzLjn/SLSrQSreqldqvoRI56+P7lRuvqG4vZieMcICFvL
         MBNGJydlkeVabl/OZQtSR+NcuEqcOcbhCu0s9LT3sVtTWHFCb8fkf9MZWlOInEKX84ZX
         O0ajxM5H6GeGDnozCwfuGhIpBNSrnMji5O7RXLQPNtZz4WUdbQfOIkZE8WZcdGfIdXxH
         pFRQ==
X-Gm-Message-State: AOJu0Yxz6Senl0ShypqbgIDVheNg1MIVXvDpL02UkSS5414M8s596Pd6
	9mYYLzId66LX2aHYjFMF5bEOrZPPD+BLbseJiLPS6rv02p0H7+hWz1TLnxmAD7VZZFFnIhVEnCA
	6w2K0Eg==
X-Google-Smtp-Source: AGHT+IEe6NhIMjl0qrBNjltCkK4Og0mX2axMMJY80bqLmgjowcFokCH2aOrFBc4AM2tL6CqFHB1He0/dHrY=
X-Received: from pjkk15.prod.google.com ([2002:a17:90b:57ef:b0:31c:2fe4:33b8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2d0:b0:313:176b:7384
 with SMTP id 98e67ed59e1d1-31c9e6fbb16mr15962881a91.11.1752851824229; Fri, 18
 Jul 2025 08:17:04 -0700 (PDT)
Date: Fri, 18 Jul 2025 08:17:02 -0700
In-Reply-To: <xojzhg3e6czqg6zqyt3wbnzfafwy7bd7fq43b3ttkhfcw3svot@rakzaalsslfz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1740036492.git.naveen@kernel.org> <f4c832aef2f1bfb0eae314380171ece4693a67b2.1740036492.git.naveen@kernel.org>
 <aFnzf4SQqc9a2KcK@google.com> <xojzhg3e6czqg6zqyt3wbnzfafwy7bd7fq43b3ttkhfcw3svot@rakzaalsslfz>
Message-ID: <aHplblJxJ-7FuaTH@google.com>
Subject: Re: [PATCH v3 2/2] KVM: SVM: Limit AVIC physical max index based on
 configured max_vcpu_ids
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 18, 2025, Naveen N Rao wrote:
> On Mon, Jun 23, 2025 at 05:38:23PM -0700, Sean Christopherson wrote:
> > > @@ -103,7 +114,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
> > >  	 */
> > >  	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
> > >  		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
> > > -		vmcb->control.avic_physical_id |= x2avic_max_physical_id;
> > > +		vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, true);
> > 
> > Don't pass hardcoded booleans when it is at all possible to do something else.
> > For this case, I would either do:
> > 
> >   static u32 avic_get_max_physical_id(struct kvm_vcpu *vcpu)
> >   {
> > 	u32 arch_max;
> > 	
> > 	if (x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic))
> 
> This won't work since we want to use this during vCPU init and at that 
> point, I don't think we can rely on the vCPU x2APIC mode to decide the 
> size of the AVIC physical ID table.

Ah, I missed that this is used by avic_get_physical_id_table_order().  How about
this?

static u32 __avic_get_max_physical_id(struct kvm *kvm, struct kvm_vcpu *vcpu)
{
	u32 arch_max;

	if (x2avic_enabled && (!vcpu || apic_x2apic_mode(vcpu->arch.apic)))
		arch_max = x2avic_max_physical_id;
	else
		arch_max = AVIC_MAX_PHYSICAL_ID;

	return min(kvm->arch.max_vcpu_ids - 1, arch_max);
}

static u32 avic_get_max_physical_id(struct kvm_vcpu *vcpu)
{
	return __avic_get_max_physical_id(vcpu->kvm, vcpu);
}

static void avic_activate_vmcb(struct vcpu_svm *svm)
{
	struct vmcb *vmcb = svm->vmcb01.ptr;
	struct kvm_vcpu *vcpu = &svm->vcpu;

	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);

	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
	vmcb->control.avic_physical_id |= avic_get_max_physical_id(vcpu);

	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;

	/*
	 * Note: KVM supports hybrid-AVIC mode, where KVM emulates x2APIC MSR
	 * accesses, while interrupt injection to a running vCPU can be
	 * achieved using AVIC doorbell.  KVM disables the APIC access page
	 * (deletes the memslot) if any vCPU has x2APIC enabled, thus enabling
	 * AVIC in hybrid mode activates only the doorbell mechanism.
	 */
	if (x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic)) {
		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
		/* Disabling MSR intercept for x2APIC registers */
		svm_set_x2apic_msr_interception(svm, false);
	} else {
		/*
		 * Flush the TLB, the guest may have inserted a non-APIC
		 * mapping into the TLB while AVIC was disabled.
		 */
		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);

		/* Enabling MSR intercept for x2APIC registers */
		svm_set_x2apic_msr_interception(svm, true);
	}
}

static int avic_get_physical_id_table_order(struct kvm *kvm)
{
	/* Limit to the maximum physical ID supported in x2avic mode */
	return get_order((__avic_get_max_physical_id(kvm, NULL) + 1) * sizeof(u64));
}

> > > +static int svm_vcpu_precreate(struct kvm *kvm)
> > > +{
> > > +	return avic_alloc_physical_id_table(kvm);
> > 
> > Why is allocation being moved to svm_vcpu_precreate()?
> 
> This is because we want KVM_CAP_MAX_VCPU_ID to have been invoked by the 
> VMM, and that is guaranteed to be set by the time the first vCPU is 
> created. We restrict the AVIC physical ID table based on the maximum 
> number of vCPUs set by the VMM.
> 
> This mirrors how Intel VMX uses this capability. I will call this out 
> explicitly in the commit log.

Do it as a separate patch.  Then you pretty much *have* to write a changelog,
and the changes that are specific to 4k support are even more isolated.

