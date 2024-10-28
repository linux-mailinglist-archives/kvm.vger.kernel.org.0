Return-Path: <kvm+bounces-29877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC879B3870
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:59:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E304E1F22A54
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217161DF962;
	Mon, 28 Oct 2024 17:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GgwjoFBP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496151DF749
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730138349; cv=none; b=Irfdv8ltGkNfqVzCKqTx35ie0+YOlBwtYa/KQyFeXJ4v9tpCChCgMXE2g5zMgJRK0sBc48dHgkseak5viO44V4BxKbpJY4SNX5HcHji/YAuF5eE6Q82Zc6A3WFHrpg8Y/Vn5VuIZT2pkU++AJegWxfLafBdKatdziD24wrFCv+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730138349; c=relaxed/simple;
	bh=RgEyJ/UTXeiL2Rr1ZWAjbIYgSjcGw8e7cSxu/c67RCE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EPrsa2/ho+RDFusp0WFeTrD6036OcKtab4NTKfTOaQP8Xm9qg+wL8QGT1ysDgbhmoj58G+hsIq3t9kUEI2NfFjsTtqPlSmDuwhLOLOTDkp2qJZjk5r8nBpWbAiyA+5mqBYmTbIll8t6MoBNoPubDu3MiLZg7Lkvo3bDpg+4GX7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GgwjoFBP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730138345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VaEuGHwDHQ/7fxU81N7Mc5+UKCdEzJjxfEJniWKTOtw=;
	b=GgwjoFBPJdI9b+6+C9ScotaR04jI3iQ9io6wzinHg3XahImOdD5w8uvujni0Mk2ApThNs3
	cn1L8WpaHvbPpqTKSitkZF3Y6nUePxszM5KYP9mjqEvI54mHL7IxTU6VgVL04DFV06YDRT
	S5lIT5U9ps2GGMlRf+aW+8IlMtx2d2k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-hqfFpMOaMJWdqMbLtUQ54A-1; Mon, 28 Oct 2024 13:59:04 -0400
X-MC-Unique: hqfFpMOaMJWdqMbLtUQ54A-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4315cefda02so33948595e9.0
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 10:59:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730138343; x=1730743143;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VaEuGHwDHQ/7fxU81N7Mc5+UKCdEzJjxfEJniWKTOtw=;
        b=YnEmhtKmILpbsGLsf/6YdLieEIHSRHE8yblf11ePNsYU4bm+5bwH/kPT0icDItUSR/
         4tdlMRlM5z+Kbx9lCoNfMqCgKZgXaqn1B2cX3gBRllQoVmPYj74fhQn9lkOa7MhZ3ce/
         MWrWj7hMQOHiUyrKfnZ9Y4aXAxCdcFbew+RdBINjDxHgayuM9DOzweVcvShviikOCUBc
         i0BoLBrUnp9CMswK46XIP/bYQ5Vw3nCwlJSps0ahHRyvBEDQ78pvNW41krle2YBecqIU
         ywEUBFf2YLEFS0ZOKz0FHS8G9xUWZl6gvqivcRvevzbQuQOmGkPAH/uh99O+4wV3VoM4
         8xwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWG/mMr//jZB9N8rAj6Xhkk0QCLxpdMrXPFX3iltCe1Txw8P1Xqorrw+ZpvIYcsptzvpkk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ3ZzhPTQDUHfUXN5BFmJSUWtDU7FvfTOEzLxCW8rHdIO33CpV
	Me3L12NYbviT6dqPGOkUswWyyinouznP2iagRlG6eHuWNOH+SXF0qU0sMuhk9+huDwwKJJ9BC8/
	PLmyL9T/v2Q/612g8aIbnJnPdfTCwDE/afmS7+HtHCXG1whteCg==
X-Received: by 2002:a05:600c:4fc5:b0:42f:8515:e490 with SMTP id 5b1f17b1804b1-4319ac7427fmr75565865e9.5.1730138343297;
        Mon, 28 Oct 2024 10:59:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyXQIh6s0GdH8O151oWfGZtILg2E2LF4hvZ6KvK5FspFGuiLQ2aANV8VYQ8kDB08L+Agb2Lg==
X-Received: by 2002:a05:600c:4fc5:b0:42f:8515:e490 with SMTP id 5b1f17b1804b1-4319ac7427fmr75565775e9.5.1730138342949;
        Mon, 28 Oct 2024 10:59:02 -0700 (PDT)
Received: from [192.168.10.3] ([151.49.226.83])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4318b57b5d9sm146350035e9.44.2024.10.28.10.59.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 10:59:02 -0700 (PDT)
Message-ID: <e8677ccc-e25e-46f9-8cf1-e3ff8d28887d@redhat.com>
Date: Mon, 28 Oct 2024 18:59:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com,
 adrian.hunter@intel.com, nik.borisov@suse.com
References: <cover.1730118186.git.kai.huang@intel.com>
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
In-Reply-To: <cover.1730118186.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/24 13:41, Kai Huang wrote:

> v5 -> v6:
>   - Change to use a script [*] to auto-generate metadata reading code.
> 
>    - https://lore.kernel.org/kvm/f25673ea-08c5-474b-a841-095656820b67@intel.com/
>    - https://lore.kernel.org/kvm/CABgObfYXUxqQV_FoxKjC8U3t5DnyM45nz5DpTxYZv2x_uFK_Kw@mail.gmail.com/
> 
>     Per Dave, this patchset doesn't contain a patch to add the script
>     to the kernel tree but append it in this cover letter in order to
>     minimize the review effort.

I think Dave did want to check it in, but not tie it to the build (so 
that you don't need to have global_metadata.json).

You can add an eleventh patch (or a v7 just for patch 3) that adds it in 
scripts/.  Maybe also add a

print("/* Generated from global_metadata.json by 
scripts/tdx_parse_metadata.py */", file=f);

line to the script, for both hfile and cfile?

>   - Change to use auto-generated code to read TDX module version,
>     supported features and CMRs in one patch, and made that from and
>     signed by Paolo.
>   - Couple of new patches due to using the auto-generated code
>   - Remove the "reading metadata" part (due to they are auto-generated
>     in one patch now) from the consumer patches.

>      print(file=file)
>      for f in fields:
>          fname = f["Field Name"]
>          field_id = f["Base FIELD_ID (Hex)"]
>          num_fields = int(f["Num Fields"])
>          num_elements = int(f["Num Elements"])
>          struct_member = fname.lower()
>          indent = "\t"
>          if num_fields > 1:
>              if fname == "CMR_BASE" or fname == "CMR_SIZE":
>                  limit = "sysinfo_cmr->num_cmrs"
>              elif fname == "CPUID_CONFIG_LEAVES" or fname == "CPUID_CONFIG_VALUES":
>                  limit = "sysinfo_td_conf->num_cpuid_config"

Thanks Intel for not telling the whole story in the "Num Fields" value 
of global_metadata.json. :)

Paolo


