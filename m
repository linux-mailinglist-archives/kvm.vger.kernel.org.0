Return-Path: <kvm+bounces-52035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E458BB000E0
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 13:57:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C06D11C865CB
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 11:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EFC125485A;
	Thu, 10 Jul 2025 11:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="La6FBe+T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB46A2494F0
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 11:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752148604; cv=none; b=XBTPZEDfTQHc5j1z1oM/XLgV8pkOA7hp9gr1/9UXBf2yenyPUCpIISsAh0oc8GVZoM7vnoqwLrTcSFMqep839D8W2q74mcYDzW5sjRQiJbQBqQVCLb6YLhj/0yxxTPM+PlQVo6Ss2NN7jjgm6RzawV/MhpILXSVYYSIcmeovjOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752148604; c=relaxed/simple;
	bh=rb5G70qXFnSXAk+IatFCs9R5tWR/o9T1v9n/4Spo0WM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LAJv75TR7+5aKnpjGqQPbjUORDMdgFyQgZS0SadFiCfmlrNGbgZuwv3MYJeuG1plG/ofZSTV0ZBiBil8vI/nFDuf916no5F81AoPdKI5wru9pNMBuoQnAZeaB86nqy3RIJGy5FBHHrBerlcz+hiRorcqdSJBTueCgF+Y3IJb+Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=La6FBe+T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752148601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kkyFAMEt5Iz+PWCaYqtt6MOGf4QHLSC9s47AzIFA+5A=;
	b=La6FBe+TG9T6s1LTPadxfLXQo85vqMhNhiqre1VapiKWLsSiHAVFkUSUu8Elu+IM2Ts8YV
	VRgVGoBznrPd+y3jEF5YI72O2pyNwY3NnnDRlmihPDRQezxuSkQYTIXR01ow1Oq8BjDN90
	aKRX/MTRZZqT9frCRD1inD3wRPpYTBM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-a8ZDMTKHMaOcYLalbl1SxA-1; Thu, 10 Jul 2025 07:56:39 -0400
X-MC-Unique: a8ZDMTKHMaOcYLalbl1SxA-1
X-Mimecast-MFC-AGG-ID: a8ZDMTKHMaOcYLalbl1SxA_1752148598
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-315af0857f2so1116277a91.0
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 04:56:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752148598; x=1752753398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kkyFAMEt5Iz+PWCaYqtt6MOGf4QHLSC9s47AzIFA+5A=;
        b=xPjvb5Hsi21E4jhKgXjsR8e8mWL7/MRrUqRoPIRCvR75Y/jPipUs5jEIG+twpHNUjC
         6pOoi6yISsQWsjuFQeoLVafe8XEdV6+b3OCzLYNZ0blp7Jg/tW1KzX7ydJkTKt+s+YQp
         c8mGYqrW+RZQTVSK52m63jaIoXhcY9Ekagrf+tNYBCUoC3jAlohKMu9PepRefQ23YX6Z
         95Fi0NhK+T3HFWpV7qiuhRkwylTxt3Nj4a3tl0Y4Cfgs8PqKmTGjTkcOy3GvLc9D0xW1
         Hu3DBM8XFnZpdK2vcEbQPRLTulUBuywQLMawdTfwppoQ8DzWeSivSeNaHSiSwukvFUN/
         marw==
X-Forwarded-Encrypted: i=1; AJvYcCUcKdyD23GaARBTezs2az69qTk+NOW1ISfyBz7S9t3USMpkUlqIgvxDi2DHcjKCY6vtmPE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzF2OE1ryanSHpOCm0rpbg25L3A+agwG39qUcmG1KiCNgZkKkMq
	GXHM3bGZbKah6T/yWMiJu2hgUrqUu7mVArdofzH4CyzK1HBWbnm6ZOfBsJwk0bA+CSyDEtn5uZm
	jMt5A4q89byH8hZKqo4AZsl3MVjmwHtxnfTKnX/Wvw2oRM6vW6WmNkbb2X35v602mfn+J9iuv8/
	jkIZn2TO7NlN5vpDGpTEzi6RxBWo6A
X-Gm-Gg: ASbGncuOHwxjDPFbGpYZBVm8FerdQp2HG2ipHjxt7pg1nqXcfX5tn6ZuDGj33p0PBBX
	IvbtMQL2hfYC7d85wRrMFsYoVz9aty38I46S9VwMvkl2M3N11bwtlTqUTWa/yqu7E9MMLTRajKm
	MCvA==
