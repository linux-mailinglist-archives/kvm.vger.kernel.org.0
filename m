Return-Path: <kvm+bounces-52422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF53DB04F38
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 05:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E3EB3B6175
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 03:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D63F2D1F4E;
	Tue, 15 Jul 2025 03:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UfJ1qJb3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF9F2D0C8A
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 03:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752550812; cv=none; b=ltwlQIsfv7Snw8//REg+MrRgNwFumyaRnhvtf3Dc+KkfoNGJuiRDmU3oPw+OGplqbv89MUG1NYdwJsiXXpnOkAEhicIGj3apEpDRQbCSDyZvt+WzXweh2Mt4Fg8pteMA9rolYByYpH4V+bZVh+G9eMdCpc50LiEg6lBmnPJAWCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752550812; c=relaxed/simple;
	bh=Qeil6/cS4TnDGn/oSbEZUuBv4NuQFCKMlPyhRgS+pqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UViUPQVeZgqYa/MhAfhBODY7+nAs/bEbowWoxeZRld9mJv9XXBLOLbrZFXAKMKfeGUKJAOU6k6E8MkgITYDnW7gBvsxsX6UbbrBnsAi741zyyAAU1kMQOEWyVDeC8bVEeDm12Fr++YAtGeTELxdKQ9RCv/yL1lLmuD1Yb7iKsbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UfJ1qJb3; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752550811; x=1784086811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qeil6/cS4TnDGn/oSbEZUuBv4NuQFCKMlPyhRgS+pqA=;
  b=UfJ1qJb3bIMiv9JXBCgpUBQEfUJQ+7qrFT1UsvjmfVuSj3swyq2DisFF
   g2PIC60BuR1bNbS3ZiFll88k2bvQARCvjJoO/r3fKYt531qHoCQANHrdn
   CkS8Suu5ObNYtdAdnKHFNa/40xOsi4lzRRBob1Hu8gB8l9R1x85rDrpoG
   aafAiWPJVRp2sLylaNvkpOhTiISPFVNnPE2SrpM/665nqCgTxMLyAf6dB
   Ndzs1yAU3nM1GxDANTvk/k+UbYADdeYuHjHMHW3w/LKRql8SwG7lymjaE
   e2wI9rVaOYOLpwtvqPrpxxIWm1YUXKg4rhA2y3yex8onc8e4v4+Uck4k6
   w==;
X-CSE-ConnectionGUID: A+u4qSkeTT+IpvU9EP3duA==
X-CSE-MsgGUID: Pwa0+v3zTY2BkaSg7kAydw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="72334945"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="72334945"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 20:40:11 -0700
X-CSE-ConnectionGUID: V/OJWrNDQHSoOfPHxJLXSA==
X-CSE-MsgGUID: Zf/J+uF7SEqChZOuPe+G6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="180808190"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa002.fm.intel.com with ESMTP; 14 Jul 2025 20:40:07 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	ackerleytng@google.com,
	seanjc@google.com
Cc: Fuad Tabba <tabba@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	rick.p.edgecombe@intel.com,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	ira.weiny@intel.com,
	michael.roth@amd.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [POC PATCH 5/5] [HACK] memory: Don't enable in-place conversion for internal MemoryRegion with gmem
Date: Tue, 15 Jul 2025 11:31:41 +0800
Message-ID: <20250715033141.517457-6-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250715033141.517457-1-xiaoyao.li@intel.com>
References: <cover.1747264138.git.ackerleytng@google.com>
 <20250715033141.517457-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the TDVF cannot work with gmem in-place conversion because
current implementation of KVM_TDX_INIT_MEM_REGION in KVM requires
gmem of TDVF to be valid for both shared and private at the same time.

To workaround it, explicitly not enable in-place conversion for internal
MemoryRegion with gmem. So that TDVF doesn't use in-place conversion gmem
and KVM_TDX_INIT_MEM_REGION will initialize the gmem with the separate
shared memory.

To make in-place conversion work with TDX's initial memory, the
one possible solution and flow would be as below and it requires KVM
change:

- QEMU create gmem as shared;
- QEMU mmap the gmem and load TDVF binary into it;
- QEMU convert gmem to private with the content preserved[1];
- QEMU invokes KVM_TDX_INIT_MEM_REGION without valid src, so that KVM
  knows to fetch the content in-place and use in-place PAGE.ADD for TDX.

[1] https://lore.kernel.org/all/aG0pNijVpl0czqXu@google.com/

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/system/memory.h | 3 +++
 system/memory.c         | 2 +-
 system/physmem.c        | 8 +++++---
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/system/memory.h b/include/system/memory.h
index f14fbf65805d..89d6449cef70 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -256,6 +256,9 @@ typedef struct IOMMUTLBEvent {
  */
 #define RAM_PRIVATE (1 << 13)
 
+/* Don't use enable in-place conversion for the guest mmefd backend */
+#define RAM_GUEST_MEMFD_NO_INPLACE (1 << 14)
+
 static inline void iommu_notifier_init(IOMMUNotifier *n, IOMMUNotify fn,
                                        IOMMUNotifierFlag flags,
                                        hwaddr start, hwaddr end,
diff --git a/system/memory.c b/system/memory.c
index 6870a41629ef..c1b73abc4c94 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -3702,7 +3702,7 @@ bool memory_region_init_ram_guest_memfd(MemoryRegion *mr,
     DeviceState *owner_dev;
 
     if (!memory_region_init_ram_flags_nomigrate(mr, owner, name, size,
-                                                RAM_GUEST_MEMFD, errp)) {
+                                                RAM_GUEST_MEMFD | RAM_GUEST_MEMFD_NO_INPLACE, errp)) {
         return false;
     }
     /* This will assert if owner is neither NULL nor a DeviceState.
diff --git a/system/physmem.c b/system/physmem.c
index ea1c27ea2b99..c23379082f38 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1916,7 +1916,8 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
 
     if (new_block->flags & RAM_GUEST_MEMFD) {
         int ret;
-        bool in_place = kvm_guest_memfd_inplace_supported;
+        bool in_place = !(new_block->flags & RAM_GUEST_MEMFD_NO_INPLACE) &&
+                        kvm_guest_memfd_inplace_supported;
 
         new_block->guest_memfd_flags = 0;
 
@@ -2230,7 +2231,8 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
     ram_flags &= ~RAM_PRIVATE;
 
     assert((ram_flags & ~(RAM_SHARED | RAM_RESIZEABLE | RAM_PREALLOC |
-                          RAM_NORESERVE | RAM_GUEST_MEMFD)) == 0);
+                          RAM_NORESERVE | RAM_GUEST_MEMFD |
+                          RAM_GUEST_MEMFD_NO_INPLACE)) == 0);
     assert(!host ^ (ram_flags & RAM_PREALLOC));
     assert(max_size >= size);
 
@@ -2314,7 +2316,7 @@ RAMBlock *qemu_ram_alloc(ram_addr_t size, uint32_t ram_flags,
                          MemoryRegion *mr, Error **errp)
 {
     assert((ram_flags & ~(RAM_SHARED | RAM_NORESERVE | RAM_GUEST_MEMFD |
-                          RAM_PRIVATE)) == 0);
+                          RAM_PRIVATE | RAM_GUEST_MEMFD_NO_INPLACE)) == 0);
     return qemu_ram_alloc_internal(size, size, NULL, NULL, ram_flags, mr, errp);
 }
 
-- 
2.43.0


