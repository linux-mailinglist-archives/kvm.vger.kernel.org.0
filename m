Return-Path: <kvm+bounces-67522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ED2DED07596
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 07:10:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 36BA7303213F
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 06:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F76E2D9796;
	Fri,  9 Jan 2026 06:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iyzUeis3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YMpb5MtK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8CA2D5936
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 06:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767938994; cv=none; b=AieMXs75CGjFTnCXNwklYVrT0g7r8F9jqlPysyL65Jj3IxIt5jzpqSHowJws/NLmyT0b0mwtnHEmGJD8exNlU3u0fEx8wGpI+2LG+Svno6mY/JYFoSI1uBaDe/duAYuazZnEBcTHIFJaj+yCHLcK0KteFXLvi8n3C/yqr9Pdoz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767938994; c=relaxed/simple;
	bh=/Whxa26upJUenWNr2ZsZaRmoZUHwHeEOLf+P/McVcP4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IFgmODd7mRtfPBG+nzxfYBZDYV6JIVAgXfTTgrrY+nOSBMtJ0Ych9m+ksKEdw7FQ/muBx4kKrdSB04ma+xGzu8skoGp3pA7PkJixuW3Du8paUpMcLJkNJnZPiKatdoJPAB5wvQIZ/g+UH8QIQupxNnYOTeT56aHigewr9D2yuU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iyzUeis3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YMpb5MtK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767938988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UsTn3TvI9UsxAE5f1Ok27om1Z5aK/et/A9uoT4IK01s=;
	b=iyzUeis3hv7/LbblWWmHIJTGh8dx76JrruOMexGelNOEkTubeviihqxR7N0v/1Rofy3jvV
	kxeEcHLAe8dzvan7N2UscNLRkziTN+l0Y/dODY/udYOe8yKIOitbeHHVj1xZD5VXAChZwM
	8MCGBY388iOP1+iJSpMZWD7mhaC5eho=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-sTlaaHfANQC3TM8LRm_ObA-1; Fri, 09 Jan 2026 01:09:47 -0500
X-MC-Unique: sTlaaHfANQC3TM8LRm_ObA-1
X-Mimecast-MFC-AGG-ID: sTlaaHfANQC3TM8LRm_ObA_1767938986
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34c48a76e75so4762395a91.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 22:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767938986; x=1768543786; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UsTn3TvI9UsxAE5f1Ok27om1Z5aK/et/A9uoT4IK01s=;
        b=YMpb5MtKSf9oOO36YlMKzyfL9BGr3Vczj08zkjYzHq0O/hY48ptyKTpQ3Pc7MiXb+r
         kj2Kdsy373DzS3TY8JuK46j9rjn2yn2KSEb6sWQJ7MiUAME0PpAKHokbqWzAQaMJEv9i
         V/veIYAP7XBbBEDaEkeMi++1QzQaKhQ+j+WGpRjiTf2loUVWNqIcO1gW1155vaEtmm5A
         I+uhKtGgb1FzHGDbpzllSx8BTIe4Zv5xiLMQuqdA/vQsY45to8SOqRxKZHq86lTY1RRC
         M4juJmibNfzBr02vWAPLKEwVMYXiuulM5KKynVkTjDq/yNH2M7mlzVl4jLAW6THtsQLW
         8Zaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767938986; x=1768543786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UsTn3TvI9UsxAE5f1Ok27om1Z5aK/et/A9uoT4IK01s=;
        b=E1ug3HyjUu5ubANBHhz/8uaLjidh2FbSogn8RTypjZkR18yvIoXSsiBDNLkF1Zgs3P
         z5Cvu49fZaC1KY5eUEogN6QyeoayjmnEgLrm8n+KM1yiVL4Ib9Yfdw7VeAoKOigJNwuF
         bjBkJA2qFqxEwzJB1ez/M84ysFxqjqUypjffk9oQiwzpNMYc5VsnnNL3cslnPvvEAz5/
         1cDxg33m/OLBSd8qx6V4JB7r2p/xhO07VHUUChk2fGqjHjhEo37TvPQeAhNVSLUD3ltf
         1kSncXz1Qp1JuOmiZGU3GWpau4JF0GFvKV0NLX2LAUyGCxhtare9Y2wHe7HTktIeakRS
         Slgw==
