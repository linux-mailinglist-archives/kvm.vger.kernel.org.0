Return-Path: <kvm+bounces-19269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 03327902D80
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 02:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD812B213C0
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 00:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920555660;
	Tue, 11 Jun 2024 00:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rU12+Nyv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECC1803
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 00:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065321; cv=none; b=l2uMEFwxEAJgbw15CaHCAEine4E9RCWyBZgXI/OT3JPsoWnvJ/W5cnC1lBjg9/m6ENjt5XlYnBvWUk7v49naxD5PdDKYppEiky/Hn111eplvQ7HNsyhleBI+SLbSQV6H8t1yzJitpKH72/VvgUc/AcaWmFZtYwUMp+K/fe6yUQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065321; c=relaxed/simple;
	bh=3uniXobaC5MSPEfsx9girsouEiiMtIw1qVVGwDeZOIQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pGEr+G48ZZsRa5KjpNa0DLPStBbCu9nd2dLl7z/nMo4E8XgH06z2TkXIuPHxU6aQfNzSbTwA0Ovb6Die5VdidyYZmkxiD6Kr4iwcSCcXoBybexoAawLwGEEachJFvz23dGzHDeEx7FMlIzHauCv4+OrfJzpcpDnwSCZ6wm1OTVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rU12+Nyv; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a0eb1c809so93689557b3.2
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 17:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718065319; x=1718670119; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=znnebkeVSvsFTLm00akjOWCV2leg9gyqu/Y0G491TkM=;
        b=rU12+NyvhRvDDBpw1TyJSYf3OF/yayTkJXOYrmIdmOD15Y8ncVO68+Thx6BRlnvm39
         c1YI/u7Le2kfa0/YhpFvnHkvf9chQfc9uh/e4kigZFmELam6n2ESc8fdTRjVXWMRvi9j
         JYRHM8uCnA8GldSAXl1azgh6BPyNKaBqqGiIuG1SoMUrFtjnZhOgrFgrtihpQf3VD3ub
         Bc91E1ctt64/im63+jfOik8j9gVW23XwJJ9Pm9PvUC3fxpoxZ35TSLpo5DDuj4Ld3lFf
         XOuyUGsCsgpNp1uMl3WIuZS8ckISi/E0YplEUUMjOWR5+5vkbIRR33AIL6LuKUSTOw/r
         GagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718065319; x=1718670119;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=znnebkeVSvsFTLm00akjOWCV2leg9gyqu/Y0G491TkM=;
        b=K9siW9I5wEzOPDUhlh3RB90DBggsQ6VWq4kPo6LOwBBLwstZDgjLYijAOXb2l23LcK
         EY0am3Krmiz3Y0s0jWCLoirfIVA4aZHSjaJlc1SZEA/JqECdXirPvTi/hK4t/Iw7d3Pk
         slW+wfntB2nqISqlMA2ANraMDLFRLKn8vRyRjCmFfjdxMp9senNpFY8ajOLoFkBkGy2M
         mxMo17GbiS7ABovCSexJdfhrk4CKp/c/RVjx3bvNSnbX+VGzTEKkLJ0T5IxijKd8gs/Z
         H6OckjeF9xv/Vig4uJ7BLWNiv55yA8ghnjiQLojvuX8NmXkfNKneD1v8JFtAnEKY/6Iz
         AWGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzlmcbe9Cm1WUhJf2FrbLFE5YU4YLk3KjMWtVrTbW4vBYUy80pNp0EfcYLtZlJ7Va+ubs88ASWRNwRw0MkSOPf6L7+
X-Gm-Message-State: AOJu0YxzUA+amyPqTfJ/z+lIvjw+2oQdadXTQpoD573DKak9Wrv8bc7K
	cphwKNd8Iyx4lVJn+MMJm9aLzJLnz1DbNzU3PR7lZ5UZaAZxKdj/4mEgAomiby6ChzKeL2RiEDm
	w+kDWN9e4T58KhpVhbg==
X-Google-Smtp-Source: AGHT+IHAQpzXE/JP1O7Hg4+Kq/h9j2tVw1U1SGU5I2M7dDYM3/uT/d6pwcmk2+n0+ICjilMbsMpRbG4g7tWO2ExY
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:6612:b0:62d:21:3f66 with SMTP
 id 00721157ae682-62d0021471dmr22261127b3.1.1718065319010; Mon, 10 Jun 2024
 17:21:59 -0700 (PDT)
