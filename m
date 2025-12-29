Return-Path: <kvm+bounces-66765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 88083CE620E
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 08:29:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5357300CBA7
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 07:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0137A26F2AF;
	Mon, 29 Dec 2025 07:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WzHq6RvL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC742F5311
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 07:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766992599; cv=none; b=ch98rWDPS7CAxld8O5lW2DJ2sbaGoRyx5XUxEcsDmf+5mkW9RJeAb8khj8p2X0d9eF4CrI47sD2LZhrZNsB5lEjQ4a+juOK5druHZl7tKMmN1C1S+Fkqw0Ky6OURDXqei61990wudF2DuIPWePwPPmm99bPgkUWyPhwWGVd55QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766992599; c=relaxed/simple;
	bh=ZB8lg+FEeOBLcKsr5se7oYvazRKQYj2n59dc8c4glpo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Op84Xp0p96yCcd2efimip+8xCvvCkcfSq18LVUAsQsTYLhF71Xr8EkjvFysoyMYydIQ4XkRgP8GfjckMiDFqq79KAjtZq9SKy39D05EWdNGjqG5ntohPtW6s20mleNquHURyuzW5uRCJf/YtrNHtlofufa+3Pq8YkflhrSvYaqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WzHq6RvL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766992594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bbpMSrSLvHoX3JODD2GRIw1w4LmWrcNKLely9tVSUQs=;
	b=WzHq6RvLVWhD9muE0tmxdm34hLcFwT0nJN2ygDbn4yPz4EUE4xjnNRPnoV3bIfM/8PWaa6
	7v4AE/xwj8boF68HEmvxo8FYJKrp8sH8HRguJNcv79H3HnLDqW61JrPeyvs+B8M/YWZP9s
	GQbtbRGRipOQrUyfJzUae9DKZrV9MMI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-48-1p1YA1FUMainomJzJps0yQ-1; Mon,
 29 Dec 2025 02:16:31 -0500
X-MC-Unique: 1p1YA1FUMainomJzJps0yQ-1
X-Mimecast-MFC-AGG-ID: 1p1YA1FUMainomJzJps0yQ_1766992590
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C454195608F;
	Mon, 29 Dec 2025 07:16:30 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 06E0319560A7;
	Mon, 29 Dec 2025 07:16:26 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	dtatulea@nvidia.com,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v2 3/3] vdpa/mlx5: update MAC address handling in mlx5_vdpa_set_attr()
Date: Mon, 29 Dec 2025 15:16:14 +0800
Message-ID: <20251229071614.779621-3-lulu@redhat.com>
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

Improve MAC address handling in mlx5_vdpa_set_attr() to ensure that
old MAC entries are properly removed from the MPFS table before
adding a new one. The new MAC address is then added to both the MPFS
and VLAN tables.

This change fixes an issue where the updated MAC address would not
take effect until QEMU was rebooted.

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index c87e6395b060..a75788ace401 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -4055,7 +4055,6 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 static int mlx5_vdpa_set_attr(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *dev,
 			      const struct vdpa_dev_set_config *add_config)
 {
-	struct virtio_net_config *config;
 	struct mlx5_core_dev *pfmdev;
 	struct mlx5_vdpa_dev *mvdev;
 	struct mlx5_vdpa_net *ndev;
@@ -4065,7 +4064,6 @@ static int mlx5_vdpa_set_attr(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 	mvdev = to_mvdev(dev);
 	ndev = to_mlx5_vdpa_ndev(mvdev);
 	mdev = mvdev->mdev;
-	config = &ndev->config;
 
 	down_write(&ndev->reslock);
 
@@ -4078,9 +4076,7 @@ static int mlx5_vdpa_set_attr(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 			goto out;
 		}
 		pfmdev = pci_get_drvdata(pci_physfn(mdev->pdev));
-		err = mlx5_mpfs_add_mac(pfmdev, config->mac);
-		if (!err)
-			ether_addr_copy(config->mac, add_config->net.mac);
+		err = mlx5_vdpa_change_new_mac(ndev, pfmdev, (u8 *)add_config->net.mac);
 	}
 
 out:
-- 
2.45.0


