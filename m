Return-Path: <kvm+bounces-54404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4C46B20484
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:54:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6605F3A7233
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70690239E69;
	Mon, 11 Aug 2025 09:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2G71mila"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022312253F9;
	Mon, 11 Aug 2025 09:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905850; cv=fail; b=SzVj+QjGZCAkQCTwbau071eHrXedLJ7fPwhjwQPo2Vl+SnuO8iRHM1cj3eTl29HoChBYRMY7B2XOhLKnmCeggoQoSJRcX7b3IN+ua0VHD7Mtaj03+pIRehUzyr7ogKxbZM2HKfsgUdEoZTuHCRpuTGY3t6YGvUJc+6WPlXIfSBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905850; c=relaxed/simple;
	bh=XLzyDEkbLW0bJKGJjNPJl9v+gOWFbW6gbhP0pJgvOHI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JZkBJmqa+eV/Qcx1jjTNEDSGfK+X8wkQUNLHITHVPPrKvIKlnqGZS5zElS95opJIc8amerOsrKuiLuGNfSnzRhvqjTORzCN/4mnhDtcPEJwwqNfgzp3wlccf5190souXs0dEEjZATVjyV1cM3QkV+ZIgCinJDLPUNU+nVnkcWbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2G71mila; arc=fail smtp.client-ip=40.107.237.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FP5kVH6istC/p4rUg/eMzZpwxbRb466x3RiXkiQcA7M1zmSy/9TQvYcSvDRYAHweWv2UAtf0hmG0oQpCk5/K4huDszsHDjJHRKCR1dmfo+lzCuR/KLChZhzNaqmTo8SQlwIivNAsxF8w2mJZlqB019BQE/G0g1Vu4Sd+CeJsM8iGHgwj9HzC7yDjO313Nag/IMXETFYseQQTeynl9Qv9fT/NU3yti2YpQHRckSTXaj1ITovLTCHpPnX0XCMjE+j45ZuomrUub4LrkZChkjJ+XhSv4kFtfhujwt4K3cz3fAzqkGyj6ZUp862iCvPTgj0T5bZwUFOHpIK6oQzMYQIxCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fyG6Y09JS0qF837apH9/bUHkBfgXk0zsnu6AvYu+PYc=;
 b=ttOnIDX2VbUetLwKHO9LiNrlG335Xpp04bLIaFPsHDz3a445jF00XsUf7jY5gkuy7FpD1z4WEM4mavppbGC1ZTBpvCXX8Cvi1rpc7iqTLWZsjV/P0sdEoFyB8bdXqEL0MHmydGDX4hjvH6NVquUox4mHQ1xe+CHQp3pl+oLyceIClwmEyFi3sATUtWcmUlr6+wtIf/dtMnK+YXt1bSTvpmSSimMZpoG6jcoJCe4N35n/8u14CxzN1ROqrm4m5WvBRCBbE3/MnFupLfuNV4ZVWnXH9oSzZ0X70Tzi/LcwpHwIjmIRyIIc/749KdZU14EVzKUvGe1lQoofIyEKT0Un+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyG6Y09JS0qF837apH9/bUHkBfgXk0zsnu6AvYu+PYc=;
 b=2G71milaxqspaxLliZnnzBMGaGyujDac/842gBK9bJUp/y7+6vxnw9/mYVFByImCjGOVUHTa0+p2GniDP7YcoO1FS2hrnZMUNmOkZWTUXSiS4PyF+rzkrddxekaTYCid0kNCw0Eq6uA5fljk/ivjnKEkZ8/Y2Rsqj1+HoKeLSLk=
