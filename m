Return-Path: <kvm+bounces-11404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64428876D3F
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:39:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 885DC1C218D9
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 22:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512525FBB2;
	Fri,  8 Mar 2024 22:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3fBf2xKm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D204CB30
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 22:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709937441; cv=none; b=Y/mQXD5GkdP1b+InwhMZFCUUuBaPaq7QFSVFvBvWdkhKl3gPNBTtEYX5KsfEXjhD6kVj5W+EQDixkCu3/ZGq4RIxJhnrjqI3ynPTeFC95RIQdVPWk1/++j/litCorz5kwrZBOTj8bhdXhSsv0LX1hShPaZL7yG9R/7qthWZKWtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709937441; c=relaxed/simple;
	bh=IHkAWM8Bsx+VfJRZIYMmESxXShX5sefkocQEmr3ATY0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=loLfXBHbhFV/x7i2/jD9sHAU+xPZtXfoyQWjt+ChZ8P7kGoi/nqU9iqGX1cpfT/z/lJhTsLLak+fHrY+AgtBcMvdGPbURv01oY1oTRjD/8b5SngjbPqhmUotJnQQSKA9WoO8yKe+yWG7gahv5ZB5qp52Q7paurgzgqMzOf/HI2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3fBf2xKm; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e657979d66so2383978b3a.2
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 14:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709937439; x=1710542239; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LOPgQup6F0h+Ij6sYWAHH/M666uh+NTVfASk5SQVjok=;
        b=3fBf2xKm09OkSwtX6Ni0r0TXTpFjHeZ49MzgEd74Mj4TZE1eeWYG96lbX8YXJMutm0
         LKZbjCbiMrNUIQXVc4QS/mhQcWGD3STeyG/izbNEPveiZgtBqCZBjyfXIwzkweb0qRnG
         9DsNRG3fOMJ+mgxsHudmJxQlrg4OS8/LO6wYhP2NGRHI/TKjnxZq0lhlR1+BpV+2H37i
         rmEjrxfVOeF2tGexuiEGfx3/edQdpJ3t3SYyCdxrs8OZ4AN1rBhS5uvKU2QUApoxTev/
         is9Z6y3j+zuB8FAW5HiZc/SFahYwzTEV6pvaL/21cTttuRPGUoYQIdSxpZP+fSzmTJrG
         E/6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709937439; x=1710542239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LOPgQup6F0h+Ij6sYWAHH/M666uh+NTVfASk5SQVjok=;
        b=Xm8axRBQqhS70bN2J4uQVgPwh9iNyVmxOFOkBVB1wnKS4sRM1u3t2ncQ3dPZpHHbfl
         FJj493W/N/PGdsCJ7SJg1rhCE5l0T112rSOBl5wArvuEEL/yzKXGOjHSlUIJP3H6wt9r
         WFTdnY1IPWUC6CjbbykrTcvzWYpdy1ZuzzOoEnuim0al8YNEBo32BFV+hUOl0WbbfSQV
         2vZeM1DjHv+N60wqGbv02F08RLW14Rd00k/EJ9DvLv/ocN6iKelQb1+rl2ia4KKJlmiA
         F71r7wDfrZJbiZKYGHo3zBf19Y5CFcscG2X9S/vWduY1oSHRJNdPmzuuS1EKnRASDRLq
         KwJw==
X-Gm-Message-State: AOJu0YxQf2clWPlktBxi4OxXVblZYAy40iU6vzYGCfJ8wAQdaeQ/WClh
	cZNhrw00Kcd3SrlvpKteNvkwbGLm0NZiUCAvkO3hxtAuxe8lRCDtO4Bu1hBgjapkzbtUq0JU9Ek
	YjA==
X-Google-Smtp-Source: AGHT+IE+bRWrHBgfuwBsG6dtY85gAaVpOrnfiadQmUNlGYDrf9yDIsmazJJkMMBobyviU9ZOhjenSlHkL0o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2291:b0:6e5:94b0:68be with SMTP id
 f17-20020a056a00229100b006e594b068bemr21598pfe.2.1709937438717; Fri, 08 Mar
 2024 14:37:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 14:36:59 -0800
In-Reply-To: <20240308223702.1350851-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240308223702.1350851-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240308223702.1350851-7-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Selftests changes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add SEV(-ES) smoke tests, and start building out infrastructure to utilize the
"core" selftests harness and TAP.  In addition to provide TAP output, using the
infrastructure reduces boilerplate code and allows running all testscases in a
test, even if a previous testcase fails (compared with today, where a testcase
failure is terminal for the entire test).

As noted in the PMU pull request, the "Use TAP interface" changes have a few
conflicts.  3 of 4 are relatively straightforward, but the one in
userspace_msr_exit_test.c's test_msr_filter_allow() is a pain.  At least, I
thought so as I botched it at least twice.  (LOL, make that three times, as I
just botched my test merge resolution).

The code should end up looking like this:

---
KVM_ONE_VCPU_TEST_SUITE(user_msr);

