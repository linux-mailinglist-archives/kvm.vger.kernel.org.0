Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16474D42F5
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 09:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbiCJJAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 04:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239986AbiCJJAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 04:00:22 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC03F8BA3
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 00:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646902761; x=1678438761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=YQ4QSPDPDFW9bScDCHDZIGKz3XUzqzpZVqrdZLdzL94=;
  b=SPzN58BNw2o3WtexnQQzG1MyPUn3rAM/QWi7nuvD3WH0yLy5k6c3urC1
   elfIC92KCG5EX3o1SDVEcj1kXdbZANAn/F7RKN/zwpq1Itiss0d3P7lb8
   CvSEhZYNKW0xHh27UJWejFi0pA/C4NXcCRErjyZbNPC+Wbts+k/7mDhOl
   2I4LWywBTe71LIwWpo/GZgit9+1BuVlTInDdqgv0YzDFBnQlA5SUDIJh4
   rVIlWiCtPHvUBWTATKyhfTYeySGsNGccHOcCp5QP43NEoozlKcDsJxX/s
   mew3VS/MRHfh4ihNxa3w/5tS2TmbSNwGFoRb6CnrUQEZQ4LC3js4zljEq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="235148776"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="235148776"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 00:59:13 -0800
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="644367228"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 00:59:11 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 2/2] i386: Add notify VM exit support
Date:   Thu, 10 Mar 2022 17:02:05 +0800
Message-Id: <20220310090205.10645-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220310090205.10645-1-chenyi.qiang@intel.com>
References: <20220310090205.10645-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are cases that malicious virtual machine can cause CPU stuck (due
to event windows don't open up), e.g., infinite loop in microcode when
nested #AC (CVE-2015-5307). No event window means no event (NMI, SMI and
IRQ) can be delivered. It leads the CPU to be unavailable to host or
other VMs. Notify VM exit is introduced to mitigate such kind of
attacks, which will generate a VM exit if no event window occurs in VM
non-root mode for a specified amount of time (notify window).

A new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT is exposed to user space
so that the user can query the capability and set the expected notify
window when creating VMs.

If notify VM exit happens with VM_INVALID_CONTEXT, hypervisor should
exit to user space with the exit reason KVM_EXIT_NOTIFY to inform the
fatal case. Then user space can inject a SHUTDOWN event to the target
vcpu. This is implemented by defining a new bit in flags field of
kvm_vcpu_event in KVM_SET_VCPU_EVENTS ioctl.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 hw/i386/x86.c         | 24 ++++++++++++++++++
 include/hw/i386/x86.h |  3 +++
 target/i386/kvm/kvm.c | 58 ++++++++++++++++++++++++++++---------------
 3 files changed, 65 insertions(+), 20 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index b84840a1bb..25e6c50b1e 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1309,6 +1309,23 @@ static void machine_set_sgx_epc(Object *obj, Visitor *v, const char *name,
     qapi_free_SgxEPCList(list);
 }
 
+static void x86_machine_get_notify_window(Object *obj, Visitor *v,
+                                const char *name, void *opaque, Error **errp)
+{
+    X86MachineState *x86ms = X86_MACHINE(obj);
+    int32_t notify_window = x86ms->notify_window;
+
+    visit_type_int32(v, name, &notify_window, errp);
+}
+
+static void x86_machine_set_notify_window(Object *obj, Visitor *v,
+                               const char *name, void *opaque, Error **errp)
+{
+    X86MachineState *x86ms = X86_MACHINE(obj);
+
+    visit_type_int32(v, name, &x86ms->notify_window, errp);
+}
+
 static void x86_machine_initfn(Object *obj)
 {
     X86MachineState *x86ms = X86_MACHINE(obj);
@@ -1319,6 +1336,7 @@ static void x86_machine_initfn(Object *obj)
     x86ms->oem_id = g_strndup(ACPI_BUILD_APPNAME6, 6);
     x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
     x86ms->bus_lock_ratelimit = 0;
+    x86ms->notify_window = -1;
 }
 
 static void x86_machine_class_init(ObjectClass *oc, void *data)
@@ -1375,6 +1393,12 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
         NULL, NULL);
     object_class_property_set_description(oc, "sgx-epc",
         "SGX EPC device");
