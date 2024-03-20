Return-Path: <kvm+bounces-12204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A5B2B8808BF
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 01:51:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 327BA1F22C78
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C7548F77;
	Wed, 20 Mar 2024 00:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mh901u8t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E311366
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 00:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710895844; cv=none; b=YK9bd6sM/wD7vU17sflaLfKkV9PlmJIUfxKt//tlQxP4BPloJmw/qvBkvFFBoj28zdqUPyWUAL/BKlSKH+j9D9IBhM2Q/r66WiPks5mk8JVWs8YJIXEWTFcEsjVG3A2waA3dw9h+6/lxaCKHODLhMTwFSxCxHJFmEz8duZwgZFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710895844; c=relaxed/simple;
	bh=e9vCkrtfJaABLYAyKrQ0HWBYDJdjKHVlxWPsqtjWiU8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mdW66Mr7X/R65I1mE11JMAJTX00+FIdC/EIVlL1PoQ4ni+FdI3El86CPg4r5EHXP+BaKDJlyoXYEQliQwR1dk7InUfYHegIxgc3von6ptDLRrp0doQiY08Vzk7js/sj1ATdHKq42zo8HRDMYoYU8qagGZdE70RL4UCFPy3CS2wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mh901u8t; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d8bcf739e5so4828149a12.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 17:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710895842; x=1711500642; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=73z0LxtdomfWG0GJE09D1ttIG4ILmbtU6RU20yVkqf4=;
        b=mh901u8t7A54U2oZkNub4mTJqcIJ7r6ar6ZLym0UGnJFrCgbUOfjM0E6Gq15UQFSQy
         RSK1Rnk9FPCboZydal4qJhq3WZGrOsoVEKozytT+WM/BIUY/P+esReMCKKtB5T/hWxeY
         24KJT1c3Q0KescU5r1QTa0ef21/Jo7AVT5Z+ID1lGYTORA6LKTDoh/X0X9O9j6XL5Rco
         gCkmxglKkv11TCT86KQWTOI5YKyWPRs3WzkvaV94tnDMl958WaAH6aoP2yDoSSdlqenE
         PaDgIHnxkJDqFF1UF8nKNn3DuYRvp5NzLJKWucICAHy5DLqeviJXvKsIZcmXVMSEqeZ6
         2j9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710895842; x=1711500642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=73z0LxtdomfWG0GJE09D1ttIG4ILmbtU6RU20yVkqf4=;
        b=U8gLPqoEnbom1eaJH9swUSbR18VAzreu5NydqThchzOd1r/xXlo6npzWMbcN9y2u6G
         Pkk4bvvLlYi15QCnD+MH1QW/eprAFdrvOlvIVFMi9L4Zp1PfgtJ5xGznHB+nXdwnNpBs
         Qw3LxuN+9Z0kv7HG2+VVhki5BdeyVb+eQTvBekiiVsotNZEVkAlZhYAib5PBLWId+1N9
         edRitz47UUDDhIR7FUwc58RFdLV9y7GTh6YXFYf3YBeK/qXN2YNXyukMZ1ChnQdx7gWw
         bj8VycV0dJYT3J1+MNAujdEssd0+QtXt/U7CAlxJgGXIvni2DEje0pmqYtQLCnznfgU7
         UQtQ==
X-Gm-Message-State: AOJu0YxByHwUfCDSc0BSVstYzLMp5+OvWDKg1GLhevpTS80D36vGF2Io
	5XNPJ4VVnutPRX1pgHBver/sIFNGVVOSL6QNl/If1jNpWSArxv4gBgZLjJHW8RVCbgC5/cumylZ
	aLQ==
X-Google-Smtp-Source: AGHT+IF1elppJ1tODfZ0EG8u4kLfEw8DDLQ91IUuYrs1E3zIe4DEs7GG6DnoA43xvrWkoC/VwXNmeT6UbY4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:488:b0:5e8:57aa:3609 with SMTP id
 bw8-20020a056a02048800b005e857aa3609mr6141pgb.9.1710895841989; Tue, 19 Mar
 2024 17:50:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 19 Mar 2024 17:50:23 -0700
In-Reply-To: <20240320005024.3216282-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240320005024.3216282-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240320005024.3216282-4-seanjc@google.com>
Subject: [RFC PATCH 3/4] KVM: x86/mmu: Mark page/folio accessed only when
 zapping leaf SPTEs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Stevens <stevensd@chromium.org>, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"

Mark folios as accessed only when zapping leaf SPTEs, which is a rough
heuristic for "only in response to an mmu_notifier invalidation".  Page
aging and LRUs are tolerant of false negatives, i.e. KVM doesn't need to
be precise for correctness, and re-marking folios as accessed when zapping
entire roots or when zapping collapsible SPTEs is expensive and adds very
little value.

E.g. when a VM is dying, all of its memory is being freed; marking folios
accessed at that time provides no known value.  Similarly, because KVM
makes folios as accessed when creating SPTEs, marking all folios as
accessed when userspace happens to delete a memslot doesn't add value.
The folio was marked access when the old SPTE was created, and will be
marked accessed yet again if a vCPU accesses the pfn again after reloading
a new root.  Zapping collapsible SPTEs is a similar story; marking folios
accessed just because userspace disable dirty logging is a side effect of
KVM behavior, not a deliberate goal.

Mark folios accessed when the primary MMU might be invalidating mappings,
e.g. instead of completely dropping calls to kvm_set_pfn_accessed(), as
such zappings are not KVM initiated, i.e. might actually be related to
page aging and LRU activity.

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
index bd2240b94ff6..0a6c6619d213 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -539,10 +539,8 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
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
index 5866a664f46e..340d5af454c6 100644
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
 
 /*
@@ -841,6 +837,9 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_iter_set_spte(kvm, &iter, 0);
 
+		if (is_accessed_spte(iter.old_spte))
+			kvm_set_pfn_accessed(spte_to_pfn(iter.old_spte));
+
 		/*
 		 * Zappings SPTEs in invalid roots doesn't require a TLB flush,
 		 * see kvm_tdp_mmu_zap_invalidated_roots() for details.
-- 
2.44.0.291.gc1ea87d7ee-goog


