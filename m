Return-Path: <kvm+bounces-35887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F03B4A159F6
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59E803A8F4F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 23:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B249F1DF242;
	Fri, 17 Jan 2025 23:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="g9g6qZcW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D055F1DEFD8;
	Fri, 17 Jan 2025 23:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737157051; cv=fail; b=JPIBiUkzrMvRgBWyBJtpAYWU6iZVIwGaNPJnioh4eo1LAqfYiK9Ux86bUywY6fiRjNXKrXToDAmVCIru2dvllpMnVrIQbyVKXbzxsTz/a899JUS6LAGzNNnOFZHaAGRh6Jr546qyI/v0wRiRf4PDNepRiNO6sPlnyHr2TrPK3HE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737157051; c=relaxed/simple;
	bh=r5WxLE5nVSQ/hddWgTApXUMwA3XMVWbrtVWf0PpZx9Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jOXfPVqrrcLwlB5zpFvSwBH18ink2OFHKq71LiL6VfHliXZTMZf8dSnkUhJiFc5bN7vHet57NGLfwO0xoJ4/uXk/V6lnmTdzgUnCV8xivUyJmOr5hpGOCnnfA8QGRkQ2ivY9SoBR4Ar0SaO0RBmKmhMdHeRTgtTNAX4KqJdvGRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=g9g6qZcW; arc=fail smtp.client-ip=40.107.100.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ysybFAIoXybpo9DOJy88yXcS+yaz2h6WwedqXQHiKQvouLTPEHp1eFWWqSKQd4t5SHf0FA2J/w2WG8By99l5coDG2EsISej1gW4CAb58SOVSTMDUAYcGNoukqRIQm+etAS4DkCTbLnqFaa7wuK7c+jiMdE10uzC9HGnnEEeUgHEUHjz50dsHHv8Rn1j4ZQAbLZWeQGUands4TCponR6dFB9L91liie1TJPBRIeSnYcBrV0jiy0qlVPiC9k2DbUCRE53lyetO2ykwOUVeCZ9UmkYR9qXkvycNuPWUUrOyPtw2MQ3YkQ8Ry6MxQjkzR/sIO3yfYWopMznzlLXFx0WnXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=St2LAUUrqUrDXHyK2khiwFSAFm432zMOMjc5UR120s8=;
 b=Na64Ft/ngU/330X+q4a7wW/OWdL08HhrGTmDNUk8RQxn49uJ8Svu1Dkx/AwelAKx4xhE2keB48AuSe0GbuMoNpiQsampLHGHTlMsdULZ9nJzwVQ2MMMC4n8DZJ1wXkgLAw2B3JS1id/WwzaQZcgJce6uBRRbmeeNuV14PTRmLhPtzFLNVxK25mI9sXqEDa8WwEVcDoOP26OuC3oc7LSlp+QfLB8LrS8xo+tfuAJVphGsAGy7v7om72DDpltLJEaK90BP1xHrPRKinCV6jHMmGrQ35a5aJNab1Fcym8WNYGLK532wJaLgw0erne4CgjCFEbS25QDvviINMwfKFAckgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=St2LAUUrqUrDXHyK2khiwFSAFm432zMOMjc5UR120s8=;
 b=g9g6qZcW+EFuwekWJNNcUKH7OuIVrZqUb5ANxp4uZXnXIRWhyxcXXoHwmiusYh/E+3po5y0bYR3rg0rfOCMBuz3OYvoneGptUPD7iLASXX4HGI7Xa8vQA925DwXCevhRO+BiJu+niCsSQECUUOCG2EMWKrvBtYVtFf6WOzMiyaF87rOf7EZqScl4iGy7lhPJ6YbWdZ8GcP6+6hdnU9mB4uLk7tkJPkRC9cMUASpCNTeox9tc7cBU7yEXR8LGavIQ1uG9yXDXc/x4SSU8ZywKICZbW0d4bkyQvBBlSYn0r8tZBAOrBxr4oxZwc/vt8MuXK0A0nzEBm+Cg6IgXt6X8gQ==
