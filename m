Return-Path: <kvm+bounces-56735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E719BB430E8
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:11:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B729206CED
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E8F7274FDE;
	Thu,  4 Sep 2025 04:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EQZeqcUH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61CB25B312;
	Thu,  4 Sep 2025 04:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958930; cv=fail; b=mYv4oxWNST8QIxkqXFWajM1TyRGXfk4OGPWMZF49hVt6c0ailmzR30ZPJXgd1Z9Y4JoFvR5e1eaTtY05QNqRQHnDWfXkzjBQr/0NO/jYTjf72FAMqlH5qtwUlji28b6JVDxKn5eQpCYkRl95uBlrSq/3F7OWHjrHjposTVf5PYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958930; c=relaxed/simple;
	bh=p+6NzfGvTNS2sxmytyS+MwsOPfefstmapEmDYF732BY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k+T70F2FYNsqnEoEXmIVVDKZ4apAG935YbaxCoGrQcxCHxYrUV+KOJSzUl+q0n3HeCszgB4H+YKQjPl5KbmgoSuXLiwSfnlZI62k8Knmik2Lr2TN9Z4XI5I4UQ/Pdww7nVieU/pZvdodEpJ5sXuX/hLB2gkvGjq958zb3vTLpPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EQZeqcUH; arc=fail smtp.client-ip=40.107.223.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KL4jtetVdrDq4t+7VkCgk8t6aep329B/kQx2mdP3f5TM1JG8qgfzcJs+bF5SzdYYbCy2ZiLwXgYy139PsvKnLl8y/GBJG04jtit4RwqKKYQLnBW3hk0KoS+KiGz70SKbaU5in/cY7uQ+670ul2jdlKdp84qwOfGY7+aoUG3372XAXNeKdxO08uvwuBiH4dGv87DMAOXxpzCkKv4xw0RvI4tpk8h0RDZL8wnqba9kbrDpZiFVpc8PoZLSwoOQCqxe+fhXHVFrkymj8UY4LuvxnDRtLdiKaMOfFUWvDLpNe60KdCX02egqiXFGPr+i5LNO1o4O69NybpLCWV6rvFzjMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Syn8VaPMVAcVQQTRe3weluvECXHGgohWc+1wVLG18NU=;
 b=Ct26xzGi1X3/Tosym0YCXKriW/p7f+hz4ZI37tC+wQ0zX1Ia7nWcOkNfCZ9uuDCLyVms40GSocPsXnkaiyNNV0oU8W52IO0KyxEagUkvPEzAJwwp3r584MSLMErh+HNbrbyKnWmxJonEsUzSQtw7QnlCoSeJU+nV6zU6yaX0Q/Wu0UViAukv/SvFrZ5aLk364cIOPH0CjBk6QJ2lQOjd+maJY+v45AyPOkoEEQChnz7cfdUKr7yuwdTqUIe9PPb4VgIoZ7nqrzE78SLsuxMCLLCtkX1D7A927Tg7Qp1rtRqLQayLN6AtTl2gFK3P59FRjf0HsZypfiHRU2zCzEK5Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Syn8VaPMVAcVQQTRe3weluvECXHGgohWc+1wVLG18NU=;
 b=EQZeqcUHJb8dHp9Jw05Uq6uOTuKFsuIVj2cGZIJUHCT9Y5LxCKgH8CsTI+RlYwZcvtnV/6E82q3yPu5sHmhrfaHJZYRIVzXaEiX4jVhplgroTm4px4jwfVBlkAO7YnxG94OAjTVo58O2s4aw5oapAa+rttXUiry+Z8aU54rGrGgXZean2WVu7Q+jSCq7x0Afh03O0gwdMBkdQVvQi6joYPyBlG08LxB7y8gx3YXj+bCK86PaBTT1hMuUVEoUdCc0MBI/m7ysknDXETvl+ESi+DTtTzDUsocun2bM6oDiWDJ3hOkJ+N3mftjF4rVqbpUlOH4VOBgEVxBQ7Qb9aZRdiw==
