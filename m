Return-Path: <kvm+bounces-61253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF217C123B0
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 01:44:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AD773B46CE
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF2EF20DD72;
	Tue, 28 Oct 2025 00:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gzVAMpHp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDA11F4281
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 00:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761612170; cv=none; b=H5lAGc/DLPovDwWWl3iR99bsyAk/1AOuSRV73zX26z93FcnJfilIhrk81vvxH4CWdPJGRICPJMGz+FEKsekhyK5AXbUer6zHjPFFwsrHmCTB69MdQCJbBQdd/AdG9DT5tbgVCoxfCADuQ7MQ9oiy5Qx/KGdOA5tswbLg8v+rn6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761612170; c=relaxed/simple;
	bh=Oaec4CMUKIqFFDe8IlwQUNfn1sis7V34LfNDLJjhz+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M5cCKlmFhjFGtQOfLIZL73jWy0bqBp3iYU52muj20GsW4L2FH20e7cbVgNoQi4qMWWD1nxBqkPQ3bE4YQR+9WChOa/FNxpXMEp7C/L329HoMga6HxAyN1uOFgKsD5RQZ9mn2I5Qz0ympm5cMBdiSjnUjzn/oNiJ0rBvlIqDIVbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gzVAMpHp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761612166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4S4XxcpkkVefNpOn6q/1PCcyZWnz2c3jb89kMwD+Dak=;
	b=gzVAMpHpeSrI5EGcG+s/qHABSdX1q3UI2E5wTBlosIM+AZ0bxmORWn9xttDvTnLvtE/+lR
	O1shjJrRKGULEbQ1jHOJx6ThQn3e2yMZL5VS7gAU7ecFUh3VhB4Fhqy+7oA4Ih81vWoZwG
	ma4ryLDn2fZQqWC3XK8/ycB/J8CsdLA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-Qv37OXjQOVuwTAn1juDxKw-1; Mon, 27 Oct 2025 20:42:45 -0400
X-MC-Unique: Qv37OXjQOVuwTAn1juDxKw-1
X-Mimecast-MFC-AGG-ID: Qv37OXjQOVuwTAn1juDxKw_1761612164
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-340299fd99dso314411a91.0
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 17:42:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761612164; x=1762216964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4S4XxcpkkVefNpOn6q/1PCcyZWnz2c3jb89kMwD+Dak=;
        b=D7XlgI23Nf3AcIaOYku0XGryZJU/lWZr/RjPs4XciWSJV06eNW48d2vyNEI263/ZZv
         NHwDhnHbt07Ip/Sm25cRlN3/V7Dxv8JPLzOP0kMlEK95aJfu8VtRQ9uthAuDICd/FVwu
         +0HvYRQARf3XcoVVKy7ofzteu6jCKAmuX5eauGK3pt6imCHUps9r6Lvtb9NZntRW68US
         wl2EWgQ9R5NCs/4VQ0d1T6fEwaUNzyHKLyYxpxmSMCbiHX4uXa9uvRJ9CKdN7xgTKUYp
         F41FTDTlKCnA2M0JNkFKLGwqeNyMXjTHbEIEoqOJf8+pSIprvuvKMY8oNiDh0EyLsSZi
         vbdw==
X-Forwarded-Encrypted: i=1; AJvYcCUVP0ECdh1iNHWUtGANVbbnbp+OEL5L5ecsnR8ANREyEPorxh8mjWcD//Y734VlVXqMG5U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeV+Xo8z/C/ZwsHFaY4X7jdIVblYuY1/A+OgYA0/X+GVyt5FGc
	tjL9Ki14tKRStWANENTAwHQS8m4qr9wGiJvn+Fv7wM3Hp6LJ/KGvo4bvmcIDTbjqPCceR2EvrSj
	+feEk+/2AwnmAY5GLhQq1ZhQt/Yq/RZ8G56Mmw06e7Ly8cHR+o7I+NsmZkuapXFljzid7QllpAy
	em07cV/UQFqsqiuAIHnkNYD8sMXVgP
X-Gm-Gg: ASbGncvacZB7+hap8fkKeno93MAE8+VPMWAGkqoFR5dbdeO9ph2kT5c6ctJI5C6rUjx
	bh7FDfYh5xXdUyqSeGIiZwtofRkfEDW+cAyoWWUMte5TAR2Oi5n8xJwg0bFSmB2hgO13OCnn0CY
	/nyVXahArqT0LZpO/JLvcCfMlGilDlpWOmDFPpPjTCmQZSraIUrpfnRI76
X-Received: by 2002:a17:90b:56cc:b0:330:6d2f:1b5d with SMTP id 98e67ed59e1d1-34027aac137mr1890126a91.26.1761612163813;
        Mon, 27 Oct 2025 17:42:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeNHCkzvcBmGGrJKaZzXODCr5cxEfASlCJa7QDO1rQohJ+NiOJXFwAxYkL7H35SEY2hZXkIcNLNUTEFlIZH4E=
X-Received: by 2002:a17:90b:56cc:b0:330:6d2f:1b5d with SMTP id
 98e67ed59e1d1-34027aac137mr1890105a91.26.1761612163245; Mon, 27 Oct 2025
 17:42:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027102644.622305-1-nhudson@akamai.com>
In-Reply-To: <20251027102644.622305-1-nhudson@akamai.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 28 Oct 2025 08:42:32 +0800
X-Gm-Features: AWmQ_bklpkUHU7-3U6X8wKJFt2zjBDUD0EycaiSZymIdh7dZBD-GL8V0CTdBW5Y
Message-ID: <CACGkMEtyX6n9uLMmo7X08tFS-V6QZoDVTxhE53h9sLDPNBKnKw@mail.gmail.com>
Subject: Re: [PATCH] vhost: add a new ioctl VHOST_GET_VRING_WORKER_INFO and
 use in net.c
