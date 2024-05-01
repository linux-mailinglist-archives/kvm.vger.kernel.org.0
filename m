Return-Path: <kvm+bounces-16312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BCFE78B872A
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D20991C230C7
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13218502B2;
	Wed,  1 May 2024 09:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hYeQDNOg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98A650288;
	Wed,  1 May 2024 09:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554270; cv=fail; b=HCEO3KIksIUWTDnizYMfM+ahmEyUvqdk2hZ8wSyKY92xv/IZSmMAYgrnM8Ye890HPSGF7g/iQncFh9yzv82pWeqmaffwqCbSSCbBt/h0Vl2L2ycm6mgz0ghnF4NPzDv+Ni8/aftwymJIs0PZ+J17qJUkoZOFPnqt9RDx2jLsS0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554270; c=relaxed/simple;
	bh=uW7L+NNzdAwdplqdooe55yjkQb0b/2k/0HRM//9PGxQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C25J6SOvkFMQIJiWzMIgNKjC4cAsj9jc+KZSpJwXABuEuPajvpOU1SThlDq1o350PyyuJr08c+ZhCjD/TKFGRebvqaxnBfO5LDZ7mZxZ7V7c07KWNVWm7TA8fWx17HqSEA3iTcr1Gn31/xK2WSfggbb+VIEcpC/HehkciGpqJLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hYeQDNOg; arc=fail smtp.client-ip=40.107.92.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEz9jp5vB6xZOETZ2Xojf5O2gRaNs33FkrX0ST/6tQo0mEbFus0I1k1D1usIoX9ATgPtJHOeMM/CHakaf23MDP+b7ew8yOuSJDR2HRQK/bTu7yx3HQvulOaEddfzusRQG5RX1/Mx0i8p6ydRhzFnQHOFfyj9LopSPr2ZMJQK2z3JjXBELMX1yZ30e84CXVQQ9WM8SegWrMZZp/7C3u0faHCZll08W4hh20ibPylNfTGtUhUQ47zuJuFVbEhRG/FL04UzfScJMkebq2e9ESGUBWrMfQ33gr80YQRrQC+i7eF+4WqB0HWwuQD8+5TDNQmxuLOyRlSm9meBxScQH6ll1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FS7iOw8OSCDAeMDBOiBD6sqTzTf6l4cypzmEfY1yRZ4=;
 b=KyskQ+R2GKK516LpEefGcyRKg2ykjmWfncJ6expBBwmNdc+tJcep7lk+79xH5OxOTzVkFUa6AVJ0QA+o+TWpEEoiach8cfArzzJPEMWQEr6S6izJtY7QJJiHLzeCqgHUYpo5xXJ+E/118QEiDGN9Vkg3wkm0dzMgknHwb1WGemv53FWCe7EpZ0qWh0gBsSx60dhJ9emOVggwFC/Su/FNDiLsBVdrJTnWAL+IeFVrVxzfraZVYUjWv1pY4eNq54AQehe++4RfZ8ph9n/GxN8avrmPcHH1vPr3exBfEbCNO9sKrbEe2c2iizBYOIiTF5sYeIzmRD95p8re3yE/MXNpuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FS7iOw8OSCDAeMDBOiBD6sqTzTf6l4cypzmEfY1yRZ4=;
 b=hYeQDNOggsnRTMo8jKpQerq8ZqUlHfrbLJbK6l9HL5VV5/95cbYFOfIr6whFo+BiLSL+Qg3SdekQyq0hG2ReMRdwZGrIzDC4dT2bdAka9eiqWPzwpWBhxs0B/TwJx4A6u84ZnoJQgOok2MBppw3E882/ZF79c8ecGBJhfiFkeZI=
