Return-Path: <kvm+bounces-21374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C659892DCCD
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 01:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 783A228721E
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B621158D92;
	Wed, 10 Jul 2024 23:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XnR5aA+K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F39156238
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654960; cv=none; b=ev5PAC/G4D/fvIlNH0wdLqM/Uz8MkwMHaIRa/lcy1vgJLfSrAlSCDQnx6VPmlzXJCVaK3WJCyEdMDrEtwjFGymPrHYHrb1/SqMiLzhxBDL22uv0cZ1IXLNu7eMiDEfSIfQa1ZiPN4GiQILGV5DC+sirxHiddWy4INM6HXbWkkjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654960; c=relaxed/simple;
	bh=+d7MHnXvG9ckN0TU9hoPWKFT9fXHe0SQp2A+udSuB7E=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tJSODwn00J9g6gzZ44JzLq/H3YPhcwaxOZKEg8PA5LdvWqzCpPsA+NKHmGvX7fDz/DhyA23F0EW+MlWUfc8kC8Qv6RkMYgC2woMaYksd/PN9mUy2mnPirpYKuxlTEO7ljebfP1YA57sBdgE5bZ1mBFw+y9JqSIbrSD7HoWLGJHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XnR5aA+K; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc691f1f83aso183905276.1
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 16:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654957; x=1721259757; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i4DifozVZ/fDrEjgZQtvTFkudk1JzJtOjKWrKpGAYuU=;
        b=XnR5aA+KNkFOrFkdGMSFAMBuqPhPqOTBx07zIv21i+P3e/Fj6yPyAQH0baSHaxrRJU
         2yiaTNuTgqCtRwvjt6ydcaPtiWsPyfgBVAG1vJ0oyyy8j2G6S2LGrzmmfKzBieO6vHEd
         u7KRO+b/KLN3ZsFh3LzY2Du3lg+9NQnPyqmzeS7KAhvp3MCodP49bhBmJ5tOZI1tbb/x
         PzfVZSlNeFO5A+hqoaszJ2SrzxknBWSLKSPZjTcaNmeMohPIcBuO1vZ8OR5hGmr7cpFR
         X8Nri3u3LUM7J4GpwITuRQN2UwYmyvgE/lL7l+7oARtPfdxvob4LXjgNEGbjb2hq+rNr
         UTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654957; x=1721259757;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i4DifozVZ/fDrEjgZQtvTFkudk1JzJtOjKWrKpGAYuU=;
        b=KlLOftNUi6eFzUJsghDyPqDeWG6kUcYYl+cL/naFNiJ60b8ryK/0iTJC3H1FMxpT2R
         ztcTDEv02K4a1skNToKYOdTubDm8JYb2hdoj8xuRADpdTIjTtBHPjTeYacHE7YePKLlh
         05kqko+N892lcvr2QJlG2jahp706DxgNs/BQc7WMAXxHtHO/RcNFEbX6nXDMHBmP4HxW
         Cz81+NUPMaG73qU6xLchps0oHzOm/3c0AEAEPFS2uFbyB47H43WKpesLkoksOTSevyv3
         rpz0jDktBJr24ey59N9POIwd83v3fNRjpFimO32q7EhV/m388ifM17VOlKu40w6yaXRn
         4Vtw==
X-Forwarded-Encrypted: i=1; AJvYcCUG2nVOe1GMO0TKubyWRpFq/v3RGr9l+dHrXGK1aIsTBofg9/Qb164qCZ+CFoFshsLUXkMMkfFUNRHqzxFtBoWJStUV
X-Gm-Message-State: AOJu0YxTMeEHnExrco8t9sruQHsNTtcBFdOgcIXIzI4nkf4EAkNsXuUs
	HtMSz9q91Ub3HAQPHAO8Nnva3O07dg0caPU9Ey9xJQXs+31KaZDhDAtVhUbsJ5qtyCscxVRlyiH
	4ZCd7fO4aTLWnw+Gecg==
