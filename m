Return-Path: <kvm+bounces-41868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E233A6E5A4
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A11016DB76
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA2A1DF99D;
	Mon, 24 Mar 2025 21:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tUNa+dzS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C581A254E
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742851266; cv=none; b=uFQLIkEtirCH1nrGWxYRnSkiEFO2UuZ3KirKcFPYW6XzuXLc9rKWq2/N2nwASSMjAjn47vfutAle6iDX/g6qMgaPvAjTwuuuW7+PysdTj1M4qc/NmWk0VFjzVbTmCtWEz6xQqzWOQKSGrxY2O8FTH1OIhZ+fQZFGtcxBGfP3Huw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742851266; c=relaxed/simple;
	bh=QFqX+GSHwEz2P0f8fm96ij7NUOpR+a4N2z6WqCQx210=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NVwFLvpLSywOEUDHkj22cRzUVfdQhC4KSZ/hEHZYCfcH3iPNQ7GXid55PVOBkVlSKgdpxCxgawlVCHIlcvpH/Wt03188VUQQAkVaDBX3gONgDOUQar1B6/e8mthW0s3Lzu1WquLukJA9hPwlbJI4Syp9xxYb3uILzD73Q331G8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tUNa+dzS; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2254e0b4b79so83711565ad.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 14:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742851264; x=1743456064; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8KoheoYm5HA8VcAgE260OGydvMzV1ButV3Mzz5BT064=;
        b=tUNa+dzS8+4Z19cM8fmmfCRFH5ZYzXCogJkb3R/xsD6t07unomF4whkPntB5U7irzF
         VcR/jtodD+69HVvgKn0zAjN05AQ3s0Jck7XW228yJx/MJD5l9KbZDT71SP9sL62nfgIL
         efH0cnj1SQid/GmoEias8R2hgW0MuKOKen/BP2gmHZ1Gfeb2Ucui7S2t3Uh4gNHxc8sn
         aGaamv3saB4wD9XuLhicBfH+H/HdDxYXHDif/mSa02VrgdhWdc6jNKBhiUMoP3oEjIii
         QMHjsMNylTLgKpLY8RPsli0vbRjCw2wppVmp0Befc6ubAgQUyJB9VIpHXsPGumRGl4NP
         Kftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742851264; x=1743456064;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8KoheoYm5HA8VcAgE260OGydvMzV1ButV3Mzz5BT064=;
        b=aDQF0I9Fx2yoO1quqbQX/IMGqpNjJeITO8bAIwyeFD5ui2WXPLq45O/0IQNQJk7Iuz
         Im/K5fSidFiLi/IjR3y4MaHh40IDKFQh07nbyVqtjAONKMdtbFvW7QVm4QV78OiGHme8
         TuLRYEWNPWSqXJm/g6rfhzlhhBRWa1wrMFwdDwj3KB/TfmKZAnjwpT1APdtW1VMrvcbI
         FhR3klGMU27phagy6G6MupcUwxOvklWOBUQMUmTjjXh61txwlCZLHP3x3O7hr1UtnOV5
         eN5M1p7V+wbm1D64CzgttaBw2hJRwnlLPvC0UwuFDvSUn2hPobh8zq0oWrKUomoSz2Nf
         b6iQ==
X-Gm-Message-State: AOJu0YxqGnRqzrn7ea/Gu7xrRJjYVfoGXqVB8Wc1MIFUVn3LXcSGXgq5
	UA+iyjOx/PpS8xJ4Uc0vikwB7G9xLFOUj7eQZcW3ZgzpF4yWOl5HvswoTbvONr8=
X-Gm-Gg: ASbGncv8lzgI3YYH4+khfmg8mnv5nLTjqFOpr94blWJiPFXsuGUh0M4Qbkh6p+6tOFe
	GCegTNoPVqUe0KJ44YQb3DoajvhvLcy6Z5MZ4mrOcfpvP5LLlitucHAmyuwEjgZ2giQOPpW3mII
	DWulX176G3d04hYutQuQTw5f6uPCrQCb9ZZj2g7HFHwzUdcYIj6/SK94ktHuzVX3WXAHPbhyga2
	/Ow2D396P9r2W1HQ0DBsmPc+O8HY0Ts47FeHvfPpaY/k7/N2CQdJut8onslmL1wJJp+OGwq5Rjn
	n9RUhuVX0rFSRrNPeAo9nDQz1k5q/pJNMpLSXDbsyfuEG9XqNNoRKLItfQ==
