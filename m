Return-Path: <kvm+bounces-35712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B801AA14756
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 02:08:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A23C2188D6A2
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 01:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2453F12DD8A;
	Fri, 17 Jan 2025 01:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qsgfCIr7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAE7288DA
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 01:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737076048; cv=none; b=TJOLnRt41quBNkI+QuTZmGuBmcpu5oRYRv4JVglIzaj4v706PJb3PHhAZvQIHhDP6OYqT0Jqkpbatk7MP+lITz2vxKicl13fEqec7zdylL05M4H9bYngfYtHlGTTP4c6seBocSPuXkS0qYsTXb9Xtf0P482G3d9678Of+gEuDbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737076048; c=relaxed/simple;
	bh=IJ/Od2WwzVaIiDHRUTVKIa99VAKjHycXj89MDlcF+Ok=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rh1BiZ7NIavpcgEheLXWsOJHDJhDGUEOh9edlmt9vsBNW6p9ObLT81uEhh5CoyZnQFuHKbirl882fgnbtLqJ+WBdhXpgUsWLOLWJdDWm1N+kEocvQn9NQyeI1DjcOIqTVALCB19AHeKOm0ownG44g4LwATewiKrKKVO03gR9t1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qsgfCIr7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee86953aeaso3088157a91.2
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 17:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737076046; x=1737680846; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FIgnMdPfU6Xl0yrmrFHWlhtpFjWojdE0kcdVQBTjKls=;
        b=qsgfCIr7REoeeyG71TnziOtVof0iWcsg46amaIdsMMkcF3ywHd//hBHREJJqFVs15o
         KVsPl4kJdMsBz4w12j2EroPJoZYFUdQUwX5APumMdCJk8DxpQFTTWJTwC8rWvxZLTnDO
         bpjD9H4uM6g/Ui8vjdT/SnQXdICXe88+YQEYjO8h/wqPGEElYuhg125FQtOYiMHzPtqw
         TNx+frHvvR9RceoYvcDEA2WrQDII5w5WzTuUwBS0jDOBXNZXLInFEhPeun0KAUk2AJV8
         sPwY6TzW5MoJ+h0AK8Gbr2vhCsjgLVR0MWCK4aAKs+v4rHg8ivZglp/a3OWZHjFEJnhv
         Qlig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737076046; x=1737680846;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FIgnMdPfU6Xl0yrmrFHWlhtpFjWojdE0kcdVQBTjKls=;
        b=w5pAuQNitQa5MJHjz9bJnmTXYVtlByLSrcuiWzVZH5utw2wJ1qhl6w0JWkHnh/n/o4
         Vqh4/ypcgA41WCrzDmi83OyeRYvbi8DK8wSJ/myp/GPa7T8vYO64xWXS5NpYeG5H+Jkl
         dqYtPkF+/66kohB78cxtZVA7JTTz2kkWD5GobYL4dveNnUq6dX5p1BovFi9QU52jhdKO
         k8fivgjvOb0fsMsFzeb+sBIFUQCiYi7BTdjl8rze0C4Ztiq3YO30L4L6D4ZvHk3P6Vy8
         rhN8KW3lOn6D5gnd4H3dlbBL8RrlFWJaHQ03jIhNsKrQNxZsmZ6vakUoAXA4AT8KMZAD
         yUmg==
X-Gm-Message-State: AOJu0YzBBJeppuoZqOsv7+1FyqKSJ3+BXPL5P2SKR2J1U+UAHXmlDvFq
	5u6dujgNjFS2w7xjacgAhCh6qvT70YCKGlctoIndpo3KWYGWj+R2gLcFHG59zaYJXJngVgHeUUs
	I0w==
X-Google-Smtp-Source: AGHT+IGMxwNqJMQ7sU+MqpCR82w9DEZU3ev2E9jOVw6as9MUG7rvMXpYC+mCmG6gGDURE5BOFIi1fia4gus=
X-Received: from pjbpx16.prod.google.com ([2002:a17:90b:2710:b0:2ef:786a:1835])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f4f:b0:2ee:6d08:7936
 with SMTP id 98e67ed59e1d1-2f782ca2bcemr979128a91.20.1737076046031; Thu, 16
 Jan 2025 17:07:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Jan 2025 17:07:13 -0800
In-Reply-To: <20250117010718.2328467-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117010718.2328467-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117010718.2328467-3-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc/main changes 6.14
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The vast majority of this pull request is the overhaul of KVM's CPUID feature
handling, which eliminates the kludgy "governed" features code and hopefully
makes it easier to maintain and understand kvm_set_cpu_caps().

There is a merge conflict with the tip tree that looks a lot scarier than it
actually is (a single feature, SRSO_USER_KERNEL_NO, was added)[*].  I assume it
would be easier to resolve the conflict if the tip tree is merged on top?

