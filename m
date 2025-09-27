Return-Path: <kvm+bounces-58921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84651BA59B4
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 08:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3952C62262C
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 06:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D5E27FB3E;
	Sat, 27 Sep 2025 06:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aDmCiaiw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CECD258ED4
	for <kvm@vger.kernel.org>; Sat, 27 Sep 2025 06:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758953370; cv=none; b=tu1+k6X/jYxxFSk3diezkfylugHJ6cRojiKsNy2PVLiUpOi+84LMRL94sTDFzql+Z1ipcv3XDJbBldfo+EAwI6WME0d23vFKVdetOD5FigqvyMmTuBRKFEu/251mH7892cisW+ZKC2uU9bxjfPANcCCkoNuJV1M3AWxS8r0yKC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758953370; c=relaxed/simple;
	bh=6dKDkbw03tFl6CHNS9HS0jZpDAgi/3/8mMvIUAcG4vY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dmAxj+ErJ/cPwEwZ4HmWdgvBDI/KRnqZT8H/7bEPoYMx4gBEtZ3/8CoEiXk1hGdDoQ+ZudeZBbkfQsIs/oVk8aWY/j8Iq4xwXLyz9QZvbEyZrEJpJ0ZNOWL+eTffZQcLIo+LUZsVvxm6fJ5zCLkj7W+j+tyRRkx3bxHN4dGyOfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aDmCiaiw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ec2211659so2975939a91.0
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 23:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758953368; x=1759558168; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/NsLpeUSndoPfAX+lsYL19n/Kvq+oOUbDD85mV11fl0=;
        b=aDmCiaiw/UCckfSwzet7nT54c78KEgt9g31OLYJTlfktmW+Th5+DDswK8KEr1wr/JD
         LkLBEVUSQmHswJXlIsbwTkaWyhqeP6deAnf3YMZhIyIeKp1Jh/QSzEgAg+16niwI++j9
         ChdP04MfL1+QikWokjuUjBl/Kk9EsDnw4zzQKHpxBCPk0BBKKSJZBoURDXqP8DSaSqod
         cmPi8BgOHELthPAlTwQIh0YmBB0AywCc82lZ4/O0iGxS3a5OEpAarnzS5nqY5VeIrfrO
         eLSTUqVZjX3QdH5rN6VG8TTKgxntbtHZfiIZruG0cZ8qLZpomOLH3IqR1AoIbhTsoBtB
         BiYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758953368; x=1759558168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/NsLpeUSndoPfAX+lsYL19n/Kvq+oOUbDD85mV11fl0=;
        b=IJO6PIMgaQS5ywVtEZljn1rnTXLjoXuTGEP0GHkTumGWsQcduok5/Py6UqL1TqTb+C
         WkL392T6cVAa8N7HpA16OrPI79MFs2xuQTqNJ/ks2Re5Lx81cI7UItizoFf1UZi26gdA
         oDd3p6cEBIJ7HSzD0D/mDSv1VG1n2KNsQ+voUSXMhX+1gbLi8aiKqAzgzp1R9zDhvU/j
         o366r7bR+pd5byIdSnQKwX8Oe6AHInxeo439TIRJSImx+T3t8HvCvse1KPykqzo3zil6
         pPGEEKmpsgMVdz/96fd6qRYQgEO35maki3lJLda5WS00nkDSVMOE4rE32IhmQyZyWDU3
         Ykug==
X-Gm-Message-State: AOJu0Ywhi3MBqNmP4OyUWi6pPsBb19jWoH1tBJFjQAYnMKmhOzi3NW1K
	RaAu+6zZHKrxpZxa6VYrL6HtJYEWi5fC5RRtFJppeDRP8OT9cw1rv5tp6+Z7b/lV5a358mEn75d
	tc0Abiw==
