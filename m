Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB31523D0D5
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgHETxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgHEQuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 12:50:20 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E84C0A893A;
        Wed,  5 Aug 2020 07:12:07 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id w17so25307259ply.11;
        Wed, 05 Aug 2020 07:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NFXipDhiZCZ3xOixjvwfPnvuyeXFxxM0MuhTheiJ4p4=;
        b=Z9nUHyMa2vU7KbGKoMXl90fqXcIhc7h6kQLrfAxucoZcHqMP5hb851GEV7+ey9jwem
         75qNus2hqMjctrwcllMNXHg6U0DoMq/KxOnto4S9gG8BIBLpdNRF6zI1LkOvT+9eKQIQ
         ER6JKEx1Nx+aL6MfNj2ge+6VQNARlDatqkwTx1a8PIsQ+A5pJ/IcqWT6gvo78+f/jD0c
         f7wVvvDHJQwbscEUYegxXjSsXent5tHvADUnFfUIITymuXsPJcKp8BhvwVy4UltoEYgJ
         DmMibDrewrWNu0LPbd9Pjlb40F5A11HD1BGVp1bwBWUpg6DpetNSb9C2qTrDKPEf/E4d
         xDig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NFXipDhiZCZ3xOixjvwfPnvuyeXFxxM0MuhTheiJ4p4=;
        b=H7NnHyWMOEAMvxzgYIt2W8yx99rfHfRQvTrg6sndE4EYyYXCp0wdMDUQzcSeaOCiTJ
         MsHYJR+ppkVef96w6LSZQa6a+CFb7A45DmFuYspv2Tw1Wo74hazpWjZwVpL3CjnCQVJT
         ULlvgqYrzyd7CZjy8q6/RkNVJ2i1nIErlo9fBezfwvRcauc6+k5XPQy1HW6lq7XHLi3W
         EC5IvlCDsPBvqvAT5gZiJnVQ1YW6ix1qWM+L0oFAktk/LpD5JNfwXCUXM02VTiwOkAZy
         e+5O34gfaE64eM29xtbaznW2qfCQE9IWdUjNZLvlwDTy443/adbXkoxp6A3AkmFFI32q
         fqhw==
X-Gm-Message-State: AOAM533ailxoDF8Hx0JYqttLyFdhQssd8E7//dCgHAS1jARYjMvkE6Z8
        A7Kq5Rwjpi+GcifCvkLm3mM=
X-Google-Smtp-Source: ABdhPJzGSjXBd0ga8725gfRLIG9DImnG2E4CBV+/W7JuBz+av6wlo44mKw7nFMoR7TSmux5RUd6Xew==
X-Received: by 2002:a17:902:7d8b:: with SMTP id a11mr3049149plm.342.1596636726942;
        Wed, 05 Aug 2020 07:12:06 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.62])
        by smtp.gmail.com with ESMTPSA id q18sm3632943pfn.106.2020.08.05.07.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 07:12:06 -0700 (PDT)
From:   Yulei Zhang <yulei.kernel@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, xiaoguangrong.eric@gmail.com,
        kernellwp@gmail.com, lihaiwei.kernel@gmail.com,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC 2/9] Introduce page table population function for direct build EPT feature
Date:   Wed,  5 Aug 2020 22:12:57 +0800
Message-Id: <20200805141257.8841-1-yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yuleixzhang@tencent.com>

