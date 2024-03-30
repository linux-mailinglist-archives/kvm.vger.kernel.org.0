Return-Path: <kvm+bounces-13161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F0EC892D87
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 22:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8D24283ABE
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 21:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C59AF50A72;
	Sat, 30 Mar 2024 21:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MRx/CD3R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6544E1D6
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 21:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711834555; cv=none; b=NFBu/I9xJ8Doue7CNIp8fxaoBS/TEnqDRBkNzN7ZjeqbSDHd62vgt4weIA0gLJo402NwwBtnuXC2bFrXP2I4/dApMGJwe8igKVYkDi6KUYicX5GopfO49tObmdWs7onIMEtgZxxbKnb8b3t5fDpo4NlM8ApuAwi1TfmB6D/g6AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711834555; c=relaxed/simple;
	bh=XGP/bsxmN4UA90jlZmkSiIF6HI+T7qPBdxxu9QCdFjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQJNUPdl911ro1yb7TlzorshCQNK4X5+WQGrQsOmVp3RJepBxyadPMMiiHIPz9P+UgzOAfAN+AYkmsl9NjX3wl4eRfGTRHNqV7T6G3S6lkjmcgDSM1gjv0FjbA1VkegPZVFnirjF/oUmLhi+ksAJCg9tAX49CPkooIRsT2oJ1lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MRx/CD3R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711834552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=R/YdumI8jd8jDImfb7MEXm8pAf+7owyDUrM2XftNAOY=;
	b=MRx/CD3RC0fPDEpIr7khRXv6XN2nIUaTA/kw/iz29kNjYIQSnenBvKmEVSkxth6+d8IbT2
	qaEmk1SRpbjldIqAw+NyJQRrh7gGshx7OIX0v7W/gNFZRBn6JGnF9mC20r0JnK28c5q7+N
	JxqQQoX6b7yqgfuWZKp4JdIbT/1hATU=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-9uxihBKrM-Ok0RCwxwkpcg-1; Sat, 30 Mar 2024 17:35:50 -0400
X-MC-Unique: 9uxihBKrM-Ok0RCwxwkpcg-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50e91f9d422so2894550e87.2
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 14:35:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711834548; x=1712439348;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R/YdumI8jd8jDImfb7MEXm8pAf+7owyDUrM2XftNAOY=;
        b=ab/z4r8rJuUlX3bvZmLx6GUUx4/fMVhnfXb1f0sG7rBX/vz6KwIoxjOHkzYZzfqFEU
         wBeXV2KyamIzbbsg4pWEbbcAcfyTacu0Fm1zqXkYNGe0rMHp/AtpN4EFMDwe/wG444J+
         99RKddoHeyvtm2a9aDG5J5q2lGsLayKOcViIr6dGzCZRd24zWF6+IOQD/zuR6Xci1uh/
         QQEembmi6VgdCObN9nkl6WbXEIhi8Vf62Jn2Zgv3THjNqNBFhaWejNjOEQBK40VR4G7u
         z4/PUjvIkcZyV0IjAQwCOkBdFxJ3vTzI3RQtmQTbGlbeqvitgz79+ojrbBops8+kTpde
         hAQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVe0DuonStGCvjgjicN+N4be9GWRkUnGqTPwagr1ZSDjapU5BMVYtKNRpvHMcLOaSPe6OXSidLT8VLKaeZSCQwOzMZ2
X-Gm-Message-State: AOJu0YylIF4mXYPvc9nausCsTqcU94tqhjI2emc5HShZbMdHxiPyYqje
	YETJqow21KtczuC+Nu+OZ1M4+6Oap/m6uLsdUdyvcl3aUbStaG4n8dE9/t5Nu4+iBPsK2C83WNR
	eKh+rV27lHJi/ZoWw2AGEKvIYoD7bg9cRC3RIisGqenwoGYy94MELHBuhOw==
X-Received: by 2002:ac2:4256:0:b0:515:a5b1:1dd0 with SMTP id m22-20020ac24256000000b00515a5b11dd0mr3175166lfl.55.1711834548601;
        Sat, 30 Mar 2024 14:35:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtpVK74hYMJQRsbSNAOxNo0vPDNEDLKCnR39FTY23/i2sK1bKLUmtvrUTSb2GUD2WssCJO3g==
X-Received: by 2002:ac2:4256:0:b0:515:a5b1:1dd0 with SMTP id m22-20020ac24256000000b00515a5b11dd0mr3175156lfl.55.1711834548253;
        Sat, 30 Mar 2024 14:35:48 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id os26-20020a170906af7a00b00a465b72a1f3sm3494452ejb.85.2024.03.30.14.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 14:35:47 -0700 (PDT)
Message-ID: <abbe9937-7e0f-4fbd-be0b-488de07dd56c@redhat.com>
Date: Sat, 30 Mar 2024 22:35:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 25/29] KVM: SVM: Add module parameter to enable the
 SEV-SNP
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-26-michael.roth@amd.com>
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
In-Reply-To: <20240329225835.400662-26-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Add a module parameter than can be used to enable or disable the SEV-SNP
> feature. Now that KVM contains the support for the SNP set the GHCB
> hypervisor feature flag to indicate that SNP is supported.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   arch/x86/kvm/svm/sev.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3e8de7cb3c89..658116537f3f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -48,7 +48,8 @@ static bool sev_es_enabled = true;
>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
>   
>   /* enable/disable SEV-SNP support */
> -static bool sev_snp_enabled;
> +static bool sev_snp_enabled = true;
> +module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
>   
>   /* enable/disable SEV-ES DebugSwap support */
>   static bool sev_es_debug_swap_enabled = true;


