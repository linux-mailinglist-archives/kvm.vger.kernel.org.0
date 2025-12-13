Return-Path: <kvm+bounces-65921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D33EBCBA4CF
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 05:50:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9DF7E3106497
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 04:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE18E29B776;
	Sat, 13 Dec 2025 04:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nhbKvPhY"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012000.outbound.protection.outlook.com [40.107.209.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48D8287263;
	Sat, 13 Dec 2025 04:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765601251; cv=fail; b=JsjlGpyVQ4iXaWpZM0FeFSdr2O9q5B774IHXNQUSKwStcRNXKfEHPDUG4nf48W/JTAkJApyAzUnOKnZ5yyWlHCd17eXEKZvrB29AuEyd2PCxR5VT/QOxYnUUec4n7sGBcV9MBvJ2MvecgW9FzKBaqa5L7NnUjlR0wPvGLqWq/go=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765601251; c=relaxed/simple;
	bh=OykvN3WVot5YOHuMxy9/W6f3FTTD8MGg/f7XDgP/H3M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zli0gl00HIV1B/ApDJ23mTxiJEVzgPk0oiGb9FePn597ZNYtg3XglsZwFxgt/CpHvgoZWWfcCKj0jR4Vi3Oj56KWG4nId91zavXDQvlmPnO3IgpqndWuNoHd/XlLHtcZDmXLIb7nV3GYh1uijSvYllpQjQYe9ePPoZHPfxBdLVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nhbKvPhY; arc=fail smtp.client-ip=40.107.209.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IMwECVDoKIbOm+ZnaqQYIT8Wlc2Wz+c+I0+C/aCiCyvtydaMzxDZBcMQdAx70IATTu/syMquJpmh2tO2RzAylW8ZpJjSwjikBqw1j+3IJglpmKoVwx56TbGKKXdGrKsCwUtsOsjd5AQViHZoZEy3n50QpZfpW8t9n6BxuY3NZ3jGgcYA1ner93MAiXesQxQMT1I70PqUurpmuscwWgKjXmifOD8cxbdD3f8/JDXmDE+mbUI942Rl1y/tsAcgkZyv2JINMHKYkREBMms4xXZP/hMSOFdH7Vfh0d76nZkuaHeXQNJXaDbwnBI1wxgM6AkmUpnCyouQQI9UL2iqXdQfQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=EMn2rdquEdXwhPojWVn5hcL8ra4l+xRTE8BHjbq+lwIendrmsE6/EXckDuNsXFQRLwz3N2CfFnWU+7/nQCIi+zXpIp9nZ1IDfQtnwA4NlnpkfZqLLGNdIpCK8IO5jKPsPdZ95WVpAKMUhpDRXZkWzP4BMslY3TrJE6N/15b0t0OJSUCI5Ad2smLr7PA5976O7HxvUB9ioCBk9PXN+RzFZ1Sp0nvnEwjdtlOArLzUHIhTyny0QCukWuTEQ9sCVIZkDD1mbdaEgj6xMfvZhx8UzGYqNiNg44Oj8Xip0/XT7ArDCIJvX7QzBorVwWfWeTa0JQ81+tKJ9Kj75z6GtlRcEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=nhbKvPhY3zZbmancTciemnBMGBAza5c7pKc0j6eifTa2WP8qU8naikMHyhtpd18m5Sfao2w7ewX+8acr/wJttUcGCa34bDu9skMM4VabRRi7f8fcxRlLNGbLlAx+LK03BM3Qq6e+cN4yYYO5AeM5xdUsfVp1Fb4DnjINLXCNiixlizKrrI7LDHeLZ0ZEmtlgTJcyUZoXrKsUL5h41cLLIISIf2oCo6WOvwF1BResx1evifK0O8sxI9fKwrpDE0glNGevHfaYd0mGZTnilKr4pyDn+Hg0niskKQ55ll1XsiyKwFOc7Q+khXwF87a8Av6KJSi78j8cj7PNvfJ9AzxGOA==
Received: from SJ2PR07CA0001.namprd07.prod.outlook.com (2603:10b6:a03:505::11)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.12; Sat, 13 Dec
 2025 04:47:19 +0000
Received: from CO1PEPF000066E9.namprd05.prod.outlook.com
 (2603:10b6:a03:505:cafe::3b) by SJ2PR07CA0001.outlook.office365.com
 (2603:10b6:a03:505::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Sat,
 13 Dec 2025 04:47:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000066E9.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 13 Dec 2025 04:47:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Dec
 2025 20:47:10 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 12 Dec 2025 20:47:09 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 12 Dec 2025 20:47:09 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v2 2/3] mm: add stubs for PFNMAP memory failure registration functions
