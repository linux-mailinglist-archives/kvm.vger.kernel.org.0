Return-Path: <kvm+bounces-49792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 732D3ADE25F
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:24:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8050189CB4E
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0E41F4CAE;
	Wed, 18 Jun 2025 04:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2hiw6wfh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FBB1D86FF
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220671; cv=none; b=PTExSOzub7si1stNqgUKEr9sX9yrXpFqJhH5T3Lk6K4Z3Vb9XBpRKl79F0ZKJmbFJqOb+6z0z5ve4W0kVpX+NvmUDE58owE+qHiooobjpCUUKag0rYQuUn/EJCmVv/fUYemyz6lDPToqYCUD6qIskMeYftsUjCxYm7z7MDz6trA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220671; c=relaxed/simple;
	bh=hDXm/uhWEmdQBNQ8soMkU9ZN5LUg87/FOyGF0UA8V7I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=t4b1pSqEyJoNxNJ+F0e+jUR85fjpKbnN71PfyUoqhUZDLQIiomegCYHvAFSoflv70Rtq8bx9HpUwuBQ+mDmgG5RJ9rSaCSiXb25T4iKtlgFHZd4+4+Dl/uie6oWcPAFyURXrpQ0x2C+D8g3vj4a8bGxw57VGJhI4GO5C3iiXc/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2hiw6wfh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3141a9a6888so2637939a91.3
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220667; x=1750825467; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o+4MhBpXw5c8zk/u/yk4K4au/XOsEIuLkOFNvyDX6c8=;
        b=2hiw6wfhgjD/KUDvnrRyt9gGydniTbj3q0yYDOuOiNYusGXtg7QYPvEI615J2t4ETT
         w40cM+iUdGHaUVVAEowLbS8S9YmKv9Jw7f5fvymBt94DOEZN3wi7YyosIpgH2XhDegYa
         8LXXVyWlL3CfUFCEuIGdsCeIgzHIIF6+4Pz/A3f+Z4gJI5+LeKucr6rLVJfO/leTIqSm
         rvaC5ZHtsiUxWdKuU8YSG03GLI8fH9FOPKuMujDwyM4j5A6ALtd1GummFjlPFXHjWpfr
         Mp2TfntCAOBZkNbE71F20dCobE0DSpzCwwbROuirwWAFTYo4LOxjfp+3InDsYeWgaMOQ
         9HRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220667; x=1750825467;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o+4MhBpXw5c8zk/u/yk4K4au/XOsEIuLkOFNvyDX6c8=;
        b=KTrmucJ7BqPipRahZdGkP79BPoZ6enXhKGDkQY1PoWJ4YU7sefmPBbWHX9MOm1zBGn
         8/qRU3ibq8nhmDzX6ZKgrQANgw9cGsorq1AEsrgsOSyapHqcZdmxrn8wgjc4bhWuzndZ
         6gaBY/zAQq59+462S9ehRxBwPLMBzrG3HnZH3AwrLPChupLzbHvrp3391PtaxoCcWE5z
         pxHVfH/dRkc0l2Nc2lCqFReWediSC5PGSNJx5Bggy9hDpm3klxU/+69QCaNyGHQcRqU8
         1iYpeBeDGH344D92/M8ZJ5cGUm0pSuU1j/5kSXuWKFWqIKnMsl3I72kubR+tquBv/bOl
         Wjqw==
X-Forwarded-Encrypted: i=1; AJvYcCV47TVE3+Tpl5xSa9SmxNsXBpbBRUH37XFMvN/OJSQqzk69yEVCQDoKMHxDgTXaIxP8G90=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbz8U0bxfP9E+F45UmYrMa+SX/d6qnMZxLafme1rXfNoAF+1z4
	mlXwO55yo581K4L85TT6wVHuYLuZ1VIr7vVLpAt5PqoJ8oOanhe8jpQdc+k5YRfFWxJjPHt5FfD
	jNRtR8ZUqhgIC2TXHY0WEmw==
X-Google-Smtp-Source: AGHT+IHFJYTSQ+MOybbax7YIQAP8zvSWneLdYPGOi/sm7TwaiipF7EkJnEgPUroMKspYYgWLmDMNWsXPyfYM7Kzw
X-Received: from pjbta6.prod.google.com ([2002:a17:90b:4ec6:b0:312:4b0b:a94])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c8d:b0:2ee:d371:3227 with SMTP id 98e67ed59e1d1-313f1d580e2mr27031305a91.17.1750220667431;
 Tue, 17 Jun 2025 21:24:27 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:09 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-1-jthoughton@google.com>
Subject: [PATCH v3 00/15] KVM: Introduce KVM Userfault
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Sean, Paolo, Oliver, + others,

Here is a v3 of KVM Userfault. Thanks for all the feedback on the v2,
Sean. I realize it has been 6 months since the v2; I hope that isn't an
issue.

I am working on the QEMU side of the changes as I get time. Let me know
if it's important for me to send those patches out for this series to be
merged.

Be aware that this series will have non-trivial conflicts with Fuad's
user mapping support for guest_memfd series[1]. For example, for the
arm64 change he is making, the newly introduced gmem_abort() would need
to be enlightened to handle KVM Userfault exits.

Changelog:
v2[2]->v3:
- Pull in Sean's changes to genericize struct kvm_page_fault and use it
  for arm64. Many of these patches now have Sean's SoB.
- Pull in Sean's small rename and squashing of the main patches.
- Add kvm_arch_userfault_enabled() in place of calling
  kvm_arch_flush_shadow_memslot() directly from generic code.
