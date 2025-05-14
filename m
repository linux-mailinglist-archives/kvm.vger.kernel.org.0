Return-Path: <kvm+bounces-46429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57E64AB63F4
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B8B73BF8C5
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9934E2063F3;
	Wed, 14 May 2025 07:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kB4kPioi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F72A205AB8;
	Wed, 14 May 2025 07:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207131; cv=fail; b=i1fepwEcmJWQ9ZIKSvgVg/mg7G5jaObSQV6QLSca1d0FizZNyOLj6s/gs4JqHYZZaC0jirU8R/dULc1KIiFSIGs6DX0DFNoKqfi4JUCVnyEK1/VuGV6xYwqG1jXb+seyQw/rtwbYzqxUdYyZIccRjotQApeHA2bNDY7QpUIw6Kc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207131; c=relaxed/simple;
	bh=Q7AhnDaiy/27v5awBvuqn+YWcr7JdH226VoJPoRxVlQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WAx6knp+vnrssO2dcDYdZ4+5LJ6b9YC9T2BxxNGc05eWZP+NRm5umnc23ZNSsEnrp9CUpMH/SfvznK14NOWcc5XNlU5Y8cj952pdr2fs3WwvxRtfiW6xUGu7F6C4gq1ivqVIxi5pzPj5BKyc3usjKJxDA8V1eYrFlK7WkrQkSuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kB4kPioi; arc=fail smtp.client-ip=40.107.220.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o9r6qFnOkD35pRjuW78tLsZT1zGtbZcR4mcjR8wV7i92I92d4eO5wgH95D5QxTTlSmGPeSAHqjXlmJgOK13gc07FVtbqKctnL77NA1df+zUTNGOEcZuUsWYhiFo3G98+Y+o7Za/YhTbqlPRytWoWLw5OGul+6I5PmqEct8LhahnhL+iwt/atq7etYw/8Zmo87i+k49YKjv/fxK2NeJX3d5UOCX6c6BoY43NXwlwjidQV3fHF5hnp4sJDz1RFsk+mKVlyVXVOWGhvtwcRNB6kGrECx97KqdLbt4WB7OWrnlkU2AtbrTgE9n0su3fkBXtojf1cM4X/xo75gM0+go+uMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BxWHpyDntcjxvYqOBSoRv1rOoJ2+yPhbCbVvOs+RQjg=;
 b=WeVVPCWTP92CPPOVcmrq+i8vaYpxHL/YNLFUJCL8mDQv3dYpH6xo1/E1YsweJsx3Xb3CZ4NAqhEYj6rVIuBcM1YNqUK5zVuZ/4OmUEZkrEQ+6Z5pq2EdBB+NnP21nMCdLJfYqHJEb2t+8pJUkpIN4Va41uBpRjNW0vrJ4ToXN7UCG9XoGiUU3bcCH0jQ4MNTN6VH8EA+E5ly7YaFpTrtXelUR4NvtJFYTNDdIkn/g6bhy70a5DV1DWRBt6RDxBQqaIj3Pz7TU0aB8vMcgiUO1XuuwbEKhsOT6cj8OxVP7aSV3/ZpfAt/kkQIlT+Zl6YORTutZhaYCua3+XVBw7mbvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxWHpyDntcjxvYqOBSoRv1rOoJ2+yPhbCbVvOs+RQjg=;
 b=kB4kPioiCpdeFy3KsFhk5O3L/ziap4yfSeZDzmC5opI4ThW2X8KJa3H+RQ+h1whRRain9tJ9errbgHiMcHysuGAWmzBMqAZM36EfRER1SBHqZy8AaiwtMO+hOOilyGYX+TWlXhwlfMb8WJYF5WVF2veadAY599FhDY4LBn8+hIA=
