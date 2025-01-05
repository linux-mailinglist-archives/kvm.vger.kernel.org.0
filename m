Return-Path: <kvm+bounces-34565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A836BA01AFE
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 18:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E3B83A3622
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 17:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7B61CEAC2;
	Sun,  5 Jan 2025 17:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uqsKPfhr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2051.outbound.protection.outlook.com [40.107.236.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE941CBE9D;
	Sun,  5 Jan 2025 17:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736098607; cv=fail; b=BZXIckS130HrTw4YZ7rWkQKxYv7gQ3fqs1hBLxxbkLYOj0KomIssDFRNrRWRZdm73VUS8nJylrDg6TCWlkOhAya0OjBQLUWvYqVjsONW/VxBBxdVy/Z6lkO1HiB3pUhFou8xFlL1I84s+j508J6M6EIDAmcu5zTZHeayUySBssA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736098607; c=relaxed/simple;
	bh=w/TTA0Ds99GMABc39/0G9IbyFRO6M1tzgGP6A5vC8mY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pn9yQg3523iA5YQGcQrQ4kyNrVo1caMVJ69XdIeXoyOWImbfuBP5IXeaCvhrHZ//x5YqxGXESkDBJhvB5pb1i79hN5//gcnimRADPsw5xS5AP+mmPrNIktQ8PWXoViF84Qz0CrxQohOIxKl6zS9rltnCFhWxnQ78Vitp2lvhcb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uqsKPfhr; arc=fail smtp.client-ip=40.107.236.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Axm2OpQ4plyhSyv3uWe/DCLxhcuNvGthdEfGiaAn/qV1og3HqmlSB87OxK5Hp8YpY3F60cNgAVBt145JJcj+TY6yi+SqGB35m7cklFU1rvDpsDbj76bd2IEpjWoXddeh8hSjIEbyc9urEfEI7+hkHDqy0I61IeJCmi3pM8QDVjesBvQ1Geq803CzFHTHckaCfm1d6ZPSSOlm95JvQFPmf6BeS2FI43ZRNdkRmHkh2hfh2Di+viJ6e0wmZV8xRvMWo6+4bF6KbYufwD242lTbCe8+m0rLQUSuCar9VBbjeeqbgj/W8Hc6Fs0ce71wYneGdiFU8gNL3lcQOua3ur8vDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gXVSh0fra83LxBKWmxkkBzlKu+MRNa+d9Gu5by6C7/Y=;
 b=kqNW/+wpNXjRwkb2yJ+YFHkKPWrkGk3CL0Z9GcQIwBAWQ/yyNlZhlR3q4fq8QMzVAjP7nbLjuV3DPcXotpPCknUBzHW4PcSzkOmE928TzQcnQMwiK5A937a/MblOhZZsNWKdY1AQr59vsPt/0MTTscu0apkArp7wcWjy01d/dFTRZXe/UKm9YYvPmrBdj7PDxw8ayHftrvaKH2TUzvz2K1zFwD1K9JD0nsk4kT61jHt7CgMKRMZCLA6qcoirJDwe/1WdvZs7BmfhOAX4KhtMy4cXBzJTH3wgt85uDdX2P7OggP086X3DvKKb50asUw3RDCHKAkdxZYNf7FWLkz9OmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXVSh0fra83LxBKWmxkkBzlKu+MRNa+d9Gu5by6C7/Y=;
 b=uqsKPfhrUPXbbR7lU0+0JRgTXjp5JMFmPbe22AAamzr+tzH8CIxYZ0GNsgZwtvvJdUFo+Pa+59TKafII5tZx8hFwg9W++1mlBViBy8o5IWhPsS0K7kFNw5DfqiupwyE4PiJ6CX8LYCgMe8He68RumTwe0XljnkxPrHTPGsg/itzOWwMdh5AuhPT2f1dvOb0YDAb19Nn/t9alpWiA264sJsq8Mbhd265n8WknO47gjJ+i5GqshXLZuS180OotY3Wq4sqYEh0sdykb9NVtZ24Lg8+t3fZU/OCeEXqQaqux/c1tDpb0wI9uZ5VtevAKnVVz7f/zuL1ID/utGlAHwOvChw==
Received: from MW4PR03CA0100.namprd03.prod.outlook.com (2603:10b6:303:b7::15)
 by MW5PR12MB5681.namprd12.prod.outlook.com (2603:10b6:303:19e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Sun, 5 Jan
 2025 17:36:35 +0000
Received: from SJ1PEPF000023D3.namprd21.prod.outlook.com
 (2603:10b6:303:b7:cafe::6b) by MW4PR03CA0100.outlook.office365.com
 (2603:10b6:303:b7::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.15 via Frontend Transport; Sun,
 5 Jan 2025 17:36:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023D3.mail.protection.outlook.com (10.167.244.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.0 via Frontend Transport; Sun, 5 Jan 2025 17:36:35 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 5 Jan 2025
 09:36:20 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 5 Jan 2025
 09:36:19 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 5 Jan 2025 09:36:19 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C link status
Date: Sun, 5 Jan 2025 17:36:15 +0000
Message-ID: <20250105173615.28481-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250105173615.28481-1-ankita@nvidia.com>
References: <20250105173615.28481-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D3:EE_|MW5PR12MB5681:EE_
X-MS-Office365-Filtering-Correlation-Id: 51aba158-56ee-4cab-718c-08dd2daf807f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZrBQ6IAAPdhn8PIRcNZMlriEfV34rKmDRH2+WoRK8WI5R7nTSyH/oyJzglZF?=
 =?us-ascii?Q?m+br43RwWe8NP6PIGVlY7O/b4Ew1n5DL5efD0ZhMZUlwZASnL74Q+EFilbDj?=
 =?us-ascii?Q?Q2y3yJxte9zqwXHa7RE6w9aiieTqrFLPXGYtdsQyq6ihqYPV8+EuhG0f7pSy?=
 =?us-ascii?Q?hW8Rl5G1CAK8cNe9uH4prsGmj29a651R3H4kn2LmA/VdnqhVO+8KKvRL9jwq?=
 =?us-ascii?Q?l8qo6cSJJX3rSLeBPm0kY92+NE+Hy+WzCiQIgqhzS2I1WFs0DDtFIDzv12Ty?=
 =?us-ascii?Q?tTPoLpZATJEo49S154xfoK41weXxoz1R1zhjhYlHtD3xanZCrlvxA+6nTXe/?=
 =?us-ascii?Q?8x+hHl/9N7FchdJHid2ywH4tzEKUj6BEHCGE8VUFZjK3TNlCWlUfxYXj5sDj?=
 =?us-ascii?Q?2R0RxPFFcARCNie5Tc9SGoOmlDN5z4ecR5IzkHvQsg2N+iclvLL55lbNCb+c?=
 =?us-ascii?Q?C2phinujSlKIGZbbYjTzh1e3L3O4JPL/WBmnSIy/cvdMXf1spUjkD0WtbHya?=
 =?us-ascii?Q?+EbUpCbnKApxqeya1iho/iI8sJc/BWrrajt+3pPLoZCeylTVnvpEj/SjWgkD?=
 =?us-ascii?Q?GoVW9mDHP3hQhtuhspyKZ6ykwQOIgCTAXx7fLh4azEa4nBDLQw0PZ+VQhKAh?=
 =?us-ascii?Q?hF8xFuSaBAbGL5MFTf0UXUy6kJHZywG0eLUf7wirlcC1Y6x7BN7XCNWReJ3a?=
 =?us-ascii?Q?2dcSEIYsdq/S4NTJgOPLFR0OI7M4LPu+uBf3Muy+4YS8IJxtj1oR5ThREuFW?=
 =?us-ascii?Q?Khruy20InZK1q50akGmwO4heQct33q4v9Txa9Eoyi/pPk0J/nWiDoGgf8Vcr?=
 =?us-ascii?Q?VeruUkkClqFx1t2F5tYD0Dxe4nXM/TKJBAmnaUo5ixcujJuxrC2WyQHDD0gN?=
 =?us-ascii?Q?lnDK0AMAvfGoXhyFlOevxjVNdTV4LVZJS3WdTMv9TRT91gAjm07+GoVV2OX8?=
 =?us-ascii?Q?Q6koSDhyqdPHH/sXlDzjAO4MZ1cb2PnTrh+PPxgBBogYw8nhqHyffI+wIDp4?=
 =?us-ascii?Q?87my/QilrMdINpBRwhfuSsadDQKlN6D5c5HPyqHUi6Dx6WmUhZunRKnjxKLy?=
 =?us-ascii?Q?Vcou++Z3ONMEawzfU3LAMyy4Q+IuycMrV8LnJRxRVscPyPp/RGYTqTwa7820?=
 =?us-ascii?Q?lDkV1TyUl/f4PfIqFhHjC7U9PoppD+JZX3qk/d1YRtY/n1N7mO+7EB2SzVOv?=
 =?us-ascii?Q?ZYNJATl2tBhs6tX+jBOZKU6MQ/sG3RGdJgDO2Pk+8Z809mkdi/wToSeKQe77?=
 =?us-ascii?Q?R1dvw/hquWppvKyJjq9iUL15Qlo7F+ILOLNOajQQdleUXzhhPzLF2fBcOVlL?=
 =?us-ascii?Q?hNUrFomUa00iOjTx7agHqLpCBl9CCMlCc+hFDJME6hR+patv3o6FC/3y2blT?=
 =?us-ascii?Q?MLF2t9kmrtEyrBM15pIDXZqKIIP9Fq6OfRNmwApCJoY27zqtWeyDe8qNsHE0?=
 =?us-ascii?Q?WQjDCqzAizleAe/lRRRungADlzxZhiVG/sgitzrsi0GrTyHzHoiUfg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2025 17:36:35.3434
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51aba158-56ee-4cab-718c-08dd2daf807f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D3.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5681

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
 drivers/vfio/pci/nvgrace-gpu/main.c | 53 +++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 44a276c886e1..cf020496743e 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -5,6 +5,7 @@
 
 #include <linux/sizes.h>
 #include <linux/vfio_pci_core.h>
+#include <linux/delay.h>
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -28,6 +29,13 @@
 
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
@@ -848,6 +856,47 @@ static bool nvgrace_gpu_has_mig_hw_bug_fix(struct pci_dev *pdev)
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
+static int nvgrace_gpu_check_device_status(struct pci_dev *pdev)
+{
+	void __iomem *io;
+	int time_elasped;
+
+	io = pci_iomap(pdev, 0, ~0UL);
+	if (!io)
+		return -ENOMEM;
+
+	for (time_elasped = 0; time_elasped < POLL_TIMEOUT_MS;
+	     time_elasped += POLL_QUANTUM_MS) {
+		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
+		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
+			pci_iounmap(pdev, io);
+			return 0;
+		}
+		msleep(POLL_QUANTUM_MS);
+	}
+
+	pci_iounmap(pdev, io);
+	return -ENODEV;
+}
+
 static int nvgrace_gpu_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
@@ -856,6 +905,10 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	u64 memphys, memlength;
 	int ret;
 
+	ret = nvgrace_gpu_check_device_status(pdev);
+	if (ret)
+		return ret;
+
 	ret = nvgrace_gpu_fetch_memory_property(pdev, &memphys, &memlength);
 	if (!ret)
 		ops = &nvgrace_gpu_pci_ops;
-- 
2.34.1


