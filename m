Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4777652E57
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 10:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbiLUJR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 04:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbiLUJRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 04:17:25 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B658659B
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 01:17:22 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id i7so14253399wrv.8
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 01:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U5gesIE8UAIuVUKf8+/lZC1j3rlzn36FnhUs2jVaVHI=;
        b=OS+Dm1Q/z2HHG0djp05nScH7ptHc2AZwlbMy9r15XqFwEBI2Pq+tjys0nWvqsY2UzL
         zsd4/miTNCOTDKVI4UIwahZ7LH73h9PQYkrWp698adh2R5rhD1m+f8iEvweEEJ3K8Aue
         EEeF1A8HJ+VOgi8D+XUZUCbhdpZr6Yn2JJHnvdzpFcKrJviGWQ/I4N9eb7Xrksa0q+ei
         +flILQwdUsTcOKPcEs4LmOzf42TQMT86QKW+J1LxvkSpZQb3VTuKOVBUDN+C+ZRrcxNM
         F9Q4za2LOarh+sAWWy2/oM06go2+klnhkcbm3CceElC2BO4HZiDhhqigo7gTirrN7MWE
         Z8Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U5gesIE8UAIuVUKf8+/lZC1j3rlzn36FnhUs2jVaVHI=;
        b=a88ROGmJL9C6cW9c/8JHItwzhJ8Ji5Dal5xxHzoHKjv6cMSmCP7++EW6GtIz3mMqRO
         FDLZeKtqMIa7sTBB8JDS5bwYPG+ZSoE1WlqcNfpIiJ7dL6BPenUlb3Jy029H+3OyoEWy
         W62pCgeOZXobp/zmlm9TEJH5NM/0C11eZZtt1ibtdlcNI6e0M8gFSLYtR6sY/bcpsO9a
         1RJGVpsQOTiDaqsPtF7H7cCykR5vzu9Rhk5peTJlppBG2MO6BcxSJGS1n6W+CHEcCQ4J
         fV2XDSHPCDceCbTh/KTchkK4hGFAIzeNWO7dlh+4OcFMSyeRTtQ94ok1JXIPMBUTQX/O
         O70g==
X-Gm-Message-State: AFqh2kpt9A8w5Yyle2YSDwgoMn8PNPwzwx4hbT7Gs7BYYyM/O+yOIZ6g
        +zJsftP2F41c0qrKPnidjuWCUw==
X-Google-Smtp-Source: AMrXdXtv6jEqkdWhxjlxet03akoO0LD2o+57ddhSQuvFR8L8o0qFuYK/cxrVOouFrvc2BL6myjULaQ==
X-Received: by 2002:a05:6000:16c9:b0:242:5f07:35a4 with SMTP id h9-20020a05600016c900b002425f0735a4mr702742wrf.54.1671614240836;
        Wed, 21 Dec 2022 01:17:20 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id bx25-20020a5d5b19000000b00225307f43fbsm14859894wrb.44.2022.12.21.01.17.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Dec 2022 01:17:20 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2] MIPS: remove support for trap and emulate KVM
Date:   Wed, 21 Dec 2022 10:17:18 +0100
Message-Id: <20221221091718.71844-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

This support was limited to the Malta board, drop it.
I do not have a machine that can run VZ KVM, so I am assuming
that it works for -M malta as well.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
Since Paolo's v1:

