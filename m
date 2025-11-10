Return-Path: <kvm+bounces-62551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78EAEC488B9
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:26:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF150189267A
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21EE532B98C;
	Mon, 10 Nov 2025 18:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UKtDhT7o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D2C32AAB8;
	Mon, 10 Nov 2025 18:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799074; cv=none; b=FgRjpJwumw/YbJOTMNdSCbyJeYrLWiekgOqbWDIn55W3setjtLJnzon4K7FIxphC5n8tqocjHYpVLa9J/H1lM0QVX1xd7M/emFMA/yNhfsJh4u21IRappai/SoUNctfS4pY+XLRbvx4bbyngFxMv07SIRC8uI0E4XJeHdfKfpPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799074; c=relaxed/simple;
	bh=Fi/ogMOE8ci/isPMMZbSl/BCrquYT2jUtaPI4KPRkzo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rYLb5feU18efAZGyl4e52h2AMT31mE0sJ/rR9Wt589UicqoUa37kDj8FLU+zEtwC6tzUz2PH2CHFUJHDQJ1QHn+6SpQoeZK6kDFS9B2Q29J0Fidti+zXpz37yi7Noyj56eFuCzqwQssuuEWke1/aNPQTtiWmKu4qhCHUj9NL0gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UKtDhT7o; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799072; x=1794335072;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Fi/ogMOE8ci/isPMMZbSl/BCrquYT2jUtaPI4KPRkzo=;
  b=UKtDhT7oN1reogmIsf1ofnmHbr+rG9577APYMLKV13RWIOLiSRGmU50v
   4rSoXZle/vqH/t6LADwfbCwmSpUnXcQR4ywvDNWr9ynL+DOMuZEXe43YF
   a5zGFziSsgMo47tuZWtViPao0q/4m7MuPt0YINKPbwY1XjmtBnVODLJBe
   TgRmUx4Oo+sbkwAMuJK0Bi4w1qmnrDVQKZe6QJwLDHvDyYvluMeEIBra8
   sWpuMSdpNIRR5n5JZ1sAJRIfbUwthh5XYjMQZad5YR8iJX+NTpGquvIKn
   BZICe/mol/sIYeUP/bHcEAH4ug0V6+K9gSBLAZXYk4eIc4Nll60ewkW8y
   A==;
X-CSE-ConnectionGUID: 65D3++JbSr6+3s0NlsXWAw==
X-CSE-MsgGUID: dMix0K7YSWKc8IOarKl/3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305475"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305475"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:24:32 -0800
X-CSE-ConnectionGUID: UywlTR1cQQu8EePz0KEhcQ==
X-CSE-MsgGUID: /3VUevgjTJ+vC5SnN6Vp2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396019"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:24:32 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 00/20] KVM: x86: Support APX feature for guests
Date: Mon, 10 Nov 2025 18:01:11 +0000
Message-ID: <20251110180131.28264-1-chang.seok.bae@intel.com>
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

This series is intended to initiate the enablement of APX support in KVM.
The goal is to start discussions and, ideally, reach consensus on key
decisions for the enabling path.

== Introduction ==

Intel introduces Advanced Performance Extensions (APX), which add 16
additional 64-bit general-purpose registers (EGPRs: R16–R31).

APX also introduces new instruction prefixes that extend register indices
to 5 bits, providing additional encoding space. The feature specification
[1] describes these extensions in detail.

The specification deliberately scopes out some areas. For example,
Sections 3.1.4.4.2–7 note that initialization and reset behaviors follow
existing XSTATE conventions.

That said, there are still some essential elements to consider at first.

== Ingredients to Consider ==

With guest exposure, the new registers will affect how KVM handles VM
exits and manages guest state. So the extended register indices need to
be properly interpreted.

