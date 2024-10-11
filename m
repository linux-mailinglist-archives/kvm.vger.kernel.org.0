Return-Path: <kvm+bounces-28592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DBC4999A2F
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:16:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 921401F2457E
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FFB1FB3ED;
	Fri, 11 Oct 2024 02:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FdgOyntl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAC81FB3D3
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612687; cv=none; b=gCnjRQmEF/nyy1nVAHeWpxogiMuanTFmdXSuXjaWy7R2xIToIJtk9S6v0Mdx1Z42sSdtFyfFKKRaR6FGvTg2ep9K+xdTIASZ9fNhbNWcOWMV22po9j4CI0WHgWDYTf6KvaPEXEVhRuchZh027vCQbum+VFqmqW42WnUhfdPWm8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612687; c=relaxed/simple;
	bh=LNXuTGR2S+iPgGGEX03rlcOFXKsH1faw0ZPmJ58DiOE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L9qmva7jq7pJf7RABVn2MbEZMl00AnfI2jU/47zSvw7kx7GJWFFGd0sA8Fcbp4b4HLDlLscj7vWPVTMlsBe6lF3r7M88ccaLf/WSSNJZLGHA8DlTjXLQR4QHnflz2OCTNu8twcmPnMVsWW3u6TmCiTeYN7JaHM7QP+v3lEnZJsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FdgOyntl; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-70ac9630e3aso1543351a12.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612685; x=1729217485; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CEg0IFfdUu4UELrQOXo0lUcfHQKNBNnbMq1djiDkWGQ=;
        b=FdgOyntliR+R53ku1l+8JOs7WqGHgzY5J/dK5vP4+B/B6lw9kgD+qUduihpl8medjW
         ms2yX97jx7+MevWVzcwv0I/VWrHae4vpGT5Umxt+PwocoL3karL2rybxy7ihNByAsvT7
         cTNCE6S6CdhsYwEIcq5LbRSPEAm3smllOxDeTPuvw405/MbFTfPdsKRgcMS7KFMkkL4J
         sdD4CEmksfwBvI1oo/NZq+KhmArReJnxzUjI4LEFmtgJid28LVEhAeHD9fC7gqK8Ko4h
         pQLCcYdRzS6bcYh3GRxkYFg9XyWm4WD+6SInx85SwUnlAP8G4+fqi1tNIsJNleQv2owJ
         pWuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612685; x=1729217485;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CEg0IFfdUu4UELrQOXo0lUcfHQKNBNnbMq1djiDkWGQ=;
        b=q9OXZAntR7h30WCiCK2aDunNAZZKws4SyONVipiirqqsDUxQvPzTWYf07B7p/CcMDw
         fDSmThArdGXAXjROeRpcDF5Ksu3Y6h1EU22Fh3hkrEv3I2WEG5bcEKmJp0fP4UAtKZEv
         gLi4XaCmMJqYNurJzL9t4yZM5OXfjHWxxc2bz++TTrNUe2iazUDE0vJ0rSxhkt5aGpTG
         KWG5aIz7QF4iqUpehZ4yrDCtxHiX9l7qclRfceHOGC9mzvjv4M2wZMf/wdmU+iKRtl0a
         J0gajSIEK7IkgkCQis5x2YangzExhL6yZVD0wsjHVEROJ4XovOzdmXAgIN+HO/rQ47Cr
         tvZA==
X-Gm-Message-State: AOJu0Yw+VVrSuzsy4YjvzeK4geJIt0ShhiNiJCsv3V4Teoso+QTfbAHy
	0Krc+I7aUb8OGt3zglb3Yun0lxSfQVPzn8BsF2cY064UrMcxhdVDKB3UGRH/0FHPTPbyGvX8ovb
	K/w==
X-Google-Smtp-Source: AGHT+IHOAZfcUyAOkGK8+VjEG0Gb80ABIViSbVLqAW+P+s1wcIQgbwkQ7kkxk7jRjasA/YCkTBO3YYYn+wk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:f8a:b0:7cd:8b5f:2567 with SMTP id
 41be03b00d2f7-7ea535255a7mr911a12.4.1728612683541; Thu, 10 Oct 2024 19:11:23
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:47 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-16-seanjc@google.com>
Subject: [PATCH 15/18] KVM: x86/mmu: Dedup logic for detecting TLB flushes on
 leaf SPTE changes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the shadow MMU and TDP MMU have identical logic for detecting
