Return-Path: <kvm+bounces-52856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB7AEB09B1B
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 08:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24CA95877FF
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C85E1F0E55;
	Fri, 18 Jul 2025 06:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fJwpnpFA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B2D1DE2C9
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 06:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752818814; cv=none; b=YLstXUQJ9WBPjbnF8OdVggY0/I/FBDni/fDIYx/GdUkeZT+gg+w35zo4Bt3oiArRkKSRaF2/7kJys1I4Zd5yj0aguhDeffyckz8zGysMlbV4mo6lEHaIVwjXJT7atAYljs/Ku/lm3SLbcoXM+PsSZPXk/2mzKPCa3DRfTbxNA/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752818814; c=relaxed/simple;
	bh=AoH2pIUWrD5MbUepOmIQK6BEXrzdiV0jm/OvN5qurII=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=BVDlmLkj8M7eBumSImYSM5c0itqHyOZ0jLEBJ5Yp1jE+fUNTg4skPmu05nRhJk/0jmnIGKlfadoPaB2BPPmcQ9WLhgA8Gz66QaSfjkPFe9Zb8IoL8Ljiq/a/yPNkgkFJhjM5Ikyj67Yx2V/9Z1N1b6/j+bfG26HT1i1AwE077NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fJwpnpFA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752818811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2I8jDNCG0L+52nyGGUbEIAwL2BkN8wDU3xL1GQ5jtVg=;
	b=fJwpnpFAGkpyUOgjTWuLsBbrygFgEIV8QNvSiy8FSk5rN55oivGLRzQS7oiTOlco+0DAW4
	fXLPt+mvil90fDDnYsCCN1z8cBMY9FB3Ld+xDbxquNB8g1BNFk/jTVkR2LTjrKaLegNSW8
	n/S3KUA15JDwhN+LUPVfWlgfp3Ijf8k=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-PuYEbrd0MPGTriYeRTD4gQ-1; Fri,
 18 Jul 2025 02:06:48 -0400
X-MC-Unique: PuYEbrd0MPGTriYeRTD4gQ-1
X-Mimecast-MFC-AGG-ID: PuYEbrd0MPGTriYeRTD4gQ_1752818806
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A614819560B3;
	Fri, 18 Jul 2025 06:06:45 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.34])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7B5D4180045B;
	Fri, 18 Jul 2025 06:06:37 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	"Xin Li (Intel)" <xin@zytor.com>,
	Rik van Riel <riel@surriel.com>,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	kvm@vger.kernel.org (open list:KVM PARAVIRT (KVM/paravirt)),
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	lulu@redhat.com
Subject: [PATCH] netvsc: transfer lower device max tso size
Date: Fri, 18 Jul 2025 14:06:15 +0800
Message-ID: <20250718060615.237986-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Jason Wang <jasowang@redhat.com>

When netvsc is accelerated by the lower device, we can advertise the
lower device max tso size in order to get better performance.

One example is that when 802.3ad encap is enabled by netvsc, it has a
lower max tso size than 64K. This will lead to software segmentation
of forwarding GSO packet (e.g the one from VM/tap).

This patch help to recover the performance.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Tested-by: Cindy Lu <lulu@redhat.com>
---
 drivers/net/hyperv/netvsc_drv.c |  2 +-
 include/linux/netdevice.h       |  4 ++++
 net/core/dev.c                  | 18 ++++++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index c41a025c66f0..7af4aa4f4abe 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2440,7 +2440,7 @@ static int netvsc_vf_changed(struct net_device *vf_netdev, unsigned long event)
 		 * switched over to the VF
 		 */
 		if (vf_is_up)
-			netif_set_tso_max_size(ndev, vf_netdev->tso_max_size);
+			netif_stacked_transfer_tso_max_size(vf_netdev, ndev);
 		else
 			netif_set_tso_max_size(ndev, netvsc_dev->netvsc_gso_max_size);
 	}
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index adb14db25798..c695a3ffecd8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5275,6 +5275,9 @@ void netdev_change_features(struct net_device *dev);
 void netif_stacked_transfer_operstate(const struct net_device *rootdev,
 					struct net_device *dev);
 
+void netif_stacked_transfer_tso_max_size(const struct net_device *rootdev,
+					 struct net_device *dev);
+
 netdev_features_t passthru_features_check(struct sk_buff *skb,
 					  struct net_device *dev,
 					  netdev_features_t features);
@@ -5326,6 +5329,7 @@ static inline bool netif_needs_gso(struct sk_buff *skb,
 }
 
 void netif_set_tso_max_size(struct net_device *dev, unsigned int size);
+
 void netif_set_tso_max_segs(struct net_device *dev, unsigned int segs);
 void netif_inherit_tso_max(struct net_device *to,
 			   const struct net_device *from);
diff --git a/net/core/dev.c b/net/core/dev.c
index be97c440ecd5..3bec4284adff 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3306,6 +3306,24 @@ void netif_set_tso_max_size(struct net_device *dev, unsigned int size)
 }
 EXPORT_SYMBOL(netif_set_tso_max_size);
 
+/**
+ *	netif_stacked_transfer_tso_max_size - transfer tso max size
+ *	@rootdev: the root or lower level device to transfer tso max size from
+ *	@dev: the device to transfer operstate to
+ *
+ *	Transfer tso max size from root to device. This is normally
+ *	called when a stacking relationship exists between the root
+ *	device and the device(a leaf device).
+ */
+void netif_stacked_transfer_tso_max_size(const struct net_device *rootdev,
+					 struct net_device *dev)
+{
+	dev->tso_max_size = rootdev->tso_max_size;
+	netif_set_gso_max_size(dev, READ_ONCE(rootdev->gso_max_size));
+	netif_set_gso_ipv4_max_size(dev, READ_ONCE(rootdev->gso_ipv4_max_size));
+}
+EXPORT_SYMBOL(netif_stacked_transfer_tso_max_size);
+
 /**
  * netif_set_tso_max_segs() - set the max number of segs supported for TSO
  * @dev:	netdev to update
-- 
2.45.0


