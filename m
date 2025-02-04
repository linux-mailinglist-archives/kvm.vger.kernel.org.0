Return-Path: <kvm+bounces-37196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EBB6EA268BC
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:42:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A1707A1A80
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EAAC145A11;
	Tue,  4 Feb 2025 00:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oK/dptWb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f73.google.com (mail-vs1-f73.google.com [209.85.217.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C2078F4A
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 00:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629662; cv=none; b=WPqHDxGN/iAWAk+/GggYkcls6DMmrgecMYOz/hh67oigmjYOjEEiCRJQ4+v6EjH7hSPGjMtp3a20hM1OfbvlM7DvajNksJQpx32HPSJB0VsC+AwVZVWiVh5xg7X4auwViayfAHzb4bIfsx6WuygMHUHPqNFQdj5tsEYnU8JRuZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629662; c=relaxed/simple;
	bh=laK1gDLMFvyUOb7SAvftZWPYqAgaPTCfy3IryJLdS2o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QRRmlkHmHJwgr8bqOkxHFjNxgwMqqF9OhIWpqqxmoO1ZCzHJHBvuK8rh9MsrHc/2IQcXxz1Zzk/HM+QtcSfZs+DqKDM3/68ihOKbVgJ7gf/f6Tq9YXat8Fk6ZkFeyVpzgHvwQWXx3l4MrtxP1JCNTBYzw6v537z7KmvuuXbRoc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oK/dptWb; arc=none smtp.client-ip=209.85.217.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f73.google.com with SMTP id ada2fe7eead31-4affbf5361eso602214137.0
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 16:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738629659; x=1739234459; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UClTVLduxzV//E3HpIXY8T1q8+8Xs6EHUNjdjil8pCk=;
        b=oK/dptWb3NxpzG3CGLqtB8xIjYbYX+ekgAPHYpotDE8cKKviHiklqTSxcHcJT+lhWn
         s4SgDu2vB9EaRKwSZ/OWCB62lwaA1fExkAKbU4J65oiuDp23nM08+YMyGXjcFg9x+3EC
         INkUAhStVpd8Ulrax51Wr35FoG5qxoX5CODKn4/FpzttpJCdmssqCyu+YT3xyW2ob9Ez
         lsTT3lwmeOQOd1ncRRRmnOgdX1DkX5CeIcZPXRcMCqCq/AFH+5R0RWjuaZp0N1KpNQZX
         ePPQq51V0B2ENKMI5o8EQMwJir0g4Uq5DIvgyZuwem7H1+j0sXP2JJ3c18R79PsK6OUB
         ujqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738629659; x=1739234459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UClTVLduxzV//E3HpIXY8T1q8+8Xs6EHUNjdjil8pCk=;
        b=PXxVzB/s/wBRQZMgwudJQQ9nXkUdGJEu/2KwbW9TWvjqV1CJeNI2YHgpkReM0z8g2U
         ER8ZvHCGrfUHWOw8PA5N/VnKcddZzvGxmKpaOu81LfXrCSuW43a+D7unoqAklUsFZj90
         eoE4OeUz9vpDO2k4Y+EquL4D+vsoIBvrIfll9vxI5czKyTElY4QVAs8iuDcvaTkkbc2i
         G2eswpmCradal/zKG6557gIBB3edSUWolgDI6dtHEgcIpW1pYUW0zA83Bph9O3XiDBvJ
         ADyZCd3obLLHXYZR7I9HjlYYZz6Ma+30RuAPJ4v6qjTd6X2G6sRZmFsiOWg7JdpocOED
         oY4g==
X-Forwarded-Encrypted: i=1; AJvYcCWLHWFEiPfRfNbYs2hG0QcRqiI5OfQ6bSTC/XGnxi5kffWBu++jUs0HbirnfTAqqbbWTeo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOKTO7i6dkjBxrVeant/qq0nqo7TFsuq9PW8FASaWl9IJEmx+y
	+JcE4+87ximnsHQBblieEsA0iCWxIyADomgt/93+nyAvu1xROZF3IAuV4IcgT6Sx82dEhC0vjrL
	wZg5MngbPsJmjibFi1Q==
X-Google-Smtp-Source: AGHT+IFoYCI+/fk9XlW4Og9OojNpJjeFqCn4vcpYW8e9yXKsurANBIx2UF+cPzuP7f1QaF+j3i3290eON/+qh+LD
X-Received: from vsbij9.prod.google.com ([2002:a05:6102:5e89:b0:4af:ac82:5669])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:54a0:b0:4b2:5c0a:9aff with SMTP id ada2fe7eead31-4b9a4ec8e82mr19199359137.3.1738629659286;
 Mon, 03 Feb 2025 16:40:59 -0800 (PST)
Date: Tue,  4 Feb 2025 00:40:32 +0000
In-Reply-To: <20250204004038.1680123-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204004038.1680123-6-jthoughton@google.com>
Subject: [PATCH v9 05/11] KVM: x86/mmu: Rename spte_has_volatile_bits() to spte_needs_atomic_write()
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

spte_has_volatile_bits() is now a misnomer, as the an SPTE can have its
Accessed bit set or cleared without the mmu_lock held, but the state of
the Accessed bit is not checked in spte_has_volatile_bits().
Even if a caller uses spte_needs_atomic_write(), Accessed bit
information may still be lost, but that is already tolerated, as the TLB
is not invalidated after the Accessed bit is cleared.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 Documentation/virt/kvm/locking.rst | 4 ++--
 arch/x86/kvm/mmu/mmu.c             | 4 ++--
 arch/x86/kvm/mmu/spte.c            | 9 +++++----
 arch/x86/kvm/mmu/spte.h            | 2 +-
 arch/x86/kvm/mmu/tdp_iter.h        | 2 +-
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index c56d5f26c750..4720053c70a3 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -196,7 +196,7 @@ writable between reading spte and updating spte. Like below case:
 The Dirty bit is lost in this case.
 
 In order to avoid this kind of issue, we always treat the spte as "volatile"
-if it can be updated out of mmu-lock [see spte_has_volatile_bits()]; it means
+if it can be updated out of mmu-lock [see spte_needs_atomic_write()]; it means
 the spte is always atomically updated in this case.
 
 3) flush tlbs due to spte updated
@@ -212,7 +212,7 @@ function to update spte (present -> present).
 
 Since the spte is "volatile" if it can be updated out of mmu-lock, we always
 atomically update the spte and the race caused by fast page fault can be avoided.
-See the comments in spte_has_volatile_bits() and mmu_spte_update().
+See the comments in spte_needs_atomic_write() and mmu_spte_update().
 
 Lockless Access Tracking:
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7779b49f386d..1fa0f47eb6a5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -501,7 +501,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 		return false;
 	}
 
