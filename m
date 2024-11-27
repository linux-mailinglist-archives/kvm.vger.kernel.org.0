Return-Path: <kvm+bounces-32555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C0869DA28D
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 07:58:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF84D283F8C
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 06:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0796B14D29D;
	Wed, 27 Nov 2024 06:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fImu+9dv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2073.outbound.protection.outlook.com [40.107.212.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A86113BAE4;
	Wed, 27 Nov 2024 06:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732690686; cv=fail; b=QUptMcUwoBt+QHS7HkGYPEe88y/ksVkkPY85HcEH/ybj7B4ZuwxpUzKHe6DCKFOo+bOlmv3GrdXlgNy6PxIdlV/54zCabQoNITc7KpmsqI9AL3JCWdxLXoE+Y758Qo3QDnhFmTv2ONEd5jmT4dcMLFPYP2IEdm1PFp5dhll+64o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732690686; c=relaxed/simple;
	bh=0XD9fSoEWhmkLOwR6rSvI47HgmnZ8TlZr7F59uViifo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DrAmTmH4MJ7yxUB/uYxkLy7ksXfn0NpfOh4HT0an4pr6amiNYAXCVblo5HXobmlss9DUqZE/UYa3cu7ULodjUwm/aXC3jnYth9QLZVf/4B2g05lzOAKXQBZybVKiTkVkNzkT4BjXR11a91s53ik9QGCSXDmqV4WmewPIPjAgbXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fImu+9dv; arc=fail smtp.client-ip=40.107.212.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ndrXf3qzU20BW3zVE8IYXu8J74daUqagmDI+BRmqIHjHiZctVVv/rFcqUSXFX3F72bvWXTYuAjFPlxX0vgtg930xKGJEq90dlyd1hMHWyPELWo223PdfccmQcKbY1RMgHUJcAqO7TH880KRozJ8U5vkzcbZQPPhUW/7UuMKaBnJwxK/coPpRDjcGhAjwb30yQJRzgSyQ9ayLiI0v47yxzAuLh3LGxFUy6GhJ3em0S1/ujbhiCE70DRB1bdfQ4ePO9ed0/S5afqiCYoACyGFCmeUSmhWt7G5PZLKowphrwAgJJS3Hdo3YaVNcxWwa35Lw71iAoIMwwBqV9F1aLKT31w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N17WcDkXClINEUAKYrPIhP6US1kNLDb/pt2+l/yYNao=;
 b=wawJvkZn5WVeStqXE9RmVqn+clVyOM0o89uaUTD23chN6PpuzfIvb0/LJRkGVGrHEQvK/MOqA6wpWHGrjlSmnBj4WnuJom+F90SpWUjffrzYHmXwFp8bHeZxG2vizDaTefOTuWrLqUL/Y1swZFlwLRZMIvz3Xjui0LQSiMEgFqNgXiuxqIRD6r7pyzynsnPH7M4jH6fCebzU1JGYWebwugN3qksp463udCQlaWccse0jfIMOHSU+RZpiYax9IFOGpSo3eLRff78NKNyUsPOZ4RZaYX/AIHC1UCO2VFb7BGpBg3BWd/E3ETUUA7PK6HHhZZg+2jY9krXWurKiubbRFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N17WcDkXClINEUAKYrPIhP6US1kNLDb/pt2+l/yYNao=;
 b=fImu+9dvM+ajFmyoFQxDVGsdCkwcr4K8r7oo+5WdPX8XhsaWz7oBaS3naZp3O2fQNWdbJTJZjuTtW2sU8fi48OyWAtj7iUkMOko4d0PFTaSg2o29vTMSQEyUBvDXr0Oq82NVgwvMfmFQVZZl7nM0e7DFqHjb0QWTRKAvtKaGVzlk80pjsbvG3e4XQlIhf7tDuWsOOlUdHb3cDmllHshR7tnIZSpZlFtZWLmeF3kuFZCeaaUEcgML98fgbD9WoM0E6lkb4iJ6+MMhew/5W3MLyOHu2VoRY+rZP7h7voehGLZ0/nl47lfDt1EgwRvwbli2nq6sGbjJ+kjsrxLZmic2nw==
Received: from PH7P222CA0009.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:33a::23)
 by SJ0PR12MB7007.namprd12.prod.outlook.com (2603:10b6:a03:486::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 06:57:59 +0000
Received: from CY4PEPF0000FCBF.namprd03.prod.outlook.com
 (2603:10b6:510:33a::4) by PH7P222CA0009.outlook.office365.com
 (2603:10b6:510:33a::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.13 via Frontend Transport; Wed,
 27 Nov 2024 06:57:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000FCBF.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8207.12 via Frontend Transport; Wed, 27 Nov 2024 06:57:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 26 Nov
 2024 22:57:41 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 26 Nov
 2024 22:57:41 -0800
Received: from rsws30.mtr.labs.mlnx (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 26 Nov 2024 22:57:38 -0800
From: Israel Rukshin <israelr@nvidia.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Parav Pandit <parav@nvidia.com>, <stefanha@redhat.com>,
	<virtualization@lists.linux.dev>, <mst@redhat.com>, Linux-block
	<linux-block@vger.kernel.org>
CC: Nitzan Carmi <nitzanc@nvidia.com>, <kvm@vger.kernel.org>, Israel Rukshin
	<israelr@nvidia.com>
Subject: [PATCH 1/2] virtio_pci: Add support for PCIe Function Level Reset
Date: Wed, 27 Nov 2024 08:57:31 +0200
Message-ID: <1732690652-3065-2-git-send-email-israelr@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1732690652-3065-1-git-send-email-israelr@nvidia.com>
References: <1732690652-3065-1-git-send-email-israelr@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBF:EE_|SJ0PR12MB7007:EE_
X-MS-Office365-Filtering-Correlation-Id: 1be4f5f0-9d1a-49e5-36c4-08dd0eb0d445
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SDuMRWF+kAl2WsFTXxfUIQXbj3UOY3hU/nA/u41x7zDYRnJwdMz+L9UMPf9h?=
 =?us-ascii?Q?7XKxXgWlO3xJvPlMoSg0WEC81fSsdDa7OzpoHzsC2ToJW72X8rLyvWCbVamh?=
 =?us-ascii?Q?PZB5ehIOR3g8N5cND5FKCBhcWkHqfV5tV4C2cdtSJ1WPggDznM9wwRPF2l65?=
 =?us-ascii?Q?P7LiYaAK2tEKgMXNrSN8/P6hYf5/3POAS0T3H6iz5OBjzq3HuEU6/qlgM3kf?=
 =?us-ascii?Q?ytvd/xj6OCpbTAhA5PkDGdXsMoaCZXEEzNkGg70fL4ydSc2ZTOKc2hexxsne?=
 =?us-ascii?Q?aujZucgQCjVNqZ7FITXc71GCMIS/PMSWkvqaocR3F5eCqcQbjh6Br7P8C97i?=
 =?us-ascii?Q?xS4wZZcHdt17kZKhlEe4wTjCST/8PIFNQ77aePRog5mLL8h5VICHnkuEQlBO?=
 =?us-ascii?Q?5m8uX9nGOSe62d7zkqdSKPMCpN5LwZpgU/4sxAu5zOjKZ5S5BJy3yl42zucP?=
 =?us-ascii?Q?0NHTsL2dJHJk3Jrcm4cMH0FRTbdfj/h+fOJKFR37n6lEyXxxzoRx+tQP7wCi?=
 =?us-ascii?Q?2Y6hek1wgUN1M5LoSk23kw53XU0jmRL9dGufG1HmZaNKSM87bOy+K+yWIQ1j?=
 =?us-ascii?Q?AgmkKQ5T/NhTn8nEgVhP49NaUC5v3aCtuIC6dX8pnM2A7FIqQg2Lzf5jxhHj?=
 =?us-ascii?Q?jqHSXinwfExlPgHIpDzQIBsdMI6iCVuHoJPtiMDyIK7ESBnYiFOLOawAyAW5?=
 =?us-ascii?Q?GFqd2hK598Yd3nlVQKHlsYeH1BPdLYW89RY9mtCP1hztGuxBv2bEWtZC+a72?=
 =?us-ascii?Q?NUrHBZzMs5kZzF6VYOMOgAXZci9P7Tx4v2bHFZ5025dHvPAB2si+CJPEaiiE?=
 =?us-ascii?Q?iMVMBeURcWSNljx13f0EhiMSmBXJlQkHfL0zRtNYaX04PU+lSy1SJiwvJ+iT?=
 =?us-ascii?Q?UGI9PRHYgdeJh1FajxqndauhEZzwTHds+OzUMKwzDCGL61Kt8Gf0gFIrlI1V?=
 =?us-ascii?Q?hqL6f7iscJCiJiiDOpbwviaYQoVUEvGkxb/P0SvFdzgv6P2mwolbt4YHOdIA?=
 =?us-ascii?Q?ow/YWLuW6vlkzgQnX+VFjgWLo4Im5/VPhufZd03D9l99Er3cSnQxBMAb+uhW?=
 =?us-ascii?Q?5m0OFLMPSS5dths0nT0u7pd5UQB7Aak66co3/HhQlmoKWb5gd22bHPwh7gI9?=
 =?us-ascii?Q?mRBeG7YurU7ETxRhcYV9egJ3LoQPrPYi1VVWIx7S4J3lucJG8HdPkPiZrO61?=
 =?us-ascii?Q?OYRnt6TuX4uNsdeUK/J2FwOp0jTMAUQzVUTDMrUHxVvAU8D7fuk4BaIUyBQ/?=
 =?us-ascii?Q?vhG0HaZauKIZWXFOR4SDJkmSTNkYUXlJyBaZF1rGmLavm8X8eOlKBWNoutb4?=
 =?us-ascii?Q?GKbT3JNoSmBEiZ54hklbitJ805OdPqIDnyMT36x9XagzB6q+FIN/nw+MubxN?=
 =?us-ascii?Q?v9CYezsrPl5+C5TPgzFg4HE1X2bwCErKmWeFMVr5lCs59kYXsZAHGBzY1xc3?=
 =?us-ascii?Q?gapTEV41KkYhNy1SDkhmCyy46ynG6vIs?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 06:57:59.3879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be4f5f0-9d1a-49e5-36c4-08dd0eb0d445
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7007

Implement support for Function Level Reset (FLR) in virtio_pci devices.
This change adds reset_prepare and reset_done callbacks, allowing
drivers to properly handle FLR operations.

Without this patch, performing and recovering from an FLR is not possible
for virtio_pci devices. This implementation ensures proper FLR handling
and recovery for both physical and virtual functions.

The device reset can be triggered in case of error or manually via
sysfs:
echo 1 > /sys/bus/pci/devices/$PCI_ADDR/reset

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/virtio/virtio.c            | 94 ++++++++++++++++++++++--------
 drivers/virtio/virtio_pci_common.c | 41 +++++++++++++
 include/linux/virtio.h             |  8 +++
 3 files changed, 118 insertions(+), 25 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index b9095751e43b..c1cc1157b380 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -527,29 +527,7 @@ void unregister_virtio_device(struct virtio_device *dev)
 }
 EXPORT_SYMBOL_GPL(unregister_virtio_device);
 
-#ifdef CONFIG_PM_SLEEP
-int virtio_device_freeze(struct virtio_device *dev)
-{
-	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
-	int ret;
-
-	virtio_config_core_disable(dev);
-
-	dev->failed = dev->config->get_status(dev) & VIRTIO_CONFIG_S_FAILED;
-
-	if (drv && drv->freeze) {
-		ret = drv->freeze(dev);
-		if (ret) {
-			virtio_config_core_enable(dev);
-			return ret;
-		}
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(virtio_device_freeze);
-
-int virtio_device_restore(struct virtio_device *dev)
+static int virtio_device_restore_priv(struct virtio_device *dev, bool restore)
 {
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
 	int ret;
@@ -580,8 +558,14 @@ int virtio_device_restore(struct virtio_device *dev)
 	if (ret)
 		goto err;
 
-	if (drv->restore) {
-		ret = drv->restore(dev);
+	if (restore) {
+		if (drv->restore) {
+			ret = drv->restore(dev);
+			if (ret)
+				goto err;
+		}
+	} else {
+		ret = drv->reset_done(dev);
 		if (ret)
 			goto err;
 	}
@@ -598,9 +582,69 @@ int virtio_device_restore(struct virtio_device *dev)
 	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
 	return ret;
 }
+
+#ifdef CONFIG_PM_SLEEP
+int virtio_device_freeze(struct virtio_device *dev)
+{
+	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
+	int ret;
+
+	virtio_config_core_disable(dev);
+
+	dev->failed = dev->config->get_status(dev) & VIRTIO_CONFIG_S_FAILED;
+
+	if (drv && drv->freeze) {
+		ret = drv->freeze(dev);
+		if (ret) {
+			virtio_config_core_enable(dev);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(virtio_device_freeze);
+
+int virtio_device_restore(struct virtio_device *dev)
+{
+	return virtio_device_restore_priv(dev, true);
+}
 EXPORT_SYMBOL_GPL(virtio_device_restore);
 #endif
 
+int virtio_device_reset_prepare(struct virtio_device *dev)
+{
+	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
+	int ret;
+
+	if (!drv || !drv->reset_prepare)
+		return -EOPNOTSUPP;
+
+	virtio_config_core_disable(dev);
+
+	dev->failed = dev->config->get_status(dev) & VIRTIO_CONFIG_S_FAILED;
+
+	ret = drv->reset_prepare(dev);
+	if (ret) {
+		virtio_config_core_enable(dev);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(virtio_device_reset_prepare);
+
+int virtio_device_reset_done(struct virtio_device *dev)
+{
+	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
+
+	if (!drv || !drv->reset_done)
+		return -EOPNOTSUPP;
+
+	return virtio_device_restore_priv(dev, false);
+}
+EXPORT_SYMBOL_GPL(virtio_device_reset_done);
+
 static int virtio_init(void)
 {
 	if (bus_register(&virtio_bus) != 0)
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 88074451dd61..d6d79af44569 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -794,6 +794,46 @@ static int virtio_pci_sriov_configure(struct pci_dev *pci_dev, int num_vfs)
 	return num_vfs;
 }
 
+static void virtio_pci_reset_prepare(struct pci_dev *pci_dev)
+{
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+	int ret = 0;
+
+	ret = virtio_device_reset_prepare(&vp_dev->vdev);
+	if (ret) {
+		if (ret != -EOPNOTSUPP)
+			dev_warn(&pci_dev->dev, "Reset prepare failure: %d",
+				 ret);
+		return;
+	}
+
+	if (pci_is_enabled(pci_dev))
+		pci_disable_device(pci_dev);
+}
+
+static void virtio_pci_reset_done(struct pci_dev *pci_dev)
+{
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+	int ret;
+
+	if (pci_is_enabled(pci_dev))
+		return;
+
+	ret = pci_enable_device(pci_dev);
+	if (!ret) {
+		pci_set_master(pci_dev);
+		ret = virtio_device_reset_done(&vp_dev->vdev);
+	}
+
+	if (ret && ret != -EOPNOTSUPP)
+		dev_warn(&pci_dev->dev, "Reset done failure: %d", ret);
+}
+
+static const struct pci_error_handlers virtio_pci_err_handler = {
+	.reset_prepare  = virtio_pci_reset_prepare,
+	.reset_done     = virtio_pci_reset_done,
+};
+
 static struct pci_driver virtio_pci_driver = {
 	.name		= "virtio-pci",
 	.id_table	= virtio_pci_id_table,
@@ -803,6 +843,7 @@ static struct pci_driver virtio_pci_driver = {
 	.driver.pm	= &virtio_pci_pm_ops,
 #endif
 	.sriov_configure = virtio_pci_sriov_configure,
+	.err_handler	= &virtio_pci_err_handler,
 };
 
 struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev)
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 338e0f5efb4b..9cb0a427b7d5 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -187,6 +187,8 @@ int virtio_device_freeze(struct virtio_device *dev);
 int virtio_device_restore(struct virtio_device *dev);
 #endif
 void virtio_reset_device(struct virtio_device *dev);
+int virtio_device_reset_prepare(struct virtio_device *dev);
+int virtio_device_reset_done(struct virtio_device *dev);
 
 size_t virtio_max_dma_size(const struct virtio_device *vdev);
 
@@ -211,6 +213,10 @@ size_t virtio_max_dma_size(const struct virtio_device *vdev);
  *    changes; may be called in interrupt context.
  * @freeze: optional function to call during suspend/hibernation.
  * @restore: optional function to call on resume.
+ * @reset_prepare: optional function to call when a transport specific reset
+ *    occurs.
+ * @reset_done: optional function to call after transport specific reset
+ *    operation has finished.
  */
 struct virtio_driver {
 	struct device_driver driver;
@@ -226,6 +232,8 @@ struct virtio_driver {
 	void (*config_changed)(struct virtio_device *dev);
 	int (*freeze)(struct virtio_device *dev);
 	int (*restore)(struct virtio_device *dev);
+	int (*reset_prepare)(struct virtio_device *dev);
+	int (*reset_done)(struct virtio_device *dev);
 };
 
 #define drv_to_virtio(__drv)	container_of_const(__drv, struct virtio_driver, driver)
-- 
2.34.1


