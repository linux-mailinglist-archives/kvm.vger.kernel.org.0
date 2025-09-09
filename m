Return-Path: <kvm+bounces-57065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 852E5B4A84F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:40:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E776A4E1B4E
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A48562D1911;
	Tue,  9 Sep 2025 09:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YNXUDUlO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D190A2C21CF;
	Tue,  9 Sep 2025 09:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410797; cv=none; b=AVnRTznsvccNgUt1IPspCvKoom3T27wsfFVi7A9iNXUBRP6bxWGEEGAynwmt7OFOu4uXmzljE/lpvAyCMLsCSHiBmZ6wOCDD4OBmY2Ctp95MChdK6XE5QiYenRTgWVGQT1hkFg6KAmXoRv0aYyXVBJfni9rjq46vTw0BTN1/DtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410797; c=relaxed/simple;
	bh=xu2dANKyubAvxrmsFb1FCC6E9W8Kc5S2SO2nznkVz1s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QZSqeT/Ii8wBKUJAscN+NRzac6odqaaCG7Ua5Bea4M7MiR9/VuQU0fgafdwYDcgollgZONtZFfqOQx1LPFv0bXWo97XS4d73UNZzCybhUKmdHbaYk50sa6oRUOHZPAIN7ozypOTlscI9yJDUKsfEsv1O9nyvbTSwjMDlUdz0r8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YNXUDUlO; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410796; x=1788946796;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xu2dANKyubAvxrmsFb1FCC6E9W8Kc5S2SO2nznkVz1s=;
  b=YNXUDUlOInMvISik0BgYaRJQCEACYezRQETgUReyupXZDl1yJKwErYj8
   T2mbyA6Eeq1LStbw/OHVMnLJMzPw/cDM7GPQbNNruKzHUIqd5lZog0sBh
   e/GD3hxI1hV77Yos85Iziz9tkVtGWAI5g/0qBQAz3s3JnsOJrJSxhzxEZ
   nuirhX8QCFbyOApkzP8bQ2/nIyDjABODz+2uYN1l7K6KqbVWGBoBaJdue
   TiJB/zmJ+WM/PHDYbC37BjZWrW5K6qJCvvgo6B/ud137pj7UWAgcsvBR8
   Y4qPWlW+gspox2vtZgPVx16tNy7Y6ET8ovEylARo03AuA1kQRoonRVKxM
   w==;
X-CSE-ConnectionGUID: 93Q8W5L9S2WIgDqxUj/SqA==
X-CSE-MsgGUID: AKBXvQkITrKMNzfZGSP1mQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307170"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307170"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:54 -0700
X-CSE-ConnectionGUID: /7Im4CaGT/+AcvI1lmO9EA==
X-CSE-MsgGUID: piwWP0KET4aSw4UXarv1YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207385"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:54 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 00/22] Enable CET Virtualization
Date: Tue,  9 Sep 2025 02:39:31 -0700
Message-ID: <20250909093953.202028-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The FPU support for CET virtualization has already been merged into 6.17-rc1.
Building on that, this series introduces Intel CET virtualization support for
KVM.

Changes in v14
1. rename the type of guest SSP register to KVM_X86_REG_KVM and add docs
   for register IDs in api.rst (Sean, Xiaoyao)
2. update commit message of patch 1
3. use rdmsrq/wrmsrq() instead of rdmsrl/wrmsrl() in patch 6 (Xin)
4. split the introduction of per-guest guest_supported_xss into a
separate patch. (Xiaoyao)
5. make guest FPU and VMCS consistent regarding MSR_IA32_S_CET
6. collect reviews from Xiaoyao.

---
Control-flow Enforcement Technology (CET) is a kind of CPU feature used
to prevent Return/CALL/Jump-Oriented Programming (ROP/COP/JOP) attacks.
It provides two sub-features(SHSTK,IBT) to defend against ROP/COP/JOP
style control-flow subversion attacks.

Shadow Stack (SHSTK):
  A shadow stack is a second stack used exclusively for control transfer
  operations. The shadow stack is separate from the data/normal stack and
  can be enabled individually in user and kernel mode. When shadow stack
  is enabled, CALL pushes the return address on both the data and shadow
  stack. RET pops the return address from both stacks and compares them.
  If the return addresses from the two stacks do not match, the processor
  generates a #CP.

Indirect Branch Tracking (IBT):
  IBT introduces new instruction(ENDBRANCH)to mark valid target addresses
  of indirect branches (CALL, JMP etc...). If an indirect branch is
  executed and the next instruction is _not_ an ENDBRANCH, the processor
  generates a #CP. These instruction behaves as a NOP on platforms that
  doesn't support CET.

