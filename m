Return-Path: <kvm+bounces-50141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0AC6AE2130
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 624913BEB63
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2023E2ECE90;
	Fri, 20 Jun 2025 17:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dw+xUwQ7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BD62EA16F
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 17:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750441274; cv=none; b=U+poygwPK0+tYXFLLzbeHXeueW6lguQHNFBrbz0xV8pTysNOufeXbVBnzJ9rBeKWTcbGt7MRZJpF4Fz8GldA6sSjztdoFwuYv9CThb9TavL0oLnkxoSSvlNDoShgaUuMPJGJZvVsCWRw8Jim5K1sqqjkjVjas+QWJwEuiFajl40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750441274; c=relaxed/simple;
	bh=SJDjlfuM0A7XYSm6LGfFduKcEBSeNR5Bs3wA6zDz9F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3HOm8qGefUCJXbGJ61BBwCxImm9rj1sYfqykXXYB+GfzTTm7uYId8en+LlvzvnTqZBx7dDDE35JQjSBqiMTppo1iMMAeSiwypr5WryKwu4J7GZp6A58oxwnT3CzRQ5cjuHu6F9r13MB3oJEdBZFyxA+f+6YB6+alWXl5gEkxFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dw+xUwQ7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750441271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yG8Hj3YZMTjjoHZLrMKgOTeT+xpXQ9Y/wEboqt/fgqM=;
	b=dw+xUwQ7Xs3py2OX92WTf11k/xn0RK9kydQl9SEUl4OK7Y/tHS9XnRFnNA92/yAUW0Qxl6
	eVEQWdQD5sc3elZeZlsUDaj/r+YWVgjLvKvjFAfsiP2Y1T51LOjZ85LjVx7vncSpCWHzbS
	1Ausu8OCGjZiz1sS8Y6oZcCSw++WES0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-9grRvwCpMPeEwQdaZRZZbQ-1; Fri,
 20 Jun 2025 13:41:06 -0400
X-MC-Unique: 9grRvwCpMPeEwQdaZRZZbQ-1
X-Mimecast-MFC-AGG-ID: 9grRvwCpMPeEwQdaZRZZbQ_1750441264
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70BA418089B7;
	Fri, 20 Jun 2025 17:41:04 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.45.224.100])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E0EE419560AB;
	Fri, 20 Jun 2025 17:40:59 +0000 (UTC)
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
	kvm@vger.kernel.org
Subject: [PATCH v5 net-next 8/9] tun: enable gso over UDP tunnel support.
Date: Fri, 20 Jun 2025 19:39:52 +0200
Message-ID: <fda9402f6f5bf07e61b45803dca77c12d3291f1b.1750436464.git.pabeni@redhat.com>
In-Reply-To: <cover.1750436464.git.pabeni@redhat.com>
References: <cover.1750436464.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Add new tun features to represent the newly introduced virtio
GSO over UDP tunnel offload. Allows detection and selection of
such features via the existing TUNSETOFFLOAD ioctl and compute
the expected virtio header size and tunnel header offset using
the current netdev features, so that we can plug almost seamless
the newly introduced virtio helpers to serialize the extended
virtio header.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v4 -> v5:
  - encapsulate the guest feature guessing in a tun helper
  - dropped irrelevant check on xdp buff headroom
  - do not remove unrelated black line
  - avoid line len > 80 char

v3 -> v4:
  - virtio tnl-related fields are at fixed offset, cleanup
    the code accordingly.
  - use netdev features instead of flags bit to check for
    the configured offload
  - drop packet in case of enabled features/configured hdr
    size mismatch

v2 -> v3:
  - cleaned-up uAPI comments
  - use explicit struct layout instead of raw buf.
---
 drivers/net/tun.c           |  58 +++++++++++++++++----
 drivers/net/tun_vnet.h      | 101 ++++++++++++++++++++++++++++++++----
 include/uapi/linux/if_tun.h |   9 ++++
 3 files changed, 150 insertions(+), 18 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index f8c5e2fd04df..abc91f28dac4 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -186,7 +186,8 @@ struct tun_struct {
 	struct net_device	*dev;
 	netdev_features_t	set_features;
 #define TUN_USER_FEATURES (NETIF_F_HW_CSUM|NETIF_F_TSO_ECN|NETIF_F_TSO| \
-			  NETIF_F_TSO6 | NETIF_F_GSO_UDP_L4)
+			  NETIF_F_TSO6 | NETIF_F_GSO_UDP_L4 | \
+			  NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
 	int			align;
 	int			vnet_hdr_sz;
