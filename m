Return-Path: <kvm+bounces-50249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79EB7AE28C3
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 13:21:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B41263BD027
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 11:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99DDC20D4E1;
	Sat, 21 Jun 2025 11:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C9fUaMmt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D010B2745C;
	Sat, 21 Jun 2025 11:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750504865; cv=none; b=izXt+qMEgtDCXahfhlmhO05TlJwkO0FLi7i9nEH6FZN0sUvfDPsQ0Rws1a1EZF8zQwGP47Ce99Nw9+BoMNvZpzj5HvGPFre0aR69l3XdlkqSdXGTQFe9qDMtEkV6Ueq18k+I7CkDUj3M1zhxLPdLukglU/LBQewXDHrjA+zeZQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750504865; c=relaxed/simple;
	bh=NR5ZXDg0NMK7LZl7jdtTqHrpcosN3wt+H3ZvZL64uuA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gww6Uge/dXME+wuxc7o2lWhsV8DqaRAOjf9fql6fOZpJ7vfBAzUi/CCGRo6lgUBnhV0aAvTfXIql4QGIWQEwvu6t37EcQSVcMqexHqpbPRyKVKy6gGedP4gPY9CZyRAOMlLI4JVINtwR+nEMtPZNrYEyk6oDe66fJTfNvV3tmL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C9fUaMmt; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-453636fa0ceso18661645e9.3;
        Sat, 21 Jun 2025 04:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750504861; x=1751109661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TVtHXMoHrZpItcZ9JNMwabBUxiaMZC31W4Vj2gMNddg=;
        b=C9fUaMmt/zQSHNMJwFLGtEYDinTX7XnL/DxsERk0APy/z0VtXOeJmuPpskJ3MGZkrd
         1dUOL1fyu8LtRO42i4/xxvsHxcmm32VOZhCKAXghKWE0RmC8KxMgFS7j2tEC4f9l4K1H
         1Bj3qgrnwv7AOMwXs7an4aYYIVU1I8Iw0uFXyRJzB84ONqnuc10VEDgfkWOWGTQC/ycp
         AXfuBaJ+OFcn19/NExei6t0BN8d8bINLoq0IjXyx9pA2XT8kb7lev/zGAJiNzzjT/X1M
         eS2jVzwtC9v6pRCP82jWsuVjIgKTPByyUr7sv6PdZc4FyjZqmWOP/CqGOolKL8yN2rH5
         QUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750504861; x=1751109661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TVtHXMoHrZpItcZ9JNMwabBUxiaMZC31W4Vj2gMNddg=;
        b=oSxm9drFjkHwxkd2/PCXe/0CiWdmj13Yf5q0LrLxBIceBoaXCw6XViI4sFIH9qJTwe
         bOdGyW82g4lMu4/eIZ415Tdg5AlMGBQMVvBndnK/xopLO2t5yTIXi6ZgPsdg0h/aFwK/
         kSXZLUDLBRIzEOydaRUcz/VWAnrCftkYWtV2opwlF5MCEUTEHyshWjl1thxqw3q7O7VA
         dInRabQXzIZX+SyaCy7L2G8C8z/9DLiDeC9zvm8OSKFDJTEp2H0wbQeDLgIW5LJy1+XG
         MEE5uGVQzX6v2oSLwvbBS/xSJYrOWbGPTIEySpIDPyOlCnZBGykDABH/Nl2Y542ru245
         qazw==
X-Forwarded-Encrypted: i=1; AJvYcCWnB52WIyq1ELvarf6F+KRvQF1sLUfhboirkqIxFu0VTD36zfqdBYBK4iUOJgbo/puT7djFr3NapDVgHO+E@vger.kernel.org, AJvYcCXUnVm79Cf7UixJdfFluyNnzmxnh/ieeNYD6+SeNAvNgY0UlccSCkw9IIcS4QlhkXGgK9E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVnj34Ijrq8XEhybBwFe05LLiWdMEHjZDFvUqUcWnKAzCjrlIr
	d/lG/V42csbOjg9dZGjUkMNG1hJknyt7Qr30ecrpizDM0NFDN8PZpgN7qLk4iA==
X-Gm-Gg: ASbGncv25fexLfjdBeGG9T4MreJVs4jSOtgr612hTqG1LE5ONVJbt7EE1Qe3hQZ5gBo
	W3JfXNH/gvYxYQPmG4TRisoZWZE6uBMhTTQJIr39cPrxsUiecC33XZAbTHUKGjK3deg2P0tBXVG
	2TVM2H9FPFAfl5XJTvAzkop4LbNoV+5HaL/P//a9G8EYutb8g5mljZfWVYoJIo6n1bcc6CqRxAC
	E+ad63J7isQewpn3DzOtrb7Zt0GncDFvfKry4XdXNrzq7GteWpoI8/SNnTqv6OlyUHVsMyXpDwz
	8pzghe1ObU6s/QTjsVNqw5OUMEfPKoKUmxZnLUCJMt/jpiDs5iyM4py3TiUVcvP3BGZ7A9dNu0s
	rPa8vcjl6OA8feAkIKYfiKSnl
