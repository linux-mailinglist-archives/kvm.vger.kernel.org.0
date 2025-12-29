Return-Path: <kvm+bounces-66764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6C97CE61CC
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 08:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EBAE3301A1AA
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 07:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA33D2F747A;
	Mon, 29 Dec 2025 07:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W1QNX1i6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2291946C8
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 07:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766992594; cv=none; b=cT6uaWH7QK01x2jvKfZqlfC8YYgoA4M6fDGqi4Smpo5/vRNUZi+3qA9KRhEe0Y3LGzujPlxiv06DAj19yJ56nsBKzSEUCoz2SdyjMy4HwqY7p73Ygiqqv5DbsTu9BOz1sCk5yvT/BBL9dMnoReWhWV8bHcv+dbSi3SjBvgbOXKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766992594; c=relaxed/simple;
	bh=fovCxHKinPlYQmGBoBFLS2Lg1H3LC5svMw7wJgQNg1I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DckfxQV/x4V1X/Mra3ytvbl+I4gOWqAr9wGvaqQLK6Uamecx5DnSZAvMn3ZXYiX0QomeByS0Rw5wcX03jJjtsfINQA0XhWsiCZs8Ce+7E04VM9gwghlANYG45Zf8v5Mft4XjW/VREtzXb9V5NcRlhTbv0+/X6Zr+BnFSbPcZSTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W1QNX1i6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766992589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oBkCZ73/jRMKywd1XjShm9N+vlFYblQSCQfCRzxfrnI=;
	b=W1QNX1i6y4LpR6zC9y/0XL9X/J+MJU1REc6SGXFlPU8NGVgarbJv5/MDNvxqPP4n4lt4oF
	rmnGyiF1l4rJsIjah/YLBTIEG7M51r1xk2OwxxrkU/DrD3ptDHFSKr30Xbd9DMN8caUM9t
	1tqPfpcHMiP1b2bbVA4iZ9vG6UMT/mI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-a6vJ3YSeMRq8qtXUZ3Sdzg-1; Mon,
 29 Dec 2025 02:16:27 -0500
X-MC-Unique: a6vJ3YSeMRq8qtXUZ3Sdzg-1
X-Mimecast-MFC-AGG-ID: a6vJ3YSeMRq8qtXUZ3Sdzg_1766992586
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51ADA1956058;
	Mon, 29 Dec 2025 07:16:26 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A9AB819560A7;
	Mon, 29 Dec 2025 07:16:22 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	dtatulea@nvidia.com,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v2 2/3] vdpa/mlx5: reuse common function for MAC address updates
Date: Mon, 29 Dec 2025 15:16:13 +0800
Message-ID: <20251229071614.779621-2-lulu@redhat.com>
In-Reply-To: <20251229071614.779621-1-lulu@redhat.com>
References: <20251229071614.779621-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Factor out MAC address update logic and reuse it from handle_ctrl_mac().

This ensures that old MAC entries are removed from the MPFS table
before adding a new one and that the forwarding rules are updated
accordingly. If updating the flow table fails, the original MAC and
rules are restored as much as possible to keep the software and
hardware state consistent.

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 95 +++++++++++++++++--------------
 1 file changed, 53 insertions(+), 42 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 6e42bae7c9a1..c87e6395b060 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2125,62 +2125,48 @@ static void teardown_steering(struct mlx5_vdpa_net *ndev)
 	mlx5_destroy_flow_table(ndev->rxft);
 }
 
