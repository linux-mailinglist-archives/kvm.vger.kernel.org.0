Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F68E349F80
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhCZCUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbhCZCUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:20:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18FAC061761
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id t1so8311395ybq.1
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wa2HBnHEdugpF8GI82/VnGsbMbCyax7Usmida2hsXks=;
        b=ntRnGtewMrQnJ0ZyoywcfyJoY3VXcJKm1/k0N8vnJz2sS/sLUavVYbXyZjmGfLujWs
         A7OpVuVgrge9g6sIHyA8kKuuxCVJF4LHDfnRC57c3LwcZMFB52xHIkGZYPVRV7LmBtRX
         cWP26TbhKCHtihLdf8ro8Ar6sN9KG09UTt+Nqp+iYYP5QggYHELX9BtW7vC45YuqRmLX
         +1SmkA8iHzw6bh5WdqcLT6PNv0Z6mPgkElc6VIZ568ErC9hQHNFLULnTTb0JHUFeOKYG
         OVxzIBDlPyjxENSnw4f8tOUFmE9kUrLxpEbgsdwoFB2DPFP1sPp9Ubk2TCAp2h46mMxC
         zPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wa2HBnHEdugpF8GI82/VnGsbMbCyax7Usmida2hsXks=;
        b=kfeB+zNjgujTcZX03Ny0HGJAEJ75uYJUyjLxpivWMGlg0cm/yz92z4DZU4dOA8RjZ3
         GinI1LT8V9uXof7EJGA4fTrV529hzaTM4bzqM7Y0505goMw5n4gY6bEZZMAInb+c7DdD
         qSXAhwV0fPvd8vvge18iW7lT6wjYu5OZMolDeo6Y5aO5vgGCL/bfuXAXk352KSV+UEr1
         oGnlveXg7spOceUtlK2EwTUNH9SOgwq9sXPzcSXcQ+ksbQr5xSXzDWt6UQqNQbZAyypU
         zHupTMOqQ6FPC0b8XkEpcCqVdHhu/p/B47GYrVteRQBKG2zU5m6f84QuZ1HkAzznE4uL
         fycg==
X-Gm-Message-State: AOAM530SL4g31rUqZQd5sY6rohQ+9L/uR1GJAd4ozmf3j9P5jjljvdr4
        sq7UToua6k4k1Gg12zLeppqEw4qUQTE=
X-Google-Smtp-Source: ABdhPJzHMxoOuIYzjF4gA1CiN58yUH1BUsmjnfOuZHCxx1/JoBQt3Lta5tuRC1MywTz941gtZrU1EG9DA4g=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:6f44:: with SMTP id k65mr15773485ybc.218.1616725222218;
 Thu, 25 Mar 2021 19:20:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:44 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 05/18] KVM: x86/mmu: Pass address space ID to __kvm_tdp_mmu_zap_gfn_range()
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

Pass the address space ID to TDP MMU's primary "zap gfn range" helper to
allow the MMU notifier paths to iterate over memslots exactly once.
Currently, both the legacy MMU and TDP MMU iterate over memslots when
looking for an overlapping hva range, which can be quite costly if there
are a large number of memslots.

Add a "flush" parameter so that iterating over multiple address spaces
in the caller will continue to do the right thing when yielding while a
flush is pending from a previous address space.

Note, this also has a functional change in the form of coalescing TLB
flushes across multiple address spaces in kvm_zap_gfn_range(), and also
optimizes the TDP MMU to utilize range-based flushing when running as L1
with Hyper-V enlightenments.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 10 ++++------
 arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 22 +++++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.h      | 13 +++++++------
 4 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e6e02360ef67..36c231d6bff9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5508,17 +5508,15 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 							KVM_MAX_HUGEPAGE_LEVEL,
 							start, end - 1, true, flush);
 		}
+
+		if (is_tdp_mmu_enabled(kvm))
+			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
+							  gfn_end, flush);
 	}
 
 	if (flush)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
 
-	if (is_tdp_mmu_enabled(kvm)) {
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
-		if (flush)
-			kvm_flush_remote_tlbs(kvm);
-	}
-
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 5fe9123fc932..db2faa806ab7 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -129,6 +129,11 @@ static inline bool kvm_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *sp)
 	return !sp->root_count;
 }
 
+static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
+{
+	return sp->role.smm ? 1 : 0;
+}
+
 /*
  * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
  *
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ff2bb0c8012e..bf279fff70ea 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -190,11 +190,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level,
 				bool shared);
 
-static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
-{
-	return sp->role.smm ? 1 : 0;
-}
-
 static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 {
 	if (!is_shadow_present_pte(old_spte) || !is_last_spte(old_spte, level))
@@ -709,14 +704,16 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
  */
-bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
-				 bool can_yield)
+bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
+				 gfn_t end, bool can_yield, bool flush)
 {
 	struct kvm_mmu_page *root;
-	bool flush = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root)
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
+		if (kvm_mmu_page_as_id(root) != as_id)
+			continue;
 		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
+	}
 
 	return flush;
 }
@@ -724,9 +721,12 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
 	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
-	bool flush;
+	bool flush = false;
+	int i;
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, max_gfn, flush);
 
-	flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn);
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 9ecd8f79f861..f224df334382 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -8,12 +8,12 @@
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
-bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
-				 bool can_yield);
-static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start,
-					     gfn_t end)
+bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
+				 gfn_t end, bool can_yield, bool flush);
+static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
+					     gfn_t start, gfn_t end, bool flush)
 {
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, start, end, true);
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
 }
 static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -28,7 +28,8 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	 * requirement), its "step sideways" will always step beyond the bounds
 	 * of the shadow page's gfn range and stop iterating before yielding.
 	 */
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn, end, false);
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, kvm_mmu_page_as_id(sp),
+					   sp->gfn, end, false, false);
 }
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 
-- 
2.31.0.291.g576ba9dcdaf-goog