@@ -925,6 +926,7 @@ static int tun_net_init(struct net_device *dev)
 	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
 			   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
 			   NETIF_F_HW_VLAN_STAG_TX;
+	dev->hw_enc_features = dev->hw_features;
 	dev->features = dev->hw_features;
 	dev->vlan_features = dev->features &
 			     ~(NETIF_F_HW_VLAN_CTAG_TX |
@@ -1698,7 +1700,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	struct sk_buff *skb;
 	size_t total_len = iov_iter_count(from);
 	size_t len = total_len, align = tun->align, linear;
-	struct virtio_net_hdr gso = { 0 };
+	struct virtio_net_hdr_v1_hash_tunnel hdr;
+	struct virtio_net_hdr *gso;
 	int good_linear;
 	int copylen;
 	int hdr_len = 0;
@@ -1708,6 +1711,15 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	int skb_xdp = 1;
 	bool frags = tun_napi_frags_enabled(tfile);
 	enum skb_drop_reason drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
+	netdev_features_t features = 0;
+
+	/*
+	 * Keep it easy and always zero the whole buffer, even if the
+	 * tunnel-related field will be touched only when the feature
+	 * is enabled and the hdr size id compatible.
+	 */
+	memset(&hdr, 0, sizeof(hdr));
+	gso = (struct virtio_net_hdr *)&hdr;
 
 	if (!(tun->flags & IFF_NO_PI)) {
 		if (len < sizeof(pi))
@@ -1721,7 +1733,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	if (tun->flags & IFF_VNET_HDR) {
 		int vnet_hdr_sz = READ_ONCE(tun->vnet_hdr_sz);
 
-		hdr_len = tun_vnet_hdr_get(vnet_hdr_sz, tun->flags, from, &gso);
+		features = tun_vnet_hdr_guest_features(vnet_hdr_sz);
+		hdr_len = __tun_vnet_hdr_get(vnet_hdr_sz, tun->flags,
+					     features, from, gso);
 		if (hdr_len < 0)
 			return hdr_len;
 
@@ -1755,7 +1769,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		 * (e.g gso or jumbo packet), we will do it at after
 		 * skb was created with generic XDP routine.
 		 */
-		skb = tun_build_skb(tun, tfile, from, &gso, len, &skb_xdp);
+		skb = tun_build_skb(tun, tfile, from, gso, len, &skb_xdp);
 		err = PTR_ERR_OR_ZERO(skb);
 		if (err)
 			goto drop;
@@ -1799,7 +1813,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		}
 	}
 
-	if (tun_vnet_hdr_to_skb(tun->flags, skb, &gso)) {
+	if (tun_vnet_hdr_tnl_to_skb(tun->flags, features, skb, &hdr)) {
 		atomic_long_inc(&tun->rx_frame_errors);
 		err = -EINVAL;
 		goto free_skb;
@@ -2050,13 +2064,21 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 	}
 
 	if (vnet_hdr_sz) {
-		struct virtio_net_hdr gso;
+		struct virtio_net_hdr_v1_hash_tunnel hdr;
+		struct virtio_net_hdr *gso;
 
-		ret = tun_vnet_hdr_from_skb(tun->flags, tun->dev, skb, &gso);
+		ret = tun_vnet_hdr_tnl_from_skb(tun->flags, tun->dev, skb,
+						&hdr);
 		if (ret)
 			return ret;
 
-		ret = tun_vnet_hdr_put(vnet_hdr_sz, iter, &gso);
+		/*
+		 * Drop the packet if the configured header size is too small
+		 * WRT the enabled offloads.
+		 */
+		gso = (struct virtio_net_hdr *)&hdr;
+		ret = __tun_vnet_hdr_put(vnet_hdr_sz, tun->dev->features,
+					 iter, gso);
 		if (ret)
 			return ret;
 	}
@@ -2357,10 +2379,12 @@ static int tun_xdp_one(struct tun_struct *tun,
 {
 	unsigned int datasize = xdp->data_end - xdp->data;
 	struct tun_xdp_hdr *hdr = xdp->data_hard_start;
+	struct virtio_net_hdr_v1_hash_tunnel *tnl_hdr;
 	struct virtio_net_hdr *gso = &hdr->gso;
 	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb = NULL;
 	struct sk_buff_head *queue;
+	netdev_features_t features;
 	u32 rxhash = 0, act;
 	int buflen = hdr->buflen;
 	int metasize = 0;
@@ -2426,7 +2450,9 @@ static int tun_xdp_one(struct tun_struct *tun,
 	if (metasize > 0)
 		skb_metadata_set(skb, metasize);
 
-	if (tun_vnet_hdr_to_skb(tun->flags, skb, gso)) {
+	features = tun_vnet_hdr_guest_features(READ_ONCE(tun->vnet_hdr_sz));
+	tnl_hdr = (struct virtio_net_hdr_v1_hash_tunnel *)gso;
+	if (tun_vnet_hdr_tnl_to_skb(tun->flags, features, skb, tnl_hdr)) {
 		atomic_long_inc(&tun->rx_frame_errors);
 		kfree_skb(skb);
 		ret = -EINVAL;
@@ -2812,6 +2838,8 @@ static void tun_get_iff(struct tun_struct *tun, struct ifreq *ifr)
 
 }
 
+#define PLAIN_GSO (NETIF_F_GSO_UDP_L4 | NETIF_F_TSO | NETIF_F_TSO6)
+
 /* This is like a cut-down ethtool ops, except done via tun fd so no
  * privs required. */
 static int set_offload(struct tun_struct *tun, unsigned long arg)
@@ -2841,6 +2869,18 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
 			features |= NETIF_F_GSO_UDP_L4;
 			arg &= ~(TUN_F_USO4 | TUN_F_USO6);
 		}
+
+		/*
+		 * Tunnel offload is allowed only if some plain offload is
+		 * available, too.
+		 */
+		if (features & PLAIN_GSO && arg & TUN_F_UDP_TUNNEL_GSO) {
+			features |= NETIF_F_GSO_UDP_TUNNEL;
+			if (arg & TUN_F_UDP_TUNNEL_GSO_CSUM)
+				features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			arg &= ~(TUN_F_UDP_TUNNEL_GSO |
+				 TUN_F_UDP_TUNNEL_GSO_CSUM);
+		}
 	}
 
 	/* This gives the user a way to test for new features in future by
diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
index 58b9ac7a5fc4..81662328b2c7 100644
--- a/drivers/net/tun_vnet.h
+++ b/drivers/net/tun_vnet.h
@@ -6,6 +6,8 @@
 #define TUN_VNET_LE     0x80000000
 #define TUN_VNET_BE     0x40000000
 
+#define TUN_VNET_TNL_SIZE	sizeof(struct virtio_net_hdr_v1_hash_tunnel)
+
 static inline bool tun_vnet_legacy_is_little_endian(unsigned int flags)
 {
 	bool be = IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE) &&
@@ -107,16 +109,26 @@ static inline long tun_vnet_ioctl(int *vnet_hdr_sz, unsigned int *flags,
 	}
 }
 
-static inline int tun_vnet_hdr_get(int sz, unsigned int flags,
-				   struct iov_iter *from,
-				   struct virtio_net_hdr *hdr)
+static inline unsigned int tun_vnet_parse_size(netdev_features_t features)
+{
+	if (!(features & NETIF_F_GSO_UDP_TUNNEL))
+		return sizeof(struct virtio_net_hdr);
+
+	return TUN_VNET_TNL_SIZE;
+}
+
+static inline int __tun_vnet_hdr_get(int sz, unsigned int flags,
+				     netdev_features_t features,
+				     struct iov_iter *from,
+				     struct virtio_net_hdr *hdr)
 {
+	unsigned int parsed_size = tun_vnet_parse_size(features);
 	u16 hdr_len;
 
 	if (iov_iter_count(from) < sz)
 		return -EINVAL;
 
-	if (!copy_from_iter_full(hdr, sizeof(*hdr), from))
+	if (!copy_from_iter_full(hdr, parsed_size, from))
 		return -EFAULT;
 
 	hdr_len = tun_vnet16_to_cpu(flags, hdr->hdr_len);
@@ -129,32 +141,70 @@ static inline int tun_vnet_hdr_get(int sz, unsigned int flags,
 	if (hdr_len > iov_iter_count(from))
 		return -EINVAL;
 
-	iov_iter_advance(from, sz - sizeof(*hdr));
+	iov_iter_advance(from, sz - parsed_size);
 
 	return hdr_len;
 }
 
-static inline int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
-				   const struct virtio_net_hdr *hdr)
+static inline int tun_vnet_hdr_get(int sz, unsigned int flags,
+				   struct iov_iter *from,
+				   struct virtio_net_hdr *hdr)
+{
+	return __tun_vnet_hdr_get(sz, flags, 0, from, hdr);
+}
+
+static inline int __tun_vnet_hdr_put(int sz, netdev_features_t features,
+				     struct iov_iter *iter,
+				     const struct virtio_net_hdr *hdr)
 {
+	unsigned int parsed_size = tun_vnet_parse_size(features);
+
 	if (unlikely(iov_iter_count(iter) < sz))
 		return -EINVAL;
 
-	if (unlikely(copy_to_iter(hdr, sizeof(*hdr), iter) != sizeof(*hdr)))
+	if (unlikely(copy_to_iter(hdr, parsed_size, iter) != parsed_size))
 		return -EFAULT;
 
-	if (iov_iter_zero(sz - sizeof(*hdr), iter) != sz - sizeof(*hdr))
+	if (iov_iter_zero(sz - parsed_size, iter) != sz - parsed_size)
 		return -EFAULT;
 
 	return 0;
 }
 
+static inline int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
+				   const struct virtio_net_hdr *hdr)
+{
+	return __tun_vnet_hdr_put(sz, 0, iter, hdr);
+}
+
 static inline int tun_vnet_hdr_to_skb(unsigned int flags, struct sk_buff *skb,
 				      const struct virtio_net_hdr *hdr)
 {
 	return virtio_net_hdr_to_skb(skb, hdr, tun_vnet_is_little_endian(flags));
 }
 
+/*
+ * Tun is not aware of the negotiated guest features, guess them from the
+ * virtio net hdr size
+ */
+static inline netdev_features_t tun_vnet_hdr_guest_features(int vnet_hdr_sz)
+{
+	if (vnet_hdr_sz >= TUN_VNET_TNL_SIZE)
+		return NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	return 0;
+}
+
+static inline int
+tun_vnet_hdr_tnl_to_skb(unsigned int flags, netdev_features_t features,
+			struct sk_buff *skb,
+			const struct virtio_net_hdr_v1_hash_tunnel *hdr)
+{
+	return virtio_net_hdr_tnl_to_skb(skb, hdr,
+				features & NETIF_F_GSO_UDP_TUNNEL,
+				features & NETIF_F_GSO_UDP_TUNNEL_CSUM,
+				tun_vnet_is_little_endian(flags));
+}
+
 static inline int tun_vnet_hdr_from_skb(unsigned int flags,
 					const struct net_device *dev,
 					const struct sk_buff *skb,
@@ -183,4 +233,37 @@ static inline int tun_vnet_hdr_from_skb(unsigned int flags,
 	return 0;
 }
 
+static inline int
+tun_vnet_hdr_tnl_from_skb(unsigned int flags,
+			  const struct net_device *dev,
+			  const struct sk_buff *skb,
+			  struct virtio_net_hdr_v1_hash_tunnel *tnl_hdr)
+{
+	bool has_tnl_offload = !!(dev->features & NETIF_F_GSO_UDP_TUNNEL);
+	int vlan_hlen = skb_vlan_tag_present(skb) ? VLAN_HLEN : 0;
+
+	if (virtio_net_hdr_tnl_from_skb(skb, tnl_hdr, has_tnl_offload,
+					tun_vnet_is_little_endian(flags),
+					vlan_hlen)) {
+		struct virtio_net_hdr_v1 *hdr = &tnl_hdr->hash_hdr.hdr;
+		struct skb_shared_info *sinfo = skb_shinfo(skb);
+
+		if (net_ratelimit()) {
+			int hdr_len = tun_vnet16_to_cpu(flags, hdr->hdr_len);
+
+			netdev_err(dev, "unexpected GSO type: 0x%x, gso_size %d, hdr_len %d\n",
+				   sinfo->gso_type,
+				   tun_vnet16_to_cpu(flags, hdr->gso_size),
+				   tun_vnet16_to_cpu(flags, hdr->hdr_len));
+			print_hex_dump(KERN_ERR, "tun: ", DUMP_PREFIX_NONE,
+				       16, 1, skb->head, min(hdr_len, 64),
+				       true);
+		}
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 #endif /* TUN_VNET_H */
diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
index 287cdc81c939..79d53c7a1ebd 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -93,6 +93,15 @@
 #define TUN_F_USO4	0x20	/* I can handle USO for IPv4 packets */
 #define TUN_F_USO6	0x40	/* I can handle USO for IPv6 packets */
 
+/* I can handle TSO/USO for UDP tunneled packets */
+#define TUN_F_UDP_TUNNEL_GSO		0x080
+
+/*
+ * I can handle TSO/USO for UDP tunneled packets requiring csum offload for
+ * the outer header
+ */
+#define TUN_F_UDP_TUNNEL_GSO_CSUM	0x100
+
 /* Protocol info prepended to the packets (when IFF_NO_PI is not set) */
 #define TUN_PKT_STRIP	0x0001
 struct tun_pi {
-- 
2.49.0


