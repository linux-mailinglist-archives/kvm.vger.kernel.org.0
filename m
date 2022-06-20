Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFAE5527BF
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346593AbiFTXJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346549AbiFTXIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:08:11 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2069.outbound.protection.outlook.com [40.107.96.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6400B245AC;
        Mon, 20 Jun 2022 16:07:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AluAlBwkaLkJ3lRL0WOwevjqJAVi5LN7oB/GZnjhoHYMq3EsnnEtSNmBe3dz4EVjLzDOZEVpv4hlb66DnM8F9R5/0TBerTd+N7geCvMosDjuYtc6hNfDUq4PKgi7UzfpFDypOheRIylLoJCknN7C6ey9pjj9byOWRsGRMSj7ikhTm5dxby6qXYGlSQR7dtE1pHnzFkCrwwcxRLPbgwew10MxQGhZ9lhnIv/nBS8hYt5tlUsljp7Q/8FJuHArp+LfXeMRiNyVkVW9qSnXk69tn+mErzQEPPoetMtpcF2lTXEG8xPoN55NMKIX8iERaTh0N4lA/qTJsnUP0HgF2WhwUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eKY142V9qIHXxgky8ugE68QKS8iCilnhDJ1lA28zjiE=;
 b=BrhPDsYgDvJi0IeyBN6fPt44ZInVYGf6zxX3rhisO9ZOhm34o2IML3nVgc6VcmCRGUBMSk5UdXQuCd0W7r843hp+C3EU8Yyl7aJyc3Vcms8mssN8UxztbQP29a45vWjPBNVjdUcUMJ2Y7DRlXsZXv7uMWQ8cjLBDcAiAh3eXIQlP4Jx2wS+jfGDGBNDsRL/6VF8P0PUEOOtfVtj9b4I9qI7o6FtIQ9zm1Et2O3mc7QRF8xuG8El1RNegWK8Q0VtsnQAHB05A9rV0A0yk27tgwEFZwdy6CzLFtrkIyeiV3siOwRJe5Tj+LNiibD+ZQfgDal0jALfhvgRYHVeWrFxfAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKY142V9qIHXxgky8ugE68QKS8iCilnhDJ1lA28zjiE=;
 b=PqT/aVUmgowHND8e0Muh/Xa9q+9AM23bsa7SGvW72Y8LevIrSp308HAfHbEu1reZFVStbMFROApjYwj5nfJKqav1LfNpaY6E2Fgzlkd6N8dOKzp0Lpo9OuOEAl9p0Cv1aOB2SpAyrm2zuIao7wjFRX63RR/WC83NrdUKQIHum7Y=
Received: from BYAPR01CA0056.prod.exchangelabs.com (2603:10b6:a03:94::33) by
 BYAPR12MB4615.namprd12.prod.outlook.com (2603:10b6:a03:96::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.20; Mon, 20 Jun 2022 23:07:03 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:94:cafe::5e) by BYAPR01CA0056.outlook.office365.com
 (2603:10b6:a03:94::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19 via Frontend
 Transport; Mon, 20 Jun 2022 23:07:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:07:02 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:07:00 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 21/49] KVM: SVM: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
Date:   Mon, 20 Jun 2022 23:06:51 +0000
Message-ID: <4896f0fd85947a139dce0ad514044c76048eaed2.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0632410c-092a-47a4-f9f6-08da5311963d
X-MS-TrafficTypeDiagnostic: BYAPR12MB4615:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB4615F38A13D0CED6C61BD9008EB09@BYAPR12MB4615.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8wKhH7p8YEBjjB1KbiymPCUzZn1Je7P8U+Mmo1ZyoJ4W/JvDlrpFUV5DT5jXGEeftjpSsASS8QCnF1LQnURvYW/sTYP2jJn1XhuIxeOMe/zXlD+6SNki0g1atJK2G8buV1zDvxG8r4MoKXnzsaaOKWsWfV66Q/JWWpIz/FGY4PLmuE289rdc6wazrJH1b4AMSPNZMb4nOkLXf/nB+AmciV3GCgyA/H/wa4UV2xwtIb9mhPRPKcJ3yHsYo75Dfau4IuYPuqHK8qwuriSMsMi3LGtguDQAW1JhC2vSf9k5bHkK5Iq0yywHOcBEMyOZlBvhOgPHsBXKYMlmwPhwFtLvY7ii6eTKwsC/JXtVaSUHAwWV3zk50JJpnwDiCLVZtEX98dn7ACutAN7koSYwk679bOHu5zmjCmNmTMUheKfxGbWoHfOdGt0IGFtMypn/qd1q3fvWXesLSnXUqm70KgDPty3TPVordNyN5ixqh74JkNrZ6bJ4V8RKlOxyMgK9Jouaq5HDLi3mHgK0805sFmdCWzZXE7sqcbhbKUP5hKFMNxqfu0cn7UpTCGZMsLjF2RtZ3fnoLeP/DUoDG2kn5bBtZfhltf9bY9v+lsobjjGsWMEiJ0q2k59Q7bTwEdXquuLzR86/2G8Pu4BbeKDUnQPb5IIGe9E86K99yhS8zqI/5TVehc/3gWfWeAPs4fbmE3B5xmBRqO6cEiXlA1B2B8tkTkYOONmnyw9GUTj7Ry5zhH2MUlVo7C7vzwz2xqRZoqwvmf8YUdD7yxBbd1Ce9DEXMg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(346002)(376002)(36840700001)(40470700004)(46966006)(4326008)(7696005)(54906003)(86362001)(110136005)(26005)(356005)(82740400003)(70206006)(70586007)(2906002)(316002)(8676002)(16526019)(5660300002)(8936002)(36860700001)(478600001)(7406005)(81166007)(186003)(7416002)(83380400001)(2616005)(36756003)(40460700003)(6666004)(426003)(82310400005)(40480700001)(336012)(47076005)(41300700001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:07:02.5602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0632410c-092a-47a4-f9f6-08da5311963d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4615
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/lapic.c               |  5 ++++-
 arch/x86/kvm/svm/sev.c             | 35 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             | 16 ++++++++++++--
 arch/x86/kvm/svm/svm.h             |  1 +
 6 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index da47f60a4650..a66292dae698 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -128,6 +128,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP(alloc_apic_backing_page)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c24a72ddc93b..0205e2944067 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1512,6 +1512,8 @@ struct kvm_x86_ops {
 	 * Returns vCPU specific APICv inhibit reasons
 	 */
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
+
+	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 66b0eb0bda94..7c7fc6c4a7f9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2506,7 +2506,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
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
index b49c370d5ae9..93365996bd59 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3030,3 +3030,38 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
+	if (IS_ALIGNED(__pfn_to_phys(pfn), PMD_SIZE)) {
+		pfn++;
+		__free_page(p);
+	} else {
+		__free_page(pfn_to_page(pfn + 1));
+	}
+
+	return pfn_to_page(pfn);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index efc7623d0f90..b4bd64f94d3a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1260,7 +1260,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb01_page = snp_safe_alloc_page(vcpu);
 	if (!vmcb01_page)
 		goto out;
 
@@ -1269,7 +1269,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 		 * SEV-ES guests require a separate VMSA page used to contain
 		 * the encrypted register state of the guest.
 		 */
-		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		vmsa_page = snp_safe_alloc_page(vcpu);
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
 
@@ -4598,6 +4598,16 @@ static int svm_vm_init(struct kvm *kvm)
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
 	.name = "kvm_amd",
 
@@ -4722,6 +4732,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
+
+	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1f4a8bd09c9e..9672e25a338d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -659,6 +659,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
-- 
2.25.1

