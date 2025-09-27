Return-Path: <kvm+bounces-58922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B2FE4BA59BA
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 08:11:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D35A518867E8
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 06:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D885525A2CF;
	Sat, 27 Sep 2025 06:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QcDKkNq2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A42927EC99
	for <kvm@vger.kernel.org>; Sat, 27 Sep 2025 06:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758953372; cv=none; b=igjhLY+P2hDB/nOefPsnyeGqW9Zuc+5j1f+W8aBY6dONOrOgIV+5uKuW4ev7k66TMpwqtE/WRTyU2LeMbTXYPWAe2IRRH2e6EXN8lDRJ7v31GOqRmvWZmp1hHH9yptmZwM0yeSIWcydYKJlYTvCtEOStYN69nqk5jGLQUYZQ2oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758953372; c=relaxed/simple;
	bh=c4ubJQSSYgeU9Kl7T0F9wc/c8xxoYO2jOI5tAMDqxws=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LzUogsCdfScmANijLN6ZRy0tFplgQhQmSS4xRy3qb5JiUWH81QOhjAl5F6iB506FV7SG9gF4PtBjqzGjIzgYrsoOFlv4JAskhDaswnfiknWzcCzTMHIrRhaAsP9hIHYshqUOCOosPj5P5QoBWOOAUcyZ6zdzHoKlXjI7dul2C+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QcDKkNq2; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2e60221fso4062060b3a.0
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 23:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758953369; x=1759558169; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FbvK9quozLEAr8mK0iGe+53m+Z85kcaVzpmuLgTvGqY=;
        b=QcDKkNq2CsxdMrEunKIGPZnr9NL0ljvdUSVaiileMF18mL6LVJQQKstM9WFGw2IBkR
         aD/UObDkc7AXZif78+RHaraqVusY0rGcoFTYkACFbwjV7c7NJ+9/Q+gvNW40KdD4aIl4
         0tijQr1SwAg3t/5Oa9kNRznEW2k1HMnbb2poZHleA2fIhiSnDV7LiyuuV+78OeNywiDw
         IJMjf9xRH82JvsAiuDR7vofb2QCxtJBcyY2F2Ottswt9kuP29XII9Vo1QM2vCya2vvOo
         hsADwyZWIJ9Er2gnvk5gouuRPrPmSM4foR8amRBmxIj/LDRGJE1FrC8RXy2XbsY3QT1d
         4ftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758953369; x=1759558169;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FbvK9quozLEAr8mK0iGe+53m+Z85kcaVzpmuLgTvGqY=;
        b=w2PSdpFWxjXQRzOmQtEfVuth4/UEYxz3V9WabekFaXA4G6Ch7JWDbOzYC84TCcCVgd
         CjWY6wQUCaA7AS07tMABlk/eqq7bLdBfFyDXucIiipHlXxKE6JJY71OGwmHH5FqHWPLv
         8Q9WVxnDML0M3ENXK1TYeHfDx3FdEYBLFL6mBGako9RZWimoKpEFiDMV8E752wuJYjGr
         gKs5wfY2/tmmBH2ONu59kV+7Ykznvq6MF9Ct8+WwqjeefILeYgO55hgVj6nZcem8lgJd
         WWXYyEIN4oH1kp17iRPdOF8Q2/lgcsicXHnj8I7Yx6BqpglLAfqh4M3Bq+T9IFRuYckR
         0eOw==
X-Gm-Message-State: AOJu0Yw59avCvveoFE+4ckDNwnXBq8cVaAiz0yPf449tgAPiedKl0UeT
	QtFCt10ef2krlkL6Un8H/L/cnC8Y+6LeC8OluyBXzRzdTaD5kgRN2FVgYBkDmkfJ7dEEa9Rdfdf
	r0zEr5Q==
