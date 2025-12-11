Return-Path: <kvm+bounces-65736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 63350CB5124
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 09:13:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 72895301BEAE
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 08:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D512DAFDB;
	Thu, 11 Dec 2025 08:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RN6eWELi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Px1oV6cj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE51C2D47E8
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 08:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765440522; cv=none; b=bMCuLQcerAoh/mkEtcV0juF5B2a4BdGqW9bl6RPaNjpFq3rARnXdbDQ/g1DmNyxY9Uim13/0p4orruK8CjqKmaZZd7+CMi102rjer9+ZsFwWxzwi8BM0uXwDnfFrTwkpSEUI/Hdjez1pyCwlk7GaLDJ/r+GeIuI8/64y8f+IWok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765440522; c=relaxed/simple;
	bh=3aLAecIJ+hwz87np8J4m/M2sR7qC25mRITv3QiPkvfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BOU/GwlaDgqhCevlZluz29uAclFsf9kyzVyuA2ohqPjd6/iXSZOZ2xZIEZvp2AsTMYV7bS94RiG2cw2yMP0h2iscc6N8YXLbNUnuMJg1frxGT+r4VnkUKW5X+zCo17Sf6HxNlmL4qoS4QdqwGxjvuhxuCFt9o+H4T47bT8hgT6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RN6eWELi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Px1oV6cj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765440519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vodviATWQnP/8u6k6xKhTTKhDnWNFGWcgWh4eEZC9Sk=;
	b=RN6eWELiG+IVbF3xJY15L/c4PL8ErMmuMSqtENOL4noj8ZTkhpeq4mKxxNapSYYbsUvCit
	zD3ohz8RzjgZQowo6euXsTrTBBn+a/Sqs8GcWp2FHt2atE4ZgJkxEd8oz2xqbCs6mWs5Pe
	1CYvpMF44/VfpvRnjQ3U3SvQiq0NKJ8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-x9rkERyTOZqlmGPlcDihUA-1; Thu, 11 Dec 2025 03:08:37 -0500
X-MC-Unique: x9rkERyTOZqlmGPlcDihUA-1
X-Mimecast-MFC-AGG-ID: x9rkERyTOZqlmGPlcDihUA_1765440517
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47a83800743so7393605e9.0
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 00:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765440517; x=1766045317; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vodviATWQnP/8u6k6xKhTTKhDnWNFGWcgWh4eEZC9Sk=;
        b=Px1oV6cjOgglNpFmseECpvZufpgryLZ+hBv7S8YmGCLUJw2aF9MxgXnt0GxV1EstRe
         j3z+o6Y1tH8dpxoCJquwL0DwmNVI8Cw7KjX6yEazMBgJlcr4G/VEA34ambHUo+V9wPMK
         Q71Wn6HLlU2nztN1YcKCTuJNxNK9Qgjgm3G/GbfGG45oUEsQJqcU5lbGV1JE/c+3tzvx
         36qfHu4hR00WYyUcecLpJD9w5grT8y1KS4EMHqr65TwUzuUIa18DLXRSIt5kVaKgEFy+
         UdsfANuIGalBAk6tXOhuZRgSd32ULRuRr6mZc+AKmAHYqiU1b7Ybw1jPUVCvHEJdLEWq
         i92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765440517; x=1766045317;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vodviATWQnP/8u6k6xKhTTKhDnWNFGWcgWh4eEZC9Sk=;
        b=AiDCGB5hVkeQn4dlIZ077uIFuKsXPzhFyv/KGEK+i1hvhyqngjF399jllkBLx7IrbJ
         UqD+55C5KCzk5LLm1ItZeOHAn9skNWZP1+cJnr8/rK7ZSj0MJnCZAX5fhMs4Lgodp25E
         WMHWZjruvB1SveShTFFIxFVqI+0qNyFQ/wZ4300J3PmfhVfD9WewRPLLGN556cblRJrz
         +NK+Sz25YAnUWwEGXlseh7YTpxo5MZmJWOgjDoQNqgejEiq95qJZ6kS5MITW/wVXvEO3
         GeZ8Y5g6VvET2+AkDz5mvlm+sRkORxWCTs/bplhjJ+poE/G62dWU302QjF1r4rUB+pFr
         Bqgg==
X-Forwarded-Encrypted: i=1; AJvYcCW81mO6vagHQ8kHXk+YDRCEosSheWPrDmDqBAzLQsq02iB38aEwvFFV41+KA35kFqoqeG8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI8JbR1G3KoALofFoqTMkvyQ0Tg46Z3uT++oH9IyfD/v6ORORW
	wrlWUP/lS7SRvW/Zjq6PK94Sx9ALLsqnYrGra2FLzPRYdiDRgldbfmypcWmWS/Bhl0ZNDFPIBuH
	pkAND0SKckjdmF++im1eQiRQTmiWn2b5++jIfuQ0J5doC3BtB9zwSZw==
X-Gm-Gg: AY/fxX52NdvvrM0mYPtMBU1W848gBISlHmzrgMmhTqSo74BPFdoq8whR0e+z+vzXR+X
	O5fQGzUZ+0NDV5B+HpV3PHPwREAXHVoGoj6WdjjtumJMdepP2Ur3tGskvy4YFUXv+AjtgU6jEGi
	d67MCBJoaXSlLRhIRPkj8e3k7kR4VbIlYvQqvgLLTYGiltYgb6/YqHWyhRQFThStLCQc0RpYodo
	BIeEf5DziVVy/aFwOaGDzAm2Ev3AEriQi882BJwkMqRUlk9m0cM4v07WPaEwSwkj2v+xXQfZdFQ
	z1oh5EGEjv3AbtoH3oZkzi+zMNhztc1sRF4aZFIqWwgB9mZqNl6gyY7dNU39f7faQrvK7gSurq1
	T1tt1TFUacxEm1t13iRz8mIovwLjcxr85nYvscMvim6b44p970DexMIbakQ/bbPPw89+8IUqslT
	W65KQ4l9qnILEcwzE=
