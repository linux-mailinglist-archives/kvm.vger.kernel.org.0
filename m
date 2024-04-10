Return-Path: <kvm+bounces-14156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4FD8A02D6
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83C24285E79
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181BC184125;
	Wed, 10 Apr 2024 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="INwqHWjb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD9D15EFAD;
	Wed, 10 Apr 2024 22:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786876; cv=none; b=RcWxKwU5gBH25BNB9NgkXdaY2SNXVm76NbiE8+DU4+N8dIMYaCW644DvFk8c1gAbSgLjP+AxjeQzrTc9EAAOe1G6orzHXOzVwqab3hx7ejZPQhzMAYYlAV1U5RxDoJHT0n1WOKPTTkqsEByyWOSQ8t+2eutTRqhfXZaOg1oCVn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786876; c=relaxed/simple;
	bh=SIKF01Wa8K/fcxDXeqv3gdOKFQzRFMM9XrVm+jAOVHU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CzRG/Ca1NutzY0xHvs2SP3L1q8QiyaEJ5SX9BpTo9eEeM864Opth4BHNusln+twPzM5dkASJJPL98+Bbp91ism1LwfOaB4ktLeVbi07WO0nfoi20IRBh5IlZIWBxsAtKa+b1YDCYw1MjGT1fQN7xu5tkcl/K/t44Ba1w0o4+b2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=INwqHWjb; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712786874; x=1744322874;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SIKF01Wa8K/fcxDXeqv3gdOKFQzRFMM9XrVm+jAOVHU=;
  b=INwqHWjb5/qPnOE+CWCNLRe+OCGghYUfAqLL4X0ZFjTy6BqWLm7J3ZlY
   B/iFGuiE5w9V8iB27Kl1MCOBs8KhhN/4QC9XQdpp1h5JuVZn9pPhE3lTq
   efaWoHBGzEHtIatDdtOLp+icCfXJFK1ptFHeQbcauqSFxfZNhdIxwnthS
   j8EuWuEQ6bWty6wBfWB+vMCuzeTYV11mPrYLD9+erQWpayfmN15Hv9EHt
   OG9VQwMj9eisc4pt8bWBAPbBkvAo+m7ikTlJ7fQlzhctfvnXMDPMLtMm3
   qeBU2Etm4bPsfYGKP0DD4T4RsTMM+RrV3wYGuj4g9+nhAe0O/5CcD2VDY
   A==;
X-CSE-ConnectionGUID: XKu/NtywTbycaB0WER4mkw==
X-CSE-MsgGUID: 7G/1PsANS2m00UP+yzUghg==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8041099"
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="8041099"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:53 -0700
X-CSE-ConnectionGUID: ZORpMvVRTdOThpCixHEDCg==
X-CSE-MsgGUID: VKIwjH8kTQ2fPd+sRAUgoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="25476289"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:52 -0700
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 00/10] KVM: Guest Memory Pre-Population API
Date: Wed, 10 Apr 2024 15:07:26 -0700
Message-ID: <cover.1712785629.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Thank you for the feedback on the v1 patch series [1].  I updated the series
based on the v1 review.  The intention is to come up with an agreement on uAPI
and to get merged into the kvm-coco-queue branch first so that the TDX KVM patch
series can reduce the number of patches.


TL;DR
TDX (or other TEE technologies) needs to pre-populate private memory as the
initial guest memory with measurement.  TDX KVM defined TDX-specific API for it.
However, Pre-population also has another use case [2] to mitigate excessive KVM
page faults during guest boot or after live migration.  It applies to not only
confidential guests but also any guest type.

The patch series v1 [1] implemented the pre-population with CoCo operations.
The major feedback is to make the API for a "pure" population and to introduce
vendor-specific APIs for CoCo operations.  The population API doesn't do any
CoCo (or whatever backend technologies) specific operation.  The changes from
v1 are, dropping flags, allowing larger mapping, dropping coco-operation for
pure KVM mapping, restricting the API to TDP MMU only, and making structure in
byte instead of page size.  Dropped patches needed for TDX.


Details of feedback and changes:
- Pure KVM mapping without additional operation (Sean, Michael)
  Changed the behavior to not issue any additional operation.  Leave it to
  vendor-specific API.  It's difficult to have common operations because coco
  technologies have their requirement.  For example, SEV requires more
  parameters for guest memory initialization.  TDX optionally extends
  measurement with memory contents.  The TDX-specific API will check if the GFN
  is mapped and issue TDX-specific operations.
  https://lore.kernel.org/kvm/Ze-TJh0BBOWm9spT@google.com/
  https://lore.kernel.org/kvm/Ze-XW-EbT9vXaagC@google.com/

- Restrict the API to TDP MMU (David)
  Narrow down the API scope to TDP MMU only for simplicity.  It returns an error
  when vCPU is in the legacy KVM MMU mode or guest mode.  They require more
  consideration and complex implementation.  Given the use case is
  pre-population, we can safely assume vCPU is not in guest mode.
  https://lore.kernel.org/kvm/ZekQFdPlU7RDVt-B@google.com/

