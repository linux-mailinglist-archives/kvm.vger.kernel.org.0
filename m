Return-Path: <kvm+bounces-41869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 278EAA6E5AA
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:26:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C235188B054
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 747AD1E1020;
	Mon, 24 Mar 2025 21:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AXujlnWF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33ED1DE8A5
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742851441; cv=none; b=XIsV5knptGkB8fzOLMQB8nqaYsPK6msQ2TzdvKFnRymhZW1gsdm0yUYMAPRXoPnWkSUvyNROs83oJ31D7pGl8IpGZqrHVWTIKPsQ2mNC+qDJrHAE5bwwPbp2kbWC0WoZ8GHKFZ60j6uhRoZwPUM8icUoiG1gFR1PX2Rf9pSSMZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742851441; c=relaxed/simple;
	bh=+I+tg0zav5R0xJhktJlDUjoPn/cJHqwZ7lWzZoKaKJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jpISkjbmoDAjxCCj14NaLmYMzOoHn5pMZv20k+apw4M7YRSJ6YDgQvlgImLmBKzPiuABpzEGJErboZedY9hTUC9+Xf0lh91JIhVeylNCnA75s+O0bJyzDDFsHwPYZR5jIlzEqNLBLXgndDRQJSTVq/pkDwaQk4zehpdEiktRHQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AXujlnWF; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ff4a4f901fso9027819a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 14:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742851438; x=1743456238; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YFDA0JeDDrgv1GyZMFNeItH4CS9p72cfNWmfFzJWQlc=;
        b=AXujlnWFIHC0r7qlSZI687ItXTtnl3srv8kiy5UvqGbkhS5sTXZlTEbX+IqqTVpnq9
         lQ74893z6nwUdaA95DGz4CMu5sY7oKDYtlXu55WYutaT9TivK1Au44mm4t7f3jE4QyH+
         QRwv1auoUq1EJMlHbUSbfb1IBcHN10hW2zYbYYSCPCzyFxHSu9Cw3yYKgU+5Wyb8SdI6
         X5oawA3HAgG59UPJenTc1s5tLbcOgztwtBxByYF9/9NRkacMBGWgyYQ3ubdUhSABLLIC
         yeRWffeEp8gwCLuAQLbhktlE9jxrtK2VonEh5Npioh2w2HbbjXrfm/R/RYiBmOkptZ0Z
         41kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742851438; x=1743456238;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YFDA0JeDDrgv1GyZMFNeItH4CS9p72cfNWmfFzJWQlc=;
        b=Ggg2jThyn1lbhKEycbYpyR59eUf0R/7PhUIVTbg6qbh1EdHy2pZWJHH9EFe/iXNMi5
         ImXmYHT52CtzYkV/8uCUqYMaHRJr36ke7CBgY8yfrrB3asI1ied/6oJHPTYLUXfoc9DT
         D+O5siRIW9ez91wTa8YrI+Ax9RZ4Lif3RRb4DnPYG8YZUAY4JqEAM5Kz8Qj4cVRP9+uy
         hJyMOgxhEqrU4BvihwCeKPh/OMjFhFX/Fjfwz7oMpZQ2v0dIgGOoGV0MaNLZiE9fJQ6L
         gOtQlrxtt2561eqaVJNbpmybcGycSyOGR8BHCmPPm/xSnZqI79DPNLZ08/46Ayyrt/1m
         iPHw==
X-Gm-Message-State: AOJu0Yz2RH77lU2FSTT9y4VTfV51XTwWIwxSHZZQI+kFC4/eh+PZxM1h
	XT/WY4Ss6UrquqrvJi/qHhNgxy4uNcWsCIaF/AMdGRXZoPmwvqzPZQDu1/CTjMY=
X-Gm-Gg: ASbGncvz93EBFeo1br+2eeSBQsqimvbTPqJzGpHOCvBkT4Zf94//BFwgRtPrevNIE6P
	yF40ymKu+/8UvjiAA2NRWr1+xlbrStwb/0YnKzEujMdleDNw4uQ8Qh3/sDYbucnc0wmF8hYkFZN
	+dKMowiZt1pcvQF40ZT8bDiEjYBUVcOcV11MsrCm9KyROOyO9UpRdkIbuu+vIkel5npK94yKkvV
	eiM9tPqifFjLAU6LRJkSoEeFBGHdJEn8xCrbMBSnVkbzegHPDxLy2uCPs4EeABiSK/oHq7RzF3L
	toxDEHVq6XtUkT+86VqyCexWcA7SgPLghXJ56XG4CXbyXwfp1iwsjOPZ4A==
X-Google-Smtp-Source: AGHT+IHB6vBc7OKIKXxCYp0nll+Xe+XOOJIvF5rYK/LZ5u7+okuz4kyrpEKI3McVEYD3sWnzIOGaLQ==
X-Received: by 2002:a17:90b:2688:b0:2ff:784b:ffe with SMTP id 98e67ed59e1d1-3030fe93ef7mr24860497a91.11.1742851438122;
        Mon, 24 Mar 2025 14:23:58 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3030f5b7891sm8763029a91.1.2025.03.24.14.23.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 14:23:57 -0700 (PDT)
Message-ID: <314709e0-3b1f-410d-bafe-37031629eed1@linaro.org>
Date: Mon, 24 Mar 2025 14:23:56 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 28/30] hw/arm/xlnx-zynqmp: prepare compilation unit to
 be common
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-29-pierrick.bouvier@linaro.org>
 <2a7a2a78-02cc-4954-85cf-b72f37678f36@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <2a7a2a78-02cc-4954-85cf-b72f37678f36@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/25 12:50, Richard Henderson wrote:
> On 3/20/25 15:30, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    hw/arm/xlnx-zynqmp.c | 2 --
>>    1 file changed, 2 deletions(-)
>>
>> diff --git a/hw/arm/xlnx-zynqmp.c b/hw/arm/xlnx-zynqmp.c
>> index d6022ff2d3d..ec2b3a41eda 100644
>> --- a/hw/arm/xlnx-zynqmp.c
>> +++ b/hw/arm/xlnx-zynqmp.c
>> @@ -22,9 +22,7 @@
>>    #include "hw/intc/arm_gic_common.h"
>>    #include "hw/misc/unimp.h"
>>    #include "hw/boards.h"
>> -#include "system/kvm.h"
>>    #include "system/system.h"
>> -#include "kvm_arm.h"
>>    #include "target/arm/cpu-qom.h"
>>    #include "target/arm/gtimer.h"
>>    
> 
> Is a better description that these headers are unused?
> 
> Anyway,
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>

Yes, I'll add this to commit message.

> 
> r~


