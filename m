Return-Path: <kvm+bounces-51132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98511AEEBBE
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 03:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 870E01894FB0
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 01:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D471946AA;
	Tue,  1 Jul 2025 01:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qwl+kYap"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C15570810
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 01:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751331851; cv=none; b=s+1WjJQw2c3d/NHYrR+OBFdRTBaXPktKaGYbrIPZ84EKf+pZFB0u+x91+RnJyGuBqbyx3bFrGj7CWmC2R/7blrzCC2m5K2pm3NYSIjslGzd+KY3ziEeQl0ZOVnF60xwCE9hm/8RwmWjQ9EMwDZJYQvlDl3SsiSOFoJKEIaNut94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751331851; c=relaxed/simple;
	bh=6iYqwF9X96MHxRdDZpSpOo/+4Mc6oLjjuGizrHod4WA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qOWur3O4gvj69SxycovT/POrWtJtkaskIK1nZOuK4V58HFg03zfDiK1jyWINmkTVnP8kVf0VusNzPQFTX7IttwaOsS3c20mb51+ewIPKgsb3y3YJyXGmfq8QYZfEak/jBkX9Kv1UK7K4fh/tza4Pyrj6KKn8F5ZF+SrY+4u4xkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qwl+kYap; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751331849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/2NKQ3CqFIITeYZPqoYmcZLIRzlMcydotc+VS4n7FN8=;
	b=Qwl+kYapoQRWl21EUCT3QRpdGRJ+TijHbPi3b9Arcjf0L94t48QilL4VFKhjKPO5JBYspn
	8S0k1idD21QXIWOJYoEJdsToddMNlf2GN9cmYc8XQY65SF94id/lyDpq8b72JVujx1C0gX
	Rwk3dnlgRgDaQ8HvS09mYThjelhyY7A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-uI15N1NzOK2UOC32b9Rq9g-1; Mon,
 30 Jun 2025 21:04:05 -0400
X-MC-Unique: uI15N1NzOK2UOC32b9Rq9g-1
X-Mimecast-MFC-AGG-ID: uI15N1NzOK2UOC32b9Rq9g_1751331843
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30811180120B;
	Tue,  1 Jul 2025 01:04:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.134])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 01655180045B;
	Tue,  1 Jul 2025 01:03:55 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: willemdebruijn.kernel@gmail.com,
	jasowang@redhat.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	mst@redhat.com,
	eperezma@redhat.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next V3 1/2] tun: remove unnecessary tun_xdp_hdr structure
Date: Tue,  1 Jul 2025 09:03:51 +0800
Message-ID: <20250701010352.74515-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

With f95f0f95cfb7("net, xdp: Introduce xdp_init_buff utility routine"),
buffer length could be stored as frame size so there's no need to have
a dedicated tun_xdp_hdr structure. We can simply store virtio net
header instead.

Acked-by: Willem de Bruijn <willemb@google.com>
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
index f8c5e2fd04df..447c37959504 100644
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


