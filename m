Return-Path: <kvm+bounces-36417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F354A1A93A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 18:50:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6567A3ADD4A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF561B6556;
	Thu, 23 Jan 2025 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HupPeGOM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEAA1ADC91;
	Thu, 23 Jan 2025 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737654571; cv=fail; b=Wyy/HBPSQZKXmxhJwFA1DNXcTVjZIcpKGIY4wVGe7IFlM+7Rd9Bxju4t45JzcXHLyQSe+FjSRZLB6hTW1HeoJ+tjp0femjsGQDgk6w1LhZJJp1v3RwcbGPP07ESv9EdKFZO3istdyRuJcrAymYz26TUIuLkcEcVoxUqNqKVo4g8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737654571; c=relaxed/simple;
	bh=PnJ0O6eZiM5gDrxWK3s87d3uyTQQ+hyUPTVTLf2kq1o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BQRLTHvmPDAwzVPtzHUvDivs96ZiOh6oR/dJ6czV9u+RfkRLN6XDnFtf9XEsPLLXAobFBtRkBSeJodnp9EyWKSu9PbfGho7TtM5cZgGHbdh5FkCnwIdQtw19m8pVt+mxMM8lGeA+dgWidzJxk/p+BZu35OQZH6ztbJ48IPIMdrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HupPeGOM; arc=fail smtp.client-ip=40.107.92.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cbyqPtVYprvKFEMtC2lWbmJx4MIA4SLLF1CpyZa0CQ3TV0oUdMn8IbL9sD/s3xamlRsD3qjOXqYJnWwUcsi3ccGgW8OCqTLOPsN/3iRpima3y4cEH7m1UVIF5ke2u8hZkT2OUE/sVcJfTO1tgcde2hXa+/pY0YSj2P0wht4K7wHorc14gWy1NYEfmyzDT1qZgwUYXdYVeL0Em23AA5eZWCuTLiwYIeGMounV4XNbe4J05Ub4pbIYbEpRezU3ZaypiUPFOxeDCFkDb8DB+Td6xHKy0iXVY+OYb8qOGNWZh4SufsL8pbQ4zvJPx6TopKTF4CRH2JfLHDe6sNv+iOfM1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AjNqtx4Jy9WYrWi5YnT7VRkplfxq2zAlECbUvAUU2Kg=;
 b=F45Dn0O9BAe4JK0cBFDhN1YGIKBaxgg9lb9EsJ6f6DGWBCDneePPOK9Y7r8URQGJpKj6kXS2DEIBdEj1u+mP8OJe7y7Lwaxv4rjE9FXIHIWM/Q+LicmDyjbVv3GTpcV5NadDk6xO537/2PoQ3ptRGRMv+7KXYi2xXwOWLWGno1oywcc/b1MXXS2V6S5RY+05RIfTsxjdTWBEhM8ynwUSmhLWBeNc7CmlVRE8HI0EdVoPdhDoiAO3lMnpuZYrAjMjrfN3otsGlzC/JDn+a2r+7y9eJa9K3FXmjTBQdWKI1ghyTVYDdQIU9zMrOZf7A2qsjbtPQSFjQILtqYjhPnL9Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjNqtx4Jy9WYrWi5YnT7VRkplfxq2zAlECbUvAUU2Kg=;
 b=HupPeGOMW/lViqpB4eNRh24p1fVf7hae8IjlBQHRSCQ/G/00lDwXsBphwk0YeZZuamsv44cr28kHQdPWhwgE6C0mu0lJsFsurQfxLBSDoeSntOfRlNSsnqx+IoEUKt8XtWC44zZmh0m0hihIYNMo9JUmymoF/vLuYMudYRX8MbhPzWy3VcsoGZTndMToI6537SnVjsqWSUpxp4rcZQslzaLEKCJafajmh2JNe8j+WqK3icmnbV3e46yoGAssI3VoqhvTVa9LDR7KDERY2a3YGOh2VOd+EilqnJHvP1QOjhYnzyDKpnxwFPEmWGyl3BJpUZv9v2CUATRHw01DPPrCjw==
