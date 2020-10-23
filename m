Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6222973E3
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751552AbgJWQah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:30:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750704AbgJWQag (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7yCUqJHRgW8Rg0g66xakTlElmUGwxirC4wHRFVKiOw=;
        b=PlKJx9WenzkBZdbBqTWMoUmlz9jnSwZszX6SOvdPV7MJ1KfncdYWb2bmpR1/omAPasZy8r
        X48QFinXDWFmw52IF+wUDMh+RRjZJAjO60jL1syu9dViF+9Li6ujfQiD//TWWKpmsth7u5
        6Th89O48JkzyI/JwnoUom0RYcKy3dvw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-rSGRW1mhOZGQOBJf8-NoKQ-1; Fri, 23 Oct 2020 12:30:28 -0400
X-MC-Unique: rSGRW1mhOZGQOBJf8-NoKQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2710110E2184;
        Fri, 23 Oct 2020 16:30:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7A0D5D9E2;
        Fri, 23 Oct 2020 16:30:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 04/22] KVM: mmu: extract spte.h and spte.c
Date:   Fri, 23 Oct 2020 12:30:06 -0400
Message-Id: <20201023163024.2765558-5-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SPTE format will be common to both the shadow and the TDP MMU.

Extract code that implements the format to a separate module, as a
first step towards adding the TDP MMU and putting mmu.c on a diet.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Makefile           |   3 +-
 arch/x86/kvm/mmu/mmu.c          | 551 +-------------------------------
 arch/x86/kvm/mmu/mmu_internal.h |  31 +-
 arch/x86/kvm/mmu/spte.c         | 318 ++++++++++++++++++
 arch/x86/kvm/mmu/spte.h         | 252 +++++++++++++++
 5 files changed, 607 insertions(+), 548 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/spte.c
 create mode 100644 arch/x86/kvm/mmu/spte.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 7f86a14aed0e..66aa24f5e2db 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -15,7 +15,8 @@ kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
-			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o
+			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
+			   mmu/spte.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3dec4744ab9c..02af304c168a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -23,6 +23,7 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 #include "cpuid.h"
+#include "spte.h"
 
 #include <linux/kvm_host.h>
 #include <linux/types.h>
@@ -45,7 +46,6 @@
 #include <asm/page.h>
 #include <asm/memtype.h>
 #include <asm/cmpxchg.h>
-#include <asm/e820/api.h>
 #include <asm/io.h>
 #include <asm/vmx.h>
 #include <asm/kvm_page_track.h>
@@ -104,45 +104,13 @@ enum {
 	AUDIT_POST_SYNC
 };
 
-#undef MMU_DEBUG
-
 #ifdef MMU_DEBUG
-static bool dbg = 0;
+bool dbg = 0;
 module_param(dbg, bool, 0644);
-
-#define pgprintk(x...) do { if (dbg) printk(x); } while (0)
-#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
-#define MMU_WARN_ON(x) WARN_ON(x)
-#else
-#define pgprintk(x...) do { } while (0)
-#define rmap_printk(x...) do { } while (0)
-#define MMU_WARN_ON(x) do { } while (0)
 #endif
 
 #define PTE_PREFETCH_NUM		8
 
-#define PT_FIRST_AVAIL_BITS_SHIFT 10
-#define PT64_SECOND_AVAIL_BITS_SHIFT 54
-
-/*
- * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
- * Access Tracking SPTEs.
- */
-#define SPTE_SPECIAL_MASK (3ULL << 52)
-#define SPTE_AD_ENABLED_MASK (0ULL << 52)
-#define SPTE_AD_DISABLED_MASK (1ULL << 52)
-#define SPTE_AD_WRPROT_ONLY_MASK (2ULL << 52)
-#define SPTE_MMIO_MASK (3ULL << 52)
-
-#define PT64_LEVEL_BITS 9
-
-#define PT64_LEVEL_SHIFT(level) \
-		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
-
-#define PT64_INDEX(address, level)\
-	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
-
-
 #define PT32_LEVEL_BITS 10
 
 #define PT32_LEVEL_SHIFT(level) \
@@ -156,18 +124,6 @@ module_param(dbg, bool, 0644);
 	(((address) >> PT32_LEVEL_SHIFT(level)) & ((1 << PT32_LEVEL_BITS) - 1))
 
 
-#ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
-#define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
-#else
-#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
-#endif
-#define PT64_LVL_ADDR_MASK(level) \
-	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
-#define PT64_LVL_OFFSET_MASK(level) \
-	(PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
-
 #define PT32_BASE_ADDR_MASK PAGE_MASK
 #define PT32_DIR_BASE_ADDR_MASK \
 	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
@@ -175,25 +131,8 @@ module_param(dbg, bool, 0644);
 	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
 					    * PT32_LEVEL_BITS))) - 1))
 
-#define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
-			| shadow_x_mask | shadow_nx_mask | shadow_me_mask)
-
-#define ACC_EXEC_MASK    1
-#define ACC_WRITE_MASK   PT_WRITABLE_MASK
-#define ACC_USER_MASK    PT_USER_MASK
-#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
-
-/* The mask for the R/X bits in EPT PTEs */
-#define PT64_EPT_READABLE_MASK			0x1ull
-#define PT64_EPT_EXECUTABLE_MASK		0x4ull
-
 #include <trace/events/kvm.h>
 
-#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
-#define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
-
-#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
-
 /* make pte_list_desc fit well in cache line */
 #define PTE_LIST_EXT 3
 
