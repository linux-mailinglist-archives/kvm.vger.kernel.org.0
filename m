Return-Path: <kvm+bounces-50142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB128AE2133
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:43:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0887B5A3FBB
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B762ECEAE;
	Fri, 20 Jun 2025 17:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TgfljBqb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABED92ECEA7
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 17:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750441278; cv=none; b=FA8Vl3dqV6aLeK1+mOnV6AYyIgvObGbT+MIEIfcsApddn2zPvbUE6/P05C+pF8Th2yFkDTlj7KGIoj0+etjCpDTHPx3lBHGuFdunimZKBU31+skiJrpDRjMA6dH4InHP6heH2Lh8D65w9HduLWLAi3ZECvHxrxy/KzGk8BQSsTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750441278; c=relaxed/simple;
	bh=kttYjMRPYV49sOXotk56RdZJe+uTd0CgV3R7yEfA08Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQRXAePM6gTqbof9A6yI03Ewa18N0jnu2mP2t5Wwoh9VImxQmTnzftvpzQbjxSIVKKMWZQiTqDboPUMoh+6qzEXFVgtLZBNkjH40XCDfo1eYyFvYS6mQ/ROwgbQau10p10OAL9AYhHxlm6AXRYC48XpUhKBYFLBxOtEXtev8hRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TgfljBqb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750441274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bNsVnKOUkAk624ypyssuNumMLSZZZvRHKL59itVJeEc=;
	b=TgfljBqbw/wSzZZhEiymHHo2wzsoPOBu9x7+nNqvrh9N14C01sTtvhdp+aCCvZyzKYqCxL
	3QhDXJfr0BBPlxI1JAVN50974c/7KyLC+Np4Lm7oB6Rl5sAGQmtA2zZ9h0HcuVcwqLvuM4
	yI2maoFDgh+Sh0fnRuGgrVOA8AhCC/E=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-HIvpj2VmPpuxavsLFkRB6A-1; Fri,
 20 Jun 2025 13:41:11 -0400
X-MC-Unique: HIvpj2VmPpuxavsLFkRB6A-1
X-Mimecast-MFC-AGG-ID: HIvpj2VmPpuxavsLFkRB6A_1750441269
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6767A180136B;
	Fri, 20 Jun 2025 17:41:09 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.45.224.100])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F26B419560AB;
	Fri, 20 Jun 2025 17:41:04 +0000 (UTC)
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
Subject: [PATCH v5 net-next 9/9] vhost/net: enable gso over UDP tunnel support.
Date: Fri, 20 Jun 2025 19:39:53 +0200
Message-ID: <f0f6ebd89251d343e5fe0f1884c3207115ba9a2d.1750436464.git.pabeni@redhat.com>
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

Vhost net need to know the exact virtio net hdr size to be able
to copy such header correctly. Teach it about the newly defined
UDP tunnel-related option and update the hdr size computation
accordingly.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v3 -> v4:
  - rebased
---
 drivers/vhost/net.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b7dd50aa1ba3..3d99da3381ce 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -75,6 +75,8 @@ static const u64 vhost_net_features[VIRTIO_FEATURES_DWORDS] = {
 	(1ULL << VIRTIO_NET_F_MRG_RXBUF) |
 	(1ULL << VIRTIO_F_ACCESS_PLATFORM) |
 	(1ULL << VIRTIO_F_RING_RESET),
+	VIRTIO_BIT(VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO) |
+	VIRTIO_BIT(VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO),
 };
 
 enum {
@@ -1624,6 +1626,12 @@ static int vhost_net_set_features(struct vhost_net *n, const u64 *features)
 		  sizeof(struct virtio_net_hdr_mrg_rxbuf) :
 		  sizeof(struct virtio_net_hdr);
 
+	if (virtio_features_test_bit(features,
+				     VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO) ||
+	    virtio_features_test_bit(features,
+				     VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO))
+		hdr_len = sizeof(struct virtio_net_hdr_v1_hash_tunnel);
+
 	if (virtio_features_test_bit(features, VHOST_NET_F_VIRTIO_NET_HDR)) {
 		/* vhost provides vnet_hdr */
 		vhost_hlen = hdr_len;
-- 
2.49.0


