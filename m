Return-Path: <kvm+bounces-49247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 893A4AD6AE3
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:33:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8472C7A8BFC
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E454022172E;
	Thu, 12 Jun 2025 08:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TIwv4eYP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811DE1B043E
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 08:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749717151; cv=none; b=COD/XAoqnL8eC+N5SmIKyquj1qP3Q+DaWfvgi+gaO0wnmJaG4V3EIrzaX2Nsdz1sPEcKz84XpSmumXMXp552Sv6cKeYx+iaQKiLm1fKPO3s6Ggq8mELbzf4ViqWkIRsB5LTvuaeX1ABadHkBuRBqwqlwaDUoTytlzOz+4y6NRMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749717151; c=relaxed/simple;
	bh=0H65YCBltM3mzM7cKC6Wde80q9ECLX3BrCRHdl1gq/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tqZfzgWkGDW7UgO/a+B4weKTg0MliZogzDGhwZFJdc/qxLJH5mkJjcTGzeFRYi3k9715eFUi1EmII2XyamvNPu3/g9zi/mYFy+c+UEm//+yBZRByr7W/GJlj0ZfzskoyDeTIXx4jTvXJQG2SP9UfhXcNtxDVkwat7V3r94CPKZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TIwv4eYP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749717148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YgJVMs0RGxMwkZXnXqV6sqGHx/KtJsdRvyJMHrklXlk=;
	b=TIwv4eYPZbNHjpVHtM3W9Z8Na/h4BArET0uddRAO0HDOxoCOmRps3gWjXGueHSYsXwiFtV
	6l9uxvNf4HadY0C+tSLiZTukbtDplzrx1ZSnFkiML/lUy812Qc4ckjQGsmSeUzFNFqz0JL
	9KSMTAfpzD4N6lQz1tKYHJz1PGw2IJM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-3KqVGTcKP0mvvuQ604UXJA-1; Thu,
 12 Jun 2025 04:32:25 -0400
X-MC-Unique: 3KqVGTcKP0mvvuQ604UXJA-1
X-Mimecast-MFC-AGG-ID: 3KqVGTcKP0mvvuQ604UXJA_1749717144
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE4CC19560AD;
	Thu, 12 Jun 2025 08:32:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.165])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0518C19560A3;
	Thu, 12 Jun 2025 08:32:17 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com,
	jasowang@redhat.com
Cc: eperezma@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	willemdebruijn.kernel@gmail.com,
	davem@davemloft.net,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Subject: [PATCH net-next 1/2] tun: remove unnecessary tun_xdp_hdr structure
Date: Thu, 12 Jun 2025 16:32:12 +0800
Message-ID: <20250612083213.2704-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

With f95f0f95cfb7("net, xdp: Introduce xdp_init_buff utility routine"),
buffer length could be stored as frame size so there's no need to have
a dedicated tun_xdp_hdr structure. We can simply store virtio net
header instead.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/tap.c      | 5 ++---
 drivers/net/tun.c      | 5 ++---
 drivers/vhost/net.c    | 8 ++------
 include/linux/if_tun.h | 5 -----
 4 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index bdf0788d8e66..d82eb7276a8b 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1044,9 +1044,8 @@ static const struct file_operations tap_fops = {
 
 static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 {
-	struct tun_xdp_hdr *hdr = xdp->data_hard_start;
-	struct virtio_net_hdr *gso = &hdr->gso;
-	int buflen = hdr->buflen;
+	struct virtio_net_hdr *gso = xdp->data_hard_start;
+	int buflen = xdp->frame_sz;
 	int vnet_hdr_len = 0;
 	struct tap_dev *tap;
 	struct sk_buff *skb;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 1207196cbbed..90055947a54b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2356,13 +2356,12 @@ static int tun_xdp_one(struct tun_struct *tun,
 		       struct tun_page *tpage)
 {
 	unsigned int datasize = xdp->data_end - xdp->data;
-	struct tun_xdp_hdr *hdr = xdp->data_hard_start;
-	struct virtio_net_hdr *gso = &hdr->gso;
+	struct virtio_net_hdr *gso = xdp->data_hard_start;
 	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb = NULL;
 	struct sk_buff_head *queue;
 	u32 rxhash = 0, act;
-	int buflen = hdr->buflen;
+	int buflen = xdp->frame_sz;
 	int metasize = 0;
 	int ret = 0;
 	bool skb_xdp = false;
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7cbfc7d718b3..777eb6193985 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -668,7 +668,6 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 	struct socket *sock = vhost_vq_get_backend(vq);
 	struct virtio_net_hdr *gso;
 	struct xdp_buff *xdp = &nvq->xdp[nvq->batched_xdp];
-	struct tun_xdp_hdr *hdr;
 	size_t len = iov_iter_count(from);
 	int headroom = vhost_sock_xdp(sock) ? XDP_PACKET_HEADROOM : 0;
 	int buflen = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
@@ -691,15 +690,13 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 	if (unlikely(!buf))
 		return -ENOMEM;
 
-	copied = copy_from_iter(buf + offsetof(struct tun_xdp_hdr, gso),
-				sock_hlen, from);
+	copied = copy_from_iter(buf, sock_hlen, from);
 	if (copied != sock_hlen) {
 		ret = -EFAULT;
 		goto err;
 	}
 
-	hdr = buf;
-	gso = &hdr->gso;
+	gso = buf;
 
 	if (!sock_hlen)
 		memset(buf, 0, pad);
@@ -727,7 +724,6 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 
 	xdp_init_buff(xdp, buflen, NULL);
 	xdp_prepare_buff(xdp, buf, pad, len, true);
-	hdr->buflen = buflen;
 
 	++nvq->batched_xdp;
 
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 043d442994b0..80166eb62f41 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -19,11 +19,6 @@ struct tun_msg_ctl {
 	void *ptr;
 };
 
-struct tun_xdp_hdr {
-	int buflen;
-	struct virtio_net_hdr gso;
-};
-
 #if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
 struct socket *tun_get_socket(struct file *);
 struct ptr_ring *tun_get_tx_ring(struct file *file);
-- 
2.34.1


