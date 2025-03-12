Return-Path: <kvm+bounces-40858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FAF0A5E629
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 22:06:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67E7417D4EE
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 21:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569871F3D5D;
	Wed, 12 Mar 2025 20:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gj4ZK6zG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AF01F30DE;
	Wed, 12 Mar 2025 20:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741813187; cv=none; b=chhVH9BvFQKa9mIwZpwLRrcyuWDiY+BdQwq2GOQTsZ4e8iaJol2gfwuU5avBn7EtzMPlalwhlDhXFW7m/EqmMk0G06R8vkvtOhqqJazOqqKixrOl1FuO6FpGgeqIZ+yE7ommPIj5UA6poiXQud1oOMvCNtLcx+vm7HLoh5UEpc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741813187; c=relaxed/simple;
	bh=Do16I5bAYzmzhFhoe8gnWsx5863bMKTjbneEuRXGaqU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y/3KvWGIw0IbIbwzlibJ8wqi/SOCmMWM3ojiOi+WsVpxtVkdS4z3w14016Hw0Bj8K3vgGo5arJCjaRhm4FMgtqPcVORcB/BW+apbE17nkEfzaZ+IG5iq/ozb6Fru3Y1J1OQggiCJooLEkJ1CyAL6f1byuRYRNFaBRlAXPAvIwB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gj4ZK6zG; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ff6a98c638so750338a91.0;
        Wed, 12 Mar 2025 13:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741813185; x=1742417985; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lCaQyn2/uqo7QNM9DADy6R5q4JezG8pI2E1+WaA9IUU=;
        b=gj4ZK6zGSugeybrgfdRtomS6ZkfW4Dhn57be8vBpK7RN3WgEGu/Bqc8FMnhY4DGzT2
         EunArjSFiae9lpz+soy/wITxgqokF3xQgNp0I+D5M1cuTDRh1RMTkhanMuYOs7+9YbgB
         KkZBRelc8gg8CYU7DspNWHLTPpZp1FsiGmv9Mxtmhusk8mgvhKj9N+jgwWT2IQ46K1FC
         GZ96i1F2Ux6nV7RvDGYjbWfCtMt/TPNP2Pi55ujV5NqG/mz7ZX8IPI5GktWT+UMUyIpA
         5ntmyXCZwmotCPW+J5KjJejcd05H2xKGfXxqRibiMf8G4Dg0GSLcJMCncyoFkE0WHtNx
         SrzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741813185; x=1742417985;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lCaQyn2/uqo7QNM9DADy6R5q4JezG8pI2E1+WaA9IUU=;
        b=uNVG/kyXe4DnXhxUO18/WFRR3TrxZHqUSLnqi9Z5TB8hWmc134noB+1PbnZiufRKJV
         rk7iUXV0B1NwP3C+YPOKV9u8h9sB98O6vLi2kkHgE8duLfRErwv8FXEaanrb6o+w993H
         2mXByKddzTcqrBvQOMq0SsK0PHyHCLN0XZZixdkacUxadpSb7e/9TnJ0w6Q6/ZUSUuoX
         muE1WcCL/fYYGXhOo5IMgzobfvyQx0S/ny6uZUzv7Uev50UROPNtiW1tqkYTq+ewnBaN
         MuQ0VVajHTrvaTttKDL1zipOG1GhB6meZ9kWRa/vTwdY2xYCRiSZFa0xMxBuZzvhkrRS
         kDTw==