There are three relevant contexts where KVM must handle the new 5-bit
register index:

 * Instruction Information in VMCS

   VMX provides instruction information through a dedicated field in the
   VMCS. However, the legacy format supports only 4-bit register indices,
   so a new 64-bit field was introduced to support 5-bit indices for
   EGPRs (see Table 3.11 in the spec).

 * Exit Qualification in VMCS

   This field also carries register index information. Fortunately, the
   current layout is not fully packed, so it appears feasible to extend
   index fields to 5 bits without structural conflict.

 * Instruction Emulator

   When exits are handled through instruction emulation, the emulator
   must decode REX2-prefixed instructions, which carry the additional
   bits encoding the extended indices and other new modifiers.

Once handlers can identify EGPR-related indices, the next question is how
to access and maintain their state.

 * Extended GPR State Management

   Current KVM behavior for legacy GPRs can be summarized as follows:
   (a) All legacy GPRs are saved on every VM exit and written back on
       re-entry. Most access operations go through KVM register cache.
   (b) The instruction emulator also maintains a temporary GPR cache
       during emulation, backed by the same KVM-managed accessor
       interface.

   For the new EGPRs, there are a few important differences:
   (a) They are general-purpose registers, but their state is
       XSAVE-managed, which makes them distinct from legacy GPRs.
   (b) The kernel itself currently does not use them, so there is no
       requirement to save EGPRs on every VM exit -- they can remain in
       hardware registers.

The mechanism to read and write EGPR state will therefore be commonly
needed by both VMX handlers and the instruction emulator.

== Approaches to Support ==

Given the above aspects, the first step is to build out a generalized GPR
accessor framework. This constitutes the first part (PART1: PATCH1–3) of
the series, laying the foundational infrastructure.

 * New EGPR Accessors (PATCH3)

   Since EGPRs are not yet clobbered by the host, they can be accessed
   directly through hardware, using the existing helpers kvm_fpu_get()
   and kvm_fpu_put().

   This model follows the same approach used for legacy FP state
   handling.

   The design choice is based on the following considerations:
   (a) Caching EGPR state on every VM exit would be unnecessary cost.
   (b) If EGPRs are updated during VM exit handling or instruction
       emulation, synchronizing them with the guest fpstate would require
       new interfaces to interact with x86 core logic, adding complexity.

 * Common GPR Access Interface --Unifying Legacy and Extended Accessors
   (PATCH2)

   Although legacy GPRs and EGPRs differ in how their state is accessed,
   that distinction does not justify maintaining separate interfaces. A
   unified accessor abstraction allows both legacy and extended registers
   to be accessed uniformly, simplifying usage for both exit handlers and
   the emulator.

Returning to the remaining key ingredients -- VMX handlers and the
instruction emulator -- the necessary updates break down into the
following.

 * Extended Instruction Information Extraction (PART2: PATCH4–8)

   Currently, instruction-related VMCS fields are stored as 32-bit raw
   data and interpreted on site. Adding separate variable in this manner
   would increase code complexity.

   Thus, refactoring this logic into a proper data structure with clear
   semantics appears to be a sensible direction.

 * Instruction Emulator (PART3: PATCH9–16)

   As noted in Paolo’s earlier feedback [2], support for REX2-prefixed
   instruction emulation is required.

   While REX2 largely mirrors legacy opcode behavior, a few exceptions
   and new instructions introduce additional decoding and handling
   requirements.

Conceptually, the changes are straightforward, though details are better
handled directly in the patches.

Finally, actual feature exposure and XCR0 management form the last stage
of enabling (PART4: PATCH17-20), relatively small but with a few key
constraints:

 * XCR0 updates and CPUID feature exposure must occur together (PATCH18).
 * The current enabling scope applies only to VMX (PATCH17-18).

== Patchset ==

As mentioned earlier, while the number of patches is relatively large,
the series is organized into four logical parts for clarity and
reviewability:

 * PART1, PATCH 01–03: GPR accessor refactoring (foundational)
 * PART2, PATCH 04–08: VMX support for EGPR index handling
 * PART3, PATCH 09–16: Instruction emulator support for REX2
 * PART4, PATCH 17–20: APX exposure and minor selftest updates

