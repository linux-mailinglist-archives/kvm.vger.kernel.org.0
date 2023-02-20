Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E652A69D36F
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjBTS4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbjBTSzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:55:48 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20617.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::617])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02361206C;
        Mon, 20 Feb 2023 10:55:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bT0YmtVe0ahmPKj5F2BPGB+AeBwB2/Qd7XQStEuNCfEyx5tCi05qxQmZEvjhuASQwkYI48Jjlc3Tq6cvsL0sFF6u6weCogX7KSA1Lo2w3bECDpJTMrHVj2jzMWjE+McYnqbjwHK/VFo70FgBtPe1tGvrIjJPJ0NPJKMGdw10U4FR/JQtM+DCsjJvLCf765K89HgwXiUGNUODidIyQyIzP+DWyx3/Zri0PHQ+NdiK1RIh1ghmjL5v+3mT4qhGL6Xqkul+hUxdaoRTqqlcRQ3eguEBXh35BXVz3ppWD96nhe0JGVFTYkSajIrTYxK7XXdYaIw9DqgDeWJ1JOkQJLKZDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kokLMy8NhHv0IiJAtB8w/Wv0Gpgl+gURTTSI+M31Zk8=;
 b=dh/Px4JAOiHHHoo9dxGQG38OnAByH+qTXM9OUmAiErE3l0FGOm2odo79zpAoH4Ms4rSEA87uwkc+wOjfa9r3oinaGcR9kSvnw77qI1QilhQob9z/1nJlcIeW79t5l8wlNaPFs+IMFGNn3A8biBH5hFKO+4Xz7/RETXfbNmyAwGUl4H7o8qAvSN0rWyV+3628z3ow+u7a/0izl7Pf0f4Z2FyBu2NQaZxhZEprm/Hv250iji7yxtZsX2GTcJDBzZR2BQM7gLnglqQXH70DZGI4XT6SqnJaCejRs60H3y+CKlWgx0U4trUM+WsKzqyTfyKLjEj0XaLElnyMkGlcFN7z+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kokLMy8NhHv0IiJAtB8w/Wv0Gpgl+gURTTSI+M31Zk8=;
 b=ETy3Pzi0XuQwsZguKeSHOwKBY6Is7l5+tzpSsnog26BuRPadZzmfDTBYwg6ZQ8oGZy/Cgep6X2q/YEKUH2YnYFLA/XNUoZXou7EXwzhl2S7HHxnKrmzJiKh6E2sm6DYsU5tpoZ/7NtyX9qYg6BHHE5tpoFv+/Y97QAsI+IN+T3Y=
