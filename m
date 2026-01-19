Return-Path: <kvm+bounces-68467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 77F12D39E20
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 06:58:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7B125305E3DB
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 05:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D272690D1;
	Mon, 19 Jan 2026 05:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AZOenaWF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CE2238D54
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 05:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768802119; cv=none; b=Xy2exQHNfPEEQw5mNwnSYDji37eqnw8tJMC4GfoPntJAPS7vFe+0sFoYy61S1ux4L9Qw2XpmXHEFhuYF/Jv9/4VxPr8iyuFZmS6pKWmuxePthOVVn2EoJZ6KeNrzofOO1xOing8vuyKZDNGqvQBJZEoax59mQbEmrLcErhh4v3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768802119; c=relaxed/simple;
	bh=Uy6C4b+WcCdVg81/oqrdtyg+fGwUM7l7vLt0awGGvnM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxA1gf3S0NFX4Wvc/vSWc8IdbSaTnBj8z1gIBIqBea5kvY0Uw7yukqz2Opkw7mgI45o8Oi3yugFI6BsyZExKkB7L7RwzX0IAmVvpIBCYfobXQc4fnp+pPbbP14Qo7U/SXmQFLj+Uq3oO6XJoQQSaM4MmFI8Ux43S4+q+8QuMvbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AZOenaWF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768802114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9RUc9xBJNSYAfdXCE6GVASEQbjxNXlsHBbIujMtK0qY=;
	b=AZOenaWFhtSENQ95Krm3OVWKouj68HQNoTEEA3M3Pz3DjzFlgXxJzm59/3asNMRew+mCTQ
	odS/mZMCHPh4HPpaAXeFYY8HKg5BkOt7a+5Yc/8imm5Otbbp1qnpApEer3J8+Y5hPZbkC3
	q9mM45udPFqxMLr042pIU+qbr8bxSZ4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-VTJcjRCqPUCOnyqhAxHO1g-1; Mon,
 19 Jan 2026 00:55:09 -0500
X-MC-Unique: VTJcjRCqPUCOnyqhAxHO1g-1
X-Mimecast-MFC-AGG-ID: VTJcjRCqPUCOnyqhAxHO1g_1768802108
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01DBF1956095;
	Mon, 19 Jan 2026 05:55:08 +0000 (UTC)
Received: from S2.redhat.com (unknown [10.72.112.143])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3C0CF19560B2;
	Mon, 19 Jan 2026 05:55:03 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	dtatulea@nvidia.com,
	mst@redhat.com,
	jasowang@redhat.com,
	netdev@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v3 3/3] vdpa/mlx5: update MAC address handling in mlx5_vdpa_set_attr()
Date: Mon, 19 Jan 2026 13:53:53 +0800
Message-ID: <20260119055447.229772-4-lulu@redhat.com>
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

Improve MAC address handling in mlx5_vdpa_set_attr() to ensure that
old MAC entries are properly removed from the MPFS table before
adding a new one. The new MAC address is then added to both the MPFS
and VLAN tables.

This change fixes an issue where the updated MAC address would not
take effect until QEMU was rebooted.

Signed-off-by: Cindy Lu <lulu@redhat.com>

Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 7a39843de243..ed9aa0c2191a 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -4055,17 +4055,15 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 static int mlx5_vdpa_set_attr(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *dev,
 			      const struct vdpa_dev_set_config *add_config)
 {
-	struct virtio_net_config *config;
 	struct mlx5_core_dev *pfmdev;
 	struct mlx5_vdpa_dev *mvdev;
 	struct mlx5_vdpa_net *ndev;
 	struct mlx5_core_dev *mdev;
-	int err = 0;
+	int err = -EOPNOTSUPP;
 
 	mvdev = to_mvdev(dev);
 	ndev = to_mlx5_vdpa_ndev(mvdev);
 	mdev = mvdev->mdev;
-	config = &ndev->config;
 
 	down_write(&ndev->reslock);
 
@@ -4078,9 +4076,8 @@ static int mlx5_vdpa_set_attr(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 			goto out;
 		}
 		pfmdev = pci_get_drvdata(pci_physfn(mdev->pdev));
-		err = mlx5_mpfs_add_mac(pfmdev, config->mac);
-		if (!err)
-			ether_addr_copy(config->mac, add_config->net.mac);
+		err = mlx5_vdpa_change_mac(ndev, pfmdev,
+					   (u8 *)add_config->net.mac);
 	}
 
 out:
-- 
2.51.0


