Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDFB73AD43
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjFVXhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbjFVXhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:37:52 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591C12123;
        Thu, 22 Jun 2023 16:37:44 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6685421cdb3so872059b3a.1;
        Thu, 22 Jun 2023 16:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687477063; x=1690069063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KHBwGkPt1yaNFdPLCBGzN9v1mhncMO23j/+SMV/ByKI=;
        b=qHjLa3duPl9+zFd9KF/zkHBNGZ9fB3Os35yqrhTk37V8BUFo5scYDWLHMtsyeFcyhF
         6qQ+/VEmoPJNWpsl3m5azksoCyh7+vjtxqU2KIwSz2QOLIgAUiRe4eqyxG7qT8DrFOX2
         vHhrfDrd45LtyEmpKarF1AWhUYnuS8BojPwqb2Kw1DvFD0aL9v+WChoAhaHd7BkdUq9E
         MntSkrx12XwEZlwNZI1qig1QwjNctvLmM/yUkYKLZouynxvHFd/rFxzjtncuUU6f8lfR
         KZMWCaffhZwVxmXRiY6OKn4EUuT33OWnIovI8Im/jTXX5YN4S/bCkw/UFtonwswY1I3Y
         11eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687477063; x=1690069063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KHBwGkPt1yaNFdPLCBGzN9v1mhncMO23j/+SMV/ByKI=;
        b=CVhT/c4+AhXnBlRuRSC1aHQsmUWVQPN2i7inIONaBvEj+tLI6BaqSZulCAtKJRC/oD
         /dq2PQZDz18Pa9z3bwg3bZx8E110D5VW+9sZ9vWImKpvpVHtjFjIyoDzmsd0Z/uSg5gO
         t33NeBERqKOR8VgDFsMYtL6Tn7eogV2vKFwsVaqv1n9bEY9CO2ee+uOHQUQl2zLNrYCW
         xyveHUnpZRR8SRI+yz6OyH/Ia0JjxQcBl+/AdBi1WoT+1Bhuo+BWXhN0Jxbg3FeLCtPv
         TksxVBDEoguWjSlmOMw0sAMAAswq07lSgnjVb8dWo+SeENT4lO/3gmHchbGtKeGOF2/U
         CEPA==
X-Gm-Message-State: AC+VfDxm31cR32z6BgFWhrfNyU7j12UYdc7Vc95ERqs5p2vXc0napHLr
        jUD4nBwA3ZuoUOay6r8vOP8=
X-Google-Smtp-Source: ACHHUZ6eIkE7Qk6z/lDy55xJJu/Cr1OzjdXOBN4L+jIP1wQWEJnKqusFPvoIKaCvsz3WXePDh2g/yQ==
X-Received: by 2002:a05:6a20:6a25:b0:122:fce4:db08 with SMTP id p37-20020a056a206a2500b00122fce4db08mr10784803pzk.26.1687477063301;
        Thu, 22 Jun 2023 16:37:43 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id b23-20020a6567d7000000b0055380e4703csm4878161pgs.31.2023.06.22.16.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 16:37:42 -0700 (PDT)
Date:   Thu, 22 Jun 2023 23:37:42 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Arseniy Krasnov <oxffffaa@gmail.com>, linux-hyperv@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
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
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vishnu Dasa <vdasa@vmware.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next v4 1/8] vsock/dgram: generalize recvmsg and
 drop transport->dgram_dequeue
Message-ID: <ZJTbRsU5kQfLEV9c@bullseye>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-1-0cebbb2ae899@bytedance.com>
 <3eb6216b-a3d2-e1ef-270c-8a0032a4a8a5@gmail.com>
 <63ko2n5fwjdefot6rzcxdftfh6pilg6vmqn66v4ue5dgf4oz53@tntmdijw4ghr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63ko2n5fwjdefot6rzcxdftfh6pilg6vmqn66v4ue5dgf4oz53@tntmdijw4ghr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 04:51:41PM +0200, Stefano Garzarella wrote:
> On Sun, Jun 11, 2023 at 11:43:15PM +0300, Arseniy Krasnov wrote:
> > Hello Bobby! Thanks for this patchset! Small comment below:
> > 
> > On 10.06.2023 03:58, Bobby Eshleman wrote:
> > > This commit drops the transport->dgram_dequeue callback and makes
> > > vsock_dgram_recvmsg() generic. It also adds additional transport
> > > callbacks for use by the generic vsock_dgram_recvmsg(), such as for
> > > parsing skbs for CID/port which vary in format per transport.
> > > 
> > > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > > ---
> > >  drivers/vhost/vsock.c                   |  4 +-
> > >  include/linux/virtio_vsock.h            |  3 ++
> > >  include/net/af_vsock.h                  | 13 ++++++-
> > >  net/vmw_vsock/af_vsock.c                | 51 ++++++++++++++++++++++++-
> > >  net/vmw_vsock/hyperv_transport.c        | 17 +++++++--
> > >  net/vmw_vsock/virtio_transport.c        |  4 +-
> > >  net/vmw_vsock/virtio_transport_common.c | 18 +++++++++
> > >  net/vmw_vsock/vmci_transport.c          | 68 +++++++++++++--------------------
> > >  net/vmw_vsock/vsock_loopback.c          |  4 +-
> > >  9 files changed, 132 insertions(+), 50 deletions(-)
> > > 
> > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > index 6578db78f0ae..c8201c070b4b 100644
> > > --- a/drivers/vhost/vsock.c
> > > +++ b/drivers/vhost/vsock.c
> > > @@ -410,9 +410,11 @@ static struct virtio_transport vhost_transport = {
> > >  		.cancel_pkt               = vhost_transport_cancel_pkt,
> > > 
> > >  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> > > -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
> > >  		.dgram_bind               = virtio_transport_dgram_bind,
> > >  		.dgram_allow              = virtio_transport_dgram_allow,
> > > +		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
> > > +		.dgram_get_port		  = virtio_transport_dgram_get_port,
> > > +		.dgram_get_length	  = virtio_transport_dgram_get_length,
> > > 
> > >  		.stream_enqueue           = virtio_transport_stream_enqueue,
> > >  		.stream_dequeue           = virtio_transport_stream_dequeue,
> > > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > > index c58453699ee9..23521a318cf0 100644
> > > --- a/include/linux/virtio_vsock.h
> > > +++ b/include/linux/virtio_vsock.h
> > > @@ -219,6 +219,9 @@ bool virtio_transport_stream_allow(u32 cid, u32 port);
> > >  int virtio_transport_dgram_bind(struct vsock_sock *vsk,
> > >  				struct sockaddr_vm *addr);
> > >  bool virtio_transport_dgram_allow(u32 cid, u32 port);
> > > +int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid);
> > > +int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port);
> > > +int virtio_transport_dgram_get_length(struct sk_buff *skb, size_t *len);
> > > 
> > >  int virtio_transport_connect(struct vsock_sock *vsk);
> > > 
> > > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > > index 0e7504a42925..7bedb9ee7e3e 100644
> > > --- a/include/net/af_vsock.h
> > > +++ b/include/net/af_vsock.h
> > > @@ -120,11 +120,20 @@ struct vsock_transport {
> > > 
> > >  	/* DGRAM. */
> > >  	int (*dgram_bind)(struct vsock_sock *, struct sockaddr_vm *);
> > > -	int (*dgram_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
> > > -			     size_t len, int flags);
> > >  	int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
> > >  			     struct msghdr *, size_t len);
> > >  	bool (*dgram_allow)(u32 cid, u32 port);
> > > +	int (*dgram_get_cid)(struct sk_buff *skb, unsigned int *cid);
> > > +	int (*dgram_get_port)(struct sk_buff *skb, unsigned int *port);
> > > +	int (*dgram_get_length)(struct sk_buff *skb, size_t *length);
> > > +
> > > +	/* The number of bytes into the buffer at which the payload starts, as
> > > +	 * first seen by the receiving socket layer. For example, if the
> > > +	 * transport presets the skb pointers using skb_pull(sizeof(header))
> > > +	 * than this would be zero, otherwise it would be the size of the
> > > +	 * header.
> > > +	 */
> > > +	const size_t dgram_payload_offset;
> > > 
> > >  	/* STREAM. */
> > >  	/* TODO: stream_bind() */
> > > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > > index efb8a0937a13..ffb4dd8b6ea7 100644
> > > --- a/net/vmw_vsock/af_vsock.c
> > > +++ b/net/vmw_vsock/af_vsock.c
> > > @@ -1271,11 +1271,15 @@ static int vsock_dgram_connect(struct socket *sock,
> > >  int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> > >  			size_t len, int flags)
> > >  {
> > > +	const struct vsock_transport *transport;
> > >  #ifdef CONFIG_BPF_SYSCALL
> > >  	const struct proto *prot;
> > >  #endif
> > >  	struct vsock_sock *vsk;
> > > +	struct sk_buff *skb;
> > > +	size_t payload_len;
> > >  	struct sock *sk;
> > > +	int err;
> > > 
> > >  	sk = sock->sk;
> > >  	vsk = vsock_sk(sk);
> > > @@ -1286,7 +1290,52 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> > >  		return prot->recvmsg(sk, msg, len, flags, NULL);
> > >  #endif
> > > 
> > > -	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
> > > +	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	transport = vsk->transport;
> > > +
> > > +	/* Retrieve the head sk_buff from the socket's receive queue. */
> > > +	err = 0;
> > > +	skb = skb_recv_datagram(sk_vsock(vsk), flags, &err);
> > > +	if (!skb)
> > > +		return err;
> > > +
> > > +	err = transport->dgram_get_length(skb, &payload_len);
> 
> What about ssize_t return value here?
> 
> Or maybe a single callback that return both length and offset?
> 
> .dgram_get_payload_info(skb, &payload_len, &payload_off)
> 

What are your thoughts on Arseniy's idea of using skb->len and adding a
skb_pull() just before vmci adds the skb to the sk receive queue?

> > > +	if (err)
> > > +		goto out;
> > > +
> > > +	if (payload_len > len) {
> > > +		payload_len = len;
> > > +		msg->msg_flags |= MSG_TRUNC;
> > > +	}
> > > +
> > > +	/* Place the datagram payload in the user's iovec. */
> > > +	err = skb_copy_datagram_msg(skb, transport->dgram_payload_offset, msg, payload_len);
> > > +	if (err)
> > > +		goto out;
> > > +
> > > +	if (msg->msg_name) {
> > > +		/* Provide the address of the sender. */
> > > +		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> > > +		unsigned int cid, port;
> > > +
> > > +		err = transport->dgram_get_cid(skb, &cid);
> > > +		if (err)
> > > +			goto out;
> > > +
> > > +		err = transport->dgram_get_port(skb, &port);
> > > +		if (err)
> > > +			goto out;
> > 
> > Maybe we can merge 'dgram_get_cid' and 'dgram_get_port' to a single callback? Because I see that this is
> > the only place where both are used (correct me if i'm wrong) and logically both operates with addresses:
> > CID and port. E.g. something like that: dgram_get_cid_n_port().
> 
> What about .dgram_addr_init(struct sk_buff *skb, struct sockaddr_vm *addr)
> and the transport can set cid and port?
> 

LGTM!

> > 
> > Moreover, I'm not sure, but is it good "tradeoff" here: remove transport specific callback for dgram receive
> > where we already have 'msghdr' with both data buffer and buffer for 'sockaddr_vm' and instead of it add new
> > several fields (callbacks) to transports like dgram_get_cid(), dgram_get_port()? I agree, that in each transport
> > specific callback we will have same copying logic by calling 'skb_copy_datagram_msg()' and filling address
> > by using 'vsock_addr_init()', but in this case we don't need to update transports too much. For example HyperV
> > still unchanged as it does not support SOCK_DGRAM. For VMCI You just need to add 'vsock_addr_init()' logic
> > to it's dgram dequeue callback.
> > 
> > What do You think?
> 
> Honestly, I'd rather avoid duplicate code than reduce changes in
> transports that don't support dgram.
> 
> One thing I do agree on though is minimizing the number of callbacks
> to call to reduce the number of indirection (more performance?).
> 
> Thanks,
> Stefano
> 

Thanks!

Best,
Bobby

> > 
> > Thanks, Arseniy
> > 
> > > +
> > > +		vsock_addr_init(vm_addr, cid, port);
> > > +		msg->msg_namelen = sizeof(*vm_addr);
> > > +	}
> > > +	err = payload_len;
> > > +
> > > +out:
> > > +	skb_free_datagram(&vsk->sk, skb);
> > > +	return err;
> > >  }
> > >  EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
> > > 
> > > diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
> > > index 7cb1a9d2cdb4..ff6e87e25fa0 100644
> > > --- a/net/vmw_vsock/hyperv_transport.c
> > > +++ b/net/vmw_vsock/hyperv_transport.c
> > > @@ -556,8 +556,17 @@ static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)
> > >  	return -EOPNOTSUPP;
> > >  }
> > > 
> > > -static int hvs_dgram_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
> > > -			     size_t len, int flags)
> > > +static int hvs_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
> > > +{
> > > +	return -EOPNOTSUPP;
> > > +}
> > > +
> > > +static int hvs_dgram_get_port(struct sk_buff *skb, unsigned int *port)
> > > +{
> > > +	return -EOPNOTSUPP;
> > > +}
> > > +
> > > +static int hvs_dgram_get_length(struct sk_buff *skb, size_t *len)
> > >  {
> > >  	return -EOPNOTSUPP;
> > >  }
> > > @@ -833,7 +842,9 @@ static struct vsock_transport hvs_transport = {
> > >  	.shutdown                 = hvs_shutdown,
> > > 
> > >  	.dgram_bind               = hvs_dgram_bind,
> > > -	.dgram_dequeue            = hvs_dgram_dequeue,
> > > +	.dgram_get_cid		  = hvs_dgram_get_cid,
> > > +	.dgram_get_port		  = hvs_dgram_get_port,
> > > +	.dgram_get_length	  = hvs_dgram_get_length,
> > >  	.dgram_enqueue            = hvs_dgram_enqueue,
> > >  	.dgram_allow              = hvs_dgram_allow,
> > > 
> > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > > index e95df847176b..5763cdf13804 100644
> > > --- a/net/vmw_vsock/virtio_transport.c
> > > +++ b/net/vmw_vsock/virtio_transport.c
> > > @@ -429,9 +429,11 @@ static struct virtio_transport virtio_transport = {
> > >  		.cancel_pkt               = virtio_transport_cancel_pkt,
> > > 
> > >  		.dgram_bind               = virtio_transport_dgram_bind,
> > > -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
> > >  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> > >  		.dgram_allow              = virtio_transport_dgram_allow,
> > > +		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
> > > +		.dgram_get_port		  = virtio_transport_dgram_get_port,
> > > +		.dgram_get_length	  = virtio_transport_dgram_get_length,
> > > 
> > >  		.stream_dequeue           = virtio_transport_stream_dequeue,
> > >  		.stream_enqueue           = virtio_transport_stream_enqueue,
> > > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > > index b769fc258931..e6903c719964 100644
> > > --- a/net/vmw_vsock/virtio_transport_common.c
> > > +++ b/net/vmw_vsock/virtio_transport_common.c
> > > @@ -797,6 +797,24 @@ int virtio_transport_dgram_bind(struct vsock_sock *vsk,
> > >  }
> > >  EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
> > > 
> > > +int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
> > > +{
> > > +	return -EOPNOTSUPP;
> > > +}
> > > +EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_cid);
> > > +
> > > +int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
> > > +{
> > > +	return -EOPNOTSUPP;
> > > +}
> > > +EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_port);
> > > +
> > > +int virtio_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
> > > +{
> > > +	return -EOPNOTSUPP;
> > > +}
> > > +EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_length);
> > > +
> > >  bool virtio_transport_dgram_allow(u32 cid, u32 port)
> > >  {
> > >  	return false;
> > > diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> > > index b370070194fa..bbc63826bf48 100644
> > > --- a/net/vmw_vsock/vmci_transport.c
> > > +++ b/net/vmw_vsock/vmci_transport.c
> > > @@ -1731,57 +1731,40 @@ static int vmci_transport_dgram_enqueue(
> > >  	return err - sizeof(*dg);
> > >  }
> > > 
> > > -static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
> > > -					struct msghdr *msg, size_t len,
> > > -					int flags)
> > > +static int vmci_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
> > >  {
> > > -	int err;
> > >  	struct vmci_datagram *dg;
> > > -	size_t payload_len;
> > > -	struct sk_buff *skb;
> > > 
> > > -	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> > > -		return -EOPNOTSUPP;
> > > +	dg = (struct vmci_datagram *)skb->data;
> > > +	if (!dg)
> > > +		return -EINVAL;
> > > 
> > > -	/* Retrieve the head sk_buff from the socket's receive queue. */
> > > -	err = 0;
> > > -	skb = skb_recv_datagram(&vsk->sk, flags, &err);
> > > -	if (!skb)
> > > -		return err;
> > > +	*cid = dg->src.context;
> > > +	return 0;
> > > +}
> > > +
> > > +static int vmci_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
> > > +{
> > > +	struct vmci_datagram *dg;
> > > 
> > >  	dg = (struct vmci_datagram *)skb->data;
> > >  	if (!dg)
> > > -		/* err is 0, meaning we read zero bytes. */
> > > -		goto out;
> > > -
> > > -	payload_len = dg->payload_size;
> > > -	/* Ensure the sk_buff matches the payload size claimed in the packet. */
> > > -	if (payload_len != skb->len - sizeof(*dg)) {
> > > -		err = -EINVAL;
> > > -		goto out;
> > > -	}
> > > +		return -EINVAL;
> > > 
> > > -	if (payload_len > len) {
> > > -		payload_len = len;
> > > -		msg->msg_flags |= MSG_TRUNC;
> > > -	}
> > > +	*port = dg->src.resource;
> > > +	return 0;
> > > +}
> > > 
> > > -	/* Place the datagram payload in the user's iovec. */
> > > -	err = skb_copy_datagram_msg(skb, sizeof(*dg), msg, payload_len);
> > > -	if (err)
> > > -		goto out;
> > > +static int vmci_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
> > > +{
> > > +	struct vmci_datagram *dg;
> > > 
> > > -	if (msg->msg_name) {
> > > -		/* Provide the address of the sender. */
> > > -		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> > > -		vsock_addr_init(vm_addr, dg->src.context, dg->src.resource);
> > > -		msg->msg_namelen = sizeof(*vm_addr);
> > > -	}
> > > -	err = payload_len;
> > > +	dg = (struct vmci_datagram *)skb->data;
> > > +	if (!dg)
> > > +		return -EINVAL;
> > > 
> > > -out:
> > > -	skb_free_datagram(&vsk->sk, skb);
> > > -	return err;
> > > +	*len = dg->payload_size;
> > > +	return 0;
> > >  }
> > > 
> > >  static bool vmci_transport_dgram_allow(u32 cid, u32 port)
> > > @@ -2040,9 +2023,12 @@ static struct vsock_transport vmci_transport = {
> > >  	.release = vmci_transport_release,
> > >  	.connect = vmci_transport_connect,
> > >  	.dgram_bind = vmci_transport_dgram_bind,
> > > -	.dgram_dequeue = vmci_transport_dgram_dequeue,
> > >  	.dgram_enqueue = vmci_transport_dgram_enqueue,
> > >  	.dgram_allow = vmci_transport_dgram_allow,
> > > +	.dgram_get_cid = vmci_transport_dgram_get_cid,
> > > +	.dgram_get_port = vmci_transport_dgram_get_port,
> > > +	.dgram_get_length = vmci_transport_dgram_get_length,
> > > +	.dgram_payload_offset = sizeof(struct vmci_datagram),
> > >  	.stream_dequeue = vmci_transport_stream_dequeue,
> > >  	.stream_enqueue = vmci_transport_stream_enqueue,
> > >  	.stream_has_data = vmci_transport_stream_has_data,
> > > diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> > > index 5c6360df1f31..2f3cabc79ee5 100644
> > > --- a/net/vmw_vsock/vsock_loopback.c
> > > +++ b/net/vmw_vsock/vsock_loopback.c
> > > @@ -62,9 +62,11 @@ static struct virtio_transport loopback_transport = {
> > >  		.cancel_pkt               = vsock_loopback_cancel_pkt,
> > > 
> > >  		.dgram_bind               = virtio_transport_dgram_bind,
> > > -		.dgram_dequeue            = virtio_transport_dgram_dequeue,
> > >  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> > >  		.dgram_allow              = virtio_transport_dgram_allow,
> > > +		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
> > > +		.dgram_get_port		  = virtio_transport_dgram_get_port,
> > > +		.dgram_get_length	  = virtio_transport_dgram_get_length,
> > > 
> > >  		.stream_dequeue           = virtio_transport_stream_dequeue,
> > >  		.stream_enqueue           = virtio_transport_stream_enqueue,
> > > 
> > 
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
