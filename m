Return-Path: <kvm+bounces-18510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA1E8D5D89
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:04:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9AD3288DF7
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 09:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCAD3156862;
	Fri, 31 May 2024 09:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ms5XktFO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D44155CB4;
	Fri, 31 May 2024 09:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717146241; cv=none; b=paCt4BufyhRaHFyakEVlI2XQfExmXs9fluK9Zr3HtFY6sD4lRvO8lfOEFZuUKAFM+hjq2hQWqRYr30OsGbxYcJQMyG/SZKB0Z2zxTlpmmeNCeQATKpRp6D8BJxNO92WuGYWGHv2DoJYyd3fFXisWTKn1UcAgSoFm8u+gMe9xZ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717146241; c=relaxed/simple;
	bh=I0bGr5yXXQvBH92i/MM1H8K0WJgO/wpihzV4iteId4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xz4e6cWi0KdlJKxdS/Ka4Yua9cmL3j4Tu5E03pLgeVoLT2XcIRTf9x7H+YY6KxmAIVAv4zgzVtvHce10rgwCvAvTGkXAgTCM+u4LLVihO3+tpAYpJAlv+IXeX/Ml2J277oWNLDTtrYwdIZWeS7cyltiQYhTWsmLGHDL4PMsMaJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ms5XktFO; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717146239; x=1748682239;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=I0bGr5yXXQvBH92i/MM1H8K0WJgO/wpihzV4iteId4Q=;
  b=ms5XktFOdcciOiDglhKe3WVL7OPw2MKBxPGiOhVXp+aL86IkhK8G9+4W
   W/kYnWgMMnAKYraQnJyG8JL3FE/49SucXzo0ElA3HVg46teQfIuyMzXYv
   hxxuaRX1B35pLnVECfVWkIQcaU1IwOXWuJNj3fmvd3sf3IgmVKCze0KL4
   XLlzJsrbuFfDPWnhqit2LBSqMxhAe8oQZBeUH/pKZBkklbxVmlRZSlCwJ
   2q5EU3L1BG9GegBl3MLcWU42l8folQeT2DLWIxZMLHYdNCXalAK54AwNt
   Xt9PTVq4vLGOfT7uecFU76zb66VrAdZmZF7a8LfeqKNWTHEa476AAUW1k
   Q==;
X-CSE-ConnectionGUID: A6dfvAHSTcKtqlQaqcVvzA==
X-CSE-MsgGUID: DiAK/4d+Tra7j2d7GPa06A==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="17480579"
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="17480579"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 02:03:58 -0700
X-CSE-ConnectionGUID: VsG6pjvOQtSXzE7bScY08w==
X-CSE-MsgGUID: 5VMMdoCUTHm+kfp1jzwWHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="36102732"
Received: from jf.jf.intel.com ([10.165.9.183])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 02:03:58 -0700
From: Yang Weijiang <weijiang.yang@intel.com>
To: tglx@linutronix.de,
	dave.hansen@intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	weijiang.yang@intel.com,
	john.allen@amd.com
Subject: [PATCH 0/6] Introduce CET supervisor state support
Date: Fri, 31 May 2024 02:03:25 -0700
Message-ID: <20240531090331.13713-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series spins off from CET KVM virtualization enabling series [1].
The purpose is to get these preparation work resolved ahead of KVM part
landing. There was a discussion about introducing CET supervisor state
support [2] [3].

CET supervisor state, i.e., IA32_PL{0,1,2}_SSP, are xsave-managed MSRs,
it can be enabled via IA32_XSS[bit 12]. KVM relies on host side CET
supervisor state support to fully enable guest CET MSR contents storage.
The benefits are: 1) No need to manually save/restore the 3 MSRs when
vCPU fpu context is sched in/out. 2) Omit manually swapping the three
MSRs at VM-Exit/VM-Entry for guest/host. 3) Make guest CET user/supervisor
states managed in a consistent manner within host kernel FPU framework.

This series tries to:
1) Fix existing issue regarding enabling guest supervisor states support.
2) Add CET supervisor state support in core kernel.
3) Introduce new FPU config for guest fpstate setup.

With the preparation work landed, for guest fpstate, we have xstate_bv[12]
== xcomp_bv[12] == 1 and CET supervisor state is saved/reloaded when
xsaves/xrstors executes on guest fpstate.
For non-guest/normal fpstate, we have xstate_bv[12] == xcomp_bv[12] == 0,
then HW can optimize xsaves/xrstors operations.

Patch1: Preserve guest supervisor xfeatures in __state_perm.
Patch2: Enable CET supervisor xstate support.
Patch3: Introduce kernel dynamic xfeature set.
Patch4: Initialize fpu_guest_cfg settings.
Patch5: Create guest fpstate with fpu_guest_cfg.
Patch6: Check invalid fpstate config before executes xsaves.

[1]: https://lore.kernel.org/all/20240219074733.122080-1-weijiang.yang@intel.com/
[2]: https://lore.kernel.org/all/ZM1jV3UPL0AMpVDI@google.com/
[3]: https://lore.kernel.org/all/2597a87b-1248-b8ce-ce60-94074bc67ea4@intel.com/


Sean Christopherson (1):
  x86/fpu/xstate: Always preserve non-user xfeatures/flags in
    __state_perm

Yang Weijiang (5):
  x86/fpu/xstate: Add CET supervisor mode state support
  x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
  x86/fpu/xstate: Introduce fpu_guest_cfg for guest FPU configuration
  x86/fpu/xstate: Create guest fpstate with guest specific config
  x86/fpu/xstate: Warn if CET supervisor state is detected in normal
    fpstate

 arch/x86/include/asm/fpu/types.h  | 16 ++++++++--
 arch/x86/include/asm/fpu/xstate.h | 11 ++++---
 arch/x86/kernel/fpu/core.c        | 53 ++++++++++++++++++++++++-------
 arch/x86/kernel/fpu/xstate.c      | 35 +++++++++++++++-----
 arch/x86/kernel/fpu/xstate.h      |  2 ++
 5 files changed, 90 insertions(+), 27 deletions(-)


base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
-- 
2.43.0


