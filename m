Return-Path: <kvm+bounces-41870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C32FEA6E5B1
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:31:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C33543A8381
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44E61B21BD;
	Mon, 24 Mar 2025 21:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fXg4ukiN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EED315E96
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742851869; cv=none; b=R2e97yZbB8mnnvtNVilvRHosswhRklg5Xe8ZBPZ07I4IxEfmrMY7shuWd3J/C+zszs/jUAASEAxKpBlYtg2CQHLQL542oOgUPNYwtfLRYNgjl2tsRB9cjvHVp8qyWtWVpJ7z0YoTe8mBF/EfOlcxb1vyKWtp3BYwt09ZvJo4V4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742851869; c=relaxed/simple;
	bh=gz6RL39ctnq9lE/REoBLaE/HkfL8ocJDZymSNzDN9oo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pn1hf6FrTp5wFJS4w3ethA8rk9XteKPRpr463Won+ZUnemin1wgUr9fQl+nrX3bSGvEfJwyHRO8Kz+CwHcdIKLta2T+4QKlVbbimGM9baXkXxJMzO6QcTlAyUQF9S7ldgDbxuc+Eb98H29BLYZTB3yM0VwvI8uCkp7S2oXMkXbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fXg4ukiN; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-301302a328bso9299080a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 14:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742851866; x=1743456666; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DZMha2t/FZ5+K9Z9EZOfeX0DoxH1TC8eTZwVsJ1i/ss=;
        b=fXg4ukiNnbFmDaXiNgfC9T2+n7EB8uXfCLLGmZJUn0zdl4mr00MCHOxFaowrvExQBI
         LEqlwcDujaocHYVn08V6g1i8TW0PIRrJC1XtoDMZfGvKr1fPcicGmK0Dgykw0QsyYfSk
         QE6zItUXuA6pMGJpoDUiSdqe/K1pxLlviGFcv84XqVSRSOP5l0FkK7mm536fz3jJPrt8
         dLDt4Ix+ceqz2uLd0b5lzG+vC8hQKFpUozF+PjL+YlLS/J4bkNRuP6M5b4qpZjg3ORl0
         05zjNTwI2y7bqClDOlQqzRAwSXDoAVnkxGHrZEAJHl2LS6hbKPQ/4dVplqdNMLSD5k+i
         NNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742851866; x=1743456666;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DZMha2t/FZ5+K9Z9EZOfeX0DoxH1TC8eTZwVsJ1i/ss=;
        b=QW8FQnuCGoCHkE9YgIb7CBorw0v+XDml/XhPaPDtlFfBPr8ztecPEdvkzd0ylrZQVE
         r77wfcDJP9C6BWTDtgQcBuzeAjDoWL+1+dH8ZC5834EERD5nEUWn7+li7ipqK0xBNIWm
         AzHq7zTfoP5gV4+k91a37DGWmWeipPSpF/bU2uoMpGSyjbszSBbOob/iHlbqN+fq1mct
         m4kJe5pA2ImDsA444j0fzdMjoBtS/gl9ASfB1p8YRizYer88it7QegX0p3ajqEd5DRcs
         yQnaFUlnTP8bhTGYZJfNq/XCdHrOYxlKkr5PUR41pk8l270Y2fW3Ix9kPlSphyCQcCCQ
         hIaA==
X-Gm-Message-State: AOJu0YxG5Urezmxm7pzTBcceN1UJBVbRGznfAeHq1e78pyvx1B/N2rx9
	TpoMLUDCUGIwVpod9lUyVzHdxrwA4L5cCzX/q66wfk5f/X0KWQSd7l3ko8p1XVc=
X-Gm-Gg: ASbGncshsuLNSJpY1ZnCC1rIBAoE4sUwQ3VsHGaKOPGwhzUvvEIl1bRlzb3xR4PGOnn
	3Rp1W17vWCX3XI2t549oD3qVxyfK5R3IkYdiikBifyfIJjBfSBsNCrLoz/0cieZtYnQuGX5gdjL
	5bVc4Mle31GKqdxdfU7FZAeR+wSZ4Qo3/TxosVYxUBubns+rDP44UymBz/O4jAKjA9X7EZrptTL
	pHaVyd/f/pdQvxxDirrc/kOOs61dTkYswrnVzwxlgncqsBeDTcAy63tag23oqehaACvRSxeZ/jD
	U0FsmwCukSEg1N+Hk6o1rosmDR1OnXOak7BmzXpkiPdcflaBNdKC/g5pqg==
X-Google-Smtp-Source: AGHT+IEWM9SFBoRyuSSBgmsPzPEyPxIRrWFs5OX1/ahn8aCoiYKj7cEZouWUI2B4dIasMlmRfEjBoA==
X-Received: by 2002:a17:90a:d008:b0:2ff:693a:7590 with SMTP id 98e67ed59e1d1-3030ff08de9mr28123196a91.33.1742851865643;
        Mon, 24 Mar 2025 14:31:05 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3036bbe74f4sm58175a91.1.2025.03.24.14.31.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 14:31:05 -0700 (PDT)
Message-ID: <6cce9fd1-d008-4b63-a77f-c091fcd933e0@linaro.org>
Date: Mon, 24 Mar 2025 14:31:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/30] hw/arm/armv7m: prepare compilation unit to be
 common
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-27-pierrick.bouvier@linaro.org>
 <0c9055a3-2650-4802-a28c-e5d79052bc81@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <0c9055a3-2650-4802-a28c-e5d79052bc81@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/25 12:48, Richard Henderson wrote:
> On 3/20/25 15:29, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    hw/arm/armv7m.c | 12 ++++++++----
>>    1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/hw/arm/armv7m.c b/hw/arm/armv7m.c
>> index 98a69846119..c367c2dcb99 100644
>> --- a/hw/arm/armv7m.c
>> +++ b/hw/arm/armv7m.c
>> @@ -139,8 +139,9 @@ static MemTxResult v7m_sysreg_ns_write(void *opaque, hwaddr addr,
>>        if (attrs.secure) {
>>            /* S accesses to the alias act like NS accesses to the real region */
>>            attrs.secure = 0;
>> +        MemOp end = target_words_bigendian() ? MO_BE : MO_LE;
>>            return memory_region_dispatch_write(mr, addr, value,
>> -                                            size_memop(size) | MO_TE, attrs);
>> +                                            size_memop(size) | end, attrs);
> 
> target_words_bigendian() is always false for arm system mode.
> Just s/TE/LE/.
> 

Good point.

By the way, what's the QEMU rationale behind having Arm big endian user 
binaries, and not provide it for softmmu binaries?
If those systems are so rare, why would people need a user mode emulation?

Thanks,
Pierrick

> 
> r~