X-Google-Smtp-Source: AGHT+IEf4rgByTR4aUAXXQim/ntEXH4+OOahy31CtY4lDoOHPzpvMBWbyGzjrmwJx01AD+FrvarBrQ==
X-Received: by 2002:a17:902:f648:b0:224:fa0:36da with SMTP id d9443c01a7336-22780c7c06fmr193333595ad.18.1742851263523;
        Mon, 24 Mar 2025 14:21:03 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611d3c0sm8504961b3a.89.2025.03.24.14.21.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 14:21:03 -0700 (PDT)
Message-ID: <231d6e5a-f8c8-4b16-a455-44e9bb8dd011@linaro.org>
Date: Mon, 24 Mar 2025 14:21:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 24/30] meson: add common hw files
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-25-pierrick.bouvier@linaro.org>
 <2650a767-a829-4544-99f9-42e23b131da3@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <2650a767-a829-4544-99f9-42e23b131da3@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/25 12:58, Richard Henderson wrote:
> On 3/20/25 15:29, Pierrick Bouvier wrote:
>> Those files will be compiled once per base architecture ("arm" in this
>> case), instead of being compiled for every variant/bitness of
>> architecture.
>>
>> We make sure to not include target cpu definitions (exec/cpu-defs.h) by
>> defining header guard directly. This way, a given compilation unit can
>> access a specific cpu definition, but not access to compile time defines
>> associated.
>>
>> Previous commits took care to clean up some headers to not rely on
>> cpu-defs.h content.
>>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    meson.build | 37 ++++++++++++++++++++++++++++++++++++-
>>    1 file changed, 36 insertions(+), 1 deletion(-)
>>
>> diff --git a/meson.build b/meson.build
>> index c21974020dd..994d3e5d536 100644
>> --- a/meson.build
>> +++ b/meson.build
>> @@ -3691,6 +3691,7 @@ hw_arch = {}
>>    target_arch = {}
>>    target_system_arch = {}
>>    target_user_arch = {}
>> +hw_common_arch = {}
>>    
>>    # NOTE: the trace/ subdirectory needs the qapi_trace_events variable
>>    # that is filled in by qapi/.
>> @@ -4089,6 +4090,34 @@ common_all = static_library('common',
>>                                implicit_include_directories: false,
>>                                dependencies: common_ss.all_dependencies())
>>    
>> +# construct common libraries per base architecture
>> +hw_common_arch_libs = {}
>> +foreach target : target_dirs
>> +  config_target = config_target_mak[target]
>> +  target_base_arch = config_target['TARGET_BASE_ARCH']
>> +
>> +  # check if already generated
>> +  if target_base_arch in hw_common_arch_libs
>> +    continue
>> +  endif
>> +
>> +  if target_base_arch in hw_common_arch
>> +    target_inc = [include_directories('target' / target_base_arch)]
>> +    src = hw_common_arch[target_base_arch]
>> +    lib = static_library(
>> +      'hw_' + target_base_arch,
>> +      build_by_default: false,
>> +      sources: src.all_sources() + genh,
>> +      include_directories: common_user_inc + target_inc,
>> +      implicit_include_directories: false,
>> +      # prevent common code to access cpu compile time
>> +      # definition, but still allow access to cpu.h
>> +      c_args: ['-DCPU_DEFS_H', '-DCOMPILING_SYSTEM_VS_USER', '-DCONFIG_SOFTMMU'],
> 
> Oof.  This really seems like a hack, but it does work,
> and I'm not sure what else to suggest.
> 

Yes, it's the best (least-worst in reality) solution I found.

Initially I simply tried to add them to libsystem.
However, it has some problems:
- Impossible to link arch files only for concerned targets (or you need 
to add when: [TARGET_X] everywhere, which is not convenient).
- They need specific flags (most notably header guard -DCPU_DEFS_H, to 
ensure we don't rely on cpu compile time defines), which is only 
achievable through static lib hack already used in our build system. So 
another library needs to be declared.

> All the rest of the meson-foo looks ok, but a second eye couldn't hurt.
> 

If someone else has a better idea achieving the same result (maybe 
Paolo?), I would be happy to implement it.

> Acked-by: Richard Henderson <richard.henderson@linaro.org>
> 
> 
> r~