Received: from SJ0PR03CA0044.namprd03.prod.outlook.com (2603:10b6:a03:33e::19)
 by SA1PR12MB8917.namprd12.prod.outlook.com (2603:10b6:806:386::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.24; Wed, 1 May
 2024 09:04:24 +0000
Received: from CO1PEPF000044F4.namprd05.prod.outlook.com
 (2603:10b6:a03:33e:cafe::ba) by SJ0PR03CA0044.outlook.office365.com
 (2603:10b6:a03:33e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.32 via Frontend
 Transport; Wed, 1 May 2024 09:04:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F4.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:04:24 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:04:23 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v15 14/20] KVM: SEV: Implement gmem hook for invalidating private pages
Date: Wed, 1 May 2024 03:52:04 -0500
Message-ID: <20240501085210.2213060-15-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F4:EE_|SA1PR12MB8917:EE_
X-MS-Office365-Filtering-Correlation-Id: a1cdd03a-7e00-4720-5c3d-08dc69bdb257
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|82310400014|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OzRVf3177MAe6xGmBnSo6cgr9lN2xYfJf7xzTVeABku0Bk+3+L/cWkaDxeMt?=
 =?us-ascii?Q?YRUqkxKrNhjcDP6bnmYyDE9WHhOh2d55QPIipIhHCO6Of23ykpU8gQVxw5xr?=
 =?us-ascii?Q?NNJ5ANiW7DTX+rNg8HDcYV8/M/uEEN86sZsXLE8IO6Ul39EQMzrZFmS5c9vr?=
 =?us-ascii?Q?jKAR1xFKDmkL8vsm84BhR3ahUiBN6H0Pa1Qi4J/qSeOI5l0W9gveQ3VzJDD0?=
 =?us-ascii?Q?bC0CuqgUBC26/JLuwSsxfxWVkGkQmSnRyk3VuCh5/x6d1hl1nWhcuChGOoTp?=
 =?us-ascii?Q?Dt/MYe/dfEtkbM8p0qU2bprTw2uLp79MGPOyjOoojKHQobpzGoo641njrNRo?=
 =?us-ascii?Q?SuVqYwP282+pvp7OjmRKcOJJjhT4w/sqbCFWa+RLZn1N4rXlSVPbSjUn19ZF?=
 =?us-ascii?Q?5g75LzZcxAUCpVojh1X3N/hJt8/2LxhTinuiA58/Xu8s0xocy+KcTOHpn1AF?=
 =?us-ascii?Q?EdR7C1icAV4znsQ/yjyaBwG7UfLNof6R8CrJaQ9CXuwMnc667tjIFQgqoHGj?=
 =?us-ascii?Q?d/BozHjCtYyGslIvdmQ4h9m8XGG5pW2mxqRqncbq9Wyy65gogbs6CTiM4Rjq?=
 =?us-ascii?Q?LEjKF0+XDyRSjJB9NlGaHxst1tjGbv4rF2ExZvY6EnkDmxKd3Ycnn35BL+dC?=
 =?us-ascii?Q?0ohkDtpyQispdFUD8SQwpRap3hjFvHn1YyJMbcOJ7UwO1kSIJDQYgeGBzj8i?=
 =?us-ascii?Q?xzi64mNNVYvXVtgkpf8lEyj+jo3SriTnVBab9Mv1V3MmXn3RndEVQqj8aIMf?=
 =?us-ascii?Q?2/TdrNiFjKuTHfYVPP/0hXy8uutUjn9LZZYWjMJKnuHdtFpKZXJz5Odd6YzZ?=
 =?us-ascii?Q?lBcImLenlytxwGX9m/QGhWg7I5Ehs2lPk+9Rf2B44PZvDHWi8btriGfoPh1f?=
 =?us-ascii?Q?XpzNinalutRbQlfBp4psUC97M1reZbmTuwdI0aOmti4LroAkuLiIBLKeMOTT?=
 =?us-ascii?Q?XlO3aORMV9/g1QToubtTaG8eeofJy0OGHPTYQ56HKZf8JYqrkecGZqM+6irh?=
 =?us-ascii?Q?9GWYfw88ZJWyvhCx3cZvwUMaTxccpkE3mqp+QjRi85Q6z6D/9CPBWzpsJVew?=
 =?us-ascii?Q?y/00bDDEVO56jG+RokACQX6X66HoAj1MLuMWfKwvEQd5dQ9FUidULxNin4b8?=
 =?us-ascii?Q?mFAwvZCjZEFPkUikediIP1u45QMtlth6foAvItlD5bbtRfuHtKdJGIF0WV2c?=
 =?us-ascii?Q?rSg8OulDNpFykAEA0fS5JNlvZQAaM3vqroHrSC3yve2hDPSM6nQA+B1Culpo?=
 =?us-ascii?Q?4rMBJJp9cGkamZwc4XRLDZFa9kdIK8QJ30rAQlvOSz8Dl5/r8GzNEgFMxUJr?=
 =?us-ascii?Q?5lz2WInQv98WU9tKRvZD2fXm6lYLLQocY1Ck7iiEUcQxbLWYjgdW5nJ8rVrf?=
 =?us-ascii?Q?WHpU9OM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(82310400014)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:04:24.0166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1cdd03a-7e00-4720-5c3d-08dc69bdb257
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8917

Implement a platform hook to do the work of restoring the direct map
entries of gmem-managed pages and transitioning the corresponding RMP
table entries back to the default shared/hypervisor-owned state.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig   |  1 +
 arch/x86/kvm/svm/sev.c | 64 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  2 ++
 4 files changed, 68 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 10768f13b240..2a7f69abcac3 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -138,6 +138,7 @@ config KVM_AMD_SEV
 	select ARCH_HAS_CC_PLATFORM
 	select KVM_GENERIC_PRIVATE_MEM
 	select HAVE_KVM_GMEM_PREPARE
+	select HAVE_KVM_GMEM_INVALIDATE
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0439ec12fa90..cb89f6eba6ea 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4655,3 +4655,67 @@ int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
 
 	return 0;
 }
