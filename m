Return-Path: <kvm+bounces-41545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C084A6A1F0
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 09:58:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB1C43ADF1A
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 08:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E655220685;
	Thu, 20 Mar 2025 08:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BiunFC6R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82BB21C17B
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 08:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742461091; cv=none; b=C3fsHvc/9QHmaRWjHtVYihmcfLkRZbelFIHr7Qh89yjeiBd99YkuUeriWvswTN+cA6NdwdXcUcfMO2F+4sKzpLIwqlOO1bu6gV+ynxux1ZNWjC/9fEYytullIrJcvtmAx5vlglp7GYdZVZ5ivUm5Xm0e5EPjf9r0JiJrknLDqVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742461091; c=relaxed/simple;
	bh=DM/ccL3ibK097z90TQvPWmYrGyoMDZe8c1dLJKbrEyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZDatEOIubggxM/AEAj1RYIDifTRYeVkWTlJ9tXCvq1wKj9mAQoN181sQ09jlMGqeLbgyDvL/jrMNJnjRRbnOSKSFc3fRJqx3r5A0f7xEdnyG6TrNoGiRrO/xQFTFRTm9DGA+/1aXjX9seEnMHZGh07lccMg7t2QffkcJePoK/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BiunFC6R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742461088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bd61lUn+sRLHMmwZN8hWDOwnbFohDDuP+YHOHn1Rqxs=;
	b=BiunFC6R4xEbHGqDHki88d6G+8I0Had5iTwFpWryRpmtv4j69N9Qf2evRRAAOqCWnzIWUs
	xONDCcRNrErHzMbapB5LRCdBUID0W3Pc1A03F5Y/bykVDEb50RhQTEDf4nTHgJQdm3G2zF
	BPrQUVbC+q7LMpu5TVtOKvrZH0TkSfk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-_SGmgSLpMjKfZ9MmVVTs9Q-1; Thu, 20 Mar 2025 04:58:07 -0400
X-MC-Unique: _SGmgSLpMjKfZ9MmVVTs9Q-1
X-Mimecast-MFC-AGG-ID: _SGmgSLpMjKfZ9MmVVTs9Q_1742461086
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5e5cc488f27so501478a12.3
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 01:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742461085; x=1743065885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bd61lUn+sRLHMmwZN8hWDOwnbFohDDuP+YHOHn1Rqxs=;
        b=Dx365bS3NAJm0YmMB7wy9P/ctMXedHPtJ0q3wU5C8xA2z/rHkQDrKS21qWCn/LsU0/
         4MxHMuWrrVfNS/gW2I/KYeWCGYLZKo2q4mBOqNQUGfwK7wojxqY0TiA17mVKeBMIjOX/
         ER61toluUgN20cNFDym4TfGjdsTe1bQHl4jp7VJN3IQfWQSHI1Q/RupzNBONU4Uwz5AW
         Msx4ZdXXfOwTcpK5L5Jui7I64q6+CTvwEHIMdkBQpGwYyNOd9akg9S2F5jE8X6CSBv9K
         Oq5uLnC0RHitfQWIdEkqILvwenwKZx6A+eFLhXyCjTrwxw6EbsbI24pSlz+rLFd6ooTx
         euWA==
X-Forwarded-Encrypted: i=1; AJvYcCVJVLCuFIW/n7HPvtjMfxKo8wrSNT9htv7ND8ifdvItWln21sSntSlZIJzLsz55MiUfNNw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrbeNm7QM21kCZ9Y/qFe+uC3XWAXctGQRBxZi3Z6rmCOfP3Uh6
	4SKY7ugN9G5r0p+MdQHs3JTX2RCje8oMnmjjOlnBbfzxaka5NbpZtKW73inoigCt3fvrK7dzJyJ
	53qE4z/FQIfgoPxUtyni/PS7z7A2Dg3SVKF5VwiSfsdh+98lYgS8/1zLXRg==
