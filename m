Return-Path: <kvm+bounces-56729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 454C6B430DB
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:10:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E3B71C23A88
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5197258CE5;
	Thu,  4 Sep 2025 04:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RC1YgbWJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76554242909;
	Thu,  4 Sep 2025 04:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958925; cv=fail; b=r0zZitVwKHbFDQnw2DXtCHePmtG9gupaHqyLU33oMvSbUVOY4kkpXU/MXtM3TLC9bIMNIeNPJZItksMZw0ZjlAQ3AR/apXNF3q1t85UhZRrccgWKwAYIOEnFs0pb8evXu8QSk1xoFzXgG4poQnwu0O/P1ccVNlrF0ZTRRKEC//U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958925; c=relaxed/simple;
	bh=WiXbiSeENmkb181nDTCtb0zyj2IhaXjHKQl6MR/sOvk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X9NFQhXeupiY9RZCvNhqNZcSKyI67uq3tM9KuzemXctIfMI1DeAAWqrRo5007PbklDS48NvwWPKn49IodKRw5mJJOiaGyVXd40yqp27OC4NW79Cf7razl/BFDmqAugSitU9+F4/zUhClSYJtv2LK7q3GBH1+nyiQiOokVkBCYVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RC1YgbWJ; arc=fail smtp.client-ip=40.107.243.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WhhaJXhFc0oF2bBK53E8L5+9HebtuGmSsg/IPquM4QQ4R6/4ds4qrtxbsz8zuregMgtlSj//brPpB47P5jGumW1gaIVWi8Wc+b9EYcyDMMRLYVWba1syLW1uRfTCbQy2JrFsGr46Z/pUoQw+1rixRrBLLUSsaRulWKvsNNAtt9GNQ0QE4eL+pMqzCj5SIoPhVuvzahZUIqq2NINb1JPUJ2YApgllAvkbsWAX7l8MdrE2Dgureb1imP43tqgefnz3XMfkhZXpW7KzsLw3FY+xFPIfG0niVDfuEyGAp+aaZkzqz4cvCrVeikiyTkgrCOVtelUVPw0KI1G2PrFPB2jZbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X4no3/c9Dc9zAnyh7x/d8D8tQ4huZoTFcFpOeJlAVNE=;
 b=KRhdvC76Jh+o05/XzCJDQi8H1nE4pezhzfbsPMD1nqVI+EqWpKtXS/EFSUFcEexD+fzuSdpiYV7fbdU/Muq/wtztMJFwuOs9Q3aCuJoZifj5zO9ocPk3zr0yX+bBtrtHRZ4ztUU5VgqIPsg+IYm/hsYaeRu8FNp9dOrxxhFVP/CeBDO2/uUfwTRRE/IZcd8dfCm00otUSjWAtzU2aKK9DGc6XaBgUm83CFLAJhVS8H0tkRwXqOSbe6ltbq0Mn2YwRtKO4IwiHiDZmVXWIShTdcKv8M6hkSRRVuowB2VcmIOcx3jgQYd/x5SVFDXwHTdq3BPa5rhUCcEbg/Hk6oanLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4no3/c9Dc9zAnyh7x/d8D8tQ4huZoTFcFpOeJlAVNE=;
 b=RC1YgbWJR02vSkvBGmN4RtF1mtvqhbZ3lFi3pRaKYQjYcD2UROfGjbdyrUWv/oJUAybUtC+5zEyhpgzhUkFpr7pwYSOYY0UQtDjgoooamUwQvIRy2P8TSZMIKIK8UPgq7punW4CB+qAIuRwdumqTzH5dw6qZk1CnUNH07siXPGks5Ljv0H/zUIytTH6rV+gkjFh/Dd8DbUXGm0WAGpZd4jwjPQV6vOzjIi1uynJWGUYf7Vofvk6qUVs3Ht/r8cVH2VlmJrCe0bjWO4BgHBEJi/ESp1FGO2/1QIoIZuTbZOJITaQN6mQwj+aGwXUa5Zj6BU++rNX66PZiLDBlFqZjpA==
