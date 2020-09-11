Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED562668BD
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgIKT33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:29:29 -0400
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:28736
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725940AbgIKT3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:29:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kp/xIAtsvxuyHaW3Y3Rw8bTIVED3ITOiN3CwPoki4hhHA5nLLD+O4oYh3itSnbY3SA8qKEvsOsm3cVTIVS/YGSZHCmMTq6yiSYTTdAOlu2GJEIrp6hE3iJ2IHQMOiuXMCnfwzE9hKLhcV/qWVwTNNnBItIkNsu2LWykZP8Lx4PFCdR75mOrAItrCbX2i8RRnzG8aVqGkjfFe8AyGEr0Mu7zLk/7RTjCNHLzEHxRsOyQI8g/P+FxyDuqnSdI6ZjOCTNQKhpOmEDJFHyiRhA0LK3UuuHA8XrjHpYWmj3IDMYp1g5+P1X/JqkJs0JvP4h/ndc9RR9vn0FXRO3hbXZUIWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAalj1SfgdRviESXHxYFGTZ2fKZ5+vPge7wml6icgJE=;
 b=l9Wfr2hEPKNFaoRpV6l5GSnrUDMhueUq+yZd15+rGXMRIZq5LrQWDLHp9Xo+kt2Cq9NoydMJWrz2jyOajFhhSuf+3U+yXiGYdqOjCHIjQxrWCV13bPBdIWD2ZAr4XRyYE+ahxfEnkxjRSJI9PhVK63BKmXdT47T4ijwAYFE03nXZRmaTWZQAiTBWX8fWwTceIShsVpWtBVrLi/p06+HGX+5Tr+/lPKnJuaBGfzjrR04GVgXfdxJC8SrcgBM9bgo/xgC88GBkvTN5OLl7owOYZrWGeIKDZTDVQgDGDJ3QJ41xsOjdEM/cvpStoqRUvCvXSsCH7Yh0/qNu/NpVD+f/JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAalj1SfgdRviESXHxYFGTZ2fKZ5+vPge7wml6icgJE=;
 b=bkDeC0zt6Q5ilVOFrJb7VsS7fzUkX/SAx9f6yuoyd19E5ZSV4HVIV6ufv8eS4hwC/Hqzet2BbrlSvridqA0Y/nTpsX2dgmNsOdHKuEwP+MIOhrcBPdcC8fbuHxWIqlG1ZiSbRaOhIrlkeqAAC7A/EjKCUoR51gUH3q1QLsYab/4=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2429.namprd12.prod.outlook.com (2603:10b6:802:26::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Fri, 11 Sep
 2020 19:29:07 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 19:29:07 +0000
Subject: [PATCH v6 10/12] KVM: X86: Rename and move the function
 vmx_handle_memory_failure to x86.c
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Fri, 11 Sep 2020 14:29:05 -0500
Message-ID: <159985254493.11252.6603092560732507607.stgit@bmoger-ubuntu>
In-Reply-To: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR12CA0055.namprd12.prod.outlook.com
 (2603:10b6:3:103::17) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR12CA0055.namprd12.prod.outlook.com (2603:10b6:3:103::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Fri, 11 Sep 2020 19:29:05 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d2075ebc-91d9-4778-e970-08d85688f325
X-MS-TrafficTypeDiagnostic: SN1PR12MB2429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2429EE758E276DB2349BD07695240@SN1PR12MB2429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hgCh3QgvYbJULpbrjGe9ycWFu8JT/Sj2AWPAKQQCZ2AZBkkTiPPR5EpGXxnTAEF+L5FGCcvet5xtT0IUx7HbUaDdFWFjZ7v9dOnQaZELhwGancFUje+/M3dGwalehyL+XmqliAKrWm0QGVm3FIN6N/pYnxkWdxSX/C/9Ihe/dVgQ8dopNukGGETksMJgLrbpvwCMNpiuNn4hgkesOxL0LeumohuAvOPczFRGlfJKfFvCQEHsDX+U/PpC6/j1jdAU40tYg/PyJUhWtf/n1VycpglujiD1KMPhRe4IxGS8eblStQs2AwZZSMUSdeDWWHgZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(8676002)(8936002)(4326008)(478600001)(316002)(7416002)(16576012)(2906002)(6486002)(44832011)(956004)(9686003)(5660300002)(66556008)(66476007)(66946007)(33716001)(83380400001)(26005)(16526019)(103116003)(52116002)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wi151IewAyqDVg949CO6MK2GhRnhoMKz49qxnL9KWEwjfjL2rn2AslcHNsjlI8MKE9UqKoK0RLY/04PHNg7QIW0jszNHtiLCN4tIcIdB/q1d4972X9q98TglieVA4lMN202DblPD6SstXozh4qiVO9qHTV2ORg/NT1RLhMJLolQIO4k+mR57buRtXRbBtuj06vFsFYt6ZeVBP3/jzIIYZfsDWuapGv0CgtU6Mx86Vl7vvMxIieVyUu984/Yn1BJ+P+W/po2QmetGWQmgyjQrMwFnQeH/gBFNAJWU3B3zalZefKxvPnjQ0aH7JvM9XHlSCJbaYbc8UEOCacm/IvXsJ50Ax41KtV3yqG/vpckNBevJdihs8tBafH6qL6ge3ZMrbQEeHsnF9xKxvmLdxcRYCgZVXx7TdftDmDns5bQJQE66NjROCpBTy9HRAS85pPeSVDyUpdCBpZ2BORQ3S3yMwmLkicGn2qha8UcXI7FkXFk9Gb5ioKQfBSvczj81HPocVO3itAl7qqh0SypfGSH3tYy+vyIMzyCECeHjmE6Wt+TEundHAQxLMCw15ZWFAooA08MXP+v3aVpSZryRiGmx3sgOdaQxIEH99u0WEiPzwMDmKM2wmH41UE8UTiS16wi79pJp98nHkSBa4cwc1U4+CA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2075ebc-91d9-4778-e970-08d85688f325
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 19:29:06.9093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y1NZizZlRuR1QAhRinC76ybTSeeovlm9YeO6KpOStoAXe8vuy0SIoQGA0MiwPEH9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2429
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handling of kvm_read/write_guest_virt*() errors can be moved to common
code. The same code can be used by both VMX and SVM.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/nested.c |   12 ++++++------
 arch/x86/kvm/vmx/vmx.c    |   29 +----------------------------
 arch/x86/kvm/vmx/vmx.h    |    2 --
 arch/x86/kvm/x86.c        |   28 ++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h        |    2 ++
 5 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 23b58c28a1c9..28becd22d9d9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4688,7 +4688,7 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer,
 
 	r = kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e);
 	if (r != X86EMUL_CONTINUE) {
-		*ret = vmx_handle_memory_failure(vcpu, r, &e);
+		*ret = kvm_handle_memory_failure(vcpu, r, &e);
 		return -EINVAL;
 	}
 
@@ -4995,7 +4995,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
 		r = kvm_write_guest_virt_system(vcpu, gva, &value, len, &e);
 		if (r != X86EMUL_CONTINUE)
-			return vmx_handle_memory_failure(vcpu, r, &e);
+			return kvm_handle_memory_failure(vcpu, r, &e);
 	}
 
 	return nested_vmx_succeed(vcpu);
