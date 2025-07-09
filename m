Return-Path: <kvm+bounces-51838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1AC5AFDE2A
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6C441755C1
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A3C11FBEA8;
	Wed,  9 Jul 2025 03:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HHmzyibn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2059.outbound.protection.outlook.com [40.107.95.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345A81DE2C2;
	Wed,  9 Jul 2025 03:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032061; cv=fail; b=iRbZ6UekSVCAU0xif8QKA7EYou5u3OCvgJbXrnJnWc3M5YPHnUWohUoZWw4z3RuODzZ7SQaM9cjSsvgK+IEAbIFPWYiQBp39zSzSHo3kJzU7FPOPTPhCPPbwaG99TYhGKJilHlJ3k3c8syK+b2d15cZaWuyg6zSDA1o6DtIaUnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032061; c=relaxed/simple;
	bh=4mXo8Ob53HdPp3NYES0MeOhD/BUB3x7XVvG+nUbNivc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tWLtPAxckirXEaBc2jV2r3qPJ0HN43lWeMq+sCr4yfQDhn7tfIzL5rWYdEXIzzTsjbwkQ5gsyQTcStaq3AsX9LEa/iBqtqhcqd7iTBrltR1mH1PEMS81M6RRe0ZGri7uOp0pEFKdWNaoHaOBppisvACUuqFTw7D3GOK+wMdP4DE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HHmzyibn; arc=fail smtp.client-ip=40.107.95.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p6/M0AWy4EJW3TE3fijTIrbFRoM2QjmRRf7XqF8NRXDZb/Hq6vIcImotTvZZAubvg4lQxmZFDWPudOLw9+Z27TFx9nYCdR61rH8rTSyZV9VV3PwDDYDmVDbLnSaM0CWaLSnc5nZ2cZVh30OZv3Y+Ef4mm7IdwctAdp9hRIjIYBzeStUoR/BFd8AJtlIprUvacztvfgJFroLlluiKoK4MPCCBNK9AGsdcTIrkKRg4ALfLCLR8D0+38wKDSH5Xbzj9zwkDZRrf2RHFNuqeRIFfUsBh+oDbsBWW9b3eZ56Td1wdlU+RgzAOx8qU9jRD+Mmgf+RCbM/y79OELTUCAaxefA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S//FiANr8z+daB3W5wyjyXlpUZHYgECT4OFNQGfdFsw=;
 b=uinhzbkowxWqyqdbuzEaMhPuepFbyBL0FmC3rkmQhH3Tw7DkcJnvOdE35yX+s6EhhqqQfqM8p7OkRXCAHQ2fbXEBbZwF4ZzdwRqYYH+enowGP0Qn/WtVqwKHD8e0GpB845PmdylsABV+Iy3eOthnCeMVwKk0hvjbOdAmdwVeIR7/npS/cTbAhEDrwxWMYs7h8h3vXf2HJMdcge6fz9/nu548ATKwYX8IjZOdKBuXR1Gm4XNF9wVwQP2PKIITpLi8/7z+zVM11c3vvwzxbunsFZuGdeSRqEfNJMIi1VdBbgAohQ52myHmTEvJu+5n05lMycpoQzhoXnBEQw621TIQ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S//FiANr8z+daB3W5wyjyXlpUZHYgECT4OFNQGfdFsw=;
 b=HHmzyibnu98fDPnqwA2Tg7XbwEO9iEzlf+0drsxtPnSDEOsebc2YdzsRTVPKy9x6ygYupBZnbMJ+CEXZ7T4j3wkuZiRghiBub9cimkYt8mrcaR9F+TXIyGzdL8Wv+KSHgOknPa1wnSDfMYdhGHdPWi8FafJB9HuYfPDZHrXS/YA=
Received: from DM6PR07CA0092.namprd07.prod.outlook.com (2603:10b6:5:337::25)
 by DS4PR12MB9681.namprd12.prod.outlook.com (2603:10b6:8:281::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 03:34:15 +0000
Received: from CY4PEPF0000EE39.namprd03.prod.outlook.com
 (2603:10b6:5:337:cafe::d3) by DM6PR07CA0092.outlook.office365.com
 (2603:10b6:5:337::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:34:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE39.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.20 via Frontend Transport; Wed, 9 Jul 2025 03:34:15 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:34:09 -0500
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
Subject: [RFC PATCH v8 04/35] KVM: x86: Rename VEC_POS/REG_POS macro usages
Date: Wed, 9 Jul 2025 09:02:11 +0530
Message-ID: <20250709033242.267892-5-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE39:EE_|DS4PR12MB9681:EE_
X-MS-Office365-Filtering-Correlation-Id: ef71ca1a-d420-43e7-a234-08ddbe997a80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1053aq5hz9bYRgjMJBs35Jqk7wGoipWtQgpl4wQAarZyzBsG18ayg8ANdQQG?=
 =?us-ascii?Q?xs9XMhl4DAT43vlDDPahr8VsO7JPa11LnQIbqXkI/jd4azXD/G3YS7gyqutf?=
 =?us-ascii?Q?+kRt4lzyfu29/d3KkNna2f2zGKZ7kMOl5Ik5rRP306/WqEyGMN4U12rWoL+g?=
 =?us-ascii?Q?usAh289KlJgxBhQB9SkM6eV0SFOEwzVm7XHqoYXxBCPxy8VIwVx17wk/pXPl?=
 =?us-ascii?Q?qeSvSmbFevIuXMSNhpFOEt49b3/xwz7CXBK+P+aPp7BsW/yPnWWWKyhziflH?=
 =?us-ascii?Q?uYoa9wy5dKGPBvJt90zC82rvFy989yYJ/B2vTnHh9/kWjge67IQ30N232lGp?=
 =?us-ascii?Q?+eBxhhHDzxIzx4SgDhd7RbT+z1dL4nM3UQXBpBxqgznH4eNcZ9qAqZvkRb9h?=
 =?us-ascii?Q?wToSzM1KbqIP06gb87klOlkWALo1/y1QaVBAmOtGLa94F0mjjCgQMarKna+i?=
 =?us-ascii?Q?Mz8Wxyfkdc6QBHx3KDV/NcNFJwtsGhPXk/lAZo4iiWB9xJvehMAWHBrSqW6f?=
 =?us-ascii?Q?ID3+/oUCYqcIXOAEBIMr25x+Npj90P4QHQNKzpFq0BhChNjVe11fiCliHPVD?=
 =?us-ascii?Q?vArQG3Q/Y0PNOn+CyEiitoVU54kaBwCkLZGiX2VVvFMDtBz/p50XK1PRK60R?=
 =?us-ascii?Q?uzSe4L6h5GmCykxN9gqFTBfgKsKbIxQEErZAPVUGVQ4aDx3Cr8/vEWcE7v0n?=
 =?us-ascii?Q?PJcOT2qQ6HaPJ/umvfW2FYSXIDZxpiFeKSYw9cwwnVc4DyL084yyCKsx6nxj?=
 =?us-ascii?Q?fOlX8kVpHA1rdnA3Htmc/uLXoVsONDKojQWpWFVUCWQDZp8af4qUnSaHecDy?=
 =?us-ascii?Q?OB+JG5+Davqxi6D6fMWq2lGsS3XB0tFqitjz65EkjHSsEEiiXsFkG9ysASy6?=
 =?us-ascii?Q?6e60H1erm3BGZsjZpx7o+3WwOUHqN/5/SeJuU8duSPH5n7FSVWvdpypeP4Ip?=
 =?us-ascii?Q?PDSRJFzTJpQO7nYWRuktoRKjluTfrT3q1OcYuVqC6Mw1cLTjbzJZ+Z92dOin?=
 =?us-ascii?Q?g1H+IzddADZUtjX5W6pkfN0TCKu8+OsVlHPvzKaiXr242uVOetTchOHQHZ3r?=
 =?us-ascii?Q?h2ELEIhBUOKM8+NWMEqOHsmW3PaEVNc8Ap2LBHJtc/wq8UOw7667F0Ale8Y4?=
 =?us-ascii?Q?gYrfBiWL9Z8F1ZsJ3+X6YoU+UqHvK95cCTQ0pL60vajNiY2fCKqtNohIa5Nk?=
 =?us-ascii?Q?3wWLPsSU9B+R2nJQMMjKqlRw6MRSqc3LGTKi9X+neKQDaiOhAouXHzmQRSHU?=
 =?us-ascii?Q?zBBQNDR6qCJoNoOOiYVd21cvpironsfGw0aTSa7lhOQr11Le0wdXObJ0vfBD?=
 =?us-ascii?Q?Jcg9nr32cQdoVGmemvF+3Asdo3lZxIzxQUJ87ao2i9A9IzDgxV6XcoZ3M1u3?=
 =?us-ascii?Q?VCHJMmeRpc2PtQBLPMdHkL4wGfMgs36NLkFbxES4fKaZ5OMrc4+zAK1szsgQ?=
 =?us-ascii?Q?TetY04X0BARmnnNa6clnHaNSWWXnjnPFCXEABHX5Euy88Bh4myoASqqjRJFC?=
 =?us-ascii?Q?yTa6qvfXZpPXzgvVdjPBp379sO2P9ksxIsOL?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:34:15.0124
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef71ca1a-d420-43e7-a234-08ddbe997a80
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE39.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9681

In preparation for moving most of the KVM's lapic helpers which
use VEC_POS/REG_POS macros to common APIC header for use in Secure
AVIC APIC driver, rename all VEC_POS/REG_POS macro usages to
APIC_VECTOR_TO_BIT_NUMBER/APIC_VECTOR_TO_REG_OFFSET and remove
VEC_POS/REG_POS.

While at it, clean up line wrap in find_highest_vector().

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - Commit log update.

 arch/x86/kvm/lapic.c | 15 +++++++--------
 arch/x86/kvm/lapic.h |  7 ++-----
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 533daf6dd1b1..1dbc1643c675 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -114,7 +114,7 @@ static __always_inline void kvm_lapic_set_reg64(struct kvm_lapic *apic,
 
 static inline int apic_test_vector(int vec, void *bitmap)
 {
-	return test_bit(VEC_POS(vec), bitmap + REG_POS(vec));
+	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
@@ -621,9 +621,8 @@ static int find_highest_vector(void *bitmap)
 	int vec;
 	u32 *reg;
 
-	for (vec = MAX_APIC_VECTOR - APIC_VECTORS_PER_REG;
-	     vec >= 0; vec -= APIC_VECTORS_PER_REG) {
-		reg = bitmap + REG_POS(vec);
+	for (vec = MAX_APIC_VECTOR - APIC_VECTORS_PER_REG; vec >= 0; vec -= APIC_VECTORS_PER_REG) {
+		reg = bitmap + APIC_VECTOR_TO_REG_OFFSET(vec);
 		if (*reg)
 			return __fls(*reg) + vec;
 	}
@@ -638,7 +637,7 @@ static u8 count_vectors(void *bitmap)
 	u8 count = 0;
 
 	for (vec = 0; vec < MAX_APIC_VECTOR; vec += APIC_VECTORS_PER_REG) {
-		reg = bitmap + REG_POS(vec);
+		reg = bitmap + APIC_VECTOR_TO_REG_OFFSET(vec);
 		count += hweight32(*reg);
 	}
 
@@ -736,12 +735,12 @@ EXPORT_SYMBOL_GPL(kvm_apic_clear_irr);
 
 static void *apic_vector_to_isr(int vec, struct kvm_lapic *apic)
 {
-	return apic->regs + APIC_ISR + REG_POS(vec);
+	return apic->regs + APIC_ISR + APIC_VECTOR_TO_REG_OFFSET(vec);
 }
 
 static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 {
-	if (__test_and_set_bit(VEC_POS(vec), apic_vector_to_isr(vec, apic)))
+	if (__test_and_set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), apic_vector_to_isr(vec, apic)))
 		return;
 
 	/*
@@ -784,7 +783,7 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 
 static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 {
-	if (!__test_and_clear_bit(VEC_POS(vec), apic_vector_to_isr(vec, apic)))
+	if (!__test_and_clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), apic_vector_to_isr(vec, apic)))
 		return;
 
 	/*
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 56369d331bfc..eb9bda52948c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -145,17 +145,14 @@ void kvm_lapic_exit(void);
 
 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
 
-#define VEC_POS(v) APIC_VECTOR_TO_BIT_NUMBER(v)
-#define REG_POS(v) APIC_VECTOR_TO_REG_OFFSET(v)
-
 static inline void kvm_lapic_clear_vector(int vec, void *bitmap)
 {
-	clear_bit(VEC_POS(vec), bitmap + REG_POS(vec));
+	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
 static inline void kvm_lapic_set_vector(int vec, void *bitmap)
 {
-	set_bit(VEC_POS(vec), bitmap + REG_POS(vec));
+	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
 }
 
 static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
-- 
2.34.1


