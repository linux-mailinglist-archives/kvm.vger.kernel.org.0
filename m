Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26D745C41B
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351302AbhKXNp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350796AbhKXNms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:42:48 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C16C0698C9;
        Wed, 24 Nov 2021 04:21:19 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id gt5so2412290pjb.1;
        Wed, 24 Nov 2021 04:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zwl/Rbup822GR7YknsUghbLNnM1SIeNYe9VDcXnP+Sk=;
        b=aQXJ83tqf+oMkt0pJY45V/H0zNbd2W+IW38lBMy3FCjlQCVNagPoG2Ng2Lt/qKaXFD
         B9alZHgES9KKYJ/vKqyet7KBsiSj2Jzf4WivUpf/sLa5eUz8A5p4lTF4l4JkbIIVtyl4
         iLSl6pQahW0SxTl3p77pqORO7Th+gfM9gzJLeUIBEYGD5G9m0U9+iXDSlzoiwI+BUD3c
         ej6qag0Sw5FT0/Fm5TDNdPtV/GJGLVXlg8glJ1sZYLyhMjzJYdu+ewok/4Eo6nwSOAN3
         5LqMFA7CyWaH11cGKnBkuBIAuyBUKlzTBDz/q12bg2144YBUdukDNPrQ4ZyLNonBQX54
         cbPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zwl/Rbup822GR7YknsUghbLNnM1SIeNYe9VDcXnP+Sk=;
        b=nR9qhA/rVToZ4rHvrc0JTo6ZI6O71Tzum+/7Mng9EZ2xSE05hNIWnhQwulWTXNhkys
         cjciI4E6T3X1emDZOz128TM1LIXtAlBvQuPaFS7LjqTYa4zGKHMM/Pbt36y8FTUJ/K0W
         DHx2RRwjFZEM2U+DghPv5Gmh7iJEtAUA+HYfKAEzrp6o8DKr1ZmkBENgnJevv2kCAw5Y
         u/TlgSEY7np/7w49kunZ3ZM4eyiHeszBxWcyNMz4fosTHQONWw36E/beb3OsunQVgtQ/
         nPS0PsmkgVDjOU/6nyo+7JQPagURd18r71L/lxlMPylc+j58RTskQLLOxZR5WEP9kf9i
         79ug==
X-Gm-Message-State: AOAM5315BFOtYhqNI1DkAf+AZkJgSfsY4fypjVAa4UGeCjM7tmpEJa+2
        NoRzCQIrIetDySX86SeKM+RLu1p6UwQ=
X-Google-Smtp-Source: ABdhPJylKauCn89iUuD4ycSsbzeFYBxpmBnW1dVi3XnyQM3sB6quaWGlySlwLEHIwj8Ih1uUWmcQRw==
X-Received: by 2002:a17:90a:9bc1:: with SMTP id b1mr14808184pjw.49.1637756478836;
        Wed, 24 Nov 2021 04:21:18 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id mg17sm4594663pjb.17.2021.11.24.04.21.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 04:21:18 -0800 (PST)
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
Subject: [PATCH 03/12] KVM: X86: Remove mmu->translate_gpa
Date:   Wed, 24 Nov 2021 20:20:45 +0800
Message-Id: <20211124122055.64424-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211124122055.64424-1-jiangshanlai@gmail.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Reduce an indirect function call (retpoline) and some intialization
code.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ----
 arch/x86/kvm/mmu.h              | 13 +++++++++++++
 arch/x86/kvm/mmu/mmu.c          | 11 +----------
 arch/x86/kvm/mmu/paging_tmpl.h  |  7 +++----
 arch/x86/kvm/x86.c              |  4 ++--
 5 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8419aff7136f..dd16fdedc0e8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -429,8 +429,6 @@ struct kvm_mmu {
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gpa_t gva_or_gpa, u32 access,
 			    struct x86_exception *exception);
-	gpa_t (*translate_gpa)(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
-			       struct x86_exception *exception);
 	int (*sync_page)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
@@ -1764,8 +1762,6 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
 void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			ulong roots_to_free);
 void kvm_mmu_free_guest_mode_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu);
-gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
-			   struct x86_exception *exception);
 gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 			      struct x86_exception *exception);
 gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9ae6168d381e..97e13c2988b3 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -351,4 +351,17 @@ static inline void kvm_update_page_stats(struct kvm *kvm, int level, int count)
 {
 	atomic64_add(count, &kvm->stat.pages[level - 1]);
 }
+
+gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
+			   struct x86_exception *exception);
+
+static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
+				      struct kvm_mmu *mmu,
+				      gpa_t gpa, u32 access,
+				      struct x86_exception *exception)
+{
+	if (mmu != &vcpu->arch.nested_mmu)
+		return gpa;
+	return translate_nested_gpa(vcpu, gpa, access, exception);
+}
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3e00a54e23b6..f3aa91db4a7e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -335,12 +335,6 @@ static bool check_mmio_spte(struct kvm_vcpu *vcpu, u64 spte)
 	return likely(kvm_gen == spte_gen);
 }
 
-static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
-                                  struct x86_exception *exception)
-{
-        return gpa;
-}
-
 static int is_cpuid_PSE36(void)
 {
 	return 1;
@@ -3734,7 +3728,7 @@ static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 {
 	if (exception)
 		exception->error_code = 0;
-	return mmu->translate_gpa(vcpu, vaddr, access, exception);
+	return kvm_translate_gpa(vcpu, mmu, vaddr, access, exception);
 }
 
 static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
@@ -5487,7 +5481,6 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 
 	mmu->root_hpa = INVALID_PAGE;
 	mmu->root_pgd = 0;
-	mmu->translate_gpa = translate_gpa;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
@@ -5549,8 +5542,6 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
-	vcpu->arch.nested_mmu.translate_gpa = translate_nested_gpa;
-
 	ret = __kvm_mmu_create(vcpu, &vcpu->arch.guest_mmu);
 	if (ret)
 		return ret;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4e203fe703b0..5c78300fc7d9 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -403,9 +403,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		walker->table_gfn[walker->level - 1] = table_gfn;
 		walker->pte_gpa[walker->level - 1] = pte_gpa;
 
-		real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(table_gfn),
-					      nested_access,
-					      &walker->fault);
+		real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(table_gfn),
+					     nested_access, &walker->fault);
 
 		/*
 		 * FIXME: This can happen if emulation (for of an INS/OUTS
@@ -467,7 +466,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	if (PTTYPE == 32 && walker->level > PG_LEVEL_4K && is_cpuid_PSE36())
 		gfn += pse36_gfn_delta(pte);
 
-	real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(gfn), access, &walker->fault);
+	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(gfn), access, &walker->fault);
 	if (real_gpa == UNMAPPED_GVA)
 		return 0;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 808786677b2b..25e278ba4666 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -810,8 +810,8 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 	 * If the MMU is nested, CR3 holds an L2 GPA and needs to be translated
 	 * to an L1 GPA.
 	 */
-	real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(pdpt_gfn),
-				      PFERR_USER_MASK | PFERR_WRITE_MASK, NULL);
+	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(pdpt_gfn),
+				     PFERR_USER_MASK | PFERR_WRITE_MASK, NULL);
 	if (real_gpa == UNMAPPED_GVA)
 		return 0;
 
-- 
2.19.1.6.gb485710b

