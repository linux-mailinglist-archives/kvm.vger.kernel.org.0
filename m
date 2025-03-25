Return-Path: <kvm+bounces-41879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B898A6E7EC
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 02:22:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3C49174ED6
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 01:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A64397DA7F;
	Tue, 25 Mar 2025 01:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WqD+Nx4B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3692EB666
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 01:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742865767; cv=none; b=rvZ7mRsqmygxRmnMqwCsPDmCBXpEIECPw08T92C/0oWAXunM9xtFCzqLeI0QiNb2hiqTfs9l8BWN76zHvMtk/To0fSyGqNMsKr8XvEIx7BGdAFScI8/qSXN/mVtzlsUGEAOH8edPDfxpuUXYb7JCLUwleecMYHPKHnBBp/+KbnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742865767; c=relaxed/simple;
	bh=DJ2wKrVyy1KcKnzPvcjD2wFIJBD1US9UlIJCqIZMxVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VwJfNu3n0QV2GYt9IbiCadIjskdcQy+P0RAUTpHQWow/USNU6gS+LQQLw0B8bP+jegaXehHs5i5TEDHMRKAceIHKjM2JczEpNDbf2cCi0gfTexxR7sA692gh+O5Yh9SNrmzknVY6COC830jPAx+lVOeCjy6eGcq3MmfRHLkJhpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WqD+Nx4B; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3018f827c9bso6823267a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 18:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742865764; x=1743470564; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aG/ikolZ9gVRmszvosTh9e33E/vQ1AmQm3yTNYjPZIM=;
        b=WqD+Nx4BjE83E6jxgUFKUlo0d77/j+2rE2JmldQ1Y+C+aBPMaDmHq6OL53Pl60odvf
         DthNIeuZtLpwlOVA+5TfvCmjGr4S7NieC0y+cshvegA047l2Wpvak7laF45g/IZOsBKo
         ZbPThXkdOKe6k9jGxE7Fpqkq8Fl5GYsbfHqLm9AwDEPtf6p08ZhVw/8eik8VpEG8aP6s
         A0SUuvqecMwVpIm3O6w7nkaBtypahTNdaSbuov9obVKQdLO9Zcl8G1VsV+hxcz6i9FVk
         WstTHFvCAOsrQT1jk0YhHYfwdx0Y0G6mt352w1eNAHtCy8Y4er5Kd4KuXzuDJ0HADQcR
         BNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742865764; x=1743470564;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aG/ikolZ9gVRmszvosTh9e33E/vQ1AmQm3yTNYjPZIM=;
        b=sxUM7ifGpQcaJdwupVCQ0snyOmNoTcHEtzne0cwOSdZzjQqO3Ejqy9tqfoVw1GlZoM
         xxhVlYXGbc/CEJyrcUYYY9pxFpFpMMwhkvco+w3tjKnRVJQEXb6Jc/3JCqs98DD20eFt
         MI8LHJ9QQfb53eIE60PX3XulFMp2rYg2V0L4ZIjSlPlAbd5gWIqBAcwFkwyL8rtkcCng
         uI2s3y0mEnR7TjKOOgylqmOKkz9OR4iDHYbMXjntflUtdHq9iNPkRmD0GFHNeaP8brGU
         6bjhJhokaS/Q/nsWZmPsMcsdWEcCe8WGauWssuXCHeOCNfxtiPwL3BTOR+TSCcesyd11
         VuDQ==
X-Gm-Message-State: AOJu0Yxqufyh2ldYGTmourzxhlOZV5ZKSxBw58ReorPFiiTWfICgAgBQ
	hK24AB+GwxDz2TrPi3oYj0qhIZ5PVFtEIzaTb/nTffHMiFC2UeymU1zUhTYeaOk=
