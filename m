Return-Path: <kvm+bounces-56728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99DEDB430D9
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6464B175155
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06DF253956;
	Thu,  4 Sep 2025 04:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gNu5uFAJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD7F23B63E;
	Thu,  4 Sep 2025 04:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958924; cv=fail; b=Sff7I8Y7z6nxX1BPcMJ593UdC/XaghHe+mJAbtdXijT9/ZJjn8VBXSMcGNTEBeWBdB+vIa7gMGsdQrc6Rej2F4LQe03NEi9aYKRfwmQxfTx8bNSbEVIuYAo6kwlk8nfplWJdpR7EOZFo/Gf4mleVSg53qgPrd7QkdBjAhjPcOKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958924; c=relaxed/simple;
	bh=t/x3PIIH49dIA2r4AkyvHyyrIpBnkaK3FkdB7qGrKyo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=du95RYJ52mXYk0xcQJKdJidc58q5I1c5PHGcnGJol/Kh4cl9grbOtO4VwJbOeH56A26jRihWJyjZC1ct1PzzVcjGxYhta0kB4gMWKfIqr7FQVmbf1lc/dZ3uSBPld36n7Hb50Z9y75BHSse6A5mllV7ZOXLr+2xjrUpB62UF3NU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gNu5uFAJ; arc=fail smtp.client-ip=40.107.237.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dCrUYxmEEzkBPvrQLA6k9DtYkK+OUrZv7lrXvgofYDDBSFjRVU5RnoJY0BVyIqz0i/RYEnMl+VwfIMDvaezoRfIRnqCwnaE9pVW105MXrCzL9M1vBYh0YSmoRcvHHU0zsxwTjcXETcLcr2WWkRrKWwlonOrxPiyPFglzdxGHxm1kC07nkNydFHtNV4i9t/DusEVPwNBNNkwNb89VJItwLRcoWgoTtV62VXv9qOolb84qzofi0oGcUeN3qmN6pvOLlLxFFhaB8f5cnVRBUuXQk99HdaI2Vs7OblRw64L4oZabzGoBk3Qdysm4/0/xhipwtc1ZuuqY4d60q9Po5jhA3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzJ+e4pr6eIhdtuH+3dJ2Ii5jpfG5RP1f6Yx5bd3C50=;
 b=e894c2QyiNA2m3iTu+EJYvWsf/1J0aJ4NJmrfoRjw2TJdFd0CQPpM8OfCt1lPOTV+8BvYlOMI0+IVRDM+MrnLszfIsgthvjPSUacfVmDnhHhQOBkKW2cWOW4XVGckOEzeYu30ReijwXwl5vmHhNrOpELLAskndVROwg83lkOnwpDPp0HBXsOQueKFPibPnxSmO0Jyap30UJzEaMI6w8dNPmn6uF139lmCtDdcDQTBbd5AflvwKkDJx3Df0GVw9tZkE+VwSxqlky6sQzAnYcaOU2/iw9tTUwU7q3lC9xl5owksI5DkqA8HL0Z9MBSDNua0wsD71J4sMzSsFw0BYRtfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzJ+e4pr6eIhdtuH+3dJ2Ii5jpfG5RP1f6Yx5bd3C50=;
 b=gNu5uFAJUOxjrkqagF3Zj0mRJsgQ7t++55LU5Hy+sPkTRNLHJ80Z4GOdUVn32TaWaZMd7boED/tqM2DhzETjAykiCUeXjVQFa/XJqwgCQM/7MUCz8+qEhIG4s7cwf0xRIWaT4KFwJmvqGuBUOnJFoM7CmoDzKffaEJpFlrwfn0yYSDte7q3ioGj54ocPF+7+2ao8VNtVuvAP72T+SUFYUtbtAWXYxzIiHwj8/nN5fl/ai6S1nAadsmECm3T/7YRQEj/nuHi1gI9xtPEBfpdR7Pusgv6ReBfcv1yoETkqwnT7ubbx+gsmxwlMmGrf5tWwS/0FmOO1ZU9SWUPW3PgXWw==
