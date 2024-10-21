Return-Path: <kvm+bounces-29234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 675E19A5A0C
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 07:59:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4193B22A40
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 05:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FEB41D12ED;
	Mon, 21 Oct 2024 05:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CIRSTvhc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B2C1D0E31;
	Mon, 21 Oct 2024 05:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490297; cv=fail; b=gJsmEihoUtz0ixy2150C7pBLsDjrgs9ZA97w3GGcxNBczQkL07iPJyJRvHUJQjFZLCKyodFQBHk2L/iHgjd6DNKwjvO0lEOL8p4GADMBgcOg6EbUCOWDYvujuy404J4zsR5slhwmS/CHZXS09i0pdeN9wYy+RXwhmAH0S0jQ3zo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490297; c=relaxed/simple;
	bh=wKrW6GiG8VQ5Pg5uWu5CCrxgEWmIGuERxeQwSlqw5ZE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ou79EeIGd4+2N5zbixb4MfEZdYxz/6XN8i2uCPCWNQgK0wIcnLLt/B6aXRgnyXyGjQbeRnSfYLq4Eb8SXp+mQunlsbN4unOMp5OM5WWbn8jZPhlb3oQqeaMKttisYtdGNhBumJS4W5TpHMUnM/FBFTlQZsknm6bZKl/7Mg9qAq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CIRSTvhc; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MZ8zY/LjUebLPslT7Dtxt98LMe0nHbVMiP+txAff9wYjQRzDVhmf8lMG5ojCPEiiEfU8xvM1/ZjAr+YSMF9u0MD4QvbuVxbYg5TDncpQujqpDkzPpDgxwPefNYBS+xiAmWFvakiu+LCJRz6zvBuAveLRrEGKXC7KispG/xr8QZRhity1qVEvakDrzV1yOoXA1d5P6AeAbeC0+TOBfCwmvGtQFveds/1AjfEG5yaQ2orYhLjf/SU5IZt6AZLE0bnJeuvpM2Vm1DH58kvkM/WBcbra833e87QxP5sP5ClDAaqDQz++zassc5dta11KPOpU/nOSTfLYOgfeSgh8a3rAUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=di8Fg6sPi7Q7PisEoXLOGNYyDvkN2EQSF85W5VfDD3s=;
 b=K6c+6DAaf2mO7+DVRID5di+rL+1EGBBuMXbjbU6DWpI4fa6p5f3Eao7cy9n9Rx5QDjJPrYWSbioW/Pnz61/WaKSzxd7pi24hAMBOsEPh9+uthG9vRUf+6WSUNV2kP/LiNSNGvcVLmFdx4u7+URwxdedSc6NpfGFNFW39XQeQadsVH89Dhcbf03VUUtDE+Df46c8qf1L8EYhByypwfoEcRWQ25dZZY3qJkfU66TDgqe7DC1qCD8/IeDPG/Gttcd0xXJwhSBJOhHk9MQP0TZfAZQcV/nOh8dTdoYIdPgqvAJHwQjmnYFzUh4OrgAeAZHZ/VDkuGnqpAqroPHdllfJTFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=di8Fg6sPi7Q7PisEoXLOGNYyDvkN2EQSF85W5VfDD3s=;
 b=CIRSTvhculMa6MCZH79cDdwsmK1RcsEEaHpPWUlHdfib7Sk0HMiNV/hngmQOUTZvJgG2VpSMM0MHJkarsWBTBkyxLXm/2CuPcKyPXftp8N343XcacFARXROKrfSqDz4RLe92PaaLpqeOT0LKenaUrkrN3cbOQ/jKDxAUDMan0Kw=
