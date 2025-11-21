Return-Path: <kvm+bounces-64060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A185C77719
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 06:47:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 424192CF18
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 05:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F94D301463;
	Fri, 21 Nov 2025 05:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hRpU2Wnk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B6F2F7AA2
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 05:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763703901; cv=none; b=Qw1yd7zmTSUgbSvuXu8//rmvIu4dBDqXySCrXv0RSSYyiTksoUJSSX+PAfxJ8CgM1ZyFyVzpNk0PzOLEux3W2/Z8CIvdiFigKQltLliSu6WezjqlR+b80E/bVNKaY85EoQywO76M6HOkG0pnbLdnezvC4myISueQe5Gt9t5lOtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763703901; c=relaxed/simple;
	bh=3NFSpqWjsgM5rSdxx4dGvveCM/Zot7GQEo4Dcfx5mEo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gOw5DXt86TdaeLRGP7GN/t/sUhHzGkpzZQypd9K5fOR1FkPBA7ZUzlvMSxlGK6g+E1693S2hHiQFqtVKFm/Z7jzqBwf3Ot4YyeeD3PdPmXo/8qmuoyL7Se2WJYb9j7hi1tfSSphRPNhcXeCCU1BY5yMATy/LKDg/hs3x23/SsgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hRpU2Wnk; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29806bd47b5so10588715ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 21:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763703895; x=1764308695; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Af9v63LGrhL0rLWA0P5zmGlSyHIM3FMNmd7fCRBQLk=;
        b=hRpU2WnkLLVefJNJnk9oip6CJOPTWio44tPEUGMMQ4k4pKbyTlOb1D5HNuBeon1N78
         A5iPLIfVwZdWbDgFrLSjdoxYbo9h4Q3Ymi/C1XBNOMzJVpdAMlTvlQe1A1MInzjSgB5r
         zRS49znVgZyD+OQw/p1+avRbWZ+pHEAy0jtIXs1EgHMaVx+gCwgSO14lhG+wftx5k1Z+
         zqifQpcsCNFSMKr4dv5Km/9zN5mhfUgHnsBtmzIFZVW+nmIDGKPfrx0j5PDh30hndgTe
         WKiz0d6YDJ24MzDSWpteOq+47vomNrBVokNtfhjrXDpIuo5bnkuBHrQ5tLp3sKCWFvSf
         owPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763703896; x=1764308696;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8Af9v63LGrhL0rLWA0P5zmGlSyHIM3FMNmd7fCRBQLk=;
        b=HwG20VeaMzcpwtXmn01NkWbp2UEaOUZaBn2fFXXMjKzYXeYhiR4p9gF1qjxki4+pzZ
         1uqBgdyYyIL/215JvkMsSvIb8Fz0bRsDX5ds1LPXm4ovJxVaS1Ql0bAWXZDi03zm1i7y
         giYjmJuqVaJMdWjyA5cX4sBxPM+/kZ50ICIsDRAf2zxihso7tmGDE/9GWdDngiPoWYH1
         UfoN/PovK3FVI/0v1JtSgPx/DWNjWSV8spyZE4ZOKCsWeXDFS0YRcsRIUu1vR4C+LzM0
         sVtaXg4KXX/bgdaHwIR9VI5U4XiPne+8kvGxIL1xc4CEmVyIshWp1dnLmL9Es1NJbcAK
         5Y2A==
X-Forwarded-Encrypted: i=1; AJvYcCWtRDIq27dEvfhN4FeYRslT4eID3M52jjwkj6l/DcyQHqRw+o1f76a3JRmhRECK+7VNMUE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyK0K6dLWIqOiORluFGFp+P4JcQRl8njvpL69eYt3q58kKeXPwS
	c0Jl9nwHpKPqHYls8bGyriEHWwgNoFOsxQO09alYa9Y5hVL5ap4WQb0Q
