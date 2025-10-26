Return-Path: <kvm+bounces-61095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B052C0A9BA
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 15:23:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 750664EBEE3
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 14:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71F5A2DF718;
	Sun, 26 Oct 2025 14:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jvGcUot6"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011053.outbound.protection.outlook.com [40.93.194.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040FA26ED43;
	Sun, 26 Oct 2025 14:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761488380; cv=fail; b=kVG6lTF19S2Y/+QjmR+DZavgiqdvzFEPqRFD2kYi+PTfbsw9JQumMoZUDeN/1GHGyg8sLpT8bCin2w62z3HuHlEQUSJ4UpQXpFm/TYk0CChW2zDuZsGL/4a6fI/E0q5vevoLfWwQbcsjI0wTmmC1JsizAWQtoNdROt7440ptxA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761488380; c=relaxed/simple;
	bh=BCrxRrypW82MvlLkCX5LNq1T/7cMYq9HyblLt95QAv8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZezR1vos8JCua3mSZpogWqDpDSnIayA5x9X3N8zAw7I6j5vbrI2jXYlhpHPb7ma5y0Dp/R5XviWtVU19gKf3kPhTybiKRePmObCRCMLemgtgCX79pRIYokeQr7j5CiESuljSiLv6ebfy1k6QNgkDtYfbJ05He5lsvoF9zMohDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jvGcUot6; arc=fail smtp.client-ip=40.93.194.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UTXYciZKGQqU0OmEF+bf3mqbBJg19UaEPKS2Ex/VY/Sqnw5YgJInCFlQdRTECX3oMjg5ELRHMarP8J35ecmy6Y906aQCDnMEu0XryVlU28CC4uv2PHYwIP8/Sr1jn5aAp6BSG9wlEF4iYKlEaoCY80cpLJKxGcIWEJGSAiO/C7zwfLHEQ7LP/OC27cPStcqY64Oz1Ijki5cmrqEO8skt1tqWs8iSXFly0xI9ggXKhrM6qcWMFqHTUh0QB/PJibl7Vf4oxNLZdpdTwBlJwiDB4Kw+bLckmXB9iR1/4DIsoKLVYDV9I7Ta7ZW0fpTTmvYJJZoD5sd3s7s0v8Xv5t/fuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNIVFlRtuevk6wMRAs3kl7QZj2pt5+QR4uhVt4OoXqQ=;
 b=gQp2tKT7OsJ0qTSCvLbNfsC/C1KuA+5QTZkcJ6RTbtDEdq4YTuq1LM/+M+wBjo7HAWg9rFJYwf+84eBLqEW2gCX/8VCIbHo1sOaHfSi2dqPyJXZkKq4t3YfRNrGjkF/G3ui2mjWxMAW1arBNuMF28FQTJQlXGD7/3gcvwQgR5EKliPTUHPd8G5ghf05tDfQ40CzCreUHRJ4w3R07b0EHA99+vRjBHqQgrmuxCxyKf59k0EqTTmOK52FtdAVIipu7eq6vOOyAqL56VCFH/upCN15h9ZOCkQlojWphZNq7SL1vBObtfDE4UdeCTU8Zxo+1+CmyAs0zziXwiyAn66vang==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNIVFlRtuevk6wMRAs3kl7QZj2pt5+QR4uhVt4OoXqQ=;
 b=jvGcUot6cClLq6EkJdK1tCIE+PElDn4GPlvGpZwtQDpaZEhCMr9LtBp4XiPkW9Zn91Mu5Dl5jZ9a1e5qgfRV8n/65IYW0rZC/fNWIYN6t8XJGRzozwXEz6pfk11Qzi2Ybbr1g7/Hn3uhjxkbhts2MNOx6T9Tu0u4GXKvj4ICb02jy0t/+88xeL5ReV1e2NdEUpfRzZOVrZbiGcjhirgtxzOfqt39tsBebSkC/gr7Qs3sgyuQI1kE7rITtupvTs9OGayi3HZ1GMwJUKXC9Vw+0JIXbXIDTTQ5BVSMnp20NPafCJtBmMbygWJdfqE3V8O1kA/UtkaBCrRSuKnu754CIg==
