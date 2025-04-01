Return-Path: <kvm+bounces-42317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69210A779D6
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:43:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03109166061
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D7C1FBEA5;
	Tue,  1 Apr 2025 11:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iS4izuTP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332601FC7D0;
	Tue,  1 Apr 2025 11:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507723; cv=fail; b=pgR8fpwnTX7KRRzcDeHLDvvl0KEMeofyObclq1mIqlpDXm4ZPTb7PBVYUMaG4GUN1rDygFS++DECj7Wmxmt/MrZVcYU7kYqxgfyp3jS7Bd8y80o43UUqP7T/JzsYvtRBczomFMoUb1ndZ+k72I/IZAoQSwhwgVB3fMCBGSwpstM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507723; c=relaxed/simple;
	bh=+N7E6kGKHfYQRiKdPD83+PzRlzt/Ro9fWIF1xVfY58c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W7q0sKHKZ1Qe3hdTClTGoIm09Qur+UV1x5gJz+jXVkGGEzuNDDj/UXKPNjqXwWgQcm9eIwuvXEb6egOCU2+AleUenFm1Ny2lmhrEulvCOOL14mqxyYrsp8rDT1/lnrj4HM6xmCsEvuIPpKyPCar8wy2uRNYWVNQikY9XnDHLNA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iS4izuTP; arc=fail smtp.client-ip=40.107.223.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C5or0T/qMuO/NMSYendNkrbOH0L/6UIDJjZCLk9oNltOakaneYDskya14kctghLb0LJTIPbqUSZHsXKi8rUEVO9usVmo35pStF+bekBvbmPfWyYLrNLegfp4SI5RO+DoJWlAjp2E3IlOc3111Se5vgaIT3HdM9T4XmqxLvxKTGREu2nSQsGBXHn/8FuomJaSiP+Y+ao/zKBJcrhzS7dARK1g1Ia1nPykUiwotGZsCLvx/JZIwBgE7JOlAypAeVXZPL/CtwBCiVcbA3Dceqbdxd+3CEOiz+ns7rM5Fozp/RA4vli5vLV77pl4kdSFiHzVeOYhxVcuKUWq1ZX+abw9VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XETBELVtjbgvPRmQF7xDKdaKIKkUgqxWSzBdcguTZqs=;
 b=ZSM9H/N/7Nmf1Ol5A9J/Uax7V6d4e3E5HvXpt0kC2wJOrC3Wk1QvlzzGVXJ5XCRHycmOqkjedjeDhjOOHwiMV9+bC25j6jdJc0cLjk5r6INZUiX8bO4mDE+F+p+bWyg9+0hU46Gg2OqV6hrcdIjZmCsS72H+w9JFNMZ5UYxxxDngnjzqynOWGLbVCKb66PPOtCh4nkLio9dC6+dOReukAXBZQi9v0DacrM/V9uohzM6rOjc3+eYH43BqTNz4YIUCUAb8987hVE4CuZMHQY2Iht9o/hIlBX8Ya2oCpXt1vXtv0g94zhylGzsqJnWXMEo5k/ZwlP9qQ/r4IPJokuZq9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XETBELVtjbgvPRmQF7xDKdaKIKkUgqxWSzBdcguTZqs=;
 b=iS4izuTPc6n3voVBWWAr63tGE59KtaQeppaPIEF+ev1kVEnXk2ZWmAyFWqMMEZQ7bzL6SwnuB/ro2lxS1NAiY+eXy2DXS51JQbxc1JBnNrtmqmYynBMpfKfNRFrghDOCDnp+oJRmD4mr19Wob2/TCoaQ3kj5JW2fi7bzw2IBlXc=
