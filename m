Return-Path: <kvm+bounces-50138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D85EAE2128
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:41:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79E457A6DEF
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D64C2EBDE1;
	Fri, 20 Jun 2025 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c8u+nX+m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2DD2E9ECB
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 17:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750441257; cv=none; b=UfLg8Ry/BjsXWF9cvNg99O6MpAKcLXx/KJgHsEjMYHyVCfYd/xVDM6tAD/wqUbvSZHQF//epQYd2oyZ/7wxdwUeuNM+bbg0wLlJxIgfhe0feO1x1OM/HKIvZ7iJp3n9XdobjsEGKvIZOTa4vWM5DssrOf3hzg9+rEn6e+/g4dc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750441257; c=relaxed/simple;
	bh=YCNJ+z+ni7T9i5/PDxBYW+kpkiPpzWbbdHUYmgSRMa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwxPw1RDIW1ScUD2ZBZnhK9HYBA6rEMrSDkDej4KYBNhM0iz/amIj/ChUA1sb9sgyKwZKIXXfSeb2a25bgyYtgorn1mEt2VGiiNB5V/rUOZ41FbSZGcyqq6hVT/fOvzFtdTrwjjNqlP3xtK4iIOkUJOZQ8/KjNOUs5nDuRFfJnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c8u+nX+m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750441255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A/zQttmcnExROycHPtcExuAs5MgShwE2WW9I76fIuPY=;
	b=c8u+nX+mNA2wou5m1Fnzvi3xG3z8oOl6+K1R2Pf0jyk1BQHNHhdJR14dj/5Vhr3eGj7sEw
	aW99yMIqvpHt4y0/HIooAmSNqOWtTMJvpdhtzTX4RFcyN0UFP1+t/krb1Ffyc85lfYI9Pw
	S/GKc+phklA+suNK5EDzoByvW2JTiLo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-504-5dHErv5HNtK5-fKfYXfjOQ-1; Fri,
 20 Jun 2025 13:40:51 -0400
X-MC-Unique: 5dHErv5HNtK5-fKfYXfjOQ-1
X-Mimecast-MFC-AGG-ID: 5dHErv5HNtK5-fKfYXfjOQ_1750441249
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30FA618011CD;
	Fri, 20 Jun 2025 17:40:49 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.45.224.100])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AE19819560AB;
	Fri, 20 Jun 2025 17:40:44 +0000 (UTC)
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
Subject: [PATCH v5 net-next 5/9] virtio_net: add supports for extended offloads
Date: Fri, 20 Jun 2025 19:39:49 +0200
Message-ID: <c29578fde4f18aca5e1aa1e56b000518cb51a092.1750436464.git.pabeni@redhat.com>
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


