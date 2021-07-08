Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B391E3BF326
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhGHA7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:59:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:23555 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230304AbhGHA6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="231168458"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="231168458"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:56:00 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770134"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:56:00 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 44/44] i386/tdx: disable S3/S4 unconditionally
Date:   Wed,  7 Jul 2021 17:55:14 -0700
Message-Id: <a3b3965d7ec4c462aa5dc9c7820ca12d5ef5635b.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Disable S3/S4 unconditionally when TDX is enabled.  Because cpu state is
protected, it's not allowed to reset cpu state.  So S3/S4 can't be
supported.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 target/i386/kvm/tdx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 0621317b0a..0dd6d94c2a 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -31,6 +31,9 @@
 #include "sysemu/tdx.h"
 #include "tdx.h"
 
+#include "hw/southbridge/piix.h"
+#include "hw/i386/ich9.h"
+
 #define TDX1_TD_ATTRIBUTE_DEBUG BIT_ULL(0)
 #define TDX1_TD_ATTRIBUTE_PERFMON BIT_ULL(63)
 #define TDX1_MIN_TSC_FREQUENCY_KHZ (100 * 1000)
@@ -103,10 +106,27 @@ static TdxFirmwareEntry *tdx_get_hob_entry(TdxGuest *tdx)
 
 static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
+    Object *pm;
+    bool ambig;
     MachineState *ms = MACHINE(qdev_get_machine());
     TdxGuest *tdx = TDX_GUEST(ms->cgs);
     TdxFirmwareEntry *entry;
 
+    /*
+     * object look up logic is copied from acpi_get_pm_info()
+     * @ hw/ie86/acpi-build.c
+     * This property override needs to be done after machine initialization
+     * as there is no ordering of creation of objects/properties.
+     */
+    pm = object_resolve_path_type("", TYPE_PIIX4_PM, &ambig);
+    if (ambig || !pm) {
+        pm = object_resolve_path_type("", TYPE_ICH9_LPC_DEVICE, &ambig);
+    }
+    if (!ambig && pm) {
+        object_property_set_uint(pm, ACPI_PM_PROP_S3_DISABLED, 1, NULL);
+        object_property_set_uint(pm, ACPI_PM_PROP_S4_DISABLED, 1, NULL);
+    }
+
     tdvf_hob_create(tdx, tdx_get_hob_entry(tdx));
 
     for_each_fw_entry(&tdx->fw, entry) {
-- 
2.25.1

