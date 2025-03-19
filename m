Return-Path: <kvm+bounces-41516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F8C2A6988C
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 20:01:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6412519C5154
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 19:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20FD3213E79;
	Wed, 19 Mar 2025 19:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dvp2WXO0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED7620C48E;
	Wed, 19 Mar 2025 19:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742410854; cv=none; b=ErIAnC3LS0zzata/qGXz88/+U1jN9YZ/4IOBiOzgNRBHUxu9UpzA/Fy27OpsQ+5gKIUpKDOGmU/sTnWL/0qYWtJzh1A7NLIAe4cFTEfDCsLHLWVr0AE3t2neJkibts8xZPvXqmSvw/JmKhllyMFoH54+FmUZ4+Za/m4jeWlhFIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742410854; c=relaxed/simple;
	bh=bQ81Fc55GF5vLNCh1KjcH+C7ekGu0HyxorM23JbvqCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RughQXQD9zsIDrysJJWs/kI3B1jcTcCITlEXQELSniJzt+Gvsm7Z/wk8RGgEGikbGPPJacLkg3aainXlio9sOV6bPAugctvXWqtII76xOjh/21chCW0ZlXOVM6QodvwpKxTgPtEzihM8X3DODnrKkfMsxF1MPF9WxQ2robCwHVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dvp2WXO0; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3012a0c8496so6314376a91.2;
        Wed, 19 Mar 2025 12:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742410852; x=1743015652; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=biXjJdX1FFK2ilJDVmzGFQ2LcLuqE/zLttPI8Z+C5Dc=;
        b=Dvp2WXO0pOBKXaMk9/jCrA50w8ja6VjmXoJgSpKe9lN2D3fk7wJleg19N8qbaAaKEP
         EHRguW1Qb1HneGa7yf9HqLi5b14+oKcrOucLyDKb819/rWk8UGhqGexclMsRn5l/ORLy
         ONNeaWgqc74OmvhlkASN1vXcGhCfwuYxKwmiCTUh7dUoimQsqjEF7SPZQLHNzf+iGYwh
         qPAgPBKORu4y+8fOoPKxwenwF8pwyxWtWWxrikG/ICHUht6wEGhajsZkjrzDMbcuUpcP
         kJRtTp1pdw7sknF57hLMEL2K5ivlRD1+egoGdE5KUMF1C+iR4Ls9XccHy03xW96xbfAp
         udEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742410852; x=1743015652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=biXjJdX1FFK2ilJDVmzGFQ2LcLuqE/zLttPI8Z+C5Dc=;
        b=Jd0BCy3uIih5HH9v+A3Nj0TmsTao2vB1nQ5dmmQbaojyVjIEWcPByK/mKlNHbJtNVT
         v553VMg337liwR1uGbtvwypqkMJj6k0j6IdSxw+cJ1dyX1ymjl5wvbnaZ0y3Z53Pv7qY
         k7V3LrwPshSIYUgPX5VduoCPhDMXZC2MNQsJ9FkcCKUWRMWZ7AQcw38T7Z5t4P0m7ZIL
         ud1hXpW+hroTFpxWjWshSoGXkZ+PUnL2War7LJg8ZJGIblxGs2bsuTkdUEwsyfOyZzA4
         0s4SEtKSA8T7bBchGlKNVaqn/0gp92eCcCnJqLueQwC01M+dnl1gIqQdmIYL7OQtI0+y
         eSpw==
X-Forwarded-Encrypted: i=1; AJvYcCUirSapKaIv5p3gHYyl+ADOCeccwVXOxqng/lOvQVYtpufuHfafQXO9uPySxci46zYCxhs=@vger.kernel.org, AJvYcCWa2HSddg3NH7/Aj35O9c8w4LdRqv8dCQ7mkG3TUF597lzEMqZfB/1xBdLhdbWAJVT+4YxCygoOjqgmWB0s@vger.kernel.org, AJvYcCWsbRRCvaci5U93FKWFBxqpnR23E6LpeG50r8ojSN/QwnmgVlqa0V4g2u9CjIi/oUnfiA5UxmMY5e6hwK6r@vger.kernel.org, AJvYcCWub422hB/9HLONkUCKnQ6XsnoQmgYzvch77iXjTjmeqGXUyH2Wpu1AYrQGkH5QDvSM2gTbbdIp@vger.kernel.org
X-Gm-Message-State: AOJu0YzjOBiHxA149bKHxx/uzUD7OjGwyQMLj8u/BR0m6tFRhpMWhoAJ
	fAofJ2DT/i+YhdJGUQn8Y4208TLQmP/UGQ4v06RCFRRhLoC+804S
