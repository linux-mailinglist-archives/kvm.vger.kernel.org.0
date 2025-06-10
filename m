Return-Path: <kvm+bounces-48820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F101AD414E
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B069817BEC5
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D537C247283;
	Tue, 10 Jun 2025 17:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wi2CJgsi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFF424500E;
	Tue, 10 Jun 2025 17:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578172; cv=fail; b=IHrzUUQv+paOdCW/MdqB98VR5V0e32jb3g9+gtAshaXXcz5OBj7P/dfFJJyaSYAeadsbqD7Zd2EB5ZkkkuKgydhnfUJDexj9AGrxzHkPOMLor/8AdjgBiJcCub6SoHhVjs9P0VU60Qblt6pFxnDWZRiW6ivw9hsDlVddSPi75Ic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578172; c=relaxed/simple;
	bh=oADmOfLMddxPBmgY/l60IeJSE5P0lckw7B9N9r0PQXk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OL0qcjzHSxTEq2g/zR6wjULxGARyTV2zDPPqV2WAq6v9gmyj3eRmaXtsdnWgmpva9FvjLCNHYf7iEkMT/rJuLeyC6vpZGKx1IU2xPnDfkpjt7G+x/0QKhFGH84t2+1jMXgtw1IxN4pm8+W3RZhqpv1ivL0kfs1Vsv7VAla4B+cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wi2CJgsi; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CZ/Z2hQfpj0MZCgux4rPW1fQWmF1+70ytbsHupS/y7oyi41rEN3wbIEg2XwO6ygV20qlreWmWD3LTCM0UNft47NjO7at9qIfKNi/geW1o0hY8dxvigGs4F2vwim7iT8hktfmJpK/ArBtE4FEdIrN51DJ0JO639InRgInVprubIrQHMcxB9ChDUu9QGxHzDK/QTPxJNm10ZvJUm1JUAwHrsiEHtCrb7hMvbx8kF3mAHRapsq2WhswaqaK5Qa4VwETsab8KVZb6dLty3quPEcwi5nmnlc3Ga/KGiLll06Z4wUzCYqa+zv8R92cmLoJk1ocdx2oISECxHxd3P5xv+QpfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1xpS0Sf3q282+l18y9kQV23vlMlYvmkoGmWSQiIh68=;
 b=lQHSRVhVshyCVUw+mMslsgCqF7i3YXUVJVLLPotTM/RCeu2cevfMkbwdnkuWjiurf5f8j+Lk4U6dza+A8paRUMQuXDZD7x/ufhn9/8+yZvtirgrmZuUSN1Ld6tsAtlvQvBTAVG3eEkekIIz0F4QyhOiRcOUrNAb/VSsPGgEUi1gPURI2vqqDFc8p2sbI/iFepc9pb2Z1YwSB4fEpGxCniavGDPp1a0fJvg3Zrua0X+hO+P8bXW6lyn59cMSggGCkqn8TpfOheyajqGbsUFjQql7jSWDtg11C9Rps5Ruf8Uky4BFuMLLW8Ue3x8xviifWuEosdzv8Hw70WI9Zud0pfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1xpS0Sf3q282+l18y9kQV23vlMlYvmkoGmWSQiIh68=;
 b=wi2CJgsi/7WhxysNrR8yRIR6ZZRCx/5cuJu0X10SHjudJyjKFYtFl7NpmF019jp6mrDJO5Wk5RZGYYvZnpkdePHZn5sF2K6A4z+i95zQMaUoXFbh+LnLB8Kt6zh7ewMb1ivclWl0I3PAqHQK9vlqSWXgkzSq34MRQK1bT+6v0Zo=
