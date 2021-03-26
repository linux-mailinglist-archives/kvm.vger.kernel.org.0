Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B77E349F9F
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhCZCVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbhCZCUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:20:41 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40113C06174A
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:41 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id p10so4453527qtq.12
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=iOxVbzFlH8VW2JI1VRY4zQXrBpDFtrY2X8eDwK7j5X0=;
        b=pkCs9Yr9pU3dv8fIQ9jmgeVq8yYkCMb3isLduBpKm1mmZlTaS3cw92wfdT89bQmnHg
         OIt6u25rmVDu1dKCLXCi65g9WvgjeQN0VufT6JuNo0XteNPeod2Th/HJT2RQW5VyaD2F
         tc6CtS2O44jw0uCQ29F+miC/xwY3Al63bPK3tppYdJXN2kQyqQgmqHTYWTqoyXm8kHwp
         ASC5MWXe/fk/e3W+NvQbUVp+j5lTAbkg4nBtBBj5GaoB7H076s2V9EjX/d9aREl6fBYu
         wHkvpemcWPUlzsXCTrIiB0TvYnmzcapkfXVHzbN9KfzxobSFtsKL4B3IYpZ0Y21T2/p6
         zCaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=iOxVbzFlH8VW2JI1VRY4zQXrBpDFtrY2X8eDwK7j5X0=;
        b=Wtr806rpYvDB+jvcKjS4QtwQSMFOiNxa/gX2cy2DDr/z1wLhAM6DmA8EyNQMYWZAOH
         fgbjQ6f/eb/ehoSTKV3HCKvP5dSD8QWEHu/qC8pyjWehJSh6Y/dZR08Ly/4SztCAYTmV
         wJYRgRnPX/DDvWmQATdDGPRe9GbuehKORHO7wOwj2JwDEYup8UGGSmnqzF79m9aDWDJz
         UwccmRsb1VjxeniElfD5RfB0i0YUZ2cvAubXFmSmRgvSo/EwQwcr/QxtUCW39CJPV7p6
         vFduYQ4uSXeJueUJn6omR5ODqMvfAbgI78NNQDStlh2bbe9NEAWVGB8hXS8vs2U2crha
         UKKg==
X-Gm-Message-State: AOAM533VVW+8U/kwQgaGI+u4XDQtKioMd43gEuVrDTc6AHlrTTUFeZrk
        8ZjaozuCD+2COAWMpgIQe6cQr40oG+U=
X-Google-Smtp-Source: ABdhPJysb3AnZIQOuckAyLhiRMHK0YS1lW+g5d/glNXX4o+lHoC4VeI7qhSEjg90fQP3CZPpwpHva/+pbdE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a0c:9ad7:: with SMTP id k23mr11087380qvf.52.1616725240451;
 Thu, 25 Mar 2021 19:20:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:52 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 13/18] KVM: PPC: Convert to the gfn-based MMU notifier callbacks
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move PPC to the gfn-base MMU notifier APIs, and update all 15 bajillion
PPC-internal hooks to work with gfns instead of hvas.

No meaningful functional change intended, though the exact order of
operations is slightly different since the memslot lookups occur before
calling into arch code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/include/asm/kvm_book3s.h  | 12 ++--
 arch/powerpc/include/asm/kvm_host.h    |  1 +
 arch/powerpc/include/asm/kvm_ppc.h     |  9 ++-
 arch/powerpc/kvm/book3s.c              | 18 +++--
 arch/powerpc/kvm/book3s.h              | 10 ++-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    | 98 +++++++-------------------
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 25 +++----
 arch/powerpc/kvm/book3s_hv.c           | 12 ++--
 arch/powerpc/kvm/book3s_pr.c           | 56 +++++----------
 arch/powerpc/kvm/e500_mmu_host.c       | 27 +++----
 10 files changed, 95 insertions(+), 173 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 2f5f919f6cd3..2d03f2930767 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -210,12 +210,12 @@ extern void kvmppc_free_pgtable_radix(struct kvm *kvm, pgd_t *pgd,
 				      unsigned int lpid);
 extern int kvmppc_radix_init(void);
 extern void kvmppc_radix_exit(void);
