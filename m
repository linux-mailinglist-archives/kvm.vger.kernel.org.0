Return-Path: <kvm+bounces-13158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30B84892D7E
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 22:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBB6B282841
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 21:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CE64D11D;
	Sat, 30 Mar 2024 21:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hu+tg7qO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBBB4AEDA
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 21:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711834316; cv=none; b=sU96opc8Q4+vBAfWVNHlZNG/6KJ9xERcoxqnFNAnT2NIr9o/5bLqm2p97E5chSL4FNgEsliAbX7YgkUDqGiJ6cm41/128EZ28k1AvaRLb/qwEAIw7Mf6lWH1smIoL2MRxAMOap7LUee99TXnDkZo4Q4zIToinh5Wu1OGOC7HAlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711834316; c=relaxed/simple;
	bh=t1KY6wPgvCWcWD2NOTNvE0vD4k8SIvXspJg1UZfO6R0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I8MgwMWfkZ70ClUhNdirX7OjjzUN+ChPioz9Xi7p5D0HT7V6vponoVF5u+ai0TsCGc+jh9J7pv/eToum7iPl7wNC7kSnP8BdlYiJ3PzsJkFGzsAYrWr/WNP98b7m5XYqJPQQ7Vx87BfJvxgM52HdXU5HOpJSztf1vF3IgNRn2PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hu+tg7qO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711834314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2Lxl+j+xR8FWVtx6+a/UxVWMhMmDhnJi8YYlIddCdSo=;
	b=hu+tg7qOLER5yPfsR3AgmPc7bLp6V8ATXtv1Zy2kOfDYvOmyO1uFeEbMW3nLwdw3msibIz
	KDQnkqa58ANIRIPvcR2CTinXE+vKPKB56c4HmkWVeECAjOo7FNhi20GuLgIRIz69HCPU98
	a0RFkh9bWf++ervOXti9R6M2WshEI7o=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-6TNAOuxjON-zT5vuK6vI4g-1; Sat, 30 Mar 2024 17:31:52 -0400
X-MC-Unique: 6TNAOuxjON-zT5vuK6vI4g-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a4747f29e19so79026766b.1
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 14:31:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711834311; x=1712439111;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Lxl+j+xR8FWVtx6+a/UxVWMhMmDhnJi8YYlIddCdSo=;
        b=Y5OCy4FiAavvhWzm1jt2rXOysXq1yK/K8Vt3yQo5VOx7dYpYv+frBWikQsiacHGa8z
         bSDQucFqoatbYu5kN27IMmptWehus4BEI3oxEuHugC8tGkVMESNfMqIZ3qqqmdepJ11R
         WbmQBB1NH1OiT9gIecPJEhNzeIHoL2+YO/lFGTED976woyGTcwmlLJcUrNbBi2RGF6J5
         qiufRNEK+lTiVL+VYhSMM4NcIDeTMRUYw3c+pjJ4F8JiyTGSDav2TaYRgnnL3GyjwWXH
         0F15pDiPXcOhNDWNXXgFvV2Gyhm7NbrFLlDWuWQ47pQs295f0bWuZDXVUfIWcpItmhaV
         zAzg==
X-Forwarded-Encrypted: i=1; AJvYcCVzbOiX7dTzeAsOI8Ee+C/gEzZaljrIZmMl53dXEO/4msw9BEToOX5GM0v8OVv0Zvr2kMKKqU49VBl7MEzlH61dgbg1
X-Gm-Message-State: AOJu0YzVA0bN0VHEQAH5Rrptu02KsPfLYx3l3DwPXB3Qg2RycT4Scflp
	4UJ9/Dk3HxUOC8ksS8oBGieYeI52smcaYSNJPA3P3KJ+Ork1yu+RTzsEqbU2SY4cyz5pme6Fk1I
	7y60BaTfJpqizLBHTMjAW2CGM/W14RgzC8TL/kFZeLjVzCcu+hg==
X-Received: by 2002:a17:907:9693:b0:a4e:17c5:9944 with SMTP id hd19-20020a170907969300b00a4e17c59944mr4619565ejc.61.1711834311183;
        Sat, 30 Mar 2024 14:31:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4ZTkjUa1qAw9ZLrLn5Cmk/KIYm4xouooLm1o+DG2vC/bIdk1gQWLiRdSLYKS8JVSoO2kgWw==
X-Received: by 2002:a17:907:9693:b0:a4e:17c5:9944 with SMTP id hd19-20020a170907969300b00a4e17c59944mr4619522ejc.61.1711834310761;
        Sat, 30 Mar 2024 14:31:50 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id h19-20020a1709060f5300b00a4e30ff4cbcsm2438004ejj.194.2024.03.30.14.31.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 14:31:50 -0700 (PDT)
Message-ID: <f1e5aef5-989c-4f07-82af-9ed54cc192be@redhat.com>
Date: Sat, 30 Mar 2024 22:31:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 22/29] KVM: SEV: Implement gmem hook for invalidating
 private pages
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
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-23-michael.roth@amd.com>
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
In-Reply-To: <20240329225835.400662-23-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> +		/*
> +		 * If an unaligned PFN corresponds to a 2M region assigned as a
> +		 * large page in he RMP table, PSMASH the region into individual
> +		 * 4K RMP entries before attempting to convert a 4K sub-page.
> +		 */
> +		if (!use_2m_update && rmp_level > PG_LEVEL_4K) {
> +			rc = snp_rmptable_psmash(pfn);
> +			if (rc)
> +				pr_err_ratelimited("SEV: Failed to PSMASH RMP entry for PFN 0x%llx error %d\n",
> +						   pfn, rc);
> +		}

Ignoring the PSMASH failure is pretty scary...  At this point 
.free_folio cannot fail, should the psmash part of this patch be done in 
kvm_gmem_invalidate_begin() before kvm_mmu_unmap_gfn_range()?

Also, can you get PSMASH_FAIL_INUSE and if so what's the best way to 
address it?  Should fallocate() return -EBUSY?

Thanks,

Paolo


