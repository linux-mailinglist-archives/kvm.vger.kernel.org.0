Return-Path: <kvm+bounces-64143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CD7C7A2D6
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:34:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 816713813E8
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 363C134F259;
	Fri, 21 Nov 2025 14:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uc0+x53R";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dJzTJ3Su"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28B734BA54
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763735080; cv=none; b=ShDhfawLU0Op4z/zxIHM1mtz6xN0qRW/O1cw/y0HEuzd3WElOo0c+kcCcG+VJTyn5hOmjuXr+RP9oOe8YJzN1MviMSdSLjFDWUy3VBTUc3nt5mQbtJ2yLN4yhFf0T8+8hxChh/OhlJJ6JLatQQIfllqq3XeKnfqDLJWwBxZ9xkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763735080; c=relaxed/simple;
	bh=QnPgXvtRQZ5SYQe+umsa9mesGhcnlTWzfoISadHUoxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nnLTLl3qZlrtlK1/R5R7IOl8/kHED23YTiBhNaQflItXfa5jh7MiDjcZtrk650iAoDY3Qd7gGjh0kk2vTzTlULnorKcVWCbNYVMSjBaOtzwkaumLfBUC3Ya+6b+8MxEUVhWkKrQNBVAhvGVLy7yCocM2ziwc2HzUxlG/OG7yCUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uc0+x53R; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dJzTJ3Su; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763735076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fjp626BzoQBQVhG9FbyK0CqqP+RmkubOlZpUHgn2GDU=;
	b=Uc0+x53Rx0YwsIQ7TW2CihHjaCTiYXEB/qvOP43M2yzyM2Zg9A3yTix/tutSlttO1hXDn7
	YkhuBdnT5aK2O6RcOIciASqx0l6Lh0Se7T1GehHCBORzQmcTniaTFf3T+gURjEkJS3qNIN
	8bbMZYgPSfbL/21NeZUPoExlUPyPgSA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677--fH0b-KoPxan7YNG89zd5g-1; Fri, 21 Nov 2025 09:24:35 -0500
X-MC-Unique: -fH0b-KoPxan7YNG89zd5g-1
X-Mimecast-MFC-AGG-ID: -fH0b-KoPxan7YNG89zd5g_1763735074
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b72a95dc686so165173066b.3
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 06:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763735073; x=1764339873; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fjp626BzoQBQVhG9FbyK0CqqP+RmkubOlZpUHgn2GDU=;
        b=dJzTJ3SuGw57GETnOjb4MMoGlc79sPkJr4hIUsh8hvi1yfiOtVHIK318jp1Jto1ezf
         nEPrOzZiK20w3AM7fWWnJgEPGa3Vwo+eP51tjYst2dG7r9KBcyJsG04gRxUBD+T76yI/
         rsM7r5tJDvOtq76l4EGTNN5PkTXf/PTChVT99Xx/23DDN8N4ybCdBW2BO/2eegNbZtKZ
         l3csrVgqH49Iqw6hHZNH5OR1l0HpHqaV0vUtuifwbQgPtAwgQ3FuWWPORXX9K9MUyUJg
         w/LgzHXg7imC3pbYI7KQPKaRctkqiNRMd88pd5HtXjPQ/uz7XuqohCCm2fj/WwFMRWh3
         KXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763735073; x=1764339873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjp626BzoQBQVhG9FbyK0CqqP+RmkubOlZpUHgn2GDU=;
        b=nrpmsouHBdUWg8hLWhDJ7IBke7AvCJX39coKu+mpK7nCdybqe5MdC4cWLkBIpHEc1j
         FSyDyDpdg+K/mth69Pd0OGkWebgOicaTkD4UgV7g3bch7TWeVHHqF+whmp40RRXZDpUh
         HLVpi+Yx2ZQsuf6d9/vaiRvY0Q8clXH/z6dCd0/ZvQRnYrXFbogW27a3AU8FghM+8iYH
         NNH0XjjQBA2i/FPMI5/2lKSuXL0JfcRbwGzlhxbJtQ289LxP6nSRddV6OTR6H/v7hbE9
         kI1UVTp7PzVYt65f0LC0+VGYQuX0XTizgWbxQgBZAQ//BVGmC9n94kp2cxZoqoECQ8cm
         7FBA==
