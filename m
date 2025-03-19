Return-Path: <kvm+bounces-41486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1F9A68D5A
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 14:04:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E491216A9DD
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 13:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 966F0256C7F;
	Wed, 19 Mar 2025 13:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q5T/Cdcj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B29A935
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 13:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742389392; cv=none; b=uCFtu9HpKqNoMstPLw8UiaMuPiX3dSREggEOfD8YYIVcnUK88065dEW9K4WyjyhFSe7bH1HANDR8BvJY9MC0dTQqT7tQZCN2pXbUwl1/rs+TGO/dJgFBjJKDVYZUbCRfn9bHHyj/oEO0ni6AIQOIRtF+RZwu4EMWmcQhYP2oROY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742389392; c=relaxed/simple;
	bh=yAzx0c228WGA/nr3V4BYObbrF98vgjmkRWrSf0j3H8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cAYz1Bvxc5SW8zmPMGPmsv5EnBaHt7HIc3zvyZraaBApqF95wK+RaK8CvZHKuDmJxuqHzlSPnrZCeiEESs1hChZboDBwXBs20zdy9mcSIGeAedHlp6j3StUGiiqnFJ07BYWdYrVojocBdGQtd9Wk+VOeP0Ipq45gwCKg4QJA7dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q5T/Cdcj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742389389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L5KvoLvfCO2GqePbpG++oDUZVlLR8Oc0vObG3V7PZYI=;
	b=Q5T/CdcjnxRXNFtRa27A4mQjBx9XiDgyL0lOTpXSP1cGCi+CBdwFv7DdZCpnhxNKp/9ReL
	w1890pAtklPZqgu6PxT5LeA8E85qHJ6ic1oQnObQtFPRZZrlDUkj3s6QP9mrMrdmHn2Ogf
	SxCn3dsKP0hWsUf0PIo/FoP0Dnon3HQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-4X3QTqRVNaaUy-XIuNQ8Qg-1; Wed, 19 Mar 2025 09:03:08 -0400
X-MC-Unique: 4X3QTqRVNaaUy-XIuNQ8Qg-1
X-Mimecast-MFC-AGG-ID: 4X3QTqRVNaaUy-XIuNQ8Qg_1742389386
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ac31990bdfdso617049866b.1
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 06:03:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742389386; x=1742994186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L5KvoLvfCO2GqePbpG++oDUZVlLR8Oc0vObG3V7PZYI=;
        b=ug+QQBXIW06SQbk8T1smol0wz1oymv0qKuIB2FLABo0UqXa+dj27RNvlPGPeat5mgj
         5epHtAOPU9JwpwCY6xrgDC3yymF+GMQHpmpfKaY5LEUBE55T8qmtzkLpE37DE5xZQp/M
         zFPOmSGAfVrBhnC9eZK4nrAPDBzAZzL9RzADKLu+1tNwnW6vbbe6rG6W3gbUp6NF1bXZ
         DvljIy9FncSjklrTGwpiINvKKKuhXjxaptD7YqLZ7B7EK+Ppsw0WABIBF9xQw4E1+QsN
         /3yEKrwGf5YzWdfULAFF4+StUKHblk5l4dI++IobNdNfUCS4NnpVLr+BPHDp+zn0SsLu
         nKDA==
X-Forwarded-Encrypted: i=1; AJvYcCW2rpIF7oUUQ92VmgqDuC9S6tdrwQoof0tDtrJFUuSqrAHezuDjxOyPnNwVjkWqP2MRob8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe7sxv7/Cn1B6rmYbF364xa9U79EXqI10nGAIyfgowtdhUif8b
	AqXIk9L0y68v9s/SIxuc49P7R/WmXcRXh6ZDizk0xmWX+kuNKkHPXuzGRitNBSkqlqx9hcW11BA
	iJ8auOu+t1CbgBi+1Zah08APW3Yx5uTbUlCPMEEZUJmG+HhbUxA==
