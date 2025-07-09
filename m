Return-Path: <kvm+bounces-51835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9345FAFDE24
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:33:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61E371BC7813
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 250CA1FBEA2;
	Wed,  9 Jul 2025 03:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pzu1C/rT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2000224FA;
	Wed,  9 Jul 2025 03:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032001; cv=fail; b=MGmtbyL0bB8rqGeputh/eha0Gw1TSr6vZZiuUcsDYLh6XeyRc2SObrI4BtrGuug6LVupxx0NSFi7KGLztO20Ls41gT+Z9x6CeGurHEbNsxf+xRC5Xh06S2XTSVYLsX+OKtRzFSuQbGWF0Q4qvMAjU355fC5WZYljY8zMT6GiSjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032001; c=relaxed/simple;
	bh=O2KtX/Iur5DIZ9hdnhuZMv42db8splBeBBHwvMje56U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rZS1qk5RSodhQiFXKmXbVCYpKPSiCKF5yNoWZkZqkqboG304o6Z+EQuHUCNJOjkwmCPfGqy2DEv+xQgFrea4MeM1IB51oJJAS7zKfL65JdARI/rOifuQ25lR+dvjdejMcqHNlQw3bKcbz72OoYq9muN48D/oYYkarWx222+h9qk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pzu1C/rT; arc=fail smtp.client-ip=40.107.244.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uc6wD+QmIrDltOvU0lAFOrOgs3gG3Tbq0BHPLpMH+X2vH5wvRVz/FZhRce2YnnfaHt/jfbF4EF1EDmLszaGW6CZ4W6Z0zg8t8/lfo0VSOjCkJRQ/avmy3IBRNjTVyt/PsyK3NH2Owb8yaloDLG/5TJgcFy/h4MrzGR8ISq9xVEuSE4BENIF/ynk52rgB49HIuRwQIXBRNeOoAX+MZUoUu+9uirHrlkevHsTPgoPdez/dP8xoissZAeDFOofXHfU3ZMmkeJy2S6RJ0E4yLYvbhhz6qB1iwe2nqnzAKgM28/kvofYZt7gpRNalDtS6EHMExv2Ac0fzrXqc9I3xcAA45Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBbEbCdSBq6aqu+ZSNqTQdc6254VALPVQ4Cj6e8I7KE=;
 b=LWcWNIstj7JL6c2AnRG/XKrHLhlimDsbh152eN9VRFWIgw/4dF+UoHOAaQfAxItZZJb/rksk/h6YDgN07z4ptgvf7Qvc/RDZmbQo8oLdkFvOVq913Ha1BjZ9OEFBh/S86AatnIqn6HQyRDhFYM/aO0Lso75YStEUDeqru7WpBUcxbngIED9POe1s5ebtrPbzeQYeC7sfnwpc2HT2vzDR9y9EnkFB/ZgXM/7fgv9nzLSIOGBgYDM1KfojgScvO/ds0UqvPvHxu/e7Ifuo2364ADqgJ3zlKKtR8UP2FQvoUrUxsjqoK3E8fke94YNLWEtwF2az4rf8n4D+tSh3zwVBbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBbEbCdSBq6aqu+ZSNqTQdc6254VALPVQ4Cj6e8I7KE=;
 b=pzu1C/rTcxHdC4hqTkQM3J1E5PwP98vAIo/xma0CQUxENnaEpFnpHwMhlUi9GgHGlc3QcEsWRv8z+FDM7X+aYCoOgchifH2FZhl0KJVHZUPb9+u4BFoP1MLflV48e5aKtGkVzUY5FODbvUjzOgt6NrJLCLfnm/tD4nx3X88Djzk=
