Return-Path: <kvm+bounces-22371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F1393DB55
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 01:55:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D75E1F24586
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 23:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8D915B0E6;
	Fri, 26 Jul 2024 23:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KcdC67np"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A881598EE
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037977; cv=none; b=VchtTwt6GZtx0eUsDtzHMbWcbh+0z7cWlhOnG3WmRAhqU7HLPrVlhVU5H6tWCboQSXtdSgH+Bqj43INB7IEW1kzW+oLhqlKPghwA8pS+AdPRax7TNGLCWFWE1kj7XDsvD93Qoc3PED1ZuI5r9pBrH+StiCvYO3hkiSQxf71SIrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037977; c=relaxed/simple;
	bh=BpefGVw3ai5MyZqnGpqT/DkM64xZIHhkO67jsUqUIys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tyeFyJDK37NNRPPd1hN4B0xKHyteE0glFUS3eJ6Gh0rqgtiAi8ZGBCIRKStAQ160SrRFCxXPuZ5Zg0cYwQX1WcvUScHUclsM8LKZ6UfJ5zWcCqQ8Yt6K5qBrOq4CfQ+eYEPhdl6VyKoHCXbQ3S5blqz8W3GTidz2u58L7rRufHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KcdC67np; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-664ccf0659cso6135777b3.1
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037974; x=1722642774; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Dpyi/TQvAabfHqvBiXmrWwwqtiSCC0ukXFLvczoDhHE=;
        b=KcdC67npj0TSKJPWMIOjBYz5BC6rRp3oSzV1GZy6lTT8BP9rI3t5P9Vy4Zs49XGVwX
         7SU18jxLk/Ian3AK9DVvxrXW741yG/ikB2NpWee3xhPNXm0uC2A16VolFBtbFkqax2F1
         fV2QB716kApSdes4JMFukG4zbfC+WMgqFnM9QJLp33344RyZ2sjkoTR5halQCk7+spp/
         WcSaXPP/XO4c4mmyyoVoKD5Cz6HZfzwl5DzT2iC3dNj8TsuNkMvCsUwLGdJXk9d0EAee
         FwFtub9t4Tg2Iqs4+RdHgufUFTYqRjzKLZGRLUn/anEJ12nl2c3Mh/Gyk5hjCsFHchDH
         VEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037974; x=1722642774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dpyi/TQvAabfHqvBiXmrWwwqtiSCC0ukXFLvczoDhHE=;
        b=HhsZRiyBwhr/Yd+S4JbGdio3CY709zxujqhO45sYKSrIAt6ZU0Af0cpCBXzl4YyHFg
         lgqFkOumJLJG7+5LXzSX4dEvsTLeuJiyh02PQQhBjWXl3aIFUWopJv5w9OGThtdcYwsE
         49/KVFIXBWgHK7Ur7KSSeB18RRv006ZQwFm/pgrpyX2FfnXuqmDqNz8f1wVxeVz9t2B+
         8mo6aJJaWyW4id82+4yegUWldF0iNcVfYzRU0JYx4tuX5cPHMG+Cu/mswSaVnfqPq4vt
         vLgjVhvRfUWZkFcVW9/n+tvWXqhbXPJTV8mllpkFnEQisYccB2+BLXgHwJiPoEjVmRrK
         eKwA==
X-Gm-Message-State: AOJu0YyQXXNaSIInMuwhnZVK+Y1zjxzjB/+10F+ylC2oLVm3ZRcUu7C9
	lPw4yBEgAgVHRm/LIf9fMFkEAnLmCIBKYkOGnTI8dgLpHxv02SxjlIiDAaiUkL8X31q8PS3QRxQ
	n4Q==
X-Google-Smtp-Source: AGHT+IEuz+UKgzDWJGr0lPjm3UdUlqhv4uVGAVLwalCQIXTZVrMJ3vp7bbZbHMGkSPe0yP2xueKpOueyV+8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:f07:b0:64a:e220:bfb5 with SMTP id
 00721157ae682-67a051e9c33mr504237b3.1.1722037973756; Fri, 26 Jul 2024
 16:52:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:17 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-9-seanjc@google.com>
Subject: [PATCH v12 08/84] KVM: x86/mmu: Mark page/folio accessed only when
 zapping leaf SPTEs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Mark folios as accessed only when zapping leaf SPTEs, which is a rough
heuristic for "only in response to an mmu_notifier invalidation".  Page
aging and LRUs are tolerant of false negatives, i.e. KVM doesn't need to
be precise for correctness, and re-marking folios as accessed when zapping
entire roots or when zapping collapsible SPTEs is expensive and adds very
little value.

E.g. when a VM is dying, all of its memory is being freed; marking folios
accessed at that time provides no known value.  Similarly, because KVM
marks folios as accessed when creating SPTEs, marking all folios as
accessed when userspace happens to delete a memslot doesn't add value.
The folio was marked access when the old SPTE was created, and will be
marked accessed yet again if a vCPU accesses the pfn again after reloading
a new root.  Zapping collapsible SPTEs is a similar story; marking folios
accessed just because userspace disable dirty logging is a side effect of
KVM behavior, not a deliberate goal.

As an intermediate step, a.k.a. bisection point, towards *never* marking
folios accessed when dropping SPTEs, mark folios accessed when the primary
MMU might be invalidating mappings, as such zappings are not KVM initiated,
i.e. might actually be related to page aging and LRU activity.

