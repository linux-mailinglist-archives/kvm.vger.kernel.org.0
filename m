Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B6B32580F
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbhBYUyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbhBYUuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:50:35 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD01AC061226
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:30 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a63so7643094yba.2
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CStveBKOEZIJIuu0d29PcoMsbDwro7qz1nDfW0Tyl2s=;
        b=DeIPOSTh5jTvcOHDAOsTHxIsbsJUCUg9SYNF479Xcm0IjuOKIRiqzI+dRIclQJY4I/
         59EbcpFa92utRPo8I+dh33vNkxfsMfM42m5+nRoJ2hA4ofJN4QAaldzUavKj7eu+U3/J
         vbIuv9Mb8amcgyoR9L4NsqRQVOPKXxW64qKhtf9TE4RdweoSwjvEwn+bDhJYJbIqoUiC
         9E2PtbFGedDwj6nRoeR9LY6caxe+vs3wtcRtzR5pgHxAt3Ael07XZ+R6NUKSxMHeEyNR
         cmMap0umW0+Jpghl+ENc3jZXR5q+0DDGp3/S5UIhItKC05EFcKBYuYm9AvZjGU+vy02e
         lr0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CStveBKOEZIJIuu0d29PcoMsbDwro7qz1nDfW0Tyl2s=;
        b=l8TReuLMOI0oXuiHURxtI/0GS6DpAChSpnMbatlM9P+QuDPcj1WR6Z6HCDvwB//rM1
         PbJ+QBLjFn8zw8ZtMNAxBn2+GdHK8E9P79UYDyPxibMdd4MjQ247+HVTCdsWqlcyj8cW
         JI2Y2GIYPmGAzX0r4m2OTyNDeItnLwiY6OHo3WZ7RmM2hqdWlvclMQNMNf76kSw0Z7oZ
         N4whN+vxek6/GpHRuPcw+kTWSkvetf+qL5udT9WaEYJnhKlpgRUsuOckuYBYb+K+AiJZ
         lvMSMykfyjDkfEg3acRHIQ4a4YApxm1cu4hElRikSNJk/ne/5VunVTlywTuCGEL5MOG5
         031Q==
X-Gm-Message-State: AOAM5333v/fkleJnsdo/o2qWcm1eNpxUobFWHFguxN0kQkps3fqE/2xd
        weI5s5+T+w8xnwBnloR/8oC9pgzvm/o=
X-Google-Smtp-Source: ABdhPJzeXKlrJOe/IPappNVx1l6zaaiJ4tcWs9xEBvZDyOG6iQDDa1JpG82lHTnqQBzQOa42grLFkzRI7dM=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a25:f0b:: with SMTP id 11mr5204604ybp.208.1614286110008;
 Thu, 25 Feb 2021 12:48:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:37 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 12/24] KVM: x86/mmu: Rename and document A/D scheme for TDP SPTEs
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

Rename the various A/D status defines to explicitly associated them with
TDP.  There is a subtle dependency on the bits in question never being
set when using PAE paging, as those bits are reserved, not available.
I.e. using these bits outside of TDP (technically EPT) would cause
explosions.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/locking.rst | 37 +++++++++++++++---------------
 arch/x86/kvm/mmu/spte.c            | 17 ++++++++++----
 arch/x86/kvm/mmu/spte.h            | 34 ++++++++++++++++++++-------
 3 files changed, 56 insertions(+), 32 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 0aa4817b466d..85876afe0441 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -38,12 +38,11 @@ the mmu-lock on x86. Currently, the page fault can be fast in one of the
 following two cases:
 
 1. Access Tracking: The SPTE is not present, but it is marked for access
-   tracking i.e. the SPTE_SPECIAL_MASK is set. That means we need to
-   restore the saved R/X bits. This is described in more detail later below.
+   tracking. That means we need to restore the saved R/X bits. This is
+   described in more detail later below.
 
-2. Write-Protection: The SPTE is present and the fault is
-   caused by write-protect. That means we just need to change the W bit of
-   the spte.
+2. Write-Protection: The SPTE is present and the fault is caused by
+   write-protect. That means we just need to change the W bit of the spte.
 
 What we use to avoid all the race is the SPTE_HOST_WRITEABLE bit and
 SPTE_MMU_WRITEABLE bit on the spte:
@@ -54,9 +53,9 @@ SPTE_MMU_WRITEABLE bit on the spte:
   page write-protection.
 
 On fast page fault path, we will use cmpxchg to atomically set the spte W
-bit if spte.SPTE_HOST_WRITEABLE = 1 and spte.SPTE_WRITE_PROTECT = 1, or
-restore the saved R/X bits if VMX_EPT_TRACK_ACCESS mask is set, or both. This
-is safe because whenever changing these bits can be detected by cmpxchg.
+bit if spte.SPTE_HOST_WRITEABLE = 1 and spte.SPTE_WRITE_PROTECT = 1, to
+restore the saved R/X bits if for an access-traced spte, or both. This is
+safe because whenever changing these bits can be detected by cmpxchg.
 
 But we need carefully check these cases:
 
@@ -185,17 +184,17 @@ See the comments in spte_has_volatile_bits() and mmu_spte_update().
 Lockless Access Tracking:
 
 This is used for Intel CPUs that are using EPT but do not support the EPT A/D
-bits. In this case, when the KVM MMU notifier is called to track accesses to a
-page (via kvm_mmu_notifier_clear_flush_young), it marks the PTE as not-present
-by clearing the RWX bits in the PTE and storing the original R & X bits in
-some unused/ignored bits. In addition, the SPTE_SPECIAL_MASK is also set on the
-PTE (using the ignored bit 62). When the VM tries to access the page later on,
-a fault is generated and the fast page fault mechanism described above is used
-to atomically restore the PTE to a Present state. The W bit is not saved when
-the PTE is marked for access tracking and during restoration to the Present
-state, the W bit is set depending on whether or not it was a write access. If
-it wasn't, then the W bit will remain clear until a write access happens, at
-which time it will be set using the Dirty tracking mechanism described above.
+bits. In this case, PTEs are tagged as A/D disabled (using ignored bits), and
+when the KVM MMU notifier is called to track accesses to a page (via
+kvm_mmu_notifier_clear_flush_young), it marks the PTE not-present in hardware
+by clearing the RWX bits in the PTE and storing the original R & X bits in more
+unused/ignored bits. When the VM tries to access the page later on, a fault is
+generated and the fast page fault mechanism described above is used to
+atomically restore the PTE to a Present state. The W bit is not saved when the
+PTE is marked for access tracking and during restoration to the Present state,
+the W bit is set depending on whether or not it was a write access. If it
+wasn't, then the W bit will remain clear until a write access happens, at which
+time it will be set using the Dirty tracking mechanism described above.
 
 3. Reference
 ------------
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 503dec3f8c7a..3eaf143b7d12 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -42,7 +42,7 @@ static u64 generation_mmio_spte_mask(u64 gen)
 	u64 mask;
 
 	WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
-	BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_SPECIAL_MASK);
+	BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_TDP_AD_MASK);
 
 	mask = (gen << MMIO_SPTE_GEN_LOW_SHIFT) & MMIO_SPTE_GEN_LOW_MASK;
 	mask |= (gen << MMIO_SPTE_GEN_HIGH_SHIFT) & MMIO_SPTE_GEN_HIGH_MASK;
@@ -96,9 +96,16 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 	int ret = 0;
 
 	if (ad_disabled)
-		spte |= SPTE_AD_DISABLED_MASK;
+		spte |= SPTE_TDP_AD_DISABLED_MASK;
 	else if (kvm_vcpu_ad_need_write_protect(vcpu))
