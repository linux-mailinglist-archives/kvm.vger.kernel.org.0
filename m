Return-Path: <kvm+bounces-50506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D97AE6809
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 16:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93F1D19240F8
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 14:13:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506232D877C;
	Tue, 24 Jun 2025 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KkHkvp/q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4EF2D1F55
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 14:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750774270; cv=none; b=McCHxqC3OxNOlLRZWjWMieB4Tmlo9QlNdsxeUXziQuh+ELVxLuE2tSw+9XCI7C0pP3ccQbIutb9qK0vtHIhjlbWZiDOryIUGWJbfBp9mgIYn7wBnUzELfOEf3physQ1eI73yduHszeBJ+a6BCNCgrqabQfwTrVVh7suWZbSoibI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750774270; c=relaxed/simple;
	bh=yjo5ZgKSI9YUA4XmQ9bO5kvOkT+lnDu4vza552t8sOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/Jhlj+BWuM8VegDKdR+dZNWOXSkCgkEptB5Gmx6bWMZKle3c41U5QSvmobpB3ShnXeLlI2DaQAgLA96jd6WWVpNueKXqNasBib1YzR8U3/7UxZK+349EpYXtbYLzKVUkZsM1Ppmq6nVj93hfzkcbHPxRmLXEvGFeo4rdC6oqck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KkHkvp/q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750774267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U6TBdGj3bz+hKJCbr0lqugD2lRkAjw0/lN7tmB4McQI=;
	b=KkHkvp/qHnsMuD+MssaSDI/qG0qWvzOvpD3voxxAFvMjD7AWAt511i92kxFWFSfIVqjjYJ
	CiTknf7N746PzJTrnsyB+8MagsbyhVSv/llT3t6yu1O0j35sLkN41JELIyRCqzcfAqmrfC
	Sk1CrBOI6D45Yp7aVT/vybJRjYqDgYs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-IpaMEUWyMRefTutlppR_lw-1; Tue,
 24 Jun 2025 10:11:04 -0400
X-MC-Unique: IpaMEUWyMRefTutlppR_lw-1
X-Mimecast-MFC-AGG-ID: IpaMEUWyMRefTutlppR_lw_1750774262
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 066B719560BE;
	Tue, 24 Jun 2025 14:11:02 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.45.224.193])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF479195608D;
	Tue, 24 Jun 2025 14:10:56 +0000 (UTC)
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
Subject: [PATCH v6 net-next 6/9] net: implement virtio helpers to handle UDP GSO tunneling.
Date: Tue, 24 Jun 2025 16:09:48 +0200
Message-ID: <93f38f81471be31f7feeb9960614a6afeded9c80.1750753211.git.pabeni@redhat.com>
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

The virtio specification are introducing support for GSO over UDP
tunnel.

This patch brings in the needed defines and the additional virtio hdr
parsing/building helpers.

The UDP tunnel support uses additional fields in the virtio hdr, and such
fields location can change depending on other negotiated features -
specifically VIRTIO_NET_F_HASH_REPORT.

Try to be as conservative as possible with the new field validation.

Existing implementation for plain GSO offloads allow for invalid/
self-contradictory values of such fields. With GSO over UDP tunnel we can
be more strict, with no need to deal with legacy implementation.

Since the checksum-related field validation is asymmetric in the driver
and in the device, introduce a separate helper to implement the new checks
(to be used only on the driver side).

Note that while the feature space exceeds the 64-bit boundaries, the
guest offload space is fixed by the specification of the
VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET command to a 64-bit size.

Prior to the UDP tunnel GSO support, each guest offload bit corresponded
to the feature bit with the same value and vice versa.

Due to the limited 'guest offload' space, relevant features in the high
64 bits are 'mapped' to free bits in the lower range. That is simpler
than defining a new command (and associated features) to exchange an
extended guest offloads set.

As a consequence, the uAPIs also specify the mapped guest offload value
corresponding to the UDP tunnel GSO features.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
--
v4 -> v5:
  - avoid lines above 80 chars

v3 -> v4:
  - fixed offset for UDP GSO tunnel, update accordingly the helpers
  - tried to clarified vlan_hlen semantic
  - virtio_net_chk_data_valid() -> virtio_net_handle_csum_offload()

v2 -> v3:
  - add definitions for possible vnet hdr layouts with tunnel support

