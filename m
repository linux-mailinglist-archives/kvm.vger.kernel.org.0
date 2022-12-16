Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D0064F3BE
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 23:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiLPWKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 17:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiLPWKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 17:10:00 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16748192B1
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 14:09:58 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id vv4so9354321ejc.2
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 14:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hMhMRrfCiDM1fa0HiJyQk7ZTpXu21fxE4Buljrx0cVk=;
        b=DGLIfMzFgbhCx8U0gJrnLdVfr6vNqJCmLKwwCgB/06+RjJ9EESzom6iuwGgZ2o9/14
         osuE1WRoEHQu5Dh12YDE5HQ+barQFHzPHyO4/l8QPyZaKK77fHJ+vTOTm8wpkiGacuLO
         BlmDKiwIWHUvNeYSu8Um/BHC44CmHP6wYhBlwsiYa+5PHfemAF6zQknYV6YIQaQPaHKh
         p2Dh6KPAYwSIt7318nhrD6hOgNMwEV6Cq0dLRWiMZ9doy4AdmoelCTY4HSrneWZrqmew
         eAAi92v+8//SYf/sihDMqYO8B/mx2LyRfM+N/+r0EaNbWx1OWSdg1ppTqA7oMjCM4z5q
         s9Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hMhMRrfCiDM1fa0HiJyQk7ZTpXu21fxE4Buljrx0cVk=;
        b=0DFxu40u27zdJE8iL+4daI69j/xHiSl927tqkY3SR0BurUEaRWwTvX7cnMiKbAmVs2
         iktHF7SyaykpZnejRJFZtFVTmoafMtOZy4XPGQVlT+a1tP7TrkzSVQ/b4Zy1ChQHs+4/
         v4HYnIacW7JEWzZapqolwrA8xvrOUz61AEtsJoleV64QEqtUb0AmfMyqhRY+qT9GBMpY
         1v5p5Zmv/AxUTfCAEBl0OvCHqjb0SymmJ3XjvVA7lnlM2PsS/liY+2p2yC2C7YyVI5AS
         yZ/ujTSHsMhrtO+mbYew7gpeO2UIfjr0CNQcgSQDnVyXgGb9j43AHpqqdpXS9h13yU0g
         xWNA==
X-Gm-Message-State: ANoB5pnAmLjsrFpBhvis6+Lfo5GeI1g6oPxspmoioDlDlRA3W0QIplO+
        eHC8w+8JchSqXlulkYA/TfdqYQ==
X-Google-Smtp-Source: AA0mqf4a7Q3VCzE8QqtlWCGCn+zcencuGtFvSPP8yFnBq4T2GBvrcWHojWn9FkNcy2XZwJiMkC/WkA==
X-Received: by 2002:a17:906:434f:b0:7ae:7ea:c76b with SMTP id z15-20020a170906434f00b007ae07eac76bmr18674080ejm.32.1671228596623;
        Fri, 16 Dec 2022 14:09:56 -0800 (PST)
Received: from localhost.localdomain ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id q13-20020a1709064c8d00b007c0c91eae04sm1296517eju.151.2022.12.16.14.09.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Dec 2022 14:09:56 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        xen-devel@lists.xenproject.org,
        Anthony Perard <anthony.perard@citrix.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        haxm-team@intel.com,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        Wenchao Wang <wenchao.wang@intel.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, qemu-arm@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cameron Esfahani <dirty@apple.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PATCH] exec: Rename NEED_CPU_H -> CONFIG_TARGET
Date:   Fri, 16 Dec 2022 23:09:51 +0100
Message-Id: <20221216220951.7597-1-philmd@linaro.org>
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

'NEED_CPU_H' guard target-specific code; it is defined by meson
altogether with the 'CONFIG_TARGET' definition. Since the latter
name is more meaningful, directly use it.

Inspired-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
Based-on: <20221216220738.7355-1-philmd@linaro.org>
  sysemu/kvm: Header cleanups around "cpu.h"
Based-on: <20221216220158.6317-1-philmd@linaro.org>
  target/i386: Header cleanups around "cpu.h"
---
 include/disas/disas.h         | 2 +-
 include/exec/cpu-defs.h       | 2 +-
 include/exec/gdbstub.h        | 4 ++--
 include/exec/helper-head.h    | 4 ++--
 include/exec/memop.h          | 6 +++---
 include/exec/memory.h         | 4 ++--
 include/hw/core/cpu.h         | 4 ++--
 include/hw/core/tcg-cpu-ops.h | 4 ++--
 include/qemu/osdep.h          | 4 ++--
 include/sysemu/hax.h          | 4 ++--
 include/sysemu/hvf.h          | 4 ++--
 include/sysemu/kvm.h          | 8 ++++----
 include/sysemu/nvmm.h         | 4 ++--
 include/sysemu/whpx.h         | 4 ++--
 include/sysemu/xen.h          | 4 ++--
 meson.build                   | 6 ++----
 scripts/analyze-inclusions    | 6 +++---
 target/arm/kvm-consts.h       | 2 +-
 18 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/include/disas/disas.h b/include/disas/disas.h
