Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C3F4D5BFF
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 08:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347130AbiCKHFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 02:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347082AbiCKHEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 02:04:53 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B824B9F6E7;
        Thu, 10 Mar 2022 23:03:49 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id cx5so7412812pjb.1;
        Thu, 10 Mar 2022 23:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PHRKmoOpdVOx/pR8qbguqjvyNTEJ3bXLgyEzmCfW7IA=;
        b=Pd3JO5VGOU2LL2nfJBODpe5Kb7ywmPlHuJyMwgjRY7zfioOnLHaaLCPYMAscrN721N
         2YTNfENdSdRF4Bbeh9N8C4BkdLQWT41VZySTLF/8ZdJA3DpyxU2znAxioIkWwaqHocG7
         SQQI1+R1KEOwY9O2DpOX7omMZ6jHaGdIdGM+bNEKrbfcRuankTzp9CAlsAaniznJaZ6P
         Wtpop2DMtSaRQ3xtaTmZvWrKQ2HQh6Da17nIOjG440XbOKyKf8eM9uQzfQYBv4s4wzgn
         QQ6WwESy9R4jO76fBQmFc/Y/UWNvQxekuja8WHT0qHWhYJ6Azw8m969xDe0v3wcIBpVd
         78lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PHRKmoOpdVOx/pR8qbguqjvyNTEJ3bXLgyEzmCfW7IA=;
        b=hwt7EA7S23GGHaTgzpYLBpEG5EcUj1/9B2gm4WanCQbTfvKVvIIIxonbQlApUO6TAB
         L9ddruW6n2sujWnXXxNvfWwXJ1JW3aT1SH2kSfEvm9bNRosShIIdaX0EthkboZu2shzS
         Vg5TwYclvgud+EHU7p8x6IcaatJS74g9klBbJXlrDgzsDL39rzoDBD7ESFPpbYdn1hNH
         IV6U/YsYcwe8TGT852ufRG9L2oy3ljx9MFw4AFM4VPIAb4db3Rf0OcDDqyoAg1+DcoXH
         UeNvSsmjMtnpYkNNdbjwPDiB603v2HjK/Ln8BoJGG2s2KhK4GESDSfb92b2ikLdb+QtV
         1sCg==
X-Gm-Message-State: AOAM530Ls+t+FKdl+QAnyZUIhP2yUbXgCCbRbwy9shbSwtRjiamkfNGr
        yw0psSWRoQdVtij0fTUGxPANrFqtexY=
X-Google-Smtp-Source: ABdhPJyu0YmUGsKJEy4FIXKekCurj/9SpISDUGXFi1BJpgO2rJUHXpvF77AnKkOEC1rhChsQZP7aeA==
X-Received: by 2002:a17:902:e547:b0:151:c5d5:a2c4 with SMTP id n7-20020a170902e54700b00151c5d5a2c4mr8948614plf.78.1646982228999;
        Thu, 10 Mar 2022 23:03:48 -0800 (PST)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm10019818pfu.202.2022.03.10.23.03.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Mar 2022 23:03:48 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH V2 6/5] KVM: X86: Propagate the nested page fault info to the guest
Date:   Fri, 11 Mar 2022 15:03:46 +0800
Message-Id: <20220311070346.45023-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220311070346.45023-1-jiangshanlai@gmail.com>
References: <20220311070346.45023-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Feed the nested page fault info into ->gva_to_gpa() in
walk_addr_generic(), so that the nested walk_addr_generic() can
propagate the nested page fault info into x86_exception.

Propagate the nested page fault info into EXIT_INFO_1 for SVM.

Morph the nested page fault info and other page fault error code into
EXIT_QUOLIFICATION for VMX.

It is a patch that makes use of the patch1.

It is untested, just served as a request for somebody to fix a known
problem, and will not be included in next version of this patchset
if the patchset needs to be updated.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/kvm_emulate.h      |  3 ++-
 arch/x86/kvm/mmu/paging_tmpl.h  |  8 ++++++--
 arch/x86/kvm/svm/nested.c       | 10 ++--------
 arch/x86/kvm/vmx/nested.c       | 11 +++++++++++
 5 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 565d9eb42429..68efa9d1ef0e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -265,6 +265,8 @@ enum x86_intercept_stage;
 				 PFERR_WRITE_MASK |		\
 				 PFERR_PRESENT_MASK)
 
