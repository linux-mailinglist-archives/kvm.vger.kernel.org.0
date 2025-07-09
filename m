Return-Path: <kvm+bounces-51841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0EE2AFDE32
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:35:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBA14540504
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D4B207A3A;
	Wed,  9 Jul 2025 03:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UuRQ6EaI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DC3FC1D;
	Wed,  9 Jul 2025 03:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032119; cv=fail; b=o7kSFUvww8EBmjJr3kixU11dPBuBWdekhclEgyjxy/98ntuVK6osue1VWLujSLnM0+YjLYgKZ/WC12cZm3BEn1cCz/zknV1Oo21inr7JYiDBCD0u7VZtBeUw5LMUY+ZZo5C+wIREhoR+CekFibgft7A8/8A+2TR1dbHYCUx9zC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032119; c=relaxed/simple;
	bh=r5YVg8b5o9xn1HXVeOu1oti0ruEDO8Cj8uQ0wTLMID4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iX4Z+FgLD7P2CSdLm+CgF/4e7z80YmMzb+Xy40UrVYgydDJBQS8G7SyQHAtatg7v6If+DFpXsm/UOxikU77BJIvjNz5m1wzPsIj4IPYJRDVkHBBK3FSI55/BiNMI5+86oVE/KPbfYt8HkNpRsurC6ZJUkfLXj/zyOPeWVYPiDh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UuRQ6EaI; arc=fail smtp.client-ip=40.107.220.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w7WuNjVHmr6Nlo7qsLah/Jb5gYyVOLKr7zAwuK03LbTw571ZrspLsFlmcPv5OEVjcKaAGFu3flkKPAILf2JFtOwyY9Mu+OhBw4Lcyc+kVa9OjSODMfNPdc6GmhkaRYixgx7SZeNMndkNcg7WWNI4L5XVjhvhsZCYzpBjBQOdsRuL56T5ygc3TMYmLvOQagS7JNlUZGUp765GlRjj++35/G1Zqft0qY7ZDkYrCGvU/AN92eKJwWjrsUViBMRfREKvZDmHhX2flSRcOJu4/HLj4WH0v4TpPqDYqO3Q4WbaXzWLiiQkWh7qNh7TrTKUL3I0iBCeIiK5y6+P8qc8uIcwyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kFe6FOD+L5WOCkpQaHW2ewrKvgItm8WGXhJsGUji258=;
 b=wbu8cJv9rLFtqFdyfSveWyKbvq7+Ctp45sH0grf+D0YrK40D6INbtECqd5Vxr3EzZrA/SLbgMhZc8ZN7f83MpZUYPsnj5UCTYjbVZU/AmxluMBkv42WbocDr31viwYgVPffuSI3fMctRg/Fbn5vihUJgAkqSQUh8PzN+0tSs5Vl3oa6nHFySqudGe6v+56EQPMqtjzDKvwwnBdciYBYj6cgEEZ0NaP9Rch1Dz17PJz8ugEpxPtegJHfRiqFHbOX0O93vl6AZyOsUhKLT+leqD1lSrfsM3x2ADUCPt2XRSFO2Ge2fStu1Jr4f2uUg2CdXcw2Au5nCa4EVuPlVN8schA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFe6FOD+L5WOCkpQaHW2ewrKvgItm8WGXhJsGUji258=;
 b=UuRQ6EaI4boQJc2zTeIy/6a8mbJsiLp+q/PbiBWGRmm8DnhfPsJ//2bMimLtCY7DZcaxliEAE2h5B5C1lOVbpcXE8eq3jrxb3VjeY94Pw3bxamct3zB0gD5HqWWxofyFAOzBXXLWn/dzAjssy1QyvWVN2yObZwm4D0aM8ONATwc=
