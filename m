Return-Path: <kvm+bounces-60399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63AE9BEBD18
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 23:32:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6C1219A4514
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 21:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0292C21E1;
	Fri, 17 Oct 2025 21:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cTCq9UAn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D717247DEA
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 21:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760736735; cv=none; b=Iyl68HlZMwjAFzW0ITcwFZdIIOsfhq5I8wNOV1vdsKnb9WFHLayQjAu2Wv7QLakp67CRM4TWxmAbPqyNkNG5bWabTHw3hC8spAhdOAGG71cCDilk6EHg5exzcUXs0PhcsWlqXG6xjmreS+et7oUdAyDnvngiHiz5HUTDkKRSbIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760736735; c=relaxed/simple;
	bh=xWGoKK25YqsvRNSCotzWxd+xc9eg4i6XzKSv+4uybPI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=V5LClKJMxywQG5mLqCa0iKs5aRA3mwh8hNh30jCjymlUaFAO8a7zm2GQPYqbRR5xJSfd3AIqJHlK05DVzvHlvoqwgZuTzyqKPFPqq6M5e7t1H4VjPImfPeg2XpJYrGO3MTZz0pS7Nes6vPYltRm/iW89T90W01PkjdkD2yutTAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cTCq9UAn; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b630753cc38so3705863a12.1
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 14:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760736733; x=1761341533; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9gtDefYWAVjsVDW6WMvanANrfYGRojaTuaBTWReOyJI=;
        b=cTCq9UAntOlG2NhBbEPHD4AXtaFLJmP2LCpfh9nRei+33ZqqVdI1vezprSnc+SVS70
         omW4lrLFt3DNWLsMhtxoD8D+GbwIEUuBULTiuaJQUM/IZnS5yHHqSjtKPVtJlgXkeP8+
         NSXBN8xm0n5vVhb92oZXwjmJ2RSywhpHlyCD791Y0BakZaHKx3iLw2RzHklGZUmmtMks
         fwTAaTdlzHdCToSwSQH/GVjHZqKvyUNPG1Fx6axp63MR4RQ+cQMyfK97+hUw6BeEO2l9
         UPz16RCxwxJxc7sS0LsB9wlSuc6EbmHa4x6OCGXtto18uMd4xqi0AoztrBlZl357hC+6
         0vUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760736733; x=1761341533;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9gtDefYWAVjsVDW6WMvanANrfYGRojaTuaBTWReOyJI=;
        b=mAfQUyu58hU3KzAtu8lURVB8uhnk4KWbbTjOuXeSHsXmBZnAB8e1bAxv41rp751Phd
         UpU2v66LhJk3xPB3dfIyi8U/bk0lPRZnGLr6KU0ztON4XTBl22G3emQR0UBUuZ8o5+TJ
         V+GiZHcjdeg/pnIn69ZAau+1qraDV17gjvKxxX661oMOlJemVMBKzTTMTjHIVV5Oi3jY
         A5arZo3dR/aWvZQGUhOrV1pJfdIrDraOvlX8GDYn15wVo5lKXY8QmJtZVcEf5euwI4y9
         PN5RLSWychMs23NJskrgsUJnOedyipWDis/YyndBAs7GNIBpHrrv2amMNOdUlpvutMma
         eudw==
X-Gm-Message-State: AOJu0YxcQWWk/7I4DkNSK2Hn15EyIxSGpnb7uSHTFvF6+pVo924f45U2
	HaU6EqwHbGYK7nlMeVP26U6ETOMxlur0rBIhICTLvCC9iue/knFlz9W5Q+CrUBPiOpAauilidD1
	2AXdiow==
X-Google-Smtp-Source: AGHT+IEbt2E83StVcKSsWn4g67eKo6J1vttk/tak3E0xY04KXB5yu7Mc5sleQhcQRAZLOADrOnbQ1UEniCU=
X-Received: from pjtk2.prod.google.com ([2002:a17:90a:c502:b0:327:7035:d848])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:244b:b0:253:1e04:4e8
 with SMTP id adf61e73a8af0-334a85fdb31mr6566741637.56.1760736733495; Fri, 17
 Oct 2025 14:32:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Oct 2025 14:32:10 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017213210.339764-1-seanjc@google.com>
Subject: [GIT PULL] KVM: guest_memd fixes+tests and a PMU fix for 6.18
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Proactively add a guest_memfd flag, INIT_SHARED, to head off a lurking ABI
collision that will necessitate a new flag at some point.  Without INIT_SHARED,
we'll likely end up with x86 CoCo VMs initializing memory to PRIVATE by default,
SHARED if MMAP, and PRIVATE if INIT_PRIVATE (the potential new flag we're
trying to avoid).

Allow mmap() on x86 CoCo VMs, i.e. on private memory, to try and detect any
other lurking ABI issues.

