Return-Path: <kvm+bounces-18029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A8D18CD08C
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 12:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77E3F1F21885
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 10:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10141144315;
	Thu, 23 May 2024 10:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iiwpL3V6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FADC142621
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 10:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716461053; cv=none; b=qAku/d0DxsXo5ZPz2h/eoYjOuy+gDbPWjaqFZBnMGIbNRMWfr/WUfmR1CxBYgFPTUZQp+XLGzNzix2T9DoRHhx4KJxv/dzMrFrZ2rzfnNZJCh8WUngh5hJTOPyrm5sJvG+Ul8OuhH+C3A/XxEGQdafVo03IngbuubMlZxjPoE7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716461053; c=relaxed/simple;
	bh=2nA6Acq97RppG8Rj9ntCO9z8r4SdCF6LPtZIBAFjOIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vDpGYDZ7BY4dqY1E1msrDCvfsD3uqL6DYA98fgmDJSsgo86mqq0hWQ4FP5M9cJre8Oevkqn/Q6C2velicG2WePmzpImDiruE/BIUMX6kfdqMvqNsTRVl5c6U0pls5N9Gds+fiYsqXJsH+RF9cRtUnZZBlgbwQ3gnSfPKS5/LFNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iiwpL3V6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716461049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6Zygmvij6H+uk7ZnSf89NRhWTU85rHPhmCFN5vmlOF4=;
	b=iiwpL3V6E7zBtzFvMESdz854F+s27nEAfjTJFHIKrdaTIPb4a7THRQzzTC7sHzIJaQj2c5
	Py33MDYrlUogKkkiaO5u6Nt3aLkc96fDinU0ZB1NkRs5rAFts0iWqidxLJ/cTxvAu95l6g
	orKh4r9m3Yh6BUKRjvNeS6ea+TIuwJ0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-Oj4zMHHhOoiM9vkLvL1ERg-1; Thu, 23 May 2024 06:44:07 -0400
X-MC-Unique: Oj4zMHHhOoiM9vkLvL1ERg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-794a0288ddfso161468385a.1
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 03:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716461047; x=1717065847;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Zygmvij6H+uk7ZnSf89NRhWTU85rHPhmCFN5vmlOF4=;
        b=ay4yHvyQeob0TVTrtnAKolQm3EUM7BVAqFBgJRa6Rof0hILqGhZYg1kVAqVMmHgSWK
         dthoXnsObCFRXB1nlCkK8AnrpSBPOsnHwPzQDWSsbImGkr7EKVpGxhveTqFK5UvcsRnN
         of/HRkufA7kFSvJYvKSZSC7aveT0hK08MX9J853Ey++NWTnFpebiNPSQuIsEKTnhsYxj
         08X80Gu558c8YpZjm5NWSqZk6fca2iLWaFb001wftoEZG4l8ubrzGrUjOmm1GxCRcE1f
         uX2jw66w0XHJ+DHx8yPPYeE0BuPLWaqQLn9ugIhpu52S+ttLQYVDKlEs6tuiGpzfWMcU
         EDkw==
X-Forwarded-Encrypted: i=1; AJvYcCUvedTwY+MO9yiIiMUkr3BiuzrjFTTGXYUyG5eGW2flbz/a2QjwWbte+7wegMu4ibwW/N1dj5S6myUZxD5y+KIQ92Ji
X-Gm-Message-State: AOJu0YzD7QgIXzyNDKGmaYyiaIZLU6nbTtCBQ9t8DZXhHRo8d1sBjMpS
	yaOsvkQ+N+RV96vyBuU3D1KbwFlzsIPVs4lEY3bykiBRJFu+YUAcHjteqszQbu3lB9YqfcpnU59
	fbjIyqIbTcc+aGvjiE6BtDKuFo8DUdtl23P8Rox7oR/j/bvfhJg==
X-Received: by 2002:a05:620a:430f:b0:790:f382:23ec with SMTP id af79cd13be357-794a0960f11mr317504785a.16.1716461046771;
        Thu, 23 May 2024 03:44:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGE+YoRZpX1JPznYvw+pWz0mAgeBbmvtKpmODy2eLi+FNZfpuiEIDnHy3GnbOeUX4KmibDTg==