-		spte |= SPTE_AD_WRPROT_ONLY_MASK;
+		spte |= SPTE_TDP_AD_WRPROT_ONLY_MASK;
+
+	/*
+	 * Bits 62:52 of PAE SPTEs are reserved.  WARN if said bits are set
+	 * if PAE paging may be employed (shadow paging or any 32-bit KVM).
+	 */
+	WARN_ON_ONCE((!tdp_enabled || !IS_ENABLED(CONFIG_X86_64)) &&
+		     (spte & SPTE_TDP_AD_MASK));
 
 	/*
 	 * For the EPT case, shadow_present_mask is 0 if hardware
@@ -180,7 +187,7 @@ u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 	       shadow_user_mask | shadow_x_mask | shadow_me_mask;
 
 	if (ad_disabled)
-		spte |= SPTE_AD_DISABLED_MASK;
+		spte |= SPTE_TDP_AD_DISABLED_MASK;
 	else
 		spte |= shadow_accessed_mask;
 
@@ -288,7 +295,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 {
 	BUG_ON(!dirty_mask != !accessed_mask);
 	BUG_ON(!accessed_mask && !acc_track_mask);
-	BUG_ON(acc_track_mask & SPTE_SPECIAL_MASK);
+	BUG_ON(acc_track_mask & SPTE_TDP_AD_MASK);
 
 	shadow_user_mask = user_mask;
 	shadow_accessed_mask = accessed_mask;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 642a17b9964c..fd0a7911f098 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -8,11 +8,24 @@
 #define PT_FIRST_AVAIL_BITS_SHIFT 10
 #define PT64_SECOND_AVAIL_BITS_SHIFT 54
 
-/* The mask used to denote Access Tracking SPTEs.  Note, val=3 is available. */
-#define SPTE_SPECIAL_MASK (3ULL << 52)
-#define SPTE_AD_ENABLED_MASK (0ULL << 52)
-#define SPTE_AD_DISABLED_MASK (1ULL << 52)
-#define SPTE_AD_WRPROT_ONLY_MASK (2ULL << 52)
+/*
+ * TDP SPTES (more specifically, EPT SPTEs) may not have A/D bits, and may also
+ * be restricted to using write-protection (for L2 when CPU dirty logging, i.e.
+ * PML, is enabled).  Use bits 52 and 53 to hold the type of A/D tracking that
+ * is must be employed for a given TDP SPTE.
+ *
+ * Note, the "enabled" mask must be '0', as bits 62:52 are _reserved_ for PAE
+ * paging, including NPT PAE.  This scheme works because legacy shadow paging
+ * is guaranteed to have A/D bits and write-protection is forced only for
+ * TDP with CPU dirty logging (PML).  If NPT ever gains PML-like support, it
+ * must be restricted to 64-bit KVM.
+ */
+#define SPTE_TDP_AD_SHIFT		52
+#define SPTE_TDP_AD_MASK		(3ULL << SPTE_TDP_AD_SHIFT)
+#define SPTE_TDP_AD_ENABLED_MASK	(0ULL << SPTE_TDP_AD_SHIFT)
+#define SPTE_TDP_AD_DISABLED_MASK	(1ULL << SPTE_TDP_AD_SHIFT)
+#define SPTE_TDP_AD_WRPROT_ONLY_MASK	(2ULL << SPTE_TDP_AD_SHIFT)
+static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 
 #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
 #define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
@@ -100,7 +113,7 @@ extern u64 __read_mostly shadow_present_mask;
 extern u64 __read_mostly shadow_me_mask;
 
 /*
- * SPTEs used by MMUs without A/D bits are marked with SPTE_AD_DISABLED_MASK;
+ * SPTEs in MMUs without A/D bits are marked with SPTE_TDP_AD_DISABLED_MASK;
  * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
  * pages.
  */
@@ -176,13 +189,18 @@ static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 static inline bool spte_ad_enabled(u64 spte)
 {
 	MMU_WARN_ON(is_mmio_spte(spte));
-	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_DISABLED_MASK;
+	return (spte & SPTE_TDP_AD_MASK) != SPTE_TDP_AD_DISABLED_MASK;
 }
 
 static inline bool spte_ad_need_write_protect(u64 spte)
 {
 	MMU_WARN_ON(is_mmio_spte(spte));
-	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_ENABLED_MASK;
+	/*
+	 * This is benign for non-TDP SPTEs as SPTE_TDP_AD_ENABLED_MASK is '0',
+	 * and non-TDP SPTEs will never set these bits.  Optimize for 64-bit
+	 * TDP and do the A/D type check unconditionally.
+	 */
+	return (spte & SPTE_TDP_AD_MASK) != SPTE_TDP_AD_ENABLED_MASK;
 }
 
 static inline u64 spte_shadow_accessed_mask(u64 spte)
-- 
2.30.1.766.gb4fecdf3b7-goog

