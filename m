Return-Path: <kvm+bounces-48819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C96AD4150
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:57:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DEA207AD550
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51125246769;
	Tue, 10 Jun 2025 17:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ohNO4abZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D852459E1;
	Tue, 10 Jun 2025 17:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578153; cv=fail; b=XeHbdFymGzzcOQZdq92rxXXUaYWORXTL9fk+A5omJxH4UsnaKUZ2M6DopYwuLqhxf0YAAre5LFqdvmG21lzHJtYIzgteJdBUGId6ngQt+H1jxQo2mI900IJZDW7U9mJMmL8sJiXWS2T8vVsRHmI8P88+qjoyNQ++n+Z1HOEF4ss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578153; c=relaxed/simple;
	bh=OgSnmwKuZiiDjgpmYNa+XUqsa98lMqZnKqFOUMj+DFE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hSQrUZiHd4nR/LyHdEKjSfLqho0MMNeGo7YGEqH+VqjxKmuVbf6osJ/mTi/tC1Vj772IPWZ4RxwFywC0oGcskgR4sVMU1TvGvJgaLEBfkt6gtgWO9DnHS+yeWmxkz473HiTQ8k/c8kqWrM3Pu/uGap+iurgnMLzIFTuUCpEYOFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ohNO4abZ; arc=fail smtp.client-ip=40.107.220.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f7VQgFVSiGqJ52xe4QJOqIb+gnoxleR14rfFkJBUpHLRY38zAr7C2L3C8jeCgt92MUImNlesvtf3nlMqCmoPvyXJqhCcMkJ3nNe9oXRGP8qT43lR97yxHdftugG2OZqIa2JPvvNyTuAIW4u7NJdRqqFQuOB771UMw/IZ3lZnJ95qlMiFllj79Xcsj/XOIT4vJzGDroAb0+xzwv2xkQIVStXo3SFyu/p4XdTB3yJBm50/G6/FenM3diZ20bbovx+3hblmau/QyIVVqX4yMuzyENkVUQHsAJLEsFPR+YsINNiR72ruszxYDDMI3m2PUFwVyflv4TnN5yswxOOJWvj/3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uEtlhVGCZW4iDAb0esxFI4R6mw8E/6Ngvccawx3ay+g=;
 b=DZwJ2wsa7n8paXU/VEkKFhz9qDYYWmN5ZbmRY4Kv71tm7Q2uNtU5cycJ5pZSUNzVX4kG0hNkUTiYyVSGugY7kxidN7J97SLaSOaiAw3P+Nv0B5f8+pszHs5oYszorBcWNlvA1O1gViQj82WfdOaF6kwOG1gqSFT7Qpfyf7rsl744BfcEFw9yp0ptmk5UhFO9WxhRwK5T9ELzm2Nqe9CeWGEiXDMk8Mo8/B+VGJXtN32/mnieniuT0MASFf+JEGT1G3GHCjRmOPr/rZyHWAl9eUF1m/PPCfw7EvNPyiZUMVqoR7mF4DGrlAqCuDJHPGF8pjF4VECFtdztsfC9zjCiUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uEtlhVGCZW4iDAb0esxFI4R6mw8E/6Ngvccawx3ay+g=;
 b=ohNO4abZ3v0VN2GB6XqcLgdLkrSaqpKcxxsUhaHBlIvSVd2C4VWb9wcJrUcdQ/2XT2mUBdyoNWBe3vcdo41yj1akl9zqlVrWJxKaziTNcXE1xJrlZrS3ntngZKSApDcNnObs2nUFB1AXhns4XkM/UyqOR47+fHCENdwWqghQMRo=
