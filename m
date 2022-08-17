Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB04596726
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 04:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238416AbiHQCCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 22:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238414AbiHQCCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 22:02:48 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBD77FE77
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 19:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660701767; x=1692237767;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=TBdOPitsnPLxSWtKB89/2rfBgbhufRafl/PkkuOQhoo=;
  b=hHXkikiKPThCWxGe5cMfaEWrKAV0a4jsF+eIOWG/FxF64OBrCfVqWxi0
   8Hl6lnzx1roZSVMapLy9LM0mEUMRkvlxpWq44n0KDvKrZoOLK5G2jDo6H
   j4RL9LJDTgrxsylA4Xj85VYeLxprIJBajf3l52eW36Nu6WqyMG8XYYNpP
   ci91DlQ0o9itg4zja7VWjdrPD6zN6qpn8rz3Hk1a+KjhtrFZ9pgH93XKy
   87r9E/fIEFpt6LMW13hjW1YiTpvgWmnis7b9Dle+l0HXlgFUnaZmQHpCP
   PUKNU8NLRW6ekGukB0J+xKjV1Twb2hYsuGWQRygx9GfR7rogmkOtG5eVG
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="291131210"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="291131210"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 19:02:47 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="675456991"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 19:02:45 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v5 3/3] i386: Add notify VM exit support
Date:   Wed, 17 Aug 2022 10:08:45 +0800
Message-Id: <20220817020845.21855-4-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220817020845.21855-1-chenyi.qiang@intel.com>
References: <20220817020845.21855-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
window when creating VMs. The format of the argument when enabling this
capability is as follows:
  Bit 63:32 - notify window specified in qemu command
  Bit 31:0  - some flags (e.g. KVM_X86_NOTIFY_VMEXIT_ENABLED is set to
              enable the feature.)

Because there are some concerns, e.g. a notify VM exit may happen with
VM_CONTEXT_INVALID set in exit qualification (no cases are anticipated
that would set this bit), which means VM context is corrupted. To avoid
the false positive and a well-behaved guest gets killed, make this
feature disabled by default. Users can enable the feature by a new
machine property:
    qemu -machine notify_vmexit=on,notify_window=0 ...

A new KVM exit reason KVM_EXIT_NOTIFY is defined for notify VM exit. If
it happens with VM_INVALID_CONTEXT, hypervisor exits to user space to
inform the fatal case. Then user space can inject a SHUTDOWN event to
the target vcpu. This is implemented by injecting a sythesized triple
fault event.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 hw/i386/x86.c         | 45 +++++++++++++++++++++++++++++++++++++++++++
 include/hw/i386/x86.h |  5 +++++
 target/i386/kvm/kvm.c | 28 +++++++++++++++++++++++++++
 3 files changed, 78 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 050eedc0c8..1eccbd3deb 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1379,6 +1379,37 @@ static void machine_set_sgx_epc(Object *obj, Visitor *v, const char *name,
     qapi_free_SgxEPCList(list);
 }
 
+static bool x86_machine_get_notify_vmexit(Object *obj, Error **errp)
+{
+    X86MachineState *x86ms = X86_MACHINE(obj);
+
+    return x86ms->notify_vmexit;
+}
+
+static void x86_machine_set_notify_vmexit(Object *obj, bool value, Error **errp)
+{
+    X86MachineState *x86ms = X86_MACHINE(obj);
+
+    x86ms->notify_vmexit = value;
+}
+
+static void x86_machine_get_notify_window(Object *obj, Visitor *v,
+                                const char *name, void *opaque, Error **errp)
+{
+    X86MachineState *x86ms = X86_MACHINE(obj);
+    uint32_t notify_window = x86ms->notify_window;
+
+    visit_type_uint32(v, name, &notify_window, errp);
+}
+
+static void x86_machine_set_notify_window(Object *obj, Visitor *v,
+                               const char *name, void *opaque, Error **errp)
+{
+    X86MachineState *x86ms = X86_MACHINE(obj);
+
+    visit_type_uint32(v, name, &x86ms->notify_window, errp);
+}
+
 static void x86_machine_initfn(Object *obj)
 {
     X86MachineState *x86ms = X86_MACHINE(obj);
@@ -1392,6 +1423,8 @@ static void x86_machine_initfn(Object *obj)
     x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
     x86ms->bus_lock_ratelimit = 0;
     x86ms->above_4g_mem_start = 4 * GiB;
+    x86ms->notify_vmexit = false;
+    x86ms->notify_window = 0;
 }
 
 static void x86_machine_class_init(ObjectClass *oc, void *data)
