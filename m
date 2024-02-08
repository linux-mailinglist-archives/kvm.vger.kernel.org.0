Return-Path: <kvm+bounces-8357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB1B584E6C3
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 18:28:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86D832958B0
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 17:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B304286AFF;
	Thu,  8 Feb 2024 17:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gn175dGl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B42D85C7F
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 17:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707413227; cv=none; b=Z3g64y+Qc6UWdk52xFgdwxGSds9CWkDLRxvJhVeezIWDg0CxyVi6HTjE8ph4rheKjn162M3jfU01afcSM1i5WQwqvpCBKsA9fj6o+DDzCa6XYFRlTB2kmyd0ogiKnfP54zGGCTIfoixz3zCGrkJ7+YMEXbZvKZUsWoOm2+boPeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707413227; c=relaxed/simple;
	bh=sx6KhQk9Is/4dxTU8a0rjN3JOBcYjPFn14qRnNkA5SY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m0bDt3AVujfCpxtwEX45aaW8GvZtJt8MQyHyuj4h9WQIb+RPZzimhJjv36EayjwVT68Fu8loKVEuydP2DJJcZGkfylUIi+197qzJBj9LdD04KPDsTpBwPcwiNvvcIPMpZyBBamdWc2dIjYyNCLIq9cbC8ndkpwtmn+TDSavIQCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gn175dGl; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e0783cd249so72845b3a.0
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 09:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707413224; x=1708018024; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gBwp2cY+kDK1oMSufcYCS0Brw297vTH+3c3ODiiUoog=;
        b=Gn175dGli9LztjZ+EVogEBA46VYuRBuiuZ4zQYf0EVSw8NFYfO/rGT1H8cFWX/5aVE
         U1ykf89PUDhWzmLxcblWZIpkvewo+/sszS80JcQnsl0vOX1+2MejjTBe2rU0fa2lR2/+
         qPAPbn5+weGildRfWjvYbrsrKP8OybaRpOVE5hQ+beBS6nuUkj8R2XSAOLvnoqiL++MC
         cNjBWWFIGPR9wmoxqOFw7FQvMur61sOxID6kjJqQkv0MOK+y6P3UMawwO6D1tJ44boJn
         6RDI0Fd00H2tx1CEIXuRVnqo0h7+AZbSi2HVbEazMVZzLd1SS6KPJvDMFWlpRVb3cx0Q
         NCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707413224; x=1708018024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gBwp2cY+kDK1oMSufcYCS0Brw297vTH+3c3ODiiUoog=;
        b=Snzhqjw70kx1D1CuzLWgoJJBraOTp/HJGuzMkfhQKpXGGaQvC/hu5FxG+aDM9G1aeS
         a1pCJmZNCxQk5RYv8iI4Xv4ui4rZJubPBg7B8wvH3HxZ4qjjEudm1CN5umRiBGTuHk4k
         pHkq8on3iDE6AfOpOmQSrmvnePkEKem6oG2b+xdMxRjYyXuvXrLXmmO4JPRnpV3kMcax
         kTmb4LL+g4AQmNS5q5u509eWVQp7E9BdOgQpSGw3AZ7IVjNCFlHTYDtnuFuQEGAS8UXd
         stsHjsG2x3k7YueISheaCqlZ22sQcUn3J5+4GIH45qFrexGwoqcJu9jWCFJNcNyKyxfK
         zIsA==
X-Gm-Message-State: AOJu0Yylrf2hmNki9AQtVPSunDN2hheM32itQ4KnLBLM+Uz8phxbKVEO
	addIfwmIsqsoK/9R93GxNPl47Pl9m9rO87kNmur93pUPhp1cEKNnuLbLrVFvKiwqnDCi3p1X74v
	ELQ==
X-Google-Smtp-Source: AGHT+IF6y2Fj9Q0xzklv4qNxJB4M0iqYnYF4z+RAImjVdV5uh7OyzZLHK0LW86J/FLUDUS/+nQQagI/rkCc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2281:b0:6df:e3d1:dd0f with SMTP id
 f1-20020a056a00228100b006dfe3d1dd0fmr365573pfe.4.1707413224273; Thu, 08 Feb
 2024 09:27:04 -0800 (PST)