X-Gm-Gg: ASbGncthEnCgfLof+n88U3gkeMBOBTUM1UG+NvxKLlarEYruKtp3Kc4q4KmF6ZQMRuj
	Spn0Ku0uiEvFyh8KRzjBTyOKf0636ATh4VjXWHLZroDHPs/kGhsX3jrya4K0H1zvrPmnPpMd0J4
	ZdaWxs+bDHAU7d1ScO2TwnCH5j/tBCyjB7UrF+sd7XG/48fcQX5lf/gxtjxzdVWjR6n2TfI7oXw
	uEJ6TuMqeFzi8RIgXQwOxnRKbGzHIz65I8izOe7kgm/esDc8j5qjUzi2f2dWSuqYRiwVKlTBOSf
	Hi+PHSlsDRD2K7C/tNy7eWN7EAe0SNBFRF+QbIkvc/pTwG5JoNA35npmgTmV7gbkVzqNoxWcE0j
	CLgP2P93D
X-Google-Smtp-Source: AGHT+IHEZCg9xs1G0ztU1F3GqMs42dpDB5T8VAwisopTv+ewq4W5/2ROGq56Z/iMGj+HJJwkTysYNg==
X-Received: by 2002:a17:90b:2743:b0:2ff:4a8d:74f8 with SMTP id 98e67ed59e1d1-3030fe721dfmr21437984a91.6.1742865764131;
        Mon, 24 Mar 2025 18:22:44 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3030fe83d50sm8832615a91.24.2025.03.24.18.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 18:22:43 -0700 (PDT)
Message-ID: <67313299-0ce6-457d-ace7-73ad864a0eb0@linaro.org>
Date: Mon, 24 Mar 2025 18:22:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/30] hw/arm/armv7m: prepare compilation unit to be
 common
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-27-pierrick.bouvier@linaro.org>
 <0c9055a3-2650-4802-a28c-e5d79052bc81@linaro.org>
 <6cce9fd1-d008-4b63-a77f-c091fcd933e0@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <6cce9fd1-d008-4b63-a77f-c091fcd933e0@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/24/25 14:31, Pierrick Bouvier wrote:
> On 3/23/25 12:48, Richard Henderson wrote:
>> On 3/20/25 15:29, Pierrick Bouvier wrote:
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> ---
>>>    hw/arm/armv7m.c | 12 ++++++++----
>>>    1 file changed, 8 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/hw/arm/armv7m.c b/hw/arm/armv7m.c
>>> index 98a69846119..c367c2dcb99 100644
>>> --- a/hw/arm/armv7m.c
>>> +++ b/hw/arm/armv7m.c
>>> @@ -139,8 +139,9 @@ static MemTxResult v7m_sysreg_ns_write(void *opaque, hwaddr addr,
>>>        if (attrs.secure) {
>>>            /* S accesses to the alias act like NS accesses to the real region */
>>>            attrs.secure = 0;
>>> +        MemOp end = target_words_bigendian() ? MO_BE : MO_LE;
>>>            return memory_region_dispatch_write(mr, addr, value,
>>> -                                            size_memop(size) | MO_TE, attrs);
>>> +                                            size_memop(size) | end, attrs);
>>
>> target_words_bigendian() is always false for arm system mode.
>> Just s/TE/LE/.
>>
> 
> Good point.
> 
> By the way, what's the QEMU rationale behind having Arm big endian user binaries, and not 
> provide it for softmmu binaries?

For system mode, endianness is set via a combination of CPSR.E, SCTLR.B and SCTLR.EE, 
details depending on armv4, armv6, armv7+.

It is IMPLEMENTATION DEFINED how the cpu initiailizes at reset.  In olden times, via a 
board-level pin (sometimes switched, sometimes soldered).  We model the board-level pin 
via the "cfgend" cpu property.

In any case, for system mode we expect the guest to do the same thing it would need to do 
on real hardware.  For user mode, we can't do that, as we're also emulating the OS layer, 
which needs to know the endianness to expect from the guest binaries.

> If those systems are so rare, why would people need a user mode emulation?

IMO armbe-linux-user is extinct.

Debian never had big-endian support at all.  If there was some other distro which had it, 
I don't recall which.  Otherwise you'd need to bootstrap the entire toolchain, which to me 
seems rather beside the point.


r~

