Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF59E76D85F
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 22:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbjHBUIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 16:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjHBUII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 16:08:08 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B231FE75;
        Wed,  2 Aug 2023 13:08:07 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-686f090310dso186113b3a.0;
        Wed, 02 Aug 2023 13:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691006887; x=1691611687;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SoiSVFle35PHH4Ar+j9kY1q+BPkG30s6HFcqkpgLJrQ=;
        b=X9PxMaqcHW05NBpDiEvFOJq8lm4SBtE/SeeblPmLaAl8tJ3K0sqqyDl3IfQJXIPfBE
         Ny2fzdJHL3ApT4YbGNPEhSuwgSSCraeI8/wAC1WfahLdoJ4C4vdaw8nfac2ZtRLU+Zay
         5vUIM6LZRW6lGj8mIol6LtD0K4MQa8mlOBH2Am6AeX+t0GvJWoWptvOWYaw0Wq7VXtnq
         ncy8F6S7fGL1fmwaP0EI7h9gzd5MxpTXril5GdjkRvJBZqZzqn50G0x3Y3rfOXGxrceK
         f8A03V5grugmvP6m2ssIrBLphm7wHS7hU3+71zK3WzS+Bngg/c7AJZGIvRbotbxrikCn
         u5GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691006887; x=1691611687;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SoiSVFle35PHH4Ar+j9kY1q+BPkG30s6HFcqkpgLJrQ=;
        b=UkZacEmwpcrvYlCACuM4I0XUQR7W5dkazvN0oWqcyAwrZAtJsHa/yuzu1RVYh/plQm
         L4z3sM79xoQll63PChR81ROybYyfIg2b/qRIIEqB0Cy4nu5raBIvAqkXN4UGkBueoBCQ
         UE1AUprE3RZgp//qeeReriDuMRKvALbd/0VFRe2RXtaLU4+j5YoDl0Gb4CN8DZzgS+hO
         NcERbi0FrB67jUqQiqxLIE9V9zFXk1ivg0gBdlkhvGEOTpMqvprMZMYKQFrMD4ObNnxV
         JfCth5XlS2DQtFG0X8Bk76q+GvvSLNEeGKqlUlvA5DdPdqaK7cBL6B/VrcYRu9bQooIU
         o8kw==
X-Gm-Message-State: ABy/qLZ874cK/RiBgrLzjNECanVncMYlhJ53X9IRpQKUpqqHUo1rnisJ
        E7UvzOX0FTeDKb0b0uE0nMuaCy5EIETVwwG6
X-Google-Smtp-Source: APBJJlG6XpkR/wQYuCuBbZ813l8yHEgwi2zGXT2bsP9TJYNxBN55lZECKLHAkB8q+yNDfor1z7iLXA==
X-Received: by 2002:a05:6a00:2291:b0:687:404f:4d60 with SMTP id f17-20020a056a00229100b00687404f4d60mr11368765pfe.32.1691006886983;
        Wed, 02 Aug 2023 13:08:06 -0700 (PDT)
Received: from localhost (ec2-52-8-182-0.us-west-1.compute.amazonaws.com. [52.8.182.0])
        by smtp.gmail.com with ESMTPSA id j8-20020aa78d08000000b006828e49c04csm11452759pfe.75.2023.08.02.13.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 13:08:06 -0700 (PDT)
Date:   Wed, 2 Aug 2023 20:08:03 +0000
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
Subject: Re: [PATCH RFC net-next v5 07/14] virtio/vsock: add common datagram
 send path
Message-ID: <ZMq3o03JO9LnwhlD@bullseye>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-7-581bd37fdb26@bytedance.com>
 <051e4091-556c-4592-4a72-4dacf0015da8@gmail.com>
 <ZMFS+MlAPTso6wjQ@bullseye>
 <dbf36361-8b94-e2e3-8478-c643bab54e43@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbf36361-8b94-e2e3-8478-c643bab54e43@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023 at 10:57:05AM +0300, Arseniy Krasnov wrote:
