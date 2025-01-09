Return-Path: <kvm+bounces-34908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE85A0743F
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 12:10:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 528BD1685A5
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 11:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CCF0216602;
	Thu,  9 Jan 2025 11:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b="UgLiaiih"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F102B21638C
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 11:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736421021; cv=none; b=uirLQM3NAfEXc2jddl4DGdmKZjmWBKV7hC1vobNfl+0HtTYwwzHKVUpX1M/0zjssBJtHBNGDVGywzqVnWDlcqWJJr7lgemfpGxtmI7924dlYe0IRobQVB/PEEcAk2kCXjop85vhF/qWeGMOwZf9rYmLlJH5OlOVFTHT82YVNHag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736421021; c=relaxed/simple;
	bh=UUeZRcbvFQU0IU5zd+krxlu/oPz539Cj6HEwFZKEK0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TpQhNAr8tbIQElZGjoQgeoLDufw1meXVC6cD+G9W1NCT4HKn9i+/cSxtmq0Yaz+imTtAjndvp6A+FlEGL0YwPk2YpkrNn7vHqf6adWxsjBOtCgsIwl+eey0xYkDRaVniepdwoJLZE2XCMK62S4FB67rA2Z7m9cQFU8WXJSbse/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io; spf=pass smtp.mailfrom=theori.io; dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b=UgLiaiih; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=theori.io
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-216395e151bso9311255ad.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 03:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google; t=1736421018; x=1737025818; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7+ljKu7GZzEGvp6RrMbhl8PlBYJNNWnzxd6tP/33TRU=;
        b=UgLiaiih3C9M3r+V4I9ArJ7mNSvM0PMgwrjt9aFi3nB+IpT8p9CeewHO+v+ENO+Lu4
         PeYHG4joDaCLcLvTHG1jt9mdv0rUwZqa7sQAWMAmf2+3bCjsb4E3METP0x8TscIE43jT
         C5/UZ0l0nEYoMI3oIhgb2vte9aValpoHhrq3s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736421018; x=1737025818;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+ljKu7GZzEGvp6RrMbhl8PlBYJNNWnzxd6tP/33TRU=;
        b=V3YUrxTMJf1Y6yO1QNVueIEg7jkJZmW1lG2qVbCoyIqZsD1Gob3MsBiv6puoHitWRj
         mSkNmqxXn9+bupcxOyQcxr37lEPge4iFsiQ3gwA0yGhqPsYq/yINujzCfSDJbzj8tL2J
         noDfQ7MWDN9j0ned1AkaLTWb3LhuPKHIfh2jcURkIXp7DvrkBGFrv2Haqlp49vW/iqJO
         RJidoC8mTVpKGmmH3E/WmXS/kz4MCQjBvJG5pDBq0fK+NVgNEbKSCAKfp/VSbOKNgTcQ
         JghIpgTQ6P6MbOWiK5v2OmKHCOai5uYgqPrF/YM8ZIFEl+A9+5J/GrUvPVixsY0YW/X2
         rZog==
X-Forwarded-Encrypted: i=1; AJvYcCWfqqnorrntvnU+c2tbVx8qF/S5fQ/HHW+NRQodBsCplFXipIVqhowIfYTj4glYnN/kwfA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrJzUW8DpOJs2mE2+8ynRv0Q55EZJ2hD3nCCEnsYuHNZFZwbmr
	SMEotC/dKjaIHqmYIFnKMx4+6ddJpfs0NHjs167BoHH914gCkR29iZ/pAmE0AxM=
X-Gm-Gg: ASbGncsIxbj9otdls5FbC9Zl5oRYS26vCYEghPXUMvyIOUy6+gSSV4k4kWHgoiAJl3d
	IdPN8Kuak01kQTZRmOQRFDVSyJ0yKji8/Q0kyXx/yjdinEJKshl0fELf7Lghxrffj/2pfW5XJ8q
	1iA4gSgUPKVK4vjvjIfGsWAUOBON5tMUABDcG1WNvPlJKMgpHcjDegOrb41PTjHnFJmorlUb+Pe
	iEOmgB4ngdVZaCSOvnZb6NLeBJfvVy5bOWrN2ovmghVkPJJywiNoLIrsGc2Ah5jsuPqeA==
