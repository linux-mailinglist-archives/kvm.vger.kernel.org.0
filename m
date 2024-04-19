Return-Path: <kvm+bounces-15252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DEB88AADB6
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:30:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B78ED1F21E76
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 11:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E35823C8;
	Fri, 19 Apr 2024 11:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g3BS/44h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5D578285;
	Fri, 19 Apr 2024 11:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713526199; cv=none; b=JolqtklZ5goBhondkOzX54clQEsRJu8rypngtbvE5y2toeASLF4eozdPW9VxfE34i6H1AFkEeS60yKFcgV57hzFK1vDMXQ8QSzyoYsTYs5GMZNB4Ea/XrW2Tuz4RCkLUZd+kUJvtbyIvSDIf/VGHFJvRroE69EruEyJ2iR770HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713526199; c=relaxed/simple;
	bh=+bgZ66r1XGRBk2c6wtWJJhlAaqhyQ4KaIrVWshIh8zA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ug73NuXGCUlydZdKm/QuiC/z7sGVADV8h4qQxYkFPVanYdb0M8416WzA7ywbiEcZVP3HojITVBv/KDQwNc9fosJVtDyePxiIEBuwZQJUETzcNBFz8LlWWnXMs4KoEx2cX56EcJP9+a+Wp7hoz0PQETXjVfNNNYMgVCNzpBGLzWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g3BS/44h; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713526197; x=1745062197;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+bgZ66r1XGRBk2c6wtWJJhlAaqhyQ4KaIrVWshIh8zA=;
  b=g3BS/44h4DneImDzo/n3Sn3UrnyvVOC4TB6tBuSpEZ/1CgAATDoynV1B
   sI32YS19MystuQZ8hG0GxFet5C7vQBeSxHwD2bfxBy1u1MAz79RVv4m2z
   tZ4l6OvMIZ4CDEMM20aD6fN1XljGxk0wFnMmGtKLgWKTU5Q7YbVILvUSc
   dJHkuqOkXauOww6XbeWg7UzouH5QRfjQo86xNiTIi3+IrsWK1rdZ67Xpt
   34gkRsIfkycElm2mL0zQmw1rhFvEMnNdZ6w4nWOjgLTIqaWZy/O8Jf9pi
   e0Ol8w9LwiBJ+kstzuNMiowW9DQ/YeIoTj5EWdUnk2sylHI3QRcESkzeZ
   g==;
X-CSE-ConnectionGUID: L8cyjuKoSSGkai2JJSwLQg==
X-CSE-MsgGUID: Dz/PEdN5Rnu7OVU5W3JkNw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="20513150"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="20513150"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 04:29:57 -0700
X-CSE-ConnectionGUID: w+ysnRBiRmaupn2nQVQRMg==
X-CSE-MsgGUID: KxMnYFbPQ5OyUTIfl97Pxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23389358"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmviesa008.fm.intel.com with ESMTP; 19 Apr 2024 04:29:55 -0700
From: Wei Wang <wei.w.wang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 0/5] KVM/x86: Enhancements to static calls
Date: Fri, 19 Apr 2024 19:29:47 +0800
Message-Id: <20240419112952.15598-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset addresses two primary concerns with the current
implementation related to static calls in kvm/x86:
1) It is implemented based on the assumption that static_call() cannot
handle undefined (i.e., NULL) hooks. As Sean pointed out, this is no
longer accurate as static_call() has treated a "NULL" pointer as a NOP
on x86.
2) Its usage is verbose and can lead to code alignment challenges, and the
addition of kvm_x86_ prefix to hooks at the static_call() sites hinders
code readability and navigation.

This patchset aims to rectify the above issues. Patch 4 and 5 are marked
as RFC, as they were not accepted yet at the idea level in the previous
discussions, so present the code changes here and give it one more try,
in case I didn't explain that well. Despite being marked as RFC, they've
gone through my tests (guest launch, a few vPMU tests, live migration
tests) without an issue.

v1->v2 changes:
- Replace static_call_cond() with static_call()
- Rename KVM_X86_SC to KVM_X86_CALL, and updated all the call sites
- Add KVM_PMU_CALL() 
- Add patch 4 and 5 to review the idea of removing KVM_X86_OP_OPTIONAL

Wei Wang (5):
  KVM: x86: Replace static_call_cond() with static_call()
  KVM: x86: Introduce KVM_X86_CALL() to simplify static calls of
    kvm_x86_ops
  KVM: x86/pmu: Add KVM_PMU_CALL() to simplify static calls of
    kvm_pmu_ops
  KVM: x86: Remove KVM_X86_OP_OPTIONAL
  KVM: x86/pmu: Remove KVM_X86_PMU_OP_OPTIONAL

 arch/x86/include/asm/kvm-x86-ops.h     | 100 ++++----
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  20 +-
 arch/x86/include/asm/kvm_host.h        |  14 +-
 arch/x86/kvm/cpuid.c                   |   2 +-
 arch/x86/kvm/hyperv.c                  |   6 +-
 arch/x86/kvm/irq.c                     |   2 +-
 arch/x86/kvm/kvm_cache_regs.h          |  10 +-
 arch/x86/kvm/lapic.c                   |  42 +--
 arch/x86/kvm/lapic.h                   |   2 +-
 arch/x86/kvm/mmu.h                     |   6 +-
 arch/x86/kvm/mmu/mmu.c                 |   4 +-
 arch/x86/kvm/mmu/spte.c                |   4 +-
 arch/x86/kvm/pmu.c                     |  31 +--
 arch/x86/kvm/smm.c                     |  44 ++--
 arch/x86/kvm/trace.h                   |  12 +-
 arch/x86/kvm/x86.c                     | 342 ++++++++++++-------------
 arch/x86/kvm/x86.h                     |   2 +-
 arch/x86/kvm/xen.c                     |   4 +-
 18 files changed, 317 insertions(+), 330 deletions(-)


base-commit: 49ff3b4aec51e3abfc9369997cc603319b02af9a
-- 
2.27.0


