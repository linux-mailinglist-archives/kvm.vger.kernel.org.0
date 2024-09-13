Return-Path: <kvm+bounces-26812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 01372977EAC
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:42:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 760D31F20F60
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD0F1D9335;
	Fri, 13 Sep 2024 11:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U793wdS3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041A81D88C1;
	Fri, 13 Sep 2024 11:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227706; cv=fail; b=uVCNuZ2c7ZZgYBeCx1JJqkKe7/seOohq3PyLbbPy2BCiXdlEkwQ4B43IvooALaJB0dlcbIpZq65/+htDuSTKjEkf41woiP5t3eWH+bPPBfLOocLTFvpUYTPioc7S0ZWbn47vTlBLnqgLk1nxyGR/7EZcezEoy+mI2idYN4ixdkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227706; c=relaxed/simple;
	bh=24Dyrgs4MCvn687dRMkmhZDqzozRLzvpCXHVWNpOwFw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E3z7iYAJypz4HYarXZ1b0FWirQ4kC8UcTSaycsbpHUTMuZnrWEuRuqHKLEEOIhftHFnjVW9gs93aaw93DJ3US/69JwKE991eojaAA/+g2Ww5FEVY6iS3apaxI89O+DJDJIsmc0X2tYdR5ZmyRuq8UK/x9OAxe6hF6GzgBFW3s0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U793wdS3; arc=fail smtp.client-ip=40.107.237.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QZpB1ZUtd4h+E9OlRtdwJbQ35aZOuPK/ZGO1wt4WYeJERhBhMbP4vS9fcCRxD0n/CJbUNllIrKvOuOqtWNInoDd7E7rMrG0SOsOT8aQNHakWJ1m3EI76jE2iKtkg+bAsOrR1+cYyZ1cX9WUe7BsbEvNn3AqnOwe1I3hnTB2fMu8Oti4wtD8Y1e9VuaYMTCosOVP+U3i3UvcMovLcDAmrO/CXDA76bXySXD1z6EBuU70OTlflT3i5+wZzXFg2WM6Ng6rLCvo0sVQkuzuaCZwBkLgFP5yr8/Ctse2728O93kxrGSxB0RN5J18/dyquzICrJ1SGqg/EXxkJU0/XusBN/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1KpV7nmNR/O98BSTyWcSRz2cmOxmsrvJOTtk/1fLhQ=;
 b=GY16h8u8Tpxb+c4eXaSmUMMvelrpQkgKt2a5rNCI0mryDPWSboc1NYpSWbdfQaBbsjMhKEzfOKastwA1smwUvQ+oprR61q+5vlGq8mg+P9q9Bgcl8k8g7SvviLW7hf75fBkiWv9jVKps7PSQp767s8g5xgh+1MDnSypP8VN70uXfy5TtdSaM9KJYlzonJoSxl+HN5H/3hG7fr8f2YYp0Ij7yxiQs9yp4V35pi4PM0DS6Ox369rm0Bzp/l7TtsjtW3d70/80fj00gS3kbrmSqjbwnCmxGyM+eRMffi/5YR4Lei0ZkKXF1z44EKx6xLR3mGtHOzFlJ7nRHMZ5JnNlbWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1KpV7nmNR/O98BSTyWcSRz2cmOxmsrvJOTtk/1fLhQ=;
 b=U793wdS3vfUScGUfC6w3S8m4W1cWxtJDWVl5kDUMCNROf6YpyJyVwiZ0fOrQh4aGBqNRNmEMOnt4Zv21F3waCqwFXbxy5qvkxRIA6MvuaWwF/Z17ir9o1YbwY7H9E7i46yaPCXvNBrBu2uJB8QdkSjDZZ0FgehTPVPgb/iEytEo=
