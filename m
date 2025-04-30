Return-Path: <kvm+bounces-44855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D87EAAA42F1
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 08:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B1221BC3501
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 06:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0511E51FF;
	Wed, 30 Apr 2025 06:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NbmjTIwN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AFA2DC77C
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 06:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993582; cv=none; b=uKA2VHVIZawjHkR0zRa9jlSEwtuR+nUXBp0JtGac3aCwp98mGkqIXvmIc4kxWiVJhlykK5kUz/AIWcxWwCi9tNJ4lW6lprhSgHpgZMo3puUcyOLZOa59/Zo4kzA/vs4TS7gkqy7RMMtMazKh/ExscoznsrVmxm/neQCWg+YKrxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993582; c=relaxed/simple;
	bh=xi9dou9JyDCESg3GukiI/GGP6+PkC02XWY8xsvmkDqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i75nGjCef9nV4psVF02t58VYfF6rUdNLWspJuZ4BEUtLIex6PN8Kkboev4Rc9wSSqhDznIdLFTXbDFyGn0fK0tDlWZ+NKWiqEGKbzSe4i4oaC6jXsopXinbUaY6gMc9sY1A4xvNbBMUjZ4/pzwQbUvH/JVYTFwYn9GD20PCxhuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NbmjTIwN; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2241053582dso103597885ad.1
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 23:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745993580; x=1746598380; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qOz704mUFzAP7PczY6/TxPRr5rC31uzEdcNBaAx4x6U=;
        b=NbmjTIwNJIggsCXuhdDdoJi5CskcRTOH4v310fPXfZ2XK5QQ7998lsFwQX759pD/8Z
         vRVq00H1E/GEdFzcVQfoXBbHfHFKc+xDJGwvX5mPXjv3cW+iWfd8GLBPsOJ9MN03PYn6
         CVkEcPibB2YtTujcIdMcVLm9rSwiccIJn/fjpDaYu3ivmHViKSjGebhXGwFpj0QQc8mw
         QhnJOD0kRZJptA8Bq7imZqvkUhbgnkRnrPgrzj8uHZtwrMVvvjZdyDyB8FufVvg2Og7X
         svOJ2nfncwb/EixlAAuu0UGACksn5u3W3oMPeptZmm8hNFr4GPeJkFLMWfVXyhwfOt+k
         RoVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745993580; x=1746598380;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qOz704mUFzAP7PczY6/TxPRr5rC31uzEdcNBaAx4x6U=;
        b=R4uXX3O4jclyKh4zgUZUb864atHGoNXy6jRe39gdwHarzhG+CqabTu0sNs0fOZzmpd
         hJNXQ4mgCtM856CdaIDaebYBF2HTxHKjNVjEOrrAmETXDUuTCeOGV16auQPn9wKnZj+H
         yaW+MVZI0LeyDHzDXUPthdyxCygwkgPOzp3LAn2LzCkcNZExOwfXqjLqMIq2tzCCrg5Q
         Ta1zHPW1z5Hs+gkMztTRGsQnlZoNB+ckIxFVy/6YV9xSFDIVIOOHmExF8wfzeJ+5Q3do
         cbM1FHpBUR6QD383SXfjVHcQv980iOEh6u10kTsb8Woibmd6I7wL+8V4eanxkgMsZef3
         UfZw==
X-Forwarded-Encrypted: i=1; AJvYcCVD7XRH746YwcWJWzoMcUzShVmV2rPbUOkUhPoBoDOyzWyGSAp4bN/LBMycDiw6sLwtwV0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye1lT/9+KqXKUjivpH4E0ltKUlvILaXiCfv8kJIkA8xH2eUinR
	6bhMudz9MA7sgpPD5d7wFv9OD6/BEd9G57oMmgpymVMXIEj0CZ37HVt42Fr04pg=
X-Gm-Gg: ASbGncvuEWeXjWpCVZ+SSOKSkkP89f6TLy3iFejlxKD8+VTZFBHNrrtG+Gvd0vL/QWr
	Qbx5ua25MKxWNZV0rfLQVi0gKAd5YxwpkqLXce8qEAWqqcPaLeVbCCCH9aowDW+1eIPE9Uoqe++
	DHhS9b3GUTKJHjNA6pWFNxdAtHSwFftJKTaL59sevb0Rig78wAC1MTQHzcI5tXVY5wCafhnZ1aW
	r4d1mVTiZkkZFVETTP8wsoT5vRpm5ba9yw1akqHfeFD4cHPIH4tMwPlKmhOaqAuthby0M8Gfs2X
	exJKkhIk1T95UZVysrWTfwfg1KtHIj45X1K3c817jVsCt5gu1nmxXQ==
