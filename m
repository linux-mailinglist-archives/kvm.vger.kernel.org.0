Return-Path: <kvm+bounces-48851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB65AD41AC
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:08:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C822F3A655C
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228DE24503C;
	Tue, 10 Jun 2025 18:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S/p8Am96"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2069.outbound.protection.outlook.com [40.107.236.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87D823C8D6;
	Tue, 10 Jun 2025 18:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578862; cv=fail; b=lq/I6Zj0WabNfoSvG8ElpMKH60A+CsahMM0kiWCLUIMjHagOi2CErPw8dWo2vqHwf4hRnZAeURch1gmRKKSQp2l3dRoJj5Ed2ePFc9hQGJS8DUHmyyJ7A8ytzviujwm2E2ANM6t7ZRY6mWIBogC42xyogGvCJ+MNUVQ0u0iTDFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578862; c=relaxed/simple;
	bh=+nx5y1QAvyYjina9GFVDHUOhVFVKD6tX/1Bbqg5MVi0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H3cI5AL9s1+x7F7TktMEHWm9uPMJyENw/qj9bqj8l3smwoZMY9P1Ck4VvIzznV/H2vA95g7iQKKBw8aiBTcIVB/YZk9MRrUCOi6yF0qGbdDRfWt3YFSBOWvIaElHJlbgFFRZ+3SViIwUTArD6tOj4c0CfxEO2YMEfIisLmyyOTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S/p8Am96; arc=fail smtp.client-ip=40.107.236.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HMAGUARCM/XufRL4ifL2nKTFCACzJKwSB3LUFHHSvTaujJx0/7l74xipAk/v9gLh39UCs1OZOVcxBOa/IWabXSPpjFezu2kMn9yWhdlYXoDgILkwXcytS6v6jujnTpzW7ZYvpwJd8QsFxKtFC+VLO0rL5YBK/ujDbgA4HSutD1thr+pIL1bth5OVnXkERT0eSsSS4VyYxW5AEOGAGXsmNBeAVoH8qeUKfg/YdzhLCUXkR+qFC9gndgwkOizhEye9UQFgcLgXUBpLW5+orGfaVFNUNhJJ2/2Pu85zSCgHLWYvJhE1+v4yoHCSTe1ZNiDj1txzHChihedgVSVdcQD7uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XWaMaHtRXxSRIgdQ+a10SDPGOnhANHDrLGB0gfxc6bQ=;
 b=Uo61BQhMy5XzuoG9Rnk3RWtnrQ3iOTBAqCVdEjpIwOI89AJbE375MlOZCjWsOM8U7ZWbPrOUgtZdapq6rSUbgVbpnZlwP+Rsg9/r4VjguoLQpiFnO84H3c1R7GEoEuGWg/oAhUGPQLtW701ZwpO3oRWdkYA4ZlC6G9MeZdks+WyagnOMAKSCPIy4Uc+cws40d9PQG9YUSciNBEB7CnTf3MNtctffCbMFYEMCfgueIbb57D2EuHEzmboDLFAya5BAM3SVL8zOSyzH9pgMGya2XTSpwWnNMFtvAr8BK8CwjV/PNz9KRvCFlgV9ppY9T06Umh7gIUdvIONFHqa0/wiOLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWaMaHtRXxSRIgdQ+a10SDPGOnhANHDrLGB0gfxc6bQ=;
 b=S/p8Am96VQVBwdKsNYOp3wjpubex99UnM9ezTtQd2r++YU78/YXqukZMEI22oeQ/gYGhiG1LRFjnNjkTS6OSVb7tQGTEVw+yz/onEsoPecBX5LDhs1MFVxrNzdbwB1SFf6v9Iw3dW8ZqvZbCJr3gx8oc5uCUK+t82etCthg6C2w=
