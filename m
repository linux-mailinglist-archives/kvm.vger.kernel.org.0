Return-Path: <kvm+bounces-36149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D79AA181FD
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CD9B1884B3D
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D300B1F4730;
	Tue, 21 Jan 2025 16:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PBaYFN5R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0A91F1527
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 16:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737476973; cv=none; b=NJCsEJx8mNnsSRc8j6tzyxEG1C/wcvTD5UI0yXvRUS56F9ONBE2iMlynpZe9heTE8t2Sgi7R5IfYuupn2coLw3tqe1Qg2U32VnpwRbloEOf0QdY06FKNLoO/H09TTu6L/qkkQ+ProTeTwsm0trVVmfiCJGEcMTIjPrlIR5scWgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737476973; c=relaxed/simple;
	bh=lvhAgMr1qLIw0C+KjhXTlOOlZ4f8ZXmXmQaQg4vArmk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IUnUhKotNG0KwkNRaepKyUkaXHb8HwWD8KmI0DQZn+1GbPpCKb6Cs8pY8XYETbu9LETDKmjgvGDfXX9jnxpi9zTDzrRFACR52moednMyJFE4OFZj6DWebCz3UEcLYo+XbX6yYe32w3V+Kw/morPrCu14oJefKMJHioUA9pzwXd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PBaYFN5R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737476970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FmmBH81f6hVHBomfe2UGheR/yM/UTiXDoOohLBQeYlA=;
	b=PBaYFN5RxEA6XY28zOcvdPhhdcDxpQOgIkeBHRlqx3Q6K0JCWKEwuFzmmDB0VrT0BoXj0R
	ofGkvLBgBKK19JPQtSPtPp+0McI9rBYA6hFC5aEF6/Am3RumzWDu5SgOu3Ltlrusf4oWsQ
	gWZ606Xy8vapTNAcjE8dvQzj2KYpT5A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-BMIc0hOVPnOpMXTVDWlRww-1; Tue, 21 Jan 2025 11:29:29 -0500
X-MC-Unique: BMIc0hOVPnOpMXTVDWlRww-1
X-Mimecast-MFC-AGG-ID: BMIc0hOVPnOpMXTVDWlRww
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38634103b0dso3622108f8f.2
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 08:29:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737476968; x=1738081768;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FmmBH81f6hVHBomfe2UGheR/yM/UTiXDoOohLBQeYlA=;
        b=u+5mZ/5/hVQqnnWITCGuxiT/Tavo64tULBbVsHDZ1bUuThRINtwcth4AVw3c7Eh8PA
         RhIwVE3hXb68konlFwLgJKJYhQSrykyUzAEzI/1c6Ki/casFi6AYwQL492wOuIQOjxdC
         5gcoDqT9xAYAxb40DC0XShOheJXd9JLPNPLRdupXO3cHxf6XcAI7eny1fXcLTEDxLLN6
         C+54qwVBjWgprzmq7eqSCMlYN6FL1pGeHCsval+3ENNfWgNMp81AZcg/lk7uN9/szNID
         GJNof/UuGCIyIpIX0X73JPKgTY9DtDp6pTpnF96Z0o+KX9END2Z/aQJi3ywQREyZVs2+
         ffXw==
X-Forwarded-Encrypted: i=1; AJvYcCV2DS7S0dxBUBKoKerAx3H4aBQcx16S4wINHk7QeA1on9CMzOezKEQuktalPmKgpO6bEa8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywvb5oh3ZVsj8YveAne6gvJOrcWA+d5V59fzhINDL9w8zGsPH1y
	dtt0lSfOXdkhfj23nP5cSvvjRuIESvsy1LKv+Aypj5wjN5ffWHPreeStqjWEM9rHzMWBhV/SON2
	wuzaJINfpye/i8mAE3Xy8sS56kU/U5Q9W7mLg2E3lCvvfA2MlQA==
X-Gm-Gg: ASbGnctjyz21CvdfJdHMyaAE8/5KUiOZIJEWm+kdRJBlXtt4jtrvZEWhgVRpXo+k6GC
	FiWVvR+Vh6GfAWejecN/+nv391VhScj18B/28O76rwBq8FpJhdy4mG+0lCyuYXKFUi65hsCinVG
	PMrLuxVx6OVQCJiPAC5+ItfCGmRKS3qNy0ZXhB9ufiJKkMtWszNIjb04qJBP+/HeJizVT4LjDpP
	OdXj4479GUKIzQiBDB13qHJOLdzW2uvhoqEKENs+PP0imBrsZNMCNJmDqPwckKF
X-Received: by 2002:adf:e8d1:0:b0:38b:da34:5915 with SMTP id ffacd0b85a97d-38bf566f5e5mr13683324f8f.23.1737476967740;
        Tue, 21 Jan 2025 08:29:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFK0MXcaZRWIzl2bfA4+MZMepukExVAz8baqmZ1gj8sc3lVxxkt4XOwKAvBR2JEk6noYQJ9yA==
X-Received: by 2002:adf:e8d1:0:b0:38b:da34:5915 with SMTP id ffacd0b85a97d-38bf566f5e5mr13683271f8f.23.1737476966326;
        Tue, 21 Jan 2025 08:29:26 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4389040854bsm190088195e9.7.2025.01.21.08.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 08:29:23 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Dongjie Zou <zoudongjie@huawei.com>
Subject: Re: [PATCH v2 4/4] KVM: selftests: Add CPUID tests for Hyper-V
 features that need in-kernel APIC
In-Reply-To: <Z4_Em95xkvagPOHN@google.com>
References: <20250118003454.2619573-1-seanjc@google.com>
 <20250118003454.2619573-5-seanjc@google.com> <877c6p8t35.fsf@redhat.com>
 <Z4_Em95xkvagPOHN@google.com>
Date: Tue, 21 Jan 2025 17:29:22 +0100
Message-ID: <87wmeo6sgt.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Jan 20, 2025, Vitaly Kuznetsov wrote:
>> > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
>> > index 3188749ec6e1..8f26130dc30d 100644
>> > --- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
>> > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
>> > @@ -43,6 +43,7 @@ static bool smt_possible(void)
>> >  
>> >  static void test_hv_cpuid(struct kvm_vcpu *vcpu, bool evmcs_expected)
>> >  {
>> > +	const bool has_irqchip = !vcpu || vcpu->vm->has_irqchip;
>> >  	const struct kvm_cpuid2 *hv_cpuid_entries;
>> >  	int i;
>> >  	int nent_expected = 10;
>> > @@ -85,12 +86,19 @@ static void test_hv_cpuid(struct kvm_vcpu *vcpu, bool evmcs_expected)
>> >  				    entry->eax, evmcs_expected
>> >  				);
>> >  			break;
>> > +		case 0x40000003:
>> > +			TEST_ASSERT(has_irqchip || !(entry->edx & BIT(19)),
>> > +				    "Synthetic Timers should require in-kernel APIC");
>> 
>> Nitpick: BIT(19) of CPUID.0x40000003(EDX) advertises 'direct' mode
>> for Synthetic timers and that's what we have paired with
>> lapic_in_kernel() check. Thus, we may want to be a bit more specific and
>> say
>> 
>> "Direct Synthetic timers should require in-kernel APIC"
>> (personally, I'd prefer "Synthetic timers in 'direct' mode" name but
>> that's not how TLFS calls them)
>
> What about adding quotes to try and communicate that it's a property of Syntehtic
> Timers?  E.g.
>
>  "\"Direct\" Synthetic Timers should require in-kernel APIC");

Sounds good to me)

-- 
Vitaly


