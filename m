Return-Path: <kvm+bounces-25249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 605C59627B2
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:49:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C4912847B4
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 12:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB7717AE0C;
	Wed, 28 Aug 2024 12:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JUylkC5S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FA516BE06
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 12:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724849379; cv=none; b=rENKrcUP/s3cEbzqLgwXRijvQ9N3nYwAjSv3oEIYjh5lSDfbD+GHF7kF8penjBL0hyIQl6WVlIzamoV+pTFx74k1L+j4g1GLigPRvjW3EyQgD78kOWwrpGBTQC0W8MltxI3By2qMzPO8hLqA84Hwnjl8BAIxHUWoctAhpEjFFCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724849379; c=relaxed/simple;
	bh=OmG9UKSRalPMPedgGvQtdSaHxT80qp6qKysD1sivNj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FJ9p0YGzgmHLFEsFzXXAf5TUAeAZS9x4sNg0eVmuynFF4AO2MwxWyB0A84emRL+H+UM4y+b/OOEABcBp3UAceEf70LcOSvrbpQC5ddFCWYlccPmkBojFav5AUiPjiLIwkF71c8PN+ig50nJUE4WA24odL1HO+04dMWAr0AWvAN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JUylkC5S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724849376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mG84mpdNAxgJt+MjSaUaK5oPD2+XnDBYY0BR3c+Z6I0=;
	b=JUylkC5SsZW2PaMrEwxIo1RAldQtENaRl+oJ2YTXvBViFAQL+lU7BRbKfPQBS0Vjj/PUrW
	zGwdYJ7JU1qHVZC9SiTu1UpTV5/GhzKYaca2ClLmnqLpa9y1KpoEKnQFXUxiYVoQ+85rne
	BpE0u+fILhj+frkXvV7OVYe+G9mEMUY=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-OQs-am_rNbu86nm5Oqb7cQ-1; Wed, 28 Aug 2024 08:49:35 -0400
X-MC-Unique: OQs-am_rNbu86nm5Oqb7cQ-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-6b44f75f886so137211557b3.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 05:49:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724849375; x=1725454175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mG84mpdNAxgJt+MjSaUaK5oPD2+XnDBYY0BR3c+Z6I0=;
        b=vAirbhANZwoRTwG+jvO4C9LDn004E8sJBoGCRGsyE5UVwz3jkvlxWtetWIJXtKq/tr
         Pm/jD7MjVVFiyFYBTGCWPcOxiyUxSDPT6bYYEtX3L3+AKiH8v0GcZeVgUIWYnhfESTBz
         nG6T9aCAaSVjUZ7csrhMdHPupFZeA3O1bRkNaXTI9TEA4XwoaYwUtSkY3Ti5p3EWeAz7
         BTVyzNoBtFaCTd6/FAV636TEUR2daq2gJmNDnFtZmQmeBXkesz8armvk4gbvomIdwo98
         Zp5026gv/1xoRpv/P6QToy+s/FdAIX1bQHUTdVp5/y0XzuFOfVYMzXJTJEtHODOaMEkU
         Vykw==
X-Forwarded-Encrypted: i=1; AJvYcCUIsxs6gR83MAGvG+JIDgGu0QGkmos+xuDCA6vnorAneiLhBql7ZI4WKDkbmmCLQlAUaio=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHzWEQRwxAE5NcyoSyeh7TU6pU1chQ0kWDCLCTGFjDYD5RfRW9
	L8ThklAQodDElv02VU7BUHjZLwPqKFttjlM8Q6e7RfAw6Gq4DNGMISow5QLkFrPw/aUpB+NmBQr
	E8dg+Cn2cDtQ7YHSwROqz2UCgIuIMC9mCIYy3PfTHEpE5kBzh886CnGauejQeW0vbq9vDGCGUuC
	Ojy2CAaO39F1paX6YmN1d/Wu52
X-Received: by 2002:a05:690c:2c8f:b0:64a:956b:c063 with SMTP id 00721157ae682-6c629065714mr152681417b3.39.1724849375217;
        Wed, 28 Aug 2024 05:49:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEd7nnhKwMBHGzXZsGM1fq6Gzr4+LPrJ+cQ8cp3h+LjdAk8VlTS8UTQRv1TB09r6RylwmJ7164mFinpLkrgGxQ=
