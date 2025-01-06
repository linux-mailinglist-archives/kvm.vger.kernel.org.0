Return-Path: <kvm+bounces-34587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 71064A025DF
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:47:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BDBD7A225A
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD49B1DE3B1;
	Mon,  6 Jan 2025 12:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LG9mKTXI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F60524F;
	Mon,  6 Jan 2025 12:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167637; cv=fail; b=IhqqBBlPgCPWyh5e1D7qbPjT5PbA7dhAlmOrZdPGzWKtLfe5GDfQtE9uexwW6yGXdOb6C5SJrDyTRbLW0FQDbYPz9njMlQnciLQU8SHM2Xp6j0QLyFDY8XEMChFw47OmaLZYXiMPk7WK52GSztENWgD7Oa5s55OYvmOauoYNMho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167637; c=relaxed/simple;
	bh=tBbe5Ql2xsYAQyh2i9G7IOX4cl9l5ObRbbFHhcjvsTM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FOH1QrEGDGmGThWcnx12wbMAi8qN/UVgfy7uXaf3dhjmvJBJsDOkZn/6oa3bC/kOD7WJ6uxbLzTNuURjzOsoy7QOa7NmoM4y1K+2qMXn90ipAtiNnAV6MaNH5JffrNryWI4gh1+B5AqnhwRXs38S609DjT9COh/sUBAkvc7ikBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LG9mKTXI; arc=fail smtp.client-ip=40.107.236.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aMlODoy7yqjJ9r1XxZihTrZ2IoJCTfEJPqh55M1FqOubWJnTKNaiK+wTR/Ulrl6ELBuFmHq48EAkM3NuS7TfBbbcQA+GBTrsnrJeVaw1AvhFXu1VQS4qahOdLcTUEpzqNKRHyOM9ODmwfKRxWKonwFgxnZE5P/XBh7MJNmPJURudZpFwqlqXk/dWIpFf9q73mYnRAuImParKzfLwYJ6V/tVXAZUc8AX29oak57EDMlstdUYRwr+M2y04/ePp7utCbULFSRCFUsAsQFkQr15OveuasGV/2dOCdWt7oUOTGBYu41o7h8Yt9pAMIvfWQUf4X6jfWvY/YF4uucrqnB2iEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BU6FsDHfqlYHB99GM2i0SepixtliORC0TggV153a7Ro=;
 b=hWiKQqOcXVfFGUr01Pt78wf/HR6xT9mIjFFY/TtGiE3LIWkEIWz3KA3wS/ZypNDxHRhVQKZh0HFqLxEEWgw+Agrtt0DpG9kP7pG0Zpqzk3dGCgrhQHPOeBictkfWiwFfYP12N8R+b3s1rj3mftScB7yiDA5DrhncnzgedUwL1Z3qHiA92HRQuHMR6onx4/iclzaNKjIqs6kYlQZ4TuYH/nDNAHwPP/jkohTgcowhydQEq1voZI6FgR7H2JaZVVaHGvw2n7IQEIHbWPj5bIXgOUm8uFS2J21Q4fGoeX7S8XAJyZcf6peX9gGstXzV5aZkeTpoPQ4nYH3lvVAF897nbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BU6FsDHfqlYHB99GM2i0SepixtliORC0TggV153a7Ro=;
 b=LG9mKTXIA9DqgF+MXShfAlonqLey+/MUgicVeImTMW7pb6iRYu67V6TJCZN9Elm92yuFolr5KLhJsJqGQv/kXqnpJLDe6B6e0AMnb4iMuYdNPDIN6JCW9lo6mUAW5sSjN83DvMOY/+iH8WbDVhHqSdEv3aBuwq3VxeR90ARYhAI=
