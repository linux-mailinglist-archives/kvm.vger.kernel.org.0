Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECEA57957C
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 10:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbiGSIrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 04:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236443AbiGSIrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 04:47:42 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8536D3C8D6;
        Tue, 19 Jul 2022 01:47:40 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id g4so12909849pgc.1;
        Tue, 19 Jul 2022 01:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cnEQJnSVFSLVIXSoPoSAlarBbvdIc2wQ0ViMWDUzIAE=;
        b=XQBws9v3VZo/TFPU3rdGdSDJuwGpEQcucrw6FwvwG/yOOpZrtQ+GB030IcqyaLHvZ0
         Z8u57QG3Vp45eNx1L5avCbnhjOAOYxRjjd1VorDoGdn4THGiC0z/cGvNL57RjSip0t7A
         mDAMgeIQ8XEJv5yZzSymkgIrn0NCe2GeNwGPEPpPiti4cFuT6ykHr6rcHRwkGVrmWua8
         KgFUt4GBkNZMaYrrEL9YX9reJmw3+++X+ghB5ytYce7FMMUWQyLx9LNGhQ/b/YnEZbjB
         BAr6Uw38MgwybrwB31YPZu88CpA70YBYrLg0A+1mVZxbs3jD77nkGRUekrXbDcs8BSOT
         MGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cnEQJnSVFSLVIXSoPoSAlarBbvdIc2wQ0ViMWDUzIAE=;
        b=W0gcu72MaPcrhdFFSKhWwmJpHNbKwzPYIWeF1OXqHMJN9T3CYfyk9+qsZTWvpjGKo6
         S/tY0GO1vKp/0lytLvjF2fr5NEi1NuexrJTaOo/1lcQiAH9zsYbVZBKOJBLlSxStdwMd
         ey9gUQc0PWIauvRrAckiOWjICvKBHh5XZE6Gb0P4fr0M5oLdkEMkbBDThp9FU6qpFUtv
         PuW5uVN8KALKSn5mKfQpFKLIktIjTaXVLjlk/oCeR8mdEivcwTikY2Vs2HMaeNyB01nF
         H01KIxAD/qws55Jyg8yHTxt9upw/ZhWJCKUybVpSnB3qzyx7is1AyIVl2D54Jjb63q9g
         rvLA==
X-Gm-Message-State: AJIora+kTe8Owb+JqBOU/YVuGSrbCuwpc0+qdmmHraMr+M7tI+JR3/qL
        UdrZcSTT+YRGD/Z8Ohi7spQ=
X-Google-Smtp-Source: AGRyM1v5aLmPzrC+XxYYV4uLh2GGuhwt1aWcry9iKekSqWPC8OhNM+loFmHZbrtIZi41GxuUaTU4NA==
X-Received: by 2002:a05:6a00:2188:b0:50c:ef4d:ef3b with SMTP id h8-20020a056a00218800b0050cef4def3bmr32852199pfi.83.1658220459845;
        Tue, 19 Jul 2022 01:47:39 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id e5-20020a621e05000000b0051b32c2a5a7sm10723999pfe.138.2022.07.19.01.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 01:47:39 -0700 (PDT)
Date:   Tue, 19 Jul 2022 01:47:37 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v7 037/102] KVM: x86/mmu: Track shadow MMIO value/mask on
 a per-VM basis
Message-ID: <20220719084737.GU1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <242df8a7164b593d3702b9ba94889acd11f43cbb.1656366338.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <242df8a7164b593d3702b9ba94889acd11f43cbb.1656366338.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Here is the updated one. The changes are
- removed hunks that should be a part of other patches.
- removed shadow_default_mmio_mask
- trimed down commit messages.

From ed6b4a076e515550878b069596cf156a1bc33514 Mon Sep 17 00:00:00 2001
Message-Id: <ed6b4a076e515550878b069596cf156a1bc33514.1658220363.git.isaku.yamahata@intel.com>
In-Reply-To: <3941849bf08a55cfbbe69b222f0fd0dac7c5ee53.1658220363.git.isaku.yamahata@intel.com>
References: <3941849bf08a55cfbbe69b222f0fd0dac7c5ee53.1658220363.git.isaku.yamahata@intel.com>
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Wed, 10 Jun 2020 15:46:38 -0700
Subject: [PATCH 036/306] KVM: x86/mmu: Track shadow MMIO value/mask on a
 per-VM basis

TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
members to kvm_arch and track value for MMIO per-VM instead of global
variables.  By using the per-VM EPT entry value for MMIO, the existing VMX
logic is kept working.  To untangle the logic to initialize
shadow_mmio_access_mask, introduce a setter function.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +++
 arch/x86/kvm/mmu.h              |  3 ++-
 arch/x86/kvm/mmu/mmu.c          |  8 +++---
 arch/x86/kvm/mmu/spte.c         | 45 +++++++++------------------------
 arch/x86/kvm/mmu/spte.h         | 10 +++-----
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++---
 arch/x86/kvm/svm/svm.c          | 11 +++++---
 arch/x86/kvm/vmx/tdx.c          |  4 +++
 arch/x86/kvm/vmx/vmx.c          | 26 +++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h      |  1 +
 10 files changed, 66 insertions(+), 52 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c47aab72a1b..39215daa8576 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1161,6 +1161,10 @@ struct kvm_arch {
 	 */
 	spinlock_t mmu_unsync_pages_lock;
 
+	bool enable_mmio_caching;
+	u64 shadow_mmio_value;
+	u64 shadow_mmio_mask;
+
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	bool iommu_noncoherent;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index ccf0ba7a6387..cfa3e658162c 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -108,7 +108,8 @@ static inline u8 kvm_get_shadow_phys_bits(void)
 	return boot_cpu_data.x86_phys_bits;
 }
 
-void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
+void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmio_mask);
+void kvm_mmu_set_mmio_access_mask(u64 mmio_access_mask);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5bfccfa0f50e..34240fcc45de 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2298,7 +2298,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 				return kvm_mmu_prepare_zap_page(kvm, child,
 								invalid_list);
 		}
-	} else if (is_mmio_spte(pte)) {
+	} else if (is_mmio_spte(kvm, pte)) {
 		mmu_spte_clear_no_track(spte);
 	}
 	return 0;
@@ -3079,7 +3079,7 @@ static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fau
 		 * and only if L1's MAXPHYADDR is inaccurate with respect to
 		 * the hardware's).
 		 */
-		if (unlikely(!enable_mmio_caching) ||
+		if (unlikely(!vcpu->kvm->arch.enable_mmio_caching) ||
 		    unlikely(fault->gfn > kvm_mmu_max_gfn()))
 			return RET_PF_EMULATE;
 	}
@@ -3918,7 +3918,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	if (WARN_ON(reserved))
 		return -EINVAL;
 