Received: from CY5PR19CA0097.namprd19.prod.outlook.com (2603:10b6:930:83::23)
 by SA0PR12MB4461.namprd12.prod.outlook.com (2603:10b6:806:9c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 03:33:15 +0000
Received: from CY4PEPF0000EE3C.namprd03.prod.outlook.com
 (2603:10b6:930:83:cafe::2d) by CY5PR19CA0097.outlook.office365.com
 (2603:10b6:930:83::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.22 via Frontend Transport; Wed,
 9 Jul 2025 03:33:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3C.mail.protection.outlook.com (10.167.242.13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 03:33:14 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:33:08 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 01/35] KVM: x86: Open code setting/clearing of bits in the ISR
Date: Wed, 9 Jul 2025 09:02:08 +0530
Message-ID: <20250709033242.267892-2-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3C:EE_|SA0PR12MB4461:EE_
X-MS-Office365-Filtering-Correlation-Id: 316beae5-838a-4c6f-62de-08ddbe99566c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l2jmtuBro+F2nFAYWGdxL9kVAvGoBq0k/S5ZWIkYnUrrJxyBUUPB3CbantSQ?=
 =?us-ascii?Q?Ipi8KYfcbUh0ePYcd0+XTE5d3NU36dYotdhQamtrwNE682w4Ujhfr9mxiyk8?=
 =?us-ascii?Q?3PqR7Oyyf+oVz2xlhaI/IjCzh3Rm7c7BnUyv1LORGMuV4EDM/yZoDFC+6JcI?=
 =?us-ascii?Q?H6Wz+SASGZrfh4gaXXqIJ9y2jMk9mO+iZ2Fz4IYmd5WK/pxaJyFKcwBi/zoI?=
 =?us-ascii?Q?TxqJz8eW1T4y022iZqNliyFX1/ZZKFOyXrJ+tg8swrR3akVl4dJELuaPKjm7?=
 =?us-ascii?Q?kMExA0YOm48DT0sDTUROy0X9lG+UdpezrvdYFwkpTS2XXzv91YFB5yy21qD8?=
 =?us-ascii?Q?uuvHtXKq58mwolK8Dno1q9P3HLtDeMvxA5wAWAfWZ9Dtvc0spbl03mKixuo5?=
 =?us-ascii?Q?+6nfHtydX9s/+2OJYU0hPJDQn8TwPHQ1fCmid1feU4V84bMoyo/RHlPXpFRK?=
 =?us-ascii?Q?XVFeE3V7QEMaODvHGU9H05UC4rFDR0rXkf6P/74zXM4Hif1CguQ9T80y+e+B?=
 =?us-ascii?Q?s3w82/fix8VxZ4AH0vJsc/STez/ByBlP+cIwnHDFIilZDpMwjU5mcM/REeVe?=
 =?us-ascii?Q?CjOfwS2gSBvnB2AoZ96+KXZBjDHwKT1G07eU0la45aHC1M9WQPk+Js+yCrWx?=
 =?us-ascii?Q?EZSJ7hZJpo1ikHhYGQ3j+TOSRHz0E9wqNaEejb2tbqFMkxiObg+VvkjblmDd?=
 =?us-ascii?Q?yCZHcHLdREn/o7lsx3g/FwZhbUBlyxeD1a4vKNJl1KRUdyhSiOL25QMva7yF?=
 =?us-ascii?Q?D7m7MusUAIlvJ/YMKOcyJ2cXRYQZzwj+VgT2eMeLXbXlQeg2s6GQH0r/NfoI?=
 =?us-ascii?Q?x78pNZAQAv5zUmJbJaEVvqYHWmqg3Iz5cUrgKYGv6+Y0Rak4PaXwLffeV15r?=
 =?us-ascii?Q?u/SY2sFtgiMu6tkF43tEBvqsHXdbSBgnebDBpXHDB+uSVV3TUSaMxeV6Blig?=
 =?us-ascii?Q?IyvodsHjfJ29HKGI2TMoFByWNBrJng6AQoJ7AjgS5sOUjuyoOfNiMboEbRfe?=
 =?us-ascii?Q?fivzRp/42x1308sVqExX2pm4QK1qW0BY5mr/kQOD19Zh5jl2e95RNp703hcf?=
 =?us-ascii?Q?SG/nG9yYKeC5Qwup+cwNls6QaJSAh9qYkZ3sYoeUwl7Ark/Ba3T8XA+i7i0d?=
 =?us-ascii?Q?Mka+qc9dOAMvAPs7Bae7FoiXC5mTZqumhMOXBwjoxVmyrtMKcI9IFC4lxTOn?=
 =?us-ascii?Q?xc5CcJKOq7w1ra6LMNopKQtAQGKIHYSpZdeozHSwjGagYptUj/FjVlN8I6iQ?=
 =?us-ascii?Q?WkAfdFM45txbmxhuepqKXKKJxn49mKMFTkWXlWl76MYBX4DHL4nWivnM/Jzz?=
 =?us-ascii?Q?1zb+K0HdEqdRGAZdZ0kFfpszjOVJnZdN9CzYYH1jYFjkoBoJP/dQwayhOY70?=
 =?us-ascii?Q?f9VRQxkhK5rCZy3Hk4Dluz7YJ9YKNsBZu/5ory45jaLz6wBWYyHEcPPhq8g2?=
 =?us-ascii?Q?Dah3Xfi4CfJ2xCFgH08WTjsWLJev9FzjWKvE0qlzRKW5bWy26Xh5wUDrHFC9?=
 =?us-ascii?Q?+syks1YNMp9/jvcFlK5BfYm6ON5hb6JtoNrG?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:33:14.4820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 316beae5-838a-4c6f-62de-08ddbe99566c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4461

Remove __apic_test_and_set_vector() and __apic_test_and_clear_vector(),
because the _only_ register that's safe to modify with a non-atomic
operation is ISR, because KVM isn't running the vCPU, i.e. hardware can't
service an IRQ or process an EOI for the relevant (virtual) APIC.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - Removed "inline" from apic_vector_to_isr().
 - Commit log updates.

 arch/x86/kvm/lapic.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 73418dc0ebb2..013e8681247f 100644
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
 
+static void *apic_vector_to_isr(int vec, struct kvm_lapic *apic)
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


