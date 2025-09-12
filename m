Return-Path: <kvm+bounces-57443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B019B559F9
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:23:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 549937BC015
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CDBC28469E;
	Fri, 12 Sep 2025 23:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dzpi781M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA4027F73A
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719407; cv=none; b=mMbp5EdPD7Egvhs9iankL4VE7ZGgZhUSCfcf67IzWiKux/mq9e4xF+9ioTiXsDyuj5l4FJUqQAoMQI2dFPW+xlbDGjcLFNIceopwDC16+wNn5gg/gpKmbJDjMyhSx4LGaJKlk+RQpiW8oFMnCLxl1xBHA9iAU5Ra2cBwFnTkJCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719407; c=relaxed/simple;
	bh=14Rc4mUmRilr9Ego6yqIcU+/4YK/OwLFOoZZkRgN3Sw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IbDht+hbklpp9w+lsPp5q9rmUHn/xRB5SKamSVhJKEbq30sK9RY+byVXgLrxlmpoMvliZKG5tSdqaFMBwhGN5Is72NzAYKLz/0hC0Nic+KwBmq0zInsFjQzbSrCydeGzGOsrcGFZuIm6HlLgLyTO0b1QXX1asTAa6wwT2X6LTUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dzpi781M; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77260b29516so4706976b3a.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719405; x=1758324205; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kubXxZpXHDaOpO9GizDKWhMEt5cYzJPmZ1HT1Xnw+ZU=;
        b=Dzpi781MprY0gtjirDtSxHNRsx/dm9Qzqlctbop1AfQEMWSmyAedb1vxRebmVEveyb
         tvH0VlinOUqscNV8Z28SmFRRSbW28fVfCOXkSeXdTyj+CDb/ywmXbJmonFpWMmA65+BW
         P6rXK0Dct5sGtPHgFO81dIElqceJkZQPy+pRoXDylIUaLj+EkXKghsxGA5zRodeAz5Du
         J/PpzWmShswnk58wvVrWH6i/hCr05degrW+N9gbwxJu+8c3MJNVw3aW4p7n+IMtLjtfl
         XBzccvFusmprNtNi27fCBFdnfrwCTIXY36clhT2FEg+AJHJQxClOtC9JZBbkja06f2Bf
         0hhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719405; x=1758324205;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kubXxZpXHDaOpO9GizDKWhMEt5cYzJPmZ1HT1Xnw+ZU=;
        b=F+RwLUAk+4sXRKahdMcKQn2VEUv4c3jDQB8eSQVZGE+kEqTMpqn4FXCb74oI1Bfvac
         ZSARQuRF2y+tuak24HcR4OBDt7IZHsnf1i7LkPyAVOktU9sqAQFani0HEC44xXEDWqqt
         bspn3oVdi76Z1/Gp0FIXd0gfCAhZHyfFpiHmqx4f/eSCW5/EPdHOtzowdoF6k1u64T0t
         iQ6SdF7TV9tRj6ww61M6M+ezRppZS+IUJdcKL1yOWwh0jPjVWUUjKeXh4pp7LNEbD4RC
         rfeTH2Py/pd9ObQKqFZ+fs/kDRqjSwFPVpxDh1kfoJ1L+8SCsCbcVRNlpRf5LEnKtRQI
         sMzA==
X-Gm-Message-State: AOJu0YzED+VXbt+xXTgmw+jITRI52NOGJ93u3KUEc+ALyfV8rKvr9AAI
	VAQA7I2UL/Tf+V2YSq32NcPpi88+/5H0rJJmiiQ0GDYCsvDMK+uOZTACVLJSZH/b8cl0Y7y95em
	sKXALXA==
X-Google-Smtp-Source: AGHT+IFeKAgDTFsHmtJYEfy+u63LVZM9vhhHya2fp64ilql1pmY6B8TrVhx6wuWjZ/UoqKZtA4WXCHEDA1s=
X-Received: from pfbcv5.prod.google.com ([2002:a05:6a00:44c5:b0:772:38cc:6145])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4b53:b0:771:fdd9:efa0
 with SMTP id d2e1a72fcca58-7761216c32bmr6336983b3a.15.1757719404835; Fri, 12
 Sep 2025 16:23:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-1-seanjc@google.com>
