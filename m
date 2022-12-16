Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEBA64EA35
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 12:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiLPLWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 06:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiLPLWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 06:22:18 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B74C1B1EA
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 03:22:14 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id i187-20020a1c3bc4000000b003d1e906ca23so966902wma.3
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 03:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AhJcdSXB4V4j08EKX0Yv20fK6m+tnCmhDQDXx34AShI=;
        b=YKWvSEmPU1MQPXRphdqkxZxqjRKzdqBo1e79yjjyPd9c68Rpy0ksBN6SfowZVItai0
         efnUxI0Eq/0UH6PoR4Ofjl4Iy/bDmqqIPpVYyBL62Y4oyWWwE0I03BUZJLf6mWAFYOlA
         vxuwvNVxx0Y/JLHzWVjJV4EMXjbo/4aT8qNsqJ0ontW3CI5H5Zn6IcHfu17nA2NEcM/O
         uOrZigVlwH40FKww+N4LJq3mwBLkh2PpG4g8zYvFFfJgfts+aRaWijFgDc4R+/gRrPJN
         2OAST0kBEALgIeBLmMw2YLtJ7c1VbDOMe5NCiC7NHKi5neQ4SzZJoDWrl5GxSShvi7Ma
         Clfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AhJcdSXB4V4j08EKX0Yv20fK6m+tnCmhDQDXx34AShI=;
        b=srw7zKB+8X5tXV6PvrAMZQXvT2d8YVH3rU5D9mydYIyE8SJiZL5rEMDvVjPK9vTaZL
         73s+2wXyCZsNfFOW9rLMwtMZuL00Qb5v3Fm8pM+hoTWoGR2qZ285UcH6T7SdeyLEP2wd
         nSGWus25M/sN21k/XIRxKIoznKPcjeDfgXY8KecJpaj7XFgjkK8gPXVYdIIkE5QiD5KP
         Tbb6s3ar+Mg+id+lghSS9hXEXTvPGh1dS474pW+c5ne6PdW6h6j2b1PsojF5anXeuMcR
         UUcUrmvI24YXyE915XpBoreZCabU8RMMwJO2wFog7M4jXI7yeodwbtiB/y78QS5hm8MS
         8eLA==
X-Gm-Message-State: ANoB5pnqV8ZtAJnlJkfPQsTIhT7q3YjSFVoMjWcmvOGeDfAmL+e16tKp
        j3oG0UPbbrIaN25ambenxHvkzg==
X-Google-Smtp-Source: AA0mqf68lMC8/t8YA9UpxWPl0s9U4OGIGFkoK3W5T6goSdmZxgQ39PbjUbeIh8QZ2sv1KDwiagjJEw==
X-Received: by 2002:a7b:c017:0:b0:3cf:8e5d:7184 with SMTP id c23-20020a7bc017000000b003cf8e5d7184mr24713399wmb.28.1671189732664;
        Fri, 16 Dec 2022 03:22:12 -0800 (PST)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id 1-20020a05600c228100b003d23928b654sm9045807wmf.11.2022.12.16.03.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 03:22:09 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id E9E251FFBA;
        Fri, 16 Dec 2022 11:22:08 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     f4bug@amsat.org, mads@ynddal.dk,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Laurent Vivier <laurent@vivier.eu>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Michael Rolnik <mrolnik@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Taylor Simpson <tsimpson@quicinc.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Song Gao <gaosong@loongson.cn>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Chris Wulff <crwulff@gmail.com>, Marek Vasut <marex@denx.de>,
        Stafford Horne <shorne@gmail.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Max Filippov <jcmvbkbc@gmail.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs),
        qemu-arm@nongnu.org (open list:ARM TCG CPUs),
        qemu-ppc@nongnu.org (open list:PowerPC TCG CPUs),
        qemu-riscv@nongnu.org (open list:RISC-V TCG CPUs),
        qemu-s390x@nongnu.org (open list:S390 general arch...)
Subject: [PATCH  v1 10/10] gdbstub: retire exec/gdbstub.h
Date:   Fri, 16 Dec 2022 11:22:06 +0000
Message-Id: <20221216112206.3171578-11-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221216112206.3171578-1-alex.bennee@linaro.org>
References: <20221216112206.3171578-1-alex.bennee@linaro.org>
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

Finally split the gdbstub API across multiple headers:

  - common.h, all the standard APIs registering and semihosting
  - user.h, user-mode specific APIs
  - helpers.h, the register helpers that need to be host/target aware

The aim is to reduce the dependence on cpu.h and target specific
awareness where we can.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 bsd-user/qemu.h                        |   2 +-
 include/exec/gdbstub.h                 | 235 -------------------------
 include/gdbstub/common.h               | 151 ++++++++++++++++
 include/gdbstub/helpers.h              | 101 +++++++++++
 accel/kvm/kvm-all.c                    |   2 +-
 accel/tcg/tcg-accel-ops.c              |   2 +-
 gdbstub/gdbstub.c                      |   2 +-
 gdbstub/softmmu.c                      |   4 +-
 gdbstub/user-target.c                  |   2 +-
 gdbstub/user.c                         |   2 +-
 linux-user/exit.c                      |   2 +-
 linux-user/main.c                      |   2 +-
 monitor/misc.c                         |   2 +-
 semihosting/arm-compat-semi.c          |   2 +-
 semihosting/console.c                  |   2 +-
 semihosting/guestfd.c                  |   2 +-
 semihosting/syscalls.c                 |   3 +-
 softmmu/cpus.c                         |   2 +-
 softmmu/runstate.c                     |   2 +-
 softmmu/vl.c                           |   2 +-
 stubs/gdbstub.c                        |   2 +-
 target/alpha/gdbstub.c                 |   2 +-
 target/arm/gdbstub.c                   |   3 +-
 target/arm/gdbstub64.c                 |   2 +-
 target/arm/helper-a64.c                |   2 +-
 target/arm/kvm64.c                     |   2 +-
 target/arm/m_helper.c                  |   2 +-
 target/avr/gdbstub.c                   |   2 +-
 target/cris/gdbstub.c                  |   2 +-
 target/hexagon/gdbstub.c               |   2 +-
 target/hppa/gdbstub.c                  |   2 +-
 target/i386/gdbstub.c                  |   2 +-
 target/i386/kvm/kvm.c                  |   2 +-
 target/i386/whpx/whpx-all.c            |   2 +-
 target/loongarch/gdbstub.c             |   3 +-
 target/m68k/gdbstub.c                  |   2 +-
 target/m68k/helper.c                   |   3 +-
 target/m68k/m68k-semi.c                |   4 +-
 target/microblaze/gdbstub.c            |   2 +-
 target/mips/gdbstub.c                  |   2 +-
 target/mips/tcg/sysemu/mips-semi.c     |   3 +-
 target/nios2/cpu.c                     |   2 +-
 target/nios2/nios2-semi.c              |   3 +-
 target/openrisc/gdbstub.c              |   2 +-
 target/openrisc/interrupt.c            |   2 +-
 target/openrisc/mmu.c                  |   2 +-
 target/ppc/cpu_init.c                  |   2 +-
 target/ppc/gdbstub.c                   |   3 +-
 target/ppc/kvm.c                       |   2 +-
 target/riscv/gdbstub.c                 |   3 +-
 target/rx/gdbstub.c                    |   2 +-
 target/s390x/gdbstub.c                 |   3 +-
 target/s390x/helper.c                  |   2 +-
 target/s390x/kvm/kvm.c                 |   2 +-
 target/sh4/gdbstub.c                   |   2 +-
 target/sparc/gdbstub.c                 |   2 +-
 target/tricore/gdbstub.c               |   2 +-
 target/xtensa/core-dc232b.c            |   2 +-
 target/xtensa/core-dc233c.c            |   2 +-
 target/xtensa/core-de212.c             |   2 +-
 target/xtensa/core-de233_fpu.c         |   2 +-
 target/xtensa/core-dsp3400.c           |   2 +-
 target/xtensa/core-fsf.c               |   2 +-
 target/xtensa/core-lx106.c             |   2 +-
 target/xtensa/core-sample_controller.c |   2 +-
 target/xtensa/core-test_kc705_be.c     |   2 +-
 target/xtensa/core-test_mmuhifi_c3.c   |   2 +-
 target/xtensa/gdbstub.c                |   2 +-
 target/xtensa/helper.c                 |   2 +-
 MAINTAINERS                            |   1 -
 scripts/feature_to_c.sh                |   2 +-
 target/xtensa/import_core.sh           |   2 +-
 72 files changed, 332 insertions(+), 305 deletions(-)
 delete mode 100644 include/exec/gdbstub.h
 create mode 100644 include/gdbstub/helpers.h

