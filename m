Return-Path: <kvm+bounces-56408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1FC3B3D8AB
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:24:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A964B17932B
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06557237707;
	Mon,  1 Sep 2025 05:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ibr3CPa7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C467E15E90;
	Mon,  1 Sep 2025 05:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756704234; cv=fail; b=s8f+DLz7y2PBdq0+7N/57I7cJIyV5sZkaEtPDIMXi/VL86ES/UZi/DLF3st2B4kVglYPELB6yRZOEBrnAkzW48PsgINegEsdvOByXicfaagWVYdrlQjfRnobL4QORoMlCCArRqdA3JbqnY51o98QdnCiB+ypzg0L/X7bV7t6baA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756704234; c=relaxed/simple;
	bh=Abdz2cJcXBzTPDQJICw+1I/D3Q1l8SXzgujiHYRJAks=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P1i3JhXqaOqjoVb9AwjEJfUJRDoqq1H8oMt5qdGR2nFreJ/Kd3ViMnUnRNy2ADJqTRN1Wo2qiLPhgZViAyJadzEgz5hfH/gpVhAN0h9IWWnq5ORPApxc0xSC+BZvL+6ZgQHtQqpwu2JCrg1JVl0uVFF0oWrT5nt2IGMFl2biEpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ibr3CPa7; arc=fail smtp.client-ip=40.107.223.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z2uzlwqIdj45LEjdRrzag5EO5szifQKz//COlDABdGKrKK5gSGDtRvwjlGJEOK8NqRHpj9Nwk5ukxtXLFyflMAvveYvfGHcJP0x8mAKH7Cxxv9lOeLx9cZtoxbcMRUNaHeaYruazjMFu5TyIFl6q0ema4fWxUlSYNd/40W/i42mHDiFqKup+UkIhxW7b1sPH3EnRGeplVo8vjS/Y4kOpqCYJRm/zoO67Tyt2Td3I7g0WxKMgng/0hJUVt9TZn1299NXJckQGsbKRR9e4YXHTAsw07xCl3JE79paLa469BOBYfPJB7sbbVVihhG+yfFpmnxcH7NIOjnx3bsjgsT92fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DpdMwT0MJerUUUtG5PKCyDI0PgEJJln+eWBiMB/lcP8=;
 b=BzFF1lQdLKdBImZHIfVN90zTbIH65mdWWv6RCyFwIH2Oz0VAhNFlUXK3a9Y8KWaKHDACQKLfon6kX5ZQ+GZXvHP5shH6+v022fq+MArBK7e/iGY2PSFYuX89b0uDbCMOEmAQq9SqTaI+YQgsn72EfocNVzyEsjJetikNzRO2CZ24zHndeOFbe82lP2FGNflYNtGJpn9IXWvN6b8vjHSWk8gua71HKAbXqNhYEPEROvh8SwkihRB9PA7lHgOeH7nVzCXS5bfkDMUaKtBc3+yMhElqi1pVzvsXWzfetngN8rKFTWx7bqi/FLU/jAJgGw6NXGkUmI35RScbaO3IWyJmDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpdMwT0MJerUUUtG5PKCyDI0PgEJJln+eWBiMB/lcP8=;
 b=Ibr3CPa7+0vVI7WsGM2MKUpamxRSjJkhKFqENJfVEGqHx6l7vhSbHjh6IScz8AfRGN/8ukt9kpGvR8U1rrT5ZJu4ifgw+HX3r7gXL/0FoXH0j/awECU+7WIxMizV0mizJnQ9MjP23eoULzsDZ6L5kKPJmxBRPvkJuMbxfysN/3Q=
