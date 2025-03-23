Return-Path: <kvm+bounces-41778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ADC5A6D0FC
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 20:59:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BBB83AC554
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 19:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4100B19C569;
	Sun, 23 Mar 2025 19:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kdsIY5Rv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0675BAF0
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 19:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742759888; cv=none; b=tVDkDTLQYv8XcBW/ttNy6BHdvtGFtZOj59O6Oj6FvxUnik5fHWastkl7PbEvECzhzfY2XHbmWWbeFA9Caj0MkglUUp8fEXn6yVXAL0u7Rr3pGSZOIUSQ53sklRXnc+8YNKhIPre3kazC2pYJ3Wo+3QqdjZt9laub6eug3rQxJbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742759888; c=relaxed/simple;
	bh=9IWwDDdEf/2hRY17kEoSHEADA41ZDRe4EtrNmvGwV0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hzLJtZfUlCH5dDr+BH9V6MuAEcS5rkRFyZ9fpf9R0FZN5AGoaBn4uEA+KRCp5/s1xsa1By2iwdWwlhU6eyiviwSU+NqEPqelazDtEdLgRXSvTf0LJxTvbW3pf5QvCQRymmnRtfKLc69X/5sZRXGmTy8L9RJkJyBk6PsXfeGGm9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kdsIY5Rv; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-225fbdfc17dso54717685ad.3
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 12:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742759886; x=1743364686; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rV6w+vA/HSvcsGTSqT6d/tmonvQTsJQlJQIhHzRBrjo=;
        b=kdsIY5RvqrwgLek00QE+bufDUxCp+nLfJMbIPg3mY7hxgCJTTuNb9WakQDpDUfmbCD
         hyZlmfgfW0cd+oC36DnpYiYsmwwwjvGBJ/8JQkqy5r+Ao1rEukHwtstxktbawrXRGCFG
         df8qIqPDyc9yiIUFoiV8MLU3Ht7IeRnxtVD+PFSMfv6ACqyYsZ8UjUEUS4zwa24rfErI
         FVgYUKzAQCQP0y/HsMe0U4vBH6ElccQXozt44QBNJJdq2xkIiyvCC6iyPLF6ky9z6StT
         c2I4K9i3VpgOgq/6YKaJCnZEYhoF+Dai9wSHyWu0jHgvDMsy8gyitm2nzeloQ70uBtIc
         9ylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742759886; x=1743364686;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rV6w+vA/HSvcsGTSqT6d/tmonvQTsJQlJQIhHzRBrjo=;
        b=j5COO1J7+6yvdFicimtnn/KGUwh8u9mOQbsMwWfKEx8mAvpy59eZ0ub+h+N62YvxbL
         MAwSH7/StqcnjsdpT5uNh2lx3952j3tyFiM8K1nyymPyZlyaeb5n+dzXGjQZjWakcQal
         8ecG8ecBpdZAYkqrL2xzkvSXqZ/cFCmohJYAoAtcx1gUOZuimkvu19Scll3MdvMf72LX
         jzs+wB8zLwUfxgct6hySRF37x9GNgtvJ1DFXDGX4vfKCSiNGKbXVe+M84OPlpNN3bhg/
         LlnuCJ0yrvcjaPpD83k0XxO0xodjDipYq+y5hMkKn6pbzhGNXilM4MJuYsrX3+OPdK/R
         /GLg==
X-Gm-Message-State: AOJu0Yy/IfJ0BTZJ5FDXHhsw+fr8HGHFIxMWKsWUYiwexFNTEYtsYgOw
	hZI6mXV4TqwniiCC3PJAfPkaHH+qe5PmeW2W9P0T3mSMUK11MjvlmegBTIeCH2A/GCDcIyX1xls
	u
