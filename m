Return-Path: <kvm+bounces-38987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0740A41DC4
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 12:55:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 588483B8FB3
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 11:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8899A25C71C;
	Mon, 24 Feb 2025 11:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FddvXp+1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FAB25D520
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 11:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740396423; cv=fail; b=AFCw+urE7Rht1g9Yib/08iZMT+1evsEE8JMBCtvjdSO/EdeOUzTFAJmyDoE8RtcnqrzZW6NeO39BnEQGVJqghMegjIfHY8caWzmOX5iQmwcIfhpV8Y+ANCMpWAQ2uxnrDQq/e21ckGa+FfF91qGPlfxipuMJCwkS2UXguc5N3Wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740396423; c=relaxed/simple;
	bh=ZW5PFaleOqrm5JezSh3GwjmRDyoM56b66Y8qdeX2F7g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rnij1yRogxNf2r+Rmh5rtH4I/6zxgu9EomvArf2JEpdOKkZ8gM1gzkdIA+dYs9+igSJwDVFMg2ou008vSU1BKHs2Y8ENTMJ79gQBlBwWvv3pRYrZZyySxguLKUMz77daH0atpf4YbCrQpJKNf9g2yVtP/NSDbCSGj/6GOZe6uM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FddvXp+1; arc=fail smtp.client-ip=40.107.92.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XtOsH9hw87a8GtCswKlGtWSAFzV/0SVYB9zlf5BBHzeE72prH/MayZJOq++BUvZTYUyN3Q+MWawh6y4QnfCfXg/JkAsMvvG+jK2JD/IQuElCjRnQ8eTIU7JFG096aL1qhpwq/8m/WlVLLWKUuzUm0o618DUmgV3OP40ae3SAqjiJOtT/c+TasGFTz5jVKx1ipNR9X+i6Si75U77diNCQJqRZw+npR82IapneRmYt3K0oLaEtDXvYlaTc9v136HMMp3VvIoA0zDbbaU0fI0IW0GPpLfZKuAN9hEx+p0NAWkr3wBHGenlsSOueov0GSNmFaq5peXPycU0xEibf2tMZHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vzWXnKz75MAqmHZe0ulugBnFx21it5hfSBjdjHkYnU=;
 b=uqHjVS9dAdlFEdH+FPSykN6FQzeDRZgvR3d7r1MZ8KYmfY8CIItT+bBSTVkXuo3B7jBc8vhSR808lwhqUFxyoNaV/imjbWtadaE/r9ailG2+vBmw9sO/fmLJL04sQD7AW3FJLXc+f5h4A4CMx5sh2wWbSSzBKwWsktOBlq+1ht+fmrmbFxl9RaAknJM2cntJJf+1xn4Rrvm5mTCb1SMh374T6e5ErFpTtPTL7sVbndxNkPsXEELuVCEyI3H8O9ygvr7ARYw7I3uh/HY8pedwfFk5uB3fz1bjgqaS24hbvNUD8T/dYTxbsI2Gn72TqDW8gkSNYufaSL14YBSeHlDiFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vzWXnKz75MAqmHZe0ulugBnFx21it5hfSBjdjHkYnU=;
 b=FddvXp+1B3nIe+JGCP7Z459uBZa6CvyDiPrdrXW2d49+Oxtc48L6DhGghHvIdCOeIuacDcSd15pg24TTXaXNIenyEpeJL1S7prVuAEoVGDf8goVOj2eStsUe3OqEqheol5bzRaLnINtt0h9rA60YNeeSvS+dSmUjLRIMZyqFurc=
