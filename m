Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC2E4D4766
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 13:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242193AbiCJM4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 07:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242183AbiCJM4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 07:56:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE70114A6ED
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 04:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646916900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o3uuvO9y1xNAcrDjYnTtQsNYybnuLDe1nLYUIuWqefY=;
        b=Dp6/evQHEidFPFuVzK2WTqW8EE8aFTIRqe7+L/oPXtVKp4r3KOMW3nS8q0cg9vrYrb6X5G
        Gd9fdf+nObgUttUOYvhzWopzZGKm0JkCWGEosjMBQj707lyM47JGjj8OqvcMTZis2+//YO
        6CK0DJxaeX2Z8RblgQGDjlajkFQKm+A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-OWQcwKxKNy2CjUG7Ib91nw-1; Thu, 10 Mar 2022 07:54:59 -0500
X-MC-Unique: OWQcwKxKNy2CjUG7Ib91nw-1
Received: by mail-wm1-f70.google.com with SMTP id 3-20020a05600c230300b00384e15ceae4so4024794wmo.7
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 04:54:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o3uuvO9y1xNAcrDjYnTtQsNYybnuLDe1nLYUIuWqefY=;
        b=19IYU/bGgN8Q7jsv1BwaHApHkOQAlWWmsXxGr6xfTSQGLWh4cSjAscgDzTYeITtHxb
         xTB5Jdjx5CWiBXUa8x+wvkXDJmGbcqcyJCXGijcKoeFww06XokIEP+PNCHn++1gLP7HR
         Iqd0uQT82dMSL7HZ8rARe8uYkWZmvDZxLhW5dWlxEMlZ+IJmjTX+vHSmo2SKi1nE0Isr
         VkCKHXEeegs94+Vl0hTNaBZEdE+o3tU8eWmLL+ZQvTEmsC7XCV3g7hy6pu03YPupCEJG
         YPf9Qji1xNp2QdPsmTx8QqR/qdfC1MyBuBndemrHOe/bgw2hUsX4el4DNGm76yYo2oPP
         bSNA==
X-Gm-Message-State: AOAM532CPiHjz18RkDrnayMOhUqJpQyHrdALiqWWLdoZFJamghx15Nuw
        qH9YLiwnbmcu7QFnX95zc3yd1AfVBdVh57mvaduzP42u2UPnMjJgkx4uEcTwtdfRAMXLEXvK0JV
        +OnHe+usNN7Nx
X-Received: by 2002:a05:600c:4307:b0:389:4f8f:f189 with SMTP id p7-20020a05600c430700b003894f8ff189mr3482148wme.29.1646916898732;
        Thu, 10 Mar 2022 04:54:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx4WtRMs4j8svdlHofO6NAwGUbSGfyjsdL481HZnIQ0bv2WpthcFijpLxcYQbLbVdijnTUBRA==
X-Received: by 2002:a05:600c:4307:b0:389:4f8f:f189 with SMTP id p7-20020a05600c430700b003894f8ff189mr3482124wme.29.1646916898425;
        Thu, 10 Mar 2022 04:54:58 -0800 (PST)
Received: from redhat.com ([2.53.27.107])
        by smtp.gmail.com with ESMTPSA id r12-20020a05600c2c4c00b003816932de9csm7606078wmg.24.2022.03.10.04.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 04:54:58 -0800 (PST)
Date:   Thu, 10 Mar 2022 07:54:54 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiyong Park <jiyong@google.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vsock: each transport cycles only on its own sockets
Message-ID: <20220310075421-mutt-send-email-mst@kernel.org>
References: <20220310124936.4179591-1-jiyong@google.com>
 <20220310124936.4179591-2-jiyong@google.com>
 <20220310075217-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310075217-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022 at 07:53:25AM -0500, Michael S. Tsirkin wrote:
> This message had 
> In-Reply-To: <20220310124936.4179591-1-jiyong@google.com>
> in its header but 20220310124936.4179591-2-jiyong@google.com was
> not sent to the list.
> Please don't do that. Instead, please write and send a proper
> cover letter. Thanks!
> 


