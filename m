Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E5369990D
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 16:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjBPPkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 10:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjBPPkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 10:40:18 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218A15454A;
        Thu, 16 Feb 2023 07:40:17 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id w20-20020a17090a8a1400b00233d7314c1cso6216058pjn.5;
        Thu, 16 Feb 2023 07:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HCcOcMkEq2Tra6a8d/G0i2aHL53mXB3M74OOhM//0hw=;
        b=MR03P9Ev0arYYfiMp0Ecem9iF8DiVJK7R70dT4rfGye+RWsDz5i84NmZNDlvQlrEVU
         sbHSNPTG9SHVVSRW2CcRykuciW7B5dcOMeNc915lPRQ1xto3e6nFLpVVqvWEn2BRJAPA
         f40qQM6/4bOe+3p6D5+FPdzyrz+m841w7eGrnQaRXSI0V/G4clTxFTQzKX8+U2vqkIjW
         cuwlYM8Eu+CG0Dq7Lv3OYFEOu83i5b7gsOACC3Bk+Ouuc1bktIX83Oxih42b/Nj+ff0s
         dugPoR2AbZDVWPiuY/OezRhTAPj9IeU7XkpAmjnFSsrCFfx7lSVsYcZUi++EXNsoC0e6
         CNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HCcOcMkEq2Tra6a8d/G0i2aHL53mXB3M74OOhM//0hw=;
        b=e3dM/HtJev+i/6HJ5AuqBX/fhO+gf4FY40zpo/UchzOhafR/likDVygdeUkv0J6Awm
         pGc0Pwi5xr/jI2fzlzPIkd3QKDsYkeAJuEXk2tYsJbNVX+/hWc+LNrlpOPxsl4EnBg1k
         Iu3VKgYndPRrnue3FO2okSlnDhKndyB+JdOVEuhRUD+TcDmkWFxL6eIlqHn6cj9PMjXL
         sgfLAIs9CFG5wTGZ9eG1pBBouOKilqKxOwyqomv+J4zEcGxRuaqHkLzUSo1gznUpbKR/
         KVzI/Tu4WvA10gQZrTdyaIpbXvxpWZegmN0gVwt2nN4OUOowYVIYi6THyIN17OGRbbOQ
         iFYw==
X-Gm-Message-State: AO0yUKXhLhdhp1M1UNxpsylSk0lu/F7DmwAU7dUIqydiiL7PYSQJXzC1
        TVpLW2E5uWkPLKe2ZBDnX5Dwq9B2D0s=
X-Google-Smtp-Source: AK7set/sVIUcEP5xuW10815z34yMBhvqfia0L6hUetjA98un5/aBkot42GLz5S787/RyAFrbCevJ3w==
X-Received: by 2002:a17:902:fa0c:b0:199:11c3:cc4f with SMTP id la12-20020a170902fa0c00b0019911c3cc4fmr5606272plb.44.1676562016256;
        Thu, 16 Feb 2023 07:40:16 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id f30-20020a63755e000000b004fb11a7f2d4sm1341772pgn.57.2023.02.16.07.40.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 07:40:15 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 01/14] KVM: x86/mmu: Use 64-bit address to invalidate to fix a subtle bug
Date:   Thu, 16 Feb 2023 23:41:07 +0800
Message-Id: <20230216154115.710033-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230216154115.710033-1-jiangshanlai@gmail.com>
References: <20230216154115.710033-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

FNAME(invlpg)() and kvm_mmu_invalidate_gva() take a gva_t,
i.e. unsigned long, as the type of the address to invalidate.
On 32-bit kernels, the upper 32 bits of the GPA will get dropped when
an L2 GPA address is to invalidate in the shadowed TDP MMU.

Convert it to u64 to fix the problem.

Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++---
 arch/x86/kvm/mmu/mmu.c          | 16 ++++++++--------
 arch/x86/kvm/mmu/paging_tmpl.h  |  7 ++++---
 arch/x86/kvm/x86.c              |  4 ++--
 4 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4d2bc08794e4..5466f4152c67 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -443,7 +443,7 @@ struct kvm_mmu {
 			    struct x86_exception *exception);
 	int (*sync_page)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp);