Received: from MW2PR16CA0029.namprd16.prod.outlook.com (2603:10b6:907::42) by
 CH3PR12MB7547.namprd12.prod.outlook.com (2603:10b6:610:147::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.18; Mon, 24 Feb 2025 11:26:52 +0000
Received: from SJ1PEPF000023CD.namprd02.prod.outlook.com
 (2603:10b6:907:0:cafe::ee) by MW2PR16CA0029.outlook.office365.com
 (2603:10b6:907::42) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.19 via Frontend Transport; Mon,
 24 Feb 2025 11:26:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023CD.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Mon, 24 Feb 2025 11:26:51 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 24 Feb
 2025 05:26:46 -0600
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>
CC: <ravi.bangoria@amd.com>, <nikunj.dadhania@amd.com>,
	<manali.shukla@amd.com>, <dapeng1.mi@intel.com>, <srikanth.aithal@amd.com>,
	<kvm@vger.kernel.org>, <santosh.shukla@amd.com>
Subject: [kvm-unit-tests RFC] x86: Fix "debug" test on AMD uArch
Date: Mon, 24 Feb 2025 11:26:01 +0000
Message-ID: <20250224112601.6504-1-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CD:EE_|CH3PR12MB7547:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c2702e9-2732-4ed4-eb91-08dd54c622be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Tn9G5Z9vkXlMrgAbc6q7bt9OM9AkJ145rYScKY1Y8/SHPIA+UE1MR7JDiLNA?=
 =?us-ascii?Q?kkQojlsJ0emEmOxcAf5EDqPDCdDBvteYcfV03pC5PL/2PadWsNJrd1YzN2c9?=
 =?us-ascii?Q?vkiSy658K5dOp9r5nctktXxbDF5bl6PwndCngz7m0rdXJOgG1usthK4ut9d2?=
 =?us-ascii?Q?HyaLB2L1x+zyPv5jCcgOYyi3Qh+UdlariMnHlqza6cxZtOkyVvCHfR1TVb8J?=
 =?us-ascii?Q?y0pAKKs0WzP/UjEbiWb592ByiQDlwT0EanUVvN6wlXshLiwyqUR3J5bQRiIf?=
 =?us-ascii?Q?tx5c2d2LSoiZ+DYZhQtllL2fbeHFhLhGIfRMEWm0BA5bCbCPa2hpZhcGasC2?=
 =?us-ascii?Q?+5hFEVZHfXdgPyrnuFEtvI+amO0q21War2F8JCKF50BvmN8ZMpn3crEGWhsV?=
 =?us-ascii?Q?ogyBJvN1qt7Kb5HJK9yer6iVd0bhWxnpKjBsjlRFLRqrGMe2/8vBGLl5HGOJ?=
 =?us-ascii?Q?JSj5bvRM/LZ9LPhGjzNQOuBno0rZixOgWtqDMTG8f9B51jmH1yFcSr03rny+?=
 =?us-ascii?Q?TjQXcPStb8ITvAJF5j2OshyihWeMC5YDHRKulL1/4kfQPcq/d88Yqcy5ZIqk?=
 =?us-ascii?Q?ThdJZxuTwoYy7TS34yqToaBHtGRH1tiHO5HU4GjLmI/+66lAaoqvdWSJhOiG?=
 =?us-ascii?Q?4E80ISo+sxvWPAPkA9y3xp/k1tpiEgA68sXyFD3evY5tt8M8f4XGN++pfIWV?=
 =?us-ascii?Q?9iXrI4D5lN7VXdLjqw31QL8xuKsxfxmoYTqKLEK6XTXa5vxWjYSoRSE4WMw+?=
 =?us-ascii?Q?aBZ7eUyPSArg0AMuX6Js/zUP+lKpMxrPOQQJllwyq/2NQ1OXxtinIwSUDNug?=
 =?us-ascii?Q?qneOd2Wk0OVhyQ+7C1U44Km7pdizEvLpsjLGtBgG/fVg5PaKW4NGXhe8u675?=
 =?us-ascii?Q?HQNu8MP02yke4SypMziW9fVgz7K6GF1rvvpaXsfW9fxn+utozSL4XBVKpnR7?=
 =?us-ascii?Q?NldeeOdQKwYhlfFiScxU70WoUfId415lbU7QrmRh+hdHXmKDa9+w2VpjUTLX?=
 =?us-ascii?Q?HXZUNuEeSeLhRNMkHM1+CzyHeXJHxGLfQSEh9x6PB7QruX5B7RNGXyr5ZYYP?=
 =?us-ascii?Q?esxy7MfcrbqKyp9I1Kt9BogtZO2+5/vH67dNXAZ05ISGHlmFU0TlTGiNifkQ?=
 =?us-ascii?Q?I3A66rTb77JwW6mEIc7mzLjBqg9nr+f3dMwhPo1m/0tLOj+5yeRAI9lEO+6N?=
 =?us-ascii?Q?DDtaS0lM505Zlel0z16p9tI3RYxm9tSMkXWSgz+1rEQg8wfXUqxlaT0Dex/J?=
 =?us-ascii?Q?l8VN6N7r0lVWXWOEMmrilvzL2ZszdaQVc96so8kQ7pFmfwKDKxab8lGvHtgC?=
 =?us-ascii?Q?MshCciwCFAzZBPtdkrg5+c1oO+lVOqvc5HCsj5DZLaScxeeSMmLXSEQRzVHO?=
 =?us-ascii?Q?yVyxX7NhqcAC2vpCCNyjVH6hAovoZTeu4EWMppFqrybv+wbVkbMCsCUzrvrd?=
 =?us-ascii?Q?8L5GJzmcX0fX5FNBiU5VXV1BqPdqYyFj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 11:26:51.7955
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c2702e9-2732-4ed4-eb91-08dd54c622be
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7547

As per the AMD APM[1], DR6[BusLockDetect] bit is unmodified for any source
of #DB exception other than Bus Lock (and AMD HW is working correctly as
per the spec).

