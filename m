Return-Path: <kvm+bounces-34594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A98A025F4
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C4A73A586B
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317E51DEFFE;
	Mon,  6 Jan 2025 12:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fmY9FcuB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7AA1DEFDA;
	Mon,  6 Jan 2025 12:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167662; cv=fail; b=f6ApMZuOM6hxHscum8TpulSIq7SVlGGV2uZSI1ea3M2UddiqwQjUQmpqiGZDZ02HRAS5Y3y071QMhlOX9+/vO5PlUodZjagilw4XzG3AVqgoxxO/2eap0Ws5ePNE1c2IwwHJWudf68ATp7bCJFNLtWIKH2PNOSQh5+9nCqptoNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167662; c=relaxed/simple;
	bh=Y08Mu2rxlE+w2qUVyI5VmnUDD1tgpq5fPwD3FWr/WFE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h2352qiaf+CCA932JXLJroHhAEaxj+tRGZkXbPs5szsjC7a7ywd5JvElb0G9piq61H9DKHwBwKfi3tCQx5k0M8rQh11IHqRPCtOT1LS7/sMHi0TpD5STfgnt1FsnEdF3HAOXXZwVHg4HrAC67h4HsrQaoAftUaeb9B7iaDsuDU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fmY9FcuB; arc=fail smtp.client-ip=40.107.237.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fk/2XwtQ+snmh85UzNwD/ZnmQYqP0IGGjDgMwUgfhk9A8yywoHD57YdFxV2ps5lRdVlS6buMehaaucVj5M1DHHu7izAzfLCN+UvptbZNYtjy2mIscHm5ZlCewrOucSp/l2gEvpxYaPaOqZj78tzK9c0zzwj2Gc3WKeKiNV4vv12pHXzfAaYLcBYP1L9/MICq/5J3RhQiwBj5fi8qaz1JQq14P6x3cLYEeRD3daT6kN4d5FgO4ws988kP12r4fthtO70wbK9fXc431jBKcyLk5X44h4eJXj1Cn10u76PY1RjUY3avBcNdYUstisNwyPPe4Hg010MpsP6fBlQXECR4Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aPI0daLjHC8yM9LM7zp/ewVc6T0Wd+VLl1TtTKp8Frk=;
 b=SHxtn2pe65DsQ9lmSIVdiRovNlXWt08y9PyefwSzeq+a1uCl9WCqjBPGCDvaFESEZypBvvDFabBI6BvjLcrd1LPvtRMD9pf3iZAt4TaPBLjP0gptKJsdU85b/OVksuQ+qJrIa/uhAgG0QPWOgDgOsMFGtvPrhHS06tt4T8IKS5BYfRXO9x/jAlc7ch2BXeyASoM27Je4G7uqARgS6idSwIV9sz0vO76s2LMdKhJq3E6iq1Ds9xMkps+vS3ozuiKUhqmZSbya4qA617UXc8+OXyuNqLtPhbsxk8x6G7DhcxhaaHKN1zHmZ0M1DezcymaItTsNP8cLnjyB21ERErC8xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPI0daLjHC8yM9LM7zp/ewVc6T0Wd+VLl1TtTKp8Frk=;
 b=fmY9FcuBD1+U7SqJgezSID87E/l/g7CGW82DYtjGVPG9G3XZ/Jq7fwzdczEcGg5WKBs+HasPaOJjOqjNKUA+Dt7CpndC+evYMwP3z2DDhZOrCWF/km+VqGr4ShTmKu8DEF0+3oqMePPVBoLLEBzcRgAy1BmHWGmSv/M+VyJpPB0=
