Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA74457B66
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237061AbhKTEys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbhKTEyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:33 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F23C0613F6
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:50:59 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id u6-20020a63f646000000b002dbccd46e61so5041269pgj.18
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gd+DQMIWWmZ8zSrxZVBN9w7ZpYdmVvIA44enNSOxRIY=;
        b=s1mq37xMUi9Cnr/98hSSZ3/2pkZucXW+bZjVxXw3fRC8ct7RcPtmiMleTWRHnrwEp+
         xxMyH5MDVw5F4xJKQxvZfskIU+6LjaTaZxfQZx8I++PUXm72sjltApRKG7NhGn77bPYe
         DP/a+ddDNvgYBxzWswq92SUTrJ0ruUl3u/TBOcwnRqGTU1SKb2nWzrv6/NguA37NhmVT
         EwVqtl01slATh702Bpio8OWXieo1u56ZMR21exNMb69bCDOEi2viUcmMtrp60YY2f6Ej
         4OQQn9vIUCTQ0OkggBerIlLv65q1nUwcksLsaN3DV7qOZ/1SnUHZsYlkwjKBM5eUv7Pc
         7Qgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gd+DQMIWWmZ8zSrxZVBN9w7ZpYdmVvIA44enNSOxRIY=;
        b=eus4JyJTOthAuEqDE2SnBOjgVgcdrCViN36lSPHYBx8ey2Y+8ExxhuSoF3+USroS1k
         BLAhwKXEzVw3nqNKK7SpPbQME6WUQeT0jeYLe8HTpgpxmwzZ3F2I/hxaRjqC39tdpVaS
         6U4aEbK5ePCSBrTlfwovZwKEhs3Ilybc5+lhJmqNkTpc3Ofoi/gVSTpHH2iYVYvTMv1J
         dahhyIaX/HSsS8y+MdpIkHI/wnWKZGAHLwS1r+f9BS7RcOScunbLSDLA8RKBtORVV2Ei
         vNSlbF8himhJ1BK0npckGUYWGJHAWVOvli2IWseB2DUWs8UTCWq83WNBLdSlw7MYR22M
         5Izw==
X-Gm-Message-State: AOAM531/xx0/r0bOXTjMJm4Rctuo6hTmy9M/YOAOKv+yIVvgfMW8ThIf
        hlIMpZWH9tGEUUeOvF0P85KTWrq4/wc=
X-Google-Smtp-Source: ABdhPJyH/tnPYyv3zYZy8gmnEQMNUpq06x+CGbjB4ZxohmVEaMkmgD70jTjfYluejU2wTtaOk8Lg7zDfD74=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2290:b0:49f:c63a:2a5f with SMTP id
 f16-20020a056a00229000b0049fc63a2a5fmr69251950pfe.69.1637383859250; Fri, 19
 Nov 2021 20:50:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:21 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-4-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 03/28] KVM: x86/mmu: Remove spurious TLB flushes in TDP MMU
 zap collapsible path
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the "flush" param and return values to/from the TDP MMU's helper for
zapping collapsible SPTEs.  Because the helper runs with mmu_lock held
for read, not write, it uses tdp_mmu_zap_spte_atomic(), and the atomic
zap handles the necessary remote TLB flush.

Similarly, because mmu_lock is dropped and re-acquired between zapping
legacy MMUs and zapping TDP MMUs, kvm_mmu_zap_collapsible_sptes() must
handle remote TLB flushes from the legacy MMU before calling into the TDP
MMU.

Opportunistically drop the local "flush" variable in the common helper.

Fixes: e2209710ccc5d ("KVM: x86/mmu: Skip rmap operations if rmaps not allocated")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  9 ++-------
 arch/x86/kvm/mmu/tdp_mmu.c | 22 +++++++---------------
 arch/x86/kvm/mmu/tdp_mmu.h |  5 ++---
 3 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 457336f67636..d2ad12a4d66e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5861,8 +5861,6 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot)
 {
-	bool flush = false;
-
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		/*
@@ -5870,17 +5868,14 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		 * logging at a 4k granularity and never creates collapsible
 		 * 2m SPTEs during dirty logging.
 		 */
-		flush = slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
-		if (flush)
+		if (slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true))
 			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 		write_unlock(&kvm->mmu_lock);
 	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
-		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
-		if (flush)
-			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
 		read_unlock(&kvm->mmu_lock);
 	}
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4cd6bf7e73f0..1db8496259ad 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1362,10 +1362,9 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
  * Clear leaf entries which could be replaced by large mappings, for
  * GFNs within the slot.
  */
-static bool zap_collapsible_spte_range(struct kvm *kvm,
+static void zap_collapsible_spte_range(struct kvm *kvm,
 				       struct kvm_mmu_page *root,
-				       const struct kvm_memory_slot *slot,
-				       bool flush)
+				       const struct kvm_memory_slot *slot)
 {
 	gfn_t start = slot->base_gfn;
 	gfn_t end = start + slot->npages;
@@ -1376,10 +1375,8 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 
 	tdp_root_for_each_pte(iter, root, start, end) {
 retry:
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true)) {
-			flush = false;
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
-		}
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
@@ -1391,6 +1388,7 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 							    pfn, PG_LEVEL_NUM))
 			continue;
 
+		/* Note, a successful atomic zap also does a remote TLB flush. */
 		if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
 			/*
 			 * The iter must explicitly re-read the SPTE because
@@ -1399,30 +1397,24 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
 			goto retry;
 		}
-		flush = true;
 	}
 
 	rcu_read_unlock();
-
-	return flush;
 }
 
 /*
  * Clear non-leaf entries (and free associated page tables) which could
  * be replaced by large mappings, for GFNs within the slot.
  */
-bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       bool flush)
+void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot)
 {
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
-		flush = zap_collapsible_spte_range(kvm, root, slot, flush);
-
-	return flush;
+		zap_collapsible_spte_range(kvm, root, slot);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 476b133544dd..3899004a5d91 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -64,9 +64,8 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       struct kvm_memory_slot *slot,
 				       gfn_t gfn, unsigned long mask,
 				       bool wrprot);
-bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       bool flush);
+void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot);
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
-- 
2.34.0.rc2.393.gf8c9666880-goog