@@ -248,62 +187,7 @@ static struct kmem_cache *pte_list_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
-static u64 __read_mostly shadow_nx_mask;
-static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
-static u64 __read_mostly shadow_user_mask;
-static u64 __read_mostly shadow_accessed_mask;
-static u64 __read_mostly shadow_dirty_mask;
-static u64 __read_mostly shadow_mmio_value;
-static u64 __read_mostly shadow_mmio_access_mask;
-static u64 __read_mostly shadow_present_mask;
-static u64 __read_mostly shadow_me_mask;
-
-/*
- * SPTEs used by MMUs without A/D bits are marked with SPTE_AD_DISABLED_MASK;
- * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
- * pages.
- */
-static u64 __read_mostly shadow_acc_track_mask;
-
-/*
- * The mask/shift to use for saving the original R/X bits when marking the PTE
- * as not-present for access tracking purposes. We do not save the W bit as the
- * PTEs being access tracked also need to be dirty tracked, so the W bit will be
- * restored only when a write is attempted to the page.
- */
-static const u64 shadow_acc_track_saved_bits_mask = PT64_EPT_READABLE_MASK |
-						    PT64_EPT_EXECUTABLE_MASK;
-static const u64 shadow_acc_track_saved_bits_shift = PT64_SECOND_AVAIL_BITS_SHIFT;
-
-/*
- * This mask must be set on all non-zero Non-Present or Reserved SPTEs in order
- * to guard against L1TF attacks.
- */
-static u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
-
-/*
- * The number of high-order 1 bits to use in the mask above.
- */
-static const u64 shadow_nonpresent_or_rsvd_mask_len = 5;
-
-/*
- * In some cases, we need to preserve the GFN of a non-present or reserved
- * SPTE when we usurp the upper five bits of the physical address space to
- * defend against L1TF, e.g. for MMIO SPTEs.  To preserve the GFN, we'll
- * shift bits of the GFN that overlap with shadow_nonpresent_or_rsvd_mask
- * left into the reserved bits, i.e. the GFN in the SPTE will be split into
- * high and low parts.  This mask covers the lower bits of the GFN.
- */
-static u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
-
-/*
- * The number of non-reserved physical address bits irrespective of features
- * that repurpose legal bits, e.g. MKTME.
- */
-static u8 __read_mostly shadow_phys_bits;
-
 static void mmu_spte_set(u64 *sptep, u64 spte);
-static bool is_executable_pte(u64 spte);
 static union kvm_mmu_page_role
 kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
 
@@ -339,134 +223,11 @@ static void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 	kvm_flush_remote_tlbs_with_range(kvm, &range);
 }
 
-void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask)
-{
-	BUG_ON((u64)(unsigned)access_mask != access_mask);
-	WARN_ON(mmio_value & (shadow_nonpresent_or_rsvd_mask << shadow_nonpresent_or_rsvd_mask_len));
-	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
-	shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
-	shadow_mmio_access_mask = access_mask;
-}
-EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
-
-static bool is_mmio_spte(u64 spte)
-{
-	return (spte & SPTE_SPECIAL_MASK) == SPTE_MMIO_MASK;
-}
-
-static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
-{
-	return sp->role.ad_disabled;
-}
-
-static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * When using the EPT page-modification log, the GPAs in the log
-	 * would come from L2 rather than L1.  Therefore, we need to rely
-	 * on write protection to record dirty pages.  This also bypasses
-	 * PML, since writes now result in a vmexit.
-	 */
-	return vcpu->arch.mmu == &vcpu->arch.guest_mmu;
-}
-
-static inline bool spte_ad_enabled(u64 spte)
-{
-	MMU_WARN_ON(is_mmio_spte(spte));
-	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_DISABLED_MASK;
-}
-
-static inline bool spte_ad_need_write_protect(u64 spte)
-{
-	MMU_WARN_ON(is_mmio_spte(spte));
-	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_ENABLED_MASK;
-}
-
-static bool is_nx_huge_page_enabled(void)
+bool is_nx_huge_page_enabled(void)
 {
 	return READ_ONCE(nx_huge_pages);
 }
 
-static inline u64 spte_shadow_accessed_mask(u64 spte)
-{
-	MMU_WARN_ON(is_mmio_spte(spte));
-	return spte_ad_enabled(spte) ? shadow_accessed_mask : 0;
-}
-
-static inline u64 spte_shadow_dirty_mask(u64 spte)
-{
-	MMU_WARN_ON(is_mmio_spte(spte));
-	return spte_ad_enabled(spte) ? shadow_dirty_mask : 0;
-}
-
-static inline bool is_access_track_spte(u64 spte)
-{
-	return !spte_ad_enabled(spte) && (spte & shadow_acc_track_mask) == 0;
-}
-
-/*
- * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
- * the memslots generation and is derived as follows:
- *
- * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
- * Bits 9-18 of the MMIO generation are propagated to spte bits 52-61
- *
- * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
- * the MMIO generation number, as doing so would require stealing a bit from
- * the "real" generation number and thus effectively halve the maximum number
- * of MMIO generations that can be handled before encountering a wrap (which
- * requires a full MMU zap).  The flag is instead explicitly queried when
- * checking for MMIO spte cache hits.
- */
-#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(17, 0)
-
-#define MMIO_SPTE_GEN_LOW_START		3
-#define MMIO_SPTE_GEN_LOW_END		11
-#define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
-						    MMIO_SPTE_GEN_LOW_START)
-
-#define MMIO_SPTE_GEN_HIGH_START	PT64_SECOND_AVAIL_BITS_SHIFT
-#define MMIO_SPTE_GEN_HIGH_END		62
-#define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
-						    MMIO_SPTE_GEN_HIGH_START)
-
-static u64 generation_mmio_spte_mask(u64 gen)
-{
-	u64 mask;
-
-	WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
-	BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_SPECIAL_MASK);
-
-	mask = (gen << MMIO_SPTE_GEN_LOW_START) & MMIO_SPTE_GEN_LOW_MASK;
-	mask |= (gen << MMIO_SPTE_GEN_HIGH_START) & MMIO_SPTE_GEN_HIGH_MASK;
-	return mask;
-}
-
-static u64 get_mmio_spte_generation(u64 spte)
-{
-	u64 gen;
-
-	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_START;
-	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_START;
-	return gen;
-}
-
-static u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
-{
-
-	u64 gen = kvm_vcpu_memslots(vcpu)->generation & MMIO_SPTE_GEN_MASK;
-	u64 mask = generation_mmio_spte_mask(gen);
-	u64 gpa = gfn << PAGE_SHIFT;
-
-	access &= shadow_mmio_access_mask;
-	mask |= shadow_mmio_value | access;
-	mask |= gpa | shadow_nonpresent_or_rsvd_mask;
-	mask |= (gpa & shadow_nonpresent_or_rsvd_mask)
-		<< shadow_nonpresent_or_rsvd_mask_len;
-
-	return mask;
-}
-
 static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
 			   unsigned int access)
 {
@@ -532,90 +293,6 @@ static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
         return gpa;
 }
 
