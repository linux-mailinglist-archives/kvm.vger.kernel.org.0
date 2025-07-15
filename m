Return-Path: <kvm+bounces-52517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76718B062FD
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 17:32:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46E637AB98F
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B248B24A078;
	Tue, 15 Jul 2025 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WkPjtxJS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B27F1EA7D2
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 15:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752593539; cv=none; b=SGJ9+/kDwf7yA7qzuIeYcSitMwx0WkEZQx0Mwoa0KpGIORkJKMWwA6bHR2MRTt1hQzdVK/7KaAqv4bmecMvjt0YLhvujZKat1/FY7X+J865sy2cFlVRqiid8y91tCWN04eIqqJyA3YUP+32/QZkRnUMmnGiCVjRDzMWv0LjfiYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752593539; c=relaxed/simple;
	bh=5rdRvK0/wv3rgyzsgXz0n1m+AdOdwgEE5BaXSVwhhTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X5xwQPMR01IJj71vfQV4KYN+n7fLUS/Zzr3iOQwfTGGcOPPKD+Szr21LMmmK9lVN4lAntpRLKpYa2xo+5CpJuEibhTfRA3pcfSfXLTYCstCZIKEXygSuoMBH35RJppbYDELpyDUGMoAO6eeaMw8JS3l5iaervhPcJ2bs4hOeVco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WkPjtxJS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752593536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wnh22gI/k+OIEWCf+4ySowORAdVnUSIEoD4hbUCmi1M=;
	b=WkPjtxJSVWQMk2C5as1nCxaCE1ldStlV+zztTaJRs7GiSv4gaCccbRPDfShBs/+COQ/E3i
	clxEm0/cYWCMzkJ5NxM31s5LY/Rxk9cmiMnjOdONXfsEOSFQjM18pjsO9GZkB7wQuKqHGF
	qXGj8KZvoy/qV55Tc7Z+vDaXz39JwTE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-Tqc-6TjfOhuhFkftWYTBnw-1; Tue, 15 Jul 2025 11:32:15 -0400
X-MC-Unique: Tqc-6TjfOhuhFkftWYTBnw-1
X-Mimecast-MFC-AGG-ID: Tqc-6TjfOhuhFkftWYTBnw_1752593534
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ae354979e7aso467669966b.0
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 08:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752593533; x=1753198333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wnh22gI/k+OIEWCf+4ySowORAdVnUSIEoD4hbUCmi1M=;
        b=El64FL4iWqFRjs+lG0hddm3hXKIetPuHomPQ9TNZT/encBE2pTZuVbodyY6sWxzpnU
         WH5SxeJGMyYqEAmksA4lyDZYpQFSu1nJQIe9AD8BgKy3bbzKMXDxCI1/jFn+hG8Ryj9y
         smZ4/NqjZypiAuInDs+hYuWQ/nJ6WaQj95Z/exMriDTTXNzylIfPmvwMrGZlEe/bAmiW
         /PwRV8vuBMVOSbw/J2EgF7/VFyFRk6l8G771UQi9kt2pWZtCSkS8rpAbJFuzhcJy0VA2
         +k/cSr7u0z9arQxZhTc4lo0MI7deFE/szSliR0v2D7pdm1wD2z0ugd51/IbkxTO/bgqN
         yeSA==
X-Forwarded-Encrypted: i=1; AJvYcCU6LvS/4AzAyC0Vasak//+oA4WPid5HEBv0a/PGhtlI2cwfM4mvKooS1VPvIj47uvV6E10=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4w/ehAsZVDBRAioNN9TdVXAfIL7JEcXUfrqGDh9p9Dxx1Ibmx
	SozVOjrvpesnMZt0IhwqvRWXW9CrkikU0UR9ItE63Ipg7kkk5sOuRWNQSwsU8ptlSCxFAVU0U5o
	Olh9kxYjLNOGs7lO7is2oWCPDvg7pEbW7q+sxhbPlWDxQL3NStG2PeZ6kK77WFX23sV2n/yrAbe
	Vaev64uFkhHMQ0aMU9PS1t+bZR36bA9rxlgpnL
