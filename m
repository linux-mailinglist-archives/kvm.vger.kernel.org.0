Return-Path: <kvm+bounces-30772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 071DB9BD52E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B3B11C22AD1
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5261EBFE3;
	Tue,  5 Nov 2024 18:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hxhoboBW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DABD1E885E
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832225; cv=none; b=kAWulB3UAO+Z5RbL3s8Vig8VbT987TOKt/MUNdwRR40nNGGqQgCNbvQ4W1RvPmguLr92d/2fQhG1uJPvB71Gu/C15SmuzrbIRUEO5dSZNhy6Wr8N2f0UHRlfmRAeTdrNU1sLEqzQWrGEPlGml3U79JY/GETCHQc++mPiQK2ydcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832225; c=relaxed/simple;
	bh=pU4SAL7p4UGbfRfS1KrjNPbw+8NK+2LolXdUKKYNjA4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NpRk0Ol3jk+KsJtgG9ua/O8Hp/ze0tJ557zmOC3tA44NMZU7w9I5L+sAc4msUPG5xxIJTF48wTEmEVwudyePtXOlwO8RSOKyAupDbP4Xx0z4cAIv3dywJDL3fdJqhPnHktfQxfMGy5Mmno0nyx7dLpk4DgsLvGw5jyNkSysdoCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hxhoboBW; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea8a5e862eso1425337b3.0
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 10:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730832222; x=1731437022; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GuOZq+bvLT62AE/FqHwVPgkEApv4Maa2ZGeXoJtXZis=;
        b=hxhoboBWYZxnEraKBm+fGoyGO8Y1Eqsxg+MbqtfO0PryneaR0tmgLPNR5MLOE/ygvQ
         8AYqH6TBSI/Zzs2uX/0cMzH/HyRPMDAjOKEL5hX5Hmk2DD5wwvNqdX7EaC1bkkA/HV/G
         IyN376ifGFMfLgzg6Wranq2PuRbJo8QprH97ujelijL2C69lWYpbnktgqU5j30iuOZAk
         hs5tD+Xh7s6WVMO6pADtUZh0na6RqgzLflA1VDXM3gSEG/b0KCbqkydlUDrX3YZeXmkL
         FMNCqCJaRtcRMbT2F//v2dK4JihdFtXDunCdZhT1+X5JUX+VJqtteBoS8H+C7cd81AtV
         sKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730832222; x=1731437022;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GuOZq+bvLT62AE/FqHwVPgkEApv4Maa2ZGeXoJtXZis=;
        b=JaIub6mI0zv9spgBLEzsTgucFlTFq+IvGxlm5dsV0i9t2OLet0Gg+UU1DaTEYIrV6n
         KIPFTpuvYbE4M8xVfallES4k5dRIvf2+MkjHKg5R+KA0Vl7GRvQQGoSuHl0/z9OmTeM/
         RYfe/UZAJjkN9iTNAzCBWjM6PjS8k0WSqpx+apAeZxWeOAXazi42pq8pjHl/gzxJ7VAa
         TaJcnkUiIS8LQfMfSVYIUx1mnX1ceIWZ1tSxDFXRuYCLrcSOG1y+Gd9G0pZR9kuGnrUU
         j780kBTxsPf8qWeitsp722H8rCxbjT61P8yTkx42OfR3AQA3gkiPknAfalySnImRerk0
         y6MA==
X-Forwarded-Encrypted: i=1; AJvYcCVrgnuedo/PmZ00Q+o09jq+rCXtov0E5UrvM+/vDKDFCl8cgtL5mqOI0izcWtdNACaxY1s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEyHXVPfvvO1r2RZiVU/9A5aezpEfFkfT6zgyN+s6cM6wXUu6v
	XcclaqCrxB5+Z0MWYbw+VYXlw9NHqrLL//QypAISWmgcfhjstOjSotHOL85bUaxUeaox1rAtwcI
	WrlRwGU/xHIuYXl9D7A==
