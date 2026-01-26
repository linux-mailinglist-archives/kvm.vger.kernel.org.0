Return-Path: <kvm+bounces-69088-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KN/rIII5d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69088-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:53:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE2A7863C8
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:53:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BD9CA304CA5A
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 09:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE6432E120;
	Mon, 26 Jan 2026 09:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UuV738Vl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C72D328251
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 09:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769420959; cv=none; b=UxxUAWjd0n0z4WwBXAodfRJXnbNAJt+0H/wWY5L6hciE7rZ8xGmuvcSimHgTVFCFy157n6bd85W8mUkd2qw1uLJkoZkAUazCzvz/l7QgJ9IDmvcUN/cye1o6kz39j0K8fXqJ51pOqWBKitrcgiT9L/gk686qI9UnrGnVWPJX5Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769420959; c=relaxed/simple;
	bh=sQG0ulPjyoMU2mXqCzKt0fj8BMgAfnG4+oOFmOhKhfo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+qL/jH+R3WhC4Jy/pUiamd0XxgXSk10pKUam9fRj1hn0SPe4FBBv84NngfeCHjxA65GMoh7zUd+0rjpo9rmSLJcs3CeNJyvvuf3fK2Eu3SmHuHQmt4jIxWbl1sBWlVXxnUEFa/oem+a7UK4+W9f9HDOWlGeDKcIWytMQG36r2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UuV738Vl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769420956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ItKIv+h2/RtsA3PNwbq9GoAOv0lsdKDp+oWdKyES3kM=;
	b=UuV738VlvM5SEf3WQAXMXrT9pR8Sx1F0/EOsde6Kt772SnRDu6UBBpxWtJyH23lx4YeZS4
	NiFdouxvgqsiXkbm/25r33AHLuMAvz1cYRhSjfqM7qB7tOlQxbWTwKoBGmLm/1qWUnm7ft
	JDUxBjyPlvmP8Zmh5zEpp+cCj2O62S8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-XxBIQ1eWMfSKmDIbSAM0Sg-1; Mon,
 26 Jan 2026 04:49:12 -0500
X-MC-Unique: XxBIQ1eWMfSKmDIbSAM0Sg-1
X-Mimecast-MFC-AGG-ID: XxBIQ1eWMfSKmDIbSAM0Sg_1769420951
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E9811956094;
	Mon, 26 Jan 2026 09:49:11 +0000 (UTC)
Received: from S2.redhat.com (unknown [10.72.112.82])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D7E71180066A;
	Mon, 26 Jan 2026 09:49:07 +0000 (UTC)
From: Cindy Lu <lulu@redhat.com>
To: lulu@redhat.com,
	dtatulea@nvidia.com,
	mst@redhat.com,
	jasowang@redhat.com,
	netdev@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v4 3/3] vdpa/mlx5: update MAC address handling in mlx5_vdpa_set_attr()
Date: Mon, 26 Jan 2026 17:45:38 +0800
Message-ID: <20260126094848.9601-4-lulu@redhat.com>
In-Reply-To: <20260126094848.9601-1-lulu@redhat.com>
References: <20260126094848.9601-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lulu@redhat.com,kvm@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-69088-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:email]
X-Rspamd-Queue-Id: DE2A7863C8
X-Rspamd-Action: no action

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
index 78a4b80d1ce2..517edd7da019 100644
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


