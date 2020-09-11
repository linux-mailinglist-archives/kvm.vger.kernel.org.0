Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591B32668C8
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgIKTaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:30:35 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:23168
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725967AbgIKTaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:30:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVp8/D6dg7UYl5jOYP4Rz8N7s3wYsQ8nZH0ipNvK8yr+8+WbypNFixsBkEKi+ltKtgnA32UvICPd6j5c6hZ+t+/1BCcxj4bYAbHRKxXSc+ExMRAiBFHFF9dbotry4vV1SYK7sAMQsIPlx0CGk64T0l3KC7BGDHmeQdo1pvXs0o7kx5XBjq8c9NmU9QJxLDmym8A7Y0pPa931vNOQSxFl7BA7wN3QH0NEoDcWi6dGcPeqxHj9TAyvMOhZChO0QJJNpxy8LFqC3uWJEPTYXv4i2IRhIlTNJK5QWz/fgLPZtCjcFXqgxp55YadRZdb83HWEewgjKaj6X7XBzGNLKVd/Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FczUHdNz8TZmMjKROJr9AgBabQceT5tAe4HHtJdYUjk=;
 b=Bo7A55r8LzwTXveT41z6YyaoAL51n5OyErkIMp7EtxPEF/ak+OyVVb76OfFgZZjdvMC18Fiq6ntWUkvRMsLVLTxLRBt6eR5n6k3XhFcpmqumbK1bGcEComfbV0oX4ypfgEEBpWex2fgt/qqHpmFdKyCvwtf0sMgsMI3Oc1PkaY7wkladovrkjVo4CMOv73ZAQiek3lS6+znA9HBaz0iHRDodb/9jxmrm3hi2xDubpLNZqZEbRwrdIlKmflq0Bmm7ealowuVV0KyEPAMB9LYP8X34hLnKsanoY3sADqmQplsCzJnLQlnqmRSt5q03/nQ1Mk0lMQuIJBpr5JHuA6SbPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FczUHdNz8TZmMjKROJr9AgBabQceT5tAe4HHtJdYUjk=;
 b=LZh2NYB3m1MhkxjkL2Es2d789g7COoydSC/6Td1bOnMFhNBgUZ4mdA1PqkZL5r7ng6TQ4NNbbtj7ORfAdJ70rJOy0pN4B43xggNspOtMfsLQyqFLbKDf4L+qJ7sawmbRX9AmlNtyYCU/pHyTuPaEdk+7gvWVYJIZZtB4L/23pyc=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 19:29:14 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 19:29:14 +0000
Subject: [PATCH v6 11/12] KVM: X86: Move handling of INVPCID types to x86
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Fri, 11 Sep 2020 14:29:12 -0500
Message-ID: <159985255212.11252.10322694343971983487.stgit@bmoger-ubuntu>
In-Reply-To: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:5:174::29) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM6PR21CA0019.namprd21.prod.outlook.com (2603:10b6:5:174::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.0 via Frontend Transport; Fri, 11 Sep 2020 19:29:12 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5dcf06e2-ae72-43ab-e035-08d85688f76a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45439791CAFBD8E1498AC87195240@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yXXwpYfsCClg0cYf8tqqxRg8TyjBTy8v/3fkiEGtlLrDIF23SVtQsGGgDjt/YkBmx0rIoC6WDHSHcnklp50iWDQf1VCnzzfDVArCgGdwq2T8ut/dsO6cVcdk1FZq3s/9odBER3W+GaM/yKsMoYGHF3MIRq2wYx7GoPHfHd7xY9NyIY9BRhfGGo8I42F6azr/cgqnPz0H2QId80aJoze9pGWutsTW+MPbQm7srz7NrMwLmqwG+1VYkV5H61zOeCSchjWfgVvSgKqux6BsmEhKjyCRkAbvG+S6D6Rx77Ax1wPo0Rmi29sHg7GSJYOUNZ9FaCKn8G+CHbBjkKptBP/kBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(2906002)(956004)(66946007)(66476007)(103116003)(8676002)(66556008)(52116002)(5660300002)(7416002)(9686003)(4326008)(8936002)(44832011)(186003)(16526019)(86362001)(33716001)(16576012)(6486002)(316002)(478600001)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MyzM3+ceSbBN7CxHGqWsyAnq9bo04I8yawN4kmb2bxJ4F2E+S4b39e2iZtl/QAi+Auiabuixxu12npjjbY0koMPy5Wu7W77xmosC+/Jol5unNdjbvFVvhBnK0bLAkMf8AJdmHy9H6ZVmaYE1nD4jEp12J1Cbo0ZiwcODPTQFtNvapUEfLxCIzckqD6BbA7D5j/VBUOgARVlKS51JENGslcY9q1Rw3aGy0eyATbpZ3e1pBmiJcs3ZiwD97udN2i1ypuRGKJpWwF4Bxh5B5Z8q/gENewjUgODqJhfUJEasrQ/+orR4ovJ11NcKHO+qHDvwdo7Q1MtLH/BiLDOoNu7mObPhuFviiq/rEDTfMjOmXWCz6O1Zn7ZEG21FRDeHQXN6E8dgMyT38ArgCiGQPW5PqUpBcKUPsY0lY2htA6HZeFaMJEKVJb6Ayhl4rGaZKC+bJSKzLcMXNKXUYJUpiwnCVnzsTf/xiMWbkvIkiLCF55MUAwjnlnEzGRxJInT3/LcA217tkH0SFQe8GGTtKv8A3eXPFXBQ8pzNKkh5go4+sshCg/lTRGnYAypB0EdS0455CteO931cvB+nolot2CoMBWUzzTs1tiFgw0UXn8kX58/tR73IGN5UcInK6yEqZFUCNeNL1NkKqsoaDweDQgU5kQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dcf06e2-ae72-43ab-e035-08d85688f76a
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 19:29:14.0931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fikmjmct7G7ZOj/vluPB0K7FNRhWsCTrAJsFCJd1jZ3s0sh/FiRQ8BjHwRBwFT8R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
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
 

