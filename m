Return-Path: <kvm+bounces-58542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEBC8B966F3
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D33219C46D8
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50ED025A340;
	Tue, 23 Sep 2025 14:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HqUxqali"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD06244685
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758638882; cv=none; b=kXT4j5Cb2GioshFzpsGJtgfOEq3uSn+CWTQ6aW0MOEXlmotzz4kgyYpDcRI/SZ2jJBDqcoTmuwn21tBrGlJEMAEZ6hHBg0e3aUDBbxZGfN/O/F6PuO1D069DgrmCpz/a2jllfO19Vs+QcQGs7CGYyP02uxh+7SJTPPn/1NeaIww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758638882; c=relaxed/simple;
	bh=KeqE1HEyB8QFnK2pN1rXqm6q+uT9Q0dbCDWcjv2Nc1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n34JkwFGUND1FLybu/D+8KZVVg0ySbAdnVFZxik4Zgo0cw7TsBaxKE+jeaEPF7snymKFm1SbBHTX5bnvDjaIK7HcslJX6fe2iCfVsnHYa2TalkWDGRj8A5bf4kHqo4l58rXzWJuvJhaP/iqakIsqKbxBQVDV/n5boWem7RjtfBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HqUxqali; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758638878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lGsm6H7P2q74l6MeTkSvpQNEFLpHSBIxi1h0StSUMNY=;
	b=HqUxqalit4ylNklbXO2dF3Q4PV+nAEN4XjrUomQ4Sd2auRZvD9oNNYqJFoTqy1gy1alT4C
	+Zo2SdoxuQ9nTSDPCHWiF8Uc4H1YWCq5BmtMKHX6uP4hh8OXKLivkBX329Ln5qMU/wa1o6
	aNPvUnB2NSSx0fEEpWtVoUQnB1ydJwc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-YFEcmEa7Nem0omnBtZqplg-1; Tue, 23 Sep 2025 10:47:57 -0400
X-MC-Unique: YFEcmEa7Nem0omnBtZqplg-1
X-Mimecast-MFC-AGG-ID: YFEcmEa7Nem0omnBtZqplg_1758638876
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3f42b54d159so3196544f8f.2
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 07:47:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758638876; x=1759243676;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lGsm6H7P2q74l6MeTkSvpQNEFLpHSBIxi1h0StSUMNY=;
        b=vhCmbYbrzw6Mhb4zEpmOiLJ1oW9yg0u1MZwJOqFcWI1qggTm6PIey/kLvvTG09xNm/
         fQURqeNed4J9zIl1wYmDKTo056/xBi4cVQ1N9NPyaqepuLP5++xGuh4HDcmSDyGBaeVb
         CmaPuNr4u7vasiCzBnqn9S4fJGEzDE1XcXEw2ReA04XG6qkCoVVP8hiQ3iorLX+50ylh
         6l+GF/54h8zPPmxkmsDCqsv/p1u+ojcUXv11KA06nGBtN8AMVHszMy69nn0kNaj8WWbI
         A61API8Yozd0lMgKFchgHxgyUwSUV0pt10An7Up7myGTQ9Ho2BOyfDc+BDuyt9AlQqRv
         U9/w==
X-Forwarded-Encrypted: i=1; AJvYcCUDnvOUPCL3Uw8FKrAt+4JrV/bc94gR/bei6MpZLejCdSBADeEkDFYX7Nvek7oBbtBKbqg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHExlLH7Z3MvBgIDO5u9cbdCgtdjGadlEOK4ht9RoTuxouxhWD
	ZbDBmHGA5IdMRasRNiwPVrfokDp1V+lwK/ERvSldm0y+v1h/3E9QLK3dVxh6kqk1HerK1WLb3f5
	hYDZQQvHXrtl/j+sUiGYGJcegyRHflZihZDxOiDBrd4Axlc94Ufdyxw==
X-Gm-Gg: ASbGncuytR4kn+R9ea7tehFqJvMpAhI62HvsNKYAYcRhM36u0yqk5izzVAFiCTFp1zH
	BSjnd2ClSu35+YpcEaKsg9ZwRosOs4IjpeJ/pltGYfFvOjhFBNvLqNLgH3a9yiovzHKzJp0rq8A
	LkB3vg/K8CGqEQcks0ANd691ea87IoGCUVhFTeWDnU3qr+Hni82NpHPfmOFKQh5RsowqIRhdIUh
	zPFReIGtxRIuVcW7RuCM4M9OLnTWFUBd683ezM2bkHSVtHM580zdvWCyXNSWYMFL0Z3SKVa6Tct
	m/Un6BMj+h04p/6mS0sMALMZkyuMAcBMUu4=
