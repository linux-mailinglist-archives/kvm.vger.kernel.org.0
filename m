Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BAC2696BD
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgINUec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:34:32 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:36897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726102AbgINUQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:16:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WI5HMdFE3kO3DlD/MfzzKd5EZe9hc2f3LT2O7vAaZlOE6hb/W5/fcI3jdiZp59xpZjZ8YB4qGMxIQcqMJlJdrUURJOb9J5zwNRr53WfHGnhkHsI/V0RKxhFh106JdoIR85TGhYWAmT09AeTJ5m8dtsaHP1ND9SJb0o5ZGev7lisH0iZdbB/IkiQpKZNESl2M2M3XgTyEbcywim4JMW/jzCQtc514mdM2SQBzENdZJAqJNL8qqHtM068F/cVkD0gByuz9LfOMH+LHeapijd2G3rEjjvAsPoMi2viJzjNlHQFQ2uWUBVgLTHpTz99k7dSXKnq8L7pBV+l4QGmg7uoByQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muMskzQ09+zMLokLB+tAsSSsCuKQWFeMBB3NVmakl/k=;
 b=Nc8UiaP6cGo8QqzEM/8G8ac0WzC2UuMV2BXsWGNA25pTVifNCBGXUFIuDFaKvfRaJ9ph4eKJTGT8nRYFma989rTcC3puSqHw4bTp/vrlI/FjKHhm3HNCeXyP0M1WCRkQpxoxkL79YGmVK7Gg6O09saEqoQocdfP4vMYWPJqCu8aCjr7rXF/YW0IrzunrrnfLdnpOREcd1iijC3KHd05mpGCGQ02dI41SjOJq3fiTzu6d69jMv0dUUn40ANgV3TvlhegvVc3pKauZzaHe2O4nWP4Bm3+KmMEZruxwg71bXmwNhQEG64AI2AXGBFo74TiNfEw4lBVUvL4h9iOkBmkDJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muMskzQ09+zMLokLB+tAsSSsCuKQWFeMBB3NVmakl/k=;
 b=o8ZEtOCRmd+ngcFTw5tlCtAXvKwXubLwVhwh8HVUjgmzr22weZEtGEddnBOVOp5NZHMcp8ATdFQPqa5H7UzPUxPg+WENHUcwnWqB/91nBa7Vgt33P8KaKs1o8h3WllEPG+3xE7MuH8HtwRDfEXdu2dkzWmtfafKUiPl0lJJCfnE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:16:39 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:16:39 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH 05/35] KVM: SVM: Add initial support for SEV-ES GHCB access to KVM