X-Forwarded-Encrypted: i=1; AJvYcCXfXRSF17vtp2D1/BsiIm+F2hA6XS88xK7EriNGUR/dyU8eNs60VmJRJKXipCQ6N9I6KWI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIz6a//H/f0bdnflB4EWKs0cl0RBX0t6dq1WuMwyUIm4Hi2PmQ
	/ubXi3sfvJD+apQIlAqAw8yyKleVF45AhlqRwZfUs3rap3MC2uhS1FLUBzYRuX4cdEly+jgts6z
	QC1izWk6J4bFr5hoYsJiJZfhh+rIGJ+3zgBB89VvlxxFoLOp+pLcVqthy6mbqpiuoCIZFmoU9Zs
	K4Zj7/jgSI00dO1CreZle/Sh+3ipSu2ZkPsLa/xZQ=
X-Gm-Gg: AY/fxX6qhg8xTvpBnKzq1pdUOs3BQWegg1PvNDFWqCCEsYGDXAMSCIQc9okqcSwfzFM
	Pe/9zoY/y9wv4O7ZomGNxLzhSjiLGp0K16VDoaUAsMaM3UdgVQ4dl+jD46dE6p9cXgAJgy4gNzW
	eckl3NEY56jYftA6AqabvFCtfdXgoljKbquJPSCcpoxXqOKeIMVb2SPXAl0aeDsV0=
X-Received: by 2002:a17:90b:1c87:b0:34c:a35d:de16 with SMTP id 98e67ed59e1d1-34f68c282c6mr8200209a91.11.1767938986168;
        Thu, 08 Jan 2026 22:09:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGwd/+ri/7IRW9go6ZEYvBIdoZ0mcrieqtY+k0sd20Yk2cfAv4k30KxCjCWEGVfJYZgJ6AXw+vCl3L0aSy822U=
X-Received: by 2002:a17:90b:1c87:b0:34c:a35d:de16 with SMTP id
 98e67ed59e1d1-34f68c282c6mr8200176a91.11.1767938985646; Thu, 08 Jan 2026
 22:09:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-10-simon.schippers@tu-dortmund.de> <CACGkMEuQikCsHn9cdhVxxHbjKAyW288SPNxAyXQ7FWNxd7Qenw@mail.gmail.com>
 <bd41afae-cf1e-46ab-8948-4c7fa280b20f@tu-dortmund.de>
In-Reply-To: <bd41afae-cf1e-46ab-8948-4c7fa280b20f@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 9 Jan 2026 14:09:34 +0800
X-Gm-Features: AQt7F2pltZRUg0ITK9mA3g-3JDbVoNoxDdcEgN4kSv6FJ9EIKXkiqcx-w4p6MXg
Message-ID: <CACGkMEs8VHGjiLqn=-Gt5=WPMzqAXNM2GcK73dLarP9CQw3+rw@mail.gmail.com>
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

On Thu, Jan 8, 2026 at 4:02=E2=80=AFPM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> On 1/8/26 05:37, Jason Wang wrote:
> > On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
> > <simon.schippers@tu-dortmund.de> wrote:
> >>
> >> This commit prevents tail-drop when a qdisc is present and the ptr_rin=
g
> >> becomes full. Once an entry is successfully produced and the ptr_ring
> >> reaches capacity, the netdev queue is stopped instead of dropping
> >> subsequent packets.
> >>
> >> If producing an entry fails anyways, the tun_net_xmit returns
> >> NETDEV_TX_BUSY, again avoiding a drop. Such failures are expected beca=
use
> >> LLTX is enabled and the transmit path operates without the usual locki=
ng.
> >> As a result, concurrent calls to tun_net_xmit() are not prevented.
> >>
> >> The existing __{tun,tap}_ring_consume functions free space in the
> >> ptr_ring and wake the netdev queue. Races between this wakeup and the
> >> queue-stop logic could leave the queue stopped indefinitely. To preven=
t
> >> this, a memory barrier is enforced (as discussed in a similar
> >> implementation in [1]), followed by a recheck that wakes the queue if
> >> space is already available.
> >>
> >> If no qdisc is present, the previous tail-drop behavior is preserved.
> >>
> >> +-------------------------+-----------+---------------+---------------=
-+
> >> | pktgen benchmarks to    | Stock     | Patched with  | Patched with  =
 |
> >> | Debian VM, i5 6300HQ,   |           | noqueue qdisc | fq_codel qdisc=
 |
> >> | 10M packets             |           |               |               =
 |
