Return-Path: <kvm+bounces-31026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B1759BF53F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 19:30:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 148CAB241FC
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A61208214;
	Wed,  6 Nov 2024 18:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dh89pHmw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC271F9EA9
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730917833; cv=none; b=Om+mhBhZ164VjV5qTR0p+7sASKEHpPSCclGFshHQd/y97EkI4PSUALZYxQoj1tvNSyQF7ekVTg93wOYvOxdzoqpIR8of2nUzxAwbM5n8EkNxZHt+uHYT07mgqIevhXK+aqNNANPDzzrwYRszRNNhfOeCJP/xA0Orjo4/ApP4GDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730917833; c=relaxed/simple;
	bh=mjoz83CLqaDv8rpTVVqzpgd8HTB+bg+8p56PWi41xqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GuMpkeExr8x6PWgZCAsnLZ9IobgiEjKPI6ubZwOwl25oPmN7VT0WajPxCB5pCtHSGk6CcvJxaqMCK+L0acvhwz1+C/v/MVjNXrWnyUhY93tEQ058LDCGmHpBwTLTkt9qFu/EaO1A6iOcC5ddkSS+d9sJiYub9JROv935alF0s9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dh89pHmw; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539f58c68c5so14327e87.3
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 10:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730917830; x=1731522630; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NbT+MVFmQWldHSwvQIAZqRuAjWXImGGsq+3vijULiGE=;
        b=Dh89pHmwgykdirMiuKcoSPSvV5BodajGivZzSc3DdTladjxUZTWFn+n6bfoSXL9vtw
         4LhQ60eryI7V2/F52aMiyFfbiQz6hXPg/YLHP9ol+ssfOBzE1x3W3efw1RHWk4jCykrt
         VnQ6i6ztzjwyVYgWXsNkKM4ggLZ3qpzFz/Ff5eH38gKhbWKzCBlcthm3klJ+CgmFM9xA
         X+JY8t15ETtKuBsoxsmsWi/zMsAEAoXzJySakC3QXndU0bICH2GZ5TgyCorxNfNRT5XL
         oYDAHNlLI8YGxr07X08NHoqETc0gJ4XIX7qYgtL2iJxu/Nkl7lFudhFegjkeFNzOOegA
         xPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730917830; x=1731522630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NbT+MVFmQWldHSwvQIAZqRuAjWXImGGsq+3vijULiGE=;
        b=Uo16tv9n6tchCq1+3zg3NSj63kbLmhGw8d9s5/JCarR7QvbEfar1+BSgpHFy9rrvbE
         s0V5vowG6+nWhrKLMs0/ujnAmIT3Mg2YQuQ7FCY4z1VkFU7n4flLWKqCLQttfjf4BJrt
         04dRw/4IbwuU4xfBEMlDT/wrvg0fHPD5QmDrC4PepA3s9t7gm2os23I5BG7lVpp5EHLL
         SvZU/MknNz7w7yTR6RSJxpjLVtihGR+u45SMqOVVlh/A9ZMHDNCTdWML+rUWp7syPxDg
         QzVKCT3wmvLOKNK9c7VqY0DTm+03upwXIlghy3MdZF0JXDc28p02NqD97r6Fe7EU/mb1
         rsqw==
X-Gm-Message-State: AOJu0YyjqYaHUp8126bAu8zmI6q9CIA/nV7Q0JPiFwQYwIUKtqtAPq2w
	geO3te1UVPBPgrZBDFsrQxFvr6XFoHoiJWb0fLHWnuiLoBT/qMB1I3kjQ/uPNV4EYcPQ96tQfyK
	Nm2KMnylCYcl/TLwBNwTf0zpLzMlXgUuLcMCILVzqsAYytuKATg==
X-Google-Smtp-Source: AGHT+IGYKAJXEmT25HizfPd98EM7DkJ/wBTM9jTTkKgsvpun+NHaqwmwMvXWcTOmNi+oHO6/SxiZtFDZUwiPL4oYAew=
X-Received: by 2002:a05:6512:159c:b0:539:8f3c:4586 with SMTP id
 2adb3069b0e04-53d65e16881mr14669176e87.55.1730917829767; Wed, 06 Nov 2024
 10:30:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106083035.2813799-1-jingzhangos@google.com>
 <20241106083035.2813799-3-jingzhangos@google.com> <86bjys1p45.wl-maz@kernel.org>
In-Reply-To: <86bjys1p45.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 6 Nov 2024 10:30:17 -0800
Message-ID: <CAAdAUthN14kLmeH0eLK991soGeZD8qzD+Sp1jR2gZjqLVE771Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
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

