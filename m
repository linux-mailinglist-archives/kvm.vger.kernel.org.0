Return-Path: <kvm+bounces-51737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4281CAFC3B3
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 09:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92EDD4A25C4
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 07:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BD6A259CA4;
	Tue,  8 Jul 2025 07:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="htmqQwOG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A4125A2C2
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 07:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751958609; cv=none; b=NGf4/Xu1vDhFx+dKNibIea4X0MEI0EZlfAbkTDlTlm+a9z1ufMTSb2ecxKqQkSfmHbEJXSI+6ok72ngz8reBHiMscwsg2EJWeCYueP/AeDJA6ODPGGYLkPaqkbuUvVpwYhl9AYXj0yJS5uX5KpR//AQe4sHrn/93vBtwsmiftGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751958609; c=relaxed/simple;
	bh=uTimezLgkgQHYiY7qbQ84oY2egHFflhVIKm4yk/L+Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBmfDRarbujcmpYXCr17OllH2wEkwyHRjGFI53vNnNX4ajAL190amrBF0d6pQofzaYoBe+h7eIthAfL1kLx7DPCs/akbQ99fn52c29PcQt1ZfaPO06O9jQRwo6qoJHw44GKwhmoe9UtCuBCB1JYjqGn2E+qVZOoOyiZaJKdMaJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=htmqQwOG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751958606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NgZrOJBd6EpKlm/wmP9eH9d2Cl9vojXTFt5e3FtCOno=;
	b=htmqQwOG/mOwUmt/tOreX1PjOqM1UEzUCX/fwDe5xKjsVkAAZvVJ2sFrjCgAZswE7r42wg
	48EJtFOCjDhQXur+zlM7a0MzFqfEoWsbnrOG7rQuWbtfguKmEWZniLGOMXLZIyl5DFBTC5
	0jLs2DMYxn8Uh77qmPmybAawZU5H0e0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-Es3VW9K8P3CcmjxEvHdnlQ-1; Tue,
 08 Jul 2025 03:10:03 -0400
X-MC-Unique: Es3VW9K8P3CcmjxEvHdnlQ-1
X-Mimecast-MFC-AGG-ID: Es3VW9K8P3CcmjxEvHdnlQ_1751958602
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1307B195FCC4;
	Tue,  8 Jul 2025 07:10:02 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.32.252])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 37E8F195608F;
	Tue,  8 Jul 2025 07:09:56 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: netdev@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jonathan Corbet <corbet@lwn.net>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v7 net-next 7/9] virtio_net: enable gso over UDP tunnel support.
Date: Tue,  8 Jul 2025 09:09:03 +0200
Message-ID: <80b155dc1103c33b221a19739287e9a6b25b087b.1751874094.git.pabeni@redhat.com>
In-Reply-To: <cover.1751874094.git.pabeni@redhat.com>
References: <cover.1751874094.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

If the related virtio feature is set, enable transmission and reception
of gso over UDP tunnel packets.

Most of the work is done by the previously introduced helper, just need
to determine the UDP tunnel features inside the virtio_net_hdr and
update accordingly the virtio net hdr size.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v3 -> v4:
  - tnl header fields at constant offset, update the parsing accordingly
  - keep separate status for tnl offload tx and tnl offload rx
  - drop redundant comment

v2 -> v3:
  - drop the VIRTIO_HAS_EXTENDED_FEATURES conditionals

v1 -> v2:
  - test for UDP_TUNNEL_GSO* only on builds with extended features support
  - comment indentation cleanup
  - rebased on top of virtio helpers changes
  - dump more information in case of bad offloads
---
 drivers/net/virtio_net.c | 85 ++++++++++++++++++++++++++++++----------
 1 file changed, 64 insertions(+), 21 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 6f86a8edc981..b80b5c3db9a3 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -79,15 +79,19 @@ static const unsigned long guest_offloads[] = {
 	VIRTIO_NET_F_GUEST_CSUM,
 	VIRTIO_NET_F_GUEST_USO4,
 	VIRTIO_NET_F_GUEST_USO6,
-	VIRTIO_NET_F_GUEST_HDRLEN
+	VIRTIO_NET_F_GUEST_HDRLEN,
+	VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_MAPPED,
+	VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM_MAPPED,
 };
 
 #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
