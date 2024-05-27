Return-Path: <kvm+bounces-18182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA278D088D
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 18:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7139B288D0D
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 16:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3DF155CAE;
	Mon, 27 May 2024 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WXOvQ+bP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037FF155C8C
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 16:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716827379; cv=none; b=YJvVxYp9zafALuGDhALXeQf/HRxF5jbqETFmX04GFzFt4bAzaPbVKMIK3OMMRZTmKdae5F4lkShnNzBx+5crB73pqubB77QBdmR5N5vSnnbfYCRbUtalqSW+lkIpR3GgJQD4sO4fNGtRNyZK0vYdplf9becc56/hwLqTHG62LtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716827379; c=relaxed/simple;
	bh=rk2XezkAzS5gUv8DwWyuJeBuEahdoVMELENJgT+Z7VQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hzrxI0EJi9cM3LbYmuJb+IwFpO+Zrrw0XZylTiyXf8Sm2T4XNVTfKXpj09T8JNCnw0+msdRhNE30GqnH5sZZYwgwZPFRd2gWT6BAH8XbohU12eklWx8uieQw80PLU9nzlzzqk2QiTs5FxDptD3FdGQ1DyyGGrm6ZU8H4KU4SlBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WXOvQ+bP; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4210aa00c94so22014125e9.1
        for <kvm@vger.kernel.org>; Mon, 27 May 2024 09:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1716827376; x=1717432176; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CUR9tjUj2iCuKOML1r+nyycL1s+FksIs6kJ9krg7rYI=;
        b=WXOvQ+bPyuPJqHwU4+icL8ySqXFsBfKb6V7+Fr1Z5DYSVcuU2KQIR+PT0kjUr7tJoj
         3ACAtlM+p62nYlhjqDTf7brKkgvhKm/g6g6BdzfW793OIIx+iOi5cfxUv+B7JeFHbczP
         T5kOye6/JNCkTBa7dYGKjWRPzp51/2q0OGD3/9airPAWnOXaJM8uwUs0xi3TlSDYh91Y
         ob5d3H95pg+Qt8aFfEqvzV0/qtLqVSjqgnnC5Bf61NyCHBQJl1G67GnML5uQWPl4C/v7
         8CwngJyq9vhlsNZbGVLRFHsW61z92Db+n5ss6sHCFPtTXIkQKWJT+uTkzp0Y350YRyM/
         TGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716827376; x=1717432176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUR9tjUj2iCuKOML1r+nyycL1s+FksIs6kJ9krg7rYI=;
        b=M1f6s2Y+Kn39Yvk9ZrR7Q3UBt02g9IP4M4hsPuTdeS+MwOrYgOOvZKAHey7d05w6lb
         vQwa6LcXOaI+ak2ancKZ5OI1xNvC0ahoc0gFMhp3/N5T1zQ1t5rs3Dns3LvmJ4FpttkR
         E0+eXeYuaa4a9wr0VIINAKHiHJiYKpKv0pwbzc4B8MjOt0UFNUD07as7gPkgGisrpVoj
         A7vZyBzU1ZDJWbPrCJhw1pEYqlN6MdM4tkET6nfuFfTihyVAjxNW8kfhd3Dkg40PNgB3
         aC/p/XYSlEQP0NG356J0mW4AxH8E7iYLelravd40VCONNqQEfc5jdflAMGTKqxYkshB1
         WBaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNBz9vv+uHV/M694Gsjz4CRlF6mGFUBgcTCybzrPcyG9jBBWE0YxykqIjqsO8U9eBOYONPslqZbs6RdQRc8/zLaM/G
X-Gm-Message-State: AOJu0YzNZZowKYui6FnjHOY8csEEy3Br8DK/XDuCsae0iTy0aSlQXQjW
	LLWxc96psnc7gfxDZRKjoQcRpdYI5JriKkLZHZUvaKrQmCfub27dyCSS0TeKE7w=