X-Received: by 2002:a05:600c:3485:b0:479:2a78:4a2e with SMTP id 5b1f17b1804b1-47a89f9219cmr10460685e9.7.1765440516596;
        Thu, 11 Dec 2025 00:08:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbnk7m2JNosjwWzc2hpxUHgrfTYSAWgWtGevR9iAHiqGMK15baZuJoytxxvBxNexxhZf/vYw==
X-Received: by 2002:a05:600c:3485:b0:479:2a78:4a2e with SMTP id 5b1f17b1804b1-47a89f9219cmr10460335e9.7.1765440516185;
        Thu, 11 Dec 2025 00:08:36 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47a89ef95e1sm20296665e9.9.2025.12.11.00.08.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 00:08:35 -0800 (PST)
Message-ID: <16e0fc49-0cdf-4e54-b692-5f58e18c747b@redhat.com>
Date: Thu, 11 Dec 2025 09:08:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] i386/cpu: Support APX for KVM
To: Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 "Chang S . Bae" <chang.seok.bae@intel.com>, Zide Chen <zide.chen@intel.com>,
 Xudong Hao <xudong.hao@intel.com>
References: <20251211070942.3612547-1-zhao1.liu@intel.com>
Content-Language: en-US
From: Paolo Bonzini <pbonzini@redhat.com>
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
In-Reply-To: <20251211070942.3612547-1-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/11/25 08:09, Zhao Liu wrote:
> Hi,
> 
> This series adds APX (Advanced Performance Extensions) support in QEMU
> to enable APX in Guest based on KVM (RFC v1 [1]).
> 
> This series is based on CET v5:
> 
> https://lore.kernel.org/qemu-devel/20251211060801.3600039-1-zhao1.liu@intel.com/
> 
> And you can also find the code here:
> 
> https://gitlab.com/zhao.liu/qemu/-/commits/i386-all-for-dmr-v2.1-12-10-2025
> 
> Compared with v1 [2], v2 adds:
>   * HMP support ("print" & "info registers").
>   * gdbstub support.
> 
> Thanks for your review!

Great, thanks!  Just one question, should the CPUID feature be "apx" or 
"apxf" (and therefore CPUID_7_1_EDX_APXF)?  I can fix that myself of course.

Thanks,

Paolo

> 
> Overview
> ========
> 
> Intel Advanced Performance Extensions (Intel APX) expands the Intel 64
> instruction set architecture with access to more registers (16
> additional general-purpose registers (GPRs) R16–R31) and adds various
> new features that improve general-purpose performance. The extensions
> are designed to provide efficient performance gains across a variety of
> workloads without significantly increasing silicon area or power
> consumption of the core.
> 
> APX spec link (rev.07) is:
> https://cdrdv2.intel.com/v1/dl/getContent/861610
> 
> At QEMU side, the enabling work mainly includes three parts:
> 
> 1. save/restore/migrate the xstate of APX.
>     * APX xstate is a user xstate, but it reuses MPX xstate area in
>       un-compacted XSAVE buffer.
>     * To address this, QEMU will reject both APX and MPX if their CPUID
>       feature bits are set at the same (in Patch 1).
> 
> 2. add related CPUIDs support in feature words.
> 
> 3. debug support, including HMP & gdbstub.
> 
> 
> Change Log
> ==========
> 
> Changes sicne v1:
>   * Expend current GPR array (CPUX86State.regs) to 32 elements instead of
>     a new array.
>   * HMP support ("print" & "info registers").
>   * gdbstub support.
> 
> [1]: KVM RFC: https://lore.kernel.org/kvm/20251110180131.28264-1-chang.seok.bae@intel.com/
> [2]: QEMU APX v1: https://lore.kernel.org/qemu-devel/20251118065817.835017-1-zhao1.liu@intel.com/
> 
> Thanks and Best Regards,
> Zhao
> ---
> Zhao Liu (6):
>    i386/machine: Use VMSTATE_UINTTL_SUB_ARRAY for vmstate of
>      CPUX86State.regs
>    i386/gdbstub: Add APX support for gdbstub
>    i386/cpu-dump: Dump entended GPRs for APX supported guest
>    i386/monitor: Support EGPRs in hmp_print
>    i386/cpu: Support APX CPUIDs
>    i386/cpu: Mark APX xstate as migratable
> 
> Zide Chen (3):
>    i386/cpu: Add APX EGPRs into xsave area
>    i386/cpu: Cache EGPRs in CPUX86State
>    i386/cpu: Add APX migration support
> 
>   configs/targets/x86_64-softmmu.mak |  2 +-
>   gdb-xml/i386-64bit-apx.xml         | 26 +++++++++++
>   include/migration/cpu.h            |  4 ++
>   target/i386/cpu-dump.c             | 30 +++++++++++--
>   target/i386/cpu.c                  | 68 ++++++++++++++++++++++++++++-
>   target/i386/cpu.h                  | 48 +++++++++++++++++++--
>   target/i386/gdbstub.c              | 69 +++++++++++++++++++++++++++++-
>   target/i386/machine.c              | 27 +++++++++++-
>   target/i386/monitor.c              | 16 +++++++
>   target/i386/xsave_helper.c         | 16 +++++++
>   10 files changed, 293 insertions(+), 13 deletions(-)
>   create mode 100644 gdb-xml/i386-64bit-apx.xml
> 


