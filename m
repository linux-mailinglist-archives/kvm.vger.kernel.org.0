Return-Path: <kvm+bounces-23787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DEC1F94D79D
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:47:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B3031F24F8B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF17E16728B;
	Fri,  9 Aug 2024 19:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yOPfdfbk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3D91990C3
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232643; cv=none; b=CkFEu/i4lPBLVev1tLluyWJ+YNbH7vQVTj2fdZxMruRtBW4vIiLyLy19TgiwUkKZQAtxSHrJvHcTG603cBnwngQBIlNz8c0d8i0KulP3n6/jVAkoiJialc3dJSMxd1PVjlJwWb3WrenSq2Xst3UJT/S1COWUUpZxYWI8XmAIl+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232643; c=relaxed/simple;
	bh=Q4/0S9zjurXdMR/Xc6/7FhGHVIB+yXDEQA05A1JT85k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YTHnXO3VApeHEa0gHQTLEItqNj/Rs3FxDrgqTEzp0L57l9/u12txDA9EoNKhOIr8HkIxl+OUUdwZcly3Z7DtpwGmhn95FdP3wjzddYmwmWxGyBepqCxWqKJ+PwQnj06JeM/cbuN7YEXz2pdaQ+2t0eL44Acwdf/nc97AWIRr0CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yOPfdfbk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb68c23a00so3335752a91.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232641; x=1723837441; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RZnIwpm2DX6oLiBTd7LSzopcPIvohhjKZPunqiEaNiE=;
        b=yOPfdfbkTACJtGhMaGp8/glp73j/d1XutUuiT1/hOrk0OHG2Co/fiHKEI+gpRxzY7P
         HI7Ng6xM24W+fzHZk14tpEPSlhZM1IDhxlrj7p6VBLQhllP4gAh9ZQsBmRW1d83yMiv4
         E3V4t34SmWHKgTNXoKZq6qoDyotqBwVv0cpRq5Z0bxkoZ8mmVhctJP4O/ljfqaCamKt4
         fQzCBe610zoObazsxBFS8IxbwVgoURES985c6oS0jIas/xkEsZHYXqAa3/625u/xaJLq
         becO5cYeFiS+KjddHSpsu8gGzOnHu8l4J/IkG5fSzEehedxR7GiqWSrDaKI8Etsn55sn
         9GyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232641; x=1723837441;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RZnIwpm2DX6oLiBTd7LSzopcPIvohhjKZPunqiEaNiE=;
        b=nBTLyhZA35Ovo8y5DR5pq2BMkp0ku7GLeTAb3lyV31LTjQX01alRLjIIqxblibI89i
         X2mqp3+DsFvfEqC3CLlet+X1buGBUl9AbSLqb3ZLdBdU5vJkhjzSfWKJLfq1XSVZGhKs
         fJTW3wNcBvrw8qQ2RruJHtdTpZmILZhG9DvTNeCX7dVrN+QnGovoLlV9fpVj9rHB4TbA
         Dy/WjVniq32zwDVyb3Qf4o9eOgqxeKR4x7rSHVYZbUlt1aoDeMKBUhTScqIEHzWwkNIQ
         03plDvJeH9xBbYXF3jhTAb46g4k4fDgFVer1m/BAJlrrO1uDp+9hMcTANDY4vBPD/Fzv
         xFBQ==
X-Gm-Message-State: AOJu0YxpZRU6mwwqI2gVoECQClvXbv4XCfYqIefr3BoMhHfQ7t5JLJle
	UhDHioKvqPko5ra735H6AvduMVuuF4ZmJZ4rvYmNbnzZXHJmm1kEwS0J7lzLKc/saDsAVa+Q+B3
	vew==
X-Google-Smtp-Source: AGHT+IEVMPLIN0gtxbuCx2PJeNj0X98BYvziqTLoHJHpzW4rfW380DSvpsuYxUtuP8Md6WisaeszFgzwm+A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:68c4:b0:2ca:7f5a:db6c with SMTP id
 98e67ed59e1d1-2d1c4c45398mr42369a91.3.1723232640835; Fri, 09 Aug 2024
 12:44:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:23 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-12-seanjc@google.com>
Subject: [PATCH 11/22] KVM: x86/mmu: Plumb a @can_yield parameter into __walk_slot_rmaps()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a @can_yield param to __walk_slot_rmaps() to control whether or not
dropping mmu_lock and conditionally rescheduling is allowed.  This will
allow using __walk_slot_rmaps() and thus cond_resched() to handle
mmu_notifier invalidations, which usually allow blocking/yielding, but not
when invoked by the OOM killer.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 676cb7dfcbf9..a5a7e476f5bb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1545,7 +1545,8 @@ static __always_inline bool __walk_slot_rmaps(struct kvm *kvm,
 					      slot_rmaps_handler fn,
 					      int start_level, int end_level,
 					      gfn_t start_gfn, gfn_t end_gfn,
-					      bool flush_on_yield, bool flush)
+					      bool can_yield, bool flush_on_yield,
+					      bool flush)
 {
 	struct slot_rmap_walk_iterator iterator;
 
@@ -1556,6 +1557,9 @@ static __always_inline bool __walk_slot_rmaps(struct kvm *kvm,
 		if (iterator.rmap)
 			flush |= fn(kvm, iterator.rmap, slot);
 
+		if (!can_yield)
+			continue;
+
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
 			if (flush && flush_on_yield) {
 				kvm_flush_remote_tlbs_range(kvm, start_gfn,
@@ -1577,7 +1581,7 @@ static __always_inline bool walk_slot_rmaps(struct kvm *kvm,
 {
 	return __walk_slot_rmaps(kvm, slot, fn, start_level, end_level,
 				 slot->base_gfn, slot->base_gfn + slot->npages - 1,
-				 flush_on_yield, false);
+				 true, flush_on_yield, false);
 }
 
 static __always_inline bool walk_slot_rmaps_4k(struct kvm *kvm,
@@ -6528,7 +6532,7 @@ static bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_e
 
 			flush = __walk_slot_rmaps(kvm, memslot, __kvm_zap_rmap,
 						  PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
-						  start, end - 1, true, flush);
+						  start, end - 1, true, true, flush);
 		}
 	}
 
@@ -6816,7 +6820,7 @@ static void kvm_shadow_mmu_try_split_huge_pages(struct kvm *kvm,
 	 */
 	for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--)
 		__walk_slot_rmaps(kvm, slot, shadow_mmu_try_split_huge_pages,
-				  level, level, start, end - 1, true, false);
+				  level, level, start, end - 1, true, true, false);
 }
 
 /* Must be called with the mmu_lock held in write-mode. */
-- 
2.46.0.76.ge559c4bf1a-goog


