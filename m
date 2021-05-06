Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052C4374CF1
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 03:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhEFBmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 21:42:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:9158 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230311AbhEFBmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 21:42:12 -0400
IronPort-SDR: qQG0uzGteNokUgLQGbHSA3Xb6ghRj3a40yprsypEFIRdGFucKSQvL0WIbhm85FWG8YFFFvhYef
 /GrVpryARkaw==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="195230481"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="195230481"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:14 -0700
IronPort-SDR: ODijVWIWkzgja8CNKpLWpZYAZg3ObQCFIyQMQIh65kRS1XKW1o23AcwOk8oNfVSLYrsrlRx73v
 2viTFNtg6E2A==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469220387"
Received: from yy-desk-7060.sh.intel.com ([10.239.159.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:11 -0700
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, dgilbert@redhat.com,
        ehabkost@redhat.com, mst@redhat.com, armbru@redhat.com,
        mtosatti@redhat.com, ashish.kalra@amd.com, Thomas.Lendacky@amd.com,
        brijesh.singh@amd.com, isaku.yamahata@intel.com, yuan.yao@intel.com
Subject: [RFC][PATCH v1 05/10] Set the RAM's MemoryRegion::debug_ops for INTEL TD guests
Date:   Thu,  6 May 2021 09:40:32 +0800
Message-Id: <20210506014037.11982-6-yuan.yao@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210506014037.11982-1-yuan.yao@linux.intel.com>
References: <20210506014037.11982-1-yuan.yao@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yuan Yao <yuan.yao@intel.com>

Now only set the RAM's debug_ops for INTEL TD guests, SEV can also
rely on the common part introduced in previous patch or introduce
new debug_ops implementation if it's necessary.

Signed-off-by: Yuan Yao <yuan.yao@intel.com>

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index d5a4345f44..772b19c524 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -60,6 +60,7 @@
 #include "sysemu/xen.h"
 #include "sysemu/reset.h"
 #include "sysemu/runstate.h"
+#include "sysemu/tdx.h"
 #include "kvm/kvm_i386.h"
 #include "hw/xen/xen.h"
 #include "hw/xen/start_info.h"
@@ -992,6 +993,9 @@ void pc_memory_init(PCMachineState *pcms,
 
     /* Init ACPI memory hotplug IO base address */
     pcms->memhp_io_base = ACPI_MEMORY_HOTPLUG_BASE;
+
+    if (tdx_debug_enabled(machine->cgs))
+        kvm_set_memory_region_debug_ops(NULL, *ram_memory);
 }
 
 /*
diff --git a/include/sysemu/tdx.h b/include/sysemu/tdx.h
index 429bb0ff8e..bd0af77c03 100644
--- a/include/sysemu/tdx.h
+++ b/include/sysemu/tdx.h
@@ -16,4 +16,7 @@ void tdx_post_init_vcpu(CPUState *cpu);
 struct TDXCapability;
 struct TDXCapability *tdx_get_capabilities(void);
 
+struct ConfidentialGuestSupport;
+bool tdx_debug_enabled(ConfidentialGuestSupport *cgs);
+
 #endif
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index c4e5686260..d13d4c8487 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -384,3 +384,18 @@ static void tdx_guest_finalize(Object *obj)
 static void tdx_guest_class_init(ObjectClass *oc, void *data)
 {
 }
+
+bool tdx_debug_enabled(ConfidentialGuestSupport *cgs)
+{
+    TdxGuest *tdx;
+
+    if (!cgs)
+        return false;
+
+    tdx = (TdxGuest *)object_dynamic_cast(OBJECT(cgs),
+                                          TYPE_TDX_GUEST);
+    if (!tdx)
+        return false;
+
+    return tdx->debug;
+}
-- 
2.20.1

