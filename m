Return-Path: <kvm+bounces-21356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B787292DAF4
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:30:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1BD9AB20E02
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C93AE16A92D;
	Wed, 10 Jul 2024 21:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ii06eIbs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ACF15E5CF;
	Wed, 10 Jul 2024 21:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646767; cv=none; b=Wh9nniWm5G7ezrPyNh4TR+XjD4OJxpyXecuoNFnXUDI7xuH0Nziwh9WE1AdgUc/Y0hA56zix8Z6i12y1ZWl6hmzv/ZlxEkxjvKwHSgZVPkgIhV3eDQ7btGnB1RTceXZoli1Xpss3/FHi7yEQjrzvnxRNEvdf7lv7n6Iw1rgGI/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646767; c=relaxed/simple;
	bh=zERDNd9JCYNnr+ycpOsWDKndLRgVVm/OgVyL7VGJ4wQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aizMC8wzn4nAPdYbqtJpdy3XwErOapf8e94fVm0SmRGOWPZooTXCu1K9HGFlDhdx/m4CJQ+ZFE86dKdoxQZC33l7eujYWYDNwAlfmC/CVpOqjJO1QHyupmWznqKq5DKM94UwOQy4i8ZWaKxfVJN0HNJEoPtQb5LoI7MsLcN7CrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ii06eIbs; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-64b0d45a7aaso2321177b3.0;
        Wed, 10 Jul 2024 14:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646765; x=1721251565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sN+GRSmx+rskTAQOVFYDHoKP/o7w51RMiYsLeysrnrY=;
        b=Ii06eIbs37xb3sMkd5xaaRWyJjk6+197FdF7l8Z+ikSonNvwvljm26e8o4RU/B7Mf6
         nv6JIw1fl8jCj5EWEdb/F41Vjs1MN/JSghHMrFAFa7BVKF67gc/TmtsutE+CAuCSREbX
         dvxCr0rUPIks8d+4d8R+DyD53B0lPRPUV5d0+EomBS5xABV1QiTrBFbIJqhXSdWFjOhm
         Vm+biOtp+DaES6ejTEjlfyxCTNME6Dl8KdQ60AHC44uqyHI7XtpikG11ODtvvSzRK/74
         6iqOyQMm9Ddr04RnY59k3xY/i+4Dm61hLWv+rQ+QPCbH0+yJePJJP42RIYusy4x8SADh
         qC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646765; x=1721251565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sN+GRSmx+rskTAQOVFYDHoKP/o7w51RMiYsLeysrnrY=;
        b=iSNgtv8ufK4NtLDVlXNMMe2/8aoHlb80aWvIaO8a4fPDUxgZMbCwkSCILmnwo2VCR3
         oP+EXJOh7+CpyZhi6b6j/H0dcCfmnCn0xhMuZzns19LF1eyXED0+VlcYzi0V0GsoLDGW
         dvz+XgT3ka1uyeMqS0bpAjWvp+hSEFkzptVdVbC1PoEIcV3c26IFYBZzZaOQ367Czp7L
         YsVTjHOoHE4qo8EISVzGfm9IgqtIEMZN8CxppH17UEybHKTfAJ5fh/QsV1Mb4rIidL8X
         1YmvIf30YeTrU5/rZIKW2bXMe7ZlG0mB57Ql8MbDqGH6TdLI2fOhwRpKyJI9DTL9Ex/F
         vd2A==
X-Forwarded-Encrypted: i=1; AJvYcCUXIM8jm0yivY6P4CxHNfs2rYd8Mc9gT2ipnMIBWKK4744ZePQkzJ/j1CImqdpn7L3jn5epyBsdEhqZNLmqLAC0pLrVJf6+B+W7DFRetQGh9kcReu8eSJaTT9a+FVmayMZQN1ZwfSkGGQVP7JWJkheKYFnKb/GFeNvsBqeyizE6gNwIpckY56QB1GTlAF1VwhqjDelLUsdJSPJB6br2l2/AHhfdTal49l9WW+I2
X-Gm-Message-State: AOJu0Yzp3vB6QWunA7gV8U/2EWgHPcpz16tUfrSR0sqRjZkymeAc5iXW
	gP+hDPIE6hDIrcJYY3vrTgL8ZzNlxk5dH9S1pSZfVWSndJ71X8zV
X-Google-Smtp-Source: AGHT+IFdDJbzk9Eahvtm1VoZEbVdPnTfeK7msIL9TKHGtqINukZ8lIPGu27MsG6zHof1X+d3FW8ZCw==
X-Received: by 2002:a05:690c:4d82:b0:650:f7a4:c70d with SMTP id 00721157ae682-658f02f55edmr94195357b3.41.1720646764730;
        Wed, 10 Jul 2024 14:26:04 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:26:04 -0700 (PDT)
From: Amery Hung <ameryhung@gmail.com>
X-Google-Original-From: Amery Hung <amery.hung@bytedance.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	bryantan@vmware.com,
	vdasa@vmware.com,
	pv-drivers@vmware.com
