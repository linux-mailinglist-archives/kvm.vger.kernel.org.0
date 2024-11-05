Return-Path: <kvm+bounces-30655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A08109BC594
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:38:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C43511C213D2
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60151FCC56;
	Tue,  5 Nov 2024 06:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lJ6sZ5xR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633191FCC63
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788674; cv=none; b=rgLyfGwip+U712C0/z0K0pCjHwp6gyp/1TTc6xoNJD+tB7EH33sliNdI12rx6iItbk7UHe2gEN67kMgCY3IC4o6X290EGNg1irMSMBGsciTPS2HDbh354d9NOusjBJnmR4q+m1/9HERjUKyTI3nv7fcZBeerePvP/PF1NFSPVHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788674; c=relaxed/simple;
	bh=O+bsng0OpqwNAjJu2viZcM1uSHuVeOnU2MBD79mzkgE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V7VxryzV0jxSKJ87bnTFChvCJBasOdjeG04dKjXB3fAI2rkwDgiOdb0zQDENo9tCgfSkjx6ovHGO63ykG8oD+Nqi3PX7ZREUu5AFSCgxHb5YnrSP6+vo6K7nxB0euFWiyjiT9fvTxOnVhY2UYSkXMWhBXctfZ0WJuDZilpaKzcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lJ6sZ5xR; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788673; x=1762324673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O+bsng0OpqwNAjJu2viZcM1uSHuVeOnU2MBD79mzkgE=;
  b=lJ6sZ5xR07xGHLj+D14HMhKGMmckab+syj4n/Wp/8gtQe3zEohALtHvb
   Spj14lRjjpXd9jLpFGM9wcV/Ue0uDErSVIXGk9xITT62Fblu3AdFWZQrN
   JjVnRuyzJUFCbydmZcKhAMa+PDdw3f7uoAW+JOve3MMkJmjRTQngEVIpH
   Vmg/y8y5WonRwllV8rcczLfIGemkT7d+84AjQAlk88rsydPKOmA6prHMq
   ezqv8K6sXq3WVTLaSizjVNHSNQI6D/4fSzjdZ7WZ2XcLILRwOM2dJG7aM
   h7FGw3NtxqGM1VIc4HI0HyYo+nWZgXFD9DdRLjSP1Ndflj5b4wNit+e15
   w==;
X-CSE-ConnectionGUID: 8EV8Y5elRkq05/MBIhjdAA==
X-CSE-MsgGUID: PQTl/QAhSd+J/2omuAGgSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689535"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689535"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:37:53 -0800
X-CSE-ConnectionGUID: igX+T3kWQlmGCs/qvn4FXA==
X-CSE-MsgGUID: flkki1dAQsOAxyMp0EcImg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988983"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:37:49 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 21/60] i386/tdx: Track mem_ptr for each firmware entry of TDVF
Date: Tue,  5 Nov 2024 01:23:29 -0500
Message-Id: <20241105062408.3533704-22-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
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
index 4afa636bfa0e..535409f34b41 100644
--- a/hw/i386/tdvf.c
+++ b/hw/i386/tdvf.c
@@ -190,6 +190,7 @@ int tdvf_parse_metadata(TdxFirmware *fw, void *flash_ptr, int size)
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
index 334dbe95cc77..6777f66a6451 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -14,9 +14,13 @@
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
 #include "qemu/base64.h"
+#include "qemu/mmap-alloc.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
+#include "sysemu/sysemu.h"
 
+#include "hw/i386/x86.h"
+#include "hw/i386/tdvf.h"
 #include "hw/i386/x86.h"
 #include "kvm_i386.h"
 #include "tdx.h"
@@ -126,6 +130,33 @@ void tdx_set_tdvf_region(MemoryRegion *tdvf_mr)
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
@@ -140,6 +171,8 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         }
     }
 
+    qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
+
     tdx_guest = tdx;
     return 0;
 }
-- 
2.34.1


