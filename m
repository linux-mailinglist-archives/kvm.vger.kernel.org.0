Return-Path: <kvm+bounces-41761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75ED2A6CA23
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 13:26:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 431A717BB6C
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 12:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 325EC21CC6A;
	Sat, 22 Mar 2025 12:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="YyJtbzao"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB4B1BD9C6
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 12:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742646220; cv=none; b=GmC3IGXQEhDUp4C/ZuFtrPBax8TfBzfs3mRrlXw1FrRLOzFzJIpt48mVnF1+Wvy+1JEaU20viIbF9zkBp+cWomy7Qr7bmRyEV9Gj0sT/KgUOa/QM0m6KEeOjVw38WFb2YnEccpSEcNyzQh2WYIh/FT0NGeYMMNEBRJ8bKuWWEU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742646220; c=relaxed/simple;
	bh=JGkkKKzAxa4ZMpAR8zJFpRuqjYnoAHWm22u5I3jTZTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C76IqsBYJC3/AOdfSG668bcfAH3pYruPjnKhZFpO4VEFyAJlrtZJqDlTo8iOPrjDQJd44fzyxOwpiujzNfArvw35pM07Efce+Nr9+CLmxDh8JdTiiCdqe7ZqDCQlafy9D1OsXxhoRovNVF7o9yo0Uvn+nUjOcwPBlA56pcY28vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=YyJtbzao; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3914a5def6bso1721545f8f.1
        for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 05:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742646217; x=1743251017; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KTzyaulL1cxveyrERlwqgSXFqrJfmGbcSuyVzNJ2WH4=;
        b=YyJtbzaoe6ctVGSUzIRnUBgVJa2zt6p1TKepjQBtKVrfD7scbWaZM0W6Ntinxemkxr
         ew3YqRPlRxgPBLDMnXJioX7wrg5oKfD+nLqoyGha83SsofWi7XRtnVKoBfXlMm7aK+AU
         +rF+EzM6YPMLBmndAzf8i5MPqr00HbGuTiYAYZxlULyBwXLr3mryBRgovjoILazbHC7P
         9lE2Gf2UJo6z7vxmpLEe65FcG0s01kW5zxhjVK6pJfFoVEPWdD2Mnb1UCAz5GKo2pxGv
         e+euxaGbUHk/1l2GB8WrZGpWgz/PjhjbspQ4mnQBVLOZK7didHgrNrTrgF/qNSB01ssE
         vXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742646217; x=1743251017;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KTzyaulL1cxveyrERlwqgSXFqrJfmGbcSuyVzNJ2WH4=;
        b=NXJRTKhaxf1aLFrUxGPNWzHYTRp9dvjmtGeXX+tOBBBoScnOwZ3Z8x6tzBQPd+o2S3
         z96ya9YVQuATeiMXy1oA9LNo90G86t4ljYjcCAF8baaU6yAC9TvuKQyFTIguNKsvD+5S
         F2pW/LSabnPOm6i0cz61J7M7IH4PT+XF2SntQ85XTRYbOtjG/M2uNzTqPleLljpIA4/2
         y0mM1AARVFhkKE/bgrdqPN/ScBU9ebD+zoFGdHGgY2sidbZ40stVkJMvl08KJIDdru6H
         HbbmGU413kCJwjgUAe8D7ShzyiNDIdYs6K3warvUWR/xWsaeYeG242HqE/h30iwWT1ZN
         c8Ug==
X-Forwarded-Encrypted: i=1; AJvYcCWo+q3QTZXZHrw8PtWUiz8wjdWTingPELfnEsYtP+6EHMYBnz79bbbUs5ezn8e3wY4QumQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzE4iSTILSOl947LFuCIki9SabcCQQnFCTu8z48Th8+aOBWNs0X
	thivaMrT2UWnNu7OzWuz0bxIpUmvgZM5TElWOWmhWrOmMMEVD0OQHsCvCBflmvk=