v1 -> v2:
  - 'relay' -> 'rely' typo
  - less unclear comment WRT enforced inner GSO checks
  - inner header fields are allowed only with 'modern' virtio,
    thus are always le
  - clarified in the commit message the need for 'mapped features'
    defines
  - assume little_endian is true when UDP GSO is enabled.
  - fix inner proto type value
---
 include/linux/virtio_net.h      | 197 ++++++++++++++++++++++++++++++--
 include/uapi/linux/virtio_net.h |  33 ++++++
 2 files changed, 222 insertions(+), 8 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 02a9f4dc594d..20e0584db1dd 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -47,9 +47,9 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
 	return 0;
 }
 
-static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
-					const struct virtio_net_hdr *hdr,
-					bool little_endian)
+static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
+					  const struct virtio_net_hdr *hdr,
+					  bool little_endian, u8 hdr_gso_type)
 {
 	unsigned int nh_min_len = sizeof(struct iphdr);
 	unsigned int gso_type = 0;
@@ -57,8 +57,8 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 	unsigned int p_off = 0;
 	unsigned int ip_proto;
 
-	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
-		switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
+	if (hdr_gso_type != VIRTIO_NET_HDR_GSO_NONE) {
+		switch (hdr_gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
 		case VIRTIO_NET_HDR_GSO_TCPV4:
 			gso_type = SKB_GSO_TCPV4;
 			ip_proto = IPPROTO_TCP;
@@ -84,7 +84,7 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 			return -EINVAL;
 		}
 
-		if (hdr->gso_type & VIRTIO_NET_HDR_GSO_ECN)
+		if (hdr_gso_type & VIRTIO_NET_HDR_GSO_ECN)
 			gso_type |= SKB_GSO_TCP_ECN;
 
 		if (hdr->gso_size == 0)
@@ -122,7 +122,8 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 
 				if (!protocol)
 					virtio_net_hdr_set_proto(skb, hdr);
-				else if (!virtio_net_hdr_match_proto(protocol, hdr->gso_type))
+				else if (!virtio_net_hdr_match_proto(protocol,
+								 hdr_gso_type))
 					return -EINVAL;
 				else
 					skb->protocol = protocol;
@@ -153,7 +154,7 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 		}
 	}
 
-	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
+	if (hdr_gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		u16 gso_size = __virtio16_to_cpu(little_endian, hdr->gso_size);
 		unsigned int nh_off = p_off;
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
@@ -199,6 +200,13 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 	return 0;
 }
 
+static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
+					const struct virtio_net_hdr *hdr,
+					bool little_endian)
+{
+	return __virtio_net_hdr_to_skb(skb, hdr, little_endian, hdr->gso_type);
+}
+
 static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
 					  struct virtio_net_hdr *hdr,
 					  bool little_endian,
@@ -242,4 +250,177 @@ static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
 	return 0;
 }
 
