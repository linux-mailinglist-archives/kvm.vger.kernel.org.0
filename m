Return-Path: <kvm+bounces-67723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 795ABD123AF
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 12:19:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4D730305DE49
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 11:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7107D3563FD;
	Mon, 12 Jan 2026 11:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G6NJL9CX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dcaMHHa2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D929E3563E0
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 11:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768216705; cv=none; b=UPoHICpONZ3m5Y/8j8gXZQt9EoLQE0wubYTNpV09wirfYBBsDceuUVOCIkyPQhc6EpSpmPbRyuVXGuIHuy/fffuqvSg/g6vlNEndnnb+kcZo2U8FmGmJ+SiuwPjFqYpfGpvq3J6U34hDquhexltCWh3ajtKy+cEAYLgwhhllMzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768216705; c=relaxed/simple;
	bh=pkVswsrbi0EtJPSPnnDNq6hfoD5ZVr4Ytx1oZl9fFsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGcclXH0Sebkib5HOSH/yQxKqmJM0XdiS+pDdBhUh7ROJiv8Zm+3HzQmUrD9QBt6pmBH3w7tc0lm/yz6MXgmy8UY80yRnvOxNa4C/GCjMV2dnfldBCEvjEnEjGn2JLUfWb1r3tPP7mQ08mC64ldKBTwE/V6m5cTYqwZqZLSwk+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G6NJL9CX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dcaMHHa2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768216703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wDc/S1WIObDz8TA7kjTeIe+EBGyyqU87Vxr9tB+mW5U=;
	b=G6NJL9CXEmIMxyCvDCNEIqtjuGxWpX6VtX5O7cI78kfTiYPo6WwWsDaz9fIy3rCreL/Cic
	UMvVq5ubbHAYmTj61bPu8dwsPxj9q4RERuSEyhe4sYWBdj7JoREhLGAjDzPhpMfyQF3Gwk
	AFva6e1pXE5et9PJ84yVaKhHE4R4K0M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-Mwd20WslOhOxZ-WSEx9Z3Q-1; Mon, 12 Jan 2026 06:18:20 -0500
X-MC-Unique: Mwd20WslOhOxZ-WSEx9Z3Q-1
X-Mimecast-MFC-AGG-ID: Mwd20WslOhOxZ-WSEx9Z3Q_1768216699
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47775585257so43279875e9.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 03:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768216699; x=1768821499; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wDc/S1WIObDz8TA7kjTeIe+EBGyyqU87Vxr9tB+mW5U=;
        b=dcaMHHa2f6NkeiE4SKiuNrqBx6tI5tfj2TPNstKADJHCbawxgrIT26BBk23eDcaLje
         rVI3FRNl5SGDykWzrvoKpcAElh/xJbH5Gmq0FqljbZGisKHp8nCdL0sMweMz6u7nIjNN
         EjoqBNL4wLpipFzRsDGHWZbEstakHkstNTL2+DciqdC6v5ou1YsJLsrKxpVD54SmHb1v
         wrSEwf80l5hXEDwHRwC+OJLg2hcQXGx7ppz/K8T6HNhG9movJnEOI6RGEOla0uGv68Ir
         aDAsvoeDIvikUbHXfEd363JJPNZxBsBpvMn+A6oiA+FlSPhnexa/Xe1k88LV8hipEPCt
         2b3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768216699; x=1768821499;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wDc/S1WIObDz8TA7kjTeIe+EBGyyqU87Vxr9tB+mW5U=;
        b=akHnV/HDsVFMYZKtP7Ja/SGjk1XMeHyK0VrIuDOwldm9qml3re/9cOPJwiXTMyIjOx
         EG5pg4DK8NQSJgaqIdkBSusV9OCNT8fhG/8OQ6sgl7+Ylp+c9uC4wFxm5K/OgvYb+PMc
         JPAbzZshy4aFx+HeK5nRxgM8sAsD1wlvZd1s0FKFvxQRsRfMVV7811fKoj7CF7B+2EuW
         S1j6ZB4bJWAR99JlE+z2jIDCbD1aVkEU7jVhPDWLuVESZ4VibH0u5kngZmfHNMl5DyiE
         b3rkCaT8p9e9MxNXb+LUp+qZyAV9PDOnsTOf+2P/BVa9ISp+VID7stRqdSe3ntSlmIpI
         rgPw==
