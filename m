Return-Path: <kvm+bounces-58228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BE67B8B79C
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CE4064E1108
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D592A2D46A7;
	Fri, 19 Sep 2025 22:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Ez66AWW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B43925B301
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321186; cv=none; b=eViEXGZZ3pxBOZqHfNvkfvbSzzZ9aCTH+uR7t8f9xqzM7XQmWAxqYMnPw/lCZbZsHWGwCASRpyRyhgz2MQC0WGWYGRlnV0fiFUvFmZiiEPx/DKnQipljefHULKvi7FFXnft+ZQ61DcZjwS2fmUMuup9W809x+OrQvn3k8MBYW8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321186; c=relaxed/simple;
	bh=w8kgfu4lyXdn5caL4Uf3S+R9VKuh3njb2qUtXpMKMTc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=uqFZsbEVL0XI6YQEtBwg7i+wKWPyf8fQXRQJ0kHXRh6j/J3SGTFsdqK7ly0gSfp9wHmJL6d5rZOCwzTSP5EeAq6vUpQctf0dD/nlrKymT8XtW+kgQ3kTLam14X7SjSVnjQCIL1FE5kt9ryutqetsoJmI8eqqk2oHRNNs+1B45Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Ez66AWW; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b54df707c1cso1710908a12.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321182; x=1758925982; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n2Wxbmj6WtpVdg9IeVBp88BDS1Uc4o7vRWZ8LLGnYUw=;
        b=4Ez66AWWXQYxjSbbwnuiwV0Tf5kE0t7K+i+1BpW5Ff416ZJLds73oiSS743BqjOryo
         0h6CcLZ4yaiTgDOHsMnV8fMm5Rsnpwz6xCacM6TtL4jbvJ/LIatKUggRdd/luJBqlQC6
         yySkn5Hq2tU7/mAwZuKgsS9zuskSa5V7fjcWX1cPZ4eNJq8VWIAYbJBi1h86zfPtpnrY
         OZPtcdfR5yzACgHO/KM2GLYzychQKelkw8tCXlVDt3Cu7imSlx3o9rMCsl6yHX6Dz8U2
         Csuw6CU0LYl3Hj0ETxHqkpKPM0dhDWpPXBUE1WNljeWnS65g1wXPvV8XX66OM7P1Bthn
         naFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321182; x=1758925982;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n2Wxbmj6WtpVdg9IeVBp88BDS1Uc4o7vRWZ8LLGnYUw=;
        b=Kulxhc89TgGCBFUgkIlMKISy/LEzsE9kMsrgh+HtMRh1rtarM7Gm0dKR4zUzRrx0zU
         HvYpcH7EgiufY8TzaDXeVbNejHXLaN28PokZcbUO6icUDKS2UCxfJX7cQn4+WbZs6JiY
         ZJegRbubBy1Y5EkgjgFwMIeEVmDVcx8QfHMSsnZPPqIz5zyrPZFYYZT5ET6f4mU01nrO
         qltvTdAK635KEt8gTL6IphZZ110Jj5Hvl2eCzYU+xvBXKxWTLiDhV5fXyX5eBDWhlEHN
         GEmVZ9DKB4Ui6yFxsRd1WEh4MR3kHaPfBnrDPpC+n4AhBOfv3Nc/DEiaovtFPTgWmdKX
         F7zg==
X-Gm-Message-State: AOJu0Yxp4dbGzPdliGtg+xc/WicZLISvHLIsh/JI7adhocCOfCGL1d9h
	9nn8S4tpPpH4Md22YI5zsg/22l6b1VSYHIwifXXEFNdQ+o3BKXqEY7/EnWqT9q6RJBdu6Xetps5
	5w3jxhQ==
