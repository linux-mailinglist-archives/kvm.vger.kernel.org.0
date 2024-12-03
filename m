Return-Path: <kvm+bounces-32911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26EF49E1773
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 10:29:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 671ACB2674D
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2861E1C36;
	Tue,  3 Dec 2024 09:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pXs58p5h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2077.outbound.protection.outlook.com [40.107.236.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91CD1E1C1B;
	Tue,  3 Dec 2024 09:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216523; cv=fail; b=GeIX7QDkIYsh9gUAjhY9MA/zRhB2f7ghU2IXrwu/PhyY8GKjO5KsnUnknenFkcL7sl905xT8SKmX/P4m8dDxw1a6FhjrW/8s7MP5i2U9jnHY82aIysn8cCaoaUxllM4ToyFavq0W21OzRT5PKgCeIEd0sL82TsDt4ATl1Hd+i+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216523; c=relaxed/simple;
	bh=J7ITyZv4fTZN+ZfiudI2wlQZ6XlSSdAR/6O3kPxxatE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CrQGNwriHtpuE2L7+dMhjiHUsbjqMgEOgB9wzf4oOA/Cs0M1YgVC3k1xrrdgIU0D3cVD4Eadxpv5yGrB7hT16FY8bJ4md6yzzq1MFtPFMX7JbdsbRcO5CzzmpTGfudlR63TRHTDyeWJq7pvwHNP0I34nHGNd+hMTLrcXXJwvJ38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pXs58p5h; arc=fail smtp.client-ip=40.107.236.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=btZZ+1d5f7VklRyBBK1XydR76IZhZqBBGArUuItPIrHRD5UGtNVc7/nxex356HMGTMZBpw5TBGwji0oyQtXTt6GpiBAfWTH2PAKTOvxY/NJdnKza0MvjjCdR87SCacfv/TldddFnQFZ9QcJON6tSb/EOVSZfhS98Pvl0xhc5xt9chy0g8cCLL8h1BlftASr4vOyYpZrhCRTYFbQTipfzYSDnTTZyk/t4onlgbNuVBb4j3uVzdByp9jj0a2LLxNnUqEHWJNssGnw58oUd0Ps9X4cvhb+coLITMCEalOtVQERyhzFjXdFbKmh8v+0XWitG473jjtshxhqHDR8KTEK2Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atjBLt16IpratFsJbg/6ZonMoxx3kjKCKv65wzEaGEI=;
 b=I/kQsgACSeHW9zqe1wGr6qh0Qtqiw61LTKX53c5lQeMspIUXaBtKjBuzEn1wB3y2P/lwLYtqQsMuquyZzwWjtcaMsfkwb4YxHHZPM3lN7rKrAIeErXr+8h7PawKK53WKkdr4Q7q1tFiiiYxkoN8YQ16nnTocLFTaPH8qOmUip7At7jLLNoIB7u4m459mi+10VfeFpiO2jUrXZ8xCFhIt5gw2PCMXprqHibnVeKM7PbuV84dvvq2UTtPVIyPL5rnszbTVy3zwB5b4zhvowcTRGyG5ljfpURyzdxdzfRj+g7eutiqT8T/Qbx4tTfbuat5QZDKtx3bmNLcrFpyhTI1zwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atjBLt16IpratFsJbg/6ZonMoxx3kjKCKv65wzEaGEI=;
 b=pXs58p5h+hES5wfhoFKVO715+nUxxbHMUJzvcONqnuDxjdS3t9udWN2NM8D02ZQZ6Gsv/9yvQzJmZl4FUqYNuEnOZ/GIXZM/9+ME0rmcg/fTijQLzVjXTnnVHQc3BByoTS7QGjWPYpfutZWTqwPQzVS3fBvWsEGNd1rKtO0DFSE=
Received: from CH2PR12CA0013.namprd12.prod.outlook.com (2603:10b6:610:57::23)
 by CYYPR12MB8749.namprd12.prod.outlook.com (2603:10b6:930:c6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Tue, 3 Dec
 2024 09:01:56 +0000
Received: from CH1PEPF0000A348.namprd04.prod.outlook.com
 (2603:10b6:610:57:cafe::2e) by CH2PR12CA0013.outlook.office365.com
 (2603:10b6:610:57::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.18 via Frontend Transport; Tue,
 3 Dec 2024 09:01:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A348.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:56 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:52 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v15 13/13] x86/sev: Allow Secure TSC feature for SNP guests
Date: Tue, 3 Dec 2024 14:30:45 +0530
Message-ID: <20241203090045.942078-14-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A348:EE_|CYYPR12MB8749:EE_
X-MS-Office365-Filtering-Correlation-Id: fe929ffd-8079-4e7e-197a-08dd137923c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7j9rKRFBmVwF95DXZ1w5wClf+76RK87sM6mazqe+khsH4IshnyPJv0h/T91o?=
 =?us-ascii?Q?WsRyj2mAbgFylCB3jLYaV9KhOgLlshgz7QtnDQ9QQdDk5LEkZ6I4Wy1WC/nk?=
 =?us-ascii?Q?mPBO3Gw80pQjxUrXnqnSCLW2SBarL4nNQ2Fy2J86mcZp9UgLVVr0ewlkkA7d?=
 =?us-ascii?Q?lEm4pO9tMlGvpZ7kk+PB+EcFxMX6mIQi7zEIYEalIGX6DQ7zKTjd/72mcy6P?=
 =?us-ascii?Q?HE/LfWdmHEu1R45+k5q1EZ4qd0sfpaXVWigdLgfWzDxfOVTVe/5laK6GoYxK?=
 =?us-ascii?Q?NL2T54688rH09iQAxrLYc83dQqOESg6jL0UnxS44ZdDPd+Ksa2y9kY0tTbk+?=
 =?us-ascii?Q?K2SwNegkTMDSMeN0G/ZFQON3f14RIo1LYd6/+QaM4Ra2W1qd8hwPOjCUO127?=
 =?us-ascii?Q?FN7vOJQaFORsFFKuXLq118hrIYM5U2VAzxO9HrQ+cckuW6KowevTworyvOtM?=
 =?us-ascii?Q?zCYXn3aPkZCiVV2TBCYKndugewGA75iv1dR/DtnSP3vp3ybFqQ9yHZfvEF18?=
 =?us-ascii?Q?IAfZP4ts98NNDm+g+5lXvdma5i6WRiymUOG0Ci93bTuRW/82vQ/blmP72cuX?=
 =?us-ascii?Q?ocJPSloe761A4hrpdCPQ0zZJ0nLRWIsisQh9npoLr/4vmmlke7o5V7IZ4j6v?=
 =?us-ascii?Q?HFUPkg5VkXwnVBUjnBf+IvPb1mXN4tF3VRvUTWEgWlhb36bvPwXdigwnJu4s?=
 =?us-ascii?Q?I2Ri0h+/YkXPbDbPC89PDiZiWM0xkbMDWebFCKWa18/aN5euOh/sW3JITbKd?=
 =?us-ascii?Q?Y1/RGLD1bB9Gr10dGZzZe0swGT2T1iOkQhG+UexDJQObDCqGv2puJS1gyDx/?=
 =?us-ascii?Q?+qifWEfV3lCd+QJcRVBWBKNDjeFT43TpMKO0uFm+FikkidAz6tVPoqLYiEIr?=
 =?us-ascii?Q?YIarSz3G5/paDbIpiqWejGRvhijsgXYAiaWJnPvs86tbJPh3eC8eX1MNAT4g?=
 =?us-ascii?Q?7q2kaVPtu0n081lDkNYwg00PPeRZQKO9Olcj6cn4xBzvBpfeyNwYFLgz6yqx?=
 =?us-ascii?Q?7kCFRmDoeKFayKAxsi7in9RvtTAiMSkbAgqD5mPnkBhkQHpVu5ZBujMFKGQm?=
 =?us-ascii?Q?a9esqH5cVeNFjIchr8McjnOAk9T6YTdXEdTC5qMn0JgkfoLzw65qCSYx4JRS?=
 =?us-ascii?Q?M/x/p/Et/LkVWv6lERoXkrZLRsyJXTXfSJbkYf+q516+lOWEO3DlJmJqiVI6?=
 =?us-ascii?Q?OwvuIRg48hnn0UTNKd3vTP1L4YbhHL1dc/l29iha9UeSUVcGiCiRN7ncJnt0?=
 =?us-ascii?Q?4QrI9XR3yFS8W1Ou3jHL81g81lVL+1u+ed21JZHoIBPsPzkaERMWqp8y2mke?=
 =?us-ascii?Q?N3egPXRiaJNVDqs14MT/Lrb8IkdZTJpl2jRSkzFKCdvWygPD9tHG2gAgRQ//?=
 =?us-ascii?Q?NGiuzmJS2lw0uvKIeSs0HlBfr7rrQQeDLMsfvcEjVfX5SFPD/bph8RmqAGDo?=
 =?us-ascii?Q?wmhkuZKBLdQrrIQKV1FMpaYG/J7BU8d3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:56.7893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe929ffd-8079-4e7e-197a-08dd137923c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A348.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8749

Now that all the required plumbing is done for enabling SNP Secure TSC
feature, add Secure TSC to SNP features present list.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/boot/compressed/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index cd44e120fe53..bb55934c1cee 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -401,7 +401,8 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
+#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
+				 MSR_AMD64_SNP_SECURE_TSC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


