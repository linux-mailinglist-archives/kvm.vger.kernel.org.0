Return-Path: <kvm+bounces-63656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A2AC6C7DA
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 04:00:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 044C8344519
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 02:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C742D1905;
	Wed, 19 Nov 2025 02:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bu0Jm5HU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZXBYrMFC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5902D4816
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 02:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763520996; cv=none; b=GEkvJHuntaxyFRnqc5RNkHus2KNYpJSwcEvAdL3XBH7S0+44nHgHTwI/SrHbGcg523RMSCruKHIvNoUiuSPMKNYQ6FwpPW6xy04zHupQ3h1SeCtqTPm1RGZtnxlud9vIvyOQ3z4pWJlFDWhQc7OZiiQqP1UmIdysMEVtU1ng/sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763520996; c=relaxed/simple;
	bh=G12hxObS9vVdQSHOVQsEwJdya84pJfSeHUQ2pXezb/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DyLghZCqAkDVMsV2CDqQGy+0m378Qt+pXQ0TGCjAZL1FtlkejZyFCGZCiGny10olczdNO0wfeF0iB+RDsTDE8FI9FFufeZMyigPWxbovIerVdqfY4Ck9qfb8i7d2ZgKTYYK13OWzuvy5rTZTFKL8vCpKxOm5kcCISLJbcQmMuuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bu0Jm5HU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZXBYrMFC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763520993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jDvPTx8od/LRicGRV59Ci5CqBppmh/yq9CH+cOE9Xiw=;
	b=Bu0Jm5HUvWXy2aT0LbgwZdQYUPGq1IqUqoc0oi50oLNLTDOj+CWsxMDKmNuLrtZdslSVll
	hP5OW1Zh4s/guy+xx0i909+jKQNb+Qi6+9g+kAZF5q4zYya9bXaYZqn/vvdFol5pbgq/sU
	ZoJa4bY80WLv4rTtnRCi/edLjRLfRf0=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-N_nvdy9CMlSFxEn16AMl4Q-1; Tue, 18 Nov 2025 21:56:32 -0500
X-MC-Unique: N_nvdy9CMlSFxEn16AMl4Q-1
X-Mimecast-MFC-AGG-ID: N_nvdy9CMlSFxEn16AMl4Q_1763520991
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-9372401215fso13318373241.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 18:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763520990; x=1764125790; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jDvPTx8od/LRicGRV59Ci5CqBppmh/yq9CH+cOE9Xiw=;
        b=ZXBYrMFC4R3upu86JqxrnKc8pUwc541fOUIcr2lW83OWb7MyiGlakRT3DQh/NNaklx
         DuI0W82eWlyIfqQgWwvw3aZX99ngVnxCH4UEU4Om8/bCaIEO0sZhrL2fsSRXOMXvVRBO
         X3Z4uIZXaKSeiduiMyfySKcmUQILVfqnXW0vePUqWdvjUv9JDXuRM1iZJKRPUEXGif8E
         1dGc16Bs3uXdqAsvoaJdlFquFjQdEQVB/zz+QvWFbS/Obb4vmUotnaF24u/v9fqxQa0J
         7ma96TyOM2OnZynw7Trsld6H4EpG/uZWGcGkaWVMK2PcFdXm2X2O4knA933oiINc05nV
         qoVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763520990; x=1764125790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jDvPTx8od/LRicGRV59Ci5CqBppmh/yq9CH+cOE9Xiw=;
        b=vTHqUrh6YmL2OBAeZrMMNwgMhGdt1zJFRFOiQbIv8Sud3qExammI2ExrV39akDo4dt
         ET2/JIeAJFULmr6ZduZnx8sUX3w4p7sqjrP26aytRZxJfftgU6gY//884CHOEwU3+mG8
         LtB5RE+BBZd12lK0OiC+HjXXnUnrGecbxqkdCqH1CC6Y2GrPEh1yKpFx6yN70ktZ1xxu
         sQEEo9JHoQ7glnRcflwyTIYhxV2PTqe4+SpdQ9k3qYHTVN1nseIZ20l9Il2+H2QJvbKl
         gRce08Tal6mk6kPA57GkoKLj3vR9nsIE9DLaeZF84xKwpngcgpCkq8fO/A8xiJkPu60v
         pM3w==
