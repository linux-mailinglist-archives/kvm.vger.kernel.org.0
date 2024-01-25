Return-Path: <kvm+bounces-6947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE99283B823
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:33:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EB011F217B6
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A06111A0;
	Thu, 25 Jan 2024 03:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P1EtP6ei"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FB21118F
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153425; cv=none; b=l9cKBxD6KjNeQ3ULineHqX6UlokeDzyUp8jweAeD3tEAUDePbLIfhjJ638rPYPUJ7Fa+tNvyjxgeCdxzhS9qAd09NPcH2LonSKprmkIF6gxQK8sDAdcZOcwHL6NON3CHyWeAj6hFbRG4qmLSYFClkgLRGYe/cmPpSlskE8BxiNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153425; c=relaxed/simple;
	bh=LgNIndXu6+vzsuko5ecgTpiadCm2PJf3afRX7saqriU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dwqzFdS0L08gw6LYO61BsL2u16q4zRJ43f/doLpV31DlDQaKSNRvmCRiFnZAJ4OKPqkzs+71uFsGdwQ8oOpNQz+LA3lQRh9npL4anKeNXm9EBIYCdMHiB7jI6qR7VX5w2Vzpm2l1uE0Ba9YQiNJRX0SKD8PAbXSDd4HL+Vg/my0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P1EtP6ei; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153424; x=1737689424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LgNIndXu6+vzsuko5ecgTpiadCm2PJf3afRX7saqriU=;
  b=P1EtP6eiiCZLhWNVfK5MKQrP5/O/OpRfyr4ySIYaiPWicBysBrMw7ARg
   pznZ3Gm7XmfCUqzjp1PFeZvk+kaGePDvZDckvtIJfx981M2Jg9003JxAC
   AT76JyCCM0e8S21ocOecliZnZFPtajZiW4hoXujCvv3Ea3gp7/UdHydus
   Oj6vb8Mlr8vm3PTPvvtS489W2ootxoSjbKI18uINIeadZ1h/d/qjcd8lA
   WPthVqfZGMxKEN24ZsOCiiWIU+ToMz0nztRNv48hzRvGfPDegV5l+TUEF
   CIaO78q9YX+yIaYH9ArCfaCGaHpPZ3h4EetLhFIIPh4DjJd2D7inW3Y/U
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9429803"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9429803"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:27:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2086086"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:27:44 -0800
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
Subject: [PATCH v4 46/66] i386/tdx: register TDVF as private memory
Date: Wed, 24 Jan 2024 22:23:08 -0500
Message-Id: <20240125032328.2522472-47-xiaoyao.li@intel.com>
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
index f7352b06c3e6..f13f49069d40 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1155,8 +1155,16 @@ void x86_bios_rom_init(MachineState *ms, const char *default_firmware,
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
index af4107514fc9..0f6a6e9bb024 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -21,6 +21,7 @@
 #include "sysemu/kvm.h"
 #include "sysemu/sysemu.h"
 #include "exec/address-spaces.h"
+#include "exec/ramblock.h"
 
 #include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/x86.h"
@@ -468,6 +469,12 @@ static void update_tdx_cpuid_lookup_by_tdx_caps(void)
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
@@ -589,6 +596,7 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
     TdxFirmwareEntry *entry;
+    RAMBlock *ram_block;
     int r;
 
     tdx_init_ram_entries();
@@ -623,6 +631,12 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
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
 
@@ -638,6 +652,10 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
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


