Return-Path: <kvm+bounces-52421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1C4B04F37
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 05:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07F7B4A4C41
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 03:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929662D2382;
	Tue, 15 Jul 2025 03:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hHUsHkh7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401942D12E0
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 03:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752550808; cv=none; b=W3YsJCG6T5KCCtFCNuHofuzn1TjguXYlWe2TkF0AxAFxUi61QJIegTtyMk5VoaxqH7yZjpgavYSs8CUPgeZWIhFIUamXdH48ZJbK11m1XeEkGAa5xux9MfJiwafnDiq3lQ0fMujVGecQ+nfIuaFTQPjEh2y7WFG6l4cGiOrMM4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752550808; c=relaxed/simple;
	bh=337nkqGcMNjO0TXjHY3O+IoJvy4v6WC372UutXb1xJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPlWZzmgFpUKPygF2ZtEFici4VxWDn2+oUc/X5qphiFBMTetADMVc7Ay47iEmcprtRYGjrIebILxC2ArzGMifewZuIXmm3XpVGTRxwDiu6ixfzWpFHox7ph54TYB7kwtBqsWug3/kci/yBRGCrnaez+up8QwY/Hx9k4bT7dtAK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hHUsHkh7; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752550807; x=1784086807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=337nkqGcMNjO0TXjHY3O+IoJvy4v6WC372UutXb1xJ4=;
  b=hHUsHkh7NIsSdq72pPXrenCxXJIVMvs69+zZgLuepQzCPm2FUKRxoWvH
   1SdOn46xY/oJdJyNXlWkyjqdHPPZBjYtgu4gf5hM96nG1YDc49L5OuAcm
   bn/4yG3BgPr04RzuhsoT2arikCushpUz4D2wWKiuxnBjWgsnn6Wi4nH/a
   e7M/kDGdQnTfw/R1pOp9yF1ypRNGijoc95Ci1C/cJGwMSx+EKgKqwcFbh
   gvrKWznZjhkHbV6/AdIKD7zcJJUo7i7y99fSeri6gM7vDRhZQWbrhgU6h
   VWP1fotub6eP+h8myJQ8y5CGIJXSxmnef5Xx8KB9oeifalk1cDYj1Hp/v
   g==;
X-CSE-ConnectionGUID: 8LH9p9F6T8OCl527tE+Vhg==
X-CSE-MsgGUID: ATfi0OQoRu+/5aB50eyjgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="72334939"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="72334939"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 20:40:07 -0700
X-CSE-ConnectionGUID: BySPT4tMS0OtYrtHF6wKWQ==
X-CSE-MsgGUID: WfFHQ5O7Q6qMylZNFgEpnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="180808164"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa002.fm.intel.com with ESMTP; 14 Jul 2025 20:40:04 -0700
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
Subject: [POC PATCH 4/5] memory/guest_memfd: Enable hugetlb support
Date: Tue, 15 Jul 2025 11:31:40 +0800
Message-ID: <20250715033141.517457-5-xiaoyao.li@intel.com>
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

(This is just the POC code to use gmem with hugetlb.)

Try with hugetlb first when hugetlb is supported by gmem. If hugetlb
cannot afford the requested memory size and returns -ENOMEM, fallback to
create gmem withtout hugetlb.

The hugetlb size is hardcoded as GUESTMEM_HUGETLB_FLAG_2MB. I'm not sure
if it will be better if gmem can report the supported hugetlb size.
But look at the current implementation of memfd, it just tries with
the requested hugetlb size from user and fail when not supported.
Hence gmem can do the same way without the supported size being
enuemrated.

For a upstreamable solution, the hugetlb support of gmem can be
implemented as "hugetlb" and "hugetlbsize" properties of
memory-backend-guestmemfd as similar of memory-backend-memfd. (It
requires memory-backed-guestmemfd introduced for in-place conversion
gmem at first)

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c    |  3 ++-
 accel/stubs/kvm-stub.c |  1 +
 include/system/kvm.h   |  1 +
 system/physmem.c       | 13 +++++++++++++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 609537738d38..2d18e961714e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -106,6 +106,7 @@ static bool kvm_immediate_exit;
 static uint64_t kvm_supported_memory_attributes;
 static bool kvm_guest_memfd_supported;
 bool kvm_guest_memfd_inplace_supported;
+bool kvm_guest_memfd_hugetlb_supported;
 static hwaddr kvm_max_slot_size = ~0;
 
 static const KVMCapabilityInfo kvm_required_capabilites[] = {
@@ -2808,6 +2809,7 @@ static int kvm_init(AccelState *as, MachineState *ms)
     kvm_guest_memfd_inplace_supported =
         kvm_check_extension(s, KVM_CAP_GMEM_SHARED_MEM) &&
         kvm_check_extension(s, KVM_CAP_GMEM_CONVERSION);
+    kvm_guest_memfd_hugetlb_supported = kvm_check_extension(s, KVM_CAP_GMEM_HUGETLB);
     kvm_pre_fault_memory_supported = kvm_vm_check_extension(s, KVM_CAP_PRE_FAULT_MEMORY);
 
     if (s->kernel_irqchip_split == ON_OFF_AUTO_AUTO) {
@@ -4536,7 +4538,6 @@ int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp)
     fd = kvm_vm_ioctl(kvm_state, KVM_CREATE_GUEST_MEMFD, &guest_memfd);
     if (fd < 0) {
         error_setg_errno(errp, errno, "Error creating KVM guest_memfd");
-        return -1;
     }
 
     return fd;
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index bf0ccae27b62..fbc1d7c4e9b5 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -25,6 +25,7 @@ bool kvm_allowed;
 bool kvm_readonly_mem_allowed;
 bool kvm_msi_use_devid;
 bool kvm_guest_memfd_inplace_supported;
+bool kvm_guest_memfd_hugetlb_supported;
 
 void kvm_flush_coalesced_mmio_buffer(void)
 {
diff --git a/include/system/kvm.h b/include/system/kvm.h
index 32f2be5f92e1..d1d79510ee26 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -44,6 +44,7 @@ extern bool kvm_readonly_mem_allowed;
 extern bool kvm_msi_use_devid;
 extern bool kvm_pre_fault_memory_supported;
 extern bool kvm_guest_memfd_inplace_supported;
+extern bool kvm_guest_memfd_hugetlb_supported;
 
 #define kvm_enabled()           (kvm_allowed)
 /**
diff --git a/system/physmem.c b/system/physmem.c
index 955480685310..ea1c27ea2b99 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1940,8 +1940,21 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
                                             GUEST_MEMFD_FLAG_INIT_PRIVATE;
         }
 
+        if (kvm_guest_memfd_hugetlb_supported) {
+            new_block->guest_memfd_flags |= GUEST_MEMFD_FLAG_HUGETLB |
+                                            GUESTMEM_HUGETLB_FLAG_2MB;
+        }
+
+        new_block->guest_memfd = kvm_create_guest_memfd(new_block->max_length,
+                                 new_block->guest_memfd_flags, &err);
+        if (new_block->guest_memfd == -ENOMEM) {
+            error_free(err);
+            new_block->guest_memfd_flags &= ~(GUEST_MEMFD_FLAG_HUGETLB |
+                                              GUESTMEM_HUGETLB_FLAG_2MB);
+        }
         new_block->guest_memfd = kvm_create_guest_memfd(new_block->max_length,
                                  new_block->guest_memfd_flags, errp);
+
         if (new_block->guest_memfd < 0) {
             qemu_mutex_unlock_ramlist();
             goto out_free;
-- 
2.43.0


