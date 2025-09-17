Return-Path: <kvm+bounces-57823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CABCB7C40A
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32678466BD7
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 08:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E3B306B23;
	Wed, 17 Sep 2025 08:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bh/+xZuC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBBE2192E3
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 08:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758096965; cv=none; b=TiAzCpTzAB/KvudML/WS5/6ytO+IOTjKs1KFdkv/u+NDbc7iMLHA4RoOJ13mJLXIiWYZj3PT9bAauIVU0q4QBphJ4JeZldmPmNq6BNGikS3EZC+BcGl1DznrfYBU6mUGQNX6yNU9P/xULdeGkB298M8I0WtfXfvy+mBJ9fVVltE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758096965; c=relaxed/simple;
	bh=DZJjEilvh8soI1BKTSfA4Ey5iDL2dw9rLc+r+sxOjtU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NkEqA266eKX+ouDEcMdWF4BjpUSl0ibdEOcf5nEdCA3c7okpHkYsmRVXmDAj8uZLxOC2+IK/Xrkz+oUZgAfku1ydCTvb70pv54bq0LCO768lwa3FE+SgwX8dIzQB3hUFyWuvgAnGaCGJlwo3yC7sgPsDF/7TSO1wv19VDigYhY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bh/+xZuC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758096962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eedUNpaU5+NqwyQ8eXKTY11TfX3TYBW7jRyqO48Q8K4=;
	b=Bh/+xZuCBTLsKq6qq1z4pHIpwwckSu3sLIQAflRmtbQu4Q9/qikeVpOXQjxpouujU90+ca
	c2QvS8xu5s8dRusGbIan7ZYk4nQ036udxUyEatrHWy05ZVy1mw3nZJHVbALDxEFKPJDhxl
	w69LKJjCuN5/zH/es/bKZeEEE2cuBxA=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-WJdUPLOrPSyUJaRxUodryw-1; Wed, 17 Sep 2025 04:16:01 -0400
X-MC-Unique: WJdUPLOrPSyUJaRxUodryw-1
X-Mimecast-MFC-AGG-ID: WJdUPLOrPSyUJaRxUodryw_1758096960
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-7238c540fdcso68307517b3.2
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 01:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758096960; x=1758701760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eedUNpaU5+NqwyQ8eXKTY11TfX3TYBW7jRyqO48Q8K4=;
        b=CeLpXjE78UUyi9S4+7yElvjcV2zknKnLBHzn4hQdzQsYIfjDSCBMSFHbUTlmfpMNWm
         O05X6yWr6H98UEN++T30qgfNG6acCayTVcgU84epdP7S4HEvHEwBwIGcwM3mB03R2Siz
         DGoHLoyZHb+dJD/quKRggyCEbFPWiPPSc2rg3UrzAsPELeIRv5rIrN7sY77NyZNMPNfT
         8dVHrWdsuVZCAtzeYEsaDyN/2Xdes5mOVNctQKORBiyle8wZ8VKnoNobzwsNdteYXL32
         hGrJW/ZnsyNb9mvxdrd0FmWwi48WfUvg3ejhBKxDN/f1wV0eM00P6KvKTI9OHLHyqW0c
         AeqQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4AsYpJnoUzFQbXhd9dCf1rQ7LNaDGunYKLxtoWkCqIvpSD6vgdNYTK3rtvY97ci6hTv4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3/91kBlvzDmGFc+SC2WXyzD5H0IckA2PWwXLR58KcPlyWgYem
	pu2h96yHsPjMJFeAikrKpfAxDk5+ZR5G9UMIxvQ0+30ZRSnl1NdHJav2xQ9CQ6QtSZr+EX3SLrm
	cap/nJh5XE+QcWKhJ8uzPwNWQUxTHmwO7nG6TDzwfGUo5onIo+QtNhNuI26GQsu/9U6uiLN+QkQ
	Th+53mz2F4ASnOEYH8MdLWwgpvljuPZLM+x48ZTjYBQQ==