+static inline unsigned int virtio_l3min(bool is_ipv6)
+{
+	return is_ipv6 ? sizeof(struct ipv6hdr) : sizeof(struct iphdr);
+}
+
+static inline int
+virtio_net_hdr_tnl_to_skb(struct sk_buff *skb,
+			  const struct virtio_net_hdr_v1_hash_tunnel *vhdr,
+			  bool tnl_hdr_negotiated,
+			  bool tnl_csum_negotiated,
+			  bool little_endian)
+{
+	const struct virtio_net_hdr *hdr = (const struct virtio_net_hdr *)vhdr;
+	unsigned int inner_nh, outer_th, inner_th;
+	unsigned int inner_l3min, outer_l3min;
+	u8 gso_inner_type, gso_tunnel_type;
+	bool outer_isv6, inner_isv6;
+	int ret;
+
+	gso_tunnel_type = hdr->gso_type & VIRTIO_NET_HDR_GSO_UDP_TUNNEL;
+	if (!gso_tunnel_type)
+		return virtio_net_hdr_to_skb(skb, hdr, little_endian);
+
+	/* Tunnel not supported/negotiated, but the hdr asks for it. */
+	if (!tnl_hdr_negotiated)
+		return -EINVAL;
+
+	/* Either ipv4 or ipv6. */
+	if (gso_tunnel_type == VIRTIO_NET_HDR_GSO_UDP_TUNNEL)
+		return -EINVAL;
+
+	/* The UDP tunnel must carry a GSO packet, but no UFO. */
+	gso_inner_type = hdr->gso_type & ~(VIRTIO_NET_HDR_GSO_ECN |
+					   VIRTIO_NET_HDR_GSO_UDP_TUNNEL);
+	if (!gso_inner_type || gso_inner_type == VIRTIO_NET_HDR_GSO_UDP)
+		return -EINVAL;
+
+	/* Rely on csum being present. */
+	if (!(hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM))
+		return -EINVAL;
+
+	/* Validate offsets. */
+	outer_isv6 = gso_tunnel_type & VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6;
+	inner_isv6 = gso_inner_type == VIRTIO_NET_HDR_GSO_TCPV6;
+	inner_l3min = virtio_l3min(inner_isv6);
+	outer_l3min = ETH_HLEN + virtio_l3min(outer_isv6);
+
+	inner_th = __virtio16_to_cpu(little_endian, hdr->csum_start);
+	inner_nh = le16_to_cpu(vhdr->inner_nh_offset);
+	outer_th = le16_to_cpu(vhdr->outer_th_offset);
+	if (outer_th < outer_l3min ||
+	    inner_nh < outer_th + sizeof(struct udphdr) ||
+	    inner_th < inner_nh + inner_l3min)
+		return -EINVAL;
+
+	/* Let the basic parsing deal with plain GSO features. */
+	ret = __virtio_net_hdr_to_skb(skb, hdr, true,
+				      hdr->gso_type & ~gso_tunnel_type);
+	if (ret)
+		return ret;
+
+	/* In case of USO, the inner protocol is still unknown and
+	 * `inner_isv6` is just a guess, additional parsing is needed.
+	 * The previous validation ensures that accessing an ipv4 inner
+	 * network header is safe.
+	 */
+	if (gso_inner_type == VIRTIO_NET_HDR_GSO_UDP_L4) {
+		struct iphdr *iphdr = (struct iphdr *)(skb->data + inner_nh);
+
+		inner_isv6 = iphdr->version == 6;
+		inner_l3min = virtio_l3min(inner_isv6);
+		if (inner_th < inner_nh + inner_l3min)
+			return -EINVAL;
+	}
+
+	skb_set_inner_protocol(skb, inner_isv6 ? htons(ETH_P_IPV6) :
+						 htons(ETH_P_IP));
+	if (hdr->flags & VIRTIO_NET_HDR_F_UDP_TUNNEL_CSUM) {
+		if (!tnl_csum_negotiated)
+			return -EINVAL;
+
+		skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_TUNNEL_CSUM;
+	} else {
+		skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_TUNNEL;
+	}
+
+	skb->inner_transport_header = inner_th + skb_headroom(skb);
+	skb->inner_network_header = inner_nh + skb_headroom(skb);
+	skb->inner_mac_header = inner_nh + skb_headroom(skb);
+	skb->transport_header = outer_th + skb_headroom(skb);
+	skb->encapsulation = 1;
+	return 0;
+}
+
+/* Checksum-related fields validation for the driver */
+static inline int virtio_net_handle_csum_offload(struct sk_buff *skb,
+						 struct virtio_net_hdr *hdr,
+						 bool tnl_csum_negotiated)
+{
+	if (!(hdr->gso_type & VIRTIO_NET_HDR_GSO_UDP_TUNNEL)) {
+		if (!(hdr->flags & VIRTIO_NET_HDR_F_DATA_VALID))
+			return 0;
+
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		if (!(hdr->flags & VIRTIO_NET_HDR_F_UDP_TUNNEL_CSUM))
+			return 0;
+
+		/* tunnel csum packets are invalid when the related
+		 * feature has not been negotiated
+		 */
+		if (!tnl_csum_negotiated)
+			return -EINVAL;
+		skb->csum_level = 1;
+		return 0;
+	}
+
+	/* DATA_VALID is mutually exclusive with NEEDS_CSUM, and GSO
+	 * over UDP tunnel requires the latter
+	 */
+	if (hdr->flags & VIRTIO_NET_HDR_F_DATA_VALID)
+		return -EINVAL;
+	return 0;
+}
+
+/*
+ * vlan_hlen always refers to the outermost MAC header. That also
+ * means it refers to the only MAC header, if the packet does not carry
+ * any encapsulation.
+ */
+static inline int
+virtio_net_hdr_tnl_from_skb(const struct sk_buff *skb,
+			    struct virtio_net_hdr_v1_hash_tunnel *vhdr,
+			    bool tnl_hdr_negotiated,
+			    bool little_endian,
+			    int vlan_hlen)
+{
+	struct virtio_net_hdr *hdr = (struct virtio_net_hdr *)vhdr;
+	unsigned int inner_nh, outer_th;
+	int tnl_gso_type;
+	int ret;
+
+	tnl_gso_type = skb_shinfo(skb)->gso_type & (SKB_GSO_UDP_TUNNEL |
+						    SKB_GSO_UDP_TUNNEL_CSUM);
+	if (!tnl_gso_type)
+		return virtio_net_hdr_from_skb(skb, hdr, little_endian, false,
+					       vlan_hlen);
+
+	/* Tunnel support not negotiated but skb ask for it. */
+	if (!tnl_hdr_negotiated)
+		return -EINVAL;
+
+	/* Let the basic parsing deal with plain GSO features. */
+	skb_shinfo(skb)->gso_type &= ~tnl_gso_type;
+	ret = virtio_net_hdr_from_skb(skb, hdr, true, false, vlan_hlen);
+	skb_shinfo(skb)->gso_type |= tnl_gso_type;
+	if (ret)
+		return ret;
+
+	if (skb->protocol == htons(ETH_P_IPV6))
+		hdr->gso_type |= VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6;
+	else
+		hdr->gso_type |= VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV4;
+
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM)
+		hdr->flags |= VIRTIO_NET_HDR_F_UDP_TUNNEL_CSUM;
+
+	inner_nh = skb->inner_network_header - skb_headroom(skb);
+	outer_th = skb->transport_header - skb_headroom(skb);
+	vhdr->inner_nh_offset = cpu_to_le16(inner_nh);
+	vhdr->outer_th_offset = cpu_to_le16(outer_th);
+	return 0;
+}
+
 #endif /* _LINUX_VIRTIO_NET_H */
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 963540deae66..8bf27ab8bcb4 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -70,6 +70,28 @@
 					 * with the same MAC.
 					 */
 #define VIRTIO_NET_F_SPEED_DUPLEX 63	/* Device set linkspeed and duplex */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO 65 /* Driver can receive