> 
> 
> On 26.07.2023 20:08, Bobby Eshleman wrote:
> > On Sat, Jul 22, 2023 at 11:16:05AM +0300, Arseniy Krasnov wrote:
> >>
> >>
> >> On 19.07.2023 03:50, Bobby Eshleman wrote:
> >>> This commit implements the common function
> >>> virtio_transport_dgram_enqueue for enqueueing datagrams. It does not add
> >>> usage in either vhost or virtio yet.
> >>>
> >>> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >>> ---
> >>>  net/vmw_vsock/virtio_transport_common.c | 76 ++++++++++++++++++++++++++++++++-
> >>>  1 file changed, 75 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> >>> index ffcbdd77feaa..3bfaff758433 100644
> >>> --- a/net/vmw_vsock/virtio_transport_common.c
> >>> +++ b/net/vmw_vsock/virtio_transport_common.c
> >>> @@ -819,7 +819,81 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
> >>>  			       struct msghdr *msg,
> >>>  			       size_t dgram_len)
> >>>  {
> >>> -	return -EOPNOTSUPP;
> >>> +	/* Here we are only using the info struct to retain style uniformity
> >>> +	 * and to ease future refactoring and merging.
> >>> +	 */
> >>> +	struct virtio_vsock_pkt_info info_stack = {
> >>> +		.op = VIRTIO_VSOCK_OP_RW,
> >>> +		.msg = msg,
> >>> +		.vsk = vsk,
> >>> +		.type = VIRTIO_VSOCK_TYPE_DGRAM,
> >>> +	};
> >>> +	const struct virtio_transport *t_ops;
> >>> +	struct virtio_vsock_pkt_info *info;
> >>> +	struct sock *sk = sk_vsock(vsk);
> >>> +	struct virtio_vsock_hdr *hdr;
> >>> +	u32 src_cid, src_port;
> >>> +	struct sk_buff *skb;
> >>> +	void *payload;
> >>> +	int noblock;
> >>> +	int err;
> >>> +
> >>> +	info = &info_stack;
> >>
> >> I think 'info' assignment could be moved below, to the place where it is used
> >> first time.
> >>
> >>> +
> >>> +	if (dgram_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
> >>> +		return -EMSGSIZE;
> >>> +
> >>> +	t_ops = virtio_transport_get_ops(vsk);
> >>> +	if (unlikely(!t_ops))
> >>> +		return -EFAULT;
> >>> +
> >>> +	/* Unlike some of our other sending functions, this function is not
> >>> +	 * intended for use without a msghdr.
> >>> +	 */
> >>> +	if (WARN_ONCE(!msg, "vsock dgram bug: no msghdr found for dgram enqueue\n"))
> >>> +		return -EFAULT;
> >>
> >> Sorry, but is that possible? I thought 'msg' is always provided by general socket layer (e.g. before
> >> af_vsock.c code) and can't be NULL for DGRAM. Please correct me if i'm wrong.
> >>
> >> Also I see, that in af_vsock.c , 'vsock_dgram_sendmsg()' dereferences 'msg' for checking MSG_OOB without any
> >> checks (before calling transport callback - this function in case of virtio). So I think if we want to keep
> >> this type of check - such check must be placed in af_vsock.c or somewhere before first dereference of this pointer.
> >>
> > 
> > There is some talk about dgram sockets adding additional messages types
> > in the future that help with congestion control. Those messages won't
> > come from the socket layer, so msghdr will be null. Since there is no
> > other function for sending datagrams, it seemed likely that this
> > function would be reworked for that purpose. I felt that adding this
> > check was a direct way to make it explicit that this function is
> > currently designed only for the socket-layer caller.
> > 
> > Perhaps a comment would suffice?
> 
> I see, thanks, it is for future usage. Sorry for dumb question: but if msg is NULL, how
> we will decide what to do in this call? Interface of this callback will be updated or
> some fields of 'vsock_sock' will contain type of such messages ?
> 
> Thanks, Arseniy
> 

Hey Arseniy, sorry about the delay I forgot about this chunk of the
thread.

This warning was intended to help by calling attention to the fact that
even though this function is the only way to send dgram packets, unlike
the connectible sending function virtio_transport_send_pkt_info() this
actually requires a non-NULL msg... it seems like it doesn't help and
just causes more confusion than anything. It is a wasted cycle on the
fastpath too, so I think I'll just drop it in the next rev.

> > 
> >>> +
> >>> +	noblock = msg->msg_flags & MSG_DONTWAIT;
> >>> +
> >>> +	/* Use sock_alloc_send_skb to throttle by sk_sndbuf. This helps avoid
> >>> +	 * triggering the OOM.
> >>> +	 */
> >>> +	skb = sock_alloc_send_skb(sk, dgram_len + VIRTIO_VSOCK_SKB_HEADROOM,
> >>> +				  noblock, &err);
> >>> +	if (!skb)
> >>> +		return err;
> >>> +
> >>> +	skb_reserve(skb, VIRTIO_VSOCK_SKB_HEADROOM);
> >>> +
> >>> +	src_cid = t_ops->transport.get_local_cid();
> >>> +	src_port = vsk->local_addr.svm_port;
> >>> +
> >>> +	hdr = virtio_vsock_hdr(skb);
> >>> +	hdr->type	= cpu_to_le16(info->type);
> >>> +	hdr->op		= cpu_to_le16(info->op);
> >>> +	hdr->src_cid	= cpu_to_le64(src_cid);
> >>> +	hdr->dst_cid	= cpu_to_le64(remote_addr->svm_cid);
> >>> +	hdr->src_port	= cpu_to_le32(src_port);
> >>> +	hdr->dst_port	= cpu_to_le32(remote_addr->svm_port);
> >>> +	hdr->flags	= cpu_to_le32(info->flags);
> >>> +	hdr->len	= cpu_to_le32(dgram_len);
> >>> +
> >>> +	skb_set_owner_w(skb, sk);
> >>> +
> >>> +	payload = skb_put(skb, dgram_len);
> >>> +	err = memcpy_from_msg(payload, msg, dgram_len);
> >>> +	if (err)
> >>> +		return err;
> >>
> >> Do we need free allocated skb here ?
> >>
> > 
> > Yep, thanks.
> > 
> >>> +
> >>> +	trace_virtio_transport_alloc_pkt(src_cid, src_port,
> >>> +					 remote_addr->svm_cid,
> >>> +					 remote_addr->svm_port,
> >>> +					 dgram_len,
> >>> +					 info->type,
> >>> +					 info->op,
> >>> +					 0);
> >>> +
> >>> +	return t_ops->send_pkt(skb);
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
> >>>  
> >>>
> >>
> >> Thanks, Arseniy
> > 
> > Thanks for the review!
> > 
> > Best,
> > Bobby
