Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DA973AD37
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbjFVXee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjFVXed (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:34:33 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DF12101;
        Thu, 22 Jun 2023 16:34:31 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-666eec46206so5339700b3a.3;
        Thu, 22 Jun 2023 16:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687476871; x=1690068871;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pfc1QyNfZVGpZq0rXdYN9rxzi+ajw4PuY2VafbrvbKA=;
        b=bBqb2gU+Xe43kHLfHfezspWZCvCwagEY7jfMKz6CxsNLS2iLcJPQN9Rov11VZMHmou
         zmXBT433ENfG+g9uMbaYXj38co6MwTPORjgUpRwIW7gO6ln8tk+4SXAFFvdYuBfclSyF
         M7baU4SQXT8Bdsfg4fyECU95MpBWHP8OwpaH/9PqBY+o/p0zUdENorIlZbbNPzSWk2Ia
         /hnWCl6meth7puGPeb3FnbfzV9Oqs+eSp33dtGIFiRkbf42epH5h7eUUR0TiFAbQyawf
         f44Hl7TMXjpRmtLypLN97PcXvCpOs2PGiXSZ1pBHilPdoJT6TaNYgKm51vgwhOkHDpDW
         Kkyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687476871; x=1690068871;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pfc1QyNfZVGpZq0rXdYN9rxzi+ajw4PuY2VafbrvbKA=;
        b=UhpWp/uM1mCvK6K054pVxknSjX3RtP5c8VT5IY3bPgfT6J1J6CI1+fZhBFZKzRWxKX
         30gXPVpMWkuhs1wMikNSCQih37AXe8YK+Fxce3pbjP6K3DRFYF1zqxISFORwwkwib7J0
         j7iPyoPawgr746Wl6geu4IPm2SHSgs9HsiRVoGI+aWK/7/u+vKjbLHcttKjvXa3jtX4c
         LFMnGGYofLmAHQEaBYANKAPzReZ+UjGBX4oJy6sutWRJnEKUDRKehUAKRqCzyuWQbnFZ
         0hRT+2fE4/l6I6s8DiP006kQJBOnci+IZloRo/QAiInVYb05NufDdzpkQz4InQNlWLAq
         xsAA==
X-Gm-Message-State: AC+VfDybGV0gK09hWL94+q9EgP/VKEzAdBzeDrUbtAO9oXuk+nGrNarj
        MC/1eGgNZGfj9vSS6lWVB4A=
X-Google-Smtp-Source: ACHHUZ6NZRMLU/S5GClV6Sx/sOEHbBnoWyE0pGZ4X8CJd76NYJZmSVSmbLVzVW4s53wIcLMGsc3l1w==
X-Received: by 2002:a05:6a00:234c:b0:668:8b43:8df0 with SMTP id j12-20020a056a00234c00b006688b438df0mr12686251pfj.33.1687476870590;
        Thu, 22 Jun 2023 16:34:30 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id s15-20020a62e70f000000b0066884d4efdbsm5156831pfh.12.2023.06.22.16.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 16:34:30 -0700 (PDT)
Date:   Thu, 22 Jun 2023 23:34:29 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Arseniy Krasnov <oxffffaa@gmail.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
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
Subject: Re: [PATCH RFC net-next v4 1/8] vsock/dgram: generalize recvmsg and
 drop transport->dgram_dequeue
Message-ID: <ZJTahaGs3yFQI7mw@bullseye>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-1-0cebbb2ae899@bytedance.com>
 <3eb6216b-a3d2-e1ef-270c-8a0032a4a8a5@gmail.com>
 <63ko2n5fwjdefot6rzcxdftfh6pilg6vmqn66v4ue5dgf4oz53@tntmdijw4ghr>
 <2a0c29d5-d696-ac24-2a4a-1d691eef8daf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a0c29d5-d696-ac24-2a4a-1d691eef8daf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 10:23:26PM +0300, Arseniy Krasnov wrote:
> 
> 
> On 22.06.2023 17:51, Stefano Garzarella wrote:
> > On Sun, Jun 11, 2023 at 11:43:15PM +0300, Arseniy Krasnov wrote:
> >> Hello Bobby! Thanks for this patchset! Small comment below:
> >>
> >> On 10.06.2023 03:58, Bobby Eshleman wrote:
> >>> This commit drops the transport->dgram_dequeue callback and makes
> >>> vsock_dgram_recvmsg() generic. It also adds additional transport
> >>> callbacks for use by the generic vsock_dgram_recvmsg(), such as for
> >>> parsing skbs for CID/port which vary in format per transport.
> >>>
> >>> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >>> ---
> >>>  drivers/vhost/vsock.c                   |  4 +-
> >>>  include/linux/virtio_vsock.h            |  3 ++
> >>>  include/net/af_vsock.h                  | 13 ++++++-
> >>>  net/vmw_vsock/af_vsock.c                | 51 ++++++++++++++++++++++++-
> >>>  net/vmw_vsock/hyperv_transport.c        | 17 +++++++--
> >>>  net/vmw_vsock/virtio_transport.c        |  4 +-
> >>>  net/vmw_vsock/virtio_transport_common.c | 18 +++++++++
> >>>  net/vmw_vsock/vmci_transport.c          | 68 +++++++++++++--------------------
> >>>  net/vmw_vsock/vsock_loopback.c          |  4 +-
> >>>  9 files changed, 132 insertions(+), 50 deletions(-)
> >>>
> >>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> >>> index 6578db78f0ae..c8201c070b4b 100644
> >>> --- a/drivers/vhost/vsock.c
> >>> +++ b/drivers/vhost/vsock.c
> >>> @@ -410,9 +410,11 @@ static struct virtio_transport vhost_transport = {
> >>>          .cancel_pkt               = vhost_transport_cancel_pkt,
> >>>
> >>>          .dgram_enqueue            = virtio_transport_dgram_enqueue,
> >>> -        .dgram_dequeue            = virtio_transport_dgram_dequeue,
> >>>          .dgram_bind               = virtio_transport_dgram_bind,
> >>>          .dgram_allow              = virtio_transport_dgram_allow,
> >>> +        .dgram_get_cid          = virtio_transport_dgram_get_cid,
> >>> +        .dgram_get_port          = virtio_transport_dgram_get_port,
> >>> +        .dgram_get_length      = virtio_transport_dgram_get_length,
> >>>
> >>>          .stream_enqueue           = virtio_transport_stream_enqueue,
> >>>          .stream_dequeue           = virtio_transport_stream_dequeue,
> >>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> >>> index c58453699ee9..23521a318cf0 100644
> >>> --- a/include/linux/virtio_vsock.h
> >>> +++ b/include/linux/virtio_vsock.h
> >>> @@ -219,6 +219,9 @@ bool virtio_transport_stream_allow(u32 cid, u32 port);
> >>>  int virtio_transport_dgram_bind(struct vsock_sock *vsk,
> >>>                  struct sockaddr_vm *addr);
> >>>  bool virtio_transport_dgram_allow(u32 cid, u32 port);
> >>> +int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid);
> >>> +int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port);
> >>> +int virtio_transport_dgram_get_length(struct sk_buff *skb, size_t *len);
> >>>
> >>>  int virtio_transport_connect(struct vsock_sock *vsk);
> >>>
> >>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> >>> index 0e7504a42925..7bedb9ee7e3e 100644
> >>> --- a/include/net/af_vsock.h
> >>> +++ b/include/net/af_vsock.h
> >>> @@ -120,11 +120,20 @@ struct vsock_transport {
> >>>
> >>>      /* DGRAM. */
> >>>      int (*dgram_bind)(struct vsock_sock *, struct sockaddr_vm *);
> >>> -    int (*dgram_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
> >>> -                 size_t len, int flags);
> >>>      int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
> >>>                   struct msghdr *, size_t len);
> >>>      bool (*dgram_allow)(u32 cid, u32 port);
> >>> +    int (*dgram_get_cid)(struct sk_buff *skb, unsigned int *cid);
> >>> +    int (*dgram_get_port)(struct sk_buff *skb, unsigned int *port);
> >>> +    int (*dgram_get_length)(struct sk_buff *skb, size_t *length);
> >>> +
> >>> +    /* The number of bytes into the buffer at which the payload starts, as
> >>> +     * first seen by the receiving socket layer. For example, if the
> >>> +     * transport presets the skb pointers using skb_pull(sizeof(header))
> >>> +     * than this would be zero, otherwise it would be the size of the
> >>> +     * header.
> >>> +     */
> >>> +    const size_t dgram_payload_offset;
> >>>
> >>>      /* STREAM. */
> >>>      /* TODO: stream_bind() */
> >>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >>> index efb8a0937a13..ffb4dd8b6ea7 100644
> >>> --- a/net/vmw_vsock/af_vsock.c
> >>> +++ b/net/vmw_vsock/af_vsock.c
> >>> @@ -1271,11 +1271,15 @@ static int vsock_dgram_connect(struct socket *sock,
> >>>  int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> >>>              size_t len, int flags)
> >>>  {
> >>> +    const struct vsock_transport *transport;
> >>>  #ifdef CONFIG_BPF_SYSCALL
> >>>      const struct proto *prot;
> >>>  #endif
> >>>      struct vsock_sock *vsk;
> >>> +    struct sk_buff *skb;
> >>> +    size_t payload_len;
> >>>      struct sock *sk;
> >>> +    int err;
> >>>
> >>>      sk = sock->sk;
> >>>      vsk = vsock_sk(sk);
> >>> @@ -1286,7 +1290,52 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> >>>          return prot->recvmsg(sk, msg, len, flags, NULL);
> >>>  #endif
> >>>
> >>> -    return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
> >>> +    if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> >>> +        return -EOPNOTSUPP;
> >>> +
> >>> +    transport = vsk->transport;
> >>> +
> >>> +    /* Retrieve the head sk_buff from the socket's receive queue. */
> >>> +    err = 0;
> >>> +    skb = skb_recv_datagram(sk_vsock(vsk), flags, &err);
> >>> +    if (!skb)
> >>> +        return err;
> >>> +
> >>> +    err = transport->dgram_get_length(skb, &payload_len);
> > 
> > What about ssize_t return value here?
> > 
> > Or maybe a single callback that return both length and offset?
> > 
> > .dgram_get_payload_info(skb, &payload_len, &payload_off)
> 
> Just architectural question:
> 
> May be we can avoid this callback for length? IIUC concept of skbuff is that
> current level of network stack already have pointer to its data 'skb->data' and
> length of the payload 'skb->len' (both are set by previous stack handler - transport in
> this case), so here we can use just 'skb->len' and thats all. There is no need to ask
> lower level of network stack for length of payload? I see that VMCI stores metadata
> with payload in 'data' buffer, but may be it is more correctly to do 'skb_pull()'
> in vmci before inserting skbuff to sockets queue? In this case field with dgram payload
> offset could be removed from transport.
> 
> Thanks, Arseniy
> 

I agree, I think introducing the skb_pull() to vmci would honestly be
best. I don't think it should break anything based on my reading of the
code if it is called just prior to sk_receive_skb().


Thanks,
Bobby

> > 
> >>> +    if (err)
> >>> +        goto out;
> >>> +
> >>> +    if (payload_len > len) {
> >>> +        payload_len = len;
> >>> +        msg->msg_flags |= MSG_TRUNC;
> >>> +    }
> >>> +
> >>> +    /* Place the datagram payload in the user's iovec. */
> >>> +    err = skb_copy_datagram_msg(skb, transport->dgram_payload_offset, msg, payload_len);
> >>> +    if (err)
> >>> +        goto out;
> >>> +
> >>> +    if (msg->msg_name) {
> >>> +        /* Provide the address of the sender. */
> >>> +        DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> >>> +        unsigned int cid, port;
> >>> +
> >>> +        err = transport->dgram_get_cid(skb, &cid);
> >>> +        if (err)
> >>> +            goto out;
> >>> +
> >>> +        err = transport->dgram_get_port(skb, &port);
> >>> +        if (err)
> >>> +            goto out;
> >>
> >> Maybe we can merge 'dgram_get_cid' and 'dgram_get_port' to a single callback? Because I see that this is
> >> the only place where both are used (correct me if i'm wrong) and logically both operates with addresses:
> >> CID and port. E.g. something like that: dgram_get_cid_n_port().
> > 
> > What about .dgram_addr_init(struct sk_buff *skb, struct sockaddr_vm *addr)
> > and the transport can set cid and port?
> > 
> >>
> >> Moreover, I'm not sure, but is it good "tradeoff" here: remove transport specific callback for dgram receive
> >> where we already have 'msghdr' with both data buffer and buffer for 'sockaddr_vm' and instead of it add new
> >> several fields (callbacks) to transports like dgram_get_cid(), dgram_get_port()? I agree, that in each transport
> >> specific callback we will have same copying logic by calling 'skb_copy_datagram_msg()' and filling address
> >> by using 'vsock_addr_init()', but in this case we don't need to update transports too much. For example HyperV
> >> still unchanged as it does not support SOCK_DGRAM. For VMCI You just need to add 'vsock_addr_init()' logic
> >> to it's dgram dequeue callback.
> >>
> >> What do You think?
> > 
> > Honestly, I'd rather avoid duplicate code than reduce changes in
> > transports that don't support dgram.
> > 
> > One thing I do agree on though is minimizing the number of callbacks
> > to call to reduce the number of indirection (more performance?).
> > 
> > Thanks,
> > Stefano
> > 
> >>
> >> Thanks, Arseniy
> >>
> >>> +
> >>> +        vsock_addr_init(vm_addr, cid, port);
> >>> +        msg->msg_namelen = sizeof(*vm_addr);
> >>> +    }
> >>> +    err = payload_len;
> >>> +
> >>> +out:
> >>> +    skb_free_datagram(&vsk->sk, skb);
> >>> +    return err;
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
> >>>
> >>> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
> >>> index 7cb1a9d2cdb4..ff6e87e25fa0 100644
> >>> --- a/net/vmw_vsock/hyperv_transport.c
> >>> +++ b/net/vmw_vsock/hyperv_transport.c
> >>> @@ -556,8 +556,17 @@ static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)
> >>>      return -EOPNOTSUPP;
> >>>  }
> >>>
> >>> -static int hvs_dgram_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
> >>> -                 size_t len, int flags)
> >>> +static int hvs_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
> >>> +{
> >>> +    return -EOPNOTSUPP;
> >>> +}
> >>> +
> >>> +static int hvs_dgram_get_port(struct sk_buff *skb, unsigned int *port)
> >>> +{
> >>> +    return -EOPNOTSUPP;
> >>> +}
> >>> +
> >>> +static int hvs_dgram_get_length(struct sk_buff *skb, size_t *len)
> >>>  {
> >>>      return -EOPNOTSUPP;
> >>>  }
> >>> @@ -833,7 +842,9 @@ static struct vsock_transport hvs_transport = {
> >>>      .shutdown                 = hvs_shutdown,
> >>>
> >>>      .dgram_bind               = hvs_dgram_bind,
> >>> -    .dgram_dequeue            = hvs_dgram_dequeue,
> >>> +    .dgram_get_cid          = hvs_dgram_get_cid,
> >>> +    .dgram_get_port          = hvs_dgram_get_port,
> >>> +    .dgram_get_length      = hvs_dgram_get_length,
> >>>      .dgram_enqueue            = hvs_dgram_enqueue,
> >>>      .dgram_allow              = hvs_dgram_allow,
> >>>
> >>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> >>> index e95df847176b..5763cdf13804 100644
> >>> --- a/net/vmw_vsock/virtio_transport.c
> >>> +++ b/net/vmw_vsock/virtio_transport.c
> >>> @@ -429,9 +429,11 @@ static struct virtio_transport virtio_transport = {
> >>>          .cancel_pkt               = virtio_transport_cancel_pkt,
> >>>
> >>>          .dgram_bind               = virtio_transport_dgram_bind,
> >>> -        .dgram_dequeue            = virtio_transport_dgram_dequeue,
> >>>          .dgram_enqueue            = virtio_transport_dgram_enqueue,
> >>>          .dgram_allow              = virtio_transport_dgram_allow,
> >>> +        .dgram_get_cid          = virtio_transport_dgram_get_cid,
> >>> +        .dgram_get_port          = virtio_transport_dgram_get_port,
> >>> +        .dgram_get_length      = virtio_transport_dgram_get_length,
> >>>
> >>>          .stream_dequeue           = virtio_transport_stream_dequeue,
> >>>          .stream_enqueue           = virtio_transport_stream_enqueue,
> >>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> >>> index b769fc258931..e6903c719964 100644
> >>> --- a/net/vmw_vsock/virtio_transport_common.c
> >>> +++ b/net/vmw_vsock/virtio_transport_common.c
> >>> @@ -797,6 +797,24 @@ int virtio_transport_dgram_bind(struct vsock_sock *vsk,
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
> >>>
> >>> +int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
> >>> +{
> >>> +    return -EOPNOTSUPP;
> >>> +}
> >>> +EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_cid);
> >>> +
> >>> +int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
> >>> +{
> >>> +    return -EOPNOTSUPP;
> >>> +}
> >>> +EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_port);
> >>> +
> >>> +int virtio_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
> >>> +{
> >>> +    return -EOPNOTSUPP;
> >>> +}
> >>> +EXPORT_SYMBOL_GPL(virtio_transport_dgram_get_length);
> >>> +
> >>>  bool virtio_transport_dgram_allow(u32 cid, u32 port)
> >>>  {
> >>>      return false;
> >>> diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> >>> index b370070194fa..bbc63826bf48 100644
> >>> --- a/net/vmw_vsock/vmci_transport.c
> >>> +++ b/net/vmw_vsock/vmci_transport.c
> >>> @@ -1731,57 +1731,40 @@ static int vmci_transport_dgram_enqueue(
> >>>      return err - sizeof(*dg);
> >>>  }
> >>>
> >>> -static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
> >>> -                    struct msghdr *msg, size_t len,
> >>> -                    int flags)
> >>> +static int vmci_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid)
> >>>  {
> >>> -    int err;
> >>>      struct vmci_datagram *dg;
> >>> -    size_t payload_len;
> >>> -    struct sk_buff *skb;
> >>>
> >>> -    if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
> >>> -        return -EOPNOTSUPP;
> >>> +    dg = (struct vmci_datagram *)skb->data;
> >>> +    if (!dg)
> >>> +        return -EINVAL;
> >>>
> >>> -    /* Retrieve the head sk_buff from the socket's receive queue. */
> >>> -    err = 0;
> >>> -    skb = skb_recv_datagram(&vsk->sk, flags, &err);
> >>> -    if (!skb)
> >>> -        return err;
> >>> +    *cid = dg->src.context;
> >>> +    return 0;
> >>> +}
> >>> +
> >>> +static int vmci_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port)
> >>> +{
> >>> +    struct vmci_datagram *dg;
> >>>
> >>>      dg = (struct vmci_datagram *)skb->data;
> >>>      if (!dg)
> >>> -        /* err is 0, meaning we read zero bytes. */
> >>> -        goto out;
> >>> -
> >>> -    payload_len = dg->payload_size;
> >>> -    /* Ensure the sk_buff matches the payload size claimed in the packet. */
> >>> -    if (payload_len != skb->len - sizeof(*dg)) {
> >>> -        err = -EINVAL;
> >>> -        goto out;
> >>> -    }
> >>> +        return -EINVAL;
> >>>
> >>> -    if (payload_len > len) {
> >>> -        payload_len = len;
> >>> -        msg->msg_flags |= MSG_TRUNC;
> >>> -    }
> >>> +    *port = dg->src.resource;
> >>> +    return 0;
> >>> +}
> >>>
> >>> -    /* Place the datagram payload in the user's iovec. */
> >>> -    err = skb_copy_datagram_msg(skb, sizeof(*dg), msg, payload_len);
> >>> -    if (err)
> >>> -        goto out;
> >>> +static int vmci_transport_dgram_get_length(struct sk_buff *skb, size_t *len)
> >>> +{
> >>> +    struct vmci_datagram *dg;
> >>>
> >>> -    if (msg->msg_name) {
> >>> -        /* Provide the address of the sender. */
> >>> -        DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> >>> -        vsock_addr_init(vm_addr, dg->src.context, dg->src.resource);
> >>> -        msg->msg_namelen = sizeof(*vm_addr);
> >>> -    }
> >>> -    err = payload_len;
> >>> +    dg = (struct vmci_datagram *)skb->data;
> >>> +    if (!dg)
> >>> +        return -EINVAL;
> >>>
> >>> -out:
> >>> -    skb_free_datagram(&vsk->sk, skb);
> >>> -    return err;
> >>> +    *len = dg->payload_size;
> >>> +    return 0;
> >>>  }
> >>>
> >>>  static bool vmci_transport_dgram_allow(u32 cid, u32 port)
> >>> @@ -2040,9 +2023,12 @@ static struct vsock_transport vmci_transport = {
> >>>      .release = vmci_transport_release,
> >>>      .connect = vmci_transport_connect,
> >>>      .dgram_bind = vmci_transport_dgram_bind,
> >>> -    .dgram_dequeue = vmci_transport_dgram_dequeue,
> >>>      .dgram_enqueue = vmci_transport_dgram_enqueue,
> >>>      .dgram_allow = vmci_transport_dgram_allow,
> >>> +    .dgram_get_cid = vmci_transport_dgram_get_cid,
> >>> +    .dgram_get_port = vmci_transport_dgram_get_port,
> >>> +    .dgram_get_length = vmci_transport_dgram_get_length,
> >>> +    .dgram_payload_offset = sizeof(struct vmci_datagram),
> >>>      .stream_dequeue = vmci_transport_stream_dequeue,
> >>>      .stream_enqueue = vmci_transport_stream_enqueue,
> >>>      .stream_has_data = vmci_transport_stream_has_data,
> >>> diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> >>> index 5c6360df1f31..2f3cabc79ee5 100644
> >>> --- a/net/vmw_vsock/vsock_loopback.c
> >>> +++ b/net/vmw_vsock/vsock_loopback.c
> >>> @@ -62,9 +62,11 @@ static struct virtio_transport loopback_transport = {
> >>>          .cancel_pkt               = vsock_loopback_cancel_pkt,
> >>>
> >>>          .dgram_bind               = virtio_transport_dgram_bind,
> >>> -        .dgram_dequeue            = virtio_transport_dgram_dequeue,
> >>>          .dgram_enqueue            = virtio_transport_dgram_enqueue,
> >>>          .dgram_allow              = virtio_transport_dgram_allow,
> >>> +        .dgram_get_cid          = virtio_transport_dgram_get_cid,
> >>> +        .dgram_get_port          = virtio_transport_dgram_get_port,
> >>> +        .dgram_get_length      = virtio_transport_dgram_get_length,
> >>>
> >>>          .stream_dequeue           = virtio_transport_stream_dequeue,
> >>>          .stream_enqueue           = virtio_transport_stream_enqueue,
> >>>
> >>
> > 
