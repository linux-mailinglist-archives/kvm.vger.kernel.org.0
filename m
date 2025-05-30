Return-Path: <kvm+bounces-48087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E0FAC89F6
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 10:34:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B65581BC124B
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 08:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCD11219A81;
	Fri, 30 May 2025 08:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YhwX70xi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BD021882B
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 08:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748594064; cv=none; b=rBUX55lF7QWdSSwtRFRQaMoVi+bai9ozOYEk+j2LGy5Xwa5ln+5cX1vDMziboLyr+xvt7wTX1mbYwLmu4nT8sNdOBkRfuPRHR2eWnHbI+GejqwusWdTa9dbfQTnQy50rpAD5g1NeYpQIOMrN3agMBR/QpY3k9j1+Q24I2yesRAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748594064; c=relaxed/simple;
	bh=GrMUBFtn4Dj0h+vdvqfh8N4b0D8OE9P2jqndkfBDheM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwcK2+KmQ05vHZclmWQ+opHi29a/zFXoHWTp1gWlZnh+Iv+TrX9H9C+dxZ3yei0EscBDeOIsm2gxfguqsXQjjtIVz/SVykK4aGYyWykaMajiTETngrOtVF51qgBWQgizwX2SwGfwV6KyDUDfX5xzA5oSoUI+KDcyqfAWx+BkLpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YhwX70xi; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748594062; x=1780130062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GrMUBFtn4Dj0h+vdvqfh8N4b0D8OE9P2jqndkfBDheM=;
  b=YhwX70xibfsIWpPKFJpWI2qqySupc3pL4DP8EpXd3BiMHsjbkJydkV5J
   O8zWWk2yNR6NWrAJOgVXTSNt5J/ttXFjtU8IOKvOybzsayla5SpTqw5Mb
   boYZzMkiJZ1qnO5wVng4tcrgjDeoyXIilocFp2Lad7I1o+SCQbnKOTBJB
   0xtQUzsv2WebLMzRDoKtNh2eND0ArC2kl/bBwwcE9DMwyk2QGmJ1eoG3x
   7txK8TigHtWmLQG+ItmRsACX9IGisPI94BHP4Y/5aDCU0bgRXpbbVUWDb
   8t5YEk0JBJt0JoL9kfFmzcnZw2IMvQ5FhsVxe5V+16vNt+nND/p31pUpN
   w==;
X-CSE-ConnectionGUID: Ob19TFdRQ0O7lS+NIBqRDg==
X-CSE-MsgGUID: 8ieQgiJ0Qz+tMcdtcRERWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="62081560"
X-IronPort-AV: E=Sophos;i="6.16,195,1744095600"; 
   d="scan'208";a="62081560"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2025 01:34:19 -0700
X-CSE-ConnectionGUID: Re9g73xaSBWt9qMaEXbiKQ==
X-CSE-MsgGUID: 74+hMB1AQIqNLDnEk4JeOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,195,1744095600"; 
   d="scan'208";a="144453800"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2025 01:34:15 -0700
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
	Zhao Liu <zhao1.liu@intel.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v6 5/5] physmem: Support coordinated discarding of RAM with guest_memfd
Date: Fri, 30 May 2025 16:32:54 +0800
Message-ID: <20250530083256.105186-6-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250530083256.105186-1-chenyi.qiang@intel.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A new field, attributes, was introduced in RAMBlock to link to a
RamBlockAttributes object, which centralizes all guest_memfd related
information (such as fd and shared bitmap) within a RAMBlock.

Create and initialize the RamBlockAttributes object upon ram_block_add().
Meanwhile, register the object in the target RAMBlock's MemoryRegion.
After that, guest_memfd-backed RAMBlock is associated with the
RamDiscardManager interface, and the users can execute RamDiscardManager
specific handling. For example, VFIO will register the
RamDiscardListener and get notifications when the state_change() helper
invokes.

As coordinate discarding of RAM with guest_memfd is now supported, only
block uncoordinated discard.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v6:
    - Squash the unblocking of cooridnate discard into this commit.
    - Remove the checks in migration path.

Changes in v5:
    - Revert to use RamDiscardManager interface.
    - Move the object_new() into the ram_block_attribute_create()
      helper.
    - Add some check in migration path.

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
---
 accel/kvm/kvm-all.c       |  9 +++++++++
 include/system/ramblock.h |  1 +
 system/physmem.c          | 18 ++++++++++++++++--
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 51526d301b..3b390bbb09 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3089,6 +3089,15 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
     rb = qemu_ram_block_from_host(addr, false, &offset);
 
+    ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
+                                            offset, size, to_private);
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
diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index 1bab9e2dac..87e847e184 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -46,6 +46,7 @@ struct RAMBlock {
     int fd;
     uint64_t fd_offset;
     int guest_memfd;
+    RamBlockAttributes *attributes;
     size_t page_size;
     /* dirty bitmap used during migration */
     unsigned long *bmap;
diff --git a/system/physmem.c b/system/physmem.c
index a8a9ca309e..1f1217fa0a 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1916,7 +1916,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
         }
         assert(new_block->guest_memfd < 0);
 
-        ret = ram_block_discard_require(true);
+        ret = ram_block_coordinated_discard_require(true);
         if (ret < 0) {
             error_setg_errno(errp, -ret,
                              "cannot set up private guest memory: discard currently blocked");
@@ -1931,6 +1931,19 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
             goto out_free;
         }
 
+        new_block->attributes = ram_block_attributes_create(new_block);
+        if (!new_block->attributes) {
+            error_setg(errp, "Failed to create ram block attribute");
+            /*
+             * The error path could be unified if the rest of ram_block_add()
+             * ever develops a need to check for errors.
+             */
+            close(new_block->guest_memfd);
+            ram_block_coordinated_discard_require(false);
+            qemu_mutex_unlock_ramlist();
+            goto out_free;
+        }
+
         /*
          * Add a specific guest_memfd blocker if a generic one would not be
          * added by ram_block_add_cpr_blocker.
@@ -2287,8 +2300,9 @@ static void reclaim_ramblock(RAMBlock *block)
     }
 
     if (block->guest_memfd >= 0) {
+        ram_block_attributes_destroy(block->attributes);
         close(block->guest_memfd);
-        ram_block_discard_require(false);
+        ram_block_coordinated_discard_require(false);
     }
 
     g_free(block);
-- 
2.43.5


