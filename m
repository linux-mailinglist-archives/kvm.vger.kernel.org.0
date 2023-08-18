Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA98780940
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359548AbjHRJ7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359604AbjHRJ7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:59:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298394490
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352718; x=1723888718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nO6z1ULObqgAHxUrZ8B6shzvhjbXrBrYzI5h0blbgjM=;
  b=BaXw9wzI+Tu5OtyZKX67/XSZ/s3wsLA0cn3vPBM9Sfw+3Ys90659PeNH
   FeRuw34FGms54+XCMbruUVs1JZepmKSfishHUCAg2j6wipcBx6wdMyiHw
   vZ+7aaPPbPJd0hqH6HMEf1vYWVcortjV0e46bnlPC2AA3SkbOmT4YgHfi
   m++8RlBYhY32kMfr39f/qfd3ln4OaXHtmMHhfmuIeusHfAj9c/ykWgIg/
   9qxQ/Z5JsW5piMwRoPUzy/xjt1vCL3IUrG0cQKWEGKvjiYSyUqfTL3W6i
   mUG/m6sl0LVMt2Fm7xQ4Hzld//y9FruLT3WwbUvlPexC+rGGqPfS6Y2Dk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966228"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966228"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:56:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235247"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235247"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:56:48 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>, xiaoyao.li@intel.com,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v2 28/58] i386/tdx: Parse TDVF metadata for TDX VM
Date:   Fri, 18 Aug 2023 05:50:11 -0400
Message-Id: <20230818095041.1973309-29-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230818095041.1973309-1-xiaoyao.li@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX cannot support pflash device since it doesn't support read-only
memslot and doesn't support emulation. Load TDVF(OVMF) with -bios option
for TDs.

When boot a TD, besides load TDVF to the address below 4G, it needs
parse TDVF metadata.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 hw/i386/pc_sysfw.c         | 7 +++++++
 hw/i386/x86.c              | 3 ++-
 target/i386/kvm/tdx-stub.c | 5 +++++
 target/i386/kvm/tdx.c      | 5 +++++
 target/i386/kvm/tdx.h      | 4 ++++
 5 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index c8d9e71b889b..cf63434ba89d 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -37,6 +37,7 @@
 #include "hw/block/flash.h"
 #include "sysemu/kvm.h"
 #include "sev.h"
+#include "kvm/tdx.h"
 
 #define FLASH_SECTOR_SIZE 4096
 
@@ -265,5 +266,11 @@ void x86_firmware_configure(void *ptr, int size)
         }
 
         sev_encrypt_flash(ptr, size, &error_fatal);
+    } else if (is_tdx_vm()) {
+        ret = tdx_parse_tdvf(ptr, size);
+        if (ret) {
+            error_report("failed to parse TDVF for TDX VM");
+            exit(1);
+        }
     }
 }
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 3ccd06154249..dabd33cb830b 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -47,6 +47,7 @@
 #include "hw/intc/i8259.h"
 #include "hw/rtc/mc146818rtc.h"
 #include "target/i386/sev.h"
+#include "kvm/tdx.h"
 
 #include "hw/acpi/cpu_hotplug.h"
 #include "hw/irq.h"
@@ -1152,7 +1153,7 @@ void x86_bios_rom_init(MachineState *ms, const char *default_firmware,
     }
     bios = g_malloc(sizeof(*bios));
     memory_region_init_ram(bios, NULL, "pc.bios", bios_size, &error_fatal);
-    if (sev_enabled()) {
+    if (sev_enabled() || is_tdx_vm()) {
         /*
          * The concept of a "reset" simply doesn't exist for
          * confidential computing guests, we have to destroy and
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
index 61f70cc0d1d9..3cd114476d78 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -11,3 +11,8 @@ int tdx_pre_create_vcpu(CPUState *cpu)
 {
     return -EINVAL;
 }
+
+int tdx_parse_tdvf(void *flash_ptr, int size)
+{
+    return -EINVAL;
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index f1305191e939..e41ea18c04db 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -580,6 +580,11 @@ out:
     return r;
 }
 
+int tdx_parse_tdvf(void *flash_ptr, int size)
+{
+    return tdvf_parse_metadata(&tdx_guest->tdvf, flash_ptr, size);
+}
+
 static void tdx_guest_region_add(MemoryListener *listener,
                                  MemoryRegionSection *section)
 {
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 68f8327f2231..e9d2888162ce 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -6,6 +6,7 @@
 #endif
 
 #include "exec/confidential-guest-support.h"
+#include "hw/i386/tdvf.h"
 
 #define TYPE_TDX_GUEST "tdx-guest"
 #define TDX_GUEST(obj)  OBJECT_CHECK(TdxGuest, (obj), TYPE_TDX_GUEST)
@@ -24,6 +25,8 @@ typedef struct TdxGuest {
     uint8_t mrconfigid[48];     /* sha348 digest */
     uint8_t mrowner[48];        /* sha348 digest */
     uint8_t mrownerconfig[48];  /* sha348 digest */
+
+    TdxFirmware tdvf;
 } TdxGuest;
 
 #ifdef CONFIG_TDX
@@ -36,5 +39,6 @@ int tdx_kvm_init(MachineState *ms, Error **errp);
 void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
                              uint32_t *ret);
 int tdx_pre_create_vcpu(CPUState *cpu);
+int tdx_parse_tdvf(void *flash_ptr, int size);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1