-extern int kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
-			unsigned long gfn);
-extern int kvm_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
-			unsigned long gfn);
-extern int kvm_test_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
-			unsigned long gfn);
+extern bool kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
+			    unsigned long gfn);
+extern bool kvm_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
+			  unsigned long gfn);
+extern bool kvm_test_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
+			       unsigned long gfn);
 extern long kvmppc_hv_get_dirty_log_radix(struct kvm *kvm,
 			struct kvm_memory_slot *memslot, unsigned long *map);
 extern void kvmppc_radix_flush_memslot(struct kvm *kvm,
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 1e83359f286b..1335f0001bdd 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -55,6 +55,7 @@
 #include <linux/mmu_notifier.h>
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
+#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 #define HPTEG_CACHE_NUM			(1 << 15)
 #define HPTEG_HASH_BITS_PTE		13
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 8aacd76bb702..21ab0332eb42 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -281,11 +281,10 @@ struct kvmppc_ops {
 				     const struct kvm_memory_slot *old,
 				     const struct kvm_memory_slot *new,
 				     enum kvm_mr_change change);
-	int (*unmap_hva_range)(struct kvm *kvm, unsigned long start,
-			   unsigned long end);
-	int (*age_hva)(struct kvm *kvm, unsigned long start, unsigned long end);
-	int (*test_age_hva)(struct kvm *kvm, unsigned long hva);
-	void (*set_spte_hva)(struct kvm *kvm, unsigned long hva, pte_t pte);
+	bool (*unmap_gfn_range)(struct kvm *kvm, struct kvm_gfn_range *range);
+	bool (*age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
+	bool (*test_age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
+	bool (*set_spte_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
 	void (*free_memslot)(struct kvm_memory_slot *slot);
 	int (*init_vm)(struct kvm *kvm);
 	void (*destroy_vm)(struct kvm *kvm);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 44bf567b6589..2b691f4d1f26 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -834,26 +834,24 @@ void kvmppc_core_commit_memory_region(struct kvm *kvm,
 	kvm->arch.kvm_ops->commit_memory_region(kvm, mem, old, new, change);
 }
 
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
-			unsigned flags)
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm->arch.kvm_ops->unmap_hva_range(kvm, start, end);
+	return kvm->arch.kvm_ops->unmap_gfn_range(kvm, range);
 }
 
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm->arch.kvm_ops->age_hva(kvm, start, end);
+	return kvm->arch.kvm_ops->age_gfn(kvm, range);
 }
 
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm->arch.kvm_ops->test_age_hva(kvm, hva);
+	return kvm->arch.kvm_ops->test_age_gfn(kvm, range);
 }
 
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
+bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	kvm->arch.kvm_ops->set_spte_hva(kvm, hva, pte);
-	return 0;
+	return kvm->arch.kvm_ops->set_spte_gfn(kvm, range);
 }
 
 int kvmppc_core_init_vm(struct kvm *kvm)
diff --git a/arch/powerpc/kvm/book3s.h b/arch/powerpc/kvm/book3s.h
index 9b6323ec8e60..740e51def5a5 100644
--- a/arch/powerpc/kvm/book3s.h
+++ b/arch/powerpc/kvm/book3s.h
@@ -9,12 +9,10 @@
 
 extern void kvmppc_core_flush_memslot_hv(struct kvm *kvm,
 					 struct kvm_memory_slot *memslot);
