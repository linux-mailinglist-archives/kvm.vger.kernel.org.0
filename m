Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4D25F0F46
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 17:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiI3Pwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 11:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiI3PwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 11:52:22 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05411A40B7
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 08:52:19 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1oeIJ7-0005Ou-Ls; Fri, 30 Sep 2022 17:52:09 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: [PATCH v3] hyperv: fix SynIC SINT assertion failure on guest reset
Date:   Fri, 30 Sep 2022 17:52:03 +0200
Message-Id: <cb57cee2e29b20d06f81dce054cbcea8b5d497e8.1664552976.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Resetting a guest that has Hyper-V VMBus support enabled triggers a QEMU
assertion failure:
hw/hyperv/hyperv.c:131: synic_reset: Assertion `QLIST_EMPTY(&synic->sint_routes)' failed.

This happens both on normal guest reboot or when using "system_reset" HMP
command.

The failing assertion was introduced by commit 64ddecc88bcf ("hyperv: SControl is optional to enable SynIc")
to catch dangling SINT routes on SynIC reset.

The root cause of this problem is that the SynIC itself is reset before
devices using SINT routes have chance to clean up these routes.

Since there seems to be no existing mechanism to force reset callbacks (or
methods) to be executed in specific order let's use a similar method that
is already used to reset another interrupt controller (APIC) after devices
have been reset - by invoking the SynIC reset from the machine reset
handler via a new x86_cpu_after_reset() function co-located with
the existing x86_cpu_reset() in target/i386/cpu.c.
Opportunistically move the APIC reset handler there, too.

Fixes: 64ddecc88bcf ("hyperv: SControl is optional to enable SynIc") # exposed the bug
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---

Changes from v2:
Make sure that the microvm machine reset handler also calls
x86_cpu_after_reset().
Opportunistically move the APIC reset handler to x86_cpu_after_reset().

 hw/i386/microvm.c          |  4 +---
 hw/i386/pc.c               |  5 ++---
 target/i386/cpu.c          | 13 +++++++++++++
 target/i386/cpu.h          |  2 ++
 target/i386/kvm/hyperv.c   |  4 ++++
 target/i386/kvm/kvm.c      | 24 +++++++++++++++++-------
 target/i386/kvm/kvm_i386.h |  1 +
 7 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index 52cafa003d..a3ff915b71 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -485,9 +485,7 @@ static void microvm_machine_reset(MachineState *machine)
     CPU_FOREACH(cs) {
         cpu = X86_CPU(cs);
 
-        if (cpu->apic_state) {
-            device_legacy_reset(cpu->apic_state);
-        }
+        x86_cpu_after_reset(cpu);
     }
 }
 
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 566accf7e6..768982ae9a 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -92,6 +92,7 @@
 #include "hw/virtio/virtio-mem-pci.h"
 #include "hw/mem/memory-device.h"
 #include "sysemu/replay.h"
+#include "target/i386/cpu.h"
 #include "qapi/qmp/qerror.h"
 #include "e820_memory_layout.h"
 #include "fw_cfg.h"
@@ -1859,9 +1860,7 @@ static void pc_machine_reset(MachineState *machine)
     CPU_FOREACH(cs) {
         cpu = X86_CPU(cs);
 
-        if (cpu->apic_state) {
-            device_legacy_reset(cpu->apic_state);
-        }
+        x86_cpu_after_reset(cpu);
     }
 }
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1db1278a59..ddb4fce2e0 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6034,6 +6034,19 @@ static void x86_cpu_reset(DeviceState *dev)
 #endif
 }
 
+void x86_cpu_after_reset(X86CPU *cpu)
+{
+#ifndef CONFIG_USER_ONLY
+    if (kvm_enabled()) {
+        kvm_arch_after_reset_vcpu(cpu);
+    }
+
+    if (cpu->apic_state) {
+        device_legacy_reset(cpu->apic_state);
+    }
+#endif
+}
+
 static void mce_init(X86CPU *cpu)
 {
     CPUX86State *cenv = &cpu->env;
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 82004b65b9..c67d98e1a9 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2079,6 +2079,8 @@ typedef struct PropValue {
 } PropValue;
 void x86_cpu_apply_props(X86CPU *cpu, PropValue *props);
 
+void x86_cpu_after_reset(X86CPU *cpu);
+
 uint32_t cpu_x86_virtual_addr_width(CPUX86State *env);
 
 /* cpu.c other functions (cpuid) */
diff --git a/target/i386/kvm/hyperv.c b/target/i386/kvm/hyperv.c
index 9026ef3a81..e3ac978648 100644
--- a/target/i386/kvm/hyperv.c
+++ b/target/i386/kvm/hyperv.c
@@ -23,6 +23,10 @@ int hyperv_x86_synic_add(X86CPU *cpu)
     return 0;
 }
 
+/*
+ * All devices possibly using SynIC have to be reset before calling this to let
+ * them remove their SINT routes first.
+ */
 void hyperv_x86_synic_reset(X86CPU *cpu)
 {
     hyperv_synic_reset(CPU(cpu));
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a1fd1f5379..774484c588 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2203,20 +2203,30 @@ void kvm_arch_reset_vcpu(X86CPU *cpu)
         env->mp_state = KVM_MP_STATE_RUNNABLE;
     }
 
+    /* enabled by default */
+    env->poll_control_msr = 1;
+
+    kvm_init_nested_state(env);
+
+    sev_es_set_reset_vector(CPU(cpu));
+}
+
+void kvm_arch_after_reset_vcpu(X86CPU *cpu)
+{
+    CPUX86State *env = &cpu->env;
+    int i;
+
+    /*
+     * Reset SynIC after all other devices have been reset to let them remove
+     * their SINT routes first.
+     */
     if (hyperv_feat_enabled(cpu, HYPERV_FEAT_SYNIC)) {
-        int i;
         for (i = 0; i < ARRAY_SIZE(env->msr_hv_synic_sint); i++) {
             env->msr_hv_synic_sint[i] = HV_SINT_MASKED;
         }
 
         hyperv_x86_synic_reset(cpu);
     }
-    /* enabled by default */
-    env->poll_control_msr = 1;
-
-    kvm_init_nested_state(env);
-
-    sev_es_set_reset_vector(CPU(cpu));
 }
 
 void kvm_arch_do_init_vcpu(X86CPU *cpu)
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 4124912c20..096a5dd781 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -38,6 +38,7 @@ bool kvm_has_adjust_clock_stable(void);
 bool kvm_has_exception_payload(void);
 void kvm_synchronize_all_tsc(void);
 void kvm_arch_reset_vcpu(X86CPU *cs);
+void kvm_arch_after_reset_vcpu(X86CPU *cpu);
 void kvm_arch_do_init_vcpu(X86CPU *cs);
 
 void kvm_put_apicbase(X86CPU *cpu, uint64_t value);
