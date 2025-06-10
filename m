Return-Path: <kvm+bounces-48825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FD8FAD415D
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:59:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43E90189E27B
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228F8248873;
	Tue, 10 Jun 2025 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ufaZ5Je6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5E224679B;
	Tue, 10 Jun 2025 17:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578283; cv=fail; b=LsYfJc3bPOOIhd85X0f2HnLPcvKUvc1Ha73RZYRL3VGhmL+TJO5eH0UlmfuCvZvs322vcdhdQR6pFvX9/fRRORfc/L/dSVDanIR8S6IQPztIklHyuSB0Vq/aCgO/dfmlmiNxlSCHcATBrJitiJRPx/rMtav+TpbpXy5wH7YCL6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578283; c=relaxed/simple;
	bh=CouRq8xg8dAWpBSQm6xg4SVY6DbEhlsNFmico6JivzU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HspRduZHHz1a4F5hMEVD0Q+Ku7U4N9jaky4V6RoOPmWHK8TDrgMFJnfoUeyB6Er65Ynt7gfFrDo5Yfyxkt+NZUp1YlBuHNb54rs3olOjyQKg9IWSl5mLZhKm9eeywxBmgYy1ynd4+5g5tm1gTCa2reMDPmJRo3LP9njJ/7QKZo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ufaZ5Je6; arc=fail smtp.client-ip=40.107.243.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V90768uBFw/k4dsfQfhDb89vxnr7mK7agBi1xBsVBF0m0vFiY/95et+08HdJJYTdc9xFNJ5s4AH3r5a+w2XGNaHs5GIxNIAWpOo5OOBPJCaofpanJf/auO1pjFGpFhLtPEhbFt599nqJ1P4QWcCmKGE44Sog8M/fXewiTL1kvxV4ppbnC2OdBde/WROn9JerrGh7rYOFYZeo2h4dEoKJ7e5LrFoMjHR94NgBs7xmyO/5qes+x/qds2vrfJdL2tFUYyCYAZVGf2Y+KYwtHHHIfieLAd8/wHdnXE/4T0vKZ5AyIlC6FTM0nPMzawaT9pIqitLQA59mG8SoXc/cBPQ78Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SiOCuWICGdZmO/pPK+HhqZKoxzutHUbrJgF8LuDyl90=;
 b=YD21tRwcUPfkY5epof90r1IqtbZckHTVviLFbb7AfUX4kMtD/sr1uGQbYlwr33t7CCHMyVU2MkvjgHj0D6s0DdsyJf+npq2+0mELJKtXmV9LVFtyAo5cJ+Z4rBurLgL62J+BuajMwIvynY3khwZ99okikK41gFiVyE/ztxgQqCyNGUJULc7XXF/qL5h4UiI1l8k3r6TJ62yjWjuyntP9daiAZkvNqu04++KzkIrLbp9QVAgQud2MoF348MEcKVIBSxtO9Z+PZr6C/oZNzyJmRyd2pZ4UW23weNxiAQLRf/ZAz0Q7roQZ8Ij2vHZU+H6ck28l/fU61pynFNJnzSx6zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiOCuWICGdZmO/pPK+HhqZKoxzutHUbrJgF8LuDyl90=;
 b=ufaZ5Je6UwOKpGyLQaPgXq9hQpL/thp/0cUNbz/MDfrO4QIX84m59ouwHzczG83WHG9XWbp7egYsBjG5THAfyTTevwozqyJPSesdN5LAsuO9yx46z8cZE/BFJybhM3bay6JbjzeSyapfxm9/i4199szPGarH0kiie6JnvyWoeug=