Received: from DM6PR07CA0097.namprd07.prod.outlook.com (2603:10b6:5:337::30)
 by SJ2PR12MB8135.namprd12.prod.outlook.com (2603:10b6:a03:4f3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 03:35:13 +0000
Received: from CY4PEPF0000EE39.namprd03.prod.outlook.com
 (2603:10b6:5:337:cafe::47) by DM6PR07CA0097.outlook.office365.com
 (2603:10b6:5:337::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:35:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE39.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.20 via Frontend Transport; Wed, 9 Jul 2025 03:35:12 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:35:04 -0500
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
Subject: [RFC PATCH v8 07/35] KVM: x86: Rename lapic get/set_reg() helpers
Date: Wed, 9 Jul 2025 09:02:14 +0530
Message-ID: <20250709033242.267892-8-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE39:EE_|SJ2PR12MB8135:EE_
X-MS-Office365-Filtering-Correlation-Id: 82941724-ab93-42cf-d7f8-08ddbe999cf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BlniXYXktCxe+eEf6rg9kScx+kwJB0UHbnx69nvoyzNgNGUXogSt0wg3ana4?=
 =?us-ascii?Q?SDK8EW3gHWzJp3stFK5I01vmX+8mLBoRN0n8XhHqiB5+WxD5iJWv5CSoWYn+?=
 =?us-ascii?Q?OzhioOaeneBptJcPAgk/bWUMQgxUBXI3PaE4/lzyyBH4escc677sjWSQH+R1?=
 =?us-ascii?Q?dcfDfs7LxV3FhLbWCwVjbDtVFECGLObBiPA7ouG9tFHasHfXrLqGAgFij1OJ?=
 =?us-ascii?Q?JApIwyagCvuByiR9I3J6mv35bF6KIemA0qhLv2ehqz3UWxbxPvWVE8TMBWdn?=
 =?us-ascii?Q?8Ng/0s545QWZ5owZFpNQGFCyujLDVWve0AOXCyds7WFyIOlgiANMU/IhGsLS?=
 =?us-ascii?Q?VOmb2stzwtiKI+F/izQYYpREANmyRAPDZ1iaAGERCeYnVCC9vrQhFj32ZlKx?=
 =?us-ascii?Q?Ge6GBVAV0qbditMm5GN1hnB43xWqqfGR61JKrVUWcPkqrG1iaRd6Q9iUsVvN?=
 =?us-ascii?Q?OzXgC09lJsWYKBYeumgONrPuFRbXAZyujCVNiwYyeSx/fXQVn8nsTJzw25c/?=
 =?us-ascii?Q?Vie9NT1MAAvrXb22TSocWR+LrptDOiiVhwmfCE4u7n1rrX1GWITmg4tr3lMS?=
 =?us-ascii?Q?a+jJzB0TAact7MlHit87p9ef6qm1SZqWSuXaIvxWpWy+YG7fWINK0LNEAx3X?=
 =?us-ascii?Q?KEBbI0Icqu8xHauTtYAKVtzbv6Fc6yoclWYBFd0SHKpFQ9eZu8A/qIFWvV6D?=
 =?us-ascii?Q?z9m0pemncP++WCAaDaqIGzvAc/tuR9CdReHJ4CRaTtyAris4X++Yx/BGOth4?=
 =?us-ascii?Q?npfHWwC1I5AJ/RHNJy7bzHnQaLYwLczJs3SlaIPcX09NQjHqp/Kdsns7lXrg?=
 =?us-ascii?Q?Iu26HH8kNEB15L1JH5K0yXOw4rmf0TKCalV2coFm3bEJ9bKT+p8CoJ0dPqvn?=
 =?us-ascii?Q?teinITvaopw6QH3Ke8d6VzCajmbXnr+k9VGKLsojcJlXyd+gSlkaOWE0GU8j?=
 =?us-ascii?Q?LLlJADaevKQXQgkc87wLVMNRmX7OGa0E4lCB0I/NCSvLMsiPLUc3Y4OshmhF?=
 =?us-ascii?Q?/sZ8oI3cyR1M/eSi/50QkxdnIBvk2nfNEhczPuyf+pQaWWPGvS/Rk6THOuvf?=
 =?us-ascii?Q?fsS45XmuWRt+0BOZYnSODTJXzkN66FzZ8/DIbEaQpMrkJoqsi92qXIrNZj/x?=
 =?us-ascii?Q?iL/w2Bzy0XHbAmUfMCECTJDSeYj2VXUqk25ZFk7o0OwH2BTtdcKmjcgl/WvO?=
 =?us-ascii?Q?89l9WLePTnXMcEoLdVQ0vHNqTXX+g7uPLpVqo9MikRBJamkHtlZgpUnkN5gY?=
 =?us-ascii?Q?2Vv5jz4SnKIK91J0o+7nvhFpIX67VR3u1UDxNM0SAqYWdEh+rqf2iEHKQsJw?=
 =?us-ascii?Q?xqTkIKzjeRWn20qCs/MrXx7NfnNObMPftX8JVFnGzg1mO0FiuL6+jdNUxysp?=
 =?us-ascii?Q?ZB0VRC3PyoRIO+bxPk3fFmEqoqxZMjAmKuwUalWUgYTgt6ASy2fh9/gGyl3l?=
 =?us-ascii?Q?YBhKfHAYWZfXBcL0wH8nBlaKC5AKQYRloQgzpOmh/c2CNxnMGwYnGSqVa4ij?=
 =?us-ascii?Q?efaWb7Jl3szDr4WKaDaZRS4gAsjjY7BNy8oU?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:35:12.7912
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82941724-ab93-42cf-d7f8-08ddbe999cf1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE39.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8135

In preparation for moving kvm-internal __kvm_lapic_set_reg(),
__kvm_lapic_get_reg() to apic.h for use in Secure AVIC APIC driver,
rename them as part of the APIC API.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - Commit log updates.

 arch/x86/kvm/lapic.c | 13 ++++++-------
 arch/x86/kvm/lapic.h |  4 ++--
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d71878a3748c..da48e5bb1818 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -79,14 +79,14 @@ module_param(lapic_timer_advance, bool, 0444);
 static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
 static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data);
 
-static inline void __kvm_lapic_set_reg(void *regs, int reg_off, u32 val)
+static inline void apic_set_reg(void *regs, int reg_off, u32 val)
 {
 	*((u32 *) (regs + reg_off)) = val;
 }
 
 static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 val)
 {
-	__kvm_lapic_set_reg(apic->regs, reg_off, val);
+	apic_set_reg(apic->regs, reg_off, val);
 }
 
 static __always_inline u64 __kvm_lapic_get_reg64(void *regs, int reg)