X-Google-Smtp-Source: AGHT+IFzFRyBsPRqe1psXzsUMqVmezGTSpHbCcLiOyFSYiXil3YJv8QplxNYlQ8wQ0IHiFDkkJXXlFTgyws=
X-Received: from pjrv14.prod.google.com ([2002:a17:90a:bb8e:b0:330:429d:b28c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d83:b0:32e:a10b:ce33
 with SMTP id 98e67ed59e1d1-3342a2b94b5mr10670974a91.21.1758953367718; Fri, 26
 Sep 2025 23:09:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Sep 2025 23:09:08 -0700
In-Reply-To: <20250927060910.2933942-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250927060910.2933942-9-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.18
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Lots and lots (and lots) of prep work for CET and FRED virtualization, and for
mediated vPMU support (about 1/3 of that series is in here, as it didn't make
the cut this time around, and the cleanups are worthwhile on their own).

Buried in here is also support for immediate forms of RDMSR/WRMSRNS, and
fastpath exit handling for TSC_DEADLINE writes on AMD.

The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9:

  Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.18

for you to fetch changes up to 86bcd23df9cec9c2df520ae0982033e301d3c184:

  KVM: x86: Fix hypercalls docs section number order (2025-09-22 07:51:36 -0700)

----------------------------------------------------------------
KVM x86 changes for 6.18

 - Don't (re)check L1 intercepts when completing userspace I/O to fix a flaw
   where a misbehaving usersepace (a.k.a. syzkaller) could swizzle L1's
   intercepts and trigger a variety of WARNs in KVM.

 - Emulate PERF_CNTR_GLOBAL_STATUS_SET for PerfMonV2 guests, as the MSR is
   supposed to exist for v2 PMUs.

 - Allow Centaur CPU leaves (base 0xC000_0000) for Zhaoxin CPUs.

 - Clean up KVM's vector hashing code for delivering lowest priority IRQs.

 - Clean up the fastpath handler code to only handle IPIs and WRMSRs that are
   actually "fast", as opposed to handling those that KVM _hopes_ are fast, and
   in the process of doing so add fastpath support for TSC_DEADLINE writes on
   AMD CPUs.

 - Clean up a pile of PMU code in anticipation of adding support for mediated
   vPMUs.

 - Add support for the immediate forms of RDMSR and WRMSRNS, sans full
   emulator support (KVM should never need to emulate the MSRs outside of
   forced emulation and other contrived testing scenarios).

 - Clean up the MSR APIs in preparation for CET and FRED virtualization, as
   well as mediated vPMU support.

 - Rejecting a fully in-kernel IRQCHIP if EOIs are protected, i.e. for TDX VMs,
   as KVM can't faithfully emulate an I/O APIC for such guests.

 - KVM_REQ_MSR_FILTER_CHANGED into a generic RECALC_INTERCEPTS in preparation
   for mediated vPMU support, as KVM will need to recalculate MSR intercepts in
   response to PMU refreshes for guests with mediated vPMUs.

 - Misc cleanups and minor fixes.

----------------------------------------------------------------
Bagas Sanjaya (1):
      KVM: x86: Fix hypercalls docs section number order

Chao Gao (1):
      KVM: x86: Zero XSTATE components on INIT by iterating over supported features

Dapeng Mi (5):
      KVM: x86/pmu: Correct typo "_COUTNERS" to "_COUNTERS"
      KVM: x86: Rename vmx_vmentry/vmexit_ctrl() helpers
      KVM: x86/pmu: Move PMU_CAP_{FW_WRITES,LBR_FMT} into msr-index.h header
      KVM: VMX: Add helpers to toggle/change a bit in VMCS execution controls
      KVM: x86/pmu: Use BIT_ULL() instead of open coded equivalents

Ewan Hai (1):
      KVM: x86: allow CPUID 0xC000_0000 to proceed on Zhaoxin CPUs

Jiaming Zhang (1):
      Documentation: KVM: Call out that KVM strictly follows the 8254 PIT spec

Liao Yuanhong (2):
      KVM: x86: Use guard() instead of mutex_lock() to simplify code
      KVM: x86: hyper-v: Use guard() instead of mutex_lock() to simplify code

Sagi Shahar (1):
      KVM: TDX: Reject fully in-kernel irqchip if EOIs are protected, i.e. for TDX VMs

Sean Christopherson (34):
      KVM: x86: Don't (re)check L1 intercepts when completing userspace I/O
      KVM: SVM: Emulate PERF_CNTR_GLOBAL_STATUS_SET for PerfMonV2
      KVM: SVM: Skip fastpath emulation on VM-Exit if next RIP isn't valid
      KVM: x86: Add kvm_icr_to_lapic_irq() helper to allow for fastpath IPIs
      KVM: x86: Only allow "fast" IPIs in fastpath WRMSR(X2APIC_ICR) handler
      KVM: x86: Drop semi-arbitrary restrictions on IPI type in fastpath
      KVM: x86: Unconditionally handle MSR_IA32_TSC_DEADLINE in fastpath exits
      KVM: x86: Acquire SRCU in WRMSR fastpath iff instruction needs to be skipped
      KVM: x86: Unconditionally grab data from EDX:EAX in WRMSR fastpath
      KVM: x86: Fold WRMSR fastpath helpers into the main handler
      KVM: x86/pmu: Move kvm_init_pmu_capability() to pmu.c
      KVM: x86/pmu: Add wrappers for counting emulated instructions/branches
      KVM: x86/pmu: Calculate set of to-be-emulated PMCs at time of WRMSRs
      KVM: x86/pmu: Rename pmc_speculative_in_use() to pmc_is_locally_enabled()
      KVM: x86/pmu: Open code pmc_event_is_allowed() in its callers
      KVM: x86/pmu: Drop redundant check on PMC being globally enabled for emulation
      KVM: x86/pmu: Drop redundant check on PMC being locally enabled for emulation
      KVM: x86/pmu: Rename check_pmu_event_filter() to pmc_is_event_allowed()
      KVM: x86: Push acquisition of SRCU in fastpath into kvm_pmu_trigger_event()
      KVM: x86: Add a fastpath handler for INVD
      KVM: x86: Rename local "ecx" variables to "msr" and "pmc" as appropriate
      KVM: x86: Use double-underscore read/write MSR helpers as appropriate
      KVM: x86: Manually clear MPX state only on INIT
      KVM: x86: Move kvm_irq_delivery_to_apic() from irq.c to lapic.c
      KVM: x86: Make "lowest priority" helpers local to lapic.c
      KVM: x86: Move vector_hashing into lapic.c
      KVM: VMX: Setup canonical VMCS config prior to kvm_x86_vendor_init()
      KVM: SVM: Check pmu->version, not enable_pmu, when getting PMC MSRs
      KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities
      KVM: x86: Rework KVM_REQ_MSR_FILTER_CHANGED into a generic RECALC_INTERCEPTS
      KVM: x86: Use KVM_REQ_RECALC_INTERCEPTS to react to CPUID updates
      KVM: x86/pmu: Move initialization of valid PMCs bitmask to common x86
      KVM: x86/pmu: Restrict GLOBAL_{CTRL,STATUS}, fixed PMCs, and PEBS to PMU v2+
      KVM: x86: Don't treat ENTER and LEAVE as branches, because they aren't

Thomas Huth (1):
      arch/x86/kvm/ioapic: Remove license boilerplate with bad FSF address

Xin Li (5):
      x86/cpufeatures: Add a CPU feature bit for MSR immediate form instructions
      KVM: x86: Rename handle_fastpath_set_msr_irqoff() to handle_fastpath_wrmsr()
      KVM: x86: Add support for RDMSR/WRMSRNS w/ immediate on Intel
      KVM: VMX: Support the immediate form of WRMSRNS in the VM-Exit fastpath
      KVM: x86: Advertise support for the immediate form of MSR instructions

Yang Weijiang (2):
      KVM: x86: Rename kvm_{g,s}et_msr()* to show that they emulate guest accesses
      KVM: x86: Add kvm_msr_{read,write}() helpers

Yury Norov (1):
      kvm: x86: simplify kvm_vector_to_index()

 Documentation/virt/kvm/api.rst                     |   6 +
 Documentation/virt/kvm/x86/hypercalls.rst          |   6 +-
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/kvm-x86-ops.h                 |   2 +-
 arch/x86/include/asm/kvm_host.h                    |  31 +-
 arch/x86/include/asm/msr-index.h                   |  16 +-
 arch/x86/include/uapi/asm/vmx.h                    |   6 +-
 arch/x86/kernel/cpu/scattered.c                    |   1 +
 arch/x86/kvm/cpuid.c                               |  13 +-
 arch/x86/kvm/emulate.c                             |  13 +-
 arch/x86/kvm/hyperv.c                              |  12 +-
 arch/x86/kvm/ioapic.c                              |  15 +-
 arch/x86/kvm/irq.c                                 |  57 ----
 arch/x86/kvm/irq.h                                 |   4 -
 arch/x86/kvm/kvm_emulate.h                         |   3 +-
 arch/x86/kvm/lapic.c                               | 169 ++++++++---
 arch/x86/kvm/lapic.h                               |  15 +-
 arch/x86/kvm/pmu.c                                 | 169 +++++++++--
 arch/x86/kvm/pmu.h                                 |  60 +---
 arch/x86/kvm/reverse_cpuid.h                       |   5 +
 arch/x86/kvm/smm.c                                 |   4 +-
 arch/x86/kvm/svm/pmu.c                             |   8 +-
 arch/x86/kvm/svm/svm.c                             |  30 +-
 arch/x86/kvm/vmx/capabilities.h                    |   3 -
 arch/x86/kvm/vmx/main.c                            |  14 +-
 arch/x86/kvm/vmx/nested.c                          |  29 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |  85 +++---
 arch/x86/kvm/vmx/tdx.c                             |   5 +
 arch/x86/kvm/vmx/vmx.c                             |  91 ++++--
 arch/x86/kvm/vmx/vmx.h                             |  13 +
 arch/x86/kvm/vmx/x86_ops.h                         |   2 +-
 arch/x86/kvm/x86.c                                 | 334 ++++++++++++---------
 arch/x86/kvm/x86.h                                 |   5 +-
 .../testing/selftests/kvm/x86/pmu_counters_test.c  |   8 +-
 34 files changed, 715 insertions(+), 520 deletions(-)

