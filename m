Return-Path: <kvm+bounces-34079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB1029F6F82
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 22:36:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EE691893951
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 21:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0568C1FC7D2;
	Wed, 18 Dec 2024 21:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z6BZp0aq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7931FBEB6
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 21:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734557777; cv=none; b=rscyZJMU5lFED1Za9X5YI0lYl3oqx1qWj+EZwB8f4wX394p7qy7JgZaBkM+nXEQF4+3gQfPj9jqVKJsmRP9O+u719kjdRK0s65B5O+0+ZOpcom0Ltjq7uEwnPNam8S58CXvdDijXeRJsfTzqjPK1nBiFp6LlmN9YzjGwKvhN1VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734557777; c=relaxed/simple;
	bh=uxBcCRhjGzXie5kmTqCNMlXwLz3YytowLn20K9+5MWg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hHWNT38DtW2DOFtMDE/tHoGAvXk4C3R0U/1m1n2jN/sQjJT7CIRdPp4cqX6Gd4L20TkGkZcX42GOLY1Jn6roevE9HEnX3TNPqH6NKt/HnmekzMJ+cHgevF8vYFbRGE0x2HW+OXWCTtV5Wmba/wegRjyiB5hOdqSDhPyUhQW7Njk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z6BZp0aq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef6ef9ba3fso99856a91.2
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 13:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734557775; x=1735162575; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oWc1sGaOiZw/BmI6uxoyXnLhxhQzeG+z+yh5nXhj+rA=;
        b=z6BZp0aq6pLS9pvnQEcMkW3mhIPGEauPivslPfVVmd9UkysbMsuRZYGmk7ifPuR8Il
         Grg4Gq6aphhqX28+UsGi2zkKjDFAnqGLHdtkAVIbMjxZ7DakRnftSaa4xyqJF8sFvukL
         SHVhq+UXSuj4M0nhYJAqMdAIHv3/7ZkSPkxxDosGWeH6ksJ7H25oXYBKgZyrlD+B3Ypk
         F6GZGJt8cc5I8IDaTyvjw+nX1FLPWu9AYzdF4pwGPgYl6rqaG71NQITXnonqy+GchzEy
         I8vtGxs+Litac4cK4Y5qrvcKFoAtKOcMFqZNTbdkxG0CCuWLxASqOKx2BNI/Ndtj2uxU
         K4dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734557775; x=1735162575;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oWc1sGaOiZw/BmI6uxoyXnLhxhQzeG+z+yh5nXhj+rA=;
        b=pFTeCE4U1Rmr09IbnSMK7FKLhFIIj9QMcAHbOyfZeoy8VROWFejXPwHuXmgne5KPCD
         ruXzCEX5T54OQVuS/nMAxZesNtzzLBm9wk5EwS4Wq5Rk/RVmbz4g6JQaNnGa2LpgYyKp
         KCdBr0goTXiE2ES9/VDoBIw0xEJaWDF7KL+cGxsJZbWkulaEffrEQsyCnRbXaqQTOCOn
         FQ5UWIJTZoh2HSa4sUJRPfWGffrZmGYDlYlCUWTLFH1bh9wN3GMcDheDpDijKxUevNa9
         eQomc+YQnaHnijMRPHaloTNYET4accrohVwxup6r/cWUTYF2iY0H1ys4yz0Q/p9+aW3k
         1foQ==
X-Gm-Message-State: AOJu0YzuZhcV9tckAu6CSoUyzGU5AhdahcVQDxWR0yRkCwBGhqju3gIp
	sI2dkvt9djC+0B3Nl9RLzZx9+IFegAFT5I0mnpAyoyfau6fzBxSGite9KncKYUuB8CCuHu0iPhJ
	COQ==
X-Google-Smtp-Source: AGHT+IH0cIBHEW0fINMkCPcMt726gLZ9Yj+wo2r0Bn7iO0S4VoKApfZ0SG0zJpt73h2i5OzKgNkb7JNq/Bk=
X-Received: from pjm6.prod.google.com ([2002:a17:90b:2fc6:b0:2ee:3cc1:7944])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:534e:b0:2ee:d63f:d73
 with SMTP id 98e67ed59e1d1-2f443ce5318mr1136420a91.11.1734557775107; Wed, 18
 Dec 2024 13:36:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Dec 2024 13:36:11 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218213611.3181643-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Treat TDP MMU faults as spurious if access is
 already allowed
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, leiyang@redhat.com
Content-Type: text/plain; charset="UTF-8"