-extern int kvm_unmap_hva_range_hv(struct kvm *kvm, unsigned long start,
-				  unsigned long end);
-extern int kvm_age_hva_hv(struct kvm *kvm, unsigned long start,
-			  unsigned long end);
-extern int kvm_test_age_hva_hv(struct kvm *kvm, unsigned long hva);
-extern void kvm_set_spte_hva_hv(struct kvm *kvm, unsigned long hva, pte_t pte);
+extern bool kvm_unmap_gfn_range_hv(struct kvm *kvm, struct kvm_gfn_range *range);
+extern bool kvm_age_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range);
+extern bool kvm_test_age_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range);
+extern bool kvm_set_spte_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range);
 
 extern int kvmppc_mmu_init_pr(struct kvm_vcpu *vcpu);
 extern void kvmppc_mmu_destroy_pr(struct kvm_vcpu *vcpu);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index bb6773594cf8..b7bd9ca040b8 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -752,51 +752,6 @@ void kvmppc_rmap_reset(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 }
 
-typedef int (*hva_handler_fn)(struct kvm *kvm, struct kvm_memory_slot *memslot,
-			      unsigned long gfn);
-
-static int kvm_handle_hva_range(struct kvm *kvm,
-				unsigned long start,
-				unsigned long end,
-				hva_handler_fn handler)
-{
-	int ret;
-	int retval = 0;
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
-
-	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots) {
-		unsigned long hva_start, hva_end;
-		gfn_t gfn, gfn_end;
-
-		hva_start = max(start, memslot->userspace_addr);
-		hva_end = min(end, memslot->userspace_addr +
-					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
-		/*
-		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
-		 * {gfn, gfn+1, ..., gfn_end-1}.
-		 */
-		gfn = hva_to_gfn_memslot(hva_start, memslot);
-		gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
-
-		for (; gfn < gfn_end; ++gfn) {
-			ret = handler(kvm, memslot, gfn);
-			retval |= ret;
-		}
-	}
-
-	return retval;
-}
-
-static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
-			  hva_handler_fn handler)
-{
-	return kvm_handle_hva_range(kvm, hva, hva + 1, handler);
-}
-
 /* Must be called with both HPTE and rmap locked */
 static void kvmppc_unmap_hpte(struct kvm *kvm, unsigned long i,
 			      struct kvm_memory_slot *memslot,
@@ -840,8 +795,8 @@ static void kvmppc_unmap_hpte(struct kvm *kvm, unsigned long i,
 	}
 }
 
-static int kvm_unmap_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
-			   unsigned long gfn)
+static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
+			    unsigned long gfn)
 {
 	unsigned long i;
 	__be64 *hptep;
@@ -874,16 +829,15 @@ static int kvm_unmap_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		unlock_rmap(rmapp);
 		__unlock_hpte(hptep, be64_to_cpu(hptep[0]));
 	}
-	return 0;
+	return false;
 }
 
-int kvm_unmap_hva_range_hv(struct kvm *kvm, unsigned long start, unsigned long end)
+bool kvm_unmap_gfn_range_hv(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	hva_handler_fn handler;
+	if (kvm_is_radix(kvm))
+		return kvm_unmap_radix(kvm, range->slot, range->start);
 
-	handler = kvm_is_radix(kvm) ? kvm_unmap_radix : kvm_unmap_rmapp;
-	kvm_handle_hva_range(kvm, start, end, handler);
-	return 0;
+	return kvm_unmap_rmapp(kvm, range->slot, range->start);
 }
 
 void kvmppc_core_flush_memslot_hv(struct kvm *kvm,
@@ -913,8 +867,8 @@ void kvmppc_core_flush_memslot_hv(struct kvm *kvm,
 	}
 }
 
-static int kvm_age_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
-			 unsigned long gfn)
+static bool kvm_age_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
+			  unsigned long gfn)
 {
 	struct revmap_entry *rev = kvm->arch.hpt.rev;
 	unsigned long head, i, j;
@@ -968,26 +922,26 @@ static int kvm_age_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	return ret;
 }
 
