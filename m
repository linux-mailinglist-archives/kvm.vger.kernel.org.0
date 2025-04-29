Return-Path: <kvm+bounces-44826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76CBBAA1CB1
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 23:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57E2D7B1337
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 21:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1191026B2B1;
	Tue, 29 Apr 2025 21:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZvjmhMFM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8584F269832
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 21:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745961111; cv=none; b=rBYBn2HZMI7pGJm+sdDQMBTjTUGE87Zl6yqnzJ2Iy2/O39yBd6Mfu39MAWh4G3NwbjkSOkzSX3kV5er2oydmZujjo7HnKUD6iP39gabOGqPZ056T3+zkDKqd2J80+SNrYSgoHOclIpWWO0hdKO8F/d5xvWuJrAXxlPV7HjUjrzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745961111; c=relaxed/simple;
	bh=X2Rt3ExWKalLY5ssp0Dms0prJVCsvkxS5PRJTSPxLMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Esb/sSALQoEe/o1W2tBIWbpRehk3UitzblYbooUqC9sjkm//3hcf6P0j5UPtvjww+aBHDC+fodciDqJoXMaHZ2fIJkgXfbPTLhAZtdnGXiROCX1FC95wD2lTLUcCY1aSY0+AnxBN0j2e/u+xbDhw5QbKZjpbGMsBHLI7o9fpj1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZvjmhMFM; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22c33ac23edso60703455ad.0
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 14:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745961109; x=1746565909; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+vBxbVVL0iKGPcc8hbFY6P4N8NFA8CDBAgRz2WbbHH0=;
        b=ZvjmhMFMbuwe8fTo1xI1tX0xH7Hp6NnovzNZf5BklrywWk+da4nt1MmkaKtfosiC0l
         lyBlBNipveNAGUWOr+c6C9XJkW6uF7ZBKhMLV2TZ1m0Xz/aDkk8gHKVIPLHeYxgg8aOA
         zz3+7kh/qICnlwJc/T5nvXe+SypN7noyWPRly/unagS6M2Q8eSAjAuzkZLtTJEQe12d3
         HyJFo7QhvyNSk4MoIMANMDPDBlcumptnMlnMHyd7I0N/yRhzWSwCUNAg4VEuw1VIElkE
         nmOX0I5zhW5O4Jke21/hUys3iZ86k83lbufJRwhfLgpJm4zHXCtQjLdTwTyhRLwzOr5k
         3ZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745961109; x=1746565909;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+vBxbVVL0iKGPcc8hbFY6P4N8NFA8CDBAgRz2WbbHH0=;
        b=BiWDbr2ur/8708E4LueRvnD3fHqS0royyn7LykOtQdbdwrHyp+wBtHfBnyEYo2SIh0
         jFTYhj4xlR7UaLvjKWA49MyPbjCCEfBDngVvhWnH155nKv2OJCxqffaoRbAGFxCEHt3E
         VvaB4zs5IPmXJUe2ebR+bHshng3uVvwkhe+F6xwAG1vmOXvCvHxbvSy8uZpxAHlo3z1l
         JYtBjJ8vQ+fFtfE2wD4/6J0bZECHvB948z5LIIoP9/mFgW0/E2lkVmEg/rWeF0dGV3en
         DOAKtZnt8zUmiTYoeSyoBQLBscFoC5lPejb0p2yvKRGBTSNEUagspUNEF5jzGntcZGAK
         xGcg==
X-Forwarded-Encrypted: i=1; AJvYcCVZinYW7onE4kS7Hv+suXWsyeYFdf9kXg506nLK+w58jN0lhZeUr9SKWtG5qNxE92f3IKg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFz97sr2LKKxeHtWMAK8lIHMDQ6a6ByXilHhxcVGjvmeU52I6R
	0ZC3kGzeABihsvHbs0wnaAYLwDeAK93yXA8Zr6/1bdoPw3aCoDygzGf3JGkDAkY=
