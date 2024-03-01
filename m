Return-Path: <kvm+bounces-10658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C08A86E733
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:29:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54A4728258A
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB2EF50D;
	Fri,  1 Mar 2024 17:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h1g0P1wb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08DF5224;
	Fri,  1 Mar 2024 17:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709314184; cv=none; b=MXXkpeVC7Owe2dl1oJKC8JVa/nOfe2MjMZtw0mDXAOaT03QDBkvb0moUcp520dEE9my+1YFadqm4hlDVy/4Ax6rtNmNJRYFAFRk+AOj5/p5JB+PUNbs+CnxlcD25kmtfPhFBRYdFdNEE0bRXAmZwvDJfw8F7Ah0I92KldZqCrkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709314184; c=relaxed/simple;
	bh=jMSg6LZKcjlzCjpvuqsCAcGkMT3EOrB6qDi5+Dp/aC0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=neRMURhA10UIqn1FFt4CbuwJEnqRGF2O6sGPgCo3VYecpjsPZYusltBOEt7gM1TBaWj1LUcpe69sMl5zGqaI1wprOYU44froAcE7Mxsf9bXe+5F3OBg7Dpx3f3FFIw/xE+v0jIpSnu137lW36QK3XAVGkUxN2inZGLk3p1DZyTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h1g0P1wb; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709314182; x=1740850182;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jMSg6LZKcjlzCjpvuqsCAcGkMT3EOrB6qDi5+Dp/aC0=;
  b=h1g0P1wbN/MU66A6yVKbwxbwu+VdE15/tkxQaKB87UXnn0Aqjju+VXtO
   Wn0LAJZnvhLEGH8H1jjxHWT2gHd4HSpQXPhbQ2IIso3V7glDpS2yu/ph7
   AhkySJbpXP3k1dnd0JzVzNwW1KUxi1TK6O4tnpni2cZvmcmBERHMd/Mg6
   QfRTI9eS6mgSF2J/h+YfMX7qEPuneOlvSBg2Qj6i0b3uUPJqCf/4U5ZDR
   6cDibiqxGrelRACoRp7l/HTZUjq3KV7V411XR+SYn8oYqjB8tx7DeLeMJ
   l72gHWJkLiN5QHqhsQo96grnbrzDKnsh73INdyq/agvv2hQGpP0+52cEu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11000"; a="6812372"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="6812372"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="12946510"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:22 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>
Subject: [RFC PATCH 0/8] KVM: Prepopulate guest memory API
Date: Fri,  1 Mar 2024 09:28:42 -0800
Message-Id: <cover.1709288671.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

The objective of this RFC patch series is to develop a uAPI aimed at
(pre)populating guest memory for various use cases and underlying VM
technologies.

- Pre-populate guest memory to mitigate excessive KVM page faults during guest
  boot [1], a need not limited to any specific technology.

- Pre-populating guest memory (including encryption and measurement) for
  confidential guests [2].  SEV-SNP, TDX, and SW-PROTECTED VM.  Potentially
  other technologies and pKVM.

The patches are organized as follows.
- 1: documentation on uAPI KVM_MAP_MEMORY.
- 2: archtechture-independent implementation part.
- 3-4: refactoring of x86 KVM MMU as preparation.
- 5: x86 Helper function to map guest page.
- 6: x86 KVM arch implementation.
- 7: Add x86-ops necessary for TDX and SEV-SNP.
- 8: selftest for validation.

Discussion point:

uAPI design:
- access flags
  Access flags are needed for the guest memory population.  We have options for
  their exposure to uAPI.
  - option 1. Introduce access flags, possibly with the addition of a private
              access flag.
  - option 2. Omit access flags from UAPI.
    Allow the kernel to deduce the necessary flag based on the memory slot and
    its memory attributes.

- SEV-SNP and byte vs. page size
  The SEV correspondence is SEV_LAUNCH_UPDATE_DATA.  Which dictates memory
  regions to be in 16-byte alignment, not page size.  Should we define struct
  kvm_memory_mapping in bytes rather than page size?

  struct kvm_sev_launch_update_data {
        __u64 uaddr;
        __u32 len;
  };

- TDX and measurement
  The TDX correspondence is TDH.MEM.PAGE.ADD and TDH.MR.EXTEND.  TDH.MEM.EXTEND
  extends its measurement by the page contents.
  Option 1. Add an additional flag like KVM_MEMORY_MAPPING_FLAG_EXTEND to issue
            TDH.MEM.EXTEND
  Option 2. Don't handle extend. Let TDX vendor specific API
            KVM_EMMORY_ENCRYPT_OP to handle it with the subcommand like
            KVM_TDX_EXTEND_MEMORY.

- TDX and struct kvm_memory_mapping:source
  While the current patch series doesn't utilize
  kvm_memory_mapping::source member.  TDX needs it to specify the source of
  memory contents.

Implementation:
- x86 KVM MMU
  In x86 KVM MMU, I chose to use kvm_mmu_do_page_fault().  It's not confined to
  KVM TDP MMU.  We can restrict it to KVM TDP MMU and introduce an optimized
  version.

[1] https://lore.kernel.org/all/65262e67-7885-971a-896d-ad9c0a760907@polito.it/
[2] https://lore.kernel.org/all/6a4c029af70d41b63bcee3d6a1f0c2377f6eb4bd.1690322424.git.isaku.yamahata@intel.com

Thanks,

Isaku Yamahata (8):
  KVM: Document KVM_MAP_MEMORY ioctl
  KVM: Add KVM_MAP_MEMORY vcpu ioctl to pre-populate guest memory
  KVM: x86/mmu: Introduce initialier macro for struct kvm_page_fault
  KVM: x86/mmu: Factor out kvm_mmu_do_page_fault()
  KVM: x86/mmu: Introduce kvm_mmu_map_page() for prepopulating guest
    memory
  KVM: x86: Implement kvm_arch_{, pre_}vcpu_map_memory()
  KVM: x86: Add hooks in kvm_arch_vcpu_map_memory()
  KVM: selftests: x86: Add test for KVM_MAP_MEMORY

 Documentation/virt/kvm/api.rst                |  36 +++++
 arch/x86/include/asm/kvm-x86-ops.h            |   2 +
 arch/x86/include/asm/kvm_host.h               |   6 +
 arch/x86/kvm/mmu.h                            |   3 +
 arch/x86/kvm/mmu/mmu.c                        |  30 ++++
 arch/x86/kvm/mmu/mmu_internal.h               |  70 +++++----
 arch/x86/kvm/x86.c                            |  83 +++++++++++
 include/linux/kvm_host.h                      |   4 +
 include/uapi/linux/kvm.h                      |  15 ++
 tools/include/uapi/linux/kvm.h                |  14 ++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/map_memory_test.c    | 136 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |  74 ++++++++++
 13 files changed, 448 insertions(+), 26 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/map_memory_test.c


base-commit: 6a108bdc49138bcaa4f995ed87681ab9c65122ad
-- 
2.25.1


