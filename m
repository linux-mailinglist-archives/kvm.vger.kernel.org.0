Return-Path: <kvm+bounces-6942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2192B83B818
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:32:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F24A1F21695
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46B10107B4;
	Thu, 25 Jan 2024 03:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="brBOVKZx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFFA748D
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153412; cv=none; b=W/TnlceqGhs7DJgLyjgwo5RkG/djjO3cgDbqmhRwW7JUQ/LQwJpVQZweaLIr1a8clr7EH+lQv3v3I67N5itL12EIjNbWEL5Gp6IYr+23BYkV2RGhULRn2RhCyclVeoBYgElOBy0cU/XFFErkY5LYpRlGorvO2aZzuZ5Ro/gfnIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153412; c=relaxed/simple;
	bh=pqlef+BHr2IcdindiCfmL2SellunImM1H5iUxXML6lI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dhezIXpAZd5W3baRJ1irl85XXdGp0oxckyus+E2Bh0r8jPGBLefPfFfKP/5zBMDPFEU6DkYivdZegTtPYmYvGZ1WNh6SMfSCwN8wXryf3Xfd03ALR5Z9o1zGmu4eEe4BG7As4ryqPoXOoHZINbqC1LSuQewQtf+j7ePdkyA+9s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=brBOVKZx; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153411; x=1737689411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pqlef+BHr2IcdindiCfmL2SellunImM1H5iUxXML6lI=;
  b=brBOVKZxIs+2p+jyb/4B9+9XbSbRjLcUY2GEu84EIYetygi85ezzPGVL
   zOEXAUvGk4QpGc3/3jV4O/ecxzgZo91QErln4IdYFTHgPGRUJ/sd8RhdZ
   JV1WW5eka2jUh6sI2/m6PDwZegWIdLYei2hv0DfOgE4h6Jv/p0JlHfYkd
   oumDDnKRT+o4kRuLqSI1URt0awhQ6tygjmb3TvlcBqUqq68/02Ja/g81B
   d6Kxvyazehi7Y/gkjAJC7q//YOhogJng6epN9Qd+BlOUDpYBJaKAI72Od
   zKoCm4kijKZgfiobn/QnqLr3BueeaMHBQNQPlWTCxFQDUg1s6wz0PcDKC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9429522"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9429522"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:27:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2085912"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:27:12 -0800
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
Subject: [PATCH v4 40/66] i386/tdx: Track mem_ptr for each firmware entry of TDVF
Date: Wed, 24 Jan 2024 22:23:02 -0500
Message-Id: <20240125032328.2522472-41-xiaoyao.li@intel.com>
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

For each TDVF sections, QEMU needs to copy the content to guest
private memory via KVM API (KVM_TDX_INIT_MEM_REGION).

Introduce a field @mem_ptr for TdxFirmwareEntry to track the memory
pointer of each TDVF sections. So that QEMU can add/copy them to guest
private memory later.

TDVF sections can be classified into two groups:
 - Firmware itself, e.g., TDVF BFV and CFV, that located separately from
   guest RAM. Its memory pointer is the bios pointer.

 - Sections located at guest RAM, e.g., TEMP_MEM and TD_HOB.
   mmap a new memory range for them.

Register a machine_init_done callback to do the stuff.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 hw/i386/tdvf.c         |  1 +
 include/hw/i386/tdvf.h |  7 +++++++
 target/i386/kvm/tdx.c  | 31 +++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/hw/i386/tdvf.c b/hw/i386/tdvf.c
index ff51f40088f0..0a6445705160 100644
--- a/hw/i386/tdvf.c
+++ b/hw/i386/tdvf.c
@@ -189,6 +189,7 @@ int tdvf_parse_metadata(TdxFirmware *fw, void *flash_ptr, int size)
     }
     g_free(sections);
 
+    fw->mem_ptr = flash_ptr;
     return 0;
 
 err:
diff --git a/include/hw/i386/tdvf.h b/include/hw/i386/tdvf.h
index 593341eb2e93..d880af245a73 100644
--- a/include/hw/i386/tdvf.h
+++ b/include/hw/i386/tdvf.h
@@ -39,13 +39,20 @@ typedef struct TdxFirmwareEntry {
     uint64_t size;
     uint32_t type;
     uint32_t attributes;
+
+    void *mem_ptr;
 } TdxFirmwareEntry;
 
 typedef struct TdxFirmware {
+    void *mem_ptr;
+
     uint32_t nr_entries;
     TdxFirmwareEntry *entries;
 } TdxFirmware;
 
+#define for_each_tdx_fw_entry(fw, e)    \
+    for (e = (fw)->entries; e != (fw)->entries + (fw)->nr_entries; e++)
+
 int tdvf_parse_metadata(TdxFirmware *fw, void *flash_ptr, int size);
 
 #endif /* HW_I386_TDVF_H */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index c743340c145c..825a432255ff 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -14,6 +14,7 @@
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
 #include "qemu/base64.h"
+#include "qemu/mmap-alloc.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
 #include "standard-headers/asm-x86/kvm_para.h"
@@ -22,6 +23,7 @@
 #include "exec/address-spaces.h"
 
 #include "hw/i386/x86.h"
+#include "hw/i386/tdvf.h"
 #include "kvm_i386.h"
 #include "tdx.h"
 #include "../cpu-internal.h"
@@ -464,6 +466,33 @@ static void update_tdx_cpuid_lookup_by_tdx_caps(void)
             (tdx_caps->xfam_fixed1 & CPUID_XSTATE_XSS_MASK) >> 32;
 }
 
+static void tdx_finalize_vm(Notifier *notifier, void *unused)
+{
+    TdxFirmware *tdvf = &tdx_guest->tdvf;
+    TdxFirmwareEntry *entry;
+
+    for_each_tdx_fw_entry(tdvf, entry) {
+        switch (entry->type) {
+        case TDVF_SECTION_TYPE_BFV:
+        case TDVF_SECTION_TYPE_CFV:
+            entry->mem_ptr = tdvf->mem_ptr + entry->data_offset;
+            break;
+        case TDVF_SECTION_TYPE_TD_HOB:
+        case TDVF_SECTION_TYPE_TEMP_MEM:
+            entry->mem_ptr = qemu_ram_mmap(-1, entry->size,
+                                           qemu_real_host_page_size(), 0, 0);
+            break;
+        default:
+            error_report("Unsupported TDVF section %d", entry->type);
+            exit(1);
+        }
+    }
+}
+
+static Notifier tdx_machine_done_notify = {
+    .notify = tdx_finalize_vm,
+};
+
 int tdx_kvm_init(MachineState *ms, Error **errp)
 {
     TdxGuest *tdx = TDX_GUEST(OBJECT(ms->cgs));
@@ -489,6 +518,8 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
      */
     kvm_readonly_mem_allowed = false;
 
+    qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
+
     tdx_guest = tdx;
     return 0;
 }
-- 
2.34.1