X-Gm-Gg: ASbGncs2VWFozZS8ebf+AMjg2BWjCBkt9g+dXs8XQM/HxMbeCRIFn/2xmdTsidHVHvK
	iwu2wCgMVY1AYCdOlmyKeLhcfskVZR8SBDsbvPrEIUnkcp7xRGbsWgOivrSemgp7dIPwBjj5Kdh
	qUpQvQzbENjneAV1yY6Z6ncJobhZKV+nfz8OSwaBgGqSPbo8fYSz/EgGgtroXRXhgke9lfOAfev
	dXWgaPyz3wKdI81MhOb2e+Ce07bRYybaXtrxH329AA0+NkNcH6rF41RLE90GNQvp9cnnINgUa0C
	rm+4m00fRHNdI1wqXQR++iJR6WxVGZXvncDVlKczrVW8cM5AZ2NFwQX73Nqaa5scF6pAW+eo1gI
	skjyxVr8g
X-Google-Smtp-Source: AGHT+IE52/go+hfWqaafAsUjbEtclhpDIHNnMSaVERxClIrOt/FGAA02DZDghiLFtwTeL9nKBPSrqg==
X-Received: by 2002:a5d:6da1:0:b0:38d:dd52:1b5d with SMTP id ffacd0b85a97d-3997f8ef06dmr5373282f8f.4.1742646216874;
        Sat, 22 Mar 2025 05:23:36 -0700 (PDT)
Received: from localhost (cst2-173-28.cust.vodafone.cz. [31.30.173.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9e66a7sm5001809f8f.76.2025.03.22.05.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Mar 2025 05:23:36 -0700 (PDT)
Date: Sat, 22 Mar 2025 13:23:35 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH v4 15/18] RISC-V: KVM: add SBI extension init()/deinit()
 functions
Message-ID: <20250322-79de477d27a2a75eb89616d1@orel>
References: <20250317170625.1142870-1-cleger@rivosinc.com>
 <20250317170625.1142870-16-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250317170625.1142870-16-cleger@rivosinc.com>

On Mon, Mar 17, 2025 at 06:06:21PM +0100, Clément Léger wrote:
> The FWFT SBI extension will need to dynamically allocate memory and do
> init time specific initialization. Add an init/deinit callbacks that
> allows to do so.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  9 +++++++++
>  arch/riscv/kvm/vcpu.c                 |  2 ++
>  arch/riscv/kvm/vcpu_sbi.c             | 26 ++++++++++++++++++++++++++
>  3 files changed, 37 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 4ed6203cdd30..bcb90757b149 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -49,6 +49,14 @@ struct kvm_vcpu_sbi_extension {
>  
>  	/* Extension specific probe function */
>  	unsigned long (*probe)(struct kvm_vcpu *vcpu);
> +
> +	/*
> +	 * Init/deinit function called once during VCPU init/destroy. These
> +	 * might be use if the SBI extensions need to allocate or do specific
> +	 * init time only configuration.
> +	 */
> +	int (*init)(struct kvm_vcpu *vcpu);
> +	void (*deinit)(struct kvm_vcpu *vcpu);
>  };
>  
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
> @@ -69,6 +77,7 @@ const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
>  bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
>  int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
>  
>  int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long reg_num,
>  				   unsigned long *reg_val);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 60d684c76c58..877bcc85c067 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -185,6 +185,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
> +	kvm_riscv_vcpu_sbi_deinit(vcpu);
> +
>  	/* Cleanup VCPU AIA context */
>  	kvm_riscv_vcpu_aia_deinit(vcpu);
>  
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index d1c83a77735e..3139f171c20f 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -508,5 +508,31 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
>  		scontext->ext_status[idx] = ext->default_disabled ?
>  					KVM_RISCV_SBI_EXT_STATUS_DISABLED :
>  					KVM_RISCV_SBI_EXT_STATUS_ENABLED;
> +
> +		if (ext->init && ext->init(vcpu) != 0)
> +			scontext->ext_status[idx] = KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
> +	}
> +}
> +
> +void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu)
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
> +		if (scontext->ext_status[idx] == KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE ||
> +		    !ext->deinit)
> +			continue;
> +
> +		ext->deinit(vcpu);
>  	}
>  }
> -- 
> 2.47.2
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

