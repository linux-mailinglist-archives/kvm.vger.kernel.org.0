Return-Path: <kvm+bounces-68193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE89AD25AE8
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 99D103099C5D
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 16:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3474334A3AB;
	Thu, 15 Jan 2026 16:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e3sjdM2A";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="NBnEoi1k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55802C0F75
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 16:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768493549; cv=none; b=mcfhDgctockT+fZwlMxunS0lBvH8bjQU9zfJuIBUGYVo4cfbTU7svkfUnCYJxRFMXIvX3nAVS5LUto4XLhtxXa4EzHYRltlek+pBe4VOsbKPEmBCWh1nJ4Nx0r5dD50NXYaPaR/E2k0FkkJsiKvETCfqd9zekthXmdSJUj0IPBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768493549; c=relaxed/simple;
	bh=RHhCaaRNI/nAzrLA7doEVdluNqjWBfYTZo1IN7DjKzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JcXoZNTaKnUFoHS0xoUCvJCpj8/hr5dYMz5TvuCsucbu02ATTEnLHVXA2EmiYmNLF+UbeA5rdDW4+HU2zeWimcbLOO+7p7EoJ6SJzsRrhZa+obWa0A/f6DyXiG8NnJ8w7JtjgS4YmNeiBr+ekNYIjV8YGtJYnTWGnpjifBbAEqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e3sjdM2A; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=NBnEoi1k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768493546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x/ZMu7CdHznH2HdFclgVFTLdKzdbKe1vdypK8PHxHR4=;
	b=e3sjdM2AmgIg+6foSAw35HbkeuO8rK2dZrwnXCjDn215tVvS3M4WXqAVwT1WTl5whR1L68
	IvMqmOWVfgZhSFOOJ0Cfys/l52uJP1x3VYki/zxi0xY7B6gLh3TIgXP+engL50/fR1+GIe
	XCjGn9yReXjJZlJ3HTab8hNS73aBh6o=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-KahbmJ9dPbOXBc4498xSCQ-1; Thu, 15 Jan 2026 11:12:25 -0500
X-MC-Unique: KahbmJ9dPbOXBc4498xSCQ-1
X-Mimecast-MFC-AGG-ID: KahbmJ9dPbOXBc4498xSCQ_1768493544
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b86fd61e3b4so102853266b.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 08:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768493544; x=1769098344; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=x/ZMu7CdHznH2HdFclgVFTLdKzdbKe1vdypK8PHxHR4=;
        b=NBnEoi1kguCa1Ek8nCokqk1nEq5Qw8ftbran239TPZo1Rj9dD/rL1ZbBCVyA+JAPlA
         1elKWSDwXaY78Vc8664fVRgw7KssWU1MH1R7i1Jl9FDx+/xua+foNydofbtxEP8iFCxN
         y/o/v2/hvwNl7C/TUxUlksjp/JqKDtnT6Cj0zB0Ht9zQNynh4aGepUcsbPpGi6teae6Y
         DrhVHu18WbrCT9VQdt1HEglqm4SWpGTh9t1r5LZOne6VoKNFz5YwxsslUfb/ke5W6VGs
         PNlbfWbqzBtMvmXJhPybrz802ZdfUKWsYWOJ+Ke6TMoGl3Yha2+q9Hmr0eQ+fOYhOrkC
         lgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768493544; x=1769098344;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x/ZMu7CdHznH2HdFclgVFTLdKzdbKe1vdypK8PHxHR4=;
        b=O9OqGoKV6+jj3n+KDmrJzcrnsSWgl6f5qXS7po0oxmCdUDUtskIfCYF9KiQacz9q3T
         bYIAhD75KFGDzmVEP6MB4glMyKM/r5ReogNqodjjKKMamlhb8sfChWgFR7+E1nx46N8M
         lAZ0tttzjWucnT/Fjo2eD6OXi5NbI2cKpNtSSkhLcRKkhYDNONC4LSF5RD/YfbN1duM2
         aQl73Hlw68dEiAQq0m9GOH0U7bojgboa4PA8GE/cGbdA/rl9LM6f88g3pBft8zG04i0W
         B41QmICpsDSl06ykLGPb/QsnrUBfU8MGIcgwWjUMK5kkBU1fsLVmbDjjQiUCDbPWTBkr
         mpgg==
