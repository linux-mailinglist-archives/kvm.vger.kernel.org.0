Return-Path: <kvm+bounces-35791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3241A152CD
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:24:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 033AC3AB925
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 15:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F075199E88;
	Fri, 17 Jan 2025 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T4zBEWIx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23559194C96;
	Fri, 17 Jan 2025 15:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737127428; cv=fail; b=S3dQI1MPaFLwMxQljBX+DBeoymn0xgSq5IiVcKhTCFWOqg5YFqS3s+q9H7mHep3ehEmSSAnh3MiaxVVHYfrid3SpyMBIckKWx0mT+j07r7L7anKKhsPYxVZb5s/irtDG0EcR+w+92qt3Mnr14z04hjlqnfEGjPOyogmfMaCv6FY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737127428; c=relaxed/simple;
	bh=4g+McOsEO4W+fW6yaUavD1vgvaitbFDc65TBu1Ncd80=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LzHALJ01WiPVYmqCddrib7fxECrm5gt062UNrKVBhsAFowfrEf6/ppAF92Pip3tn7XalzPkMlAkRPK2k0C+EE+r5VwBLoBFfHcq+QhYxZLlDjSomGOga9XUoykM0oQqVS8rh+2u/hX2XYP91sNrcUy27iPkbbfnFaPzMmbBb5gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T4zBEWIx; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vq3OqNvlVGktjOoensB9plpCPUJo4wr3WSw13zCPW+yJPMks6tMdWlxiEncVFUJ6QX+4Fwcsc9BJPgVtcoCNm5SEDejNXkjlAbnMZOWrNGsJT2WF7Vc1mgV+OsHJvcBidJcJ3qmy+uwq0oMzOuPf9lheB4ZOf1kbRW8rWWFsF55xjBkAzp/uH3+RRTtfX125Zb7+Xr7v9jGpZwCAOXF5hPHdftmo3sfdJ6RM+KCW6Itv5rfyDXtpkvQOe0AxfSses5BP9G450FyrLPYJr+fn6eUCqFhduRWdytWvGXq+OlT8na3Xedfa9CGSxuGvHxOFa3qmQtsoY0iozkKzGVe5xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8M5M0qQzWhBJT8I+3AzUF1zqzyEVo03USrXhwZVuWJY=;
 b=RTfrtuJ2fsV9xzBNXA/3kME6yWWjbwP+bl6liVRP0u80PcNUIl8RArtWPY0J9LHlf5NcIRYJrbKyOIyVyu9XqXhvncvDyCobKsKIO8b5dRVXaZXy/RL/eqs/jcwY5u50Xqek7pvZGQh6QbNProxipCSGCHrUdh7sIqBM8KUgp432rV2uC8V5D29JzQZFhGCrhmK/2Z2NPAr02BldwegUu2sWiqxo0fUW9FWW37Teah4m92Oexbwx7znEUEzWqJye8IpNu67Za7l3s3TuG6nFRYFFG+LR9Y+Rxkhj+mtgr5Hp6lLgj9jdna9nSAcaP6FcvIGC6vf9mNMY9Atq3Y2JAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8M5M0qQzWhBJT8I+3AzUF1zqzyEVo03USrXhwZVuWJY=;
 b=T4zBEWIxG4mIBgF8Z1VXXWLMhQJtOGowDR/SbnIKprAQ8eMZyyixtwnV7r7scZhluKCrTz50aHW9Il0hl3DjBA1K3WpzzSo5Vc58CLN8h2D3mW9mpZsC2NB4hogdkgncQSUYD4i4Wpd5f1NWAoB14c/ud/+9aeMJlLLOVyvg+R6x3C1MYqVSxdp9wpHZ4coiMvjk6MMdZyy3kx1cQ2qH2ifVxZvJiWeSutCWgnznlPoffNWjo0TQYzyTsMHJ6jCY2CWyuY0kih9657Wq74ZK1UUwr0vwDg2TXn4wM8ZPQ9dh/eCmsjmVNoD/x/0Tbm/EMrMWsbunuR5atTE8cxMZSw==