X-Forwarded-Encrypted: i=1; AJvYcCWLdfNj3y8N8JGee8xbngojgqJ+b+ppiH1ebf6jtTVnnaAJQP7qb/3IW79FrDrb6eWoUrI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGEakVVYOmEJ3DfeCOUC+3ATOBTJnPLJBtOm0LDHAnlIBszple
	Y1jdB1EH84X+aS01ms2QTdeC0f1J02nP9wN2WiJ3pr5NFt8IahK60RPt9OCKkDhtsIVmxDGNJeJ
	FaU/iWml9T1a5usRFPts5xOIzQKju+yPnqWueNyRLxqvszYDbu3rcoPzAEfxTGXuL0FR7ANMz/v
	bv6TTLDiy5ip8uprb5nZ/sNIjRq9FbARbHK/f9zYM=
X-Gm-Gg: ASbGncvuz53jhsvKhkUrH3dwOstj0+/HydLcVi30x4VVtsA+wHXIQCUHC8Mt6Idatyz
	Xr6I6xu2z4f/Rrg0aYVOPeZket+120RS3W0H2shCLLpdu7639tibtLuDTw7HsqWUin5/AaJ1W3+
	BXJK/b9yEKFwdATFntYDmQ3a6grNk4KD2i1DtetYInUaUx+MF4GZwlpsAtTxDgsf0=
X-Received: by 2002:a05:6102:e0a:b0:5db:ef3f:6c7d with SMTP id ada2fe7eead31-5dfc5556bf8mr6112208137.14.1763520990178;
        Tue, 18 Nov 2025 18:56:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMHvc8TbnsY8T2F+eiw7C0cSgj9lMpJACXTR8AzjwZ2GrCglhiRk/Pmo0QAEu0HhMJS9z+SDjksvQGpkSmyfk=
X-Received: by 2002:a05:6102:e0a:b0:5db:ef3f:6c7d with SMTP id
 ada2fe7eead31-5dfc5556bf8mr6112195137.14.1763520989781; Tue, 18 Nov 2025
 18:56:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118090942.1369-1-liming.wu@jaguarmicro.com>
In-Reply-To: <20251118090942.1369-1-liming.wu@jaguarmicro.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 19 Nov 2025 10:56:17 +0800
X-Gm-Features: AWmQ_bmKFv4JLlor4jL7WLrkrIdgod9abx7FeAA8sB4t9HbQcF1R97xzgCvVagE
Message-ID: <CACGkMEvwedzRrMd9hYm7PbDezBu1GM3q-YcUhsvfYJVv=bNSdw@mail.gmail.com>
Subject: Re: [PATCH] virtio_net: enhance wake/stop tx queue statistics accounting
To: liming.wu@jaguarmicro.com
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, angus.chen@jaguarmicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 5:10=E2=80=AFPM <liming.wu@jaguarmicro.com> wrote:
>
> From: Liming Wu <liming.wu@jaguarmicro.com>
>
> This patch refines and strengthens the statistics collection of TX queue
> wake/stop events introduced by a previous patch.

It would be better to add commit id here.