index d363e95ede..1f6706a374 100644
--- a/include/disas/disas.h
+++ b/include/disas/disas.h
@@ -3,7 +3,7 @@
 
 #include "exec/hwaddr.h"
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 #include "cpu.h"
 
 /* Disassemble this for me please... (debugging). */
diff --git a/include/exec/cpu-defs.h b/include/exec/cpu-defs.h
index 21309cf567..9775634ff6 100644
--- a/include/exec/cpu-defs.h
+++ b/include/exec/cpu-defs.h
@@ -19,7 +19,7 @@
 #ifndef CPU_DEFS_H
 #define CPU_DEFS_H
 
-#ifndef NEED_CPU_H
+#ifndef CONFIG_TARGET
 #error cpu.h included from common code
 #endif
 
diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
index f667014888..49f63d3c50 100644
--- a/include/exec/gdbstub.h
+++ b/include/exec/gdbstub.h
@@ -71,7 +71,7 @@ struct gdb_timeval {
   uint64_t tv_usec;   /* microsecond */
 } QEMU_PACKED;
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 #include "cpu.h"
 
 typedef void (*gdb_syscall_complete_cb)(CPUState *cpu, uint64_t ret, int err);
@@ -214,7 +214,7 @@ static inline uint8_t * gdb_get_reg_ptr(GByteArray *buf, int len)
 #define ldtul_p(addr) ldl_p(addr)
 #endif
 
-#endif /* NEED_CPU_H */
+#endif /* CONFIG_TARGET */
 
 /**
  * gdbserver_start: start the gdb server
diff --git a/include/exec/helper-head.h b/include/exec/helper-head.h
index e242fed46e..584b120312 100644
--- a/include/exec/helper-head.h
+++ b/include/exec/helper-head.h
@@ -49,7 +49,7 @@
 #define dh_ctype_noreturn G_NORETURN void
 #define dh_ctype(t) dh_ctype_##t
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 # ifdef TARGET_LONG_BITS
 #  if TARGET_LONG_BITS == 32
 #   define dh_alias_tl i32
@@ -63,7 +63,7 @@
 # define dh_alias_env ptr
 # define dh_ctype_env CPUArchState *
 # define dh_typecode_env dh_typecode_ptr
-#endif
+#endif /* CONFIG_TARGET */
 
 /* We can't use glue() here because it falls foul of C preprocessor
    recursive expansion rules.  */