Date:   Mon, 14 Sep 2020 15:15:19 -0500
Message-Id: <9e52807342691ff0d4b116af6e147021c61a2d71.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:5:60::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR10CA0021.namprd10.prod.outlook.com (2603:10b6:5:60::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:16:38 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5ea0c62f-4666-437b-e8aa-08d858eb1687
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB116348D2985CE235D0613E7FEC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UcLMpJICbyRBrFVcsB5Wk//FUxCAPLq8pB3bS3tqzL6vZ95n9g0WVa+nOFooEhvOqEwJC5ImheAhyGJ7ujGye0iMeve+0qt0eIFZBeWOnwkce3ka5wbmGdor670mKaGXAPfnOgHP/9vfPE/DqvROLeDMl4Jw7k+lffO1kucmL60SuwUSNVKteZox8z/xCB7C8rBGFyTv07pznQThgDC2F6INyf8DgUBGXknRKHzuTVE0H6Sze/ETrdUIoG0gwnUqpa67/Bct3xtKAJsicTw7V0jvZ2pq9iUivaivoI9eSiG+/vHSjvZ1hB2xg/ufEiS6bV1Fm5+ig1pS3OmMDRiMJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fQV2Iyn4iWyWu+T47Dqdl/qLNlaGkEgIGsd/u/F1GQ6NY30ux76rqwXfiy3C4RiYonYK3SeSt/MNhgcTt9pe/P4z/DmeKFZS+TsTeXOg4+o4N2PuTZWKPc754p9i9qS4VrvHjZG7Oc9s8Ov56jv5v0uF4dYbY9lBY1fkZ5vCI2u/WOfvkE8q94WpRTokd7eZr5QE7zd1j4DEE/0Px0g83FhMrV3Vn+NIBSymL/A0IYHbIvosbFfm78PPyC4V5UArPfMUUpy32FKod1beIlWlT67Xn/fmgo32jBHl1ht2eSEdXIkd1jK0bU5rVcSDhW0Vks7scNYmKGVsU6A89+xqOlc8pXVEbNU2NptQuLhQUhmhiqAZjVhDAsnfcV1O3xcdQF4m8aZ082i4c6cLiPX11xWtuz30mZGRg0UZbSaRYIuQVB3T72zWJGWS2eJW2Qe5v/ivJJ9/R72O47FaJcdvmCnmDwx8lcUTzNm2M4zCRMbuD0bTQeW6bpUH9vPhxwYHi3ecu0cmHi4WhUBrBcjSoPV7iLV6tGnjwcIwUvkm/9ffA0JS0pQha/c52wxbS8X7Bw5RMlCwkQu3RXkrS/vX2PiA1/Eq1RePQh2AYw85aCM/bhhynDksDjEEsHr7rq0JAUuIjv4qBTF+pQYP/lLAGA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea0c62f-4666-437b-e8aa-08d858eb1687
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:16:39.3658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ud6kf3My3EISkbi00tjT89LiCPz3p9phKWeEAP4M+wkWcZUn4d7lyiblftxRpLujseKR8zCudriXpHMlxew4Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Provide initial support for accessing the GHCB when needing to access
registers for an SEV-ES guest. The support consists of:

  - Accessing the GHCB instead of the VMSA when reading and writing
    guest registers (after the VMSA has been encrypted).
  - Creating register access override functions for reading and writing
    guest registers from the common KVM support.
  - Allocating pages for the VMSA and GHCB when creating each vCPU
    - The VMSA page holds the encrypted VMSA for the vCPU
    - The GHCB page is used to hold a copy of the guest GHCB during
      VMGEXIT processing.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h  |   7 ++
 arch/x86/include/asm/msr-index.h |   1 +
 arch/x86/kvm/kvm_cache_regs.h    |  30 +++++--
 arch/x86/kvm/svm/svm.c           | 138 ++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h           |  65 ++++++++++++++-
 5 files changed, 230 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5303dbc5c9bc..c900992701d6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -788,6 +788,9 @@ struct kvm_vcpu_arch {
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
+
+	/* SEV-ES support */
+	bool vmsa_encrypted;
 };
 
 struct kvm_lpage_info {
@@ -1227,6 +1230,10 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
+
+	void (*reg_read_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
+	void (*reg_write_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg,
+				   unsigned long val);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 249a4147c4b2..16f5b20bb099 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -466,6 +466,7 @@
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
 #define MSR_AMD64_IBSOPDATA4		0xc001103d
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
+#define MSR_AMD64_VM_PAGE_FLUSH		0xc001011e
 #define MSR_AMD64_SEV_ES_GHCB		0xc0010130
 #define MSR_AMD64_SEV			0xc0010131
 #define MSR_AMD64_SEV_ENABLED_BIT	0
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index cfe83d4ae625..e87eb90999d5 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -9,15 +9,21 @@
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
 	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_PGE | X86_CR4_TSD)
 
-#define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
-static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
-{									      \
-	return vcpu->arch.regs[VCPU_REGS_##uname];			      \
-}									      \
-static __always_inline void kvm_##lname##_write(struct kvm_vcpu *vcpu,	      \
-						unsigned long val)	      \
-{									      \
-	vcpu->arch.regs[VCPU_REGS_##uname] = val;			      \
+#define BUILD_KVM_GPR_ACCESSORS(lname, uname)					\
+static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)	\
+{										\
+	if (kvm_x86_ops.reg_read_override)					\
+		kvm_x86_ops.reg_read_override(vcpu, VCPU_REGS_##uname);		\
+										\
+	return vcpu->arch.regs[VCPU_REGS_##uname];				\
+}										\
+static __always_inline void kvm_##lname##_write(struct kvm_vcpu *vcpu,		\
+						unsigned long val)		\
+{										\
+	if (kvm_x86_ops.reg_write_override)					\
+		kvm_x86_ops.reg_write_override(vcpu, VCPU_REGS_##uname, val);	\
+										\
+	vcpu->arch.regs[VCPU_REGS_##uname] = val;				\
 }
 BUILD_KVM_GPR_ACCESSORS(rax, RAX)
 BUILD_KVM_GPR_ACCESSORS(rbx, RBX)
@@ -67,6 +73,9 @@ static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
 	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
 		return 0;
 
+	if (kvm_x86_ops.reg_read_override)
+		kvm_x86_ops.reg_read_override(vcpu, reg);
+
 	if (!kvm_register_is_available(vcpu, reg))
 		kvm_x86_ops.cache_reg(vcpu, reg);
 
@@ -79,6 +88,9 @@ static inline void kvm_register_write(struct kvm_vcpu *vcpu, int reg,
 	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
 		return;
 
+	if (kvm_x86_ops.reg_write_override)
+		kvm_x86_ops.reg_write_override(vcpu, reg, val);
+
 	vcpu->arch.regs[reg] = val;
 	kvm_register_mark_dirty(vcpu, reg);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 779c167e42cc..d1f52211627a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1175,6 +1175,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	struct page *msrpm_pages;
 	struct page *hsave_page;
 	struct page *nested_msrpm_pages;
+	struct page *vmsa_page = NULL;
 	int err;
 
 	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
@@ -1197,9 +1198,19 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (!hsave_page)
 		goto free_page3;
 
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		/*
+		 * SEV-ES guests require a separate VMSA page used to contain
+		 * the encrypted register state of the guest.
+		 */
+		vmsa_page = alloc_page(GFP_KERNEL);
+		if (!vmsa_page)
+			goto free_page4;
+	}
+
 	err = avic_init_vcpu(svm);
 	if (err)
-		goto free_page4;
+		goto free_page5;
 
 	/* We initialize this flag to true to make sure that the is_running
 	 * bit would be set the first time the vcpu is loaded.
@@ -1219,6 +1230,12 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm->vmcb = page_address(page);
 	clear_page(svm->vmcb);
 	svm->vmcb_pa = __sme_set(page_to_pfn(page) << PAGE_SHIFT);
+
+	if (vmsa_page) {
+		svm->vmsa = page_address(vmsa_page);
+		clear_page(svm->vmsa);
+	}
+
 	svm->asid_generation = 0;
 	init_vmcb(svm);
 
@@ -1227,6 +1244,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	return 0;
 
+free_page5:
+	if (vmsa_page)
+		__free_page(vmsa_page);
 free_page4:
 	__free_page(hsave_page);
 free_page3:
@@ -1258,6 +1278,26 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	 */
 	svm_clear_current_vmcb(svm->vmcb);
 
+	if (sev_es_guest(vcpu->kvm)) {
+		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+
+		if (vcpu->arch.vmsa_encrypted) {
+			u64 page_to_flush;
+
+			/*
+			 * The VMSA page was used by hardware to hold guest
+			 * encrypted state, be sure to flush it before returning
+			 * it to the system. This is done using the VM Page
+			 * Flush MSR (which takes the page virtual address and
+			 * guest ASID).
+			 */
+			page_to_flush = (u64)svm->vmsa | sev->asid;
+			wrmsrl(MSR_AMD64_VM_PAGE_FLUSH, page_to_flush);
+		}
+
+		__free_page(virt_to_page(svm->vmsa));
+	}
+
 	__free_page(pfn_to_page(__sme_clr(svm->vmcb_pa) >> PAGE_SHIFT));
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
 	__free_page(virt_to_page(svm->nested.hsave));
@@ -4012,6 +4052,99 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
 }
 
+/*
+ * These return values represent the offset in quad words within the VM save
+ * area. This allows them to be accessed by casting the save area to a u64
+ * array.
+ */
+#define VMSA_REG_ENTRY(_field)	 (offsetof(struct vmcb_save_area, _field) / sizeof(u64))
+#define VMSA_REG_UNDEF		 VMSA_REG_ENTRY(valid_bitmap)
+static inline unsigned int vcpu_to_vmsa_entry(enum kvm_reg reg)
+{
+	switch (reg) {
+	case VCPU_REGS_RAX:	return VMSA_REG_ENTRY(rax);
+	case VCPU_REGS_RBX:	return VMSA_REG_ENTRY(rbx);
+	case VCPU_REGS_RCX:	return VMSA_REG_ENTRY(rcx);
+	case VCPU_REGS_RDX:	return VMSA_REG_ENTRY(rdx);
+	case VCPU_REGS_RSP:	return VMSA_REG_ENTRY(rsp);
+	case VCPU_REGS_RBP:	return VMSA_REG_ENTRY(rbp);
+	case VCPU_REGS_RSI:	return VMSA_REG_ENTRY(rsi);
+	case VCPU_REGS_RDI:	return VMSA_REG_ENTRY(rdi);
+#ifdef CONFIG_X86_64
+	case VCPU_REGS_R8:	return VMSA_REG_ENTRY(r8);
+	case VCPU_REGS_R9:	return VMSA_REG_ENTRY(r9);
+	case VCPU_REGS_R10:	return VMSA_REG_ENTRY(r10);
+	case VCPU_REGS_R11:	return VMSA_REG_ENTRY(r11);
+	case VCPU_REGS_R12:	return VMSA_REG_ENTRY(r12);
+	case VCPU_REGS_R13:	return VMSA_REG_ENTRY(r13);
+	case VCPU_REGS_R14:	return VMSA_REG_ENTRY(r14);
+	case VCPU_REGS_R15:	return VMSA_REG_ENTRY(r15);
+#endif
+	case VCPU_REGS_RIP:	return VMSA_REG_ENTRY(rip);
+	default:
+		WARN_ONCE(1, "unsupported VCPU to VMSA register conversion\n");
+		return VMSA_REG_UNDEF;
+	}
+}
+
+/* For SEV-ES guests, populate the vCPU register from the appropriate VMSA/GHCB */
+static void svm_reg_read_override(struct kvm_vcpu *vcpu, enum kvm_reg reg)
+{
+	struct vmcb_save_area *vmsa;
+	struct vcpu_svm *svm;
+	unsigned int entry;
+	unsigned long val;
+	u64 *vmsa_reg;
+
+	if (!sev_es_guest(vcpu->kvm))
+		return;
+
+	entry = vcpu_to_vmsa_entry(reg);
+	if (entry == VMSA_REG_UNDEF)
+		return;
+
+	svm = to_svm(vcpu);
+	vmsa = get_vmsa(svm);
+	vmsa_reg = (u64 *)vmsa;
+	val = (unsigned long)vmsa_reg[entry];
+
+	/* If a GHCB is mapped, check the bitmap of valid entries */
+	if (svm->ghcb) {
+		if (!test_bit(entry, (unsigned long *)vmsa->valid_bitmap))
+			val = 0;
+	}
+
+	vcpu->arch.regs[reg] = val;
+}
+
+/* For SEV-ES guests, set the vCPU register in the appropriate VMSA */
+static void svm_reg_write_override(struct kvm_vcpu *vcpu, enum kvm_reg reg,
+				   unsigned long val)
+{
+	struct vmcb_save_area *vmsa;
+	struct vcpu_svm *svm;
+	unsigned int entry;
+	u64 *vmsa_reg;
+
+	entry = vcpu_to_vmsa_entry(reg);
+	if (entry == VMSA_REG_UNDEF)
+		return;
+
+	svm = to_svm(vcpu);
+	vmsa = get_vmsa(svm);
+	vmsa_reg = (u64 *)vmsa;
+
+	/* If a GHCB is mapped, set the bit to indicate a valid entry */
+	if (svm->ghcb) {
+		unsigned int index = entry / 8;
+		unsigned int shift = entry % 8;
+
+		vmsa->valid_bitmap[index] |= BIT(shift);
+	}
+
+	vmsa_reg[entry] = val;
+}
+
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
@@ -4150,6 +4283,9 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.reg_read_override = svm_reg_read_override,
+	.reg_write_override = svm_reg_write_override,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f42ba9d158df..ff587536f571 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -159,6 +159,10 @@ struct vcpu_svm {
 	 */
 	struct list_head ir_list;
 	spinlock_t ir_list_lock;
+
+	/* SEV-ES support */
+	struct vmcb_save_area *vmsa;
+	struct ghcb *ghcb;
 };
 
 struct svm_cpu_data {
@@ -509,9 +513,34 @@ void sev_hardware_teardown(void);
 
 static inline struct vmcb_save_area *get_vmsa(struct vcpu_svm *svm)
 {
-	return &svm->vmcb->save;
+	struct vmcb_save_area *vmsa;
+
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		/*
+		 * Before LAUNCH_UPDATE_VMSA, use the actual SEV-ES save area
+		 * to construct the initial state.  Afterwards, use the mapped
+		 * GHCB in a VMGEXIT or the traditional save area as a scratch
+		 * area when outside of a VMGEXIT.
+		 */
+		if (svm->vcpu.arch.vmsa_encrypted) {
+			if (svm->ghcb)
+				vmsa = &svm->ghcb->save;
+			else
+				vmsa = &svm->vmcb->save;
+		} else {
+			vmsa = svm->vmsa;
+		}
+	} else {
+		vmsa = &svm->vmcb->save;
+	}
+
+	return vmsa;
 }
 
+#define SEV_ES_SET_VALID(_vmsa, _field)					\
+	__set_bit(GHCB_BITMAP_IDX(_field),				\
+		  (unsigned long *)(_vmsa)->valid_bitmap)
+
 #define DEFINE_VMSA_SEGMENT_ENTRY(_field, _entry, _size)		\
 	static inline _size						\
 	svm_##_field##_read_##_entry(struct vcpu_svm *svm)		\
@@ -528,6 +557,9 @@ static inline struct vmcb_save_area *get_vmsa(struct vcpu_svm *svm)
 		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
 									\
 		vmsa->_field._entry = value;				\
+		if (svm->vcpu.arch.vmsa_encrypted) {			\
+			SEV_ES_SET_VALID(vmsa, _field);			\
+		}							\
 	}								\
 
 #define DEFINE_VMSA_SEGMENT_ACCESSOR(_field)				\
@@ -551,6 +583,9 @@ static inline struct vmcb_save_area *get_vmsa(struct vcpu_svm *svm)
 		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
 									\
 		vmsa->_field = *seg;					\
+		if (svm->vcpu.arch.vmsa_encrypted) {			\
+			SEV_ES_SET_VALID(vmsa, _field);			\
+		}							\
 	}
 
 DEFINE_VMSA_SEGMENT_ACCESSOR(cs)
@@ -579,6 +614,9 @@ DEFINE_VMSA_SEGMENT_ACCESSOR(tr)
 		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
 									\
 		vmsa->_field = value;					\
+		if (svm->vcpu.arch.vmsa_encrypted) {			\
+			SEV_ES_SET_VALID(vmsa, _field);			\
+		}							\
 	}								\
 									\
 	static inline void						\
@@ -587,6 +625,9 @@ DEFINE_VMSA_SEGMENT_ACCESSOR(tr)
 		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
 									\
 		vmsa->_field &= value;					\
+		if (svm->vcpu.arch.vmsa_encrypted) {			\
+			SEV_ES_SET_VALID(vmsa, _field);			\
+		}							\
 	}								\
 									\
 	static inline void						\
@@ -595,6 +636,9 @@ DEFINE_VMSA_SEGMENT_ACCESSOR(tr)
 		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
 									\
 		vmsa->_field |= value;					\
+		if (svm->vcpu.arch.vmsa_encrypted) {			\
+			SEV_ES_SET_VALID(vmsa, _field);			\
+		}							\
 	}
 
 #define DEFINE_VMSA_ACCESSOR(_field)					\
