Return-Path: <kvm+bounces-7065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BE4683D3A8
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:46:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7768D28200D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7F3BE4E;
	Fri, 26 Jan 2024 04:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="26LcK3hw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A1513FE4;
	Fri, 26 Jan 2024 04:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244347; cv=fail; b=AlT58ZNYTNU8kwiToto6EEB3tpZj/MIa/hMNz7AJnUqjMDrsLzfG37+/aRR60hJBJcZUY9Pe5v45vjXK/xMCgHTZE5umfLLHb013HTPqviTQjnRE2BouySYgrJh1Y4p1O7jtMc9xAEcdmoTO2HquHreFsY9FmuyJITfIv53OjKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244347; c=relaxed/simple;
	bh=InY5dwA03BhVFVqv+Z6ShNccNA8kOZvYoL6P9/6iS6A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eCu5fDx6gH8UW+2YaO0IYTZ9h/No4pEdNFQghPYeahqUugxt8/WbX9nheJQ9/0crei0yz+0MyXYqRakuq6ga8OGnsfTvFOlk13Wg7LepbTV2a2Tp8O2BbDUNVxcCESb/vNXaOjOBqg4dWWD6v6As8bYrCQ48VJxph4gOyJvgiO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=26LcK3hw; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VDPAFUKtRofZIhx2Rnecs1yuorc8mimYqsMxgyLxMtXWty3g/bNWhjJoOhMqhsb+qEnXu+h0EsBQ1oOW3QAnfZkIlSDA/mn+Bd44r4ouMwMlZzGIOaf7vIy0evxx04fxZUnYbALeEEO6qeQcFt6m6/WKcCZSRYiaqxAHYTA06ByemZEWju8UKW3kyGpJiSuR60EakiAq1d+2sYJghJRA3FHJLx+xzhtzozZfVS6gRhCysv/FPArfWgxxqd+Oe2CA/a2mIc0mzbTALfCTLPA3QHf+cbUm1BCE+Jl3NDCulFkqSDnSWyEibg7b5AIjaN5qBRpH0PEh5VN+/P2/OBsq8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vOqbJt4AWqrFUm6TwvKdJ4cOhGB1Q4xIXK8repYmn8Q=;
 b=duE3Y6hLNbmsayEXZuq0V+NFG5ij4QtNM2L4oGyWL4wfd+tAxmI1BT67d+lWGe8SUoaynCfLpS4jNqm1NIWsMRnoPXUjMGKDbw/7JB5pgsfuSoazFnJPOHyWmEzpjKDYKteWPLo60OMfIquXNI7eZl06G8NvDokrpSPJg3kckVpfKTWNUWthJp/SW3BT0M0XGmmc7QEiG/2kULzjUSFqWYu0fx30dU6ohT51+ZwmgxcLIRfESu2NEVE49GwB86yYCZgR+G7gzqA0h0SoZnoxAIRgbrAKLf5SosKmN9FDPFDyQ+IMN8nP6PxbHIoxsF+q8TN97p+7zyAa4FzHADdLvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOqbJt4AWqrFUm6TwvKdJ4cOhGB1Q4xIXK8repYmn8Q=;
 b=26LcK3hwjochdB05JbxrZNmz/4y9l6UEwizxNuY/Rfk6BtoT2pjl+LE2Tl9VPZkxEttXN5iBABoWnyyxrnIRiiv+Jgm3zyCjgD7z+G17DdSYPcrIh7WifnCBrlKx93wbrUVqivWfCgOo+6QXlzbgVtd6NGbYyNetfVpkNbTM/ew=
