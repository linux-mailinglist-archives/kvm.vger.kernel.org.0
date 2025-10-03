Return-Path: <kvm+bounces-59476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C252CBB860D
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 01:26:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DD094A7196
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 23:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C00827CCF0;
	Fri,  3 Oct 2025 23:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eLPblk/I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B2B277CBF
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 23:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759533975; cv=none; b=OLGFJ7tlxmPXpsgQN/UuEqRsufaaw8CDCc8v+ASJm0rxUIFklHvdNX4v3vxe3m1J9eKMRMi6WsZaRyMwlNiuZ/UkfvKvafi9pzb6yIlaXhmFCoB0Rp8ygHWZ0OdsWk9Ms4U+K4U6gLBBQL+eIJGfMRXopG/ffwPV2jE+xvzQl90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759533975; c=relaxed/simple;
	bh=lEq8JRI2SSnz7kakcfguWPlzyKoCI/2Vw7Y09973W8U=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=enbGlAoRfeVHFZSvLCuYKSQ0/PRCR9EC6F3IusvtHqrn5xId12w5fokNDnyiWqGb+y9VLUZqYX2/MWuCmr2wB83B3xJKxJYCb0J+jPhFuGrxHTJosWZl9qHdXOKXN+/d8RIAMdnMHH5ZgVSDgGav1N91ziX/BtkOb0/QT2+i3BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eLPblk/I; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-330a4d5c4efso2480180a91.0
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 16:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759533973; x=1760138773; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hx+pV01crlqWXLtVnn69IFCOSwNofZUkvtg0lWK3NeM=;
        b=eLPblk/Irp6Xx3iDmnrOJhHNAXSPPTQp/qczKlAyRuMfzhkLYOVJSpQyJNUTBggeFd
         mYV/yFkr1FYUqX/Kh2R/d9dg/yFDKpxk2Lf/ZHkminYPtw80ktIQvqSXmRdBGlp+IJh3
         scNELUK2gjHWTg4m8FG99ostYh9hPKJljETOOdxZOD4qcZyr8QPDy9071o2UH3r0whez
         RxoOT1oBkkag0eWa2bxoJ6UUweNcjALDYbL1FuVO80EpbZVETyFn3s2IPseCOk809pvn
         xbdQcOIkt6LkHNm3ToZCnU3fFJpjHxDqJssS5wYNS0YDSL0MRUo0kgsSnZxijkMK4Aul
         12IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759533973; x=1760138773;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hx+pV01crlqWXLtVnn69IFCOSwNofZUkvtg0lWK3NeM=;
        b=wHrgJIw+3fAMZMjmXF6PLD/EapoRQOp0AsbDgvRpnFVuAeezkiHP09kLo2elwghV4n
         AvTwJwKDMpipLu5yE0Hot1HDt+EIB1ZDiq5jxwiIIWf/Eckp/xMFHzI6YR9ByuwQQ5L+
         qgmUugyMqUh8PkOCQ5f0nb4jCpm3y/3Q/enn5WZZcAsMzgV6lx1x035sQ3ZHZntm7Cu1
         UNVFG1IuKo+EFfCQT4/fzBklkbmJ03//IrIwhf57Zzap4JxVqZPKEot7+k4rloUrcP8W
         adz8RWhhaU05uTQDEpSEcMAqvh5EplW+LY6Z9NgV7Ju9a/t4+IKwlCIJSrPSYlM/xGjG
         csTg==
X-Gm-Message-State: AOJu0YziPn7QXSYW+STJtxRxNumQ32T7BNAPPU8Nzi/rpo3QRjlKEqyW
	2olZ8LilrAfH2OJ2ypBMxyjYXI9ceDBt4kI7d6RYCoxeI5kAuVK1k0TrGl+funkTMguSoj2m3bm
	R/uzdHw==