X-Google-Smtp-Source: AGHT+IGfCJZo4LZWWLpRRKTEPYlRJOgjNRulCbrg6HUczWdUKveycFMLbxR2PpHYqvUCkagZop+Nww==
X-Received: by 2002:a05:600c:1d22:b0:418:2b26:47a3 with SMTP id 5b1f17b1804b1-421089ffc9emr76330215e9.32.1716827376450;
        Mon, 27 May 2024 09:29:36 -0700 (PDT)
Received: from localhost ([176.74.158.132])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421089b0410sm113439735e9.29.2024.05.27.09.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 May 2024 09:29:36 -0700 (PDT)
Date: Mon, 27 May 2024 18:29:35 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, greentime.hu@sifive.com, vincent.chen@sifive.com, 
	cleger@rivosinc.com, alex@ghiti.fr, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 4/5] RISC-V: KVM: add support for
 SBI_FWFT_PTE_AD_HW_UPDATING
Message-ID: <20240527-cd06bb4215d05129f4793dd6@orel>
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
 <20240524103307.2684-5-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524103307.2684-5-yongxuan.wang@sifive.com>

On Fri, May 24, 2024 at 06:33:04PM GMT, Yong-Xuan Wang wrote:
> Add support for SBI_FWFT_PTE_AD_HW_UPDATING to set the PTE A/D bits
> updating behavior for Guest/VM.
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  2 +-
>  arch/riscv/kvm/vcpu_sbi_fwft.c             | 38 +++++++++++++++++++++-
>  2 files changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
> index 7b7bcc5c8fee..3614a44e0a4a 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
> @@ -11,7 +11,7 @@
>  
>  #include <asm/sbi.h>
>  
> -#define KVM_SBI_FWFT_FEATURE_COUNT	1
> +#define KVM_SBI_FWFT_FEATURE_COUNT	2
>  
>  struct kvm_sbi_fwft_config;
>  struct kvm_vcpu;
> diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
> index 89ec263c250d..14ef74023340 100644
> --- a/arch/riscv/kvm/vcpu_sbi_fwft.c
> +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
> @@ -71,6 +71,36 @@ static int kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
>  	return SBI_SUCCESS;
>  }
>  
> +static int kvm_sbi_fwft_adue_supported(struct kvm_vcpu *vcpu)
> +{
> +	if (!riscv_isa_extension_available(vcpu->arch.isa, SVADU))
> +		return SBI_ERR_NOT_SUPPORTED;
> +
> +	return 0;
> +}
> +
> +static int kvm_sbi_fwft_set_adue(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf,
> +				 unsigned long value)
> +{
> +	if (value)
> +		vcpu->arch.cfg.henvcfg |= ENVCFG_ADUE;
> +	else
> +		vcpu->arch.cfg.henvcfg &= ~ENVCFG_ADUE;
> +
> +	return SBI_SUCCESS;
> +}
> +
> +static int kvm_sbi_fwft_get_adue(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf,
> +				 unsigned long *value)
> +{
> +	if (!riscv_isa_extension_available(vcpu->arch.isa, SVADU))
> +		return SBI_ERR_NOT_SUPPORTED;
> +
> +	*value = !!(vcpu->arch.cfg.henvcfg & ENVCFG_ADUE);
> +
> +	return SBI_SUCCESS;
> +}
> +
>  static struct kvm_sbi_fwft_config *
>  kvm_sbi_fwft_get_config(struct kvm_vcpu *vcpu, enum sbi_fwft_feature_t feature)
>  {
> @@ -177,7 +207,13 @@ static const struct kvm_sbi_fwft_feature features[] = {
>  		.supported = kvm_sbi_fwft_misaligned_delegation_supported,
>  		.set = kvm_sbi_fwft_set_misaligned_delegation,
>  		.get = kvm_sbi_fwft_get_misaligned_delegation,
> -	}
> +	},
> +	{
> +		.id = SBI_FWFT_PTE_AD_HW_UPDATING,
> +		.supported = kvm_sbi_fwft_adue_supported,
> +		.set = kvm_sbi_fwft_set_adue,
> +		.get = kvm_sbi_fwft_get_adue,
> +	},
>  };
>  
>  static_assert(ARRAY_SIZE(features) == KVM_SBI_FWFT_FEATURE_COUNT);
> -- 
> 2.17.1
> 
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

