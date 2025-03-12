Return-Path: <kvm+bounces-40856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB7C9A5E60C
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 22:05:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6632017029C
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 21:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F7C1F192B;
	Wed, 12 Mar 2025 20:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jd5XpD5h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16141EF0B1;
	Wed, 12 Mar 2025 20:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741813182; cv=none; b=QkaVBJZgYYyCAefBLAkxoKwxbsgE2GOdH3fKSSOzAdLZ8NBBcB/RezAPvrAGZMBrlq/pivdfZIttvxth1+CaGiarUF9faWtYZVWGHNG3hA/aMy/tLNVVTSPBOH9V8xPfrEEM9sB9GFEC98AODAs7ZjEyNPpfb/QWEi9x5MNRadI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741813182; c=relaxed/simple;
	bh=58nrTVMzaWpCXQO0MEnaL13tkgHSzsCIquB0X3ajUcU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BN8QA6qvdcD2C9KjuOsOxU8v0Lkwr9tI9Mi0+dr3OrpQhLNAVzE6qavgpgCI+M+7A+5N0uC9uQBAZ0mxtmL5EkDPmyFS5kqsJ4wRV+6m4ASEhZ53VT7nf6JfZ0gple4v2I8knSTQmYeLDBAJ2/dHdWXYyopzTcTNCv81SzD+QHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jd5XpD5h; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-224341bbc1dso5853745ad.3;
        Wed, 12 Mar 2025 13:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741813180; x=1742417980; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S6SV0OMMvHfQ9dNMh3vcZfmXfg4llKsen+7oez8IFsY=;
        b=Jd5XpD5hE3kNDbCTC3TeFq02vI6C37IeGdvTDJ3pef8QaGweBp7cEPayCQxPrIFrtG
         MgzpfDqSWqr78nMA8AUfjqrJYMuEdGOOtHkZ+T9kCd3tnW8eMZaOKmgMv99PeGfxJRLS
         Cin7JV7mNPFnRwHpr13u9ATGasy8iEZgeXZ/G2cfMBxgMa/re3spVOuFQXEx8PgJh4Pd
         rBQ2AhM6+ylOvLT3HlfQbaeMa5UqvylDAmjFvCQXloiFpEnX2NEiD3Qz2nYTQR+0+8Ue
         nAipZyg/g0bBm9nau2F78V6KSVLKslZ361qx+H455z4RzL/712B+VyO0TyyfbHMZO9Wa
         EF9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741813180; x=1742417980;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S6SV0OMMvHfQ9dNMh3vcZfmXfg4llKsen+7oez8IFsY=;
        b=jOI5U04X8n5RcCQbvMBnDRTxT9dCTWY6fznOVuniOuzx5eLYoQMm1GlGqj2KLN2qKC
         BOaEC368g9YiIESzhzge3jFKCLVOEvAydmba5LvfDh+Uc/lRwx3Uk2EKxz+6YPRElgOR
         EtFFM5asnrJ6ZPe2pmXhUD/dzED60RzNw/kB1ZhD5wioe9qvQt4TG6GTS1yJO02K4JkS
         OdQt26VGcvFnDIfufPCyNdqM14zZZnvJjDVlY6ET8jQsiHrM4lr8jEIO/KwcbmdLx30N
         bw5QtpDKx4n6CPgoE3OR9ZngpnYkIFqPghx6C0MbQembHcvS1K7Ffrq/WzFYd0oGqNa8
         J+Ww==
X-Forwarded-Encrypted: i=1; AJvYcCWFhUPdi3Yj6a2ccGekOzBdQr+qmho957lc4UizUE/QM/yHiDJnN3E+MVQ2S/mIqLInPc4=@vger.kernel.org, AJvYcCWWqKO8z34piNCunaxiUlHqQw9F9YHX7h8HSJnLyOHywXAh7PVCRZagxAeFC4SoaSc808t0nOrcg2+m1xvt@vger.kernel.org, AJvYcCXBhmG3uI+AL8Fg7kLwnpwhAI9D15PaEcJeQOOW5GXMANfe+qPBjcSTO3ADq++PW88TBxlzd7BG@vger.kernel.org, AJvYcCXNH9+dTfBW8+yHbl7Ni0tw6maDjtlb5uwkS1nn0auW3Ls01ixjtgYq2Dp7i3IFmaKdUr6t1Xtn/CQymrAG@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7b5BsqYVEf5+qIaJf7gBB6vIR9jTP58NXYmy9jhs6xM0nA2I2
	g/lSjJ3rjkOvQj1t+QNNZBrcZ4Kj1We2sBASNb8HrhwIBVHScwEt
