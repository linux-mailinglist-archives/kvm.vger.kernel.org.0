Return-Path: <kvm+bounces-61771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AC70AC2954B
	for <lists+kvm@lfdr.de>; Sun, 02 Nov 2025 19:45:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 196104E83D9
	for <lists+kvm@lfdr.de>; Sun,  2 Nov 2025 18:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B44323D7FF;
	Sun,  2 Nov 2025 18:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mTShJ5oM"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010062.outbound.protection.outlook.com [52.101.56.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB8D322A;
	Sun,  2 Nov 2025 18:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762109095; cv=fail; b=nIVrgscT05A9g/5GWam5RWAxEMsTo9xsccKwjDLPBce6Um4oEoGZ3PrfL34/6x3RlwECRApFzWSzG9YiC2vVFIzJ9i/sMqSyKJ6PNLLXGB67qqZBSUUWSzx+yVHuDvKoFuEcLII+FthW7SuzqjaiuMuPoJH/QovVqmwe3VXY2Qo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762109095; c=relaxed/simple;
	bh=BCrxRrypW82MvlLkCX5LNq1T/7cMYq9HyblLt95QAv8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qLi6dcWHoLWpoEeIBf77I2SxZhv1lwPE4SpCOZLSeT5rYKYi9zZ0wvahTLGjsj3FoDu02ZIcJZLbzUsBBEcQgbZgt0k/Nm9B8aI374BTRJLA89/iReMS1+flebwwFvHRKBxcW9Qt/CYk5nJq1gNXnVsiuQjAolAGt1J+3sswK+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mTShJ5oM; arc=fail smtp.client-ip=52.101.56.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P0L9zc9SvwqfN2KJt+E4wiX3DONDIj4qeTajD+LkYG2SDTZdidz5f81T4gDTSbaUSPwULqErlAC+NXdGnWevQnGACnzpJhqZljfoS+jVyy1BTpWzOAK5O//89KUI7KL98kj+DoSCYDxsrAd+yrY0/GIH8FGISozPMdXNJKRQlgkgvyu2A2AjDgSP6rVfnqSojdFA+Kdy/fIz1hW7gqjnLjNKAG15CBRh1+IRWmZR1VwD5yCMftwSonHkWbKTl+mysIGsxVvt6oxPwo8WV8ayFW4tHEjKXApS+KGnORBNPtEV3u5IjpePlAEozLRJ8piPZ13h36ZSzZzFO/YRUAK4sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNIVFlRtuevk6wMRAs3kl7QZj2pt5+QR4uhVt4OoXqQ=;
 b=XD+8Y9QNObCMWeu4WhQX1iYmq3V8eGGsar68ezytNRWOO1/o7GsZc8LxUUiYQ68uWxQoT8b4NTzwV6WDghBnEJANybMl6bQCYmK1a+qroRK2/xX6Q7vsyLJr5nKp52xXa6iUSRlGVUfDi2AC62BPmqwBHmJpsERm+57GF9gh+bEfL7rQbxC361roGukYdS45VHXqd9ciLh6cp/tmvycfwBOLQkxkdciyz++NOTdFk6eY77kG5tkpyO2Dicam6/9rD8xyVvvGlSuGogmYpU6Rda6HchEjUQ+JD0uFAIBf/NgMEgqaZudyI3EmEVxNPv+x7uEyyiISq06QPRpAauFdTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNIVFlRtuevk6wMRAs3kl7QZj2pt5+QR4uhVt4OoXqQ=;
 b=mTShJ5oMHe76l9g5/kU4NYAtZo1j8ZSWsgH3d0cZlxEUNDdgdWFyyrOTu+DpVVGpl6URA9exCqQZP8EYLsFKDoKBM/hmCSGs87BVVc9571jbVlEJqG1I5nq0g97T9a9ItnrxbSXcuv3iAEO3quFGS6wN2unN9cYBMZY2bcHuwyoqHIs0D7S6B6GGSGJnbMZ04+IrB6c7LO9cUIja8shHlt7rpQmSJuZAqC8lWY+RCstBVBcSZLG+xc7YnJxaCwcjnUG+/MMVJf3xQPlqn2llALo6hmxu885JhanF7a5YDk9Kn1sDsgltEt8j54NfwklLHXv4NkoklKzokQWhJpz1Dw==
