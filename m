Return-Path: <kvm+bounces-47107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A3E2ABD4F7
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:32:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EE8F3BB238
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD4F2798F9;
	Tue, 20 May 2025 10:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NOMAnwrw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25038279350
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747736967; cv=none; b=c3hNr24C0rx5G5Bq4TvItlIleKY+3J+5WErJ25F1TmG47ccAupTQXkBkOc3jBXjTI1qK0+CRu2I14gyb1RfF5sSbUadHxlnE4ahlCTyr+PwK6TLLZOBYOkPCSaLjFOISUnrdo36Rkq/XH7SxUDZB0Gs0Q6rP43zAqDhHsPCI1Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747736967; c=relaxed/simple;
	bh=ZTijY9Sdopl8+Dse6K2gwMX4Z7V1NW/c8Gpa+JnYhEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXLXekuizuWefk1i8bY/PTguXtXkQXz+8viTmTPVGewFD3ZmFU3TBmtbP7MLfEEhm92Ubqk/Fa9/Um9DnT/EjM7ZOC6JnBO52nz4TFEORRRs82tQu12HXDKFBnUTFe+3FxhR2SOYwB1pon7fhwT0W2TtI/hyB6zGNp5/2h0kKNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NOMAnwrw; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747736967; x=1779272967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZTijY9Sdopl8+Dse6K2gwMX4Z7V1NW/c8Gpa+JnYhEs=;
  b=NOMAnwrwIdw4KkrxJbC84yb+I9gGJoShRVouCpnqT99x9SNcnU4ZjG4Z
   B+aViY1S6BqkPM5XNnJjz7SmAWR5MSf1B+hxpK4mHRtgx23UK7nhvgBWl
   9LKmb+dVYMwX1N6HtqBu4w4nl69SRPeGnoGgO+TWKJtRcsK4mQfoUh+wV
   TViO7+kufYfW1wO0fMuTwj/+Sn1GiIb4u3L5gt7DTXPlPihDAvBC6wkjv
   BIgiA5Lhc4GfQe1mghpRSBqpQqqrIJPYHBCXBPZ1YCU1unwMxG9WhVEL7
   l/fjLlNoXFKcN13p+BjKjcO6HAAmo/uDcUvoiSoy2QBnUdBKGn8ApGAEu
   Q==;
X-CSE-ConnectionGUID: dh82f3X/Rg6qbL9efLIa3g==
X-CSE-MsgGUID: +uBYqLTyTvy6kLgJU9B2Cg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49566667"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49566667"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:26 -0700
X-CSE-ConnectionGUID: qH/3r4eJRWqXLyP4ArAIjw==
X-CSE-MsgGUID: Dn1CjrlUSPixRMIoLxJdBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144905270"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:22 -0700
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
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v5 06/10] memory: Attach RamBlockAttribute to guest_memfd-backed RAMBlocks
Date: Tue, 20 May 2025 18:28:46 +0800
Message-ID: <20250520102856.132417-7-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250520102856.132417-1-chenyi.qiang@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A new field, ram_shared, was introduced in RAMBlock to link to a
RamBlockAttribute object, which centralizes all guest_memfd state
information (such as fd and shared_bitmap) within a RAMBlock.

Create and initialize the RamBlockAttribute object upon ram_block_add().
Meanwhile, register the object in the target RAMBlock's MemoryRegion.
After that, guest_memfd-backed RAMBlock is associated with the
RamDiscardManager interface, and the users will execute
RamDiscardManager specific handling. For example, VFIO will register the
RamDiscardListener as expected. The live migration path needs to be
avoided since it is not supported yet in confidential VMs.

Additionally, use the ram_block_attribute_state_change() helper to
notify the registered RamDiscardListener of these changes.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
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

Changes in v2:
    - Introduce a new field memory_attribute_manager in RAMBlock.
    - Move the state_change() handling during page conversion in this patch.
    - Undo what we did if it fails to set.
    - Change the order of close(guest_memfd) and memory_attribute_manager cleanup.