- Remove cpu_mips_kvm_um_phys_to_kseg0() declaration in "cpu.h"
- Remove unused KVM_KSEG0_BASE/KVM_KSEG2_BASE definitions
- Use USEG_LIMIT/KSEG0_BASE instead of magic values

       /* Check where the kernel has been linked */
  -    if (!(kernel_entry & 0x80000000ll)) {
  -        error_report("CONFIG_KVM_GUEST kernels are not supported");
  +    if (kernel_entry <= USEG_LIMIT) {
  +        error_report("Trap-and-Emul kernels (Linux CONFIG_KVM_GUEST)"
  +                     " are not supported");

  -    env->CP0_EBase = (cs->cpu_index & 0x3FF) | (int32_t)0x80000000;
  +    env->CP0_EBase = KSEG0_BASE | (cs->cpu_index & 0x3FF);
---
 docs/about/deprecated.rst       |  9 -------
 docs/about/removed-features.rst |  9 +++++++
 hw/mips/malta.c                 | 46 +++++----------------------------
 target/mips/cpu.c               |  7 +----
 target/mips/cpu.h               |  3 ---
 target/mips/internal.h          |  3 ---
 target/mips/kvm.c               | 11 +-------
 target/mips/sysemu/addr.c       | 17 ------------
 target/mips/sysemu/physaddr.c   | 13 ----------
 9 files changed, 18 insertions(+), 100 deletions(-)

diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
index 93affe3669..b28f50b22f 100644
--- a/docs/about/deprecated.rst
+++ b/docs/about/deprecated.rst
@@ -199,15 +199,6 @@ deprecated.  Use ``sections`` instead.
 Member ``section-size`` in return value elements with meta-type ``uint64`` is
 deprecated.  Use ``sections`` instead.
 
-System accelerators
--------------------
-
-MIPS ``Trap-and-Emul`` KVM support (since 6.0)
-''''''''''''''''''''''''''''''''''''''''''''''
-
-The MIPS ``Trap-and-Emul`` KVM host and guest support has been removed
-from Linux upstream kernel, declare it deprecated.
-
 Host Architectures
 ------------------
 
diff --git a/docs/about/removed-features.rst b/docs/about/removed-features.rst
index 63df9848fd..22b4b5d128 100644
--- a/docs/about/removed-features.rst
+++ b/docs/about/removed-features.rst
@@ -617,6 +617,15 @@ x86 ``Icelake-Client`` CPU (removed in 7.1)
 There isn't ever Icelake Client CPU, it is some wrong and imaginary one.
 Use ``Icelake-Server`` instead.
 
+System accelerators
+-------------------
+
+MIPS "Trap-and-Emulate" KVM support (removed in 8.0)
+''''''''''''''''''''''''''''''''''''''''''''''''''''
+
+The MIPS "Trap-and-Emulate" KVM host and guest support was removed
+from Linux in 2021, and is not supported anymore by QEMU either.
+
 System emulator machines
 ------------------------
 
diff --git a/hw/mips/malta.c b/hw/mips/malta.c
index e5050ecd3c..fed8b65f1e 100644
--- a/hw/mips/malta.c
+++ b/hw/mips/malta.c
@@ -58,6 +58,7 @@
 #include "semihosting/semihost.h"
 #include "hw/mips/cps.h"
 #include "hw/qdev-clock.h"
+#include "target/mips/internal.h"
 
 #define ENVP_PADDR          0x2000
 #define ENVP_VADDR          cpu_mips_phys_to_kseg0(NULL, ENVP_PADDR)
@@ -870,7 +871,6 @@ static uint64_t load_kernel(void)
     uint32_t *prom_buf;
     long prom_size;
     int prom_index = 0;
-    uint64_t (*xlate_to_kseg0) (void *opaque, uint64_t addr);
     uint8_t rng_seed[32];
     char rng_seed_hex[sizeof(rng_seed) * 2 + 1];
     size_t rng_seed_prom_offset;
@@ -894,19 +894,10 @@ static uint64_t load_kernel(void)
     }
 
     /* Check where the kernel has been linked */
-    if (kernel_entry & 0x80000000ll) {
-        if (kvm_enabled()) {
-            error_report("KVM guest kernels must be linked in useg. "
-                         "Did you forget to enable CONFIG_KVM_GUEST?");
-            exit(1);
-        }
-
-        xlate_to_kseg0 = cpu_mips_phys_to_kseg0;
-    } else {
-        /* if kernel entry is in useg it is probably a KVM T&E kernel */
-        mips_um_ksegs_enable();
-
-        xlate_to_kseg0 = cpu_mips_kvm_um_phys_to_kseg0;
+    if (kernel_entry <= USEG_LIMIT) {
+        error_report("Trap-and-Emul kernels (Linux CONFIG_KVM_GUEST)"
+                     " are not supported");
+        exit(1);
     }
 
     /* load initrd */
@@ -947,7 +938,7 @@ static uint64_t load_kernel(void)
     if (initrd_size > 0) {
         prom_set(prom_buf, prom_index++,
                  "rd_start=0x%" PRIx64 " rd_size=%" PRId64 " %s",
-                 xlate_to_kseg0(NULL, initrd_offset),
+                 cpu_mips_phys_to_kseg0(NULL, initrd_offset),
                  initrd_size, loaderparams.kernel_cmdline);
     } else {
         prom_set(prom_buf, prom_index++, "%s", loaderparams.kernel_cmdline);
@@ -1039,11 +1030,6 @@ static void main_cpu_reset(void *opaque)
     }
 
     malta_mips_config(cpu);
-
-    if (kvm_enabled()) {
-        /* Start running from the bootloader we wrote to end of RAM */
-        env->active_tc.PC = 0x40000000 + loaderparams.ram_low_size;
-    }
 }
 
 static void create_cpu_without_cps(MachineState *ms, MaltaState *s,
@@ -1177,13 +1163,7 @@ void mips_malta_init(MachineState *machine)
     fl_idx++;
     if (kernel_filename) {
         ram_low_size = MIN(ram_size, 256 * MiB);
-        /* For KVM we reserve 1MB of RAM for running bootloader */
-        if (kvm_enabled()) {
-            ram_low_size -= 0x100000;
-            bootloader_run_addr = cpu_mips_kvm_um_phys_to_kseg0(NULL, ram_low_size);
-        } else {
-            bootloader_run_addr = cpu_mips_phys_to_kseg0(NULL, RESET_ADDRESS);
-        }
+        bootloader_run_addr = cpu_mips_phys_to_kseg0(NULL, RESET_ADDRESS);
 
         /* Write a small bootloader to the flash location. */
         loaderparams.ram_size = ram_size;
@@ -1200,20 +1180,8 @@ void mips_malta_init(MachineState *machine)
             write_bootloader_nanomips(memory_region_get_ram_ptr(bios),
                                       bootloader_run_addr, kernel_entry);
         }
-        if (kvm_enabled()) {
-            /* Write the bootloader code @ the end of RAM, 1MB reserved */
-            write_bootloader(memory_region_get_ram_ptr(ram_low_preio) +
-                                    ram_low_size,
-                             bootloader_run_addr, kernel_entry);
-        }
     } else {
         target_long bios_size = FLASH_SIZE;
-        /* The flash region isn't executable from a KVM guest */
-        if (kvm_enabled()) {
-            error_report("KVM enabled but no -kernel argument was specified. "
-                         "Booting from flash is not supported with KVM.");
-            exit(1);
-        }
         /* Load firmware from flash. */
         if (!dinfo) {
             /* Load a BIOS image. */
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 17bbcbf5ff..f8c8e0ba39 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -291,12 +291,7 @@ static void mips_cpu_reset_hold(Object *obj)
     env->tlb->tlb_in_use = env->tlb->nb_tlb;
     env->CP0_Wired = 0;
     env->CP0_GlobalNumber = (cs->cpu_index & 0xFF) << CP0GN_VPId;
-    env->CP0_EBase = (cs->cpu_index & 0x3FF);
-    if (mips_um_ksegs_enabled()) {
-        env->CP0_EBase |= 0x40000000;
-    } else {
-        env->CP0_EBase |= (int32_t)0x80000000;
-    }
+    env->CP0_EBase = KSEG0_BASE | (cs->cpu_index & 0x3FF);
     if (env->CP0_Config3 & (1 << CP0C3_CMGCR)) {
         env->CP0_CMGCRBase = 0x1fbf8000 >> 4;
     }
diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 0a085643a3..caf2b06911 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1296,11 +1296,8 @@ void cpu_set_exception_base(int vp_index, target_ulong address);
 uint64_t cpu_mips_kseg0_to_phys(void *opaque, uint64_t addr);
 uint64_t cpu_mips_phys_to_kseg0(void *opaque, uint64_t addr);
 
-uint64_t cpu_mips_kvm_um_phys_to_kseg0(void *opaque, uint64_t addr);
 uint64_t cpu_mips_kseg1_to_phys(void *opaque, uint64_t addr);
 uint64_t cpu_mips_phys_to_kseg1(void *opaque, uint64_t addr);
-bool mips_um_ksegs_enabled(void);
-void mips_um_ksegs_enable(void);
 
 #if !defined(CONFIG_USER_ONLY)
 
diff --git a/target/mips/internal.h b/target/mips/internal.h
index 57b312689a..4b0031d10d 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -99,9 +99,6 @@ int mips_cpu_gdb_write_register(CPUState *cpu, uint8_t *buf, int reg);
 #define KSEG2_BASE      ((target_ulong)(int32_t)0xC0000000UL)
 #define KSEG3_BASE      ((target_ulong)(int32_t)0xE0000000UL)
 
-#define KVM_KSEG0_BASE  ((target_ulong)(int32_t)0x40000000UL)
-#define KVM_KSEG2_BASE  ((target_ulong)(int32_t)0x60000000UL)
-
 #if !defined(CONFIG_USER_ONLY)
 
 enum {
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index bcb8e06b2c..c14e8f550f 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -1268,25 +1268,16 @@ int kvm_arch_msi_data_to_gsi(uint32_t data)
 
 int mips_kvm_type(MachineState *machine, const char *vm_type)
 {
-#if defined(KVM_CAP_MIPS_VZ) || defined(KVM_CAP_MIPS_TE)
+#if defined(KVM_CAP_MIPS_VZ)
     int r;
     KVMState *s = KVM_STATE(machine->accelerator);
-#endif
 
-#if defined(KVM_CAP_MIPS_VZ)
     r = kvm_check_extension(s, KVM_CAP_MIPS_VZ);
     if (r > 0) {
         return KVM_VM_MIPS_VZ;
     }
 #endif
 
-#if defined(KVM_CAP_MIPS_TE)
-    r = kvm_check_extension(s, KVM_CAP_MIPS_TE);
-    if (r > 0) {
-        return KVM_VM_MIPS_TE;
-    }
-#endif
-
     return -1;
 }
 
diff --git a/target/mips/sysemu/addr.c b/target/mips/sysemu/addr.c
index 86f1c129c9..4f025be44a 100644
--- a/target/mips/sysemu/addr.c
+++ b/target/mips/sysemu/addr.c
@@ -23,8 +23,6 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 
-static int mips_um_ksegs;
-
 uint64_t cpu_mips_kseg0_to_phys(void *opaque, uint64_t addr)
 {
     return addr & 0x1fffffffll;
@@ -35,11 +33,6 @@ uint64_t cpu_mips_phys_to_kseg0(void *opaque, uint64_t addr)
     return addr | ~0x7fffffffll;
 }
 
-uint64_t cpu_mips_kvm_um_phys_to_kseg0(void *opaque, uint64_t addr)
-{
-    return addr | 0x40000000ll;
-}
-
 uint64_t cpu_mips_kseg1_to_phys(void *opaque, uint64_t addr)
 {
     return addr & 0x1fffffffll;
@@ -49,13 +42,3 @@ uint64_t cpu_mips_phys_to_kseg1(void *opaque, uint64_t addr)
 {
     return (addr & 0x1fffffffll) | 0xffffffffa0000000ll;
 }
-
-bool mips_um_ksegs_enabled(void)
-{
-    return mips_um_ksegs;
-}
-
-void mips_um_ksegs_enable(void)
-{
-    mips_um_ksegs = 1;
-}
diff --git a/target/mips/sysemu/physaddr.c b/target/mips/sysemu/physaddr.c
index 1918633aa1..2970df8a09 100644
--- a/target/mips/sysemu/physaddr.c
+++ b/target/mips/sysemu/physaddr.c
@@ -130,19 +130,6 @@ int get_physical_address(CPUMIPSState *env, hwaddr *physical,
     /* effective address (modified for KVM T&E kernel segments) */
     target_ulong address = real_address;
 
-    if (mips_um_ksegs_enabled()) {
-        /* KVM T&E adds guest kernel segments in useg */
-        if (real_address >= KVM_KSEG0_BASE) {
-            if (real_address < KVM_KSEG2_BASE) {
-                /* kseg0 */
-                address += KSEG0_BASE - KVM_KSEG0_BASE;
-            } else if (real_address <= USEG_LIMIT) {
-                /* kseg2/3 */
-                address += KSEG2_BASE - KVM_KSEG2_BASE;
-            }
-        }
-    }
-
     if (address <= USEG_LIMIT) {
         /* useg */
         uint16_t segctl;
-- 
2.38.1

