Return-Path: <kvm+bounces-48004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F02EAC8389
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2F1B1BA4099
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 21:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275EF293751;
	Thu, 29 May 2025 21:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QME/c5Db"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0CF20C469;
	Thu, 29 May 2025 21:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748553509; cv=fail; b=X6o64YKHmRL45Op/gIkv/rvkuAdkbquKoGwuZ6FgvSFML0pm+3ThIOiusOCm0+jYEizdAprZaAXjmjDgz1FZJhZ7E4Ge+z2HWJHVwSzPnFvZM+vqpGNDNborFDoJ9VeNHZW27n0+8Fprl0hgwLsS5VkP3mHcxEgvismq28Ef7rk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748553509; c=relaxed/simple;
	bh=ZdKIUXqVhEAWn17XUyT4ppr790iIHIRnZ79OX/3B3e8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uWW+Istwms2EIzT433it2N/Nww6DX13FObjQRmgU5cQSsn7S+LsIXB3pBvx0e1Ok0q5MWJVYzLRoVlwgtGy8Zj3FVURPNh/4Pz94hX0ElTVSv1FIYcxX2WWmSOCeY3RaQiS56sH5+FYSKpxA2+UHPULPsFFRP6uSrVscEpnTtkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QME/c5Db; arc=fail smtp.client-ip=40.107.92.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i1gE3/68utP8zGB+m05PsjQV9rrFhDEfYDnsUFZ3UVdSSEUdA5uNfDnMnvKzUl3iMTyjhFjKh6UMc+3GF2aRrXwzB1/TPoECjv5yR31KOn0KMamVFIZRcsL1kuA2/9iu3oQCV0trarhqyJMO2FgsdjLJtVnVwgMIT06NiBXBIfk6Beb3FpAoWMNC8A9jsrfTIm1Dr28UC4eH2ix3gBBbeXnUOtBFGgxLeG5OK1wJ8IpBFetl31N2E0S1HnsoDz2wtOjv2FQItjgWo2Y5goodLjAtuHNwGmcaYhB4u1HJzS8T/D/zCP0PfzQLzpP30QX8pzwLw4MPf3lYDBOaJ5qSIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qeO2OVu3W9gbA+aDqteWBAO5r8ZzpRdlwF0lmRGlIL4=;
 b=HbfBv6Rusko6WWtm3SutmExm7fIs83JxkAL5hB4eP/BnBsgShd4c5BOTXPKPTu+gLFhFu4x7/uf5pju3oYUu+QMcKBOxEMQzl/kR/lxry+2HtI2PfFmyf+A58ahkKNMxQdtSPPibBHfzPEMN5gSGLjWwvyPwUxVpQGCJpf9Uqe2EnXhJgAZkTKLdaRLJaV8aNO34OhfUIQVJN3CMAeysl1NYSsDALHWmj6RwJSPSQT5DMCW6CxAN7j9QaKNtSIMqDGotCXrlVyAgvI7MEgHzGNSZPr4xDlzGfApZarPmbSlHLV5VQlCtjnAzHUrqqAM5/85I3iE4fkzOCgvxopPQ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qeO2OVu3W9gbA+aDqteWBAO5r8ZzpRdlwF0lmRGlIL4=;
 b=QME/c5Db7vc6rMPVDS3aEcMg8kbsPBAmyCPnde75ZQaQmJWh/yrwaOnr5sT0dw7CgNiQit75yWHxBF8oba0EOa33fvvLGaHYMT14BTpYo3XGtVi7zJysv4Po9IXBQ99QpwdbUrMYHXXTlmUvJuujyxo+tzUBwSe9gO0GV1YEJeg=
