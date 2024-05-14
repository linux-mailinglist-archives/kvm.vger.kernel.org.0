Return-Path: <kvm+bounces-17368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A008C4D54
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 09:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A007283DB3
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 07:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C2F1BC5C;
	Tue, 14 May 2024 07:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="YG1QtCEv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66EB179A3
	for <kvm@vger.kernel.org>; Tue, 14 May 2024 07:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715673193; cv=none; b=uEL0hrbsZOzO/qEHIRogZQu41wUAu+ZPeh3YGsC8qPJ/VhkoswF6qz8oBCgv7MPFU0kQBS6qiXMwW257CC9oNFYTTLQJ3pau4MtLHEmKgGOC48SQrDvcEiNQEG2QrySCuvVjomrzL+BU7ADzISFlLYP85M3qyrPHYT3ArTUbS1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715673193; c=relaxed/simple;
	bh=4BPRRFjn10KTemZVMiXfbzWtTKbIap/yR25p1VitIqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iTo7Sws0wQSylpDxFOgYocyfkPFdPpCMUECGMplG5bANvXOGT2dOoIAYmAedTwGJ9THRVaO1GM1qEc0q3/LjmLo/0OoaALItNOxLhqIEVpEJlfS88Q5soXkPPk4fhHrzf1G0k3MFqHlknQ0BASix/iExQcrnHbdZOOY38K36ACQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=YG1QtCEv; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-51fa8f5269eso1112197e87.0
        for <kvm@vger.kernel.org>; Tue, 14 May 2024 00:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715673190; x=1716277990; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xLTEzVHwu7ZYKj/KSfivTkPQEQSaRSHzucHxEOOY2fE=;
        b=YG1QtCEvwcvEyKCFIuvs7uSvdvIKGv+ODpphQ2TyWi8aNEm8CSrztNmrfa9mvgCYTz
         Z1kQhC4hzMipZrMG5UeoE0S1iQ/1S9Q7A0HWy0r01wIcFhah2C79lGO0YGAdtROQGdQW
         8U8yNXCxErgc/F6qD3q6N5/FcMAta1iI4/BVBCdJ8PXMi2psIJbp89w3Kg1ytm/nG9M1
         UFfTbhV0wA7JbHc/Yq2A9iH8QGOXiWgkHGTO3vwJyEi7NwSUguk4PTVguFG8IRR4ZfpM
         4wD76T2x+hKkd/RoaHq974MefhtRF4Py04rtrrNxy+lFatqsjeMVc9IkbbiXuFXY0N+9
         QWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715673190; x=1716277990;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xLTEzVHwu7ZYKj/KSfivTkPQEQSaRSHzucHxEOOY2fE=;
        b=X0BsseItbKRn8HVJwyxHO2ZWofUrehNjhdQApBTwZ6Hgqj5qocZAlIRWqq4h6RRZZA
         Um04Dbzr9f1Av8HuVp8lJbwEhuhvlae1UPbDSVCkKP1Up2Uu/MBoHv58Q+O7pU7pc42K
         mKx3CWa33gPa4jAZajpbySnmk53AyJ0zJtIiORJB0RpAimHNRX+vOpOoT7/sIhIkEmKr
         HHjh4JJFzv7TjAmlFzSlSmSK4R/zp8nWqU6nixgLObM0cvDQP//Kom3LbQblz6cWzNu9
         j2Q5A5TVDq78+SSn9VD+jrqa5kHX3Kns2VzFpbtCbX5JVYZCck6Pcj3nuLzUoiFUdhkU
         sIpw==
X-Forwarded-Encrypted: i=1; AJvYcCVlPrZ0qpLoqQG/14rxIHCLaYq/XP/OObmaYbu/MUB5lJxCmn3UKoLiTa3v6vROfxBlv7t9bFG91O0sq5qXUxdasjtd
X-Gm-Message-State: AOJu0Yw2tgDRIXxzQ5AGurbs5qF1UKN1DWjQ+8YXGlpMTTxZFLZVzsb8
	wxw4RASnpv3sd6O4a8uRY5kZp/wGd5ygFq+0QIPrDW8G8Zd4QYGsrIUGk38wa/g=
