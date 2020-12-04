Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FECF2CE7B8
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 06:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgLDFpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 00:45:44 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:53565 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbgLDFpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 00:45:43 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CnM8g6bfwz9sVp; Fri,  4 Dec 2020 16:44:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607060659;
        bh=Xn1Ehv+oTCo3XiURURCvz/JFFB+ow4VAF1+V7lqlNS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ed9o9wKFPM0s5Mo6zA5fSCi5uRSwLvtpYzjtCgaVHt7BW6ImDSZX0Gbyu3g6gOcIB
         WGrL398jc4G4ePzohkUWw+5INq7Fpjpi/+fFmr/gLzJDZ0+Wk/XWsmAcwvtppSVUAZ
         YLDm6JQVpnGfbC+vdWj85/oznV+REBNtZDCI45VU=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, David Gibson <david@gibson.dropbear.id.au>,
        cohuck@redhat.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com
Subject: [for-6.0 v5 06/13] securable guest memory: Decouple kvm_memcrypt_*() helpers from KVM
Date:   Fri,  4 Dec 2020 16:44:08 +1100
Message-Id: <20201204054415.579042-7-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201204054415.579042-1-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_memcrypt_enabled() and kvm_memcrypt_encrypt_data() helper functions
don't conceptually have any connection to KVM (although it's not possible
in practice to use them without it).

They also rely on looking at the global KVMState.  But the same information
is available from the machine, and the only existing callers have natural
access to the machine state.

Therefore, move and rename them to helpers in securable-guest-memory.h,
taking an explicit machine parameter.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/kvm/kvm-all.c                   | 27 --------------------
 accel/stubs/kvm-stub.c                | 10 --------
 hw/i386/pc_sysfw.c                    |  6 +++--
 include/exec/securable-guest-memory.h | 36 +++++++++++++++++++++++++++
 include/sysemu/kvm.h                  | 17 -------------
 5 files changed, 40 insertions(+), 56 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 92a49b328a..c6bd7b9d02 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -121,9 +121,6 @@ struct KVMState
     KVMMemoryListener memory_listener;
     QLIST_HEAD(, KVMParkedVcpu) kvm_parked_vcpus;
 
-    /* securable guest memory (e.g. by guest memory encryption) */
-    SecurableGuestMemory *sgm;
-
     /* For "info mtree -f" to tell if an MR is registered in KVM */
     int nr_as;
     struct KVMAs {
@@ -222,28 +219,6 @@ int kvm_get_max_memslots(void)
     return s->nr_slots;
 }
 
-bool kvm_memcrypt_enabled(void)
-{
-    if (kvm_state && kvm_state->sgm) {
-        return true;
-    }
-
-    return false;
-}
-
-int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
-{
-    SecurableGuestMemory *sgm = kvm_state->sgm;
-
-    if (sgm) {
-        SecurableGuestMemoryClass *sgmc = SECURABLE_GUEST_MEMORY_GET_CLASS(sgm);
-
-        return sgmc->encrypt_data(sgm, ptr, len);
-    }
-
-    return 1;
-}
-
 /* Called with KVMMemoryListener.slots_lock held */
 static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
 {
@@ -2213,8 +2188,6 @@ static int kvm_init(MachineState *ms)
         if (ret < 0) {
             goto err;
         }
-
-        kvm_state->sgm = ms->sgm;
     }
 
     ret = kvm_arch_init(ms, s);
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 680e099463..0f17acfac0 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -81,16 +81,6 @@ int kvm_on_sigbus(int code, void *addr)
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
index b6c0822fe3..439ac78970 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -38,6 +38,7 @@
 #include "sysemu/sysemu.h"
 #include "hw/block/flash.h"
 #include "sysemu/kvm.h"
+#include "exec/securable-guest-memory.h"
 
 /*
  * We don't have a theoretically justifiable exact lower bound on the base
@@ -201,10 +202,11 @@ static void pc_system_flash_map(PCMachineState *pcms,
             pc_isa_bios_init(rom_memory, flash_mem, size);
 
             /* Encrypt the pflash boot ROM */
-            if (kvm_memcrypt_enabled()) {
+            if (securable_guest_memory_enabled(MACHINE(pcms))) {
                 flash_ptr = memory_region_get_ram_ptr(flash_mem);
                 flash_size = memory_region_size(flash_mem);
-                ret = kvm_memcrypt_encrypt_data(flash_ptr, flash_size);
+                ret = securable_guest_memory_encrypt(MACHINE(pcms),
+                                                     flash_ptr, flash_size);
                 if (ret) {
                     error_report("failed to encrypt pflash rom");
                     exit(1);
diff --git a/include/exec/securable-guest-memory.h b/include/exec/securable-guest-memory.h
index 4e2ae27040..7325b504ba 100644
--- a/include/exec/securable-guest-memory.h
+++ b/include/exec/securable-guest-memory.h
@@ -21,6 +21,7 @@
 #ifndef CONFIG_USER_ONLY
 
 #include "qom/object.h"
+#include "hw/boards.h"
 
 #define TYPE_SECURABLE_GUEST_MEMORY "securable-guest-memory"
 #define SECURABLE_GUEST_MEMORY(obj)                                    \
@@ -43,6 +44,41 @@ typedef struct SecurableGuestMemoryClass {
     int (*encrypt_data)(SecurableGuestMemory *, uint8_t *, uint64_t);
 } SecurableGuestMemoryClass;
 
+/**
+ * securable_guest_memory_enabled - return whether guest memory is protected
+ *                               from hypervisor access (with memory
+ *                               encryption or otherwise)
+ * Returns: true guest memory is not directly accessible to qemu
+ *          false guest memory is directly accessible to qemu
+ */
+static inline bool securable_guest_memory_enabled(MachineState *machine)
+{
+    return !!machine->sgm;
+}
+
+/**
+ * securable_guest_memory_encrypt: encrypt the memory range to make
+ *                              it guest accessible
+ *
+ * Return: 1 failed to encrypt the range
+ *         0 succesfully encrypted memory region
+ */
+static inline int securable_guest_memory_encrypt(MachineState *machine,
+                                              uint8_t *ptr, uint64_t len)
+{
+    SecurableGuestMemory *sgm = machine->sgm;
+
+    if (sgm) {
+        SecurableGuestMemoryClass *sgmc = SECURABLE_GUEST_MEMORY_GET_CLASS(sgm);
+
+        if (sgmc->encrypt_data) {
+            return sgmc->encrypt_data(sgm, ptr, len);
+        }
+    }
+
+    return 1;
+}
+
 #endif /* !CONFIG_USER_ONLY */
 
 #endif /* QEMU_SECURABLE_GUEST_MEMORY_H */
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index bb5d5cf497..0e163c2c9d 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -233,23 +233,6 @@ int kvm_has_intx_set_mask(void);
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
2.28.0

