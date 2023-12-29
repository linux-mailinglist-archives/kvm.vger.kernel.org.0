Return-Path: <kvm+bounces-5309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9BDD81FC67
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 02:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 335241F2486E
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 01:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81CF17EF;
	Fri, 29 Dec 2023 01:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="Gvju+amL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155F11382
	for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 01:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d45f182fa2so24253305ad.3
        for <kvm@vger.kernel.org>; Thu, 28 Dec 2023 17:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1703814289; x=1704419089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WNCVR8SMHnCHeEQ/yMeXXkUdP9Bs/RTaT2/RSyEx1Tc=;
        b=Gvju+amLK1SWDCzrmCohjbd3fDyjKYopcQjuln/p70su+MGV689NW/Lpjve1AfMgDZ
         3Lpnen4voluq9tu3z7SemfGVZeStKrnbWSeIZVNio72MJ0OSLTV7jkC1FB8O5ws9nxLw
         iNn/Btn1asPDoGzeDxgfy403w2VNqkd3x6KDAciEHFeJEwp2Tq9f5JDlerxNiyb/sltK
         l0jr7Jh4DMzQW6Vj25Sq1+neQRbbibTq5Ju77TwnUbYA4S5W2YfF+j4lkDfiQAFhkyhe
         ufVEqgB+gKjq411/BuEYAl7tPMT/m3eWffCqbHRTZ3Q+qvsrwHh4e/HKC1sP1LlR7BNf
         wERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703814289; x=1704419089;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WNCVR8SMHnCHeEQ/yMeXXkUdP9Bs/RTaT2/RSyEx1Tc=;
        b=J5Opy+PO0wd8snT1Wd1NZfNHq2d6gwKWU+62N4zTfcZprqcqp/0gHJKTu7n1/BKA8k
         BmExnPE5hVZ39NDNyw1ORAECsfFYiajMr+y46zfzNv0Ao0LF2bnpDm61Mm16ZwCzp2TH
         FcGXXEL4ukxZW2qmBG6leJZRJvnyzhJfh+Z92R6s//NovlrP7LHqtyIkv9q7XI5aQVHz
         YKkCLp037FHMg58OgPLcofVCcsZ9qvZiCPxzI7F957nfl6JlPf4VAYapj8l4EFHBEMfy
         3MBMxxYDAtzS3CHZ8k/C6Hr104ivXkaAVthffKJj4ojJoEL/0OHwF+Poy57k2TuaAXn4
         O7Bg==
X-Gm-Message-State: AOJu0YzjABHWP0GJUZfUBAh2whll8JYDnRSVLrwgroRWmW6q2H/xSxCu
	wJD64r68mNfQShNHMcpK7aXjAvd/TtQ1YA==
X-Google-Smtp-Source: AGHT+IHJ97SDIMc6/L9jYSipHJSv37tASQguwy1/ne3mvPNbcopocbR96EShTn3HW49dMkrd1Sk0UQ==
X-Received: by 2002:a17:902:f7ca:b0:1d3:f067:a3f0 with SMTP id h10-20020a170902f7ca00b001d3f067a3f0mr11108857plw.107.1703814289238;
        Thu, 28 Dec 2023 17:44:49 -0800 (PST)
Received: from localhost ([12.44.203.122])
        by smtp.gmail.com with ESMTPSA id pl18-20020a17090b269200b0028ae9a419f0sm19000570pjb.44.2023.12.28.17.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Dec 2023 17:44:48 -0800 (PST)
Date: Thu, 28 Dec 2023 17:44:48 -0800 (PST)
X-Google-Original-Date: Thu, 28 Dec 2023 17:44:25 PST (-0800)
Subject:     Re: [v1 03/10] drivers/perf: riscv: Read upper bits of a firmware counter
In-Reply-To: <20231218104107.2976925-4-atishp@rivosinc.com>
CC: linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>,
  aou@eecs.berkeley.edu, alexghiti@rivosinc.com, ajones@ventanamicro.com, anup@brainfault.org,
  atishp@atishpatra.org, Conor Dooley <conor.dooley@microchip.com>, guoren@kernel.org, uwu@icenowy.me,
  kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
  Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, Will Deacon <will@kernel.org>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: Atish Patra <atishp@rivosinc.com>
Message-ID: <mhng-94cdfcf4-01c1-493c-a23e-32bc8b391aad@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Mon, 18 Dec 2023 02:41:00 PST (-0800), Atish Patra wrote:
> SBI v2.0 introduced a explicit function to read the upper 32 bits
> for any firmwar counter width that is longer than 32bits.
> This is only applicable for RV32 where firmware counter can be
> 64 bit.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/perf/riscv_pmu_sbi.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 16acd4dcdb96..646604f8c0a5 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -35,6 +35,8 @@
>  PMU_FORMAT_ATTR(event, "config:0-47");
>  PMU_FORMAT_ATTR(firmware, "config:63");
>
> +static bool sbi_v2_available;
> +
>  static struct attribute *riscv_arch_formats_attr[] = {
>  	&format_attr_event.attr,
>  	&format_attr_firmware.attr,
> @@ -488,16 +490,23 @@ static u64 pmu_sbi_ctr_read(struct perf_event *event)
>  	struct hw_perf_event *hwc = &event->hw;
>  	int idx = hwc->idx;
>  	struct sbiret ret;
> -	union sbi_pmu_ctr_info info;
>  	u64 val = 0;
> +	union sbi_pmu_ctr_info info = pmu_ctr_list[idx];
>
>  	if (pmu_sbi_is_fw_event(event)) {
>  		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ,
>  				hwc->idx, 0, 0, 0, 0, 0);
> -		if (!ret.error)
> -			val = ret.value;
> +		if (ret.error)
> +			return val;
> +
> +		val = ret.value;
> +		if (IS_ENABLED(CONFIG_32BIT) && sbi_v2_available && info.width >= 32) {
> +			ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ_HI,
> +					hwc->idx, 0, 0, 0, 0, 0);
> +			if (!ret.error)
> +				val |= ((u64)ret.value << 32);
> +		}
>  	} else {
> -		info = pmu_ctr_list[idx];
>  		val = riscv_pmu_ctr_read_csr(info.csr);
>  		if (IS_ENABLED(CONFIG_32BIT))
>  			val = ((u64)riscv_pmu_ctr_read_csr(info.csr + 0x80)) << 31 | val;
> @@ -1108,6 +1117,9 @@ static int __init pmu_sbi_devinit(void)
>  		return 0;
>  	}
>
> +	if (sbi_spec_version >= sbi_mk_version(2, 0))
> +		sbi_v2_available = true;
> +
>  	ret = cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
>  				      "perf/riscv/pmu:starting",
>  				      pmu_sbi_starting_cpu, pmu_sbi_dying_cpu);

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>

