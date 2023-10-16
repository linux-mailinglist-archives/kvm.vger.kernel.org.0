Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D6F7CA9A2
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbjJPNfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbjJPNfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:35:38 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0030AC;
        Mon, 16 Oct 2023 06:35:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPRpTkzDvH7+cCrkt8OtXIWr8OtMEQt0Bepeo1PVhcQmM1YLbakM3CbV9R0UEpiHyyM4SPWSQ9cOKKm0IqZaht9C6lt/v79EyQxiNFvgFXFnmcPA/teOvfkkRawlsRvreK6l8vT/Qk0uo1wMyQYKrrl0demiKdd0C+PkVY50GLQls4TTT3BPzox8Er+yzLrwQHmvXC00RETPMrjX0Tiqic6aEywRcIL4HBZbxroLDOc07Qoz+DCFZ6Bzfg8AB4sTHJb5tWtCCdDWDJxO2TP3q/ORrwjCkBdVMEq3Z2DlnFC1D7N8z2XgweDoORcQyQD5DeKclAZ8EGE1DAd8t58X1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxXeAwCDwUa4LM2Qj3jEtVVTyfAMEIpIluDpcBM/B+Q=;
 b=E0A5dL5cjoqcmJos+3eQkZqKMZkynkHn8D04/zJNkr3yXIiYGhMoc/CZiAMyStlrpvU/hxAMJMQA68gTS85XfsdGqy35b5wYXxshyQ6wakJlFDSVAcl335MkR8J9Xv2FzXxFSBCdIgHk02+1RTX0lU4aMf3Yu480/PGgX5gd40o1+N9V3pq2XL6IeJ5hYXx3R/rbkbTTR3cXR9FjBx6BAK336lYp7Pg0fEJLkgnLGTrjAR4d8uRt6oldKDvzTNlSO66+9k0ZMzX81PplNyJGky/BM9nvoFpocRuWbBBd/zslZUbNE72gehyXwMZ+xSiDuA4lATMRMDZoTckF7LUAXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxXeAwCDwUa4LM2Qj3jEtVVTyfAMEIpIluDpcBM/B+Q=;
 b=OalkfUaPjBjNsGOVDGAkCUt2HPS6FkxndmlxUMdQIa8mLfCVI1aj/aEv0CMOrNoiqw4TzS9CYE0OrpQZDhyUwMgbA66oRLia6uWWVaQ71fNAKOV/QrUxu8XKs5JRCbsGmAN2FAvN+stQXKV8MLNXGyXoyGXo961KsWIS8ktzNUw=
