Return-Path: <kvm+bounces-43058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35B61A83AED
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:24:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E28DE7AC936
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDCDF20AF6C;
	Thu, 10 Apr 2025 07:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z8qZXiZU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D316C208989;
	Thu, 10 Apr 2025 07:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744269737; cv=none; b=fPYHrLbj4qgeKZYzgJ5y5eiq2CVJ5ODbAWDPLRr34B3LsHtqSnpR5mBj5bbzF15xeOGitGP5LRguKa0fi6OT+2zKb60vKaDR7mCTmgqHVxnot5Pp1+Tz/tfs23MsPQGyLefYjaqt5cxrK4l/srU/n6hqzX2EozePUDo+gpChkvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744269737; c=relaxed/simple;
	bh=YzLZelE6BsJucoUqF3YIzWb+b3HRdn6XVlfFQHzQmbU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e3Enk5fWASbVJILxZrsS3d8xP2rVE8AasR3/oh8wcMb57OQG4dOKJ6zzr6wX/pLRCPZdEj4hPxSE7cbt8YiIqmWb9fjCrMGe/DJWxlPZKHIbDWSYr0+YIDuDvFwoEJaveSGofYvlIWUTMoAPiaLgmcASQLmsARUvbbFotLEkxjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z8qZXiZU; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744269735; x=1775805735;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YzLZelE6BsJucoUqF3YIzWb+b3HRdn6XVlfFQHzQmbU=;
  b=Z8qZXiZU+Ql2M5BJnNwPl5e4iqj2VHq6sD6YuoEqdg4nJbByYvrcO0RX
   L7T5mYDVif+7Ik6ulnQlfsD1B7IqCfjoPCweQj3tOWbel3zIQTbaaNtWI
   EKsHzg7h+PJRYylclwknsEm7UN1xbyltw4LaxwSzhF75cgQph6UmCvrs9
   9ijoHF3ceJC4nnoj9C2vF56PMC4ImqKJDHTwhsWVyuRCBrU9OyJO5UHX6
   +zxo5yah6gnrz+wOyxS8214kfN7L6xXuJjMcUpLgID70cXKgmPRSQgKFu
   DWkfhud6mv71PG85csA3dKjE9JSbnfsmIuFMFrP5LDRiQmL8NO5NAuVgt
   Q==;
X-CSE-ConnectionGUID: QwmFwCppT0i2dIAQp6W9EQ==
X-CSE-MsgGUID: Wk0URf8vQLCBj6lpebqu9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="56439269"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="56439269"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:22:14 -0700
X-CSE-ConnectionGUID: vmLrXjDDR+i3GEhl2GhJCA==
X-CSE-MsgGUID: Nf07GllVRxSqinkQIy5+Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128778054"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:22:02 -0700
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
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Eric Biggers <ebiggers@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Uros Bizjak <ubizjak@gmail.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 0/7] Introduce CET supervisor state support
Date: Thu, 10 Apr 2025 15:24:40 +0800
Message-ID: <20250410072605.2358393-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Dear maintainers and reviewers,

I would appreciate your feedback on two unresolved issues:

1. Management of guest default features and sizes (patch 3)

The CET supervisor state will be added as a guest-only feature, causing
guest FPU default features and sizes to diverge from those of non-guest
FPUs. Calculating guest FPU default features and sizes at runtime based on
defaults in fpu_kernel/user_cfg is undesirable due to unnecessary runtime
overhead and the need for calculations in multiple places, such as during
vCPU fpstate allocation and FPU permission initialization.

The preferred approach is to calculate guest default features and sizes
at boot time and then cache them.

Versions v3 and earlier used a guest-specific fpu_state_config to hold
guest defaults, but the other fields in the struct were unused, suggesting
that fpu_guest_cfg might not be the best fit. In v4, inspired by the
existing independent_features field, I switched to adding guest defaults to
fpu_kernel/user_cfg. During the review, Chang suggested a cleaner and more
structured alternative by introducing a dedicated struct for guest
defaults. This v5 follows Chang's suggestion.

2. Naming of the guest-only feature mask (patch 6)

Instead of hard-coding the CET supervisor state in various places, we
establish an infrastructure that introduces a mask to abstract the features
necessary for guest FPUs, which are not enabled by non-guest FPUs.

