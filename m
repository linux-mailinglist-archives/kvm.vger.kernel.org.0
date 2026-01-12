Return-Path: <kvm+bounces-67853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7647AD15F30
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:18:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A88A3302BA50
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A991221FBB;
	Tue, 13 Jan 2026 00:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FiB8mQns"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7190142AB7;
	Tue, 13 Jan 2026 00:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263476; cv=none; b=c54/y3uD7wYqMe6pJZHFsjLs66ZLZgiOEETIDTcvOUYsosoZCuYoWZaV3AENnR3oh+1dL2tsul94iaC8YTHkR6xqbysFiBS9JG7Ke/HPYogUWGkItma0baYKL3svTwubnpX+VKkiH2yH645BFq0xQDbyDjce0q2l5r6NugMVE6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263476; c=relaxed/simple;
	bh=tdqDZEv2m9eHgE+ToDfh2V3OTztIE5t0gQqlDbyq6I0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S1vuJX937z086qEkno11/SzpQLEo8RCVwUbjdqJmZlNw83087LYMSjeFgjT87XIlh4t/AHmzZJ49VymHMGwt4+T5f0vG2liuHO3hwTZjKoZJUM4Tm1Rhj9r7F/UwEUfXEBz1OvfqfFlkyGiUFWNAPOYcAOfJ/0lblnvINOB907U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FiB8mQns; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263475; x=1799799475;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tdqDZEv2m9eHgE+ToDfh2V3OTztIE5t0gQqlDbyq6I0=;
  b=FiB8mQnsprvUgLvg4fivlybXdat1UxEBsSOpdY90ySG76jyu2eSI+PJZ
   WRfQSDrO/seSYA4uq5oO9NQYHofZUzqnIgkbvxlZsu4y7gfLfN6qbA3tN
   lbfdme5Y1eHUq5X8Yht4U+ms9AyXiYBZpn1V5MO00pA6my3zE2XKIFUt6
   8Dsvy/A9gtEnXD25eomE5mitYiOTAxSSShhIOMwpbwfhvooi2Z8cqQOv4
   wUfz1Hqi2WnaTW5sRxDxBi5aK7S8IDlzCpX7XTovQWHfljN6GSNiUT8dj
   xbPRTJTTvGI2yhG+Nbq+E/M+jW/F+3FdTEQ04ytdd0s3m9fAUR8UzDcas
   A==;
X-CSE-ConnectionGUID: HI6u12aPS+Ocw3FyGG1shg==
X-CSE-MsgGUID: JFVOA7o5QaqE+uAc4NrP5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264167"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264167"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:17:55 -0800
X-CSE-ConnectionGUID: /BxfuyfhT3Ki83gEsBDnZA==
X-CSE-MsgGUID: VZmJ5bkhQhSTMzxoYuRv8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042138"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:17:55 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 00/16] KVM: x86: Enable APX for guests
Date: Mon, 12 Jan 2026 23:53:52 +0000
Message-ID: <20260112235408.168200-1-chang.seok.bae@intel.com>
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

Here is a summary of changes since the last posting [1]:

  * PATCH 2/3: Move EGPR accessor code to x86.c (Paolo)
  * PATCH 11:  Rename NoRex to NoRex2 (Paolo)
  * PATCH 05:  Remove an unused function parameter (Chao)
  * PATCH 7/8: Reorder nVMX changes after VMX patches (Chao)

With this posting, I would like to see if I can collect some review tags.

For anyone looking at this series for the first time, please refer to the
initial RFC posting cover and the related discussions [3], while a brief
overview is here:

  APX [2] extends the general-purpose register set (EGPRs). Unlike legacy
  GPRs, the state is not cached by KVM, so will be accessed directly to
  live hardware registers (Part1). Based on that, VMX exit handling
  (Part2) and instruction emulation (Part3) are updated before the
  feature is exposed to guests (Part4).

  * Part1, PATCH 01-03: GPR accessor refactoring and EGPR support
  * Part2, PATCH 04-08: VMX handler changes for EGPR indices
  * Part3, PATCH 09-12: Emulator changes for REX2 support
  * Part4, PATCH 13-16: Feature expossure and self-tests

The series is also available here:
  git://github.com/intel/apx.git apx-kvm_v2

This version is rebased on v6.19-rc5. I do not see any direct dependency
on other pending changes right now; any conflict should be manageable
later.

Thanks,
Chang

[1] V1: https://lore.kernel.org/kvm/20251221040742.29749-1-chang.seok.bae@intel.com/
[2] APX Architecture Specification:
    https://cdrdv2.intel.com/v1/dl/getContent/784266
[3] RFC: https://lore.kernel.org/kvm/20251110180131.28264-1-chang.seok.bae@intel.com/

Chang S. Bae (15):
  KVM: x86: Rename register accessors to be GPR-specific
  KVM: x86: Refactor GPR accessors to differentiate register access
    types
  KVM: x86: Implement accessors for extended GPRs
  KVM: VMX: Introduce unified instruction info structure
  KVM: VMX: Refactor instruction information retrieval
  KVM: VMX: Refactor GPR index retrieval from exit qualification
  KVM: VMX: Support extended register index in exit handling
  KVM: nVMX: Propagate the extended instruction info field
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
 arch/x86/kvm/emulate.c                        | 121 +++++++++++-----
 arch/x86/kvm/kvm_emulate.h                    |  11 +-
 arch/x86/kvm/reverse_cpuid.h                  |   6 +
 arch/x86/kvm/svm/svm.c                        |  23 +++-
 arch/x86/kvm/vmx/nested.c                     |  87 ++++++------
 arch/x86/kvm/vmx/nested.h                     |   2 +-
 arch/x86/kvm/vmx/vmcs12.c                     |   1 +
 arch/x86/kvm/vmx/vmcs12.h                     |   3 +-
 arch/x86/kvm/vmx/vmx.c                        |  26 ++--
 arch/x86/kvm/vmx/vmx.h                        | 106 ++++++++++++--
 arch/x86/kvm/x86.c                            | 130 ++++++++++++++++--
 arch/x86/kvm/x86.h                            |  24 +++-
 arch/x86/kvm/xen.c                            |   2 +-
 .../selftests/kvm/include/x86/processor.h     |   1 +
 tools/testing/selftests/kvm/x86/state_test.c  |   6 +
 .../selftests/kvm/x86/xcr0_cpuid_test.c       |  19 +++
 21 files changed, 498 insertions(+), 125 deletions(-)


base-commit: 0f61b1860cc3f52aef9036d7235ed1f017632193
-- 
2.51.0


