Return-Path: <kvm+bounces-1579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 571EB7E9746
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59C671C209D9
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 08:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63051C2B8;
	Mon, 13 Nov 2023 08:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BAkNXl/d"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9561B278
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:03:51 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A1D10F6
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 00:03:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCRMD2WL9gFbaxOm92P4m/JldoV7lMLiXjbaw3HFNvYd4tBSJx8ecAZgQru1Hpd4EGjzvSy0O+X/lEoLetI5CizeI9gHA87ey8nUD9+v7zDfOvCwy2TGG2cgo9RO5S6PreKDl0ozrrI/LFQ1BySjwp7Gr3py0SoCyvvXxDEr0LcRKpmAXCgiwAfGXxuzCwj+Q4kq/sRMmr19VwMewrchwQm7ICp58xp49XLbekpwu09wm+t9HsltHDVArw92QNvExec0DQ+Miyz/H5peYkEOth7NcGa+DWey/VRHCd5RfZi8U7De69pCewSiEq60iM1ox8P6autWJGJlZ7jYBiUG0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1eFzxJ/LjJHaZZ59rqE75yCcH0bNXHQfZmDKNhUSPI=;
 b=liBd2OLeJ18igIsK5DasVgfznOEfTmW6YGVF5+sfQ+hUcSmkJ5/h/bqyGDxGAe+2O/irhg7yMnEnhNQd5P4fzOO5TDVyJl3m2vtCSQNZHPwr/S8JjPR5d8Cpo+O6WfL1h4keNcfYdLWvUfg5i8im7vsE4wDhA1f+kmtibwP0RJhOqFRDtfqArH+eU3xRPg4xdOHfId10f2XJTHj4yQViplfCU8G16UIzp44GKpakc1imzN89gJAwKRAuEy+aaceKbgbAQa4SFf0S6Ax7hlTnlsEdAp/VnEUyuQ2UvtqKp52p0slQCxxMOOYsFpQYZhuOkofw6QxjE7VFzI5/br2BOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1eFzxJ/LjJHaZZ59rqE75yCcH0bNXHQfZmDKNhUSPI=;
 b=BAkNXl/d4HQ4J7twL0VNCP/4AzERg05Xqi4830bJRn5tEjfiKwhwXizvNrxC/NT5pyIlDMRt1diYz66pL10jsegxDja31jSe4gN8SUD3zGcpXksYhqBuv79Hg007u7yoY8zwJgq/JVbibMzWvtKaPpbW8wlXZ7blO2VPt0OkTTD0sCz7kxO3phcy6CVyfRIYY7Kx2I3gFUf8AuC/TRVfZWGC66u1+YrdePQlc17aTK+e8sX/DG5w9rOlLy39DwcAqwv360M0KeMozXb2LthuVHdVUdxCnELlynVKokXSSWskQvG7ROsJDD9x0+QmpYk3te673L7Wa9n8lz7nvDpRTQ==
