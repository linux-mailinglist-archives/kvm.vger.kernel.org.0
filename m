Return-Path: <kvm+bounces-32743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ECB29DB855
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 14:11:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12360B21C4D
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 13:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC911A2630;
	Thu, 28 Nov 2024 13:11:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BADE19EEB4;
	Thu, 28 Nov 2024 13:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732799459; cv=none; b=DKECRmwQVGuCGosZYOhQXVXN3VLdh7vkCPrj4pzxyy6yzuiT2uMmG7mZYwyhHYIFghqMgCq0vL7vZ6u8VZKxCUYrqe85riiuL+sYEho2cEUdof/0hvskDPfp/dbCo4oQyuHYD7jZ+z4RU5htBYnrlw6TKGKE+398B9giw22fGq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732799459; c=relaxed/simple;
	bh=9elU7BZr9bP1QgsHDVwfQ9JRpl3ecGTM3aErGIE8wFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hdSZ4t3IVjdS8ZGGf+5ndtWOgVSXNHpXz2babh7kayr4LYvXSuN+A6yUDO1TaMoxCfT/huy7Tn62ZHv2iFXHLug072PTCIUKa1ZkbwBj2P7y+r0rFiQ427TqiBvTvv0W6Mc1gO2UnTHTYxRmWqugKFFdLm7hXcL8qECQiNOynmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id B3B1E60003;
	Thu, 28 Nov 2024 13:10:53 +0000 (UTC)
Message-ID: <77b7b44f-e05a-4845-8d45-0e0d831bb8e7@ghiti.fr>
Date: Thu, 28 Nov 2024 14:10:53 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] drivers/perf: riscv: Fix Platform firmware event data
Content-Language: en-US
To: Atish Patra <atishp@rivosinc.com>, Anup Patel <anup@brainfault.org>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
 <20241119-pmu_event_info-v1-2-a4f9691421f8@rivosinc.com>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20241119-pmu_event_info-v1-2-a4f9691421f8@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr

Hi Atish,

On 19/11/2024 21:29, Atish Patra wrote:
> Platform firmware event data field is allowed to be 62 bits for
> Linux as uppper most two bits are reserved to indicate SBI fw or
> platform specific firmware events.
> However, the event data field is masked as per the hardware raw
> event mask which is not correct.
>
> Fix the platform firmware event data field with proper mask.
>
> Fixes: f0c9363db2dd ("perf/riscv-sbi: Add platform specific firmware event handling")
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>   arch/riscv/include/asm/sbi.h |  1 +
>   drivers/perf/riscv_pmu_sbi.c | 12 +++++-------
>   2 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 98f631b051db..9be38b05f4ad 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -158,6 +158,7 @@ struct riscv_pmu_snapshot_data {
>   };
>   
>   #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
> +#define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
>   #define RISCV_PMU_RAW_EVENT_IDX 0x20000
>   #define RISCV_PLAT_FW_EVENT	0xFFFF
>   
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index cb98efa9b106..50cbdbf66bb7 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -508,7 +508,6 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
>   {
>   	u32 type = event->attr.type;
>   	u64 config = event->attr.config;
> -	u64 raw_config_val;
>   	int ret;
>   
>   	/*
> @@ -529,21 +528,20 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
>   	case PERF_TYPE_RAW:
>   		/*
>   		 * As per SBI specification, the upper 16 bits must be unused
> -		 * for a raw event.
> +		 * for a hardware raw event.
>   		 * Bits 63:62 are used to distinguish between raw events
>   		 * 00 - Hardware raw event
>   		 * 10 - SBI firmware events
>   		 * 11 - Risc-V platform specific firmware event
>   		 */
> -		raw_config_val = config & RISCV_PMU_RAW_EVENT_MASK;
> +
>   		switch (config >> 62) {
>   		case 0:
>   			ret = RISCV_PMU_RAW_EVENT_IDX;
> -			*econfig = raw_config_val;
> +			*econfig = config & RISCV_PMU_RAW_EVENT_MASK;
>   			break;
>   		case 2:
> -			ret = (raw_config_val & 0xFFFF) |
> -				(SBI_PMU_EVENT_TYPE_FW << 16);
> +			ret = (config & 0xFFFF) | (SBI_PMU_EVENT_TYPE_FW << 16);
>   			break;
>   		case 3:
>   			/*
> @@ -552,7 +550,7 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
>   			 * Event data - raw event encoding
>   			 */
>   			ret = SBI_PMU_EVENT_TYPE_FW << 16 | RISCV_PLAT_FW_EVENT;
> -			*econfig = raw_config_val;
> +			*econfig = config & RISCV_PMU_PLAT_FW_EVENT_MASK;
>   			break;
>   		}
>   		break;
>

It seems independent from the other patches, so I guess we should take 
it for 6.13 rcX.

Let me know if that's not the case.

Thanks,

Alex


