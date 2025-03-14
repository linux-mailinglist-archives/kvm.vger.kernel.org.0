Return-Path: <kvm+bounces-41071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C578AA613D6
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:41:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA7033B1D00
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E478420101E;
	Fri, 14 Mar 2025 14:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="iGT/Lh2B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF00200BB8
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 14:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741963216; cv=none; b=GxcrA9ZO4Pkwn5Wp0g4jouQf3grHekROvz2oeqDw2+2TA36OhgN35WlDERbRhynRUy+Wn/pbN7qG19SKTUrTO+DmhhpmSs7675Zf98Rz90EznIJRfxWjf6wMOwaF8kfMIa/ae9UaMclzUjsNc3oOSmD3zNLEG5EhHvxhifUMAME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741963216; c=relaxed/simple;
	bh=nfw0RtGDs+JYFChSu3zbhx0B/5coaK9bdLpUJTsFWJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WQZtD6SooNGUkrfRoq6oSHvxzBZK44Aq+n4BxnInsPmg8XCjCsipHLFbSFjr2fsmxUBrz5IWFibG0WIgUipEz7YMMT7jEIUU4qx9Zs1w++tKnksHbZU1j53n+47DRccXL+GTJuKQXVlCLe3FUJCPmq8nPOdDKDYyNl+WgMRKEEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=iGT/Lh2B; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-39141ffa9fcso1832693f8f.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 07:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741963211; x=1742568011; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fxgj92qNVf8hUC6pVQUheuB7d74bdJSB97loH4AdJvM=;
        b=iGT/Lh2BsYNMA4q5iHCJ4XF/7XgxQWQve6wBHJ07KgPVOtyI66gpo2ZCk767OHkZQL
         7ZpVAN1bP1QryxCenPO++HL0t1PbclHlMRlHOXhsZTRNzYtxq0+x2QN3q5AFH+7le6EK
         Tb9qntaLGlNzhE8aTcL86P0O9aU9Uof2QleYDUmuXXxLQtnNEbg0Nsl0IFiShk+2XShi
         9LLRvoP3xUL10vQq1Wd2K0c8XZjubX4gX8uVcL4G0HvUc/t0ja+W1dLYm8Zo/2WHBzcZ
         Nl8iVLob4Zt8MGcvXCbFnGay+O3lTC4KMj/FcC7tyO18Q3szOUDXW9ot0iGoBGTW4HqB
         1S+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741963211; x=1742568011;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fxgj92qNVf8hUC6pVQUheuB7d74bdJSB97loH4AdJvM=;
        b=dCosW455PpIgE2cF+6XSrnjBMDEnGwZ8Tb0OZ+81Ng0NlOxQ/JfBUrnCHid9nHyXVT
         Nw0gPV4I6iwCRwba8+mtajn1Kz9BBVOFG2f7bZV75im6oP7QLj+sy94O7wfCREtTKnOH
         LCyizmXJwk+nuUzAnvx3dgoKdzIxWCp4MLACNJJDxIllCImY/VXG7AJIusA2/dfcJuxH
         lmIhFlqmJbhHbJ5tfLvJEGwamUerUMaq0pPCC5hYa5BocPRkRfj2iSOASFT3aZgWwQ0K
         1rE47H2FdEwXwsmBbuPTpk+l3nStfIf3XhslY4xbPhnAyuN/M6L+b212KmK1f2lw3Il6
         BhZQ==
X-Gm-Message-State: AOJu0Yyul6GRG8Ud2jmcfjaUnfN1vISFLWkIdKMYRO9DWYesYhTFmQNb
	KnuNyPtN+snTvzNgpM5MZNeVDYx+h9je9HKaxiaTmLWyDlmTCxwHCHPnY6OOXCI=