-/*
- * Sets the shadow PTE masks used by the MMU.
- *
- * Assumptions:
- *  - Setting either @accessed_mask or @dirty_mask requires setting both
- *  - At least one of @accessed_mask or @acc_track_mask must be set
- */
-void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
-		u64 dirty_mask, u64 nx_mask, u64 x_mask, u64 p_mask,
-		u64 acc_track_mask, u64 me_mask)
-{
-	BUG_ON(!dirty_mask != !accessed_mask);
-	BUG_ON(!accessed_mask && !acc_track_mask);
-	BUG_ON(acc_track_mask & SPTE_SPECIAL_MASK);
-
-	shadow_user_mask = user_mask;
-	shadow_accessed_mask = accessed_mask;
-	shadow_dirty_mask = dirty_mask;
-	shadow_nx_mask = nx_mask;
-	shadow_x_mask = x_mask;
-	shadow_present_mask = p_mask;
-	shadow_acc_track_mask = acc_track_mask;
-	shadow_me_mask = me_mask;
-}
-EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
-
-static u8 kvm_get_shadow_phys_bits(void)
-{
-	/*
-	 * boot_cpu_data.x86_phys_bits is reduced when MKTME or SME are detected
-	 * in CPU detection code, but the processor treats those reduced bits as
-	 * 'keyID' thus they are not reserved bits. Therefore KVM needs to look at
-	 * the physical address bits reported by CPUID.
-	 */
-	if (likely(boot_cpu_data.extended_cpuid_level >= 0x80000008))
-		return cpuid_eax(0x80000008) & 0xff;
-
-	/*
-	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
-	 * custom CPUID.  Proceed with whatever the kernel found since these features
-	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
-	 */
-	return boot_cpu_data.x86_phys_bits;
-}
-
-static void kvm_mmu_reset_all_pte_masks(void)
-{
-	u8 low_phys_bits;
-
-	shadow_user_mask = 0;
-	shadow_accessed_mask = 0;
-	shadow_dirty_mask = 0;
-	shadow_nx_mask = 0;
-	shadow_x_mask = 0;
-	shadow_present_mask = 0;
-	shadow_acc_track_mask = 0;
-
-	shadow_phys_bits = kvm_get_shadow_phys_bits();
-
-	/*
-	 * If the CPU has 46 or less physical address bits, then set an
-	 * appropriate mask to guard against L1TF attacks. Otherwise, it is
-	 * assumed that the CPU is not vulnerable to L1TF.
-	 *
-	 * Some Intel CPUs address the L1 cache using more PA bits than are
-	 * reported by CPUID. Use the PA width of the L1 cache when possible
-	 * to achieve more effective mitigation, e.g. if system RAM overlaps
-	 * the most significant bits of legal physical address space.
-	 */
-	shadow_nonpresent_or_rsvd_mask = 0;
-	low_phys_bits = boot_cpu_data.x86_phys_bits;
-	if (boot_cpu_has_bug(X86_BUG_L1TF) &&
-	    !WARN_ON_ONCE(boot_cpu_data.x86_cache_bits >=
-			  52 - shadow_nonpresent_or_rsvd_mask_len)) {
-		low_phys_bits = boot_cpu_data.x86_cache_bits
-			- shadow_nonpresent_or_rsvd_mask_len;
-		shadow_nonpresent_or_rsvd_mask =
-			rsvd_bits(low_phys_bits, boot_cpu_data.x86_cache_bits - 1);
-	}
-
-	shadow_nonpresent_or_rsvd_lower_gfn_mask =
-		GENMASK_ULL(low_phys_bits - 1, PAGE_SHIFT);
-}
-
 static int is_cpuid_PSE36(void)
 {
 	return 1;
@@ -626,35 +303,6 @@ static int is_nx(struct kvm_vcpu *vcpu)
 	return vcpu->arch.efer & EFER_NX;
 }
 
-static int is_shadow_present_pte(u64 pte)
-{
-	return (pte != 0) && !is_mmio_spte(pte);
-}
-
-static int is_large_pte(u64 pte)
-{
-	return pte & PT_PAGE_SIZE_MASK;
-}
-
-static int is_last_spte(u64 pte, int level)
-{
-	if (level == PG_LEVEL_4K)
-		return 1;
-	if (is_large_pte(pte))
-		return 1;
-	return 0;
-}
-
-static bool is_executable_pte(u64 spte)
-{
-	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
-}
-
-static kvm_pfn_t spte_to_pfn(u64 pte)
-{
-	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
-}
-
 static gfn_t pse36_gfn_delta(u32 gpte)
 {
 	int shift = 32 - PT32_DIR_PSE36_SHIFT - PAGE_SHIFT;
@@ -799,12 +447,6 @@ static u64 __get_spte_lockless(u64 *sptep)
 }
 #endif
 
-static bool spte_can_locklessly_be_made_writable(u64 spte)
-{
-	return (spte & (SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE)) ==
-		(SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE);
-}
-
 static bool spte_has_volatile_bits(u64 spte)
 {
 	if (!is_shadow_present_pte(spte))
@@ -829,21 +471,6 @@ static bool spte_has_volatile_bits(u64 spte)
 	return false;
 }
 
