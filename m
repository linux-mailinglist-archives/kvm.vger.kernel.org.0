Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D2E4DC830
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbiCQOCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbiCQOCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:02:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1D81E3E06
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 07:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525659; x=1679061659;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f/HYjrrPVIDfEjInD9F41PJhlI76P5ZOBWNuyMbg1eI=;
  b=YV9RZVCIZxUrFKhYe0FhiiK9Mtbuxg1cT+ybkkJS2Js/9qP3hD51xXVR
   uuvE+ecGAxD8AuywPVXiLoRQqRaeceb2QOfX+DopZ8t+/0u7/tygwXf9C
   CKQq4pZSwOyioso2mpU1UWi4MJykru3CcMMmCPWZg/zSgxwfwwlEdSGSo
   8PAMSTC5LRPn/7XLtDCDm0KivEkdisEG62Y2UPrJUqQkatIuYqCiUi0a5
   X6d0UszU4FBxJ1YCOa2Vxy0qLEYMiOlzstgn3W/+wbuZtgsTqwcLSjCbd
   FXu/KyEQjF5fiu52D/WOeO0zhd+yvW8fWCajv6wfLNB9DpA03Jm+d1e2K
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="257058734"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="257058734"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 07:00:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541378457"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 07:00:48 -0700
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
Subject: [RFC PATCH v3 21/36] i386/tdx: Track mem_ptr for each firmware entry of TDVF
Date:   Thu, 17 Mar 2022 21:58:58 +0800
Message-Id: <20220317135913.2166202-22-xiaoyao.li@intel.com>
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

For every TDVF sections, QEMU needs to copy its content to guest
private memory via KVM API, to initialize them.

So add a field @mem_ptr to track the pointer of each TDVF sections.

BFV and CFV are firmware and loaded as plfash.

TEMP_MEM and TD_HOB always locate at guest RAM before 4G, specifically
starting from 0x80 0000 (8M)

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/hw/i386/tdvf.h |  5 +++++
 target/i386/kvm/tdx.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/hw/i386/tdvf.h b/include/hw/i386/tdvf.h
index 773bd39a3bff..ce28b7ec4543 100644
--- a/include/hw/i386/tdvf.h
+++ b/include/hw/i386/tdvf.h
@@ -39,6 +39,8 @@ typedef struct TdxFirmwareEntry {
     uint64_t size;
     uint32_t type;
     uint32_t attributes;
+
+    void *mem_ptr;
 } TdxFirmwareEntry;
 
 typedef struct TdxFirmware {
@@ -50,6 +52,9 @@ typedef struct TdxFirmware {
     TdxFirmwareEntry *entries;
 } TdxFirmware;
 
+#define for_each_tdx_fw_entry(fw, e)    \
+    for (e = (fw)->entries; e != (fw)->entries + (fw)->nr_entries; e++)
+
 int tdvf_parse_metadata(TdxFirmware *fw, void *flash_ptr, int size);
 
 #endif /* HW_I386_TDVF_H */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index cd88b6dfc280..fe8554dcebb0 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -16,8 +16,10 @@
 #include "qom/object_interfaces.h"
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/kvm.h"
+#include "sysemu/sysemu.h"
 
 #include "hw/i386/x86.h"
+#include "hw/i386/tdvf.h"
 #include "kvm_i386.h"
 #include "tdx.h"
 
@@ -103,6 +105,44 @@ static void get_tdx_capabilities(void)
     tdx_caps = caps;
 }
 
+static void tdx_finalize_vm(Notifier *notifier, void *unused)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+    void *base_ram_ptr = memory_region_get_ram_ptr(ms->ram);
+    TdxFirmware *tdvf = &tdx_guest->tdvf;
+    TdxFirmwareEntry *entry;
+
+    for_each_tdx_fw_entry(tdvf, entry) {
+        switch (entry->type) {
+        case TDVF_SECTION_TYPE_BFV:
+            if (tdvf->split_tdvf) {
+                entry->mem_ptr = tdvf->code_ptr;
+            } else {
+                entry->mem_ptr = tdvf->code_ptr + entry->data_offset;
+            }
+            break;
+        case TDVF_SECTION_TYPE_CFV:
+            if (tdvf->split_tdvf) {
+                entry->mem_ptr = tdvf->vars_ptr;
+            } else {
+                entry->mem_ptr = tdvf->code_ptr;
+            }
+            break;
+        case TDVF_SECTION_TYPE_TD_HOB:
+        case TDVF_SECTION_TYPE_TEMP_MEM:
+            entry->mem_ptr = base_ram_ptr + entry->address;
+            break;
+        default:
+            error_report("Unsupported TDVF section %d", entry->type);
+            exit(1);
+        }
+    }
+}
+
+static Notifier tdx_machine_done_notify = {
+    .notify = tdx_finalize_vm,
+};
+
 int tdx_kvm_init(MachineState *ms, Error **errp)
 {
     TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
@@ -124,6 +164,8 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
      */
     kvm_readonly_mem_allowed = false;
 
+    qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
+
     tdx_guest = tdx;
 
     return 0;
-- 
2.27.0

