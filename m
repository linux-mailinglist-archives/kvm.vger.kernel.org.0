Return-Path: <kvm+bounces-51946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21DE2AFEB93
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97FD6564B5A
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED8C22E5403;
	Wed,  9 Jul 2025 14:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hvw/csdQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5972E3B1E
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752070155; cv=none; b=HOmh5inTaY2oVzCIdabfAhBXHYI2+Hiw30V1dtaWoN72P0UDzuR//X8Fd36yW6VxrZdgItMZ+rTJqIRrsQ+JqOUIbl4mnQLZeG4MAIo0+v8QkMEEgbrXzlDFJAY0auOLFFQEAd2fQ7YMY2GMFSBoQS5yczyKEDSRsDGl3nv6Mh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752070155; c=relaxed/simple;
	bh=u9ZCL26Udw7csZPMMP8KEX8jrLO4XNBGOHz68QbHy+I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OWCa4fjR9z+Zltd4xvKw09BA2W/mC8RF89v364TiGV/cjNGVazY6RXmhcdClbNOKGWbKjeIq0uQxemu7sFkARIEFmjEOz1QD9JDMkCuofG+Ic9TdBlr3gf0uvBt3iMkAGaDvXTlbBB3vN0Ng48zxsj6D4nKh+zGp7YgI6LokO5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hvw/csdQ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74b185fba41so4559111b3a.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 07:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752070153; x=1752674953; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t5tpTrrg2hny9/I7I2qzQrheZCqRZ5KWbbmlizq7TnU=;
        b=hvw/csdQcOW2edZ1v/B1i0Xk30K7Ks+5iCIa3+u/MpiwN++sSvnsE8TnSeBARb+r6k
         8CUe12Kp9H0yvK6RsSh1gL9GgQiMUQq5gSrt29+t6s8GW3AJbDmYvi63zL3Zzdk1PkfM
         +x1CdfYk0/oNraFjxdzx7Y19pnc66hA05dyjMO4wIG3+u6I5A1cukNXaOfvlTJfCypbc
         JFlwdCgNlp7owLrBMXbBGK56/uFg8lXP4qauNHYv9Q1IfsLMFBQC6IRi/JRItxD9dmjq
         VVDWdhGhZiEf1hEaYsuqLdbs3EmwiKZgDCi/olH+gFpyI8rCX6Qr44Iy1NQ9Jr46zE0e
         ttcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752070153; x=1752674953;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t5tpTrrg2hny9/I7I2qzQrheZCqRZ5KWbbmlizq7TnU=;
        b=maqdPzM1G9I2xTWx9KFpMwYB7qUtC4OtrDyYgrzSVIrXC8mT89DjeHEID7Xe9VbuMT
         ApRk+DR1E+ReLgM7fvNWchCKL+22f0oWd4ziLVAXV/9QFtJqHPo/0crzC6n3e8KFIEYQ
         QWqDLTSl5l2sNwkbzSSD8pwsU7ugbXiHjqWhsuHzmBkx5Qmv4D+pVywgsvmYUEZIzOX6
         etc2Qo0r4gTVspOQFw4pVwWknx7e9g5LJByn5h158v23wKYBqffaXja3H/xRhY68hgUI
         GVFrqU2CDOyvDvcOWO6o2kckkWf3Lj0Y6Zh46mkC+VDpjIhWosCgdSlo4vrxuhRDBtmt
         V1VA==
X-Forwarded-Encrypted: i=1; AJvYcCXHZNJPmGR8lY2wVXDC408QhenMLrmCC2cdWzPaGiPVNdAe9OtJIRP8zhUrIHYrrK1Bozk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOhQfo/EJBHXxlq404v5jsw9/kaHPhTfGASX7bCiObSo/+Ng8y
	kYma3fe3+pAN6BngFIZCh0+hdW3HlXGxduoLaa0N8r9+grrzS24JDIYbqwPEJdiQ0rBhKAlzJVP
	dJtIoTA==
X-Google-Smtp-Source: AGHT+IHDb9Dv+1va9PvqDCQHLOYKAmeY56qPvJ4RxAeantsKZ8J12hViLyDpj1gcR3GtO9OpwmQWTNCFJms=
X-Received: from pfbcp14.prod.google.com ([2002:a05:6a00:348e:b0:746:279c:7298])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:14d6:b0:746:298e:4ed0
 with SMTP id d2e1a72fcca58-74ea6641bd6mr4374759b3a.13.1752070153115; Wed, 09
 Jul 2025 07:09:13 -0700 (PDT)
Date: Wed, 9 Jul 2025 07:09:11 -0700
In-Reply-To: <20250709033242.267892-5-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-5-Neeraj.Upadhyay@amd.com>
Message-ID: <aG54B8frrerb0pn4@google.com>
Subject: Re: [RFC PATCH v8 04/35] KVM: x86: Rename VEC_POS/REG_POS macro usages
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Neeraj Upadhyay wrote:
> @@ -736,12 +735,12 @@ EXPORT_SYMBOL_GPL(kvm_apic_clear_irr);
>  
>  static void *apic_vector_to_isr(int vec, struct kvm_lapic *apic)
>  {
> -	return apic->regs + APIC_ISR + REG_POS(vec);
> +	return apic->regs + APIC_ISR + APIC_VECTOR_TO_REG_OFFSET(vec);
>  }
>  
>  static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
>  {
> -	if (__test_and_set_bit(VEC_POS(vec), apic_vector_to_isr(vec, apic)))
> +	if (__test_and_set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), apic_vector_to_isr(vec, apic)))
>  		return;
>  
>  	/*
> @@ -784,7 +783,7 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
>  
>  static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
>  {
> -	if (!__test_and_clear_bit(VEC_POS(vec), apic_vector_to_isr(vec, apic)))
> +	if (!__test_and_clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), apic_vector_to_isr(vec, apic)))
>  		return;
>  
>  	/*

Almost forgot.  I'd prefer to wrap these two, i.e.

	if (__test_and_set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec),
			       apic_vector_to_isr(vec, apic)))
		return;

and

	if (!__test_and_clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec),
				  apic_vector_to_isr(vec, apic)))
		return;