The other highlight is Ivan's fixes for dealing with VM-Exits that occur while
the CPU is vectoring an event.

[*] https://lore.kernel.org/all/20250106150509.19432acd@canb.auug.org.au

The following changes since commit 9af04539d474dda4984ff4909d4568e6123c8cba:

  KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR (2024-12-18 14:15:05 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.14

for you to fetch changes up to 4c20cd4cee929aef89118ac8820cefab427c6ae1:

  KVM: x86: Avoid double RDPKRU when loading host/guest PKRU (2025-01-08 14:08:25 -0800)

----------------------------------------------------------------
KVM x86 misc changes for 6.14:

 - Overhaul KVM's CPUID feature infrastructure to replace "governed" features
   with per-vCPU tracking of the vCPU's capabailities for all features.  Along
   the way, refactor the code to make it easier to add/modify features, and
   add a variety of self-documenting macro types to again simplify adding new
   features and to help readers understand KVM's handling of existing features.

 - Rework KVM's handling of VM-Exits during event vectoring to plug holes where
   KVM unintentionally puts the vCPU into infinite loops in some scenarios,
   e.g. if emulation is triggered by the exit, and to bring parity between VMX
   and SVM.

 - Add pending request and interrupt injection information to the kvm_exit and
   kvm_entry tracepoints respectively.

 - Fix a relatively benign flaw where KVM would end up redoing RDPKRU when
   loading guest/host PKRU due to a refactoring of the kernel helpers that
   didn't account for KVM's pre-checking of the need to do WRPKRU.

----------------------------------------------------------------
Ivan Orlov (7):
      KVM: x86: Add function for vectoring error generation
      KVM: x86: Add emulation status for unhandleable exception vectoring
      KVM: x86: Try to unprotect and retry on unhandleable emulation failure
      KVM: VMX: Handle event vectoring error in check_emulate_instruction()
      KVM: SVM: Handle event vectoring error in check_emulate_instruction()
      KVM: selftests: Add and use a helper function for x86's LIDT
      KVM: selftests: Add test case for MMIO during vectoring on x86

Liam Ni (1):
      KVM: x86: Use LVT_TIMER instead of an open coded literal

Maxim Levitsky (2):
      KVM: x86: Add interrupt injection information to the kvm_entry tracepoint
      KVM: x86: Add information about pending requests to kvm_exit tracepoint

Sean Christopherson (58):
      KVM: x86: Use feature_bit() to clear CONSTANT_TSC when emulating CPUID
      KVM: x86: Limit use of F() and SF() to kvm_cpu_cap_{mask,init_kvm_defined}()
      KVM: x86: Do all post-set CPUID processing during vCPU creation
      KVM: x86: Explicitly do runtime CPUID updates "after" initial setup
      KVM: x86: Account for KVM-reserved CR4 bits when passing through CR4 on VMX
      KVM: selftests: Update x86's set_sregs_test to match KVM's CPUID enforcement
      KVM: selftests: Assert that vcpu->cpuid is non-NULL when getting CPUID entries
      KVM: selftests: Refresh vCPU CPUID cache in __vcpu_get_cpuid_entry()
      KVM: selftests: Verify KVM stuffs runtime CPUID OS bits on CR4 writes
      KVM: x86: Move __kvm_is_valid_cr4() definition to x86.h
      KVM: x86/pmu: Drop now-redundant refresh() during init()
      KVM: x86: Drop now-redundant MAXPHYADDR and GPA rsvd bits from vCPU creation
      KVM: x86: Disallow KVM_CAP_X86_DISABLE_EXITS after vCPU creation
      KVM: x86: Reject disabling of MWAIT/HLT interception when not allowed
      KVM: x86: Drop the now unused KVM_X86_DISABLE_VALID_EXITS
      KVM: selftests: Fix a bad TEST_REQUIRE() in x86's KVM PV test
      KVM: selftests: Update x86's KVM PV test to match KVM's disabling exits behavior
      KVM: x86: Zero out PV features cache when the CPUID leaf is not present
      KVM: x86: Don't update PV features caches when enabling enforcement capability
      KVM: x86: Do reverse CPUID sanity checks in __feature_leaf()
      KVM: x86: Account for max supported CPUID leaf when getting raw host CPUID
      KVM: x86: Unpack F() CPUID feature flag macros to one flag per line of code
      KVM: x86: Rename kvm_cpu_cap_mask() to kvm_cpu_cap_init()
      KVM: x86: Add a macro to init CPUID features that are 64-bit only
      KVM: x86: Add a macro to precisely handle aliased 0x1.EDX CPUID features
      KVM: x86: Handle kernel- and KVM-defined CPUID words in a single helper
      KVM: x86: #undef SPEC_CTRL_SSBD in cpuid.c to avoid macro collisions
      KVM: x86: Harden CPU capabilities processing against out-of-scope features
      KVM: x86: Add a macro to init CPUID features that ignore host kernel support
      KVM: x86: Add a macro to init CPUID features that KVM emulates in software
      KVM: x86: Swap incoming guest CPUID into vCPU before massaging in KVM_SET_CPUID2
      KVM: x86: Clear PV_UNHALT for !HLT-exiting only when userspace sets CPUID
      KVM: x86: Remove unnecessary caching of KVM's PV CPUID base
      KVM: x86: Always operate on kvm_vcpu data in cpuid_entry2_find()
      KVM: x86: Move kvm_find_cpuid_entry{,_index}() up near cpuid_entry2_find()
      KVM: x86: Remove all direct usage of cpuid_entry2_find()
      KVM: x86: Advertise TSC_DEADLINE_TIMER in KVM_GET_SUPPORTED_CPUID
      KVM: x86: Advertise HYPERVISOR in KVM_GET_SUPPORTED_CPUID
      KVM: x86: Rename "governed features" helpers to use "guest_cpu_cap"
      KVM: x86: Replace guts of "governed" features with comprehensive cpu_caps
      KVM: x86: Initialize guest cpu_caps based on guest CPUID
      KVM: x86: Extract code for generating per-entry emulated CPUID information
      KVM: x86: Treat MONTIOR/MWAIT as a "partially emulated" feature
      KVM: x86: Initialize guest cpu_caps based on KVM support
      KVM: x86: Avoid double CPUID lookup when updating MWAIT at runtime
      KVM: x86: Drop unnecessary check that cpuid_entry2_find() returns right leaf
      KVM: x86: Update OS{XSAVE,PKE} bits in guest CPUID irrespective of host support
      KVM: x86: Update guest cpu_caps at runtime for dynamic CPUID-based features
      KVM: x86: Shuffle code to prepare for dropping guest_cpuid_has()
      KVM: x86: Replace (almost) all guest CPUID feature queries with cpu_caps
      KVM: x86: Drop superfluous host XSAVE check when adjusting guest XSAVES caps
      KVM: x86: Add a macro for features that are synthesized into boot_cpu_data
      KVM: x86: Pull CPUID capabilities from boot_cpu_data only as needed
      KVM: x86: Rename "SF" macro to "SCATTERED_F"
      KVM: x86: Explicitly track feature flags that require vendor enabling
      KVM: x86: Explicitly track feature flags that are enabled at runtime
      KVM: x86: Use only local variables (no bitmask) to init kvm_cpu_caps
      KVM: x86: Avoid double RDPKRU when loading host/guest PKRU

 Documentation/virt/kvm/api.rst                     |  10 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |  65 +-
 arch/x86/kvm/cpuid.c                               | 967 ++++++++++++++-------
 arch/x86/kvm/cpuid.h                               | 128 ++-
 arch/x86/kvm/governed_features.h                   |  22 -
 arch/x86/kvm/hyperv.c                              |   2 +-
 arch/x86/kvm/kvm_emulate.h                         |   2 +
 arch/x86/kvm/lapic.c                               |   6 +-
 arch/x86/kvm/mmu.h                                 |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |   4 +-
 arch/x86/kvm/pmu.c                                 |   1 -
 arch/x86/kvm/reverse_cpuid.h                       |  23 +-
 arch/x86/kvm/smm.c                                 |  10 +-
 arch/x86/kvm/svm/nested.c                          |  22 +-
 arch/x86/kvm/svm/pmu.c                             |   8 +-
 arch/x86/kvm/svm/sev.c                             |  21 +-
 arch/x86/kvm/svm/svm.c                             |  70 +-
 arch/x86/kvm/svm/svm.h                             |   4 +-
 arch/x86/kvm/trace.h                               |  17 +-
 arch/x86/kvm/vmx/hyperv.h                          |   2 +-
 arch/x86/kvm/vmx/main.c                            |   1 +
 arch/x86/kvm/vmx/nested.c                          |  18 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   4 +-
 arch/x86/kvm/vmx/sgx.c                             |  14 +-
 arch/x86/kvm/vmx/vmx.c                             | 100 +--
 arch/x86/kvm/vmx/x86_ops.h                         |   3 +
 arch/x86/kvm/x86.c                                 | 188 ++--
 arch/x86/kvm/x86.h                                 |   6 +-
 include/uapi/linux/kvm.h                           |   4 -
 .../testing/selftests/kvm/include/x86/processor.h  |  25 +-
 .../testing/selftests/kvm/set_memory_region_test.c |  53 +-
 tools/testing/selftests/kvm/x86/kvm_pv_test.c      |  38 +-
 tools/testing/selftests/kvm/x86/set_sregs_test.c   |  63 +-
 tools/testing/selftests/kvm/x86/sev_smoke_test.c   |   2 +-
 35 files changed, 1187 insertions(+), 719 deletions(-)
 delete mode 100644 arch/x86/kvm/governed_features.h

