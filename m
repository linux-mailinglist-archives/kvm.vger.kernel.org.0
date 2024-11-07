Return-Path: <kvm+bounces-31128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B04B9C09E4
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 16:17:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE9F0B24DE6
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 15:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC00E2139B0;
	Thu,  7 Nov 2024 15:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Kc9NCjve"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2047.outbound.protection.outlook.com [40.107.236.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEF22101A4;
	Thu,  7 Nov 2024 15:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730992654; cv=fail; b=Wg1xcOAYFte+jk+BhITGnddN6l/94rQwxYE75zEm1R2JtaWDQlzZE8iNa85GB5Obe+wwfYqlc1Wtu2rZr0a9oeUke9Q6NtcoUbdZGRHGtsgVNFQNYtKZ4zd8cNJlEGX95fVujrRNSGHNxvRXBAHLVK+y/LmFoaRKQLDfsGqh2As=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730992654; c=relaxed/simple;
	bh=s+UvP2KIYsNE8sPADYW+xeIgcX8GdwNV7/X3ehNHHBM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Phq7fu4+eBx+5HHFcvm3Tozy2jj+bT982riIhPFkCKlzS7XTx4WlcKqaH3PafTlwHz8XynoPTtBht3BLJXXuftZNKtB6XbVzH/Z0XZGAY6duIutCJTqYGjiYBtDl/Fpa499hvI3e0rnY/lzo3RqtkSmabIdP2OgkNtprjFmdKPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Kc9NCjve; arc=fail smtp.client-ip=40.107.236.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aanWmw4PBZURu4T4wZC6Szla3kkXnhQ9cr25Ydzgv5M9IPS/LScE5PglEt9jNHDUzjAcHWGlvC/49UNo9nD7jlchABdLd81LwnJR5whsGuq0B1+6lzbWrCbeunZg+P/vzZX9FnOcDfqx2GKIDom7ciOon4HJiC8Xg+9MtKw7PYy4Rd+L0z6uJ9zr56CvC5TKxuCnNam1d9XQv9JJHTrr9l1BofnQ/ufaUa+K4e/LmpxOLRM06yELl0kUX1mL/n0TK56HGjD5Eg96zuWOQ8JphuR329eeYrBC7fWduU2TbV1Yq3I1ZcZ+4A5iEDIqyev7EH+JcEnPi3WOxP18jhv2VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTg+xwuYNYeWtXT0XNssM8Y9ujObAUQZGlS2p2cz8No=;
 b=TkasTNcABxNfR+j78FNqoxhLCNH43whnPwRF86AO32+HohBnMc56FuB9E6qVBUocjHvOCMUdbPesY/D+VV2jbMYFhEYVuihuCtVurshjW1tH/Kl7EU+TN5nuwGBRHa9nDPBeqjjJzGi5bBrxHyC6jAfoIQ5neyJf1tAn7ZuceZSDJlW3PRIn36Sn9TLyWT8SCQQ6ogahm3gjW3TG+itogEPQM5Oa5/0vSVkd8upPC/g3pJMp0cyLpXFExAlUcIrH09M8uR5TAz2Pol9v+iC+E60X430S5EI1vjbdUfqKz0/PijNUEpT2Gyt8hnoIOgt/j6eo7fH4nCpPJ8K+Uf6tBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTg+xwuYNYeWtXT0XNssM8Y9ujObAUQZGlS2p2cz8No=;
 b=Kc9NCjvewOu82kDfduqN+sajJtIkwexL2KnmBdzBVIVR9ut0qe2DMJTtt59vnrvGyVJKlTSXSwn2CfA/EHzdItlGmRiyFhO92D1PE2sbIW/eklhfs/eifzIjFEXIJp4FZB6nq8XG3B25rJHIgFwbTH5qEny3bzaVpsDL3OJ67rjivlP0ZjZWKXHXY6fZcnWNsjSMDmG24+kHYGk2pwm80IBabj7HMoq1vmgO9bxm5wv8rGTEi6mrd2EspCnM5rVms3Lb8BEejhkx8wh99NDqUFZAJCLpjRnIEmEu2MbMifNgNEXK8IfIm2Df77M0Ph1cX3qs5T/4IdYlHNZHdNG6Vw==