Cc: dan.carpenter@linaro.org,
	simon.horman@corigine.com,
	oxffffaa@gmail.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	bobby.eshleman@bytedance.com,
	jiang.wang@bytedance.com,
	amery.hung@bytedance.com,
	ameryhung@gmail.com,
	xiyou.wangcong@gmail.com
Subject: [RFC PATCH net-next v6 11/14] vhost/vsock: implement datagram support
Date: Wed, 10 Jul 2024 21:25:52 +0000
Message-Id: <20240710212555.1617795-12-amery.hung@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240710212555.1617795-1-amery.hung@bytedance.com>
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bobby Eshleman <bobby.eshleman@bytedance.com>

This commit implements datagram support for vhost/vsock by teaching
vhost to use the common virtio transport datagram functions.

If the virtio RX buffer is too small, then the transmission is
abandoned, the packet dropped, and EHOSTUNREACH is added to the socket's
error queue.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Signed-off-by: Amery Hung <amery.hung@bytedance.com>
---
 drivers/vhost/vsock.c    | 60 ++++++++++++++++++++++++++++++++++++++--
 net/vmw_vsock/af_vsock.c |  2 +-
 2 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index fa1aefb78016..13c3cbff21da 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -8,6 +8,7 @@
  */
 #include <linux/miscdevice.h>
 #include <linux/atomic.h>
+#include <linux/errqueue.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/vmalloc.h>
@@ -32,7 +33,8 @@
 enum {
 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
 			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
-			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
+			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
+			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
 };
 
 enum {
@@ -56,6 +58,7 @@ struct vhost_vsock {
 	atomic_t queued_replies;
 
 	u32 guest_cid;
+	bool dgram_allow;
 	bool seqpacket_allow;
 };
 
@@ -86,6 +89,32 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
 	return NULL;
 }
 
+/* Claims ownership of the skb, do not free the skb after calling! */
+static void
+vhost_transport_error(struct sk_buff *skb, int err)
+{
+	struct sock_exterr_skb *serr;
+	struct sock *sk = skb->sk;
+	struct sk_buff *clone;
+
+	serr = SKB_EXT_ERR(skb);
+	memset(serr, 0, sizeof(*serr));
+	serr->ee.ee_errno = err;
+	serr->ee.ee_origin = SO_EE_ORIGIN_NONE;
+
+	clone = skb_clone(skb, GFP_KERNEL);
+	if (!clone)
+		goto out;
+
+	if (sock_queue_err_skb(sk, clone))
+		kfree_skb(clone);
+
+	sk->sk_err = err;
+	sk_error_report(sk);
+out:
+	kfree_skb(skb);
+}
+
 static void
 vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			    struct vhost_virtqueue *vq)
@@ -162,9 +191,15 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		hdr = virtio_vsock_hdr(skb);
 
 		/* If the packet is greater than the space available in the
-		 * buffer, we split it using multiple buffers.
+		 * buffer, we split it using multiple buffers for connectible
+		 * sockets and drop the packet for datagram sockets.
 		 */
 		if (payload_len > iov_len - sizeof(*hdr)) {
+			if (le16_to_cpu(hdr->type) == VIRTIO_VSOCK_TYPE_DGRAM) {
+				vhost_transport_error(skb, EHOSTUNREACH);
+				continue;
+			}
+
 			payload_len = iov_len - sizeof(*hdr);
 
 			/* As we are copying pieces of large packet's buffer to
@@ -403,6 +438,22 @@ static bool vhost_transport_msgzerocopy_allow(void)
 	return true;
 }
 
+static bool vhost_transport_dgram_allow(u32 cid, u32 port)
+{
+	struct vhost_vsock *vsock;
+	bool dgram_allow = false;
+
+	rcu_read_lock();
+	vsock = vhost_vsock_get(cid);
+
+	if (vsock)
+		dgram_allow = vsock->dgram_allow;
+
+	rcu_read_unlock();
+
+	return dgram_allow;
+}
+
 static bool vhost_transport_seqpacket_allow(u32 remote_cid);
 
 static struct virtio_transport vhost_transport = {
@@ -419,7 +470,7 @@ static struct virtio_transport vhost_transport = {
 		.cancel_pkt               = vhost_transport_cancel_pkt,
 
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
-		.dgram_allow              = virtio_transport_dgram_allow,
+		.dgram_allow              = vhost_transport_dgram_allow,
 
 		.stream_enqueue           = virtio_transport_stream_enqueue,
 		.stream_dequeue           = virtio_transport_stream_dequeue,
@@ -811,6 +862,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
 	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
 		vsock->seqpacket_allow = true;
 
+	if (features & (1ULL << VIRTIO_VSOCK_F_DGRAM))
+		vsock->dgram_allow = true;
+
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
 		vq = &vsock->vqs[i];
 		mutex_lock(&vq->mutex);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index f0e5db0eb43a..344db0f3a602 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1463,7 +1463,7 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 		return prot->recvmsg(sk, msg, len, flags, NULL);
 #endif
 
-	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
+	if (unlikely(flags & MSG_OOB))
 		return -EOPNOTSUPP;
 
 	if (unlikely(flags & MSG_ERRQUEUE))
-- 
2.20.1


