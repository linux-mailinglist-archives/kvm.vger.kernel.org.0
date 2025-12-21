Return-Path: <kvm+bounces-66442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E38FCD3B8B
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:31:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C9EEC3011EE5
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB3EE2222BF;
	Sun, 21 Dec 2025 04:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Aq4m94DA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405BA3A1E72;
	Sun, 21 Dec 2025 04:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291472; cv=none; b=daXj+jB2wNMGlUjsEtjZMJns/QMqUD84LL7jVznUUUB+kDnMD1Q/VbjpDTzoE67ivLXokAK6tYwE2rAM9joWbgPilVlqzp54xyXJFcqnfMiQYQmf9OHFTCJ3S0i/WtAqrDVVJ84QUbxII7kvR3t/HyPPqq00Xaun8s9TDeAKoi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291472; c=relaxed/simple;
	bh=0Jjz/LDF7FFY7kCnfolQnpRXgQh2ZKtrmb561qv45bg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P7tr0MleGYHWj+l59phcIvE6ekGvIQhZSg1fYB27JwWCQAVhVqcLeNbAcRRh/0IVOSrj1fX90+fJtsBKLN2Ub7D1ha9znYDtJGDwYLg47G232acQjDaTs+dNPwTD3sZ4cM50o569XZsTtbJrRq1n2o7Xu/DindO7ANA7WJ/X1io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Aq4m94DA; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291469; x=1797827469;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0Jjz/LDF7FFY7kCnfolQnpRXgQh2ZKtrmb561qv45bg=;
  b=Aq4m94DAalUVSrjZc7FFIF/BsYIynxws1CCoKF78cC/XFgyXIe46YRGK
   JbR9pfDg/Xv1MmCkIGRQNJgzq9mRRVqmL4oA/bfI7NMoDEyMZEzHt2pOX
   s8SaR6mnj53/p/dK9iFtBMHnn8hNzGNdi+fOIoCy4c7j3A0EgJFowhE84
   NKM5iG7HMaW1UNbHgC3UccGmCdO06a1labvV009yK4dx1zYSlMTw4hjNt
   lIQW28twLVOLnracBntkfrHMWQq9JroHd1hzuyHcp6xwwIRPWIWmltnan
   F9GRe5qJelRoAu+Gi6FlFK09olWoniETA5MdW9NWx1vvkSx8IQ0PVa0Hh
   A==;
X-CSE-ConnectionGUID: LOeeb3SHR+S+PubieB1QMg==
X-CSE-MsgGUID: Irox87GGTXWhGPeMBmQdug==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132360"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132360"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:08 -0800
X-CSE-ConnectionGUID: SuezgUKRRJ2NerWfGQaqIg==
X-CSE-MsgGUID: C6HZm6cxQ4CpXOVOWZk/lA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229884852"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:08 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 00/16] KVM: x86: Enable APX for guests
Date: Sun, 21 Dec 2025 04:07:26 +0000
Message-ID: <20251221040742.29749-1-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

Since the last RFC posting [1], Paolo provided extensive feedback that
helped clarify the overall direction, so this series is now without RFC.
The patchset incorporates those feedbacks throughout, based on v6.19-rc1
where the VEX support series [2] was merged.

Major changes were made on the emulator with rebasing and subsequent
simplifications. Below is a brief summary of each part.

 * Part1, PATCH 01-03: GPR accessor refactoring

   PATCH2: Rename the internal GPR access helpers to kvm_gpr_read_raw() /
   kvm_gpr_write(). These accessors are selectively defined to support
   EGPR indexes. Only with CONFIG_KVM_APX=y, EGPR handling is compiled
   while AMD and 32-bit builds remain unchanged and continue to use the
   existing accessor as is.

 * Part2, PATCH 04-08: VMX support for extended register index

   In the previous version, use of extended VMX fields for EGPR indices
   was conditioned on XCR0.APX. However, enumeration of the APX CPUID bit
   alone is sufficient to guarantee availability of the extended field in
   VMCS. Now, this series checks static_cpu_has(X86_FEATURE_APX) for VMX
   (PATCH8) and the corresponding vCPU value for nested VMX (PATCH7).

 * Part3, PATCH 09-12:  Emulation support for REX2

   This part has the largest changes, with substantial simplification:

   1. PATCH10/11: JMPABS support is dropped, as emulation of memory
      operations are practically meaningful. Then, this drop allows reuse
      of the existing opcode tables with adjustments -- adding the NoRex
      tag for clarifying the #UD behavior with REX2 in PATCH10.
      Subsequently, on PATCH11, REX2-prefixed opcode lookup is then
      integrated into the existing flow by jumping directly to the
      relevant sites.

   2. PATCH11: REX2 disallows several illegal prefix sequences. The
      previous version had pretty complex logic unnecessary. The new
      approach relies on opcode table attributes, which is sufficient and
      makes it simple. This also aligns with the spec sentences [3].

   3. PATCH10: Register index extraction is simplified by a generalized
      helper which interprets REX/REX2 bits.

 * Part4, PATCH13-16: APX exposition and self-test

   There are no changes to CPUID exposure or the self-tests. The only
   adjustment is in XCR0.APX handling to explicitly prevent conflicts
   with MPX (PATCH13). The code that previously referenced XCR0.APX in
   the VMX exit handler was removed with the Part2 changes.