Each patch includes an RFC note to provide context for reviewers.

This series is based on the next branch of the KVM x86 tree [3] and is
available at:

  git://github.com/intel/apx.git apx-kvm_rfc-v1

== Testing ==

Testing so far has focused on unit and synthetic coverage of relevant
code paths using KVM selftests, both on legacy and APX systems.

For decoder-related changes, additional testing was performed by invoking
x86_decode_insn() from a pseudo driver with some test inputs to exercise
REX2 and legacy decoding logic.

== References ==

[1] https://cdrdv2.intel.com/v1/dl/getContent/784266
[2] https://lore.kernel.org/kvm/CABgObfaHp9bH783Kdwm_tMBHZk5zWCxD7R+RroB_Q_o5NWBVZg@mail.gmail.com/
[3] https://github.com/kvm-x86/linux


I would also give thanks to Chao and Zhao for helping me out in this
KVM series.

Thanks for a look on this.
Chang

Chang S. Bae (19):
  KVM: x86: Rename register accessors to be GPR-specific
  KVM: x86: Refactor GPR accessors to differentiate register access
    types
  KVM: x86: Implement accessors for extended GPRs
  KVM: VMX: Introduce unified instruction info structure
  KVM: VMX: Refactor instruction information retrieval
  KVM: VMX: Refactor GPR index retrieval from exit qualification
  KVM: nVMX: Support the extended instruction info field
  KVM: VMX: Support extended register index in exit handling
  KVM: x86: Support EGPR accessing and tracking for instruction
    emulation
  KVM: x86: Refactor REX prefix handling in instruction emulation
  KVM: x86: Refactor opcode table lookup in instruction emulation
  KVM: x86: Support REX2-extended register index in the decoder
  KVM: x86: Add REX2 opcode tables to the instruction decoder
  KVM: x86: Emulate REX2-prefixed 64-bit absolute jump
  KVM: x86: Reject EVEX-prefix instructions in the emulator
  KVM: x86: Decode REX2 prefix in the emulator
  KVM: x86: Prepare APX state setting in XCR0
  KVM: x86: Expose APX sub-features to guests
  KVM: selftests: Add APX state handling and XCR0 sanity checks

Peter Fang (1):
  KVM: x86: Expose APX foundational feature bit to guests

 arch/x86/include/asm/kvm_host.h               |  19 ++
 arch/x86/include/asm/kvm_vcpu_regs.h          |  16 ++
 arch/x86/include/asm/vmx.h                    |   2 +
 arch/x86/kvm/cpuid.c                          |  14 +-
 arch/x86/kvm/emulate.c                        | 177 +++++++++++++++---
 arch/x86/kvm/fpu.h                            |  82 ++++++++
 arch/x86/kvm/kvm_cache_regs.h                 |   1 +
 arch/x86/kvm/kvm_emulate.h                    |  44 ++++-
 arch/x86/kvm/reverse_cpuid.h                  |   6 +
 arch/x86/kvm/svm/svm.c                        |  23 ++-
 arch/x86/kvm/vmx/nested.c                     |  83 ++++----
 arch/x86/kvm/vmx/nested.h                     |   2 +-
 arch/x86/kvm/vmx/vmcs12.c                     |   1 +
 arch/x86/kvm/vmx/vmcs12.h                     |   3 +-
 arch/x86/kvm/vmx/vmx.c                        |  26 +--
 arch/x86/kvm/vmx/vmx.h                        | 106 ++++++++++-
 arch/x86/kvm/x86.c                            |  29 ++-
 arch/x86/kvm/x86.h                            |  49 ++++-
 arch/x86/kvm/xen.c                            |   2 +-
 .../selftests/kvm/include/x86/processor.h     |   1 +
 tools/testing/selftests/kvm/x86/state_test.c  |   6 +
 .../selftests/kvm/x86/xcr0_cpuid_test.c       |  20 ++
 22 files changed, 592 insertions(+), 120 deletions(-)


base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
-- 
2.51.0


