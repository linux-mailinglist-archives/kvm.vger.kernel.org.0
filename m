Return-Path: <kvm+bounces-29028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E85E09A1284
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 21:27:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A777E286408
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 19:27:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0762144D2;
	Wed, 16 Oct 2024 19:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="CYJCk7jp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E740D2141C0
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 19:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729106864; cv=none; b=HD7o8QAGulNXaeQ7b9QjgaOtCs6/WrHwe+HQEAT3FSasp+kT6dXvtzywPgTJn25yNTR0F0zOBzIUR+uJ+RUkoxIK5dYd9HAZO+fVtaS5c7IiAcy66QaL6XrRHa5KSBWPJGOttF6fBSKqXUeQovd+nSGipSRocoZA3nZ74KugFJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729106864; c=relaxed/simple;
	bh=QL8AAyq4okBa56/NxbA+hTLKq+aPTQdX4Mx2OAVqfV0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bP2UsnyrnkyKDSxVCxsARpcWhWCqxe8oim66CZlYOEKcWjKAfxha8m2OfLLBUTgu/2JaRRDbTnyKqHxTg71cBzq5dnbrHNO5qtauh/ey1qB3fHHG2QLxB2m3EYbTMFsCKfzk5pRjJDIqfxgLjq6vmz8/daTP5KU0Fd8AsL14cso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=CYJCk7jp; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20cb7088cbcso1391185ad.0
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 12:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1729106861; x=1729711661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qd1CmdA3yqF27op1lfKzX3+JmGDdwdfJqTWrLKRMg8E=;
        b=CYJCk7jpJfe1aI6O7BAntz2/7I2JslwdQtBwwRvq/+o+GwPJB0v3ur2aPADd/GxMux
         7giwGBsrnQzq0qgNULCYRLrVz+YJ4s23Omj8UhBvJKTZQpa0oo+Zj5qt4SwFP75N37Sv
         3tKzZ0k0yVUoSQq79DfrbIxm+fzdk8igjEspXmOxfm4JXk3FIr9RTpnuX6xfWwC/ujEU
         6JsYZXrN8YNxeYt6b58TRIpRlEPkJo6JPDT0ofpDPWYhVgo9fT+Py8vhlVWHOguksJgF
         9lNd3sX9my91jb7XrFtaYeNNM43D9ftJ1jiiRhdPJz98fxDtqccDKScapArXbk52oDaR
         qfzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729106861; x=1729711661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qd1CmdA3yqF27op1lfKzX3+JmGDdwdfJqTWrLKRMg8E=;
        b=pWofTNHmj0ObqD8Nuo2rTjVJ5ju9paX+qNYMNKMHdXmmAkpOH0uvxEQjWCEnnUi0Pf
         64wkwi2SLYJCHg6gLVqwmYmKKE98ME0U28Ffx9XwdAYquGpktHZRJ/Rv17mlYbCmNR+u
         bT/ORxI6fbVNQsS9zIC4t1vpzNM9G3laHNfWrgjj3qJVvrN8XKOx9a4cNxnH3YD+fYg2
         kXknJH0bbTv0U4aU1uBZeqsWKbDPOA0kwGsJLY3Acpf1qtXIG0yzDzTBOy27Pb8ORPLO
         UZm2AdLwH98h/3958BF2gq/Pitwl028yR5F5DvrIF9UoAA49Bs8s/30PUZufVcH7uTdg
         LH6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUdVdaxvLCAKbEVrhzXtKHWTbFaJHNfj7/VNBfjebeHpzUTq4SAsyKyTD48U5k2Ce8tQV0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzknyM5YL46rsYpAReK3jboUpv23t7vBQ2QA1alwhDHPyosnO4p
	5LKqKh1Xj8W4GI0Ifxomjo3VUPI6I7Iru3WZOAP1kZ7qWMRIOv9SXoXcyCOMGG4=
