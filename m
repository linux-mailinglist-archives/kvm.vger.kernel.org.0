Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9EC7CA9F3
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbjJPNlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbjJPNll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:41:41 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116B4D76;
        Mon, 16 Oct 2023 06:41:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQGRn4Px2G5h6JZOrfdpR+Ghnd0PLHO89UvKPM6o2qRsHKTrSIfWh0gF8/hgjU2P+BX6AGkWK/J5llRybKc0hfuoY34ZjOlb4w88ji0EYvBSflNEnR7rDv+I11sx0lZxqs1+hhV18vh7pdnKdVJYkTaHLsKHLpQXwjnwDz+ayFQ8saKRjGPeV3Pjts1Mmy40TUg8tm8TIrgtto3XD383Xp3KIO9DedBzIV0mDU1cIvU/RIopOIcYo2MlB3YdMXEPLEGcsQuHjdaxKID2VmC4hZkRsR5TpKhSRNeu6FcjoMykOo+caMlCkklkQawrj1jEVp/+xWtTJN5Mz7LNjJfwxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8hxv7UWGBvgSMNbe8UkazNxrQaFcb/05VFnmh4EPoMU=;
 b=nRlRpU90hZM95Yuf/zQzjWZFH4cbw9WP+ILxMu/cF47xuuwgfX7WwvFJLvzNLHdSwPDPjhN/4El2z3r4/Ly9NHh2i2cw0MwJzmyLbugtDgMCbR3XSuJljMG6SQFLgThGtJA1lEEW1XYoFv9kSmYt4dtQK1Rpx2SljqG9Fw5KPd6ObAQlSapbpLnxfI+E2iwyrqt6YM9AATI8VeIQiPBKealch/0aSzndbh5375dEeuLFNdaveu7SLOrxFAFarXl6MzBwFl3ARZJwFFqGyPQj/tirIM0lJwUsusLwzkzNdDGwt+0RRwtRQf/UA+4EITqpm+1CjJU+cK8HIF1CUI8tRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hxv7UWGBvgSMNbe8UkazNxrQaFcb/05VFnmh4EPoMU=;
 b=dZP3Sa9GyQ6gnFNpJxdC6fXcsweMqCuDL7pafXkbDdCC+OGI9INImzeouFxnHfU7OYUYTnCXOKY8Qhtp3ZYehXc40h0vrrogpZw940A09bWVz8ZRVBTK3WOYGlmOUiCI6YtLpGbLZm0yVayNaWbxw7saFiw2rpxUTk+R/cA4FCU=
