Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B8364C78D
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 11:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbiLNK7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 05:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237936AbiLNK7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 05:59:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A4714038
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 02:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671015532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bsm8rypiWXXlAJ/OnIAvVOQDlYOOMt1+SaQ7hOIMf78=;
        b=T6CDKCDihF+0BOz/Fb8yhLYxRctXcgmKlxfotPR6NdPFrwq97drZnM5v/rPOEl4cyi+Sld
        ZIy8QF3Gf6MmtN08vjyCC1Lz2tScKY5/4paDrv9Vx01pLksy9/KaedqbU5WD0VcBAhNvBc
        V0gw1mmL4lIITBIilRRHPeuJFdXw+/k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-646-7_s7-Jw8N1-oo03dwzVPWA-1; Wed, 14 Dec 2022 05:58:50 -0500
X-MC-Unique: 7_s7-Jw8N1-oo03dwzVPWA-1
Received: by mail-wm1-f71.google.com with SMTP id c187-20020a1c35c4000000b003cfee3c91cdso6256005wma.6
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 02:58:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bsm8rypiWXXlAJ/OnIAvVOQDlYOOMt1+SaQ7hOIMf78=;
        b=7fhewb5uVgZRcP7yEjnAADjP9CtT8AmlqMJMPZeOviLEURAyIajeiPaayzbzBi2Fi3
         weBHBmBjob1CS5ZBzztIoe/daK7d3CYmXYXcu0bR42yXCtIWdIRTH3sMes8v/JbmSo8+
         51nYb6h8r7HeSa5gVR7MRCBcijFrYikVtjrybTV0PpjmVgcz4A5TmtyV17XCLePJ4TIb
         jXkwkZHBK2Ynh9J3iEbLJUDqq7G07f0oBvPJvk50ukC1eeS++POU19e5Pq6nzDpOwUwF
         pxPIyBUcPx6RXO4H4DTAT+l3LocQB3xyGrNa98pLfCYNE8bk7GHu9vvKwy1awHopddqQ
         F1BQ==
X-Gm-Message-State: ANoB5plDuS1i+QTPeqo+oqqZ0SJguwwU/ANlxs9nWqwiIIJ6ZR+g4OQU
        mMIm4G6PPEWQMEHG5P6eorskUqzAY8mFvUmHiqYfwFx2y1iVVcxhdn2vp9CKq6uT7QcBH2fzAVp
        c2YsnyCys7FgN
X-Received: by 2002:a05:600c:1c9e:b0:3d2:7a7:5cc6 with SMTP id k30-20020a05600c1c9e00b003d207a75cc6mr16127426wms.18.1671015529752;
        Wed, 14 Dec 2022 02:58:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4GhTuy3yFMob3cVWbwQSim+kT62Pp9g1pSNQfJtskVOvtO6CT9jLknO7unhHjf9Ss6p0OSBw==
X-Received: by 2002:a05:600c:1c9e:b0:3d2:7a7:5cc6 with SMTP id k30-20020a05600c1c9e00b003d207a75cc6mr16127414wms.18.1671015529490;
        Wed, 14 Dec 2022 02:58:49 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-97-87.dyn.eolo.it. [146.241.97.87])
        by smtp.gmail.com with ESMTPSA id m17-20020a05600c3b1100b003c6b7f5567csm7893601wms.0.2022.12.14.02.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 02:58:49 -0800 (PST)
Message-ID: <4b66f91f23a3eb91c3232bc68f45bdb799217c40.camel@redhat.com>
Subject: Re: [PATCH net-next v7] virtio/vsock: replace virtio_vsock_pkt with
 sk_buff
