Return-Path: <kvm+bounces-45450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5CD3AA9BF7
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:51:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0688E1A80F3B
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D0E26B08C;
	Mon,  5 May 2025 18:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JwkcXfT5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E67ABA49
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746471084; cv=none; b=cz6/Hqd+Gl9g/mH3booHjJ4F5wSO7ZPtmeGgjGkErmFd5cF0rdcyQ+rvKOmkzbN6eUu5i+SV9uvWk7DW4aVCW7/Ewsbw1dDbNY4hmWGmO0fqb3NwywFS6KXU9WGk8VW2j3ohLHdww59/hCXFfyWxyTLio/WSoHY9Wfw0O5iGO3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746471084; c=relaxed/simple;
	bh=zU9Gyx/LVJyjKW6LkymOUduN/z3Uouz0Tc7MVeBnLPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g51WVIcuW6FyVzOqgt0G9x1gKMz5+ujGsVVkmKwMWHgWdsnFUBgDNy8UESiGJNAlNZWZlzXI8T97bOJ6RonO4D8tSTbs3DIeFBnRs3kBWMnB7pqCs2ysUiorSY10dPDH+uGsNjLtZVZMY/xQsD/yI2NWVxm1mkg6Io6Mc3ufsBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JwkcXfT5; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2295d78b45cso62780525ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746471081; x=1747075881; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DAxYYa+f57aHAbvNw+rs3kNliEbilY3GCs1FN1ZlFHk=;
        b=JwkcXfT5oWj5oe9XAL2KVT2G1bBD91ZfLkuZx37X/qVL8V/TG7O2URQYdLYhAAo9Gw
         TOWtytz/LToOoCcaNjL59u1oXxLYPMPw6IPE9lUcvxLr9AfUY/f8DB+DcQK70wgDpawf
         wlWxiEy34g347nZDa/EgBgwr2HgQx02onQhgF7dgDkmM7RkFi51Cb6sc3BFo9aeH2d+S
         lm+c4MXD31S+LRWMJhY+Vi9WX9m6MDiyEQ+cO4yb6ueivc/MIAlB0Mw5VjgK3a3I1cwf
         Xj46tfIC0FL98nx0rUCncq3DvYZSxi4UZ3y0WV4vX0T2SdnmQLuFbMAVm/Z3Vg51+I/g
         PPiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746471081; x=1747075881;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DAxYYa+f57aHAbvNw+rs3kNliEbilY3GCs1FN1ZlFHk=;
        b=cfWCl5454/Ur5te1irf88UTx/Ta1Tt4PdoxrO9iAjhAavCK0CeGhCZdoOFi1gdKgrY
         LPhTnczVicGZQU6z5hyNY7ZHXKIUwQdeTr+xX4dIZMJHOobe7taxtiwZnKDHO/dMjYfP
         Cpb0df8DhxYHvEGKsNcGygTbro9dBHyGQ2Oy3FluLP6gWs71RT3/4YgTvlvNm5mBdlaE
         EVKb3MNSimjVhRYt4urbbkpj/2YAE7cuW7VyP2UvovUyxaZElV0PGbNqpLqMcCpPUvtv
         w/K7fty0DA7/j23THQ4S6kLTyVY+tbu02kz0JkVp/VNUhpUvzqhg0+ztE5kbz/GF0Dih
         44cA==
X-Forwarded-Encrypted: i=1; AJvYcCWAM/KuoxGrrxqKB6lSZFQN9VwVf0v1naP+p4oSU2gNGzyJqicGH6IViul0UQvQxIDrJVI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq+xdgA+duWbBEYorPXW9xe+SnEnS3EB6C/ByqJGQTMFtP+Itf
	TacH8aS4KReYB2kVlX0ycEXcCj1Tyxhm7SpiMwFXvTr+oF2xFa8qy5lTXWu1/X4=
X-Gm-Gg: ASbGnctg7N4yf/AjFvpboKXNLfKtj1i3CHgMT3sh4H3ubvBkPd3SPvLdzyoKbmLnvf3
	ggzAtbwHT2eUp5DBxLugbsPmBrsJlfjFUwry60Q4p/EmoO2HKmoyrvToLyAmzzBKPgEOWmxJ9xB
	VbGqzbKYNOlEBNcw5JLs+P+T3ABQql74zEnr7t3O4XFlewRZGsVorIIz4m6SGl4b709s2QtJYlY
	Tsa4E2i67ORD7jmAEBa0yIhHnkCZTZTAoOH3eVT8WA2LOPq1QKQEo4owMXEe9nPfiWnxJDP0wVw
	Jf1eehfe2vGphF6c7Gr3sG8mW5AUFud2oU3RLjsBeQqpkxTb5Zw2sjSHpxHaHKg8vz2ZJWeBTDE
	3BMYjdlE=
X-Google-Smtp-Source: AGHT+IH+lsN7TStKXBftqejfHAZR2ZE9pmBQGgu41g9SizVP17mMAL4qD/r2wuGLYimKJYKg/Xf2bQ==
X-Received: by 2002:a17:903:2447:b0:223:f9a4:3fb6 with SMTP id d9443c01a7336-22e328a3394mr7213785ad.11.1746471081585;
        Mon, 05 May 2025 11:51:21 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522952csm58581155ad.185.2025.05.05.11.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:51:21 -0700 (PDT)
Message-ID: <c67c4a79-7855-4d15-8064-b2f448ac9a42@linaro.org>
Date: Mon, 5 May 2025 11:51:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 41/48] target/arm/tcg/crypto_helper: compile file twice
 (system, user)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-42-pierrick.bouvier@linaro.org>
 <79916f8d-2793-40a7-b769-ee109c52ef63@linaro.org>
 <f33fa744-1557-4c01-ba49-e64b4d3b6368@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <f33fa744-1557-4c01-ba49-e64b4d3b6368@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/5/25 11:47, Pierrick Bouvier wrote:
> On 5/5/25 11:38 AM, Richard Henderson wrote:
>> On 5/4/25 18:52, Pierrick Bouvier wrote:
>>> --- a/target/arm/tcg/meson.build
>>> +++ b/target/arm/tcg/meson.build
>>> @@ -30,7 +30,6 @@ arm_ss.add(files(
>>>      'translate-mve.c',
>>>      'translate-neon.c',
>>>      'translate-vfp.c',
>>> -  'crypto_helper.c',
>>>      'hflags.c',
>>>      'iwmmxt_helper.c',
>>>      'm_helper.c',
>>> @@ -63,3 +62,10 @@ arm_system_ss.add(files(
>>>    arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
>>>    arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
>>> +
>>> +arm_common_system_ss.add(files(
>>> +  'crypto_helper.c',
>>> +))
>>> +arm_user_ss.add(files(
>>> +  'crypto_helper.c',
>>> +))
>>
>> Could this use arm_common_ss?  I don't see anything that needs to be built user/system in
>> this file...
>>
> 
> It needs vec_internal.h (clear_tail), which needs CPUARMState, which pulls cpu.h, which 
> uses CONFIG_USER_ONLY.

Ah, right.  I didn't see that coming.  :-)

> I'll take a look to break this dependency, so it can be built only once, and for other 
> files as well.

Thanks.  Building twice is still an improvement, so for this set,

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

