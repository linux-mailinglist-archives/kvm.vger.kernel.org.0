Return-Path: <kvm+bounces-13698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3C4E899BCE
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 13:23:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A319283117
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB7816C68D;
	Fri,  5 Apr 2024 11:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="EBZIspQc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C7616C684
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 11:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712316191; cv=none; b=FjyRuHq4m0AqIRhTjnASub9ROaxfSsdH3Gz/b8xtA9Gi95DPs8vzQ7rF8Fn6nHYJnzbe0eK1hfk6/1KhcyqO6qxCnU5oAt+jC4EAtjYe7dhpPtKA5Mom9Bt39zZOnPsmHg8XVg2Isif1JYdCsNB17BdyILRqbR8LEB9TV13gKFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712316191; c=relaxed/simple;
	bh=oGJdt/19LKDTvxYgKTkWSed86buXn0F4UgK7eTA38I8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ngBzamyyGxr9CKWVhV2Yl4mpmjKZrwIaTfZ8HTX62ybF2fZZE0Il2RCzcjq5vkMZieKUIwfqL43LcChFVbkLRxIYeQmMwT/2ujXFEAtvzouBKxgRUSs5et2FxsaMyuNnUdOHndhdtSOidpbAwh4bxJVMbhN2B41JlTkTB6phV/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=EBZIspQc; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-516d3776334so919059e87.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 04:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712316187; x=1712920987; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1StIt3kBG1sKfWkM0jYTmYiHX1k739mPkjj6luO5sU=;
        b=EBZIspQcH6nRcs0FQNCSRQe0/PoQETZSI/qLyhbucOenbz71Bk3qbbmix75sSTdP0H
         Z7KhXg9SKo4ybM4MoQWN5aGUBbCBZaWo2joWBuRFxQ8xN4FNVPVTfEQUSyLeM1X5bPsW
         FwBCbRnCHZPORZnx9RK3YiTII2jTLYH9wYjnWUonjwWyAoAMaG8wrkTK99xtSrMgma/o
         0zEkUW8pPR96nNvp4X/JZHfUY2Rp47NA5xemWKQ6qjJ1ORzcAKy+etLpj7uvmD5pgkma
         277WHnJlDMWMO4384HnJmUEDJwo56pYnJ8iXdd6I5dsl/Tz5ez/nhpNCnAYI3rWEQPvw
         YgOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712316187; x=1712920987;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q1StIt3kBG1sKfWkM0jYTmYiHX1k739mPkjj6luO5sU=;
        b=b2+a5IHPoNz2LZKsJ5v93MLE9BJApnrN4HLuRW6ZaYcN29gg9wSOCcvwqhZT+yr2mu
         xRh7ASFFqvIQS8gYlRPRf1RSDjqlQSiEtql5W4xJ0/rcbgSG2ZhoUsnmUC5gvIaFCgh6
         gmea3bLa1eXylKYdjA+HqxsNl/IHhm0ByKD17+4maaoEOJClSTVx5iRhibzgCRVhlQ+l
         uk0lteIKO3Q9RAYG3jcsF7ETKrD/QVFLhylgYl+Zie9MZvGZ6SdlF+fKLPtX/tsxpBPm
         nfkbc9AawXnDJPjhVoEo0rrTuwVX1HH7Fkdz2MaYmOFLippjzipyN1ltRvqlJb8lcIG1
         lXww==
X-Forwarded-Encrypted: i=1; AJvYcCVV5zqe1oa1BTIyYGLcrxeMPypEuVNLVLwJ05Nng1cPKKU/djlgIyqz0q1qKL72XM9tc0WCWkjWS3r24tElfYEQghI8
X-Gm-Message-State: AOJu0YxMW4RZOyafyJFVJp9QuZV7yME7o2pNmslfd2nCvf0mMAVnCFxR
	m3/tkwa0NgAKaC3z8BKvgt9Ot2JqyJkB7mDm0VAbM1k38rznOOg0urYcMYogRJc=
X-Google-Smtp-Source: AGHT+IHkj15u2Bxl0RbCYsvSnoaNnRvyO2MnsCgl4V2xQvxUMx8unnpUY36pEW96b3ybfXEcZnPVSw==
X-Received: by 2002:a19:f604:0:b0:516:d152:b892 with SMTP id x4-20020a19f604000000b00516d152b892mr952297lfe.60.1712316186941;
        Fri, 05 Apr 2024 04:23:06 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id j13-20020a50ed0d000000b0056c4372c161sm686856eds.55.2024.04.05.04.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 04:23:06 -0700 (PDT)
