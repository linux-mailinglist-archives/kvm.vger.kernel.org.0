Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4C84DC82C
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiCQOCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbiCQOCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:02:03 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FF61DF875
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 07:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525646; x=1679061646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mV+vZKgB9wWAZa80ndD8UAUUgRWr1a59i9z1xeznEGc=;
  b=CR+bszwywDmchiU5exdyFnKadvgDw8zVSoH2UOYsSGorHxfRt0DvE3SO
   xlU/jGq9DCskNYwbauOaU9qFV9sc5gKKM2QgrXh1//HssBS2pT7JytvG0
   C2IBjIAcQEAggVpmOGX+w/1DIpQHMxygBvnPEkceR88r+CNE0gdkgryfe
   YSwC+PfIT2V7TfZz9NxdMpH8Go6hKTW8f/B46iIFm8Rjxbs4OAteGrmW5
   C7Yw9oe3yO4BWJQXzKwnFwFG08pUzVGv1GU3VxIyhu9Q+NpLSS+oCbTNQ
   Vrv+zZHbrOnmX1zgWJvIVei98CyXEVZbzdvR560hVIo/lXbyAtn/mbI07
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="257058554"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="257058554"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 07:00:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541378304"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 07:00:29 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        xiaoyao.li@intel.com, erdemaktas@google.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, seanjc@google.com
Subject: [RFC PATCH v3 17/36] pflash_cfi01/tdx: Introduce ram_mode of pflash for TDVF
Date:   Thu, 17 Mar 2022 21:58:54 +0800
Message-Id: <20220317135913.2166202-18-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220317135913.2166202-1-xiaoyao.li@intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX VM needs to boot with Trust Domain Virtual Firmware (TDVF). Unlike
that OVMF is mapped as rom device, TDVF needs to be mapped as private
memory. This is because TDX architecture doesn't provide read-only
capability for VMM, and it doesn't support instruction emulation due
to guest memory and registers are not accessible for VMM.

On the other hand, OVMF can work as TDVF, which is usually configured
as pflash device in QEMU. To keep the same usage (QEMU parameter),
introduce ram_mode to pflash for TDVF. When it's creating a TDX VM,
ram_mode will be enabled automatically that map the firmware as RAM.

Note, this implies two things:
 1. TDVF (OVMF) is not read-only (write-protected).

 2. It doesn't support non-volatile UEFI variables as what pflash
    supports that the change to non-volatile UEFI variables won't get
    synced back to backend vars.fd file.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/block/pflash_cfi01.c | 25 ++++++++++++++++++-------
 hw/i386/pc_sysfw.c      | 14 +++++++++++---
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/hw/block/pflash_cfi01.c b/hw/block/pflash_cfi01.c
index 74c7190302bd..55e8bb2bd5ee 100644
--- a/hw/block/pflash_cfi01.c
+++ b/hw/block/pflash_cfi01.c
@@ -87,6 +87,7 @@ struct PFlashCFI01 {
     void *storage;
     VMChangeStateEntry *vmstate;
     bool old_multiple_chip_handling;
+    bool ram_mode;  /* if 1, the flash is mapped as RAM */
 };
 
 static int pflash_post_load(void *opaque, int version_id);
@@ -818,17 +819,24 @@ static void pflash_cfi01_realize(DeviceState *dev, Error **errp)
 
     total_len = pfl->sector_len * pfl->nb_blocs;
 
-    memory_region_init_rom_device(
-        &pfl->mem, OBJECT(dev),
-        &pflash_cfi01_ops,
-        pfl,
-        pfl->name, total_len, errp);
+    if (pfl->ram_mode) {
+        memory_region_init_ram(&pfl->mem, OBJECT(dev),pfl->name, total_len, errp);
+    } else {
+        memory_region_init_rom_device(
+            &pfl->mem, OBJECT(dev),
+            &pflash_cfi01_ops,
+            pfl,
+            pfl->name, total_len, errp);
+    }
     if (*errp) {
         return;
     }
 
     pfl->storage = memory_region_get_ram_ptr(&pfl->mem);
-    sysbus_init_mmio(SYS_BUS_DEVICE(dev), &pfl->mem);
+
+    if (!pfl->ram_mode) {
+        sysbus_init_mmio(SYS_BUS_DEVICE(dev), &pfl->mem);
+    }
 
     if (pfl->blk) {
         uint64_t perm;
@@ -879,7 +887,9 @@ static void pflash_cfi01_system_reset(DeviceState *dev)
      */
     pfl->cmd = 0x00;
     pfl->wcycle = 0;
-    memory_region_rom_device_set_romd(&pfl->mem, true);
+    if (!pfl->ram_mode) {
+        memory_region_rom_device_set_romd(&pfl->mem, true);
+    }
     /*
      * The WSM ready timer occurs at most 150ns after system reset.
      * This model deliberately ignores this delay.
@@ -924,6 +934,7 @@ static Property pflash_cfi01_properties[] = {
     DEFINE_PROP_STRING("name", PFlashCFI01, name),
     DEFINE_PROP_BOOL("old-multiple-chip-handling", PFlashCFI01,
                      old_multiple_chip_handling, false),
+    DEFINE_PROP_BOOL("ram-mode", PFlashCFI01, ram_mode, false),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index 75b34d02cb4f..03c84b5aaa32 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -38,6 +38,7 @@
 #include "hw/block/flash.h"
 #include "sysemu/kvm.h"
 #include "sev.h"
+#include "kvm/tdx.h"
 
 #define FLASH_SECTOR_SIZE 4096
 
@@ -184,12 +185,19 @@ static void pc_system_flash_map(PCMachineState *pcms,
         total_size += size;
         qdev_prop_set_uint32(DEVICE(system_flash), "num-blocks",
                              size / FLASH_SECTOR_SIZE);
+        qdev_prop_set_bit(DEVICE(system_flash), "ram-mode", is_tdx_vm());
         sysbus_realize_and_unref(SYS_BUS_DEVICE(system_flash), &error_fatal);
-        sysbus_mmio_map(SYS_BUS_DEVICE(system_flash), 0,
-                        0x100000000ULL - total_size);
+        flash_mem = pflash_cfi01_get_memory(system_flash);
+        if (is_tdx_vm()) {
+            memory_region_add_subregion(get_system_memory(),
+                                        0x100000000ULL - total_size,
+                                        flash_mem);
+        } else {
+            sysbus_mmio_map(SYS_BUS_DEVICE(system_flash), 0,
+                            0x100000000ULL - total_size);
+        }
 
         if (i == 0) {
-            flash_mem = pflash_cfi01_get_memory(system_flash);
             pc_isa_bios_init(rom_memory, flash_mem, size);
 
             /* Encrypt the pflash boot ROM */
-- 
2.27.0

