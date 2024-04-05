Return-Path: <kvm+bounces-13707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 302EF899C85
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:13:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA4E92838B1
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 12:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E9C16C862;
	Fri,  5 Apr 2024 12:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="gu06X8WS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D243F12AACC
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 12:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712319181; cv=none; b=audk2F1SkNWRt7VcurdrjLFnWgUvj8nu5cYxO1lvL6xDFEX6tvg3HIxyR7NZRSVKS/dleEHNoPOH69tNnY9BQsCpOo/PYXrhJXOKseRKyM2UAClvhdna0dYi8+CkK7o6CcnJIUKeKVEhr5cVF2hGYefCZXVi+Up3z4TuQEMutw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712319181; c=relaxed/simple;
	bh=dshtjM1v82zRVU8kvER3wDxbXe0KcYtKm0n9OIpWsWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J9d60mRwpqSP/XWznzhPNrJWZGk8tNTRbqgVZF4KYYf2CG/ccucdcz0RJ9IDrIc9rzR27rG+nfLzKZj1vxPW8IlF06gVu6qoF+Py8IkUNlweYBboyHpb0N2CUApF3r1Vn9yWcjvatXQOlFBFAep5z1Xt74LHt3NFGjFqrfW/T8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=gu06X8WS; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d718ee7344so23944211fa.2
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 05:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712319178; x=1712923978; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HYZcvWtsDvy2pse+vGPhkHFJFnqvbEcDhkbwdc6IM+c=;
        b=gu06X8WSsXWUs6SO/U3Zt2ly3kHHeDvnI8Yq5WXvntsKwUkwdFzlu4RcoOJp9hh6yl
         616RU/qFaoO4dchfZLDF7KXyO/eOcCox8GRXZqJ6Wsg5KvdPq+1lI8jZ1Y/gVh5l7oj0
         xdUATFT929OEWiyA+T3269BycGS2RG2krE3dFFR7BBIyyTVNoTCaBTRoBY9F22c7FUH7
         jvufGnAccgIpq6xD7C9GcEFRKYa68pOCxQcKIdBbPgi1hnZEtZcrwipMydyBz4uBoPzR
         bdqfxz2dX3qqXQP6mCmm7pJLcxXE7gX9qAyOzR30Iyc9NzL5sJdtSVtwCpuXzFeD0Kpe
         Ufzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712319178; x=1712923978;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HYZcvWtsDvy2pse+vGPhkHFJFnqvbEcDhkbwdc6IM+c=;
        b=HUp7B9wlxqo53QMqEmF8yE13MUmTMnrL4ohwXhvt7lwc+8gc6G4Pf0njpNGpX/Uexj
         8YOV2MdbkCEU4BvjGHNdBrjd2AZ2urx6R9EjKRfsBxqsplfrh1nqo2r9Tp7spasWXUnf
         QP4rvrBSk2VRfhee3bNsYYQF4V93I9nzX8Rlne3v5PvZj60W5l/cK18Xj9zw6M0rtaja
         ojzxPeofleWk/JvgRMTTj5Mkg1FeG53C4YKw1egytKUkVOKjkb+P38HF0NIxu+GHwNmx
         3YwKXHlR8Nloauht1Z/uL3f+oGdNsFfqN/jY6sFnVfSDj8QfcuzDPuMdJDWi16LAkewF
         +hfA==
X-Forwarded-Encrypted: i=1; AJvYcCXYIrQYp9Ydki3GBb1jt8xMBIVWoHk/KesJrHYHRD1R7p1A83kpK11g0Pj0kN87u42sWFMNLaNONHyl7+vmB/s4Kd9c
X-Gm-Message-State: AOJu0YxRpWvY2Co3UjKOyvaCbu6YopH+hV49E5byMVh+wwhSAncLhnV5
	CJcFTWg9s4/Id8bYIB6in0gEXmzVn/qwkDG5XaBlCiLTWpExJsVtrj0Jt5E6jak=
X-Google-Smtp-Source: AGHT+IE7Lx9Gy8UPuI2Fe6F5yEOkQeAtXYhy3EeJ04SwdjNicn6qCSA5xJIY7awO1OB5cSxmhomVgg==
X-Received: by 2002:a2e:8555:0:b0:2d7:9d4:f31c with SMTP id u21-20020a2e8555000000b002d709d4f31cmr1244137ljj.15.1712319178095;
        Fri, 05 Apr 2024 05:12:58 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id iv9-20020a05600c548900b004162e3e5b9asm2463049wmb.44.2024.04.05.05.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 05:12:57 -0700 (PDT)
Date: Fri, 5 Apr 2024 14:12:56 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Ajay Kaher <akaher@vmware.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Alexey Makhalov <amakhalov@vmware.com>, 
	Anup Patel <anup@brainfault.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Juergen Gross <jgross@suse.com>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, virtualization@lists.linux.dev, 
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>, Will Deacon <will@kernel.org>, x86@kernel.org
Subject: Re: [PATCH v5 15/22] RISC-V: KVM: Improve firmware counter read
 function
Message-ID: <20240405-dbb7765ae18820c57461dfff@orel>
References: <20240403080452.1007601-1-atishp@rivosinc.com>
 <20240403080452.1007601-16-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403080452.1007601-16-atishp@rivosinc.com>

On Wed, Apr 03, 2024 at 01:04:44AM -0700, Atish Patra wrote:
> Rename the function to indicate that it is meant for firmware
> counter read. While at it, add a range sanity check for it as
> well.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_pmu.h | 2 +-
>  arch/riscv/kvm/vcpu_pmu.c             | 7 ++++++-
>  arch/riscv/kvm/vcpu_sbi_pmu.c         | 2 +-
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> index 55861b5d3382..fa0f535bbbf0 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -89,7 +89,7 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  				     unsigned long ctr_mask, unsigned long flags,
>  				     unsigned long eidx, u64 evtdata,
>  				     struct kvm_vcpu_sbi_return *retdata);
> -int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> +int kvm_riscv_vcpu_pmu_fw_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>  				struct kvm_vcpu_sbi_return *retdata);
>  int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
>  				      struct kvm_vcpu_sbi_return *retdata);
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index ff326152eeff..94efa88d054d 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -235,6 +235,11 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>  	u64 enabled, running;
>  	int fevent_code;
>  
> +	if (cidx >= kvm_pmu_num_counters(kvpmu) || cidx == 1) {
> +		pr_warn("Invalid counter id [%ld] during read\n", cidx);
> +		return -EINVAL;
> +	}
> +
>  	pmc = &kvpmu->pmc[cidx];
>  
>  	if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
> @@ -747,7 +752,7 @@ int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
>  	return 0;
>  }
>  
> -int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> +int kvm_riscv_vcpu_pmu_fw_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>  				struct kvm_vcpu_sbi_return *retdata)
>  {
>  	int ret;
> diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
> index cf111de51bdb..e4be34e03e83 100644
> --- a/arch/riscv/kvm/vcpu_sbi_pmu.c
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -62,7 +62,7 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		ret = kvm_riscv_vcpu_pmu_ctr_stop(vcpu, cp->a0, cp->a1, cp->a2, retdata);
>  		break;
>  	case SBI_EXT_PMU_COUNTER_FW_READ:
> -		ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata);
> +		ret = kvm_riscv_vcpu_pmu_fw_ctr_read(vcpu, cp->a0, retdata);
>  		break;
>  	case SBI_EXT_PMU_COUNTER_FW_READ_HI:
>  		if (IS_ENABLED(CONFIG_32BIT))
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

