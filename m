Return-Path: <kvm+bounces-414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 527557DF7AA
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 17:33:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69FBF1C20F84
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 16:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C104200BE;
	Thu,  2 Nov 2023 16:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Th0d6+eU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48A41DFE4
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 16:33:11 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBF2123;
	Thu,  2 Nov 2023 09:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698942787; x=1730478787;
  h=from:to:cc:subject:date:message-id;
  bh=cdPiSKd/31m3AqChZgVeKDRUhuu5sQ7j4sET0CgQF7k=;
  b=Th0d6+eUPgQLiytFXHm+dPltt4U6RNigxg9+JNUpSjWu/5mc+8YlUDT5
   pMWr+2LE8bIRfT/Pbbp40TsUml8rrcssG7z/hmDk6aekPD1XpocxJ6njk
   dIpRLKUVCADRi/TtBocaJ9LJ7ir2FiGxZoGuLlqO/ODEDyBC7S9XxYFpp
   oqRzrFuyQcS1jTliWVgajmB22NLFX/yZaJYx9RKDgr6855mRaxYOd6F9l
   Fd2+MfXVKlU/Wv0Vus1GlAi/RpwWL/lEZTJKu0YjLyqcVCdWfltkGRgdX
   CgqvFFwXEDv1OZ09aVTpOrubX3mGS8rAEoMJ1LIaCtKNk1f5fdyFzFyvM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="388570836"
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="388570836"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 09:33:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="9448383"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.159.65])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 09:33:00 -0700
From: Zeng Guang <guang.zeng@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	Zeng Guang <guang.zeng@intel.com>
Subject: [RFC PATCH v1 0/8] KVM: seftests: Support guest user mode execution and running
Date: Thu,  2 Nov 2023 23:51:03 +0800
Message-Id: <20231102155111.28821-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

This patch series give a proposal to support guest VM running
in user mode and in canonical linear address organization as
well.

First design to parition the 64-bit canonical linear address space
into two half parts belonging to user-mode and supervisor-mode
respectively, similar as the organization of linear addresses used
in linux OS. Currently the linear addresses use 48-bit canonical
format in which bits 63:47 of the address are identical.

Secondly setup page table mapping the same guest physical address
of test code and data segment onto both user-mode and supervisor-mode
address space. It allows guest in different runtime mode, i.e.
user or supervisor, can run one code base in the corresponding
linear address space.

Also provide the runtime environment setup API for switching to
user mode execution.     


Zeng Guang (8):
  KVM: selftests: x86: Fix bug in addr_arch_gva2gpa()
  KVM: selftests: x86: Support guest running on canonical linear-address
    organization
  KVM: selftests: Add virt_arch_ucall_prealloc() arch specific
    implementation
  KVM : selftests : Adapt selftest cases to kernel canonical linear
    address
  KVM: selftests: x86: Prepare setup for user mode support
  KVM: selftests: x86: Allow user to access user-mode address and I/O
    address space
  KVM: selftests: x86: Support vcpu run in user mode
  KVM: selftests: x86: Add KVM forced emulation prefix capability

 .../selftests/kvm/include/kvm_util_base.h     |  20 ++-
 .../selftests/kvm/include/x86_64/processor.h  |  48 ++++++-
 .../selftests/kvm/lib/aarch64/processor.c     |   5 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   6 +-
 .../selftests/kvm/lib/riscv/processor.c       |   5 +
 .../selftests/kvm/lib/s390x/processor.c       |   5 +
 .../testing/selftests/kvm/lib/ucall_common.c  |   2 +
 .../selftests/kvm/lib/x86_64/processor.c      | 117 ++++++++++++++----
 .../selftests/kvm/set_memory_region_test.c    |  13 +-
 .../testing/selftests/kvm/x86_64/debug_regs.c |   2 +-
 .../kvm/x86_64/userspace_msr_exit_test.c      |   9 +-
 11 files changed, 195 insertions(+), 37 deletions(-)

-- 
2.21.3


