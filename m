Return-Path: <kvm+bounces-40938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82141A5F821
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 15:29:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DAE397AFEB4
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 14:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E93268695;
	Thu, 13 Mar 2025 14:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="AgOoItBx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35478267F7D
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 14:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741876147; cv=none; b=e1gEy4Rlr2CpV963Tcw8+yQXD+qVYmYMtiKdDv68BVYJ+iWdM7L5/ioS9hf4KJ58/AiLAZGHrWzs5qhgFTxDQ8U1n9cnRom0NmzhIQrUNNT95ND6vM0yLTKNynQCt3IYqSJ3RVoakKNSWbP5DBF442DlMPMn6VDbfgsRrnmn9Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741876147; c=relaxed/simple;
	bh=IhRbxTNYT5jDWLzzSzpAtQQCUlM7VyTU4q+UFyC9fjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eB0fhXBLfvvsqEbBBTKf3xmHXsRkG66nga5LrFN8BdrRDUFhgaeHQyDpYY3L78WOIQpbEd86TDytRC9pUAiF/kdgO0NASDR/6TOZ+YkvXxJrPYYbf9Kqluv5Hs/KFkMEyCBpzTzd0ebQmLzTxAZQuVOTzmRxfu0kV9UV4VucgMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=AgOoItBx; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-39130ee05b0so1035566f8f.3
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 07:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1741876143; x=1742480943; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2dChJFwxiHoEAavEY7H+gGYQh3r5PftDd7S++Ebsfx4=;
        b=AgOoItBxGdtypefmqI5M1KIYtFGynvG82b46kqW4USzdrPuWwckKdtSpZlWZcwqCQj
         pf/BJUaAeqBPdd0+gndq9mxOZld7cCo+UhizVREqB5iCO24W9sIir0we4VprIyEMEvji
         C7Ttv+1vMjxOFniyLiodLbvyXYtlRDPebPu1OYsdAd5koEhZtiNLUDtcL3CpD3NE61PU
         oKfOXuZi09gXBAWT12mKomv0djT30HAzZU9BTBpEbjnWKkEo2Vl9g9Bm/wWuDe94t/NS
         pLhfoYbFxxwbcPPd0pAR/M7b+qRTo2QLYCeH68xXmojF2yyghsS3F8x4fx3fimWfGpng
         RbZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741876143; x=1742480943;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2dChJFwxiHoEAavEY7H+gGYQh3r5PftDd7S++Ebsfx4=;
        b=a6TaK6gJZWcwpuuc/5ixhmdd7h8eV2v07E/2+gYDGyvqGlJLQDjZHxCYolDJmkN3gp
         3mk4c/7lFoqsjh8oQ+K5OIuSTC3GMHDCTKqb7d+m4knEI2xN2RfHMzdNVrHL5VcWIc9u
         aH1DBsKS/s4hBYPG7A4it2TJckN0TI8BUOnCT5ufg+RpFrSFbkBmTbjdLuWAYn80V+Kp
         QO6ScE/RUfqQO8b6agpPVqHPcrj9v/GwpOQQTfS9ORJX+i6xAD5ToSvXfEdrAJ13iIvE
         g23ymw1hABi9+/YCmIJ+h7H7joo4SM+sGuV1lEDU4PeLkxJV+IpzlfliRQZSoRvMCt7I
         ccdA==
X-Forwarded-Encrypted: i=1; AJvYcCXbxI4+yba6T4BqV3fiH8KDfPmwJBf3KMtJurXSKWyK7A1oglfLF6QNk5V/hYM0R6rW8n0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvT0bK2i+RQ9c3YyJZTgNgl0oSWgRw8QLLXzf/fKs3eRvAcAxF
	pMKD9ia/btFmxatuIITouqEoa2V8Va1fZIxlHrSpyLxjkuBZahcXIpRsbhbWkIY=
X-Gm-Gg: ASbGncu5mEfzS/Pz18j2+ztdM9jwzR+LGAK6P5jU1MDqJ0TvF/uA7O0WGRYMhm8CAKM
	pMO6JzNED1113lcQUUFFfi8tmtmIbhGU15QoFlMtyLCRNyFZrgspxIBg5pL4dmSUlAi/NMtunPP
	tKPodt8U/BIUlaf9kX0hZ9dXbVUkYBAjBCstF60KJ33v0hhD87uunGENKJAo8FnxZXJjSWUgvgt
	aOYMzPzxkSjmksNhhGDw2BA2znoNXQ2F5vZ698VREnsh8q4dBwkicrVa46cF98GLiUk4B4YA2pk
	s/hytVSWKaqAH0O9jnbbLZqqemWkbVOt
