Return-Path: <kvm+bounces-43550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B786DA917B7
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 627255A6211
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A154E227E92;
	Thu, 17 Apr 2025 09:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3JLavZj+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2077.outbound.protection.outlook.com [40.107.236.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5186918BC0C;
	Thu, 17 Apr 2025 09:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881747; cv=fail; b=n1hWIgfI5QJYlpepu2imAkBV7G7srDkp6toroyhtATAyPGA1wEa8v1QQpYKy4g6oWhDPUvTEqGp81xIT8KJGwdyN7L+n4VJ5LTeqR/OmSuZJKApwMU/hglEk3YK0CsLrnz1O4f+VeT3gwj8buwDOq0T7G/fu0vuKXDKBubAUzvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881747; c=relaxed/simple;
	bh=RxnnllWctx340IZ0MgDpBK9EP05R0fwWLcE8mkDEvL4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qg/tBSWXoCXYl/tbUO5k/uCWTsm3OqpF7KOP+fKEpp3+ys4Hz3N1DNddzbWzBXdhDbAO4ylAKXFp5w6SnuFVfnldA3Xn99svtfdcBt2Mtr8nDFaNhyZRQPXaX/32y+R8MnycdZxJvqUMMSQwzKaaAD6p26b4A55seSynEsEet+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3JLavZj+; arc=fail smtp.client-ip=40.107.236.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IQibZro3fvXDgyCwKZVbM2uaMlNTQhRrwi2/60F8lcLFYSKqmJQZ606ch+TMzzg+0B2h8nlo3iHSASQAc0QN14Imt88GjIflWtLpxrqcNnQM79dz1+Qg/WQpQ9JTyjoD3wpCI0Q98sJgAfgOSeYFHE+6xYaVpFd4bwMXS8RYYPOW9msknaKjtiTfhclcHYMHuVvSGHjEpjHuLx4jX2nxFaE43uMKd5IlZjSEAcLRk2Y2oiWAE9Hl9SNuWWQJk42yx3kM1py198qX81F/d40R1dcSRioYMYUw6vaV6RpapiOOuKpaKihCTrgCZT3IaIz0Q/xFxyVlnr2JTLWP0ziY1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8x8EiUUDtWRFp8MtS6o7SPnkYamkIROUUFTvCiqEP5U=;
 b=oiiAtojgxYNMM7F+3TyWbk+tTjwUmSKGuxcsLT5/jl+dw0RkfvWWekrAd9/30rV3GYhuV6gid36PBfF8Slr6QCqpvyI2z9tG5VkpYEcc6H0GF6VI/ESVwrVNRvZ4ypIpCFQyl5A4U4GWXmVZ9WBCMTrWh55rUJOkkvEdSKm1iRxRY/BRgCMUx+QBNM+g7CKqtOEhNStHOK0wNcWRcNb8lLvD5O4kHRgKScz9Wj/Lj5k5fxrnmrMyw8USd7k6gqLzDVGpy7uNwGPI2K5XJi9RN6SmcKB9AnfiMAMd1qH79nBLUsinXEfYlz/ciSYS9zYMeITVIdrVeBlFYc6RZNsqEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8x8EiUUDtWRFp8MtS6o7SPnkYamkIROUUFTvCiqEP5U=;
 b=3JLavZj+ns9zbPEf8SXrVA2nnfLjnS+gqA0aZAUE3kA+yqUipv2mh/pI3F8SN8bIQKG3j+mzYHFJg7GTtCEiK7YaRzzTUU3Ab64JBaohIigzLm5XkLyVaI/69PGjh/C61kwCw6s3LBZ2iSl749khn2CuUPW1/XDqOEEF0C8q66g=
Received: from BN0PR04CA0021.namprd04.prod.outlook.com (2603:10b6:408:ee::26)
 by SA3PR12MB9157.namprd12.prod.outlook.com (2603:10b6:806:39a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Thu, 17 Apr
 2025 09:22:22 +0000
Received: from BN2PEPF000055DC.namprd21.prod.outlook.com
 (2603:10b6:408:ee:cafe::c3) by BN0PR04CA0021.outlook.office365.com
 (2603:10b6:408:ee::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.36 via Frontend Transport; Thu,
 17 Apr 2025 09:22:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DC.mail.protection.outlook.com (10.167.245.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.4 via Frontend Transport; Thu, 17 Apr 2025 09:22:22 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:22:14 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v4 12/18] x86/sev: Enable NMI support for Secure AVIC
Date: Thu, 17 Apr 2025 14:47:02 +0530
Message-ID: <20250417091708.215826-13-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DC:EE_|SA3PR12MB9157:EE_
X-MS-Office365-Filtering-Correlation-Id: b0580662-0755-4289-0407-08dd7d915c2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F0FtZFLfuolAGNuHc1YawM5OXdz90kSUfYW9ckZKFT+/mYkHmcwfN7/r2FiH?=
 =?us-ascii?Q?k/SGyENfr+vXQDSMD9SWQQzcYdgarJrLVdEUoGLpzbnm5BFhFaySG7AxcuTC?=
 =?us-ascii?Q?4X88WG6rHgaxlzDe9WQ+tJ2GN+9HIcpGrrQyxuJstB/AIw0dACeokhfZ/PDk?=
 =?us-ascii?Q?/sX94uCNoAkRV0vjlYABS5m1jGUq24Hms2Stnzqkf95we2/2lde5Vyv50IQJ?=
 =?us-ascii?Q?QM6nyzjOclji04mBP6vLr+HYjvUmlDNtYfhMP/ivyBEX95LtTU5JmVQORl0p?=
 =?us-ascii?Q?PSVGAoHSBqqJugRrLdaZpSIz6R6j2y4ZhPq474bdSNLlBZ5sNPSCGI/wS0SK?=
 =?us-ascii?Q?7SbHKvvxTitSat/Qdk8jLJxL0a21zDgZwMn8bjur3MbYOR+DTWUxl2MgXaEF?=
 =?us-ascii?Q?Fthqq5WW1LaS9xaXU2LkKc0qOzoiUUcLorgeXwk9xKO/s69zozB8TJFcTfI2?=
 =?us-ascii?Q?tv11vQYMkHU/w7TIdG8nYCHgSHdQpqKEkZPIeuyIneJe+I4UJEq42NkgScTZ?=
 =?us-ascii?Q?qg5PwqkzedpANsjBHqjhGzv82R1aClkyvx9WWkeBCZyttfY8Mq3/w0eP0GOj?=
 =?us-ascii?Q?+nx7znehyCwsnlnlugTfkaQI24GvEA/yaGRfo146NE5cm15LdepBj1oyNfGG?=
 =?us-ascii?Q?8rGp+Sm6aFTAazI/e1fuZV59zPebFK6z1u1iGd4BjfJFtyIASzNt+yDTjyf0?=
 =?us-ascii?Q?JFBn/cEhpi0K/WNO6pZzJnjkCMLzn0CDC70conT6cO1hkKbfjEeGZKAkPwm7?=
 =?us-ascii?Q?NaQYDsXFoyIb5dmZb9RzXohwgmmp7vCbvBa84R+nzkRWJxp4xHP6iCWgIkzy?=
 =?us-ascii?Q?sDiSW0ckEIsjTHVEN05O/20ecoXxTTvHyjbxr6Qdx/uNJSAm63FJwgjbvYKD?=
 =?us-ascii?Q?dGVNn9ZzjwW1SIXFWVAyI5jFXJtpZgC73XzX3GGOnQ+A2INEaz1wt19fXPyE?=
 =?us-ascii?Q?yQ/rC5YmLe4huYqboNV3BtlhPQoePvZf7HhBRq0/OZjvAggFuUXYyM1eSMhF?=
 =?us-ascii?Q?8rBnaQqqcbOJlxufgvzpiGrRhx4f3aAzv/VH7j8Azku7oJTzkacr9mpsTURS?=
 =?us-ascii?Q?RJzudbLSgR/31YBVzy5gki9FPcyqzzYDTY9EZD4DSt9jEVz96rUO5wFmjSSn?=
 =?us-ascii?Q?G2+LdxHaZwkw44+vaHUS1WVLI5JlZwHxrMZPcLfDMygJUjZ/60SfV83AUXUi?=
 =?us-ascii?Q?XWRqNbanfQ9GSO4UoONRRQylWeuOOF2RATmYxO/GLoZHrgBHF19doqPv1mFT?=
 =?us-ascii?Q?0Bgrj/F104TvGW9HurPN5dYJEbDppLmV7Dn6vs2zLSCi+Qj1eFKbRJa9R7cG?=
 =?us-ascii?Q?UEx4d1NmP+0GcLad6ngKLsHjOcYIdhRUZEc4g/pgxoLy3MlhkSqH4V9jNktN?=
 =?us-ascii?Q?8F7unioDLiInN8Uz06/IK6xaWU7fQH/TW0Q+jpLPnYVxxw1/ek0M2PKzBXN9?=
 =?us-ascii?Q?F6ZkOQoDqD9JBxG9rum9SUG/1dGvtRk5j0eWh9Lf7r/DaUWDih72sPc104L3?=
 =?us-ascii?Q?HaUfxaJB2IIsiBoOioC5JSMyPxy0/3pKXArf?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:22:22.6050
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0580662-0755-4289-0407-08dd7d915c2a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9157

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Now that support to send NMI IPI and support to inject NMI from
the hypervisor has been added, set V_NMI_ENABLE in VINTR_CTRL
field of VMSA to enable NMI for Secure AVIC guests.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - No change.

 arch/x86/coco/sev/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 7bc0c036b4d7..1dcd40e80a46 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1189,7 +1189,7 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
 	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
-		vmsa->vintr_ctrl	|= V_GIF_MASK;
+		vmsa->vintr_ctrl	|= (V_GIF_MASK | V_NMI_ENABLE_MASK);
 
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
-- 
2.34.1