Subject: [PATCH v15 00/41] KVM: x86: Mega-CET
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

This series is (hopefully) all of the in-flight CET virtualization patches
in one big bundle.  Please holler if I missed a patch or three as this is what
I am planning on applying for 6.18 (modulo fixups and whatnot), i.e. if there's
something else that's needed to enable CET virtualization, now's the time...

Patches 1-3 probably need the most attention, as they are new in v15 and I
don't have a fully working SEV-ES setup (don't have the right guest firmware,
ugh).  Though testing on everything would be much appreciated.

I kept almost all Tested-by tags even for patches that I massaged a bit, and
only dropped tags for the "don't emulate CET stuff" patch.  In theory, the
changes I've made *should* be benign.  Please yell, loudly, if I broken
something and/or you want me to drop your Tested-by.

v15:
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
  KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
  KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
  KVM: x86: SVM: Pass through shadow stack MSRs as appropriate
  KVM: SVM: Enable shadow stack virtualization for SVM

Mathias Krause (1):
  KVM: VMX: Make CR4.CET a guest owned bit

Sean Christopherson (17):
  KVM: SEV: Rename kvm_ghcb_get_sw_exit_code() to
    kvm_get_cached_sw_exit_code()
  KVM: SEV: Read save fields from GHCB exactly once
  KVM: SEV: Validate XCR0 provided by guest in GHCB
  KVM: x86: Report XSS as to-be-saved if there are supported features
  KVM: x86: Load guest FPU state when access XSAVE-managed MSRs
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

Yang Weijiang (15):
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
  KVM: x86: Don't emulate instructions affected by CET features
  KVM: x86: Enable CET virtualization for VMX and advertise to userspace
  KVM: nVMX: Virtualize NO_HW_ERROR_CODE_CC for L1 event injection to L2
  KVM: nVMX: Prepare for enabling CET support for nested guest

 Documentation/virt/kvm/api.rst                |  14 +-
 arch/x86/include/asm/kvm_host.h               |   6 +-
 arch/x86/include/asm/vmx.h                    |   9 +
 arch/x86/include/uapi/asm/kvm.h               |  34 ++
 arch/x86/kvm/cpuid.c                          |  17 +-
 arch/x86/kvm/emulate.c                        |  58 ++-
 arch/x86/kvm/kvm_cache_regs.h                 |   3 +-
 arch/x86/kvm/smm.c                            |   8 +
 arch/x86/kvm/smm.h                            |   2 +-
 arch/x86/kvm/svm/nested.c                     |  20 +
 arch/x86/kvm/svm/sev.c                        |  23 +-
 arch/x86/kvm/svm/svm.c                        |  46 +-
 arch/x86/kvm/svm/svm.h                        |  30 +-
 arch/x86/kvm/trace.h                          |   5 +-
 arch/x86/kvm/vmx/capabilities.h               |   9 +
 arch/x86/kvm/vmx/nested.c                     | 163 ++++++-
 arch/x86/kvm/vmx/nested.h                     |   5 +
 arch/x86/kvm/vmx/vmcs12.c                     |   6 +
 arch/x86/kvm/vmx/vmcs12.h                     |  14 +-
 arch/x86/kvm/vmx/vmx.c                        |  84 +++-
 arch/x86/kvm/vmx/vmx.h                        |   9 +-
 arch/x86/kvm/x86.c                            | 362 +++++++++++++-
 arch/x86/kvm/x86.h                            |  37 ++
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/processor.h     |   2 +
 .../testing/selftests/kvm/lib/x86/processor.c |  33 ++
 .../selftests/kvm/x86/hyperv_features.c       |  16 +-
 tools/testing/selftests/kvm/x86/msrs_test.c   | 440 ++++++++++++++++++
 .../selftests/kvm/x86/vmx_pmu_caps_test.c     |   4 +-
 .../selftests/kvm/x86/xcr0_cpuid_test.c       |  12 +-
 30 files changed, 1382 insertions(+), 90 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/msrs_test.c


base-commit: b33f3c899e27cad5a62b15f9e3724fb5e61378c4
-- 
2.51.0.384.g4c02a37b29-goog


