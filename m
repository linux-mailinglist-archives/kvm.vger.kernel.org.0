Return-Path: <kvm+bounces-57807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E548B7E504
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE4713B97AF
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 23:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D6A2F745F;
	Tue, 16 Sep 2025 23:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YGHr+K6C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A33B2F5327
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 23:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758066243; cv=none; b=jqUlYqqrTnmaduRYaTawU8THYsOQn5k4/2e6YMkubJwFIQEHvC3Jt3qEWkkwUkOF0mtSwwUv9yhwub4CSiOvPAX1YU/i3q6Juk8UsRSWpaquKpWFmWs/4jqwM8UxSW5ql/uO5s6q0zMzjBPgU/uOmFOlDjNxb/8mT74TXQhM76I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758066243; c=relaxed/simple;
	bh=XsnkMyQoiDjSyscFIjDdskWFvtSk6gaKUIKj/7lSCm4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PGcywAjk/nGd+hwWxROCEMdEf8fRRrWvWehfnon1i0U2SkY5xPi2aNXej4DYcaJI7nR9tZ94wQD8ZlsbdGBd1xOxFjUA12a34wevsNgw3VoI+QdAew5mMKpRjHOoSdFSSDBuvJEFfc13NYBCBcxusXXix3QHbLuHwDgPpkqlOZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YGHr+K6C; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2445826fd9dso71810255ad.3
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758066241; x=1758671041; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GbdwKehIoIHRtRqLAxQ+WKxaFmFQHmQ2pBun1Ap9hJU=;
        b=YGHr+K6CngRyT4HyIMqT9bKIf+qM7VFqGbFy0rdQ7YpECOCz7YcGtpc4+eReHNPf/N
         ebIx/XgP47NnwP3UakNk9KYGaFqE6VyaTDF0dkUrDic6SSoBn+UsOLn0swQ5AxUAXNVf
         Zi9oY8ysf4HeKzfmVOnfoalLY00LdoT6Ql4O2t8nhbsO1OJc24eg0N7KQWo3gr3/UIQd
         qIR4owAJVF0+MHROycaIwxqOeD1ueB/E1ToxWDzVLt6FMs7abNstkkW6M5fAyJvilQiF
         WeEDxRVu+81gLuQEwDJymIaxhyTYO8zZuD1mfkUOgnozcFOqL5PffLla3n4MWCHbzb+1
         RGZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758066241; x=1758671041;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GbdwKehIoIHRtRqLAxQ+WKxaFmFQHmQ2pBun1Ap9hJU=;
        b=XMRr555Eng9qc/W5YbQwrN+8mhst3doh7j8sqxqkhqxM8wmOCy2EeZ5+0vmNijYOu0
         L3o7kdSolLshM05gnIZ5X2FdnTCQRDPz+lSzS7wusJVPllT5xlxXw1WpjHYNycZHIW2u
         oC2C6pkUx9gqIYc06MeSmpghg5dVNFwUXunJdNRBxGGqvjYSM8wi96AWvFqZ0Hn0nf65
         C4mfmehAnU0nhRoaPZqf/vAkEYBtolVWEVydnsdPNO0jnHwoD9npPqbmDnveiMASe4h7
         VT/LE4o61XxXpW+bFBtdtS7imF7Mf+N4mVZGgdkG5eKlWGcUUuhqrGCTQObNnhSEYcNp
         AoDA==
X-Forwarded-Encrypted: i=1; AJvYcCU6ouVs0IBDQddy05EScxqOWWPj/MF6wxGYaZKzN4DYl/UFB8x87KVbjcwrtigXgIz/VKU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK/Yl9WT46FAIzWV0s7UlhqGmfv/DStLJZZPiTcukyDsF5qYF9
	FNJsAyubO9N3G1NK51s3X3uB5Kn9OeBq40HRbJGAdaETPtH8rjF1m9a5
