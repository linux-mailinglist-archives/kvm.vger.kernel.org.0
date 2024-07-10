Return-Path: <kvm+bounces-21353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5249092DAE4
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:29:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D64B81F22029
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D705015F401;
	Wed, 10 Jul 2024 21:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ncEvEbJu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6652158A03;
	Wed, 10 Jul 2024 21:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646765; cv=none; b=FIEfE04xmKbdcbcoq3Lcsu3b3jUJuV8Id5hr5sGXRCghJR07rg+dBAxGei1u8bWi9EfMUKbhIDmrTASFqmUZuVgVBSux+hP3/LkWvGFdxynF7ljDXqhxal6Z594/cSffD6cMtuvIgdgY8g+vBePAgnCHHA60D9efLKUiRYN8YBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646765; c=relaxed/simple;
	bh=GXo6JSq/5CxjMKofrwy78dq6F+39cdkj30pXolPW1Us=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bSuic7JTt4iqvtcPNA8/whD5QWhCntM0DIfO+LtT6b1TExJG+Y9XGAHPNrFIVDpe1soEzS3wDhhUpEH6HekTzNRT0XN6HwAFGXEgaEvYaZKQdsMFY2vexpi/89zfW9MPljUuoItGzxQZysG4dWsI1L55Od/TjJzo5aE4+vgWxtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ncEvEbJu; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-79ef93865afso14097385a.1;
        Wed, 10 Jul 2024 14:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646761; x=1721251561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcuXrJuADhlXXbo4cjnK+9NG13fjZ+fX0XEhslHQVp4=;
        b=ncEvEbJu9f/Gms65RjwE5Ns0Z4nmIYR931isiJPqRYFH9CxEwN08QBxxC1iWie6dGR
         fKr6LQ7kAF7VKndt0AM0yGk/8ioxy/cgV/3pvuAzApJffu7PlHtCfbE7L04soWUt0pJ2
         fm/KHWWwB/QUptSQDbIFly7RLLMs+gBLyXGJ15ZOepmCYfparV7zAC8QLBq0mixZk3WI
         QMLG5TrxNutuH9WjPqn/Ef5nst0sxYi6WI7bicBpDD6hpYWUcspYEfkgNhvWmWCv1vsi
         FVPEgdvTRoVKNf6iNrqyscrv2iaRsJBk2uhh4vAJ8Dy6em3quzG5EQo/aoW4jgSL5QOr
         JIDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646761; x=1721251561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jcuXrJuADhlXXbo4cjnK+9NG13fjZ+fX0XEhslHQVp4=;
        b=r+Xdnm32p0q0M0XnIRrsL14JDnXbwAnxB7Yv+U3Zk5Ke0U0+X/rfRtF1BSOc6K+UpB
         IZSWNjSYVtAf6KHZsJyDWUDiUCRQSJ8J8B66mb4xL/EezdXIo6jEzy6UcTIs4i+7fWCu
         AJsk8uSjleFCoeUTcaVrzapMr5D1jOpjgXdsEStxlHnLcMs/BByoWPBNEA+hmU7CDyqd
         5k3ecC8SgndcSpK53Wme5NhkijJ7kqCaxWd3BTMbTvimypLNg7Kor1KJ9CrkG584A5eZ
         rg7PeW7yauC1LQ6ARry/vGgg4M/n/Zo1iVhpQ9OWAxeqglnuAx7BqKLEtN9/W1idFrbX
         /boA==
X-Forwarded-Encrypted: i=1; AJvYcCXO0A+Eckkn+P263s80CTYe9NWfZLO+DdMVx+fkdqDaq4PvuxzwsewuShMxj59B9e59I0ROhEdg8Vh5BUTvBpplD2ffmPHJR+uwafZb2Oq1z1SzIcbVrD1Kam6U04pS1miFBDnqDM06GDu5cBY1q/GIFXSikj5tQygWKl9PP7XSCLsdvDMXV4ZauX9D/JT6jcKty/gvf+3BYzNLdofX+09MJ4CRiN2w0ou3PUCe
X-Gm-Message-State: AOJu0Yz/c+5zKvl3/0S214VypwAm0Wn9fzgevjcTGofcfLCXOB0gByhF
	5PLzzJBm/x90HAYQ9Gd5sekqezPWGRJ1o94ttBipBZroNvHqINta
X-Google-Smtp-Source: AGHT+IFD1T5j41+YkZKjlX8tb+oypqzwGo0KjjclrVPhg6VzPZNTu72qGOLdEGcwfETG9bkgVsiXwg==
X-Received: by 2002:a05:620a:5604:b0:79d:6169:7ab9 with SMTP id af79cd13be357-79f19c083f0mr801584485a.68.1720646761611;
        Wed, 10 Jul 2024 14:26:01 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:26:01 -0700 (PDT)
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
Subject: [RFC PATCH net-next v6 07/14] virtio/vsock: add common datagram send path
Date: Wed, 10 Jul 2024 21:25:48 +0000
Message-Id: <20240710212555.1617795-8-amery.hung@bytedance.com>
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

