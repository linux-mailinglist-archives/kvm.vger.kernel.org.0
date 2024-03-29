Return-Path: <kvm+bounces-13121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 008FE89276E
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:02:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA3D728338C
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBDFE13E8AE;
	Fri, 29 Mar 2024 23:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zw5+RhL/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A08713E414;
	Fri, 29 Mar 2024 23:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753336; cv=fail; b=LzVM2oPKxcDMPhTGrN1EjkcJHNwS3bh+14wE3eIZAlJcRpZ7fViydGmITkkNSe8XdfvC3xvChzx8OBTDynOtxHCmdWezcu5S7Dq9sVn5pZrUfVrtHU8hLP2DTEkow3G+9GQeOf7uuaruamqj7HblM3eLI9JBtPEJe6L6IfchT5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753336; c=relaxed/simple;
	bh=ve0Q/9IkEDuMVauLWMMuYGROPkz8VDXCebbb2IciUSs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m4D9/d/1CgNnpUIXnIDmC2BOqXfLvwWQE5n+ZA+DbK77nW1C3Gq/zLoGVjYJD1/X1NedCKLg6IqZSPipXMyBrCxPdo4/HVpFBHPSJYkuDjnrmZY9Wuca7bQBJBYJ7HwfvE9hBP4nosUGj9Hm+UQqsjhqtaqFMPvbH6J9Dzl87c4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zw5+RhL/; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rpv0NaEcWWmOacEWTJ4zXiLzuFIvhF2pgNzp6IXt+9RIVisgGJK/84XT195gmZgaB6bW/Jelueaazeq5ZGNQkOcWEt0QZJMBz4ceYMBXPXx8aNGhDdcx2RThLdqEanGR4/Y5HLyV0tROWvkbeHUURtdLSthwd30o6EGkEWi2FEe4dUvKI8tifAgUN0MD4EMCmAF5qzBHcM+XCHaCKXu9W8HK7hljQIZ/SGX1fvtWmjFpzTDsxWYWtV1pNl4UU4/L27x57bT7+tfALgs8/bUGVRdCboU/1nMCQEUARiZkwltyFuUkDPvqxy7C9kRSUG6EbtyBC2Uw0sHyoSNa+r3YzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aREpckIK1aTtdsTDTyZ9MXdMoxILhHALRKMNW8mq2U4=;
 b=JyShgHcZa2/wma0PqUHAezNHvPONlHryO8/XJB1I50gnnfxl57oFiWU9/wHoVVmqKtNAmbMEqDws0sNbUmQdLKdYvDX8KOXqiwgGZ5ItdSaTdW/hVRFsmTBSoNbqdPnj1B8AdltPC1n+HdqzfZzgurDzO0CylqwZk75MdK4+xiUUjoMv8PsYAbh0RISnlEuZKdeEYhyqnKtAJ+kWpJFukP8S0JfNY50G4S5e1V5VJMJRpzixURLISWViF222MI8R6S+WQg938MqizQF/+d4OBkjUK+Zb54xcLAcgaB5WCpFDRnSe2RhlrwTlHbJ4lbVwKWCIFLoNtRKfXsXhUVRH4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aREpckIK1aTtdsTDTyZ9MXdMoxILhHALRKMNW8mq2U4=;
 b=zw5+RhL/bwPs4XPGs8H1awi574VvDZOke4fiosae+nVYgXxK3ZQB45aDqrxVN5DHDKXl7Shji5iXQVxjNKXJod67K1kmhzWGQ5lEqQQidigjKYIoL7zsO9fG5TZk8w1DmfuO5IEzGLcDKiiPO513qLKjuoFmKnmLnkv2EOGR9Xc=
Received: from SJ0PR03CA0276.namprd03.prod.outlook.com (2603:10b6:a03:39e::11)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Fri, 29 Mar
 2024 23:02:11 +0000
Received: from SJ1PEPF00001CE0.namprd05.prod.outlook.com
 (2603:10b6:a03:39e:cafe::9a) by SJ0PR03CA0276.outlook.office365.com
 (2603:10b6:a03:39e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 23:02:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE0.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:02:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:02:09 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v12 17/29] KVM: SEV: Add support to handle RMP nested page faults
