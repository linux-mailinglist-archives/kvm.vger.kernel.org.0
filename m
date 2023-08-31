Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2F578EDCE
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 14:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241376AbjHaM5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 08:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjHaM5T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 08:57:19 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1CACEE
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 05:57:14 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-401f503b529so7237235e9.0
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 05:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693486633; x=1694091433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BBmbYhwWUokJXrJxrg7jVrc5Nfzg+L5Sye1331NUuIk=;
        b=owvR4Q0+9oPvsqMuY7phn1sLvU23nnpCdhSU1oAzmt3pfYmUiQUe3CFmTfpqe/3CBm
         08iIWmqHDF3sMxqGHJw8k/q0uBDiCh1X1B02F+et5+05CQq6nkA/V859GDp/fjnjSIpc
         FfZYqBWZtCVQSzxxIPkJMKxJ8Ccp+NDBa6AosuHzFkmHoB5lI+9NFvtgTmHNuLkuWS9c
         HGvi2/5zu2WUZAQhXaXyfS2Emz0qs+Mh4kvzodt+A4QUVuT+sD1YFzWsu6OiZODtm8X1
         POyPXx/8Z9XriooEXoGvDsCcX804zRgtic3kucODcvfrSi+RghTyDJphWnsUQEg+ihFR
         B/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693486633; x=1694091433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BBmbYhwWUokJXrJxrg7jVrc5Nfzg+L5Sye1331NUuIk=;
        b=Qg1wzig79jkBuADpSOQ/L44vkIobvUZMNv8EoSGuVg0hSse050FayDRTb7uGO9N58M
         x67LHLN8RBLYQGhVynXWCt6HI5ySPNYAsv84luaeaMSt0fw2EJX1eoGPqMUHHkMx0/Ko
         LYxCjm2uee2gIvHEw4/MggDxDnjkcFF1kagJU+EJ62L3Ua3rGFBjqWBj2Z25jxDhsRPO
         qepiTfRwFVU9/xrMMI9TffmhnthxLI908vcBphJLDrA3DfEUHNXi+35Qg4WuZqPqzHeX
         vKlal8agxAaze3ZMJReY1TR5O5ryX9yhXmqIRLJFDb24L8dFrOJkdsl0dHOi6ti1G0yG
         NxBA==
X-Gm-Message-State: AOJu0YwnKCK0bZUzNAcAH9BJdfqCkglcjJ8/13Lc0AXXzFIk7XAlLb9V
        MnOWkyY15ZfzEVHnKs2euanz2Q==
X-Google-Smtp-Source: AGHT+IHrugNVq5rO5pJJ/HVe0riFESd6n16BG/MMuMQ4rPHV0uAB9PLEZj5wGWLR2gGoNPDMyj/U+A==
X-Received: by 2002:a7b:cd06:0:b0:401:519:d2 with SMTP id f6-20020a7bcd06000000b00401051900d2mr3641584wmj.23.1693486633253;
        Thu, 31 Aug 2023 05:57:13 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.199.245])
        by smtp.gmail.com with ESMTPSA id n5-20020a05600c294500b003fa96fe2bd9sm5055144wmd.22.2023.08.31.05.57.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 31 Aug 2023 05:57:12 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-arm@nongnu.org, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        qemu-riscv@nongnu.org, qemu-block@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        Tyrone Ting <kfting@nuvoton.com>, Hao Wu <wuhaotsh@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefan Weil <sw@weilnetz.de>, Riku Voipio <riku.voipio@iki.fi>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Subject: [PULL 04/41] bulk: Do not declare function prototypes using 'extern' keyword
