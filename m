Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7C3B11EA27
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 19:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbfLMS1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 13:27:53 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:56745 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728660AbfLMS1w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 13:27:52 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ifpdF-0001O7-KH; Fri, 13 Dec 2019 19:25:41 +0100
From:   Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 2/7] KVM: arm/arm64: Pass flags along Stage-2 unmapping functions
Date:   Fri, 13 Dec 2019 18:24:58 +0000
Message-Id: <20191213182503.14460-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191213182503.14460-1-maz@kernel.org>
References: <20191213182503.14460-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, jhogan@kernel.org, paulus@ozlabs.org, pbonzini@redhat.com, rkrcmar@redhat.com, sean.j.christopherson@intel.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass a set of flags to all Stage-2 unmapping functions.
The only value passed for now is zero, and it is not evaluated yet.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/mmu.c | 47 ++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 078e10c5650e..0fed7c19c6d5 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -152,7 +152,8 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 	return p;
 }
 
-static void clear_stage2_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_addr_t addr)
+static void clear_stage2_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_addr_t addr,
+				   unsigned long flags)
 {
 	pud_t *pud_table __maybe_unused = stage2_pud_offset(kvm, pgd, 0UL);
 	stage2_pgd_clear(kvm, pgd);
@@ -161,7 +162,8 @@ static void clear_stage2_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_addr_t addr
 	put_page(virt_to_page(pgd));
 }
 
-static void clear_stage2_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr)
+static void clear_stage2_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr,
+				   unsigned long flags)
 {
 	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(kvm, pud, 0);
 	VM_BUG_ON(stage2_pud_huge(kvm, *pud));
@@ -171,7 +173,8 @@ static void clear_stage2_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr
 	put_page(virt_to_page(pud));
 }
 
-static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr)
+static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr,
+				   unsigned long flags)
 {
 	pte_t *pte_table = pte_offset_kernel(pmd, 0);
 	VM_BUG_ON(pmd_thp_or_huge(*pmd));
@@ -235,7 +238,8 @@ static inline void kvm_pgd_populate(pgd_t *pgdp, pud_t *pudp)
  * does.
  */
 static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
-		       phys_addr_t addr, phys_addr_t end)
+			      phys_addr_t addr, phys_addr_t end,
+			      unsigned long flags)
 {
 	phys_addr_t start_addr = addr;
 	pte_t *pte, *start_pte;
@@ -257,11 +261,12 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
 	if (stage2_pte_table_empty(kvm, start_pte))
-		clear_stage2_pmd_entry(kvm, pmd, start_addr);
+		clear_stage2_pmd_entry(kvm, pmd, start_addr, flags);
 }
 
 static void unmap_stage2_pmds(struct kvm *kvm, pud_t *pud,
-		       phys_addr_t addr, phys_addr_t end)
+			      phys_addr_t addr, phys_addr_t end,
+			      unsigned long flags)
 {
 	phys_addr_t next, start_addr = addr;
 	pmd_t *pmd, *start_pmd;
@@ -280,17 +285,18 @@ static void unmap_stage2_pmds(struct kvm *kvm, pud_t *pud,
 
 				put_page(virt_to_page(pmd));
 			} else {
-				unmap_stage2_ptes(kvm, pmd, addr, next);
+				unmap_stage2_ptes(kvm, pmd, addr, next, flags);
 			}
 		}
 	} while (pmd++, addr = next, addr != end);
 
 	if (stage2_pmd_table_empty(kvm, start_pmd))
-		clear_stage2_pud_entry(kvm, pud, start_addr);
+		clear_stage2_pud_entry(kvm, pud, start_addr, flags);
 }
 
 static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
-		       phys_addr_t addr, phys_addr_t end)
+			      phys_addr_t addr, phys_addr_t end,
+			      unsigned long flags)
 {
 	phys_addr_t next, start_addr = addr;
 	pud_t *pud, *start_pud;
@@ -307,13 +313,13 @@ static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
 				kvm_flush_dcache_pud(old_pud);
 				put_page(virt_to_page(pud));
 			} else {
-				unmap_stage2_pmds(kvm, pud, addr, next);
+				unmap_stage2_pmds(kvm, pud, addr, next, flags);
 			}
 		}
 	} while (pud++, addr = next, addr != end);
 
 	if (stage2_pud_table_empty(kvm, start_pud))
-		clear_stage2_pgd_entry(kvm, pgd, start_addr);
+		clear_stage2_pgd_entry(kvm, pgd, start_addr, flags);
 }
 
 /**
@@ -327,7 +333,8 @@ static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
  * destroying the VM), otherwise another faulting VCPU may come in and mess
  * with things behind our backs.
  */
-static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
+static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size,
+			       unsigned long flags)
 {
 	pgd_t *pgd;
 	phys_addr_t addr = start, end = start + size;
@@ -347,7 +354,7 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 			break;
 		next = stage2_pgd_addr_end(kvm, addr, end);
 		if (!stage2_pgd_none(kvm, *pgd))
-			unmap_stage2_puds(kvm, pgd, addr, next);
+			unmap_stage2_puds(kvm, pgd, addr, next, flags);
 		/*
 		 * If the range is too large, release the kvm->mmu_lock
 		 * to prevent starvation and lockup detector warnings.
@@ -950,7 +957,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 
 		if (!(vma->vm_flags & VM_PFNMAP)) {
 			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
-			unmap_stage2_range(kvm, gpa, vm_end - vm_start);
+			unmap_stage2_range(kvm, gpa, vm_end - vm_start, 0);
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
@@ -996,7 +1003,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
-		unmap_stage2_range(kvm, 0, kvm_phys_size(kvm));
+		unmap_stage2_range(kvm, 0, kvm_phys_size(kvm), 0);
 		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 		kvm->arch.pgd_phys = 0;
@@ -1086,7 +1093,7 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 		 * get handled accordingly.
 		 */
 		if (!pmd_thp_or_huge(old_pmd)) {
-			unmap_stage2_range(kvm, addr & S2_PMD_MASK, S2_PMD_SIZE);
+			unmap_stage2_range(kvm, addr & S2_PMD_MASK, S2_PMD_SIZE, 0);
 			goto retry;
 		}
 		/*
@@ -1136,7 +1143,7 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
 		 * the range for this block and retry.
 		 */
 		if (!stage2_pud_huge(kvm, old_pud)) {
-			unmap_stage2_range(kvm, addr & S2_PUD_MASK, S2_PUD_SIZE);
+			unmap_stage2_range(kvm, addr & S2_PUD_MASK, S2_PUD_SIZE, 0);
 			goto retry;
 		}
 
@@ -2031,7 +2038,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 
 static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
-	unmap_stage2_range(kvm, gpa, size);
+	unmap_stage2_range(kvm, gpa, size, 0);
 	return 0;
 }
 
@@ -2344,7 +2351,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
-		unmap_stage2_range(kvm, mem->guest_phys_addr, mem->memory_size);
+		unmap_stage2_range(kvm, mem->guest_phys_addr, mem->memory_size, 0);
 	else
 		stage2_flush_memslot(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
@@ -2380,7 +2387,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	unmap_stage2_range(kvm, gpa, size);
+	unmap_stage2_range(kvm, gpa, size, 0);
 	spin_unlock(&kvm->mmu_lock);
 }
 
-- 
2.20.1

