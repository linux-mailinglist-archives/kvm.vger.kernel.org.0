Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28ED64D0CE
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiLNUMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiLNULd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:11:33 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92EF419B4;
        Wed, 14 Dec 2022 12:03:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5dqqnCwMA9gVsTAkOCqErXGgtfzAf9WMt9nd212itrMBFBW8CoOikLu0dmP/3EBvsnT/073ZE/57dcgd2dEO9FNqIKdwFh//3yvEm04q0j/A+fCYXOhRcFGeewTwQlkQKL3H0spooIbnw43lt7cxpIQF/h+QeY867rA6qjAdTwJcDgmG2CbqHUyhfB8DDaMZuiJGLBsRwCWACD+HA6GW/G/bscNZn38SktVt5IrXTnWYNjRrDZtfs5/0dKY3KyttJVmAdErPgOGmCPkGXrfhRu1iJITEp6aXFmiRY/0h9d+l6fUMaw2NWMYgyiSYnjqMSJmEjv0hxCiWsOZHmk7MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOe60nzGdlMzQXs5TK7zEKZesPLwJGtRx9qJrFWezak=;
 b=R9gT8HwAeylbAUtgA1UqHhgBz1Fh+bGrO28+kYk0BeIELYZDru5dcoZygGPUJt5eXyaTcI5eT3UF3DctR5RRS5y3avnVaTtWJKPYvE17S+07T0l/fZMtVUjClBCeOUCK3Fpe5/MRUDxP0hblkxLt6+tUyc+RCCGOxh5RHyPneLbQ4YAaLy+Z89S9wBf1nWB+H98Z7MbaYzELmutn7VW970Rc5czoxks7vS0MDKVH7GaEcxhtHfcD38w87kUHiJ01qQ8QSvCti4aWhKhTpHbaT+xFIylDpWxVvMLQjBNuWaiziGWl+VfxnpRzQwHkCkmwPdFXLAghkD8cD7EMqr1cCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOe60nzGdlMzQXs5TK7zEKZesPLwJGtRx9qJrFWezak=;
 b=JBKlu0ikIUSm19/oD1bzOWKmfViXnrbem6CDW8lNK9XEA6IfWF8lwDH3WOSIyrH18Ny2W5K4R79IWHszYFAWqHYbnsUVN/N9Y2iLYXg5xYLLOqIoQQVk0RHVx+M4L7z3B6w9rIS66xBT6QvdaIIZ6BObGO2+qvv7ikn61zlPTco=
Received: from CY5PR22CA0076.namprd22.prod.outlook.com (2603:10b6:930:80::23)
 by PH7PR12MB6539.namprd12.prod.outlook.com (2603:10b6:510:1f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:03:11 +0000
Received: from CY4PEPF0000C96E.namprd02.prod.outlook.com
 (2603:10b6:930:80:cafe::d3) by CY5PR22CA0076.outlook.office365.com
 (2603:10b6:930:80::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:03:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96E.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 20:03:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:03:10 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 51/64] KVM: SVM: Add support to handle the RMP nested page fault
Date:   Wed, 14 Dec 2022 13:40:43 -0600
Message-ID: <20221214194056.161492-52-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96E:EE_|PH7PR12MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: 208bccc9-227f-4a5e-3059-08dade0e3a52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oFD4Fru9kyvxTEUwaEd0qmp6c5aBjkV8GNHkCFsOoDWFbJDciYM6Sn+G7yyEo017kCiiqAfx011VuV0V9m5t2VBSUHJi0Lk+vhusEWmbGvFDoyXkT1FWQliIWi+yp7OvMYMvgAhpRNWw+xstHc9BX3QTdys+ecD3Gt9zjUBiTEOQIjr/3lGDLgbHVnIDxkz06xppAMoRXpb8oUAyDDFdNql6aoQCgilBSRPCOp7f0MRATKjXG9xLcuTTk1r+Ol+LJYlex+GSZu7gEA/OuGjcEjMDXFZt6vj8+MBnyOF/6D2URVZPQ5ICWvvRS4gFcsa4tr4xnr8QWKbtA3CPUxLjZdcpa3czUtaKOm9/7zJiTehivjb6ALhrlMBhd9/xNjewFuT73yGal5WuUJiz/H6MaGG/G3iaJEGVO6U2boHGP/LqFEDEBQmY35ImzgZzEIz2tu+B1LV9UcErvcMscfX1RxG0CTH9d2cCjuPrnqmKn3Za65VN6/HGkTTxuYsvBHcIiN6yGSsHIry1OBGpbrWjECt8gnlyOH/bbz9r+zaFmtk/Sxpr1WogA186P7LRx17spx30XmmFqOmpVD2iMXpD1LUCi2qsjK7ab5r1jMYJAAIsg7zaB6ixZwNGwqouEQ9LyRRCQHSRsw1nGa4q46HCb8jm8rgqqwzCwNyNYAJcub52ss/DmL4Pp1/Cf3UiA5k7qbmB79c0jZ6GNhGvSpszVH8dpZU/XVopfavfp19xy9E=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(376002)(396003)(451199015)(40470700004)(46966006)(36840700001)(316002)(54906003)(6916009)(26005)(40480700001)(36860700001)(2906002)(426003)(6666004)(186003)(478600001)(36756003)(356005)(47076005)(40460700003)(70206006)(8936002)(2616005)(8676002)(44832011)(82740400003)(81166007)(5660300002)(83380400001)(16526019)(7416002)(7406005)(336012)(86362001)(4326008)(70586007)(41300700001)(1076003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:03:11.4313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 208bccc9-227f-4a5e-3059-08dade0e3a52
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6539
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/svm/sev.c | 78 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c | 21 +++++++++---
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 96 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 90b509fe1826..5f2b2092cdae 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3361,6 +3361,13 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
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
@@ -3911,6 +3918,77 @@ void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
 	read_unlock(&(kvm)->mmu_lock);
 }
 
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
+	if (!(error_code & PFERR_GUEST_SIZEM_MASK))
+		pr_warn("Unexpected RMP fault for GPA 0x%llx, error_code 0x%llx",
+			gpa, error_code);
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
+		pr_warn("Unexpected RMP fault, size-mismatch for non-private GPA 0x%llx", gpa);
+		return;
+	}
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!kvm_slot_can_be_private(slot)) {
+		pr_warn("Unexpected RMP fault, non-private slot for GPA 0x%llx", gpa);
+		return;
+	}
+
+	ret = kvm_restricted_mem_get_pfn(slot, gfn, &pfn, &order);
+	if (ret) {
+		pr_warn("Unexpected RMP fault, no private backing page for GPA 0x%llx", gpa);
+		return;
+	}
+
+	assigned = snp_lookup_rmpentry(pfn, &rmp_level);
+	if (assigned != 1) {
+		pr_warn("Unexpected RMP fault, no assigned RMP entry for GPA 0x%llx", gpa);
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
+
 int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault)
 {
 	gfn_t gfn = gpa_to_gfn(gpa);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1826946a2f43..43f04fc95a0a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1968,15 +1968,28 @@ static int pf_interception(struct kvm_vcpu *vcpu)
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
index aef13c120f2d..12b9f4d539fb 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -730,6 +730,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void sev_rmp_page_level_adjust(struct kvm *kvm, gfn_t gfn, int *level);
 int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn);
 void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn);
+void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 
 int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
 
-- 
2.25.1