Note, x86 is the only KVM architecture that "double dips"; every other
arch marks pfns as accessed only when mapping into the guest, not when
mapping into the guest _and_ when removing from the guest.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/locking.rst | 76 +++++++++++++++---------------
 arch/x86/kvm/mmu/mmu.c             |  4 +-
 arch/x86/kvm/mmu/tdp_mmu.c         |  7 ++-
 3 files changed, 43 insertions(+), 44 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 02880d5552d5..8b3bb9fe60bf 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -138,49 +138,51 @@ Then, we can ensure the dirty bitmaps is correctly set for a gfn.
 
 2) Dirty bit tracking
 
-In the origin code, the spte can be fast updated (non-atomically) if the
+In the original code, the spte can be fast updated (non-atomically) if the
 spte is read-only and the Accessed bit has already been set since the
 Accessed bit and Dirty bit can not be lost.
 
 But it is not true after fast page fault since the spte can be marked
 writable between reading spte and updating spte. Like below case:
 
-+------------------------------------------------------------------------+
-| At the beginning::                                                     |
-|                                                                        |
-|	spte.W = 0                                                       |
-|	spte.Accessed = 1                                                |
-+------------------------------------+-----------------------------------+
-| CPU 0:                             | CPU 1:                            |
-+------------------------------------+-----------------------------------+
-| In mmu_spte_clear_track_bits()::   |                                   |
-|                                    |                                   |
-|  old_spte = *spte;                 |                                   |
-|                                    |                                   |
-|                                    |                                   |
-|  /* 'if' condition is satisfied. */|                                   |
-|  if (old_spte.Accessed == 1 &&     |                                   |
-|       old_spte.W == 0)             |                                   |
-|     spte = 0ull;                   |                                   |
-+------------------------------------+-----------------------------------+
-|                                    | on fast page fault path::         |
-|                                    |                                   |
-|                                    |    spte.W = 1                     |
-|                                    |                                   |
-|                                    | memory write on the spte::        |
-|                                    |                                   |
-|                                    |    spte.Dirty = 1                 |
-+------------------------------------+-----------------------------------+
-|  ::                                |                                   |
-|                                    |                                   |
-|   else                             |                                   |
-|     old_spte = xchg(spte, 0ull)    |                                   |
-|   if (old_spte.Accessed == 1)      |                                   |
-|     kvm_set_pfn_accessed(spte.pfn);|                                   |
-|   if (old_spte.Dirty == 1)         |                                   |
-|     kvm_set_pfn_dirty(spte.pfn);   |                                   |
-|     OOPS!!!                        |                                   |
-+------------------------------------+-----------------------------------+
++-------------------------------------------------------------------------+
+| At the beginning::                                                      |
+|                                                                         |
+|	spte.W = 0                                                              |
+|	spte.Accessed = 1                                                       |
++-------------------------------------+-----------------------------------+
+| CPU 0:                              | CPU 1:                            |
++-------------------------------------+-----------------------------------+
+| In mmu_spte_update()::              |                                   |
+|                                     |                                   |
+|  old_spte = *spte;                  |                                   |
+|                                     |                                   |
+|                                     |                                   |
+|  /* 'if' condition is satisfied. */ |                                   |
+|  if (old_spte.Accessed == 1 &&      |                                   |
+|       old_spte.W == 0)              |                                   |
+|     spte = new_spte;                |                                   |
++-------------------------------------+-----------------------------------+
+|                                     | on fast page fault path::         |
+|                                     |                                   |
+|                                     |    spte.W = 1                     |
+|                                     |                                   |
+|                                     | memory write on the spte::        |
+|                                     |                                   |
+|                                     |    spte.Dirty = 1                 |
++-------------------------------------+-----------------------------------+
+|  ::                                 |                                   |
+|                                     |                                   |
+|   else                              |                                   |
+|     old_spte = xchg(spte, new_spte);|                                   |
+|   if (old_spte.Accessed &&          |                                   |
+|       !new_spte.Accessed)           |                                   |
+|     flush = true;                   |                                   |
+|   if (old_spte.Dirty &&             |                                   |
+|       !new_spte.Dirty)              |                                   |
+|     flush = true;                   |                                   |
+|     OOPS!!!                         |                                   |
++-------------------------------------+-----------------------------------+
 
 The Dirty bit is lost in this case.
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2e6daa6d1cc0..58b70328b20c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -542,10 +542,8 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 	 * to guarantee consistency between TLB and page tables.
 	 */
 
-	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
+	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte))
 		flush = true;
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
-	}
 
 	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte))
 		flush = true;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7ac43d1ce918..d1de5f28c445 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -520,10 +520,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	if (was_present && !was_leaf &&
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
-
-	if (was_leaf && is_accessed_spte(old_spte) &&
-	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
 static inline int __must_check __tdp_mmu_set_spte_atomic(struct tdp_iter *iter,
@@ -865,6 +861,9 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
 
+		if (is_accessed_spte(iter.old_spte))
+			kvm_set_pfn_accessed(spte_to_pfn(iter.old_spte));
+
 		/*
 		 * Zappings SPTEs in invalid roots doesn't require a TLB flush,
 		 * see kvm_tdp_mmu_zap_invalidated_roots() for details.
-- 
2.46.0.rc1.232.g9752f9e123-goog


