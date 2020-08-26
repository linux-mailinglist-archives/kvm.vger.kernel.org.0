Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA89253811
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgHZTPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:15:52 -0400
Received: from mail-co1nam11on2076.outbound.protection.outlook.com ([40.107.220.76]:57728
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726838AbgHZTPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:15:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFfgPfnugRXTAy2ojTR1lPl4xzogFGOZgc9FxkWzw9h+tT2MqBgEtDAh4yNGiycbMQldjOlvPPQgP31fhdJl3ER45GanfhPPSUWOkwByfXwK5KWUNjP7Tzyr+mUCygx6wg7KyzzKOIF1XJ8NquDgtAMusA/SKdQJQDMsFRGpMFsAVeekgTvXH8idpebYGJaQaGFNd8cbW3tMyvhgJmhVDWT5kOCUVy7+XAqOo0YGxi12+a7jp4esdHF5nfYsMuOL0N2rzBmi+ZjIIyzB7mk+RkazyBAqklReJ+fXiYtKhvPWr7MU2m7Zoo5wTWOBIb6VeJjK0H6gUbd6L9rcdXdWig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FczUHdNz8TZmMjKROJr9AgBabQceT5tAe4HHtJdYUjk=;
 b=C940DQekVfgfeRB9S6ZKAmhZwLOpeik1OFVytrhp28Ner6EwTpMXZ730aX3E+jYTvOK3Y2W0KiPo01fwAhd7uKE/YT8xOjyrdFlFDZQvZMyY4QuvvHeTqM2Y8sDpJEK/EirEeo2dhSu+JHHFAIq+81nTkMDiGVNzknF96QBvhol15Lj6zaOC1261/i/42Z4tuFA7N5+PWPoKgibyGJCj4QLVIcRVE2IBDGihuK+SAuEUPqxN9Rf6b0OQGPgEkcH47njjLcCAF2lHbosLPycLElNO92rVcSHL6izTpWH9J+ZPmJv2hrBAuPwDgMQokyv1lxkjwjn0uq4KB9AHDCk+xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FczUHdNz8TZmMjKROJr9AgBabQceT5tAe4HHtJdYUjk=;
 b=kfK6nvVQmYRmnE1N1FF6IcR0KUoNMnI3Qxmo6BlugehmG5u/sRKytAr4E+MoyvTxNmYtxG4NabVVg21+7/23D35P9I3dzMaO8K/O3ZdW+Y8LkcwpNnu57aEBXv43dYz119pE/1riiBlJBEwELgBCB5hCErV4aSGZ2Vk40JuYxiE=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2384.namprd12.prod.outlook.com (2603:10b6:802:25::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Wed, 26 Aug
 2020 19:15:12 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 19:15:12 +0000
Subject: [PATCH v5 11/12] KVM: X86: Move handling of INVPCID types to x86
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Wed, 26 Aug 2020 14:15:09 -0500
Message-ID: <159846930937.18873.8981656942066067627.stgit@bmoger-ubuntu>
In-Reply-To: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR14CA0144.namprd14.prod.outlook.com
 (2603:10b6:0:53::28) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM3PR14CA0144.namprd14.prod.outlook.com (2603:10b6:0:53::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 19:15:10 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6a66744f-6935-42b0-5535-08d849f45ada
X-MS-TrafficTypeDiagnostic: SN1PR12MB2384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23846352055BC123FC97483395540@SN1PR12MB2384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5aCMhHk7rsCvWgIywvl2ijc7B4Jco0wciJzDtTVmz8wMME8JTCdp2RsS+cOSf2FINaSZq/8GdV/07Vnao6yjGj9u7M07WYBsROkPAe6n0Ant3HdB9+s+RNuCTrl/JVI9uevSYF2VZsLpDw9I+5VWIM6wFehyYIYaiSHl0s1cE85de+n59J+H45YvHltQ6AHpgYMquxUqIoRSuf4Pj2s89sgzedg6qsFzCaC5L02pdwXLysShS3zsFkkIuWpv2cZ/rKV73w/qEgp6g3krdyR3b2yr+FfdzZScsMKPZBRx29JPoY45sz/qgmBQaBMnYK3BMDWYPNDxRrOZgBAdgPtmaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(366004)(136003)(376002)(396003)(39860400002)(103116003)(4326008)(186003)(66946007)(5660300002)(66476007)(66556008)(44832011)(86362001)(33716001)(9686003)(52116002)(7416002)(83380400001)(6486002)(8936002)(8676002)(16576012)(2906002)(316002)(26005)(478600001)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: C1yxCgrwNimp6w/FGn8xuchEAXukh4qrt8KlBF0091maEy4M8y3yg7vXyZKjw9c6fVhYQWbX8lygna77N8T0+nP5plAi3ZiJ9AKUDPwVmkcrKlBkpdg2YdbLOqcVZbpCd78DxmoZQReiCuJvpd+dUnnsZgTgfOxGaO1QvTU13o+2sjrjVbXAk7SEXAyZF0indJZB0XKhXw9JCSsLrspcKZY26UcidvVEKCmYRJsEOoykOlwP37obD5FASgnNkzKHmNsF6C1EDW/JjBqG1zKlr1G9x8omksPddJWNtKo8RrQa5yGpVrLlNWiSs8vKDZZM+Q84lrowv2OyuQMOLpZ7I70u0CmQA7S9ik5si5LY4/BwIdoUNqbUYq0mUAJaEycEuy3KGw/kAfEgr9wK2IM/tRN1p0AhmbXv+JOvlGgP8SbVMT4ZVR/mVaCXX9gtNXi3TrNkdVPm7kEjTzCwq64z9PQk4ZYKG96vwyjPXXgTILZWBdVFDXk+1Dcjoj4kOB50TpThj/y8BJOFX7S9AnL5AA6B9JBTl6Na4alQl8AAebwMvDVZPkrsrDH8vwVe5OKUEomB1s2XvTUBYjkYSfw2AoAQtIaFH/QC/nmcDvN0Y1L2IGroZgKt+L6gj3GWAF3VEKYDfMkmHQ0ZtjCf3RO7Nw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a66744f-6935-42b0-5535-08d849f45ada
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:15:11.9700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OBOK0SZqOlvun/f4FaQb9zarGnxnS6j2X6gMbUDwOOZkzrwI+KQy+xzJ0mKB7Egq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2384
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

INVPCID instruction handling is mostly same across both VMX and
SVM. So, move the code to common x86.c.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmx.c |   68 +-----------------------------------------
 arch/x86/kvm/x86.c     |   78 ++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |    1 +
 3 files changed, 80 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b15b4c6e3b46..ff42d27f641f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5497,16 +5497,11 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
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
 	} operand;
-	int r;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
@@ -5529,68 +5524,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 				sizeof(operand), &gva))
 		return 1;
 
