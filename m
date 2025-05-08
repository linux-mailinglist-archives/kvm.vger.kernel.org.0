Return-Path: <kvm+bounces-45923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0F95AAFE7A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22594188495A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931DA28312E;
	Thu,  8 May 2025 15:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fAn6/SI5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3362820CD
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716758; cv=none; b=RolkOXKu9iqZpduz/fvm1knK+YNV+sSjIgTz5IWIdHO8NoM3g6Pyh+4Bypy2Sna2u9UkfGXGy6M/iBFe38zsUtJWAnwTOiivPT9/vTDBk+LsJt/KaDpFiOoMEURuSI3aIZsztgcqOOkCXqEHwG/0Wca4HRB4LPf/H+qJsAgltRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716758; c=relaxed/simple;
	bh=RPTMrLQkM3bIxbRVYOEBZ9rV41Eau9U5ifMZEE5ypx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PG5uR/RrrN3kGQyA+ykQeueVjZ0itKypertT1wAIUs++STUmyfb0f8WYHQd8YK6k93bLZIzx6xdiKZo58pCS6N3A6EzDZtbyvexz2bVspyARRF0Gvcno5YfAG06AusWgkEY2j/BhYB+87jtybVsNycKk5WO1pBA4ancs6HKNJPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fAn6/SI5; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716757; x=1778252757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RPTMrLQkM3bIxbRVYOEBZ9rV41Eau9U5ifMZEE5ypx0=;
  b=fAn6/SI5y9TYvTtKO7/+ORaOqljlQNiBGcT4zQiyrmrR/yexwfrgq0jM
   D/PG4whhL+7QLmtVIApXfmenCa+ePKBXLkWQvdQY74Ay/8YPnL5AQLxxE
   yT8gDqOskO8lGuG9xZcmN0PFOytlZZL0sRPMCfLdFWX/0qS7xXUKU9xZO
   JDZnM3NU4gbG4YN6oVcpPZjyGuS3eXTws+TSA/l2y1lT8spHYcMlgHtgs
   2vBn1JpIHGz3ifGPZ6s2twVNJbwmWdjTJDNeMoq/VLj5pbdDSLj6YE5/X
   MXq4M6MrawnM6Djw6d0kp3476zWNROUaMtev0wa4tSGpHgO9wDVHOwV1X
   w==;
X-CSE-ConnectionGUID: HhYHslokS7iOBI5zE8W3cQ==
X-CSE-MsgGUID: S7f7LfP1TcmlB0qsixMeVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888159"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888159"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:05:57 -0700
X-CSE-ConnectionGUID: SpTfsLpbTSm6BZLpLRbESQ==
X-CSE-MsgGUID: sc2osDjRRLSImdynd04j3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439956"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:05:54 -0700
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
Subject: [PATCH v9 20/55] i386/tdx: Track mem_ptr for each firmware entry of TDVF
Date: Thu,  8 May 2025 10:59:26 -0400
Message-ID: <20250508150002.689633-21-xiaoyao.li@intel.com>
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
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v8:
- Remove the duplicated header include;
- Add error handling for qemu_ram_mmap() failure;
---
 hw/i386/tdvf.c         |  1 +
 include/hw/i386/tdvf.h |  7 +++++++
 target/i386/kvm/tdx.c  | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+)

diff --git a/hw/i386/tdvf.c b/hw/i386/tdvf.c
index 6b1c6aede1e7..b351f7a9a16e 100644
--- a/hw/i386/tdvf.c
+++ b/hw/i386/tdvf.c
@@ -178,6 +178,7 @@ int tdvf_parse_metadata(TdxFirmware *fw, void *flash_ptr, int size)
         }
     }
 
+    fw->mem_ptr = flash_ptr;
     return 0;
 
 err:
diff --git a/include/hw/i386/tdvf.h b/include/hw/i386/tdvf.h
index 7ebcac42a36c..e75c8d1acc68 100644
--- a/include/hw/i386/tdvf.h
+++ b/include/hw/i386/tdvf.h
@@ -26,13 +26,20 @@ typedef struct TdxFirmwareEntry {
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
index 71be3bd28d47..e2794843a9db 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -12,10 +12,13 @@
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
 #include "qemu/base64.h"
+#include "qemu/mmap-alloc.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
 #include "crypto/hash.h"
+#include "system/system.h"
 
+#include "hw/i386/tdvf.h"
 #include "hw/i386/x86.h"
 #include "kvm_i386.h"
 #include "tdx.h"
@@ -143,6 +146,38 @@ void tdx_set_tdvf_region(MemoryRegion *tdvf_mr)
     tdx_guest->tdvf_mr = tdvf_mr;
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
+            if (entry->mem_ptr == MAP_FAILED) {
+                error_report("Failed to mmap memory for TDVF section %d",
+                             entry->type);
+                exit(1);
+            }
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
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     TdxGuest *tdx = TDX_GUEST(cgs);
@@ -157,6 +192,8 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         }
     }
 
+    qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
+
     tdx_guest = tdx;
     return 0;
 }
-- 
2.43.0