X-Google-Smtp-Source: AGHT+IGDqECtzVQiyvob42K+wWVkyDgAiBwFIiXNIl3yGzVgEww+Lj75qqTlHArlcv9m3haBR7C2Bw==
X-Received: by 2002:a17:903:22ca:b0:223:f9a4:3fb6 with SMTP id d9443c01a7336-22df5764863mr19101975ad.11.1745993579899;
        Tue, 29 Apr 2025 23:12:59 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5216bb0sm114355105ad.235.2025.04.29.23.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 23:12:59 -0700 (PDT)
Message-ID: <71d2f4ba-6bbb-42de-b460-bea1ef979b68@linaro.org>
Date: Tue, 29 Apr 2025 23:12:58 -0700
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
 qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, qemu-arm@nongnu.org, anjo@rev.ng,
 richard.henderson@linaro.org
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-4-pierrick.bouvier@linaro.org>
 <fd70e4f4-29b8-4027-a70c-747729172ce5@linaro.org>
 <12579394-7bce-4b9e-ba66-00ce1dff43d1@linaro.org>
 <f5a5e439-ed3a-49af-a3f2-da8a6f44ae83@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <f5a5e439-ed3a-49af-a3f2-da8a6f44ae83@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/29/25 11:06 PM, Philippe Mathieu-Daudé wrote:
> On 29/4/25 23:11, Pierrick Bouvier wrote:
>> On 4/29/25 11:01 AM, Philippe Mathieu-Daudé wrote:
>>> Hi Pierrick,
>>>
>>> On 29/4/25 07:00, Pierrick Bouvier wrote:
>>>> Following what we did for hw/, we need target specific common libraries
>>>> for target. We need 2 different libraries:
>>>> - code common to a base architecture
>>>> - system code common to a base architecture
>>>>
>>>> For user code, it can stay compiled per target for now.
>>>>
>>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>> ---
>>>>     meson.build | 78 ++++++++++++++++++++++++++++++++++++++++
>>>> +------------
>>>>     1 file changed, 61 insertions(+), 17 deletions(-)
>>>>
>>>> diff --git a/meson.build b/meson.build
>>>> index 68d36ac140f..7b2cf3cd7d1 100644
>>>> --- a/meson.build
>>>> +++ b/meson.build
>>>> @@ -3684,6 +3684,8 @@ target_arch = {}
>>>>     target_system_arch = {}
>>>>     target_user_arch = {}
>>>>     hw_common_arch = {}
>>>> +target_common_arch = {}
>>>> +target_common_system_arch = {}
>>>>     # NOTE: the trace/ subdirectory needs the qapi_trace_events variable
>>>>     # that is filled in by qapi/.
>>>> @@ -4087,29 +4089,59 @@ common_all = static_library('common',
>>>>     # construct common libraries per base architecture
>>>>     hw_common_arch_libs = {}
>>>> +target_common_arch_libs = {}
>>>> +target_common_system_arch_libs = {}
>>>>     foreach target : target_dirs
>>>>       config_target = config_target_mak[target]
>>>>       target_base_arch = config_target['TARGET_BASE_ARCH']
>>>> +  target_inc = [include_directories('target' / target_base_arch)]
>>>> +  inc = [common_user_inc + target_inc]
>>>> -  # check if already generated
>>>> -  if target_base_arch in hw_common_arch_libs
>>>> -    continue
>>>> -  endif
>>>> +  # prevent common code to access cpu compile time definition,
>>>> +  # but still allow access to cpu.h
>>>> +  target_c_args = ['-DCPU_DEFS_H']
>>>> +  target_system_c_args = target_c_args + ['-
>>>> DCOMPILING_SYSTEM_VS_USER', '-DCONFIG_SOFTMMU']
>>>>       if target_base_arch in hw_common_arch
>>>> -    target_inc = [include_directories('target' / target_base_arch)]
>>>> -    src = hw_common_arch[target_base_arch]
>>>> -    lib = static_library(
>>>> -      'hw_' + target_base_arch,
>>>> -      build_by_default: false,
>>>> -      sources: src.all_sources() + genh,
>>>> -      include_directories: common_user_inc + target_inc,
>>>> -      implicit_include_directories: false,
>>>> -      # prevent common code to access cpu compile time
>>>> -      # definition, but still allow access to cpu.h
>>>> -      c_args: ['-DCPU_DEFS_H', '-DCOMPILING_SYSTEM_VS_USER', '-
>>>> DCONFIG_SOFTMMU'],
>>>> -      dependencies: src.all_dependencies())
>>>> -    hw_common_arch_libs += {target_base_arch: lib}
>>>> +    if target_base_arch not in hw_common_arch_libs
>>>> +      src = hw_common_arch[target_base_arch]
>>>> +      lib = static_library(
>>>> +        'hw_' + target_base_arch,
>>>> +        build_by_default: false,
>>>> +        sources: src.all_sources() + genh,
>>>> +        include_directories: inc,
>>>> +        c_args: target_system_c_args,
>>>> +        dependencies: src.all_dependencies())
>>>> +      hw_common_arch_libs += {target_base_arch: lib}
>>>> +    endif
>>>> +  endif
>>>> +
>>>> +  if target_base_arch in target_common_arch
>>>> +    if target_base_arch not in target_common_arch_libs
>>>> +      src = target_common_arch[target_base_arch]
>>>> +      lib = static_library(
>>>> +        'target_' + target_base_arch,
>>>> +        build_by_default: false,
>>>> +        sources: src.all_sources() + genh,
>>>> +        include_directories: inc,
>>>> +        c_args: target_c_args,
>>>> +        dependencies: src.all_dependencies())
>>>> +      target_common_arch_libs += {target_base_arch: lib}
>>>> +    endif
>>>> +  endif
>>>> +
>>>> +  if target_base_arch in target_common_system_arch
>>>> +    if target_base_arch not in target_common_system_arch_libs
>>>> +      src = target_common_system_arch[target_base_arch]
>>>> +      lib = static_library(
>>>> +        'target_system_' + target_base_arch,
>>>> +        build_by_default: false,
>>>> +        sources: src.all_sources() + genh,
>>>> +        include_directories: inc,
>>>> +        c_args: target_system_c_args,
>>>> +        dependencies: src.all_dependencies())
>>>> +      target_common_system_arch_libs += {target_base_arch: lib}
>>>> +    endif
>>>>       endif
>>>>     endforeach
>>>> @@ -4282,12 +4314,24 @@ foreach target : target_dirs
>>>>       target_common = common_ss.apply(config_target, strict: false)
>>>>       objects = [common_all.extract_objects(target_common.sources())]
>>>>       arch_deps += target_common.dependencies()
>>>> +  if target_base_arch in target_common_arch_libs
>>>> +    src = target_common_arch[target_base_arch].apply(config_target,
>>>> strict: false)
>>>> +    lib = target_common_arch_libs[target_base_arch]
>>>> +    objects += lib.extract_objects(src.sources())
>>>> +    arch_deps += src.dependencies()
>>>> +  endif
>>>>       if target_type == 'system' and target_base_arch in
>>>> hw_common_arch_libs
>>>>         src = hw_common_arch[target_base_arch].apply(config_target,
>>>> strict: false)
>>>>         lib = hw_common_arch_libs[target_base_arch]
>>>>         objects += lib.extract_objects(src.sources())
>>>>         arch_deps += src.dependencies()
>>>>       endif
>>>> +  if target_type == 'system' and target_base_arch in
>>>> target_common_system_arch_libs
>>>> +    src =
>>>> target_common_system_arch[target_base_arch].apply(config_target,
>>>> strict: false)
>>>> +    lib = target_common_system_arch_libs[target_base_arch]
>>>> +    objects += lib.extract_objects(src.sources())
>>>> +    arch_deps += src.dependencies()
>>>> +  endif
>>>>       target_specific = specific_ss.apply(config_target, strict: false)
>>>>       arch_srcs += target_specific.sources()
>>>
>>> Somehow related to this patch, when converting from target_system_arch
> 
> "Somehow related to" ~-> "pre-existing issue exposed by"
> 
>>> to target_common_system_arch, emptying it, I get:
>>>
>>> ../../meson.build:4237:27: ERROR: Key microblaze is not in the
>>> dictionary.
>>>
>>> 4235   if target.endswith('-softmmu')
>>> 4236     target_type='system'
>>> 4237     t = target_system_arch[target_base_arch].apply(config_target,
>>> strict: false)
>>>
>>
>> Patch 12 introduces an empty arm_common_ss and it does not seem to be a
>> problem.
>> Feel free to share your meson.build if there is a problem.
> 
> Empty arm_common_ss[] isn't a problem. What I'm saying is
> when I move all files from target_system_arch[ARCH] to
> target_common_system_arch[ARCH] I get an error because
> target_system_arch[ARCH] isn't expected to be empty.
> I suppose due to:
> 
>     target_system_arch[target_base_arch].apply()
> 
> Yes, I can keep/add an empty source set but it makes meson
> files review more cumbersome (unused source set, but if you
> remove it then the build fails).

Oh, I see.
Then, you just need to add a conditional
"if target_base_arch in target_system_arch" around this spot, and remove 
the dictionary entry set in target/microblaze/meson.build.

- target_arch += {'microblaze': microblaze_ss}

This target was much quicker than arm, it's nice :)