Page table population function will pin the memory and pre-construct
the EPT base on the input memory slot configuration so that it won't
relay on the page fault interrupt to setup the page table.

Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |   2 +-
 arch/x86/kvm/mmu/mmu.c          | 212 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c          |   2 +-
 arch/x86/kvm/vmx/vmx.c          |  17 ++-
 include/linux/kvm_host.h        |   4 +-
 virt/kvm/kvm_main.c             |  30 ++++-
 6 files changed, 250 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2407b872f493..69c946831ca7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1152,7 +1152,7 @@ struct kvm_x86_ops {
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
 	int (*get_tdp_level)(struct kvm_vcpu *vcpu);
-	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+	u64 (*get_mt_mask)(struct kvm *kvm, struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 70cf2c1a1423..1609012be67d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -235,6 +235,11 @@ struct kvm_shadow_walk_iterator {
 		({ spte = mmu_spte_get_lockless(_walker.sptep); 1; });	\
 	     __shadow_walk_next(&(_walker), spte))
 
+#define for_each_direct_build_shadow_entry(_walker, shadow_addr, _addr, level)	\
+	for (__shadow_walk_init(&(_walker), shadow_addr, _addr, level);		\
+	     shadow_walk_okay(&(_walker));					\
+	     shadow_walk_next(&(_walker)))
+
 static struct kmem_cache *pte_list_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
@@ -2564,13 +2569,20 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
+static void __shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
+			       hpa_t shadow_addr, u64 addr, int level)
+{
+	iterator->addr = addr;
+	iterator->shadow_addr = shadow_addr;
+	iterator->level = level;
+	iterator->sptep = NULL;
+}
+
 static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
 					struct kvm_vcpu *vcpu, hpa_t root,
 					u64 addr)
 {
-	iterator->addr = addr;
-	iterator->shadow_addr = root;
-	iterator->level = vcpu->arch.mmu->shadow_root_level;
+	__shadow_walk_init(iterator, root, addr, vcpu->arch.mmu->shadow_root_level);
 
 	if (iterator->level == PT64_ROOT_4LEVEL &&
 	    vcpu->arch.mmu->root_level < PT64_ROOT_4LEVEL &&
@@ -3037,7 +3049,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (tdp_enabled)
-		spte |= kvm_x86_ops.get_mt_mask(vcpu, gfn,
+		spte |= kvm_x86_ops.get_mt_mask(vcpu->kvm, vcpu, gfn,
 			kvm_is_mmio_pfn(pfn));
 
 	if (host_writable)
@@ -6250,6 +6262,198 @@ int kvm_mmu_module_init(void)
 	return ret;
 }
 
+static int direct_build_tdp_set_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
+		    u64 *sptep, unsigned pte_access, int level,
+		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
+		    bool dirty, bool host_writable)
+{
+	u64 spte = 0;
+	int ret = 0;
+	/*
+	 * For the EPT case, shadow_present_mask is 0 if hardware
+	 * supports exec-only page table entries.  In that case,
+	 * ACC_USER_MASK and shadow_user_mask are used to represent
+	 * read access.  See FNAME(gpte_access) in paging_tmpl.h.
+	 */
+	spte |= shadow_present_mask;
+	if (!speculative)
+		spte |= shadow_accessed_mask;
+
+	if (level > PT_PAGE_TABLE_LEVEL && (pte_access & ACC_EXEC_MASK) &&
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
+	if (level > PT_PAGE_TABLE_LEVEL)
+		spte |= PT_PAGE_SIZE_MASK;
+
+	if (tdp_enabled)
+		spte |= kvm_x86_ops.get_mt_mask(kvm, NULL, gfn, kvm_is_mmio_pfn(pfn));
+
+	if (host_writable)
+		spte |= SPTE_HOST_WRITEABLE;
+	else
+		pte_access &= ~ACC_WRITE_MASK;
+
+	spte |= (u64)pfn << PAGE_SHIFT;
+
+	if (pte_access & ACC_WRITE_MASK) {
+
+		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
+
+		if (dirty) {
+			mark_page_dirty_in_slot(slot, gfn);
+			spte |= shadow_dirty_mask;
+		}
+	}
+
+	if (mmu_spte_update(sptep, spte))
+		kvm_flush_remote_tlbs(kvm);
+
+	return ret;
+}
+
+static void __kvm_walk_global_page(struct kvm *kvm, u64 addr, int level)
+{
+	int i;
+	kvm_pfn_t pfn;
+	u64 *sptep = (u64 *)__va(addr);
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
+		if (is_shadow_present_pte(sptep[i])) {
+			if (!is_last_spte(sptep[i], level)) {
+				__kvm_walk_global_page(kvm, sptep[i] & PT64_BASE_ADDR_MASK, level - 1);
+			} else {
+				pfn = spte_to_pfn(sptep[i]);
+				mmu_spte_clear_track_bits(&sptep[i]);
+				kvm_release_pfn_clean(pfn);
+			}
+		}
+	}
+	put_page(pfn_to_page(addr >> PAGE_SHIFT));
+}
+
+static int direct_build_tdp_map(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn,
+				kvm_pfn_t pfn, int level)
+{
+	int ret = 0;
+
+	struct kvm_shadow_walk_iterator iterator;
+	kvm_pfn_t old_pfn;
+	u64 spte;
+
+	for_each_direct_build_shadow_entry(iterator, kvm->arch.global_root_hpa,
+				gfn << PAGE_SHIFT, kvm_x86_ops.get_tdp_level(NULL)) {
+		if (iterator.level == level) {
+			break;
+		}
+
+		if (!is_shadow_present_pte(*iterator.sptep)) {
+			struct page *page;
+			page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+			if (!page)
+				return 0;
+
+			spte = page_to_phys(page) | PT_PRESENT_MASK | PT_WRITABLE_MASK |
+				shadow_user_mask | shadow_x_mask | shadow_accessed_mask;
+			mmu_spte_set(iterator.sptep, spte);
+		}
+	}
+	/* if presented pte, release the original pfn  */
+	if (is_shadow_present_pte(*iterator.sptep)) {
+		if (level > PT_PAGE_TABLE_LEVEL)
+			__kvm_walk_global_page(kvm, (*iterator.sptep) & PT64_BASE_ADDR_MASK, level - 1);
+		else {
+			old_pfn = spte_to_pfn(*iterator.sptep);
+			mmu_spte_clear_track_bits(iterator.sptep);
+			kvm_release_pfn_clean(old_pfn);
+		}
+	}
+	direct_build_tdp_set_spte(kvm, slot, iterator.sptep, ACC_ALL, level, gfn, pfn, false, true, true);
+
+	return ret;
+}
+
+static int host_mapping_level(struct kvm *kvm, gfn_t gfn)
+{
+	unsigned long page_size;
+	int i, ret = 0;
+
+	page_size = kvm_host_page_size(kvm, NULL, gfn);
+
+	for (i = PT_PAGE_TABLE_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
+		if (page_size >= KVM_HPAGE_SIZE(i))
+			ret = i;
+		else
+			break;
+	}
+
+	return ret;
+}
+
+int direct_build_mapping_level(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	int host_level, max_level, level;
+	struct kvm_lpage_info *linfo;
+
+	host_level = host_mapping_level(kvm, gfn);
+	if (host_level != PT_PAGE_TABLE_LEVEL) {
+		max_level = min(max_page_level, host_level);
+		for (level = PT_DIRECTORY_LEVEL; level <= max_level; ++level) {
+			linfo = lpage_info_slot(gfn, slot, level);
+			if (linfo->disallow_lpage)
+				break;
+		}
+		host_level = level - 1;
+	}
+	return host_level;
+}
+
+int kvm_direct_tdp_populate_page_table(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	gfn_t gfn;
+	kvm_pfn_t pfn;
+	int host_level;
+
+	if (!kvm->arch.global_root_hpa) {
+		struct page *page;
+		WARN_ON(!tdp_enabled);
+		WARN_ON(kvm_x86_ops.get_tdp_level(NULL) != PT64_ROOT_4LEVEL);
+
+		/* init global root hpa */
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			return -ENOMEM;
+
+		kvm->arch.global_root_hpa = page_to_phys(page);
+	}
+
+	/* setup page table for the slot */
+	for (gfn = slot->base_gfn;
+		gfn < slot->base_gfn + slot->npages;
+		gfn += KVM_PAGES_PER_HPAGE(host_level)) {
+		pfn = gfn_to_pfn_try_write(slot, gfn);
+		if ((pfn & KVM_PFN_ERR_FAULT) || is_noslot_pfn(pfn))
+			return -ENOMEM;
+
+		host_level = direct_build_mapping_level(kvm, slot, gfn);
+
+		if (host_level > PT_PAGE_TABLE_LEVEL)
+			MMU_WARN_ON(gfn & (KVM_PAGES_PER_HPAGE(host_level) - 1));
+		direct_build_tdp_map(kvm, slot, gfn, pfn, host_level);
+	}
+
+	return 0;
+}
+
 /*
  * Calculate mmu pages needed for kvm.
  */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a862c768fd54..40819ed00bf2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3488,7 +3488,7 @@ static bool svm_has_emulated_msr(int index)
 	return true;
 }
 