X-Forwarded-Encrypted: i=1; AJvYcCU64884mjrPPI8joPagdlmqP1RU8OVxP7kAefjjF4WpQO3kzqm4w6O8UkdFxE2R9dKNWnM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8Ee86Oz+mi4HdLjlt4XiE3sNLaSLi+q9ViwcbS1jnuRc0PZBr
	lL1OLTmFRmTOsSHO9gsQE1xO+1TYqcnFnTEGFHmowuldyBqYWvj20fpWY8IGLU7XN+dYMX9H+Hl
	POi5ZXWfBsSn8/wvfsoNgJOCDzFd1DT+MoqEqyPusmVYyb4CzPW7hFg==
X-Gm-Gg: AY/fxX7E0Z8xvTs0tEp+oS/ucQ/Iji14NkMzo0rXYTs2MNE16gTuH9Dw6qlUWERqMgs
	6M/YKLqQa3rSe0urwh6HCLjb9HkJXUHjs4MJ7v8gIcRE2CT+f0oAoZ7br4NzLnYcFY7wqcMn+cn
	yS/zuVPHBt/bQnDhteF5+wgRjI4A3BitDvhdasThLMAdbWgTgdELFVytU/TrTg0reJMuuAkEk+t
	vOVkC0lW1YyMG1cimhchrCs7HF04ugb7AQmIYNMgO+PlTLj7BeMhUu6aqs3OTqTXzkZMZ62qroL
	eaP4PQuTA8T0AENY+B6vwPAkYXxwA0sU+nWHOEVQUiO+sAyAeruEnQYbxff2k+zGob8vlcG+XL6
	BPQlxejxLa6qecQ/z3NiqXxgU/+IHJoQ=
X-Received: by 2002:a05:600c:a48:b0:47a:829a:ebb with SMTP id 5b1f17b1804b1-47d84b36a2amr184082665e9.19.1768216699007;
        Mon, 12 Jan 2026 03:18:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH/yWXG4PNK8nWzZOE4GBrCOM9Xs4Vra+av8pc//nciA6emW6OxV8142ysunXFkn8n9dmwmuA==
X-Received: by 2002:a05:600c:a48:b0:47a:829a:ebb with SMTP id 5b1f17b1804b1-47d84b36a2amr184082135e9.19.1768216698496;
        Mon, 12 Jan 2026 03:18:18 -0800 (PST)
