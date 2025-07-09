Return-Path: <kvm+bounces-51846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83A75AFDE3E
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:37:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47BFC1C25CB5
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8549218ADD;
	Wed,  9 Jul 2025 03:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XbJtsRMU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2060.outbound.protection.outlook.com [40.107.96.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4231FBCB1;
	Wed,  9 Jul 2025 03:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032208; cv=fail; b=R7PJhKBe978gVIr9Et3d6DLjwcZXy2a/x/xcVCIcU4UQpGprBrJCTcupvnZvobTxGID8hY6GCfNmuuayMGgR3+PvHLP7BhRLX7gk+7jn83sjbAz+bjN6sWEXOEshZ3QZ1d/C97udtYxvIkHANzL/w90LVT0GoPG+4JWADL6Ky20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032208; c=relaxed/simple;
	bh=2WN8cewqKubiOM7Vcsz6SOOsNHrAh8zSawJ5b8hH/4U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DrgorfVpR/kMRIOW93+0nbf5q060dANrVSaeN4QJMeY3KAL5HDLp6e3y5CwiUX4EpYawoGF+ivXXWKi4hHnE+YphClDWvo88UOz3MtM4beupO6M7K6XFjeawnD6iIcLj6a5BSfPiJBFAnAkq9pwFirvKx5MIhRH0bE5t87+0DIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XbJtsRMU; arc=fail smtp.client-ip=40.107.96.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DhYLKxfjGPNKKDsaF8maRSMcjSLDDzFVC83sN/qCrX2nQAsazrEaVaeWsijRA7mA62IIOuBsfkFTfhkqOkuBRW4h/iTaw280LmwDyHQim79n4TVbkhVpJKItsQDIUZSk/1ThZX8Q3SNjuXH/c/A+VM9A1yoaQ8Et5A463rSnD8V+j7VspKfkWDAukamJbMi3E6Ls/p3qix1aUoLLUl4DaTJTdMiC8GjVPmqq+ZUPHALzebMpdyyb6R28ZJnptc4Y4NSUJs5iFeGuu38lGLsm7IAwQW0Lli1twGkzOk1GoEU23NhGbrwsO64bOYAMC0H9L1K84Tzinz07POBFoDoVkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WO3eTxIIKiGrWIROyfpyplMc9sCPiyO2Z8H0FYMoaGU=;
 b=olumf21uoZaIkl5wc6JLTmnVzLvPLAOLqTse4guXJsO7m44AaTXjhtF2lt+DNky79gZHhx1jKzAqYqp2fn1To2QIY/QYzKKdUmOqd7LWyh49X9iyboy493WqRYqbU9GJqLzk0wcXenUjTp3NwOz0oOfc5q56ghRMtqV/qXFLirIMDJaZ6GCo0HxPnhm6NCjI2WNW+MpOxWZCt8z/hAJcjRu9JkqgijS01zw0mzq5Nld2j18JKCSit0CCdrVxwxR09uwOn+68E8jIiR+ACgFxg7mytHIeFb0wOI55PRJXiYEIWmH1I2litLrF2VaQrg+JvdXqGGqxoLPORSbGZXgcaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WO3eTxIIKiGrWIROyfpyplMc9sCPiyO2Z8H0FYMoaGU=;
 b=XbJtsRMUoqiAd80GbbX/EbZ8KU0hYFdMvlk+cRowlhnV/T1boZINOodriyEDlObG8cxG4FXtfF6GkyC8DFrHH+nD/4Xmv/J/SDfyekq6l06lVeVdcoE+1ERHBEmaAvbq1PGMJ/3YQDkhnUdM3Od+NBJBOD3QKXJ6jvVImEPeOSs=
Received: from SJ0PR13CA0183.namprd13.prod.outlook.com (2603:10b6:a03:2c3::8)
 by BY5PR12MB4308.namprd12.prod.outlook.com (2603:10b6:a03:20a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Wed, 9 Jul
 2025 03:36:42 +0000
Received: from CY4PEPF0000EE39.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::a0) by SJ0PR13CA0183.outlook.office365.com
 (2603:10b6:a03:2c3::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.5 via Frontend Transport; Wed, 9
 Jul 2025 03:36:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE39.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.20 via Frontend Transport; Wed, 9 Jul 2025 03:36:42 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:36:36 -0500
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
Subject: [RFC PATCH v8 12/35] x86/apic: KVM: Move lapic set/clear_vector() helpers to common code
Date: Wed, 9 Jul 2025 09:02:19 +0530
Message-ID: <20250709033242.267892-13-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE39:EE_|BY5PR12MB4308:EE_
X-MS-Office365-Filtering-Correlation-Id: 13ffd6e2-5ae5-420c-3dbf-08ddbe99d277
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Rz5K5yI01wl+7yH2xQHLQyJoN/kHrtK8uFcIgPEvg+gL9ztZD1WnU2vbO/UB?=
 =?us-ascii?Q?SfR3tshfBzzxbzukxVpqfFixYHKatsOnTDcseDxeTmaoK+sXuwHqLsnzhItO?=
 =?us-ascii?Q?P2AJtsjifgUh1r0+oyTLpN7wkwjR0Yh/Vq+cIRdXqozxmGDkWzymZIz7yM25?=
 =?us-ascii?Q?QoYDeZaZasaNidDZWvnBFl5Qns9jN7T56eCVOhaQUszv36ctDIcWLY+6S1vP?=
 =?us-ascii?Q?j+4u2O1h+qNye8bqOjBItVAJSNJOw35tuGLkf/SzZaWW9b90A82CkajcPBno?=
 =?us-ascii?Q?rCJY4j1hONvbdWh+WWyXHlB+Iq92wG7038gqa3r4UWQ7m+HS5KKMGGnQeVFn?=
 =?us-ascii?Q?HNp51F2tt06fltSYhJRFNEzw6uBlEWLb+7iH6bCNLX0uW5dBehB2O/fpB0UY?=
 =?us-ascii?Q?N7YoMWxnYs5xPENKd3ohn7ix7ZaAAvOrACTvdu25mpR92S/6700eKX8pghuM?=
 =?us-ascii?Q?gLnwIekArCkgbv2lrsSvEUS8Ouw9LdphaxQJI9UEa6bdvPujXZDf8nY8tqrN?=
 =?us-ascii?Q?bjo90JHifQ9btvx4EeJC/UyX1esLgLcX20RMPOKH85OC692l7yFXjFkS6mWh?=
 =?us-ascii?Q?aj0HX1sKqVOdJIaR4j2F0yAAwunm4wI4eMO1ef1kpHXtYsWd5q2DxCefHkNt?=
 =?us-ascii?Q?Aqv6i4R9wy6jeBJgE/rKCwywfu8KAiLtTcquqsbiTbiB+8563+Cf6LVfiGej?=
 =?us-ascii?Q?i52SbNW0jl6q59sohJ6sXLTDQ9mbHnAbhgl7WeT1NT3aWBDYRcA+ytX4s/p2?=
 =?us-ascii?Q?CiIDmBYkDdqEg0eR7jmfpZa7f2WjIlPX7fy8sNgf0UnEruD6OkB4QD9bJdvn?=
 =?us-ascii?Q?xJfgw4xrt9rgWIAFnHpi6/aWjRWmoRsUckJVR1WorTQVfEVaXQszJOmJEgd2?=
 =?us-ascii?Q?c+ecTv5O7Lj37Uc0M9HwDbGaH54Gp1e9gH6Z2OuZMc42rhMfZLBHlq9U6XJX?=
 =?us-ascii?Q?rWHiKqHg9GFR87elN1NOHvsvsFG5mo9DofoxzzKNawOhBmia6wGnm2NRKaiW?=
 =?us-ascii?Q?hT4u3Y4hHxEOiS04wv8jXBD4jbjFOqRDf2OmmOwgs1lBDVo92+x4F7oDwMFT?=
 =?us-ascii?Q?zizJTG+WI6rTvmJ5oO6X1lsN5x1sx0XnMvuJ24wi4M1hwzEnXQzaUMSzicZf?=
 =?us-ascii?Q?EYn1O3bMRrPj0cv8fVXXS5MvNJjZRywnH4+Az7JOu99sgWdNq4S6f4wwFQEE?=
 =?us-ascii?Q?MdmnmyPHDnCkoH44j07aqLcYrXROUw3Eq5GGOFVbvWHkGsotcAnf8GhTGWrY?=
 =?us-ascii?Q?gPUu97EIz1x/TNRyzzooGbKLISdH8PMkxVKUdUA3JUKuBfMuP9N/ZmjOfeHf?=
 =?us-ascii?Q?hlji0taFPerB/rS26Xcqp6i+rFpGeLh0NYv5pTcKRIYYL45Wrd3QXapiXonY?=
 =?us-ascii?Q?40hEXd/e0lRnrvUTPLgD4/vscMWqH1ospYKTAk77T9tKqVAa6BMNJKvBAz3+?=
 =?us-ascii?Q?IrEjB/th+LGrjBrfRZTELqvOsP9hOD5UpC2vfCNT3P/6YdU7UZ3Vf6NFYie2?=
 =?us-ascii?Q?04zX+ogFjTLyD1Pvul7K5USowmCdaZXoW+5J?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:36:42.5911
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ffd6e2-5ae5-420c-3dbf-08ddbe99d277
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE39.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4308

Move apic_clear_vector() and apic_set_vector() helper functions to
apic.h in order to reuse them in the Secure AVIC guest APIC driver
in later patches to atomically set/clear vectors in the APIC backing
page.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - Commit log update.

 arch/x86/include/asm/apic.h | 10 ++++++++++
 arch/x86/kvm/lapic.h        | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b8b5fe875bde..c6d1c51f71ec 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -547,6 +547,16 @@ static __always_inline void apic_set_reg64(void *regs, int reg, u64 val)
 	*((u64 *) (regs + reg)) = val;
 }
 
+static inline void apic_clear_vector(int vec, void *bitmap)
+{
+	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+}
+
+static inline void apic_set_vector(int vec, void *bitmap)
+{
+	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 174df6996404..31284ec61a6a 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -147,16 +147,6 @@ void kvm_lapic_exit(void);
 
 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
 
-static inline void apic_clear_vector(int vec, void *bitmap)
-{
-	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
-}
-
-static inline void apic_set_vector(int vec, void *bitmap)
-{
-	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
-}
-
 static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 {
 	apic_set_vector(vec, apic->regs + APIC_IRR);
-- 
2.34.1


