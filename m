Return-Path: <kvm+bounces-45333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25D60AA841C
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:33:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F9B2179FE1
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF6E158858;
	Sun,  4 May 2025 05:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jj0h7r3S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4055680
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336658; cv=none; b=sKEq/566G8H0jVn8R11SmOo+mamecfUDp5l1MA7XCxsegQmqXnlIGKveXWlkArQYbdKJXnMzhKl1GdbwBttzuEr6F7vfOhKvwlI8vaa6ADOqVB50ijX5jf7jNUDRGuAahfE+/MqpWbXvSBvToSxpxb5AJv3big+RGn2CFsSnfSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336658; c=relaxed/simple;
	bh=5VjPwwtl5mhQn5z1FAf8dWDjvyymWmg+mdD1XHtORP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EAoBrAC8TEx2r7ppsJtR8SUsxBcEqYE083s6F1fm5InhLpQ3dSpZ+alQJXrrd0ZX/raIxsvEfeeV1zmYh60DbXqDVNNgLSzKskQUhkA/j+31r3KQIRiP6nb5y31NC3JxJjfLxwyw6DQRvqfq4Dq7U4OeF1eVmiOlv8owqXesnVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jj0h7r3S; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-30828fc17adso3318896a91.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336656; x=1746941456; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6KTAcWJ13xp5uQrxG2Jl/+OuSInS0YWXgC8gF3pCHPk=;
        b=jj0h7r3S1jaBEv11ZTGHylDRUxdFk21ziysbE1vApP4M4QOx2kCVqxKCH6V9jzvJ81
         wRAGjk1YGFn2TSI+HDF9GnnIQoG3Xf7hsXVeWhvMeafwWQzrHjBsacHa/oQGkZ3Vw9UA
         Y0RoEJUhxcB5HfF+tG3wgkslRkVPF8Um0NBzAYr9BrNkdZ34PyecQ/pzHwpGKHLzb/i7
         kwKBUOtAiH0MCT5pxU0ZI4TIIUQdCPnfhSi07vvIPVEziLfSuBCcpJH0tsAVdJnOnOvX
         2nzgTXys22797LagSiyrgufwFYFVkknLvh12LWaIWuSt03MC/ggonFpWxOfUaRGcGedA
         mhZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336656; x=1746941456;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6KTAcWJ13xp5uQrxG2Jl/+OuSInS0YWXgC8gF3pCHPk=;
        b=HnU06Qb53P0698zxVRsSOSYey7tcZFNA0JuUSp55anpvoONUMUbBKgUZH8iI3eG+5V
         G+6yNwI5eqkAN9OsP/K5MvK9oIvR9X0DTIYjDIwClEtyJcQf/I77iwNVUty/3G2IEU6T
         8KZF6xuMpUIosJlHjCH1n3mJTA62Qp2QArLQvv1USOAXf1WU7Gwh1WsaMahxESJ1NBg8
         3YANqrPsd2i1AorDyIRyoWZhqEs5s2KyNRLG/PuG90/Ygh+iYJCmTJgN00WZwRmgmL+G
         SR/AhrZmIo0W/s/AGgCeaXulnZrQdM5UN9lHYLQgPIX/HHN04PHEalDRKS2sFP+D0CAO
         nI6g==
X-Forwarded-Encrypted: i=1; AJvYcCU+9ydLt+qp0MpzqPH7eQSLYFmJXgj1uf/ff0CYnMsfQKO0xWisk2ziBEZLMJpjDnB3Zu8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1KXyS5V9sZRl7i9VM+JOVRv2DXUFO/9it3zWpJ3xRAj9DcWHE
	pcHFoDHGEQEdRSCbPbttSDckLAQCaM4yvyyge7LB/h6FdgnFF2ln3FFuQw32I6E=
X-Gm-Gg: ASbGncv7pB0TTZ+dJQSJj6DYexzMBOQHY4Rymh5vzL3hJRA9fCC+zcSkkUUJTXHzsct
	byusKeEWmJydnXGcRIqa5PcobBSu5CVUq7WJexm7hp8StA6d65wHD1Z5enS+ogKUXR5dc4sbjCx
	TiMnw5Iqye25fJYWWdAcXtXHOn3PaaLaeYTrfLU6tQXuCmrJ09ddMr8U4VjZuT9GL5YmDPPUy9H
	jXetc7x16HaVyn65pa9P8KsBtG8Mz1iGab0aiNS1XxPblztVdtiHaVEcYjZnd7Fe3IffwWf8D9O
	U5YbTySEArWXBDFhBxg//GlVnpBkjv6JbeiOnWb/sGAgmAoktwDjK74svCXVHU8v
