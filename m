Return-Path: <kvm+bounces-41426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2852A67B93
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:06:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8008C8857B9
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE58E213E81;
	Tue, 18 Mar 2025 18:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nh0/yY3G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20599212FA2
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742320997; cv=none; b=sz5ANffISwk43FZwVoL6VqMHFfPOln66xclkLgyMemqMPfA1+4v1eNgbTmJjrRq5czLM0BzVcmTZWx1QOA3sGiClMX1noYaxueVfCfnhXnn3sYy6jaHoaq3qaHce1ILtSl5WJuAhkq2fffUP/Hgy0sNtGWF3esEmalHUb8bkGos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742320997; c=relaxed/simple;
	bh=XaNGJLkWPs0Qmbxt043B99FS4bhKF+GrcE4g0MLQJNU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gt9SLcd84aDM3mfrlgnNgQJb1JRnTNMYIpoNymSPcCOazIY9TM05cChMMqeNv0RPIBIqmW8O8sq6GRwZ2+WwUlEBl0Xs8VXPCAABUcEOjtoDGKRJrSfHRWvXAFJ6CH/Z4tYIDVt6B3bcc7xCOEaEI8EJSNwW342sG0gfOJ+Ha94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nh0/yY3G; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff605a7a43so9293768a91.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742320989; x=1742925789; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LnxJk4vBSHp9N1LYFKJLt0e8ikcWRVhvPtecH3/Bee4=;
        b=Nh0/yY3G5b1sdJkbN58sr2FAcrLAnmUr4RBP5rCe05GR51Sf7urOCTV0E8oPDD2Zlf
         /Zs7EJ89bBzyvveDqXWTSLfS3EsobAcxAL/5CZIoYOpe47grN9CNzMJJ0WauW+lo1xcF
         WutNW4IrXFMtu2v/I/Ac5UKyQrmmyjDyGDh/0DpEoEPNkbIrNA5uqSwtmJzae9p/HCuW
         zryO/1M5FC36DMbKrHT1bNeCgBnFbgH8jIgf7KXYdS70KvdkJGUXj9ByOJwozBfEzkXn
         EW2qEaNB/LuyvZTkjmhBzAaapNh/CwjVuXdnyXlm/COxyNlojul377gDFUCd/2EcYtxF
         rORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742320989; x=1742925789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LnxJk4vBSHp9N1LYFKJLt0e8ikcWRVhvPtecH3/Bee4=;
        b=RuHlKTaABtCSheIHIjoita8I7WZZE4OF0Rv+cxqg3QXSoR7/7UhvvqFEfd3ti7qO3t
         x3muRPDcJ6OqsxgafJ+WV68r+yrm+DJ71E5lEbn9A6w2hy5XzoyO33VeInYtDjDDFq5n
         RvwP34EuKCk4jiKXRHmITqeTUFRFPckm3odTb3JuiD7aIMIZeGC7HAIC0FOX7gyu9b0U
         7oya1Eb9DANq94iIzyGSxt+tqrUpM5ksFsyl2INcPXjzfdsXnU+FOj3yfytkkjMkG8wp
         Tm/b1raI/x72JTbJ1Kn1CqlVSMusfN+ZbmDzfInxbDd5BQzGbtOjJ50mujO+jHwJMP1R
         79vQ==
X-Gm-Message-State: AOJu0YxY7UxlQnm8AUoTiMjoZqDLCF2G6aHOQNGneraom3oCGzVQ4TW5
	XAj++70Il4C8mEac1ojQRTIXo8vPmlyFE5bnO9nRLBVS4kQOpCykXCAe4CUObeo0inJDCmFYcW+
	AZg==
X-Google-Smtp-Source: AGHT+IHZwwToMGKFE4smkp6DkYNdKGE/kbs13n/bLX0z07PsjJvXq6Jp/hz8OiDvzRRG1V1mnoUZJJtQRjQ=
X-Received: from pjbsd13.prod.google.com ([2002:a17:90b:514d:b0:2ea:5084:5297])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:388b:b0:2fe:b907:562f
 with SMTP id 98e67ed59e1d1-301a5b0d3fdmr4269014a91.14.1742320989263; Tue, 18
 Mar 2025 11:03:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Mar 2025 11:02:56 -0700
In-Reply-To: <20250318180303.283401-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318180303.283401-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318180303.283401-2-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.15
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A variety of cleanups and minor fixes, and improved support (and fixes) for
honoring L1 intercepts when emulating instructions on behalf of L2.

FWIW, unless I'm missing something, the severity of the L2 emulation bugs means
that emulating instructions while L2 is active is _very_ rare for real world
use cases.  I.e. the fixes are not urgent.