X-Google-Smtp-Source: AGHT+IFnfCE8HnSqPqXhgqX3PjG5pW2ak+1lY68Y94GynMu9XIVIPZx+uiDRa8pAmZ17XLGwC0ponEhG1reOcQzi
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:6f8a:b0:6d3:e7e6:8460 with
 SMTP id 00721157ae682-6ea5576c8bdmr2660807b3.1.1730832222251; Tue, 05 Nov
 2024 10:43:42 -0800 (PST)
Date: Tue,  5 Nov 2024 18:43:22 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105184333.2305744-1-jthoughton@google.com>
Subject: [PATCH v8 00/11] KVM: x86/mmu: Age sptes locklessly
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Andrew has queued patches to make MGLRU consult KVM when doing aging[8].
Now, make aging lockless for the shadow MMU and the TDP MMU. This allows
us to reduce the time/CPU it takes to do aging and the performance
impact on the vCPUs while we are aging.

The final patch in this series modifies access_tracking_stress_test to
age using MGLRU. There is a mode (-p) where it will age while the vCPUs
are faulting memory in. Here are some results with that mode:

TDP MMU disabled, no optimization:
$ ./access_tracking_perf_test -l -r /dev/cgroup/memory -v 64 -p
lru_gen avg pass duration     : 15.954388970s, (passes:1, total:15.954388970s)

TDP MMU disabled, lockless:
$ ./access_tracking_perf_test -l -r /dev/cgroup/memory -v 64 -p
lru_gen avg pass duration     : 0.527091929s, (passes:35, total:18.448217547s)

The vCPU time difference in these runs with the shadow MMU vary quite a
lot, and there doesn't seem to be a notable improvement with this
particular test.

There are some more results with the TDP MMU from v4[4].

I have also tested with Sean's mmu_stress_test changes[1].

Note: the new MGLRU mode for access_tracking_perf_test will verify that
aging is functional. It will only be functional with the MGLRU patches
that have been sent to Andrew separately[8].

=== Previous Versions ===

Since v7[7]:
 - Dropped MGLRU changes (Andrew has queued them[8]).
 - Dropped DAMON cleanup (Andrew has queued this[9]).
 - Dropped MMU notifier changes completely.
 - Made shadow MMU aging *always* lockless, not just lockless when the
   now-removed "fast_only" clear notifier was used.
 - Given that the MGLRU changes no longer introduce a new MGLRU
   capability, drop the new capability check from the selftest.
 - Rebased on top of latest kvm-x86/next, including the x86 mmu changes
   for marking pages as dirty.

Since v6[6]:
 - Rebased on top of kvm-x86/next and Sean's lockless rmap walking
   changes.
 - Removed HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONLY (thanks DavidM).
 - Split up kvm_age_gfn() / kvm_test_age_gfn() optimizations (thanks
   DavidM and Sean).
 - Improved new MMU notifier documentation (thanks DavidH).
 - Dropped arm64 locking change.
 - No longer retry for CAS failure in TDP MMU non-A/D case (thanks
   Sean).
 - Added some R-bys and A-bys.

Since v5[5]:
 - Reworked test_clear_young_fast_only() into a new parameter for the
   existing notifiers (thanks Sean).
 - Added mmu_notifier.has_fast_aging to tell mm if calling fast-only
   notifiers should be done.
 - Added mm_has_fast_young_notifiers() to inform users if calling
   fast-only notifier helpers is worthwhile (for look-around to use).
 - Changed MGLRU to invoke a single notifier instead of two when
   aging and doing look-around (thanks Yu).
 - For KVM/x86, check indirect_shadow_pages > 0 instead of
   kvm_memslots_have_rmaps() when collecting age information
   (thanks Sean).
 - For KVM/arm, some fixes from Oliver.
 - Small fixes to access_tracking_perf_test.
 - Added missing !MMU_NOTIFIER version of mmu_notifier_clear_young().

Since v4[4]:
 - Removed Kconfig that controlled when aging was enabled. Aging will
   be done whenever the architecture supports it (thanks Yu).
 - Added a new MMU notifier, test_clear_young_fast_only(), specifically
   for MGLRU to use.
 - Add kvm_fast_{test_,}age_gfn, implemented by x86.
 - Fix locking for clear_flush_young().
 - Added KVM_MMU_NOTIFIER_YOUNG_LOCKLESS to clean up locking changes
   (thanks Sean).
 - Fix WARN_ON and other cleanup for the arm64 locking changes
   (thanks Oliver).