Treat slow-path TDP MMU faults as spurious if the access is allowed given
the existing SPTE to fix a benign warning (other than the WARN itself)
due to replacing a writable SPTE with a read-only SPTE, and to avoid the
unnecessary LOCK CMPXCHG and subsequent TLB flush.

If a read fault races with a write fault, fast GUP fails for any reason
when trying to "promote" the read fault to a writable mapping, and KVM
resolves the write fault first, then KVM will end up trying to install a
read-only SPTE (for a !map_writable fault) overtop a writable SPTE.

Note, it's not entirely clear why fast GUP fails, or if that's even how
KVM ends up with a !map_writable fault with a writable SPTE.  If something
else is going awry, e.g. due to a bug in mmu_notifiers, then treating read
faults as spurious in this scenario could effectively mask the underlying
problem.

However, retrying the faulting access instead of overwriting an existing
SPTE is functionally correct and desirable irrespective of the WARN, and
fast GUP _can_ legitimately fail with a writable VMA, e.g. if the Accessed
bit in primary MMU's PTE is toggled and causes a PTE value mismatch.  The
WARN was also recently added, specifically to track down scenarios where
KVM is unnecessarily overwrites SPTEs, i.e. treating the fault as spurious
doesn't regress KVM's bug-finding capabilities in any way.  In short,
letting the WARN linger because there's a tiny chance it's due to a bug
elsewhere would be excessively paranoid.

Fixes: 1a175082b190 ("KVM: x86/mmu: WARN and flush if resolving a TDP MMU fault clears MMU-writable")
Reported-by: leiyang@redhat.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219588
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 12 ------------
 arch/x86/kvm/mmu/spte.h    | 17 +++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c |  5 +++++
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 22e7ad235123..2401606db260 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3364,18 +3364,6 @@ static bool fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool is_access_allowed(struct kvm_page_fault *fault, u64 spte)
-{
-	if (fault->exec)
-		return is_executable_pte(spte);
-
-	if (fault->write)
-		return is_writable_pte(spte);
-
-	/* Fault was on Read access */
-	return spte & PT_PRESENT_MASK;
-}
-
 /*
  * Returns the last level spte pointer of the shadow page walk for the given
  * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index f332b33bc817..af10bc0380a3 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -461,6 +461,23 @@ static inline bool is_mmu_writable_spte(u64 spte)
 	return spte & shadow_mmu_writable_mask;
 }
 
+/*
+ * Returns true if the access indicated by @fault is allowed by the existing
+ * SPTE protections.  Note, the caller is responsible for checking that the
+ * SPTE is a shadow-present, leaf SPTE (either before or after).
+ */
+static inline bool is_access_allowed(struct kvm_page_fault *fault, u64 spte)
+{
+	if (fault->exec)
+		return is_executable_pte(spte);
+
+	if (fault->write)
+		return is_writable_pte(spte);
+
+	/* Fault was on Read access */
+	return spte & PT_PRESENT_MASK;
+}
+
 /*
  * If the MMU-writable flag is cleared, i.e. the SPTE is write-protected for
  * write-tracking, remote TLBs must be flushed, even if the SPTE was read-only,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4508d868f1cd..2f15e0e33903 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -985,6 +985,11 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	if (fault->prefetch && is_shadow_present_pte(iter->old_spte))
 		return RET_PF_SPURIOUS;
 
+	if (is_shadow_present_pte(iter->old_spte) &&
+	    is_access_allowed(fault, iter->old_spte) &&
+	    is_last_spte(iter->old_spte, iter->level))
+		return RET_PF_SPURIOUS;
+
 	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else

base-commit: 3522c419758ee8dca5a0e8753ee0070a22157bc1
-- 
2.47.1.613.gc27f4b7a9f-goog


