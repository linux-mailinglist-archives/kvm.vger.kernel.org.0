Return-Path: <kvm+bounces-54807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC65B286EC
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 22:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA00DB05509
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 20:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FD522BE055;
	Fri, 15 Aug 2025 20:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="bdION+ee"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441FF31770C
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 20:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755288283; cv=none; b=rHru/DAKuffwEmOa4aRlhJZnZsX5dahaRZg/k2scVpyPuRWKyuikLe+CZfNz8/iCxHKVFbQzgPr8z4atLDY8QyQfsKmaBsU5/9ZlTxFk18K9qsfkMD65bA4XZBzBv5m/GNQe+2SkGdh/UI8co5KSa/+5HRx6p9XpygQzVLa+df8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755288283; c=relaxed/simple;
	bh=YnJazGOGZYJN/dBOZtTqRX6QsQM8mR8auk3uz2DqgeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ji8JBglXYybrPAqywSQMEpaQ5OBA9yxJtVNAAPiL1mgCvFTlmATEgrgbH0oN4oqRJs1Oi0Q3YuKvaM5GdUerBSk8ICA/+9MjNyUE9l7kV2uuQehCJE083bD882UPxlZXJ2Pk80/hP6ao5Fvq3FLmw81W1wLmCg4G24o220y/tYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=bdION+ee; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-88432e2975cso162971939f.2
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 13:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755288280; x=1755893080; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YjJzR6BitUGV64diaMvb3KSO/e3Gi7ex2M4rjIRjOr4=;
        b=bdION+eejFvdPEWkEbuMrOJ3+gSdkiYpkxnSXMWsRmBATp6dxZ3jndTZjFN2l7rLrJ
         Wg0MvpyfdW2ATIMfUJomXxy0Mqm/tqGaIQIIr/iKmpQ61rYgzTElr91VQ5GfMPkBU8gd
         +YnJHz+kGMF3kJbMEV7HMFCFu8echSEeWkbVwtJFTO3XUfEfngxnWyltILOoSd8mQ+xH
         nX8MPluR3DzvdNhMr4TJ9CmUpSecA0Tx0nTptZxDrrOoW3nD3b/+uM6GHAxNBEgkjNMX
         MYu452K4mmJn9pooUruBDq82NCy7uHAM2hKvs6BOHecoRXDahyykkLelYYe+TRq5GX2a
         dsWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755288280; x=1755893080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YjJzR6BitUGV64diaMvb3KSO/e3Gi7ex2M4rjIRjOr4=;
        b=RRcW/KDzlRVxoeeIUxu+w0zvH6OVfe+CjqlSAS/MJ135wajNHEsTPPtUCSydFRi7kv
         M/8Ec23WiToRCuYV7d7FCj4/sIplCwKLX8shjVcYl589cyY6n+VFhXFfMML60MTmpTPc
         F4f+PP1T1py3quKwmXvnI1O4/WJ71ZZSr45ZgnmIoy7N1O8z6DA/xROuu7fY/u1zMXGh
         vAxvNeP8K8Hm+AruNzUVRibaVKeeMusJ6AHR/i9Vo85qngKMlIKG7J94pM5mbClrpUoT
         HvU3fNwIIU7F3VNjNl2V/cwQZI+7j8gXTjtTUOKBtnZ9mH0tP/sTdmHFT3RuaHjLHIrY
         JDTw==
X-Forwarded-Encrypted: i=1; AJvYcCUBIB0sAblePD+yTGflIYDhPipHSKULbOTFNLC11NlR4xi1OiueEdodvnZEbf2o8jmISp8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxidejcRnvKngHYGvdM7TObjGVTm+Z4OtruWquynuXMi6BPRHOB
	aS0aIhvn8qNXHc/17dvzn+5b2S+h/CPYWSfi8SInUekB3URYKfid4NUz/9qwg+RFi28=
X-Gm-Gg: ASbGncu014Xn8IxIeELQ/FxDMYjNjzKFAGBoqqcpVVafEXgzjk9/rfeITeAMnWDbypV
	OYks5lcD7joUjww2cdhq00DIYAkhcUdNZUceyksQPr1w7VOxNHKU8XedO7doWUzNaXp16OTrMZR
	zlybTknyjmQKpRF87Vj0mW/x8svq351GS2Ex5egP6N1KHcB21BHySij0LxZRLxHo8ZTK0HYdtNc
	gn35DIMzkKcxpasHnXoitELk3lsuTpsDZvT5zqsFX45C4QvGXNn0k/+s4lLiTFgYuQWLLMHIFSd
	PCDkRdHcU6QMWDf68i149RfQJmL85ak0ji3dzabDGglFgmQ6oqCufysDPuQa8/bEYU0sfRB2glX
	BURepuBmgSYLaGp2GCW+f2zmP
X-Google-Smtp-Source: AGHT+IFVAKt30ibqWuDesYE4Rq4i7q7q9OchtpkO5B6rE/MAYha/hplJL5lUKwJN5zK9vnb+lDVkPA==
X-Received: by 2002:a05:6602:3410:b0:86c:e686:ca29 with SMTP id ca18e2360f4ac-8843e34cd35mr730781139f.2.1755288280204;
        Fri, 15 Aug 2025 13:04:40 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8843f9f6d8dsm77814839f.24.2025.08.15.13.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 13:04:39 -0700 (PDT)
Date: Fri, 15 Aug 2025 15:04:38 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/6] RISC-V: KVM: Set initial value of hedeleg in
 kvm_arch_vcpu_create()
Message-ID: <20250815-5b8056af445fb30be7c387a7@orel>
References: <20250814155548.457172-1-apatel@ventanamicro.com>
 <20250814155548.457172-2-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814155548.457172-2-apatel@ventanamicro.com>

On Thu, Aug 14, 2025 at 09:25:43PM +0530, Anup Patel wrote:
> The hedeleg may be updated by ONE_REG interface before the VCPU
> is run at least once hence set the initial value of hedeleg in
> kvm_arch_vcpu_create() instead of kvm_riscv_vcpu_setup_config().
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index f001e56403f9..86025f68c374 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -133,6 +133,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  	/* Mark this VCPU never ran */
>  	vcpu->arch.ran_atleast_once = false;
> +
> +	vcpu->arch.cfg.hedeleg = KVM_HEDELEG_DEFAULT;
>  	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>  	bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
>  
> @@ -570,7 +572,6 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
>  			cfg->hstateen0 |= SMSTATEEN0_SSTATEEN0;
>  	}
>  
> -	cfg->hedeleg = KVM_HEDELEG_DEFAULT;
>  	if (vcpu->guest_debug)
>  		cfg->hedeleg &= ~BIT(EXC_BREAKPOINT);
>  }
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

