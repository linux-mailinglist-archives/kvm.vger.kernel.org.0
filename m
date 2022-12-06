Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B219164412A
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 11:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiLFKVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 05:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiLFKVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 05:21:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7FC7676
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 02:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670322028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jHrzc7nXr4YvCNaFmiJ1lG1BHgrUaPmAIMwaF5/OBO4=;
        b=KJwp2tS7QXn015PwBDP7+jXgN8Z2Zjce2Wq7Ij5FNUd2v87d8otQbYEZeuBN2uLDSI/syD
        O9E4pYdkLeTUcwDZ84yxsRZaTj6oCCtU8IsafDzMBcD58Y++kHoDG0E1INl1N3uFFMy64H
        J04JXsxp+xBL4KsWlFhmU9gjmT9YWus=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-136-bJyGzAr3NMyfOWGXsJopPA-1; Tue, 06 Dec 2022 05:20:27 -0500
X-MC-Unique: bJyGzAr3NMyfOWGXsJopPA-1
Received: by mail-qk1-f198.google.com with SMTP id v7-20020a05620a0f0700b006faffce43b2so19797713qkl.9
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 02:20:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jHrzc7nXr4YvCNaFmiJ1lG1BHgrUaPmAIMwaF5/OBO4=;
        b=ONmuOJ0YJzhLbDZu7+mKtZcqsTm7vr1Y5AUVCksWI8IPtT0b0heLXQ2eLGiJZa4EZD
         tMMIpxytuDWeRrKDGoC3vvqJ8u0dy4QZxcHG4//K0DY3TPfdV5GDUb5eC64oniDQSuLE
         mK4gPJOXyiPpz9old5fZoTktLEHA+COWZyC91FbUUVq+LBqNt7Wzmc+sUDB8nzABwtqW
         Kvpn8n1VVb2OAoBREVC0p3xmXIxG4GvgNGACJnrkNyXFda+xc17eCmcWAA/Rk5dOH9CI
         wYkfvNtS06+6VKDMj31SjOCtZrCbVUTWp97IOqpRY4+ypEEU/LQaik5sHgxYYAvzjlNi
         TzSQ==
X-Gm-Message-State: ANoB5pmzrofY0tV1M7DZKwHgeNZr2EA3sXa08Zp1nm4FQ9zuhm2ofnD9
        a7t0NO3dVvQfJxk3+or1mPmvECtuEW5VipFmWnz0n6L4pbCbfNFq7B8LkIh/MHVSk7axSAhUP7x
        3O2Au8GEkZcc0
X-Received: by 2002:a05:622a:4017:b0:3a5:4f7e:bab2 with SMTP id cf23-20020a05622a401700b003a54f7ebab2mr64363598qtb.527.1670322026695;
        Tue, 06 Dec 2022 02:20:26 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5qvnmSSJhD7XhInjAoVoAZX/6OMJ6iTD3rm9lH6Om7UxRSOVZ1bSbEKEISqvQ5FcAl/6HHWQ==
X-Received: by 2002:a05:622a:4017:b0:3a5:4f7e:bab2 with SMTP id cf23-20020a05622a401700b003a54f7ebab2mr64363575qtb.527.1670322026401;
        Tue, 06 Dec 2022 02:20:26 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-106-100.dyn.eolo.it. [146.241.106.100])
        by smtp.gmail.com with ESMTPSA id bi6-20020a05620a318600b006fa16fe93bbsm14341627qkb.15.2022.12.06.02.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 02:20:26 -0800 (PST)
Message-ID: <863a58452b4a4c0d63a41b0f78b59d32919067fa.camel@redhat.com>
Subject: Re: [PATCH v5] virtio/vsock: replace virtio_vsock_pkt with sk_buff
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
Date:   Tue, 06 Dec 2022 11:20:21 +0100
In-Reply-To: <20221202173520.10428-1-bobby.eshleman@bytedance.com>
References: <20221202173520.10428-1-bobby.eshleman@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Fri, 2022-12-02 at 09:35 -0800, Bobby Eshleman wrote:
[...]
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index 35d7eedb5e8e..6c0b2d4da3fe 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -3,10 +3,129 @@
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
> +
> +static inline struct virtio_vsock_hdr *virtio_vsock_hdr(struct sk_buff *skb)
> +{
> +	return (struct virtio_vsock_hdr *)skb->head;
> +}
> +
> +static inline bool virtio_vsock_skb_reply(struct sk_buff *skb)
> +{
> +	return skb->_skb_refdst & VIRTIO_VSOCK_SKB_FLAGS_REPLY;
> +}

I'm sorry for the late feedback. The above is extremelly risky: if the
skb will land later into the networking stack, we could experience the
most difficult to track bugs.

You should use the skb control buffer instead (skb->cb), with the
additional benefit you could use e.g. bool - the compiler could emit
better code to manipulate such fields - and you will not need to clear
the field before release nor enqueue.

[...]

> @@ -352,37 +360,38 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>  				   size_t len)
>  {
>  	struct virtio_vsock_sock *vvs = vsk->trans;
> -	struct virtio_vsock_pkt *pkt;
>  	size_t bytes, total = 0;
> -	u32 free_space;
> +	struct sk_buff *skb;
>  	int err = -EFAULT;
> +	u32 free_space;
>  
>  	spin_lock_bh(&vvs->rx_lock);
> -	while (total < len && !list_empty(&vvs->rx_queue)) {
> -		pkt = list_first_entry(&vvs->rx_queue,
> -				       struct virtio_vsock_pkt, list);
> +	while (total < len && !skb_queue_empty_lockless(&vvs->rx_queue)) {
> +		skb = __skb_dequeue(&vvs->rx_queue);

Here the locking schema is confusing. It looks like vvs->rx_queue is
under vvs->rx_lock protection, so the above should be skb_queue_empty()
instead of the lockless variant.

[...]

> @@ -858,16 +873,11 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
>  static void virtio_transport_remove_sock(struct vsock_sock *vsk)
>  {
>  	struct virtio_vsock_sock *vvs = vsk->trans;
> -	struct virtio_vsock_pkt *pkt, *tmp;
>  
>  	/* We don't need to take rx_lock, as the socket is closing and we are
>  	 * removing it.
>  	 */
> -	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
> -		list_del(&pkt->list);
> -		virtio_transport_free_pkt(pkt);
> -	}
> -
> +	virtio_vsock_skb_queue_purge(&vvs->rx_queue);

Still assuming rx_queue is under the rx_lock, given you don't need the
locking here as per the above comment, you should use the lockless
purge variant.

Thanks!

Paolo