X-Gm-Gg: ASbGncvP2W79atZ1aT7+J/Io22OHCNQKTwUC05ybXelmZXyu+jGnEQjWf83vo0t2Q84
	tCXQR3bttW6vqOC6hPPo8PSRp2CWlwUmVNiikjTzuFTJDxvEhuzlIX7x755Sedc9X6C7DdBv61S
	zh6XouuDqljHoiqIQAgRHCGPuS4hWwFbMoBWCfbOsOwIPKP1f50ObfnASoDAdRgJEbjNFPu+mcN
	4OpvGSxzF8Qq5ELmaQjwLR9jlpCTfSWk+nwF9kRO0CgOXTIk9uMvleSicxCPJ/6DvPsC0BdvkrS
	y2UJLUz/SLjPqEoCtfnztiv2YSGzoCDGeEKQhx6Enm0=
X-Google-Smtp-Source: AGHT+IEnho2DT4EvAFXOzkMi6dHuQrNeMTnsCpgaC1KC1WI9+9kok4yqlR4obktRfMVTp+vp23mIfg==
X-Received: by 2002:a17:903:2308:b0:220:ce37:e31f with SMTP id d9443c01a7336-22592e2cb8emr122152785ad.17.1741813180080;
        Wed, 12 Mar 2025 13:59:40 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:71::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a7f93esm120621905ad.142.2025.03.12.13.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 13:59:39 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Wed, 12 Mar 2025 13:59:35 -0700
Subject: [PATCH v2 1/3] vsock: add network namespace support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250312-vsock-netns-v2-1-84bffa1aa97a@gmail.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
In-Reply-To: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 Jakub Kicinski <kuba@kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: "David S. Miller" <davem@davemloft.net>, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, 
 Bobby Eshleman <bobbyeshleman@gmail.com>
X-Mailer: b4 0.14.2

From: Stefano Garzarella <sgarzare@redhat.com>

This patch adds a check of the "net" assigned to a socket during
the vsock_find_bound_socket() and vsock_find_connected_socket()
to support network namespace, allowing to share the same address
(cid, port) across different network namespaces.

This patch preserves old behavior, and does not yet bring up namespace
support fully.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
---
v1 -> v2:
* remove 'netns' module param
* remove vsock_net_eq()
* use vsock_global_net() for "global" namespace
* use fallback logic in socket lookup functions, giving precedence to
  non-global vsock namespaces

RFC -> v1
* added 'netns' module param
* added 'vsock_net_eq()' to check the "net" assigned to a socket
  only when 'netns' support is enabled
---
 include/net/af_vsock.h                  |  7 +++--
 net/vmw_vsock/af_vsock.c                | 55 ++++++++++++++++++++++++---------
 net/vmw_vsock/hyperv_transport.c        |  2 +-
 net/vmw_vsock/virtio_transport_common.c |  5 +--
 net/vmw_vsock/vmci_transport.c          |  4 +--
 5 files changed, 51 insertions(+), 22 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 9e85424c834353d016a527070dd62e15ff3bfce1..41afbc18648c953da27a93571d408de968aa7668 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -213,9 +213,10 @@ void vsock_enqueue_accept(struct sock *listener, struct sock *connected);
 void vsock_insert_connected(struct vsock_sock *vsk);
 void vsock_remove_bound(struct vsock_sock *vsk);
 void vsock_remove_connected(struct vsock_sock *vsk);
-struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
+struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr, struct net *net);
 struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
-					 struct sockaddr_vm *dst);
+					 struct sockaddr_vm *dst,
+					 struct net *net);
 void vsock_remove_sock(struct vsock_sock *vsk);
 void vsock_for_each_connected_socket(struct vsock_transport *transport,
 				     void (*fn)(struct sock *sk));
@@ -255,4 +256,6 @@ static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
 {
 	return t->msgzerocopy_allow && t->msgzerocopy_allow();
 }
+
+struct net *vsock_global_net(void);
 #endif /* __AF_VSOCK_H__ */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 7e3db87ae4333cf63327ec105ca99253569bb9fe..d206489bf0a81cf989387c7c8063be91a7c21a7d 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -235,37 +235,60 @@ static void __vsock_remove_connected(struct vsock_sock *vsk)
 	sock_put(&vsk->sk);
 }
 
-static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
+struct net *vsock_global_net(void)
 {
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(vsock_global_net);
+
+static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr,
+					      struct net *net)
+{
+	struct sock *fallback = NULL;
 	struct vsock_sock *vsk;
 
 	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
-		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
-			return sk_vsock(vsk);
+		if (vsock_addr_equals_addr(addr, &vsk->local_addr)) {
+			if (net_eq(net, sock_net(sk_vsock(vsk))))
+				return sk_vsock(vsk);
 
+			if (net_eq(net, vsock_global_net()))
+				fallback = sk_vsock(vsk);
+		}
 		if (addr->svm_port == vsk->local_addr.svm_port &&
 		    (vsk->local_addr.svm_cid == VMADDR_CID_ANY ||
-		     addr->svm_cid == VMADDR_CID_ANY))
-			return sk_vsock(vsk);
+		     addr->svm_cid == VMADDR_CID_ANY)) {
+			if (net_eq(net, sock_net(sk_vsock(vsk))))
+				return sk_vsock(vsk);
+
+			if (net_eq(net, vsock_global_net()))
+				fallback = sk_vsock(vsk);
+		}
 	}
 
