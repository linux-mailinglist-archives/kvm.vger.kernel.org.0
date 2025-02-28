Return-Path: <kvm+bounces-39672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D4FDAA49462
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:05:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69ED67A93B1
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DAA254B1B;
	Fri, 28 Feb 2025 09:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fWusdhJn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E761A3158;
	Fri, 28 Feb 2025 09:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740733539; cv=fail; b=QTb3twE6VihM7wdz5yOj1OMCt1c1X1rPzfjXYdQz6hlvlBZh6tisIieyZAWxoSKhqNoPeD7pnh2Q+U5fuRRCTwmdAVuvhUlz1eXRvBcowdgJsMIFJ3ASVnftMJvY7Zkztp5SAUZa816kgL6ueadr7YNKkZGUCHcmFa83HEXio2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740733539; c=relaxed/simple;
	bh=wxBTtctkNjQKsWhRKcF1wiTiYFKho3rHZxel+hz+03o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C7xjGAj8/OZO+ZYbcbPC461GNoi2gQshwflRP+OjAICuEsRq7qghLXhkFdondKBNO/G1GajQzNAfcW1103yT+RowrxMVizAS5H05w0q4DsqS0vW3hqw+1ism5NXZICSioHQyvZ92Gv2qHgSNjwtm+ipsYmCg9V6vzidxGQ8z4/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fWusdhJn; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yv7vrRz7VW0emM6/NPhrAh9bpwJpTMjOCa2lnPBQVqMHUp3oYFvLPtx483+MOedKzGjSXlZgnfR2w6M/tPyWb0roXcUO6WaJUrdyBSmuOqE+F8/3tmt/A98FL2CnW/gT4hDzgQux6OHxesoNIPIuaYlAzngYdo1+9CxBiW2XoEQxmEAqU99jTYQCnEx0OlVNckVkoPmUvuih1rN3DrCkErstaii+yy0rYfXbsqgMKk/LfEC+cG5tzSlSu3zsh7gZBwCUD5lDgvUKRSy6nzEQVCIil36RwANMEVHJlgh4gw6PuYaUdw3NbDN1+Zv4vugLnrcQJg7NYOn9RPx8Djywpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bS+PZC3EUTudMMth3fF3meGGM8HntlMe2BYSCcNsc3g=;
 b=zBmjY00B+tvLNcVx5dvo6xy6SFr4SbBN2HCLpK9jJUvFIzn8a/vd+dJfBAQgUOHnxaRW02ye9+PmrpkVs1QH00gRlQMzEjcK5qU42qPxlF0aS0pQ+HVe2A/DjmapOU96Kah8mNWljC78fhn5OnDIbVaSVc3lRXDr/bUKkCZEyg/88eDgDXp08HvWdHsgck8iz91XfMqjYWNbtoH/KgNBYAgzlhTF7H2eXqweITVWHluTg6JoPyaa1sYqNR4z18WKI3/1y6GppUi8ccbFIkIEq5aGEPL2gEoESmT0hWUvToM6sgh4Feianq3946WjEs2qV2TCF+giSoPpxYOHoaGwEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bS+PZC3EUTudMMth3fF3meGGM8HntlMe2BYSCcNsc3g=;
 b=fWusdhJnXB1IaBoTfPaGvyzKHrjiGzU6nkqpVz16nFbVlZ0d4xvP4NyLvvvrL1VMoPjcNOmo6F/X8NMvLDXNbLdZcrui4LXLanp/wSkFb4WIFvJwnKz/zMgxOarw0vEazPeHvcjNR/o3C45aIVpguRoOsEDZxM1Kv8eyzdKY2ao=
Received: from MW2PR16CA0009.namprd16.prod.outlook.com (2603:10b6:907::22) by
 IA0PPF04DCE520E.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.23; Fri, 28 Feb
 2025 09:05:35 +0000
Received: from SJ1PEPF000023D0.namprd02.prod.outlook.com
 (2603:10b6:907:0:cafe::f1) by MW2PR16CA0009.outlook.office365.com
 (2603:10b6:907::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.20 via Frontend Transport; Fri,
 28 Feb 2025 09:05:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D0.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:05:35 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:04:09 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 07/19] KVM: SEV: Do not intercept SECURE_AVIC_CONTROL MSR