The mask was previously named XFEATURE_MASK_KERNEL_DYNAMIC. It was slightly
preferred because it reflected the XSAVE buffer state (some buffers have
the features while others do not) rather than being tied to its
usage - KVM. However, this name led to confusion. In this v5, it has been
renamed to XFEATURE_MASK_GUEST_SUPERVISOR. Please refer to patch 6 for the
decision-making process.

Aside from these issues, I believe this series is in good shape. However,
since most of the patches have not yet received Reviewed-by/Acked-by tags,
please take a look at them as well.

Also, credit to Chang and Rick for their help with this series.

== Changelog ==
v4->v5:
 - Reorder patches to ensure new features come after cleanups and bug fixes
   (Chang, Dave, Ingo)
 - Add a dedicated structure for default xfeatures and sizes for guest FPUs
   (Chang)
 - Provide a detailed explanation for choosing XFEATURE_MASK_GUEST_SUPERVISOR
   (Chang)
 - Summarize the long history of the CET FPU series and the rationale behind
   the "guest-only" approach in the cover-letter and the last patch
 - Other minor changes; please see each patch for details. (Chang)
 - v4: https://lore.kernel.org/kvm/20250318153316.1970147-1-chao.gao@intel.com/

== Background ==

CET defines two register states: CET user, which includes user-mode control
registers, and CET supervisor, which consists of shadow-stack pointers for
privilege levels 0-2.

Current kernels disable shadow stacks in kernel mode, making the CET
supervisor state unused and eliminating the need for context switching.

== Problem ==

To virtualize CET for guests, KVM must accurately emulate hardware
behavior. A key challenge arises because there is no CPUID flag to indicate
that shadow stack is supported only in user mode. Therefore, KVM cannot
assume guests will not enable shadow stacks in kernel mode and must
preserve the CET supervisor state of vCPUs.

== Solution ==

An initial proposal to manually save and restore CET supervisor states
using raw RDMSR/WRMSR in KVM was rejected due to performance concerns and
its impact on KVM's ABI. Instead, leveraging the kernel's FPU
infrastructure for context switching was favored [1].

The main question then became whether to enable the CET supervisor state
globally for all processes or restrict it to vCPU processes. This decision
involves a trade-off between a 24-byte XSTATE buffer waste for all non-vCPU
processes and approximately 100 lines of code complexity in the kernel [2].
The agreed approach is to first try this optimal solution [3], i.e.,
restricting the CET supervisor state to guest FPUs only and eliminating
unnecessary space waste.

Key changes in this series are:

1) Fix existing issue regarding enabling guest supervisor states support.
2) Add default features and size for guest FPUs.
3) Add infrastructure to support guest-only features.
4) Add CET supervisor state as the first guest-only feature.

With the series in place, guest FPUs have xstate_bv[12] == xcomp_bv[12] == 1
and CET supervisor state is saved/reloaded when xsaves/xrstors executes on
guest FPUs. non-guest FPUs have xstate_bv[12] == xcomp_bv[12] == 0, then
CET supervisor state is not saved/restored.

== Performance ==

We measured context-switching performance with the benchmark [4] in following
three cases.

case 1: the baseline. i.e., this series isn't applied
case 2: baseline + this series. CET-S space is allocated for guest fpu only.
case 3: baseline + allocate CET-S space for all tasks. Hardware init
        optimization avoids writing out CET-S space on each XSAVES.

The performance differences in the three cases are very small and fall within the
run-to-run variation.

[1]: https://lore.kernel.org/kvm/ZM1jV3UPL0AMpVDI@google.com/
[2]: https://lore.kernel.org/kvm/1c2fd06e-2e97-4724-80ab-8695aa4334e7@intel.com/
[3]: https://lore.kernel.org/kvm/2597a87b-1248-b8ce-ce60-94074bc67ea4@intel.com/
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

Yang Weijiang (2):
  x86/fpu/xstate: Introduce "guest-only" supervisor xfeature set
  x86/fpu/xstate: Add CET supervisor xfeature support as a guest-only
    feature

 arch/x86/include/asm/fpu/types.h  | 81 +++++++++++++++++++++++++------
 arch/x86/include/asm/fpu/xstate.h |  9 ++--
 arch/x86/kernel/fpu/core.c        | 42 ++++++++++------
 arch/x86/kernel/fpu/xstate.c      | 60 +++++++++++++++++------
 arch/x86/kernel/fpu/xstate.h      |  5 ++
 5 files changed, 149 insertions(+), 48 deletions(-)


base-commit: ed91ad084ef9fa49f6c6dfef2cb10c12ce3786a6
-- 
2.46.1