X-Received: by 2002:a17:90b:3b49:b0:311:e358:c4af with SMTP id 98e67ed59e1d1-31c3f009e6fmr4393638a91.16.1752148598084;
        Thu, 10 Jul 2025 04:56:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGzXDXIYrI4f+jLyxhULQ9DqyW5G8ylmygYQYyAzXd4OJkMIkYk3DytFSfacD1R0OWVPHmUj+PcCPRkbGbaLU=
X-Received: by 2002:a17:90b:3b49:b0:311:e358:c4af with SMTP id
 98e67ed59e1d1-31c3f009e6fmr4393594a91.16.1752148597517; Thu, 10 Jul 2025
 04:56:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250708064819.35282-1-jasowang@redhat.com> <20250708064819.35282-3-jasowang@redhat.com>
In-Reply-To: <20250708064819.35282-3-jasowang@redhat.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 10 Jul 2025 13:56:01 +0200
X-Gm-Features: Ac12FXxqyil8MqjxEy578TLpzJROnoKM1BcKhfmfNf8EzAA5LKZlAqaOzlkMxyw
Message-ID: <CAJaqyWcSakXs2GC5QkRtT7BjOK3Mzb-RxS198N+ePqKG9h_BhA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] vhost_net: basic in_order support
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jonah.palmer@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 8, 2025 at 8:48=E2=80=AFAM Jason Wang <jasowang@redhat.com> wro=
te:
>
> This patch introduces basic in-order support for vhost-net. By
> recording the number of batched buffers in an array when calling
> `vhost_add_used_and_signal_n()`, we can reduce the number of userspace
> accesses. Note that the vhost-net batching logic is kept as we still
> count the number of buffers there.
>
> Testing Results:
>
> With testpmd:
>
> - TX: txonly mode + vhost_net with XDP_DROP on TAP shows a 17.5%
>   improvement, from 4.75 Mpps to 5.35 Mpps.
> - RX: No obvious improvements were observed.
>
> With virtio-ring in-order experimental code in the guest:
>
> - TX: pktgen in the guest + XDP_DROP on  TAP shows a 19% improvement,
>   from 5.2 Mpps to 6.2 Mpps.
> - RX: pktgen on TAP with vhost_net + XDP_DROP in the guest achieves a
>   6.1% improvement, from 3.47 Mpps to 3.61 Mpps.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Thanks!