Each patch contains detailed changelogs describing the individual changes.
The previous cover letter [4] also includes some details that were
previously brought up as RFC and now seem to be established.

Thanks to Paolo for the thorough reviews and guidance, and to Chao for
spotting an important point.

The series is also available on this repository:
  git://github.com/intel/apx.git apx-kvm_v1

Thanks,
Chang

[1]: https://lore.kernel.org/kvm/20251110180131.28264-1-chang.seok.bae@intel.com
[2]: https://lore.kernel.org/kvm/20251114003633.60689-1-pbonzini@redhat.com
[3]: https://lore.kernel.org/kvm/20251110180131.28264-1-chang.seok.bae@intel.com
[4]: 3.1.2.1 REX2 Prefix, APX Architecture Specification
     https://cdrdv2.intel.com/v1/dl/getContent/784266

Chang S. Bae (15):
  KVM: x86: Rename register accessors to be GPR-specific
  KVM: x86: Refactor GPR accessors to differentiate register access
    types
  KVM: x86: Implement accessors for extended GPRs
  KVM: VMX: Introduce unified instruction info structure
  KVM: VMX: Refactor instruction information retrieval
  KVM: VMX: Refactor GPR index retrieval from exit qualification
  KVM: nVMX: Propagate the extended instruction info field
  KVM: VMX: Support extended register index in exit handling
  KVM: emulate: Support EGPR accessing and tracking
  KVM: emulate: Handle EGPR index and REX2-incompatible opcodes
  KVM: emulate: Support REX2-prefixed opcode decode
  KVM: emulate: Reject EVEX-prefixed instructions
  KVM: x86: Guard valid XCR0.APX settings
  KVM: x86: Expose APX sub-features to guests
  KVM: x86: selftests: Add APX state handling and XCR0 sanity checks

Peter Fang (1):
  KVM: x86: Expose APX foundational feature bit to guests

 arch/x86/include/asm/kvm_host.h               |  19 +++
 arch/x86/include/asm/kvm_vcpu_regs.h          |  16 +++
 arch/x86/include/asm/vmx.h                    |   2 +
 arch/x86/kvm/Kconfig                          |   4 +
 arch/x86/kvm/cpuid.c                          |  14 +-
 arch/x86/kvm/emulate.c                        | 121 +++++++++++++-----
 arch/x86/kvm/fpu.h                            |  82 ++++++++++++
 arch/x86/kvm/kvm_emulate.h                    |  11 +-
 arch/x86/kvm/reverse_cpuid.h                  |   6 +
 arch/x86/kvm/svm/svm.c                        |  23 +++-
 arch/x86/kvm/vmx/nested.c                     |  87 +++++++------
 arch/x86/kvm/vmx/nested.h                     |   2 +-
 arch/x86/kvm/vmx/vmcs12.c                     |   1 +
 arch/x86/kvm/vmx/vmcs12.h                     |   3 +-
 arch/x86/kvm/vmx/vmx.c                        |  26 ++--
 arch/x86/kvm/vmx/vmx.h                        | 106 +++++++++++++--
 arch/x86/kvm/x86.c                            |  53 ++++++--
 arch/x86/kvm/x86.h                            |  24 +++-
 arch/x86/kvm/xen.c                            |   2 +-
 .../selftests/kvm/include/x86/processor.h     |   1 +
 tools/testing/selftests/kvm/x86/state_test.c  |   6 +
 .../selftests/kvm/x86/xcr0_cpuid_test.c       |  19 +++
 22 files changed, 503 insertions(+), 125 deletions(-)


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.51.0