Date: Fri, 28 Feb 2025 14:21:03 +0530
Message-ID: <20250228085115.105648-8-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
References: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D0:EE_|IA0PPF04DCE520E:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b94958c-a917-4ebb-b27b-08dd57d70fef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bzJwbgdZ0m7dxfAbx0xIfRaeu0Z/PTPNBdpmS2h4TQzWbfcPw+yckPjzrZ5a?=
 =?us-ascii?Q?IoR7pth+XkkZpmf5ncKtI5BDjs6PZKaKKYUt+FdwrOzEQGFL61TZqTAJJlnl?=
 =?us-ascii?Q?9nBoGn+IgyvxzU4xX1kK5aFzK92FJENZ3gMXtnrYqDhqH9S5dmywBI9nstnn?=
 =?us-ascii?Q?1Zr0t51Ew/ZzlbMk/KMomAueDGbcfp45hy3Py2WAtwz771a66hAyyVo4lLSw?=
 =?us-ascii?Q?5+hlyUWSWGUBoV9GgeTzVN83ZU67a8WxWJXA0rUSX3Q8wNxGi+WusYlvtYpz?=
 =?us-ascii?Q?67mAq+xfyldcJy2H6R95Bs8ux2BgjhHAHCNqtfJVn5i4FV2CjOnMATxgT+VV?=
 =?us-ascii?Q?g0nte12T8ANP9Bq2sx0ykIdZo5bnkkGUj1arb8DPQ1bHDLr81t0C78IgS4rl?=
 =?us-ascii?Q?Da7tWXuiRxEdtJP4DOyGISlQJvmzPAaR/7QZa9UPWKPlRJ6ZlpIy/zSmY5li?=
 =?us-ascii?Q?Qu1czt3iwwKsr8hs+xvIzScQPCz3yHJLpEeJwAY3xD7mCAFKgoBtZu9q9igR?=
 =?us-ascii?Q?vN48D7FE246kIAoPSadyplOQQEmOEJpdzopEiLO0RJ1nEXcOQYR1xb9GS9pD?=
 =?us-ascii?Q?e/uuUye2VxuSzT+qkD90SYx78LXgf8j9Pa+I+rQpXX0WdNS+1G0dRD6Q/kGz?=
 =?us-ascii?Q?97mlnywzJXZElSoZ1X1hUB2ioTwN88IcuhCoD2wDtKSYEeGAzjsyoQ0eLyXW?=
 =?us-ascii?Q?RV/XWxC2I3LYUf0SIVAwbblyTbE8no/RoqOqGwMXGe5WRw74HxgY9VYfhNHF?=
 =?us-ascii?Q?VUvuyjJCBzmf3v7jFpoqledbEVdeMyJuCNVZSGvY3sKXnDi/cN84g69XARuN?=
 =?us-ascii?Q?wftv6kEqolOndxVoW8SU4HVGmOod9kvdsWC5wTrDaPJHkX7meYu4xJmWYI0g?=
 =?us-ascii?Q?P4pEZ+zbJ4VNdCn/QqrC7fqknjTuJSdkHdiCZYqJ3LxYDrct6BRqgyTExphl?=
 =?us-ascii?Q?T/lsqKLKH/0mo7/uqNP/WUzsoWftmgwSunFBany3ITEE2L9fiGHt9nwzHMvq?=
 =?us-ascii?Q?EBL5oMn6r9qnv709HlusaAwvWUgfCANJ5ZP/4JSPGBOW6Q3smW7cd5Y5xckx?=
 =?us-ascii?Q?uBtuOCUUbPyAg4CFOcWZ8iWN9hh5VRs2lDQzjdygOQDycNapW8vbHA8FKP1q?=
 =?us-ascii?Q?tVEYULm3GhJruYm2l6gVvenpt91e9b8FPxcwnf3QRVw/eDcPhHNdwZ+GIWa+?=
 =?us-ascii?Q?XDz+ow67LIQ39J5ziqpi1Mnru5qMxNxTtxyreRQXnNsGyyu9uF/IDmI3jRFs?=
 =?us-ascii?Q?43Kk4CUkmZZYD9ReoMGVmbJ1OLAB87MmYX7BonuFzyswlovIKW27so6BI1p0?=
 =?us-ascii?Q?PX1WgsJ1ILbna1iKXvpibeKbvhmJO6fbgFgXT/b/DWlUWTP9sO/nA7T2+wbW?=
 =?us-ascii?Q?krw5jjiL0FV7J9RPVZxfMORUR1C6DHSXJMYuBmZnOVrgslADn+EnmgWEt7ED?=
 =?us-ascii?Q?ffjvG8LQva3Nl+xN8N5KLtl1yOoCJVRKZEGxbFnOHqVJouZjbZ/yS1ZeNcPv?=
 =?us-ascii?Q?Iw1a9OYLOF+jW1c=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:05:35.1555
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b94958c-a917-4ebb-b27b-08dd57d70fef
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF04DCE520E

From: Kishon Vijay Abraham I <kvijayab@amd.com>

The SECURE_AVIC_CONTROL MSR (0xc0010138) holds the GPA of the APIC
backing page and bitfields to enable Secure AVIC and NMI. This MSR
is populated by the guest and the hypervisor should not intercept it
so that the guest can properly set the MSR. Disable intercepting the
SECURE_AVIC_CONTROL MSR for Secure AVIC enabled guests.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Co-developed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/asm/msr-index.h | 2 ++
 arch/x86/kvm/svm/sev.c           | 3 +++
 arch/x86/kvm/svm/svm.c           | 1 +
 arch/x86/kvm/svm/svm.h           | 2 +-
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3ae84c3b8e6d..6fb734228726 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -683,6 +683,8 @@
 #define MSR_AMD64_SNP_RESV_BIT		18
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
 
+#define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
+
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
 #define MSR_AMD64_RMP_BASE		0xc0010132
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 82209cd56ec6..6313679a65b8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4573,6 +4573,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	/* Clear intercepts on selected MSRs */
 	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
+
+	if (sev_savic_active(vcpu->kvm))
+		set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_SECURE_AVIC_CONTROL, 1, 1);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d4191c0a0133..d00ae58c0b0a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -110,6 +110,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_EFER,				.always = false },
 	{ .index = MSR_IA32_CR_PAT,			.always = false },
 	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = true  },
+	{ .index = MSR_AMD64_SECURE_AVIC_CONTROL,	.always = false },
 	{ .index = MSR_TSC_AUX,				.always = false },
 	{ .index = X2APIC_MSR(APIC_ID),			.always = false },
 	{ .index = X2APIC_MSR(APIC_LVR),		.always = false },
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7cde221e477e..e855f101e60f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -44,7 +44,7 @@ static inline struct page *__sme_pa_to_page(unsigned long pa)
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	48
+#define MAX_DIRECT_ACCESS_MSRS	49
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.34.1


