Return-Path: <kvm+bounces-39684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A4721A494D1
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5550B189530E
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB29F2561D6;
	Fri, 28 Feb 2025 09:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WYBCQThN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDD71C2324;
	Fri, 28 Feb 2025 09:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740734683; cv=fail; b=iZKu6cowlyuTdZOAdVaQJjwn5yUfj2KmvBvbe9zOqZeZnGWs33Lrxv/ueSb4jnUunAwOEkmalQ1CYWjQNIV7bsXh4P7jbbtOP4UvEwaKzsFMMGek++ivLO5bJPWini2SSNzEMyOdD1QQlEkBj3y5Kwv+q2AE0qOCCfCfnpv1txY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740734683; c=relaxed/simple;
	bh=UpNHG615ffwbVFQE6nEYc9kCZluH62/MQMXXzqmIbiU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nsb6u7YxuFy8UmjQiCoYJ2ToDzrlKSoGi5SyPbP1Qb5tAv1iUjXnCUTrhRZt87pj8+9/B7obSpjsSzMFQqF0GBbsJv6EvbBGPl7oezaPSWxN/8sLAlVuQVh054ZgPjKiJn26+g/x7B4h1Jg2/O1Tj42fW+TDG5PISmqzMIDl6Zc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WYBCQThN; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FLFymCEkHraYlGfgAjK8v/PDaHdK+ky9sy9O6/K+F5FteftGlIKbUzLtpNg4s3UzHOzeYXjRe57PAx5G5Bpu+R75IR/l9PITAfUVzB3z8WDN3BtZ+8daBbxXkHJP/JzR8gMQI5BYXmm4KwwuqNqBYVkwRdkFQScOEeL8bVfXFJhYYF8WhSfqK0gmRkI+V/ZKJ021m8BIG2YizFY5aEPh3LYmzOPariOse+HdPzGWE0LzLQBCB1782nDF2BVVyNA+ebj2hsJaBitks0HKNmzTb+q/bJHjw9yoj1LsJ3nPaVjWv+vtFe2sy1su+CBrmv5dtC8PIn8A/s06mo+fBaN5oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=53NAodmLhmzOmrUBg0McY6WeOT3kHYrwCuoGguNa62c=;
 b=kG/O98jXgw8UMdrzLLAgJG+gvRAq4aWPDwT9nEFb8KauloNXrsW5jatPMypWC/xoDHo5LCRkCvsY20Bek68ocS4+xql8gWxOV3TvCHcaaoQlnGgYyHIwn3wt66QaW2nrZ1z7LeMhnN9NbjzGBYhLYdvadtvR5kkgAi1Zl/vpm0agaBtUaWLg76L6Ajs7UqJJPQro5OnkQOFTVvE4rAREtNHCJ98pNa2Y8eaw06vDSl26eBa5wnvtTLdd788LWfvfrSWBvI1//qfCWkQ9Zo1WSGPAYQJ52my3X0bq/cS3rH9epYjJZDvf9v3qf4/4vz/xC5HoHYIi5KzT3wHOhPStiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53NAodmLhmzOmrUBg0McY6WeOT3kHYrwCuoGguNa62c=;
 b=WYBCQThNOMerjmcVGTjg92CNGPZOT14zoiMQWN19s8rHnrZEQtNcbOoZpS2bL5sP8REeppl+vqn+1KpRXunospiq+mer3b3dQ8AvlZQgAA4uqkXnZE5qgOPZGGi7fM/sv2QYJDVFrwwcfSmLhjOVsFJlZy1ZItYnUVby4DOy9ew=
Received: from SJ0PR05CA0002.namprd05.prod.outlook.com (2603:10b6:a03:33b::7)
 by DS0PR12MB8198.namprd12.prod.outlook.com (2603:10b6:8:f2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Fri, 28 Feb
 2025 09:24:38 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::25) by SJ0PR05CA0002.outlook.office365.com
 (2603:10b6:a03:33b::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.10 via Frontend Transport; Fri,
 28 Feb 2025 09:24:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:24:38 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:23:35 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 18/19] X86: SVM: Check injected vectors before waiting for timer expiry