X-Google-Smtp-Source: AGHT+IE7dZqHWxgDihzhhf0nrFCTfPN5D2KY1zQcwkD2Mm+ZXXwkvi9pc1+rRyYowH4/XDv43yUOP6DV5AI=
X-Received: from pjbqn13.prod.google.com ([2002:a17:90b:3d4d:b0:31f:2a78:943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:939d:b0:243:be3f:9b9d
 with SMTP id adf61e73a8af0-292765c1f96mr7213475637.58.1758321182506; Fri, 19
 Sep 2025 15:33:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-1-seanjc@google.com>
Subject: [PATCH v16 00/51] KVM: x86: Super Mega CET
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

As the subject suggests, this series continues to grow, as there an absolutely
stupid number of edge cases and interactions.

There are (a lot) more changes between v15 and v16 than I was hoping for, but
there all fairly "minor" in the sense that it's things like disabling SHSTK
when using the shadow MMU.  I.e. it's mostly "configuration" fixes, and very
few logical changes (outside of msrs_test.c, which has non-trivial changes due
to ignore_msrs, argh).

So, my plan is to still land this in 6.18.  I'm going to push it to -next
today to get as much testing as possible, but in a dedicated branch so that I
can fixup as needed (e.g. even if it's just for reviews).  I'll freeze the
hashes sometime next week.

I probably missed some of the changes in the log below, sorry.

P.S. I have a pile of local changes to the CET KVM-Unit-Test, I'll post them
     sometime next week.

v16:
 - Collect more reviews.
 - Reject task switch emulation if IBT or SHSTK. [Binbin]
 - Improve various comments and fix typos. [Binbin]
 - Accept writes to XSS for SEV-ES guests even though that state is
   "protected", as KVM needs to update its internal tracking in response to
   guest changes. [John]
 - Drop @ghcb from KVM's accessors so that it's harder to screw up. [Tom]
 - s/KVM_X86_REG_ENCODE/KVM_X86_REG_ID. [Binbin]
 - Append "cc" to cpu_has_vmx_basic_no_hw_errcode(). [Binbin]
 - Use "KVM: SVM" for shortlogs. [Xin]
 - Disable SHSTK if TDP is disabled (affects AMD only because Intel was already
   disabling support indirectly thanks to Unrestricted Guest).
 - Disable IBT and SHSTK of allow_smaller_maxphyaddr is true (Intel only
   because it doesn't work on AMD with NPT).
 - Rework IBT instruction detection to realy on IsBranch and the operand source
   instead of having to manually inspect+tag each instruction.
 - Handle the annoying #GP case for SSP[63:32] != 0 when transitioning to
   compatibility mode so that FAR JMP doesn't need to be disallowed when
   SHSTK is enabled (I don't anyone would care, but special casing FAR JMP for
   a very solvable problem felt lazy).
 - Add a define for PFERR_SS_MASK and pretty print the missing PFERR (don't ask
   me how long it took to figure out why the SHSTK KUT testcase failed when
   I tried to run it with npt=0).
 - Advertise LOAD_CET_STATE fields for nVMX iff one of IBT or SHSTK is
   supported (being able to load non-existent CET state is all kinds of weird).
 - Explicitly check for SHSTK when translating MSR_KVM_INTERNAL_GUEST_SSP to
   avoid running afoul of ignore_msrs.
 - Add TSC_AUX to the 
 - Skip negative tests in msrs_tests when ignore_msrs is true (KVM's ABI, or
   rather lack thereof, is truly awful).
 - Remove an unnecessary round of vcpu_run() calls. [Chao]
 - Use ex_str() in a few more tests. [Chao]
 - Add XFEATURE_MASK_CET_ALL to simplify referencing KERNEL and USER, which
   KVM always does as a pair. [Binbin]

v15:
 - https://lore.kernel.org/all/20250912232319.429659-1-seanjc@google.com
 - Collect reviews (hopefully I got 'em all).
 - Add support for KVM_GET_REG_LIST.
 - Load FPU when accessing XSTATE MSRs via ONE_REG ioctls.
 - Explicitly return -EINVAL on kvm_set_one_msr() failure.
 - Make is_xstate_managed_msr() more precise (check guest caps).
 - Dedup guts of kvm_{g,s}et_xstate_msr() (as kvm_access_xstate_msr()).
 - WARN if KVM uses kvm_access_xstate_msr() to access an MSR that isn't
   managed via XSAVE.
 - Document why S_CET isn't treated as an XSTATE-managed MSR.
 - Mark VMCB_CET as clean/dirty as appropriate.
 - Add nSVM support for the CET VMCB fields.
 - Add an "msrs" selftest to coverage ONE_REG and host vs. guest accesses in
   general.
 - Add patches to READ_ONCE() guest-writable GHCB fields, and to check the
   validity of XCR0 "writes".
 - Check the validity of XSS "writes" via common MSR emulation.
 - Add {CP,HV,VC,SV}_VECTOR definitions so that tracing and selftests can
   pretty print them.
 - Add pretty printing for unexpected exceptions in selftests.
 - Tweak the emulator rejection to be more precise (grab S_CET vs. U_CET based
   CPL for near transfers), and to avoid unnecessary reads of CR4, S_CET, and
   U_CET.

Intel (v14): https://lkml.kernel.org/r/20250909093953.202028-1-chao.gao%40intel.com
AMD    (v4): https://lore.kernel.org/all/20250908201750.98824-1-john.allen@amd.com
grsec  (v3): https://lkml.kernel.org/r/20250813205957.14135-1-minipli%40grsecurity.net

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

Sean Christopherson (26):
  KVM: SEV: Rename kvm_ghcb_get_sw_exit_code() to
    kvm_get_cached_sw_exit_code()
  KVM: SEV: Read save fields from GHCB exactly once
  KVM: SEV: Validate XCR0 provided by guest in GHCB
  KVM: x86: Report XSS as to-be-saved if there are supported features
  KVM: x86: Load guest FPU state when access XSAVE-managed MSRs
  KVM: x86: Don't emulate instructions affected by CET features
  KVM: x86: Don't emulate task switches when IBT or SHSTK is enabled
  KVM: x86: Emulate SSP[63:32]!=0 #GP(0) for FAR JMP to 32-bit mode
  KVM: x86/mmu: WARN on attempt to check permissions for Shadow Stack
    #PF
  KVM: x86/mmu: Pretty print PK, SS, and SGX flags in MMU tracepoints
  KVM: nVMX: Always forward XSAVES/XRSTORS exits from L2 to L1
  KVM: x86: Disable support for Shadow Stacks if TDP is disabled
  KVM: x86: Disable support for IBT and SHSTK if
    allow_smaller_maxphyaddr is true
  KVM: VMX: Configure nested capabilities after CPU capabilities
  KVM: nSVM: Save/load CET Shadow Stack state to/from vmcb12/vmcb02
  KVM: SEV: Synchronize MSR_IA32_XSS from the GHCB when it's valid
  KVM: x86: Add human friendly formatting for #XM, and #VE
  KVM: x86: Define Control Protection Exception (#CP) vector
  KVM: x86: Define AMD's #HV, #VC, and #SX exception vectors
  KVM: selftests: Add ex_str() to print human friendly name of exception
    vectors
  KVM: selftests: Add an MSR test to exercise guest/host and read/write
  KVM: selftests: Add support for MSR_IA32_{S,U}_CET to MSRs test
  KVM: selftests: Extend MSRs test to validate vCPUs without supported
    features
  KVM: selftests: Add KVM_{G,S}ET_ONE_REG coverage to MSRs test
  KVM: selftests: Add coverate for KVM-defined registers in MSRs test
  KVM: selftests: Verify MSRs are (not) in save/restore list when
    (un)supported

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

 Documentation/virt/kvm/api.rst                |  14 +-
 arch/x86/include/asm/kvm_host.h               |   7 +-
 arch/x86/include/asm/vmx.h                    |   9 +
 arch/x86/include/uapi/asm/kvm.h               |  34 ++
 arch/x86/kvm/cpuid.c                          |  35 +-
 arch/x86/kvm/emulate.c                        | 149 +++++-
 arch/x86/kvm/kvm_cache_regs.h                 |   3 +-
 arch/x86/kvm/mmu.h                            |   2 +-
 arch/x86/kvm/mmu/mmutrace.h                   |   3 +
 arch/x86/kvm/smm.c                            |   8 +
 arch/x86/kvm/smm.h                            |   2 +-
 arch/x86/kvm/svm/nested.c                     |  20 +
 arch/x86/kvm/svm/sev.c                        |  37 +-
 arch/x86/kvm/svm/svm.c                        |  50 +-
 arch/x86/kvm/svm/svm.h                        |  29 +-
 arch/x86/kvm/trace.h                          |   5 +-
 arch/x86/kvm/vmx/capabilities.h               |   9 +
 arch/x86/kvm/vmx/nested.c                     | 185 ++++++-
 arch/x86/kvm/vmx/nested.h                     |   5 +
 arch/x86/kvm/vmx/vmcs12.c                     |   6 +
 arch/x86/kvm/vmx/vmcs12.h                     |  14 +-
 arch/x86/kvm/vmx/vmx.c                        |  93 +++-
 arch/x86/kvm/vmx/vmx.h                        |   9 +-
 arch/x86/kvm/x86.c                            | 413 ++++++++++++++-
 arch/x86/kvm/x86.h                            |  37 ++
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/processor.h     |   7 +
 .../testing/selftests/kvm/lib/x86/processor.c |  33 ++
 .../selftests/kvm/x86/hyperv_features.c       |  16 +-
 .../selftests/kvm/x86/monitor_mwait_test.c    |   8 +-
 tools/testing/selftests/kvm/x86/msrs_test.c   | 485 ++++++++++++++++++
 .../selftests/kvm/x86/pmu_counters_test.c     |   4 +-
 .../selftests/kvm/x86/vmx_pmu_caps_test.c     |   4 +-
 .../selftests/kvm/x86/xcr0_cpuid_test.c       |  12 +-
 34 files changed, 1624 insertions(+), 124 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/msrs_test.c


base-commit: fa8ba002a503ab724311c4cf9db58d50a33c4b5c
-- 
2.51.0.470.ga7dc726c21-goog


