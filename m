Return-Path: <kvm+bounces-50505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35930AE67FD
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 16:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AAA43B8B25
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 14:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 366AC2D6618;
	Tue, 24 Jun 2025 14:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cmPCGijN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDFC2D1913
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750774264; cv=none; b=F/Xj25dfoITkeGzRytDgHuyk7pty5fTYSbee/TOW549NhupQUsxLYW180xGhMzFHq0ReuUhadvN6UbvPbQOTGuuLRA7qb9/thVbIt9+E40YgQiH4VV5buvhSP/FaOgOZRKRMXjICvPZoSCQ0dOLcVTMW7e1rK7RrFLMwMjQORqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750774264; c=relaxed/simple;
	bh=YCNJ+z+ni7T9i5/PDxBYW+kpkiPpzWbbdHUYmgSRMa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRaA618G8PtC6EBueP93Ce3Xqnp3HGSZoo30KoL5FI66Le4Qtv8ou6+/ZUwuNPwq/WV31zpslf6MIaVxCfGfvP3KGzj9+MWw6j2R5WnD1au3Qw5yVW+0a2MKVYivWibBqBvi3BsgALSg/CV1eMly9t/XIO2cbGWYKk/n+teJ0Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cmPCGijN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750774261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A/zQttmcnExROycHPtcExuAs5MgShwE2WW9I76fIuPY=;
	b=cmPCGijNBN3cnmJfxAeEc8pcLEXbFsS9A7BJq5tV2PHfYH6Ewunzf3IzhGP6zMZ7QlSa95
	7uMOXS75QjGEGA55EtsZgRh3arclyYJ6WWfXBss/rXNSpcBUYPzxc01Dai7tiN2JgXEfnm
	xsZDEzRuqvx35v2xkRGL/EDthyKkr3o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-451-EQMhH3rkOOKX1EdQclrdYQ-1; Tue,
 24 Jun 2025 10:10:57 -0400
X-MC-Unique: EQMhH3rkOOKX1EdQclrdYQ-1
X-Mimecast-MFC-AGG-ID: EQMhH3rkOOKX1EdQclrdYQ_1750774255
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DE3A1956095;
	Tue, 24 Jun 2025 14:10:55 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.45.224.193])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 92397195608F;
	Tue, 24 Jun 2025 14:10:48 +0000 (UTC)
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
Subject: [PATCH v6 net-next 5/9] virtio_net: add supports for extended offloads
Date: Tue, 24 Jun 2025 16:09:47 +0200
Message-ID: <09cfc4bb359ade9d5f432362a18e773e88a24b94.1750753211.git.pabeni@redhat.com>
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

The virtio_net driver needs it to implement GSO over UDP tunnel
offload.

The only missing piece is mapping them to/from the extended
features.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v4 -> v5:
 - avoid lines longer than 80 chars

v2 -> v3:
 - offload to feature conversion is now an inline function

v1 -> v2:
 - drop unused macro
 - restrict the offload remap range as per latest spec update
---
 drivers/net/virtio_net.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 07e41dce4203..ad73863324e8 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -35,6 +35,23 @@ module_param(csum, bool, 0444);
 module_param(gso, bool, 0444);
 module_param(napi_tx, bool, 0644);
 
+#define VIRTIO_OFFLOAD_MAP_MIN	46
+#define VIRTIO_OFFLOAD_MAP_MAX	47
+#define VIRTIO_FEATURES_MAP_MIN	65
+#define VIRTIO_O2F_DELTA	(VIRTIO_FEATURES_MAP_MIN - \
+				 VIRTIO_OFFLOAD_MAP_MIN)
+
+static bool virtio_is_mapped_offload(unsigned int obit)
+{
+	return obit >= VIRTIO_OFFLOAD_MAP_MIN &&
+	       obit <= VIRTIO_OFFLOAD_MAP_MAX;
+}
+
+static unsigned int virtio_offload_to_feature(unsigned int obit)
+{
+	return virtio_is_mapped_offload(obit) ? obit + VIRTIO_O2F_DELTA : obit;
+}
+
 /* FIXME: MTU in config. */
 #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
 #define GOOD_COPY_LEN	128
@@ -7026,9 +7043,13 @@ static int virtnet_probe(struct virtio_device *vdev)
 		netif_carrier_on(dev);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(guest_offloads); i++)
-		if (virtio_has_feature(vi->vdev, guest_offloads[i]))
+	for (i = 0; i < ARRAY_SIZE(guest_offloads); i++) {
+		unsigned int fbit;
+
+		fbit = virtio_offload_to_feature(guest_offloads[i]);
+		if (virtio_has_feature(vi->vdev, fbit))
 			set_bit(guest_offloads[i], &vi->guest_offloads);
+	}
 	vi->guest_offloads_capable = vi->guest_offloads;
 
 	rtnl_unlock();
-- 
2.49.0


