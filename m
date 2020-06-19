Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FA820000A
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 04:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgFSCGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 22:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729456AbgFSCGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 22:06:17 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FD1C0613EE
        for <kvm@vger.kernel.org>; Thu, 18 Jun 2020 19:06:15 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49p2GT1nx6z9sSg; Fri, 19 Jun 2020 12:06:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1592532369;
        bh=T8XqkWK5JYfur3/pmkkptr+wA0TMGxmdlb99ZrpmXZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBvMriufB9iG+tUu4tP1QPH2DHnINBGfgG58DZp8rqgZKdt7GFlHSdgv2cbCxtmxY
         64vPS+bMDu4WjEraFgPx/XClkpfn2dYIukR9dAIGrInHf3xTwu3qOmrgZTJ4qjpqjK
         2KZR9fPhMiGpVYa/el8HATHhqCc3ofYY+tgMm7Pk=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, mdroth@linux.vnet.ibm.com,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-s390x@nongnu.org, david@redhat.com,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 5/9] host trust limitation: Decouple kvm_memcrypt_*() helpers from KVM
Date:   Fri, 19 Jun 2020 12:05:58 +1000
Message-Id: <20200619020602.118306-6-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619020602.118306-1-david@gibson.dropbear.id.au>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_memcrypt_enabled() and kvm_memcrypt_encrypt_data() helper functions
don't conceptually have any connection to KVM (although it's not possible
in practice to use them without it).

They also rely on looking at the global KVMState.  But the same information
is available from the machine, and the only existing callers have natural
access to the machine state.

Therefore, move and rename them to helpers in host-trust-limitation.h,
taking an explicit machine parameter.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/kvm/kvm-all.c                  | 27 ---------------------
 accel/stubs/kvm-stub.c               | 10 --------
 hw/i386/pc_sysfw.c                   |  6 +++--
 include/exec/host-trust-limitation.h | 36 ++++++++++++++++++++++++++++
 include/sysemu/kvm.h                 | 17 -------------
 5 files changed, 40 insertions(+), 56 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index d8e8fa345e..9645271ca5 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -118,9 +118,6 @@ struct KVMState
     KVMMemoryListener memory_listener;
     QLIST_HEAD(, KVMParkedVcpu) kvm_parked_vcpus;
 
-    /* host trust limitation (e.g. by guest memory encryption) */
-    HostTrustLimitation *htl;
-
     /* For "info mtree -f" to tell if an MR is registered in KVM */
     int nr_as;
     struct KVMAs {
@@ -219,28 +216,6 @@ int kvm_get_max_memslots(void)
     return s->nr_slots;
 }
 
-bool kvm_memcrypt_enabled(void)
-{
-    if (kvm_state && kvm_state->htl) {
-        return true;
-    }
-
-    return false;
-}
-
-int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
-{
-    HostTrustLimitation *htl = kvm_state->htl;
-
-    if (htl) {
-        HostTrustLimitationClass *htlc = HOST_TRUST_LIMITATION_GET_CLASS(htl);
-
-        return htlc->encrypt_data(htl, ptr, len);
-    }
-
-    return 1;
-}
-
 /* Called with KVMMemoryListener.slots_lock held */
 static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
 {
@@ -2188,8 +2163,6 @@ static int kvm_init(MachineState *ms)
         if (ret < 0) {
             goto err;
         }
-
-        kvm_state->htl = ms->htl;
     }
 
     ret = kvm_arch_init(ms, s);
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 82f118d2df..78b3eef117 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -104,16 +104,6 @@ int kvm_on_sigbus(int code, void *addr)
     return 1;
 }
 
-bool kvm_memcrypt_enabled(void)
-{
-    return false;
-}
-
-int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
-{
-  return 1;
-}
-
 #ifndef CONFIG_USER_ONLY
 int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
 {
diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index ec2a3b3e7e..cab5ac5695 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -38,6 +38,7 @@
 #include "sysemu/sysemu.h"
 #include "hw/block/flash.h"
 #include "sysemu/kvm.h"
+#include "exec/host-trust-limitation.h"
 
 /*
  * We don't have a theoretically justifiable exact lower bound on the base
@@ -196,10 +197,11 @@ static void pc_system_flash_map(PCMachineState *pcms,
             pc_isa_bios_init(rom_memory, flash_mem, size);
 
             /* Encrypt the pflash boot ROM */
-            if (kvm_memcrypt_enabled()) {
+            if (host_trust_limitation_enabled(MACHINE(pcms))) {
                 flash_ptr = memory_region_get_ram_ptr(flash_mem);
                 flash_size = memory_region_size(flash_mem);
-                ret = kvm_memcrypt_encrypt_data(flash_ptr, flash_size);
+                ret = host_trust_limitation_encrypt(MACHINE(pcms),
+                                                    flash_ptr, flash_size);
                 if (ret) {
                     error_report("failed to encrypt pflash rom");
                     exit(1);
diff --git a/include/exec/host-trust-limitation.h b/include/exec/host-trust-limitation.h
index a19f12ae14..fc30ea3f78 100644
--- a/include/exec/host-trust-limitation.h
+++ b/include/exec/host-trust-limitation.h
@@ -14,6 +14,7 @@
 #define QEMU_HOST_TRUST_LIMITATION_H
 
 #include "qom/object.h"
+#include "hw/boards.h"
 
 #define TYPE_HOST_TRUST_LIMITATION "host-trust-limitation"
 #define HOST_TRUST_LIMITATION(obj)                                    \
@@ -33,4 +34,39 @@ typedef struct HostTrustLimitationClass {
     int (*encrypt_data)(HostTrustLimitation *, uint8_t *, uint64_t);
 } HostTrustLimitationClass;
 
+/**
+ * host_trust_limitation_enabled - return whether guest memory is protected
+ *                                 from hypervisor access (with memory
+ *                                 encryption or otherwise)
+ * Returns: true guest memory is not directly accessible to qemu
+ *          false guest memory is directly accessible to qemu
+ */
+static inline bool host_trust_limitation_enabled(MachineState *machine)
+{
+    return !!machine->htl;
+}
+
+/**
+ * host_trust_limitation_encrypt: encrypt the memory range to make
+ *                                it guest accessible
+ *
+ * Return: 1 failed to encrypt the range
+ *         0 succesfully encrypted memory region
+ */
+static inline int host_trust_limitation_encrypt(MachineState *machine,
+                                                uint8_t *ptr, uint64_t len)
+{
+    HostTrustLimitation *htl = machine->htl;
+
+    if (htl) {
+        HostTrustLimitationClass *htlc = HOST_TRUST_LIMITATION_GET_CLASS(htl);
+
+        if (htlc->encrypt_data) {
+            return htlc->encrypt_data(htl, ptr, len);
+        }
+    }
+
+    return 1;
+}
+
 #endif /* QEMU_HOST_TRUST_LIMITATION_H */
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index b4174d941c..c7b9739609 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -231,23 +231,6 @@ int kvm_destroy_vcpu(CPUState *cpu);
  */
 bool kvm_arm_supports_user_irq(void);
 
-/**
- * kvm_memcrypt_enabled - return boolean indicating whether memory encryption
- *                        is enabled
- * Returns: 1 memory encryption is enabled
- *          0 memory encryption is disabled
- */
-bool kvm_memcrypt_enabled(void);
-
-/**
- * kvm_memcrypt_encrypt_data: encrypt the memory range
- *
- * Return: 1 failed to encrypt the range
- *         0 succesfully encrypted memory region
- */
-int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len);
-
-
 #ifdef NEED_CPU_H
 #include "cpu.h"
 
-- 
2.26.2

