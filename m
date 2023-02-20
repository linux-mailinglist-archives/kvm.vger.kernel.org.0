Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB5069D358
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbjBTSxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbjBTSxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:53:33 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CC53592;
        Mon, 20 Feb 2023 10:53:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1677IsrNIci7studV3s+nL61csVqTyy9ziqqc9SRUon2IoL/Hbn7vPekWxVjZxCbUBu81/gkKNQheNULdDB48c8GN1yykARFGZCqSzih3nbQO6n+eL5SEWQ0dWTKc0BYLr9Uw4vxnqtSglWwB3GNBMO89cRk1zlbTGb1u8kztjuiMa8HF4uSHTdU09YK6PUnUAg7tcpnrqtoXL2YgARmoJktZr+2kPtnJl0LQsSnS7qtj6m3PjDbUoaTulv+3qQU/KEUhpa2Kv/XWRSROyrZzP9vuFYbRpeZSYElM86EXxmyMFX3l32fniPrerRfncyFC5CbPnNf/+6vbFDKJdOvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EiNmv50v1k6xWo6LXu4CGQp8xzQCx8kEUJHMu+8q+GY=;
 b=T30EAm2En7rbUiiYkb16Lcvv9MfE+PnchOtLvMgPYmP3jnw3JKvolZIfPsA+mw5jzRWp1MusY1mcFGDt10oKDnDieiYRPSUcazYVpp66cxOkEfTdNUXzsPzbCtDLSrQTU+IE0qJZo36NdINlaMGcI4CPYHezSt5whkiaD+Im2IWqmBsI0Eg9LWlBdOZAaWIMlMVIE81hFcTxDr4fhQ25CP14KhTDUr2jpGEF+gpouGoEOw0B79UYq6L0MREIA1tdhZp/BplYIw4Ato7QMLpJQyhs765RZyTKD6D2UM6lFzo3GlcnXtFMCXGlCZnVen4wdfdYEt+rD10fPAj/J08cbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EiNmv50v1k6xWo6LXu4CGQp8xzQCx8kEUJHMu+8q+GY=;
 b=4fRC1AjRVQ09W/vbXRBYP/LcQf6DbyYtyTW4QiU22p0h2vjDcelylI0PosrHo9+COK/z5Ba6yEmGcGS+MPeEnpOhildkEgLIQul5WgoAF/6M6vBIWqvM/Ftz6PxM2VIEeZ+8fzYkTFhUQh9/8fQZ0NYi6lBk4sIQgBnSb9kZfdY=
