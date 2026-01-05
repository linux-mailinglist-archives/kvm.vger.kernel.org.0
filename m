Return-Path: <kvm+bounces-67003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F38CF2157
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 07:37:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 03D2E300976F
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 06:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9EB34502A;
	Mon,  5 Jan 2026 06:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DGYifX6X"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013033.outbound.protection.outlook.com [40.93.201.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2D026E6F9
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 06:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767595036; cv=fail; b=sDyew7+JVUGvupEkRZwHbEzyy3cwLKXtR5w2iwcfh6W99J6BCXxbVN1mTDtFUcGvoImzMCG4U6VDrxp6+q66VSLrxr44h3PfN4ur3/uKXbvM/dky7ou4TyPN0x8s9mFZSkDjetiHN+s+HJoOxM2/DrKHa2LuzVVkm8XCYchfdgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767595036; c=relaxed/simple;
	bh=DGUDiAvzB8Ly4c8dJZyYOhYo7dqDOjL5RzXhFn7lZOI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rGCPP7Z3nvoGmEGsZVR7lzM+Oef+H3pBreO1J3JLHu0zLOlDBvHo/XxMVvi8oYw7K95g6GrfppiGASZGZ7VaclHZo10tpsxQc0vNbowzryXZGKadS2NRsVYFkPlghdKreVpkAsQ6LeuzSnAH9fc9PYerDBPAz0ZpMXG98FjNkag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DGYifX6X; arc=fail smtp.client-ip=40.93.201.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qcbgMeOkUq3MnHygvp2SqPEe7BmtmsK5dJdLw5YGg+3+JnzurpJsC4zZ4La4iDNvxlDFogu1DEcGUZ4rHRJnEUVEiLYrUjTHjBvubogiDar//52Q9U/RZ95YjYgNnixQa7ggaa+1lCFAXM6ot1PYpg1vCboJyrvjkWuIC+2Fhl30Eseo6AP4AYwbHbQBXthatGwY/hx8jTJC4VYUY712sbD6RerCqqSfMRCQ08XU/cNjQwJ+L+Aeg84MHQt2eKYHlYiLjzrQ4EN7r6ZxnnZxNH1iD+uJLzwShx3Naf9naSmApknKjAlZrCnnft7pb9jkt9QHip9spoDPbLxfN0uosA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqp/jcYBZ9+9hoxeDr32aFb3EGC1/NTGyN6wt6DOGRQ=;
 b=KF24goFvuuIv2XsjAxZcMs3ctl7hVt5Fe1ThNozxZAMvBy8M5KxjzLNN4CY+RIz/Cssv220ee/WVZJvIYWNABKo/byLWfoeOyGSHLDDJ7mnYmbhWZzlKjb+p4nY1VZ1niQZGjxKw5Y+otaDAkiD/ut3meBVdV78JxVjzte65+0Wa6UEVaAacXF7vjCRG6U9TnGJ1U/sWSzLvQ2mXAkuy6afO63ftcHlE+7m+jOzs8/3JPkGjZJnWaUJt9sR/BNMKLjCt61q4WkbSC4GY15KVkcOdo+CNzx94NDOKlhe4ZwQOhBKWaP2MaYjWZL6F9oYUbxHfllXQCsXIi4BQBzM3AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqp/jcYBZ9+9hoxeDr32aFb3EGC1/NTGyN6wt6DOGRQ=;
 b=DGYifX6XksQrzY8FCdEkU3GiHs0uz1uvwEHFSuBqF3RSi3ZLThxDngee0c4Oba3qPzbUNfjwLsOlsvlFa+k1i38VGReqSPhY31Jnd/4BAb9hYGuuiaxLQ7bxwXFSgbI+b3IfAAadHuV5JRz3VqUP+HCl1MkZldxZcw8eoNXR3nI=
Received: from DM6PR13CA0030.namprd13.prod.outlook.com (2603:10b6:5:bc::43) by
 BL3PR12MB6569.namprd12.prod.outlook.com (2603:10b6:208:38c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.14; Mon, 5 Jan 2026 06:37:11 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:bc:cafe::ae) by DM6PR13CA0030.outlook.office365.com
 (2603:10b6:5:bc::43) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.1 via Frontend Transport; Mon, 5
 Jan 2026 06:37:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Mon, 5 Jan 2026 06:37:10 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 5 Jan
 2026 00:37:07 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v5 6/8] KVM: SVM: Use BIT_ULL for 64-bit nested_ctl bit definitions
