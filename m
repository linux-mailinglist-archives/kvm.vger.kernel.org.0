Return-Path: <kvm+bounces-10724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0EDC86F017
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 11:52:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 362C22842F7
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 10:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079B1107B4;
	Sat,  2 Mar 2024 10:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LJp/2Ft2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572F1BA42
	for <kvm@vger.kernel.org>; Sat,  2 Mar 2024 10:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709376727; cv=none; b=Txm1yV894lf2+ILb4KxaYHPLDWGsO6YF1FOZzgSv7oYdO8eWc5cUfZdMdSDrmbTKaAJm8DyLBTGE06/B2xmiDwiUCv0WO8xOoHC1ZMHQnlGTRIzYFu14pvrMttsi4ieNDhZxKYSNLl3dv8dc1I7nuRQiyCkqrj0rzx2m352WUQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709376727; c=relaxed/simple;
	bh=XBSHM22vHMNsyJdf8IF+rdpTefstfNWgsuzTwp/4C0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q05hjYdFnRXS37SE3p25dU9CceaskrMsHcg4LKOMYL04zo+rzYRKBr/r3sdUg2/4eCnu045TGL/tem01f8uCgKVeYQHyp98CXgFXGG3yQxF14cvEJnHiwCYgqT7otraGNlMGrz7eEe6oMyxt3gFEcIhDk1BhubEBcQ04ZX1RJIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=LJp/2Ft2; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5658082d2c4so4326052a12.1
        for <kvm@vger.kernel.org>; Sat, 02 Mar 2024 02:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709376724; x=1709981524; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9EpHJ3vXoVYx3z3WiPBm0nq7L3LHn09T6f5KhziK9jw=;
        b=LJp/2Ft2wrjc6pY7V8n0DwCDVqTBg6ZL5hln7mvzDB/xNaSBFO3xtmqvdyPlyY2B1X
         CZk0UhIL4BaCpILz1PGdsFC4Uogn0LwDaLnED5uy2qsft0tlMNwmoeb+Edy82kGORv3A
         exx9Hc/Aqz6sIqXyxc+zqAaPZY1KSjqZzjOaSUkzvrm7BSWLtTSHYshY2MDGtxjZv8/s
         n1SOr/PEzH1WIPkKa2SBIeh3Gkz4CtiUF1qPRll+t40nYYC5M5tJYU2JhSxR+cJwhSTz
         ueBLuFyRy2tZcWKd+6GD66g6DnegorWnrDw/N6AN1dhuP3/HdYmDASwtOFweRv2MrtGm
         pDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709376724; x=1709981524;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9EpHJ3vXoVYx3z3WiPBm0nq7L3LHn09T6f5KhziK9jw=;
        b=wZJqFvJSE/5iJhQ2enMv1I+5Wi13cCLK8r+MWyzT0iIA88lpA6R/DVbFu59UgrprUw
         Ewx5pX193UmYKuDkhvdvMZl/ZJI1QZC5xZQOzaG3zdSW8Zh0/R1ZjIZrSBpUF01lIURM
         2iOjzGhywPZyPmPQCNpbd5dmjR7ZwWMlIV1qehQJATerwbr0UYFLzVpZS4Of8p5IzpRD
         88c9sebKsFVpzHdHxyu21xDTjU1yo53V4C6svI/lNcpH48G+QsBLUJPpdOqu4xrPO8AX
         D5K3unoNDtNdxtsXn0udl7S1sI4qQgVM3YnQ6lRX5ljGtXKLXfCjkdzbKGmmyaqeANNN
         89mg==
X-Forwarded-Encrypted: i=1; AJvYcCVTBPr9Wtewu3D1LbbBQ5WgXOukhdlp+avIDgah2jszSQr19UNO37wUdVz/L3ipeacjpuICdOoQv3k4lZRWUhXSJRbM
X-Gm-Message-State: AOJu0YzUJg7KdWGTYlLO1luP6Iy3JwplfStRAdFcARX7HeupCPt58Vda
	0ONuhIfjm8yBu43laxxDd/aOF3KZaFCPPJGZJ852Z6EsqVMGiagDJXHfOTTKCgI=
X-Google-Smtp-Source: AGHT+IHCev5tUtcI53kDoYHkl5lWdh3t/37ee1Ru+I9oZgloBvL0ICNc3Zq0ypsxSf+vVr5Y6SFE0Q==
X-Received: by 2002:a17:906:e211:b0:a3e:3a1d:f4b5 with SMTP id gf17-20020a170906e21100b00a3e3a1df4b5mr3140237ejb.65.1709376723783;
        Sat, 02 Mar 2024 02:52:03 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id h17-20020a1709063c1100b00a42da3b6518sm2609577ejg.18.2024.03.02.02.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Mar 2024 02:52:03 -0800 (PST)
Date: Sat, 2 Mar 2024 11:52:02 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Guo Ren <guoren@kernel.org>, Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 10/15] RISC-V: KVM: Support 64 bit firmware counters
 on RV32