Also, pls version in subject e.g. PATCH v2, and include
full changelog in the cover letter. Thanks!

> On Thu, Mar 10, 2022 at 09:49:35PM +0900, Jiyong Park wrote:
> > When iterating over sockets using vsock_for_each_connected_socket, make
> > sure that a transport filters out sockets that don't belong to the
> > transport.
> > 
> > There actually was an issue caused by this; in a nested VM
> > configuration, destroying the nested VM (which often involves the
> > closing of /dev/vhost-vsock if there was h2g connections to the nested
> > VM) kills not only the h2g connections, but also all existing g2h
> > connections to the (outmost) host which are totally unrelated.
> > 
> > Tested: Executed the following steps on Cuttlefish (Android running on a
> > VM) [1]: (1) Enter into an `adb shell` session - to have a g2h
> > connection inside the VM, (2) open and then close /dev/vhost-vsock by
> > `exec 3< /dev/vhost-vsock && exec 3<&-`, (3) observe that the adb
> > session is not reset.
> > 
> > [1] https://android.googlesource.com/device/google/cuttlefish/
> > 
> > Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> > Signed-off-by: Jiyong Park <jiyong@google.com>
> > ---
> >  drivers/vhost/vsock.c            | 4 ++++
> >  net/vmw_vsock/virtio_transport.c | 7 +++++++
> >  net/vmw_vsock/vmci_transport.c   | 5 +++++
> >  3 files changed, 16 insertions(+)
> > 
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index 37f0b4274113..853ddac00d5b 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -722,6 +722,10 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
> >  	 * executing.
> >  	 */
> >  
> > +	/* Only handle our own sockets */
> > +	if (vsk->transport != &vhost_transport.transport)
> > +		return;
> > +
> >  	/* If the peer is still valid, no need to reset connection */
> >  	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
> >  		return;
> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > index fb3302fff627..61b24eb31d4b 100644
> > --- a/net/vmw_vsock/virtio_transport.c
> > +++ b/net/vmw_vsock/virtio_transport.c
> > @@ -24,6 +24,7 @@
> >  static struct workqueue_struct *virtio_vsock_workqueue;
> >  static struct virtio_vsock __rcu *the_virtio_vsock;
> >  static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
> > +static struct virtio_transport virtio_transport; /* forward declaration */
> >  
> >  struct virtio_vsock {
> >  	struct virtio_device *vdev;
> > @@ -357,11 +358,17 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
> >  
> >  static void virtio_vsock_reset_sock(struct sock *sk)
> >  {
> > +	struct vsock_sock *vsk = vsock_sk(sk);
> > +
> >  	/* vmci_transport.c doesn't take sk_lock here either.  At least we're
> >  	 * under vsock_table_lock so the sock cannot disappear while we're
> >  	 * executing.
> >  	 */
> >  
> > +	/* Only handle our own sockets */
> > +	if (vsk->transport != &virtio_transport.transport)
> > +		return;
> > +
> >  	sk->sk_state = TCP_CLOSE;
> >  	sk->sk_err = ECONNRESET;
> >  	sk_error_report(sk);
> > diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> > index 7aef34e32bdf..cd2f01513fae 100644
> > --- a/net/vmw_vsock/vmci_transport.c
> > +++ b/net/vmw_vsock/vmci_transport.c
> > @@ -803,6 +803,11 @@ static void vmci_transport_handle_detach(struct sock *sk)
> >  	struct vsock_sock *vsk;
> >  
> >  	vsk = vsock_sk(sk);
> > +
> > +	/* Only handle our own sockets */
> > +	if (vsk->transport != &vmci_transport)
> > +		return;
> > +
> >  	if (!vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle)) {
> >  		sock_set_flag(sk, SOCK_DONE);
> >  
> > -- 
> > 2.35.1.723.g4982287a31-goog