+
+    object_class_property_add(oc, X86_MACHINE_NOTIFY_WINDOW, "int32_t",
+                                x86_machine_get_notify_window,
+                                x86_machine_set_notify_window, NULL, NULL);
+    object_class_property_set_description(oc, X86_MACHINE_NOTIFY_WINDOW,
+            "Set the notify window required by notify VM exit");
 }
 
 static const TypeInfo x86_machine_info = {
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index a145a30370..2a4ca21a94 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -82,6 +82,8 @@ struct X86MachineState {
      * which means no limitation on the guest's bus locks.
      */
     uint64_t bus_lock_ratelimit;
+
+    int32_t notify_window;
 };
 
 #define X86_MACHINE_SMM              "smm"
@@ -89,6 +91,7 @@ struct X86MachineState {
 #define X86_MACHINE_OEM_ID           "x-oem-id"
 #define X86_MACHINE_OEM_TABLE_ID     "x-oem-table-id"
 #define X86_MACHINE_BUS_LOCK_RATELIMIT  "bus-lock-ratelimit"
+#define X86_MACHINE_NOTIFY_WINDOW     "notify-window"
 
 #define TYPE_X86_MACHINE   MACHINE_TYPE_NAME("x86")
 OBJECT_DECLARE_TYPE(X86MachineState, X86MachineClass, X86_MACHINE)
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 83d0988302..65ad370652 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2299,6 +2299,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     int ret;
     struct utsname utsname;
     Error *local_err = NULL;
+    X86MachineState *x86ms;
+
+    assert(object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE));
+    x86ms = X86_MACHINE(ms);
 
     /*
      * Initialize SEV context, if required
@@ -2394,8 +2398,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     }
 
     if (kvm_check_extension(s, KVM_CAP_X86_SMM) &&
-        object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE) &&
-        x86_machine_is_smm_enabled(X86_MACHINE(ms))) {
+        x86_machine_is_smm_enabled(x86ms)) {
         smram_machine_done.notify = register_smram_listener;
         qemu_add_machine_init_done_notifier(&smram_machine_done);
     }
@@ -2423,25 +2426,31 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
-    if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE)) {
-        X86MachineState *x86ms = X86_MACHINE(ms);
+    if (x86ms->bus_lock_ratelimit > 0) {
+        ret = kvm_check_extension(s, KVM_CAP_X86_BUS_LOCK_EXIT);
+        if (!(ret & KVM_BUS_LOCK_DETECTION_EXIT)) {
+            error_report("kvm: bus lock detection unsupported");
+            return -ENOTSUP;
+        }
+        ret = kvm_vm_enable_cap(s, KVM_CAP_X86_BUS_LOCK_EXIT, 0,
+                                KVM_BUS_LOCK_DETECTION_EXIT);
+        if (ret < 0) {
+            error_report("kvm: Failed to enable bus lock detection cap: %s",
+                         strerror(-ret));
+            return ret;
+        }
+        ratelimit_init(&bus_lock_ratelimit_ctrl);
+        ratelimit_set_speed(&bus_lock_ratelimit_ctrl,
+                            x86ms->bus_lock_ratelimit, BUS_LOCK_SLICE_TIME);
+    }
 
-        if (x86ms->bus_lock_ratelimit > 0) {
-            ret = kvm_check_extension(s, KVM_CAP_X86_BUS_LOCK_EXIT);
-            if (!(ret & KVM_BUS_LOCK_DETECTION_EXIT)) {
-                error_report("kvm: bus lock detection unsupported");
-                return -ENOTSUP;
-            }
-            ret = kvm_vm_enable_cap(s, KVM_CAP_X86_BUS_LOCK_EXIT, 0,
-                                    KVM_BUS_LOCK_DETECTION_EXIT);
-            if (ret < 0) {
-                error_report("kvm: Failed to enable bus lock detection cap: %s",
-                             strerror(-ret));
-                return ret;
-            }
-            ratelimit_init(&bus_lock_ratelimit_ctrl);
-            ratelimit_set_speed(&bus_lock_ratelimit_ctrl,
-                                x86ms->bus_lock_ratelimit, BUS_LOCK_SLICE_TIME);
+    if (kvm_check_extension(s, KVM_CAP_X86_NOTIFY_VMEXIT)) {
+        ret = kvm_vm_enable_cap(s, KVM_CAP_X86_NOTIFY_VMEXIT, 0,
+                                x86ms->notify_window);
+        if (ret < 0) {
+            error_report("kvm: Failed to enable notify vmexit cap: %s",
+                         strerror(-ret));
+            return ret;
         }
     }
 
@@ -4856,6 +4865,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
     X86CPU *cpu = X86_CPU(cs);
     uint64_t code;
     int ret;
+    struct kvm_vcpu_events events = {};
 
     switch (run->exit_reason) {
     case KVM_EXIT_HLT:
@@ -4911,6 +4921,14 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         /* already handled in kvm_arch_post_run */
         ret = 0;
         break;
+    case KVM_EXIT_NOTIFY:
+        ret = 0;
+        if (run->notify.data & KVM_NOTIFY_CONTEXT_INVALID) {
+            warn_report("KVM: invalid context due to notify vmexit");
+            events.flags |= KVM_VCPUEVENT_SHUTDOWN;
+            ret = kvm_vcpu_ioctl(cs, KVM_SET_VCPU_EVENTS, &events);
+        }
+        break;
     default:
         fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);
         ret = -1;
-- 
2.17.1