-int kvm_age_hva_hv(struct kvm *kvm, unsigned long start, unsigned long end)
+bool kvm_age_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	hva_handler_fn handler;
+	if (kvm_is_radix(kvm))
+		kvm_age_radix(kvm, range->slot, range->start);
 
-	handler = kvm_is_radix(kvm) ? kvm_age_radix : kvm_age_rmapp;
-	return kvm_handle_hva_range(kvm, start, end, handler);
+	return kvm_age_rmapp(kvm, range->slot, range->start);
 }
 
-static int kvm_test_age_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
-			      unsigned long gfn)
+static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
+			       unsigned long gfn)
 {
 	struct revmap_entry *rev = kvm->arch.hpt.rev;
 	unsigned long head, i, j;
 	unsigned long *hp;
-	int ret = 1;
+	bool ret = true;
 	unsigned long *rmapp;
 
 	rmapp = &memslot->arch.rmap[gfn - memslot->base_gfn];
 	if (*rmapp & KVMPPC_RMAP_REFERENCED)
-		return 1;
+		return true;
 
 	lock_rmap(rmapp);
 	if (*rmapp & KVMPPC_RMAP_REFERENCED)
@@ -1002,27 +956,27 @@ static int kvm_test_age_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
 				goto out;
 		} while ((i = j) != head);
 	}
-	ret = 0;
+	ret = false;
 
  out:
 	unlock_rmap(rmapp);
 	return ret;
 }
 
-int kvm_test_age_hva_hv(struct kvm *kvm, unsigned long hva)
+bool kvm_test_age_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	hva_handler_fn handler;
+	if (kvm_is_radix(kvm))
+		kvm_test_age_radix(kvm, range->slot, range->start);
 
-	handler = kvm_is_radix(kvm) ? kvm_test_age_radix : kvm_test_age_rmapp;
-	return kvm_handle_hva(kvm, hva, handler);
+	return kvm_test_age_rmapp(kvm, range->slot, range->start);
 }
 
-void kvm_set_spte_hva_hv(struct kvm *kvm, unsigned long hva, pte_t pte)
+bool kvm_set_spte_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	hva_handler_fn handler;
+	if (kvm_is_radix(kvm))
+		return kvm_unmap_radix(kvm, range->slot, range->start);
 
-	handler = kvm_is_radix(kvm) ? kvm_unmap_radix : kvm_unmap_rmapp;
-	kvm_handle_hva(kvm, hva, handler);
+	return kvm_unmap_rmapp(kvm, range->slot, range->start);
 }
 
 static int vcpus_running(struct kvm *kvm)
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index e603de7ade52..9e19ea451354 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -993,8 +993,8 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 }
 
 /* Called with kvm->mmu_lock held */
-int kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
-		    unsigned long gfn)
+bool kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
+		     unsigned long gfn)
 {
 	pte_t *ptep;
 	unsigned long gpa = gfn << PAGE_SHIFT;
@@ -1002,24 +1002,24 @@ int kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE) {
 		uv_page_inval(kvm->arch.lpid, gpa, PAGE_SHIFT);
-		return 0;
+		return false;
 	}
 
 	ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (ptep && pte_present(*ptep))
 		kvmppc_unmap_pte(kvm, ptep, gpa, shift, memslot,
 				 kvm->arch.lpid);
-	return 0;
+	return false;
 }
 
 /* Called with kvm->mmu_lock held */
-int kvm_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
-		  unsigned long gfn)
+bool kvm_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
+		   unsigned long gfn)
 {
 	pte_t *ptep;
 	unsigned long gpa = gfn << PAGE_SHIFT;
 	unsigned int shift;
-	int ref = 0;
+	bool ref = false;
 	unsigned long old, *rmapp;
 
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)
@@ -1035,26 +1035,27 @@ int kvm_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		kvmhv_update_nest_rmap_rc_list(kvm, rmapp, _PAGE_ACCESSED, 0,
 					       old & PTE_RPN_MASK,
 					       1UL << shift);