On Wed, Nov 6, 2024 at 5:14=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 06 Nov 2024 08:30:33 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > From: Kunkun Jiang <jiangkunkun@huawei.com>
> >
> > vgic_its_save_device_tables will traverse its->device_list to
> > save DTE for each device. vgic_its_restore_device_tables will
> > traverse each entry of device table and check if it is valid.
> > Restore if valid.
> >
> > But when MAPD unmaps a device, it does not invalidate the
> > corresponding DTE. In the scenario of continuous saves
> > and restores, there may be a situation where a device's DTE
> > is not saved but is restored. This is unreasonable and may
> > cause restore to fail. This patch clears the corresponding
> > DTE when MAPD unmaps a device.
> >
> > Co-developed-by: Shusen Li <lishusen2@huawei.com>
> > Signed-off-by: Shusen Li <lishusen2@huawei.com>
> > Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-=
its.c
> > index 2381bc5ce544..7c57c7c6fbff 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -1140,8 +1140,9 @@ static int vgic_its_cmd_handle_mapd(struct kvm *k=
vm, struct vgic_its *its,
> >       u8 num_eventid_bits =3D its_cmd_get_size(its_cmd);
> >       gpa_t itt_addr =3D its_cmd_get_ittaddr(its_cmd);
> >       struct its_device *device;
> > +     gpa_t gpa;
> >
> > -     if (!vgic_its_check_id(its, its->baser_device_table, device_id, N=
ULL))
> > +     if (!vgic_its_check_id(its, its->baser_device_table, device_id, &=
gpa))
> >               return E_ITS_MAPD_DEVICE_OOR;
> >
> >       if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
> > @@ -1161,8 +1162,17 @@ static int vgic_its_cmd_handle_mapd(struct kvm *=
kvm, struct vgic_its *its,
> >        * The spec does not say whether unmapping a not-mapped device
> >        * is an error, so we are done in any case.
> >        */
> > -     if (!valid)
> > +     if (!valid) {
> > +             struct kvm *kvm =3D its->dev->kvm;
> > +             int dte_esz =3D vgic_its_get_abi(its)->dte_esz;
> > +             u64 val =3D 0;
> > +
> > +             if (KVM_BUG_ON(dte_esz !=3D sizeof(val), kvm))
> > +                     return -EINVAL;
>
> I find it pretty odd to bug only in that case, and the sprinkling of
> these checks all over the place is horrible. I'm starting to wonder if
> we shouldn't simply wrap vgic_write_guest() and co to do the checking.
>
> > +
> > +             vgic_write_guest_lock(kvm, gpa, &val, dte_esz);
>
> I'm thinking of something like:
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index ba945ba78cc7d..d8e57aefcd3a5 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -1128,6 +1128,19 @@ static struct its_device *vgic_its_alloc_device(st=
ruct vgic_its *its,
>         return device;
>  }
>
> +
> +#define its_write_entry_lock(i, g, valp, t)                            \
> +       ({                                                              \
> +               struct kvm *__k =3D (i)->dev->kvm;                       =
 \
> +               int __sz =3D vgic_its_get_abi(i)->t;                     =
 \
> +               int __ret =3D 0;                                         =
 \
> +               if (KVM_BUG_ON(__sz !=3D sizeof(*(valp)), __k))          =
 \
> +                       __ret =3D -EINVAL;                               =
 \
> +               else                                                    \
> +                       vgic_write_guest_lock(__k, (g), (valp), __sz);  \
> +               __ret;                                                  \
> +       })
> +
>  /*
>   * MAPD maps or unmaps a device ID to Interrupt Translation Tables (ITTs=
).
>   * Must be called with the its_lock mutex held.
> @@ -1140,8 +1153,9 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm=
, struct vgic_its *its,
>         u8 num_eventid_bits =3D its_cmd_get_size(its_cmd);
>         gpa_t itt_addr =3D its_cmd_get_ittaddr(its_cmd);
>         struct its_device *device;
> +       gpa_t gpa;
>
> -       if (!vgic_its_check_id(its, its->baser_device_table, device_id, N=
ULL))
> +       if (!vgic_its_check_id(its, its->baser_device_table, device_id, &=
gpa))
>                 return E_ITS_MAPD_DEVICE_OOR;
>
>         if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
> @@ -1161,8 +1175,10 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kv=
m, struct vgic_its *its,
>          * The spec does not say whether unmapping a not-mapped device
>          * is an error, so we are done in any case.
>          */
> -       if (!valid)
> -               return 0;
> +       if (!valid) {
> +               u64 val =3D 0;
> +               return its_write_entry_lock(its, gpa, &val, dte_esz);
> +       }
>
>         device =3D vgic_its_alloc_device(its, device_id, itt_addr,
>                                        num_eventid_bits);
>
> which can be generalised everywhere (you can even extract the check
> and move it to an out-of-line helper as required).

Sounds good. Will do as you suggested.

Jing
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