Received: from CH0PR13CA0055.namprd13.prod.outlook.com (2603:10b6:610:b2::30)
 by DM4PR12MB5796.namprd12.prod.outlook.com (2603:10b6:8:63::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 18:07:37 +0000
Received: from CH1PEPF0000AD7C.namprd04.prod.outlook.com
 (2603:10b6:610:b2:cafe::f0) by CH0PR13CA0055.outlook.office365.com
 (2603:10b6:610:b2::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.16 via Frontend Transport; Tue,
 10 Jun 2025 18:07:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7C.mail.protection.outlook.com (10.167.244.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:07:37 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:07:29 -0500
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
Subject: [RFC PATCH v7 35/37] x86/apic: Enable Secure AVIC in Control MSR
Date: Tue, 10 Jun 2025 23:24:22 +0530
Message-ID: <20250610175424.209796-36-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7C:EE_|DM4PR12MB5796:EE_
X-MS-Office365-Filtering-Correlation-Id: a7ce3c6f-1293-401e-4c65-08dda849aec8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JbQxNTtn7F9uzSAtLNLHRLGme4GWZdo6fUJp5GwjLvqGlV2OjecaoSUmBD43?=
 =?us-ascii?Q?4UBygZxEZJ1DiQpcmMCXuZ8kUbzWSBaygmanrzCQrAF6hzCZXcf1o670PiLZ?=
 =?us-ascii?Q?KSlqdW5uUI8qBb/gBtkI7FzYFSLdFhJ8f7qNnyo8jPjeRtR7e5zdXoOQpsHH?=
 =?us-ascii?Q?Afb6vGD6t0MhopNk21G16lwzCRRTC6ca2eO6KhMrbAz+zgLbfiDN357nTwvX?=
 =?us-ascii?Q?jN/ow1TYTrfwW/NLHNP19LWwOXCEM2bYdaKpj5GonQikQg9SWvk51rr5oGRV?=
 =?us-ascii?Q?2nHYI0Wm4TZRstimLVc7QomkPbRMrDFdA/7i0/XRxCT+7/IyvRHEcZqhXjtL?=
 =?us-ascii?Q?/vzlW8KKOpZIj1QJtyhvceOZ3MQevhdjEQh+Y1oZqBjj8Ygxl42wx9PEUSYV?=
 =?us-ascii?Q?LFJCCm11bLoiPTjHA2dIJ57tflwV20kV6EaVvBc4cm+ga2OMiX7UJsuXIriq?=
 =?us-ascii?Q?xF0xqkWM4E8YFHSejqx1pBWs+GIlYv8Aprq7PM6f93VvK0UitPxn2yGMmZov?=
 =?us-ascii?Q?iPYMBLNo9EpD4K/q+VzomcdUjJgRcbh8gydRkryRmEyUy4K/pD4IDi7FJ00a?=
 =?us-ascii?Q?K5KL/UXxk2aDsIvTPqsFlFgszJkvdWxYEuc6fdyrkRaBq5HhRxVOXF1AyahY?=
 =?us-ascii?Q?L5DB09E38cp9/d35H9YmYo1BdlhMIoyUxjr1z6MoD6MDhwjjXVRFsZ+PHovM?=
 =?us-ascii?Q?PmUHFyeXS/kmmzdD2AaOIL+NSVzagH7DnSkBHjJDc1L8WpUYbifj/ueggKlz?=
 =?us-ascii?Q?+jRD/p/fuMg16O4APCjCe3fPClvVGGZYSBvgFCSxAbwpuxedri49ElpnN5Zz?=
 =?us-ascii?Q?NevUNQkDwYitpWrOfC7irf/R+nmC4fgDP1p6wwdOAn6RvlDXZwYHAPYSq/rS?=
 =?us-ascii?Q?6qwHgOVY/2xxTjAXpM9YKxqyX9Jao1F2Wmzb4qojD8fLK+EQdXkGvMS0CpUc?=
 =?us-ascii?Q?0rkQhCEdG9jw1PuxHV3H6UPo+azWnH0kKkCrbHs2NL0LgArW8iIOJUEcEBVs?=
 =?us-ascii?Q?7LCgrL9Z4j+eJzvntaeiMA0OWF4s1j77MjiUx9vFos60ZPhbGQXIhEl8hILq?=
 =?us-ascii?Q?tmxEHlGvU6GXFTBLnE6QfEwuLW1k6C8dopvoss8131w5jw4hM3W3+UY6oS4L?=
 =?us-ascii?Q?/uTtXela8wrYW1+B9of841lZseed+HOb3bmYSXn+FPYb6gUTxpIipLz+Eokw?=
 =?us-ascii?Q?5YrOlipkPx2/gMGSOx2UM3ELDoKhKBQ1UdwTP/KS1BJsbVw2jy2yGSd9xZfv?=
 =?us-ascii?Q?Rox7vRK3Ry33GOVkMWmPQhMyQptxpN2OAL8qQOaejSulvhOMNBFY4OgxlrQC?=
 =?us-ascii?Q?er5zKe2uaK2l8woYsDCAjXKgZ7YqBUIcpbBNS4sxnvFvbVyh90gmCxhvRoOx?=
 =?us-ascii?Q?vPqFJur7bCdpy01AvH9ReFYQvBYhTJ4aO4LOv0CqC0dFyBsjIDhvZ48dGcUv?=
 =?us-ascii?Q?33sRcJMdzUkw4MQRRlu9uzdH/1aNoMPRTYXo1/IpG65FLdvn1qkuXIeirr1Q?=
 =?us-ascii?Q?iJkftjm00NsA1dfX0xcgz9QFhYntvpFIeChO?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:07:37.4370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ce3c6f-1293-401e-4c65-08dda849aec8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5796

With all the pieces in place now, enable Secure AVIC in Secure
AVIC Control MSR. Any access to x2APIC MSRs are emulated by
the hypervisor before Secure AVIC is enabled in the control MSR.
Post Secure AVIC enablement, all x2APIC MSR accesses (whether
accelerated by AVIC hardware or trapped as VC exception) operate
on vCPU's APIC backing page.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - No change.

 arch/x86/include/asm/msr-index.h    | 2 ++
 arch/x86/kernel/apic/x2apic_savic.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 7ef1173ef15e..2264bd768f51 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -702,6 +702,8 @@
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
 #define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
+#define MSR_AMD64_SECURE_AVIC_EN_BIT	0
+#define MSR_AMD64_SECURE_AVIC_EN	BIT_ULL(MSR_AMD64_SECURE_AVIC_EN_BIT)
 #define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT 1
 #define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI BIT_ULL(MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 417ea676c37e..2849f2354bf9 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -375,7 +375,7 @@ static void savic_setup(void)
 	res = savic_register_gpa(gpa);
 	if (res != ES_OK)
 		snp_abort();
-	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_EN | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int savic_probe(void)
-- 
2.34.1