X-Gm-Gg: ASbGncuwzYTdAWIH3hcuKeZKKc8AJx6JCjWowQ3T9GfHlW9abka0NLslCTlCFQsV+UV
	vhEtJfuA95J244uzFpRlAb8+UvxlQfp8+He5cL9i5s8TaWt1MNzPE4fOHWjg8t3rSvKhmTSewFu
	/bjFo4Y/TZ2J+FY9Mp76QDNazC1CbT9Oh6dZC2En4I4z+Sl0c5AQkgL1zg4dnvpfakJ0KSxWETH
	mJHm41iqWvgdV2CGH0AtDJeLcDEOEWmh6yCS8NXMthz3kLt8L5nS5xp+bxB3xtvNBW7SGCDj76a
	HniJ/irowkYbp80VnPPph++qESvo2PkpGd7Ht/g7TMwyPR4umgTlmA==
X-Google-Smtp-Source: AGHT+IEFmAHBbO2wKdGpPUmlZ7vzYIs7H2Tc0jXj+u7tbNw7KX5eQru8f502ZH9woOgYHKduUx5NSg==
X-Received: by 2002:a17:903:8cd:b0:223:6657:5003 with SMTP id d9443c01a7336-22df35700b2mr14256935ad.32.1745961108795;
        Tue, 29 Apr 2025 14:11:48 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5102d31sm107976365ad.198.2025.04.29.14.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 14:11:48 -0700 (PDT)
Message-ID: <12579394-7bce-4b9e-ba66-00ce1dff43d1@linaro.org>
Date: Tue, 29 Apr 2025 14:11:47 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] meson: add common libs for target and target_system
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-arm@nongnu.org, anjo@rev.ng, richard.henderson@linaro.org
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-4-pierrick.bouvier@linaro.org>
 <fd70e4f4-29b8-4027-a70c-747729172ce5@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <fd70e4f4-29b8-4027-a70c-747729172ce5@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/29/25 11:01 AM, Philippe Mathieu-Daudé wrote:
> Hi Pierrick,
> 
> On 29/4/25 07:00, Pierrick Bouvier wrote:
>> Following what we did for hw/, we need target specific common libraries
>> for target. We need 2 different libraries:
>> - code common to a base architecture
>> - system code common to a base architecture
>>
>> For user code, it can stay compiled per target for now.
>>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    meson.build | 78 +++++++++++++++++++++++++++++++++++++++++------------
>>    1 file changed, 61 insertions(+), 17 deletions(-)
>>
>> diff --git a/meson.build b/meson.build
>> index 68d36ac140f..7b2cf3cd7d1 100644
>> --- a/meson.build
>> +++ b/meson.build
>> @@ -3684,6 +3684,8 @@ target_arch = {}
>>    target_system_arch = {}
>>    target_user_arch = {}
>>    hw_common_arch = {}
>> +target_common_arch = {}
>> +target_common_system_arch = {}
>>    
>>    # NOTE: the trace/ subdirectory needs the qapi_trace_events variable
>>    # that is filled in by qapi/.
>> @@ -4087,29 +4089,59 @@ common_all = static_library('common',
>>    
>>    # construct common libraries per base architecture
>>    hw_common_arch_libs = {}
>> +target_common_arch_libs = {}
>> +target_common_system_arch_libs = {}
>>    foreach target : target_dirs
>>      config_target = config_target_mak[target]
>>      target_base_arch = config_target['TARGET_BASE_ARCH']
>> +  target_inc = [include_directories('target' / target_base_arch)]
>> +  inc = [common_user_inc + target_inc]
>>    
>> -  # check if already generated
>> -  if target_base_arch in hw_common_arch_libs
>> -    continue
>> -  endif
>> +  # prevent common code to access cpu compile time definition,
>> +  # but still allow access to cpu.h
>> +  target_c_args = ['-DCPU_DEFS_H']
>> +  target_system_c_args = target_c_args + ['-DCOMPILING_SYSTEM_VS_USER', '-DCONFIG_SOFTMMU']
>>    
>>      if target_base_arch in hw_common_arch
>> -    target_inc = [include_directories('target' / target_base_arch)]
>> -    src = hw_common_arch[target_base_arch]
>> -    lib = static_library(
>> -      'hw_' + target_base_arch,
>> -      build_by_default: false,
>> -      sources: src.all_sources() + genh,
>> -      include_directories: common_user_inc + target_inc,
>> -      implicit_include_directories: false,
>> -      # prevent common code to access cpu compile time
>> -      # definition, but still allow access to cpu.h
>> -      c_args: ['-DCPU_DEFS_H', '-DCOMPILING_SYSTEM_VS_USER', '-DCONFIG_SOFTMMU'],
>> -      dependencies: src.all_dependencies())
>> -    hw_common_arch_libs += {target_base_arch: lib}
>> +    if target_base_arch not in hw_common_arch_libs
>> +      src = hw_common_arch[target_base_arch]
>> +      lib = static_library(
>> +        'hw_' + target_base_arch,
>> +        build_by_default: false,
>> +        sources: src.all_sources() + genh,
>> +        include_directories: inc,
>> +        c_args: target_system_c_args,
>> +        dependencies: src.all_dependencies())
>> +      hw_common_arch_libs += {target_base_arch: lib}
>> +    endif
>> +  endif
>> +
>> +  if target_base_arch in target_common_arch
>> +    if target_base_arch not in target_common_arch_libs
>> +      src = target_common_arch[target_base_arch]
>> +      lib = static_library(
>> +        'target_' + target_base_arch,
>> +        build_by_default: false,
>> +        sources: src.all_sources() + genh,
>> +        include_directories: inc,
>> +        c_args: target_c_args,
>> +        dependencies: src.all_dependencies())
>> +      target_common_arch_libs += {target_base_arch: lib}
>> +    endif
>> +  endif
>> +
>> +  if target_base_arch in target_common_system_arch
>> +    if target_base_arch not in target_common_system_arch_libs
>> +      src = target_common_system_arch[target_base_arch]
>> +      lib = static_library(
>> +        'target_system_' + target_base_arch,
>> +        build_by_default: false,
>> +        sources: src.all_sources() + genh,
>> +        include_directories: inc,
>> +        c_args: target_system_c_args,
>> +        dependencies: src.all_dependencies())
>> +      target_common_system_arch_libs += {target_base_arch: lib}
>> +    endif
>>      endif
>>    endforeach
>>    
>> @@ -4282,12 +4314,24 @@ foreach target : target_dirs
>>      target_common = common_ss.apply(config_target, strict: false)
>>      objects = [common_all.extract_objects(target_common.sources())]
>>      arch_deps += target_common.dependencies()
>> +  if target_base_arch in target_common_arch_libs
>> +    src = target_common_arch[target_base_arch].apply(config_target, strict: false)
>> +    lib = target_common_arch_libs[target_base_arch]
>> +    objects += lib.extract_objects(src.sources())
>> +    arch_deps += src.dependencies()
>> +  endif
>>      if target_type == 'system' and target_base_arch in hw_common_arch_libs
>>        src = hw_common_arch[target_base_arch].apply(config_target, strict: false)
>>        lib = hw_common_arch_libs[target_base_arch]
>>        objects += lib.extract_objects(src.sources())
>>        arch_deps += src.dependencies()
>>      endif
>> +  if target_type == 'system' and target_base_arch in target_common_system_arch_libs
>> +    src = target_common_system_arch[target_base_arch].apply(config_target, strict: false)
>> +    lib = target_common_system_arch_libs[target_base_arch]
>> +    objects += lib.extract_objects(src.sources())
>> +    arch_deps += src.dependencies()
>> +  endif
>>    
>>      target_specific = specific_ss.apply(config_target, strict: false)
>>      arch_srcs += target_specific.sources()
> 
> Somehow related to this patch, when converting from target_system_arch
> to target_common_system_arch, emptying it, I get:
> 
> ../../meson.build:4237:27: ERROR: Key microblaze is not in the dictionary.
> 
> 4235   if target.endswith('-softmmu')
> 4236     target_type='system'
> 4237     t = target_system_arch[target_base_arch].apply(config_target,
> strict: false)
>

Patch 12 introduces an empty arm_common_ss and it does not seem to be a 
problem.
Feel free to share your meson.build if there is a problem.

