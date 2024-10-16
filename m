Return-Path: <kvm+bounces-29027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0C99A1238
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 21:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F6B8B213C5
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 19:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE096212D0A;
	Wed, 16 Oct 2024 19:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="R3JkJPB4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14883165EE6
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 19:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729105436; cv=none; b=Pa8TMJkvfaimvqc2VR2+ffdecznGmy/WUQAtu+2NGt43o6jO6goNTL9i/aTyE2l9V1SUFQbiXlBE+49Ew2GkYhmyhY5wr/WirddZ8VSxKhIZ763VefwEJqNnsq5+hp0gFI9I8Vqb3UKhuVEHjT3a/e1BSZe+ahNEXi5u2TDS/BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729105436; c=relaxed/simple;
	bh=IdGPXBYuC+gFWtEcqOsuKc1VFFYBfDflbDi3vzbNnYk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mokW19yY2YH4Z6v70fEUacA1zX9UjtCt1g6TElotlihyBjSrx1Gc/8DvnnYPo/0+5s4RJ7YlFOwjqTyIF4yKveNlEVY77kWeWVJ9+TZZ5gcHU9v8dUG9Vc+juW31apX6M4PaAK48EIG1hNEC9Kd7DdILcprBLMtcwWg19ORTZnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=R3JkJPB4; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3a3bd664ebaso835735ab.2
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 12:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1729105433; x=1729710233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CxyFXAuH+mgf3dl67t38IiOCtsPnCcipqPsettp6piQ=;
        b=R3JkJPB4pNIN4SIXZGpVy8KAk/U2/3+wcfCfjeBT4pUb4yeHnPfrtaPmumrof7m+jd
         R6i4g2nth/WJYVWLNdKm3E7QgTPdNzmfYeDCRgKy9Kis2Nr7u1UeOY/B+djl0adNc724
         4DU5B6/qRqaiskPDuoQN1ZDTdWeLvTZBEECuLuVwRVZuPJQj3MN4Xra/9Hn8s/Zl/3qh
         NG+bOR8uZYrGsiRBOxz1UAtdvToXPYzzLimM89eOpcAlbvIge46uh8Sgl9bLl3h2NXvO
         ntuLjS7XvvGMsFf+DWlyeevYdo0KAnRNm8c+rmExXsrummjaYVjiDMRuU0KTyCPfHv8R
         I1DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729105433; x=1729710233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CxyFXAuH+mgf3dl67t38IiOCtsPnCcipqPsettp6piQ=;
        b=Ay6khTTSmotxKJ3mvvB82o+IcV5nAMrEzf+iEc4r4ZjhqT0d+lyWKkzgcOar+qRpkP
         eN5PzDz6ZE62Y4tADXrnTFTmb5yt2O7NxslWyQdnaHA1T6ccFQrV+No0C+RSP6XVD2bf
         mxOpfXwkOxJqRtOv9vFAWhZzug7njxJYsfIJKu3UyFF7dCfkMqGO7Y8FBQYnIYweHCdG
         8OBzjdLjpN0oJNBveMR8yJYwEk1/TsGBbCZPNqNzeN1ttzDUYj1VVnN+t3FHDDHE0uxk
         BF2Cg5VT9by9M4KBNf7/rwfJo/883PJDI0+9ramckkFJWaZwC/kAjqj8LLp53lOcHftU
         sN7A==
X-Forwarded-Encrypted: i=1; AJvYcCWz9TjznQfwmjXsV0VJT/UE4JA5fw1ROb3KqIlzz/FxTJPiyszq1HG/r1sHPcF5VDisbiE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX+LkZ1fOXX5FRv74wEycC+ar/y3AGP0Rfatj/PaUIr/YJcXFQ
	EKH25z+Pnd1BRTxrBdvn3C4ktWa5+CHFGPWuJabtbL4zlZ07OfSN+5kqhRN8VqI=
X-Google-Smtp-Source: AGHT+IFN4BQomLzr5kcRH/fIUJNMPAHP7KDnpJqCP2efyNjSfr3q1aTjpUQkcj+hd8dhGj91RZQEZw==
X-Received: by 2002:a05:6e02:1c21:b0:3a0:bc39:2d72 with SMTP id e9e14a558f8ab-3a3dc4cc8a8mr49777475ab.12.1729105433066;
        Wed, 16 Oct 2024 12:03:53 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea9c6c403csm3651632a12.35.2024.10.16.12.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 12:03:52 -0700 (PDT)
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
Subject: Re: [01/13] RISC-V: KVM: Order the object files alphabetically
Date: Wed, 16 Oct 2024 12:03:49 -0700
Message-Id: <20241016190349.640640-1-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240719160913.342027-2-apatel@ventanamicro.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Order the object files alphabetically in the Makefile so that
> it is very predictable inserting new object files in the future.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/Makefile | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index c2cacfbc06a0..c1eac0d093de 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -9,27 +9,29 @@ include $(srctree)/virt/kvm/Makefile.kvm
>  
>  obj-$(CONFIG_KVM) += kvm.o
>  
> +# Ordered alphabetically
> +kvm-y += aia.o
> +kvm-y += aia_aplic.o
> +kvm-y += aia_device.o
> +kvm-y += aia_imsic.o
>  kvm-y += main.o
> -kvm-y += vm.o
> -kvm-y += vmid.o
> -kvm-y += tlb.o
>  kvm-y += mmu.o
> +kvm-y += tlb.o
>  kvm-y += vcpu.o
>  kvm-y += vcpu_exit.o
>  kvm-y += vcpu_fp.o
> -kvm-y += vcpu_vector.o
>  kvm-y += vcpu_insn.o
>  kvm-y += vcpu_onereg.o
> -kvm-y += vcpu_switch.o
> +kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
>  kvm-y += vcpu_sbi.o
> -kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
>  kvm-y += vcpu_sbi_base.o
> -kvm-y += vcpu_sbi_replace.o
>  kvm-y += vcpu_sbi_hsm.o
> +kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_sbi_pmu.o
> +kvm-y += vcpu_sbi_replace.o
>  kvm-y += vcpu_sbi_sta.o
> +kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
> +kvm-y += vcpu_switch.o
>  kvm-y += vcpu_timer.o
> -kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o vcpu_sbi_pmu.o
> -kvm-y += aia.o
> -kvm-y += aia_device.o
> -kvm-y += aia_aplic.o
> -kvm-y += aia_imsic.o
> +kvm-y += vcpu_vector.o
> +kvm-y += vm.o
> +kvm-y += vmid.o
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

