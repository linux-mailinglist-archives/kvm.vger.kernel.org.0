Return-Path: <kvm+bounces-5358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 509ED820751
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:29:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7512A1C21406
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C1814F68;
	Sat, 30 Dec 2023 16:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="APXw0Lyi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21415156C8;
	Sat, 30 Dec 2023 16:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fboXQrRxsoXwY876TIY7pP33hAyPQqCD+cy14quRMka9Ci5o8JElhDTSJ8RfhD8imGSj7/cU/ScvCVNscxqfnO201oWmAvkHbRFg05I//E+jxwS3+v4RCse6PKojgo8jOLAr3wLtnb1tvw1jd06PvbOG0QJ/I+NfoWxcemgz+cBkGsJOqeXm5OyOhC9WHFZa2c0uN0VNH6O7sWbiPv0dc8RZbuDujXEJYq+Z10aH9PLmYGTCvhzdeMURNLwcidjWUfT4/Wupm1XJvANhKsR4fJ0y0oWQ2hc/i7Cx8M+0muJkdqiFhM2GBnfqKRaAziyyx0lG0IMU/NeiyweZhTdsSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wumlc4LrJ8MbZRcfY0TTykTD6wM9aYXAlR6rOhZ4Vh4=;
 b=f92jyh8mocyvqRJzbH0/eSsPcyhlYLyY0In/K7UgizOWle0wOuoPue6mUH1BvdyvES6ZSlqiiLFvdxVlu9AM64PbaWx3rFh7DAxN8f2G6fsYAr/5/ATO43VHQ6NxQFcwiG1V1xJ/xwnZ83k3HQDe3pYNX4az27jcxi2i1tSCMOo2kJL4205AoSl/wUAYqzKqr0187ChBa9AEeBFFZzaY/TFbMR4zJwp34ToEk3tI9mMzVF6U+5C4l+rTxJrAv7wkTneF9M1Zu7JNCSsWR4hWzbkhnpRNC9oXYTlwIOHqNxGnNpLk+fzOiBOOAnvlXkGehsy+9IyzPWBy/sxaf+I8/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wumlc4LrJ8MbZRcfY0TTykTD6wM9aYXAlR6rOhZ4Vh4=;
 b=APXw0LyiGKOSkWSfQ21+qSy5y0v6iK7pmRM1z9mthBc9+wG/DBHrHhgXnuZ1AKOjD13bS8xI9pyMEgz1Qwip2mR/M2N2M2wIJ1OK9onM9fwcDIP3xGs60kkp38UfA9CV7rMsgDaTQO2pn+tTddAmyOunIgFtXym2S8bEf0ES6rY=