X-Forwarded-Encrypted: i=1; AJvYcCWIZqPvyMFICC99HDLPiwUgs5mSVoKVtnyfr8KUS4LfNFlhad/tDBjpxqNoR92M/f1qedk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSGlwD7Ud7lPLCbmERhlA2gHMa3mFZDBLhbZgtAnurGX7lvgzo
	J+ZPXThbBgMRSMyfoMPz1u8R97Mp+3Jqtqat2vzu0J2AYpzUeN2s6TXEvXX5emWLYDwlK9JqCYO
	KSArRO4i8RJ5rrcmpTMW0270iPj1cQIsDcyrd+biKASKxgkFiB/FbhGBaG3/CXQ==
X-Gm-Gg: ASbGncuR6Q3CzkruU9jRh3H4HJ6nkhAqA29D3EnOF9QYsu8mbfiudSiaAEmER9KRWH8
	uWjt9xMtXqeW6IKvvtnNOSDBT78GwcqfhFwpOoDg/N2BZgFmQZ2cf5Yu9Naq/MD4GFh8ni01VgX
	s5aGt6k3HZ6e8ErNUFQE+FsClm84JcsStJhSw1nmksgg2tOszHUr4/gfrMXLpF3I3QBC6IFbS0n
	gdR86y2c27FzmEYa6AbQaeam0Y/eg0z86Gyimg7Sc9F6QzcWDhfsFJNJhpqujPqnReutFbnakp4
	g8CGk2fRCm03QpVUGGwj0DOYb5KukcOI0vEOvzxW9TC2/KSmpqQO8nOttRM9Y+Fo0hrAugakD+X
	r82bsy7rckTsm3jF2N/FNUqcSWkN9Ys8FUkspmaOBb4VVrAGYVYiFHYUbHGpq9Q==
X-Received: by 2002:a17:907:940b:b0:b6d:8385:2164 with SMTP id a640c23a62f3a-b7671a138eamr235113966b.54.1763735073203;
        Fri, 21 Nov 2025 06:24:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGJ8mGsJDC/jBsF/7MODboFQ8xnEWvfzBEbNDMHQmTFFF/qxLBffDQu+QTks1yX2nh4ZJoQhQ==
X-Received: by 2002:a17:907:940b:b0:b6d:8385:2164 with SMTP id a640c23a62f3a-b7671a138eamr235109966b.54.1763735072611;
        Fri, 21 Nov 2025 06:24:32 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cdd62bsm479111266b.5.2025.11.21.06.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 06:24:32 -0800 (PST)
Date: Fri, 21 Nov 2025 15:24:25 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org, berrange@redhat.com, 
	Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v11 03/13] vsock: reject bad
 VSOCK_NET_MODE_LOCAL configuration for G2H
Message-ID: <swa5xpovczqucynffqgfotyx34lziccwpqomnm5a7iwmeyixfv@uehtzbdj53b4>
References: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
 <20251120-vsock-vmtest-v11-3-55cbc80249a7@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251120-vsock-vmtest-v11-3-55cbc80249a7@meta.com>

