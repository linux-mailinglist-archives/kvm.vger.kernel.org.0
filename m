Return-Path: <kvm+bounces-28583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D74D5999A1C
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 485421F244F3
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75B91F8911;
	Fri, 11 Oct 2024 02:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qdz8Pfor"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55961F706C
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612668; cv=none; b=Eqf6eWP/T1/qfbAZDuCl6fa/k/8caVbNYxPRZEzQju5odYETkEqMH4xWnCPrYVm3ASibcBxCZ8ggk18Uk04I/0T63PsCxUIA+TKgutaJwZ+MAwMXE3ZMwVp34BOCmHtcZV+riKapbqbYS/wSLuttKKd4kAV+zJXF/kFxivM1iyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612668; c=relaxed/simple;
	bh=6ySxcwhwrHJlZ4I/ATeASq5WDemLJ6Yi/XYtpmqlx9I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lQ4G02qhnTsX9mfYv2U21HMRyLpeSV1qQc8qo8RockzyVwelEFhHh1e7GD02/wFD3PMqM+wSoW6TSjTWU3iNEfVw++um7+PlzghZ+6kbi0k0NDEtmGfDdwM0CbRPLvd0ufZ/x57vp2eJ/AZzjXt/k4f13DFsGTIhGDvXVm8IBx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qdz8Pfor; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e3497c8eb0so3111937b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612665; x=1729217465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=J6fJWudgoyhjNeokLMIpfJOGPiEm4NW5MKaOgNe3m0c=;
        b=Qdz8PforVMb9xifm6HVypigyoGtQkLdh8cmmpSJq/4lfTLbHDzO/EM0BzRV6d/uXaP
         7fOuj0sXvznIu7E36BFljQ5hZmve8tGVcRyZ1ot+YpGrc+vYIWJOfiQ3RX256/oklpF4
         t4QrvRqvOGr2/gFVefXFvHDFGtMw7gDrcloEU3rLlHp6W+Wsygnb4zZct9IcQU8hi+Pz
         H2zTMj6XX7HqHfZWR1W1Rn/Tf1Rw5qy3cJFKh2R0I9Wy87ynC16YuXp9GeYkMsIsMxgo
         cF+AiNK17BnBcWGufdj6dI6r7ksgK72CPH5OkX7cQSZPN7cZ0ylAH79WALIpfbYvAHw9
         DGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612665; x=1729217465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J6fJWudgoyhjNeokLMIpfJOGPiEm4NW5MKaOgNe3m0c=;
        b=Olk2RWop4mfc+RWLNGbG8NoEls6lEBzZiT/sQUZQVjhX6AxwI2M2e/UDt4WsSn+TyT
         9pDjt/CJ+fVVo3GAdFS44sWPTJBaonUgV7s2ATw9xzRMl1IYASzWNDhI3g8vt9HGZQUm
         I4jMqz44yOy6+f1yA6sz55olTzO0WPTuU71I5KIs32g7A6EdFZr7bQGf5hB0p+ZZbWhT
         L04viezHWS8LeFOZ1mkeFAZzHVMYptY+vflkSqxlUUThGIaoAxh4gbSVMoPOzp0JzuSx
         3lOV1Ao/rKCwh6U02TYO6uzYgCx8xV+2/PC27q6IDmjr/e8D7b8gdioC1S9SDvgcCW8C
         3ihA==
X-Gm-Message-State: AOJu0YzdNUGEcMQXiIoxX/70pH6058eAocQYnk+9fa/+NkVtRey0kFZC
	FdlSlb4jKpAaqj1rZTBzier9hpv0zSboLAd/z3GN1GQkf6ecaKrXQlGXKqojelZEg2KBtnQVgQQ
	r7A==
X-Google-Smtp-Source: AGHT+IFbXi1dCiXSidWjoezcs3LfAr39NDQ+HaYJkXB3Sn0xMqcrzqVDZ2BFbhCf6XdaWRZ36muZ7O1FhMs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4706:b0:6e2:a355:7b5c with SMTP id
 00721157ae682-6e32f33bf7emr548257b3.5.1728612664905; Thu, 10 Oct 2024
 19:11:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:38 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-7-seanjc@google.com>
Subject: [PATCH 06/18] KVM: x86/mmu: Drop ignored return value from kvm_tdp_mmu_clear_dirty_slot()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the return value from kvm_tdp_mmu_clear_dirty_slot() as its sole
caller ignores the result (KVM flushes after clearing dirty logs based on
the logs themselves, not based on SPTEs).

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 20 ++++++--------------
 arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 91caa73a905b..9c66be7fb002 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1492,13 +1492,12 @@ static bool tdp_mmu_need_write_protect(struct kvm_mmu_page *sp)
 	return kvm_mmu_page_ad_need_write_protect(sp) || !kvm_ad_enabled();
 }
 
-static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			   gfn_t start, gfn_t end)
+static void clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+				  gfn_t start, gfn_t end)
 {
 	const u64 dbit = tdp_mmu_need_write_protect(root) ? PT_WRITABLE_MASK :
 							    shadow_dirty_mask;
 	struct tdp_iter iter;
-	bool spte_set = false;
 
 	rcu_read_lock();
 
@@ -1519,31 +1518,24 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		if (tdp_mmu_set_spte_atomic(kvm, &iter, iter.old_spte & ~dbit))
 			goto retry;
-
-		spte_set = true;
 	}
 
 	rcu_read_unlock();
-	return spte_set;
 }
 
 /*
  * Clear the dirty status (D-bit or W-bit) of all the SPTEs mapping GFNs in the
- * memslot. Returns true if an SPTE has been changed and the TLBs need to be
- * flushed.
+ * memslot.
  */
-bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
+void kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 				  const struct kvm_memory_slot *slot)
 {
 	struct kvm_mmu_page *root;
-	bool spte_set = false;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
-		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
-				slot->base_gfn + slot->npages);
-
-	return spte_set;
+		clear_dirty_gfn_range(kvm, root, slot->base_gfn,
+				      slot->base_gfn + slot->npages);
 }
 
 static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 1b74e058a81c..d842bfe103ab 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -34,7 +34,7 @@ bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 
 bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 			     const struct kvm_memory_slot *slot, int min_level);
-bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
+void kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 				  const struct kvm_memory_slot *slot);
 void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       struct kvm_memory_slot *slot,
-- 
2.47.0.rc1.288.g06298d1525-goog