Date:   Thu, 31 Aug 2023 14:56:06 +0200
Message-ID: <20230831125646.67855-5-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230831125646.67855-1-philmd@linaro.org>
References: <20230831125646.67855-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By default, C function prototypes declared in headers are visible,
so there is no need to declare them as 'extern' functions.
Remove this redundancy in a single bulk commit; do not modify:

  - meson.build (used to check function availability at runtime)
  - pc-bios/
  - libdecnumber/
  - tests/
  - *.c

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
Message-Id: <20230605175647.88395-5-philmd@linaro.org>
---
 bsd-user/bsd-file.h            |  6 ++---
 crypto/hmacpriv.h              | 13 +++++------
 hw/xen/xen_pt.h                |  8 +++----
 include/crypto/secret_common.h | 14 +++++-------
 include/exec/page-vary.h       |  4 ++--
 include/hw/misc/aspeed_scu.h   |  2 +-
 include/hw/nvram/npcm7xx_otp.h |  4 ++--
 include/hw/qdev-core.h         |  4 ++--
 include/qemu/crc-ccitt.h       |  4 ++--
 include/qemu/osdep.h           |  4 ++--
 include/qemu/rcu.h             | 14 ++++++------
 include/qemu/sys_membarrier.h  |  4 ++--
 include/qemu/uri.h             |  6 ++---
 include/sysemu/accel-blocker.h | 14 ++++++------
 include/sysemu/os-win32.h      |  4 ++--
 include/user/safe-syscall.h    |  4 ++--
 target/i386/sev.h              |  6 ++---
 target/mips/cpu.h              |  4 ++--
 tcg/tcg-internal.h             |  4 ++--
 include/exec/memory_ldst.h.inc | 42 +++++++++++++++++-----------------
 20 files changed, 79 insertions(+), 86 deletions(-)

diff --git a/bsd-user/bsd-file.h b/bsd-user/bsd-file.h
index 588e0c50d4..3c00dc0056 100644
--- a/bsd-user/bsd-file.h
+++ b/bsd-user/bsd-file.h
@@ -51,10 +51,8 @@ do {                                        \
     unlock_user(p1, arg1, 0);               \
 } while (0)
 
-extern struct iovec *lock_iovec(int type, abi_ulong target_addr, int count,
-        int copy);
-extern void unlock_iovec(struct iovec *vec, abi_ulong target_addr, int count,
-        int copy);
+struct iovec *lock_iovec(int type, abi_ulong target_addr, int count, int copy);
+void unlock_iovec(struct iovec *vec, abi_ulong target_addr, int count, int copy);
 
 int safe_open(const char *path, int flags, mode_t mode);
 int safe_openat(int fd, const char *path, int flags, mode_t mode);
diff --git a/crypto/hmacpriv.h b/crypto/hmacpriv.h
index 4387ca2587..62dfe8257a 100644
--- a/crypto/hmacpriv.h
+++ b/crypto/hmacpriv.h
@@ -28,19 +28,18 @@ struct QCryptoHmacDriver {
     void (*hmac_free)(QCryptoHmac *hmac);
 };
 
-extern void *qcrypto_hmac_ctx_new(QCryptoHashAlgorithm alg,
-                                  const uint8_t *key, size_t nkey,
-                                  Error **errp);
+void *qcrypto_hmac_ctx_new(QCryptoHashAlgorithm alg,
+                           const uint8_t *key, size_t nkey,
+                           Error **errp);
 extern QCryptoHmacDriver qcrypto_hmac_lib_driver;
 
 #ifdef CONFIG_AF_ALG
 
 #include "afalgpriv.h"
 
-extern QCryptoAFAlg *
-qcrypto_afalg_hmac_ctx_new(QCryptoHashAlgorithm alg,
-                           const uint8_t *key, size_t nkey,
-                           Error **errp);
+QCryptoAFAlg *qcrypto_afalg_hmac_ctx_new(QCryptoHashAlgorithm alg,
+                                         const uint8_t *key, size_t nkey,
+                                         Error **errp);
 extern QCryptoHmacDriver qcrypto_hmac_afalg_driver;
 
 #endif
diff --git a/hw/xen/xen_pt.h b/hw/xen/xen_pt.h
index b20744f7c7..31bcfdf705 100644
--- a/hw/xen/xen_pt.h
+++ b/hw/xen/xen_pt.h
@@ -340,11 +340,9 @@ static inline bool xen_pt_has_msix_mapping(XenPCIPassthroughState *s, int bar)
     return s->msix && s->msix->bar_index == bar;
 }
 