KUT debug test initializes DR6[BusLockDetect] with 0 before executing each
test and thus the bit remains 0 at the #DB exception for sources other
than Bus Lock. Since DR6[BusLockDetect] bit has opposite polarity, as in,
value 0 indicates the condition, KUT tests are interpreting it as #DB due
to Bus Lock and thus they are failing.

Fix this by initializing DR6 with a valid default value before running the
test.

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 13.1.3.6 Bus Lock Trap
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Note: Although Intel SDM (December 2024, Vol 3B, 19.2.3 Debug Status
Register (DR6)) stats the same "Other debug exceptions do not modify this
bit", HW seems to be resetting DR6[BusLockDetect] to 1 for #DB with
non-BusLock sources? In any case, initializing DR6 with correct value is
semantically correct on Intel as well, so this should not have any
regression on Intel platforms.

Reported-by: Sean Christopherson <seanjc@google.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219787#c13
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 x86/debug.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/x86/debug.c b/x86/debug.c
index f493567c..2b1084a2 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -93,7 +93,7 @@ static void __run_single_step_db_test(db_test_fn test, db_report_fn report_fn)
 	bool ign;
 
 	n = 0;
-	write_dr6(0);
+	write_dr6(DR6_ACTIVE_LOW);
 
 	start = test();
 	report_fn(start, "");
@@ -107,7 +107,7 @@ static void __run_single_step_db_test(db_test_fn test, db_report_fn report_fn)
 		return;
 
 	n = 0;
-	write_dr6(0);
+	write_dr6(DR6_ACTIVE_LOW);
 
 	/*
 	 * Run the test in usermode.  Use the expected start RIP from the first
@@ -339,6 +339,7 @@ static noinline unsigned long singlestep_with_movss_blocking_and_dr7_gd(void)
 	 * General Detect #DB.
 	 */
 	asm volatile(
+		"mov $0xffff0ff0, %%rcx\n\t"
 		"xor %0, %0\n\t"
 		"pushf\n\t"
 		"pop %%rax\n\t"
@@ -347,7 +348,7 @@ static noinline unsigned long singlestep_with_movss_blocking_and_dr7_gd(void)
 		"mov %%ss, %%ax\n\t"
 		"popf\n\t"
 		"mov %%ax, %%ss\n\t"
-		"1: mov %0, %%dr6\n\t"
+		"1: mov %%rcx, %%dr6\n\t"
 		"and $~(1<<8),%%rax\n\t"
 		"push %%rax\n\t"
 		"popf\n\t"
@@ -433,7 +434,7 @@ int main(int ac, char **av)
 	write_cr4(cr4 | X86_CR4_DE);
 	read_dr4();
 	report(got_ud, "DR4 read got #UD with CR4.DE == 1");
-	write_dr6(0);
+	write_dr6(DR6_ACTIVE_LOW);
 
 	extern unsigned char sw_bp;
 	asm volatile("int3; sw_bp:");
@@ -460,7 +461,7 @@ int main(int ac, char **av)
 	n = 0;
 	extern unsigned char hw_bp2;
 	write_dr0(&hw_bp2);
-	write_dr6(DR6_BS | DR6_TRAP1);
+	write_dr6(DR6_BS | DR6_TRAP1 | DR6_ACTIVE_LOW);
 	asm volatile("hw_bp2: nop");
 	report(n == 1 &&
 	       db_addr[0] == ((unsigned long)&hw_bp2) &&
@@ -477,7 +478,7 @@ int main(int ac, char **av)
 
 	n = 0;
 	write_dr1((void *)&value);
-	write_dr6(DR6_BS);
+	write_dr6(DR6_BS | DR6_ACTIVE_LOW);
 	write_dr7(0x00d0040a); // 4-byte write
 
 	extern unsigned char hw_wp1;
@@ -491,7 +492,7 @@ int main(int ac, char **av)
 	       "hw watchpoint (test that dr6.BS is not cleared)");
 
 	n = 0;
-	write_dr6(0);
+	write_dr6(DR6_ACTIVE_LOW);
 
 	extern unsigned char hw_wp2;
 	asm volatile(
@@ -504,7 +505,7 @@ int main(int ac, char **av)
 	       "hw watchpoint (test that dr6.BS is not set)");
 
 	n = 0;
-	write_dr6(0);
+	write_dr6(DR6_ACTIVE_LOW);
 	extern unsigned char sw_icebp;
 	asm volatile(".byte 0xf1; sw_icebp:");
 	report(n == 1 &&
-- 
2.43.0


