Return-Path: <kvm+bounces-1762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E1467EBDB1
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBA3E281312
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6961CD516;
	Wed, 15 Nov 2023 07:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S+zcKqQd"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0504D26D
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:19:44 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5B3D1
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032783; x=1731568783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gPIv+EVFLCQuX/CLJsbN+BBY/kYZvm9tPwnOGusF8vY=;
  b=S+zcKqQd/AIT2cLg3fRR5lbOjDsrPqRG4oQJer3qpul6fFVQ/dpgTw9q
   dinxYrow9ZqLs5eE0zOhF0g80KmHjPRFkwGZNgM4E6jB85GJscEmrAasy
   c8U0Jp36zdCNCseR8WZq7JL2wwijs2Q+FtgfoE0Ff40/DBxd7v5wDdVls
   1meewICWMbi6NRQNCLT/d14eFcmgeSViYYeY4eyITQhJLbq4okQRqU/HL
   UyLLIAMWwYNVxLWAiAIWnKp9zKe5bF6engtv5qIFvE93lnjZl+V4qVLzk
   SwXkpIzyz+Yamz9pebUOvLxMKasD38XSzt9O+ntt3P/BgA/4ww1eILl/g
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622977"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622977"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:19:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714799205"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714799205"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:19:32 -0800
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
Subject: [PATCH v3 34/70] kvm/memory: Introduce the infrastructure to set the default shared/private value
Date: Wed, 15 Nov 2023 02:14:43 -0500
Message-Id: <20231115071519.2864957-35-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
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
index a92fff471b58..316690d113d0 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1467,6 +1467,16 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
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
index f780367ab1bd..bdc4b98efe70 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -246,6 +246,9 @@ typedef struct IOMMUTLBEvent {
 /* RAM can be private that has kvm gmem backend */
 #define RAM_GUEST_MEMFD   (1 << 12)
 
+/* RAM is default private */
+#define RAM_DEFAULT_PRIVATE     (1 << 13)
+
 static inline void iommu_notifier_init(IOMMUNotifier *n, IOMMUNotify fn,
                                        IOMMUNotifierFlag flags,
                                        hwaddr start, hwaddr end,
@@ -1715,6 +1718,9 @@ bool memory_region_is_protected(MemoryRegion *mr);
  */
 bool memory_region_has_guest_memfd(MemoryRegion *mr);
 
+void memory_region_set_default_private(MemoryRegion *mr);
+bool memory_region_is_default_private(MemoryRegion *mr);
+
 /**
  * memory_region_get_iommu: check whether a memory region is an iommu
  *
diff --git a/system/memory.c b/system/memory.c
index 69741d91bbb7..b0c58232b6f7 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -1867,6 +1867,19 @@ bool memory_region_has_guest_memfd(MemoryRegion *mr)
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