diff --git a/bsd-user/qemu.h b/bsd-user/qemu.h
index be6105385e..d76d17cdc5 100644
--- a/bsd-user/qemu.h
+++ b/bsd-user/qemu.h
@@ -36,7 +36,7 @@ extern char **environ;
 #include "target_os_vmparam.h"
 #include "target_os_signal.h"
 #include "target.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/user.h"
 
 /*
  * This struct is used to hold certain information about the image.  Basically,
diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
deleted file mode 100644
index d1eb96f807..0000000000
--- a/include/exec/gdbstub.h
+++ /dev/null
@@ -1,235 +0,0 @@
-#ifndef GDBSTUB_H
-#define GDBSTUB_H
-
-#define DEFAULT_GDBSTUB_PORT "1234"
-
-/* GDB breakpoint/watchpoint types */
-#define GDB_BREAKPOINT_SW        0
-#define GDB_BREAKPOINT_HW        1
-#define GDB_WATCHPOINT_WRITE     2
-#define GDB_WATCHPOINT_READ      3
-#define GDB_WATCHPOINT_ACCESS    4
-
-/* For gdb file i/o remote protocol open flags. */
-#define GDB_O_RDONLY  0
-#define GDB_O_WRONLY  1
-#define GDB_O_RDWR    2
-#define GDB_O_APPEND  8
-#define GDB_O_CREAT   0x200
-#define GDB_O_TRUNC   0x400
-#define GDB_O_EXCL    0x800
-
-/* For gdb file i/o remote protocol errno values */
-#define GDB_EPERM           1
-#define GDB_ENOENT          2
-#define GDB_EINTR           4
-#define GDB_EBADF           9
-#define GDB_EACCES         13
-#define GDB_EFAULT         14
-#define GDB_EBUSY          16
-#define GDB_EEXIST         17
-#define GDB_ENODEV         19
-#define GDB_ENOTDIR        20
-#define GDB_EISDIR         21
-#define GDB_EINVAL         22
-#define GDB_ENFILE         23
-#define GDB_EMFILE         24
-#define GDB_EFBIG          27
-#define GDB_ENOSPC         28
-#define GDB_ESPIPE         29
-#define GDB_EROFS          30
-#define GDB_ENAMETOOLONG   91
-#define GDB_EUNKNOWN       9999
-
-/* For gdb file i/o remote protocol lseek whence. */
-#define GDB_SEEK_SET  0
-#define GDB_SEEK_CUR  1
-#define GDB_SEEK_END  2
-
-/* For gdb file i/o stat/fstat. */
-typedef uint32_t gdb_mode_t;
-typedef uint32_t gdb_time_t;
-
-struct gdb_stat {
-  uint32_t    gdb_st_dev;     /* device */
-  uint32_t    gdb_st_ino;     /* inode */
-  gdb_mode_t  gdb_st_mode;    /* protection */
-  uint32_t    gdb_st_nlink;   /* number of hard links */
-  uint32_t    gdb_st_uid;     /* user ID of owner */
-  uint32_t    gdb_st_gid;     /* group ID of owner */
-  uint32_t    gdb_st_rdev;    /* device type (if inode device) */
-  uint64_t    gdb_st_size;    /* total size, in bytes */
-  uint64_t    gdb_st_blksize; /* blocksize for filesystem I/O */
-  uint64_t    gdb_st_blocks;  /* number of blocks allocated */
-  gdb_time_t  gdb_st_atime;   /* time of last access */
-  gdb_time_t  gdb_st_mtime;   /* time of last modification */
-  gdb_time_t  gdb_st_ctime;   /* time of last change */
-} QEMU_PACKED;
-
-struct gdb_timeval {
-  gdb_time_t tv_sec;  /* second */
-  uint64_t tv_usec;   /* microsecond */
-} QEMU_PACKED;
-
-typedef void (*gdb_syscall_complete_cb)(CPUState *cpu, uint64_t ret, int err);
-
-/**
- * gdb_do_syscall:
- * @cb: function to call when the system call has completed
- * @fmt: gdb syscall format string
- * ...: list of arguments to interpolate into @fmt
- *
- * Send a GDB syscall request. This function will return immediately;
- * the callback function will be called later when the remote system
- * call has completed.
- *
- * @fmt should be in the 'call-id,parameter,parameter...' format documented
- * for the F request packet in the GDB remote protocol. A limited set of
- * printf-style format specifiers is supported:
- *   %x  - target_ulong argument printed in hex
- *   %lx - 64-bit argument printed in hex
- *   %s  - string pointer (target_ulong) and length (int) pair
- */
-void gdb_do_syscall(gdb_syscall_complete_cb cb, const char *fmt, ...);
-/**
- * gdb_do_syscallv:
- * @cb: function to call when the system call has completed
- * @fmt: gdb syscall format string
- * @va: arguments to interpolate into @fmt
- *
- * As gdb_do_syscall, but taking a va_list rather than a variable
- * argument list.
- */
-void gdb_do_syscallv(gdb_syscall_complete_cb cb, const char *fmt, va_list va);
-int use_gdb_syscalls(void);
-
-#ifdef CONFIG_USER_ONLY
-#endif
-
-/* Get or set a register.  Returns the size of the register.  */
-typedef int (*gdb_get_reg_cb)(CPUArchState *env, GByteArray *buf, int reg);
-typedef int (*gdb_set_reg_cb)(CPUArchState *env, uint8_t *buf, int reg);
-void gdb_register_coprocessor(CPUState *cpu,
-                              gdb_get_reg_cb get_reg, gdb_set_reg_cb set_reg,
-                              int num_regs, const char *xml, int g_pos);
-
-#ifdef NEED_CPU_H
-#include "cpu.h"
-
-/*
- * The GDB remote protocol transfers values in target byte order. As
- * the gdbstub may be batching up several register values we always
- * append to the array.
- */
-
-static inline int gdb_get_reg8(GByteArray *buf, uint8_t val)
-{
-    g_byte_array_append(buf, &val, 1);
-    return 1;
-}
-
-static inline int gdb_get_reg16(GByteArray *buf, uint16_t val)
-{
-    uint16_t to_word = tswap16(val);
-    g_byte_array_append(buf, (uint8_t *) &to_word, 2);
-    return 2;
-}
-
-static inline int gdb_get_reg32(GByteArray *buf, uint32_t val)
-{
-    uint32_t to_long = tswap32(val);
-    g_byte_array_append(buf, (uint8_t *) &to_long, 4);
-    return 4;
-}
-
-static inline int gdb_get_reg64(GByteArray *buf, uint64_t val)
-{
-    uint64_t to_quad = tswap64(val);
-    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
-    return 8;
-}
-
-static inline int gdb_get_reg128(GByteArray *buf, uint64_t val_hi,
-                                 uint64_t val_lo)
-{
-    uint64_t to_quad;
-#if TARGET_BIG_ENDIAN
-    to_quad = tswap64(val_hi);
-    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
-    to_quad = tswap64(val_lo);
-    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
-#else
-    to_quad = tswap64(val_lo);
-    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
-    to_quad = tswap64(val_hi);
-    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
-#endif
-    return 16;
-}
-
-static inline int gdb_get_zeroes(GByteArray *array, size_t len)
-{
-    guint oldlen = array->len;
-    g_byte_array_set_size(array, oldlen + len);
-    memset(array->data + oldlen, 0, len);
-
-    return len;
-}
-
-/**
- * gdb_get_reg_ptr: get pointer to start of last element
- * @len: length of element
- *
- * This is a helper function to extract the pointer to the last
- * element for additional processing. Some front-ends do additional
- * dynamic swapping of the elements based on CPU state.
- */
-static inline uint8_t * gdb_get_reg_ptr(GByteArray *buf, int len)
-{
-    return buf->data + buf->len - len;
-}
-
-#if TARGET_LONG_BITS == 64
-#define gdb_get_regl(buf, val) gdb_get_reg64(buf, val)
-#define ldtul_p(addr) ldq_p(addr)
-#else
-#define gdb_get_regl(buf, val) gdb_get_reg32(buf, val)
-#define ldtul_p(addr) ldl_p(addr)
-#endif
-
-#endif /* NEED_CPU_H */
-
-/**
- * gdbserver_start: start the gdb server
- * @port_or_device: connection spec for gdb
- *
- * For CONFIG_USER this is either a tcp port or a path to a fifo. For
- * system emulation you can use a full chardev spec for your gdbserver
- * port.
- */
-int gdbserver_start(const char *port_or_device);
-
-/**
- * gdb_exit: exit gdb session, reporting inferior status
- * @code: exit code reported
- *
- * This closes the session and sends a final packet to GDB reporting
- * the exit status of the program. It also cleans up any connections
- * detritus before returning.
- */
-void gdb_exit(int code);
-
-void gdb_set_stop_cpu(CPUState *cpu);
-
-/**
- * gdb_has_xml:
- * This is an ugly hack to cope with both new and old gdb.
- * If gdb sends qXfer:features:read then assume we're talking to a newish
- * gdb that understands target descriptions.
- */
-extern bool gdb_has_xml;
-
-/* in gdbstub-xml.c, generated by scripts/feature_to_c.sh */
-extern const char *const xml_builtin[][2];
-
-#endif
diff --git a/include/gdbstub/common.h b/include/gdbstub/common.h
index f928dbc487..680250273b 100644
--- a/include/gdbstub/common.h
+++ b/include/gdbstub/common.h
@@ -9,6 +9,157 @@
 #ifndef GDBSTUB_COMMON_H
 #define GDBSTUB_COMMON_H
 
