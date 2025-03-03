Return-Path: <kvm+bounces-39921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5294A4CC01
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 20:32:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9D1A1894F04
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 19:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C32D22E002;
	Mon,  3 Mar 2025 19:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PHDWKAHp"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584B122DF8D
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 19:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741030318; cv=none; b=C5xxcU518oXBLKOE+TFqXCOxcsNGcSzEHJZWy88JTAR2NRtwqr3wQ+8YZJhxgPDkOiUg0nyYn/L8hmxGB8KZAyFXhrx4voyEl6DehaWxQ68lj70GehGgWcUt5s5Mg4T6KsV/YPeypq4D+hAK7jIImg/3dExk6tUl0qPmz6YMRGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741030318; c=relaxed/simple;
	bh=uSGvfjovsdfyUdu7wuGY4zvu92LIyoDYDeUyoexzOlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5shzLPkqbkajW1w+nHMTQ1HfTo7MBAKz/+SCBf3hrdpOq+mp14lh10AsuojTI6cAcNKWA15+e4jswFGXbuwWtwoZAczKoZZ0LxiYmLjZOsFT9hkVu/6qLIjJxtO1thbaxT+oMDil82DIS2qDzlmmECi1Yxqxgv/nzfpUGewKuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PHDWKAHp; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 3 Mar 2025 19:31:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741030314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9y+r94mPtFlrPqF8gB/c1m2hma3BlLx4QJpsnidFoZU=;
	b=PHDWKAHpgxrRvyweDUVEAPf4YvRGU6e2CndYm/KTctHnfwh5xr02jFubFFCuGKs7E7J9vH
	KX3VBNBqjUXTTx/hQ4P2CtFekXiTyQUHn+FAx3MZwmM2dS4MV9uu+scGSd5KaXHOTiYCr0
	5ypchNz96dc86qdUrH6oAWX2TeAZeuk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/13] KVM: nSVM: Track the ASID per-VMCB
Message-ID: <Z8YDpocIkdUn8LCU@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
 <20250205182402.2147495-2-yosry.ahmed@linux.dev>
 <7addde721e3f67bfa8ec5c9671f51d131f84bc6b.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7addde721e3f67bfa8ec5c9671f51d131f84bc6b.camel@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 28, 2025 at 08:23:48PM -0500, Maxim Levitsky wrote:
> On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> > The ASID is currently tracked per-vCPU, because the same ASID is used by
> > L1 and L2. That ASID is flushed on every transition between L1 and L2.
> > 
> > Track the ASID separately for each VMCB (similar to the
> > asid_generation), giving L2 a separate ASID. This is in preparation for
> > doing fine-grained TLB flushes on nested transitions instead of
> > unconditional full flushes.
> > 
> > The ASIDs are still not fully maintained (e.g. a remote flush will only
> > flush the current ASID), so keep the TLB flush on every transition until
> > this is sorted out.
> > 
> > L1's ASID will be flushed on KVM_REQ_TLB_FLUSH_GUEST if it is the
> > active context, so remove the TODO in nested_svm_transition_tlb_flush()
> > about it.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c |  1 -
> >  arch/x86/kvm/svm/sev.c    |  2 +-
> >  arch/x86/kvm/svm/svm.c    | 12 +++++++-----
> >  arch/x86/kvm/svm/svm.h    |  2 +-
> >  4 files changed, 9 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 04c375bf1ac2a..bbe4f3ac9f250 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -495,7 +495,6 @@ static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
> >  	 *  - Honor L1's request to flush an ASID on nested VMRUN
> >  	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
> >  	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
> > -	 *  - Flush L1's ASID on KVM_REQ_TLB_FLUSH_GUEST
> >  	 *
> >  	 * [*] Unlike nested EPT, SVM's ASID management can invalidate nested
> >  	 *     NPT guest-physical mappings on VMRUN.
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 799f8494b599c..b0adfd0537d00 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -3468,7 +3468,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
> >  	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
> >  
> >  	/* Assign the asid allocated with this SEV guest */
> > -	svm->asid = asid;
> > +	svm->current_vmcb->asid = asid;
> >  
> >  	/*
> >  	 * Flush guest TLB:
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 7640a84e554a6..08340ae57777b 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1335,8 +1335,10 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
> >  		save->g_pat = vcpu->arch.pat;
> >  		save->cr3 = 0;
> >  	}
> > -	svm->current_vmcb->asid_generation = 0;
> > -	svm->asid = 0;
> > +	svm->vmcb01.asid_generation = 0;
> > +	svm->vmcb01.asid = 0;
> > +	svm->nested.vmcb02.asid_generation = 0;
> > +	svm->nested.vmcb02.asid = 0;
> >  
> >  	svm->nested.vmcb12_gpa = INVALID_GPA;
> >  	svm->nested.last_vmcb12_gpa = INVALID_GPA;
> > @@ -1988,7 +1990,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
> >  	}
> >  
> >  	svm->current_vmcb->asid_generation = sd->asid_generation;
> > -	svm->asid = sd->next_asid++;
> > +	svm->current_vmcb->asid = sd->next_asid++;
> >  }
> >  
> >  static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
> > @@ -4235,8 +4237,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
> >  
> >  	sync_lapic_to_cr8(vcpu);
> >  
> > -	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
> > -		svm->vmcb->control.asid = svm->asid;
> > +	if (unlikely(svm->current_vmcb->asid != svm->vmcb->control.asid)) {
> > +		svm->vmcb->control.asid = svm->current_vmcb->asid;
> >  		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
> >  	}
> >  	svm->vmcb->save.cr2 = vcpu->arch.cr2;
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 9d7cdb8fbf872..ebbb0b1a64676 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -133,6 +133,7 @@ struct kvm_vmcb_info {
> >  	unsigned long pa;
> >  	int cpu;
> >  	uint64_t asid_generation;
> > +	u32 asid;
> >  };
> >  
> >  struct vmcb_save_area_cached {
> > @@ -247,7 +248,6 @@ struct vcpu_svm {
> >  	struct vmcb *vmcb;
> >  	struct kvm_vmcb_info vmcb01;
> >  	struct kvm_vmcb_info *current_vmcb;
> > -	u32 asid;
> >  	u32 sysenter_esp_hi;
> >  	u32 sysenter_eip_hi;
> >  	uint64_t tsc_aux;
> 
> Hi,
> 

Hi,

Thanks for taking a look! 

> 
> I think it should be possible to eliminate separate ASID field (current_vmcb->asid/svm->asid)
> completely and instead just use the value stored in the vmcb.
> 
> When there is a need to update it, KVM can also set the corresponding dirty bit
> as done in svm_vcpu_run (new_asid also already does this when the asid generation increases)
> 
> Also KVM already sets the tlb_ctl directly in the vmcb.
> 
> What do you think?

Yeah I think we can do that, although if we go with Sean's suggestion of
a per VM or a per vCPU ASID, this will change anyway. If we use a per
vCPU ASID, I think it would be nice to have it directly in svm->asid and
svm->nested.asid02 to be consistent with VMX.

I will see how the code turns out to be after taking Sean's suggestion
and go from there.