Date: Fri, 28 Feb 2025 14:21:14 +0530
Message-ID: <20250228085115.105648-19-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
References: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|DS0PR12MB8198:EE_
X-MS-Office365-Filtering-Correlation-Id: 0795785a-e2ef-4141-5a8a-08dd57d9b93d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?21TLZKhN95go3BkfwOpVtoI6HkahbKZ43sh3EwvroSPw3Kk5Mz7MnAO0aXh6?=
 =?us-ascii?Q?27Ktv5LxpgHFZTFNUeoTUJPPgX175cbff166orPudduzMed8d4YNas2Z12V1?=
 =?us-ascii?Q?SbgF0Sf1q13zpWxDHLh/9BFJ3Mu0xEUCwo6tP+fhTtAYdqlRPF0EMHJLMr6E?=
 =?us-ascii?Q?La+MksdFiTiTI43NVRHNwlYCPi6v94GP9RR/v0BOno5Gl+3DITXESp/L/u0m?=
 =?us-ascii?Q?WKXbdUK6UdsvwPSQM2/V+ghsY7VxEQxLfFALls3ZhEZx8+JQty3usGIfKrPd?=
 =?us-ascii?Q?lVA1xxlq5GA/oRhPd2knYYK1xyE3gw+KwbEGh+dgLcz3dJGRsksH0yFiRC/V?=
 =?us-ascii?Q?xXo2LgaVQjZ9eEAJk85Mpj1fW9I4Sk+oZWXXHZUZQydLozOW/lxPJDVezdSL?=
 =?us-ascii?Q?nYrrmf6xahaXpsPj8KDhA+rXap1HrvgtFcZzdc++1coE6HO7cVbXlTUvqERJ?=
 =?us-ascii?Q?jy7VFzZQle4P+bO3iZ66DPC0w8NYg6VPYkpVvRpbJsFxVJ9jN0NU+vlhPEjH?=
 =?us-ascii?Q?NArB+T/LUB58Vs1LpRbWpdU4nipplVMZlFCDJMoTR4XIyDkRtOpH22oJdfdg?=
 =?us-ascii?Q?jzQlNBM36YbqcXZi6KooHI/XQKQU9FDqZMLQWV5lrHTpITt9v/pBTV4QxfN7?=
 =?us-ascii?Q?reEpkswf1ketE8HGQpFrUgrcU+P4MOU3ymL2d3RwYOb/qLVTvSfqmqv9Pdtz?=
 =?us-ascii?Q?XewDaJJKNqFTMCokSAvTaNPLBNtrWQJ9snPG9XH4HfQbcTeGEMHc0Ogg2mvs?=
 =?us-ascii?Q?uv0PA/avb6ZbyrnfMoKdUvzH3/xAgbGD/FKFmdHqWxeuN548nJEWMb1HdVR0?=
 =?us-ascii?Q?8mk02mvDgsfLO+84jdaghT7spL0USShRZjI9Y3Vep460Ox5lbpJJ9xagxMSu?=
 =?us-ascii?Q?bHEgxCT/qH+EYlRlRH3yFh4mMF/xhEUXsE7hQcOhBBdl+YWXHnWWKYsiza+o?=
 =?us-ascii?Q?1f1gvsTjFuGjgJsuw2H2HE9q/xqmP+HAa9pn55iyvnFUlPOkaGYRJYQEutzy?=
 =?us-ascii?Q?4/hTXjqyvKgaTJW3t0wjMbk2MmRGUS5nwy5RBFC6KH/4axMoDYkROYp9Mzap?=
 =?us-ascii?Q?2DicL1LxP6VnGN3KfWokK3811oE50L8+wGwrY4UCVRtLVsPP/IT2UTWueTNN?=
 =?us-ascii?Q?WYGgVMraxBIB69nXePWGQL8a6ua/drkJxRWyqwh8MkCkyx55aP0TgyfoVf8Z?=
 =?us-ascii?Q?3p8N1MZda18rXYW+IzfEmCE1lJoia9HS7OKgzKhZGNtaWln7L7+k153dfRZ/?=
 =?us-ascii?Q?M8Euw5CU6MmVaseaH7nTwz7sGBuqUGRgkno4yKCmDyfS3qFmgFa7m+ePwfMj?=
 =?us-ascii?Q?n/+y+yFjEtm2Ee8evFMTnwWTUfl34fx5X+wBsr3/zgH27/b9Rxhh2512cJDX?=
 =?us-ascii?Q?70kO7DmJvDNisCMJbzSeUlh3KI+60IGSiXan9XzYZkDOi8QJQt+4E6R9g528?=
 =?us-ascii?Q?MTPLLsjaZHFjnoQwdxPqL3dWKQ8zYbKRB7SyEdxyvvTnslwZ0lystCGVGbuG?=
 =?us-ascii?Q?Ru06De5r5BxIKBY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:24:38.2241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0795785a-e2ef-4141-5a8a-08dd57d9b93d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8198

For Secure AVIC guests, call kvm_wait_lapic_expire() only when
the vector for LVTT is set in requested_IRR.

KVM always assumes a timer IRQ was injected if APIC state is
protected. For Secure AVIC guests, check to-be-injected vectors
in the requested_IRR to avoid unnecessary wait calls.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/sev.c | 8 ++++++++
 arch/x86/kvm/svm/svm.c | 3 ++-
 arch/x86/kvm/svm/svm.h | 2 ++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a7e916891226..881311227504 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5334,3 +5334,11 @@ bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu)
 	return READ_ONCE(to_svm(vcpu)->sev_savic_has_pending_ipi) ||
 		kvm_apic_has_interrupt(vcpu) != -1;
 }
+
+bool sev_savic_timer_int_injected(struct kvm_vcpu *vcpu)
+{
+	u32 reg  = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTT);
+	int vec = reg & APIC_VECTOR_MASK;
+
+	return to_svm(vcpu)->vmcb->control.requested_irr[vec / 32] & BIT(vec % 32);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 08d5dc55e175..1323ec14f76a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4292,7 +4292,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
 
-	kvm_wait_lapic_expire(vcpu);
+	if (!sev_savic_active(vcpu->kvm) || sev_savic_timer_int_injected(vcpu))
+		kvm_wait_lapic_expire(vcpu);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index be87b9a0284f..b129ae089186 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -765,6 +765,7 @@ static inline bool sev_savic_active(struct kvm *kvm)
 }
 void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected);
 bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu);
+bool sev_savic_timer_int_injected(struct kvm_vcpu *vcpu);
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -798,6 +799,7 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 static inline bool sev_savic_active(struct kvm *kvm) { return false; }
 static inline void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected) {}
 static inline bool sev_savic_has_pending_interrupt(struct kvm_vcpu *vcpu) { return false; }
+static inline bool sev_savic_timer_int_injected(struct kvm_vcpu *vcpu) { return true; }
 #endif
 
 /* vmenter.S */
-- 
2.34.1


