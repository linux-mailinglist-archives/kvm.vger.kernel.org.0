Return-Path: <kvm+bounces-43554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D09A917BA
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:24:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 436DD176A7D
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405B6229B32;
	Thu, 17 Apr 2025 09:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dFi7skiE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32A4226CF1;
	Thu, 17 Apr 2025 09:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881846; cv=fail; b=DTpFMysSQC6PyXNd6KBWDluHbxAwd3OmCJkLDhJXrB/2wkCXFat+6UKPMJKT67NHBRJQ7cRgi6aOJAAhmJQoXnExuaxkxoYIiZ7Zn14FSZIo3lBM1wv4/tUzNlfZ3GlOC5YW7uY1oM4rYRNFjWn8h13GflsKsZC6Qyhmckci2po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881846; c=relaxed/simple;
	bh=Y3x7EXV1YcrW8Afspw1vAxXmo3rXsaSfZrtmUiBgn2c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fUQVLGgymU4bxcifhxE0cvPxf5xd9ynHGD4yzL59ns0KyNYo+842x2gq4dA03Rk8I9nathJc/i6o0zdATePJ72DtumsxnTW+mFjc3QjlcNW1hgwGuPDyVIs7UzleA32W67QZBd1brr4c68MetDbxdtBZyTEpa/sQ86s5S1tKHxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dFi7skiE; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cA3GjDKvEGgy+JbBZ033ECxoslLdRMPVCj+FGbMUXwnWkJ1Qu0GJkUICerwWbUXfayenJ7NibntAZgHOWc6n27QFX1SYE+uR4+bGmeFOVF39Z/3hh7LXKpkvTh8D26GlsfnnprF+n9Nxc2Y3NbCPSkU94qHSCjvWg5K+S2q7iMPF9FehmZmvn+JY3rKIjfpU9qY9oNKU7V0Rff3co1HDoCsxYWzw2FUZd2Z1W3z3jlDaApFf4tpBFPH0kFrA0Pj/2YbkvaldOJV2qnsLasphBEUczZV+iL3UbbXlUagCPZMWoS+gFynwp7mU5j9xiyx9BNBtaRJqAJNdx2SBcMwEXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWXiLuEv4l4Qm1T8uayhkmgtLDhe4QigI/3TNIf8d6E=;
 b=R2Cv/b1KPrSzqrtsk+/K3lD+5FzjYUfG4KG6ZiVXsY/URfcuMCVolgVG+fV/NderRqOvgJ4n/K1c2gDj1fpdKnBw5rjVmjxvtOFTEYz1oaMJQAc2eAXM3WOZkSB0/aaOrM0pi8DS/+2qC2HM3Vi8NBwGOlks4EUqUqC9vGIRPbRR1yCirp9txCVNRyRS9/UdFblQI+MlOu+fYcW1gDqVFe/V7obUv0w6d7qaqBaj6wbE8fKFeGm0c6sRV7zUF+IcvUw7tLniOsaVD7LGOaRmHDk6xJFoWjAOiBg3u6YmE1qrqGegZuX/JFM2CVgJnpHRfKT4KCl+9iZFW/TOZxATXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWXiLuEv4l4Qm1T8uayhkmgtLDhe4QigI/3TNIf8d6E=;
 b=dFi7skiEu5caAC2VdOiITXWzAQ6SuGi/I6AVmPQQ3/vzJ62cZhBLn8bISoZmc+SJv+sFvENklSToZMSIF7rtp0iIgMmEXlsr+HyLRkVHNUrmd6MYpQUapQAw24v6xvytScpc1OgbMkmbT8mAGZXlAMjQX/daZxsZ3zUEdY+oKcg=
Received: from BN9PR03CA0465.namprd03.prod.outlook.com (2603:10b6:408:139::20)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Thu, 17 Apr
 2025 09:24:01 +0000
