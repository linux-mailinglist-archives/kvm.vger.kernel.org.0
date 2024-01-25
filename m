Return-Path: <kvm+bounces-6934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D52EC83B808
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:31:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C352284863
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB9C17BBD;
	Thu, 25 Jan 2024 03:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="maSwW8a/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B38E1798A
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153363; cv=none; b=i8VpR6p88bSO1HSFAk7Mv7zM/4Y68urCkupb8IyFSbIa6bTu5qa0FCw5D1vM3HcdlOQBl5yXH0+6MuLmZ5wyKWXY1qzzvzTxj5uCW88djGfeQjV83v5Zdsnych+6mHiCzZprByOh1friAoW7IrUE6xRjnN6/AV1EJ7NBS8kpzr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153363; c=relaxed/simple;
	bh=4NaFGev49Ww2K7vKm+OM3dUy64sSDjG4Z2BvNptlRTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kibsLtVGG3ow996UMo7YP3T5zfx1Ys0kngdvQ2bvq8OwzbWQxKvFW46jqF0qnaABmh3MoWZujMoBP/+Xm30MfV/YjGXT/0bKxdVilb9uRJ/x5wSTUNaSqaGxF+PwR/TVDWKz2flpMlj6aMfjl6Q68CuE835cKMXZnkWmxqgvWY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=maSwW8a/; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153362; x=1737689362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4NaFGev49Ww2K7vKm+OM3dUy64sSDjG4Z2BvNptlRTQ=;
  b=maSwW8a/aqf2riidHFP2wyNqahviMkdamFdWcdrvqPr3HFLPe0GvWxKf
   QLhkx9onzIgyTVmIMP4wKIBoI5wxHDBldsphy2dmDfv1QUGVerps+NPj1
   g6zG2xRlqAbsiT1smvO6G6GWgAlIUANh7+nxweem+lHx2jzKiauzJzefP
   vyiSg13J7xGmfMsuRSk9ytu44YDiGBivG99JLVe7zsQZbMh0no3Zkapw6
   e98NWLH07aNoUm/vTQWUeBccYqP2UEyLaEsICbciFo3bn09KX3Y1VAQ07
   jq4UHW0XJFcrguT42IIE1qlE1bt4earKT6CncTN8/exs/GwK+TXjPOHZk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9429116"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9429116"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:26:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2085772"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:26:28 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 32/66] kvm/memory: Introduce the infrastructure to set the default shared/private value
Date: Wed, 24 Jan 2024 22:22:54 -0500
Message-Id: <20240125032328.2522472-33-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce new flag RAM_DEFAULT_PRIVATE for RAMBlock. It's used to
indicate the default attribute,  private or not.

Set the RAM range to private explicitly when it's default private.

Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c   | 10 ++++++++++
 include/exec/memory.h |  6 ++++++
 system/memory.c       | 13 +++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 55f69d0f049a..094ce7695e16 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1458,6 +1458,16 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
                     strerror(-err));
             abort();
         }
+
+        if (memory_region_is_default_private(mr)) {
+            err = kvm_set_memory_attributes_private(start_addr, slot_size);
+            if (err) {
+                error_report("%s: failed to set memory attribute private: %s\n",
+                             __func__, strerror(-err));
+                exit(1);
+            }
+        }
+
         start_addr += slot_size;
         ram_start_offset += slot_size;
         ram += slot_size;
diff --git a/include/exec/memory.h b/include/exec/memory.h
index f11036ead15e..7229fcc0415f 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -246,6 +246,9 @@ typedef struct IOMMUTLBEvent {
 /* RAM can be private that has kvm guest memfd backend */
 #define RAM_GUEST_MEMFD   (1 << 12)
 
+/* RAM is default private */
+#define RAM_DEFAULT_PRIVATE     (1 << 13)
+
 static inline void iommu_notifier_init(IOMMUNotifier *n, IOMMUNotify fn,
                                        IOMMUNotifierFlag flags,
                                        hwaddr start, hwaddr end,
@@ -1736,6 +1739,9 @@ bool memory_region_is_protected(MemoryRegion *mr);
  */
 bool memory_region_has_guest_memfd(MemoryRegion *mr);
 
+void memory_region_set_default_private(MemoryRegion *mr);
+bool memory_region_is_default_private(MemoryRegion *mr);
+
 /**
  * memory_region_get_iommu: check whether a memory region is an iommu
  *
diff --git a/system/memory.c b/system/memory.c
index c756950c0c0f..74f647f2e56f 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -1855,6 +1855,19 @@ bool memory_region_has_guest_memfd(MemoryRegion *mr)
     return mr->ram_block && mr->ram_block->guest_memfd >= 0;
 }
 
+bool memory_region_is_default_private(MemoryRegion *mr)
+{
+    return memory_region_has_guest_memfd(mr) &&
+           (mr->ram_block->flags & RAM_DEFAULT_PRIVATE);
+}
+
+void memory_region_set_default_private(MemoryRegion *mr)
+{
+    if (memory_region_has_guest_memfd(mr)) {
+        mr->ram_block->flags |= RAM_DEFAULT_PRIVATE;
+    }
+}
+
 uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
 {
     uint8_t mask = mr->dirty_log_mask;
-- 
2.34.1


