Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F3C72B6EF
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbjFLEtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235433AbjFLEsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:48:46 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B271E1BCD;
        Sun, 11 Jun 2023 21:48:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ibpd94S9wJ3R8CscOFRtFYoJjT7wdfbFkoi0cpevstqNCy450RJrBDGAfHhF/cbUlVDDCu5GErJNw6Uu2UkK2mShVCJnAmiNxXIwTZ9FiPnRZsxwM5pmoRfkqECtMmRAEv54kDovelxsXNr1qBaZn9hU6fc2nhjufYeq4k8Z/W/ajMvqUKvmD00uUEswBq0rNI2ZjoR3Vz5LeXdf2srrfhd1qkKOUzspKU9ngJAv52TdqOROTovn6IDS9bFu68JUVx/H56DFDLMo6zimZTWlCg8+U/OAh+tDofozEovLLBQ1WKDitzXTylOxzOxdSRX90dJyXIeFhFz7b8RckJV+Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E3y+s7+t3OqbSQoznIHk/l3yDEommf/ftwO+lV/tIro=;
 b=PhCOCDg9L6nejZyiXnmARwOdXw/k9l9cluYFIP+pgi/AheMatX/WdLzGBcQeBWFUIl3UEdDc4GqaaBXXG20OPa2ANtnUmHVAYxQfUrgT0GQQkJDUU0C5ZJMviLtCzoLCal6O/VIx3riRXyVFWHdH3SEGFzeBBN4wDhQuaZGpPUxq9oNgu9BwEO3yYM+Dgga+1r11O08Lej7xL5RpVV1XMesnm4iL0qy3MG8dT22hDJf92/ugSLLIhn8cRQM+/XB9nQANpb581YmuqBbbWLnMh+COkzIX2fg79bukspyUhFWFpfQsOCCsJb/IDAWrQTTaHGbZSr5uI9W76YKPoutkIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3y+s7+t3OqbSQoznIHk/l3yDEommf/ftwO+lV/tIro=;
 b=0D7OkJExtOdzx2+c0N0ecrasyFJZsd0eSynonvg2FZCuzI8tuQscvi6cD4mEnZEu3jRO/Ckx2pCJ87I1XEIXv7DIA0VDayflS2zdDB3pl2OHVIW/zsbrPVY4CEsKxauj7ETNNxU/RDEOPHjduyt5Z6gKu48YTuL77C3CDOTskbo=
Received: from DM6PR02CA0071.namprd02.prod.outlook.com (2603:10b6:5:177::48)
 by CY5PR12MB6177.namprd12.prod.outlook.com (2603:10b6:930:26::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 04:47:17 +0000
Received: from DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::e6) by DM6PR02CA0071.outlook.office365.com
 (2603:10b6:5:177::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:47:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT097.mail.protection.outlook.com (10.13.172.72) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.29 via Frontend Transport; Mon, 12 Jun 2023 04:47:16 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:47:11 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 40/51] KVM: SVM: Add support to handle RMP nested page faults