X-Received: by 2002:a05:620a:430f:b0:790:f382:23ec with SMTP id af79cd13be357-794a0960f11mr317502285a.16.1716461046268;
        Thu, 23 May 2024 03:44:06 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-109.retail.telecomitalia.it. [79.53.30.109])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7930f124416sm675768085a.119.2024.05.23.03.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 03:44:05 -0700 (PDT)
Date: Thu, 23 May 2024 12:43:59 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: stefanha@redhat.com, mst@redhat.com, davem@davemloft.net, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [RFC PATCH 2/5] vsock/virtio: Add support for multi-devices
Message-ID: <4ogioby7q4togpjupcjwhu7gupggghneo7kzlfei3q5padjm6z@7edcp65wl4oy>
References: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
 <20240517144607.2595798-3-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240517144607.2595798-3-niuxuewei.nxw@antgroup.com>

On Fri, May 17, 2024 at 10:46:04PM GMT, Xuewei Niu wrote:
>The maximum number of devices is limited by `MAX_VSOCK_NUM`.
>
>Extends `vsock_transport` struct with 4 methods to support multi-devices:
>
>* `get_virtio_vsock()`: It receives a CID, and returns a struct of virtio
>  vsock. This method is designed to select a vsock device by its CID.
>* `get_default_cid()`: It receives nothing, returns the default CID of the
>  first vsock device registered to the kernel.
>* `get_local_cids()`: It returns a vector of vsock devices' CIDs.
>* `compare_order()`: It receives two different CIDs, named "left" and
>  "right" respectively. It returns "-1" while the "left" is behind the
>  "right". Otherwise, return "1".
>
>`get_local_cid()` is retained, but returns "-1" if the transport supports
>multi-devices.
>
>Replaces the single instance of `virtio_vsock` with a list, named
>`virtio_vsock_list`. The devices are inserted into the list when probing.
>
>The kernel will deny devices from being registered if there are conflicts
>existing in CIDs or orders.
>
>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>---
> include/net/af_vsock.h                  |  16 ++
> include/uapi/linux/vm_sockets.h         |   6 +
> net/vmw_vsock/af_vsock.c                |  82 ++++++--
> net/vmw_vsock/virtio_transport.c        | 246 ++++++++++++++++++------
> net/vmw_vsock/virtio_transport_common.c |  10 +-
> 5 files changed, 293 insertions(+), 67 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 535701efc1e5..0151296a0bc5 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -174,6 +174,22 @@ struct vsock_transport {
>
> 	/* Addressing. */
> 	u32 (*get_local_cid)(void);
>+	/* Held rcu read lock by the caller. */

We should also explain why the rcu is needed.

>+	struct virtio_vsock *(*get_virtio_vsock)(unsigned int cid);

af_vsock supports several transports (i.e. HyperV, VMCI, VIRTIO/VHOST,
loobpack), so we need to be generic here.

In addition, the pointer returned by this function is never used, so
why we need this?

>+	unsigned int (*get_default_cid)(void);
>+	/* Get an list containing all the CIDs of registered vsock.   Return
>+	 * the length of the list.
>+	 *
>+	 * Held rcu read lock by the caller.
>+	 */
>+	int (*get_local_cids)(unsigned int *local_cids);

Why int? get_local_cid() returns an u32, we should do the same.

In addition, can we remove get_local_cid() and implement 
get_local_cids() for all the transports?

>+	/* Compare the order of two devices.  Given the guest CIDs of two
>+	 * different devices, returns -1 while the left is behind the right.
>+	 * Otherwise, return 1.
>+	 *
>+	 * Held rcu read lock by the caller.
>+	 */
>+	int (*compare_order)(unsigned int left, unsigned int right);

Please check better the type for CIDs all over the place.

>
> 	/* Read a single skb */
> 	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
>diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
>index ed07181d4eff..36ca5023293a 100644
>--- a/include/uapi/linux/vm_sockets.h
>+++ b/include/uapi/linux/vm_sockets.h
>@@ -189,6 +189,12 @@ struct sockaddr_vm {
> 			       sizeof(__u8)];
> };
>
>+/* The maximum number of vsock devices.  Each vsock device has an exclusive
>+ * context id.
>+ */
>+
>+#define MAX_VSOCK_NUM 16

This is used internally in AF_VSOCK, I don't think we should expose it
in the UAPI.


