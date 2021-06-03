Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2480F39A55C
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 18:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhFCQK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 12:10:27 -0400
Received: from mail-co1nam11on2040.outbound.protection.outlook.com ([40.107.220.40]:13440
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230022AbhFCQKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 12:10:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PdOL5DefL6nqzsYdEmYX2clDeqIM1J3g5ZaPHR/Fl9GKon938WMuejotQbCaXWEC4RbDd6UELQdh+ufPwj3ZLEY6ASM3V5VewpIziqdpkCnwD1LIz8C0/h8d5MRiwLb6BYY84NwJk8ktrDFdXEmUnMmytZb9qJYQe84RhEiQa4SdxNwnSZcSqN72lUN9cq+VZZhARznOOArn8bsQGdQeJkvzj2rpoNdwza9APU13IySs/GYswxgkvK895pn80Lomsxr0/0trWc+7+0mAc0JEdLe8Xui0eYBvbBBi/j2UUXESAPoKB16Mfa+f4J6YNsdpgu9+elyVPI5r1Dgf7TJz7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8C9U6RTln0jtK1b/i+9I7vpdJgGLcvqg9uCg+rFw2Ec=;
 b=kTysWUCdNICenDfmLnD4agUUANsSnb7G10ecbtaqiNnvwirLsKroBpbINcMPRCiQtw9KOUxVy6LyEYsSj8fVlVHU4XazMPAfZ9snKlT51YRGDjm+tVqiJPQubSqID5/V8NmoVMCdRPYQ+meDPoTGfHFZUZ94eoflT34IweUodoKqSa8MOnj3CAsiuzH+muFtKm1k7YHCEfQ6cIxcoQtUzWfhXYwCMNtF8sUppaPTCFEwDouXA28J8F/UhaWd1Si2IPl9Bx1QjPiv3a3LW0+B9yPe9n2kJlh4JH1wUWbomTfRy9Tp+ntdEFNLhOVvSmWQyK+XJV5QErf8npjvpoTfQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8C9U6RTln0jtK1b/i+9I7vpdJgGLcvqg9uCg+rFw2Ec=;
 b=rO/3Aeky9hRusgtt2KGJplPrbNn6HWngU0vfa5Z4zRiInCrW8UzXmRxozII46SPFgvGWGAbbKDOEh57WsyKCLM0O9uAY5u5KaRiqUMACZ2wCrM/iXPFSZgny/7l1Xnp25VWqAB9WTvH2EkD4gGyeasSlEbdKm3xpp6uPyrF4J6qwSxQ43g2GehrNjw4/rsvnGHcePuT1Kg0hSsW/PiUhpmcuhyUxTJwlzqGqE9fdC269ZVGgsozueS0NwnMZFeGl/f17XILpuUmyfWg0I9zF5Vh7qqA8DERzx+WCe+cNMUzTjrDXW7OOapSeXuRIWIj26QipV8l635LqxAH6KsSz5Q==
Received: from CO1PR15CA0080.namprd15.prod.outlook.com (2603:10b6:101:20::24)
 by DM6PR12MB2793.namprd12.prod.outlook.com (2603:10b6:5:4f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.29; Thu, 3 Jun
 2021 16:08:37 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::e1) by CO1PR15CA0080.outlook.office365.com
 (2603:10b6:101:20::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:08:37 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:08:36 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:08:36 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 16:08:31 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jgg@nvidia.com>
CC:     <aviadye@nvidia.com>, <oren@nvidia.com>, <shahafs@nvidia.com>,
        <parav@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>, <targupta@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>,
        <yan.y.zhao@intel.com>, Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 04/11] vfio-pci: rename ops functions to fit core namings
Date:   Thu, 3 Jun 2021 19:08:02 +0300
Message-ID: <20210603160809.15845-5-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210603160809.15845-1-mgurtovoy@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5decf16-f7aa-4809-0097-08d926a9d867
X-MS-TrafficTypeDiagnostic: DM6PR12MB2793:
X-Microsoft-Antispam-PRVS: <DM6PR12MB279340EC5AD2DCEAA03458B5DE3C9@DM6PR12MB2793.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0gAVHt2kBOS3gSjoWCAks9vE3j9Y+h8NoTckpK22C16P9kk8wJRHZ67lOVxDCaNfxW47w1tLvYX6m5K2KPVLgV8+aZ6hGJYqFSafm2PURVmT3gCsGFy3hpxqQq0cTxD8S2b7J17r/j5ugc+ku4gWa9URatogMm5210MXXmEWShhLCZWD9wV6I/xljFBJIF1tvTQo5/EecGlsVTRB3SHjoauiAgqewjUgMDeecwCydHCjLR8JyeJZaFRNz28mPFl83MG2Am6iI4NDTn6q/tCpsye8ps4Sx4rC3HPPJR+Lu2zSo0uO6DNPnn2Ukk5jWU/N7AUu5DZeIIHgzLP5gKyxe9zuB9hWqQlr137BQu+0bgb+naDl9duSMyoOI7g3HKT94bpYboHEve180Rpi3IGPcuT5rXasBvLqZ4xVXljf21mFJnGu8UYNWvps/iOhczxC7m0eHRxOxECkAQyol+OlAzq5lLtojXEy8coFFMZWiSTiT60mHzf498jGOLIf9YqFxj8bTjVhQePptlhFRmL5gnZtVxuHYlv/M4vW2wnEtRfvOky7p5VX1783J3LilbpNvB+ptsgV9oUFmOLqYIjZGOedxnvaYos3CHWOps17uRbpA7GxYhvAZFne9Fa98rM4rEZBJO68wCHiSo/VJI8uOCk9rBuusYqw8xnx2zsUlX4=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(46966006)(36840700001)(4326008)(36860700001)(26005)(8936002)(70586007)(110136005)(54906003)(356005)(8676002)(82740400003)(2616005)(336012)(6666004)(7636003)(1076003)(70206006)(47076005)(82310400003)(6636002)(5660300002)(36756003)(83380400001)(36906005)(478600001)(316002)(107886003)(426003)(86362001)(2906002)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:08:37.0813
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5decf16-f7aa-4809-0097-08d926a9d867
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2793
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is another preparation patch for separating the vfio_pci driver to
a subsystem driver and a generic pci driver. This patch doesn't change
any logic.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 36 ++++++++++++++++----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a6a9d1aaa185..2d2fa64cc8a0 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -533,7 +533,7 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int va
 	vfio_device_put(&pf_vdev->vdev);
 }
 
