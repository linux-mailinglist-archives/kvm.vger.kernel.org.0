Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F4372B69B
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbjFLEiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbjFLEhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:37:43 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2068.outbound.protection.outlook.com [40.107.102.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F5F1BF6;
        Sun, 11 Jun 2023 21:37:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AnPXLP0mY1IeMJpSHgR3nv6D5WhJcPcVvrpavYsQ9F7g6y1NWdSbJbP5B8PH5BBqMlvJhWIB/+yZYhnyJUle5owBzSc/LK5UqoP5QBE7OpTeGJlXAZbXlslFpciGETcLTh91gdiL9WGU/PO1FYSl3HI6WNun0YPSeSnRzwHcmS/DNCagHi0qP7l+YB7+x0vCRwa3ikiwmf55Qpt8BT5G0W/82yJlahz15j4Xk5WFvPzOCLCamkh10bcT9M1unVdVyN6M/Q4y1XxmNSNXXl0dRrC0X7e4907+BgLDoipkjl2zGOU+l8DbycrOACs2RWIdccg7swdbR7jWgXwXNQgwJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HAG99mlA6jc200AafFpw4ErvSud5hXObZsDWDpLaHt8=;
 b=i3blII3YZx3zWIEPgNfJdlH9FuFxY7O2hmnK/6palLgW9uS8Wedo9WO8D421MhX2uyO7CXxCndskqn3rMr8JAycHvQCrTnHpNMJKipjiYHE08ntcP97sTd5wxqQg8TxWFT5spwSObtq1bJn4Tb656X2Ei0TmdZ+rfN4BPjCsEmM8e81c8xR0xStNzo+cjfe4dUqH7d6/ELi34x0lApqhfW0rkQ6GAMhJZRTo57OWPn1v78ifsr/nXt71Eqn12mDH0Ml9vbVTGtGF6TJxWA2DQA5AS4rM70u11PyXLr4RQ1tV57Qw7IZh51JNXt1miUiLwq/kGKjTl9uv2lcVDL6sJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAG99mlA6jc200AafFpw4ErvSud5hXObZsDWDpLaHt8=;
 b=WQNV7Hua977WTx8KoyO5Q2uQCtsNqbn4NYF8Ms32YN/G4Mw9MADZwtIo2mJQQxqJDhVDCv+MGWVJfpX1KM2IefFQXPx5JPpOwK5axvcENWdvXBtXRNd79KHEfu9GjrXUpHebQ6CdUU085RO6jidmOkbhjwZ6Z+j55SKUH7QaR3Q=
Received: from DM6PR04CA0005.namprd04.prod.outlook.com (2603:10b6:5:334::10)
 by SJ0PR12MB5674.namprd12.prod.outlook.com (2603:10b6:a03:42c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 04:37:04 +0000
Received: from DM6NAM11FT083.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::41) by DM6PR04CA0005.outlook.office365.com
 (2603:10b6:5:334::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:37:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT083.mail.protection.outlook.com (10.13.173.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:37:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:37:03 -0500
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
Subject: [PATCH RFC v9 26/51] KVM: SVM: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
Date:   Sun, 11 Jun 2023 23:25:34 -0500
Message-ID: <20230612042559.375660-27-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT083:EE_|SJ0PR12MB5674:EE_
X-MS-Office365-Filtering-Correlation-Id: 923afc12-2499-46bf-bd5a-08db6afeabd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5leXYoIZh7AnkZJ9YUvuvDQlcQ73AB41RhQg7fgqFaY/ZFgVZWq3/SWB7aWWydQx5md3WHFh6rFR1bYg7RB06xQinD7mrqnD9mHIHp+RZ2b2LYwZzz8Y2V6R0MWcLmO20210WMF9xQ4hafqmlOlTvhsDk1/hyb8DF1w7Gpo4b3vPY37c5A8zy5xxYmrRm7YA5eLFGeNdzCfykO104SYdvIsD12/n9+C+Sq9UdiZCjB35+yqiLDZYLYfPEPMtImd03i8b8HVoimA9KBtHvFu4dqcaW7Tde6cLswqjHxSNhtD9ezdklPoltv8ilJMoJIxiTCy5TJqNySfnP/KVsFifXoTnTbd3DpLJIhR2m06nibFQTSe+vFqd3ZlD3PgTcWCPJbW4zPS5iRSpaUA8mOBClZcVOXZDZj58SoZKvriWcrpe83ndfoB5avOXvGmWRwSeB5jtOBP9/6MEx5JANbTOUIlTPiG+c3CjP8VrHF0LzdtPBUBzZjXEgBLzgSVVGPodSilHKrvQ0qIXZJCkNKiTjO7Canjt/MVSaQJFOs7n94Z4Ysm/jUh6LS/0F7ITecfK7zmgaW261cfZJnLZ2fe71GUlSTSrYd0QwPQm6eJ+hzllj7nIRXLY/yhZKzcwkSFzRpLLSfAMofC8ZpV+q3RfKMkiP6gjmoljsQU3qCFC1GyiCZMVlQeYeVaTbxrpC80Au4XJp2RCBC1/ap84OJJFX7bDqsB4CSipLqTIBPzIcBVOKL2DZ4oHKiSlajNH57ECidQ4c/QpbgIMu+5JlgV3VQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(1076003)(26005)(16526019)(40480700001)(186003)(41300700001)(426003)(5660300002)(82310400005)(47076005)(36756003)(36860700001)(7406005)(7416002)(44832011)(70586007)(4326008)(70206006)(8936002)(6666004)(83380400001)(336012)(478600001)(8676002)(2616005)(54906003)(2906002)(86362001)(6916009)(356005)(316002)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:37:03.9399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 923afc12-2499-46bf-bd5a-08db6afeabd7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT083.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5674
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
index 48f043de2ec0..28456b497198 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -135,6 +135,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
+KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c26f76641121..8d2bb3ff66a2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1743,6 +1743,7 @@ struct kvm_x86_ops {
 	int (*gmem_prepare)(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
 	void (*gmem_invalidate)(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end);
+	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e542cf285b51..94311938651a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2769,7 +2769,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
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
index 96936ddf1b3c..fb981c8b82c4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1185,7 +1185,7 @@ int svm_allocate_nested(struct vcpu_svm *svm)
 	if (svm->nested.initialized)
 		return 0;
 
-	vmcb02_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb02_page = snp_safe_alloc_page(&svm->vcpu);
 	if (!vmcb02_page)
 		return -ENOMEM;
 	svm->nested.vmcb02.ptr = page_address(vmcb02_page);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2bceb0060880..69b57e8f0a7f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3104,3 +3104,36 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
index eb308c9994f9..065167b42f90 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -668,7 +668,7 @@ static int svm_cpu_init(int cpu)
 	int ret = -ENOMEM;
 
 	memset(sd, 0, sizeof(struct svm_cpu_data));
-	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	sd->save_area = snp_safe_alloc_page(NULL);
 	if (!sd->save_area)
 		return ret;
 
@@ -1381,7 +1381,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb01_page = snp_safe_alloc_page(vcpu);
 	if (!vmcb01_page)
 		goto out;
 
@@ -1390,7 +1390,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 		 * SEV-ES guests require a separate VMSA page used to contain
 		 * the encrypted register state of the guest.
 		 */
-		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		vmsa_page = snp_safe_alloc_page(vcpu);
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
 
@@ -4770,6 +4770,16 @@ static int svm_vm_init(struct kvm *kvm)
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
 
@@ -4900,6 +4910,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
+	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1ab117daebd9..e45b54e95495 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -741,6 +741,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
-- 
2.25.1