X-Google-Smtp-Source: AGHT+IE6kHjF6VMW7zKKnf4D3URfl2Zhbkt1AYg7UxtWOKnbCc5MRKenY3iXJIlmvTUmO1+DA+iBUw==
X-Received: by 2002:a17:903:2a90:b0:216:1079:82bb with SMTP id d9443c01a7336-21a8d6c7c8cmr46825095ad.19.1736421018208;
        Thu, 09 Jan 2025 03:10:18 -0800 (PST)
Received: from v4bel-B760M-AORUS-ELITE-AX ([211.219.71.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a91767dd4sm10210695ad.23.2025.01.09.03.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 03:10:17 -0800 (PST)
Date: Thu, 9 Jan 2025 06:10:10 -0500
From: Hyunwoo Kim <v4bel@theori.io>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Wongi Lee <qwerty@theori.io>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>,
	virtualization@lists.linux.dev,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>, bpf@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>, Michal Luczaj <mhal@rbox.co>,
	kvm@vger.kernel.org, imv4bel@gmail.com, v4bel@theori.io
Subject: Re: [PATCH net 1/2] vsock/virtio: discard packets if the transport
 changes
Message-ID: <Z3+ukoUBYp5VVXRX@v4bel-B760M-AORUS-ELITE-AX>
References: <20250108180617.154053-1-sgarzare@redhat.com>
 <20250108180617.154053-2-sgarzare@redhat.com>
 <Z37Sh+utS+iV3+eb@v4bel-B760M-AORUS-ELITE-AX>
 <77plpkw3mp4r3ue4ubmh4yhqfo777koiu65dqfqfxmjgc5uq57@aifi6mhtgtuj>
 <Z3+TSNfTJr2X8oQV@v4bel-B760M-AORUS-ELITE-AX>
 <x3gyqgbor4syfy56j5qolppiec3du4hbkywncmlipt2sw6bp46@vtk4apoy7w3o>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x3gyqgbor4syfy56j5qolppiec3du4hbkywncmlipt2sw6bp46@vtk4apoy7w3o>

On Thu, Jan 09, 2025 at 11:59:21AM +0100, Stefano Garzarella wrote:
> On Thu, Jan 09, 2025 at 04:13:44AM -0500, Hyunwoo Kim wrote:
> > On Thu, Jan 09, 2025 at 10:01:31AM +0100, Stefano Garzarella wrote:
> > > On Wed, Jan 08, 2025 at 02:31:19PM -0500, Hyunwoo Kim wrote:
> > > > On Wed, Jan 08, 2025 at 07:06:16PM +0100, Stefano Garzarella wrote:
> > > > > If the socket has been de-assigned or assigned to another transport,
> > > > > we must discard any packets received because they are not expected
> > > > > and would cause issues when we access vsk->transport.
> > > > >
> > > > > A possible scenario is described by Hyunwoo Kim in the attached link,
> > > > > where after a first connect() interrupted by a signal, and a second
> > > > > connect() failed, we can find `vsk->transport` at NULL, leading to a
> > > > > NULL pointer dereference.
> > > > >
> > > > > Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> > > > > Reported-by: Hyunwoo Kim <v4bel@theori.io>
> > > > > Reported-by: Wongi Lee <qwerty@theori.io>
> > > > > Closes: https://lore.kernel.org/netdev/Z2LvdTTQR7dBmPb5@v4bel-B760M-AORUS-ELITE-AX/
> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > > ---
> > > > >  net/vmw_vsock/virtio_transport_common.c | 7 +++++--
> > > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > > > > index 9acc13ab3f82..51a494b69be8 100644
> > > > > --- a/net/vmw_vsock/virtio_transport_common.c
> > > > > +++ b/net/vmw_vsock/virtio_transport_common.c
> > > > > @@ -1628,8 +1628,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> > > > >
> > > > >  	lock_sock(sk);
> > > > >
> > > > > -	/* Check if sk has been closed before lock_sock */
> > > > > -	if (sock_flag(sk, SOCK_DONE)) {
> > > > > +	/* Check if sk has been closed or assigned to another transport before
> > > > > +	 * lock_sock (note: listener sockets are not assigned to any transport)
> > > > > +	 */
> > > > > +	if (sock_flag(sk, SOCK_DONE) ||
> > > > > +	    (sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {
> > > >
> > > > If a race scenario with vsock_listen() is added to the existing
> > > > race scenario, the patch can be bypassed.
> > > >
> > > > In addition to the existing scenario:
> > > > ```
> > > >                     cpu0                                                      cpu1
> > > >
> > > >                                                               socket(A)
> > > >
> > > >                                                               bind(A, {cid: VMADDR_CID_LOCAL, port: 1024})
> > > >                                                                 vsock_bind()
> > > >
> > > >                                                               listen(A)
> > > >                                                                 vsock_listen()
> > > >  socket(B)
> > > >
> > > >  connect(B, {cid: VMADDR_CID_LOCAL, port: 1024})
> > > >    vsock_connect()
> > > >      lock_sock(sk);
> > > >      virtio_transport_connect()
> > > >        virtio_transport_connect()
> > > >          virtio_transport_send_pkt_info()
> > > >            vsock_loopback_send_pkt(VIRTIO_VSOCK_OP_REQUEST)
> > > >              queue_work(vsock_loopback_work)
> > > >      sk->sk_state = TCP_SYN_SENT;
> > > >      release_sock(sk);
> > > >                                                               vsock_loopback_work()
> > > >                                                                 virtio_transport_recv_pkt(VIRTIO_VSOCK_OP_REQUEST)
> > > >                                                                   sk = vsock_find_bound_socket(&dst);
> > > >                                                                   virtio_transport_recv_listen(sk, skb)
> > > >                                                                     child = vsock_create_connected(sk);
> > > >                                                                     vsock_assign_transport()
> > > >                                                                       vvs = kzalloc(sizeof(*vvs), GFP_KERNEL);
> > > >                                                                     vsock_insert_connected(vchild);
> > > >                                                                       list_add(&vsk->connected_table, list);
> > > >                                                                     virtio_transport_send_response(vchild, skb);
> > > >                                                                       virtio_transport_send_pkt_info()
> > > >                                                                         vsock_loopback_send_pkt(VIRTIO_VSOCK_OP_RESPONSE)
> > > >                                                                           queue_work(vsock_loopback_work)
> > > >
> > > >                                                               vsock_loopback_work()
> > > >                                                                 virtio_transport_recv_pkt(VIRTIO_VSOCK_OP_RESPONSE)
> > > >                                                                   sk = vsock_find_bound_socket(&dst);
> > > >                                                                   lock_sock(sk);
> > > >                                                                   case TCP_SYN_SENT:
> > > >                                                                   virtio_transport_recv_connecting()
> > > >                                                                     sk->sk_state = TCP_ESTABLISHED;
> > > >                                                                   release_sock(sk);
> > > >
> > > >                                                               kill(connect(B));
> > > >      lock_sock(sk);
> > > >      if (signal_pending(current)) {
> > > >      sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
> > > >      sock->state = SS_UNCONNECTED;    // [1]
> > > >      release_sock(sk);
> > > >
> > > >  connect(B, {cid: VMADDR_CID_HYPERVISOR, port: 1024})
> > > >    vsock_connect(B)
> > > >      lock_sock(sk);
> > > >      vsock_assign_transport()
> > > >        virtio_transport_release()
> > > >          virtio_transport_close()
> > > >            if (!(sk->sk_state == TCP_ESTABLISHED || sk->sk_state == TCP_CLOSING))
> > > >            virtio_transport_shutdown()
> > > >              virtio_transport_send_pkt_info()
> > > >                vsock_loopback_send_pkt(VIRTIO_VSOCK_OP_SHUTDOWN)
> > > >                  queue_work(vsock_loopback_work)
> > > >            schedule_delayed_work(&vsk->close_work, VSOCK_CLOSE_TIMEOUT);	// [5]
> > > >        vsock_deassign_transport()
> > > >          vsk->transport = NULL;
> > > >        return -ESOCKTNOSUPPORT;
> > > >      release_sock(sk);
> > > >                                                               vsock_loopback_work()
> > > >                                                                 virtio_transport_recv_pkt(VIRTIO_VSOCK_OP_SHUTDOWN)
> > > >                                                                   virtio_transport_recv_connected()
> > > >                                                                     virtio_transport_reset()
> > > >                                                                       virtio_transport_send_pkt_info()
> > > >                                                                         vsock_loopback_send_pkt(VIRTIO_VSOCK_OP_RST)
> > > >                                                                           queue_work(vsock_loopback_work)
> > > >  listen(B)
> > > >    vsock_listen()
> > > >      if (sock->state != SS_UNCONNECTED)    // [2]
> > > >      sk->sk_state = TCP_LISTEN;    // [3]
> > > >
> > > >                                                               vsock_loopback_work()
> > > >                                                                 virtio_transport_recv_pkt(VIRTIO_VSOCK_OP_RST)
> > > > 								   if ((sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {    // [4]
> > > > 								   ...
> > > > 							
> > > >  virtio_transport_close_timeout()
> > > >    virtio_transport_do_close()
> > > >      vsock_stream_has_data()
> > > >        return vsk->transport->stream_has_data(vsk);    // null-ptr-deref
> > > >
> > > > ```
> > > > (Yes, This is quite a crazy scenario, but it can actually be induced)
> > > >
> > > > Since sock->state is set to SS_UNCONNECTED during the first connect()[1],
> > > > it can pass the sock->state check[2] in vsock_listen() and set
> > > > sk->sk_state to TCP_LISTEN[3].
> > > > If this happens, the check in the patch with
> > > > `sk->sk_state != TCP_LISTEN` will pass[4], and a null-ptr-deref can
> > > > still occur.)
> > > >
> > > > More specifically, because the sk_state has changed to TCP_LISTEN,
> > > > virtio_transport_recv_disconnecting() will not be called by the
> > > > loopback worker. However, a null-ptr-deref may occur in
> > > > virtio_transport_close_timeout(), which is scheduled by
> > > > virtio_transport_close() called in the flow of the second connect()[5].
> > > > (The patch no longer cancels the virtio_transport_close_timeout() worker)
> > > >
> > > > And even if the `sk->sk_state != TCP_LISTEN` check is removed from the
> > > > patch, it seems that a null-ptr-deref will still occur due to
> > > > virtio_transport_close_timeout().
> > > > It might be necessary to add worker cancellation at the
> > > > appropriate location.
> > > 
> > > Thanks for the analysis!
> > > 
> > > Do you have time to cook a proper patch to cover this scenario?
> > > Or we should mix this fix together with your patch (return 0 in
> > > vsock_stream_has_data()) while we investigate a better handling?
> > 
> > For now, it seems better to merge them together.
> 
> Okay, since both you and Michael agree on that, I'll include your changes in
> this series, but adding a warning message, since it should not happen.
> 
> Is that fine with you?

Yes, I agree.

> 
> > 
> > It seems that covering this scenario will require more analysis and
> > testing.
> 
> Yeah, scheduling a task during the release is tricky, especially when we are
> changing the transport, so I think we should handle that better.
> 
> One idea that I have it to cancel delayed works in
> virtio_transport_destruct(), I'll test it a bit and add a patch for that in
> the next version of this series.

OK. once the patch is submitted, I will review it.

> 
> We also need to reset SOCK_DONE after changing the transports.
> 
> Thanks,
> Stefano
> 

