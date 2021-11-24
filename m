Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CEF45C41F
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351317AbhKXNpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350956AbhKXNmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:42:54 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66993C0698CB;
        Wed, 24 Nov 2021 04:21:31 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id x7so2436706pjn.0;
        Wed, 24 Nov 2021 04:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nx8naYJh1ipVWYX82CVY7+oRo59tsyYL0AYDD5FQuD8=;
        b=bJvWtl9spXUR44uhEAcvEFd4KD/+FY8lHL2R21lS2lCAN0Ifj2DtUkvn3/GLjn9twJ
         lNd1tyfLCxwkkipp3plp2JJx4cJH6mQVOdYxnZxQD0+/nzxxYgcnjsm36MN/hFIpXQRt
         skA7eVII80U+5HYRMcLjYA1P3iXGxMfohmW1D+iYbsKwHK/L0WYfF0+h2FMNPQcLzSlW
         BXIIfrXwWgWBF8hvRA2srQ1VEJhXWWcKTwA57R70a6uBOcAwXmvZN3ptQRF44FUtW4/p
         T4urWKAXtB9Qb674tl3tDdWs4l2KUi6nnL0/eYM+8OYLki+OOmn1zSxToiQbmWorJiMQ
         khdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nx8naYJh1ipVWYX82CVY7+oRo59tsyYL0AYDD5FQuD8=;
        b=iBys+bRbK2+3nNIa7CFujnzy64TGlAz0wMdjYY5t+DB22FADqNiAfLJSwI/7RzL/QB
         iq4Sx2Duy+3sDTvpnvkKT+AiO+w4RO7F6zHDSh0sPzzLU7e7xBB5s9BxzHPMu0q1amdP
         jXlBLdnJOYxaciOdEWrtDvf0FpiQhUYJ9tCm9hdsl6ix/AMNiSsWq6raJ6VdlWXHiiHD
         tZlSBxGrM0ZuZ2nfuI80mU+gHlM4Zi/G/FMCpcpfW2fWMrvyIjA0IKbmVoFe/FQoRkiK
         dA5AKZB8g4N58cBUlvmPp+dCtlvMbt4ynDZ6vbbD9BPkdZJk2cFM+bpQEUqW1f+Sj8Mk
         Aefw==
X-Gm-Message-State: AOAM531+/WslwhOJoEYv/qe/QGvjv5KfLzT67mWwfE90vPjTo0lHMZiT
        ThRz+T0PAGfI26sShzdMN8ge2jLtVRg=
X-Google-Smtp-Source: ABdhPJyhpU94osS6KjkmJ+iOWbepJPJFtWdebfgcKrsgGzYkqdS5e+HkUwMJ11ezX3RQpwOQR2JyBA==
X-Received: by 2002:a17:902:728e:b0:143:a388:868b with SMTP id d14-20020a170902728e00b00143a388868bmr17969637pll.33.1637756490796;
        Wed, 24 Nov 2021 04:21:30 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id mq14sm5267905pjb.54.2021.11.24.04.21.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 04:21:30 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 05/12] KVM: X86: Change the type of a parameter of kvm_mmu_invalidate_gva() and mmu->invlpg() to gpa_t
Date:   Wed, 24 Nov 2021 20:20:47 +0800
Message-Id: <20211124122055.64424-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211124122055.64424-1-jiangshanlai@gmail.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

When kvm_mmu_invalidate_gva() is called for nested TDP, the @gva is L2
GPA, so the type of the parameter should be gpa_t like mmu->gva_to_gpa().

The parameter name is also changed to gva_or_l2pa for self documentation.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++---
 arch/x86/kvm/mmu/mmu.c          | 14 +++++++-------
 arch/x86/kvm/mmu/paging_tmpl.h  |  7 ++++---
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dd16fdedc0e8..e382596baa1d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -427,11 +427,11 @@ struct kvm_mmu {
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
 				  struct x86_exception *fault);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			    gpa_t gva_or_gpa, u32 access,
+			    gpa_t gva_or_l2pa, u32 access,
 			    struct x86_exception *exception);
 	int (*sync_page)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp);
-	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
+	void (*invlpg)(struct kvm_vcpu *vcpu, gpa_t gva_or_l2pa, hpa_t root_hpa);
 	hpa_t root_hpa;
 	gpa_t root_pgd;
 	union kvm_mmu_role mmu_role;
@@ -1785,7 +1785,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			    gva_t gva, hpa_t root_hpa);
+			    gpa_t gva_or_l2pa, hpa_t root_hpa);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 72ce0d78435e..d3bad4ae72fb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5313,24 +5313,24 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
 void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			    gva_t gva, hpa_t root_hpa)
+			    gpa_t gva_or_l2pa, hpa_t root_hpa)
 {
 	int i;
 
-	/* It's actually a GPA for vcpu->arch.guest_mmu.  */
+	/* It's actually a L2 GPA for vcpu->arch.guest_mmu.  */
 	if (mmu != &vcpu->arch.guest_mmu) {
 		/* INVLPG on a non-canonical address is a NOP according to the SDM.  */
-		if (is_noncanonical_address(gva, vcpu))
+		if (is_noncanonical_address(gva_or_l2pa, vcpu))
 			return;
 
-		static_call(kvm_x86_tlb_flush_gva)(vcpu, gva);
+		static_call(kvm_x86_tlb_flush_gva)(vcpu, gva_or_l2pa);
 	}
 
 	if (!mmu->invlpg)
 		return;
 
 	if (root_hpa == INVALID_PAGE) {
-		mmu->invlpg(vcpu, gva, mmu->root_hpa);
+		mmu->invlpg(vcpu, gva_or_l2pa, mmu->root_hpa);
 
 		/*
 		 * INVLPG is required to invalidate any global mappings for the VA,
@@ -5345,9 +5345,9 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		 */
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 			if (VALID_PAGE(mmu->prev_roots[i].hpa))
-				mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
+				mmu->invlpg(vcpu, gva_or_l2pa, mmu->prev_roots[i].hpa);
 	} else {
-		mmu->invlpg(vcpu, gva, root_hpa);
+		mmu->invlpg(vcpu, gva_or_l2pa, root_hpa);
 	}
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5c78300fc7d9..7b86209e73f9 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -928,7 +928,8 @@ static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
 	return gfn_to_gpa(sp->gfn) + offset * sizeof(pt_element_t);
 }
 
-static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
+/* Note, @gva_or_l2pa is a GPA when invlpg() invalidates an L2 GPA. */
+static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gpa_t gva_or_l2pa, hpa_t root_hpa)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
@@ -936,7 +937,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 	int level;
 	u64 *sptep;
 
-	vcpu_clear_mmio_info(vcpu, gva);
+	vcpu_clear_mmio_info(vcpu, gva_or_l2pa);
 
 	/*
 	 * No need to check return value here, rmap_can_add() can
@@ -950,7 +951,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 	}
 
 	write_lock(&vcpu->kvm->mmu_lock);
-	for_each_shadow_entry_using_root(vcpu, root_hpa, gva, iterator) {
+	for_each_shadow_entry_using_root(vcpu, root_hpa, gva_or_l2pa, iterator) {
 		level = iterator.level;
 		sptep = iterator.sptep;
 
-- 
2.19.1.6.gb485710b

