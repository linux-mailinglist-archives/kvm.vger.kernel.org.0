Return-Path: <kvm+bounces-67685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E03C3D10547
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 03:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9CE463008880
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 02:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F43F302750;
	Mon, 12 Jan 2026 02:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QNnWo1SX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJVF79bY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3247301718
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 02:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768184588; cv=none; b=fEpuDrVTsAxDTCZuFuFqAE6FjuQ9wkHS4mKZAkbMHcvMM+cbfaZ4oG6ATY5d+lddaF+apcEKOuXk7EIygYIPiTd6DD/Km8s4WFpx8NH9R2oe/kxi0T2BckZdQi39guiaDBtP1BfbRMjq249Qx72p4lHtYyRLyTDEs5CML520G0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768184588; c=relaxed/simple;
	bh=JmKwPot1HFG3rwXFIsvxegVeHzGSVWS+8mzPzrKuRgw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jLYIXLY2i/jVLQDQa7Pae5c2ZIMZOIeC8C51MO4CAL0VPmnuCQoYKdQxX+NjOvK6eU9Sq2wq8zjTCT1PFONP/+kXI2Gl1mzA7vhyCa0qg65U3us9wl3JtgSk4gLIesfwQ+WqYk1EiODQfFCUJCwq8vI9ijM9Qhw148TYFoKzuyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QNnWo1SX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gJVF79bY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768184585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sRgs/y8WuRWu+uVZoV/9+bsX13ckGLVOYczCcjx/MOU=;
	b=QNnWo1SXMv6Zt33kdWb+agT+NC6PAU6WrPGqmoW94ykS1Wr91Z5R4mwn8xsj/1VV3kobZO
	4NG5pmUaFgGUWLwBQ1akcESqzhMmKnfNWoIDRvZHChorwfLinJyZrDWhhYHAxVp30EMAzK
	ea6ppRpua/lqlAu9QzRUxa0Ir/fOJzA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-hbQJVryBMRCsBTVh--1T2g-1; Sun, 11 Jan 2026 21:23:04 -0500
X-MC-Unique: hbQJVryBMRCsBTVh--1T2g-1
X-Mimecast-MFC-AGG-ID: hbQJVryBMRCsBTVh--1T2g_1768184583
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34c6e05af6fso6115669a91.1
        for <kvm@vger.kernel.org>; Sun, 11 Jan 2026 18:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768184583; x=1768789383; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sRgs/y8WuRWu+uVZoV/9+bsX13ckGLVOYczCcjx/MOU=;
        b=gJVF79bYjr29w5P6Qec/U2h/TYSjoBW4wB0S+/ixIEV8wKC8R13g4MbDW2TezdJDHE
         oX0Cokxj+Yt0JBRTD/DkuFe0eBRsO7xGWsLyS0o5D4BGIuQEXWbTMh+9RxNIVtvbYFP5
         nZ1zCBjDR0sDoGCp9x7GFIrxQyKxE3Ycm1O0ccyh+vQw3NIDhSkU08WRch2g2SzpHGmQ
         KckeEEuzNHoSXfYbs5uopF5k669bQGNjibJgqQOHjjtJkUWArLVPGPjCjbl8NzvbPfmi
         bKnmNlz3bqbOzELiByttwIRRxaTNpPMsIk7dioYF/Kmc8Jwt+1+yptxcv8ii6pW2sU7c
         I0UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768184583; x=1768789383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sRgs/y8WuRWu+uVZoV/9+bsX13ckGLVOYczCcjx/MOU=;
        b=eA6Jm2XbDw+KSNyMIJRIr2XUlGXicYoyf3RHDM6qWddWq2jNNFDpUBoov+Wkf2MR00
         P8m8fGN6thqVE/tltOSMmhOlKJRCJiZ0+lTLkfhWBCfGdQs5Eqoo0fa55J5i74B9x/sY
         qXg7053c2JaCNnAiwoEv4f0R+d5WOhSFnklPk8/U93MdknMNv2z0cmw08OkIrvqV28ht
         7C5HSSYMTJDzAidnPDNBynSS+1xzBl3sA58ZbzhpHQ+xcAYzr15E1CBOt4cK/SqgPBdb
         OnKFbJfqFvCpAfqI7yQOyGqD8AJZi6htdFzmNsyNLQ9+82grlm8gy3lwBNBGwS1cYfrx
         vSDw==
X-Forwarded-Encrypted: i=1; AJvYcCWyIgr9x8jHEcxr9bsf7ZGh5MnZ6wSfrgnliXB8fGMIb/8h+DbBFrFDhNoOOaq5FZxra+w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz15e/Lkjb1XNX5mTqexyxwey8rx3NElugbafCb6robJSk191eA
	qKsc28FpSWRU4OY6mzyfTOCrwquKX1FV5JP1ZLa/YUW4ASEXXPNzMDORhySHx1qtUJub2ky5QBS
	ePxL95YbJ5KanyFk4vu9jFxhFwfza4FpuMAf1SQcCb6hhpUb/c4Jjrq1CQ8/IHvDUdHzTuPiVV8
	HBg5MYw/gs8ZV/uBPauuo0pjs53kqx