X-Gm-Gg: ASbGncuU+6bH1QOAC+ixtY1IbJ8HwbEmk8WYksDOlpX4bzE/Q2/aFsSr2UaqFboPIKr
	OSKIKrVzh8H8cUVxqNPQC55GW7d9AG6SK0byRXLNlJvVbKZ073DDIP+z9XBj2Qc7kSC5ypYEDEJ
	77yS1e0EwRu9Oq5H/9sJheeHoTpGv/DWzUsikWLoFTCj6JZhMsbfeQuQYPlNc58ZqktPQFpvqD5
	IBqK2XAXjvzrqgCZJwNxMPqGgIHePgTvtTSlegfmeHZP3bpV6REjlAFVxHaKjrfjYm7scswWi8v
	dKwQcc8b4LbQv71P6GvTa2EwWlJk+eahrltrUvqvA0McKwVM4isAARn0BcKEoEIbIA==
X-Google-Smtp-Source: AGHT+IExM0pI9/JU5Crfnd4d50aC7MIsk6BLw9VYIOpGl+RqOsh+7wpYyCT51g4e/BejE8WXLNDy4g==
X-Received: by 2002:a17:90b:3c0f:b0:301:1d03:93cd with SMTP id 98e67ed59e1d1-301be201d9dmr6662434a91.24.1742410851540;
        Wed, 19 Mar 2025 12:00:51 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:1::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf589fbcsm2030123a91.12.2025.03.19.12.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 12:00:50 -0700 (PDT)
Date: Wed, 19 Mar 2025 12:00:38 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/3] vsock: add network namespace support
Message-ID: <Z9sUVs1Tq3SN83MQ@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-1-84bffa1aa97a@gmail.com>
 <sqvqvlovlxpfo2tlkazugkocwmlhc7iay2kvq7b75bgwk7vhfw@tvgfe5fj3mw6>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sqvqvlovlxpfo2tlkazugkocwmlhc7iay2kvq7b75bgwk7vhfw@tvgfe5fj3mw6>

On Wed, Mar 19, 2025 at 02:02:32PM +0100, Stefano Garzarella wrote:
> On Wed, Mar 12, 2025 at 01:59:35PM -0700, Bobby Eshleman wrote:
> > From: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > This patch adds a check of the "net" assigned to a socket during
> > the vsock_find_bound_socket() and vsock_find_connected_socket()
> > to support network namespace, allowing to share the same address
> > (cid, port) across different network namespaces.
> > 
> > This patch preserves old behavior, and does not yet bring up namespace
> > support fully.
> > 
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> I'd describe here a bit the new behaviour related to `fallback` that you
> developed.
> 
> Or we can split this patch in two patches, one with my changes without
> fallback, and another with fallback as you as author.
> 
> WDYT?
> 

I like the idea of splitting it, that way any unforeseen issues in the
new logic can be isolated to the one patch.