Date: Thu, 8 Feb 2024 09:27:02 -0800
In-Reply-To: <20240208002420.34mvemnzrwwsaesw@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231016115028.996656-1-michael.roth@amd.com> <20231016115028.996656-9-michael.roth@amd.com>
 <ZbmenP05fo8hZU8N@google.com> <20240208002420.34mvemnzrwwsaesw@amd.com>
Message-ID: <ZcUO5sFEAIH68JIA@google.com>
Subject: Re: [PATCH RFC gmem v1 8/8] KVM: x86: Determine shared/private faults
 based on vm_type
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, pbonzini@redhat.com, isaku.yamahata@intel.com, 
	ackerleytng@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	nikunj.dadhania@amd.com, jroedel@suse.de, pankaj.gupta@amd.com, 
	thomas.lendacky@amd.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 07, 2024, Michael Roth wrote:
> On Tue, Jan 30, 2024 at 05:13:00PM -0800, Sean Christopherson wrote:
> > On Mon, Oct 16, 2023, Michael Roth wrote:
> > > For KVM_X86_SNP_VM, only the PFERR_GUEST_ENC_MASK flag is needed to
> > > determine with an #NPF is due to a private/shared access by the guest.
> > > Implement that handling here. Also add handling needed to deal with
> > > SNP guests which in some cases will make MMIO accesses with the
> > > encryption bit.
> > 
> > ...
> > 
> > > @@ -4356,12 +4357,19 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> > >  			return RET_PF_EMULATE;
> > >  	}
> > >  
> > > -	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> > > +	/*
> > > +	 * In some cases SNP guests will make MMIO accesses with the encryption
> > > +	 * bit set. Handle these via the normal MMIO fault path.
> > > +	 */
> > > +	if (!slot && private_fault && kvm_is_vm_type(vcpu->kvm, KVM_X86_SNP_VM))
> > > +		private_fault = false;
> > 
> > Why?  This is inarguably a guest bug.
> 
> AFAICT this isn't explicitly disallowed by the SNP spec.

There are _lots_ of things that aren't explicitly disallowed by the APM, that
doesn't mean that _KVM_ needs to actively support them.

I am *not* taking on more broken crud in KVM to workaround OVMF's stupidity, the
KVM_X86_QUIRK_CD_NW_CLEARED has taken up literally days of my time at this point.

> So KVM would need to allow for these cases in order to be fully compatible
> with existing SNP guests that do this.

No.  KVM does not yet support SNP, so as far as KVM's ABI goes, there are no
existing guests.  Yes, I realize that I am burying my head in the sand to some
extent, but it is simply not sustainable for KVM to keep trying to pick up the
pieces of poorly defined hardware specs and broken guest firmware.

> > > +static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 err)
> > > +{
> > > +	bool private_fault = false;
> > > +
> > > +	if (kvm_is_vm_type(kvm, KVM_X86_SNP_VM)) {
> > > +		private_fault = !!(err & PFERR_GUEST_ENC_MASK);
> > > +	} else if (kvm_is_vm_type(kvm, KVM_X86_SW_PROTECTED_VM)) {
> > > +		/*
> > > +		 * This handling is for gmem self-tests and guests that treat
> > > +		 * userspace as the authority on whether a fault should be
> > > +		 * private or not.
> > > +		 */
> > > +		private_fault = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
> > > +	}
> > 
> > This can be more simply:
> > 
> > 	if (kvm_is_vm_type(kvm, KVM_X86_SNP_VM))
> > 		return !!(err & PFERR_GUEST_ENC_MASK);
> > 
> > 	if (kvm_is_vm_type(kvm, KVM_X86_SW_PROTECTED_VM))
> > 		return kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
> > 
> 
> Yes, indeed. But TDX has taken a different approach for SW_PROTECTED_VM
> case where they do this check in kvm_mmu_page_fault() and then synthesize
> the PFERR_GUEST_ENC_MASK into error_code before calling
> kvm_mmu_do_page_fault(). It's not in the v18 patchset AFAICT, but it's
> in the tdx-upstream git branch that corresponds to it:
> 
>   https://github.com/intel/tdx/commit/3717a903ef453aa7b62e7eb65f230566b7f158d4
> 
> Would you prefer that SNP adopt the same approach?

Ah, yes, 'twas my suggestion in the first place.  FWIW, I was just reviewing the
literal code here and wasn't paying much attention to the content.

https://lore.kernel.org/all/f474282d701aca7af00e4f7171445abb5e734c6f.1689893403.git.isaku.yamahata@intel.com