KVM_ONE_VCPU_TEST(user_msr, msr_filter_allow, guest_code_filter_allow)
{
	struct kvm_vm *vm = vcpu->vm;
	uint64_t cmd;
	int rc;

	sync_global_to_guest(vm, fep_available);

	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
---

The resolutions I've been using can be found in kvm-x86/next.


The following changes since commit db7d6fbc10447090bab8691a907a7c383ec66f58:

  KVM: remove unnecessary #ifdef (2024-02-08 08:41:06 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.9

for you to fetch changes up to e9da6f08edb0bd4c621165496778d77a222e1174:

  KVM: selftests: Explicitly close guest_memfd files in some gmem tests (2024-03-05 13:31:20 -0800)

----------------------------------------------------------------
KVM selftests changes for 6.9:

 - Add macros to reduce the amount of boilerplate code needed to write "simple"
   selftests, and to utilize selftest TAP infrastructure, which is especially
   beneficial for KVM selftests with multiple testcases.

 - Add basic smoke tests for SEV and SEV-ES, along with a pile of library
   support for handling private/encrypted/protected memory.

 - Fix benign bugs where tests neglect to close() guest_memfd files.

----------------------------------------------------------------
Ackerley Tng (1):
      KVM: selftests: Add a macro to iterate over a sparsebit range

Dongli Zhang (1):
      KVM: selftests: Explicitly close guest_memfd files in some gmem tests

Michael Roth (2):
      KVM: selftests: Make sparsebit structs const where appropriate
      KVM: selftests: Add support for protected vm_vaddr_* allocations

Peter Gonda (5):
      KVM: selftests: Add support for allocating/managing protected guest memory
      KVM: selftests: Explicitly ucall pool from shared memory
      KVM: selftests: Allow tagging protected memory in guest page tables
      KVM: selftests: Add library for creating and interacting with SEV guests
      KVM: selftests: Add a basic SEV smoke test

Sean Christopherson (4):
      KVM: selftests: Move setting a vCPU's entry point to a dedicated API
      KVM: selftests: Extend VM creation's @shape to allow control of VM subtype
      KVM: selftests: Use the SEV library APIs in the intra-host migration test
      KVM: selftests: Add a basic SEV-ES smoke test

Thomas Huth (7):
      KVM: selftests: x86: sync_regs_test: Use vcpu_run() where appropriate
      KVM: selftests: x86: sync_regs_test: Get regs structure before modifying it
      KVM: selftests: Add a macro to define a test with one vcpu
      KVM: selftests: x86: Use TAP interface in the sync_regs test
      KVM: selftests: x86: Use TAP interface in the fix_hypercall test
      KVM: selftests: x86: Use TAP interface in the vmx_pmu_caps test
      KVM: selftests: x86: Use TAP interface in the userspace_msr_exit test

 tools/testing/selftests/kvm/Makefile               |   2 +
 tools/testing/selftests/kvm/guest_memfd_test.c     |   3 +
 .../selftests/kvm/include/aarch64/kvm_util_arch.h  |   7 ++
 .../selftests/kvm/include/kvm_test_harness.h       |  36 ++++++
 .../testing/selftests/kvm/include/kvm_util_base.h  |  61 +++++++++--
 .../selftests/kvm/include/riscv/kvm_util_arch.h    |   7 ++
 .../selftests/kvm/include/s390x/kvm_util_arch.h    |   7 ++
 tools/testing/selftests/kvm/include/sparsebit.h    |  56 +++++++---
 .../selftests/kvm/include/x86_64/kvm_util_arch.h   |  23 ++++
 .../selftests/kvm/include/x86_64/processor.h       |   8 ++
 tools/testing/selftests/kvm/include/x86_64/sev.h   | 107 ++++++++++++++++++
 .../testing/selftests/kvm/lib/aarch64/processor.c  |  24 +++-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  67 ++++++++++--
 tools/testing/selftests/kvm/lib/riscv/processor.c  |   9 +-
 tools/testing/selftests/kvm/lib/s390x/processor.c  |  13 ++-
 tools/testing/selftests/kvm/lib/sparsebit.c        |  48 ++++----
 tools/testing/selftests/kvm/lib/ucall_common.c     |   3 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  45 +++++++-
 tools/testing/selftests/kvm/lib/x86_64/sev.c       | 114 +++++++++++++++++++
 .../selftests/kvm/x86_64/fix_hypercall_test.c      |  27 +++--
 .../kvm/x86_64/private_mem_conversions_test.c      |   2 +
 .../selftests/kvm/x86_64/sev_migrate_tests.c       |  60 +++-------
 .../testing/selftests/kvm/x86_64/sev_smoke_test.c  |  88 +++++++++++++++
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  | 121 +++++++++++++++------
 .../selftests/kvm/x86_64/userspace_msr_exit_test.c |  52 +++------
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |  52 ++-------
 26 files changed, 802 insertions(+), 240 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/kvm_test_harness.h
 create mode 100644 tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_smoke_test.c

