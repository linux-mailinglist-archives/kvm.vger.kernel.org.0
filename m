Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4419A76DCEA
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 02:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjHCAx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 20:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjHCAxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 20:53:25 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3192102;
        Wed,  2 Aug 2023 17:53:23 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-686e29b058cso303548b3a.1;
        Wed, 02 Aug 2023 17:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691024003; x=1691628803;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zZ9dGWM/27uTbk4G6LFzY3aX0Wx6mK6D2JfWAFDZw+8=;
        b=EjRaOAYPQEXaCdjPeGPKMIX+t1b64+Knuy5qVmaroPI+ulPi4M3Mx+8RDvh2+8YIph
         AiTC9DaTQ3Jfz8a7mJG10oLYU7y8LyD/o4HRCnCt2dWwR+aOkC6JcDJxlPmH7yMcfrAY
         7d2YJguyt4TaR1ueWVADEhVsMZfovpGb4JdVLB9L7hpWJ157/Tr1rKt2bghfi17/+pIH
         Gp9LRD2z2ohS1fXiB8ReZC17XiJe4cLWuBIpjC29vdHSgEDndKqevS49mMVM3syFQbcc
         1BcuRiqn2DtyR+2OeI+/n4eeZbABxjE7WLgnkfa0jMMEf2TOFIK54W1mLtklba/PuUAd
         FUWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691024003; x=1691628803;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZ9dGWM/27uTbk4G6LFzY3aX0Wx6mK6D2JfWAFDZw+8=;
        b=F/++hBDNL5o9aogsOUfJrf37INbiy8I0voQT4ZpxJuhfJsb0FPFOUTg1w3RpVYNiRN
         5fn3Y38CaAag6uX1ZF2090bWLV979P7Y9CwtDESbWYzA6s7nHpxfZYWT9g+qXmJZc7N0
         UPEXYgZuLo2oyXWrs0CynJfg5t9KUcm7eC9HquE91XSg6DEehkMoDHcLgO2Be/b/Pp5O
         9lnxzcTr+ArhvackbCVE5khuEnaLvjdiRVn8WAQ/Zy/0YLD+G3enRyUv80uqYsT3D5Yi
         lCnYPVEz31MTIOMXU2xyjWoAlN/17ZWhBppqCMNz5QMgvalsB0R72L0v47dpXvhao8S1
         J8KA==
X-Gm-Message-State: ABy/qLZAihB0kbS+ZZpXjRUt3u/NFJJ/qbuNgDhySj01oF3cW+5Kwdmk
        FDL+r/xMhScP+LPUs4JgDAg=
X-Google-Smtp-Source: APBJJlF0Chd224yiHOmP45PspTp8hExjT5K+UpaZUJC08EQ9fRDRebyom7GrPMtyCH+i6cKP9HkzpQ==
X-Received: by 2002:a05:6a00:391c:b0:67e:bf65:ae68 with SMTP id fh28-20020a056a00391c00b0067ebf65ae68mr17184470pfb.3.1691024003169;
        Wed, 02 Aug 2023 17:53:23 -0700 (PDT)
Received: from localhost (c-67-166-91-86.hsd1.wa.comcast.net. [67.166.91.86])
        by smtp.gmail.com with ESMTPSA id v24-20020aa78518000000b00679b7d2bd57sm11605103pfn.192.2023.08.02.17.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 17:53:22 -0700 (PDT)
Date:   Thu, 3 Aug 2023 00:53:22 +0000
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
Subject: Re: [PATCH RFC net-next v5 03/14] af_vsock: support multi-transport
 datagrams
Message-ID: <ZMr6giur//A1hrND@bullseye>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-3-581bd37fdb26@bytedance.com>
 <43fad7ab-2ca9-608e-566f-80e607d2d6b8@gmail.com>
 <ZMrXrBHuaEcpxGwA@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMrXrBHuaEcpxGwA@bullseye>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023 at 10:24:44PM +0000, Bobby Eshleman wrote:
> On Sun, Jul 23, 2023 at 12:53:15AM +0300, Arseniy Krasnov wrote:
> > 
> > 
> > On 19.07.2023 03:50, Bobby Eshleman wrote:
> > > This patch adds support for multi-transport datagrams.
> > > 
> > > This includes:
> > > - Per-packet lookup of transports when using sendto(sockaddr_vm)
> > > - Selecting H2G or G2H transport using VMADDR_FLAG_TO_HOST and CID in
> > >   sockaddr_vm
> > > - rename VSOCK_TRANSPORT_F_DGRAM to VSOCK_TRANSPORT_F_DGRAM_FALLBACK
> > > - connect() now assigns the transport for (similar to connectible
> > >   sockets)
> > > 
> > > To preserve backwards compatibility with VMCI, some important changes
> > > are made. The "transport_dgram" / VSOCK_TRANSPORT_F_DGRAM is changed to
> > > be used for dgrams only if there is not yet a g2h or h2g transport that
> > > has been registered that can transmit the packet. If there is a g2h/h2g
> > > transport for that remote address, then that transport will be used and
> > > not "transport_dgram". This essentially makes "transport_dgram" a
> > > fallback transport for when h2g/g2h has not yet gone online, and so it
> > > is renamed "transport_dgram_fallback". VMCI implements this transport.
> > > 
> > > The logic around "transport_dgram" needs to be retained to prevent
> > > breaking VMCI:
> > > 
> > > 1) VMCI datagrams existed prior to h2g/g2h and so operate under a
> > >    different paradigm. When the vmci transport comes online, it registers
> > >    itself with the DGRAM feature, but not H2G/G2H. Only later when the
> > >    transport has more information about its environment does it register
> > >    H2G or G2H.  In the case that a datagram socket is created after
> > >    VSOCK_TRANSPORT_F_DGRAM registration but before G2H/H2G registration,
> > >    the "transport_dgram" transport is the only registered transport and so
> > >    needs to be used.
> > > 
> > > 2) VMCI seems to require a special message be sent by the transport when a
> > >    datagram socket calls bind(). Under the h2g/g2h model, the transport
> > >    is selected using the remote_addr which is set by connect(). At
> > >    bind time there is no remote_addr because often no connect() has been
> > >    called yet: the transport is null. Therefore, with a null transport
> > >    there doesn't seem to be any good way for a datagram socket to tell the
> > >    VMCI transport that it has just had bind() called upon it.
> > > 
> > > With the new fallback logic, after H2G/G2H comes online the socket layer
> > > will access the VMCI transport via transport_{h2g,g2h}. Prior to H2G/G2H
> > > coming online, the socket layer will access the VMCI transport via
> > > "transport_dgram_fallback".
> > > 
> > > Only transports with a special datagram fallback use-case such as VMCI
> > > need to register VSOCK_TRANSPORT_F_DGRAM_FALLBACK.
> > > 
> > > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > > ---
> > >  drivers/vhost/vsock.c                   |  1 -
> > >  include/linux/virtio_vsock.h            |  2 --
> > >  include/net/af_vsock.h                  | 10 +++---
> > >  net/vmw_vsock/af_vsock.c                | 64 ++++++++++++++++++++++++++-------
> > >  net/vmw_vsock/hyperv_transport.c        |  6 ----
> > >  net/vmw_vsock/virtio_transport.c        |  1 -
> > >  net/vmw_vsock/virtio_transport_common.c |  7 ----
> > >  net/vmw_vsock/vmci_transport.c          |  2 +-
> > >  net/vmw_vsock/vsock_loopback.c          |  1 -
> > >  9 files changed, 58 insertions(+), 36 deletions(-)
> > > 
> > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > index ae8891598a48..d5d6a3c3f273 100644
> > > --- a/drivers/vhost/vsock.c
> > > +++ b/drivers/vhost/vsock.c
> > > @@ -410,7 +410,6 @@ static struct virtio_transport vhost_transport = {
> > >  		.cancel_pkt               = vhost_transport_cancel_pkt,
> > >  
> > >  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> > > -		.dgram_bind               = virtio_transport_dgram_bind,
> > >  		.dgram_allow              = virtio_transport_dgram_allow,
> > >  
> > >  		.stream_enqueue           = virtio_transport_stream_enqueue,
> > > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > > index 18cbe8d37fca..7632552bee58 100644
> > > --- a/include/linux/virtio_vsock.h
> > > +++ b/include/linux/virtio_vsock.h
> > > @@ -211,8 +211,6 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
> > >  u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
> > >  bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
> > >  bool virtio_transport_stream_allow(u32 cid, u32 port);
> > > -int virtio_transport_dgram_bind(struct vsock_sock *vsk,
> > > -				struct sockaddr_vm *addr);
> > >  bool virtio_transport_dgram_allow(u32 cid, u32 port);
> > >  
> > >  int virtio_transport_connect(struct vsock_sock *vsk);
> > > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > > index 305d57502e89..f6a0ca9d7c3e 100644
> > > --- a/include/net/af_vsock.h
> > > +++ b/include/net/af_vsock.h
> > > @@ -96,13 +96,13 @@ struct vsock_transport_send_notify_data {
> > >  
> > >  /* Transport features flags */
> > >  /* Transport provides host->guest communication */
> > > -#define VSOCK_TRANSPORT_F_H2G		0x00000001
> > > +#define VSOCK_TRANSPORT_F_H2G			0x00000001
> > >  /* Transport provides guest->host communication */
> > > -#define VSOCK_TRANSPORT_F_G2H		0x00000002
> > > -/* Transport provides DGRAM communication */
> > > -#define VSOCK_TRANSPORT_F_DGRAM		0x00000004
> > > +#define VSOCK_TRANSPORT_F_G2H			0x00000002
> > > +/* Transport provides fallback for DGRAM communication */
> > > +#define VSOCK_TRANSPORT_F_DGRAM_FALLBACK	0x00000004
> > >  /* Transport provides local (loopback) communication */
> > > -#define VSOCK_TRANSPORT_F_LOCAL		0x00000008
> > > +#define VSOCK_TRANSPORT_F_LOCAL			0x00000008
> > >  
> > >  struct vsock_transport {
> > >  	struct module *module;
> > > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > > index ae5ac5531d96..26c97b33d55a 100644
> > > --- a/net/vmw_vsock/af_vsock.c
> > > +++ b/net/vmw_vsock/af_vsock.c
> > > @@ -139,8 +139,8 @@ struct proto vsock_proto = {
> > >  static const struct vsock_transport *transport_h2g;
> > >  /* Transport used for guest->host communication */
> > >  static const struct vsock_transport *transport_g2h;
> > > -/* Transport used for DGRAM communication */
> > > -static const struct vsock_transport *transport_dgram;
> > > +/* Transport used as a fallback for DGRAM communication */
> > > +static const struct vsock_transport *transport_dgram_fallback;
> > >  /* Transport used for local communication */
> > >  static const struct vsock_transport *transport_local;
> > >  static DEFINE_MUTEX(vsock_register_mutex);
> > > @@ -439,6 +439,18 @@ vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
> > >  	return transport;
> > >  }
> > >  
> > > +static const struct vsock_transport *
> > > +vsock_dgram_lookup_transport(unsigned int cid, __u8 flags)
> > > +{
> > > +	const struct vsock_transport *transport;
> > > +
> > > +	transport = vsock_connectible_lookup_transport(cid, flags);
> > > +	if (transport)
> > > +		return transport;
> > > +
> > > +	return transport_dgram_fallback;
> > > +}
> > > +
> > >  /* Assign a transport to a socket and call the .init transport callback.
> > >   *
> > >   * Note: for connection oriented socket this must be called when vsk->remote_addr
> > > @@ -475,7 +487,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> > >  
> > >  	switch (sk->sk_type) {
> > >  	case SOCK_DGRAM:
> > > -		new_transport = transport_dgram;
> > > +		new_transport = vsock_dgram_lookup_transport(remote_cid,
> > > +							     remote_flags);
> > 
> > I'm a little bit confused about this: 
> > 1) Let's create SOCK_DGRAM socket using vsock_create()
> > 2) for SOCK_DGRAM it calls 'vsock_assign_transport()' and we go here, remote_cid == -1
> > 3) I guess 'vsock_dgram_lookup_transport()' calls logic from 0002 and returns h2g for such remote cid, which is not
> >    correct I think...
> > 
> > Please correct me if i'm wrong
> > 
> > Thanks, Arseniy
> > 
> 
> As I understand, for the VMCI case, if transport_h2g != NULL, then
> transport_h2g == transport_dgram_fallback. In either case,
> vsk->transport == transport_dgram_fallback.
> 
> For the virtio/vhost case, temporarily vsk->transport == transport_h2g,
> but it is unused because vsk->transport->dgram_bind == NULL.
> 
> Until SS_CONNECTED is set by connect() and vsk->transport is set
> correctly, the send path is barred from using the bad transport.
> 
> I guess the recvmsg() path is a little more sketchy, and probably only
> works in my test cases because h2g/g2h in the vhost/virtio case have
> identical dgram_addr_init() implementations.
> 
> I think a cleaner solution is maybe checking in vsock_create() if
> dgram_bind is implemented. If it is not, then vsk->transport should be
> reset to NULL and a comment added explaining why VMCI requires this.
> 
> Then the other calls can begin explicitly checking for vsk->transport ==
> NULL.

Actually, on further reflection here, in order for the vsk->transport to
be called in time for ->dgram_addr_init(), it is going to be necessary
to call vsock_assign_transport() in vsock_dgram_bind() anyway.

I think this means that the vsock_assign_transport() call can be removed
from vsock_create() call entirely, and yet VMCI can still dispatch
messages upon bind() calls as needed.

This would then simplify the whole arrangement, if there aren't other
unseen issues.

> 
> Thoughts?
> 
> > >  		break;
> > >  	case SOCK_STREAM:
> > >  	case SOCK_SEQPACKET:
> > > @@ -692,6 +705,9 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> > >  static int __vsock_bind_dgram(struct vsock_sock *vsk,
> > >  			      struct sockaddr_vm *addr)
> > >  {
> > > +	if (!vsk->transport || !vsk->transport->dgram_bind)
> > > +		return -EINVAL;
> > > +
> > >  	return vsk->transport->dgram_bind(vsk, addr);
> > >  }
> > >  
> > > @@ -1162,6 +1178,7 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
> > >  	struct vsock_sock *vsk;
> > >  	struct sockaddr_vm *remote_addr;
> > >  	const struct vsock_transport *transport;
> > > +	bool module_got = false;
> > >  
> > >  	if (msg->msg_flags & MSG_OOB)
> > >  		return -EOPNOTSUPP;
> > > @@ -1173,19 +1190,34 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
> > >  
> > >  	lock_sock(sk);
> > >  
> > > -	transport = vsk->transport;
> > > -
> > >  	err = vsock_auto_bind(vsk);
> > >  	if (err)
> > >  		goto out;
> > >  
> > > -
> > >  	/* If the provided message contains an address, use that.  Otherwise
> > >  	 * fall back on the socket's remote handle (if it has been connected).
> > >  	 */
> > >  	if (msg->msg_name &&
> > >  	    vsock_addr_cast(msg->msg_name, msg->msg_namelen,
> > >  			    &remote_addr) == 0) {
> > > +		transport = vsock_dgram_lookup_transport(remote_addr->svm_cid,
> > > +							 remote_addr->svm_flags);
> > > +		if (!transport) {
> > > +			err = -EINVAL;
> > > +			goto out;
> > > +		}
> > > +
> > > +		if (!try_module_get(transport->module)) {
> > > +			err = -ENODEV;
> > > +			goto out;
> > > +		}
> > > +
> > > +		/* When looking up a transport dynamically and acquiring a
> > > +		 * reference on the module, we need to remember to release the
> > > +		 * reference later.
> > > +		 */
> > > +		module_got = true;
> > > +
> > >  		/* Ensure this address is of the right type and is a valid
> > >  		 * destination.
> > >  		 */
> > > @@ -1200,6 +1232,7 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
> > >  	} else if (sock->state == SS_CONNECTED) {
> > >  		remote_addr = &vsk->remote_addr;
> > >  
> > > +		transport = vsk->transport;
> > >  		if (remote_addr->svm_cid == VMADDR_CID_ANY)
> > >  			remote_addr->svm_cid = transport->get_local_cid();
> > >  
> > > @@ -1224,6 +1257,8 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
> > >  	err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
> > >  
> > >  out:
> > > +	if (module_got)
> > > +		module_put(transport->module);
> > >  	release_sock(sk);
> > >  	return err;
> > >  }
> > > @@ -1256,13 +1291,18 @@ static int vsock_dgram_connect(struct socket *sock,
> > >  	if (err)
> > >  		goto out;
> > >  
> > > +	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
> > > +
> > > +	err = vsock_assign_transport(vsk, NULL);
> > > +	if (err)
> > > +		goto out;
> > > +
> > >  	if (!vsk->transport->dgram_allow(remote_addr->svm_cid,
> > >  					 remote_addr->svm_port)) {
> > >  		err = -EINVAL;
> > >  		goto out;
> > >  	}
> > >  
> > > -	memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
> > >  	sock->state = SS_CONNECTED;
> > >  
> > >  	/* sock map disallows redirection of non-TCP sockets with sk_state !=
> > > @@ -2487,7 +2527,7 @@ int vsock_core_register(const struct vsock_transport *t, int features)
> > >  
> > >  	t_h2g = transport_h2g;
> > >  	t_g2h = transport_g2h;
> > > -	t_dgram = transport_dgram;
> > > +	t_dgram = transport_dgram_fallback;
> > >  	t_local = transport_local;
> > >  
> > >  	if (features & VSOCK_TRANSPORT_F_H2G) {
> > > @@ -2506,7 +2546,7 @@ int vsock_core_register(const struct vsock_transport *t, int features)
> > >  		t_g2h = t;
> > >  	}
> > >  
> > > -	if (features & VSOCK_TRANSPORT_F_DGRAM) {
> > > +	if (features & VSOCK_TRANSPORT_F_DGRAM_FALLBACK) {
> > >  		if (t_dgram) {
> > >  			err = -EBUSY;
> > >  			goto err_busy;
> > > @@ -2524,7 +2564,7 @@ int vsock_core_register(const struct vsock_transport *t, int features)
> > >  
> > >  	transport_h2g = t_h2g;
> > >  	transport_g2h = t_g2h;
> > > -	transport_dgram = t_dgram;
> > > +	transport_dgram_fallback = t_dgram;
> > >  	transport_local = t_local;
> > >  
> > >  err_busy:
> > > @@ -2543,8 +2583,8 @@ void vsock_core_unregister(const struct vsock_transport *t)
> > >  	if (transport_g2h == t)
> > >  		transport_g2h = NULL;
> > >  
> > > -	if (transport_dgram == t)
> > > -		transport_dgram = NULL;
> > > +	if (transport_dgram_fallback == t)
> > > +		transport_dgram_fallback = NULL;
> > >  
> > >  	if (transport_local == t)
> > >  		transport_local = NULL;
> > > diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
> > > index 7f1ea434656d..c29000f2612a 100644
> > > --- a/net/vmw_vsock/hyperv_transport.c
> > > +++ b/net/vmw_vsock/hyperv_transport.c
> > > @@ -551,11 +551,6 @@ static void hvs_destruct(struct vsock_sock *vsk)
> > >  	kfree(hvs);
> > >  }
> > >  
> > > -static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)
> > > -{
> > > -	return -EOPNOTSUPP;
> > > -}
> > > -
> > >  static int hvs_dgram_enqueue(struct vsock_sock *vsk,
> > >  			     struct sockaddr_vm *remote, struct msghdr *msg,
> > >  			     size_t dgram_len)
> > > @@ -826,7 +821,6 @@ static struct vsock_transport hvs_transport = {
> > >  	.connect                  = hvs_connect,
> > >  	.shutdown                 = hvs_shutdown,
> > >  
> > > -	.dgram_bind               = hvs_dgram_bind,
> > >  	.dgram_enqueue            = hvs_dgram_enqueue,
> > >  	.dgram_allow              = hvs_dgram_allow,
> > >  
> > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > > index 66edffdbf303..ac2126c7dac5 100644
> > > --- a/net/vmw_vsock/virtio_transport.c
> > > +++ b/net/vmw_vsock/virtio_transport.c
> > > @@ -428,7 +428,6 @@ static struct virtio_transport virtio_transport = {
> > >  		.shutdown                 = virtio_transport_shutdown,
> > >  		.cancel_pkt               = virtio_transport_cancel_pkt,
> > >  
> > > -		.dgram_bind               = virtio_transport_dgram_bind,
> > >  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> > >  		.dgram_allow              = virtio_transport_dgram_allow,
> > >  
> > > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > > index 01ea1402ad40..ffcbdd77feaa 100644
> > > --- a/net/vmw_vsock/virtio_transport_common.c
> > > +++ b/net/vmw_vsock/virtio_transport_common.c
> > > @@ -781,13 +781,6 @@ bool virtio_transport_stream_allow(u32 cid, u32 port)
> > >  }
> > >  EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
> > >  
> > > -int virtio_transport_dgram_bind(struct vsock_sock *vsk,
> > > -				struct sockaddr_vm *addr)
> > > -{
> > > -	return -EOPNOTSUPP;
> > > -}
> > > -EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
> > > -
> > >  bool virtio_transport_dgram_allow(u32 cid, u32 port)
> > >  {
> > >  	return false;
> > > diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> > > index 0bbbdb222245..857b0461f856 100644
> > > --- a/net/vmw_vsock/vmci_transport.c
> > > +++ b/net/vmw_vsock/vmci_transport.c
> > > @@ -2072,7 +2072,7 @@ static int __init vmci_transport_init(void)
> > >  	/* Register only with dgram feature, other features (H2G, G2H) will be
> > >  	 * registered when the first host or guest becomes active.
> > >  	 */
> > > -	err = vsock_core_register(&vmci_transport, VSOCK_TRANSPORT_F_DGRAM);
> > > +	err = vsock_core_register(&vmci_transport, VSOCK_TRANSPORT_F_DGRAM_FALLBACK);
> > >  	if (err < 0)
> > >  		goto err_unsubscribe;
> > >  
> > > diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> > > index 2a59dd177c74..278235ea06c4 100644
> > > --- a/net/vmw_vsock/vsock_loopback.c
> > > +++ b/net/vmw_vsock/vsock_loopback.c
> > > @@ -61,7 +61,6 @@ static struct virtio_transport loopback_transport = {
> > >  		.shutdown                 = virtio_transport_shutdown,
> > >  		.cancel_pkt               = vsock_loopback_cancel_pkt,
> > >  
> > > -		.dgram_bind               = virtio_transport_dgram_bind,
> > >  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> > >  		.dgram_allow              = virtio_transport_dgram_allow,
> > >  
> > > 
