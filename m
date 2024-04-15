Return-Path: <kvm+bounces-14647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A738A5135
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04BD01F21B54
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC261811E6;
	Mon, 15 Apr 2024 13:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="bugntPOs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ED271B4C
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 13:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713186918; cv=none; b=ImTpshFfTpeI7nr/lqUaKYmDZiWmi3uTUxCCf5pLMIxqDBnT8F6ouy5PmeI0frWKSmRQZQqNRlpJHK0FbUgXyyGjBdCkwmbzdz/std9g4VGKjAce0bm5RYQAcIO+IfU6h7xwq/uWSLpibVFQYURt45gC6B4B8lK2ATG+eNK35w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713186918; c=relaxed/simple;
	bh=wQu4AB/hrYeKhHh8iDIAICEBW2rABai55pnKGz7N32g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fDCxO35tbovxD6PkTS4cacoz76w96ZPINaENlBud3rnmA9lsOQLQY9TbBevxyT6RBrCezpxI3p0iJvv+nGc7FkwyimIRTN6SASAb5G3hBXjwLRitlHoA9fkIdzWR3lAGP8iYP0vcDFD0U/0Mj4DPaNt+srReNNYPt72KGmi7ATk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=bugntPOs; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-418671bac0aso3703215e9.1
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 06:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1713186915; x=1713791715; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hkfoH6pgevkYBCq40yfYP4WU2j0tmJHdJg6k4nyDGog=;
        b=bugntPOs3rv2UwUzmx/l888+vpjQne88H7KkS8WdzDyU9Xz01g9lbsJjAv3Xz15xn8
         t2FHCF3kVWnt09c3fwuWVj4YOy+7Tu97aD1hEXjELph0cWVitK0G/n4vcS4C1QE/6CmC
         YRzOs5GyZTVASd/30iUwpy7KV22eHuKQ/kLpWwA7O3pQszI+7iM1HvX+Z71LNsqnbbsP
         2x3vPrC7eko0j4/n7PK7Mfc95qepsb817Mv0yzD0sN683CxnSco7YWMk9PAv3KdhTIlS
         9hV2M87IoBPa8wa/SW2S9M/a9iK0zeiE/7oxm0JGrseTuRxX/qDt7vdfKW+kUSKaNi4T
         z4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713186915; x=1713791715;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hkfoH6pgevkYBCq40yfYP4WU2j0tmJHdJg6k4nyDGog=;
        b=EGc+zQtmybw2Zt6WMOf2+o3bexotvX4L5DippkvQWREx3LxqWfaC3CTi1ufEN2c04G
         79GGs81X+KvDMdRBjcQXLssu0YZUrCYE2uLIwHtKdxuDrfxDNvGmdmhvhnWCOvVsJtYG
         PJD0r3dQotoWkEI0u7DozZc7augC/mtEIhVD2w5V69T08ekXRfoDtNyr2R+Cb9LSYIP2
         kmahcqBP2Jl2i9Z5xLAS971zeIU3GUlpPrC0txJbl5K2RVuN2V3oiPUpkcnhIA9+wiNh
         v2kOgjmaspiHOccOxnSKccNzNLiwRe/dA1oX7jinY9dUE8Funq5hFRLJxIeuMeVL3/Ul
         4xpw==
X-Forwarded-Encrypted: i=1; AJvYcCVC5qkC1G9StoM8KchKle+xzcBm9BVFNiZl+xjebTDUAEbEV99TnOx4PbJQHz0NnhLv5Pr5hBptaSbvqFJW4+S3YzcL
X-Gm-Message-State: AOJu0Yz7HExtVdGrKdN/oqtQnqnzFUq/aFo+5i/f2crSwu9Bg88fKBQr
	zUfZ9Dc9gUpXEgs9QsU5924osZhHlSQuW/rT03FUdlz+QrY2MgH9MjJkVv7ujyw=
X-Google-Smtp-Source: AGHT+IHaN+91KLEi7R/RxmtZuQH0jSX9Ui8qFAfF8HKSuojq26EX0a+2rvsHFXS88Kq+hml8I98gaQ==
X-Received: by 2002:a05:600c:4f4e:b0:418:2394:c60e with SMTP id m14-20020a05600c4f4e00b004182394c60emr3981791wmq.24.1713186914737;
        Mon, 15 Apr 2024 06:15:14 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id z15-20020adfe54f000000b00345c2f84d5asm12068662wrm.10.2024.04.15.06.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 06:15:14 -0700 (PDT)
Date: Mon, 15 Apr 2024 15:15:13 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
	Anup Patel <anup@brainfault.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Alexey Makhalov <alexey.amakhalov@broadcom.com>, 
	Atish Patra <atishp@atishpatra.org>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Juergen Gross <jgross@suse.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, 
	x86@kernel.org
