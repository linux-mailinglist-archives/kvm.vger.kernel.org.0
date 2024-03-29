Return-Path: <kvm+bounces-13126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5DA89277D
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:04:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 126712816B6
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B199013E417;
	Fri, 29 Mar 2024 23:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="maozduhT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2057.outbound.protection.outlook.com [40.107.101.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F0C13DDA9;
	Fri, 29 Mar 2024 23:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753439; cv=fail; b=OToffMBxb+NE1Ro7Q41JzYbAcIq8uFE4K4SDhJ1Ym4+JFJooPjuT6AV8VrXO6cOK2dSyWwPD5Xit1kKXiFvCSOfzwoqoha5XlzHXll4POULJErFtWta/5uJoU3zbW8JGZFcSppiaTMPVglouhnps0zbC0+qlw0ZVQLGZdXuTM+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753439; c=relaxed/simple;
	bh=6CkoOOZ6AkdlTCidjobtJtqJrQP4jEWphKSjDEn4SGo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N8kHhBgF3VX/Dha6ptWvVyksLM8T4xvLFW2ansns6bn2p6ZDFW5p00VnEWKldg3d28hEfyAs+qXgxDtJgazwy5bk05TNeudy9y3lHFCT6w5q/rdCM1EWneA1nvLJrDeZA22m3nqAbC5r+NUmp92TUXwEnI0ufi3J10EWtpQJWgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=maozduhT; arc=fail smtp.client-ip=40.107.101.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9q7SU+cHbNFCuzRrRJUzYl+bRZrsB3k/zZbwa8LDc/xWCBYnjkfKF6rr7QfwH/ogyImiBXQiWYsyC57dXibUxknPN6fTzMpRT90iRMOhs9mYBhVccZ8sEuknMaqOUq2nAza1gv3RLsnlnFq0JC2t0C5gggO73HCGnGoh9aOjPvNxeCG7C7arJEeisDeMhi5nNPvcmo9Yo4W7fYbj80I3f2HWNfl5vvQnpCk9IacGuHfJRLKZn6JmuNrxnBReGO4Ss6wcTVgBBPCheVU383o6pYnbMNEAc0OFx4vqE58tPkFn39yPs/bS2zPsevBu/Ogl+cltdKN5zuhmiwkvIUzuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+K7wLY17tKpW9sKriGkhTyOexBAXsP2mhYMvVxlJ3E4=;
 b=Q5MMpowWCH8aqoNSM9iO7EsAFo1BS4QA0XI6+h3IoblfwzCEHz83iiVw2vBW9Ut+F6Hj1+Smj74f4F/A1d93wKDIEOSqDmN50brow3cxE2FQFp3E6QtzwePWlxFoAI16VteYO/DkJKaNAfk1RTy6qj2AS3KMNLzPHFfSKi/MJf2UQhw4Y0TcZWW5XX4wUCZUtJIRCA4asWpUSFy3NV7fW9j08+KWu529c4LyhWS1yH7zMD+Zldof7GoCwiHeuRWM0q/+kp/oS51mXazPHbX0uBZLOQooovyiCKxgRbZ2SPSVz8wdalxIkmbn7W/csTaXTz0rGVhEFkeOZZpOE3asWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+K7wLY17tKpW9sKriGkhTyOexBAXsP2mhYMvVxlJ3E4=;
 b=maozduhTFToc56YvcdflPOJEtVas7K+zEDP/mYpEEafnbIPK5Ya8js71OMrmY9gMew0wn8oIbmAyG5qAhIC6zP8hI6u6rvLjRRXoi4eeUOMDNH5G1HffPIcDRbcM7DjFM2DmLknG9ZkaTSaIyIwpY3C0ITxO3g+sKZCz4PT8K+w=
Received: from SJ0PR03CA0024.namprd03.prod.outlook.com (2603:10b6:a03:33a::29)
 by DS7PR12MB6023.namprd12.prod.outlook.com (2603:10b6:8:85::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.40; Fri, 29 Mar 2024 23:03:55 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::1b) by SJ0PR03CA0024.outlook.office365.com
 (2603:10b6:a03:33a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 23:03:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:03:55 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:03:54 -0500
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
Subject: [PATCH v12 21/29] KVM: SEV: Implement gmem hook for initializing private pages
Date: Fri, 29 Mar 2024 17:58:27 -0500
Message-ID: <20240329225835.400662-22-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|DS7PR12MB6023:EE_
X-MS-Office365-Filtering-Correlation-Id: 58fff027-36fc-408b-9c2f-08dc50448223
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	r8RF85uXm7G8R/dtDU2aw79j70sRNRJBs4rT3hVI1vAVaFTVa7ps8A775WR8TQXuA0J98qJsC8zTaAp9pS6JyV68fvlEF3jz2ti9tj6iE6FYnFI7DFgI3TyjBfHzlCRClqSAAYF65vlPD5hLMJQbF1J2m/WX88BOi6LGMCmRO24ECCCHhwH15FiZFLl3r2ySV3r/uMro2X4pW640woloVHGDKTJ+RjOC58tm7TybvZULJNA2fu26aJU9U4PC/pSy13tRB96CDi/Erjj4L5bL6cn46Bmh9S2984quX+mShmm3stQFcAxvqNVYEYqrEWMUzacTwxPw6jdozU/yGArnbPfpIDCSGTGkUpR0bsf/VUUAzodfqv0Oaf/DEjtI7sYD5euUohmEyB3f/FLyx9ybUjJQ+xJa6We8/YIEpIsM+3BDQg3fVEjDzlwdOLadFWTb0HFM6xedw5lDG0QPaLiCs2Kc3fnkKKgZpDb/LBJcb1QnZgARL8T7i3ho+CLCFj5qcqBtWjUr2+rxeWhXPVRZ8H5iUD8evYfgUyNcDd22ZQPYZnlusf6tEshDoRolvfxOVatTLGscI2WDod/f9A7b7h32Q7129gV1qzJ5yTu6i5xRp+YAN5T1fIT09KUEgLtU+XUeYvOH7i2zECEzsGeo+OT4O32GLU1HPDfHgzyii4AcHrNbzqlZfEJ8rTPTf6cbunJILH6ht7IliJNbcPAca45+bXpnNxluUiwxcNgjsuR3krgvUK9bE9thSeA0PToe
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:03:55.0044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58fff027-36fc-408b-9c2f-08dc50448223
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6023

This will handle the RMP table updates needed to put a page into a
private state before mapping it into an SEV-SNP guest.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig   |  1 +
 arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  2 +
 arch/x86/kvm/svm/svm.h |  5 +++
 arch/x86/kvm/x86.c     |  5 +++
 virt/kvm/guest_memfd.c |  4 +-
 6 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d0bb0e7a4e80..286b40d0b07c 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -124,6 +124,7 @@ config KVM_AMD_SEV
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
 	select KVM_GENERIC_PRIVATE_MEM
+	select HAVE_KVM_GMEM_PREPARE
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9ea13c2de668..e1f8be1df219 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4282,3 +4282,101 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 out:
 	put_page(pfn_to_page(pfn));
 }
