Return-Path: <kvm+bounces-67348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 59E70D00F97
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 05:38:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2CF5C301DE32
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 04:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB75299927;
	Thu,  8 Jan 2026 04:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZVXjUO8P";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KSnix7w5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EB2296BD6
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 04:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767847077; cv=none; b=f9q7TWmTwAWSIX132IeEAf1yopnEjHCdpQp9vsSOWBfS45C6mVCPNEQER8fo168SVvAwm+qLs1zTC4GDvTYlOp1MfhmHaWptkRd9ExYzHHEbiEQ8CClp1xr3IPHNh8kbgtrmAcdHIXqlwTTg7dSSdDAY18pm7tflQv8LG6jrMIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767847077; c=relaxed/simple;
	bh=EHUBmEarbkqeknUga6s29EH7ucSXyuJH72yRaZDXOAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lo8EZcNHJNPeapmglHptqS0iOq8aShiUvQ3wTIZoarR5NS2rl8anwrsQ6k6UAJXr6L2RJZwdUQ3/IT3F6xjLsu7/NDJkoYTyEErM/+SS/hBUdX2hqv2EZQw99BIx9tE3Sh9WDXiDgzSNfWN6T/QoKW/QQn/ks8M1H/fu2+x77wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZVXjUO8P; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KSnix7w5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767847074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nGJJ3mghZGQyoRGajBObKXNhhk9ab2WcIcydiR3jcw4=;
	b=ZVXjUO8PVn8FmelaUsOCcHfbJQBS6PYPrE3aLDfrAMSilKx6WisRlUp4ZLq0KZj8xP6azi
	COSa3bFGzkjfRqR0PPswqCwhozftBdlclgmDr/ZH5BbwCLzpZqjnx0OMM1eg6BoDdcJr2+
	cCJ69omyEUqvXrqghiUqAge+K7kHgJo=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-QfA0f4M9MAm5iPHtI926VQ-1; Wed, 07 Jan 2026 23:37:52 -0500
X-MC-Unique: QfA0f4M9MAm5iPHtI926VQ-1
X-Mimecast-MFC-AGG-ID: QfA0f4M9MAm5iPHtI926VQ_1767847072
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34c5d203988so5479500a91.3
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 20:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767847072; x=1768451872; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGJJ3mghZGQyoRGajBObKXNhhk9ab2WcIcydiR3jcw4=;
        b=KSnix7w5wJ4AfIiytZ5NoETEwEz5NCEsDeuELbBgf1W5w+aG8uy21LIDTqjcK7C5Ct
         oe/KE82Zga7PS69f3zPfJy5nOvbqXMG7lGp8SdeVmOahemVCJPqXdXVJrB2omSSlWiCC
         Mw4vV+jzB0eoItq0fPpbg8eh/GRS/eR1j/av8i1tnIhibj0dyVk57B8zZeKbd103Hwk4
         kimmJCVUB8r0lEJNVVChVP2RlBb/MD94aLV9qKk+uw6JeDKhCGqqicks1RdchWu6qUxW
         aKIIatSJH6I2FhPx4DSmRW5V30TTxkrGz/WFmLpIqM8/ma5pFA+OySa61Dx1zwEwIvGa
         AebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767847072; x=1768451872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nGJJ3mghZGQyoRGajBObKXNhhk9ab2WcIcydiR3jcw4=;
        b=aV6MWy2+Ff9gxEadO8qIORkHfti7CwZH+SUQzcUUON4rXEpfj2pzACwVj0DsaA91tJ
         28Vu9kRAHQPZGHAXhdaKL/AVRJvKIUZlL1FZ1YKZfpgQIWiYcvLxN4iTAQcmSMobbGMH
         xkDdkUFfqPmu4sdJhmMB41DDH3ePh2Vo4kERvKbZO8Su4drSOnRKN9DqCqeH/rIqUAat
         xLlfW7ZiF/VhNlckSfXstP2O42zcQ2FuJvPFbp0q/iudSzrutuj5V+PZSBi757DGQ/ZQ
         VCkwLiQ8uh0yiYoSMX9zNQKinKFMxoElWw6fbAD2C6g9wQxCFHtv9Gm1bsNYP5gUwyOX
         9x1g==
X-Forwarded-Encrypted: i=1; AJvYcCVSLkAxLzMR+Sc4MYCwz/Eda0ggm9L06ymGkVTAYu1olsfr1wAo68KkRyPXEbdLyYweSsg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzotHnbp6d0o6dZbwYRjyuGPj15SJWna9Aek9xYl0nKWpFFex3M
	jyBwx0cDs9u1XqFTueHfS16DnYOwYoJ/Prg0yCGdnnhseb7kq9Fjn4DcJIRXIm1Q7dtWUdgw1y1
	fsMOYD3DqQ2nAAqwxBnqULXnwos7NFH9ORWPoLuxKxLfe1aJb3C/+286jBuXaT+aHrGmyGQN5O/
	O5uwCb7HsSMGNsZ9rEKOiAna3fIylb
X-Gm-Gg: AY/fxX6y3JvlSKbGfUh+EmVMfvyf+gF0kqHvSBN7s0WETgtB6NjzWqgqO1/4i0vwHSf
	e72vp0ujiXWm83NYQ4dUMcG1vr/N3qwVt6mm0baRhyujuzV5cZK1QWQcIpcLL2ZRX75MbtIVIuY
	E/FxK2qUT4uKxHVQMdk5FelGNBOPtZ5F0XiLbYkEvDRh8MAlUepGhx6OobxoEqM0Q=
