Return-Path: <kvm+bounces-68455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D985D39C4B
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 03:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B65DF301399D
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 02:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F1E241103;
	Mon, 19 Jan 2026 02:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DLpqxyPB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="klaga4PV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB0D239E75
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 02:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768788782; cv=pass; b=HrwY70D10pCHcLhWZpc4gsJ8j2WQqod9i5IH3umraZBsPtZfacgYttyc84+Hbpl/8yY1q8Zx6HdmGFTbT9BBanzm6hC1jEjeGqjlLi5vdpMd/7RjR2g+xCKg+DuqD/be61K3hy9R1HBRsaW9ZTmoq3Nh11vlmqLztcqDcjl8WAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768788782; c=relaxed/simple;
	bh=b66rLIBiGJ7BwzeJ7NBVrWX0pCkBrP5xqopu/zP1v50=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RUq2KPUvFFva01fy03d7aJieGYleWCbqYRDwH5TP7wZFM6W0bXQqR2YTPjGBhzJXGD8+CF5GsjONVSyUPfmEyOeALFKHOL1bmpqRTrqACxyVn/SYOuPEk2iovyqpMfnEa5156fVJle0kkwu3Yn8KOEgzt4snSD2hzUzOJkRZHpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DLpqxyPB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=klaga4PV; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768788779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7DbdTN7pF/npZpXEyk9hZ7zUr+KhydCm72fooIP7+FI=;
	b=DLpqxyPB4rpBbHc3IAzWTr7Eci60HDA6TXduONVHm4hyuanMu1fZOtowqWqsOhx3FG90vT
	5RnWm8Rykq+7yxTTQ5CCRlVdJvf0I9tG1AJ8tsYPuilyZWJv95L/jLuMBk9SdeA+RK3CVZ
	Hc4X6Ms0BfR9uJoSwbSSG7I5osIPGQ4=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-QpXACN-fPu-OqoJ8NjTn4Q-1; Sun, 18 Jan 2026 21:12:56 -0500