+
+static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
+{
+	kvm_pfn_t pfn = start;
+
+	while (pfn < end) {
+		int ret, rmp_level;
+		bool assigned;
+
+		ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+		if (ret) {
+			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry: PFN 0x%llx GFN start 0x%llx GFN end 0x%llx RMP level %d error %d\n",
+					    pfn, start, end, rmp_level, ret);
+			return false;
+		}
+
+		if (assigned) {
+			pr_debug("%s: overlap detected, PFN 0x%llx start 0x%llx end 0x%llx RMP level %d\n",
+				 __func__, pfn, start, end, rmp_level);
+			return false;
+		}
+
+		pfn++;
+	}
+
+	return true;
+}
+
+static u8 max_level_for_order(int order)
+{
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
+		return PG_LEVEL_2M;
+
+	return PG_LEVEL_4K;
+}
+
+static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int order)
+{
+	kvm_pfn_t pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
+
+	/*
+	 * If this is a large folio, and the entire 2M range containing the
+	 * PFN is currently shared, then the entire 2M-aligned range can be
+	 * set to private via a single 2M RMP entry.
+	 */
+	if (max_level_for_order(order) > PG_LEVEL_4K &&
+	    is_pfn_range_shared(pfn_aligned, pfn_aligned + PTRS_PER_PMD))
+		return true;
+
+	return false;
+}
+
+int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	kvm_pfn_t pfn_aligned;
+	gfn_t gfn_aligned;
+	int level, rc;
+	bool assigned;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (rc) {
+		pr_err_ratelimited("SEV: Failed to look up RMP entry: GFN %llx PFN %llx error %d\n",
+				   gfn, pfn, rc);
+		return -ENOENT;
+	}
+
+	if (assigned) {
+		pr_debug("%s: already assigned: gfn %llx pfn %llx max_order %d level %d\n",
+			 __func__, gfn, pfn, max_order, level);
+		return 0;
+	}
+
+	if (is_large_rmp_possible(kvm, pfn, max_order)) {
+		level = PG_LEVEL_2M;
+		pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
+		gfn_aligned = ALIGN_DOWN(gfn, PTRS_PER_PMD);
+	} else {
+		level = PG_LEVEL_4K;
+		pfn_aligned = pfn;
+		gfn_aligned = gfn;
+	}
+
+	rc = rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned), level, sev->asid, false);
+	if (rc) {
+		pr_err_ratelimited("SEV: Failed to update RMP entry: GFN %llx PFN %llx level %d error %d\n",
+				   gfn, pfn, level, rc);
+		return -EINVAL;
+	}
+
+	pr_debug("%s: updated: gfn %llx pfn %llx pfn_aligned %llx max_order %d level %d\n",
+		 __func__, gfn, pfn, pfn_aligned, max_order, level);
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a895d3f07cb8..c099154e326a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5078,6 +5078,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+
+	.gmem_prepare = sev_gmem_prepare,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0cdcd0759fe0..53618cfc2b89 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -730,6 +730,7 @@ extern unsigned int max_sev_asid;
 void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
+int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -746,6 +747,10 @@ static inline int sev_dev_get_attr(u64 attr, u64 *val) { return -ENXIO; }
 static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
 static inline void sev_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) {}
+static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
+{
+	return 0;
+}
 
 #endif
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 617c38656757..d05922684005 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13615,6 +13615,11 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
 #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+bool kvm_arch_gmem_prepare_needed(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_SNP_VM;
+}
+
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
 {
 	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3e3c4b7fff3b..11952254ae48 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -46,8 +46,8 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
 		gfn = slot->base_gfn + index - slot->gmem.pgoff;
 		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_head(page)));
 		if (rc) {
-			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, error %d.\n",
-					    index, rc);
+			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
+					    index, gfn, pfn, rc);
 			return rc;
 		}
 	}
-- 
2.25.1