X-Google-Smtp-Source: AGHT+IFjYknI/NeOW18++Rn42Mxx5swXjhEFW71pYEimDWbmXgcrBx4iFJVHTv3S7pkDar/TjlhEEA==
X-Received: by 2002:a05:600c:a48:b0:453:6b3a:6c06 with SMTP id 5b1f17b1804b1-4536b3a708amr19192415e9.29.1750504860877;
        Sat, 21 Jun 2025 04:21:00 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535e9844a9sm86192885e9.12.2025.06.21.04.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jun 2025 04:21:00 -0700 (PDT)
Date: Sat, 21 Jun 2025 12:20:59 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Bibo Mao <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 9/9] LoongArch: KVM: INTC: Add address alignment
 check
Message-ID: <20250621122059.6caf299a@pumpkin>
In-Reply-To: <CAAhV-H6Eru5e6+_i+4DY9qwshibY43hjbS-QC-fhLD04-4mOGw@mail.gmail.com>
References: <20250611014651.3042734-1-maobibo@loongson.cn>
	<20250611015145.3042884-1-maobibo@loongson.cn>
	<CAAhV-H6Eru5e6+_i+4DY9qwshibY43hjbS-QC-fhLD04-4mOGw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Jun 2025 16:47:22 +0800
Huacai Chen <chenhuacai@kernel.org> wrote:

> Hi, Bibo,
>=20
> On Wed, Jun 11, 2025 at 9:51=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wr=
ote:
> >
> > IOCSR instruction supports 1/2/4/8 bytes access, the address should
> > be naturally aligned with its access size. Here address alignment
> > check is added in eiointc kernel emulation.
> >
> > At the same time len must be 1/2/4/8 bytes from iocsr exit emulation
> > function kvm_emu_iocsr(), remove the default case in switch case
> > statements. =20
> Robust code doesn't depend its callers do things right, so I suggest
> keeping the default case, which means we just add the alignment check
> here.

kernel code generally relies on callers to DTRT - except for values
that come from userspace.

Otherwise you get unreadable and slow code that continuously checks
for things that can't happen.

	David

>=20
> And I think this patch should also Cc stable and add a Fixes tag.
>=20
>=20
> Huacai
>=20
> >
> > Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> > ---
> >  arch/loongarch/kvm/intc/eiointc.c | 21 +++++++++++++--------
> >  1 file changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/int=
c/eiointc.c
> > index 8b0d9376eb54..4e9d12300cc4 100644
> > --- a/arch/loongarch/kvm/intc/eiointc.c
> > +++ b/arch/loongarch/kvm/intc/eiointc.c
> > @@ -311,6 +311,12 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
> >                 return -EINVAL;
> >         }
> >
> > +       /* len must be 1/2/4/8 from function kvm_emu_iocsr() */
> > +       if (addr & (len - 1)) {
> > +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", _=
_func__, addr, len);
> > +               return -EINVAL;
> > +       }
> > +
> >         vcpu->stat.eiointc_read_exits++;
> >         spin_lock_irqsave(&eiointc->lock, flags);
> >         switch (len) {
> > @@ -323,12 +329,9 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
> >         case 4:
> >                 ret =3D loongarch_eiointc_readl(vcpu, eiointc, addr, va=
l);
> >                 break;
> > -       case 8:
> > +       default:
> >                 ret =3D loongarch_eiointc_readq(vcpu, eiointc, addr, va=
l);
> >                 break;
> > -       default:
> > -               WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx,=
 size %d\n",
> > -                                               __func__, addr, len);
> >         }
> >         spin_unlock_irqrestore(&eiointc->lock, flags);
> >
> > @@ -682,6 +685,11 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
> >                 return -EINVAL;
> >         }
> >
> > +       if (addr & (len - 1)) {
> > +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", _=
_func__, addr, len);
> > +               return -EINVAL;
> > +       }
> > +
> >         vcpu->stat.eiointc_write_exits++;
> >         spin_lock_irqsave(&eiointc->lock, flags);
> >         switch (len) {
> > @@ -694,12 +702,9 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
> >         case 4:
> >                 ret =3D loongarch_eiointc_writel(vcpu, eiointc, addr, v=
al);
> >                 break;
> > -       case 8:
> > +       default:
> >                 ret =3D loongarch_eiointc_writeq(vcpu, eiointc, addr, v=
al);
> >                 break;
> > -       default:
> > -               WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx,=
 size %d\n",
> > -                                               __func__, addr, len);
> >         }
> >         spin_unlock_irqrestore(&eiointc->lock, flags);
> >
> > --
> > 2.39.3
> > =20
>=20