Subject: Re: [PATCH v6 08/24] drivers/perf: riscv: Implement SBI PMU snapshot
 function
Message-ID: <20240415-1654deb9446d6c0ebb858b30@orel>
References: <20240411000752.955910-1-atishp@rivosinc.com>
 <20240411000752.955910-9-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411000752.955910-9-atishp@rivosinc.com>

On Wed, Apr 10, 2024 at 05:07:36PM -0700, Atish Patra wrote:
> SBI v2.0 SBI introduced PMU snapshot feature which adds the following
> features.
> 
> 1. Read counter values directly from the shared memory instead of
> csr read.
> 2. Start multiple counters with initial values with one SBI call.
> 
> These functionalities optimizes the number of traps to the higher
> privilege mode. If the kernel is in VS mode while the hypervisor
> deploy trap & emulate method, this would minimize all the hpmcounter
> CSR read traps. If the kernel is running in S-mode, the benefits
> reduced to CSR latency vs DRAM/cache latency as there is no trap
> involved while accessing the hpmcounter CSRs.
> 
> In both modes, it does saves the number of ecalls while starting
> multiple counter together with an initial values. This is a likely
> scenario if multiple counters overflow at the same time.
> 
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/perf/riscv_pmu.c       |   1 +
>  drivers/perf/riscv_pmu_sbi.c   | 224 +++++++++++++++++++++++++++++++--
>  include/linux/perf/riscv_pmu.h |   6 +
>  3 files changed, 219 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/perf/riscv_pmu.c b/drivers/perf/riscv_pmu.c
> index b4efdddb2ad9..36d348753d05 100644
> --- a/drivers/perf/riscv_pmu.c
> +++ b/drivers/perf/riscv_pmu.c
> @@ -408,6 +408,7 @@ struct riscv_pmu *riscv_pmu_alloc(void)
>  		cpuc->n_events = 0;
>  		for (i = 0; i < RISCV_MAX_COUNTERS; i++)
>  			cpuc->events[i] = NULL;
> +		cpuc->snapshot_addr = NULL;
>  	}
>  	pmu->pmu = (struct pmu) {
>  		.event_init	= riscv_pmu_event_init,
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index f23501898657..e2881415ca0a 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -58,6 +58,9 @@ PMU_FORMAT_ATTR(event, "config:0-47");
>  PMU_FORMAT_ATTR(firmware, "config:63");
>  
>  static bool sbi_v2_available;
> +static DEFINE_STATIC_KEY_FALSE(sbi_pmu_snapshot_available);
> +#define sbi_pmu_snapshot_available() \
> +	static_branch_unlikely(&sbi_pmu_snapshot_available)
>  
>  static struct attribute *riscv_arch_formats_attr[] = {
>  	&format_attr_event.attr,
> @@ -508,14 +511,109 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
>  	return ret;
>  }
>  
> +static void pmu_sbi_snapshot_free(struct riscv_pmu *pmu)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct cpu_hw_events *cpu_hw_evt = per_cpu_ptr(pmu->hw_events, cpu);
> +
> +		if (!cpu_hw_evt->snapshot_addr)
> +			continue;
> +
> +		free_page((unsigned long)cpu_hw_evt->snapshot_addr);
> +		cpu_hw_evt->snapshot_addr = NULL;
> +		cpu_hw_evt->snapshot_addr_phys = 0;
> +	}
> +}
> +
> +static int pmu_sbi_snapshot_alloc(struct riscv_pmu *pmu)
> +{
> +	int cpu;
> +	struct page *snapshot_page;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct cpu_hw_events *cpu_hw_evt = per_cpu_ptr(pmu->hw_events, cpu);
> +
> +		if (cpu_hw_evt->snapshot_addr)
> +			continue;
> +
> +		snapshot_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
> +		if (!snapshot_page) {
> +			pmu_sbi_snapshot_free(pmu);
> +			return -ENOMEM;
> +		}
> +		cpu_hw_evt->snapshot_addr = page_to_virt(snapshot_page);
> +		cpu_hw_evt->snapshot_addr_phys = page_to_phys(snapshot_page);
> +	}
> +
> +	return 0;
> +}
> +
> +static int pmu_sbi_snapshot_disable(void)
> +{
> +	struct sbiret ret;
> +
> +	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_SNAPSHOT_SET_SHMEM, -1,
> +			-1, 0, 0, 0, 0);

The SBI_SHMEM_DISABLE patch got moved in front of this patch, but looks
like it was forgotten to apply it.

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew

