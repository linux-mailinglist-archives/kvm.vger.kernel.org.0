Return-Path: <kvm+bounces-26322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17B72973F94
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:30:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4CB3289906
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 310141BC084;
	Tue, 10 Sep 2024 17:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hN3cyH4g"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63261BBBD7
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725988997; cv=none; b=gm1i7caKA5gHMLswmnDuMsbsGfI1X6SLMixMwtWfWY6RIPEBgFg9i1UpBo+SrRYXJth9UCxWExP2C69xzg7ZtTR9r9a3g9R7+oVVxEilYFd/wMTvy7Y2/GCD4rnS1iWAMEtl9HvhVhlSUZqs3UCbe5AhvRax/zAZA/JmjEGAI5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725988997; c=relaxed/simple;
	bh=3HzZMOePfkS9jV2mIucUMg0FLClBHJMcLOws/BZLNeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aM85uraW4koqOKdwbukJNaGBjt386bM9hBglKpqSg4MEcYeTxFftbVjOuS49E6m02huU1jIuWxOC2lDCVs8yjmdS8A2yFkzJPaFLDUQCC8TfOte4NlN6b53vL8RxKplOYzNj0rKpqpMJ4qWbymkspOPx54lkW1R8ouyleay3rrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hN3cyH4g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725988994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uU1YVV5KEmnJArooZzou/r1gFQKreRbLBjRHOx64SpU=;
	b=hN3cyH4gXzjeLZGMSX4BPJRB8WY+8RLTuWRacJIlVdG3jWoH/JqxjlCSEk/JsuiDGQuR/M
	ffheGrZCnWMN/62oLXZjYyiLmtJ3ABd2JnCfQ3liBlvV6zoKXk3ibauB5d6Xnm+1REbu41
	xTPqcdEwUuUUULxkac26C3WckiujbHY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-79mi-WPrP9S2CmibdM2spg-1; Tue, 10 Sep 2024 13:23:13 -0400
X-MC-Unique: 79mi-WPrP9S2CmibdM2spg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-374c960ee7aso4252003f8f.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:23:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725988992; x=1726593792;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uU1YVV5KEmnJArooZzou/r1gFQKreRbLBjRHOx64SpU=;
        b=HBl2FeCtM/HTREDsZcZoNsFG3Q6axlXA9MakcUNiHoLznZKQazGl7GF8/qmstZJYH/
         5wizxays0MeG8qq0ss1NRh9uZCKoTFZLf+1f3IjyDi/wVZS2FqrNNsvo2Iw0fMeVRu8Q
         kLxiCG7X7TaDmGZavDncgCBltqeJOINnUHk/adaomPlVIYV7j9cVC8BOzuachoELKSmA
         dNYkHtw9rsKCevIa02l0aa62TFAqXi342uFWMfMmekeIzVdjUGfYH8i6Z/+AN1i4tPva
         jc8W6tOfItAIp0ZlbSTzkeTJ80He9WMOsK60D3gtY9L5DcyEMY2byuB9oqyGjtvTa4ZM
         q0mQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2++A7MEXRsfP4fQRAiy7zTfpxfHPGt7P8YQeXLboj0H/vvPDIDHr5GID6sgo2GFs9mE0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6qg3dSbjjnVhfkWQMbxDEjaqFtLaB/ZuH66jYrcMpCWpGLt83
	MbMCkSIvxJScLVlZcpaSY+x7Bg5jPBgsWfsPSByGBjHWRh1+IeYxySdDC5YFxnhf3YjTsdygZM6
	SYyAjjKcVCjg4/djOiDzwWIsEslq2a1bFOij1dkPdy6BzOLuSGQ==
X-Received: by 2002:a5d:64ce:0:b0:374:c71c:3dc0 with SMTP id ffacd0b85a97d-37892466d5bmr10563236f8f.52.1725988992466;
        Tue, 10 Sep 2024 10:23:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQtLVK5qHXlirReZkAVIKHaz8mqp7ppA9dX+hwrkXKZ9TWwHgJqvWCAKwbH3vJJABbUFSJfQ==
