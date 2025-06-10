Return-Path: <kvm+bounces-48829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84BC2AD416C
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6F8E3A6206
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 193B7247295;
	Tue, 10 Jun 2025 17:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eUjlMnWp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7762367CC;
	Tue, 10 Jun 2025 17:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578369; cv=fail; b=YCFhHOei7irs2h0FVtnrYs6QDSW7XUqtnMQbOaq1CH0qcRCUYM9Z3YoaFpWlFTsLsKdeam/KhpdrokFAR/zvJaqGbuikS86zplJ8BbfTPUKkYLIHyH5zJD7FIPSnAZkEcWZUCSPAFoB4fQoDWGKSlDECV0/o8hNtqd3xedDFGNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578369; c=relaxed/simple;
	bh=kyAlHv6fSGpTYB2S2zREAhhGR/lathoMM1HzGeJGREY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZAPbfDGYqJ18vw9WsDXSuQnm5M5GzTfkFVrHuPLQHPhQNN6DEb6exQUH1nNBz7BymmDHsSwcnEuLls7DrA99yZfjhGAlF/aj6E9KhsTEQ5blPewTs7gcpu0N91aBcpeR5FeHiCFhW5SEw79ELLiMAKVQ4BKnZsrXzSau/kTapWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eUjlMnWp; arc=fail smtp.client-ip=40.107.92.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w7uV+4TtJS65Eo9DRDTGdgWNWp8YKzbOz+uJiH97e6MXUHmriHUqOqqpBA0/zFRy+D/QW+qKYillrl9VURGv6H+6E8RwY+PzAh3lA29ltWdKv65/qXkdPTk3DqQoohi61CRlMpR0tKFSJXjkAZRELNnSkc/jenAsAKP7b0oplnkCIc1bEHz0QMCreDGeR+1NAwFRcRDErpQ0ESr0NdBWkV6stXaBfvQnUMGVPosSaR8mPvj1pH5pxZNEmCSAzdLT3JaOW1hDocecP7S2UDoCByP1OerueR2wgUg1t6nnM0l2AVbaoGFIiI5BNzbmGUXz1khnxLXm/iNedLi2oMR0Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hXCNYsidJXwh/Q2E09a84rchXWbOpJjqAx8+HA/KdWQ=;
 b=wUXjbgOQim4XtYiO0ObarcymiJgjbGoS72SRCWIfHIET6hSQMWVE9fX07Uh+1W2Zz7bWNpLmBdhcRFV/bfZggFjOnaJw3i+9JIIBCZvgmQvyjfQKI7BWYPw0+5Vp02n9pKWQDZ7mYSvknXYbLKVGcSohKw2fNVyl30ZOMo39hAERZoiYZaepP0mtsGRqloSGGA6wEWdViIvRoR+jv7r7wkHY3DgVre/Yn16V9yOdPfhAMrUeIWug+eNWH8Bfn7rkzG24kk0SZSODRwlIdbTnptdcy093ChKBWwE8RBLuSCeMszOgoVWbdaQsYY9YVbEX65CelCnzGZ/eTC3py5tJ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXCNYsidJXwh/Q2E09a84rchXWbOpJjqAx8+HA/KdWQ=;
 b=eUjlMnWphszlY1Dlw2xy024hfBBlQBndWZC7iSjLLe+aruxylP55b/C9KpLxApESAM/dRv90eSeFbG7QeH7Fv1rw/ukSVkaMHSFidYu7H3e6pCHcAfovszz4Cm5jauDc3QsJxsg/n3bLgnPhc9Pvu5LQiqsbQ7fAdk8Ny1Z4gRc=
