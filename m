Return-Path: <kvm+bounces-56737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1285EB430EC
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A9471C23BE1
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06DAA2798FA;
	Thu,  4 Sep 2025 04:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kIhXJNNq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E722126CE17;
	Thu,  4 Sep 2025 04:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958932; cv=fail; b=HRKgm1hi4euFMSGAb5bqcqQ+3xXBFiNmwZCofFgm5IR3YgLITcDcmT/MfnxTJgPI5E1g0icdVjscwXWlAHdaWAIuQDiuBGHqC6I5yN+RP30LYgUsfBU1XHDcetEM5UNMenOBJirqZGPX8RiUj/miMm93byeUB+9qzAAlmdqHrRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958932; c=relaxed/simple;
	bh=ZFikG7Tjp8zlLVutDGVh3X+rA6wse6HV9rhb0jT2VNk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F6cXcudKhul2Jt10ujgxvGu3NLjrQT7rlgGqUsx627v6k1H2zXsDP3gd6FMK73Uc9Ln5ZhJA1vt0Oq7K1s3fwAnONLYKiEEb35Nb7p6rwvgud18K+wrbIudmdanhkCeEITRDKtrxJlTZxt5XjKvCVkC2+6o5EGcFpojM4iaXN3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kIhXJNNq; arc=fail smtp.client-ip=40.107.92.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rU5BXtxjX4brIovHJpPC3y8TUlJoQm/u93pPhUUBRg5Ee29M+gw99P1O4XbAiu8Q8+Hrq8PI57gJsHmFmI+ZAOLSJOJk/ROw50W+g2DfbUgbJpmf9Xz0UcrDJuSLN4wbbw010dzdNi72QvxS7Mg5UQOLGY+zAzzWjbiWXDhSsIvr811Ik1Q0LUQYzr7rqSBbkoW1a8DZglLPVyZ7MSIxe3Qoyjdud0VaZvjSramlJEyJ4t7BzHYf7VuZbhf5wiRSWS/YEWuW2c8YcMRvYE0C23hTlKoOJY+MSPwikG4Iio7entjof6rXgyy7lTy5FQSwXbipRg5Ia1Rb4Kp13y0aZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EabDFE5r3erzRQEbAWOqlFl95J5u923xUXoF5yM2Qp0=;
 b=jFAC6EvmMR8jUBprXQz6Ohoo4HUt+BaIzzupFUsZdLp/NkcoLmZ77l2HodGtpGdHatZdz0KiYtgGKwH7X4ZJsYPheiUnOsecsvY1kfXabrW1nymtjWMXwZKxs3TB2Ea9pggaVBifU9dXi6nJsMr+4EolevuRxMX6lGwXbPSxj6THboqnAwvoAVd2nbasgF0vjfM3it64XxTYUd2VJ4ffMDEwaMFwivxjm7KhnnwsLtRpws7ojqMx4GfmnaATOdYTfpGY7KcoiVVslNxhiY71Nib/O4Lbr0I52YAWZK4mmRMiKigi3PG/v+E07yrV1itFqAdWwG/NWB9xZEWBbzIhnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EabDFE5r3erzRQEbAWOqlFl95J5u923xUXoF5yM2Qp0=;
 b=kIhXJNNqBqLQufFEQGTK4+tT5dmNxMzcxGVCRCwATaeqTJUctUvuYsX3Vqry8Onmit/EeQLHMI+zRNXZqkK7eGlAS5JDqqDBZ9Qj2Zqqv6OyNXOz93/EdkQU3Q8AN6JcCt48SGx8Q6HbAFQqrEGFn9CNLLPpi0GiKKJdmgNnwWRKvLosZJPHOEWz4A5bAUkgh818l8bkxw/B2yYKlwQlTgn0Y5Gb6UGuT/c4SmSmIEnYCfyxU9tuAhOqr4JCgllT9sDZNUc8YylA9oHtDHpS1hm9NVZkWIUDmsiaBewamSDjt6mYAOEhQ0+81bAGu5ZNs/8vidzLXF8YhnizQVOY+A==
