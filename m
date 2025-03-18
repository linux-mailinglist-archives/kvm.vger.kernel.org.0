Return-Path: <kvm+bounces-41453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7CE1A67F73
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:12:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0605619C03E3
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4EE620766F;
	Tue, 18 Mar 2025 22:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EPdVKmH1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531692066EC
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742335880; cv=none; b=i7KiGjuizrwmoW3ykIMWiMJoGQF1xTPCMEtbBHPV8b7aIKQ74IfHApxp+bUrJKTC4YqLPbEMYvi+oDO1p5eYK6skkzIzePAv9sie+pa97lFm4KxJHSAoXomsGWdzyeHNBQWT/HVCcty4fYV4QZo7AaZ9YLgle0z5GdpiZMvyGRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742335880; c=relaxed/simple;
	bh=iEpeNTK8mzEb3zVd2E9ANGIFzGakCL5Px4lneNNn2Ds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YdeOaolOLnnqs+D7PSQIpk/tJaivVeDW3EXvGeCVOQoOqxRoijoETO/4ZABU66z0e6kW//+5n4OOKRGEtRS74JjgSuwxjb4iFQDdVXnmy/MkV1oQlBXPoA/zrjJCk8tya5iyjMQYbq0snhCyE3jlzkZf3EUGAjsVHaoMRWESjas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EPdVKmH1; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-225df540edcso2229685ad.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742335878; x=1742940678; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+69esl2nOuGPMBCNKxNirnt+vS+cxkG3qdPl+eItGdM=;
        b=EPdVKmH1SWu6nkeI1Mt3X0PGdD3DuXWGiV2IE2TapaW2etrEGbofzlkAOzLnzWf/St
         MDxvae66XcEyZS7NkfxBjUfczyJ+I445N02UOSZBMcQFSZYzmFZtcv4wG+p51CDOwIje
         jHEGpafxCG99SMQK9cxGXvozMBwDdpSPaqc4aOjLoZumHLi4ek9IdG2g3hmQLlPuZD6i
         ti2oyjvoy88DgbVvbyg033EJzvp9Jhombn+gvt+JlZciDH6MzRyGCbPrT4QlT5xqfO4d
         ULqr9YNZGUkLmWiZzT3aZQ/LMlIVH9rej+DXVTk5zxjblmb82c6MHg7O0HHbdgttYRRs
         F54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742335878; x=1742940678;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+69esl2nOuGPMBCNKxNirnt+vS+cxkG3qdPl+eItGdM=;
        b=YicBT8Py+DrkPa9UI5K3IzTfS2yed+9UbontU1+EU+RHLWpwUnxzJPkjy7bDy7f/kc
         EaHNL1Ez0UyOJYfGvhgVcEerLwLiXS2F3KJGLcqzBLaeOi5EMYlhlFGj5RrLZFp5I1RW
         MQc4RumtgLCy5BSNNTJzAYsU9tS3/fNnNc61d3b1J/ONJSwZ2mmtHbudeFXe/h93RQU9
         YucxqkWKXnty6RTNeR3HoCOozKlQ4L95zmM7dBrk7p1xZPUfTGaj6FFhqOgm6rNQsRn0
         kvVmy3aDeJlyYMShQIF7IVG+EyLNTrWCJb/RuUUstaZrBeV5VycB1CfiDRPvIMhKWneM
         3Vew==
X-Forwarded-Encrypted: i=1; AJvYcCX4o8JiTTfzV915pkCdaPaFttMw5nkXiG5+sFd/7ahmVhfAvVKfoZG1d7a6InUbNbfZFlg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyK4J1sB/Rvn6IfGXgYXdtSzY17KvJp2KGkuCQfioyHWR8g0Tvy
	xFO1tq7RO0toThMhYZvpYivt01/DgHJIRatft/zh6ehyXsw6FjJV1nB4HA7UeX4=
X-Gm-Gg: ASbGnctGi88fmhEpbXpF5zI8L6VdJ8GOc8TDRKzSS2IYVrbDJhXgmduPXbGATyqxm8I
	PeWrWzctEN+n/CIVMFZKhKfBLJTV2Ra25pQPz8dPyDZJqI2qnHnnTBs2e24CiS8kJADD5I9wJ+T
	nC6VqdyFlZ0d37rOUEjTohWtiRdl3c6caYuMUjI93vtg5BXLz91Ge0SH5flyaVlNtjNV/6/mNsL
	Vy9JzsawE6qfp1mKR/xecXA99c7R4vGmd4NdAHHW0it25MyuAvj0DP/W55h3Hb9/T4XFdzbaXaD
	4n/XM3BN++L2DzAvOL8pM1XA1wX8hpbcrS6TODX0F7bvtUShqny86FBJVmSkdJKB8ZIdhf0PY6i
	Tu40xPL2x
X-Google-Smtp-Source: AGHT+IF+o57KxPqZyp1dw2vr26h6BTXUQUOnR/DxEq+2jvgU+MIkHQqqlXf/RtfTtCdotr4CtaEHHA==
X-Received: by 2002:a05:6a00:218d:b0:736:bced:f4cf with SMTP id d2e1a72fcca58-7376d4619eamr874582b3a.0.1742335878454;
        Tue, 18 Mar 2025 15:11:18 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-737116b10edsm10459572b3a.171.2025.03.18.15.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:11:18 -0700 (PDT)
Message-ID: <35c90e78-2c2c-4bbb-9996-4031c9eef08a@linaro.org>
Date: Tue, 18 Mar 2025 15:11:16 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/13] exec/cpu-all: allow to include specific cpu
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-5-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250318045125.759259-5-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 21:51, Pierrick Bouvier wrote:
> Including "cpu.h" from code that is not compiled per target is ambiguous
> by definition. Thus we introduce a conditional include, to allow every
> architecture to set this, to point to the correct definition.
> 
> hw/X or target/X will now include directly "target/X/cpu.h", and
> "target/X/cpu.h" will define CPU_INCLUDE to itself.
> We already do this change for arm cpu as part of this commit.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h | 4 ++++
>   target/arm/cpu.h       | 2 ++
>   2 files changed, 6 insertions(+)
> 
> diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
> index 7c6c47c43ed..1a756c0cfb3 100644
> --- a/include/exec/cpu-all.h
> +++ b/include/exec/cpu-all.h
> @@ -46,7 +46,11 @@
>   
>   CPUArchState *cpu_copy(CPUArchState *env);
>   
> +#ifdef CPU_INCLUDE
> +#include CPU_INCLUDE
> +#else
>   #include "cpu.h"
> +#endif
>   
>   #ifdef CONFIG_USER_ONLY
>   
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index a8177c6c2e8..7aeb012428c 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -31,6 +31,8 @@
>   #include "target/arm/multiprocessing.h"
>   #include "target/arm/gtimer.h"
>   
> +#define CPU_INCLUDE "target/arm/cpu.h"
> +
>   #ifdef TARGET_AARCH64
>   #define KVM_HAVE_MCE_INJECTION 1
>   #endif

This doesn't make any sense to me.  CPU_INCLUDE is defined within the very file that 
you're trying to include by avoiding "cpu.h".


r~