Received: from PH5P222CA0004.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:34b::7)
 by LV3PR12MB9213.namprd12.prod.outlook.com (2603:10b6:408:1a6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 11:41:58 +0000
Received: from CO1PEPF000044F8.namprd21.prod.outlook.com
 (2603:10b6:510:34b:cafe::9d) by PH5P222CA0004.outlook.office365.com
 (2603:10b6:510:34b::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8583.41 via Frontend Transport; Tue,
 1 Apr 2025 11:41:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:41:57 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:41:51 -0500
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
Subject: [PATCH v3 17/17] x86/sev: Indicate SEV-SNP guest supports Secure AVIC
Date: Tue, 1 Apr 2025 17:06:16 +0530
Message-ID: <20250401113616.204203-18-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F8:EE_|LV3PR12MB9213:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e432181-8bb7-4d9c-72bd-08dd711235b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?62wG2K8mi+cQyKDEJGQSZcOGLAum1y0lVK8cnxOymZOSvxS+tq3xMo6s91dZ?=
 =?us-ascii?Q?DeEKpUqaBEduDOwh7owcppYSU1hOl2IQ6wQoWW+AuSoCCdci9AEDkToZdT2j?=
 =?us-ascii?Q?nGszfeVryYm4Lzf6/Cz3etiqxnXoOXXRx8sbx1GzJXCOhjo/1C6Dizl3T73t?=
 =?us-ascii?Q?87ciqz3hP4LdxZ957c4vpweSUgvDjJLKSNTdxICs9V1PCcjMBkebo/B0UXxj?=
 =?us-ascii?Q?gLycF4zyO5Gu9ebj9VnDeFM806BpBXKyoVVGgl4q1BwpqEKbzSBRzrleOTOU?=
 =?us-ascii?Q?C3TORJ9icfcHhMPd82zp7surdY3I929/1ASHOrKuA2FEpoCGKh4KVxwFOBYZ?=
 =?us-ascii?Q?heyiVqg3dimjdfxk1wsil9LjVPhBpbB+cepArNZ5L7150EM6q7v173ZuzcP4?=
 =?us-ascii?Q?Myblh0kjOhA0zNVkC15paJZUPzxWJVzPIqlfNyvAc3L/91DNE/kXtXULI3T3?=
 =?us-ascii?Q?H6HP0290FezebyUqUxwZ4wlS4hl3OEC9uYmEyArYSPxzumQK43PwlQdUYjn6?=
 =?us-ascii?Q?X6ys/PQ9P3//Pg2Ccv/zh5gbne3uk6qJofzj/eiRvEIqWL6T6l9nu7LjGOrh?=
 =?us-ascii?Q?gRtbFOuUsEYWxJplhNHE8qTTAaInv6e80DsXP/BfKxrw/a4iO82ryl5QVdyE?=
 =?us-ascii?Q?pSxDH8nXCPkBu5DTYRvo5b0+PvUtF0id46zj9CBCB3cPV2Lzn9qIN74anLTw?=
 =?us-ascii?Q?nCBG/DlBtjq3mvjwh73ORnBbeCsHUgkJNtbZzw0c9sgUa/e7UeFY3qYv1gJP?=
 =?us-ascii?Q?Y3yK3VfP2gt0mZMpvuSlKNNBndOlkJe3Kp3mfB8ubkAksH21luFh0b55fdl2?=
 =?us-ascii?Q?k85hox4MrGzejoXxrbhRVZdiqOeovrxix71Cyqk8ybBEqlAwJmylXQ+WBmeB?=
 =?us-ascii?Q?CTG+zunxfaYQTYRhHCcDiWRVUdoZojjL2rQsu+q7XMOkKA54JR2RsxFtYY5e?=
 =?us-ascii?Q?E4Pahkpdx8lsrB3di9S8eAWOXyI2DOfsbk1HdTWU+EeXcGWWqLBRO60XbNFe?=
 =?us-ascii?Q?HPlrlEu7UL8HvgxKNfNAQOp7W1Rz2tKjO6KnQy/faGV183wDpCZS6CpOyUnN?=
 =?us-ascii?Q?6dsE32yEHcNQoyTgAQVJdUp6cRTQ6mLwrUtzjaqksQOAV5hixnae9Nw1+VsI?=
 =?us-ascii?Q?ZQEImCJpju0BJWllqhwN3tXBZS/SeuqloIimxxH7Ehs4jxucLyT+UmMUHxBc?=
 =?us-ascii?Q?PSGFGm4qBqIJ7tAWk+9241BZv7szyoRp7vxJhhtb2N37RsvYk5Z4ujxuOWHC?=
 =?us-ascii?Q?TFxdSkdX0Vzag5s+Hull7xQnZkj67UZ3ylgkuXYqYMeIkc1pEbp2GoEEQ//G?=
 =?us-ascii?Q?nXZgBYWwpf97o0pSBMD8wZHftQvXX7/yZKQOfLwUr8RXYVvfTfwACnn/YJzS?=
 =?us-ascii?Q?bEKRave/tgraPZcb61T14dy/DWFnuYZnsTc06Thjo6iNsj7jT5yhLMZlolI6?=
 =?us-ascii?Q?HqOgX3txBb0kl0WT8gtFYqmlr9cMCE932SlGKSqiVIA6a0XHgo4YV20wc5wW?=
 =?us-ascii?Q?w+V84mvxRuzt6nc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:41:57.9574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e432181-8bb7-4d9c-72bd-08dd711235b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F8.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9213

Now that Secure AVIC support is added in the guest, indicate SEV-SNP
guest supports Secure AVIC feature if CONFIG_AMD_SECURE_AVIC is
enabled.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:
 - Set SNP_FEATURE_SECURE_AVIC in SNP_FEATURES_PRESENT only when
   CONFIG_AMD_SECURE_AVIC is enabled.

 arch/x86/boot/compressed/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 798fdd3dbd1e..adcbf53ad50d 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -397,13 +397,20 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
 				 MSR_AMD64_SNP_SECURE_AVIC |		\
 				 MSR_AMD64_SNP_RESERVED_MASK)
 
+#ifdef CONFIG_AMD_SECURE_AVIC
+#define SNP_FEATURE_SECURE_AVIC		MSR_AMD64_SNP_SECURE_AVIC
+#else
+#define SNP_FEATURE_SECURE_AVIC		0
+#endif
+
 /*
  * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
 #define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
-				 MSR_AMD64_SNP_SECURE_TSC)
+				 MSR_AMD64_SNP_SECURE_TSC |	\
+				 SNP_FEATURE_SECURE_AVIC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


