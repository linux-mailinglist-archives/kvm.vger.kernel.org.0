Return-Path: <kvm+bounces-5371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 566108207A3
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:25:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4448281B90
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B09C13C;
	Sat, 30 Dec 2023 17:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f3qFmrx5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2259474;
	Sat, 30 Dec 2023 17:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhQ9Z214uC+757akySjjl4qwK0kDPwRbjytpQlgEkYMGPh8docme+RZSWo5wN14kqmEL1tElRviu0W8Hv680GBRhg9Xl5A6MFCOiad3gl8NKgUAMBbmjWFXeXIMieIjd4iUb2X1ShH3gt+vXf9kho4MpP8xgSWxoJb1CqcHn81BYPbY6RTN+hnsSVpW+Rq9etxpuXo4v0VBY3GEdHUh46n8KSkFyRgEfq2rqWpK6vlbwO4p2lEuv4LPPQYpXDWm/6+tX/RILWFOhp0rFM45O9Mo3BSMZPjD3GSBQMspUz6d4EsuGN6CFKOBhsfZT4vFKFPUe/qX4MX1tDt+v8mS6SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ha70LUUwBF2GKOLwk2IDsBKjAfjqiTrz3NfZpC2t4HA=;
 b=fiDHKoCH7St0tJq0uh1Kz5Lpkvf2a3M96fKcbLvYFgMe6qRm1I4SGO2ieUoPfPh7jdwArNNcTE2gi8iISxrdYeRhI/+TT8jHHnMnTUNJPiJ0JZXiqBRubdt1RsjBiqigyahkRgtdKhqm76XPNCa03zAixI2KrVs5+vrhU19g6d3AO7Nnza3MMZfaHc9FRrEnpR40SpULQ+N5SZmVOAEeY5c6Fi/VDdl+ses1a3MRgZhhg/psLRUEj243SSZLPnAsjYMAlsKZWSKejhXMT2Ays6LC77bzTymO5NJctrWteygqrbjWqGMa74zDv3sYolsEI102h7bIjVz90SmCBKnlNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ha70LUUwBF2GKOLwk2IDsBKjAfjqiTrz3NfZpC2t4HA=;
 b=f3qFmrx55ItdoNrG0bSu71sWsBYqnPLnCtXBwUhavmBTOMXG0aHVU8ZkMaEB1edOEwlPRZbHKqP5IqAmFiDzmkoW2PV0B2ERu7jZLgINjcOXM75tYhwiKbQKQr7ooChdNrXh3xpLCM2+O+j/93zJW84tQ8cQEtuwUK5ls2sLFlo=
