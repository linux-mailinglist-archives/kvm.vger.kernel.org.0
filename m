Return-Path: <kvm+bounces-57600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28457B582AF
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 19:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35F1317FD21
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 17:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C28E2BD016;
	Mon, 15 Sep 2025 17:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="KebkQQKv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9170028AB0B
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757955712; cv=none; b=EGSJywz/nMrNdXsOiy61iktmQaPouaEKtuqbe8Wrxr4eeNseBiO25NtkLuNdsmsG7sldZYySRQ9TI2R+v69IeZI3QIL2QywHmobw6FSo5ITI2qjJSJsSqkD5MXo6wISpbqxVRgAMTXy+2Pl+Fl/8ATaAJTIqbyzAHyS0zOeHCx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757955712; c=relaxed/simple;
	bh=q4Gi0ntxWm1QrtAeAhkAa/jv924QF60CECMU0fW1MPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ewdjB7BKTffoGFT4Ni4NLw9FpkygRf1ilTjEN6akEJrP8WBFWp/D7hf+NuLkDxDt9QzN/N+0JZQgItIpN9/HhF1EtYFqFC3cdQbF6S4Dq4kQ4zv54Z7JWA8q8hsstgHGQOFRq46SWdS8yzzNHqr6PI2YdTfQ3od13IZ3+cbzJjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=KebkQQKv; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-4240784860bso4694605ab.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 10:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1757955709; x=1758560509; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k8pxyW/bjpXpmupAYzyp4FH4PZi8lnxP+pKqyf7C5o8=;
        b=KebkQQKvhhJzLib60TpU80VeNK2uCGx15a/UzGyd3HxrJD70+B7AoP57l/H8piZJ7G
         gw/9WV0lWrTHWP36cJCwV7wzsLCwAOnMGC6vCLhrWhPLmTR1cKZlXoMLQValixMcbyKS
         oTJLC2nXwfCP9YaieoWMjbKYtPoZ1FaqxCg5MoKyTwpEGOWfLxUMb31kLdktTd5CHeFU
         5lj50jzr+Sf5aSOFhdNpFX1s1VXtsi4qMw7uTjTiB+eMIoqaGPjc77R9VmdmavMe0vZ8
         O6LJqes9s2+DYw3TnKRCEgsBDNrKNpJ9qfpMGVFX/y/YnxmDyog5nQD+90av5yRrhjOG
         tRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757955709; x=1758560509;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k8pxyW/bjpXpmupAYzyp4FH4PZi8lnxP+pKqyf7C5o8=;
        b=o4N64JqFbIeKsVVS85CTxPpbW9wuSnnorZHJ7E4Xcq8nxSKRSPjFEyXZlkijc1GCWf
         OMdFqbkUL3Yocmo+ps3XMagv+L7SjxxeosmolCIqorX0oPQapAlluxtAAPllrgmmGGqK
         FTgJ9SsgL3bDgwU65BT9TU/xxkGPgfeVBi0vhP70Z2G11gqbSx1bZRcnXT0vH8JrI01C
         1e5++GEpVismCCWuXCFbe7nyj9xSlpW5+a95SH3hFOrzzLlZwNm+WqNpTUb3BXGOtvQ3
         zxV8ekiyybht9GxsvqBkuxitrp1+eRj3IDmR+BdV6v1WvaNUSS8R49BBE5QnycOPinbT
         +p8w==
X-Forwarded-Encrypted: i=1; AJvYcCVze47BDnAQQ6CHDsl6hZcDRDZbAyX59bMZwU5KoMAQfuJoRdXbWu7jFOUHLI/Y318DXaA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPOtOJrKnj5nAFflC1GxoUqhYJPxd6P+VB7y8PnW4QmKxaDQor
	ILf4y4r1zf1dEpCfQ7u1HBMI1DDbCpCrVMJz7AW74eHEuK0RqTT2b4uNyioiCnxNbcA=
X-Gm-Gg: ASbGnct2S8IWzEdPxjem+lphB3/XkFDDZfH96453R5OJ78wVEmrqrhaV660FH1xVHwD
	pjJB8cVYocVao8t8znY5C/rpT7uRmojsL8RyM5UHazgXgKabPYx+rGkJIGzihPVSIS9iLD3l2bZ
	d7CpJ8o5mkBxhyTLn9wsqqmnJSxevcFvVJzGtlFU7JPjN0rG/eDVmzr8t3ZQ5vJRuCNSaQcoX3V
	54ATGqnTRI0kOGoc4sInqNcAy+6DSV2ueRXoPEJwCnfF8k5SbisX0TOrY4uugOaUF+Tj8tgLbsR
	odeCNNrTyKAZHgUWpaLOpQp47gAFldYrJiK+hCnYg/jACdtYcuK/dIcNDqSSbJEgmAG1cSF9wEg
	34lBxHwHVZyffICeLA3CRK5+E
