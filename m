Return-Path: <kvm+bounces-64889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FCC6C8F858
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4A5D7354C2E
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 16:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DD42D97BD;
	Thu, 27 Nov 2025 16:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZwrZnlr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782F42D77F1
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 16:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764261191; cv=none; b=fQ5qC7Cv30N+U7rH59HMWB0vjynB9OqV7x5+082L5A2VFW54bM+tqROy+wlg0XFy5cDDh5+jcrJxdgCgu5uCxUbTmu85crud/3uI0ayFH55RnJRySBy7Dp46D1LqJ7M9aR08Inx1MpwIG6Pwzrn3REwyhtSXYsGG7P2ztvy+kaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764261191; c=relaxed/simple;
	bh=MnKx0TGQoH2FUa9xP9Z7VF4P4kRP54jP0QM23r1vQ8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DhyOq1yjlb1YE9g+8dOnF9unMUUgXNXQne2O4m5b6FhHoLBZL8XEyIn/fKk1rCejCo8tEHXD2ODJwAzcSKfW4LkroHC6CDeIi1gCmSoUe6tjS8tzWZHQGIZhgdKE0dRTxy//UXXilPh73oQruqJxF8bqdxnjDYWggAPv8OAYXfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cZwrZnlr; arc=none smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6430834244aso789894d50.2
        for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 08:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764261187; x=1764865987; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NLkQ9mjek5IFuuUNhN4vly0jCNui++KbFNXB7GjATe8=;
        b=cZwrZnlri6XlhVMvFhnAQgJhgVWCFrga3iSIm/rqEpv5a4M7PuXaKUM5byMAFhcSCX
         65V/yb9hWIXjgFiuNIT/YJiaUEiMj3BtFceOZPCXQIejpTbgQTE9o+uSG0cwWpTLsNhK
         COhrb9lkXBkQE3XfzAiGKVFESzoJNkMm8kA3B2UQ34AzA1nobMqOc/gUAr9uR8zNBJvn
         1N2RM34pPZNWfxATnAeRwrR1ueqTaiFBJSvkgOr9FLigbWXLHf6HLO0If0ABofLdyuiw
         KwrYqMnOlgDptt0roxmZ4L5U4Jqbq8gHobjkLiqcKahqiCzr2AXk+J2e8o+ZUBLIjo1x
         L6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764261187; x=1764865987;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NLkQ9mjek5IFuuUNhN4vly0jCNui++KbFNXB7GjATe8=;
        b=n7qDcGbSc1P5nwbKZMVz4TfRd1uaMos787SVtp4qwRcH0PX6h1F6OWRI3HERP6Bsmp
         rswjQDZXjaX8epWw14eGRiD5YcPbBdk06/xJidEi47sEjbrAZN9yMaeq+V089LdwaQX8
         EoRfBirRf8Nb1E3jxW3bAoR5rXWfSijmFciDYhwkChyUZe/H29jmrRvwWqDpjYYiPlDw
         txMJbN/P1LOrQEJmDKVipXGM5QDs7ZUYRHFb3R+HrSifyQZlbpE06ssgUGYXW9cmQzsI
         A8GOWa/Mej9Rz3FExiLof57C7KRk6YvVBRplL8WS172QbNuWa7PE8Rn5RUVv+ubM06pw
         wRNg==
X-Forwarded-Encrypted: i=1; AJvYcCXw5UyCpjJyZjGAtkBwTL03MvtTXPPLw799d3ekwP7uJVNj3Nyl0QrqBXMKeqDKU+ycX1E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzklu/enOoTjhx3yx8YXkrOVLc39PegpwjMef+/pTgCPLkbsUsS
	Ufnipet7tynxwHl/7EaOE92Cn1uYLAlSUHCp1m/GC0rqU3oeycxpzjlV
