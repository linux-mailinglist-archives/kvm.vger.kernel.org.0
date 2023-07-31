Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAC3769C69
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbjGaQ1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbjGaQ06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:26:58 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FDE1BEC
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820790; x=1722356790;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QoBc+IVWDb42m9hfWIVmJcD1aYMSQ1vw/jwLkspqX3E=;
  b=akBZCY0RoYLaQ+AlZ+IDLjFbwnX2FyGxyi5HGiJOboNHjcCUQ0c0dgTK
   q2YTqW7fAO2K81NlRoc6itm0Ya7Ox1OaO6ZQiBqCAIFODXbo7QufCw35o
   8HykL6lKgN49uhN3YtyW8OjPfkkhxGgfJB7FuY/iCGC2yTiNV+4C5S1ZF
   2o9djQQxsZk1Q9KhjhZQf2SfG07/l/5sogNsfnsRoeO7NdiSZlqL1AHdQ
   j59cPb8kbqTRotjehJf1kCs/wFWlfppgi0srz3lEqP/ZvrGCxEN8t8ZiG
   K5vYdHZ07UBLZg6xU/e1LEF18OEO2FxySAktkTAA64beubIk6pEK70pOQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993639"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993639"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:26:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984449"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984449"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:26:11 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        xiaoyao.li@intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC PATCH 18/19] q35: Introduce smm_ranges property for q35-pci-host
Date:   Mon, 31 Jul 2023 12:22:00 -0400
Message-Id: <20230731162201.271114-19-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230731162201.271114-1-xiaoyao.li@intel.com>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@linux.intel.com>

Add a q35 property to check whether or not SMM ranges, e.g. SMRAM, TSEG,
etc... exist for the target platform.  TDX doesn't support SMM and doesn't
play nice with QEMU modifying related guest memory ranges.

Signed-off-by: Isaku Yamahata <isaku.yamahata@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/i386/pc_q35.c          |  3 ++-
 hw/pci-host/q35.c         | 42 +++++++++++++++++++++++++++------------
 include/hw/i386/pc.h      |  1 +
 include/hw/pci-host/q35.h |  1 +
 4 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index dc27a9e223a2..73eb3bc5e826 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -232,8 +232,9 @@ static void pc_q35_init(MachineState *machine)
                             x86ms->above_4g_mem_size, NULL);
     object_property_set_bool(phb, PCI_HOST_BYPASS_IOMMU,
                              pcms->default_bus_bypass_iommu, NULL);
+    object_property_set_bool(phb, PCI_HOST_PROP_SMM_RANGES,
+                             x86_machine_is_smm_enabled(x86ms), NULL);
     sysbus_realize_and_unref(SYS_BUS_DEVICE(phb), &error_fatal);
-
     /* pci */
     host_bus = PCI_BUS(qdev_get_child_bus(DEVICE(phb), "pcie.0"));
     pcms->bus = host_bus;
diff --git a/hw/pci-host/q35.c b/hw/pci-host/q35.c
index ac1518a94ee4..f5c01f7080f9 100644
--- a/hw/pci-host/q35.c
+++ b/hw/pci-host/q35.c
@@ -186,6 +186,8 @@ static Property q35_host_props[] = {
                      mch.below_4g_mem_size, 0),
     DEFINE_PROP_SIZE(PCI_HOST_ABOVE_4G_MEM_SIZE, Q35PCIHost,
                      mch.above_4g_mem_size, 0),
+    DEFINE_PROP_BOOL(PCI_HOST_PROP_SMM_RANGES, Q35PCIHost,
+                     mch.has_smm_ranges, true),
     DEFINE_PROP_BOOL("x-pci-hole64-fix", Q35PCIHost, pci_hole64_fix, true),
     DEFINE_PROP_END_OF_LIST(),
 };
@@ -221,6 +223,7 @@ static void q35_host_initfn(Object *obj)
     /* mch's object_initialize resets the default value, set it again */
     qdev_prop_set_uint64(DEVICE(s), PCI_HOST_PROP_PCI_HOLE64_SIZE,
                          Q35_PCI_HOST_HOLE64_SIZE_DEFAULT);
+
     object_property_add(obj, PCI_HOST_PROP_PCI_HOLE_START, "uint32",
                         q35_host_get_pci_hole_start,
                         NULL, NULL, NULL);
@@ -483,6 +486,10 @@ static void mch_write_config(PCIDevice *d,
         mch_update_pciexbar(mch);
     }
 