>+
> #define IOCTL_VM_SOCKETS_GET_LOCAL_CID		_IO(7, 0xb9)
>
> /* MSG_ZEROCOPY notifications are encoded in the standard error format,
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 54ba7316f808..da06ddc940cd 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -234,19 +234,45 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
>
> static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
> {
>-	struct vsock_sock *vsk;
>+	struct vsock_sock *vsk, *any_vsk = NULL;
>
>+	rcu_read_lock();

Why the rcu is needed?

> 	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) 
> 	{
>+		/* The highest priority: full match. */
> 		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
>-			return sk_vsock(vsk);
>+			goto out;
>
>-		if (addr->svm_port == vsk->local_addr.svm_port &&
>-		    (vsk->local_addr.svm_cid == VMADDR_CID_ANY ||
>-		     addr->svm_cid == VMADDR_CID_ANY))
>-			return sk_vsock(vsk);
>+		/* Port match */
>+		if (addr->svm_port == vsk->local_addr.svm_port) {
>+			/* The second priority: local cid is VMADDR_CID_ANY. */
>+			if (vsk->local_addr.svm_cid == VMADDR_CID_ANY)
>+				goto out;
>+
>+			/* The third priority: local cid isn't VMADDR_CID_ANY. */
>+			if (addr->svm_cid == VMADDR_CID_ANY) {
>+				if (!any_vsk) {
>+					any_vsk = vsk;
>+					continue;
>+				}
>+				// Use the device with smaller order
>+				if (vsk->transport->compare_order(any_vsk->local_addr.svm_cid,
>+								  vsk->local_addr.svm_cid) < 0)
>+					any_vsk = vsk;
>+			}
>+		}
>+	}
>+	rcu_read_unlock();
>+
>+	if (any_vsk) {
>+		pr_debug("matched a any_vsk at %p\n", any_vsk);
>+		return sk_vsock(any_vsk);
> 	}
>
> 	return NULL;
>+
>+out:
>+	rcu_read_unlock();
>+	return sk_vsock(vsk);
> }
>
> static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
>@@ -408,7 +434,11 @@ static bool vsock_use_local_transport(unsigned int remote_cid)
> 		return true;
>
> 	if (transport_g2h) {
>-		return remote_cid == transport_g2h->get_local_cid();
>+		if (transport_g2h->get_virtio_vsock)
>+			return transport_g2h->get_virtio_vsock(remote_cid) !=
>+			       NULL;
>+		else
>+			return remote_cid == transport_g2h->get_local_cid();
> 	} else {
> 		return remote_cid == VMADDR_CID_HOST;
> 	}
>@@ -516,9 +546,26 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> }
> EXPORT_SYMBOL_GPL(vsock_assign_transport);
>
>+bool transport_g2h_verify_cid(unsigned int cid)
>+{
>+	/* transports that support multi devices */
>+	rcu_read_lock();
>+	if (transport_g2h->get_virtio_vsock &&
>+	    (cid == VMADDR_CID_ANY || transport_g2h->get_virtio_vsock(cid))) {
>+		rcu_read_unlock();
>+		return true;
>+	}
>+	rcu_read_unlock();
>+	/* other transports */
>+	if (cid == transport_g2h->get_local_cid())
>+		return true;
>+
>+	return false;
>+}
>+
> bool vsock_find_cid(unsigned int cid)
> {
>-	if (transport_g2h && cid == transport_g2h->get_local_cid())
>+	if (transport_g2h && transport_g2h_verify_cid(cid))
> 		return true;
>
> 	if (transport_h2g && cid == VMADDR_CID_HOST)
>@@ -697,7 +744,9 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
> 	/* Now bind to the provided address or select appropriate values if
> 	 * none are provided (VMADDR_CID_ANY and VMADDR_PORT_ANY).  Note that
> 	 * like AF_INET prevents binding to a non-local IP address (in most
>-	 * cases), we only allow binding to a local CID.
>+	 * cases), we only allow binding to a local CID. In the cases of
>+	 * multi-devices, only CIDs of vsock devices registered in the kernel
>+	 * are allowed.
> 	 */
> 	if (addr->svm_cid != VMADDR_CID_ANY && !vsock_find_cid(addr->svm_cid))
> 		return -EADDRNOTAVAIL;
>@@ -825,7 +874,6 @@ static void __vsock_release(struct sock *sk, int level)
> 			__vsock_release(pending, SINGLE_DEPTH_NESTING);
> 			sock_put(pending);
> 		}
>-