Received: from PH7PR17CA0057.namprd17.prod.outlook.com (2603:10b6:510:325::6)
 by IA1PR12MB8586.namprd12.prod.outlook.com (2603:10b6:208:44e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:41:33 +0000
Received: from SN1PEPF000252A1.namprd05.prod.outlook.com
 (2603:10b6:510:325:cafe::b8) by PH7PR17CA0057.outlook.office365.com
 (2603:10b6:510:325::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:41:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A1.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:41:33 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:41:30 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 35/50] KVM: SEV: Add support to handle RMP nested page faults
Date:   Mon, 16 Oct 2023 08:28:04 -0500
Message-ID: <20231016132819.1002933-36-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A1:EE_|IA1PR12MB8586:EE_
X-MS-Office365-Filtering-Correlation-Id: 211c9b9a-3f24-4fb9-5a13-08dbce4d9c5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DY4HKDrYW+oRI8XNYyA/ptxyNzE9fqOOmRM0iWYOs/3qyCjdM6yzqCeSLmD9xrSxATlBfd5DfEXtsLbeBx2TlyYJ4OZN0u+hK05Qf+O9La4kywmAnRTK2maNhXop78mHkugRjeOMUk1BGcjb8SWbSSpgwZoQPsLUq7NgnU7o9z3PGNFJL1RrnjBcWlT7dJX3ghQCkfRZ7b1D1jZJRej/hZZhZAjKI3rkJCQ9jjv0BtbxL/dOcfIBC3IIE3yG0UFcMV1utK4YUyEh9JEt+cFu+k9EfPE+hgDb33sqJBbh/Th0Tb62IVAwVA+XAanPpZfgmKJLU5FukGkSd3mCb5J1YXS8QY1ERv3zaYyyYN2on8057JluQUk3eNYzLjYuugt94m/712XiPvK/UTRAWv5NGeHcrh0rCkfmy0Q7ssfCaNPIRRiwI906/MbZnuaQNZp2KX31FEAh9qaDiOOmopNDcCTUXzHObD00s6Y+g2vSoitHPbgWRpzM/sYCtVuW4xOEOo58PHcS75MELq9m3EwOFfF0hunU3qbQS678IraqF6cjHuai574Bygq373l9mAF0fAURr8HqGfEiOhld7bQYJSD4eP555XrWss3iaR+h9zKi4lXutukStdvUMdIX6HR/tAInVf+/rroGYZKImuJxkbE99fpR6pFg6QU8suS/H5/vON3Nx9QgW2yFOGb0OISwkOkhCwu7ZqMw1bYOoAw7qFL/+ZeLYYU+D0S0c+PfclDXhl1QL2ZZhfXwD7Y5r8ptdtuPyEs9viQKtr3sCnUgww==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(186009)(1800799009)(64100799003)(82310400011)(451199024)(36840700001)(46966006)(40470700004)(316002)(6916009)(478600001)(70586007)(54906003)(70206006)(6666004)(1076003)(26005)(336012)(2616005)(16526019)(426003)(7406005)(7416002)(8676002)(8936002)(4326008)(2906002)(44832011)(5660300002)(41300700001)(36756003)(81166007)(86362001)(47076005)(356005)(36860700001)(83380400001)(82740400003)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:41:33.3246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 211c9b9a-3f24-4fb9-5a13-08dbce4d9c5a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8586
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/sev-common.h |  3 +
 arch/x86/kvm/svm/sev.c            | 92 +++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c            | 21 +++++--
 arch/x86/kvm/svm/svm.h            |  1 +
 4 files changed, 113 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 9febc1474a30..15d8e9805963 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -188,6 +188,9 @@ struct snp_psc_desc {
 /* RMUPDATE detected 4K page and 2MB page overlap. */
 #define RMPUPDATE_FAIL_OVERLAP		4
 
+/* PSMASH failed due to concurrent access by another CPU */
+#define PSMASH_FAIL_INUSE		3
+
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
 #define RMP_PG_SIZE_2M			1
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0287fadeae76..0a45031386c2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3270,6 +3270,13 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_rmptable_psmash(kvm_pfn_t pfn)
+{
+	pfn = pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+
+	return psmash(pfn);
+}
+
 static int snp_complete_psc_msr_protocol(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3816,3 +3823,88 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 
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
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, size-mismatch for non-private GPA 0x%llx\n",
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
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, no private backing page for GPA 0x%llx\n",
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
+	 *    what is indicated by the page-size bit in the 2MB-aligned RMP
+	 *    entry for the PFN that backs the GPA.
+	 *
+	 * 2) Guest access via NPT can trigger an #NPF if the NPT mapping is
+	 *    smaller than what is indicated by the 2MB-aligned RMP entry for
+	 *    the PFN that backs the GPA.
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
+	if (ret && ret != PSMASH_FAIL_INUSE)
+		pr_err_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
+				   gpa, pfn, ret);
+
+	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
+out:
+	put_page(pfn_to_page(pfn));
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8e4ef0cd968a..563c9839428d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2046,15 +2046,28 @@ static int pf_interception(struct kvm_vcpu *vcpu)
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
index c4449a88e629..c3a37136fa30 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -715,6 +715,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 
 /* vmenter.S */
 
-- 
2.25.1

