Return-Path: <kvm+bounces-41386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C545A677CE
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:30:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D068B3B73D5
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 15:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6257920E709;
	Tue, 18 Mar 2025 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H1zgCviM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD9B17A30D;
	Tue, 18 Mar 2025 15:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742311823; cv=none; b=LtD5yu9ytSs37uKOlOmuIG1rFeSdkDngvkeEFQ0Oj4Kvmq3vPoIPK0LUFtO1cl4Q7w60WlxlPYojdg/UjVpmVUglEDkxNuvMtNrhyycYAkg/NCr1bKypR0wst2Eg73RV/Om5qc9VtmVAyHl4IfjZg3Rjh4Vlo/jthY4vMNLKWgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742311823; c=relaxed/simple;
	bh=+SIo73UTTU2z5Vf1k6pxRbo/XOAy9cklFGnqrVYlfpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IntEPEroFLUJkcrZ69m0OsMspxtd9pd5s8cdQtvLEXtBBYybdfJmiymK09N8lusJMzqUz8PWxSO4WjEko6aeIL2osrrfnvC21iraZ4gElMw84lhk5V8Uer4wkM9ez2UleIfYkwRwgCV+knwQ6EFTda5DWMoScpGaI8XQwlONEBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H1zgCviM; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742311821; x=1773847821;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+SIo73UTTU2z5Vf1k6pxRbo/XOAy9cklFGnqrVYlfpQ=;
  b=H1zgCviM4/vC3wKS3wOybSk/Q7HwY0gsM39tRAmlikf8fPa7xmfrNmjD
   AWGtoPOcEqIXPQMAyDpyl87T5l/yeSURaF/a5JCbIfMTyAqRtzldUyuQO
   A2JY3yDu+Dhas2gHoBLkkjuQCXtmAO0PN1RLDM24Mq4jhXZSqddzhmAVC
   M6o5akCnr0FMMjxP35e+cD7ZaC/vmtZEK9kuLIs4qenMaug0Df/cYywHC
   z+covZSceM13zMuBGwc08j70KikOthJgQ5IC3JwVnhu8pinN1E9Vsjr1S
   cOeaPppd3pWd+5J226XzL3sxU8w7+rDMlRszFW63WTbFtXLwUSVI1pmj/
   A==;
X-CSE-ConnectionGUID: mWZ6+p6HTMqBY69vCAUG5Q==
X-CSE-MsgGUID: Y1MJ04k7T4q+eXGNPr3VfQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="46224081"
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="46224081"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:30:20 -0700
X-CSE-ConnectionGUID: 7rFWyapITSGRVQkQT70p4w==
X-CSE-MsgGUID: okfQd0iKQmOttwcNx41GhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="122121754"
Received: from spr.sh.intel.com ([10.239.53.19])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:30:09 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Adamos Ttofari <attofari@amazon.de>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Eric Biggers <ebiggers@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Li RongQing <lirongqing@baidu.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Uros Bizjak <ubizjak@gmail.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 0/8] Introduce CET supervisor state support
Date: Tue, 18 Mar 2025 23:31:50 +0800
Message-ID: <20250318153316.1970147-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

==Changelog==
v3->v4:
 - Remove fpu_guest_cfg.
   The fact that only the default_features and default_size fields of
   fpu_guest_cfg are used suggests that a full fpu_guest_cfg may not be
   necessary. Adding two members, "guest_default_xfeatures" and
   "guest_default_size", or even a single "guest_only_xfeatures" member in
   fpu_kernel_cfg, similar to "independent_xfeatures", is more logical. To
   facilitate discussion, implement this approach in this version.
 - Extract the fix for inconsistencies in fpu_guest and post it separately
   (Chang)
 - Rename XFEATURE_MASK_KERNEL_DYNAMIC to XFEATURE_MASK_SUPERVISOR_GUEST as
   tglx noted "this dynamic naming is really bad":

   https://lore.kernel.org/all/87sg1owmth.ffs@nanos.tec.linutronix.de/

 - Rerun performance tests and update the performance claims in the cover-letter
   (Dave)
 - Tighten down the changelogs and drop useless comments (Dave)
 - Reorder the patches to put the CET supervisor state patch before the
   "guest-only" optimization, allowing maintainers to easily adopt or omit the
   optimization.
 - v3: https://lore.kernel.org/kvm/20250307164123.1613414-1-chao.gao@intel.com/

