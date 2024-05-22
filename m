Return-Path: <kvm+bounces-17937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 338398CBCEA
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 10:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64B551C21FA8
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74B58004A;
	Wed, 22 May 2024 08:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="HL33OQuI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3E88003A
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 08:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716366301; cv=none; b=aADYHlaE69Bd2LGEYrDsJgJUAgjSoxGDS5RjaN3Jan8MvRPVTAZtlfn8mlRO8HkDlfjp6BCb4qcxiYJ8KEoVXP8GRP1j/dmwi/zAc8aGRr8Zm5LRDjQBiIKjS6hVWcR5AlT5H2k1QUFQGFa8/M9mT0TgWtMPhStZs5Dp7ArhX2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716366301; c=relaxed/simple;
	bh=ZZjOtieCe2E0oa/JksMhIScdEBtDgFgRJ00fyxssCEY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fl59C0FPrR+dIIdMQ035HnSEpoGIsXJoJXXwWtK3QnYmsTqSG3AyC0sE2U4lNTbJqZZ+63GtKylTPOAA+mMdlQgQ7sC51V1VyY2Vzx7ANfoZEinfVysr/lHOUgGNjqivBinEq+qAevylbtFk4yvmwMsc2wjnXlZRp70qRivod7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=HL33OQuI; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3cabac56b38so817984b6e.3
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 01:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1716366298; x=1716971098; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryQmKzk8MS5bOTQ7tYWhiPdYPLdCvZh4q9YKiDsePQg=;
        b=HL33OQuIIXO+jXY6kblTsqFQftIW4anjuFgUqYEsel+ggTbDESo6oZMK3mHOu1bLwV
         YBO3lQN9agZUeL7x0pnLtu7Ph5GMYCABKexqye/seIqmw6TdC+MRdpqhSFEeLGDcCj7C
         EEWqE53Yj8MIYAsA8VMZ4v9u/sPxb8wfJaDD84KSDZ52SGtN2c4Ryb2ep1UWIVDwHMeO
         F4xVnxo3UmPgju0lGFwHUNgYCIkSmO9PyL0UZKnn5jvwfwU7AYl3DyneVbwkz1VSTEKG
         iYP6LSJe/oN+/Un3iJgXrMGCbdaha7dbLDh3RRe7IB3CLJkVdJd05aLSLFeTapI2iE2I
         Cekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716366298; x=1716971098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ryQmKzk8MS5bOTQ7tYWhiPdYPLdCvZh4q9YKiDsePQg=;
        b=fxvlYGK0yOnWUVrHCIjnO3GQxEaMBaNwz0lfzMtE72xHrmE3ZLXSHjmB5lbHl727f5
         Dr8Lm2z40VquyLZegrCR74zDAG6Nq18iHLhbRc3y2mUem8zJfAewqyUbiSC5NTxllqY5
         qYZxGzoRQTIuEzy/Q7H6T5d0jApkdFB/YKF8I04yf9fMJ7FaSyRMK3pSsZJaVXl55EKI
         XFiDc8zNysU2DoKUkZcpwAxSiyiJWwIsugholLSN+2VYBCtl6Ea1GRM5tcOHQpxgUIuo
         Dgdg1EZj1h1RpEfwSjTBqwn+BGDO1KDDipXcGVMAf2bPpPlSQDCpm9bapO5ZWqgrRdDE
         OzyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUj1Wl4Ple/evtosgdqfN8MHw1LD6h72AcnVRjeZBJyQ78kVhhz/cBlAzkzYV/0PTzFRG0Wy1ttzTLn9Dw3VtrMOTT
X-Gm-Message-State: AOJu0Yy7rRZKb1KuUf3nEnybBlAGe2SruBxqERg3ssv08LzLgeeuw6Oq
	AuqPml7HCHWmU0VHzNVdbO63g7Y5YtnZ0Xlqa9hciJb3F5HzaYgiPG2DrMAZJyEdL2qgnSIwJaN
	wpMmgKx59tGN+w5oRjIoY9ogg36a0zmNl2sj8AQ==
X-Google-Smtp-Source: AGHT+IF4k+kxPGLcYD0POCnK9OmyQ9preI608Hi2OXykANc9ri4/InnJ5s0XE9eRonrivkbfast3MVxc50oCdnXsClw=
X-Received: by 2002:a05:6808:140e:b0:3c7:4db:9769 with SMTP id
 5614622812f47-3cdb6c6eb3dmr1592357b6e.47.1716366298226; Wed, 22 May 2024
 01:24:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240415064905.25184-1-yongxuan.wang@sifive.com>
In-Reply-To: <20240415064905.25184-1-yongxuan.wang@sifive.com>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Wed, 22 May 2024 16:24:46 +0800
Message-ID: <CAMWQL2jvNV70dX46J+EzUQXxw1yzVGzB2+knuPFiWK7mF2TfFA@mail.gmail.com>
Subject: Re: [PATCH 1/1] RISC-V: KVM: No need to use mask when hart-index-bit
 is 0
To: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org
Cc: greentime.hu@sifive.com, vincent.chen@sifive.com, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ping

On Mon, Apr 15, 2024 at 2:49=E2=80=AFPM Yong-Xuan Wang <yongxuan.wang@sifiv=
e.com> wrote:
>
> When the maximum hart number within groups is 1, hart-index-bit is set to
> 0. Consequently, there is no need to restore the hart ID from IMSIC
> addresses and hart-index-bit settings. Currently, QEMU and kvmtool do not
> pass correct hart-index-bit values when the maximum hart number is a
> power of 2, thereby avoiding this issue. Corresponding patches for QEMU
> and kvmtool will also be dispatched.
>
> Fixes: 89d01306e34d ("RISC-V: KVM: Implement device interface for AIA irq=
chip")
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>  arch/riscv/kvm/aia_device.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> index 0eb689351b7d..5cd407c6a8e4 100644
> --- a/arch/riscv/kvm/aia_device.c
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -237,10 +237,11 @@ static gpa_t aia_imsic_ppn(struct kvm_aia *aia, gpa=
_t addr)
>
>  static u32 aia_imsic_hart_index(struct kvm_aia *aia, gpa_t addr)
>  {
> -       u32 hart, group =3D 0;
> +       u32 hart =3D 0, group =3D 0;
>
> -       hart =3D (addr >> (aia->nr_guest_bits + IMSIC_MMIO_PAGE_SHIFT)) &
> -               GENMASK_ULL(aia->nr_hart_bits - 1, 0);
> +       if (aia->nr_hart_bits)
> +               hart =3D (addr >> (aia->nr_guest_bits + IMSIC_MMIO_PAGE_S=
HIFT)) &
> +                      GENMASK_ULL(aia->nr_hart_bits - 1, 0);
>         if (aia->nr_group_bits)
>                 group =3D (addr >> aia->nr_group_shift) &
>                         GENMASK_ULL(aia->nr_group_bits - 1, 0);
> --
> 2.17.1
>