+#define DEFAULT_GDBSTUB_PORT "1234"
+
+/* GDB breakpoint/watchpoint types */
+#define GDB_BREAKPOINT_SW        0
+#define GDB_BREAKPOINT_HW        1
+#define GDB_WATCHPOINT_WRITE     2
+#define GDB_WATCHPOINT_READ      3
+#define GDB_WATCHPOINT_ACCESS    4
+
+/* For gdb file i/o remote protocol open flags. */
+#define GDB_O_RDONLY  0
+#define GDB_O_WRONLY  1
+#define GDB_O_RDWR    2
+#define GDB_O_APPEND  8
+#define GDB_O_CREAT   0x200
+#define GDB_O_TRUNC   0x400
+#define GDB_O_EXCL    0x800
+
+/* For gdb file i/o remote protocol errno values */
+#define GDB_EPERM           1
+#define GDB_ENOENT          2
+#define GDB_EINTR           4
+#define GDB_EBADF           9
+#define GDB_EACCES         13
+#define GDB_EFAULT         14
+#define GDB_EBUSY          16
+#define GDB_EEXIST         17
+#define GDB_ENODEV         19
+#define GDB_ENOTDIR        20
+#define GDB_EISDIR         21
+#define GDB_EINVAL         22
+#define GDB_ENFILE         23
+#define GDB_EMFILE         24
+#define GDB_EFBIG          27
+#define GDB_ENOSPC         28
+#define GDB_ESPIPE         29
+#define GDB_EROFS          30
+#define GDB_ENAMETOOLONG   91
+#define GDB_EUNKNOWN       9999
+
+/* For gdb file i/o remote protocol lseek whence. */
+#define GDB_SEEK_SET  0
+#define GDB_SEEK_CUR  1
+#define GDB_SEEK_END  2
+
+/* For gdb file i/o stat/fstat. */
+typedef uint32_t gdb_mode_t;
+typedef uint32_t gdb_time_t;
+
+struct gdb_stat {
+  uint32_t    gdb_st_dev;     /* device */
+  uint32_t    gdb_st_ino;     /* inode */
+  gdb_mode_t  gdb_st_mode;    /* protection */
+  uint32_t    gdb_st_nlink;   /* number of hard links */
+  uint32_t    gdb_st_uid;     /* user ID of owner */
+  uint32_t    gdb_st_gid;     /* group ID of owner */
+  uint32_t    gdb_st_rdev;    /* device type (if inode device) */
+  uint64_t    gdb_st_size;    /* total size, in bytes */
+  uint64_t    gdb_st_blksize; /* blocksize for filesystem I/O */
+  uint64_t    gdb_st_blocks;  /* number of blocks allocated */
+  gdb_time_t  gdb_st_atime;   /* time of last access */
+  gdb_time_t  gdb_st_mtime;   /* time of last modification */
+  gdb_time_t  gdb_st_ctime;   /* time of last change */
+} QEMU_PACKED;
+
+struct gdb_timeval {
+  gdb_time_t tv_sec;  /* second */
+  uint64_t tv_usec;   /* microsecond */
+} QEMU_PACKED;
+
+typedef void (*gdb_syscall_complete_cb)(CPUState *cpu, uint64_t ret, int err);
+
+/**
+ * gdb_do_syscall:
+ * @cb: function to call when the system call has completed
+ * @fmt: gdb syscall format string
+ * ...: list of arguments to interpolate into @fmt
+ *
+ * Send a GDB syscall request. This function will return immediately;
+ * the callback function will be called later when the remote system
+ * call has completed.
+ *
+ * @fmt should be in the 'call-id,parameter,parameter...' format documented
+ * for the F request packet in the GDB remote protocol. A limited set of
+ * printf-style format specifiers is supported:
+ *   %x  - target_ulong argument printed in hex
+ *   %lx - 64-bit argument printed in hex
+ *   %s  - string pointer (target_ulong) and length (int) pair
+ */
+void gdb_do_syscall(gdb_syscall_complete_cb cb, const char *fmt, ...);
+/**
+ * gdb_do_syscallv:
+ * @cb: function to call when the system call has completed
+ * @fmt: gdb syscall format string
+ * @va: arguments to interpolate into @fmt
+ *
+ * As gdb_do_syscall, but taking a va_list rather than a variable
+ * argument list.
+ */
+void gdb_do_syscallv(gdb_syscall_complete_cb cb, const char *fmt, va_list va);
+
+/**
+ * use_gdb_syscalls() - use gdb syscalls or native file IO for semihosting
+ */
+int use_gdb_syscalls(void);
+
+/**
+ * gdbserver_start: start the gdb server
+ * @port_or_device: connection spec for gdb
+ *
+ * For CONFIG_USER this is either a tcp port or a path to a fifo. For
+ * system emulation you can use a full chardev spec for your gdbserver
+ * port.
+ */
+int gdbserver_start(const char *port_or_device);
+
+/**
+ * gdb_exit: exit gdb session, reporting inferior status
+ * @code: exit code reported
+ *
+ * This closes the session and sends a final packet to GDB reporting
+ * the exit status of the program. It also cleans up any connections
+ * detritus before returning.
+ */
+void gdb_exit(int code);
+
+/**
+ * gdb_set_stop_cpu() - signal which CPU just halted
+ *
+ * This is called by the core translator to signal which CPU caused the
+ * current stoppage.
+ */
+void gdb_set_stop_cpu(CPUState *cpu);
+
+/**
+ * gdb_has_xml:
+ * This is an ugly hack to cope with both new and old gdb.
+ * If gdb sends qXfer:features:read then assume we're talking to a newish
+ * gdb that understands target descriptions.
+ */
+extern bool gdb_has_xml;
+
+/* in gdbstub-xml.c, generated by scripts/feature_to_c.sh */
+extern const char *const xml_builtin[][2];
+
+/* Get or set a register.  Returns the size of the register.  */
+typedef int (*gdb_get_reg_cb)(CPUArchState *env, GByteArray *buf, int reg);
+typedef int (*gdb_set_reg_cb)(CPUArchState *env, uint8_t *buf, int reg);
+void gdb_register_coprocessor(CPUState *cpu,
+                              gdb_get_reg_cb get_reg, gdb_set_reg_cb set_reg,
+                              int num_regs, const char *xml, int g_pos);
 
 
 #endif /* GDBSTUB_COMMON_H */