Received: from SJ0PR05CA0009.namprd05.prod.outlook.com (2603:10b6:a03:33b::14)
 by SA1PR12MB5669.namprd12.prod.outlook.com (2603:10b6:806:237::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:18:45 +0000
Received: from SN1PEPF00036F43.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::d6) by SJ0PR05CA0009.outlook.office365.com
 (2603:10b6:a03:33b::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.23 via Frontend Transport; Wed,
 14 May 2025 07:18:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F43.mail.protection.outlook.com (10.167.248.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:18:44 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:18:35 -0500
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
Subject: [RFC PATCH v6 01/32] x86/apic: KVM: Deduplicate APIC vector => register+bit math
Date: Wed, 14 May 2025 12:47:32 +0530
Message-ID: <20250514071803.209166-2-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F43:EE_|SA1PR12MB5669:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fb442b6-e8fe-40ab-d865-08dd92b78f9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?syea8shIdgfWyAqizoRK8gQrzJbxAUapyadsvaQ5qQFL+qudI8cnQ4ffro5A?=
 =?us-ascii?Q?JN/wd0NAT+6Eq/u7Qh40vivEiWO6YAFD+V2o9OffEYmCW8v3o+gFAlShmERz?=
 =?us-ascii?Q?wDcUWGn/wh2YZbM7Z0maDiCBoB9wJo90LyvqSEk1b2C/IwbnzcbT1geUXWy7?=
 =?us-ascii?Q?6BvNzIzD4fes2y7NsiKeY1x8sCviVriQDLfHK2fcOzb9H5bBsavWIR8RZBOn?=
 =?us-ascii?Q?eG1Pmi2DK6gNj/CmsMFZ4EGz6Zi9WgbaWr+rUd7R8x3oVNCm2KsJh9hp2H8o?=
 =?us-ascii?Q?UdMq57sxNSqqnI7BMCc7RdOQ1M+mzK/NNCoBkS1s7m2+cQPl6mmBNxIRu/6c?=
 =?us-ascii?Q?TYFfFWMbY3K0039QF+81e73RxO9t1JzLWnaq5lRoLtMZAW2zGyeMa4RNU2Zo?=
 =?us-ascii?Q?X16q2BeRUuaoHobTxHqmA5ekSiaFuz9XUiRlJ4MDUw+cR9CMvjGgWAnRB2Mk?=
 =?us-ascii?Q?1qlXsbZt+14A3+LSqzKvdn3nkHofBixHcHqtKHvgu6nnlmwiot/9pFSe0wPk?=
 =?us-ascii?Q?SS1lmYT0YaJ3WgkMlVqeZ6FS2QGx4rqgbSQvMmyJj/rq7sNptgwP0PngvcfH?=
 =?us-ascii?Q?xt+qE1/Lm+Dctz1alsm6OFVej1j6cS6OuFfqmxdIeP/HoZZ8gHTDSMw/Pkyf?=
 =?us-ascii?Q?nrfmXJHGuqUfUPKK8c45TbNlCExB5jkTCFnEQKdVNjGls5iqBBwDSNJmW3Lo?=
 =?us-ascii?Q?0h/Mwn/zvfmYDRcaYnZbGpMsipIpuFGs40qRvhfsDXrJO3t/CbZ3Lr2+U14X?=
 =?us-ascii?Q?YpWqZ9WWituTf7zU9LMvYViLpMIzqG8SbvuLcgpzmoUYvSY1N6SvtWBdQrM2?=
 =?us-ascii?Q?BYKa3uJlyB4isOEm1y85cmPeoEr+LzQG98w+5tv2xXDWsjnDEWlDQYW55HLw?=
 =?us-ascii?Q?8GhTPOQ2yWZ1rh5rx/bBNoQWLJpzHuFQWcmvkYkZbFJ7xSjG00A+CgQp+gb7?=
 =?us-ascii?Q?gXRjy1L+dG0vWRz9dm695tYh8bnWINs2XTfP1M58tf+paiHLJNzjaNKN3oRb?=
 =?us-ascii?Q?g9C7jDJTT8kWcIrTcgnTnUGQJmkLgNNqcdEKNds1fxq14GwcRo4cA9yLR4Ub?=
 =?us-ascii?Q?Jab3myfUIgCMkBbK1XmJvtYmvI/4t/QWbfAIdBlq3g0giCd/GZ5X8wPh0CWh?=
 =?us-ascii?Q?/VOrezjo38UEiAG6foZYmhIDpBPAurSd80YyVIuKWsDJoTRA70OadJIGojuM?=
 =?us-ascii?Q?XMFnFBztdC2lqFheGLoEJkzyly7DLoe209giZ/dpSHiZkUmfvqRvNnO2rEuN?=
 =?us-ascii?Q?aUAykHTAS6Z76uC5gqrPrhk7hh2qhzOrDeCyZIH76MMh6tZ4szZN//JwWYiH?=
 =?us-ascii?Q?8hMxrQfn5otJZLqje84FvFnwVntyPubJPNpOPp3YcVmcurcHlKAsSzcZ3Rza?=
 =?us-ascii?Q?Oa+huzU7K27ZEQ1u5lA7Q8a4ycSxheg0ZXeFCeo5gYT+DfyC0/Aj7upyBJbq?=
 =?us-ascii?Q?/2BgDsjV12kecWTDb/sgpZcN0wFP+g8fKDZoQUYhlPL81qm9vaLI2u8woOL/?=
 =?us-ascii?Q?iUhCAuAkDxSK8IRExfajS+Qp2+baK2hp/dGx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:18:44.2031
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb442b6-e8fe-40ab-d865-08dd92b78f9e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F43.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5669

From: Sean Christopherson <seanjc@google.com>

Consolidate KVM's {REG,VEC}_POS() macros and lapic_vector_set_in_irr()'s
open coded equivalent logic in anticipation of the kernel gaining more
usage of vector => reg+bit lookups.

Use lapic_vector_set_in_irr()'s math as using divides for both the bit
number and register offset makes it easier to connect the dots, and for at
least one user, fixup_irqs(), "/ 32 * 0x10" generates ever so slightly
better code with gcc-14 (shaves a whole 3 bytes from the code stream):

((v) >> 5) << 4:
  c1 ef 05           shr    $0x5,%edi
  c1 e7 04           shl    $0x4,%edi
  81 c7 00 02 00 00  add    $0x200,%edi

(v) / 32 * 0x10:
  c1 ef 05           shr    $0x5,%edi
  83 c7 20           add    $0x20,%edi
  c1 e7 04           shl    $0x4,%edi

Keep KVM's tersely named macros as "wrappers" to avoid unnecessary churn
in KVM, and because the shorter names yield more readable code overall in
KVM.

No functional change intended (clang-19 and gcc-14 generate bit-for-bit
identical code for all of kvm.ko).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:
 - New change.

 arch/x86/include/asm/apic.h | 7 +++++--
 arch/x86/kvm/lapic.h        | 4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 68e10e30fe9b..7e0d3045e74c 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -488,11 +488,14 @@ static inline void apic_setup_apic_calls(void) { }
 
 extern void apic_ack_irq(struct irq_data *data);
 
+#define APIC_VECTOR_TO_BIT_NUMBER(v) ((v) % 32)
+#define APIC_VECTOR_TO_REG_OFFSET(v) ((v) / 32 * 0x10)
+
 static inline bool lapic_vector_set_in_irr(unsigned int vector)
 {
-	u32 irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+	u32 irr = apic_read(APIC_IRR + APIC_VECTOR_TO_REG_OFFSET(vector));
 
-	return !!(irr & (1U << (vector % 32)));
+	return !!(irr & (1U << APIC_VECTOR_TO_BIT_NUMBER(vector)));
 }
 
 static inline bool is_vector_pending(unsigned int vector)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1a8553ebdb42..05fdf88ef55a 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -143,8 +143,8 @@ void kvm_lapic_exit(void);
 
 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
 
-#define VEC_POS(v) ((v) & (32 - 1))
-#define REG_POS(v) (((v) >> 5) << 4)
+#define VEC_POS(v) APIC_VECTOR_TO_BIT_NUMBER(v)
+#define REG_POS(v) APIC_VECTOR_TO_REG_OFFSET(v)
 
 static inline void kvm_lapic_clear_vector(int vec, void *bitmap)
 {
-- 
2.34.1


