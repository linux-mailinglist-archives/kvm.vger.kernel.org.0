Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A234B4D47E9
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 14:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242344AbiCJNSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 08:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235049AbiCJNSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 08:18:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BE7914D27A
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 05:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646918229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ipKGAsfvx4KvpIaltnSTRpTCF3Z+heVHYCt28YT0aF0=;
        b=MjiK7V/PK/wsj785pj1t2C218eqemqT1Q+VbGD+cUMuLL3ny+ug/k0dxf7q/2MkCdM0aXk
        xVM+ycRF8k23UVx1QtBQEVmslEg7jkCnjRZUYl8pP55MZYRN1nkgPve2cUUvC+U08gJ/e3
        NBQF24EaptJbCRd5SFYbMOnIFVhMH40=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-qjUxPVZ_Mh6Ih3nCNXZN9A-1; Thu, 10 Mar 2022 08:17:06 -0500
X-MC-Unique: qjUxPVZ_Mh6Ih3nCNXZN9A-1
Received: by mail-wm1-f71.google.com with SMTP id o21-20020a05600c511500b003818c4b98b5so2095255wms.0
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 05:17:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ipKGAsfvx4KvpIaltnSTRpTCF3Z+heVHYCt28YT0aF0=;
        b=Tu31DxfWpzGN3l09tAzyJP+hj40br46uFbJejuD7WYxoy1Do772o8hz3/jXU9n5ib1
         b248E2GHVgJtC8ujoqFFR2LtVH3nP+qNa9TcH8X9bpYf+imxWHIgKYQQp7dXvTF5s3jx
         8S5Gx4lXSfvXFZ05GgeMvjmIfq28H2xDkZqSxCzBr9a+UgIVADlU3ojYkXDvJG6gbWVF
         lJ/hvx4jYvgru0EMWN+WGqexJ5qY9j9boIQTbj3Koa2anEA7XHHpAPs0bzt2SaBdOdVe
         tWXZPKCAIPhrZAjK/tbXnO/wyruhZKP7svKjYp2wz7W4EAGEFcEIB0jY74twRpnQTT6m
         ZkQA==
X-Gm-Message-State: AOAM53109YRv8gine0L94MYycl+qUlt/cU4asXjZbWBVCyOK/bg4n+FR
        m5280eWbTIkgG2sXWszd/YTXZiR+HR6oFP2PhsU5REQdkEKmdwdxghWcRYuqiYEt3NOWroQ9fBZ
        zmoGxO6lUf9c+
X-Received: by 2002:a5d:4dc4:0:b0:1ef:7aa9:5a8e with SMTP id f4-20020a5d4dc4000000b001ef7aa95a8emr3512622wru.168.1646918224884;
        Thu, 10 Mar 2022 05:17:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwnYu6RJxPUA0EkhT6wRJxsIiquTBvA0erpSRnIdz5JOuNjFwG8/Nf2GIWfELU/w+shXdZ1mw==
X-Received: by 2002:a5d:4dc4:0:b0:1ef:7aa9:5a8e with SMTP id f4-20020a5d4dc4000000b001ef7aa95a8emr3512596wru.168.1646918224550;
        Thu, 10 Mar 2022 05:17:04 -0800 (PST)
Received: from redhat.com ([2.53.27.107])
        by smtp.gmail.com with ESMTPSA id d8-20020a056000114800b001f045f3435asm5758437wrx.108.2022.03.10.05.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 05:17:04 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:16:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiyong Park <jiyong@google.com>
Cc:     sgarzare@redhat.com, stefanha@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kuba@kernel.org, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vsock: each transport cycles only on its own sockets
Message-ID: <20220310081458-mutt-send-email-mst@kernel.org>
References: <20220310125425.4193879-1-jiyong@google.com>
 <20220310125425.4193879-2-jiyong@google.com>
 <20220310075933-mutt-send-email-mst@kernel.org>
 <CALeUXe4V=6WhavV5d0XN_EjtZ9=0_5rD9ZfvQ77M1W4HpYh_2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALeUXe4V=6WhavV5d0XN_EjtZ9=0_5rD9ZfvQ77M1W4HpYh_2Q@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022 at 10:11:32PM +0900, Jiyong Park wrote:
> Hi Michael,
> 
> Thanks for looking into this.
> 
> Would you mind if I ask what you mean by incomplete? Is it because non-updated
> modules will still have the issue? Please elaborate.

What stefano wrote:
	I think there is the same problem if the g2h driver will be
	unloaded (or a reset event is received after a VM migration), it will close
	all sockets of the nested h2g.
looks like this will keep happening even with your patch, though
I didn't try.