Received: from BL6PEPF0001AB54.namprd02.prod.outlook.com
 (2603:10b6:408:139:cafe::17) by BN9PR03CA0465.outlook.office365.com
 (2603:10b6:408:139::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.32 via Frontend Transport; Thu,
 17 Apr 2025 09:24:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB54.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 17 Apr 2025 09:24:00 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:23:53 -0500
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
Subject: [PATCH v4 16/18] x86/apic: Enable Secure AVIC in Control MSR
Date: Thu, 17 Apr 2025 14:47:06 +0530
Message-ID: <20250417091708.215826-17-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB54:EE_|SA0PR12MB4432:EE_
X-MS-Office365-Filtering-Correlation-Id: 915650a2-8382-46ed-37d4-08dd7d9196b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EkoDganiXfozpGuoKPBcFkCIiWLV4MX9SaPZkYV19B37gyVUlxbZdYX+IaPI?=
 =?us-ascii?Q?mBs8RQ3U6dCA/rv8nq6F5zR2iR0jJ3SvEcbmnE01Va/pK0cRuPrxif+PWptM?=
 =?us-ascii?Q?yr0n5RwnPUt3j284EXW8RYIdWI8Vxx0U3m+Ge77yAeQPwA8+JIb3B4qBZOep?=
 =?us-ascii?Q?Jq/11tuV1YcS7pMpz4QPUtl6rg163O6bnvhNidSvnfEyRxX7pNMK1TJHsEXf?=
 =?us-ascii?Q?Q0jIiDYzmEkSxr1Mwd46zYKRk5/r7M2IG8bfwUgfCc0Gn+WS31qnh7gfFcIB?=
 =?us-ascii?Q?a6WP8mrBJ+G59VQmQMuOM4YTFCqa19G8WMFT0m9CgLsRW8XO5PuwTfVF/NaT?=
 =?us-ascii?Q?ZTqYnClF8JttrZclItI68IZ5W5lP3e4X+tEbQKxv+dGVgKQJ8j/miD3FnvG2?=
 =?us-ascii?Q?vxxEAxcX02JH4oKgCw/QxdGpb8vDyrnACbEdRUfCzuyb0FjkPPJdKjHR9VHG?=
 =?us-ascii?Q?WKYQjI8Fc+J5jgpFSSgvJbPfwZdDnwvO0mTUGjy5/WxaLp02rhm3F9J7LfpF?=
 =?us-ascii?Q?PIClZNXt9VhdfaEaAe3Rt/ltzK2hRiL+Sg7/YTYgzBjXNHXn0tEQI50snhpv?=
 =?us-ascii?Q?M5xFxLzwSnfJ/fM9mi3takC86htP+CqMpJGf1Pjq4bzS22NUNsPVHZj1+XW7?=
 =?us-ascii?Q?r88NeBSzU3pJBHwG7FOf5zumkDFxUC3oPqr8VoPOauoHoerMtx2N2sXLWvfr?=
 =?us-ascii?Q?4tT9GjMrR8RKOTyq+++MOsHfs5HsXLbcLYZkOT0ZZinKD6A+t2IacxfNCZi2?=
 =?us-ascii?Q?skNPiSdiCVsv9zHFlZ7ahsFbo9vrbjsBbAPMl87CthS32cdpfaFJaUpCCyI9?=
 =?us-ascii?Q?YlNCRD6lEtu3cyTj5sclL7mq6v69X0V7eIkt80jd7vI+D9Ls8njh9K/iE3zl?=
 =?us-ascii?Q?YG839TgzkUNm/7HFiNdpTwF2ZraC7vxE6xTcKB6BZmovk2ddf3H5Iv2lAyeR?=
 =?us-ascii?Q?c/FTvxN/ghtIWtlLez0rZnt4LSmU2nZmXAOVppDWG87PK2rTs7eNms1R3N+f?=
 =?us-ascii?Q?4BAh+TAyjbg+gbq41nZo6Pk6XfwTfastMPcUp/La9JRNV+1zPv0Y/QztM6pI?=
 =?us-ascii?Q?gnvXe3WLzN6k/M+Xa09eumkf+brcc+NbOiITMYxTFOK8eFk4GEQSTN8VKWDY?=
 =?us-ascii?Q?l/2RvXSUc/7YSIIYuktUpcjFOG500neEZm45Sriv0hbXMK2ckwnlNLIsONr4?=
 =?us-ascii?Q?RZ/S60UmUnN4jrGUxHxMbOyvQj3XR9onCehEX0cgd1BS9oLg31rLL11eqTgS?=
 =?us-ascii?Q?RPBzBPfhIuFX7pL3/Aztwk1k8+4B3sLMHNKT50A8CQMlnXrgBzBZtmmD+Ajz?=
 =?us-ascii?Q?qtLwNljLUrWaWlt+Xi2E+1f1TZ089y1RVvpoOGdpQbXi+33ZhLkn6LbL/GnM?=
 =?us-ascii?Q?oMBBDOMUhPNvxSBZjhczH9mGkDJfloYxhOa8iL7Joa5vKDnPN2FgDPK9mloa?=
 =?us-ascii?Q?otX8aUIaV/xPWimTdV7LDQNMvzvX/c2/LjwjdcFGsQ38e59kZzeQb36QAV91?=
 =?us-ascii?Q?pzsh4ee8QTTwGk8N6K63gdlObY002wEmca80?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:24:00.8488
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 915650a2-8382-46ed-37d4-08dd7d9196b9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB54.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432

With all the pieces in place now, enable Secure AVIC in Secure
AVIC Control MSR. Any access to x2APIC MSRs are emulated by
the hypervisor before Secure AVIC is enabled in the control MSR.
Post Secure AVIC enablement, all x2APIC MSR accesses (whether
accelerated by AVIC hardware or trapped as VC exception) operate
on vCPU's APIC backing page.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - No change.

 arch/x86/include/asm/msr-index.h    | 2 ++
 arch/x86/kernel/apic/x2apic_savic.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 9f3c4dbd6385..c5ce1c256f1d 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -694,6 +694,8 @@
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
 #define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
+#define MSR_AMD64_SECURE_AVIC_EN_BIT	0
+#define MSR_AMD64_SECURE_AVIC_EN	BIT_ULL(MSR_AMD64_SECURE_AVIC_EN_BIT)
 #define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT 1
 #define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI BIT_ULL(MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index e7dd7ec7c502..6284d1f8dac9 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -363,7 +363,7 @@ static void savic_setup(void)
 	res = savic_register_gpa(gpa);
 	if (res != ES_OK)
 		snp_abort();
-	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_EN | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int savic_probe(void)
-- 
2.34.1


