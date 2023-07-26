Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1748C763DF5
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 19:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjGZRzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 13:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjGZRzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 13:55:11 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCEE268B;
        Wed, 26 Jul 2023 10:55:07 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1bb7b8390e8so210995ad.2;
        Wed, 26 Jul 2023 10:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690394106; x=1690998906;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GuaoxLq3ek5fXAM+0CB3nqB/uwC00m1vaFSxsUcMVrA=;
        b=k5wUBeagCyB+tisPnHfea0oLFzJzrIsN/FOrt+w3xKjd2n9yBaPYjKI5ITCxQ+R5Il
         6W0/6jSvv4W/yKfm0v2Zwx6XOx4UJ/x+/r+OaxpZLKZBMnRawh+sNxjuZw7CWK93Vnkh
         son9wP3r97LJGhaXrpDNTQs4baB1yIFMv6A0MFl4VwVdLYOrJ011DuOPlwp0euqX+MMr
         so3++eV1HpcJ/hjGgjIMhwgtB+Ql73I9u0w1KYz3dtwYp2YC26YSxckFRCG3M5xnlDZs
         V1Dh2fDqFJlWkFsdYWprGXx6NVflu6v0A2uwIjupLyFAgvV1LtiU5Dm7+aYxg18e2GLz
         56ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690394106; x=1690998906;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GuaoxLq3ek5fXAM+0CB3nqB/uwC00m1vaFSxsUcMVrA=;
        b=BdTTOF1shF/cMQRh2QdJKorSGuUWkO9mi5UAoPpVLiSH1SpDs0dy4fqsVBv0GXqjuH
         6i8Rm7K/H0D7r9CrRyB9SD72whOzSO5XMTDfuv3T9vaiJTDxB9zENbJah9TaLVAd05sA
         nZcUL1vYZFdz3ws3y5R1YVDTwWou0KzZW0z2zuMquei+q+0LYSzHs5ry9dSG7oEmHRwY
         9nYrUpl/wgq7ttvV2XAODF8S8P878GzfksBWDWjwnO6HnxKYFm0caE3XbEtiY/YuH796
         G2+NSDvBY7PakZcVXYomHzxe4OmuU+dx78tNk6Us8anIYKmWcGcM6bAKmHF8scRs+3u6
         EAag==
X-Gm-Message-State: ABy/qLarYzca50VclmwocJw4yAhlKIILyCFAXVB9vpcoF/oAc6YWnLTM
        n5j3MogHGjPdfy7YBiMbhWA=
X-Google-Smtp-Source: APBJJlF8DNCyu4FofHR7yeGQzZW2ImdQNj+5n6rZ8QUWU69sp6IDmdDiAWnGqXowrLfCzWROfpl28w==
X-Received: by 2002:a17:902:a415:b0:1b9:ea60:cd8a with SMTP id p21-20020a170902a41500b001b9ea60cd8amr2103365plq.50.1690394106141;
        Wed, 26 Jul 2023 10:55:06 -0700 (PDT)
Received: from localhost (c-73-190-126-111.hsd1.wa.comcast.net. [73.190.126.111])
        by smtp.gmail.com with ESMTPSA id o10-20020a170902bcca00b001b850c9af71sm13413891pls.285.2023.07.26.10.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 10:55:05 -0700 (PDT)
Date:   Wed, 26 Jul 2023 17:55:04 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Arseniy Krasnov <oxffffaa@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        Simon Horman <simon.horman@corigine.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC net-next v5 11/14] vhost/vsock: implement datagram
 support
Message-ID: <ZMFd+Jd/LrfpJsVA@bullseye>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-11-581bd37fdb26@bytedance.com>
 <b15d237e-31b5-40ae-83fc-e71649febd2b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b15d237e-31b5-40ae-83fc-e71649febd2b@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 22, 2023 at 11:42:38AM +0300, Arseniy Krasnov wrote:
> 
> 
> On 19.07.2023 03:50, Bobby Eshleman wrote:
> > This commit implements datagram support for vhost/vsock by teaching
> > vhost to use the common virtio transport datagram functions.
> > 
> > If the virtio RX buffer is too small, then the transmission is
> > abandoned, the packet dropped, and EHOSTUNREACH is added to the socket's
> > error queue.
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
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
> 
> May for skb which is error carrier we can use 'sock_omalloc()', not 'skb_clone()' ? TCP uses skb
> allocated by this function as carriers of error structure. I guess 'skb_clone()' also clones data of origin,
> but i think that there is no need in data as we insert it to error queue of the socket.
> 
> What do You think?

IIUC skb_clone() is often used in this scenario so that the user can
retrieve the error-causing packet from the error queue.  Is there some
reason we shouldn't do this?

I'm seeing that the serr bits need to occur on the clone here, not the
original. I didn't realize the SKB_EXT_ERR() is a skb->cb cast. I'm not
actually sure how this passes the test case since ->cb isn't cloned.

> 
> > +	if (!clone)
> > +		return;
> 
> What will happen here 'if (!clone)' ? skb will leak as it was removed from queue?
> 

Ah yes, true.

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
> 
> Sorry, but I get build error here, because SOL_VSOCK in undefined. I think it should be added to
> include/linux/socket.h and to uapi files also for future use in userspace.
> 

Strange, I built each patch individually without issue. My base is
netdev/main with your SOL_VSOCK patch applied. I will look today and see
if I'm missing something.

> Also Stefano Garzarella <sgarzare@redhat.com> suggested to add define something like VSOCK_RECVERR,
> in the same way as IP_RECVERR, and use it as last parameter of 'sock_recv_errqueue()'.
> 

Got it, thanks.

> >  	transport = vsk->transport;
> >  
> >  	/* Retrieve the head sk_buff from the socket's receive queue. */
> > 
> 
> Thanks, Arseniy

Thanks,
Bobby
