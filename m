Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6C33D13BE
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhGUPhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:37:10 -0400
Received: from mail-mw2nam08on2056.outbound.protection.outlook.com ([40.107.101.56]:32992
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232890AbhGUPhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:37:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGazgKHWKicyJHzCPMEEs41MX4sNYuTQJENEiR6gkN16vX/YJHvUF/qeq+TN6CEpX+k1Um5kfCPM2uOJ5sxWteWBHo3fD+ardOKU6cXodI/z4plZaThZ/9nNxrE0tXcuIwmx3pHRP1jdZZIgaZoKO4OEpe1qbONyKSBDNb4V4fmmveCnoi23Y2dh+HXAzLbi29SnexxElxlBlA9dX9Z3bGduX2W4pead+JtRAZJGS7DFoutDkJSPYaImGpLJCaoW7DFF/4IM4o1yY/dCIYs/QcjasAhLioVeWuC6XopW22vk4VciCYsWvCdHnf/fjGy0B2mbjBFuzH1Akz9DUw20NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gD/1MJiCTBwhHXsDqGFhDeAo/5e6Q4DrV/tPk3Es9i0=;
 b=Nptimz2h6kWfcA9Oe2WsV3jZ8AZnp4SaHqfELTZT6FoXnStK1PVi2pufcVuBTBhYDQAS/9whev6qt5m6bEdslm2QdFaBHSECTXCf75rykfsrvFumPVfuDzttbP79BLkKn9CLgjej9iVX7B5NbLcxt8SJ0IkMeHwBOOColoPEAdvOewHX9syaQZEaCG5F/zFN+81eZU0hpq+TBB3cBotEToaJ7bCwzZVWWwxI2TtiKsAa8RGbJIA/djAgL+ZdkCBK1bsPpvb7fKokGGZPqABcdBuK65/C6tl9zEb+ndU4THRCXC24thN7U2SW6TW8qm/6bf4thtERDFFKe2O6Wskutw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gD/1MJiCTBwhHXsDqGFhDeAo/5e6Q4DrV/tPk3Es9i0=;
 b=ZhboZTZmndcfSoD0175zNRWBXVtWe+A3UQsUhZrQH/kperQ2EhUs7CyoOhLC+T3t6svaz+XHZgUENHS0vlnj6wCj/aCucKDOqyJSANMEacscUuVFv8YQqeIhfVxPyCF6nShqBXnLPlMnCK6e/F6tx706uADmRyM1AvpTGjqLLcTMdpbcRJTtYp4XYlCyMyaIY88GaX1EcbkydlAJuafzBjZzEbGIApMH3MPpmqySKva7vaWoBYxNQX+RMXWZmUMat99usvn9zzfZaVT3lm2iaTN43kOGjFRJEAvMSRolISQXutMufjx0E4YktQr2K7vK6WbSExGa4b99XiTGL8oHkQ==
Received: from BN0PR04CA0111.namprd04.prod.outlook.com (2603:10b6:408:ec::26)
 by BL1PR12MB5047.namprd12.prod.outlook.com (2603:10b6:208:31a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Wed, 21 Jul
 2021 16:17:40 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::57) by BN0PR04CA0111.outlook.office365.com
 (2603:10b6:408:ec::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 16:17:40 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 16:17:39 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:35 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: [PATCH 04/12] vfio/pci: Rename ops functions to fit core namings
Date:   Wed, 21 Jul 2021 19:16:01 +0300
Message-ID: <20210721161609.68223-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210721161609.68223-1-yishaih@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 566c25d3-fd56-4f92-c2b4-08d94c631007
X-MS-TrafficTypeDiagnostic: BL1PR12MB5047:
X-Microsoft-Antispam-PRVS: <BL1PR12MB504706BE25C27725726DFBDFC3E39@BL1PR12MB5047.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2iE9b/piVl8I0ONWz3V34wQv26lW3ME2zqnEJJi3Gf+Zj9Zgp3cbNO92nzzA5XcjLoQa/U65AZU0hNkQXy6SU12WhicRs7f/7+hRK4OYWz4wNT9dVZbS/afjeN6S0IazCyOspCsSgYZ3VquYT10N5tjrIX2/FcihgUuCUaHRgwOwGuOKQSLnGyFFsna5hrrtDg+1cO1ns/M/B0OZymUt6lkN4rH5utJYGkDpqicAcaJxT1HezRohEWKHcWytZB58UeaabKk1GEHs7gp5xbPRnKNZU8RFvnsYLA49NSIlx5IQfqLPd8Nb6FYEyfgGGTunENmiN15jUIztmI7HDyVrcMOJjORYqa3SPdN0PGZUTyUvEpPD79lTN5cP21Bu1o9/ZyfZQvurD9yJ9pbugL5B65ZWOYzLe3A4YFg0lsCYDm2wbp7m8L3tQx8itIoLgxNme5SxTNsDvDt3OLYWCVvV5msj8saGq9RZtC90cKwq/U3/iRHN7LFLNbjGAGhXcKNbTtCNEbtRabg8pYxtBZWD5IFjyuAu6iKFx4+/w3ykaIeKjLyJIGBDklEfB2TtpLl0HJylOmQpbTksKWaQIUu5aODy4p9stpvXmAxubEVxBAKTyQtx/ha2o2vvQoqpfI03hCo7l0hIJFYtqZSKnxdELATeo5PLxB/9VMSiBPtRrccNCNxYsls4tG2v63c1SYtWmK+/VwEUr8h/dbSwcjpbkM4PisF19i6QQVCdOoyRYvY=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(46966006)(36840700001)(47076005)(186003)(336012)(4326008)(110136005)(82310400003)(8936002)(36860700001)(2616005)(54906003)(8676002)(7636003)(83380400001)(7416002)(82740400003)(36756003)(2906002)(1076003)(478600001)(7696005)(426003)(356005)(316002)(36906005)(5660300002)(70586007)(6666004)(70206006)(86362001)(107886003)(26005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:17:40.2164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 566c25d3-fd56-4f92-c2b4-08d94c631007
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

This is another preparation patch for separating the vfio_pci driver to
a subsystem driver and a generic pci driver. This patch doesn't change
any logic.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6f95cd842545..ab22b0db064a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -535,7 +535,7 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int va
 	vfio_device_put(&pf_vdev->vdev);
 }
 
-static void vfio_pci_close_device(struct vfio_device *core_vdev)
+static void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -556,7 +556,7 @@ static void vfio_pci_close_device(struct vfio_device *core_vdev)
 	mutex_unlock(&vdev->igate);
 }
 
-static int vfio_pci_open_device(struct vfio_device *core_vdev)
+static int vfio_pci_core_open_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -729,7 +729,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static long vfio_pci_ioctl(struct vfio_device *core_vdev,
+static long vfio_pci_core_ioctl(struct vfio_device *core_vdev,
 			   unsigned int cmd, unsigned long arg)
 {
 	struct vfio_pci_core_device *vdev =
@@ -1304,7 +1304,7 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_read(struct vfio_device *core_vdev, char __user *buf,
+static ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	struct vfio_pci_core_device *vdev =
@@ -1316,7 +1316,7 @@ static ssize_t vfio_pci_read(struct vfio_device *core_vdev, char __user *buf,
 	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
 
-static ssize_t vfio_pci_write(struct vfio_device *core_vdev, const char __user *buf,
+static ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	struct vfio_pci_core_device *vdev =
@@ -1535,7 +1535,7 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
 	.fault = vfio_pci_mmap_fault,
 };
 
-static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
+static int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1606,7 +1606,7 @@ static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *v
 	return 0;
 }
 
-static void vfio_pci_request(struct vfio_device *core_vdev, unsigned int count)
+static void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1722,7 +1722,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 
 #define VF_TOKEN_ARG "vf_token="
 
-static int vfio_pci_match(struct vfio_device *core_vdev, char *buf)
+static int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1774,14 +1774,14 @@ static int vfio_pci_match(struct vfio_device *core_vdev, char *buf)
 
 static const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
-	.open_device	= vfio_pci_open_device,
-	.close_device	= vfio_pci_close_device,
-	.ioctl		= vfio_pci_ioctl,
-	.read		= vfio_pci_read,
-	.write		= vfio_pci_write,
-	.mmap		= vfio_pci_mmap,
-	.request	= vfio_pci_request,
-	.match		= vfio_pci_match,
+	.open_device	= vfio_pci_core_open_device,
+	.close_device	= vfio_pci_core_close_device,
+	.ioctl		= vfio_pci_core_ioctl,
+	.read		= vfio_pci_core_read,
+	.write		= vfio_pci_core_write,
+	.mmap		= vfio_pci_core_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
 };
 
 static int vfio_pci_bus_notifier(struct notifier_block *nb,
-- 
2.18.1

