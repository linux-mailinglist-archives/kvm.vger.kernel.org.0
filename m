Return-Path: <kvm+bounces-37191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7390A268AE
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:41:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 423EE3A5A8D
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994334120B;
	Tue,  4 Feb 2025 00:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2KVocSmm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f74.google.com (mail-vs1-f74.google.com [209.85.217.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1666217F7
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 00:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629653; cv=none; b=m3ojXBdI5m3uVk/jsIDaCFlSvViN7qE89rCh25j9Uk9Us/wOqzUgISdw5HMGjaDXzav3j7owijTmdDQt0A4E6heulCyf86WYIK2KChKwI4yiwGm/Iib1Yyi8Cfqnnp2oZ50IrMcqp+8L1RML6v/bu4IEJUoBE+GcFDft/G0b7+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629653; c=relaxed/simple;
	bh=bmrASrR62KZeZJxjZFE0p0oaXdaB83EF/gXrCasGfZY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=D+zbFof0DBwR2n5dr6Jpm+omu6SLNEwMA4WohpNRZ5hJE+HzrZl8SYGQsQds3H1DY3heBOirRuLaJIQOb/L9rW08g9vZYKsPUaNa6adJ8/eJerqlZKXnPbJvEV1s90+8Y2HV7s4B/LF0cXyXfz8ZipGuRl6pMvKJzCLVgkHxZdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2KVocSmm; arc=none smtp.client-ip=209.85.217.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f74.google.com with SMTP id ada2fe7eead31-4b03fdeda53so3452764137.2
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 16:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738629651; x=1739234451; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7eaGS+IR45A+UfTwsXIDE/PzKhhx7VFkOrorlaB6LjU=;
        b=2KVocSmmDNPhzz4CCycag4AgJHlzOMp19h/mJFL4pNrAFEqLMgQZbZDPQx7FIfo0gG
         FKAkMQmGFYLhC9OIWjzbj2kwDpBb6iu6GlFXOuRlIvNlHHOAQnNbunF/TDxmg5lJPMn+
         j64DXdYRlosUMogf0RiOdM/4HS2sdAj6ouzjhpTrakPI4yaAdzgL62xoIjRAf4iXtd7r
         5IZ4BH9MHlqVgq/Esi+OdCO2c4X/NTDKygpE56tSZHyojCxylEdF3pydI5Xg+yxmjYox
         jM5TO8hfTgds7UR0orAAyQePM35qLp7M6XgmxJJo8osAjVF/pLlUu4bLR1QKSz4oKr7h
         8daw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738629651; x=1739234451;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7eaGS+IR45A+UfTwsXIDE/PzKhhx7VFkOrorlaB6LjU=;
        b=Sf8dEViESq0w0Zz8548ZQ4GAZ4hYVzxoz/btrqTK7jRG6TGpgUnljkN010fPeFeLP2
         Sfe51BFUlIrteZhpFqBW3vlz6DP74LVzJ3IpqT+hqB0RPIvUHLyaJAQfniB2vvPKhgEa
         nvy4VUpMvuntdesKxwKUFN/e1apNN20PrC7SCcftaZbQQiQnvSuUJ2XCC5jBCRJ8RsD0
         eVi9+tL28F6bvwG9bEF1jsUKEEGYIB9uec5L+XccsjtSH4cPPgDEg3cYrxQCfd9VIHHe
         vDE+Prla6KMfJKJsqL83yP4+lRvN9ATpBVaNJK8GD1vVUlmRuKL4XdCk2568YqoYG7su
         0OuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPcYoZgB7EZ7FiHosRuHqtxj0q1WaGTv8nImAwPi8KVUD8/uPmiE3CdYSg59m+Y+Ta8CU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVBzPpd0sqtJMmVt17nyK0k4t/QRQ81h3kMmR9iaaufxYr+6T7
	7EkcZ8LyeelCPCQoqiUXAn24b6I0IOcyXuXPu5Vd7CAI2DX2dYAO/DuVwMKP3W8npWPpBJXnYjN
	bB/957fEKnsBLpraoVg==
X-Google-Smtp-Source: AGHT+IGzxM4bB5itmqJHiLbEn0wk0ACsS2SMyJJUn0jlhzxe3U3mUBho5B4yp3Dk2uR91vtv7uT00NEWAYWYghNn
X-Received: from uaf10.prod.google.com ([2002:a05:6130:6d0a:b0:864:fdaa:625f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:26ce:b0:4af:e61d:e22f with SMTP id ada2fe7eead31-4b9a52fc968mr19654056137.24.1738629650816;
 Mon, 03 Feb 2025 16:40:50 -0800 (PST)
Date: Tue,  4 Feb 2025 00:40:27 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204004038.1680123-1-jthoughton@google.com>
Subject: [PATCH v9 00/11] KVM: x86/mmu: Age sptes locklessly
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

By aging sptes locklessly with the TDP MMU and the shadow MMU, neither
vCPUs nor reclaim (mmu_notifier_invalidate_range*) will get stuck
waiting for aging. This contention reduction improves guest performance
and saves a significant amount of Google Cloud's CPU usage, and it has
valuable improvements for ChromeOS, as Yu has mentioned previously[1].

Please see v8[8] for some performance results using
access_tracking_perf_test patched to use MGLRU.

Neither access_tracking_perf_test nor mmu_stress_test trigger any
splats (with CONFIG_LOCKDEP=y) with the TDP MMU and with the shadow MMU.

=== Previous Versions ===

Since v8[8]:
 - Re-added the kvm_handle_hva_range helpers and applied Sean's
   kvm_{handle -> age}_hva_range rename.
 - Renamed spte_has_volatile_bits() to spte_needs_atomic_write() and
   removed its Accessed bit check. Undid change to
   tdp_mmu_spte_need_atomic_write().
 - Renamed KVM_MMU_NOTIFIER_{YOUNG -> AGING}_LOCKLESS.
 - cpu_relax(), lockdep, preempt_disable(), and locking fixups for
   per-rmap lock (thanks Lai and Sean).
 - Renamed kvm_{has -> may_have}_shadow_mmu_sptes().
 - Rebased onto latest kvm/next, including changing
   for_each_tdp_mmu_root_rcu to use `types`.
 - Dropped MGLRU changes from access_tracking_perf_test.
 - Picked up Acked-bys from Yu. (thank you!)

Since v7[7]:
 - Dropped MGLRU changes.
 - Dropped DAMON cleanup.
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

Based on latest kvm/next.

[1]: https://lore.kernel.org/kvm/CAOUHufYS0XyLEf_V+q5SCW54Zy2aW5nL8CnSWreM8d1rX5NKYg@mail.gmail.com/
[2]: https://lore.kernel.org/kvmarm/20230526234435.662652-1-yuzhao@google.com/
[3]: https://lore.kernel.org/linux-mm/20240401232946.1837665-1-jthoughton@google.com/
[4]: https://lore.kernel.org/linux-mm/20240529180510.2295118-1-jthoughton@google.com/
[5]: https://lore.kernel.org/linux-mm/20240611002145.2078921-1-jthoughton@google.com/
[6]: https://lore.kernel.org/linux-mm/20240724011037.3671523-1-jthoughton@google.com/
[7]: https://lore.kernel.org/kvm/20240926013506.860253-1-jthoughton@google.com/
[8]: https://lore.kernel.org/kvm/20241105184333.2305744-1-jthoughton@google.com/

James Houghton (7):
  KVM: Rename kvm_handle_hva_range()
  KVM: Add lockless memslot walk to KVM
  KVM: x86/mmu: Factor out spte atomic bit clearing routine
  KVM: x86/mmu: Relax locking for kvm_test_age_gfn() and kvm_age_gfn()
  KVM: x86/mmu: Rename spte_has_volatile_bits() to
    spte_needs_atomic_write()
  KVM: x86/mmu: Skip shadow MMU test_young if TDP MMU reports page as
    young
  KVM: x86/mmu: Only check gfn age in shadow MMU if
    indirect_shadow_pages > 0

Sean Christopherson (4):
  KVM: x86/mmu: Refactor low level rmap helpers to prep for walking w/o
    mmu_lock
  KVM: x86/mmu: Add infrastructure to allow walking rmaps outside of
    mmu_lock
  KVM: x86/mmu: Add support for lockless walks of rmap SPTEs
  KVM: x86/mmu: Support rmap walks without holding mmu_lock when aging
    gfns

 Documentation/virt/kvm/locking.rst |   4 +-
 arch/x86/include/asm/kvm_host.h    |   4 +-
 arch/x86/kvm/Kconfig               |   1 +
 arch/x86/kvm/mmu/mmu.c             | 364 +++++++++++++++++++++--------
 arch/x86/kvm/mmu/spte.c            |  19 +-
 arch/x86/kvm/mmu/spte.h            |   2 +-
 arch/x86/kvm/mmu/tdp_iter.h        |  26 ++-
 arch/x86/kvm/mmu/tdp_mmu.c         |  36 ++-
 include/linux/kvm_host.h           |   1 +
 virt/kvm/Kconfig                   |   2 +
 virt/kvm/kvm_main.c                |  56 +++--
 11 files changed, 364 insertions(+), 151 deletions(-)


base-commit: f7bafceba76e9ab475b413578c1757ee18c3e44b
-- 
2.48.1.362.g079036d154-goog


