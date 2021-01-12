Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F022F2744
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 05:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731906AbhALEpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 23:45:55 -0500
Received: from ozlabs.org ([203.11.71.1]:44167 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731533AbhALEpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 23:45:54 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFJ0R320zz9sjD; Tue, 12 Jan 2021 15:45:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610426711;
        bh=thJIxYImNDEGyMXfz3IxBysZDEAVYAA8TpCNd/GoFv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPINh0KcaeCOugy1e8ye37CcM1MUy+v8lyrm3AE06w23UvnS3ge0xF8kzr6i/DySG
         rOSLItKNNkW/du++5VVbIWbshI2If5VtgtYd+o2WbYmKoIT7FEij82wXlGXPICgR8e
         RnY1IVFutI88eCRB+zqnqUtEz1sTB5W7Q39gIJos=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     andi.kleen@intel.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>,
        mdroth@linux.vnet.ibm.com, richard.henderson@linaro.org,
        kvm@vger.kernel.org,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: [PATCH v6 03/13] sev: Remove false abstraction of flash encryption
Date:   Tue, 12 Jan 2021 15:44:58 +1100
Message-Id: <20210112044508.427338-4-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112044508.427338-1-david@gibson.dropbear.id.au>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When AMD's SEV memory encryption is in use, flash memory banks (which are
initialed by pc_system_flash_map()) need to be encrypted with the guest's
key, so that the guest can read them.

That's abstracted via the kvm_memcrypt_encrypt_data() callback in the KVM
state.. except, that it doesn't really abstract much at all.

For starters, the only called is in code specific to the 'pc' family of
machine types, so it's obviously specific to those and to x86 to begin
with.  But it makes a bunch of further assumptions that need not be true
about an arbitrary confidential guest system based on memory encryption,
let alone one based on other mechanisms:

 * it assumes that the flash memory is defined to be encrypted with the
   guest key, rather than being shared with hypervisor
 * it assumes that that hypervisor has some mechanism to encrypt data into
   the guest, even though it can't decrypt it out, since that's the whole
   point
 * the interface assumes that this encrypt can be done in place, which
   implies that the hypervisor can write into a confidential guests's
   memory, even if what it writes isn't meaningful

So really, this "abstraction" is actually pretty specific to the way SEV
works.  So, this patch removes it and instead has the PC flash
initialization code call into a SEV specific callback.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 accel/kvm/kvm-all.c    | 31 ++-----------------------------
 accel/kvm/sev-stub.c   |  9 ++-------
 accel/stubs/kvm-stub.c | 10 ----------
 hw/i386/pc_sysfw.c     | 17 ++++++-----------
 include/sysemu/kvm.h   | 16 ----------------
 include/sysemu/sev.h   |  4 ++--
 target/i386/sev-stub.c |  5 +++++
 target/i386/sev.c      | 24 ++++++++++++++----------
 8 files changed, 31 insertions(+), 85 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 389eaace72..260ed73ffe 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -120,10 +120,6 @@ struct KVMState
     KVMMemoryListener memory_listener;
     QLIST_HEAD(, KVMParkedVcpu) kvm_parked_vcpus;
 
-    /* memory encryption */
-    void *memcrypt_handle;
-    int (*memcrypt_encrypt_data)(void *handle, uint8_t *ptr, uint64_t len);
-
     /* For "info mtree -f" to tell if an MR is registered in KVM */
     int nr_as;
     struct KVMAs {
@@ -222,26 +218,6 @@ int kvm_get_max_memslots(void)
     return s->nr_slots;
 }
 
