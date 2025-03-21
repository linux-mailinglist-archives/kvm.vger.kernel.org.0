Return-Path: <kvm+bounces-41683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10047A6C012
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A13951896C64
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96BE522D786;
	Fri, 21 Mar 2025 16:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BPj3YDfb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5563422B8B1
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 16:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742575012; cv=none; b=M8REdc6Vvea03f7wcU/lXK5xLWZ/vNRf14QEzA+axw0lwlCYfCIbiP9J8j1C51qZkc3s47YeRiE5GoYdgpJLKK1/zIed4Z328UDAPtS9GLCydUTmnz+IbUxJewra77dwCeIzjnEBi41kilvI5Xg+0sO61s+ckuQLJSpOuZZG9GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742575012; c=relaxed/simple;
	bh=zqVhMqAchexCMUj5MJs61/qfElAx/Ht8wd9skecPi3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GL57JmjpnUa2L3zVjRXV9vU8eqdQHOhqgv637kHdo2XLxKLbCQAufxzqCoHFbtRMVbWPZqy3qiujSzooysreyCCif1vkUe9i8RIZM4IvAOBIq8iRxMKHGej29OPbGGZKyc9+G5s27PDodU1wr1nWFPfsoBjxdccE9/NN+rSsRT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BPj3YDfb; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-224171d6826so11883215ad.3
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 09:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742575010; x=1743179810; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nyAxrcxJpaXDZ7GiFFU2INjbqCkqjtifUru6VAPSebo=;
        b=BPj3YDfbfLUTF32ePFd+HaxPQtIaMpr/kAIkT9pHI3Hu04+wdIkYZOP0CVp8QVR7m5
         Yenysd4qe6C9McqdkNTtDsSc8Vtq8azBfMUp87Q2BErcz5thW8rQHjIBN9Psjp4fy0fM
         T0al3lkeGk4wDuJN68/IINhcXeOC1MrzWcaG2/IqBrgzO85/I+h25fcadK/JCIyPNXMD
         C/BpWRl9cIa5nc1t2yj5bFZsnKvxTQJZ8HiBsnM1fMmIyKcwzrCjvfj2h6gOJAdOpZqg
         i6n70QxxxzAu7a+EyEtQpqJqiPESLNwFEtZDje/7gzVEPChG2LccqRXl6nal0UyMpWd6
         Kbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742575010; x=1743179810;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nyAxrcxJpaXDZ7GiFFU2INjbqCkqjtifUru6VAPSebo=;
        b=jxUW7L4inGt5xJhM4fhB7VNO6VVILtHn5FhGaMK6ijN8JbBXP8WImRWyPTGsAT+s9p
         6eUireX6CibIr9b/Rdckm542hNCYTs08XZXnZ9++Ba7DK9uHufroIF/dFltaLu/KWNB2
         xy17BOp9wFvfG9u/3/3r/rUX6CT+xnrNS9zAPTikTH0pRrsxSkE8tjk4wM62z05wzQFA
         QinCksaSw59HJTozJFUKpsZFyyR74iw3+ttp8/usGAfzlk/PqntNgwqHAcTOO+/E2vEA
         ryuA/CUxBIdTYJnDTBxjR566It+qh1uDPbfjoBOE8EFj0GuY1EWrlvheuQhx5j+APUAy
         YKCw==
X-Gm-Message-State: AOJu0YwPNCOQFqMkRkZJp6BCUc5bFlLK1/pUg9o2o1PtlAMqE/8/wtDW
	nFjiSHEF0Bcys4elkJSpfoWyTuWFNzrwEmEt1c0Ogo0ff1xIlmZFo1CUXQtP1ss=
X-Gm-Gg: ASbGnct3cu6f0oDcS2XkY71pt4e+OhvcNo3rL1mKlvYFjCV7OnQ/IIjuaiWbV90U5gJ
	tdB9iiKbTVQ8+WPEPi599XTSs6kNXqr3PsnJAlbMZcv3d6mKirwRTM3neb0/tH49DFz+U/E2qbe
	Fg2UXQlYZiriHturqwGGmh58bAVHGMuWT1XLpj+ly/hRM0/Y59/WSlrrzqDZ5NLtsekMUPIQiMv
	tpLu/irrZ0Z1Yr5xCHfTov5wzQKfA8TryOnvxxy2n1fKj8J1Tpkusxcprvymc85JklyMmdSpK7/
	vP5brvMdv3XrPGZA9fGiPHY8cMFwn0PW5tBD1gl0DZFJ+zktW6LpC29VE+ETLtwd8r1NHTU+I0Q
	SGKwnhqqx5XtJ2imYCgY=
X-Google-Smtp-Source: AGHT+IGRZBvkhTTMFTisosTyZ2ZOdK/frO3hQGPp0saPscrfsv066xw8DoRU1w1LWAfx91qFBAAnlg==
X-Received: by 2002:a17:902:d58b:b0:223:f9a4:3fb6 with SMTP id d9443c01a7336-22780c52283mr65790865ad.11.1742575010316;
        Fri, 21 Mar 2025 09:36:50 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811d9f0dsm19122885ad.165.2025.03.21.09.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 09:36:49 -0700 (PDT)
Message-ID: <6215e901-af91-4e3a-b8ea-dba9b36cd87c@linaro.org>
Date: Fri, 21 Mar 2025 09:36:48 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/30] exec/cpu-all: remove system/memory include
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-6-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-6-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> We include this header where needed. When includes set already have
> ifdef CONFIG_USER_ONLY, we add it here, else, we don't condition the
> include.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   hw/s390x/ipl.h                       | 1 +
>   include/exec/cpu-all.h               | 3 ---
>   target/arm/internals.h               | 1 +
>   target/hppa/cpu.h                    | 1 +
>   target/i386/hvf/vmx.h                | 1 +
>   target/ppc/mmu-hash32.h              | 2 ++
>   hw/ppc/spapr_ovec.c                  | 1 +
>   target/alpha/helper.c                | 1 +
>   target/arm/hvf/hvf.c                 | 1 +
>   target/avr/helper.c                  | 1 +
>   target/i386/arch_memory_mapping.c    | 1 +
>   target/i386/helper.c                 | 1 +
>   target/i386/tcg/system/misc_helper.c | 1 +
>   target/i386/tcg/system/tcg-cpu.c     | 1 +
>   target/m68k/helper.c                 | 1 +
>   target/ppc/excp_helper.c             | 1 +
>   target/ppc/mmu-book3s-v3.c           | 1 +
>   target/ppc/mmu-hash64.c              | 1 +
>   target/ppc/mmu-radix64.c             | 1 +
>   target/riscv/cpu_helper.c            | 1 +
>   target/sparc/ldst_helper.c           | 1 +
>   target/sparc/mmu_helper.c            | 1 +
>   target/xtensa/mmu_helper.c           | 1 +
>   target/xtensa/op_helper.c            | 1 +
>   24 files changed, 24 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

