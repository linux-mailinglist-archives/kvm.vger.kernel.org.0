Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659BD41027B
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 02:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245353AbhIRA6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 20:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344073AbhIRA6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 20:58:38 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85053C0613D3;
        Fri, 17 Sep 2021 17:57:13 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so11184043pjc.3;
        Fri, 17 Sep 2021 17:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZA+x0Dr9VRAZpjOgKU8m5Fy4ryA8YwDPMh/59d87rIQ=;
        b=Pf02RchtREYyPG4gVATQkoNjuESuDWsTsFb3wsI8eMBOFeC41QGmatvUeRPaflK5PC
         cSntiSwdTPlbq9CYwwV5yWcRRV8/Z/5z5bODBzcWBDrmtoBWp2BAiiPZFmbxx5LJsnhN
         4ufOOD0yftUS/FKLAXkkjWSFf4cWdKU3Guoi2oxBRvMCotKqqi30R3/JwOrA+Nrdi4Vb
         b6QMUE90Y+6cU1aAFAYJk/rTElpJ+LaDj+qFyzJpUbqrDjtxH5YgBVwQGZrOEJ8lRxW1
         9EhKDD++3nJP4e3CNOW3FZmaHv9ctB7wvYfOdn5qufCsKOWEfB4CGzjKIxIkCjy/uBwU
         st3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZA+x0Dr9VRAZpjOgKU8m5Fy4ryA8YwDPMh/59d87rIQ=;
        b=T2nYLq8AQhbyhN/MhW9/i8/e78NuyidSg3qtyuatFckGLHspvtRkaxdeDZZRLaDjuk
         eaV2F2cJgQBNLUnB62rCLnKS1sxodWD/ljbuSVJUBOk1uyG7iLY2CKajwffFI1Bf8p/v
         eWce86QZzUMpk7UM9+YPEkkb6bTUa5LA6LmoHgD0cbIHw1eHkY2SDtJFdWq4CRRTDwL0
         ye8AWXC8CUGRnlRkE9MIJSbq2VmHpTAy7HhkXWBg261q98ibn+GpO2E78ehJjJdKBKxh
         gV1erenGjngQYqnwEEszGF3H/cJEGVR0FcYeQDOfoeQ/TD9X0Cd1Hp4Swaz1QH+lYsa/
         Z3ag==
X-Gm-Message-State: AOAM532rhHVQSlKclA4Ylgf19V2EYApjr1NkRTUrPveQ80NwNS4XUWbu
        e7+OEo93EipNA/PZ097QRKsJ/WfERP8=
X-Google-Smtp-Source: ABdhPJxSglwd7cpK5W9I9ybudk1OWdomZcKHSBdP9Z7wwApeYSQsDWvaQWUBEE2DDoBudr0oX+M8iw==
X-Received: by 2002:a17:902:bccc:b0:136:1474:3f37 with SMTP id o12-20020a170902bccc00b0013614743f37mr11954394pls.57.1631926632918;
        Fri, 17 Sep 2021 17:57:12 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id q1sm7026523pfu.4.2021.09.17.17.57.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Sep 2021 17:57:12 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH V2 06/10] KVM: X86: Change kvm_sync_page() to return true when remote flush is needed
Date:   Sat, 18 Sep 2021 08:56:32 +0800
Message-Id: <20210918005636.3675-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210918005636.3675-1-jiangshanlai@gmail.com>
References: <20210918005636.3675-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Currently kvm_sync_page() returns true when there is any present spte.
But the return value is ignored in the callers.

Changing kvm_sync_page() to return true when remote flush is needed and
changing mmu->sync_page() not to directly flush can combine and reduce
remote flush requests.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c         | 21 +++++++++++++--------
 arch/x86/kvm/mmu/paging_tmpl.h | 21 ++++++++++-----------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9aba5d93a747..2f3f47dc96b0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1792,7 +1792,7 @@ static void mark_unsync(u64 *spte)
 static int nonpaging_sync_page(struct kvm_vcpu *vcpu,
 			       struct kvm_mmu_page *sp)
 {
-	return 0;
+	return -1;
 }
 
 #define KVM_PAGE_ARRAY_NR 16