X-Gm-Gg: AY/fxX4hXcbgW1b7jLuzpNhglGilaS6taAZ+qg1XMajVju35yH+R+kgqZHiMAkYFOfS
	6epGFIzr49eD/MWAMUdtn5jbw1Yeh53qfRnFw2mTxlTRcofmfQPuogwlMr0xtd5UKVFGO81JvgI
	MEMF1ud7Bg5thMb5JguRPt8EReX4yid/wKP+f9qIQ4WirUwCfJFWSTMYny32n9ruBHb90=
X-Received: by 2002:a17:90b:1650:b0:340:d1b5:bfda with SMTP id 98e67ed59e1d1-34f68c33781mr14316848a91.3.1768184583267;
        Sun, 11 Jan 2026 18:23:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzVFQTinfgVuoT02Ul+n5+3LO4GPPv+fa7/iUBiA4N9KQ7iqYy1PJMve6sJwtFaBPX0HHFdXRRol20Nxi5Vy0=
X-Received: by 2002:a17:90b:1650:b0:340:d1b5:bfda with SMTP id
 98e67ed59e1d1-34f68c33781mr14316821a91.3.1768184582782; Sun, 11 Jan 2026
 18:23:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-10-simon.schippers@tu-dortmund.de> <CACGkMEuQikCsHn9cdhVxxHbjKAyW288SPNxAyXQ7FWNxd7Qenw@mail.gmail.com>
 <bd41afae-cf1e-46ab-8948-4c7fa280b20f@tu-dortmund.de> <CACGkMEs8VHGjiLqn=-Gt5=WPMzqAXNM2GcK73dLarP9CQw3+rw@mail.gmail.com>
 <900c364b-f5ca-4458-a711-bf3e0433b537@tu-dortmund.de>
In-Reply-To: <900c364b-f5ca-4458-a711-bf3e0433b537@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 12 Jan 2026 10:22:51 +0800
X-Gm-Features: AZwV_QhHI92q6lgD6p0Q1oo70mczijvjl8JIiP2Rj2lWAdmWqkezRiDMgsGAQv4
Message-ID: <CACGkMEvqoxSiM65ectKaF=UQ6PJn6+FQyJ=_YjgCo+QBCj1umg@mail.gmail.com>
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

On Fri, Jan 9, 2026 at 6:15=E2=80=AFPM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> On 1/9/26 07:09, Jason Wang wrote:
> > On Thu, Jan 8, 2026 at 4:02=E2=80=AFPM Simon Schippers
> > <simon.schippers@tu-dortmund.de> wrote:
> >>
> >> On 1/8/26 05:37, Jason Wang wrote:
> >>> On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
> >>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>
> >>>> This commit prevents tail-drop when a qdisc is present and the ptr_r=
ing
> >>>> becomes full. Once an entry is successfully produced and the ptr_rin=
g
> >>>> reaches capacity, the netdev queue is stopped instead of dropping
> >>>> subsequent packets.
> >>>>
> >>>> If producing an entry fails anyways, the tun_net_xmit returns
> >>>> NETDEV_TX_BUSY, again avoiding a drop. Such failures are expected be=
cause
> >>>> LLTX is enabled and the transmit path operates without the usual loc=
king.
> >>>> As a result, concurrent calls to tun_net_xmit() are not prevented.
> >>>>
> >>>> The existing __{tun,tap}_ring_consume functions free space in the
> >>>> ptr_ring and wake the netdev queue. Races between this wakeup and th=
e
> >>>> queue-stop logic could leave the queue stopped indefinitely. To prev=
ent
> >>>> this, a memory barrier is enforced (as discussed in a similar
> >>>> implementation in [1]), followed by a recheck that wakes the queue i=
f
> >>>> space is already available.
> >>>>
> >>>> If no qdisc is present, the previous tail-drop behavior is preserved=
.
> >>>>
> >>>> +-------------------------+-----------+---------------+-------------=
---+
> >>>> | pktgen benchmarks to    | Stock     | Patched with  | Patched with=
   |
> >>>> | Debian VM, i5 6300HQ,   |           | noqueue qdisc | fq_codel qdi=
sc |
> >>>> | 10M packets             |           |               |             =
   |
> >>>> +-----------+-------------+-----------+---------------+-------------=
---+
> >>>> | TAP       | Transmitted | 196 Kpps  | 195 Kpps      | 185 Kpps    =
   |
> >>>> |           +-------------+-----------+---------------+-------------=
---+
> >>>> |           | Lost        | 1618 Kpps | 1556 Kpps     | 0           =
   |
> >>>> +-----------+-------------+-----------+---------------+-------------=
---+
> >>>> | TAP       | Transmitted | 577 Kpps  | 582 Kpps      | 578 Kpps    =
   |
