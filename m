Return-Path: <kvm+bounces-65587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B3012CB0DAA
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 19:38:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7C53A3015AA1
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 18:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405B430276C;
	Tue,  9 Dec 2025 18:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NNFc7Z09"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6F422A7E4
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 18:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765305483; cv=none; b=Kp6OXAnB9efYFaM6gHYmNcmTsRiGE5CT3XKZCzcQADHiuT1JdaIbZn15kJba2p6Etq4q83jGN8Dl0hECn6jeZg5zzMEpJWPz3o+AICugjLVHe6/RrDKQzSagTmV7kpCpSHvyIOxjG0uKdCJLX1OlYI5fH7+Zh4xf7/XREv25SYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765305483; c=relaxed/simple;
	bh=ywyAFwBeTgGGkGrBxxbqDKIQ7Pi5YfHzmm3NeCu7/zk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lhSCXkCAN1Cdi1e+N6+d7UQG0d2mkzkdQJ4FUtDroXrdGWB7iC6Uau5XVpeas2zGGJOt2NeLyCncgKKvdj+5nCRGZ04e1BMolh0T05tWOHlNMTdhVpL9jV452JMi5XKBz9kRUJXIzZfmzm381JJNniuKdfSUhoALBY//SAqNseY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NNFc7Z09; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 9 Dec 2025 18:37:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765305479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d4ydV2vdKmB2QnHBNTSbm8jMTfAaXBi9QadtHt5Q/Tk=;
	b=NNFc7Z09JTCzz7zWuh2D0CR9R0/+ZBlTn4CSoLqFtXEt/kVj0VyXCV76nXytKbAF3WVjdV
	PSRJRXq5JGcwrU5HUEcUEBNU5FZPF6CyDpdz1ABvi7ruI4E5gbB4BOCoPcv8RKWH0Ah/bL
	5vDhQfgpgGORRsUyhPE5kjD0+ZQRL0w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 12/13] KVM: nSVM: Sanitize control fields copied from
 VMCB12
Message-ID: <lnfdbq433rp5d66tlgpllmdzftwzwkt4jdmhpqf354g7lz7wnv@yxofvwgcoycp>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-13-yosry.ahmed@linux.dev>
 <aThL9nUuZzZVoKi3@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aThL9nUuZzZVoKi3@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 09, 2025 at 08:19:02AM -0800, Sean Christopherson wrote:
> On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > Make sure all fields used from VMCB12 in creating the VMCB02 are
> > sanitized, such no unhandled or reserved bits end up in the VMCB02.
> > 
> > The following control fields are read from VMCB12 and have bits that are
> > either reserved or not handled/advertised by KVM: tlb_ctl, int_ctl,
> > int_state, int_vector, event_inj, misc_ctl, and misc_ctl2.
> > 
> > The following fields do not require any extra sanitizing:
> > - int_ctl: bits from VMCB12 are copied bit-by-bit as needed.
> > - misc_ctl: only used in consistency checks (particularly NP_ENABLE).
> > - misc_ctl2: bits from VMCB12 are copied bit-by-bit as needed.
> > 
> > For the remaining fields, make sure only defined bits are copied from
> > VMCB12 by defining appropriate masks where needed. The only exception is
> > tlb_ctl, which is unused, so remove it.
> > 
> > Opportunisitcally move some existing definitions in svm.h around such
> 
> Opportunistically.  But moot point, because please put such cleanups in a separate
> patch.  There are so many opportunistic cleanups in this patch that I genuinely
> can't see what's changing, and I don't have the patience right now to stare hard.

Fair enough.

> 
> Cleanups will making *related* changes are totally fine, e.g. bundling the use
> of PAGE_MASK in conjuction with changing the code to do "from->iopm_base_pa & ..."
> instead of "to->msrpm_base_pa &= ..." is fine, but those changes have nothing to
> do with the rest of the patch.
> 
> > that they are ordered by bit position, and cleanup ignoring the lower
> > bits of {io/msr}pm_base_pa in __nested_copy_vmcb_control_to_cache() by
> > using PAGE_MASK. Also, expand the comment about the ASID being copied
> > only for consistency checks.
> > 
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/include/asm/svm.h | 11 ++++++++---
> >  arch/x86/kvm/svm/nested.c  | 26 ++++++++++++++------------
> >  arch/x86/kvm/svm/svm.h     |  1 -
> >  3 files changed, 22 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > index a842018952d2c..44f2cfcd8d4ff 100644
> > --- a/arch/x86/include/asm/svm.h
> > +++ b/arch/x86/include/asm/svm.h
> > @@ -213,11 +213,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
> >  #define V_NMI_ENABLE_SHIFT 26
> >  #define V_NMI_ENABLE_MASK (1 << V_NMI_ENABLE_SHIFT)
> >  
> > +#define X2APIC_MODE_SHIFT 30
> > +#define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
> > +
> >  #define AVIC_ENABLE_SHIFT 31
> >  #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
> >  
> > -#define X2APIC_MODE_SHIFT 30
> > -#define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
> > +#define SVM_INT_VECTOR_MASK (0xff)
> >  
> >  #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
> >  #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
> > @@ -626,8 +628,11 @@ static inline void __unused_size_checks(void)
> >  #define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
> >  #define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
> >  
> > -#define SVM_EVTINJ_VALID (1 << 31)
> >  #define SVM_EVTINJ_VALID_ERR (1 << 11)
> > +#define SVM_EVTINJ_VALID (1 << 31)
> 
> If you want to do cleanup, these should all use BIT()...

