Return-Path: <kvm+bounces-44256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58E6BA9BFB2
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:26:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 900B446696D
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 07:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A0322E41D;
	Fri, 25 Apr 2025 07:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="G+Ng+RFl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC141F4CAC
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 07:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745565998; cv=none; b=dVZjwmJ9++fXRsuRKeKKC5DVsYy3HMu4CvwSx1e0gAljLjE6yk6orNhSaQ9VWZnSPpWvt/1J8ov0GD3T88o34md4e8CAmTbeJk4N9lj8zUXuRWeCEPg1voKskAa4M0LoskYe9rt3Ypo2cDcZ5TkdTT/s+ItjAY6I0B/WfF8K7wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745565998; c=relaxed/simple;
	bh=WOBxNFfwoRaqVofbA8CFrImfGjl5LQJoK5Bx9c4gVxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ee8dWtoLRA7mdAtK4Zq7xeT9RlXD/4BaZhvkUbbHrzkbf7LFi/xbwBtSLtpqHwwVbdayffmIPcCgNKM5zv0a3aSawqWQgwUSGhhNYoq/wkZDA+3qyRI5WsALpRmL/yULkAU+3l+dp2DDS3Ijw/T9NUYSUEiHWGHXBw+oOPRvl24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=G+Ng+RFl; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so16916215e9.3
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 00:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745565995; x=1746170795; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8rOWai1sdUbgwofhh5Gm/RhS+Xf+8kuHnQc4bFrAWfA=;
        b=G+Ng+RFlzYMB95D9S5v5mPE8PcsRJ+L1L53MKVN24KeRO0aiqd2jh6Bld+oP7/FTnF
         SkxdVOfCuS0AZftZ3RNo9LdO4Yt3nbRjbTHDkTEA+Yf+5ufOIkCN8NoC98ct4dlRMpX6
         FAcm9IFJHebAuAI7TC36AJWyR22iT1O2emh7tqsxGApLAPznuLaWnD9e1gy3XkVbF3QK
         h7+WTN6oqgnfLWpBmJIDkCiar93TU0TO+Ibhauzt5GbaZjzlGI9dJ0ZAq9T+Nhienavx
         kGVyJcBQB2LtVdNcJDqV5Vc+W6GL4vQAAHmDWGOU/2erL2LypG9vDzNR9n1VNVIpz8Fc
         3LzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745565995; x=1746170795;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8rOWai1sdUbgwofhh5Gm/RhS+Xf+8kuHnQc4bFrAWfA=;
        b=P2d1M9u7pQ9LOEua7cVKN/0SWcMEbXwsPiMt8HXtbhoXFzG36ClNXgXphtkIdHV7Vk
         snSpsA/1q/Gb63K7IxZlIeJcGPhJd7ihm6dm1hGvX0lmPkbMhyFiET/Mt1P3yPSQRIGm
         Oan0oW97SIcuEjY4e83tErCpQts46DQxQybriVClWvd92GdNJGo3m2QXC3qCVs6+B6Xt
         HkGXlip0Kb/OXlArt7mWF2UkPC0/lC3GcWSrmLWYvnM6SER5zcYSZo8ygHrRSjRfvgJN
         temk4OKoI03rUfV6lSQWvOrG6mQiukBEaOEiPV7ix7kKRMiaNK4chqoQ05VRnt/QWXXn
         sr+A==
X-Forwarded-Encrypted: i=1; AJvYcCVSydZGvFbKP4bB06jTJIeWhz00qHm7Ur8Qt2mibr/a3BKTDfOjRuCi2Mhturnl51GOubY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxH4V+1kBfGDTOTC93mILhqmgOceizSgg6Ak5oOF3IhqLEtoQ40
	R+HUnCfZEuNIm1jAyHBG4pNm4L5otFw4sVMTQ1Tdibb9ZCJdTgDQo9252QgXWwM=
X-Gm-Gg: ASbGncvy6fOQ4zV1gNl7h5GQdYG//6fRCZlN2GZf1fruPHRE21igKURKI+Lbmzx8ADE
	cH25LLJbvStnFz1MRV95JlDQ6bXng+bfXgd1HazfZ0NLe2FBrq0lterisuQoLUqjtFzz2yfiTnI
	yPNl1UNoxmvSxLeyy9ByXJb9O86mOy6H624sTyH2Z9dZm/uBnRRvV3eOS6ezeMKuatWP3S00cU8
	/riwFuP+j/61cfm/099nvvkTDQgM+aXXjoxTbeFoF7XAVPBOxHvZVUo3s5hPL6oV/wkYjk9lpUl
	2xW3JPxQFAkWMkWy+JVWPP/WJA+4
X-Google-Smtp-Source: AGHT+IHyL/iAGxsNCgxot5kbeyyZgpCwkYAozWtkwnyndNThNfSseLduEbxfeuXjaZvP1Jxj6O0QvQ==
X-Received: by 2002:a05:600c:34ca:b0:43e:a7c9:8d2b with SMTP id 5b1f17b1804b1-440a66aaf1bmr8945465e9.24.1745565994713;
        Fri, 25 Apr 2025 00:26:34 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2aab65sm46521075e9.17.2025.04.25.00.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 00:26:34 -0700 (PDT)
Date: Fri, 25 Apr 2025 09:26:33 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 2/3] riscv: Strengthen duplicate and inconsistent
 definition of RV_X()
Message-ID: <20250425-93c9f462a1980ebd7bbc515d@orel>
References: <20250422082545.450453-1-alexghiti@rivosinc.com>
 <20250422082545.450453-3-alexghiti@rivosinc.com>
 <20250424-f322adab22126ae97dd7c5b4@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424-f322adab22126ae97dd7c5b4@orel>

On Thu, Apr 24, 2025 at 10:45:46AM +0200, Andrew Jones wrote:
> On Tue, Apr 22, 2025 at 10:25:44AM +0200, Alexandre Ghiti wrote:
> > RV_X() macro is defined in two different ways which is error prone.
> > 
> > So harmonize its first definition and add another macro RV_X_mask() for
> > the second one.
> > 
> > Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/insn.h        | 39 ++++++++++++++--------------
> >  arch/riscv/kernel/elf_kexec.c        |  1 -
> >  arch/riscv/kernel/traps_misaligned.c |  1 -
> >  arch/riscv/kvm/vcpu_insn.c           |  1 -
> >  4 files changed, 20 insertions(+), 22 deletions(-)
> > 
> > diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
> > index 2a589a58b291..4063ca35be9b 100644
> > --- a/arch/riscv/include/asm/insn.h
> > +++ b/arch/riscv/include/asm/insn.h
> > @@ -288,43 +288,44 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
> >  
> >  #define RV_IMM_SIGN(x) (-(((x) >> 31) & 1))
> >  #define RVC_IMM_SIGN(x) (-(((x) >> 12) & 1))
> > -#define RV_X(X, s, mask)  (((X) >> (s)) & (mask))
> > -#define RVC_X(X, s, mask) RV_X(X, s, mask)
> > +#define RV_X(X, s, n) (((X) >> (s)) & ((1 << (n)) - 1))
> 
> Assuming n is arbitrary then we should be using BIT_ULL.
>

Eh, scratch this. We know n has to be 31 or less since these macros are
for instruction encodings.

Thanks,
drew