Received: from SJ0PR13CA0175.namprd13.prod.outlook.com (2603:10b6:a03:2c7::30)
 by DS0PR12MB8477.namprd12.prod.outlook.com (2603:10b6:8:15b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Thu, 4 Sep
 2025 04:08:38 +0000
Received: from SJ5PEPF000001D2.namprd05.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::c8) by SJ0PR13CA0175.outlook.office365.com
 (2603:10b6:a03:2c7::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.7 via Frontend Transport; Thu, 4
 Sep 2025 04:08:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001D2.mail.protection.outlook.com (10.167.242.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:31 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:31 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:31 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 06/14] vfio/nvgrace-egm: Introduce egm class and register char device numbers
Date: Thu, 4 Sep 2025 04:08:20 +0000
Message-ID: <20250904040828.319452-7-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D2:EE_|DS0PR12MB8477:EE_
X-MS-Office365-Filtering-Correlation-Id: b0696b30-f381-4c83-1f0c-08ddeb68b9c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N47in0NsYCmiq33J9wNHeYK7qZsbwZECWHTI2ZUaQ4kSPtBA2RiIlOwOaase?=
 =?us-ascii?Q?utJFqCDwXfCNvIrqGWKv6NVpohV/9vl6vUIh/E0d49M543gwz3zbRo38G0U0?=
 =?us-ascii?Q?9n4nvKJV933oPan86xlS4QXPfssBCt7er32rRuFUPMrXtDwRE6oQfJGeJYIj?=
 =?us-ascii?Q?UkAx5QCgCcp0QOQQmQh3Lt0L1pEJVi1YwycAC0Cclvo2R/WBuRXhb0cKVPFL?=
 =?us-ascii?Q?e7m9mY/HUcdJgNl92+3Ee6RE1puQw+8mtBYqnWHd2VEqD/CDeO0Bd7rEogtH?=
 =?us-ascii?Q?C+kdkPye0isb8Gx0WXYvaI46EJNecIpI86iWlWKf9MygFGe1cpXqJjzHauN2?=
 =?us-ascii?Q?LCiIn3Q+K/lGu9QB3cfnl6PFCsqtjCJcH7Em9lkh7GeJQtXGvsMH1ib081cq?=
 =?us-ascii?Q?Gp21+sOwETlG74Q81kBZkQaQnEjsSOszkSdw9f0pItqZazjy9ooB4vdMG2z6?=
 =?us-ascii?Q?ZBasAX4pk1NGoWC/A9f6EWWumRpLmjZGlN16jZVI9Il+GKiuGcb+a669xQHt?=
 =?us-ascii?Q?r/C/A5JJrkVoTHAO9VEU0kAjo6wH/i+iCjcYz7a3MCbkNs92qB9hf4CV2nka?=
 =?us-ascii?Q?pMaGQQVFLh3/eXPHSrSvNZyV4LUanp3lxM0UzKMr/TRVRPn3szCBVLV48MAk?=
 =?us-ascii?Q?0msNCV8S0W2Amur96SrbQZDkPPQF1JLTq+FkT2HW94RF1yOMFeqAPJnM1s7y?=
 =?us-ascii?Q?bOAFnjixbO6UTgL3wxqmPjprFtu/PziA7RIdaO866y4Z6x60Mg7FsQEbtP6q?=
 =?us-ascii?Q?T/0FuUKsauOzXjuuQ+XlKr1X33dqF/6sCVls6+jw1xqogFLvMFmA11MD8NP3?=
 =?us-ascii?Q?SK0odpYxZMmX01uD5Uds8ZmWS+E4XbSM9yX+AzzouAojkyQKErkNOYamxhbe?=
 =?us-ascii?Q?4RMVVB2HGloxqlNtzo9fu/4j/5Fmv3tORwEUa0a6VNQ3AuNigs7sa2KBFlhq?=
 =?us-ascii?Q?lb9Ypb4Pa+j4TIWDafmWWFyuMqnXA5TKs488CTzuFBjEO+Oy1UzYZI7t29TH?=
 =?us-ascii?Q?G2sowUObw7P8GI90WbSnMHklJnZ3AyRILeRS1R8qKut65ZsJZmoKfJhgsRIs?=
 =?us-ascii?Q?k1XUW52wHVVIoDUupLO9QEhq0Elv6Gw7yMcG00foYaOlYOXujDRlw7WNANbe?=
 =?us-ascii?Q?HFnIOcLFq5ZUodTl3mfFcBvtaGTCXjlPAEuC4tB1orKX23AZKFqPwcT2FzwJ?=
 =?us-ascii?Q?KO8t19EYmvYMvoDCyX/Vc1Ngo8gcr7xcGNlA/+fExuBRxdoCjVpdntvMlkV9?=
 =?us-ascii?Q?k11tmZy7omLWASqLn4qnxfHJVtVLABcoAM0X0NXQNtxqvPDCQvcRbWHDifeF?=
 =?us-ascii?Q?32QGjWFolxxiKCxJMjsmAYk8OEsiNCuGY874lOOxMjErscWrA80OxMg3c6d7?=
 =?us-ascii?Q?/+vnBRaqP/M1+stlx+/E9ekF+E6zoUazzBpDGbcfeNARA2lQh/k/3giQMAM/?=
 =?us-ascii?Q?iF/9gkf+R/3Wcx+cz6Y4Cw10X4+JYPo8A0EhFSfJGGKdQz6w8x3hnN0alrOa?=
 =?us-ascii?Q?2EXJXXKqDA3s706p+quBC0L9jc68xi6ADruk?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:38.2101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0696b30-f381-4c83-1f0c-08ddeb68b9c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8477

From: Ankit Agrawal <ankita@nvidia.com>

The EGM regions are exposed to the userspace as char devices. A unique
char device with a different minor number is assigned to EGM region
belonging to a different Grace socket.

Add a new egm class and register a range of char device numbers for
the same.

Setting MAX_EGM_NODES as 4 as the 4-socket is the largest configuration
on Grace based systems.

Suggested-by: Aniket Agashe <aniketa@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm.c | 36 ++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index 999808807019..6bab4d94cb99 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -4,14 +4,50 @@
  */
 
 #include <linux/vfio_pci_core.h>
+#include <linux/nvgrace-egm.h>
+
+#define MAX_EGM_NODES 4
+
+static dev_t dev;
+static struct class *class;
+
+static char *egm_devnode(const struct device *device, umode_t *mode)
+{
+	if (mode)
+		*mode = 0600;
+
+	return NULL;
+}
 
 static int __init nvgrace_egm_init(void)
 {
+	int ret;
+
+	/*
+	 * Each EGM region on a system is represented with a unique
+	 * char device with a different minor number. Allow a range
+	 * of char device creation.
+	 */
+	ret = alloc_chrdev_region(&dev, 0, MAX_EGM_NODES,
+				  NVGRACE_EGM_DEV_NAME);
+	if (ret < 0)
+		return ret;
+
+	class = class_create(NVGRACE_EGM_DEV_NAME);
+	if (IS_ERR(class)) {
+		unregister_chrdev_region(dev, MAX_EGM_NODES);
+		return PTR_ERR(class);
+	}
+
+	class->devnode = egm_devnode;
+
 	return 0;
 }
 
 static void __exit nvgrace_egm_cleanup(void)
 {
+	class_destroy(class);
+	unregister_chrdev_region(dev, MAX_EGM_NODES);
 }
 
 module_init(nvgrace_egm_init);
-- 
2.34.1