Received: from BYAPR05CA0028.namprd05.prod.outlook.com (2603:10b6:a03:c0::41)
 by PH7PR12MB7284.namprd12.prod.outlook.com (2603:10b6:510:20b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Mon, 16 Oct
 2023 13:35:27 +0000
Received: from MWH0EPF000989E6.namprd02.prod.outlook.com
 (2603:10b6:a03:c0:cafe::2f) by BYAPR05CA0028.outlook.office365.com
 (2603:10b6:a03:c0::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.18 via Frontend
 Transport; Mon, 16 Oct 2023 13:35:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E6.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:35:27 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:35:26 -0500
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
Subject: [PATCH v10 23/50] KVM: SEV: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
Date:   Mon, 16 Oct 2023 08:27:52 -0500
Message-ID: <20231016132819.1002933-24-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E6:EE_|PH7PR12MB7284:EE_
X-MS-Office365-Filtering-Correlation-Id: bfd04760-752c-4fde-a922-08dbce4cc225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M3MuEZvhCu5ASTByvdQRKDfIxS7nv3vzlxjoxSaDj23zNVVLIcJWZxvTXg+hLWTt2+AoIsmRGWq0BtDHB2mvjHWGZwILPc/UvQBeFPeO/rmjdxuA0ekxR+/TPghPPqZhGq+sA5BXBp691OaV2H1H5BMTVVfoGhnsGB6q+ARvUMdH/LlJSjkWKECi0w6nBYeYr11QPi6t9JkWqykgWSbm3f4dfOEQmR/PP21nP6I9doMBBc8hXvf6dYUXQOxC6+DhzyJosvxqFGWFPGCrOlnM8U/Q0v2QssMkFWSBTN9omr+DddDeJUEkDSZzQXCr//898uyvKaoRLFoKhQBXyAWtCa/FN1LvR+I8wEg7/ueYYR5Z1mOl8QCCHHr19BxYQkQSpZuvTyyB0R2gIj/tct/jUzM9zFgQpTfIshlXIrNs3sWPC4BgmRUSTEin1jwkDK0C0EkBDWhLZoSs60m8/KqbsE3NhhOA0rPGtmjzKeBACV7+Xvw0bMhbzDBk5Cz0v4ut0lzJdekJM0gjqrNeEhl76TUx71XomsY1BbUUFabktBXNtBUbzVEhpFQU73gQcYC0DUbLAbZ6qTWxHRQk2iwU3d+DzSZIxJ75I+cs4XH/FkCP8cPbE04Z/+GB6Ar94tfNRCCKM2gbQZx2K922i6W2+SGkQYz8rZvL8Mi6onobXSmktOscRIcxlxF8edocb6Z9dhteQxgRTbsAGBMciFhUziQjk4DEYJy200FITgMKLTXeBOR4LC2D2h/KCAafyKQsJzJ0vAmle/EeAsiVbMD31Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(136003)(39860400002)(376002)(230922051799003)(64100799003)(1800799009)(451199024)(82310400011)(186009)(36840700001)(46966006)(40470700004)(44832011)(86362001)(41300700001)(5660300002)(36860700001)(7416002)(7406005)(47076005)(36756003)(83380400001)(8936002)(4326008)(8676002)(2906002)(70586007)(316002)(70206006)(6916009)(336012)(426003)(54906003)(1076003)(356005)(81166007)(2616005)(40480700001)(82740400003)(478600001)(26005)(40460700003)(16526019)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:35:27.1579
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd04760-752c-4fde-a922-08dbce4cc225
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7284
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

Implement a workaround for an SNP erratum where the CPU will incorrectly
signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
RMP entry of a VMCB, VMSA or AVIC backing page.

When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
backing pages as "in-use" via a reserved bit in the corresponding RMP
entry after a successful VMRUN. This is done for _all_ VMs, not just
SNP-Active VMs.

If the hypervisor accesses an in-use page through a writable
translation, the CPU will throw an RMP violation #PF. On early SNP
hardware, if an in-use page is 2mb aligned and software accesses any
part of the associated 2mb region with a hupage, the CPU will
incorrectly treat the entire 2mb region as in-use and signal a spurious
RMP violation #PF.

The recommended is to not use the hugepage for the VMCB, VMSA or
AVIC backing page for similar reasons. Add a generic allocator that will
ensure that the page returns is not hugepage (2mb or 1gb) and is safe to
be used when SEV-SNP is enabled. Also implement similar handling for the
VMCB/VMSA pages of nested guests.

Co-developed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
Reported-by: Alper Gun <alpergun@google.com> # for nested VMSA case
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
[mdr: squash in nested guest handling from Ashish]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/lapic.c               |  5 ++++-
 arch/x86/kvm/svm/nested.c          |  2 +-
 arch/x86/kvm/svm/sev.c             | 33 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             | 17 ++++++++++++---
 arch/x86/kvm/svm/svm.h             |  1 +
 7 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index f1505a5fa781..4ef2eca14287 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -136,6 +136,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
+KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fa401cb1a552..a3983271ea28 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1763,6 +1763,7 @@ struct kvm_x86_ops {
 
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
+	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index dcd60b39e794..631a554c0f48 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2810,7 +2810,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
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
index dd496c9e5f91..1f9a3f9eb985 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1194,7 +1194,7 @@ int svm_allocate_nested(struct vcpu_svm *svm)
 	if (svm->nested.initialized)
 		return 0;
 
-	vmcb02_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb02_page = snp_safe_alloc_page(&svm->vcpu);
 	if (!vmcb02_page)
 		return -ENOMEM;
 	svm->nested.vmcb02.ptr = page_address(vmcb02_page);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 088b32657f46..1cfb9232fc74 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3211,3 +3211,36 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		break;
 	}
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
+	 * Allocate an SNP safe page to workaround the SNP erratum where
+	 * the CPU will incorrectly signal an RMP violation  #PF if a
+	 * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
+	 * or AVIC backing page. The recommeded workaround is to not use the
+	 * hugepage.
+	 *
+	 * Allocate one extra page, use a page which is not 2mb aligned
+	 * and free the other.
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
index 1e7fb1ea45f7..8e4ef0cd968a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -706,7 +706,7 @@ static int svm_cpu_init(int cpu)
 	int ret = -ENOMEM;
 
 	memset(sd, 0, sizeof(struct svm_cpu_data));
-	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	sd->save_area = snp_safe_alloc_page(NULL);
 	if (!sd->save_area)
 		return ret;
 
@@ -1425,7 +1425,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb01_page = snp_safe_alloc_page(vcpu);
 	if (!vmcb01_page)
 		goto out;
 
@@ -1434,7 +1434,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 		 * SEV-ES guests require a separate VMSA page used to contain
 		 * the encrypted register state of the guest.
 		 */
-		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		vmsa_page = snp_safe_alloc_page(vcpu);
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
 
@@ -4876,6 +4876,16 @@ static int svm_vm_init(struct kvm *kvm)
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
 
@@ -5007,6 +5017,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
+	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c13070d00910..b7b8bf73cbb9 100644
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