X-Gm-Gg: ASbGnctIiKi7NGhLO+om8ahOzeCDY6x4LfJwUyXgO97hwGDYDRqwbebf3fBIYYepdBo
	K6i0ImpppWwl60P8ksai7Qydw1B+gptuqZbKMDjHcdpxL5cvfu0eZXnux7IfRs3Nqgh6uJ0MezC
	K+w4UJKuqnsPJe0Ys59tCvDQg+JAX3SEwfkAbuIMbxsrMCI1HFGjQOV0u/eAXNKr3cO7SL96D+d
	sZulYM8JEoM/j66AUVErS58b5aoD6y0FF0QL/HQTXvn6+dUkLJJjMhHWJFpjOP8edPgcCEfRTc1
	n4iT5yMpR5XFIRQwCHM1JKM0w3EfQrrQXWRZna2pLtCB7a4ihFLCHZKbqoXuF0Fq2BARpNi+HFh
	HNx5vYWz3ovxXLbVAh0Z4i4ETz9H2Jzw=
X-Google-Smtp-Source: AGHT+IF/pyzswxNFNkRKTib2UDHppVdNz86fZjJPyjOG7e1TjRL6qmhbxP/zP+ozSDEbzUE6jX7HZg==
X-Received: by 2002:a17:902:ecce:b0:24c:7bc6:7ac7 with SMTP id d9443c01a7336-2681217e503mr1123395ad.18.1758066240548;
        Tue, 16 Sep 2025 16:44:00 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:72::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2679423db74sm59204955ad.77.2025.09.16.16.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 16:43:59 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 16 Sep 2025 16:43:50 -0700
Subject: [PATCH net-next v6 6/9] vhost/vsock: add netns support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250916-vsock-vmtest-v6-6-064d2eb0c89d@meta.com>
References: <20250916-vsock-vmtest-v6-0-064d2eb0c89d@meta.com>
In-Reply-To: <20250916-vsock-vmtest-v6-0-064d2eb0c89d@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 Bobby Eshleman <bobbyeshleman@gmail.com>, berrange@redhat.com, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.13.0

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add the ability to isolate vsock flows using namespaces.

The VM, via the vhost_vsock struct, inherits its namespace from the
process that opens the vhost-vsock device. vhost_vsock lookup functions
are modified to take into account the mode (e.g., if CIDs are matching
but modes don't align, then return NULL).

vhost_vsock now acquires a reference to the namespace.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>

---
Changes in v5:
- respect pid namespaces when assigning namespace to vhost_vsock
---
 drivers/vhost/vsock.c | 74 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 66 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 34adf0cf9124..1aabe9f85503 100644
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
+	enum vsock_net_mode orig_net_mode;
 
 	/* Link to global vhost_vsock_hash, writes use vhost_vsock_mutex */
 	struct hlist_node hash;
@@ -64,10 +69,40 @@ static u32 vhost_transport_get_local_cid(void)
 	return VHOST_VSOCK_DEFAULT_HOST_CID;
 }
 
+/* Return true if the namespace net can access the vhost_vsock vsock.
+ * Otherwise, return false.
+ *
+ * If the netns is the same, it doesn't matter if it is local or global. The
+ * vsock sockets within a namespace can always communicate.
+ *
+ * If the netns is different, then we need to check if the current namespace
+ * mode is global and if the namespace mode at the time of the vhost_vsock
+ * being created is global. If so, then we allow it. By checking the namespace
+ * mode at the time of the vhost_vsock's creation we allow the flow to continue
+ * working even if the namespace mode changes to "local" in the middle of a
+ * socket's lifetime. If we used the current namespace mode instead, then any
+ * socket that was alive prior to the mode change would suddenly fail.
+ */
+static bool vhost_vsock_net_check_mode(struct net *net,
+				       struct vhost_vsock *vsock,
+				       bool check_global)
+{
+	if (net_eq(net, vsock->net))
+		return true;
+
+	return check_global &&
+	       (vsock_net_mode(net) == VSOCK_NET_MODE_GLOBAL &&
+	        vsock->orig_net_mode == VSOCK_NET_MODE_GLOBAL);
+}
+
 /* Callers that dereference the return value must hold vhost_vsock_mutex or the
  * RCU read lock.
+ *
+ * If check_global is true, evaluate the vhost_vsock namespace and namespace
+ * net argument as matching if they are both in global mode.
  */
-static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
+static struct vhost_vsock *vhost_vsock_get(u32 guest_cid, struct net *net,
+					   bool check_global)
 {
 	struct vhost_vsock *vsock;
 
@@ -78,9 +113,9 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
 		if (other_cid == 0)
 			continue;
 
-		if (other_cid == guest_cid)
+		if (other_cid == guest_cid &&
+		    vhost_vsock_net_check_mode(net, vsock, check_global))
 			return vsock;
-
 	}
 
 	return NULL;
