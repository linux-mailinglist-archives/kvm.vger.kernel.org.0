Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E8E73A4A9
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 17:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbjFVPUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 11:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjFVPUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 11:20:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E848110F4
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 08:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687447206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YAWCmrAmwCl1N7fCfizEGws+8a3F56UqQiaEh7J5B+E=;
        b=d4Ed1yOB8bZufN9l/26AikcXEzccwbctOdaCP+a9bKovhGAOz0A6BZA6U2PwrDtE4VMPtz
        ofRgBmyRZwsRfcsiVURB586030fEi+S3G+18U9/rdFdgVCCv1lfW0QTBlaBRGoZT+7xItK
        atC8fchBS2GBU0qaPy9NMdYELjI9vW0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-LtGr2mNAOrOVJ0xNJZ2wvQ-1; Thu, 22 Jun 2023 11:19:16 -0400
X-MC-Unique: LtGr2mNAOrOVJ0xNJZ2wvQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f810b4903fso37367095e9.2
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 08:19:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687447152; x=1690039152;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YAWCmrAmwCl1N7fCfizEGws+8a3F56UqQiaEh7J5B+E=;
        b=K+t/envb2Z1GJ/8FfD1WqixPS3HAa/aLZvNLho968rvcr5YqLsGt7eXSuf1TGG0sHf
         B9Pw7W2g+k9tdVyl/9OmgLuibMh0tQUAjngAHy708CNW4bIO2aXwGqXKqUS2qRpPuUWX
         RBPa1xlNbxcgUVSSwjvCkqZ8tOacZpVakVySjzYlmJ/oZx0B9XLwEa283KMdrrIvIJ4z
         OS8kcJvG8TmWTZzwu1XrY77CZR6lis7RllE0SXtp3IstGGddUBIpeCITmjgvxBuu/ssK
         4f4UGTG02CnYKTFmjNgMCU9GuTHstr8Lj5nGBQD/DOVKmREoV9OnPUqorXawoH6ff+WM
         wmow==
X-Gm-Message-State: AC+VfDzPbKSvSBAZqerW6rpwoL/eYlWTKb5s4UYFT9bqmNG2epHVej+I
        dcyo81+RWtvURhYXKdRPae4+zwb8IOBkzGIbnJqTXbdvHVl4df8EG9XBrFIi1gpWYMdXnpue3Xk
        SSy7zv5s3BAFo
X-Received: by 2002:a7b:cd16:0:b0:3f9:b119:e42b with SMTP id f22-20020a7bcd16000000b003f9b119e42bmr9403371wmj.30.1687447152464;
        Thu, 22 Jun 2023 08:19:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4UtO+vdPl4TbSBFba6U7sn8uXDPfnnKtHGMCmuC/vX/EQ7I92imvaPRsCck5pPB0+FXg2gyA==
X-Received: by 2002:a7b:cd16:0:b0:3f9:b119:e42b with SMTP id f22-20020a7bcd16000000b003f9b119e42bmr9403350wmj.30.1687447152070;
        Thu, 22 Jun 2023 08:19:12 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id f20-20020a1c6a14000000b003f8f884ebe5sm8051180wmc.2.2023.06.22.08.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 08:19:11 -0700 (PDT)
Date:   Thu, 22 Jun 2023 17:19:08 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
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
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC net-next v4 3/8] vsock: support multi-transport
 datagrams
Message-ID: <tngyeva5by3aldrhlixajjin2hqmcl6uruvuoed7hyrndlesfd@bbv7aphqye2q>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-3-0cebbb2ae899@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v4-3-0cebbb2ae899@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 10, 2023 at 12:58:30AM +0000, Bobby Eshleman wrote:
>This patch adds support for multi-transport datagrams.
>
>This includes:
>- Per-packet lookup of transports when using sendto(sockaddr_vm)
>- Selecting H2G or G2H transport using VMADDR_FLAG_TO_HOST and CID in
>  sockaddr_vm
>
>To preserve backwards compatibility with VMCI, some important changes
>were made. The "transport_dgram" / VSOCK_TRANSPORT_F_DGRAM is changed to
>be used for dgrams iff there is not yet a g2h or h2g transport that has

s/iff/if

>been registered that can transmit the packet. If there is a g2h/h2g
>transport for that remote address, then that transport will be used and
>not "transport_dgram". This essentially makes "transport_dgram" a
>fallback transport for when h2g/g2h has not yet gone online, which
>appears to be the exact use case for VMCI.
>
>This design makes sense, because there is no reason that the
>transport_{g2h,h2g} cannot also service datagrams, which makes the role
>of transport_dgram difficult to understand outside of the VMCI context.
>
>The logic around "transport_dgram" had to be retained to prevent
>breaking VMCI:
>
>1) VMCI datagrams appear to function outside of the h2g/g2h
>   paradigm. When the vmci transport becomes online, it registers itself
>   with the DGRAM feature, but not H2G/G2H. Only later when the
>   transport has more information about its environment does it register
>   H2G or G2H. In the case that a datagram socket becomes active
>   after DGRAM registration but before G2H/H2G registration, the
>   "transport_dgram" transport needs to be used.

