Return-Path: <kvm+bounces-31244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 866CA9C18CA
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 10:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E74A1B2187E
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 09:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0E71E0DE0;
	Fri,  8 Nov 2024 09:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UoLLy5yS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565821E00AC
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 09:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731056929; cv=none; b=PDOc6Hqe5HO5oXVxPEvyS3aCKZSLvkNOHkzBgQcxODVfoNkTZUnb8S61DIHLeJR8cnp+UNGpTM5z6IJoq3tyQ5NERh7N3vK36sYvxC5f+ziBd0j5pqYaXWmlKyLMPCusYoqqSHRV7pLK4/8tQlFMWCpKpEKbGC93FTp3NnV3KbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731056929; c=relaxed/simple;
	bh=WFc3Q9Mb4YnWrd+oQcX8uE9XxGi7mkMSsY7Q/8EXo/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tyNvPKlJt8P8+tQSgNQveMWJNZYPETjdAH4OFr3YZ80VTCIozSugoM4rKfgn7fx5mPgjhL2fPZH1zcZtHAmusGS/Cv5qwcztc3t41Dz4HLwnS5zY8jdrEU0Sk7Jua8ufI1nVG5bzfvlhcYnPuXlOUl62mX+K8Lej58Paxr8GKIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UoLLy5yS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731056926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4zjoLu3X9DAY4JQpfTcJl0/52UxwxHvuqwd6q7efGUc=;
	b=UoLLy5yS8Et0w4I4Ddj0Qrpcx1qsx7v0JTLZRsrGuNm7r+IjF35VwtwExoau7+5NkQ6e5T
	Wzq/LdjV6J1pOgvnRbscKu+RixP+1FtcTrF8qRoVDTT7VPNGLv5rVE2HETmucF/nTXmphK
	/Ni2G97lrEWp5oyWgXUfD+CS1AoreQc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227--3h_e7RdOUiwFEkqspTxqA-1; Fri, 08 Nov 2024 04:08:44 -0500
X-MC-Unique: -3h_e7RdOUiwFEkqspTxqA-1
X-Mimecast-MFC-AGG-ID: -3h_e7RdOUiwFEkqspTxqA
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43159c07193so17073665e9.0
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 01:08:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731056923; x=1731661723;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4zjoLu3X9DAY4JQpfTcJl0/52UxwxHvuqwd6q7efGUc=;
        b=PZRsD9Ld8EnzsvzfvkF6ufDH3r8OZAkfFEGu+ZQOV3XaHW3e96Qcxj03axxieNuA4P
         jJizyL+60cTzqpkL82tvO6g2BwDdXwnAtb8qSrD2q9GzunT9s+kJzt9XUF6RqdO6GzcT
         i7ugZlrt4OtKvRwe8601zzMZT0f+jZeLagTJxMelJl8RPD9YDbsp5/B1+gh8jNBfgxru
         A2Dhzr2/DUQoSpmM7zNZQaIoNRkqi34+EodU6dxgtR50rfokFMRi3Yzk6kMo4L5zS94u
         lJ7dTH7Dc/MM1XT94i5P8nDNk0v4vrKTCUyMV08GKbXIj1Fcyltxbvk4OwCboUIvjGse
         6eCQ==
X-Forwarded-Encrypted: i=1; AJvYcCW51lpmu8aspShgp8rii2cB8YMudTcQYKFJtg+RnchA7qE62YbXiF/3/fOF3jQPadffT54=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvMjJmt2f86K8qmf6jzRH8gUbZ7zAyo+347seoGwWObDTYHv1H
	+aX9CbCjdPQxiU72Xl/4QMrAI3RIQ6jjMgJLGWEFG2hgztMHYGAnTqnfFdw8faMGmyrEZIEvdGS
	XuBWql5Da/VTCoItGocz2loqdL9MkqFiruUPbUHn4HlPy/L4TWQ==