X-Gm-Gg: ASbGncvlQY5/HWDAGDv5BR5dSmdtm3d5U+lS9P/ct8rKHxH4j8CNitb7ifH05F38FQA
	jcDVDkWxw03ideWa1pM45j7bUuwoWV7FluxVNXIAeIiwXZyL5uKSj5z3vCWvuSp+MQzlrqJxaZi
	rnNVPPIbi8d0/sQWGirGLLpvgU8jhUHdXffgpoMEvNqW406Q37XcRqugpUXz1X6+PzU9mbTOkmv
	aEEC44aTgaRrtsy8nDiImGn6h/st6QmRyZdn387G36LN1ZjYAMQp/wdny1rDa6CISQwJ5XfcxQ2
	OKYmbpVLUEswVZxXJRsi8RtZwlHfJ4w9j4sXl5DVexnyr4O4xiUjJJvdRdjzyA==
X-Received: by 2002:a17:907:94c5:b0:ac3:50b:b810 with SMTP id a640c23a62f3a-ac3b7e81331mr283801766b.33.1742389385899;
        Wed, 19 Mar 2025 06:03:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHX8tsi7utsUzXyDOLGgGqVSjOZ0FllgK/3DLytjT5YpmEthJZMbrdByXJvSa+B6nX/bHrLOA==
X-Received: by 2002:a17:907:94c5:b0:ac3:50b:b810 with SMTP id a640c23a62f3a-ac3b7e81331mr283614366b.33.1742389362916;
        Wed, 19 Mar 2025 06:02:42 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-53.retail.telecomitalia.it. [79.53.30.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3b2b94da0sm133809866b.148.2025.03.19.06.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 06:02:42 -0700 (PDT)
Date: Wed, 19 Mar 2025 14:02:32 +0100
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
Message-ID: <sqvqvlovlxpfo2tlkazugkocwmlhc7iay2kvq7b75bgwk7vhfw@tvgfe5fj3mw6>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-1-84bffa1aa97a@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250312-vsock-netns-v2-1-84bffa1aa97a@gmail.com>

On Wed, Mar 12, 2025 at 01:59:35PM -0700, Bobby Eshleman wrote:
>From: Stefano Garzarella <sgarzare@redhat.com>
>
>This patch adds a check of the "net" assigned to a socket during
>the vsock_find_bound_socket() and vsock_find_connected_socket()
>to support network namespace, allowing to share the same address
>(cid, port) across different network namespaces.
>
>This patch preserves old behavior, and does not yet bring up namespace
>support fully.
>
>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

I'd describe here a bit the new behaviour related to `fallback` that you 
developed.

Or we can split this patch in two patches, one with my changes without 
fallback, and another with fallback as you as author.

WDYT?


>Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
>---
>v1 -> v2:
>* remove 'netns' module param
>* remove vsock_net_eq()
>* use vsock_global_net() for "global" namespace
>* use fallback logic in socket lookup functions, giving precedence to
>  non-global vsock namespaces
>
>RFC -> v1
>* added 'netns' module param
>* added 'vsock_net_eq()' to check the "net" assigned to a socket
>  only when 'netns' support is enabled
>---
> include/net/af_vsock.h                  |  7 +++--
> net/vmw_vsock/af_vsock.c                | 55 ++++++++++++++++++++++++---------
> net/vmw_vsock/hyperv_transport.c        |  2 +-
> net/vmw_vsock/virtio_transport_common.c |  5 +--
> net/vmw_vsock/vmci_transport.c          |  4 +--
> 5 files changed, 51 insertions(+), 22 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 9e85424c834353d016a527070dd62e15ff3bfce1..41afbc18648c953da27a93571d408de968aa7668 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -213,9 +213,10 @@ void vsock_enqueue_accept(struct sock *listener, struct sock *connected);
> void vsock_insert_connected(struct vsock_sock *vsk);
> void vsock_remove_bound(struct vsock_sock *vsk);
> void vsock_remove_connected(struct vsock_sock *vsk);
>-struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
>+struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr, struct net *net);
> struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
>-					 struct sockaddr_vm *dst);
>+					 struct sockaddr_vm *dst,
>+					 struct net *net);
> void vsock_remove_sock(struct vsock_sock *vsk);
> void vsock_for_each_connected_socket(struct vsock_transport *transport,
> 				     void (*fn)(struct sock *sk));
>@@ -255,4 +256,6 @@ static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
> {
> 	return t->msgzerocopy_allow && t->msgzerocopy_allow();
> }
>+
>+struct net *vsock_global_net(void);

