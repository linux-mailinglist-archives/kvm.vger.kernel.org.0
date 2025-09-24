Return-Path: <kvm+bounces-58607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4DA9B984DD
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 07:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FF984A0645
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 05:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C5523D7DE;
	Wed, 24 Sep 2025 05:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gMvemh7F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7CA23B628
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 05:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758693044; cv=none; b=EJYiaUS0QdgufMZ9CYBferQQafbgbE+xOU8W/qAx12etY6lxmLbZ0A/SxjQlLvTr5PodGdzyAePLcvzMrpXOIwj5sli5x1HR2TPsXEaeChgBKp2iOvpOlh9WVVBE8dvePaOH4cw5TK10O6KxpQsKGSINQC+GsJmjK95Z9zLYiqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758693044; c=relaxed/simple;
	bh=/J1NuLRSXzUZpYo/ANfB3d4ysGO2emGoUiZYdgGvFRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rnbqUdZC9FHFtD3oRdugkqE4UVYwdQCw6yrC/nM8aFDHBWPap9Yp0bi6+/XQS4TOq3zKXcEU9JmtYFO+O35QoO0kQjGe8CIIkNzBlOAl0PZGJ6XaTXwFldTPMHZnKOgExtrsqWMW7AP1fa8lF0I5h9xnWScayd+WjA0YAIWlz6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gMvemh7F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758693041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ppJ/4+p6+d9eQBtSGx+90R7i7ZmKWove36hByh++FaI=;
	b=gMvemh7FX6iDENF2CQyXd3nwJaGhXOhdSwLlw0j6ZR/dRW4wuaeFqptNalp1yR0cofghzg
	++XTzqvgFKWYzQo+qWbcHTMHFr5feyMPlGDgSwEW/4jWcI0DP7hIzNIcEVjTCt989f7ykR
	QGACc2IzTmhK0uyDj4jjCSLGiICtWFk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-RrVrj_fkPQmoZiJyR_ZTfQ-1; Wed, 24 Sep 2025 01:50:39 -0400
X-MC-Unique: RrVrj_fkPQmoZiJyR_ZTfQ-1
X-Mimecast-MFC-AGG-ID: RrVrj_fkPQmoZiJyR_ZTfQ_1758693038
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e1a2a28f4so14733845e9.2
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 22:50:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758693038; x=1759297838;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ppJ/4+p6+d9eQBtSGx+90R7i7ZmKWove36hByh++FaI=;
        b=s0vTPZd0U6UYqJtJZEaiQg0vZcOs6gePxQBfejj0kGAXtnbF4nwn8X+TETuL5t4pSj
         v98y58imG9jzBcXmGJPsqdm7Hckz34tbNY4Gv+SUvIKPrS0emDe9akSt/0On/A7VsrWE
         JCRIN7YULphH4PzqSnzFeB1x2UePHbjFUj2NZ9RvqwmdYEUS6oPgHxpnVvx2s6CbXoMw
         54zHw7PdiQIn89GYBvr7DNSt31vPn4IayJ8sE/M4v/vo/UEPzQSClkiG6knj6nqZKN8d
         yjeOVRsXEnmiRjjrD26I/4R/zfU7HAAbbUVxAutkkoE8ot3RVFuoQYgJgweLoI8gPWQF
         jIWw==
X-Forwarded-Encrypted: i=1; AJvYcCX5/ij+OJ6nlCzglh7MO9q4G45tr9nOC9PYuE5avYIoV+/PXhow7vDJqM9kANK6bTAccaM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSD8XkxUyeCOe4YVP1r3kAHJIWXK0EbzUHXi8sFWjwCDwSwEHe
	WW1NqQ4UVEMd2fI1/EIHUss8E+fr60vTdLzBXQykXE7zMGqFpfFqa7kMLTuJGTEmxuFBHkcLJSc
	v2fUVlpEz7sxjbuSZhEiOT+ckdnp6qKIzhX5QkNdtu9olPDqi3Fn18g==
X-Gm-Gg: ASbGnctuSEiJkwAduEaAyonDTal6AL1LNqezcvk+ZhMS1CwvLO8fyT44FLWKanfpkRk
	463yBmVZwyqyD5RXbYjIuuh3WqpFFFwBbEzvCQNjhiqp2dHk53sGSnwsjrYeJi+S939swxHpZMG
	+lacs782O9QRgT8Ahloib60oP2pXBxqCxm3T/wRcgjVb9hJjXRXLIol2q1j4655sDbWqShF1bGj
	KYh/NHKoC2+UO8+TRpwzbUx0GmgUoy2GuO1hdz9ItG5igB7ypLrOy6ucAr9rZ+B56NxSW2bLXJA
	RZ0q2vFpVJYvWRicFPKMOsES8N/+LWM0ebE=
X-Received: by 2002:a05:600c:1d11:b0:45d:d9ca:9f8a with SMTP id 5b1f17b1804b1-46e1dac604cmr44570225e9.27.1758693038301;
        Tue, 23 Sep 2025 22:50:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEI5yChju2CNQTfr7bjk/jSZjz66aaKFh1WsB19/2l6F8R6L8aK5fNSSg13stYE6WzGdJUdzA==
X-Received: by 2002:a05:600c:1d11:b0:45d:d9ca:9f8a with SMTP id 5b1f17b1804b1-46e1dac604cmr44570045e9.27.1758693037866;
        Tue, 23 Sep 2025 22:50:37 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e21c8b7eesm22011065e9.4.2025.09.23.22.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 22:50:37 -0700 (PDT)
