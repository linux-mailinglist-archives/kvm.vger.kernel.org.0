Return-Path: <kvm+bounces-39670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2612A4944C
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:02:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73B3018951BE
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC6B2566D9;
	Fri, 28 Feb 2025 09:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f2smNlgj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4970A1EDA2F;
	Fri, 28 Feb 2025 09:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740733285; cv=fail; b=k4/CLq/VrLSD3BBVZiTeJuprlpfBX7zuedWdkr/sLy2c7mv+9vPookoYkl//MSBdzMxmA4b4aedK0PFpc2MI8kaZBRy1m6guk3+AIIg9GwACFu6swXiRVINSYzcr/UGa5MwUM4vdTxcO5Ya8YpVqH2GYELEuk/tLtJed40gz7YY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740733285; c=relaxed/simple;
	bh=jT72YGGTK/7/6vpLax1+u9YGtSvyZMeIBiJ7bKSgRSQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ev216giOSUYV/oASsKAkJRJcEOsKHfabYnyjAHZ8P4hStb9SAJsMgAFxe+X7qDCCf+SKoZpVWMjc/c7L0WToXBbf/MMAvQH4lxq8Rb4T7tjF17dDDLl1UlT9sgc3qKMXbuwoSKmKSnzXFjQy/Fw1R+tV23tbn6/hmPgWTh49uhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f2smNlgj; arc=fail smtp.client-ip=40.107.93.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+MI8DlTE/dqrrR3xRGZemKfB+Sa0RZYiQb9CrYhtuRH2kvZNWcpUHqOqhTHzPhN2goOnZaPtcNmRWegFQ7rNV6n0RHBQXcxe1WFOrotFxBqaJOOdAj9ArWVn7ggbN7F56y/XxigIDLyBkFVLJMU462aGxifVMum7lHuew7xwzwLONjmHOaH1BRaeLY6Ej0N3iklM5YlhgL+L+Pqhf6o+qN6EHlF0jxV0i4yFaPNMKWnK/Qt3pA/FNJuSfVITUAy+FwowxAs4YcuSCN5ZKng3HK97LykIqLg+OMdAkezy5V7NQMI8XCmQzZNN8ETg0C3p5dFMNxwCfTz2I1yDY+GiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u93zLMV/4DhbvBDrJ7XQZqSoCduVlZjlSyLf30KDlZA=;
 b=GOoIAuIl2sSg+6fQrhEE34PaH6CCmskKb5s+JUJjtzkusHxOJaY4uV3zQf6YmmCdjuI4a71MtWpct3MLu+Qwe46OmryQ4Xzzv9bMYHl4ghuCvOq6BZvqrCVm+GC05TvTVqkmZ+2JLfB0qERKwRtYWuF86apxXEZ6vcJJ33pH0EBrAda/KwckhvqbpJCkeKIBExX1mTHtlb4UDpk1g6RKj07aK8f0Lk895W0jcfSvlzzKjn+S2Acrk6xvfrn5g0dpVvfODmfsBq/AfoKe+QRFvku5pFopE/YOtrvQaVIc258yzgEwBZJmTVoyTC/vopfpph0C3QUte3jW9QGgf8qQdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u93zLMV/4DhbvBDrJ7XQZqSoCduVlZjlSyLf30KDlZA=;
 b=f2smNlgjmU/xkTNMp2SXvQQRnZdjfGKplM0UvmVLrOrqrR5k2xkXzJ6SLRkk/Fv5byc6aGe3gNSWRcbDb947Aa3HtQwXdBs4+3abzeA+QpeaFYCBJeUC8FiSn2WbeqGBa/Lb5/R4oQwLPTzur+s2oqUEz5aJWOIhmZWNew+D5SM=
Received: from BYAPR06CA0018.namprd06.prod.outlook.com (2603:10b6:a03:d4::31)
 by LV8PR12MB9334.namprd12.prod.outlook.com (2603:10b6:408:20b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.23; Fri, 28 Feb
 2025 09:01:20 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::cc) by BYAPR06CA0018.outlook.office365.com
 (2603:10b6:a03:d4::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.18 via Frontend Transport; Fri,
 28 Feb 2025 09:01:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:01:19 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:01:13 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 05/19] KVM: SVM: Add support for Secure AVIC capability in KVM