X-Gm-Gg: ASbGncvu88ivH+VMe6AC61weKIW0emzb6iVu8ysX4siOzVVacFLuuHFpXUuyrxNkWkk
	z1c8Hu39yLzcm2YW0FymBDqSPliaRof549FJlx9aHgiw1enGJNp2aZxHVDuYEiBXalfDB5Y88Dh
	+1NK/KTmgT6VnNBqfM9QdnCyAgmYlSm4T6TE42xHhsvivY5eetQ8h1zPS4JUw+lwPFh7mbzYLuc
	c06K7qnlTEo0Yc2nSR2/zRGu5akemqhyLNRyFUUJbFMPQ7UA560HE3DrxFoeCPd+c1Npa5DgmVN
	PL/cmyLOX5CpP3hbAnNW0mElKL1qQqb0rB6E8t0V9NzhTCc7FIA6lnbSTnhqDpSgJlJKU8dPDRF
	R6Yr+P4f3KzAEF0D/i6UFPOEOPC08sUnTBkzMjMYR40xUbcO167TIsVRjQfbyXK4bgGuN+fODEA
	nviavNmkX7uiu3UsdG1LvQ
X-Google-Smtp-Source: AGHT+IF0iYp9b0FX0KZhlBvdPvQOs85zD/xCyN6riZGZ8FzygdF+zvR7wEbOx5UnBNLtRnXTn3LY0Q==
X-Received: by 2002:a17:902:d4ca:b0:294:f6e2:cea1 with SMTP id d9443c01a7336-29b6c571f11mr13130845ad.38.1763703895454;
        Thu, 20 Nov 2025 21:44:55 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:4f::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b111acfsm44608815ad.19.2025.11.20.21.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 21:44:55 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Thu, 20 Nov 2025 21:44:37 -0800
Subject: [PATCH net-next v11 05/13] vsock: add netns support to virtio
 transports
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251120-vsock-vmtest-v11-5-55cbc80249a7@meta.com>
References: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
In-Reply-To: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@gmail.com>, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add netns support to loopback and vhost. Keep netns disabled for
virtio-vsock, but add necessary changes to comply with common API
updates.

This is the patch in the series when vhost-vsock namespaces actually
come online.  Hence, vhost_transport_supports_local_mode() is switched
to return true.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v11:
- reorder with the skb ownership patch for loopback (Stefano)
- toggle vhost_transport_supports_local_mode() to true

Changes in v10:
- Splitting patches complicates the series with meaningless placeholder
  values that eventually get replaced anyway, so to avoid that this
  patch combines into one. Links to previous patches here:
  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-3-852787a37bed@meta.com/
  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-6-852787a37bed@meta.com/
  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-7-852787a37bed@meta.com/
- remove placeholder values (Stefano)
- update comment describe net/net_mode for
  virtio_transport_reset_no_sock()
---
 drivers/vhost/vsock.c                   | 47 ++++++++++++++++++------
 include/linux/virtio_vsock.h            |  8 +++--
 net/vmw_vsock/virtio_transport.c        | 10 ++++--
 net/vmw_vsock/virtio_transport_common.c | 63 ++++++++++++++++++++++++---------
 net/vmw_vsock/vsock_loopback.c          |  8 +++--
 5 files changed, 103 insertions(+), 33 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 4e3856aa2479..e73a6499b9fe 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -46,6 +46,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(vhost_vsock_hash, 8);
 struct vhost_vsock {
 	struct vhost_dev dev;
 	struct vhost_virtqueue vqs[2];
+	struct net *net;
+	netns_tracker ns_tracker;
+
+	/* The ns mode at the time vhost_vsock was created */
+	enum vsock_net_mode net_mode;
 
 	/* Link to global vhost_vsock_hash, writes use vhost_vsock_mutex */
 	struct hlist_node hash;
@@ -66,13 +71,14 @@ static u32 vhost_transport_get_local_cid(void)
 
 static bool vhost_transport_supports_local_mode(void)
 {
-	return false;
+	return true;
 }
 
 /* Callers that dereference the return value must hold vhost_vsock_mutex or the
  * RCU read lock.
  */
-static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
+static struct vhost_vsock *vhost_vsock_get(u32 guest_cid, struct net *net,
+					   enum vsock_net_mode mode)
 {
 	struct vhost_vsock *vsock;
 
@@ -83,9 +89,10 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
 		if (other_cid == 0)
 			continue;
 
-		if (other_cid == guest_cid)
+		if (other_cid == guest_cid &&
+		    vsock_net_check_mode(net, mode, vsock->net,
+					 vsock->net_mode))
 			return vsock;
-
 	}
 
 	return NULL;
@@ -274,7 +281,8 @@ static void vhost_transport_send_pkt_work(struct vhost_work *work)
 }
 
 static int