Received: from CH2PR03CA0006.namprd03.prod.outlook.com (2603:10b6:610:59::16)
 by BN3PR12MB9594.namprd12.prod.outlook.com (2603:10b6:408:2cb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.41; Tue, 10 Jun
 2025 17:57:58 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:59:cafe::a1) by CH2PR03CA0006.outlook.office365.com
 (2603:10b6:610:59::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Tue,
 10 Jun 2025 17:57:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:57:58 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:57:50 -0500
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
Subject: [RFC PATCH v7 09/37] KVM: lapic: Rename lapic set/clear vector helpers
Date: Tue, 10 Jun 2025 23:23:56 +0530
Message-ID: <20250610175424.209796-10-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|BN3PR12MB9594:EE_
X-MS-Office365-Filtering-Correlation-Id: bb8e4c76-5ea5-4b2a-80e0-08dda84855da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1dgT/IFyQ+p2DBRoMrVtOxH/9i1p9jnmnjy+F/nPS0uM+JTFPLqdRBBTmOdL?=
 =?us-ascii?Q?2G9lmZCv463W69CIWDNT3NfLNsX362dSSFmoF/uM4RCYShH6tOf9BC5HxMdc?=
 =?us-ascii?Q?JeHFtYUO5v0J7wRArvAG/8Ab8QR3GCWQ/vBLJlHg8f1ijLHL/Io55BNy8ZNV?=
 =?us-ascii?Q?/XZZB3yGqRBk5u+EqkK99aw6+okPByD9x0StirQ8KlfPXEzsB2Fp8UN1PaXy?=
 =?us-ascii?Q?JIZQ50p5ZZ8/hZ9tVHTTQpFiRqc/6zZD9elhlriYJTfUP7b40ZsAnc8EFwpO?=
 =?us-ascii?Q?bJBRU1wMG4RNEuSVJ6GjH0OLzFiL80PWr97TI5i2YDR5GE0VRc/30sSJ9VZq?=
 =?us-ascii?Q?dCmuOUEDzVRnLgVPJS0xE6DnLbux6NoKwakdewhu7Ubdht1OK8qeGIH10RZE?=
 =?us-ascii?Q?/WU8r2M+aOPTWzKSB8vT0K9FyAfe7tqiUSzMlG+xReHBnpzwwK8mZU09Lz10?=
 =?us-ascii?Q?vv7enyrgbLARn5sI9i0SW0/fCiHM/WvdljZqodSIrF+O73DCX9Z6/kSNZkxM?=
 =?us-ascii?Q?oRXlWWm/RTSOBK6bffPKrz1ZgMSOZOoW8FhovQE4j4jEJIaT7TtkZmIOLFr2?=
 =?us-ascii?Q?uoCQ9A2dCdCclS/3AYP+azWEpb9MVh+vXkjow6awJWwvasqPEb8G1/cD7C69?=
 =?us-ascii?Q?yXmipM/SE6mhn7Y8foGmGVtWUEgM9aHSkVZNO7jESaXz7rMfaKVJRtxFi5F2?=
 =?us-ascii?Q?ZOhOIRoRSoqRtxuVB5F+POZF+AFT0sEHgph9vC6EoQ7+vFgtuPcseGMKIHu6?=
 =?us-ascii?Q?IzW3ForNsa+r9ExKQNfBD49toSpwyAvYNPhJxbr02lGyfxxVOo1q7nx8kTCB?=
 =?us-ascii?Q?ORZuT4WQOxrd5As0qi/nZqRB97D3GwYGVnL9a9DJLv15gwajffIcsmPIMPbu?=
 =?us-ascii?Q?Z/eg3EUX+28CVE5AhUmUHX5tpq3Hr5/Trv8P1u1yW3q9Ikr8GrDS26q3wZqr?=
 =?us-ascii?Q?HffOfj6nIYV30MYxrOwaCf49wtL7Rql/ikCLEdpnLw6tKZukdo+ubPca6ixP?=
 =?us-ascii?Q?GEtuQC7nwST0k7J8t0SvyAR0Y6+DirABxkf5f66CAwMhPcE+ReZlZYBx9xZv?=
 =?us-ascii?Q?77+2awR+S4TYK6b8w4nM1Re8pl+dmySsHbnmEjHg2uUQ387yXcFsbWJvNezZ?=
 =?us-ascii?Q?DlWpbRlZXruKo2pAjbsC52y7vusR1Hdf2/AO8u3yZRSK1+MMIYUrm4phjPim?=
 =?us-ascii?Q?j+hzJ5deQyR0ZkhiuUMaDJTxvYk1fWl2cVbmCMYN/YiYNMZUAZe4pZmqk3Cs?=
 =?us-ascii?Q?8s0zd0uXhnZv+pTp62WxH5W/Mq9dLji5AN2NNkGNZkX5O4ixjRcBGAqnJPqn?=
 =?us-ascii?Q?YX4C2NkDZs/G2LJwVkVuSyW+ErW8fURQB3tCVJfrm1aZs34+wHNU/uW62zvs?=
 =?us-ascii?Q?IH/dGDVgJhdv8CBtmmlRgGkkp3eTuwf6pE/eGEvisu++NaWl1q5W2lPm+Ttc?=
 =?us-ascii?Q?aMOlUswhuXnUMuJgOyiOFpWxwNOwle+ySF6Jqsmazj2qkzN9Ak65YowJIa6P?=
 =?us-ascii?Q?SC4axXDnKWRDryzLWcEXSFphFbI95GbIqFAf?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:57:58.7411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8e4c76-5ea5-4b2a-80e0-08dda84855da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9594

In preparation for moving kvm-internal kvm_lapic_set_vector(),
kvm_lapic_clear_vector() to apic.h for use in Secure AVIC apic driver,
rename them to signify that they are part of apic api.

While at it, cleanup line wrap in __apic_accept_irq().

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - New change.

 arch/x86/kvm/lapic.c | 10 ++++------
 arch/x86/kvm/lapic.h |  6 +++---
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e5366548e549..20e2ceb965b7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -718,10 +718,10 @@ static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 {
 	if (unlikely(apic->apicv_active)) {
-		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
+		apic_clear_vector(vec, apic->regs + APIC_IRR);
 	} else {
 		apic->irr_pending = false;
-		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
+		apic_clear_vector(vec, apic->regs + APIC_IRR);
 		if (apic_search_irr(apic) != -1)
 			apic->irr_pending = true;
 	}
@@ -1326,11 +1326,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 
 		if (apic_test_vector(vector, apic->regs + APIC_TMR) != !!trig_mode) {
 			if (trig_mode)
-				kvm_lapic_set_vector(vector,
-						     apic->regs + APIC_TMR);
+				apic_set_vector(vector, apic->regs + APIC_TMR);
 			else
-				kvm_lapic_clear_vector(vector,
-						       apic->regs + APIC_TMR);
+				apic_clear_vector(vector, apic->regs + APIC_TMR);
 		}
 
 		kvm_x86_call(deliver_interrupt)(apic, delivery_mode,
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index a49e4c21db35..c7babae8af83 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -145,19 +145,19 @@ void kvm_lapic_exit(void);
 
 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
 
-static inline void kvm_lapic_clear_vector(int vec, void *bitmap)
+static inline void apic_clear_vector(int vec, void *bitmap)
 {
 	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
-static inline void kvm_lapic_set_vector(int vec, void *bitmap)
+static inline void apic_set_vector(int vec, void *bitmap)
 {
 	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
 static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 {
-	kvm_lapic_set_vector(vec, apic->regs + APIC_IRR);
+	apic_set_vector(vec, apic->regs + APIC_IRR);
 	/*
 	 * irr_pending must be true if any interrupt is pending; set it after
 	 * APIC_IRR to avoid race with apic_clear_irr
-- 
2.34.1


