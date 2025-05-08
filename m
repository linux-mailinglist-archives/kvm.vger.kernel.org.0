Return-Path: <kvm+bounces-45927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 22193AAFE77
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DFA2B41D09
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A99227A127;
	Thu,  8 May 2025 15:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TcVB5Iod"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF6E284662
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716771; cv=none; b=qXPlhDwN/7tjyBtx+D/XUWZrWo3B+L06IiFbYLK73S4PhtScFr2VN1CD03qZf+UqEN0KvGlPLRptH/GrK/YPG+LwFWog5asFTUHyRmMyeMJp9XeCX5+S+2c+Q1C/POTRg85r72sbUy+LY1auDBHzj35g2V+qHpPHM7xfYiTTqAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716771; c=relaxed/simple;
	bh=D4IRLcKZtl5/KG1JlFXyQKH3kpmLXgl1SrfSklWW7eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3msdDZ3BhhguLJfjeETSHIYXAYm4po9x9qk35XEpgz9cid6P3KtC0MuCVMTMOVACJqq1xpRbSC+ragrePLA9M858nfTTsOAA8egibj2l29fiApLpl0Im8M/c6MuhbYl7a6V9taoEZwhJDrn2NGrh6OdRO1ks/YvlIbrZWKmdWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TcVB5Iod; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716770; x=1778252770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D4IRLcKZtl5/KG1JlFXyQKH3kpmLXgl1SrfSklWW7eE=;
  b=TcVB5IodhnOM2pPZ7xJofdkYuymc6Fp2NztO3AupFMbgZczDM9yLQyvY
   la/HliX/+mrLVRvbJ/M+FHvUsAk6RxezQBNvXoaIpgS8SbbKJm8sdFD1y
   xlj+1CrIYEmwfRYx2Jf+dCF3DYSgq7eEpaRRafGl0VbKodm4k/Xzhx5A0
   WwvcEyFf4S/smEJ5VJw+9FxEtHJfoXXLpQm1DUTbEwbGOguX85HAr/SMV
   cqa7bhLVTnNgTvUiTwwZb8AtXJJQHZU6AAop51S0d5mheE2wVyU/4QeP+
   6mJWwogoU4hWfgf8UdKpvC0F8rGbOA9tXJqpneTVDvrvDBc6JtNP1K9dn
   A==;
X-CSE-ConnectionGUID: QWfUr7ewS/2vLy6S8CK0qA==
X-CSE-MsgGUID: QWg+/xv3QoKo0qQW1JevYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888195"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888195"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:09 -0700
X-CSE-ConnectionGUID: OMZyKA3QRXSqyXN3LLQ5jQ==
X-CSE-MsgGUID: 8l6jpUgeRjWjKw70km2Wzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440025"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:06 -0700
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
Subject: [PATCH v9 24/55] i386/tdx: Add TDVF memory via KVM_TDX_INIT_MEM_REGION
Date: Thu,  8 May 2025 10:59:30 -0400
Message-ID: <20250508150002.689633-25-xiaoyao.li@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDVF firmware (CODE and VARS) needs to be copied to TD's private
memory via KVM_TDX_INIT_MEM_REGION, as well as TD HOB and TEMP memory.

If the TDVF section has TDVF_SECTION_ATTRIBUTES_MR_EXTEND set in the
flag, calling KVM_TDX_EXTEND_MEMORY to extend the measurement.

After populating the TDVF memory, the original image located in shared
ramblock can be discarded.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v6:
 - switch back to use KVM_TDX_INIT_MEM_REGION according to KVM's change;
---
 target/i386/kvm/tdx.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index de682a93e51c..6a9215d9f0d7 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -17,6 +17,7 @@
 #include "qom/object_interfaces.h"
 #include "crypto/hash.h"
 #include "system/system.h"
+#include "exec/ramblock.h"
 
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/tdvf.h"
@@ -269,6 +270,9 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
     TdxFirmwareEntry *entry;
+    RAMBlock *ram_block;
+    Error *local_err = NULL;
+    int r;
 
     tdx_init_ram_entries();
 
@@ -304,6 +308,44 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
           sizeof(TdxRamEntry), &tdx_ram_entry_compare);
 
     tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
+
+    for_each_tdx_fw_entry(tdvf, entry) {
+        struct kvm_tdx_init_mem_region region;
+        uint32_t flags;
+
+        region = (struct kvm_tdx_init_mem_region) {
+            .source_addr = (uint64_t)entry->mem_ptr,
+            .gpa = entry->address,
+            .nr_pages = entry->size >> 12,
+        };
+
+        flags = entry->attributes & TDVF_SECTION_ATTRIBUTES_MR_EXTEND ?
+                KVM_TDX_MEASURE_MEMORY_REGION : 0;
+
+        do {
+            error_free(local_err);
+            local_err = NULL;
+            r = tdx_vcpu_ioctl(first_cpu, KVM_TDX_INIT_MEM_REGION, flags,
+                               &region, &local_err);
+        } while (r == -EAGAIN || r == -EINTR);
+        if (r < 0) {
+            error_report_err(local_err);
+            exit(1);
+        }
+
+        if (entry->type == TDVF_SECTION_TYPE_TD_HOB ||
+            entry->type == TDVF_SECTION_TYPE_TEMP_MEM) {
+            qemu_ram_munmap(-1, entry->mem_ptr, entry->size);
+            entry->mem_ptr = NULL;
+        }
+    }
+
+    /*
+     * TDVF image has been copied into private region above via
+     * KVM_MEMORY_MAPPING. It becomes useless.
+     */
+    ram_block = tdx_guest->tdvf_mr->ram_block;
+    ram_block_discard_range(ram_block, 0, ram_block->max_length);
 }
 
 static Notifier tdx_machine_done_notify = {
-- 
2.43.0


