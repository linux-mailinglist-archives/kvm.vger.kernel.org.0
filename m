Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3205F64D0A6
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiLNUFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiLNUEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:04:53 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089EA2B1BB;
        Wed, 14 Dec 2022 11:59:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBPph2rYsW63K/ZH6sKjt+BJ3vAJspwRZyxaNnDfkmTBqBQPsI4uChA+gq4Dn9YPexV81yFYtB1q3W39cIKRFAzFM8CDUVmIWJuzmYwDIN1DGiJd1tChV3KJWp6dmGdc/UARtE/3d+syttQwbxRmNNGWfmMQf9qYRMwsf5pnZtJypTizkdYKgKyEZajDgMM9Ixp047pGXiFQtAPX1H76w56asE6E1K9RBm9l/o+Ygt4A7mtiU88r8lJeF6xC1BFbTIE3HqeoYL3hGtNGoMxJWvpcg0YimLz7AjVdg5m3L6JWyA11vF2Pr05iL7byVwevpBt+zXztwN+huGa0v35gJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIMjY7hiNsb9k1AzgaOD++2qcJNETyyjvIDWnwvrG1s=;
 b=eswmslqJ3L0E56MqKxCYOAskGBimLSdRMfNBYptbr+z+DdQCUIaGt5BNIeTlxpYGSES81d+viqGu2xSHZfQp+Y8ih1J+B+AbtTM9earv/cHnJXpotnhuKdTq/x0wngn+wRIN+V7F/LLEj7wpAFQXOo6ASzE8yiIhKBrmX0GlkLTDuRiUacr+vENIkEK2bMRwk1A9NWdU/o739ufQFzrCcCSGAQm2LhCTnB4CrWUijc4Qpmg5BU8oLcwxm+ahmuJi1PlDeZI+Itx0BSKTQx3KlKK8QogMVZqmVwqj2cPqmFKAzq/hCpP4/WPcwX2jWd4Mt5wGpBDyNSxVAArYwR6AMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIMjY7hiNsb9k1AzgaOD++2qcJNETyyjvIDWnwvrG1s=;
 b=nhhAPQHvtMKk7g7ebClLtOfMOY+phoRMsj375cGCk8YtJiggH3S6kxjV29bE41jZSM+tZWPSM69VFnoEvYLUz+X4PT655eWQslB+gRooi9GZB02kjOP/0myQce5L2UgULdeq7KhWZlu8+fd57ufEPWA9Z8e3quZzG/GCsCWZTUs=
Received: from CY8PR12CA0002.namprd12.prod.outlook.com (2603:10b6:930:4e::26)
 by CH2PR12MB4040.namprd12.prod.outlook.com (2603:10b6:610:ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:59:21 +0000
Received: from CY4PEPF0000C96C.namprd02.prod.outlook.com
 (2603:10b6:930:4e:cafe::ab) by CY8PR12CA0002.outlook.office365.com
 (2603:10b6:930:4e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:59:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96C.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 19:59:21 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:59:19 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Subject: [PATCH RFC v7 41/64] KVM: X86: Keep the NPT and RMP page level in sync
Date:   Wed, 14 Dec 2022 13:40:33 -0600
Message-ID: <20221214194056.161492-42-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96C:EE_|CH2PR12MB4040:EE_
X-MS-Office365-Filtering-Correlation-Id: 351b3bf2-4a7b-4d72-75ca-08dade0db110
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hXjW5yhjSp2ViycKw3iv682ex/wd+aEGbQPF7HXHe2guvTW835pbYqEK6KeviVTS9pmlzWCGBgDg3dxxYfxmzOb7bK7f48dDvK+jXzWIuZSFTvvGuS8b6UyPhAXv2ZUtMIrwBpoyFz5iCYZyd97dZddiGocdT2ryKAtomJMVmWI87weu255k+TswsUfINfJpt6L0pwWYzbIAOVO5LnZLXJRsrDebtt6pxVBUCkVDkIfuHOXbavFm268R2W6BW53cCu+oaeG8xCkkTERMlaPXW3hAzNVsogCDDYktGv1XbRC904zWG/wrgNfH4M3X+644vshBaItMVpQXqt91DKRrhEQE/iut56Snz4WbRBV+kNILWLp63OjmjF3oQKLFRbvCQAgDTAhYmx+vgnsojiOLBGIhvsKXcZKM31at2Fgq7WxRL9IMdbNoH/bQ5cuKi4G696VR2TJu/Vpbcoy9qlbcvh7eG8KBTpWYBm9kbUHej90dvM63wk8O3dQkBg9ne/UqM53zwCZEuYKJje5u/9ALXoBqgCuuR/6GxQaTR4onGa5/+1yUreU0mp3CzSfI95417iA8BTxDdxwzyByVlKPRrTqPxk05XCz8tWSYNUAb0RQP42Vv8jCcmIA2JrHTpwOV12e/SYPspD6mPSdjY0XnJ2L434WsNzxgMS6dTEszLs6YiIotcwX0ihcWITphbyuERCt5ovwC9KO+fhZmGUgsMnW+f9O9jw81TdyzMdUR/h0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(346002)(451199015)(36840700001)(40470700004)(46966006)(2906002)(82740400003)(44832011)(356005)(40480700001)(8936002)(36756003)(36860700001)(26005)(6666004)(70586007)(82310400005)(316002)(4326008)(86362001)(7416002)(7406005)(5660300002)(81166007)(426003)(70206006)(54906003)(6916009)(8676002)(478600001)(41300700001)(16526019)(186003)(40460700003)(83380400001)(47076005)(2616005)(336012)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:59:21.1683
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 351b3bf2-4a7b-4d72-75ca-08dade0db110
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4040
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

When running an SEV-SNP VM, the sPA used to index the RMP entry is
obtained through the NPT translation (gva->gpa->spa). The NPT page
level is checked against the page level programmed in the RMP entry.
If the page level does not match, then it will cause a nested page
fault with the RMP bit set to indicate the RMP violation.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
Signed-off-by: Ashish Kalra <Ashish.Kalra@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 +
 arch/x86/kvm/mmu/mmu.c             | 12 +++++-
 arch/x86/kvm/svm/sev.c             | 66 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  2 +
 arch/x86/kvm/svm/svm.h             |  1 +
 6 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e0015926cdf4..61e31b622fce 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -136,6 +136,7 @@ KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
 KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
 KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
 KVM_X86_OP_OPTIONAL(invalidate_restricted_mem)
+KVM_X86_OP_OPTIONAL(rmp_page_level_adjust)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e2529415f28b..b126c6ac7ce4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1724,6 +1724,8 @@ struct kvm_x86_ops {
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
 
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
+
+	void (*rmp_page_level_adjust)(struct kvm *kvm, gfn_t gfn, int *level);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2713632e5061..25db83021500 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3053,6 +3053,11 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 
 out:
 	local_irq_restore(flags);
+
+	/* Adjust the page level based on the SEV-SNP RMP page level. */
+	if (kvm_x86_ops.rmp_page_level_adjust)
+		static_call(kvm_x86_rmp_page_level_adjust)(kvm, gfn, &level);
+
 	return level;
 }
 
@@ -3070,8 +3075,13 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			break;
 	}
 
-	if (is_private)
+	pr_debug("%s: gfn: %llx max_level: %d max_huge_page_level: %d\n",
+		 __func__, gfn, max_level, max_huge_page_level);
+	if (kvm_slot_can_be_private(slot) && is_private) {
+		if (kvm_x86_ops.rmp_page_level_adjust)
+			static_call(kvm_x86_rmp_page_level_adjust)(kvm, gfn, &max_level);
 		return max_level;
+	}
 
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6f901545bed9..443c5c8aaaf3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3710,6 +3710,72 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 	return p;
 }
 
