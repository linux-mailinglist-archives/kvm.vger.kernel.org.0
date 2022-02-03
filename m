Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AB04A7D18
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348679AbiBCBBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348674AbiBCBBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:19 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D0AC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:18 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id n13-20020a17090a928d00b001b80df27e05so775999pjo.8
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CpxBz2rSpFHFrskwqdmipYbFWhPiqrMn8PP5pj8ez7U=;
        b=m1JYGJaisGEH4T7QmXuoj7WXTaKj+gwcooNraiEcvjGbzn/GJFosljSEkMIl0WYPQz
         dGerQ1UlZlU6fStcTKnNm0JN5xKIrFp0GqR7GECtQ+YBFAcUBer/ptPAMqPBRo1NJbnR
         fh54cI8hJz7XDwNQ02GULCVzLHyyByWSr/KTShzSWG1wuTpX57KEFboFJkbLJyWwM5Sa
         VqktwXwlrtsa7w5kgLQ9TNCArz6uL02QhhlK0RJzvK5xQ9Fu1W2gV9gRalkiY0igWX73
         yPC15xCGhCHIj73m/lIygsC2vVoDytZx84EGi7iPs+/qHXM1XVU1ed8/8s6kH1ave3fy
         TJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CpxBz2rSpFHFrskwqdmipYbFWhPiqrMn8PP5pj8ez7U=;
        b=s1Z+GuvpJitEvT99QdmYraNw0OzqHCE1kuT68WjkvDYIBXAf+hYN5ztREwq25jOc/n
         1ld5bAmy+ZIEmZQuOHwp1+oce8/yYapm91b+3a4V7bo8BNwBRgks4MMje9TTYUZef+th
         /vsNV6Yhsa+Edphd8k61O51AA5m9eRdZDdGEzeZMCZBhmMoSmmGB7pP3slPFwS+jwca9
         9Ql7S0mj/odTOS8SiNEe3BPLgS2q/OEj5SlB52m++V/LyL6Tt+BxoRECSfzhh01wePFj
         Fe2wF/hiTxfrWeIsu6K9EkH65Ew5VGF59tpTkasSpIn0t7MiM8/bj+4dLvKOcTAweUid
         bPng==
X-Gm-Message-State: AOAM533FQThxRn/6mIXqBKaCP4Eond4kxSbjOK4KvcVhlUY8DKGvCE1k
        W1hZoqOyPfV6STtu3RX+lLcikzttUpqOQg==
X-Google-Smtp-Source: ABdhPJxQpSONJqRxVDJXGlKvbxEW3+WV+iwEhrPYoeisLaikAYvcz7Ym+61cml/miI4NPesOudSKWofx7tU2cA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:6b4b:: with SMTP id
 g11mr32942650plt.109.1643850078439; Wed, 02 Feb 2022 17:01:18 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:39 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 11/23] KVM: x86/mmu: Pass const memslot to kvm_mmu_init_sp()
 and descendants
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a const pointer so that kvm_mmu_init_sp() can be called from
contexts where we have a const pointer.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_page_track.h | 2 +-
 arch/x86/kvm/mmu/mmu.c                | 7 +++----
 arch/x86/kvm/mmu/mmu_internal.h       | 2 +-
 arch/x86/kvm/mmu/page_track.c         | 4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c            | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.h            | 2 +-
 6 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index eb186bc57f6a..3a2dc183ae9a 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -58,7 +58,7 @@ int kvm_page_track_create_memslot(struct kvm *kvm,
 				  unsigned long npages);
 
 void kvm_slot_page_track_add_page(struct kvm *kvm,
-				  struct kvm_memory_slot *slot, gfn_t gfn,
+				  const struct kvm_memory_slot *slot, gfn_t gfn,
 				  enum kvm_page_track_mode mode);
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a5e3bb632542..de7c47ee0def 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -805,7 +805,7 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn)
 }
 
 static void account_shadowed(struct kvm *kvm,
-			     struct kvm_memory_slot *slot,
+			     const struct kvm_memory_slot *slot,
 			     struct kvm_mmu_page *sp)
 {
 	gfn_t gfn;
@@ -1384,7 +1384,7 @@ int kvm_cpu_dirty_log_size(void)
 }
 
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
-				    struct kvm_memory_slot *slot, u64 gfn,
+				    const struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level)
 {
 	struct kvm_rmap_head *rmap_head;
@@ -2158,9 +2158,8 @@ static struct kvm_mmu_page *kvm_mmu_get_existing_sp(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-
 static void kvm_mmu_init_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
-			    struct kvm_memory_slot *slot, gfn_t gfn,
+			    const struct kvm_memory_slot *slot, gfn_t gfn,
 			    union kvm_mmu_page_role role)
 {
 	struct hlist_head *sp_list;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index c5f2c0b9177d..e6bcea5a0aa9 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -123,7 +123,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
-				    struct kvm_memory_slot *slot, u64 gfn,
+				    const struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 					u64 start_gfn, u64 pages);
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 68eb1fb548b6..ebd704946a35 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -83,7 +83,7 @@ int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot)
 	return 0;
 }
 
-static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
+static void update_gfn_track(const struct kvm_memory_slot *slot, gfn_t gfn,
 			     enum kvm_page_track_mode mode, short count)
 {
 	int index, val;
@@ -111,7 +111,7 @@ static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
  * @mode: tracking mode, currently only write track is supported.
  */
 void kvm_slot_page_track_add_page(struct kvm *kvm,
-				  struct kvm_memory_slot *slot, gfn_t gfn,
+				  const struct kvm_memory_slot *slot, gfn_t gfn,
 				  enum kvm_page_track_mode mode)
 {
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4ff1af24b5aa..34c451f1eac9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1645,7 +1645,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
  * Returns true if an SPTE was set and a TLB flush is needed.
  */
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, gfn_t gfn,
+				   const struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level)
 {
 	struct kvm_mmu_page *root;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 3f987785702a..b1265149a05d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -64,7 +64,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot);
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, gfn_t gfn,
+				   const struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level);
 
 void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
-- 
2.35.0.rc2.247.g8bbb082509-goog