-static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
+static int mlx5_vdpa_change_new_mac(struct mlx5_vdpa_net *ndev,
+				    struct mlx5_core_dev *pfmdev,
+				    const u8 *new_mac)
 {
-	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
-	struct mlx5_control_vq *cvq = &mvdev->cvq;
-	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
-	struct mlx5_core_dev *pfmdev;
-	size_t read;
-	u8 mac[ETH_ALEN], mac_back[ETH_ALEN];
-
-	pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
-	switch (cmd) {
-	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
-		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov, (void *)mac, ETH_ALEN);
-		if (read != ETH_ALEN)
-			break;
-
-		if (!memcmp(ndev->config.mac, mac, 6)) {
-			status = VIRTIO_NET_OK;
-			break;
-		}
+	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
+	u8 old_mac[ETH_ALEN];
 
-		if (is_zero_ether_addr(mac))
-			break;
+	if (is_zero_ether_addr(new_mac))
+		return -EINVAL;
 
-		if (!is_zero_ether_addr(ndev->config.mac)) {
-			if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) {
-				mlx5_vdpa_warn(mvdev, "failed to delete old MAC %pM from MPFS table\n",
-					       ndev->config.mac);
-				break;
-			}
+	if (!is_zero_ether_addr(ndev->config.mac)) {
+		if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) {
+			mlx5_vdpa_warn(mvdev, "failed to delete old MAC %pM from MPFS table\n",
+				       ndev->config.mac);
+			return -EIO;
 		}
+	}
 
-		if (mlx5_mpfs_add_mac(pfmdev, mac)) {
-			mlx5_vdpa_warn(mvdev, "failed to insert new MAC %pM into MPFS table\n",
-				       mac);
-			break;
-		}
+	if (mlx5_mpfs_add_mac(pfmdev, (u8 *)new_mac)) {
+		mlx5_vdpa_warn(mvdev, "failed to insert new MAC %pM into MPFS table\n",
+			       new_mac);
+		return -EIO;
+	}
 
 		/* backup the original mac address so that if failed to add the forward rules
 		 * we could restore it
 		 */
-		memcpy(mac_back, ndev->config.mac, ETH_ALEN);
+		memcpy(old_mac, ndev->config.mac, ETH_ALEN);
 
-		memcpy(ndev->config.mac, mac, ETH_ALEN);
+		memcpy(ndev->config.mac, new_mac, ETH_ALEN);
 
 		/* Need recreate the flow table entry, so that the packet could forward back
 		 */
-		mac_vlan_del(ndev, mac_back, 0, false);
+		mac_vlan_del(ndev, old_mac, 0, false);
 
 		if (mac_vlan_add(ndev, ndev->config.mac, 0, false)) {
 			mlx5_vdpa_warn(mvdev, "failed to insert forward rules, try to restore\n");
 
 			/* Although it hardly run here, we still need double check */
-			if (is_zero_ether_addr(mac_back)) {
+			if (is_zero_ether_addr(old_mac)) {
 				mlx5_vdpa_warn(mvdev, "restore mac failed: Original MAC is zero\n");
-				break;
+				return -EIO;
 			}
 
 			/* Try to restore original mac address to MFPS table, and try to restore
@@ -2191,20 +2177,45 @@ static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
 					       ndev->config.mac);
 			}
 
-			if (mlx5_mpfs_add_mac(pfmdev, mac_back)) {
+			if (mlx5_mpfs_add_mac(pfmdev, old_mac)) {
 				mlx5_vdpa_warn(mvdev, "restore mac failed: insert old MAC %pM into MPFS table failed\n",
-					       mac_back);
+					       old_mac);
 			}
 
-			memcpy(ndev->config.mac, mac_back, ETH_ALEN);
+			memcpy(ndev->config.mac, old_mac, ETH_ALEN);
 
 			if (mac_vlan_add(ndev, ndev->config.mac, 0, false))
 				mlx5_vdpa_warn(mvdev, "restore forward rules failed: insert forward rules failed\n");
 
-			break;
+			return -EIO;
 		}
 
-		status = VIRTIO_NET_OK;
+		return 0;
+}
+
+static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
+{
+	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
+	struct mlx5_control_vq *cvq = &mvdev->cvq;
+	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
+	struct mlx5_core_dev *pfmdev;
+	size_t read;
+	u8 mac[ETH_ALEN];
+
+	pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
+	switch (cmd) {
+	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
+		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov,
+					     (void *)mac, ETH_ALEN);
+		if (read != ETH_ALEN)
+			break;
+
+		if (!memcmp(ndev->config.mac, mac, 6)) {
+			status = VIRTIO_NET_OK;
+			break;
+		}
+		status = mlx5_vdpa_change_new_mac(ndev, pfmdev, mac) ? VIRTIO_NET_ERR :
+								       VIRTIO_NET_OK;
 		break;
 
 	default:
-- 
2.45.0