+    if (!mch->has_smm_ranges) {
+        return;
+    }
+
     if (ranges_overlap(address, len, MCH_HOST_BRIDGE_SMRAM,
                        MCH_HOST_BRIDGE_SMRAM_SIZE)) {
         mch_update_smram(mch);
@@ -501,10 +508,13 @@ static void mch_write_config(PCIDevice *d,
 static void mch_update(MCHPCIState *mch)
 {
     mch_update_pciexbar(mch);
+
     mch_update_pam(mch);
-    mch_update_smram(mch);
-    mch_update_ext_tseg_mbytes(mch);
-    mch_update_smbase_smram(mch);
+    if (mch->has_smm_ranges) {
+        mch_update_smram(mch);
+        mch_update_ext_tseg_mbytes(mch);
+        mch_update_smbase_smram(mch);
+    }
 
     /*
      * pci hole goes from end-of-low-ram to io-apic.
@@ -545,19 +555,21 @@ static void mch_reset(DeviceState *qdev)
     pci_set_quad(d->config + MCH_HOST_BRIDGE_PCIEXBAR,
                  MCH_HOST_BRIDGE_PCIEXBAR_DEFAULT);
 
-    d->config[MCH_HOST_BRIDGE_SMRAM] = MCH_HOST_BRIDGE_SMRAM_DEFAULT;
-    d->config[MCH_HOST_BRIDGE_ESMRAMC] = MCH_HOST_BRIDGE_ESMRAMC_DEFAULT;
-    d->wmask[MCH_HOST_BRIDGE_SMRAM] = MCH_HOST_BRIDGE_SMRAM_WMASK;
-    d->wmask[MCH_HOST_BRIDGE_ESMRAMC] = MCH_HOST_BRIDGE_ESMRAMC_WMASK;
+    if (mch->has_smm_ranges) {
+        d->config[MCH_HOST_BRIDGE_SMRAM] = MCH_HOST_BRIDGE_SMRAM_DEFAULT;
+        d->config[MCH_HOST_BRIDGE_ESMRAMC] = MCH_HOST_BRIDGE_ESMRAMC_DEFAULT;
+        d->wmask[MCH_HOST_BRIDGE_SMRAM] = MCH_HOST_BRIDGE_SMRAM_WMASK;
+        d->wmask[MCH_HOST_BRIDGE_ESMRAMC] = MCH_HOST_BRIDGE_ESMRAMC_WMASK;
 
-    if (mch->ext_tseg_mbytes > 0) {
-        pci_set_word(d->config + MCH_HOST_BRIDGE_EXT_TSEG_MBYTES,
-                     MCH_HOST_BRIDGE_EXT_TSEG_MBYTES_QUERY);
+        if (mch->ext_tseg_mbytes > 0) {
+            pci_set_word(d->config + MCH_HOST_BRIDGE_EXT_TSEG_MBYTES,
+                        MCH_HOST_BRIDGE_EXT_TSEG_MBYTES_QUERY);
+        }
+
+        d->config[MCH_HOST_BRIDGE_F_SMBASE] = 0;
+        d->wmask[MCH_HOST_BRIDGE_F_SMBASE] = 0xff;
     }
 
-    d->config[MCH_HOST_BRIDGE_F_SMBASE] = 0;
-    d->wmask[MCH_HOST_BRIDGE_F_SMBASE] = 0xff;
-
     mch_update(mch);
 }
 
@@ -585,6 +597,10 @@ static void mch_realize(PCIDevice *d, Error **errp)
                  PAM_EXPAN_BASE + i * PAM_EXPAN_SIZE, PAM_EXPAN_SIZE);
     }
 
+    if (!mch->has_smm_ranges) {
+        return;
+    }
+
     /* if *disabled* show SMRAM to all CPUs */
     memory_region_init_alias(&mch->smram_region, OBJECT(mch), "smram-region",
                              mch->pci_address_space, MCH_HOST_BRIDGE_SMRAM_C_BASE,
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index c98d628a76f3..3c9ced22cea9 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -156,6 +156,7 @@ void pc_guest_info_init(PCMachineState *pcms);
 #define PCI_HOST_PROP_PCI_HOLE64_SIZE  "pci-hole64-size"
 #define PCI_HOST_BELOW_4G_MEM_SIZE     "below-4g-mem-size"
 #define PCI_HOST_ABOVE_4G_MEM_SIZE     "above-4g-mem-size"
+#define PCI_HOST_PROP_SMM_RANGES       "smm-ranges"
 
 
 void pc_pci_as_mapping_init(MemoryRegion *system_memory,
diff --git a/include/hw/pci-host/q35.h b/include/hw/pci-host/q35.h
index 1d98bbfe0dd2..930af3870e8a 100644
--- a/include/hw/pci-host/q35.h
+++ b/include/hw/pci-host/q35.h
@@ -50,6 +50,7 @@ struct MCHPCIState {
     MemoryRegion tseg_blackhole, tseg_window;
     MemoryRegion smbase_blackhole, smbase_window;
     bool has_smram_at_smbase;
+    bool has_smm_ranges;
     Range pci_hole;
     uint64_t below_4g_mem_size;
     uint64_t above_4g_mem_size;
-- 
2.34.1

