Return-Path: <kvm+bounces-21085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE4B929CC1
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 09:06:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 569B4280BE9
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 07:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ADB01BF3F;
	Mon,  8 Jul 2024 07:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NmNOAgEC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D540718643
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 07:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720422386; cv=none; b=Iu8m2tcV8rjYbrdiwF2yWFfk+zOR5hb3D2Ee4x726/jUWYVEUcNXs6v4GhjOt8i68lyYcpplEOEtgbSJiItFV0RdzgcTOPPSeqRm7EUbG9b3QYgijJ58/Gr56don4AMtChcTMB2m/YUSzX9pAcFI+uWhJuee0yici8chkvZyr5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720422386; c=relaxed/simple;
	bh=THNdkBV6zSeKbGJ+rU746rP1p4hHLxTftUqiTNAVfmI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b9CIRsrLEohtUX9U3jNvhv+zm1YM13obS3ZFHedh9mrx1U14apDboESf7HHMRoHn+wjcw0WOd42hJxrufNvRBO2SoIN6fkz5AyVJJt6mPqbP2/aAlz+tu9RcKojXgAEW3PUi0fKw6CzxYdh9OE+tpXZL7avUKcKQ6ebkR5ElTY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NmNOAgEC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720422383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zyIJppIdQ0nDVMjomTHHFokVZU/AX+NHjK5GMHRTEbg=;
	b=NmNOAgECKqlcUfPD+S7jTqpWQi18coYbJc2QPyTVu0VXDxaOiK6Qm2g1vHf4d0ILYlbF9d
	CzMdv/36IDB6LUeulTdxIuLNDgrUXSMuLe4b/DkiE6iTZXnhhV+KCE/e8y0bwYGyaEBzJk
	+pu7LnMwIIYmzKF1k02fBlT6dCYdrUo=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-X5PVgQsjMJaGarYCiF5E_w-1; Mon, 08 Jul 2024 03:06:22 -0400
X-MC-Unique: X5PVgQsjMJaGarYCiF5E_w-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-810549fde5fso421789241.2
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 00:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720422382; x=1721027182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zyIJppIdQ0nDVMjomTHHFokVZU/AX+NHjK5GMHRTEbg=;
        b=dBxioo0ucNKgU93s4bWYF2d77ighdJ9N3PIUycmU1URfqba5k7h2UcToCax7lpI8al
         5DEx6j4aD97NUdBFV5NY58SGvIqsZqOJcCCfOhv6J7VPoPjb9B9sz9RXGDIW26ClXTLX
         By8s/3teHFpyk1mFtQBSuDZLKWACsNk71cxyKAKGe/PYIvwqsxwiJ4M0dz7QrE8IeFu/
         W4/zhNJGHBM3V/FTWiIulJ8GBBja1iuPnXFf0mGTqe16BuIu2PNLtHjUeC2arxUaA0wt
         +AazDptgkE59fMt9jFeiiA+G1TdYI5B2sDARbcEWGaDzDzOZXDmne9HYtetwrQZ97mij
         rv1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUzwc4Sam33CSkrb9yZA39Pll2IfGgdn8dvsf4uMgfmngfMuf4nwI/NsTBKlqDiqYnLOjkJUzXnOruL7qPNOCmWp3y7
X-Gm-Message-State: AOJu0Ywngga/UCq/nk2aekKBdqYb0aiUXYr1vJ110TY8LBEAmDywbw4H
	GbbHNo5ht3NCAqlJgiP0A6BiSoOFxFfEKdumMdhf/qJSBSO8fFWGcT4Xc6M8WcvlbOwXqY4yfNq
	CygsGOJd36dNuIVwHUhfHkl4b0svlcXCTzjCcUnEUfpGLpv6WuC6eXyiIVLh5GiHLs/OE+4m2aJ
	o/Jxr82cEfN/DOZ+Lod8dDpGry
X-Received: by 2002:a67:fc49:0:b0:48f:95c4:d534 with SMTP id ada2fe7eead31-48fee85607dmr10714732137.3.1720422381817;
        Mon, 08 Jul 2024 00:06:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFO1uc/RoshDkfTco0M6SeXuaFTZdF5eVYjCvZPJyHOCO2f2BCvZGt1Bk00xuZa9uB5eVL5bqHsQrA5BAFqNEk=
X-Received: by 2002:a67:fc49:0:b0:48f:95c4:d534 with SMTP id
 ada2fe7eead31-48fee85607dmr10714708137.3.1720422381475; Mon, 08 Jul 2024
 00:06:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708064820.88955-1-lulu@redhat.com> <20240708064820.88955-3-lulu@redhat.com>
In-Reply-To: <20240708064820.88955-3-lulu@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 8 Jul 2024 15:06:05 +0800
Message-ID: <CACGkMEum7Ufgkez9p4-o9tfYBqfvPUA+BPrxZD8gF7PmWVhE2g@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] vdpa_sim_net: Add the support of set mac address
To: Cindy Lu <lulu@redhat.com>
Cc: dtatulea@nvidia.com, mst@redhat.com, parav@nvidia.com, sgarzare@redhat.com, 
	netdev@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 2:48=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> Add the function to support setting the MAC address.
> For vdpa_sim_net, the driver will write the MAC address
> to the config space, and other devices can implement
> their own functions to support this.
>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim=
/vdpa_sim_net.c
> index cfe962911804..a472c3c43bfd 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -414,6 +414,22 @@ static void vdpasim_net_get_config(struct vdpasim *v=
dpasim, void *config)
>         net_config->status =3D cpu_to_vdpasim16(vdpasim, VIRTIO_NET_S_LIN=
K_UP);
>  }
>
> +static int vdpasim_net_set_attr(struct vdpa_mgmt_dev *mdev,
> +                               struct vdpa_device *dev,
> +                               const struct vdpa_dev_set_config *config)
> +{
> +       struct vdpasim *vdpasim =3D container_of(dev, struct vdpasim, vdp=
a);
> +
> +       struct virtio_net_config *vio_config =3D vdpasim->config;
> +       if (config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
> +               if (!is_zero_ether_addr(config->net.mac)) {
> +                       memcpy(vio_config->mac, config->net.mac, ETH_ALEN=
);
> +                       return 0;
> +               }
> +       }
> +       return -EINVAL;

I think in the previous version, we agreed to have a lock to
synchronize the writing here?

Thanks

> +}
> +
>  static void vdpasim_net_setup_config(struct vdpasim *vdpasim,
>                                      const struct vdpa_dev_set_config *co=
nfig)
>  {
> @@ -510,7 +526,8 @@ static void vdpasim_net_dev_del(struct vdpa_mgmt_dev =
*mdev,
>
>  static const struct vdpa_mgmtdev_ops vdpasim_net_mgmtdev_ops =3D {
>         .dev_add =3D vdpasim_net_dev_add,
> -       .dev_del =3D vdpasim_net_dev_del
> +       .dev_del =3D vdpasim_net_dev_del,
> +       .dev_set_attr =3D vdpasim_net_set_attr
>  };
>
>  static struct virtio_device_id id_table[] =3D {
> --
> 2.45.0
>