-		ref = 1;
+		ref = true;
 	}
 	return ref;
 }
 
 /* Called with kvm->mmu_lock held */
-int kvm_test_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
-		       unsigned long gfn)
+bool kvm_test_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
+		        unsigned long gfn)
+
 {
 	pte_t *ptep;
 	unsigned long gpa = gfn << PAGE_SHIFT;
 	unsigned int shift;
-	int ref = 0;
+	bool ref = false;
 
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)
 		return ref;
 
 	ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (ptep && pte_present(*ptep) && pte_young(*ptep))
-		ref = 1;
+		ref = true;
 	return ref;
 }
 
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 13bad6bf4c95..07682ad4110e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4770,7 +4770,7 @@ int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 		kvmhv_release_all_nested(kvm);
 	kvmppc_rmap_reset(kvm);
 	kvm->arch.process_table = 0;
-	/* Mutual exclusion with kvm_unmap_hva_range etc. */
+	/* Mutual exclusion with kvm_unmap_gfn_range etc. */
 	spin_lock(&kvm->mmu_lock);
 	kvm->arch.radix = 0;
 	spin_unlock(&kvm->mmu_lock);
@@ -4792,7 +4792,7 @@ int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
 	if (err)
 		return err;
 	kvmppc_rmap_reset(kvm);
-	/* Mutual exclusion with kvm_unmap_hva_range etc. */
+	/* Mutual exclusion with kvm_unmap_gfn_range etc. */
 	spin_lock(&kvm->mmu_lock);
 	kvm->arch.radix = 1;
 	spin_unlock(&kvm->mmu_lock);
@@ -5654,10 +5654,10 @@ static struct kvmppc_ops kvm_ops_hv = {
 	.flush_memslot  = kvmppc_core_flush_memslot_hv,
 	.prepare_memory_region = kvmppc_core_prepare_memory_region_hv,
 	.commit_memory_region  = kvmppc_core_commit_memory_region_hv,
-	.unmap_hva_range = kvm_unmap_hva_range_hv,
-	.age_hva  = kvm_age_hva_hv,
-	.test_age_hva = kvm_test_age_hva_hv,
-	.set_spte_hva = kvm_set_spte_hva_hv,
+	.unmap_gfn_range = kvm_unmap_gfn_range_hv,
+	.age_gfn = kvm_age_gfn_hv,
+	.test_age_gfn = kvm_test_age_gfn_hv,
+	.set_spte_gfn = kvm_set_spte_gfn_hv,
 	.free_memslot = kvmppc_core_free_memslot_hv,
 	.init_vm =  kvmppc_core_init_vm_hv,
 	.destroy_vm = kvmppc_core_destroy_vm_hv,
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 913944dc3620..d7733b07f489 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -425,61 +425,39 @@ static int kvmppc_core_check_requests_pr(struct kvm_vcpu *vcpu)
 }
 
 /************* MMU Notifiers *************/
-static void do_kvm_unmap_hva(struct kvm *kvm, unsigned long start,
-			     unsigned long end)
+static bool do_kvm_unmap_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	long i;
 	struct kvm_vcpu *vcpu;
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
 
-	slots = kvm_memslots(kvm);
-	kvm_for_each_memslot(memslot, slots) {
-		unsigned long hva_start, hva_end;
-		gfn_t gfn, gfn_end;
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvmppc_mmu_pte_pflush(vcpu, range->start << PAGE_SHIFT,
+				      range->end << PAGE_SHIFT);
 
-		hva_start = max(start, memslot->userspace_addr);
-		hva_end = min(end, memslot->userspace_addr +
-					(memslot->npages << PAGE_SHIFT));
-		if (hva_start >= hva_end)
-			continue;
-		/*
-		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
-		 * {gfn, gfn+1, ..., gfn_end-1}.
-		 */
-		gfn = hva_to_gfn_memslot(hva_start, memslot);
-		gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
-		kvm_for_each_vcpu(i, vcpu, kvm)
-			kvmppc_mmu_pte_pflush(vcpu, gfn << PAGE_SHIFT,
-					      gfn_end << PAGE_SHIFT);
-	}
+	return false;
 }
 