X-Gm-Gg: ASbGncslIiOilYhilFx0VDkSNvry/JoLERQzkK1UG6aHzvQL+QUAgpn046dBgDJNcgb
	BQPzYaD8rOld59bnfw5WTLkmURh6D8ucs09AQ3MDuWoixphlRwytaFBdam7OHzgwJYh1QOZy7NB
	Xzjka3/S9qUaiQl237O1ZcSGEGem+NF3dD1wvuyMqulXO/E5TFV51t7wQBmUUp6GA6PJJ3Dl06I
	/EhX8hiTUv7iBTjL9BDV/zSGUWv9Qm+6KzrYbep7WqpBQDAEO8w7W9S3ErYRiwCAxRfTd8WRef+
	2Ac7BELdrfdI3uvgiVUXJiPwf/uHDMpDacR10Yotrg4x/u/LzJtFmnqz6DWhpXydBXkGxH2bb63
	jM30e4wo9
X-Google-Smtp-Source: AGHT+IFfak5B0jGxPFefdrcBK4EUg3tVjnxOA8xxYMB9LcDAjqBf1PF95EWl+vpwBeyVmqQayJ7ZBw==
X-Received: by 2002:a17:902:f683:b0:21f:136a:a374 with SMTP id d9443c01a7336-22780e25b3dmr168091805ad.43.1742759886087;
        Sun, 23 Mar 2025 12:58:06 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811eedcfsm55095025ad.205.2025.03.23.12.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 12:58:05 -0700 (PDT)
Message-ID: <2650a767-a829-4544-99f9-42e23b131da3@linaro.org>
Date: Sun, 23 Mar 2025 12:58:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 24/30] meson: add common hw files
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-25-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-25-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Those files will be compiled once per base architecture ("arm" in this
> case), instead of being compiled for every variant/bitness of
> architecture.
> 
> We make sure to not include target cpu definitions (exec/cpu-defs.h) by
> defining header guard directly. This way, a given compilation unit can
> access a specific cpu definition, but not access to compile time defines
> associated.
> 
> Previous commits took care to clean up some headers to not rely on
> cpu-defs.h content.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   meson.build | 37 ++++++++++++++++++++++++++++++++++++-
>   1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/meson.build b/meson.build
> index c21974020dd..994d3e5d536 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -3691,6 +3691,7 @@ hw_arch = {}
>   target_arch = {}
>   target_system_arch = {}
>   target_user_arch = {}
> +hw_common_arch = {}
>   
>   # NOTE: the trace/ subdirectory needs the qapi_trace_events variable
>   # that is filled in by qapi/.
> @@ -4089,6 +4090,34 @@ common_all = static_library('common',
>                               implicit_include_directories: false,
>                               dependencies: common_ss.all_dependencies())
>   
> +# construct common libraries per base architecture
> +hw_common_arch_libs = {}
> +foreach target : target_dirs
> +  config_target = config_target_mak[target]
> +  target_base_arch = config_target['TARGET_BASE_ARCH']
> +
> +  # check if already generated
> +  if target_base_arch in hw_common_arch_libs
> +    continue
> +  endif
> +
> +  if target_base_arch in hw_common_arch
> +    target_inc = [include_directories('target' / target_base_arch)]
> +    src = hw_common_arch[target_base_arch]
> +    lib = static_library(
> +      'hw_' + target_base_arch,
> +      build_by_default: false,
> +      sources: src.all_sources() + genh,
> +      include_directories: common_user_inc + target_inc,
> +      implicit_include_directories: false,
> +      # prevent common code to access cpu compile time
> +      # definition, but still allow access to cpu.h
> +      c_args: ['-DCPU_DEFS_H', '-DCOMPILING_SYSTEM_VS_USER', '-DCONFIG_SOFTMMU'],

Oof.  This really seems like a hack, but it does work,
and I'm not sure what else to suggest.

All the rest of the meson-foo looks ok, but a second eye couldn't hurt.

Acked-by: Richard Henderson <richard.henderson@linaro.org>


r~