+
+void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
+{
+	kvm_pfn_t pfn;
+
+	pr_debug("%s: PFN start 0x%llx PFN end 0x%llx\n", __func__, start, end);
+
+	for (pfn = start; pfn < end;) {
+		bool use_2m_update = false;
+		int rc, rmp_level;
+		bool assigned;
+
+		rc = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+		if (WARN_ONCE(rc, "SEV: Failed to retrieve RMP entry for PFN 0x%llx error %d\n",
+			      pfn, rc))
+			goto next_pfn;
+
+		if (!assigned)
+			goto next_pfn;
+
+		use_2m_update = IS_ALIGNED(pfn, PTRS_PER_PMD) &&
+				end >= (pfn + PTRS_PER_PMD) &&
+				rmp_level > PG_LEVEL_4K;
+
+		/*
+		 * If an unaligned PFN corresponds to a 2M region assigned as a
+		 * large page in the RMP table, PSMASH the region into individual
+		 * 4K RMP entries before attempting to convert a 4K sub-page.
+		 */
+		if (!use_2m_update && rmp_level > PG_LEVEL_4K) {
+			/*
+			 * This shouldn't fail, but if it does, report it, but
+			 * still try to update RMP entry to shared and pray this
+			 * was a spurious error that can be addressed later.
+			 */
+			rc = snp_rmptable_psmash(pfn);
+			WARN_ONCE(rc, "SEV: Failed to PSMASH RMP entry for PFN 0x%llx error %d\n",
+				  pfn, rc);
+		}
+
+		rc = rmp_make_shared(pfn, use_2m_update ? PG_LEVEL_2M : PG_LEVEL_4K);
+		if (WARN_ONCE(rc, "SEV: Failed to update RMP entry for PFN 0x%llx error %d\n",
+			      pfn, rc))
+			goto next_pfn;
+
+		/*
+		 * SEV-ES avoids host/guest cache coherency issues through
+		 * WBINVD hooks issued via MMU notifiers during run-time, and
+		 * KVM's VM destroy path at shutdown. Those MMU notifier events
+		 * don't cover gmem since there is no requirement to map pages
+		 * to a HVA in order to use them for a running guest. While the
+		 * shutdown path would still likely cover things for SNP guests,
+		 * userspace may also free gmem pages during run-time via
+		 * hole-punching operations on the guest_memfd, so flush the
+		 * cache entries for these pages before free'ing them back to
+		 * the host.
+		 */
+		clflush_cache_range(__va(pfn_to_hpa(pfn)),
+				    use_2m_update ? PMD_SIZE : PAGE_SIZE);
+next_pfn:
+		pfn += use_2m_update ? PTRS_PER_PMD : 1;
+		cond_resched();
+	}
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 60783e9f2ae8..29dc5fa28d97 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5087,6 +5087,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 
 	.gmem_prepare = sev_gmem_prepare,
+	.gmem_invalidate = sev_gmem_invalidate,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ff1aca7e10e9..f91096722e29 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -737,6 +737,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
+void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -757,6 +758,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 {
 	return 0;
 }
+static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
 
 #endif
 
-- 
2.25.1