-bool kvm_memcrypt_enabled(void)
-{
-    if (kvm_state && kvm_state->memcrypt_handle) {
-        return true;
-    }
-
-    return false;
-}
-
-int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
-{
-    if (kvm_state->memcrypt_handle &&
-        kvm_state->memcrypt_encrypt_data) {
-        return kvm_state->memcrypt_encrypt_data(kvm_state->memcrypt_handle,
-                                              ptr, len);
-    }
-
-    return 1;
-}
-
 /* Called with KVMMemoryListener.slots_lock held */
 static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
 {
@@ -2206,13 +2182,10 @@ static int kvm_init(MachineState *ms)
      * encryption context.
      */
     if (ms->memory_encryption) {
-        kvm_state->memcrypt_handle = sev_guest_init(ms->memory_encryption);
-        if (!kvm_state->memcrypt_handle) {
-            ret = -1;
+        ret = sev_guest_init(ms->memory_encryption);
+        if (ret < 0) {
             goto err;
         }
-
-        kvm_state->memcrypt_encrypt_data = sev_encrypt_data;
     }
 
     ret = kvm_arch_init(ms, s);
diff --git a/accel/kvm/sev-stub.c b/accel/kvm/sev-stub.c
index 4f97452585..5db9ab8f00 100644
--- a/accel/kvm/sev-stub.c
+++ b/accel/kvm/sev-stub.c
@@ -15,12 +15,7 @@
 #include "qemu-common.h"
 #include "sysemu/sev.h"
 
-int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
+int sev_guest_init(const char *id)
 {
-    abort();
-}
-
-void *sev_guest_init(const char *id)
-{
-    return NULL;
+    return -1;
 }
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
index 92e90ff013..11172214f1 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -38,6 +38,7 @@
 #include "sysemu/sysemu.h"
 #include "hw/block/flash.h"
 #include "sysemu/kvm.h"
+#include "sysemu/sev.h"
 
 #define FLASH_SECTOR_SIZE 4096
 
@@ -147,7 +148,7 @@ static void pc_system_flash_map(PCMachineState *pcms,
     PFlashCFI01 *system_flash;
     MemoryRegion *flash_mem;
     void *flash_ptr;
-    int ret, flash_size;
+    int flash_size;
 
     assert(PC_MACHINE_GET_CLASS(pcms)->pci_enabled);
 
@@ -191,16 +192,10 @@ static void pc_system_flash_map(PCMachineState *pcms,
             flash_mem = pflash_cfi01_get_memory(system_flash);
             pc_isa_bios_init(rom_memory, flash_mem, size);
 
-            /* Encrypt the pflash boot ROM */
-            if (kvm_memcrypt_enabled()) {
-                flash_ptr = memory_region_get_ram_ptr(flash_mem);
-                flash_size = memory_region_size(flash_mem);
-                ret = kvm_memcrypt_encrypt_data(flash_ptr, flash_size);
-                if (ret) {
-                    error_report("failed to encrypt pflash rom");
-                    exit(1);
-                }
-            }
+            /* Encrypt the pflash boot ROM, if necessary */
+            flash_ptr = memory_region_get_ram_ptr(flash_mem);
+            flash_size = memory_region_size(flash_mem);
+            sev_encrypt_flash(flash_ptr, flash_size, &error_fatal);
         }
     }
 }
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index bb5d5cf497..11cf0b875d 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -233,22 +233,6 @@ int kvm_has_intx_set_mask(void);
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
 
 #ifdef NEED_CPU_H
 #include "cpu.h"
diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
index 7ab6e3e31d..7335e59867 100644
--- a/include/sysemu/sev.h
+++ b/include/sysemu/sev.h
@@ -16,8 +16,8 @@
 
 #include "sysemu/kvm.h"
 
-void *sev_guest_init(const char *id);
-int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len);
+int sev_guest_init(const char *id);
+int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
 int sev_inject_launch_secret(const char *hdr, const char *secret,
                              uint64_t gpa, Error **errp);
 #endif
diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index c1fecc2101..1ac1fd5b94 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -54,3 +54,8 @@ int sev_inject_launch_secret(const char *hdr, const char *secret,
 {
     return 1;
 }
+
+int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
+{
+    return 0;
+}
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 6b49925f51..2a4b2187d6 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -682,7 +682,7 @@ sev_vm_state_change(void *opaque, int running, RunState state)
     }
 }
 
-void *
+int
 sev_guest_init(const char *id)
 {
     SevGuestState *sev;
@@ -695,7 +695,7 @@ sev_guest_init(const char *id)
     ret = ram_block_discard_disable(true);
     if (ret) {
         error_report("%s: cannot disable RAM discard", __func__);
-        return NULL;
+        return -1;
     }
 
     sev = lookup_sev_guest_info(id);
@@ -766,23 +766,27 @@ sev_guest_init(const char *id)
     qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
 
-    return sev;
+    return 0;
 err:
     sev_guest = NULL;
     ram_block_discard_disable(false);
-    return NULL;
+    return -1;
 }
 
 int
-sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
+sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
 {
-    SevGuestState *sev = handle;
-
-    assert(sev);
+    if (!sev_guest) {
+        return 0;
+    }
 
     /* if SEV is in update state then encrypt the data else do nothing */
-    if (sev_check_state(sev, SEV_STATE_LAUNCH_UPDATE)) {
-        return sev_launch_update_data(sev, ptr, len);
+    if (sev_check_state(sev_guest, SEV_STATE_LAUNCH_UPDATE)) {
+        int ret = sev_launch_update_data(sev_guest, ptr, len);
+        if (ret < 0) {
+            error_setg(errp, "failed to encrypt pflash rom");
+            return ret;
+        }
     }
 
     return 0;
-- 
2.29.2

