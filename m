Return-Path: <kvm+bounces-62882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8D3C52B37
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 15:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F84F4A43CC
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 14:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31DDE280014;
	Wed, 12 Nov 2025 14:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YNb3r4/u";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="t/VFszy0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D5527B50C
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 14:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762956883; cv=none; b=SHQ63WkB79a1SiiPaowEObCsBj+20czRQLi3AcAuZQTJ4Vi3fDQNHf0+EJUSVlqys/cdmWLgIRKmrbr/oSwHnCsMKggOfC5FicQVuVrkKrxwFxDbE8u9IUU2HGksqaLShlmDfnP6h5qEpJ7SKjHJDhqI6/HVe92uuYD38jq5sCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762956883; c=relaxed/simple;
	bh=JyctcxckwAEdDEqx5FKccCnHzggDD15toylMAuUgIp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R4tAvhxvgPJjPYZqsMO/zraMRwL0eAdogMG5uf/8oP+mCXmR3aDO9aBhY6rpIFnUGyFYHyFwN5wL6WBoebpuPy2MFtW0ViBR6QjaPFZ6FcauaSMBckPqHeJnQ8NRFiG8krM5hJhF3wAqZWvA0npT4sf9LPNtNcHjRqkRQBajgEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YNb3r4/u; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=t/VFszy0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762956880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5kleEVK8tpt4xZ7W2ZyV/cI7GmMyMgMVfb75BW0YW68=;
	b=YNb3r4/uB+QNHoSkCVmceHh7Exhh0mswkggsZFRLT8SBw/IEuREqM8PK7MjG0Yj8O7tgd9
	fLWaVbajkhV4CrmrSetTDIWfdvxRzFQ6DemHzpMqU3wjwTz7++tYVWc/KOsiXLifwXaeBK
	dhePoiIIn6wSZE8OcaGedD49Ir9UnCg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-RPB4IXJPNu2v0X6ZLd7DSQ-1; Wed, 12 Nov 2025 09:14:39 -0500
X-MC-Unique: RPB4IXJPNu2v0X6ZLd7DSQ-1
X-Mimecast-MFC-AGG-ID: RPB4IXJPNu2v0X6ZLd7DSQ_1762956875
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4ed846ac283so21988331cf.0
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 06:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762956875; x=1763561675; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5kleEVK8tpt4xZ7W2ZyV/cI7GmMyMgMVfb75BW0YW68=;
        b=t/VFszy0+0vZPMrKfIW1z/mid37MdNJGc/P1pvdeMq7DwIPfji8s0xiV0FsjuNSP7o
         ILboVDGUQnNyP71eYNHEKPDP228JaFKw3e/n3x/2wS6+v5XKcObL99708Gs5nPkl6ZlA
         ZwEo5Q5G6fOAFfNMhdc6BGlc8FPUjvlhzxht/udrtPUz6C6IOA/he9P7bQyKFLHQYbBq
         1qYj/JJFa0pinzd8189I7z62bNuc2WOVC8ZTNPUab4Z4GPDbsXYTl8maCWXi7kyAUSam
         8qz9Udh/UlWvTA15804tvP+RO+bJcf9e80UOIvjL7Ccum565ySUzcjShxBIyP0IKPQeJ
         H2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762956875; x=1763561675;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5kleEVK8tpt4xZ7W2ZyV/cI7GmMyMgMVfb75BW0YW68=;
        b=O6kssKFI4Qmj0bosO7XQCmjpHVWD+KqOQZSr06LM0wWQ64PFHbkKNOKuB1zjz81l7m
         QxnHi1CxxgWaGiKYApSYdd5VIQ0jmV4C4nf5paAQPXX+MR6FoCSdl/ulWfQXpsuB2HkI
         IjPwBsX2KVYB1JUYOj1R+VQFneoQNMzxIiFbHPOe4VpUPCEXUGUdD7rkpJp3rYOO7t6d
         yapdtLi+JVjN7Lh8ZmeN7XBI9JNbXQlcJealtYYU0ffeBLYiwEvzKyCoFpe6UXhwJGqn
         hgkcPXX4wfHq0N15qUWljSFb8x97RrDqAXxSbLlJbii/j16y6ZpTaq2apK87kXPJ+56q
         O+Ug==
