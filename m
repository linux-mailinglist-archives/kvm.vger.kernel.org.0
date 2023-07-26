Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4EC763EB7
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 20:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjGZSlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 14:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjGZSlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 14:41:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE15E26BB
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 11:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690396834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hLRB+0VH4NUNA9S2GxQpRS/NrBaKH7At4oaqQkmEFHQ=;
        b=eW2XlbWRNsiKQ0HchbRrMi0EBoKn7kzTbeUhNDLbc20qep9yS0CwIk2YX4JrkU00z8Q6BI
        nbstPRIW4lqquvHwKr/ztjgzsoCDKCKnijT1qquCGWweY4nNP1PLcCCN03fZOdNtAjLET9
        wIVxq3csgTscjkHJHMMBGT0kBrBYum4=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-Uzn-h8GROZCpJ7GfxdV_Uw-1; Wed, 26 Jul 2023 14:40:31 -0400
X-MC-Unique: Uzn-h8GROZCpJ7GfxdV_Uw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2b934194964so464011fa.1
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 11:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690396830; x=1691001630;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLRB+0VH4NUNA9S2GxQpRS/NrBaKH7At4oaqQkmEFHQ=;
        b=gCRWevDH79ZxbLac9pGz7vV7IJxK262QruXrZ3egKvpRr0dtCy0q6JA+QxB9o8M1ig
         6QWqdzcHqiNH6LmZ3Dv1h19OD7IzS5wzASp4GdUyWZulULwY0elUQ59QFMgDtfDqRbp8
         b+N0503sWfThe9NxDLZ8AZRlBcEcGsXqaouaF0sq5jnHH/qaMPsx+4ly928OPcFi/fPt
         78eEjB70r82y6r8PZ2BTwaRjdyjOgGmESsXTW6r92bA/OCjXdb4KZ13y0scmyATER6xz
         q9Fl6uFzm910A0EaJxSUSa77/WKVE2EgAKaufRqQMBn5KVEWMduKW0RB0br/isiCPFRQ
         7Xjg==
X-Gm-Message-State: ABy/qLZSU/DOHjVAR/eEU4D8OAI57Fae4Hs39/7F4+NuURr6LwYvwhDR
        +UKrrH0APWU3WvmqOYAgwKzVDHEr9BieugLECL4CFKKtK8JNQajZBxQrGmk5v0sFJrAZvWEtyYo
        vnycLVFq4+pXQ
X-Received: by 2002:a05:6512:3103:b0:4fd:d213:dfd0 with SMTP id n3-20020a056512310300b004fdd213dfd0mr20085lfb.11.1690396830367;
        Wed, 26 Jul 2023 11:40:30 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFfIFB6koq240oc65lATC1OG8dihM0yJR6Errj2gYzEcAeMZ8KdgTUnrOPiNp0AKGTRCUhLIw==
X-Received: by 2002:a05:6512:3103:b0:4fd:d213:dfd0 with SMTP id n3-20020a056512310300b004fdd213dfd0mr20068lfb.11.1690396830026;
        Wed, 26 Jul 2023 11:40:30 -0700 (PDT)
Received: from redhat.com ([2.52.14.22])
        by smtp.gmail.com with ESMTPSA id o26-20020aa7d3da000000b005222c160464sm4518711edr.72.2023.07.26.11.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 11:40:27 -0700 (PDT)
Date:   Wed, 26 Jul 2023 14:40:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC net-next v5 11/14] vhost/vsock: implement datagram
 support
Message-ID: <20230726143850-mutt-send-email-mst@kernel.org>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-11-581bd37fdb26@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v5-11-581bd37fdb26@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 12:50:15AM +0000, Bobby Eshleman wrote:
> This commit implements datagram support for vhost/vsock by teaching
> vhost to use the common virtio transport datagram functions.
> 
> If the virtio RX buffer is too small, then the transmission is
> abandoned, the packet dropped, and EHOSTUNREACH is added to the socket's
> error queue.
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>

EHOSTUNREACH?