v2->v3:
 - reorder patches to add fpu_guest_cfg first and then introduce dynamic kernel
   feature concept (Dave)
 - Revise changelog for all patches except the first and the last one (Dave)
 - Split up patches that do multiple things into separate patches.
 - collect tags for patch 1
 - v2: https://lore.kernel.org/kvm/20241126101710.62492-1-chao.gao@intel.com/

v1->v2:
 - rebase onto the latest kvm-x86/next
 - Add performance data to the cover-letter
 - v1: https://lore.kernel.org/kvm/73802bff-833c-4233-9a5b-88af0d062c82@intel.com/

==Background==

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

==Solution==

This series tries to:
1) Fix existing issue regarding enabling guest supervisor states support.
2) Add CET supervisor state support in core kernel.
3) Introduce guest default features and size for guest fpstate setup.

With the preparation work landed, for guest fpstate, we have xstate_bv[12]
== xcomp_bv[12] == 1 and CET supervisor state is saved/reloaded when
xsaves/xrstors executes on guest fpstate.
For non-guest/normal fpstate, we have xstate_bv[12] == xcomp_bv[12] == 0,
then HW can optimize xsaves/xrstors operations.

==Performance==

We measured context-switching performance with the benchmark [4] in following
three cases.

case 1: the baseline. i.e., this series isn't applied
case 2: baseline + this series. CET-S space is allocated for guest fpu only.
case 3: baseline + allocate CET-S space for all tasks. Hardware init
        optimization avoids writing out CET-S space on each XSAVES.

The performance differences in the three cases are very small and fall within the
run-to-run variation.

Case 2 is preferred over Case 3 because it can save 24B of CET-S space for all
non-vCPU threads with just a one-line change:

+	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_SUPERVISOR_GUEST

We believe adding guest defaults has its own merits. It improves readability,
decouples host FPUs and guest FPUs, and arguably enhances extensibility.

[1]: https://lore.kernel.org/all/20240219074733.122080-1-weijiang.yang@intel.com/
[2]: https://lore.kernel.org/all/ZM1jV3UPL0AMpVDI@google.com/
[3]: https://lore.kernel.org/all/2597a87b-1248-b8ce-ce60-94074bc67ea4@intel.com/
[4]: https://github.com/antonblanchard/will-it-scale/blob/master/tests/context_switch1.c


Chao Gao (4):
  x86/fpu: Drop @perm from guest pseudo FPU container
  x86/fpu/xstate: Differentiate default features for host and guest FPUs
  x86/fpu: Initialize guest FPU permissions from guest defaults
  x86/fpu: Initialize guest fpstate and FPU pseudo container from guest
    defaults

Sean Christopherson (1):
  x86/fpu/xstate: Always preserve non-user xfeatures/flags in
    __state_perm

Yang Weijiang (3):
  x86/fpu/xstate: Add CET supervisor xfeature support
  x86/fpu/xstate: Introduce "guest-only" supervisor xfeature set
  x86/fpu/xstate: Warn if guest-only supervisor states are detected in
    normal fpstate

 arch/x86/include/asm/fpu/types.h  | 58 ++++++++++++++++++++++---------
 arch/x86/include/asm/fpu/xstate.h |  9 +++--
 arch/x86/kernel/fpu/core.c        | 36 ++++++++++++-------
 arch/x86/kernel/fpu/xstate.c      | 42 +++++++++++++++-------
 arch/x86/kernel/fpu/xstate.h      |  2 ++
 5 files changed, 102 insertions(+), 45 deletions(-)

-- 
2.46.1


