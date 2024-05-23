Return-Path: <kvm+bounces-18023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFCEC8CCEBE
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 11:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CEBA1C213A7
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 09:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A4313D276;
	Thu, 23 May 2024 09:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="D2h6Gblt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90DB13CF93
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 09:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716455168; cv=none; b=bb36v/dFQ/aQIXr7U4zKYnmlsHPyTMsusWFNOnglbfhlJ1/qP1Vb2IQIA7VdejUFsHyJLUJsFofgT36TWMx8oosZ0zWUs78bRAPAR5KC+4Ax0YnYxvDO88BjwkorkagM6UVP+A0KMvCHoPACPGLyaiaRSpix7wGwx0+kNK5FI6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716455168; c=relaxed/simple;
	bh=zAGC0q3zb/kUKLlN7+r/uiMOW4NzeKphfhi7MnVOhxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/Hlai1PXT1d31c4CpHKu7m8T7gOdU3EKAdtOv41vuplKvMFpodQmuBhlNzZgXd0Kr+nryftHXYaHE04GAb20L5dbBKFLECSsXOC/w8Z4NjI3wDTnZ+S/2zBW1oozQgNdIiFbYmpbEV93dD2QZS59Dg8XxflwiS3GU6Z/AfH/iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=D2h6Gblt; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a59a0e4b773so1070512966b.2
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 02:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1716455165; x=1717059965; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4l5zU20cndw6hYAB3MUXx+3Gbe6LL2k71CJyaDseujw=;
        b=D2h6GbltyI4M7OT8AraTGlHcftzZRO7aHGAy6Z6MLgISZUMLuEu+FzJnyYkF9/PHV3
         +GMSpRc/rS+3Lpj3AW7hD9PqXfwMBB7G0yLDG6IR5WwUIUTOvoVPwYXzaCxJiMS1wZiE
         GcP2/FbZVAvKgsvJl1lziTzSD1IN/vIpkpzCsx3B6MVuZECwlIoxisEUwXlz0eF+nW8Z
         9cuzk2o3UpWqaqLQJbqoLYB51Gs9EImsOxGsqEnQc3zg+2bN67NKWkr4f5ilfakKPtgl
         38WuAn4dLO9fGr+ajKoF/QZkvE3R9MGVG4KIVKpOWqbn+uuhRcfa1sDi0LXH3NR0vZda
         bzag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716455165; x=1717059965;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4l5zU20cndw6hYAB3MUXx+3Gbe6LL2k71CJyaDseujw=;
        b=kxBfT3AFScnj3klaSFiQwmwZnIyGloJj2Eoj6Wcx/I7mBqDGAmKmQzM5ID5rZq28fQ
         YK6uiV5gjtQ913Zhw+ChW8fFRGUD5gUTjbfN5kqZxcWhz952N7Ga8HiFJt+fuoMz5e9B
         +ZVlLWxDdDLq3xv+MKNTUxhyNHjejktDwVDcq5o49yP09eBVgNxQ8FG1I0PxaM5a9DT3
         4rOuz5LG/yPO+XMfHvEVL5GZzGThmvlt/6I9TDZx+lZgELFDgNJ2QB5lSAOxhf9NDkB8
         VR8Av700uky51P4PnQkah71LhxBwbCqWqZZ5WYrrqgmNHhEV1sp2k+gFTtIzon1CYZgf
         sb4Q==
X-Forwarded-Encrypted: i=1; AJvYcCU0oCiGeAmodIv+j/k2mKyZ7STF7v9RxpmBA0ibnX/+ntRr6IZ/I/ZvGeS4Y5tmCYfRki+5KXmuR9yitPJjH6NcAD5h
X-Gm-Message-State: AOJu0Yygkf15lYDH/6XIZWSysjvhog+c92umsntdo3XpzH0KzDk4tPfo
	C8oussnrkNEgX8ZG8jnYZ0ZjRBjP7QXQDd2bIRyAk0bWmBKjfWjXA7diA4c6i1A=
X-Google-Smtp-Source: AGHT+IG/+kNSZwH/WitEGN5akql9DZcvaGdZF5htf4Rc1hKQs5Ev4o2xODzuMiJrZHse607olITOWA==
X-Received: by 2002:a17:907:9148:b0:a59:a5c3:819e with SMTP id a640c23a62f3a-a622805e75cmr232911766b.11.1716455165190;
        Thu, 23 May 2024 02:06:05 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a622bd91be5sm213204766b.33.2024.05.23.02.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 02:06:04 -0700 (PDT)
Date: Thu, 23 May 2024 11:06:03 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RISC-V: KVM: Fix incorrect reg_subtype labels in
 kvm_riscv_vcpu_set_reg_isa_ext function
Message-ID: <20240523-9c0425e6b3c697abc1009123@orel>
References: <ff1c6771a67d660db94372ac9aaa40f51e5e0090.1716429371.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff1c6771a67d660db94372ac9aaa40f51e5e0090.1716429371.git.zhouquan@iscas.ac.cn>

On Thu, May 23, 2024 at 10:13:34AM GMT, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> In the function kvm_riscv_vcpu_set_reg_isa_ext, the original code
> used incorrect reg_subtype labels KVM_REG_RISCV_SBI_MULTI_EN/DIS.
> These have been corrected to KVM_REG_RISCV_ISA_MULTI_EN/DIS respectively.
> Although they are numerically equivalent, the actual processing
> will not result in errors, but it may lead to ambiguous code semantics.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  arch/riscv/kvm/vcpu_onereg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index c676275ea0a0..62874fbca29f 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -724,9 +724,9 @@ static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
>  	switch (reg_subtype) {
>  	case KVM_REG_RISCV_ISA_SINGLE:
>  		return riscv_vcpu_set_isa_ext_single(vcpu, reg_num, reg_val);
> -	case KVM_REG_RISCV_SBI_MULTI_EN:
> +	case KVM_REG_RISCV_ISA_MULTI_EN:
>  		return riscv_vcpu_set_isa_ext_multi(vcpu, reg_num, reg_val, true);
> -	case KVM_REG_RISCV_SBI_MULTI_DIS:
> +	case KVM_REG_RISCV_ISA_MULTI_DIS:
>  		return riscv_vcpu_set_isa_ext_multi(vcpu, reg_num, reg_val, false);
>  	default:
>  		return -ENOENT;
> 
> base-commit: 29c73fc794c83505066ee6db893b2a83ac5fac63
> -- 
> 2.34.1
> 
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