I can do that.

> 
> > +
> > +#define SVM_EVTINJ_RESERVED_BITS ~(SVM_EVTINJ_VEC_MASK | SVM_EVTINJ_TYPE_MASK | \
> > +				   SVM_EVTINJ_VALID_ERR | SVM_EVTINJ_VALID)
> 
> Because then I don't have to think hard about what exactly this will generate.

Ack.

> 
> >  #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
> >  #define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 89830380cebc5..503cb7f5a4c5f 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -479,10 +479,11 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
> >  	for (i = 0; i < MAX_INTERCEPT; i++)
> >  		to->intercepts[i] = from->intercepts[i];
> >  
> > -	to->iopm_base_pa        = from->iopm_base_pa;
> > -	to->msrpm_base_pa       = from->msrpm_base_pa;
> > +	/* Lower bits of IOPM_BASE_PA and MSRPM_BASE_PA are ignored */
> > +	to->iopm_base_pa        = from->iopm_base_pa & PAGE_MASK;
> > +	to->msrpm_base_pa       = from->msrpm_base_pa & PAGE_MASK;
> > +
> >  	to->tsc_offset          = from->tsc_offset;
> > -	to->tlb_ctl             = from->tlb_ctl;
> >  	to->int_ctl             = from->int_ctl;
> >  	to->int_vector          = from->int_vector;
> >  	to->int_state           = from->int_state;
> > @@ -492,19 +493,21 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
> >  	to->exit_info_2         = from->exit_info_2;
> >  	to->exit_int_info       = from->exit_int_info;
> >  	to->exit_int_info_err   = from->exit_int_info_err;
> > -	to->misc_ctl          = from->misc_ctl;
> > +	to->misc_ctl		= from->misc_ctl;
> >  	to->event_inj           = from->event_inj;
> >  	to->event_inj_err       = from->event_inj_err;
> >  	to->next_rip            = from->next_rip;
> >  	to->nested_cr3          = from->nested_cr3;
> > -	to->misc_ctl2            = from->misc_ctl2;
> > +	to->misc_ctl2		= from->misc_ctl2;
> >  	to->pause_filter_count  = from->pause_filter_count;
> >  	to->pause_filter_thresh = from->pause_filter_thresh;
> >  
> > -	/* Copy asid here because nested_vmcb_check_controls will check it.  */
> > +	/*
> > +	 * Copy asid here because nested_vmcb_check_controls() will check it.
> > +	 * The ASID could be invalid, or conflict with another VM's ASID , so it
> > +	 * should never be used directly to run L2.
> > +	 */
> >  	to->asid           = from->asid;
> > -	to->msrpm_base_pa &= ~0x0fffULL;
> > -	to->iopm_base_pa  &= ~0x0fffULL;
> >  
> >  #ifdef CONFIG_KVM_HYPERV
> >  	/* Hyper-V extensions (Enlightened VMCB) */
> > @@ -890,9 +893,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> >  		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
> >  		(vmcb01->control.int_ctl & int_ctl_vmcb01_bits);
> >  
> > -	vmcb02->control.int_vector          = svm->nested.ctl.int_vector;
> > -	vmcb02->control.int_state           = svm->nested.ctl.int_state;
> > -	vmcb02->control.event_inj           = svm->nested.ctl.event_inj;
> > +	vmcb02->control.int_vector          = svm->nested.ctl.int_vector & SVM_INT_VECTOR_MASK;
> > +	vmcb02->control.int_state           = svm->nested.ctl.int_state & SVM_INTERRUPT_SHADOW_MASK;
> > +	vmcb02->control.event_inj           = svm->nested.ctl.event_inj & ~SVM_EVTINJ_RESERVED_BITS;
> >  	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
> >  
> >  	/*
> > @@ -1774,7 +1777,6 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
> >  	dst->msrpm_base_pa        = from->msrpm_base_pa;
> >  	dst->tsc_offset           = from->tsc_offset;
> >  	dst->asid                 = from->asid;
> > -	dst->tlb_ctl              = from->tlb_ctl;
> >  	dst->int_ctl              = from->int_ctl;
> >  	dst->int_vector           = from->int_vector;
> >  	dst->int_state            = from->int_state;
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index ef6bdce630dc0..c8d43793aa9d6 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -178,7 +178,6 @@ struct vmcb_ctrl_area_cached {
> >  	u64 msrpm_base_pa;
> >  	u64 tsc_offset;
> >  	u32 asid;
> > -	u8 tlb_ctl;
> >  	u32 int_ctl;
> >  	u32 int_vector;
> >  	u32 int_state;
> > -- 
> > 2.51.2.1041.gc1ab5b90ca-goog
> > 