Received: from CH2PR08CA0004.namprd08.prod.outlook.com (2603:10b6:610:5a::14)
 by PH7PR12MB6610.namprd12.prod.outlook.com (2603:10b6:510:212::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Fri, 17 Jan
 2025 23:37:23 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10b6:610:5a:cafe::50) by CH2PR08CA0004.outlook.office365.com
 (2603:10b6:610:5a::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.16 via Frontend Transport; Fri,
 17 Jan 2025 23:37:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.11 via Frontend Transport; Fri, 17 Jan 2025 23:37:23 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 Jan
 2025 15:37:12 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 Jan
 2025 15:37:11 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 17 Jan 2025 15:37:11 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v4 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C link status
Date: Fri, 17 Jan 2025 23:37:04 +0000
Message-ID: <20250117233704.3374-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250117233704.3374-1-ankita@nvidia.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|PH7PR12MB6610:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e71dffb-c070-4f8a-f332-08dd374fe48d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?16ZhtQR2N2YlM8o5pXDBkOW7hg2dWoqQnwcrlJkFkuNBkymixY4nWy1PDYtg?=
 =?us-ascii?Q?QWMTDkdAa+7M5K43pKCqw8c3XTFm83d0ASFySCNb6TihoeMwLIQ8K36WSCXa?=
 =?us-ascii?Q?Pooz/Jubs+bk2/yOgZX4mC9t9v4qeviYmvKsp0bWOwRwiEJ3rl7qQdUQaU5t?=
 =?us-ascii?Q?Ty/jhCm8Km137SrzHGdxppUyWzi+TpaKgidIuBzauwJyGorTEKS9xdqx5Jt6?=
 =?us-ascii?Q?CNRNwyz1Z2Lkb/fZbYWbBfgV0axXeIzdnN2EX0eDFmhVJGx1sMKXF8Rus0MB?=
 =?us-ascii?Q?Xlqk1bqX0Ir9qiOc3gV+Sa2iRhkamzhgZ1rYwsyC5ibg9js2MxjmNYEdmFCl?=
 =?us-ascii?Q?Tcuj1U1+6LG9JgxMH5nKu/CwoKUGcyBHnBL9NubZR52UuZLoog6zXrzujMzw?=
 =?us-ascii?Q?XAttWbGLGj4ppyF2jBpArf/jBFUGYP31vbhbyuCyvMWiqEY0bNUYb/GVmg7z?=
 =?us-ascii?Q?l8oH8nt/q5hCG1p8Gz3YakZ9X0V4CDfRnx93K3h/dj/qOpa10IgTX1kmnSUu?=
 =?us-ascii?Q?t0wvhFJGwGe2dJqvBQrusV7SjaTMnou2twhE/eNMrG16LWMGNESg/4l8NQK2?=
 =?us-ascii?Q?2THCbAWzeG4s/LdGxLd3S4dE9qiO2ZV1PaOu9FsSiXDk5YtgvWk0dDYeoT0+?=
 =?us-ascii?Q?0VxOhU1vPqyYTJvP1Z9VTQnKoD/c0E3IuTCJoV0usP3X3xyFvTIvpJLC2LIO?=
 =?us-ascii?Q?w4omO/nd1vDJNJ78c6p2HzccecEKqC042cOb/Jap12IUzg/DakobekhllCSh?=
 =?us-ascii?Q?7BqxuDNOm7JUJnxDQFL8TJjuXl9c1/tcC/7x2q5RWK1LhzYnmp2+Kk6XNH3+?=
 =?us-ascii?Q?QnEybHRyPWXU942WAogW8Q7zYRMlNjdFC8z9biKDvUIdh1jeIEv+XwKKGCMH?=
 =?us-ascii?Q?lpXlV8kM23hfuK+w8L+xujaOjMQdtZ7VFzUBACSaJyfoP9SOhtgk4XZJAggL?=
 =?us-ascii?Q?SjR5nAQQLV2EsSb243AU6r6ATLRsHjfUWKrKFULL8Z0h4B3TFFPkfJCvwZ6L?=
 =?us-ascii?Q?wWaixf9jdmA8ZoI+9b4B1B1dXs2vx35B1NOx68xSI2K/Ezi9AKU0fdNea/Dl?=
 =?us-ascii?Q?GS3O9QGcIX9CQ3kE8IyepiHLnGdzvND2qI6L2LSUaMBiQNgy0GQOG3Ugiww+?=
 =?us-ascii?Q?OtsbXs6TwoHqs0VfrVrT+Pdx0tySpDtLD2M4Lml+OqFJs4C5xnE7uYKncMj/?=
 =?us-ascii?Q?+aUOyAxLe8mnaICLDaOmsnUcOxE/+iEcYpecVEZPOz8QNUsYALUXBk0309gS?=
 =?us-ascii?Q?Uh0YNdbsqYXiccH6euv2YZUf/HAYs5d3GQNXlAPUMR0rfQFMhKvdnHOMZgQ6?=
 =?us-ascii?Q?FiGbv92D3fnoLoStockKJUfYQWzRMuQG3PIqN2sNSww+d+x8pM2rnEKHxQJg?=
 =?us-ascii?Q?HdtPzay9sU1Z0+FwrVgWdRu9+QvA4LKJ2OwwwLvQL/iTkOYUdrp9a85U5pvE?=
 =?us-ascii?Q?LNuxyvBXS4ybSTPgMBTMjwdMo/fvxYNMmcTc8BylNHainXt4uDlv8j0kmKvA?=
 =?us-ascii?Q?m0JhUVm8oaGYLhY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 23:37:23.1524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e71dffb-c070-4f8a-f332-08dd374fe48d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6610

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

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 64 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c    |  2 +
 2 files changed, 66 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e6fe5bc8940f..d3529d2cc3b0 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -5,6 +5,10 @@
 
 #include <linux/sizes.h>
 #include <linux/vfio_pci_core.h>
+#include <linux/delay.h>
+#include <linux/jiffies.h>
+
+#include "../vfio_pci_priv.h"
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -25,6 +29,13 @@
 
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
@@ -856,6 +867,55 @@ static bool nvgrace_gpu_has_mig_hw_bug_fix(struct pci_dev *pdev)
 	return false;
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
+ */
+static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev,
+					 struct vfio_pci_core_device *vdev)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
+	void __iomem *io;
+	int ret = -ETIME;
+	u16 cmd;
+
+	cmd = vfio_pci_memory_lock_and_enable(vdev);
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
+	vfio_pci_memory_unlock_and_restore(vdev, cmd);
+	return ret;
+}
+
 static int nvgrace_gpu_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
@@ -875,6 +935,10 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 
 	dev_set_drvdata(&pdev->dev, &nvdev->core_device);
 
+	ret = nvgrace_gpu_wait_device_ready(pdev, &nvdev->core_device);
+	if (ret)
+		return ret;
+
 	if (ops == &nvgrace_gpu_pci_ops) {
 		nvdev->has_mig_hw_bug_fix = nvgrace_gpu_has_mig_hw_bug_fix(pdev);
 
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 90240c8d51aa..68f123d17c4b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1634,12 +1634,14 @@ u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev)
 
 	return cmd;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_memory_lock_and_enable);
 
 void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev, u16 cmd)
 {
 	pci_write_config_word(vdev->pdev, PCI_COMMAND, cmd);
 	up_write(&vdev->memory_lock);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_memory_unlock_and_restore);
 
 static unsigned long vma_to_pfn(struct vm_area_struct *vma)
 {
-- 
2.34.1


