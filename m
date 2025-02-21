Return-Path: <kvm+bounces-38847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DB73A3F2BD
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 12:11:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 321DB19C6B7C
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 11:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C82C208966;
	Fri, 21 Feb 2025 11:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="KWpMP9QA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F502AE89
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 11:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740136292; cv=none; b=jMZgoblYxYHdzbiCadaknttws6wNFcXuizIDlQaykmILoQQ+9zjRVkiBALlzZG/cWZ9g5nLgaWm75dFMd7QJt6gs0swVQe7dje1koSsWbwpcncyWvZsCpb3F8a365+2jD4WcMgKVmdgs7p5U+j7St1P8t6FZtRRMwYTZCupZGms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740136292; c=relaxed/simple;
	bh=uFst0uZhDHecANQgSPcaTkQaZji1kbxiGdT8lgz3J6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y+XLWQE7Vw0WupD5lnhkg7q7TtYiiBeB4bohVcprTB7Ti3fgduhS0aw2c9TLi4gUpsCkiVuA5IkODJk7iZVkPEtGJsTAeC5I1LigxFWzwm5icE7KUcEYBA+pKUWyBBoBM157BJKlpJxNZrLvdPRB7PBhh2VDuU2nGDGF8NEm9Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=KWpMP9QA; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-439a331d981so16977695e9.3
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 03:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1740136287; x=1740741087; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jSsWiZSoq00eYWyXg0OJO1m3DP0gspy/2ZFYEnCczbE=;
        b=KWpMP9QAKaSZKOF420rklwiTuC5+Y8wM1RIzB1olZYwtHg3vYK/zy5hXWL5cRXYgIE
         z9utogW2VMSxIGZnPCaIYTckrD7YEP53k5nMLrlI/Yh0OSq7FhvaOHkGq53SjipSC8aC
         6dU6OI1g5x+Px8RjGm3DYgpIBQc6LRF0NXoGq/rmhYC73RYRj1Co2vL/ScVA2deX4Lou
         38AmHoYTxNU9dIAshQcCsvrzcEp3cN4HZz7ZIepCmAu5eMEsPYKFE/u0uuD9CMhM3KNo
         btIPZlvvgofMVBJZF7UK67BensNJ3B1MnbmSSyMlcbfRoGjAxTw57lA0PYp2bV0iQLDV
         vxAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740136287; x=1740741087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSsWiZSoq00eYWyXg0OJO1m3DP0gspy/2ZFYEnCczbE=;
        b=CzavMYo9ov1smnv4/SBbPQJs3l1sL/sH5SzRWc39H4eoNvHttGZA/WAC/O/DRuI2W1
         uFb66rREefxXqlDLST5MZFaHz3sfRUakl7bYJqoRriWVAO/kv80RODZ6izc7VCq/K1Ts
         7rbP2jr7bNol9Njyzfm/Gb6ZtIzCAgPnwIHwCrzshzq5PMFTthfjQzH/gcjy9goCjITq
         qWTrk9cQF08W51SrBpVeJbsI0XbUNlbg9lrGyQ2+iEza7tFnQkdGyjKry3sc0BhDoHoQ
         235zU4liFL8IGavNom8zJNQFQ1kw6IUFUvPZ6snvkjEiiaazU7czTiUn9CZTAZeWcRxt
         PW2w==
X-Forwarded-Encrypted: i=1; AJvYcCWHyfusW104zJKp4yztEIMEN7DCgePb6mC35PTGMtpsN+YZ0hhRW9RnxReCCb2BOssCV1U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrkhbwFRn/zGtXe7ajOKXCLupi2x1mrXaVcX6AwM+GHI4ncLZR
	lLfqQGwo6BmjGOmix9LGxQEj7EXcAp6C0FiOudVSG+fB15YkyTdXt+JWT1gew00=
X-Gm-Gg: ASbGncuEd0oxKRI80I/X8Wbo09+9m3zioMUe6K9gou+hNYfLO43eFZGwinyt+hQPYXJ
	Bb9xeH/yI9+dQ2wPiQL3RsnX7rGQn/w2E9A9Unof1y+hfzZi6DI2xpzgQ7Oqp3dD1TR1+vAS8ML
	kQm6VsyMKFBTMJPg6JaM9JA27cEG+a1LfONaPZSekC4sM5fdanEyQuZlrTyzB/Srdx0gf6fQvvR
	h2HnhSHDqqHETogb9qvwZluW8XTyI6VPRADDj9F0+SvrHhiE2NFU+ZkHMpAnH0yxcOL6Dlfa4KA
	x4aENT24cZjB4Q==
X-Google-Smtp-Source: AGHT+IF0uAlwa6gBu1gPr2dqwSyuIZZV/tSdbeIren4YqG3M6YP4kMXrRqTqSrM5G5BkGMJt/vM5Cw==
X-Received: by 2002:a05:600c:1396:b0:439:6d7c:48fd with SMTP id 5b1f17b1804b1-439ae1d877dmr24012595e9.4.1740136287415;
        Fri, 21 Feb 2025 03:11:27 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::766e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b439dsm22921657f8f.8.2025.02.21.03.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2025 03:11:27 -0800 (PST)
Date: Fri, 21 Feb 2025 12:11:26 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: BillXiang <xiangwencheng@lanxincomputing.com>
Cc: anup@brainfault.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, rkrcmar@ventanamicro.com
Subject: Re: [PATCH v2] riscv: KVM: Remove unnecessary vcpu kick
Message-ID: <20250221-11926c4f2ca3fab3b565bc92@orel>
References: <20250221104538.2147-1-xiangwencheng@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221104538.2147-1-xiangwencheng@lanxincomputing.com>

On Fri, Feb 21, 2025 at 06:45:38PM +0800, BillXiang wrote:
> Remove the unnecessary kick to the vCPU after writing to the vs_file
> of IMSIC in kvm_riscv_vcpu_aia_imsic_inject.
> 
> For vCPUs that are running, writing to the vs_file directly forwards
> the interrupt as an MSI to them and does not need an extra kick.
> 
> For vCPUs that are descheduled after emulating WFI, KVM will enable
> the guest external interrupt for that vCPU in
> kvm_riscv_aia_wakeon_hgei. This means that writing to the vs_file
> will cause a guest external interrupt, which will cause KVM to wake
> up the vCPU in hgei_interrupt to handle the interrupt properly.
> 
> Signed-off-by: BillXiang <xiangwencheng@lanxincomputing.com>
> ---
> v2: Revise the commit message to ensure it meets the required 
>     standards for acceptance
> 
>  arch/riscv/kvm/aia_imsic.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index a8085cd8215e..29ef9c2133a9 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -974,7 +974,6 @@ int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vcpu,
>  
>  	if (imsic->vsfile_cpu >= 0) {
>  		writel(iid, imsic->vsfile_va + IMSIC_MMIO_SETIPNUM_LE);
> -		kvm_vcpu_kick(vcpu);
>  	} else {
>  		eix = &imsic->swfile->eix[iid / BITS_PER_TYPE(u64)];
>  		set_bit(iid & (BITS_PER_TYPE(u64) - 1), eix->eip);
> -- 
> 2.46.2

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

