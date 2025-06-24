Return-Path: <kvm+bounces-50507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4719DAE680F
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 16:16:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39DE41C206A6
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 14:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75C6B2D3A94;
	Tue, 24 Jun 2025 14:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PHJMwF8K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9082D3A91
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 14:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750774276; cv=none; b=AwQ0ZA+ruKbPRbBKjUt7C3u5Q7nEtHlH6sqX83QDofqHue+uS2aBTurZ6bf7/Sb50mzPHv3wIEMbJl3WNAooUZZfi1ZCcCtiSVZJNV33IVEXIxmwcELapHNuqezn+niYMe1YYVM+ZPl0f6YQX/4YOftWwasl50TPkBSJrXsK0ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750774276; c=relaxed/simple;
	bh=SFT1vVIOXxVY8tkQN+dOElowfANFUnUkVlLdLRNxvYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWmKCbX+qMVYjjlKb+dwKsD9bByoxrW7j03t1B7xp799VgtoyTUcwEXdz0K9eDJnL6SUq9z0MlTa7jZWaY7UBcCw3UabR57XCMTnJqyaJnY5xctmO6hym5/8BtBF0gO1haAMyt9ZsahAaYp1sW0gOwQFvUVyAkLUnF5LfGhXdaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PHJMwF8K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750774273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=//+gd3wI/cQ4/bKBv9RYxEaNpSQw45ZjNQJ7prPE0Gc=;
	b=PHJMwF8KeQLynVOH2nisQksUw6/yGN/iDjOCcNwYDeTfC+2EcDq6f3XH8jyBgi8rbzVFHM
	ZgJIuSkGrLfZgGyuTmPFfW0a+fVJdX2c/kpRKqWo//vW+DbxwOUdrT2CbZ9fN3/PKH59hm
	NOZSaCNuvyH7PsrCht2qrCDApg3ATG8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-xaee4lh_NDWIbrlHWTiukw-1; Tue,
 24 Jun 2025 10:11:09 -0400
X-MC-Unique: xaee4lh_NDWIbrlHWTiukw-1
X-Mimecast-MFC-AGG-ID: xaee4lh_NDWIbrlHWTiukw_1750774267
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90FF4180029F;
	Tue, 24 Jun 2025 14:11:07 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.45.224.193])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 84FA6195608F;
	Tue, 24 Jun 2025 14:11:02 +0000 (UTC)
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
Subject: [PATCH v6 net-next 7/9] virtio_net: enable gso over UDP tunnel support.
Date: Tue, 24 Jun 2025 16:09:49 +0200
Message-ID: <f4dfdf02c3254c0e77ba89c90310fb7696c6f1e7.1750753211.git.pabeni@redhat.com>
In-Reply-To: <cover.1750753211.git.pabeni@redhat.com>
References: <cover.1750753211.git.pabeni@redhat.com>
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
index ad73863324e8..68bf35dae31a 100644
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
 
@@ -2532,14 +2544,21 @@ static void virtnet_receive_done(struct virtnet_info *vi, struct receive_queue *
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
 
@@ -3251,9 +3270,9 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 
 static int xmit_skb(struct send_queue *sq, struct sk_buff *skb, bool orphan)
 {
-	struct virtio_net_hdr_mrg_rxbuf *hdr;
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 	struct virtnet_info *vi = sq->vq->vdev->priv;
+	struct virtio_net_hdr_v1_hash_tunnel *hdr;
 	int num_sg;
 	unsigned hdr_len = vi->hdr_len;
 	bool can_push;
@@ -3266,17 +3285,17 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb, bool orphan)
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
@@ -6765,10 +6784,20 @@ static int virtnet_probe(struct virtio_device *vdev)
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
 
@@ -6861,7 +6890,10 @@ static int virtnet_probe(struct virtio_device *vdev)
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
@@ -6869,6 +6901,13 @@ static int virtnet_probe(struct virtio_device *vdev)
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
@@ -7179,6 +7218,10 @@ static struct virtio_device_id id_table[] = {
 
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