Received: from PH7P221CA0013.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::9)
 by IA0PR12MB8894.namprd12.prod.outlook.com (2603:10b6:208:483::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Mon, 6 Jan
 2025 12:47:03 +0000
Received: from CY4PEPF0000EDD6.namprd03.prod.outlook.com
 (2603:10b6:510:32a:cafe::1c) by PH7P221CA0013.outlook.office365.com
 (2603:10b6:510:32a::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Mon,
 6 Jan 2025 12:47:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD6.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:47:03 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:46:57 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v16 01/13] virt: sev-guest: Remove is_vmpck_empty() helper
Date: Mon, 6 Jan 2025 18:16:21 +0530
Message-ID: <20250106124633.1418972-2-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106124633.1418972-1-nikunj@amd.com>
References: <20250106124633.1418972-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD6:EE_|IA0PR12MB8894:EE_
X-MS-Office365-Filtering-Correlation-Id: 138d52c6-b09e-4163-d436-08dd2e50384d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?urotcq0NZXIQn38J2m8Z2Viqty5d05wZDMYz+cyG5IRymeUAQARDD8+GsCgM?=
 =?us-ascii?Q?CoLXXcs0NKk/s2eyH43csV/w2cau+xWYJUgejQ4U+DlWO0Y+U1zXSdzsyCJn?=
 =?us-ascii?Q?nOeHn/e4Nio1ojvzxh/PKSGLiRJGsMRFY6FGG6rJiz/Ye1MM1H5kywewoJ+W?=
 =?us-ascii?Q?YgD+iovJ03I1SqgDBU9zq2hbu/ylXIYkaJGoRvvnkZNpvCK5Co9FqtpyYSl4?=
 =?us-ascii?Q?9pkyMkTd7w2woZP6h0GDkynACZG4u9T2etAov21q93K1ZKfMRwOH/p2xIREr?=
 =?us-ascii?Q?pJOaomV3bnfWy2nEGz0huL6RwlHiZNugV0e/hZj2T5KkLQCqphYGMUd/jNBw?=
 =?us-ascii?Q?4y4b5RA1eL+7gBvRQ1tWYFdyNPuLZsPKqS8PKfGDVDGO69A36T1VEmRfeED2?=
 =?us-ascii?Q?cLiLGOqSuskca5HMIgjoiZL7T6Uav6paFtMmYLgd0vOidrDxPTZzKfj+7mxv?=
 =?us-ascii?Q?CoACNV1yXUX7NNzFDqzrm9A7gZcXTP+4XqfHbkvCaZznmFa8w8shLejnRUcm?=
 =?us-ascii?Q?bt6OapQk6LBFr2IzgekzKHRKxDYORXpVphh1QbS0qch14BrOj+jArAm8gt5d?=
 =?us-ascii?Q?ohQuz8TuQ9oKZgxR7tXW+flAy0MfgD7jG8h5BsKoJaKJTpcONHi8yy5HP1oB?=
 =?us-ascii?Q?fbU8annIIpnUUidtuldijPQ6y2QnuAw59CboXOyDh7gHhBHBO0655Rae6GwO?=
 =?us-ascii?Q?wNXjMJwLQiGs2KWV8iWQmb4DUTn50pi3wDmhEG7eriEURacj/x0/fFDuv/ib?=
 =?us-ascii?Q?6HYPKYpQNNyKAXcQ4tj9sC5ixPQIvaGB5aZQ8W2bxz1MDBzc7xvwmJjkWu8a?=
 =?us-ascii?Q?Pv4+Qq40KP30fjjI/f8Yh3WELe7TKWfeKibi/MMQdeVMRQp5puzC/wUlz1D2?=
 =?us-ascii?Q?/eEkQ+ve7hHF1E7i3kBRloHmP5UJXNDWpF9ZAHKUZE2YQGmkeobRSUmEILqI?=
 =?us-ascii?Q?v3bY0Bwrbt6+O3/qTID9T556/NYu2DymsZSTsSjPZXmxTNhPjvlFCv71KMvB?=
 =?us-ascii?Q?F4WRm+YkRV9ZgzJxkFJzwujLZRWxCFvAhjPoG5+CZk/6zzYqupvYEsSvKEGD?=
 =?us-ascii?Q?I4Pk/T3xHCk5j+LS+rjblhvmADzMJLfLG+AJUyu/Te3nUp9jfk4WdQFxzgHl?=
 =?us-ascii?Q?Qan6p/twzlTUBIqfZz3BtUFCATUopCW34LH1jRvHOSiZQKV+fjscF6luhG4a?=
 =?us-ascii?Q?SXPsbzZzQh4lRNoO7OGtYlrlEURc0kvkUq9IKUMgzOB7IIK0qFnoaafGAcit?=
 =?us-ascii?Q?GpnEfdB73smDzSUBhFeCTm00Aczd2HEg3NOqsLj6A5yBpBPrxZHWk2d8bjiW?=
 =?us-ascii?Q?FHnGWS9cEJRLegCeFxRMZqa+4IKbrNzYaQ4oHKNF2GM3SssDFp2lmNNCORsB?=
 =?us-ascii?Q?GcsaXhDS4PH/MJiZKTTx8prKJtmU+xIZEK7nEcIfRZi6N8fUe4Dl4bMAGIIs?=
 =?us-ascii?Q?5/aGpKfV4EUnetpEhA98ABHu/RSjN1NJGzMN2u3px3+U+gEDkeh+mNkIxOi9?=
 =?us-ascii?Q?9R5Avk8E/lHgH/g=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:47:03.1645
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 138d52c6-b09e-4163-d436-08dd2e50384d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8894

Remove the is_vmpck_empty() helper function, which uses a local array
allocation to check if the VMPCK is empty. Replace it with memchr_inv() to
directly determine if the VMPCK is empty without additional memory
allocation.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index b699771be029..62328d0b2cb6 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -63,16 +63,6 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
 /* Mutex to serialize the shared buffer access and command handling. */
 static DEFINE_MUTEX(snp_cmd_mutex);
 
-static bool is_vmpck_empty(struct snp_msg_desc *mdesc)
-{
-	char zero_key[VMPCK_KEY_LEN] = {0};
-
-	if (mdesc->vmpck)
-		return !memcmp(mdesc->vmpck, zero_key, VMPCK_KEY_LEN);
-
-	return true;
-}
-
 /*
  * If an error is received from the host or AMD Secure Processor (ASP) there
  * are two options. Either retry the exact same encrypted request or discontinue
@@ -335,7 +325,7 @@ static int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_r
 	guard(mutex)(&snp_cmd_mutex);
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(mdesc)) {
+	if (!mdesc->vmpck || !memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN)) {
 		pr_err_ratelimited("VMPCK is disabled\n");
 		return -ENOTTY;
 	}
@@ -1024,7 +1014,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	}
 
 	/* Verify that VMPCK is not zero. */
-	if (is_vmpck_empty(mdesc)) {
+	if (!memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN)) {
 		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
 		goto e_unmap;
 	}
-- 
2.34.1