> ---
>  drivers/vhost/net.c | 86 ++++++++++++++++++++++++++++++++-------------
>  1 file changed, 61 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 4f9c67f17b49..8ac994b3228a 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -74,7 +74,8 @@ enum {
>                          (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
>                          (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
>                          (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> -                        (1ULL << VIRTIO_F_RING_RESET)
> +                        (1ULL << VIRTIO_F_RING_RESET) |
> +                        (1ULL << VIRTIO_F_IN_ORDER)
>  };
>
>  enum {
> @@ -450,7 +451,8 @@ static int vhost_net_enable_vq(struct vhost_net *n,
>         return vhost_poll_start(poll, sock->file);
>  }
>
> -static void vhost_net_signal_used(struct vhost_net_virtqueue *nvq)
> +static void vhost_net_signal_used(struct vhost_net_virtqueue *nvq,
> +                                 unsigned int count)
>  {
>         struct vhost_virtqueue *vq =3D &nvq->vq;
>         struct vhost_dev *dev =3D vq->dev;
> @@ -458,8 +460,8 @@ static void vhost_net_signal_used(struct vhost_net_vi=
rtqueue *nvq)
>         if (!nvq->done_idx)
>                 return;
>
> -       vhost_add_used_and_signal_n(dev, vq, vq->heads, NULL,
> -                                   nvq->done_idx);
> +       vhost_add_used_and_signal_n(dev, vq, vq->heads,
> +                                   vq->nheads, count);
>         nvq->done_idx =3D 0;
>  }
>
> @@ -468,6 +470,8 @@ static void vhost_tx_batch(struct vhost_net *net,
>                            struct socket *sock,
>                            struct msghdr *msghdr)
>  {
> +       struct vhost_virtqueue *vq =3D &nvq->vq;
> +       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
>         struct tun_msg_ctl ctl =3D {
>                 .type =3D TUN_MSG_PTR,
>                 .num =3D nvq->batched_xdp,
> @@ -475,6 +479,11 @@ static void vhost_tx_batch(struct vhost_net *net,
>         };
>         int i, err;
>
> +       if (in_order) {
> +               vq->heads[0].len =3D 0;
> +               vq->nheads[0] =3D nvq->done_idx;
> +       }
> +
>         if (nvq->batched_xdp =3D=3D 0)
>                 goto signal_used;
>
> @@ -496,7 +505,7 @@ static void vhost_tx_batch(struct vhost_net *net,
>         }
>
>  signal_used:
> -       vhost_net_signal_used(nvq);
> +       vhost_net_signal_used(nvq, in_order ? 1 : nvq->done_idx);
>         nvq->batched_xdp =3D 0;
>  }
>
> @@ -758,6 +767,7 @@ static void handle_tx_copy(struct vhost_net *net, str=
uct socket *sock)
>         int sent_pkts =3D 0;
>         bool sock_can_batch =3D (sock->sk->sk_sndbuf =3D=3D INT_MAX);
>         bool busyloop_intr;
> +       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
>
>         do {
>                 busyloop_intr =3D false;
> @@ -794,11 +804,13 @@ static void handle_tx_copy(struct vhost_net *net, s=
truct socket *sock)
>                                 break;
>                         }
>
> -                       /* We can't build XDP buff, go for single
> -                        * packet path but let's flush batched
> -                        * packets.
> -                        */
> -                       vhost_tx_batch(net, nvq, sock, &msg);
> +                       if (nvq->batched_xdp) {
> +                               /* We can't build XDP buff, go for single
> +                                * packet path but let's flush batched
> +                                * packets.
> +                                */
> +                               vhost_tx_batch(net, nvq, sock, &msg);
> +                       }
>                         msg.msg_control =3D NULL;
>                 } else {
>                         if (tx_can_batch(vq, total_len))
> @@ -819,8 +831,12 @@ static void handle_tx_copy(struct vhost_net *net, st=
ruct socket *sock)
>                         pr_debug("Truncated TX packet: len %d !=3D %zd\n"=
,
>                                  err, len);
>  done:
> -               vq->heads[nvq->done_idx].id =3D cpu_to_vhost32(vq, head);
> -               vq->heads[nvq->done_idx].len =3D 0;
> +               if (in_order) {
> +                       vq->heads[0].id =3D cpu_to_vhost32(vq, head);
> +               } else {
> +                       vq->heads[nvq->done_idx].id =3D cpu_to_vhost32(vq=
, head);
> +                       vq->heads[nvq->done_idx].len =3D 0;
> +               }
>                 ++nvq->done_idx;
>         } while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)=
));
>
> @@ -999,7 +1015,7 @@ static int peek_head_len(struct vhost_net_virtqueue =
*rvq, struct sock *sk)
>  }
>
>  static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock=
 *sk,