- Drop flags for KVM page fault. (Sean, David, Michael, Kai)
  Drop all defined flags.  Make flags reserved for future use.  Only RW mapping
  is useful for pre-population use cases.  Narrow down the API as the initial
  API because deprecating API is difficult.
  https://lore.kernel.org/kvm/ZepptFuo5ZK6w4TT@google.com/

- Allow mapping level larger than request (David)
  Allow huge page mapping larger than request because it doesn't have to be
  exact mapping for the supposed use case.  gmem_max_level() hook allows the
  vendor-backend to specify the desired level.
  https://lore.kernel.org/kvm/CALzav=dHNYP02q_CJncwk-JdL9OSB=613v4+siBm1Cp2rmxLLw@mail.gmail.com/

- Use byte length instead of number of pages (Michael)
  Changed struct kvm_mapping to use byte length instead of page size.  Because
  we may want sub-page operations, use byte instead of page to avoid unnecessary
  future API changes.
  https://lore.kernel.org/kvm/20240311032051.prixfnqgbsohns2e@amd.com/


This patch series depends on the following patch series, which enhance
KVM page fault handler, on the top of the KVM queue branch
  https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=queue

- https://lore.kernel.org/kvm/20240228024147.41573-1-seanjc@google.com/
  [PATCH 00/16] KVM: x86/mmu: Page fault and MMIO cleanups

The organization of this patch series is as follows.
1: Documentation on uAPI KVM_MAP_MEMORY.
2: Archtechture-independent implementation part with uAPI definition.
3: Refactoring of x86 KVM MMU as preparation.
4: Preparation for the next patch.
5: Add an x86 KVM MMU helper function to map the guest page.
6: x86 KVM arch implementation.
7: Enhancement of x86 KVM arch implementation to enforce L1 GPA independent
   of vCPU mode.
8: Add x86-ops necessary for TDX and SEV-SNP.
9: SEV callback to return an error.
10: Selftest for validation.

---
The objective of this RFC patch series is to develop a uAPI aimed at
pre-populating guest memory for various use cases and underlying VM
technologies.

Pre-populating guest memory to mitigate excessive KVM page faults during guest
boot [2] or after live migration is a need not limited to any specific
technology.  Also, it applies to the case after live migration on the
destination.  KVM_MAP_MEMORY only populates the second-level page tables and
doesn't do further technology-specific operations.  For example, CoCo-related
operations like SEV-SNP RMP operation, TDX TDH.MEM.PAGE.ADD() and
TDH.MR.EXTEND(). Use technology-specific APIs for it.

The existing mmap(MAP_POPULATE) or madvise(MADV_WILLNEED) don't help because it
interacts with the CPU page tables, not with the second-level page tables for
virtualization (AMD NPT, Intel EPT, ARM state-2 page table, RISC-V G-stage page
table, etc.)

For x86 default VM (SVM or VMX) or other x86 VM type that uses the TDP page
table SW-PROTECTED VM, SEV/SEV-SNP, TDX, and pKVM, the API populates the TDP
page tables.  Although this patch series implements it for x86 KVM, the uAPI
should be applicable to other architecture that supports the second-level page
tables, such as the ARM stage-2 page table and RISC-V G-stage page table.  Other
CoCo technology KVM support like ARM CCA RMM or RISC-V CoVE would introduce the
vendor-specific uAPI.

- KVM_MAP_MEMORY: Populate the second-level page table.
  x86 VM populates the TDP page tables.
  The technology will define if KVM_MAP_MEMORY is optional or mandatory.  Or it
  may not support the API by returning -EOPNOTSUPP.