This commit implements the common function
virtio_transport_dgram_enqueue for enqueueing datagrams. It does not add
usage in either vhost or virtio yet.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Signed-off-by: Amery Hung <amery.hung@bytedance.com>
---
 include/linux/virtio_vsock.h            |  1 +
 include/net/af_vsock.h                  |  2 +
 net/vmw_vsock/af_vsock.c                |  2 +-
 net/vmw_vsock/virtio_transport_common.c | 87 ++++++++++++++++++++++++-
 4 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index f749a066af46..4408749febd2 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -152,6 +152,7 @@ struct virtio_vsock_pkt_info {
 	u16 op;
 	u32 flags;
 	bool reply;
+	u8 remote_flags;
 };
 
 struct virtio_transport {
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 44db8f2c507d..6e97d344ac75 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -216,6 +216,8 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
 				     void (*fn)(struct sock *sk));
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
 bool vsock_find_cid(unsigned int cid);
+const struct vsock_transport *vsock_dgram_lookup_transport(unsigned int cid,
+							   __u8 flags);
 
 struct vsock_skb_cb {
 	unsigned int src_cid;
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ab08cd81720e..f83b655fdbe9 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -487,7 +487,7 @@ vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
 	return transport;
 }
 
-static const struct vsock_transport *
+const struct vsock_transport *
 vsock_dgram_lookup_transport(unsigned int cid, __u8 flags)
 {
 	const struct vsock_transport *transport;
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index a1c76836d798..46cd1807f8e3 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1040,13 +1040,98 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_shutdown);
 
+static int virtio_transport_dgram_send_pkt_info(struct vsock_sock *vsk,
+						struct virtio_vsock_pkt_info *info)
+{
+	u32 src_cid, src_port, dst_cid, dst_port;
+	const struct vsock_transport *transport;
+	const struct virtio_transport *t_ops;
+	struct sock *sk = sk_vsock(vsk);
+	struct virtio_vsock_hdr *hdr;
+	struct sk_buff *skb;
+	void *payload;
+	int noblock = 0;
+	int err;
+
+	info->type = virtio_transport_get_type(sk_vsock(vsk));
+
+	if (info->pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
+		return -EMSGSIZE;
+
+	transport = vsock_dgram_lookup_transport(info->remote_cid, info->remote_flags);
+	t_ops = container_of(transport, struct virtio_transport, transport);
+	if (unlikely(!t_ops))
+		return -EFAULT;
+
+	if (info->msg)
+		noblock = info->msg->msg_flags & MSG_DONTWAIT;
+
+	/* Use sock_alloc_send_skb to throttle by sk_sndbuf. This helps avoid
+	 * triggering the OOM.
+	 */
+	skb = sock_alloc_send_skb(sk, info->pkt_len + VIRTIO_VSOCK_SKB_HEADROOM,
+				  noblock, &err);
+	if (!skb)
+		return err;
+
+	skb_reserve(skb, VIRTIO_VSOCK_SKB_HEADROOM);
+
+	src_cid = t_ops->transport.get_local_cid();
+	src_port = vsk->local_addr.svm_port;
+	dst_cid = info->remote_cid;
+	dst_port = info->remote_port;
+
+	hdr = virtio_vsock_hdr(skb);
+	hdr->type	= cpu_to_le16(info->type);
+	hdr->op		= cpu_to_le16(info->op);
+	hdr->src_cid	= cpu_to_le64(src_cid);
+	hdr->dst_cid	= cpu_to_le64(dst_cid);
+	hdr->src_port	= cpu_to_le32(src_port);
+	hdr->dst_port	= cpu_to_le32(dst_port);
+	hdr->flags	= cpu_to_le32(info->flags);
+	hdr->len	= cpu_to_le32(info->pkt_len);
+
+	if (info->msg && info->pkt_len > 0) {
+		payload = skb_put(skb, info->pkt_len);
+		err = memcpy_from_msg(payload, info->msg, info->pkt_len);
+		if (err)
+			goto out;
+	}
+
+	trace_virtio_transport_alloc_pkt(src_cid, src_port,
+					 dst_cid, dst_port,
+					 info->pkt_len,
+					 info->type,
+					 info->op,
+					 info->flags,
+					 false);
+
+	return t_ops->send_pkt(skb);
+out:
+	kfree_skb(skb);
+	return err;
+}
+
 int
 virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
 			       struct sockaddr_vm *remote_addr,
 			       struct msghdr *msg,
 			       size_t dgram_len)
 {
-	return -EOPNOTSUPP;
+	/* Here we are only using the info struct to retain style uniformity
+	 * and to ease future refactoring and merging.
+	 */
+	struct virtio_vsock_pkt_info info = {
+		.op = VIRTIO_VSOCK_OP_RW,
+		.remote_cid = remote_addr->svm_cid,
+		.remote_port = remote_addr->svm_port,
+		.remote_flags = remote_addr->svm_flags,
+		.msg = msg,
+		.vsk = vsk,
+		.pkt_len = dgram_len,
+	};
+
+	return virtio_transport_dgram_send_pkt_info(vsk, &info);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
 
-- 
2.20.1