Since v3[3]:
 - Vastly simplified the series (thanks David). Removed mmu notifier
   batching logic entirely.
 - Cleaned up how locking is done for mmu_notifier_test/clear_young
   (thanks David).
 - Look-around is now only done when there are no secondary MMUs
   subscribed to MMU notifiers.
 - CONFIG_LRU_GEN_WALKS_SECONDARY_MMU has been added.
 - Fixed the lockless implementation of kvm_{test,}age_gfn for x86
   (thanks David).
 - Added MGLRU functional and performance tests to
   access_tracking_perf_test (thanks Axel).
 - In v3, an mm would be completely ignored (for aging) if there was a
   secondary MMU but support for secondary MMU walking was missing. Now,
   missing secondary MMU walking support simply skips the notifier
   calls (except for eviction).
 - Added a sanity check for that range->lockless and range->on_lock are
   never both provided for the memslot walk.

For the changes since v2[2], see v3.

Based on latest kvm-x86/next.

[1]: https://lore.kernel.org/kvm/20241009154953.1073471-1-seanjc@google.com/
[2]: https://lore.kernel.org/kvmarm/20230526234435.662652-1-yuzhao@google.com/
[3]: https://lore.kernel.org/linux-mm/20240401232946.1837665-1-jthoughton@google.com/
[4]: https://lore.kernel.org/linux-mm/20240529180510.2295118-1-jthoughton@google.com/
[5]: https://lore.kernel.org/linux-mm/20240611002145.2078921-1-jthoughton@google.com/
[6]: https://lore.kernel.org/linux-mm/20240724011037.3671523-1-jthoughton@google.com/
[7]: https://lore.kernel.org/kvm/20240926013506.860253-1-jthoughton@google.com/
[8]: https://lore.kernel.org/linux-mm/20241019012940.3656292-1-jthoughton@google.com/
[9]: https://lore.kernel.org/linux-mm/20241021160212.9935-1-jthoughton@google.com/

James Houghton (7):
  KVM: Remove kvm_handle_hva_range helper functions
  KVM: Add lockless memslot walk to KVM
  KVM: x86/mmu: Factor out spte atomic bit clearing routine
  KVM: x86/mmu: Relax locking for kvm_test_age_gfn and kvm_age_gfn
  KVM: x86/mmu: Rearrange kvm_{test_,}age_gfn
  KVM: x86/mmu: Only check gfn age in shadow MMU if
    indirect_shadow_pages > 0
  KVM: selftests: Add multi-gen LRU aging to access_tracking_perf_test

Sean Christopherson (4):
  KVM: x86/mmu: Refactor low level rmap helpers to prep for walking w/o
    mmu_lock
  KVM: x86/mmu: Add infrastructure to allow walking rmaps outside of
    mmu_lock
  KVM: x86/mmu: Add support for lockless walks of rmap SPTEs
  KVM: x86/mmu: Support rmap walks without holding mmu_lock when aging
    gfns

 arch/x86/include/asm/kvm_host.h               |   4 +-
 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/mmu/mmu.c                        | 338 ++++++++++-----
 arch/x86/kvm/mmu/tdp_iter.h                   |  27 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |  23 +-
 include/linux/kvm_host.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/access_tracking_perf_test.c | 366 ++++++++++++++--
 .../selftests/kvm/include/lru_gen_util.h      |  55 +++
 .../testing/selftests/kvm/lib/lru_gen_util.c  | 391 ++++++++++++++++++
 virt/kvm/Kconfig                              |   2 +
 virt/kvm/kvm_main.c                           | 102 +++--
 12 files changed, 1124 insertions(+), 187 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/lru_gen_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/lru_gen_util.c


base-commit: a27e0515592ec9ca28e0d027f42568c47b314784
-- 
2.47.0.199.ga7371fff76-goog


