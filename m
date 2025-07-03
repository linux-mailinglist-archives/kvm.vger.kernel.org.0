Return-Path: <kvm+bounces-51494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58146AF781E
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 16:47:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F95A3B5C82
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 14:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99FDE2EACE1;
	Thu,  3 Jul 2025 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PHFKQVje"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99341DC98B
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 14:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554014; cv=none; b=WiZ7p4xxDcDzjPkRHR+q5UxehKZYBC/WfLnc1H3U29WDyS5uNj23ml5y/ai+1dClZUDR7pQmSqSBzzHJ2IOI244li2M2WIbHAdhtQnr2DoBZIoGz+TRuMcr3+xvvz8XnPp+qEYPVa4TRK3x2WXWkmtIBut84hEijY39+Cb+9EHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554014; c=relaxed/simple;
	bh=PQPZQGbt0R9wRyl269UGoO2q9a0YZ10xOHJanRN5w34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pDWfkvDRti78vTACPspEozJroeZPiMeRZc9WIe1wmZHLbd0N26KsJsjhMaf6kNV9N0u9lldj2Mim9m/UpXGxjOYBbtdssE8JP3wsnNuvhrC2DPx8Pe6DLlh7b8ot1Yfx6m34e6syoybSprbtqPqNQR0MncDbmfbK/hEYNObEC+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PHFKQVje; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4530921461aso54639505e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 07:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751554011; x=1752158811; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BcGz55w59YWt1Euim5nr6K8+orikmC4If+SmL5rAAME=;
        b=PHFKQVjePj1pScp3W3WTJnUH+77mr+h/S79rufyax7Zn2s4NLXcKyjHum2rrP3ijz1
         hP8dxosMAav1HcsOJFlpSUkvGmlsydZ0MYlldX76utueYhYBGPas1AI74rmjl8ubPpU2
         meT0716W4wZsMQBXtDrx2ydhF+NqzecnDgGPTD8HxQLdYKjDBM5V5DVPAiPCMCaNjWae
         rFPNZBGFolTnZGFVcTZbPx4CP2cX+PuLnJePgHo7XkRdTYQMq72hEbCgmR8kXZLtLzlt
         t8xm8jdtrXLthdUCzwFVueyZcEV8v1z3XUQMAJaK+sSDBTgH6sEv9ynm9MJWVxSvQ22S
         Z/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751554011; x=1752158811;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BcGz55w59YWt1Euim5nr6K8+orikmC4If+SmL5rAAME=;
        b=UWU7g5uRzGlLmKaof4njsxXs781ZVDpW+VpBo0yPnqsztv8oDOEC1T20q+1zL8tEiy
         rlk61GNb7Aj9gL5Nq7yjNj/xzyT/9M5IUYZ0cdxiBaAuhfVVHaNtumYoP3/qcw+M0dW3
         +FGBUxqyUebZ8c0fvhEv8rI5WhBx0GrT28YUyhQbQq/DUVj4TWf0szNb/84ZgdUuXE8h
         OaK50XOnI/wHC1ITloLV2GJLvvKYKPazbLWE8wlPB3kh2YHMeq9C14R9YOZ0gV866Ef1
         rC3Y61pzRcSpM/xNObp9qqBYrPSijLgGE9VRgtTLz3MLM37W5PtyhhbV2h13GiW9vcJX
         ZTog==
X-Forwarded-Encrypted: i=1; AJvYcCU4U04Fdo6Lw+scEFhVTsVVpJSI35AHX7d6AKH7MkfCmc3Q3RAzxMKk4jlFe/bspNlewOQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1MSJppl2MGXuL5plHolkaf+v8qjqfe57nzz0ygEuf1KrlLzIy
	a3dwq1Qs9DG5RwE4to53MamhScKQfr1Wxg3x6i3DmXBnQAxL77EwdtxhSguWm8/d4e8=
X-Gm-Gg: ASbGnct8fBd4OK3QHwo3DMsNeVUlTidPzhD9qfteKgEDE+gOd5t5dDuwTsoM9XKAWpu
	ULXR7xkiNW0rm8EVLHWlOCtyYpQDPzOlP4bAyHLebvzJeVucZ4WPuhaHhFNLncpVHnYIFUYzE6/
	YFkyW0jSwrr+KdO3yLnQLPnR6TaXmahgL3WbT6RlZE36sM0Tx+OLUKRlW4W1DJKcfNecXPLHyxC
	JrK3umwvdr5F/oSMKgqNcrJh3PimiiywBjPNQ1KOk0kQoo6OetlouiE7lNAgsVcN64MkS86TsDK
	Mjo+x8wE6nrqKdJPmpB/nVLogEcMVQ0yC2J85YxQqw/a4Y4PXG33Pf5lFljA/Q/jRKo/HRcy7Bz
	mtfjweMTZcaqXw74IrYQcE6va2Hn4Ew==
