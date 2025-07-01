Return-Path: <kvm+bounces-51177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 426AFAEF4B4
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 12:15:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 697837ACDE9
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 10:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B490626FD99;
	Tue,  1 Jul 2025 10:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lR20NJVc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E363A2701D9
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 10:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751364914; cv=none; b=HFq9IsbcaV36j1TM2Fzh67Zz0/JoCQxoy+1cZco9/ctcD9Vr+2FJcFmm7Ranpjt6i0gKYKz3Owe/WPkwPFl1j7ElcqiO0zC5mli37cZmifU/Xfhb76kZJI+Y/ybAk13XNreH1yC41duMfX3CP+a50Q+7I2FEUcNWl7R8CojujKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751364914; c=relaxed/simple;
	bh=YT6FGno718O1pM/xKVUvSb9c3U+S65MEJS08wUBfa2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tib8gYjt5mocH8wUio2TnJIoVozZmW8d9GMVEs+AP7gR1bczpPwKAmOVpP2zYrEAqTgXORVCw+cziy7+resmgf4o5UF0nksAxpYQJF5k7aMuSYXlPwMkIqHh9Uu2oKXqMP9Jb60Ohn2nt0/SrTJbD8/drIRt92bJhNP92TUbn5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lR20NJVc; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-451d41e1ad1so35909215e9.1
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 03:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751364911; x=1751969711; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aCAWKACQX2fPUuLCEOQi2kKR8kfTCXZQfgtxYqfJhnQ=;
        b=lR20NJVcoj7bJPzow5zpmMfb2LuMpYyQ9OEmpPImZOEFQOzf+vbHODDeH4FGOIuVt1
         cL6LAvUa7sR15lhheIeoXCfa/YvldSs4cimLuMdYPrUnw1NQCA5HfZMUjE7j/21Yaq+r
         M53iWAQZlW62kYvkeOHBEyqkURH7J7ViabHybk3JbsFitn6nhTEM22ZpolPuzIOPu1Ny
         HAimm5B0fnaQq9Ri2ZS+wF/HMMzgGPE9SwP/V/qsgVkM8zYTvJ0Ehx9gnZLWo1bc/EzI
         nJOvq6OejxqvIRrvMTGhkcNOmU5Jy2/rdeqDDhMlrNfACS7LWTbkw+fg5Z+NC1AsDmbH
         Xhbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751364911; x=1751969711;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aCAWKACQX2fPUuLCEOQi2kKR8kfTCXZQfgtxYqfJhnQ=;
        b=KxjKWQWbkQmIS/5iSXmyeNGDJr0GJ9CL3XwguWlr65+ZErvzT76N5mgiKyEbB6Fgo4
         5WGEvpyQaljOWGdnsKHp5tr+4FK6EPNzPBejEGmhM1gVt5rVoFENRHqFnhmy8pKZPCXt
         b2qG0Q4D9QxyvQpZVXooCbl7bG0yE3ZXDO922s5aeUq8SnF8n0k5pBoS3SaK4T7iqECM
         CiDm8FnCkiCOBsYIOBJREJcPbQWYWiFM+2PII4VkHc7fwx50+/JmF+zLdzdZF6TyxhFQ
         mNBGeVTj6+TX7W5lG1NxQ/vjSb433WZ8ZGeCsyQR3o+Vjzc2e/w3Gs78pCQS/gnpRthP
         SUjA==
X-Forwarded-Encrypted: i=1; AJvYcCUTjciaFUJ5RF2o1pm5i3zT2RONpKC4qnGvfZIWcZfbxnuAHpJQEp4u6L9OQSdTRatRDZA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRv/5H/Na4Y505uLY1/qeqs4UlTyklTtnpuNIJdQBKABEHjF6F
	F72FkiYnXd1n3LaC2PcSZjrEInnMc+5dlx0/FzRP4eUBExCWVFCZWC7mDGrP41r3PCQ=