Received: from DM5PR07CA0117.namprd07.prod.outlook.com (2603:10b6:4:ae::46) by
 IA0PR12MB8748.namprd12.prod.outlook.com (2603:10b6:208:482::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 18:54:02 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::d5) by DM5PR07CA0117.outlook.office365.com
 (2603:10b6:4:ae::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:54:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.19 via Frontend Transport; Mon, 20 Feb 2023 18:54:02 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:54:01 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>,
        "Jarkko Sakkinen" <jarkko@profian.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Subject: [PATCH RFC v8 37/56] KVM: X86: Keep the NPT and RMP page level in sync
Date:   Mon, 20 Feb 2023 12:38:28 -0600
Message-ID: <20230220183847.59159-38-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT012:EE_|IA0PR12MB8748:EE_
X-MS-Office365-Filtering-Correlation-Id: 17e376b1-4bdf-44b5-9e12-08db1373d557
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8KwLgoSvn+rq0RN8eAFGfO8DJrkAUHiQkSI9pezqXNlTVPl/BgcroD7KTdadz4J7Ouj2C7bw571dIg7a4oxFx0zbJnPuGThqQvL+k5sgyduuMwJEz5rn90o0aqHT/pIOrandIOfqud5o6V1m7O1cGm/hY7Pr8EYRs2SdvueW0UGzXruiWrXAlydKI8lllAlCF6TiBQxOmBlwbd3XdoWoZ71FB64FBVIgmpiPPxIaMb+fRa5DwTjLlPu1w1kDcJSI3pYiGjfELNie4aG5cWbw/G6M1u6hw43w/7oPUQmMWUEZ0yLeUeUHNuZXndU6MQbv6JgGbgkzR7WLf8a1ZGvx7ENOWTt/Xsmm5bkG3YtSqmxY4hkv1jxOwQUl4QZ3H/+fTRedSbQYRWPVif4s2u0EpKJ2ooHwb/IzPxPlGN2rEZ8g1SPXZtDajC3/CH3Lkvj79hjRCxZ7kFf3B+y7nxpBmPxPgn9UYqGUWg1rQVNlOZIMGWaJ9qn02rAfuVbPK2eE1vn1Jzut18EUdjZAuVoINegxVqh2kIXNBYGorR5KscSYa52gwKObTqanX4bdEXWdsxueXgNJbW0s/GmSKotrRaq3ZZ8r+lzkbFKkbnJUtM6xJCnqFEq/9ZBeU60te9xy7XvjJOPp9GOI1KoRYMauHxOeIV199ytL0xcStNJJ5q4VCZCj2kK+dBG5LL9iyjoRAXp+7FNEPe1C+7YuUFwvVcfFzz+OmcfA6G/aXRu/71Q=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(82740400003)(36860700001)(5660300002)(44832011)(7416002)(7406005)(86362001)(82310400005)(2906002)(81166007)(40480700001)(356005)(336012)(36756003)(478600001)(426003)(26005)(186003)(47076005)(16526019)(70206006)(70586007)(54906003)(83380400001)(40460700003)(316002)(6666004)(6916009)(2616005)(1076003)(8676002)(41300700001)(4326008)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:54:02.3731
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e376b1-4bdf-44b5-9e12-08db1373d557
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8748
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/mmu/mmu.c             |  9 ++++++
 arch/x86/kvm/svm/sev.c             | 51 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  2 ++
 arch/x86/kvm/svm/svm.h             |  1 +
 6 files changed, 66 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e116405cbb5f..87a087ec3277 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -135,6 +135,7 @@ KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
 KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
 KVM_X86_OP_OPTIONAL(invalidate_restricted_mem)
+KVM_X86_OP_OPTIONAL(adjust_mapping_level)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a9363a6f779d..456b42cb167b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
 
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
+
+	void (*adjust_mapping_level)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *level);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 360af0c9997e..d8e5254f314d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3081,6 +3081,7 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 
 out:
 	local_irq_restore(flags);
+
 	return level;
 }
 
@@ -3141,6 +3142,14 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
 						       fault->gfn, fault->max_level,
 						       fault->is_private);
+	if (kvm_slot_can_be_private(slot)) {
+		int req_level = fault->req_level;
+
+		static_call_cond(kvm_x86_adjust_mapping_level)(vcpu->kvm, fault->gfn, fault->pfn,
+							       &req_level);
+		fault->req_level = req_level;
+	}
+
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 515e22d0dc30..e8740c35be39 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3749,3 +3749,54 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 
 	return p;
 }
+
+static bool is_gfn_range_shared(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	while (start++ < end)
+		if (kvm_mem_is_private(kvm, start))
+			return false;
+
+	return true;
+}
+
+void sev_adjust_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *level)
+{
+	int assigned;
+	int rmp_level = 1;
+	int level_orig = *level;
+
+	if (!sev_snp_guest(kvm))
+		return;
+
+	/* If there's an error retrieving RMP entry, stick with 4K mappings */
+	assigned = snp_lookup_rmpentry(pfn, &rmp_level);
+	if (unlikely(assigned < 0))
+		goto out_adjust;
+
+	if (!assigned) {
+		gfn_t huge_gfn;
+
+		/*
+		 * If all the pages are shared then no need to keep the RMP
+		 * and NPT in sync.
+		 */
+		huge_gfn = gfn & ~(PTRS_PER_PMD - 1);
+		if (is_gfn_range_shared(kvm, huge_gfn, huge_gfn + PTRS_PER_PMD))
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
+	pr_debug("%s: GFN: 0x%llx, PFN: 0x%llx, level: %d, rmp_level: %d, level_orig: %d, assigned: %d\n",
+		 __func__, gfn, pfn, *level, rmp_level, level_orig, assigned);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1061aaf66f0a..9eb750c8b04c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4835,6 +4835,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+
+	.adjust_mapping_level = sev_adjust_mapping_level,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 740969b57425..cbd4594f1cca 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -706,6 +706,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+void sev_adjust_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *level);
 
 /* vmenter.S */
 
-- 
2.25.1