X-Google-Smtp-Source: AGHT+IFG3Fh3OmK4nyyMWaj/8CJF8m2OKT56xa6Rlm7TVxCw3VLXdVuw4KrYDmvPYL2Yqr7Q05OW6Q==
X-Received: by 2002:a17:90b:3505:b0:308:7a70:489a with SMTP id 98e67ed59e1d1-30a61a49176mr4616861a91.30.1746336656291;
        Sat, 03 May 2025 22:30:56 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e152291e3sm32237285ad.202.2025.05.03.22.30.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 May 2025 22:30:55 -0700 (PDT)
Message-ID: <e060e797-306f-4541-907b-7fdd8ae7781d@linaro.org>
Date: Sat, 3 May 2025 22:30:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/40] meson: apply target config for picking files
 from libsystem and libuser
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, anjo@rev.ng,
 kvm@vger.kernel.org, richard.henderson@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
 <20250504052914.3525365-5-pierrick.bouvier@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
In-Reply-To: <20250504052914.3525365-5-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/3/25 10:28 PM, Pierrick Bouvier wrote:
> semihosting code needs to be included only if CONFIG_SEMIHOSTING is set.
> However, this is a target configuration, so we need to apply it to the
> libsystem libuser source sets.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   meson.build | 26 ++++++++++++++------------
>   1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/meson.build b/meson.build
> index 6f4129826af..59c520de359 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -4056,27 +4056,19 @@ common_ss.add(qom, qemuutil)
>   common_ss.add_all(when: 'CONFIG_SYSTEM_ONLY', if_true: [system_ss])
>   common_ss.add_all(when: 'CONFIG_USER_ONLY', if_true: user_ss)
>   
> -libuser_ss = libuser_ss.apply({})
>   libuser = static_library('user',
> -                         libuser_ss.sources() + genh,
> +                         libuser_ss.all_sources() + genh,
>                            c_args: ['-DCONFIG_USER_ONLY',
>                                     '-DCOMPILING_SYSTEM_VS_USER'],
> -                         dependencies: libuser_ss.dependencies(),
> +                         dependencies: libuser_ss.all_dependencies(),
>                            build_by_default: false)
> -libuser = declare_dependency(objects: libuser.extract_all_objects(recursive: false),
> -                             dependencies: libuser_ss.dependencies())
> -common_ss.add(when: 'CONFIG_USER_ONLY', if_true: libuser)
>   
> -libsystem_ss = libsystem_ss.apply({})
>   libsystem = static_library('system',
> -                           libsystem_ss.sources() + genh,
> +                           libsystem_ss.all_sources() + genh,
>                              c_args: ['-DCONFIG_SOFTMMU',
>                                       '-DCOMPILING_SYSTEM_VS_USER'],
> -                           dependencies: libsystem_ss.dependencies(),
> +                           dependencies: libsystem_ss.all_dependencies(),
>                              build_by_default: false)
> -libsystem = declare_dependency(objects: libsystem.extract_all_objects(recursive: false),
> -                               dependencies: libsystem_ss.dependencies())
> -common_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: libsystem)
>   
>   # Note that this library is never used directly (only through extract_objects)
>   # and is not built by default; therefore, source files not used by the build
> @@ -4315,6 +4307,16 @@ foreach target : target_dirs
>     target_common = common_ss.apply(config_target, strict: false)
>     objects = [common_all.extract_objects(target_common.sources())]
>     arch_deps += target_common.dependencies()
> +  if target_type == 'system'
> +    src = libsystem_ss.apply(config_target, strict: false)
> +    objects += libsystem.extract_objects(src.sources())
> +    arch_deps += src.dependencies()
> +  endif
> +  if target_type == 'user'
> +    src = libuser_ss.apply(config_target, strict: false)
> +    objects += libuser.extract_objects(src.sources())
> +    arch_deps += src.dependencies()
> +  endif
>     if target_base_arch in target_common_arch_libs
>       src = target_common_arch[target_base_arch].apply(config_target, strict: false)
>       lib = target_common_arch_libs[target_base_arch]

@Philippe: this is the patch you need for semihosting (+ previous one).

