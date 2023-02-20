Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336BD69D3A5
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbjBTTBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbjBTTAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:00:53 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E550B22026;
        Mon, 20 Feb 2023 11:00:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWR+H9k7NaEkDNDswlWqytzOyFuxgzHkRrnjdx6RVkdkBCItfCW4CB5YReE7thhQWyN87qwwuylCq2XkZ0p2dLqXphyFzcCDdU8paRFtrw5fLgg43hXASTjBv3aY1OPq2ti0AXYsKfUrbO9Uo62mYZSZa3Icx9zX9TJJ24kZMGHNPwbiomX9XBoW2QQ13qeJonFhFblBGdLtLcYpbPtxB8RLgt3DnrVGNlauCLF5CE5MFW1WgZOqOzdhiX9AnhELzQKs4coPc94FnMqHR0eS18oYzoWRbhrHmqOh7Yzg/9WeS1WQKx1N2chEf8VtnmhKgvEF35T7dOIRNc0ZfGFZNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDe8g5CKLNfnRX5BP3OujC8LV1qgCmPw2a0wdR51M1w=;
 b=WqrKqVIgzAKh+WxIrBX6y5r8jZxD6CbyXGRjwKoFl+hHGqqvtmRQrcWE+Q6v+OzWcMo+FKj6JGY5aRm416aOSeS0hE6halefBEyXyAdQZ8FUFPIOY1of9IPKrn9dRM+CZThkOZb8E9Y3OtoLjm4v+LC8Bj+BHz3zH7Dx/R+4USCTUPsnBc1qUvJtgjENPa+xaZqUbM3VyC3FdZ73yE/gpg8UwX2BdR7LxJg+VvbeCmHaW9aiLA87iuaHKzIVi5KT+lHAZ0sLJ52era5PBsTFkoy76uNeUwdhPujhCGezK+e4lRZb/a1HoGVBqRPZyArF31bsZkTqJh6RVRlCz/bQnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDe8g5CKLNfnRX5BP3OujC8LV1qgCmPw2a0wdR51M1w=;
 b=ReJS4KP/a2QGuPe/xbRYg/CD+J5NNNucqadI2yiehHDO5KtGGTz7w3eVvdVwivVNlOSl2ztm4HuXsRHTBj2mBQNkSKYzoD9dKCA+qpB/dEjSBN+pBv7kmYh0vIKx7FCZb+OWbuQNgWxceReOpyOPU1yck1Dic/glpDN3qlDg7HU=
Received: from BL0PR01CA0030.prod.exchangelabs.com (2603:10b6:208:71::43) by
 SN7PR12MB8001.namprd12.prod.outlook.com (2603:10b6:806:340::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.18; Mon, 20 Feb 2023 18:56:50 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:71:cafe::d0) by BL0PR01CA0030.outlook.office365.com
 (2603:10b6:208:71::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:56:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:56:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:56:49 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 44/56] KVM: SVM: Add support to handle the RMP nested page fault
Date:   Mon, 20 Feb 2023 12:38:35 -0600
Message-ID: <20230220183847.59159-45-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|SN7PR12MB8001:EE_
X-MS-Office365-Filtering-Correlation-Id: e6faf4d8-d37f-4176-87f3-08db13743941
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hQZ9nMwnrwE0FZrlTBbgCPI8tzQqzUcYb1Adl0EuvzMdgKarcL8D89YkX8G9aaiX9GX3NZHzzHiER0WDmhcDL183KpfIm4bQkGfKqTdDfWV6kiCT8e40zZeqpJ/JXfS5BCbTNfvBRVujhIbJkSyKuZPIEWhSEizvOpXf3ETIe6MiUUNQhIGFKHet6DKTZP6krpjNhxWbuWXhhADhvBn8PQT0K/PrxZ1rQuEgthQX/D4Qi5DBAtGS/RLLUpwP6HJhj3x0yRbua94ADXX2oXrS6iFaobdWrBRtGOp26dvKvc99qKcGCzULWnq7xzzUqsJ6RZcTGWC7i8B7w87IL5DnO985RBE0jWKAE4MMg9eUxE+nrk1Rx4GimdvFELhHfokBwaLeEZq7za35b8qL+dzxhyFUrw3C6gnClgExxNQrK99cHnlyR5QsRMuZ16gFs8IMRLpdNZX52xjllD1CnKk3TdH4FI8RyAw5Ezxz37ltARrCQbG+34+clveN5zhGXMASRzuik44nDXv08pMqOftzUwWvmunC9Mq45iV0J5t4LR0ltBNFjAUjZL7K0LKLPdqpiBgpP8+usUjofMVeNUBX4psutURQ9QHRMfSOmpkxz0/+/t34s+7ZrZCd2D3uEZvwLVnjxt1cRr8OAeexcOHF7VNgh+z9/TVgLaOryCo2N7SfupoFwdKYXIS/rSVzydJ+Vty6T9apxgY6Dtxh9f78ZHrRTF29RqV842k5AUYJWFg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199018)(46966006)(40470700004)(36840700001)(40460700003)(81166007)(356005)(82310400005)(6666004)(2616005)(16526019)(336012)(426003)(26005)(36860700001)(47076005)(186003)(40480700001)(83380400001)(7416002)(70586007)(8936002)(6916009)(70206006)(2906002)(44832011)(4326008)(41300700001)(5660300002)(82740400003)(316002)(86362001)(7406005)(36756003)(478600001)(1076003)(54906003)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:56:49.9537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6faf4d8-d37f-4176-87f3-08db13743941
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8001
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled in the guest, the hardware places restrictions
on all memory accesses based on the contents of the RMP table. When
hardware encounters RMP check failure caused by the guest memory access
it raises the #NPF. The error code contains additional information on
the access type. See the APM volume 2 for additional information.