Received: from BL1PR13CA0096.namprd13.prod.outlook.com (2603:10b6:208:2b9::11)
 by IA0PR12MB7531.namprd12.prod.outlook.com (2603:10b6:208:43f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:24:46 +0000
Received: from MN1PEPF0000ECD4.namprd02.prod.outlook.com
 (2603:10b6:208:2b9:cafe::8) by BL1PR13CA0096.outlook.office365.com
 (2603:10b6:208:2b9::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.7 via Frontend
 Transport; Sat, 30 Dec 2023 17:24:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD4.mail.protection.outlook.com (10.167.242.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:24:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:24:41 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH v11 10/35] KVM: SEV: Do not intercept accesses to MSR_IA32_XSS for SEV-ES guests
Date: Sat, 30 Dec 2023 11:23:26 -0600
Message-ID: <20231230172351.574091-11-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD4:EE_|IA0PR12MB7531:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a11e442-b6d0-4604-85f0-08dc095c3818
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WUXxigJ5jBElF/DMeYYtioPmeGAqvw5qbvg9YnhOGpzqPE2iWvHoqrpK4I0+AVtbjEaM0r0WrMxF3Rtbt/pZ6SYOW2vSjswHlUBKB/eHFi+kB6Ohhh5Wzo7Rsvfvk77MqQzIYP8dO6nf4yShpJM0ZOxkq8RL0yQzmKPTOQ12aXnczgRWtQKI3mzvdvsI/RP7HhImUxiZ8hgc7MsmPefuCPoWExyl8AS2OF7VvAEBOPZI2KtfmTsOweKXD9y8rkxqx0BQBGu7UHb/v7Gce7jkfmww4nTThhSjtgRczC+PsuYtEF9NbBru3Sf6tyCtnLkAHjD/sNUhsFKB5RmIxtJ2uMlanaJ1WzhTCLFzFMs4Sy16Dfpw5paxEURnXLNIGbIS1nw5dpjeDElYKAloj1bEmHeXiZoTB0zTaWw3sJhqFiW2xqYYTLMB/SqXbx4KIF1dGP20/YkHBRC7avYRJ5nnlKNcIUBSVw8xa/GoLfCeXpgRfrNvyUZcjN3H7nDtBMjoHH9lRjWGsenVGHNSV6osyn0hbjwJkOoK7zsC2jjfqNWtsGeKUUlzX4rsgDDb9BbBdGaiVmy6MyaxfBVO7Fsbjb69W7VcM7MXUKeSB0MEQJvCoQmNuWa+rok/j73dHVHGiJiTqEcQiNkBNRPYO3MzuZ9WR2dLF934XuMk5bigXAVWH5OvK1Bk16c/oLsbUdLhKeHXgp3W1ifUBhh7YPtyLmrwEM+u/utnTazyMP/NMX7OKf367UbMsrMHTb6WdMti5ar8hJU4Db6LtsIqsJGjkQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(39860400002)(396003)(230922051799003)(1800799012)(64100799003)(451199024)(82310400011)(186009)(36840700001)(40470700004)(46966006)(44832011)(5660300002)(356005)(81166007)(2906002)(40480700001)(40460700003)(82740400003)(86362001)(4326008)(8676002)(7406005)(7416002)(36860700001)(8936002)(47076005)(316002)(6916009)(70586007)(70206006)(41300700001)(336012)(478600001)(426003)(16526019)(54906003)(6666004)(26005)(83380400001)(1076003)(36756003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:24:46.1915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a11e442-b6d0-4604-85f0-08dc095c3818
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7531

When intercepts are enabled for MSR_IA32_XSS, the host will swap in/out
the guest-defined values while context-switching to/from guest mode.
However, in the case of SEV-ES, vcpu->arch.guest_state_protected is set,
so the guest-defined value is effectively ignored when switching to
guest mode with the understanding that the VMSA will handle swapping
in/out this register state.

However, SVM is still configured to intercept these accesses for SEV-ES
guests, so the values in the initial MSR_IA32_XSS are effectively
read-only, and a guest will experience undefined behavior if it actually
tries to write to this MSR. Fortunately, only CET/shadowstack makes use
of this register on SEV-ES-capable systems currently, which isn't yet
widely used, but this may become more of an issue in the future.

Additionally, enabling intercepts of MSR_IA32_XSS results in #VC
exceptions in the guest in certain paths that can lead to unexpected #VC
nesting levels. One example is SEV-SNP guests when handling #VC
exceptions for CPUID instructions involving leaf 0xD, subleaf 0x1, since
they will access MSR_IA32_XSS as part of servicing the CPUID #VC, then
generate another #VC when accessing MSR_IA32_XSS, which can lead to
guest crashes if an NMI occurs at that point in time. Running perf on a
guest while it is issuing such a sequence is one example where these can
be problematic.

Address this by disabling intercepts of MSR_IA32_XSS for SEV-ES guests
if the host/guest configuration allows it. If the host/guest
configuration doesn't allow for MSR_IA32_XSS, leave it intercepted so
that it can be caught by the existing checks in
kvm_{set,get}_msr_common() if the guest still attempts to access it.

Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
Cc: Alexey Kardashevskiy <aik@amd.com>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 19 +++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  2 +-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2efe3ed89808..f99435b6648f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2978,6 +2978,25 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 
 		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, v_tsc_aux, v_tsc_aux);
 	}
+
+	/*
+	 * For SEV-ES, accesses to MSR_IA32_XSS should not be intercepted if
+	 * the host/guest supports its use.
+	 *
+	 * guest_can_use() checks a number of requirements on the host/guest to
+	 * ensure that MSR_IA32_XSS is available, but it might report true even
+	 * if X86_FEATURE_XSAVES isn't configured in the guest to ensure host
+	 * MSR_IA32_XSS is always properly restored. For SEV-ES, it is better
+	 * to further check that the guest CPUID actually supports
+	 * X86_FEATURE_XSAVES so that accesses to MSR_IA32_XSS by misbehaved
+	 * guests will still get intercepted and caught in the normal
+	 * kvm_emulate_rdmsr()/kvm_emulated_wrmsr() paths.
+	 */
+	if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
+	else
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 0, 0);
 }
 
 void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b6179696861a..18d55df7fa5f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -103,6 +103,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
 	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
 	{ .index = MSR_IA32_LASTINTTOIP,		.always = false },
+	{ .index = MSR_IA32_XSS,			.always = false },
 	{ .index = MSR_EFER,				.always = false },
 	{ .index = MSR_IA32_CR_PAT,			.always = false },
 	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = true  },
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9ed9d72546b3..7f1fbd874c45 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	46
+#define MAX_DIRECT_ACCESS_MSRS	47
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.25.1