-vhost_transport_send_pkt(struct sk_buff *skb)
+vhost_transport_send_pkt(struct sk_buff *skb, struct net *net,
+			 enum vsock_net_mode net_mode)
 {
 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
 	struct vhost_vsock *vsock;
@@ -283,7 +291,7 @@ vhost_transport_send_pkt(struct sk_buff *skb)
 	rcu_read_lock();
 
 	/* Find the vhost_vsock according to guest context id  */
-	vsock = vhost_vsock_get(le64_to_cpu(hdr->dst_cid));
+	vsock = vhost_vsock_get(le64_to_cpu(hdr->dst_cid), net, net_mode);
 	if (!vsock) {
 		rcu_read_unlock();
 		kfree_skb(skb);
@@ -310,7 +318,8 @@ vhost_transport_cancel_pkt(struct vsock_sock *vsk)
 	rcu_read_lock();
 
 	/* Find the vhost_vsock according to guest context id  */
-	vsock = vhost_vsock_get(vsk->remote_addr.svm_cid);
+	vsock = vhost_vsock_get(vsk->remote_addr.svm_cid,
+				sock_net(sk_vsock(vsk)), vsk->net_mode);
 	if (!vsock)
 		goto out;
 
@@ -470,11 +479,12 @@ static struct virtio_transport vhost_transport = {
 static bool vhost_transport_seqpacket_allow(struct vsock_sock *vsk,
 					    u32 remote_cid)
 {
+	struct net *net = sock_net(sk_vsock(vsk));
 	struct vhost_vsock *vsock;
 	bool seqpacket_allow = false;
 
 	rcu_read_lock();
-	vsock = vhost_vsock_get(remote_cid);
+	vsock = vhost_vsock_get(remote_cid, net, vsk->net_mode);
 
 	if (vsock)
 		seqpacket_allow = vsock->seqpacket_allow;
@@ -545,7 +555,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 		if (le64_to_cpu(hdr->src_cid) == vsock->guest_cid &&
 		    le64_to_cpu(hdr->dst_cid) ==
 		    vhost_transport_get_local_cid())
-			virtio_transport_recv_pkt(&vhost_transport, skb);
+			virtio_transport_recv_pkt(&vhost_transport, skb,
+						  vsock->net, vsock->net_mode);
 		else
 			kfree_skb(skb);
 
@@ -662,6 +673,7 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 {
 	struct vhost_virtqueue **vqs;
 	struct vhost_vsock *vsock;
+	struct net *net;
 	int ret;
 
 	/* This struct is large and allocation could fail, fall back to vmalloc
@@ -677,6 +689,17 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
+	net = current->nsproxy->net_ns;
+	vsock->net = get_net_track(net, &vsock->ns_tracker, GFP_KERNEL);
+
+	/* Store the mode of the namespace at the time of creation. If this
+	 * namespace later changes from "global" to "local", we want this vsock
+	 * to continue operating normally and not suddenly break. For that
+	 * reason, we save the mode here and later use it when performing
+	 * socket lookups with vsock_net_check_mode() (see vhost_vsock_get()).
+	 */
+	vsock->net_mode = vsock_net_mode(net);
+
 	vsock->guest_cid = 0; /* no CID assigned yet */
 	vsock->seqpacket_allow = false;
 
@@ -716,7 +739,8 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
 	 */
 
 	/* If the peer is still valid, no need to reset connection */
-	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
+	if (vhost_vsock_get(vsk->remote_addr.svm_cid, sock_net(sk),
+			    vsk->net_mode))
 		return;
 
 	/* If the close timeout is pending, let it expire.  This avoids races
@@ -761,6 +785,7 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
 
 	vhost_dev_cleanup(&vsock->dev);
+	put_net_track(vsock->net, &vsock->ns_tracker);
 	kfree(vsock->dev.vqs);
 	vhost_vsock_free(vsock);
 	return 0;
@@ -787,7 +812,7 @@ static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 guest_cid)
 
 	/* Refuse if CID is already in use */
 	mutex_lock(&vhost_vsock_mutex);
-	other = vhost_vsock_get(guest_cid);
+	other = vhost_vsock_get(guest_cid, vsock->net, vsock->net_mode);
 	if (other && other != vsock) {
 		mutex_unlock(&vhost_vsock_mutex);
 		return -EADDRINUSE;
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 0c67543a45c8..5ed6136a4ed4 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -173,6 +173,8 @@ struct virtio_vsock_pkt_info {
 	u32 remote_cid, remote_port;
 	struct vsock_sock *vsk;
 	struct msghdr *msg;
+	struct net *net;
+	enum vsock_net_mode net_mode;
 	u32 pkt_len;
 	u16 type;
 	u16 op;
@@ -185,7 +187,8 @@ struct virtio_transport {
 	struct vsock_transport transport;
 
 	/* Takes ownership of the packet */
-	int (*send_pkt)(struct sk_buff *skb);
+	int (*send_pkt)(struct sk_buff *skb, struct net *net,
+			enum vsock_net_mode net_mode);
 
 	/* Used in MSG_ZEROCOPY mode. Checks, that provided data
 	 * (number of buffers) could be transmitted with zerocopy
@@ -280,7 +283,8 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
 void virtio_transport_destruct(struct vsock_sock *vsk);
 
 void virtio_transport_recv_pkt(struct virtio_transport *t,
-			       struct sk_buff *skb);
+			       struct sk_buff *skb, struct net *net,
+			       enum vsock_net_mode net_mode);
 void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *skb);
 u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted);
 void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index af4fbce0baab..106d3f25a5cb 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -243,7 +243,8 @@ static int virtio_transport_send_skb_fast_path(struct virtio_vsock *vsock, struc
 }
 
 static int
-virtio_transport_send_pkt(struct sk_buff *skb)
+virtio_transport_send_pkt(struct sk_buff *skb, struct net *net,
+			  enum vsock_net_mode net_mode)
 {
 	struct virtio_vsock_hdr *hdr;
 	struct virtio_vsock *vsock;
@@ -675,7 +676,12 @@ static void virtio_transport_rx_work(struct work_struct *work)
 				virtio_vsock_skb_put(skb, payload_len);
 
 			virtio_transport_deliver_tap_pkt(skb);
-			virtio_transport_recv_pkt(&virtio_transport, skb);
+
+			/* Force virtio-transport into global mode since it
+			 * does not yet support local-mode namespacing.
+			 */
+			virtio_transport_recv_pkt(&virtio_transport, skb,
+						  NULL, VSOCK_NET_MODE_GLOBAL);
 		}
 	} while (!virtqueue_enable_cb(vq));
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 675eb9d83549..5bb498caa19e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -413,7 +413,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 
 		virtio_transport_inc_tx_pkt(vvs, skb);
 
-		ret = t_ops->send_pkt(skb);
+		ret = t_ops->send_pkt(skb, info->net, info->net_mode);
 		if (ret < 0)
 			break;
 
@@ -527,6 +527,8 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk)
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_CREDIT_UPDATE,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
+		.net_mode = vsk->net_mode,
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1067,6 +1069,8 @@ int virtio_transport_connect(struct vsock_sock *vsk)
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_REQUEST,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
+		.net_mode = vsk->net_mode,
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1082,6 +1086,8 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
 			 (mode & SEND_SHUTDOWN ?
 			  VIRTIO_VSOCK_SHUTDOWN_SEND : 0),
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
+		.net_mode = vsk->net_mode,
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1108,6 +1114,8 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
 		.msg = msg,
 		.pkt_len = len,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
+		.net_mode = vsk->net_mode,
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1145,6 +1153,8 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
 		.op = VIRTIO_VSOCK_OP_RST,
 		.reply = !!skb,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
+		.net_mode = vsk->net_mode,
 	};
 
 	/* Send RST only if the original pkt is not a RST pkt */
@@ -1156,9 +1166,14 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
 
 /* Normally packets are associated with a socket.  There may be no socket if an
  * attempt was made to connect to a socket that does not exist.
+ *
+ * net and net_mode refer to the namespace of whoever sent the invalid message.
+ * For loopback, this is the namespace of the socket. For vhost, this is the
+ * namespace of the VM (i.e., vhost_vsock).
  */
 static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
-					  struct sk_buff *skb)
+					  struct sk_buff *skb, struct net *net,
+					  enum vsock_net_mode net_mode)
 {
 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
 	struct virtio_vsock_pkt_info info = {
@@ -1171,6 +1186,13 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 		 * sock_net(sk) until the reply skb is freed.
 		 */
 		.vsk = vsock_sk(skb->sk),
+
+		/* net or net_mode are not defined here because we pass
+		 * net and net_mode directly to t->send_pkt(), instead of
+		 * relying on virtio_transport_send_pkt_info() to pass them to
+		 * t->send_pkt(). They are not needed by
+		 * virtio_transport_alloc_skb().
+		 */
 	};
 	struct sk_buff *reply;
 
@@ -1189,7 +1211,7 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 	if (!reply)
 		return -ENOMEM;
 
-	return t->send_pkt(reply);
+	return t->send_pkt(reply, net, net_mode);
 }
 
 /* This function should be called with sk_lock held and SOCK_DONE set */
@@ -1471,6 +1493,8 @@ virtio_transport_send_response(struct vsock_sock *vsk,
 		.remote_port = le32_to_cpu(hdr->src_port),
 		.reply = true,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
+		.net_mode = vsk->net_mode,
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1513,12 +1537,14 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 	int ret;
 
 	if (le16_to_cpu(hdr->op) != VIRTIO_VSOCK_OP_REQUEST) {
-		virtio_transport_reset_no_sock(t, skb);
+		virtio_transport_reset_no_sock(t, skb, sock_net(sk),
+					       vsk->net_mode);
 		return -EINVAL;
 	}
 
 	if (sk_acceptq_is_full(sk)) {
-		virtio_transport_reset_no_sock(t, skb);
+		virtio_transport_reset_no_sock(t, skb, sock_net(sk),
+					       vsk->net_mode);
 		return -ENOMEM;
 	}
 
@@ -1526,13 +1552,15 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 	 * Subsequent enqueues would lead to a memory leak.
 	 */
 	if (sk->sk_shutdown == SHUTDOWN_MASK) {
-		virtio_transport_reset_no_sock(t, skb);
+		virtio_transport_reset_no_sock(t, skb, sock_net(sk),
+					       vsk->net_mode);
 		return -ESHUTDOWN;
 	}
 
 	child = vsock_create_connected(sk);
 	if (!child) {
-		virtio_transport_reset_no_sock(t, skb);
+		virtio_transport_reset_no_sock(t, skb, sock_net(sk),
+					       vsk->net_mode);
 		return -ENOMEM;
 	}
 
@@ -1554,7 +1582,8 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 	 */
 	if (ret || vchild->transport != &t->transport) {
 		release_sock(child);
-		virtio_transport_reset_no_sock(t, skb);
+		virtio_transport_reset_no_sock(t, skb, sock_net(sk),
+					       vsk->net_mode);
 		sock_put(child);
 		return ret;
 	}
@@ -1582,7 +1611,8 @@ static bool virtio_transport_valid_type(u16 type)
  * lock.
  */
 void virtio_transport_recv_pkt(struct virtio_transport *t,
-			       struct sk_buff *skb)
+			       struct sk_buff *skb, struct net *net,
+			       enum vsock_net_mode net_mode)
 {
 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
 	struct sockaddr_vm src, dst;
@@ -1605,24 +1635,25 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 					le32_to_cpu(hdr->fwd_cnt));
 
 	if (!virtio_transport_valid_type(le16_to_cpu(hdr->type))) {
-		(void)virtio_transport_reset_no_sock(t, skb);
+		(void)virtio_transport_reset_no_sock(t, skb, net, net_mode);
 		goto free_pkt;
 	}
 
 	/* The socket must be in connected or bound table
 	 * otherwise send reset back
 	 */
-	sk = vsock_find_connected_socket(&src, &dst);
+	sk = vsock_find_connected_socket_net(&src, &dst, net, net_mode);
 	if (!sk) {
-		sk = vsock_find_bound_socket(&dst);
+		sk = vsock_find_bound_socket_net(&dst, net, net_mode);
 		if (!sk) {
-			(void)virtio_transport_reset_no_sock(t, skb);
+			(void)virtio_transport_reset_no_sock(t, skb, net,
+							     net_mode);
 			goto free_pkt;
 		}
 	}
 
 	if (virtio_transport_get_type(sk) != le16_to_cpu(hdr->type)) {
-		(void)virtio_transport_reset_no_sock(t, skb);
+		(void)virtio_transport_reset_no_sock(t, skb, net, net_mode);
 		sock_put(sk);
 		goto free_pkt;
 	}
@@ -1641,7 +1672,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 	 */
 	if (sock_flag(sk, SOCK_DONE) ||
 	    (sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {
-		(void)virtio_transport_reset_no_sock(t, skb);
+		(void)virtio_transport_reset_no_sock(t, skb, net, net_mode);
 		release_sock(sk);
 		sock_put(sk);
 		goto free_pkt;
@@ -1673,7 +1704,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		kfree_skb(skb);
 		break;
 	default:
-		(void)virtio_transport_reset_no_sock(t, skb);
+		(void)virtio_transport_reset_no_sock(t, skb, net, net_mode);
 		kfree_skb(skb);
 		break;
 	}
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 1e25c1a6b43f..a730fa74d2d9 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -31,7 +31,8 @@ static bool vsock_loopback_supports_local_mode(void)
 	return true;
 }
 
-static int vsock_loopback_send_pkt(struct sk_buff *skb)
+static int vsock_loopback_send_pkt(struct sk_buff *skb, struct net *net,
+				   enum vsock_net_mode net_mode)
 {
 	struct vsock_loopback *vsock = &the_vsock_loopback;
 	int len = skb->len;
@@ -138,7 +139,10 @@ static void vsock_loopback_work(struct work_struct *work)
 		 */
 		virtio_transport_consume_skb_sent(skb, false);
 		virtio_transport_deliver_tap_pkt(skb);
-		virtio_transport_recv_pkt(&loopback_transport, skb);
+
+		virtio_transport_recv_pkt(&loopback_transport, skb,
+					  sock_net(skb->sk),
+					  vsock_sk(skb->sk)->net_mode);
 	}
 }
 

-- 
2.47.3