-	return NULL;
+	return fallback;
 }
 
 static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
-						  struct sockaddr_vm *dst)
+						  struct sockaddr_vm *dst,
+						  struct net *net)
 {
+	struct sock *fallback = NULL;
 	struct vsock_sock *vsk;
 
 	list_for_each_entry(vsk, vsock_connected_sockets(src, dst),
 			    connected_table) {
 		if (vsock_addr_equals_addr(src, &vsk->remote_addr) &&
 		    dst->svm_port == vsk->local_addr.svm_port) {
-			return sk_vsock(vsk);
+			if (net_eq(net, sock_net(sk_vsock(vsk))))
+				return sk_vsock(vsk);
+
+			if (net_eq(net, vsock_global_net()))
+				fallback = sk_vsock(vsk);
 		}
 	}
 
-	return NULL;
+	return fallback;
 }
 
 static void vsock_insert_unbound(struct vsock_sock *vsk)
@@ -304,12 +327,12 @@ void vsock_remove_connected(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(vsock_remove_connected);
 
-struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
+struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr, struct net *net)
 {
 	struct sock *sk;
 
 	spin_lock_bh(&vsock_table_lock);
-	sk = __vsock_find_bound_socket(addr);
+	sk = __vsock_find_bound_socket(addr, net);
 	if (sk)
 		sock_hold(sk);
 
@@ -320,12 +343,13 @@ struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
 EXPORT_SYMBOL_GPL(vsock_find_bound_socket);
 
 struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
-					 struct sockaddr_vm *dst)
+					 struct sockaddr_vm *dst,
+					 struct net *net)
 {
 	struct sock *sk;
 
 	spin_lock_bh(&vsock_table_lock);
-	sk = __vsock_find_connected_socket(src, dst);
+	sk = __vsock_find_connected_socket(src, dst, net);
 	if (sk)
 		sock_hold(sk);
 
@@ -644,6 +668,7 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 {
 	static u32 port;
 	struct sockaddr_vm new_addr;
+	struct net *net = sock_net(sk_vsock(vsk));
 
 	if (!port)
 		port = get_random_u32_above(LAST_RESERVED_PORT);
@@ -660,7 +685,7 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 
 			new_addr.svm_port = port++;
 
-			if (!__vsock_find_bound_socket(&new_addr)) {
+			if (!__vsock_find_bound_socket(&new_addr, net)) {
 				found = true;
 				break;
 			}
@@ -677,7 +702,7 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 			return -EACCES;
 		}
 
-		if (__vsock_find_bound_socket(&new_addr))
+		if (__vsock_find_bound_socket(&new_addr, net))
 			return -EADDRINUSE;
 	}
 
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 31342ab502b4fc35feb812d2c94e0e35ded73771..253609898d24f8a484fcfc3296011c6f501a72a8 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -313,7 +313,7 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 		return;
 
 	hvs_addr_init(&addr, conn_from_host ? if_type : if_instance);
-	sk = vsock_find_bound_socket(&addr);
+	sk = vsock_find_bound_socket(&addr, NULL);
 	if (!sk)
 		return;
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 7f7de6d8809655fe522749fbbc9025df71f071bd..256d2a4fe482b3cb938a681b6924be69b2065616 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1590,6 +1590,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 			       struct sk_buff *skb)
 {
 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
+	struct net *net = vsock_global_net();
 	struct sockaddr_vm src, dst;
 	struct vsock_sock *vsk;
 	struct sock *sk;
@@ -1617,9 +1618,9 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 	/* The socket must be in connected or bound table
 	 * otherwise send reset back
 	 */
-	sk = vsock_find_connected_socket(&src, &dst);
+	sk = vsock_find_connected_socket(&src, &dst, net);
 	if (!sk) {
-		sk = vsock_find_bound_socket(&dst);
+		sk = vsock_find_bound_socket(&dst, net);
 		if (!sk) {
 			(void)virtio_transport_reset_no_sock(t, skb);
 			goto free_pkt;
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index b370070194fa4ac0df45a073d389ffccf69a0029..373b9fe30a26c18aaa181fbc16db840d8f839b13 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -703,9 +703,9 @@ static int vmci_transport_recv_stream_cb(void *data, struct vmci_datagram *dg)
 	vsock_addr_init(&src, pkt->dg.src.context, pkt->src_port);
 	vsock_addr_init(&dst, pkt->dg.dst.context, pkt->dst_port);
 
-	sk = vsock_find_connected_socket(&src, &dst);
+	sk = vsock_find_connected_socket(&src, &dst, NULL);
 	if (!sk) {
-		sk = vsock_find_bound_socket(&dst);
+		sk = vsock_find_bound_socket(&dst, NULL);
 		if (!sk) {
 			/* We could not find a socket for this specified
 			 * address.  If this packet is a RST, we just drop it.

-- 
2.47.1