X-Gm-Gg: ASbGnctkLArziZU+Pmoa63Kf1rgGfaKt7yIW7PWDBuv2LGtL2VbDJf9tgqP+ZyPss1z
	6xNHjpZRMx8TgtAg92xGpi58JffBGoy1vM6SXtTlS++rjGS1qGbH3Ch7wmdP0zkiK1wR0CBF2We
	80rif3uIAE83MCWX1ZWy+0XwxV3cm9t7A65grzYE0KbVGgjPaSPX0/LM/WKP8hLaEqBOaBE1VyU
	VOS3Hi1LCx+PF4gkXQSy0LOJMkJFv/QcZ5CueyRoS1diTBmkb6isra379Qb57Nq9ika4AaLIjqD
	1LBmmhEqXY2zRKxeV19ZhIB2aEf8+xdsFXgAHWP1XplOrFsXji8M2kv/+wbkVfYX
X-Received: by 2002:a17:907:d1a:b0:ac3:9587:f2a1 with SMTP id a640c23a62f3a-ac3cdfbaad6mr295751966b.20.1742461085278;
        Thu, 20 Mar 2025 01:58:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGq0juNbqCxFJGV1XJKgWfbIVjl7qoYd4fj9juFeRDlZBNQGi5NZBdC6rDGZqTEbwHSGFJEAQ==
X-Received: by 2002:a17:907:d1a:b0:ac3:9587:f2a1 with SMTP id a640c23a62f3a-ac3cdfbaad6mr295748566b.20.1742461084564;
        Thu, 20 Mar 2025 01:58:04 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-55.business.telecomitalia.it. [87.12.25.55])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3daddfe94sm66361766b.73.2025.03.20.01.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 01:58:03 -0700 (PDT)
Date: Thu, 20 Mar 2025 09:57:57 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
	Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, "David S. Miller" <davem@davemloft.net>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/3] vsock: add network namespace support
Message-ID: <sarbzv7tqaljonkuerlmirulq25ouk6mwyfbr4oaqfzfry2kcm@efbhpxgpxikk>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-1-84bffa1aa97a@gmail.com>
 <sqvqvlovlxpfo2tlkazugkocwmlhc7iay2kvq7b75bgwk7vhfw@tvgfe5fj3mw6>
 <Z9sUVs1Tq3SN83MQ@devvm6277.cco0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Z9sUVs1Tq3SN83MQ@devvm6277.cco0.facebook.com>

