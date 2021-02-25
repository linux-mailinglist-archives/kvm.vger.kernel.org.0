Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54CF32581C
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbhBYUzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbhBYUwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:52:12 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5ABC061788
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:47 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id p136so7624510ybc.21
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KPwBN3kxwz361LXpz9SZI0brfn4PUGIyM8jlrlDx8Uc=;
        b=diozhjASaLDUbb2ByAoCABeedgKcXRJj/yekQAvg1TQktIpMPKFRiLsT3QAhMgtFYE
         KwbazfUAOsntv7/WDECQvoPJ27oX+T57ZuVkFyRBa4ikBHyg1T+WTBZQ94HSgQOpyNmx
         Qx8R9O+H68laTaQEuj+2h2VgqoNVYDde+IGYdVt4H/8dRgRpVsFB+3gyAvvlxHCOxHfM
         r/4TW30NzMUiaxCeMlTsTn0X8Fk6SJsHTsBpAISNbaFbLUcpio6x5MfnBu51qjzfXIQX
         buz7xyHby6bJUtR+taDfsTrW8v9zmMSqCdPHiUJAYoeOXIq/hT7pr7G3PvV6W1vmiBr4
         8sSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KPwBN3kxwz361LXpz9SZI0brfn4PUGIyM8jlrlDx8Uc=;
        b=iQWmwQM1YtgrX0EyEOnd+DJeZEsEZXicSw8vt+XrfeaAriDRGRlEneDuBBRJ1IdFB4
         1seAqsOAVyBBDN743GvFIlCcUwRCHv88rxfrLMop7bL/+LghcFyQyEDr31f367R29ZAH
         EOXnPPyGlRR46oDNB4tOCm3ZFdXy2BnX4PeNaPx9sgz4hTRu2tBIeGR5VYzmpoiH85Zm
         graI0YKkBN5CjheDnc1nZj4+/4bBpEyIi2uDQ+DUMlf4XEy4tytal/GbzK+h2HMDSEaK
         mUF8SSdPk2c9yN8WVCvltoZbxxNyySKk4mcfwWkhbYSN+Bu0qcpFJ2XYJrRdNsET5iXu
         ArXQ==
X-Gm-Message-State: AOAM531wmniIMjigWr3CBDibmiu/Qp2S/bzcQvvaDb0rgcVg0QTCsiSn
        N0BxNVI5tsuwO3Y66Xa4JxeIX/G5fZE=
X-Google-Smtp-Source: ABdhPJxKUYSdGYv5Qx/boJeF4MiMwpQyNbZptET5Hx1lGbYcIdQLitjVyh8rklMQdT7MXRoKh1zo7VJALP0=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a25:25d8:: with SMTP id l207mr7261484ybl.68.1614286126849;
 Thu, 25 Feb 2021 12:48:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:43 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-19-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 18/24] KVM: x86/mmu: Make Host-writable and MMU-writable bit
 locations dynamic
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make the location of the HOST_WRITABLE and MMU_WRITABLE configurable for
a given KVM instance.  This will allow EPT to use high available bits,
which in turn will free up bit 11 for a constant MMU_PRESENT bit.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/locking.rst | 18 +++++++++---------
 arch/x86/kvm/mmu.h                 | 12 ++++++------
 arch/x86/kvm/mmu/mmu.c             |  8 ++++----
 arch/x86/kvm/mmu/paging_tmpl.h     |  2 +-
 arch/x86/kvm/mmu/spte.c            | 13 +++++++++----
 arch/x86/kvm/mmu/spte.h            | 13 ++++++-------
 arch/x86/kvm/mmu/tdp_mmu.c         |  6 +++---
 7 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 85876afe0441..1fc860c007a3 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -44,18 +44,18 @@ following two cases:
 2. Write-Protection: The SPTE is present and the fault is caused by
    write-protect. That means we just need to change the W bit of the spte.
 
-What we use to avoid all the race is the SPTE_HOST_WRITEABLE bit and
-SPTE_MMU_WRITEABLE bit on the spte:
+What we use to avoid all the race is the Host-writable bit and MMU-writable bit
+on the spte:
 
-- SPTE_HOST_WRITEABLE means the gfn is writable on host.
-- SPTE_MMU_WRITEABLE means the gfn is writable on mmu. The bit is set when
-  the gfn is writable on guest mmu and it is not write-protected by shadow
-  page write-protection.
+- Host-writable means the gfn is writable in the host kernel page tables and in
+  its KVM memslot.
+- MMU-writable means the gfn is writable in the guest's mmu and it is not
+  write-protected by shadow page write-protection.
 
 On fast page fault path, we will use cmpxchg to atomically set the spte W