-	if (!spte_has_volatile_bits(old_spte))
+	if (!spte_needs_atomic_write(old_spte))
 		__update_clear_spte_fast(sptep, new_spte);
 	else
 		old_spte = __update_clear_spte_slow(sptep, new_spte);
@@ -524,7 +524,7 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 	int level = sptep_to_sp(sptep)->role.level;
 
 	if (!is_shadow_present_pte(old_spte) ||
-	    !spte_has_volatile_bits(old_spte))
+	    !spte_needs_atomic_write(old_spte))
 		__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
 	else
 		old_spte = __update_clear_spte_slow(sptep, SHADOW_NONPRESENT_VALUE);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index e984b440c0f0..ae2017cc1239 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -129,11 +129,12 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 }
 
 /*
- * Returns true if the SPTE has bits that may be set without holding mmu_lock.
- * The caller is responsible for checking if the SPTE is shadow-present, and
- * for determining whether or not the caller cares about non-leaf SPTEs.
+ * Returns true if the SPTE has bits other than the Accessed bit that may be
+ * changed without holding mmu_lock. The caller is responsible for checking if
+ * the SPTE is shadow-present, and for determining whether or not the caller
+ * cares about non-leaf SPTEs.
  */
-bool spte_has_volatile_bits(u64 spte)
+bool spte_needs_atomic_write(u64 spte)
 {
 	if (!is_writable_pte(spte) && is_mmu_writable_spte(spte))
 		return true;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 59746854c0af..4c290ae9a02a 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -519,7 +519,7 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
-bool spte_has_volatile_bits(u64 spte);
+bool spte_needs_atomic_write(u64 spte);
 
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 05e9d678aac9..b54123163efc 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -55,7 +55,7 @@ static inline bool kvm_tdp_mmu_spte_need_atomic_write(u64 old_spte, int level)
 {
 	return is_shadow_present_pte(old_spte) &&
 	       is_last_spte(old_spte, level) &&
-	       spte_has_volatile_bits(old_spte);
+	       spte_needs_atomic_write(old_spte);
 }
 
 static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
-- 
2.48.1.362.g079036d154-goog


