Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6572350C70B
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 05:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbiDWDvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 23:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiDWDvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 23:51:10 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79BF1C1BA6
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:14 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d6-20020aa78686000000b0050adc2b200cso4680889pfo.21
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dtBZMDfTalZh2XkDGyYCthXE8Qbr+M1eG4ZapuRAgmk=;
        b=Bcff9EnUeQjBvfNF0ZD4Jxot9AFwuW5ObvM+nOepNeFE8fW67Rqag9IEH+IVOpA1IH
         0NIIFCxWds+9BXOGtnmxHFMuQSLcb77BloSATp/9nrhR6+Ve2ES0m8fYr2UaCI4FYk6I
         vgfH8sA7JIsKX86nzfLOpomrU5h+yvKjWWxR7iEgq9ILHpiJyaBHxkUEhok1E+FDfnKe
         YSEcl1SBDKQiXHpOpWEvhx/qEsDtpwXag9Xk2AAGjmRrhVmiz6yzddEPnsFGmDTUaqDb
         zv8fiwFlGnQfMxiOTuAJXVqPDwCHt/eRyNbjo3Qzno1kI+MEypVRgJAhDuQvW0O+pZaq
         wF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dtBZMDfTalZh2XkDGyYCthXE8Qbr+M1eG4ZapuRAgmk=;
        b=7LQOwM8rHOYUV3iYS/MvzOCtmbtD/xz6tWwRqJ/r8+2XW2vXvmOiiCerQ6b7ClnDcu
         AHQJbzD1uycsDGmqJin180LXfqC1zOJmgomFSEbuPM3aBCY+f5BrVWCaQJuSa5aGtE2w
         kFyMLmbfGXWvUCpKUfpWgf+WaIDDcCjo+c3XWRxK+VVZUEl8icvbRY4CBCkJftfFD7bx
         /1QDpBMM7D7EX2V2nCZY5sljTCq3bl6BXgdZ4rFl94CQendzjY43lDGSwtPmO+BMX17h
         O/mpmtdzOmiBnP8dRerzuEzMyr73qXL2TS2pqCsdm1oHS0WW9EWEz5u1l3QuXwyQsBLB
         Pnlg==
X-Gm-Message-State: AOAM531B8PodErz7BxR1U1B7zglTPsx5XPX02gvGRpz3rtCaK/QoB1hi
        noEfKCqfOAbXMyIThleA05PBPxjW2fQ=
X-Google-Smtp-Source: ABdhPJzB5ZvT1BP2AXWkijl7gJ9hs+fwyWMBfbxmRJUD6kFR5UyFoyTZ4f782KaP5mq3+tk3zPM049PzgQ0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1955:b0:505:7902:36d3 with SMTP id
 s21-20020a056a00195500b00505790236d3mr8175856pfk.77.1650685694468; Fri, 22
 Apr 2022 20:48:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 03:47:42 +0000
In-Reply-To: <20220423034752.1161007-1-seanjc@google.com>
Message-Id: <20220423034752.1161007-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220423034752.1161007-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 02/12] KVM: x86/mmu: Move shadow-present check out of spte_has_volatile_bits()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the is_shadow_present_pte() check out of spte_has_volatile_bits()
and into its callers.  Well, caller, since only one of its two callers
doesn't already do the shadow-present check.

Opportunistically move the helper to spte.c/h so that it can be used by
the TDP MMU, which is also the primary motivation for the shadow-present
change.  Unlike the legacy MMU, the TDP MMU uses a single path for clear
leaf and non-leaf SPTEs, and to avoid unnecessary atomic updates, the TDP
MMU will need to check is_last_spte() prior to calling
spte_has_volatile_bits(), and calling is_last_spte() without first
calling is_shadow_present_spte() is at best odd, and at worst a violation
of KVM's loosely defines SPTE rules.

Note, mmu_spte_clear_track_bits() could likely skip the write entirely
for SPTEs that are not shadow-present.  Leave that cleanup for a future
patch to avoid introducing a functional change, and because the
shadow-present check can likely be moved further up the stack, e.g.
drop_large_spte() appears to be the only path that doesn't already
explicitly check for a shadow-present SPTE.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c  | 29 ++---------------------------
 arch/x86/kvm/mmu/spte.c | 28 ++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/spte.h |  2 ++
 3 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 612316768e8e..65b723201738 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -470,32 +470,6 @@ static u64 __get_spte_lockless(u64 *sptep)
 }
 #endif
 
-static bool spte_has_volatile_bits(u64 spte)
-{
-	if (!is_shadow_present_pte(spte))
-		return false;
-
-	/*
-	 * Always atomically update spte if it can be updated
-	 * out of mmu-lock, it can ensure dirty bit is not lost,
-	 * also, it can help us to get a stable is_writable_pte()
-	 * to ensure tlb flush is not missed.
-	 */
-	if (!is_writable_pte(spte) && is_mmu_writable_spte(spte))
-		return true;
-
-	if (is_access_track_spte(spte))
-		return true;
-
-	if (spte_ad_enabled(spte)) {
-		if (!(spte & shadow_accessed_mask) ||
-		    (is_writable_pte(spte) && !(spte & shadow_dirty_mask)))
-			return true;
-	}
-
-	return false;
-}
-
 /* Rules for using mmu_spte_set:
  * Set the sptep from nonpresent to present.
  * Note: the sptep being assigned *must* be either not present
@@ -590,7 +564,8 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 	u64 old_spte = *sptep;
 	int level = sptep_to_sp(sptep)->role.level;
 
-	if (!spte_has_volatile_bits(old_spte))
+	if (!is_shadow_present_pte(old_spte) ||
+	    !spte_has_volatile_bits(old_spte))
 		__update_clear_spte_fast(sptep, 0ull);
 	else
 		old_spte = __update_clear_spte_slow(sptep, 0ull);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 3d611f07eee8..800b857b3a53 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -90,6 +90,34 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 				     E820_TYPE_RAM);
 }
 
+/*
+ * Returns true if the SPTE has bits that may be set without holding mmu_lock.
+ * The caller is responsible for checking if the SPTE is shadow-present, and
+ * for determining whether or not the caller cares about non-leaf SPTEs.
+ */
+bool spte_has_volatile_bits(u64 spte)
+{
+	/*
+	 * Always atomically update spte if it can be updated
+	 * out of mmu-lock, it can ensure dirty bit is not lost,
+	 * also, it can help us to get a stable is_writable_pte()
+	 * to ensure tlb flush is not missed.
+	 */
+	if (!is_writable_pte(spte) && is_mmu_writable_spte(spte))
+		return true;
+
+	if (is_access_track_spte(spte))
+		return true;
+
+	if (spte_ad_enabled(spte)) {
+		if (!(spte & shadow_accessed_mask) ||
+		    (is_writable_pte(spte) && !(spte & shadow_dirty_mask)))
+			return true;
+	}
+
+	return false;
+}
+
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 570699682f6d..098d7d144627 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -412,6 +412,8 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
+bool spte_has_volatile_bits(u64 spte);
+
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