-bit if spte.SPTE_HOST_WRITEABLE = 1 and spte.SPTE_WRITE_PROTECT = 1, to
-restore the saved R/X bits if for an access-traced spte, or both. This is
-safe because whenever changing these bits can be detected by cmpxchg.
+bit if spte.HOST_WRITEABLE = 1 and spte.WRITE_PROTECT = 1, to restore the saved
+R/X bits if for an access-traced spte, or both. This is safe because whenever
+changing these bits can be detected by cmpxchg.
 
 But we need carefully check these cases:
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 11cf7793cfee..72b0f66073dc 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -125,7 +125,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
  * write-protects guest page to sync the guest modification, b) another one is
  * used to sync dirty bitmap when we do KVM_GET_DIRTY_LOG. The differences
  * between these two sorts are:
- * 1) the first case clears SPTE_MMU_WRITEABLE bit.
+ * 1) the first case clears MMU-writable bit.
  * 2) the first case requires flushing tlb immediately avoiding corrupting
  *    shadow page table between all vcpus so it should be in the protection of
  *    mmu-lock. And the another case does not need to flush tlb until returning
@@ -136,17 +136,17 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
  * So, there is the problem: the first case can meet the corrupted tlb caused
  * by another case which write-protects pages but without flush tlb
  * immediately. In order to making the first case be aware this problem we let
- * it flush tlb if we try to write-protect a spte whose SPTE_MMU_WRITEABLE bit
- * is set, it works since another case never touches SPTE_MMU_WRITEABLE bit.
+ * it flush tlb if we try to write-protect a spte whose MMU-writable bit
+ * is set, it works since another case never touches MMU-writable bit.
  *
  * Anyway, whenever a spte is updated (only permission and status bits are
- * changed) we need to check whether the spte with SPTE_MMU_WRITEABLE becomes
+ * changed) we need to check whether the spte with MMU-writable becomes
  * readonly, if that happens, we need to flush tlb. Fortunately,
  * mmu_spte_update() has already handled it perfectly.
  *
- * The rules to use SPTE_MMU_WRITEABLE and PT_WRITABLE_MASK:
+ * The rules to use MMU-writable and PT_WRITABLE_MASK:
  * - if we want to see if it has writable tlb entry or if the spte can be
- *   writable on the mmu mapping, check SPTE_MMU_WRITEABLE, this is the most
+ *   writable on the mmu mapping, check MMU-writable, this is the most
  *   case, otherwise
  * - if we fix page fault on the spte or do write-protection by dirty logging,
  *   check PT_WRITABLE_MASK.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1fb500db46e0..e636fcd529d2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1107,7 +1107,7 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	rmap_printk("spte %p %llx\n", sptep, *sptep);
 
 	if (pt_protect)
-		spte &= ~SPTE_MMU_WRITEABLE;
+		spte &= ~shadow_mmu_writable_mask;
 	spte = spte & ~PT_WRITABLE_MASK;
 
 	return mmu_spte_update(sptep, spte);
@@ -5485,9 +5485,9 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	 * spte from present to present (changing the spte from present
 	 * to nonpresent will flush all the TLBs immediately), in other
 	 * words, the only case we care is mmu_spte_update() where we
-	 * have checked SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE
-	 * instead of PT_WRITABLE_MASK, that means it does not depend
-	 * on PT_WRITABLE_MASK anymore.
+	 * have checked Host-writable | MMU-writable instead of
+	 * PT_WRITABLE_MASK, that means it does not depend on PT_WRITABLE_MASK
+	 * anymore.
 	 */
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 55d7b473ac44..8b9987d5fe02 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1084,7 +1084,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 		nr_present++;
 
-		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;
+		host_writable = sp->spt[i] & shadow_host_writable_mask;
 
 		set_spte_ret |= set_spte(vcpu, &sp->spt[i],
 					 pte_access, PG_LEVEL_4K,
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index ac5ea6fda969..2329ba60c67a 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -21,6 +21,8 @@
 static bool __read_mostly enable_mmio_caching = true;
 module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
 
+u64 __read_mostly shadow_host_writable_mask;
+u64 __read_mostly shadow_mmu_writable_mask;
 u64 __read_mostly shadow_nx_mask;
 u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 u64 __read_mostly shadow_user_mask;
@@ -137,7 +139,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 			kvm_is_mmio_pfn(pfn));
 
 	if (host_writable)
