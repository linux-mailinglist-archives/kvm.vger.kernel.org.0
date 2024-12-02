Return-Path: <kvm+bounces-32859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1EA39E0F33
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 00:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B7D9B23E76
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 23:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717B81DFD9F;
	Mon,  2 Dec 2024 23:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="K0CPNamH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55DA1DEFC2
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 23:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733180564; cv=none; b=o1/pCG3WWD14Yl9XOz4Bxt3vTww9zKTdChPypGVifAskEyECjQM16k4vmHE8iBCUZy5C0UZQQjxH/g3fXgY0pf6dw8pQgTWyZscquiwDy6SNeOo/W9N7x66OtZ4XfzmcQKfqv4TIaxvVT2dZcLfyTr2Hmy0nRRg53ct+IOLAQ8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733180564; c=relaxed/simple;
	bh=0o/VeYa0bbOGyirOVhNvZLZhLD1xrhRXWY07BbhU40M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e3qRw+NwmoBwVIhGqWaN0pu4nj4AyEV8jjJWvu1wmGvJSw9GnM6MjsVv8G+FosBIPDpz0Quei2/kDhbhNOYkdA6KkF3AZXUHCeTeeaL7Hpd7eyj0LVqE9flz6XJsZ04cRtp9njgbVd74yjfXY009FToaSVP4AY8U3UwtJb0esdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=K0CPNamH; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-71d4ba17cd2so2103514a34.3
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 15:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1733180562; x=1733785362; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TBGqkK/v5Iev96wXKEIFiXllPqz6RLCGsNpAQ8PdYPY=;
        b=K0CPNamHa88OinRjAImF3h9aCeN4UAivsslpkDJTMR7PMFApdxpXtdVlYejqi/wmK1
         Q3ifTFLhBpvYijEM/8RjmYNzTc1m66BtgvchUlvAje2k1QP72sB4fGZbSUUoQJQXkWQp
         ZflO4D/DsTH+x2+0dXylOFIoColdiQ63bsvifKcfDJqO36vriv5I1YGJWxOpOwT+1PTS
         yt2Az4k6s4PQOfJX6zMVEYg/VhMn5ufPE83zsdYI4PUL/ldXyC5yBHGJbnI3dh5qqFTB
         mdIQbBVsJa+m9ZQM8Lpq3cpiT8uiHN+UCWJ1cHVIDTeEo9F+QCk3RsSkOk5xErxXscNY
         P9Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733180562; x=1733785362;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TBGqkK/v5Iev96wXKEIFiXllPqz6RLCGsNpAQ8PdYPY=;
        b=DHNZwcAs00ckddGYlQge11PTL6DW8Ens5HJLke13mVkEWD/4+1BZz+4wdTXgeXGCZO
         1b6dCwJN1AyZlDV7RtrCKuMGXACt+tgzL4gFyDeW5oEmA3LhaYibzALDDZ8enGJOfwC6
         vVLl4vbwcfhGaUyid6BuhbXHMQGe5JjlMnPl7rpXNX5EjQGLshJvoujx5PLVCaFayVBR
         7l5d6a0GD4PEjpKpb1gCkkT3FXXsJ4FDGyjjhE9XBXeQvipl6CkvtolNcw65Pf7GCatJ
         W9DwHk6PzHMhrURDUQ8RvGZSxIvyQHRybF5lXpccyhctBRGLK9ob6eVAoDq7pA9VOjXG
         PoSg==
X-Forwarded-Encrypted: i=1; AJvYcCXsaai3KFCuGMjlO27c6Db9VcnSK2D8coDfv9HCV1J2wBHcax/frszHrQDLeIl6s/WEQD4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwROumtf2yKnnysNygS0/zR0cP8/+yV8hNb+pnRp6qz1wp9XcDE
	/NKRB8FGEAsnuJ/Y7fna3svlncacenwAy9ThLEWinDkZ34pFwbpZXBnfphN4Vn8=
X-Gm-Gg: ASbGncteGwpJRx10V1xE0AvvMfpRA6KawmRN50uAeBe0LBTawkPPBekQP1KpdP3saRo
	0vADEhor2I8V9F9klirEIBffj7TUHWeme5IQTfGWIaZPYLrKFRcMPtO0QGNOaXPFqRSyiPnmtew
	/bGNRmBlDIZeOkxL15lxlQCVXUcO7fhzn4g3CDl1Q+4ZhYB5bDk9OFQ8DmGVvlV0+AIkI7PUA3Y
	ovQMSfcmckrA/pqL81KtU2wZuUPbYnhAF5ZitW1xh/ljjwKP/LlQJH7CSygofW55ijtzfS4Lik=
X-Google-Smtp-Source: AGHT+IEv1JBbSaCa71BDRL05MtUtqi8CljIjDPjho0wurIfJyJM/U1viaWwUhmNhZ6XHgApvGm5kLA==
X-Received: by 2002:a05:6830:25d4:b0:710:fa7e:e002 with SMTP id 46e09a7af769-71dad6015c9mr537077a34.5.1733180561967;
        Mon, 02 Dec 2024 15:02:41 -0800 (PST)
