Return-Path: <kvm+bounces-38472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 77F1AA3A4A0
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 18:48:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E3DB7A2335
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:47:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267FB270EB5;
	Tue, 18 Feb 2025 17:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="oCX4y4n/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9B4270EAF
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739900926; cv=none; b=omCPoR0XKE57hG7I/yGN2i2H9bpt+cPcLnfVKmO7p3jspo/jYAkLB+i9wqx59gpPuqvdReYk1phdrH5M3JhPKPMlQkyvrFlRMSiKG3PnSgTKxo0ASBn+hbDoAKhKiG0QkqCQvM4FdHt8mxyvHnuwHANEBqUvmx9lAV3H4FqJzSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739900926; c=relaxed/simple;
	bh=iauYa14SsO/lsoYscvnp8YszrySxWKqagso3jWg5CLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aZRnN5UYvvtLIxFCvrTUh9FDuLdBYz/ulf2JSRbv9Dc6LqXrnz1RldZChZaUARRj3SzeVKC40Sx5EctEAkLZbq5OCL9W0CVzeWgx+HIGclQk1wNahA1VPKsrDO8g3428+MsTxunzCmrY/cdpTxSPyZNc1z7Dwvrs4n6v7LAxKy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=oCX4y4n/; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-38f406e9f80so2322893f8f.2
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1739900922; x=1740505722; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y/9F2KANNnqRPhOVip+6sGGo7ED+K7ta4GpssYl+9ok=;
        b=oCX4y4n/UKpgMVUsJdVILw92Q0kzKN5V1cKjYbkWlhFiiTLyWsVKtH4mqwqXsayqjD
         7aYSDmoQt/kAkIjNU52KNUkJ0X91mSNZ6bCuqLBud630s8X6Tx8SKAC5YGJ0v1tt0GJN
         XewWExI+EOrmPU0nXKTgPRrKXjVkAMDnX/yfC/T5TzHj2KozMABwSunFgEX0l2Bu/lV9
         Mh/NR0mR4PQfRD3X6ok7GhdE/HGliEdAdGanMYZ3dZpzQ+2shOMHdrekX9pCmT5CYE3i
         nGAzEGakxh4xptatgM8p2+JbyggYkjvZ2NyFgs8qL8EAaNHkCYziIGJp6/yj4s3YGO76
         RdPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739900922; x=1740505722;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/9F2KANNnqRPhOVip+6sGGo7ED+K7ta4GpssYl+9ok=;
        b=eEFjp4aMFZMpaJuM8g0YV7izi6PwGO3lksH9NiFH6H8dXy8LoS5ixz5ZzgN+DBujjj
         Xq+iJG9D+05Z3jtycXEbuSEkwwaJAbBYzcxgQSs9FZ3Vtd6pztLsOoThZKuFPYNK71vp
         KoGcDwQvshe2F4jGHzh0sk1LCWWs+PHADXk6CB95VZ7mUf7Q9WWNvKC+DLaXcbpmxwlZ
         /5Q6Vs960I/p25e6PsMTyi9RxCeWT8Oeb5+KG73sr/EmOsyDKlMCX6HFM/bKXjVdDtol
         TBYXblnPvRcFKqpATmT4LNGHfhPoHY5BNNzZPdKKSngJ/g5lO4ERTV+XGfFVUt06dH58
         fi6Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3X1uVZNXuq9U5E44JOcym0Cb1V5sH6XMxl0QAlnj6xLmBqBQcZP5E9wk0O5qc5G/Fe+A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyK/eEDxJwQrlbDwI415BTz3NyHurlv5YVQgLCJklJ72kaqjBos
	oX/l5UzkUsbQoNsgtQe7sKRaT7g1yveV4uAGDb9E/hs0dmOvbCJBk7AuPe3i80U=