-extern void *pci_assign_dev_load_option_rom(PCIDevice *dev,
-                                            int *size,
-                                            unsigned int domain,
-                                            unsigned int bus, unsigned int slot,
-                                            unsigned int function);
+void *pci_assign_dev_load_option_rom(PCIDevice *dev, int *size,
+                                     unsigned int domain, unsigned int bus,
+                                     unsigned int slot, unsigned int function);
 static inline bool is_igd_vga_passthrough(XenHostPCIDevice *dev)
 {
     return (xen_igd_gfx_pt_enabled()
diff --git a/include/crypto/secret_common.h b/include/crypto/secret_common.h
index 42c7ff7af6..a0a22e1abd 100644
--- a/include/crypto/secret_common.h
+++ b/include/crypto/secret_common.h
@@ -48,13 +48,11 @@ struct QCryptoSecretCommonClass {
 };
 
 
-extern int qcrypto_secret_lookup(const char *secretid,
-                                 uint8_t **data,
-                                 size_t *datalen,
-                                 Error **errp);
-extern char *qcrypto_secret_lookup_as_utf8(const char *secretid,
-                                           Error **errp);
-extern char *qcrypto_secret_lookup_as_base64(const char *secretid,
-                                             Error **errp);
+int qcrypto_secret_lookup(const char *secretid,
+                          uint8_t **data,
+                          size_t *datalen,
+                          Error **errp);
+char *qcrypto_secret_lookup_as_utf8(const char *secretid, Error **errp);
+char *qcrypto_secret_lookup_as_base64(const char *secretid, Error **errp);
 
 #endif /* QCRYPTO_SECRET_COMMON_H */
diff --git a/include/exec/page-vary.h b/include/exec/page-vary.h
index ebbe9b169b..54ddde308a 100644
--- a/include/exec/page-vary.h
+++ b/include/exec/page-vary.h
@@ -27,8 +27,8 @@ typedef struct {
 } TargetPageBits;
 
 #ifdef IN_PAGE_VARY
-extern bool set_preferred_target_page_bits_common(int bits);
-extern void finalize_target_page_bits_common(int min);
+bool set_preferred_target_page_bits_common(int bits);
+void finalize_target_page_bits_common(int min);
 #endif
 
 /**
diff --git a/include/hw/misc/aspeed_scu.h b/include/hw/misc/aspeed_scu.h
index 5c7c04eedf..7cb6018dbc 100644
--- a/include/hw/misc/aspeed_scu.h
+++ b/include/hw/misc/aspeed_scu.h
@@ -51,7 +51,7 @@ struct AspeedSCUState {
 
 #define ASPEED_IS_AST2500(si_rev)     ((((si_rev) >> 24) & 0xff) == 0x04)
 
-extern bool is_supported_silicon_rev(uint32_t silicon_rev);
+bool is_supported_silicon_rev(uint32_t silicon_rev);
 
 
 struct AspeedSCUClass {
diff --git a/include/hw/nvram/npcm7xx_otp.h b/include/hw/nvram/npcm7xx_otp.h
index 156bbd151a..ea4b5d0731 100644
--- a/include/hw/nvram/npcm7xx_otp.h
+++ b/include/hw/nvram/npcm7xx_otp.h
@@ -73,7 +73,7 @@ typedef struct NPCM7xxOTPClass NPCM7xxOTPClass;
  * Each nibble of data is encoded into a byte, so the number of bytes written
  * to the array will be @len * 2.
  */
-extern void npcm7xx_otp_array_write(NPCM7xxOTPState *s, const void *data,
-                                    unsigned int offset, unsigned int len);
+void npcm7xx_otp_array_write(NPCM7xxOTPState *s, const void *data,
+                             unsigned int offset, unsigned int len);
 
 #endif /* NPCM7XX_OTP_H */
diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
index 884c726a87..151d968238 100644
--- a/include/hw/qdev-core.h
+++ b/include/hw/qdev-core.h
@@ -1086,7 +1086,7 @@ typedef enum MachineInitPhase {
     PHASE_MACHINE_READY,
 } MachineInitPhase;
 
-extern bool phase_check(MachineInitPhase phase);
-extern void phase_advance(MachineInitPhase phase);
+bool phase_check(MachineInitPhase phase);
+void phase_advance(MachineInitPhase phase);
 
 #endif
diff --git a/include/qemu/crc-ccitt.h b/include/qemu/crc-ccitt.h
index d6eb49146d..8918dafe07 100644
--- a/include/qemu/crc-ccitt.h
+++ b/include/qemu/crc-ccitt.h
@@ -17,8 +17,8 @@
 extern uint16_t const crc_ccitt_table[256];
 extern uint16_t const crc_ccitt_false_table[256];
 
-extern uint16_t crc_ccitt(uint16_t crc, const uint8_t *buffer, size_t len);
-extern uint16_t crc_ccitt_false(uint16_t crc, const uint8_t *buffer, size_t len);
+uint16_t crc_ccitt(uint16_t crc, const uint8_t *buffer, size_t len);
+uint16_t crc_ccitt_false(uint16_t crc, const uint8_t *buffer, size_t len);
 
 static inline uint16_t crc_ccitt_byte(uint16_t crc, const uint8_t c)
 {
diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index 2cae135280..2897720fac 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -250,7 +250,7 @@ extern "C" {
  * supports QEMU_ERROR, this will be reported at compile time; otherwise
  * this will be reported at link time due to the missing symbol.
  */
-G_NORETURN extern
+G_NORETURN
 void QEMU_ERROR("code path is reachable")
     qemu_build_not_reached_always(void);
 #if defined(__OPTIMIZE__) && !defined(__NO_INLINE__)
@@ -506,7 +506,7 @@ void qemu_anon_ram_free(void *ptr, size_t size);
  * See MySQL bug #7156 (http://bugs.mysql.com/bug.php?id=7156) for discussion
  * about Solaris missing the madvise() prototype.
  */
-extern int madvise(char *, size_t, int);
+int madvise(char *, size_t, int);
 #endif
 
 #if defined(CONFIG_LINUX)
diff --git a/include/qemu/rcu.h b/include/qemu/rcu.h
index 661c1a1468..fea058aa9f 100644
--- a/include/qemu/rcu.h
+++ b/include/qemu/rcu.h
@@ -118,19 +118,19 @@ static inline void rcu_read_unlock(void)
     }
 }
 
-extern void synchronize_rcu(void);
+void synchronize_rcu(void);
 
 /*
  * Reader thread registration.
  */
-extern void rcu_register_thread(void);
-extern void rcu_unregister_thread(void);
+void rcu_register_thread(void);
+void rcu_unregister_thread(void);
 
 /*
  * Support for fork().  fork() support is enabled at startup.
  */
-extern void rcu_enable_atfork(void);
-extern void rcu_disable_atfork(void);
+void rcu_enable_atfork(void);
+void rcu_disable_atfork(void);
 
 struct rcu_head;
 typedef void RCUCBFunc(struct rcu_head *head);
@@ -140,8 +140,8 @@ struct rcu_head {
     RCUCBFunc *func;
 };
 
-extern void call_rcu1(struct rcu_head *head, RCUCBFunc *func);
-extern void drain_call_rcu(void);
+void call_rcu1(struct rcu_head *head, RCUCBFunc *func);
+void drain_call_rcu(void);
 
 /* The operands of the minus operator must have the same type,
  * which must be the one that we specify in the cast.
diff --git a/include/qemu/sys_membarrier.h b/include/qemu/sys_membarrier.h
index b5bfa21d52..e7774891f8 100644
--- a/include/qemu/sys_membarrier.h
+++ b/include/qemu/sys_membarrier.h
@@ -14,8 +14,8 @@
  * side.  The slow side forces processor-level ordering on all other cores
  * through a system call.
  */
-extern void smp_mb_global_init(void);
-extern void smp_mb_global(void);
+void smp_mb_global_init(void);
+void smp_mb_global(void);
 #define smp_mb_placeholder()       barrier()
 #else
 /* Keep it simple, execute a real memory barrier on both sides.  */
diff --git a/include/qemu/uri.h b/include/qemu/uri.h
index 2875c51417..1855b764f2 100644
--- a/include/qemu/uri.h
+++ b/include/qemu/uri.h
@@ -96,8 +96,8 @@ typedef struct QueryParams {
   QueryParam *p;       /* array of parameters */
 } QueryParams;
 
-QueryParams *query_params_new (int init_alloc);
-extern QueryParams *query_params_parse (const char *query);
-extern void query_params_free (QueryParams *ps);
+QueryParams *query_params_new(int init_alloc);
+QueryParams *query_params_parse(const char *query);
+void query_params_free(QueryParams *ps);
 
 #endif /* QEMU_URI_H */
diff --git a/include/sysemu/accel-blocker.h b/include/sysemu/accel-blocker.h
index 0733783bcc..f07f368358 100644
--- a/include/sysemu/accel-blocker.h
+++ b/include/sysemu/accel-blocker.h
@@ -16,7 +16,7 @@
 
 #include "sysemu/cpus.h"
 
-extern void accel_blocker_init(void);
+void accel_blocker_init(void);
 
 /*
  * accel_{cpu_}ioctl_begin/end:
@@ -26,10 +26,10 @@ extern void accel_blocker_init(void);
  * called, preventing new ioctls to run. They will continue only after
  * accel_ioctl_inibith_end().
  */
-extern void accel_ioctl_begin(void);
-extern void accel_ioctl_end(void);
-extern void accel_cpu_ioctl_begin(CPUState *cpu);
-extern void accel_cpu_ioctl_end(CPUState *cpu);
+void accel_ioctl_begin(void);
+void accel_ioctl_end(void);
+void accel_cpu_ioctl_begin(CPUState *cpu);
+void accel_cpu_ioctl_end(CPUState *cpu);
 
 /*
  * accel_ioctl_inhibit_begin: start critical section
@@ -42,7 +42,7 @@ extern void accel_cpu_ioctl_end(CPUState *cpu);
  * This allows the caller to access shared data or perform operations without
  * worrying of concurrent vcpus accesses.
  */
-extern void accel_ioctl_inhibit_begin(void);
+void accel_ioctl_inhibit_begin(void);
 
 /*
  * accel_ioctl_inhibit_end: end critical section started by
@@ -50,6 +50,6 @@ extern void accel_ioctl_inhibit_begin(void);
  *
  * This function allows blocked accel_{cpu_}ioctl_begin() to continue.
  */
-extern void accel_ioctl_inhibit_end(void);
+void accel_ioctl_inhibit_end(void);
 
 #endif /* ACCEL_BLOCKER_H */
diff --git a/include/sysemu/os-win32.h b/include/sysemu/os-win32.h
index 91aa0d7ec0..83104e332f 100644
--- a/include/sysemu/os-win32.h
+++ b/include/sysemu/os-win32.h
@@ -66,8 +66,8 @@ extern "C" {
  * setjmp to _setjmpex instead. However, they are still defined in libmingwex.a,
  * which gets linked automatically.
  */
-extern int __mingw_setjmp(jmp_buf);
-extern void __attribute__((noreturn)) __mingw_longjmp(jmp_buf, int);
+int __mingw_setjmp(jmp_buf);
+void __attribute__((noreturn)) __mingw_longjmp(jmp_buf, int);
 #define setjmp(env) __mingw_setjmp(env)
 #define longjmp(env, val) __mingw_longjmp(env, val)
 #elif defined(_WIN64)
diff --git a/include/user/safe-syscall.h b/include/user/safe-syscall.h
index 195cedac04..27b71cdbd8 100644
--- a/include/user/safe-syscall.h
+++ b/include/user/safe-syscall.h
@@ -126,8 +126,8 @@
  */
 
 /* The core part of this function is implemented in assembly */
-extern long safe_syscall_base(int *pending, long number, ...);
-extern long safe_syscall_set_errno_tail(int value);
+long safe_syscall_base(int *pending, long number, ...);
+long safe_syscall_set_errno_tail(int value);
 
 /* These are defined by the safe-syscall.inc.S file */
 extern char safe_syscall_start[];
diff --git a/target/i386/sev.h b/target/i386/sev.h
index 7b1528248a..e7499c95b1 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -46,9 +46,9 @@ bool sev_es_enabled(void);
 #define sev_es_enabled() 0
 #endif
 
-extern uint32_t sev_get_cbit_position(void);
-extern uint32_t sev_get_reduced_phys_bits(void);
-extern bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp);
+uint32_t sev_get_cbit_position(void);
+uint32_t sev_get_reduced_phys_bits(void);
+bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp);
 
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
 int sev_inject_launch_secret(const char *hdr, const char *secret,
diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index f81bd06f5e..6d6af1f2a8 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1224,8 +1224,8 @@ void mips_cpu_list(void);
 
 #define cpu_list mips_cpu_list
 
-extern void cpu_wrdsp(uint32_t rs, uint32_t mask_num, CPUMIPSState *env);
-extern uint32_t cpu_rddsp(uint32_t mask_num, CPUMIPSState *env);
+void cpu_wrdsp(uint32_t rs, uint32_t mask_num, CPUMIPSState *env);
+uint32_t cpu_rddsp(uint32_t mask_num, CPUMIPSState *env);
 
 /*
  * MMU modes definitions. We carefully match the indices with our
diff --git a/tcg/tcg-internal.h b/tcg/tcg-internal.h
index fbe62b31b8..40a69e6e6e 100644
--- a/tcg/tcg-internal.h
+++ b/tcg/tcg-internal.h
@@ -64,8 +64,8 @@ static inline TCGv_i32 TCGV_HIGH(TCGv_i64 t)
     return temp_tcgv_i32(tcgv_i64_temp(t) + !HOST_BIG_ENDIAN);
 }
 #else
-extern TCGv_i32 TCGV_LOW(TCGv_i64) QEMU_ERROR("32-bit code path is reachable");
-extern TCGv_i32 TCGV_HIGH(TCGv_i64) QEMU_ERROR("32-bit code path is reachable");
+TCGv_i32 TCGV_LOW(TCGv_i64) QEMU_ERROR("32-bit code path is reachable");
+TCGv_i32 TCGV_HIGH(TCGv_i64) QEMU_ERROR("32-bit code path is reachable");
 #endif
 
 static inline TCGv_i64 TCGV128_LOW(TCGv_i128 t)
diff --git a/include/exec/memory_ldst.h.inc b/include/exec/memory_ldst.h.inc
index 7c3a641f7e..92ad74e956 100644
--- a/include/exec/memory_ldst.h.inc
+++ b/include/exec/memory_ldst.h.inc
@@ -20,48 +20,48 @@
  */
 
 #ifdef TARGET_ENDIANNESS
-extern uint16_t glue(address_space_lduw, SUFFIX)(ARG1_DECL,
+uint16_t glue(address_space_lduw, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
-extern uint32_t glue(address_space_ldl, SUFFIX)(ARG1_DECL,
+uint32_t glue(address_space_ldl, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
-extern uint64_t glue(address_space_ldq, SUFFIX)(ARG1_DECL,
+uint64_t glue(address_space_ldq, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
-extern void glue(address_space_stl_notdirty, SUFFIX)(ARG1_DECL,
+void glue(address_space_stl_notdirty, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint32_t val, MemTxAttrs attrs, MemTxResult *result);
-extern void glue(address_space_stw, SUFFIX)(ARG1_DECL,
+void glue(address_space_stw, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint16_t val, MemTxAttrs attrs, MemTxResult *result);
-extern void glue(address_space_stl, SUFFIX)(ARG1_DECL,
+void glue(address_space_stl, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint32_t val, MemTxAttrs attrs, MemTxResult *result);
-extern void glue(address_space_stq, SUFFIX)(ARG1_DECL,
+void glue(address_space_stq, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result);
 #else
-extern uint8_t glue(address_space_ldub, SUFFIX)(ARG1_DECL,
+uint8_t glue(address_space_ldub, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
-extern uint16_t glue(address_space_lduw_le, SUFFIX)(ARG1_DECL,
+uint16_t glue(address_space_lduw_le, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
-extern uint16_t glue(address_space_lduw_be, SUFFIX)(ARG1_DECL,
+uint16_t glue(address_space_lduw_be, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
-extern uint32_t glue(address_space_ldl_le, SUFFIX)(ARG1_DECL,
+uint32_t glue(address_space_ldl_le, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
-extern uint32_t glue(address_space_ldl_be, SUFFIX)(ARG1_DECL,
+uint32_t glue(address_space_ldl_be, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
-extern uint64_t glue(address_space_ldq_le, SUFFIX)(ARG1_DECL,
+uint64_t glue(address_space_ldq_le, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
-extern uint64_t glue(address_space_ldq_be, SUFFIX)(ARG1_DECL,
+uint64_t glue(address_space_ldq_be, SUFFIX)(ARG1_DECL,
     hwaddr addr, MemTxAttrs attrs, MemTxResult *result);
-extern void glue(address_space_stb, SUFFIX)(ARG1_DECL,
+void glue(address_space_stb, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint8_t val, MemTxAttrs attrs, MemTxResult *result);
-extern void glue(address_space_stw_le, SUFFIX)(ARG1_DECL,
+void glue(address_space_stw_le, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint16_t val, MemTxAttrs attrs, MemTxResult *result);
-extern void glue(address_space_stw_be, SUFFIX)(ARG1_DECL,
+void glue(address_space_stw_be, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint16_t val, MemTxAttrs attrs, MemTxResult *result);
-extern void glue(address_space_stl_le, SUFFIX)(ARG1_DECL,
+void glue(address_space_stl_le, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint32_t val, MemTxAttrs attrs, MemTxResult *result);
-extern void glue(address_space_stl_be, SUFFIX)(ARG1_DECL,
+void glue(address_space_stl_be, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint32_t val, MemTxAttrs attrs, MemTxResult *result);
-extern void glue(address_space_stq_le, SUFFIX)(ARG1_DECL,
+void glue(address_space_stq_le, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result);
-extern void glue(address_space_stq_be, SUFFIX)(ARG1_DECL,
+void glue(address_space_stq_be, SUFFIX)(ARG1_DECL,
     hwaddr addr, uint64_t val, MemTxAttrs attrs, MemTxResult *result);
 #endif
 
-- 
2.41.0