X-Gm-Gg: ASbGncvLU+kt5xEwKdsS3hetcqagmPqYfzJc8CxP14jGmtk0xTlxouFt7xGkCDI1rZa
	V9hcQj7Dz9R35nCzFw05pREeuj7eOg65ri7yIoIx/1IYQwrZs4osNosn2/TwyaDXcx/YwAmWyHt
	BQQan3YlGp/dPo8tHzsHo7Tw==
X-Received: by 2002:a17:907:cf93:b0:ae3:cf41:b93b with SMTP id a640c23a62f3a-ae6fc0a7f90mr1582699166b.41.1752593533371;
        Tue, 15 Jul 2025 08:32:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOIuENMcFdE7XVF/eBak/JoBXEh87UvUrI/EctpEOdONudRuCPXduAkkRmy07jHtjgT20K0pXxQIEZJ9U0ySo=
X-Received: by 2002:a17:907:cf93:b0:ae3:cf41:b93b with SMTP id
 a640c23a62f3a-ae6fc0a7f90mr1582696366b.41.1752593532954; Tue, 15 Jul 2025
 08:32:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250710023208.846-1-liming.wu@jaguarmicro.com>
In-Reply-To: <20250710023208.846-1-liming.wu@jaguarmicro.com>
From: Lei Yang <leiyang@redhat.com>
Date: Tue, 15 Jul 2025 23:31:35 +0800
X-Gm-Features: Ac12FXx0K4HuoaUKypyFETVzBZg3F6wzzVt1s3aBwTTAZbrGnPQbtaOUcuDFRP8
Message-ID: <CAPpAL=wvL2LfRV5BFgLVG69hUoO5fYVx6WEK-PimjoQpy1S7ZA@mail.gmail.com>
Subject: Re: [PATCH v2] virtio_net: simplify tx queue wake condition check
To: liming.wu@jaguarmicro.com
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, angus.chen@jaguarmicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested this series of patches v2 with virtio-net regression tests,
everything works fine.

Tested-by: Lei Yang <leiyang@redhat.com>

On Thu, Jul 10, 2025 at 10:32=E2=80=AFAM <liming.wu@jaguarmicro.com> wrote:
>
> From: Liming Wu <liming.wu@jaguarmicro.com>
>
> Consolidate the two nested if conditions for checking tx queue wake
> conditions into a single combined condition. This improves code
> readability without changing functionality. And move netif_tx_wake_queue
> into if condition to reduce unnecessary checks for queue stops.
>
> Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
> Tested-by: Lei Yang <leiyang@redhat.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/virtio_net.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 5d674eb9a0f2..07a378220643 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3021,12 +3021,11 @@ static void virtnet_poll_cleantx(struct receive_q=
ueue *rq, int budget)
>                         free_old_xmit(sq, txq, !!budget);
>                 } while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
>
> -               if (sq->vq->num_free >=3D MAX_SKB_FRAGS + 2) {
> -                       if (netif_tx_queue_stopped(txq)) {
> -                               u64_stats_update_begin(&sq->stats.syncp);
> -                               u64_stats_inc(&sq->stats.wake);
> -                               u64_stats_update_end(&sq->stats.syncp);
> -                       }
> +               if (sq->vq->num_free >=3D MAX_SKB_FRAGS + 2 &&
> +                   netif_tx_queue_stopped(txq)) {
> +                       u64_stats_update_begin(&sq->stats.syncp);
> +                       u64_stats_inc(&sq->stats.wake);
> +                       u64_stats_update_end(&sq->stats.syncp);
>                         netif_tx_wake_queue(txq);
>                 }
>
> @@ -3218,12 +3217,11 @@ static int virtnet_poll_tx(struct napi_struct *na=
pi, int budget)
>         else
>                 free_old_xmit(sq, txq, !!budget);
>
> -       if (sq->vq->num_free >=3D MAX_SKB_FRAGS + 2) {
> -               if (netif_tx_queue_stopped(txq)) {
> -                       u64_stats_update_begin(&sq->stats.syncp);
> -                       u64_stats_inc(&sq->stats.wake);
> -                       u64_stats_update_end(&sq->stats.syncp);
> -               }
> +       if (sq->vq->num_free >=3D MAX_SKB_FRAGS + 2 &&
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


