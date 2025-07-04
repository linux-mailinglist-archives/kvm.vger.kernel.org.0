Return-Path: <kvm+bounces-51595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2496DAF8F60
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 12:04:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E141586E73
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910802EF9A7;
	Fri,  4 Jul 2025 10:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eyKzGkqX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D38288C1C
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 10:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751623444; cv=none; b=mL2+ezHvDpOHdopnoR4aG2GR/H8zoKmNe/V4S8FFyeCjkPpJtSF9kEwS5HD8dD/lo7mwYvB5+nyW84X2aQav+m0xaiigzC0tGLlv9/0GGhGYAY/N13MeBZgyugcizHQWp5LR0p3y6T0DSocIoIUcm8RfTtCbUkJqD12/UFwSygM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751623444; c=relaxed/simple;
	bh=B7aUvk/jHjdAbP1Txi087l61k45RNX1ZWe+SIygilVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bmq1rie0C9/bOmmgJbID7Gfx1Ib0sYGicYJ0lvKs0Iex9+FFKSQRewtA4jAN1JDwNFPypWa+PI6haJ67UTR0I+43l6n9PsoL7rWrslMLyV07o4+apSZy3DXipu2QqxWHeYVvSJxLl8PqdcFZkMqQnPzWE9z9YD7+1hZfif+LE6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eyKzGkqX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751623441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rWi88a+JkVfvhFesKDsYwPcS3Up3wpcEEvDnhl9YEKo=;
	b=eyKzGkqXL8vpPgddz8IWyIRdr9pBfI6XprIXpUXmxSkbh0ZtZwSnP9GvX2ZbHdMRfB38l4
	iqdEBmqSC3CxGd4M8YhgxAumfTKLgSs5N3uYLeyWx1A+aiWAtic8kNrFYo2aJ0sMpTiuTA
	Teo/EN5UpwwsBgZ6BoKMollsPlhbCsE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-qv616qA2PQGDJd6NAFm21A-1; Fri, 04 Jul 2025 06:04:00 -0400
X-MC-Unique: qv616qA2PQGDJd6NAFm21A-1
X-Mimecast-MFC-AGG-ID: qv616qA2PQGDJd6NAFm21A_1751623439
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ae2b7bdc8f6so80718566b.1
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 03:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751623439; x=1752228239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rWi88a+JkVfvhFesKDsYwPcS3Up3wpcEEvDnhl9YEKo=;
        b=QWKR4b7JDFfvYSGp6iXaGfXVg/hXkOme/7xM37CaXtVQ9PygpEB1/kKGYoHYnIjepp
         Aoi9CvQAJqyH99lmHeTBRMg+Vc8l2J/HccOyTI9dSJdvOaoH4YoKKyo1iB+WSwr4hETY
         OIGRcP8SiUeoQrFtxGOgnFuWORBnRJ6SkDvmOZW5F7PhAQ9mDd+3UgYfLe6vDrmu5UPS
         1kgItMS1KHkbpwxLh/BKCeKcwCeoGfrD4mpP3a9QW2NsxqewWyn+ykkEJzLDyHl8Y3XV
         TqyY7Ne72atz1lJoLPSYEpidWIqUF9PVq+npnUikHwxxVvCSYOIjOCPhIyN/mqElqWOb
         ZpRg==
X-Forwarded-Encrypted: i=1; AJvYcCXkXBcnXjN49MN2n4WEvMaqdRuDVSEzack0MrUm7IZB6fy1hzbBak6q7fkZUigmHispFzM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7LjRnFLlSPaiqB49da+VJFsu6OSf7FVO0/nG/h32mVG9Rk04K
	tcn9bvUHQFk78qKfW3Ho5nCXZiy5U+4fHZdUDlPBSXxT1BjW1hzaeKRvNTgxazGEKUoJjfDrWEl
	r2nWBSt+hmLd6eaW6YY77c2+Wmj1hDY1zReUIaFJsQm4j+fJgjxulVRr2yCVuODKuNhd6+mM84L
	v4cKDdfXIwP/T4V+OP1nTc094+7yf7
X-Gm-Gg: ASbGnctajmOWhjjQypNh11gKm0C1mBNrCAQmMPQ4gHjywzPp8LQsNdnbNvbDW38t5n/
	7XifjJ3YE5aW6IJNhwfM2eekXvjLfhbRMYGVex04TKMfBi7meBJk4blmySd7koDqHs85bF4isDR
	g4DDwW