From:   Paolo Abeni <pabeni@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 14 Dec 2022 11:58:47 +0100
In-Reply-To: <20221213192843.421032-1-bobby.eshleman@bytedance.com>
References: <20221213192843.421032-1-bobby.eshleman@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-12-13 at 19:28 +0000, Bobby Eshleman wrote:
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 5703775af129..2a5994b029b2 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -51,8 +51,7 @@ struct vhost_vsock {
>  	struct hlist_node hash;
>  
>  	struct vhost_work send_pkt_work;
> -	spinlock_t send_pkt_list_lock;
> -	struct list_head send_pkt_list;	/* host->guest pending packets */
> +	struct sk_buff_head send_pkt_queue; /* host->guest pending packets */
>  
>  	atomic_t queued_replies;
>  
> @@ -108,40 +107,33 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  	vhost_disable_notify(&vsock->dev, vq);
>  
>  	do {
> -		struct virtio_vsock_pkt *pkt;
> +		struct virtio_vsock_hdr *hdr;
> +		size_t iov_len, payload_len;
>  		struct iov_iter iov_iter;
> +		u32 flags_to_restore = 0;
> +		struct sk_buff *skb;
>  		unsigned out, in;
>  		size_t nbytes;
> -		size_t iov_len, payload_len;
>  		int head;
> -		u32 flags_to_restore = 0;
>  
> -		spin_lock_bh(&vsock->send_pkt_list_lock);
> -		if (list_empty(&vsock->send_pkt_list)) {
> -			spin_unlock_bh(&vsock->send_pkt_list_lock);
> +		spin_lock(&vsock->send_pkt_queue.lock);
> +		skb = __skb_dequeue(&vsock->send_pkt_queue);
> +		spin_unlock(&vsock->send_pkt_queue.lock);

Here you use a plain spin_lock(), but every other lock has the _bh()
variant. A few lines above this functions acquires a mutex, so this is
process context (and not BH context): I guess you should use _bh()
here, too.

[...]

> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index 35d7eedb5e8e..0385df976d41 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -3,10 +3,116 @@
>  #define _LINUX_VIRTIO_VSOCK_H
>  
>  #include <uapi/linux/virtio_vsock.h>
> +#include <linux/bits.h>
>  #include <linux/socket.h>
>  #include <net/sock.h>
>  #include <net/af_vsock.h>
>  
> +#define VIRTIO_VSOCK_SKB_HEADROOM (sizeof(struct virtio_vsock_hdr))
> +
> +enum virtio_vsock_skb_flags {
> +	VIRTIO_VSOCK_SKB_FLAGS_REPLY		= BIT(0),
> +	VIRTIO_VSOCK_SKB_FLAGS_TAP_DELIVERED	= BIT(1),
> +};

It looks like the above enum is not used anymore, you can drop it.

[...]

> @@ -121,20 +108,18 @@ static void vsock_loopback_work(struct work_struct *work)
>  {
>  	struct vsock_loopback *vsock =
>  		container_of(work, struct vsock_loopback, pkt_work);
> -	LIST_HEAD(pkts);
> +	struct sk_buff_head pkts;
> +	struct sk_buff *skb;
> +
> +	skb_queue_head_init(&pkts);
>  
>  	spin_lock_bh(&vsock->pkt_list_lock);
> -	list_splice_init(&vsock->pkt_list, &pkts);
> +	skb_queue_splice_init(&vsock->pkt_queue, &pkts);
>  	spin_unlock_bh(&vsock->pkt_list_lock);
>  
> -	while (!list_empty(&pkts)) {
> -		struct virtio_vsock_pkt *pkt;
> -
> -		pkt = list_first_entry(&pkts, struct virtio_vsock_pkt, list);
> -		list_del_init(&pkt->list);
> -
> -		virtio_transport_deliver_tap_pkt(pkt);
> -		virtio_transport_recv_pkt(&loopback_transport, pkt);
> +	while ((skb = skb_dequeue(&pkts))) {

Minor nit: since this code has complete ownership of the pkts queue,
you can use the lockless dequeue variant here:

	while ((skb = __skb_dequeue(&pkts))) {

> +		virtio_transport_deliver_tap_pkt(skb);
> +		virtio_transport_recv_pkt(&loopback_transport, skb);
>  	}
>  }
>  

Other then that LGTM. @Michael: feel free to take this via your tree,
once that the above feedback has been addressed, thanks!

Paolo

