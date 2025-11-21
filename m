Return-Path: <kvm+bounces-64226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C644C7B5F6
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1F4BE35FA90
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 965A12F261A;
	Fri, 21 Nov 2025 18:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kwt3e+yb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FA43A1C9
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763750654; cv=none; b=ajDlx1vfb64ShGRKbh2qMLqlN5MHdPkwSoXpJIUezd8ZyOd00EpNX4QL0ZjX1mzHCJrcXx+RkmNusqolnxi0TyU7WTMbR38lW6dKsSLowfGIfl7Ua48hBkhKOycyv92gkhn1F8bC2vr6c/Xcr6GCvNaa5Gf6XVKsDhqE5ip/aQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763750654; c=relaxed/simple;
	bh=sTsoBriAcRT8jSD7A4hcif5f79IbeMjA5xydgfIYXmY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=FFJqNXfKziElRfZVvC6NlB6+WX9y70GulipM1oi5ZwTcNF7tyyhaK0TioEHjzQSj3A7xKki9SgsycaKC7H59GVJbLgqTWNx94KE2OicI4qWuDWFrXu9usPSk0glmRVNNNVv7Lt0L+sKmTE5yJYe4iffmcXLBke43c4jtQ8yFP5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kwt3e+yb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3438744f11bso6521517a91.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763750652; x=1764355452; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=scTl7a8sTQ4GEKkbrOBUGir3O6p7Bh2C0OKRu0mDrnU=;
        b=Kwt3e+ybhFRaWhh32JaolVpwQbYd0ttBKLb7hRd0S7JbcJYN0GgiCwyC1tsknoTw97
         BFMWdeoTw8/NeNMLBnXe0WIN9eiKEmotAodYd2VaIqxMBULpGKG7XDjdMrT9+JzlpAI+
         PxonoJ3clgMm73AzJZy0i8ipdEJjEH4YvTWvQ7mCnex8V8nNXA0ZV1zCM3Rj9/y1tg58
         rVDLybol00DiY5aexMqEZRwjwzCUkPDHjtLQA5jqd/cbZIjOIRJJ3E/oVsilrSEKkif6
         vo/jMYTgeS4FNjKzD6BvqLvB3RMSGH2Z3xVebcNUHltRBGeTdO1GG29fR42TnmxCKWV4
         xAAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763750652; x=1764355452;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=scTl7a8sTQ4GEKkbrOBUGir3O6p7Bh2C0OKRu0mDrnU=;
        b=t33bH2pcCxUVe6zCiQ7IVX/l+M6iWk7BnCGKOuooRMrd6RpFokOoQnqG1Oni7RqT+A
         9Y/BHCN4bkCEHYzSyX1ZnvdccxiOtEhq0bD4t5qHheRTru67mcKFEXtQD9emylG6jzOm
         ooJqCoswJd7/a4xIu5M83O9sqDpBaLvN6KHUuA1lorGuLPiXI5QUdrCJQXp8JZwOilkH
         2jh/8xhWoWuCG4hNZeEt+ay7FeHIz/0xUPqcz/9AllqOpMSLL3aAwBCRzDrcztzwD8Jm
         nBA3JkriQixvKwYFYfYdqmlqzX/CmCPJEjqiOkycCnH92dXjVJTZIh/K8oJ9SIg6TKvH
         zaJw==
X-Gm-Message-State: AOJu0YyyIjxxKK7NtB3Uk4gqYtycRrW0Zi2Z5CGRVrTFH3TGtekVkEsX
	fRLV1onBBXsVb24JPRHnSB10KHoDLmlZKMpDTDZjkpEbqrBgeGLUp4GDAI7whgENsNx1E+U0dcs
	he8Pgwg==