diff --git a/include/exec/memop.h b/include/exec/memop.h
index 25d027434a..ebf6c5f69d 100644
--- a/include/exec/memop.h
+++ b/include/exec/memop.h
@@ -35,7 +35,7 @@ typedef enum MemOp {
     MO_LE    = 0,
     MO_BE    = MO_BSWAP,
 #endif
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 #if TARGET_BIG_ENDIAN
     MO_TE    = MO_BE,
 #else
@@ -65,7 +65,7 @@ typedef enum MemOp {
      */
     MO_ASHIFT = 5,
     MO_AMASK = 0x7 << MO_ASHIFT,
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 #ifdef TARGET_ALIGNED_ONLY
     MO_ALIGN = 0,
     MO_UNALN = MO_AMASK,
@@ -107,7 +107,7 @@ typedef enum MemOp {
     MO_BESL  = MO_BE | MO_SL,
     MO_BESQ  = MO_BE | MO_SQ,
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
     MO_TEUW  = MO_TE | MO_UW,
     MO_TEUL  = MO_TE | MO_UL,
     MO_TEUQ  = MO_TE | MO_UQ,
diff --git a/include/exec/memory.h b/include/exec/memory.h
index c37ffdbcd1..2d1fd6e475 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -2938,7 +2938,7 @@ address_space_write_cached(MemoryRegionCache *cache, hwaddr addr,
 MemTxResult address_space_set(AddressSpace *as, hwaddr addr,
                               uint8_t c, hwaddr len, MemTxAttrs attrs);
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 /* enum device_endian to MemOp.  */
 static inline MemOp devend_memop(enum device_endian end)
 {
@@ -2956,7 +2956,7 @@ static inline MemOp devend_memop(enum device_endian end)
     return (end == non_host_endianness) ? MO_BSWAP : 0;
 #endif
 }
-#endif
+#endif /* CONFIG_TARGET */
 
 /*
  * Inhibit technologies that require discarding of pages in RAM blocks, e.g.,
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index bc3229ae13..5ab6244bc8 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -1044,7 +1044,7 @@ bool target_words_bigendian(void);
 
 void page_size_init(void);
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 
 #ifdef CONFIG_SOFTMMU
 
@@ -1059,7 +1059,7 @@ extern const VMStateDescription vmstate_cpu_common;
 }
 #endif /* CONFIG_SOFTMMU */
 
-#endif /* NEED_CPU_H */
+#endif /* CONFIG_TARGET */
 
 #define UNASSIGNED_CPU_INDEX -1
 #define UNASSIGNED_CLUSTER_INDEX -1
diff --git a/include/hw/core/tcg-cpu-ops.h b/include/hw/core/tcg-cpu-ops.h
index 20e3c0ffbb..3cd9b5718a 100644
--- a/include/hw/core/tcg-cpu-ops.h
+++ b/include/hw/core/tcg-cpu-ops.h
@@ -49,7 +49,7 @@ struct TCGCPUOps {
     /** @debug_excp_handler: Callback for handling debug exceptions */
     void (*debug_excp_handler)(CPUState *cpu);
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 #if defined(CONFIG_USER_ONLY) && defined(TARGET_I386)
     /**
      * @fake_user_interrupt: Callback for 'fake exception' handling.
@@ -171,7 +171,7 @@ struct TCGCPUOps {
     void (*record_sigbus)(CPUState *cpu, vaddr addr,
                           MMUAccessType access_type, uintptr_t ra);
 #endif /* CONFIG_SOFTMMU */
-#endif /* NEED_CPU_H */
+#endif /* CONFIG_TARGET */
 
 };
 
diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index b9c4307779..d5eccf1a97 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -28,11 +28,11 @@
 #define QEMU_OSDEP_H
 
 #include "config-host.h"
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 #include CONFIG_TARGET
 #else
 #include "exec/poison.h"
-#endif
+#endif /* CONFIG_TARGET */
 
 /*
  * HOST_WORDS_BIGENDIAN was replaced with HOST_BIG_ENDIAN. Prevent it from
diff --git a/include/sysemu/hax.h b/include/sysemu/hax.h
index bf8f99a824..90994e2773 100644
--- a/include/sysemu/hax.h
+++ b/include/sysemu/hax.h
@@ -24,11 +24,11 @@
 
 int hax_sync_vcpus(void);
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 # ifdef CONFIG_HAX
 #  define CONFIG_HAX_IS_POSSIBLE
 # endif
-#else /* !NEED_CPU_H */
+#else /* !CONFIG_TARGET */
 # define CONFIG_HAX_IS_POSSIBLE
 #endif
 
diff --git a/include/sysemu/hvf.h b/include/sysemu/hvf.h
index bb70082e45..6873193ebd 100644
--- a/include/sysemu/hvf.h
+++ b/include/sysemu/hvf.h
@@ -16,7 +16,7 @@
 #include "qemu/accel.h"
 #include "qom/object.h"
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 
 #ifdef CONFIG_HVF
 uint32_t hvf_get_supported_cpuid(uint32_t func, uint32_t idx,
@@ -28,7 +28,7 @@ extern bool hvf_allowed;
 #define hvf_get_supported_cpuid(func, idx, reg) 0
 #endif /* !CONFIG_HVF */
 
-#endif /* NEED_CPU_H */
+#endif /* CONFIG_TARGET */
 
 #define TYPE_HVF_ACCEL ACCEL_CLASS_NAME("hvf")
 
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index a53d6dab49..9e85db41ca 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -20,14 +20,14 @@
 #include "qemu/accel.h"
 #include "qom/object.h"
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 # ifdef CONFIG_KVM
 #  include <linux/kvm.h>
 #  define CONFIG_KVM_IS_POSSIBLE
 # endif
 #else
 # define CONFIG_KVM_IS_POSSIBLE
-#endif
+#endif /* CONFIG_TARGET */
 
 #ifdef CONFIG_KVM_IS_POSSIBLE
 
@@ -407,7 +407,7 @@ void kvm_get_apic_state(DeviceState *d, struct kvm_lapic_state *kapic);
 struct kvm_guest_debug;
 struct kvm_debug_exit_arch;
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 #include "cpu.h"
 
 struct kvm_sw_breakpoint {
@@ -443,7 +443,7 @@ uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index);
 int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
                                        hwaddr *phys_addr);
 
-#endif /* NEED_CPU_H */
+#endif /* CONFIG_TARGET */
 
 int kvm_check_extension(KVMState *s, unsigned int extension);
 
diff --git a/include/sysemu/nvmm.h b/include/sysemu/nvmm.h
index 833670fccb..bfd97729cf 100644
--- a/include/sysemu/nvmm.h
+++ b/include/sysemu/nvmm.h
@@ -10,7 +10,7 @@
 #ifndef QEMU_NVMM_H
 #define QEMU_NVMM_H
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 
 #ifdef CONFIG_NVMM
 
@@ -22,6 +22,6 @@ int nvmm_enabled(void);
 
 #endif /* CONFIG_NVMM */
 
-#endif /* NEED_CPU_H */
+#endif /* CONFIG_TARGET */
 
 #endif /* QEMU_NVMM_H */
diff --git a/include/sysemu/whpx.h b/include/sysemu/whpx.h
index 2889fa2278..452377a81e 100644
--- a/include/sysemu/whpx.h
+++ b/include/sysemu/whpx.h
@@ -13,7 +13,7 @@
 #ifndef QEMU_WHPX_H
 #define QEMU_WHPX_H
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 
 #ifdef CONFIG_WHPX
 
@@ -27,6 +27,6 @@ bool whpx_apic_in_platform(void);
 
 #endif /* CONFIG_WHPX */
 
-#endif /* NEED_CPU_H */
+#endif /* CONFIG_TARGET */
 
 #endif /* QEMU_WHPX_H */
diff --git a/include/sysemu/xen.h b/include/sysemu/xen.h
index 0ca25697e4..72483dd584 100644
--- a/include/sysemu/xen.h
+++ b/include/sysemu/xen.h
@@ -10,13 +10,13 @@
 
 #include "exec/cpu-common.h"
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 # ifdef CONFIG_XEN
 #  define CONFIG_XEN_IS_POSSIBLE
 # endif
 #else
 # define CONFIG_XEN_IS_POSSIBLE
-#endif
+#endif /* CONFIG_TARGET */
 
 #ifdef CONFIG_XEN_IS_POSSIBLE
 
diff --git a/meson.build b/meson.build
index 5c6b5a1c75..2fe437d54d 100644
--- a/meson.build
+++ b/meson.build
@@ -3204,8 +3204,7 @@ foreach d, list : target_modules
           config_target = config_target_mak[target]
           config_target += config_host
           target_inc = [include_directories('target' / config_target['TARGET_BASE_ARCH'])]
-          c_args = ['-DNEED_CPU_H',
-                    '-DCONFIG_TARGET="@0@-config-target.h"'.format(target),
+          c_args = ['-DCONFIG_TARGET="@0@-config-target.h"'.format(target),
                     '-DCONFIG_DEVICES="@0@-config-devices.h"'.format(target)]
           target_module_ss = module_ss.apply(config_target, strict: false)
           if target_module_ss.sources() != []
@@ -3384,8 +3383,7 @@ foreach target : target_dirs
   target_base_arch = config_target['TARGET_BASE_ARCH']
   arch_srcs = [config_target_h[target]]
   arch_deps = []
-  c_args = ['-DNEED_CPU_H',
-            '-DCONFIG_TARGET="@0@-config-target.h"'.format(target),
+  c_args = ['-DCONFIG_TARGET="@0@-config-target.h"'.format(target),
             '-DCONFIG_DEVICES="@0@-config-devices.h"'.format(target)]
   link_args = emulator_link_args
 
diff --git a/scripts/analyze-inclusions b/scripts/analyze-inclusions
index 45c821de32..67d19bc00d 100644
--- a/scripts/analyze-inclusions
+++ b/scripts/analyze-inclusions
@@ -92,7 +92,7 @@ echo trace/generated-tracers.h:
 analyze -include ../include/qemu/osdep.h trace/generated-tracers.h
 
 echo target/i386/cpu.h:
-analyze -DNEED_CPU_H -I../target/i386 -Ii386-softmmu -include ../include/qemu/osdep.h ../target/i386/cpu.h
+analyze -DCONFIG_TARGET -I../target/i386 -Ii386-softmmu -include ../include/qemu/osdep.h ../target/i386/cpu.h
 
-echo hw/hw.h + NEED_CPU_H:
-analyze -DNEED_CPU_H -I../target/i386 -Ii386-softmmu -include ../include/qemu/osdep.h ../include/hw/hw.h
+echo hw/hw.h + CONFIG_TARGET:
+analyze -DCONFIG_TARGET -I../target/i386 -Ii386-softmmu -include ../include/qemu/osdep.h ../include/hw/hw.h
diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index 09967ec5e6..690d32ff2b 100644
--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -14,7 +14,7 @@
 #ifndef ARM_KVM_CONSTS_H
 #define ARM_KVM_CONSTS_H
 
-#ifdef NEED_CPU_H
+#ifdef CONFIG_TARGET
 #ifdef CONFIG_KVM
 #include <linux/kvm.h>
 #include <linux/psci.h>
-- 
2.38.1