X-MC-Unique: QpXACN-fPu-OqoJ8NjTn4Q-1
X-Mimecast-MFC-AGG-ID: QpXACN-fPu-OqoJ8NjTn4Q_1768788775
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-5ed0ec20724so8404784137.2
        for <kvm@vger.kernel.org>; Sun, 18 Jan 2026 18:12:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768788775; cv=none;
        d=google.com; s=arc-20240605;
        b=coV7g+y/UHbj/70p1w69mcGU+K4nXvVMpaG3DXF4GGOkTwIYBEW/bec9UB/OOBGvAg
         PwqTGboMGQEAmzjPninNLpFAwFM5OcBhEpk6L+G2uwxeeoJGmuZGvZEJeVMQZCz0uxdM
         jKyaltiN7hgwMovdpY9QlLnAGGDsPSKgOyuWajfo0M+B6l5WNYDztPqG6YpebA/a1xP6
         PBrbPinCwHRv4t0E6d1y4eQP62IdM8OvYH2AxMYf5pVGGJ5fmn9ASjVyA7FzOpmKxXjG
         b9J1ynKcyqRj56OEZDgwRdW3JGK6BijTwmFUTGNGgTsB5IgrwDx3NNkRsL5NDGF7q6ws
         UBmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7DbdTN7pF/npZpXEyk9hZ7zUr+KhydCm72fooIP7+FI=;
        fh=2i12ZXzrvcGt46/jDSZD5Hw1eyJr/07Tppmlq0v1Xfw=;
        b=kamHUk0xNe4AK0ZDZXiKLQ6OdAJqSgN71nfwG5biZBcFqwm/DRfGaPpBmkDbyns7bb
         cGSYq34x7SlkPg5vRM6JelJG32lCTlps0pV8MzGuUGeVBtG8etlv7DdM9WjcW0LELpWH
         hH8/bhtyP/63Go973KZPjmxspEkgPZ/WjXvvbLKcis7YrVpoWN351gxA7byqNiOOIVxE
         RP0O12cvuRm5/gHSTPqQqnbOup8ZCCl3YVVNtEtW2lfgGotDdOtLGXbBAmRAHMRnQ1Xp
         NdygkDW7DO0qnUxCo5eEjwXHY+BHqI3AbWq7orHE6xlf4HmBusLtfZdvQxTVZ5ntVxK8
         GiSg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768788775; x=1769393575; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7DbdTN7pF/npZpXEyk9hZ7zUr+KhydCm72fooIP7+FI=;
        b=klaga4PVCP4/Kkj+TF9R0iPnH3LyN9pz1qQtlwrIBP+QdgMS/L7pgd8Xa7EgHywmza
         hj0sFZx0dpQr9tvgjYG9FGYBBoqjNPiTffTp+F2vFvPkBS1zbOz0Mf6ipaDOsj0R3Apk
         4jgM+BMMNRE2oJkG8npwBuPhnwMUxE4OCwb/P5ZqUbD03lqhjfqzFESFedYQBbYT/kcu
         4dcgGPHIJRt6UnJ2ZZ/Yb1q7S2h5YbtxqizmNkKppE3J4kG9h7yVc1o7sz7u20Cg3xRN
         ND8ncdammANzh6XKLRxx+zYhCO9QSfLP8Dmq+X34cC6VUKKlNeLusWD3wzJOLuUx7LKe
         3y5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768788775; x=1769393575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7DbdTN7pF/npZpXEyk9hZ7zUr+KhydCm72fooIP7+FI=;
        b=ij1Er74sXHRFuneE4zaquMDj2ytBMIds5lGACxGmBebo+iPpQSDIztsa4f5TYcggeR
         qE1Mj1He+CQPFW5WDalSxvOOEkbds2+jLinE2pjkKORWDbgLt648dYMnsWGGvaRhiWSB
         GgauYAhlI+0hlHx2xODnUpKYjGg+Rf0hREItSHA6xa6IvLt1yBRgIlVe32Gtnc8RQl8F
         VJxvFNwXp9sk+E6/xtTMat8joa0RT/fduIhDLyX5Tpx7UGOmvQTQcTuOBj5UC6hXAFAw
         c4tL7Vxs4wdzJfmGhyHV+cuXtlRd6lyrd7Yd79xctN4tRecYUiLOe5CAc3+pzHkuZS9V
         7Qew==
X-Forwarded-Encrypted: i=1; AJvYcCVF6YvEw4peBoiXcLTex05DZ22rxzWRX6fMAA1RB3QHLdOH2bxwNFA3U/NfHpuuG6I+DR8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGqLPx6ENthLyJ2BCoVar34QKZT5hJJNHqKmnhK5DKkHuTcOs+
	E85b82zTRrjfTYPan1p6c4RxHSb4girw0M3N8AHK2DtT9rBXoKg7OhhJuayrpG1XQRXcQIpAFAq
	0zSgfbuWn6SjPbAbGrXLikwtYXNz2ePObBi2VOlGwbvTrPoE2LDJ8lCDFzrhzi1+Ft3sAZKrTWb
	xpf0OVJG4TWejX0Xn5n5OzfLRh7L4D
X-Gm-Gg: AY/fxX728zlV8EWU87Bpa9KvgeQZFA1j6Ht8jJXpfDqOFRFnW5DInjQol2FEBo1Sa4L
	TEGKu7yJMsCMhcKpAQN32jVdxhlnjbBzQwKA7Gku3OH3ZNuY+FKYJM3rbwxbcNwrWx6fFw54VmG
	XBoEle3rIH8Svw1hEPxcFX9jPDOPHcqEj0RpppJK7bG6DSC0QIq7QEBY7QhyxBrxA4HV4=