-	if (is_mmio_spte(spte)) {
+	if (is_mmio_spte(vcpu->kvm, spte)) {
 		gfn_t gfn = get_mmio_spte_gfn(spte);
 		unsigned int access = get_mmio_spte_access(spte);
 
@@ -4361,7 +4361,7 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			   unsigned int access)
 {
-	if (unlikely(is_mmio_spte(*sptep))) {
+	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
 		if (gfn != get_mmio_spte_gfn(*sptep)) {
 			mmu_spte_clear_no_track(sptep);
 			return true;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 92968e5605fc..9a130dd3d6a3 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -29,8 +29,6 @@ u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 u64 __read_mostly shadow_user_mask;
 u64 __read_mostly shadow_accessed_mask;
 u64 __read_mostly shadow_dirty_mask;
-u64 __read_mostly shadow_mmio_value;
-u64 __read_mostly shadow_mmio_mask;
 u64 __read_mostly shadow_mmio_access_mask;
 u64 __read_mostly shadow_present_mask;
 u64 __read_mostly shadow_me_value;
@@ -62,10 +60,10 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	u64 spte = generation_mmio_spte_mask(gen);
 	u64 gpa = gfn << PAGE_SHIFT;
 
-	WARN_ON_ONCE(!shadow_mmio_value);
+	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
 
 	access &= shadow_mmio_access_mask;
-	spte |= shadow_mmio_value | access;
+	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
 	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
 	spte |= (gpa & shadow_nonpresent_or_rsvd_mask)
 		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
@@ -337,9 +335,8 @@ u64 mark_spte_for_access_track(u64 spte)
 	return spte;
 }
 
-void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
+void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmio_mask)
 {
-	BUG_ON((u64)(unsigned)access_mask != access_mask);
 	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
 
 	if (!enable_mmio_caching)
@@ -366,12 +363,9 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 	    WARN_ON(mmio_value && (__REMOVED_SPTE & mmio_mask) == mmio_value))
 		mmio_value = 0;
 
-	if (!mmio_value)
-		enable_mmio_caching = false;
-
-	shadow_mmio_value = mmio_value;
-	shadow_mmio_mask  = mmio_mask;
-	shadow_mmio_access_mask = access_mask;
+	kvm->arch.enable_mmio_caching = !!mmio_value;
+	kvm->arch.shadow_mmio_value = mmio_value;
+	kvm->arch.shadow_mmio_mask = mmio_mask;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
@@ -399,20 +393,12 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
 	shadow_host_writable_mask = EPT_SPTE_HOST_WRITABLE;
 	shadow_mmu_writable_mask  = EPT_SPTE_MMU_WRITABLE;
-
-	/*
-	 * EPT Misconfigurations are generated if the value of bits 2:0
-	 * of an EPT paging-structure entry is 110b (write/execute).
-	 */
-	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
-				   VMX_EPT_RWX_MASK, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_masks);
 
 void kvm_mmu_reset_all_pte_masks(void)
 {
 	u8 low_phys_bits;
-	u64 mask;
 
 	shadow_phys_bits = kvm_get_shadow_phys_bits();
 
@@ -452,18 +438,11 @@ void kvm_mmu_reset_all_pte_masks(void)
 
 	shadow_host_writable_mask = DEFAULT_SPTE_HOST_WRITABLE;
 	shadow_mmu_writable_mask  = DEFAULT_SPTE_MMU_WRITABLE;
+}
 
-	/*
-	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
-	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
-	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
-	 * 52-bit physical addresses then there are no reserved PA bits in the
-	 * PTEs and so the reserved PA approach must be disabled.
-	 */
-	if (shadow_phys_bits < 52)
-		mask = BIT_ULL(51) | PT_PRESENT_MASK;
-	else
-		mask = 0;
-
-	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
+void kvm_mmu_set_mmio_access_mask(u64 mmio_access_mask)
+{
+	BUG_ON((u64)(unsigned)mmio_access_mask != mmio_access_mask);
+	shadow_mmio_access_mask = mmio_access_mask;
 }
+EXPORT_SYMBOL(kvm_mmu_set_mmio_access_mask);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index f5fd22f6bf5f..99bce92b596e 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -5,8 +5,6 @@
 
 #include "mmu_internal.h"
 
-extern bool __read_mostly enable_mmio_caching;
-
 /*
  * A MMU present SPTE is backed by actual memory and may or may not be present
  * in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11, as it
@@ -160,8 +158,6 @@ extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 extern u64 __read_mostly shadow_user_mask;
 extern u64 __read_mostly shadow_accessed_mask;
 extern u64 __read_mostly shadow_dirty_mask;
-extern u64 __read_mostly shadow_mmio_value;
-extern u64 __read_mostly shadow_mmio_mask;
 extern u64 __read_mostly shadow_mmio_access_mask;
 extern u64 __read_mostly shadow_present_mask;
 extern u64 __read_mostly shadow_me_value;
@@ -228,10 +224,10 @@ static inline bool is_removed_spte(u64 spte)
  */
 extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
-static inline bool is_mmio_spte(u64 spte)
+static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
 {
-	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
-	       likely(enable_mmio_caching);
+	return (spte & kvm->arch.shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
+		likely(kvm->arch.enable_mmio_caching);
 }
 
 static inline bool is_shadow_present_pte(u64 pte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2ca03ec3bf52..82f1bfac7ee6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -569,8 +569,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		 * impact the guest since both the former and current SPTEs
 		 * are nonpresent.
 		 */
-		if (WARN_ON(!is_mmio_spte(old_spte) &&
-			    !is_mmio_spte(new_spte) &&
+		if (WARN_ON(!is_mmio_spte(kvm, old_spte) &&
+			    !is_mmio_spte(kvm, new_spte) &&
 			    !is_removed_spte(new_spte)))
 			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
 			       "should not be replaced with another,\n"
@@ -1108,7 +1108,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	}
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
-	if (unlikely(is_mmio_spte(new_spte))) {
+	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
 		vcpu->stat.pf_mmio_spte_created++;
 		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
 				     new_spte);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f01821f48bfd..0f63257161a6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -198,6 +198,7 @@ module_param(dump_invalid_vmcb, bool, 0644);
 bool intercept_smi = true;
 module_param(intercept_smi, bool, 0444);
 
+static u64 __read_mostly svm_shadow_mmio_mask;
 
 static bool svm_gp_erratum_intercept = true;
 
@@ -4685,6 +4686,9 @@ static bool svm_is_vm_type_supported(unsigned long type)
 
 static int svm_vm_init(struct kvm *kvm)
 {
+	kvm_mmu_set_mmio_spte_mask(kvm, svm_shadow_mmio_mask,
+				   svm_shadow_mmio_mask);
+
 	if (!pause_filter_count || !pause_filter_thresh)
 		kvm->arch.pause_in_guest = true;
 
@@ -4834,7 +4838,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 static __init void svm_adjust_mmio_mask(void)
 {
 	unsigned int enc_bit, mask_bit;
-	u64 msr, mask;
+	u64 msr;
 
 	/* If there is no memory encryption support, use existing mask */
 	if (cpuid_eax(0x80000000) < 0x8000001f)
@@ -4861,9 +4865,8 @@ static __init void svm_adjust_mmio_mask(void)
 	 *
 	 * If the mask bit location is 52 (or above), then clear the mask.
 	 */
-	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
-
-	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
+	svm_shadow_mmio_mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
+	kvm_mmu_set_mmio_access_mask(PT_WRITABLE_MASK | PT_USER_MASK);
 }
 
 static __init void svm_set_cpu_caps(void)
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 36d2127cb7b7..52fb54880f9b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -7,6 +7,7 @@
 #include "x86_ops.h"
 #include "tdx.h"
 #include "x86.h"
+#include "mmu.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) "tdx: " fmt
@@ -276,6 +277,9 @@ int tdx_vm_init(struct kvm *kvm)
 	int ret, i;
 	u64 err;
 
+	kvm_mmu_set_mmio_spte_mask(kvm, vmx_shadow_mmio_mask,
+				   vmx_shadow_mmio_mask);
+
 	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
 	kvm->max_vcpus = 0;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e129ee663498..88e893fdffe8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -141,6 +141,8 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 extern bool __read_mostly allow_smaller_maxphyaddr;
 module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 
+u64 __ro_after_init vmx_shadow_mmio_mask;
+
 #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
 #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
 #define KVM_VM_CR0_ALWAYS_ON				\
@@ -7359,6 +7361,17 @@ int vmx_vm_init(struct kvm *kvm)
 	if (!ple_gap)
 		kvm->arch.pause_in_guest = true;
 
+	/*
+	 * EPT Misconfigurations can be generated if the value of bits 2:0
+	 * of an EPT paging-structure entry is 110b (write/execute).
+	 */
+	if (enable_ept)
+		kvm_mmu_set_mmio_spte_mask(kvm, VMX_EPT_MISCONFIG_WX_VALUE,
+					   VMX_EPT_RWX_MASK);
+	else
+		kvm_mmu_set_mmio_spte_mask(kvm, vmx_shadow_mmio_mask,
+					   vmx_shadow_mmio_mask);
+
 	if (boot_cpu_has(X86_BUG_L1TF) && enable_ept) {
 		switch (l1tf_mitigation) {
 		case L1TF_MITIGATION_OFF:
@@ -8358,6 +8371,19 @@ int __init vmx_init(void)
 	if (!enable_ept)
 		allow_smaller_maxphyaddr = true;
 
+	/*
+	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
+	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
+	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
+	 * 52-bit physical addresses then there are no reserved PA bits in the
+	 * PTEs and so the reserved PA approach must be disabled.
+	 */
+	if (kvm_get_shadow_phys_bits() < 52)
+		vmx_shadow_mmio_mask = BIT_ULL(51) | PT_PRESENT_MASK;
+	else
+		vmx_shadow_mmio_mask = 0;
+	kvm_mmu_set_mmio_access_mask(0);
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 7e38c7b756d4..279e5360c555 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -13,6 +13,7 @@ void hv_vp_assist_page_exit(void);
 void __init vmx_init_early(void);
 int __init vmx_init(void);
 void vmx_exit(void);
+extern u64 __ro_after_init vmx_shadow_mmio_mask;
 
 __init int vmx_cpu_has_kvm_support(void);
 __init int vmx_disabled_by_bios(void);
-- 
2.25.1


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
