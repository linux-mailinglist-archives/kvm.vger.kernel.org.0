Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34241D2807
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgENGls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:48 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:52975 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgENGlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 02:41:32 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24m14zwz9sTw; Thu, 14 May 2020 16:41:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438488;
        bh=WyiZoF1mzL5OoKjGqBGnRf4GRkvW7uXDxuJdtMLizl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/eoNX4A238oWdUgT4+Yeb8cnie5ys6bT2E3T9v5XfgpnUft9hi+K7dS0lWjpRtu5
         o80EfJTmQQDlrABeUeJfbYpyHFsCvnztjyInJ8xPnPWdL5vDXIqjrC65i+NQ4lEX1N
         csyuLqQ5P5Rny8/d6OdNVMhQfwe4UOOpDW1azltI=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.redhat.com,
        qemu-devel@nongnu.org, brijesh.singh@amd.com
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.-rg,
        mdroth@linux.vnet.ibm.com
Subject: [RFC 15/18] guest memory protection: Decouple kvm_memcrypt_*() helpers from KVM
Date:   Thu, 14 May 2020 16:41:17 +1000
Message-Id: <20200514064120.449050-16-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
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

Therefore, move and rename them to helpers in guest-memory-protection.h,
taking an explicit machine parameter.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 accel/kvm/kvm-all.c                    | 28 -------------------
 accel/stubs/kvm-stub.c                 | 10 -------
 hw/i386/pc_sysfw.c                     |  6 ++--
 include/exec/guest-memory-protection.h | 38 ++++++++++++++++++++++++++
 include/sysemu/kvm.h                   | 17 ------------
 5 files changed, 42 insertions(+), 57 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 60c4fe326b..5451728425 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -117,9 +117,6 @@ struct KVMState
     KVMMemoryListener memory_listener;
     QLIST_HEAD(, KVMParkedVcpu) kvm_parked_vcpus;
 
-    /* memory encryption */
-    GuestMemoryProtection *guest_memory_protection;
-
     /* For "info mtree -f" to tell if an MR is registered in KVM */
     int nr_as;
     struct KVMAs {
@@ -168,29 +165,6 @@ int kvm_get_max_memslots(void)
     return s->nr_slots;
 }
 
-bool kvm_memcrypt_enabled(void)
-{
-    if (kvm_state && kvm_state->guest_memory_protection) {
-        return true;
-    }
-
-    return false;
-}
-
-int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
-{
-    GuestMemoryProtection *gmpo = kvm_state->guest_memory_protection;
-
-    if (gmpo) {
-        GuestMemoryProtectionClass *gmpc =
-            GUEST_MEMORY_PROTECTION_GET_CLASS(gmpo);
-
-        return gmpc->encrypt_data(gmpo, ptr, len);
-    }
-
-    return 1;
-}
-
 /* Called with KVMMemoryListener.slots_lock held */
 static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
 {
@@ -2076,8 +2050,6 @@ static int kvm_init(MachineState *ms)
         if (ret < 0) {
             goto err;
         }
-
-        kvm_state->guest_memory_protection = ms->gmpo;
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
index f5f3f466b0..4b015085f6 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -38,6 +38,7 @@
 #include "sysemu/sysemu.h"
 #include "hw/block/flash.h"
 #include "sysemu/kvm.h"
+#include "exec/guest-memory-protection.h"
 
 /*
  * We don't have a theoretically justifiable exact lower bound on the base
@@ -197,10 +198,11 @@ static void pc_system_flash_map(PCMachineState *pcms,
             pc_isa_bios_init(rom_memory, flash_mem, size);
 
             /* Encrypt the pflash boot ROM */
-            if (kvm_memcrypt_enabled()) {
+            if (guest_memory_protection_enabled(MACHINE(pcms))) {
                 flash_ptr = memory_region_get_ram_ptr(flash_mem);
                 flash_size = memory_region_size(flash_mem);
-                ret = kvm_memcrypt_encrypt_data(flash_ptr, flash_size);
+                ret = guest_memory_protection_encrypt(MACHINE(pcms),
+                                                      flash_ptr, flash_size);
                 if (ret) {
                     error_report("failed to encrypt pflash rom");
                     exit(1);
diff --git a/include/exec/guest-memory-protection.h b/include/exec/guest-memory-protection.h
index 3707b96515..7d959b4910 100644
--- a/include/exec/guest-memory-protection.h
+++ b/include/exec/guest-memory-protection.h
@@ -14,6 +14,7 @@
 #define QEMU_GUEST_MEMORY_PROTECTION_H
 
 #include "qom/object.h"
+#include "hw/boards.h"
 
 typedef struct GuestMemoryProtection GuestMemoryProtection;
 
@@ -35,5 +36,42 @@ typedef struct GuestMemoryProtectionClass {
     int (*encrypt_data)(GuestMemoryProtection *, uint8_t *, uint64_t);
 } GuestMemoryProtectionClass;
 
+/**
+ * guest_memory_protection_enabled - return whether guest memory is
+ *                                   protected from hypervisor access
+ *                                   (with memory encryption or
+ *                                   otherwise)
+ * Returns: true guest memory is not directly accessible to qemu
+ *          false guest memory is directly accessible to qemu
+ */
+static inline bool guest_memory_protection_enabled(MachineState *machine)
+{
+    return !!machine->gmpo;
+}
+
+/**
+ * guest_memory_protection_encrypt: encrypt the memory range to make
+ *                                  it guest accessible
+ *
+ * Return: 1 failed to encrypt the range
+ *         0 succesfully encrypted memory region
+ */
+static inline int guest_memory_protection_encrypt(MachineState *machine,
+                                                  uint8_t *ptr, uint64_t len)
+{
+    GuestMemoryProtection *gmpo = machine->gmpo;
+
+    if (gmpo) {
+        GuestMemoryProtectionClass *gmpc =
+            GUEST_MEMORY_PROTECTION_GET_CLASS(gmpo);
+
+        if (gmpc->encrypt_data) {
+            return gmpc->encrypt_data(gmpo, ptr, len);
+        }
+    }
+
+    return 1;
+}
+
 #endif /* QEMU_GUEST_MEMORY_PROTECTION_H */
 
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 141342de98..656b122f8a 100644
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