@@ -272,13 +307,14 @@ static int
 vhost_transport_send_pkt(struct sk_buff *skb)
 {
 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
+	struct net *net = virtio_vsock_skb_net(skb);
 	struct vhost_vsock *vsock;
 	int len = skb->len;
 
 	rcu_read_lock();
 
 	/* Find the vhost_vsock according to guest context id  */
-	vsock = vhost_vsock_get(le64_to_cpu(hdr->dst_cid));
+	vsock = vhost_vsock_get(le64_to_cpu(hdr->dst_cid), net, true);
 	if (!vsock) {
 		rcu_read_unlock();
 		kfree_skb(skb);
@@ -305,7 +341,7 @@ vhost_transport_cancel_pkt(struct vsock_sock *vsk)
 	rcu_read_lock();
 
 	/* Find the vhost_vsock according to guest context id  */
-	vsock = vhost_vsock_get(vsk->remote_addr.svm_cid);
+	vsock = vhost_vsock_get(vsk->remote_addr.svm_cid, sock_net(sk_vsock(vsk)), true);
 	if (!vsock)
 		goto out;
 
@@ -462,11 +498,12 @@ static struct virtio_transport vhost_transport = {
 
 static bool vhost_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid)
 {
+	struct net *net = sock_net(sk_vsock(vsk));
 	struct vhost_vsock *vsock;
 	bool seqpacket_allow = false;
 
 	rcu_read_lock();
-	vsock = vhost_vsock_get(remote_cid);
+	vsock = vhost_vsock_get(remote_cid, net, true);
 
 	if (vsock)
 		seqpacket_allow = vsock->seqpacket_allow;
@@ -526,6 +563,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			continue;
 		}
 
+		virtio_vsock_skb_set_net(skb, vsock->net);
+		virtio_vsock_skb_set_orig_net_mode(skb, vsock->orig_net_mode);
 		total_len += sizeof(*hdr) + skb->len;
 
 		/* Deliver to monitoring devices all received packets */
@@ -652,10 +691,14 @@ static void vhost_vsock_free(struct vhost_vsock *vsock)
 
 static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 {
+
 	struct vhost_virtqueue **vqs;
 	struct vhost_vsock *vsock;
+	struct net *net;
 	int ret;
 
+	net = current->nsproxy->net_ns;
+
 	/* This struct is large and allocation could fail, fall back to vmalloc
 	 * if there is no other way.
 	 */
@@ -669,6 +712,12 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
+	vsock->net = get_net_track(net, &vsock->ns_tracker, GFP_KERNEL);
+
+	/* Cache the mode of the namespace so that if that netns mode changes,
+	 * the vhost_vsock will continue to function as expected. */
+	vsock->orig_net_mode = vsock_net_mode(net);
+
 	vsock->guest_cid = 0; /* no CID assigned yet */
 	vsock->seqpacket_allow = false;
 
@@ -707,8 +756,16 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
 	 * executing.
 	 */
 
+	/* DELETE ME:
+	 *
+	 * for each connected socket:
+	 *	vhost_vsock = vsock_sk(sk)
+	 *
+	 *	find the peer
+	 */
+
 	/* If the peer is still valid, no need to reset connection */
-	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
+	if (vhost_vsock_get(vsk->remote_addr.svm_cid, sock_net(sk), false))
 		return;
 
 	/* If the close timeout is pending, let it expire.  This avoids races
@@ -753,6 +810,7 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
 
 	vhost_dev_cleanup(&vsock->dev);
+	put_net_track(vsock->net, &vsock->ns_tracker);
 	kfree(vsock->dev.vqs);
 	vhost_vsock_free(vsock);
 	return 0;
@@ -779,7 +837,7 @@ static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 guest_cid)
 
 	/* Refuse if CID is already in use */
 	mutex_lock(&vhost_vsock_mutex);
-	other = vhost_vsock_get(guest_cid);
+	other = vhost_vsock_get(guest_cid, vsock->net, true);
 	if (other && other != vsock) {
 		mutex_unlock(&vhost_vsock_mutex);
 		return -EADDRINUSE;

-- 
2.47.3


