Return-Path: <kvm+bounces-16233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 337A08B7509
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 13:58:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A9CB1C21B98
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 11:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936F8383A5;
	Tue, 30 Apr 2024 11:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="gfax4WYZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F247813D272
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 11:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714478296; cv=none; b=TMggF76JTUdLRShHLTjSuUaim06+n6N2+bQiDTIaeogeYQtWzP7uW63giDdM0vMkPpvii7MwARsAC2UXUqzB6pWbRVAnYn1Z2lCGnc6zNluJELnBgrk9a2ISnn+ZNmcde/ORxZSnGWcVBrTQ7RGcE0F/NE/lBwgzKAKLubkA3vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714478296; c=relaxed/simple;
	bh=4Id6VGdf2u95AiGZLRjJqIidD6qWkQ0vVUrWA2CAko0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UaPRdqzYNACW7m2JjpZ9hJtmIGtcGCQfAfTJ4/Nw35PBVF/pQMrONFnY0P/pq75o9N+HguNJv5W/2M1q3kmuSonPVlYbLqmr4Qpe2g0xq+wMDCAmk4/fT812FpJenJyUwBcI3MwCeYV2ocIMCr2rH5xY2T+FT5rbJkUppXrXpUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=gfax4WYZ; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-34aa836b948so973071f8f.3
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 04:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1714478293; x=1715083093; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OzSSsyfFzBl2mcBYufKCnCUvVLKXjpztnM9DRhV5I5Q=;
        b=gfax4WYZVWRWHneERJ5B9qLZ+IGdyGTAn1ajTfdxobuIBSH9Y1VwduofRqT8pXlEnt
         B3eRiNcry74gnR2ZfzleUYU1cpIdZ33M07dJcB+DId08lzZtiwbagmnV4Q9rur4JB8Ue
         vV2Z1vZ0RB+VXCNn60bFd8JxrQchN9+M/8AUKqyBIT3QuHtsPIg4FT7yxKGDsGho+e66
         Lc3Ca+RGcPxE8Z4I270KgfAfkDM1pW4eCl57wXctjEQIXM3bfX03uj7QelroWUb68+pm
         j3ykx8JWRwzDyOru8RKRvXYplu1uJwRBUBPdCNxiNqHQodkZYPJ4CRM2oSEPEfPq/tdk
         GvTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714478293; x=1715083093;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OzSSsyfFzBl2mcBYufKCnCUvVLKXjpztnM9DRhV5I5Q=;
        b=fht3TtTEFv+vyy5Ze9JLh7AnUyhLVZVF6COC1IVoDhG3/j3SOdY/ywg1Or0ciKKIg7
         NY4OaITuaJC/+6M26d2sUdk/yN+Z6068aLruwtBOgmiiOOfmOm2jFfJI+9NMrbn2RWiZ
         WsWXGh42Wt0lwK0xh15Cg46bpYCcgIrUYljlreO1QyNXb1nrv5rp4da8xapIoXVvbXO8
         GPpLLI/pgHa/GWv4ijyhtqfNRlzqUhgrYhE8pcb/iqtjYQ2aomDRrRPqODVjI32xZGht
         +hph4eG+WfnbjWc4v+7eEmSj7+vkT1K8NX0FgpYTvViacRIVkxjQhfgzP8pw9wVnyl4V
         s5ig==
X-Forwarded-Encrypted: i=1; AJvYcCWCa8T9+qoak6lGW6JBYbb5hIinOTQ989u4z8lVIn/4ohT3HdxoNz+hYuohY+rRx00Wlst0EFWG1mOc2AHGhJSwZg3y
X-Gm-Message-State: AOJu0YxvlN6u7j/pC4uV0xB5ai9PZ3vfBUI6lmqVj0iupRZAbYroKRpg
	OalKp1Kw4VmPYJVyVGsCWUoWBjkcxnv9PSp8ypTBMRJIWKpdW4tqkXlPXLhvAUA=
X-Google-Smtp-Source: AGHT+IFowi0uScE3U6kwtOLic0zxD94ruOb8GXnQAwFE/D5XSkJPVJ8UzE8OGVrMPrp7yPhK24S50A==
X-Received: by 2002:a05:6000:1756:b0:34d:af59:32bc with SMTP id m22-20020a056000175600b0034daf5932bcmr103435wrf.7.1714478293117;
        Tue, 30 Apr 2024 04:58:13 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:999:a3a0:c21b:67fd:90ab:9053? ([2a01:e0a:999:a3a0:c21b:67fd:90ab:9053])
        by smtp.gmail.com with ESMTPSA id g17-20020a5d5551000000b0034c5e61ee82sm10843260wrw.67.2024.04.30.04.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 04:58:12 -0700 (PDT)
Message-ID: <dbcf0be9-eae6-4776-bc5b-c6fad58df9c3@rivosinc.com>
Date: Tue, 30 Apr 2024 13:58:11 +0200
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

Ahah, I would have done it if it would have make sense and add any
useful support. But AFAICT, the current implementation solves most of
the problems you raised.

While thinking about it, I can even simply it a bit more. Once a ISA
extension bit is set in the final mask, I can actually disable it in the
original mask to avoid looping over it again. I'll send a V5.

> I kinda wish we didn't do this at all, but I think we've brought this
> upon ourselves via hwprobe. I'm still on the fence as to whether things
> that are implied need to be handled in this way. I think I'll bring this
> up tomorrow at the weekly call, because so far it's only been you and I
> discussing this really and it's a policy decision that hwprobe-ists
> should be involved in I think.

Yeah sure.

> 
> Implied extensions aside, I think we will eventually need this stuff
> anyway, for extensions that make no sense to consider if a config option
> for a dependency is disabled.
> From talking to Eric Biggers the other week about
> riscv_isa_extension_available() I'm of the opinion that we need to do
> better with that interface w.r.t. extension and config dependencies,
> and what seems like a good idea to me at the moment is putting tests for
> IS_ENABLED(RISCV_ISA_FOO) into these validate hooks.

Yeah, see what you mean. I think we also need to define if we want to
expose all the ISA extensions in /proc/cpuinfo (ie no matter the config
of the kernel) or not. If so, additional validate() callback would make
sense. If we want to keep the full ISA string in /proc/info, then we
will need another way of doing so.

> 
> I'll try to look at the actual implementation here tomorrow.

Great, thanks.

Clément

> 
> Cheers,
> Conor.