X-Received: by 2002:a05:600c:1d20:b0:430:57e8:3c7e with SMTP id 5b1f17b1804b1-432b751ee6bmr16519265e9.28.1731056922850;
        Fri, 08 Nov 2024 01:08:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFXS+cqyTfle4rH6KhTwr187aMVV3GDgGEJWyKzmdTnx+Rn7WxfiZ/RnrVdoicvqr2Lr55snA==
X-Received: by 2002:a05:600c:1d20:b0:430:57e8:3c7e with SMTP id 5b1f17b1804b1-432b751ee6bmr16518905e9.28.1731056922486;
        Fri, 08 Nov 2024 01:08:42 -0800 (PST)
Received: from [192.168.10.47] ([151.49.84.243])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-432aa5b5e56sm95082935e9.2.2024.11.08.01.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2024 01:08:41 -0800 (PST)
Message-ID: <68770651-f7cc-4032-aabc-90c72ee648a6@redhat.com>
Date: Fri, 8 Nov 2024 10:08:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] kvm: svm: Fix gctx page leak on invalid inputs
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Dionna Glaze <dionnaglaze@google.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Michael Roth <michael.roth@amd.com>,
 Brijesh Singh <brijesh.singh@amd.com>, Ashish Kalra <ashish.kalra@amd.com>
Cc: John Allen <john.allen@amd.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>,
 Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 kvm@vger.kernel.org
References: <20241105010558.1266699-1-dionnaglaze@google.com>
 <20241105010558.1266699-2-dionnaglaze@google.com>
 <867da10c-352b-317e-6ba8-7e4369000773@amd.com>
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
In-Reply-To: <867da10c-352b-317e-6ba8-7e4369000773@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 15:29, Tom Lendacky wrote:
> On 11/4/24 19:05, Dionna Glaze wrote:
>> Ensure that snp gctx page allocation is adequately deallocated on
>> failure during snp_launch_start.
>>
>> Fixes: 136d8bc931c8 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command")
>>
>> CC: Sean Christopherson <seanjc@google.com>
>> CC: Paolo Bonzini <pbonzini@redhat.com>
>> CC: Thomas Gleixner <tglx@linutronix.de>
>> CC: Ingo Molnar <mingo@redhat.com>
>> CC: Borislav Petkov <bp@alien8.de>
>> CC: Dave Hansen <dave.hansen@linux.intel.com>
>> CC: Ashish Kalra <ashish.kalra@amd.com>
>> CC: Tom Lendacky <thomas.lendacky@amd.com>
>> CC: John Allen <john.allen@amd.com>
>> CC: Herbert Xu <herbert@gondor.apana.org.au>
>> CC: "David S. Miller" <davem@davemloft.net>
>> CC: Michael Roth <michael.roth@amd.com>
>> CC: Luis Chamberlain <mcgrof@kernel.org>
>> CC: Russ Weight <russ.weight@linux.dev>
>> CC: Danilo Krummrich <dakr@redhat.com>
>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> CC: "Rafael J. Wysocki" <rafael@kernel.org>
>> CC: Tianfei zhang <tianfei.zhang@intel.com>
>> CC: Alexey Kardashevskiy <aik@amd.com>
>>
>> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
>> ---
>>   arch/x86/kvm/svm/sev.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 714c517dd4b72..f6e96ec0a5caa 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2212,10 +2212,6 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   	if (sev->snp_context)
>>   		return -EINVAL;
>>   
>> -	sev->snp_context = snp_context_create(kvm, argp);
>> -	if (!sev->snp_context)
>> -		return -ENOTTY;
>> -
>>   	if (params.flags)
>>   		return -EINVAL;
>>   
>> @@ -2230,6 +2226,10 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
>>   		return -EINVAL;
>>   
>> +	sev->snp_context = snp_context_create(kvm, argp);
>> +	if (!sev->snp_context)
>> +		return -ENOTTY;
>> +
>>   	start.gctx_paddr = __psp_pa(sev->snp_context);
>>   	start.policy = params.policy;
>>   	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
> 

Applied, thanks.

Paolo