+static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
+{
+	int level;
+
+	while (end > start) {
+		if (snp_lookup_rmpentry(start, &level) != 0)
+			return false;
+		start++;
+	}
+
+	return true;
+}
+
+void sev_rmp_page_level_adjust(struct kvm *kvm, gfn_t gfn, int *level)
+{
+	struct kvm_memory_slot *slot;
+	int ret, order, assigned;
+	int rmp_level = 1;
+	kvm_pfn_t pfn;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!kvm_slot_can_be_private(slot))
+		return;
+
+	ret = kvm_restricted_mem_get_pfn(slot, gfn, &pfn, &order);
+	if (ret) {
+		pr_warn_ratelimited("Failed to adjust RMP page level, unable to obtain private PFN, rc: %d\n",
+				    ret);
+		*level = PG_LEVEL_4K;
+		return;
+	}
+
+	/* If there's an error retrieving RMP entry, stick with 4K mappings */
+	assigned = snp_lookup_rmpentry(pfn, &rmp_level);
+	if (unlikely(assigned < 0))
+		goto out_adjust;
+
+	if (!assigned) {
+		kvm_pfn_t huge_pfn;
+
+		/*
+		 * If all the pages are shared then no need to keep the RMP
+		 * and NPT in sync.
+		 */
+		huge_pfn = pfn & ~(PTRS_PER_PMD - 1);
+		if (is_pfn_range_shared(huge_pfn, huge_pfn + PTRS_PER_PMD))
+			goto out;
+	}
+
+	/*
+	 * The hardware installs 2MB TLB entries to access to 1GB pages,
+	 * therefore allow NPT to use 1GB pages when pfn was added as 2MB
+	 * in the RMP table.
+	 */
+	if (rmp_level == PG_LEVEL_2M && (*level == PG_LEVEL_1G))
+		goto out;
+
+out_adjust:
+	/* Adjust the level to keep the NPT and RMP in sync */
+	*level = min_t(size_t, *level, rmp_level);
+out:
+	put_page(pfn_to_page(pfn));
+	pr_debug("%s: GFN: 0x%llx, level: %d, rmp_level: %d, ret: %d\n",
+		 __func__, gfn, *level, rmp_level, ret);
+}
+
 int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault)
 {
 	gfn_t gfn = gpa_to_gfn(gpa);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 013f811c733c..2dfa150bcb09 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4843,6 +4843,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 
 	.fault_is_private = sev_fault_is_private,
+
+	.rmp_page_level_adjust = sev_rmp_page_level_adjust,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 17200c1ad20e..ae733188cf87 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -698,6 +698,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+void sev_rmp_page_level_adjust(struct kvm *kvm, gfn_t gfn, int *level);
 
 int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
 
-- 
2.25.1