Date: Sat, 13 Dec 2025 04:47:07 +0000
Message-ID: <20251213044708.3610-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251213044708.3610-1-ankita@nvidia.com>
References: <20251213044708.3610-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000066E9:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: f9f51cf5-446f-48c9-4437-08de3a02b2ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?48KvNHV7ZU/jNiiuZMtW8FpeAXWbAg+8x4TqSVncfpjMVn/bay7eqXL+oDBL?=
 =?us-ascii?Q?LvGdr76BCU3GrIzXOwBVEOq92WHLVo78xK/IaCnPkLEzXTLyXGsxlHXueuK+?=
 =?us-ascii?Q?08TYA5AuYEUync70SR6oQQHp0E2MGtCCoakxq4atov7I9RfNQgLYqeJAlcEZ?=
 =?us-ascii?Q?UqgP4yQtY+UwKPqhioYOSEyze6Rx/jiI6S567ziB1YRcThKwnw7R48abXHha?=
 =?us-ascii?Q?iclcwYk8syoboEW3fgQ2j2G/6LCI7nh0P1a/9d+/FJlIZNWU9rkamzjHBcpV?=
 =?us-ascii?Q?lwJ/hz7ou7Hu3zYpFlko4DCy8Z2fzjEJC1FGCooveEcpPMTCHW+PvhRYhKGR?=
 =?us-ascii?Q?GgjMJopf9Nkewm1Ve2b2oskqqY6x2hH5DeziDMrtjeQlZ1tr/W4NuChlj+3H?=
 =?us-ascii?Q?Bb5FLpqZR93ykMSwbMNt3J6SVf8anmVKbS7F45J4ZXaVK5ugyQOzJGBozmW4?=
 =?us-ascii?Q?Cp5KJRHosGSWAe4KQnykOfyba2eXi8AIxGrR3NOAlXp5Bs8dGhMcuF/2rTHx?=
 =?us-ascii?Q?HEMe7SsMRaZpCQrau+hwm7SJNL1/O+HOnzqlqtIoToaMBYIWy75/lxNptTh0?=
 =?us-ascii?Q?GAVq9vMJr+VfTgEGfISztZl917fNmrGlXS+Tmorw3/ofxPn6gbdvtWsfpLyZ?=
 =?us-ascii?Q?+QsvO3NEJGNoVwk36Jjtz+NR2rZe3CQ/0OWT4Z2jgZnVfeEEq1htNSKA0HJg?=
 =?us-ascii?Q?jIiLgU5s00UT3hiUAQhvdEtAqFX7ElgE277ZT29GqrzFjOLUwBontOuJ5ZJ3?=
 =?us-ascii?Q?O5btG5sZjCjsJGAEfbtgCQXg0CsgdrnTvLOeIX0dm8IKvKj6BduWhTK1fdtA?=
 =?us-ascii?Q?fgOFycn2J3Ftp8ixtbQQ4Cvp6hq+S6KUoqFluKw1bFWhe2dFLmo1ocU06BF3?=
 =?us-ascii?Q?Slxu+aSnO10bIQvhebyyxJNKdro4OElmGNbtwEeFI0Gr04kFvhYP8isa9oWX?=
 =?us-ascii?Q?HzxIzkXIEgTpXI4AjM9PaXc2isG4nTMo9NtDboWPiypww9IxCNTzfBgGA5Qb?=
 =?us-ascii?Q?yPRQuI8MV4tPkYnJkCwFvhrQKNv1qA54aESgX/HO+yygsnwwPKMIbcn3+Cr3?=
 =?us-ascii?Q?MkxrZtkJeAnIXWQDM7BaxLRQX66vqOEzrg29eSFe9zfzN1AmsYgDK1rB6PJd?=
 =?us-ascii?Q?/vgjOvBWtOa0X40Q5LIcGGXfc5uJ9vfTqkAIplHEbHhkIWknBmMk9jKny3Vf?=
 =?us-ascii?Q?2uJvZo05uYJhjd0tP03ZXFcmCiGp1w4TqxrcXhSmKqQSuA0z9r/irU8Z/RFF?=
 =?us-ascii?Q?cJ+vyLEb+3mH+NcxMgykYmIxQ31vMEp0OWRfW5ANHvev3+bWNjiukX6SR8sK?=
 =?us-ascii?Q?JVawmFfyDJ/HxKTpSGbIEmWbbM5e0MEoNuN8JbmsuKVn5BqdxHLv2hUwVdRM?=
 =?us-ascii?Q?1Qbp6UMiB2lBJeAtOTnlswQ4zS3IW/MNcoUXb3OaLCj9YeK3skkPNCzRaSGA?=
 =?us-ascii?Q?IUoCvYLZGKxdN+Z70bz0O5pmw6BEO8uHTB4xzX62teJr4l2EyMHJoZzhuoXQ?=
 =?us-ascii?Q?TSQ04T6gzMNsjd5jtKdGbZqztiTj4ZECJuugyGNANS/+HYkuQNqckxT8ODtJ?=
 =?us-ascii?Q?nuM6sJw5RACJkgiQ1JW7/vdTV0cGUniK6+oSi/Pv?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2025 04:47:19.4222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f51cf5-446f-48c9-4437-08de3a02b2ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270

From: Ankit Agrawal <ankita@nvidia.com>

Add stubs to address CONFIG_MEMORY_FAILURE disabled.

Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/linux/memory-failure.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
index 7b5e11cf905f..d333dcdbeae7 100644
--- a/include/linux/memory-failure.h
+++ b/include/linux/memory-failure.h
@@ -4,8 +4,6 @@
 
 #include <linux/interval_tree.h>
 
-struct pfn_address_space;
-
 struct pfn_address_space {
 	struct interval_tree_node node;
 	struct address_space *mapping;
@@ -13,7 +11,18 @@ struct pfn_address_space {
 				unsigned long pfn, pgoff_t *pgoff);
 };
 
+#ifdef CONFIG_MEMORY_FAILURE
 int register_pfn_address_space(struct pfn_address_space *pfn_space);
 void unregister_pfn_address_space(struct pfn_address_space *pfn_space);
+#else
+static inline int register_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+}
+#endif /* CONFIG_MEMORY_FAILURE */
 
 #endif /* _LINUX_MEMORY_FAILURE_H */
-- 
2.34.1


