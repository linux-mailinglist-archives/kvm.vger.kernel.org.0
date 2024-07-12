Return-Path: <kvm+bounces-21582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ADCB93028C
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 01:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBFEC282F58
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 23:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57882132134;
	Fri, 12 Jul 2024 23:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EZiOg1Ld"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACDB136E38
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 23:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720828632; cv=none; b=R8+l8ubZmQbkQ2uSxkXFvFs1Ks3e5jnFhmGHj8KWC0R3C3ATUHkCbK0prK1jsSHHzdPzm75/eFhK9XK9O9e6VD9czhWadkI2dpffyPjduML+IbWNUSJdjBl1eTf87J64jA8Y2doI5rA6dtMliiwPVlTQlEep3K42CQ41BbWJXtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720828632; c=relaxed/simple;
	bh=EC2XbtPRhEZcIzirD/sSdcyfYegpCfcKVgFnHi3sueE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LUfUOtF+aO8qt7uNLAGkjshBvdO0lXOopouO39o7zbdC+kLSLAVDEKXOfVEEmy3D75d72S2IvfppNHCW6AXb9ox30Ok8LjEzGUWm6bbNl00IW3I8tUgGV2YmHYlGhlmlwa26cDAxOLjAf7SS5LNpFbf9SdtrWvWyxkt5H8Jo4fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EZiOg1Ld; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02fff66a83so4557757276.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 16:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720828630; x=1721433430; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OaZneo+HEIw51VcJ4/Lr6F+kdWHy1synO7AGtB5rQE0=;
        b=EZiOg1Ld0XzK15nZTay2tdUs8hG6NOWaGRKh1wuIX2JfOneelyZ5IZjWZMDXXK2NjA
         e1O6LwFk93h2FOjX5rrxDf1KPFcDk5RNivikjvnxHBIk1Tz9OElo+xm5x4RKra+twlTM
         tg1TqGN4sypIE7ilQuvtywuobif46riJiZJNZfu5mibeLTdc4MLEdHrbjnGQlNGJdk63
         AsmqSDauy+CEJn/A1NE11PPK0qlmkSgt+9Uf/EvB7Agg/TmB3rLmQa54ULQ+xVqz6rCB
         C9OGpqbNNBxiLw03VGxcHqf9IedF5FNaaPsoW602VoGIA/oNwSFHjy4MovcqgTxI0izK
         YAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720828630; x=1721433430;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OaZneo+HEIw51VcJ4/Lr6F+kdWHy1synO7AGtB5rQE0=;
        b=puOjtxZeP4Vsxuqmw/TDNAD5hs4AZhsBTwA9bl3mFABnk9V8/a7RzAB3xEBfpm00J2
         OH3weki4GhkEabaaBDAlS0KDVsXjEfWoV/LrItlup5niyM/VUQh1b/w3IywQVqN1Bw3l
         ZDQFe6tU+cJMUqRg6oMPHeOAI1iJC37Ee4m02BdrKx+PaoPZzdxE/clEl0nDAsjA5+Pp
         TscP4BuAqK5iNalPfMDXUiN0zBvtkpMvPMaaNDJ6zCXdi+wZmwk2SPnBMhFsyF5Zk7UQ
         DjwwBGLEZEj2JUVO5hMWMNPYN1GnUVqHibFPyC/5W+nusZKd4NXsLGDz3UTNzFmzrF4t
         aatA==
X-Gm-Message-State: AOJu0Yy2vo7KgbkDhqcHrZlc56B87bGbuHg7xuSR1uYCmViFLhH8AqUe
	TmSyMl9d37fuuyKWiHyN6ungNZeUTttctd6+CtpOu4KYcO/Bnr8pOOCuTc3h3pVCe3lkCdnSvXN
	Tvg==
X-Google-Smtp-Source: AGHT+IEHMwtzk2eLw9cTwak/XJk9llNIq9/Qj8wuhzrWJvGikI3n898DLwpakDTRiAUifGUhKLsZUYQoozo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1206:b0:e03:59e2:e82 with SMTP id
 3f1490d57ef6-e041b134afbmr22126276.10.1720828629895; Fri, 12 Jul 2024
 16:57:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jul 2024 16:56:53 -0700
In-Reply-To: <20240712235701.1458888-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712235701.1458888-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240712235701.1458888-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.11
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The most notable change is the addition of the capability to allow changing
KVM's emulated APIC bus frequency for TDX.  Most everything else is cleanup=
s.