> >>>> |  +        +-------------+-----------+---------------+-------------=
---+
> >>>> | vhost-net | Lost        | 1170 Kpps | 1109 Kpps     | 0           =
   |
> >>>> +-----------+-------------+-----------+---------------+-------------=
---+
> >>>>
> >>>> [1] Link: https://lore.kernel.org/all/20250424085358.75d817ae@kernel=
.org/
> >>>>
> >>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> >>>> ---
> >>>>  drivers/net/tun.c | 31 +++++++++++++++++++++++++++++--
> >>>>  1 file changed, 29 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>>> index 71b6981d07d7..74d7fd09e9ba 100644
> >>>> --- a/drivers/net/tun.c
> >>>> +++ b/drivers/net/tun.c
> >>>> @@ -1008,6 +1008,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff=
 *skb, struct net_device *dev)
> >>>>         struct netdev_queue *queue;
> >>>>         struct tun_file *tfile;
> >>>>         int len =3D skb->len;
> >>>> +       bool qdisc_present;
> >>>> +       int ret;
> >>>>
> >>>>         rcu_read_lock();
> >>>>         tfile =3D rcu_dereference(tun->tfiles[txq]);
> >>>> @@ -1060,13 +1062,38 @@ static netdev_tx_t tun_net_xmit(struct sk_bu=
ff *skb, struct net_device *dev)
> >>>>
> >>>>         nf_reset_ct(skb);
> >>>>
> >>>> -       if (ptr_ring_produce(&tfile->tx_ring, skb)) {
> >>>> +       queue =3D netdev_get_tx_queue(dev, txq);
> >>>> +       qdisc_present =3D !qdisc_txq_has_no_queue(queue);
> >>>> +
> >>>> +       spin_lock(&tfile->tx_ring.producer_lock);
> >>>> +       ret =3D __ptr_ring_produce(&tfile->tx_ring, skb);
> >>>> +       if (__ptr_ring_produce_peek(&tfile->tx_ring) && qdisc_presen=
t) {
> >>>> +               netif_tx_stop_queue(queue);
> >>>> +               /* Avoid races with queue wake-up in
> >>>> +                * __{tun,tap}_ring_consume by waking if space is
> >>>> +                * available in a re-check.
> >>>> +                * The barrier makes sure that the stop is visible b=
efore
> >>>> +                * we re-check.
> >>>> +                */
> >>>> +               smp_mb__after_atomic();
> >>>> +               if (!__ptr_ring_produce_peek(&tfile->tx_ring))
> >>>> +                       netif_tx_wake_queue(queue);
> >>>
> >>> I'm not sure I will get here, but I think those should be moved to th=
e
> >>> following if(ret) check. If __ptr_ring_produce() succeed, there's no
> >>> need to bother with those queue stop/wake logic?
> >>
> >> There is a need for that. If __ptr_ring_produce_peek() returns -ENOSPC=
,
> >> we stop the queue proactively.
> >
> > This seems to conflict with the following NETDEV_TX_BUSY. Or is
> > NETDEV_TX_BUSY prepared for the xdp_xmit?
>
> Am I not allowed to stop the queue and then return NETDEV_TX_BUSY?

No, I mean I don't understand why we still need to peek since we've
already used NETDEV_TX_BUSY.

> And I do not understand the connection with xdp_xmit.

Since there's we don't modify xdp_xmit path, so even if we peek next
ndo_start_xmit can still hit ring full.

Thanks

>
> >
> >>
> >> I believe what you are aiming for is to always stop the queue if(ret),
> >> which I can agree with. In that case, I would simply change the condit=
ion
> >> to:
> >>
> >> if (qdisc_present && (ret || __ptr_ring_produce_peek(&tfile->tx_ring))=
)
> >>
> >>>
> >>>> +       }
> >>>> +       spin_unlock(&tfile->tx_ring.producer_lock);
> >>>> +
> >>>> +       if (ret) {
> >>>> +               /* If a qdisc is attached to our virtual device,
> >>>> +                * returning NETDEV_TX_BUSY is allowed.
> >>>> +                */
> >>>> +               if (qdisc_present) {
> >>>> +                       rcu_read_unlock();
> >>>> +                       return NETDEV_TX_BUSY;
> >>>> +               }
> >>>>                 drop_reason =3D SKB_DROP_REASON_FULL_RING;
> >>>>                 goto drop;
> >>>>         }
> >>>>
> >>>>         /* dev->lltx requires to do our own update of trans_start */
> >>>> -       queue =3D netdev_get_tx_queue(dev, txq);
> >>>>         txq_trans_cond_update(queue);
> >>>>
> >>>>         /* Notify and wake up reader process */
> >>>> --
> >>>> 2.43.0
> >>>>
> >>>
> >>> Thanks
> >>>
> >>
> >
> > Thanks
> >
>


