Return-Path: <kvm+bounces-13303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A1BE8947B2
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 01:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEC81283725
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 23:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4F557864;
	Mon,  1 Apr 2024 23:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rcUf3/3H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4FA56B8F
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 23:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712014200; cv=none; b=EIUYaspl+gaC+tmrEZ4Qx7y5+u3y4pkjTdb5KiBg7xZiKm4njqhqJzUb4mnElmi1gCgHBQTGOi/f3BTCXxnLGS5ruOA/C+bzCKGsdATWUBOeE7eNjDnoyuOcrHoueLZ+NaV9rsO96T+3g80KvsQJPwCPGjX+VAne8RupTTAf7mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712014200; c=relaxed/simple;
	bh=LIU3srPkuAU2Il0Ayu4Wz3ZF0a3r6V03GyttaxoyE9Q=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PtitfUFqfI1x40AxjbbnStVn/ZfjSVsDHs1mdAQ2VtOi+GymBFmbfvR8Y+lVa0cqEsxMTTfZXgs/PSEUZ7PB+g56tkymee5mGnZSpGDfNEK+Zu3UbHukUY9nCtlqE7aAx9RMUTjHhCjDFnRPDrnkYR91tgdhvLqUJK0Lki2fHeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rcUf3/3H; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a61b31993so81552287b3.1
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 16:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712014196; x=1712618996; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3wg9CCGpIdLpfDRqh60QLQofCQe0biAtvSj1Gdo5bk8=;
        b=rcUf3/3Hx79SQpAY7DJI+A7c4PJxcLpRh9bjArXZWq5RmH8UM59RZPPelNnD82Zs2v
         UYJAGIA2LNKy5g0kCM+Tdp+TrzmMGXUIfhOkF4TC95s0ATZG3/vMyIwARciwcG/O/gmF
         6+X9vHutCcV5cnN+YoSUptFqxNDv85n87KX4kICeyLKyMYwtkQRGJLxOClKGqzneIe0H
         qUlvjbHRsiBu8lP4wG+NsScN5NednQGAv8Yk1N7Qe+Ml6hd7+M0z4KxtuvJlAZPied4s
         GwOQQd1hW1LyUQqaybsLrbpsRpdhUUjWidmwDeflXEnhFB+OpHvNA55KUD966PLllaKH
         g2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712014196; x=1712618996;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3wg9CCGpIdLpfDRqh60QLQofCQe0biAtvSj1Gdo5bk8=;
        b=odpZ3FLvWUedREur2vGCUW3wFJ+sJhZlXKxWd2UlivQmYU5G9rGE3XtMGiFKBvDa9s
         zmFk0I6V7VF+LuT6PhjuThPnvKrntCvT/ZxYBxQcOTQWSHEwl+PP25OZE/8XVgr1nw9i
         6B0bZ/ZFkqCcETVuluSTAiFiLJ/KEoSlAEHkaqYRfXEnFS1dxG+hdd6mPag9JhyPtbdC
         lEAORChaVAJIw/NxkRNJcseU0VA9H2fu8aCI+Wl9pT1+O5+xi56/FwJqbhAtKUJTvGLe
         2f9yyRcqx+vOnzXT5dMC2eSih4vUcWvsoPAysabJN2zrQSqrpp248PQHRDMcDzAT+j98
         4vfA==
X-Forwarded-Encrypted: i=1; AJvYcCX1PJC23UNttWnTJaCNUXb3D0+vgpbnqkq7/81O8SHzGzPDUAxGxd0n6ANABev/rWKTZBUKfYTyxENLY4vUvlH9JQqy
X-Gm-Message-State: AOJu0YzPkn6uJaIOoLD4KiuqY1e57FwtRQPfD9CDtz3lVbQCND0PzoF5
	p6tc5lbLP6jfghlFZwJsLBisPvkfyeXQfWsTcF5E8ZSerROtnFeT8SzhvvqAGJmbDU4bsAZnvQX
	0CodSxeRAIizMMMeUgQ==
X-Google-Smtp-Source: AGHT+IGQKV963bGOmZkg1qJdb4wkJ3JL7Okh/SQUhgB3vOnWcX/gauefdkact4kTuSTRZOisDp+cn6EF/9Mo2eKk
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:f83:b0:614:e20c:d423 with SMTP
 id df3-20020a05690c0f8300b00614e20cd423mr823185ywb.10.1712014196503; Mon, 01
 Apr 2024 16:29:56 -0700 (PDT)