-static int kvm_unmap_hva_range_pr(struct kvm *kvm, unsigned long start,
-				  unsigned long end)
+static bool kvm_unmap_gfn_range_pr(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	do_kvm_unmap_hva(kvm, start, end);
-
-	return 0;
+	return do_kvm_unmap_gfn(kvm, range);
 }
 
-static int kvm_age_hva_pr(struct kvm *kvm, unsigned long start,
-			  unsigned long end)
+static bool kvm_age_gfn_pr(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	/* XXX could be more clever ;) */
-	return 0;
+	return false;
 }
 
-static int kvm_test_age_hva_pr(struct kvm *kvm, unsigned long hva)
+static bool kvm_test_age_gfn_pr(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	/* XXX could be more clever ;) */
-	return 0;
+	return false;
 }
 
-static void kvm_set_spte_hva_pr(struct kvm *kvm, unsigned long hva, pte_t pte)
+static bool kvm_set_spte_gfn_pr(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	/* The page will get remapped properly on its next fault */
-	do_kvm_unmap_hva(kvm, hva, hva + PAGE_SIZE);
+	return do_kvm_unmap_gfn(kvm, range);
 }
 
 /*****************************************/
@@ -2079,10 +2057,10 @@ static struct kvmppc_ops kvm_ops_pr = {
 	.flush_memslot = kvmppc_core_flush_memslot_pr,
 	.prepare_memory_region = kvmppc_core_prepare_memory_region_pr,
 	.commit_memory_region = kvmppc_core_commit_memory_region_pr,
-	.unmap_hva_range = kvm_unmap_hva_range_pr,
-	.age_hva  = kvm_age_hva_pr,
-	.test_age_hva = kvm_test_age_hva_pr,
-	.set_spte_hva = kvm_set_spte_hva_pr,
+	.unmap_gfn_range = kvm_unmap_gfn_range_pr,
+	.age_gfn  = kvm_age_gfn_pr,
+	.test_age_gfn = kvm_test_age_gfn_pr,
+	.set_spte_gfn = kvm_set_spte_gfn_pr,
 	.free_memslot = kvmppc_core_free_memslot_pr,
 	.init_vm = kvmppc_core_init_vm_pr,
 	.destroy_vm = kvmppc_core_destroy_vm_pr,
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 648aefe1a3e7..7f16afc331ef 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -721,43 +721,36 @@ int kvmppc_load_last_inst(struct kvm_vcpu *vcpu,
 
 /************* MMU Notifiers *************/
 
-static int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
+static bool kvm_e500_mmu_unmap_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	/*
 	 * Flush all shadow tlb entries everywhere. This is slow, but
 	 * we are 100% sure that we catch the to be unmapped page
 	 */
-	kvm_flush_remote_tlbs(kvm);
-
-	return 0;
+	return true;
 }
 
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
-			unsigned flags)
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	/* kvm_unmap_hva flushes everything anyways */
-	kvm_unmap_hva(kvm, start);
-
-	return 0;
+	return kvm_e500_mmu_unmap_gfn(kvm, range);
 }
 
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	/* XXX could be more clever ;) */
-	return 0;
+	return false;
 }
 
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	/* XXX could be more clever ;) */
-	return 0;
+	return false;
 }
 
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
+bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	/* The page will get remapped properly on its next fault */
-	kvm_unmap_hva(kvm, hva);
-	return 0;
+	return kvm_e500_mmu_unmap_gfn(kvm, range);
 }
 
 /*****************************************/
-- 
2.31.0.291.g576ba9dcdaf-goog

