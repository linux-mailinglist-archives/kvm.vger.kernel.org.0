Return-Path: <kvm+bounces-20269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 58D2B9125DB
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:48:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D151E1F24B67
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C07AB17B42F;
	Fri, 21 Jun 2024 12:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="caO8ydwn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCB8155A35;
	Fri, 21 Jun 2024 12:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973654; cv=fail; b=oaDFho5s0z/6kEW312k/IK9X1voMY2gY/Hvi2N+pUXQfyB3ltGlLavVNyB7RTATaGdspkhv47oSfAl7LCqAygko0V6+Ax/+U5SeSn/8of2jFqRD5Ejd2O/B/KeHt1ai3bXu6RgUtGppiRcQfGxMeJU2cMPuJIa+D5fxz+OPL19k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973654; c=relaxed/simple;
	bh=sMUEgS2OAgLUi3hCkfqVE3W55RNR9QGPfw4LxwPs2VA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MRsaM+Ux6CbtllwdssG/Ow2gwHskTEr8+wpvzAUkNDF2kix2Od5se9FACYriIf4hNsX0n8gglpkR1lF6lV3USvzFROdstZLdA+kGKXHFdAubnugDYImCFbdeLK4MuQ5LZ+GcjZYv/YpGDyGNzTDXOaq657dUgUJd4P9AFDdo+sE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=caO8ydwn; arc=fail smtp.client-ip=40.107.92.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBB8cexYfcv5BF+JIQDI4Fm28MHd8rZmEuTKTPagg2+XSN2YBN6cSK1TUlK/Ll4W9z7t1bw3Df9lcMIsn/ehhohi7Ef+YLy9mIigj9K4q8wsfzFp8kYd7Q7aidpD4y/0Vq2X4ANC2wQKqBQ06//kOTSVPZSx9R9RnmFu/JeMZxzNZArJWipot0iz1eOPWjzc8ptOKA0ZOn37FDwe1GIym7BzycO6MdLC+O7+WJ2iFXyqtPlCBoHgMTinWijuQnXH+vP4x1+XfpclAf/XIr44bYhvf1DBJtFt+KKDxTw7CF7pYluPEQmF7LqZpIJaI8XuRqxsIl8XPFPpAwJ9Z+RH1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxzyqnMqVWcls0UcDrE4oX6b/GsUu1v5GwYmfO4Rbxw=;
 b=gFr1GgiQSEY3NNo3fK3fWNTv/b85TVQWhAYbQKVLBx4q7c23B4Li69PsiYLp9HI9L1ZwWTFX5Em5X7WTR5pV6HQvoLOUmWBvhj5GfbDBaAEaWov3kVub/BICgjky/7lJkYEWQht2cb/HjLR2U1UA1lQZVCytYOp7YCwRj+rJ9MzxI0S7PDOZ69EwPmiysFb/0sQHne1Dy6xOzGOsveBmksInOspAr/XDjk2himt3xS//a8v8qk/q/siqhuxkclpePQFPs6f5JNI115CteDiXti6+BnPoWCqcxBwUsEyD3nhABjeHkqgZcQhUlWEn884UbEGaIPFQW2sZDxOWq+abHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxzyqnMqVWcls0UcDrE4oX6b/GsUu1v5GwYmfO4Rbxw=;
 b=caO8ydwnzEl51SgyXCXr9/b/Or+lvKfskr0RFZdIGkg5K131Lkh8UeaX4uHZxw4e5RDHfTO+ZFvfoQlucp10/gZ1GfYjzNDEcj8GcqUabcjrwM25xAVlcaDLcGRzXcYxxcnNwYkZonmufylLNt9ZAvP9a0J7/7UgfN8TXNikWwI=
Received: from DS0PR17CA0023.namprd17.prod.outlook.com (2603:10b6:8:191::24)
 by MW4PR12MB6852.namprd12.prod.outlook.com (2603:10b6:303:207::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 12:40:49 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:8:191:cafe::68) by DS0PR17CA0023.outlook.office365.com
 (2603:10b6:8:191::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:49 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:45 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 23/24] x86/cpu/amd: Do not print FW_BUG for Secure TSC