required TLB flushes when updating SPTEs, move said logic to a helper so
that the TDP MMU code can benefit from the comments that are currently
exclusive to the shadow MMU.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 19 +------------------
 arch/x86/kvm/mmu/spte.h    | 29 +++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c |  3 +--
 3 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5be3b5f054f1..f75915ff33be 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -488,23 +488,6 @@ static void mmu_spte_set(u64 *sptep, u64 new_spte)
 /* Rules for using mmu_spte_update:
  * Update the state bits, it means the mapped pfn is not changed.
  *
- * If the MMU-writable flag is cleared, i.e. the SPTE is write-protected for
- * write-tracking, remote TLBs must be flushed, even if the SPTE was read-only,
- * as KVM allows stale Writable TLB entries to exist.  When dirty logging, KVM
- * flushes TLBs based on whether or not dirty bitmap/ring entries were reaped,
- * not whether or not SPTEs were modified, i.e. only the write-tracking case
- * needs to flush at the time the SPTEs is modified, before dropping mmu_lock.
- *
- * Don't flush if the Accessed bit is cleared, as access tracking tolerates
- * false negatives, and the one path that does care about TLB flushes,
- * kvm_mmu_notifier_clear_flush_young(), flushes if a young SPTE is found, i.e.
- * doesn't rely on lower helpers to detect the need to flush.
- *
- * Lastly, don't flush if the Dirty bit is cleared, as KVM unconditionally
- * flushes when enabling dirty logging (see kvm_mmu_slot_apply_flags()), and
- * when clearing dirty logs, KVM flushes based on whether or not dirty entries
- * were reaped from the bitmap/ring, not whether or not dirty SPTEs were found.
- *
  * Returns true if the TLB needs to be flushed
  */
 static bool mmu_spte_update(u64 *sptep, u64 new_spte)
@@ -527,7 +510,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 	WARN_ON_ONCE(!is_shadow_present_pte(old_spte) ||
 		     spte_to_pfn(old_spte) != spte_to_pfn(new_spte));
 
-	return is_mmu_writable_spte(old_spte) && !is_mmu_writable_spte(new_spte);
+	return is_tlb_flush_required_for_leaf_spte(old_spte, new_spte);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index c8dc75337c8b..a404279ba731 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -467,6 +467,35 @@ static inline bool is_mmu_writable_spte(u64 spte)
 	return spte & shadow_mmu_writable_mask;
 }
 
+/*
+ * If the MMU-writable flag is cleared, i.e. the SPTE is write-protected for
+ * write-tracking, remote TLBs must be flushed, even if the SPTE was read-only,
+ * as KVM allows stale Writable TLB entries to exist.  When dirty logging, KVM
+ * flushes TLBs based on whether or not dirty bitmap/ring entries were reaped,
+ * not whether or not SPTEs were modified, i.e. only the write-tracking case
+ * needs to flush at the time the SPTEs is modified, before dropping mmu_lock.
+ *
+ * Don't flush if the Accessed bit is cleared, as access tracking tolerates
+ * false negatives, and the one path that does care about TLB flushes,
+ * kvm_mmu_notifier_clear_flush_young(), flushes if a young SPTE is found, i.e.
+ * doesn't rely on lower helpers to detect the need to flush.
+ *
+ * Lastly, don't flush if the Dirty bit is cleared, as KVM unconditionally
+ * flushes when enabling dirty logging (see kvm_mmu_slot_apply_flags()), and
+ * when clearing dirty logs, KVM flushes based on whether or not dirty entries
+ * were reaped from the bitmap/ring, not whether or not dirty SPTEs were found.
+ *
+ * Note, this logic only applies to shadow-present leaf SPTEs.  The caller is
+ * responsible for checking that the old SPTE is shadow-present, and is also
+ * responsible for determining whether or not a TLB flush is required when
+ * modifying a shadow-present non-leaf SPTE.
+ */
+static inline bool is_tlb_flush_required_for_leaf_spte(u64 old_spte,
+						       u64 new_spte)
+{
+	return is_mmu_writable_spte(old_spte) && !is_mmu_writable_spte(new_spte);
+}
+
 static inline u64 get_mmio_spte_generation(u64 spte)
 {
 	u64 gen;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f412bca206c5..615c6a84fd60 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1034,8 +1034,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		return RET_PF_RETRY;
 	else if (is_shadow_present_pte(iter->old_spte) &&
 		 (!is_last_spte(iter->old_spte, iter->level) ||
-		  WARN_ON_ONCE(is_mmu_writable_spte(iter->old_spte) &&
-			       !is_mmu_writable_spte(new_spte))))
+		  WARN_ON_ONCE(is_tlb_flush_required_for_leaf_spte(iter->old_spte, new_spte))))
 		kvm_flush_remote_tlbs_gfn(vcpu->kvm, iter->gfn, iter->level);
 
 	/*
-- 
2.47.0.rc1.288.g06298d1525-goog