Date:   Sun, 11 Jun 2023 23:25:48 -0500
Message-ID: <20230612042559.375660-41-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT097:EE_|CY5PR12MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ccfaa0e-7e76-4413-6a9b-08db6b001935
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V2Zyvwb47JdoxYXjhACqkbRhZOMMHH4VCfyv07v4gBce+KYaEYYz7PFqP+Kf8m96s9RcCd+Zp/U+4FxCEW54SFw/5u9Rt2mx/dRcRT69PZHpEZK/wCI+r7W8xUTA5QunwYXAE50/p9SA2/j3RZkeObXmkErzudq5v/iWcefZWoZNzY60qageCLyDRukcsB8LwcIwP4L8xAoq0WfxJFyMcaiTeHVFeNnBPXJxoQNVSjWDT3yIXost9ZNV4R2CFrZ4XsqxlaHa/URGmXb9qGBuIprHuEMpsxk77a2jCHfYtO+7JrcbDy+JG6CzWzi54hhEYnRqdNcqE2Cb2EtgQZQ7JFG2JGsADvlHFAYN07F1M+Lu5KB86ivc1+wMpNd5druakJ4vHW0ccjoBnfYr6UTnItPy5KLmcp4kXL9UIYvFnLUe81ZNj6yrJ2VsE+lSZY4trJ3Lk0x/LPzIogpuRSQVf2ueRjcpKagRwOWpjMbePHmqo9VDAtDg5vLQpDE7K52J2Mzmx9V9YWS/qrK7tCrHWTNOizTqxj+9Yf6l3XAtP6bDjnw8+d4V5F+VHb6dkNSlypY8cU6U++CZuKZBKonSMAAbU/Q6uyvHu0sS44dVXfYiyMQ2O3/NhIb/9wKBWK+iIuvPMfRIQvx++7U4dGD/RBVYU9ke5l6dpFwHaI8bqtW98i8Fo8lOxi/ZAYLy8cQwZB/QouwfxvHlq2C0VzFyW+Lu2mmsHCRP+jSjyi7ywRad3JP4d6ZG/cQ8T7kvdn4K6VZnv8hhEOhT/RguuIsw1A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199021)(40470700004)(46966006)(36840700001)(86362001)(82310400005)(7406005)(7416002)(40460700003)(316002)(8676002)(41300700001)(82740400003)(83380400001)(5660300002)(26005)(40480700001)(81166007)(1076003)(356005)(6666004)(36860700001)(8936002)(44832011)(36756003)(336012)(4326008)(426003)(6916009)(70586007)(47076005)(70206006)(478600001)(186003)(16526019)(2906002)(54906003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:47:16.9379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ccfaa0e-7e76-4413-6a9b-08db6b001935
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6177
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

When using gmem, RMP faults resulting from mismatches between the state
in the RMP table vs. what the guest expects via its page table result
in KVM_EXIT_MEMORY_FAULTs being forwarded to userspace to handle. This
means the only expected case that needs to be handled in the kernel is
when the page size of the entry in the RMP table is larger than the
mapping in the nested page table, in which case a PSMASH instruction
needs to be issued to split the large RMP entry into individual 4K
entries so that subsequent accesses can succeed.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 85 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c | 21 +++++++++--
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 103 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9b9dff7728c8..1ba49c5ebaed 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3234,6 +3234,13 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_rmptable_psmash(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	pfn = pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+
+	return psmash(pfn);
+}
+
 static int snp_complete_psc_msr_protocol(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3696,3 +3703,81 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 
 	return p;
 }
+
+void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm *kvm = vcpu->kvm;
+	int order, rmp_level, ret;
+	bool assigned;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+
+	/*
+	 * Private memslots forward handling of implicit page state changes
+	 * to userspace, so the only RMP faults expected here are for
+	 * PFERR_GUEST_SIZEM_MASK. Anything else suggests that the RMP table
+	 * has gotten out of sync with the private memslot. Generally...
+	 *
+	 * However, there is a transient case where access to an NPT mapping
+	 * that has just been split/PSMASH'd can generate an RMP fault. In this
+	 * case the PFERR_GUEST_SIZEM bit might not be set. In these cases it
+	 * should be safe to ignore and let the guest retry, but allow for
+	 * these to be optionally logged to diagnose exceptional cases.
+	 */
+	if (!(error_code & PFERR_GUEST_SIZEM_MASK)) {
+		pr_debug_ratelimited("Unexpected RMP fault for GPA 0x%llx, error_code 0x%llx",
+				     gpa, error_code);
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
+	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order);
+	if (ret) {
+		pr_warn_ratelimited("Unexpected RMP fault, no private backing page for GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+	if (ret || !assigned) {
+		pr_warn_ratelimited("Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
+				    gpa, pfn, ret);
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
index 065167b42f90..0cff050bf5bb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1995,15 +1995,28 @@ static int pf_interception(struct kvm_vcpu *vcpu)
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
index 02edbdd443e4..4cf9dbc442e9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -762,6 +762,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 
 /* vmenter.S */
 
-- 
2.25.1