Received: from PH7P221CA0061.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:328::15)
 by MN2PR12MB4062.namprd12.prod.outlook.com (2603:10b6:208:1d0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Mon, 6 Jan
 2025 12:47:32 +0000
Received: from CY4PEPF0000EDD1.namprd03.prod.outlook.com
 (2603:10b6:510:328:cafe::e1) by PH7P221CA0061.outlook.office365.com
 (2603:10b6:510:328::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Mon,
 6 Jan 2025 12:47:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD1.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:47:31 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:47:26 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v16 08/13] x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled guests
Date: Mon, 6 Jan 2025 18:16:28 +0530
Message-ID: <20250106124633.1418972-9-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD1:EE_|MN2PR12MB4062:EE_
X-MS-Office365-Filtering-Correlation-Id: 641947a1-75ef-4b30-8077-08dd2e504921
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VfTiny8/UaLLZaX/svKFeZ8bC3azUku+YkJn1dYeeSQfrRAUHx/HAsVEOr40?=
 =?us-ascii?Q?imi/cwLce5lIxMiFK6l5LiTUV5blvuQe9eJH7bNj1tPXEOrzy3Y77rrVa6j5?=
 =?us-ascii?Q?7LgepXQgVDp5Hm/SkeI8DJyfJP3jMC/xZ+ODcxc8xDzJBfud9zja1GzSeSoL?=
 =?us-ascii?Q?QRY4cxDx9zgwIgtlV3sxNZ6BW7JvY/dLdYAET60nJR1yx7CjZVfVbYjvYfUl?=
 =?us-ascii?Q?63+I3ii6UGTax2PWBNtJ46cILTrSRUQK5mMg9pYK4yF8CCD8LhP/rehP4+lZ?=
 =?us-ascii?Q?OeiLDs2FYhqs2lB77uEcxq1+HpGriGw9xLMWt+F/XbTyj1o0ES88Zh8PoE82?=
 =?us-ascii?Q?L6Sw1AqKcucypIhThRQLyqu6aThdum9JykrFpHnMAfWNJMLevoKzCLqxlEYt?=
 =?us-ascii?Q?L+PP2os89+Pbgw029SrVGSyTVLUtMCD9Zs4n3spVtIawT+oK4invp0kXGXKP?=
 =?us-ascii?Q?R5+SZqJYVNlx0U3FPIC3TBDWRQwBKfgyIUeBuuM8LRyFPdhIRhV7g1yqpFgQ?=
 =?us-ascii?Q?Dicxmkppc7YHUQqCu5ohbq7tKwavV8WwOKFB1PDsMC6Bp5APuMYIKFVxaHQ6?=
 =?us-ascii?Q?df3jKzCc8jztRYwY43MsjMkYiqoi5O+9Q+gkd6aLQB82+KKZeIyjOXVYy7JZ?=
 =?us-ascii?Q?6i+Ytqt/RGPHD6VvWkyb42VDDtDq2sQH9JCbGKkfLLg87K2F4nA2L9EHykDL?=
 =?us-ascii?Q?VTCtUNLHGAyXFXoC7R9oW4U7AMcwZS/Jh65atmsyXfvWJU8kSb12DXP83zmI?=
 =?us-ascii?Q?OoawcjWmxd8IYb85AGsgqIS+tNKBfTP8/Vpi3LMI/cbIGYw5mUUSpS8tqdLA?=
 =?us-ascii?Q?UOAVTysg117Bo9LnS5dImBo9yQTA5u0odX4FKLqtM9XOcz3d1h3VwOFAS+C8?=
 =?us-ascii?Q?YlU7kxOnQoH5a2mGn2lBPJbziHXOnSo4a7ItSD47zGxUaIR2qoKT5DCUnsiT?=
 =?us-ascii?Q?SP2dAojRzgD4LbJXu+cjTY5in2/uF72ZTiRSltvwF2O+Oxje6BqEkqYk6gyL?=
 =?us-ascii?Q?rzwGjCeuGac6+GyJ+jp+Ryr2eUxUHbmcakw/22gkPlytJBZ0gGtnVP6hqWVZ?=
 =?us-ascii?Q?IMK668c/J84ufZYZkuTdOgfISdC9JgHoIzOnv+BszWozgPN5xKhb9qS5ssJU?=
 =?us-ascii?Q?SP/niE4WuxPHBFPykItfwZEk+JalrZON3oplJ0t7xVhVEYEttCAmr9TAOIV5?=
 =?us-ascii?Q?wJfsn8h86+8aYXztSFtJXqKG9gzRwp0EOv/imCUuDFjxmU1z/wekLgbQYFDE?=
 =?us-ascii?Q?gBzyyK2HmIGJEg3hK5/hHFBxVpXJTlD4RI1z3BDChmyLBEOkqqw9WJdL6Mh2?=
 =?us-ascii?Q?H58OM5oNKP6IZE51LaSoUQQOIgZLEbR4IgY98qgNfK9mVUVoHIVbE6JtPByp?=
 =?us-ascii?Q?jnTwog6gXj/+1AgGexSKZxahtPOq0E0t5JZ3EJuUTr9oL4djvHoihAvZtlLe?=
 =?us-ascii?Q?4Ew1LWuy8tqh5FfvoNIkbVB1neuY7wxk2ZIpwiNxwR2i9eAMp90kHjo5qpCG?=
 =?us-ascii?Q?/FHXDZt/9Z3yQFg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:47:31.3953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 641947a1-75ef-4b30-8077-08dd2e504921
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4062

The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC is
enabled. A #VC exception will be generated if the RDTSC/RDTSCP instructions
are being intercepted. If this should occur and Secure TSC is enabled,
guest execution should be terminated as the guest cannot rely on the TSC
value provided by the hypervisor.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/coco/sev/shared.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
index 96023bd978cc..2e4122f8aa6b 100644
--- a/arch/x86/coco/sev/shared.c
+++ b/arch/x86/coco/sev/shared.c
@@ -1141,6 +1141,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
 	enum es_result ret;
 
+	/*
+	 * The hypervisor should not be intercepting RDTSC/RDTSCP when Secure
+	 * TSC is enabled. A #VC exception will be generated if the RDTSC/RDTSCP
+	 * instructions are being intercepted. If this should occur and Secure
+	 * TSC is enabled, guest execution should be terminated as the guest
+	 * cannot rely on the TSC value provided by the hypervisor.
+	 */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		return ES_VMM_ERROR;
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
 	if (ret != ES_OK)
 		return ret;
-- 
2.34.1


