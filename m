Return-Path: <kvm+bounces-56726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82393B430D4
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44013172F53
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD76242D86;
	Thu,  4 Sep 2025 04:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NvwR261R"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECA623814D;
	Thu,  4 Sep 2025 04:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958922; cv=fail; b=pMQ9mrGi3zspdHwYmxErvlDBic940qEIytzJBrS2It3lF14BKf9ZuGDD02rQVoAuRiAk6E2yzUroBpv8UqNFcLqEaY0qaUC4jTgec4uNAIRZYULmlr9E8MI17gYnNZjZEIb1fyG0ALoodiDh4d5YItkiSmP8ZTKrc+QeK7u6UUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958922; c=relaxed/simple;
	bh=bGzlAZvsc4fthEARNPfenMfbu8H0L9feoFQAmiy9+vI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I/B6Sd7HBJRVtzh/PPkuCWZoK5oSfzfvzK/tROaUG/617Wuf+qfEOAFZMroTve+DK3TC+Y3tM/Wq7CCiIlCjbpQw4aahCb3DLaiyjjGtWXfIn8N0fRpkqhv6dCdlyrj+dMlCjFUr5RA0ZMEe2w79Qa/6Q+dOWX6NVcLirsT0csY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NvwR261R; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DqNy/HYJES4y42S1jxHEt05foTbFuQ4uBBFLHD+aGAnfoVjtty2ndzX/i/j/Bysw/EDl53jjLqP5BWdk5okOAkXq8+d1auYIyOjbSnupO8s1omkALGGwcry1t2CKw7w0KCsjyLJkxnp37U01chmuJmLo8VHp54LFfCmePCWZXKr4Pu2XMCzGlC/i+jkpjchROLde0IMyhIjoESbFWlyE8gHiph6yXWU8K1kWcymdbyxeDM1Cuez+YoRO+X6xy/q92x22cGECsVQuiQAb7Gmm9OftHvMhnA0+dEVHha1nZ/ZpZZK0EFIg8ClFSi1RMyy2o5Y/qSHYTzQ/K2xvAeDmXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f3R5prkxlUWa+i6h6zI/FTbRbejLI9P8nFF/IddgsNw=;
 b=wyhzG3zmFegDz2NjFvWsSCSDw9bYaZgs1pHVb0NpYJn/8n0V5hXz2M/MsmCDzMKS5VlxYbPBHrYqL9iGmLZHiQqhkApO77BKSOLKIZ17vNzaCCvPUaqrmCIrqsAKtYgrxCFqbTGdmVPLjkQliMVnLYqWkrPaFzG2uVx+a0DmXhHRUjF19WYXS4nImqTp5OGuzcsyjHEDzu6yHoqJWchMjynsMKUz3DZsFflhM5pXQaUhEofP4wp7fqNVDbqTJ471ELNElmj9KmE8ruEvf9Q87Z3PU5B0RECbniJRzX/jc+jRiPUYgmym+UcpXQ+8Qcxug2S8bwoNnCJCO0IZ5IHdzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f3R5prkxlUWa+i6h6zI/FTbRbejLI9P8nFF/IddgsNw=;
 b=NvwR261RBtl0aIT+2jstiiSzKGAh2s95vGjTaJ96dUumW5XMxhAyrEMKTCOBYDdPHgZD+R+cXjvGe7BpWBF96X8qWBitgiabFdRbYOedwpQ+k3wZI90OWx6cVkJEsCJeQpLTUwiDIzX5lnCqLQYgkIFhZ6irCqEhqb5073+DbJ0Ug85YVSyjaH2XrhFQNdZIPn8FCim8r/IPlihAS2lBrAem1eXzQNzPjp43OdU3JZJVF3wd310ydZhhvUvw0vf7MsIMrafIVANEum2/zd55VBM/F6rten/ryJKmRXoTztawekT2S+5U0G9d9zktWtUV3LBRHDGJWLVn8SdT6RrAKw==