-static void vfio_pci_release(struct vfio_device *core_vdev)
+static void vfio_pci_core_release(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -556,7 +556,7 @@ static void vfio_pci_release(struct vfio_device *core_vdev)
 	mutex_unlock(&vdev->igate);
 }
 
-static int vfio_pci_open(struct vfio_device *core_vdev)
+static int vfio_pci_core_open(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -763,7 +763,7 @@ struct vfio_devices {
 	int max_index;
 };
 
-static long vfio_pci_ioctl(struct vfio_device *core_vdev,
+static long vfio_pci_core_ioctl(struct vfio_device *core_vdev,
 			   unsigned int cmd, unsigned long arg)
 {
 	struct vfio_pci_core_device *vdev =
@@ -1394,7 +1394,7 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_read(struct vfio_device *core_vdev, char __user *buf,
+static ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	struct vfio_pci_core_device *vdev =
@@ -1406,7 +1406,7 @@ static ssize_t vfio_pci_read(struct vfio_device *core_vdev, char __user *buf,
 	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
 
-static ssize_t vfio_pci_write(struct vfio_device *core_vdev, const char __user *buf,
+static ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	struct vfio_pci_core_device *vdev =
@@ -1612,7 +1612,7 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
 	.fault = vfio_pci_mmap_fault,
 };
 
-static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
+static int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1683,7 +1683,7 @@ static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *v
 	return 0;
 }
 
-static void vfio_pci_request(struct vfio_device *core_vdev, unsigned int count)
+static void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1799,7 +1799,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 
 #define VF_TOKEN_ARG "vf_token="
 
-static int vfio_pci_match(struct vfio_device *core_vdev, char *buf)
+static int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1874,7 +1874,7 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 	return 0;
 }
 
-static int vfio_pci_reflck_attach(struct vfio_device *core_vdev)
+static int vfio_pci_core_reflck_attach(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1890,15 +1890,15 @@ static int vfio_pci_reflck_attach(struct vfio_device *core_vdev)
 
 static const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
-	.open		= vfio_pci_open,
-	.release	= vfio_pci_release,
-	.ioctl		= vfio_pci_ioctl,
-	.read		= vfio_pci_read,
-	.write		= vfio_pci_write,
-	.mmap		= vfio_pci_mmap,
-	.request	= vfio_pci_request,
-	.match		= vfio_pci_match,
-	.reflck_attach	= vfio_pci_reflck_attach,
+	.open		= vfio_pci_core_open,
+	.release	= vfio_pci_core_release,
+	.ioctl		= vfio_pci_core_ioctl,
+	.read		= vfio_pci_core_read,
+	.write		= vfio_pci_core_write,
+	.mmap		= vfio_pci_core_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
+	.reflck_attach	= vfio_pci_core_reflck_attach,
 };
 
 static int vfio_pci_bus_notifier(struct notifier_block *nb,
-- 
2.21.0