Received: from DS7PR03CA0002.namprd03.prod.outlook.com (2603:10b6:5:3b8::7) by
 SA3PR12MB9178.namprd12.prod.outlook.com (2603:10b6:806:396::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7135.22; Sat, 30 Dec 2023 16:26:38 +0000
Received: from DS1PEPF0001709D.namprd05.prod.outlook.com
 (2603:10b6:5:3b8:cafe::93) by DS7PR03CA0002.outlook.office365.com
 (2603:10b6:5:3b8::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 16:26:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0001709D.mail.protection.outlook.com (10.167.18.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:26:37 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:26:37 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, Marc Orr <marcorr@google.com>
Subject: [PATCH v1 22/26] KVM: SEV: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
Date: Sat, 30 Dec 2023 10:19:50 -0600
Message-ID: <20231230161954.569267-23-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230161954.569267-1-michael.roth@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709D:EE_|SA3PR12MB9178:EE_
X-MS-Office365-Filtering-Correlation-Id: e9a3e7f9-7ff4-444a-bb3d-08dc095418f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RwkwCELUxpQHEdtTp7pkBn9HgaALrUxYN0tvp6WvV6B9okgIUjLjJO3q/639bZd9FMUDZZYq+oxo86I0ojZ38l0b/PYmydOlgfVymVW06EP05+m8OLUYipOizznLczWfTMkVbWG9lwq8fxv0JyL12oUdyegHKBpCr4MY2lWRDTX3NVh3EtwmVK/UbeXmrCpVhXOfkiXZo3nwJ/OtIpKJZ9WFxF/TNrdVnDg5WyeNWlUN7fy9Q79Df1u0uiwuGoovoAKxp+2amvMUDhhSrgLMNkM89/4OM5Y1Tm2bJLK27HwqKpc25rkjl7vC8ChTZbVsu2uBpnhiNv2NjKzCVk77YSziLet4FlBYAQh26Jvi62BJOvtp4erRBLVggiNmISJFwfvTOyEwsl6tbA3Nd7Ex4ecBb6nuAWzwVTZo8TTc8RA/heEZXjp58U6P4LD4H94ixqgvdu840wwr0lEgwR7GI3IpANOATFJGNAQIPzvwIDXbm/YyIyjoGi4ORYJzRYM8VqReJHTpjMuPAV09wSOkOBCWeCFhEysslm07u+bwtS6ts6EYbmvEaM/YbagAZolWrq8gXJjxLNjuEKINCiQWlHdoNvyVewvJQOQD2rQO1CVwGhqj9hGB9yKrfaZD0TmJHz4qBBSaEm2VBpwAFp8yZqwkeEiNp3JGMP57OECg+532dY2NPFE4flhudwbyXlh9C8djc7KbkW8OeC7li4WIbRmPsvBFGLHoSC8iHUrjKZoHM/BUbemfkgl+5TBGXwIjURQosgpqqXNa/kqcc7kZdw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(376002)(39860400002)(230922051799003)(64100799003)(186009)(82310400011)(451199024)(1800799012)(40470700004)(46966006)(36840700001)(40480700001)(40460700003)(336012)(2616005)(16526019)(426003)(26005)(83380400001)(1076003)(86362001)(36756003)(81166007)(82740400003)(356005)(47076005)(4326008)(44832011)(5660300002)(7416002)(7406005)(6666004)(36860700001)(54906003)(8936002)(8676002)(70586007)(70206006)(316002)(6916009)(2906002)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:26:37.9843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a3e7f9-7ff4-444a-bb3d-08dc095418f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9178

From: Brijesh Singh <brijesh.singh@amd.com>

Implement a workaround for an SNP erratum where the CPU will incorrectly
signal an RMP violation #PF if a hugepage (2MB or 1GB) collides with the
RMP entry of a VMCB, VMSA or AVIC backing page.

When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
backing pages as "in-use" via a reserved bit in the corresponding RMP
entry after a successful VMRUN. This is done for _all_ VMs, not just
SNP-Active VMs.

If the hypervisor accesses an in-use page through a writable
translation, the CPU will throw an RMP violation #PF. On early SNP
hardware, if an in-use page is 2MB-aligned and software accesses any
part of the associated 2MB region with a hugepage, the CPU will
incorrectly treat the entire 2MB region as in-use and signal a an RMP
violation #PF.

To avoid this, the recommendation is to not use a 2MB-aligned page for
the VMCB, VMSA or AVIC pages. Add a generic allocator that will ensure
that the page returned is not 2MB-aligned and is safe to be used when
SEV-SNP is enabled. Also implement similar handling for the VMCB/VMSA
pages of nested guests.

Co-developed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
Reported-by: Alper Gun <alpergun@google.com> # for nested VMSA case
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
[mdr: squash in nested guest handling from Ashish, commit msg fixups]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/lapic.c               |  5 ++++-
 arch/x86/kvm/svm/nested.c          |  2 +-
 arch/x86/kvm/svm/sev.c             | 32 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             | 17 +++++++++++++---
 arch/x86/kvm/svm/svm.h             |  1 +
 7 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 378ed944b849..ab24ce207988 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -138,6 +138,7 @@ KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
+KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7bc1daf68741..9b0f18d096ed 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1794,6 +1794,7 @@ struct kvm_x86_ops {
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
 
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
+	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3242f3da2457..1edf93ee3395 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2815,7 +2815,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
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
index dee62362a360..55b9a6d96bcf 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1181,7 +1181,7 @@ int svm_allocate_nested(struct vcpu_svm *svm)
 	if (svm->nested.initialized)
 		return 0;
 
-	vmcb02_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb02_page = snp_safe_alloc_page(&svm->vcpu);
 	if (!vmcb02_page)
 		return -ENOMEM;
 	svm->nested.vmcb02.ptr = page_address(vmcb02_page);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 58e19d023d70..2efe3ed89808 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3144,3 +3144,35 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
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
+	 * Allocate an SNP-safe page to workaround the SNP erratum where
+	 * the CPU will incorrectly signal an RMP violation #PF if a
+	 * hugepage (2MB or 1GB) collides with the RMP entry of a
+	 * 2MB-aligned VMCB, VMSA, or AVIC backing page.
+	 *
+	 * Allocate one extra page, choose a page which is not
+	 * 2MB-aligned, and free the other.
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
index 13cacaba229c..b6179696861a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -702,7 +702,7 @@ static int svm_cpu_init(int cpu)
 	int ret = -ENOMEM;
 
 	memset(sd, 0, sizeof(struct svm_cpu_data));
-	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	sd->save_area = snp_safe_alloc_page(NULL);
 	if (!sd->save_area)
 		return ret;
 
@@ -1420,7 +1420,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb01_page = snp_safe_alloc_page(vcpu);
 	if (!vmcb01_page)
 		goto out;
 
@@ -1429,7 +1429,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 		 * SEV-ES guests require a separate VMSA page used to contain
 		 * the encrypted register state of the guest.
 		 */
-		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		vmsa_page = snp_safe_alloc_page(vcpu);
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
 
@@ -4899,6 +4899,16 @@ static int svm_vm_init(struct kvm *kvm)
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
 
@@ -5030,6 +5040,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
+	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 59adff7bbf55..9ed9d72546b3 100644
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