Received: from SJ0PR13CA0175.namprd13.prod.outlook.com (2603:10b6:a03:2c7::30)
 by DS0PR12MB6535.namprd12.prod.outlook.com (2603:10b6:8:c0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.25; Thu, 4 Sep
 2025 04:08:37 +0000
Received: from SJ5PEPF000001D2.namprd05.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::e9) by SJ0PR13CA0175.outlook.office365.com
 (2603:10b6:a03:2c7::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.7 via Frontend Transport; Thu, 4
 Sep 2025 04:08:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001D2.mail.protection.outlook.com (10.167.242.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:37 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:31 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:30 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:30 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 04/14] vfio/nvgrace-gpu: Introduce functions to fetch and save EGM info
Date: Thu, 4 Sep 2025 04:08:18 +0000
Message-ID: <20250904040828.319452-5-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D2:EE_|DS0PR12MB6535:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fa2f89e-6b91-41b1-26cf-08ddeb68b94d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ktFPMHOgZozTJzxKxeuL3qMg0U9iZl+VHjl6+oZFO7NX4jQllFJ6P1AL2T1Y?=
 =?us-ascii?Q?ciPclt/u2+mLYMnKBFyR++7HU8F96ehdewl3iLSlw39dc8y/ckpwk0ZUDsSi?=
 =?us-ascii?Q?XWr+WJXrePVXStSIqq+LO3b4eEHXUnNBHePk/6pIJD4yd7AsxyhOCM4df+J6?=
 =?us-ascii?Q?LwtZc4TuCnsM6Y8RuRG67tdaAHJ4910wQzjsRwdTko87ZVTtcc9KUvpddLal?=
 =?us-ascii?Q?5ZpYJ1doae4SPPNEISBc/Zy4zfNzctAnWw2hfZJ6araxic72l0ghv7TJnmJe?=
 =?us-ascii?Q?MvtmAN8GpoCO6/MTmNmSTGRLMED6qFpoFBKjl3jMp28B1VNIDn/HDlDNQ8ds?=
 =?us-ascii?Q?R9w0pjQ74If/LLCBGYjyENU5hUWKb6mX0qjlQzMOwmxusi5X1j1bm1r9cw1I?=
 =?us-ascii?Q?OEXUKpoVbv4ulz0EWL73FSoPByOr2TXL321ruJH4rZwpj9zVb7wAR9MrREPK?=
 =?us-ascii?Q?wQBbBPhAOpaOMS5Goy6v0IWqdPHs1JKfOyCZbau6PVGPklk1mvXIGmgKpJ4w?=
 =?us-ascii?Q?r2b2dkQmcGX/d8+Ri4TshdyvVLtgwNjIVf+yVBVM46YVTX6YwItuqmcbkpPJ?=
 =?us-ascii?Q?PeGTUQREVfD/nusm9TcEBBQFAe2fiNfPcPdunwVUHF9cXHD8Sa8MFbUDWF6T?=
 =?us-ascii?Q?grcxO/iln8fqQH2e+AZ92J1RqpMRXYwgfmV8O8to4sm6Q3wL3/GNVqikc1aI?=
 =?us-ascii?Q?lzUt/VBir7EtUrchqNbIuA5Q0PLQCgfzIgn3stuHjUIhVUO+KresdWcd3pHG?=
 =?us-ascii?Q?vakUjOWtQRbSNgLH5br8QjD4pfLaB4RY4UyHakMusqS/dOIxmVVJTH+59jzb?=
 =?us-ascii?Q?ZRSue9pvNpu6mbVm9PlvXy2reIVLaYOcLhgcfKiN/7be6k85PLA9zsKLcC52?=
 =?us-ascii?Q?1czJrbFswpMi6AYjHr1t50l2VAnuZcoCF/INvhNzwbzTzCAUJfBVBvVl2QRz?=
 =?us-ascii?Q?RBshMIU9eyMyugc3ycslalvuqnkXVJ38Z9vQxsu/xBtl+Q9ArvAakYuoAEfS?=
 =?us-ascii?Q?SbRjVWvhYpep9fMlyzMNo/JRlQZnmjHQa5FJJEl9XUKLCmXjLvYeqg3mFA/J?=
 =?us-ascii?Q?akjuFsVbWa0YuSsycyGZzfcTgsMfBJ6yKAipj88r/Dk0NA2j4ZTgmmVDZIsg?=
 =?us-ascii?Q?aEQYXc8CQBCYH1dcQzE7y6zCLZiOCz7GpJ4LXNdiSu9FMyOyOVAqerwMieFU?=
 =?us-ascii?Q?KHIZoyPytZMW7MgsQM7AnRcSj9QMqlKp7qN8rt3ivfMf7GQh/G9SzObaDS8q?=
 =?us-ascii?Q?L+bIYBU2LTykT6JR3PYhkenKpqPMnAFRDChLXdUQD1u6Sdpr+5Y27P0cNjjt?=
 =?us-ascii?Q?Zvpv9hG0g24Wn6hnmVbtCfhKfozwRoj2MlHAd+tviNwUU79dxjiSE2r3L6mw?=
 =?us-ascii?Q?dgWgEKEEUJyFlAv81tk5khX+EZ77IYqRiBGxpM2teSKNX6WGA+94psBANYCt?=
 =?us-ascii?Q?wAHnQyabNBjKl+W/35nbuoidxn/w0MxEp7eMQ+JLZ6a4DeSsIEWNfl6Bptik?=
 =?us-ascii?Q?pa40ZlMcwW6iiIFXb5MEInOyUJtD7XVwlvK6?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:37.4095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fa2f89e-6b91-41b1-26cf-08ddeb68b94d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6535

From: Ankit Agrawal <ankita@nvidia.com>

The nvgrace-gpu module tracks the various EGM regions on the system.
The EGM region information - Base SPA and size - are part of the ACPI
tables. This can be fetched from the DSD table using the GPU handle.

When the GPUs are bound to the nvgrace-gpu module, it fetches the EGM
region information from the ACPI table using the GPU's pci_dev. The
EGM regions are tracked in a list and the information per region is
maintained in the nvgrace_egm_dev.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 24 +++++++++++++++++++++++-
 drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  4 +++-
 drivers/vfio/pci/nvgrace-gpu/main.c    |  8 ++++++--
 include/linux/nvgrace-egm.h            |  2 ++
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
index 28cfd29eda56..ca50bc1f67a0 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
@@ -17,6 +17,26 @@ int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm)
 					pegmpxm);
 }
 
