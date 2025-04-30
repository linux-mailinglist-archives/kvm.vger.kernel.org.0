Return-Path: <kvm+bounces-44853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD9CEAA42D9
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 08:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B1C2466E71
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 06:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEF11E47CC;
	Wed, 30 Apr 2025 06:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="baNpSg9/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9BE1E8335
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 06:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993192; cv=none; b=D/ZoyMRCOd3miqekVCQc4eFHsaLyQV1WAT3tJCFa8vkIfTzW1BMN8n5scKzhrGqPStLvskHwDepuK6Ruw+6DyVbCmPQa/Ju7r0VjNNDLoBwE/TWbkrw7TKFiwSQiu1ugvAFvUZfRCwmrynlmeYdc6fn7AH0lQwMXB3faM98OjUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993192; c=relaxed/simple;
	bh=uqdz5RtxVV1MC42vY8nNd3D9zYai4QJ/iD4LBbXlh0Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VrBvLti0Qf8Am2o4dmYPu7lmega2wdVQtWCsKke6GtjcauF/y0vUGYRQ9rq/AsmI45k1HmdR7EzFbKqADboM4k04oacGtMxJL3tvKpvL07D2u76j+HZ5kwcbrYqD39mYMXrvvvFmTIBfQBB3QgWwwEQnZZTEUZ1WlxTcot8r938=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=baNpSg9/; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-39c1efc457bso4982239f8f.2
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 23:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745993189; x=1746597989; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VaK0UyE1mFBNKIjhFBbQsGXEj6TCL5MtPpa0p8PsSEs=;
        b=baNpSg9/kd05AOyFWWw/VB0t9cc2jaIY/ni8uE4tQqtwHzBH1yLkBeb08oE/arwTI4
         ol76RV7gn0TNlmfKDz/gzAH1Ut8Hf0GcNNGb6DgGIUqDjBjmsKFNau+Fn1qJyepdgMQ4
         JcCvRQgyOVB/EMTYIfuADvrTy0U3cTxd/qnLOe5Vb59VsDFhYcA5H+iMk5WkHE4Je55P
         Hm1pEdRb+BDEbEaHSu9BfkA6lyWkUYeHBgkbexl2m3kbxGWB+Oczl1wa4WApj34TJkqd
         LttHBd61rfZhb818Zn5Q519wI21irHFx2mCkUsFFvVHT6Yxtih9N/vdKpKrJ/RXqXaoC
         LEvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745993189; x=1746597989;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VaK0UyE1mFBNKIjhFBbQsGXEj6TCL5MtPpa0p8PsSEs=;
        b=VFbmnDB7Rk5i4KJqQdi0t54IZgRStmwrmODnINV0FrEEkd/XjkcUYbGYUXInOhXWDs
         TNFqpfYafBgV94GxYR/YyhkCBidAPeUi1rD3AmYPZVVDcWKMHqprPDYR2WE8w1xRpZEJ
         E3bwyswko9vatLvoiN4OVLJhCltocijiISlzPYWV1LuYw/Qwp/RDSSQ/2sbWAPM8NI4H
         G6ZNEAp825jCCIl5AxGG2qVxhGJOTSOaRTHaRrcj+AFnSPSlGaOvk5MYRn/+fWAlo7IA
         wjUxDWAZli6kZ9tUSLsxtIFMRVWueu+bt2Hrbcck1kATQFHG3qLfHbXtGn+dknzd+v85
         gTvA==
X-Forwarded-Encrypted: i=1; AJvYcCX2aRfecdM/K5mFOGdvd1qhcLtYlrQRm4KiATuGcuBJKV7PuL99eMOCXN8BKlGQ3ZG4iwc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyQmVdp8ZcQKs9ikwRJ5oRMLYTECuvotonyWL40yJDUG2WOfgV
	PGWHxs4UA5cKZKm6luzib6u4ceUezLIz8yL6zcNHzWgjZ2FjV5gXxxe8hs4CNKc=
X-Gm-Gg: ASbGncuUBhvFWFvQl1KkuVKGDvCnRgXFJz1LB+1X/Q8HX6oPatpPvh9uShfp1+Fl7ix
	j+w0g1PKz389Qe/JdLBE9KKqlRWuwMMuX6MOaN+kX069CQBtZE7teepSrAsYN6dizasJ7rGNKS4
	2s6h69yznVjbGAD8v9khLWuEFCtdQYrMcn2yfxQ7245JBp+SwsTkrLGFhiX2AhZYqoiTH8EvIg+
	SxzGAm6cqBek+w6aHK/s4zTHjur6kh+UCYBe8DZSIsGSyYJNUY1rH94HSAWCchWZlAA3mbsBJNQ
	MVaohCfHbPb8VEi48lXQ9N7kU2VGM6m6BsnLNMyDjXzdxznTqEQmfFAIdmeI0vZgasPPtRhgN4v
	An6lxpQvQ
