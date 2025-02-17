Return-Path: <kvm+bounces-38336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74016A37CFD
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 09:19:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F4CB3B2C36
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 08:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7211E1A08DB;
	Mon, 17 Feb 2025 08:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lqx2qodx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C9C1A2645
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 08:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739780346; cv=none; b=HDgtpuOpUeViL7A1rRbCCes8X1h7ZTXJaMkmmFiyACbiLZcmE1pIbeSBYgpGibsRRgizi3kJlgHjV+JibUp+BOnjRHcyadTmXDmY8Igsxybt0u/tJ8GnT9iZf1arL3eBiueQEKycAC8LDgam1PEvykpU9e0T6oebF2COv3AHLbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739780346; c=relaxed/simple;
	bh=et457s5gxOACczlEdsQV3JpgBTp1+3xW6hMwzsrYsk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zrey6Nc+yMzqqWCmGE4QW1SObk8sWIzaf+5Hm/X/rZFIdJEi+AFNpU+mlRMaBMWAhcPa+Gp76kGHmfNrEk9lFQ9ZfeY5eBqmUkGD/Jl7Mi75KMHSAOa4vtxoIvn7cF8pJ4mhy2Bh5dmAoyCNblfEOK2BYPxWzAc5sus0STXZxlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lqx2qodx; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739780344; x=1771316344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=et457s5gxOACczlEdsQV3JpgBTp1+3xW6hMwzsrYsk0=;
  b=Lqx2qodxEt7eGP97ygA8l95KUxRGrn4DUbs4r0VgrnDDxm9sjFeZGmEJ
   ntXP29un1UkokVT3Es98yeIMl4MX6GFTxkj3fEFtlrymToyfhVUZQrgPS
   qRyB8JlK7ZEEFJFfPY60lf21lgy65r9e8JBHzr4kAgWtq45K61ijeqcAP
   l6qDFhsltIy5JsB7VyfzpKwSHW6kdfSV6R8Pdehamb2PK6lZu6lkwtu4/
   xzsieUjVHHxWp3k4xM9++H3WmL1pGSNGAeDvXS6qf95r6MeBR8TZ8EOaS
   ckLtvrlqHffT6F9bt/g0BR7wKGTxu0D7KBXgTZvC5zK+67cD6KwCdLq/5
   A==;
X-CSE-ConnectionGUID: H+mn5nH2R0C5h29Y5+fUAw==
X-CSE-MsgGUID: P9oYwJLfQ26D9Ulbejm26A==
X-IronPort-AV: E=McAfee;i="6700,10204,11347"; a="50669000"
X-IronPort-AV: E=Sophos;i="6.13,292,1732608000"; 
   d="scan'208";a="50669000"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:19:04 -0800
X-CSE-ConnectionGUID: l51kerAISVmk9QAqliXkng==
X-CSE-MsgGUID: xdV2eWBVTKyB3H50d8XF5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118690254"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:19:02 -0800
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v2 5/6] memory: Attach MemoryAttributeManager to guest_memfd-backed RAMBlocks
Date: Mon, 17 Feb 2025 16:18:24 +0800
Message-ID: <20250217081833.21568-6-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250217081833.21568-1-chenyi.qiang@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new field, memory_attribute_manager, in RAMBlock to link to
an MemoryAttributeManager object. This change centralizes all
guest_memfd state information (like fd and shared_bitmap) within a
RAMBlock, making it easier to manage.

Use the realize()/unrealize() helpers to initialize/uninitialize the
MemoryAttributeManager object. Register/unregister the object in the
target RAMBlock's MemoryRegion when creating guest_memfd. Upon memory
state changes in kvm_convert_memory(), invoke the
memory_attribute_manager_state_change() helper to notify the registered
RamDiscardListener.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v2:
    - Introduce a new field memory_attribute_manager in RAMBlock.
    - Move the state_change() handling during page conversion in this patch.
    - Undo what we did if it fails to set.
    - Change the order of close(guest_memfd) and memory_attribute_manager cleanup.
---
 accel/kvm/kvm-all.c     |  9 +++++++++
 include/exec/ramblock.h |  2 ++
 system/physmem.c        | 13 +++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c1fea69d58..c0d15c48ad 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -48,6 +48,7 @@
 #include "kvm-cpus.h"
 #include "system/dirtylimit.h"
 #include "qemu/range.h"
+#include "system/memory-attribute-manager.h"
 
 #include "hw/boards.h"
 #include "system/stats.h"
@@ -3088,6 +3089,14 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
     rb = qemu_ram_block_from_host(addr, false, &offset);
 
+    ret = memory_attribute_manager_state_change(MEMORY_ATTRIBUTE_MANAGER(mr->rdm),
+                                                offset, size, to_private);
+    if (ret) {
+        warn_report("Failed to notify the listener the state change of "
+                    "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
+                    start, size, to_private ? "private" : "shared");
+    }
+
     if (to_private) {
         if (rb->page_size != qemu_real_host_page_size()) {
             /*
diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
index 0babd105c0..06fd365326 100644
--- a/include/exec/ramblock.h
+++ b/include/exec/ramblock.h
@@ -23,6 +23,7 @@
 #include "cpu-common.h"
 #include "qemu/rcu.h"
 #include "exec/ramlist.h"
+#include "system/memory-attribute-manager.h"
 
 struct RAMBlock {
     struct rcu_head rcu;
@@ -42,6 +43,7 @@ struct RAMBlock {
     int fd;
     uint64_t fd_offset;
     int guest_memfd;
+    MemoryAttributeManager *memory_attribute_manager;
     size_t page_size;
     /* dirty bitmap used during migration */
     unsigned long *bmap;
diff --git a/system/physmem.c b/system/physmem.c
index c76503aea8..0ed394c5d2 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -54,6 +54,7 @@
 #include "system/hostmem.h"
 #include "system/hw_accel.h"
 #include "system/xen-mapcache.h"
+#include "system/memory-attribute-manager.h"
 #include "trace.h"
 
 #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
@@ -1885,6 +1886,16 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
             qemu_mutex_unlock_ramlist();
             goto out_free;
         }
+
+        new_block->memory_attribute_manager = MEMORY_ATTRIBUTE_MANAGER(object_new(TYPE_MEMORY_ATTRIBUTE_MANAGER));
+        if (memory_attribute_manager_realize(new_block->memory_attribute_manager, new_block->mr)) {
+            error_setg(errp, "Failed to realize memory attribute manager");
+            object_unref(OBJECT(new_block->memory_attribute_manager));
+            close(new_block->guest_memfd);
+            ram_block_discard_require(false);
+            qemu_mutex_unlock_ramlist();
+            goto out_free;
+        }
     }
 
     ram_size = (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS;
@@ -2138,6 +2149,8 @@ static void reclaim_ramblock(RAMBlock *block)
     }
 
     if (block->guest_memfd >= 0) {
+        memory_attribute_manager_unrealize(block->memory_attribute_manager);
+        object_unref(OBJECT(block->memory_attribute_manager));
         close(block->guest_memfd);
         ram_block_discard_require(false);
     }
-- 
2.43.5