Received: from SA9PR13CA0139.namprd13.prod.outlook.com (2603:10b6:806:27::24)
 by DS0PR12MB6656.namprd12.prod.outlook.com (2603:10b6:8:d2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Thu, 4 Sep
 2025 04:08:43 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:806:27:cafe::ce) by SA9PR13CA0139.outlook.office365.com
 (2603:10b6:806:27::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Thu,
 4 Sep 2025 04:08:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:42 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:33 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:33 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:33 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 11/14] vfio/nvgrace-egm: Fetch EGM region retired pages list
Date: Thu, 4 Sep 2025 04:08:25 +0000
Message-ID: <20250904040828.319452-12-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|DS0PR12MB6656:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b5058c7-5d78-422d-bfef-08ddeb68bca0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wroWYFKwhzE5TWbVE6QKsLjy4TJ4K50RQnJAzbvqOZ8EF7APlanZ5QAwC0Zg?=
 =?us-ascii?Q?2VxflgzVrVXeHjgFogh28JV8RujMIML4RxoX3jKeQewLsW8/rcgT2hS++R2k?=
 =?us-ascii?Q?SBGCC07OAuqlRjeQaII/XNXE9t+Gz4ejuJhCb6wG1MJ8Srj1zZxP7i4Vgmpl?=
 =?us-ascii?Q?o6l2Cp839vNNiAxQEq0nH7u7BjN1Ufnm3pmgufjZDojEGc6Eh29iqX5llgM4?=
 =?us-ascii?Q?A1FSknbKDIuMtxAYHZtkdoGoLc2pukWCItSsWJd7dt/6iZBV5aUOJ6r4Cn/A?=
 =?us-ascii?Q?HUE/NuT+TNp4xqC7sRWBcbZhqN2NM2Ixe1zfC94w81pOANIIBk7ExrEOrjMo?=
 =?us-ascii?Q?o7HU0q2F+GEbE7nuo9TAwy1+WRUSk9W6R/DY4oxgPuRfTbJyHyT2frZVWR31?=
 =?us-ascii?Q?FGUzmT55GkuTS83BzJfjeCQYf0PXi329OvBtrWJbqXKC3A1l0y9KE/maIXRE?=
 =?us-ascii?Q?t6LldHxTvm17+s2AaBZEZDV9vYRrbXQN/dahxDr5a7w4YjRHcGI+cZaIrm8n?=
 =?us-ascii?Q?5rsJ/bVMCvHx14M8fG2pprWdo7Ft2IRHNHymrXtm64UGrlww/1unSmCPjt1H?=
 =?us-ascii?Q?hdFxPt/1O6LiRISUSWwDeF2ulobXK0Q27HgN9Fnk5yPaCGfEshWEXXC7NHDR?=
 =?us-ascii?Q?Nz1xzjovH3R/vlJ9z/kvcOCglgxuLoM6TC2q3vvJipoG0Hkbd0HRq7gpmlE9?=
 =?us-ascii?Q?OiO7uWiQd+sdb6PH7MPleCf38Lt88cdqRDU8wIUmt8tra+C94lQdgRMrlTIl?=
 =?us-ascii?Q?vvsgkxgtuZL9NzM9HvCZjsX6qc4sv7k10NeGRK9vVujfkG42bcKw8mm/sIsP?=
 =?us-ascii?Q?ABdcB8s5JuqiD/iPgvmj1vHifIPxcKo42+KEC9M75K/HzFgfpidzzdeLh6So?=
 =?us-ascii?Q?ImCBqRdv9mbCdUl70wWHcDu7k+qYZaob8PMyrpCrZJtowktZqqjVscrW7n2S?=
 =?us-ascii?Q?nANzTGfEPeemZD58V0yXnzHOwWSyxhEaX3FFxGJXR0pO50bg7sGvq2hvQ8gf?=
 =?us-ascii?Q?i2GPcSsHrx6Z1DNBcecvQHgw7ZRhdBN4kkKw/6qQUAoRiFrbeos6ODiF2uUz?=
 =?us-ascii?Q?108isWKWZlAy7wMnpEF/VTjNYc9ZdcEXQmRZ67jT2TZXQHuNS1seM98dMGTY?=
 =?us-ascii?Q?bZmk9c1KczqGo5xNNInXmJ4FnOOljT+jaE+yzlvLC8aTZWsL911QiDDPYzZR?=
 =?us-ascii?Q?TEyfqIAMnIPIluEPCG4A8loTlBpuPohtQt49E44SR5Qf7ranJ/RghzoiTWM3?=
 =?us-ascii?Q?okcGFKMQpabxvKn3xjMRSpuXc7KY4ZrnR9fG6VhAJWF5l8zrh+Dr9CHSlbSc?=
 =?us-ascii?Q?rXX+fJvDnaScXSTkXXoxnKFI8t4u0G3a/if5/FBGJdkfvs2AS7IjVM0Sdluy?=
 =?us-ascii?Q?Gf0l0LstVlTcH4StKjeGzWjxorrr0RkOmB5KPBdWs09wdzAqcy8TQcOsJbb/?=
 =?us-ascii?Q?MALZ4IJtRCEanGp+sPmNSo3f0l8Xfq6qza0GVy6gm7uXkf08bH2mDQovFbyH?=
 =?us-ascii?Q?uL2AKuPUnsE5wNXl+BWebHRjwS5OIwI/Fz7M?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:42.8919
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b5058c7-5d78-422d-bfef-08ddeb68bca0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6656