+#define PFERR_GUEST_MASK (PFERR_GUEST_FINAL_MASK | PFERR_GUEST_PAGE_MASK)
+
 /* apic attention bits */
 #define KVM_APIC_CHECK_VAPIC	0
 /*
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 39eded2426ff..cdc2977ce086 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -24,8 +24,9 @@ struct x86_exception {
 	bool error_code_valid;
 	u16 error_code;
 	bool nested_page_fault;
-	u64 address; /* cr2 or nested page fault gpa */
 	u8 async_page_fault;
+	u64 nested_pfec; /* nested page fault error code */
+	u64 address; /* cr2 or nested page fault gpa */
 };
 
 /*
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 8621188b46df..95367f5ca998 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -383,7 +383,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	 * by the MOV to CR instruction are treated as reads and do not cause the
 	 * processor to set the dirty flag in any EPT paging-structure entry.
 	 */
-	nested_access = (have_ad ? PFERR_WRITE_MASK : 0) | PFERR_USER_MASK;
+	nested_access = (have_ad ? PFERR_WRITE_MASK : 0) | PFERR_USER_MASK |
+			PFERR_GUEST_PAGE_MASK;
 
 	pte_access = ~0;
 	++walker->level;
@@ -466,7 +467,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	if (PTTYPE == 32 && walker->level > PG_LEVEL_4K && is_cpuid_PSE36())
 		gfn += pse36_gfn_delta(pte);
 
-	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(gfn), access, &walker->fault);
+	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(gfn),
+			access | PFERR_GUEST_FINAL_MASK, &walker->fault);
 	if (real_gpa == UNMAPPED_GVA)
 		return 0;
 
@@ -534,6 +536,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	walker->fault.address = addr;
 	walker->fault.nested_page_fault = mmu != vcpu->arch.walk_mmu;
 	walker->fault.async_page_fault = false;
+	if (walker->fault.nested_page_fault)
+		walker->fault.nested_pfec = errcode | (access & PFERR_GUEST_MASK);
 
 	trace_kvm_mmu_walker_error(walker->fault.error_code);
 	return 0;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 96bab464967f..0abcbd3de892 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -38,18 +38,12 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (svm->vmcb->control.exit_code != SVM_EXIT_NPF) {
-		/*
-		 * TODO: track the cause of the nested page fault, and
-		 * correctly fill in the high bits of exit_info_1.
-		 */
 		svm->vmcb->control.exit_code = SVM_EXIT_NPF;
 		svm->vmcb->control.exit_code_hi = 0;
-		svm->vmcb->control.exit_info_1 = (1ULL << 32);
-		svm->vmcb->control.exit_info_2 = fault->address;
 	}
 
-	svm->vmcb->control.exit_info_1 &= ~0xffffffffULL;
-	svm->vmcb->control.exit_info_1 |= fault->error_code;
+	svm->vmcb->control.exit_info_1 = fault->nested_pfec;
+	svm->vmcb->control.exit_info_2 = fault->address;
 
 	nested_svm_vmexit(svm);
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1dfe23963a9e..fd5dd5acf63b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -372,6 +372,17 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 	u32 vm_exit_reason;
 	unsigned long exit_qualification = vcpu->arch.exit_qualification;
 
+	exit_qualification &= ~(EPT_VIOLATION_ACC_READ | EPT_VIOLATION_ACC_WRITE |
+				EPT_VIOLATION_ACC_INSTR | EPT_VIOLATION_GVA_TRANSLATED);
+	exit_qualification |= fault->nested_pfec & PFERR_USER_MASK ?
+				EPT_VIOLATION_ACC_READ : 0;
+	exit_qualification |= fault->nested_pfec & PFERR_WRITE_MASK ?
+				EPT_VIOLATION_ACC_WRITE : 0;
+	exit_qualification |= fault->nested_pfec & PFERR_FETCH_MASK ?
+				EPT_VIOLATION_ACC_INSTR : 0;
+	exit_qualification |= fault->nested_pfec & PFERR_GUEST_FINAL_MASK ?
+				EPT_VIOLATION_GVA_TRANSLATED : 0;
+
 	if (vmx->nested.pml_full) {
 		vm_exit_reason = EXIT_REASON_PML_FULL;
 		vmx->nested.pml_full = false;
-- 
2.19.1.6.gb485710b

