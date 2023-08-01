Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F046B76A7D6
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 06:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjHAE0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 00:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjHAE0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 00:26:04 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FD719AA;
        Mon, 31 Jul 2023 21:26:03 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6bc8d1878a0so2701589a34.1;
        Mon, 31 Jul 2023 21:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690863963; x=1691468763;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I8CHyoHhmN+q/J1PCONHwiM9HH+tWvIWVbUGrmR36Vc=;
        b=ED496ToEa0tMrJ8/56KSQ+ayTPU6QNLSXSaxyUYi22ExG3lvf4czG37oj7kco4RLDJ
         7z8D0Mep3f6ek2KTU237JswFMCQ+vApNC5OOIiQkJypErczK05TYkr3Nhfu/vdVH3iLo
         C0aYP+CtmjtmGFZDgN9JOS+lKhgy48nk7ae42pmLsv5zooWRcqzJij7A7DbEz0tdSlRE
         NMKvVABe8a/oXtzwxhIls0KO67y/PHXnreq8atJzugkxd9w/TmZTH/cBFfVv4nz5xbgZ
         sTq9Rr1pIFqoAhwppxCcsAWgm+qgG3A61ZtM/ZPUAi/fySJ9RY6+V3EU3L+TeBtK4qxA
         6+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690863963; x=1691468763;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I8CHyoHhmN+q/J1PCONHwiM9HH+tWvIWVbUGrmR36Vc=;
        b=Ktqt/6uwajqv+CIZrXdc9HJmwtaXrPlUP2WPhLoqEXCcuoQo/fjYpGvetVujTDLejx
         qtcZR7rMWEi53N4A8b5pbdP9W976f7HyeVrk/RAODZqK94gFNxrfZxR7wfhXAkAGIDuZ
         yFbdnXhf7YN/ubmolbcmoMjcm5mO8LNw1DWhWFU3DKOVdGp2RW6DDBNEz5/3rAe4Hpvt
         YP/V+Qmu+i5DvZrUeHihgYjXZlISfC+ocs8b7A6jT8p8adQlsxMl9BwsEiXN7OqmowkW
         7pkz9NyiLESfQFT8X4DqXn7idk17vOkgIIXD1lJY3rkx2jDn09rVd0NxJD0KXobiKvhS
         5dvA==
X-Gm-Message-State: ABy/qLYXlWddqzOEO0on/1NFcHmhcB9kWSBJX7ky6EfdFvbjNWSNEfc1
        vg9n5rJaYEOtTgj/MF1+m4s=
X-Google-Smtp-Source: APBJJlHc7oUPOaA/bFeYqHEJOO/eD37jmtZNqE4aCon6mJvbOF+9nouZMBnzIJiLQpohsXyRW3pZHw==
X-Received: by 2002:a05:6358:720d:b0:134:d026:42d2 with SMTP id h13-20020a056358720d00b00134d02642d2mr2307644rwa.24.1690863962624;
        Mon, 31 Jul 2023 21:26:02 -0700 (PDT)
Received: from localhost (c-67-166-91-86.hsd1.wa.comcast.net. [67.166.91.86])
        by smtp.gmail.com with ESMTPSA id m25-20020a637119000000b0056456fff676sm1944200pgc.66.2023.07.31.21.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 21:26:02 -0700 (PDT)
Date:   Tue, 1 Aug 2023 04:26:01 +0000
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
Message-ID: <ZMiJWV15cSG9qQx1@bullseye>
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

Yes, in the v4 thread we decided to try to mimic UDP/ICMP behavior when
IP packets are lost.

If an IP packet is dropped and the full UDP segment is not assembled,
then ICMP_TIME_EXCEEDED ICMP_EXC_FRAGTIME is sent. The sending stack
propagates this up the socket as EHOSTUNREACH. ENOBUFS/ENOMEM is already
used for local buffers, so EHOSTUNREACH distinctly points to the remote
end of the flow as well.

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