-static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+static u64 svm_get_mt_mask(struct kvm *kvm, struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8fafcb2cd103..4b8728c713ff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2972,10 +2972,12 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 static int get_ept_level(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu) && nested_cpu_has_ept(get_vmcs12(vcpu)))
-		return vmx_eptp_page_walk_level(nested_ept_get_eptp(vcpu));
-	if (cpu_has_vmx_ept_5levels() && (cpuid_maxphyaddr(vcpu) > 48))
-		return 5;
+	if (vcpu) {
+		if (is_guest_mode(vcpu) && nested_cpu_has_ept(get_vmcs12(vcpu)))
+			return vmx_eptp_page_walk_level(nested_ept_get_eptp(vcpu));
+		if (cpu_has_vmx_ept_5levels() && (cpuid_maxphyaddr(vcpu) > 48))
+			return 5;
+	}
 	return 4;
 }
 
@@ -6861,7 +6863,7 @@ static int __init vmx_check_processor_compat(void)
 	return 0;
 }
 
-static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+static u64 vmx_get_mt_mask(struct kvm *kvm, struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	u8 cache;
 	u64 ipat = 0;
@@ -6889,12 +6891,15 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 		goto exit;
 	}
 
-	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
+	if (!kvm_arch_has_noncoherent_dma(kvm)) {
 		ipat = VMX_EPT_IPAT_BIT;
 		cache = MTRR_TYPE_WRBACK;
 		goto exit;
 	}
 