@@ -1906,12 +1906,14 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 static bool kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			 struct list_head *invalid_list)
 {
-	if (vcpu->arch.mmu->sync_page(vcpu, sp) == 0) {
+	int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
+
+	if (ret < 0) {
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
 		return false;
 	}
 
-	return true;
+	return !!ret;
 }
 
 static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
@@ -2021,6 +2023,7 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 	struct mmu_page_path parents;
 	struct kvm_mmu_pages pages;
 	LIST_HEAD(invalid_list);
+	bool flush = false;
 
 	while (mmu_unsync_walk(parent, &pages)) {
 		bool protected = false;
@@ -2030,23 +2033,25 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu,
 
 		if (protected) {
 			kvm_flush_remote_tlbs(vcpu->kvm);
+			flush = false;
 		}
 
 		for_each_sp(pages, sp, parents, i) {
 			kvm_unlink_unsync_page(vcpu->kvm, sp);
-			kvm_sync_page(vcpu, sp, &invalid_list);
+			flush |= kvm_sync_page(vcpu, sp, &invalid_list);
 			mmu_pages_clear_parents(&parents);
 		}
 		if (need_resched() || rwlock_needbreak(&vcpu->kvm->mmu_lock)) {
-			kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, false);
+			kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, flush);
 			if (!can_yield)
 				return -EINTR;
 
 			cond_resched_rwlock_write(&vcpu->kvm->mmu_lock);
+			flush = false;
 		}
 	}
 
-	kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, false);
+	kvm_mmu_remote_flush_or_zap(vcpu->kvm, &invalid_list, flush);
 	return 0;
 }
 
@@ -2130,6 +2135,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 				break;
 
 			WARN_ON(!list_empty(&invalid_list));
+			kvm_flush_remote_tlbs(vcpu->kvm);
 		}
 
 		__clear_sp_write_flooding_count(sp);
@@ -4128,7 +4134,7 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
 }
 
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
-			   unsigned int access, int *nr_present)
+			   unsigned int access)
 {
 	if (unlikely(is_mmio_spte(*sptep))) {
 		if (gfn != get_mmio_spte_gfn(*sptep)) {
@@ -4136,7 +4142,6 @@ static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			return true;
 		}
 
-		(*nr_present)++;
 		mark_mmio_spte(vcpu, sptep, gfn, access);
 		return true;
 	}
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 87374cfd82be..c3edbc0f06b3 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1060,11 +1060,16 @@ static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gpa_t vaddr,
  * Using the cached information from sp->gfns is safe because:
  * - The spte has a reference to the struct page, so the pfn for a given gfn
  *   can't change unless all sptes pointing to it are nuked first.
+ *
+ * Returns
+ * < 0: the sp should be zapped
+ *   0: the sp is synced and no tlb flushing is required
+ * > 0: the sp is synced and tlb flushing is required
  */
 static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
 	union kvm_mmu_page_role mmu_role = vcpu->arch.mmu->mmu_role.base;
-	int i, nr_present = 0;
+	int i;
 	bool host_writable;
 	gpa_t first_pte_gpa;
 	int set_spte_ret = 0;
@@ -1092,7 +1097,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	 */
 	if (WARN_ON_ONCE(sp->role.direct ||
 			 (sp->role.word ^ mmu_role.word) & ~sync_role_ign.word))
-		return 0;
+		return -1;
 
 	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
 
@@ -1109,7 +1114,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 		if (kvm_vcpu_read_guest_atomic(vcpu, pte_gpa, &gpte,
 					       sizeof(pt_element_t)))
-			return 0;
+			return -1;
 
 		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
 			set_spte_ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
@@ -1121,8 +1126,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		pte_access &= FNAME(gpte_access)(gpte);
 		FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
 
-		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access,
-		      &nr_present))
+		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
 			continue;
 
 		if (gfn != sp->gfns[i]) {
@@ -1131,8 +1135,6 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 			continue;
 		}
 
-		nr_present++;
-
 		host_writable = sp->spt[i] & shadow_host_writable_mask;
 
 		set_spte_ret |= set_spte(vcpu, &sp->spt[i],
@@ -1141,10 +1143,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 					 true, false, host_writable);
 	}
 
-	if (set_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH)
-		kvm_flush_remote_tlbs(vcpu->kvm);
-
-	return nr_present;
+	return set_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH;
 }
 
 #undef pt_element_t
-- 
2.19.1.6.gb485710b

