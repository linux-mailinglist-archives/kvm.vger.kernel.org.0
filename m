Return-Path: <kvm+bounces-22989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 896A89452D4
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 20:37:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E086288B72
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD5F14F9D4;
	Thu,  1 Aug 2024 18:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0vlCK4Du"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855FE14E2D9
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 18:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722537314; cv=none; b=gRyxwaA2jNOmdYB4v6iBAKc7uVllWppWtb7PkFpjHRjkD6qvpBpUgshVJhxEwLTypWIoDlOhu8vjXik4WlZCo3U4gBf5BY62zXyR13DmnGvbFyPW/Hv1WYj3zFXScR3GyuPYi8b56ktg6EmnxDi22IHGmt2wb5PXol9CWts9Coc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722537314; c=relaxed/simple;
	bh=QjtPf6OwO3F3v2qbeeMqBdAhvi3//8swMm8d6nCHE5E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ogIraGDKahWmwlLPRlcfyK8kC7C/msJVzHvg0QSMGyC5Ab+m1KUMiZn2UKVwq1l8zgV70jtBRXsP1XFahcZoVJm4J8NVE7la2ZurFNip5WQYvZrN02u2j2PxYRbQhNnO0j4uiqAWMDwn8qdi0zkOzuFGmWD/Xr7i50Alf7PBiWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0vlCK4Du; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d1cc32058so6101922b3a.2
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 11:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722537313; x=1723142113; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pjpYJOfuFfBZxoqHyzYZOHO/aDFDcIHjHTQpaKTRfzU=;
        b=0vlCK4DuMb/cGY3MjcBI30JIteqLSMLxIDLShEgeDyBjmBo32FiQfYT0z2cRE01Ent
         LJFmalieCjcyZV5xjEFgd1LvEjVKr1/EMFw6WZLb/H/1Tdcbuk2WIXjP22m+fLM2wtGo
         /vnsYno5ZhfdjGu+zESkheRexa1pTHDrkWZsrZzUJ+GlEKO82GldDIDd6CLdbShu7BOZ
         6CFRZcOEzQAZjQodiJUI0iNuHyY69vs70AWWmP1l1IM7O7lBur/1OPyFQ93SKdDC+UDu
         RFCvQEtCoRHBbGSGinbDRLVPgWtHytidmdSAmNXGuvfVbqzIzFujWkErrN5d2GpMkK7r
         CE4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722537313; x=1723142113;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pjpYJOfuFfBZxoqHyzYZOHO/aDFDcIHjHTQpaKTRfzU=;
        b=F+56O7KSX5k6Md3NBWulM46ZN9ywotwdpda2Ft+9hOQhO8RyDgAXhmtDP6/nPG3zfg
         r2yP8hpbqiGEwQ8Zi3vRRz0qk27zuvHyEcDGPxIVXh3m3lHAKLWxs086UWLPKfeYFFwy
         4TIlUhkwCqO/0mG2F5yQ5RYHe3wqjix0zVaPHIem7kNyoThqWGtENc4/nEH3cCPKnaDH
         l5tQRVe2Kw5/gZfYvDb18p5DW8Txa2vrF//8pZbSR6AvxUwsCGM1G6b6Fn/hFfLvQDye
         VqFIJPqdqSUpiiFDRO8z/0XTA9SRRMp+Gs6/xqOe6VLrvOA0sZbZgiQhYZu8uPxvFNXp
         9POg==
X-Gm-Message-State: AOJu0Yzx+K6cbdESQEWlcn1j9LqgkbZDpmFnR+E+1AE3U9fBHft3Ro3x
	9XdOFDM5ShGlTKIZ3FQk1ktheZs+zLaCKJp+YNUvq2YPGWKMUvCxQRtWducqJ0Bo9EtKW/izeE3
	L6Q==
X-Google-Smtp-Source: AGHT+IFcO+Vr6uQpb300nP1wpu6DqsAAMIX15/3LQD4+pSQyjhlaJV4bhz777we1jEIWnrv4DvkpVknRK04=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f13:b0:70e:9e1b:1a83 with SMTP id
 d2e1a72fcca58-7106d01e048mr17749b3a.2.1722537312706; Thu, 01 Aug 2024
 11:35:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  1 Aug 2024 11:34:53 -0700
In-Reply-To: <20240801183453.57199-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801183453.57199-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240801183453.57199-10-seanjc@google.com>
Subject: [RFC PATCH 9/9] KVM: x86/mmu: Track SPTE accessed info across
 mmu_notifier PROT changes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Preserve Accessed information when zapping SPTEs in response to an
mmu_notifier protection change, e.g. if KVM is zapping SPTEs because
NUMA balancing kicked in.  KVM is not required to fully unmap the SPTE,
and the core VMA information isn't changing, i.e. the information is
still fresh and useful.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ac3200ce00f9..780f35a22c05 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -838,7 +838,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
  * operation can cause a soft lockup.
  */
 static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
-			      gfn_t start, gfn_t end, bool can_yield, bool flush)
+			      gfn_t start, gfn_t end, bool can_yield,
+			      bool keep_accessed_bit, bool flush)
 {
 	struct tdp_iter iter;
 
@@ -849,17 +850,29 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
+		u64 new_spte = SHADOW_NONPRESENT_VALUE;
+
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
 			continue;
 		}
 
+		/*
+		 * Note, this will fail to clear non-present, accessed SPTEs,
+		 * but that isn't a functional problem, it can only result in
+		 * a _potential_ false positive  in the unlikely scenario that
+		 * the primary MMU zaps an hva, reinstalls a new hva, and ages
+		 * the new hva, all before KVM accesses the hva.
+		 */
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
+		if (keep_accessed_bit)
+			new_spte |= iter.old_spte & shadow_accessed_mask;
+
+		tdp_mmu_iter_set_spte(kvm, &iter, new_spte);
 
 		/*
 		 * Zappings SPTEs in invalid roots doesn't require a TLB flush,
@@ -889,7 +902,7 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, -1)
-		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
+		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, false, flush);
 
 	return flush;
 }
@@ -1180,11 +1193,13 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
+	bool keep_a_bit = range->arg.event == MMU_NOTIFY_PROTECTION_VMA ||
+			  range->arg.event == MMU_NOTIFY_PROTECTION_PAGE;
 	struct kvm_mmu_page *root;
 
 	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
 		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
-					  range->may_block, flush);
+					  range->may_block, keep_a_bit, flush);
 
 	return flush;
 }
@@ -1201,7 +1216,11 @@ static void kvm_tdp_mmu_age_spte(struct tdp_iter *iter)
 {
 	u64 new_spte;
 
-	if (spte_ad_enabled(iter->old_spte)) {
+	if (spte_ad_enabled(iter->old_spte) ||
+	    !is_shadow_present_pte(iter->old_spte)) {
+		KVM_MMU_WARN_ON(!is_shadow_present_pte(iter->old_spte) &&
+				iter->old_spte != (SHADOW_NONPRESENT_VALUE | shadow_accessed_mask));
+
 		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
 							 iter->old_spte,
 							 shadow_accessed_mask,
@@ -1235,7 +1254,7 @@ static bool __kvm_tdp_mmu_age_gfn_range(struct kvm *kvm,
 	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
 		rcu_read_lock();
 
-		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
+		tdp_root_for_each_pte(iter, root, range->start, range->end) {
 			if (!is_accessed_spte(iter.old_spte))
 				continue;
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