X-Received: by 2002:a05:6102:3f4a:b0:5dd:b0e6:c4cb with SMTP id ada2fe7eead31-5f1a4d8d33amr3253351137.9.1768788775622;
        Sun, 18 Jan 2026 18:12:55 -0800 (PST)
X-Received: by 2002:a05:6102:3f4a:b0:5dd:b0e6:c4cb with SMTP id
 ada2fe7eead31-5f1a4d8d33amr3253337137.9.1768788775314; Sun, 18 Jan 2026
 18:12:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251229071614.779621-1-lulu@redhat.com> <09178761-3ff7-4c6d-bdf4-cbf16531d71e@nvidia.com>
In-Reply-To: <09178761-3ff7-4c6d-bdf4-cbf16531d71e@nvidia.com>
From: Cindy Lu <lulu@redhat.com>
Date: Mon, 19 Jan 2026 10:12:16 +0800
X-Gm-Features: AZwV_Qizwj1EMviepQfrW3r56R4fRHe-HzedcvdMLGJBJgU0YPalMF59laPuV2I
Message-ID: <CACLfguWDQ-NqNV6w2BAGQS_fA0+ADhVVOJbzDC+rt4u8Trhu3Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] vdpa/mlx5: update mlx_features with driver state check
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: mst@redhat.com, jasowang@redhat.com, 
	virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 2, 2026 at 8:09=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com>=
 wrote:
>
>
> Hi Cindy,
>
> Thanks for your patch!
>
> On 29.12.25 08:16, Cindy Lu wrote:
> > Add logic in mlx5_vdpa_set_attr() to ensure the VIRTIO_NET_F_MAC
> > feature bit is properly set only when the device is not yet in
> > the DRIVER_OK (running) state.
> >
> > This makes the MAC address visible in the output of:
> >
> >  vdpa dev config show -jp
> >
> > when the device is created without an initial MAC address.
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
>
> Having a cover letter with the summary, history and links series would
> make the review process easier.
>
> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/=
mlx5_vnet.c
> > index ddaa1366704b..6e42bae7c9a1 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -4049,7 +4049,7 @@ static int mlx5_vdpa_set_attr(struct vdpa_mgmt_de=
v *v_mdev, struct vdpa_device *
> >       struct mlx5_vdpa_dev *mvdev;
> >       struct mlx5_vdpa_net *ndev;
> >       struct mlx5_core_dev *mdev;
> > -     int err =3D -EOPNOTSUPP;
> > +     int err =3D 0;
> >
> >       mvdev =3D to_mvdev(dev);
> >       ndev =3D to_mlx5_vdpa_ndev(mvdev);
> > @@ -4057,13 +4057,22 @@ static int mlx5_vdpa_set_attr(struct vdpa_mgmt_=
dev *v_mdev, struct vdpa_device *
> >       config =3D &ndev->config;
> >
> >       down_write(&ndev->reslock);
> > -     if (add_config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
> > +
> > +     if (add_config->mask & BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
> > +             if (!(ndev->mvdev.status & VIRTIO_CONFIG_S_DRIVER_OK)) {
> > +                     ndev->mvdev.mlx_features |=3D BIT_ULL(VIRTIO_NET_=
F_MAC);
> > +             } else {
> > +                     mlx5_vdpa_warn(mvdev, "device running, skip updat=
ing MAC\n");
> > +                     err =3D -EBUSY;
> > +                     goto out;
> > +             }
> >               pfmdev =3D pci_get_drvdata(pci_physfn(mdev->pdev));
> >               err =3D mlx5_mpfs_add_mac(pfmdev, config->mac);
> >               if (!err)
> >                       ether_addr_copy(config->mac, add_config->net.mac)=
;
> >       }
> >
> > +out:
> >       up_write(&ndev->reslock);
> >       return err;
> >  }
> The patch itself makes sense. For it you can add:
>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
>
Thanks Dragos, will add this
> Thanks,
> Dragos
>