Received: from BL1P222CA0017.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::22)
 by CYYPR12MB9016.namprd12.prod.outlook.com (2603:10b6:930:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.16; Fri, 17 Jan
 2025 15:23:41 +0000
Received: from BN2PEPF000055DE.namprd21.prod.outlook.com
 (2603:10b6:208:2c7:cafe::e9) by BL1P222CA0017.outlook.office365.com
 (2603:10b6:208:2c7::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.16 via Frontend Transport; Fri,
 17 Jan 2025 15:23:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF000055DE.mail.protection.outlook.com (10.167.245.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.0 via Frontend Transport; Fri, 17 Jan 2025 15:23:40 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 Jan
 2025 07:23:39 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 17 Jan 2025 07:23:38 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 17 Jan 2025 07:23:38 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C link status
Date: Fri, 17 Jan 2025 15:23:34 +0000
Message-ID: <20250117152334.2786-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250117152334.2786-1-ankita@nvidia.com>
References: <20250117152334.2786-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DE:EE_|CYYPR12MB9016:EE_
X-MS-Office365-Filtering-Correlation-Id: 5327fa5c-1969-4b3d-ed7f-08dd370aec2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zHSZ5EVafuB1oWSZd625jfOw7aZOJU5nSWQdJiMdsen+5JAYzB+1aDsL3Iv/?=
 =?us-ascii?Q?XZkXZ9Vi6J7ImdLf2FW377id3ByMBIkK75HENC4ZBlaoyjIMgQRa7OX7Pvgy?=
 =?us-ascii?Q?azFrgp9+yHJzgEMYhGV9M1I87CJoKGKyWL8Fbxh4Y93hXkzN09V2BFm6EOsK?=
 =?us-ascii?Q?7ZxZbIf/Tgt/xyIQKKfOnJat6bjNeG60V6EI77mZEFGP5hL/mt4VoXefrRk9?=
 =?us-ascii?Q?IHs4RM39Dq4ZSHghtFAtySBkBMMYKJiI3hJZrvndr4OtrTFoPeH7c6p9fNYb?=
 =?us-ascii?Q?kULI0Ei4QVrmG3691RED08GU5dKB4F1b3IEu9FVTnB6F2SQdswzgwRw8Erjn?=
 =?us-ascii?Q?l1KKVkGsGHx7L6t1wEHKwuC02IHZZGxxAfD3J/zE12xWIjPJ8BdRU1fzFgc8?=
 =?us-ascii?Q?96z3M17qV+Vxpx/2rlite7Q9ymF2iC7AtvBGMedLQ4zkyU0PJytPd3RdDUs2?=
 =?us-ascii?Q?XAaF8S/pZV3r/GrF8v8fFxlJ7hSFAhlKqN+LQmhNQXj/91Ed9u30ZIPRU7Go?=
 =?us-ascii?Q?8sjUgJWsJgR7OBftPC+9UsvWXIJqwBqpE2tUNp5fjSWWn4pcYh4rhECmRjhi?=
 =?us-ascii?Q?NQUDh4D6QCHcwptf1PIUbdv5tiz/IvmTz87W1dYJ0WRhE0RoQIeKpcfqS9td?=
 =?us-ascii?Q?2txMXYXa96faXxtEw5paG5+YPdzjyJ7KIG95pK3TGs4ksCEgcJfH+yneI9G8?=
 =?us-ascii?Q?aNR9mJ0Gmw8Wv0xlWw7dT5CsKXT6KQKI9A7qfoPOcv0OkvKmOtI9VaGcs+5/?=
 =?us-ascii?Q?ltpAX+5/WszURnEVJ6Zunc53kFCL+Qp3QFNJ9ru4lc4E3a3etD2v7eI7G2T5?=
 =?us-ascii?Q?dT5mE03OEOCTdBXbBLFlkZh2J71fbmeCLlfbTaMZ/WyJ6SZaXa+tBtvXOBuZ?=
 =?us-ascii?Q?LuTZAVEUjAqMXFt8otGTJF42WptZ5bj0hRfsh7YUzI8ds9Y/YHOoOyZk2Ndw?=
 =?us-ascii?Q?JlrYZTYztCNdDi8ypecRVxNstBtvmhJ7Z3P4UExsff+i5VOb6kMcK7mZ4wMc?=
 =?us-ascii?Q?ogNAiUOEt1LEwGwLfb2kHcGhmiQz/9TPXRtTwYCBNrGlHNSgiM+xgOwohdHp?=
 =?us-ascii?Q?lxSQLUHkPv+OBiUlcq/ODyRfknPOVWZ3+lM5HT8C0ZjACF64xiCCIDYoPkgs?=
 =?us-ascii?Q?gYdaZZNo7r5hsQlnFSQnhMsCJudNI3a9rWpz0bzLWYyiegTkpvBguu4zhH55?=
 =?us-ascii?Q?zPhAwnd+xfKEWyskryzGgUQg6x0tJZebtCxZXHHOhyxQqFfD9ZyewJzR8qdn?=
 =?us-ascii?Q?XcvlsZuZSnw6JWThcT74ONm/WoZcjWKwZN7haY3CbKQNrJXJsF86wQTfRF9P?=
 =?us-ascii?Q?5/Imo4nnwzwhpmrGVuk8aX3O+a9x6OjiO5Pq3jWvsTfWW9PQ5/3Pn6hOOiEo?=
 =?us-ascii?Q?IeuNyERZxQUAm6p2NZepqRYncQdmk/KzxfgG8Y+4KxsrXFPyz46kvW2hNlJW?=
 =?us-ascii?Q?QqO3czbKE20lZavxGigLZyEHREr8XgWgNBONqqLPN7QO0h+XNwSHMA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 15:23:40.6302
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5327fa5c-1969-4b3d-ed7f-08dd370aec2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DE.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9016

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
 drivers/vfio/pci/nvgrace-gpu/main.c | 55 +++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 89d38e3c0261..6298e7f0fe1a 100644
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
@@ -855,6 +864,48 @@ static bool nvgrace_gpu_has_mig_hw_bug_fix(struct pci_dev *pdev)
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
+static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
+	void __iomem *io;
+	int ret = -ETIME;
+
+	io = pci_iomap(pdev, 0, 0);
+	if (!io)
+		return -ENOMEM;
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
+	return ret;
+}
+
 static int nvgrace_gpu_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
@@ -863,6 +914,10 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
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