-static bool is_accessed_spte(u64 spte)
-{
-	u64 accessed_mask = spte_shadow_accessed_mask(spte);
-
-	return accessed_mask ? spte & accessed_mask
-			     : !is_access_track_spte(spte);
-}
-
-static bool is_dirty_spte(u64 spte)
-{
-	u64 dirty_mask = spte_shadow_dirty_mask(spte);
-
-	return dirty_mask ? spte & dirty_mask : spte & PT_WRITABLE_MASK;
-}
-
 /* Rules for using mmu_spte_set:
  * Set the sptep from nonpresent to present.
  * Note: the sptep being assigned *must* be either not present
@@ -979,34 +606,6 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
 	return __get_spte_lockless(sptep);
 }
 
-static u64 mark_spte_for_access_track(u64 spte)
-{
-	if (spte_ad_enabled(spte))
-		return spte & ~shadow_accessed_mask;
-
-	if (is_access_track_spte(spte))
-		return spte;
-
-	/*
-	 * Making an Access Tracking PTE will result in removal of write access
-	 * from the PTE. So, verify that we will be able to restore the write
-	 * access in the fast page fault path later on.
-	 */
-	WARN_ONCE((spte & PT_WRITABLE_MASK) &&
-		  !spte_can_locklessly_be_made_writable(spte),
-		  "kvm: Writable SPTE is not locklessly dirty-trackable\n");
-
-	WARN_ONCE(spte & (shadow_acc_track_saved_bits_mask <<
-			  shadow_acc_track_saved_bits_shift),
-		  "kvm: Access Tracking saved bit locations are not zero\n");
-
-	spte |= (spte & shadow_acc_track_saved_bits_mask) <<
-		shadow_acc_track_saved_bits_shift;
-	spte &= ~shadow_acc_track_mask;
-
-	return spte;
-}
-
 /* Restore an acc-track PTE back to a regular PTE */
 static u64 restore_acc_track_spte(u64 spte)
 {
@@ -1747,21 +1346,6 @@ static int kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	return kvm_zap_rmapp(kvm, rmap_head);
 }
 
-static u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
-{
-	u64 new_spte;
-
-	new_spte = old_spte & ~PT64_BASE_ADDR_MASK;
-	new_spte |= (u64)new_pfn << PAGE_SHIFT;
-
-	new_spte &= ~PT_WRITABLE_MASK;
-	new_spte &= ~SPTE_HOST_WRITEABLE;
-
-	new_spte = mark_spte_for_access_track(new_spte);
-
-	return new_spte;
-}
-
 static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			     struct kvm_memory_slot *slot, gfn_t gfn, int level,
 			     unsigned long data)
@@ -2583,21 +2167,6 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	__shadow_walk_next(iterator, *iterator->sptep);
 }
 
-static u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
-{
-	u64 spte;
-
-	spte = __pa(child_pt) | shadow_present_mask | PT_WRITABLE_MASK |
-	       shadow_user_mask | shadow_x_mask | shadow_me_mask;
-
-	if (ad_disabled)
-		spte |= SPTE_AD_DISABLED_MASK;
-	else
-		spte |= shadow_accessed_mask;
-
-	return spte;
-}
-
 static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 			     struct kvm_mmu_page *sp)
 {
@@ -2919,8 +2488,8 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	kvm_mmu_mark_parents_unsync(sp);
 }
 
-static bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
-				   bool can_unsync)
+bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
+			    bool can_unsync)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2980,116 +2549,6 @@ static bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return false;
 }
 
-static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
-{
-	if (pfn_valid(pfn))
-		return !is_zero_pfn(pfn) && PageReserved(pfn_to_page(pfn)) &&
-			/*
-			 * Some reserved pages, such as those from NVDIMM
-			 * DAX devices, are not for MMIO, and can be mapped
-			 * with cached memory type for better performance.
-			 * However, the above check misconceives those pages
-			 * as MMIO, and results in KVM mapping them with UC
-			 * memory type, which would hurt the performance.
-			 * Therefore, we check the host memory type in addition
-			 * and only treat UC/UC-/WC pages as MMIO.
-			 */
-			(!pat_enabled() || pat_pfn_immune_to_uc_mtrr(pfn));
-
-	return !e820__mapped_raw_any(pfn_to_hpa(pfn),
-				     pfn_to_hpa(pfn + 1) - 1,
-				     E820_TYPE_RAM);
-}
-
-/* Bits which may be returned by set_spte() */
-#define SET_SPTE_WRITE_PROTECTED_PT	BIT(0)
-#define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
-#define SET_SPTE_SPURIOUS		BIT(2)
-
-static int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
-		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
-		     bool can_unsync, bool host_writable, bool ad_disabled,
-		     u64 *new_spte)
-{
-	u64 spte = 0;
-	int ret = 0;
-
-	if (ad_disabled)
-		spte |= SPTE_AD_DISABLED_MASK;
-	else if (kvm_vcpu_ad_need_write_protect(vcpu))
-		spte |= SPTE_AD_WRPROT_ONLY_MASK;
-
-	/*
-	 * For the EPT case, shadow_present_mask is 0 if hardware
-	 * supports exec-only page table entries.  In that case,
-	 * ACC_USER_MASK and shadow_user_mask are used to represent
-	 * read access.  See FNAME(gpte_access) in paging_tmpl.h.
-	 */
-	spte |= shadow_present_mask;
-	if (!speculative)
-		spte |= spte_shadow_accessed_mask(spte);
-
-	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
-	    is_nx_huge_page_enabled()) {
-		pte_access &= ~ACC_EXEC_MASK;
-	}
-
-	if (pte_access & ACC_EXEC_MASK)
-		spte |= shadow_x_mask;
-	else
-		spte |= shadow_nx_mask;
-
-	if (pte_access & ACC_USER_MASK)
-		spte |= shadow_user_mask;
-
-	if (level > PG_LEVEL_4K)
-		spte |= PT_PAGE_SIZE_MASK;
-	if (tdp_enabled)
-		spte |= kvm_x86_ops.get_mt_mask(vcpu, gfn,
-			kvm_is_mmio_pfn(pfn));
-
-	if (host_writable)
-		spte |= SPTE_HOST_WRITEABLE;
-	else
-		pte_access &= ~ACC_WRITE_MASK;
-
-	if (!kvm_is_mmio_pfn(pfn))
-		spte |= shadow_me_mask;
-
-	spte |= (u64)pfn << PAGE_SHIFT;
-
-	if (pte_access & ACC_WRITE_MASK) {
-		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
-
-		/*
-		 * Optimization: for pte sync, if spte was writable the hash
-		 * lookup is unnecessary (and expensive). Write protection
-		 * is responsibility of mmu_get_page / kvm_sync_page.
-		 * Same reasoning can be applied to dirty page accounting.
-		 */
-		if (!can_unsync && is_writable_pte(old_spte))
-			goto out;
-
-		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
-			pgprintk("%s: found shadow page for %llx, marking ro\n",
-				 __func__, gfn);
-			ret |= SET_SPTE_WRITE_PROTECTED_PT;
-			pte_access &= ~ACC_WRITE_MASK;
-			spte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
-		}
-	}
-
-	if (pte_access & ACC_WRITE_MASK)
-		spte |= spte_shadow_dirty_mask(spte);
-
-	if (speculative)
-		spte = mark_spte_for_access_track(spte);
-
-out:
-	*new_spte = spte;
-	return ret;
-}
-
 static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    unsigned int pte_access, int level,
 		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 3acf3b8eb469..fc72f199eaa6 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -3,9 +3,23 @@
 #define __KVM_X86_MMU_INTERNAL_H
 
 #include <linux/types.h>