Page state changes are handled by userspace, so if an RMP fault is
triggered as a result of an RMP NPT fault, exit to userspace just like
with explicit page-state change requests.

RMP NPT faults can also occur if the guest pvalidates a 2M page as 4K,
in which case the RMP entries need to be PSMASH'd. Handle this case
immediately in the kernel.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 84 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c | 21 +++++++++--
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 102 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 102966c43e28..197b1f904567 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3347,6 +3347,13 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_rmptable_psmash(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	pfn = pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+
+	return psmash(pfn);
+}
+
 /*
  * TODO: need to get the value set by userspace in vcpu->run->vmgexit.ghcb_msr
  * and process that here accordingly.
@@ -3872,3 +3879,80 @@ void sev_adjust_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *le
 	pr_debug("%s: GFN: 0x%llx, PFN: 0x%llx, level: %d, rmp_level: %d, level_orig: %d, assigned: %d\n",
 		 __func__, gfn, pfn, *level, rmp_level, level_orig, assigned);
 }
+
+void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
+{
+	int order, rmp_level, assigned, ret;
+	struct kvm_memory_slot *slot;
+	struct kvm *kvm = vcpu->kvm;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+
+	/*
+	 * Private memslots punt handling of implicit page state changes to
+	 * userspace, so the only RMP faults expected here for
+	 * PFERR_GUEST_SIZEM_MASK. Anything else suggests that the RMP table has
+	 * gotten out of sync with the private memslot.
+	 *
+	 * TODO: However, this case has also been noticed when an access occurs
+	 * to an NPT mapping that has just been split/PSMASHED, in which case
+	 * PFERR_GUEST_SIZEM_MASK might not be set. In those cases it should be
+	 * safe to ignore and let the guest retry, but log these just in case
+	 * for now.
+	 */
+	if (!(error_code & PFERR_GUEST_SIZEM_MASK)) {
+		pr_warn_ratelimited("Unexpected RMP fault for GPA 0x%llx, error_code 0x%llx",
+				    gpa, error_code);
+		return;
+	}
+
+	gfn = gpa >> PAGE_SHIFT;
+
+	/*
+	 * Only RMPADJUST/PVALIDATE should cause PFERR_GUEST_SIZEM.
+	 *
+	 * For PVALIDATE, this should only happen if a guest PVALIDATEs a 4K GFN
+	 * that is backed by a huge page in the host whose RMP entry has the
+	 * hugepage/assigned bits set. With UPM, that should only ever happen
+	 * for private pages.
+	 *
+	 * For RMPADJUST, this assumption might not hold, in which case handling
+	 * for obtaining the PFN from HVA-backed memory may be needed. For now,
+	 * just print warnings.
+	 */
+	if (!kvm_mem_is_private(kvm, gfn)) {
+		pr_warn_ratelimited("Unexpected RMP fault, size-mismatch for non-private GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!kvm_slot_can_be_private(slot)) {
+		pr_warn_ratelimited("Unexpected RMP fault, non-private slot for GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	ret = kvm_restrictedmem_get_pfn(slot, gfn, &pfn, &order);
+	if (ret) {
+		pr_warn_ratelimited("Unexpected RMP fault, no private backing page for GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	assigned = snp_lookup_rmpentry(pfn, &rmp_level);
+	if (assigned != 1) {
+		pr_warn_ratelimited("Unexpected RMP fault, no assigned RMP entry for GPA 0x%llx\n",
+				    gpa);
+		goto out;
+	}
+
+	ret = snp_rmptable_psmash(kvm, pfn);
+	if (ret)
+		pr_err_ratelimited("Unable to split RMP entries for GPA 0x%llx PFN 0x%llx ret %d\n",
+				   gpa, pfn, ret);
+
+out:
+	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
+	put_page(pfn_to_page(pfn));
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9eb750c8b04c..f9ab4bf6d245 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1976,15 +1976,28 @@ static int pf_interception(struct kvm_vcpu *vcpu)
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
+		handle_rmp_page_fault(vcpu, fault_address, error_code);
+	}
+
+	return rc;
 }
 
 static int db_interception(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0c655a4d32d5..13b00233b315 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -714,6 +714,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void sev_adjust_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *level);
+void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 
 /* vmenter.S */
 
-- 
2.25.1

