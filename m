Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8DF3F3FE8
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhHVOh4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:37:56 -0400
Received: from mail-dm6nam11on2044.outbound.protection.outlook.com ([40.107.223.44]:3680
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233450AbhHVOhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:37:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUP5+mdbdorSuUii7iKZReF2ioXu51OFQhgJxnbldmGTqgOxw6js6u+X1mk1LT4FG2oo5/n3NJKwUCsgLlwzUZzazgLq1q8jciVwrWClAk0jEXtj14IBDalcWWKNRor1ZUm+lNNqgsbbNVu9ySoT1SxUixXvuM07KxbSNyubptyKOxR4NYt22+MZGzsDpG4iTVBR/WtKHvfWnpRpwRaHmcYMZhcnxGWNAILCYUM/T7hJ38idgtGUfLEWIAD5soAz4lm4dCnS7yw56RiOio3SLqII3AbSaQ5o8a03GhNwWIRbh769gty0ssPyTfsGZY4ST8Qp9377ZatVQFQgnrxJRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk6eiJRzhHqxXMmQf+G6er3GAE5IGBFw1AxsURvDILY=;
 b=eaedd6urecoc9l8ZeIJ8OZJdVOafibN1iSVlc5J7REa1gf4iidOhZV+JWD+eJTUIBb4qlICXgl6+xFuEMXf44tmPW7GM1UPigegEIB8v4LAbtgIQCJ/D20Id1fAUdg/wfW+/JcGpBfZ8IT+PtHkBxLjdyGwxrd3DM0Y/TwfGZkeUfFU45OqDV44eiG5yy51IMKvTkPCxojJ5/xHNid1nq819JLysoHE/uDWXApEYldAYUrVfbSayQq232ZPUSLxFuWhQj1NSHIiVmTws97H+TdsBk9iRwLR5RlR9ZP82odmBpdGEGk6SReMrSpGwXrwIBYdZIwgYpCvokxlLiAZu1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk6eiJRzhHqxXMmQf+G6er3GAE5IGBFw1AxsURvDILY=;
 b=nMJ2o9ZSk34uyBygQ35j5Nd8uo2bwGJ5jMTGuO3kkGLpK2zolqH9BkIdw8VAXjc1dJIVey08/J8PsPDz7sFpjJrk+v7yaaZGwc4us+e51Sp8RE+fJlDeYqMtfKcwBPB7D03BsiqmG7nhZLComCQfMHFiTh7uGrMniAuSSoOcL4CZw4YnwW5+Jp2n0V4LcFL1ivbK/7wvXVUqid/zOXO+mIG97Fmvuo+FTmFbIrkBUwmme8liw+vketlM+XAoIizJwmcl5nPQGT2UFlQ3MrwVx6ddjtIggOOkXurxH8/2goE6yPhjM/QMRUCxQURg+HstznXtm6Ue/I5Ypu8p5HKy/A==
Received: from BN9PR03CA0771.namprd03.prod.outlook.com (2603:10b6:408:13a::26)
 by MN2PR12MB4221.namprd12.prod.outlook.com (2603:10b6:208:1d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sun, 22 Aug
 2021 14:37:13 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::23) by BN9PR03CA0771.outlook.office365.com
 (2603:10b6:408:13a::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 14:37:12 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Aug
 2021 07:37:11 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:07 +0000
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
Subject: [PATCH V3 04/13] vfio/pci: Rename ops functions to fit core namings
Date:   Sun, 22 Aug 2021 17:35:53 +0300
Message-ID: <20210822143602.153816-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210822143602.153816-1-yishaih@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9a7e702-0d11-40c5-b06b-08d9657a54aa
X-MS-TrafficTypeDiagnostic: MN2PR12MB4221:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4221F26FCF0340BAFC85031CC3C39@MN2PR12MB4221.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QcLR3AlquZvb8zuzBfoYO/RHxU+8IsZ3l9H7QQtougs8c0PBK3mSp7JcQhr7sxUiVg0b4eotr4oCYG4vXhnksBmS7vZoBmHy/TmsdoZiu79AuD3uD0hnbHh7Wl0Ir9OfFEO2sYjbhXzo8RkmajuOoxXYdadK9Y6TZg8eRb3p4C4Ofm6BSvklem7LBMvFfDxqrXa6W1/jMcuvCGqUmNa7rilWv3TUiWVqP309gx63XA+HxJW0G59O3Lg4vE5+MFk1wL812N1L0r5KdZ7r0RM7222wfUoyTQd1yEgAti17+quYwI5MM3q8e9Hset8GBZ4ySkTzN+bZz86ShwjFq4OQEg88s5abNOEiUN7wJMAlxfeIRCTLld6J0qD0OwpWzoNdjBYvVxTH9uB8io9FmpWSGK3Y/ScxFVb7lWxZedTxSJgAVOU4wVWW0nr83jntOnL8KQLOEQ9bM5d9l05IpxQIwe4Q8TdI3LIBK+F0OmzJE+haaAGu3NW+gs4O1pHCawUu8ONNmVwRZuzdKsFE8bCkmy4stufy4HSyUUyZHtSZiwVsCOoml1FIWU20qB/ocdEqqUoN5N/DJJ+mnfyQscM+mcF5/5K8Iz8xH1lnuzrOJltceRG3FIWxt6BM0hiGSTDEuq7Gvaj8UxRrTgLClt0sI+xfGhe7j40Uslmb4/ie3K6bPnMQkxee7UB2Ink2NKq25PuLglwKgVpT+g51bU5fYW2/aMDAT+Qf4LuGmzCQCRI=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(36840700001)(46966006)(6666004)(47076005)(83380400001)(107886003)(36756003)(426003)(70206006)(82310400003)(26005)(86362001)(36860700001)(316002)(7636003)(82740400003)(8936002)(2906002)(5660300002)(110136005)(54906003)(7696005)(1076003)(4326008)(356005)(70586007)(2616005)(186003)(8676002)(478600001)(7416002)(336012)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:37:12.8444
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a7e702-0d11-40c5-b06b-08d9657a54aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4221
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
index 2729479390a0..ee5c8fe2a324 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -533,7 +533,7 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int va
 	vfio_device_put(&pf_vdev->vdev);
 }
 
-static void vfio_pci_close_device(struct vfio_device *core_vdev)
+static void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -554,7 +554,7 @@ static void vfio_pci_close_device(struct vfio_device *core_vdev)
 	mutex_unlock(&vdev->igate);
 }
 