From: Ankit Agrawal <ankita@nvidia.com>

It is possible for some system memory pages on the EGM to
have retired pages with uncorrectable ECC errors. A list of
pages known with such errors (referred as retired pages) are
maintained by the Host UEFI. The Host UEFI populates such list
in a reserved region. It communicates the SPA of this region
through a ACPI DSDT property.

nvgrace-egm module is responsible to store the list of retired page
offsets to be made available for usermode processes. The module:
1. Get the reserved memory region SPA and maps to it to fetch
the list of bad pages.
2. Calculate the retired page offsets in the EGM and stores it.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm.c     | 81 ++++++++++++++++++++++++++
 drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 32 ++++++++--
 drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  5 +-
 drivers/vfio/pci/nvgrace-gpu/main.c    |  8 ++-
 include/linux/nvgrace-egm.h            |  2 +
 5 files changed, 118 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index bf1241ed1d60..7a026b4d98f7 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -8,6 +8,11 @@
 
 #define MAX_EGM_NODES 4
 
+struct h_node {
+	unsigned long mem_offset;
+	struct hlist_node node;
+};
+
 static dev_t dev;
 static struct class *class;
 static DEFINE_XARRAY(egm_chardevs);
@@ -16,6 +21,7 @@ struct chardev {
 	struct device device;
 	struct cdev cdev;
 	atomic_t open_count;
+	DECLARE_HASHTABLE(htbl, 0x10);
 };
 
 static struct nvgrace_egm_dev *
@@ -145,20 +151,86 @@ static void del_egm_chardev(struct chardev *egm_chardev)
 	put_device(&egm_chardev->device);
 }
 
