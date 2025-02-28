Return-Path: <kvm+bounces-39671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64C8AA4945D
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 130981887A9A
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDC3A255E37;
	Fri, 28 Feb 2025 09:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cwxLli+Y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BEE1DDA20;
	Fri, 28 Feb 2025 09:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740733491; cv=fail; b=nLLpV5jT1/OHOt5RQm0bAdOEvC91tur5cOkVf2TrjA/24Uvxn9UqAHn/85NIvsPcpd/M7cMCR0S5Ua7thu8lQZscCidRFQUhrDomm06vZ/mzRNd/am4O0ckVhCNDuc02O9qY9XqqfuGqZOJ9RAUW7gmDVhqBNglzTN3yH4WaP24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740733491; c=relaxed/simple;
	bh=6WDCEvPpkwHP20TDuahu0rNUJjZ+Jfh7kYejLo2MRvA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ECttrBs4bGIVtwGvsolLEOAt6y59cRYye79Zd1PdJQm9+JsKymCrJ3rhIutT856NySIVzVvS6PJP/5xrNhk7SxaEZAyqf2dkObuNfRXnQCJf2c+Y6B5ScGoQ4877DtyZLF2Rlubvt4l9ODBA+T0ycLb5wofPi5pFaw/Zon/eQ/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cwxLli+Y; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t8YNUoej6iOsFSY5YSzD/yMULm59VdkUpZFyRKOVEKmqFeFVzaqEjgk8BYUKKChXf77ytCZOJp4/mKJ6aF4junM1PNG40twclPOSxnp1L253tCcPTZ14kW6KF+3vh0hf4NvRZgnkxQUP8+8+xT3xOGRzwidVohCFmI6/L9oxoFuAaLD5nx50rsn2hflVS/BcFvv1lwOxy9LmU/7KOIi7tUneS7LjGPfVC3DqitVNZ1mhwP1jOIMTtnbvMYU37MsRz2upXLQLmRJBJnNF5+jU3cjEtpOHATvovAb3gf2TNHwacYs7Y1+gc9PZ+F9lpPQ9kHNE0DYdrgCvJvJ7WQjaJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZtvj0Tmb7QFhHOr7sMRflnBPAi/75mPWS+3iodBw8Y=;
 b=i33YzJMlXwYj7zmx6oDw2K5Sc7J8Urdf3wISFeRuKs/iIiv0/FLYLyMep3n7YH3s2sZrfLO+PCnwBlnINGqgaTcYXDleAUIHopDfvh101McjyujkEZtAtVgMSuIWqCkhIhjDhbym8LBKgV2p/D8PvzcKHwEa1+olzttRE82ZiDMCkIDJ/T5QEVwF9cbUNj7yh5EBwQvSON2QL34O2aUs+Orgz0lGS1bm0wkvmwj8kkWFWAZF3ikmRRv5d85vEgSJaioorYdKpD4UKSp8YSeW6O7rm0R5f4Fcj+e3YIp0c771dmdC1AqLH0l8/+fYqZ+wE6GVLFZYXMfigJ+e0FDtJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZtvj0Tmb7QFhHOr7sMRflnBPAi/75mPWS+3iodBw8Y=;
 b=cwxLli+Y7sTB0lb1oWdTQO0qEqxVM7JsuTlKRn6d63YGWIFhgP+D7y3V2iuPIJYSSpLf6PWgrpICevUqlAzO3FJaq7an7csIJAJRI61b/iuqnrZJiR5MPAvAikDWLrNt8MNETlplmrXV5D3jajW63Z/H74lGU5uGcAsxBlgL71U=
Received: from MW4PR03CA0140.namprd03.prod.outlook.com (2603:10b6:303:8c::25)
 by CY8PR12MB7124.namprd12.prod.outlook.com (2603:10b6:930:5f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.23; Fri, 28 Feb
 2025 09:04:45 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:303:8c:cafe::d) by MW4PR03CA0140.outlook.office365.com
 (2603:10b6:303:8c::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.21 via Frontend Transport; Fri,
 28 Feb 2025 09:04:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:04:44 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:02:10 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 06/19] KVM: SVM: Initialize apic protected state for SAVIC guests
