Return-Path: <kvm+bounces-51840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A2B4AFDE30
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E67F3BBF44
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E166E1FF5F9;
	Wed,  9 Jul 2025 03:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gTaEDvl8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2060.outbound.protection.outlook.com [40.107.100.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA91FC1D;
	Wed,  9 Jul 2025 03:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032098; cv=fail; b=NJmfsGnMoCuIKCjGNUqSEpRKkkYXOOCnHawiMfM0T3jq2b3lSKwmNV7AMT9Lwv1MacBTLV07vvRHywo+UIj/apg5KKcl3+WZUbhVH443DRwrkXFZD5sSlLUDwQF/KUhKF1o49Ye3eHgybAEKrjPqdmcBcfm6pdnd+50YN0Kq3vI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032098; c=relaxed/simple;
	bh=/Sf8/GlUskh7YBTH0kvepuMQpKgY0K5YKN7LIVQc0jk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DRFh9W4KLN2Hi9Ft1lBk/cwk0xR3vztgAYTvSZAGF2YWNny7uzqFVQ3d5CBMnmYa8CIP+Jo3RxZF4p75GuJRFKQoBRF0KS94lHtg5oJttGUaV+etWkj6hS+SE6gsAIoxBi7m9IHTvurZw9KHsXrNwcvqYMJ2Qz4nLjlU2ggw3L8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gTaEDvl8; arc=fail smtp.client-ip=40.107.100.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AB+tEf70cYuvO2XDOCdf3jd7MaYvdGd9XVn8G4wNeyPTKcH6LDQnnQuU04xhYRE2pv6nMQQ5rtdZX06AVR70pyhNKvQwFi2PGefFMCcFo0hLVjx4ALfhNbntwxWftPetfsvg4aXgIMNtjA3BhoQCk66CzRTVnjXLmgU7yth6fH3I6iCpGLPLQ1BdC80BfyapMnNfbuzyE6WoOA19NOFl6LzEgbCFKM0fE/kml1ZqGtJjusZD9K2OziGlL7T6CTRUu+HjY89a9yBk3Xc14a6zCJWBKdS8VQoDDLx53uTdC9WqPUNvHQGpUM1dNdDCA8C74jfFYF9Jg42pNyZ/32yPcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BqnI3YLjmCuJFKwi2G5vbMdM3w7IwOj3fLSLFKCuepA=;
 b=Fr6DFy/Y0QaXiXV6sbx51Ri6zjysJDVYSuCcxNHGyh+feJKB4yS5lw2h6aZiuw7B+tNN135rLL39YrzvmAqXAlPIM9hedNNT7Um1UOydI9VNiJt0Rm6uKp0SWPumr5SqcYm5iL/PLGulJknk3gp3wWoyrqzgrkz5cIQPNay4U2cJsRGwdq6eiASENMGbxHML1J++flm+mEg8IO4fqhddGq6KDV4O7MVvpeWnLy0ATk7AUGDKwl1ye4gBc2HblCHkRFGho/jtXWV2QykyQFzpim/P/51gj91iwjnapBJB3yYhafI6gGDoc7zenqDqO1eSUvYGTGv2Nlh9rvFhmdNqHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BqnI3YLjmCuJFKwi2G5vbMdM3w7IwOj3fLSLFKCuepA=;
 b=gTaEDvl8EdS3u3tJAZnIlyZvwbtjJHrjYH2Njfuy81rMNU/LH+OO2+08+xauQmAyOG1Jq7kUhVFcR8AQ8DmoO6fs5fZF/FNI3sT+PYqNxImKM8cuE7m/1VUylrmPB40RkgLLRXDRi6bahw2rxbTFVl0/KPR7LLCCYqc/z6XbwQY=
Received: from PH8PR07CA0019.namprd07.prod.outlook.com (2603:10b6:510:2cd::18)
 by PH7PR12MB5880.namprd12.prod.outlook.com (2603:10b6:510:1d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.21; Wed, 9 Jul
 2025 03:34:52 +0000
Received: from CY4PEPF0000EE38.namprd03.prod.outlook.com
 (2603:10b6:510:2cd:cafe::40) by PH8PR07CA0019.outlook.office365.com
 (2603:10b6:510:2cd::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:34:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE38.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:34:51 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:34:45 -0500
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
Subject: [RFC PATCH v8 06/35] KVM: x86: Rename find_highest_vector()
Date: Wed, 9 Jul 2025 09:02:13 +0530
Message-ID: <20250709033242.267892-7-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE38:EE_|PH7PR12MB5880:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a7cc0a5-530f-4519-31b2-08ddbe999071
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aVN0Ghiahy+68WIXjKumh62AYiQIq5xQiT0cdR7eza4RqT2Yp2WpkHk18o0p?=
 =?us-ascii?Q?6uZMu4M0CNK5hz/8vaMleuGbXMhht2x06+YkzoYTI/VzaXTD+b/pfEe2FdOL?=
 =?us-ascii?Q?m0LblmL9IInw4H3IKW0icEeP6LBKNosmwIVtrskhxT5M0FlTvjoDwl9z8cTI?=
 =?us-ascii?Q?K4zef7JePMfRhRPquHKSmJY7V7sbPFaUIJed8G5jmi7cftoxSBv0iwDTUwLo?=
 =?us-ascii?Q?HHthHOfXJKFSqBEIyuo2dQpIjodDD15ddcX3fcoSg/306zoCelmmCqVBWfW/?=
 =?us-ascii?Q?qcFGaqgjFe8qkKsBNnBSNe8b1gGa1afS4toGYPhiac62nimQ2uYoIk7A8yae?=
 =?us-ascii?Q?Lsce/fHUyBGeMJxdI5D/sj/cwn9260wm9tWUskSzLDTItja4Vn528ILYwWrm?=
 =?us-ascii?Q?gwjhxh45V4U9cBxduvXFCvWtbwPekSbOG5CJOP27K8l5Nx7A0B5ErbkrCDWq?=
 =?us-ascii?Q?48O3b1/jo8ofHuEPCb9+f0Z4CnNa+ucE1kX7vU7XsvyHq1B0BSHgzbb23j3Q?=
 =?us-ascii?Q?np6NXDcJFBOA/+pFe80ggp/zxT8Xmd/aitU4YwohsLDKD3kbnHLkQDCcIDei?=
 =?us-ascii?Q?+GYe9/vSKREmBrdjdpQue3NJvEMCMdJPcYzMvwKx/k6UIQ1N+SpQp19S2ica?=
 =?us-ascii?Q?nAThDhXNht9PJU5qJ8zhAGE+3/mzqNEq6dE+yJbEcppnYHGiTuhH60eKQhj1?=
 =?us-ascii?Q?kUVpKLN3iAv8OL28H3vP0IoVjY7sqA7FzTT308uPwlposWO9kUy6gKIi6v/g?=
 =?us-ascii?Q?ty5EUpnzmh7opwCCP8JUp9DIL4VUGgHHZMWQZJEefwKemZUyrQGAqngzk6rv?=
 =?us-ascii?Q?dWwPRya6CDaAKYB4SyKa3RQDfCFK+JJEIs0V8lNcCgGZfYt0AnYzDQ8UBp8+?=
 =?us-ascii?Q?BktIWzHdCvpkihG5Dm2T2cFE/Bwk3qJknpsAJ9HR/8VsQ4MNnBigbL/V8f7d?=
 =?us-ascii?Q?ge6YWRf4L1tbnPZ8cCeQRyonR3YTdGgvWoAcvBIOZS71HNV4vOIeuboVKe0Q?=
 =?us-ascii?Q?RxmhTbi5nGrn7l69QqcfbW+gmudyTp7fqhctYxg9IAUoY78lca1w2ZcLR0F0?=
 =?us-ascii?Q?tbJo54kEO3Q6zHLQW3dI94oruRs+m0bV7qm38Chr6ihdSJk6icacrj4g39c1?=
 =?us-ascii?Q?zFJh6MDIiXJX9Iv4NVlQw0kuCE7IaNI2z4VwsjSo9HxiJwYygeBAJy+6oJFM?=
 =?us-ascii?Q?ZfPZ4DGUypicNyWVVwWIky/EGoePsNTBwnJHB0gHzSRNMQAzT09LrXd/E+zX?=
 =?us-ascii?Q?W0ZGPchVxPCeEY//bvJSk3NbH7kHHOJH0/n0HWAZR6QVb2OKkGtgOo9I3I1m?=
 =?us-ascii?Q?grAtVnY4EDiZUcIYjHBM+5iELh+cX52lc/AGSup/3tYxw+FafQljtATW3tgj?=
 =?us-ascii?Q?vTij3Lb3/8oeqNfY9LDpl/Cnea74Et6MhQaoh7UE37hMljDOdfihIpZKW43S?=
 =?us-ascii?Q?cELHnL+ObaeWhg0HR3c16cSi2VC5sjyHFGpNPcz21YF/lRCrcb/zhXBlJSqp?=
 =?us-ascii?Q?wjMdBeTkZY+vNmd9Qw0CpHq+zYGl5fu2N5JP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:34:51.8213
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7cc0a5-530f-4519-31b2-08ddbe999071
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE38.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5880

In preparation for moving kvm-internal find_highest_vector() to
apic.h for use in Secure AVIC APIC driver, rename find_highest_vector()
to apic_find_highest_vector() as part of the APIC API.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - Commit log update.

 arch/x86/kvm/lapic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3be5f0db892c..d71878a3748c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -616,7 +616,7 @@ static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
 	[LVT_CMCI] = LVT_MASK | APIC_MODE_MASK
 };
 
-static int find_highest_vector(void *bitmap)
+static int apic_find_highest_vector(void *bitmap)
 {
 	int vec;
 	u32 *reg;
@@ -695,7 +695,7 @@ EXPORT_SYMBOL_GPL(kvm_apic_update_irr);
 
 static inline int apic_search_irr(struct kvm_lapic *apic)
 {
-	return find_highest_vector(apic->regs + APIC_IRR);
+	return apic_find_highest_vector(apic->regs + APIC_IRR);
 }
 
 static inline int apic_find_highest_irr(struct kvm_lapic *apic)
@@ -775,7 +775,7 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 	if (likely(apic->highest_isr_cache != -1))
 		return apic->highest_isr_cache;
 
-	result = find_highest_vector(apic->regs + APIC_ISR);
+	result = apic_find_highest_vector(apic->regs + APIC_ISR);
 	ASSERT(result == -1 || result >= 16);
 
 	return result;
-- 
2.34.1