-static int vfio_pci_open_device(struct vfio_device *core_vdev)
+static int vfio_pci_core_open_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -727,7 +727,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static long vfio_pci_ioctl(struct vfio_device *core_vdev,
+static long vfio_pci_core_ioctl(struct vfio_device *core_vdev,
 			   unsigned int cmd, unsigned long arg)
 {
 	struct vfio_pci_core_device *vdev =
@@ -1302,7 +1302,7 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_read(struct vfio_device *core_vdev, char __user *buf,
+static ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	struct vfio_pci_core_device *vdev =
@@ -1314,7 +1314,7 @@ static ssize_t vfio_pci_read(struct vfio_device *core_vdev, char __user *buf,
 	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
 
-static ssize_t vfio_pci_write(struct vfio_device *core_vdev, const char __user *buf,
+static ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	struct vfio_pci_core_device *vdev =
@@ -1533,7 +1533,7 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
 	.fault = vfio_pci_mmap_fault,
 };
 
-static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
+static int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1604,7 +1604,7 @@ static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *v
 	return 0;
 }
 
-static void vfio_pci_request(struct vfio_device *core_vdev, unsigned int count)
+static void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1720,7 +1720,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 
 #define VF_TOKEN_ARG "vf_token="
 
-static int vfio_pci_match(struct vfio_device *core_vdev, char *buf)
+static int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1772,14 +1772,14 @@ static int vfio_pci_match(struct vfio_device *core_vdev, char *buf)
 
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

