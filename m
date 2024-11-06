Return-Path: <kvm+bounces-30969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B9619BF1B0
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFC8D1F217DD
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B295A204F95;
	Wed,  6 Nov 2024 15:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ba8TIHUe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7C22036ED
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 15:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730906990; cv=none; b=ULocI6autBS+b6WB9axOx+7cGU0ouwOoEi8V3vZJLbnAzdt1ZgjKnIf6MlKXQGFH6D/IjfIhqOAHjVltZ3wDFcGSP1zxGZ5dcc+Ocp9wYAhQTGwF3fp/nHGJEbLKgYSe9SkC+H6Nubq8U7ByppPfVrwTOroa95prFTfcPxxRqcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730906990; c=relaxed/simple;
	bh=slDITeVaZJdLWTmohyTCR5uLP4r1HBqbMUAWjzsYL20=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ix/yGcMBAtI3gICwvfh3J5Rw76aWhpPtoQ+9zvfBiUOotPdzAE+6duUSwpvOjvk9ApdrIzDTo+18hKtd1Cbb1bf8DL/Ojhhiqg9aAm30LJ9E73XmG6bIczcnDAeXcuAWIFtWwmvnZ0rKOT+b7Q2kSh6nQVfJ0dPn19xcntP79dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ba8TIHUe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730906987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XOPbnWiJRNPBK8Iuorno9W+gLQNQbKU697K4rUrZaZA=;
	b=Ba8TIHUeQAQ3C2doT4wSRmYL8crxr/xWoPfu+85hlCGkuSvVrLXpDsR4ZH2Jw32iXbCo4c
	X1Kco/OQh/bPvwSdjDJlMEiDW7FZr35OYRYUuPTBGmKDj1g3+VtnXAy+KnIw6vr+sbnp/O
	Z0u9dXbCKYtpxEX+LczBzelOCb4OHa8=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-29pwHJCZMs-CUf458YPpBw-1; Wed, 06 Nov 2024 10:29:46 -0500
X-MC-Unique: 29pwHJCZMs-CUf458YPpBw-1
X-Mimecast-MFC-AGG-ID: 29pwHJCZMs-CUf458YPpBw
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-6ea258fe4b6so137166527b3.1
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 07:29:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730906986; x=1731511786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XOPbnWiJRNPBK8Iuorno9W+gLQNQbKU697K4rUrZaZA=;
        b=MBH7zL1AvfrPSr2DtJWuX+H2cfTwqqOyJuuzsX/PBm6wfLqcZUaUFdWm+sO7zufKk3
         8JGvmewLUwXuYJpM9eOjIsdMIoHBcO+nT/WrfC8+HHIDO/Y3doj23mlagA55mZrO63me
         mvMC9iZ1o4FXLGl5J7H3lC8ZPL4mWWStx+GcUvj6PVyeDW4dXhNnjDqdM/HUnVZ0u/cU
         oJmjaxCMX95SXZkAjMQ/Vw1yvLVf5zQJMqHkCgmwbWfTcR2BJR+mxuHbYF8gC6YUUWjC
         g/ixXRfA4xblOVrGG3yAtPD2DuLuYoo/WupBaYNXUWXqCLiYxfgSxeGaE8HMIpIs33hM
         96sQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSwXG4cPYM6V2I3/TAw6UwvKCz/30F18zt/u91gGJURL8RYEUWEOp4e1O8yW+uuPOcKYk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2kL5/67PFvirg25E1EihHjMPFHguR0qZS7oXJ+qVgH9Nr2OxR
	+ZJgiplTG5kUin2e9Ui3tl9NU9vwoIAUnTNYfKpe0HUxtE8DXz92uHO0TnRMJgv6ATuUmfL6hQV
	6TpccoQMueT1cNJkqs4ImA440tDPhPgJGZCWcYNVcBhuQU197Tm4/ez1+ZwoFqLBhziU1MXq9AH
	8ETUS2yKnvkiI2iaV1Cg5dVV22
