Return-Path: <kvm+bounces-45924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5522AAAFE83
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:11:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A9B116C1AB
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3317279917;
	Thu,  8 May 2025 15:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RlROz0aH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CC5279916
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716762; cv=none; b=BgDARYN6an6xosq6QxJglwbTSkGJqi87+rwKnkxeK1Nwy/zDwCb6BjNEMBOIKaa0PYSSfM9ou5rh43GL8bwzh3CDmmGC7YteeSpCe2QeljlpNgLRAGvMrw3vDpKDhxsE61DbPGSY9Vq5wuuSNg0yWdt/7fSVAT6JGQnJNSYMGtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716762; c=relaxed/simple;
	bh=uuTstmDS5i+HnC7+/DzfUFJjK3Y71tYlo9wSAV1l0tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipqceglbDv4RyUycnbbClh3LCH/57tg8XWRgPb+4De38NTh1BMC7ULokq9yiPvrjsN/hZeEKF9wzpCXqSFHl9bum7SjwDWI8uhWtTTfKIHTMutaU+BmwOScNorHGbIuHGKT+/1mSB6DvkZwyUMcMomCswvUfDtmIHzhOVRojs6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RlROz0aH; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716760; x=1778252760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uuTstmDS5i+HnC7+/DzfUFJjK3Y71tYlo9wSAV1l0tE=;
  b=RlROz0aHgAICM3bsbEQcdLz6GInkVkg0+71iUZHib9+lwgWKG5BP+Sx3
   UCP/S7zkBEZ+ot3l4hOtvbz5ECab1ZTKoMOrz8eVGS18MqebmaE5mjpA0
   Om01dpbDqXowlMVy+/GtY1i2lUE476Rq+62T3Wkxzg3RfHL9fS7pgu+he
   KRbyB9jOSuoRB+PjY1ScfWsXhGokl1RgT9lH0gQOVxqPSQUIxYyTvWPr7
   TMmT3Wxo6zPIIsX1kqJHmRbNJ93nMcs0EO4Abl6362d7hjQXt1Pic/8zX
   l0yjFPLNWW/N+3r0h8bdfU3uOYmlkElfT87DAOuRXhGxwjh8F7SJGY33B
   Q==;
X-CSE-ConnectionGUID: UR50QwaDQByFRXoubN3Taw==
X-CSE-MsgGUID: +nZJIeb9SmSeAmCPHIpfDg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888170"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888170"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:00 -0700
X-CSE-ConnectionGUID: 6rGq/mcpQNCEgk7X86Ovtg==
X-CSE-MsgGUID: f/UZv+0RTOePmaA16vjC/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439967"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:05:57 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 21/55] i386/tdx: Track RAM entries for TDX VM
Date: Thu,  8 May 2025 10:59:27 -0400
Message-ID: <20250508150002.689633-22-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RAM of TDX VM can be classified into two types:

 - TDX_RAM_UNACCEPTED: default type of TDX memory, which needs to be
   accepted by TDX guest before it can be used and will be all-zeros
   after being accepted.

 - TDX_RAM_ADDED: the RAM that is ADD'ed to TD guest before running, and
   can be used directly. E.g., TD HOB and TEMP MEM that needed by TDVF.

Maintain TdxRamEntries[] which grabs the initial RAM info from e820 table
and mark each RAM range as default type TDX_RAM_UNACCEPTED.

Then turn the range of TD HOB and TEMP MEM to TDX_RAM_ADDED since these
ranges will be ADD'ed before TD runs and no need to be accepted runtime.

The TdxRamEntries[] are later used to setup the memory TD resource HOB
that passes memory info from QEMU to TDVF.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v9:
- Add error handling of tdx_accept_ram_range();

Changes in v3:
- use enum TdxRamType in struct TdxRamEntry; (Isaku)
- Fix the indention; (Daniel)

Changes in v1:
  - simplify the algorithm of tdx_accept_ram_range() (Suggested-by: Gerd Hoffman)
    (1) Change the existing entry to cover the accepted ram range.
    (2) If there is room before the accepted ram range add a
	TDX_RAM_UNACCEPTED entry for that.
    (3) If there is room after the accepted ram range add a
	TDX_RAM_UNACCEPTED entry for that.
---
 target/i386/kvm/tdx.c | 116 ++++++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h |  14 +++++
 2 files changed, 130 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index e2794843a9db..ec48bfcc7226 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -18,6 +18,7 @@
 #include "crypto/hash.h"
 #include "system/system.h"
 
+#include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/tdvf.h"
 #include "hw/i386/x86.h"
 #include "kvm_i386.h"
@@ -146,11 +147,117 @@ void tdx_set_tdvf_region(MemoryRegion *tdvf_mr)
     tdx_guest->tdvf_mr = tdvf_mr;
 }
 