Date: Tue, 11 Jun 2024 00:21:36 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611002145.2078921-1-jthoughton@google.com>
Subject: [PATCH v5 0/9] mm: multi-gen LRU: Walk secondary MMU page tables
 while aging
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

This patchset makes it possible for MGLRU to consult secondary MMUs
while doing aging, not just during eviction. This allows for more
accurate reclaim decisions, which is especially important for proactive
reclaim.

This series does the following:
 1. Improve locking for the existing test/clear_young notifiers for x86
    and arm64.
 2. Add a new notifier test_clear_young_fast_only(), implemented only by
    KVM/x86.
 3. Incorporate test_clear_young_fast_only() into MGLRU aging.

To make aging work for more than just x86, the
test_clear_young_fast_only() notifier must be implemented by those other
architectures.

access_tracking_perf_test now has a mode (-p) to check performance of
MGLRU aging while the VM is faulting memory in. See the v4 cover
letter[1] for performance data collected with this test.

Previous versions of this series included logic in MGLRU and KVM to
support batching the updates to secondary page tables. This version
removes this logic, as it was complex and not necessary to enable
proactive reclaim. This optimization, as well as the additional
optimizations for arm64 and powerpc, can be done in a later series.

=== Previous Versions ===

This v5 re-adds a lot of logic that was present in v3 and earlier
versions of the series. There is an important difference I want to call
out:

 - should_look_around() can sometimes require two notifiers instead of
   one. This is necessary if I forbid myself from modifying
   mmu_notifier_clear_young().

   It may simply be better to do what v2/v3 did have and not have a
   fast-only notifier, and merge them all. This makes the API slightly
   more complex. I'm not sure which is better.

Change log:

Since v4[1]:
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

Since v3[2]:
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

For the changes since v2[3], see v3.

Based on 6.10-rc3.

[1]: https://lore.kernel.org/linux-mm/20240529180510.2295118-1-jthoughton@google.com/
[2]: https://lore.kernel.org/linux-mm/20240401232946.1837665-1-jthoughton@google.com/
[3]: https://lore.kernel.org/kvmarm/20230526234435.662652-1-yuzhao@google.com/

James Houghton (8):
  KVM: Add lockless memslot walk to KVM
  KVM: x86: Relax locking for kvm_test_age_gfn and kvm_age_gfn
  KVM: arm64: Relax locking for kvm_test_age_gfn and kvm_age_gfn
  mm: Add test_clear_young_fast_only MMU notifier
  KVM: Add kvm_fast_age_gfn and kvm_fast_test_age_gfn
  KVM: x86: Implement kvm_fast_test_age_gfn and kvm_fast_age_gfn
  mm: multi-gen LRU: Have secondary MMUs participate in aging
  KVM: selftests: Add multi-gen LRU aging to access_tracking_perf_test

Yu Zhao (1):
  KVM: x86: Move tdp_mmu_enabled and shadow_accessed_mask

 Documentation/admin-guide/mm/multigen_lru.rst |   6 +-
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/hyp/pgtable.c                  |  15 +-
 arch/arm64/kvm/mmu.c                          |  26 +-
 arch/x86/include/asm/kvm_host.h               |  14 +
 arch/x86/kvm/Kconfig                          |   2 +
 arch/x86/kvm/mmu.h                            |   6 -
 arch/x86/kvm/mmu/mmu.c                        |  60 ++-
 arch/x86/kvm/mmu/spte.h                       |   1 -
 arch/x86/kvm/mmu/tdp_iter.h                   |  27 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |  67 ++-
 include/linux/kvm_host.h                      |   8 +
 include/linux/mmu_notifier.h                  |  50 +++
 include/linux/mmzone.h                        |   6 +-
 include/trace/events/kvm.h                    |  22 +
 mm/mmu_notifier.c                             |  26 ++
 mm/rmap.c                                     |   9 +-
 mm/vmscan.c                                   | 185 +++++++--
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/access_tracking_perf_test.c | 365 ++++++++++++++--
 .../selftests/kvm/include/lru_gen_util.h      |  55 +++
 .../testing/selftests/kvm/lib/lru_gen_util.c  | 391 ++++++++++++++++++
 virt/kvm/Kconfig                              |   7 +
 virt/kvm/kvm_main.c                           |  73 +++-
 24 files changed, 1283 insertions(+), 140 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/lru_gen_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/lru_gen_util.c


base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
-- 
2.45.2.505.gda0bf45e8d-goog


