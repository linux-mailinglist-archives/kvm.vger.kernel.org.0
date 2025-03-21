Return-Path: <kvm+bounces-41732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E90A6C5DA
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 23:21:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E3A01886D51
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 22:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F741F3BB7;
	Fri, 21 Mar 2025 22:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ve6b5koF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542211519BE
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 22:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742595564; cv=none; b=mXxl9YXDx7SpIPVJZCK7Ze+7OAGvuH+75No2QwP1Cn7Dc7Vd5SW0sGIP8OtPpW3dOldnXBE7KaUL7Id5KapPk3ywGeh1wNg/BWBS7bh0cP2HOXyxrAU7xJDixERV8i3y6ky3aX231b92gtjsk8g4NL/1Usz3mJBALbPD9jU0CZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742595564; c=relaxed/simple;
	bh=E6vCNsKbFDL5t+Oh9vylOnfFyrtyqOxq9LAWiye5QGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O8bdTV14qBpu4FOWlVs8KyEaFtS+eD9c46DS5bYlEkMbAhXWxIKrumnITHwRG5QZmUuCP2Z0mfWVMy7aM4WVe4FAd+JWhCduGibDXwCyy25V5ZmmnSUOM+uuYBWoIGvdOGXqfQ3wVnaS+eAh/BRDyuHY+dHFY017CcOOBvdC+3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ve6b5koF; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-224019ad9edso62016005ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 15:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742595562; x=1743200362; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2m5L+7pt7GeWrU7Kt4b77ijay6+lliI8NzQ5LxIHZMQ=;
        b=Ve6b5koFKvUl/O06TuQEjccD6w6RPamQIQp9z6p4p8oBRbj/KW4xRu2o44l9LmbQbA
         fHWf1gP2jrxJAW12SwAAyvpS2bziwpZhphhV924ip/etdSlXfoTptsQvzKhLGZPwngQt
         ZvAQOuBrGXp1XUGGH7UgR//3SABl0Va7u+V9K369YwH33jGzF8Eno7ATjPiKbr6Npt+C
         QlVtlboPu2zjdrnJDHZk/BjhPzXAuf46ZaBlxUuzyjP8SqJjDiO5eNqMqqoo8iRNnDNj
         20iq6P2983x/ATw5zPhTAOofuk4NexpiIRN6nA+hYNeaE9afCwosvONVEPSyjn5KLq4a
         LC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742595562; x=1743200362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2m5L+7pt7GeWrU7Kt4b77ijay6+lliI8NzQ5LxIHZMQ=;
        b=M/mHQ+ujtXHc9XhQRBb1mMe6xIdHbkSjv9CiG4EfQO/eta8yC5s5RFL/skC7brNCOy
         sI89DNOziZw/Bq5N0SvMSBZwrP8/7aEYo5np73L3NRLUWt1iazbykbeg7Z6MYMSkovx6
         WCYvIinQ9zfEnr9N+i299paq1LjQontIxWhabcxdYZXQ/Qd/2C0L65TtZsY3r3a4iVgA
         PwPUC9WdYdWRn3zXL6GBi50twSMgzDVEGSpitdgDPKEQ4DOR8Ige0uWSazwzxx4xmxMx
         3+ypu4hSVT5ZfdutRqM8db/So16iWlGvKDig2VYCOVdRV1KYNx9HwiK3KLn8MIatw2O/
         4N4g==
X-Gm-Message-State: AOJu0YzRApwYVuYR0CNd0BjEs7vesoz/YxsTN0FYEMrPANUHazW64QHH
	LVTQJ6BaPvikWnxy1Q38gP1DTvVVaaEJzfKKKGpF7hFwzyFgf3G1IatCdSYANEY=
X-Gm-Gg: ASbGncsUN1Fu8FV02sjXprhF7lxa0/hjww0S5KzRyO5VoTLFx1w29Aqy2Cra9z2Y7MC
	zbKqwaBTdaE//eXlrZTTePUBHA8uCkSDzkA8jOnIAtHxb1cKtxs5PBhyW9cELYOku5Uk78Fc1HN
	ro/90qHbFWLonV0SIuXcp4SyEEmVwwfhQJKz/H4M+AtjQTTC1mD0+QUWO7D5FRne18ArzXm3hhq
	ePdLSucEp7kk/Fn7HT8IrcLqRV3EyYYQGBCvxDDKviq5I0e3BDtarDog3Qkzf+26E9G1CX7oybB
	gypLynAMgo2VRNO/MgBweQEyD3Er/z232oAqRbALqJKAO0eefvMHTxkuw8IRGRE8wbu7VkMd73L
	UmOnICvJdHywyWtkV0l0=
X-Google-Smtp-Source: AGHT+IEW6cQdABbMHDm5Jw4zpDdOGnA50ctGXbvRzVQOXJyT4XTYONXfp+PmiJ5E+lNB/pujFV4exg==
X-Received: by 2002:a05:6a20:2d23:b0:1f5:6f5d:3366 with SMTP id adf61e73a8af0-1fe434371c4mr9545558637.37.1742595562592;
        Fri, 21 Mar 2025 15:19:22 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a28058f9sm2346075a12.24.2025.03.21.15.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 15:19:22 -0700 (PDT)
Message-ID: <c0e338f5-6592-4d83-9f17-120b9c4f039e@linaro.org>
Date: Fri, 21 Mar 2025 15:19:20 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/30] exec/target_page: runtime defintion for
 TARGET_PAGE_BITS_MIN
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-18-pierrick.bouvier@linaro.org>
 <2e667bb0-7357-4caf-ab60-4e57aabdceeb@linaro.org>
 <e738b8b8-e06f-48d0-845e-f263adb3dee5@linaro.org>
 <a67d17bb-e0dc-4767-8a43-8f057db70c71@linaro.org>
 <216a39c6-384d-4f9e-b615-05af18c6ef59@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <216a39c6-384d-4f9e-b615-05af18c6ef59@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/21/25 13:11, Pierrick Bouvier wrote:
> On 3/21/25 12:27, Richard Henderson wrote:
>> On 3/21/25 11:09, Pierrick Bouvier wrote:
>>>> Mmm, ok I guess.  Yesterday I would have suggested merging this with page-vary.h, but
>>>> today I'm actively working on making TARGET_PAGE_BITS_MIN a global constant.
>>>>
>>>
>>> When you mention this, do you mean "constant accross all architectures", or a global
>>> (const) variable vs having a function call?
>> The first -- constant across all architectures.
>>
> 
> That's great.
> Does choosing the min(set_of(TARGET_PAGE_BITS_MIN)) is what we want there, or is the 
> answer more subtle than that?

It will be, yes.

This isn't as hard as it seems, because there are exactly two targets with
TARGET_PAGE_BITS < 12: arm and avr.

Because we still support armv4, TARGET_PAGE_BITS_MIN must be <= 10.

AVR currently has TARGET_PAGE_BITS == 8, which is a bit of a problem.
My first task is to allow avr to choose TARGET_PAGE_BITS_MIN >= 10.

Which will leave us with TARGET_PAGE_BITS_MIN == 10.


r~

