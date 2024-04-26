Return-Path: <kvm+bounces-16077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 147118B4035
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 21:42:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 382241C217B0
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8354A1CFA9;
	Fri, 26 Apr 2024 19:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cgeIewuA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E2A1BC31
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 19:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714160534; cv=none; b=SPKTDwBW/fbhrp2/MsfJROTSMbP1UpWndsrjfppE7VWQWVtXdrcHGWJ4IDzpZyGQI8fLiWEHLAmtc+aTuvjMKQMY7JJweipzm0hgz7yHqPGLZruQRZ+d4AFowCWzVfYXU+WCC/JpS2Jv8QtTtVtdzKBr0r2ZEXkKZEMzMey1ZVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714160534; c=relaxed/simple;
	bh=G5HQj60dasV7RHNCCm2kbH9wLGP/Vw9wXbkjmye0K+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bIwV8Ofc7GOeGbgblWcU6TPsOSN+NbL7wu1luwa2Zcl2H0BTJyMDXDSZjpDO6L3bxr8hrJRgIgWMNu3KKC8T7WvfC4Awu1NAyZEu0jdDsK0H1EBu2tK1ossrC0J6MBurF3WtiYIWj43YO0p2bjH1E7pI1TJTbTlSoBnpA5EY80w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cgeIewuA; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-51bae805c56so2913403e87.0
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 12:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714160531; x=1714765331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ye55WMDRK5S6l5M0zWgNVrTpOE29KI1trvIKq0uwte4=;
        b=cgeIewuAmYK8Q8FyDcP911XwL8v9EFiMDJu+NFzBasD/cjnnV3eTsg3E5gslxus6EG
         ugawMbHPK8RBejxwbxYLVcCJUXMdqdMVEP9P7JClkX98tGOTL1daJAUhw2H6Qlm/NXhU
         4LMvJlzxsEI02OcVPS7zvoCKlEUjIc1Qmnl9WZjvqipQ19yXuADq3DseWedqkossklE+
         mDV4X07pAwj9Bmd0yTz5F7LeNwnLig2pjHFSXUUsGGlTpY8hoMXJ2E+NAXg5NtYjNcPc
         TudZaQWOmPYUSdxzKexSevYpQQ36nFsUg+dA/DMvm0yDjbHFsoLFOiQOyFqoDsi7lvx9
         YmzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714160531; x=1714765331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ye55WMDRK5S6l5M0zWgNVrTpOE29KI1trvIKq0uwte4=;
        b=gB8b/rBQsuqtml+VtpOfpmbMVEUpDgISR9ckoVs5RQEgJIb68LZ8BlTWb5dZIQH515
         Q4TWe4UlpDfT4q/aybtbiGnrNn9N02UZFTiszmNJkaHi9v2KumGgvOPXkvlIUo4vzT4g
         Qpv8wIbXj+NlTGfX/pVcCkuNHKmR5275eJsNoXZ7STwf9F4+qnY3DdMP32WG20AroRSn
         NQu7btfo17T5q6U8XKXJy93q2UW/N+mXXfXa2iDP1p+Hc+RX4gno98HczI3tDwLWGrCE
         yZBXvyOqPA3BNKfGHSnrQxe8ZId20MdlmYOWUvNCQUdrXx6MwIduO+Vt+tGeE0D9Xwwu
         nBRA==
X-Forwarded-Encrypted: i=1; AJvYcCWw0368ViG/0YpYyW6crNNVYHHY4ICJ5Haf7O6wc1bDo8GIlHjx70bLbrVS8lPPisT7bxI6EMiMnoISnQ/a428ARpRg
X-Gm-Message-State: AOJu0YziqruFsdPtsPwaO4B7vUZLXqEuv33uFLISFCdW+ATyxGNdGuU1
	I79DMrgJWXUWe++hsP0wlCwLQk8OT61H8UanUVep3EL7H9L7fERd9xjVwcyPbnw=
X-Google-Smtp-Source: AGHT+IFL14ms+GZPBLVOB0MB3rNqmeNW55qsxaKuP7JYpVZQYPUqzQLjW5flfi2FoO61Lw3+u8GCQQ==
X-Received: by 2002:a19:f80b:0:b0:518:bc7c:413a with SMTP id a11-20020a19f80b000000b00518bc7c413amr2135720lff.69.1714160530417;
        Fri, 26 Apr 2024 12:42:10 -0700 (PDT)
Received: from m1x-phil.lan (aul93-h02-176-184-11-147.dsl.sta.abo.bbox.fr. [176.184.11.147])
        by smtp.gmail.com with ESMTPSA id e24-20020a170906081800b00a5891d81009sm3390140ejd.36.2024.04.26.12.42.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Apr 2024 12:42:09 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PULL 01/38] exec: Rename NEED_CPU_H -> COMPILING_PER_TARGET