X-Gm-Gg: ASbGncv2kgPlG6otFBVmhQHXIsV1Vaff/dyf15D7wpW7Z6ExQt2sob2EaVWzPuxM68U
	ijjPSCVwbP9fMn+H3kyMcr0b9DH2P7JLc+wmryIXFfnBymVjCaJ+ejlB0VBx9NHUyEsY0bL9yi8
	tvorgzM0gN7A/8GcddskEsIWkf0Grl+695J/FR91ycX4B0oG0iYsXIAqITBMzOendPl7VMEXHLZ
	/p4MkaqJEC7t6rnCbWCkR+7EwN/30lDkY22gMxJmmfeDUbDE91sgPNiwK+EOxrU4G5aDVzVXOG5
	QjwUHox/QYMRj77+739Iz3t6K+dCbnSh0xwTqXrqI1Ihn9/5VOJ+/qdvQ7y5xSXDmPTzqYO5H2z
	4ncne+jNuHKaP4R9w5HZbrHE6j0wawk65isQKUQPExlnKd+MyVi9eqaaW+knSEdHMJh3juLs6BJ
	KbYyT3fbtjrYyVRy3l/8MZSuRGGm1/okCd2b3LW5o8aXJyReAZXhaDUAKoog==
X-Google-Smtp-Source: AGHT+IFtQb93BI4nOdT1XLTFUuCFPL/VIC2PZ4x09Wo+rKazRZ0bNp0sq4na1MhyEwURoWY9j6bB4A==
X-Received: by 2002:a05:690e:1884:b0:643:2dc2:da47 with SMTP id 956f58d0204a3-6432dc2db5cmr6271850d50.58.1764261187305;
        Thu, 27 Nov 2025 08:33:07 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:49::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6433c050d98sm650602d50.2.2025.11.27.08.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 08:33:06 -0800 (PST)
Date: Thu, 27 Nov 2025 08:33:05 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kselftest@vger.kernel.org, berrange@redhat.com,
	Sargun Dhillon <sargun@sargun.me>,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v12 02/12] vsock: add netns to vsock core
Message-ID: <aSh9Qdsxl1Ot8byP@devvm11784.nha0.facebook.com>
References: <20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com>
 <20251126-vsock-vmtest-v12-2-257ee21cd5de@meta.com>
 <hgz3rtpb3lvxzbygye6ziobfujfsl2yefh5t3ghrbbbknr6eis@ypifkm24ygja>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hgz3rtpb3lvxzbygye6ziobfujfsl2yefh5t3ghrbbbknr6eis@ypifkm24ygja>

