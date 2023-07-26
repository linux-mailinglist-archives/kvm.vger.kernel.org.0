Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A79C763DFC
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 19:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjGZR6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 13:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjGZR6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 13:58:15 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409F3121;
        Wed, 26 Jul 2023 10:58:14 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-686ea67195dso93725b3a.2;
        Wed, 26 Jul 2023 10:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690394293; x=1690999093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/YJKcaPv1jYD2cQZ5S5R7oRv+E2C9zFFFjCUSa+rubM=;
        b=mZkwf5zWFZeIiX0fU/UFJoxuzD6Wpz0HN320FewBuhVtwxAloF8LgDHfXgcir9p0PC
         8MJG0/wOnbUsKi3x+8GXQBKbfOc3xSVTh0FFc+hbGvcHnCuy5C1urw8JFc+6us72qneN
         LmC7sXZbmM2u2LneV6r4YKoEvdOHO/fUVsMSVsJXGkLtxNkxKwiPgWWARo0hF40tvt78
         haLNtRk22yTQaYRgwOCX+4ufOJCVVFLhb/Un8nU8QauRMy/cReIPd6u1bvbi84y+hwIE
         wVuwr6dOLd6OQ9nFPe9fEyS6D3DFhR2/JZc/0drGX3hJ+r1RLpQjni5AdAxm5VEBv6n4
         7y4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690394293; x=1690999093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/YJKcaPv1jYD2cQZ5S5R7oRv+E2C9zFFFjCUSa+rubM=;
        b=YqP+bc73BttZ377F5zvmVInanV19s55J0v/3teOMDghbHHK0L6KaKwqX/VbmI5yGxM
         9PnOXv5KXdwfR/kHo0bZFjMt+8zBy06dzJ5O/dnTm0lZgJsgd0K1YLYhBKJFf7slN+Eg
         WhZ9kJO1rG+3hAq8dYepFz3OeeeE0yk5hx5AHjgEulh/XA1FCdg1fG963ieX9ltVfrbp
         zI7kjyeskb9XrUBkOgwRqpQqY0nRe7hYexwoWAn5QQKX72rfhW0UORp+Sq+CIdCY2Qxd
         xZeXMNEoi0DWfSCLbdHGSTjcdx/5HfxPeCw29ZM4Fi8d+OkuTBPqxO4TOEIcCj63l+cB
         hQ/Q==
X-Gm-Message-State: ABy/qLa3dYZKw41xUL4NGKeELwqBvUSgLP6nINoBaYz4Ifgz3OlB5HHW
        ABusmEIJZ4loLkZE6nnxFBw=
X-Google-Smtp-Source: APBJJlEQ/e0rg4pmuw54TG3103tj5QD08hcsCxAgU3Pe0YQS/La3teWui75iq3R9z6H9ONChhtFm5Q==
X-Received: by 2002:a05:6a00:88b:b0:677:c9da:14b0 with SMTP id q11-20020a056a00088b00b00677c9da14b0mr3042053pfj.32.1690394293576;
        Wed, 26 Jul 2023 10:58:13 -0700 (PDT)
Received: from localhost (c-73-190-126-111.hsd1.wa.comcast.net. [73.190.126.111])
        by smtp.gmail.com with ESMTPSA id g20-20020a62e314000000b00672401787c6sm621035pfh.109.2023.07.26.10.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 10:58:13 -0700 (PDT)
Date:   Wed, 26 Jul 2023 17:58:12 +0000
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
Subject: Re: [PATCH RFC net-next v5 13/14] virtio/vsock: implement datagram
 support
Message-ID: <ZMFetBpO0OdzXtnK@bullseye>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-13-581bd37fdb26@bytedance.com>
 <adeed3a8-68fe-bdb7-e4a1-48044dbe5436@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adeed3a8-68fe-bdb7-e4a1-48044dbe5436@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 22, 2023 at 11:45:29AM +0300, Arseniy Krasnov wrote:
> 
> 
> On 19.07.2023 03:50, Bobby Eshleman wrote:
> > This commit implements datagram support for virtio/vsock by teaching
> > virtio to use the general virtio transport ->dgram_addr_init() function
> > and implementation a new version of ->dgram_allow().
> > 
> > Additionally, it drops virtio_transport_dgram_allow() as an exported
> > symbol because it is no longer used in other transports.
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > ---
> >  include/linux/virtio_vsock.h            |  1 -
> >  net/vmw_vsock/virtio_transport.c        | 24 +++++++++++++++++++++++-
> >  net/vmw_vsock/virtio_transport_common.c |  6 ------
> >  3 files changed, 23 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > index b3856b8a42b3..d0a4f08b12c1 100644
> > --- a/include/linux/virtio_vsock.h
> > +++ b/include/linux/virtio_vsock.h
> > @@ -211,7 +211,6 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
> >  u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
> >  bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
> >  bool virtio_transport_stream_allow(u32 cid, u32 port);
> > -bool virtio_transport_dgram_allow(u32 cid, u32 port);
> >  void virtio_transport_dgram_addr_init(struct sk_buff *skb,
> >  				      struct sockaddr_vm *addr);
> >  
> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > index ac2126c7dac5..713718861bd4 100644
> > --- a/net/vmw_vsock/virtio_transport.c
> > +++ b/net/vmw_vsock/virtio_transport.c
> > @@ -63,6 +63,7 @@ struct virtio_vsock {
> >  
> >  	u32 guest_cid;
> >  	bool seqpacket_allow;
> > +	bool dgram_allow;
> >  };
> >  
> >  static u32 virtio_transport_get_local_cid(void)
> > @@ -413,6 +414,7 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
> >  	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
> >  }
> >  
> > +static bool virtio_transport_dgram_allow(u32 cid, u32 port);
> 
> May be add body here? Without prototyping? Same for loopback and vhost.
> 

Sounds okay with me, but this seems to go against the pattern
established by seqpacket. Any reason why?

> >  static bool virtio_transport_seqpacket_allow(u32 remote_cid);
> >  
> >  static struct virtio_transport virtio_transport = {
> > @@ -430,6 +432,7 @@ static struct virtio_transport virtio_transport = {
> >  
> >  		.dgram_enqueue            = virtio_transport_dgram_enqueue,
> >  		.dgram_allow              = virtio_transport_dgram_allow,
> > +		.dgram_addr_init          = virtio_transport_dgram_addr_init,
> >  
> >  		.stream_dequeue           = virtio_transport_stream_dequeue,
> >  		.stream_enqueue           = virtio_transport_stream_enqueue,
> > @@ -462,6 +465,21 @@ static struct virtio_transport virtio_transport = {
> >  	.send_pkt = virtio_transport_send_pkt,
> >  };
> >  
> > +static bool virtio_transport_dgram_allow(u32 cid, u32 port)
> > +{
> > +	struct virtio_vsock *vsock;
> > +	bool dgram_allow;
> > +
> > +	dgram_allow = false;
> > +	rcu_read_lock();
> > +	vsock = rcu_dereference(the_virtio_vsock);
> > +	if (vsock)
> > +		dgram_allow = vsock->dgram_allow;
> > +	rcu_read_unlock();
> > +
> > +	return dgram_allow;
> > +}
> > +
> >  static bool virtio_transport_seqpacket_allow(u32 remote_cid)
> >  {
> >  	struct virtio_vsock *vsock;
> > @@ -655,6 +673,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> >  	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
> >  		vsock->seqpacket_allow = true;
> >  
> > +	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
> > +		vsock->dgram_allow = true;
> > +
> >  	vdev->priv = vsock;
> >  
> >  	ret = virtio_vsock_vqs_init(vsock);
> > @@ -747,7 +768,8 @@ static struct virtio_device_id id_table[] = {
> >  };
> >  
> >  static unsigned int features[] = {
> > -	VIRTIO_VSOCK_F_SEQPACKET
> > +	VIRTIO_VSOCK_F_SEQPACKET,
> > +	VIRTIO_VSOCK_F_DGRAM
> >  };
> >  
> >  static struct virtio_driver virtio_vsock_driver = {
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > index 96118e258097..77898f5325cd 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -783,12 +783,6 @@ bool virtio_transport_stream_allow(u32 cid, u32 port)
> >  }
> >  EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
> >  
> > -bool virtio_transport_dgram_allow(u32 cid, u32 port)
> > -{
> > -	return false;
> > -}
> > -EXPORT_SYMBOL_GPL(virtio_transport_dgram_allow);
> > -
> >  int virtio_transport_connect(struct vsock_sock *vsk)
> >  {
> >  	struct virtio_vsock_pkt_info info = {
> > 
> 
> Thanks, Arseniy

Thanks,
Bobby