In addition to the guest_memfd fixes/cleanups, fix a PMU goof where KVM calls
into perf on a hybrid CPU and gets yelled at.  There's no functional issue, but
the WARN is obviously less than ideal.

The following changes since commit 6b36119b94d0b2bb8cea9d512017efafd461d6ac:

  KVM: x86: Export KVM-internal symbols for sub-modules only (2025-09-30 13:40:02 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.18-rc2

for you to fetch changes up to 505f5224b197b77169c977e747cbc18b222f85f9:

  KVM: selftests: Verify that reads to inaccessible guest_memfd VMAs SIGBUS (2025-10-10 14:25:30 -0700)

----------------------------------------------------------------
KVM x86 fixes for 6.18:

 - Expand the KVM_PRE_FAULT_MEMORY selftest to add a regression test for the
   bug fixed by commit 3ccbf6f47098 ("KVM: x86/mmu: Return -EAGAIN if userspace
   deletes/moves memslot during prefault")

 - Don't try to get PMU capabbilities from perf when running a CPU with hybrid
   CPUs/PMUs, as perf will rightly WARN.

 - Rework KVM_CAP_GUEST_MEMFD_MMAP (newly introduced in 6.18) into a more
   generic KVM_CAP_GUEST_MEMFD_FLAGS

 - Add a guest_memfd INIT_SHARED flag and require userspace to explicitly set
   said flag to initialize memory as SHARED, irrespective of MMAP.  The
   behavior merged in 6.18 is that enabling mmap() implicitly initializes
   memory as SHARED, which would result in an ABI collision for x86 CoCo VMs
   as their memory is currently always initialized PRIVATE.

 - Allow mmap() on guest_memfd for x86 CoCo VMs, i.e. on VMs with private
   memory, to enable testing such setups, i.e. to hopefully flush out any
   other lurking ABI issues before 6.18 is officially released.

 - Add testcases to the guest_memfd selftest to cover guest_memfd without MMAP,
   and host userspace accesses to mmap()'d private memory.

----------------------------------------------------------------
Ackerley Tng (1):
      KVM: selftests: Add test coverage for guest_memfd without GUEST_MEMFD_FLAG_MMAP

Dapeng Mi (1):
      KVM: x86/pmu: Don't try to get perf capabilities for hybrid CPUs

Sean Christopherson (12):
      KVM: Rework KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_MEMFD_FLAGS
      KVM: guest_memfd: Add INIT_SHARED flag, reject user page faults if not set
      KVM: guest_memfd: Invalidate SHARED GPAs if gmem supports INIT_SHARED
      KVM: Explicitly mark KVM_GUEST_MEMFD as depending on KVM_GENERIC_MMU_NOTIFIER
      KVM: guest_memfd: Allow mmap() on guest_memfd for x86 VMs with private memory
      KVM: selftests: Stash the host page size in a global in the guest_memfd test
      KVM: selftests: Create a new guest_memfd for each testcase
      KVM: selftests: Add wrappers for mmap() and munmap() to assert success
      KVM: selftests: Isolate the guest_memfd Copy-on-Write negative testcase
      KVM: selftests: Add wrapper macro to handle and assert on expected SIGBUS
      KVM: selftests: Verify that faulting in private guest_memfd memory fails
      KVM: selftests: Verify that reads to inaccessible guest_memfd VMAs SIGBUS

Yan Zhao (1):
      KVM: selftests: Test prefault memory during concurrent memslot removal

 Documentation/virt/kvm/api.rst                       |  15 ++++++++--
 arch/x86/kvm/pmu.c                                   |   8 ++++--
 arch/x86/kvm/x86.c                                   |   7 +++--
 include/linux/kvm_host.h                             |  12 +++++++-
 include/uapi/linux/kvm.h                             |   5 ++--
 tools/testing/selftests/kvm/guest_memfd_test.c       | 175 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------
 tools/testing/selftests/kvm/include/kvm_util.h       |  25 ++++++++++++++++
 tools/testing/selftests/kvm/include/test_util.h      |  19 +++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c           |  44 ++++++++++------------------
 tools/testing/selftests/kvm/lib/test_util.c          |   7 +++++
 tools/testing/selftests/kvm/mmu_stress_test.c        |   5 ++--
 tools/testing/selftests/kvm/pre_fault_memory_test.c  | 131 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 tools/testing/selftests/kvm/s390/ucontrol_test.c     |  16 +++++------
 tools/testing/selftests/kvm/set_memory_region_test.c |  17 ++++++-----
 virt/kvm/Kconfig                                     |   1 +
 virt/kvm/guest_memfd.c                               |  75 +++++++++++++++++++++++++++++++-----------------
 virt/kvm/kvm_main.c                                  |   4 +--
 17 files changed, 378 insertions(+), 188 deletions(-)

