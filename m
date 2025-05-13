Return-Path: <kvm+bounces-46373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF27AB5ADC
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 19:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7FA14669B0
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 17:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52562BE7B8;
	Tue, 13 May 2025 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k0ukUyas"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A6314B965
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 17:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747156340; cv=none; b=ctWmhf2Ln2U4Vx4TRTHM3biFf2U1S3WmFRxgNtFVSsCLNU9uR/cye7DzMERUPnJDJCq1Eqq8dkmoXFZzNEy+AeuXBoXNJcQ6k5gDUG8AN4PMoLqSRAmI5Q/yTgAO7/eRZcIwexkuGSFj3bO1RygiAE3PoJ/Q/T3s0xGXOG1IG+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747156340; c=relaxed/simple;
	bh=zDeqED1y2IZRsMzoAzb0EoEMyzdbpkNXQd9guf/fZcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CdGzRcgezuXHuOjj3pRH45k/7+f8h+ox0GxK9G3lrtwMu0xpNSCW5xNjMjM+hHuwyhUxu/cLhopa+pzxCDwpVZWO1ONX4C0zzlAUsUdyk3S0gRRphjM9mzW63bEBguTtpQrLihUmX3wvI+YM+b14hsW49Jx8GDa7+uWf9xiFgys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k0ukUyas; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a1d8c09674so3267032f8f.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747156337; x=1747761137; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T540ncNJFrqke0ZjSBQ7eQ9JCXacMOXT7j2qsKpoG/8=;
        b=k0ukUyasVSwfKCnJM/Lj3PPfdXT4cJkiFGmTwjY6GkA6+GjZbcpLmt031340obUbMY
         u9HQezi97AwLRfPMtctNc0V3k0uXd95LSIiKVdfFAZfZMn8fnnoq6YJhMefxn8r7njGt
         c8KXO4HrOUjxV5WCFKuKK25DpxE9aSuVRkTZ/De8zbnpjf3Rb5BcQsP9/R7mN7smqMdC
         GxG8OuKsT595OEkMqWlpB4MRKs/psMhwOe4csKhYizDgh1T2menzqpNNzlHGC5hHRPbV
         mcE2OzBT5lQ0+LhMLTroJj+CAnfKP1DH2Q7xNiYGsCDNM6AenKor36LNxiIQStYayPnZ
         g6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747156337; x=1747761137;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T540ncNJFrqke0ZjSBQ7eQ9JCXacMOXT7j2qsKpoG/8=;
        b=g4nm1uyxg0tUCt+ZQLFbJG7dRuaXEqLyQTa5oPJtmJku+PY6linkeUIAv5BJow1cQ8
         PxfQaS5mDAjKXb9vhgc6wDxwaHDPW6HjkrN7btF7NfMj8gdCWLSGAg7RyufUnWI9E6xI
         avrP4ci0oUKRY6wDC4tEe6E4Zx5CFyT4rDoz8rRHzzQD89nj2vVcuehwWmY3VO+b8BhQ
         DmO6hOUKpnefmho0uYg+PjbR9OiNdM5lFDxscUUfxEs5kUF+lcPa4J0AEyu2eby/k7tI
         uvwMINOcY3gTbvsM0TDLIyOHjmTyX8Turh8k96FvDGQ8+8+fxSISS0uT6dtAt0wiSsYL
         /R8Q==
X-Gm-Message-State: AOJu0Yw/qDfv34HNx7avQmEFacZBQqB4ouEKel6Z4TrZebAHnxW+9cDl
	2By95SYuHTk7gNsQY4fNYgjO+f+Ej2JctdABSHv6VSD3eqYCs2x/GTv8GUlXGmk=
X-Gm-Gg: ASbGncuhhnDzg7BQGhgHdxEG+O5H4GNA814HZQO8FeVWhbGGSrXiC0Bn9WoWoA5YK1b
	dej9euMaW4yXO7wpaNQ1sAqTAyz3XYyvTupFtcdjd/TYJaYsYcYk2C0+bdTNsWDJXVOhZb9pTfJ
	1bzoKt1sN98wZhKGZ9bju/yIUYJySr/oSXX51K+Yo3nWl/dT5VCu56WHFURFLMd674P9FhsrTaq
	Kg4mHKDLV4RRfjwbiJzFS6HQ/3OMsAjplyvMXUW2dnnp8AMRBV4PEMWJJtrN2Eu3Q/w2M0+zOgc
	W/hJSbWC+sfQsQ39JMyN0XlViaAAnVR/gLrjGuKXC3Y2DmYY0o24+L0u6axr94QTMnIevbtIwJc
	QHMwLNzrMkLJCwwjctA==
X-Google-Smtp-Source: AGHT+IGL16BdFJ++J2CAKTAD4h7uoECpiXj/ZB09lxvIo8wt2EW36FWymJLMvbNmNt0byDIquGel8A==
X-Received: by 2002:a05:6000:1788:b0:3a0:b8b0:440e with SMTP id ffacd0b85a97d-3a349928fd6mr75822f8f.45.1747156337122;
        Tue, 13 May 2025 10:12:17 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58ec8f1sm16629888f8f.26.2025.05.13.10.12.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 10:12:16 -0700 (PDT)
Message-ID: <cb2798a2-e673-427c-a83f-2afbac59751b@linaro.org>
Date: Tue, 13 May 2025 18:12:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 30/48] target/arm/ptw: replace TARGET_AARCH64 by
 CONFIG_ATOMIC64 from arm_casq_ptw
To: Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-31-pierrick.bouvier@linaro.org>
 <91cd9b9a-8c67-47d3-8b19-ebaf0b4fab5d@linaro.org>
 <39c6f5ab-6e45-491d-a0e8-07408e29e2f8@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <39c6f5ab-6e45-491d-a0e8-07408e29e2f8@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 13/5/25 19:03, Richard Henderson wrote:
> On 5/13/25 03:41, Philippe Mathieu-Daudé wrote:
>> On 12/5/25 20:04, Pierrick Bouvier wrote:
>>> This function needs 64 bit compare exchange, so we hide implementation
>>> for hosts not supporting it (some 32 bit target, which don't run 64 bit
>>> guests anyway).
>>>
>>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> ---
>>>   target/arm/ptw.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/target/arm/ptw.c b/target/arm/ptw.c
>>> index 68ec3f5e755..44170d831cc 100644
>>> --- a/target/arm/ptw.c
>>> +++ b/target/arm/ptw.c
>>> @@ -737,7 +737,7 @@ static uint64_t arm_casq_ptw(CPUARMState *env, 
>>> uint64_t old_val,
>>>                                uint64_t new_val, S1Translate *ptw,
>>>                                ARMMMUFaultInfo *fi)
>>>   {
>>> -#if defined(TARGET_AARCH64) && defined(CONFIG_TCG)
>>> +#if defined(CONFIG_ATOMIC64) && defined(CONFIG_TCG)
>>>       uint64_t cur_val;
>>>       void *host = ptw->out_host;
>>
>> I'd feel safer squashing:
>>
>> -- >8 --
>> @@ -743,2 +743,5 @@ static uint64_t arm_casq_ptw(CPUARMState *env, 
>> uint64_t old_val,
>>
>> +    /* AArch32 does not have FEAT_HADFS */
>> +    assert(cpu_isar_feature(aa64_hafs, env_archcpu(env)));
> 
> Why?  This is checked in the setting of param.{ha,hd}.
> See aa{32,64}_va_parameters.

I suppose the "AArch32 does not have FEAT_HADFS" is misleading then.

Better if no changes are necessary and this series can go as is.

