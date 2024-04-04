Return-Path: <kvm+bounces-13533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA8DB8985DB
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 13:15:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E1281F27E68
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 11:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45E48286B;
	Thu,  4 Apr 2024 11:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LeY/pptd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28245811E0
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 11:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712229304; cv=none; b=sTXR4A06c8fihF9BBjuNg0Uc7B7CYbdjaC6UgHI2EwAj2TRm15TE8re2DjR4sFTe2+uPxmzHp8AUmPQM/3KY3sW5w0UCpBdxgW9kObs40hqCm5tY3gONe+BBzaytMlXagnfE8djxQyVYd3TmQ/Rhv1G8Bky5elplNA4gO9jEJJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712229304; c=relaxed/simple;
	bh=lcJ+0RKOVKyrFkZyrW0bb1gbt91d8N2KUr9gV2aCHuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0R3iwZPDrx84lRByhzF0WB5m+1bSQ3NEzKvkLhunPK6giBXr74ouMfGvnFqrodLlvWNOM6hr9c8F2Xeu2/IccNf0zNFKm+2xl78vaOU0XUeTy5eIE6gEe+giYbdIQeydHNCSDwo0xD0aH1RQ+v8BaEDs/5lPvm/gzAIJcZUkLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=LeY/pptd; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-566e869f631so878272a12.0
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 04:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712229301; x=1712834101; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=25ODCdRY+Jn4wzM+mEjHDke5+vqaysXX4gL6DfhOAvg=;
        b=LeY/pptd4pc15OvlMMzvYYgW1REaFvv+8aB3TzuqRawEQUHFYNHLNVe2z1Zv/Svg6K
         Dzb64pkVl8UFOhy2Fkgwl5B9cwlN0j5M+JkXiTCRFG0yVU4xGtXSzQuYQyiZrqHAhvGE
         64jTqqgOIi3BGe0lRwZy8Lbsjmv5C3wStrplGZACVg1n2ZIwWLMmz3yNv6fZ7/HC2dbg
         LudmSqah5AIRGyQuLYy61j8mEJoAlQQqdyvvjuopvHAlsBJHmG7hd46QPvnr7EiuLJQ3
         HDqaGP/K1MQsZH4eJAs2UPbzaO82PErSFaVi8FeRah3q+LGwHpDQNsfL+rrIpET+Hbit
         nPqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712229301; x=1712834101;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=25ODCdRY+Jn4wzM+mEjHDke5+vqaysXX4gL6DfhOAvg=;
        b=ZXYwSw9458CIsRClXF6ZOE+9EC3aJiB78q9c4lYu8zibB3XS5F/qUh4BzNRywobN8M
         q8QkCNWnamBfhPiJ+P2UDap/te7+GGFRA8+6ssSXbM0uokNvhrwCEJfla6O4XsN/C04B
         nA7zuGD/AiVPa5sN9VTPpb8LIL4hwhQYwkl65k7jfltTOxBCxLlaXqXNwicUTOZPJW0Z
         SqrOH9mfYvfB5B1tD9QdWn9Z6/mOkFZBe5/tfP14q8NoCzVJiddlrtGTUHZOLUZ3DxrN
         9fw0dfxeICWR/05yJdFWhgiKaup+zVWJcE2GPnysf4Z5J5b4qufSiBOqzuvz6OlohYtr
         hGsw==
X-Forwarded-Encrypted: i=1; AJvYcCXMGYcucFymRftLgTs57sJTvExip2k/Qlst9OPBQt4YIVFXrHOJ3pl3o1SDHYcctgzAywJBQ81/oSpsW8YHm8f3fRXQ
X-Gm-Message-State: AOJu0YwM74S+24ccgOd0q70KGe5qMs5Fy9YcmYgY0wmjRvQG2ALLGkoX
	/6ts/1vqLWEEYbu7yokhkE7ld53sSmCBgebUQHElAQobq0iwjs0gO+gTdNUfYkE=
X-Google-Smtp-Source: AGHT+IHVQCEpGYXXQyLBKL2NnoOYXTEECAPh40NJ3Rd5iw4YTlh7y+zWHd66X26Mz6VjXnim0PWvpg==
X-Received: by 2002:a50:8e4f:0:b0:567:824:e36c with SMTP id 15-20020a508e4f000000b005670824e36cmr1856431edx.14.1712229301530;
        Thu, 04 Apr 2024 04:15:01 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id fj22-20020a0564022b9600b0056a2cc5c868sm9061098edb.72.2024.04.04.04.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 04:14:59 -0700 (PDT)
Date: Thu, 4 Apr 2024 13:14:58 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Ajay Kaher <akaher@vmware.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Alexey Makhalov <amakhalov@vmware.com>, 
	Conor Dooley <conor.dooley@microchip.com>, Juergen Gross <jgross@suse.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, virtualization@lists.linux.dev, 
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>, Will Deacon <will@kernel.org>, x86@kernel.org
Subject: Re: [PATCH v5 05/22] RISC-V: Add SBI PMU snapshot definitions
Message-ID: <20240404-ecddd056e774ccec7cea3be8@orel>
References: <20240403080452.1007601-1-atishp@rivosinc.com>
 <20240403080452.1007601-6-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403080452.1007601-6-atishp@rivosinc.com>

On Wed, Apr 03, 2024 at 01:04:34AM -0700, Atish Patra wrote:
> SBI PMU Snapshot function optimizes the number of traps to
> higher privilege mode by leveraging a shared memory between the S/VS-mode
> and the M/HS mode. Add the definitions for that extension and new error
> codes.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/sbi.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 4afa2cd01bae..9aada4b9f7b5 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -132,6 +132,7 @@ enum sbi_ext_pmu_fid {
>  	SBI_EXT_PMU_COUNTER_STOP,
>  	SBI_EXT_PMU_COUNTER_FW_READ,
>  	SBI_EXT_PMU_COUNTER_FW_READ_HI,
> +	SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
>  };
>  
>  union sbi_pmu_ctr_info {
> @@ -148,6 +149,13 @@ union sbi_pmu_ctr_info {
>  	};
>  };
>  
> +/* Data structure to contain the pmu snapshot data */
> +struct riscv_pmu_snapshot_data {
> +	u64 ctr_overflow_mask;
> +	u64 ctr_values[64];
> +	u64 reserved[447];
> +};
> +
>  #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
>  #define RISCV_PMU_RAW_EVENT_IDX 0x20000
>  
> @@ -244,9 +252,11 @@ enum sbi_pmu_ctr_type {
>  
>  /* Flags defined for counter start function */
>  #define SBI_PMU_START_FLAG_SET_INIT_VALUE BIT(0)
> +#define SBI_PMU_START_FLAG_INIT_SNAPSHOT BIT(1)
>  
>  /* Flags defined for counter stop function */
>  #define SBI_PMU_STOP_FLAG_RESET BIT(0)
> +#define SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT BIT(1)
>  
>  enum sbi_ext_dbcn_fid {
>  	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
> @@ -285,6 +295,7 @@ struct sbi_sta_struct {
>  #define SBI_ERR_ALREADY_AVAILABLE -6
>  #define SBI_ERR_ALREADY_STARTED -7
>  #define SBI_ERR_ALREADY_STOPPED -8
> +#define SBI_ERR_NO_SHMEM	-9
>  
>  extern unsigned long sbi_spec_version;
>  struct sbiret {
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

