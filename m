Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8454325380D
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgHZTPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:15:44 -0400
Received: from mail-co1nam11on2076.outbound.protection.outlook.com ([40.107.220.76]:57728
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727017AbgHZTPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:15:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhLhBybPDM3oiYajdObGZvj2zY35K03trf6fmpK/U+zO4N5zBjrS/HVSCf4CpbZO/pLAvqs1jMwNJl9R4ZVixomCGFkWKeIupJN6uMsG9N6U+Vy1uNupYy3Hce62xFZHGlZMS5D++L5wMlNEOfUlKm9YK+owiKWaPB736xrZglW2nfEgpgbXfLpMo4xqeHlQEUD7bfPRPpTvp8ujlw4BldML4W52iPuxvOuZIVSUE3Ger8T8o6rtjGKcSobat3QZtWdxBWlcJWNchiTyoVj2LsIimYNekGxFKjmU4zxnR064TeJp18s2RWZF353w8N1yPd5Dn7ZJ8G4rhyGohe6o+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2VobKazc2SHtgQtsnoWiyopnSb2d9K5GeJXr0aX2eQ=;
 b=XsKqi/HpGfkjyRjqlwnSQj4sOos/lskLL+WzRzGWiosDrKX3d0aCQZJ764asTXDYMpLYhdAtwQcEpFuxKsPaflU00oajCpWcvpWYpZohT7EH4fMwpwOPkM/av7NP+zftY8CenSsVwGIKzF0J9mebD5YpViaj7w/nY5MwTC7xbMNc93HWf/zzQZq25EkUN5iwMK/Ci2mDPxvgU5EL4+8gcsiNr7Ta9J/NTrSpzqkKLrKKm5UPCdNam70RdbTChPUliQxlqfL6sG2LU8FgLumcvYTzr7BnTXlkn4fSTpwfAt0VBqZEbtOZoKPskLtGz81wo6SlDUGlEhQ+Q7BIfmV1RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2VobKazc2SHtgQtsnoWiyopnSb2d9K5GeJXr0aX2eQ=;
 b=D84YzPd2564QMJ/Mk9DpcsRaLHJqzF5aDFc0/noeKpHpYEkec29wKDhwKmSw+6EC2zEhsoP1oQtiUl1IS5biUZHwGwdY4lY21oRkz35EBGuNP2Q8TaYsxTJMyHa0TVJC8w7NP60D3RIpsK/y5K7UMWn8nbn3Hb0/UpGepaJvqJw=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2384.namprd12.prod.outlook.com (2603:10b6:802:25::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Wed, 26 Aug
 2020 19:15:04 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 19:15:04 +0000
Subject: [PATCH v5 10/12] KVM: X86: Rename and move the function
 vmx_handle_memory_failure to x86.c
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Wed, 26 Aug 2020 14:15:01 -0500
Message-ID: <159846930119.18873.955266273208700176.stgit@bmoger-ubuntu>
In-Reply-To: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR04CA0059.namprd04.prod.outlook.com
 (2603:10b6:3:ef::21) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM5PR04CA0059.namprd04.prod.outlook.com (2603:10b6:3:ef::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 19:15:02 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8bb44841-fa82-49e5-8892-08d849f455ee
X-MS-TrafficTypeDiagnostic: SN1PR12MB2384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23847EBFA5CCFD06C200DF3195540@SN1PR12MB2384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X69pOGsfDArRPp+CkK16Dv4SZ0jtYaVA3lI/pnkgpJOAxYfWAchmGJuPusj5hsYUTeczdNPZflXwImmfp+dyK1pfs+Ltsy3fjKZcyCYGqvYB2/6yEOfPzbrrivQipLqvfv/VsxID0bQUCHlvDCLBUZHnVWn5HnXq2TJQXbltFtAHPWKqtM3XFUnIS43tiqKNBA46WkOpfkPnOOkTPUkt4GUlaktznv8qtsUw0NRD47XN94EaQF3R4d7NXUKZJPt/IeLV5aUxqeBJjvG+fjwoRhorPHlDqzED6P/GzCFfzFPE7qRRGWqpM4Isv5snhowo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(366004)(136003)(376002)(396003)(39860400002)(103116003)(4326008)(186003)(66946007)(5660300002)(66476007)(66556008)(44832011)(86362001)(33716001)(9686003)(52116002)(7416002)(83380400001)(6486002)(8936002)(8676002)(16576012)(2906002)(316002)(26005)(478600001)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VjfAxk/139XVMgqHm7nHbvHByy/gVOOwVMmm0SOtgF28iPRItWkXUME8Zx0lgM2EinR4YMGU1GYo3RugkrBTph8v5WLxHPcOQZDo9FuZHityiDZrg+26+KTeDZIHCMUZjQUwxaz0tphLO1howbknkRkGMDNuihvL4BdonQVSy7KafSvVQCTUHQCRD41xf90SOrRDphSkyOfx9BVQja0F8vdy8/RETd0k7jiCAzHFHlg+AZr10NnIZWOEhOcaHg8LK/aZ7as12Fufd6bRmIDkwaNMRkEGetnQSJpiOC3sNosk6kuQa7qoihpTdmsf/3Uzk/Vt+JqJsVCQyMK7LYG9FEmQG5VCptCOVduu077tuHgwpmK3w2Nsx74vCRELKpLtnTXHWWUVNklywNFo62vmVG80INhWKlUkACR1brT0G/wMF7wCkT+Inee+sLWZQ1JYsBEdXm2fLCIvGgM+sEjNcXj+XxHhksKCFJAuy8QMb9k6dLnQiB3uHAaQoRZ22xDMF2dxKXvdA2WkR0/mPh713566+Ha6IzQ4LIHwn1TCf3/o5PImyrYgRyyI0t5NsdKx8wFAp/rg13WChv/5DI8uizH16jbYHG3aAqlYWkRYC4PCR8gDp0aCDhDZ5bwsM9pX1Dv8AUaQGfn1UGiP4d9bkA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb44841-fa82-49e5-8892-08d849f455ee
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:15:04.1185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IzjSIZPJMvahdCpi3gIzmZIvCn1a95femRo86o1KqnQCS9cRnUxlcUPZscsOyI6g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2384
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handling of kvm_read/write_guest_virt*() errors can be moved to common
code. The same code can be used by both VMX and SVM.

Signed-off-by: Babu Moger <babu.moger@amd.com>
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
 

