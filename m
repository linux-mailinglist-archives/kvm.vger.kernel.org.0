Return-Path: <kvm+bounces-41529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BB3A2A69CA3
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 00:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 696B67B06C1
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 23:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E8B2223339;
	Wed, 19 Mar 2025 23:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b/eLfvaL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07021CCEE2
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 23:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742426244; cv=none; b=C7HNfoJjWDZ7h3VLjOux2ju9/3O8aCNHAS6oHVFMwUzvFAYErx3Zq5iF77lNbq0W5JkptUYh11tseR88+sU35gOqGLhqFxhBaUucVJggSLNDTXndPw9nrWrFIT06TC3IfUfRh189HKxdUrb0HXUvHCDj6a6gE93Jsrbu9w3+h4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742426244; c=relaxed/simple;
	bh=A79DNgjXTVQlEIF2lhL0L1adWEkAUL2gjfJrsNqns1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e10tuBVcEqSdLUOraFMqVMiXNhYxzz4xBxIvmfBGstEJPLMh1CTxRBwXdt7FgnkUk4yrawQm5VkxYLv8bk6g6dxstBkK7rvodR+V1B/ko8cQjdodcplvG2vxEBzk+fMshNddFmo4gFVaBr9hU8I6Zcaw9eNiz2TMRUIvUIOVL4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=b/eLfvaL; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-223fb0f619dso1684445ad.1
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 16:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742426242; x=1743031042; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ttP94RHuaW+AA9Kr1WQ092r9FjI6PwOL8z/bAPk2OEs=;
        b=b/eLfvaL5O3LFyWq9QSbjd+EFR++AFEjgGWJU+uitN7+5Lp0HVQkso2FYVKfGwlzdj
         9pVajDT61pebpfN50H8hefc4F73OmKHO2Bty3I6EdBnzcomlPQhTmwfON+Z9z6APiplt
         ekdy4yVg4NxPcH2Onb7dbuB/JC9XfFXWjlq5J88+EO5LXQ7Ce5xruXRsWtWU99H9Pe7C
         IRzezlYUq/JWWMbRcavGyQ8eoU7LNY2wVNAwPHNZ6+Jexp6MtKfutRJJId6tNydHJtnr
         m3bpECf931KYKevDqLRzxD1utpJyhYtgMBya4p/FFGRlFshHSrOqnagCxQvDtzqoptW8
         afmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742426242; x=1743031042;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ttP94RHuaW+AA9Kr1WQ092r9FjI6PwOL8z/bAPk2OEs=;
        b=pOR2DbfKJvAzG86+qRiIb3y2qmLW+awrBbB8/rAq3JzDIgOFid0KOpp404s8eDeZo3
         C6TSZx6b/YdQnCliNaZnyqtjc06ICUIHIVSIIbLIYTu+LFa2H+lPNLwWtbTXqVXAEITr
         1DJ7/KKgVQRDO3QhuCvJVwv+0+x8f1KmZZu5XBA2+0Kol2CwBmXZLJ5USgHSU32NSagj
         ewRK/IXXsBa67quChGAZWZ/4AFjpbyUm8jX/WVmldi1FfOnYbBX9KbJh1RvDl1dlBV+d
         OcYutAa0lEypWcYHQ7fzHWFbRfURJ/B3bEHD43ggtjc+ss5AZMSTSKYRvpfodOUs449R
         PFLw==
X-Forwarded-Encrypted: i=1; AJvYcCV2YP6ahfOEGov72p/UrdVJ/y0bxb4gO1japXSGuHS+JfE7q8mRHqd5bxUjrnn0ZKzXonQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBcwak76xtkPp0ThRnJTq/d0EAmKebfBmlN7I8L+6jcSOc3TIp
	+ySZjoNbpNHrtMFEHLlw6sQ+U+IqX9Nnra3L970bJ8q/xDELsEqmXldjdENT4Zw=
X-Gm-Gg: ASbGnct1qP3ANKsYAUuXRQAfF43kXDEMG1bjU15e+sZ5jBO1urJJJBZWzt7XxUkVpH/
	bQbOEmvUpTHDHLVrGzkV4bK9oOijE8Go0kE9ubMzmFYEVi8L7MXTYrmooXxwxCrx89CfVAxYCMM
	a2ZWAbdx/Hw/Kq4Bl4EM3UySBVEO/vxOWHpt4+mm4L/+zee9ZHbGa25tez4dnEMrETzPuospMv6
	Xio4H1owCe7TGv784l3G5WYFgK615bfe8p+O5qpOu0QLiQqWBZfXLl287ll/YHBRag0QVJrtuYL
	/43j3mMOtd933D6yu2LMfQS/xEGFlpGDkf+UuS47t9NwHjsiOGzKU+bRaQ==
X-Google-Smtp-Source: AGHT+IEtBsTb1UciPJqi6Yn3xnP4BzsUVR1YgdarGKsS/r3jPqAR67hjwo2vl8jyIQenMvjoz3v6cg==
X-Received: by 2002:a05:6a21:99a0:b0:1f3:3804:9740 with SMTP id adf61e73a8af0-1fbeb999249mr6978385637.15.1742426242185;
        Wed, 19 Mar 2025 16:17:22 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9e0fd8sm11540538a12.26.2025.03.19.16.17.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 16:17:21 -0700 (PDT)
Message-ID: <8ddf1e1e-7570-475c-aae1-fa715f983131@linaro.org>
Date: Wed, 19 Mar 2025 16:17:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/13] target/arm/cpu: flags2 is always uint64_t
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-9-pierrick.bouvier@linaro.org>
 <9556c183-c103-403c-b400-0942d42785d7@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <9556c183-c103-403c-b400-0942d42785d7@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/25 15:40, Richard Henderson wrote:
> On 3/17/25 21:51, Pierrick Bouvier wrote:
>> Do not rely on target dependent type, but use a fixed type instead.
>> Since the original type is unsigned, it should be safe to extend its
>> size without any side effect.
>>
>> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/cpu.h        | 2 +-
>>    target/arm/tcg/hflags.c | 4 ++--
>>    2 files changed, 3 insertions(+), 3 deletions(-)
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> 
> We can also remove the comment lower down about cs_base being
> based on target_ulong, since that was changed some time ago:
> 
> exec/translation-block.h:    uint64_t cs_base;
> 
>

Sure.

I updated the comment to this:

   * We collect these two parts in CPUARMTBFlags where they are named
   * flags and flags2 respectively.
   *
- * The flags that are shared between all execution modes, TBFLAG_ANY,
- * are stored in flags.  The flags that are specific to a given mode
- * are stores in flags2.  Since cs_base is sized on the configured
- * address size, flags2 always has 64-bits for A64, and a minimum of
- * 32-bits for A32 and M32.
+ * The flags that are shared between all execution modes, TBFLAG_ANY, 
are stored
+ * in flags. The flags that are specific to a given mode are stored in 
flags2.
+ * flags2 always has 64-bits, even though only 32-bits are used for A32 
and M32.
   *
   * The bits for 32-bit A-profile and M-profile partially overlap:
   *


> 
> r~