X-Received: by 2002:a05:690c:3709:b0:6de:2ae:811f with SMTP id 00721157ae682-6ea64bf4929mr214868907b3.35.1730906984670;
        Wed, 06 Nov 2024 07:29:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF9nPBTHJqeZMQrOB+AjpFwft6nmjDkLsM/1siwtBJuUveAw1rOQNtWk+iPD8sPue9NKKJFYwcetid08rljtMM=
X-Received: by 2002:a05:690c:3709:b0:6de:2ae:811f with SMTP id
 00721157ae682-6ea64bf4929mr214868357b3.35.1730906984105; Wed, 06 Nov 2024
 07:29:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105185101.1323272-2-dtatulea@nvidia.com>
In-Reply-To: <20241105185101.1323272-2-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 6 Nov 2024 16:29:08 +0100
Message-ID: <CAJaqyWeCNfq=M1JSaBjVQLq8_zTpZyMJk0_CWLXVo7v_DGRQFw@mail.gmail.com>
Subject: Re: [PATCH] vdpa/mlx5: Fix error path during device add
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, virtualization@lists.linux.dev, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 7:52=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com>=
 wrote:
>
> In the error recovery path of mlx5_vdpa_dev_add(), the cleanup is
> executed and at the end put_device() is called which ends up calling
> mlx5_vdpa_free(). This function will execute the same cleanup all over
> again. Most resources support being cleaned up twice, but the recent
> mlx5_vdpa_destroy_mr_resources() doesn't.
>
> This change drops the explicit cleanup from within the
> mlx5_vdpa_dev_add() and lets mlx5_vdpa_free() do its work.
>
> This issue was discovered while trying to add 2 vdpa devices with the
> same name:
> $> vdpa dev add name vdpa-0 mgmtdev auxiliary/mlx5_core.sf.2
> $> vdpa dev add name vdpa-0 mgmtdev auxiliary/mlx5_core.sf.3
>
> ... yields the following dump:
>
>   BUG: kernel NULL pointer dereference, address: 00000000000000b8
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: Oops: 0000 [#1] SMP
>   CPU: 4 UID: 0 PID: 2811 Comm: vdpa Not tainted 6.12.0-rc6 #1
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-g=
f21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>   RIP: 0010:destroy_workqueue+0xe/0x2a0
>   Code: ...
>   RSP: 0018:ffff88814920b9a8 EFLAGS: 00010282
>   RAX: 0000000000000000 RBX: ffff888105c10000 RCX: 0000000000000000
>   RDX: 0000000000000001 RSI: ffff888100400168 RDI: 0000000000000000
>   RBP: 0000000000000000 R08: ffff888100120c00 R09: ffffffff828578c0
>   R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>   R13: ffff888131fd99a0 R14: 0000000000000000 R15: ffff888105c10580
>   FS:  00007fdfa6b4f740(0000) GS:ffff88852ca00000(0000) knlGS:00000000000=
00000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00000000000000b8 CR3: 000000018db09006 CR4: 0000000000372eb0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>    <TASK>
>    ? __die+0x20/0x60
>    ? page_fault_oops+0x150/0x3e0
>    ? exc_page_fault+0x74/0x130
>    ? asm_exc_page_fault+0x22/0x30
>    ? destroy_workqueue+0xe/0x2a0
>    mlx5_vdpa_destroy_mr_resources+0x2b/0x40 [mlx5_vdpa]
>    mlx5_vdpa_free+0x45/0x150 [mlx5_vdpa]
>    vdpa_release_dev+0x1e/0x50 [vdpa]
>    device_release+0x31/0x90
>    kobject_put+0x8d/0x230
>    mlx5_vdpa_dev_add+0x328/0x8b0 [mlx5_vdpa]
>    vdpa_nl_cmd_dev_add_set_doit+0x2b8/0x4c0 [vdpa]
>    genl_family_rcv_msg_doit+0xd0/0x120
>    genl_rcv_msg+0x180/0x2b0
>    ? __vdpa_alloc_device+0x1b0/0x1b0 [vdpa]
>    ? genl_family_rcv_msg_dumpit+0xf0/0xf0
>    netlink_rcv_skb+0x54/0x100
>    genl_rcv+0x24/0x40
>    netlink_unicast+0x1fc/0x2d0
>    netlink_sendmsg+0x1e4/0x410
>    __sock_sendmsg+0x38/0x60
>    ? sockfd_lookup_light+0x12/0x60
>    __sys_sendto+0x105/0x160
>    ? __count_memcg_events+0x53/0xe0
>    ? handle_mm_fault+0x100/0x220
>    ? do_user_addr_fault+0x40d/0x620
>    __x64_sys_sendto+0x20/0x30
>    do_syscall_64+0x4c/0x100
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>   RIP: 0033:0x7fdfa6c66b57
>   Code: ...
>   RSP: 002b:00007ffeace22998 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
>   RAX: ffffffffffffffda RBX: 000055a498608350 RCX: 00007fdfa6c66b57
>   RDX: 000000000000006c RSI: 000055a498608350 RDI: 0000000000000003
>   RBP: 00007ffeace229c0 R08: 00007fdfa6d35200 R09: 000000000000000c
>   R10: 0000000000000000 R11: 0000000000000202 R12: 000055a4986082a0
>   R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffeace233f3
>    </TASK>
>   Modules linked in: ...
>   CR2: 00000000000000b8
>
> Fixes: 62111654481d ("vdpa/mlx5: Postpone MR deletion")

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Thanks!

> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index dee019977716..5f581e71e201 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -3963,28 +3963,28 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev=
 *v_mdev, const char *name,
>         mvdev->vdev.dma_dev =3D &mdev->pdev->dev;
>         err =3D mlx5_vdpa_alloc_resources(&ndev->mvdev);
>         if (err)
> -               goto err_mpfs;
> +               goto err_alloc;
>
>         err =3D mlx5_vdpa_init_mr_resources(mvdev);
>         if (err)
> -               goto err_res;
> +               goto err_alloc;
>
>         if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
>                 err =3D mlx5_vdpa_create_dma_mr(mvdev);
>                 if (err)
> -                       goto err_mr_res;
> +                       goto err_alloc;
>         }
>
>         err =3D alloc_fixed_resources(ndev);
>         if (err)
> -               goto err_mr;
> +               goto err_alloc;
>
>         ndev->cvq_ent.mvdev =3D mvdev;
>         INIT_WORK(&ndev->cvq_ent.work, mlx5_cvq_kick_handler);
>         mvdev->wq =3D create_singlethread_workqueue("mlx5_vdpa_wq");
>         if (!mvdev->wq) {
>                 err =3D -ENOMEM;
> -               goto err_res2;
> +               goto err_alloc;
>         }
>
>         mvdev->vdev.mdev =3D &mgtdev->mgtdev;
> @@ -4010,17 +4010,6 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev =
*v_mdev, const char *name,
>         _vdpa_unregister_device(&mvdev->vdev);
>  err_reg:
>         destroy_workqueue(mvdev->wq);
> -err_res2:
> -       free_fixed_resources(ndev);
> -err_mr:
> -       mlx5_vdpa_clean_mrs(mvdev);
> -err_mr_res:
> -       mlx5_vdpa_destroy_mr_resources(mvdev);
> -err_res:
> -       mlx5_vdpa_free_resources(&ndev->mvdev);
> -err_mpfs:
> -       if (!is_zero_ether_addr(config->mac))
> -               mlx5_mpfs_del_mac(pfmdev, config->mac);
>  err_alloc:
>         put_device(&mvdev->vdev.dev);
>         return err;
> --
> 2.47.0
>