X-Google-Smtp-Source: AGHT+IFkXhAaFq4Gfid2gGFh2dtDUrMzOfe69LeCJz2X/JEm+++v3KJ+uH1MdEO8vdfK5Vk+MihXoOYiBSw=
X-Received: from pjbgc3.prod.google.com ([2002:a17:90b:3103:b0:32b:61c4:e48b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33c7:b0:32e:64ca:e84e
 with SMTP id 98e67ed59e1d1-339c27351dfmr6287322a91.15.1759533973449; Fri, 03
 Oct 2025 16:26:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Oct 2025 16:25:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003232606.4070510-1-seanjc@google.com>
Subject: [PATCH v2 00/13] KVM: guest_memfd: MMAP and related fixes
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix several flaws in guest_memfd related to MMAP support, the big one being
a lurking ABI mess due to MMAP implicitly inverting the initial private vs.
shared state of a gmem instance.

To solve that, add a guest_memfd flag, INIT_SHARED, to let userspace explicitly
state whether the underlying memory should default to private vs. shared.
As-is, the initial state is implicitly derived from the MMAP flag: guest_memfd
without MMAP is private, and with MMAP is shared.  That implicit behavior
is going to create a mess of an ABI once in-place conversion support comes
along.

If the init state is implicit, then x86 CoCo VMs will end up with init state
that varies based on whether or not a guest_memfd instance is configured for
mmap() support.  To avoid breaking guest<=>host ABI for CoCo VMs when utilizing
in-place conversion, i.e. MMAP, userspace would need to immediately convert all
memory from shared=>private.  As a bonus, this allows for adding test coverage
that KVM rejects faults to private memory.

v2:
 - Collect reviews.
 - Improve documentation. [Fuad]
 - s/DEFAULT_SHARED/INIT_SHARED. [Ackerley]
 - Add TEST_EXPECT_SIGBUS() to simplify testing "bad" accesses. [Ackerley]
 - Replace KVM_CAP_GUEST_MEMFD_MMAP with KVM_CAP_GUEST_MEMFD_FLAGS.
 - Add more coverage for SIGBUS cases.
 - Fix a benign (but lurking) bug where guest_memfd doesn't mark SHARED GPAs
   for invalidation (only TDX looks at the invalidation filters, and TDX won't
   support shared memory until in-place conversion comes along).
 - Explicitly report several signals (debugging SIGBUS when I screwed up was
   super annoying without the explicit TEST_FAIL()).
 - Allow mmap() on private memory to avoid having to add more CAPs for it
   (and because it'll allow for setting NUMA policy on private memory).
 - Mark KVM_GUEST_MEMFD as depending on KVM_GENERIC_MMU_NOTIFIER (pre-existing
   bug, but slightly more evident once arm64 support guest_memfd (s390 is the
   only arch that doesn't select KVM_GENERIC_MMU_NOTIFIER)).

v1: https://lore.kernel.org/all/diqz4isiuddj.fsf@google.com

Ackerley Tng (1):
  KVM: selftests: Add test coverage for guest_memfd without
    GUEST_MEMFD_FLAG_MMAP

Sean Christopherson (12):
  KVM: Rework KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_MEMFD_FLAGS
  KVM: guest_memfd: Add INIT_SHARED flag, reject user page faults if not
    set
  KVM: guest_memfd: Invalidate SHARED GPAs if gmem supports INIT_SHARED
  KVM: Explicitly mark KVM_GUEST_MEMFD as depending on
    KVM_GENERIC_MMU_NOTIFIER
  KVM: guest_memfd: Allow mmap() on guest_memfd for x86 VMs with private
    memory
  KVM: selftests: Stash the host page size in a global in the
    guest_memfd test
  KVM: selftests: Create a new guest_memfd for each testcase
  KVM: selftests: Add wrappers for mmap() and munmap() to assert success
  KVM: selftests: Isolate the guest_memfd Copy-on-Write negative
    testcase
  KVM: selftests: Add wrapper macro to handle and assert on expected
    SIGBUS
  KVM: selftests: Verify that faulting in private guest_memfd memory
    fails
  KVM: selftests: Verify that reads to inaccessible guest_memfd VMAs
    SIGBUS

 Documentation/virt/kvm/api.rst                |  15 +-
 arch/x86/kvm/x86.c                            |   7 +-
 include/linux/kvm_host.h                      |  12 +-
 include/uapi/linux/kvm.h                      |   5 +-
 .../testing/selftests/kvm/guest_memfd_test.c  | 175 ++++++++++--------
 .../testing/selftests/kvm/include/kvm_util.h  |  25 +++
 .../testing/selftests/kvm/include/test_util.h |  19 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  44 ++---
 tools/testing/selftests/kvm/lib/test_util.c   |   7 +
 tools/testing/selftests/kvm/mmu_stress_test.c |   5 +-
 .../selftests/kvm/s390/ucontrol_test.c        |  16 +-
 .../selftests/kvm/set_memory_region_test.c    |  17 +-
 virt/kvm/Kconfig                              |   1 +
 virt/kvm/guest_memfd.c                        |  75 +++++---
 virt/kvm/kvm_main.c                           |   4 +-
 15 files changed, 259 insertions(+), 168 deletions(-)


base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
-- 
2.51.0.618.g983fd99d29-goog