X-Forwarded-Encrypted: i=1; AJvYcCUU/q3jHFYXpRqLyWDDJ0bKry6kua0x87H7HEpecVUabmdp5QnFFRSmcYVF2NtaLXxJfbiHaeqFFyLOfBSQ@vger.kernel.org, AJvYcCUqTjfcpYRY69de56XE3ZT2XBCVMeiR9uphjlgEV+8bNDvTdbITnRsSaYXxPokIL0ZDQn4=@vger.kernel.org, AJvYcCUuMuAzcLub50ZGBkzWLfdzYCl4QR9mAOVjZe9FiJmKw2tFjSZc9Uj2uXpGdu/j6NCF2xrWJhpD@vger.kernel.org, AJvYcCWWFEil2GaybYYfhoP8rplHqnz13HIlybO3Apn3ZMHbTzNbSHhjRWjKZUAzGsWPz4Qg+ydqlyIXNnji4m58@vger.kernel.org
X-Gm-Message-State: AOJu0YyDQ0nkf7dTG7MypetShG/exyKAW/sQOAtYqdU944Ld6vsKTVGo
	HEyiWZhMTIM01IkPYJUXQSzZhuUxomowO137kAZpGEoTyoUkomVZ
X-Gm-Gg: ASbGncvsEYA84QzvDfD0BJ0OZLsZ+gCiCedxjn3zft53vlT/bAuR7Xbpq7ShWg3DdMk
	2Idfgqrf0+fdGv1QDJrsE9Mg5mZWo2gGW94B2wRsx4V4CXeD1AsitlxyK46EvrYv6k/CcP3yVOS
	y29DEH2p419fI2undEsseFXIlTdCrWeGFEDmXrUBdJ8CFqIFhqVTn5PGTvAADerwUT8XhUHmgYL
	NPXoD//4TLwvWS/cIrnjLcKFTZmlzzapdLP5b2rmaDtUY9LCUZ8wE6RYrv1gNoKgG9u3D9i1I86
	WRfW/1h9OdIyXmZnIohq9ix0xdJ2cE2GN1w5xAwM3/I=
X-Google-Smtp-Source: AGHT+IG8o4T4fQgM/ljNeiMXid+znFHo/f0a3WcQ7wf4lTgAMYEbvfs/XE+5hQSFsAZ5+QRpMt+LWA==
X-Received: by 2002:a17:90b:1d0a:b0:2ea:83a0:47a5 with SMTP id 98e67ed59e1d1-2ff7ce457acmr33164596a91.4.1741813184517;
        Wed, 12 Mar 2025 13:59:44 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:70::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301190b98ebsm2342609a91.36.2025.03.12.13.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 13:59:43 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Wed, 12 Mar 2025 13:59:37 -0700
Subject: [PATCH v2 3/3] vhost/vsock: use netns of process that opens the
 vhost-vsock-netns device
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250312-vsock-netns-v2-3-84bffa1aa97a@gmail.com>
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

This patch assigns the network namespace of the process that opened
vhost-vsock-netns device (e.g. VMM) to the packets coming from the
guest, allowing only host sockets in the same network namespace to
communicate with the guest.

This patch also allows having different VMs, running in different
network namespace, with the same CID/port.

This patch brings namespace support only to vhost-vsock, but not
to virtio-vsock, hyperv, or vmci.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
---
v1 -> v2
 * removed 'netns' module param
 * renamed vsock_default_net() to vsock_global_net() to reflect new
   semantics
 * reserved NULL net to indicate "global" vsock namespace

RFC -> v1
* added 'netns' module param
* added 'vsock_net_eq()' to check the "net" assigned to a socket
  only when 'netns' support is enabled