The following changes since commit a64dcfb451e254085a7daee5fe51bf22959d52d3:

  Linux 6.14-rc2 (2025-02-09 12:45:03 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.15

for you to fetch changes up to e6c8728a8e2d20b262209c70a8ca67719a628833:

  KVM: x86: Remove the unreachable case for 0x80000022 leaf in __do_cpuid_func() (2025-03-04 09:19:49 -0800)

----------------------------------------------------------------
KVM x86 misc changes for 6.15:

 - Fix a bug in PIC emulation that caused KVM to emit a spurious KVM_REQ_EVENT.

 - Add a helper to consolidate handling of mp_state transitions, and use it to
   clear pv_unhalted whenever a vCPU is made RUNNABLE.

 - Defer runtime CPUID updates until KVM emulates a CPUID instruction, to
   coalesce updates when multiple pieces of vCPU state are changing, e.g. as
   part of a nested transition.

 - Fix a variety of nested emulation bugs, and add VMX support for synthesizing
   nested VM-Exit on interception (instead of injecting #UD into L2).

 - Drop "support" for PV Async #PF with proctected guests without SEND_ALWAYS,
   as KVM can't get the current CPL.

 - Misc cleanups

----------------------------------------------------------------
Ethan Zhao (1):
      KVM: x86/cpuid: add type suffix to decimal const 48 fix building warning

Jim Mattson (2):
      KVM: x86: Introduce kvm_set_mp_state()
      KVM: x86: Clear pv_unhalted on all transitions to KVM_MP_STATE_RUNNABLE

Li RongQing (1):
      KVM: x86: Use kvfree_rcu() to free old optimized APIC map

Liam Ni (1):
      KVM: x86: Wake vCPU for PIC interrupt injection iff a valid IRQ was found

Sean Christopherson (19):
      KVM: x86: Use for-loop to iterate over XSTATE size entries
      KVM: x86: Apply TSX_CTRL_CPUID_CLEAR if and only if the vCPU has RTM or HLE
      KVM: x86: Query X86_FEATURE_MWAIT iff userspace owns the CPUID feature bit
      KVM: x86: Defer runtime updates of dynamic CPUID bits until CPUID emulation
      KVM: nVMX: Check PAUSE_EXITING, not BUS_LOCK_DETECTION, on PAUSE emulation
      KVM: nSVM: Pass next RIP, not current RIP, for nested VM-Exit on emulation
      KVM: nVMX: Allow emulating RDPID on behalf of L2
      KVM: nVMX: Emulate HLT in L2 if it's not intercepted
      KVM: nVMX: Consolidate missing X86EMUL_INTERCEPTED logic in L2 emulation
      KVM: x86: Plumb the src/dst operand types through to .check_intercept()
      KVM: x86: Plumb the emulator's starting RIP into nested intercept checks
      KVM: x86: Add a #define for the architectural max instruction length
      KVM: nVMX: Allow the caller to provide instruction length on nested VM-Exit
      KVM: nVMX: Synthesize nested VM-Exit for supported emulation intercepts
      KVM: selftests: Add a nested (forced) emulation intercept test for x86
      KVM: x86: Don't inject PV async #PF if SEND_ALWAYS=0 and guest state is protected
      KVM: x86: Rename and invert async #PF's send_user_only flag to send_always
      KVM: x86: Use a dedicated flow for queueing re-injected exceptions
      KVM: x86: Always set mp_state to RUNNABLE on wakeup from HLT

Ted Chen (1):
      KVM: x86: Remove unused iommu_domain and iommu_noncoherent from kvm_arch

Xiaoyao Li (1):
      KVM: x86: Remove the unreachable case for 0x80000022 leaf in __do_cpuid_func()

 arch/x86/include/asm/kvm_host.h                    |   9 +-
 arch/x86/kvm/cpuid.c                               |  52 ++++----
 arch/x86/kvm/cpuid.h                               |   9 +-
 arch/x86/kvm/emulate.c                             |   5 +-
 arch/x86/kvm/i8259.c                               |   2 +-
 arch/x86/kvm/kvm_emulate.h                         |   7 +-
 arch/x86/kvm/lapic.c                               |  17 +--
 arch/x86/kvm/smm.c                                 |   2 +-
 arch/x86/kvm/svm/nested.c                          |   2 +-
 arch/x86/kvm/svm/sev.c                             |   7 +-
 arch/x86/kvm/svm/svm.c                             |  17 ++-
 arch/x86/kvm/trace.h                               |  14 +-
 arch/x86/kvm/vmx/nested.c                          |  18 +--
 arch/x86/kvm/vmx/nested.h                          |  22 +++-
 arch/x86/kvm/vmx/vmx.c                             | 120 ++++++++++++-----
 arch/x86/kvm/x86.c                                 | 136 +++++++++----------
 arch/x86/kvm/x86.h                                 |   7 +
 arch/x86/kvm/xen.c                                 |   4 +-
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../selftests/kvm/x86/nested_emulation_test.c      | 146 +++++++++++++++++++++
 20 files changed, 416 insertions(+), 181 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/nested_emulation_test.c