X-Gm-Gg: ASbGncu7yUcGmrLIXzew49NWqxUEqBnwkq1RgF2ZKIRtJCjYg5PH0gwDYdbB7IFNQ19
	p7xucT2Ao+F75tU46GXWPWG0eI+wT+EVfDvmglruYa2HSWRkFitJF+2cQCPJzocm6QCbC7KYIkG
	k5zYRdGYY0/BeGxrSFhI/5afIU4R0RGE3Si6E5tDxEQxGiQDxYCcr4E0Zt4wNIL3/lDarzv3OPY
	cwFqcU1EOk3DDDFtuiR0Wd0iakz17xlLmALpVX9UtaMR1Z+rK5ZXnL3BQbmfF5R/3fibRv2UZLO
	Xa0=
X-Google-Smtp-Source: AGHT+IGDVdEGfqSSRSuokSOsRD/Nb4bUupeEDDpkXhWkKSM85eFfn/T5hKxjkCf6oi4D/15usSNtVA==
X-Received: by 2002:a5d:6c68:0:b0:38f:4acd:975c with SMTP id ffacd0b85a97d-38f58795a45mr438523f8f.27.1739900922377;
        Tue, 18 Feb 2025 09:48:42 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::766e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258dcc45sm15720336f8f.33.2025.02.18.09.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 09:48:41 -0800 (PST)
Date: Tue, 18 Feb 2025 18:48:41 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?6aG55paH5oiQ?= <xiangwencheng@lanxincomputing.com>
Cc: "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, 
	"anup@brainfault.org" <anup@brainfault.org>, "atishp@atishpatra.org" <atishp@atishpatra.org>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] riscv: KVM: Remove unnecessary vcpu kick
Message-ID: <20250218-57a3a16e477f83a8c267d120@orel>
References: <38cc241c40a8ef2775e304d366bcd07df733ecf0.1d66512d.85e4.41a5.8cf7.4c1fdb05d775@feishu.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38cc241c40a8ef2775e304d366bcd07df733ecf0.1d66512d.85e4.41a5.8cf7.4c1fdb05d775@feishu.cn>

On Tue, Feb 18, 2025 at 04:00:24PM +0800, 项文成 wrote:
> From 30dd00f6886119ecc5c39b6b88f8617a57e598fc Mon Sep 17 00:00:00 2001
> From: BillXiang <xiangwencheng@lanxincomputing.com>
> Date: Tue, 18 Feb 2025 15:45:52 +0800
> Subject: [PATCH] riscv: KVM: Remove unnecessary vcpu kick
> 
> Hello everyone,
> I'm wondering whether it's necessary to kick the virtual hart
> after writing to the vsfile of IMSIC.
> From my understanding, writing to the vsfile should directly
> forward the interrupt as MSI to the virtual hart. This means that
> an additional kick should not be necessary, as it would cause the
> vCPU to exit unnecessarily and potentially degrade performance.
> I've tested this behavior in QEMU, and it seems to work perfectly
> fine without the extra kick.
> Would appreciate any insights or confirmation on this!
> Best regards.

The above should be in a cover letter so the commit message can
be written following the guidelines of [1]

[1] Documentation/process/submitting-patches.rst

> 
> Signed-off-by: BillXiang <xiangwencheng@lanxincomputing.com>
> ---
>  arch/riscv/kvm/aia_imsic.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index a8085cd8215e..29ef9c2133a9 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -974,7 +974,6 @@ int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vcpu,
> 
>         if (imsic->vsfile_cpu >= 0) {
>                 writel(iid, imsic->vsfile_va + IMSIC_MMIO_SETIPNUM_LE);
> -               kvm_vcpu_kick(vcpu);

We can't completely remove the kick, but we could replace it with a
kvm_vcpu_wake_up().

There's also a kick in kvm_riscv_vcpu_vstimer_expired() which could be a
kvm_vcpu_wake_up() when hideleg has IRQ_VS_TIMER set (which it currently
always does).

Thanks,
drew

>         } else {
>                 eix = &imsic->swfile->eix[iid / BITS_PER_TYPE(u64)];
>                 set_bit(iid & (BITS_PER_TYPE(u64) - 1), eix->eip);
> --
> 2.46.2
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

