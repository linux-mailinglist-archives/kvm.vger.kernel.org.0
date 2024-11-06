Return-Path: <kvm+bounces-31020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A17139BF508
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 19:16:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 597021F21B6B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C733E2076DE;
	Wed,  6 Nov 2024 18:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0JtvWboH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B7B1922FC
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 18:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730917009; cv=none; b=AsuKmn3GDZaa7Duxh+HykNdYnv/1QKG4tEMMo2IVrLoLxnmbEEwj0JbFqrE/xzwtAp/bqO6wTqaBJwCP/n0UM/0DzhceLeDXNpl5w/m+UbfKDo6ONljWfpcOKZ5X6Ybv8gOlUhH1iEmXmhc4SDlbSlsC1QOrXtKxvJEO2q3hygw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730917009; c=relaxed/simple;
	bh=akr2pHWvlpxX6Fg1IQ3TT51LBTF7P5k6M3NIk8ktde8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n4Uj1oZOF9/i4MhZIV3dUy1rIlalUYBnPtKPAw/B7wDTRJ+S0oPmaCKv9E74OHB+xaUkHZRt5+GVL33LHITyhmGezqEqktec/MvuNPeD9iI9Et9X4rb5LylRCvVUmQA10W48N38kjOQjUyXz0OAO+uswTD8qRg1MqBMSq/bMhXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0JtvWboH; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539e8607c2aso4974e87.3
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 10:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730917005; x=1731521805; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LeWA172BYFuvJUs17jk2BLJpPj+VSqEWSdhQr3Tt5lU=;
        b=0JtvWboH3eEW5OFU4FEkGSPWVz7e5CaDSAefUiLYMGiNdyurRGpz3m94gH8I1Q91aH
         TAOHNCms7kxUlQ6HkP26itRt7DVrL+t1jFiGjvfJBWr5giyerfqH2Yfs7RkWPde8mPTc
         47oZO9mWv7rIwQ1rObUa1dihidz0ILmp+PrYqS3nnz3GuPJQl6r79/6JiZwvQmKuVvlj
         27G2C8AsyshjTvliTyCJ9bcseIclALsfzYvyREtzmPKXn0Xd5XuSfKtqjPQwSWPxlP4J
         P0VoxRLeRfo0dmuCGGcA/BeXK7d7IKUAznJecKVc0ZgfPef1ekqiOXeggpeNCWzfuZMg
         6H3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730917005; x=1731521805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LeWA172BYFuvJUs17jk2BLJpPj+VSqEWSdhQr3Tt5lU=;
        b=sNz5+KoYZczqE5cnPFfS7x31PamyAqZZ/UboKJRfUViGRnc4ByUH42qyFxhFY2fHI0
         PneMzED00dc53RXd1kIjGdlLbH/6dSybhsCQS1lN2NXljkMclGp98Yq6ycrc2VTiNxks
         zUm2tvjOZD/qa4AI3/uXJ0xPzEXlyZOSeIByNsU7wCvDW5eVnN0reOtPMElSfXN7Bnvz
         UZ122dBis9XB5AuYMrFX4r6qKFLevbw8HTfd2ttUMEo5tHFxxux6A+L4OCia7508t9KF
         1vA27quq778uKTUwxecxM1S+phL9GOyk81fxlleibxGjMHeIfnz4H5GnyVDFTT1C9V2N
         QCZA==
X-Gm-Message-State: AOJu0YyDf/Dqj0Ma6ctdQ+Bkz4MfAXHPM5jlbnqWziSx9z5Q12CfgVTX
	3WFGNX0Wao8QS9ssjcFKhbJxv2IkyG4gQ1gV8y2tGk8+WVjieNGza5o7VFj74ynvgx7Ufs1FT/o
	sH3sd963VwmBxM21sC+epjyqY/RtsFgC0OD7OtT5MCwrepOUMwA==
X-Google-Smtp-Source: AGHT+IH0eyYrDiApka0FCPYt2gCEKlK4/mAq7uw29tSP1xJ7qJxDTSHGX9xhi6kEHhZbsrB00EH2FETbJzZH1P9TZow=
X-Received: by 2002:a05:6512:12c5:b0:539:e88f:23a1 with SMTP id
 2adb3069b0e04-53b3491c80emr21831365e87.44.1730917005120; Wed, 06 Nov 2024
 10:16:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106083035.2813799-1-jingzhangos@google.com>
 <20241106083035.2813799-2-jingzhangos@google.com> <86cyj81sdl.wl-maz@kernel.org>
In-Reply-To: <86cyj81sdl.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 6 Nov 2024 10:16:33 -0800
Message-ID: <CAAdAUtgiWxhY6DQrS_B=6PhL3+V-qfJVSsqWWeVuGqW7DLcotw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Kunkun Jiang <jiangkunkun@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 4:03=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 06 Nov 2024 08:30:32 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > From: Kunkun Jiang <jiangkunkun@huawei.com>
> >
> > In all the vgic_its_save_*() functinos, they do not check whether
> > the data length is 8 bytes before calling vgic_write_guest_lock.
> > This patch adds the check. To prevent the kernel from being blown up
> > when the fault occurs, KVM_BUG_ON() is used. And the other BUG_ON()s
> > are replaced together.
> >
> > Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 21 +++++++++++++++++++--
> >  1 file changed, 19 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-=
its.c
> > index ba945ba78cc7..2381bc5ce544 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -2095,6 +2095,10 @@ static int vgic_its_save_ite(struct vgic_its *it=
s, struct its_device *dev,
> >              ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
> >               ite->collection->collection_id;
> >       val =3D cpu_to_le64(val);
> > +
> > +     if (KVM_BUG_ON(ite_esz !=3D sizeof(val), kvm))
> > +             return -EINVAL;
> > +
> >       return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
> >  }
> >
> > @@ -2250,6 +2254,10 @@ static int vgic_its_save_dte(struct vgic_its *it=
s, struct its_device *dev,
> >              (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
> >               (dev->num_eventid_bits - 1));
> >       val =3D cpu_to_le64(val);
> > +
> > +     if (KVM_BUG_ON(dte_esz !=3D sizeof(val), kvm))
> > +             return -EINVAL;
> > +
> >       return vgic_write_guest_lock(kvm, ptr, &val, dte_esz);
> >  }
> >
> > @@ -2431,12 +2439,17 @@ static int vgic_its_save_cte(struct vgic_its *i=
ts,
> >                            struct its_collection *collection,
> >                            gpa_t gpa, int esz)
> >  {
> > +     struct kvm *kvm =3D its->dev->kvm;
>
> nit: just use its->dev->kvm consistently, as this is what we are
> already doing in this function.

Sure. Will do.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

