Return-Path: <kvm+bounces-22792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 143359432E8
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C8291C211D0
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119951D3626;
	Wed, 31 Jul 2024 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fRdWxwX/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB611CB32F;
	Wed, 31 Jul 2024 15:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438590; cv=fail; b=MBI12GyWfrP+8tN1pl8TbJblks3quzEPToStlNZdWdzWLbNl7YuxB4wSjSCg9rTW41NYArqMjICmvrAOtvOV2hGW+98bkkHmV/S4T4R/Jku1QQW+SBvZnjEA90oLxhgZbx3sh6cOWebTAu/+ofb4xzl6L2hYaULwY804Bz5tx8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438590; c=relaxed/simple;
	bh=2k6VbzH2BIqJNNwYxpT7TO+paYM30wolsECgnn94tRQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MwS1kr3jlKkdxyPNP0vjxq7O3oMCDeU+8jppLYJj+5D6hyn6FkXzu9x8om5VdzewG6E6/lBuEGyA1KgiBABAjlOT30KYiDjzHfxX31IVX3neGqOf7sdp4PfL4TYMwnOjX/Vq4HthqwY5rYbpjJWv95gaFqSMMQZ26rLncL7BEu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fRdWxwX/; arc=fail smtp.client-ip=40.107.92.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IX+BMBa9iti0Sx3v42x3CsK59eV70bbqiXzomz1ODUBtra++QYJBMHP/GJgKh9dmUgM84SpbfpWFqltA8TJd9d/GIA1+LRo8kl2LqKiKSq04ABlObTLDd8X7l4GIxqlcUutrTzUJsh5184DafbMrK49dIiKOig9tMBGqOVEfijeC4e9PSfDMY29qg9BHSo04kn/zYsGSQskBObdvBWekLEqTN3WRKtB7wLhgFRSy0BHxHFMK+lOYrqkE2bHVhlF8GpYGTOich529xcpUKX7vC9Gl1cClHRY0gAn8C6fDZ6cNxC5lOZzZ7ockiFPLHLyscj0urQF5F3Y3MATtMcNS1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R35YcfpMfkkvWIJmb1WPtShF2Ta3rExIk7TUgVjB+5Y=;
 b=uyJmo1XlB0C0KZ5WEOm9wfxayaxBmOpTp1ZfQcSxp67WscS2d29kwKKKbt6Ba8K2qhC53kl3l7NIIxUhtPtMYyvvwcCiU2niy5XRTGAA8C4cP9gIIdCHt8pyv3fnWZRIrBYLG3gRzwDWRE9pW3akuAOG3sa5lEgGmgkcw/xVW6mqwaHs8QLyyIDl3gIB459Zafkp4l94QMTYj1dvv1iydlNpHYbYUjfxf4EjbPpGMP2eMyjIPxtKgDDSAXfJoZ0cPFhefXQ82zZPeIf3PksCG++pyeQvVNpa+mfGYOqAXFT2R8kcHG+VeYF0TCCc8bcndwVIrfhjcru7R+QmZLxPHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R35YcfpMfkkvWIJmb1WPtShF2Ta3rExIk7TUgVjB+5Y=;
 b=fRdWxwX/pKN/kKsW82CjWXMxFs0DBD8b1L41+A2Z/NESDZEANDLfzsRNjeaUQRM/T/WvoZNpqPaweJbfgB34qeJiAfInBS+ks9N9q7eJrtcW230fNcywPQUuJczoEyHKArE2If1m1EH70fcbE50JK6Uu0egIITM3Nq30+Plxfto=