X-Received: by 2002:a05:6000:220c:b0:3f3:88e1:9e30 with SMTP id ffacd0b85a97d-405c5bd85e9mr2624048f8f.15.1758638875916;
        Tue, 23 Sep 2025 07:47:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVQW7wtomtpR1qDlFcvwbCRqGqsve/Ts8yCwjgDlTYhRUQTsERWyfPd2452H8Z8mCijph+Xg==
X-Received: by 2002:a05:6000:220c:b0:3f3:88e1:9e30 with SMTP id ffacd0b85a97d-405c5bd85e9mr2624025f8f.15.1758638875505;
        Tue, 23 Sep 2025 07:47:55 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f61703b206sm14087074f8f.6.2025.09.23.07.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 07:47:55 -0700 (PDT)
Date: Tue, 23 Sep 2025 10:47:52 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: Re: [PATCH net-next v5 3/8] TUN, TAP & vhost_net: Stop netdev queue
 before reaching a full ptr_ring
Message-ID: <20250923104348-mutt-send-email-mst@kernel.org>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
 <20250922221553.47802-4-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922221553.47802-4-simon.schippers@tu-dortmund.de>

On Tue, Sep 23, 2025 at 12:15:48AM +0200, Simon Schippers wrote:
> Stop the netdev queue ahead of __ptr_ring_produce when
> __ptr_ring_full_next signals the ring is about to fill. Due to the
> smp_wmb() of __ptr_ring_produce the consumer is guaranteed to be able to
> notice the stopped netdev queue after seeing the new ptr_ring entry. As
> both __ptr_ring_full_next and __ptr_ring_produce need the producer_lock,
> the lock is held during the execution of both methods.
> 
> dev->lltx is disabled to ensure that tun_net_xmit is not called even
> though the netdev queue is stopped (which happened in my testing,
> resulting in rare packet drops). Consequently, the update of trans_start
> in tun_net_xmit is also removed.
> 
> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> ---
>  drivers/net/tun.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 86a9e927d0ff..c6b22af9bae8 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -931,7 +931,7 @@ static int tun_net_init(struct net_device *dev)
>  	dev->vlan_features = dev->features &
>  			     ~(NETIF_F_HW_VLAN_CTAG_TX |
>  			       NETIF_F_HW_VLAN_STAG_TX);
> -	dev->lltx = true;
> +	dev->lltx = false;
>  
>  	tun->flags = (tun->flags & ~TUN_FEATURES) |
>  		      (ifr->ifr_flags & TUN_FEATURES);
> @@ -1060,14 +1060,18 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	nf_reset_ct(skb);
>  
> -	if (ptr_ring_produce(&tfile->tx_ring, skb)) {
> +	queue = netdev_get_tx_queue(dev, txq);
> +
> +	spin_lock(&tfile->tx_ring.producer_lock);
> +	if (__ptr_ring_full_next(&tfile->tx_ring))
> +		netif_tx_stop_queue(queue);
> +
> +	if (unlikely(__ptr_ring_produce(&tfile->tx_ring, skb))) {
> +		spin_unlock(&tfile->tx_ring.producer_lock);
>  		drop_reason = SKB_DROP_REASON_FULL_RING;
>  		goto drop;
>  	}

The comment makes it sound like you always keep one slot free
in the queue but that is not the case - you just
check before calling __ptr_ring_produce.


But it is racy isn't it? So first of all I suspect you
are missing an mb before netif_tx_stop_queue.

Second it's racy because more entries can get freed
afterwards. Which maybe is ok in this instance?
But it really should be explained in more detail, if so.



Now - why not just check ring full *after* __ptr_ring_produce?
Why do we need all these new APIs, and we can
use existing ones which at least are not so hard to understand.




> -
> -	/* dev->lltx requires to do our own update of trans_start */
> -	queue = netdev_get_tx_queue(dev, txq);
> -	txq_trans_cond_update(queue);
> +	spin_unlock(&tfile->tx_ring.producer_lock);
>  
>  	/* Notify and wake up reader process */
>  	if (tfile->flags & TUN_FASYNC)
> -- 
> 2.43.0