Received: from redhat.com (IGLD-80-230-35-22.inter.net.il. [80.230.35.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f653c61sm355460055e9.10.2026.01.12.03.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 03:18:17 -0800 (PST)
Date: Mon, 12 Jan 2026 06:18:14 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: Jason Wang <jasowang@redhat.com>, willemdebruijn.kernel@gmail.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
	leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
	tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v7 9/9] tun/tap & vhost-net: avoid ptr_ring
 tail-drop when qdisc is present
Message-ID: <20260112061721-mutt-send-email-mst@kernel.org>
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-10-simon.schippers@tu-dortmund.de>
 <CACGkMEuQikCsHn9cdhVxxHbjKAyW288SPNxAyXQ7FWNxd7Qenw@mail.gmail.com>
 <bd41afae-cf1e-46ab-8948-4c7fa280b20f@tu-dortmund.de>
 <CACGkMEs8VHGjiLqn=-Gt5=WPMzqAXNM2GcK73dLarP9CQw3+rw@mail.gmail.com>
 <900c364b-f5ca-4458-a711-bf3e0433b537@tu-dortmund.de>
 <CACGkMEvqoxSiM65ectKaF=UQ6PJn6+FQyJ=_YjgCo+QBCj1umg@mail.gmail.com>
 <9aaf2420-089d-4fd9-824d-24982a86a70d@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9aaf2420-089d-4fd9-824d-24982a86a70d@tu-dortmund.de>

On Mon, Jan 12, 2026 at 12:08:14PM +0100, Simon Schippers wrote:
> On 1/12/26 03:22, Jason Wang wrote:
> > On Fri, Jan 9, 2026 at 6:15 PM Simon Schippers
> > <simon.schippers@tu-dortmund.de> wrote:
> >>
> >> On 1/9/26 07:09, Jason Wang wrote:
> >>> On Thu, Jan 8, 2026 at 4:02 PM Simon Schippers
> >>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>
> >>>> On 1/8/26 05:37, Jason Wang wrote:
> >>>>> On Thu, Jan 8, 2026 at 5:06 AM Simon Schippers
> >>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>
> >>>>>> This commit prevents tail-drop when a qdisc is present and the ptr_ring
> >>>>>> becomes full. Once an entry is successfully produced and the ptr_ring
> >>>>>> reaches capacity, the netdev queue is stopped instead of dropping
> >>>>>> subsequent packets.
> >>>>>>
> >>>>>> If producing an entry fails anyways, the tun_net_xmit returns
> >>>>>> NETDEV_TX_BUSY, again avoiding a drop. Such failures are expected because
> >>>>>> LLTX is enabled and the transmit path operates without the usual locking.
> >>>>>> As a result, concurrent calls to tun_net_xmit() are not prevented.
> >>>>>>
> >>>>>> The existing __{tun,tap}_ring_consume functions free space in the
> >>>>>> ptr_ring and wake the netdev queue. Races between this wakeup and the
> >>>>>> queue-stop logic could leave the queue stopped indefinitely. To prevent
> >>>>>> this, a memory barrier is enforced (as discussed in a similar
> >>>>>> implementation in [1]), followed by a recheck that wakes the queue if
> >>>>>> space is already available.
> >>>>>>
> >>>>>> If no qdisc is present, the previous tail-drop behavior is preserved.
> >>>>>>
> >>>>>> +-------------------------+-----------+---------------+----------------+
> >>>>>> | pktgen benchmarks to    | Stock     | Patched with  | Patched with   |
> >>>>>> | Debian VM, i5 6300HQ,   |           | noqueue qdisc | fq_codel qdisc |
> >>>>>> | 10M packets             |           |               |                |
> >>>>>> +-----------+-------------+-----------+---------------+----------------+
> >>>>>> | TAP       | Transmitted | 196 Kpps  | 195 Kpps      | 185 Kpps       |
> >>>>>> |           +-------------+-----------+---------------+----------------+
> >>>>>> |           | Lost        | 1618 Kpps | 1556 Kpps     | 0              |
> >>>>>> +-----------+-------------+-----------+---------------+----------------+
> >>>>>> | TAP       | Transmitted | 577 Kpps  | 582 Kpps      | 578 Kpps       |
> >>>>>> |  +        +-------------+-----------+---------------+----------------+
> >>>>>> | vhost-net | Lost        | 1170 Kpps | 1109 Kpps     | 0              |
> >>>>>> +-----------+-------------+-----------+---------------+----------------+
> >>>>>>
> >>>>>> [1] Link: https://lore.kernel.org/all/20250424085358.75d817ae@kernel.org/
> >>>>>>
> >>>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> >>>>>> ---
> >>>>>>  drivers/net/tun.c | 31 +++++++++++++++++++++++++++++--
> >>>>>>  1 file changed, 29 insertions(+), 2 deletions(-)
> >>>>>>
> >>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>>>>> index 71b6981d07d7..74d7fd09e9ba 100644
> >>>>>> --- a/drivers/net/tun.c
> >>>>>> +++ b/drivers/net/tun.c
> >>>>>> @@ -1008,6 +1008,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
> >>>>>>         struct netdev_queue *queue;
> >>>>>>         struct tun_file *tfile;
> >>>>>>         int len = skb->len;
> >>>>>> +       bool qdisc_present;
> >>>>>> +       int ret;
> >>>>>>
> >>>>>>         rcu_read_lock();
> >>>>>>         tfile = rcu_dereference(tun->tfiles[txq]);
> >>>>>> @@ -1060,13 +1062,38 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
> >>>>>>
> >>>>>>         nf_reset_ct(skb);
> >>>>>>
> >>>>>> -       if (ptr_ring_produce(&tfile->tx_ring, skb)) {
> >>>>>> +       queue = netdev_get_tx_queue(dev, txq);
> >>>>>> +       qdisc_present = !qdisc_txq_has_no_queue(queue);
> >>>>>> +
> >>>>>> +       spin_lock(&tfile->tx_ring.producer_lock);
> >>>>>> +       ret = __ptr_ring_produce(&tfile->tx_ring, skb);
> >>>>>> +       if (__ptr_ring_produce_peek(&tfile->tx_ring) && qdisc_present) {
> >>>>>> +               netif_tx_stop_queue(queue);
> >>>>>> +               /* Avoid races with queue wake-up in
> >>>>>> +                * __{tun,tap}_ring_consume by waking if space is
> >>>>>> +                * available in a re-check.
> >>>>>> +                * The barrier makes sure that the stop is visible before
> >>>>>> +                * we re-check.
> >>>>>> +                */
> >>>>>> +               smp_mb__after_atomic();
> >>>>>> +               if (!__ptr_ring_produce_peek(&tfile->tx_ring))
> >>>>>> +                       netif_tx_wake_queue(queue);
> >>>>>
> >>>>> I'm not sure I will get here, but I think those should be moved to the
> >>>>> following if(ret) check. If __ptr_ring_produce() succeed, there's no
> >>>>> need to bother with those queue stop/wake logic?
> >>>>
> >>>> There is a need for that. If __ptr_ring_produce_peek() returns -ENOSPC,
> >>>> we stop the queue proactively.
> >>>
> >>> This seems to conflict with the following NETDEV_TX_BUSY. Or is
> >>> NETDEV_TX_BUSY prepared for the xdp_xmit?
> >>
> >> Am I not allowed to stop the queue and then return NETDEV_TX_BUSY?
> > 
> > No, I mean I don't understand why we still need to peek since we've
> > already used NETDEV_TX_BUSY.
> 
> Yes, if __ptr_ring_produce() returns -ENOSPC, there is no need to check
> __ptr_ring_produce_peek(). I agree with you on this point and will update
> the code accordingly. In all other cases, checking
> __ptr_ring_produce_peek() is still required in order to proactively stop
> the queue.
> 
> > 
> >> And I do not understand the connection with xdp_xmit.
> > 
> > Since there's we don't modify xdp_xmit path, so even if we peek next
> > ndo_start_xmit can still hit ring full.
> 
> Ah okay. Would you apply the same stop-and-recheck logic in
> tun_xdp_xmit when __ptr_ring_produce() fails to produce it, or is that
> not permitted there?
> 
> Apart from that, as noted in the commit message, since we are using LLTX,
> hitting a full ring is still possible anyway. I could see that especially
> at multiqueue tests with pktgen by looking at the qdisc requeues.
> 
> Thanks

If it's an exceptional rare condition (i.e. a race), it's not a big deal. That's why
NETDEV_TX_BUSY is there in the 1st place. If it's the main modus
operadi - not good.


> > 
> > Thanks
> > 
> >>
> >>>
> >>>>
> >>>> I believe what you are aiming for is to always stop the queue if(ret),
> >>>> which I can agree with. In that case, I would simply change the condition
> >>>> to:
> >>>>
> >>>> if (qdisc_present && (ret || __ptr_ring_produce_peek(&tfile->tx_ring)))
> >>>>
> >>>>>
> >>>>>> +       }
> >>>>>> +       spin_unlock(&tfile->tx_ring.producer_lock);
> >>>>>> +
> >>>>>> +       if (ret) {
> >>>>>> +               /* If a qdisc is attached to our virtual device,
> >>>>>> +                * returning NETDEV_TX_BUSY is allowed.
> >>>>>> +                */
> >>>>>> +               if (qdisc_present) {
> >>>>>> +                       rcu_read_unlock();
> >>>>>> +                       return NETDEV_TX_BUSY;
> >>>>>> +               }
> >>>>>>                 drop_reason = SKB_DROP_REASON_FULL_RING;
> >>>>>>                 goto drop;
> >>>>>>         }
> >>>>>>
> >>>>>>         /* dev->lltx requires to do our own update of trans_start */
> >>>>>> -       queue = netdev_get_tx_queue(dev, txq);
> >>>>>>         txq_trans_cond_update(queue);
> >>>>>>
> >>>>>>         /* Notify and wake up reader process */
> >>>>>> --
> >>>>>> 2.43.0
> >>>>>>
> >>>>>
> >>>>> Thanks
> >>>>>
> >>>>
> >>>
> >>> Thanks
> >>>
> >>
> > 


