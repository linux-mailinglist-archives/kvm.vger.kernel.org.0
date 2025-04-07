Return-Path: <kvm+bounces-42808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B68FAA7D6CE
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31A2516766D
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E733A1A315F;
	Mon,  7 Apr 2025 07:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OfCE66t+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CA7227B8C
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012223; cv=none; b=JwvO7eq3Tt1/fajUc60dZPoVrW2YSDPMIyutcvcytPLhsAlk0lwNSuKWryxrCB2RW7Ciu6WUgpFm0K3noZEGE5nTvXwODEthu6WI0KhNctD9eEjnygQW79snb938JRGnkAyYOhmEyJvOOh0QN2y1LeJrTlyWLhfSxH76RIddBac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012223; c=relaxed/simple;
	bh=VcsOtoKaXuIBJyGwmx8nSbTIs9EhvqUalOaaez7TI0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4MyLe401FH5a1+do89zqch3dN7Wb2e23HZ92l9Tw4prwB7EjWmOHclsJ1wM13XOYES9MO+3//qeliOMZgny3FYIBxmOn/oO7YTUYU26UcOZk4Vy0Vs7wZVzi+RB1nPa74kr1O0tDrrNcFtYn0MoZ/pSMuAD1iVa5DWwfZ4PC+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OfCE66t+; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744012222; x=1775548222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VcsOtoKaXuIBJyGwmx8nSbTIs9EhvqUalOaaez7TI0A=;
  b=OfCE66t+jTNcOns1sQUwSJTDr0xWQMVWpAcg4t9YVxDAb9qKy8qKb3nP
   amDEKGtYG2lA1UbY3Txm/OoELMu+Kcya2Ez1kIVGCx9Z8H5rdeI/0HDFr
   bMgysBtzIYPQZXXGvyle6uH+vWJdsYRE0fxUNvgWQoS+QEqQ+qsWe+9is
   cNzajt68IloAMvUlDdc7Oo9HVKtha3OQ/4rs5LYDKw8IjdeAf2ORWZ/FV
   yorefbnErzZ0RRY/aAM737Q614GkuMU52PwTAJIx74kjpd1nyR0ofhGZG
   A5wMF7aNgjbq85kP/4lv5LM7RLqbfLNiCFKuSwfFBMvRDMBfswP7+madt
   A==;
X-CSE-ConnectionGUID: RGmF6XtdS0aQukfkC6TVTg==
X-CSE-MsgGUID: FZ9rhfA/R3Cwi+WK9QRZwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="67857571"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="67857571"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:22 -0700
X-CSE-ConnectionGUID: 52pGxl9oQAeCJDAezIyv3w==
X-CSE-MsgGUID: Q/C6FP9TTbaf3hipyyTGfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128405662"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:18 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
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
Subject: [PATCH v4 09/13] memory: Attach RamBlockAttribute to guest_memfd-backed RAMBlocks
Date: Mon,  7 Apr 2025 15:49:29 +0800
Message-ID: <20250407074939.18657-10-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250407074939.18657-1-chenyi.qiang@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A new field, ram_block_attribute, is introduced in RAMBlock to link to a
RamBlockAttribute object. This change centralizes all guest_memfd state
information (such as fd and shared_bitmap) within a RAMBlock,
simplifying management.

The realize()/unrealized() helpers are used to initialize/uninitialize
the RamBlockAttribute object. The object is registered/unregistered in
the target RAMBlock's MemoryRegion when creating guest_memfd.

Additionally, use the private_shared_manager_state_change() helper to
notify the registered PrivateSharedListener of these changes.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v4:
    - Remove the replay operations for attribute changes which will be
      handled in a listener in following patches.
    - Add some comment in the error path of realize() to remind the
      future development of the unified error path.

Changes in v3:
    - Use ram_discard_manager_reply_populated/discarded() to set the
      memory attribute and add the undo support if state_change()
      failed.
    - Didn't add Reviewed-by from Alexey due to the new changes in this
      commit.

Changes in v2:
    - Introduce a new field memory_attribute_manager in RAMBlock.
    - Move the state_change() handling during page conversion in this patch.
    - Undo what we did if it fails to set.
    - Change the order of close(guest_memfd) and memory_attribute_manager cleanup.
---
 accel/kvm/kvm-all.c     |  9 +++++++++
 include/exec/ramblock.h |  1 +
 system/physmem.c        | 16 ++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c1fea69d58..546b58b737 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3088,6 +3088,15 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
     rb = qemu_ram_block_from_host(addr, false, &offset);
 
+    ret = private_shared_manager_state_change(PRIVATE_SHARED_MANAGER(mr->gsm),
+                                              offset, size, to_private);
+    if (ret) {
+        error_report("Failed to notify the listener the state change of "
+                     "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
+                     start, size, to_private ? "private" : "shared");
+        goto out_unref;
+    }
+
     if (to_private) {
         if (rb->page_size != qemu_real_host_page_size()) {
             /*
diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
index b8b5469db9..78eb031819 100644
--- a/include/exec/ramblock.h
+++ b/include/exec/ramblock.h
@@ -46,6 +46,7 @@ struct RAMBlock {
     int fd;
     uint64_t fd_offset;
     int guest_memfd;
+    RamBlockAttribute *ram_block_attribute;
     size_t page_size;
     /* dirty bitmap used during migration */
     unsigned long *bmap;
diff --git a/system/physmem.c b/system/physmem.c
index c76503aea8..fb74321e10 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1885,6 +1885,20 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
             qemu_mutex_unlock_ramlist();
             goto out_free;
         }
+
+        new_block->ram_block_attribute = RAM_BLOCK_ATTRIBUTE(object_new(TYPE_RAM_BLOCK_ATTRIBUTE));
+        if (ram_block_attribute_realize(new_block->ram_block_attribute, new_block->mr)) {
+            error_setg(errp, "Failed to realize ram block attribute");
+            /*
+             * The error path could be unified if the rest of ram_block_add() ever
+             * develops a need to check for errors.
+             */
+            object_unref(OBJECT(new_block->ram_block_attribute));
+            close(new_block->guest_memfd);
+            ram_block_discard_require(false);
+            qemu_mutex_unlock_ramlist();
+            goto out_free;
+        }
     }
 
     ram_size = (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS;
@@ -2138,6 +2152,8 @@ static void reclaim_ramblock(RAMBlock *block)
     }
 
     if (block->guest_memfd >= 0) {
+        ram_block_attribute_unrealize(block->ram_block_attribute);
+        object_unref(OBJECT(block->ram_block_attribute));
         close(block->guest_memfd);
         ram_block_discard_require(false);
     }
-- 
2.43.5