X-Google-Smtp-Source: AGHT+IFK5XT7UHSQrlxr7LQKm8w77hD8+KM4GncyTgmb2n30Ylg4IneXsazEWdIYddLlBi7cytSeQZeqe74=
X-Received: from pfhk7.prod.google.com ([2002:aa7:9987:0:b0:771:83fa:dfac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:240d:b0:77e:9ae8:c7d0
 with SMTP id d2e1a72fcca58-780fcdee2eemr10201867b3a.1.1758953369366; Fri, 26
 Sep 2025 23:09:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Sep 2025 23:09:09 -0700
In-Reply-To: <20250927060910.2933942-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250927060910.2933942-10-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: CET virtualization for 6.18
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

This one is a bit wonky.  It's based off the "misc" branch/request, includes
a merge of "selftests", and a merge of a slightly older version of "svm".
I generated the shortlog against the last merge commit and manually added
the two merge commits.  Hopefully it came out right?

This will also superficially conflict with the tip tree, which has PeterZ's
fastop purge.  The resolution is a simple "take the changes from each", but
it's the emulator instruction definitions, i.e. stupid hard to read, so just
a heads up: https://lore.kernel.org/all/aNEb7o3xrTDQ6JP4@finisterre.sirena.org.uk

As for the content, getting this ready was much more of a scramble than I was
planning/hoping, especially given that this has been a work in-progress since
forever.  However, most of the late churn was for "stupid" things like not
disabling SHSTK support on AMD when using shadow paging, i.e. stuff that needed
to be handled, but is completely unrelated to core CET virtualization.

So, I don't think letting this sit in -next for a full cycle will be a net
positive; somewhat similar to what happened with TDX, though on a smaller scale,
the scope and volume of changes and contributors was making it difficult to
manage the series.  If there are issues, I think we'll come out ahead by
applying fixes on top instead of trying to respin the full series or squash
fixups.

There are a pile of KVM-Unit-Test changes to validate a good chunk of this
(but we can definitely do better).  A good number of them are sitting on my
systems in a half-baked state, so it'll probably be a few weeks (or more)
before you see a KUT pull request.

The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9:

  Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-cet-6.18

for you to fetch changes up to d292035fb5d209b78beda356a2a9720154bd7c00:

  KVM: VMX: Make CR4.CET a guest owned bit (2025-09-23 10:03:09 -0700)

----------------------------------------------------------------
KVM x86 CET virtualization support for 6.18

Add support for virtualizing Control-flow Enforcement Technology (CET) on
Intel (Shadow Stacks and Indirect Branch Tracking) and AMD (Shadow Stacks).

CET is comprised of two distinct features, Shadow Stacks (SHSTK) and Indirect
Branch Tracking (IBT), that can be utilized by software to help provide
Control-flow integrity (CFI).  SHSTK defends against backward-edge attacks
(a.k.a. Return-oriented programming (ROP)), while IBT defends against
forward-edge attacks (a.k.a. similarly CALL/JMP-oriented programming (COP/JOP)).

Attackers commonly use ROP and COP/JOP methodologies to redirect the control-
flow to unauthorized targets in order to execute small snippets of code,
a.k.a. gadgets, of the attackers choice.  By chaining together several gadgets,
an attacker can perform arbitrary operations and circumvent the system's
defenses.

SHSTK defends against backward-edge attacks, which execute gadgets by modifying
the stack to branch to the attacker's target via RET, by providing a second
stack that is used exclusively to track control transfer operations.  The
shadow stack is separate from the data/normal stack, and can be enabled
independently in user and kernel mode.

When SHSTK is is enabled, CALL instructions push the return address on both the
data and shadow stack. RET then pops the return address from both stacks and
compares the addresses.  If the return addresses from the two stacks do not
match, the CPU generates a Control Protection (#CP) exception.

IBT defends against backward-edge attacks, which branch to gadgets by executing
indirect CALL and JMP instructions with attacker controlled register or memory
state, by requiring the target of indirect branches to start with a special
marker instruction, ENDBRANCH.  If an indirect branch is executed and the next
instruction is not an ENDBRANCH, the CPU generates a #CP.  Note, ENDBRANCH
behaves as a NOP if IBT is disabled or unsupported.

From a virtualization perspective, CET presents several problems.  While SHSTK
and IBT have two layers of enabling, a global control in the form of a CR4 bit,
and a per-feature control in user and kernel (supervisor) MSRs (U_CET and S_CET
respectively), the {S,U}_CET MSRs can be context switched via XSAVES/XRSTORS.
Practically speaking, intercepting and emulating XSAVES/XRSTORS is not a viable
option due to complexity, and outright disallowing use of XSTATE to context
switch SHSTK/IBT state would render the features unusable to most guests.

To limit the overall complexity without sacrificing performance or usability,
simply ignore the potential virtualization hole, but ensure that all paths in
KVM treat SHSTK/IBT as usable by the guest if the feature is supported in
hardware, and the guest has access to at least one of SHSTK or IBT.  I.e. allow
userspace to advertise one of SHSTK or IBT if both are supported in hardware,
even though doing so would allow a misbehaving guest to use the unadvertised
feature.

Fully emulating SHSTK and IBT would also require significant complexity, e.g.
to track and update branch state for IBT, and shadow stack state for SHSTK.
Given that emulating large swaths of the guest code stream isn't necessary on
modern CPUs, punt on emulating instructions that meaningful impact or consume
SHSTK or IBT.  However, instead of doing nothing, explicitly reject emulation
of such instructions so that KVM's emulator can't be abused to circumvent CET.
Disable support for SHSTK and IBT if KVM is configured such that emulation of
arbitrary guest instructions may be required, specifically if Unrestricted
Guest (Intel only) is disabled, or if KVM will emulate a guest.MAXPHYADDR that
is smaller than host.MAXPHYADDR.

Lastly disable SHSTK support if shadow paging is enabled, as the protections
for the shadow stack are novel (shadow stacks require Writable=0,Dirty=1, so
that they can't be directly modified by software), i.e. would require
non-trivial support in the Shadow MMU.

Note, AMD CPUs currently only support SHSTK.  Explicitly disable IBT support
so that KVM doesn't over-advertise if AMD CPUs add IBT, and virtualizing IBT
in SVM requires KVM modifications.


----------------------------------------------------------------
Chao Gao (4):
      KVM: x86: Check XSS validity against guest CPUIDs
      KVM: nVMX: Add consistency checks for CR0.WP and CR4.CET
      KVM: nVMX: Add consistency checks for CET states
      KVM: nVMX: Advertise new VM-Entry/Exit control bits for CET state

John Allen (4):
      KVM: SVM: Emulate reads and writes to shadow stack MSRs
      KVM: SVM: Update dump_vmcb with shadow stack save area additions
      KVM: SVM: Pass through shadow stack MSRs as appropriate
      KVM: SVM: Enable shadow stack virtualization for SVM

Mathias Krause (1):
      KVM: VMX: Make CR4.CET a guest owned bit

Sean Christopherson (25):
      KVM: x86: Merge 'svm' into 'cet' to pick up GHCB dependencies
      KVM: x86: Merge 'selftests' into 'cet' to pick up ex_str()
      KVM: x86: Report XSS as to-be-saved if there are supported features
      KVM: x86: Load guest FPU state when access XSAVE-managed MSRs
      KVM: x86: Don't emulate instructions affected by CET features
      KVM: x86: Don't emulate task switches when IBT or SHSTK is enabled
      KVM: x86: Emulate SSP[63:32]!=0 #GP(0) for FAR JMP to 32-bit mode
      KVM: x86/mmu: WARN on attempt to check permissions for Shadow Stack #PF
      KVM: x86/mmu: Pretty print PK, SS, and SGX flags in MMU tracepoints
      KVM: nVMX: Always forward XSAVES/XRSTORS exits from L2 to L1
      KVM: x86: Disable support for Shadow Stacks if TDP is disabled
      KVM: x86: Initialize allow_smaller_maxphyaddr earlier in setup
      KVM: x86: Disable support for IBT and SHSTK if allow_smaller_maxphyaddr is true
      KVM: VMX: Configure nested capabilities after CPU capabilities
      KVM: nSVM: Save/load CET Shadow Stack state to/from vmcb12/vmcb02
      KVM: SEV: Synchronize MSR_IA32_XSS from the GHCB when it's valid
      KVM: x86: Add human friendly formatting for #XM, and #VE
      KVM: x86: Define Control Protection Exception (#CP) vector
      KVM: x86: Define AMD's #HV, #VC, and #SX exception vectors
      KVM: selftests: Add an MSR test to exercise guest/host and read/write
      KVM: selftests: Add support for MSR_IA32_{S,U}_CET to MSRs test
      KVM: selftests: Extend MSRs test to validate vCPUs without supported features
      KVM: selftests: Add KVM_{G,S}ET_ONE_REG coverage to MSRs test
      KVM: selftests: Add coverage for KVM-defined registers in MSRs test
      KVM: selftests: Verify MSRs are (not) in save/restore list when (un)supported

Yang Weijiang (16):
      KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
      KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
      KVM: x86: Initialize kvm_caps.supported_xss
      KVM: x86: Add fault checks for guest CR4.CET setting
      KVM: x86: Report KVM supported CET MSRs as to-be-saved
      KVM: VMX: Introduce CET VMCS fields and control bits
      KVM: x86: Enable guest SSP read/write interface with new uAPIs
      KVM: VMX: Emulate read and write to CET MSRs
      KVM: x86: Save and reload SSP to/from SMRAM
      KVM: VMX: Set up interception for CET MSRs
      KVM: VMX: Set host constant supervisor states to VMCS fields
      KVM: x86: Allow setting CR4.CET if IBT or SHSTK is supported
      KVM: x86: Add XSS support for CET_KERNEL and CET_USER
      KVM: x86: Enable CET virtualization for VMX and advertise to userspace
      KVM: nVMX: Virtualize NO_HW_ERROR_CODE_CC for L1 event injection to L2
      KVM: nVMX: Prepare for enabling CET support for nested guest

 Documentation/virt/kvm/api.rst                      |  14 +++-
 arch/x86/include/asm/kvm_host.h                     |   6 +-
 arch/x86/include/asm/vmx.h                          |   9 +++
 arch/x86/include/uapi/asm/kvm.h                     |  34 ++++++++
 arch/x86/kvm/cpuid.c                                |  35 ++++++++-
 arch/x86/kvm/emulate.c                              | 150 ++++++++++++++++++++++++++++++++---
 arch/x86/kvm/kvm_cache_regs.h                       |   3 +-
 arch/x86/kvm/mmu.h                                  |   2 +-
 arch/x86/kvm/mmu/mmutrace.h                         |   3 +
 arch/x86/kvm/smm.c                                  |   8 ++
 arch/x86/kvm/smm.h                                  |   2 +-
 arch/x86/kvm/svm/nested.c                           |  20 +++++
 arch/x86/kvm/svm/sev.c                              |   3 +
 arch/x86/kvm/svm/svm.c                              |  80 ++++++++++++++-----
 arch/x86/kvm/svm/svm.h                              |   4 +-
 arch/x86/kvm/trace.h                                |   5 +-
 arch/x86/kvm/vmx/capabilities.h                     |   9 +++
 arch/x86/kvm/vmx/nested.c                           | 186 +++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/nested.h                           |   5 ++
 arch/x86/kvm/vmx/vmcs12.c                           |   6 ++
 arch/x86/kvm/vmx/vmcs12.h                           |  14 +++-
 arch/x86/kvm/vmx/vmx.c                              | 109 ++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h                              |   9 ++-
 arch/x86/kvm/x86.c                                  | 410 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/x86.h                                  |  37 +++++++++
 tools/testing/selftests/kvm/Makefile.kvm            |   1 +
 tools/testing/selftests/kvm/include/x86/processor.h |   5 ++
 tools/testing/selftests/kvm/x86/msrs_test.c         | 489 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 28 files changed, 1563 insertions(+), 95 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/msrs_test.c