If it just returns null, maybe we can make it inline here.

> #endif /* __AF_VSOCK_H__ */
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 7e3db87ae4333cf63327ec105ca99253569bb9fe..d206489bf0a81cf989387c7c8063be91a7c21a7d 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -235,37 +235,60 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
> 	sock_put(&vsk->sk);
> }
>
>-static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
>+struct net *vsock_global_net(void)
> {
>+	return NULL;
>+}
>+EXPORT_SYMBOL_GPL(vsock_global_net);
>+
>+static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr,
>+					      struct net *net)
>+{

Please add a comment here to describe what fallback is used for.
And I would suggest also something on top of this file to explain a bit
how netns are handled in AF_VSOCK.

>+	struct sock *fallback = NULL;
> 	struct vsock_sock *vsk;
>
> 	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
>-		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
>-			return sk_vsock(vsk);
>+		if (vsock_addr_equals_addr(addr, &vsk->local_addr)) {
>+			if (net_eq(net, sock_net(sk_vsock(vsk))))
>+				return sk_vsock(vsk);
>
>+			if (net_eq(net, vsock_global_net()))
>+				fallback = sk_vsock(vsk);
>+		}
> 		if (addr->svm_port == vsk->local_addr.svm_port &&
> 		    (vsk->local_addr.svm_cid == VMADDR_CID_ANY ||
>-		     addr->svm_cid == VMADDR_CID_ANY))
>-			return sk_vsock(vsk);
>+		     addr->svm_cid == VMADDR_CID_ANY)) {
>+			if (net_eq(net, sock_net(sk_vsock(vsk))))
>+				return sk_vsock(vsk);
>+
>+			if (net_eq(net, vsock_global_net()))
>+				fallback = sk_vsock(vsk);
>+		}
> 	}
>
>-	return NULL;
>+	return fallback;
> }
>
> static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
>-						  struct sockaddr_vm *dst)
>+						  struct sockaddr_vm *dst,
>+						  struct net *net)
> {
>+	struct sock *fallback = NULL;
> 	struct vsock_sock *vsk;
>
> 	list_for_each_entry(vsk, vsock_connected_sockets(src, dst),
> 			    connected_table) {
> 		if (vsock_addr_equals_addr(src, &vsk->remote_addr) &&
> 		    dst->svm_port == vsk->local_addr.svm_port) {
>-			return sk_vsock(vsk);
>+			if (net_eq(net, sock_net(sk_vsock(vsk))))
>+				return sk_vsock(vsk);
>+
>+			if (net_eq(net, vsock_global_net()))
>+				fallback = sk_vsock(vsk);

This pattern seems to be repeated 3 times, can we make a function/macro?

> 		}
> 	}
>
>-	return NULL;
>+	return fallback;
> }
>
> static void vsock_insert_unbound(struct vsock_sock *vsk)
>@@ -304,12 +327,12 @@ void vsock_remove_connected(struct vsock_sock *vsk)
> }
> EXPORT_SYMBOL_GPL(vsock_remove_connected);
>
>-struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
>+struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr, struct net *net)
> {
> 	struct sock *sk;
>
> 	spin_lock_bh(&vsock_table_lock);
>-	sk = __vsock_find_bound_socket(addr);
>+	sk = __vsock_find_bound_socket(addr, net);
> 	if (sk)
> 		sock_hold(sk);
>
>@@ -320,12 +343,13 @@ struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
> EXPORT_SYMBOL_GPL(vsock_find_bound_socket);
>
> struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
>-					 struct sockaddr_vm *dst)
>+					 struct sockaddr_vm *dst,
>+					 struct net *net)
> {
> 	struct sock *sk;
>
> 	spin_lock_bh(&vsock_table_lock);
>-	sk = __vsock_find_connected_socket(src, dst);
>+	sk = __vsock_find_connected_socket(src, dst, net);
> 	if (sk)
> 		sock_hold(sk);
>
>@@ -644,6 +668,7 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> {
> 	static u32 port;
> 	struct sockaddr_vm new_addr;
>+	struct net *net = sock_net(sk_vsock(vsk));
>
> 	if (!port)
> 		port = get_random_u32_above(LAST_RESERVED_PORT);
>@@ -660,7 +685,7 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>
> 			new_addr.svm_port = port++;
>
>-			if (!__vsock_find_bound_socket(&new_addr)) {
>+			if (!__vsock_find_bound_socket(&new_addr, net)) {
> 				found = true;
> 				break;
> 			}
>@@ -677,7 +702,7 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> 			return -EACCES;
> 		}
>
>-		if (__vsock_find_bound_socket(&new_addr))
>+		if (__vsock_find_bound_socket(&new_addr, net))
> 			return -EADDRINUSE;
> 	}
>
>diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>index 31342ab502b4fc35feb812d2c94e0e35ded73771..253609898d24f8a484fcfc3296011c6f501a72a8 100644
>--- a/net/vmw_vsock/hyperv_transport.c
>+++ b/net/vmw_vsock/hyperv_transport.c
>@@ -313,7 +313,7 @@ static void hvs_open_connection(struct vmbus_channel *chan)
> 		return;
>
> 	hvs_addr_init(&addr, conn_from_host ? if_type : if_instance);
>-	sk = vsock_find_bound_socket(&addr);
>+	sk = vsock_find_bound_socket(&addr, NULL);
> 	if (!sk)
> 		return;
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 7f7de6d8809655fe522749fbbc9025df71f071bd..256d2a4fe482b3cb938a681b6924be69b2065616 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1590,6 +1590,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> 			       struct sk_buff *skb)
> {
> 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
>+	struct net *net = vsock_global_net();

Why using vsock_global_net() in virtio and directly NULL in the others 
transports?

> 	struct sockaddr_vm src, dst;
> 	struct vsock_sock *vsk;
> 	struct sock *sk;
>@@ -1617,9 +1618,9 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> 	/* The socket must be in connected or bound table
> 	 * otherwise send reset back
> 	 */
>-	sk = vsock_find_connected_socket(&src, &dst);
>+	sk = vsock_find_connected_socket(&src, &dst, net);
> 	if (!sk) {
>-		sk = vsock_find_bound_socket(&dst);
>+		sk = vsock_find_bound_socket(&dst, net);
> 		if (!sk) {
> 			(void)virtio_transport_reset_no_sock(t, skb);
> 			goto free_pkt;
>diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
>index b370070194fa4ac0df45a073d389ffccf69a0029..373b9fe30a26c18aaa181fbc16db840d8f839b13 100644
>--- a/net/vmw_vsock/vmci_transport.c
>+++ b/net/vmw_vsock/vmci_transport.c
>@@ -703,9 +703,9 @@ static int vmci_transport_recv_stream_cb(void *data, struct vmci_datagram *dg)
> 	vsock_addr_init(&src, pkt->dg.src.context, pkt->src_port);
> 	vsock_addr_init(&dst, pkt->dg.dst.context, pkt->dst_port);
>
>-	sk = vsock_find_connected_socket(&src, &dst);
>+	sk = vsock_find_connected_socket(&src, &dst, NULL);
> 	if (!sk) {
>-		sk = vsock_find_bound_socket(&dst);
>+		sk = vsock_find_bound_socket(&dst, NULL);
> 		if (!sk) {
> 			/* We could not find a socket for this specified
> 			 * address.  If this packet is a RST, we just drop it.
>
>-- 2.47.1
>


