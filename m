Return-Path: <kvm+bounces-5391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 584B18207E3
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D84FE1F22AB3
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAEE0F9CC;
	Sat, 30 Dec 2023 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VUYVhN4I"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEE414F8D;
	Sat, 30 Dec 2023 17:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zg8NmP2Zlp8Ao6bHGMApLSQ22CUAbDWVaT074O3qR2tRl+V5OfwJBda0wVLTSgwSbN4oXMrJiaEsr5nB5f/GbUxV0t5xGSDtdsd3YC8QTNfRMibQ5+NHVyyitzUyelin35gh+5TCOgF9UOeoW2qsEt+YHqtFJpzVCXaBF3cTTVqgwC0JhjAKedouOBMbL4kU2UWxP2sia3vNjv6iXotEjb89Wkp/jgZdemyL68DIKsy/Z1dbqbb0aW/V6hVidU+3PRK999lPdb83M3deGTanoKn4VBrYIonQ+a8qNOS7Zp31LoPVba2kkMh6/bHqlqBFSn7BLWoM0XTntN51KDfYOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1q/IDF0qYXkJ286SdCGuzAGffimqSfzL+i/Gnvr/GE=;
 b=H1knlMFy3HGHVNHg7wzYaPWL76Ucsnr4nOdV61orurK8bPRbJlFFb76DrBO/NW+JL5EuxTi286aCUhP5+2XyYWLbmTUQZr9qh9i8RBoJdzm69+XVth74k3YFcM8V7aBTiBCUGWCALOKwGArTPHwdk7+mB1OmgFHsPwRYQeE+8VK8xZnlzhFLBN0D3iVEcWzEpPw6s42f83qaSd4SBrwD4wSSNqT88h6M7EBREG59i3xkrh9HBuSKleIcexpoS3xcP8i5N9MZjn+Dl1B4hxBFUe2hwnCfcJieJBjxrI6iIuEDRwaXP3p8QFvkLrtAfsfTxpHFU/HHoH/704Y1pfLDdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1q/IDF0qYXkJ286SdCGuzAGffimqSfzL+i/Gnvr/GE=;
 b=VUYVhN4IWVOC73YCYiJCsqooGSqlhUkASWX/PD+CgZsrb15d7vfFKasYsUd0EG2QP6DUdjfGcL7i4vdwVfZSQrPUx7SVFtuP946FndeQMbUvOEH7ck7NxYlEMuMiAb/mlUIbOYVmd26JkV2Z4JUEGC3dR83MthoJHOKpoihiitk=
Received: from SJ0PR05CA0196.namprd05.prod.outlook.com (2603:10b6:a03:330::21)
 by SJ1PR12MB6121.namprd12.prod.outlook.com (2603:10b6:a03:45c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:31:40 +0000
Received: from CO1PEPF000044F1.namprd05.prod.outlook.com
 (2603:10b6:a03:330:cafe::cf) by SJ0PR05CA0196.outlook.office365.com
 (2603:10b6:a03:330::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.8 via Frontend
 Transport; Sat, 30 Dec 2023 17:31:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F1.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:31:39 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:31:38 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v11 28/35] KVM: SEV: Implement gmem hook for initializing private pages
Date: Sat, 30 Dec 2023 11:23:44 -0600
Message-ID: <20231230172351.574091-29-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F1:EE_|SJ1PR12MB6121:EE_
X-MS-Office365-Filtering-Correlation-Id: 87b6613d-9e15-4c77-bf06-08dc095d2ec5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xd0vzeKXW6RfAphrsqWrRZctvoPd6zoOA+EfHPMKxWJbEUJ3pqAYCiWiXvH0GsA66rhxkG9M5uG11gDy2pv/8mce1NbOmOQxuB7850smLNz1pxd32CgEcfzM8H9uhazdy+VYJ8Y7KFGAWha6fYn9NCRD4M5CXdyy7Hj7KKqkfbvsrzWsSpBn2+HcZ2YddMbEjjNdXflzqjUVcwf7rdPmtsR0XOs6QbvXNMRcAofFervfNBybumyb6pRNAJRpGF0/FLIpvdHfe3ZwCh72ij8+UYBl7N/vHwfh7+qWvK2j9vc2Pj91skEMdNNQBIAuSOoPMHjalJP6VWykqp65Q7HyP51Xtwmg+ABZBQwRKNk2KQW3KFUtLeHDj6qp4NlcXDX761mK4c0HRJ41slv6jMM/lwfE5xQuUtRuovDztNwK/TWb0/gLFTKVDPYL+WQITsYOt4v16kXZiMtwMOuHF5i6Wv+CDj9RnYIRn5yBuSUW5L/BFU1QdkRjIxTGA0URWqjzXdEt0Ywp6lOzI2kcbUCKdehyd8h72EZVPwzOR3sJttJScL2FP2eGL28BB5a33zOu4NSqmUNsS7kCThTq2o8ezXOFTZKp+g8LotZLzveQBtxj70JUJuANw2VeOJIlnTCQYuVSbPO0c1C4vA4cQviYarye9PbNsH+dUPY7/ZZZERMShr2bMnmNC9ZJPizCwEAekDQJtfcNEbPJpqC3Z/gqJOT+2jBEEP0QE1HFsUsUuQK1WmfuALhRvpHhoaGhVqU2AhmH74foySSQY+qNem9WJQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(396003)(39860400002)(230922051799003)(1800799012)(451199024)(64100799003)(82310400011)(186009)(40470700004)(46966006)(36840700001)(40480700001)(40460700003)(336012)(426003)(2616005)(16526019)(83380400001)(1076003)(26005)(86362001)(81166007)(36756003)(356005)(82740400003)(4326008)(44832011)(5660300002)(47076005)(7406005)(7416002)(6666004)(36860700001)(54906003)(8936002)(8676002)(70206006)(70586007)(316002)(6916009)(2906002)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:31:39.9368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b6613d-9e15-4c77-bf06-08dc095d2ec5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6121

This will handle RMP table updates and direct map changes needed to put
a page into a private state before mapping it into an SEV-SNP guest.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig   |  1 +
 arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  2 +
 arch/x86/kvm/svm/svm.h |  1 +
 virt/kvm/guest_memfd.c |  4 +-
 5 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 4ec53d6d5773..79c002e1bb5c 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -125,6 +125,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select KVM_GENERIC_PRIVATE_MEM
+	select HAVE_KVM_GMEM_PREPARE
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b2ac696c436a..91f53f4a6059 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4154,3 +4154,101 @@ void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
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
index 240518f8d6c7..32cef8626b57 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5065,6 +5065,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+
+	.gmem_prepare = sev_gmem_prepare,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d953ae41c619..9ece9612dbb9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -725,6 +725,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
+int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 
 /* vmenter.S */
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index feec0da93d98..ddea45279fef 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -66,8 +66,8 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
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


