Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1B77AE438
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 05:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbjIZDev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 23:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjIZDeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 23:34:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989B2DD
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 20:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695699239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VemcH0Pxc7gzhy8cLvwCxUH2+uz/mp+txw8hIJIiBPM=;
        b=OOz5t0m3wfjnubxtzlYDthhtROxHIncx5c7QA9bti0wy8c6t+CSahHH141R0k/kEYfDLzf
        rJDaadBYhJBUf5tUsNj2R1rtwODL2viK4R52m3rDoZYoztkl2QAweIEiOJJHJrxPiaHfGg
        REgUghB8GRC+TluSv8nXGMrox1t7pXQ=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-oW4Tm5U7NgKShjrH6Cydgg-1; Mon, 25 Sep 2023 23:33:58 -0400
X-MC-Unique: oW4Tm5U7NgKShjrH6Cydgg-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5043c0cbb62so8938884e87.1
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 20:33:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695699236; x=1696304036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VemcH0Pxc7gzhy8cLvwCxUH2+uz/mp+txw8hIJIiBPM=;
        b=ef2wbVyvvfta0T88pGPNHASLF/eCRa1pJLblt09h6su/SPjGrXQGGjdSPqsMauhFTo
         RGhw3Pj8xhHbnd9O6ZzxS0XxrP5W5+KXJe+p+NBWGs6jzhvHsT4WdKuDo1pF0W7zDWU3
         uyWese46O6wEE+48EPzVOmxNL7cAhDXEluFnnoTC2uhugEaqhzGmgfG+cZoqXO8tuqEt
         lW4VOFknj4ow5hFkMvDcRW67M2TvFyQPFZZeDVeHmknxf0iFtIxHP4WA9y9GTSFQlo18
         +nbF1Hv6zpnqT+KXeL/NAjsJnaVdxN+06+sAZY7E6eCSDd/M3evChy1MtL41o/5iEExz
         tsJg==
X-Gm-Message-State: AOJu0Yzkl1Ow5RcLB4SJEPjbmVQLxfszq/aQojSleIqB4fBhXx09Z/Ax
        1Qso13VWjkv89PBt5aNTcCUVGHu6tRlI5GZkTYDUriVdHyUxQnxQv1RRJBkvnN5mZJ6g0ruQYsN
        HB9UxW5htF4gY/NLXF6EtXXmkHNYZ
X-Received: by 2002:a05:6512:3daa:b0:503:1adf:b4d5 with SMTP id k42-20020a0565123daa00b005031adfb4d5mr8636666lfv.52.1695699236802;
        Mon, 25 Sep 2023 20:33:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKxKhnIjCY2u75vQcX2wF3cjPA5sZgxKb74ILugVtiuipD5V5dNcKckwfV7TbxCYM65s77akemf8UqWtEbv3E=
X-Received: by 2002:a05:6512:3daa:b0:503:1adf:b4d5 with SMTP id
 k42-20020a0565123daa00b005031adfb4d5mr8636648lfv.52.1695699236445; Mon, 25
 Sep 2023 20:33:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230912130132.561193-1-dtatulea@nvidia.com> <20230912130132.561193-8-dtatulea@nvidia.com>
In-Reply-To: <20230912130132.561193-8-dtatulea@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 26 Sep 2023 11:33:45 +0800
Message-ID: <CACGkMEuC+TrrZ-=63XpFySzcvHYD+0YyJxF9ckx7ZSJqSS0JOw@mail.gmail.com>
Subject: Re: [PATCH 07/16] vdpa/mlx5: Collapse "dvq" mr add/delete functions
To:     Dragos Tatulea <dtatulea@nvidia.com>
Cc:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 12, 2023 at 9:02=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> Now that the cvq code is out of mlx5_vdpa_create/destroy_mr, the "dvq"
> functions can be folded into their callers.
>
> Having "dvq" in the naming will no longer be accurate in the downstream
> patches.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vdpa/mlx5/core/mr.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> index 587300e7c18e..fde00497f4ad 100644
> --- a/drivers/vdpa/mlx5/core/mr.c
> +++ b/drivers/vdpa/mlx5/core/mr.c
> @@ -489,7 +489,7 @@ static void destroy_user_mr(struct mlx5_vdpa_dev *mvd=
ev, struct mlx5_vdpa_mr *mr
>         }
>  }
>
> -static void _mlx5_vdpa_destroy_dvq_mr(struct mlx5_vdpa_dev *mvdev, unsig=
ned int asid)
> +static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, unsigned =
int asid)
>  {
>         struct mlx5_vdpa_mr *mr =3D &mvdev->mr;
>
> @@ -513,7 +513,7 @@ void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *=
mvdev, unsigned int asid)
>
>         mutex_lock(&mr->mkey_mtx);
>
> -       _mlx5_vdpa_destroy_dvq_mr(mvdev, asid);
> +       _mlx5_vdpa_destroy_mr(mvdev, asid);
>
>         mutex_unlock(&mr->mkey_mtx);
>  }
> @@ -524,9 +524,9 @@ void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev=
)
>         prune_iotlb(mvdev);
>  }
>
> -static int _mlx5_vdpa_create_dvq_mr(struct mlx5_vdpa_dev *mvdev,
> -                                   struct vhost_iotlb *iotlb,
> -                                   unsigned int asid)
> +static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
> +                               struct vhost_iotlb *iotlb,
> +                               unsigned int asid)
>  {
>         struct mlx5_vdpa_mr *mr =3D &mvdev->mr;
>         int err;
> @@ -550,12 +550,6 @@ static int _mlx5_vdpa_create_dvq_mr(struct mlx5_vdpa=
_dev *mvdev,
>         return 0;
>  }
>
> -static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
> -                               struct vhost_iotlb *iotlb, unsigned int a=
sid)
> -{
> -       return _mlx5_vdpa_create_dvq_mr(mvdev, iotlb, asid);
> -}
> -
>  int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb =
*iotlb,
>                         unsigned int asid)
>  {
> --
> 2.41.0
>