Received: from SA9PR13CA0146.namprd13.prod.outlook.com (2603:10b6:806:27::31)
 by CH1PR12MB9600.namprd12.prod.outlook.com (2603:10b6:610:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 04:08:41 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:806:27:cafe::96) by SA9PR13CA0146.outlook.office365.com
 (2603:10b6:806:27::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.14 via Frontend Transport; Thu,
 4 Sep 2025 04:08:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:41 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:33 -0700
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
Subject: [RFC 09/14] vfio/nvgrace-egm: Add chardev ops for EGM management
Date: Thu, 4 Sep 2025 04:08:23 +0000
Message-ID: <20250904040828.319452-10-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|CH1PR12MB9600:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d0e638e-3780-4349-5913-08ddeb68bbe9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G8XfpTUziUhPGBSKxGvcp/98EMjJxUoZsxJhGIxSLDIRdlK/5+wG8umguLbl?=
 =?us-ascii?Q?kph+NQSe66/7L1DczkvX3HnRX4QoiHkkhi7eBOTvbojgj6g+zGMR/xY0wwZ8?=
 =?us-ascii?Q?HFEwMUav8RpIFnIv2zodYcG8ueuC/L1AeMoUbd+EhAqBgBBLZGziEcNAFVST?=
 =?us-ascii?Q?qqzMMJu5fOSs0x3R04cDZgj+klbyQpWrhq1LMAMHrbzXDSO2amm2XcKkBsvY?=
 =?us-ascii?Q?D/nmjCx8gb0idO2cidXIGPoY3v/mcA6ALwBLtJqq0IckOB0akmDBOxmiY9NT?=
 =?us-ascii?Q?6SkNVcKVaKqe0juJYQXntIlzDfS8/S45d3e7rKE7PQxiQAyz6WuDLWtrGY0k?=
 =?us-ascii?Q?Gj7NcunYe75sUOaTJjFdAbjcQngvUbQYehITkLMtBcurC68Bo+9Uibx4BEyw?=
 =?us-ascii?Q?ftYHDs/XBztsqqo4LrdPbTFyMPOrsR6NtJBWO9Dpzz1p2Dk5lAT2FNHV7a/d?=
 =?us-ascii?Q?90kY01I0qYrYpnL6rVnqgNkwlV29tTkl4sRiDpeTFGApuc5z6Ho1yQwgRnhQ?=
 =?us-ascii?Q?5Jj7qmj1Z4wGZAGbF7/raY61P+L4Ov1n9Mi9sxRO8yHVBMWdcBAH9FeUpQ0b?=
 =?us-ascii?Q?cYBn1ltdK1WMGJsGF+hLNizVr6aL5tRN/IDOOnYt4AMq7Kv1P70C+fGNIbcV?=
 =?us-ascii?Q?oCk3346KUVW/FF7FAEw06ukmCf3N5GoakLo7lsCZGYE8c2MabmAouxc9F3n4?=
 =?us-ascii?Q?qJ50EY5fyhFWHs9I/wjw67hA/pv7XpupmvfAy2M67EjXN6zl3EePexwJJ4GP?=
 =?us-ascii?Q?DNHsuDCat6gCFrjHq1PpBTjgmO4hHNF5hjBrjTegPjbIhJ2uJS8mrTFCWSor?=
 =?us-ascii?Q?hlI3I72phzDLr6vwyLK19vN7nQDk+d8yGLrYyOVDFt/3wiSPXBhFx2XEOW/K?=
 =?us-ascii?Q?9NhB+UT2FtJIJaT5uTKXZc04Bn8h2qUdomuMqROYCtXpnMkK+sa1ALUIvXYv?=
 =?us-ascii?Q?uvmLxUJxoiypNVmAiTUU9dTmVNyq9tBNBFo1vwh4FwTzCCdKzHb0Zd0R8OO9?=
 =?us-ascii?Q?1u3qM7BcwQQAXHOHCKWWqpVvZxdMke/ZX5dMaRrgksuzq+HdYjrbPOHR9dF2?=
 =?us-ascii?Q?9XMLVE7vuDprDUYiWzDmFa+S4u/5yd09CIRbvOQlL2876RV4kIKwwzV5ZXXo?=
 =?us-ascii?Q?9tJjJUQom8aPLB5DFaf7I3aOK+qBN2770EegJTR+QALk1zSzkGU3J0EU+Fzf?=
 =?us-ascii?Q?2GSMb7UnbExy1OyaZzflw62iBZQN/JvgL5bsTfEQN8A4sftVT6m5hzzSXN0a?=
 =?us-ascii?Q?uGlR3LOqZf8yc+3lNpqkjOOQzexXSDN1yHg7W1ruZ2s7Odb+h0Hg99PTz0lt?=
 =?us-ascii?Q?drBFHroEJO0q2dttQBD0QMxTTfv0SJyXRyHDWYRZ2Q2VQ/7CWBV01OdsI1G9?=
 =?us-ascii?Q?xzAi/UlYI9fMt03ojWS1bETuYWL+3BxEK7XfNTWey5hHMcl6ijc41fDv1mqV?=
 =?us-ascii?Q?bJJxaTZ9ylbfP4XpHNf0T/I0hw4Sy7yY/uYMUVivawE+JNfNFFwB3jl5ITNB?=
 =?us-ascii?Q?x6yYXa7VIy9xa3uwnY+p4xKeLhoGvYkG01LL?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:41.6845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0e638e-3780-4349-5913-08ddeb68bbe9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9600

From: Ankit Agrawal <ankita@nvidia.com>

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
 drivers/vfio/pci/nvgrace-gpu/egm.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index c2dce5fa797a..7bf6a05aa967 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -17,19 +17,46 @@ struct chardev {
 	struct cdev cdev;
 };
 
+static struct nvgrace_egm_dev *
+egm_chardev_to_nvgrace_egm_dev(struct chardev *egm_chardev)
+{
+	struct auxiliary_device *aux_dev =
+		container_of(egm_chardev->device.parent, struct auxiliary_device, dev);
+
+	return container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
+}
+
 static int nvgrace_egm_open(struct inode *inode, struct file *file)
 {
+	struct chardev *egm_chardev =
+		container_of(inode->i_cdev, struct chardev, cdev);
+
+	file->private_data = egm_chardev;
+
 	return 0;
 }
 
 static int nvgrace_egm_release(struct inode *inode, struct file *file)
 {
+	file->private_data = NULL;
+
 	return 0;
 }
 
 static int nvgrace_egm_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return 0;
+	struct chardev *egm_chardev = file->private_data;
+	struct nvgrace_egm_dev *egm_dev =
+		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
+
+	/*
+	 * EGM memory is invisible to the host kernel and is not managed
+	 * by it. Map the usermode VMA to the EGM region.
+	 */
+	return remap_pfn_range(vma, vma->vm_start,
+			       PHYS_PFN(egm_dev->egmphys),
+			       (vma->vm_end - vma->vm_start),
+			       vma->vm_page_prot);
 }
 
 static const struct file_operations file_ops = {
-- 
2.34.1


