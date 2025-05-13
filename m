Return-Path: <kvm+bounces-46316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2862AB508E
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 11:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BF3B163AAF
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE2823BCEB;
	Tue, 13 May 2025 09:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wdHjD1/M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773CC1F5852
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130286; cv=none; b=IpPjC/xplgSTkHFCuLZwooYlfWRARsbOpFi0CTqoKfDJ83nfpD/nFlH5+76qy1TcbPdEyeIMwnPzUjmGIg8ESdh0AVkQl024pbKnHHzHUy/zEGNs64U1dvMVdUujgjjBtKOF0f5KGtkSm7xtQqPQ+udru1TQ6Uu2b94ri6Vgu6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130286; c=relaxed/simple;
	bh=2HdzxtwD2V6qRT32rB77zjA/NPCK37s2EHbjQ9Lz2qE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JZ2WuKrA/QvRz1VSvU+CFBnmy3wtEoP/+8RitEtyoju+Oc6sOAhJbQOkKEf4Ls48VSwJHHjKlAqHPTSRQxkkYQy2L3D+9iY2BqCELmCHVx/zYEYX+C3kzK6j/51YIVEeuJmOIJ/vkJLekPpib+EdL9+yM8Exi2kZ+FCvOPrf8A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wdHjD1/M; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a0be50048eso4101499f8f.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 02:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747130283; x=1747735083; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u+orejYg5iGx2gkb2gtAC+NwOz7ulxd/j87UKY2QmtE=;
        b=wdHjD1/MQeKnRFRW9i313rmwglXWfjX12ds8fImyVnZnq8H2WVssQc3gYRSNOF9Pe1
         mRNefvqCWPvNzlrJtMazfahtAc+zfDrlmo/6W1saCoui1Jyzcr+OGRrFCZ9iooMZKVMn
         gnrQSXIkKZg2mlbd9bmw3x5k0WpQzrUN2c2RRQogf1EFUc9DKto6pFHObTwf1dKcDEJd
         38EzVOFHKNdrGRzdkoUvJPTpVFVaXizQfOYMv5c3sdMQAPJt2BHr1KrXFT784cABHuFo
         HynrPvxYcpiChgVCiCgLtttzGyPUCX0BtzMCbyzG4PvQu4vk0LH73wo8uFj4WUUgWOD6
         ixjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130283; x=1747735083;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u+orejYg5iGx2gkb2gtAC+NwOz7ulxd/j87UKY2QmtE=;
        b=VVfYenGt6JHyf6nIYzIvSb4J5SVUwhc89j/Ct4CP0czqc05Fm9Msif2gDj4cliGU68
         +UGjSXwZ17O2WnfIPdPOG6CVKIa/j1KcxTjx6eDaIP1Orx3YTSjQ92GKxJIwF/Wva84h
         leMZzKsWsT/3MKPx+713FzsVDxz8y+qTll/pSD52VdgoYIvu5kw2sZSwlpHPicdQwa9s
         dOgsHQpAPQ95gvUmKHy27D8UEkqHHolMT1PPL6RwyilMXXHtXnWkPeDNqKXzusH7Ys4h
         XukQPjTW7bUzApJZlUmZjZmWaMC4wNUhe3g/Rm3G+UTYeX5olIY4njuXKZ66J1Fdj63H
         MdjA==
X-Gm-Message-State: AOJu0Yzx/B3/C3f//OxLZrHKM/PZpA0fPpSYUp483lDmmaOqrJTkWCFW
	ZPdRkk/sW2TWH/JudLXlNcwmpxPGa05FuYdVz+CjOvnOxilRZyFqDyseOdaVHVA=
X-Gm-Gg: ASbGncsuhamC0NPb3fl/aux8kxJCmd3qlXMiHVXqLwWTqBRJsBck+tj26qCGKOpGRGo
	RoMoJHdv1oJ+1MLFMKNJFmAuiC5RL/1Fb8317UMbQNjqk42yZx0a17RHVjkQ6eeIX8kSL/H8C5N
	oRmK4jWQvP26L12abIIvnoQ1bp9GV0DFv9+MVkWH1VSuy0b2GPUrL7zvVMVsEOBG0ob3h7D9SOd
	KDFfA8l91RH3Op7gmzoh9BBoujwRum6XRlxj26KD438fjKW4S7nI1CAZIGRbL0B4mnNikIHMJ1X
	bx5mrMOlaOXleUvgYmFh2wudUr8pqFUViFmtAbMgTefkeOe+x1TAEXwMTf/O4WTF2ifA6fT7WU3
	RgYyXsnTN6dlATnAcO2GSbe4=
X-Google-Smtp-Source: AGHT+IFH2OlvRcGl4N9FjP9kuGhmZ9IA5VlsAJQgKag/eumhT+Cs9hNppG5RoEwO0fq6PUrIk86v4Q==
X-Received: by 2002:a05:6000:22c4:b0:3a1:fb7c:278f with SMTP id ffacd0b85a97d-3a1fb7c29b0mr9435718f8f.22.1747130282699;
        Tue, 13 May 2025 02:58:02 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2ca31sm15710232f8f.65.2025.05.13.02.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 02:58:02 -0700 (PDT)
Message-ID: <a7c1d6b0-8e62-4bcf-8b0b-35311d4f7802@linaro.org>
Date: Tue, 13 May 2025 10:58:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 02/48] include/system/hvf: missing vaddr include
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-3-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-3-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> On MacOS x86_64:
> In file included from ../target/i386/hvf/x86_task.c:13:
> /Users/runner/work/qemu/qemu/include/system/hvf.h:42:5: error: unknown type name 'vaddr'
>      vaddr pc;
>      ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:43:5: error: unknown type name 'vaddr'
>      vaddr saved_insn;
>      ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:5: error: type name requires a specifier or qualifier
>      QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
>      ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:18: error: a parameter list without types is only allowed in a function definition
>      QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
>                   ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:36: error: expected ';' at end of declaration list
>      QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
> 
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/system/hvf.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/include/system/hvf.h b/include/system/hvf.h
> index 7b45a2e1988..a9a502f0c8f 100644
> --- a/include/system/hvf.h
> +++ b/include/system/hvf.h
> @@ -17,6 +17,7 @@
>   #include "qemu/queue.h"
>   #include "exec/vaddr.h"

               ^^^^^^^^^^^^

Since commit 0af34b1dacc this patch isn't needed anymore.

(no need to respin as it can simply be skipped).

>   #include "qom/object.h"
> +#include "exec/vaddr.h"
>   
>   #ifdef COMPILING_PER_TARGET
>   # ifdef CONFIG_HVF


