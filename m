Return-Path: <kvm+bounces-25250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79874962811
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 15:00:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 326D4282468
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 13:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F961187862;
	Wed, 28 Aug 2024 12:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U/7o0RZl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDC1184535
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 12:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724849987; cv=none; b=utAE+61VpJ92Emf1WMgNiBXFuckK4RGC8PmwBcKv7j6ncw0OD6ggp2RZPm44aQ69TnLk9gBrFkF+gJV5Cw993xDa1A2JTg6a4ZWVGYg+mil367rWF2nXS7lmeMWfuMGD7ksNEfuxu6dnCwS83xcw7gK0uGKJzFVeb0TfresWW7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724849987; c=relaxed/simple;
	bh=ymupMNvwNJBaMEUU8F78IdNvFql9A3Vo9I6iMpInMlw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f/gm9FV6v01dqihtb63wcYo2eSXkrM6yePGrAQvgdqquE/pDheeb4W0qG1aUMfz1KAb3LBO48/YgPAtbA6YCS3F/7h3Y7mEeYZYX2ygL+NVdZQXlL0HOPAEeT8T8An9V/JIsJ3w+6H2TZzdvylExHmN0Zi9imKXziPS9PA8y554=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U/7o0RZl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724849984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3TUrO5dpGA8rfdSv1PfPK5BcATBwgN+tBNwuxtVK/c=;
	b=U/7o0RZlNJ6ZghNZBWNkEC3eWrbsC6x3vLQLxINgmC/4k8IX/Ls9XtC92F79D7uM6Tncts
	FEG2wq03/Nk9daGFSlX7eL9d0bD5SsgXa1IBJqmrx4oHlxpJLeK4gyJdXG1N1HcNl5JbOB
	9FToVPvNbaJL4cYBcwa90IbwjwA5wwE=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-QDJ-LtKxP92SEpWwWdZPyQ-1; Wed, 28 Aug 2024 08:59:43 -0400
X-MC-Unique: QDJ-LtKxP92SEpWwWdZPyQ-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-6b3fec974e5so126756547b3.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 05:59:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724849983; x=1725454783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S3TUrO5dpGA8rfdSv1PfPK5BcATBwgN+tBNwuxtVK/c=;
        b=Twemedp9qPmGeVPY6zVoAhIC/QiOxiHlro+uim7I3INd9XTz4AXDbnBaSaewpUGKkC
         0b2/xqfPvPcgG0CibJ8eY/KDSB254DvJhC8vGgCoEA9opELwquY/0tgxTIzKj7Kof2by
         opyUZeDOCk5ErTyy3tO5iiyMpvXwlVXaH7y1vVv454nLXwpq+NuoUGAsD8LHHra375CL
         tONbhXn3O8JwX7DdilQPcG+LejnvqXWgL/gIVLmojiDcvec2kOeDAmL9aHt0EmFBv8ci
         zzoVQjkTRwvhix/4tnfUtPWMt7aIXmo0dtE0BNzGMa62nzyRKs1naf6DI8MhplAojD7R
         X3bw==
X-Forwarded-Encrypted: i=1; AJvYcCWGjZ90mja4KFjZt5xLQuNnLMxY4ya03FyuiJCFCudvodfzIOp1kAK0p9vNenREPh/GzoY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1RvJ0mQ+9v4AkaPYqYWiaXeVXQpLM0QrKFLg12cycg3AZoQue
	QLOOBeObwiwRogJwjH8ac4YFKVjEMmJcMjRbRWbYoQZQFTqoUnFC+u0XZY57H04LQ8hdDjLJi+I
	Zauz0YYYzRY7K3jyyKP3PwrDCFXholxRc7LMzOFmdL1RJH8jtOxjCSVquW+9S/ihOOG9c5wbZf2
	6goiJyBP58MouuzmDKgw9nPUcqACz+6vBb5bAF4A==
X-Received: by 2002:a05:690c:f81:b0:6cf:8d6f:2c17 with SMTP id 00721157ae682-6cf8d6f330bmr82005097b3.8.1724849982824;
        Wed, 28 Aug 2024 05:59:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgcU387IxWPo4yekqWXqtNg5KIt51AsXE5T6bzQ+TasCLXcyqT2oXqmZTLQUlKNBz+CaTjn6pYNY9IaOgUuYc=
X-Received: by 2002:a05:690c:f81:b0:6cf:8d6f:2c17 with SMTP id
 00721157ae682-6cf8d6f330bmr82004837b3.8.1724849982531; Wed, 28 Aug 2024
 05:59:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816090159.1967650-1-dtatulea@nvidia.com> <20240816090159.1967650-11-dtatulea@nvidia.com>
In-Reply-To: <20240816090159.1967650-11-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 28 Aug 2024 14:59:05 +0200
Message-ID: <CAJaqyWd0Gwap1253WegSHSADw2ymZ81vvwuTgVMCTSH5-gddbg@mail.gmail.com>
Subject: Re: [PATCH vhost v2 10/10] vdpa/mlx5: Parallelize VQ suspend/resume
 for CVQ MQ command
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
> change_num_qps() is still suspending/resuming VQs one by one.
> This change switches to parallel suspend/resume.
>
> When increasing the number of queues the flow has changed a bit for
> simplicity: the setup_vq() function will always be called before
> resume_vqs(). If the VQ is initialized, setup_vq() will exit early. If
> the VQ is not initialized, setup_vq() will create it and resume_vqs()
> will resume it.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index d1a01c229110..822092eccb32 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2229,25 +2229,27 @@ static int change_num_qps(struct mlx5_vdpa_dev *m=
vdev, int newqps)
>                 if (err)
>                         return err;
>
> -               for (i =3D cur_vqs - 1; i >=3D new_vqs; i--) {
> -                       struct mlx5_vdpa_virtqueue *mvq =3D &ndev->vqs[i]=
;
> -
> -                       if (is_resumable(ndev))
> -                               suspend_vq(ndev, mvq);
> -                       else
> -                               teardown_vq(ndev, mvq);
> +               if (is_resumable(ndev)) {
> +                       suspend_vqs(ndev, new_vqs, cur_vqs - new_vqs);
> +               } else {
> +                       for (i =3D new_vqs; i < cur_vqs; i++)
> +                               teardown_vq(ndev, &ndev->vqs[i]);
>                 }
>
>                 ndev->cur_num_vqs =3D new_vqs;
>         } else {
>                 ndev->cur_num_vqs =3D new_vqs;
> -               for (i =3D cur_vqs; i < new_vqs; i++) {
> -                       struct mlx5_vdpa_virtqueue *mvq =3D &ndev->vqs[i]=
;
>
> -                       err =3D mvq->initialized ? resume_vq(ndev, mvq) :=
 setup_vq(ndev, mvq, true);
> +               for (i =3D cur_vqs; i < new_vqs; i++) {
> +                       err =3D setup_vq(ndev, &ndev->vqs[i], false);
>                         if (err)
>                                 goto clean_added;
>                 }
> +
> +               err =3D resume_vqs(ndev, cur_vqs, new_vqs - cur_vqs);
> +               if (err)
> +                       goto clean_added;
> +
>                 err =3D modify_rqt(ndev, new_vqs);
>                 if (err)
>                         goto clean_added;
> --
> 2.45.1
>


