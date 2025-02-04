Return-Path: <kvm+bounces-37259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EAB8A27932
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 18:58:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C97F1166F39
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A95521660B;
	Tue,  4 Feb 2025 17:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A0jixMCo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C528216E06
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 17:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738691926; cv=none; b=VJ/cK4pSoFHte/rla4Fc7UzeRykQ7Ym+3vrDh4vt8Tpnqv3Bx8tpT2zk3ExBFREqtYMvxzHIwUzRnTnVErXJb6Ot7Eu+tf4O8IhoxFs4iVVmVzvEP9/ENpyrOjrKes/TUOK1Ouau839Bod48VXWxDeZfrOgiJI02Vlwox4ij9vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738691926; c=relaxed/simple;
	bh=mcWM9JZRZ6PqIkePmQyxVeUNFL3oWmy+p3wfbdfqIrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GQaGjMtsYM3T/T6RIgH7+YN4V7KinuW7GFhHCQajDtsTQ3f/tqXzy4hY0BVKsAYdMB7HJvMzconzSZZGAaZr1HJ6yfswOe7GNpVl3O8VgABmU+OuVew1qXli3jAUmAQspwJgMJpfKtCgnaRtzDoqs0CVf5LzXgcSSXSuRBDcpfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A0jixMCo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738691924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4tEv0ZS87LCpgKuJidnYRf/SyUvTQEIjTRctKqIgV/M=;
	b=A0jixMCoCA6rTba+d62KMjry1Nu7x87NJg7VXUnN93OVUhkXaquvrgjVwvACtiVasTnduB
	J4QbRJZA9+PEYBk41pTJXPfs4d/ZjNbLSh+7QHPazmCinofmY0YJHJWL/LwFGB2oOUefRf
	Yd/qeMvURJG47Kkn8QfNEFPSPuATv6I=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-VHycFIPQOI2wilZ3VzEXjQ-1; Tue, 04 Feb 2025 12:58:42 -0500
X-MC-Unique: VHycFIPQOI2wilZ3VzEXjQ-1
X-Mimecast-MFC-AGG-ID: VHycFIPQOI2wilZ3VzEXjQ
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aa67fcbb549so184341766b.0
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 09:58:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738691921; x=1739296721;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4tEv0ZS87LCpgKuJidnYRf/SyUvTQEIjTRctKqIgV/M=;
        b=E+XFw7tmPPsARTmSWdjqVMTG89C5gQP2X6rVwfSyEF1QqxwzVH7oCaFrjqrR7PKp/H
         YRDtdwMJpF/NmmImYk8kSMG9VHMY14gFzW24Kuvh3epE2xxfB04dc3nQTQ3ol7mmOGen
         uAHOgv9AQlRhnSr2YBfhVVIBoNS5KPvIMDNoX2keLCjnoE6dfHgmrJDNbvv7B3//tg3E
         Mo/Bz91Yx/ojitEzOnOXGSXzineffqg7BkkTm1k7zIC9zZrpAAHKRITZvTBfthdwrJ1c
         TbbTq7bM8aIvWqj1jkp1KCPLlkUsNVFs68sHdjVxTRL4tRdvkUdhk9jy0j6Fp9eeanzr
         fqog==
X-Forwarded-Encrypted: i=1; AJvYcCVziAh/bVhNElIIGvxVieNfUj0aYs8ApdGGVV9ItTzjdV58ewGTb1BnzBDIkjp2O2In5GM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0Sg121Q+wmWbg5tyDoYihi9jaPITn+EbBnc79OGy+lCs8696f
	qNRh9s5FQpT/vxR+kJ7NqEW+kuxZFE5DztTwyZXUb62Q51as6MUhQPysGz1dsfwRwCZ9TITXAxc
	iu2Fkx+bjfkggc2KNy+k4NB8NgxIbB3Bd9O8+v9yrldkV/qu3bIqtK0UbjaVY