+static void cleanup_retired_pages(struct chardev *egm_chardev)
+{
+	struct h_node *cur_page;
+	unsigned long bkt;
+	struct hlist_node *temp_node;
+
+	hash_for_each_safe(egm_chardev->htbl, bkt, temp_node, cur_page, node) {
+		hash_del(&cur_page->node);
+		kvfree(cur_page);
+	}
+}
+
+static int nvgrace_egm_fetch_retired_pages(struct nvgrace_egm_dev *egm_dev,
+					   struct chardev *egm_chardev)
+{
+	u64 count;
+	void *memaddr;
+	int index, ret = 0;
+
+	memaddr = memremap(egm_dev->retiredpagesphys, PAGE_SIZE, MEMREMAP_WB);
+	if (!memaddr)
+		return -ENOMEM;
+
+	count = *(u64 *)memaddr;
+
+	for (index = 0; index < count; index++) {
+		struct h_node *retired_page;
+
+		/*
+		 * Since the EGM is linearly mapped, the offset in the
+		 * carveout is the same offset in the VM system memory.
+		 *
+		 * Calculate the offset to communicate to the usermode
+		 * apps.
+		 */
+		retired_page = kvzalloc(sizeof(*retired_page), GFP_KERNEL);
+		if (!retired_page) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		retired_page->mem_offset = *((u64 *)memaddr + index + 1) -
+					   egm_dev->egmphys;
+		hash_add(egm_chardev->htbl, &retired_page->node,
+			 retired_page->mem_offset);
+	}
+
+	memunmap(memaddr);
+
+	if (ret)
+		cleanup_retired_pages(egm_chardev);
+
+	return ret;
+}
+
 static int egm_driver_probe(struct auxiliary_device *aux_dev,
 			    const struct auxiliary_device_id *id)
 {
 	struct nvgrace_egm_dev *egm_dev =
 		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
 	struct chardev *egm_chardev;
+	int ret;
 
 	egm_chardev = setup_egm_chardev(egm_dev);
 	if (!egm_chardev)
 		return -EINVAL;
 
+	hash_init(egm_chardev->htbl);
+
+	ret = nvgrace_egm_fetch_retired_pages(egm_dev, egm_chardev);
+	if (ret)
+		goto error_exit;
+
 	xa_store(&egm_chardevs, egm_dev->egmpxm, egm_chardev, GFP_KERNEL);
 
 	return 0;
+
+error_exit:
+	del_egm_chardev(egm_chardev);
+	return ret;
 }
 
 static void egm_driver_remove(struct auxiliary_device *aux_dev)
@@ -166,10 +238,19 @@ static void egm_driver_remove(struct auxiliary_device *aux_dev)
 	struct nvgrace_egm_dev *egm_dev =
 		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
 	struct chardev *egm_chardev = xa_erase(&egm_chardevs, egm_dev->egmpxm);
+	struct h_node *cur_page;
+	unsigned long bkt;
+	struct hlist_node *temp_node;
 
 	if (!egm_chardev)
 		return;
 
+	hash_for_each_safe(egm_chardev->htbl, bkt, temp_node, cur_page, node) {
+		hash_del(&cur_page->node);
+		kvfree(cur_page);
+	}
+
+	cleanup_retired_pages(egm_chardev);
 	del_egm_chardev(egm_chardev);
 }
 
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
index ca50bc1f67a0..b8e143542bce 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
@@ -18,22 +18,41 @@ int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm)
 }
 
 int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
-				   u64 *pegmlength)
+				   u64 *pegmlength, u64 *pretiredpagesphys)
 {
 	int ret;
 
 	/*
-	 * The memory information is present in the system ACPI tables as DSD
-	 * properties nvidia,egm-base-pa and nvidia,egm-size.
+	 * The EGM memory information is present in the system ACPI tables
+	 * as DSD properties nvidia,egm-base-pa and nvidia,egm-size.
 	 */
 	ret = device_property_read_u64(&pdev->dev, "nvidia,egm-size",
 				       pegmlength);
 	if (ret)
-		return ret;
+		goto error_exit;
 
 	ret = device_property_read_u64(&pdev->dev, "nvidia,egm-base-pa",
 				       pegmphys);
+	if (ret)
+		goto error_exit;
+
+	/*
+	 * SBIOS puts the list of retired pages on a region. The region
+	 * SPA is exposed as "nvidia,egm-retired-pages-data-base".
+	 */
+	ret = device_property_read_u64(&pdev->dev,
+				       "nvidia,egm-retired-pages-data-base",
+				       pretiredpagesphys);
+	if (ret)
+		goto error_exit;
+
+	/* Catch firmware bug and avoid a crash */
+	if (*pretiredpagesphys == 0) {
+		dev_err(&pdev->dev, "Retired pages region is not setup\n");
+		ret = -EINVAL;
+	}
 
+error_exit:
 	return ret;
 }
 
