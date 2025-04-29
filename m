Return-Path: <kvm+bounces-44819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A4BDAA18C3
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 20:04:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A4DE4E0475
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 18:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADE3D22AE68;
	Tue, 29 Apr 2025 18:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q+AIyMAi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A35253F25
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 18:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949724; cv=none; b=ImjM5HtGHPhIt5rQ6Z+4HfrL2M2nhuO7YxqRFCVxiOOq8O9mUnI1iUpdO1xfQOAoRhUUolKioqqi1A9ooOQZbF5zNBNm773dIbRi70dZKkf2iTCbDnO2ZxE0RqZa+zR5NyrbMLGsZzmgevqkrtXQdarIOG72MFxbpjpN2AwXG4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949724; c=relaxed/simple;
	bh=Vv6CjAX0UcypBdi0r3oZDdsAEr6GHrBU4Ith4OdMgcs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qxcuZ25Cj/pMHmwFoqZmpWvTTjm7rhPmlgyDVVTngY/c0P0/G7E9YXvKc7P1GlHtj5sXG7NjQ6gPGa/Llt1tRWbkIWrvbYycY98NwFzz2lCju4EpWhthmgx7xyOqEdLlroLKfknqSYcqqiEb1YZB34Asqgtf1nOwoNTpahqljfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q+AIyMAi; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4394a0c65fcso62673145e9.1
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 11:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745949721; x=1746554521; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5tX6znmzbpd+MNtjGZbGG6rcM/3SSGVVvBfmXACpsrY=;
        b=q+AIyMAi6FI8Shsc+G8SrPzSM3sdZ/byFcCTFC1fLYV/Ika7AKRQ+YPS79M+BRCSKq
         5Gl6cU+XP3RH6oFxtwUchhRt4wlDt/MiH2iHfWbaYZN04y3YDC4EQmxmdmI4iruAVEa0
         cKvhRsNd0qNJ3cjLXGTff8T0yPHAelugHhm5ROXDRYScwcrVjS3QPtoyZ6xywgB577eh
         w1qY01mY7yGjT5wBZGkUzsCzzhdWyK1jd6scgPx8kOzD8IMQRBpYEK9NcWOas9KQgo+n
         BN2Q+jhX8exoWlWNcqbsM7VMbAK5rmjGhQTrfLqvQUvVeOnzuP9NiHvbMBGCDZJCJa96
         mkig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745949721; x=1746554521;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5tX6znmzbpd+MNtjGZbGG6rcM/3SSGVVvBfmXACpsrY=;
        b=ubbjd1zrjy1FPsEFj+XQRtA4FDtcS29L5We651mQlXuFXWn5P2wTxD2sdQ/o2NYgL1
         wOzCCdB9iOvD5jqVvcFA7bO3CTmI11sZYQvWpWs0rJpFkgDP61wCjSJIiSFDzycWV0tC
         wbeOUdZFbuDezJzW6K4NgNXyzT5gaF47JGfDHbxcV7OiYEiV7Vi9Aw0wwVH24UJONh4v
         9oiDcnRE4QM0L3ch/yGKU5lZM06fXN9f5/aPuB/Eti4rs1rCqoy517ns5WCXyVDdMIpZ
         E1lvZ+RVixK94CU1XT4Luw46K1USX1rqCNB6tYShGHq61X3ytN/9SGyX8CvtzzOLpKKf
         Xwow==
X-Forwarded-Encrypted: i=1; AJvYcCUJBjxGab87uHMQBSf2O/kH7szThndXJt7i+5YctOSbimxC/cC9B5/KPiu80kZaiXh3d6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaXHDA1afB07I7DAdEi5IL6K96JmMJwqNqBy+7NwVbdrZBPnVR
	yi3sdILpMCghkLA70zppaAJ5wAlJeQQCa/uGwE3Jh3xpQKlH0yAo6rHo47tkHXCgHTbxd3vYCcI
	Z
