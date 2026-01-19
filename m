Return-Path: <kvm+bounces-68466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 56720D39E18
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 06:57:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A7CAC304EF6A
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 05:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ECE8261B6D;
	Mon, 19 Jan 2026 05:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GnahQO3f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115F2238D54
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 05:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768802112; cv=none; b=p2xQOtZ1fq61FIII8HcSd+EDXooedLMdi9wK3gemMbBPJyqckrgvX5zUjhu8Qfx2ODMySQFv+h6FmZ2rs0czO5yQmLCnjrdqtxLkvO4e+fTLmqXgyjpS11qUhR5Su1B+1s3XlWDmMqhMwyoMzs6vohj88pWDgjykgap7Pxv2H5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768802112; c=relaxed/simple;
	bh=WRJITVGmCxqYkve8Ho+yyw32OTu+B5XDN14mxbcFRZQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiyR6Iw017ziOJuyK1Qcc4oMv9bz/iC5yBCnXmldnGUgBhLQsEQkbJghF/6nO3nK3nzOupQCvb/bO4U2BmqiNFjZjdafMwVnc0CZW0u4AHJ9J8rZsQ5Ex3lZCeoyFY8frrsPkKdLijeDVbLqlin0TC2GetFHtc5oWyyItID21JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GnahQO3f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768802109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YN+HSo6dS+cli6sGxFT1HAy73Kuoi+/ndOD7w6p0q/0=;
	b=GnahQO3fHWNCm6j/P+/6PCeXmwE09smH2qpiX3gKdAw4rRN0189zvgzCvcF3eb9abcfGrC
	EjaRatc2KhiW22KnnJihQVOvdHSTDOXoq8aSZgMu89CGQ2oIrYrq/vWJFWI1OkmGHAR1MT
	rATyLOZhuPn4pFP+sfGuwq1GtJgmRWE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-163-UpKBv2hfPhCmJTbS206JQw-1; Mon,
 19 Jan 2026 00:55:04 -0500
X-MC-Unique: UpKBv2hfPhCmJTbS206JQw-1
X-Mimecast-MFC-AGG-ID: UpKBv2hfPhCmJTbS206JQw_1768802103
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 848E8180045C;
	Mon, 19 Jan 2026 05:55:03 +0000 (UTC)
Received: from S2.redhat.com (unknown [10.72.112.143])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D7FDC19560A7;
	Mon, 19 Jan 2026 05:54:59 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	dtatulea@nvidia.com,
	mst@redhat.com,
	jasowang@redhat.com,
	netdev@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v3 2/3] vdpa/mlx5: reuse common function for MAC address updates
Date: Mon, 19 Jan 2026 13:53:52 +0800
Message-ID: <20260119055447.229772-3-lulu@redhat.com>
In-Reply-To: <20260119055447.229772-1-lulu@redhat.com>
References: <20260119055447.229772-1-lulu@redhat.com>
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

Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 131 ++++++++++++++++--------------
 1 file changed, 71 insertions(+), 60 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 6e42bae7c9a1..7a39843de243 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2125,86 +2125,97 @@ static void teardown_steering(struct mlx5_vdpa_net *ndev)
 	mlx5_destroy_flow_table(ndev->rxft);
 }
 
-static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
+static int mlx5_vdpa_change_mac(struct mlx5_vdpa_net *ndev,
+				struct mlx5_core_dev *pfmdev,
+				const u8 *new_mac)
 {
-	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
-	struct mlx5_control_vq *cvq = &mvdev->cvq;
-	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
-	struct mlx5_core_dev *pfmdev;
-	size_t read;
-	u8 mac[ETH_ALEN], mac_back[ETH_ALEN];
+	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
+	u8 old_mac[ETH_ALEN];
 
-	pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
-	switch (cmd) {
-	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
-		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov, (void *)mac, ETH_ALEN);
-		if (read != ETH_ALEN)
-			break;
+	if (is_zero_ether_addr(new_mac))
+		return -EINVAL;
 
-		if (!memcmp(ndev->config.mac, mac, 6)) {
-			status = VIRTIO_NET_OK;
-			break;
+	if (!is_zero_ether_addr(ndev->config.mac)) {
+		if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) {
+			mlx5_vdpa_warn(mvdev, "failed to delete old MAC %pM from MPFS table\n",
+				       ndev->config.mac);
+			return -EIO;
 		}
+	}
 
-		if (is_zero_ether_addr(mac))
-			break;
+	if (mlx5_mpfs_add_mac(pfmdev, (u8 *)new_mac)) {
+		mlx5_vdpa_warn(mvdev, "failed to insert new MAC %pM into MPFS table\n",
+			       new_mac);
+		return -EIO;
+	}
 
-		if (!is_zero_ether_addr(ndev->config.mac)) {
-			if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) {
-				mlx5_vdpa_warn(mvdev, "failed to delete old MAC %pM from MPFS table\n",
-					       ndev->config.mac);
-				break;
-			}
-		}
+	/* backup the original mac address so that if failed to add the forward rules
+	 * we could restore it
+	 */
+	memcpy(old_mac, ndev->config.mac, ETH_ALEN);
 
