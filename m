Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB40B76D7B4
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 21:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjHBT2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 15:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjHBT2b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 15:28:31 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B512D123;
        Wed,  2 Aug 2023 12:28:29 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-686efa1804eso110975b3a.3;
        Wed, 02 Aug 2023 12:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691004509; x=1691609309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RRy8M68oQc9X6bkkx6C0tx5oJgeAp1XL44cqtKOQ9YM=;
        b=P/n1Hwavlk7dIRxmjbdWknFVkgP/no5NrYBKpQB8kXDO6Rp+B961JuHUvjwUYKeuZe
         J5+VWcmhfdDEQvMAr1o7KasluX5pMSTsi+tcArkNePaBhTG6zKLXLw8YTzVaqNJXmAc/
         aE6/BiyzJXeo1cB9agV06nHOrICAZyGjz91J24nRGAyNkwtAQzx/NfKrjvcZpMn4rB9I
         lq4C+saXrgyvi2l51ub60VmGE34Wl6zvHSbSuRVg0n5E+fjK3L2kPhm4PLpRpwZSLgt0
         zsaxN/JpoTKMZirxR8g+qcBSzG5G4i/MPvKEw+lotPZ1D/UfWJFWeO8HasFYpIGzo/qA
         +Nzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691004509; x=1691609309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RRy8M68oQc9X6bkkx6C0tx5oJgeAp1XL44cqtKOQ9YM=;
        b=IC1TXg12XeU+TztkHaKHGZp15Wjhj1w+52nv2YKPdbp4O1zpveNA1oHSASq8yM363Q
         6yudHov2JR8w1GCnZs5NcQBC+WyATJdR7YCw6BAxAAvkbOwD1X2q6V8TKyynMJx2cc5f
         biv05gX/zOeKuOrLzFFbRiJRZMxvIUFcQotubbMFtM4gP1FhJHMRLk6YgPDQzBeXqm4l
         vIYctOmGQAqfGp97+u/Lmg0fGOy7EdyBCjNoZ8IDwDPo+39njx1tcVBoUvKXIF8ag7JH
         rsOx0NjhHfa5ceWtdm5IpBcMUnPj0cbW4E8lkcFQTf60VZtbPUFOgMu9U+q406yZCd6n
         iB5Q==
X-Gm-Message-State: ABy/qLYCcqaFsURRxWSa7TV190Z7BuQT2f/3OQnpbw1PE83qoZxCBd0V
        RCaEwctnAtlcWvRc+UdhAQE=
X-Google-Smtp-Source: APBJJlFcOt8XsDxMddgNHYI/97xi0AqQFqSkAwmzYD/6Xb/GI7pA7csj4Z0OL5bVwY/fT4kKcNLXYQ==
X-Received: by 2002:a05:6a00:1a13:b0:687:20d6:fae5 with SMTP id g19-20020a056a001a1300b0068720d6fae5mr15225374pfv.24.1691004508981;
        Wed, 02 Aug 2023 12:28:28 -0700 (PDT)
Received: from localhost (ec2-52-8-182-0.us-west-1.compute.amazonaws.com. [52.8.182.0])
        by smtp.gmail.com with ESMTPSA id s8-20020a639248000000b0055c090df2fasm11726494pgn.93.2023.08.02.12.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 12:28:28 -0700 (PDT)
Date:   Wed, 2 Aug 2023 19:28:27 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        linux-hyperv@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Simon Horman <simon.horman@corigine.com>,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Vishnu Dasa <vdasa@vmware.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next v5 11/14] vhost/vsock: implement datagram
 support
Message-ID: <ZMquW+6Rl6ZsYHad@bullseye>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-11-581bd37fdb26@bytedance.com>
 <20230726143850-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726143850-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 26, 2023 at 02:40:22PM -0400, Michael S. Tsirkin wrote:
> On Wed, Jul 19, 2023 at 12:50:15AM +0000, Bobby Eshleman wrote:
> > This commit implements datagram support for vhost/vsock by teaching
> > vhost to use the common virtio transport datagram functions.
> > 
> > If the virtio RX buffer is too small, then the transmission is
> > abandoned, the packet dropped, and EHOSTUNREACH is added to the socket's
> > error queue.
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> 
> EHOSTUNREACH?
> 
> 
> > ---
> >  drivers/vhost/vsock.c    | 62 +++++++++++++++++++++++++++++++++++++++++++++---
> >  net/vmw_vsock/af_vsock.c |  5 +++-
> >  2 files changed, 63 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index d5d6a3c3f273..da14260c6654 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -8,6 +8,7 @@
> >   */
> >  #include <linux/miscdevice.h>
> >  #include <linux/atomic.h>
> > +#include <linux/errqueue.h>
> >  #include <linux/module.h>
> >  #include <linux/mutex.h>
> >  #include <linux/vmalloc.h>
> > @@ -32,7 +33,8 @@
> >  enum {
> >  	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
> >  			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> > -			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
> > +			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
> > +			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
> >  };
> >  
> >  enum {
> > @@ -56,6 +58,7 @@ struct vhost_vsock {
> >  	atomic_t queued_replies;
> >  
> >  	u32 guest_cid;
> > +	bool dgram_allow;
> >  	bool seqpacket_allow;
> >  };
> >  
> > @@ -86,6 +89,32 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
> >  	return NULL;
> >  }
> >  
> > +/* Claims ownership of the skb, do not free the skb after calling! */
> > +static void
> > +vhost_transport_error(struct sk_buff *skb, int err)
> > +{
> > +	struct sock_exterr_skb *serr;
> > +	struct sock *sk = skb->sk;
> > +	struct sk_buff *clone;
> > +
> > +	serr = SKB_EXT_ERR(skb);
> > +	memset(serr, 0, sizeof(*serr));
> > +	serr->ee.ee_errno = err;
> > +	serr->ee.ee_origin = SO_EE_ORIGIN_NONE;
> > +
> > +	clone = skb_clone(skb, GFP_KERNEL);
> > +	if (!clone)
> > +		return;
> > +
> > +	if (sock_queue_err_skb(sk, clone))
> > +		kfree_skb(clone);
> > +
> > +	sk->sk_err = err;
> > +	sk_error_report(sk);
> > +
> > +	kfree_skb(skb);
> > +}
> > +
> >  static void
> >  vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >  			    struct vhost_virtqueue *vq)
> > @@ -160,9 +189,15 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >  		hdr = virtio_vsock_hdr(skb);
> >  
> >  		/* If the packet is greater than the space available in the
> > -		 * buffer, we split it using multiple buffers.
> > +		 * buffer, we split it using multiple buffers for connectible
> > +		 * sockets and drop the packet for datagram sockets.
> >  		 */
> 
> won't this break things like recently proposed zerocopy?
> I think splitup has to be supported for all types.
> 

Could you elaborate? Is there something about zerocopy that would
prohibit the transport from dropping a datagram?

> 
> >  		if (payload_len > iov_len - sizeof(*hdr)) {
> > +			if (le16_to_cpu(hdr->type) == VIRTIO_VSOCK_TYPE_DGRAM) {
> > +				vhost_transport_error(skb, EHOSTUNREACH);
> > +				continue;
> > +			}
> > +
> >  			payload_len = iov_len - sizeof(*hdr);
> >  
> >  			/* As we are copying pieces of large packet's buffer to
> > @@ -394,6 +429,7 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
> >  	return val < vq->num;
> >  }
> >  
> > +static bool vhost_transport_dgram_allow(u32 cid, u32 port);
> >  static bool vhost_transport_seqpacket_allow(u32 remote_cid);
> >  
> >  static struct virtio_transport vhost_transport = {
> > @@ -410,7 +446,8 @@ static struct virtio_transport vhost_transport = {
> >  		.cancel_pkt               = vhost_transport_cancel_pkt,
> >  
> >  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> > -		.dgram_allow              = virtio_transport_dgram_allow,
> > +		.dgram_allow              = vhost_transport_dgram_allow,
> > +		.dgram_addr_init          = virtio_transport_dgram_addr_init,
> >  
> >  		.stream_enqueue           = virtio_transport_stream_enqueue,
> >  		.stream_dequeue           = virtio_transport_stream_dequeue,
> > @@ -443,6 +480,22 @@ static struct virtio_transport vhost_transport = {
> >  	.send_pkt = vhost_transport_send_pkt,
> >  };
> >  
> > +static bool vhost_transport_dgram_allow(u32 cid, u32 port)
> > +{
> > +	struct vhost_vsock *vsock;
> > +	bool dgram_allow = false;
> > +
> > +	rcu_read_lock();
> > +	vsock = vhost_vsock_get(cid);
> > +
> > +	if (vsock)
> > +		dgram_allow = vsock->dgram_allow;
> > +
> > +	rcu_read_unlock();
> > +
> > +	return dgram_allow;
> > +}
> > +
> >  static bool vhost_transport_seqpacket_allow(u32 remote_cid)
> >  {
> >  	struct vhost_vsock *vsock;
> > @@ -799,6 +852,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
> >  	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
> >  		vsock->seqpacket_allow = true;
> >  
> > +	if (features & (1ULL << VIRTIO_VSOCK_F_DGRAM))
> > +		vsock->dgram_allow = true;
> > +
> >  	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
> >  		vq = &vsock->vqs[i];
> >  		mutex_lock(&vq->mutex);
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index e73f3b2c52f1..449ed63ac2b0 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -1427,9 +1427,12 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> >  		return prot->recvmsg(sk, msg, len, flags, NULL);
> >  #endif
> >  
> > -	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> > +	if (unlikely(flags & MSG_OOB))
> >  		return -EOPNOTSUPP;
> >  
> > +	if (unlikely(flags & MSG_ERRQUEUE))
> > +		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, 0);
> > +
> >  	transport = vsk->transport;
> >  
> >  	/* Retrieve the head sk_buff from the socket's receive queue. */
> > 
> > -- 
> > 2.30.2
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
