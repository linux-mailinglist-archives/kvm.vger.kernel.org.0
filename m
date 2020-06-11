Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEF41F6F8E
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 23:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgFKVsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 17:48:42 -0400
Received: from mail-eopbgr680061.outbound.protection.outlook.com ([40.107.68.61]:20994
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726349AbgFKVsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 17:48:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9AR4ORoEAtoQ8Jr4TQXFAf1b85rD1iDvq4GnlIWHqGqGWMK0Z810ZXVDZLyBGxnyuFQuzdGsTUgm8vZZ3ZKI6GFc4EDV/1i354kpHXrXDANCeyIcZWDEaF9IZy3r/dhH6FwPiTk2kOyd31/kZpLLre5ZwF6FwvczDp4HekhAfBVT1F59NNkZkJeb8k9fjNZ9crljMxNLRbYMdnV7kwSsOgkF2Gtonl2OBxo4NcllSHei95paf1YS+ZEyHdn1drSkv6rbLUYqYJ+IWY80df87Aaw2zTYRYmjdrgkzAZQapnAdEzma+8/9JAY60pkyBGnaNHH0Te7QiAMAZa2w1IK1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wszXHOme3aEp+KG1tt9uh0LeRs6FwrR/e1hp0UE0DLg=;
 b=MNmmomBkCUevwKfOidy75yMJaPbeSP0li8FNqi7LRTVt1O1MVphSZ9iw0truIcDyKKNuVdm6fKu1wSZWk3JI0RFmFfM1r2fG2BlClZUGT+3wycQQKA8H7ndsJN+X9tfqfzhWSBjfXm/OBKO00paxqSSkiITv9Dc2We1rtpgPA8OUgNabdjbdvcFhV56G34JSmxRwJmkwlip8RDl0t1SYrbRWJTPqb48VlN5/yy7fcaSEl7VLLY5/iCdcEVZbBiTCElRiDlmmejaED7tKkN07jafmU5joDb0QyHaEfhop0ipnEPz1Q60rMDFqPWkUickGZDzCeWZLWBavIstSqhoqww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wszXHOme3aEp+KG1tt9uh0LeRs6FwrR/e1hp0UE0DLg=;
 b=ohfXqpujW1Ncvi03OLfL2eF5ey+44Vs0GewYF8mvo3DdskaT1xqfifJ9cWQ5oQe1BHl0gi5SgOsPYcGo1y5yrix0tl+iJAatpz1djMbABT+eXOcuzYdb5KGSrgpsHEgGtWaDj94yW43gyD5IkGShIG497DsNZOi97AukX3l7nQY=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4589.namprd12.prod.outlook.com (2603:10b6:806:92::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Thu, 11 Jun
 2020 21:48:37 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 21:48:37 +0000
Subject: [PATCH 1/3] KVM: X86: Move handling of INVPCID types to x86
From:   Babu Moger <babu.moger@amd.com>
To:     wanpengli@tencent.com, joro@8bytes.org, x86@kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, vkuznets@redhat.com,
        tglx@linutronix.de, jmattson@google.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 11 Jun 2020 16:48:35 -0500
Message-ID: <159191211555.31436.7157754769653935735.stgit@bmoger-ubuntu>
In-Reply-To: <159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu>
References: <159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR14CA0043.namprd14.prod.outlook.com
 (2603:10b6:5:18f::20) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM6PR14CA0043.namprd14.prod.outlook.com (2603:10b6:5:18f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18 via Frontend Transport; Thu, 11 Jun 2020 21:48:36 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0531b781-295a-4231-0f21-08d80e51327f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45899E157719D7B0BD67347695800@SA0PR12MB4589.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zi+jvI/Bc1Do1UzoquT50uT2GUlsbOMKhRKaH9YG1hC6xmlQIzik+CfMt/OlPfGPyMXBvCaDJkragv0NrxA/6kpGb2X72azCK22NfJRHTt5Djdeadbm0uPXe8VrecRUR7CRTZyQhEyN/EqIPA316qKn9RfKYrmQQvrAnks2V8qQi4jAyu34EayN1mhzQeDC1EYWK64VdbeH0kbqucxEiXAIw9UCYCA/g5MIlXeyQTZQe6moG5+TDOKB8fZfrwUkZLB/VjCzaGluFPJlPUiwR+DWVq7WHJtXc2BA0oAoQfzAWgs9hsQTREF0FAQFr9o7SA4L+NMr1LCruofQLfYOIetNevl06swFxHvJCp8xkJs/M2g8lp6ODHpqV6gK31pIk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(52116002)(33716001)(6486002)(16576012)(8936002)(2906002)(8676002)(16526019)(9686003)(7416002)(186003)(4326008)(316002)(478600001)(103116003)(44832011)(956004)(5660300002)(83380400001)(26005)(66476007)(66556008)(66946007)(86362001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Wvjv2Xh9WtQOcI5jIM34HAH2K6BzPPN7eMtPIeCeGKN9bZofh9ybQh8D3nM183vmKolF8LBus/Hgc4W/KvsWGXrusrnTVPIltUm/DGajJlS429guL9o4l0J6k0IrtPuuuMoW8T05kEWUqe0TFXBPm4xpYC6qziYnYEKxX6PMHW3XGrgU6ockDABRDW3HUXlrv/6ZAf/YmmBH1DJyvhMEp5hiNrwIzDHzp23spX2jXWawyRlt0BLJYSxOIK2IRXNQgjToaeU1NjmsKZEGEHcVCdr/j6hm8Q98H8yfu2MGpc69KWA++1kbP6cMDEhFCLg+BVfJVyf7fZxIqjoF0zC0ACQ4IY119+24zDuhXvvh07WJESaL77QCuXfsmMH4f8eo+2ywkNh2pf3pCSPoEkRc9ZgBDUYjdmzOfscbBaDBMFOHML12CqaK2+rv06sHfVNjicBq11mIHZRl+R+ayCyn4ARXWTgHbxyI3O6CDe33fI4=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0531b781-295a-4231-0f21-08d80e51327f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 21:48:37.7911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SH+Ce0tvPFOBVX6S3g1525gggKhbJq/Mfr8uBHFu7CJVwmUPQG5f2kFk6Qq11xGH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4589
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

INVPCID instruction handling is mostly same across both VMX and
SVM. So, move the code to common x86.c.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/vmx/vmx.c |   78 +-----------------------------------------
 arch/x86/kvm/x86.c     |   89 ++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |    2 +
 3 files changed, 92 insertions(+), 77 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 170cc76a581f..d9c35f337da6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5477,29 +5477,15 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
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
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
-		kvm_queue_exception(vcpu, UD_VECTOR);
-		return 1;
-	}
-
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	type = kvm_register_readl(vcpu, (vmx_instruction_info >> 28) & 0xf);
 
-	if (type > 3) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-
 	/* According to the Intel instruction reference, the memory operand
 	 * is read even if it isn't needed (e.g., for type==all)
 	 */
@@ -5508,69 +5494,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
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
index 9e41b5135340..13373359608c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -72,6 +72,7 @@
 #include <asm/hypervisor.h>
 #include <asm/intel_pt.h>
 #include <asm/emulate_prefix.h>
+#include <asm/tlbflush.h>
 #include <clocksource/hyperv_timer.h>
 
 #define CREATE_TRACE_POINTS
@@ -10714,6 +10715,94 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
 
+int kvm_handle_invpcid_types(struct kvm_vcpu *vcpu, gva_t gva,
+			     unsigned long type)
+{
+	unsigned long roots_to_free = 0;
+	struct x86_exception e;
+	bool pcid_enabled;
+	unsigned i;
+	struct {
+		u64 pcid;
+		u64 gla;
+	} operand;
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	if (type > 3) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
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
index 6eb62e97e59f..8e23f2705344 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -365,5 +365,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
+int kvm_handle_invpcid_types(struct kvm_vcpu *vcpu, gva_t gva,
+			     unsigned long type);
 
 #endif