To: Nick Hudson <nhudson@akamai.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Max Tottenham <mtottenh@akamai.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 6:27=E2=80=AFPM Nick Hudson <nhudson@akamai.com> wr=
ote:
>
> The vhost_net (and vhost_sock) drivers create worker tasks to handle
> the virtual queues. Provide a new ioctl VHOST_GET_VRING_WORKER_INFO that
> can be used to determine the PID of these tasks so that, for example,
> they can be pinned to specific CPU(s).
>
> Signed-off-by: Nick Hudson <nhudson@akamai.com>
> Reviewed-by: Max Tottenham <mtottenh@akamai.com>
> ---
>  drivers/vhost/net.c              |  5 +++++
>  drivers/vhost/vhost.c            | 16 ++++++++++++++++
>  include/uapi/linux/vhost.h       |  3 +++
>  include/uapi/linux/vhost_types.h | 13 +++++++++++++
>  kernel/vhost_task.c              | 12 ++++++++++++
>  5 files changed, 49 insertions(+)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 35ded4330431..e86bd5d7d202 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1804,6 +1804,11 @@ static long vhost_net_ioctl(struct file *f, unsign=
ed int ioctl,
>                 return vhost_net_reset_owner(n);
>         case VHOST_SET_OWNER:
>                 return vhost_net_set_owner(n);
> +       case VHOST_GET_VRING_WORKER_INFO:
> +               mutex_lock(&n->dev.mutex);
> +               r =3D vhost_worker_ioctl(&n->dev, ioctl, argp);
> +               mutex_unlock(&n->dev.mutex);
> +               return r;
>         default:
>                 mutex_lock(&n->dev.mutex);
>                 r =3D vhost_dev_ioctl(&n->dev, ioctl, argp);
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 8570fdf2e14a..8b52fd5723c3 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2399,6 +2399,22 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned=
 int ioctl, void __user *argp)
>                 if (ctx)
>                         eventfd_ctx_put(ctx);
>                 break;
> +       case VHOST_GET_VRING_WORKER_INFO:
> +               worker =3D rcu_dereference_check(vq->worker,
> +                                              lockdep_is_held(&dev->mute=
x));
> +               if (!worker) {
> +                       ret =3D -EINVAL;
> +                       break;
> +               }
> +
> +               memset(&ring_worker_info, 0, sizeof(ring_worker_info));
> +               ring_worker_info.index =3D idx;
> +               ring_worker_info.worker_id =3D worker->id;
> +               ring_worker_info.worker_pid =3D task_pid_vnr(vhost_get_ta=
sk(worker->vtsk));
> +
> +               if (copy_to_user(argp, &ring_worker_info, sizeof(ring_wor=
ker_info)))
> +                       ret =3D -EFAULT;
> +               break;
>         default:
>                 r =3D -ENOIOCTLCMD;
>                 break;
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index c57674a6aa0d..c32aa8c71952 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -101,6 +101,9 @@
>  /* Return the vring worker's ID */
>  #define VHOST_GET_VRING_WORKER _IOWR(VHOST_VIRTIO, 0x16,               \
>                                      struct vhost_vring_worker)
> +/* Return the vring worker's ID and PID */
> +#define VHOST_GET_VRING_WORKER_INFO _IOWR(VHOST_VIRTIO, 0x17,  \
> +                                    struct vhost_vring_worker_info)
>
>  /* The following ioctls use eventfd file descriptors to signal and poll
>   * for events. */
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_=
types.h
> index 1c39cc5f5a31..28e00f8ade85 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -63,6 +63,19 @@ struct vhost_vring_worker {
>         unsigned int worker_id;
>  };
>
> +/* Per-virtqueue worker mapping entry */
> +struct vhost_vring_worker_info {
> +       /* vring index */
> +       unsigned int index;
> +       /*
> +        * The id of the vhost_worker returned from VHOST_NEW_WORKER or
> +        * allocated as part of vhost_dev_set_owner.
> +        */
> +       unsigned int worker_id;

I'm not sure the above two are a must and exposing internal workd_id
seems not like a good idea.

> +
> +       __kernel_pid_t worker_pid;  /* PID/TID of worker thread, -1 if no=
ne */

Instead of exposing the worker PID, I wonder if it's simple to just
having a better naming of the worker instead of a simple:

        snprintf(name, sizeof(name), "vhost-%d", current->pid);

> +};
> +
>  /* no alignment requirement */
>  struct vhost_iotlb_msg {
>         __u64 iova;
> diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
> index 27107dcc1cbf..aa87a7f0c98a 100644
> --- a/kernel/vhost_task.c
> +++ b/kernel/vhost_task.c
> @@ -67,6 +67,18 @@ static int vhost_task_fn(void *data)
>         do_exit(0);
>  }
>
> +/**
> + * vhost_get_task - get a pointer to the vhost_task's task_struct
> + * @vtsk: vhost_task to return the task for
> + *
> + * return the vhost_task's task.
> + */
> +struct task_struct *vhost_get_task(struct vhost_task *vtsk)
> +{
> +       return vtsk->task;
> +}
> +EXPORT_SYMBOL_GPL(vhost_get_task);
> +
>  /**
>   * vhost_task_wake - wakeup the vhost_task
>   * @vtsk: vhost_task to wake
> --
> 2.34.1
>

Thanks