X-Google-Smtp-Source: AGHT+IGleZxYUt4mvQCru8lvqfwiOY5k61Gmu5l5Nxb9Gfvqk177LFIz9ZNpte5dLHg976OYyY0/0Rk5LPFmcxhb
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:32a6:b0:e03:61bb:6032 with
 SMTP id 3f1490d57ef6-e0577fa164amr19023276.1.1720654957517; Wed, 10 Jul 2024
 16:42:37 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:04 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-1-jthoughton@google.com>
Subject: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This patch series implements the KVM-based demand paging system that was
first introduced back in November[1] by David Matlack.

The working name for this new system is KVM Userfault, but that name is
very confusing so it will not be the final name.

Problem: post-copy with guest_memfd
===================================

Post-copy live migration makes it possible to migrate VMs from one host
to another no matter how fast they are writing to memory while keeping
the VM paused for a minimal amount of time. For post-copy to work, we
need:
 1. to be able to prevent KVM from being able to access particular pages
    of guest memory until we have populated it
 2. for userspace to know when KVM is trying to access a particular
    page.
 3. a way to allow the access to proceed.

Traditionally, post-copy live migration is implemented using
userfaultfd, which hooks into the main mm fault path. KVM hits this path
when it is doing HVA -> PFN translations (with GUP) or when it itself
attempts to access guest memory. Userfaultfd sends a page fault
notification to userspace, and KVM goes to sleep.

Userfaultfd works well, as it is not specific to KVM; everyone who
attempts to access guest memory will block the same way.

However, with guest_memfd, we do not use GUP to translate from GFN to
HPA (nor is there an intermediate HVA).

So userfaultfd in its current form cannot be used to support post-copy
live migration with guest_memfd-backed VMs.

Solution: hook into the gfn -> pfn translation
==============================================

The only way to implement post-copy with a non-KVM-specific
userfaultfd-like system would be to introduce the concept of a
file-userfault[2] to intercept faults on a guest_memfd.

Instead, we take the simpler approach of adding a KVM-specific API, and
we hook into the GFN -> HVA or GFN -> PFN translation steps (for
traditional memslots and for guest_memfd respectively).

I have intentionally added support for traditional memslots, as the
complexity that it adds is minimal, and it is useful for some VMMs, as
it can be used to fully implement post-copy live migration.

Implementation Details
======================

Let's break down how KVM implements each of the three core requirements
for implementing post-copy as laid out above:

--- Preventing access: KVM_MEMORY_ATTRIBUTE_USERFAULT ---

The most straightforward way to inform KVM of userfault-enabled pages is
to use a new memory attribute, say KVM_MEMORY_ATTRIBUTE_USERFAULT.

There is already infrastructure in place for modifying and checking
memory attributes. Using this interface is slightly challenging, as there
is no UAPI for setting/clearing particular attributes; we must set the
exact attributes we want.

The synchronization that is in place for updating memory attributes is
not suitable for post-copy live migration either, which will require
updating memory attributes (from userfault to no-userfault) very
frequently.

Another potential interface could be to use something akin to a dirty
bitmap, where a bitmap describes which pages within a memslot (or VM)
should trigger userfaults. This way, it is straightforward to make
updates to the userfault status of a page cheap.

When KVM Userfault is enabled, we need to be careful not to map a
userfault page in response to a fault on a non-userfault page. In this
RFC, I've taken the simplest approach: force new PTEs to be PAGE_SIZE.

--- Page fault notifications ---

For page faults generated by vCPUs running in guest mode, if the page
the vCPU is trying to access is a userfault-enabled page, we use
KVM_EXIT_MEMORY_FAULT with a new flag: KVM_MEMORY_EXIT_FLAG_USERFAULT.

For arm64, I believe this is actually all we need, provided we handle
steal_time properly.

