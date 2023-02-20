Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABCD69D321
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbjBTSs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbjBTSsp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:48:45 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20611.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::611])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7621E1E0;
        Mon, 20 Feb 2023 10:48:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMX2wOGkJlySpYru0yrtc8ipW4M9U7j+pjwE6eN/rBBf7XxyU7S73TZPZmNjrsxMDhrfiembiR6ENAzdQXh7OdTxR5HyQ4f72hcN7k7J84EJl/xNLW3sm5og8wN+DRJGXWjC0wp2CBtbswJ2AO650a+6KivuwdRm+Yh627mfwpIIYjunykMD0ixftOyGOYEqQOVl9n7AZmWKcDmo17Z7SpgI5fDqJheN8t5DgO4TiNpLcaWmyXfF0WWbSs5jeoGeeJPdqktj0WB1PD/cNeOc0rv0v+e7GCW2l9Vin2h4MAPwmoM1XQIv1VaAiNBk2Asn04MaBRa6K8BvzaJsfwcoww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rrQnaVQh2mcS503DV65lMv6uDTUoE4QTksfruqEgVic=;
 b=PCoRF+bGEfwx+c9JYKmCWUZOZKsN3Nx1nn479TbMXSYoT7E/J0tlE2UNqlxai+u7CXYYp0AoQE81yhKNZlk+p33nhZQQXRqTCIhjfxJURPVixt/G7bVA//KIKNSNzhDP09f7CHgPmG3l6F+dwucaUgYk10rlQzEXaL27xBW7UvUzYhQ1HRdfYEcPvbXm2zV107Nu6/B/aY54WxCW8LsaXb7RHrqysW7SiOZV6MlJkmavVSDukrQpj3/tjXBLASkRWNys6m98UrKsFqy8wbdqxvMk1MGocfCjyhM+lTbn1AXno3T4f/Ci97IyJloYklFZT0s2ZWkbRyf31vVVga+2pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrQnaVQh2mcS503DV65lMv6uDTUoE4QTksfruqEgVic=;
 b=o8OBNomizSWbxJ9cYw29Pe3QA2JSH1JVHiLDYBPK1XGHnsAbPHglnKY2+jTwJbWc835BIpYqSSJ3TAffDjwH7QkUs5g6+/uR4pt3EYXIugwpkxZGXzrFwg1XQLisPP5vBLOKw+Ecj/knJsD1b3Axw4r31cN/Q4pU4RPClVLaOII=