Received: from BN0PR04CA0160.namprd04.prod.outlook.com (2603:10b6:408:eb::15)
 by SA1PR12MB7410.namprd12.prod.outlook.com (2603:10b6:806:2b4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.20; Fri, 13 Sep
 2024 11:41:41 +0000
Received: from BN1PEPF0000467F.namprd03.prod.outlook.com
 (2603:10b6:408:eb:cafe::f5) by BN0PR04CA0160.outlook.office365.com
 (2603:10b6:408:eb::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Fri, 13 Sep 2024 11:41:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000467F.mail.protection.outlook.com (10.167.243.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:41:41 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:41:36 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 14/14] x86/sev: Indicate SEV-SNP guest supports Secure AVIC
Date: Fri, 13 Sep 2024 17:07:05 +0530
Message-ID: <20240913113705.419146-15-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000467F:EE_|SA1PR12MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: d414d01d-2781-40fe-9bb6-08dcd3e90902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cDZ+wJqiMA6gOxxBYObFvCZtnFVO8a8d18wIxbxrnPIWUPSZmRRsf2C9TQHx?=
 =?us-ascii?Q?q8Rk/t2MmDHY910oQN+lJtw7xT7egIO46KB3Ax5EoeU8plgMlHy5kWjMkzzP?=
 =?us-ascii?Q?GtpAIEHrX2refuApvMWKH1hLxE0j9AgSTr56gCPVVzdV12PkHLB+z6Y3mkgm?=
 =?us-ascii?Q?9Lp6TNZGQlqu7Ka5InTIyWHkHNX09YOn/W32DfJJrIa0EhWhI0ObLGugl8MR?=
 =?us-ascii?Q?ol2nupusJOF/yPGa6tWVn0s2cMaj3IYcDXGjTJKq/WKij5A6zswPkTjkg/kR?=
 =?us-ascii?Q?Nrjo6Dh+yX3fomz4N41rIC9hZEt7K7XNn2w4yQsWPDdbgUa00Yy5V4B5hopQ?=
 =?us-ascii?Q?T9FEm/SQKMZV5Fh3SefoonMwomf82kGrkVZSlNlLzT5q23PGNeAsaofoFQZz?=
 =?us-ascii?Q?O3+Cd9GB7WakzdAjdThxrvgf0KoGHspWu8XMN25xfODLz5LRQ7yj33+5jpl8?=
 =?us-ascii?Q?KbJyIVXXY0w4tTz/7cd2ebFMAb4Q1D722VlbLtFezeZsZVsUuaY3bHzYPWDH?=
 =?us-ascii?Q?e79+fB4ujh1BSPPh3tZQL1W+YkmxB8dXtwQUwIKQWWDk2LTpvGMTApmIC5ba?=
 =?us-ascii?Q?KIwwMkSqH4uLbfkX6OlM1e9akkY24Jqg4BQrYMbctoDgzTBSTDScBsB8STS3?=
 =?us-ascii?Q?XfLmUOsMkkdHERsPniHbM4MBrtx+hKkvCj4QkX+FQ0aUfven79UArkHrmIH8?=
 =?us-ascii?Q?O4cEg+NI5rOARihEr55FWyce8QMedgAbcQ/scXVH0jo4483lihzfh9k3Zs1u?=
 =?us-ascii?Q?I3UWv/OMRzUqVQWET1B7PeD6qpFsHnWUJGlsTCAzUZLXbUJO4d+OOObm3DJf?=
 =?us-ascii?Q?hcUZN2Ow22C+nuqhz/ojNoWDnDf0HbbSc3dNsA6CVKDx97GbF6CVWffMy3gq?=
 =?us-ascii?Q?jBDd/7PrcM/xsKEwG75VE4Ux+VSbWOsulJJztdJPq8rqmhDc2Mp3Mqk1dLr7?=
 =?us-ascii?Q?6fzJQbIDysnQxV6gwWBacHqpFKYYv02lsd6UoJMDVmV7PDfQh65viLRPhCBM?=
 =?us-ascii?Q?1NIzzPuPQsRe2FD6o0TaUmeZOzJ6Qu3WcAAi/j5bxZSgZylsF56uI31k7MnK?=
 =?us-ascii?Q?AJonRhQ3dWpQTwi31wTqnqp6DA4Cqssbln5nYnIZ3RQL/yL2dJmbwuVM7ogJ?=
 =?us-ascii?Q?RipZ6XhcMF4WY8HF+r/I7Yep0JWx15aMvrU7UBpmVuERC6vjBGT/HQCQrDEr?=
 =?us-ascii?Q?n924SAFCQ+d8D4paR4EeJQenIJloVHPf7WeylFVEg6SRYlXlHR4NR7uc3FPZ?=
 =?us-ascii?Q?jfmIdXT1rO6fciYINtEN17QUEWsDY3pvucZbjr3U0sNiMpG11uJuCypFuVm4?=
 =?us-ascii?Q?5meIGYBm1B9leSTnAt9cJ+elu7O1Q8ZxUC1UZBEehDyf6VqsRhfRL8VJqJdj?=
 =?us-ascii?Q?Z+beE28+wVWIOEHbARmgOhhZZoNOtSm9fEB3VIjTL9E64z9vC9Uc62E7CcyA?=
 =?us-ascii?Q?YcmnzP3csUyvH458b5Bj/m7M259UV32D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:41:41.1149
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d414d01d-2781-40fe-9bb6-08dcd3e90902
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000467F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7410

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Now that Secure AVIC support is added in the guest, indicate SEV-SNP
guest supports Secure AVIC.

Without this, the guest terminates booting with Non-Automatic Exit(NAE)
termination request event.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/boot/compressed/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index ec038be0a048..fa5f1dc94e2b 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -402,7 +402,7 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
+#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP | MSR_AMD64_SNP_SECURE_AVIC_ENABLED)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