> 
> > Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
> > ---
> > v1 -> v2:
> > * remove 'netns' module param
> > * remove vsock_net_eq()
> > * use vsock_global_net() for "global" namespace
> > * use fallback logic in socket lookup functions, giving precedence to
> >  non-global vsock namespaces
> > 
> > RFC -> v1
> > * added 'netns' module param
> > * added 'vsock_net_eq()' to check the "net" assigned to a socket
> >  only when 'netns' support is enabled
> > ---
> > include/net/af_vsock.h                  |  7 +++--
> > net/vmw_vsock/af_vsock.c                | 55 ++++++++++++++++++++++++---------
> > net/vmw_vsock/hyperv_transport.c        |  2 +-
> > net/vmw_vsock/virtio_transport_common.c |  5 +--
> > net/vmw_vsock/vmci_transport.c          |  4 +--
> > 5 files changed, 51 insertions(+), 22 deletions(-)
> > 
> > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > index 9e85424c834353d016a527070dd62e15ff3bfce1..41afbc18648c953da27a93571d408de968aa7668 100644
> > --- a/include/net/af_vsock.h
> > +++ b/include/net/af_vsock.h
> > @@ -213,9 +213,10 @@ void vsock_enqueue_accept(struct sock *listener, struct sock *connected);
> > void vsock_insert_connected(struct vsock_sock *vsk);
> > void vsock_remove_bound(struct vsock_sock *vsk);
> > void vsock_remove_connected(struct vsock_sock *vsk);
> > -struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
> > +struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr, struct net *net);
> > struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
> > -					 struct sockaddr_vm *dst);
> > +					 struct sockaddr_vm *dst,
> > +					 struct net *net);
> > void vsock_remove_sock(struct vsock_sock *vsk);
> > void vsock_for_each_connected_socket(struct vsock_transport *transport,
> > 				     void (*fn)(struct sock *sk));
> > @@ -255,4 +256,6 @@ static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
> > {
> > 	return t->msgzerocopy_allow && t->msgzerocopy_allow();
> > }
> > +
> > +struct net *vsock_global_net(void);
> 
> If it just returns null, maybe we can make it inline here.
> 

Roger that.