> -                                     bool *busyloop_intr)
> +                                     bool *busyloop_intr, unsigned int c=
ount)
>  {
>         struct vhost_net_virtqueue *rnvq =3D &net->vqs[VHOST_NET_VQ_RX];
>         struct vhost_net_virtqueue *tnvq =3D &net->vqs[VHOST_NET_VQ_TX];
> @@ -1009,7 +1025,7 @@ static int vhost_net_rx_peek_head_len(struct vhost_=
net *net, struct sock *sk,
>
>         if (!len && rvq->busyloop_timeout) {
>                 /* Flush batched heads first */
> -               vhost_net_signal_used(rnvq);
> +               vhost_net_signal_used(rnvq, count);
>                 /* Both tx vq and rx socket were polled here */
>                 vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, true);
>
> @@ -1021,7 +1037,7 @@ static int vhost_net_rx_peek_head_len(struct vhost_=
net *net, struct sock *sk,
>
>  /* This is a multi-buffer version of vhost_get_desc, that works if
>   *     vq has read descriptors only.
> - * @vq         - the relevant virtqueue
> + * @nvq                - the relevant vhost_net virtqueue
>   * @datalen    - data length we'll be reading
>   * @iovcount   - returned count of io vectors we fill
>   * @log                - vhost log
> @@ -1029,14 +1045,17 @@ static int vhost_net_rx_peek_head_len(struct vhos=
t_net *net, struct sock *sk,
>   * @quota       - headcount quota, 1 for big buffer
>   *     returns number of buffer heads allocated, negative on error
>   */
> -static int get_rx_bufs(struct vhost_virtqueue *vq,
> +static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
>                        struct vring_used_elem *heads,
> +                      u16 *nheads,
>                        int datalen,
>                        unsigned *iovcount,
>                        struct vhost_log *log,
>                        unsigned *log_num,
>                        unsigned int quota)
>  {
> +       struct vhost_virtqueue *vq =3D &nvq->vq;
> +       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
>         unsigned int out, in;
>         int seg =3D 0;
>         int headcount =3D 0;
> @@ -1073,14 +1092,16 @@ static int get_rx_bufs(struct vhost_virtqueue *vq=
,
>                         nlogs +=3D *log_num;
>                         log +=3D *log_num;
>                 }
> -               heads[headcount].id =3D cpu_to_vhost32(vq, d);
>                 len =3D iov_length(vq->iov + seg, in);
> -               heads[headcount].len =3D cpu_to_vhost32(vq, len);
> -               datalen -=3D len;
> +               if (!in_order) {
> +                       heads[headcount].id =3D cpu_to_vhost32(vq, d);
> +                       heads[headcount].len =3D cpu_to_vhost32(vq, len);
> +               }
>                 ++headcount;
> +               datalen -=3D len;
>                 seg +=3D in;
>         }
> -       heads[headcount - 1].len =3D cpu_to_vhost32(vq, len + datalen);
> +
>         *iovcount =3D seg;
>         if (unlikely(log))
>                 *log_num =3D nlogs;
> @@ -1090,6 +1111,15 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
>                 r =3D UIO_MAXIOV + 1;
>                 goto err;
>         }
> +
> +       if (!in_order)
> +               heads[headcount - 1].len =3D cpu_to_vhost32(vq, len + dat=
alen);
> +       else {
> +               heads[0].len =3D cpu_to_vhost32(vq, len + datalen);
> +               heads[0].id =3D cpu_to_vhost32(vq, d);
> +               nheads[0] =3D headcount;
> +       }
> +
>         return headcount;
>  err:
>         vhost_discard_vq_desc(vq, headcount);
> @@ -1102,6 +1132,8 @@ static void handle_rx(struct vhost_net *net)
>  {
>         struct vhost_net_virtqueue *nvq =3D &net->vqs[VHOST_NET_VQ_RX];
>         struct vhost_virtqueue *vq =3D &nvq->vq;
> +       bool in_order =3D vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> +       unsigned int count =3D 0;
>         unsigned in, log;
>         struct vhost_log *vq_log;
>         struct msghdr msg =3D {
> @@ -1149,12 +1181,13 @@ static void handle_rx(struct vhost_net *net)
>
>         do {
>                 sock_len =3D vhost_net_rx_peek_head_len(net, sock->sk,
> -                                                     &busyloop_intr);
> +                                                     &busyloop_intr, cou=
nt);
>                 if (!sock_len)
>                         break;
>                 sock_len +=3D sock_hlen;
>                 vhost_len =3D sock_len + vhost_hlen;
> -               headcount =3D get_rx_bufs(vq, vq->heads + nvq->done_idx,
> +               headcount =3D get_rx_bufs(nvq, vq->heads + count,
> +                                       vq->nheads + count,
>                                         vhost_len, &in, vq_log, &log,
>                                         likely(mergeable) ? UIO_MAXIOV : =
1);
>                 /* On error, stop handling until the next kick. */
> @@ -1230,8 +1263,11 @@ static void handle_rx(struct vhost_net *net)
>                         goto out;
>                 }
>                 nvq->done_idx +=3D headcount;
> -               if (nvq->done_idx > VHOST_NET_BATCH)
> -                       vhost_net_signal_used(nvq);
> +               count +=3D in_order ? 1 : headcount;
> +               if (nvq->done_idx > VHOST_NET_BATCH) {
> +                       vhost_net_signal_used(nvq, count);
> +                       count =3D 0;
> +               }
>                 if (unlikely(vq_log))
>                         vhost_log_write(vq, vq_log, log, vhost_len,
>                                         vq->iov, in);
> @@ -1243,7 +1279,7 @@ static void handle_rx(struct vhost_net *net)
>         else if (!sock_len)
>                 vhost_net_enable_vq(net, vq);
>  out:
> -       vhost_net_signal_used(nvq);
> +       vhost_net_signal_used(nvq, count);
>         mutex_unlock(&vq->mutex);
>  }
>
> --
> 2.31.1
>


