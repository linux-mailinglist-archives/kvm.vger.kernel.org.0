Return-Path: <kvm+bounces-32906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 403CC9E1759
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 10:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C831B36623
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3C51E0DD4;
	Tue,  3 Dec 2024 09:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Pe9WpBoV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D341BD9EB;
	Tue,  3 Dec 2024 09:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216504; cv=fail; b=PPQdCnpgC8ts//X93jr76zkbOgn829LbcDKWwuIwcS6KiTH73p5rr0ee8Fg3kCJ1/hEvdp4K0wIB5ydvl6mAYL0Eq4/obc7QXJbMsuWGEOAWCtb4sbHbvzSISvmePgeRuFtJihhAL/bJFSMzgBtbEp5HisKD2Qi00HSWZfG8zo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216504; c=relaxed/simple;
	bh=pSEt+x5pK7qLR8kzWGpKtymdDI3tYGaJc3XCrr4HDZo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JPZD5NWI8tqZAAjGyZpEjw/M0CENYEKC9mCVVyZmF49pmnfRfBRiOWaPsSkdhkqUqNaZ3HGHt6P//9+gKarEwbsO+v2/+S5E+fHfjVB2iy5dCn/PCj6OLI4VdXbUUQpC/0hPS3o10gN5ALHs0MCLSv06Okv3yuR9QEHw4IDZ1z0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Pe9WpBoV; arc=fail smtp.client-ip=40.107.223.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hUsahnoa++wQmtIL6r8amaNEAGuTxbolAy+8Nv261ag6vZeKIhf+2M5qwc9F5SQBc+jXTtKrCD/M0999VtlLZM302ScKZPEXbdSAtRbez5jsVlIPywqI9+UovU573h3OoYb7X6VkR3Kg40a+6iCNF3bIQ/jyF+7mXKBiNN2aaxZstxMdR/gTPg1hUBg4cH2qzEovSMmH54yQ5rOZgY54H4OT86ew3fkDQeiBZMRDhM6eki9qmD7K/McA/920/CQccHNK6YHrJaDfn8OjpnH/bYPam4RwQ8605yDHvEUzHNZwMgQbrSxcQNPftNO77NNuzgj+60NWV/wYisq4bT6/6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gRCKVDfmEN69C8vV943le0g8cl+S2x3eSRUWNJEc5Xc=;
 b=TwqqdG13io8D0/Kw9RP0vBORVxHvr7XqNo5spJum7HwUkvmOwMsqAspbaW+hB24T/fnXaRRLdUZIwdrY9/YOdwe7nva8Af1R7QOFSJm1l++r3yp8vRR7V1iQWC/aVFCVxsLP9UIxu/u7f6Su154itkynqqsUtL5ItnLQtwA6rL79v6R0L96h2ezLenYTgJopoBXuA3dRYy3eHFvNvBu8S/wfxI9ccozm9KwJ3NItJZIzVSlYxCxhCyVzIbAKgpHv6KTnJykSHa5YP10jHaI7oAOgo0SzsqD7cKkrREYQS9BHexoNqzw+JIfkC1Y4ijHzRz6yS6oTNJ70PiWx58lIRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRCKVDfmEN69C8vV943le0g8cl+S2x3eSRUWNJEc5Xc=;
 b=Pe9WpBoVV1n4vwPH+TMCWgvcAvxyMVDTdub6vtWQVfoLwRYFF3AAtS/2GqbfzjrGuIxAQkjU1PsIalif/xrjFRtNeQ4IlGEyb3XIhbp1iUSN7M53xBPhx+cA0JHgHBbLUFDfcUW9u+PrZpd4n3HOnAKWYF9rz7uU+XPewoQUBAk=