Message-ID: <20240302-7679c8f67984ccae734926ba@orel>
References: <20240229010130.1380926-1-atishp@rivosinc.com>
 <20240229010130.1380926-11-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229010130.1380926-11-atishp@rivosinc.com>

On Wed, Feb 28, 2024 at 05:01:25PM -0800, Atish Patra wrote:
> The SBI v2.0 introduced a fw_read_hi function to read 64 bit firmware
> counters for RV32 based systems.
> 
> Add infrastructure to support that.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  4 ++-
>  arch/riscv/kvm/vcpu_pmu.c             | 37 ++++++++++++++++++++++++++-
>  arch/riscv/kvm/vcpu_sbi_pmu.c         |  6 +++++
>  3 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> index 8cb21a4f862c..e0ad27dea46c 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -20,7 +20,7 @@ static_assert(RISCV_KVM_MAX_COUNTERS <= 64);
>  
>  struct kvm_fw_event {
>  	/* Current value of the event */
> -	unsigned long value;
> +	u64 value;
>  
>  	/* Event monitoring status */
>  	bool started;
> @@ -91,6 +91,8 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  				     struct kvm_vcpu_sbi_return *retdata);
>  int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>  				struct kvm_vcpu_sbi_return *retdata);
> +int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
> +				      struct kvm_vcpu_sbi_return *retdata);
>  void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
>  int kvm_riscv_vcpu_pmu_setup_snapshot(struct kvm_vcpu *vcpu, unsigned long saddr_low,
>  				      unsigned long saddr_high, unsigned long flags,
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index a02f7b981005..469bb430cf97 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -196,6 +196,29 @@ static int pmu_get_pmc_index(struct kvm_pmu *pmu, unsigned long eidx,
>  	return kvm_pmu_get_programmable_pmc_index(pmu, eidx, cbase, cmask);
>  }
>  
> +static int pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
> +			      unsigned long *out_val)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc;
> +	int fevent_code;
> +
> +	if (!IS_ENABLED(CONFIG_32BIT))

Let's remove the CONFIG_32BIT check in kvm_sbi_ext_pmu_handler() and then
set *out_val to zero here and return success. Either that, or we should
WARN or something here since it's a KVM bug to get here with
!CONFIG_32BIT.

> +		return -EINVAL;
> +
> +	pmc = &kvpmu->pmc[cidx];

Uh oh! We're missing range validation of cidx! And I see we're missing it
in pmu_ctr_read() too. We need the same check we have in
kvm_riscv_vcpu_pmu_ctr_info(). I think the other SBI functions are OK,
but it's worth a triple check.

> +
> +	if (pmc->cinfo.type != SBI_PMU_CTR_TYPE_FW)
> +		return -EINVAL;
> +
> +	fevent_code = get_event_code(pmc->event_idx);
> +	pmc->counter_val = kvpmu->fw_event[fevent_code].value;
> +
> +	*out_val = pmc->counter_val >> 32;
> +
> +	return 0;
> +}
> +
>  static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>  			unsigned long *out_val)
>  {
> @@ -702,6 +725,18 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  	return 0;
>  }
>  
> +int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
> +				      struct kvm_vcpu_sbi_return *retdata)
> +{
> +	int ret;
> +
> +	ret = pmu_fw_ctr_read_hi(vcpu, cidx, &retdata->out_val);
> +	if (ret == -EINVAL)
> +		retdata->err_val = SBI_ERR_INVALID_PARAM;
> +
> +	return 0;

I see this follows the pattern we have with kvm_riscv_vcpu_pmu_ctr_read
and pmu_ctr_read, but I wonder if we really need the
kvm_riscv_vcpu_pmu_ctr_read() and kvm_riscv_vcpu_pmu_fw_ctr_read_hi()
wrapper functions?

> +}
> +
>  int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>  				struct kvm_vcpu_sbi_return *retdata)
>  {
> @@ -775,7 +810,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>  			pmc->cinfo.csr = CSR_CYCLE + i;
>  		} else {
>  			pmc->cinfo.type = SBI_PMU_CTR_TYPE_FW;
> -			pmc->cinfo.width = BITS_PER_LONG - 1;
> +			pmc->cinfo.width = 63;
>  		}
>  	}
>  
> diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
> index 9f61136e4bb1..58a0e5587e2a 100644
> --- a/arch/riscv/kvm/vcpu_sbi_pmu.c
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -64,6 +64,12 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	case SBI_EXT_PMU_COUNTER_FW_READ:
>  		ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata);
>  		break;
> +	case SBI_EXT_PMU_COUNTER_FW_READ_HI:
> +		if (IS_ENABLED(CONFIG_32BIT))
> +			ret = kvm_riscv_vcpu_pmu_fw_ctr_read_hi(vcpu, cp->a0, retdata);
> +		else
> +			retdata->out_val = 0;
> +		break;
>  	case SBI_EXT_PMU_SNAPSHOT_SET_SHMEM:
>  		ret = kvm_riscv_vcpu_pmu_setup_snapshot(vcpu, cp->a0, cp->a1, cp->a2, retdata);
>  		break;
> -- 
> 2.34.1
> 

Thanks,
drew