On Thu, Nov 20, 2025 at 09:44:35PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Reject setting VSOCK_NET_MODE_LOCAL with -EOPNOTSUPP if a G2H transport
>is operational. Additionally, reject G2H transport registration if there
>already exists a namespace in local mode.
>
>G2H sockets break in local mode because the G2H transports don't support
>namespacing yet. The current approach is to coerce packets coming out of
>G2H transports into VSOCK_NET_MODE_GLOBAL mode, but it is not possible
>to coerce sockets in the same way because it cannot be deduced which
>transport will be used by the socket. Specifically, when bound to
>VMADDR_CID_ANY in a nested VM (both G2H and H2G available), it is not
>until a packet is received and matched to the bound socket that we
>assign the transport. This presents a chicken-and-egg problem, because
>we need the namespace to lookup the socket and resolve the transport,
>but we need the transport to know how to use the namespace during
>lookup.
>
>For that reason, this patch prevents VSOCK_NET_MODE_LOCAL from being
>used on systems that support G2H, even nested systems that also have H2G
>transports.
>
>Local mode is blocked based on detecting the presence of G2H devices
>(when possible, as hyperv is special). This means that a host kernel
>with G2H support compiled in (or has the module loaded), will still
>support local mode if there is no G2H (e.g., virtio-vsock) device
>detected. This enables using the same kernel in the host and in the
>guest, as we do in kselftest.
>
>Systems with only namespace-aware transports (vhost-vsock, loopback) can
>still use both VSOCK_NET_MODE_GLOBAL and VSOCK_NET_MODE_LOCAL modes as
>intended.
>
>Add supports_local_mode() transport callback to indicate
>transport-specific local mode support.
>
>These restrictions can be lifted in a future patch series when G2H
>transports gain namespace support.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v11:
>- vhost_transport_supports_local_mode() returns false to keep things
>  disabled until support comes online (Stefano)
>- add comment above supports_local_mode() cb to clarify (Stefano)
>- Remove redundant `ret = 0` initialization in vsock_net_mode_string()
>  (Stefano)
>- Refactor vsock_net_mode_string() to separate parsing from validation
>  (Stefano)
>- vmci returns false for supports_local_mode(), with comment
>
>Changes in v10:
>- move this patch before any transports bring online namespacing (Stefano)
>- move vsock_net_mode_string into critical section (Stefano)
>- add ->supports_local_mode() callback to transports (Stefano)
>---
> drivers/vhost/vsock.c            |  6 ++++++
> include/net/af_vsock.h           | 11 +++++++++++
> net/vmw_vsock/af_vsock.c         | 32 ++++++++++++++++++++++++++++++++
> net/vmw_vsock/hyperv_transport.c |  6 ++++++
> net/vmw_vsock/virtio_transport.c | 13 +++++++++++++
> net/vmw_vsock/vmci_transport.c   | 12 ++++++++++++
> net/vmw_vsock/vsock_loopback.c   |  6 ++++++
> 7 files changed, 86 insertions(+)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 69074656263d..4e3856aa2479 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -64,6 +64,11 @@ static u32 vhost_transport_get_local_cid(void)
> 	return VHOST_VSOCK_DEFAULT_HOST_CID;
> }
>
>+static bool vhost_transport_supports_local_mode(void)
>+{
>+	return false;
>+}
>+
> /* Callers that dereference the return value must hold vhost_vsock_mutex or the
>  * RCU read lock.
>  */
>@@ -412,6 +417,7 @@ static struct virtio_transport vhost_transport = {
> 		.module                   = THIS_MODULE,
>
> 		.get_local_cid            = vhost_transport_get_local_cid,
>+		.supports_local_mode	  = vhost_transport_supports_local_mode,
>
> 		.init                     = virtio_transport_do_socket_init,
> 		.destruct                 = virtio_transport_destruct,
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 59d97a143204..e24ef1d9fe02 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -180,6 +180,17 @@ struct vsock_transport {
> 	/* Addressing. */
> 	u32 (*get_local_cid)(void);
>
>+	/* Return true if the transport is compatible with
>+	 * VSOCK_NET_MODE_LOCAL. Otherwise, return false.
>+	 *
>+	 * Transports should return false if they lack local-mode namespace
>+	 * support (e.g., G2H transports like hyperv-vsock and vmci-vsock).
>+	 * virtio-vsock returns true only if no device is present in order to
>+	 * enable local mode in nested scenarios in which virtio-vsock is
>+	 * loaded or built-in, but nonetheless unusable by sockets.
>+	 */
>+	bool (*supports_local_mode)(void);
>+
> 	/* Read a single skb */
> 	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 243c0d588682..120adb9dad9f 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -91,6 +91,12 @@
>  *   and locked down by a namespace manager. The default is "global". The mode
>  *   is set per-namespace.
>  *
>+ *   Note: LOCAL mode is only supported when using namespace-aware transports
>+ *   (vhost-vsock, loopback). If a guest-to-host transport (virtio-vsock,
>+ *   hyperv-vsock, vmci-vsock) is operational, attempts to set LOCAL mode will
>+ *   fail with EOPNOTSUPP, as these transports do not support per-namespace
>+ *   isolation.
>+ *
>  *   The modes affect the allocation and accessibility of CIDs as follows:
>  *
>  *   - global - access and allocation are all system-wide
>@@ -2794,6 +2800,15 @@ static int vsock_net_mode_string(const struct ctl_table *table, int write,
> 	else
> 		return -EINVAL;
>
>+	mutex_lock(&vsock_register_mutex);
>+	if (mode == VSOCK_NET_MODE_LOCAL &&
>+	    transport_g2h && transport_g2h->supports_local_mode &&
>+	    !transport_g2h->supports_local_mode()) {
>+		mutex_unlock(&vsock_register_mutex);
>+		return -EOPNOTSUPP;
>+	}
>+	mutex_unlock(&vsock_register_mutex);

Wait, I think we already discussed about this, vsock_net_write_mode() 
must be called with the lock held.

See 
https://lore.kernel.org/netdev/aRTTwuuXSz5CvNjt@devvm11784.nha0.facebook.com/

Since I guess we need another version of this patch, can you check the
commit description to see if it reflects what we are doing now
(e.g vhost is not enabled)?

Also I don't understand why for vhost we will enable it later, but for
virtio_transport and vsock_loopback we are enabling it now, also if this
patch is before the support on that transports. I'm a bit confused.

If something is unclear, let's discuss it before sending a new version.


What I had in mind was, add this patch and explain why we need this new
callback (like you did), but enable the support in the patches that
really enable it for any transport. But maybe what is not clear to me is 
that we need this only for G2H. But now I'm confused about the 
discussion around vmci H2G. We decided to discard also that one, but 
here we are not checking that?
I mean here we are calling supports_local_mode() only on G2H IIUC.

>+
> 	if (!vsock_net_write_mode(net, mode))
> 		return -EPERM;
>
>@@ -2938,6 +2953,7 @@ int vsock_core_register(const struct vsock_transport *t, int features)
> {
> 	const struct vsock_transport *t_h2g, *t_g2h, *t_dgram, *t_local;
> 	int err = mutex_lock_interruptible(&vsock_register_mutex);
>+	struct net *net;
>
> 	if (err)
> 		return err;
>@@ -2960,6 +2976,22 @@ int vsock_core_register(const struct vsock_transport *t, int features)
> 			err = -EBUSY;
> 			goto err_busy;
> 		}
>+
>+		/* G2H sockets break in LOCAL mode namespaces because G2H

And also here we are talking about only of G2H, so what happen if vmci 
is loaded as H2G?

IMO we should discuss this a bit more and make it a bit more generic, 
like check all the transports.

Thanks,
Stefano

>+		 * transports don't support them yet. Block registering new G2H
>+		 * transports if we already have local mode namespaces on the
>+		 * system.
>+		 */
>+		rcu_read_lock();
>+		for_each_net_rcu(net) {
>+			if (vsock_net_mode(net) == VSOCK_NET_MODE_LOCAL) {
>+				rcu_read_unlock();
>+				err = -EOPNOTSUPP;
>+				goto err_busy;
>+			}
>+		}
>+		rcu_read_unlock();
>+
> 		t_g2h = t;
> 	}
>
>diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>index 432fcbbd14d4..279f04fcd81a 100644
>--- a/net/vmw_vsock/hyperv_transport.c
>+++ b/net/vmw_vsock/hyperv_transport.c
>@@ -833,10 +833,16 @@ int hvs_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
> 	return -EOPNOTSUPP;
> }
>
>+static bool hvs_supports_local_mode(void)
>+{
>+	return false;
>+}
>+
> static struct vsock_transport hvs_transport = {
> 	.module                   = THIS_MODULE,
>
> 	.get_local_cid            = hvs_get_local_cid,
>+	.supports_local_mode      = hvs_supports_local_mode,
>
> 	.init                     = hvs_sock_init,
> 	.destruct                 = hvs_destruct,
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index d365a4b371d0..af4fbce0baab 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -94,6 +94,18 @@ static u32 virtio_transport_get_local_cid(void)
> 	return ret;
> }
>
>+static bool virtio_transport_supports_local_mode(void)
>+{
>+	struct virtio_vsock *vsock;
>+
>+	rcu_read_lock();
>+	vsock = rcu_dereference(the_virtio_vsock);
>+	rcu_read_unlock();
>+
>+	/* Local mode is supported only when no G2H device is present.  */
>+	return vsock ? false : true;
>+}
>+
> /* Caller need to hold vsock->tx_lock on vq */
> static int virtio_transport_send_skb(struct sk_buff *skb, struct virtqueue *vq,
> 				     struct virtio_vsock *vsock, gfp_t gfp)
>@@ -544,6 +556,7 @@ static struct virtio_transport virtio_transport = {
> 		.module                   = THIS_MODULE,
>
> 		.get_local_cid            = virtio_transport_get_local_cid,
>+		.supports_local_mode      = virtio_transport_supports_local_mode,
>
> 		.init                     = virtio_transport_do_socket_init,
> 		.destruct                 = virtio_transport_destruct,
>diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
>index 7eccd6708d66..e392d3d1fd90 100644
>--- a/net/vmw_vsock/vmci_transport.c
>+++ b/net/vmw_vsock/vmci_transport.c
>@@ -2033,6 +2033,17 @@ static u32 vmci_transport_get_local_cid(void)
> 	return vmci_get_context_id();
> }
>
>+static bool vmci_transport_supports_local_mode(void)
>+{
>+	/* Local mode is not yet compatible with vmci because there is no clear
>+	 * mechanism yet for attaching a namespace to a VM, or for handling the
>+	 * namespacing for when neither H2G or G2H is registered (as is the
>+	 * case for MODULE_ALIAS_NETPROTO(PF_VSOCK) loading. To simplify, we
>+	 * keep local mode off for now.
>+	 */
>+	return false;
>+}
>+
> static struct vsock_transport vmci_transport = {
> 	.module = THIS_MODULE,
> 	.init = vmci_transport_socket_init,
>@@ -2062,6 +2073,7 @@ static struct vsock_transport vmci_transport = {
> 	.notify_send_post_enqueue = vmci_transport_notify_send_post_enqueue,
> 	.shutdown = vmci_transport_shutdown,
> 	.get_local_cid = vmci_transport_get_local_cid,
>+	.supports_local_mode = vmci_transport_supports_local_mode,
> };
>
> static bool vmci_check_transport(struct vsock_sock *vsk)
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index 8722337a4f80..1e25c1a6b43f 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -26,6 +26,11 @@ static u32 vsock_loopback_get_local_cid(void)
> 	return VMADDR_CID_LOCAL;
> }
>
>+static bool vsock_loopback_supports_local_mode(void)
>+{
>+	return true;
>+}
>+
> static int vsock_loopback_send_pkt(struct sk_buff *skb)
> {
> 	struct vsock_loopback *vsock = &the_vsock_loopback;
>@@ -58,6 +63,7 @@ static struct virtio_transport loopback_transport = {
> 		.module                   = THIS_MODULE,
>
> 		.get_local_cid            = vsock_loopback_get_local_cid,
>+		.supports_local_mode	  = vsock_loopback_supports_local_mode,
>
> 		.init                     = virtio_transport_do_socket_init,
> 		.destruct                 = virtio_transport_destruct,
>
>-- 
>2.47.3
>