X-Received: by 2002:a5d:64ce:0:b0:374:c71c:3dc0 with SMTP id ffacd0b85a97d-37892466d5bmr10563201f8f.52.1725988991948;
        Tue, 10 Sep 2024 10:23:11 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-378956de00fsm9438259f8f.99.2024.09.10.10.23.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 10:23:11 -0700 (PDT)
Message-ID: <d566cce2-2c78-4547-a2c0-75087e06f790@redhat.com>
Date: Tue, 10 Sep 2024 19:23:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/25] KVM: TDX: Make pmu_intel.c ignore guest TD case
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-16-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 xsEhBFRCcBIBDqDGsz4K0zZun3jh+U6Z9wNGLKQ0kSFyjN38gMqU1SfP+TUNQepFHb/Gc0E2
 CxXPkIBTvYY+ZPkoTh5xF9oS1jqI8iRLzouzF8yXs3QjQIZ2SfuCxSVwlV65jotcjD2FTN04
 hVopm9llFijNZpVIOGUTqzM4U55sdsCcZUluWM6x4HSOdw5F5Utxfp1wOjD/v92Lrax0hjiX
 DResHSt48q+8FrZzY+AUbkUS+Jm34qjswdrgsC5uxeVcLkBgWLmov2kMaMROT0YmFY6A3m1S
 P/kXmHDXxhe23gKb3dgwxUTpENDBGcfEzrzilWueOeUWiOcWuFOed/C3SyijBx3Av/lbCsHU
 Vx6pMycNTdzU1BuAroB+Y3mNEuW56Yd44jlInzG2UOwt9XjjdKkJZ1g0P9dwptwLEgTEd3Fo
 UdhAQyRXGYO8oROiuh+RZ1lXp6AQ4ZjoyH8WLfTLf5g1EKCTc4C1sy1vQSdzIRu3rBIjAvnC
 tGZADei1IExLqB3uzXKzZ1BZ+Z8hnt2og9hb7H0y8diYfEk2w3R7wEr+Ehk5NQsT2MPI2QBd
 wEv1/Aj1DgUHZAHzG1QN9S8wNWQ6K9DqHZTBnI1hUlkp22zCSHK/6FwUCuYp1zcAEQEAAc0j
 UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT7CwU0EEwECACMFAlRCcBICGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRB+FRAMzTZpsbceDp9IIN6BIA0Ol7MoB15E
 11kRz/ewzryFY54tQlMnd4xxfH8MTQ/mm9I482YoSwPMdcWFAKnUX6Yo30tbLiNB8hzaHeRj
 jx12K+ptqYbg+cevgOtbLAlL9kNgLLcsGqC2829jBCUTVeMSZDrzS97ole/YEez2qFpPnTV0
 VrRWClWVfYh+JfzpXmgyhbkuwUxNFk421s4Ajp3d8nPPFUGgBG5HOxzkAm7xb1cjAuJ+oi/K
 CHfkuN+fLZl/u3E/fw7vvOESApLU5o0icVXeakfSz0LsygEnekDbxPnE5af/9FEkXJD5EoYG
 SEahaEtgNrR4qsyxyAGYgZlS70vkSSYJ+iT2rrwEiDlo31MzRo6Ba2FfHBSJ7lcYdPT7bbk9
 AO3hlNMhNdUhoQv7M5HsnqZ6unvSHOKmReNaS9egAGdRN0/GPDWr9wroyJ65ZNQsHl9nXBqE
 AukZNr5oJO5vxrYiAuuTSd6UI/xFkjtkzltG3mw5ao2bBpk/V/YuePrJsnPFHG7NhizrxttB
 nTuOSCMo45pfHQ+XYd5K1+Cv/NzZFNWscm5htJ0HznY+oOsZvHTyGz3v91pn51dkRYN0otqr
 bQ4tlFFuVjArBZcapSIe6NV8C4cEiSTOwE0EVEJx7gEIAMeHcVzuv2bp9HlWDp6+RkZe+vtl
 KwAHplb/WH59j2wyG8V6i33+6MlSSJMOFnYUCCL77bucx9uImI5nX24PIlqT+zasVEEVGSRF
 m8dgkcJDB7Tps0IkNrUi4yof3B3shR+vMY3i3Ip0e41zKx0CvlAhMOo6otaHmcxr35sWq1Jk
 tLkbn3wG+fPQCVudJJECvVQ//UAthSSEklA50QtD2sBkmQ14ZryEyTHQ+E42K3j2IUmOLriF
 dNr9NvE1QGmGyIcbw2NIVEBOK/GWxkS5+dmxM2iD4Jdaf2nSn3jlHjEXoPwpMs0KZsgdU0pP
 JQzMUMwmB1wM8JxovFlPYrhNT9MAEQEAAcLBMwQYAQIACQUCVEJx7gIbDAAKCRB+FRAMzTZp
 sadRDqCctLmYICZu4GSnie4lKXl+HqlLanpVMOoFNnWs9oRP47MbE2wv8OaYh5pNR9VVgyhD
 OG0AU7oidG36OeUlrFDTfnPYYSF/mPCxHttosyt8O5kabxnIPv2URuAxDByz+iVbL+RjKaGM
 GDph56ZTswlx75nZVtIukqzLAQ5fa8OALSGum0cFi4ptZUOhDNz1onz61klD6z3MODi0sBZN
 Aj6guB2L/+2ZwElZEeRBERRd/uommlYuToAXfNRdUwrwl9gRMiA0WSyTb190zneRRDfpSK5d
 usXnM/O+kr3Dm+Ui+UioPf6wgbn3T0o6I5BhVhs4h4hWmIW7iNhPjX1iybXfmb1gAFfjtHfL
 xRUr64svXpyfJMScIQtBAm0ihWPltXkyITA92ngCmPdHa6M1hMh4RDX+Jf1fiWubzp1voAg0
 JBrdmNZSQDz0iKmSrx8xkoXYfA3bgtFN8WJH2xgFL28XnqY4M6dLhJwV3z08tPSRqYFm4NMP
 dRsn0/7oymhneL8RthIvjDDQ5ktUjMe8LtHr70OZE/TT88qvEdhiIVUogHdo4qBrk41+gGQh
 b906Dudw5YhTJFU3nC6bbF2nrLlB4C/XSiH76ZvqzV0Z/cAMBo5NF/w=
In-Reply-To: <20240812224820.34826-16-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/24 00:48, Rick Edgecombe wrote:
> From: Isaku Yamahata<isaku.yamahata@intel.com>
> 
> Because TDX KVM doesn't support PMU yet (it's future work of TDX KVM
> support as another patch series) and pmu_intel.c touches vmx specific
> structure in vcpu initialization, as workaround add dummy structure to
> struct vcpu_tdx and pmu_intel.c can ignore TDX case.
> 
> Signed-off-by: Isaku Yamahata<isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe<rick.p.edgecombe@intel.com>

Would be nicer not to have this dummy member at all if possible.

Could vcpu_to_lbr_desc() return NULL, and then lbr_desc can be checked 
in intel_pmu_init() and intel_pmu_refresh()?  Then the checks for 
is_td_vcpu(vcpu), both inside WARN_ON_ONCE() and outside, can also be 
changed to check NULL-ness of vcpu_to_lbr_desc().

Also please add a WARN_ON_ONCE(is_td_vcpu(vcpu)), or 
WARN_ON_ONCE(!lbr_desc) given the above suggestion, to return early from 
vmx_passthrough_lbr_msrs().

Thanks,

Paolo