X-Google-Smtp-Source: AGHT+IHqIzI6/eX+M77METO5h1Wu7G1KLCGIOf2BgRfCvA+uMVVvIx+s01MVZzW+quu/0mK3wDzy+JMJrOA=
X-Received: from pjuf21.prod.google.com ([2002:a17:90a:ce15:b0:340:d03e:4ed9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4906:b0:340:f05a:3ebd
 with SMTP id 98e67ed59e1d1-34733f23548mr2765875a91.28.1763750652533; Fri, 21
 Nov 2025 10:44:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 10:44:09 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121184409.286650-1-seanjc@google.com>
Subject: [kvm-unit-tests GIT PULL] x86: A pile of changes
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull a large pile of (mostly) x86 changes that have accumulated over
the last few months.  Note, there are arm and arm64 changes in here, Acked-by
Drew.  They were add-ons to an x86 change, but I had to drop the x86 change
because of pre-existing test bugs[1].

I didn't include the AVX VMOVDQA series[2] here, to give you (and others) a
chance to review the changes.  Definitely feel free to apply it directly :-)

[1] https://lore.kernel.org/all/3bac29b9-4c49-4e5d-997e-9e4019a2fceb@grsecurity.net
[2] http://lore.kernel.org/all/20251121180901.271486-1-seanjc@google.com

The following changes since commit af582a4ebaf7828c200dc7150aa0dbccb60b08a7:

  lib: make limits.h more Clang friendly (2025-09-16 08:09:00 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/kvm-unit-tests.git tags/kvm-x86-2025.11.21

for you to fetch changes up to f561b31d3dee01f8be58978be23bb0903543153d:

  x86: pmu_pebs: Support to validate timed PEBS record on GNR/SRF (2025-11-20 16:44:30 -0800)

----------------------------------------------------------------
KVM-Unit-Tests x86 (and one-off arm+arm64) changes:

 - Ensure do_iret() has a valid stack frame for x86_64 (it worked by dumb
   luck of the top-most page in virtual address space always being mapped).

 - Add more selective CR0 write and LMSW testcases for nested SVM.

 - Add more LBR virtualization testcases for nested SVM.

 - Extend non-canonical memory access tests to verify CR2 isn't clobbered.

 - Provide better backtraces for arm and arm64.  Support for x86 is also in
   the works, but is blocked due to existing test bugs that are exposed by
   the forced profiling.

 - Add (lots) more CET testcases.

 - Workaround PMU test failures on Intel CPUs with overcount errata.

 - Misc cleanups and fixes.

----------------------------------------------------------------
Chao Gao (9):
      x86/eventinj: Use global asm label for nested NMI IP address verification
      x86/eventinj: Push SS and SP to IRET frame
      x86: cet: Remove unnecessary memory zeroing for shadow stack
      x86: cet: Directly check for #CP exception in run_in_user()
      x86: cet: Validate #CP error code
      x86: cet: Use report_skip()
      x86: cet: Drop unnecessary casting
      x86: cet: Validate writing unaligned values to SSP MSR causes #GP
      x86: cet: Validate CET states during VMX transitions

Dapeng Mi (3):
      x86/pmu: Relax precise count check for emulated instructions tests
      x86: pmu_pebs: Remove abundant data_cfg_match calculation
      x86: pmu_pebs: Support to validate timed PEBS record on GNR/SRF

Mathias Krause (15):
      x86: Print error code for unhandled exceptions
      x86/emulator64: Extend non-canonical memory access tests with CR2 coverage
      x86: Don't rely on KVM's hypercall patching
      x86: Provide a macro for extable handling
      x86/hypercall: Simplify and increase coverage
      Makefile: Provide a concept of late CFLAGS
      arm64: Better backtraces for leaf functions
      arm: Fix backtraces involving leaf functions
      x86: cet: Make shadow stack less fragile
      x86: cet: Simplify IBT test
      x86: cet: Use symbolic values for the #CP error codes
      x86: cet: Test far returns too
      x86: Avoid top-most page for vmalloc on x86-64
      x86: cet: Enable NOTRACK handling for IBT tests
      x86: cet: Reset IBT tracker state on #CP violations

Sean Christopherson (7):
      x86/emulator64: Add macro to test emulation of non-canonical accesses
      x86/svm: Account for numerical rounding errors in TSC scaling test
      x86: cet: Run SHSTK and IBT tests as appropriate if either feature is supported
      x86: cet: Drop the "intel_" prefix from the CET testcase
      x86: cet: Add testcases to verify KVM rejects emulation of CET instructions
      x86/vmexit: Add WBINVD and INVD VM-Exit latency testcases
      x86/emulator: Treat DR6_BUS_LOCK as writable if CPU has BUS_LOCK_DETECT

Yang Weijiang (1):
      x86: cet: Pass virtual addresses to invlpg

Yosry Ahmed (13):
      scripts: Always return '2' when skipping tests
      x86/vmx: Skip vmx_pf_exception_test_fep early if FEP is not available
      x86/svm: Cleanup selective cr0 write intercept test
      x86/svm: Move CR0 selective write intercept test near CR3 intercept
      x86/svm: Add FEP helpers for SVM tests
      x86/svm: Report unsupported SVM tests
      x86/svm: Move report_svm_guest() to the top of svm_tests.c
      x86/svm: Print SVM test names before running tests
      x86/svm: Generalize and improve selective CR0 write intercept test
      x86/svm: Add more selective CR0 write and LMSW test cases
      x86/svm: Correctly extract the IP from LBR MSRs
      x86/svm: Cleanup LBRV tests
      x86/svm: Add more LBRV test cases

dongsheng (5):
      x86/pmu: Add helper to detect Intel overcount issues
      x86/pmu: Relax precise count validation for Intel overcounted platforms
      x86/pmu: Fix incorrect masking of fixed counters
      x86/pmu: Handle instruction overcount issue in overflow test
      x86/pmu: Expand "llc references" upper limit for broader compatibility

 Makefile             |   4 +
 arm/Makefile.arm     |   8 +
 arm/Makefile.arm64   |   6 +
 lib/arm/stack.c      |  18 ++-
 lib/x86/desc.c       |   6 +-
 lib/x86/desc.h       |  17 ++-
 lib/x86/msr.h        |   9 +-
 lib/x86/pmu.c        |  39 +++++
 lib/x86/pmu.h        |  11 ++
 lib/x86/processor.h  |  27 ++++
 lib/x86/usermode.c   |  16 +-
 lib/x86/usermode.h   |  13 +-
 lib/x86/vm.c         |   2 +
 scripts/runtime.bash |   4 +-
 x86/apic.c           |   5 +-
 x86/cet.c            | 302 ++++++++++++++++++++++++++++++--------
 x86/emulator.c       |   9 +-
 x86/emulator64.c     |  54 ++++---
 x86/eventinj.c       |  24 ++-
 x86/hypercall.c      | 131 ++++++++---------
 x86/lam.c            |  10 +-
 x86/pmu.c            |  72 ++++++---
 x86/pmu_pebs.c       |   9 +-
 x86/svm.c            |  10 +-
 x86/svm.h            |   1 +
 x86/svm_tests.c      | 402 +++++++++++++++++++++++++++++++++++----------------
 x86/unittests.cfg    |  10 +-
 x86/vmexit.c         |  17 ++-
 x86/vmx.h            |   8 +-
 x86/vmx_tests.c      |  86 +++++++++++
 30 files changed, 987 insertions(+), 343 deletions(-)