IIRC we did this, because at that time only VMCI supported DGRAM. Now 
that there are more transports, maybe DGRAM can follow the h2g/g2h 
paradigm.

>
>2) VMCI seems to require special message be sent by the transport when a
>   datagram socket calls bind(). Under the h2g/g2h model, the transport
>   is selected using the remote_addr which is set by connect(). At
>   bind time there is no remote_addr because often no connect() has been
>   called yet: the transport is null. Therefore, with a null transport
>   there doesn't seem to be any good way for a datagram socket a tell the
>   VMCI transport that it has just had bind() called upon it.

@Vishnu, @Bryan do you think we can avoid this in some way?

>
>Only transports with a special datagram fallback use-case such as VMCI
>need to register VSOCK_TRANSPORT_F_DGRAM.

Maybe we should rename it in VSOCK_TRANSPORT_F_DGRAM_FALLBACK or
something like that.

In any case, we definitely need to update the comment in 
include/net/af_vsock.h on top of VSOCK_TRANSPORT_F_DGRAM mentioning
this.

>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> drivers/vhost/vsock.c                   |  1 -
> include/linux/virtio_vsock.h            |  2 -
> net/vmw_vsock/af_vsock.c                | 78 +++++++++++++++++++++++++--------
> net/vmw_vsock/hyperv_transport.c        |  6 ---
> net/vmw_vsock/virtio_transport.c        |  1 -
> net/vmw_vsock/virtio_transport_common.c |  7 ---
> net/vmw_vsock/vsock_loopback.c          |  1 -
> 7 files changed, 60 insertions(+), 36 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index c8201c070b4b..8f0082da5e70 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -410,7 +410,6 @@ static struct virtio_transport vhost_transport = {
> 		.cancel_pkt               = vhost_transport_cancel_pkt,
>
> 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
>-		.dgram_bind               = virtio_transport_dgram_bind,
> 		.dgram_allow              = virtio_transport_dgram_allow,
> 		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
> 		.dgram_get_port		  = virtio_transport_dgram_get_port,
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 23521a318cf0..73afa09f4585 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -216,8 +216,6 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
> u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
> bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
> bool virtio_transport_stream_allow(u32 cid, u32 port);
>-int virtio_transport_dgram_bind(struct vsock_sock *vsk,
>-				struct sockaddr_vm *addr);
> bool virtio_transport_dgram_allow(u32 cid, u32 port);
> int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid);
> int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port);
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 74358f0b47fa..ef86765f3765 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -438,6 +438,18 @@ vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
> 	return transport;
> }
>
>+static const struct vsock_transport *
>+vsock_dgram_lookup_transport(unsigned int cid, __u8 flags)
>+{
>+	const struct vsock_transport *transport;
>+
>+	transport = vsock_connectible_lookup_transport(cid, flags);
>+	if (transport)
>+		return transport;
>+
>+	return transport_dgram;
>+}
>+
> /* Assign a transport to a socket and call the .init transport callback.
>  *
>  * Note: for connection oriented socket this must be called when vsk->remote_addr
>@@ -474,7 +486,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>
> 	switch (sk->sk_type) {
> 	case SOCK_DGRAM:
>-		new_transport = transport_dgram;
>+		new_transport = vsock_dgram_lookup_transport(remote_cid,
>+							     remote_flags);
> 		break;
> 	case SOCK_STREAM:
> 	case SOCK_SEQPACKET:
>@@ -691,6 +704,9 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> static int __vsock_bind_dgram(struct vsock_sock *vsk,
> 			      struct sockaddr_vm *addr)
> {
>+	if (!vsk->transport || !vsk->transport->dgram_bind)
>+		return -EINVAL;
>+
> 	return vsk->transport->dgram_bind(vsk, addr);
> }
>
>@@ -1172,19 +1188,24 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>
> 	lock_sock(sk);
>
>-	transport = vsk->transport;
>-
>-	err = vsock_auto_bind(vsk);
>-	if (err)
>-		goto out;
>-
>-
> 	/* If the provided message contains an address, use that.  Otherwise
> 	 * fall back on the socket's remote handle (if it has been connected).
> 	 */
> 	if (msg->msg_name &&
> 	    vsock_addr_cast(msg->msg_name, msg->msg_namelen,
> 			    &remote_addr) == 0) {
>+		transport = vsock_dgram_lookup_transport(remote_addr->svm_cid,
>+							 remote_addr->svm_flags);
>+		if (!transport) {
>+			err = -EINVAL;
>+			goto out;
>+		}
>+
>+		if (!try_module_get(transport->module)) {
>+			err = -ENODEV;
>+			goto out;
>+		}
>+
> 		/* Ensure this address is of the right type and is a valid
> 		 * destination.
> 		 */
>@@ -1193,11 +1214,27 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
> 			remote_addr->svm_cid = transport->get_local_cid();
>

 From here ...

> 		if (!vsock_addr_bound(remote_addr)) {
>+			module_put(transport->module);
>+			err = -EINVAL;
>+			goto out;
>+		}
>+
>+		if (!transport->dgram_allow(remote_addr->svm_cid,
>+					    remote_addr->svm_port)) {
>+			module_put(transport->module);
> 			err = -EINVAL;
> 			goto out;
> 		}
>+
>+		err = transport->dgram_enqueue(vsk, remote_addr, msg, len);

... to here, looks like duplicate code, can we get it out of the if 
block?

>+		module_put(transport->module);
> 	} else if (sock->state == SS_CONNECTED) {
> 		remote_addr = &vsk->remote_addr;
>+		transport = vsk->transport;
>+
>+		err = vsock_auto_bind(vsk);
>+		if (err)
>+			goto out;
>
> 		if (remote_addr->svm_cid == VMADDR_CID_ANY)
> 			remote_addr->svm_cid = transport->get_local_cid();
>@@ -1205,23 +1242,23 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
> 		/* XXX Should connect() or this function ensure remote_addr is
> 		 * bound?
> 		 */
>-		if (!vsock_addr_bound(&vsk->remote_addr)) {
>+		if (!vsock_addr_bound(remote_addr)) {
> 			err = -EINVAL;
> 			goto out;
> 		}
>-	} else {
>-		err = -EINVAL;
>-		goto out;
>-	}
>
>-	if (!transport->dgram_allow(remote_addr->svm_cid,
>-				    remote_addr->svm_port)) {
>+		if (!transport->dgram_allow(remote_addr->svm_cid,
>+					    remote_addr->svm_port)) {
>+			err = -EINVAL;
>+			goto out;
>+		}
>+
>+		err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
>+	} else {
> 		err = -EINVAL;
> 		goto out;
> 	}
>
>-	err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
>-
> out:
> 	release_sock(sk);
> 	return err;
>@@ -1255,13 +1292,18 @@ static int vsock_dgram_connect(struct socket *sock,
> 	if (err)
> 		goto out;
>
>+	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
>+
>+	err = vsock_assign_transport(vsk, NULL);
>+	if (err)
>+		goto out;
>+
> 	if (!vsk->transport->dgram_allow(remote_addr->svm_cid,
> 					 remote_addr->svm_port)) {
> 		err = -EINVAL;
> 		goto out;
> 	}
>
>-	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
> 	sock->state = SS_CONNECTED;
>
> 	/* sock map disallows redirection of non-TCP sockets with sk_state !=
>diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>index ff6e87e25fa0..c00bc5da769a 100644
>--- a/net/vmw_vsock/hyperv_transport.c
>+++ b/net/vmw_vsock/hyperv_transport.c
>@@ -551,11 +551,6 @@ static void hvs_destruct(struct vsock_sock *vsk)
> 	kfree(hvs);
> }
>
>-static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)
>-{
>-	return -EOPNOTSUPP;
>-}
>-
> static int hvs_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
> {
> 	return -EOPNOTSUPP;
>@@ -841,7 +836,6 @@ static struct vsock_transport hvs_transport = {
> 	.connect                  = hvs_connect,
> 	.shutdown                 = hvs_shutdown,
>
>-	.dgram_bind               = hvs_dgram_bind,
> 	.dgram_get_cid		  = hvs_dgram_get_cid,
> 	.dgram_get_port		  = hvs_dgram_get_port,
> 	.dgram_get_length	  = hvs_dgram_get_length,
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 5763cdf13804..1b7843a7779a 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -428,7 +428,6 @@ static struct virtio_transport virtio_transport = {
> 		.shutdown                 = virtio_transport_shutdown,
> 		.cancel_pkt               = virtio_transport_cancel_pkt,
>
>-		.dgram_bind               = virtio_transport_dgram_bind,
> 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> 		.dgram_allow              = virtio_transport_dgram_allow,
> 		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index e6903c719964..d5a3c8efe84b 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -790,13 +790,6 @@ bool virtio_transport_stream_allow(u32 cid, u32 port)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
>
>-int virtio_transport_dgram_bind(struct vsock_sock *vsk,
>-				struct sockaddr_vm *addr)
>-{
>-	return -EOPNOTSUPP;
>-}
>-EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
>-
> int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
> {
> 	return -EOPNOTSUPP;
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index 2f3cabc79ee5..e9de45a26fbd 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -61,7 +61,6 @@ static struct virtio_transport loopback_transport = {
> 		.shutdown                 = virtio_transport_shutdown,
> 		.cancel_pkt               = vsock_loopback_cancel_pkt,
>
>-		.dgram_bind               = virtio_transport_dgram_bind,
> 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> 		.dgram_allow              = virtio_transport_dgram_allow,
> 		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
>
>-- 
>2.30.2
>

The rest LGTM!

Stefano