Received: from CH2PR08CA0021.namprd08.prod.outlook.com (2603:10b6:610:5a::31)
 by MW4PR12MB6730.namprd12.prod.outlook.com (2603:10b6:303:1ec::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Thu, 29 May
 2025 21:18:23 +0000
Received: from CH2PEPF000000A0.namprd02.prod.outlook.com
 (2603:10b6:610:5a:cafe::e2) by CH2PR08CA0021.outlook.office365.com
 (2603:10b6:610:5a::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Thu,
 29 May 2025 21:18:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF000000A0.mail.protection.outlook.com (10.167.244.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Thu, 29 May 2025 21:18:22 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 May
 2025 16:18:19 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Subject: [PATCH 1/2] KVM: SVM: Allow SNP guest policy disallow running with SMT enabled
Date: Thu, 29 May 2025 16:17:59 -0500
Message-ID: <71043abdd9ef23b6f98fffa9c5c6045ac3a50187.1748553480.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1748553480.git.thomas.lendacky@amd.com>
References: <cover.1748553480.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000000A0:EE_|MW4PR12MB6730:EE_
X-MS-Office365-Filtering-Correlation-Id: 40a48ccb-f966-4ad2-1872-08dd9ef65781
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YMzRFHld1GYicsRYt5bynEFnsr7FpRGvks/2DpuTI0sk8TSnd/uKwSSTceyI?=
 =?us-ascii?Q?myE7Av2/Sn2JuyVMIkCEYuPh9njm/pInLRnl/uWpZwCVfnVFIQwLshQJCuVS?=
 =?us-ascii?Q?Nipn6/lnNysokJEZBJPFdN/cPdyYscdqMkAXIA9ABQK0Gp8ISapJA9I6VlUH?=
 =?us-ascii?Q?GqpP5Dg+Y6BwCTxvfyAa6S9KGFm/kuuLR+iiRQOVzDZXmFlDCF7k6BeoKvmH?=
 =?us-ascii?Q?GX8MIh20gD91ZZdc0vPnfZRiaUQ9RbvWvuydlTzeEOtwk42i5iMPv7Yxwykk?=
 =?us-ascii?Q?wO730SbOrsF+SCGpQfsQuqx4EtpL6GpGSwWkWB3ORJUStNMpOcjeBdSqtyu6?=
 =?us-ascii?Q?edZjah0E8ekX4UAMjW6BnLnPpSLIGcJvaOojP1uDX2sk5NuaGnOZpixI6boa?=
 =?us-ascii?Q?w7GvAXdllq9tObJtdD5QirmB63nXZySfzv0JeQDt7iJooeHl3KT4iV+cItf6?=
 =?us-ascii?Q?ztxRoOF5ukyzoo5tPmHijuNVxtQ99wINf4x+rvGhBg77c1c0wtgS8Hn9Tx5Q?=
 =?us-ascii?Q?UR7mw285zGBqPJbwjVQzRO5pAdOw6JYQRcj0oCUhlRefkrDou920tWXCvhQ/?=
 =?us-ascii?Q?8A0i2pTg/xu9HXEGjMHQktoiv0idz6jICfZVcasuowva1Q8upurK5sRL64e1?=
 =?us-ascii?Q?3QLYZeeTCrdyhAbog5Y5yMy7jGSXCF71wtY2n5R3qF+TDAatrVgjGYCco7rI?=
 =?us-ascii?Q?IgAnSlprDHIvqklK3q9MZlhCoELRXgrVgf8/HIsg7FdgcjQMT4b5PZ171aHO?=
 =?us-ascii?Q?/BBYxGsFGHoCANH7YbwmT5gqdkfEMzSTIN5QJdZ1dmL5MsyMVXgAB3VlBKR5?=
 =?us-ascii?Q?ihV/uh32sjzTSccuOCJ3CTwyqWw7SZiCY27A//+nGOe4uU7idwi6yNEh6il5?=
 =?us-ascii?Q?LNFqva+/4oMQQQvbtmF6hnLHzaYW3K8kvfL7I1sHF7pUwBhF4rh2X2bsuyOp?=
 =?us-ascii?Q?znNHMo9zupYttbLTGbj+k9sbkAK0/W48Rmcp8yqJAy5kcSAsUTw0dL1CXRLc?=
 =?us-ascii?Q?SPkS49scyyig3uHY5nRJAdgdp7mwhkn187OvWhZBbxPVvRK7Pp/WmMSvsCyV?=
 =?us-ascii?Q?ltcOlksZIVq1gXFcUAhXbG+adw6cQzct95P2+0OeZN5T8LwS8cfx0WInpMON?=
 =?us-ascii?Q?sgOOv3Wz1lAr8M4way00XeEJ2DiWUXmd8xPXfuLJPEj5893UdxNhwAs6XhV+?=
 =?us-ascii?Q?zJ98bcVtsC7oforjdAWSSalZ9u7aiRYFPOFG0KkKfpIUALlcFu1BPAaE/dSa?=
 =?us-ascii?Q?G5aaJ7BKPTCqa0TfFD1cHlsW1gP1zvnVQ++rX6UsZilkuoeZ9WIAtpFoASiw?=
 =?us-ascii?Q?gsHEUj2FMfMOW+gNprdGCSKee9vyZQVQMh+wFCfh/stVSbqBDLmcYWx8CmEe?=
 =?us-ascii?Q?nic46wnqdflHZroahUhr7y3O+/yTjeIGO+uWbf3KQWaoST1+xBTz/D3150yL?=
 =?us-ascii?Q?uqgn0IvN9voXA4zPOYY/GuMFsy2dCW0m+7j5CUBhJCavDYbXM91SLIHip0A/?=
 =?us-ascii?Q?nP93Nu/+ETGGswBZvxo4jmxaM6TUjezOtLfS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2025 21:18:22.3173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a48ccb-f966-4ad2-1872-08dd9ef65781
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000000A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6730

KVM currently returns -EINVAL when it attempts to create an SNP guest if
the SMT guest policy bit is not set. However, there is no reason to check
this, as there is no specific support in KVM that is required to support
this. The SEV firmware will determine if SMT has been enabled or disabled
in the BIOS and process the policy in the proper way:

 - SMT enabled in BIOS
   - Guest policy SMT == 0 ==> SNP_LAUNCH_START fails with POLICY_FAILURE
   - Guest policy SMT == 1 ==> SNP_LAUNCH_START succeeds

 - SMT disabled in BIOS
   - Guest policy SMT == 0 ==> SNP_LAUNCH_START succeeds
   - Guest policy SMT == 1 ==> SNP_LAUNCH_START succeeds

Remove the check for the SMT policy bit from snp_launch_start() and allow
the firmware to perform the proper checking.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 978a0088a3f1..77eb036cd6d4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2194,8 +2194,7 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EINVAL;
 
 	/* Check for policy bits that must be set */
-	if (!(params.policy & SNP_POLICY_MASK_RSVD_MBO) ||
-	    !(params.policy & SNP_POLICY_MASK_SMT))
+	if (!(params.policy & SNP_POLICY_MASK_RSVD_MBO))
 		return -EINVAL;
 
 	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
-- 
2.46.2


