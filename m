Return-Path: <kvm+bounces-65562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 35506CB0A67
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:57:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 054A7316BC88
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97D6F329E75;
	Tue,  9 Dec 2025 16:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B9Kt3f0z"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013027.outbound.protection.outlook.com [40.93.196.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099F23002CD;
	Tue,  9 Dec 2025 16:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299113; cv=fail; b=FwvbgukaCssjVqvPemvHaKwdyjvu5ZK2ScYtJ8FsE23zeXIaO5PmFxhqjTtalJ5AyaTXXZD7xi6EHGP9zOHKrqrSWovnLlLAwUGZe6j2Hfdoe6wXKtPqS4GDLzxAiW0PUiqwuNpYjaScbYN92PtCG/2bDO8caUCuy4GnX4X6q64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299113; c=relaxed/simple;
	bh=Y3PrEnHSlhxFT4e527ZQT7yFRNRnaoRfLoa40OiIwTA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qs3f233NTaryRYscmDGkT0w2CvNNKBKrLvXHVTMVIQ5SzamxY8fz6nS6HgEAXAfam0cONG30XAT2TNs20T0WE7ymi+bF9AmQXbMBczgpgjcxH7zHOvJIfcehlwqkNYOfyX4jXs0dDteiAiwlNahtOl5eKMNYtANPsN3hGUb9sj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B9Kt3f0z; arc=fail smtp.client-ip=40.93.196.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=psc67IfrTf+hd17bKRY0xKVdZiEEUF2Ag5sx9m2UubiHs04cliA2o8gpTkrX7FiiKseF2ck7wZS2lWiyss/FZA5biBVyifsemFkxIK01Kk9j7Gi3gQrZx7Dbz10FWdf2MX0HaCqM5yX0MoYGsyQJ4ZjOQuJkHL90+Zw2nYA5A2hhVdooLJnglfYar/dzJ+EzwAquQCMS0ReFOB/aaIRqgdMtDKDspybzCDdyNQwqUhzgvZ0qryUaTs4DTNFe/phTlEAeGki4I390ulJjXnru4x7lwh3Y7eOqepzfAAewkYYXoFpj0l0d0PeJl1VIfR5iFTHGDI2FpK91xIC+nUZfaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WwaKGfrFnrXibcbAKe4iATpt0x/YPgJCHKsTDP7mAsI=;
 b=MJf9TXkTR/hSx364i+uZ6u5e30v0uOJHkTweJHA1JMKQJ9mR8A3xniz+w9xbLxq9Ws9yJZLUokxkIGd2ordY47cCRmk900rlYpytk78T2OD3Hne5tKpVTs9zI0Xu/I4OjzA9F5fq7xwuTfe0eqzV7IeAmPWDOpeZp7ntLHrsBFwP4BaZ4YZhgseM0EqxSVS1d6qFK/KPoqK5BMY70qML54fnqhzVZjhrFLaUvcnyC8M4rL5v6iAhuxIfWBTiEQ0UoB/VFgS4UB97fzlqQYDE6Ld67jDQNLlea6bvfUUz+d7mGzcnqfdsvB4Q6lGSx3URPiqZ+Zr4sk0ax0ENhbYgjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WwaKGfrFnrXibcbAKe4iATpt0x/YPgJCHKsTDP7mAsI=;
 b=B9Kt3f0zfe51umX7D4+zxMy9T2ExRUkGEf8ZxdtBfdBG6WfVYaOKJkyBntBxImB6Tr1qbi9ZTfvkP+DKuHKWRpatCLNGjoqR5YbUohDRUy2jwvY0tWYL7zRekiRUbNi9VsbbMIbVP+O2AAqLtIxUXJKgHQxh1W0VHhoaxf5sHGb9Apwn99Ykqv0cji1nY5HYezRMwR78d5bh60TbVrp3JQWbpYJTAaaqli6iBwBNrtU5ZIizyLIuxxWXWmoyBq99WufbXbwuaxBFhaeCl8IbwJroGj4aU31oBEHJmFPNwFjpRvQYeZoiDCdXP1dK2jhbrT9xZ/Whi3WdvW9ZNMMGfA==