> > #endif /* __AF_VSOCK_H__ */
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index 7e3db87ae4333cf63327ec105ca99253569bb9fe..d206489bf0a81cf989387c7c8063be91a7c21a7d 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -235,37 +235,60 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
> > 	sock_put(&vsk->sk);
> > }
> > 
> > -static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
> > +struct net *vsock_global_net(void)
> > {
> > +	return NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(vsock_global_net);
> > +
> > +static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr,
> > +					      struct net *net)
> > +{
> 
> Please add a comment here to describe what fallback is used for.
> And I would suggest also something on top of this file to explain a bit
> how netns are handled in AF_VSOCK.
> 

sgtm!

> > +	struct sock *fallback = NULL;
> > 	struct vsock_sock *vsk;
> > 
> > 	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
> > -		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
> > -			return sk_vsock(vsk);
> > +		if (vsock_addr_equals_addr(addr, &vsk->local_addr)) {
> > +			if (net_eq(net, sock_net(sk_vsock(vsk))))
> > +				return sk_vsock(vsk);
> > 
> > +			if (net_eq(net, vsock_global_net()))
> > +				fallback = sk_vsock(vsk);
> > +		}
> > 		if (addr->svm_port == vsk->local_addr.svm_port &&
> > 		    (vsk->local_addr.svm_cid == VMADDR_CID_ANY ||
> > -		     addr->svm_cid == VMADDR_CID_ANY))
> > -			return sk_vsock(vsk);
> > +		     addr->svm_cid == VMADDR_CID_ANY)) {
> > +			if (net_eq(net, sock_net(sk_vsock(vsk))))
> > +				return sk_vsock(vsk);
> > +
> > +			if (net_eq(net, vsock_global_net()))
> > +				fallback = sk_vsock(vsk);
> > +		}
> > 	}
> > 
> > -	return NULL;
> > +	return fallback;
> > }
> > 
> > static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
> > -						  struct sockaddr_vm *dst)
> > +						  struct sockaddr_vm *dst,
> > +						  struct net *net)
> > {
> > +	struct sock *fallback = NULL;
> > 	struct vsock_sock *vsk;
> > 
> > 	list_for_each_entry(vsk, vsock_connected_sockets(src, dst),
> > 			    connected_table) {
> > 		if (vsock_addr_equals_addr(src, &vsk->remote_addr) &&
> > 		    dst->svm_port == vsk->local_addr.svm_port) {
> > -			return sk_vsock(vsk);
> > +			if (net_eq(net, sock_net(sk_vsock(vsk))))
> > +				return sk_vsock(vsk);
> > +
> > +			if (net_eq(net, vsock_global_net()))
> > +				fallback = sk_vsock(vsk);
> 
> This pattern seems to be repeated 3 times, can we make a function/macro?
> 

yep, no problem!

> > 		}
> > 	}
> > 
> > -	return NULL;
> > +	return fallback;
> > }
> > 
> > static void vsock_insert_unbound(struct vsock_sock *vsk)
> > @@ -304,12 +327,12 @@ void vsock_remove_connected(struct vsock_sock *vsk)
> > }
> > EXPORT_SYMBOL_GPL(vsock_remove_connected);
> > 
> > -struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
> > +struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr, struct net *net)
> > {
> > 	struct sock *sk;
> > 
> > 	spin_lock_bh(&vsock_table_lock);
> > -	sk = __vsock_find_bound_socket(addr);
> > +	sk = __vsock_find_bound_socket(addr, net);
> > 	if (sk)
> > 		sock_hold(sk);
> > 
> > @@ -320,12 +343,13 @@ struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
> > EXPORT_SYMBOL_GPL(vsock_find_bound_socket);
> > 
> > struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
> > -					 struct sockaddr_vm *dst)
> > +					 struct sockaddr_vm *dst,
> > +					 struct net *net)
> > {
> > 	struct sock *sk;
> > 
> > 	spin_lock_bh(&vsock_table_lock);
> > -	sk = __vsock_find_connected_socket(src, dst);
> > +	sk = __vsock_find_connected_socket(src, dst, net);
> > 	if (sk)
> > 		sock_hold(sk);
> > 
> > @@ -644,6 +668,7 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> > {
> > 	static u32 port;
> > 	struct sockaddr_vm new_addr;
> > +	struct net *net = sock_net(sk_vsock(vsk));
> > 
> > 	if (!port)
> > 		port = get_random_u32_above(LAST_RESERVED_PORT);
> > @@ -660,7 +685,7 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> > 
> > 			new_addr.svm_port = port++;
> > 
> > -			if (!__vsock_find_bound_socket(&new_addr)) {
> > +			if (!__vsock_find_bound_socket(&new_addr, net)) {
> > 				found = true;
> > 				break;
> > 			}
> > @@ -677,7 +702,7 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> > 			return -EACCES;
> > 		}
> > 
> > -		if (__vsock_find_bound_socket(&new_addr))
> > +		if (__vsock_find_bound_socket(&new_addr, net))
> > 			return -EADDRINUSE;
> > 	}
> > 
> > diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
> > index 31342ab502b4fc35feb812d2c94e0e35ded73771..253609898d24f8a484fcfc3296011c6f501a72a8 100644
> > --- a/net/vmw_vsock/hyperv_transport.c
> > +++ b/net/vmw_vsock/hyperv_transport.c
> > @@ -313,7 +313,7 @@ static void hvs_open_connection(struct vmbus_channel *chan)
> > 		return;
> > 
> > 	hvs_addr_init(&addr, conn_from_host ? if_type : if_instance);
> > -	sk = vsock_find_bound_socket(&addr);
> > +	sk = vsock_find_bound_socket(&addr, NULL);
> > 	if (!sk)
> > 		return;
> > 
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > index 7f7de6d8809655fe522749fbbc9025df71f071bd..256d2a4fe482b3cb938a681b6924be69b2065616 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -1590,6 +1590,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> > 			       struct sk_buff *skb)
> > {
> > 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
> > +	struct net *net = vsock_global_net();
> 
> Why using vsock_global_net() in virtio and directly NULL in the others
> transports?
> 

This was an oversight on my part, I found an unnamed NULL harder to
reason about, switched to the func, but forgot to switch over the other
transports.

BTW, I was unsure about just making NULL a macro (e.g.,
VIRTIO_VSOCK_GLOBAL_NET?) instead of a function. I just used a function
because A) I noticed in the prior rev that the default net was a
function instead of some macro to &init_net, and B) the function seemed
a little more flexible for future changes. What are your thoughts here?


Thanks for the review!

Best,
Bobby