Date: Fri, 26 Apr 2024 21:41:21 +0200
Message-ID: <20240426194200.43723-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240426194200.43723-1-philmd@linaro.org>
References: <20240426194200.43723-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

'NEED_CPU_H' guard target-specific code; it is defined by meson
altogether with the 'CONFIG_TARGET' definition. Rename NEED_CPU_H
as COMPILING_PER_TARGET to clarify its meaning.

Mechanical change running:

 $ sed -i s/NEED_CPU_H/COMPILING_PER_TARGET/g $(git grep -l NEED_CPU_H)

then manually add a /* COMPILING_PER_TARGET */ comment
after the '#endif' when the block is large.

Inspired-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20240322161439.6448-4-philmd@linaro.org>
---
 meson.build                | 4 ++--
 include/exec/cpu-defs.h    | 2 +-
 include/exec/helper-head.h | 4 ++--
 include/exec/memop.h       | 4 ++--
 include/exec/memory.h      | 4 ++--
 include/exec/tswap.h       | 4 ++--
 include/gdbstub/helpers.h  | 2 +-
 include/hw/core/cpu.h      | 4 ++--
 include/qemu/osdep.h       | 2 +-
 include/sysemu/hvf.h       | 8 ++++----
 include/sysemu/kvm.h       | 6 +++---
 include/sysemu/nvmm.h      | 4 ++--
 include/sysemu/whpx.h      | 4 ++--
 include/sysemu/xen.h       | 4 ++--
 target/arm/kvm-consts.h    | 4 ++--
 scripts/analyze-inclusions | 6 +++---
 16 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/meson.build b/meson.build
index 553b940999..96fdc6dfd2 100644
--- a/meson.build
+++ b/meson.build
@@ -3610,7 +3610,7 @@ foreach d, list : target_modules
         if target.endswith('-softmmu')
           config_target = config_target_mak[target]
           target_inc = [include_directories('target' / config_target['TARGET_BASE_ARCH'])]