Received: from SJ0PR13CA0171.namprd13.prod.outlook.com (2603:10b6:a03:2c7::26)
 by CH3PR12MB9077.namprd12.prod.outlook.com (2603:10b6:610:1a2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 16:51:45 +0000
Received: from SJ1PEPF00002313.namprd03.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::94) by SJ0PR13CA0171.outlook.office365.com
 (2603:10b6:a03:2c7::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.6 via Frontend Transport; Tue, 9
 Dec 2025 16:51:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002313.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 16:51:43 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:20 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:19 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:51:12 -0800
From: <mhonap@nvidia.com>
To: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <kvm@vger.kernel.org>, <mhonap@nvidia.com>
Subject: [RFC v2 04/15] cxl: introduce devm_cxl_del_memdev()
Date: Tue, 9 Dec 2025 22:20:08 +0530
Message-ID: <20251209165019.2643142-5-mhonap@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209165019.2643142-1-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002313:EE_|CH3PR12MB9077:EE_
X-MS-Office365-Filtering-Correlation-Id: cc690d65-8a4e-47b8-cb90-08de37433bb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nFWWPRNLGMfYNLK2P7lwm8TqnFkxIjWlxtISO7PqW25nnpYlgxdsD26i7vjk?=
 =?us-ascii?Q?RLZbR7cT1xxROR5HPo+Gh2mmuJfdyEZOGRLPWAzTvvn7T0ke5A9Ctk744wdn?=
 =?us-ascii?Q?uANmke3VhOjVH01qmTJ2t5xmhHScT6GSk50aguwWZplSDPAMdbqDN6oqpdHo?=
 =?us-ascii?Q?/bfmSBfqQEj2c2cLWPPnqE/vwhWI+XgZzJqddNd9ddVpK5Xt5dTCyEs0qBke?=
 =?us-ascii?Q?rJZcyM/JwB68jK4qsu3FHLzjWaRnX/yaqi+R0s112hJMHsFXaLSH8awfVjM5?=
 =?us-ascii?Q?Nw3F59qZzac54HmpGvaDD9K6QRoeUoU9mJRJOWDK84yTeUE0EyR5tHn4V0X5?=
 =?us-ascii?Q?/NaVfA01z8cECpfae4hEqk56lSH7OsJyHMHIpPKz6KU+ZuYDfhw30fyF1wCc?=
 =?us-ascii?Q?MS57DDnV4J9OYngaVicKxjf6U8dUV0GHjNlIicEA2mSlvLe6k5v0m3m5mHi1?=
 =?us-ascii?Q?8iModg3fyRX3HrA31dxiZww6V2Lrtt4wUX0g1I0Jg8Uja6UmiC0CZxyoBRvj?=
 =?us-ascii?Q?9RfwGwn8E29kwUoFj2+4pVvJ/o28a7nTZvtnOmW5jUts+cKiuEA2kHCMM/h2?=
 =?us-ascii?Q?kVsJQM4tTjGrCVwRWXCle6dxcDESm1yfcfOn7a4AzsztW0rjkvVv63b/CTNY?=
 =?us-ascii?Q?3CYEc/BTHl1Z6hNYfyMaeRtlenWjhwZwPQZ9jUAbnP1ivN+xKCiybRdlAtMp?=
 =?us-ascii?Q?MLo27d5V8iHTVTeKMytMejhYFmYUOxswmKWT9MqKYHMyDjMOV+MvI8NQTJN5?=
 =?us-ascii?Q?UhvT+TXBqnzEd4jrmjpy1GnW8vylgl2zHVZypYjT23YPXkrVzkh451S2fQg9?=
 =?us-ascii?Q?chdsD7A6mNooKCNNcUhvYQ3XRYYR5D8jLGT581rLY/xK7WuTeAYPveDFnu8B?=
 =?us-ascii?Q?D/Vl/3wJyTAbQr2na9mReAwRjO5jttL6+FsYUX/sziWJtKIu3mgwYin9km7E?=
 =?us-ascii?Q?VdyCTCDxoSkfRvplr01y1vAdk6NsTx0YGKaR5U9VOk2SPBk1CdMRk/nxxm1K?=
 =?us-ascii?Q?HsEhCRbc3Nnlaj7eoNef6A8YnteOj5xf5vtfTt+gW46we8nJNYnM0CjIsNpY?=
 =?us-ascii?Q?TFafbwkeupd+/c6n0uWF46DJm3hhWJIe8PF6QAZaZHwuA7fnT+o/iYPEisuf?=
 =?us-ascii?Q?R5WkV24qjFrW2RHW2kit9/3aXaylkv+yb6OPUtg0pi5PMbEWj+uHopFizlDL?=
 =?us-ascii?Q?hcGjSr4EFTg5ziUqw8Q963nb7o+O8L3AFsIpxd84xF96LGtYNcUlStJddNvd?=
 =?us-ascii?Q?Ke7hOvCAXSM7jALIvckFzIwDh6pYZD2kgU2fi589IEQt37yVvsoSoKd6KBFo?=
 =?us-ascii?Q?M1ASGmExXpegwrdgLX4hsJERrBYnJ0Dc9R5+rL1VijQuJXJC45gzwIf6ryyA?=
 =?us-ascii?Q?z3m6h1GqblQ6ZeVxcW1+03xo4mpr9O4w7bUSPIlHS6YGfmpouOv4kKQQj1BF?=
 =?us-ascii?Q?M7U0HPD8UIl6WXq7kPNDTUyzw7wwOJkH3mqXIcsHegGrECz02M9LFKTlI3vt?=
 =?us-ascii?Q?VkmI+v6yk9AiyCV0h5Kw9SjzHaxqXT+hTzFt5L1HmJ2laS8LpM4RyTuVoeqj?=
 =?us-ascii?Q?fD4OiNeUp0QSXR1/t3ArSOTTruYmGmeVfI4Lv5Fh?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:51:43.5973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc690d65-8a4e-47b8-cb90-08de37433bb6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002313.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9077

From: Zhi Wang <zhiw@nvidia.com>

The teardown path of kernel CXL core heavily leverages the device
resource manager. Thus, the lifecycle of many created resources are
tied to the refcount of parent object and the resourced are freed
when the parent object is freed.

However, this creates a gap when an external caller wants to swept the
resource but keep the parent object for a re-initialization sequence.
E.g. in vfio-cxl.

Introduce the devm_cxl_del_memdev() for an external caller to destroy
the CXL memdev.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/cxl/core/memdev.c | 6 ++++++
 include/cxl/cxl.h         | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 9de2ecb2abdc..d281843fb2f4 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -775,6 +775,12 @@ int devm_cxl_memdev_add_or_reset(struct device *host, struct cxl_memdev *cxlmd)
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_memdev_add_or_reset, "CXL");
 
+void devm_cxl_del_memdev(struct device *host, struct cxl_memdev *cxlmd)
+{
+	devm_release_action(host, cxl_memdev_unregister, cxlmd);
+}
+EXPORT_SYMBOL_NS_GPL(devm_cxl_del_memdev, "CXL");
+
 static long __cxl_memdev_ioctl(struct cxl_memdev *cxlmd, unsigned int cmd,
 			       unsigned long arg)
 {
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
index 28a39bfd74bc..e3bf8cf0b6d6 100644
--- a/include/cxl/cxl.h
+++ b/include/cxl/cxl.h
@@ -267,6 +267,7 @@ int cxl_await_range_active(struct cxl_dev_state *cxlds);
 struct cxl_memdev *devm_cxl_add_memdev(struct device *host,
 				       struct cxl_dev_state *cxlds,
 				       const struct cxl_memdev_ops *ops);
+void devm_cxl_del_memdev(struct device *host, struct cxl_memdev *cxlmd);
 struct cxl_port;
 struct cxl_root_decoder *cxl_get_hpa_freespace(struct cxl_memdev *cxlmd,
 					       int interleave_ways,
-- 
2.25.1