Received: from CH2PR18CA0039.namprd18.prod.outlook.com (2603:10b6:610:55::19)
 by SA1PR12MB7368.namprd12.prod.outlook.com (2603:10b6:806:2b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Thu, 23 Jan
 2025 17:49:21 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:610:55:cafe::ce) by CH2PR18CA0039.outlook.office365.com
 (2603:10b6:610:55::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.18 via Frontend Transport; Thu,
 23 Jan 2025 17:49:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.8 via Frontend Transport; Thu, 23 Jan 2025 17:49:21 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 23 Jan
 2025 09:49:06 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 23 Jan
 2025 09:49:05 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 23 Jan 2025 09:49:05 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kjaju@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C link status
Date: Thu, 23 Jan 2025 17:48:54 +0000
Message-ID: <20250123174854.3338-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250123174854.3338-1-ankita@nvidia.com>
References: <20250123174854.3338-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|SA1PR12MB7368:EE_
X-MS-Office365-Filtering-Correlation-Id: 96d9f788-b28a-44ab-12c8-08dd3bd6445e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LkRXhi+qBpzxJFWwz0IMijHCA00GB++WcodIK84SqNUrp34JLiV/aL8QfSa6?=
 =?us-ascii?Q?C3HlON99rKBstiplRW6lpLlzhpoee6sxS73KGU12/3zw9Gz/k4UOHZEQGplI?=
 =?us-ascii?Q?wwoDZxj5swfVF//M7hk2u8Zudb5NGmL9UqyMx7gxVjcBQTvi/rRSkzvJ1upU?=
 =?us-ascii?Q?33QvXEkoevpr9VYPz/0AaHODFuIGlw4vy8T2nOA2+88BHCeaVfGnlp8TLXVG?=
 =?us-ascii?Q?SClBSc+gIZ3TbEkUV9dyralV76OzK70BbvHleNzNCX/fwcwss+3rTDu4x3/N?=
 =?us-ascii?Q?FCwg85OJQ7Hq2ok7suNDGKeWT+cro0iew1WbJboUKGnja2o19Owl28bFltg0?=
 =?us-ascii?Q?pdIUjqmJ3j8wEiLwcbUniYAPQDVM7NhBebwK6ehvib6ze453nipb1pn5cZyW?=
 =?us-ascii?Q?GQwznL5Bx6srK53qQlTsJFLPrhiY5cRgFXW+ycJpqoGoo0T9eUmGEXrwrWYf?=
 =?us-ascii?Q?567fqlJueZ36a1l2j2+N1CpC313+WkfON4m6GZrE5eKVhBkPjhWXKXrOGwP1?=
 =?us-ascii?Q?PnPoeU0TjZQ0i0o83iMHxBjuAhoROl+0fMFZX5FWFPjItXxGC0QxZ5nZD8QL?=
 =?us-ascii?Q?Xxh6sBpn6FsrA0rqrdKiWREl3OBekOlVonjpOe5NY/S2U6cbK3YQvmsSQnWg?=
 =?us-ascii?Q?MXyZd1t71DB/S80FKUwklA99XteKgEDwvgjlEQuNyBLe3IkfZgOVhqYAnIn2?=
 =?us-ascii?Q?VqLUa6228Jvivz/97UqQHCH0OfXaoSJ74bcMXxp8hC9R2i7uzc3zrVyP8O70?=
 =?us-ascii?Q?zuxhtSwcD5bd162ylTKgnNl4HBM+y9n3Cto0+cOpeL9lZTPcekaD2bPANumI?=
 =?us-ascii?Q?fu2Iso4C6NwGp8obTbJGBpc68XTzHFbqOLo9vB2uPdt/g7t1Ah7Vad9Kewzf?=
 =?us-ascii?Q?2WP7SL3IwDcfgmAg13jc7rtsahTevxtBqinQk7bm6sbyjm9q8GJMuFyLbWNV?=
 =?us-ascii?Q?oc86OU5gxwIt3IqAsRGlEi8C2iIHmpSX+9dia+LSzNy9yjaJRX57oTzUvYPO?=
 =?us-ascii?Q?xQHKD6cyxC74TxokpeOFLiXY8UwjfQmVWXadcEAJpm4+pOIv5T625dq/oB19?=
 =?us-ascii?Q?AwqP6A7Gj/0WsM9fkuIFR5yCsES7mEVnYGxrQcI5T2MA/4CiTC789fvUGqa3?=
 =?us-ascii?Q?kQVItlP3WAmocqiWZZo2uDGPPvT2tpdqMvxYlHKvWfr+OSSkE+33oqebpAyk?=
 =?us-ascii?Q?P9vGDF1B4ui2l5JLrCWtlKgfF9pP54hk7/BSKF1baBSZK1J8y9WQ8QKSuwgF?=
 =?us-ascii?Q?IFDgfuTc46D/Ev2/VYwR8L2BLeO3/9jbr54UL/kltc6xoNfYlhbYWnMvPYNQ?=
 =?us-ascii?Q?cmFNhSlT+C1OiBtLs2BsykDFY6C9stjPaaWRpr0DOeuFpXhOJsALYAV9KZM/?=
 =?us-ascii?Q?YjkudpvDd1EZMqINTnYi9hWKU8hbLouphyuvO7OdSnhgQjeQgjvlu6PjWwDH?=
 =?us-ascii?Q?OGM//cpH2PTypZendVhQ2l3GyqOxwvha1nuO9NqynplzehZU+T6UMOwZ+meC?=
 =?us-ascii?Q?nCyLoC1jIkSLhS8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 17:49:21.1128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d9f788-b28a-44ab-12c8-08dd3bd6445e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7368

From: Ankit Agrawal <ankita@nvidia.com>

In contrast to Grace Hopper systems, the HBM training has been moved
out of the UEFI on the Grace Blackwell systems. This reduces the system
bootup time significantly.

The onus of checking whether the HBM training has completed thus falls
on the module.

The HBM training status can be determined from a BAR0 register.
Similarly, another BAR0 register exposes the status of the CPU-GPU
chip-to-chip (C2C) cache coherent interconnect.

Based on testing, 30s is determined to be sufficient to ensure
initialization completion on all the Grace based systems. Thus poll
these register and check for 30s. If the HBM training is not complete
or if the C2C link is not ready, fail the probe.

While the time is not required on Grace Hopper systems, it is
beneficial to make the check to ensure the device is in an
expected state. Hence keeping it generalized to both the generations.

Ensure that the BAR0 is enabled before accessing the registers.

CC: Alex Williamson <alex.williamson@redhat.com>
CC: Kevin Tian <kevin.tian@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 72 +++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index f4f23c0c95c7..fc480ea32c11 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -5,6 +5,8 @@
 
 #include <linux/sizes.h>
 #include <linux/vfio_pci_core.h>
+#include <linux/delay.h>
+#include <linux/jiffies.h>
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -25,6 +27,13 @@
 
 #define GPU_CAP_DVSEC_REGISTER 3
 
+#define C2C_LINK_BAR0_OFFSET 0x1498
+#define HBM_TRAINING_BAR0_OFFSET 0x200BC
+#define STATUS_READY 0xFF
+
+#define POLL_QUANTUM_MS 1000
+#define POLL_TIMEOUT_MS (30 * 1000)
+
 /*
  * The state of the two device memory region - resmem and usemem - is
  * saved as struct mem_region.
@@ -861,6 +870,65 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
 	return true;
 }
 
+/*
+ * To reduce the system bootup time, the HBM training has
+ * been moved out of the UEFI on the Grace-Blackwell systems.
+ *
+ * The onus of checking whether the HBM training has completed
+ * thus falls on the module. The HBM training status can be
+ * determined from a BAR0 register.
+ *
+ * Similarly, another BAR0 register exposes the status of the
+ * CPU-GPU chip-to-chip (C2C) cache coherent interconnect.
+ *
+ * Poll these register and check for 30s. If the HBM training is
+ * not complete or if the C2C link is not ready, fail the probe.
+ *
+ * While the wait is not required on Grace Hopper systems, it
+ * is beneficial to make the check to ensure the device is in an
+ * expected state.
+ *
+ * Ensure that the BAR0 region is enabled before accessing the
+ * registers.
+ */
+static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
+	void __iomem *io;
+	int ret = -ETIME;
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	ret = pci_request_selected_regions(pdev, 1 << 0, "vfio-pci");
+	if (ret)
+		goto request_region_exit;
+
+	io = pci_iomap(pdev, 0, 0);
+	if (!io) {
+		ret = -ENOMEM;
+		goto iomap_exit;
+	}
+
+	do {
+		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
+		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
+			ret = 0;
+			goto reg_check_exit;
+		}
+		msleep(POLL_QUANTUM_MS);
+	} while (!time_after(jiffies, timeout));
+
+reg_check_exit:
+	pci_iounmap(pdev, io);
+iomap_exit:
+	pci_release_selected_regions(pdev, 1 << 0);
+request_region_exit:
+	pci_disable_device(pdev);
+	return ret;
+}
+
 static int nvgrace_gpu_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
@@ -869,6 +937,10 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	u64 memphys, memlength;
 	int ret;
 
+	ret = nvgrace_gpu_wait_device_ready(pdev);
+	if (ret)
+		return ret;
+
 	ret = nvgrace_gpu_fetch_memory_property(pdev, &memphys, &memlength);
 	if (!ret)
 		ops = &nvgrace_gpu_pci_ops;
-- 
2.34.1