The following changes since commit c3f38fa61af77b49866b006939479069cd451173=
:

  Linux 6.10-rc2 (2024-06-02 15:44:56 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.11

for you to fetch changes up to 82222ee7e84cb03158935e053c4c4960ac1debbd:

  KVM: selftests: Add test for configure of x86 APIC bus frequency (2024-06=
-28 15:21:43 -0700)

----------------------------------------------------------------
KVM x86 misc changes for 6.11

 - Add a global struct to consolidate tracking of host values, e.g. EFER, a=
nd
   move "shadow_phys_bits" into the structure as "maxphyaddr".

 - Add KVM_CAP_X86_APIC_BUS_CYCLES_NS to allow configuring the effective AP=
IC
   bus frequency, because TDX.

 - Print the name of the APICv/AVIC inhibits in the relevant tracepoint.

 - Clean up KVM's handling of vendor specific emulation to consistently act=
 on
   "compatible with Intel/AMD", versus checking for a specific vendor.

 - Misc cleanups

----------------------------------------------------------------
Alejandro Jimenez (2):
      KVM: x86: Print names of apicv inhibit reasons in traces
      KVM: x86: Keep consistent naming for APICv/AVIC inhibit reasons

Binbin Wu (1):
      KVM: VMX: Remove unused declaration of vmx_request_immediate_exit()

Carlos L=C3=B3pez (1):
      KVM: x86: Improve documentation for KVM_CAP_X86_BUS_LOCK_EXIT

Hou Wenlong (1):
      KVM: x86: Drop unused check_apicv_inhibit_reasons() callback definiti=
on

Isaku Yamahata (4):
      KVM: x86: hyper-v: Calculate APIC bus frequency for Hyper-V
      KVM: x86: Make nanoseconds per APIC bus cycle a VM variable
      KVM: x86: Add a capability to configure bus frequency for APIC timer
      KVM: selftests: Add test for configure of x86 APIC bus frequency

Jeff Johnson (1):
      KVM: x86: Add missing MODULE_DESCRIPTION() macros

Peng Hao (1):
      KVM: X86: Remove unnecessary GFP_KERNEL_ACCOUNT for temporary variabl=
es

Reinette Chatre (1):
      KVM: selftests: Add guest udelay() utility for x86

Sean Christopherson (12):
      KVM: x86: Add a struct to consolidate host values, e.g. EFER, XCR0, e=
tc...
      KVM: SVM: Use KVM's snapshot of the host's XCR0 for SEV-ES host state
      KVM: x86/mmu: Snapshot shadow_phys_bits when kvm.ko is loaded
      KVM: x86: Move shadow_phys_bits into "kvm_host", as "maxphyaddr"
      KVM: x86/pmu: Squash period for checkpointed events based on host HLE=
/RTM
      KVM: x86: Apply Intel's TSC_AUX reserved-bit behavior to Intel compat=
 vCPUs
      KVM: x86: Inhibit code #DBs in MOV-SS shadow for all Intel compat vCP=
Us
      KVM: x86: Use "is Intel compatible" helper to emulate SYSCALL in !64-=
bit
      KVM: SVM: Emulate SYSENTER RIP/RSP behavior for all Intel compat vCPU=
s
      KVM: x86: Allow SYSENTER in Compatibility Mode for all Intel compat v=
CPUs
      KVM: x86: Open code vendor_intel() in string_registers_quirk()
      KVM: x86: Bury guest_cpuid_is_amd_or_hygon() in cpuid.c

Thomas Prescher (1):
      KVM: x86: Add KVM_RUN_X86_GUEST_MODE kvm_run flag

 Documentation/virt/kvm/api.rst                     |  78 ++++++---
 arch/x86/include/asm/kvm_host.h                    |  24 ++-
 arch/x86/include/uapi/asm/kvm.h                    |   1 +
 arch/x86/kvm/cpuid.c                               |  12 ++
 arch/x86/kvm/cpuid.h                               |  18 --
 arch/x86/kvm/emulate.c                             |  71 +++-----
 arch/x86/kvm/hyperv.c                              |   3 +-
 arch/x86/kvm/kvm_emulate.h                         |   1 +
 arch/x86/kvm/lapic.c                               |   6 +-
 arch/x86/kvm/lapic.h                               |   3 +-
 arch/x86/kvm/mmu.h                                 |  27 +--
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 arch/x86/kvm/mmu/spte.c                            |  26 ++-
 arch/x86/kvm/pmu.c                                 |   2 +-
 arch/x86/kvm/svm/sev.c                             |   4 +-
 arch/x86/kvm/svm/svm.c                             |  15 +-
 arch/x86/kvm/svm/svm.h                             |   2 +-
 arch/x86/kvm/trace.h                               |   9 +-
 arch/x86/kvm/vmx/main.c                            |   2 +-
 arch/x86/kvm/vmx/nested.c                          |   8 +-
 arch/x86/kvm/vmx/vmx.c                             |  29 ++-
 arch/x86/kvm/vmx/vmx.h                             |   2 +-
 arch/x86/kvm/vmx/x86_ops.h                         |   2 -
 arch/x86/kvm/x86.c                                 | 112 +++++++-----
 arch/x86/kvm/x86.h                                 |  19 +-
 include/uapi/linux/kvm.h                           |   2 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 tools/testing/selftests/kvm/include/x86_64/apic.h  |   8 +
 .../selftests/kvm/include/x86_64/processor.h       |  18 ++
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  11 ++
 .../selftests/kvm/x86_64/apic_bus_clock_test.c     | 194 +++++++++++++++++=
++++
 31 files changed, 503 insertions(+), 209 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.=
c