---
 accel/kvm/kvm-all.c |  9 +++++++++
 migration/ram.c     | 28 ++++++++++++++++++++++++++++
 system/physmem.c    | 14 ++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 51526d301b..2d7ecaeb6a 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3089,6 +3089,15 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
     rb = qemu_ram_block_from_host(addr, false, &offset);
 
+    ret = ram_block_attribute_state_change(RAM_BLOCK_ATTRIBUTE(mr->rdm),
+                                           offset, size, to_private);
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
diff --git a/migration/ram.c b/migration/ram.c
index c004f37060..69c9a42f16 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -890,6 +890,13 @@ static uint64_t ramblock_dirty_bitmap_clear_discarded_pages(RAMBlock *rb)
 
     if (rb->mr && rb->bmap && memory_region_has_ram_discard_manager(rb->mr)) {
         RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
+
+        if (object_dynamic_cast(OBJECT(rdm), TYPE_RAM_BLOCK_ATTRIBUTE)) {
+            error_report("%s: Live migration for confidential VM is not "
+                         "supported yet.", __func__);
+            exit(1);
+        }
+
         MemoryRegionSection section = {
             .mr = rb->mr,
             .offset_within_region = 0,
@@ -913,6 +920,13 @@ bool ramblock_page_is_discarded(RAMBlock *rb, ram_addr_t start)
 {
     if (rb->mr && memory_region_has_ram_discard_manager(rb->mr)) {
         RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
+
+        if (object_dynamic_cast(OBJECT(rdm), TYPE_RAM_BLOCK_ATTRIBUTE)) {
+            error_report("%s: Live migration for confidential VM is not "
+                         "supported yet.", __func__);
+            exit(1);
+        }
+
         MemoryRegionSection section = {
             .mr = rb->mr,
             .offset_within_region = start,
@@ -1552,6 +1566,13 @@ static void ram_block_populate_read(RAMBlock *rb)
      */
     if (rb->mr && memory_region_has_ram_discard_manager(rb->mr)) {
         RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
+
+        if (object_dynamic_cast(OBJECT(rdm), TYPE_RAM_BLOCK_ATTRIBUTE)) {
+            error_report("%s: Live migration for confidential VM is not "
+                         "supported yet.", __func__);
+            exit(1);
+        }
+
         MemoryRegionSection section = {
             .mr = rb->mr,
             .offset_within_region = 0,
@@ -1611,6 +1632,13 @@ static int ram_block_uffd_protect(RAMBlock *rb, int uffd_fd)
     /* See ram_block_populate_read() */
     if (rb->mr && memory_region_has_ram_discard_manager(rb->mr)) {
         RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
+
+        if (object_dynamic_cast(OBJECT(rdm), TYPE_RAM_BLOCK_ATTRIBUTE)) {
+            error_report("%s: Live migration for confidential VM is not "
+                         "supported yet.", __func__);
+            exit(1);
+        }
+
         MemoryRegionSection section = {
             .mr = rb->mr,
             .offset_within_region = 0,
diff --git a/system/physmem.c b/system/physmem.c
index a8a9ca309e..f05f7ff09a 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1931,6 +1931,19 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
             goto out_free;
         }
 
+        new_block->ram_shared = ram_block_attribute_create(new_block->mr);
+        if (!new_block->ram_shared) {
+            error_setg(errp, "Failed to create ram block attribute");
+            /*
+             * The error path could be unified if the rest of ram_block_add()
+             * ever develops a need to check for errors.
+             */
+            close(new_block->guest_memfd);
+            ram_block_discard_require(false);
+            qemu_mutex_unlock_ramlist();
+            goto out_free;
+        }
+
         /*
          * Add a specific guest_memfd blocker if a generic one would not be
          * added by ram_block_add_cpr_blocker.
@@ -2287,6 +2300,7 @@ static void reclaim_ramblock(RAMBlock *block)
     }
 
     if (block->guest_memfd >= 0) {
+        ram_block_attribute_destroy(block->ram_shared);
         close(block->guest_memfd);
         ram_block_discard_require(false);
     }
-- 
2.43.5


