Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFF84DADD8
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 10:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344258AbiCPJyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 05:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiCPJyh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 05:54:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B1533336A
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 02:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647424399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=URtiK+smvWeTTdZ/Hsz11BHTdlcjBz0MY/0XPQvAwZY=;
        b=R21wFl5sOYptesUbx99CHaQDBbnWnk30is44yZD6eNrqb0uXWLACPjiSb3+sTTn1EIcv4p
        PGEYPkunpkcOWZBns/8bsa+BQb9pi+SL/tpiSa3xQNDQYZOcMrLWN4fEtpSbHJfrouib5K
        TDmp83caZXzFJrIb5ORhnapvdAgYKvc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-FfTgYJCCOdaTNEKesI7MEg-1; Wed, 16 Mar 2022 05:53:15 -0400
X-MC-Unique: FfTgYJCCOdaTNEKesI7MEg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46B3829DD9A3;
        Wed, 16 Mar 2022 09:53:14 +0000 (UTC)
Received: from localhost (unknown [10.39.208.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D850D40E7F1E;
        Wed, 16 Mar 2022 09:53:10 +0000 (UTC)
From:   marcandre.lureau@redhat.com
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Vikram Garhwal <fnu.vikram@xilinx.com>,
        Jason Wang <jasowang@redhat.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Coiby Xu <Coiby.Xu@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs),
        qemu-arm@nongnu.org (open list:ARM PrimeCell and...),
        qemu-s390x@nongnu.org (open list:S390 SCLP-backed...),
        qemu-ppc@nongnu.org (open list:PowerPC TCG CPUs),
        qemu-riscv@nongnu.org (open list:RISC-V TCG CPUs),
        qemu-block@nongnu.org (open list:virtio-blk)
Subject: [PATCH 10/27] Replace config-time define HOST_WORDS_BIGENDIAN
Date:   Wed, 16 Mar 2022 13:53:07 +0400
Message-Id: <20220316095308.2613651-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Replace a config-time define with a compile time condition
define (compatible with clang and gcc) that must be declared prior to
its usage. This avoids having a global configure time define, but also
prevents from bad usage, if the config header wasn't included before.

This can help to make some code independent from qemu too.

gcc supports __BYTE_ORDER__ from about 4.6 and clang from 3.2.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 meson.build                             |  1 -
 accel/tcg/atomic_template.h             |  4 +-
 audio/audio.h                           |  2 +-
 hw/display/pl110_template.h             |  6 +--
 hw/net/can/ctucan_core.h                |  2 +-
 hw/net/vmxnet3.h                        |  4 +-
 include/exec/cpu-all.h                  |  4 +-
 include/exec/cpu-common.h               |  2 +-
 include/exec/memop.h                    |  2 +-
 include/exec/memory.h                   |  2 +-
 include/fpu/softfloat-types.h           |  2 +-
 include/hw/core/cpu.h                   |  2 +-
 include/hw/i386/intel_iommu.h           |  6 +--
 include/hw/i386/x86-iommu.h             |  4 +-
 include/hw/virtio/virtio-access.h       |  6 +--
 include/hw/virtio/virtio-gpu-bswap.h    |  2 +-
 include/libdecnumber/dconfig.h          |  2 +-
 include/net/eth.h                       |  2 +-
 include/qemu/bswap.h                    |  8 ++--
 include/qemu/compiler.h                 |  2 +
 include/qemu/host-utils.h               |  2 +-
 include/qemu/int128.h                   |  2 +-
 include/ui/qemu-pixman.h                |  2 +-
 net/util.h                              |  2 +-
 target/arm/cpu.h                        |  8 ++--
 target/arm/translate-a64.h              |  2 +-
 target/arm/vec_internal.h               |  2 +-
 target/i386/cpu.h                       |  2 +-
 target/mips/cpu.h                       |  2 +-
 target/ppc/cpu.h                        |  2 +-
 target/s390x/tcg/vec.h                  |  2 +-
 target/xtensa/cpu.h                     |  2 +-
 tests/fp/platform.h                     |  4 +-
 accel/kvm/kvm-all.c                     |  4 +-
 audio/dbusaudio.c                       |  2 +-
 disas.c                                 |  2 +-
 hw/core/loader.c                        |  4 +-
 hw/display/artist.c                     |  6 +--
 hw/display/pxa2xx_lcd.c                 |  2 +-
 hw/display/vga.c                        | 12 +++---
 hw/display/virtio-gpu-gl.c              |  2 +-
 hw/s390x/event-facility.c               |  2 +-
 hw/virtio/vhost.c                       |  2 +-
 linux-user/arm/nwfpe/double_cpdo.c      |  4 +-
 linux-user/arm/nwfpe/fpa11_cpdt.c       |  4 +-
 linux-user/ppc/signal.c                 |  3 +-
 linux-user/syscall.c                    |  6 +--
 net/net.c                               |  4 +-
 target/alpha/translate.c                |  2 +-
 target/arm/crypto_helper.c              |  2 +-
 target/arm/helper.c                     |  2 +-
 target/arm/kvm64.c                      |  4 +-
 target/arm/neon_helper.c                |  2 +-
 target/arm/sve_helper.c                 |  4 +-
 target/arm/translate-sve.c              |  6 +--
 target/arm/translate-vfp.c              |  2 +-
 target/arm/translate.c                  |  2 +-
 target/hppa/translate.c                 |  2 +-
 target/i386/tcg/translate.c             |  2 +-
 target/mips/tcg/lmmi_helper.c           |  2 +-
 target/mips/tcg/msa_helper.c            | 54 ++++++++++++-------------
 target/ppc/arch_dump.c                  |  2 +-
 target/ppc/int_helper.c                 | 22 +++++-----
 target/ppc/kvm.c                        |  4 +-
 target/ppc/mem_helper.c                 |  2 +-
 target/riscv/vector_helper.c            |  2 +-
 target/s390x/tcg/translate.c            |  2 +-
 target/sparc/vis_helper.c               |  4 +-
 tcg/tcg-op.c                            |  4 +-
 tcg/tcg.c                               | 12 +++---
 tests/qtest/vhost-user-blk-test.c       |  2 +-
 tests/qtest/virtio-blk-test.c           |  2 +-
 ui/vdagent.c                            |  2 +-
 ui/vnc.c                                |  2 +-
 util/bitmap.c                           |  2 +-
 util/host-utils.c                       |  2 +-
 target/ppc/translate/vmx-impl.c.inc     |  4 +-
 target/ppc/translate/vsx-impl.c.inc     |  2 +-
 target/riscv/insn_trans/trans_rvv.c.inc |  4 +-
 target/s390x/tcg/translate_vx.c.inc     |  2 +-
 tcg/aarch64/tcg-target.c.inc            |  4 +-
 tcg/arm/tcg-target.c.inc                |  4 +-
 tcg/mips/tcg-target.c.inc               |  2 +-
 tcg/ppc/tcg-target.c.inc                | 10 ++---
 tcg/riscv/tcg-target.c.inc              |  4 +-
 85 files changed, 173 insertions(+), 173 deletions(-)

diff --git a/meson.build b/meson.build
index f20712cb93d7..88df1bc42973 100644
--- a/meson.build
+++ b/meson.build
@@ -1591,7 +1591,6 @@ config_host_data.set('QEMU_VERSION_MICRO', meson.project_version().split('.')[2]
 
 config_host_data.set_quoted('CONFIG_HOST_DSOSUF', host_dsosuf)
 config_host_data.set('HAVE_HOST_BLOCK_DEVICE', have_host_block_device)
-config_host_data.set('HOST_WORDS_BIGENDIAN', host_machine.endian() == 'big')
 
 have_coroutine_pool = get_option('coroutine_pool')
 if get_option('debug_stack_usage') and have_coroutine_pool
diff --git a/accel/tcg/atomic_template.h b/accel/tcg/atomic_template.h
index fc165031e868..404a530f7c2a 100644
--- a/accel/tcg/atomic_template.h
+++ b/accel/tcg/atomic_template.h
@@ -63,7 +63,7 @@
    the ATOMIC_NAME macro, and redefined below.  */
 #if DATA_SIZE == 1
 # define END
-#elif defined(HOST_WORDS_BIGENDIAN)
+#elif HOST_BIG_ENDIAN
 # define END  _be
 #else
 # define END  _le
@@ -196,7 +196,7 @@ GEN_ATOMIC_HELPER_FN(umax_fetch, MAX,  DATA_TYPE, new)
 
 /* Define reverse-host-endian atomic operations.  Note that END is used
    within the ATOMIC_NAME macro.  */
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 # define END  _le
 #else
 # define END  _be
diff --git a/audio/audio.h b/audio/audio.h
index cbb10f4816e5..3d5ecdecd5c1 100644
--- a/audio/audio.h
+++ b/audio/audio.h
@@ -32,7 +32,7 @@
 
 typedef void (*audio_callback_fn) (void *opaque, int avail);
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define AUDIO_HOST_ENDIANNESS 1
 #else
 #define AUDIO_HOST_ENDIANNESS 0
diff --git a/hw/display/pl110_template.h b/hw/display/pl110_template.h
index 877419aa817a..00877853225d 100644
--- a/hw/display/pl110_template.h
+++ b/hw/display/pl110_template.h
@@ -15,18 +15,18 @@
 
 #if ORDER == 0
 #define NAME glue(lblp_, BORDER)
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define SWAP_WORDS 1
 #endif
 #elif ORDER == 1
 #define NAME glue(bbbp_, BORDER)
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
 #define SWAP_WORDS 1
 #endif
 #else
 #define SWAP_PIXELS 1
 #define NAME glue(lbbp_, BORDER)
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define SWAP_WORDS 1
 #endif
 #endif
diff --git a/hw/net/can/ctucan_core.h b/hw/net/can/ctucan_core.h
index bbc09ae06785..608307a6310c 100644
--- a/hw/net/can/ctucan_core.h
+++ b/hw/net/can/ctucan_core.h
@@ -31,7 +31,7 @@
 #include "exec/hwaddr.h"
 #include "net/can_emu.h"
 
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
 #define __LITTLE_ENDIAN_BITFIELD 1
 #endif
 
diff --git a/hw/net/vmxnet3.h b/hw/net/vmxnet3.h
index 5b3b76ba7ad1..bf4f6de74a07 100644
--- a/hw/net/vmxnet3.h
+++ b/hw/net/vmxnet3.h
@@ -35,7 +35,7 @@
 #define __le32  uint32_t
 #define __le64  uint64_t
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define __BIG_ENDIAN_BITFIELD
 #else
 #endif
@@ -800,7 +800,7 @@ struct Vmxnet3_DriverShared {
 #undef __le16
 #undef __le32
 #undef __le64
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #undef __BIG_ENDIAN_BITFIELD
 #endif
 
diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index c0f0fab28a1f..ef7d3bb76140 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -34,13 +34,13 @@
 
 /* some important defines:
  *
- * HOST_WORDS_BIGENDIAN : if defined, the host cpu is big endian and
+ * HOST_BIG_ENDIAN : whether the host cpu is big endian and
  * otherwise little endian.
  *
  * TARGET_WORDS_BIGENDIAN : same for target cpu
  */
 
-#if defined(HOST_WORDS_BIGENDIAN) != defined(TARGET_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN != defined(TARGET_WORDS_BIGENDIAN)
 #define BSWAP_NEEDED
 #endif
 
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 7f7b5943c7bc..e8fdb143ff2c 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -46,7 +46,7 @@ enum device_endian {
     DEVICE_LITTLE_ENDIAN,
 };
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define DEVICE_HOST_ENDIAN DEVICE_BIG_ENDIAN
 #else
 #define DEVICE_HOST_ENDIAN DEVICE_LITTLE_ENDIAN
diff --git a/include/exec/memop.h b/include/exec/memop.h
index 2a885f3917b4..44f923ed4660 100644
--- a/include/exec/memop.h
+++ b/include/exec/memop.h
@@ -28,7 +28,7 @@ typedef enum MemOp {
     MO_SIGN  = 0x08,   /* Sign-extended, otherwise zero-extended.  */
 
     MO_BSWAP = 0x10,   /* Host reverse endian.  */
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     MO_LE    = MO_BSWAP,
     MO_BE    = 0,
 #else
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 4d5997e6bbae..e40653f0d19e 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -2931,7 +2931,7 @@ static inline MemOp devend_memop(enum device_endian end)
     QEMU_BUILD_BUG_ON(DEVICE_HOST_ENDIAN != DEVICE_LITTLE_ENDIAN &&
                       DEVICE_HOST_ENDIAN != DEVICE_BIG_ENDIAN);
 
-#if defined(HOST_WORDS_BIGENDIAN) != defined(TARGET_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN != defined(TARGET_WORDS_BIGENDIAN)
     /* Swap if non-host endianness or native (target) endianness */
     return (end == DEVICE_HOST_ENDIAN) ? 0 : MO_BSWAP;
 #else
diff --git a/include/fpu/softfloat-types.h b/include/fpu/softfloat-types.h
index 8abd9ab4ec9c..7a6ea881d83e 100644
--- a/include/fpu/softfloat-types.h
+++ b/include/fpu/softfloat-types.h
@@ -103,7 +103,7 @@ typedef struct {
 #define make_floatx80(exp, mant) ((floatx80) { mant, exp })
 #define make_floatx80_init(exp, mant) { .low = mant, .high = exp }
 typedef struct {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     uint64_t high, low;
 #else
     uint64_t low, high;
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 136973655c1a..b0e2e5b9d253 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -187,7 +187,7 @@ struct CPUClass {
 typedef union IcountDecr {
     uint32_t u32;
     struct {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
         uint16_t high;
         uint16_t low;
 #else
diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index 3b5ac869db6e..bfa982a41957 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -145,7 +145,7 @@ enum {
 /* Interrupt Remapping Table Entry Definition */
 union VTD_IR_TableEntry {
     struct {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
         uint32_t __reserved_1:8;     /* Reserved 1 */
         uint32_t vector:8;           /* Interrupt Vector */
         uint32_t irte_mode:1;        /* IRTE Mode */
@@ -172,7 +172,7 @@ union VTD_IR_TableEntry {
 #endif
         uint32_t dest_id;            /* Destination ID */
         uint16_t source_id;          /* Source-ID */
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
         uint64_t __reserved_2:44;    /* Reserved 2 */
         uint64_t sid_vtype:2;        /* Source-ID Validation Type */
         uint64_t sid_q:2;            /* Source-ID Qualifier */
@@ -191,7 +191,7 @@ union VTD_IR_TableEntry {
 /* Programming format for MSI/MSI-X addresses */
 union VTD_IR_MSIAddress {
     struct {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
         uint32_t __head:12;          /* Should always be: 0x0fee */
         uint32_t index_l:15;         /* Interrupt index bit 14-0 */
         uint32_t int_mode:1;         /* Interrupt format */
diff --git a/include/hw/i386/x86-iommu.h b/include/hw/i386/x86-iommu.h
index 5ba0c056d60c..7637edb430a4 100644
--- a/include/hw/i386/x86-iommu.h
+++ b/include/hw/i386/x86-iommu.h
@@ -87,7 +87,7 @@ struct X86IOMMUIrq {
 struct X86IOMMU_MSIMessage {
     union {
         struct {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
             uint32_t __addr_head:12; /* 0xfee */
             uint32_t dest:8;
             uint32_t __reserved:8;
@@ -108,7 +108,7 @@ struct X86IOMMU_MSIMessage {
     };
     union {
         struct {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
             uint16_t trigger_mode:1;
             uint16_t level:1;
             uint16_t __resved:3;
diff --git a/include/hw/virtio/virtio-access.h b/include/hw/virtio/virtio-access.h
index 6818a23a2d35..90cbb77782b5 100644
--- a/include/hw/virtio/virtio-access.h
+++ b/include/hw/virtio/virtio-access.h
@@ -149,7 +149,7 @@ static inline uint64_t virtio_ldq_p(VirtIODevice *vdev, const void *ptr)
 
 static inline uint16_t virtio_tswap16(VirtIODevice *vdev, uint16_t s)
 {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     return virtio_access_is_big_endian(vdev) ? s : bswap16(s);
 #else
     return virtio_access_is_big_endian(vdev) ? bswap16(s) : s;
@@ -215,7 +215,7 @@ static inline void virtio_tswap16s(VirtIODevice *vdev, uint16_t *s)
 
 static inline uint32_t virtio_tswap32(VirtIODevice *vdev, uint32_t s)
 {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     return virtio_access_is_big_endian(vdev) ? s : bswap32(s);
 #else
     return virtio_access_is_big_endian(vdev) ? bswap32(s) : s;
@@ -229,7 +229,7 @@ static inline void virtio_tswap32s(VirtIODevice *vdev, uint32_t *s)
 
 static inline uint64_t virtio_tswap64(VirtIODevice *vdev, uint64_t s)
 {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     return virtio_access_is_big_endian(vdev) ? s : bswap64(s);
 #else
     return virtio_access_is_big_endian(vdev) ? bswap64(s) : s;
diff --git a/include/hw/virtio/virtio-gpu-bswap.h b/include/hw/virtio/virtio-gpu-bswap.h
index 5faac0d8d5f3..912410848597 100644
--- a/include/hw/virtio/virtio-gpu-bswap.h
+++ b/include/hw/virtio/virtio-gpu-bswap.h
@@ -29,7 +29,7 @@ virtio_gpu_ctrl_hdr_bswap(struct virtio_gpu_ctrl_hdr *hdr)
 static inline void
 virtio_gpu_bswap_32(void *ptr, size_t size)
 {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 
     size_t i;
     struct virtio_gpu_ctrl_hdr *hdr = (struct virtio_gpu_ctrl_hdr *) ptr;
diff --git a/include/libdecnumber/dconfig.h b/include/libdecnumber/dconfig.h
index 0f7dccef1f4e..2bc0ba7f1444 100644
--- a/include/libdecnumber/dconfig.h
+++ b/include/libdecnumber/dconfig.h
@@ -28,7 +28,7 @@
    02110-1301, USA.  */
 
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define WORDS_BIGENDIAN 1
 #else
 #define WORDS_BIGENDIAN 0
diff --git a/include/net/eth.h b/include/net/eth.h
index 7767ae880ecc..6e699b0d7a4a 100644
--- a/include/net/eth.h
+++ b/include/net/eth.h
@@ -159,7 +159,7 @@ struct tcp_hdr {
     u_short     th_dport;   /* destination port */
     uint32_t    th_seq;     /* sequence number */
     uint32_t    th_ack;     /* acknowledgment number */
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     u_char  th_off : 4,     /* data offset */
         th_x2:4;            /* (unused) */
 #else
diff --git a/include/qemu/bswap.h b/include/qemu/bswap.h
index 2d3bb8bbedda..9dff7c7dbbc9 100644
--- a/include/qemu/bswap.h
+++ b/include/qemu/bswap.h
@@ -84,7 +84,7 @@ static inline void bswap64s(uint64_t *s)
     *s = bswap64(*s);
 }
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define be_bswap(v, size) (v)
 #define le_bswap(v, size) glue(bswap, size)(v)
 #define be_bswaps(v, size)
@@ -188,7 +188,7 @@ CPU_CONVERT(le, 64, uint64_t)
  * a compile-time constant if you pass in a constant.  So this can be
  * used to initialize static variables.
  */
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 # define const_le32(_x)                          \
     ((((_x) & 0x000000ffU) << 24) |              \
      (((_x) & 0x0000ff00U) <<  8) |              \
@@ -211,7 +211,7 @@ typedef union {
 
 typedef union {
     float64 d;
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     struct {
         uint32_t upper;
         uint32_t lower;
@@ -235,7 +235,7 @@ typedef union {
 
 typedef union {
     float128 q;
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     struct {
         uint32_t upmost;
         uint32_t upper;
diff --git a/include/qemu/compiler.h b/include/qemu/compiler.h
index 0a5e67fb970e..7fdd88adb368 100644
--- a/include/qemu/compiler.h
+++ b/include/qemu/compiler.h
@@ -7,6 +7,8 @@
 #ifndef COMPILER_H
 #define COMPILER_H
 
+#define HOST_BIG_ENDIAN (__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__)
+
 #if defined __clang_analyzer__ || defined __COVERITY__
 #define QEMU_STATIC_ANALYSIS 1
 #endif
diff --git a/include/qemu/host-utils.h b/include/qemu/host-utils.h
index ca979dc6ccde..f19bd2910563 100644
--- a/include/qemu/host-utils.h
+++ b/include/qemu/host-utils.h
@@ -88,7 +88,7 @@ static inline uint64_t muldiv64(uint64_t a, uint32_t b, uint32_t c)
     union {
         uint64_t ll;
         struct {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
             uint32_t high, low;
 #else
             uint32_t low, high;
diff --git a/include/qemu/int128.h b/include/qemu/int128.h
index 2c4064256cdf..37e07fd6dd92 100644
--- a/include/qemu/int128.h
+++ b/include/qemu/int128.h
@@ -205,7 +205,7 @@ typedef struct Int128 Int128;
  * a union with other integer types).
  */
 struct Int128 {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     int64_t hi;
     uint64_t lo;
 #else
diff --git a/include/ui/qemu-pixman.h b/include/ui/qemu-pixman.h
index 806ddcd7cdab..0c775604d173 100644
--- a/include/ui/qemu-pixman.h
+++ b/include/ui/qemu-pixman.h
@@ -19,7 +19,7 @@
  * feeding libjpeg / libpng and writing screenshots.
  */
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 # define PIXMAN_BE_r8g8b8     PIXMAN_r8g8b8
 # define PIXMAN_BE_x8r8g8b8   PIXMAN_x8r8g8b8
 # define PIXMAN_BE_a8r8g8b8   PIXMAN_a8r8g8b8
diff --git a/net/util.h b/net/util.h
index 358185fd5034..288312979f09 100644
--- a/net/util.h
+++ b/net/util.h
@@ -30,7 +30,7 @@
  * Structure of an internet header, naked of options.
  */
 struct ip {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     uint8_t ip_v:4,         /* version */
             ip_hl:4;        /* header length */
 #else
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 157f214cce12..ae45fdfbb5ce 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -95,7 +95,7 @@ enum {
  * therefore useful to be able to pass TCG the offset of the least
  * significant half of a uint64_t struct member.
  */
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define offsetoflow32(S, M) (offsetof(S, M) + sizeof(uint32_t))
 #define offsetofhigh32(S, M) offsetof(S, M)
 #else
@@ -382,7 +382,7 @@ typedef struct CPUArchState {
         union { /* Fault address registers. */
             struct {
                 uint64_t _unused_far0;
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
                 uint32_t ifar_ns;
                 uint32_t dfar_ns;
                 uint32_t ifar_s;
@@ -419,7 +419,7 @@ typedef struct CPUArchState {
         uint64_t c9_pminten; /* perf monitor interrupt enables */
         union { /* Memory attribute redirection */
             struct {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
                 uint64_t _unused_mair_0;
                 uint32_t mair1_ns;
                 uint32_t mair0_ns;
@@ -1092,7 +1092,7 @@ void aarch64_add_pauth_properties(Object *obj);
  */
 static inline uint64_t *sve_bswap64(uint64_t *dst, uint64_t *src, int nr)
 {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     int i;
 
     for (i = 0; i < nr; ++i) {
diff --git a/target/arm/translate-a64.h b/target/arm/translate-a64.h
index 58f50abca469..38884158aab3 100644
--- a/target/arm/translate-a64.h
+++ b/target/arm/translate-a64.h
@@ -71,7 +71,7 @@ static inline int vec_reg_offset(DisasContext *s, int regno,
 {
     int element_size = 1 << size;
     int offs = element * element_size;
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     /* This is complicated slightly because vfp.zregs[n].d[0] is
      * still the lowest and vfp.zregs[n].d[15] the highest of the
      * 256 byte vector, even on big endian systems.
diff --git a/target/arm/vec_internal.h b/target/arm/vec_internal.h
index 2a3355829068..fb43a2380e21 100644
--- a/target/arm/vec_internal.h
+++ b/target/arm/vec_internal.h
@@ -29,7 +29,7 @@
  * The H1_<N> macros are used when performing byte arithmetic and then
  * casting the final pointer to a type of size N.
  */
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define H1(x)   ((x) ^ 7)
 #define H1_2(x) ((x) ^ 6)
 #define H1_4(x) ((x) ^ 4)
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 5e406088a91a..5124c1e307b5 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1246,7 +1246,7 @@ typedef struct BNDCSReg {
 #define BNDCFG_BNDPRESERVE  2ULL
 #define BNDCFG_BDIR_MASK    TARGET_PAGE_MASK
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define ZMM_B(n) _b_ZMMReg[63 - (n)]
 #define ZMM_W(n) _w_ZMMReg[31 - (n)]
 #define ZMM_L(n) _l_ZMMReg[15 - (n)]
diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 52ce08a94d36..5335ac10a3dc 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -35,7 +35,7 @@ union fpr_t {
  *define FP_ENDIAN_IDX to access the same location
  * in the fpr_t union regardless of the host endianness
  */
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #  define FP_ENDIAN_IDX 1
 #else
 #  define FP_ENDIAN_IDX 0
diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
index 047b24ba50ea..627e574127ba 100644
--- a/target/ppc/cpu.h
+++ b/target/ppc/cpu.h
@@ -2642,7 +2642,7 @@ static inline bool lsw_reg_in_range(int start, int nregs, int rx)
 }
 
 /* Accessors for FP, VMX and VSX registers */
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define VsrB(i) u8[i]
 #define VsrSB(i) s8[i]
 #define VsrH(i) u16[i]
diff --git a/target/s390x/tcg/vec.h b/target/s390x/tcg/vec.h
index a6e361869b2e..8d095efcfc6f 100644
--- a/target/s390x/tcg/vec.h
+++ b/target/s390x/tcg/vec.h
@@ -38,7 +38,7 @@ typedef union S390Vector {
  * W:  [             1][             0] - [             3][             2]
  * DW: [                             0] - [                             1]
  */
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
 #define H1(x)  ((x) ^ 7)
 #define H2(x)  ((x) ^ 3)
 #define H4(x)  ((x) ^ 1)
diff --git a/target/xtensa/cpu.h b/target/xtensa/cpu.h
index 4515f682aa26..a572e831aebf 100644
--- a/target/xtensa/cpu.h
+++ b/target/xtensa/cpu.h
@@ -494,7 +494,7 @@ typedef struct XtensaConfigList {
     struct XtensaConfigList *next;
 } XtensaConfigList;
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 enum {
     FP_F32_HIGH,
     FP_F32_LOW,
diff --git a/tests/fp/platform.h b/tests/fp/platform.h
index c20ba70baa07..6c72ad0cd05b 100644
--- a/tests/fp/platform.h
+++ b/tests/fp/platform.h
@@ -29,9 +29,9 @@
  * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
-#include "config-host.h"
+#include "qemu/compiler.h"
 
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
 #define LITTLEENDIAN 1
 /* otherwise do not define it */
 #endif
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 27864dfaeaaa..6467dd241025 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1202,8 +1202,8 @@ void kvm_hwpoison_page_add(ram_addr_t ram_addr)
 
 static uint32_t adjust_ioeventfd_endianness(uint32_t val, uint32_t size)
 {
-#if defined(HOST_WORDS_BIGENDIAN) != defined(TARGET_WORDS_BIGENDIAN)
-    /* The kernel expects ioeventfd values in HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN != defined(TARGET_WORDS_BIGENDIAN)
+    /* The kernel expects ioeventfd values in HOST_BIG_ENDIAN
      * endianness, but the memory core hands them in target endianness.
      * For example, PPC is always treated as big-endian even if running
      * on KVM and on PPC64LE.  Correct here.
diff --git a/audio/dbusaudio.c b/audio/dbusaudio.c
index f178b47deec1..a3d656d3b017 100644
--- a/audio/dbusaudio.c
+++ b/audio/dbusaudio.c
@@ -122,7 +122,7 @@ static size_t dbus_put_buffer_out(HWVoiceOut *hw, void *buf, size_t size)
     return size;
 }
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define AUDIO_HOST_BE TRUE
 #else
 #define AUDIO_HOST_BE FALSE
diff --git a/disas.c b/disas.c
index 3dab4482d1a1..2d2565ac5774 100644
--- a/disas.c
+++ b/disas.c
@@ -144,7 +144,7 @@ static void initialize_debug_host(CPUDebug *s)
 
     s->info.read_memory_func = host_read_memory;
     s->info.print_address_func = host_print_address;
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     s->info.endian = BFD_ENDIAN_BIG;
 #else
     s->info.endian = BFD_ENDIAN_LITTLE;
diff --git a/hw/core/loader.c b/hw/core/loader.c
index ca2f2431fba7..8d9b2df6e725 100644
--- a/hw/core/loader.c
+++ b/hw/core/loader.c
@@ -474,7 +474,7 @@ ssize_t load_elf_ram_sym(const char *filename,
         ret = ELF_LOAD_NOT_ELF;
         goto fail;
     }
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     data_order = ELFDATA2MSB;
 #else
     data_order = ELFDATA2LSB;
@@ -511,7 +511,7 @@ ssize_t load_elf_ram_sym(const char *filename,
 
 static void bswap_uboot_header(uboot_image_header_t *hdr)
 {
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
     bswap32s(&hdr->ih_magic);
     bswap32s(&hdr->ih_hcrc);
     bswap32s(&hdr->ih_time);
diff --git a/hw/display/artist.c b/hw/display/artist.c
index 1d877998b9ae..69a8f9eea8ba 100644
--- a/hw/display/artist.c
+++ b/hw/display/artist.c
@@ -26,7 +26,7 @@
 #define TYPE_ARTIST "artist"
 OBJECT_DECLARE_SIMPLE_TYPE(ARTISTState, ARTIST)
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define ROP8OFF(_i) (3 - (_i))
 #else
 #define ROP8OFF
@@ -712,7 +712,7 @@ static void combine_write_reg(hwaddr addr, uint64_t val, int size, void *out)
      * FIXME: is there a qemu helper for this?
      */
 
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
     addr ^= 3;
 #endif
 
@@ -1087,7 +1087,7 @@ static uint64_t combine_read_reg(hwaddr addr, int size, void *in)
      * FIXME: is there a qemu helper for this?
      */
 
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
     addr ^= 3;
 #endif
 
diff --git a/hw/display/pxa2xx_lcd.c b/hw/display/pxa2xx_lcd.c
index 2887ce496b47..6ccc1ad9d337 100644
--- a/hw/display/pxa2xx_lcd.c
+++ b/hw/display/pxa2xx_lcd.c
@@ -199,7 +199,7 @@ typedef struct QEMU_PACKED {
         SKIP_PIXEL(to);          \
     } while (0)
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 # define SWAP_WORDS 1
 #endif
 
diff --git a/hw/display/vga.c b/hw/display/vga.c
index 9d1f66af402e..99f88c61cbe7 100644
--- a/hw/display/vga.c
+++ b/hw/display/vga.c
@@ -94,19 +94,19 @@ const uint8_t gr_mask[16] = {
                 (((uint32_t)(__x) & (uint32_t)0x00ff0000UL) >>  8) | \
                 (((uint32_t)(__x) & (uint32_t)0xff000000UL) >> 24) ))
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define PAT(x) cbswap_32(x)
 #else
 #define PAT(x) (x)
 #endif
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define BIG 1
 #else
 #define BIG 0
 #endif
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define GET_PLANE(data, p) (((data) >> (24 - (p) * 8)) & 0xff)
 #else
 #define GET_PLANE(data, p) (((data) >> ((p) * 8)) & 0xff)
@@ -133,7 +133,7 @@ static const uint32_t mask16[16] = {
 
 #undef PAT
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define PAT(x) (x)
 #else
 #define PAT(x) cbswap_32(x)
@@ -1296,7 +1296,7 @@ static void vga_draw_text(VGACommonState *s, int full_update)
                 if (cx > cx_max)
                     cx_max = cx;
                 *ch_attr_ptr = ch_attr;
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
                 ch = ch_attr >> 8;
                 cattr = ch_attr & 0xff;
 #else
@@ -1477,7 +1477,7 @@ static void vga_draw_graphic(VGACommonState *s, int full_update)
     vga_draw_line_func *vga_draw_line = NULL;
     bool share_surface, force_shadow = false;
     pixman_format_code_t format;
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     bool byteswap = !s->big_endian_fb;
 #else
     bool byteswap = s->big_endian_fb;
diff --git a/hw/display/virtio-gpu-gl.c b/hw/display/virtio-gpu-gl.c
index 6cc4313b1af2..0bca8877035e 100644
--- a/hw/display/virtio-gpu-gl.c
+++ b/hw/display/virtio-gpu-gl.c
@@ -108,7 +108,7 @@ static void virtio_gpu_gl_device_realize(DeviceState *qdev, Error **errp)
 {
     VirtIOGPU *g = VIRTIO_GPU(qdev);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     error_setg(errp, "virgl is not supported on bigendian platforms");
     return;
 #endif
diff --git a/hw/s390x/event-facility.c b/hw/s390x/event-facility.c
index 6fa47b889ca4..faa51aa4c70d 100644
--- a/hw/s390x/event-facility.c
+++ b/hw/s390x/event-facility.c
@@ -28,7 +28,7 @@ typedef struct SCLPEventsBus {
 } SCLPEventsBus;
 
 /* we need to save 32 bit chunks for compatibility */
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define RECV_MASK_LOWER 1
 #define RECV_MASK_UPPER 0
 #else /* little endian host */
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index b643f42ea4ec..e55ac32bf3a9 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -989,7 +989,7 @@ static inline bool vhost_needs_vring_endian(VirtIODevice *vdev)
     if (virtio_vdev_has_feature(vdev, VIRTIO_F_VERSION_1)) {
         return false;
     }
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     return vdev->device_endian == VIRTIO_DEVICE_ENDIAN_LITTLE;
 #else
     return vdev->device_endian == VIRTIO_DEVICE_ENDIAN_BIG;
diff --git a/linux-user/arm/nwfpe/double_cpdo.c b/linux-user/arm/nwfpe/double_cpdo.c
index 1cef380852c9..d45ece2e2fe7 100644
--- a/linux-user/arm/nwfpe/double_cpdo.c
+++ b/linux-user/arm/nwfpe/double_cpdo.c
@@ -150,7 +150,7 @@ unsigned int DoubleCPDO(const unsigned int opcode)
       case MNF_CODE:
       {
          unsigned int *p = (unsigned int*)&rFm;
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
          p[0] ^= 0x80000000;
 #else
          p[1] ^= 0x80000000;
@@ -162,7 +162,7 @@ unsigned int DoubleCPDO(const unsigned int opcode)
       case ABS_CODE:
       {
          unsigned int *p = (unsigned int*)&rFm;
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
          p[0] &= 0x7fffffff;
 #else
          p[1] &= 0x7fffffff;
diff --git a/linux-user/arm/nwfpe/fpa11_cpdt.c b/linux-user/arm/nwfpe/fpa11_cpdt.c
index c32b0c2faac0..fee525937c55 100644
--- a/linux-user/arm/nwfpe/fpa11_cpdt.c
+++ b/linux-user/arm/nwfpe/fpa11_cpdt.c
@@ -44,7 +44,7 @@ void loadDouble(const unsigned int Fn, target_ulong addr)
    unsigned int *p;
    p = (unsigned int*)&fpa11->fpreg[Fn].fDouble;
    fpa11->fType[Fn] = typeDouble;
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
    /* FIXME - handle failure of get_user() */
    get_user_u32(p[0], addr); /* sign & exponent */
    get_user_u32(p[1], addr + 4);
@@ -147,7 +147,7 @@ void storeDouble(const unsigned int Fn, target_ulong addr)
       default: val = fpa11->fpreg[Fn].fDouble;
    }
    /* FIXME - handle put_user() failures */
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
    put_user_u32(p[0], addr);	/* msw */
    put_user_u32(p[1], addr + 4);	/* lsw */
 #else
diff --git a/linux-user/ppc/signal.c b/linux-user/ppc/signal.c
index ec0b9c0df3da..2550b8f8c069 100644
--- a/linux-user/ppc/signal.c
+++ b/linux-user/ppc/signal.c
@@ -215,8 +215,7 @@ static target_ulong get_sigframe(struct target_sigaction *ka,
     return (oldsp - frame_size) & ~0xFUL;
 }
 
-#if ((defined(TARGET_WORDS_BIGENDIAN) && defined(HOST_WORDS_BIGENDIAN)) || \
-     (!defined(HOST_WORDS_BIGENDIAN) && !defined(TARGET_WORDS_BIGENDIAN)))
+#if defined(TARGET_WORDS_BIGENDIAN) == HOST_BIG_ENDIAN
 #define PPC_VEC_HI      0
 #define PPC_VEC_LO      1
 #else
diff --git a/linux-user/syscall.c b/linux-user/syscall.c
index b9b18a7eaffb..4de45ec6222e 100644
--- a/linux-user/syscall.c
+++ b/linux-user/syscall.c
@@ -8152,7 +8152,7 @@ static int is_proc_myself(const char *filename, const char *entry)
     return 0;
 }
 
-#if defined(HOST_WORDS_BIGENDIAN) != defined(TARGET_WORDS_BIGENDIAN) || \
+#if HOST_BIG_ENDIAN != defined(TARGET_WORDS_BIGENDIAN) || \
     defined(TARGET_SPARC) || defined(TARGET_M68K) || defined(TARGET_HPPA)
 static int is_proc(const char *filename, const char *entry)
 {
@@ -8160,7 +8160,7 @@ static int is_proc(const char *filename, const char *entry)
 }
 #endif
 
-#if defined(HOST_WORDS_BIGENDIAN) != defined(TARGET_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN != defined(TARGET_WORDS_BIGENDIAN)
 static int open_net_route(void *cpu_env, int fd)
 {
     FILE *fp;
@@ -8246,7 +8246,7 @@ static int do_openat(void *cpu_env, int dirfd, const char *pathname, int flags,
         { "stat", open_self_stat, is_proc_myself },
         { "auxv", open_self_auxv, is_proc_myself },
         { "cmdline", open_self_cmdline, is_proc_myself },
-#if defined(HOST_WORDS_BIGENDIAN) != defined(TARGET_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN != defined(TARGET_WORDS_BIGENDIAN)
         { "/proc/net/route", open_net_route, is_proc },
 #endif
 #if defined(TARGET_SPARC) || defined(TARGET_HPPA)
diff --git a/net/net.c b/net/net.c
index f0d14dbfc1f0..9f17ab204422 100644
--- a/net/net.c
+++ b/net/net.c
@@ -524,7 +524,7 @@ void qemu_set_vnet_hdr_len(NetClientState *nc, int len)
 
 int qemu_set_vnet_le(NetClientState *nc, bool is_le)
 {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     if (!nc || !nc->info->set_vnet_le) {
         return -ENOSYS;
     }
@@ -537,7 +537,7 @@ int qemu_set_vnet_le(NetClientState *nc, bool is_le)
 
 int qemu_set_vnet_be(NetClientState *nc, bool is_be)
 {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     return 0;
 #else
     if (!nc || !nc->info->set_vnet_be) {
diff --git a/target/alpha/translate.c b/target/alpha/translate.c
index 66768ab47ad5..4e887311ab62 100644
--- a/target/alpha/translate.c
+++ b/target/alpha/translate.c
@@ -235,7 +235,7 @@ static TCGv dest_fpr(DisasContext *ctx, unsigned reg)
 static int get_flag_ofs(unsigned shift)
 {
     int ofs = offsetof(CPUAlphaState, flags);
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     ofs += 3 - (shift / 8);
 #else
     ofs += shift / 8;
diff --git a/target/arm/crypto_helper.c b/target/arm/crypto_helper.c
index 28a84c2dbdb6..4c8fd34aecb0 100644
--- a/target/arm/crypto_helper.c
+++ b/target/arm/crypto_helper.c
@@ -23,7 +23,7 @@ union CRYPTO_STATE {
     uint64_t   l[2];
 };
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define CR_ST_BYTE(state, i)   ((state).bytes[(15 - (i)) ^ 8])
 #define CR_ST_WORD(state, i)   ((state).words[(3 - (i)) ^ 2])
 #else
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 088956eecf06..6a6eb0fc8a4c 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -8638,7 +8638,7 @@ static void add_cpreg_to_hashtable(ARMCPU *cpu, const ARMCPRegInfo *r,
                 r2->cp = 15;
             }
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
             if (r2->fieldoffset) {
                 r2->fieldoffset += sizeof(uint32_t);
             }
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index ccadfbbe72be..9ec8875150d6 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -1023,7 +1023,7 @@ static int kvm_arch_put_fpsimd(CPUState *cs)
 
     for (i = 0; i < 32; i++) {
         uint64_t *q = aa64_vfp_qreg(env, i);
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
         uint64_t fp_val[2] = { q[1], q[0] };
         reg.addr = (uintptr_t)fp_val;
 #else
@@ -1242,7 +1242,7 @@ static int kvm_arch_get_fpsimd(CPUState *cs)
         if (ret) {
             return ret;
         } else {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
             uint64_t t;
             t = q[0], q[0] = q[1], q[1] = t;
 #endif
diff --git a/target/arm/neon_helper.c b/target/arm/neon_helper.c
index 338b9189d5b2..bc6c4a54e9d9 100644
--- a/target/arm/neon_helper.c
+++ b/target/arm/neon_helper.c
@@ -23,7 +23,7 @@ typedef struct \
 { \
     type v1; \
 } neon_##name;
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define NEON_TYPE2(name, type) \
 typedef struct \
 { \
diff --git a/target/arm/sve_helper.c b/target/arm/sve_helper.c
index 07be55b7e1ad..d1ea26f1f774 100644
--- a/target/arm/sve_helper.c
+++ b/target/arm/sve_helper.c
@@ -2802,7 +2802,7 @@ static void swap_memmove(void *vd, void *vs, size_t n)
     uintptr_t o = (d | s | n) & 7;
     size_t i;
 
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
     o = 0;
 #endif
     switch (o) {
@@ -2864,7 +2864,7 @@ static void swap_memzero(void *vd, size_t n)
         return;
     }
 
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
     o = 0;
 #endif
     switch (o) {
diff --git a/target/arm/translate-sve.c b/target/arm/translate-sve.c
index 33ca1bcfac38..72132a10323b 100644
--- a/target/arm/translate-sve.c
+++ b/target/arm/translate-sve.c
@@ -2872,7 +2872,7 @@ static TCGv_i64 load_last_active(DisasContext *s, TCGv_i32 last,
      * The final adjustment for the vector register base
      * is added via constant offset to the load.
      */
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     /* Adjust for element ordering.  See vec_reg_offset.  */
     if (esz < 3) {
         tcg_gen_xori_i32(last, last, 8 - (1 << esz));
@@ -5711,7 +5711,7 @@ static void do_ldrq(DisasContext *s, int zt, int pg, TCGv_i64 addr, int dtype)
          * for this load operation.
          */
         TCGv_i64 tmp = tcg_temp_new_i64();
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
         poff += 6;
 #endif
         tcg_gen_ld16u_i64(tmp, cpu_env, poff);
@@ -5790,7 +5790,7 @@ static void do_ldro(DisasContext *s, int zt, int pg, TCGv_i64 addr, int dtype)
          * for this load operation.
          */
         TCGv_i64 tmp = tcg_temp_new_i64();
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
         poff += 4;
 #endif
         tcg_gen_ld32u_i64(tmp, cpu_env, poff);
diff --git a/target/arm/translate-vfp.c b/target/arm/translate-vfp.c
index 17f796e32a33..6a95a67a69e5 100644
--- a/target/arm/translate-vfp.c
+++ b/target/arm/translate-vfp.c
@@ -93,7 +93,7 @@ uint64_t vfp_expand_imm(int size, uint8_t imm8)
 static inline long vfp_f16_offset(unsigned reg, bool top)
 {
     long offs = vfp_reg_offset(false, reg);
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     if (!top) {
         offs += 2;
     }
diff --git a/target/arm/translate.c b/target/arm/translate.c
index bf2196b9e24c..e8dfa71364db 100644
--- a/target/arm/translate.c
+++ b/target/arm/translate.c
@@ -1158,7 +1158,7 @@ long neon_element_offset(int reg, int element, MemOp memop)
 {
     int element_size = 1 << (memop & MO_SIZE);
     int ofs = element * element_size;
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     /*
      * Calculate the offset assuming fully little-endian,
      * then XOR to account for the order of the 8-byte units.
diff --git a/target/hppa/translate.c b/target/hppa/translate.c
index 5c0b1eb274aa..0b83ee4d9856 100644
--- a/target/hppa/translate.c
+++ b/target/hppa/translate.c
@@ -566,7 +566,7 @@ static void save_gpr(DisasContext *ctx, unsigned reg, TCGv_reg t)
     }
 }
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 # define HI_OFS  0
 # define LO_OFS  4
 #else
diff --git a/target/i386/tcg/translate.c b/target/i386/tcg/translate.c
index 2a94d3374252..5649bba9a88d 100644
--- a/target/i386/tcg/translate.c
+++ b/target/i386/tcg/translate.c
@@ -359,7 +359,7 @@ static void gen_update_cc_op(DisasContext *s)
 
 #endif /* !TARGET_X86_64 */
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define REG_B_OFFSET (sizeof(target_ulong) - 1)
 #define REG_H_OFFSET (sizeof(target_ulong) - 2)
 #define REG_W_OFFSET (sizeof(target_ulong) - 2)
diff --git a/target/mips/tcg/lmmi_helper.c b/target/mips/tcg/lmmi_helper.c
index abeb7736aeb2..2c8732525ce3 100644
--- a/target/mips/tcg/lmmi_helper.c
+++ b/target/mips/tcg/lmmi_helper.c
@@ -37,7 +37,7 @@ typedef union {
 } LMIValue;
 
 /* Some byte ordering issues can be mitigated by XORing in the following.  */
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 # define BYTE_ORDER_XOR(N) N
 #else
 # define BYTE_ORDER_XOR(N) 0
diff --git a/target/mips/tcg/msa_helper.c b/target/mips/tcg/msa_helper.c
index 5667b1f0a15c..389c42e4baa3 100644
--- a/target/mips/tcg/msa_helper.c
+++ b/target/mips/tcg/msa_helper.c
@@ -4146,7 +4146,7 @@ void helper_msa_ilvev_b(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->b[8]  = pws->b[9];
     pwd->b[9]  = pwt->b[9];
     pwd->b[10] = pws->b[11];
@@ -4190,7 +4190,7 @@ void helper_msa_ilvev_h(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->h[4] = pws->h[5];
     pwd->h[5] = pwt->h[5];
     pwd->h[6] = pws->h[7];
@@ -4218,7 +4218,7 @@ void helper_msa_ilvev_w(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->w[2] = pws->w[3];
     pwd->w[3] = pwt->w[3];
     pwd->w[0] = pws->w[1];
@@ -4250,7 +4250,7 @@ void helper_msa_ilvod_b(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->b[7]  = pwt->b[6];
     pwd->b[6]  = pws->b[6];
     pwd->b[5]  = pwt->b[4];
@@ -4294,7 +4294,7 @@ void helper_msa_ilvod_h(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->h[3] = pwt->h[2];
     pwd->h[2] = pws->h[2];
     pwd->h[1] = pwt->h[0];
@@ -4322,7 +4322,7 @@ void helper_msa_ilvod_w(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->w[1] = pwt->w[0];
     pwd->w[0] = pws->w[0];
     pwd->w[3] = pwt->w[2];
@@ -4354,7 +4354,7 @@ void helper_msa_ilvl_b(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->b[7]  = pwt->b[15];
     pwd->b[6]  = pws->b[15];
     pwd->b[5]  = pwt->b[14];
@@ -4398,7 +4398,7 @@ void helper_msa_ilvl_h(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->h[3] = pwt->h[7];
     pwd->h[2] = pws->h[7];
     pwd->h[1] = pwt->h[6];
@@ -4426,7 +4426,7 @@ void helper_msa_ilvl_w(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->w[1] = pwt->w[3];
     pwd->w[0] = pws->w[3];
     pwd->w[3] = pwt->w[2];
@@ -4458,7 +4458,7 @@ void helper_msa_ilvr_b(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->b[8]  = pws->b[0];
     pwd->b[9]  = pwt->b[0];
     pwd->b[10] = pws->b[1];
@@ -4502,7 +4502,7 @@ void helper_msa_ilvr_h(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->h[4] = pws->h[0];
     pwd->h[5] = pwt->h[0];
     pwd->h[6] = pws->h[1];
@@ -4530,7 +4530,7 @@ void helper_msa_ilvr_w(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->w[2] = pws->w[0];
     pwd->w[3] = pwt->w[0];
     pwd->w[0] = pws->w[1];
@@ -4661,7 +4661,7 @@ void helper_msa_pckev_b(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->b[8]  = pws->b[9];
     pwd->b[10] = pws->b[13];
     pwd->b[12] = pws->b[1];
@@ -4705,7 +4705,7 @@ void helper_msa_pckev_h(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->h[4] = pws->h[5];
     pwd->h[6] = pws->h[1];
     pwd->h[0] = pwt->h[5];
@@ -4733,7 +4733,7 @@ void helper_msa_pckev_w(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->w[2] = pws->w[3];
     pwd->w[0] = pwt->w[3];
     pwd->w[3] = pws->w[1];
@@ -4765,7 +4765,7 @@ void helper_msa_pckod_b(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->b[7]  = pwt->b[6];
     pwd->b[5]  = pwt->b[2];
     pwd->b[3]  = pwt->b[14];
@@ -4810,7 +4810,7 @@ void helper_msa_pckod_h(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->h[3] = pwt->h[2];
     pwd->h[1] = pwt->h[6];
     pwd->h[7] = pws->h[2];
@@ -4838,7 +4838,7 @@ void helper_msa_pckod_w(CPUMIPSState *env,
     wr_t *pws = &(env->active_fpu.fpr[ws].wr);
     wr_t *pwt = &(env->active_fpu.fpr[wt].wr);
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     pwd->w[1] = pwt->w[0];
     pwd->w[3] = pws->w[0];
     pwd->w[0] = pwt->w[2];
@@ -5926,7 +5926,7 @@ void helper_msa_copy_s_b(CPUMIPSState *env, uint32_t rd,
                          uint32_t ws, uint32_t n)
 {
     n %= 16;
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     if (n < 8) {
         n = 8 - n - 1;
     } else {
@@ -5940,7 +5940,7 @@ void helper_msa_copy_s_h(CPUMIPSState *env, uint32_t rd,
                          uint32_t ws, uint32_t n)
 {
     n %= 8;
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     if (n < 4) {
         n = 4 - n - 1;
     } else {
@@ -5954,7 +5954,7 @@ void helper_msa_copy_s_w(CPUMIPSState *env, uint32_t rd,
                          uint32_t ws, uint32_t n)
 {
     n %= 4;
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     if (n < 2) {
         n = 2 - n - 1;
     } else {
@@ -5975,7 +5975,7 @@ void helper_msa_copy_u_b(CPUMIPSState *env, uint32_t rd,
                          uint32_t ws, uint32_t n)
 {
     n %= 16;
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     if (n < 8) {
         n = 8 - n - 1;
     } else {
@@ -5989,7 +5989,7 @@ void helper_msa_copy_u_h(CPUMIPSState *env, uint32_t rd,
                          uint32_t ws, uint32_t n)
 {
     n %= 8;
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     if (n < 4) {
         n = 4 - n - 1;
     } else {
@@ -6003,7 +6003,7 @@ void helper_msa_copy_u_w(CPUMIPSState *env, uint32_t rd,
                          uint32_t ws, uint32_t n)
 {
     n %= 4;
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     if (n < 2) {
         n = 2 - n - 1;
     } else {
@@ -6019,7 +6019,7 @@ void helper_msa_insert_b(CPUMIPSState *env, uint32_t wd,
     wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
     target_ulong rs = env->active_tc.gpr[rs_num];
     n %= 16;
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     if (n < 8) {
         n = 8 - n - 1;
     } else {
@@ -6035,7 +6035,7 @@ void helper_msa_insert_h(CPUMIPSState *env, uint32_t wd,
     wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
     target_ulong rs = env->active_tc.gpr[rs_num];
     n %= 8;
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     if (n < 4) {
         n = 4 - n - 1;
     } else {
@@ -6051,7 +6051,7 @@ void helper_msa_insert_w(CPUMIPSState *env, uint32_t wd,
     wr_t *pwd = &(env->active_fpu.fpr[wd].wr);
     target_ulong rs = env->active_tc.gpr[rs_num];
     n %= 4;
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     if (n < 2) {
         n = 2 - n - 1;
     } else {
diff --git a/target/ppc/arch_dump.c b/target/ppc/arch_dump.c
index 993740897d83..1139cead9fed 100644
--- a/target/ppc/arch_dump.c
+++ b/target/ppc/arch_dump.c
@@ -161,7 +161,7 @@ static void ppc_write_elf_vmxregset(NoteFuncArg *arg, PowerPCCPU *cpu)
         bool needs_byteswap;
         ppc_avr_t *avr = cpu_avr_ptr(&cpu->env, i);
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
         needs_byteswap = s->dump_info.d_endian == ELFDATA2LSB;
 #else
         needs_byteswap = s->dump_info.d_endian == ELFDATA2MSB;
diff --git a/target/ppc/int_helper.c b/target/ppc/int_helper.c
index 492f34c4992b..8c1674510bb3 100644
--- a/target/ppc/int_helper.c
+++ b/target/ppc/int_helper.c
@@ -425,7 +425,7 @@ uint64_t helper_PEXTD(uint64_t src, uint64_t mask)
 
 /*****************************************************************************/
 /* Altivec extension helpers */
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define VECTOR_FOR_INORDER_I(index, element)                    \
     for (index = 0; index < ARRAY_SIZE(r->element); index++)
 #else
@@ -1177,7 +1177,7 @@ XXGENPCV(XXGENPCVDM, 8)
 #undef XXGENPCV_LE_COMP
 #undef XXGENPCV
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define VBPERMQ_INDEX(avr, i) ((avr)->u8[(i)])
 #define VBPERMD_INDEX(i) (i)
 #define VBPERMQ_DW(index) (((index) & 0x40) != 0)
@@ -1298,7 +1298,7 @@ void helper_vpmsumd(ppc_avr_t *r, ppc_avr_t *a, ppc_avr_t *b)
 }
 
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define PKBIG 1
 #else
 #define PKBIG 0
@@ -1307,7 +1307,7 @@ void helper_vpkpx(ppc_avr_t *r, ppc_avr_t *a, ppc_avr_t *b)
 {
     int i, j;
     ppc_avr_t result;
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     const ppc_avr_t *x[2] = { a, b };
 #else
     const ppc_avr_t *x[2] = { b, a };
@@ -1516,7 +1516,7 @@ void helper_vslo(ppc_avr_t *r, ppc_avr_t *a, ppc_avr_t *b)
 {
     int sh = (b->VsrB(0xf) >> 3) & 0xf;
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     memmove(&r->u8[0], &a->u8[sh], 16 - sh);
     memset(&r->u8[16 - sh], 0, sh);
 #else
@@ -1525,7 +1525,7 @@ void helper_vslo(ppc_avr_t *r, ppc_avr_t *a, ppc_avr_t *b)
 #endif
 }
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define ELEM_ADDR(VEC, IDX, SIZE) (&(VEC)->u8[IDX])
 #else
 #define ELEM_ADDR(VEC, IDX, SIZE) (&(VEC)->u8[15 - (IDX)] - (SIZE) + 1)
@@ -1554,7 +1554,7 @@ VINSX(W, uint32_t)
 VINSX(D, uint64_t)
 #undef ELEM_ADDR
 #undef VINSX
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define VEXTDVLX(NAME, SIZE) \
 void helper_##NAME(CPUPPCState *env, ppc_avr_t *t, ppc_avr_t *a, ppc_avr_t *b, \
                    target_ulong index)                                         \
@@ -1593,7 +1593,7 @@ VEXTDVLX(VEXTDUHVLX, 2)
 VEXTDVLX(VEXTDUWVLX, 4)
 VEXTDVLX(VEXTDDVLX, 8)
 #undef VEXTDVLX
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define VEXTRACT(suffix, element)                                            \
     void helper_vextract##suffix(ppc_avr_t *r, ppc_avr_t *b, uint32_t index) \
     {                                                                        \
@@ -1750,7 +1750,7 @@ void helper_vsro(ppc_avr_t *r, ppc_avr_t *a, ppc_avr_t *b)
 {
     int sh = (b->VsrB(0xf) >> 3) & 0xf;
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     memmove(&r->u8[sh], &a->u8[0], 16 - sh);
     memset(&r->u8[0], 0, sh);
 #else
@@ -1867,7 +1867,7 @@ void helper_vsum4ubs(CPUPPCState *env, ppc_avr_t *r, ppc_avr_t *a, ppc_avr_t *b)
     }
 }
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define UPKHI 1
 #define UPKLO 0
 #else
@@ -1974,7 +1974,7 @@ VGENERIC_DO(popcntd, u64)
 
 #undef VGENERIC_DO
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define QW_ONE { .u64 = { 0, 1 } }
 #else
 #define QW_ONE { .u64 = { 1, 0 } }
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index dc93b99189ea..d1f07c4f41d4 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -632,7 +632,7 @@ static int kvm_put_fp(CPUState *cs)
             uint64_t *fpr = cpu_fpr_ptr(&cpu->env, i);
             uint64_t *vsrl = cpu_vsrl_ptr(&cpu->env, i);
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
             vsr[0] = float64_val(*fpr);
             vsr[1] = *vsrl;
 #else
@@ -710,7 +710,7 @@ static int kvm_get_fp(CPUState *cs)
                                         strerror(errno));
                 return ret;
             } else {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
                 *fpr = vsr[0];
                 if (vsx) {
                     *vsrl = vsr[1];
diff --git a/target/ppc/mem_helper.c b/target/ppc/mem_helper.c
index 39945d9ea585..f1c76a7750ab 100644
--- a/target/ppc/mem_helper.c
+++ b/target/ppc/mem_helper.c
@@ -461,7 +461,7 @@ uint32_t helper_stqcx_be_parallel(CPUPPCState *env, target_ulong addr,
 
 /*****************************************************************************/
 /* Altivec extension helpers */
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
 #define HI_IDX 0
 #define LO_IDX 1
 #else
diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
index 3bd4aac9c970..7a6ce0a3bc7d 100644
--- a/target/riscv/vector_helper.c
+++ b/target/riscv/vector_helper.c
@@ -79,7 +79,7 @@ target_ulong HELPER(vsetvl)(CPURISCVState *env, target_ulong s1,
  * Note that vector data is stored in host-endian 64-bit chunks,
  * so addressing units smaller than that needs a host-endian fixup.
  */
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define H1(x)   ((x) ^ 7)
 #define H1_2(x) ((x) ^ 6)
 #define H1_4(x) ((x) ^ 4)
diff --git a/target/s390x/tcg/translate.c b/target/s390x/tcg/translate.c
index 904b51542f7c..9299cbf34034 100644
--- a/target/s390x/tcg/translate.c
+++ b/target/s390x/tcg/translate.c
@@ -263,7 +263,7 @@ static inline int vec_reg_offset(uint8_t reg, uint8_t enr, MemOp es)
      * 16 byte operations to handle it in a special way.
      */
     g_assert(es <= MO_64);
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
     offs ^= (8 - bytes);
 #endif
     return offs + vec_full_reg_offset(reg);
diff --git a/target/sparc/vis_helper.c b/target/sparc/vis_helper.c
index f917e5992dc7..3afdc6975cff 100644
--- a/target/sparc/vis_helper.c
+++ b/target/sparc/vis_helper.c
@@ -42,7 +42,7 @@ target_ulong helper_array8(target_ulong pixel_addr, target_ulong cubesize)
         GET_FIELD_SP(pixel_addr, 11, 12);
 }
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 #define VIS_B64(n) b[7 - (n)]
 #define VIS_W64(n) w[3 - (n)]
 #define VIS_SW64(n) sw[3 - (n)]
@@ -470,7 +470,7 @@ uint64_t helper_bshuffle(uint64_t gsr, uint64_t src1, uint64_t src2)
     uint32_t i, mask, host;
 
     /* Set up S such that we can index across all of the bytes.  */
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     s.ll[0] = src1;
     s.ll[1] = src2;
     host = 0;
diff --git a/tcg/tcg-op.c b/tcg/tcg-op.c
index 65e1c94c2d5c..5d48537927b5 100644
--- a/tcg/tcg-op.c
+++ b/tcg/tcg-op.c
@@ -1156,7 +1156,7 @@ void tcg_gen_ld_i64(TCGv_i64 ret, TCGv_ptr arg2, tcg_target_long offset)
 {
     /* Since arg2 and ret have different types,
        they cannot be the same temporary */
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     tcg_gen_ld_i32(TCGV_HIGH(ret), arg2, offset);
     tcg_gen_ld_i32(TCGV_LOW(ret), arg2, offset + 4);
 #else
@@ -1167,7 +1167,7 @@ void tcg_gen_ld_i64(TCGv_i64 ret, TCGv_ptr arg2, tcg_target_long offset)
 
 void tcg_gen_st_i64(TCGv_i64 arg1, TCGv_ptr arg2, tcg_target_long offset)
 {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     tcg_gen_st_i32(TCGV_HIGH(arg1), arg2, offset);
     tcg_gen_st_i32(TCGV_LOW(arg1), arg2, offset + 4);
 #else
diff --git a/tcg/tcg.c b/tcg/tcg.c
index 33a97eabdb83..f8542529d030 100644
--- a/tcg/tcg.c
+++ b/tcg/tcg.c
@@ -51,7 +51,7 @@
 #else
 # define ELF_CLASS  ELFCLASS64
 #endif
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 # define ELF_DATA   ELFDATA2MSB
 #else
 # define ELF_DATA   ELFDATA2LSB
@@ -883,7 +883,7 @@ TCGTemp *tcg_global_mem_new_internal(TCGType type, TCGv_ptr base,
     TCGTemp *base_ts = tcgv_ptr_temp(base);
     TCGTemp *ts = tcg_global_alloc(s);
     int indirect_reg = 0, bigendian = 0;
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     bigendian = 1;
 #endif
 
@@ -1547,7 +1547,7 @@ void tcg_gen_callN(void *func, TCGTemp *ret, int nargs, TCGTemp **args)
         }
 #else
         if (TCG_TARGET_REG_BITS < 64 && (typemask & 6) == dh_typecode_i64) {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
             op->args[pi++] = temp_arg(ret + 1);
             op->args[pi++] = temp_arg(ret);
 #else
@@ -1600,7 +1600,7 @@ void tcg_gen_callN(void *func, TCGTemp *ret, int nargs, TCGTemp **args)
              * have to get more complicated to differentiate between
              * stack arguments and register arguments.
              */
-#if defined(HOST_WORDS_BIGENDIAN) != defined(TCG_TARGET_STACK_GROWSUP)
+#if HOST_BIG_ENDIAN != defined(TCG_TARGET_STACK_GROWSUP)
             op->args[pi++] = temp_arg(args[i] + 1);
             op->args[pi++] = temp_arg(args[i]);
 #else
@@ -3598,7 +3598,7 @@ static void tcg_reg_alloc_dup(TCGContext *s, const TCGOp *op)
         /* fall through */
 
     case TEMP_VAL_MEM:
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
         endian_fixup = itype == TCG_TYPE_I32 ? 4 : 8;
         endian_fixup -= 1 << vece;
 #else
@@ -3879,7 +3879,7 @@ static bool tcg_reg_alloc_dup2(TCGContext *s, const TCGOp *op)
         if (!itsh->mem_coherent) {
             temp_sync(s, itsh, s->reserved_regs, 0, 0);
         }
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
         TCGTemp *its = itsh;
 #else
         TCGTemp *its = itsl;
diff --git a/tests/qtest/vhost-user-blk-test.c b/tests/qtest/vhost-user-blk-test.c
index 62e670f39be0..659b5050d8af 100644
--- a/tests/qtest/vhost-user-blk-test.c
+++ b/tests/qtest/vhost-user-blk-test.c
@@ -37,7 +37,7 @@ typedef struct QVirtioBlkReq {
     uint8_t status;
 } QVirtioBlkReq;
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 static const bool host_is_big_endian = true;
 #else
 static const bool host_is_big_endian; /* false */
diff --git a/tests/qtest/virtio-blk-test.c b/tests/qtest/virtio-blk-test.c
index 2a236982118f..f22594a1a823 100644
--- a/tests/qtest/virtio-blk-test.c
+++ b/tests/qtest/virtio-blk-test.c
@@ -33,7 +33,7 @@ typedef struct QVirtioBlkReq {
 } QVirtioBlkReq;
 
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 const bool host_is_big_endian = true;
 #else
 const bool host_is_big_endian; /* false */
diff --git a/ui/vdagent.c b/ui/vdagent.c
index 7ea4bc5d9a26..02861edfb13c 100644
--- a/ui/vdagent.c
+++ b/ui/vdagent.c
@@ -664,7 +664,7 @@ static void vdagent_chr_open(Chardev *chr,
     VDAgentChardev *vd = QEMU_VDAGENT_CHARDEV(chr);
     ChardevQemuVDAgent *cfg = backend->u.qemu_vdagent.data;
 
-#if defined(HOST_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN
     /*
      * TODO: vdagent protocol is defined to be LE,
      * so we have to byteswap everything on BE hosts.
diff --git a/ui/vnc.c b/ui/vnc.c
index 3ccd33dedcc8..2448384d4e64 100644
--- a/ui/vnc.c
+++ b/ui/vnc.c
@@ -2340,7 +2340,7 @@ static void pixel_format_message (VncState *vs) {
     vnc_write_u8(vs, vs->client_pf.bits_per_pixel); /* bits-per-pixel */
     vnc_write_u8(vs, vs->client_pf.depth); /* depth */
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     vnc_write_u8(vs, 1);             /* big-endian-flag */
 #else
     vnc_write_u8(vs, 0);             /* big-endian-flag */
diff --git a/util/bitmap.c b/util/bitmap.c
index 1f201393aef1..f81d8057a7e6 100644
--- a/util/bitmap.c
+++ b/util/bitmap.c
@@ -376,7 +376,7 @@ static void bitmap_to_from_le(unsigned long *dst,
 {
     long len = BITS_TO_LONGS(nbits);
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     long index;
 
     for (index = 0; index < len; index++) {
diff --git a/util/host-utils.c b/util/host-utils.c
index bcc772b8ec95..96d5dc0bed25 100644
--- a/util/host-utils.c
+++ b/util/host-utils.c
@@ -34,7 +34,7 @@ static inline void mul64(uint64_t *plow, uint64_t *phigh,
     typedef union {
         uint64_t ll;
         struct {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
             uint32_t high, low;
 #else
             uint32_t low, high;
diff --git a/target/ppc/translate/vmx-impl.c.inc b/target/ppc/translate/vmx-impl.c.inc
index 6101bca3fd7a..764ac45409ae 100644
--- a/target/ppc/translate/vmx-impl.c.inc
+++ b/target/ppc/translate/vmx-impl.c.inc
@@ -173,7 +173,7 @@ static void gen_mtvscr(DisasContext *ctx)
 
     val = tcg_temp_new_i32();
     bofs = avr_full_offset(rB(ctx->opcode));
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     bofs += 3 * 4;
 #endif
 
@@ -1692,7 +1692,7 @@ static void gen_vsplt(DisasContext *ctx, int vece)
 
     /* Experimental testing shows that hardware masks the immediate.  */
     bofs += (uimm << vece) & 15;
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
     bofs ^= 15;
     bofs &= ~((1 << vece) - 1);
 #endif
diff --git a/target/ppc/translate/vsx-impl.c.inc b/target/ppc/translate/vsx-impl.c.inc
index e67fbf2bb8ed..c4cc01239ea3 100644
--- a/target/ppc/translate/vsx-impl.c.inc
+++ b/target/ppc/translate/vsx-impl.c.inc
@@ -1552,7 +1552,7 @@ static bool trans_XXSPLTW(DisasContext *ctx, arg_XX2_uim2 *a)
     tofs = vsr_full_offset(a->xt);
     bofs = vsr_full_offset(a->xb);
     bofs += a->uim << MO_32;
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
     bofs ^= 8 | 4;
 #endif
 
diff --git a/target/riscv/insn_trans/trans_rvv.c.inc b/target/riscv/insn_trans/trans_rvv.c.inc
index 275fded6e43b..04b55e5040ba 100644
--- a/target/riscv/insn_trans/trans_rvv.c.inc
+++ b/target/riscv/insn_trans/trans_rvv.c.inc
@@ -3288,7 +3288,7 @@ static void load_element(TCGv_i64 dest, TCGv_ptr base,
 /* offset of the idx element with base regsiter r */
 static uint32_t endian_ofs(DisasContext *s, int r, int idx)
 {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     return vreg_ofs(s, r) + ((idx ^ (7 >> s->sew)) << s->sew);
 #else
     return vreg_ofs(s, r) + (idx << s->sew);
@@ -3298,7 +3298,7 @@ static uint32_t endian_ofs(DisasContext *s, int r, int idx)
 /* adjust the index according to the endian */
 static void endian_adjust(TCGv_i32 ofs, int sew)
 {
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     tcg_gen_xori_i32(ofs, ofs, 7 >> sew);
 #endif
 }
diff --git a/target/s390x/tcg/translate_vx.c.inc b/target/s390x/tcg/translate_vx.c.inc
index 98eb7710a4a9..b829ce0c7c79 100644
--- a/target/s390x/tcg/translate_vx.c.inc
+++ b/target/s390x/tcg/translate_vx.c.inc
@@ -175,7 +175,7 @@ static void get_vec_element_ptr_i64(TCGv_ptr ptr, uint8_t reg, TCGv_i64 enr,
 
     /* convert it to an element offset relative to cpu_env (vec_reg_offset() */
     tcg_gen_shli_i64(tmp, tmp, es);
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
     tcg_gen_xori_i64(tmp, tmp, 8 - NUM_VEC_ELEMENT_BYTES(es));
 #endif
     tcg_gen_addi_i64(tmp, tmp, vec_full_reg_offset(reg));
diff --git a/tcg/aarch64/tcg-target.c.inc b/tcg/aarch64/tcg-target.c.inc
index 077fc5140154..eb38113a70af 100644
--- a/tcg/aarch64/tcg-target.c.inc
+++ b/tcg/aarch64/tcg-target.c.inc
@@ -1557,7 +1557,7 @@ static void tcg_out_adr(TCGContext *s, TCGReg rd, const void *target)
  */
 static void * const qemu_ld_helpers[MO_SIZE + 1] = {
     [MO_8]  = helper_ret_ldub_mmu,
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     [MO_16] = helper_be_lduw_mmu,
     [MO_32] = helper_be_ldul_mmu,
     [MO_64] = helper_be_ldq_mmu,
@@ -1574,7 +1574,7 @@ static void * const qemu_ld_helpers[MO_SIZE + 1] = {
  */
 static void * const qemu_st_helpers[MO_SIZE + 1] = {
     [MO_8]  = helper_ret_stb_mmu,
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     [MO_16] = helper_be_stw_mmu,
     [MO_32] = helper_be_stl_mmu,
     [MO_64] = helper_be_stq_mmu,
diff --git a/tcg/arm/tcg-target.c.inc b/tcg/arm/tcg-target.c.inc
index 4bc0420f4d2f..2c6c353eea2b 100644
--- a/tcg/arm/tcg-target.c.inc
+++ b/tcg/arm/tcg-target.c.inc
@@ -1296,7 +1296,7 @@ static void tcg_out_vldst(TCGContext *s, ARMInsn insn,
 static void * const qemu_ld_helpers[MO_SSIZE + 1] = {
     [MO_UB]   = helper_ret_ldub_mmu,
     [MO_SB]   = helper_ret_ldsb_mmu,
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     [MO_UW] = helper_be_lduw_mmu,
     [MO_UL] = helper_be_ldul_mmu,
     [MO_UQ] = helper_be_ldq_mmu,
@@ -1316,7 +1316,7 @@ static void * const qemu_ld_helpers[MO_SSIZE + 1] = {
  */
 static void * const qemu_st_helpers[MO_SIZE + 1] = {
     [MO_8]   = helper_ret_stb_mmu,
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     [MO_16] = helper_be_stw_mmu,
     [MO_32] = helper_be_stl_mmu,
     [MO_64] = helper_be_stq_mmu,
diff --git a/tcg/mips/tcg-target.c.inc b/tcg/mips/tcg-target.c.inc
index 993149d18a56..bd76f0c97f15 100644
--- a/tcg/mips/tcg-target.c.inc
+++ b/tcg/mips/tcg-target.c.inc
@@ -26,7 +26,7 @@
 
 #include "../tcg-ldst.c.inc"
 
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
 # define MIPS_BE  1
 #else
 # define MIPS_BE  0
diff --git a/tcg/ppc/tcg-target.c.inc b/tcg/ppc/tcg-target.c.inc
index 1f3c5c171cb7..cfcd121f9c23 100644
--- a/tcg/ppc/tcg-target.c.inc
+++ b/tcg/ppc/tcg-target.c.inc
@@ -1864,7 +1864,7 @@ void tb_target_set_jmp_target(uintptr_t tc_ptr, uintptr_t jmp_rx,
             i1 = ADDIS | TAI(TCG_REG_TB, TCG_REG_TB, hi >> 16);
             i2 = ADDI | TAI(TCG_REG_TB, TCG_REG_TB, lo);
         }
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
         pair = (uint64_t)i1 << 32 | i2;
 #else
         pair = (uint64_t)i2 << 32 | i1;
@@ -3235,7 +3235,7 @@ static bool tcg_out_dupm_vec(TCGContext *s, TCGType type, unsigned vece,
             tcg_out_mem_long(s, 0, LVEBX, out, base, offset);
         }
         elt = extract32(offset, 0, 4);
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
         elt ^= 15;
 #endif
         tcg_out32(s, VSPLTB | VRT(out) | VRB(out) | (elt << 16));
@@ -3248,7 +3248,7 @@ static bool tcg_out_dupm_vec(TCGContext *s, TCGType type, unsigned vece,
             tcg_out_mem_long(s, 0, LVEHX, out, base, offset);
         }
         elt = extract32(offset, 1, 3);
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
         elt ^= 7;
 #endif
         tcg_out32(s, VSPLTH | VRT(out) | VRB(out) | (elt << 16));
@@ -3261,7 +3261,7 @@ static bool tcg_out_dupm_vec(TCGContext *s, TCGType type, unsigned vece,
         tcg_debug_assert((offset & 3) == 0);
         tcg_out_mem_long(s, 0, LVEWX, out, base, offset);
         elt = extract32(offset, 2, 2);
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
         elt ^= 3;
 #endif
         tcg_out32(s, VSPLTW | VRT(out) | VRB(out) | (elt << 16));
@@ -3275,7 +3275,7 @@ static bool tcg_out_dupm_vec(TCGContext *s, TCGType type, unsigned vece,
         tcg_out_mem_long(s, 0, LVX, out, base, offset & -16);
         tcg_out_vsldoi(s, TCG_VEC_TMP1, out, out, 8);
         elt = extract32(offset, 3, 1);
-#ifndef HOST_WORDS_BIGENDIAN
+#if !HOST_BIG_ENDIAN
         elt = !elt;
 #endif
         if (elt) {
diff --git a/tcg/riscv/tcg-target.c.inc b/tcg/riscv/tcg-target.c.inc
index 6409d9c3d54f..81a83e45b156 100644
--- a/tcg/riscv/tcg-target.c.inc
+++ b/tcg/riscv/tcg-target.c.inc
@@ -854,7 +854,7 @@ static void tcg_out_mb(TCGContext *s, TCGArg a0)
 static void * const qemu_ld_helpers[MO_SSIZE + 1] = {
     [MO_UB] = helper_ret_ldub_mmu,
     [MO_SB] = helper_ret_ldsb_mmu,
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     [MO_UW] = helper_be_lduw_mmu,
     [MO_SW] = helper_be_ldsw_mmu,
     [MO_UL] = helper_be_ldul_mmu,
@@ -879,7 +879,7 @@ static void * const qemu_ld_helpers[MO_SSIZE + 1] = {
  */
 static void * const qemu_st_helpers[MO_SIZE + 1] = {
     [MO_8]   = helper_ret_stb_mmu,
-#ifdef HOST_WORDS_BIGENDIAN
+#if HOST_BIG_ENDIAN
     [MO_16] = helper_be_stw_mmu,
     [MO_32] = helper_be_stl_mmu,
     [MO_64] = helper_be_stq_mmu,
-- 
2.35.1.273.ge6ebfd0e8cbb