X-Google-Smtp-Source: AGHT+IFGRk0+85vMf2nznPTCngJQKmrnEFB+xnqtB5azAsXm2lVcoxNZzqC/c+NjJqT/RrDSQQ2lQA==
X-Received: by 2002:a5d:5f4e:0:b0:391:fcc:9ee8 with SMTP id ffacd0b85a97d-39132d6bc06mr19775572f8f.23.1741876143518;
        Thu, 13 Mar 2025 07:29:03 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::59a5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d0a74d339sm54808835e9.14.2025.03.13.07.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 07:29:03 -0700 (PDT)
Date: Thu, 13 Mar 2025 15:29:02 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH v3 15/17] RISC-V: KVM: add SBI extension reset callback
Message-ID: <20250313-d269cf1812f8d080947fd64d@orel>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
 <20250310151229.2365992-16-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250310151229.2365992-16-cleger@rivosinc.com>

On Mon, Mar 10, 2025 at 04:12:22PM +0100, Clément Léger wrote:
> Currently, oonly the STA extension needed a reset function but that's

only

> going to be the case for FWFT as well. Add a reset callback that can be
> implemented by SBI extensions.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_host.h     |  1 -
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  2 ++
>  arch/riscv/kvm/vcpu.c                 |  2 +-
>  arch/riscv/kvm/vcpu_sbi.c             | 24 ++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu_sbi_sta.c         |  3 ++-
>  5 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index cc33e35cd628..bb93d2995ea2 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -409,7 +409,6 @@ void __kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
>  bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu);
>  
> -void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu);
>  
>  #endif /* __RISCV_KVM_HOST_H__ */
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index bcb90757b149..cb68b3a57c8f 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -57,6 +57,7 @@ struct kvm_vcpu_sbi_extension {
>  	 */
>  	int (*init)(struct kvm_vcpu *vcpu);
>  	void (*deinit)(struct kvm_vcpu *vcpu);
> +	void (*reset)(struct kvm_vcpu *vcpu);
>  };
>  
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
> @@ -78,6 +79,7 @@ bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
>  int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_sbi_reset(struct kvm_vcpu *vcpu);
>  
>  int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long reg_num,
>  				   unsigned long *reg_val);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 877bcc85c067..542747e2c7f5 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -94,7 +94,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>  	vcpu->arch.hfence_tail = 0;
>  	memset(vcpu->arch.hfence_queue, 0, sizeof(vcpu->arch.hfence_queue));
>  
> -	kvm_riscv_vcpu_sbi_sta_reset(vcpu);
> +	kvm_riscv_vcpu_sbi_reset(vcpu);
>  
>  	/* Reset the guest CSRs for hotplug usecase */
>  	if (loaded)
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 858ddefd7e7f..18726096ef44 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -539,3 +539,27 @@ void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu)
>  		ext->deinit(vcpu);
>  	}
>  }
> +
> +void kvm_riscv_vcpu_sbi_reset(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
> +	const struct kvm_riscv_sbi_extension_entry *entry;
> +	const struct kvm_vcpu_sbi_extension *ext;
> +	int idx, i;
> +
> +	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
> +		entry = &sbi_ext[i];
> +		ext = entry->ext_ptr;
> +		idx = entry->ext_idx;
> +
> +		if (idx < 0 || idx >= ARRAY_SIZE(scontext->ext_status))
> +			continue;
> +
> +		if (scontext->ext_status[idx] != KVM_RISCV_SBI_EXT_STATUS_ENABLED ||
> +		    !ext->reset)
> +			continue;
> +
> +		ext->reset(vcpu);
> +	}
> +}
> +
> diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
> index 5f35427114c1..cc6cb7c8f0e4 100644
> --- a/arch/riscv/kvm/vcpu_sbi_sta.c
> +++ b/arch/riscv/kvm/vcpu_sbi_sta.c
> @@ -16,7 +16,7 @@
>  #include <asm/sbi.h>
>  #include <asm/uaccess.h>
>  
> -void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu)
> +static void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.sta.shmem = INVALID_GPA;
>  	vcpu->arch.sta.last_steal = 0;
> @@ -156,6 +156,7 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta = {
>  	.extid_end = SBI_EXT_STA,
>  	.handler = kvm_sbi_ext_sta_handler,
>  	.probe = kvm_sbi_ext_sta_probe,
> +	.reset = kvm_riscv_vcpu_sbi_sta_reset,
>  };
>  
>  int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu,
> -- 
> 2.47.2
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