X-Forwarded-Encrypted: i=1; AJvYcCWv+TN3+9SjfZz6DsQF4ZimYAMs+EwDHj0l95xptw9yL6i3jVCHbZ4E2HAB/ipnPEs7YCg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0H6D4PL3n4SCNviu55jU5RAEKnRVxZMNJoohuwYGP5eZx7YeG
	xFNKaOwVBf61mLCdReCpgC8mDw/JQyaJs6A3TYx3mNBLeZdt0cIlQGbcN2Fw3f9ALVnyKOhccDt
	u2VkXGnkM8yzwcQfCRxii7gK/+F5kbTNiffqPYE5+YEpnBN4pp/+3mg==
X-Gm-Gg: ASbGncsLKwf5HZIhAIzH+LyKZ5WoIze2PCU/jGJyOUUdUQ6xx/d71LYjZdDt3/CzN1T
	5NYqxNSwgHvr1NnjpxpIx13a88Bte0z7IoMVruORlVBdBRNTWVB2/jt+aVanqf215yWTJOqIOyK
	196EDEnYxmHpllzkPgztFVIC4huNX00W3e4xoMaQwJHW1tqbTqtOKWkKNA9pR7D+UMLBoFMNxKm
	ORqj9SrCArjwuuZzwQhhXK8gcC5+Y/LLG/rfxJ4KoyToCMeXrnZzE9bPirwr3gTtlGvBZl8OgD2
	idKZ/Sb/3yuyZKzrAxrX9eZilyb8inqlHsgmP9K4mSgU0PYo0ML0CP9YF5tQ6KjfwwJVlkrsklk
	pr6+nkQ162Rd/nlhbvcKrWdc2CAHpy4cOn1B3BUK7v7aYOumoFN4=
X-Received: by 2002:ac8:5983:0:b0:4ec:a568:7b1e with SMTP id d75a77b69052e-4edcaaec3e2mr78006121cf.18.1762956875031;
        Wed, 12 Nov 2025 06:14:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHutV4q27lbE8C6HLafJNOda9w2qwvdCEtRKJttm7/ujNKk26qiibWyBgHPT9eWaQJRZvPw+Q==
X-Received: by 2002:ac8:5983:0:b0:4ec:a568:7b1e with SMTP id d75a77b69052e-4edcaaec3e2mr78004731cf.18.1762956873927;
        Wed, 12 Nov 2025 06:14:33 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-153.retail.telecomitalia.it. [79.46.200.153])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29a85d2efsm200544485a.14.2025.11.12.06.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 06:14:33 -0800 (PST)
Date: Wed, 12 Nov 2025 15:14:23 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>, berrange@redhat.com, 
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v9 02/14] vsock: add netns to vsock core
Message-ID: <nrqn2cye7pepfb3fafyehvmymeazas3mjhwerkibzd3kub77sz@jalo3y6dyygm>
References: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
 <20251111-vsock-vmtest-v9-2-852787a37bed@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251111-vsock-vmtest-v9-2-852787a37bed@meta.com>

