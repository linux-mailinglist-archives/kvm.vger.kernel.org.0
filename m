Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3984DC82E
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbiCQOCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbiCQOCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:02:12 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BE51E3197
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 07:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525653; x=1679061653;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A+2XP4jbSe3PB7Mapyen8YX1FnexO4Fy/hlr8NnZ0hc=;
  b=P3OpSrcMr8Gtc+4Ib5ZdFkzZ8cKyws91S9gs8gUlZkb+lfG8R8y9un6i
   m/I69D0bEWAXFraHEuSULucJBh0EGnYulhYx2zkzbE3JCM/DG4AUFEd3p
   DAWC8e8t2z/whuBHYTehWrvrB7Z+OhR6az0WMuPdv2iePDWc3sGdb9PLu
   mVeH5FRyia7wehn8wIztlPPlpY+ozYJU0AQXyZP58q6ABxuNyBQ46LyP0
   HgTo6iO4onXvm+qUCWGxrbmr8U9yVhTbvuaTfDZ9iLAG6XSSN5hdTDT3i
   bnLPk3jAvzP/0AGSmGuI5oW7k73mjO64cXnb+m0n/qFdHuvDnQMy8+JRK
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="257058631"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="257058631"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 07:00:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541378400"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 07:00:39 -0700
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
Subject: [RFC PATCH v3 19/36] i386/tdx: Parse TDVF metadata for TDX VM
Date:   Thu, 17 Mar 2022 21:58:56 +0800
Message-Id: <20220317135913.2166202-20-xiaoyao.li@intel.com>
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

When boot a TDX VM, parse firmware as TDVF. Only enable this on the case
that firmware is provided as flash, since it's the correct interface to
specify firmware for uefi guest.

- When unified firmware is provided, there is only one pflsh, pflash[0];

- When split images (CODE.fd and VARs.fd) are provided, metadata is
  located in CODE.fd, which means pflash[0].

So parse TDVF on plash[0].

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/i386/pc_sysfw.c         | 21 ++++++++++++++-------
 target/i386/kvm/tdx-stub.c |  5 +++++
 target/i386/kvm/tdx.c      |  4 ++++
 target/i386/kvm/tdx.h      |  4 ++++
 4 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index 03c84b5aaa32..bdec29fd9519 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -200,15 +200,16 @@ static void pc_system_flash_map(PCMachineState *pcms,
         if (i == 0) {
             pc_isa_bios_init(rom_memory, flash_mem, size);
 
+            flash_ptr = memory_region_get_ram_ptr(flash_mem);
+            flash_size = memory_region_size(flash_mem);
+            /*
+             * OVMF places a GUIDed structures in the flash, so
+             * search for them
+             */
+            pc_system_parse_ovmf_flash(flash_ptr, flash_size);
+
             /* Encrypt the pflash boot ROM */
             if (sev_enabled()) {
-                flash_ptr = memory_region_get_ram_ptr(flash_mem);
-                flash_size = memory_region_size(flash_mem);
-                /*
-                 * OVMF places a GUIDed structures in the flash, so
-                 * search for them
-                 */
-                pc_system_parse_ovmf_flash(flash_ptr, flash_size);
 
                 ret = sev_es_save_reset_vector(flash_ptr, flash_size);
                 if (ret) {
@@ -217,6 +218,12 @@ static void pc_system_flash_map(PCMachineState *pcms,
                 }
 
                 sev_encrypt_flash(flash_ptr, flash_size, &error_fatal);
+            } else if (is_tdx_vm()) {
+                ret = tdx_parse_tdvf(flash_ptr, flash_size);
+                if (ret) {
+                    error_report("failed to parse TDVF in pflash for TDX VM");
+                    exit(1);
+                }
             }
         }
     }
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
index 2871de9d7b56..395a59721266 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -12,3 +12,8 @@ int tdx_pre_create_vcpu(CPUState *cpu)
 {
     return -EINVAL;
 }
+
+int tdx_parse_tdvf(void *flash_ptr, int size)
+{
+    return -EINVAL;
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 1bb8211e74e6..7f34b14dc504 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -260,6 +260,10 @@ out:
     qemu_mutex_unlock(&tdx_guest->lock);
     return r;
 }
+int tdx_parse_tdvf(void *flash_ptr, int size)
+{
+    return tdvf_parse_metadata(&tdx_guest->tdvf, flash_ptr, size);
+}
 
 static bool tdx_guest_get_sept_ve_disable(Object *obj, Error **errp)
 {
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 46a24ee8c7cc..12bcf25bb95b 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -6,6 +6,7 @@
 #endif
 
 #include "exec/confidential-guest-support.h"
+#include "hw/i386/tdvf.h"
 
 #define TYPE_TDX_GUEST "tdx-guest"
 #define TDX_GUEST(obj)  OBJECT_CHECK(TdxGuest, (obj), TYPE_TDX_GUEST)
@@ -21,6 +22,8 @@ typedef struct TdxGuest {
 
     bool initialized;
     uint64_t attributes;    /* TD attributes */
+
+    TdxFirmware tdvf;
 } TdxGuest;
 
 #ifdef CONFIG_TDX
@@ -33,5 +36,6 @@ int tdx_kvm_init(MachineState *ms, Error **errp);
 void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
                              uint32_t *ret);
 int tdx_pre_create_vcpu(CPUState *cpu);
+int tdx_parse_tdvf(void *flash_ptr, int size);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.27.0