CET states management
=====================
KVM cooperates with host kernel FPU framework to manage guest CET registers.
With CET supervisor mode state support in this series, KVM can save/restore
full guest CET xsave-managed states.

CET user mode and supervisor mode xstates, i.e., MSR_IA32_{U_CET,PL3_SSP}
and MSR_IA32_PL{0,1,2}, depend on host FPU framework to swap guest and host
xstates. On VM-Exit, guest CET xstates are saved to guest fpu area and host
CET xstates are loaded from task/thread context before vCPU returns to
userspace, vice-versa on VM-Entry. See details in kvm_{load,put}_guest_fpu().

CET supervisor mode states are grouped into two categories : XSAVE-managed
and non-XSAVE-managed, the former includes MSR_IA32_PL{0,1,2}_SSP and are
controlled by CET supervisor mode bit(S_CET bit) in XSS, the later consists
of MSR_IA32_S_CET and MSR_IA32_INTR_SSP_TBL.

VMX introduces new VMCS fields, {GUEST|HOST}_{S_CET,SSP,INTR_SSP_TABL}, to
facilitate guest/host non-XSAVES-managed states. When VMX CET entry/exit load
bits are set, guest/host MSR_IA32_{S_CET,INTR_SSP_TBL,SSP} are loaded from
equivalent fields at VM-Exit/Entry. With these new fields, such supervisor
states require no addtional KVM save/reload actions.

Tests
======
This series has successfully passed the basic CET user shadow stack test
and kernel IBT test in both L1 and L2 guests. The newly added
KVM-unit-tests [2] also passed, and its v11 has been tested with the AMD
CET series by John [3].

For your convenience, you can use my WIP QEMU [1] for testing.

[1]: https://github.com/gaochaointel/qemu-dev qemu-cet
[2]: https://lore.kernel.org/kvm/20250626073459.12990-1-minipli@grsecurity.net/
[3]: https://lore.kernel.org/kvm/aH6CH+x5mCDrvtoz@AUSJOHALLEN.amd.com/

Chao Gao (5):
  KVM: x86: Check XSS validity against guest CPUIDs
  KVM: nVMX: Add consistency checks for CR0.WP and CR4.CET
  KVM: nVMX: Add consistency checks for CET states
  KVM: nVMX: Advertise new VM-Entry/Exit control bits for CET state
  KVM: selftest: Add tests for KVM_{GET,SET}_ONE_REG

Sean Christopherson (2):
  KVM: x86: Report XSS as to-be-saved if there are supported features
  KVM: x86: Load guest FPU state when access XSAVE-managed MSRs

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
  KVM: x86: Don't emulate instructions guarded by CET
  KVM: x86: Enable CET virtualization for VMX and advertise to userspace
  KVM: nVMX: Virtualize NO_HW_ERROR_CODE_CC for L1 event injection to L2
  KVM: nVMX: Prepare for enabling CET support for nested guest

 Documentation/virt/kvm/api.rst                |   9 +
 arch/x86/include/asm/kvm_host.h               |   5 +-
 arch/x86/include/asm/vmx.h                    |   9 +
 arch/x86/include/uapi/asm/kvm.h               |  29 ++
 arch/x86/kvm/cpuid.c                          |  17 +-
 arch/x86/kvm/emulate.c                        |  46 ++-
 arch/x86/kvm/smm.c                            |   8 +
 arch/x86/kvm/smm.h                            |   2 +-
 arch/x86/kvm/svm/svm.c                        |   4 +
 arch/x86/kvm/vmx/capabilities.h               |   9 +
 arch/x86/kvm/vmx/nested.c                     | 163 ++++++++++-
 arch/x86/kvm/vmx/nested.h                     |   5 +
 arch/x86/kvm/vmx/vmcs12.c                     |   6 +
 arch/x86/kvm/vmx/vmcs12.h                     |  14 +-
 arch/x86/kvm/vmx/vmx.c                        |  85 +++++-
 arch/x86/kvm/vmx/vmx.h                        |   9 +-
 arch/x86/kvm/x86.c                            | 264 +++++++++++++++++-
 arch/x86/kvm/x86.h                            |  61 ++++
 tools/arch/x86/include/uapi/asm/kvm.h         |  29 ++
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/get_set_one_reg.c       |  30 ++
 21 files changed, 764 insertions(+), 41 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/get_set_one_reg.c

-- 
2.47.3


