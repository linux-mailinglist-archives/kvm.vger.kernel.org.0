Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AB35EEE9E
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 09:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbiI2HOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 03:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbiI2HOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 03:14:14 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEF8132FF6
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 00:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664435648; x=1695971648;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=PvmDqbquWzupiy4aH26wEXQ5Z+AGyeFV5o+EPKcrQdA=;
  b=dHJDL4Wi746RwnRIMEmcD22RdJg1CurRMrS0Meljue811vwC+AC2pfzQ
   S1uikJ3Ku13NW3CIXPfyDf4+4zWOugK1/zhbH6/fAeqv430wE0pLAXpzA
   o5ijvmH4WbaF7d3DpTaGnpnLpPa+SPLruwx368+yYvhiwy7qkqCy3NYjU
   X1drk1FD2xkTJ1Wln0v326KYAY751IrXGj0hizmWR3ndwL80kiIGlBVvF
   2YgaLrjZaw/MZ5yFl1eXyN03Gy+33XNSvxbL6NbjUyvP7PqJZh1sDECnx
   gQxJ8sG5LE0wZSzgMSSBA3n+NpVJlP7Day4l0unalKKO/YarRQPGsWgu1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="288978824"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="288978824"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 00:14:08 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="655440752"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="655440752"
Received: from chenyi-pc.sh.intel.com ([10.239.159.53])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 00:14:05 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Peter Xu <peterx@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [RESEND PATCH v8 4/4] i386: add notify VM exit support
Date:   Thu, 29 Sep 2022 15:20:14 +0800
Message-Id: <20220929072014.20705-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220929072014.20705-1-chenyi.qiang@intel.com>
References: <20220929072014.20705-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
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

Users can configure the feature by a new (x86 only) accel property:
    qemu -accel kvm,notify-vmexit=run|internal-error|disable,notify-window=n

The default option of notify-vmexit is run, which will enable the
capability and do nothing if the exit happens. The internal-error option
raises a KVM internal error if it happens. The disable option does not
enable the capability. The default value of notify-window is 0. It is valid
only when notify-vmexit is not disabled. The valid range of notify-window
is non-negative. It is even safe to set it to zero since there's an
internal hardware threshold to be added to ensure no false positive.

Because a notify VM exit may happen with VM_CONTEXT_INVALID set in exit
qualification (no cases are anticipated that would set this bit), which
means VM context is corrupted. It would be reflected in the flags of
KVM_EXIT_NOTIFY exit. If KVM_NOTIFY_CONTEXT_INVALID bit is set, raise a KVM
internal error unconditionally.

Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 accel/kvm/kvm-all.c   |  2 +
 qapi/run-state.json   | 17 ++++++++
 qemu-options.hx       | 11 +++++
 target/i386/kvm/kvm.c | 98 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 128 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 3624ed8447..41ba9de3b8 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3636,6 +3636,8 @@ static void kvm_accel_instance_init(Object *obj)
     s->kernel_irqchip_split = ON_OFF_AUTO_AUTO;
     /* KVM dirty ring is by default off */
     s->kvm_dirty_ring_size = 0;
+    s->notify_vmexit = NOTIFY_VMEXIT_OPTION_RUN;
+    s->notify_window = 0;
 }
 
 static void kvm_accel_class_init(ObjectClass *oc, void *data)
diff --git a/qapi/run-state.json b/qapi/run-state.json
index 9273ea6516..49989d30e6 100644
--- a/qapi/run-state.json
+++ b/qapi/run-state.json
@@ -643,3 +643,20 @@
 { 'struct': 'MemoryFailureFlags',
   'data': { 'action-required': 'bool',
             'recursive': 'bool'} }
+
+##
+# @NotifyVmexitOption:
+#
+# An enumeration of the options specified when enabling notify VM exit
+#
+# @run: enable the feature, do nothing and continue if the notify VM exit happens.
+#
+# @internal-error: enable the feature, raise a internal error if the notify
+#                  VM exit happens.
+#
+# @disable: disable the feature.
+#
+# Since: 7.2
+##
+{ 'enum': 'NotifyVmexitOption',
+  'data': [ 'run', 'internal-error', 'disable' ] }
\ No newline at end of file
diff --git a/qemu-options.hx b/qemu-options.hx
index 913c71e38f..8f85004a7d 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -191,6 +191,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
     "                split-wx=on|off (enable TCG split w^x mapping)\n"
     "                tb-size=n (TCG translation block cache size)\n"
     "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
+    "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
     "                thread=single|multi (enable multi-threaded TCG)\n", QEMU_ARCH_ALL)
 SRST
 ``-accel name[,prop=value[,...]]``
@@ -242,6 +243,16 @@ SRST
         is disabled (dirty-ring-size=0).  When enabled, KVM will instead
         record dirty pages in a bitmap.
 