-	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
-	if (r != X86EMUL_CONTINUE)
-		return kvm_handle_memory_failure(vcpu, r, &e);
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
+	return kvm_handle_invpcid(vcpu, type, gva);
 }
 
 static int handle_pml_full(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5d7930ecdddc..39ca22e0f8b2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -71,6 +71,7 @@
 #include <asm/irq_remapping.h>
 #include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
+#include <asm/tlbflush.h>
 #include <asm/intel_pt.h>
 #include <asm/emulate_prefix.h>
 #include <clocksource/hyperv_timer.h>
@@ -10791,6 +10792,83 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 }
 EXPORT_SYMBOL_GPL(kvm_handle_memory_failure);
 
+int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
+{
+	bool pcid_enabled;
+	struct x86_exception e;
+	unsigned i;
+	unsigned long roots_to_free = 0;
+	struct {
+		u64 pcid;
+		u64 gla;
+	} operand;
+	int r;
+
+	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
+	if (r != X86EMUL_CONTINUE)
+		return kvm_handle_memory_failure(vcpu, r, &e);
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
+EXPORT_SYMBOL_GPL(kvm_handle_invpcid);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d3a41144eb30..6781fd660a29 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -374,6 +374,7 @@ int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
 int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
+int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);
 
 #define  KVM_MSR_RET_INVALID  2
 