-	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
+	void (*invlpg)(struct kvm_vcpu *vcpu, u64 addr, hpa_t root_hpa);
 	struct kvm_mmu_root_info root;
 	union kvm_cpu_role cpu_role;
 	union kvm_mmu_page_role root_role;
@@ -2025,8 +2025,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
-void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			    gva_t gva, hpa_t root_hpa);
+void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			     u64 addr, hpa_t root_hpa);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c91ee2927dd7..91f8e1d1d4cc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5706,25 +5706,25 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
-void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			    gva_t gva, hpa_t root_hpa)
+void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			     u64 addr, hpa_t root_hpa)
 {
 	int i;
 
 	/* It's actually a GPA for vcpu->arch.guest_mmu.  */
 	if (mmu != &vcpu->arch.guest_mmu) {
 		/* INVLPG on a non-canonical address is a NOP according to the SDM.  */
-		if (is_noncanonical_address(gva, vcpu))
+		if (is_noncanonical_address(addr, vcpu))
 			return;
 
-		static_call(kvm_x86_flush_tlb_gva)(vcpu, gva);
+		static_call(kvm_x86_flush_tlb_gva)(vcpu, addr);
 	}
 
 	if (!mmu->invlpg)
 		return;
 
 	if (root_hpa == INVALID_PAGE) {
-		mmu->invlpg(vcpu, gva, mmu->root.hpa);
+		mmu->invlpg(vcpu, addr, mmu->root.hpa);
 
 		/*
 		 * INVLPG is required to invalidate any global mappings for the VA,
@@ -5739,15 +5739,15 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		 */
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 			if (VALID_PAGE(mmu->prev_roots[i].hpa))
-				mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
+				mmu->invlpg(vcpu, addr, mmu->prev_roots[i].hpa);
 	} else {
-		mmu->invlpg(vcpu, gva, root_hpa);
+		mmu->invlpg(vcpu, addr, root_hpa);
 	}
 }
 
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	kvm_mmu_invalidate_gva(vcpu, vcpu->arch.walk_mmu, gva, INVALID_PAGE);
+	kvm_mmu_invalidate_addr(vcpu, vcpu->arch.walk_mmu, gva, INVALID_PAGE);
 	++vcpu->stat.invlpg;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 57f0b75c80f9..c7b1de064be5 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -887,7 +887,8 @@ static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
 	return gfn_to_gpa(sp->gfn) + offset * sizeof(pt_element_t);
 }
 
-static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
+/* Note, @addr is a GPA when invlpg() invalidates an L2 GPA translation in shadowed TDP */
+static void FNAME(invlpg)(struct kvm_vcpu *vcpu, u64 addr, hpa_t root_hpa)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
@@ -895,7 +896,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 	int level;
 	u64 *sptep;
 
-	vcpu_clear_mmio_info(vcpu, gva);
+	vcpu_clear_mmio_info(vcpu, addr);
 
 	/*
 	 * No need to check return value here, rmap_can_add() can
@@ -909,7 +910,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 	}
 
 	write_lock(&vcpu->kvm->mmu_lock);
-	for_each_shadow_entry_using_root(vcpu, root_hpa, gva, iterator) {
+	for_each_shadow_entry_using_root(vcpu, root_hpa, addr, iterator) {
 		level = iterator.level;
 		sptep = iterator.sptep;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 508074e47bc0..b9663623c128 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -798,8 +798,8 @@ void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 	 */
 	if ((fault->error_code & PFERR_PRESENT_MASK) &&
 	    !(fault->error_code & PFERR_RSVD_MASK))
-		kvm_mmu_invalidate_gva(vcpu, fault_mmu, fault->address,
-				       fault_mmu->root.hpa);
+		kvm_mmu_invalidate_addr(vcpu, fault_mmu, fault->address,
+					fault_mmu->root.hpa);
 
 	fault_mmu->inject_page_fault(vcpu, fault);
 }
-- 
2.19.1.6.gb485710b