X-Google-Smtp-Source: AGHT+IHvMWtjH1+AiR8aOx6oFZN4XcRnQW05gxpTDKHmHDoS6vbn6KlCaKQgBpMcCZmZSsP/tHlapA==
X-Received: by 2002:a05:600c:4754:b0:453:1058:f8c1 with SMTP id 5b1f17b1804b1-454ac6122a3mr32948425e9.3.1751554011011;
        Thu, 03 Jul 2025 07:46:51 -0700 (PDT)
Received: from [192.168.69.218] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e52ad2sm18590233f8f.48.2025.07.03.07.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 07:46:50 -0700 (PDT)
Message-ID: <e9d806f6-95e1-4bee-be41-46baee9a251c@linaro.org>
Date: Thu, 3 Jul 2025 16:46:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 47/69] target/arm: Use generic hwaccel_enabled() to
 check 'host' cpu type
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org,
 Richard Henderson <richard.henderson@linaro.org>, qemu-arm@nongnu.org
References: <20250703105540.67664-1-philmd@linaro.org>
 <20250703105540.67664-48-philmd@linaro.org>
 <364dc354-ba78-47c6-ac65-2c0282e28733@linaro.org>
 <CAFEAcA8-ucEJPgVLpBfNyMo8ax-sR6iYr5Zk4DJavYaOkQnfDA@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAFEAcA8-ucEJPgVLpBfNyMo8ax-sR6iYr5Zk4DJavYaOkQnfDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 15:46, Peter Maydell wrote:
> On Thu, 3 Jul 2025 at 14:45, Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
>>
>> On 3/7/25 12:55, Philippe Mathieu-Daudé wrote:
>>> We should be able to use the 'host' CPU with any hardware accelerator.
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>>> ---
>>>    target/arm/arm-qmp-cmds.c | 5 +++--
>>>    target/arm/cpu.c          | 5 +++--
>>>    2 files changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
>>> index cefd2352638..ee5eb1bac9f 100644
>>> --- a/target/arm/arm-qmp-cmds.c
>>> +++ b/target/arm/arm-qmp-cmds.c
>>> @@ -30,6 +30,7 @@
>>>    #include "qapi/qapi-commands-misc-arm.h"
>>>    #include "qobject/qdict.h"
>>>    #include "qom/qom-qobject.h"
>>> +#include "system/hw_accel.h"
>>>    #include "cpu.h"
>>>
>>>    static GICCapability *gic_cap_new(int version)
>>> @@ -116,8 +117,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>>            return NULL;
>>>        }
>>>
>>> -    if (!kvm_enabled() && !strcmp(model->name, "host")) {
>>> -        error_setg(errp, "The CPU type '%s' requires KVM", model->name);
>>> +    if (!hwaccel_enabled() && !strcmp(model->name, "host")) {
>>> +        error_setg(errp, "The CPU type 'host' requires hardware accelerator");
>>>            return NULL;
>>>        }
>>
>> Consider the following hunk squashed:
>>
>> -- >8 --
>> diff --git a/tests/qtest/arm-cpu-features.c b/tests/qtest/arm-cpu-features.c
>> index eb8ddebffbf..bdd37cafecd 100644
>> --- a/tests/qtest/arm-cpu-features.c
>> +++ b/tests/qtest/arm-cpu-features.c
>> @@ -456,7 +456,8 @@ static void test_query_cpu_model_expansion(const
>> void *data)
>>                     "ARM CPU type", NULL);
>>        assert_error(qts, "max", "Parameter 'model.props.not-a-prop' is
>> unexpected",
>>                     "{ 'not-a-prop': false }");
>> -    assert_error(qts, "host", "The CPU type 'host' requires KVM", NULL);
>> +    assert_error(qts, "host",
>> +                 "The CPU type 'host' requires hardware accelerator",
>> NULL);
> 
> Grammar nit: either "a hardware accelerator" or "hardware acceleration".

Fixed, thanks :)