Received: from CH2PR02CA0022.namprd02.prod.outlook.com (2603:10b6:610:4e::32)
 by IA1PR12MB9062.namprd12.prod.outlook.com (2603:10b6:208:3aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Tue, 10 Jun
 2025 17:59:25 +0000
Received: from CH1PEPF0000AD77.namprd04.prod.outlook.com
 (2603:10b6:610:4e:cafe::7d) by CH2PR02CA0022.outlook.office365.com
 (2603:10b6:610:4e::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Tue,
 10 Jun 2025 17:59:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD77.mail.protection.outlook.com (10.167.244.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:59:25 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:59:16 -0500
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
Subject: [RFC PATCH v7 13/37] KVM: x86: Move lapic get/set_reg64() helpers to common code
Date: Tue, 10 Jun 2025 23:24:00 +0530
Message-ID: <20250610175424.209796-14-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD77:EE_|IA1PR12MB9062:EE_
X-MS-Office365-Filtering-Correlation-Id: f5512773-5b95-4f6f-606e-08dda8488955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sDI76/BmdD68ACvwo6lT+oiM+tkUE5aOKm+G6vKQ25aoh7MoSuHd+Vq5L3CB?=
 =?us-ascii?Q?LffJ3R0UxKBqyt1jsIGstuJTovvxLDmqijCPHmLasWYh9lL2DLs9VJ0kQzgC?=
 =?us-ascii?Q?0CySCLCkUg6JF+R7U6yh3WSmqe7846DJB/vcoqRoaAIcALhkPNFYjZPtkgjS?=
 =?us-ascii?Q?HMRCU0p45Erv/fL6K15YUURQp/DMmoT2b/dC/n4cD8bKxEC6u7FXFdPzcYUQ?=
 =?us-ascii?Q?Hy3Frzkgs0YWFITCydOymRYAhKHSu0O+Ji7D6ZTSKsBkWRshzLIpB7/Sit0M?=
 =?us-ascii?Q?+9y60z13VAQ0IbjBStluODCrbaelWYhrIGnLItBKiK38IWzF6GDvIGm+1poq?=
 =?us-ascii?Q?pGOL/jrPH8p+fAv5FLjBD5yPvozY+zR193hO6lSWvTe8la61Ab8JRZyzkQwD?=
 =?us-ascii?Q?3c/p6ixN+1KjJ4tDAeS/olScio2UwZFCKkFZyXBnfgnapNTZ/kV/PYBEtEws?=
 =?us-ascii?Q?0lnbLRDBWMCpCiZVgxAZYzlVhVP5jsY1WyObC18BltmrfZ7C7KD2DpN59CwL?=
 =?us-ascii?Q?cN8rIMX1j0SWqtY+soAlGcZhiKyhgMZ0TZfA0CMIGs1TLo6Cw8lOtt5fbXCG?=
 =?us-ascii?Q?6wtzqXR9eyhqA5/71/Ihts1In//WHOpowXBrN/X+wIEXeQ5XQQPdzhFnOdUR?=
 =?us-ascii?Q?DkUljdZBcNv0c3Q4PTAdG7DVIZPFWo8MUmGYC6PdcZxE2zIQvz+jk6ilLfDk?=
 =?us-ascii?Q?aum5QyoTHWbm8C0h3VUeWINGcm9GGrp2s4sHycuhx3VP3qSKac8tZoXygkIb?=
 =?us-ascii?Q?5adlJ15hYUHiHf/drBdcbGAvyvvhOyoxFxz63qJFIeF04+xuZLj+zJ4Hxlmo?=
 =?us-ascii?Q?18+epXhyFnnsmtJzUS4FxmQp0ksNDOoeYj708sOZm20sCtRCW9NnCVTruny2?=
 =?us-ascii?Q?LSYJ6OHIwv5kXTF5BrL4L/Q+AFONRItEzozu6udyKj4rzbUqs02hZGyqcB6k?=
 =?us-ascii?Q?CsQQbfpgeorVyLIFv82+Zb9tQL7ov1f0fFr4fi+dElaq9VKDKQWkkUCX889u?=
 =?us-ascii?Q?PtPx6QGHIpu7Ip2BWbK0Sv6TYtc+qBu4KYbsbIAvCoRAtuPw+TqfxWy1FkU8?=
 =?us-ascii?Q?L9YNSKrKwnknRwh0PyUr64cp9wrXPQyWi5AnNEll0868Vph+l6dp8edWHkjB?=
 =?us-ascii?Q?LXLTeDOl2UXtD6k/45ouLThenHtRirohO4vZyonIVz2jUb26jX4L3j2OyLV+?=
 =?us-ascii?Q?PD0bG69VBDD2UB7qCXSx1Y+6T3LKdbdVBSofYDRXokPGuvXuNBTbnebnYATd?=
 =?us-ascii?Q?ggfDeI02yWW8nYDY3Kc1Yf91Rm4SHOvrfmAlFEk4H2pUlFwWG8UvrdIs3qJy?=
 =?us-ascii?Q?myDWlO2zKXQSnvPhPWxGLKa9mgNGM0Iax8417Sf/GivpOJsFAmTWoe9rUPCI?=
 =?us-ascii?Q?DzUT2n1aEk5aT0MazyV4r0MedZJdGYsQOcdNAN4m/fP6Vwn381Q6r9s/n5iC?=
 =?us-ascii?Q?8ih2fYlxPxKpAC/cej6YDMN/NxlycRgREubbIgM9wIBnFEHOjqPD74OiqMAJ?=
 =?us-ascii?Q?+wwsFPCCwhyLZZm/zp8P+Ew7X5dOQor17Xca?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:59:25.1095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5512773-5b95-4f6f-606e-08dda8488955
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD77.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9062

Move the apic_get_reg64() and apic_set_reg64() helper functions
to apic.h in order to reuse them in the Secure AVIC guest apic
driver in later patches to read/write APIC_ICR from/to the
APIC backing page.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - Moved function renames outside of this patch.

 arch/x86/include/asm/apic.h | 12 ++++++++++++
 arch/x86/kvm/lapic.c        | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 904029f6530c..b8b5fe875bde 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -535,6 +535,18 @@ static inline void apic_set_reg(void *regs, int reg_off, u32 val)
 	*((u32 *) (regs + reg_off)) = val;
 }
 
+static __always_inline u64 apic_get_reg64(void *regs, int reg)
+{
+	BUILD_BUG_ON(reg != APIC_ICR);
+	return *((u64 *) (regs + reg));
+}
+
+static __always_inline void apic_set_reg64(void *regs, int reg, u64 val)
+{
+	BUILD_BUG_ON(reg != APIC_ICR);
+	*((u64 *) (regs + reg)) = val;
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b27f111a2634..85bc31747d54 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -82,23 +82,11 @@ static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 va
 	apic_set_reg(apic->regs, reg_off, val);
 }
 
-static __always_inline u64 apic_get_reg64(void *regs, int reg)
-{
-	BUILD_BUG_ON(reg != APIC_ICR);
-	return *((u64 *) (regs + reg));
-}
-
 static __always_inline u64 kvm_lapic_get_reg64(struct kvm_lapic *apic, int reg)
 {
 	return apic_get_reg64(apic->regs, reg);
 }
 
-static __always_inline void apic_set_reg64(void *regs, int reg, u64 val)
-{
-	BUILD_BUG_ON(reg != APIC_ICR);
-	*((u64 *) (regs + reg)) = val;
-}
-
 static __always_inline void kvm_lapic_set_reg64(struct kvm_lapic *apic,
 						int reg, u64 val)
 {
-- 
2.34.1