X-Google-Smtp-Source: AGHT+IFqY2wyvF3cR961CoTKkr0CDZXR/0s85Nwqd83veNOjb0gavDaD/XgV16EoOIwhK0OowJ6D0g==
X-Received: by 2002:a5d:64c7:0:b0:39c:1257:c96e with SMTP id ffacd0b85a97d-3a08ff55599mr664270f8f.58.1745993188968;
        Tue, 29 Apr 2025 23:06:28 -0700 (PDT)
Received: from [192.168.69.226] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e461bfsm16159104f8f.79.2025.04.29.23.06.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 23:06:28 -0700 (PDT)
Message-ID: <f5a5e439-ed3a-49af-a3f2-da8a6f44ae83@linaro.org>
Date: Wed, 30 Apr 2025 08:06:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] meson: add common libs for target and target_system
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, qemu-arm@nongnu.org, anjo@rev.ng,
 richard.henderson@linaro.org
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-4-pierrick.bouvier@linaro.org>
 <fd70e4f4-29b8-4027-a70c-747729172ce5@linaro.org>
 <12579394-7bce-4b9e-ba66-00ce1dff43d1@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <12579394-7bce-4b9e-ba66-00ce1dff43d1@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29/4/25 23:11, Pierrick Bouvier wrote:
> On 4/29/25 11:01 AM, Philippe Mathieu-Daudé wrote:
>> Hi Pierrick,
>>
>> On 29/4/25 07:00, Pierrick Bouvier wrote:
>>> Following what we did for hw/, we need target specific common libraries
>>> for target. We need 2 different libraries:
>>> - code common to a base architecture
>>> - system code common to a base architecture
>>>
>>> For user code, it can stay compiled per target for now.
>>>
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> ---
>>>    meson.build | 78 ++++++++++++++++++++++++++++++++++++++++ 
>>> +------------
>>>    1 file changed, 61 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/meson.build b/meson.build
>>> index 68d36ac140f..7b2cf3cd7d1 100644
>>> --- a/meson.build
>>> +++ b/meson.build
>>> @@ -3684,6 +3684,8 @@ target_arch = {}
>>>    target_system_arch = {}
>>>    target_user_arch = {}
>>>    hw_common_arch = {}
>>> +target_common_arch = {}
>>> +target_common_system_arch = {}
>>>    # NOTE: the trace/ subdirectory needs the qapi_trace_events variable
>>>    # that is filled in by qapi/.
>>> @@ -4087,29 +4089,59 @@ common_all = static_library('common',
>>>    # construct common libraries per base architecture
>>>    hw_common_arch_libs = {}
>>> +target_common_arch_libs = {}
>>> +target_common_system_arch_libs = {}
>>>    foreach target : target_dirs
>>>      config_target = config_target_mak[target]
>>>      target_base_arch = config_target['TARGET_BASE_ARCH']
>>> +  target_inc = [include_directories('target' / target_base_arch)]
>>> +  inc = [common_user_inc + target_inc]
>>> -  # check if already generated
>>> -  if target_base_arch in hw_common_arch_libs
>>> -    continue
>>> -  endif
>>> +  # prevent common code to access cpu compile time definition,
>>> +  # but still allow access to cpu.h
>>> +  target_c_args = ['-DCPU_DEFS_H']
>>> +  target_system_c_args = target_c_args + ['- 
>>> DCOMPILING_SYSTEM_VS_USER', '-DCONFIG_SOFTMMU']
>>>      if target_base_arch in hw_common_arch
>>> -    target_inc = [include_directories('target' / target_base_arch)]
>>> -    src = hw_common_arch[target_base_arch]
>>> -    lib = static_library(
>>> -      'hw_' + target_base_arch,
>>> -      build_by_default: false,
>>> -      sources: src.all_sources() + genh,
>>> -      include_directories: common_user_inc + target_inc,
>>> -      implicit_include_directories: false,
>>> -      # prevent common code to access cpu compile time
>>> -      # definition, but still allow access to cpu.h
>>> -      c_args: ['-DCPU_DEFS_H', '-DCOMPILING_SYSTEM_VS_USER', '- 
>>> DCONFIG_SOFTMMU'],
>>> -      dependencies: src.all_dependencies())
>>> -    hw_common_arch_libs += {target_base_arch: lib}
>>> +    if target_base_arch not in hw_common_arch_libs
>>> +      src = hw_common_arch[target_base_arch]
>>> +      lib = static_library(
>>> +        'hw_' + target_base_arch,
>>> +        build_by_default: false,
>>> +        sources: src.all_sources() + genh,
>>> +        include_directories: inc,
>>> +        c_args: target_system_c_args,
>>> +        dependencies: src.all_dependencies())
>>> +      hw_common_arch_libs += {target_base_arch: lib}
>>> +    endif
>>> +  endif
>>> +
>>> +  if target_base_arch in target_common_arch
>>> +    if target_base_arch not in target_common_arch_libs
>>> +      src = target_common_arch[target_base_arch]
>>> +      lib = static_library(
>>> +        'target_' + target_base_arch,
>>> +        build_by_default: false,
>>> +        sources: src.all_sources() + genh,
>>> +        include_directories: inc,
>>> +        c_args: target_c_args,
>>> +        dependencies: src.all_dependencies())
>>> +      target_common_arch_libs += {target_base_arch: lib}
>>> +    endif
>>> +  endif
>>> +
>>> +  if target_base_arch in target_common_system_arch
>>> +    if target_base_arch not in target_common_system_arch_libs
>>> +      src = target_common_system_arch[target_base_arch]
>>> +      lib = static_library(
>>> +        'target_system_' + target_base_arch,
>>> +        build_by_default: false,
>>> +        sources: src.all_sources() + genh,
>>> +        include_directories: inc,
>>> +        c_args: target_system_c_args,
>>> +        dependencies: src.all_dependencies())
>>> +      target_common_system_arch_libs += {target_base_arch: lib}
>>> +    endif
>>>      endif
>>>    endforeach
>>> @@ -4282,12 +4314,24 @@ foreach target : target_dirs
>>>      target_common = common_ss.apply(config_target, strict: false)
>>>      objects = [common_all.extract_objects(target_common.sources())]
>>>      arch_deps += target_common.dependencies()
>>> +  if target_base_arch in target_common_arch_libs
>>> +    src = target_common_arch[target_base_arch].apply(config_target, 
>>> strict: false)
>>> +    lib = target_common_arch_libs[target_base_arch]
>>> +    objects += lib.extract_objects(src.sources())
>>> +    arch_deps += src.dependencies()
>>> +  endif
>>>      if target_type == 'system' and target_base_arch in 
>>> hw_common_arch_libs
>>>        src = hw_common_arch[target_base_arch].apply(config_target, 
>>> strict: false)
>>>        lib = hw_common_arch_libs[target_base_arch]
>>>        objects += lib.extract_objects(src.sources())
>>>        arch_deps += src.dependencies()
>>>      endif
>>> +  if target_type == 'system' and target_base_arch in 
>>> target_common_system_arch_libs
>>> +    src = 
>>> target_common_system_arch[target_base_arch].apply(config_target, 
>>> strict: false)
>>> +    lib = target_common_system_arch_libs[target_base_arch]
>>> +    objects += lib.extract_objects(src.sources())
>>> +    arch_deps += src.dependencies()
>>> +  endif
>>>      target_specific = specific_ss.apply(config_target, strict: false)
>>>      arch_srcs += target_specific.sources()
>>
>> Somehow related to this patch, when converting from target_system_arch

"Somehow related to" ~-> "pre-existing issue exposed by"

>> to target_common_system_arch, emptying it, I get:
>>
>> ../../meson.build:4237:27: ERROR: Key microblaze is not in the 
>> dictionary.
>>
>> 4235   if target.endswith('-softmmu')
>> 4236     target_type='system'
>> 4237     t = target_system_arch[target_base_arch].apply(config_target,
>> strict: false)
>>
> 
> Patch 12 introduces an empty arm_common_ss and it does not seem to be a 
> problem.
> Feel free to share your meson.build if there is a problem.

Empty arm_common_ss[] isn't a problem. What I'm saying is
when I move all files from target_system_arch[ARCH] to 
target_common_system_arch[ARCH] I get an error because
target_system_arch[ARCH] isn't expected to be empty.
I suppose due to:

   target_system_arch[target_base_arch].apply()

Yes, I can keep/add an empty source set but it makes meson
files review more cumbersome (unused source set, but if you
remove it then the build fails).

