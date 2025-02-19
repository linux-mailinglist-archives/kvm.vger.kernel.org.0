Return-Path: <kvm+bounces-38556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD0E5A3B491
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 09:44:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C8FD3A1C4D
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 08:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C54A41E0B74;
	Wed, 19 Feb 2025 08:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="f9TezJNt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCED1DFE25
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 08:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954174; cv=none; b=Lo6GakcOclo+Wxgzkk6omwKHBMFfBJfWLInmRCAAkLluGI57Nr2IvvGchVhoTtlGYHSAfcas6VouLRwQ69MYxAJLq+Np4Z7FJ+0xrKq2aZEsUk3Z4oceHpHG3lfg8nCKNAkamBGwWAJND2PU1ljGBCAOMX574LSVy2TACzy4ius=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954174; c=relaxed/simple;
	bh=ZFR9Bssmw+rkM4kJMxjoQ8QQzST30QWN969X923UvhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qNrf2fMiPmvSwO3x3MBDHrHxZhL2A1oTAumDu0Cda7icy8lYizGreAj4XcxzYWS+mv1jbNEc3+5SkVKehKz+ENaKhg8eJNwEMXKSu/VoPqBDaFAW2F+8ewMxU/uXOzWcotsDOwb6tlRHKIcY4rGuasT47cVWPTJzymb7CdalweQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=f9TezJNt; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43995b907cfso9558845e9.3
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 00:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1739954167; x=1740558967; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hX5Pqy74HJXGhYd3EYVGCK1e+ORfs5MU+F8H+njiblE=;
        b=f9TezJNtOmcpId/TimX969aOFeVzhNFlS5Vj5mWnfZpPO5aZA7TQL/E2N3xS8xMjOG
         ajG15sM0KVqP5PEqhH8T1J1XZ5C/b7/cBeIJGsKjyltUzbkeMV5TbsBXJH4R6XTXTxp5
         eWMEuLThjiPYV035NMBvS/yftrUExnfC77/thRBLyBDc5mI/AEfg5VhWUZ9fkc0CK//b
         6EPo9xz8spSLRe10b8ch2/dC/WauC9u+mh2/wGN/7A8+WHrLjbSJf2mX4UVXa7uqRokZ
         FCnyVuZKV6k7vVhNA4jiwz6dOE8GGNZfqFo/dAquuhfD20ocixgLKI87+UCLFVUDRNNd
         q6TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739954167; x=1740558967;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hX5Pqy74HJXGhYd3EYVGCK1e+ORfs5MU+F8H+njiblE=;
        b=Zg0Da33XeTgdBjtdxbDFkM5QC5jqY1KiMOZb//OaSvX/jyjo5GMORNv4lW4Au6Z4TV
         AULYNoQ6f9xS2ow3A0WqYcHSFzLETNxuqdjG9Df9DdKwZ7xU58g2bRjlwjeWJOrBHNmh
         DXu2J3iF52xPRmWEhwQ7hauLkaMMwaL2e8nW6z8ZwkLJssJ0CcqJww2PsZBCJK9u0qWC
         vGrM5ZeakPBB0Wlw5Svvisv8G5fIhsQY0/ZIBKdRSvL17iPCarTCWKnHMlcm/Lj/9KRk
         yinCFhE9UoHrXft8gCUVcq71N6vY9/mUdb7ILY981Rgmf0xU52seTkE/skzGMzlQwT6M
         94pg==
X-Forwarded-Encrypted: i=1; AJvYcCWsrWGiHw3evQumgJWZXhLqODJSegoH5rzhqM4PBPugOfMnrtig5wNkx6bwZdpu3sobhGw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yys3i0/uF+AbpXgtlhcl2/U7GgHFM1pI8o7NiHswSP9zJzg3vqI
	cXqrv1DSdUgNCVjNyir3WZ0BiBm6fgjxQhtXOBombObh0T5LEXrHBvC+ukI1hLg=
X-Gm-Gg: ASbGnctawhL1anKZbtLPi/kIC41bUy8yZUTTpG9mcsVNNoSXo8yz949TBDolp4q5h/a
	H5oUactdNIA+/OYxfrFPHyOLg6QBg+JjJmYqq7tKzFVdy7Gd52R9KZq9p6I3q1SO1PwFwWrngS6
	VRp0IvJhUCU7UESEasknjaydz/cy9aEGcII7XKI6wl71V9TQMuqVDmQfVkBgz/gcJ5yQWZ7RzvB
	LaqAyyoZF/hpM8bx83EaAryDzH5FNNSfpiFv1ppv+vjc8B/w13NUUHjhm+N8gQ4XLklBFP8hfl5
	+DQ=
X-Google-Smtp-Source: AGHT+IHs4kVPkFYUzWm7KaTrDUxtzlrgRhTgXt+SxWy9TWu9laptUSWnP8MSP8v1LxvgTwxXTCCeSQ==
X-Received: by 2002:a5d:6484:0:b0:38f:4c30:7cdd with SMTP id ffacd0b85a97d-38f4c307ec0mr7919846f8f.37.1739954167212;
        Wed, 19 Feb 2025 00:36:07 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::766e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d58f3sm17085819f8f.73.2025.02.19.00.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 00:36:06 -0800 (PST)
Date: Wed, 19 Feb 2025 09:36:05 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: BillXiang <xiangwencheng@lanxincomputing.com>
Cc: anup@brainfault.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu
Subject: Re: [PATCH] riscv: KVM: Remove unnecessary vcpu kick
Message-ID: <20250219-badec60b9b12834cf534dcbf@orel>
References: <20250219015426.1939-1-xiangwencheng@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219015426.1939-1-xiangwencheng@lanxincomputing.com>

On Wed, Feb 19, 2025 at 09:54:26AM +0800, BillXiang wrote:
> Thank you Andrew Jones, forgive my errors in the last email.

From here down is all exactly the same as your first email, which I
already completely replied to.

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
> 
> Signed-off-by: BillXiang <xiangwencheng@lanxincomputing.com>
> ---
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