-
+#include <linux/kvm_host.h>
 #include <asm/kvm_host.h>
 
+#undef MMU_DEBUG
+
+#ifdef MMU_DEBUG
+extern bool dbg;
+
+#define pgprintk(x...) do { if (dbg) printk(x); } while (0)
+#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
+#define MMU_WARN_ON(x) WARN_ON(x)
+#else
+#define pgprintk(x...) do { } while (0)
+#define rmap_printk(x...) do { } while (0)
+#define MMU_WARN_ON(x) do { } while (0)
+#endif
+
 struct kvm_mmu_page {
 	struct list_head link;
 	struct hlist_node hash_link;
@@ -55,6 +69,21 @@ static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
 	return to_shadow_page(__pa(sptep));
 }
 
+static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * When using the EPT page-modification log, the GPAs in the log
+	 * would come from L2 rather than L1.  Therefore, we need to rely
+	 * on write protection to record dirty pages.  This also bypasses
+	 * PML, since writes now result in a vmexit.
+	 */
+	return vcpu->arch.mmu == &vcpu->arch.guest_mmu;
+}
+
+bool is_nx_huge_page_enabled(void);
+bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
+			    bool can_unsync);
+
 void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
new file mode 100644
index 000000000000..d9c5665a55e9
--- /dev/null
+++ b/arch/x86/kvm/mmu/spte.c
@@ -0,0 +1,318 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Kernel-based Virtual Machine driver for Linux
+ *
+ * Macros and functions to access KVM PTEs (also known as SPTEs)
+ *
+ * Copyright (C) 2006 Qumranet, Inc.
+ * Copyright 2020 Red Hat, Inc. and/or its affiliates.
+ */
+
+
+#include <linux/kvm_host.h>
+#include "mmu.h"
+#include "mmu_internal.h"
+#include "x86.h"
+#include "spte.h"
+
+#include <asm/e820/api.h>
+
+u64 __read_mostly shadow_nx_mask;
+u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
+u64 __read_mostly shadow_user_mask;
+u64 __read_mostly shadow_accessed_mask;
+u64 __read_mostly shadow_dirty_mask;
+u64 __read_mostly shadow_mmio_value;
+u64 __read_mostly shadow_mmio_access_mask;
+u64 __read_mostly shadow_present_mask;
+u64 __read_mostly shadow_me_mask;
+u64 __read_mostly shadow_acc_track_mask;
+
+u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
+u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
+
+u8 __read_mostly shadow_phys_bits;
+
+static u64 generation_mmio_spte_mask(u64 gen)
+{
+	u64 mask;
+
+	WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
+	BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_SPECIAL_MASK);
+
+	mask = (gen << MMIO_SPTE_GEN_LOW_START) & MMIO_SPTE_GEN_LOW_MASK;
+	mask |= (gen << MMIO_SPTE_GEN_HIGH_START) & MMIO_SPTE_GEN_HIGH_MASK;
+	return mask;
+}
+
+u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
+{
+	u64 gen = kvm_vcpu_memslots(vcpu)->generation & MMIO_SPTE_GEN_MASK;
+	u64 mask = generation_mmio_spte_mask(gen);
+	u64 gpa = gfn << PAGE_SHIFT;
+
+	access &= shadow_mmio_access_mask;
+	mask |= shadow_mmio_value | access;
+	mask |= gpa | shadow_nonpresent_or_rsvd_mask;
+	mask |= (gpa & shadow_nonpresent_or_rsvd_mask)
+		<< shadow_nonpresent_or_rsvd_mask_len;
+
+	return mask;
+}
+
+static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
+{
+	if (pfn_valid(pfn))
+		return !is_zero_pfn(pfn) && PageReserved(pfn_to_page(pfn)) &&
+			/*
+			 * Some reserved pages, such as those from NVDIMM
+			 * DAX devices, are not for MMIO, and can be mapped
+			 * with cached memory type for better performance.
+			 * However, the above check misconceives those pages
+			 * as MMIO, and results in KVM mapping them with UC
+			 * memory type, which would hurt the performance.
+			 * Therefore, we check the host memory type in addition
+			 * and only treat UC/UC-/WC pages as MMIO.
+			 */
+			(!pat_enabled() || pat_pfn_immune_to_uc_mtrr(pfn));
+
+	return !e820__mapped_raw_any(pfn_to_hpa(pfn),
+				     pfn_to_hpa(pfn + 1) - 1,
+				     E820_TYPE_RAM);
+}
+
+int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
+		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
+		     bool can_unsync, bool host_writable, bool ad_disabled,
+		     u64 *new_spte)
+{
+	u64 spte = 0;
+	int ret = 0;
+
+	if (ad_disabled)
+		spte |= SPTE_AD_DISABLED_MASK;
+	else if (kvm_vcpu_ad_need_write_protect(vcpu))
+		spte |= SPTE_AD_WRPROT_ONLY_MASK;
+
+	/*
+	 * For the EPT case, shadow_present_mask is 0 if hardware
+	 * supports exec-only page table entries.  In that case,
+	 * ACC_USER_MASK and shadow_user_mask are used to represent
+	 * read access.  See FNAME(gpte_access) in paging_tmpl.h.
+	 */
+	spte |= shadow_present_mask;
+	if (!speculative)
+		spte |= spte_shadow_accessed_mask(spte);
+
+	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
+	    is_nx_huge_page_enabled()) {
+		pte_access &= ~ACC_EXEC_MASK;
+	}
+
+	if (pte_access & ACC_EXEC_MASK)
+		spte |= shadow_x_mask;
+	else
+		spte |= shadow_nx_mask;
+
+	if (pte_access & ACC_USER_MASK)
+		spte |= shadow_user_mask;
+
+	if (level > PG_LEVEL_4K)
+		spte |= PT_PAGE_SIZE_MASK;
+	if (tdp_enabled)
+		spte |= kvm_x86_ops.get_mt_mask(vcpu, gfn,
+			kvm_is_mmio_pfn(pfn));
+
+	if (host_writable)
+		spte |= SPTE_HOST_WRITEABLE;
+	else
+		pte_access &= ~ACC_WRITE_MASK;
+
+	if (!kvm_is_mmio_pfn(pfn))
+		spte |= shadow_me_mask;
+
+	spte |= (u64)pfn << PAGE_SHIFT;
+
+	if (pte_access & ACC_WRITE_MASK) {
+		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
+
+		/*
+		 * Optimization: for pte sync, if spte was writable the hash
+		 * lookup is unnecessary (and expensive). Write protection
+		 * is responsibility of mmu_get_page / kvm_sync_page.
+		 * Same reasoning can be applied to dirty page accounting.
+		 */
+		if (!can_unsync && is_writable_pte(old_spte))
+			goto out;
+
+		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
+			pgprintk("%s: found shadow page for %llx, marking ro\n",
+				 __func__, gfn);
+			ret |= SET_SPTE_WRITE_PROTECTED_PT;
+			pte_access &= ~ACC_WRITE_MASK;
+			spte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
+		}
+	}
+
+	if (pte_access & ACC_WRITE_MASK)
+		spte |= spte_shadow_dirty_mask(spte);
+
+	if (speculative)
+		spte = mark_spte_for_access_track(spte);
+
+out:
+	*new_spte = spte;
+	return ret;
+}
+
+u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
+{
+	u64 spte;
+
+	spte = __pa(child_pt) | shadow_present_mask | PT_WRITABLE_MASK |
+	       shadow_user_mask | shadow_x_mask | shadow_me_mask;
+
+	if (ad_disabled)
+		spte |= SPTE_AD_DISABLED_MASK;
+	else
+		spte |= shadow_accessed_mask;
+
+	return spte;
+}
+
+u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
+{
+	u64 new_spte;
+
+	new_spte = old_spte & ~PT64_BASE_ADDR_MASK;
+	new_spte |= (u64)new_pfn << PAGE_SHIFT;
+
+	new_spte &= ~PT_WRITABLE_MASK;
+	new_spte &= ~SPTE_HOST_WRITEABLE;
+
+	new_spte = mark_spte_for_access_track(new_spte);
+
+	return new_spte;
+}
+
+static u8 kvm_get_shadow_phys_bits(void)
+{
+	/*
+	 * boot_cpu_data.x86_phys_bits is reduced when MKTME or SME are detected
+	 * in CPU detection code, but the processor treats those reduced bits as
+	 * 'keyID' thus they are not reserved bits. Therefore KVM needs to look at
+	 * the physical address bits reported by CPUID.
+	 */
+	if (likely(boot_cpu_data.extended_cpuid_level >= 0x80000008))
+		return cpuid_eax(0x80000008) & 0xff;
+
+	/*
+	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
+	 * custom CPUID.  Proceed with whatever the kernel found since these features
+	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
+	 */
+	return boot_cpu_data.x86_phys_bits;
+}
+
+u64 mark_spte_for_access_track(u64 spte)
+{
+	if (spte_ad_enabled(spte))
+		return spte & ~shadow_accessed_mask;
+
+	if (is_access_track_spte(spte))
+		return spte;
+
+	/*
+	 * Making an Access Tracking PTE will result in removal of write access
+	 * from the PTE. So, verify that we will be able to restore the write
+	 * access in the fast page fault path later on.
+	 */
+	WARN_ONCE((spte & PT_WRITABLE_MASK) &&
+		  !spte_can_locklessly_be_made_writable(spte),
+		  "kvm: Writable SPTE is not locklessly dirty-trackable\n");
+
+	WARN_ONCE(spte & (shadow_acc_track_saved_bits_mask <<
+			  shadow_acc_track_saved_bits_shift),
+		  "kvm: Access Tracking saved bit locations are not zero\n");
+
+	spte |= (spte & shadow_acc_track_saved_bits_mask) <<
+		shadow_acc_track_saved_bits_shift;
+	spte &= ~shadow_acc_track_mask;
+
+	return spte;
+}
+
+void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask)
+{
+	BUG_ON((u64)(unsigned)access_mask != access_mask);
+	WARN_ON(mmio_value & (shadow_nonpresent_or_rsvd_mask << shadow_nonpresent_or_rsvd_mask_len));
+	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
+	shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
+	shadow_mmio_access_mask = access_mask;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
+
+/*
+ * Sets the shadow PTE masks used by the MMU.
+ *
+ * Assumptions:
+ *  - Setting either @accessed_mask or @dirty_mask requires setting both
+ *  - At least one of @accessed_mask or @acc_track_mask must be set
+ */
+void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
+		u64 dirty_mask, u64 nx_mask, u64 x_mask, u64 p_mask,
+		u64 acc_track_mask, u64 me_mask)
+{
+	BUG_ON(!dirty_mask != !accessed_mask);
+	BUG_ON(!accessed_mask && !acc_track_mask);
+	BUG_ON(acc_track_mask & SPTE_SPECIAL_MASK);
+
+	shadow_user_mask = user_mask;
+	shadow_accessed_mask = accessed_mask;
+	shadow_dirty_mask = dirty_mask;
+	shadow_nx_mask = nx_mask;
+	shadow_x_mask = x_mask;
+	shadow_present_mask = p_mask;
+	shadow_acc_track_mask = acc_track_mask;
+	shadow_me_mask = me_mask;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
+
+void kvm_mmu_reset_all_pte_masks(void)
+{
+	u8 low_phys_bits;
+
+	shadow_user_mask = 0;
+	shadow_accessed_mask = 0;
+	shadow_dirty_mask = 0;
+	shadow_nx_mask = 0;
+	shadow_x_mask = 0;
+	shadow_present_mask = 0;
+	shadow_acc_track_mask = 0;
+
+	shadow_phys_bits = kvm_get_shadow_phys_bits();
+
+	/*
+	 * If the CPU has 46 or less physical address bits, then set an
+	 * appropriate mask to guard against L1TF attacks. Otherwise, it is
+	 * assumed that the CPU is not vulnerable to L1TF.
+	 *
+	 * Some Intel CPUs address the L1 cache using more PA bits than are
+	 * reported by CPUID. Use the PA width of the L1 cache when possible
+	 * to achieve more effective mitigation, e.g. if system RAM overlaps
+	 * the most significant bits of legal physical address space.
+	 */
+	shadow_nonpresent_or_rsvd_mask = 0;
+	low_phys_bits = boot_cpu_data.x86_phys_bits;
+	if (boot_cpu_has_bug(X86_BUG_L1TF) &&
+	    !WARN_ON_ONCE(boot_cpu_data.x86_cache_bits >=
+			  52 - shadow_nonpresent_or_rsvd_mask_len)) {
+		low_phys_bits = boot_cpu_data.x86_cache_bits
+			- shadow_nonpresent_or_rsvd_mask_len;
+		shadow_nonpresent_or_rsvd_mask =
+			rsvd_bits(low_phys_bits, boot_cpu_data.x86_cache_bits - 1);
+	}
+
+	shadow_nonpresent_or_rsvd_lower_gfn_mask =
+		GENMASK_ULL(low_phys_bits - 1, PAGE_SHIFT);
+}
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
new file mode 100644
index 000000000000..4ecf40e0b8fe
--- /dev/null
+++ b/arch/x86/kvm/mmu/spte.h
@@ -0,0 +1,252 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#ifndef KVM_X86_MMU_SPTE_H
+#define KVM_X86_MMU_SPTE_H
+
+#include "mmu_internal.h"
+
+#define PT_FIRST_AVAIL_BITS_SHIFT 10
+#define PT64_SECOND_AVAIL_BITS_SHIFT 54
+
+/*
+ * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
+ * Access Tracking SPTEs.
+ */
+#define SPTE_SPECIAL_MASK (3ULL << 52)
+#define SPTE_AD_ENABLED_MASK (0ULL << 52)
+#define SPTE_AD_DISABLED_MASK (1ULL << 52)
+#define SPTE_AD_WRPROT_ONLY_MASK (2ULL << 52)
+#define SPTE_MMIO_MASK (3ULL << 52)
+
+#ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
+#define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
+#else
+#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
+#endif
+#define PT64_LVL_ADDR_MASK(level) \
+	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT64_LEVEL_BITS))) - 1))
+#define PT64_LVL_OFFSET_MASK(level) \
+	(PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT64_LEVEL_BITS))) - 1))
+
+#define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
+			| shadow_x_mask | shadow_nx_mask | shadow_me_mask)
+
+#define ACC_EXEC_MASK    1
+#define ACC_WRITE_MASK   PT_WRITABLE_MASK
+#define ACC_USER_MASK    PT_USER_MASK
+#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
+
+/* The mask for the R/X bits in EPT PTEs */
+#define PT64_EPT_READABLE_MASK			0x1ull
+#define PT64_EPT_EXECUTABLE_MASK		0x4ull
+
+#define PT64_LEVEL_BITS 9
+
+#define PT64_LEVEL_SHIFT(level) \
+		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
+
+#define PT64_INDEX(address, level)\
+	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
+#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
+
+
+#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
+
+/*
+ * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
+ * the memslots generation and is derived as follows:
+ *
+ * Bits 0-8 of the MMIO generation are propagated to spte bits 3-11
+ * Bits 9-18 of the MMIO generation are propagated to spte bits 52-61
+ *
+ * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
+ * the MMIO generation number, as doing so would require stealing a bit from
+ * the "real" generation number and thus effectively halve the maximum number
+ * of MMIO generations that can be handled before encountering a wrap (which
+ * requires a full MMU zap).  The flag is instead explicitly queried when
+ * checking for MMIO spte cache hits.
+ */
+#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(17, 0)
+
+#define MMIO_SPTE_GEN_LOW_START		3
+#define MMIO_SPTE_GEN_LOW_END		11
+#define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
+						    MMIO_SPTE_GEN_LOW_START)
+
+#define MMIO_SPTE_GEN_HIGH_START	PT64_SECOND_AVAIL_BITS_SHIFT
+#define MMIO_SPTE_GEN_HIGH_END		62
+#define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
+						    MMIO_SPTE_GEN_HIGH_START)
+
+extern u64 __read_mostly shadow_nx_mask;
+extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
+extern u64 __read_mostly shadow_user_mask;
+extern u64 __read_mostly shadow_accessed_mask;
+extern u64 __read_mostly shadow_dirty_mask;
+extern u64 __read_mostly shadow_mmio_value;
+extern u64 __read_mostly shadow_mmio_access_mask;
+extern u64 __read_mostly shadow_present_mask;
+extern u64 __read_mostly shadow_me_mask;
+
+/*
+ * SPTEs used by MMUs without A/D bits are marked with SPTE_AD_DISABLED_MASK;
+ * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
+ * pages.
+ */
+extern u64 __read_mostly shadow_acc_track_mask;
+
+/*
+ * This mask must be set on all non-zero Non-Present or Reserved SPTEs in order
+ * to guard against L1TF attacks.
+ */
+extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
+
+/*
+ * The mask/shift to use for saving the original R/X bits when marking the PTE
+ * as not-present for access tracking purposes. We do not save the W bit as the
+ * PTEs being access tracked also need to be dirty tracked, so the W bit will be
+ * restored only when a write is attempted to the page.
+ */
+static const u64 shadow_acc_track_saved_bits_mask = PT64_EPT_READABLE_MASK |
+						    PT64_EPT_EXECUTABLE_MASK;
+static const u64 shadow_acc_track_saved_bits_shift = PT64_SECOND_AVAIL_BITS_SHIFT;
+
+/*
+ * The number of high-order 1 bits to use in the mask above.
+ */
+static const u64 shadow_nonpresent_or_rsvd_mask_len = 5;
+
+/*
+ * In some cases, we need to preserve the GFN of a non-present or reserved
+ * SPTE when we usurp the upper five bits of the physical address space to
+ * defend against L1TF, e.g. for MMIO SPTEs.  To preserve the GFN, we'll
+ * shift bits of the GFN that overlap with shadow_nonpresent_or_rsvd_mask
+ * left into the reserved bits, i.e. the GFN in the SPTE will be split into
+ * high and low parts.  This mask covers the lower bits of the GFN.
+ */
+extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
+
+/*
+ * The number of non-reserved physical address bits irrespective of features
+ * that repurpose legal bits, e.g. MKTME.
+ */
+extern u8 __read_mostly shadow_phys_bits;
+
+static inline bool is_mmio_spte(u64 spte)
+{
+	return (spte & SPTE_SPECIAL_MASK) == SPTE_MMIO_MASK;
+}
+
+static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
+{
+	return sp->role.ad_disabled;
+}
+
+static inline bool spte_ad_enabled(u64 spte)
+{
+	MMU_WARN_ON(is_mmio_spte(spte));
+	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_DISABLED_MASK;
+}
+
+static inline bool spte_ad_need_write_protect(u64 spte)
+{
+	MMU_WARN_ON(is_mmio_spte(spte));
+	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_ENABLED_MASK;
+}
+
+static inline u64 spte_shadow_accessed_mask(u64 spte)
+{
+	MMU_WARN_ON(is_mmio_spte(spte));
+	return spte_ad_enabled(spte) ? shadow_accessed_mask : 0;
+}
+
+static inline u64 spte_shadow_dirty_mask(u64 spte)
+{
+	MMU_WARN_ON(is_mmio_spte(spte));
+	return spte_ad_enabled(spte) ? shadow_dirty_mask : 0;
+}
+
+static inline bool is_access_track_spte(u64 spte)
+{
+	return !spte_ad_enabled(spte) && (spte & shadow_acc_track_mask) == 0;
+}
+
+static inline int is_shadow_present_pte(u64 pte)
+{
+	return (pte != 0) && !is_mmio_spte(pte);
+}
+
+static inline int is_large_pte(u64 pte)
+{
+	return pte & PT_PAGE_SIZE_MASK;
+}
+
+static inline int is_last_spte(u64 pte, int level)
+{
+	if (level == PG_LEVEL_4K)
+		return 1;
+	if (is_large_pte(pte))
+		return 1;
+	return 0;
+}
+
+static inline bool is_executable_pte(u64 spte)
+{
+	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
+}
+
+static inline kvm_pfn_t spte_to_pfn(u64 pte)
+{
+	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+}
+
+static inline bool is_accessed_spte(u64 spte)
+{
+	u64 accessed_mask = spte_shadow_accessed_mask(spte);
+
+	return accessed_mask ? spte & accessed_mask
+			     : !is_access_track_spte(spte);
+}
+
+static inline bool is_dirty_spte(u64 spte)
+{
+	u64 dirty_mask = spte_shadow_dirty_mask(spte);
+
+	return dirty_mask ? spte & dirty_mask : spte & PT_WRITABLE_MASK;
+}
+
+static inline bool spte_can_locklessly_be_made_writable(u64 spte)
+{
+	return (spte & (SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE)) ==
+		(SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE);
+}
+
+static inline u64 get_mmio_spte_generation(u64 spte)
+{
+	u64 gen;
+
+	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_START;
+	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_START;
+	return gen;
+}
+
+/* Bits which may be returned by set_spte() */
+#define SET_SPTE_WRITE_PROTECTED_PT    BIT(0)
+#define SET_SPTE_NEED_REMOTE_TLB_FLUSH BIT(1)
+#define SET_SPTE_SPURIOUS              BIT(2)
+
+int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
+		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
+		     bool can_unsync, bool host_writable, bool ad_disabled,
+		     u64 *new_spte);
+u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
+u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
+u64 mark_spte_for_access_track(u64 spte);
+u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
+
+void kvm_mmu_reset_all_pte_masks(void);
+
+#endif
-- 
2.26.2


