Return-Path: <kvm+bounces-52419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12F6EB04F35
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 05:40:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B0EC3B508B
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 03:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702392D0C9D;
	Tue, 15 Jul 2025 03:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z2IB/gVR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0762C17A8
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 03:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752550801; cv=none; b=TxqnLN4M7tR01ar9CFFbMvjboFKbwTKqrUMe7LNsksx3VylOlaafX5a9hWsKY1dweol6aSRTvNLwduODNCzAULNKJptwLoWWT/4NgIOWegHxBMrxX05T63oxIJoDs+VOVyksrF+uvAVjpgDdYrKQQfYRQYLm4KeSf/nDtUQ7WCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752550801; c=relaxed/simple;
	bh=Q4SUK8FgUWLQ+4A301fwccsLC3/hT+jdFcVfpJvYn+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sd6ZfaPmAIRsuPrliDxEw6xjblv0mj7T3LtlMXXmLyTi6ysZH4yxLNH9MEoZqZpXG/bxxq5qr+WiqECl7IeXKv0ZSJLd5kQTiEQzlXOQUQuoCAp5YhnZJekSzgqbLR9MrjNQn3knzDUO+ECzzVoQPVHVmCH9IjzP8nUt7+ANU1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z2IB/gVR; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752550800; x=1784086800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q4SUK8FgUWLQ+4A301fwccsLC3/hT+jdFcVfpJvYn+8=;
  b=Z2IB/gVRRGg/Nic16b5On1KKi/Wa8ux7cYHwQyJqizDhP1/VqP1B6AWB
   gKcDgGkOmy30kqYRTmt8w9CTXi6hO1FvcHXuwMlZOcNho6eaziXAJWMY1
   pZgtxE3YjCarbBQqocUpSZUtYF7RimPo1tlChdZ9jIHxQOMo+CmcD0l95
   3gyDJWjvgyFyJD41H0fWusG4vDpPXFwJ+ImmgdbFcdZMLensLJOTp4r/U
   AHGq73qf6dsRD3M67zj1Lbsz/lHrD8XS7lpMfXdznL5GAlBe5pK1cwCxd
   nwl2UgSWtmQnYee2hwcpufHXNDVMqaeN1DhpOTiC+oDPa8v6mbyuFd01/
   A==;
X-CSE-ConnectionGUID: bkn7vRZdQSCtzEvjJvhGEg==
X-CSE-MsgGUID: F//t3/aeQW6foH77qjiMBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="72334925"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="72334925"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 20:40:00 -0700
X-CSE-ConnectionGUID: xwHQgJYWS6Waa1s9cAT7Hg==
X-CSE-MsgGUID: C+4jFUV2S3CD/bdO7Y/0qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="180808100"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa002.fm.intel.com with ESMTP; 14 Jul 2025 20:39:56 -0700
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
Subject: [POC PATCH 2/5] headers: Fetch gmem updates
Date: Tue, 15 Jul 2025 11:31:38 +0800
Message-ID: <20250715033141.517457-3-xiaoyao.li@intel.com>
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

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 linux-headers/linux/guestmem.h | 29 +++++++++++++++++++++++++++++
 linux-headers/linux/kvm.h      | 18 ++++++++++++++++++
 2 files changed, 47 insertions(+)
 create mode 100644 linux-headers/linux/guestmem.h

diff --git a/linux-headers/linux/guestmem.h b/linux-headers/linux/guestmem.h
new file mode 100644
index 000000000000..be045fbad230
--- /dev/null
+++ b/linux-headers/linux/guestmem.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_GUESTMEM_H
+#define _LINUX_GUESTMEM_H
+
+/*
+ * Huge page size must be explicitly defined when using the guestmem_hugetlb
+ * allocator for guest_memfd.  It is the responsibility of the application to
+ * know which sizes are supported on the running system.  See mmap(2) man page
+ * for details.
+ */
+
+#define GUESTMEM_HUGETLB_FLAG_SHIFT	58
+#define GUESTMEM_HUGETLB_FLAG_MASK	0x3fUL
+
+#define GUESTMEM_HUGETLB_FLAG_16KB	(14UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
+#define GUESTMEM_HUGETLB_FLAG_64KB	(16UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
+#define GUESTMEM_HUGETLB_FLAG_512KB	(19UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
+#define GUESTMEM_HUGETLB_FLAG_1MB	(20UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
+#define GUESTMEM_HUGETLB_FLAG_2MB	(21UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
+#define GUESTMEM_HUGETLB_FLAG_8MB	(23UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
+#define GUESTMEM_HUGETLB_FLAG_16MB	(24UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
+#define GUESTMEM_HUGETLB_FLAG_32MB	(25UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
+#define GUESTMEM_HUGETLB_FLAG_256MB	(28UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
+#define GUESTMEM_HUGETLB_FLAG_512MB	(29UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
+#define GUESTMEM_HUGETLB_FLAG_1GB	(30UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
+#define GUESTMEM_HUGETLB_FLAG_2GB	(31UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
+#define GUESTMEM_HUGETLB_FLAG_16GB	(34UL << GUESTMEM_HUGETLB_FLAG_SHIFT)
+
+#endif /* _LINUX_GUESTMEM_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 32c5885a3c20..ff9ef5fb37c5 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -952,6 +952,9 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_GMEM_SHARED_MEM 240
+#define KVM_CAP_GMEM_CONVERSION 241
+#define KVM_CAP_GMEM_HUGETLB 242
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1589,12 +1592,27 @@ struct kvm_memory_attributes {
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 
+#define GUEST_MEMFD_FLAG_SUPPORT_SHARED	(1UL << 0)
+#define GUEST_MEMFD_FLAG_INIT_PRIVATE	(1UL << 1)
+#define GUEST_MEMFD_FLAG_HUGETLB	(1UL << 2)
+
 struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
 	__u64 reserved[6];
 };
 
+#define KVM_GMEM_IO 0xAF
+#define KVM_GMEM_CONVERT_SHARED		_IOWR(KVM_GMEM_IO,  0x41, struct kvm_gmem_convert)
+#define KVM_GMEM_CONVERT_PRIVATE	_IOWR(KVM_GMEM_IO,  0x42, struct kvm_gmem_convert)
+
+struct kvm_gmem_convert {
+	__u64 offset;
+	__u64 size;
+	__u64 error_offset;
+	__u64 reserved[5];
+};
+
 #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
 
 struct kvm_pre_fault_memory {
-- 
2.43.0