Received: from CH5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:610:1f4::6)
 by SJ0PR12MB6879.namprd12.prod.outlook.com (2603:10b6:a03:484::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 17:55:46 +0000
Received: from CH1PEPF0000AD77.namprd04.prod.outlook.com
 (2603:10b6:610:1f4:cafe::e7) by CH5PR04CA0001.outlook.office365.com
 (2603:10b6:610:1f4::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Tue,
 10 Jun 2025 17:55:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD77.mail.protection.outlook.com (10.167.244.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:55:46 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:55:38 -0500
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
Subject: [RFC PATCH v7 03/37] x86/apic: KVM: Deduplicate APIC vector => register+bit math
Date: Tue, 10 Jun 2025 23:23:50 +0530
Message-ID: <20250610175424.209796-4-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD77:EE_|SJ0PR12MB6879:EE_
X-MS-Office365-Filtering-Correlation-Id: 39658930-78f2-452d-87a0-08dda84806dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hgrzSW3OFthh9HwB43cw0JjTflDvX5V4l8ozyG6dMR7IX+jwB6caWaQ4XDCB?=
 =?us-ascii?Q?JoUFg14anZfmFgZaqHymRoe/F638SQnt/c35kZrk8zwjz52Tk/1CGo1uae6I?=
 =?us-ascii?Q?mJIjcY1B8u2x1irkqmf91MPk1B3avwKDs8d0oq/cOEMFKFuS8FT6gdzOZbMt?=
 =?us-ascii?Q?7pQMXj3b+wTuXkYKG4doVpY+WHLocStdxcCUmASX7mlSA3ruegSLPh1eJ8tu?=
 =?us-ascii?Q?BjXtL7Ur5LRaoOsr5a1a48/lj2TLIJWhBgqiI/uKa5EvTptuahVyYhIOgVzv?=
 =?us-ascii?Q?bjItmv/w8M4FpE73/EnprPsbPbjr+Xw/KfXs+Ta0zJku5cRd03GOG3DAFD31?=
 =?us-ascii?Q?3dcamCkAShnyIujXZvvdfOo3lZUPaJEohLoXdkuOfCHLKIB7XxHhLpVC246f?=
 =?us-ascii?Q?jWhzAwLVsf1/7WIKP0rUNJmckZETEI6fObDEdqaylkNaqixtbNtD8SQL+f9f?=
 =?us-ascii?Q?QegBkL5UDAoKbJAtfo5WJh6t6ipTX6Y5BsqQFPL3AFzVJnJRArZPfiS0Xf/j?=
 =?us-ascii?Q?NanbTbMhyaAk/RNiAXqwDF/krdwmJUEhSylYgtlm7eS5i2VED7PYg9zRtftf?=
 =?us-ascii?Q?yl5h7d2zWHM1Z4KRMIgFEaBo835ALkM9XNQzDDcyVg+BsKHEsNN7ryE7jK4v?=
 =?us-ascii?Q?39Cp94JH6vHJ5veaLVJ4f60RAyAmPQRucSkONJVd9WasAvk+tKBuDfN/AY8t?=
 =?us-ascii?Q?YFnMTOE4swAzujUlCHSfeYtITlKNHGA1XuhmInCthX12kf0RkeQjocbO+CRV?=
 =?us-ascii?Q?RMl5cSxnsekFsDt0nfvpSZf7ms1bCeBz3Gkhi2lEVJPeAofes6gkhQd4Mjjy?=
 =?us-ascii?Q?+rV3y9lV5hexdGFx7xAU1nt2os2Rk5VEL/s0TENh2CWElqCAcsJ86LslrFZs?=
 =?us-ascii?Q?DJzMYTSqQVHPnZyvz7Tm8idCJHHK65Qf1qg9BnnP3kZa5w+Tp7NKUJOFN7SO?=
 =?us-ascii?Q?cXJ/ICzdDRFEylZGAoABhxcO+PFbNxj+SjiN3TnS8ctz1Fvg/L3sI5XkfYiX?=
 =?us-ascii?Q?7SbFD/zLKGPmIVpXc0dnVfkg1n5t0ItE0SmKItP2zvfsO4xrsKZ0x+uSiIuw?=
 =?us-ascii?Q?doNyqyuNWoeIaEGxJJkpNwcFmdanW1V4S5deThgCvu1B59ed8CsKXGjExKpW?=
 =?us-ascii?Q?aPPhLu+3gqHXR3gDnOQ6oNsbYtQleJCsFNAZU5+opdr4Xn8olHYfVtuQ8Lmo?=
 =?us-ascii?Q?cCoO2MaznMqdSdotAbCLizuebbGxyNRaLK6dQbdxdvRvRPAKsIpHTJFT/7lp?=
 =?us-ascii?Q?zMf1RFBhyEk237S3iS/MhXu/6dns+zRg2pdcJCNBECzA7TRb3jE7VOcZv6sY?=
 =?us-ascii?Q?9gzYSwj2A4rYrFOjqPx+WCKF7T35V3X8Yz8ZvkNDYtL8iN/lnOlCpxz0tBlY?=
 =?us-ascii?Q?K4hQSYlz9TWxvaXvpN/F2+o2xB+RN/2DqIdgkXC/P+YaW4uXOP/lXFimFVj2?=
 =?us-ascii?Q?K55IMvcTvX8B86RAFoxx45Hz/Oy52Y8n7z5QtVcfrT7TY0majPMz59JhH41D?=
 =?us-ascii?Q?maGDx141WyaqnY2vtgVzN0QggMcVjq/Nl1ae?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:55:46.2152
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39658930-78f2-452d-87a0-08dda84806dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD77.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6879

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

The new macros type cast the vector parameter to "unsigned int". This is
required from better code generation for cases where an "int" is passed
to these macros in kvm code.

int v;

((v) >> 5) << 4:

  c1 f8 05    sar    $0x5,%eax
  c1 e0 04    shl    $0x4,%eax

((v) / 32 * 0x10):

  85 ff       test   %edi,%edi
  8d 47 1f    lea    0x1f(%rdi),%eax
  0f 49 c7    cmovns %edi,%eax
  c1 f8 05    sar    $0x5,%eax
  c1 e0 04    shl    $0x4,%eax

((unsigned int)(v) / 32 * 0x10):

  c1 f8 05    sar    $0x5,%eax
  c1 e0 04    shl    $0x4,%eax

(v) & (32 - 1):

  89 f8       mov    %edi,%eax
  83 e0 1f    and    $0x1f,%eax

(v) % 32

  89 fa       mov    %edi,%edx
  c1 fa 1f    sar    $0x1f,%edx
  c1 ea 1b    shr    $0x1b,%edx
  8d 04 17    lea    (%rdi,%rdx,1),%eax
  83 e0 1f    and    $0x1f,%eax
  29 d0       sub    %edx,%eax

(unsigned int)(v) % 32:

  89 f8       mov    %edi,%eax
  83 e0 1f    and    $0x1f,%eax

Overall kvm.ko text size is impacted if "unsigned int" is not used.

Bin      Orig     New (w/o unsigned int)  New (w/ unsigned int)

lapic.o  28580        28772                 28580
kvm.o    670810       671002                670810
kvm.ko   708079       708271                708079

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[Neeraj: Type cast vec macro param to "unsigned int", provide data
         in commit log on "unsigned int" requirement]
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - Added "unsigned int" type cast in the macro definitions.
 - Added details to the commit log.

 arch/x86/include/asm/apic.h | 7 +++++--
 arch/x86/kvm/lapic.h        | 4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 23d86c9750b9..c84d4e86fe4e 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -488,11 +488,14 @@ static inline void apic_setup_apic_calls(void) { }
 
 extern void apic_ack_irq(struct irq_data *data);
 
+#define APIC_VECTOR_TO_BIT_NUMBER(v) ((unsigned int)(v) % 32)
+#define APIC_VECTOR_TO_REG_OFFSET(v) ((unsigned int)(v) / 32 * 0x10)
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
index 1638a3da383a..56369d331bfc 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -145,8 +145,8 @@ void kvm_lapic_exit(void);
 
 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
 
-#define VEC_POS(v) ((v) & (32 - 1))
-#define REG_POS(v) (((v) >> 5) << 4)
+#define VEC_POS(v) APIC_VECTOR_TO_BIT_NUMBER(v)
+#define REG_POS(v) APIC_VECTOR_TO_REG_OFFSET(v)
 
 static inline void kvm_lapic_clear_vector(int vec, void *bitmap)
 {
-- 
2.34.1