Date: Wed, 24 Sep 2025 01:50:34 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: Re: [PATCH net-next v5 3/8] TUN, TAP & vhost_net: Stop netdev queue
 before reaching a full ptr_ring
Message-ID: <20250924014703-mutt-send-email-mst@kernel.org>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250922221553.47802-4-simon.schippers@tu-dortmund.de>
 <20250923104348-mutt-send-email-mst@kernel.org>
 <71afbe18-3a5a-44ca-bb3b-b018f73ae8c6@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71afbe18-3a5a-44ca-bb3b-b018f73ae8c6@tu-dortmund.de>

On Wed, Sep 24, 2025 at 07:41:28AM +0200, Simon Schippers wrote:
> Hi,
> first of all thank you very much for your detailed replies! :)
> 
> On 23.09.25 16:47, Michael S. Tsirkin wrote:
> > On Tue, Sep 23, 2025 at 12:15:48AM +0200, Simon Schippers wrote:
> >> Stop the netdev queue ahead of __ptr_ring_produce when
> >> __ptr_ring_full_next signals the ring is about to fill. Due to the
> >> smp_wmb() of __ptr_ring_produce the consumer is guaranteed to be able to
> >> notice the stopped netdev queue after seeing the new ptr_ring entry. As
> >> both __ptr_ring_full_next and __ptr_ring_produce need the producer_lock,
> >> the lock is held during the execution of both methods.
> >>
> >> dev->lltx is disabled to ensure that tun_net_xmit is not called even
> >> though the netdev queue is stopped (which happened in my testing,
> >> resulting in rare packet drops). Consequently, the update of trans_start
> >> in tun_net_xmit is also removed.
> >>
> >> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> >> ---
> >>  drivers/net/tun.c | 16 ++++++++++------
> >>  1 file changed, 10 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >> index 86a9e927d0ff..c6b22af9bae8 100644
> >> --- a/drivers/net/tun.c
> >> +++ b/drivers/net/tun.c
> >> @@ -931,7 +931,7 @@ static int tun_net_init(struct net_device *dev)
> >>  	dev->vlan_features = dev->features &
> >>  			     ~(NETIF_F_HW_VLAN_CTAG_TX |
> >>  			       NETIF_F_HW_VLAN_STAG_TX);
> >> -	dev->lltx = true;
> >> +	dev->lltx = false;
> >>  
> >>  	tun->flags = (tun->flags & ~TUN_FEATURES) |
> >>  		      (ifr->ifr_flags & TUN_FEATURES);
> >> @@ -1060,14 +1060,18 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
> >>  
> >>  	nf_reset_ct(skb);
> >>  
> >> -	if (ptr_ring_produce(&tfile->tx_ring, skb)) {
> >> +	queue = netdev_get_tx_queue(dev, txq);
> >> +
> >> +	spin_lock(&tfile->tx_ring.producer_lock);
> >> +	if (__ptr_ring_full_next(&tfile->tx_ring))
> >> +		netif_tx_stop_queue(queue);
> >> +
> >> +	if (unlikely(__ptr_ring_produce(&tfile->tx_ring, skb))) {
> >> +		spin_unlock(&tfile->tx_ring.producer_lock);
> >>  		drop_reason = SKB_DROP_REASON_FULL_RING;
> >>  		goto drop;
> >>  	}
> > 
> > The comment makes it sound like you always keep one slot free
> > in the queue but that is not the case - you just
> > check before calling __ptr_ring_produce.
> > 
> 
> I agree.
> 
> > 
> > But it is racy isn't it? So first of all I suspect you
> > are missing an mb before netif_tx_stop_queue.
> > 
> 
> I don’t really get this point right now.

ring full next is a read. stop queue is a write. if you are
relying on ordering them in some way you need a full mb generally.




> > Second it's racy because more entries can get freed
> > afterwards. Which maybe is ok in this instance?
> > But it really should be explained in more detail, if so.
> > 
> 
> Will be covered in the next mail.
> 
> > 
> > 
> > Now - why not just check ring full *after* __ptr_ring_produce?
> > Why do we need all these new APIs, and we can
> > use existing ones which at least are not so hard to understand.
> > 
> > 
> 
> You convinced me about changing my implementation anyway but here my (old) 
> idea:
> I did this in V1-V4. The problem is that vhost_net is only called on 
> EPOLLIN triggered by tun_net_xmit. Then, after consuming a batch from the 
> ptr_ring, it must be able to see if the netdev queue stopped or not. If 
> this is not the case the ptr_ring might get empty and vhost_net is not 
> able to wake the queue again (because it is not stopped from its POV), 
> which happened in my testing in my V4.
> 
> This is the reason why, now in the V5, in tun_net_xmit I stop the netdev 
> queue before producing. With that I exploit the smp_wmb() in 
> __ptr_ring_produce which is paired with the READ_ONCE in __ptr_ring_peek 
> to ensure that the consumer in vhost_net sees that the netdev queue 
> stopped after consuming a batch.

yea you said it somewhere in code, too, and I am not sure I understand it all, but
wmb isn't paired with READ_ONCE generally. barrier pairing
is described in memory-barriers.txt, READ_ONCE is not a barrier
at all.

> > 
> > 
> >> -
> >> -	/* dev->lltx requires to do our own update of trans_start */
> >> -	queue = netdev_get_tx_queue(dev, txq);
> >> -	txq_trans_cond_update(queue);
> >> +	spin_unlock(&tfile->tx_ring.producer_lock);
> >>  
> >>  	/* Notify and wake up reader process */
> >>  	if (tfile->flags & TUN_FASYNC)
> >> -- 
> >> 2.43.0
> > 


