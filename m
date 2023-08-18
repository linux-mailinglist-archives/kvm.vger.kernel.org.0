Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A226C780951
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359586AbjHRJ7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359658AbjHRJ72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:59:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3BB422D
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352752; x=1723888752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mRmkkrsbcYl/h4unuPlDa8xITicU6e+dg3FGKV3epRg=;
  b=JzFmhyKeGsKetRY8lZNug5ePkD1dkmLaJPS5QsYF7VWJJTZugaPTV/j4
   +25RHATQQt2WyLbn/dOP4aCOb3D/M2Qd8EdvxmBXYHIagoUyRIRs+GLJV
   Tf8Rm/NohB//Xo4LORcccLK1nEVU9Hk+B+Hnwk2s48qXrVlO1CymeUmCQ
   +hzfXSM4f30P8fyjKlyLBy0tXWRWNpM4C3Iaei5F8sm4m2fA65g7wGl4l
   qJK0m9kwFT3kh4alDVtJXiAPqT6j8aOh6vi6i2yq7NqQgnOmFIwWGFn3i
   zXiDhou4PsMSwLNthyKAcRwvhfHGPwukyY0Qs2znEhYznO9yuHNWUTow6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966487"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966487"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:57:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235419"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235419"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:57:34 -0700
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
Subject: [PATCH v2 37/58] i386/tdx: register TDVF as private memory
Date:   Fri, 18 Aug 2023 05:50:20 -0400
Message-Id: <20230818095041.1973309-38-xiaoyao.li@intel.com>
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

From: Chao Peng <chao.p.peng@linux.intel.com>

Allocate private gmem memory for BIOS if it's TD VM.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/i386/x86.c         |  9 ++++++++-
 target/i386/kvm/tdx.c | 17 +++++++++++++++++
 target/i386/kvm/tdx.h |  2 ++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index e2a1369e5dfc..a0c9f4d646e2 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1151,8 +1151,15 @@ void x86_bios_rom_init(MachineState *ms, const char *default_firmware,
         (bios_size % 65536) != 0) {
         goto bios_error;
     }
+
     bios = g_malloc(sizeof(*bios));
-    memory_region_init_ram(bios, NULL, "pc.bios", bios_size, &error_fatal);
+    if (is_tdx_vm()) {
+        memory_region_init_ram_gmem(bios, NULL, "pc.bios", bios_size, &error_fatal);
+        tdx_set_tdvf_region(bios);
+    } else {
+        memory_region_init_ram(bios, NULL, "pc.bios", bios_size, &error_fatal);
+    }
+
     if (sev_enabled() || is_tdx_vm()) {
         /*
          * The concept of a "reset" simply doesn't exist for
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 37ff0f4eea11..5b688eb39327 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -456,6 +456,12 @@ static void update_tdx_cpuid_lookup_by_tdx_caps(void)
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
@@ -576,6 +582,7 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
     TdxFirmwareEntry *entry;
+    RAMBlock *ram_block;
     int r;
 
     tdx_init_ram_entries();
@@ -610,6 +617,12 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
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
 
@@ -625,6 +638,10 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
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
index 9b3c427766ef..1c444b6cdb3f 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -38,6 +38,7 @@ typedef struct TdxGuest {
     uint8_t mrownerconfig[48];  /* sha348 digest */
 
     TdxFirmware tdvf;
+    MemoryRegion *tdvf_region;
 
     uint32_t nr_ram_entries;
     TdxRamEntry *ram_entries;
@@ -53,6 +54,7 @@ int tdx_kvm_init(MachineState *ms, Error **errp);
 void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
                              uint32_t *ret);
 int tdx_pre_create_vcpu(CPUState *cpu);
+void tdx_set_tdvf_region(MemoryRegion *tdvf_region);
 int tdx_parse_tdvf(void *flash_ptr, int size);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1