Received: from SJ0PR13CA0178.namprd13.prod.outlook.com (2603:10b6:a03:2c7::33)
 by DM3PR12MB9349.namprd12.prod.outlook.com (2603:10b6:0:49::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 04:08:39 +0000
Received: from SJ5PEPF000001D2.namprd05.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::49) by SJ0PR13CA0178.outlook.office365.com
 (2603:10b6:a03:2c7::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.6 via Frontend Transport; Thu, 4
 Sep 2025 04:08:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001D2.mail.protection.outlook.com (10.167.242.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:39 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:32 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:32 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:32 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 08/14] vfio/nvgrace-egm: Expose EGM region as char device
Date: Thu, 4 Sep 2025 04:08:22 +0000
Message-ID: <20250904040828.319452-9-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904040828.319452-1-ankita@nvidia.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D2:EE_|DM3PR12MB9349:EE_
X-MS-Office365-Filtering-Correlation-Id: be430934-5d52-4fea-75e2-08ddeb68ba78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AQ8ge4dg/qdAhl07rmFxzk3eTcdtjUS6Oj2W80+uULLqWhM8jVtCriqmUZjR?=
 =?us-ascii?Q?xHBi5DAyM2+pVr8b0mf8m7WpzD7zG7tgYH09bj3g/qPe2XozeavyN1s0a/U9?=
 =?us-ascii?Q?JCS4a0WgcAaZ4dN2B7oSwQ+rZvZnN8t8tOAdw5QEp359IvvozNaa83AlszFH?=
 =?us-ascii?Q?MUHIPaiheGr7VBK8arn8lpqTx0hukAKa7HHbsrUMDJYaWqP4dpgSx9g+3/EJ?=
 =?us-ascii?Q?ddMC2Idh0QgefdAMz/S1KN3oUg9svTxOZGquNgZ3rZkdxT4ekvKf0k83ntZN?=
 =?us-ascii?Q?GZ2v53Ar25gP6FiphxPaBGmP6MkffJjApoSOGFbfLcZflOu0N+y5qNENRG2c?=
 =?us-ascii?Q?DDTQrLPbDOfWqB0C0MM+J27eH+F1M7S6gqBiaBzmKf1t1E+gHCPuH4QSjvji?=
 =?us-ascii?Q?4ad4ZAJR0udkCzD6xZCIkzpwfWzwbKEcjf15qCgg0OfezdrL8J96Nql2+nGN?=
 =?us-ascii?Q?fqdzm11xnpOVjgtHnAHClvqO0qBpjZ+aFmgQxXedOqB8jue33xMWB+RL+r6w?=
 =?us-ascii?Q?xHvubH5SU/T97DMXtgUnLgM+71iKk0BqmcAcTXf5vYJh8QkhM4fQqla5T+hI?=
 =?us-ascii?Q?NtvVuyLMcfV+8hhQbOL6RKcf2iiLTEMJF/90SQkSZCVdY3NWA7KVoBF1jC7L?=
 =?us-ascii?Q?QQHw97rGalE/DcgvJe+G8Ahbcj/l2NnxIyXr9uttv46y7tzLgQ9c/x0FG3bw?=
 =?us-ascii?Q?i1CoLvtvmThIQaE0vlkZukyojoz2c7L3xl7g2FY72iEO8IAsXWIRBkL2XFdW?=
 =?us-ascii?Q?nnCXppKLDNHwJgCs+qd7XkTMSoor9bwxvK1heJ36FRlsStiw6zmE74oEaOQR?=
 =?us-ascii?Q?Do9cWcf5df6/wqWF3zskWu9r4zwxmP9pocZ2b3kj3aH14ZgHKfOhy3Vw5ifb?=
 =?us-ascii?Q?12EDFD5jk/DJYjsFeN6pOmvUs30M5OLVH3mD89KHU7TVW9icfR3csBvIBpfx?=
 =?us-ascii?Q?8OisXdGwHBrj8FAn0e97ExkM4kY1UoCA67RXSUS2/OdI0g1kc42Vk68XWOGc?=
 =?us-ascii?Q?mUH2UuqR4tuvO5BLkrjB6wnnzmJePAQ/cv52giWX2IN0F+v4JKLf1JGC4BZw?=
 =?us-ascii?Q?LFgtiHuPa8tWkBNLJicLwPlo4eqxhqFK8s36UvBv6XJfaJvEbXlSEHTnnvzT?=
 =?us-ascii?Q?TancvWYFcubdZAtCAIWoQvyZ4drkcN9ACQF5cHMhDp4hVoy1/qpSvHzuvpfM?=
 =?us-ascii?Q?7LrY4v+uUG5YeDC9LEAZRDK3kUEBcMd3FuklpPpTzq1tdDHy5qv2d3BTgjw+?=
 =?us-ascii?Q?PLMZip/OwG92bRuP1HAbBuekepkY4/DgRQCuHUj5QoElipfrsdxFfv4qZDCj?=
 =?us-ascii?Q?SYHj63LuzUbmwE2e0OF4i+UI2sY1MoBUyfQWPTLAILjpSjxVF6KjQ1aMDkPB?=
 =?us-ascii?Q?FLQiPcjXZGYj8i8j59FGjygyYJy+vxErnIi3cJyrpLo5+YJFhxNTp24Dph6l?=
 =?us-ascii?Q?kqEAJKjmYa2TZWSy9pslyqn55HheENQLnw2Hvjw/N1Xh2RYdJ4dl4qzkDXIJ?=
 =?us-ascii?Q?e8ZS/BYCfmMXBstklOGEQyNIzPZrrUmjEC7P?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:39.3784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be430934-5d52-4fea-75e2-08ddeb68ba78
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9349

From: Ankit Agrawal <ankita@nvidia.com>

The EGM module expose the various EGM regions as a char device. A
usermode app such as Qemu may mmap to the region and use as VM sysmem.
Each EGM region is represented with a unique char device /dev/egmX
bearing a distinct minor number.

EGM module implements the mmap file_ops to manage the usermode app's
VMA mapping to the EGM region. The appropriate region is determined
from the minor number.

Note that the EGM memory region is invisible to the host kernel as it
is not present in the host EFI map. The host Linux MM thus cannot manage
the memory, even though it is accessible on the host SPA. The EGM module
thus use remap_pfn_range() to perform the VMA mapping to the EGM region.

Suggested-by: Aniket Agashe <aniketa@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm.c | 99 ++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index 12d4e6e83fff..c2dce5fa797a 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -10,15 +10,114 @@
 
 static dev_t dev;
 static struct class *class;
+static DEFINE_XARRAY(egm_chardevs);
+
+struct chardev {
+	struct device device;
+	struct cdev cdev;
+};
+
+static int nvgrace_egm_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static int nvgrace_egm_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static int nvgrace_egm_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	return 0;
+}
+
+static const struct file_operations file_ops = {
+	.owner = THIS_MODULE,
+	.open = nvgrace_egm_open,
+	.release = nvgrace_egm_release,
+	.mmap = nvgrace_egm_mmap,
+};
+
+static void egm_chardev_release(struct device *dev)
+{
+	struct chardev *egm_chardev = container_of(dev, struct chardev, device);
+
+	kvfree(egm_chardev);
+}
+
+static struct chardev *
+setup_egm_chardev(struct nvgrace_egm_dev *egm_dev)
+{
+	struct chardev *egm_chardev;
+	int ret;
+
+	egm_chardev = kvzalloc(sizeof(*egm_chardev), GFP_KERNEL);
+	if (!egm_chardev)
+		goto create_err;
+
+	device_initialize(&egm_chardev->device);
+
+	/*
+	 * Use the proximity domain number as the device minor
+	 * number. So the EGM corresponding to node X would be
+	 * /dev/egmX.
+	 */
+	egm_chardev->device.devt = MKDEV(MAJOR(dev), egm_dev->egmpxm);
+	egm_chardev->device.class = class;
+	egm_chardev->device.release = egm_chardev_release;
+	egm_chardev->device.parent = &egm_dev->aux_dev.dev;
+	cdev_init(&egm_chardev->cdev, &file_ops);
+	egm_chardev->cdev.owner = THIS_MODULE;
+
+	ret = dev_set_name(&egm_chardev->device, "egm%lld", egm_dev->egmpxm);
+	if (ret)
+		goto error_exit;
+
+	ret = cdev_device_add(&egm_chardev->cdev, &egm_chardev->device);
+	if (ret)
+		goto error_exit;
+
+	return egm_chardev;
+
+error_exit:
+	kvfree(egm_chardev);
+create_err:
+	return NULL;
+}
+
+static void del_egm_chardev(struct chardev *egm_chardev)
+{
+	cdev_device_del(&egm_chardev->cdev, &egm_chardev->device);
+	put_device(&egm_chardev->device);
+}
 
 static int egm_driver_probe(struct auxiliary_device *aux_dev,
 			    const struct auxiliary_device_id *id)
 {
+	struct nvgrace_egm_dev *egm_dev =
+		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
+	struct chardev *egm_chardev;
+
+	egm_chardev = setup_egm_chardev(egm_dev);
+	if (!egm_chardev)
+		return -EINVAL;
+
+	xa_store(&egm_chardevs, egm_dev->egmpxm, egm_chardev, GFP_KERNEL);
+
 	return 0;
 }
 
 static void egm_driver_remove(struct auxiliary_device *aux_dev)
 {
+	struct nvgrace_egm_dev *egm_dev =
+		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
+	struct chardev *egm_chardev = xa_erase(&egm_chardevs, egm_dev->egmpxm);
+
+	if (!egm_chardev)
+		return;
+
+	del_egm_chardev(egm_chardev);
 }
 
 static const struct auxiliary_device_id egm_id_table[] = {
-- 
2.34.1


