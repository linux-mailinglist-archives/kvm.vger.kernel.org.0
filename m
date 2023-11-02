Return-Path: <kvm+bounces-415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 061FE7DF7AE
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 17:33:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64E51B21372
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 16:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE07208AF;
	Thu,  2 Nov 2023 16:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="enG+SBUb"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39628200B7
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 16:33:13 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B6112D;
	Thu,  2 Nov 2023 09:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698942789; x=1730478789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Rx30kV34VqF67UIAymgDYBdZ21FZrZga0jsqNzydYSw=;
  b=enG+SBUbE0KOboWt7gQc6gkZDyOD1sRILsQ9TlqOeJL66CoI8i70NCi/
   8zbHWNiHCg4WGnr3nh796Uf2d/1GEWYo6S38TKKxCYs1wv1ltaJp0kP4P
   L/mLsqZNeVkQkwnqe1R93r/bCB7HcWi5sYPfHDC/QavfNue5WKcuKFO4d
   cf9JDgpdiIvs3zR7FHRFl2PxPiJ2AXJPVMH16BgbD7epKu9EMF9t2Rsdj
   1KH0XYcD7VmBI67kJKbUnOQBcFImwmUsktxbNboRsuyO9eS0dtYUomQ9m
   sdoAILDqSOAQpTXM4IcUeK0GUhqJ4VYAd/6XLFunYutgs/iQ2HlRfvXHZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="388570853"
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="388570853"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 09:33:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="9448403"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.159.65])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 09:33:04 -0700
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
Subject: [RFC PATCH v1 1/8] KVM: selftests: x86: Fix bug in addr_arch_gva2gpa()
Date: Thu,  2 Nov 2023 23:51:04 +0800
Message-Id: <20231102155111.28821-2-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231102155111.28821-1-guang.zeng@intel.com>
References: <20231102155111.28821-1-guang.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Fix the approach to get page map from gva to gpa.

If gva maps a 4-KByte page, current implementation of addr_arch_gva2gpa()
will obtain wrong page size and cannot derive correct offset from the guest
virtual address.

Meanwhile using HUGEPAGE_MASK(x) to calculate the offset within page
(1G/2M/4K) mistakenly incorporates the upper part of 64-bit canonical
linear address. That will work out improper guest physical address if
translating guest virtual address in supervisor-mode address space.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d8288374078e..9f4b8c47edce 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -293,6 +293,7 @@ uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 	if (vm_is_target_pte(pde, level, PG_LEVEL_2M))
 		return pde;
 
+	*level = PG_LEVEL_4K;
 	return virt_get_pte(vm, pde, vaddr, PG_LEVEL_4K);
 }
 
@@ -496,7 +497,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	 * No need for a hugepage mask on the PTE, x86-64 requires the "unused"
 	 * address bits to be zero.
 	 */
-	return PTE_GET_PA(*pte) | (gva & ~HUGEPAGE_MASK(level));
+	return PTE_GET_PA(*pte) | (gva & (HUGEPAGE_SIZE(level) - 1));
 }
 
 static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
-- 
2.21.3