Unrelated change.

> 		release_sock(sk);
> 		sock_put(sk);
> 	}
>@@ -1181,7 +1229,12 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
> 		 */
>
> 		if (remote_addr->svm_cid == VMADDR_CID_ANY)
>-			remote_addr->svm_cid = transport->get_local_cid();
>+			if (transport->get_default_cid)
>+				remote_addr->svm_cid =
>+					transport->get_default_cid();
>+			else
>+				remote_addr->svm_cid =
>+					transport->get_local_cid();
>
> 		if (!vsock_addr_bound(remote_addr)) {
> 			err = -EINVAL;
>@@ -1191,7 +1244,12 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
> 		remote_addr = &vsk->remote_addr;
>
> 		if (remote_addr->svm_cid == VMADDR_CID_ANY)
>-			remote_addr->svm_cid = transport->get_local_cid();
>+			if (transport->get_default_cid)
>+				remote_addr->svm_cid =
>+					transport->get_default_cid();
>+			else
>+				remote_addr->svm_cid =
>+					transport->get_local_cid();
>
> 		/* XXX Should connect() or this function ensure remote_addr is
> 		 * bound?
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index ee5d306a96d0..93d25aeafb83 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -22,8 +22,8 @@
> #include <net/af_vsock.h>
>
> static struct workqueue_struct *virtio_vsock_workqueue;
>-static struct virtio_vsock __rcu *the_virtio_vsock;
>-static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
>+static LIST_HEAD(virtio_vsock_list); /* vsock multi-devices */
>+static DEFINE_MUTEX(virtio_vsock_list_mutex); /* protects virtio_vsock_list */
> static struct virtio_transport virtio_transport; /* forward declaration */
>
> struct virtio_vsock {
>@@ -62,6 +62,7 @@ struct virtio_vsock {
> 	struct virtio_vsock_event event_list[8];
>
> 	u32 guest_cid;
>+	u32 order;
> 	bool seqpacket_allow;
>
> 	/* These fields are used only in tx path in function
>@@ -74,24 +75,70 @@ struct virtio_vsock {
> 	 */
> 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
> 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
>+
>+	struct list_head node;
>+	struct rcu_head rcu;
> };
>
> static u32 virtio_transport_get_local_cid(void)
>+{
>+	return VMADDR_CID_ANY;
>+}
>+
>+/* Held rcu read lock by the caller. */
>+static struct virtio_vsock *virtio_transport_get_virtio_vsock(unsigned int cid)
> {
> 	struct virtio_vsock *vsock;
>-	u32 ret;
>+	list_for_each_entry(vsock, &virtio_vsock_list, node) {
>+		if (vsock->guest_cid == cid)
>+			return vsock;
>+	}
>+	return NULL;
>+}
>
>-	rcu_read_lock();
>-	vsock = rcu_dereference(the_virtio_vsock);
>-	if (!vsock) {
>-		ret = VMADDR_CID_ANY;
>-		goto out_rcu;
>+static unsigned int virtio_transport_get_default_cid(void)
>+{
>+	struct virtio_vsock *vsock;
>+
>+	vsock = list_first_or_null_rcu(&virtio_vsock_list, struct virtio_vsock,
>+				       node);
>+	if (!vsock)
>+		return VMADDR_CID_ANY;
>+
>+	return vsock->guest_cid;
>+}
>+
>+/* Held rcu read lock by the caller. */
>+static int virtio_transport_get_local_cids(u32 *cids)
>+{
>+	int count = 0;
>+	struct virtio_vsock *vsock;
>+
>+	if (!cids)
>+		return -EFAULT;
>+
>+	list_for_each_entry(vsock, &virtio_vsock_list, node) {
>+		cids[count++] = vsock->guest_cid;
> 	}
>+	return count;
>+}
>
>-	ret = vsock->guest_cid;
>-out_rcu:
>-	rcu_read_unlock();
>-	return ret;
>+/* Held rcu read lock by the caller. */
>+static int virtio_transport_compare_order(unsigned int left, unsigned int right)
>+{
>+	struct virtio_vsock *vsock;
>+
>+	if (left == right)
>+		return 0;
>+
>+	list_for_each_entry(vsock, &virtio_vsock_list, node) {
>+		if (right == vsock->guest_cid)
>+			return -1;
>+		if (left == vsock->guest_cid)
>+			return 1;
>+	}
>+
>+	return 0;
> }
>
> static void
>@@ -201,12 +248,16 @@ virtio_transport_send_pkt(struct sk_buff *skb)
> 	struct virtio_vsock_hdr *hdr;
> 	struct virtio_vsock *vsock;
> 	int len = skb->len;
>+	unsigned int src_cid;
>
> 	hdr = virtio_vsock_hdr(skb);
>+	src_cid = le64_to_cpu(hdr->src_cid);
>
> 	rcu_read_lock();
>-	vsock = rcu_dereference(the_virtio_vsock);
>+	vsock = virtio_transport_get_virtio_vsock(src_cid);
> 	if (!vsock) {
>+		pr_debug("pkt sending has been failed, as vsock with cid %u not found\n",
>+			 src_cid);
> 		kfree_skb(skb);
> 		len = -ENODEV;
> 		goto out_rcu;
>@@ -236,13 +287,17 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
> 	int cnt = 0, ret;
>
> 	rcu_read_lock();
>-	vsock = rcu_dereference(the_virtio_vsock);
>-	if (!vsock) {
>+	if (list_empty(&virtio_vsock_list)) {
> 		ret = -ENODEV;
> 		goto out_rcu;
> 	}
>
>-	cnt = virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
>+	list_for_each_entry(vsock, &virtio_vsock_list, node) {
>+		cnt = virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
>+		/* Skbs for the vsk belong to one virtio_vsock */
>+		if (cnt)
>+			break;
>+	}
>
> 	if (cnt) {
> 		struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
>@@ -385,6 +440,16 @@ static void virtio_vsock_update_guest_cid(struct virtio_vsock *vsock)
> 	vsock->guest_cid = le64_to_cpu(guest_cid);
> }
>
>+static void virtio_vsock_update_order(struct virtio_vsock *vsock)
>+{
>+	struct virtio_device *vdev = vsock->vdev;
>+	__le64 order;
>+
>+	vdev->config->get(vdev, offsetof(struct virtio_vsock_config, order),
>+			  &order, sizeof(order));
>+	vsock->order = le64_to_cpu(order);
>+}
>+
> /* event_lock must be held */
> static void virtio_vsock_event_handle(struct virtio_vsock *vsock,
> 				      struct virtio_vsock_event *event)
>@@ -492,13 +557,17 @@ static bool virtio_transport_msgzerocopy_allow(void)
> 	return true;
> }
>
>-static bool virtio_transport_seqpacket_allow(u32 remote_cid);
>+static bool virtio_transport_seqpacket_allow(u32 src_cid, u32 remote_cid);
>
> static struct virtio_transport virtio_transport = {
> 	.transport = {
> 		.module                   = THIS_MODULE,
>
> 		.get_local_cid            = virtio_transport_get_local_cid,
>+		.get_virtio_vsock         = virtio_transport_get_virtio_vsock,
>+		.get_default_cid          = virtio_transport_get_default_cid,
>+		.get_local_cids           = virtio_transport_get_local_cids,
>+		.compare_order            = virtio_transport_compare_order,
>
> 		.init                     = virtio_transport_do_socket_init,
> 		.destruct                 = virtio_transport_destruct,
>@@ -617,7 +686,38 @@ static void virtio_transport_rx_work(struct work_struct *work)
> static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
> {
> 	struct virtio_device *vdev = vsock->vdev;
>-	static const char * const names[] = {
>+	struct virtio_vsock *_vsock = NULL;
>+	int i;
>+	unsigned int guest_cid, order;
>+
>+	virtio_vsock_update_guest_cid(vsock);
>+	virtio_vsock_update_order(vsock);
>+	guest_cid = vsock->guest_cid;
>+	order = vsock->order;
>+
>+	i = 0;
>+	list_for_each_entry(_vsock, &virtio_vsock_list, node) {
>+		if (++i > MAX_VSOCK_NUM) {
>+			pr_debug("vsock num reaches limit %d\n", MAX_VSOCK_NUM);
>+			return -ENOMEM;
>+		}
>+
>+		/* Check for guest_cid conflicts */
>+		if (unlikely(guest_cid == _vsock->guest_cid)) {
>+			pr_debug("conflict exists in vsock's guest_cid %u\n",
>+				 guest_cid);
>+			return -EBUSY;
>+		}
>+
>+		/* Check for order conflicts */
>+		if (unlikely(order == _vsock->order)) {
>+			pr_debug("conflict exists in vsock's order %u\n",
>+				 order);
>+			return -EBUSY;
>+		}
>+	}
>+
>+	static const char *const names[] = {
> 		"rx",
> 		"tx",
> 		"event",
>@@ -634,8 +734,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
> 	if (ret < 0)
> 		return ret;
>
>-	virtio_vsock_update_guest_cid(vsock);
>-
> 	virtio_device_ready(vdev);
>
> 	return 0;
>@@ -716,21 +814,14 @@ static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
>
> static int virtio_vsock_probe(struct virtio_device *vdev)
> {
>-	struct virtio_vsock *vsock = NULL;
>-	int ret;
>-	int i;
>+	struct virtio_vsock *vsock, *_vsock, *first_vsock;
>+	int ret, i;
>+	unsigned int guest_cid, order;
>
>-	ret = mutex_lock_interruptible(&the_virtio_vsock_mutex);
>+	ret = mutex_lock_interruptible(&virtio_vsock_list_mutex);
> 	if (ret)
> 		return ret;
>
>-	/* Only one virtio-vsock device per guest is supported */
>-	if (rcu_dereference_protected(the_virtio_vsock,
>-				lockdep_is_held(&the_virtio_vsock_mutex))) {
>-		ret = -EBUSY;
>-		goto out;
>-	}
>-
> 	vsock = kzalloc(sizeof(*vsock), GFP_KERNEL);
> 	if (!vsock) {
> 		ret = -ENOMEM;
>@@ -764,28 +855,56 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	for (i = 0; i < ARRAY_SIZE(vsock->out_sgs); i++)
> 		vsock->out_sgs[i] = &vsock->out_bufs[i];
>
>-	rcu_assign_pointer(the_virtio_vsock, vsock);
>+	order = vsock->order;
>+	guest_cid = vsock->guest_cid;
>+	first_vsock =
>+		list_first_entry(&virtio_vsock_list, struct virtio_vsock, node);
>+	/* Insert virtio-vsock device into a proper location. */
>+	if (list_empty(&virtio_vsock_list) || first_vsock->order > order) {
>+		list_add_rcu(&vsock->node, &virtio_vsock_list);
>+	} else {
>+		list_for_each_entry(_vsock, &virtio_vsock_list, node) {
>+			struct virtio_vsock *next = container_of(_vsock->node.next,
>+				struct virtio_vsock, node);
>+			if (&next->node != &virtio_vsock_list &&
>+			    next->order < order)
>+				continue;
>+			list_add_rcu(&vsock->node, &_vsock->node);
>+			break;
>+		}
>+	}
>+
>+	pr_debug("virtio_vsock@%p registered (cid = %u, order = %u)\n", vsock, guest_cid, order);
>+
> 	virtio_vsock_vqs_start(vsock);
>
>-	mutex_unlock(&the_virtio_vsock_mutex);
>+	mutex_unlock(&virtio_vsock_list_mutex);
>
> 	return 0;
>
> out:
> 	kfree(vsock);
>-	mutex_unlock(&the_virtio_vsock_mutex);
>+	mutex_unlock(&virtio_vsock_list_mutex);
> 	return ret;
> }
>
> static void virtio_vsock_remove(struct virtio_device *vdev)
> {
>-	struct virtio_vsock *vsock = vdev->priv;
>+	struct virtio_vsock *vsock, *_vsock;
>
>-	mutex_lock(&the_virtio_vsock_mutex);
>+	vsock = vdev->priv;
>+
>+	mutex_lock(&virtio_vsock_list_mutex);
>
> 	vdev->priv = NULL;
>-	rcu_assign_pointer(the_virtio_vsock, NULL);
>-	synchronize_rcu();
>+	/* Remove virtio-vsock device from the list. */
>+	list_for_each_entry(_vsock, &virtio_vsock_list, node) {
>+		if (vsock == _vsock) {
>+			list_del_rcu(&vsock->node);
>+			synchronize_rcu();
>+			break;
>+		}
>+	}
>
> 	virtio_vsock_vqs_del(vsock);
>
>@@ -797,7 +916,7 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> 	flush_work(&vsock->event_work);
> 	flush_work(&vsock->send_pkt_work);
>
>-	mutex_unlock(&the_virtio_vsock_mutex);
>+	mutex_unlock(&virtio_vsock_list_mutex);
>
> 	kfree(vsock);
> }
>@@ -805,43 +924,62 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> #ifdef CONFIG_PM_SLEEP
> static int virtio_vsock_freeze(struct virtio_device *vdev)
> {
>-	struct virtio_vsock *vsock = vdev->priv;
>+	struct virtio_vsock *vsock, *_vsock;
>
>-	mutex_lock(&the_virtio_vsock_mutex);
>+	vsock = vdev->priv;
>
>-	rcu_assign_pointer(the_virtio_vsock, NULL);
>-	synchronize_rcu();
>+	mutex_lock(&virtio_vsock_list_mutex);
>+
>+	list_for_each_entry(_vsock, &virtio_vsock_list, node) {
>+		if (vsock == _vsock) {
>+			list_del_rcu(&vsock->node);
>+			synchronize_rcu();
>+			break;
>+		}
>+	}
>
> 	virtio_vsock_vqs_del(vsock);
>
>-	mutex_unlock(&the_virtio_vsock_mutex);
>+	mutex_unlock(&virtio_vsock_list_mutex);
>
> 	return 0;
> }
>
> static int virtio_vsock_restore(struct virtio_device *vdev)
> {
>-	struct virtio_vsock *vsock = vdev->priv;
>+	struct virtio_vsock *vsock, *_vsock, *first_vsock;
> 	int ret;
>+	unsigned int order;
>
>-	mutex_lock(&the_virtio_vsock_mutex);
>+	vsock = vdev->priv;
>
>-	/* Only one virtio-vsock device per guest is supported */
>-	if (rcu_dereference_protected(the_virtio_vsock,
>-				lockdep_is_held(&the_virtio_vsock_mutex))) {
>-		ret = -EBUSY;
>-		goto out;
>-	}
>+	mutex_lock(&virtio_vsock_list_mutex);
>
> 	ret = virtio_vsock_vqs_init(vsock);
> 	if (ret < 0)
> 		goto out;
>
>-	rcu_assign_pointer(the_virtio_vsock, vsock);
>+	order = vsock->order;
>+	first_vsock =
>+		list_first_entry(&virtio_vsock_list, struct virtio_vsock, node);
>+	/* Insert virtio-vsock device into a proper location. */
>+	if (list_empty(&virtio_vsock_list) || first_vsock->order > order) {
>+		list_add_rcu(&vsock->node, &virtio_vsock_list);
>+	} else {
>+		list_for_each_entry(_vsock, &virtio_vsock_list, node) {
>+			struct virtio_vsock *next = container_of(_vsock->node.next,
>+				struct virtio_vsock, node);
>+			if (&next->node != &virtio_vsock_list &&
>+			    next->order < order)
>+				continue;
>+			list_add_rcu(&vsock->node, &_vsock->node);
>+			break;
>+		}
>+	}
> 	virtio_vsock_vqs_start(vsock);
>
> out:
>-	mutex_unlock(&the_virtio_vsock_mutex);
>+	mutex_unlock(&virtio_vsock_list_mutex);
> 	return ret;
> }
> #endif /* CONFIG_PM_SLEEP */
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 16ff976a86e3..bed75a41419e 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -340,7 +340,15 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	if (unlikely(!t_ops))
> 		return -EFAULT;
>
>-	src_cid = t_ops->transport.get_local_cid();
>+	if (vsk->local_addr.svm_cid == VMADDR_CID_ANY) {
>+		if (t_ops->transport.get_default_cid)
>+			src_cid = t_ops->transport.get_default_cid();
>+		else
>+			src_cid = t_ops->transport.get_local_cid();

Can get_local_cid() be used for this case instead of adding 
get_default_cid()?

What happen if get_default_cid() returns VMADDR_CID_ANY?
Should we fallback to get_local_cid()?

>+	} else {
>+		src_cid = vsk->local_addr.svm_cid;
>+	}
>+
> 	src_port = vsk->local_addr.svm_port;
> 	if (!info->remote_cid) {
> 		dst_cid	= vsk->remote_addr.svm_cid;
>-- 
>2.34.1
>