Date: Fri, 29 Mar 2024 17:58:23 -0500
Message-ID: <20240329225835.400662-18-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE0:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 28caeec9-eaaa-4720-7f97-08dc5044445d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JXTCISndS2/r5x6NMJ2t51Vfu/p6ZmdNWROhuaETSgas9t4XpeEnKggbccuOh7Q+j+6ibsqRa10T6H+RNY/f7HovlDKdRM/wNfHnuxFCPsZ1gh6AiyjHtHZN4EZ2PLlUmQ90dvSUfdVy+1kAAusLmfVCZf59F4BZNReSwwjSihPdwVwSFllZSq582E2WT80rAqlcmuio+b2fZleaW5lP+scaBjnoY1wi3IC4CvKrwM2OQ5U2tfSboz1tzbhquIVdcUgyeulo5Iub4yHrEdlDmJPb1K0Edzo25153XHHRyqHeAaDOOEJt2x5/aDcRU9U38Qx9KSQRY/Djcy9kc7RzY7IRKLjH3XRsmWiLh/27noGI41o9DlAy3/3lidY9/kmDiMdbdDz1pwncBITDWkznU2rBxDb4b5ogSI+Hrvfuy3o2MzNdiIfswSUM/Iw+a/nxja45nLrfM+NyMztnK2extIPkV9UZaGw6yVTBQ21iYqDlCT2txUgbQEPJ+PftUWsXsTjF1hBEfmu07FvQdvieUKOgYsyG4LCBifEr8aJBh4ETKlfuMYVIUbOSRnYYFvALURQQwP6VG5Vv/7UiZrnVaeS8teVws3JcH6k5U7eg42YN4aD9Ucv1ImJHU8BtYr/QLLY/8/H/+PThTFCmnKDgkd2ySOnuz2XqMkYTTZ8QKQ/hxcGDPYcEJRCSpXamJXssFD0CU4VYsq9C3230r2w28ZYLzVfsQv1V00F+qLQ1NQK64I/hVdR//ANKXyKG/AAP
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:02:11.3650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28caeec9-eaaa-4720-7f97-08dc5044445d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled in the guest, the hardware places restrictions
on all memory accesses based on the contents of the RMP table. When
hardware encounters RMP check failure caused by the guest memory access
it raises the #NPF. The error code contains additional information on
the access type. See the APM volume 2 for additional information.

When using gmem, RMP faults resulting from mismatches between the state
in the RMP table vs. what the guest expects via its page table result
in KVM_EXIT_MEMORY_FAULTs being forwarded to userspace to handle. This
means the only expected case that needs to be handled in the kernel is
when the page size of the entry in the RMP table is larger than the
mapping in the nested page table, in which case a PSMASH instruction
needs to be issued to split the large RMP entry into individual 4K
entries so that subsequent accesses can succeed.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h |   3 ++
 arch/x86/kvm/svm/sev.c     | 103 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     |  21 ++++++--
 arch/x86/kvm/svm/svm.h     |   3 ++
 4 files changed, 126 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 780182cda3ab..234a998e2d2d 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -91,6 +91,9 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 /* RMUPDATE detected 4K page and 2MB page overlap. */
 #define RMPUPDATE_FAIL_OVERLAP		4
 
+/* PSMASH failed due to concurrent access by another CPU */
+#define PSMASH_FAIL_INUSE		3
+
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
 #define RMP_PG_SIZE_2M			1
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c35ed9d91c89..a0a88471f9ab 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3397,6 +3397,13 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_rmptable_psmash(kvm_pfn_t pfn)
+{
+	pfn = pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+
+	return psmash(pfn);
+}
+
 static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3956,3 +3963,99 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 
 	return p;
 }
