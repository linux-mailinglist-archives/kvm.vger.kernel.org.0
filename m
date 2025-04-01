Return-Path: <kvm+bounces-42315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94CF3A779D2
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C13881890492
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714591FBCBC;
	Tue,  1 Apr 2025 11:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ReLP3WvM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0534D1F12F1;
	Tue,  1 Apr 2025 11:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507681; cv=fail; b=qSWjYcjlt//IHO6cdmn9b+UTABPAdhvALzPeXtHS9wIf1jl+HoOqsDfT7mm8X4h1vnEqCqQ7VYYTZkOsjGKonAO85k17BOaJC7ukZ9JzRSx8YpZ+JMn3nhE83Bp72ATgLip7XLQzVrdA06wYJGtT3Pa1+jwiau9O+ottzXt1Ieo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507681; c=relaxed/simple;
	bh=3dh1TYDNjv48/0HB8LQG2QdnDmn04+2dsOkRECTcARw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dPzWUcCRRgxyNeRycS6+0bolF5eFthxsps4cBEmSKKkj2S15WIXQFSk9JFfjtc698aBwHKuSGi0N9EO72gxzQUHjjwm0r5DSP1zw63ofZf5Ee6wF7a0WhrJXfDl+Hzv/bb8gKfL27zCOykvkVowtd8zBZyLwd7ZBuaCHbhL1dv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ReLP3WvM; arc=fail smtp.client-ip=40.107.93.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQ4wM2bFPkBUZgxUu+8BEZtGIRz6T5iK2mvj0d9J+r+5MA5R4JKT3OfEzTryNVBt+xCYMgFcgF6rTiIvzUbymyvyy5bfc25cf7hRZDet/BMu8wDinqw3lmFvjJqkJZw61WuysxHGTnEdCYfROFI2srK2o2VIbmI1a2Arec++PwBlq9Krlc46OZPEoEG836if8DIS+TYsDFG9ywI45c8Fgk9CDxEeTToZoaBVGvuEccjmZYHfwREOc9XfifgtACcFLw2VP4HFpdCH6IYXS3defH3tRjmDNZEePCPtw8ZyZsQ9kCZ65TVNRcGuKI298H7DEKJanGOLd8yjIpJphVAIow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3t6o1YDsXd61KxmXE0lxQcDVynF7zwuu+69D+1D9ZZI=;
 b=uWzxkcPyMv1TwY8D06ISVO/9cXkPlSTYeCZKyKqr/UZfHOoLjRFPKaIIsqjb4Tm9hAjOrQ+3AwSGLlpFgW6M32E97/XeSrjPQR5NIpmi/WcIeMwXHr2hFH2lGZc0MtuxvZvlDpFkJ15CyfMifjpnp+fGY6W8v2Q5g04gF2UwTbStdaSmH9JaLGNpvUqXMlQY62b4WiRYJrtNF/nRSQkUenngv97jzADuCEGO63b7vcq73F0C468IDuAcwOHPvsmAGBiJ8dTOw+c2jVbXFkbQEA7oYUN51OsYmJkVp2YLY60P2Gk0qp8PRWuZX0jmUP4Qg/dKsvXE+M7M30ZNHiWmaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3t6o1YDsXd61KxmXE0lxQcDVynF7zwuu+69D+1D9ZZI=;
 b=ReLP3WvMFnaOkdbd9l+P/Ext9dICjk2SdfRGseerUKesZNK3jSiNwK+Gq/eA89mgrm0vrixPPjRMsEeM0DLacwoUvf+u8bAYw8vNIPVkf2H88NvXFTfeGr/FR+mO8Nomb55cB6DXXLngG7QL7Tl3z6b+3OV3WO1EobpR8CtRWX0=