+    ``notify-vmexit=run|internal-error|disable,notify-window=n``
+        Enables or disables notify VM exit support on x86 host and specify
+        the corresponding notify window to trigger the VM exit if enabled.
+        ``run`` option enables the feature. It does nothing and continue
+        if the exit happens. ``internal-error`` option enables the feature.
+        It raises a internal error. ``disable`` option doesn't enable the feature.
+        This feature can mitigate the CPU stuck issue due to event windows don't
+        open up for a specified of time (i.e. notify-window).
+        Default: notify-vmexit=run,notify-window=0.
+
 ERST
 
 DEF("smp", HAS_ARG, QEMU_OPTION_smp,
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index eab09833f9..9a4378b304 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -15,6 +15,7 @@
 #include "qemu/osdep.h"
 #include "qapi/qapi-events-run-state.h"
 #include "qapi/error.h"
+#include "qapi/visitor.h"
 #include <sys/ioctl.h>
 #include <sys/utsname.h>
 #include <sys/syscall.h>
@@ -2599,6 +2600,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    if (s->notify_vmexit != NOTIFY_VMEXIT_OPTION_DISABLE &&
+        kvm_check_extension(s, KVM_CAP_X86_NOTIFY_VMEXIT)) {
+            uint64_t notify_window_flags =
+                ((uint64_t)s->notify_window << 32) |
+                KVM_X86_NOTIFY_VMEXIT_ENABLED |
+                KVM_X86_NOTIFY_VMEXIT_USER;
+            ret = kvm_vm_enable_cap(s, KVM_CAP_X86_NOTIFY_VMEXIT, 0,
+                                    notify_window_flags);
+            if (ret < 0) {
+                error_report("kvm: Failed to enable notify vmexit cap: %s",
+                             strerror(-ret));
+                return ret;
+            }
+    }
+
     return 0;
 }
 
@@ -5141,6 +5157,9 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
     X86CPU *cpu = X86_CPU(cs);
     uint64_t code;
     int ret;
+    bool ctx_invalid;
+    char str[256];
+    KVMState *state;
 
     switch (run->exit_reason) {
     case KVM_EXIT_HLT:
@@ -5196,6 +5215,21 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         /* already handled in kvm_arch_post_run */
         ret = 0;
         break;
+    case KVM_EXIT_NOTIFY:
+        ctx_invalid = !!(run->notify.flags & KVM_NOTIFY_CONTEXT_INVALID);
+        state = KVM_STATE(current_accel());
+        sprintf(str, "Encounter a notify exit with %svalid context in"
+                     " guest. There can be possible misbehaves in guest."
+                     " Please have a look.", ctx_invalid ? "in" : "");
+        if (ctx_invalid ||
+            state->notify_vmexit == NOTIFY_VMEXIT_OPTION_INTERNAL_ERROR) {
+            warn_report("KVM internal error: %s", str);
+            ret = -1;
+        } else {
+            warn_report_once("KVM: %s", str);
+            ret = 0;
+        }
+        break;
     default:
         fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);
         ret = -1;
@@ -5473,6 +5507,70 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
     }
 }
 
+static int kvm_arch_get_notify_vmexit(Object *obj, Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    return s->notify_vmexit;
+}
+
+static void kvm_arch_set_notify_vmexit(Object *obj, int value, Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+
+    if (s->fd != -1) {
+        error_setg(errp, "Cannot set properties after the accelerator has been initialized");
+        return;
+    }
+
+    s->notify_vmexit = value;
+}
+
+static void kvm_arch_get_notify_window(Object *obj, Visitor *v,
+                                       const char *name, void *opaque,
+                                       Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    uint32_t value = s->notify_window;
+
+    visit_type_uint32(v, name, &value, errp);
+}
+
+static void kvm_arch_set_notify_window(Object *obj, Visitor *v,
+                                       const char *name, void *opaque,
+                                       Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    Error *error = NULL;
+    uint32_t value;
+
+    if (s->fd != -1) {
+        error_setg(errp, "Cannot set properties after the accelerator has been initialized");
+        return;
+    }
+
+    visit_type_uint32(v, name, &value, &error);
+    if (error) {
+        error_propagate(errp, error);
+        return;
+    }
+
+    s->notify_window = value;
+}
+
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
+    object_class_property_add_enum(oc, "notify-vmexit", "NotifyVMexitOption",
+                                   &NotifyVmexitOption_lookup,
+                                   kvm_arch_get_notify_vmexit,
+                                   kvm_arch_set_notify_vmexit);
+    object_class_property_set_description(oc, "notify-vmexit",
+                                          "Enable notify VM exit");
+
+    object_class_property_add(oc, "notify-window", "uint32",
+                              kvm_arch_get_notify_window,
+                              kvm_arch_set_notify_window,
+                              NULL, NULL);
+    object_class_property_set_description(oc, "notify-window",
+                                          "Clock cycles without an event window "
+                                          "after which a notification VM exit occurs");
 }
-- 
2.17.1