Date: Fri, 21 Jun 2024 18:09:02 +0530
Message-ID: <20240621123903.2411843-24-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|MW4PR12MB6852:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e789742-fc63-4e81-0e21-08dc91ef6180
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|82310400023|1800799021|376011|7416011|36860700010;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kWJUH3DhDI6FKEn4JP877JR5S74AaCDOYkqw5lpssKtPU9Ay8rwyufvMy8IV?=
 =?us-ascii?Q?rwQY/h52q3YfekrMF67L2qdplRtz7p8aD4xlSs6DyePNDzQy7wrsJCMqw8ZC?=
 =?us-ascii?Q?h0wbti25wMFztHEhsvAd7sVTnL+Rf5UlzUc4UByFHUJiGqQXUeOlKQQy5fOq?=
 =?us-ascii?Q?yGiB6YNivU+df4/jwcxMayCwh6FjsEGuhGuoJRJQjAwvILCxE5V135wgjzk5?=
 =?us-ascii?Q?/JOEK+TVcPJtpw0KiEbvH0Kpz1zLrBmH3jYPnoRhfrlZrz0yhZRjYbB8/LOG?=
 =?us-ascii?Q?KGdNX+5H6l8QONsBzz/TiCazFWQufszAg9pHj7bJdCAOLWFcOzXTSMUdCVeg?=
 =?us-ascii?Q?VLlFVHH4jGgWFrWdDdRBt8sllNLiCj8IzRJasCty+5Q+W0l0ZWSB1C4eoKHN?=
 =?us-ascii?Q?pro25QVgnK6uxUEvvnxZYguU1VUpPpa7AvyUiqS5mwY/6lh/bL49KtDLMsbj?=
 =?us-ascii?Q?L1f+j71Ac1atlgThX3jkIK/9KT9FGVIPf4HnsdxJ+sqrBg3ZAvulhIPrwnHo?=
 =?us-ascii?Q?m59sftB5+ogZotPlnH8z/b5WBlJgxuDUa1sCQ1tS2qEXNlQwelgl8i/lv4yD?=
 =?us-ascii?Q?8tXr3/NOXgPMpUtFqzzMAaAt+JW2EmRVdhpwD0jshvJVuITwheyKfR9RA0r7?=
 =?us-ascii?Q?RMdvp720AaR7k+gEnZOClIjQ1DOT4JR2FJJWwnaoq3YWkGB2d/tJR3MYzPYC?=
 =?us-ascii?Q?RIZ1LvwsBZT+oWJBknPCWXYMnyuIGQtpoysecoOMgJUoYnqM2dGapPgYo8eq?=
 =?us-ascii?Q?kXG9l1YYW11BCvyXdjnaAHU1WrR5GhTCyfnWsX79s4obojag5FrzrmOCRza/?=
 =?us-ascii?Q?dMelhYLW4Yt8M+OgdzcRHaR8vDWjyzgaNMpPziqzrpMVcZQvLnvg7tFSl6ko?=
 =?us-ascii?Q?AKsQ5+osVQZw6V9PyHEqGaAdfU00V1qwUAwexP6JEKRz/fQ/SZX0dmRcKA4x?=
 =?us-ascii?Q?cw24e5I6e8bILAc4+U6LO0Dvo4wiKyLwJLRhovt/F/wK/k1wGPfuZ+nAWOqm?=
 =?us-ascii?Q?QT/WhDm+RchYFgLQ897700+Zk0Z/trlvg/KVDHebYQ54dTqGUT/ghgv6Wyuz?=
 =?us-ascii?Q?NkF+sLnGF/ZhfhTDb9D+veSOaaxWEen6L8jbVcRH7FGVtVIWCeX1AxoDDAnt?=
 =?us-ascii?Q?hzfs8im5uDFOempAvVCHyQLOtRNnIhfdJYw6f34KdhrIeoQ8CveBtJPdgWxW?=
 =?us-ascii?Q?KK+6v9wLhB70GT9HP8DYbpJdRBvH/PkyMAUcH/AxIAaC7T46zZJNdY1UW4+r?=
 =?us-ascii?Q?XN6hlEFI0qHDcikJqT4bWCbKorbgmHlvDGD98RuLvGOTMDspavyEwx6hQ6bw?=
 =?us-ascii?Q?/ImcA13Jvgyzk2lcRi20tQSMub4rMy5tQvYfxK0+fhWNgMFsZFq3YmVier/y?=
 =?us-ascii?Q?pYZvV5wb+SSm/gqTMdmyJBkgtb4dXO0uhXtsGd9XlcEhiiMQbw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(82310400023)(1800799021)(376011)(7416011)(36860700010);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:49.7198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e789742-fc63-4e81-0e21-08dc91ef6180
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6852

When SecureTSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_edx
is set, kernel complains with the below firmware bug:

[Firmware Bug]: TSC doesn't count with P0 frequency!

Secure TSC need not run at P0 frequency, the TSC frequency is set by the
VMM as part of the SNP_LAUNCH_START command. Avoid the check when Secure
TSC is enabled

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/cpu/amd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 44df3f11e731..905e57ca324f 100644
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