@@ -74,7 +93,8 @@ static void nvgrace_gpu_release_aux_device(struct device *device)
 
 struct nvgrace_egm_dev *
 nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
-			      u64 egmphys, u64 egmlength, u64 egmpxm)
+			      u64 egmphys, u64 egmlength, u64 egmpxm,
+			      u64 retiredpagesphys)
 {
 	struct nvgrace_egm_dev *egm_dev;
 	int ret;
@@ -86,6 +106,8 @@ nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
 	egm_dev->egmpxm = egmpxm;
 	egm_dev->egmphys = egmphys;
 	egm_dev->egmlength = egmlength;
+	egm_dev->retiredpagesphys = retiredpagesphys;
+
 	INIT_LIST_HEAD(&egm_dev->gpus);
 
 	egm_dev->aux_dev.id = egmpxm;
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
index 2e1612445898..2f329a05685d 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
@@ -16,8 +16,9 @@ void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
 
 struct nvgrace_egm_dev *
 nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
-			      u64 egmphys, u64 egmlength, u64 egmpxm);
+			      u64 egmphys, u64 egmlength, u64 egmpxm,
+			      u64 retiredpagesphys);
 
 int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
-				   u64 *pegmlength);
+				   u64 *pegmlength, u64 *pretiredpagesphys);
 #endif /* EGM_DEV_H */
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index b1ccd1ac2e0a..534dc3ee6113 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -67,7 +67,7 @@ static struct list_head egm_dev_list;
 static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 {
 	struct nvgrace_egm_dev_entry *egm_entry = NULL;
-	u64 egmphys, egmlength, egmpxm;
+	u64 egmphys, egmlength, egmpxm, retiredpagesphys;
 	int ret = 0;
 	bool is_new_region = false;
 
@@ -80,7 +80,8 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
 		goto exit;
 
-	ret = nvgrace_gpu_fetch_egm_property(pdev, &egmphys, &egmlength);
+	ret = nvgrace_gpu_fetch_egm_property(pdev, &egmphys, &egmlength,
+					     &retiredpagesphys);
 	if (ret)
 		goto exit;
 
@@ -103,7 +104,8 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 
 	egm_entry->egm_dev =
 		nvgrace_gpu_create_aux_device(pdev, NVGRACE_EGM_DEV_NAME,
-					      egmphys, egmlength, egmpxm);
+					      egmphys, egmlength, egmpxm,
+					      retiredpagesphys);
 	if (!egm_entry->egm_dev) {
 		ret = -EINVAL;
 		goto free_egm_entry;
diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
index a66906753267..197255c2a3b7 100644
--- a/include/linux/nvgrace-egm.h
+++ b/include/linux/nvgrace-egm.h
@@ -7,6 +7,7 @@
 #define NVGRACE_EGM_H
 
 #include <linux/auxiliary_bus.h>
+#include <linux/hashtable.h>
 
 #define NVGRACE_EGM_DEV_NAME "egm"
 
@@ -19,6 +20,7 @@ struct nvgrace_egm_dev {
 	struct auxiliary_device aux_dev;
 	phys_addr_t egmphys;
 	size_t egmlength;
+	phys_addr_t retiredpagesphys;
 	u64 egmpxm;
 	struct list_head gpus;
 };
-- 
2.34.1


