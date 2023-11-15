Return-Path: <kvm+bounces-1776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1CAA7EBDD9
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 402C41F26618
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2264E6AD6;
	Wed, 15 Nov 2023 07:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AECcPlW8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956546119
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:22:06 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608B99E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032925; x=1731568925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cbxWEN7AdUzAAcSeAZm3Cpi9cquc6XfjGquydN+R/is=;
  b=AECcPlW88mBcn7E8TA1NV88UP++Q4UBiU4dEpy92rHUTTKSA5kjzukPI
   XLFNSFnObziwhlBZpzO5V53/NUQqx+n4xBRSs4xhxi9eTf1X69ASnyB22
   PV6NElpNEJpjBJAZ/qQq6YpCld/AwAdqyqwt3O6V0f5nDF5To8PfiJ70E
   eZ96TxuNVaZaoU5iaqf8/zE7SraXEjOMnyjdK78+uMQw9aPkUDqRxJ6YJ
   qe6fJH6CdUd0loL+VI1z0j7CCf9itPkFsnsFWOvkGSB3evNOts3tSNeRy
   2pcXOw3SQgZ1NaEsGvmeFZK5zQ5rCU0OHJgCpsgSxxwzFzkIWBbTctXlR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623358"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623358"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:22:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714800137"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714800137"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:21:57 -0800
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
Subject: [PATCH v3 48/70] i386/tdx: register TDVF as private memory
Date: Wed, 15 Nov 2023 02:14:57 -0500
Message-Id: <20231115071519.2864957-49-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chao Peng <chao.p.peng@linux.intel.com>

Allocate private guest memfd memory for BIOS if it's TD VM.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/i386/x86.c         | 10 +++++++++-
 target/i386/kvm/tdx.c | 18 ++++++++++++++++++
 target/i386/kvm/tdx.h |  2 ++
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 2f299355a5e3..0f69b55c5219 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1146,8 +1146,16 @@ void x86_bios_rom_init(MachineState *ms, const char *default_firmware,
         (bios_size % 65536) != 0) {
         goto bios_error;
     }
+
     bios = g_malloc(sizeof(*bios));
-    memory_region_init_ram(bios, NULL, "pc.bios", bios_size, &error_fatal);
+    if (is_tdx_vm()) {
+        memory_region_init_ram_guest_memfd(bios, NULL, "pc.bios", bios_size,
+                                           &error_fatal);
+        tdx_set_tdvf_region(bios);
+    } else {
+        memory_region_init_ram(bios, NULL, "pc.bios", bios_size, &error_fatal);
+    }
+
     if (sev_enabled() || is_tdx_vm()) {
         /*
          * The concept of a "reset" simply doesn't exist for
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 6bb3249fa610..4b8c13890b11 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -21,6 +21,7 @@
 #include "sysemu/kvm.h"
 #include "sysemu/sysemu.h"
 #include "exec/address-spaces.h"
+#include "exec/ramblock.h"
 
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/x86.h"
@@ -461,6 +462,12 @@ static void update_tdx_cpuid_lookup_by_tdx_caps(void)
             (tdx_caps->xfam_fixed1 & CPUID_XSTATE_XSS_MASK) >> 32;
 }
 
+void tdx_set_tdvf_region(MemoryRegion *tdvf_region)
+{
+    assert(!tdx_guest->tdvf_region);
+    tdx_guest->tdvf_region = tdvf_region;
+}
+
 static TdxFirmwareEntry *tdx_get_hob_entry(TdxGuest *tdx)
 {
     TdxFirmwareEntry *entry;
@@ -582,6 +589,7 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
     TdxFirmwareEntry *entry;
+    RAMBlock *ram_block;
     int r;
 
     tdx_init_ram_entries();
@@ -616,6 +624,12 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
             .nr_pages = entry->size / 4096,
         };
 
+        r = kvm_set_memory_attributes_private(entry->address, entry->size);
+        if (r < 0) {
+             error_report("Reserve initial private memory failed %s", strerror(-r));
+             exit(1);
+        }
+
         __u32 flags = entry->attributes & TDVF_SECTION_ATTRIBUTES_MR_EXTEND ?
                       KVM_TDX_MEASURE_MEMORY_REGION : 0;
 
@@ -631,6 +645,10 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
             entry->mem_ptr = NULL;
         }
     }
+
+    /* Tdvf image was copied into private region above. It becomes unnecessary. */
+    ram_block = tdx_guest->tdvf_region->ram_block;
+    ram_block_discard_range(ram_block, 0, ram_block->max_length);
 }
 
 static Notifier tdx_machine_done_notify = {
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 3a35a2bc0900..5fb20a5f06bb 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -38,6 +38,7 @@ typedef struct TdxGuest {
     char *mrownerconfig;    /* base64 encoded sha348 digest */
 
     TdxFirmware tdvf;
+    MemoryRegion *tdvf_region;
 
     uint32_t nr_ram_entries;
     TdxRamEntry *ram_entries;
@@ -53,6 +54,7 @@ int tdx_kvm_init(MachineState *ms, Error **errp);
 void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
                              uint32_t *ret);
 int tdx_pre_create_vcpu(CPUState *cpu, Error **errp);
+void tdx_set_tdvf_region(MemoryRegion *tdvf_region);
 int tdx_parse_tdvf(void *flash_ptr, int size);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


