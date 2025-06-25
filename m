Return-Path: <kvm+bounces-50680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B01EAE8363
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:57:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C033A4A6BD7
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 12:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 657662620C6;
	Wed, 25 Jun 2025 12:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OxtAGA5L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F282620C8
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 12:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750856009; cv=none; b=g24B9u1NTvQZG326wRLL+MYQ/1FqKqUUqXDUP4wf9Jetzsa+lQzOhVFwtYfBBTaHoXExjBi7S8OaqDHtqq5QTdNQmT8/XKXMqASQmTgfI+k4oUwI7XOAnzKdrVqhM4B8W0dULfmy8SspRFQmLH4gNeXDN4FFtkWkvZn34+2aqgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750856009; c=relaxed/simple;
	bh=LyYQDcnXmGsVu73bpfzmTVDLBrEXLKs1lCcXT5WkdYU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ErfXmfHTdH1PGaGrZKAx0k+b2LXa3zZPepVKZgFmXk7KcnjB6sug5b8e90MUMrrrnm/oLyaUkHv7vIwP77EUDTwBtFSyu+B1SkR5zMhUngiIEOxYKqFOomFaeo7Fm+mINiV5dxpHcZh5XncZVtpUR0zloVsiyAy01oiC/QtBjlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OxtAGA5L; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2356ce55d33so25785745ad.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 05:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750856007; x=1751460807; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qm9UdCmx0AUjdXCDjy0dtaSU1yfF/6cv13NPsG0xoPg=;
        b=OxtAGA5LpfPL2vRuPmjdvZ7zVnn59HhhsUiL8FIsXqJRLO9Cc5nrrTiy6F4g92OxJa
         zVPdPo0f1m5O4Ix5vHfhg2brORVyqSNuRdtOd0zFMedqOpFo+yLRuVZIkUPKZSgpFLUX
         9aUQs75xPjeBX+95fV1qwEYZ0KuuieKZ/m1u0pecY419oQM+rdi65CQlA9XtvLiuyGkU
         H5Wtf9iLyjxLK9ZwPw8PFQAgIqOUqJjUowa9iFHaMcyfDFqrUo9KyEe7FojwSetAxYPX
         HRXxKA7vxeFSiFIJPQtfvM+z8BnT1eBVidaKnHYwBs72SVHVJEQbzaDYSXHOTOTSmRl0
         9Q7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750856007; x=1751460807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qm9UdCmx0AUjdXCDjy0dtaSU1yfF/6cv13NPsG0xoPg=;
        b=vgU2eEwwNP/5CUzZvZhzog7RF0a9dzcMv+I0JunWOml4WSLqp6Ok5XzIJhwuACv9pg
         fedE/WR7EtjvX8JlnCOqRDlH+w+Kp0oUx+sdwPLGHNmmytDOYQmXsuidWm0h6yMu6NJ9
         mezSnFrIsKqKkRrU54mnJgEhyNFXozhkG6OP0GAtYa6sgFO69I3FGNebGLHEgAnBMR0H
         o3NFpqGcbUVynElw+hFDPr6fHrfOS75OzU6qYjLD9YaiTZvhBguaycei9nGS/wKHai5Q
         743pGkRVLcSraP1Q94X/YBuP3CZEMyGOgrOnVgO2yS7vQwrZW/55ujdrdUZITX3+yOiN
         Qx9w==
X-Forwarded-Encrypted: i=1; AJvYcCXGuIoHZrcrI1X162p/GnUCSVlUWmQ8JIImAjeEsQWbxZzluouT7exakTcsN+N/K70Kpgw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwalBBn1XOVVGnpVa3TDvfweMsjmuxFV2LAEXPyNw45SvvM4Lgx
	oq3v7Wi6zI28KV4xK7bCgp8PomzkKxclGDn/wojLorbfMi0DsnJzuOlj9VY6D2Doi3nmCj4Fy3R
	O/SBSgg==
X-Google-Smtp-Source: AGHT+IFkzNNA6kVoA+2D6FAE4AOHOnEwMQn/97TNwefolAE17lsZ+t6y3XTUeyFLF/Yx7w++6g2MSRnkPqg=
X-Received: from plbmv13.prod.google.com ([2002:a17:903:b8d:b0:235:54f:4f12])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2bcc:b0:235:5a9:976f
 with SMTP id d9443c01a7336-23824030ccdmr68655075ad.24.1750856007263; Wed, 25
 Jun 2025 05:53:27 -0700 (PDT)
Date: Wed, 25 Jun 2025 05:53:25 -0700
In-Reply-To: <20250610175424.209796-2-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com> <20250610175424.209796-2-Neeraj.Upadhyay@amd.com>
Message-ID: <aFvxRctwWEtRde08@google.com>
Subject: Re: [RFC PATCH v7 01/37] KVM: lapic: Remove __apic_test_and_{set|clear}_vector()
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	francescolavra.fl@gmail.com, tiala@microsoft.com
Content-Type: text/plain; charset="us-ascii"

"KVM: x86:" for the scope.  That goes for all of the relevant shortlogs.

And for this one in particular, maybe something like:

  KVM: x86: Open code setting/clearing of bits in the ISR

because seeing "Remove" in the shortlog reads like it's a straight deletion of
code.

On Tue, Jun 10, 2025, Neeraj Upadhyay wrote:
> Remove __apic_test_and_set_vector() and __apic_test_and_clear_vector(),
> because the _only_ register that's safe to modify with a non-atomic
> operation is ISR, because KVM isn't running the vCPU, i.e. hardware can't
> service an IRQ or process an EOI for the relevant (virtual) APIC.
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> [Neeraj: Add "inline" for apic_vector_to_isr()]
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v6:
> 
>  - New change.
> 
>  arch/x86/kvm/lapic.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 73418dc0ebb2..11e57f351ce5 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -125,16 +125,6 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
>  		apic_test_vector(vector, apic->regs + APIC_IRR);
>  }
>  
> -static inline int __apic_test_and_set_vector(int vec, void *bitmap)
> -{
> -	return __test_and_set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> -}
> -
> -static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
> -{
> -	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> -}
> -
>  __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
>  EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
>  
> @@ -744,9 +734,14 @@ void kvm_apic_clear_irr(struct kvm_vcpu *vcpu, int vec)
>  }
>  EXPORT_SYMBOL_GPL(kvm_apic_clear_irr);
>  
> +static inline void *apic_vector_to_isr(int vec, struct kvm_lapic *apic)

<formletter>

Do not use "inline" for functions that are visible only to the local compilation
unit.  "inline" is just a hint, and modern compilers are smart enough to inline
functions when appropriate without a hint.

A longer explanation/rant here: https://lore.kernel.org/all/ZAdfX+S323JVWNZC@google.com

</formletter>

Ignoring the existing code below, there's lots of crusty old code in KVM (that
isn't "bad" per se, i.e. isn't worth fixing unless a prime opportunity arises).

> +{
> +	return apic->regs + APIC_ISR + REG_POS(vec);
> +}
> +
>  static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
>  {
> -	if (__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
> +	if (__test_and_set_bit(VEC_POS(vec), apic_vector_to_isr(vec, apic)))
>  		return;
>  
>  	/*
> @@ -789,7 +784,7 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
>  
>  static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
>  {
> -	if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
> +	if (!__test_and_clear_bit(VEC_POS(vec), apic_vector_to_isr(vec, apic)))
>  		return;
>  
>  	/*
> -- 
> 2.34.1
> 