X-Received: by 2002:a05:690c:2c8f:b0:64a:956b:c063 with SMTP id
 00721157ae682-6c629065714mr152681307b3.39.1724849374930; Wed, 28 Aug 2024
 05:49:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816090159.1967650-1-dtatulea@nvidia.com> <20240816090159.1967650-10-dtatulea@nvidia.com>
In-Reply-To: <20240816090159.1967650-10-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 28 Aug 2024 14:48:59 +0200
Message-ID: <CAJaqyWcnJwfwyGKqx62OdSXrVH4gA701E-j5soChG0ZfTUsi9Q@mail.gmail.com>
Subject: Re: [PATCH vhost v2 09/10] vdpa/mlx5: Small improvement for change_num_qps()
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	virtualization@lists.linux-foundation.org, Si-Wei Liu <si-wei.liu@oracle.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024 at 11:03=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.co=
m> wrote:
>
> change_num_qps() has a lot of multiplications by 2 to convert
> the number of VQ pairs to number of VQs. This patch simplifies
> the code by doing the VQP -> VQ count conversion at the beginning
> in a variable.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index 65063c507130..d1a01c229110 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2219,16 +2219,17 @@ static virtio_net_ctrl_ack handle_ctrl_mac(struct=
 mlx5_vdpa_dev *mvdev, u8 cmd)
>  static int change_num_qps(struct mlx5_vdpa_dev *mvdev, int newqps)
>  {
>         struct mlx5_vdpa_net *ndev =3D to_mlx5_vdpa_ndev(mvdev);
> -       int cur_qps =3D ndev->cur_num_vqs / 2;
> +       int cur_vqs =3D ndev->cur_num_vqs;
> +       int new_vqs =3D newqps * 2;
>         int err;
>         int i;
>
> -       if (cur_qps > newqps) {
> -               err =3D modify_rqt(ndev, 2 * newqps);
> +       if (cur_vqs > new_vqs) {
> +               err =3D modify_rqt(ndev, new_vqs);
>                 if (err)
>                         return err;
>
> -               for (i =3D ndev->cur_num_vqs - 1; i >=3D 2 * newqps; i--)=
 {
> +               for (i =3D cur_vqs - 1; i >=3D new_vqs; i--) {
>                         struct mlx5_vdpa_virtqueue *mvq =3D &ndev->vqs[i]=
;
>
>                         if (is_resumable(ndev))
> @@ -2237,27 +2238,27 @@ static int change_num_qps(struct mlx5_vdpa_dev *m=
vdev, int newqps)
>                                 teardown_vq(ndev, mvq);
>                 }
>
> -               ndev->cur_num_vqs =3D 2 * newqps;
> +               ndev->cur_num_vqs =3D new_vqs;
>         } else {
> -               ndev->cur_num_vqs =3D 2 * newqps;
> -               for (i =3D cur_qps * 2; i < 2 * newqps; i++) {
> +               ndev->cur_num_vqs =3D new_vqs;
> +               for (i =3D cur_vqs; i < new_vqs; i++) {
>                         struct mlx5_vdpa_virtqueue *mvq =3D &ndev->vqs[i]=
;
>
>                         err =3D mvq->initialized ? resume_vq(ndev, mvq) :=
 setup_vq(ndev, mvq, true);
>                         if (err)
>                                 goto clean_added;
>                 }
> -               err =3D modify_rqt(ndev, 2 * newqps);
> +               err =3D modify_rqt(ndev, new_vqs);
>                 if (err)
>                         goto clean_added;
>         }
>         return 0;
>
>  clean_added:
> -       for (--i; i >=3D 2 * cur_qps; --i)
> +       for (--i; i >=3D cur_vqs; --i)
>                 teardown_vq(ndev, &ndev->vqs[i]);
>
> -       ndev->cur_num_vqs =3D 2 * cur_qps;
> +       ndev->cur_num_vqs =3D cur_vqs;
>
>         return err;
>  }
> --
> 2.45.1
>