X-Google-Smtp-Source: AGHT+IFoxV0OBJ2pPBa3JaF0UAh0T+UygwcrRunJT3pLxQjb5MJyphkUDSDvZdgExNMyuDU4htwPIQ==
X-Received: by 2002:a17:902:d490:b0:20c:f3cf:50eb with SMTP id d9443c01a7336-20cf3cf5379mr121875075ad.44.1729106861266;
        Wed, 16 Oct 2024 12:27:41 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d1805ca60sm31993675ad.239.2024.10.16.12.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 12:27:41 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: apatel@ventanamicro.com
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [02/13] RISC-V: KVM: Save/restore HSTATUS in C source
Date: Wed, 16 Oct 2024 12:27:38 -0700
Message-Id: <20241016192738.646447-1-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240719160913.342027-3-apatel@ventanamicro.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> We will be optimizing HSTATUS CSR access via shared memory setup
> using the SBI nested acceleration extension. To facilitate this,
> we first move HSTATUS save/restore in kvm_riscv_vcpu_enter_exit().
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu.c        |  9 +++++++++
>  arch/riscv/kvm/vcpu_switch.S | 36 +++++++++++++-----------------------
>  2 files changed, 22 insertions(+), 23 deletions(-)
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 449e5bb948c2..93b1ce043482 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -720,9 +720,18 @@ static __always_inline void kvm_riscv_vcpu_swap_in_host_state(struct kvm_vcpu *v
>   */
>  static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_cpu_context *gcntx = &vcpu->arch.guest_context;
> +	struct kvm_cpu_context *hcntx = &vcpu->arch.host_context;
> +
>  	kvm_riscv_vcpu_swap_in_guest_state(vcpu);
>  	guest_state_enter_irqoff();
> +
> +	hcntx->hstatus = csr_swap(CSR_HSTATUS, gcntx->hstatus);
> +
>  	__kvm_riscv_switch_to(&vcpu->arch);
> +
> +	gcntx->hstatus = csr_swap(CSR_HSTATUS, hcntx->hstatus);
> +
>  	vcpu->arch.last_exit_cpu = vcpu->cpu;
>  	guest_state_exit_irqoff();
>  	kvm_riscv_vcpu_swap_in_host_state(vcpu);
> diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
> index 0c26189aa01c..f83643c4fdb9 100644
> --- a/arch/riscv/kvm/vcpu_switch.S
> +++ b/arch/riscv/kvm/vcpu_switch.S
> @@ -43,35 +43,30 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>  
>  	/* Load Guest CSR values */
>  	REG_L	t0, (KVM_ARCH_GUEST_SSTATUS)(a0)
> -	REG_L	t1, (KVM_ARCH_GUEST_HSTATUS)(a0)
> -	REG_L	t2, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
> -	la	t4, .Lkvm_switch_return
> -	REG_L	t5, (KVM_ARCH_GUEST_SEPC)(a0)
> +	REG_L	t1, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
> +	la	t3, .Lkvm_switch_return
> +	REG_L	t4, (KVM_ARCH_GUEST_SEPC)(a0)
>  
>  	/* Save Host and Restore Guest SSTATUS */
>  	csrrw	t0, CSR_SSTATUS, t0
>  
> -	/* Save Host and Restore Guest HSTATUS */
> -	csrrw	t1, CSR_HSTATUS, t1
> -
>  	/* Save Host and Restore Guest SCOUNTEREN */
> -	csrrw	t2, CSR_SCOUNTEREN, t2
> +	csrrw	t1, CSR_SCOUNTEREN, t1
>  
>  	/* Save Host STVEC and change it to return path */
> -	csrrw	t4, CSR_STVEC, t4
> +	csrrw	t3, CSR_STVEC, t3
>  
>  	/* Save Host SSCRATCH and change it to struct kvm_vcpu_arch pointer */
> -	csrrw	t3, CSR_SSCRATCH, a0
> +	csrrw	t2, CSR_SSCRATCH, a0
>  
>  	/* Restore Guest SEPC */
> -	csrw	CSR_SEPC, t5
> +	csrw	CSR_SEPC, t4
>  
>  	/* Store Host CSR values */
>  	REG_S	t0, (KVM_ARCH_HOST_SSTATUS)(a0)
> -	REG_S	t1, (KVM_ARCH_HOST_HSTATUS)(a0)
> -	REG_S	t2, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
> -	REG_S	t3, (KVM_ARCH_HOST_SSCRATCH)(a0)
> -	REG_S	t4, (KVM_ARCH_HOST_STVEC)(a0)
> +	REG_S	t1, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
> +	REG_S	t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
> +	REG_S	t3, (KVM_ARCH_HOST_STVEC)(a0)
>  
>  	/* Restore Guest GPRs (except A0) */
>  	REG_L	ra, (KVM_ARCH_GUEST_RA)(a0)
> @@ -153,8 +148,7 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>  	REG_L	t1, (KVM_ARCH_HOST_STVEC)(a0)
>  	REG_L	t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
>  	REG_L	t3, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
> -	REG_L	t4, (KVM_ARCH_HOST_HSTATUS)(a0)
> -	REG_L	t5, (KVM_ARCH_HOST_SSTATUS)(a0)
> +	REG_L	t4, (KVM_ARCH_HOST_SSTATUS)(a0)
>  
>  	/* Save Guest SEPC */
>  	csrr	t0, CSR_SEPC
> @@ -168,18 +162,14 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>  	/* Save Guest and Restore Host SCOUNTEREN */
>  	csrrw	t3, CSR_SCOUNTEREN, t3
>  
> -	/* Save Guest and Restore Host HSTATUS */
> -	csrrw	t4, CSR_HSTATUS, t4
> -
>  	/* Save Guest and Restore Host SSTATUS */
> -	csrrw	t5, CSR_SSTATUS, t5
> +	csrrw	t4, CSR_SSTATUS, t4
>  
>  	/* Store Guest CSR values */
>  	REG_S	t0, (KVM_ARCH_GUEST_SEPC)(a0)
>  	REG_S	t2, (KVM_ARCH_GUEST_A0)(a0)
>  	REG_S	t3, (KVM_ARCH_GUEST_SCOUNTEREN)(a0)
> -	REG_S	t4, (KVM_ARCH_GUEST_HSTATUS)(a0)
> -	REG_S	t5, (KVM_ARCH_GUEST_SSTATUS)(a0)
> +	REG_S	t4, (KVM_ARCH_GUEST_SSTATUS)(a0)
>  
>  	/* Restore Host GPRs (except A0 and T0-T6) */
>  	REG_L	ra, (KVM_ARCH_HOST_RA)(a0)
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