On Wed, Mar 19, 2025 at 12:00:38PM -0700, Bobby Eshleman wrote:
>On Wed, Mar 19, 2025 at 02:02:32PM +0100, Stefano Garzarella wrote:
>> On Wed, Mar 12, 2025 at 01:59:35PM -0700, Bobby Eshleman wrote:
>> > From: Stefano Garzarella <sgarzare@redhat.com>
>> >
>> > This patch adds a check of the "net" assigned to a socket during
>> > the vsock_find_bound_socket() and vsock_find_connected_socket()
>> > to support network namespace, allowing to share the same address
>> > (cid, port) across different network namespaces.
>> >
>> > This patch preserves old behavior, and does not yet bring up namespace
>> > support fully.
>> >
>> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>
>> I'd describe here a bit the new behaviour related to `fallback` that you
>> developed.
>>
>> Or we can split this patch in two patches, one with my changes without
>> fallback, and another with fallback as you as author.
>>
>> WDYT?
>>
>
>I like the idea of splitting it, that way any unforeseen issues in the
>new logic can be isolated to the one patch.
>
>>
>> > Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
>> > ---
>> > v1 -> v2:
>> > * remove 'netns' module param
>> > * remove vsock_net_eq()
>> > * use vsock_global_net() for "global" namespace
>> > * use fallback logic in socket lookup functions, giving precedence to
>> >  non-global vsock namespaces
>> >
>> > RFC -> v1
>> > * added 'netns' module param
>> > * added 'vsock_net_eq()' to check the "net" assigned to a socket
>> >  only when 'netns' support is enabled
>> > ---
>> > include/net/af_vsock.h                  |  7 +++--
>> > net/vmw_vsock/af_vsock.c                | 55 ++++++++++++++++++++++++---------
>> > net/vmw_vsock/hyperv_transport.c        |  2 +-
>> > net/vmw_vsock/virtio_transport_common.c |  5 +--
>> > net/vmw_vsock/vmci_transport.c          |  4 +--
>> > 5 files changed, 51 insertions(+), 22 deletions(-)
>> >
>> > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> > index 9e85424c834353d016a527070dd62e15ff3bfce1..41afbc18648c953da27a93571d408de968aa7668 100644
>> > --- a/include/net/af_vsock.h
>> > +++ b/include/net/af_vsock.h
>> > @@ -213,9 +213,10 @@ void vsock_enqueue_accept(struct sock *listener, struct sock *connected);
>> > void vsock_insert_connected(struct vsock_sock *vsk);
>> > void vsock_remove_bound(struct vsock_sock *vsk);
>> > void vsock_remove_connected(struct vsock_sock *vsk);
>> > -struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
>> > +struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr, struct net *net);
>> > struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
>> > -					 struct sockaddr_vm *dst);
>> > +					 struct sockaddr_vm *dst,
>> > +					 struct net *net);
>> > void vsock_remove_sock(struct vsock_sock *vsk);
>> > void vsock_for_each_connected_socket(struct vsock_transport *transport,
>> > 				     void (*fn)(struct sock *sk));
>> > @@ -255,4 +256,6 @@ static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
>> > {
>> > 	return t->msgzerocopy_allow && t->msgzerocopy_allow();
>> > }
>> > +
>> > +struct net *vsock_global_net(void);
>>
>> If it just returns null, maybe we can make it inline here.
>>
>
>Roger that.
>
>> > #endif /* __AF_VSOCK_H__ */
>> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> > index 7e3db87ae4333cf63327ec105ca99253569bb9fe..d206489bf0a81cf989387c7c8063be91a7c21a7d 100644
>> > --- a/net/vmw_vsock/af_vsock.c
>> > +++ b/net/vmw_vsock/af_vsock.c
>> > @@ -235,37 +235,60 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
>> > 	sock_put(&vsk->sk);
>> > }
>> >
>> > -static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
>> > +struct net *vsock_global_net(void)
>> > {
>> > +	return NULL;
>> > +}
>> > +EXPORT_SYMBOL_GPL(vsock_global_net);
>> > +
>> > +static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr,
>> > +					      struct net *net)
>> > +{
>>
>> Please add a comment here to describe what fallback is used for.
>> And I would suggest also something on top of this file to explain a bit
>> how netns are handled in AF_VSOCK.
>>
>
>sgtm!
>
>> > +	struct sock *fallback = NULL;
>> > 	struct vsock_sock *vsk;
>> >
>> > 	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
>> > -		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
>> > -			return sk_vsock(vsk);
>> > +		if (vsock_addr_equals_addr(addr, &vsk->local_addr)) {
>> > +			if (net_eq(net, sock_net(sk_vsock(vsk))))
>> > +				return sk_vsock(vsk);
>> >
>> > +			if (net_eq(net, vsock_global_net()))
>> > +				fallback = sk_vsock(vsk);
>> > +		}
>> > 		if (addr->svm_port == vsk->local_addr.svm_port &&
>> > 		    (vsk->local_addr.svm_cid == VMADDR_CID_ANY ||
>> > -		     addr->svm_cid == VMADDR_CID_ANY))
>> > -			return sk_vsock(vsk);
>> > +		     addr->svm_cid == VMADDR_CID_ANY)) {
>> > +			if (net_eq(net, sock_net(sk_vsock(vsk))))
>> > +				return sk_vsock(vsk);
>> > +
>> > +			if (net_eq(net, vsock_global_net()))
>> > +				fallback = sk_vsock(vsk);
>> > +		}
>> > 	}
>> >
>> > -	return NULL;
>> > +	return fallback;
>> > }
>> >
>> > static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
>> > -						  struct sockaddr_vm *dst)
>> > +						  struct sockaddr_vm *dst,
>> > +						  struct net *net)
>> > {
>> > +	struct sock *fallback = NULL;
>> > 	struct vsock_sock *vsk;
>> >
>> > 	list_for_each_entry(vsk, vsock_connected_sockets(src, dst),
>> > 			    connected_table) {
>> > 		if (vsock_addr_equals_addr(src, &vsk->remote_addr) &&
>> > 		    dst->svm_port == vsk->local_addr.svm_port) {
>> > -			return sk_vsock(vsk);
>> > +			if (net_eq(net, sock_net(sk_vsock(vsk))))
>> > +				return sk_vsock(vsk);
>> > +
>> > +			if (net_eq(net, vsock_global_net()))
>> > +				fallback = sk_vsock(vsk);
>>
>> This pattern seems to be repeated 3 times, can we make a function/macro?
>>
>
>yep, no problem!
>
>> > 		}
>> > 	}
>> >
>> > -	return NULL;
>> > +	return fallback;
>> > }
>> >
>> > static void vsock_insert_unbound(struct vsock_sock *vsk)
>> > @@ -304,12 +327,12 @@ void vsock_remove_connected(struct vsock_sock *vsk)
>> > }
>> > EXPORT_SYMBOL_GPL(vsock_remove_connected);
>> >
>> > -struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
>> > +struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr, struct net *net)
>> > {
>> > 	struct sock *sk;
>> >
>> > 	spin_lock_bh(&vsock_table_lock);
>> > -	sk = __vsock_find_bound_socket(addr);
>> > +	sk = __vsock_find_bound_socket(addr, net);
>> > 	if (sk)
>> > 		sock_hold(sk);
>> >
>> > @@ -320,12 +343,13 @@ struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
>> > EXPORT_SYMBOL_GPL(vsock_find_bound_socket);
>> >
>> > struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
>> > -					 struct sockaddr_vm *dst)
>> > +					 struct sockaddr_vm *dst,
>> > +					 struct net *net)
>> > {
>> > 	struct sock *sk;
>> >
>> > 	spin_lock_bh(&vsock_table_lock);
>> > -	sk = __vsock_find_connected_socket(src, dst);
>> > +	sk = __vsock_find_connected_socket(src, dst, net);
>> > 	if (sk)
>> > 		sock_hold(sk);
>> >
>> > @@ -644,6 +668,7 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>> > {
>> > 	static u32 port;
>> > 	struct sockaddr_vm new_addr;
>> > +	struct net *net = sock_net(sk_vsock(vsk));
>> >
>> > 	if (!port)
>> > 		port = get_random_u32_above(LAST_RESERVED_PORT);
>> > @@ -660,7 +685,7 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>> >
>> > 			new_addr.svm_port = port++;
>> >
>> > -			if (!__vsock_find_bound_socket(&new_addr)) {
>> > +			if (!__vsock_find_bound_socket(&new_addr, net)) {
>> > 				found = true;
>> > 				break;
>> > 			}
>> > @@ -677,7 +702,7 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>> > 			return -EACCES;
>> > 		}
>> >
>> > -		if (__vsock_find_bound_socket(&new_addr))
>> > +		if (__vsock_find_bound_socket(&new_addr, net))
>> > 			return -EADDRINUSE;
>> > 	}
>> >
>> > diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>> > index 31342ab502b4fc35feb812d2c94e0e35ded73771..253609898d24f8a484fcfc3296011c6f501a72a8 100644
>> > --- a/net/vmw_vsock/hyperv_transport.c
>> > +++ b/net/vmw_vsock/hyperv_transport.c
>> > @@ -313,7 +313,7 @@ static void hvs_open_connection(struct vmbus_channel *chan)
>> > 		return;
>> >
>> > 	hvs_addr_init(&addr, conn_from_host ? if_type : if_instance);
>> > -	sk = vsock_find_bound_socket(&addr);
>> > +	sk = vsock_find_bound_socket(&addr, NULL);
>> > 	if (!sk)
>> > 		return;
>> >
>> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> > index 7f7de6d8809655fe522749fbbc9025df71f071bd..256d2a4fe482b3cb938a681b6924be69b2065616 100644
>> > --- a/net/vmw_vsock/virtio_transport_common.c
>> > +++ b/net/vmw_vsock/virtio_transport_common.c
>> > @@ -1590,6 +1590,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>> > 			       struct sk_buff *skb)
>> > {
>> > 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
>> > +	struct net *net = vsock_global_net();
>>
>> Why using vsock_global_net() in virtio and directly NULL in the others
>> transports?
>>
>
>This was an oversight on my part, I found an unnamed NULL harder to
>reason about, switched to the func, but forgot to switch over the other
>transports.
>
>BTW, I was unsure about just making NULL a macro (e.g.,
>VIRTIO_VSOCK_GLOBAL_NET?) instead of a function. I just used a function
>because A) I noticed in the prior rev that the default net was a
>function instead of some macro to &init_net, and B) the function seemed
>a little more flexible for future changes. What are your thoughts here?

Inline function in the header should be fine IMHO.

Thanks,
Stefano

>
>
>Thanks for the review!
>
>Best,
>Bobby
>