X-Google-Smtp-Source: AGHT+IFi6vqzi7uBigrs1rkZ7BYQA7tKMwkaIff57LL4Wv+ao8W4QcMhs/+e22hjK6NK5HxClZr37A==
X-Received: by 2002:a05:6e02:188d:b0:3eb:5862:7cef with SMTP id e9e14a558f8ab-420a4173bb3mr104487445ab.22.1757955706965;
        Mon, 15 Sep 2025 10:01:46 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-41dfb240f4fsm58897935ab.43.2025.09.15.10.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 10:01:46 -0700 (PDT)
Date: Mon, 15 Sep 2025 12:01:45 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Jinyu Tang <tjytimi@163.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Conor Dooley <conor.dooley@microchip.com>, Yong-Xuan Wang <yongxuan.wang@sifive.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Radim Krcmar <rkrcmar@ventanamicro.com>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Tianshun Sun <stsmail163@163.com>
Subject: Re: [RFC PATCH] kvm/riscv: Add ctxsstatus and ctxhstatus for
 migration
Message-ID: <20250915-ad649bd2a0c0b9e98b63c5f4@orel>
References: <20250915152731.1371067-1-tjytimi@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915152731.1371067-1-tjytimi@163.com>

On Mon, Sep 15, 2025 at 11:27:31PM +0800, Jinyu Tang wrote:
> When migrating a VM which guest running in user mode 
> (e.g., executing a while(1) application), the target 
> VM fails to run because it loses the information of 
> guest_context.hstatus and guest_context.sstatus. The 
> VM uses the initialized values instead of the correct ones.

Does https://lore.kernel.org/all/20250915070811.3422578-1-xb@ultrarisc.com/
fix this?

Thanks,
drew

> 
> This patch adds two new context registers (ctxsstatus and 
> ctxhstatus) to the kvm_vcpu_csr structure and implements 
> the necessary KVM get and set logic to preserve these values 
> during migration.
> 
> QEMU needs to be updated to support these new registers.
> See https://github.com/tjy-zhu/qemu
> for the corresponding QEMU changes.
> 
> I'm not sure if adding these CSR registers is a right way. RISCV
> KVM doesn't have API to save these two context csrs now. I will
> submit the corresponding QEMU patch to the QEMU community if
> KVM has API to get and set them.
> 
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> Tested-by: Tianshun Sun <stsmail163@163.com>
> ---
>  arch/riscv/include/asm/kvm_host.h |  2 ++
>  arch/riscv/include/uapi/asm/kvm.h |  2 ++
>  arch/riscv/kvm/vcpu_onereg.c      | 16 ++++++++++++++++
>  3 files changed, 20 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index d71d3299a..55604b075 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -161,6 +161,8 @@ struct kvm_vcpu_csr {
>  	unsigned long vsatp;
>  	unsigned long scounteren;
>  	unsigned long senvcfg;
> +	unsigned long ctxsstatus;
> +	unsigned long ctxhstatus;
>  };
>  
>  struct kvm_vcpu_config {
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index ef27d4289..cd7d7087f 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -81,6 +81,8 @@ struct kvm_riscv_csr {
>  	unsigned long satp;
>  	unsigned long scounteren;
>  	unsigned long senvcfg;
> +	unsigned long ctxsstatus;
> +	unsigned long ctxhstatus;
>  };
>  
>  /* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index cce6a38ea..284ee6e81 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -489,6 +489,12 @@ static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
>  	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
>  		return -ENOENT;
>  
> +	if (reg_num == KVM_REG_RISCV_CSR_REG(ctxsstatus))
> +		csr->ctxsstatus = vcpu->arch.guest_context.sstatus;
> +
> +	if (reg_num == KVM_REG_RISCV_CSR_REG(ctxhstatus))
> +		csr->ctxhstatus = vcpu->arch.guest_context.hstatus;
> +
>  	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
>  		kvm_riscv_vcpu_flush_interrupts(vcpu);
>  		*out_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
> @@ -515,6 +521,16 @@ static int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
>  
>  	((unsigned long *)csr)[reg_num] = reg_val;
>  
> +	if (reg_num == KVM_REG_RISCV_CSR_REG(ctxsstatus)) {
> +		if (csr->ctxsstatus != 0)
> +			vcpu->arch.guest_context.sstatus = csr->ctxsstatus;
> +	}
> +
> +	if (reg_num == KVM_REG_RISCV_CSR_REG(ctxhstatus)) {
> +		if (csr->ctxhstatus != 0)
> +			vcpu->arch.guest_context.hstatus = csr->ctxhstatus;
> +	}
> +
>  	if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
>  		WRITE_ONCE(vcpu->arch.irqs_pending_mask[0], 0);
>  
> -- 
> 2.43.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

