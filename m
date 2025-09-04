Return-Path: <kvm+bounces-56725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA575B430D1
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:08:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58E177C0BF3
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA81723BCFD;
	Thu,  4 Sep 2025 04:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uGAC5bcG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2048.outbound.protection.outlook.com [40.107.95.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368F923770A;
	Thu,  4 Sep 2025 04:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958921; cv=fail; b=QP+UCzS4m/5gq20Hdx3mYZyT47tRrdZzNzl2VorutjIxtGDhMbKZ1JFLP56oitf8Xp62cs0p7dmv2u6u43maDapVQjrg2VJW7Oc7AVYS6EnVdbqm+8aMtRr8UCFgpvJCdWaoS1aEhxSnOb5p/2w1/0Jx4aPCOHn+h+cK1MIQzpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958921; c=relaxed/simple;
	bh=f/Z5Ik+/3VbDxM5lUH69qFNQ10KWLXCIaJYieTPFcAQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B/xDK1DB6mQAoprlGZCrCY9K/IbaN77DVaqXd9fjoSJzUtDjwN7Wev8f1EYD6nZmyX/587tL3hfJwqZk9Manh3La7VlOx3kemFRdX6ZJ7ufy9+wu2WVG/la23aymS157SbPHKQ41wPRTs9p2fU9Vkg9iMxQ8yvi54/dYkSHwtKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uGAC5bcG; arc=fail smtp.client-ip=40.107.95.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CeIXrGOQbfolIm8Yuh08XqguYIvMMoDsdGcRYxjnmr/cBvpq06nddO1TYeIdM68q3PyzoKIxCa4Drk4Z6E5w2L8zNkzKCJlxCfJnCh7Bo/lG/TsvDkdG2MQ0wq6hsEZEJxaj6hJ7yvTUxSqk7D2WH2fw8IFnsqptFYM4FRNQza23BZq+xlKuJjysxxL5smTU3QcbDlodDbFNsVbLrviMc5VgGrBm5SOMqWEC6T8ni/zGhW1/wpav+s7Si9PHLK4dIefxWTN+XR+qM0xFyIg9UGsVAyZiX2b795giPpGADqnh0ZsO3Xsv9QmGHwlwQn/evOEbty5odyVq8vwW1jKQzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JID8y7Z9uJF50O8YDNsF/0hOlM+5JVit07Ff6CcCMI4=;
 b=tT6YdKxOXO0uPXvbY5NZrtFz4QKaPRuEkD+NmapsD5fKIli7n7UEOh5GJqedJYdfDPiCHg5GWiTMXTjbVgRXjP2ZMk+Ixca7RI/TBhmbaPnYcpRb3/XBfdAbzr/KPrTCdm+pigLf74OM0ypseejvkACK1mzJ+HDU1aARrCQ17hr+LmZt/gql/0T65g85+FDos8VtOOOgzM8QVlgaaaZmUEoG3l1s81Gi528GILxMl51rss9adwIvU38aHhqnYk5iElpflQnAQPokVsb5SUJ0wYldAjB22b/p1I3Cfj4SHev8RwtORFELBvwWc3XYxLxFDIfdHR7+cMpxNC+J6vkn4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JID8y7Z9uJF50O8YDNsF/0hOlM+5JVit07Ff6CcCMI4=;
 b=uGAC5bcGX8DG0qJpg6guEJuOpru1nheslL72GFoJ7GwI7lvAJgpWPKzgtaIKRF1US4GOAl+5JtmEl//iX9NeO35UhUORr8CiRmdevvbdimgrLydrUWd1Q/TAXV7sSCs15GS63WnIAfOIz05mTGitnEnd/J8I8PM8BX9QByOxWp2CwT6o+NiDvnfKbPaeEpTwIWVZmHeH3ekc2vLtlX5YR3yU15QIm9WRLvRT5+U4yo6Z6PQhGGR65lZXNFsc2F19Vg/RjLKgc+yowpPAOIMM0qYF7J29/wNpuL4Us8X9gN4ign0cCDOghymPYKWzozipY02mPJhiV2j+ffOsrFYB6w==
Received: from SJ0PR13CA0180.namprd13.prod.outlook.com (2603:10b6:a03:2c7::35)
 by PH8PR12MB6843.namprd12.prod.outlook.com (2603:10b6:510:1ca::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Thu, 4 Sep
 2025 04:08:34 +0000
Received: from SJ5PEPF000001D2.namprd05.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::b7) by SJ0PR13CA0180.outlook.office365.com
 (2603:10b6:a03:2c7::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.6 via Frontend Transport; Thu, 4
 Sep 2025 04:08:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001D2.mail.protection.outlook.com (10.167.242.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:30 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:29 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:29 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 01/14] vfio/nvgrace-gpu: Expand module_pci_driver to allow custom module init
Date: Thu, 4 Sep 2025 04:08:15 +0000
Message-ID: <20250904040828.319452-2-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D2:EE_|PH8PR12MB6843:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b31d7a2-de6f-405a-9b5c-08ddeb68b7b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9xx/23UHzYTeS3MMqPd0GMZ14oXR/feuH1HFd3EPZr4zYsyCrde2B33jqk2l?=
 =?us-ascii?Q?yLbmFnlYkgGIiuL51PdqyTBI5YyBi8WnM0TayGgW13gHj8thpIvl0tNaouYX?=
 =?us-ascii?Q?rciSX9Cv9cwPuGKVHhWTZfvf1BnON/gWVlVCenY2zW8HQ0CxwXDz4KwPPIFe?=
 =?us-ascii?Q?Ovu4Kfvvuum6bGPxUx1V+zoWA0RCunx7tsgpB8SFL/A7J0o8g7B031Lk/ldL?=
 =?us-ascii?Q?b+3+AzCnTHRzP+/9y3aN1iRLkP60Nhgz0rsfuTnQnwn7bgJmzLcp2+LbH1kA?=
 =?us-ascii?Q?lEMinVEJIgks4mvKf/FHCIBscN8pyGlPv/MJkshCS0kdE0ZUPGXBfdKxQHz1?=
 =?us-ascii?Q?tAae+wffaBCkM2ozcHX9hcsIezz/Rz/aefZkTdEtD7Rrbvmpn8aqoyRP75Ew?=
 =?us-ascii?Q?rmcSoaoymuJt+sVo1jEe6u3/EO5CeKruJDUGV+mKC9vP1T2KS20DDL1Gnpu4?=
 =?us-ascii?Q?t7KxMMvRc/L5J996CSMpNccf5LjLaK0JBxmUV9NP3qviChk9AFzCwLNPHtFT?=
 =?us-ascii?Q?6M+95yTx+vb1ARs1H8aD5rHBWKFXtTntUuCOvWC/qUstZNI2z77Mt0oOdJSs?=
 =?us-ascii?Q?2CTRXlrDAM8Hej+VS2vAPK1BHR22gr7JBH3+Ie/jPAZwqBG6NNODD9iV0ngN?=
 =?us-ascii?Q?EvrcjBcoX+fOgoYfmBQGg5oUlxH0H0Inn1MVLLBo2fS7mlm/Dq5j+74qSLlP?=
 =?us-ascii?Q?KephelXj0B1tRT8pMOOEaGJmx1tbEYEL5blD+PTFd0QlpMCCszS0Y+2JhVdh?=
 =?us-ascii?Q?EDTO0AKXgGeNeCYiLkQFCFVmzsqgp2bVJyTuFJqst3J9YY3SdC8XT7r2u60H?=
 =?us-ascii?Q?UHWqX2nidPueA0mqoQKv0/TtLO7xiJRU1sD+wZRIdHKy8S2afBF9xQty/jev?=
 =?us-ascii?Q?Tge8iychZKygbllrSyQf1Yi9LUPm0nNmZrKwzJQYqfvk6i7cWCTlGzGhyBPS?=
 =?us-ascii?Q?Mp8YFiSmyg1JUiFZ1E/CqNCQ4dObA1hkYQClUSQFBULzi93OK1loMxo4yQxG?=
 =?us-ascii?Q?k6oMLBalSQBeQCKvyK3SXWKFETijTd6qDqWouCPYMmmIGOwM0BW+qRKrQxd6?=
 =?us-ascii?Q?lWhype2ol6AoFwhMkdW7L4IVE9GZW0Eem82EqMNaocKIwmHVpNzeVqZWndBs?=
 =?us-ascii?Q?Odmicu4iLOSyTYXe2hcPkTmg+iWe+cuTEvEEOuFSnVAsf3/ZpElVDBsLIxgm?=
 =?us-ascii?Q?iiGMaOi6R06QRAerrmX4akdLAMHzVs2F46Jkpq6RFvG1NxMYmJed+YG6NNGn?=
 =?us-ascii?Q?W9j21YZPQbbJaJdRjvt3lCYUXpnuoz3oZhd9/IlZE257IsptYYgKg3NttEiH?=
 =?us-ascii?Q?bsOVtCI5JLkm2YnbNNrMwJl1BNLNvFD87WKeGl8DRCal4kF/hC1KkzW2YjaR?=
 =?us-ascii?Q?Zn4WUfhVFKLxVY8jbb1Q+WJm7ekRXibH8iaVyFIe/c3Xhmr5NBJtNq4FCy6O?=
 =?us-ascii?Q?iKpo7VW2bEqDLs5jwjRB3dvpsM8e9sOpGN/6YPZP7LgEt3GCbq0lluwvQFs3?=
 =?us-ascii?Q?O/sTsfUKfbbWztTm+eVOs3y0ADJ1RlJVOBxh?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:34.7156
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b31d7a2-de6f-405a-9b5c-08ddeb68b7b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6843

From: Ankit Agrawal <ankita@nvidia.com>

Allow custom changes to the nvgrace-gpu module init functions by
expanding definition of module_pci_driver.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index d95761dcdd58..72e7ac1fa309 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -1009,7 +1009,17 @@ static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
 	.driver_managed_dma = true,
 };
 
-module_pci_driver(nvgrace_gpu_vfio_pci_driver);
+static int __init nvgrace_gpu_vfio_pci_init(void)
+{
+	return pci_register_driver(&nvgrace_gpu_vfio_pci_driver);
+}
+module_init(nvgrace_gpu_vfio_pci_init);
+
+static void __exit nvgrace_gpu_vfio_pci_cleanup(void)
+{
+	pci_unregister_driver(&nvgrace_gpu_vfio_pci_driver);
+}
+module_exit(nvgrace_gpu_vfio_pci_cleanup);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
-- 
2.34.1