+
+void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm *kvm = vcpu->kvm;
+	int order, rmp_level, ret;
+	bool assigned;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+
+	gfn = gpa >> PAGE_SHIFT;
+
+	/*
+	 * The only time RMP faults occur for shared pages is when the guest is
+	 * triggering an RMP fault for an implicit page-state change from
+	 * shared->private. Implicit page-state changes are forwarded to
+	 * userspace via KVM_EXIT_MEMORY_FAULT events, however, so RMP faults
+	 * for shared pages should not end up here.
+	 */
+	if (!kvm_mem_is_private(kvm, gfn)) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault for non-private GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!kvm_slot_can_be_private(slot)) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, non-private slot for GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order);
+	if (ret) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+	if (ret || !assigned) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
+				    gpa, pfn, ret);
+		goto out;
+	}
+
+	/*
+	 * There are 2 cases where a PSMASH may be needed to resolve an #NPF
+	 * with PFERR_GUEST_RMP_BIT set:
+	 *
+	 * 1) RMPADJUST/PVALIDATE can trigger an #NPF with PFERR_GUEST_SIZEM
+	 *    bit set if the guest issues them with a smaller granularity than
+	 *    what is indicated by the page-size bit in the 2MB RMP entry for
+	 *    the PFN that backs the GPA.
+	 *
+	 * 2) Guest access via NPT can trigger an #NPF if the NPT mapping is
+	 *    smaller than what is indicated by the 2MB RMP entry for the PFN
+	 *    that backs the GPA.
+	 *
+	 * In both these cases, the corresponding 2M RMP entry needs to
+	 * be PSMASH'd to 512 4K RMP entries.  If the RMP entry is already
+	 * split into 4K RMP entries, then this is likely a spurious case which
+	 * can occur when there are concurrent accesses by the guest to a 2MB
+	 * GPA range that is backed by a 2MB-aligned PFN who's RMP entry is in
+	 * the process of being PMASH'd into 4K entries. These cases should
+	 * resolve automatically on subsequent accesses, so just ignore them
+	 * here.
+	 */
+	if (rmp_level == PG_LEVEL_4K) {
+		pr_debug_ratelimited("%s: Spurious RMP fault for GPA 0x%llx, error_code 0x%llx",
+				     __func__, gpa, error_code);
+		goto out;
+	}
+
+	pr_debug_ratelimited("%s: Splitting 2M RMP entry for GPA 0x%llx, error_code 0x%llx",
+			     __func__, gpa, error_code);
+	ret = snp_rmptable_psmash(pfn);
+	if (ret && ret != PSMASH_FAIL_INUSE) {
+		/*
+		 * Look it up again. If it's 4K now then the PSMASH may have raced with
+		 * another process and the issue has already resolved itself.
+		 */
+		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) && assigned &&
+		    rmp_level == PG_LEVEL_4K) {
+			pr_debug_ratelimited("%s: PSMASH for GPA 0x%llx failed with ret %d due to potential race",
+					     __func__, gpa, ret);
+			goto out;
+		}
+		pr_err_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
+				   gpa, pfn, ret);
+	}
+
+	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
+out:
+	put_page(pfn_to_page(pfn));
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2c162f6a1d78..648a05ca53fc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2043,15 +2043,28 @@ static int pf_interception(struct kvm_vcpu *vcpu)
 static int npf_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	int rc;
 
 	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
 	trace_kvm_page_fault(vcpu, fault_address, error_code);
-	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
-			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
-			svm->vmcb->control.insn_bytes : NULL,
-			svm->vmcb->control.insn_len);
+	rc = kvm_mmu_page_fault(vcpu, fault_address, error_code,
+				static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
+				svm->vmcb->control.insn_bytes : NULL,
+				svm->vmcb->control.insn_len);
+
+	/*
+	 * rc == 0 indicates a userspace exit is needed to handle page
+	 * transitions, so do that first before updating the RMP table.
+	 */
+	if (error_code & PFERR_GUEST_RMP_MASK) {
+		if (rc == 0)
+			return rc;
+		sev_handle_rmp_fault(vcpu, fault_address, error_code);
+	}
+
+	return rc;
 }
 
 static int db_interception(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bb04d63012b4..c0675ff2d8a2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -722,6 +722,7 @@ void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
+void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -735,6 +736,8 @@ static inline void sev_hardware_unsetup(void) {}
 static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
 static inline int sev_dev_get_attr(u64 attr, u64 *val) { return -ENXIO; }
 #define max_sev_asid 0
+static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
+
 #endif
 
 /* vmenter.S */
-- 
2.25.1