X-Forwarded-Encrypted: i=1; AJvYcCX1u/+iUcwdNIWZIW8V9a6Du3hn1OpLSoPDGrTsVsl/5qqRo7X0cxOPmAAttak0YHZfDs8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzHWuTPY6wzHdDKt6zTIBP0aJntqLtMAf8urlmomCKOi3sHT+Q
	7bhZTMjhHs9GKYwhzpwmE+S8QsF/FKyEzmp5b6MZ1F3fEOYpVYWxTNAcVZWKk2z6i2YasytU50j
	LxbxCarcLR8EfgYTkZ0XPKGDDSkXAKfyMAZjgRPDotV3r1d60x3fl+g==
X-Gm-Gg: AY/fxX519vtJQZ0W5rnSnONN339gtVkP9xLfwYTPY7gvqSR72baLURJpnOsNArJ0DQh
	Tlf26yBYS0kWdttZ0DyKD7bggMC1Jg88B6T3t1Pt8IfU94r0ms4YrHWLWUa2kRPVHY7aCsi0GBU
	u5KW2Fi9vpCBSUr8xOgEnHu+pDK+b0+ZGgewdnEx0biJ6TxdZQbB/Ocxx2tN8pc2fcjAElcfxZL
	04Vi9/c7ZvfiRCujH+IWCWuknDafk81DA3v48nvAl8o/Q8FqMwJpw57Zai42Mct47DulYJAeoGm
	RV6gqynR1rHusbD7sG4knt4ijOecATZ6t/GJuIQsTmobXHES242sUUr5llk04vbdvSbJAOJGwur
	/WVtEfndpJWY12b2+ksNrKb6hkUG6Ynqz98zonYtu896+X5LQFsG2YuJ4JYBJOsX0yKviyCo5lA
	Vt75scnXchs0U=
X-Received: by 2002:a17:907:1ca5:b0:b77:1233:6f32 with SMTP id a640c23a62f3a-b8792feb14dmr11233066b.48.1768493544155;
        Thu, 15 Jan 2026 08:12:24 -0800 (PST)
X-Received: by 2002:a17:907:1ca5:b0:b77:1233:6f32 with SMTP id a640c23a62f3a-b8792feb14dmr11231266b.48.1768493543711;
        Thu, 15 Jan 2026 08:12:23 -0800 (PST)
Received: from [192.168.1.84] ([93.56.161.93])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-b86faa6be37sm1484355966b.36.2026.01.15.08.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 08:12:23 -0800 (PST)
Message-ID: <43474e30-6a14-4ab1-aa2c-5f079503637d@redhat.com>
Date: Thu, 15 Jan 2026 17:12:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever
 XFD[i]=1
To: Dave Hansen <dave.hansen@intel.com>, Jim Mattson <jmattson@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
 stable@vger.kernel.org
References: <20260101090516.316883-1-pbonzini@redhat.com>
 <20260101090516.316883-2-pbonzini@redhat.com>
 <CALMp9eSWwjZ83VQXRSD3ciwHmtaK5_i-941KdiAv9V9eU20B8g@mail.gmail.com>
 <aVxiowGbWNgY2cWD@google.com>
 <CALMp9eToT-af8kntKK2TiFHHUcUQgU25GaaNqq49RZZt2Buffg@mail.gmail.com>
 <9beb7ca4-7bcf-45f1-aefa-f8e6e8122ede@intel.com>
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
In-Reply-To: <9beb7ca4-7bcf-45f1-aefa-f8e6e8122ede@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 17:07, Dave Hansen wrote:
> On 1/6/26 09:56, Jim Mattson wrote:
>> Apologies. You're right. Though Intel is a bit coy, the only way to
>> interpret that section of the SDM is to conclude that the AMX state in
>> the CPU becomes undefined when XFD[18] is set.
> 
> I'll touch base with the folks that wrote that blurb. I'm a little
> nervous to interpret that "software should not..." blurb as a full
> architectural DANGER sign partly because it's in a "RECOMMENDATIONS FOR
> SYSTEM SOFTWARE" section.
> 
> I'm _sure_ they discussed tying XFD[i] and XINUSE[i] together and there
> was a good reason they did not.

Is there anything that prevents an SMM handler (or more likely, an SMI 
transfer monitor) to do an XSAVE/XRSTOR and destroy tile data?

Paolo


