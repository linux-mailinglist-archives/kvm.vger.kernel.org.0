Return-Path: <kvm+bounces-48817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD0CAD414A
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DCA187AB3BB
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21DEE246769;
	Tue, 10 Jun 2025 17:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2mACMpod"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3E424466A;
	Tue, 10 Jun 2025 17:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578111; cv=fail; b=qPjRPXP+0vRhfp1ODTmasfTHToCy6oay9TlrjCDkXI8RPri8xDbrPxZ8clpyeZbqVC/aS8K7f2/bCvrXu+n80+DTF7/8TPh9lDnwWVpWBtnNEbq58WDxkS2SlABsODJcjv17TZ6cC23Iyw219xzalEDPWzf//uK1rfer6rOh2UU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578111; c=relaxed/simple;
	bh=yATbhCd/ZLkM6lpAY6V+PqxDgpjHS0hF9R4N99dTfGw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=khHqRz4iduLBG3vCne2g+eiNn9Z4d2Q6lB6rojg17aqAbqrIpF+3MSMScrxCzE1xd770WDOm/xRNodPgnRjlPHz3Z94qFwwp/gryMgU2DyKrj2Vh5u/d/8PtHjyjraJ+TD0AQpRxjn3HU6UlYVRC+3pYhemaWXqqMgNqi9n74OI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2mACMpod; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GU883FEJCsGr46hQVSkBolBcd8wWqg78qOPseTySllQz5VNteSkGkrd3nsQSUfcztzw/vn+tn+xcmhcg3t6ykEMpiOrutIR1UK2JhDdjRddTM1d7yLAunU4HXb9NOybC6RcDjfX4McAA7GExs8Up/aD0DrJtA553dVdXMA9/7gegaT2wOOdvUvk+HC02+QJ74cykoPSiXxM8bQzTCMNgP/8mD5r41QI07LQZgohu4bWXDFz5tOL4Ra01FRxa3RWLY8hHvVUSLfjVKYB90hVQfKcZ1Md4z4FOZRcD1OhRn51Emh05UxxBTIkX3CeBa16gg562Q56BIvbt9X8nBpIHtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VoSLRdJoJNmyByas8PvisEHRTSqbX1CxmP84uyARPF8=;
 b=BAh5Hhl/8xqsgwxDIML7Q8YdAWDrhDOdypHT3epkHab9xHyuMORuu/dENP5SlfDcPci3iGdAiq/sFbw+RMeskT/suwqlW5ySxIOGlFZIim6IfqHJEplxn8IEN0GJ8yh8XzMVBir/i0L7pcNBSgQxN6mEc8OIhaASUcJJUrH3O4OV04ndOAXcvCtOYsQ7ZpQQ7tKmihWH6MgUnvtgLvrfuqy9wv98IXuxjSEqhH8u1yynu3rY0l3NTdLb1O+rPuE9UeaXGnqpEQKPT/Xney6KWBCgLRyhRBoXjmy6QBQ9Eo04x0lf27PJLLi/enzKHo1rWEPKS+Z9AOtbh6ZW1+GWhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoSLRdJoJNmyByas8PvisEHRTSqbX1CxmP84uyARPF8=;
 b=2mACMpodv3I4sRdNG2ktgJGn+kAopa0ntEoDg+QjetTYV5AkxXgDBXXvWEwM1qNyGo9R2BpgIPncfer3WUT+77kkkNnEmF4o1T8QiFXFKc6U8Ecuscoy0pESVr8HYQ8NH3PA+MN1Nn7bktYtuLvHSLYBiy5WZL5ji7boiqnCLZ4=