@@ -3078,12 +3078,12 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 
 		if (!kvm_x86_ops.x2apic_icr_is_split) {
 			if (set) {
-				icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
-				      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;
+				icr = apic_get_reg(s->regs, APIC_ICR) |
+				      (u64)apic_get_reg(s->regs, APIC_ICR2) << 32;
 				__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
 			} else {
 				icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
-				__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
+				apic_set_reg(s->regs, APIC_ICR2, icr >> 32);
 			}
 		}
 	}
@@ -3099,8 +3099,7 @@ int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	 * Get calculated timer current count for remaining timer period (if
 	 * any) and store it in the returned register set.
 	 */
-	__kvm_lapic_set_reg(s->regs, APIC_TMCCT,
-			    __apic_read(vcpu->arch.apic, APIC_TMCCT));
+	apic_set_reg(s->regs, APIC_TMCCT, __apic_read(vcpu->arch.apic, APIC_TMCCT));
 
 	return kvm_apic_state_fixup(vcpu, s, false);
 }
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 7ce89bf0b974..a49e4c21db35 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -165,14 +165,14 @@ static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 	apic->irr_pending = true;
 }
 
-static inline u32 __kvm_lapic_get_reg(void *regs, int reg_off)
+static inline u32 apic_get_reg(void *regs, int reg_off)
 {
 	return *((u32 *) (regs + reg_off));
 }
 
 static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
 {
-	return __kvm_lapic_get_reg(apic->regs, reg_off);
+	return apic_get_reg(apic->regs, reg_off);
 }
 
 DECLARE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
-- 
2.34.1