@@ -5068,7 +5068,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 			return 1;
 		r = kvm_read_guest_virt(vcpu, gva, &value, len, &e);
 		if (r != X86EMUL_CONTINUE)
-			return vmx_handle_memory_failure(vcpu, r, &e);
+			return kvm_handle_memory_failure(vcpu, r, &e);
 	}
 
 	field = kvm_register_readl(vcpu, (((instr_info) >> 28) & 0xf));
@@ -5230,7 +5230,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	r = kvm_write_guest_virt_system(vcpu, gva, (void *)&current_vmptr,
 					sizeof(gpa_t), &e);
 	if (r != X86EMUL_CONTINUE)
-		return vmx_handle_memory_failure(vcpu, r, &e);
+		return kvm_handle_memory_failure(vcpu, r, &e);
 
 	return nested_vmx_succeed(vcpu);
 }
@@ -5283,7 +5283,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 		return 1;
 	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
 	if (r != X86EMUL_CONTINUE)
-		return vmx_handle_memory_failure(vcpu, r, &e);
+		return kvm_handle_memory_failure(vcpu, r, &e);
 
 	/*
 	 * Nested EPT roots are always held through guest_mmu,
@@ -5365,7 +5365,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		return 1;
 	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
 	if (r != X86EMUL_CONTINUE)
-		return vmx_handle_memory_failure(vcpu, r, &e);
+		return kvm_handle_memory_failure(vcpu, r, &e);
 
 	if (operand.vpid >> 16)
 		return nested_vmx_fail(vcpu,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 46ba2e03a892..b15b4c6e3b46 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1598,33 +1598,6 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-/*
- * Handles kvm_read/write_guest_virt*() result and either injects #PF or returns
- * KVM_EXIT_INTERNAL_ERROR for cases not currently handled by KVM. Return value
- * indicates whether exit to userspace is needed.
- */
-int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
-			      struct x86_exception *e)
-{
-	if (r == X86EMUL_PROPAGATE_FAULT) {
-		kvm_inject_emulated_page_fault(vcpu, e);
-		return 1;
-	}
-
-	/*
-	 * In case kvm_read/write_guest_virt*() failed with X86EMUL_IO_NEEDED
-	 * while handling a VMX instruction KVM could've handled the request
-	 * correctly by exiting to userspace and performing I/O but there
-	 * doesn't seem to be a real use-case behind such requests, just return
-	 * KVM_EXIT_INTERNAL_ERROR for now.
-	 */
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	vcpu->run->internal.ndata = 0;
-
-	return 0;
-}
-
 /*
  * Recognizes a pending MTF VM-exit and records the nested state for later
  * delivery.
@@ -5558,7 +5531,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 
 	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
 	if (r != X86EMUL_CONTINUE)
-		return vmx_handle_memory_failure(vcpu, r, &e);
+		return kvm_handle_memory_failure(vcpu, r, &e);
 
 	if (operand.pcid >> 12 != 0) {
 		kvm_inject_gp(vcpu, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 26175a4759fa..7c578564a8fc 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -354,8 +354,6 @@ struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
-int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
-			      struct x86_exception *e);
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 539ea1cd6020..5d7930ecdddc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10763,6 +10763,34 @@ void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_c
 }
 EXPORT_SYMBOL_GPL(kvm_fixup_and_inject_pf_error);
 
+/*
+ * Handles kvm_read/write_guest_virt*() result and either injects #PF or returns
+ * KVM_EXIT_INTERNAL_ERROR for cases not currently handled by KVM. Return value
+ * indicates whether exit to userspace is needed.
+ */
+int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
+			      struct x86_exception *e)
+{
+	if (r == X86EMUL_PROPAGATE_FAULT) {
+		kvm_inject_emulated_page_fault(vcpu, e);
+		return 1;
+	}
+
+	/*
+	 * In case kvm_read/write_guest_virt*() failed with X86EMUL_IO_NEEDED
+	 * while handling a VMX instruction KVM could've handled the request
+	 * correctly by exiting to userspace and performing I/O but there
+	 * doesn't seem to be a real use-case behind such requests, just return
+	 * KVM_EXIT_INTERNAL_ERROR for now.
+	 */
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+	vcpu->run->internal.ndata = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_handle_memory_failure);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 995ab696dcf0..d3a41144eb30 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -372,6 +372,8 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
 int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
+int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
+			      struct x86_exception *e);
 
 #define  KVM_MSR_RET_INVALID  2
 