X-Gm-Gg: ASbGncte7D7uhjrM10Zut/eimWs4ulWi0rLZ3L/JjIcz8auHF4+GSCvIU+tcyHR8754
	FD4TzFJ5ujbwPO28Qwy2OtbOJcxwYbHWj5ccQ181fS5pf/5NNYM1021v/q4tL8iOy7R0suV33JP
	/AAhCqBQDmzJ5RgEZz61IbVBx9vbHs7v0HAnl7FafBRBxTXCMz19ksp8NJTHAQyuqUtjG86HmeA
	lehWOLD
X-Received: by 2002:a05:690c:6c86:b0:723:b37b:f75f with SMTP id 00721157ae682-73891b87784mr10853787b3.26.1758096959686;
        Wed, 17 Sep 2025 01:15:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyEE0NjY/G5cvHcAfaFUYZLAJa4QZLLCvZPWadjWH10jQVSkAeb7QCxJDkVvvAIV4aZoNVgVWuy6Xs42oRk5I=
X-Received: by 2002:a05:690c:6c86:b0:723:b37b:f75f with SMTP id
 00721157ae682-73891b87784mr10853617b3.26.1758096959304; Wed, 17 Sep 2025
 01:15:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917063045.2042-1-jasowang@redhat.com>
In-Reply-To: <20250917063045.2042-1-jasowang@redhat.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 17 Sep 2025 10:15:22 +0200
X-Gm-Features: AS18NWDDF_GZcJeZupVOj5tO-bkVG3qVNzTBHe2X19uvGqJmtk3QOixi1mHlzhU
Message-ID: <CAJaqyWdoLiXJ8Skgwp14Ov66WP1wjnJkR0wwUdmcziSAFJoxCA@mail.gmail.com>
Subject: Re: [PATCH vhost 1/3] vhost-net: unbreak busy polling
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, jonah.palmer@oracle.com, kuba@kernel.org, jon@nutanix.com, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 8:31=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> Commit 67a873df0c41 ("vhost: basic in order support") pass the number
> of used elem to vhost_net_rx_peek_head_len() to make sure it can
> signal the used correctly before trying to do busy polling. But it
> forgets to clear the count, this would cause the count run out of sync
> with handle_rx() and break the busy polling.
>
> Fixing this by passing the pointer of the count and clearing it after
> the signaling the used.
>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> Cc: stable@vger.kernel.org
> Fixes: 67a873df0c41 ("vhost: basic in order support")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/net.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index c6508fe0d5c8..16e39f3ab956 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1014,7 +1014,7 @@ static int peek_head_len(struct vhost_net_virtqueue=
 *rvq, struct sock *sk)
>  }
>
>  static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock=
 *sk,
> -                                     bool *busyloop_intr, unsigned int c=
ount)
> +                                     bool *busyloop_intr, unsigned int *=
count)
>  {
>         struct vhost_net_virtqueue *rnvq =3D &net->vqs[VHOST_NET_VQ_RX];
>         struct vhost_net_virtqueue *tnvq =3D &net->vqs[VHOST_NET_VQ_TX];
> @@ -1024,7 +1024,8 @@ static int vhost_net_rx_peek_head_len(struct vhost_=
net *net, struct sock *sk,
>
>         if (!len && rvq->busyloop_timeout) {
>                 /* Flush batched heads first */
> -               vhost_net_signal_used(rnvq, count);
> +               vhost_net_signal_used(rnvq, *count);
> +               *count =3D 0;
>                 /* Both tx vq and rx socket were polled here */
>                 vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, true);
>
> @@ -1180,7 +1181,7 @@ static void handle_rx(struct vhost_net *net)
>
>         do {
>                 sock_len =3D vhost_net_rx_peek_head_len(net, sock->sk,
> -                                                     &busyloop_intr, cou=
nt);
> +                                                     &busyloop_intr, &co=
unt);
>                 if (!sock_len)
>                         break;
>                 sock_len +=3D sock_hlen;
> --
> 2.34.1
>