Date: Mon, 5 Jan 2026 06:36:20 +0000
Message-ID: <20260105063622.894410-7-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260105063622.894410-1-nikunj@amd.com>
References: <20260105063622.894410-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|BL3PR12MB6569:EE_
X-MS-Office365-Filtering-Correlation-Id: 44fc8591-11e2-4805-4e6c-08de4c24daf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8x7MZgfnzJxuy3eYmVBCw4tsiUvBUa4F1F2DOyZvmXdipr235VEI1XjqlPL4?=
 =?us-ascii?Q?Gg+d1TEloBDnMOfA2gnpZPq85tR/GTiC945HlOG2gh29eaAQjhE94LX4717j?=
 =?us-ascii?Q?nmJuSve7PtL+SVfImvZjAfYXz5ggXU3c+kSvqBIog/TvOY+LniOkb7cydQlW?=
 =?us-ascii?Q?foRdyi4n/XjHAw3P+zlqT2fGWoWHcxDwRpOEnVCJxlQkUE+dLtuzH9SHTJ5N?=
 =?us-ascii?Q?iSzltKewoEY9/GqWXUbs1+7W6SxfIWMHCcmKj/GaqRiElqEO27stBd8xkQN+?=
 =?us-ascii?Q?6ssTJXs7GNQhfI/CNvhwPXZ8vCxalK9GLIOiiWI+fSb+QCxSSJgfuOW2PgiJ?=
 =?us-ascii?Q?fY8XRtxfFupKRzoW9yKGmvSrTp3e7WFUyUlJC0aLSm5RSYOgQwVACKqjKJUv?=
 =?us-ascii?Q?2Mr4Tirh6nJEjjSmEwkz7YikeX/mW8LolfJmkNQ2rp6U2tJf9tNaEWFlVfxr?=
 =?us-ascii?Q?EYkJYFuxk/SKlPz++X2XoN4h0tqWszrNiiq1attB4n99bsCzospvTGPwMvYx?=
 =?us-ascii?Q?gCPuLzFDOEqSR07D9hUGTHLHrFvdrgrlzvyIm+ROKa13R8XFMUY6xtxuzlan?=
 =?us-ascii?Q?mU0cWeZRHfQ9YA1fQZ3Ri/btgvin3zt0+uCo2vmjDYPFBnbgpyTnaU/G1VMt?=
 =?us-ascii?Q?Tznr9i2jlUiQFl7rKoL6RkfdDrtMTQstZMbI//AfNxZwf0ALVGcWKaiUj317?=
 =?us-ascii?Q?q0f/AfO1yuYe5jbwvsDvocG5PguOdmzZePbD6DIunNWJ3O/7lsQkjEyrhnfy?=
 =?us-ascii?Q?TuK4gTK2eztLeAZ35m4ToiX9trcPBsko1vnWnUgMdK2PWq5jFyz3mLitLAvR?=
 =?us-ascii?Q?Cn7zj+Zw9NA5WduLBJ9vY3+o3GkrXEUEyEgM4zHbNGYj0o9wnkLZDRgYQQ8W?=
 =?us-ascii?Q?O1I2gds/5C/oG4+P7cLhNKil+HepzQ4ygxXOOMTtWVrgKC96/2CrP3pPNBN7?=
 =?us-ascii?Q?GULCHJMSo7up1poMJm1vXJGN5TwKEfDwYxZQoZfF6MpwGMlX21j2kp/Y4dHj?=
 =?us-ascii?Q?yv1HK3ZtHHvkomcDpFFLsN0Cz7q+87a87pClkBsla+5P/wKeKeNRjtzLjtaE?=
 =?us-ascii?Q?rvWCG5/47o6wxJSzhxrxby0O2EanPZaU0IJMddXrjuV9TsTfR2eUCSo/rhY8?=
 =?us-ascii?Q?NvJBFDAoUzO5qkGo7ZflLGggadwrwzRYdP2v305HFAe9jSEn7Ye0oNhbmaPq?=
 =?us-ascii?Q?o4vrufR/MyaTaLRu/EYwbOZjyJO83mGdG7NwsJSrvXkuLvvWpN5y0M3yxGhc?=
 =?us-ascii?Q?1YKwPARLB6jUzPlExq2IgfTYq75lQhFxOmyQVT2tGtBFt+el5V4qc3+p6emM?=
 =?us-ascii?Q?CArXb4lQAKXA+4jmOPj+nZE+JVImDjsaUt/jqw2kye4J8vvUYQtDNLnLo4++?=
 =?us-ascii?Q?1t0dLw2ESCCtGKq15hjGVZ/v0PciXoGC7a3N4qnZKjYHky3XE23o8FU14Gx2?=
 =?us-ascii?Q?lTVhJmrnLZzd9PNDOlGpeFJa/6XNXhbFWwCWAifPJcXRHdfWpgMVep5GM85U?=
 =?us-ascii?Q?C9xHyZzqfsT5IG8H+ZBCtXiAERof/uYI7oJdUXt9gAswySdULVar818lyVA0?=
 =?us-ascii?Q?LH1WbyA55dIp1xiBG1M=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 06:37:10.8402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44fc8591-11e2-4805-4e6c-08de4c24daf2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6569

Replace BIT() with BIT_ULL() for SVM nested control bit definitions
since nested_ctl is a 64-bit field in the VMCB control area structure.

No functional change intended.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 56aa99503dc4..751da7cbabed 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -236,9 +236,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
 #define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
 
-#define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
-#define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
-#define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
+#define SVM_NESTED_CTL_NP_ENABLE	BIT_ULL(0)
+#define SVM_NESTED_CTL_SEV_ENABLE	BIT_ULL(1)
+#define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT_ULL(2)
 
 
 #define SVM_TSC_RATIO_RSVD	0xffffff0000000000ULL
-- 
2.48.1


