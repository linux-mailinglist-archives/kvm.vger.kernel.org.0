Return-Path: <kvm+bounces-46454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E458BAB645A
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:30:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05CB619E1F60
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CFCE20C009;
	Wed, 14 May 2025 07:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pJ//StbQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3E02040B0;
	Wed, 14 May 2025 07:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207722; cv=fail; b=cRrwNWeTPOQV3B1NtugghRgBdFgwobF2+W5gAERYbTuZYumsgavLpoxuoLwXUQkH3/rLasOQvzydM+D8rh5ESi97LDG+BoU96GI06nhoWEytxEePw6IOEmqXaZ0YSui45F1qooO8tcO1NgEakIu1LcZ7lJKTtBFuZ/9kWLMadrU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207722; c=relaxed/simple;
	bh=bnbZBjpQT5vlYHBtqNVW2CF73B2w6FdxR8YXLwICUFs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FVSAsk6/xsu181icX67ILl43WlyyJeI3zyS9Vf5gn+ezzdH7kSYODeBooF6jL3qeTVh2sl4NXP5w82vg15G2P5Gjm1qu5KjzeiZ1H4kcNAK/2Wvzf7ufSt9KHvOIMvEH4apH3Ud0V0vV6KwZTq0ZZc0DZVmmI315HyuCvIpZie4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pJ//StbQ; arc=fail smtp.client-ip=40.107.93.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sVVbXJ3bWwMEqFPk4wYGNBsjo/Va6+w/qVlmUNTtFb4vxjFYiK6KkpEyiY3jWkRwMJxRpveXQ/upDOhxLctrUt3uS6x1ehtGr2rXwpkuY+Bwtjzv9Go5tT/f2HQq0hnmn8EW3n9fujfkDsgpJKHvmK083MaOWS1N0h5SJkKGtUP8YVG+BVFezSic7dbPLw4nCmkoZWOHoT8SuA42DS0mpxbapkUztfh8na/TDi78JMJQvq5jlWfzhmNPjVfSOXJRtq4eliPtAFQyGhj+j54Ggl/iJkaUGlJxYxSGSwUw0+rI2NPBiSN0q8tAoVY1uYeMkGSilgzOD1ab+y5N2/WZpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ddecjDmNeWxOB8lx74zoy9HT1Fcs4LAAY6gZrCTA3I=;
 b=QE6hS+KTb3MBEGlcXZLDstgvKmE+y29X29USEHba2YzXj6UDMNSMEvCII6wBHnBY19QbiKUdbosT8Spd5LIxxj0OgUF+9O7AO4KDcYpcbL/ex6kUJT4UlSh8huO33zBKicjKTs6R1mzLVbp0YW4KNUrpX4wd+PqiuN09ns5hovu9o8BoTGxjAjMs/xlJ//m8rEtt0XkeinkKVCr4MDURjkCl38qbd8BBX3UnoDZb62ETp+tIjIzY0pXGECYtrPwcxEiTpIgdvHJqUhjecy2wDk7i6+d2aa6e9o5lpUw8XKJVGpI7UoM4hvZEwBHHLQlHDDgtUE8+udYH8POuVNfu0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ddecjDmNeWxOB8lx74zoy9HT1Fcs4LAAY6gZrCTA3I=;
 b=pJ//StbQq2pLjgczhyg4H4x6Tt288B2IsYaNgH5/deifnmUJxMYzNmp/81t6g0IFBP1Xl/4Jq76VUFeLSMcXeF3AonjWn+iGDJU72BDKJ0lHv6Rvj0E2dL7nHBG1tIv9mkX5z0bNAXomDi0vWISkpX74q4LcL8fQt4LQmVE/0tM=
Received: from CH2PR19CA0026.namprd19.prod.outlook.com (2603:10b6:610:4d::36)
 by CH1PR12MB9600.namprd12.prod.outlook.com (2603:10b6:610:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 07:28:36 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:4d:cafe::4e) by CH2PR19CA0026.outlook.office365.com
 (2603:10b6:610:4d::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.28 via Frontend Transport; Wed,
 14 May 2025 07:28:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:28:36 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:28:26 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v6 25/32] x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