Received: from CH0PR04CA0044.namprd04.prod.outlook.com (2603:10b6:610:77::19)
 by PH7PR12MB7916.namprd12.prod.outlook.com (2603:10b6:510:26a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 09:01:37 +0000
Received: from CH1PEPF0000A345.namprd04.prod.outlook.com
 (2603:10b6:610:77:cafe::f1) by CH0PR04CA0044.outlook.office365.com
 (2603:10b6:610:77::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.18 via Frontend Transport; Tue,
 3 Dec 2024 09:01:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A345.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:37 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:33 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v15 08/13] x86/cpu/amd: Do not print FW_BUG for Secure TSC
Date: Tue, 3 Dec 2024 14:30:40 +0530
Message-ID: <20241203090045.942078-9-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241203090045.942078-1-nikunj@amd.com>
References: <20241203090045.942078-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A345:EE_|PH7PR12MB7916:EE_
X-MS-Office365-Filtering-Correlation-Id: 714e3424-fde9-421b-f8a1-08dd1379185b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O7gm1yuRtIG2wNCN/FdxkqTEXWhiabPr31jExJRLRSlFn93q1npqMVBBevlT?=
 =?us-ascii?Q?dAbND6WhE0oZBcINUICX6xJ1vPfMZloIjr6mmUzPzbpKTQiUpG3bW4wXUrcZ?=
 =?us-ascii?Q?HQjlqUFzhlf4Jjoo0VAnR8sW/huXhjpB/WHhGTvtE7dzrXMaFv1N5Cc0WWaf?=
 =?us-ascii?Q?czc3BclWr4gopj2mUbjdHzfwNHs75GIH3ieMHmzR5ywFM9IcuO70uuQT4c/e?=
 =?us-ascii?Q?SZisJfNr4TF+nsajEemL8W+JoBP6WYnO+ghIaMl8+aBUAH08OYdob/j3ylhU?=
 =?us-ascii?Q?P46v4141+Gvu9CE1I40hp7GhRst9/cbgYbf+zJicKiOw4NbHs/mUpWeFZjfM?=
 =?us-ascii?Q?mjQQnNja3+h+DzcuF5YQj6Iw5Nsmqfb+rdUjZefjlyOkFFZTPdktoSTvITPt?=
 =?us-ascii?Q?zYg0eiXqp19CnYdwgInwgylnk/qEGE40g0B9S25LacEoBJ1zbs7ztVx6NP36?=
 =?us-ascii?Q?UrTxN2RpFhcKSep1NttXCsjr/Wc4wNGSiD+h9WcxK1f2WwuWcifFgCfzngaM?=
 =?us-ascii?Q?dVhovyyVi9HWkj5cdusGMoDX240Oi2N8MJgGdHJI8CePi4Q6qMkaDtZwi0hn?=
 =?us-ascii?Q?m4+NOFwGt69ZZ5WTCbMgXxUFAx7oVgZo9/aJwzP34HFS/HTKSBneVYaq2nn4?=
 =?us-ascii?Q?G2xpAfQqmbigm55JnfXZW48ZT6v++CycwSd/5Q8t1zD0aE/9gstsyBj84pTE?=
 =?us-ascii?Q?egE0kOIO3nEMpERy43ErsH+LoCALIq5lDnE5S6t18HhVn3Rv45SUAbncWXF/?=
 =?us-ascii?Q?vo2RQNS+MzEIk0hR2fcf37a3RjJ/e5yhEGU2XNabgkV0jbDnPDoTHeYkTa3l?=
 =?us-ascii?Q?bnC/lH3rBTAH/cogXDsceWjOni0Okj8vsvlnoVJrGtXmpVndpCLPBdK2R2je?=
 =?us-ascii?Q?bQ1CX6w1i025u6elfJHabgk7EAFd4tBFPi05N6IcS3MUy9vFudAifuDZy2vG?=
 =?us-ascii?Q?nmxkOzDZ6/Sx83AzqKo6VtIHk0QroJMI+ptqwCr98cZ/U/BRZrZ/ZstZL5ma?=
 =?us-ascii?Q?YnkSiLfwB8ftNCHi2UUXc4BYjJ8Fge4zJnUDgIrWIK2IJpY+MrM+k4VxJo+n?=
 =?us-ascii?Q?RxZdSd3XzqxlcSp9hzYk/IEo+xJgCtEr+yGIcNWPtjIAGC6Vf72UoBqTRx+L?=
 =?us-ascii?Q?bxdRxl8OVJtD3zAzC+lNNiOrKiZ5UYBViF61ZH43kpN58JOw7o3fxiA8GkO9?=
 =?us-ascii?Q?K7JSdP1X0N6lyxtcZ7EJvWfpUVJJ3LvTsgK21a+SjXNjV01YBR4/zJMjjSfJ?=
 =?us-ascii?Q?VcBsn+VAw013SdFG0A0k9F5RYqhXy2Lm0hcx3R7ZbZDterudNnE5QMEHuSZr?=
 =?us-ascii?Q?nHUfGyFt4N35zvofpezx4RRnnRh6z5fNO+4OMxa5df+Lr/p5PtTjE5UlSYnI?=
 =?us-ascii?Q?e2S/k09ev4TvvaIT5/F2fp5EpdkJpJjJk4s4PL6RCLkVsyw4gXKLvWFUY1PH?=
 =?us-ascii?Q?svJlG2mfxpiqOd5kWFJEzKK1T6w60TT1?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:37.6348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 714e3424-fde9-421b-f8a1-08dd1379185b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A345.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7916

When Secure TSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_edx
is set, the kernel complains with the below firmware bug:

[Firmware Bug]: TSC doesn't count with P0 frequency!

Secure TSC does not need to run at P0 frequency; the TSC frequency is set
by the VMM as part of the SNP_LAUNCH_START command. Skip this check when
Secure TSC is enabled

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/cpu/amd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index d8408aafeed9..af9dd545f0ec 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -370,7 +370,8 @@ static void bsp_determine_snp(struct cpuinfo_x86 *c)
 
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
-	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
+	    !cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
 
 		if (c->x86 > 0x10 ||
 		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
-- 
2.34.1


