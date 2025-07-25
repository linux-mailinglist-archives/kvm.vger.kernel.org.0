Return-Path: <kvm+bounces-53484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C72BEB12678
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:08:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0418173870
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 346362620D3;
	Fri, 25 Jul 2025 22:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IMKilnMO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83C02571B6
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481248; cv=none; b=pbadxh0yVH3kkVyQmG2WS1NF+T8p0iItgvfwkX9vEogT3KyvOq2gf97xUDFB2KzSURodw+83/Y4y2fXkra719Zji8KnBJMGwodykxm46pxT+D9jxEiGM87a9l/wdRgZ3QuLUgP2IWu1zPKBPoXvyT27P+9sPxMjDoWlP8ii+u38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481248; c=relaxed/simple;
	bh=1AoFK3JJiomM1GrABo3jFmBT6IZokD5oQaopJO0Npnk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Don55chzmue596hnbEX8ydfeJBedjp7yk0H1Dg0y7cwtGewbPJwxnUyfWjoAxY0s6yj3ogcmzK5ZgRlIyXvVzv0WjyGELUdX7W4Dm5HT0awmU7QvstofFAtbG0a+9vHBgikTsZ2rOFXgPsjJmMfZHZngH11uRXG72NXWw6r8Mzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IMKilnMO; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2363bb41664so22619215ad.0
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753481245; x=1754086045; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IrItbUVtQo5DvZScbJW6MAP2AhEOoh7p12agMFyFdHs=;
        b=IMKilnMODr5eivtdmJd/K2sP7n7sXw/rsyhS6SVCqlAAQhPtE0x6xGdFksxpXObofW
         koIdz0i4OyR5j7cFg4fNTZRWpm8BHmGxBRq5y8j0cDDt7Do7gsl75E214PvvOZx6Nqgw
         fKhtwybihSFblo9FuHIv9f0zbMM2ErEkmFsxDAsbHrlraUXnTSjMjFRO2HSzt03qQ4GB
         1eHcty5/TqkWshGqCpFjvtzSr3okeNV8/kRYIkG+aw/GqY0ACY0Pq/WV/1aRq7Y6stXm
         aGZrG7IpYx3i+7X/XeyCdG2ogil7G8qTJqk7TiHZ+Xq/GuHrC5TJx8pAEKRTqUmJiSk3
         aBBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753481245; x=1754086045;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IrItbUVtQo5DvZScbJW6MAP2AhEOoh7p12agMFyFdHs=;
        b=W0yyQVPAfagZwSL6KRnVsuZ2okQgG8XM17K8cwkAIC1rI7PF12IndwmzZcOi0gY+lT
         Z6zCB1xt2N926BjNQqRUleEQPv0oDSyLyVHK5JHVObzo5AtwiZ5R1aePv/ITEtO6Lj7R
         nz+vrVSyP4QmIKbv+s94ptrn84b2oFB1SfIamWzXEcsQ2pAItML0f6nJ7WpiEsSGL45y
         +bE22qxu3yUVXHKpAPWh74pQBfVZA1Zc6IlHS9PtCG9ZgxuUYy43VkVxTZ4Y1azswE+v
         Gj8T9cfi07h00sNW/hXmvf1q/B0Il+ndISTB7phiQk19FMcZlGSM0tuUnneZ+k1OEI5Z
         y5/A==
X-Gm-Message-State: AOJu0YynVHSeIDfba6SA5JIGY+5YTOndYkNO0Gui8lsSjKpqBX5NfqjZ
	jx0IE+w9a92SqRNTiCkOd/L811H+Q1apfeqofLfy7LBZ+zZH2BY1dA/Y2QM2u4/6Bx79DcZ+XOd
	d2obAzQ==
X-Google-Smtp-Source: AGHT+IH+k5b68uh6fXP4eFIO65pV/Fg8xYtozotz8wKAwZccfgxrTG1Y0GZx8MvJx/RhEEy7W37MKnJ5bxM=
X-Received: from pjbsi8.prod.google.com ([2002:a17:90b:5288:b0:311:4aa8:2179])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e887:b0:237:f757:9ad8
 with SMTP id d9443c01a7336-23fa5cd3ac5mr109016925ad.1.1753481245261; Fri, 25
 Jul 2025 15:07:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Jul 2025 15:07:05 -0700
In-Reply-To: <20250725220713.264711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250725220713.264711-6-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The highlights are the DEBUGCTL.FREEZE_IN_SMM fix from Maxim, Jim's APERF/MPERF
support that has probably made him question the meaning of life, and a big
cleanup of the MSR interception code to ease the pain of adding support for
CET, FRED, and the mediated PMU (and any other features that deal with MSRs).