Date: Wed, 14 May 2025 12:47:56 +0530
Message-ID: <20250514071803.209166-26-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|CH1PR12MB9600:EE_
X-MS-Office365-Filtering-Correlation-Id: ab034404-c341-418d-5347-08dd92b8f05e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8Aky5yshraBEPPLA/fxsxVZMOv49siS+m5h7KIMa8MgLinsd2xhEUyPy0c05?=
 =?us-ascii?Q?dm9MSVWxR1WuSvnySSrT3kqU4B38ePkW7Fj/rgj0t/5Nn3gT1bclNi1THLLT?=
 =?us-ascii?Q?ulz2cl5FxKtZyKO9PZo8HJwrzkTX1/WTpka6SwmWJAXJPC7B9pPslO2oHTFQ?=
 =?us-ascii?Q?VMQkoCdB9qZEVooiUun4quNIhd5ndVSBstup9v0y/4K1zpX9HTONRmgnQwtU?=
 =?us-ascii?Q?NtzzWQIsOVNqywEXXLkb8IQfJvD/UceoAbM60AAamUvBkU24oIcr10nXrsks?=
 =?us-ascii?Q?LKbPDbqFSZTSmjbaUlPwU9BNpWPEww6P+Z6MT261ixOK0739oMZ01MjPCyjo?=
 =?us-ascii?Q?wnFk0Ia22D6bUoVPuZ/myMO52E7ZkQrPei5X/kIKC1VdIJqkTIQsub4AEq5O?=
 =?us-ascii?Q?aGDJEKu25nFp/xxiWdS0ul+Al3TPlSC0rEybCCU7mQpRiBgOQWgPtHNx2Yo4?=
 =?us-ascii?Q?Xux/SfUIF1CUm9mGu9ymZXbrr/pjlTeTeXEIp7enWO4tYA91wdeOJ1JxU/KH?=
 =?us-ascii?Q?2E3NNNUOCpxtV8mSRXjkJrEZYhoMevUv8CWqWqetu6OcwPFA39Uj9l/fn/ME?=
 =?us-ascii?Q?Z8VURJxJx1NsXcmNaEFgptmf7TWgsclaKUaio0iDydVVbFHkTs+huFXtmMRA?=
 =?us-ascii?Q?NOsgR5xuYZu0qRHZiTk3++MwlVJ3icxKLpwzGG6uzKPRUZjWt06oOjQiOPnc?=
 =?us-ascii?Q?UV47kFWwQ8mdBdKF2BTHCynIRLIXLn7cFzEhzjTL+7dc82gG0O9Z7Oo5noYl?=
 =?us-ascii?Q?8wCzuu8FeiF3YkxgmVblSvvwuKdeU6C3m0Yzc7Ws17CQ/wfbMHpIlDRTMfuU?=
 =?us-ascii?Q?n767lMuIQJBbKED2y53dwgWcyK6tFYw8mtXA40ioy+AfhPcmE7y7tU4rtVXw?=
 =?us-ascii?Q?aMG2+W35fi0QehFeSnHSpJbRkndLtgrRYnNgMUHq0qDqgRK+/zLTDrVoly/9?=
 =?us-ascii?Q?p+/PmLfQ0UkYBBgysDmqVWFvWziOaAmHVRHF+y59ksHFVje4Ek4yz2DJrwsl?=
 =?us-ascii?Q?ciD0NbBnrYvUCv0J1Zmm0k5muCCtd0jED/woYHHbzOZ9mWj+nKcQP/gfdom2?=
 =?us-ascii?Q?kkV5kCZi37bBI/ZrWC/AwR6oXaxvD9/vCTUjDZNWwi5uOcrlrCIPMFxXhrF9?=
 =?us-ascii?Q?IPCGKms5Sg+ZLBlEuROKIxWUw/2/LmjBRZgRN/jn+lVFuMRPzsfHwv3/WfGi?=
 =?us-ascii?Q?llZVg57NjRLmWzbMpFYKHsVkwTa1A/X8Ns9WHomMqCFX4BWmiy9E5JKCk+ax?=
 =?us-ascii?Q?iPSuBN7Rr4qDDn9MHWmENhPYyj2N8fH6kou6OE6fC5VGPmyKjkIpXAIX18BC?=
 =?us-ascii?Q?oX9IeSkHAEqUbazDWSIDRNwhymfvMOKv81JHf+cRLmiTpM6X9GR8Kbt/7eua?=
 =?us-ascii?Q?mwVVJqgM2AyWzNF2poNi+6qoOqr70usVyk+Wfd5+bvRVUQa/BPUR/VvBPSEK?=
 =?us-ascii?Q?+4gI6Yr2SE6xZcqTvp1XKbjmmAltF6y2NjIaMVcUP8yzu0pc64hrVnx9cfrN?=
 =?us-ascii?Q?/L7O4TENdBCXOeRaL8BEMGYg7TSK6orcUusZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:28:36.0273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab034404-c341-418d-5347-08dd92b8f05e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9600

Secure AVIC requires "AllowedNmi" bit in the Secure AVIC Control MSR
to be set for NMI to be injected from hypervisor. Set "AllowedNmi"
bit in Secure AVIC Control MSR to allow NMI interrupts to be injected
from hypervisor.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - No change.

 arch/x86/include/asm/msr-index.h    | 3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index d32908b93b30..9f3c4dbd6385 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -693,6 +693,9 @@
 #define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
+#define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT 1
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI BIT_ULL(MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
 #define MSR_AMD64_RMP_END		0xc0010133
 #define MSR_AMD64_RMP_CFG		0xc0010136
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 66fa4b8d76ef..583b57636f21 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -19,6 +19,11 @@
 
 static struct apic_page __percpu *apic_page __ro_after_init;
 
+static inline void savic_wr_control_msr(u64 val)
+{
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, lower_32_bits(val), upper_32_bits(val));
+}
+
 static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -330,6 +335,7 @@ static void savic_setup(void)
 	res = savic_register_gpa(gpa);
 	if (res != ES_OK)
 		snp_abort();
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int savic_probe(void)
-- 
2.34.1


