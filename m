Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485C91FC151
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 00:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgFPWDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 18:03:44 -0400
Received: from mail-dm6nam10on2087.outbound.protection.outlook.com ([40.107.93.87]:26966
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726397AbgFPWDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 18:03:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jv+it1B7pbkP4rfp4CYvt+sSlq4v17xZF8PicswCvQDt+G/NuVTh5Y+c6z8BHuk9XGIJhY2T7N5is/FXs48Sg2ldVQQ75E7vGHpeEIrA4/15ENvXMqgpYTvH2BbiE7IQnyU2A13LlDrYRk9yz0FowNwnL+UgYpoehyO3YTV+zLOXtuZFdcSG/ntMIaKWUBbpLxZXkjGrguoYQfNHWOMTRTTm+VYk3SXnimvDKu0qQz1pK0prq1vjFj0Q43qulfJMBomSZbVtyv253UibLn5k0e6IB4/oTbtLlqIP1cj8haS/i2cpnW7MdiXwK6wAuDS1Q2BafCJ0AMqzdg81uFo3gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEBUmA5sOctOQ7RAonG8lN4Opt2pnHURJXk/mUicfDA=;
 b=eWN9Vlhju6aRsoTxENKs/0YRawduubL9dap9oBpWB8qi42tGJIobTeM1CdK3YfWPsKtxFp5moLGXyYdb5B2hS46ED5CVpdECSPedJg+cV38jHatnnrya6qY3e63/Cz7JxfTHXOZMcUM/p105+FOVnXUoziZIpua4aKGbcY5pZY4Q4WVcQ/PryqKiDQHM17TCZoiVthLYy0MBc3gHMDWgb7NCVJiLfefEZMIaxqtEkga3mMbZZww2lXqoQLRglA+B77gX1jKzZSwxBBmvKnwLNWPmjCjKewKBHPbMytPCZrGxoWJCqseuq2vxQfGD8NbchnJo3wBqTkhWswAYQd9Vkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEBUmA5sOctOQ7RAonG8lN4Opt2pnHURJXk/mUicfDA=;
 b=EIaZJQUfI9OJ6YE3kN9LZZzKSMy3nGPZQoZvHayJJTg8euhOPFpaWQs2KEPcX6ezapLjN6XDOjYwbsnBvR8OpoIT7gDj7IuQv3s0kw9N+XzNFvubJoP/UqdUc8JUG88dJIlW3tPx3T/JO0+sy+DpoB33MY3WxrFEoehX52K57vk=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2622.namprd12.prod.outlook.com (2603:10b6:805:72::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Tue, 16 Jun
 2020 22:03:38 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.029; Tue, 16 Jun 2020
 22:03:38 +0000
Subject: [PATCH v2 1/3] KVM: X86: Move handling of INVPCID types to x86
From:   Babu Moger <babu.moger@amd.com>
To:     wanpengli@tencent.com, joro@8bytes.org, x86@kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, vkuznets@redhat.com,
        tglx@linutronix.de, jmattson@google.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 16 Jun 2020 17:03:36 -0500
Message-ID: <159234501692.6230.5105866433978454983.stgit@bmoger-ubuntu>
In-Reply-To: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu>
References: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR16CA0001.namprd16.prod.outlook.com
 (2603:10b6:3:c0::11) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR16CA0001.namprd16.prod.outlook.com (2603:10b6:3:c0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19 via Frontend Transport; Tue, 16 Jun 2020 22:03:37 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d1145439-1343-4908-229c-08d812411faf
X-MS-TrafficTypeDiagnostic: SN6PR12MB2622:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB262222711AE86A26C07C6201959D0@SN6PR12MB2622.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04362AC73B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MLnamlxHXmaOFNRX4fuqqSmCg0zo5SeJiF8jYUX/uyw5zdN2OQwRmnn0+ljRmEbjIfVpytc/o7qFNP82S/T2+mMpE4ZEvXH/FNiAygpiO4ohb6Q5KV9fg/2qYTR1Q9BmJGM06q6ezRfkPx4R0FhwKyevLb1p+xrBDLUsXKwKqw/fdF2JZ+rv0MPn9LNpMwQKFOKxfqLZqGyNcLT4cJnz28hl2Ikb0cWdhe6mgpx08vGxZsN2M/AzWkx0H0QzG3HWAHTDWPWk6WpVbWuk22joFx7UL5b9ygh15QxlSqax+s49RRbeUDj1dpJ0bVWH1XDLuE+AZestZSXp9z2zwef85VG9v9d2uEmYErF0Zhx+o1HTOdWXN+JBBEor5RR0/K3i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(366004)(39860400002)(136003)(396003)(376002)(346002)(7416002)(8676002)(83380400001)(478600001)(5660300002)(16576012)(8936002)(186003)(4326008)(103116003)(16526019)(2906002)(316002)(26005)(66476007)(66946007)(66556008)(956004)(33716001)(6486002)(9686003)(44832011)(52116002)(86362001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6QNrCNPV6HWFmUrbEKNG4+JgkhHkYqzhHlYZQkmtPYe27kDFMnEwvhvahOu1yMPrwZS+4I0TnI1edzlYMmxuVYfLKoALc/LlTU4h0hszbReoLvNHoTjn+W6ETghVB2xw94CRsHsIInhk13yhm5QPP4kLgFDgodtsWObQuyFbpKDqyy8MPTogFvZwM1Y7yPS2sTRdZYfghJxcS7iOcfeDzGBStsP9NMMwBmaSnpsTRzia/SsbW2MkAjJNdISNUOjdZNUHIPwfpvNRxgdO7AdGXKxqIp+RuLns7T3sFVkXeedFM3g49sW2UjCPhxzZL52ZUKGndidfr5VrrXVvsn+a+NOJuuhLnUX2D3fUKkK5UKIyl7TdLS3BiOFyg83XA2SbM0aRdKC8D/EFhstaRZL6AmSMAxgQmK9FH4teRrFDvXUks+El5EF89uGzWeR7o0iENCV8ar8lZSKOZN/XpZeFzvcPMGrLlKFSzzNoCoaT36k=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1145439-1343-4908-229c-08d812411faf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2020 22:03:38.7550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmj55qUTecJ3H62FZMvbyFX8cvZf02LgZjYpDeCq292LHKQGKvmVGd3PyXkgagTX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2622
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

INVPCID instruction handling is mostly same across both VMX and
SVM. So, move the code to common x86.c.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/vmx/vmx.c |   68 +----------------------------------------
 arch/x86/kvm/x86.c     |   79 ++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |    3 +-
 3 files changed, 82 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 170cc76a581f..b4140cfd15fd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5477,11 +5477,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 {
 	u32 vmx_instruction_info;
 	unsigned long type;
-	bool pcid_enabled;
 	gva_t gva;
-	struct x86_exception e;
-	unsigned i;
-	unsigned long roots_to_free = 0;
 	struct {
 		u64 pcid;
 		u64 gla;
@@ -5508,69 +5504,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 				sizeof(operand), &gva))
 		return 1;
 
-	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
-		kvm_inject_emulated_page_fault(vcpu, &e);
-		return 1;
-	}
-
-	if (operand.pcid >> 12 != 0) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-
-	pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
-
-	switch (type) {
-	case INVPCID_TYPE_INDIV_ADDR:
-		if ((!pcid_enabled && (operand.pcid != 0)) ||
-		    is_noncanonical_address(operand.gla, vcpu)) {
-			kvm_inject_gp(vcpu, 0);
-			return 1;
-		}
-		kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
-		return kvm_skip_emulated_instruction(vcpu);
-
-	case INVPCID_TYPE_SINGLE_CTXT:
-		if (!pcid_enabled && (operand.pcid != 0)) {
-			kvm_inject_gp(vcpu, 0);
-			return 1;
-		}
-
-		if (kvm_get_active_pcid(vcpu) == operand.pcid) {
-			kvm_mmu_sync_roots(vcpu);
-			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
-		}
-
-		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
-			if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
-			    == operand.pcid)
-				roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
-
-		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
-		/*
-		 * If neither the current cr3 nor any of the prev_roots use the
-		 * given PCID, then nothing needs to be done here because a
-		 * resync will happen anyway before switching to any other CR3.
-		 */
-
-		return kvm_skip_emulated_instruction(vcpu);
-
-	case INVPCID_TYPE_ALL_NON_GLOBAL:
-		/*
-		 * Currently, KVM doesn't mark global entries in the shadow
-		 * page tables, so a non-global flush just degenerates to a
-		 * global flush. If needed, we could optimize this later by
-		 * keeping track of global entries in shadow page tables.
-		 */
-
-		/* fall-through */
-	case INVPCID_TYPE_ALL_INCL_GLOBAL:
-		kvm_mmu_unload(vcpu);
-		return kvm_skip_emulated_instruction(vcpu);
-
-	default:
-		BUG(); /* We have already checked above that type <= 3 */
-	}
+	return kvm_handle_invpcid_types(vcpu,  gva, type);
 }
 
 static int handle_pml_full(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e41b5135340..9c858ca0e592 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -70,6 +70,7 @@
 #include <asm/irq_remapping.h>
 #include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
+#include <asm/tlbflush.h>
 #include <asm/intel_pt.h>
 #include <asm/emulate_prefix.h>
 #include <clocksource/hyperv_timer.h>
@@ -10714,6 +10715,84 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
 
+int kvm_handle_invpcid_types(struct kvm_vcpu *vcpu, gva_t gva,
+			     unsigned long type)
+{
+	unsigned long roots_to_free = 0;
+	struct x86_exception e;
+	bool pcid_enabled;
+	unsigned int i;
+	struct {
+		u64 pcid;
+		u64 gla;
+	} operand;
+
+	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
+		kvm_inject_emulated_page_fault(vcpu, &e);
+		return 1;
+	}
+
+	if (operand.pcid >> 12 != 0) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
+
+	switch (type) {
+	case INVPCID_TYPE_INDIV_ADDR:
+		if ((!pcid_enabled && (operand.pcid != 0)) ||
+		    is_noncanonical_address(operand.gla, vcpu)) {
+			kvm_inject_gp(vcpu, 0);
+			return 1;
+		}
+		kvm_mmu_invpcid_gva(vcpu, operand.gla, operand.pcid);
+		return kvm_skip_emulated_instruction(vcpu);
+
+	case INVPCID_TYPE_SINGLE_CTXT:
+		if (!pcid_enabled && (operand.pcid != 0)) {
+			kvm_inject_gp(vcpu, 0);
+			return 1;
+		}
+
+		if (kvm_get_active_pcid(vcpu) == operand.pcid) {
+			kvm_mmu_sync_roots(vcpu);
+			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+		}
+
+		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+			if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
+			    == operand.pcid)
+				roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
+
+		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
+		/*
+		 * If neither the current cr3 nor any of the prev_roots use the
+		 * given PCID, then nothing needs to be done here because a
+		 * resync will happen anyway before switching to any other CR3.
+		 */
+
+		return kvm_skip_emulated_instruction(vcpu);
+
+	case INVPCID_TYPE_ALL_NON_GLOBAL:
+		/*
+		 * Currently, KVM doesn't mark global entries in the shadow
+		 * page tables, so a non-global flush just degenerates to a
+		 * global flush. If needed, we could optimize this later by
+		 * keeping track of global entries in shadow page tables.
+		 */
+
+		/* fall-through */
+	case INVPCID_TYPE_ALL_INCL_GLOBAL:
+		kvm_mmu_unload(vcpu);
+		return kvm_skip_emulated_instruction(vcpu);
+
+	default:
+		BUG(); /* We have already checked above that type <= 3 */
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_handle_invpcid_types);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6eb62e97e59f..f706f6f7196d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -365,5 +365,6 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
-
+int kvm_handle_invpcid_types(struct kvm_vcpu *vcpu, gva_t gva,
+			     unsigned long type);
 #endif

