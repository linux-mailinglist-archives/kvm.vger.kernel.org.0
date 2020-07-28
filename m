Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31A3231657
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 01:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgG1Xi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 19:38:58 -0400
Received: from mail-bn7nam10on2042.outbound.protection.outlook.com ([40.107.92.42]:62212
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730500AbgG1Xi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 19:38:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5gTVFmlf+Qd4MMJA+N5u5k0VAHjKX82yQHb0rNQWB9vJEd/WBmg4eRQuU2sxYB4h46VOu6c8XNLwTJw2N9bgJdfrFIUgmROMKWZbPHtrSUowB22vRGyqJ1EEJCU7fx40qEOV3Qg3dP9d/qpb/9hNYqtrr6zM1ptgBi1DMzEZZayWwgs3AGObF7mlVJsjEJ+1UQGcAv45ODG8Z6eKZ7YE1Hgh4YN1GS5eNdSjL5JG2jwXiVn3q7Yt+GW8ZBB+jEVarM8I/pmlGnZUo3KFG2A7+98PJkx/qgpIWOqHb/B/MwqjujOTZhqVYmnvJEeHdUJEkrGptUi2AsqqXjVoaVUdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WE2qnEMQNVxJ6mxTaCReBhaJE1QqLxKTleHbYOi9e8=;
 b=JRYSMAYkBP3QezN3mBnuiddTmEVSNm4IiiYRXIVxewJF7fPj6Sid7XbAJTmR8jpt07YprkNj4gpVerD25BZqkalVSX6dfuUC6XFeTIEr5gcTkq58CI8bMJfXfZFPOLDR+U/kLvk4eqyveKa1LEV3PxKdieLG9O2h6xnA8on1KYGXj8OeQ+QWHWJo8UFoxTBHRKmGzNmuMIeWPFVqeOOKtNFV4OVEwQ5miDgY68k25XXpt+jkOKMkz6KpuKjDvtkdkgTik9PWhuStKrKHEkUaYw8N1xi0BbAddXvvKYL/sPbtnttjFwosb9G54SI7BZtFuJb2IWRHPHgH8pUpLxOMDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WE2qnEMQNVxJ6mxTaCReBhaJE1QqLxKTleHbYOi9e8=;
 b=2YP3u6XvZ8XwQF09onjfQqEJM+qe19C569OcDAnTP+zviFMFYf9assVm8R76TZVoRsv1RtDHvy/jttIAJcDwK1x1cHXqeLfgLjRgxO/zRUE9dm+JDEI8YHcq7Y+Eq3Nn6fwPeMkl3rDf56icbjeNqiF64oo5QuLNuKE8QhbYMpk=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 23:38:54 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 23:38:54 +0000
Subject: [PATCH v3 10/11] KVM: X86: Move handling of INVPCID types to x86
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Tue, 28 Jul 2020 18:38:52 -0500
Message-ID: <159597953280.12744.625668493094858788.stgit@bmoger-ubuntu>
In-Reply-To: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:806:d3::7) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SA0PR11CA0002.namprd11.prod.outlook.com (2603:10b6:806:d3::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Tue, 28 Jul 2020 23:38:53 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 622ee7bc-4f09-4245-0d4f-08d8334f63a1
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2559C2E3968BD4287C14FFD295730@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfi2g07ZwcnF3GC1OZjqJcoVX7wPUdh745Tezp6Jlo0LUEwht2B6Iiyp0XLG/MmFTuNqyJq4LzMdMoDd0TvAuSfrogQEYaiMbcTQKkd81tRbGZ5EBcHqiEugZO/EKaUjxCZq9zmNBGSELgKdfRbBgxE2ks4pmWCyGpg55xU9r8c25yD5qkWysMcna5b8xE+Je9K+NgBXemkvQhTdDvjQgRVMaDWommOTOe4TwakY+2F8lxYaJDmBHAvAvgdgd5YiDXZyr1kUW/0nYq6mxBA7D/7nVvW/jIvzpk0RO+G91ANogjQAhVyQMzzaX3xC4ARMhn3Pvxnvz1WodfUl0QA+ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(66946007)(66476007)(5660300002)(7416002)(316002)(478600001)(6486002)(16576012)(66556008)(2906002)(103116003)(83380400001)(86362001)(9686003)(8936002)(16526019)(8676002)(26005)(186003)(956004)(52116002)(44832011)(33716001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: N46khQVS8b6eO3VNlreHFTCKffOXVSzuXEsm7JXnTD/tkpjTC2L/zbBFawtEXs2R9eTGEQj4yKyTmD7zM34l1JHJ+g/u7+QYX86YvYKSm/GrH0xlYTbRsRa3pQWRzWLvePduMn/scQG+n7KXPxkgJwpKKjGE8VLVZDlnEnQ9r9jFZQ3UVPnlxfyrl/3NP43Um9B5FiZ/h78iPT0Hhvt9M2OoAeG3YRUdQ7tDKIrNzKtWOW6j3tSc457Fiy74Q8dcDpSJfsH+3t2AClYUCgW3eHHeDK8Ax2/xY0O8+hyXC0s50Mj+FGXx0RMBdA1otOAnvfSXJf9uEBsImsU08awxcVz/4zQlzJjrVvwsdEBnsmGjpFRVtSuN8Oa0S6hGV6gl8X62Wp+6cGStO5k3uWKoWWyFrBnrAgnlrORFsdTwiBjcXBbm88nGruXwnwcK3G/RmpFUPNqwytjXM89n05jGj6lPrm+EAfy1xM4LGJr1Hdwo+LmW4+xuGSkKk/zgrrQ3IWHciw+FHMbmCdehLakiThZHM3NZtg8XnPoR6cwzPlhs1L55nIU2lMbQ3QdyqxZ4Kc2V4gCe/AXK3m24Lxr6voOEXtxTLwEFVx1okNErlT7TO7782nj4I3g1lu5/l3gqS9GCqHQqgXOzwkj/ycI8qA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 622ee7bc-4f09-4245-0d4f-08d8334f63a1
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 23:38:54.2695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QIvB3I+Rgzeap65xNOrt5j2Ha68PV4U02/Ta5b9nIPhgtuPzNlnhFxXVkGehDffL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

INVPCID instruction handling is mostly same across both VMX and
SVM. So, move the code to common x86.c.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/vmx/vmx.c |   62 +------------------------------------------
 arch/x86/kvm/x86.c     |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |    3 +-
 3 files changed, 72 insertions(+), 62 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 13745f2a5ecd..eb988ebedd9e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5500,11 +5500,8 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 {
 	u32 vmx_instruction_info;
 	unsigned long type;
-	bool pcid_enabled;
 	gva_t gva;
 	struct x86_exception e;
-	unsigned i;
-	unsigned long roots_to_free = 0;
 	struct {
 		u64 pcid;
 		u64 gla;
@@ -5536,64 +5533,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 	if (r != X86EMUL_CONTINUE)
 		return vmx_handle_memory_failure(vcpu, r, &e);
 
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
+	return kvm_handle_invpcid(vcpu, type, operand.pcid, operand.gla);
 }
 
 static int handle_pml_full(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88c593f83b28..a3a3aa42b695 100644
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
@@ -10699,6 +10700,74 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
 
+int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type,
+		       u64 pcid, u64 gla)
+{
+	unsigned long roots_to_free = 0;
+	bool pcid_enabled;
+	unsigned int i;
+
+	if (pcid >> 12 != 0) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
+
+	switch (type) {
+	case INVPCID_TYPE_INDIV_ADDR:
+		if ((!pcid_enabled && (pcid != 0)) ||
+		    is_noncanonical_address(gla, vcpu)) {
+			kvm_inject_gp(vcpu, 0);
+			return 1;
+		}
+		kvm_mmu_invpcid_gva(vcpu, gla, pcid);
+		return kvm_skip_emulated_instruction(vcpu);
+
+	case INVPCID_TYPE_SINGLE_CTXT:
+		if (!pcid_enabled && (pcid != 0)) {
+			kvm_inject_gp(vcpu, 0);
+			return 1;
+		}
+
+		if (kvm_get_active_pcid(vcpu) == pcid) {
+			kvm_mmu_sync_roots(vcpu);
+			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+		}
+
+		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+			if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
+			    == pcid)
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
index 6eb62e97e59f..2f2db47a1a50 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -365,5 +365,6 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
-
+int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type,
+		       u64 pcid, u64 gla);
 #endif