On Thu, Nov 27, 2025 at 03:25:32PM +0100, Stefano Garzarella wrote:
> On Wed, Nov 26, 2025 at 11:47:31PM -0800, Bobby Eshleman wrote:
> > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > 
> > Add netns logic to vsock core. Additionally, modify transport hook
> > prototypes to be used by later transport-specific patches (e.g.,
> > *_seqpacket_allow()).
> > 
> > Namespaces are supported primarily by changing socket lookup functions
> > (e.g., vsock_find_connected_socket()) to take into account the socket
> > namespace and the namespace mode before considering a candidate socket a
> > "match".
> > 
> > This patch also introduces the sysctl /proc/sys/net/vsock/ns_mode that
> > accepts the "global" or "local" mode strings.
> > 
> > Add netns functionality (initialization, passing to transports, procfs,
> > etc...) to the af_vsock socket layer. Later patches that add netns
> > support to transports depend on this patch.
> > 
> > dgram_allow(), stream_allow(), and seqpacket_allow() callbacks are
> > modified to take a vsk in order to perform logic on namespace modes. In
> > future patches, the net and net_mode will also be used for socket
> > lookups in these functions.
> > 
> > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> > ---
> > Changes in v12:
> > - return true in dgram_allow(), stream_allow(), and seqpacket_allow()
> >  only if net_mode == VSOCK_NET_MODE_GLOBAL (Stefano)
> > - document bind(VMADDR_CID_ANY) case in af_vsock.c (Stefano)
> > - change order of stream_allow() call in vmci so we can pass vsk
> >  to it
> > 
> > Changes in v10:
> > - add file-level comment about what happens to sockets/devices
> >  when the namespace mode changes (Stefano)
> > - change the 'if (write)' boolean in vsock_net_mode_string() to
> >  if (!write), this simplifies a later patch which adds "goto"
> >  for mutex unlocking on function exit.
> > 
> > Changes in v9:
> > - remove virtio_vsock_alloc_rx_skb() (Stefano)
> > - remove vsock_global_dummy_net, not needed as net=NULL +
> >  net_mode=VSOCK_NET_MODE_GLOBAL achieves identical result
> > 
> > Changes in v7:
> > - hv_sock: fix hyperv build error
> > - explain why vhost does not use the dummy
> > - explain usage of __vsock_global_dummy_net
> > - explain why VSOCK_NET_MODE_STR_MAX is 8 characters
> > - use switch-case in vsock_net_mode_string()
> > - avoid changing transports as much as possible
> > - add vsock_find_{bound,connected}_socket_net()
> > - rename `vsock_hdr` to `sysctl_hdr`
> > - add virtio_vsock_alloc_linear_skb() wrapper for setting dummy net and
> >  global mode for virtio-vsock, move skb->cb zero-ing into wrapper
> > - explain seqpacket_allow() change
> > - move net setting to __vsock_create() instead of vsock_create() so
> >  that child sockets also have their net assigned upon accept()
> > 
> > Changes in v6:
> > - unregister sysctl ops in vsock_exit()
> > - af_vsock: clarify description of CID behavior
> > - af_vsock: fix buf vs buffer naming, and length checking
> > - af_vsock: fix length checking w/ correct ctl_table->maxlen
> > 
> > Changes in v5:
> > - vsock_global_net() -> vsock_global_dummy_net()
> > - update comments for new uAPI
> > - use /proc/sys/net/vsock/ns_mode instead of /proc/net/vsock_ns_mode
> > - add prototype changes so patch remains compilable
> > ---
> > drivers/vhost/vsock.c                   |   9 +-
> > include/linux/virtio_vsock.h            |   4 +-
> > include/net/af_vsock.h                  |  13 +-
> > net/vmw_vsock/af_vsock.c                | 272 +++++++++++++++++++++++++++++---
> > net/vmw_vsock/hyperv_transport.c        |   7 +-
> > net/vmw_vsock/virtio_transport.c        |   9 +-
> > net/vmw_vsock/virtio_transport_common.c |   6 +-
> > net/vmw_vsock/vmci_transport.c          |  26 ++-
> > net/vmw_vsock/vsock_loopback.c          |   8 +-
> > 9 files changed, 310 insertions(+), 44 deletions(-)
> > 
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index ae01457ea2cd..83937e1d63fa 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -404,7 +404,8 @@ static bool vhost_transport_msgzerocopy_allow(void)
> > 	return true;
> > }
> > 
> > -static bool vhost_transport_seqpacket_allow(u32 remote_cid);
> > +static bool vhost_transport_seqpacket_allow(struct vsock_sock *vsk,
> > +					    u32 remote_cid);
> > 
> > static struct virtio_transport vhost_transport = {
> > 	.transport = {
> > @@ -460,11 +461,15 @@ static struct virtio_transport vhost_transport = {
> > 	.send_pkt = vhost_transport_send_pkt,
> > };
> > 
> > -static bool vhost_transport_seqpacket_allow(u32 remote_cid)
> > +static bool vhost_transport_seqpacket_allow(struct vsock_sock *vsk,
> > +					    u32 remote_cid)
> > {
> > 	struct vhost_vsock *vsock;
> > 	bool seqpacket_allow = false;
> > 
> > +	if (vsk->net_mode != VSOCK_NET_MODE_GLOBAL)
> > +		return false;
> > +
> > 	rcu_read_lock();
> > 	vsock = vhost_vsock_get(remote_cid);
> > 
> > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > index 0c67543a45c8..1845e8d4f78d 100644
> > --- a/include/linux/virtio_vsock.h
> > +++ b/include/linux/virtio_vsock.h
> > @@ -256,10 +256,10 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
> > 
> > u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
> > bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
> > -bool virtio_transport_stream_allow(u32 cid, u32 port);
> > +bool virtio_transport_stream_allow(struct vsock_sock *vsk, u32 cid, u32 port);
> > int virtio_transport_dgram_bind(struct vsock_sock *vsk,
> > 				struct sockaddr_vm *addr);
> > -bool virtio_transport_dgram_allow(u32 cid, u32 port);
> > +bool virtio_transport_dgram_allow(struct vsock_sock *vsk, u32 cid, u32 port);
> > 
> > int virtio_transport_connect(struct vsock_sock *vsk);
> > 
> > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > index 9b5bdd083b6f..d10e73cd7413 100644
> > --- a/include/net/af_vsock.h
> > +++ b/include/net/af_vsock.h
> > @@ -126,7 +126,7 @@ struct vsock_transport {
> > 			     size_t len, int flags);
> > 	int (*dgram_enqueue)(struct vsock_sock *, struct sockaddr_vm *,
> > 			     struct msghdr *, size_t len);
> > -	bool (*dgram_allow)(u32 cid, u32 port);
> > +	bool (*dgram_allow)(struct vsock_sock *vsk, u32 cid, u32 port);
> > 
> > 	/* STREAM. */
> > 	/* TODO: stream_bind() */
> > @@ -138,14 +138,14 @@ struct vsock_transport {
> > 	s64 (*stream_has_space)(struct vsock_sock *);
> > 	u64 (*stream_rcvhiwat)(struct vsock_sock *);
> > 	bool (*stream_is_active)(struct vsock_sock *);
> > -	bool (*stream_allow)(u32 cid, u32 port);
> > +	bool (*stream_allow)(struct vsock_sock *vsk, u32 cid, u32 port);
> > 
> > 	/* SEQ_PACKET. */
> > 	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
> > 				     int flags);
> > 	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
> > 				 size_t len);
> > -	bool (*seqpacket_allow)(u32 remote_cid);
> > +	bool (*seqpacket_allow)(struct vsock_sock *vsk, u32 remote_cid);
> > 	u32 (*seqpacket_has_data)(struct vsock_sock *vsk);
> > 
> > 	/* Notification. */
> > @@ -218,6 +218,13 @@ void vsock_remove_connected(struct vsock_sock *vsk);
> > struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
> > struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
> > 					 struct sockaddr_vm *dst);
> > +struct sock *vsock_find_bound_socket_net(struct sockaddr_vm *addr,
> > +					 struct net *net,
> > +					 enum vsock_net_mode net_mode);
> > +struct sock *vsock_find_connected_socket_net(struct sockaddr_vm *src,
> > +					     struct sockaddr_vm *dst,
> > +					     struct net *net,
> > +					     enum vsock_net_mode net_mode);
> > void vsock_remove_sock(struct vsock_sock *vsk);
> > void vsock_for_each_connected_socket(struct vsock_transport *transport,
> > 				     void (*fn)(struct sock *sk));
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index adcba1b7bf74..6113c22db8dc 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -83,6 +83,46 @@
> >  *   TCP_ESTABLISHED - connected
> >  *   TCP_CLOSING - disconnecting
> >  *   TCP_LISTEN - listening
> > + *
> > + * - Namespaces in vsock support two different modes configured
> > + *   through /proc/sys/net/vsock/ns_mode. The modes are "local" and "global".
> > + *   Each mode defines how the namespace interacts with CIDs.
> > + *   /proc/sys/net/vsock/ns_mode is write-once, so that it may be configured
> > + *   and locked down by a namespace manager. The default is "global". The mode
> > + *   is set per-namespace.
> > + *
> > + *   The modes affect the allocation and accessibility of CIDs as follows:
> > + *
> > + *   - global - access and allocation are all system-wide
> 
> nit: maybe we should mention that this mode is primarily for backward
> compatibility, since it's the way how vsock worked before netns support.
> 
> (We can fix later eventually with a followup patch)
> 
> > + *      - all CID allocation from global namespaces draw from the same
> > + *        system-wide pool.
> > + *      - if one global namespace has already allocated some CID, another
> > + *        global namespace will not be able to allocate the same CID.
> > + *      - global mode AF_VSOCK sockets can reach any VM or socket in any global
> > + *        namespace, they are not contained to only their own namespace.
> > + *      - AF_VSOCK sockets in a global mode namespace cannot reach VMs or
> > + *        sockets in any local mode namespace.
> > + *   - local - access and allocation are contained within the namespace
> > + *     - CID allocation draws only from a private pool local only to the
> > + *       namespace, and does not affect the CIDs available for allocation in any
> > + *       other namespace (global or local).
> > + *     - VMs in a local namespace do not collide with CIDs in any other local
> > + *       namespace or any global namespace. For example, if a VM in a local mode
> > + *       namespace is given CID 10, then CID 10 is still available for
> > + *       allocation in any other namespace, but not in the same namespace.
> > + *     - AF_VSOCK sockets in a local mode namespace can connect only to VMs or
> > + *       other sockets within their own namespace.
> > + *     - sockets bound to VMADDR_CID_ANY in local namespaces will never resolve
> > + *       to any transport that is not compatible with local mode. There is no
> > + *       error that propagates to the user (as there is for connection attempts)
> > + *       because it is possible for some packet to reach this socket from
> > + *       a different transport that *does* support local mode. For
> > + *       example, virtio-vsock may not support local mode, but the socket
> > + *       may still accept a connection from vhost-vsock which does.
> > + *
> > + *   - when a socket or device is initialized in a namespace with mode
> > + *     global, it will stay in global mode even if the namespace later
> > + *     changes to local.
> >  */
> > 
> > #include <linux/compat.h>
> > @@ -100,6 +140,7 @@
> > #include <linux/module.h>
> > #include <linux/mutex.h>
> > #include <linux/net.h>
> > +#include <linux/proc_fs.h>
> > #include <linux/poll.h>
> > #include <linux/random.h>
> > #include <linux/skbuff.h>
> > @@ -111,9 +152,18 @@
> > #include <linux/workqueue.h>
> > #include <net/sock.h>
> > #include <net/af_vsock.h>
> > +#include <net/netns/vsock.h>
> > #include <uapi/linux/vm_sockets.h>
> > #include <uapi/asm-generic/ioctls.h>
> > 
> > +#define VSOCK_NET_MODE_STR_GLOBAL "global"
> > +#define VSOCK_NET_MODE_STR_LOCAL "local"
> > +
> > +/* 6 chars for "global", 1 for null-terminator, and 1 more for '\n'.
> > + * The newline is added by proc_dostring() for read operations.
> > + */
> > +#define VSOCK_NET_MODE_STR_MAX 8
> > +
> > static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
> > static void vsock_sk_destruct(struct sock *sk);
> > static int vsock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
> > @@ -235,33 +285,47 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
> > 	sock_put(&vsk->sk);
> > }
> > 
> > -static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
> > +static struct sock *__vsock_find_bound_socket_net(struct sockaddr_vm *addr,
> > +						  struct net *net,
> > +						  enum vsock_net_mode net_mode)
> > {
> > 	struct vsock_sock *vsk;
> > 
> > 	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
> > -		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
> > -			return sk_vsock(vsk);
> > +		struct sock *sk = sk_vsock(vsk);
> > +
> > +		if (vsock_addr_equals_addr(addr, &vsk->local_addr) &&
> > +		    vsock_net_check_mode(sock_net(sk), vsk->net_mode, net,
> > +					 net_mode))
> > +			return sk;
> > 
> > 		if (addr->svm_port == vsk->local_addr.svm_port &&
> > 		    (vsk->local_addr.svm_cid == VMADDR_CID_ANY ||
> > -		     addr->svm_cid == VMADDR_CID_ANY))
> > -			return sk_vsock(vsk);
> > +		     addr->svm_cid == VMADDR_CID_ANY) &&
> > +		     vsock_net_check_mode(sock_net(sk), vsk->net_mode, net,
> > +					  net_mode))
> > +			return sk;
> > 	}
> > 
> > 	return NULL;
> > }
> > 
> > -static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
> > -						  struct sockaddr_vm *dst)
> > +static struct sock *
> > +__vsock_find_connected_socket_net(struct sockaddr_vm *src,
> > +				  struct sockaddr_vm *dst, struct net *net,
> > +				  enum vsock_net_mode net_mode)
> > {
> > 	struct vsock_sock *vsk;
> > 
> > 	list_for_each_entry(vsk, vsock_connected_s)ckets(src, dst),
> > 			    connected_table) {
> > +		struct sock *sk = sk_vsock(vsk);
> > +
> > 		if (vsock_addr_equals_addr(src, &vsk->remote_addr) &&
> > -		    dst->svm_port == vsk->local_addr.svm_port) {
> > -			return sk_vsock(vsk);
> > +		    dst->svm_port == vsk->local_addr.svm_port &&
> > +		    vsock_net_check_mode(sock_net(sk), vsk->net_mode, net,
> > +					 net_mode)) {
> > +			return sk;
> > 		}
> > 	}
> > 
> > @@ -304,12 +368,14 @@ void vsock_remove_connected(struct vsock_sock *vsk)
> > }
> > EXPORT_SYMBOL_GPL(vsock_remove_connected);
> > 
> > -struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
> > +struct sock *vsock_find_bound_socket_net(struct sockaddr_vm *addr,
> > +					 struct net *net,
> > +					 enum vsock_net_mode net_mode)
> > {
> > 	struct sock *sk;
> > 
> > 	spin_lock_bh(&vsock_table_lock);
> > -	sk = __vsock_find_bound_socket(addr);
> > +	sk = __vsock_find_bound_socket_net(addr, net, net_mode);
> > 	if (sk)
> > 		sock_hold(sk);
> > 
> > @@ -317,15 +383,23 @@ struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
> > 
> > 	return sk;
> > }
> > +EXPORT_SYMBOL_GPL(vsock_find_bound_socket_net);
> > +
> > +struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
> > +{
> > +	return vsock_find_bound_socket_net(addr, NULL, VSOCK_NET_MODE_GLOBAL);
> 
> The patch LGTM, my last doubt now is if here (and in
> vsock_find_connected_socket() ) we should use `init_net`.
> 
> In practice, this is the namespace (NULL) and mode (GLOBAL) used by
> transports that do not support namespaces.
> 
> So here we are making them belong to no namespace, so they can only reach
> global ones. When any namespace, including `init_net`, switches to local, it
> can no longer be reached by transports that do not support local namespaces,
> because in practice we still do not have a way to associate a device (in the
> case of drivers) with a specific namespace.  Right?

Right.

> 
> If I get it right, it can makes sense, but I'd like an ack from net
> maintainers to be sure we are doing the right things.
> 
> Also I think we should have a comment on top of this function to make it
> clear that should be used only by transport that doesn't support namespace,
> and the reason why we used NULL and GLOBAL. Plus a comment on top of this
> file (near where we described local vs global) to clarify the status of
> this.
> 
> That said, if next week net-next will close, I think we can send a follow-up
> patch just for those comments, so:

Sounds good, I'll wait for further feedback before sending anything!

> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 

> > +}
> > EXPORT_SYMBOL_GPL(vsock_find_bound_socket);
> > 
> > -struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
> > -					 struct sockaddr_vm *dst)
> > +struct sock *vsock_find_connected_socket_net(struct sockaddr_vm *src,
> > +					     struct sockaddr_vm *dst,
> > +					     struct net *net,
> > +					     enum vsock_net_mode net_mode)
> > {
> > 	struct sock *sk;
> > 
> > 	spin_lock_bh(&vsock_table_lock);
> > -	sk = __vsock_find_connected_socket(src, dst);
> > +	sk = __vsock_find_connected_socket_net(src, dst, net, net_mode);
> > 	if (sk)
> > 		sock_hold(sk);
> > 
> > @@ -333,6 +407,14 @@ struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
> > 
> > 	return sk;
> > }
> > +EXPORT_SYMBOL_GPL(vsock_find_connected_socket_net);
> > +
> > +struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
> > +					 struct sockaddr_vm *dst)
> > +{
> > +	return vsock_find_connected_socket_net(src, dst,
> > +					       NULL, VSOCK_NET_MODE_GLOBAL);
> > +}
> > EXPORT_SYMBOL_GPL(vsock_find_connected_socket);
> 