Date: Mon,  1 Apr 2024 23:29:39 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240401232946.1837665-1-jthoughton@google.com>
Subject: [PATCH v3 0/7] mm/kvm: Improve parallelism for access bit harvesting
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

This patchset adds a fast path in KVM to test and clear access bits on
sptes without taking the mmu_lock. It also adds support for using a
bitmap to (1) test the access bits for many sptes in a single call to
mmu_notifier_test_young, and to (2) clear the access bits for many ptes
in a single call to mmu_notifier_clear_young.

With Yu's permission, I'm now working on getting this series into a
mergeable state.

I'm posting this as an RFC because I'm not sure if the arm64 bits are
correct, and I haven't done complete performance testing. I want to do
broader experimentation to see how much this improves VM performance in
a cloud environment, but I want to be sure that the code is mergeable
first.

Yu has posted other performance results[1], [2]. This v3 shouldn't
significantly change the x86 results, but the arm64 results may have
changed.

The most important changes since v2[3]:

- Split the test_clear_young MMU notifier back into test_young and
  clear_young. I did this because the bitmap passed in has a distinct
  meaning for each of them, and I felt that this was cleaner.

- The return value of test_young / clear_young now indicates if the
  bitmap was used.

- Removed the custom spte walker to implement the lockless path. This
  was important for arm64 to be functionally correct (thanks Oliver),
  and it avoids a lot of problems brought up in review of v2 (for
  example[4]).

- Add kvm_arch_prepare_bitmap_age and kvm_arch_finish_bitmap_age to
  allow for arm64 to implement its bitmap-based aging to grab the MMU
  lock for reading while allowing x86 to be lockless.

- The powerpc changes have been dropped.

- The logic to inform architectures how to use the bitmap has been
  cleaned up (kvm_should_clear_young has been split into
  kvm_gfn_should_age and kvm_gfn_record_young) (thanks Nicolas).

There were some smaller changes too:
- Added test_clear_young_metadata (thanks Sean).
- MMU_NOTIFIER_RANGE_LOCKLESS has been renamed to
  MMU_NOTIFIER_YOUNG_FAST, to indicate to the caller that passing a
  bitmap for MGLRU look-around is likely to be beneficial.
- Cleaned up comments that describe the changes to
  mmu_notifier_test_young / mmu_notifier_clear_young (thanks Nicolas).

[1]: https://lore.kernel.org/all/20230609005943.43041-1-yuzhao@google.com/
[2]: https://lore.kernel.org/all/20230609005935.42390-1-yuzhao@google.com/
[3]: https://lore.kernel.org/kvmarm/20230526234435.662652-1-yuzhao@google.com/
[4]: https://lore.kernel.org/all/ZItX64Bbx5vdjo9M@google.com/

James Houghton (5):
  mm: Add a bitmap into mmu_notifier_{clear,test}_young
  KVM: Move MMU notifier function declarations
  KVM: Add basic bitmap support into kvm_mmu_notifier_test/clear_young
  KVM: x86: Participate in bitmap-based PTE aging
  KVM: arm64: Participate in bitmap-based PTE aging

Yu Zhao (2):
  KVM: x86: Move tdp_mmu_enabled and shadow_accessed_mask
  mm: multi-gen LRU: use mmu_notifier_test_clear_young()

 Documentation/admin-guide/mm/multigen_lru.rst |   6 +-
 arch/arm64/include/asm/kvm_host.h             |   5 +
 arch/arm64/include/asm/kvm_pgtable.h          |   4 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  21 +-
 arch/arm64/kvm/mmu.c                          |  23 ++-
 arch/x86/include/asm/kvm_host.h               |  20 ++
 arch/x86/kvm/mmu.h                            |   6 -
 arch/x86/kvm/mmu/mmu.c                        |  16 +-
 arch/x86/kvm/mmu/spte.h                       |   1 -
 arch/x86/kvm/mmu/tdp_mmu.c                    |  10 +-
 include/linux/kvm_host.h                      | 101 ++++++++--
 include/linux/mmu_notifier.h                  |  93 ++++++++-
 include/linux/mmzone.h                        |   6 +-
 include/trace/events/kvm.h                    |  13 +-
 mm/mmu_notifier.c                             |  20 +-
 mm/rmap.c                                     |   9 +-
 mm/vmscan.c                                   | 183 ++++++++++++++----
 virt/kvm/kvm_main.c                           | 100 +++++++---
 18 files changed, 509 insertions(+), 128 deletions(-)


base-commit: 0cef2c0a2a356137b170c3cb46cb9c1dd2ca3e6b
-- 
2.44.0.478.gd926399ef9-goog