+	if (!vcpu)
+		vcpu = kvm->vcpus[0];
+
 	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
 		ipat = VMX_EPT_IPAT_BIT;
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 92efa39ea3d7..d1f75ad5038b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -693,6 +693,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
 /* flush all memory translations */
 void kvm_arch_flush_shadow_all(struct kvm *kvm);
 /* flush memory translations pointing to 'slot' */
@@ -720,6 +721,7 @@ kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
 			       bool *writable);
+kvm_pfn_t gfn_to_pfn_try_write(struct kvm_memory_slot *slot, gfn_t gfn);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
@@ -770,7 +772,7 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
-unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
+unsigned long kvm_host_page_size(struct kvm *kvm, struct kvm_vcpu *vcpu, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 77aa91fb08d2..46217b1c8353 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -144,7 +144,7 @@ static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
 
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
@@ -1629,14 +1629,17 @@ bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
 
-unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
+unsigned long kvm_host_page_size(struct kvm *kvm, struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	struct vm_area_struct *vma;
 	unsigned long addr, size;
 
 	size = PAGE_SIZE;
 
-	addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gfn, NULL);
+	if (vcpu)
+		addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gfn, NULL);
+	else
+		addr = gfn_to_hva(kvm, gfn);
 	if (kvm_is_error_hva(addr))
 		return PAGE_SIZE;
 
@@ -1931,6 +1934,25 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	return pfn;
 }
 
+/* Map pfn for direct EPT mode, if map failed and it is readonly memslot,
+ * will try to remap it with readonly flag.
+ */
+kvm_pfn_t gfn_to_pfn_try_write(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	kvm_pfn_t pfn;
+	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, !memslot_is_readonly(slot));
+
+	if (kvm_is_error_hva(addr))
+		return KVM_PFN_NOSLOT;
+
+	pfn = hva_to_pfn(addr, false, NULL, true, NULL);
+	if (pfn & KVM_PFN_ERR_FAULT) {
+		if (memslot_is_readonly(slot))
+			pfn = hva_to_pfn(addr, false, NULL, false, NULL);
+	}
+	return pfn;
+}
+
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
 			       bool *writable)
@@ -2571,7 +2593,7 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
 				    gfn_t gfn)
 {
 	if (memslot && memslot->dirty_bitmap) {
-- 
2.17.1