- vendor-specific APIs:
  SEV: KVM_SEV_LAUNCH_MEASURE and guest_memfd prepare hook.
       KVM_MAP_MEMORY is optional for SEV-SNP because the second-level page
       table (NPT) is not protected.  It introduces the Reverse Map Table (RMP)
       to track the correspondence from the host physical address to the guest
       physical address.  The RMP is protected independently from NPT and the
       host VMM uses the dedicated instruction (RMPUPDATE, PSMASH).  It doesn't
       matter whether the GFN is populated with NPT or not because
       KVM_SEV_LAUNCH_MEASURE works with RMP and PFN only.

       [PATCH v12 11/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
       https://lore.kernel.org/kvm/20240329225835.400662-12-michael.roth@amd.com/

       [PATCH v12 21/29] KVM: SEV: Implement gmem hook for initializing private pages
       https://lore.kernel.org/kvm/20240329225835.400662-22-michael.roth@amd.com/
       
  TDX: KVM_TDX_INIT_MEM_REGION
       KVM_MAP_MEMORY is mandatory for TDX.  Return an error for not
       pre-populated GFN.  TDX protects the second level page table which is
       called Secure-EPT with its operations like TDH.MEM.SEPT.ADD(),
       TDH.MEM.PAGE.ADD(), etc.  The non-leaf entries need to be populated to
       add the leaf private page to the guest.

       https://lore.kernel.org/kvm/ZfBkle1eZFfjPI8l@google.com/
       
  ARM CCV RMM and RISC-V CoVE would define their uAPIs and determine if
  KVM_MAP_MEMORY is optional, mandatory, or unsupported because these two
  technologies are similar to TDX or SEV-SNP as the following is a small summary
  of technologies:
  ARM CCV RMM introduces the Realm Translation Table (RTT) as the stage two
  translation table.  The contents of an RTT are not directly accessible to the
  host with RMM commands like RMI_DATA_CREATE(), RMI_DATA_CREATE_UNKNOWN(), and
  RMI_RTT_CREATE(), etc.
  RISC-V CoVE introduces the Memory Tracking Table (MTT) to track the host
  physical address is whether confidential or non-confidential, etc with the
  operations like sbi_covh_add_tvm_page_table_pages(),
  sbi_covh_add_tvm_measured_pages(), sbi_covh_add_tvm_zero_pages(), etc.  The
  host VMM has no access to the G-stage page table.

Changes:
v2:
- Drop flags for KVM page fault
- Allow mapping larger than the request
- Change struct kvm_memory_mapping.  Dropped source. Make them in bytes.
- Make KVM_MAP_MMEORY pure mapping.  It takes no further action like copying
  memory contents, measurement, etc.
- Restrict the API to TDP MMU only.

v1:
[1] https://lore.kernel.org/kvm/cover.1709288671.git.isaku.yamahata@intel.com/

[2] https://lore.kernel.org/all/65262e67-7885-971a-896d-ad9c0a760907@polito.it/
[3] https://lore.kernel.org/all/6a4c029af70d41b63bcee3d6a1f0c2377f6eb4bd.1690322424.git.isaku.yamahata@intel.com

Thanks,

Isaku Yamahata (10):
  KVM: Document KVM_MAP_MEMORY ioctl
  KVM: Add KVM_MAP_MEMORY vcpu ioctl to pre-populate guest memory
  KVM: x86/mmu: Extract __kvm_mmu_do_page_fault()
  KVM: x86/mmu: Make __kvm_mmu_do_page_fault() return mapped level
  KVM: x86/mmu: Introduce kvm_tdp_map_page() to populate guest memory
  KVM: x86: Implement kvm_arch_vcpu_map_memory()
  KVM: x86: Always populate L1 GPA for KVM_MAP_MEMORY
  KVM: x86: Add a hook in kvm_arch_vcpu_map_memory()
  KVM: SVM: Implement pre_mmu_map_page() to refuse KVM_MAP_MEMORY
  KVM: selftests: x86: Add test for KVM_MAP_MEMORY

 Documentation/virt/kvm/api.rst                |  52 ++
 arch/x86/include/asm/kvm-x86-ops.h            |   1 +
 arch/x86/include/asm/kvm_host.h               |   3 +
 arch/x86/kvm/mmu.h                            |   3 +
 arch/x86/kvm/mmu/mmu.c                        |  32 ++
 arch/x86/kvm/mmu/mmu_internal.h               |  36 +-
 arch/x86/kvm/svm/sev.c                        |   6 +
 arch/x86/kvm/svm/svm.c                        |   2 +
 arch/x86/kvm/svm/svm.h                        |   9 +
 arch/x86/kvm/x86.c                            |  82 +++
 include/linux/kvm_host.h                      |   3 +
 include/uapi/linux/kvm.h                      |   9 +
 tools/include/uapi/linux/kvm.h                |   8 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/map_memory_test.c    | 479 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |  54 ++
 16 files changed, 769 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/map_memory_test.c


base-commit: 14009f39d2632aef6ef2421e21791144f2da8dab
prerequisite-patch-id: 1ca598b4dc0b7450f5e92f0f112bb810194ca31e
prerequisite-patch-id: 06e681d29f9bc5141760fbc173170eb5f6b0b448
prerequisite-patch-id: 79e9efbb9666bc38062052a94d3fe0950f666538
prerequisite-patch-id: b7df4f4b0a76cc89a33e0af033614ac41fc9a125
prerequisite-patch-id: 05ee88161ea93139190133de4bc1639ffeb999b5
prerequisite-patch-id: 2f163bc188dad6bc3ca51ad4a39de0c70b8a926f
prerequisite-patch-id: f9f4a66755c1f5728f4bdc663969c93da305af4f
prerequisite-patch-id: a5f7010a12eb69c65e1e998ef3750a0c9fb276c9
prerequisite-patch-id: ad620e25babeff7472a48311fc2903971777c1fb
prerequisite-patch-id: 34dc0058454f08f7e7e0e87ceb6073de2839eb18
prerequisite-patch-id: 7c348b473163f44046c2f28c728dbb66e42045f6
prerequisite-patch-id: 296a4b916d1261fcdf8ad1c3bb1b0ed454ccc312
prerequisite-patch-id: 5952fd4611ae5367b9378f4a37d31e2228975717
prerequisite-patch-id: 8371f63d5fbb091ec7daa6b39a6e0263415b3e56
prerequisite-patch-id: 7492a030d6b475bda7357b20f6ba08665a8ff79b
prerequisite-patch-id: 219902bb30027256f999eb311e1e3869752cd6f9
-- 
2.43.2


