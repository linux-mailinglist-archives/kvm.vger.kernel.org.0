Return-Path: <kvm+bounces-48716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44220AD182D
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 07:02:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DC9F1698AA
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 05:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC2D280001;
	Mon,  9 Jun 2025 05:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="KtCdTPJH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84F92746A
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 05:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749445315; cv=none; b=LELHEgg3lE8qupJsY+tiIBMAyo6B5YeHoXD0SswH0kvwVgrdZdueSc+ly05f7rn/A+ppkeZxZMe3M4VTYclSlHGOr9Od37UZ89Hubuh9eCDGnTfIeDiL1Q19X67Uqb8iLcfNyKeEEZN4x2B5yDTcBvF11UKo4c3PkpWO37fL7r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749445315; c=relaxed/simple;
	bh=Zj8k3HkK/FoiffBM5h35ABkSn0Y9vTnhX20e6BB/zfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c5KVOs8HD0UGcPXyc8gdIlIw3JzIJX6OhtqMr/U3mzeoPjo+2lXKfVgQi61OuIUOCK3bXetz0RC3wWjZ5kooXP9G+ZaCLfyWwJtsjRcesJ5bvyLQtHcMyb+Y1B8aKvIZbFS42bBQ/aOfnnP1Dcsa+mzrS1BvVtFo6VS4m8btpJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=KtCdTPJH; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5532f9ac219so4579727e87.1
        for <kvm@vger.kernel.org>; Sun, 08 Jun 2025 22:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749445311; x=1750050111; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qOMcjGbCg5jsFQHyOHp8QkLmffXsMI4hIXBXUWTyrTY=;
        b=KtCdTPJHw0HsawP3alP5azgcaH0f34affEbRzmVURFnlYIUWz6jOyK6Tc0RNyFMbdb
         M9vc22x/Ra/WxSpzVoE5AHuYFM7RR7/qbgbMCnQ3wpp6NjbN3VGUCif7CshCRN34159y
         fvj8qNQZCiXvk/Bibk403mLVuPoo3Hrfukvkl0zoKHtuQe2tUYJ6GWzwykK6oEicqnSb
         aFv9Eh1V3j0ckA66dsztVKX1i30fNe7P6bk485wJCLi0+3WeougZvVfMBZA8NV8RXvU2
         oXC+cb6+vM+DMi9Ksua3pSexyM7adtFeJe6YAaMU1mgXxCkUpUiYrC+C1lYyNWTa6o24
         wvwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749445311; x=1750050111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOMcjGbCg5jsFQHyOHp8QkLmffXsMI4hIXBXUWTyrTY=;
        b=NCwCDtoFk5EDOdgSh/PE1eZ6wy2qyF5TIgp2W6qTsl3HM73Rksv7U5UcCGmqgRje9i
         DhdrIHGTO+EvEoBe0EmI08By4C60iRKE+MHFY8W7AEGdM2NKyOPuQL6BeO5WLi5Y/rq0
         EMRobIoJ/dI3XJw4Sm0iZxxhiRS4OK7yPN5teIpuQj7z9aCtTQ+zn9sGNEfrftQzxtiX
         NkJSL6n3ziXjI2gK49ZuWqBe1o7Fhr2ApcVuik8p0DDjh9EnXZEWORIdrrfzLskoXdyp
         9+NWh+86dRiCxkRil8vRAPYTKhUeJ5G/g0J0+ckekwH8vbSPbRMX4jnpUB+78y8tCZNm
         umOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDTvGeU/VPUhPpNoZWfQZdsBirud+8akdpmYcPxQ4PKqXnWVf5aKorAcIFctE2Uk3Z448=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlSEgvdyBJEQNoSGmBZAeD0MOQzre2suQbDNtaLzWRNLUnqCvT
	rNocfqIyNz7+/17NKq+y6ysyeyUcOrDTH+xOB66rJ9+9DMuR6z/LZIje4YqCQRTsPvjswixE9cX
	fdHrciUdcJFuxAaZM5L6xm9BjjUudlZRex+lv+MTYAw==
X-Gm-Gg: ASbGncs3XIqlZXVWSFdjDS7tetceTuK/qgASDr2MfnpYDbSAk6oAu+D8zrvDlHJRVFl
	62FoxA3CKap1akcNQwyj2uZJDuDxjL0znod0Jr4BX11EsAOkbSMKvzstDLadlZn/AXjA1hBnJK2
	a3NDAY2Pe/+DSC503TCP7YEob3ooDlbuoPFg==
X-Google-Smtp-Source: AGHT+IGNoFMBVcIkhkWIxs1T6dpBKHVyU1+GA9Sn2XOqGmubTKzpGdkqTqGYa5lWFnUt1IGgZ9ywL6/bb9mRRWona4Q=
X-Received: by 2002:a05:6512:b96:b0:553:2e37:6952 with SMTP id
 2adb3069b0e04-55366c35b56mr2725861e87.55.1749445310725; Sun, 08 Jun 2025
 22:01:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605061458.196003-1-apatel@ventanamicro.com>
 <20250605061458.196003-4-apatel@ventanamicro.com> <ed5276d8-5169-47fc-bef2-bde7b8979e7e@linux.dev>
In-Reply-To: <ed5276d8-5169-47fc-bef2-bde7b8979e7e@linux.dev>
From: Anup Patel <apatel@ventanamicro.com>
Date: Mon, 9 Jun 2025 10:31:38 +0530
X-Gm-Features: AX0GCFu6khb6JAs3hfg5t5-XeCYErlLBCVttXYRvddGA_uZhl6kG6tBxdop0a2o
Message-ID: <CAK9=C2WWtOdG9aYhmrTnDNoV9f0VBYUENJ8utKd=4G9-1SyzdQ@mail.gmail.com>
Subject: Re: [PATCH 03/13] RISC-V: KVM: Check kvm_riscv_vcpu_alloc_vector_context()
 return value
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 5:46=E2=80=AFAM Atish Patra <atish.patra@linux.dev> =
wrote:
>
>
> On 6/4/25 11:14 PM, Anup Patel wrote:
> > The kvm_riscv_vcpu_alloc_vector_context() does return an error code
> > upon failure so don't ignore this in kvm_arch_vcpu_create().
>
> currently, kvm_riscv_vcpu_alloc_vector_context returns -ENOMEM only.
>
> Do you have some plans to return different errors in the future ?

Even if kvm_riscv_vcpu_alloc_vector_context() always returns -ENOMEM,
the caller should not assume anything about the return value.

>
> Otherwise, the code remains same before and after.
>
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >   arch/riscv/kvm/vcpu.c | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index e0a01af426ff..6a1914b21ec3 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -148,8 +148,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >
> >       spin_lock_init(&vcpu->arch.reset_state.lock);
> >
> > -     if (kvm_riscv_vcpu_alloc_vector_context(vcpu))
> > -             return -ENOMEM;
> > +     /* Setup VCPU vector context */
> The function name is pretty self explanatory. So no need of this comment =
?

Yes, no need for this comment. I will drop it in the next revision.

> > +     rc =3D kvm_riscv_vcpu_alloc_vector_context(vcpu);
> > +     if (rc)
> > +             return rc;
> >
> >       /* Setup VCPU timer */
> >       kvm_riscv_vcpu_timer_init(vcpu);
>

Regards,
Anup

