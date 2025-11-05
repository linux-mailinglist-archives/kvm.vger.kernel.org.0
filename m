Return-Path: <kvm+bounces-62113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42653C37A20
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 21:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A10F3A8EC0
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 20:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3283446A8;
	Wed,  5 Nov 2025 20:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fKoyvWoE"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD38232938B
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 20:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762373072; cv=none; b=EPTrVrXhUXMevgqQZ6UOZaxaxtQCLl+B3Zs15reJGMuzteIZl46Gz6Ebbb8VK+3StkoXJGrOpCnAs7nfoSXPqiuUXc2WuJVBVM065ESHd9LypoDeoZXmunVS8WPMmggvPUZ1r0TnXIaTnYOiP8IW9ENoA+i2IgGDfAnUtkS7uA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762373072; c=relaxed/simple;
	bh=mY7NO0+qU5X9V5PbwePYWzYmDJPdI94x5mJXLK2Pjd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZhkHGlr4yKtzDYfj09sdW8JLrG3HVlvJfVNmQoF5Rkw6lmziTTzYZ8IJoKGthv7Mc7ZJNC9qClrcqbYjB8tlIzX5Na/1hQ9or/Cfodkdf++zYPK2Il1vj2M3ln8k1L46bMVDOuUcBgyqzehLKmJsc+5qyWOfcFQkViwOHNNk/Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fKoyvWoE; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 5 Nov 2025 20:04:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762373066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7c3VKkhTGYq+wSgt8NGN39M9SWqcyVAMnzwEFySADl8=;
	b=fKoyvWoEsE9wcHIJ/+7f6q/bwXfBMBa6QeN3+/P4G9MGieNGdtfM2g4MYFK1txg+iCwKuq
	Gnl9JsTxpnKrN/CFYjgK00ihwObhQj/F6QaIz0x81qic/OsEPUKRqf1N03Soljpl2DrrhR
	3Ekugq6plrcAlpC61J9XGqnpw5H858U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel
Subject: Re: [PATCH 3/3] KVM: nSVM: Avoid incorrect injection of
 SVM_EXIT_CR0_SEL_WRITE
Message-ID: <ek624i3z4e4nwlk36h7frogzgiml47xdzzilu5zuhiyb5gk5eb@tr2a6ptojzyo>
References: <20251024192918.3191141-1-yosry.ahmed@linux.dev>
 <20251024192918.3191141-4-yosry.ahmed@linux.dev>
 <aQuqC6Nh4--OV0Je@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aQuqC6Nh4--OV0Je@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 05, 2025 at 11:48:27AM -0800, Sean Christopherson wrote:
> On Fri, Oct 24, 2025, Yosry Ahmed wrote:
> > When emulating L2 instructions, svm_check_intercept() checks whether a
> > write to CR0 should trigger a synthesized #VMEXIT with
> > SVM_EXIT_CR0_SEL_WRITE. However, it does not check whether L1 enabled
> > the intercept for SVM_EXIT_WRITE_CR0, which has higher priority
> > according to the APM (24593—Rev.  3.42—March 2024, Table 15-7):
> > 
> >   When both selective and non-selective CR0-write
> >   intercepts are active at the same time, the non-selective
> >   intercept takes priority. With respect to exceptions, the
> >   priority of this inter
> > 
> > Make sure L1 does NOT intercept SVM_EXIT_WRITE_CR0 before checking if
> > SVM_EXIT_CR0_SEL_WRITE needs to be injected.
> > 
> > Fixes: cfec82cb7d31 ("KVM: SVM: Add intercept check for emulated cr accesses")
> > Cc: stable@vger.kernel
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/svm.c | 16 +++++++++++++---
> >  1 file changed, 13 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 9ea0ff136e299..4f79c4d837535 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4533,12 +4533,22 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
> >  		if (info->intercept == x86_intercept_cr_write)
> >  			icpt_info.exit_code += info->modrm_reg;
> >  
> > +		/*
> > +		 * If the write is indeed to CR0, check whether the exit_code
> > +		 * needs to be converted to SVM_EXIT_CR0_SEL_WRITE. Intercepting
> > +		 * SVM_EXIT_WRITE_CR0 has higher priority than
> > +		 * SVM_EXIT_CR0_SEL_WRITE, so this is only relevant if L1 sets
> > +		 * INTERCEPT_SELECTIVE_CR0 but not INTERCEPT_CR0_WRITE.
> > +		 */
> >  		if (icpt_info.exit_code != SVM_EXIT_WRITE_CR0 ||
> 
> Oof, the existing is all kinds of confusing.  Even with your comment, it took me
> a few seconds to understand how/where the exit_code is being modified.  Eww.
> 
> Any objection to opportunistically fixing this up to the (completely untested)
> below when applying?

Looks good with a minor nit:

> 
> 		/*
> 		 * Adjust the exit code accordingly if a CR other than CR0 is
> 		 * being written, and skip straight to the common handling as
> 		 * only CR0 has an additional selective intercept.
> 		 */
> 		if (info->intercept == x86_intercept_cr_write && info->modrm_reg) {
> 			icpt_info.exit_code += info->modrm_reg;
> 			break;
> 		}
> 
> 		/*
> 		 * Convert the exit_code to SVM_EXIT_CR0_SEL_WRITE if L1 set
> 		 * INTERCEPT_SELECTIVE_CR0 but not INTERCEPT_CR0_WRITE, as the
> 		 * unconditional intercept has higher priority.
> 		 */

We only convert the exict_code to SVM_EXIT_CR0_SEL_WRITE if other
conditions are true below. So maybe "Check if the exit_code needs to be
converted to.."?

> 		if (vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_CR0_WRITE) ||
> 		    !(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_SELECTIVE_CR0)))
> 			break;
> 
> 
> > -		    info->intercept == x86_intercept_clts)
> > +		    vmcb12_is_intercept(&svm->nested.ctl,
> > +					INTERCEPT_CR0_WRITE) ||
> > +		    !(vmcb12_is_intercept(&svm->nested.ctl,
> > +					  INTERCEPT_SELECTIVE_CR0)))
> 
> Let these poke out.

Sure. Do you prefer a new version with this + your fixup above, or will
you fix them up while applying?

> 
> >  			break;
> >  
> > -		if (!(vmcb12_is_intercept(&svm->nested.ctl,
> > -					INTERCEPT_SELECTIVE_CR0)))
> > +		/* CLTS never triggers INTERCEPT_SELECTIVE_CR0 */
> > +		if (info->intercept == x86_intercept_clts)
> >  			break;
> >  
> >  		/* LMSW always triggers INTERCEPT_SELECTIVE_CR0 */
> > -- 
> > 2.51.1.821.gb6fe4d2222-goog
> > 