Received: from DM6PR02CA0133.namprd02.prod.outlook.com (2603:10b6:5:1b4::35)
 by LV8PR12MB9420.namprd12.prod.outlook.com (2603:10b6:408:200::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 15:17:27 +0000
Received: from DS1PEPF0001708E.namprd03.prod.outlook.com
 (2603:10b6:5:1b4:cafe::4c) by DM6PR02CA0133.outlook.office365.com
 (2603:10b6:5:1b4::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20 via Frontend
 Transport; Thu, 7 Nov 2024 15:17:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0001708E.mail.protection.outlook.com (10.167.17.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Thu, 7 Nov 2024 15:17:27 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 07:17:14 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 07:17:14 -0800
Received: from rsws30.mtr.labs.mlnx (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 7 Nov 2024 07:17:11 -0800
From: Israel Rukshin <israelr@nvidia.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Parav Pandit <parav@nvidia.com>, <stefanha@redhat.com>,
	<virtualization@lists.linux.dev>, <mst@redhat.com>, Linux-block
	<linux-block@vger.kernel.org>
CC: Nitzan Carmi <nitzanc@nvidia.com>, <kvm@vger.kernel.org>, Israel Rukshin
	<israelr@nvidia.com>
Subject: [PATCH 1/2] virtio_pci: Add support for PCIe Function Level Reset
Date: Thu, 7 Nov 2024 17:16:59 +0200
Message-ID: <1730992620-201192-2-git-send-email-israelr@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1730992620-201192-1-git-send-email-israelr@nvidia.com>
References: <1730992620-201192-1-git-send-email-israelr@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708E:EE_|LV8PR12MB9420:EE_
X-MS-Office365-Filtering-Correlation-Id: 03a148e8-251f-4a42-1f8b-08dcff3f4a3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wq58I8FwhFM5xZaVHwxZMrQ+WoIa7+6IiODwdVzafrpc36EXW/MwPBDVpKtv?=
 =?us-ascii?Q?tE+7jWRf6q8OhAoeLDQDqcZyRsFhYycmElELUlwytUxGb3dKBeRw6izPsUuT?=
 =?us-ascii?Q?lIURdAB9f+MLT5NI1WIvfeIq+D+4cCFSf5Ggy6y1pjcrtvKm5otLbmF6OJcb?=
 =?us-ascii?Q?eMjd1qy7BxgNBMdmUkq2shORzIHW+RFLJ8bdm2KqrU8315tSwoKfWZca5/Qy?=
 =?us-ascii?Q?X///A6uYJ1E6bjsxQsEGI+lhGswbE1PEbYx5IXN4pbmeR+mCHbkDFUVP+xUr?=
 =?us-ascii?Q?uxvtH9cAvBeqKGfZZ/P9R9vvGbKYqZ0zpYqNVUGtAPt/qMCqQdyzKkUHTdXb?=
 =?us-ascii?Q?ej3nDLwL8B9wO3NbOAWEH4gDWHtdxjtdy2FROATMuymQQDPy1WHUxPJ+bGou?=
 =?us-ascii?Q?eDHs9I92b8HynIuomIS6Hi/NKELxRYvTFEKVel98VCeBYflAegdAYsDu1PUR?=
 =?us-ascii?Q?dA4se0h0nQOJGAVslHAhIW6jgWnaaXtYdh/DUNwQh9NQ8p4IyRiyzpDllGSj?=
 =?us-ascii?Q?ax2bZhSYDVHukyq9Y0HoEhyTazgbuYQIB5bvKGLCdaZC8IQ2XMdb9uURQtnY?=
 =?us-ascii?Q?A/2LVm5WbTvX1MXzJ0OCO8GD5aaXH6nteoRMrhru/Ar3hsvXP1aVLIa1idea?=
 =?us-ascii?Q?VysS025lqTpjSBcojduNpPlFJK0yPo3a1oPn2C7Lamox64MJanNMO0Zix5h7?=
 =?us-ascii?Q?b7PpKr9gzS8kDOd2Xs/XntpKcKnTjFWkLDJ4/roP0Qidg0KgSxJFOFnmp7K5?=
 =?us-ascii?Q?h2pE5gV0hUeMflndcTfEvcbqTt8mQpMMuKsUMBYLRSDCc8M4Y7rEB/ovhkLH?=
 =?us-ascii?Q?0R/WdSS6VW4rOPIVkk/XPbcc1za/WuMYvsOl1i7ohqaHbFP76IZo9VdivZxO?=
 =?us-ascii?Q?ikJt/T3X5XMgpHcw0ZyW3BRlCNq6+eL/AnGVIussCT+XrEt/f7cU1Nac8bM/?=
 =?us-ascii?Q?k/k3m1kgR79jJZMKe011dgH4SLOD2RdKKalzooXVY82ND4cjmc7s0vJJMy1X?=
 =?us-ascii?Q?Mp7Z9nFxEDZYqbiJ19mmVJCGxP2vS1+4VGqZ3sbSrfSWStbNCXio2xNVoQeF?=
 =?us-ascii?Q?tw4aUb3QoK/lfNKTtZuMdE9RKexux5vsTO/45IS939EYqDWC1ClUAccQn2B3?=
 =?us-ascii?Q?AGrFM5n0wQTa7yTvl8Hy2uA1ZcSgTvh7qVYauRQItZ2qWU1crnmLeBzyaPXP?=
 =?us-ascii?Q?H8sI60vaYuAufe2P7rNUxDvxZYjkjzgypu/jx9KwQnOin5B8LFrmSmBzkdru?=
 =?us-ascii?Q?+KfHZ5HkfOJ0O5EGuwknHt6JN5u6ZriwIki7nhuY4r0mFLe3BjvHIdeiT+//?=
 =?us-ascii?Q?A5/J/McOMpakj48qCBfW4UaKSaWQs06KSqNTOKoT4H2mN3IqZsmgKBV6VXg4?=
 =?us-ascii?Q?pwQoBqn8eddq0v2qMr1S45vL53sYy9ccLfqZDNpA/a8Pe1PNBw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 15:17:27.1878
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a148e8-251f-4a42-1f8b-08dcff3f4a3f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9420

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
 drivers/virtio/virtio_pci_common.c | 39 +++++++++++++
 include/linux/virtio.h             |  8 +++
 3 files changed, 116 insertions(+), 25 deletions(-)

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
index c44d8ba00c02..a96bebb6a2ca 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -782,6 +782,44 @@ static int virtio_pci_sriov_configure(struct pci_dev *pci_dev, int num_vfs)
 	return num_vfs;
 }
 
+static void virtio_pci_reset_prepare(struct pci_dev *pci_dev)
+{
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+	int ret = 0;
+
+	ret = virtio_device_reset_prepare(&vp_dev->vdev);
+	if (ret) {
+		dev_warn(&pci_dev->dev, "Reset prepare failure: %d", ret);
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
+	if (ret)
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
@@ -791,6 +829,7 @@ static struct pci_driver virtio_pci_driver = {
 	.driver.pm	= &virtio_pci_pm_ops,
 #endif
 	.sriov_configure = virtio_pci_sriov_configure,
+	.err_handler	= &virtio_pci_err_handler,
 };
 
 struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev)
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 306137a15d07..b5241e840550 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -178,6 +178,8 @@ int virtio_device_freeze(struct virtio_device *dev);
 int virtio_device_restore(struct virtio_device *dev);
 #endif
 void virtio_reset_device(struct virtio_device *dev);
+int virtio_device_reset_prepare(struct virtio_device *dev);
+int virtio_device_reset_done(struct virtio_device *dev);
 
 size_t virtio_max_dma_size(const struct virtio_device *vdev);
 
@@ -202,6 +204,10 @@ size_t virtio_max_dma_size(const struct virtio_device *vdev);
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
@@ -217,6 +223,8 @@ struct virtio_driver {
 	void (*config_changed)(struct virtio_device *dev);
 	int (*freeze)(struct virtio_device *dev);
 	int (*restore)(struct virtio_device *dev);
+	int (*reset_prepare)(struct virtio_device *dev);
+	int (*reset_done)(struct virtio_device *dev);
 };
 
 #define drv_to_virtio(__drv)	container_of_const(__drv, struct virtio_driver, driver)
-- 
2.34.1