>
> Previously, the driver only recorded partial wake/stop statistics
> for TX queues. Some wake events triggered by 'skb_xmit_done()' or resume
> operations were not counted, which made the per-queue metrics incomplete.
>
> Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
> ---
>  drivers/net/virtio_net.c | 49 ++++++++++++++++++++++------------------
>  1 file changed, 27 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8e8a179aaa49..f92a90dde2b3 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -775,10 +775,26 @@ static bool virtqueue_napi_complete(struct napi_str=
uct *napi,
>         return false;
>  }
>
> +static void virtnet_tx_wake_queue(struct virtnet_info *vi,
> +                               struct send_queue *sq)
> +{
> +       unsigned int index =3D vq2txq(sq->vq);
> +       struct netdev_queue *txq =3D netdev_get_tx_queue(vi->dev, index);
> +
> +       if (netif_tx_queue_stopped(txq)) {
> +               u64_stats_update_begin(&sq->stats.syncp);
> +               u64_stats_inc(&sq->stats.wake);
> +               u64_stats_update_end(&sq->stats.syncp);
> +               netif_tx_wake_queue(txq);
> +       }
> +}
> +
>  static void skb_xmit_done(struct virtqueue *vq)
>  {
>         struct virtnet_info *vi =3D vq->vdev->priv;
> -       struct napi_struct *napi =3D &vi->sq[vq2txq(vq)].napi;
> +       unsigned int index =3D vq2txq(vq);
> +       struct send_queue *sq =3D &vi->sq[index];
> +       struct napi_struct *napi =3D &sq->napi;
>
>         /* Suppress further interrupts. */
>         virtqueue_disable_cb(vq);
> @@ -786,8 +802,7 @@ static void skb_xmit_done(struct virtqueue *vq)
>         if (napi->weight)
>                 virtqueue_napi_schedule(napi, vq);
>         else
> -               /* We were probably waiting for more output buffers. */
> -               netif_wake_subqueue(vi->dev, vq2txq(vq));
> +               virtnet_tx_wake_queue(vi, sq);
>  }
>
>  #define MRG_CTX_HEADER_SHIFT 22
> @@ -1166,10 +1181,7 @@ static void check_sq_full_and_disable(struct virtn=
et_info *vi,
>                         /* More just got used, free them then recheck. */
>                         free_old_xmit(sq, txq, false);
>                         if (sq->vq->num_free >=3D MAX_SKB_FRAGS + 2) {
> -                               netif_start_subqueue(dev, qnum);
> -                               u64_stats_update_begin(&sq->stats.syncp);
> -                               u64_stats_inc(&sq->stats.wake);
> -                               u64_stats_update_end(&sq->stats.syncp);
> +                               virtnet_tx_wake_queue(vi, sq);

This is suspicious, netif_tx_wake_queue() will schedule qdisc, or is
this intended?

>                                 virtqueue_disable_cb(sq->vq);
>                         }
>                 }
> @@ -3068,13 +3080,8 @@ static void virtnet_poll_cleantx(struct receive_qu=
eue *rq, int budget)
>                         free_old_xmit(sq, txq, !!budget);
>                 } while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
>
> -               if (sq->vq->num_free >=3D MAX_SKB_FRAGS + 2 &&
> -                   netif_tx_queue_stopped(txq)) {
> -                       u64_stats_update_begin(&sq->stats.syncp);
> -                       u64_stats_inc(&sq->stats.wake);
> -                       u64_stats_update_end(&sq->stats.syncp);
> -                       netif_tx_wake_queue(txq);
> -               }
> +               if (sq->vq->num_free >=3D MAX_SKB_FRAGS + 2)
> +                       virtnet_tx_wake_queue(vi, sq);
>
>                 __netif_tx_unlock(txq);
>         }
> @@ -3264,13 +3271,8 @@ static int virtnet_poll_tx(struct napi_struct *nap=
i, int budget)
>         else
>                 free_old_xmit(sq, txq, !!budget);
>
> -       if (sq->vq->num_free >=3D MAX_SKB_FRAGS + 2 &&
> -           netif_tx_queue_stopped(txq)) {
> -               u64_stats_update_begin(&sq->stats.syncp);
> -               u64_stats_inc(&sq->stats.wake);
> -               u64_stats_update_end(&sq->stats.syncp);
> -               netif_tx_wake_queue(txq);
> -       }
> +       if (sq->vq->num_free >=3D MAX_SKB_FRAGS + 2)
> +               virtnet_tx_wake_queue(vi, sq);
>
>         if (xsk_done >=3D budget) {
>                 __netif_tx_unlock(txq);
> @@ -3521,6 +3523,9 @@ static void virtnet_tx_pause(struct virtnet_info *v=
i, struct send_queue *sq)
>
>         /* Prevent the upper layer from trying to send packets. */
>         netif_stop_subqueue(vi->dev, qindex);
> +       u64_stats_update_begin(&sq->stats.syncp);
> +       u64_stats_inc(&sq->stats.stop);
> +       u64_stats_update_end(&sq->stats.syncp);
>
>         __netif_tx_unlock_bh(txq);
>  }
> @@ -3537,7 +3542,7 @@ static void virtnet_tx_resume(struct virtnet_info *=
vi, struct send_queue *sq)
>
>         __netif_tx_lock_bh(txq);
>         sq->reset =3D false;
> -       netif_tx_wake_queue(txq);
> +       virtnet_tx_wake_queue(vi, sq);
>         __netif_tx_unlock_bh(txq);
>
>         if (running)
> --
> 2.34.1
>

Thanks


