Return-Path: <kvm+bounces-33765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 492909F16E9
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C317160F95
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 19:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D02081E5708;
	Fri, 13 Dec 2024 19:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KP3gOpyV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE43A19006B
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 19:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734119844; cv=none; b=ZQH8blF3zwE2ICTrduRbxqyXPjLTp+54fmF3dOgBFrT9jcURRXmLS4+ruMhjm2xJ9jLz+prtsPqEpuMzONywGRnT6fdiu5QdvmSSIJwaWQT2NZd77AHvL/LM9uFmHYhDiprhECEp5atP/p6P7NE9utTo3mN0owGNVa8xF37OKWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734119844; c=relaxed/simple;
	bh=XQPOlnlsT9x5JBg6YadRks4VXQOQqhLnQ7Lb15PXF08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sdzxdyWewj5K8rPa9a0BdS6B4Z20gNaSJZFS9D5Af6dqd/RAprZOKg+jArbvvjouSKUj9XGq++zzmUAn4Ey0XqdULFONnr+e7Ng8UaIXqP1mCwY8uJ2WUlXLy/eolk2wUuzWcKQrR8bV0YgVh7OvZGeU4OrOavZZb21Q+usGspU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KP3gOpyV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734119840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hm5h+ozmqAY9jlDeghJNCu8+0lOi1BgC1gMW31+G5gk=;
	b=KP3gOpyVTwBCKHktXf0njULd9WIIyqhtpDP5QbVJ2xSE5SvWaWUEGyBaLOQZKNOj8bXMI1
	/R7xtrqlf9XhAZXHCyAxJuLQsfgdzFOKVzMjlAZbJBVT+7Tz1o5/4JcSOB0nl3l7hnRNix
	Hq6e10QGmQKYOOgDusyRnflvD59t7a4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-37-aXI4XRVkON2OBc1ycjRjJQ-1; Fri,
 13 Dec 2024 14:57:15 -0500
X-MC-Unique: aXI4XRVkON2OBc1ycjRjJQ-1
X-Mimecast-MFC-AGG-ID: aXI4XRVkON2OBc1ycjRjJQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C25019560A6;
	Fri, 13 Dec 2024 19:57:13 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9A99D195605A;
	Fri, 13 Dec 2024 19:57:12 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v5 00/18] TDX MMU prep series part 1
Date: Fri, 13 Dec 2024 14:56:53 -0500
Message-ID: <20241213195711.316050-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hi,

this is the essentially final version of the TDX MMU prep series, focusing
on supporting TDX's separation of EPT into a direct part (for shared pages)
and a part that is managed by the TDX module and cached (into a "mirror"
EPT) by KVM.

The changes from v4 (https://patchew.org/linux/20240718211230.1492011-1-rick.p.edgecombe@intel.com/)
are minor:

- patch 7: kvm_tdp_mmu_handle_gfn is now __kvm_tdp_mmu_age_gfn_range

- patch 7: zap_collapsible_spte_range is now split into
  tdp_mmu_make_huge_spte and recover_huge_pages_range

- patch 10/12: KVM_INVALID_ROOTS used to mean "walk all invalid roots";
  now it means "walk *also* invalid roots of the kind (direct/mirror)
  specified by the other bits.  This is closer in meaning to the
  existing code, as kvm_tdp_mmu_unmap_gfn_range() will then operate
  only on direct or only on mirror pages depending on the path that
  caused the invalidation (guest_memfd vs. MMU notifier)

- patch 13: adjust commit message due to change from kvm_tdp_mmu_handle_gfn
  to __kvm_tdp_mmu_age_gfn_range; "or" KVM_INVALID_ROOTS into the
  "types" variable in kvm_tdp_mmu_unmap_gfn_range, otherwise the loop
  would not affect invalid roots.  This is the problematic code from v4:

-	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, KVM_ALL_ROOTS)
+	types = kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter);
+
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, types)

  and here is it in v5

+	types = kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter) | KVM_INVALID_ROOTS;
+
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, types)

- patch 14: tdp_mmu_zap_spte_atomic() disappeared in commit 35ef80eb29ab
  ("KVM: x86/mmu: Batch TLB flushes when zapping collapsible TDP MMU SPTEs", 2024-10-30)

- patch 18: context changes due to kvm_release_pfn_clean -> kvm_mmu_finish_page_fault

Thanks,

Paolo

Isaku Yamahata (12):
  KVM: Add member to struct kvm_gfn_range for target alias
  KVM: x86/mmu: Add an external pointer to struct kvm_mmu_page
  KVM: x86/mmu: Add an is_mirror member for union kvm_mmu_page_role
  KVM: x86/tdp_mmu: Take struct kvm in iter loops
  KVM: x86/mmu: Support GFN direct bits
  KVM: x86/tdp_mmu: Extract root invalid check from tdx_mmu_next_root()
  KVM: x86/tdp_mmu: Introduce KVM MMU root types to specify page table
    type
  KVM: x86/tdp_mmu: Take root in tdp_mmu_for_each_pte()
  KVM: x86/tdp_mmu: Support mirror root for TDP MMU
  KVM: x86/tdp_mmu: Propagate building mirror page tables
  KVM: x86/tdp_mmu: Propagate tearing down mirror page tables
  KVM: x86/tdp_mmu: Take root types for
    kvm_tdp_mmu_invalidate_all_roots()

Paolo Bonzini (1):
  KVM: x86/tdp_mmu: Propagate attr_filter to MMU notifier callbacks

Rick Edgecombe (5):
  KVM: x86/mmu: Zap invalid roots with mmu_lock holding for write at
    uninit
  KVM: x86: Add a VM type define for TDX
  KVM: x86/mmu: Make kvm_tdp_mmu_alloc_root() return void
  KVM: x86/tdp_mmu: Don't zap valid mirror roots in
    kvm_tdp_mmu_zap_all()
  KVM: x86/mmu: Prevent aliased memslot GFNs

 arch/x86/include/asm/kvm-x86-ops.h |   4 +
 arch/x86/include/asm/kvm_host.h    |  26 ++-
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/kvm/mmu.h                 |  31 +++
 arch/x86/kvm/mmu/mmu.c             |  50 ++++-
 arch/x86/kvm/mmu/mmu_internal.h    |  64 +++++-
 arch/x86/kvm/mmu/spte.h            |   5 +
 arch/x86/kvm/mmu/tdp_iter.c        |  10 +-
 arch/x86/kvm/mmu/tdp_iter.h        |  21 +-
 arch/x86/kvm/mmu/tdp_mmu.c         | 323 ++++++++++++++++++++++-------
 arch/x86/kvm/mmu/tdp_mmu.h         |  51 ++++-
 arch/x86/kvm/x86.c                 |   3 +
 include/linux/kvm_host.h           |   6 +
 virt/kvm/guest_memfd.c             |   2 +
 virt/kvm/kvm_main.c                |  14 ++
 15 files changed, 506 insertions(+), 105 deletions(-)

-- 
2.43.5