Received: from CH0P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::23)
 by IA1PR12MB7735.namprd12.prod.outlook.com (2603:10b6:208:421::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 17:56:07 +0000
Received: from CH1PEPF0000AD74.namprd04.prod.outlook.com
 (2603:10b6:610:ef:cafe::b8) by CH0P220CA0009.outlook.office365.com
 (2603:10b6:610:ef::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Tue,
 10 Jun 2025 17:56:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD74.mail.protection.outlook.com (10.167.244.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:56:07 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:55:59 -0500
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
Subject: [RFC PATCH v7 04/37] KVM: lapic: Rename VEC_POS/REG_POS macro usages
Date: Tue, 10 Jun 2025 23:23:51 +0530
Message-ID: <20250610175424.209796-5-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD74:EE_|IA1PR12MB7735:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bcad86b-e703-4329-0c27-08dda8481382
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K8qWVu7xAgDQyAyLm/G3IMHL612aXGV60GOtln49tKBNftg6Fwy+9N2VQaMD?=
 =?us-ascii?Q?17RZm3ilRCND+yC5+hRcD+PjzDDZYUFl181IHSdSPJ/kxel2CNl9GtDmZyas?=
 =?us-ascii?Q?28eHuGJxQTbXzd62PVb9Hm/CPZYFdZRGZGf1s0OdvnrUFeObVPLm01JfRtfg?=
 =?us-ascii?Q?U+AcGPMnethqZ5oPGhjrdi8Fwa5Fs8O73lWocjk0InbJrPj3TsxIZSVAke03?=
 =?us-ascii?Q?rLLmLHVN8OVh2A0q60Z3b9itjIk7Y08HWlZA6cBZ9aAgAcva7/0WG514pJE9?=
 =?us-ascii?Q?OsW9czBark1MhT3XIl687Xc7fhANYE9hLhLcVXQEuJPHCA5sKQ2UBjq6pI2R?=
 =?us-ascii?Q?WlftAFTGzH+gagl+h5oe3XA1TSzjEbjgLOM/dZm3GMdaSHhPpGeAUfFXneR2?=
 =?us-ascii?Q?YxemAKTys5BYcA55Ce4LFXRHhtfU90Bp0pcgDs7KMwYiNrcismJriWb3MZ+M?=
 =?us-ascii?Q?purgGuMLHIpjFgQcCFRvM9XgHHiMlZhIqaJ2Xx4MfOIRq9tBHjzX3idRbLBC?=
 =?us-ascii?Q?yVHYCT2xDJjuugEMkITViBWvSlOnu5G8n+8Z4u9t2gsr/sLGSU5osAKO1sRi?=
 =?us-ascii?Q?doOkIWHmA55eFZhGw48HTUvTkPcbEGRlVhm75NLHjNm+GY4l5MKESq5qZS4n?=
 =?us-ascii?Q?kP+PTAC+fnyFz7LZNrp6nItsQveIppqOPZAZBzRWZqzHLa/7ULntkubdYYMh?=
 =?us-ascii?Q?WY8nT0gPoeLUlc05/uXyuGTc/sRIU6IBY/U/aFKv9pv4QYnszkwHNzsMDuWF?=
 =?us-ascii?Q?sDNmoMiydHNJ3ppcuXACHY5SRaSGH7iFFbzYxjHfVqvSG/+ah566BwlT6UdU?=
 =?us-ascii?Q?4mybvbVAelEEjogdOfAWke6FA2AAaW5PoliHzn+qSqrxO+Ao/fDqOhBjHbKE?=
 =?us-ascii?Q?NWI8EjMs7UoTsOU6XOlI8JnKW963veIUQk1eKAxtJEf32zmwJJr38A1CpzCs?=
 =?us-ascii?Q?q6VpsaJcYcXyLopkwrDNlcURiBs2lTO7Zu/SgrQdfwmklahyd0VOqQNuw/q4?=
 =?us-ascii?Q?5lAozgz0hGJR1uS95WrgA7pw0uScWdeqqZ2o8pD90i23J1j+Hkfw6d/+VGAr?=
 =?us-ascii?Q?+EQjW8Sz+r4CrzF1M5SIogz7yPjScmf584MK9TitNBj6/+S3bgco7Q27A0Gd?=
 =?us-ascii?Q?K5RfK2shPIGvtnwoYatwxkwgF2OrKZrZuiqxXhzXbFB3vu770VNheqvxZJxT?=
 =?us-ascii?Q?68uWuFVYWL5KAJ8Vo1+ClR7isgIlX7I3K4RvoV7tFtekCBCuOEq8uUrR0RFK?=
 =?us-ascii?Q?9scuW45UyDY6glaX1AbyR3VmiCr9l+RHoZtXFHUO0TZ7lMXvmzIaNF31jsmc?=
 =?us-ascii?Q?bfCG4Z+qUZLFy2PnAbdKh5PxueRHN3Xfa6DdFsxZ7EKSIFcsI8B0GtxqiqeO?=
 =?us-ascii?Q?Uxpp3D5UtmvPIRN8VrBc9hZYniLhx9PfyzVvOadP64SZH/e7f3fo4wto6cu/?=
 =?us-ascii?Q?I+L2Z6FANC0inJ84TIlhtrLWJ9SEhWaq/8QCj2lEhVfKP6tHEkCsVsYp4hhI?=
 =?us-ascii?Q?TQo3yVXIExLmr3gByP5CvQ5V+wZWuwlBaJuJ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:56:07.4344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bcad86b-e703-4329-0c27-08dda8481382
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD74.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7735

In preparation for moving most of the KVM's lapic helpers which
use VEC_POS/REG_POS macros to common apic header for use in Secure
AVIC apic driver, rename all VEC_POS/REG_POS macro usages to
APIC_VECTOR_TO_BIT_NUMBER/APIC_VECTOR_TO_REG_OFFSET and remove
VEC_POS/REG_POS.

While at it, clean up line wrap in find_highest_vector().

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - New change.

 arch/x86/kvm/lapic.c | 15 +++++++--------
 arch/x86/kvm/lapic.h |  7 ++-----
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index aa645b5cf013..096db088d6b7 100644
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
 
 static inline void *apic_vector_to_isr(int vec, struct kvm_lapic *apic)
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


