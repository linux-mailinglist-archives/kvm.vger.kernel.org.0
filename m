Return-Path: <kvm+bounces-45443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85587AA9BAF
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:40:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F92D7A91C3
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A6126FDA0;
	Mon,  5 May 2025 18:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pEGy03oY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D585526C39B
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746470384; cv=none; b=ZxkCMT2puOmKQzRkIVyjBIkpjYy3WjMwDrsJ7sADZESd15UG1iVc2G2d0uwkxbU/HiX3xkUztfJNBs2A9mR6FbTeyVqxJU3xhFeyls4rxm3mP9+lncDfnTsHu51H9+zH+NUvP73oqGWFdbyQIjTsUouwzmfRh5T4PZOCBbtqRyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746470384; c=relaxed/simple;
	bh=lS9KBsTdGY8ONZwx+VctHA103wVUXTrA5DOcQ63QzO0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BOfKakgkkHp/IzDBD0B4GuizcA1n2gBc9M1Fi95DfRSDgM1Ugh+vMJZyDlDk/AYv2Z5rPT4gxvmLL5ob9aFxl3rny7J6aKuFS9Yc0Zq+pTA+gjMpJ5fpOGTJ+SEovclD9atwyunblWciv1XDmbLvst7dGMHqsfQYtQ1NMDLaZWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pEGy03oY; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-73bf5aa95e7so4546772b3a.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746470381; x=1747075181; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wjp7WHX6S8/97RAjKa96LznAbJzgoQ0PQ76T4W+qSTM=;
        b=pEGy03oYWKYKWHRK4NLrEjdQ8kpEyrYKdAcf6we8TuaP8O5BgB1JrYXmmTU11NIcRY
         R1QUScWhCcN3Knkm8DsIPtbrYK7TsDwk+3xW9S0hl59SIjlYAPfaoSHTQK91vxU6R+QD
         Zg+4QAfa4/u1cLguAp8TL6FAJbCl8EClv+1MQm1YxbaLhvnAxYsxdg6vS+RV1p9/04/b
         YmJ2VSGUVQVjWZK0x0ypaPGCtUY6t42aJwrtZtd4G47MtzUucJEeFXYsOkb0Fn5/ufqL
         SL+hl26X8vMlgaLGpBF1IOlfhkAWBBM8k/jF24nq22FolMePbDxyzN+kbam7OVmBFdur
         OVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746470381; x=1747075181;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wjp7WHX6S8/97RAjKa96LznAbJzgoQ0PQ76T4W+qSTM=;
        b=nrg8g9keZO/7G5++1IMeFxr1UYVCvu3uhxpgh6AlOYv0pFFTpDjjgHmofEHfx42TXQ
         mxop2l8tVoQpGu55MW72Gh6hPhXILiO8I9vjTVShbkCLyx1RSwkJYWHbwkb2Zzz1ubGN
         MLSCMSSZhgIpXTKf9ybCSCqp9b1pcuKhT2YYOBA4KAAvgghAByHwXn6ei+yhG2AbuLXk
         9coA25F0sThJz67yxvgA70xE2SyXZxf0fsKavNKtuCwzbcSx9uZcmAQ1umbR6idHZPbp
         QZEwdypiRy0++cNB+vMs6rRHSGaWoqytoCx6ypB7Z7T0E1NStfPYpuGEpWrHeP5VkhMq
         sqmg==
X-Forwarded-Encrypted: i=1; AJvYcCX0S8bDTFRwXig5YQ7Aml8LcyR+kUbMZdaNpEp1OqndEl5gEavPeVx6ShQ0By2I+8TEem4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBRieVDZkJhE8p/EPKdkCwl2IflDywiDgnC+9naE0ps4EYjiz/
	e64+/xkjQVB+QqBIRtDdftjYYQRVaazSHhYRhKz6QkVPSzrU4Xcz+Q/gVM8Sv1Y=
X-Gm-Gg: ASbGncvSDlNHADarCmTSHEDDqfy0Dfyh3oKnenLKMNiD25TtvkVzT+bSrydQGyZe6yt
	MAUS9HVPUm5thykWFfIGXTZiqyDRvKAIuqFEDyb4+C4d+e5ufy3Xj8Jp56HFZuqwHi4IbZ3DN8b
	MTN6Xfzu4nexfKaiFIw9yrSDfuIsor7Ft11/bJfVq08ueXfhE4bYbI2n19WKU/juAocgBsvGyV/
	+wiP9V5ZzXLYAgM7b6koSu3Ky3CBVl2Pf0HcOQgCbgEagZ9CbOIY2Mx3w4VTq1MVXre75AZPHmn
	zOSQo9CWQggnHSEVBcCockuaclz/NVU7CX4fcMA1WeDYxZxIkekGWwZRddBjGPaj
X-Google-Smtp-Source: AGHT+IHIyGDEwNeuR+yUkZvgvcAQgfoZ8WOvYMCeAlTVmL+ZY9t98NrBZlqA2uVThyjTLh1YetB/tQ==
X-Received: by 2002:a05:6a00:2a08:b0:737:6d4b:f5f8 with SMTP id d2e1a72fcca58-7406f179679mr10222756b3a.17.1746470381196;
        Mon, 05 May 2025 11:39:41 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058df43c8sm7188761b3a.84.2025.05.05.11.39.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:39:40 -0700 (PDT)
Message-ID: <a365d727-8bdd-4b27-a763-08c5b3384040@linaro.org>
Date: Mon, 5 May 2025 11:39:40 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/48] target/arm: Replace target_ulong -> uint64_t for
 HWBreakpoint
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-2-pierrick.bouvier@linaro.org>
 <dc27e3f6-ceac-4e05-9652-28634d4fe73c@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <dc27e3f6-ceac-4e05-9652-28634d4fe73c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/5/25 3:44 AM, Philippe Mathieu-Daudé wrote:
> On 5/5/25 03:51, Pierrick Bouvier wrote:
>> From: Philippe Mathieu-Daudé <philmd@linaro.org>
>>
>> CPUARMState::pc is of type uint64_t.
> 
> Richard made a comment on this description:
> https://lore.kernel.org/qemu-devel/655c920b-8204-456f-91a3-85129c5e3b06@linaro.org/
> 

Thanks!
Once your updated commit is upstream, I can rebase the series on top of it.

>>
>> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/internals.h   | 6 +++---
>>    target/arm/hyp_gdbstub.c | 6 +++---
>>    2 files changed, 6 insertions(+), 6 deletions(-)
> 