X-Gm-Gg: ASbGncv7idlRLGtg6X1hPheAt+h7iEwXx5JAFxyype7ms5SHmy2bI+lfI5UZhIedVzs
	Sx3Ki7J/IecPI5amrPaC8+0X9oBpuKKP0Cb/osn/QNhgCX1N0GtWX5a8EEdVG9MRWf0UOzSyrqe
	5njeojG/6e1bpFk1eKbkVSF3vKNbRTzvwPicOwo3uLohlYWZizWTL1o9e8jawo8OMUsgy1pErmE
	lBaGgJqvNLjHaoixlIrzgCv3ssbsYaPPISiHWTS13X9syl5OfE0gFJNvKQ7u31uRosTw0F39+jQ
	Oc2juEkT8lOCmQfSYMLnRmW8Kvt3cwhbjd1ydYYCd0tbozPz+6wNYDA0HvqjFxoAhAkC1+eIPFF
	qvX0e9tIAqc/ghYY6q7k0PIIjMkEvHQ==
X-Google-Smtp-Source: AGHT+IE2TIUCu3tWDUhYMKR2RX27xn19+zw/Sg/ImtPMtPrU5FOrGBc29LXE1pvk/a3tWyk20y/Jvw==
X-Received: by 2002:a05:600c:4f46:b0:43b:ca39:6c75 with SMTP id 5b1f17b1804b1-4549ff26757mr11446845e9.16.1751364911092;
        Tue, 01 Jul 2025 03:15:11 -0700 (PDT)
Received: from [192.168.69.166] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453823ad0f3sm194858785e9.19.2025.07.01.03.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 03:15:10 -0700 (PDT)
Message-ID: <34fa39b2-fc0a-4d3b-9a3f-4888d02bdebc@linaro.org>
Date: Tue, 1 Jul 2025 12:15:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/26] target/arm/hvf: Trace hv_vcpu_run() failures
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@csgraf.de>,
 Bernhard Beschow <shentey@gmail.com>, John Snow <jsnow@redhat.com>,
 Thomas Huth <thuth@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
 Cameron Esfahani <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>,
 Radoslaw Biernacki <rad@semihalf.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
 <20250623121845.7214-7-philmd@linaro.org>
 <CAFEAcA9ref1SFd2uPRBBjyg=eph+GptWxoyURxMZj8aSVD7zAg@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAFEAcA9ref1SFd2uPRBBjyg=eph+GptWxoyURxMZj8aSVD7zAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/7/25 11:49, Peter Maydell wrote:
> On Mon, 23 Jun 2025 at 13:19, Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
>>
>> Allow distinguishing HV_ILLEGAL_GUEST_STATE in trace events.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> ---
>>   target/arm/hvf/hvf.c        | 10 +++++++++-
>>   target/arm/hvf/trace-events |  1 +
>>   2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
>> index ef76dcd28de..cc5bbc155d2 100644
>> --- a/target/arm/hvf/hvf.c
>> +++ b/target/arm/hvf/hvf.c
>> @@ -1916,7 +1916,15 @@ int hvf_vcpu_exec(CPUState *cpu)
>>       bql_unlock();
>>       r = hv_vcpu_run(cpu->accel->fd);
>>       bql_lock();
>> -    assert_hvf_ok(r);
>> +    switch (r) {
>> +    case HV_SUCCESS:
>> +        break;
>> +    case HV_ILLEGAL_GUEST_STATE:
>> +        trace_hvf_illegal_guest_state();
>> +        /* fall through */
>> +    default:
>> +        g_assert_not_reached();
> 
> This seems kind of odd.
> 
> If it can happen, we shouldn't g_assert_not_reached().
> If it can't happen, we shouldn't trace it.
> 
> But the hvf code already has a lot of "assert success
> rather than handling possible-but-fatal errors more
> gracefully", so I guess it's OK.

OK, you can drop this patch: I will replace with error("unrecoverable:
...") && exit(1); to avoid such oddity.