-		if (mlx5_mpfs_add_mac(pfmdev, mac)) {
-			mlx5_vdpa_warn(mvdev, "failed to insert new MAC %pM into MPFS table\n",
-				       mac);
-			break;
-		}
+	memcpy(ndev->config.mac, new_mac, ETH_ALEN);
 
-		/* backup the original mac address so that if failed to add the forward rules
-		 * we could restore it
-		 */
-		memcpy(mac_back, ndev->config.mac, ETH_ALEN);
+	/* Need recreate the flow table entry, so that the packet could forward back
+	 */
+	mac_vlan_del(ndev, old_mac, 0, false);
 
-		memcpy(ndev->config.mac, mac, ETH_ALEN);
+	if (mac_vlan_add(ndev, ndev->config.mac, 0, false)) {
+		mlx5_vdpa_warn(mvdev, "failed to insert forward rules, try to restore\n");
 
-		/* Need recreate the flow table entry, so that the packet could forward back
+		/* Although it hardly run here, we still need double check */
+		if (is_zero_ether_addr(old_mac)) {
+			mlx5_vdpa_warn(mvdev, "restore mac failed: Original MAC is zero\n");
+			return -EIO;
+		}
+
+		/* Try to restore original mac address to MFPS table, and try to restore
+		 * the forward rule entry.
 		 */
-		mac_vlan_del(ndev, mac_back, 0, false);
+		if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) {
+			mlx5_vdpa_warn(mvdev, "restore mac failed: delete MAC %pM from MPFS table failed\n",
+				       ndev->config.mac);
+		}
 
-		if (mac_vlan_add(ndev, ndev->config.mac, 0, false)) {
-			mlx5_vdpa_warn(mvdev, "failed to insert forward rules, try to restore\n");
+		if (mlx5_mpfs_add_mac(pfmdev, old_mac)) {
+			mlx5_vdpa_warn(mvdev, "restore mac failed: insert old MAC %pM into MPFS table failed\n",
+				       old_mac);
+		}
 
-			/* Although it hardly run here, we still need double check */
-			if (is_zero_ether_addr(mac_back)) {
-				mlx5_vdpa_warn(mvdev, "restore mac failed: Original MAC is zero\n");
-				break;
-			}
+		memcpy(ndev->config.mac, old_mac, ETH_ALEN);
 
-			/* Try to restore original mac address to MFPS table, and try to restore
-			 * the forward rule entry.
-			 */
-			if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) {
-				mlx5_vdpa_warn(mvdev, "restore mac failed: delete MAC %pM from MPFS table failed\n",
-					       ndev->config.mac);
-			}
+		if (mac_vlan_add(ndev, ndev->config.mac, 0, false))
+			mlx5_vdpa_warn(mvdev, "restore forward rules failed: insert forward rules failed\n");
 
-			if (mlx5_mpfs_add_mac(pfmdev, mac_back)) {
-				mlx5_vdpa_warn(mvdev, "restore mac failed: insert old MAC %pM into MPFS table failed\n",
-					       mac_back);
-			}
+		return -EIO;
+	}
 
-			memcpy(ndev->config.mac, mac_back, ETH_ALEN);
+	return 0;
+}
 
-			if (mac_vlan_add(ndev, ndev->config.mac, 0, false))
-				mlx5_vdpa_warn(mvdev, "restore forward rules failed: insert forward rules failed\n");
+static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
+{
+	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
+	struct mlx5_control_vq *cvq = &mvdev->cvq;
+	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
+	struct mlx5_core_dev *pfmdev;
+	size_t read;
+	u8 mac[ETH_ALEN];
 
+	pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
+	switch (cmd) {
+	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
+		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov,
+					     (void *)mac, ETH_ALEN);
+		if (read != ETH_ALEN)
 			break;
-		}
 
-		status = VIRTIO_NET_OK;
+		if (!memcmp(ndev->config.mac, mac, 6)) {
+			status = VIRTIO_NET_OK;
+			break;
+		}
+		status = mlx5_vdpa_change_mac(ndev, pfmdev, mac) ? VIRTIO_NET_ERR :
+								       VIRTIO_NET_OK;
 		break;
 
 	default:
-- 
2.51.0