On Tue, Nov 11, 2025 at 10:54:44PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add netns logic to vsock core. Additionally, modify transport hook
>prototypes to be used by later transport-specific patches (e.g.,
>*_seqpacket_allow()).
>
>Namespaces are supported primarily by changing socket lookup functions
>(e.g., vsock_find_connected_socket()) to take into account the socket
>namespace and the namespace mode before considering a candidate socket a
>"match".
>
>This patch also introduces the sysctl /proc/sys/net/vsock/ns_mode that
>accepts the "global" or "local" mode strings.
>
>Add netns functionality (initialization, passing to transports, procfs,
>etc...) to the af_vsock socket layer. Later patches that add netns
>support to transports depend on this patch.
>
>seqpacket_allow() callbacks are modified to take a vsk so that transport
>implementations can inspect sock_net(sk) and vsk->net_mode when performing
>lookups (e.g., vhost does this in its future netns patch). Because the
>API change affects all transports, it seemed more appropriate to make
>this internal API change in the "vsock core" patch then in the "vhost"
>patch.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v9:
>- remove virtio_vsock_alloc_rx_skb() (Stefano)
>- remove vsock_global_dummy_net, not needed as net=NULL +
>  net_mode=VSOCK_NET_MODE_GLOBAL achieves identical result
>
>Changes in v7:
>- hv_sock: fix hyperv build error
>- explain why vhost does not use the dummy
>- explain usage of __vsock_global_dummy_net
>- explain why VSOCK_NET_MODE_STR_MAX is 8 characters
>- use switch-case in vsock_net_mode_string()
>- avoid changing transports as much as possible
>- add vsock_find_{bound,connected}_socket_net()
>- rename `vsock_hdr` to `sysctl_hdr`
>- add virtio_vsock_alloc_linear_skb() wrapper for setting dummy net and
>  global mode for virtio-vsock, move skb->cb zero-ing into wrapper
>- explain seqpacket_allow() change
>- move net setting to __vsock_create() instead of vsock_create() so
>  that child sockets also have their net assigned upon accept()
>
>Changes in v6:
>- unregister sysctl ops in vsock_exit()
>- af_vsock: clarify description of CID behavior
>- af_vsock: fix buf vs buffer naming, and length checking
>- af_vsock: fix length checking w/ correct ctl_table->maxlen
>
>Changes in v5:
>- vsock_global_net() -> vsock_global_dummy_net()
>- update comments for new uAPI
>- use /proc/sys/net/vsock/ns_mode instead of /proc/net/vsock_ns_mode
>- add prototype changes so patch remains compilable
>---
> drivers/vhost/vsock.c            |   4 +-
> include/net/af_vsock.h           |   8 +-
> net/vmw_vsock/af_vsock.c         | 251 ++++++++++++++++++++++++++++++++++++---
> net/vmw_vsock/virtio_transport.c |   4 +-
> net/vmw_vsock/vsock_loopback.c   |   4 +-
> 5 files changed, 247 insertions(+), 24 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index ae01457ea2cd..34adf0cf9124 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -404,7 +404,7 @@ static bool vhost_transport_msgzerocopy_allow(void)
> 	return true;
> }
>
>-static bool vhost_transport_seqpacket_allow(u32 remote_cid);
>+static bool vhost_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid);
>
> static struct virtio_transport vhost_transport = {
> 	.transport = {
>@@ -460,7 +460,7 @@ static struct virtio_transport vhost_transport = {
> 	.send_pkt = vhost_transport_send_pkt,
> };
>
>-static bool vhost_transport_seqpacket_allow(u32 remote_cid)
>+static bool vhost_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid)
> {
> 	struct vhost_vsock *vsock;
> 	bool seqpacket_allow = false;
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index f3c3f74355e8..cfd121bb5ab7 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -145,7 +145,7 @@ struct vsock_transport {
> 				     int flags);
> 	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
> 				 size_t len);
>-	bool (*seqpacket_allow)(u32 remote_cid);
>+	bool (*seqpacket_allow)(struct vsock_sock *vsk, u32 remote_cid);
> 	u32 (*seqpacket_has_data)(struct vsock_sock *vsk);
>
> 	/* Notification. */
>@@ -218,6 +218,12 @@ void vsock_remove_connected(struct vsock_sock *vsk);
> struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
> struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
> 					 struct sockaddr_vm *dst);
>+struct sock *vsock_find_bound_socket_net(struct sockaddr_vm *addr, struct net *net,
>+					 enum vsock_net_mode net_mode);
>+struct sock *vsock_find_connected_socket_net(struct sockaddr_vm *src,
>+					     struct sockaddr_vm *dst,
>+					     struct net *net,
>+					     enum vsock_net_mode net_mode);
> void vsock_remove_sock(struct vsock_sock *vsk);
> void vsock_for_each_connected_socket(struct vsock_transport *transport,
> 				     void (*fn)(struct sock *sk));
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 72bb6b7ed386..c0b5946bdc95 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -83,6 +83,35 @@
>  *   TCP_ESTABLISHED - connected
>  *   TCP_CLOSING - disconnecting
>  *   TCP_LISTEN - listening
>+ *
>+ * - Namespaces in vsock support two different modes configured
>+ *   through /proc/sys/net/vsock/ns_mode. The modes are "local" and "global".
>+ *   Each mode defines how the namespace interacts with CIDs.
>+ *   /proc/sys/net/vsock/ns_mode is write-once, so that it may be configured
>+ *   and locked down by a namespace manager. The default is "global". The mode
>+ *   is set per-namespace.
>+ *
>+ *   The modes affect the allocation and accessibility of CIDs as follows:
>+ *
>+ *   - global - access and allocation are all system-wide
>+ *      - all CID allocation from global namespaces draw from the same
>+ *        system-wide pool
>+ *      - if one global namespace has already allocated some CID, another
>+ *        global namespace will not be able to allocate the same CID
>+ *      - global mode AF_VSOCK sockets can reach any VM or socket in any global
>+ *        namespace, they are not contained to only their own namespace
>+ *      - AF_VSOCK sockets in a global mode namespace cannot reach VMs or
>+ *        sockets in any local mode namespace
>+ *   - local - access and allocation are contained within the namespace
>+ *     - CID allocation draws only from a private pool local only to the
>+ *       namespace, and does not affect the CIDs available for allocation in any
>+ *       other namespace (global or local)
>+ *     - VMs in a local namespace do not collide with CIDs in any other local
>+ *       namespace or any global namespace. For example, if a VM in a local mode
>+ *       namespace is given CID 10, then CID 10 is still available for
>+ *       allocation in any other namespace, but not in the same namespace
>+ *     - AF_VSOCK sockets in a local mode namespace can connect only to VMs or
>+ *       other sockets within their own namespace.