Received: from CH0PR03CA0050.namprd03.prod.outlook.com (2603:10b6:610:b3::25)
 by CH2PR12MB4247.namprd12.prod.outlook.com (2603:10b6:610:7c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Sun, 2 Nov
 2025 18:44:47 +0000
Received: from CH1PEPF0000AD82.namprd04.prod.outlook.com
 (2603:10b6:610:b3:cafe::ce) by CH0PR03CA0050.outlook.office365.com
 (2603:10b6:610:b3::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.16 via Frontend Transport; Sun,
 2 Nov 2025 18:44:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD82.mail.protection.outlook.com (10.167.244.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.6 via Frontend Transport; Sun, 2 Nov 2025 18:44:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 2 Nov
 2025 10:44:39 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 2 Nov
 2025 10:44:38 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 2 Nov 2025 10:44:38 -0800
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
Subject: [PATCH v5 1/3] mm: Change ghes code to allow poison of non-struct pfn
Date: Sun, 2 Nov 2025 18:44:32 +0000
Message-ID: <20251102184434.2406-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251102184434.2406-1-ankita@nvidia.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD82:EE_|CH2PR12MB4247:EE_
X-MS-Office365-Filtering-Correlation-Id: 333c9e97-a8c5-48dd-f1af-08de1a3fe60c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U1FoCGEBJseNO04u1ocjhmz3ke/jxtZ4cjTYiprII8hdX2I1L2jrm+8cwIeZ?=
 =?us-ascii?Q?/iRuc/5ZShfyMOTfFvdI8Z4jAa8bfLuRLATZSIO9a9iRy/W97Emn+EAOJRQC?=
 =?us-ascii?Q?1PXwaqzzK8YKb80aZWYI+4i60D0obV+xSwS6QpHB3QFyi1rm9axcV5Y4KKTY?=
 =?us-ascii?Q?iRPoK6yL6bTgdSySPhAj/mwDZOpEqCqEuqmhEhhtVp7R1uxkdI8kRbMHRCsn?=
 =?us-ascii?Q?mCREF6UmBZKZwpigDQyct3yyIwUGWMBi5L+by7qc4uhWdGHjrMqEodkjNE57?=
 =?us-ascii?Q?in3CHqrGhUpAQZ+tzAUR5XzRyWStUz8gJLiDFolLfgzs+SLDgSkvtfrPhxK5?=
 =?us-ascii?Q?21zAi9E0dvWZJHZaVx75a7t5COZSS0c1o0b45J9TAjdjhsvuO9PTVjLJvHKV?=
 =?us-ascii?Q?HciYUfEsO9cRAYFgH8xJF2B6EYBHPQRzC0+JP92trAPe/u+2i+ao7yDErn0o?=
 =?us-ascii?Q?rLBUFeonAEtlHKanAdgwZHIrVnqAJRhrgHTMxDyiE3fsHuTROGTBoFfnEbUL?=
 =?us-ascii?Q?g48q/R4LCN+bl3LUpI2ZbhLARYnlj5G/pf1mYqtpitN5hJoSq08UEXQY6QNG?=
 =?us-ascii?Q?AL4h7TbO50A7YfwkAiXfh0OBrXChxETHH1wSbYNYCX+0o1MFdDefzDQVgWyj?=
 =?us-ascii?Q?iOgBl6QY82VawQ7ThAL9/BAAHieqJPIZXMIMMGjoZ7rVj1eXvKrEnRWRi7lF?=
 =?us-ascii?Q?rRTor9zb7xWdGCzNUBjGfvX1nKBj0vOIuyP/Np2a7ZyYCLnrgTqPciwg570V?=
 =?us-ascii?Q?hrlGgcrWYxXD614c/y+vgH17xEd+/fFi89aCssBsSM0q7vfeNpcSiM7oNzao?=
 =?us-ascii?Q?hBda/HuMO1dRlRtyxBGXWfdwjGyO1Mt19EeQMoHx57iAJ4+lVasivsvcaOi9?=
 =?us-ascii?Q?tJWdWHYMsc3H5WAZ8dVmJxhjO8diNMMLVTZT7u8VPq8S0IGuX+AStjewu01i?=
 =?us-ascii?Q?XYHhQI9zc/gbVCfY90i/y7BhcG1SpVTQnxBo4CrtyzDZ4+ddiPGZTYYef+m3?=
 =?us-ascii?Q?bYZMUzTL5HVEKMvwwGJhFkugIDktxDshGCIAuRXanLfsBaJcWkYsiF3lYZqa?=
 =?us-ascii?Q?hXxtGZW3JFZBuQpSwGdCOozxWbj9rKBtuZ5roTFB/QFyvG2PBsXoou+YjuPW?=
 =?us-ascii?Q?zf96elVPE8twCYxxUjnHlCJdc1V9xIfPInC11qN4FKEjC5kpq2JjueXk2YSH?=
 =?us-ascii?Q?YWPvWsaP5xii2dVsejFnd0DY808sQDiUwMKCWYiFlIk2GyypaFYx6blRYM8m?=
 =?us-ascii?Q?8E0KFNxh39egjUgPIF1fb/qQdKGyRqTUvRnpPrtF6pB2VFRJRizha6rELiRm?=
 =?us-ascii?Q?628i2y3AxlX1AAZSExbM23T8m0X4k28gGVAKNH1fAfzGuoCU4yUOOJJFzBVb?=
 =?us-ascii?Q?XS21skx6rTRsXr/DS1nd4VE6GzaNeyf0WocBoZJ+yK0FnHbMnrk++xSRwt5L?=
 =?us-ascii?Q?GfSESfUGMsrAZMAUGy+rKeZ8BVGWrN+qleYJ2gqQ2b9T/WCRK6I98w3KV9rQ?=
 =?us-ascii?Q?8xgAmp5x0sYvMg31DLqsMJUAXQJISffShV2lLgaLTascssE0A9Kz1xTUcDhl?=
 =?us-ascii?Q?McUa8f/77TWXLJP/1x+mSmmjuERIo0VZ267XxdyX?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2025 18:44:47.6686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 333c9e97-a8c5-48dd-f1af-08de1a3fe60c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD82.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4247

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


