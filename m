Return-Path: <kvm+bounces-18499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2EDD8D59F5
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 07:42:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9011285CBD
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 05:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454E67D096;
	Fri, 31 May 2024 05:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="z8G6tu6o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E1D52F6A
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 05:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717134141; cv=none; b=eCzT1SRn8KogUci/qsU7bjqzf0aSq7RG5/ib40iHQUx4Htp4M4YlMjiftGDAkU3Md9oNAjjrVdMT0syRq8LDA41jvtbEpuqoD/XuhHzPHt4MynkhrGc5KDcUiyiV0BP+jkWrLgg5F8ghz3dkKYyCcdQpolXCjCfOk6atGsZ0VOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717134141; c=relaxed/simple;
	bh=xBhn4FqMHr7qVwz2luiXPl37K5D2EBhvaRA62rusHzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y4y+glFOjfCKhm1Ar6jtAPVoQiYrkWLbypOQJfoMUIU6RlBfssEFXoujtlULtKrx61Pq2Aalmnh2upxR9+gLXacKLcAL27yvxa3/9OrkJyMLc6RNniectqmVYFGf11hnXRO1JSS6GKvLl5VvDDiztvOXTZMoiC1+zD5DrL8Msiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=z8G6tu6o; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7e2025c3651so71190339f.3
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 22:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1717134138; x=1717738938; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7O7d9Ggj1euHigzWUl/7tmCoiCMPOOy96o4IjkVfxbc=;
        b=z8G6tu6oIZOcw2uW9LUlQkfHRRjrkO9n+zoSWzwm6Cuo+k13j2LRdW5Wl1yuFrrpLV
         D532b8FtzrxhC2billrlDMQUVw22BHG8gNJTpAle3+a92HMpMU08l+eqFum0I50E3dUy
         jvRb1z1zH3Cv2/jEmJfgnt+i/THZeHBRHzBH07slzbknHZPr6U080ooV9ScKXOR/Nqh7
         wjG5jIKc1PC/tE9kfth4Pg5QO6EzPyarqSakTfZd3NQd8jbAJ5VJxsvoq6HW6gJKXru5
         A1RgbulEjbjeNh+U6c9XZR1PAiYSRjKwX3jFSd/G0Eku2wHIl8r6IZMkR6X49tVbkw6Y
         hrQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717134138; x=1717738938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7O7d9Ggj1euHigzWUl/7tmCoiCMPOOy96o4IjkVfxbc=;
        b=Yrb+3iYM3dmtH6uSiJuQDIzH3rx/cg4PePSFcOIKKZ/lHe7G6GAzL9ht6IeZ/R2VmN
         BMeyANfCvcu2GoPwAk+HbRyZh0ygN2YUct2/2OYC/sXJFFKER10sfsI/ot1HAoijCN+o
         J7qX2QBv3DpYFSdTfaRGakNyB2HayWZS8q8f3HomVEj3AUQMmhmdqeq7EOrQRl/pcbvp
         DZ9hHqzf/MmgmRPivXWXcy8AZsy4tgNAJHXptew43or1QT2oAcYE7kSegHOW/mbDp1jL
         YyA9QkZ6SfbQgfU4WlQkRbraot4xCEr/04WOJytkAdYuDKqEXp1CR3bAcSCWG0ztP8Wc
         CZCg==
X-Forwarded-Encrypted: i=1; AJvYcCWbO0ToTiAoEt6e9cXe8xXR/jKLzUV6CRIXw9b84EQkvKg4FPx/PuCNKAPwp4oQr6435uMIF17a1sBYHZNHcSGllsDB
X-Gm-Message-State: AOJu0YzIdyGM0D5L47uaDPMwgnxvDo/npeFyNYxoXBj+Q2fycNQHB/Z0
	54gEXt2E7kY7ARAirbI4/gZUHS143xlF591pvHnHO9quhfw1+01+AUBX2FcTlXEZUEWVYF7zw/w
	eqGAzvrwy9XxWCG98pFrf/eyJEgmwfCH61zMfFA==
X-Google-Smtp-Source: AGHT+IEtj9pGF5vtAyZZfL+KJ2BJbeEtCqJtl3SIrkwKxUBy8V/vzqXxMBy/vadTFe0iv23wkzuDXFNgfcG5jn+EYHg=
X-Received: by 2002:a05:6602:2c02:b0:7ea:cd68:d235 with SMTP id
 ca18e2360f4ac-7eafff45e66mr121858839f.18.1717134137673; Thu, 30 May 2024
 22:42:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ff1c6771a67d660db94372ac9aaa40f51e5e0090.1716429371.git.zhouquan@iscas.ac.cn>
In-Reply-To: <ff1c6771a67d660db94372ac9aaa40f51e5e0090.1716429371.git.zhouquan@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 31 May 2024 11:12:05 +0530
Message-ID: <CAAhSdy1Mjx5cq0Gim3TBFSCNbCJPvMxkRSC-gW6KjFeGBrg75w@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix incorrect reg_subtype labels in
 kvm_riscv_vcpu_set_reg_isa_ext function
To: zhouquan@iscas.ac.cn
Cc: atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2024 at 7:43=E2=80=AFAM <zhouquan@iscas.ac.cn> wrote:
>
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> In the function kvm_riscv_vcpu_set_reg_isa_ext, the original code
> used incorrect reg_subtype labels KVM_REG_RISCV_SBI_MULTI_EN/DIS.
> These have been corrected to KVM_REG_RISCV_ISA_MULTI_EN/DIS respectively.
> Although they are numerically equivalent, the actual processing
> will not result in errors, but it may lead to ambiguous code semantics.
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>

Queued this patch for Linux-6.10-rcX fixes.

I have added an appropriate Fixes tag as well.

Thanks,
Anup

> ---
>  arch/riscv/kvm/vcpu_onereg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index c676275ea0a0..62874fbca29f 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -724,9 +724,9 @@ static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_=
vcpu *vcpu,
>         switch (reg_subtype) {
>         case KVM_REG_RISCV_ISA_SINGLE:
>                 return riscv_vcpu_set_isa_ext_single(vcpu, reg_num, reg_v=
al);
> -       case KVM_REG_RISCV_SBI_MULTI_EN:
> +       case KVM_REG_RISCV_ISA_MULTI_EN:
>                 return riscv_vcpu_set_isa_ext_multi(vcpu, reg_num, reg_va=
l, true);
> -       case KVM_REG_RISCV_SBI_MULTI_DIS:
> +       case KVM_REG_RISCV_ISA_MULTI_DIS:
>                 return riscv_vcpu_set_isa_ext_multi(vcpu, reg_num, reg_va=
l, false);
>         default:
>                 return -ENOENT;
>
> base-commit: 29c73fc794c83505066ee6db893b2a83ac5fac63
> --
> 2.34.1
>