Date: Fri, 28 Feb 2025 14:21:02 +0530
Message-ID: <20250228085115.105648-7-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|CY8PR12MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: c60805c5-3f28-43fe-6d69-08dd57d6f198
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?okxClPqCGxA3keLrMVOaX9/TIU9Onb2s8U9yn07F9O5cs+zHPofe0xV2At7L?=
 =?us-ascii?Q?m7iEdDZvHDqjoNBsFekWZcAsqu9E6N/lMwOzvtxcjNJE0w5LWxKFWbczt0lj?=
 =?us-ascii?Q?Zo76GkaMqfA4BtcbtHuu0uscjNEN4NMtJpOYtJckF7UW0dwocVQ8AaKdGeFY?=
 =?us-ascii?Q?N2kWVUJZgOGfBTZg7CawdXdU7CIVOMXvOKhzZR0eJ0CVgbxucIWqUpWINBOw?=
 =?us-ascii?Q?HlaEYMCw5j5+7Vp7+kPlDNJ2Loe4WvJLgOjBcRbWxT2C2genpi2Z3Qn6zSjx?=
 =?us-ascii?Q?yYar+Q7+QDuB2JCVZqRXtio0duh9EJd6ObiCGmo3/30UmI+0oyYYSZoKvzJ7?=
 =?us-ascii?Q?sQbbPDWQ8lOlFSfPavKWiQEQjN+fBfptGhiTxw83oP4KTE8apaM4OpwkJgjP?=
 =?us-ascii?Q?14utP3TiIbdL7CDWP3eKMhXaTAxhgkrH4Ox7GyJQ+qk9zJWQCuQTfywjpKR9?=
 =?us-ascii?Q?oAWJALQC3/jS7lfVCBo3SpPnbvM4S5z5DRop4Kb32l4fb1v5oHccQOJna9n3?=
 =?us-ascii?Q?HBIg16ef72bSmbuGU6ROxFsAwCrL3GTmDUo9DmUfWwSoIFtX5KygAsnwr/UM?=
 =?us-ascii?Q?hncyi7ZLtbhOS2bJVHztFV1fAc4pXqA1QfKdZH14MBV4xV1EGC7g/u2KGPC9?=
 =?us-ascii?Q?7fVuGL9Y0GW2axJ3IEPlgfkZsgTI5cbvp+kBGQIzzRmbleUSzYOOpcLIhsjK?=
 =?us-ascii?Q?u1hFuIuXU+qXZv3Ij7mO/xVQmTu5zyBbwzW0ZuNeMft5X7rO8MxNE7DcOLIU?=
 =?us-ascii?Q?J797dbFAIrjLTdJESD+jmrOtZigyDvgxGgRyqF2MqATSyXUEe5u84zmGulLK?=
 =?us-ascii?Q?npoktj6k9aMk662UCtad18gala29I0mWRRMhpnI1fBXkgDgOe69fxkA4rTB5?=
 =?us-ascii?Q?cFblq3whq3Knxgjha0OlTxBQrsp/mV+w9pnoIravjTV7i0qZz8nqouQTSHyi?=
 =?us-ascii?Q?P7EGwHxKl6H6HfF1+HAO4dNHL+BO/GGCDijKUJKHQS2r9FSX4RLa1VJZqGUb?=
 =?us-ascii?Q?nwAeucuI1cnSmeaWr+I1hCTPSqiyZnQOxeJf8+ZgZD2X13xVSwwW/N84hHuR?=
 =?us-ascii?Q?jrEuytKssqtJh5cIJoZKTrswRdjHHs3PwAk83xPBLw/+1Swus1JuqMZY6Kb8?=
 =?us-ascii?Q?MOKzsATlT0CkSbq7ijvm4Ng7ted2FI1kXVnGCahS4tAoqheFVrGgZHUjXJF3?=
 =?us-ascii?Q?CMpg6ZgUGegjIoewuRh3dGuHGFzqp/rKMvBwKrngeuTTuIbeF/aqjfUieHB+?=
 =?us-ascii?Q?znTwv1lcxsEqg6s0wJM2VNsSFUu1pa5VJpuwQcBXN4Z9tVbpxHTAs3/qhZOm?=
 =?us-ascii?Q?R/utATwlIQkOuLWSLo6HCf38zhnqoMm65BiT9RngvaZPSEwZMZwG07prK5Wo?=
 =?us-ascii?Q?o6uDnsyTqyyAxNXorATeUTSw+FdErjCrZijfnkhSoXsppfTPPgFQEgMOSRiA?=
 =?us-ascii?Q?sjYza0XX5SSKGHw1lRfpw57ITuM3Igbw5YH/Ja42a2jkA2o6DkOl9B2s3MNn?=
 =?us-ascii?Q?+osW+QKMjeSHMBg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:04:44.2363
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c60805c5-3f28-43fe-6d69-08dd57d6f198
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7124

Initialize lapic's guest_apic_protected for Secure AVIC guests.
This is only an initialization commit and actual support for
creating Secure AVIC enabled guests and injecting interrupts
would be added in later commits.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 arch/x86/kvm/svm/svm.h | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 456d841298f7..d4191c0a0133 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1442,6 +1442,9 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	if (!vmcb01_page)
 		goto out;
 
+	if (sev_savic_active(vcpu->kvm))
+		vcpu->arch.apic->guest_apic_protected = APIC_STATE_PROTECTED_INJECTED_INTR;
+
 	if (sev_es_guest(vcpu->kvm)) {
 		/*
 		 * SEV-ES guests require a separate VMSA page used to contain
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9d7cdb8fbf87..7cde221e477e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -756,6 +756,10 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+static inline bool sev_savic_active(struct kvm *kvm)
+{
+	return to_kvm_sev_info(kvm)->vmsa_features & SVM_SEV_FEAT_SECURE_AVIC;
+}
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -786,6 +790,7 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return 0;
 }
+static inline bool sev_savic_active(struct kvm *kvm) { return false; }
 
 #endif
 
-- 
2.34.1


