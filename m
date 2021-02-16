Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DF431C56D
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhBPCTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:19:41 -0500
Received: from mga06.intel.com ([134.134.136.31]:39373 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229977AbhBPCRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:17:00 -0500
IronPort-SDR: 5dPLPtRBfs6IVkKKLQggkcqJ0YQVAuXwWYCZUradwIG87XpfKm1eXaV+pGD5Yjuvh4HJAl05VZ
 r4wmTVj83mXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="244270209"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="244270209"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:52 -0800
IronPort-SDR: bTa1V5nNWnVHlu6obW20lt5sVgr0Pj1YcFNm5PpOHi1oRbxr5dqA8HeXEGI8aoHUWBMRFVGeCN
 gy31Vn4/T52w==
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="591705429"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:52 -0800
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 15/23] i386/tdx: Add hook to require generic device loader
Date:   Mon, 15 Feb 2021 18:13:11 -0800
Message-Id: <2ea61dad121c2ec89597b3b6dbfe538be22ac2cc.1613188118.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a hook for TDX to denote that the TD Virtual Firmware must be
provided via the "generic" device loader.  Error out if pflash is used
in conjuction with TDX.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 hw/i386/pc_sysfw.c         |  6 ++++++
 include/sysemu/tdx.h       |  2 ++
 target/i386/kvm/tdx-stub.c |  5 +++++
 target/i386/kvm/tdx.c      | 25 +++++++++++++++++++++++++
 4 files changed, 38 insertions(+)

diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index 11172214f1..65eed485ff 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -39,6 +39,7 @@
 #include "hw/block/flash.h"
 #include "sysemu/kvm.h"
 #include "sysemu/sev.h"
+#include "sysemu/tdx.h"
 
 #define FLASH_SECTOR_SIZE 4096
 
@@ -207,6 +208,11 @@ void pc_system_firmware_init(PCMachineState *pcms,
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
index d095dab662..e8cd2a7672 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -106,6 +106,31 @@ int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
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
2.17.1