X-Gm-Gg: ASbGnctrTFRO9Bf6Zmltfc8SBX2BMUydQYcf39HhJF4yM7TATTfUvrKW8YS0QdteriC
	Giu5bm+DEdD/93prn4RTH7CoO9gPzIIPuvfIph7K6IxAtvQ3tyJ8tQO6n4oPT7m/mlrvekr4HZC
	ZU3sooci1agnFxdYnevUpmCX5FNFN7i9pGp7j7WSXFrlv1jLLxNKTh05TtZebp0PgGPyk9c6bzq
	K+gOGJZGjznoAlpnp7v7tToHBmymsSrPMwJeSeUeYaLHdLMNf3BXZW/B/8usSYsvy5gI9PbUZev
	2jl0Q7sJ2Vq4nIxany6kb4Vw1fWUedkbeQvtq/VvkzU5zt0hY1Oqsq4HNRc37Chw7+F2sgZVVT7
	EXXExUafDSBfo4g==
X-Google-Smtp-Source: AGHT+IGfaI23NYF76B479Bp7eKq+GJV/N5yaJymdVdvVphglf8imvkiZbjfj4oSEsp2KqhUsCvYy4A==
X-Received: by 2002:a05:600c:3844:b0:43c:fcbc:968c with SMTP id 5b1f17b1804b1-441b1f32cb5mr1737775e9.7.1745949720801;
        Tue, 29 Apr 2025 11:02:00 -0700 (PDT)
Received: from [192.168.69.226] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441ae456d7dsm15945095e9.1.2025.04.29.11.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 11:02:00 -0700 (PDT)
Message-ID: <fd70e4f4-29b8-4027-a70c-747729172ce5@linaro.org>
Date: Tue, 29 Apr 2025 20:01:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] meson: add common libs for target and target_system
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-arm@nongnu.org, anjo@rev.ng, richard.henderson@linaro.org
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-4-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250429050010.971128-4-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Pierrick,