> >> +-----------+-------------+-----------+---------------+---------------=
-+
> >> | TAP       | Transmitted | 196 Kpps  | 195 Kpps      | 185 Kpps      =
 |
> >> |           +-------------+-----------+---------------+---------------=
-+
> >> |           | Lost        | 1618 Kpps | 1556 Kpps     | 0             =
 |
> >> +-----------+-------------+-----------+---------------+---------------=
-+
> >> | TAP       | Transmitted | 577 Kpps  | 582 Kpps      | 578 Kpps      =
 |
> >> |  +        +-------------+-----------+---------------+---------------=
-+
> >> | vhost-net | Lost        | 1170 Kpps | 1109 Kpps     | 0             =
 |
> >> +-----------+-------------+-----------+---------------+---------------=
-+
> >>
> >> [1] Link: https://lore.kernel.org/all/20250424085358.75d817ae@kernel.o=
rg/
> >>
> >> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> >> ---
> >>  drivers/net/tun.c | 31 +++++++++++++++++++++++++++++--
> >>  1 file changed, 29 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >> index 71b6981d07d7..74d7fd09e9ba 100644
> >> --- a/drivers/net/tun.c
> >> +++ b/drivers/net/tun.c
> >> @@ -1008,6 +1008,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *=
skb, struct net_device *dev)
> >>         struct netdev_queue *queue;
> >>         struct tun_file *tfile;
> >>         int len =3D skb->len;
> >> +       bool qdisc_present;
> >> +       int ret;
> >>
> >>         rcu_read_lock();
> >>         tfile =3D rcu_dereference(tun->tfiles[txq]);
> >> @@ -1060,13 +1062,38 @@ static netdev_tx_t tun_net_xmit(struct sk_buff=
 *skb, struct net_device *dev)
> >>
> >>         nf_reset_ct(skb);
> >>
> >> -       if (ptr_ring_produce(&tfile->tx_ring, skb)) {
> >> +       queue =3D netdev_get_tx_queue(dev, txq);
> >> +       qdisc_present =3D !qdisc_txq_has_no_queue(queue);
> >> +
> >> +       spin_lock(&tfile->tx_ring.producer_lock);
> >> +       ret =3D __ptr_ring_produce(&tfile->tx_ring, skb);
> >> +       if (__ptr_ring_produce_peek(&tfile->tx_ring) && qdisc_present)=
 {
> >> +               netif_tx_stop_queue(queue);
> >> +               /* Avoid races with queue wake-up in
> >> +                * __{tun,tap}_ring_consume by waking if space is
> >> +                * available in a re-check.
> >> +                * The barrier makes sure that the stop is visible bef=
ore
> >> +                * we re-check.
> >> +                */
> >> +               smp_mb__after_atomic();
> >> +               if (!__ptr_ring_produce_peek(&tfile->tx_ring))
> >> +                       netif_tx_wake_queue(queue);
> >
> > I'm not sure I will get here, but I think those should be moved to the
> > following if(ret) check. If __ptr_ring_produce() succeed, there's no
> > need to bother with those queue stop/wake logic?
>
> There is a need for that. If __ptr_ring_produce_peek() returns -ENOSPC,
> we stop the queue proactively.

This seems to conflict with the following NETDEV_TX_BUSY. Or is
NETDEV_TX_BUSY prepared for the xdp_xmit?

>
> I believe what you are aiming for is to always stop the queue if(ret),
> which I can agree with. In that case, I would simply change the condition
> to:
>
> if (qdisc_present && (ret || __ptr_ring_produce_peek(&tfile->tx_ring)))
>
> >
> >> +       }
> >> +       spin_unlock(&tfile->tx_ring.producer_lock);
> >> +
> >> +       if (ret) {
> >> +               /* If a qdisc is attached to our virtual device,
> >> +                * returning NETDEV_TX_BUSY is allowed.
> >> +                */
> >> +               if (qdisc_present) {
> >> +                       rcu_read_unlock();
> >> +                       return NETDEV_TX_BUSY;
> >> +               }
> >>                 drop_reason =3D SKB_DROP_REASON_FULL_RING;
> >>                 goto drop;
> >>         }
> >>
> >>         /* dev->lltx requires to do our own update of trans_start */
> >> -       queue =3D netdev_get_tx_queue(dev, txq);
> >>         txq_trans_cond_update(queue);
> >>
> >>         /* Notify and wake up reader process */
> >> --
> >> 2.43.0
> >>
> >
> > Thanks
> >
>

Thanks