Received: from CY5PR15CA0044.namprd15.prod.outlook.com (2603:10b6:930:1b::27)
 by MW3PR12MB4361.namprd12.prod.outlook.com (2603:10b6:303:5a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:47:44 +0000
Received: from CY4PEPF0000C966.namprd02.prod.outlook.com
 (2603:10b6:930:1b:cafe::fc) by CY5PR15CA0044.outlook.office365.com
 (2603:10b6:930:1b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19 via Frontend
 Transport; Mon, 20 Feb 2023 18:47:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C966.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:47:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:47:43 -0600
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
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: [PATCH RFC v8 01/56] KVM: x86: Add 'fault_is_private' x86 op
Date:   Mon, 20 Feb 2023 12:37:52 -0600
Message-ID: <20230220183847.59159-2-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C966:EE_|MW3PR12MB4361:EE_
X-MS-Office365-Filtering-Correlation-Id: bb36044f-08b9-4aa1-a24d-08db1372f426
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYMAuGPQWb5w8UiI1X/BvhHTugnqZR7o/1jUDsOuXiX2wANlUfgr/UgE9wpIh4TJR1hewWn9bZo39BmfP3BAZVmBUmIaoRguyx+rQyda6D2xGzdFcPLvCq7Q6C7OTk8ZCbw0ZsdvjinM+R4SzRHfAXjsfesv1q++w7S5BSa6IrsRxMn3jngvH78xUWX4VU4/0ju+GpAEjhDPchN+uBpOU8rSqfborH9d3z0zSugLZatBns8V6T0JSmWCDehM/9cTF90EH831AbFz26OZOhBXV13ZTacIfS5kQNB7f9NK0i94Y86BEtQT5UNsXyS9dSJ8N21tmAYWzUTMjpzYXwddnDIGixi8KUA2AwlDBTzdzSEb6Nz95wOpg7GvDAiW8G5phUb7kmS85NMYMKaUdjpQMRPjvaftqrKJLop2VwuQtmmxpHjNAdoKLHPS0U+jVWoMRQ43Z5JWFop6Z5v8U8lJzXMjRkzYiNBKIVFZ8EghY79NzRWv4XH2jWdTBZN1f1YQneojfq6pi8B7iYU4zS7AgdgyQgshPlNZ9m9Uj7fx47lyuUJklkdeHjw2rjgwHw/BqIvPb/9PxIEHY4dmNTNw+y27EDpLhx16PsEmviSrk4EE9oGRyMmH8yEMHujnFbaBZmx+urJmasLkavCuT4CNW4S8cSdiU8Ee4XqeROmpLF7/6MTK9qB/6bKwpdmkm1FNDzEvLoUbx9Ua9ZiklQtRUrfxOjlc29Q4xP2W18aiSYg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(5660300002)(8936002)(426003)(47076005)(36860700001)(83380400001)(40480700001)(40460700003)(86362001)(82740400003)(186003)(356005)(81166007)(336012)(316002)(82310400005)(54906003)(478600001)(4326008)(8676002)(41300700001)(70586007)(6916009)(2616005)(16526019)(1076003)(36756003)(6666004)(26005)(70206006)(2906002)(7416002)(7406005)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:47:44.5335
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb36044f-08b9-4aa1-a24d-08db1372f426
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C966.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4361
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This callback is used by the KVM MMU to check whether a #NPF was for a
private GPA or not.

In some cases the full 64-bit error code for the #NPF will be needed to
make this determination, so also update kvm_mmu_do_page_fault() to
accept the full 64-bit value so it can be plumbed through to the
callback.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/mmu/mmu.c             |  3 +--
 arch/x86/kvm/mmu/mmu_internal.h    | 37 +++++++++++++++++++++++++++---
 4 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8dc345cc6318..72183da010b8 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -131,6 +131,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e552374f2357..f856d689dda0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1643,6 +1643,7 @@ struct kvm_x86_ops {
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
+	bool (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eda615f3951c..fb3f34b7391c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5724,8 +5724,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-					  lower_32_bits(error_code), false);
+		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
 	}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e642d431df4b..557a001210df 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -231,6 +231,37 @@ struct kvm_page_fault {
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
+static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 err)
+{
+	struct kvm_memory_slot *slot;
+	bool private_fault = false;
+	gfn_t gfn = gpa_to_gfn(gpa);
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot) {
+		pr_debug("%s: no slot, GFN: 0x%llx\n", __func__, gfn);
+		goto out;
+	}
+
+	if (!kvm_slot_can_be_private(slot)) {
+		pr_debug("%s: slot is not private, GFN: 0x%llx\n", __func__, gfn);
+		goto out;
+	}
+
+	if (static_call(kvm_x86_fault_is_private)(kvm, gpa, err, &private_fault))
+		goto out;
+
+	/*
+	 * Handling below is for UPM self-tests and guests that treat userspace
+	 * as the authority on whether a fault should be private or not.
+	 */
+	private_fault = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
+
+out:
+	pr_debug("%s: GFN: 0x%llx, private: %d\n", __func__, gfn, private_fault);
+	return private_fault;
+}
+
 /*
  * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_page_fault(),
  * and of course kvm_mmu_do_page_fault().
@@ -262,11 +293,11 @@ enum {
 };
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefetch)
+					u64 err, bool prefetch)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
-		.error_code = err,
+		.error_code = lower_32_bits(err),
 		.exec = err & PFERR_FETCH_MASK,
 		.write = err & PFERR_WRITE_MASK,
 		.present = err & PFERR_PRESENT_MASK,
@@ -280,7 +311,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
-		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
+		.is_private = kvm_mmu_fault_is_private(vcpu->kvm, cr2_or_gpa, err),
 	};
 	int r;
 
-- 
2.25.1

