Return-Path: <kvm+bounces-32857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DC009E0EF7
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 23:37:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F368C28338F
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 22:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4241DF98C;
	Mon,  2 Dec 2024 22:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="J4LbFVo+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258AC1DDC29
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 22:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733179061; cv=none; b=d6uzcoMNyTdlnUvyBaXoBT7GG2gEd3AwG8wR3HzHe0BRWKogiKZlUS0oXeJklx69TSh0BJ0d4sUtUbum9rXhzfnEpwWFY9NXVEFfH5Lvk2cdl6aNPxWT4r/vu7mmFoJla+cCTv5CwMdks6CohokNhPdhPAiWAgg8i6spAs+EAIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733179061; c=relaxed/simple;
	bh=/hF7KILTyziyFP++Iik8VVjKhXLy5rq4mvxg4BbxrxA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=URHvmfdgLSgJiFHLBnEhqj8wiQXe0Jy7NUp/Xi1wOc4z3M2A1p+OrCt2Z3kcNVazwRnhr9o1QZyY4W9CsnDsJYUVufcDuJHozgGlkQZ4cDdJb7u9HvrGOX5nU6O8CsyxQ25HnPvE9Powk1JT0B3a2C6wJZW3tmD81wLWKkFnPoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=J4LbFVo+; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3a77562332aso17377895ab.3
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 14:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1733179059; x=1733783859; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PMzTzllEKVWPpxhY4qjTST2+tDlHfK8mSjvLBCDTSBA=;
        b=J4LbFVo+wTDIZFR23o/sUdKsspX80Uz2ajjn3WD0XwKMM93edIiHoxNjUV1KnUaSlK
         ivjTUtYk+iEG5M83+79KGxaj/lZKixdLZDTPXV91WISishJuFMXcd1/lsZLD+6Ps8ydt
         N1t2V/+C1mdhz2/X4ziPKD0YeIuyt+Tg+uh7hL9BXwoFcdHxFgjeXnTXjSv7PFC3IZKf
         /ufNRAL0PxKpP891+0Nq4nLfWnl2n8B8L1fZvstu31tXZHg/cQaYnfxTkP+UbXD8Pa07
         HuzYmE6V5r/LgUEzygAVwzRsef/R8Gp+fIIOYsLzkl1GWeRZVvN/jddd+bMK/1dU7Qc3
         uvvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733179059; x=1733783859;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PMzTzllEKVWPpxhY4qjTST2+tDlHfK8mSjvLBCDTSBA=;
        b=w+TV7nALkZorbrBs2r/I9q81nBkbZc9FJdreLuuXtAniZnj8o9LdxowNIkK6aH03sc
         KdZzw13fPSPflT3Eh5UVkcQ56ULxl0GKEFhYvoAeDIjDaywOdjW0NBqte//DufWB4+Ta
         7v4sHA3pWr5Mvq2i+Tb5Yxl0hzSCTu2DNM0042G+1+GU+qFmXLF1S8nNlrdXWJULL93F
         lv9qdDta6oMnN/2ftl7jJ8qzuRUSFGS/6DEvi9Lp8cEbj4erT59KRBgCqkg8m1u+qjQ9
         BzyWd8bisp0Inb7glINPsbbt537wcryXIRCM8Qrru49m/UnuINSeFXm9uStk6Dsr3kMP
         hIwA==
X-Forwarded-Encrypted: i=1; AJvYcCXyIVc4BmM70bhtsQXeFMSgWgJ/awk29tDm4ZdUl8Np1B0qEbTNwMXP2DrpSASBgu2zPKE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuB3KwYbZjZZTGEvdbPD8f+z0z4hnDxXMTcW3oSdf/TdqgKBEZ
	xv7r1tgo7BXk1PKZd/AwaJ6Urx0SAXg1Dbvc5am9NvIbsiQXgkLx+ARLKq6tMDM=
X-Gm-Gg: ASbGnct+xIgvs9KUnqihIzPQ+bwEMcicv8KFGsuCoUQ0gqyyvUTxNwscAsUedoz7y2d
	G0PxNxft3mR6ZUENlUWzpC7vBMIGp3irNrAQJwQ9sPj7+cbB4rwzO2KDU/VBBQNuekJ6+ZXwjJ9
	Eh/xCRwX4AG80LT7oP6cgUhNeiJZYv/Bdz/wXQOFkl/WN5n7/CYIAA4Emvkv0Kl2KjgxnWtLprW
	cOAiBnidZHfbDrR6VxEcnLs4Tlph1+AYkx6BTa4TmR5wumkRzLCOE8THvWZD4p9e4hNpTxtul0=