+static void tdx_add_ram_entry(uint64_t address, uint64_t length,
+                              enum TdxRamType type)
+{
+    uint32_t nr_entries = tdx_guest->nr_ram_entries;
+    tdx_guest->ram_entries = g_renew(TdxRamEntry, tdx_guest->ram_entries,
+                                     nr_entries + 1);
+
+    tdx_guest->ram_entries[nr_entries].address = address;
+    tdx_guest->ram_entries[nr_entries].length = length;
+    tdx_guest->ram_entries[nr_entries].type = type;
+    tdx_guest->nr_ram_entries++;
+}
+
+static int tdx_accept_ram_range(uint64_t address, uint64_t length)
+{
+    uint64_t head_start, tail_start, head_length, tail_length;
+    uint64_t tmp_address, tmp_length;
+    TdxRamEntry *e;
+    int i;
+
+    for (i = 0; i < tdx_guest->nr_ram_entries; i++) {
+        e = &tdx_guest->ram_entries[i];
+
+        if (address + length <= e->address ||
+            e->address + e->length <= address) {
+            continue;
+        }
+
+        /*
+         * The to-be-accepted ram range must be fully contained by one
+         * RAM entry.
+         */
+        if (e->address > address ||
+            e->address + e->length < address + length) {
+            return -1;
+        }
+
+        if (e->type == TDX_RAM_ADDED) {
+            return 0;
+        }
+
+        break;
+    }
+
+    if (i == tdx_guest->nr_ram_entries) {
+        return -1;
+    }
+
+    tmp_address = e->address;
+    tmp_length = e->length;
+
+    e->address = address;
+    e->length = length;
+    e->type = TDX_RAM_ADDED;
+
+    head_length = address - tmp_address;
+    if (head_length > 0) {
+        head_start = tmp_address;
+        tdx_add_ram_entry(head_start, head_length, TDX_RAM_UNACCEPTED);
+    }
+
+    tail_start = address + length;
+    if (tail_start < tmp_address + tmp_length) {
+        tail_length = tmp_address + tmp_length - tail_start;
+        tdx_add_ram_entry(tail_start, tail_length, TDX_RAM_UNACCEPTED);
+    }
+
+    return 0;
+}
+
+static int tdx_ram_entry_compare(const void *lhs_, const void* rhs_)
+{
+    const TdxRamEntry *lhs = lhs_;
+    const TdxRamEntry *rhs = rhs_;
+
+    if (lhs->address == rhs->address) {
+        return 0;
+    }
+    if (le64_to_cpu(lhs->address) > le64_to_cpu(rhs->address)) {
+        return 1;
+    }
+    return -1;
+}
+
+static void tdx_init_ram_entries(void)
+{
+    unsigned i, j, nr_e820_entries;
+
+    nr_e820_entries = e820_get_table(NULL);
+    tdx_guest->ram_entries = g_new(TdxRamEntry, nr_e820_entries);
+
+    for (i = 0, j = 0; i < nr_e820_entries; i++) {
+        uint64_t addr, len;
+
+        if (e820_get_entry(i, E820_RAM, &addr, &len)) {
+            tdx_guest->ram_entries[j].address = addr;
+            tdx_guest->ram_entries[j].length = len;
+            tdx_guest->ram_entries[j].type = TDX_RAM_UNACCEPTED;
+            j++;
+        }
+    }
+    tdx_guest->nr_ram_entries = j;
+}
+
 static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
     TdxFirmwareEntry *entry;
 
+    tdx_init_ram_entries();
+
     for_each_tdx_fw_entry(tdvf, entry) {
         switch (entry->type) {
         case TDVF_SECTION_TYPE_BFV:
@@ -166,12 +273,21 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
                              entry->type);
                 exit(1);
             }
+            if (tdx_accept_ram_range(entry->address, entry->size)) {
+                error_report("Failed to accept memory for TDVF section %d",
+                             entry->type);
+                qemu_ram_munmap(-1, entry->mem_ptr, entry->size);
+                exit(1);
+            }
             break;
         default:
             error_report("Unsupported TDVF section %d", entry->type);
             exit(1);
         }
     }
+
+    qsort(tdx_guest->ram_entries, tdx_guest->nr_ram_entries,
+          sizeof(TdxRamEntry), &tdx_ram_entry_compare);
 }
 
 static Notifier tdx_machine_done_notify = {
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 28a03c2a7b82..36a7400e7480 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -20,6 +20,17 @@ typedef struct TdxGuestClass {
 /* TDX requires bus frequency 25MHz */
 #define TDX_APIC_BUS_CYCLES_NS 40
 
+enum TdxRamType {
+    TDX_RAM_UNACCEPTED,
+    TDX_RAM_ADDED,
+};
+
+typedef struct TdxRamEntry {
+    uint64_t address;
+    uint64_t length;
+    enum TdxRamType type;
+} TdxRamEntry;
+
 typedef struct TdxGuest {
     X86ConfidentialGuest parent_obj;
 
@@ -34,6 +45,9 @@ typedef struct TdxGuest {
 
     MemoryRegion *tdvf_mr;
     TdxFirmware tdvf;
+
+    uint32_t nr_ram_entries;
+    TdxRamEntry *ram_entries;
 } TdxGuest;
 
 #ifdef CONFIG_TDX
-- 
2.43.0