Received: from PH7P223CA0021.NAMP223.PROD.OUTLOOK.COM (2603:10b6:510:338::16)
 by MW6PR12MB8958.namprd12.prod.outlook.com (2603:10b6:303:240::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.49; Tue, 1 Apr
 2025 11:41:16 +0000
Received: from CO1PEPF000044F7.namprd21.prod.outlook.com
 (2603:10b6:510:338:cafe::92) by PH7P223CA0021.outlook.office365.com
 (2603:10b6:510:338::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8583.39 via Frontend Transport; Tue,
 1 Apr 2025 11:41:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:41:15 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:41:09 -0500
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
Subject: [PATCH v3 15/17] x86/apic: Enable Secure AVIC in Control MSR
Date: Tue, 1 Apr 2025 17:06:14 +0530
Message-ID: <20250401113616.204203-16-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F7:EE_|MW6PR12MB8958:EE_
X-MS-Office365-Filtering-Correlation-Id: fd505f88-373d-4a59-8331-08dd71121ca5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fwa2OdUOweVsY+j7bujRnFlL4xN1FnOJ7yLiL6CSHvX2PVZ5mLXN5dZ1knUs?=
 =?us-ascii?Q?OyjCD2oo13gBt/AUe7tZj2yl/MZ/OX4WNGxfEABDztR1EAvJACCjAGTLkQSV?=
 =?us-ascii?Q?rKMXhU/cPYW8sn6zwswG6gH1hymXU0pOXzJUoDMZ+Na9Vw/3awbuJvbCyS6z?=
 =?us-ascii?Q?ogiW+ZnHwM3hmB1y8Ffm4GJF2dSnHOR83f9bt0Hbx/iEo4b+fPGcMmjRwk4R?=
 =?us-ascii?Q?Ki5dtwgEp1yoegxDpHrIavHn08kc23UxzE1ys2RofE5GlDE8DlMCmny7rOCs?=
 =?us-ascii?Q?T3hjgiRA4AMPaQ5lUzdrAtY8ZrZD+XVfnGPzbG0bv0aDvT1leNQAAcgu/I1O?=
 =?us-ascii?Q?ieJlFW/9buEAImYzMSN2SB7VlKcp3fUP9BYEYKjYPAJQLV9i7BwIWQntgAJS?=
 =?us-ascii?Q?Q5DvsBs47TDPhevnduinngmduKY2IB6YbNW++mRr8Fl6sX60dQJHZwvEXjG2?=
 =?us-ascii?Q?+nOPiofkgxPNRf5NF2YUGBdY4pBcTPcAo8MG21mohSXPMyiRnToWcy95sTBE?=
 =?us-ascii?Q?yTHQ8P7E8PV2FguYjDe0ij9ow4odIS4ZE59qNzIoy1uHv9cBXIX6ceEzJ3jJ?=
 =?us-ascii?Q?enlG1enS50gX9JgP5IFnignNitAed5O4VvnJjYX3WJkqUpJN63qDjfT4Sb7V?=
 =?us-ascii?Q?EZ5O3MeZFsroWehCXEHZ5Hwux/PEwmQlxOGi6x5q4Pezi94l7Gi1n9W7qQRg?=
 =?us-ascii?Q?8/MSZlzAr2sRPSWw7XKh+3coBpfMZq6QhZiyWvqpZ80feDPkGQJSxCktf7mV?=
 =?us-ascii?Q?z0zN+vkSbMeDwdgYkD9bb7HHrGTkjEeLkgDmpL+xeocrmllqkw22NRGoawg7?=
 =?us-ascii?Q?R5XsSQMGlf6cPUBCr4mBaVb/f+DpGu/apGvkQADzUrjtLB+x3QmiUkP9zCU5?=
 =?us-ascii?Q?sR2JjJv8Bxko2UTgWERjcc3HL13jnwfTjNKTmudfY90LCRzLdE8kr24SAO0M?=
 =?us-ascii?Q?ojlWPZNlS7ad3da5DkdkxoiVmvJmTx8zOcblTvJAKMIkefbpk1cZSElz8/p8?=
 =?us-ascii?Q?JpMZcUjPBuyJbWLlBsW17Wy2yA1qQkksoXzDVeGUR4LqCnKab7ct37+xRdbd?=
 =?us-ascii?Q?TFjXHIp9yUOLX7sez4C7I7UhItM4Tw9R+Iab5jwSojOm1s2Roge1Wfxu26Pb?=
 =?us-ascii?Q?EdX4KECC/7gtrYJFpcE5+n8nmN/0x2u+TyJY1IHa/4c2pOZWJ/nVU7JeHscH?=
 =?us-ascii?Q?F+ExNXdR4kYpN8Zpr3B9wSzbHMyLzDwpRkCn33yQI5PR+PCsf/23ochtYoEZ?=
 =?us-ascii?Q?Uz3ZE95sV2ktvgdgezU4OTPCXEADo88laG6E5/YDnNqJIfM8GYf/iZ61Dfau?=
 =?us-ascii?Q?scWh0J0XP5O/sx04AUrFk9KMQBNfrJNAjX8tD/kw0SficPEYEy0QmWHJvzjL?=
 =?us-ascii?Q?QKJbpRniKzDt0C57Vz8xAaSIY+YmeC8uJV/FXtp715Yr8De9dzlGxk+L68pm?=
 =?us-ascii?Q?4chZMpdvYahSFNQkf7jjQ8msnywJSaFFIEIRGJGoT226YbVHcq0L1Vz3vTDB?=
 =?us-ascii?Q?jXq1VlL5LPJYNgbsQ4UWa71C/wq0KESNBF/7?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:41:15.8955
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd505f88-373d-4a59-8331-08dd71121ca5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8958

With all the pieces in place now, enable Secure AVIC in Secure
AVIC Control MSR. Any access to x2APIC MSRs are emulated by
the hypervisor before Secure AVIC is enabled in the control MSR.
Post Secure AVIC enablement, all x2APIC MSR accesses (whether
accelerated by AVIC hardware or trapped as VC exception) operate
on vCPU's APIC backing page.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:
 - Move MSR_AMD64_SECURE_AVIC_EN* macros to this patch.

 arch/x86/include/asm/msr-index.h    | 2 ++
 arch/x86/kernel/apic/x2apic_savic.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 28cec4460918..16745040f5f8 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -690,6 +690,8 @@
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
 #define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
+#define MSR_AMD64_SECURE_AVIC_EN_BIT	0
+#define MSR_AMD64_SECURE_AVIC_EN	BIT_ULL(MSR_AMD64_SECURE_AVIC_EN_BIT)
 #define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT 1
 #define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI BIT_ULL(MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 8cfffdc4cf8b..5b6fd08f2c2e 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -379,7 +379,7 @@ static void x2apic_savic_setup(void)
 	ret = savic_register_gpa(gpa);
 	if (ret != ES_OK)
 		snp_abort();
-	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_EN | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int x2apic_savic_probe(void)
-- 
2.34.1


