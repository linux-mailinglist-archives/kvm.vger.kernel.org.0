Return-Path: <kvm+bounces-44968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64B03AA53FD
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 063FA7A9CB9
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4522690C4;
	Wed, 30 Apr 2025 18:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mKLgk287"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31C618024
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 18:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746038695; cv=none; b=f7WW1ETm/nRcyMrCRidwH/IEngPz5odh2JoA6k/dSeHsoBZrm47SzKJgijkg7OJLPG1MK/jJOUoXoh90CnF1V04+vUG9/uc+SIrC267D2q4lQtYGpbWXsy0mnhunzBJF1QADRvXmm8Miqm8oOkeoK4twsF5GZyLGTUvaDG+YTAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746038695; c=relaxed/simple;
	bh=PAAOmbVnYIXP0gtYFComl7H2mhE153nK56/A5N3SaEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hcNmNZN0Kt8ZhPiVmiKBoCKF3r8zCV4U6H+0x/KEyqw5haLD1zKJaEGYdB3K8doGJOMudDTh6r2+R2Fy+BiWSgxWVorOHEIY5wzoDqsIXwO+NoOavdNv00u5uimBaomJzqhwtuxWN4wcHifm9Dxtt8kacjobCVNq57/DOtjGI3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mKLgk287; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2295d78b45cso3034595ad.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746038693; x=1746643493; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JdWqsLDjnrtyzwFMcIoY/AoiwcaSRG/i7b+cFDcrK9c=;
        b=mKLgk287C/ov3x4fOI4cpCPgDG5c3zEXqwcrBBLlyhHBFhrHpQc0G3qnaZlrksg5I1
         i67ZDqpFUdCZyKSoyHc2Stxrd7gAHi9wTSLUXm1WTt0C0Ju2elz6zCwGfG15zZ9oONX+
         xHVEXkCGJg/tKvAoHBM6lkvLzAuxG0pPKaFwNVo37jZBzXFao9pTI4NAXevx/KC59hsF
         ArjdVbpf8xaaE2DjvCjeBAbawjq0R/Eumv2Z7Yxr4ndFV2k2yIgM0PjOp7tDdPO5/3Mo
         Maz8e3VUJXp/D7AUaztf+PS/gAbHu43doVmqAK0mc/qj+tz9fH0QPDyKtHI/K9cIysWO
         9LNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746038693; x=1746643493;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JdWqsLDjnrtyzwFMcIoY/AoiwcaSRG/i7b+cFDcrK9c=;
        b=P7xqGEHTAjWfVBa0scJjNw4/7PSRGklgeEi6JYdc18KKKcrqrjDQiIffkeoR5OHWIM
         5g8wo4NvYPlspjsdTqBqrZoB68Ql9a1MyqRuWBj7pOuQ/0oU4lUHG/0MVGXdDMaTOQfm
         XwJcmELkHKMmaypxW949sYWeMBCV3j7IOq7esOUOFo7qgLy9nQDd8x4WV0KJ0B3Wko++
         e4UBaVzO0DUE23TxTSJzYpgn7lNyl03D7U+CPTsFP6Gv8kevtVSQfmCSOfVIg+vX9wi3
         WQeZdWRxXCokShm/01yr7P8ui10iNfwVltDBPDfZa0G7BNMXydVv45dqkA7+IINwOv9B
         6J+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXURSrhNaaIk2QXjrS8Hc60tjX25C+x71dha6/8mq2V+5TF4wBK3ZkU3s3AOQgoFpw75lQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YykKbKltf20/LJ5GgUA+AXn9wgdbXf0mhq1XlAtqN0MUkEeOFIs
	8Ev4uKG3ZzBefq+NR6IU6D2DIzM2UTY/pizcY6NeyYSdktXewSWJGPbgeqqTz70=
X-Gm-Gg: ASbGncvb7Wo0irEM5NHlgsGHKsv6RH30274FBSTaKWsPUFVPf4stUDCDJk9DijDr7Lb
	P/f8q1XbIMcHFfnC2MI5GRyR0GBVcF9tw/iJUVmenHC/ZdFn9QWhkyy5xuUK/hC0NgPPc2Mh7la
	GwNqYg4r9YQoX27rwHrB5V7vz7+KQQn4JM1/9uBV4f/Y1bgnYIh77G7h5nt/A60fGBH3++yFY90
	KFmlFA7abktTuo6ypAb5OMo6L2zBuzpPTaFYgDudEjyMxYztDhHDV2oYRfuLv/q+ofYAkTq2Jhf
	UFQXbQuq0ECHwo5kxwmzFZZir/RWoB0O3vjVfqkKrpCf7v1HoiF6pQzA7tpciErP6A1n+xBlkW3
	Is9b78PQ=
X-Google-Smtp-Source: AGHT+IHxn1Zv7Hu1E+clIILqP1pD7IlfPAs6LU2N+d0EY9D8VKYrJPa4AMt91rvWNqyMk4G4YZ47MA==
X-Received: by 2002:a17:903:17cb:b0:224:191d:8a79 with SMTP id d9443c01a7336-22df57ab489mr60984125ad.27.1746038693185;
        Wed, 30 Apr 2025 11:44:53 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db50e7cb2sm126245815ad.112.2025.04.30.11.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 11:44:52 -0700 (PDT)
Message-ID: <639c510f-4843-4c08-9952-83f9e781d679@linaro.org>
Date: Wed, 30 Apr 2025 11:44:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/12] target/arm/cpu: remove TARGET_BIG_ENDIAN
 dependency
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-9-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250430145838.1790471-9-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 07:58, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/cpu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

> 
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 07f279fec8c..37b11e8866f 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -23,6 +23,7 @@
>   #include "qemu/timer.h"
>   #include "qemu/log.h"
>   #include "exec/page-vary.h"
> +#include "exec/tswap.h"
>   #include "target/arm/idau.h"
>   #include "qemu/module.h"
>   #include "qapi/error.h"
> @@ -1172,7 +1173,7 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
>   
>       info->endian = BFD_ENDIAN_LITTLE;
>       if (bswap_code(sctlr_b)) {
> -        info->endian = TARGET_BIG_ENDIAN ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
> +        info->endian = target_big_endian() ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
>       }
>       info->flags &= ~INSN_ARM_BE32;
>   #ifndef CONFIG_USER_ONLY