-		spte |= SPTE_HOST_WRITEABLE;
+		spte |= shadow_host_writable_mask;
 	else
 		pte_access &= ~ACC_WRITE_MASK;
 
@@ -147,7 +149,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 	spte |= (u64)pfn << PAGE_SHIFT;
 
 	if (pte_access & ACC_WRITE_MASK) {
-		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
+		spte |= PT_WRITABLE_MASK | shadow_mmu_writable_mask;
 
 		/*
 		 * Optimization: for pte sync, if spte was writable the hash
@@ -163,7 +165,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 				 __func__, gfn);
 			ret |= SET_SPTE_WRITE_PROTECTED_PT;
 			pte_access &= ~ACC_WRITE_MASK;
-			spte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
+			spte &= ~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
 		}
 	}
 
@@ -202,7 +204,7 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
 	new_spte |= (u64)new_pfn << PAGE_SHIFT;
 
 	new_spte &= ~PT_WRITABLE_MASK;
-	new_spte &= ~SPTE_HOST_WRITEABLE;
+	new_spte &= ~shadow_host_writable_mask;
 
 	new_spte = mark_spte_for_access_track(new_spte);
 
@@ -342,6 +344,9 @@ void kvm_mmu_reset_all_pte_masks(void)
 	shadow_acc_track_mask	= 0;
 	shadow_me_mask		= sme_me_mask;
 
+	shadow_host_writable_mask = DEFAULT_SPTE_HOST_WRITEABLE;
+	shadow_mmu_writable_mask  = DEFAULT_SPTE_MMU_WRITEABLE;
+
 	/*
 	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
 	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index e918b8f0b21d..287540d211a9 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -5,8 +5,6 @@
 
 #include "mmu_internal.h"
 
-#define PT_FIRST_AVAIL_BITS_SHIFT 10
-
 /*
  * TDP SPTES (more specifically, EPT SPTEs) may not have A/D bits, and may also
  * be restricted to using write-protection (for L2 when CPU dirty logging, i.e.
@@ -59,9 +57,8 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 
-
-#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
-#define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
+#define DEFAULT_SPTE_HOST_WRITEABLE	BIT_ULL(10)
+#define DEFAULT_SPTE_MMU_WRITEABLE	BIT_ULL(11)
 
 /*
  * Due to limited space in PTEs, the MMIO generation is a 20 bit subset of
@@ -100,6 +97,8 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 9 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
 
+extern u64 __read_mostly shadow_host_writable_mask;
+extern u64 __read_mostly shadow_mmu_writable_mask;
 extern u64 __read_mostly shadow_nx_mask;
 extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 extern u64 __read_mostly shadow_user_mask;
@@ -264,8 +263,8 @@ static inline bool is_dirty_spte(u64 spte)
 
 static inline bool spte_can_locklessly_be_made_writable(u64 spte)
 {
-	return (spte & (SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE)) ==
-		(SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE);
+	return (spte & shadow_host_writable_mask) &&
+	       (spte & shadow_mmu_writable_mask);
 }
 
 static inline u64 get_mmio_spte_generation(u64 spte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 782cae1eb5e1..bef0e1908e82 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1329,7 +1329,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 /*
  * Removes write access on the last level SPTE mapping this GFN and unsets the
- * SPTE_MMU_WRITABLE bit to ensure future writes continue to be intercepted.
+ * MMU-writable bit to ensure future writes continue to be intercepted.
  * Returns true if an SPTE was set and a TLB flush is needed.
  */
 static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
@@ -1346,7 +1346,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 			break;
 
 		new_spte = iter.old_spte &
-			~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
+			~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
 
 		tdp_mmu_set_spte(kvm, &iter, new_spte);
 		spte_set = true;
@@ -1359,7 +1359,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 
 /*
  * Removes write access on the last level SPTE mapping this GFN and unsets the
- * SPTE_MMU_WRITABLE bit to ensure future writes continue to be intercepted.
+ * MMU-writable bit to ensure future writes continue to be intercepted.
  * Returns true if an SPTE was set and a TLB flush is needed.
  */
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
-- 
2.30.1.766.gb4fecdf3b7-goog