+int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
+				   u64 *pegmlength)
+{
+	int ret;
+
+	/*
+	 * The memory information is present in the system ACPI tables as DSD
+	 * properties nvidia,egm-base-pa and nvidia,egm-size.
+	 */
+	ret = device_property_read_u64(&pdev->dev, "nvidia,egm-size",
+				       pegmlength);
+	if (ret)
+		return ret;
+
+	ret = device_property_read_u64(&pdev->dev, "nvidia,egm-base-pa",
+				       pegmphys);
+
+	return ret;
+}
+
 int add_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev)
 {
 	struct gpu_node *node;
@@ -54,7 +74,7 @@ static void nvgrace_gpu_release_aux_device(struct device *device)
 
 struct nvgrace_egm_dev *
 nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
-			      u64 egmpxm)
+			      u64 egmphys, u64 egmlength, u64 egmpxm)
 {
 	struct nvgrace_egm_dev *egm_dev;
 	int ret;
@@ -64,6 +84,8 @@ nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
 		goto create_err;
 
 	egm_dev->egmpxm = egmpxm;
+	egm_dev->egmphys = egmphys;
+	egm_dev->egmlength = egmlength;
 	INIT_LIST_HEAD(&egm_dev->gpus);
 
 	egm_dev->aux_dev.id = egmpxm;
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
index 1635753c9e50..2e1612445898 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
@@ -16,6 +16,8 @@ void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
 
 struct nvgrace_egm_dev *
 nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
-			      u64 egmphys);
+			      u64 egmphys, u64 egmlength, u64 egmpxm);
 
+int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
+				   u64 *pegmlength);
 #endif /* EGM_DEV_H */
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 436f0ac17332..7486a1b49275 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -67,7 +67,7 @@ static struct list_head egm_dev_list;
 static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 {
 	struct nvgrace_egm_dev_entry *egm_entry = NULL;
-	u64 egmpxm;
+	u64 egmphys, egmlength, egmpxm;
 	int ret = 0;
 	bool is_new_region = false;
 
@@ -80,6 +80,10 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
 		goto exit;
 
+	ret = nvgrace_gpu_fetch_egm_property(pdev, &egmphys, &egmlength);
+	if (ret)
+		goto exit;
+
 	list_for_each_entry(egm_entry, &egm_dev_list, list) {
 		/*
 		 * A system could have multiple GPUs associated with an
@@ -99,7 +103,7 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 
 	egm_entry->egm_dev =
 		nvgrace_gpu_create_aux_device(pdev, NVGRACE_EGM_DEV_NAME,
-					      egmpxm);
+					      egmphys, egmlength, egmpxm);
 	if (!egm_entry->egm_dev) {
 		ret = -EINVAL;
 		goto free_egm_entry;
diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
index e42494a2b1a6..a66906753267 100644
--- a/include/linux/nvgrace-egm.h
+++ b/include/linux/nvgrace-egm.h
@@ -17,6 +17,8 @@ struct gpu_node {
 
 struct nvgrace_egm_dev {
 	struct auxiliary_device aux_dev;
+	phys_addr_t egmphys;
+	size_t egmlength;
 	u64 egmpxm;
 	struct list_head gpus;
 };
-- 
2.34.1