-				(1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
-				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
-				(1ULL << VIRTIO_NET_F_GUEST_UFO)  | \
-				(1ULL << VIRTIO_NET_F_GUEST_USO4) | \
-				(1ULL << VIRTIO_NET_F_GUEST_USO6))
+			(1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
+			(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
+			(1ULL << VIRTIO_NET_F_GUEST_UFO)  | \
+			(1ULL << VIRTIO_NET_F_GUEST_USO4) | \
+			(1ULL << VIRTIO_NET_F_GUEST_USO6) | \
+			(1ULL << VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_MAPPED) | \
+			(1ULL << VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM_MAPPED))
 
 struct virtnet_stat_desc {
 	char desc[ETH_GSTRING_LEN];
@@ -440,6 +444,13 @@ struct virtnet_info {
 	/* Work struct for delayed refilling if we run low on memory. */
 	struct delayed_work refill;
 
+	/* UDP tunnel support */
+	bool tx_tnl;
+
+	bool rx_tnl;
+
+	bool rx_tnl_csum;
+
 	/* Is delayed refill enabled? */
 	bool refill_enabled;
 
@@ -499,6 +510,7 @@ struct virtio_net_common_hdr {
 		struct virtio_net_hdr hdr;
 		struct virtio_net_hdr_mrg_rxbuf	mrg_hdr;
 		struct virtio_net_hdr_v1_hash hash_v1_hdr;
+		struct virtio_net_hdr_v1_hash_tunnel tnl_hdr;
 	};
 };
 
@@ -2555,14 +2567,21 @@ static void virtnet_receive_done(struct virtnet_info *vi, struct receive_queue *
 	if (dev->features & NETIF_F_RXHASH && vi->has_rss_hash_report)
 		virtio_skb_set_hash(&hdr->hash_v1_hdr, skb);
 
-	if (flags & VIRTIO_NET_HDR_F_DATA_VALID)
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	hdr->hdr.flags = flags;
+	if (virtio_net_handle_csum_offload(skb, &hdr->hdr, vi->rx_tnl_csum)) {
+		net_warn_ratelimited("%s: bad csum: flags: %x, gso_type: %x rx_tnl_csum %d\n",
+				     dev->name, hdr->hdr.flags,
+				     hdr->hdr.gso_type, vi->rx_tnl_csum);
+		goto frame_err;
+	}
 
-	if (virtio_net_hdr_to_skb(skb, &hdr->hdr,
-				  virtio_is_little_endian(vi->vdev))) {
-		net_warn_ratelimited("%s: bad gso: type: %u, size: %u\n",
+	if (virtio_net_hdr_tnl_to_skb(skb, &hdr->tnl_hdr, vi->rx_tnl,
+				      vi->rx_tnl_csum,
+				      virtio_is_little_endian(vi->vdev))) {
+		net_warn_ratelimited("%s: bad gso: type: %x, size: %u, flags %x tunnel %d tnl csum %d\n",
 				     dev->name, hdr->hdr.gso_type,
-				     hdr->hdr.gso_size);
+				     hdr->hdr.gso_size, hdr->hdr.flags,
+				     vi->rx_tnl, vi->rx_tnl_csum);
 		goto frame_err;
 	}
 
@@ -3274,9 +3293,9 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 
 static int xmit_skb(struct send_queue *sq, struct sk_buff *skb, bool orphan)
 {
-	struct virtio_net_hdr_mrg_rxbuf *hdr;
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 	struct virtnet_info *vi = sq->vq->vdev->priv;
+	struct virtio_net_hdr_v1_hash_tunnel *hdr;
 	int num_sg;
 	unsigned hdr_len = vi->hdr_len;
 	bool can_push;
@@ -3289,17 +3308,17 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb, bool orphan)
 	/* Even if we can, don't push here yet as this would skew
 	 * csum_start offset below. */
 	if (can_push)
-		hdr = (struct virtio_net_hdr_mrg_rxbuf *)(skb->data - hdr_len);
+		hdr = (struct virtio_net_hdr_v1_hash_tunnel *)(skb->data -
+							       hdr_len);
 	else
-		hdr = &skb_vnet_common_hdr(skb)->mrg_hdr;
+		hdr = &skb_vnet_common_hdr(skb)->tnl_hdr;
 
-	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
-				    virtio_is_little_endian(vi->vdev), false,
-				    0))
+	if (virtio_net_hdr_tnl_from_skb(skb, hdr, vi->tx_tnl,
+					virtio_is_little_endian(vi->vdev), 0))
 		return -EPROTO;
 
 	if (vi->mergeable_rx_bufs)
-		hdr->num_buffers = 0;
+		hdr->hash_hdr.hdr.num_buffers = 0;
 
 	sg_init_table(sq->sg, skb_shinfo(skb)->nr_frags + (can_push ? 1 : 2));
 	if (can_push) {
@@ -6794,10 +6813,20 @@ static int virtnet_probe(struct virtio_device *vdev)
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_USO))
 			dev->hw_features |= NETIF_F_GSO_UDP_L4;
 
+		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO)) {
+			dev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
+			dev->hw_enc_features = dev->hw_features;
+		}
+		if (dev->hw_features & NETIF_F_GSO_UDP_TUNNEL &&
+		    virtio_has_feature(vdev, VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO_CSUM)) {
+			dev->hw_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			dev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		}
+
 		dev->features |= NETIF_F_GSO_ROBUST;
 
 		if (gso)
-			dev->features |= dev->hw_features & NETIF_F_ALL_TSO;
+			dev->features |= dev->hw_features;
 		/* (!csum && gso) case will be fixed by register_netdev() */
 	}
 
@@ -6890,7 +6919,10 @@ static int virtnet_probe(struct virtio_device *vdev)
 		dev->xdp_metadata_ops = &virtnet_xdp_metadata_ops;
 	}
 
-	if (vi->has_rss_hash_report)
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO) ||
+	    virtio_has_feature(vdev, VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO))
+		vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash_tunnel);
+	else if (vi->has_rss_hash_report)
 		vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
 	else if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
 		 virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
@@ -6898,6 +6930,13 @@ static int virtnet_probe(struct virtio_device *vdev)
 	else
 		vi->hdr_len = sizeof(struct virtio_net_hdr);
 
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM))
+		vi->rx_tnl_csum = true;
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO))
+		vi->rx_tnl = true;
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO))
+		vi->tx_tnl = true;
+
 	if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
 	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
 		vi->any_header_sg = true;
@@ -7208,6 +7247,10 @@ static struct virtio_device_id id_table[] = {
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
+	VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO,
+	VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM,
+	VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO,
+	VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO_CSUM,
 };
 
 static unsigned int features_legacy[] = {
-- 
2.49.0


