Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F12064D091
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiLNUCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiLNT7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:59:52 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0832BB14;
        Wed, 14 Dec 2022 11:56:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIzMGwPzYK+wxJPzf2X7RTAgMwI9xZORPNpWKR/eYJBgCXcAYB3U9lFXe9oVtJQJ+mtzG35v/VqlFo4YpQ7RjHDl/jqAOwXdPpw6Sc3hsIQ+8BTJ1V8iLF8WiOJwjESBFxtCE0JlFn8MUqtSlcVn3/uJZVi7aStLvIzRkmDRgp/QJMMy+zC7u3p72VOJd41s/rfKOrzfysIdm3OOSeJzPb04YQSJygvKyGVYUY3aQD4YQbbEiMufNf7MRthcSo9mOlNsvRBXKRa8XABd4KSaMnXrrX3xdscjOZy0qk9haOA6zKVCeeBGCcw0ik3QJSCvZJaMJAdScRAWmLJqWf1bDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeifTBbDa1KVpZpgd13JQktLoRSv+C6/qJfNPJKBMxw=;
 b=inxXymeqFVphvtEvsNLfFCFe2KWfkWWcpVJN+HBbjoghjGYvG1TWn/gt6P8rTll2TA3978/WrM/hq5qnVJdo1Rj7NKagRkh4i52EFTgib6SYMha9/8Rk81CThkDD78OcXDsJuO+z7J++XvpBPnxUlj71vUTz597358K50xetZHM7yhO0EcJWMDossXjITtuh6iF0u1Ll825YeB2adD+NAnWha678AAz/zHFVecIgOu3oP+qbuFIkrWqr7CH61wIwo/YFzke+/Cw9Ra1MBed+lIX2PDorQ5c5gzLuCA3m9GFR12Y91sfSZDkT1uRVbwDO0ExzPprSj+0oW1IgKqTxOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LeifTBbDa1KVpZpgd13JQktLoRSv+C6/qJfNPJKBMxw=;
 b=ro9+8Fj8vFrJ/s3xkwXKDhyHniY1TX5VRQJydn+mDv6GwaKefeesA1ySlBFcNZepYGd6jZ0q5wrwlaTYfjYvPyQjiv6WclUPpZ7D2G9/UA/5n6txwrQIANdxWH1tNNjl9cEz0XrzrShsTdozugq7uxmlb9wBEhybzzxmMJ7p87g=
Received: from MW2PR16CA0057.namprd16.prod.outlook.com (2603:10b6:907:1::34)
 by DM4PR12MB5200.namprd12.prod.outlook.com (2603:10b6:5:397::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:56:54 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::94) by MW2PR16CA0057.outlook.office365.com
 (2603:10b6:907:1::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:56:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 19:56:54 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:56:52 -0600
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
Subject: [PATCH RFC v7 35/64] KVM: SVM: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
Date:   Wed, 14 Dec 2022 13:40:27 -0600
Message-ID: <20221214194056.161492-36-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT057:EE_|DM4PR12MB5200:EE_
X-MS-Office365-Filtering-Correlation-Id: 41248a71-0f29-461a-1390-08dade0d596b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bcbt0EJUz8JZjJNyTejuvLrAHv8AQ5iilq0ampzsGH1kEXhJAzXncxnAYiNlutINfZUscuw3VX+JncLKqfFETNL4RFZMLCV/MpdQpMXSV6himu30ITWCJf1AdrT/hnwbdMU6EihyCb37MFWS4kFEvT7Mct4tf4fc+xVks6hdOu3p4Vz07lY3R1DAvJSxA7acPUX91h8UTQU+x9vZYG6wXkLRvNvrBKwWA+5ETGYbOPdG2vgyZ1J221UxICZrFMDUchD8eYnEZ22HaIMCbDZhz3pTr3Ly9rVaNfV2dT57Y5846PL9C4g4m0/va0cYzk9hdw9gNJzM3zXCWweMqZJtxpLT+rbcP48fL4YjXFNstxBduGduAjp+e7+yU5QUMRymhMj3BsPMw3GYtJN5y11JVqIIQqtBvFySwOeJnSEcHTlpwc2+ScrXldwuerUDWEis3TX8/E8P0Jm3HcNnVTKO30pDTT+rAozc838NZSbxw+xBlWathsXMRkDMXd2n0uQR4ztaFNhe48DqIV6ijZmIB4kjkaROtJxgIS5vR9oi/gWt/NLq231dByyCEiHp9qB5tpqysvgTs/uSNtb1pQHuQMvPhGdLcvv/UHbwyq+XNeT6u5y7VL9AYugmd8ocXKWrDTF8v6tCJYoQ+vqi4rghttUomYL6fxCgCmU7jla2FUBWEISodt0tp3WlD7C1U7hCgl0n6DWsSj58X2QwUfMCdaYi4zY3HzbcvWhX+l6DOv8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(36756003)(40480700001)(6666004)(8936002)(478600001)(82310400005)(86362001)(82740400003)(356005)(81166007)(36860700001)(40460700003)(41300700001)(316002)(7416002)(1076003)(336012)(7406005)(2616005)(5660300002)(16526019)(44832011)(186003)(54906003)(2906002)(4326008)(6916009)(70206006)(8676002)(26005)(70586007)(426003)(83380400001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:56:54.1071
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41248a71-0f29-461a-1390-08dade0d596b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5200
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
index c71df44b0f02..e0015926cdf4 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -131,6 +131,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
 KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
 KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9ef8d73455d9..e2529415f28b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1722,6 +1722,8 @@ struct kvm_x86_ops {
 	 * Returns vCPU specific APICv inhibit reasons
 	 */
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
+
+	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1bb63746e991..8500d1d54664 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2581,7 +2581,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
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
index 82ff96b4f04a..0e93b536dc34 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3234,6 +3234,39 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	}
 }
 
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
+
 int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault)
 {
 	gfn_t gfn = gpa_to_gfn(gpa);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fc7885869f7e..013f811c733c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1360,7 +1360,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb01_page = snp_safe_alloc_page(vcpu);
 	if (!vmcb01_page)
 		goto out;
 
@@ -1369,7 +1369,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 		 * SEV-ES guests require a separate VMSA page used to contain
 		 * the encrypted register state of the guest.
 		 */
-		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		vmsa_page = snp_safe_alloc_page(vcpu);
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
 
@@ -4694,6 +4694,16 @@ static int svm_vm_init(struct kvm *kvm)
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
 static int svm_private_mem_enabled(struct kvm *kvm)
 {
 	if (sev_guest(kvm))
@@ -4830,6 +4840,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
+	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 
 	.fault_is_private = sev_fault_is_private,
 };
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1f3098dff3d5..ea9844546e8a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -684,6 +684,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 
 int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
 
-- 
2.25.1