X-Received: by 2002:a17:90b:560b:b0:349:7fc6:18 with SMTP id 98e67ed59e1d1-34f68b9a22fmr4745632a91.13.1767847071690;
        Wed, 07 Jan 2026 20:37:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECns7jouA7f2VNHsoSXSn1GwNS9wwLb0mzRo21rU5B9H5vGzwBZRLYUrbrNqFBS4uDGJcoRqYkbR+MEJG9hv8=
X-Received: by 2002:a17:90b:560b:b0:349:7fc6:18 with SMTP id
 98e67ed59e1d1-34f68b9a22fmr4745605a91.13.1767847071303; Wed, 07 Jan 2026
 20:37:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de> <20260107210448.37851-10-simon.schippers@tu-dortmund.de>
In-Reply-To: <20260107210448.37851-10-simon.schippers@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 8 Jan 2026 12:37:39 +0800
X-Gm-Features: AQt7F2qCw4tSinw_uRQv6jndxzlecHSCxyFfKRavPy7gsUnUcdmHs2F5zxEB4h4
Message-ID: <CACGkMEuQikCsHn9cdhVxxHbjKAyW288SPNxAyXQ7FWNxd7Qenw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 9/9] tun/tap & vhost-net: avoid ptr_ring
 tail-drop when qdisc is present
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	mst@redhat.com, eperezma@redhat.com, leiyang@redhat.com, 
	stephen@networkplumber.org, jon@nutanix.com, tim.gebauer@tu-dortmund.de, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> This commit prevents tail-drop when a qdisc is present and the ptr_ring
> becomes full. Once an entry is successfully produced and the ptr_ring
> reaches capacity, the netdev queue is stopped instead of dropping
> subsequent packets.
>
> If producing an entry fails anyways, the tun_net_xmit returns
> NETDEV_TX_BUSY, again avoiding a drop. Such failures are expected because
> LLTX is enabled and the transmit path operates without the usual locking.
> As a result, concurrent calls to tun_net_xmit() are not prevented.
>
> The existing __{tun,tap}_ring_consume functions free space in the
> ptr_ring and wake the netdev queue. Races between this wakeup and the
> queue-stop logic could leave the queue stopped indefinitely. To prevent
> this, a memory barrier is enforced (as discussed in a similar
> implementation in [1]), followed by a recheck that wakes the queue if
> space is already available.
>
> If no qdisc is present, the previous tail-drop behavior is preserved.
>
> +-------------------------+-----------+---------------+----------------+
> | pktgen benchmarks to    | Stock     | Patched with  | Patched with   |
> | Debian VM, i5 6300HQ,   |           | noqueue qdisc | fq_codel qdisc |
> | 10M packets             |           |               |                |
> +-----------+-------------+-----------+---------------+----------------+
> | TAP       | Transmitted | 196 Kpps  | 195 Kpps      | 185 Kpps       |
> |           +-------------+-----------+---------------+----------------+
> |           | Lost        | 1618 Kpps | 1556 Kpps     | 0              |
> +-----------+-------------+-----------+---------------+----------------+
> | TAP       | Transmitted | 577 Kpps  | 582 Kpps      | 578 Kpps       |
> |  +        +-------------+-----------+---------------+----------------+
> | vhost-net | Lost        | 1170 Kpps | 1109 Kpps     | 0              |
> +-----------+-------------+-----------+---------------+----------------+
>
> [1] Link: https://lore.kernel.org/all/20250424085358.75d817ae@kernel.org/
>
> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> ---
>  drivers/net/tun.c | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 71b6981d07d7..74d7fd09e9ba 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1008,6 +1008,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb=
, struct net_device *dev)
>         struct netdev_queue *queue;
>         struct tun_file *tfile;
>         int len =3D skb->len;
> +       bool qdisc_present;
> +       int ret;
>
>         rcu_read_lock();
>         tfile =3D rcu_dereference(tun->tfiles[txq]);
> @@ -1060,13 +1062,38 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *s=
kb, struct net_device *dev)
>
>         nf_reset_ct(skb);
>
> -       if (ptr_ring_produce(&tfile->tx_ring, skb)) {
> +       queue =3D netdev_get_tx_queue(dev, txq);
> +       qdisc_present =3D !qdisc_txq_has_no_queue(queue);
> +
> +       spin_lock(&tfile->tx_ring.producer_lock);
> +       ret =3D __ptr_ring_produce(&tfile->tx_ring, skb);
> +       if (__ptr_ring_produce_peek(&tfile->tx_ring) && qdisc_present) {
> +               netif_tx_stop_queue(queue);
> +               /* Avoid races with queue wake-up in
> +                * __{tun,tap}_ring_consume by waking if space is
> +                * available in a re-check.
> +                * The barrier makes sure that the stop is visible before
> +                * we re-check.
> +                */
> +               smp_mb__after_atomic();
> +               if (!__ptr_ring_produce_peek(&tfile->tx_ring))
> +                       netif_tx_wake_queue(queue);

I'm not sure I will get here, but I think those should be moved to the
following if(ret) check. If __ptr_ring_produce() succeed, there's no
need to bother with those queue stop/wake logic?

> +       }
> +       spin_unlock(&tfile->tx_ring.producer_lock);
> +
> +       if (ret) {
> +               /* If a qdisc is attached to our virtual device,
> +                * returning NETDEV_TX_BUSY is allowed.
> +                */
> +               if (qdisc_present) {
> +                       rcu_read_unlock();
> +                       return NETDEV_TX_BUSY;
> +               }
>                 drop_reason =3D SKB_DROP_REASON_FULL_RING;
>                 goto drop;
>         }
>
>         /* dev->lltx requires to do our own update of trans_start */
> -       queue =3D netdev_get_tx_queue(dev, txq);
>         txq_trans_cond_update(queue);
>
>         /* Notify and wake up reader process */
> --
> 2.43.0
>

Thanks