Should we also document what happen to pre-existing sockets/devices if 
the user change the mode ?

The rest LGTM!

Thanks,
Stefano

>  */
>
> #include <linux/compat.h>
>@@ -100,6 +129,7 @@
> #include <linux/module.h>
> #include <linux/mutex.h>
> #include <linux/net.h>
>+#include <linux/proc_fs.h>
> #include <linux/poll.h>
> #include <linux/random.h>
> #include <linux/skbuff.h>
>@@ -111,9 +141,18 @@
> #include <linux/workqueue.h>
> #include <net/sock.h>
> #include <net/af_vsock.h>
>+#include <net/netns/vsock.h>
> #include <uapi/linux/vm_sockets.h>
> #include <uapi/asm-generic/ioctls.h>
>
>+#define VSOCK_NET_MODE_STR_GLOBAL "global"
>+#define VSOCK_NET_MODE_STR_LOCAL "local"
>+
>+/* 6 chars for "global", 1 for null-terminator, and 1 more for '\n'.
>+ * The newline is added by proc_dostring() for read operations.
>+ */
>+#define VSOCK_NET_MODE_STR_MAX 8
>+
> static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
> static void vsock_sk_destruct(struct sock *sk);
> static int vsock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
>@@ -235,33 +274,44 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
> 	sock_put(&vsk->sk);
> }
>
>-static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
>+static struct sock *__vsock_find_bound_socket_net(struct sockaddr_vm *addr,
>+						  struct net *net,
>+						  enum vsock_net_mode net_mode)
> {
> 	struct vsock_sock *vsk;
>
> 	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
>-		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
>-			return sk_vsock(vsk);
>+		struct sock *sk = sk_vsock(vsk);
>+
>+		if (vsock_addr_equals_addr(addr, &vsk->local_addr) &&
>+		    vsock_net_check_mode(sock_net(sk), vsk->net_mode, net, net_mode))
>+			return sk;
>
> 		if (addr->svm_port == vsk->local_addr.svm_port &&
> 		    (vsk->local_addr.svm_cid == VMADDR_CID_ANY ||
>-		     addr->svm_cid == VMADDR_CID_ANY))
>-			return sk_vsock(vsk);
>+		     addr->svm_cid == VMADDR_CID_ANY) &&
>+		     vsock_net_check_mode(sock_net(sk), vsk->net_mode, net, net_mode))
>+			return sk;
> 	}
>
> 	return NULL;
> }
>
>-static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
>-						  struct sockaddr_vm *dst)
>+static struct sock *__vsock_find_connected_socket_net(struct sockaddr_vm *src,
>+						      struct sockaddr_vm *dst,
>+						      struct net *net,
>+						      enum vsock_net_mode net_mode)
> {
> 	struct vsock_sock *vsk;
>
> 	list_for_each_entry(vsk, vsock_connected_sockets(src, dst),
> 			    connected_table) {
>+		struct sock *sk = sk_vsock(vsk);
>+
> 		if (vsock_addr_equals_addr(src, &vsk->remote_addr) &&
>-		    dst->svm_port == vsk->local_addr.svm_port) {
>-			return sk_vsock(vsk);
>+		    dst->svm_port == vsk->local_addr.svm_port &&
>+		    vsock_net_check_mode(sock_net(sk), vsk->net_mode, net, net_mode)) {
>+			return sk;
> 		}
> 	}
>
>@@ -304,12 +354,14 @@ void vsock_remove_connected(struct vsock_sock *vsk)
> }
> EXPORT_SYMBOL_GPL(vsock_remove_connected);
>
>-struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
>+struct sock *vsock_find_bound_socket_net(struct sockaddr_vm *addr,
>+					 struct net *net,
>+					 enum vsock_net_mode net_mode)
> {
> 	struct sock *sk;
>
> 	spin_lock_bh(&vsock_table_lock);
>-	sk = __vsock_find_bound_socket(addr);
>+	sk = __vsock_find_bound_socket_net(addr, net, net_mode);
> 	if (sk)
> 		sock_hold(sk);
>
>@@ -317,15 +369,23 @@ struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
>
> 	return sk;
> }
>+EXPORT_SYMBOL_GPL(vsock_find_bound_socket_net);
>+
>+struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
>+{
>+	return vsock_find_bound_socket_net(addr, NULL, VSOCK_NET_MODE_GLOBAL);
>+}
> EXPORT_SYMBOL_GPL(vsock_find_bound_socket);
>
>-struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
>-					 struct sockaddr_vm *dst)
>+struct sock *vsock_find_connected_socket_net(struct sockaddr_vm *src,
>+					     struct sockaddr_vm *dst,
>+					     struct net *net,
>+					     enum vsock_net_mode net_mode)
> {
> 	struct sock *sk;
>
> 	spin_lock_bh(&vsock_table_lock);
>-	sk = __vsock_find_connected_socket(src, dst);
>+	sk = __vsock_find_connected_socket_net(src, dst, net, net_mode);
> 	if (sk)
> 		sock_hold(sk);
>
>@@ -333,6 +393,14 @@ struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
>
> 	return sk;
> }
>+EXPORT_SYMBOL_GPL(vsock_find_connected_socket_net);
>+
>+struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
>+					 struct sockaddr_vm *dst)
>+{
>+	return vsock_find_connected_socket_net(src, dst,
>+					       NULL, VSOCK_NET_MODE_GLOBAL);
>+}
> EXPORT_SYMBOL_GPL(vsock_find_connected_socket);
>
> void vsock_remove_sock(struct vsock_sock *vsk)
>@@ -528,7 +596,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>
> 	if (sk->sk_type == SOCK_SEQPACKET) {
> 		if (!new_transport->seqpacket_allow ||
>-		    !new_transport->seqpacket_allow(remote_cid)) {
>+		    !new_transport->seqpacket_allow(vsk, remote_cid)) {
> 			module_put(new_transport->module);
> 			return -ESOCKTNOSUPPORT;
> 		}
>@@ -676,6 +744,7 @@ static void vsock_pending_work(struct work_struct *work)
> static int __vsock_bind_connectible(struct vsock_sock *vsk,
> 				    struct sockaddr_vm *addr)
> {
>+	struct net *net = sock_net(sk_vsock(vsk));
> 	static u32 port;
> 	struct sockaddr_vm new_addr;
>
>@@ -695,7 +764,8 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>
> 			new_addr.svm_port = port++;
>
>-			if (!__vsock_find_bound_socket(&new_addr)) {
>+			if (!__vsock_find_bound_socket_net(&new_addr, net,
>+							   vsk->net_mode)) {
> 				found = true;
> 				break;
> 			}
>@@ -712,7 +782,8 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> 			return -EACCES;
> 		}
>
>-		if (__vsock_find_bound_socket(&new_addr))
>+		if (__vsock_find_bound_socket_net(&new_addr, net,
>+						  vsk->net_mode))
> 			return -EADDRINUSE;
> 	}
>
>@@ -836,6 +907,8 @@ static struct sock *__vsock_create(struct net *net,
> 		vsk->buffer_max_size = VSOCK_DEFAULT_BUFFER_MAX_SIZE;
> 	}
>
>+	vsk->net_mode = vsock_net_mode(net);
>+
> 	return sk;
> }
>
>@@ -2636,6 +2709,141 @@ static struct miscdevice vsock_device = {
> 	.fops		= &vsock_device_ops,
> };
>
>+static int vsock_net_mode_string(const struct ctl_table *table, int write,
>+				 void *buffer, size_t *lenp, loff_t *ppos)
>+{
>+	char data[VSOCK_NET_MODE_STR_MAX] = {0};
>+	enum vsock_net_mode mode;
>+	struct ctl_table tmp;
>+	struct net *net;
>+	int ret;
>+
>+	if (!table->data || !table->maxlen || !*lenp) {
>+		*lenp = 0;
>+		return 0;
>+	}
>+
>+	net = current->nsproxy->net_ns;
>+	tmp = *table;
>+	tmp.data = data;
>+
>+	if (!write) {
>+		const char *p;
>+
>+		mode = vsock_net_mode(net);
>+
>+		switch (mode) {
>+		case VSOCK_NET_MODE_GLOBAL:
>+			p = VSOCK_NET_MODE_STR_GLOBAL;
>+			break;
>+		case VSOCK_NET_MODE_LOCAL:
>+			p = VSOCK_NET_MODE_STR_LOCAL;
>+			break;
>+		default:
>+			WARN_ONCE(true, "netns has invalid vsock mode");
>+			*lenp = 0;
>+			return 0;
>+		}
>+
>+		strscpy(data, p, sizeof(data));
>+		tmp.maxlen = strlen(p);
>+	}
>+
>+	ret = proc_dostring(&tmp, write, buffer, lenp, ppos);
>+	if (ret)
>+		return ret;
>+
>+	if (write) {
>+		if (*lenp >= sizeof(data))
>+			return -EINVAL;
>+
>+		if (!strncmp(data, VSOCK_NET_MODE_STR_GLOBAL, sizeof(data)))
>+			mode = VSOCK_NET_MODE_GLOBAL;
>+		else if (!strncmp(data, VSOCK_NET_MODE_STR_LOCAL, sizeof(data)))
>+			mode = VSOCK_NET_MODE_LOCAL;
>+		else
>+			return -EINVAL;
>+
>+		if (!vsock_net_write_mode(net, mode))
>+			return -EPERM;
>+	}
>+
>+	return 0;
>+}
>+
>+static struct ctl_table vsock_table[] = {
>+	{
>+		.procname	= "ns_mode",
>+		.data		= &init_net.vsock.mode,
>+		.maxlen		= VSOCK_NET_MODE_STR_MAX,
>+		.mode		= 0644,
>+		.proc_handler	= vsock_net_mode_string
>+	},
>+};
>+
>+static int __net_init vsock_sysctl_register(struct net *net)
>+{
>+	struct ctl_table *table;
>+
>+	if (net_eq(net, &init_net)) {
>+		table = vsock_table;
>+	} else {
>+		table = kmemdup(vsock_table, sizeof(vsock_table), GFP_KERNEL);
>+		if (!table)
>+			goto err_alloc;
>+
>+		table[0].data = &net->vsock.mode;
>+	}
>+
>+	net->vsock.sysctl_hdr = register_net_sysctl_sz(net, "net/vsock", table,
>+						       ARRAY_SIZE(vsock_table));
>+	if (!net->vsock.sysctl_hdr)
>+		goto err_reg;
>+
>+	return 0;
>+
>+err_reg:
>+	if (!net_eq(net, &init_net))
>+		kfree(table);
>+err_alloc:
>+	return -ENOMEM;
>+}
>+
>+static void vsock_sysctl_unregister(struct net *net)
>+{
>+	const struct ctl_table *table;
>+
>+	table = net->vsock.sysctl_hdr->ctl_table_arg;
>+	unregister_net_sysctl_table(net->vsock.sysctl_hdr);
>+	if (!net_eq(net, &init_net))
>+		kfree(table);
>+}
>+
>+static void vsock_net_init(struct net *net)
>+{
>+	net->vsock.mode = VSOCK_NET_MODE_GLOBAL;
>+}
>+
>+static __net_init int vsock_sysctl_init_net(struct net *net)
>+{
>+	vsock_net_init(net);
>+
>+	if (vsock_sysctl_register(net))
>+		return -ENOMEM;
>+
>+	return 0;
>+}
>+
>+static __net_exit void vsock_sysctl_exit_net(struct net *net)
>+{
>+	vsock_sysctl_unregister(net);
>+}
>+
>+static struct pernet_operations vsock_sysctl_ops __net_initdata = {
>+	.init = vsock_sysctl_init_net,
>+	.exit = vsock_sysctl_exit_net,
>+};
>+
> static int __init vsock_init(void)
> {
> 	int err = 0;
>@@ -2663,10 +2871,18 @@ static int __init vsock_init(void)
> 		goto err_unregister_proto;
> 	}
>
>+	if (register_pernet_subsys(&vsock_sysctl_ops)) {
>+		err = -ENOMEM;
>+		goto err_unregister_sock;
>+	}
>+
>+	vsock_net_init(&init_net);
> 	vsock_bpf_build_proto();
>
> 	return 0;
>
>+err_unregister_sock:
>+	sock_unregister(AF_VSOCK);
> err_unregister_proto:
> 	proto_unregister(&vsock_proto);
> err_deregister_misc:
>@@ -2680,6 +2896,7 @@ static void __exit vsock_exit(void)
> 	misc_deregister(&vsock_device);
> 	sock_unregister(AF_VSOCK);
> 	proto_unregister(&vsock_proto);
>+	unregister_pernet_subsys(&vsock_sysctl_ops);
> }
>
> const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *vsk)
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 8c867023a2e5..f92f23be3f59 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -536,7 +536,7 @@ static bool virtio_transport_msgzerocopy_allow(void)
> 	return true;
> }
>
>-static bool virtio_transport_seqpacket_allow(u32 remote_cid);
>+static bool virtio_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid);
>
> static struct virtio_transport virtio_transport = {
> 	.transport = {
>@@ -593,7 +593,7 @@ static struct virtio_transport virtio_transport = {
> 	.can_msgzerocopy = virtio_transport_can_msgzerocopy,
> };
>
>-static bool virtio_transport_seqpacket_allow(u32 remote_cid)
>+static bool virtio_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid)
> {
> 	struct virtio_vsock *vsock;
> 	bool seqpacket_allow;
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index bc2ff918b315..a8f218f0c5a3 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -46,7 +46,7 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
> 	return 0;
> }
>
>-static bool vsock_loopback_seqpacket_allow(u32 remote_cid);
>+static bool vsock_loopback_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid);
> static bool vsock_loopback_msgzerocopy_allow(void)
> {
> 	return true;
>@@ -106,7 +106,7 @@ static struct virtio_transport loopback_transport = {
> 	.send_pkt = vsock_loopback_send_pkt,
> };
>
>-static bool vsock_loopback_seqpacket_allow(u32 remote_cid)
>+static bool vsock_loopback_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid)
> {
> 	return true;
> }
>
>-- 
>2.47.3
>


