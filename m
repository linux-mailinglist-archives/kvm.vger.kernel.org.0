Return-Path: <kvm+bounces-39262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 138DAA459AC
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:13:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E94393ABE59
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5EFA2676F6;
	Wed, 26 Feb 2025 09:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VZcQT/Zz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2071.outbound.protection.outlook.com [40.107.96.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10752673A3;
	Wed, 26 Feb 2025 09:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740561059; cv=fail; b=e2P1hWwXIsZHwwmwdaLh1v79TyS+fjcx+CP38YZSLXjznowTqwpsFfN/2yS1iOcL+IyF7mOUK4VQqMZ2o8QN1zQhp8UFVDLGwYZebUpG1DzxSt0210GFzzaeLaUR/V609JW+T8F7+8K3nrZAj/cisa+z+n3jNicv6DOWG4Zkvzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740561059; c=relaxed/simple;
	bh=Qd2CAg1kDIr4WaEMKrqyqazIy4kNu0LmdtSRqL9UmzM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=THy6AV9z9kMe08SfyuB1Utoam8qlTGNryM8CLvIehWj9O8vk/HavRCoD0nLym6RmUgCUMr15ZSdUj3Lggyb6GqZxi5Kbc6/ldtR7qnL6fw893Bar2h7713uMzwjSsAkwE668qvONVNr1DninmAJbLZTc/pOcsqTVoALSOhd3Ak8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VZcQT/Zz; arc=fail smtp.client-ip=40.107.96.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A3L8tkLN09BWWZYDmvqa1HcAkSKYckGoNsSeYxH/SibksjH4yp4zwmFNf1ydPRt02spDgVxCgzKlx4UgOMouDbgY4hEYYZ2Z3g5BucmIUo6Sp7hIWrJ5xZwZAg9L773fbt5+fUdadB/BeNsPAJOrdIptdy+57DpEujlWqvn79f33F6LTN5maAA1Q0mQysAFhxSILlaVZQPezfUchUzwHsyyWbO7+uDc9OYgPq30O52P49JpLh0AlovVaAd3NcR7tsa1+Gs/LsU8JypI0iNXoEKzKuD125g7v4t6SQU1vr9Qxg/poEe3NYOZcpdrNDI7F2uKSWPbpbYcs/xoRsMdEfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EtV/zMVgddxyg7y4DhrKjPKIm43cHyGIsZbCWAGiAi4=;
 b=I2Z4IkJYSYaW1bLAVNhWpex7GgfhwAmCLRNKkMYdNmvhDg6qWDgQVAVYW3oMG0YVot98vKpmaMxvyP68u+4RsE3i8IxDCjG544eZlwtDygIxhWteH9pzR06KAqesp4fzFto6LUIZwdMjdZuLW3jX25Q8vEB5OV9+6cSVaP7H32U8T5Th6XUB1bJ8KvdLmbL/e8LSQi3KT+2wUwu5NJ1WqFQ1SaeZLjgNVp5ok3Z0OzhwxBk93z7WLDEG5dMLLWdCLy7N0Xe5vh31xGqxbcdKtVSprNDSAKp9jlhBXCBzuSEM1AEVLs05QcQFeCpw65vlFo3nRcEutsQGYUTw56cWdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtV/zMVgddxyg7y4DhrKjPKIm43cHyGIsZbCWAGiAi4=;
 b=VZcQT/ZzfwfV0Ofcg2toGFleKcHQ1GF9kM3oXyQPcyG+VGfe00hPuzbw5Y+AJHNtSddFp1Ctxrol1TcL6szus7kOquWwCG/NQzDqr6wYVHm1i+8KIx+77pNDwhucxfkFvYG1s7HmFEI5IzJQLOwlmYhduFlyjUQvOO2Cda1wQ2c=
Received: from BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30)
 by CYXPR12MB9426.namprd12.prod.outlook.com (2603:10b6:930:e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Wed, 26 Feb
 2025 09:10:54 +0000
Received: from SJ1PEPF00002320.namprd03.prod.outlook.com
 (2603:10b6:a03:14b:cafe::66) by BYAPR06CA0053.outlook.office365.com
 (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Wed,
 26 Feb 2025 09:10:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002320.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:10:54 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:10:48 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 17/17] x86/sev: Indicate SEV-SNP guest supports Secure AVIC
Date: Wed, 26 Feb 2025 14:35:25 +0530
Message-ID: <20250226090525.231882-18-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002320:EE_|CYXPR12MB9426:EE_
X-MS-Office365-Filtering-Correlation-Id: c84a7d4e-a05a-4a92-93c8-08dd5645798a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SGPFp9nnWp/FQStvN1ncpjddHXQNyCulGWFHPaxo1YTyxT93RpcdWX+Qvt19?=
 =?us-ascii?Q?/Wg29/o0OL2Q0yVTcgcMrBVT1djg0HBf7NK34eh9+oIVnYplLtMJ5uN1F2Un?=
 =?us-ascii?Q?rlYYi0yU26pjjQIDd+nbx833c9+uQFQlguGSMfbXmkc4CsBlUCm/RXf7C8qh?=
 =?us-ascii?Q?lgvk0zytXuc6uQGdzjkfoQNg0ECHtOCw6DGiaqopVfLzk1VOXPX1dK6M1Edp?=
 =?us-ascii?Q?0sQq+Xb+np6OcTL7mPZDdzpQqBJlR7B1Hw/ZM/wh19XE9ttjcqn856QELBw1?=
 =?us-ascii?Q?/28Ac1TOPWs9KK/oDM3tDmsHfPBKoNcMTGk0ieK+iC/IWEJgTxY62Uhpz5CV?=
 =?us-ascii?Q?RcRZlLV3uYdF+KlDhHcHhGWvivbaGNXlNKvFCdpPXJ/8gncUmdwSooSgtqYT?=
 =?us-ascii?Q?fngfX4cfynyf3w4NTCo20VtAQMoA53SYj0dgHK9S3KqmunP4JRiY/Et00mIU?=
 =?us-ascii?Q?RqsHIT3GJmVWIv+AJG/wYMM1ec3Pvrq89vkG9X98MkF0olhojkSy3kKlO4ec?=
 =?us-ascii?Q?hDaXHobmdQ6Eb2wKNWLUqMgmI7OAU4JDX8fKwuOMlmA/2mf0gXdj/DerQYkn?=
 =?us-ascii?Q?07R8QMrolB9seeIdI1R+SaV2PWqgvi0+6ZI5otmstFuqtlBYIc9bui/pJSOP?=
 =?us-ascii?Q?MtAhuoNycvSxpPrsFlqYgnPlNWq0cBpT+5hftUxadGU9cjO8eWrDUKV7rRZT?=
 =?us-ascii?Q?cxbKCC+2zphQsK4V9xgL1nV8Khj1YmIsI/lqOf2yi+TBi5Kud3Kw2HYgPWSm?=
 =?us-ascii?Q?O7+PiVFcKV9d1U9fG3x4OdRq0JFHxmRJGBVNdG+dIZyZiY+SCfEgc7tKVdvN?=
 =?us-ascii?Q?Mis/4Y3/Wj5njrk07lSV8WXPdQnI77X1o9zJ3hvDXLAuomeDrJNB3mfnoKly?=
 =?us-ascii?Q?oc/BvbPXPzSYA63O2/prBdbjwzHX3HOczwwz79PtrQ1qZcDarC5l/7sf5D9h?=
 =?us-ascii?Q?LeMSmHSHkuFk0GXHwI3LEuH0qd/NQV2o+wxo0bHKECAP7qqL4QFN6FcvBN9p?=
 =?us-ascii?Q?PhUM3fyeDp6ZCrmcJzb71aPkkaQ4dH3Zh6qLsBVhrtxRgbmI7e4Cu7pAjw8f?=
 =?us-ascii?Q?QBnVLwUlA8UT5PTSsjoI/ieb2pqV83J8lKD5X7u9EKRmdWhB/DgIuM/CSzib?=
 =?us-ascii?Q?Gz4QVGt5hK+X8tPl6ZEQKRmj6CzdZFY8wIbhYQXBZQOrR89S2ltyrCgMwyew?=
 =?us-ascii?Q?vneVvww6Jgq4u0eLZKCf7IJp8/LarloaYXQrorcTWjE8ayP5ZHieWYpFqTRj?=
 =?us-ascii?Q?pqXt1Pa6z+K2HafWvF/q72O9HTGnm/LuRzbvaAXKzpkmw88edyiXB/utG9bx?=
 =?us-ascii?Q?g94K2R62KCNnYz/qkQvCMgt66N19cmR91fup/yatpIxD8xoS1VpSgOFfV2P0?=
 =?us-ascii?Q?vgx7FTmLV+7QEUHFjQO7PVNEq7RrdDd7gBrI5OouC0CJOIAQJngw1i390h6u?=
 =?us-ascii?Q?dZWbf7T7sxQaQ2lgofuBBh6Hdk9yA5U1dt+b4N4SjzkBFjg1noa6xgNPiu7B?=
 =?us-ascii?Q?gPfbRc6UPeRXxtE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:10:54.6616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c84a7d4e-a05a-4a92-93c8-08dd5645798a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002320.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9426

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Now that Secure AVIC support is added in the guest, indicate SEV-SNP
guest supports Secure AVIC.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:
 - No change.

 arch/x86/boot/compressed/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 798fdd3dbd1e..385063ceb89c 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -403,7 +403,8 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
  * guest kernel, a corresponding bit should be added to the mask.
  */
 #define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
-				 MSR_AMD64_SNP_SECURE_TSC)
+				 MSR_AMD64_SNP_SECURE_TSC |	\
+				 MSR_AMD64_SNP_SECURE_AVIC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