X-Google-Smtp-Source: AGHT+IHn6Lx4GjIuR+MSzoOaterYaBTQwRP1DNSP58qngN6mgKfAI1QR+jafEOWkEaXAab45plCQgQ==
X-Received: by 2002:a05:6e02:1a03:b0:3a7:e286:a56b with SMTP id e9e14a558f8ab-3a7f9a2fad6mr2575485ab.5.1733179059220;
        Mon, 02 Dec 2024 14:37:39 -0800 (PST)
Received: from [100.64.0.1] ([147.124.94.167])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a7ccc0dde5sm24963835ab.43.2024.12.02.14.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2024 14:37:38 -0800 (PST)
Message-ID: <e124c532-7a08-4788-843d-345827e35f5f@sifive.com>
Date: Mon, 2 Dec 2024 16:37:36 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] drivers/perf: riscv: Add raw event v2 support
To: Atish Patra <atishp@rivosinc.com>, Anup Patel <anup@brainfault.org>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
 <20241119-pmu_event_info-v1-3-a4f9691421f8@rivosinc.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <20241119-pmu_event_info-v1-3-a4f9691421f8@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Atish,

On 2024-11-19 2:29 PM, Atish Patra wrote:
> SBI v3.0 introduced a new raw event type that allows wider
> mhpmeventX width to be programmed via CFG_MATCH.
> 
> Use the raw event v2 if SBI v3.0 is available.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/sbi.h |  4 ++++
>  drivers/perf/riscv_pmu_sbi.c | 18 ++++++++++++------
>  2 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 9be38b05f4ad..3ee9bfa5e77c 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -159,7 +159,10 @@ struct riscv_pmu_snapshot_data {
>  
>  #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
>  #define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
> +/* SBI v3.0 allows extended hpmeventX width value */
> +#define RISCV_PMU_RAW_EVENT_V2_MASK GENMASK_ULL(55, 0)
>  #define RISCV_PMU_RAW_EVENT_IDX 0x20000
> +#define RISCV_PMU_RAW_EVENT_V2_IDX 0x30000
>  #define RISCV_PLAT_FW_EVENT	0xFFFF
>  
>  /** General pmu event codes specified in SBI PMU extension */
> @@ -217,6 +220,7 @@ enum sbi_pmu_event_type {
>  	SBI_PMU_EVENT_TYPE_HW = 0x0,
>  	SBI_PMU_EVENT_TYPE_CACHE = 0x1,
>  	SBI_PMU_EVENT_TYPE_RAW = 0x2,
> +	SBI_PMU_EVENT_TYPE_RAW_V2 = 0x3,
>  	SBI_PMU_EVENT_TYPE_FW = 0xf,
>  };
>  
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 50cbdbf66bb7..f0e845ff6b79 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -59,7 +59,7 @@ asm volatile(ALTERNATIVE(						\
>  #define PERF_EVENT_FLAG_USER_ACCESS	BIT(SYSCTL_USER_ACCESS)
>  #define PERF_EVENT_FLAG_LEGACY		BIT(SYSCTL_LEGACY)
>  
> -PMU_FORMAT_ATTR(event, "config:0-47");
> +PMU_FORMAT_ATTR(event, "config:0-55");
>  PMU_FORMAT_ATTR(firmware, "config:62-63");
>  
>  static bool sbi_v2_available;
> @@ -527,18 +527,24 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
>  		break;
>  	case PERF_TYPE_RAW:
>  		/*
> -		 * As per SBI specification, the upper 16 bits must be unused
> -		 * for a hardware raw event.
> +		 * As per SBI v0.3 specification,
> +		 *  -- the upper 16 bits must be unused for a hardware raw event.
> +		 * As per SBI v3.0 specification,
> +		 *  -- the upper 8 bits must be unused for a hardware raw event.
>  		 * Bits 63:62 are used to distinguish between raw events
>  		 * 00 - Hardware raw event
>  		 * 10 - SBI firmware events
>  		 * 11 - Risc-V platform specific firmware event
>  		 */
> -
>  		switch (config >> 62) {
>  		case 0:
> -			ret = RISCV_PMU_RAW_EVENT_IDX;
> -			*econfig = config & RISCV_PMU_RAW_EVENT_MASK;
> +			if (sbi_v3_available) {
> +				*econfig = config & RISCV_PMU_RAW_EVENT_V2_MASK;
> +				ret = RISCV_PMU_RAW_EVENT_V2_IDX;
> +			} else {
> +				*econfig = config & RISCV_PMU_RAW_EVENT_MASK;
> +				ret = RISCV_PMU_RAW_EVENT_IDX;

Shouldn't we check to see if any of bits 48-55 are set and return an error,
instead of silently requesting the wrong event?

Regards,
Samuel

> +			}
>  			break;
>  		case 2:
>  			ret = (config & 0xFFFF) | (SBI_PMU_EVENT_TYPE_FW << 16);
> 