On 29/4/25 07:00, Pierrick Bouvier wrote:
> Following what we did for hw/, we need target specific common libraries
> for target. We need 2 different libraries:
> - code common to a base architecture
> - system code common to a base architecture
> 
> For user code, it can stay compiled per target for now.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   meson.build | 78 +++++++++++++++++++++++++++++++++++++++++------------
>   1 file changed, 61 insertions(+), 17 deletions(-)
> 
> diff --git a/meson.build b/meson.build
> index 68d36ac140f..7b2cf3cd7d1 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -3684,6 +3684,8 @@ target_arch = {}
>   target_system_arch = {}
>   target_user_arch = {}
>   hw_common_arch = {}
> +target_common_arch = {}
> +target_common_system_arch = {}
>   
>   # NOTE: the trace/ subdirectory needs the qapi_trace_events variable
>   # that is filled in by qapi/.
> @@ -4087,29 +4089,59 @@ common_all = static_library('common',
>   
>   # construct common libraries per base architecture
>   hw_common_arch_libs = {}
> +target_common_arch_libs = {}
> +target_common_system_arch_libs = {}
>   foreach target : target_dirs
>     config_target = config_target_mak[target]
>     target_base_arch = config_target['TARGET_BASE_ARCH']
> +  target_inc = [include_directories('target' / target_base_arch)]
> +  inc = [common_user_inc + target_inc]
>   
> -  # check if already generated
> -  if target_base_arch in hw_common_arch_libs
> -    continue
> -  endif
> +  # prevent common code to access cpu compile time definition,
> +  # but still allow access to cpu.h
> +  target_c_args = ['-DCPU_DEFS_H']
> +  target_system_c_args = target_c_args + ['-DCOMPILING_SYSTEM_VS_USER', '-DCONFIG_SOFTMMU']
>   
>     if target_base_arch in hw_common_arch
> -    target_inc = [include_directories('target' / target_base_arch)]
> -    src = hw_common_arch[target_base_arch]
> -    lib = static_library(
> -      'hw_' + target_base_arch,
> -      build_by_default: false,
> -      sources: src.all_sources() + genh,
> -      include_directories: common_user_inc + target_inc,
> -      implicit_include_directories: false,
> -      # prevent common code to access cpu compile time
> -      # definition, but still allow access to cpu.h
> -      c_args: ['-DCPU_DEFS_H', '-DCOMPILING_SYSTEM_VS_USER', '-DCONFIG_SOFTMMU'],
> -      dependencies: src.all_dependencies())
> -    hw_common_arch_libs += {target_base_arch: lib}
> +    if target_base_arch not in hw_common_arch_libs
> +      src = hw_common_arch[target_base_arch]
> +      lib = static_library(
> +        'hw_' + target_base_arch,
> +        build_by_default: false,
> +        sources: src.all_sources() + genh,
> +        include_directories: inc,
> +        c_args: target_system_c_args,
> +        dependencies: src.all_dependencies())
> +      hw_common_arch_libs += {target_base_arch: lib}
> +    endif
> +  endif
> +
> +  if target_base_arch in target_common_arch
> +    if target_base_arch not in target_common_arch_libs
> +      src = target_common_arch[target_base_arch]
> +      lib = static_library(
> +        'target_' + target_base_arch,
> +        build_by_default: false,
> +        sources: src.all_sources() + genh,
> +        include_directories: inc,
> +        c_args: target_c_args,
> +        dependencies: src.all_dependencies())
> +      target_common_arch_libs += {target_base_arch: lib}
> +    endif
> +  endif
> +
> +  if target_base_arch in target_common_system_arch
> +    if target_base_arch not in target_common_system_arch_libs
> +      src = target_common_system_arch[target_base_arch]
> +      lib = static_library(
> +        'target_system_' + target_base_arch,
> +        build_by_default: false,
> +        sources: src.all_sources() + genh,
> +        include_directories: inc,
> +        c_args: target_system_c_args,
> +        dependencies: src.all_dependencies())
> +      target_common_system_arch_libs += {target_base_arch: lib}
> +    endif
>     endif
>   endforeach
>   
> @@ -4282,12 +4314,24 @@ foreach target : target_dirs
>     target_common = common_ss.apply(config_target, strict: false)
>     objects = [common_all.extract_objects(target_common.sources())]
>     arch_deps += target_common.dependencies()
> +  if target_base_arch in target_common_arch_libs
> +    src = target_common_arch[target_base_arch].apply(config_target, strict: false)
> +    lib = target_common_arch_libs[target_base_arch]
> +    objects += lib.extract_objects(src.sources())
> +    arch_deps += src.dependencies()
> +  endif
>     if target_type == 'system' and target_base_arch in hw_common_arch_libs
>       src = hw_common_arch[target_base_arch].apply(config_target, strict: false)
>       lib = hw_common_arch_libs[target_base_arch]
>       objects += lib.extract_objects(src.sources())
>       arch_deps += src.dependencies()
>     endif
> +  if target_type == 'system' and target_base_arch in target_common_system_arch_libs
> +    src = target_common_system_arch[target_base_arch].apply(config_target, strict: false)
> +    lib = target_common_system_arch_libs[target_base_arch]
> +    objects += lib.extract_objects(src.sources())
> +    arch_deps += src.dependencies()
> +  endif
>   
>     target_specific = specific_ss.apply(config_target, strict: false)
>     arch_srcs += target_specific.sources()

Somehow related to this patch, when converting from target_system_arch
to target_common_system_arch, emptying it, I get:

../../meson.build:4237:27: ERROR: Key microblaze is not in the dictionary.

4235   if target.endswith('-softmmu')
4236     target_type='system'
4237     t = target_system_arch[target_base_arch].apply(config_target, 
strict: false)