X-Google-Smtp-Source: AGHT+IGAAZ+jOBUCojQGggh22j6hs6WvIQhPLRiw+ncZod2lDfQS/ZA3a8ERikpxDRqLtFBslYYo/A==
X-Received: by 2002:a2e:9094:0:b0:2df:4bad:cb7f with SMTP id 38308e7fff4ca-2e51fd4b333mr72404111fa.2.1715673189903;
        Tue, 14 May 2024 00:53:09 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:999:a3a0:1660:5f6e:2f9c:91b9? ([2a01:e0a:999:a3a0:1660:5f6e:2f9c:91b9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-41fccbe8e3csm185259155e9.1.2024.05.14.00.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 May 2024 00:53:09 -0700 (PDT)
Message-ID: <e57f8b70-7981-42c1-bb04-2060054dd796@rivosinc.com>
Date: Tue, 14 May 2024 09:53:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/11] riscv: add ISA extensions validation
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Conor Dooley <conor@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Anup Patel <anup@brainfault.org>, Shuah Khan <shuah@kernel.org>,
 Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
References: <20240429150553.625165-1-cleger@rivosinc.com>
 <20240429150553.625165-3-cleger@rivosinc.com>
 <20240429-subtext-tabby-3a1532f058a5@spud>
 <5d5febd5-d113-4e8c-9535-9e75acf23398@rivosinc.com>
 <20240430-payable-famished-6711765d5ca4@wendy>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20240430-payable-famished-6711765d5ca4@wendy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 30/04/2024 13:44, Conor Dooley wrote:
> On Tue, Apr 30, 2024 at 09:18:47AM +0200, Clément Léger wrote:
>>
>>
>> On 30/04/2024 00:15, Conor Dooley wrote:
>>> On Mon, Apr 29, 2024 at 05:04:55PM +0200, Clément Léger wrote:
>>>> Since a few extensions (Zicbom/Zicboz) already needs validation and
>>>> future ones will need it as well (Zc*) add a validate() callback to
>>>> struct riscv_isa_ext_data. This require to rework the way extensions are
>>>> parsed and split it in two phases. First phase is isa string or isa
>>>> extension list parsing and consists in enabling all the extensions in a
>>>> temporary bitmask without any validation. The second step "resolves" the
>>>> final isa bitmap, handling potential missing dependencies. The mechanism
>>>> is quite simple and simply validate each extension described in the
>>>> temporary bitmap before enabling it in the final isa bitmap. validate()
>>>> callbacks can return either 0 for success, -EPROBEDEFER if extension
>>>> needs to be validated again at next loop. A previous ISA bitmap is kept
>>>> to avoid looping mutliple times if an extension dependencies are never
>>>> satisfied until we reach a stable state. In order to avoid any potential
>>>> infinite looping, allow looping a maximum of the number of extension we
>>>> handle. Zicboz and Zicbom extensions are modified to use this validation
>>>> mechanism.
>>>
>>> Your reply to my last review only talked about part of my comments,
>>> which is usually what you do when you're gonna implement the rest, but
>>> you haven't.
>>> I like the change you've made to shorten looping, but I'd at least like
>>> a response to why a split is not worth doing :)
>>
>> Hi Conor,
>>
>> Missed that point since I was feeling that my solution actually
>> addresses your concerns. Your argument was that there is no reason to
>> loop for Zicbom/Zicboz but that would also apply to Zcf in case we are
>> on RV64 as well (since zcf is not supported on RV64). So for Zcf, that
>> would lead to using both mecanism or additional ifdefery with little to
>> no added value since the current solution actually solves both cases:
>>
>> - We don't have any extra looping if all validation callback returns 0
>> (except the initial one on riscv_isa_ext, which is kind of unavoidable).
>> - Zicbom, Zicboz callbacks will be called only once (which was one of
>> your concern).
>>
>> Adding a second kind of callback for after loop validation would only
>> lead to a bunch of additional macros/ifdefery for extensions with
>> validate() callback, with validate_end() or with both (ie Zcf)). For
>> these reasons, I do not think there is a need for a separate mechanism
>> nor additional callback for such extensions except adding extra code
>> with no real added functionality.
>>
>> AFAIK, the platform driver probing mechanism works the same, the probe()
>> callback is actually called even if for some reason properties are
>> missing from nodes for platform devices and thus the probe() returns
>> -EINVAL or whatever.
>>
>> Hope this answers your question,
> 
> Yeah, pretty much I am happy with just an "it's not worth doing it"
> response. Given it wasn't your first choice, I doubt you're overly happy
> with it either, but I really would like to avoid looping to closure to
> sort out dependencies - particularly on the boot CPU before we bring
> anyone else up, but if the code is now more proactive about breaking
> out, I suppose that'll have to do :)
> I kinda wish we didn't do this at all, but I think we've brought this
> upon ourselves via hwprobe. I'm still on the fence as to whether things
> that are implied need to be handled in this way. I think I'll bring this
> up tomorrow at the weekly call, because so far it's only been you and I
> discussing this really and it's a policy decision that hwprobe-ists
> should be involved in I think.

Hi Conor,

Were you able to discuss that topic ?

> 
> Implied extensions aside, I think we will eventually need this stuff
> anyway, for extensions that make no sense to consider if a config option
> for a dependency is disabled.
> From talking to Eric Biggers the other week about
> riscv_isa_extension_available() I'm of the opinion that we need to do
> better with that interface w.r.t. extension and config dependencies,
> and what seems like a good idea to me at the moment is putting tests for
> IS_ENABLED(RISCV_ISA_FOO) into these validate hooks.
> 
> I'll try to look at the actual implementation here tomorrow.

Did you found time to look at the implementation ?

Thanks,

Clément

> 
> Cheers,
> Conor.