Received: from BN9PR03CA0303.namprd03.prod.outlook.com (2603:10b6:408:112::8)
 by DM6PR12MB4108.namprd12.prod.outlook.com (2603:10b6:5:220::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Tue, 10 Jun
 2025 17:55:05 +0000
Received: from BN1PEPF0000468B.namprd05.prod.outlook.com
 (2603:10b6:408:112:cafe::d0) by BN9PR03CA0303.outlook.office365.com
 (2603:10b6:408:112::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Tue,
 10 Jun 2025 17:55:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468B.mail.protection.outlook.com (10.167.243.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:55:04 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:54:57 -0500
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
Subject: [RFC PATCH v7 01/37] KVM: lapic: Remove __apic_test_and_{set|clear}_vector()
Date: Tue, 10 Jun 2025 23:23:48 +0530
Message-ID: <20250610175424.209796-2-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468B:EE_|DM6PR12MB4108:EE_
X-MS-Office365-Filtering-Correlation-Id: 9792f7f9-187f-48cb-4363-08dda847ee0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4iMSk5sW8La7hNelfK+0LWsp1f8NsdfF/BtYXrgL+VwK15WV9XaXr7Mle2om?=
 =?us-ascii?Q?5CmsJ35MLxXR8+6HB+bhITQTlyTz39ng9OGW5MxeAO9enRWn+dt6/P7/4euD?=
 =?us-ascii?Q?o7VR/49EMGg/DqVl2ZzyadFqqQhUY6ayQumscSq74Zf/GhACWMWD1gp1Gqhn?=
 =?us-ascii?Q?GzxInPipr200n+5GBWO20xH73cgOCzBTJvKgx/bne747AlOdEdziO6Pva3Hs?=
 =?us-ascii?Q?GU4twfFCYXBddv2qJIkzkX8ZSG65iJS2GYKZUI7rQCAdMjP6v7wNjyq/Yc6O?=
 =?us-ascii?Q?BscdJ2ddsOTjOFE47MevKaDEIIh7ny1Ate1/iKB0x1y10vO0b5FXjnACrUv4?=
 =?us-ascii?Q?N93KU1aN3MRyjKo6nBI9MzT1y/kqkcQ2yQ6/dieF3etV2d/WKOdyALUEghNw?=
 =?us-ascii?Q?cVI8KZO7CN3vKdDgFgF62nbutcntYz/fuixvHZBiz3cE9KLEZs+CftKsMqxn?=
 =?us-ascii?Q?HBk4Z2cUI4FUgHZKst0Ha7H9VquQXpmdR/RlIgxfvpC6zaoLMPYfv260gNNb?=
 =?us-ascii?Q?5jz+idd7jwmPiLcqyFPfo11wtfVTCUipcuKQ5slcKbvVlOiDGpLIJg1D6GOY?=
 =?us-ascii?Q?zu06y5Af1aZA5aCGyCkoKPMMU5zG6ojVpjmMvund4R+UWgeU22XpxTds1AnX?=
 =?us-ascii?Q?t2IIJ2U0XXrLHjEBSduARHgTNoTwZRtM4pEn9zoLBORYFtgEXaYNw/qfCRNc?=
 =?us-ascii?Q?nk1YxW0sPq/J5cjKRj2ch8p8BoiGvbG/ot4M5BXheeXoZQxWoHRY6xFtsLxI?=
 =?us-ascii?Q?YcaRWyZCQQ4WUPl2Yet4jGwyV3Ibv9IgRXpdgi2LLp32ayVMfkiHRqbXa+3n?=
 =?us-ascii?Q?OqPWT80QnUDpRCB6scapMrveWr/lpuImta1w/um80P5xoL7HPhzfs41a5w6u?=
 =?us-ascii?Q?a+MDD3Rk7cmoLGC0Qbw/NpBR6aMQ4t3Lltj5iBOV7TiW3yKSNVBODKuuACKY?=
 =?us-ascii?Q?6MzdwzUbRIT7fe8OssIQ1x6eBKt2C6FeVy4fmrmJghi53ZLt4HrdS7ryoLpV?=
 =?us-ascii?Q?FszNbKfxeC+JAAf3XxkrJTGLfoAMBXsi7hTl323zuS0eSr0dAgoSUDJamKQL?=
 =?us-ascii?Q?7me8UB9QvVYMuE5nT2OsBv4JT5y/EOLgr6dJRIsXcnJqnk3Y5yhD6+Jp7q4i?=
 =?us-ascii?Q?kB2bwnQRlvFhAKVHl2WvWng1zbeUmWZ6TCSQk83nMsOqsZ0r9Hle7vF+IrFo?=
 =?us-ascii?Q?Xc1aGogwJyO3UpfwkXXQLxVvb1xtNVOZMCU94aZXD0nUsplx1Dz+Yhkhkq6E?=
 =?us-ascii?Q?qYbYsEvi13YDEzMCEpqPTkRU2f2vHhlIgZqCVBOkMcRJHLQ1eqnAphYzb7IW?=
 =?us-ascii?Q?CQwKz5H+JSy9rlY86uOU1MR5O335FpWxU6e0j06KLCwGDMwBaQ5d3EtTHFiS?=
 =?us-ascii?Q?UAW/eh19oIeXrfPeJuYWzpoW49br8k2rVuwtVicLI8EL7HamSx1jMq+nrybk?=
 =?us-ascii?Q?KW2XtxgmJykwSDVMV8HymUactUG8j11f21sJrL4zQLbelpShr8Pi/TOtkHEZ?=
 =?us-ascii?Q?DDjokitSJjguwugUV2YmYDh+6jpE+ousTp7m?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:55:04.5844
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9792f7f9-187f-48cb-4363-08dda847ee0a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4108

Remove __apic_test_and_set_vector() and __apic_test_and_clear_vector(),
because the _only_ register that's safe to modify with a non-atomic
operation is ISR, because KVM isn't running the vCPU, i.e. hardware can't
service an IRQ or process an EOI for the relevant (virtual) APIC.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
[Neeraj: Add "inline" for apic_vector_to_isr()]
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - New change.

 arch/x86/kvm/lapic.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 73418dc0ebb2..11e57f351ce5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -125,16 +125,6 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
 		apic_test_vector(vector, apic->regs + APIC_IRR);
 }
 
-static inline int __apic_test_and_set_vector(int vec, void *bitmap)
-{
-	return __test_and_set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
-}
-
-static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
-{
-	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
-}
-
 __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
 EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
 
@@ -744,9 +734,14 @@ void kvm_apic_clear_irr(struct kvm_vcpu *vcpu, int vec)
 }
 EXPORT_SYMBOL_GPL(kvm_apic_clear_irr);
 
+static inline void *apic_vector_to_isr(int vec, struct kvm_lapic *apic)
+{
+	return apic->regs + APIC_ISR + REG_POS(vec);
+}
+
 static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 {
-	if (__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
+	if (__test_and_set_bit(VEC_POS(vec), apic_vector_to_isr(vec, apic)))
 		return;
 
 	/*
@@ -789,7 +784,7 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 
 static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 {
-	if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
+	if (!__test_and_clear_bit(VEC_POS(vec), apic_vector_to_isr(vec, apic)))
 		return;
 
 	/*
-- 
2.34.1