-          c_args = ['-DNEED_CPU_H',
+          c_args = ['-DCOMPILING_PER_TARGET',
                     '-DCONFIG_TARGET="@0@-config-target.h"'.format(target),
                     '-DCONFIG_DEVICES="@0@-config-devices.h"'.format(target)]
           target_module_ss = module_ss.apply(config_target, strict: false)
@@ -3793,7 +3793,7 @@ foreach target : target_dirs
   target_base_arch = config_target['TARGET_BASE_ARCH']
   arch_srcs = [config_target_h[target]]
   arch_deps = []
-  c_args = ['-DNEED_CPU_H',
+  c_args = ['-DCOMPILING_PER_TARGET',
             '-DCONFIG_TARGET="@0@-config-target.h"'.format(target),
             '-DCONFIG_DEVICES="@0@-config-devices.h"'.format(target)]
   link_args = emulator_link_args
diff --git a/include/exec/cpu-defs.h b/include/exec/cpu-defs.h
index 3915438b83..0dbef3010c 100644
--- a/include/exec/cpu-defs.h
+++ b/include/exec/cpu-defs.h
@@ -19,7 +19,7 @@
 #ifndef CPU_DEFS_H
 #define CPU_DEFS_H
 
-#ifndef NEED_CPU_H
+#ifndef COMPILING_PER_TARGET
 #error cpu.h included from common code
 #endif
 
diff --git a/include/exec/helper-head.h b/include/exec/helper-head.h
index 28ceab0a46..5ef467a79d 100644
--- a/include/exec/helper-head.h
+++ b/include/exec/helper-head.h
@@ -43,7 +43,7 @@
 #define dh_ctype_noreturn G_NORETURN void
 #define dh_ctype(t) dh_ctype_##t
 
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 # ifdef TARGET_LONG_BITS
 #  if TARGET_LONG_BITS == 32
 #   define dh_alias_tl i32
@@ -54,7 +54,7 @@
 #  endif
 # endif
 # define dh_ctype_tl target_ulong
-#endif
+#endif /* COMPILING_PER_TARGET */
 
 /* We can't use glue() here because it falls foul of C preprocessor
    recursive expansion rules.  */
diff --git a/include/exec/memop.h b/include/exec/memop.h
index a86dc6743a..06417ff361 100644
--- a/include/exec/memop.h
+++ b/include/exec/memop.h
@@ -35,7 +35,7 @@ typedef enum MemOp {
     MO_LE    = 0,
     MO_BE    = MO_BSWAP,
 #endif
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 #if TARGET_BIG_ENDIAN
     MO_TE    = MO_BE,
 #else
@@ -135,7 +135,7 @@ typedef enum MemOp {
     MO_BESL  = MO_BE | MO_SL,
     MO_BESQ  = MO_BE | MO_SQ,
 
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
     MO_TEUW  = MO_TE | MO_UW,
     MO_TEUL  = MO_TE | MO_UL,
     MO_TEUQ  = MO_TE | MO_UQ,
diff --git a/include/exec/memory.h b/include/exec/memory.h
index dbb1bad72f..dadb5cd65a 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -3107,7 +3107,7 @@ address_space_write_cached(MemoryRegionCache *cache, hwaddr addr,
 MemTxResult address_space_set(AddressSpace *as, hwaddr addr,
                               uint8_t c, hwaddr len, MemTxAttrs attrs);
 
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 /* enum device_endian to MemOp.  */
 static inline MemOp devend_memop(enum device_endian end)
 {
@@ -3125,7 +3125,7 @@ static inline MemOp devend_memop(enum device_endian end)
     return (end == non_host_endianness) ? MO_BSWAP : 0;
 #endif
 }
-#endif
+#endif /* COMPILING_PER_TARGET */
 
 /*
  * Inhibit technologies that require discarding of pages in RAM blocks, e.g.,
diff --git a/include/exec/tswap.h b/include/exec/tswap.h
index 68944a880b..5089cd6a4c 100644
--- a/include/exec/tswap.h
+++ b/include/exec/tswap.h
@@ -15,11 +15,11 @@
  * If we're in target-specific code, we can hard-code the swapping
  * condition, otherwise we have to do (slower) run-time checks.
  */
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 #define target_needs_bswap()  (HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN)
 #else
 #define target_needs_bswap()  (target_words_bigendian() != HOST_BIG_ENDIAN)
-#endif
+#endif /* COMPILING_PER_TARGET */
 
 static inline uint16_t tswap16(uint16_t s)
 {
diff --git a/include/gdbstub/helpers.h b/include/gdbstub/helpers.h
index c573aef2dc..6b97610f48 100644
--- a/include/gdbstub/helpers.h
+++ b/include/gdbstub/helpers.h
@@ -12,7 +12,7 @@
 #ifndef _GDBSTUB_HELPERS_H_
 #define _GDBSTUB_HELPERS_H_
 
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 #include "cpu.h"
 
 /*
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index ec14f74ce5..7f037b158e 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -1182,7 +1182,7 @@ bool target_words_bigendian(void);
 
 const char *target_name(void);
 
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 
 #ifndef CONFIG_USER_ONLY
 
@@ -1197,7 +1197,7 @@ extern const VMStateDescription vmstate_cpu_common;
 }
 #endif /* !CONFIG_USER_ONLY */
 
-#endif /* NEED_CPU_H */
+#endif /* COMPILING_PER_TARGET */
 
 #define UNASSIGNED_CPU_INDEX -1
 #define UNASSIGNED_CLUSTER_INDEX -1
diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index c7053cdc2b..f61edcfdc2 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -32,7 +32,7 @@
 #endif
 
 #include "config-host.h"
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 #include CONFIG_TARGET
 #else
 #include "exec/poison.h"
diff --git a/include/sysemu/hvf.h b/include/sysemu/hvf.h
index 4a7c6af3a5..730f927f03 100644
--- a/include/sysemu/hvf.h
+++ b/include/sysemu/hvf.h
@@ -16,7 +16,7 @@
 #include "qemu/accel.h"
 #include "qom/object.h"
 
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 #include "cpu.h"
 
 #ifdef CONFIG_HVF
@@ -26,7 +26,7 @@ extern bool hvf_allowed;
 #define hvf_enabled() 0
 #endif /* !CONFIG_HVF */
 
-#endif /* NEED_CPU_H */
+#endif /* COMPILING_PER_TARGET */
 
 #define TYPE_HVF_ACCEL ACCEL_CLASS_NAME("hvf")
 
@@ -34,7 +34,7 @@ typedef struct HVFState HVFState;
 DECLARE_INSTANCE_CHECKER(HVFState, HVF_STATE,
                          TYPE_HVF_ACCEL)
 
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 struct hvf_sw_breakpoint {
     vaddr pc;
     vaddr saved_insn;
@@ -66,6 +66,6 @@ void hvf_arch_update_guest_debug(CPUState *cpu);
  * Return whether the guest supports debugging.
  */
 bool hvf_arch_supports_guest_debug(void);
-#endif /* NEED_CPU_H */
+#endif /* COMPILING_PER_TARGET */
 
 #endif
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 47f9e8be1b..eaf801bc93 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -20,7 +20,7 @@
 #include "qemu/accel.h"
 #include "qom/object.h"
 
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 # ifdef CONFIG_KVM
 #  include <linux/kvm.h>
 #  define CONFIG_KVM_IS_POSSIBLE
@@ -210,7 +210,7 @@ bool kvm_arm_supports_user_irq(void);
 int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
 int kvm_on_sigbus(int code, void *addr);
 
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 #include "cpu.h"
 
 void kvm_flush_coalesced_mmio_buffer(void);
@@ -435,7 +435,7 @@ void kvm_set_sigmask_len(KVMState *s, unsigned int sigmask_len);
 int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
                                        hwaddr *phys_addr);
 
-#endif /* NEED_CPU_H */
+#endif /* COMPILING_PER_TARGET */
 
 void kvm_cpu_synchronize_state(CPUState *cpu);
 
diff --git a/include/sysemu/nvmm.h b/include/sysemu/nvmm.h
index be7bc9a62d..6971ddb3a5 100644
--- a/include/sysemu/nvmm.h
+++ b/include/sysemu/nvmm.h
@@ -12,7 +12,7 @@
 #ifndef QEMU_NVMM_H
 #define QEMU_NVMM_H
 
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 
 #ifdef CONFIG_NVMM
 
@@ -24,6 +24,6 @@ int nvmm_enabled(void);
 
 #endif /* CONFIG_NVMM */
 
-#endif /* NEED_CPU_H */
+#endif /* COMPILING_PER_TARGET */
 
 #endif /* QEMU_NVMM_H */
diff --git a/include/sysemu/whpx.h b/include/sysemu/whpx.h
index 781ca5b2b6..00ff409b68 100644
--- a/include/sysemu/whpx.h
+++ b/include/sysemu/whpx.h
@@ -15,7 +15,7 @@
 #ifndef QEMU_WHPX_H
 #define QEMU_WHPX_H
 
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 
 #ifdef CONFIG_WHPX
 
@@ -29,6 +29,6 @@ bool whpx_apic_in_platform(void);
 
 #endif /* CONFIG_WHPX */
 
-#endif /* NEED_CPU_H */
+#endif /* COMPILING_PER_TARGET */
 
 #endif /* QEMU_WHPX_H */
diff --git a/include/sysemu/xen.h b/include/sysemu/xen.h
index a9f591f26d..754ec2e6cb 100644
--- a/include/sysemu/xen.h
+++ b/include/sysemu/xen.h
@@ -16,13 +16,13 @@
 
 #include "exec/cpu-common.h"
 
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 # ifdef CONFIG_XEN
 #  define CONFIG_XEN_IS_POSSIBLE
 # endif
 #else
 # define CONFIG_XEN_IS_POSSIBLE
-#endif
+#endif /* COMPILING_PER_TARGET */
 
 #ifdef CONFIG_XEN_IS_POSSIBLE
 
diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index 7c6adc14f6..c44d23dbe7 100644
--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -14,13 +14,13 @@
 #ifndef ARM_KVM_CONSTS_H
 #define ARM_KVM_CONSTS_H
 
-#ifdef NEED_CPU_H
+#ifdef COMPILING_PER_TARGET
 #ifdef CONFIG_KVM
 #include <linux/kvm.h>
 #include <linux/psci.h>
 #define MISMATCH_CHECK(X, Y) QEMU_BUILD_BUG_ON(X != Y)
 #endif
-#endif
+#endif /* COMPILING_PER_TARGET */
 
 #ifndef MISMATCH_CHECK
 #define MISMATCH_CHECK(X, Y) QEMU_BUILD_BUG_ON(0)
diff --git a/scripts/analyze-inclusions b/scripts/analyze-inclusions
index 45c821de32..b6280f25c8 100644
--- a/scripts/analyze-inclusions
+++ b/scripts/analyze-inclusions
@@ -92,7 +92,7 @@ echo trace/generated-tracers.h:
 analyze -include ../include/qemu/osdep.h trace/generated-tracers.h
 
 echo target/i386/cpu.h:
-analyze -DNEED_CPU_H -I../target/i386 -Ii386-softmmu -include ../include/qemu/osdep.h ../target/i386/cpu.h
+analyze -DCOMPILING_PER_TARGET -I../target/i386 -Ii386-softmmu -include ../include/qemu/osdep.h ../target/i386/cpu.h
 
-echo hw/hw.h + NEED_CPU_H:
-analyze -DNEED_CPU_H -I../target/i386 -Ii386-softmmu -include ../include/qemu/osdep.h ../include/hw/hw.h
+echo hw/hw.h + COMPILING_PER_TARGET:
+analyze -DCOMPILING_PER_TARGET -I../target/i386 -Ii386-softmmu -include ../include/qemu/osdep.h ../include/hw/hw.h
-- 
2.41.0