X-Received: by 2002:a17:907:1b28:b0:ae3:6038:ad6f with SMTP id a640c23a62f3a-ae3f801ffffmr257588266b.3.1751623439181;
        Fri, 04 Jul 2025 03:03:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHS9N1eCIk/WZ0O55TJaTXfCqhycvxAdX3gpiv7v0S1xEAaaTDokoaZNHnw35/eNshgWtKvOMMHV8DKBFb9MEc=
X-Received: by 2002:a17:907:1b28:b0:ae3:6038:ad6f with SMTP id
 a640c23a62f3a-ae3f801ffffmr257584266b.3.1751623438615; Fri, 04 Jul 2025
 03:03:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250702014139.721-1-liming.wu@jaguarmicro.com>
In-Reply-To: <20250702014139.721-1-liming.wu@jaguarmicro.com>
From: Lei Yang <leiyang@redhat.com>
Date: Fri, 4 Jul 2025 18:03:21 +0800
X-Gm-Features: Ac12FXx2LPRflMaDOhrK2WN9s4Zkqha02pwAGwf7MkpIy2PH8obbz9l4skjV1c8
Message-ID: <CAPpAL=wY_JU7r8oWgcF_keq+rbpGdkhS5KF0K67g=rbX7_nwng@mail.gmail.com>
Subject: Re: [PATCH] virtio_net: simplify tx queue wake condition check
To: liming.wu@jaguarmicro.com
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, angus.chen@jaguarmicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I tested this patch with virito-net regression tests, everything works fine=
.

Tested-by: Lei Yang <leiyang@redhat.com>

On Wed, Jul 2, 2025 at 9:42=E2=80=AFAM <liming.wu@jaguarmicro.com> wrote:
>
> From: Liming Wu <liming.wu@jaguarmicro.com>
>
> Consolidate the two nested if conditions for checking tx queue wake
> conditions into a single combined condition. This improves code
> readability without changing functionality. And move netif_tx_wake_queue
> into if condition to reduce unnecessary checks for queue stops.
>
> Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
> ---
>  drivers/net/virtio_net.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index e53ba600605a..6f3d69feb427 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2998,12 +2998,11 @@ static void virtnet_poll_cleantx(struct receive_q=
ueue *rq, int budget)
>                         free_old_xmit(sq, txq, !!budget);
>                 } while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
>
> -               if (sq->vq->num_free >=3D 2 + MAX_SKB_FRAGS) {
> -                       if (netif_tx_queue_stopped(txq)) {
> -                               u64_stats_update_begin(&sq->stats.syncp);
> -                               u64_stats_inc(&sq->stats.wake);
> -                               u64_stats_update_end(&sq->stats.syncp);
> -                       }
> +               if (sq->vq->num_free >=3D 2 + MAX_SKB_FRAGS &&
> +                   netif_tx_queue_stopped(txq)) {
> +                       u64_stats_update_begin(&sq->stats.syncp);
> +                       u64_stats_inc(&sq->stats.wake);
> +                       u64_stats_update_end(&sq->stats.syncp);
>                         netif_tx_wake_queue(txq);
>                 }
>
> @@ -3195,12 +3194,11 @@ static int virtnet_poll_tx(struct napi_struct *na=
pi, int budget)
>         else
>                 free_old_xmit(sq, txq, !!budget);
>
> -       if (sq->vq->num_free >=3D 2 + MAX_SKB_FRAGS) {
> -               if (netif_tx_queue_stopped(txq)) {
> -                       u64_stats_update_begin(&sq->stats.syncp);
> -                       u64_stats_inc(&sq->stats.wake);
> -                       u64_stats_update_end(&sq->stats.syncp);
> -               }
> +       if (sq->vq->num_free >=3D 2 + MAX_SKB_FRAGS &&
> +           netif_tx_queue_stopped(txq)) {
> +               u64_stats_update_begin(&sq->stats.syncp);
> +               u64_stats_inc(&sq->stats.wake);
> +               u64_stats_update_end(&sq->stats.syncp);
>                 netif_tx_wake_queue(txq);
>         }
>
> --
> 2.34.1
>
>