Date: Fri, 28 Feb 2025 14:21:01 +0530
Message-ID: <20250228085115.105648-6-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|LV8PR12MB9334:EE_
X-MS-Office365-Filtering-Correlation-Id: b64991a5-4396-4229-c953-08dd57d6779a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K/T1CM6ibk24wHh130y7OW0jFdgbgfgiODtgNERzI6St19zSbjMrhw1mLUKt?=
 =?us-ascii?Q?2k/adUvY8ZDy41xJoSCwnahhzxeaJHq1/RbriJ/GefOUbY37Rsa5LNBM4oBJ?=
 =?us-ascii?Q?MGurNASWpW7LN7K1Fl9ss92rNCqrF3/BAQJAbWIBn3Q2v1F8J2H/zRf7QoV5?=
 =?us-ascii?Q?//1WhAQzshwtyGxE9hRKzeu5/IgeleJ9ku1RkVEk9XmQnr/dC6khPHC6K60c?=
 =?us-ascii?Q?9BvKpqIwCz0gAEO/c8Attpl+bcJVcbDNnyqoW4B8erPmK0LPFOE86F3o5ApP?=
 =?us-ascii?Q?nKP2wELVIC7bIpv+m3O7X/WH0OgPm0GBZwSjWFH060jRcq42prb0STbNB0vZ?=
 =?us-ascii?Q?M8buZeUGtM0wojDu7ALEI7bM+f6UknW1B0+pwrpPrw898QLJP8RocEoaAwTz?=
 =?us-ascii?Q?U1oHQAZgfQ2MumcVLQ5IrzVmPnxjjg1IiLxVhCcq89vJ477pbzDrzHEznKpC?=
 =?us-ascii?Q?rvj1fB3Q4WjOHTJ25UwKMzo1oD6krg9BJxql5kYrXmmF7KEgjh28P4orbj6A?=
 =?us-ascii?Q?2XBpRpffJ1bGeevEZkes/u3INqUWZVGyAT1G7oq0EigyUM4s1nKzEmT/s4Ec?=
 =?us-ascii?Q?o8lWV/06ajA7znvK4t2V1xFIw7xYI+tlRn/EJnS/iYt8KFIZJjhRKLG75qWF?=
 =?us-ascii?Q?LJlA6UOS5a4W+B7Di7IkF8zFEh4qZNQndFEBYBe17wkMmon8ydB+wlpeatut?=
 =?us-ascii?Q?1x9LuS4KU9Kx5TEqCPYbwUicVUuB4oV3xv2gXLRT6cvr8n5uav21JCvQEHK6?=
 =?us-ascii?Q?rV8BVxV93/fVz65xk0U5feEfK5JLwfKxf1Naj8VH0vv3YZuTtkx6egwNnY9V?=
 =?us-ascii?Q?CPUS86aeDXvKWu1XBc86AN5FfVBFMKDNNEKmp/6LfCNbeXW/VWqBoAe49KBS?=
 =?us-ascii?Q?A372xGYmElCmg3OiA3zAI8z9+JUk+h1xnX3hFcykQ+MV+KRKUmWTJsBDGH44?=
 =?us-ascii?Q?tGxjpwYu4uc7yxz33GxE/2Sgs8kRqB1/kRpPcCxXnBmv3dCOxY6PX9UgBm8I?=
 =?us-ascii?Q?WVO/mYkHaj09B+QwO1udyG+ZBNSWSQ3stNY3ENEFoVrnP1A+6q77vlYFpSwy?=
 =?us-ascii?Q?/6Q3sxWHnuR/uX/tyZIhn3052yvUVFESv8/NgcavZ2UJI/Mijgu2dtbB3Hda?=
 =?us-ascii?Q?sp7xXqy8trjy9e5ezrIa5sjlOCvVBlC1Bp52FyBFsFbvScjPhf1jZ/BRwqAD?=
 =?us-ascii?Q?hgYAMiKs8libj2oDr/E70IhLzbnCS48TjLRsXsqIYFdFB84MbeY743IgLY7d?=
 =?us-ascii?Q?IoebJYIaAfDOU+rC2fIPZsv+O8E2CKvL1NbTJAzqXuEqnpIUgIMc4PGNdKH7?=
 =?us-ascii?Q?phYWx5Qc4EEloAAUq9qkLyO8Ok6ACkZdptS7IhXU2ud2b5aY571Zpt160Sf1?=
 =?us-ascii?Q?G8Msditn6L3kNp1r43B0kieRaZJPQIq1Fi4hckX4SyXiYdflJqaY0BGd0NUc?=
 =?us-ascii?Q?W3tW+30E42bktiGyOLot9mrW3pP69PMq8L/BwVZSYlywSmrNoBzYwx6GPxhz?=
 =?us-ascii?Q?Zt3tBWQX37gZAdw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:01:19.6010
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b64991a5-4396-4229-c953-08dd57d6779a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9334

Add support to KVM for determining if a system is capable of
supporting Secure AVIC feature.

Secure AVIC feature support is determined based on:

- secure_avic module parameter is set.
- X86_FEATURE_SECURE_AVIC CPU Feature bit is set.
- SNP feature is supported.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/asm/svm.h | 1 +
 arch/x86/kvm/svm/sev.c     | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 9391eca5412e..f81b417fe836 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -292,6 +292,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
+#define SVM_SEV_FEAT_SECURE_AVIC			BIT(16)
 #define SVM_SEV_FEAT_ALLOWED_SEV_FEATURES		BIT_ULL(63)
 
 #define SVM_SEV_FEAT_INT_INJ_MODES		\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index bf4e85e11a7b..82209cd56ec6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -58,6 +58,10 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+/* enable/disable SEV-SNP Secure AVIC support */
+bool sev_snp_savic_enabled = true;
+module_param_named(secure_avic, sev_snp_savic_enabled, bool, 0444);
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -2962,6 +2966,8 @@ void __init sev_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
 		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
 	}
+	if (sev_snp_savic_enabled)
+		kvm_cpu_cap_set(X86_FEATURE_SECURE_AVIC);
 }
 
 void __init sev_hardware_setup(void)
@@ -3082,6 +3088,9 @@ void __init sev_hardware_setup(void)
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled = false;
 
+	if (!sev_snp_supported || !cpu_feature_enabled(X86_FEATURE_SECURE_AVIC))
+		sev_snp_savic_enabled = false;
+
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
-- 
2.34.1