Received: from SA9PR13CA0167.namprd13.prod.outlook.com (2603:10b6:806:28::22)
 by SJ0PR12MB5662.namprd12.prod.outlook.com (2603:10b6:a03:429::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Mon, 13 Nov
 2023 08:03:44 +0000
Received: from SA2PEPF000015CA.namprd03.prod.outlook.com
 (2603:10b6:806:28:cafe::dc) by SA9PR13CA0167.outlook.office365.com
 (2603:10b6:806:28::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.15 via Frontend
 Transport; Mon, 13 Nov 2023 08:03:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF000015CA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7002.13 via Frontend Transport; Mon, 13 Nov 2023 08:03:44 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 13 Nov
 2023 00:03:25 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 13 Nov 2023 00:03:25 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Mon, 13 Nov 2023 00:03:21 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 vfio 7/9] vfio/pci: Expose vfio_pci_core_setup_barmap()
Date: Mon, 13 Nov 2023 10:02:20 +0200
Message-ID: <20231113080222.91795-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231113080222.91795-1-yishaih@nvidia.com>
References: <20231113080222.91795-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CA:EE_|SJ0PR12MB5662:EE_
X-MS-Office365-Filtering-Correlation-Id: fc4aaa72-5d23-4626-fef5-08dbe41f0eaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7tCWR3HhxvD0yMp1AiKJF1Wat6rRpKsy4ec+DZnJ3fchtIgJfwHVIzg/MQt/2QXdGXf7V+cq0g+PuY6D2aTZHrkvc521jXu2m+ZpaIpHZc6YembaEY/KgSOijycj4bVXZEpZ1Mg0qNazHl4yLxdNmclZOmLoYE2zVphKgCeeGWr3LwjJvnFz8m8NpxJwv+QmgIPsZVLsta89xSSX8jLQ/0GcBIXjcY7RIDrRS6Ew5eRA88uStV+0ZgRVAE+fR2MsnMwMu8KB9nNsYNOiOdCPgOFI7bAqIY8oaOnrW02ej1O7Jhhjbd7X5lCcPYnSgzUM1eky7wyEVQYF+vLuGPjHTETkVr1AqbwVyyPrpPDD5O4m2fOvKwsHJJJ0exij/ZGQupGEZfn5pPZe6AJCBAqsydOmPO5XeAdCRWWVN/gMNZIfkcsDwb8jN3JtUx9j3GfwZeCQ6XjSIV6zVuqHgmk6Uj/2Atm8aCLcUnGOUOhGNlRiaqXRF/ShARkBhKaRS+ChKidb0CrzBZ/qPuSh8vQVj4ZZmHpIOZqD8ceJ7OI195JCmb/3t4EnQu8jQ4xmN+FwNoG2yOY8UqqDlWEXNd7kx3v7G3JRD6iPUD2M8JHyK+kz8CE2nyq7dIXMMfhp8iA1mh2oakZaR/U1tCQlNUMpoIm9qJd6jyqlUio1Vks64bkc/K8/BUiE6xOafnPccnl/lJnqu8vjLGd/MCynYeBxvF3+OkB+aSNeU/u4Qw6aH4gVeP7Iol/RIGUMNoDsvtvNLWKtpjzyFomC52uLUbBhdw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(136003)(396003)(346002)(230922051799003)(82310400011)(64100799003)(451199024)(186009)(1800799009)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(54906003)(70586007)(70206006)(110136005)(82740400003)(7636003)(356005)(36756003)(86362001)(6636002)(36860700001)(83380400001)(336012)(426003)(26005)(1076003)(107886003)(2616005)(7696005)(2906002)(478600001)(316002)(5660300002)(47076005)(41300700001)(8676002)(4326008)(8936002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 08:03:44.3341
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc4aaa72-5d23-4626-fef5-08dbe41f0eaf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5662

Expose vfio_pci_core_setup_barmap() to be used by drivers.

This will let drivers to mmap a BAR and re-use it from both vfio and the
driver when it's applicable.

This API will be used in the next patches by the vfio/virtio coming
driver.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 25 +++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_rdwr.c | 28 ++--------------------------
 include/linux/vfio_pci_core.h    |  1 +
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1929103ee59a..ebea39836dd9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -684,6 +684,31 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
+int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	void __iomem *io;
+	int ret;
+
+	if (vdev->barmap[bar])
+		return 0;
+
+	ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
+	if (ret)
+		return ret;
+
+	io = pci_iomap(pdev, bar, 0);
+	if (!io) {
+		pci_release_selected_regions(pdev, 1 << bar);
+		return -ENOMEM;
+	}
+
+	vdev->barmap[bar] = io;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_setup_barmap);
+
 void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index e27de61ac9fe..6f08b3ecbb89 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -200,30 +200,6 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 	return done;
 }
 
-static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
-{
-	struct pci_dev *pdev = vdev->pdev;
-	int ret;
-	void __iomem *io;
-
-	if (vdev->barmap[bar])
-		return 0;
-
-	ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
-	if (ret)
-		return ret;
-
-	io = pci_iomap(pdev, bar, 0);
-	if (!io) {
-		pci_release_selected_regions(pdev, 1 << bar);
-		return -ENOMEM;
-	}
-
-	vdev->barmap[bar] = io;
-
-	return 0;
-}
-
 ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite)
 {
@@ -262,7 +238,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		}
 		x_end = end;
 	} else {
-		int ret = vfio_pci_setup_barmap(vdev, bar);
+		int ret = vfio_pci_core_setup_barmap(vdev, bar);
 		if (ret) {
 			done = ret;
 			goto out;
@@ -438,7 +414,7 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 		return -EINVAL;
 #endif
 
-	ret = vfio_pci_setup_barmap(vdev, bar);
+	ret = vfio_pci_core_setup_barmap(vdev, bar);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 562e8754869d..67ac58e20e1d 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -127,6 +127,7 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 
-- 
2.27.0