But the one change that I really want your eyeballs on is that last commit,
"Reject KVM_SET_TSC_KHZ VM ioctl when vCPUs have been created"; it's an ABI
change that could break userspace.  AFAICT, it won't affect any (known)
userspace, and restricting the ioctl for all VM types is much simpler than
special casing "secure" TSC guests.  Holler if you want a new tag/pull request
without that change; I deliberately kept it dead last specifically so it could
be omitted without any fuss.

The following changes since commit 28224ef02b56fceee2c161fe2a49a0bb197e44f5:

  KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities (2025-06-20 14:20:20 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.17

for you to fetch changes up to dcbe5a466c123a475bb66492749549f09b5cab00:

  KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPUs have been created (2025-07-14 15:29:33 -0700)

----------------------------------------------------------------
KVM x86 misc changes for 6.17

 - Prevert the host's DEBUGCTL.FREEZE_IN_SMM (Intel only) when running the
   guest.  Failure to honor FREEZE_IN_SMM can bleed host state into the guest.

 - Explicitly check vmcs12.GUEST_DEBUGCTL on nested VM-Enter (Intel only) to
   prevent L1 from running L2 with features that KVM doesn't support, e.g. BTF.

 - Intercept SPEC_CTRL on AMD if the MSR shouldn't exist according to the
   vCPU's CPUID model.

 - Rework the MSR interception code so that the SVM and VMX APIs are more or
   less identical.

 - Recalculate all MSR intercepts from the "source" on MSR filter changes, and
   drop the dedicated "shadow" bitmaps (and their awful "max" size defines).

 - WARN and reject loading kvm-amd.ko instead of panicking the kernel if the
   nested SVM MSRPM offsets tracker can't handle an MSR.

 - Advertise support for LKGS (Load Kernel GS base), a new instruction that's
   loosely related to FRED, but is supported and enumerated independently.

 - Fix a user-triggerable WARN that syzkaller found by stuffing INIT_RECEIVED,
   a.k.a. WFS, and then putting the vCPU into VMX Root Mode (post-VMXON).  Use
   the same approach KVM uses for dealing with "impossible" emulation when
   running a !URG guest, and simply wait until KVM_RUN to detect that the vCPU
   has architecturally impossible state.

 - Add KVM_X86_DISABLE_EXITS_APERFMPERF to allow disabling interception of
   APERF/MPERF reads, so that a "properly" configured VM can "virtualize"
   APERF/MPERF (with many caveats).

 - Reject KVM_SET_TSC_KHZ if vCPUs have been created, as changing the "default"
   frequency is unsupported for VMs with a "secure" TSC, and there's no known
   use case for changing the default frequency for other VM types.

----------------------------------------------------------------
Chao Gao (2):
      KVM: x86: Deduplicate MSR interception enabling and disabling
      KVM: SVM: Simplify MSR interception logic for IA32_XSS MSR

Jim Mattson (3):
      KVM: x86: Replace growing set of *_in_guest bools with a u64
      KVM: x86: Provide a capability to disable APERF/MPERF read intercepts
      KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF

Kai Huang (1):
      KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPUs have been created

Maxim Levitsky (3):
      KVM: nVMX: Check vmcs12->guest_ia32_debugctl on nested VM-Enter
      KVM: VMX: Wrap all accesses to IA32_DEBUGCTL with getter/setter APIs
      KVM: VMX: Preserve host's DEBUGCTLMSR_FREEZE_IN_SMM while running the guest

Sean Christopherson (44):
      KVM: TDX: Use kvm_arch_vcpu.host_debugctl to restore the host's DEBUGCTL
      KVM: x86: Convert vcpu_run()'s immediate exit param into a generic bitmap
      KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of a new KVM_RUN flag
      KVM: VMX: Allow guest to set DEBUGCTL.RTM_DEBUG if RTM is supported
      KVM: VMX: Extract checking of guest's DEBUGCTL into helper
      KVM: SVM: Disable interception of SPEC_CTRL iff the MSR exists for the guest
      KVM: SVM: Allocate IOPM pages after initial setup in svm_hardware_setup()
      KVM: SVM: Don't BUG if setting up the MSR intercept bitmaps fails
      KVM: SVM: Tag MSR bitmap initialization helpers with __init
      KVM: SVM: Use ARRAY_SIZE() to iterate over direct_access_msrs
      KVM: SVM: Kill the VM instead of the host if MSR interception is buggy
      KVM: x86: Use non-atomic bit ops to manipulate "shadow" MSR intercepts
      KVM: SVM: Massage name and param of helper that merges vmcb01 and vmcb12 MSRPMs
      KVM: SVM: Clean up macros related to architectural MSRPM definitions
      KVM: nSVM: Use dedicated array of MSRPM offsets to merge L0 and L1 bitmaps
      KVM: nSVM: Omit SEV-ES specific passthrough MSRs from L0+L1 bitmap merge
      KVM: nSVM: Don't initialize vmcb02 MSRPM with vmcb01's "always passthrough"
      KVM: SVM: Add helpers for accessing MSR bitmap that don't rely on offsets
      KVM: SVM: Implement and adopt VMX style MSR intercepts APIs
      KVM: SVM: Pass through GHCB MSR if and only if VM is an SEV-ES guest
      KVM: SVM: Drop "always" flag from list of possible passthrough MSRs
      KVM: x86: Move definition of X2APIC_MSR() to lapic.h
      KVM: VMX: Manually recalc all MSR intercepts on userspace MSR filter change
      KVM: SVM: Manually recalc all MSR intercepts on userspace MSR filter change
      KVM: x86: Rename msr_filter_changed() => recalc_msr_intercepts()
      KVM: SVM: Rename init_vmcb_after_set_cpuid() to make it intercepts specific
      KVM: SVM: Fold svm_vcpu_init_msrpm() into its sole caller
      KVM: SVM: Merge "after set CPUID" intercept recalc helpers
      KVM: SVM: Drop explicit check on MSRPM offset when emulating SEV-ES accesses
      KVM: SVM: Move svm_msrpm_offset() to nested.c
      KVM: SVM: Store MSRPM pointer as "void *" instead of "u32 *"
      KVM: nSVM: Access MSRPM in 4-byte chunks only for merging L0 and L1 bitmaps
      KVM: SVM: Return -EINVAL instead of MSR_INVALID to signal out-of-range MSR
      KVM: nSVM: Merge MSRPM in 64-bit chunks on 64-bit kernels
      KVM: SVM: Add a helper to allocate and initialize permissions bitmaps
      KVM: x86: Simplify userspace filter logic when disabling MSR interception
      KVM: selftests: Verify KVM disable interception (for userspace) on filter change
      KVM: x86: Drop pending_smi vs. INIT_RECEIVED check when setting MP_STATE
      KVM: x86: WARN and reject KVM_RUN if vCPU's MP_STATE is SIPI_RECEIVED
      KVM: x86: Move INIT_RECEIVED vs. INIT/SIPI blocked check to KVM_RUN
      KVM: x86: Refactor handling of SIPI_RECEIVED when setting MP_STATE
      KVM: VMX: Add a macro to track which DEBUGCTL bits are host-owned
      KVM: selftests: Expand set of APIs for pinning tasks to a single CPU
      KVM: selftests: Convert arch_timer tests to common helpers to pin task

Xin Li (1):
      KVM: x86: Advertise support for LKGS

 Documentation/virt/kvm/api.rst                     |  25 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   3 +-
 arch/x86/include/asm/kvm_host.h                    |  22 +-
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/kvm/cpuid.c                               |   1 +
 arch/x86/kvm/lapic.h                               |   2 +
 arch/x86/kvm/svm/nested.c                          | 128 ++++--
 arch/x86/kvm/svm/sev.c                             |  33 +-
 arch/x86/kvm/svm/svm.c                             | 500 +++++++--------------
 arch/x86/kvm/svm/svm.h                             | 104 ++++-
 arch/x86/kvm/vmx/common.h                          |   2 -
 arch/x86/kvm/vmx/main.c                            |  23 +-
 arch/x86/kvm/vmx/nested.c                          |  27 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   8 +-
 arch/x86/kvm/vmx/tdx.c                             |  24 +-
 arch/x86/kvm/vmx/vmx.c                             | 284 ++++--------
 arch/x86/kvm/vmx/vmx.h                             |  61 ++-
 arch/x86/kvm/vmx/x86_ops.h                         |   6 +-
 arch/x86/kvm/x86.c                                 | 106 +++--
 arch/x86/kvm/x86.h                                 |  18 +-
 include/uapi/linux/kvm.h                           |   1 +
 tools/include/uapi/linux/kvm.h                     |   1 +
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/arch_timer.c           |   7 +-
 .../selftests/kvm/arm64/arch_timer_edge_cases.c    |  23 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |  31 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  15 +-
 tools/testing/selftests/kvm/lib/memstress.c        |   2 +-
 tools/testing/selftests/kvm/x86/aperfmperf_test.c  | 213 +++++++++
 .../selftests/kvm/x86/userspace_msr_exit_test.c    |   8 +
 30 files changed, 930 insertions(+), 750 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/aperfmperf_test.c