diff --git a/include/gdbstub/helpers.h b/include/gdbstub/helpers.h
new file mode 100644
index 0000000000..1fe5602f96
--- /dev/null
+++ b/include/gdbstub/helpers.h
@@ -0,0 +1,101 @@
+/*
+ * gdbstub helpers
+ *
+ * These are all used by the various frontends and have to be host
+ * aware to ensure things are store in target order.
+ *
+ * Copyright (c) 2022 Linaro Ltd
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef _GDBSTUB_HELPERS_H_
+#define _GDBSTUB_HELPERS_H_
+
+#ifdef NEED_CPU_H
+#include "cpu.h"
+
+/*
+ * The GDB remote protocol transfers values in target byte order. As
+ * the gdbstub may be batching up several register values we always
+ * append to the array.
+ */
+
+static inline int gdb_get_reg8(GByteArray *buf, uint8_t val)
+{
+    g_byte_array_append(buf, &val, 1);
+    return 1;
+}
+
+static inline int gdb_get_reg16(GByteArray *buf, uint16_t val)
+{
+    uint16_t to_word = tswap16(val);
+    g_byte_array_append(buf, (uint8_t *) &to_word, 2);
+    return 2;
+}
+
+static inline int gdb_get_reg32(GByteArray *buf, uint32_t val)
+{
+    uint32_t to_long = tswap32(val);
+    g_byte_array_append(buf, (uint8_t *) &to_long, 4);
+    return 4;
+}
+
+static inline int gdb_get_reg64(GByteArray *buf, uint64_t val)
+{
+    uint64_t to_quad = tswap64(val);
+    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
+    return 8;
+}
+
+static inline int gdb_get_reg128(GByteArray *buf, uint64_t val_hi,
+                                 uint64_t val_lo)
+{
+    uint64_t to_quad;
+#if TARGET_BIG_ENDIAN
+    to_quad = tswap64(val_hi);
+    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
+    to_quad = tswap64(val_lo);
+    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
+#else
+    to_quad = tswap64(val_lo);
+    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
+    to_quad = tswap64(val_hi);
+    g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
+#endif
+    return 16;
+}
+
+static inline int gdb_get_zeroes(GByteArray *array, size_t len)
+{
+    guint oldlen = array->len;
+    g_byte_array_set_size(array, oldlen + len);
+    memset(array->data + oldlen, 0, len);
+
+    return len;
+}
+
+/**
+ * gdb_get_reg_ptr: get pointer to start of last element
+ * @len: length of element
+ *
+ * This is a helper function to extract the pointer to the last
+ * element for additional processing. Some front-ends do additional
+ * dynamic swapping of the elements based on CPU state.
+ */
+static inline uint8_t * gdb_get_reg_ptr(GByteArray *buf, int len)
+{
+    return buf->data + buf->len - len;
+}
+
+#if TARGET_LONG_BITS == 64
+#define gdb_get_regl(buf, val) gdb_get_reg64(buf, val)
+#define ldtul_p(addr) ldq_p(addr)
+#else
+#define gdb_get_regl(buf, val) gdb_get_reg32(buf, val)
+#define ldtul_p(addr) ldl_p(addr)
+#endif
+
+#endif /* NEED_CPU_H */
+
+#endif /* _GDBSTUB_HELPERS_H_ */
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index e86c33e0e6..93926e557e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -27,7 +27,7 @@
 #include "hw/pci/msi.h"
 #include "hw/pci/msix.h"
 #include "hw/s390x/adapter.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
 #include "sysemu/cpus.h"
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 19cbf1db3a..08435b72b4 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -33,7 +33,7 @@
 #include "qemu/guest-random.h"
 #include "exec/exec-all.h"
 #include "exec/hwaddr.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 
 #include "tcg-accel-ops.h"
 #include "tcg-accel-ops-mttcg.h"
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index fa68a77066..f3fec3a266 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -28,7 +28,7 @@
 #include "qemu/cutils.h"
 #include "qemu/module.h"
 #include "trace.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #ifdef CONFIG_USER_ONLY
 #include "gdbstub/user.h"
 #else
