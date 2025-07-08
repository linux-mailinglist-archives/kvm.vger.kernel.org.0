Return-Path: <kvm+bounces-51735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5459BAFC3AC
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 09:10:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6554425546
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 07:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830BE261574;
	Tue,  8 Jul 2025 07:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SlyG9QQ3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE0125A2B5
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 07:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751958597; cv=none; b=SLEOXawfvbrO+3fBzfdc8EKHmr5mSJ5C1TanSc6Ox25ohyipxTILPEoFTAJ4CVCLLcujWKxBPqhdyDAe8pnfAUYJhIPWC71Vz0F/iIEb2JEfrLtP1/Mw/+0OskoDhUdV4THgB+1G8eefwTt9aXbGs40nUpAeN8lb75Zd35VXU4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751958597; c=relaxed/simple;
	bh=RfiVbzd4N84I4zYTlWrLhkzX3qnBzcKJsoMC0Ta6iqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+RD3VzK7P6ZGe1/0O4fGxMR+OI6RFhl+EUpGSjmqbzFWHz9kxun1eDYkFK/lUho1C4oMAwDGJfDTEgypwNSn2PfKKg6OEs4fYzVP814okxU/llFGf2iISlOuPxldW9xJ+6TuTRzBVnbsfOYWG+ySAPiDnusDfrLM760rx5ByDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SlyG9QQ3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751958595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ME3Sp0L5kybzZSCfVybZkMKTEWiUzAhs5CYz2hx18n8=;
	b=SlyG9QQ36gjkb8peuHKt9f4H/Z8IU0T28Eoj2MakmShRXk+S2+Rj0rWMHmEfxivU4lxqIh
	ftDCs3ns3Q95oTE5wPNGor/HlNWI98GHJ4gRBKp7A5fleO49CjtM/77kMTzDZNONyfsvEI
	ovm5JAhHJub085ywyo3gzol/qOppV7o=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-_mxu0o7NM2uZOoLjVxyWBg-1; Tue,
 08 Jul 2025 03:09:53 -0400
X-MC-Unique: _mxu0o7NM2uZOoLjVxyWBg-1
X-Mimecast-MFC-AGG-ID: _mxu0o7NM2uZOoLjVxyWBg_1751958591
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DAD7180A8FF;
	Tue,  8 Jul 2025 07:09:51 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.32.252])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 233D1195608F;
	Tue,  8 Jul 2025 07:09:45 +0000 (UTC)
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
Subject: [PATCH v7 net-next 5/9] virtio_net: add supports for extended offloads
Date: Tue,  8 Jul 2025 09:09:01 +0200
Message-ID: <82a5589e753192a82c69d74ec32938e385a44680.1751874094.git.pabeni@redhat.com>
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
index 9f6e0153ed2d..6f86a8edc981 100644
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
@@ -7055,9 +7072,13 @@ static int virtnet_probe(struct virtio_device *vdev)
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