@@ -629,6 +673,25 @@ DEFINE_VMSA_ACCESSOR(last_excp_to)
 DEFINE_VMSA_U8_ACCESSOR(cpl)
 DEFINE_VMSA_ACCESSOR(rip)
 DEFINE_VMSA_ACCESSOR(rax)
+DEFINE_VMSA_ACCESSOR(rbx)
+DEFINE_VMSA_ACCESSOR(rcx)
+DEFINE_VMSA_ACCESSOR(rdx)
 DEFINE_VMSA_ACCESSOR(rsp)
+DEFINE_VMSA_ACCESSOR(rbp)
+DEFINE_VMSA_ACCESSOR(rsi)
+DEFINE_VMSA_ACCESSOR(rdi)
+DEFINE_VMSA_ACCESSOR(r8)
+DEFINE_VMSA_ACCESSOR(r9)
+DEFINE_VMSA_ACCESSOR(r10)
+DEFINE_VMSA_ACCESSOR(r11)
+DEFINE_VMSA_ACCESSOR(r12)
+DEFINE_VMSA_ACCESSOR(r13)
+DEFINE_VMSA_ACCESSOR(r14)
+DEFINE_VMSA_ACCESSOR(r15)
+DEFINE_VMSA_ACCESSOR(sw_exit_code)
+DEFINE_VMSA_ACCESSOR(sw_exit_info_1)
+DEFINE_VMSA_ACCESSOR(sw_exit_info_2)
+DEFINE_VMSA_ACCESSOR(sw_scratch)
+DEFINE_VMSA_ACCESSOR(xcr0)
 
 #endif
-- 
2.28.0