Received: from BYAPR02CA0031.namprd02.prod.outlook.com (2603:10b6:a02:ee::44)
 by SA1PR12MB7366.namprd12.prod.outlook.com (2603:10b6:806:2b3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Mon, 11 Aug
 2025 09:50:42 +0000
Received: from SJ1PEPF000023D0.namprd02.prod.outlook.com
 (2603:10b6:a02:ee:cafe::6f) by BYAPR02CA0031.outlook.office365.com
 (2603:10b6:a02:ee::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:50:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D0.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:50:42 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:50:35 -0500
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
Subject: [PATCH v9 16/18] x86/apic: Enable Secure AVIC in Control MSR
Date: Mon, 11 Aug 2025 15:14:42 +0530
Message-ID: <20250811094444.203161-17-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D0:EE_|SA1PR12MB7366:EE_
X-MS-Office365-Filtering-Correlation-Id: 221af5d9-d494-4c31-f7a7-08ddd8bc8975
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9wv/BDPHm3c9F4lVV2U1TsSlP9sqC3gd+9cnGLpWEiFGRfxVg/6syZt8HSrr?=
 =?us-ascii?Q?jF6XsiJOr9mIc91nMbXmQplI2gaxipO1xumeLSCG+HhiFc4fb5Uq+1EQldRJ?=
 =?us-ascii?Q?P/w38u1Lspf9hzTUAEgAtEvNv6gmBugcKZ5EWYcahMblduabx+wMWLiMHx5S?=
 =?us-ascii?Q?KgPCyAss7aD8Vw4zHV1+K/hbv5msH816+WiVGg6fuup84syQCrrIV0MCZtpe?=
 =?us-ascii?Q?ZEHA0eJQ8NqUIZD3MKcA8sFSRzR7OZYnvcoq1QXmNgjVOTipqWqtO28l1DqH?=
 =?us-ascii?Q?vp57YIh5dLzltSv/VxWnXcx1ePHgWxVzCbf5Go/CfM1dvbe7W6Bxo/N+0GOx?=
 =?us-ascii?Q?oFGwlC55mbq9V+aOgE2KrRKfnPD2bbRPy1NfVRXKUuGeXfF59GyecWfBitRp?=
 =?us-ascii?Q?6ZQHDMSsEYK339Y2gF2z0JN61BDaBQRdRpYW2QIpDpSXU3Vi2CDrBS2bX8CA?=
 =?us-ascii?Q?N5MSjRGgmmbfECdz/3CGeZ316Jk6+iM1mpf/5AZKxsu4XHUHgCqbmU/hf3uO?=
 =?us-ascii?Q?GMUQwLAGwPZ/kXa6L7adJ+SkQfdPyp6xjNblCrVcM9rclEfY9SIf72KXoHC7?=
 =?us-ascii?Q?uzDyiv8nf7Xycf9oXkPl07G4BRSrA3wcLC9tEWsSFoh8sQll1em5duLI2FUN?=
 =?us-ascii?Q?NsTOeTV+l/p38bTCj+L74TkZ/u/wESUh1WNqTWgfyZFTT7CGXXhG9Lcid+ml?=
 =?us-ascii?Q?yTrwmTJv78vgLUj41TLXGpXSn5lfkCFIbKr7wq0oQfWTKM7KceZ2nUwNCY3T?=
 =?us-ascii?Q?dUS891ZHwWaxz1opb8Eq870s3dXwjZxURTKYjkDBHqLl00YTYD8DQqlNk6AT?=
 =?us-ascii?Q?O+X/i/1a790LK4WKw60PnVhnunFlAoCfU7ozBm865gtx4dDiJNvybLPCxTEQ?=
 =?us-ascii?Q?J2ovePXbsxpcd0Y9MfTW4KdvS4z64mhtU2B1R7/iw84blOX1PNcuV/qV/1JY?=
 =?us-ascii?Q?pRKu98uGCsue5ngIIl7qnJ83XFXE8UpvAP8Gad4sQrMF0TzEHbXP2HCq7SY4?=
 =?us-ascii?Q?dbAU2w8YvaLMt379mdDOo63T0JFyVp/he3G5zUaSsXV0Lo2I7Vw7WLl3RDCX?=
 =?us-ascii?Q?ZM0jWHqMQpiYn5304Uj4kRuf2xIlkDPfQS7RvSFV4CjimSpxqaA/D3yjdLcb?=
 =?us-ascii?Q?Vx6XCGsyM1EjaAqzh6oSX8tCeZ0ZA1FCy0s/yfvNREdJIL0cH+mTas150IM0?=
 =?us-ascii?Q?0MzBIQWm/A46avA2ArILQHA+jDtxg6O3bk0tS0DcWrcHI9bWJg4fEnYIE8a4?=
 =?us-ascii?Q?NNbeZlaQh85KUn2Br1bjKt4zwn9mH1AxtGOCX2BYRNfks54gYz6kYHbEhZ1n?=
 =?us-ascii?Q?spxxv0++dyuW5xrjlXeTLy3liwVboMQarFXc00vD7KE6REK32pkyaKYlihi+?=
 =?us-ascii?Q?k3OSfi9Knq556hBw4+pIjVRCZlY02nhID6W8zxf/el1XQbqTcp5KA6dwnJdO?=
 =?us-ascii?Q?E5kt7pwSwiBT5xQ6ZLQhZN2LXdY7eO7nfSoF32Fjm8MXcOTTeOkfUFH1MD3I?=
 =?us-ascii?Q?dcEvNgI8SafBK/AJ8iSvO/ezjjmV+HmptlJ1?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:50:42.6792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 221af5d9-d494-4c31-f7a7-08ddd8bc8975
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7366

With all the pieces in place now, enable Secure AVIC in Secure
AVIC Control MSR. Any access to x2APIC MSRs are emulated by
the hypervisor before Secure AVIC is enabled in the control MSR.
Post Secure AVIC enablement, all x2APIC MSR accesses (whether
accelerated by AVIC hardware or trapped as VC exception) operate
on vCPU's APIC backing page.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - Added Tianyu's Reviewed-by.

 arch/x86/include/asm/msr-index.h    | 2 ++
 arch/x86/kernel/apic/x2apic_savic.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 2efc03d324c0..3d0688af2009 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -704,6 +704,8 @@
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
 #define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
+#define MSR_AMD64_SECURE_AVIC_EN_BIT	0
+#define MSR_AMD64_SECURE_AVIC_EN	BIT_ULL(MSR_AMD64_SECURE_AVIC_EN_BIT)
 #define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT 1
 #define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI BIT_ULL(MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 71775d6d8fbe..e3d8a4302522 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -360,7 +360,7 @@ static void savic_setup(void)
 	res = savic_register_gpa(gpa);
 	if (res != ES_OK)
 		snp_abort();
-	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_EN | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int savic_probe(void)
-- 
2.34.1