+					      * GSO-over-UDP-tunnel packets
+					      */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM 66 /* Driver handles
+						   * GSO-over-UDP-tunnel
+						   * packets with partial csum
+						   * for the outer header
+						   */
+#define VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO 67 /* Device can receive
+					     * GSO-over-UDP-tunnel packets
+					     */
+#define VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO_CSUM 68 /* Device handles
+						  * GSO-over-UDP-tunnel
+						  * packets with partial csum
+						  * for the outer header
+						  */
+
+/* Offloads bits corresponding to VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO{,_CSUM}
+ * features
+ */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_MAPPED	46
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM_MAPPED	47
 
 #ifndef VIRTIO_NET_NO_LEGACY
 #define VIRTIO_NET_F_GSO	6	/* Host handles pkts w/ any GSO type */
@@ -131,12 +153,17 @@ struct virtio_net_hdr_v1 {
 #define VIRTIO_NET_HDR_F_NEEDS_CSUM	1	/* Use csum_start, csum_offset */
 #define VIRTIO_NET_HDR_F_DATA_VALID	2	/* Csum is valid */
 #define VIRTIO_NET_HDR_F_RSC_INFO	4	/* rsc info in csum_ fields */
+#define VIRTIO_NET_HDR_F_UDP_TUNNEL_CSUM 8	/* UDP tunnel csum offload */
 	__u8 flags;
 #define VIRTIO_NET_HDR_GSO_NONE		0	/* Not a GSO frame */
 #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
 #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
 #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
 #define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4& IPv6 UDP (USO) */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV4 0x20 /* UDPv4 tunnel present */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6 0x40 /* UDPv6 tunnel present */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL (VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV4 | \
+				       VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6)
 #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
 	__u8 gso_type;
 	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
@@ -181,6 +208,12 @@ struct virtio_net_hdr_v1_hash {
 	__le16 padding;
 };
 
+struct virtio_net_hdr_v1_hash_tunnel {
+	struct virtio_net_hdr_v1_hash hash_hdr;
+	__le16 outer_th_offset;
+	__le16 inner_nh_offset;
+};
+
 #ifndef VIRTIO_NET_NO_LEGACY
 /* This header comes first in the scatter-gather list.
  * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it must
-- 
2.49.0