Received: from SJ0PR13CA0141.namprd13.prod.outlook.com (2603:10b6:a03:2c6::26)
 by CY8PR12MB7754.namprd12.prod.outlook.com (2603:10b6:930:86::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.17; Sun, 26 Oct
 2025 14:19:35 +0000
Received: from SJ1PEPF00002325.namprd03.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::f5) by SJ0PR13CA0141.outlook.office365.com
 (2603:10b6:a03:2c6::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.11 via Frontend Transport; Sun,
 26 Oct 2025 14:19:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002325.mail.protection.outlook.com (10.167.242.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Sun, 26 Oct 2025 14:19:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sun, 26 Oct
 2025 07:19:24 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 26 Oct
 2025 07:19:24 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 26 Oct 2025 07:19:23 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <skolothumtho@nvidia.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
	<guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <alex@shazbot.org>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
	<u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>, Shuai Xue
	<xueshuai@linux.alibaba.com>
Subject: [PATCH v4 1/3] mm: Change ghes code to allow poison of non-struct pfn
Date: Sun, 26 Oct 2025 14:19:17 +0000
Message-ID: <20251026141919.2261-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251026141919.2261-1-ankita@nvidia.com>
References: <20251026141919.2261-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002325:EE_|CY8PR12MB7754:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cad322d-704a-42f1-d119-08de149ab08e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IyGEF6AHvTWB5b5hd/3TEiVzsw02pAqRLVCQTnUyfYZRk6V0cmSZqV2SUZn9?=
 =?us-ascii?Q?fb+9FHGxAFMvNCSg2rGPjjPwbXlsOliKqm/eehR2Oq8YDnsTjQNQo8skColw?=
 =?us-ascii?Q?ec1XxwL3E9NWRFckv/1XguvWwQ1jZ2bQFVR8Ipoggzv4KFXDj58QHcz0Y23K?=
 =?us-ascii?Q?ie2V2J/EC2H807esLPMTKt4JIxZcjkW8Z2OqfuJYhE/24x0y9MtfozcNP/Lo?=
 =?us-ascii?Q?PKacprnvXTmbNPQzx/C9bMyD27BsXmThEg3Tk7DbiUHeR/IUNKSoPzXbJI6V?=
 =?us-ascii?Q?yW22HK8kIqso7SlVHhHgltIQcEMl3k6pn5UaZoXPP21b4TQrFG7JQpbCEkeg?=
 =?us-ascii?Q?2Ajx4ZF57TB3/ty+MVJeUHzVZFMYcy5DExPXhIkduM2WMKHQRIbLZErkXMkk?=
 =?us-ascii?Q?Xyfoqa9+9+B786lGDKSJjK+kqOrfN4qfrbVKguUuCnMicazPzF86mVwpzNhV?=
 =?us-ascii?Q?UoOQkijZAq/06YCI8A/bZy2AQBgVW1rXcXC8vR8UrZKNLnzs/t/dcujZUip6?=
 =?us-ascii?Q?32ZnyBtG8xZrS0TXdgEHCHYKixef3CttuId3dM9dsON80S08t0jpS5o/IBBc?=
 =?us-ascii?Q?QCSObYAdVgmDxg4ybp6QIbknCxHAbyAlesbBdiqPXGJiKv9k4kj+KVwT9tLn?=
 =?us-ascii?Q?3NaU24x+t2dNf5JQjDQM2bUfXitoOB/SH0vlylO+S2DUZx7E3rWOjluF/ZB2?=
 =?us-ascii?Q?WWdUBcIwDhnWJmhCNBDO+ceASjfHB8oaGz+yzgfq65RfCvIcV7zf+UyMrR7C?=
 =?us-ascii?Q?MDjvviT93mQFtHioBFILw87gaed8ux9CrnHbboNC0zNSFtdXjOCWfHXasUs9?=
 =?us-ascii?Q?ovbzzJa7RbINwSQg3wPSVV8HMhNBhozrv5hnKBnYPau4mx1l5SUbaD0I2AxH?=
 =?us-ascii?Q?bUa3ssBrqwkuPZ10khOHPYvbW223Q5NOfh5soMQTYMddydmX999pSLztESjm?=
 =?us-ascii?Q?igWjHMELf/gU1/jSucjHGNOKADM63z2ekW8NpBjeOAmj6A6qFzXszG+zKB5c?=
 =?us-ascii?Q?uGU+0+RUIYlTFV/O7XLvdo7Xs9BmksykST10p24wyVzr/FxcU8iefwqcXYL7?=
 =?us-ascii?Q?4+A3ufzJMxvfAj0a2EugAC8QVy5kxHVLkz56y4nmEJxDAutZX7d1bvUMZUIv?=
 =?us-ascii?Q?mjV3v7KL/0yWIO+Bpm7eWjWJFvVWjwOflrJxfvOLS6ob6iAqg1ppcTrnanAM?=
 =?us-ascii?Q?SQwvNgFf7bu8kn31eD5lr8zjUabCTW6+ZnGNjpMnhIse1liYvopLoPP90awb?=
 =?us-ascii?Q?sSuOaZ5p8lUFkNcb88ZDwWhWBd7U5r9+gXJxJ153qGpdGlob1F+s3ayC9kZ3?=
 =?us-ascii?Q?FqvtVL4I1gPdvYo0zlpDr4QwHNpAA0UkivgeBGku9VFAGDPDcEK6batGNP07?=
 =?us-ascii?Q?b4pJZ4MxtNs1CHs/X99Tze/5mSBHgIHWXCAUnXnGlA4wZqezp9c5EbmzNI+V?=
 =?us-ascii?Q?k4a6O1hO+zY6xlDZNaycwPzZLeOxQGiA8r7sZ5bfnzcqMI/8smn18uJwolPg?=
 =?us-ascii?Q?tQk9ZBH8vfnBWYp/XeM0cmWmXtX0rtS1cDsJSWYwkInohKobXrgmtSZ5OEAI?=
 =?us-ascii?Q?uUgMqi5QOvTYbD4yX3lDXasIQaPhJGX5/S/SVsvR?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2025 14:19:35.1881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cad322d-704a-42f1-d119-08de149ab08e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002325.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7754

From: Ankit Agrawal <ankita@nvidia.com>

The GHES code allows calling of memory_failure() on the PFNs that pass the
pfn_valid() check. This contract is broken for the remapped PFNs which
fails the check and ghes_do_memory_failure() returns without triggering
memory_failure().

Update code to allow memory_failure() call on PFNs failing pfn_valid().

Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/acpi/apei/ghes.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a0d54993edb3..bc4d0f2b3e9d 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -505,12 +505,6 @@ static bool ghes_do_memory_failure(u64 physical_addr, int flags)
 		return false;
 
 	pfn = PHYS_PFN(physical_addr);
-	if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
-		pr_warn_ratelimited(FW_WARN GHES_PFX
-		"Invalid address in generic error data: %#llx\n",
-		physical_addr);
-		return false;
-	}
 
 	if (flags == MF_ACTION_REQUIRED && current->mm) {
 		twcb = (void *)gen_pool_alloc(ghes_estatus_pool, sizeof(*twcb));
-- 
2.34.1