I also don't like how patch 1 adds code that patch 2 removes. Untidy.
Let's just squash and have downstreams worry about stable ABI.


> 
> On Thu, Mar 10, 2022 at 10:02 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Mar 10, 2022 at 09:54:24PM +0900, Jiyong Park wrote:
> > > When iterating over sockets using vsock_for_each_connected_socket, make
> > > sure that a transport filters out sockets that don't belong to the
> > > transport.
> > >
> > > There actually was an issue caused by this; in a nested VM
> > > configuration, destroying the nested VM (which often involves the
> > > closing of /dev/vhost-vsock if there was h2g connections to the nested
> > > VM) kills not only the h2g connections, but also all existing g2h
> > > connections to the (outmost) host which are totally unrelated.
> > >
> > > Tested: Executed the following steps on Cuttlefish (Android running on a
> > > VM) [1]: (1) Enter into an `adb shell` session - to have a g2h
> > > connection inside the VM, (2) open and then close /dev/vhost-vsock by
> > > `exec 3< /dev/vhost-vsock && exec 3<&-`, (3) observe that the adb
> > > session is not reset.
> > >
> > > [1] https://android.googlesource.com/device/google/cuttlefish/
> > >
> > > Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> > > Signed-off-by: Jiyong Park <jiyong@google.com>
> > > ---
> > >  drivers/vhost/vsock.c            | 4 ++++
> > >  net/vmw_vsock/virtio_transport.c | 7 +++++++
> > >  net/vmw_vsock/vmci_transport.c   | 5 +++++
> > >  3 files changed, 16 insertions(+)
> > >
> > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > index 37f0b4274113..853ddac00d5b 100644
> > > --- a/drivers/vhost/vsock.c
> > > +++ b/drivers/vhost/vsock.c
> > > @@ -722,6 +722,10 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
> > >        * executing.
> > >        */
> > >
> > > +     /* Only handle our own sockets */
> > > +     if (vsk->transport != &vhost_transport.transport)
> > > +             return;
> > > +
> > >       /* If the peer is still valid, no need to reset connection */
> > >       if (vhost_vsock_get(vsk->remote_addr.svm_cid))
> > >               return;
> >
> >
> > We know this is incomplete though. So I think it's the wrong thing to do
> > when you backport, too. If all you worry about is breaking a binary
> > module interface, how about simply exporting a new function when you
> > backport. Thus you will have downstream both:
> >
> > void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
> >
> > void vsock_for_each_connected_socket_new(struct vsock_transport *transport,
> >                                     void (*fn)(struct sock *sk));
> >
> >
> > and then upstream we can squash these two patches.
> >
> > Hmm?
> >
> >
> > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > > index fb3302fff627..61b24eb31d4b 100644
> > > --- a/net/vmw_vsock/virtio_transport.c
> > > +++ b/net/vmw_vsock/virtio_transport.c
> > > @@ -24,6 +24,7 @@
> > >  static struct workqueue_struct *virtio_vsock_workqueue;
> > >  static struct virtio_vsock __rcu *the_virtio_vsock;
> > >  static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
> > > +static struct virtio_transport virtio_transport; /* forward declaration */
> > >
> > >  struct virtio_vsock {
> > >       struct virtio_device *vdev;
> > > @@ -357,11 +358,17 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
> > >
> > >  static void virtio_vsock_reset_sock(struct sock *sk)
> > >  {
> > > +     struct vsock_sock *vsk = vsock_sk(sk);
> > > +
> > >       /* vmci_transport.c doesn't take sk_lock here either.  At least we're
> > >        * under vsock_table_lock so the sock cannot disappear while we're
> > >        * executing.
> > >        */
> > >
> > > +     /* Only handle our own sockets */
> > > +     if (vsk->transport != &virtio_transport.transport)
> > > +             return;
> > > +
> > >       sk->sk_state = TCP_CLOSE;
> > >       sk->sk_err = ECONNRESET;
> > >       sk_error_report(sk);
> > > diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> > > index 7aef34e32bdf..cd2f01513fae 100644
> > > --- a/net/vmw_vsock/vmci_transport.c
> > > +++ b/net/vmw_vsock/vmci_transport.c
> > > @@ -803,6 +803,11 @@ static void vmci_transport_handle_detach(struct sock *sk)
> > >       struct vsock_sock *vsk;
> > >
> > >       vsk = vsock_sk(sk);
> > > +
> > > +     /* Only handle our own sockets */
> > > +     if (vsk->transport != &vmci_transport)
> > > +             return;
> > > +
> > >       if (!vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle)) {
> > >               sock_set_flag(sk, SOCK_DONE);
> > >
> > > --
> > > 2.35.1.723.g4982287a31-goog
> >

