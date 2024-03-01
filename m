Return-Path: <kvm+bounces-10611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D767386DEA1
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 10:52:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12A99B23C2B
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 09:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FBB76BB32;
	Fri,  1 Mar 2024 09:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="coZWtSlb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2FB6A8C8
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 09:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709286756; cv=none; b=uXes/kTCOTjikKj1gbQQkkl0bgENkTc9kqPD4o7EF1dWZn1pvM5lb6eDLnfzU4I8SWaI4R7UG6l/jszjcJViAlMzrZ09QqWt1Rf2sM/f3sTLzFpNsNi6i3ixYOypK1q3+pktJtBDzQyE+ORaI0HWzvD0t1AYBWviOJHVrAHjjC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709286756; c=relaxed/simple;
	bh=O5SoYzfgteCQ6ALh9ZQ0QFHLP3C0R6ls6LeO2LAOIIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ioxSFYFNSwxUfdb4LqHM9LB/4fJM1oEP9m/89wh8OKciGx0Qe0NzV9FviwlKXzzlxk31vE+ZCjQKKxTqHa65NlfZiG7yCYpNEOiIupbJxO5y58cGBlzPL5l+PlMQ//P22jDZus/Y+rfzVtP1JKgKBwaA3Ko2vZ7xD3GvLZX3c7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=coZWtSlb; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a446478b04bso168710666b.3
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 01:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709286753; x=1709891553; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j9QHyWahfs9gCWf7uMaefOcLnvNGoebBSGi+N5cc4JQ=;
        b=coZWtSlbLcar5hxTRopmsCqRZPL+6bX1HJWD97ntHVwgTwgLjoce/2QfC99qy92a16
         BaC+aObyeOQCbLhizP0aJUmfCkRdyVh5cpnXXxLw+htQONdKaP8rvAMvoL90jK/wH/ue
         2JyUf0UHrW7xX1UppkxyUboOttCC9xrC94m/ch343qPLroXuu/75rO1NqdZMEfL9y4/C
         4u8TqVQZEPDVDjppnCKHH6NIpBhLjRugeY0pwevbygp1S6m+EcZO3dit0POmFhD/0QNU
         8J1A9wyT0A3m5UyNrUxC7nrq1sFvNyVEJOx22LIyQfSjcJLmPbOIgcqFLdnpgCmkgQpu
         l8dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709286753; x=1709891553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j9QHyWahfs9gCWf7uMaefOcLnvNGoebBSGi+N5cc4JQ=;
        b=UDPzUgmlAtzMO7ymlzG6RRf2NyXFRO/UWtdrYp+MNx7qjuw+NKxKy3NP0pbC3tShxE
         UkNsBr9csIGlLA2UJzATPUVUxlCZRxJlJRwUumaqCDAs0n6clxFq3RNC0R+Ycb7ywjPk
         xX/Inn+1x3nUA94uLj4Aq4PwWPb5w5tNqzZKrv2S+FmAwKBEpfNoWMnir7ufxm2+JvOQ
         D+Cb6f8fSwROukDI+eGHrwEyXGXgkYtrivGhUGraUtq9TSTSIwVxWzUbdVC93XzwpymZ
         KtLKYbnlluxt9TDlabsgS4hx/OWcHKE9TTNgaSrGuUnMbMbNyXuN1ONEZR+QVC03p1Hk
         hwbA==
X-Forwarded-Encrypted: i=1; AJvYcCWipVLYNhJG/NiItZ2Rr1KskuzG+cqL/Qys/KKt1BAwf/DQInogVQi53+8xiczYp2mT+/o6++AH0of7UoNIOH1Tti1U
X-Gm-Message-State: AOJu0YyvFmpQl0rWX0fKGPh+xWyjIj+QX9aJ6kaZt6R7lVkpwOF4li0f
	EJEuzvWjDYQ/NWt5Pd8TDzJeDUnTp43GmtNXoxCOqhmn33qOiYy9zEgraVEGRxo=
X-Google-Smtp-Source: AGHT+IFFb5bzOks+lqs/185Lu0au521O/ZsFgW4Nrk2H88MGDv0vRN/r6X3wkkf9qeHNHigHYwOjLA==
X-Received: by 2002:a17:906:a197:b0:a43:af0b:c1c0 with SMTP id s23-20020a170906a19700b00a43af0bc1c0mr980628ejy.16.1709286753092;
        Fri, 01 Mar 2024 01:52:33 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id vu2-20020a170907a64200b00a43bf7ef577sm1535120ejc.188.2024.03.01.01.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 01:52:32 -0800 (PST)
Date: Fri, 1 Mar 2024 10:52:31 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
	Conor Dooley <conor.dooley@microchip.com>, Anup Patel <anup@brainfault.org>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, Icenowy Zheng <uwu@icenowy.me>, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 03/15] drivers/perf: riscv: Read upper bits of a
 firmware counter
Message-ID: <20240301-36ababe3e198d3d7573f316e@orel>
References: <20240229010130.1380926-1-atishp@rivosinc.com>
 <20240229010130.1380926-4-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229010130.1380926-4-atishp@rivosinc.com>

On Wed, Feb 28, 2024 at 05:01:18PM -0800, Atish Patra wrote:
> SBI v2.0 introduced a explicit function to read the upper 32 bits
> for any firmwar counter width that is longer than 32bits.

firmware

> This is only applicable for RV32 where firmware counter can be
> 64 bit.
> 
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/perf/riscv_pmu_sbi.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 16acd4dcdb96..ea0fdb589f0d 100644
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
> +			return 0;
> +
> +		val = ret.value;
> +		if (IS_ENABLED(CONFIG_32BIT) && sbi_v2_available && info.width >= 32) {
> +			ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ_HI,
> +					hwc->idx, 0, 0, 0, 0, 0);
> +			if (!ret.error)

Getting an error here indicates a buggy SBI. Maybe we should have a
warn-once?

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
> -- 
> 2.34.1
>

Either way,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


