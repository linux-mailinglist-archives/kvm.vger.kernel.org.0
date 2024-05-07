Return-Path: <kvm+bounces-16830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 827038BE44C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:38:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C6AF289B98
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 13:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10561649CD;
	Tue,  7 May 2024 13:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TWqIZCRg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BFE1635D0;
	Tue,  7 May 2024 13:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715088672; cv=none; b=JQVZ8onT4TrSV9xhCRKgRnM5x18BhxozjfJCcDCA4qpGikcZg0UCeznonAoyKCu08Pv0epINFmYicmRZlYTbw8A5Z8HvsGUVXMNPzhNq1JbSjXx9PBE0Mvsqf+rzzGA051HN4DT8FJg9sTHTvNKB4HTDREPUNTnVTdq5t4fbczE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715088672; c=relaxed/simple;
	bh=sh0U92ZUvgTe/aCZ+bkGqG/NncKUwjz4yL0ln1X82PE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kZhuGZudQODdBVdDfCz39LowkHxj8Z5GzTSHE+6jodjqlc6Odgl3BNfauesBrrO92zD4EoDF1miVd5tlKDUeQpeMnVsmjirNXRuQH2g+LWvqxbSPX5yXsnRqTsxns3zCY7EKhaTHIFAYuP3UuQB8aaJK9V/XFl6gicOVSFjR4aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TWqIZCRg; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715088670; x=1746624670;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sh0U92ZUvgTe/aCZ+bkGqG/NncKUwjz4yL0ln1X82PE=;
  b=TWqIZCRgLL0DyyuYub2YgbJC4rzsme2t+pP6s++g0tQ/6gw4oLwJmXQ8
   wW+fFY1cMKsG0L/z7g1xAaorPCwhyL5WSwRSCBlCocN0YczYQnnI7DgFt
   0yycYNAhm9hED/0sWP/hLOg/+p4QCjC8dklKd8/wOHGNRAxGq3Y3l266K
   KElz8onY+2Uqth5ChruphC9Z2W3A01813kO6bI6stjU1gln3o5kfGEg6l
   QH4Rd5cZOacn8INa5blgjrn59wA0ICRquUP7YcK8vL3f9krn0bf5YPPUl
   lldiMgQpRnrwOnJrwnre7b7C/tNOTz7CZgmYZ4jtpOBfAGewWg8PJ+N3M
   g==;
X-CSE-ConnectionGUID: YByrZyZdSM2O2/Sw5kPF6Q==
X-CSE-MsgGUID: 8gyFD6K/SK+7Ism9FGt6ew==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="28361542"
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="28361542"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 06:31:10 -0700
X-CSE-ConnectionGUID: ar19MniHT9SJvqj/tShcqQ==
X-CSE-MsgGUID: Xtsxs8SxSSCEB13dpoJFJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="33330769"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orviesa005.jf.intel.com with ESMTP; 07 May 2024 06:31:08 -0700
From: Wei Wang <wei.w.wang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v4 0/3] KVM/x86: Enhancements to static calls
Date: Tue,  7 May 2024 21:31:00 +0800
Message-Id: <20240507133103.15052-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset introduces the kvm_x86_call() and kvm_pmu_call() macros to
streamline the usage of static calls of kvm_x86_ops and kvm_pmu_ops. The
current static_call() usage is a bit verbose and can lead to code
alignment challenges, and the addition of kvm_x86_ prefix to hooks at the
static_call() sites hinders code readability and navigation. The use of
static_call_cond() is essentially the same as static_call() on x86, so it
is replaced by static_call() to simplify the code. The changes have gone
through my tests (guest launch, a few vPMU tests, live migration tests)
without an issue.

v3->v4 change:
- Rename KVM_X86_CALL() to kvm_x86_call() and KVM_PMU_CALL() to
  kvm_pmu_call() as they resemble functions, so the lower-case style
  looks more readable.

v2->v3 changes:
- Change the KVM_X86_CALL() definition to have the parameters in their
  owen paratheses.
- Update the .get_cpl() hook in pmu.c to use KVM_X86_CALL().
  (it was omitted in v2)

v1->v2 changes:
- Replace static_call_cond() with static_call()
- Rename KVM_X86_SC to KVM_X86_CALL, and updated all the call sites
- Add KVM_PMU_CALL() 
- Add patch 4 and 5 to review the idea of removing KVM_X86_OP_OPTIONAL

Wei Wang (3):
  KVM: x86: Replace static_call_cond() with static_call()
  KVM: x86: Introduce kvm_x86_call() to simplify static calls of
    kvm_x86_ops
  KVM: x86/pmu: Add kvm_pmu_call() to simplify static calls of
    kvm_pmu_ops

 arch/x86/include/asm/kvm_host.h |  11 +-
 arch/x86/kvm/cpuid.c            |   2 +-
 arch/x86/kvm/hyperv.c           |   6 +-
 arch/x86/kvm/irq.c              |   2 +-
 arch/x86/kvm/kvm_cache_regs.h   |  10 +-
 arch/x86/kvm/lapic.c            |  42 +++--
 arch/x86/kvm/lapic.h            |   2 +-
 arch/x86/kvm/mmu.h              |   6 +-
 arch/x86/kvm/mmu/mmu.c          |   4 +-
 arch/x86/kvm/mmu/spte.c         |   4 +-
 arch/x86/kvm/pmu.c              |  29 +--
 arch/x86/kvm/smm.c              |  44 ++---
 arch/x86/kvm/trace.h            |  15 +-
 arch/x86/kvm/x86.c              | 322 ++++++++++++++++----------------
 arch/x86/kvm/x86.h              |   2 +-
 arch/x86/kvm/xen.c              |   4 +-
 16 files changed, 259 insertions(+), 246 deletions(-)


base-commit: aec147c18856fa7115e14b9ad6a91c3ed2cf2e19
-- 
2.27.0