- Pull in Xin Li's documentation section number fix for
  KVM_CAP_ARM_WRITABLE_IMP_ID_REGS[3].
v1[4]->v2:
- For arm64, no longer zap stage 2 when disabling KVM_MEM_USERFAULT
  (thanks Oliver).
- Fix the userfault_bitmap validation and casts (thanks kernel test
  robot).
- Fix _Atomic cast for the userfault bitmap in the selftest (thanks
  kernel test robot).
- Pick up Reviewed-by on doc changes (thanks Bagas).

Below is the cover letter from v1, mostly unchanged:

Please see the RFC[5] for the problem description. In summary,
guest_memfd VMs have no mechanism for doing post-copy live migration.
KVM Userfault provides such a mechanism.

There is a second problem that KVM Userfault solves: userfaultfd-based
post-copy doesn't scale very well. KVM Userfault when used with
userfaultfd can scale much better in the common case that most post-copy
demand fetches are a result of vCPU access violations. This is a
continuation of the solution Anish was working on[6]. This aspect of
KVM Userfault is important for userfaultfd-based live migration when
scaling up to hundreds of vCPUs with ~30us network latency for a
PAGE_SIZE demand-fetch.

The implementation in this series is version than the RFC[5]. It adds...
 1. a new memslot flag is added: KVM_MEM_USERFAULT,
 2. a new parameter, userfault_bitmap, into struct kvm_memory_slot,
 3. a new KVM_RUN exit reason: KVM_MEMORY_EXIT_FLAG_USERFAULT,
 4. a new KVM capability KVM_CAP_USERFAULT.

KVM Userfault does not attempt to catch KVM's own accesses to guest
memory. That is left up to userfaultfd.

When enabling KVM_MEM_USERFAULT for a memslot, the second-stage mappings
are zapped, and new faults will check `userfault_bitmap` to see if the
fault should exit to userspace.

When KVM_MEM_USERFAULT is enabled, only PAGE_SIZE mappings are
permitted.

When disabling KVM_MEM_USERFAULT, huge mappings will be reconstructed
consistent with dirty log disabling. So on x86, huge mappings will be
reconstructed, but on arm64, they won't be.

KVM Userfault is not compatible with async page faults. Nikita has
proposed a new implementation of async page faults that is more
userspace-driven that *is* compatible with KVM Userfault[7].

See v1 for more performance details[4]. They are unchanged in this
version.

This series is based on the latest kvm-x86/next.

[1]: https://lore.kernel.org/kvm/20250611133330.1514028-1-tabba@google.com/
[2]: https://lore.kernel.org/kvm/20250109204929.1106563-1-jthoughton@google.com/
[3]: https://lore.kernel.org/kvm/20250414165146.2279450-1-xin@zytor.com/
[4]: https://lore.kernel.org/kvm/20241204191349.1730936-1-jthoughton@google.com/
[5]: https://lore.kernel.org/kvm/20240710234222.2333120-1-jthoughton@google.com/
[6]: https://lore.kernel.org/all/20240215235405.368539-1-amoorthy@google.com/
[7]: https://lore.kernel.org/kvm/20241118123948.4796-1-kalyazin@amazon.com/#t

James Houghton (11):
  KVM: Add common infrastructure for KVM Userfaults
  KVM: x86: Add support for KVM userfault exits
  KVM: arm64: Add support for KVM userfault exits
  KVM: Enable and advertise support for KVM userfault exits
  KVM: selftests: Fix vm_mem_region_set_flags docstring
  KVM: selftests: Fix prefault_mem logic
  KVM: selftests: Add va_start/end into uffd_desc
  KVM: selftests: Add KVM Userfault mode to demand_paging_test
  KVM: selftests: Inform set_memory_region_test of KVM_MEM_USERFAULT
  KVM: selftests: Add KVM_MEM_USERFAULT + guest_memfd toggle tests
  KVM: Documentation: Add KVM_CAP_USERFAULT and KVM_MEM_USERFAULT
    details

Sean Christopherson (3):
  KVM: x86/mmu: Move "struct kvm_page_fault" definition to
    asm/kvm_host.h
  KVM: arm64: Add "struct kvm_page_fault" to gather common fault
    variables
  KVM: arm64: x86: Require "struct kvm_page_fault" for memory fault
    exits

Xin Li (Intel) (1):
  KVM: Documentation: Fix section number for
    KVM_CAP_ARM_WRITABLE_IMP_ID_REGS

 Documentation/virt/kvm/api.rst                |  35 ++++-
 arch/arm64/include/asm/kvm_host.h             |   9 ++
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          |  48 +++---
 arch/x86/include/asm/kvm_host.h               |  68 +++++++-
 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/mmu/mmu.c                        |  13 +-
 arch/x86/kvm/mmu/mmu_internal.h               |  77 +---------
 arch/x86/kvm/x86.c                            |  27 ++--
 include/linux/kvm_host.h                      |  49 +++++-
 include/uapi/linux/kvm.h                      |   6 +-
 .../selftests/kvm/demand_paging_test.c        | 145 ++++++++++++++++--
 .../testing/selftests/kvm/include/kvm_util.h  |   5 +
 .../selftests/kvm/include/userfaultfd_util.h  |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  42 ++++-
 .../selftests/kvm/lib/userfaultfd_util.c      |   2 +
 .../selftests/kvm/set_memory_region_test.c    |  33 ++++
 virt/kvm/Kconfig                              |   3 +
 virt/kvm/kvm_main.c                           |  57 ++++++-
 19 files changed, 489 insertions(+), 134 deletions(-)


base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.50.0.rc2.692.g299adb8693-goog


