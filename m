Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3353BF314
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhGHA6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:57295 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhGHA6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209239173"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209239173"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:56 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770059"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:56 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 22/44] i386/tdx: Add TDVF memory via INIT_MEM_REGION
Date:   Wed,  7 Jul 2021 17:54:52 -0700
Message-Id: <8abb2018fbaafaa12f9d4b9f225ec7de481f39db.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add, and optionally measure, TDVF memory via KVM_TDX_INIT_MEM_REGION as
part of finalizing the TD.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 target/i386/kvm/tdx.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 12b2e02fa2..0cd649dd01 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -85,10 +85,26 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
     TdxGuest *tdx = TDX_GUEST(ms->cgs);
+    TdxFirmwareEntry *entry;
 
     tdvf_hob_create(tdx, tdx_get_hob_entry(tdx));
 
+    for_each_fw_entry(&tdx->fw, entry) {
+        struct kvm_tdx_init_mem_region mem_region = {
+            .source_addr = (__u64)entry->mem_ptr,
+            .gpa = entry->address,
+            .nr_pages = entry->size / 4096,
+        };
+
+        __u32 metadata = entry->attributes & TDVF_SECTION_ATTRIBUTES_EXTENDMR ?
+                         KVM_TDX_MEASURE_MEMORY_REGION : 0;
+
+        tdx_ioctl(KVM_TDX_INIT_MEM_REGION, metadata, &mem_region);
+    }
+
     tdx_ioctl(KVM_TDX_FINALIZE_VM, 0, NULL);
+
+    tdx->parent_obj.ready = true;
 }
 
 static Notifier tdx_machine_done_late_notify = {
@@ -301,7 +317,6 @@ static void tdx_guest_init(Object *obj)
 {
     TdxGuest *tdx = TDX_GUEST(obj);
 
-    tdx->parent_obj.ready = true;
     qemu_mutex_init(&tdx->lock);
 
     tdx->debug = false;
-- 
2.25.1