Received: from DM6PR08CA0011.namprd08.prod.outlook.com (2603:10b6:5:80::24) by
 DM4PR12MB8521.namprd12.prod.outlook.com (2603:10b6:8:17e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7228.26; Fri, 26 Jan 2024 04:45:43 +0000
Received: from DS2PEPF00003439.namprd02.prod.outlook.com
 (2603:10b6:5:80:cafe::86) by DM6PR08CA0011.outlook.office365.com
 (2603:10b6:5:80::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.38 via Frontend
 Transport; Fri, 26 Jan 2024 04:45:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003439.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:45:42 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:45:19 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>, Marc Orr <marcorr@google.com>
Subject: [PATCH v2 21/25] KVM: SEV: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
Date: Thu, 25 Jan 2024 22:11:21 -0600
Message-ID: <20240126041126.1927228-22-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003439:EE_|DM4PR12MB8521:EE_
X-MS-Office365-Filtering-Correlation-Id: ce326697-6c1f-45c3-fa13-08dc1e29a752
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TRaHYen1j3hWp/i4+RwYnPQSVdKEkvEzZlJDTP+R5EIPr+SvHcQJWNvx6S4G7rX9rDx32AwyEAWWDFWAGmBEwKrA1kVfibCh660wxDiuKf96l7DNSDQiRekbLAJXbmf1Ak0ALxpj+GAtYe04Dxp6/yYhHxUOS5PqNNtsy2ZyoIevk+JjWBYv0C0I4epG26dQzhdIZ8DKMOKAubaeUj85tgfnhlCqY56RhpOrTQLDvR6KXQ63f+f/LBj5mQ5mMAq5sG6TzETh3MUkexqyYwXrkOfLJi2as1AqtXDqCHVTqsptp5ab3JBNDHdp4zFmYWjTDXhOeCyHAHEReR6aYGTGHZqCUe1K+duN9bJMTf9WOQ1KEidRCbrY+ZJ2za8O2iuwCClM8SIm2wQEpg1m/ieHwtEG27GGB6oDVMwEDZYqXe0r8OwFZOPapqysAf/86P1QXKqvItAoMo3NJoIomTchKORj1W+fcwao5sn+wYbHvBVbJvHWlfzsy9MwkI5llv+iSHrN18GTrpKDw4iJZ42fM6qdEHh/9s9XW6PR3hNUAs7a+cj83g+xCulH8z4JEbK5EM5H1vzSzhLUgLvXxPIv+b0xfkBcfeFiB8fI+OuOHzt2UAx07NDLD0sAjvqTRX4IP5nzRf39cXVhhEaata2tLE3//SgaquzI0tMr0iMu/CA7VLNfkz4sddz4CMexnCAnwXG9cLMRKxdCry3eDExeYOnhbto0JYB6E/gr1XsFcO7ghTiacp5wtt+AlViTjNMN9qDiy7NmahyTdUlCkJEeXg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(396003)(39860400002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(82310400011)(36840700001)(40470700004)(46966006)(336012)(426003)(1076003)(26005)(16526019)(36860700001)(2616005)(356005)(6666004)(7406005)(5660300002)(83380400001)(7416002)(47076005)(2906002)(44832011)(41300700001)(478600001)(316002)(8676002)(70206006)(70586007)(6916009)(54906003)(8936002)(4326008)(36756003)(81166007)(86362001)(82740400003)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:45:42.8555
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce326697-6c1f-45c3-fa13-08dc1e29a752
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003439.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8521

From: Brijesh Singh <brijesh.singh@amd.com>

Implement a workaround for an SNP erratum where the CPU will incorrectly
signal an RMP violation #PF if a hugepage (2MB or 1GB) collides with the
RMP entry of a VMCB, VMSA or AVIC backing page.

When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
backing pages as "in-use" via a reserved bit in the corresponding RMP
entry after a successful VMRUN. This is done for _all_ VMs, not just
SNP-Active VMs.

If the hypervisor accesses an in-use page through a writable
translation, the CPU will throw an RMP violation #PF. On early SNP
hardware, if an in-use page is 2MB-aligned and software accesses any
part of the associated 2MB region with a hugepage, the CPU will
incorrectly treat the entire 2MB region as in-use and signal a an RMP
violation #PF.

To avoid this, the recommendation is to not use a 2MB-aligned page for
the VMCB, VMSA or AVIC pages. Add a generic allocator that will ensure
that the page returned is not 2MB-aligned and is safe to be used when
SEV-SNP is enabled. Also implement similar handling for the VMCB/VMSA
pages of nested guests.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
Reported-by: Alper Gun <alpergun@google.com> # for nested VMSA case
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
[mdr: squash in nested guest handling from Ashish, commit msg fixups]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/lapic.c               |  5 ++++-
 arch/x86/kvm/svm/nested.c          |  2 +-
 arch/x86/kvm/svm/sev.c             | 32 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             | 17 +++++++++++++---
 arch/x86/kvm/svm/svm.h             |  1 +
 7 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 378ed944b849..ab24ce207988 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -138,6 +138,7 @@ KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
+KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b5b2d0fde579..5c12af29fd9b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1794,6 +1794,7 @@ struct kvm_x86_ops {
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
 
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
+	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3242f3da2457..1edf93ee3395 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2815,7 +2815,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
 	vcpu->arch.apic = apic;
 
-	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	if (kvm_x86_ops.alloc_apic_backing_page)
+		apic->regs = static_call(kvm_x86_alloc_apic_backing_page)(vcpu);
+	else
+		apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!apic->regs) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
 		       vcpu->vcpu_id);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index dee62362a360..55b9a6d96bcf 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1181,7 +1181,7 @@ int svm_allocate_nested(struct vcpu_svm *svm)
 	if (svm->nested.initialized)
 		return 0;
 
-	vmcb02_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb02_page = snp_safe_alloc_page(&svm->vcpu);
 	if (!vmcb02_page)
 		return -ENOMEM;
 	svm->nested.vmcb02.ptr = page_address(vmcb02_page);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 564091f386f7..f99435b6648f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3163,3 +3163,35 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
 }
+
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
+{
+	unsigned long pfn;
+	struct page *p;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+
+	/*
+	 * Allocate an SNP-safe page to workaround the SNP erratum where
+	 * the CPU will incorrectly signal an RMP violation #PF if a
+	 * hugepage (2MB or 1GB) collides with the RMP entry of a
+	 * 2MB-aligned VMCB, VMSA, or AVIC backing page.
+	 *
+	 * Allocate one extra page, choose a page which is not
+	 * 2MB-aligned, and free the other.
+	 */
+	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
+	if (!p)
+		return NULL;
+
+	split_page(p, 1);
+
+	pfn = page_to_pfn(p);
+	if (IS_ALIGNED(pfn, PTRS_PER_PMD))
+		__free_page(p++);
+	else
+		__free_page(p + 1);
+
+	return p;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 61f2bdc9f4f8..272d5ed37ce7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -703,7 +703,7 @@ static int svm_cpu_init(int cpu)
 	int ret = -ENOMEM;
 
 	memset(sd, 0, sizeof(struct svm_cpu_data));
-	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	sd->save_area = snp_safe_alloc_page(NULL);
 	if (!sd->save_area)
 		return ret;
 
@@ -1421,7 +1421,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb01_page = snp_safe_alloc_page(vcpu);
 	if (!vmcb01_page)
 		goto out;
 
@@ -1430,7 +1430,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 		 * SEV-ES guests require a separate VMSA page used to contain
 		 * the encrypted register state of the guest.
 		 */
-		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		vmsa_page = snp_safe_alloc_page(vcpu);
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
 
@@ -4900,6 +4900,16 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
+{
+	struct page *page = snp_safe_alloc_page(vcpu);
+
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
@@ -5031,6 +5041,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
+	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8ef95139cd24..7f1fbd874c45 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -694,6 +694,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
-- 
2.25.1