Received: from MW4PR04CA0291.namprd04.prod.outlook.com (2603:10b6:303:89::26)
 by CH3PR12MB8185.namprd12.prod.outlook.com (2603:10b6:610:123::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Mon, 1 Sep
 2025 05:23:49 +0000
Received: from SJ5PEPF000001D4.namprd05.prod.outlook.com
 (2603:10b6:303:89:cafe::7f) by MW4PR04CA0291.outlook.office365.com
 (2603:10b6:303:89::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Mon,
 1 Sep 2025 05:23:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D4.mail.protection.outlook.com (10.167.242.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:23:48 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:23:47 -0500
Received: from BLR-L-MASHUKLA.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:23:42 -0700
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v2 07/12] KVM: x86/cpuid: Add a KVM-only leaf for IBS capabilities
Date: Mon, 1 Sep 2025 10:53:28 +0530
Message-ID: <20250901052328.209212-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250901051656.209083-1-manali.shukla@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D4:EE_|CH3PR12MB8185:EE_
X-MS-Office365-Filtering-Correlation-Id: 78eeae34-924c-47d5-9277-08dde917bae7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CkHA+bNdtMExk59/GHh7MCj2KqGz8bI5lUF/jj9uDFOHqoswjFK3D9+2WNgE?=
 =?us-ascii?Q?DBS2scMi8g+hBHvP3t0VjLbkWVaADSpyv5Q1l+FyQN2QEDgNwrHs+B36NjgH?=
 =?us-ascii?Q?9fJckEOqwn+zOKKDyjLrJCLYUR0L11aGTk4hQ8YXq91OuvYW+0onM/EGnXrG?=
 =?us-ascii?Q?aQT/svdZS8TuBb4hZFGd6MrdcsvF21HdmUSLb0hUxfMUom0tyduQoVggjkPr?=
 =?us-ascii?Q?N/C7vUjQ9Lu9PwntAMFVIPIdKLYkr7KnZ/72yLFy1cj4s4BHK6Tvk4Qv5Eej?=
 =?us-ascii?Q?1hhh75GKS6Q0a2OphBt7Vhbro4Tu9FOEBFNi31sddh5Jr+yi5uZraK3A5q/8?=
 =?us-ascii?Q?Au1SK5y9U4JRS5OVfl/iwL4R3QJw1M8fXUM2EtoOm7fiu6iFODTf/Kec8o0N?=
 =?us-ascii?Q?QULYFiQBE0GuNUmX96DDmLh691zWHKeLndBJsvNMOPOHjnFLOY4k622Emg9c?=
 =?us-ascii?Q?ppiIjNknOAfYTvhxLIeYy/+aeNEacC1xNdc4Sp1y13q/hu4lbepHDG/url2q?=
 =?us-ascii?Q?XoYm0ET2lBCUAKJ7yveyVBAcy7isuezOYlXvU5kvUXNhGmoJJ+Fmm5oiFhqX?=
 =?us-ascii?Q?ZCmJPCQNM/WcxgTBEkq42QZSoOOYMR6pwGOrjyHZwfiI+2KikjLCN99VAbSe?=
 =?us-ascii?Q?isPKv/PmAyN7NGtuBaxbCPHgagQOtJnqUq/g1Yt/nlxu22styCFNzRPuxPIR?=
 =?us-ascii?Q?K5oRLumPdwbGTt+iYpoBENOi7y/JHA/PEEbRpb5efwZ2rxjWcOS6wBZXHnzU?=
 =?us-ascii?Q?dTuHLiizzpML51a2UK26N9ZmAHlu1jtjJbGJONBuzL5ksLs8SUksCdrcs5yw?=
 =?us-ascii?Q?5RuX/3gcxBTv2eXrNwyraMJcSBjId5HnCEFOnQxC6zr7kXqAiATlGOTSDtsb?=
 =?us-ascii?Q?0gIp8ZQUX12ahyd+e6Wbp4iu1s2tfN7BElZVtS50ubSaj0rZbjyvwT/ZPmtT?=
 =?us-ascii?Q?QUu03U0CpDaHW3Q/rEKPp2IS/WoE7XxjTLLHLEwIZdcXM/N6e+SDaOgaa/hn?=
 =?us-ascii?Q?4YcBRC0Gx79HNZIMH/d3wYatJ4k+bVndGTIJNLP1nSftL9SM5ofodvrpAT5S?=
 =?us-ascii?Q?cFij4hTfD8DUPtOrDHR4k97Fi0glJLAJ4yGbvbqrDG9+fs6Fz2VxXVXBqixf?=
 =?us-ascii?Q?uJuxom1za9h2ZXabvatlIz4qNcbou2c0cPI6WBLjls0jEH/EuY/swuYCiy4t?=
 =?us-ascii?Q?M1vT0WKfr7zwy+0mm/UsXCgF6OVk6sg4/3NjvWO37fZCZHLumEkcQvHQSZbW?=
 =?us-ascii?Q?QA5xogl4+DwT3KDdkA/jqMuM80h6Mw7wVg3bzWhBRb0vp5i/Ku6NihH66Scl?=
 =?us-ascii?Q?s1YGDsrbIdHQxuxOIdoQmZge3x4WNiIiVHxicZ44UmvIlE38xe7w3yvk9J0W?=
 =?us-ascii?Q?AN27T6DG87eJ6N+nVLkZaAlEFLEPqKZXjwhaLzhW7kTOl6AuDPeNL6TZxVQb?=
 =?us-ascii?Q?5I8G8H4DPVn/PXN9DFQ2AlLfpdC+O2De0xzOgEtz3GSaNqTa4qjrdsIBoxgj?=
 =?us-ascii?Q?kyUSkyC9McHzrYxaXYJe5IdnCx0nFqcxJ9mL?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:23:48.4382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78eeae34-924c-47d5-9277-08dde917bae7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8185

Add a KVM-only leaf for AMD's Instruction Based Sampling capabilities.
There are 12 capabilities which are added to KVM-only leaf, so that KVM
can set these capabilities for the guest, when IBS feature bit is
enabled on the guest.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/reverse_cpuid.h    | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5512e33db14a..c615ee5b1e9f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -772,6 +772,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
 	CPUID_7_1_EDX,
 	CPUID_8000_0007_EDX,
+	CPUID_8000_001B_EAX,
 	CPUID_8000_0022_EAX,
 	CPUID_7_2_EDX,
 	CPUID_24_0_EBX,
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index c53b92379e6e..32b22c6508f1 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -56,6 +56,21 @@
 #define KVM_X86_FEATURE_TSA_SQ_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 1)
 #define KVM_X86_FEATURE_TSA_L1_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 2)
 
+/* AMD defined Instruction-base Sampling capabilities. CPUID level 0x8000001B (EAX). */
+#define X86_FEATURE_IBS_AVAIL		KVM_X86_FEATURE(CPUID_8000_001B_EAX, 0)
+#define X86_FEATURE_IBS_FETCHSAM	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 1)
+#define X86_FEATURE_IBS_OPSAM		KVM_X86_FEATURE(CPUID_8000_001B_EAX, 2)
+#define X86_FEATURE_IBS_RDWROPCNT	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 3)
+#define X86_FEATURE_IBS_OPCNT		KVM_X86_FEATURE(CPUID_8000_001B_EAX, 4)
+#define X86_FEATURE_IBS_BRNTRGT		KVM_X86_FEATURE(CPUID_8000_001B_EAX, 5)
+#define X86_FEATURE_IBS_OPCNTEXT	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 6)
+#define X86_FEATURE_IBS_RIPINVALIDCHK	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 7)
+#define X86_FEATURE_IBS_OPBRNFUSE	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 8)
+#define X86_FEATURE_IBS_FETCHCTLEXTD	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 9)
+#define X86_FEATURE_IBS_ZEN4_EXT	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 11)
+#define X86_FEATURE_IBS_LOADLATFIL	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 12)
+#define X86_FEATURE_IBS_DTLBSTAT	KVM_X86_FEATURE(CPUID_8000_001B_EAX, 19)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -86,6 +101,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
 	[CPUID_7_2_EDX]       = {         7, 2, CPUID_EDX},
 	[CPUID_24_0_EBX]      = {      0x24, 0, CPUID_EBX},
+	[CPUID_8000_001B_EAX] = {0x8000001b, 0, CPUID_EAX},
 	[CPUID_8000_0021_ECX] = {0x80000021, 0, CPUID_ECX},
 };
 
-- 
2.43.0