Date: Fri, 5 Apr 2024 13:23:04 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Ajay Kaher <akaher@vmware.com>, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Alexey Makhalov <amakhalov@vmware.com>, Conor Dooley <conor.dooley@microchip.com>, 
	Juergen Gross <jgross@suse.com>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, virtualization@lists.linux.dev, 
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>, Will Deacon <will@kernel.org>, x86@kernel.org
Subject: Re: [PATCH v5 12/22] RISC-V: KVM: Implement SBI PMU Snapshot feature
Message-ID: <20240405-1060c986299eaac3528c7d4f@orel>
References: <20240403080452.1007601-1-atishp@rivosinc.com>
 <20240403080452.1007601-13-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403080452.1007601-13-atishp@rivosinc.com>

On Wed, Apr 03, 2024 at 01:04:41AM -0700, Atish Patra wrote:
> PMU Snapshot function allows to minimize the number of traps when the
> guest access configures/access the hpmcounters. If the snapshot feature
> is enabled, the hypervisor updates the shared memory with counter
> data and state of overflown counters. The guest can just read the
> shared memory instead of trap & emulate done by the hypervisor.
> 
> This patch doesn't implement the counter overflow yet.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |   7 ++
>  arch/riscv/kvm/vcpu_pmu.c             | 121 +++++++++++++++++++++++++-
>  arch/riscv/kvm/vcpu_sbi_pmu.c         |   3 +
>  3 files changed, 130 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> index 395518a1664e..77a1fc4d203d 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -50,6 +50,10 @@ struct kvm_pmu {
>  	bool init_done;
>  	/* Bit map of all the virtual counter used */
>  	DECLARE_BITMAP(pmc_in_use, RISCV_KVM_MAX_COUNTERS);
> +	/* The address of the counter snapshot area (guest physical address) */
> +	gpa_t snapshot_addr;
> +	/* The actual data of the snapshot */
> +	struct riscv_pmu_snapshot_data *sdata;
>  };
>  
>  #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu_context)
> @@ -85,6 +89,9 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>  				struct kvm_vcpu_sbi_return *retdata);
>  void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
> +int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long saddr_low,
> +				      unsigned long saddr_high, unsigned long flags,
> +				      struct kvm_vcpu_sbi_return *retdata);
>  void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 2d9929bbc2c8..f706c688b338 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -14,6 +14,7 @@
>  #include <asm/csr.h>
>  #include <asm/kvm_vcpu_sbi.h>
>  #include <asm/kvm_vcpu_pmu.h>
> +#include <asm/sbi.h>
>  #include <linux/bitops.h>
>  
>  #define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
> @@ -311,6 +312,80 @@ int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
>  	return ret;
>  }
>  
> +static void kvm_pmu_clear_snapshot_area(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	int snapshot_area_size = sizeof(struct riscv_pmu_snapshot_data);
> +
> +	if (kvpmu->sdata) {
> +		if (kvpmu->snapshot_addr != INVALID_GPA) {
> +			memset(kvpmu->sdata, 0, snapshot_area_size);
> +			kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr,
> +					     kvpmu->sdata, snapshot_area_size);
> +		} else {
> +			pr_warn("snapshot address invalid\n");
> +		}
> +		kfree(kvpmu->sdata);
> +		kvpmu->sdata = NULL;
> +	}
> +	kvpmu->snapshot_addr = INVALID_GPA;
> +}
> +
> +int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long saddr_low,
> +				      unsigned long saddr_high, unsigned long flags,
> +				      struct kvm_vcpu_sbi_return *retdata)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	int snapshot_area_size = sizeof(struct riscv_pmu_snapshot_data);
> +	int sbiret = 0;
> +	gpa_t saddr;
> +	unsigned long hva;
> +	bool writable;
> +
> +	if (!kvpmu || flags) {
> +		sbiret = SBI_ERR_INVALID_PARAM;
> +		goto out;
> +	}
> +
> +	if (saddr_low == SBI_SHMEM_DISABLE && saddr_high == SBI_SHMEM_DISABLE) {
> +		kvm_pmu_clear_snapshot_area(vcpu);
> +		return 0;
> +	}
> +
> +	saddr = saddr_low;
> +
> +	if (saddr_high != 0) {
> +		if (IS_ENABLED(CONFIG_32BIT))
> +			saddr |= ((gpa_t)saddr << 32);

saddr |= ((gpa_t)saddr_high << 32)

> +		else
> +			sbiret = SBI_ERR_INVALID_ADDRESS;
> +		goto out;
> +	}
> +

Thanks,
drew