Received: from BYAPR08CA0027.namprd08.prod.outlook.com (2603:10b6:a03:100::40)
 by MN0PR12MB5929.namprd12.prod.outlook.com (2603:10b6:208:37c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 05:58:11 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2603:10b6:a03:100:cafe::cf) by BYAPR08CA0027.outlook.office365.com
 (2603:10b6:a03:100::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28 via Frontend
 Transport; Mon, 21 Oct 2024 05:58:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 05:58:10 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Oct
 2024 00:57:57 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v13 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering TSC frequency
Date: Mon, 21 Oct 2024 11:21:52 +0530
Message-ID: <20241021055156.2342564-10-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241021055156.2342564-1-nikunj@amd.com>
References: <20241021055156.2342564-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|MN0PR12MB5929:EE_
X-MS-Office365-Filtering-Correlation-Id: 59749a22-0f93-4519-1504-08dcf19557d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7NHrXdyx85Ll/qf7DTBmeSv8B23yvtiIaHTxg9w9xZW4CocvSEH6fDXDVKWV?=
 =?us-ascii?Q?dIy/NeGFPY5Xt1SnUPwp9sRwK3LzQaQVdJZxNDwTlzvnl6lDK35/pAro2dHC?=
 =?us-ascii?Q?pORS116CC0XCmqeDQVppfXLuCv8AQO56pIDoUyvoqKvI481Onk03cKGRMkxN?=
 =?us-ascii?Q?0k0VysSUOzPsyaFfr9Li8smTdT7cpvEo5dAiY8GmwFVjPOvDBxz561H+L6oX?=
 =?us-ascii?Q?kspsb6QoLdvWpwMsPKYG9T1nfpwewHPK6VVUcCK0sbz1lo5DNvnYZtp90bS+?=
 =?us-ascii?Q?Q9vnC5PXyadQ812fkgn8TPwDb4slMHljc8VzCYUAsSZEA2E+n3r1IiJsIft+?=
 =?us-ascii?Q?MKHdKSdykzmm4D2wvGnFxtKd/TLYMRuTLXRS/FGPa8Lp6VmNA13D1aShXGUi?=
 =?us-ascii?Q?Cy4mfsVtH006ERWo75T52Pbbmalz6l2/8UHHpLtUXKRi1yzEhZMF1Zxa0uvn?=
 =?us-ascii?Q?lBx3vcGoE4bsmK6ThWYSQRnva5OSFvQltdsb39yKMIgbJZeCCis0Wbu5EBuN?=
 =?us-ascii?Q?SJwqX6yFUFljjdkfDlJ8jT2ksJWsaecMM8zLfd+mzNVUR1sQ13AMhriYFoyl?=
 =?us-ascii?Q?9BbHIcpArzol2uRiPbPE4Pg0D/T+Yh66HMqLKjKJ+YIIXna00+NszBJ8wlWy?=
 =?us-ascii?Q?SYI95x0HkIK5ASbD2V/Z6Q1y09qNdxQdebN2w7gJ51z2MoN9JEOP9SCubPL3?=
 =?us-ascii?Q?nizLYPMj0wJChwj/AMQKWkO3FoKEY3kTlSaBX5CPwm0s4Nh8isLYnr07/XyG?=
 =?us-ascii?Q?QLVvz4xKcB7ta3WbDXXb/JomtjcH3BTseGANFeJ/6IV86idrIWi/+dXbFlIF?=
 =?us-ascii?Q?ReQihGy7Rb3de5Z8Ws2xnZXIFDXGnewi6lI4dvchFn3L8CSWlgQeZN09yyr8?=
 =?us-ascii?Q?o5zSyi7Ec/4bZVP+gFTiAbb47libCS8bWQgSaH8pVUJyewJmdqh6BfQbEn1D?=
 =?us-ascii?Q?9zyFrwuLhVrNj2NIHAlwGr1WV3WNX/T7njN7ioHcejKJiSEfPeNZFPy+cRMw?=
 =?us-ascii?Q?gCkIrNFR0nUSoiapsFdn6EWCdYGrkflI6ft7mpj/NtHj5fjwHLUujECCc6sz?=
 =?us-ascii?Q?Yrebphl10dLqq/mXF+fIFGi+QlIVdNcaJ7cLSDrqkfAqPOWWmetURzcrdhxU?=
 =?us-ascii?Q?9rHf7+YZMcbFqclvcY3skZMuQUoUYFE24MHfemZiJ7q0WR8KFEVpOzR6UQ3+?=
 =?us-ascii?Q?ktTXOHepPPPi+IJqYRWAv9mKxkkBBcNq4mmpVTd+lnHbOj4k75nnMRzsT+On?=
 =?us-ascii?Q?9MmU4hGoo4xr5hZtLujWPpdaJDjWlDY8Qz+17exyeEbX6rVeeIkfd1YFyKwb?=
 =?us-ascii?Q?NOXpmW21OEVMz61cBO5eeXakJn5s71ISq4nzwNGN1o/c28rBfpfZlggKz609?=
 =?us-ascii?Q?wSYSmeS9iuozWITA4UrOFoXZuCOu95m88fetyFTM6y9LtBoHIQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 05:58:10.4077
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59749a22-0f93-4519-1504-08dcf19557d3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5929

Calibrating the TSC frequency using the kvmclock is not correct for
SecureTSC enabled guests. Use the platform provided TSC frequency via the
GUEST_TSC_FREQ MSR (C001_0134h).

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/coco/sev/core.c   | 16 ++++++++++++++++
 arch/x86/kernel/tsc.c      |  5 +++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 9169b18eeb78..34f7b9fc363b 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -536,6 +536,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
 }
 
 void __init snp_secure_tsc_prepare(void);
+void __init securetsc_init(void);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -584,6 +585,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
 				       u32 resp_sz) { return -ENODEV; }
 
 static inline void __init snp_secure_tsc_prepare(void) { }
+static inline void __init securetsc_init(void) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 4e9b1cc1f26b..154d568c59cf 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -3065,3 +3065,19 @@ void __init snp_secure_tsc_prepare(void)
 
 	pr_debug("SecureTSC enabled");
 }
+
+static unsigned long securetsc_get_tsc_khz(void)
+{
+	unsigned long long tsc_freq_mhz;
+
+	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
+
+	return (unsigned long)(tsc_freq_mhz * 1000);
+}
+
+void __init securetsc_init(void)
+{
+	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
+	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
+}
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index dfe6847fd99e..c83f1091bb4f 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -30,6 +30,7 @@
 #include <asm/i8259.h>
 #include <asm/topology.h>
 #include <asm/uv/uv.h>
+#include <asm/sev.h>
 
 unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
@@ -1514,6 +1515,10 @@ void __init tsc_early_init(void)
 	/* Don't change UV TSC multi-chassis synchronization */
 	if (is_early_uv_system())
 		return;
+
+	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+		securetsc_init();
+
 	if (!determine_cpu_tsc_frequencies(true))
 		return;
 	tsc_enable_sched_clock();
-- 
2.34.1