Received: from DM6PR13CA0030.namprd13.prod.outlook.com (2603:10b6:5:bc::43) by
 DM6PR12MB4137.namprd12.prod.outlook.com (2603:10b6:5:218::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.20; Wed, 31 Jul 2024 15:09:45 +0000
Received: from DS3PEPF0000C37D.namprd04.prod.outlook.com
 (2603:10b6:5:bc:cafe::8) by DM6PR13CA0030.outlook.office365.com
 (2603:10b6:5:bc::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23 via Frontend
 Transport; Wed, 31 Jul 2024 15:09:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37D.mail.protection.outlook.com (10.167.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:09:45 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:09:41 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 20/20] x86/cpu/amd: Do not print FW_BUG for Secure TSC
Date: Wed, 31 Jul 2024 20:38:11 +0530
Message-ID: <20240731150811.156771-21-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37D:EE_|DM6PR12MB4137:EE_
X-MS-Office365-Filtering-Correlation-Id: 2431b0ee-0c4d-4678-e36d-08dcb172d009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?elEgJjT5FbuQ8tfjLqoqI5eFNWzyijAjWL+kZt1sHfuTX3QLTH+oLGgCdLFH?=
 =?us-ascii?Q?FNrkdESnAg+tdwDofX+E8XNxL6HwCwtGLHQJZwePn8gVapzkSXYBBlUjjtOL?=
 =?us-ascii?Q?mhbltsIdVwOwWHmW/QRErlDUOS7xT91u/vdtaYi6blheDkKnadRuqa6cjx1l?=
 =?us-ascii?Q?0B2fgK1kFKvEieWMq/9ASVOgpaMTysYR04ELXu7liS/dKBOhFTE5+nF+iNnA?=
 =?us-ascii?Q?o6FZ134TZAIaM+f4BfugeWrvOTJDYvqo+qD6LAng8MCVWzhpO8pbXj9KVl0v?=
 =?us-ascii?Q?aRcoXQ72H8OCf8F8HMUO1fuImlO0odzRqSmKBo5cxh8KxNnFKqGWOu5+j2th?=
 =?us-ascii?Q?MRuuPzPlVLwxjrEAbG23hW6ns0iq7bg05uEFZ142J9f3HRXXrY+QiqN+IVJb?=
 =?us-ascii?Q?fnoNf1LZI96K0jbuKxpie+KVrgybOcouFUFwzs1/uRF1hq9HvSlQfXI9uUNA?=
 =?us-ascii?Q?9izLhSYlrGmpkCNBYCE9Mhpt5lURk7rh8KLIEUNZ0JwEbP7aVdrl8Vvxkg2g?=
 =?us-ascii?Q?m+juT9J4u0E+9t66o9yOJtewqH3yaxZKlOHd47+ga2ASClrzTNWCJKl4vOSB?=
 =?us-ascii?Q?6XMLP5+e2eZ0XJzBhi7suMmm9JU4qz4MsBInLJK+d9y5KfT3mSjU4Rhvrbhj?=
 =?us-ascii?Q?y8LgzYiLEje4++/D0uytdc2Zp7uUFS3fq/A09z5g3GdMc++MOgeLUecrb7QO?=
 =?us-ascii?Q?BGEH1Ipp9oDB+OIzJYxekOiA/EStf80gTcpk+/cqNGVpoUXeC8S37YFrFu+H?=
 =?us-ascii?Q?uolHMPPCBF0nnXqJcfyHtQv1Q9ufhuxS4p9dhClBg6kdvUXw4x3SnqtBU+oD?=
 =?us-ascii?Q?NmR3Pqm61Yt6JU9h2orvRxPyBAV/gvYRTcsLvvQhRvnmk14vyldrG4tH8N6q?=
 =?us-ascii?Q?SPGXpZ707snv7rnrEqTIvHy7BiwjgowJZ+qV5dNHoUXaBftBat1sxOZ5tGx5?=
 =?us-ascii?Q?wMxMts9ygjFy/Z0JAc4nOoUnt0kIT3iyx7AdUzjCAiEnRLE5PbHJxiVcGNWn?=
 =?us-ascii?Q?j8zxKRkO1V6JSrF4KQHNXrdPSDaSHpB8qCsYj9JcirBfGN4GVZGA//J0BHEE?=
 =?us-ascii?Q?rxvQVs8qKrwVOKh633U0Co8ty4THRRaTIvgNJ+XHt+gpBm5FHS6TXcgC4SgG?=
 =?us-ascii?Q?AlpqRmqcAhQyeOLMonwqPbblzZWFYFWYRZegzPTu2etZdXoo2SL75rS14gLF?=
 =?us-ascii?Q?w96G/QKLT5FbjQlYr2NMi4MsgVSB5UlUYRSfzkEDPgV3xTAc3lzgOncgvaVL?=
 =?us-ascii?Q?rKHeRBjlEdCC1cndahD59Y3ux+TJLLFZogdGv3VNBsBnZwAhNKLcOdhiV6LG?=
 =?us-ascii?Q?N53U5h0Ryp/qJZ9xML7FQ63Wc58Bf1+243Ce/CTn/xWaZovu44wz8d0XyD1k?=
 =?us-ascii?Q?q0Imao4Ypow5+3CL7CDs2X/wCamRK6AiT9yZwoTiWaop07D7Dr1q0KCTW5kJ?=
 =?us-ascii?Q?uyV1YLlcC9JUZBcdyMwjVjua53TzkVxl?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:09:45.3371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2431b0ee-0c4d-4678-e36d-08dcb172d009
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4137

When Secure TSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_edx
is set, the kernel complains with the below firmware bug:

[Firmware Bug]: TSC doesn't count with P0 frequency!

Secure TSC does not need to run at P0 frequency; the TSC frequency is set
by the VMM as part of the SNP_LAUNCH_START command. Skip this check when
Secure TSC is enabled

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/cpu/amd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index be5889bded49..87b55d2183a0 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -370,7 +370,8 @@ static void bsp_determine_snp(struct cpuinfo_x86 *c)
 
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
-	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
+	    !cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
 
 		if (c->x86 > 0x10 ||
 		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
-- 
2.34.1