Received: from DM6PR04CA0007.namprd04.prod.outlook.com (2603:10b6:5:334::12)
 by MW4PR12MB7286.namprd12.prod.outlook.com (2603:10b6:303:22f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:51:56 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::23) by DM6PR04CA0007.outlook.office365.com
 (2603:10b6:5:334::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:51:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.20 via Frontend Transport; Mon, 20 Feb 2023 18:51:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:51:55 -0600
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
Subject: [PATCH RFC v8 31/56] KVM: SVM: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
Date:   Mon, 20 Feb 2023 12:38:22 -0600
Message-ID: <20230220183847.59159-32-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT061:EE_|MW4PR12MB7286:EE_
X-MS-Office365-Filtering-Correlation-Id: 79800487-d9db-43d0-644a-08db13738a3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W8lZTb0pqpbErP1JqdvrCRvUYEXBlWNkL8TQZsJJXMkI07Tw9mwwPGSGOOMS1gy8/KwJf4azFcuv1TkC1f5nnDJsKo+x1WtM+Pw0507vEd0WPtajldbukCs+3S7VZxZdq7vrXxJomOYpQWRp6cqmR/4AgONXsIyGKCUBGbOYtauohe287kFNaj7d7dMV7i0qJjAtXDu0WZNCOKgOnOMxExWVhZPfVaHVX05xStlLBXBCwRAwalWNQZgyLTQ8z5CcyWnafOOHzBf2dfnfVjcqWpNbNobqx1CxNdsth9oAq/roTxpk7mLG3Val+6zvHqsVwH0/y7Wr8o/D4dtfa+pU+Qt/v0j4reTu0Gb57MX3XX45es4iMnG1H3QWyzPvEg9tY5zmvr0t6P6A/Qtyq28VUxd08N109+mZu9hmK764vE6C1/jEIOqbwOGYh2shaxbojX/YC76N2U1UGpPBBSukA17FFB4upGrCOu2Va72x0uLtW2d34Zo6wRsMvO46bwVnrIwutgDVkPbrVzIBhVk3ntCSA5eA2HssT1O4Z2jHv0aHVEZyXjZgE+iZ529Q6BAeFu6rWiv2tGaeR/jBaozrjwHZKc2/HMynbLRiAGnlNvPZWgazYFM8HtiDI7FE2WiubX74Qu8HTTSzbYBqpizpVndmiYn9N8hc9Q9cbLJvRY/q5WQW+610RDo2bWLCJgnY+OAw3EnTguIhVExn6D/ibb7759vcPvgSpD4J7Rjnoaw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199018)(46966006)(36840700001)(40470700004)(82740400003)(81166007)(36756003)(82310400005)(356005)(36860700001)(16526019)(40460700003)(40480700001)(6666004)(26005)(186003)(1076003)(4326008)(54906003)(478600001)(2616005)(70206006)(70586007)(336012)(2906002)(6916009)(8676002)(316002)(7406005)(8936002)(83380400001)(5660300002)(7416002)(44832011)(86362001)(426003)(41300700001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:51:56.3590
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79800487-d9db-43d0-644a-08db13738a3b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7286
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
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
backing   pages as "in-use" in the RMP after a successful VMRUN.  This
is done for _all_ VMs, not just SNP-Active VMs.

If the hypervisor accesses an in-use page through a writable
translation, the CPU will throw an RMP violation #PF. On early SNP
hardware, if an in-use page is 2mb aligned and software accesses any
part of the associated 2mb region with a hupage, the CPU will
incorrectly treat the entire 2mb region as in-use and signal a spurious
RMP violation #PF.

The recommended is to not use the hugepage for the VMCB, VMSA or
AVIC backing page. Add a generic allocator that will ensure that the
page returns is not hugepage (2mb or 1gb) and is safe to be used when
SEV-SNP is enabled.

Co-developed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/lapic.c               |  5 ++++-
 arch/x86/kvm/svm/sev.c             | 33 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             | 15 ++++++++++++--
 arch/x86/kvm/svm/svm.h             |  1 +
 6 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 6a885f024a00..e116405cbb5f 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -131,6 +131,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
 KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
 KVM_X86_OP_OPTIONAL(invalidate_restricted_mem)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 37c92412035f..a9363a6f779d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1729,6 +1729,8 @@ struct kvm_x86_ops {
 	 * Returns vCPU specific APICv inhibit reasons
 	 */
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
+
+	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 80f92cbc4029..72e46d5b4201 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2740,7 +2740,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
 	vcpu->arch.apic = apic;
 
-	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	if (kvm_x86_ops.alloc_apic_backing_page)
+		apic->regs = static_call(kvm_x86_alloc_apic_backing_page)(vcpu);
+	else
+		apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!apic->regs) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
 		       vcpu->vcpu_id);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c1f0d4898ce3..9e9efb42a766 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3241,3 +3241,36 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
index 213593dbd7a1..1061aaf66f0a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1372,7 +1372,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb01_page = snp_safe_alloc_page(vcpu);
 	if (!vmcb01_page)
 		goto out;
 
@@ -1381,7 +1381,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 		 * SEV-ES guests require a separate VMSA page used to contain
 		 * the encrypted register state of the guest.
 		 */
-		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		vmsa_page = snp_safe_alloc_page(vcpu);
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
 
@@ -4696,6 +4696,16 @@ static int svm_vm_init(struct kvm *kvm)
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
 
@@ -4824,6 +4834,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
+	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c249c360fe36..5efcf036ccad 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -692,6 +692,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
-- 
2.25.1

