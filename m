Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE733BF309
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhGHA6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:19320 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230194AbhGHA6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196696075"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196696075"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770037"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:55 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 15/44] i386/tdx: Add hook to require generic device loader
Date:   Wed,  7 Jul 2021 17:54:45 -0700
Message-Id: <c16cb881efabc16a94ff7c02cd8c7abe24411e3f.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a hook for TDX to denote that the TD Virtual Firmware must be
provided via the "generic" device loader.  Error out if pflash is used
in conjuction with TDX.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 hw/i386/pc_sysfw.c         |  6 ++++++
 include/sysemu/tdx.h       |  2 ++
 target/i386/kvm/tdx-stub.c |  5 +++++
 target/i386/kvm/tdx.c      | 25 +++++++++++++++++++++++++
 4 files changed, 38 insertions(+)

diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index 6ce37a2b05..5ff571af36 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -38,6 +38,7 @@
 #include "hw/block/flash.h"
 #include "sysemu/kvm.h"
 #include "sysemu/sev.h"
+#include "sysemu/tdx.h"
 
 #define FLASH_SECTOR_SIZE 4096
 
@@ -328,6 +329,11 @@ void pc_system_firmware_init(PCMachineState *pcms,
     int i;
     BlockBackend *pflash_blk[ARRAY_SIZE(pcms->flash)];
 
+    if (!tdx_system_firmware_init(pcms, rom_memory)) {
+        pc_system_flash_cleanup_unused(pcms);
+        return;
+    }
+
     if (!pcmc->pci_enabled) {
         x86_bios_rom_init(MACHINE(pcms), "bios.bin", rom_memory, true);
         return;
diff --git a/include/sysemu/tdx.h b/include/sysemu/tdx.h
index 03461b6ae8..70eb01348f 100644
--- a/include/sysemu/tdx.h
+++ b/include/sysemu/tdx.h
@@ -3,8 +3,10 @@
 
 #ifndef CONFIG_USER_ONLY
 #include "sysemu/kvm.h"
+#include "hw/i386/pc.h"
 
 bool kvm_has_tdx(KVMState *s);
+int tdx_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_memory);
 #endif
 
 void tdx_pre_create_vcpu(CPUState *cpu);
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
index 93afe07ddb..4e1a0a4280 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -7,6 +7,11 @@ bool kvm_has_tdx(KVMState *s)
 {
         return false;
 }
+
+int tdx_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_memory)
+{
+    return -ENOSYS;
+}
 #endif
 
 void tdx_pre_create_vcpu(CPUState *cpu)
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 67fb03b4b5..48c04d344d 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -109,6 +109,31 @@ int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     return 0;
 }
 
+int tdx_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_memory)
+{
+    MachineState *ms = MACHINE(pcms);
+    TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
+                                                    TYPE_TDX_GUEST);
+    int i;
+
+    if (!tdx) {
+        return -ENOSYS;
+    }
+
+    /*
+     * Sanitiy check for tdx:
+     * TDX uses generic loader to load bios instead of pflash.
+     */
+    for (i = 0; i < ARRAY_SIZE(pcms->flash); i++) {
+        if (drive_get(IF_PFLASH, 0, i)) {
+            error_report("pflash not supported by VM type, "
+                         "use -device loader,file=<path>");
+            exit(1);
+        }
+    }
+    return 0;
+}
+
 void tdx_get_supported_cpuid(KVMState *s, uint32_t function,
                              uint32_t index, int reg, uint32_t *ret)
 {
-- 
2.25.1

