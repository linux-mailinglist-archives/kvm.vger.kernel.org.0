Return-Path: <kvm+bounces-36504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B451A1B6FC
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:38:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E1DC16CE15
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B954B78F5D;
	Fri, 24 Jan 2025 13:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W4tiG91J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726584AEE2
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725895; cv=none; b=omDqEDu3zSp7j3MMpNgPmmZA3zF2yKLElalRYLC4R25HWD3n1pd0/LH+gskkBjHLczQRzhBcSSuS0H20VATD/h+rZePclIjon/DUqvq6WZrjnW0mj6QlFzRKEH8WJYk2Hh7kuYLoQ+frA0TIQxwscmEGKaOfvprSaLxIfU1WCE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725895; c=relaxed/simple;
	bh=DXpMC+tvWG2bJ2wmr3p9vzssFXm2kjDUo/t7kVqEp9k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JxIrUtnlpNpKx5kV2UPLtkwZwvVja34CqDVLGCYWL38ps+mMMsnrSeFg7zVxrHV3EOvnzyTOH9uCcZ4TrcxctfCxH5IPZ++CVKLk8tAnDqw8J+m7p7Yb5CkMks/lD7poQhAJFnXDdftr6yDHhwtDJnC3GCKjpDloelBW6UKAJ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W4tiG91J; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725894; x=1769261894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DXpMC+tvWG2bJ2wmr3p9vzssFXm2kjDUo/t7kVqEp9k=;
  b=W4tiG91Jkc/mCIEbUfpMBvNm/jxaDf+NZd2wbifJbXt7zr3L6iZy+wAE
   V/umvs8BeImT52sBp02wMUPO7ob8h5zERDyey9FNKD+eziQcGnYenn2bg
   w4QKkmHWj4paXPAjPO2u1qoVVyOLt68D2GnCbA1+4IMSgdPS3dsUsOtgB
   2nG/ocD6WCEGzwonTWd39sm9TebGCxq2nKQdxyKVEHYvuNp3zgaO8oIdz
   89r6dDXGYMHUM3OorFovgG0F58TcPo3rXoMsbJq39iolt4ZbxUUmmkQ5h
   0XZecTWqTSFGHtBFQaV1eM/tPbGMJbgBcYKMtHuIc/bckdTI90q6Zysjo
   g==;
X-CSE-ConnectionGUID: lcSSM0JUSDCnrUUWaEoKXA==
X-CSE-MsgGUID: zJJW255TT1W9C5uyl8p8LA==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246361"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246361"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:38:14 -0800
X-CSE-ConnectionGUID: AjZTTzDmQM6xqe0hhFX0zA==
X-CSE-MsgGUID: D7OT/wdNTdyDe1rt+e8JQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804275"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:09 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 19/52] i386/tdx: Track mem_ptr for each firmware entry of TDVF
Date: Fri, 24 Jan 2025 08:20:15 -0500
Message-Id: <20250124132048.3229049-20-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
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
 target/i386/kvm/tdx.c  | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/hw/i386/tdvf.c b/hw/i386/tdvf.c
index 887af41ff486..b693b3e6f8e2 100644
--- a/hw/i386/tdvf.c
+++ b/hw/i386/tdvf.c
@@ -177,6 +177,7 @@ int tdvf_parse_metadata(TdxFirmware *fw, void *flash_ptr, int size)
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
index 73f90b0a2217..8564b3ae905d 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -12,10 +12,14 @@
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
 #include "qemu/base64.h"
+#include "qemu/mmap-alloc.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
 #include "crypto/hash.h"
+#include "system/system.h"
 
+#include "hw/i386/x86.h"
+#include "hw/i386/tdvf.h"
 #include "hw/i386/x86.h"
 #include "kvm_i386.h"
 #include "tdx.h"
@@ -143,6 +147,33 @@ void tdx_set_tdvf_region(MemoryRegion *tdvf_mr)
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
@@ -157,6 +188,8 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         }
     }
 
+    qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
+
     tdx_guest = tdx;
     return 0;
 }
-- 
2.34.1