@@ -1461,6 +1494,18 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
         NULL, NULL);
     object_class_property_set_description(oc, "sgx-epc",
         "SGX EPC device");
+
+    object_class_property_add(oc, X86_MACHINE_NOTIFY_WINDOW, "uint32_t",
+                              x86_machine_get_notify_window,
+                              x86_machine_set_notify_window, NULL, NULL);
+    object_class_property_set_description(oc, X86_MACHINE_NOTIFY_WINDOW,
+            "Set the notify window required by notify VM exit");
+
+    object_class_property_add_bool(oc, X86_MACHINE_NOTIFY_VMEXIT,
+                                   x86_machine_get_notify_vmexit,
+                                   x86_machine_set_notify_vmexit);
+    object_class_property_set_description(oc, X86_MACHINE_NOTIFY_VMEXIT,
+            "Enable notify VM exit");
 }
 
 static const TypeInfo x86_machine_info = {
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index 62fa5774f8..5707329fa7 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -85,6 +85,9 @@ struct X86MachineState {
      * which means no limitation on the guest's bus locks.
      */
     uint64_t bus_lock_ratelimit;
+
+    bool notify_vmexit;
+    uint32_t notify_window;
 };
 
 #define X86_MACHINE_SMM              "smm"
@@ -94,6 +97,8 @@ struct X86MachineState {
 #define X86_MACHINE_OEM_ID           "x-oem-id"
 #define X86_MACHINE_OEM_TABLE_ID     "x-oem-table-id"
 #define X86_MACHINE_BUS_LOCK_RATELIMIT  "bus-lock-ratelimit"
+#define X86_MACHINE_NOTIFY_VMEXIT     "notify-vmexit"
+#define X86_MACHINE_NOTIFY_WINDOW     "notify-window"
 
 #define TYPE_X86_MACHINE   MACHINE_TYPE_NAME("x86")
 OBJECT_DECLARE_TYPE(X86MachineState, X86MachineClass, X86_MACHINE)
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index cb88ba4a00..85f11dd8d6 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2580,6 +2580,20 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
             ratelimit_set_speed(&bus_lock_ratelimit_ctrl,
                                 x86ms->bus_lock_ratelimit, BUS_LOCK_SLICE_TIME);
         }
+
+        if (x86ms->notify_vmexit &&
+            kvm_check_extension(s, KVM_CAP_X86_NOTIFY_VMEXIT)) {
+            uint64_t notify_window_flags = ((uint64_t)x86ms->notify_window << 32) |
+                                           KVM_X86_NOTIFY_VMEXIT_ENABLED |
+                                           KVM_X86_NOTIFY_VMEXIT_USER;
+            ret = kvm_vm_enable_cap(s, KVM_CAP_X86_NOTIFY_VMEXIT, 0,
+                                    notify_window_flags);
+            if (ret < 0) {
+                error_report("kvm: Failed to enable notify vmexit cap: %s",
+                             strerror(-ret));
+                return ret;
+            }
+        }
     }
 
     return 0;
@@ -5117,6 +5131,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
     X86CPU *cpu = X86_CPU(cs);
     uint64_t code;
     int ret;
+    struct kvm_vcpu_events events = {};
 
     switch (run->exit_reason) {
     case KVM_EXIT_HLT:
@@ -5172,6 +5187,19 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         /* already handled in kvm_arch_post_run */
         ret = 0;
         break;
+    case KVM_EXIT_NOTIFY:
+        ret = 0;
+        if (run->notify.flags & KVM_NOTIFY_CONTEXT_INVALID) {
+            warn_report("KVM: invalid context due to notify vmexit");
+            if (has_triple_fault_event) {
+                events.flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
+                events.triple_fault.pending = true;
+                ret = kvm_vcpu_ioctl(cs, KVM_SET_VCPU_EVENTS, &events);
+            } else {
+                ret = -1;
+            }
+        }
+        break;
     default:
         fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);
         ret = -1;
-- 
2.17.1

