Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2094231C557
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhBPCQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:16:46 -0500
Received: from mga03.intel.com ([134.134.136.65]:30899 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhBPCQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:16:04 -0500
IronPort-SDR: qHKWslVBwrpSCa+6WovEhuSbeg/LjeZrSqOCyfvTcdCSyB8PeDVmefm1mgVsG9IOLNtFb5VoqH
 keQBbPnU7XSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="182865761"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="182865761"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:53 -0800
IronPort-SDR: EWfpFLeWP33SB+MsXpK3VvYQ5ivgrXW4hOPO7hw/pMaqdefliQA9zagfa45zwJDwYRrh6aCb0t
 QLU1aXgpJKDg==
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="591705447"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:53 -0800
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 20/23] i386/tdx: Add TDVF memory via INIT_MEM_REGION
Date:   Mon, 15 Feb 2021 18:13:16 -0800
Message-Id: <e6a374b5ac3f08fbd4227080d607f8b17640cac8.1613188118.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add, and optionally measure, TDVF memory via KVM_TDX_INIT_MEM_REGION as
part of finalizing the TD.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 target/i386/kvm/tdx.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 8e4bf98735..49b4355849 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -83,10 +83,26 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
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
@@ -288,9 +304,6 @@ static void tdx_guest_init(Object *obj)
     tdx->debug = false;
     object_property_add_bool(obj, "debug", tdx_guest_get_debug,
                              tdx_guest_set_debug);
-
-    /* TODO: move this after fully TD initialized */
-    tdx->parent_obj.ready = true;
 }
 
 static void tdx_guest_finalize(Object *obj)
-- 
2.17.1