X-Gm-Gg: ASbGncugEhdu09hhwmZC4E+xj7ykgQXA1S6rfgN07JBiBe+57pV2Kl4E9b5qhMi5Nre
	MwjXhUnxPCj/iRz01t6w9QOMxnmzWBZ9vvyfZ+nOpoTpuKIJGS8pbxaZMXqn6reHf9QRgdx77QI
	LxH4IFU/z8Ofpn0c7BReW18kVbS4KYadeyTQXfCYIJEcEKOWM1Dng/RjZABOwe/QBx0An8wDVa/
	yvIGdOE+C2Mj4WvmhnsB3SRFompPJEXOL4b0j/pvUzVidZ8MpM5KwFK2gaLT5t1HUXfiOdaoeBR
	qjnKF2WzdKrTPaJ5suL8IxwZEkTeJ/5yPjBYrRC47/Lf1cahnsXsI87MUk/UeMzlRh1hnapUgmz
	X6vPVfm3butrZmk3nkJkMwH+y
X-Google-Smtp-Source: AGHT+IFa+aTBGHkeFzcMLxBXa2JTRA6YhHMQUjt/9S3iJBqwVboXGugV53IwLhO2jIlrkkQYoi0gig==
X-Received: by 2002:a5d:584d:0:b0:38d:e304:7470 with SMTP id ffacd0b85a97d-3971d8015d6mr3449285f8f.25.1741963211193;
        Fri, 14 Mar 2025 07:40:11 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1ffb62ccsm19220165e9.7.2025.03.14.07.40.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 07:40:10 -0700 (PDT)
Message-ID: <d9a386a5-2ee6-483f-b78b-91e682925700@rivosinc.com>
Date: Fri, 14 Mar 2025 15:40:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 0/6] riscv: add SBI SSE extension tests
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250314111030.3728671-1-cleger@rivosinc.com>
 <20250314-eb8cf0b719942c912e254ab2@orel>
 <eaf88dbb-39bb-4755-830a-7c801099c790@rivosinc.com>
 <20250314-2452599f59b82e53e99100e7@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250314-2452599f59b82e53e99100e7@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 14/03/2025 15:34, Andrew Jones wrote:
> On Fri, Mar 14, 2025 at 03:23:39PM +0100, Clément Léger wrote:
>>
>>
>> On 14/03/2025 15:19, Andrew Jones wrote:
>>> On Fri, Mar 14, 2025 at 12:10:23PM +0100, Clément Léger wrote:
>>>> This series adds tests for SBI SSE extension as well as needed
>>>> infrastructure for SSE support. It also adds test specific asm-offsets
>>>> generation to use custom OFFSET and DEFINE from the test directory.
>>>
>>> Is there an opensbi branch I should be using to test this? There are
>>> currently 54 failures reported with opensbi's master branch, and, with
>>> opensbi v1.5.1, which is the version provided by qemu's master branch,
>>> I get a crash which leads to a recursive stack walk. The crash occurs
>>> in what I'm guessing is sbi_sse_inject() by the last successful output.
>>
>> Yeah that's due to a6/a7 being inverted at injection time.
>>
>>>
>>> I can't merge this without it skipping/kfailing with qemu's opensbi,
>>> otherwise it'll fail CI. We could change CI to be more tolerant, but I'd
>>> rather use kfail instead, and of course not crash.
>>
>> Yes, the branch dev/cleger/sse on github can be used:
>>
>> https://github.com/rivosinc/opensbi/tree/dev/cleger/sse
>>
>> I'm waiting for the specification error changes to be merged before
>> sending this one.
> 
> While ugly, I'm not opposed to doing an SBI implementation ID and
> version check at the entry of the SSE tests and then just SKIP
> when we detect opensbi and not a late enough version of it. If we
> go that route, then please create a separate patch that adds a
> couple functions in lib/riscv/sbi allowing all sbi unit tests to
> easily check for specific SBI implementations and versions. (We'll
> probably want to steal the kernel's sbi_mk_version and add an enum
> or defines for the SBI implementation IDs.)

Based on the fact that it actually crashes on earlier OpenSBI version, I
feel like we are not going to cut it if we want it to be reliable on all
OpenSBI versions. I'll take a look at what you propose.

Thanks,

Clément

> 
> Thanks,
> drew


