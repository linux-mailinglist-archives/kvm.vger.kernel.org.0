Return-Path: <kvm+bounces-45289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EFDEAA833A
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 00:26:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1E9B17D99C
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 22:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DBE1DDA14;
	Sat,  3 May 2025 22:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TkgB7Ku7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAFD2DC799
	for <kvm@vger.kernel.org>; Sat,  3 May 2025 22:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746311165; cv=none; b=g5c1eN+Eqpm+nYcg2ELu22U2ECJ63IamrdXOsZb278ILlxsn8U3d/d56ks14ktJ+wUszkmVuv+elWyd8EQ6PYusX0HUAZHuskz/pOGh4D3WNH4gY9eThMODHPZfRcWywELuMBe47/tVM56C3G/Ur0IsRuCuSJNKJTPJWqWa9ANs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746311165; c=relaxed/simple;
	bh=Gyu9C/36o2ldr7oH0FNGH24Tq1URNxSLkMlee/ssJfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FmlBQeNPo9I60K7kIPxorTqN7W77+Prgam6S0AlytWeKoR7on8ckG2ZM6KPpyUsYgV1QPjYq1sZ9RnhgYcO48/6OGkDo8QeZMHQ3uknWABLD/sG+0T8OEDetljc7+8hFe25zdLVTQT6f+/RtHehCe++xWO5lnB9RELhDiHt/HMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TkgB7Ku7; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b07d607dc83so2701479a12.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 15:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746311163; x=1746915963; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9i08Z+jcxbTTH6KQSk61zUEyMsxpIEuVYvglLCm0+hA=;
        b=TkgB7Ku70h42AmZzjze9lojcpgZfkxsRygAgCP3d2hGE7HMHCK3uuWqpeZ13Hf92LG
         bJeZdmK95QhA5KrBNNzpnYSBfTVtNjuTjK/qzdG/6UL50RvsNuMiyaCx0qahb5AnJonK
         cYUDShAM8WqBTD8hxGr+GYfIjWCPZ17l77vOejxuSI/nCcOLqMrzgAVB4nhbSm2RtE8I
         qfbtIQs1d8L/Ypn5B5lKtL8iD4e34gH+57O+HZkf7I8iZtfOixYm4cburD1PTWIqAqM8
         IKMSjmp8t/vuvSsMOxzW5xFgg1fhjGPWrvWsQhA28yIUHSYWKYhOOHaPg13/sIMl7wf7
         6bgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746311163; x=1746915963;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9i08Z+jcxbTTH6KQSk61zUEyMsxpIEuVYvglLCm0+hA=;
        b=D1HaUaWOHpuwPSDKeQ6kVN1z5g99KFCBw5Nb5JPrpXUSU8eG/6hG2dJp4JLwjV3RgN
         YhcMPsMUZnKGJIY/e0amIqcmJ8fBL4vIcG018S6uYmzIKDCBd1W3kQXf0OqDxhutb1o3
         rVg4Wm0kcEwxfRLq0ySxeHwbI3NYbZROXYimtXqfKOcGsnQdJp+d2IM9+tzufUyd8ps3
         F4QgPtgo3nKCUhhKCYqyrNySFFUuini3Vvt12vhFr0o/0bqUMZvWFKnYTTLkBaPlCtrG
         D2yzWy5zOU0Mpvc6E9lpmD6vtODx9AHQ0tVB6fJ1L6ggU37yD0JmFKDsJXA2GlvUjV4h
         5HDw==
X-Forwarded-Encrypted: i=1; AJvYcCXgJnnBmFV7ANisb0+xA58p78tiOV2KJyxmRJsRROI33G8JCzu7zJwIe0m6QqynjUzblOM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgzlNpLKZH/mqzp3XYxm8TSRqJX26CCYy+hU6yqSNiWuu9rrAz
	02rMey6kGnIlq8BSLc3glVgQFgQho551+ifQwOh6BUVgFOb6OY6a+V4OJmQfJRk=
X-Gm-Gg: ASbGncsc64Z+Sl+5JWzr4hmJH1gX8OmmP6TPVngtJH5rFT/86I2I6iy7ObO1xPBjHnd
	EVbTpCNdpI+2ahv496yTsvQMs/W9uFD+DWswb6j84Ykgidokednl6IOBx2sIouO1XXGudMZRU+Q
	GnbQlDZ8lIBdaMRljya6YaYWRlVZ9Yk+zYWoicPyHn9rotReyo4z3lE1Piz+mHohE1w2+djjXIa
	9e0ScACTj4JSxSQ6v4CfjOmjPI+BngYMZi8cAUJRIQb8FgldQLJqLjbFkDmYA0NBVOmwQpsxo0Q
	pt0ah6M9xMs9mmE5ATuDb4a2SS1MxbcubNhzFKslHtembFy8clFBIy0ls+6VVVnG
X-Google-Smtp-Source: AGHT+IFVS6pgrVlMsUM12y7XK5SWDSNHy0AmYyU8HwZ9dIIHsc3zzGiZRrDxyDbWSBlN9jiNSw7pwA==
X-Received: by 2002:a17:90a:e188:b0:2fe:a545:4c84 with SMTP id 98e67ed59e1d1-30a61a7473bmr3079491a91.34.1746311163552;
        Sat, 03 May 2025 15:26:03 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a4745f61bsm6240193a91.7.2025.05.03.15.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 May 2025 15:26:03 -0700 (PDT)
Message-ID: <f37f5c9b-74ae-4c92-a731-803ec883b08c@linaro.org>
Date: Sat, 3 May 2025 15:26:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 25/33] target/arm/arch_dump: remove TARGET_AARCH64
 conditionals
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-26-pierrick.bouvier@linaro.org>
 <91c5f1ac-105a-4567-b1c2-e1d230d8cfc9@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <91c5f1ac-105a-4567-b1c2-e1d230d8cfc9@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/1/25 12:30 PM, Philippe Mathieu-Daudé wrote:
> On 1/5/25 08:23, Pierrick Bouvier wrote:
>> Associated code is protected by cpu_isar_feature(aa64*)
>>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/arch_dump.c | 6 ------
>>    1 file changed, 6 deletions(-)
> 
> Should we assert() in the callees? Anyway,
> 

I don't think so, as call sites are guarded by cpu_isar_feature(aa64_*).

I understand your repeated question on this topic, and I think a good 
guideline could be to assert only when there are several call sites, or 
call sites external to compilation units. For a static function called 
in a single place, the risk to introduce a regression is quite low.

> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> 