For x86, where returning from deep within the instruction emulator (or
other non-trivial execution paths) is infeasible, being able to pause
execution while userspace fetches the page, just as userfaultfd would
do, is necessary. Let's call these "asynchronous userfaults."

A new ioctl, KVM_READ_USERFAULT, has been added to read asynchronous
userfaults, and an eventfd is used to signal that new faults are
available for reading.

Today, we busy-wait for a gfn to have userfault disabled. This will
change in the future.

--- Fault resolution ---

Resolving userfaults today is as simple as removing the USERFAULT memory
attribute on the faulting gfn. This will change if we do not end up
using memory attributes for KVM Userfault. Having a range-based wake-up
like userfaultfd (see UFFDIO_WAKE) might also be helpful for
performance.

Problems with this series
=========================
- This cannot be named KVM Userfault! Perhaps "KVM missing pages"?
- Memory attribute modification doesn't scale well.
- We busy-wait for pages to not be userfault-enabled.
- gfn_to_hva and gfn_to_pfn caches are not invalidated.
- Page tables are not collapsed when KVM Userfault is disabled.
- There is no self-test for asynchronous userfaults.
- Asynchronous page faults can be dropped if KVM_READ_USERFAULT fails.
- Supports only x86 and arm64.
- Probably many more!

Thanks!

[1]: https://lore.kernel.org/kvm/CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com/
[2]: https://lore.kernel.org/kvm/CADrL8HVwBjLpWDM9i9Co1puFWmJshZOKVu727fMPJUAbD+XX5g@mail.gmail.com/

James Houghton (18):
  KVM: Add KVM_USERFAULT build option
  KVM: Add KVM_CAP_USERFAULT and KVM_MEMORY_ATTRIBUTE_USERFAULT
  KVM: Put struct kvm pointer in memslot
  KVM: Fail __gfn_to_hva_many for userfault gfns.
  KVM: Add KVM_PFN_ERR_USERFAULT
  KVM: Add KVM_MEMORY_EXIT_FLAG_USERFAULT
  KVM: Provide attributes to kvm_arch_pre_set_memory_attributes
  KVM: x86: Add KVM Userfault support
  KVM: x86: Add vCPU fault fast-path for Userfault
  KVM: arm64: Add KVM Userfault support
  KVM: arm64: Add vCPU memory fault fast-path for Userfault
  KVM: arm64: Add userfault support for steal-time
  KVM: Add atomic parameter to __gfn_to_hva_many
  KVM: Add asynchronous userfaults, KVM_READ_USERFAULT
  KVM: guest_memfd: Add KVM Userfault support
  KVM: Advertise KVM_CAP_USERFAULT in KVM_CHECK_EXTENSION
  KVM: selftests: Add KVM Userfault mode to demand_paging_test
  KVM: selftests: Remove restriction in vm_set_memory_attributes

 Documentation/virt/kvm/api.rst                |  23 ++
 arch/arm64/include/asm/kvm_host.h             |   2 +-
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/arm.c                          |   8 +-
 arch/arm64/kvm/mmu.c                          |  45 +++-
 arch/arm64/kvm/pvtime.c                       |  11 +-
 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/mmu/mmu.c                        |  67 +++++-
 arch/x86/kvm/mmu/mmu_internal.h               |   3 +-
 include/linux/kvm_host.h                      |  41 +++-
 include/uapi/linux/kvm.h                      |  13 ++
 .../selftests/kvm/demand_paging_test.c        |  46 +++-
 .../testing/selftests/kvm/include/kvm_util.h  |   7 -
 virt/kvm/Kconfig                              |   4 +
 virt/kvm/guest_memfd.c                        |  16 +-
 virt/kvm/kvm_main.c                           | 213 +++++++++++++++++-
 16 files changed, 457 insertions(+), 44 deletions(-)


base-commit: 02b0d3b9d4dd1ef76b3e8c63175f1ae9ff392313
-- 
2.45.2.993.g49e7a77208-goog