---
 drivers/vhost/vsock.c            | 97 +++++++++++++++++++++++++++++++++-------
 include/linux/miscdevice.h       |  1 +
 include/net/af_vsock.h           |  3 +-
 net/vmw_vsock/af_vsock.c         | 30 ++++++++++++-
 net/vmw_vsock/virtio_transport.c |  4 +-
 net/vmw_vsock/vsock_loopback.c   |  4 +-
 6 files changed, 117 insertions(+), 22 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 02e2a3551205a4398a74a167a82802d950c962f6..8702beb8238aa290b6d901e53c36481637840017 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -46,6 +46,7 @@ static DEFINE_READ_MOSTLY_HASHTABLE(vhost_vsock_hash, 8);
 struct vhost_vsock {
 	struct vhost_dev dev;
 	struct vhost_virtqueue vqs[2];
+	struct net *net;
 
 	/* Link to global vhost_vsock_hash, writes use vhost_vsock_mutex */
 	struct hlist_node hash;
@@ -67,8 +68,9 @@ static u32 vhost_transport_get_local_cid(void)
 /* Callers that dereference the return value must hold vhost_vsock_mutex or the
  * RCU read lock.
  */
-static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
+static struct vhost_vsock *vhost_vsock_get(u32 guest_cid, struct net *net, bool global_fallback)
 {
+	struct vhost_vsock *fallback = NULL;
 	struct vhost_vsock *vsock;
 
 	hash_for_each_possible_rcu(vhost_vsock_hash, vsock, hash, guest_cid) {
@@ -78,11 +80,18 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
 		if (other_cid == 0)
 			continue;
 
-		if (other_cid == guest_cid)
-			return vsock;
+		if (other_cid == guest_cid) {
+			if (net_eq(net, vsock->net))
+				return vsock;
 
+			if (net_eq(vsock->net, vsock_global_net()))
+				fallback = vsock;
+		}
 	}
 
+	if (global_fallback)
+		return fallback;
+
 	return NULL;
 }
 
@@ -272,13 +281,14 @@ static int
 vhost_transport_send_pkt(struct sk_buff *skb)
 {
 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
+	struct net *net = VIRTIO_VSOCK_SKB_CB(skb)->net;
 	struct vhost_vsock *vsock;
 	int len = skb->len;
 
 	rcu_read_lock();
 
 	/* Find the vhost_vsock according to guest context id  */
-	vsock = vhost_vsock_get(le64_to_cpu(hdr->dst_cid));
+	vsock = vhost_vsock_get(le64_to_cpu(hdr->dst_cid), net, true);
 	if (!vsock) {
 		rcu_read_unlock();
 		kfree_skb(skb);
@@ -305,7 +315,8 @@ vhost_transport_cancel_pkt(struct vsock_sock *vsk)
 	rcu_read_lock();
 
 	/* Find the vhost_vsock according to guest context id  */
-	vsock = vhost_vsock_get(vsk->remote_addr.svm_cid);
+	vsock = vhost_vsock_get(vsk->remote_addr.svm_cid,
+				sock_net(sk_vsock(vsk)), true);
 	if (!vsock)
 		goto out;
 
@@ -403,7 +414,7 @@ static bool vhost_transport_msgzerocopy_allow(void)
 	return true;
 }
 
-static bool vhost_transport_seqpacket_allow(u32 remote_cid);
+static bool vhost_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid);
 
 static struct virtio_transport vhost_transport = {
 	.transport = {
@@ -459,13 +470,14 @@ static struct virtio_transport vhost_transport = {
 	.send_pkt = vhost_transport_send_pkt,
 };
 
-static bool vhost_transport_seqpacket_allow(u32 remote_cid)
+static bool vhost_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid)
 {
+	struct net *net = sock_net(sk_vsock(vsk));
 	struct vhost_vsock *vsock;
 	bool seqpacket_allow = false;
 
 	rcu_read_lock();
-	vsock = vhost_vsock_get(remote_cid);
+	vsock = vhost_vsock_get(remote_cid, net, true);
 
 	if (vsock)
 		seqpacket_allow = vsock->seqpacket_allow;
@@ -525,7 +537,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			continue;
 		}
 
-		VIRTIO_VSOCK_SKB_CB(skb)->net = vsock_global_net();
+		VIRTIO_VSOCK_SKB_CB(skb)->net = vsock->net;
 		total_len += sizeof(*hdr) + skb->len;
 
 		/* Deliver to monitoring devices all received packets */
@@ -650,7 +662,7 @@ static void vhost_vsock_free(struct vhost_vsock *vsock)
 	kvfree(vsock);
 }
 
-static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
+static int __vhost_vsock_dev_open(struct inode *inode, struct file *file, struct net *net)
 {
 	struct vhost_virtqueue **vqs;
 	struct vhost_vsock *vsock;
@@ -669,6 +681,8 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
+	vsock->net = net;
+
 	vsock->guest_cid = 0; /* no CID assigned yet */
 	vsock->seqpacket_allow = false;
 
@@ -693,6 +707,22 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
+static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
+{
+	return __vhost_vsock_dev_open(inode, file, vsock_global_net());
+}
+
+static int vhost_vsock_netns_dev_open(struct inode *inode, struct file *file)
+{
+	struct net *net;
+
+	net = get_net_ns_by_pid(current->pid);
+	if (IS_ERR(net))
+		return PTR_ERR(net);
+
+	return __vhost_vsock_dev_open(inode, file, net);
+}
+
 static void vhost_vsock_flush(struct vhost_vsock *vsock)
 {
 	vhost_dev_flush(&vsock->dev);
@@ -708,7 +738,7 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
 	 */
 
 	/* If the peer is still valid, no need to reset connection */
-	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
+	if (vhost_vsock_get(vsk->remote_addr.svm_cid, sock_net(sk), true))
 		return;
 
 	/* If the close timeout is pending, let it expire.  This avoids races
@@ -753,6 +783,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
 
 	vhost_dev_cleanup(&vsock->dev);
+	if (vsock->net)
+		put_net(vsock->net);
 	kfree(vsock->dev.vqs);
 	vhost_vsock_free(vsock);
 	return 0;
@@ -777,9 +809,15 @@ static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 guest_cid)
 	if (vsock_find_cid(guest_cid))
 		return -EADDRINUSE;
 
+	/* If this namespace has already connected to this CID, then report
+	 * that this address is already in use.
+	 */
+	if (vsock->net && vsock_net_has_connected(vsock->net, guest_cid))
+		return -EADDRINUSE;
+
 	/* Refuse if CID is already in use */
 	mutex_lock(&vhost_vsock_mutex);
-	other = vhost_vsock_get(guest_cid);
+	other = vhost_vsock_get(guest_cid, vsock->net, false);
 	if (other && other != vsock) {
 		mutex_unlock(&vhost_vsock_mutex);
 		return -EADDRINUSE;
@@ -931,6 +969,24 @@ static struct miscdevice vhost_vsock_misc = {
 	.fops = &vhost_vsock_fops,
 };
 
+static const struct file_operations vhost_vsock_netns_fops = {
+	.owner          = THIS_MODULE,
+	.open           = vhost_vsock_netns_dev_open,
+	.release        = vhost_vsock_dev_release,
+	.llseek		= noop_llseek,
+	.unlocked_ioctl = vhost_vsock_dev_ioctl,
+	.compat_ioctl   = compat_ptr_ioctl,
+	.read_iter      = vhost_vsock_chr_read_iter,
+	.write_iter     = vhost_vsock_chr_write_iter,
+	.poll           = vhost_vsock_chr_poll,
+};
+
+static struct miscdevice vhost_vsock_netns_misc = {
+	.minor = VHOST_VSOCK_NETNS_MINOR,
+	.name = "vhost-vsock-netns",
+	.fops = &vhost_vsock_netns_fops,
+};
+
 static int __init vhost_vsock_init(void)
 {
 	int ret;
@@ -941,17 +997,26 @@ static int __init vhost_vsock_init(void)
 		return ret;
 
 	ret = misc_register(&vhost_vsock_misc);
-	if (ret) {
-		vsock_core_unregister(&vhost_transport.transport);
-		return ret;
-	}
+	if (ret)
+		goto out_vt;
+
+	ret = misc_register(&vhost_vsock_netns_misc);
+	if (ret)
+		goto out_vvm;
 
 	return 0;
+
+out_vvm:
+	misc_deregister(&vhost_vsock_misc);
+out_vt:
+	vsock_core_unregister(&vhost_transport.transport);
+	return ret;
 };
 
 static void __exit vhost_vsock_exit(void)
 {
 	misc_deregister(&vhost_vsock_misc);
+	misc_deregister(&vhost_vsock_netns_misc);
 	vsock_core_unregister(&vhost_transport.transport);
 };
 
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 69e110c2b86a9b16c1637778a25e1eebb3fd0111..a7e11b70a5398a225c4d63d50ac460e6388e022c 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -71,6 +71,7 @@
 #define USERIO_MINOR		240
 #define VHOST_VSOCK_MINOR	241
 #define RFKILL_MINOR		242
+#define VHOST_VSOCK_NETNS_MINOR	243
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 41afbc18648c953da27a93571d408de968aa7668..1e37737689a741d91e64b8c0ed0a931fc7376194 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -143,7 +143,7 @@ struct vsock_transport {
 				     int flags);
 	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
 				 size_t len);
-	bool (*seqpacket_allow)(u32 remote_cid);
+	bool (*seqpacket_allow)(struct vsock_sock *vsk, u32 remote_cid);
 	u32 (*seqpacket_has_data)(struct vsock_sock *vsk);
 
 	/* Notification. */
@@ -258,4 +258,5 @@ static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
 }
 
 struct net *vsock_global_net(void);
+bool vsock_net_has_connected(struct net *net, u64 guest_cid);
 #endif /* __AF_VSOCK_H__ */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d206489bf0a81cf989387c7c8063be91a7c21a7d..58fa415555d6aae5043b5ca2bfc4783af566cf28 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -391,6 +391,34 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
 }
 EXPORT_SYMBOL_GPL(vsock_for_each_connected_socket);
 
+bool vsock_net_has_connected(struct net *net, u64 guest_cid)
+{
+	bool ret = false;
+	int i;
+
+	spin_lock_bh(&vsock_table_lock);
+
+	for (i = 0; i < ARRAY_SIZE(vsock_connected_table); i++) {
+		struct vsock_sock *vsk;
+
+		list_for_each_entry(vsk, &vsock_connected_table[i],
+				    connected_table) {
+			if (sock_net(sk_vsock(vsk)) != net)
+				continue;
+
+			if (vsk->remote_addr.svm_cid == guest_cid) {
+				ret = true;
+				goto out;
+			}
+		}
+	}
+
+out:
+	spin_unlock_bh(&vsock_table_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vsock_net_has_connected);
+
 void vsock_add_pending(struct sock *listener, struct sock *pending)
 {
 	struct vsock_sock *vlistener;
@@ -537,7 +565,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		if (!new_transport->seqpacket_allow ||
-		    !new_transport->seqpacket_allow(remote_cid)) {
+		    !new_transport->seqpacket_allow(vsk, remote_cid)) {
 			module_put(new_transport->module);
 			return -ESOCKTNOSUPPORT;
 		}
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 163ddfc0808529ad6dda7992f9ec48837dd7337c..60bf3f1f39c51d44768fd2f04df3abee9f966252 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -536,7 +536,7 @@ static bool virtio_transport_msgzerocopy_allow(void)
 	return true;
 }
 
-static bool virtio_transport_seqpacket_allow(u32 remote_cid);
+static bool virtio_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid);
 
 static struct virtio_transport virtio_transport = {
 	.transport = {
@@ -593,7 +593,7 @@ static struct virtio_transport virtio_transport = {
 	.can_msgzerocopy = virtio_transport_can_msgzerocopy,
 };
 
-static bool virtio_transport_seqpacket_allow(u32 remote_cid)
+static bool virtio_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid)
 {
 	struct virtio_vsock *vsock;
 	bool seqpacket_allow;
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 6e78927a598e07cf77386a420b9d05d3f491dc7c..1b2fab73e0d0a6c63ed60d29fc837da58f6fb121 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -46,7 +46,7 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
 	return 0;
 }
 
-static bool vsock_loopback_seqpacket_allow(u32 remote_cid);
+static bool vsock_loopback_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid);
 static bool vsock_loopback_msgzerocopy_allow(void)
 {
 	return true;
@@ -106,7 +106,7 @@ static struct virtio_transport loopback_transport = {
 	.send_pkt = vsock_loopback_send_pkt,
 };
 
-static bool vsock_loopback_seqpacket_allow(u32 remote_cid)
+static bool vsock_loopback_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid)
 {
 	return true;
 }

-- 
2.47.1