> ---
>  drivers/vhost/vsock.c    | 62 +++++++++++++++++++++++++++++++++++++++++++++---
>  net/vmw_vsock/af_vsock.c |  5 +++-
>  2 files changed, 63 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index d5d6a3c3f273..da14260c6654 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -8,6 +8,7 @@
>   */
>  #include <linux/miscdevice.h>
>  #include <linux/atomic.h>
> +#include <linux/errqueue.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/vmalloc.h>
> @@ -32,7 +33,8 @@
>  enum {
>  	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
>  			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> -			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
> +			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
> +			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
>  };
>  
>  enum {
> @@ -56,6 +58,7 @@ struct vhost_vsock {
>  	atomic_t queued_replies;
>  
>  	u32 guest_cid;
> +	bool dgram_allow;
>  	bool seqpacket_allow;
>  };
>  
> @@ -86,6 +89,32 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
>  	return NULL;
>  }
>  
> +/* Claims ownership of the skb, do not free the skb after calling! */
> +static void
> +vhost_transport_error(struct sk_buff *skb, int err)
> +{
> +	struct sock_exterr_skb *serr;
> +	struct sock *sk = skb->sk;
> +	struct sk_buff *clone;
> +
> +	serr = SKB_EXT_ERR(skb);
> +	memset(serr, 0, sizeof(*serr));
> +	serr->ee.ee_errno = err;
> +	serr->ee.ee_origin = SO_EE_ORIGIN_NONE;
> +
> +	clone = skb_clone(skb, GFP_KERNEL);
> +	if (!clone)
> +		return;
> +
> +	if (sock_queue_err_skb(sk, clone))
> +		kfree_skb(clone);
> +
> +	sk->sk_err = err;
> +	sk_error_report(sk);
> +
> +	kfree_skb(skb);
> +}
> +
>  static void
>  vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  			    struct vhost_virtqueue *vq)
> @@ -160,9 +189,15 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>  		hdr = virtio_vsock_hdr(skb);
>  
>  		/* If the packet is greater than the space available in the
> -		 * buffer, we split it using multiple buffers.
> +		 * buffer, we split it using multiple buffers for connectible
> +		 * sockets and drop the packet for datagram sockets.
>  		 */

won't this break things like recently proposed zerocopy?
I think splitup has to be supported for all types.


>  		if (payload_len > iov_len - sizeof(*hdr)) {
> +			if (le16_to_cpu(hdr->type) == VIRTIO_VSOCK_TYPE_DGRAM) {
> +				vhost_transport_error(skb, EHOSTUNREACH);
> +				continue;
> +			}
> +
>  			payload_len = iov_len - sizeof(*hdr);
>  
>  			/* As we are copying pieces of large packet's buffer to
> @@ -394,6 +429,7 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
>  	return val < vq->num;
>  }
>  
> +static bool vhost_transport_dgram_allow(u32 cid, u32 port);
>  static bool vhost_transport_seqpacket_allow(u32 remote_cid);
>  
>  static struct virtio_transport vhost_transport = {
> @@ -410,7 +446,8 @@ static struct virtio_transport vhost_transport = {
>  		.cancel_pkt               = vhost_transport_cancel_pkt,
>  
>  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> -		.dgram_allow              = virtio_transport_dgram_allow,
> +		.dgram_allow              = vhost_transport_dgram_allow,
> +		.dgram_addr_init          = virtio_transport_dgram_addr_init,
>  
>  		.stream_enqueue           = virtio_transport_stream_enqueue,
>  		.stream_dequeue           = virtio_transport_stream_dequeue,
> @@ -443,6 +480,22 @@ static struct virtio_transport vhost_transport = {
>  	.send_pkt = vhost_transport_send_pkt,
>  };
>  
> +static bool vhost_transport_dgram_allow(u32 cid, u32 port)
> +{
> +	struct vhost_vsock *vsock;
> +	bool dgram_allow = false;
> +
> +	rcu_read_lock();
> +	vsock = vhost_vsock_get(cid);
> +
> +	if (vsock)
> +		dgram_allow = vsock->dgram_allow;
> +
> +	rcu_read_unlock();
> +
> +	return dgram_allow;
> +}
> +
>  static bool vhost_transport_seqpacket_allow(u32 remote_cid)
>  {
>  	struct vhost_vsock *vsock;
> @@ -799,6 +852,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
>  	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
>  		vsock->seqpacket_allow = true;
>  
> +	if (features & (1ULL << VIRTIO_VSOCK_F_DGRAM))
> +		vsock->dgram_allow = true;
> +
>  	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
>  		vq = &vsock->vqs[i];
>  		mutex_lock(&vq->mutex);
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index e73f3b2c52f1..449ed63ac2b0 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -1427,9 +1427,12 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>  		return prot->recvmsg(sk, msg, len, flags, NULL);
>  #endif
>  
> -	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> +	if (unlikely(flags & MSG_OOB))
>  		return -EOPNOTSUPP;
>  
> +	if (unlikely(flags & MSG_ERRQUEUE))
> +		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, 0);
> +
>  	transport = vsk->transport;
>  
>  	/* Retrieve the head sk_buff from the socket's receive queue. */
> 
> -- 
> 2.30.2