X-Gm-Gg: ASbGncs5GamSGYVGa26XIod85NhpI8Y2qPF8BiniJdG+yXWmiOScTR9fP2PYkzG4KN6
	TDsE6VCVf2l0WGIivbj/TczHNI/kS3+M+6tLR/25Ej2M9QmIrvLbNjx95ZqSqG3aUttqzSctPSw
	xQfoLBzM4/4U4ANQZ6ulFP7+Lh6Da2uAguhhVGKzV1EZGv7rfhgoFq75YSTKW/Ay19uOMrPD3QH
	urS0ACGeTSWK0MgU/0PQirQuypCQjxekDOiG7/lFgCc4eRx9QjflPWl+sVz1VAsPte7f+DaVfV9
	wnw/9Q==
X-Received: by 2002:a17:907:6d1d:b0:ab6:fe30:f487 with SMTP id a640c23a62f3a-ab6fe31017bmr2012663266b.12.1738691921317;
        Tue, 04 Feb 2025 09:58:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEngAueFezRPiiaOjcjw/oTHTi3J+m4OkdKh3LbQcs/taWyeXi7gQiffkbOXLLL97NJGlDUzA==
X-Received: by 2002:a17:907:6d1d:b0:ab6:fe30:f487 with SMTP id a640c23a62f3a-ab6fe31017bmr2012661266b.12.1738691920999;
        Tue, 04 Feb 2025 09:58:40 -0800 (PST)
Received: from [192.168.10.3] ([151.62.97.55])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ab6e47cf9desm976700766b.55.2025.02.04.09.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 09:58:40 -0800 (PST)
Message-ID: <2d86cce9-88c2-4b2f-a8a6-ee33d0e1c98d@redhat.com>
Date: Tue, 4 Feb 2025 18:58:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] KVM: x86: Remove use of apicv_update_lock when
 toggling guest debug state
To: Sean Christopherson <seanjc@google.com>, Naveen N Rao <naveen@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
References: <cover.1738595289.git.naveen@kernel.org>
 <dc6cf3403e29c0296926e3bd8f0d4e87b67f4600.1738595289.git.naveen@kernel.org>
 <30fc469b5b2ec5e2d6703979a0d09ad0a9df29e1.camel@redhat.com>
 <a7eb34n6gkwg6kafh7r76tkwtweuflyfoczgxya2k63al2qdoe@phmszu6ilk4w>
 <Z6JTmvrkrLpaJ1nw@google.com>
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
In-Reply-To: <Z6JTmvrkrLpaJ1nw@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/25 18:51, Sean Christopherson wrote:
> On Tue, Feb 04, 2025, Naveen N Rao wrote:
>> On Mon, Feb 03, 2025 at 09:00:05PM -0500, Maxim Levitsky wrote:
>>> On Mon, 2025-02-03 at 22:33 +0530, Naveen N Rao (AMD) wrote:
>>>> apicv_update_lock is not required when querying the state of guest
>>>> debug in all the vcpus. Remove usage of the same, and switch to
>>>> kvm_set_or_clear_apicv_inhibit() helper to simplify the code.
>>>
>>> It might be worth to mention that the reason why the lock is not needed,
>>> is because kvm_vcpu_ioctl from which this function is called takes 'vcpu->mutex'
>>> and thus concurrent execution of this function is not really possible.
>>
>> Looking at this again, that looks to be a vcpu-specific lock, so I guess
>> it is possible for multiple vcpus to run this concurrently?
> 
> Correct.

And this patch is incorrect. Because there is a store and many loads, 
you have the typical race when two vCPUs set blockirq at the same time

	vcpu 0				vcpu 1
	---------------			--------------
	set vcpu0->guest_debug
					clear vcpu1->guest_debug
	read vcpu0->guest_debug
	read vcpu1->guest_debug	
	set inhibit
					read stale vcpu0->guest_debug
					read vcpu1->guest_debug
					clear inhibit

But since this is really a slow path, why even bother optimizing it?

Paolo


