Return-Path: <kvm+bounces-15149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 396EF8AA347
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:49:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E580D288964
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371BC19DF5C;
	Thu, 18 Apr 2024 19:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EhAD4X5e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C216517AD72;
	Thu, 18 Apr 2024 19:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469565; cv=fail; b=mIo+5xH7peUEB8++wUqEqo/7d305pLuc/gq8PN3Eu4vX/QVxudbvZnJfquxWKQXVBt1s/EaSbX1XbnVPuZlKAyjbk/KJjjhamlEcE8DiKmn63iloW+WeTauYYp35kc78xsGth+kUkIjkuHzMYcpxtrBz9FrWYUFrFdO6exT+U/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469565; c=relaxed/simple;
	bh=XEreU/KW8d+SnBeNC3vL2Vk1MUDEc4e7mpA0rCnjTZA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L4YQFYOomCrfeLzmXsJT0ykE7vJ2Mmpk+EekS5AH6Y5BQzxtV/WEDkoPl2LkGk5IU8YBR1YTyHd8OJLkejqM/z8FopSpQuPlTwDL1CNbWiMXQCsJihP5hADVTDABQws8z0jYqjWuxLykNPlbz6EiREGQz8yBSNJWJ31WUlVkzoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EhAD4X5e; arc=fail smtp.client-ip=40.107.243.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxJ7UIMdL74KCBD7HpmQ5zgQ1jgQhLkofPqGMoHuHH01Qyyg69BkQqE8F4laDvV2NJ3XPp7k0YC/SWmzWrnNHe/yA27QUln3gaDMXySlaKL1kc1Qu1Obk6iXCPv+ueKg87a4fsc/SRjzEe+/as4SrpR9bZREBD0enCuOTQOFzPIExTFkGhRAw1O/WW8SP4qxEecadSzaYlyDqMLNhAkyBfAUZiT8Q84mkBrfC70XnRsDLLl2Uj3QmORBHYODsDsfHMJ4zWJ6CK3j13m/b7b+ix4RCLSJmZNLhXfxhftDneoADsOPVezhHYkht2pAOzOoKuFq/Kzyfcxam5bnHqKzTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MtJ0CbnPYcoNEBTs7TIJH/j0ZqiCTVlnNUX1frLxFaY=;
 b=k7TktPOvywX3Bub+ycyMAq0tfqPJGp5pSMg/QH8s2sS3qkZfUnjmx+wppPalThX1ThFtm8oqXHhsaLf18/hFDxnJZiObkH2+XoYsurjCb1JUoA3TK9+j2yGtn7TXhS8ptVjv1YvwnafTU91Jon9/+bXhS7NNjn29Q1+C71yBM4Z/YNFhRcpa4Qc/ymNvoi29/w/gQRrW+fnoy1aZaBjDwgwRDEmiBLyDLkNxBu9whF3s0C9vuQRy9SZ8GFC875KCQlocGAxMGCq45iI69/dy4gjPJA+u0U4sOoWx5WBQpT25FeD4owY6Le563qmjyaDbvSMfyE8UG4ggnJbICAwnvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtJ0CbnPYcoNEBTs7TIJH/j0ZqiCTVlnNUX1frLxFaY=;
 b=EhAD4X5e9U9U++R8b0N1QMKDTbT7+CXlcKcDBCavWJ3wOyqm2p+tqLgAD3Jw8Ys4Q7oRCvCRk5Gb+C1AqpBYSku048ZsaBHq5e05B7Gyp9edF+CrmWAxWnu6vf04/EHxDVDkU+uvIR+9T7C0MzexVXxNjnVzOCx/Icc4hcKqhHo=
Received: from BYAPR06CA0043.namprd06.prod.outlook.com (2603:10b6:a03:14b::20)
 by PH7PR12MB7938.namprd12.prod.outlook.com (2603:10b6:510:276::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Thu, 18 Apr
 2024 19:46:01 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:a03:14b:cafe::2e) by BYAPR06CA0043.outlook.office365.com
 (2603:10b6:a03:14b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.26 via Frontend
 Transport; Thu, 18 Apr 2024 19:46:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:46:01 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:45:59 -0500
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
Subject: [PATCH v13 19/26] KVM: SEV: Implement gmem hook for invalidating private pages
Date: Thu, 18 Apr 2024 14:41:26 -0500
Message-ID: <20240418194133.1452059-20-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|PH7PR12MB7938:EE_
X-MS-Office365-Filtering-Correlation-Id: 5af138b6-7f59-48bc-13cd-08dc5fe02cf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CIHzGPB4xhk9gRrByuRWgzNy/AmdnvFCVzzz/nbtPk12+Bkep+58cQdUiQIR2DAWzocs2VVn2HwCkv2gKubi0tDFJg5jECAp77IbOgGvtpakbZVe94jztFVZuB0Sz+QJhYv6U0vUzrZEGituq/7dV7JfYf9WsohCqM6K1QAYJtsvm5o3MN41cM8Ooq86ywOFDlgj9QIEsAa8ljIQxR1/PlDEbsbpuJ8Z/K4Z0f1kAwaroqJH5MS5Wy2d1mLxae1QhJwZd1TG2s74xZXYUqv7ZAmw3I2DiDHaaQgXPHm+tRLroXSFR3gleu3Q/I+rxSa5QlfBkmRO1GFwJ0PlEt6E9CG0WF6+hOg8aKPbHBkwvPyh0he/vhiGUSRaKHCcW+TPBrp+5u/tkiSauwGlWumZfen7VMm76tueK3B/iQKzzWMJe94GzArNBaUcNVOXIkNFMk8pcDYsU43YReD4+5Q46PYVQc6nDqi0BKeYB4MXXhITlov5QZGjTB9Ld+dFa25bswcRXwima60UC6aky4jwMltXhmX4uYeC+tgI8mFSb7V89wxCfs5DFUEzXlX3IE00flzVtbFGSZZ3m5ZkR+g7vDF+v7uQwUHoZh0EGxRKHgpIWoXBi5zt/NqPMDSNrN/E9CxVpyq7gc0v2GsmDxP5s3vcAs8JxtV6Wx/SC2b3JAr7GLPgFXVf+LM2eTD7T7ZHAgmZruSdHjGOJER29vgohbk5Dzln4/pKHwuQPqO154o4iwlD2sP96lKeDEjaxEfh
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:46:01.0155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5af138b6-7f59-48bc-13cd-08dc5fe02cf6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7938

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
index 29f6e8dc29c8..f60bb8291494 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4455,3 +4455,67 @@ int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
 
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
index 3e8d0752bf1b..60d121250b0d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5082,6 +5082,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 
 	.gmem_prepare = sev_gmem_prepare,
+	.gmem_invalidate = sev_gmem_invalidate,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7712ed90aae8..6721e5c6cf73 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -731,6 +731,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
+void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -751,6 +752,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 {
 	return 0;
 }
+static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
 
 #endif
 
-- 
2.25.1