diff --git a/gdbstub/softmmu.c b/gdbstub/softmmu.c
index 1154a313cb..3540d5892b 100644
--- a/gdbstub/softmmu.c
+++ b/gdbstub/softmmu.c
@@ -14,7 +14,6 @@
 #include "qapi/error.h"
 #include "qemu/error-report.h"
 #include "qemu/cutils.h"
-#include "exec/gdbstub.h"
 #include "exec/hwaddr.h"
 #include "exec/tb-flush.h"
 #include "sysemu/cpus.h"
@@ -26,8 +25,9 @@
 #include "chardev/char.h"
 #include "chardev/char-fe.h"
 #include "monitor/monitor.h"
-#include "trace.h"
+#include "gdbstub/common.h"
 #include "internals.h"
+#include "trace.h"
 
 /* system emulation connection details */
 typedef struct GDBConnection {
diff --git a/gdbstub/user-target.c b/gdbstub/user-target.c
index 83e04e1c23..a959b6d9dc 100644
--- a/gdbstub/user-target.c
+++ b/gdbstub/user-target.c
@@ -8,7 +8,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "qemu.h"
 #include "internals.h"
 
diff --git a/gdbstub/user.c b/gdbstub/user.c
index 3492d9b68a..65ea52479e 100644
--- a/gdbstub/user.c
+++ b/gdbstub/user.c
@@ -14,7 +14,7 @@
 #include "qemu/sockets.h"
 #include "exec/hwaddr.h"
 #include "exec/tb-flush.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "gdbstub/user.h"
 #include "hw/core/cpu.h"
 #include "trace.h"
diff --git a/linux-user/exit.c b/linux-user/exit.c
index fa6ef0b9b4..fb65924c16 100644
--- a/linux-user/exit.c
+++ b/linux-user/exit.c
@@ -17,7 +17,7 @@
  *  along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 #include "qemu/osdep.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "qemu.h"
 #include "user-internals.h"
 #ifdef CONFIG_GPROF
diff --git a/linux-user/main.c b/linux-user/main.c
index 68aaf4bd58..ced3c8b1df 100644
--- a/linux-user/main.c
+++ b/linux-user/main.c
@@ -39,7 +39,7 @@
 #include "qemu/module.h"
 #include "qemu/plugin.h"
 #include "exec/exec-all.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "gdbstub/user.h"
 #include "tcg/tcg.h"
 #include "qemu/timer.h"
diff --git a/monitor/misc.c b/monitor/misc.c
index c7eb673ffd..3bf5f6afc0 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -29,7 +29,7 @@
 #include "hw/pci/pci.h"
 #include "sysemu/watchdog.h"
 #include "hw/loader.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "net/net.h"
 #include "net/slirp.h"
 #include "ui/qemu-spice.h"
diff --git a/semihosting/arm-compat-semi.c b/semihosting/arm-compat-semi.c
index 62d8bae97f..bb43aa988c 100644
--- a/semihosting/arm-compat-semi.c
+++ b/semihosting/arm-compat-semi.c
@@ -33,7 +33,7 @@
 
 #include "qemu/osdep.h"
 #include "qemu/timer.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "semihosting/semihost.h"
 #include "semihosting/console.h"
 #include "semihosting/common-semi.h"
diff --git a/semihosting/console.c b/semihosting/console.c
index 5d61e8207e..b3e999fbcf 100644
--- a/semihosting/console.c
+++ b/semihosting/console.c
@@ -18,7 +18,7 @@
 #include "qemu/osdep.h"
 #include "semihosting/semihost.h"
 #include "semihosting/console.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "exec/exec-all.h"
 #include "qemu/log.h"
 #include "chardev/char.h"
diff --git a/semihosting/guestfd.c b/semihosting/guestfd.c
index b05c52f26f..757c63f6fe 100644
--- a/semihosting/guestfd.c
+++ b/semihosting/guestfd.c
@@ -9,7 +9,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "semihosting/semihost.h"
 #include "semihosting/guestfd.h"
 #ifdef CONFIG_USER_ONLY
diff --git a/semihosting/syscalls.c b/semihosting/syscalls.c
index 508a0ad88c..6570caece2 100644
--- a/semihosting/syscalls.c
+++ b/semihosting/syscalls.c
@@ -7,7 +7,8 @@
  */
 
 #include "qemu/osdep.h"
-#include "exec/gdbstub.h"
+#include "exec/cpu-defs.h"
+#include "gdbstub/common.h"
 #include "semihosting/guestfd.h"
 #include "semihosting/syscalls.h"
 #include "semihosting/console.h"
diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index 5a584a8d57..72f35c605d 100644
--- a/softmmu/cpus.c
+++ b/softmmu/cpus.c
@@ -30,7 +30,7 @@
 #include "qapi/qapi-commands-misc.h"
 #include "qapi/qapi-events-run-state.h"
 #include "qapi/qmp/qerror.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "sysemu/hw_accel.h"
 #include "exec/cpu-common.h"
 #include "qemu/thread.h"
diff --git a/softmmu/runstate.c b/softmmu/runstate.c
index cab9f6fc07..9bffc5cdbe 100644
--- a/softmmu/runstate.c
+++ b/softmmu/runstate.c
@@ -30,7 +30,7 @@
 #include "crypto/cipher.h"
 #include "crypto/init.h"
 #include "exec/cpu-common.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "hw/boards.h"
 #include "migration/misc.h"
 #include "migration/postcopy-ram.h"
diff --git a/softmmu/vl.c b/softmmu/vl.c
index 798e1dc933..b2007641e1 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -66,7 +66,7 @@
 #include "sysemu/sysemu.h"
 #include "sysemu/numa.h"
 #include "sysemu/hostmem.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "qemu/timer.h"
 #include "chardev/char.h"
 #include "qemu/bitmap.h"
diff --git a/stubs/gdbstub.c b/stubs/gdbstub.c
index 2b7aee50d3..f5f2147caf 100644
--- a/stubs/gdbstub.c
+++ b/stubs/gdbstub.c
@@ -1,5 +1,5 @@
 #include "qemu/osdep.h"
-#include "exec/gdbstub.h"       /* xml_builtin */
+#include "gdbstub/common.h"       /* xml_builtin */
 
 const char *const xml_builtin[][2] = {
   { NULL, NULL }
diff --git a/target/alpha/gdbstub.c b/target/alpha/gdbstub.c
index 7db14f4431..0f8fa150f8 100644
--- a/target/alpha/gdbstub.c
+++ b/target/alpha/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int alpha_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/arm/gdbstub.c b/target/arm/gdbstub.c
index 2f806512d0..f39a1825e6 100644
--- a/target/arm/gdbstub.c
+++ b/target/arm/gdbstub.c
@@ -19,7 +19,8 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
+#include "gdbstub/helpers.h"
 #include "internals.h"
 #include "cpregs.h"
 
diff --git a/target/arm/gdbstub64.c b/target/arm/gdbstub64.c
index 07a6746944..48d2888b6f 100644
--- a/target/arm/gdbstub64.c
+++ b/target/arm/gdbstub64.c
@@ -20,7 +20,7 @@
 #include "qemu/log.h"
 #include "cpu.h"
 #include "internals.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int aarch64_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/arm/helper-a64.c b/target/arm/helper-a64.c
index 77a8502b6b..b52d381043 100644
--- a/target/arm/helper-a64.c
+++ b/target/arm/helper-a64.c
@@ -20,7 +20,7 @@
 #include "qemu/osdep.h"
 #include "qemu/units.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "exec/helper-proto.h"
 #include "qemu/host-utils.h"
 #include "qemu/log.h"
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 1197253d12..ba64e40554 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -22,7 +22,7 @@
 #include "qemu/error-report.h"
 #include "qemu/host-utils.h"
 #include "qemu/main-loop.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "sysemu/runstate.h"
 #include "sysemu/kvm.h"
 #include "sysemu/kvm_int.h"
diff --git a/target/arm/m_helper.c b/target/arm/m_helper.c
index 355cd4d60a..53f1b38ec4 100644
--- a/target/arm/m_helper.c
+++ b/target/arm/m_helper.c
@@ -12,7 +12,7 @@
 #include "trace.h"
 #include "cpu.h"
 #include "internals.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "exec/helper-proto.h"
 #include "qemu/host-utils.h"
 #include "qemu/main-loop.h"
diff --git a/target/avr/gdbstub.c b/target/avr/gdbstub.c
index 1c1b908c92..150344d8b9 100644
--- a/target/avr/gdbstub.c
+++ b/target/avr/gdbstub.c
@@ -19,7 +19,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int avr_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/cris/gdbstub.c b/target/cris/gdbstub.c
index 2418d575b1..25c0ca33a5 100644
--- a/target/cris/gdbstub.c
+++ b/target/cris/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int crisv10_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/hexagon/gdbstub.c b/target/hexagon/gdbstub.c
index d152d01bfe..46083da620 100644
--- a/target/hexagon/gdbstub.c
+++ b/target/hexagon/gdbstub.c
@@ -16,7 +16,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "cpu.h"
 #include "internal.h"
 
diff --git a/target/hppa/gdbstub.c b/target/hppa/gdbstub.c
index 729c37b2ca..48a514384f 100644
--- a/target/hppa/gdbstub.c
+++ b/target/hppa/gdbstub.c
@@ -19,7 +19,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int hppa_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/i386/gdbstub.c b/target/i386/gdbstub.c
index c3a2cf6f28..255faa70f6 100644
--- a/target/i386/gdbstub.c
+++ b/target/i386/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "include/gdbstub/helpers.h"
 
 #ifdef TARGET_X86_64
 static const int gpr_map[16] = {
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 0ab4e0734a..d169cf9dc7 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -34,7 +34,7 @@
 #include "hyperv.h"
 #include "hyperv-proto.h"
 
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "qemu/host-utils.h"
 #include "qemu/main-loop.h"
 #include "qemu/config-file.h"
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index e738d83e81..430da38778 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -12,7 +12,7 @@
 #include "cpu.h"
 #include "exec/address-spaces.h"
 #include "exec/ioport.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/accel.h"
 #include "sysemu/whpx.h"
 #include "sysemu/cpus.h"
diff --git a/target/loongarch/gdbstub.c b/target/loongarch/gdbstub.c
index a4d1e28e36..4589978512 100644
--- a/target/loongarch/gdbstub.c
+++ b/target/loongarch/gdbstub.c
@@ -8,8 +8,9 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "gdbstub/common.h"
+#include "gdbstub/helpers.h"
 #include "internals.h"
-#include "exec/gdbstub.h"
 
 uint64_t read_fcc(CPULoongArchState *env)
 {
diff --git a/target/m68k/gdbstub.c b/target/m68k/gdbstub.c
index eb2d030e14..1e5f033a12 100644
--- a/target/m68k/gdbstub.c
+++ b/target/m68k/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int m68k_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/m68k/helper.c b/target/m68k/helper.c
index 4621cf2402..1c6938396d 100644
--- a/target/m68k/helper.c
+++ b/target/m68k/helper.c
@@ -21,7 +21,8 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "exec/exec-all.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
+#include "gdbstub/helpers.h"
 #include "exec/helper-proto.h"
 #include "fpu/softfloat.h"
 #include "qemu/qemu-print.h"
diff --git a/target/m68k/m68k-semi.c b/target/m68k/m68k-semi.c
index 87b1314925..29be977c07 100644
--- a/target/m68k/m68k-semi.c
+++ b/target/m68k/m68k-semi.c
@@ -20,7 +20,9 @@
 #include "qemu/osdep.h"
 
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
+#include "gdbstub/common.h"
+#include "gdbstub/helpers.h"
 #include "semihosting/syscalls.h"
 #include "semihosting/softmmu-uaccess.h"
 #include "hw/boards.h"
diff --git a/target/microblaze/gdbstub.c b/target/microblaze/gdbstub.c
index 2e6e070051..ad2e0b27cb 100644
--- a/target/microblaze/gdbstub.c
+++ b/target/microblaze/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 /*
  * GDB expects SREGs in the following order:
diff --git a/target/mips/gdbstub.c b/target/mips/gdbstub.c
index f1c2a2cf6d..62d7b72407 100644
--- a/target/mips/gdbstub.c
+++ b/target/mips/gdbstub.c
@@ -20,7 +20,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "internal.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "fpu_helper.h"
 
 int mips_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
diff --git a/target/mips/tcg/sysemu/mips-semi.c b/target/mips/tcg/sysemu/mips-semi.c
index 85f0567a7f..121eeae6be 100644
--- a/target/mips/tcg/sysemu/mips-semi.c
+++ b/target/mips/tcg/sysemu/mips-semi.c
@@ -20,7 +20,8 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "qemu/log.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
+#include "gdbstub/helpers.h"
 #include "semihosting/softmmu-uaccess.h"
 #include "semihosting/semihost.h"
 #include "semihosting/console.h"
diff --git a/target/nios2/cpu.c b/target/nios2/cpu.c
index 9a5351bc81..d85d97dd55 100644
--- a/target/nios2/cpu.c
+++ b/target/nios2/cpu.c
@@ -23,7 +23,7 @@
 #include "qapi/error.h"
 #include "cpu.h"
 #include "exec/log.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "hw/qdev-properties.h"
 
 static void nios2_cpu_set_pc(CPUState *cs, vaddr value)
diff --git a/target/nios2/nios2-semi.c b/target/nios2/nios2-semi.c
index f76e8588c5..f21b47bb9d 100644
--- a/target/nios2/nios2-semi.c
+++ b/target/nios2/nios2-semi.c
@@ -23,7 +23,8 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
+#include "gdbstub/helpers.h"
 #include "semihosting/syscalls.h"
 #include "semihosting/softmmu-uaccess.h"
 #include "qemu/log.h"
diff --git a/target/openrisc/gdbstub.c b/target/openrisc/gdbstub.c
index 095bf76c12..d1074a0581 100644
--- a/target/openrisc/gdbstub.c
+++ b/target/openrisc/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int openrisc_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/openrisc/interrupt.c b/target/openrisc/interrupt.c
index c31c6f12c4..3887812810 100644
--- a/target/openrisc/interrupt.c
+++ b/target/openrisc/interrupt.c
@@ -21,7 +21,7 @@
 #include "qemu/log.h"
 #include "cpu.h"
 #include "exec/exec-all.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 #ifndef CONFIG_USER_ONLY
 #include "hw/loader.h"
diff --git a/target/openrisc/mmu.c b/target/openrisc/mmu.c
index 0b8afdbacf..603c26715e 100644
--- a/target/openrisc/mmu.c
+++ b/target/openrisc/mmu.c
@@ -22,7 +22,7 @@
 #include "qemu/log.h"
 #include "cpu.h"
 #include "exec/exec-all.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 #include "hw/loader.h"
 
diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index cbf0081374..949fbbd215 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -20,7 +20,7 @@
 
 #include "qemu/osdep.h"
 #include "disas/dis-asm.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "kvm_ppc.h"
 #include "sysemu/cpus.h"
 #include "sysemu/hw_accel.h"
diff --git a/target/ppc/gdbstub.c b/target/ppc/gdbstub.c
index 1a0b9ca82c..444d5e616f 100644
--- a/target/ppc/gdbstub.c
+++ b/target/ppc/gdbstub.c
@@ -19,7 +19,8 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
+#include "gdbstub/helpers.h"
 #include "internal.h"
 
 static int ppc_gdb_register_len_apple(int n)
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 7c25348b7b..c4f958ce12 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -40,7 +40,7 @@
 #include "migration/qemu-file-types.h"
 #include "sysemu/watchdog.h"
 #include "trace.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "exec/memattrs.h"
 #include "exec/ram_addr.h"
 #include "sysemu/hostmem.h"
diff --git a/target/riscv/gdbstub.c b/target/riscv/gdbstub.c
index 6e7bbdbd5e..666c06ffe0 100644
--- a/target/riscv/gdbstub.c
+++ b/target/riscv/gdbstub.c
@@ -17,7 +17,8 @@
  */
 
 #include "qemu/osdep.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
+#include "gdbstub/helpers.h"
 #include "cpu.h"
 
 struct TypeSize {
diff --git a/target/rx/gdbstub.c b/target/rx/gdbstub.c
index 7eb2059a84..d7e0e6689b 100644
--- a/target/rx/gdbstub.c
+++ b/target/rx/gdbstub.c
@@ -17,7 +17,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 int rx_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
diff --git a/target/s390x/gdbstub.c b/target/s390x/gdbstub.c
index a5d69d0e0b..8aaea23104 100644
--- a/target/s390x/gdbstub.c
+++ b/target/s390x/gdbstub.c
@@ -22,7 +22,8 @@
 #include "cpu.h"
 #include "s390x-internal.h"
 #include "exec/exec-all.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
+#include "gdbstub/helpers.h"
 #include "qemu/bitops.h"
 #include "sysemu/hw_accel.h"
 #include "sysemu/tcg.h"
diff --git a/target/s390x/helper.c b/target/s390x/helper.c
index 473c8e51b0..2b363aa959 100644
--- a/target/s390x/helper.c
+++ b/target/s390x/helper.c
@@ -21,7 +21,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "s390x-internal.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/timer.h"
 #include "hw/s390x/ioinst.h"
 #include "hw/s390x/pv.h"
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 3ac7ec9acf..ec883721b3 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -40,7 +40,7 @@
 #include "sysemu/hw_accel.h"
 #include "sysemu/runstate.h"
 #include "sysemu/device_tree.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/common.h"
 #include "exec/ram_addr.h"
 #include "trace.h"
 #include "hw/s390x/s390-pci-inst.h"
diff --git a/target/sh4/gdbstub.c b/target/sh4/gdbstub.c
index 3488f68e32..d8e199fc06 100644
--- a/target/sh4/gdbstub.c
+++ b/target/sh4/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 /* Hint: Use "set architecture sh4" in GDB to see fpu registers */
 /* FIXME: We should use XML for this.  */
diff --git a/target/sparc/gdbstub.c b/target/sparc/gdbstub.c
index 5d1e808e8c..a1c8fdc4d5 100644
--- a/target/sparc/gdbstub.c
+++ b/target/sparc/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 #ifdef TARGET_ABI32
 #define gdb_get_rega(buf, val) gdb_get_reg32(buf, val)
diff --git a/target/tricore/gdbstub.c b/target/tricore/gdbstub.c
index ebf32defde..5a61ac5753 100644
--- a/target/tricore/gdbstub.c
+++ b/target/tricore/gdbstub.c
@@ -18,7 +18,7 @@
  */
 
 #include "qemu/osdep.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 
 
 #define LCX_REGNUM         32
diff --git a/target/xtensa/core-dc232b.c b/target/xtensa/core-dc232b.c
index c982d09c24..9aba2667e3 100644
--- a/target/xtensa/core-dc232b.c
+++ b/target/xtensa/core-dc232b.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 #include "qemu/timer.h"
 
diff --git a/target/xtensa/core-dc233c.c b/target/xtensa/core-dc233c.c
index 595ab9a90f..9b0a625063 100644
--- a/target/xtensa/core-dc233c.c
+++ b/target/xtensa/core-dc233c.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-dc233c/core-isa.h"
diff --git a/target/xtensa/core-de212.c b/target/xtensa/core-de212.c
index 50c995ba79..b08fe22e65 100644
--- a/target/xtensa/core-de212.c
+++ b/target/xtensa/core-de212.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-de212/core-isa.h"
diff --git a/target/xtensa/core-de233_fpu.c b/target/xtensa/core-de233_fpu.c
index 41af8057fb..8845cdb592 100644
--- a/target/xtensa/core-de233_fpu.c
+++ b/target/xtensa/core-de233_fpu.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-de233_fpu/core-isa.h"
diff --git a/target/xtensa/core-dsp3400.c b/target/xtensa/core-dsp3400.c
index 81e425c568..c0f94b9e27 100644
--- a/target/xtensa/core-dsp3400.c
+++ b/target/xtensa/core-dsp3400.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-dsp3400/core-isa.h"
diff --git a/target/xtensa/core-fsf.c b/target/xtensa/core-fsf.c
index 3327c50b4f..310be8d61f 100644
--- a/target/xtensa/core-fsf.c
+++ b/target/xtensa/core-fsf.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-fsf/core-isa.h"
diff --git a/target/xtensa/core-lx106.c b/target/xtensa/core-lx106.c
index 7a771d09a6..7f71d088f3 100644
--- a/target/xtensa/core-lx106.c
+++ b/target/xtensa/core-lx106.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-lx106/core-isa.h"
diff --git a/target/xtensa/core-sample_controller.c b/target/xtensa/core-sample_controller.c
index fd5de5576b..8867001aac 100644
--- a/target/xtensa/core-sample_controller.c
+++ b/target/xtensa/core-sample_controller.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-sample_controller/core-isa.h"
diff --git a/target/xtensa/core-test_kc705_be.c b/target/xtensa/core-test_kc705_be.c
index 294c16f2f4..bd082f49aa 100644
--- a/target/xtensa/core-test_kc705_be.c
+++ b/target/xtensa/core-test_kc705_be.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-test_kc705_be/core-isa.h"
diff --git a/target/xtensa/core-test_mmuhifi_c3.c b/target/xtensa/core-test_mmuhifi_c3.c
index c0e5d32d1e..3090dd01ed 100644
--- a/target/xtensa/core-test_mmuhifi_c3.c
+++ b/target/xtensa/core-test_mmuhifi_c3.c
@@ -27,7 +27,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-test_mmuhifi_c3/core-isa.h"
diff --git a/target/xtensa/gdbstub.c b/target/xtensa/gdbstub.c
index b6696063e5..4b3bfb7e59 100644
--- a/target/xtensa/gdbstub.c
+++ b/target/xtensa/gdbstub.c
@@ -19,7 +19,7 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/log.h"
 
 enum {
diff --git a/target/xtensa/helper.c b/target/xtensa/helper.c
index 2aa9777a8e..dbeb97a953 100644
--- a/target/xtensa/helper.c
+++ b/target/xtensa/helper.c
@@ -29,7 +29,7 @@
 #include "qemu/log.h"
 #include "cpu.h"
 #include "exec/exec-all.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "exec/helper-proto.h"
 #include "qemu/error-report.h"
 #include "qemu/qemu-print.h"
diff --git a/MAINTAINERS b/MAINTAINERS
index c84d9299c3..ba7ae16d57 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2697,7 +2697,6 @@ M: Alex Bennée <alex.bennee@linaro.org>
 R: Philippe Mathieu-Daudé <philmd@linaro.org>
 S: Maintained
 F: gdbstub/*
-F: include/exec/gdbstub.h
 F: include/gdbstub/*
 F: gdb-xml/
 F: tests/tcg/multiarch/gdbstub/
diff --git a/scripts/feature_to_c.sh b/scripts/feature_to_c.sh
index c1f67c8f6a..cdebb85590 100644
--- a/scripts/feature_to_c.sh
+++ b/scripts/feature_to_c.sh
@@ -56,7 +56,7 @@ for input; do
 done
 
 echo
-echo '#include "exec/gdbstub.h"'
+echo '#include "gdbstub/common.h"'
 echo "const char *const xml_builtin[][2] = {"
 
 for input; do
diff --git a/target/xtensa/import_core.sh b/target/xtensa/import_core.sh
index b4c15556c2..17dfec8957 100755
--- a/target/xtensa/import_core.sh
+++ b/target/xtensa/import_core.sh
@@ -41,7 +41,7 @@ tar -xf "$OVERLAY" -O binutils/xtensa-modules.c | \
 cat <<EOF > "${TARGET}.c"
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/gdbstub.h"
+#include "gdbstub/helpers.h"
 #include "qemu/host-utils.h"
 
 #include "core-$NAME/core-isa.h"
-- 
2.34.1

