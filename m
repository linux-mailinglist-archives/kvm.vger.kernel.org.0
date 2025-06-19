Return-Path: <kvm+bounces-49970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7C4FAE0517
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 14:09:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A8653AF67B
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 12:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D329023B623;
	Thu, 19 Jun 2025 12:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1Q3A8RC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DF3221FDF;
	Thu, 19 Jun 2025 12:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750334713; cv=none; b=VHm8htiHPMNlQp31180EJRogRIUcJrWIB8nRtgFO0CrjN+TWyp5KGHm5sYjZszrXHc5YJ/gESi+LlrZHKwXVBLlPF2sjsytcanZYBNYsqNwdSDNsq8oHuqRgNeIFLriAILmjKg5EriuYimUuLkZgVXklG5BcdDKD735ewdz0AHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750334713; c=relaxed/simple;
	bh=MunQ7b3vU7ftVz8YaGhqxMkxEggblwQtVf1vjF4zllU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZKd6QRfGhMLjotIRVlRydxIx5+A0ZRVpSH2sApxST5QTmyj1wrsmCrjo9mfWmB5nTWjW8HZdCQxD2Xws9now7xeRbosDT8ZXzDpiTFa3pUqjcSzI7Jr5lLH3EnO8J0jQvYrflB4xMpbDMebFOmhA6C1GRUReXU3oeXsNCUMrjlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1Q3A8RC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9235EC4CEEA;
	Thu, 19 Jun 2025 12:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750334712;
	bh=MunQ7b3vU7ftVz8YaGhqxMkxEggblwQtVf1vjF4zllU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m1Q3A8RCpduNXFnV1EPgCHLC9lFs/gD7zgVnx+w5hK9aQCHLcxE/5v5kKlafYvKOR
	 fv11q1LKEieqxfDcNuftuxAJyk26/kCIlycJcf0bKS8u2uycArEG2sSyc6rtuwYoe3
	 pi4j2i2NqKO/EsSQs1IkvdpDAIHT7B+gtxnX+hOCoJ4P0iX82AY4Gwq5IsvNCU48/H
	 V1T287pkyxSnVzPkzrONol9U9ParA/pnUU+HRSpRVdsv8wfbYj7RR4Guf7fAnmdFOp
	 eZTEzn6COjyNsbq8c7qE6VbyhnYRbr1DispP+jA8oO2nM7/7lGuuC58AfTMN8DvxCM
	 +WMTvjs3CWfYw==
Date: Thu, 19 Jun 2025 17:31:04 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 17/62] KVM: SVM: Add enable_ipiv param, never set
 IsRunning if disabled
Message-ID: <fpb6l3xwyksd7s5izmrhr4hfrkmfeavbgfatokgl5sdeh75mtx@f6gcad774zeh>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-19-seanjc@google.com>
 <2eqjnjnszlmhlnvw6kcve4exjnpy7skguypwtmxutb2gecs3an@gcou53thsqww>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2eqjnjnszlmhlnvw6kcve4exjnpy7skguypwtmxutb2gecs3an@gcou53thsqww>

On Thu, Jun 19, 2025 at 05:01:30PM +0530, Naveen N Rao wrote:
> On Wed, Jun 11, 2025 at 03:45:20PM -0700, Sean Christopherson wrote:
> > @@ -1030,7 +1047,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
> >  	 * can't be scheduled out and thus avic_vcpu_{put,load}() can't run
> >  	 * recursively.
> >  	 */
> > -	entry = READ_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id]);
> > +	entry = svm->avic_physical_id_entry;
> >  
> >  	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
> >  	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
> > @@ -1049,7 +1066,10 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
> >  	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
> >  
> >  	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
> > -	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
> > +	svm->avic_physical_id_entry = entry;
> > +
> > +	if (enable_ipiv)
> > +		WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
> 
> If enable_ipiv is false, then isRunning bit will never be set and we 
> would have bailed out earlier. So, the check for enable_ipiv can be 
> dropped here (or converted into an assert).

Ignore this, I got this wrong, sorry. The earlier check is against the 
local copy of the physical ID table entry, which will indeed have 
isRunning set so this is all good.

- Naveen