Received: from [100.64.0.1] ([147.124.94.167])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e230de08f6sm2269346173.79.2024.12.02.15.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2024 15:02:41 -0800 (PST)
Message-ID: <8dc7e94c-4bf2-4367-8561-166bec6ec315@sifive.com>
Date: Mon, 2 Dec 2024 17:02:39 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] RISC-V: KVM: Implement get event info function
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Mayuresh Chitale <mchitale@ventanamicro.com>
References: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
 <20241119-pmu_event_info-v1-7-a4f9691421f8@rivosinc.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <20241119-pmu_event_info-v1-7-a4f9691421f8@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Atish,

On 2024-11-19 2:29 PM, Atish Patra wrote:
> The new get_event_info funciton allows the guest to query the presence
> of multiple events with single SBI call. Currently, the perf driver
> in linux guest invokes it for all the standard SBI PMU events. Support
> the SBI function implementation in KVM as well.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  3 ++
>  arch/riscv/kvm/vcpu_pmu.c             | 67 +++++++++++++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu_sbi_pmu.c         |  3 ++
>  3 files changed, 73 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> index 1d85b6617508..9a930afc8f57 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -98,6 +98,9 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
>  int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long saddr_low,
>  				      unsigned long saddr_high, unsigned long flags,
>  				      struct kvm_vcpu_sbi_return *retdata);
> +int kvm_riscv_vcpu_pmu_event_info(struct kvm_vcpu *vcpu, unsigned long saddr_low,
> +				  unsigned long saddr_high, unsigned long num_events,
> +				  unsigned long flags, struct kvm_vcpu_sbi_return *retdata);
>  void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index efd66835c2b8..a30f7ec31479 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -456,6 +456,73 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long s
>  	return 0;
>  }
>  
> +int kvm_riscv_vcpu_pmu_event_info(struct kvm_vcpu *vcpu, unsigned long saddr_low,
> +				  unsigned long saddr_high, unsigned long num_events,
> +				  unsigned long flags, struct kvm_vcpu_sbi_return *retdata)
> +{
> +	unsigned long hva;
> +	struct riscv_pmu_event_info *einfo;
> +	int shmem_size = num_events * sizeof(*einfo);
> +	bool writable;
> +	gpa_t shmem;
> +	u32 eidx, etype;
> +	u64 econfig;
> +	int ret;
> +
> +	if (flags != 0 || (saddr_low & (SZ_16 - 1))) {
> +		ret = SBI_ERR_INVALID_PARAM;
> +		goto out;
> +	}
> +
> +	shmem = saddr_low;
> +	if (saddr_high != 0) {
> +		if (IS_ENABLED(CONFIG_32BIT)) {
> +			shmem |= ((gpa_t)saddr_high << 32);
> +		} else {
> +			ret = SBI_ERR_INVALID_ADDRESS;
> +			goto out;
> +		}
> +	}
> +
> +	hva = kvm_vcpu_gfn_to_hva_prot(vcpu, shmem >> PAGE_SHIFT, &writable);
> +	if (kvm_is_error_hva(hva) || !writable) {
> +		ret = SBI_ERR_INVALID_ADDRESS;

This only checks the first page if the address crosses a page boundary. Maybe
that is okay since kvm_vcpu_read_guest()/kvm_vcpu_write_guest() will fail if a
later page is inaccessible?

> +		goto out;
> +	}
> +
> +	einfo = kzalloc(shmem_size, GFP_KERNEL);
> +	if (!einfo)
> +		return -ENOMEM;
> +
> +	ret = kvm_vcpu_read_guest(vcpu, shmem, einfo, shmem_size);
> +	if (ret) {
> +		ret = SBI_ERR_FAILURE;
> +		goto free_mem;
> +	}
> +
> +	for (int i = 0; i < num_events; i++) {
> +		eidx = einfo[i].event_idx;
> +		etype = kvm_pmu_get_perf_event_type(eidx);
> +		econfig = kvm_pmu_get_perf_event_config(eidx, einfo[i].event_data);
> +		ret = riscv_pmu_get_event_info(etype, econfig, NULL);
> +		if (ret > 0)
> +			einfo[i].output = 1;

This also needs to write `output` in the else case to indicate that the event is
not supported; the spec does not require the caller to initialize bit 0 of
output to zero.

Regards,
Samuel

> +	}
> +
> +	kvm_vcpu_write_guest(vcpu, shmem, einfo, shmem_size);
> +	if (ret) {
> +		ret = SBI_ERR_FAILURE;
> +		goto free_mem;
> +	}
> +
> +free_mem:
> +	kfree(einfo);
> +out:
> +	retdata->err_val = ret;
> +
> +	return 0;
> +}
> +
>  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu,
>  				struct kvm_vcpu_sbi_return *retdata)
>  {
> diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
> index e4be34e03e83..a020d979d179 100644
> --- a/arch/riscv/kvm/vcpu_sbi_pmu.c
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -73,6 +73,9 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	case SBI_EXT_PMU_SNAPSHOT_SET_SHMEM:
>  		ret = kvm_riscv_vcpu_pmu_snapshot_set_shmem(vcpu, cp->a0, cp->a1, cp->a2, retdata);
>  		break;
> +	case SBI_EXT_PMU_EVENT_GET_INFO:
> +		ret = kvm_riscv_vcpu_pmu_event_info(vcpu, cp->a0, cp->a1, cp->a2, cp->a3, retdata);
> +		break;
>  	default:
>  		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
>  	}
> 


