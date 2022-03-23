Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18364E55D4
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 16:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245333AbiCWQAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 12:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiCWQAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 12:00:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD2377B113
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 08:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648051140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c8bqwAgZ0AQGumIJTXFtFQGIax2LEO4s6wMzj2Mz0d8=;
        b=IYA6oGRzusn0qS/rdp9ie3pEpigTQvXHIuS1an56RsYxX5Cx4UG4tMtfv/CSRyNvkcoMwQ
        /MziqS77laQUGeSWHTMXDF0uIZl0JgI7vY/7l6WxvpVUjaH+R3Tx0Ho9n0Ee9M0EOk892L
        PWdE2CzNrHBmQdrYwnDVRgwckUYnTig=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-lLWr_Q03PWeE1fAK3SS3JQ-1; Wed, 23 Mar 2022 11:58:54 -0400
X-MC-Unique: lLWr_Q03PWeE1fAK3SS3JQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D31E296A60B;
        Wed, 23 Mar 2022 15:58:52 +0000 (UTC)
Received: from localhost (unknown [10.39.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E40258059A;
        Wed, 23 Mar 2022 15:58:48 +0000 (UTC)
From:   marcandre.lureau@redhat.com
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Chris Wulff <crwulff@gmail.com>, Marek Vasut <marex@denx.de>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs),
        qemu-arm@nongnu.org (open list:ARM TCG CPUs),
        qemu-ppc@nongnu.org (open list:PowerPC TCG CPUs)
Subject: [PATCH 07/32] Replace TARGET_WORDS_BIGENDIAN
Date:   Wed, 23 Mar 2022 19:57:18 +0400
Message-Id: <20220323155743.1585078-8-marcandre.lureau@redhat.com>
In-Reply-To: <20220323155743.1585078-1-marcandre.lureau@redhat.com>
References: <20220323155743.1585078-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Convert the TARGET_WORDS_BIGENDIAN macro, similarly to what was done
with HOST_BIG_ENDIAN. The new TARGET_BIG_ENDIAN macro is either 0 or 1,
and thus should always be defined to prevent misuse.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
---
 docs/devel/loads-stores.rst                |  2 +-
 configs/targets/aarch64_be-linux-user.mak  |  2 +-
 configs/targets/armeb-linux-user.mak       |  2 +-
 configs/targets/hppa-linux-user.mak        |  2 +-
 configs/targets/hppa-softmmu.mak           |  2 +-
 configs/targets/m68k-linux-user.mak        |  2 +-
 configs/targets/m68k-softmmu.mak           |  2 +-
 configs/targets/microblaze-linux-user.mak  |  2 +-
 configs/targets/microblaze-softmmu.mak     |  2 +-
 configs/targets/mips-linux-user.mak        |  2 +-
 configs/targets/mips-softmmu.mak           |  2 +-
 configs/targets/mips64-linux-user.mak      |  2 +-
 configs/targets/mips64-softmmu.mak         |  2 +-
 configs/targets/mipsn32-linux-user.mak     |  2 +-
 configs/targets/or1k-linux-user.mak        |  2 +-
 configs/targets/or1k-softmmu.mak           |  2 +-
 configs/targets/ppc-linux-user.mak         |  2 +-
 configs/targets/ppc-softmmu.mak            |  2 +-
 configs/targets/ppc64-linux-user.mak       |  2 +-
 configs/targets/ppc64-softmmu.mak          |  2 +-
 configs/targets/s390x-linux-user.mak       |  2 +-
 configs/targets/s390x-softmmu.mak          |  2 +-
 configs/targets/sh4eb-linux-user.mak       |  2 +-
 configs/targets/sh4eb-softmmu.mak          |  2 +-
 configs/targets/sparc-linux-user.mak       |  2 +-
 configs/targets/sparc-softmmu.mak          |  2 +-
 configs/targets/sparc32plus-linux-user.mak |  2 +-
 configs/targets/sparc64-linux-user.mak     |  2 +-
 configs/targets/sparc64-softmmu.mak        |  2 +-
 configs/targets/xtensaeb-linux-user.mak    |  2 +-
 configs/targets/xtensaeb-softmmu.mak       |  2 +-
 meson.build                                |  5 +++++
 bsd-user/qemu.h                            |  2 +-
 include/exec/cpu-all.h                     |  7 +++----
 include/exec/cpu_ldst.h                    |  2 +-
 include/exec/gdbstub.h                     |  2 +-
 include/exec/memop.h                       |  2 +-
 include/exec/memory.h                      |  2 +-
 include/exec/poison.h                      |  2 +-
 include/hw/core/cpu.h                      |  2 +-
 include/hw/mips/bios.h                     |  2 +-
 include/hw/virtio/virtio-access.h          |  2 +-
 linux-user/aarch64/target_syscall.h        |  2 +-
 linux-user/arm/target_syscall.h            |  2 +-
 linux-user/ppc/target_syscall.h            |  2 +-
 linux-user/qemu.h                          |  2 +-
 linux-user/user-internals.h                |  2 +-
 linux-user/xtensa/target_structs.h         |  2 +-
 target/arm/cpu.h                           |  8 ++++----
 target/xtensa/cpu.h                        |  2 +-
 target/xtensa/overlay_tool.h               |  2 +-
 accel/kvm/kvm-all.c                        |  2 +-
 cpu.c                                      |  2 +-
 disas.c                                    |  2 +-
 hw/arm/armv7m.c                            |  2 +-
 hw/display/vga.c                           |  2 +-
 hw/microblaze/boot.c                       |  2 +-
 hw/mips/gt64xxx_pci.c                      |  6 +++---
 hw/mips/jazz.c                             |  2 +-
 hw/mips/malta.c                            | 24 +++++++++++-----------
 hw/mips/mipssim.c                          |  2 +-
 hw/nios2/boot.c                            |  2 +-
 hw/xtensa/sim.c                            |  2 +-
 hw/xtensa/xtfpga.c                         |  4 ++--
 linux-user/aarch64/cpu_loop.c              |  2 +-
 linux-user/aarch64/signal.c                |  4 ++--
 linux-user/arm/cpu_loop.c                  |  2 +-
 linux-user/elfload.c                       |  6 +++---
 linux-user/ppc/signal.c                    |  4 ++--
 linux-user/syscall.c                       |  6 +++---
 linux-user/uname.c                         |  2 +-
 linux-user/xtensa/signal.c                 |  2 +-
 softmmu/memory.c                           |  2 +-
 softmmu/qtest.c                            |  2 +-
 target/arm/cpu.c                           |  2 +-
 target/mips/cpu.c                          |  4 ++--
 target/mips/tcg/msa_helper.c               | 10 ++++-----
 target/ppc/cpu_init.c                      |  2 +-
 target/ppc/gdbstub.c                       |  4 ++--
 target/ppc/mem_helper.c                    |  2 +-
 target/ppc/translate.c                     |  2 +-
 target/xtensa/translate.c                  |  6 +++---
 tests/tcg/xtensa/Makefile.softmmu-target   |  2 +-
 83 files changed, 120 insertions(+), 116 deletions(-)

diff --git a/docs/devel/loads-stores.rst b/docs/devel/loads-stores.rst
index 8f0035c821bf..ad5dfe133e15 100644
--- a/docs/devel/loads-stores.rst
+++ b/docs/devel/loads-stores.rst
@@ -275,7 +275,7 @@ called during the translator callback ``translate_insn``.
 
 There is a set of functions ending in ``_swap`` which, if the parameter
 is true, returns the value in the endianness that is the reverse of
-the guest native endianness, as determined by ``TARGET_WORDS_BIGENDIAN``.
+the guest native endianness, as determined by ``TARGET_BIG_ENDIAN``.
 
 Function names follow the pattern:
 
diff --git a/configs/targets/aarch64_be-linux-user.mak b/configs/targets/aarch64_be-linux-user.mak
index d3ee10c00f31..77944247459b 100644
--- a/configs/targets/aarch64_be-linux-user.mak
+++ b/configs/targets/aarch64_be-linux-user.mak
@@ -1,6 +1,6 @@
 TARGET_ARCH=aarch64
 TARGET_BASE_ARCH=arm
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_XML_FILES= gdb-xml/aarch64-core.xml gdb-xml/aarch64-fpu.xml
 TARGET_HAS_BFLT=y
 CONFIG_ARM_COMPATIBLE_SEMIHOSTING=y
diff --git a/configs/targets/armeb-linux-user.mak b/configs/targets/armeb-linux-user.mak
index f81e5bf1fe4b..a249cc2e29d6 100644
--- a/configs/targets/armeb-linux-user.mak
+++ b/configs/targets/armeb-linux-user.mak
@@ -1,7 +1,7 @@
 TARGET_ARCH=arm
 TARGET_SYSTBL_ABI=common,oabi
 TARGET_SYSTBL=syscall.tbl
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_XML_FILES= gdb-xml/arm-core.xml gdb-xml/arm-vfp.xml gdb-xml/arm-vfp3.xml gdb-xml/arm-vfp-sysregs.xml gdb-xml/arm-neon.xml gdb-xml/arm-m-profile.xml gdb-xml/arm-m-profile-mve.xml
 TARGET_HAS_BFLT=y
 CONFIG_ARM_COMPATIBLE_SEMIHOSTING=y
diff --git a/configs/targets/hppa-linux-user.mak b/configs/targets/hppa-linux-user.mak
index f01e0a7b9ed8..db873a879688 100644
--- a/configs/targets/hppa-linux-user.mak
+++ b/configs/targets/hppa-linux-user.mak
@@ -2,4 +2,4 @@ TARGET_ARCH=hppa
 TARGET_SYSTBL_ABI=common,32
 TARGET_SYSTBL=syscall.tbl
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
diff --git a/configs/targets/hppa-softmmu.mak b/configs/targets/hppa-softmmu.mak
index e3e71eb21b9a..44f07b033238 100644
--- a/configs/targets/hppa-softmmu.mak
+++ b/configs/targets/hppa-softmmu.mak
@@ -1,4 +1,4 @@
 TARGET_ARCH=hppa
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_SUPPORTS_MTTCG=y
diff --git a/configs/targets/m68k-linux-user.mak b/configs/targets/m68k-linux-user.mak
index 805d16c6ab2d..579b5d299ccf 100644
--- a/configs/targets/m68k-linux-user.mak
+++ b/configs/targets/m68k-linux-user.mak
@@ -1,6 +1,6 @@
 TARGET_ARCH=m68k
 TARGET_SYSTBL_ABI=common
 TARGET_SYSTBL=syscall.tbl
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_XML_FILES= gdb-xml/cf-core.xml gdb-xml/cf-fp.xml gdb-xml/m68k-core.xml gdb-xml/m68k-fp.xml
 TARGET_HAS_BFLT=y
diff --git a/configs/targets/m68k-softmmu.mak b/configs/targets/m68k-softmmu.mak
index 5df1a2b7d76c..bbcd0bada698 100644
--- a/configs/targets/m68k-softmmu.mak
+++ b/configs/targets/m68k-softmmu.mak
@@ -1,3 +1,3 @@
 TARGET_ARCH=m68k
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_XML_FILES= gdb-xml/cf-core.xml gdb-xml/cf-fp.xml gdb-xml/m68k-core.xml gdb-xml/m68k-fp.xml
diff --git a/configs/targets/microblaze-linux-user.mak b/configs/targets/microblaze-linux-user.mak
index 2a25bf2fa39a..4249a37f6528 100644
--- a/configs/targets/microblaze-linux-user.mak
+++ b/configs/targets/microblaze-linux-user.mak
@@ -1,5 +1,5 @@
 TARGET_ARCH=microblaze
 TARGET_SYSTBL_ABI=common
 TARGET_SYSTBL=syscall.tbl
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_HAS_BFLT=y
diff --git a/configs/targets/microblaze-softmmu.mak b/configs/targets/microblaze-softmmu.mak
index 33f2a004029f..8385e2d33363 100644
--- a/configs/targets/microblaze-softmmu.mak
+++ b/configs/targets/microblaze-softmmu.mak
@@ -1,4 +1,4 @@
 TARGET_ARCH=microblaze
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_SUPPORTS_MTTCG=y
 TARGET_NEED_FDT=y
diff --git a/configs/targets/mips-linux-user.mak b/configs/targets/mips-linux-user.mak
index 19f5779831ae..71fa77d464dd 100644
--- a/configs/targets/mips-linux-user.mak
+++ b/configs/targets/mips-linux-user.mak
@@ -3,4 +3,4 @@ TARGET_ABI_MIPSO32=y
 TARGET_SYSTBL_ABI=o32
 TARGET_SYSTBL=syscall_o32.tbl
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
diff --git a/configs/targets/mips-softmmu.mak b/configs/targets/mips-softmmu.mak
index 8a49999a47dd..7787a4d94cf6 100644
--- a/configs/targets/mips-softmmu.mak
+++ b/configs/targets/mips-softmmu.mak
@@ -1,4 +1,4 @@
 TARGET_ARCH=mips
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_SUPPORTS_MTTCG=y
diff --git a/configs/targets/mips64-linux-user.mak b/configs/targets/mips64-linux-user.mak
index 32fd1acdf254..5a4771f22dba 100644
--- a/configs/targets/mips64-linux-user.mak
+++ b/configs/targets/mips64-linux-user.mak
@@ -4,4 +4,4 @@ TARGET_BASE_ARCH=mips
 TARGET_SYSTBL_ABI=n64
 TARGET_SYSTBL=syscall_n64.tbl
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
diff --git a/configs/targets/mips64-softmmu.mak b/configs/targets/mips64-softmmu.mak
index ece25b96242e..568d66650c88 100644
--- a/configs/targets/mips64-softmmu.mak
+++ b/configs/targets/mips64-softmmu.mak
@@ -1,4 +1,4 @@
 TARGET_ARCH=mips64
 TARGET_BASE_ARCH=mips
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
diff --git a/configs/targets/mipsn32-linux-user.mak b/configs/targets/mipsn32-linux-user.mak
index b8c2441ad076..1e80b302fcb5 100644
--- a/configs/targets/mipsn32-linux-user.mak
+++ b/configs/targets/mipsn32-linux-user.mak
@@ -5,4 +5,4 @@ TARGET_BASE_ARCH=mips
 TARGET_SYSTBL_ABI=n32
 TARGET_SYSTBL=syscall_n32.tbl
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
diff --git a/configs/targets/or1k-linux-user.mak b/configs/targets/or1k-linux-user.mak
index 1dfb93e46dc8..39558f77ecfe 100644
--- a/configs/targets/or1k-linux-user.mak
+++ b/configs/targets/or1k-linux-user.mak
@@ -1,2 +1,2 @@
 TARGET_ARCH=openrisc
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
diff --git a/configs/targets/or1k-softmmu.mak b/configs/targets/or1k-softmmu.mak
index 9e1d4a1fb1e5..263e97087094 100644
--- a/configs/targets/or1k-softmmu.mak
+++ b/configs/targets/or1k-softmmu.mak
@@ -1,3 +1,3 @@
 TARGET_ARCH=openrisc
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_NEED_FDT=y
diff --git a/configs/targets/ppc-linux-user.mak b/configs/targets/ppc-linux-user.mak
index ca4187e4aaca..cc0439a52857 100644
--- a/configs/targets/ppc-linux-user.mak
+++ b/configs/targets/ppc-linux-user.mak
@@ -1,5 +1,5 @@
 TARGET_ARCH=ppc
 TARGET_SYSTBL_ABI=common,nospu,32
 TARGET_SYSTBL=syscall.tbl
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_XML_FILES= gdb-xml/power-core.xml gdb-xml/power-fpu.xml gdb-xml/power-altivec.xml gdb-xml/power-spe.xml
diff --git a/configs/targets/ppc-softmmu.mak b/configs/targets/ppc-softmmu.mak
index f4eef1819a66..774440108f7f 100644
--- a/configs/targets/ppc-softmmu.mak
+++ b/configs/targets/ppc-softmmu.mak
@@ -1,4 +1,4 @@
 TARGET_ARCH=ppc
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_XML_FILES= gdb-xml/power-core.xml gdb-xml/power-fpu.xml gdb-xml/power-altivec.xml gdb-xml/power-spe.xml
 TARGET_NEED_FDT=y
diff --git a/configs/targets/ppc64-linux-user.mak b/configs/targets/ppc64-linux-user.mak
index 3133346676cf..4d81969f4a2d 100644
--- a/configs/targets/ppc64-linux-user.mak
+++ b/configs/targets/ppc64-linux-user.mak
@@ -3,5 +3,5 @@ TARGET_BASE_ARCH=ppc
 TARGET_ABI_DIR=ppc
 TARGET_SYSTBL_ABI=common,nospu,64
 TARGET_SYSTBL=syscall.tbl
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_XML_FILES= gdb-xml/power64-core.xml gdb-xml/power-fpu.xml gdb-xml/power-altivec.xml gdb-xml/power-spe.xml gdb-xml/power-vsx.xml
diff --git a/configs/targets/ppc64-softmmu.mak b/configs/targets/ppc64-softmmu.mak
index 84fbf46be9e0..ddf0c39617f4 100644
--- a/configs/targets/ppc64-softmmu.mak
+++ b/configs/targets/ppc64-softmmu.mak
@@ -1,6 +1,6 @@
 TARGET_ARCH=ppc64
 TARGET_BASE_ARCH=ppc
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_SUPPORTS_MTTCG=y
 TARGET_XML_FILES= gdb-xml/power64-core.xml gdb-xml/power-fpu.xml gdb-xml/power-altivec.xml gdb-xml/power-spe.xml gdb-xml/power-vsx.xml
 TARGET_NEED_FDT=y
diff --git a/configs/targets/s390x-linux-user.mak b/configs/targets/s390x-linux-user.mak
index 9e31ce6457e9..e2978248eded 100644
--- a/configs/targets/s390x-linux-user.mak
+++ b/configs/targets/s390x-linux-user.mak
@@ -1,5 +1,5 @@
 TARGET_ARCH=s390x
 TARGET_SYSTBL_ABI=common,64
 TARGET_SYSTBL=syscall.tbl
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_XML_FILES= gdb-xml/s390x-core64.xml gdb-xml/s390-acr.xml gdb-xml/s390-fpr.xml gdb-xml/s390-vx.xml gdb-xml/s390-cr.xml gdb-xml/s390-virt.xml gdb-xml/s390-gs.xml
diff --git a/configs/targets/s390x-softmmu.mak b/configs/targets/s390x-softmmu.mak
index fd9fbd870d32..258b4cf35824 100644
--- a/configs/targets/s390x-softmmu.mak
+++ b/configs/targets/s390x-softmmu.mak
@@ -1,4 +1,4 @@
 TARGET_ARCH=s390x
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_SUPPORTS_MTTCG=y
 TARGET_XML_FILES= gdb-xml/s390x-core64.xml gdb-xml/s390-acr.xml gdb-xml/s390-fpr.xml gdb-xml/s390-vx.xml gdb-xml/s390-cr.xml gdb-xml/s390-virt.xml gdb-xml/s390-gs.xml
diff --git a/configs/targets/sh4eb-linux-user.mak b/configs/targets/sh4eb-linux-user.mak
index 9b6fb4c1bbed..6724165efee2 100644
--- a/configs/targets/sh4eb-linux-user.mak
+++ b/configs/targets/sh4eb-linux-user.mak
@@ -2,5 +2,5 @@ TARGET_ARCH=sh4
 TARGET_SYSTBL_ABI=common
 TARGET_SYSTBL=syscall.tbl
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_HAS_BFLT=y
diff --git a/configs/targets/sh4eb-softmmu.mak b/configs/targets/sh4eb-softmmu.mak
index 382e9a80f8d2..dc8b30bf7a22 100644
--- a/configs/targets/sh4eb-softmmu.mak
+++ b/configs/targets/sh4eb-softmmu.mak
@@ -1,3 +1,3 @@
 TARGET_ARCH=sh4
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
diff --git a/configs/targets/sparc-linux-user.mak b/configs/targets/sparc-linux-user.mak
index 53dc7aaed5a6..00e7bc1f076a 100644
--- a/configs/targets/sparc-linux-user.mak
+++ b/configs/targets/sparc-linux-user.mak
@@ -2,4 +2,4 @@ TARGET_ARCH=sparc
 TARGET_SYSTBL_ABI=common,32
 TARGET_SYSTBL=syscall.tbl
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
diff --git a/configs/targets/sparc-softmmu.mak b/configs/targets/sparc-softmmu.mak
index 9ba3d7b07f19..a849190f0108 100644
--- a/configs/targets/sparc-softmmu.mak
+++ b/configs/targets/sparc-softmmu.mak
@@ -1,3 +1,3 @@
 TARGET_ARCH=sparc
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
diff --git a/configs/targets/sparc32plus-linux-user.mak b/configs/targets/sparc32plus-linux-user.mak
index e4c51df3dcad..a65c0951a18b 100644
--- a/configs/targets/sparc32plus-linux-user.mak
+++ b/configs/targets/sparc32plus-linux-user.mak
@@ -5,4 +5,4 @@ TARGET_ABI_DIR=sparc
 TARGET_SYSTBL_ABI=common,32
 TARGET_SYSTBL=syscall.tbl
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
diff --git a/configs/targets/sparc64-linux-user.mak b/configs/targets/sparc64-linux-user.mak
index 9d23ab4a266e..20fcb93fa4b1 100644
--- a/configs/targets/sparc64-linux-user.mak
+++ b/configs/targets/sparc64-linux-user.mak
@@ -4,4 +4,4 @@ TARGET_ABI_DIR=sparc
 TARGET_SYSTBL_ABI=common,64
 TARGET_SYSTBL=syscall.tbl
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
diff --git a/configs/targets/sparc64-softmmu.mak b/configs/targets/sparc64-softmmu.mak
index 8dd321780042..c626ac3eae67 100644
--- a/configs/targets/sparc64-softmmu.mak
+++ b/configs/targets/sparc64-softmmu.mak
@@ -1,4 +1,4 @@
 TARGET_ARCH=sparc64
 TARGET_BASE_ARCH=sparc
 TARGET_ALIGNED_ONLY=y
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
diff --git a/configs/targets/xtensaeb-linux-user.mak b/configs/targets/xtensaeb-linux-user.mak
index 1ea0f1ba9156..bce2d1d65d23 100644
--- a/configs/targets/xtensaeb-linux-user.mak
+++ b/configs/targets/xtensaeb-linux-user.mak
@@ -1,5 +1,5 @@
 TARGET_ARCH=xtensa
 TARGET_SYSTBL_ABI=common
 TARGET_SYSTBL=syscall.tbl
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_HAS_BFLT=y
diff --git a/configs/targets/xtensaeb-softmmu.mak b/configs/targets/xtensaeb-softmmu.mak
index 405cf5acbb4a..b02e11b82008 100644
--- a/configs/targets/xtensaeb-softmmu.mak
+++ b/configs/targets/xtensaeb-softmmu.mak
@@ -1,3 +1,3 @@
 TARGET_ARCH=xtensa
-TARGET_WORDS_BIGENDIAN=y
+TARGET_BIG_ENDIAN=y
 TARGET_SUPPORTS_MTTCG=y
diff --git a/meson.build b/meson.build
index 7828f6537813..e03a1b50cc11 100644
--- a/meson.build
+++ b/meson.build
@@ -2186,6 +2186,9 @@ foreach target : target_dirs
   if 'TARGET_ABI_DIR' not in config_target
     config_target += {'TARGET_ABI_DIR': config_target['TARGET_ARCH']}
   endif
+  if 'TARGET_BIG_ENDIAN' not in config_target
+    config_target += {'TARGET_BIG_ENDIAN': 'n'}
+  endif
 
   foreach k, v: disassemblers
     if host_arch.startswith(k) or config_target['TARGET_BASE_ARCH'].startswith(k)
@@ -2210,6 +2213,8 @@ foreach target : target_dirs
       config_target_data.set_quoted(k, v)
     elif v == 'y'
       config_target_data.set(k, 1)
+    elif v == 'n'
+      config_target_data.set(k, 0)
     else
       config_target_data.set(k, v)
     endif
diff --git a/bsd-user/qemu.h b/bsd-user/qemu.h
index 21c06f2e7003..be6105385e8c 100644
--- a/bsd-user/qemu.h
+++ b/bsd-user/qemu.h
@@ -465,7 +465,7 @@ static inline void *lock_user_string(abi_ulong guest_addr)
 static inline uint64_t target_arg64(uint32_t word0, uint32_t word1)
 {
 #if TARGET_ABI_BITS == 32
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     return ((uint64_t)word0 << 32) | word1;
 #else
     return ((uint64_t)word1 << 32) | word0;
diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index f77070da5f7e..5d5290deb5a9 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -37,11 +37,10 @@
  * HOST_BIG_ENDIAN : whether the host cpu is big endian and
  * otherwise little endian.
  *
- * TARGET_WORDS_BIGENDIAN : if defined, the host cpu is big endian and otherwise
- * little endian.
+ * TARGET_BIG_ENDIAN : same for the target cpu
  */
 
-#if HOST_BIG_ENDIAN != defined(TARGET_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
 #define BSWAP_NEEDED
 #endif
 
@@ -121,7 +120,7 @@ static inline void tswap64s(uint64_t *s)
 /* Target-endianness CPU memory access functions. These fit into the
  * {ld,st}{type}{sign}{size}{endian}_p naming scheme described in bswap.h.
  */
-#if defined(TARGET_WORDS_BIGENDIAN)
+#if TARGET_BIG_ENDIAN
 #define lduw_p(p) lduw_be_p(p)
 #define ldsw_p(p) ldsw_be_p(p)
 #define ldl_p(p) ldl_be_p(p)
diff --git a/include/exec/cpu_ldst.h b/include/exec/cpu_ldst.h
index 6adacf89280d..d0c7c0d5fe8e 100644
--- a/include/exec/cpu_ldst.h
+++ b/include/exec/cpu_ldst.h
@@ -377,7 +377,7 @@ static inline CPUTLBEntry *tlb_entry(CPUArchState *env, uintptr_t mmu_idx,
 
 #endif /* defined(CONFIG_USER_ONLY) */
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
 # define cpu_lduw_data        cpu_lduw_be_data
 # define cpu_ldsw_data        cpu_ldsw_be_data
 # define cpu_ldl_data         cpu_ldl_be_data
diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
index 89edf94d2860..c35d7334b494 100644
--- a/include/exec/gdbstub.h
+++ b/include/exec/gdbstub.h
@@ -110,7 +110,7 @@ static inline int gdb_get_reg128(GByteArray *buf, uint64_t val_hi,
                                  uint64_t val_lo)
 {
     uint64_t to_quad;
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     to_quad = tswap64(val_hi);
     g_byte_array_append(buf, (uint8_t *) &to_quad, 8);
     to_quad = tswap64(val_lo);
diff --git a/include/exec/memop.h b/include/exec/memop.h
index 44f923ed4660..25d027434ad5 100644
--- a/include/exec/memop.h
+++ b/include/exec/memop.h
@@ -36,7 +36,7 @@ typedef enum MemOp {
     MO_BE    = MO_BSWAP,
 #endif
 #ifdef NEED_CPU_H
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     MO_TE    = MO_BE,
 #else
     MO_TE    = MO_LE,
diff --git a/include/exec/memory.h b/include/exec/memory.h
index e40653f0d19e..f1c19451bcd0 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -2931,7 +2931,7 @@ static inline MemOp devend_memop(enum device_endian end)
     QEMU_BUILD_BUG_ON(DEVICE_HOST_ENDIAN != DEVICE_LITTLE_ENDIAN &&
                       DEVICE_HOST_ENDIAN != DEVICE_BIG_ENDIAN);
 
-#if HOST_BIG_ENDIAN != defined(TARGET_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
     /* Swap if non-host endianness or native (target) endianness */
     return (end == DEVICE_HOST_ENDIAN) ? 0 : MO_BSWAP;
 #else
diff --git a/include/exec/poison.h b/include/exec/poison.h
index 7c5c02f03f08..9f1ca3409c25 100644
--- a/include/exec/poison.h
+++ b/include/exec/poison.h
@@ -38,7 +38,7 @@
 #pragma GCC poison TARGET_HAS_BFLT
 #pragma GCC poison TARGET_NAME
 #pragma GCC poison TARGET_SUPPORTS_MTTCG
-#pragma GCC poison TARGET_WORDS_BIGENDIAN
+#pragma GCC poison TARGET_BIG_ENDIAN
 #pragma GCC poison BSWAP_NEEDED
 
 #pragma GCC poison TARGET_LONG_BITS
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index b0e2e5b9d253..13adb251b2ab 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -1028,7 +1028,7 @@ void cpu_exec_unrealizefn(CPUState *cpu);
  * target_words_bigendian:
  * Returns true if the (default) endianness of the target is big endian,
  * false otherwise. Note that in target-specific code, you can use
- * TARGET_WORDS_BIGENDIAN directly instead. On the other hand, common
+ * TARGET_BIG_ENDIAN directly instead. On the other hand, common
  * code should normally never need to know about the endianness of the
  * target, so please do *not* use this function unless you know very well
  * what you are doing!
diff --git a/include/hw/mips/bios.h b/include/hw/mips/bios.h
index c03007999a03..44acb6815bec 100644
--- a/include/hw/mips/bios.h
+++ b/include/hw/mips/bios.h
@@ -5,7 +5,7 @@
 #include "cpu.h"
 
 #define BIOS_SIZE (4 * MiB)
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
 #define BIOS_FILENAME "mips_bios.bin"
 #else
 #define BIOS_FILENAME "mipsel_bios.bin"
diff --git a/include/hw/virtio/virtio-access.h b/include/hw/virtio/virtio-access.h
index 90cbb77782b5..07aae69042a9 100644
--- a/include/hw/virtio/virtio-access.h
+++ b/include/hw/virtio/virtio-access.h
@@ -28,7 +28,7 @@ static inline bool virtio_access_is_big_endian(VirtIODevice *vdev)
 {
 #if defined(LEGACY_VIRTIO_IS_BIENDIAN)
     return virtio_is_big_endian(vdev);
-#elif defined(TARGET_WORDS_BIGENDIAN)
+#elif TARGET_BIG_ENDIAN
     if (virtio_vdev_has_feature(vdev, VIRTIO_F_VERSION_1)) {
         /* Devices conforming to VIRTIO 1.0 or later are always LE. */
         return false;
diff --git a/linux-user/aarch64/target_syscall.h b/linux-user/aarch64/target_syscall.h
index a98f568ab4d7..c055133725ec 100644
--- a/linux-user/aarch64/target_syscall.h
+++ b/linux-user/aarch64/target_syscall.h
@@ -8,7 +8,7 @@ struct target_pt_regs {
     uint64_t        pstate;
 };
 
-#if defined(TARGET_WORDS_BIGENDIAN)
+#if TARGET_BIG_ENDIAN
 #define UNAME_MACHINE "aarch64_be"
 #else
 #define UNAME_MACHINE "aarch64"
diff --git a/linux-user/arm/target_syscall.h b/linux-user/arm/target_syscall.h
index f04f9c9e3d75..412ad434cfc2 100644
--- a/linux-user/arm/target_syscall.h
+++ b/linux-user/arm/target_syscall.h
@@ -18,7 +18,7 @@ struct target_pt_regs {
 #define ARM_NR_set_tls	  (ARM_NR_BASE + 5)
 #define ARM_NR_get_tls    (ARM_NR_BASE + 6)
 
-#if defined(TARGET_WORDS_BIGENDIAN)
+#if TARGET_BIG_ENDIAN
 #define UNAME_MACHINE "armv5teb"
 #else
 #define UNAME_MACHINE "armv5tel"
diff --git a/linux-user/ppc/target_syscall.h b/linux-user/ppc/target_syscall.h
index 7df911893775..77b36d0b46e6 100644
--- a/linux-user/ppc/target_syscall.h
+++ b/linux-user/ppc/target_syscall.h
@@ -59,7 +59,7 @@ struct target_revectored_struct {
  */
 
 #if defined(TARGET_PPC64)
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
 #define UNAME_MACHINE "ppc64"
 #else
 #define UNAME_MACHINE "ppc64le"
diff --git a/linux-user/qemu.h b/linux-user/qemu.h
index 98dfbf20962b..46550f5e2178 100644
--- a/linux-user/qemu.h
+++ b/linux-user/qemu.h
@@ -236,7 +236,7 @@ static inline bool access_ok(CPUState *cpu, int type,
     } while (0)
 
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
 # define __put_user(x, hptr)  __put_user_e(x, hptr, be)
 # define __get_user(x, hptr)  __get_user_e(x, hptr, be)
 #else
diff --git a/linux-user/user-internals.h b/linux-user/user-internals.h
index a8fdd6933b23..49978d0c79a1 100644
--- a/linux-user/user-internals.h
+++ b/linux-user/user-internals.h
@@ -115,7 +115,7 @@ static inline int is_error(abi_long ret)
 #if TARGET_ABI_BITS == 32
 static inline uint64_t target_offset64(uint32_t word0, uint32_t word1)
 {
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     return ((uint64_t)word0 << 32) | word1;
 #else
     return ((uint64_t)word1 << 32) | word0;
diff --git a/linux-user/xtensa/target_structs.h b/linux-user/xtensa/target_structs.h
index 9cde6844b8fc..cb1b3411cf08 100644
--- a/linux-user/xtensa/target_structs.h
+++ b/linux-user/xtensa/target_structs.h
@@ -15,7 +15,7 @@ struct target_ipc_perm {
 
 struct target_semid64_ds {
   struct target_ipc_perm sem_perm;
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
   abi_ulong __unused1;
   abi_ulong sem_otime;
   abi_ulong __unused2;
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 816aa0394e9f..ccf635ac5cbc 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -3549,12 +3549,12 @@ static inline int cpu_mmu_index(CPUARMState *env, bool ifetch)
 static inline bool bswap_code(bool sctlr_b)
 {
 #ifdef CONFIG_USER_ONLY
-    /* BE8 (SCTLR.B = 0, TARGET_WORDS_BIGENDIAN = 1) is mixed endian.
-     * The invalid combination SCTLR.B=1/CPSR.E=1/TARGET_WORDS_BIGENDIAN=0
+    /* BE8 (SCTLR.B = 0, TARGET_BIG_ENDIAN = 1) is mixed endian.
+     * The invalid combination SCTLR.B=1/CPSR.E=1/TARGET_BIG_ENDIAN=0
      * would also end up as a mixed-endian mode with BE code, LE data.
      */
     return
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
         1 ^
 #endif
         sctlr_b;
@@ -3570,7 +3570,7 @@ static inline bool bswap_code(bool sctlr_b)
 static inline bool arm_cpu_bswap_data(CPUARMState *env)
 {
     return
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
        1 ^
 #endif
        arm_cpu_data_is_big_endian(env);
diff --git a/target/xtensa/cpu.h b/target/xtensa/cpu.h
index a572e831aebf..f10cfabdc35c 100644
--- a/target/xtensa/cpu.h
+++ b/target/xtensa/cpu.h
@@ -590,7 +590,7 @@ void xtensa_cpu_do_unaligned_access(CPUState *cpu, vaddr addr,
 #define XTENSA_CPU_TYPE_NAME(model) model XTENSA_CPU_TYPE_SUFFIX
 #define CPU_RESOLVING_TYPE TYPE_XTENSA_CPU
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
 #define XTENSA_DEFAULT_CPU_MODEL "fsf"
 #define XTENSA_DEFAULT_CPU_NOMMU_MODEL "fsf"
 #else
diff --git a/target/xtensa/overlay_tool.h b/target/xtensa/overlay_tool.h
index 78720734fe92..701c00eed20a 100644
--- a/target/xtensa/overlay_tool.h
+++ b/target/xtensa/overlay_tool.h
@@ -449,7 +449,7 @@
 
 #endif
 
-#if (defined(TARGET_WORDS_BIGENDIAN) != 0) == (XCHAL_HAVE_BE != 0)
+#if TARGET_BIG_ENDIAN == (XCHAL_HAVE_BE != 0)
 #define REGISTER_CORE(core) \
     static void __attribute__((constructor)) register_core(void) \
     { \
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 1c129dc90c8b..8d9d2367ee02 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1202,7 +1202,7 @@ void kvm_hwpoison_page_add(ram_addr_t ram_addr)
 
 static uint32_t adjust_ioeventfd_endianness(uint32_t val, uint32_t size)
 {
-#if HOST_BIG_ENDIAN != defined(TARGET_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
     /* The kernel expects ioeventfd values in HOST_BIG_ENDIAN
      * endianness, but the memory core hands them in target endianness.
      * For example, PPC is always treated as big-endian even if running
diff --git a/cpu.c b/cpu.c
index be1f8b074ce4..d34c3439bbf3 100644
--- a/cpu.c
+++ b/cpu.c
@@ -469,7 +469,7 @@ int cpu_memory_rw_debug(CPUState *cpu, vaddr addr,
 
 bool target_words_bigendian(void)
 {
-#if defined(TARGET_WORDS_BIGENDIAN)
+#if TARGET_BIG_ENDIAN
     return true;
 #else
     return false;
diff --git a/disas.c b/disas.c
index 2d2565ac5774..8c16e55c7e72 100644
--- a/disas.c
+++ b/disas.c
@@ -126,7 +126,7 @@ static void initialize_debug_target(CPUDebug *s, CPUState *cpu)
     s->cpu = cpu;
     s->info.read_memory_func = target_read_memory;
     s->info.print_address_func = print_address;
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     s->info.endian = BFD_ENDIAN_BIG;
 #else
     s->info.endian = BFD_ENDIAN_LITTLE;
diff --git a/hw/arm/armv7m.c b/hw/arm/armv7m.c
index 41cfca0f2236..32349ec94b17 100644
--- a/hw/arm/armv7m.c
+++ b/hw/arm/armv7m.c
@@ -577,7 +577,7 @@ void armv7m_load_kernel(ARMCPU *cpu, const char *kernel_filename, int mem_size)
     int asidx;
     CPUState *cs = CPU(cpu);
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     big_endian = 1;
 #else
     big_endian = 0;
diff --git a/hw/display/vga.c b/hw/display/vga.c
index 737cfbde98ce..5dca2d15284e 100644
--- a/hw/display/vga.c
+++ b/hw/display/vga.c
@@ -2242,7 +2242,7 @@ bool vga_common_init(VGACommonState *s, Object *obj, Error **errp)
      * into a device attribute set by the machine/platform to remove
      * all target endian dependencies from this file.
      */
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     s->default_endian_fb = true;
 #else
     s->default_endian_fb = false;
diff --git a/hw/microblaze/boot.c b/hw/microblaze/boot.c
index 8821d009f1a9..03c030aa2cf0 100644
--- a/hw/microblaze/boot.c
+++ b/hw/microblaze/boot.c
@@ -138,7 +138,7 @@ void microblaze_load_kernel(MicroBlazeCPU *cpu, hwaddr ddr_base,
         uint32_t base32;
         int big_endian = 0;
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
         big_endian = 1;
 #endif
 
diff --git a/hw/mips/gt64xxx_pci.c b/hw/mips/gt64xxx_pci.c
index e0ff1b556603..19d0d9889f5e 100644
--- a/hw/mips/gt64xxx_pci.c
+++ b/hw/mips/gt64xxx_pci.c
@@ -986,7 +986,7 @@ static void gt64120_reset(DeviceState *dev)
     /* FIXME: Malta specific hw assumptions ahead */
 
     /* CPU Configuration */
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     s->regs[GT_CPU]           = 0x00000000;
 #else
     s->regs[GT_CPU]           = 0x00001000;
@@ -1097,7 +1097,7 @@ static void gt64120_reset(DeviceState *dev)
     s->regs[GT_TC_CONTROL]    = 0x00000000;
 
     /* PCI Internal */
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     s->regs[GT_PCI0_CMD]      = 0x00000000;
 #else
     s->regs[GT_PCI0_CMD]      = 0x00010001;
@@ -1118,7 +1118,7 @@ static void gt64120_reset(DeviceState *dev)
     s->regs[GT_PCI0_SSCS10_BAR] = 0x00000000;
     s->regs[GT_PCI0_SSCS32_BAR] = 0x01000000;
     s->regs[GT_PCI0_SCS3BT_BAR] = 0x1f000000;
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     s->regs[GT_PCI1_CMD]      = 0x00000000;
 #else
     s->regs[GT_PCI1_CMD]      = 0x00010001;
diff --git a/hw/mips/jazz.c b/hw/mips/jazz.c
index 44f0d48bfd75..4d6b44de342e 100644
--- a/hw/mips/jazz.c
+++ b/hw/mips/jazz.c
@@ -158,7 +158,7 @@ static void mips_jazz_init(MachineState *machine,
         [JAZZ_PICA61] = {33333333, 4},
     };
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     big_endian = 1;
 #else
     big_endian = 0;
diff --git a/hw/mips/malta.c b/hw/mips/malta.c
index 6288511723e1..c4474b927c46 100644
--- a/hw/mips/malta.c
+++ b/hw/mips/malta.c
@@ -367,7 +367,7 @@ static uint64_t malta_fpga_read(void *opaque, hwaddr addr,
 
     /* STATUS Register */
     case 0x00208:
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
         val = 0x00000012;
 #else
         val = 0x00000010;
@@ -695,7 +695,7 @@ static void write_bootloader_nanomips(uint8_t *base, uint64_t run_addr,
     stw_p(p++, 0xe040); stw_p(p++, 0x0681);
                                 /* lui t1, %hi(0xb4000000)      */
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
 
     stw_p(p++, 0xe020); stw_p(p++, 0x0be1);
                                 /* lui t0, %hi(0xdf000000)      */
@@ -894,7 +894,7 @@ static void write_bootloader(uint8_t *base, uint64_t run_addr,
     /* Load BAR registers as done by YAMON */
     stl_p(p++, 0x3c09b400);                  /* lui t1, 0xb400 */
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     stl_p(p++, 0x3c08df00);                  /* lui t0, 0xdf00 */
 #else
     stl_p(p++, 0x340800df);                  /* ori t0, r0, 0x00df */
@@ -903,39 +903,39 @@ static void write_bootloader(uint8_t *base, uint64_t run_addr,
 
     stl_p(p++, 0x3c09bbe0);                  /* lui t1, 0xbbe0 */
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     stl_p(p++, 0x3c08c000);                  /* lui t0, 0xc000 */
 #else
     stl_p(p++, 0x340800c0);                  /* ori t0, r0, 0x00c0 */
 #endif
     stl_p(p++, 0xad280048);                  /* sw t0, 0x0048(t1) */
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     stl_p(p++, 0x3c084000);                  /* lui t0, 0x4000 */
 #else
     stl_p(p++, 0x34080040);                  /* ori t0, r0, 0x0040 */
 #endif
     stl_p(p++, 0xad280050);                  /* sw t0, 0x0050(t1) */
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     stl_p(p++, 0x3c088000);                  /* lui t0, 0x8000 */
 #else
     stl_p(p++, 0x34080080);                  /* ori t0, r0, 0x0080 */
 #endif
     stl_p(p++, 0xad280058);                  /* sw t0, 0x0058(t1) */
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     stl_p(p++, 0x3c083f00);                  /* lui t0, 0x3f00 */
 #else
     stl_p(p++, 0x3408003f);                  /* ori t0, r0, 0x003f */
 #endif
     stl_p(p++, 0xad280060);                  /* sw t0, 0x0060(t1) */
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     stl_p(p++, 0x3c08c100);                  /* lui t0, 0xc100 */
 #else
     stl_p(p++, 0x340800c1);                  /* ori t0, r0, 0x00c1 */
 #endif
     stl_p(p++, 0xad280080);                  /* sw t0, 0x0080(t1) */
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     stl_p(p++, 0x3c085e00);                  /* lui t0, 0x5e00 */
 #else
     stl_p(p++, 0x3408005e);                  /* ori t0, r0, 0x005e */
@@ -1030,7 +1030,7 @@ static uint64_t load_kernel(void)
     int prom_index = 0;
     uint64_t (*xlate_to_kseg0) (void *opaque, uint64_t addr);
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     big_endian = 1;
 #else
     big_endian = 0;
@@ -1272,7 +1272,7 @@ void mips_malta_init(MachineState *machine)
                                     ram_low_postio);
     }
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     be = 1;
 #else
     be = 0;
@@ -1353,7 +1353,7 @@ void mips_malta_init(MachineState *machine)
          * In little endian mode the 32bit words in the bios are swapped,
          * a neat trick which allows bi-endian firmware.
          */
-#ifndef TARGET_WORDS_BIGENDIAN
+#if !TARGET_BIG_ENDIAN
         {
             uint32_t *end, *addr;
             const size_t swapsize = MIN(bios_size, 0x3e0000);
diff --git a/hw/mips/mipssim.c b/hw/mips/mipssim.c
index 27a46bd5380b..30bc1c4f086f 100644
--- a/hw/mips/mipssim.c
+++ b/hw/mips/mipssim.c
@@ -65,7 +65,7 @@ static uint64_t load_kernel(void)
     ram_addr_t initrd_offset;
     int big_endian;
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     big_endian = 1;
 #else
     big_endian = 0;
diff --git a/hw/nios2/boot.c b/hw/nios2/boot.c
index 5b3e4efed5be..e889595d5c2b 100644
--- a/hw/nios2/boot.c
+++ b/hw/nios2/boot.c
@@ -140,7 +140,7 @@ void nios2_load_kernel(Nios2CPU *cpu, hwaddr ddr_base,
         uint64_t entry, high;
         int big_endian = 0;
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
         big_endian = 1;
 #endif
 
diff --git a/hw/xtensa/sim.c b/hw/xtensa/sim.c
index 2028fe793d9b..946c71cb5b5c 100644
--- a/hw/xtensa/sim.c
+++ b/hw/xtensa/sim.c
@@ -96,7 +96,7 @@ XtensaCPU *xtensa_sim_common_init(MachineState *machine)
 void xtensa_sim_load_kernel(XtensaCPU *cpu, MachineState *machine)
 {
     const char *kernel_filename = machine->kernel_filename;
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     int big_endian = true;
 #else
     int big_endian = false;
diff --git a/hw/xtensa/xtfpga.c b/hw/xtensa/xtfpga.c
index c1e004e8822d..2a5556a35f50 100644
--- a/hw/xtensa/xtfpga.c
+++ b/hw/xtensa/xtfpga.c
@@ -219,7 +219,7 @@ static const MemoryRegionOps xtfpga_io_ops = {
 
 static void xtfpga_init(const XtfpgaBoardDesc *board, MachineState *machine)
 {
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     int be = 1;
 #else
     int be = 0;
@@ -430,7 +430,7 @@ static void xtfpga_init(const XtfpgaBoardDesc *board, MachineState *machine)
         }
         if (entry_point != env->pc) {
             uint8_t boot[] = {
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
                 0x60, 0x00, 0x08,       /* j    1f */
                 0x00,                   /* .literal_position */
                 0x00, 0x00, 0x00, 0x00, /* .literal entry_pc */
diff --git a/linux-user/aarch64/cpu_loop.c b/linux-user/aarch64/cpu_loop.c
index 1737e2ea655a..31a66a4fa07c 100644
--- a/linux-user/aarch64/cpu_loop.c
+++ b/linux-user/aarch64/cpu_loop.c
@@ -202,7 +202,7 @@ void target_cpu_copy_regs(CPUArchState *env, struct target_pt_regs *regs)
     }
     env->pc = regs->pc;
     env->xregs[31] = regs->sp;
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     env->cp15.sctlr_el[1] |= SCTLR_E0E;
     for (i = 1; i < 4; ++i) {
         env->cp15.sctlr_el[i] |= SCTLR_EE;
diff --git a/linux-user/aarch64/signal.c b/linux-user/aarch64/signal.c
index df9e39a4ba04..7de4c96eb9d0 100644
--- a/linux-user/aarch64/signal.c
+++ b/linux-user/aarch64/signal.c
@@ -147,7 +147,7 @@ static void target_setup_fpsimd_record(struct target_fpsimd_context *fpsimd,
 
     for (i = 0; i < 32; i++) {
         uint64_t *q = aa64_vfp_qreg(env, i);
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
         __put_user(q[0], &fpsimd->vregs[i * 2 + 1]);
         __put_user(q[1], &fpsimd->vregs[i * 2]);
 #else
@@ -233,7 +233,7 @@ static void target_restore_fpsimd_record(CPUARMState *env,
 
     for (i = 0; i < 32; i++) {
         uint64_t *q = aa64_vfp_qreg(env, i);
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
         __get_user(q[0], &fpsimd->vregs[i * 2 + 1]);
         __get_user(q[1], &fpsimd->vregs[i * 2]);
 #else
diff --git a/linux-user/arm/cpu_loop.c b/linux-user/arm/cpu_loop.c
index 032e1ffddfbd..9dcb2e024eb0 100644
--- a/linux-user/arm/cpu_loop.c
+++ b/linux-user/arm/cpu_loop.c
@@ -485,7 +485,7 @@ void target_cpu_copy_regs(CPUArchState *env, struct target_pt_regs *regs)
     for(i = 0; i < 16; i++) {
         env->regs[i] = regs->uregs[i];
     }
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     /* Enable BE8.  */
     if (EF_ARM_EABI_VERSION(info->elf_flags) >= EF_ARM_EABI_VER4
         && (info->elf_flags & EF_ARM_BE8)) {
diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index 9628a38361cb..796acdcdbd2c 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -105,7 +105,7 @@ int info_is_fdpic(struct image_info *info)
 #define ELIBBAD 80
 #endif
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
 #define ELF_DATA        ELFDATA2MSB
 #else
 #define ELF_DATA        ELFDATA2LSB
@@ -483,7 +483,7 @@ static const char *get_elf_platform(void)
 {
     CPUARMState *env = thread_cpu->env_ptr;
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
 # define END  "b"
 #else
 # define END  "l"
@@ -514,7 +514,7 @@ static const char *get_elf_platform(void)
 
 #define ELF_ARCH        EM_AARCH64
 #define ELF_CLASS       ELFCLASS64
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
 # define ELF_PLATFORM    "aarch64_be"
 #else
 # define ELF_PLATFORM    "aarch64"
diff --git a/linux-user/ppc/signal.c b/linux-user/ppc/signal.c
index 2550b8f8c069..accf5aa199c8 100644
--- a/linux-user/ppc/signal.c
+++ b/linux-user/ppc/signal.c
@@ -215,7 +215,7 @@ static target_ulong get_sigframe(struct target_sigaction *ka,
     return (oldsp - frame_size) & ~0xFUL;
 }
 
-#if defined(TARGET_WORDS_BIGENDIAN) == HOST_BIG_ENDIAN
+#if TARGET_BIG_ENDIAN == HOST_BIG_ENDIAN
 #define PPC_VEC_HI      0
 #define PPC_VEC_LO      1
 #else
@@ -542,7 +542,7 @@ void setup_rt_frame(int sig, struct target_sigaction *ka,
     env->nip = (target_ulong) ka->_sa_handler;
 #endif
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     /* Signal handlers are entered in big-endian mode.  */
     ppc_store_msr(env, env->msr & ~(1ull << MSR_LE));
 #else
diff --git a/linux-user/syscall.c b/linux-user/syscall.c
index 7182dbd9796d..dc7b513c3cbb 100644
--- a/linux-user/syscall.c
+++ b/linux-user/syscall.c
@@ -8152,7 +8152,7 @@ static int is_proc_myself(const char *filename, const char *entry)
     return 0;
 }
 
-#if HOST_BIG_ENDIAN != defined(TARGET_WORDS_BIGENDIAN) || \
+#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN || \
     defined(TARGET_SPARC) || defined(TARGET_M68K) || defined(TARGET_HPPA)
 static int is_proc(const char *filename, const char *entry)
 {
@@ -8160,7 +8160,7 @@ static int is_proc(const char *filename, const char *entry)
 }
 #endif
 
-#if HOST_BIG_ENDIAN != defined(TARGET_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
 static int open_net_route(void *cpu_env, int fd)
 {
     FILE *fp;
@@ -8246,7 +8246,7 @@ static int do_openat(void *cpu_env, int dirfd, const char *pathname, int flags,
         { "stat", open_self_stat, is_proc_myself },
         { "auxv", open_self_auxv, is_proc_myself },
         { "cmdline", open_self_cmdline, is_proc_myself },
-#if HOST_BIG_ENDIAN != defined(TARGET_WORDS_BIGENDIAN)
+#if HOST_BIG_ENDIAN != TARGET_BIG_ENDIAN
         { "/proc/net/route", open_net_route, is_proc },
 #endif
 #if defined(TARGET_SPARC) || defined(TARGET_HPPA)
diff --git a/linux-user/uname.c b/linux-user/uname.c
index 1d82608c100f..0856783b2190 100644
--- a/linux-user/uname.c
+++ b/linux-user/uname.c
@@ -41,7 +41,7 @@ const char *cpu_to_uname_machine(void *cpu_env)
 
     /* in theory, endianness is configurable on some ARM CPUs, but this isn't
      * used in user mode emulation */
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
 #define utsname_suffix "b"
 #else
 #define utsname_suffix "l"
diff --git a/linux-user/xtensa/signal.c b/linux-user/xtensa/signal.c
index 06d91a37ecee..f5fb8b5cbebe 100644
--- a/linux-user/xtensa/signal.c
+++ b/linux-user/xtensa/signal.c
@@ -130,7 +130,7 @@ static int setup_sigcontext(struct target_rt_sigframe *frame,
 
 static void install_sigtramp(uint8_t *tramp)
 {
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     /* Generate instruction:  MOVI a2, __NR_rt_sigreturn */
     __put_user(0x22, &tramp[0]);
     __put_user(0x0a, &tramp[1]);
diff --git a/softmmu/memory.c b/softmmu/memory.c
index 8060c6de7802..0456a6c051eb 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -350,7 +350,7 @@ static void flatview_simplify(FlatView *view)
 
 static bool memory_region_big_endian(MemoryRegion *mr)
 {
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     return mr->ops->endianness != DEVICE_LITTLE_ENDIAN;
 #else
     return mr->ops->endianness == DEVICE_BIG_ENDIAN;
diff --git a/softmmu/qtest.c b/softmmu/qtest.c
index cc586233a974..6a0edd733b79 100644
--- a/softmmu/qtest.c
+++ b/softmmu/qtest.c
@@ -732,7 +732,7 @@ static void qtest_process_command(CharBackend *chr, gchar **words)
         qtest_send(chr, "OK\n");
     } else if (strcmp(words[0], "endianness") == 0) {
         qtest_send_prefix(chr);
-#if defined(TARGET_WORDS_BIGENDIAN)
+#if TARGET_BIG_ENDIAN
         qtest_sendf(chr, "OK big\n");
 #else
         qtest_sendf(chr, "OK little\n");
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 5d4ca7a22700..0980d3390112 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -812,7 +812,7 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 
     sctlr_b = arm_sctlr_b(env);
     if (bswap_code(sctlr_b)) {
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
         info->endian = BFD_ENDIAN_LITTLE;
 #else
         info->endian = BFD_ENDIAN_BIG;
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index af287177d5af..ad74fbe636af 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -189,7 +189,7 @@ static void mips_cpu_reset(DeviceState *dev)
     /* Reset registers to their default values */
     env->CP0_PRid = env->cpu_model->CP0_PRid;
     env->CP0_Config0 = env->cpu_model->CP0_Config0;
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     env->CP0_Config0 |= (1 << CP0C0_BE);
 #endif
     env->CP0_Config1 = env->cpu_model->CP0_Config1;
@@ -418,7 +418,7 @@ static void mips_cpu_disas_set_info(CPUState *s, disassemble_info *info)
     CPUMIPSState *env = &cpu->env;
 
     if (!(env->insn_flags & ISA_NANOMIPS32)) {
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
         info->print_insn = print_insn_big_mips;
 #else
         info->print_insn = print_insn_little_mips;
diff --git a/target/mips/tcg/msa_helper.c b/target/mips/tcg/msa_helper.c
index 389c42e4baa3..4dde5d639ad4 100644
--- a/target/mips/tcg/msa_helper.c
+++ b/target/mips/tcg/msa_helper.c
@@ -8218,7 +8218,7 @@ void helper_msa_ffint_u_df(CPUMIPSState *env, uint32_t df, uint32_t wd,
 #define MEMOP_IDX(DF)
 #endif
 
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
 static inline uint64_t bswap16x4(uint64_t x)
 {
     uint64_t m = 0x00ff00ff00ff00ffull;
@@ -8258,7 +8258,7 @@ void helper_msa_ld_h(CPUMIPSState *env, uint32_t wd,
      */
     d0 = cpu_ldq_le_data_ra(env, addr + 0, ra);
     d1 = cpu_ldq_le_data_ra(env, addr + 8, ra);
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     d0 = bswap16x4(d0);
     d1 = bswap16x4(d1);
 #endif
@@ -8279,7 +8279,7 @@ void helper_msa_ld_w(CPUMIPSState *env, uint32_t wd,
      */
     d0 = cpu_ldq_le_data_ra(env, addr + 0, ra);
     d1 = cpu_ldq_le_data_ra(env, addr + 8, ra);
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     d0 = bswap32x2(d0);
     d1 = bswap32x2(d1);
 #endif
@@ -8345,7 +8345,7 @@ void helper_msa_st_h(CPUMIPSState *env, uint32_t wd,
     /* Store 8 bytes at a time.  See helper_msa_ld_h. */
     d0 = pwd->d[0];
     d1 = pwd->d[1];
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     d0 = bswap16x4(d0);
     d1 = bswap16x4(d1);
 #endif
@@ -8366,7 +8366,7 @@ void helper_msa_st_w(CPUMIPSState *env, uint32_t wd,
     /* Store 8 bytes at a time.  See helper_msa_ld_w. */
     d0 = pwd->d[0];
     d1 = pwd->d[1];
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     d0 = bswap32x2(d0);
     d1 = bswap32x2(d1);
 #endif
diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index 073fd101687c..5062d0e4782a 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -7150,7 +7150,7 @@ static void ppc_cpu_reset(DeviceState *dev)
 #if defined(TARGET_PPC64)
     msr |= (target_ulong)1 << MSR_TM; /* Transactional memory */
 #endif
-#if !defined(TARGET_WORDS_BIGENDIAN)
+#if !TARGET_BIG_ENDIAN
     msr |= (target_ulong)1 << MSR_LE; /* Little-endian user mode */
     if (!((env->msr_mask >> MSR_LE) & 1)) {
         fprintf(stderr, "Selected CPU does not support little-endian.\n");
diff --git a/target/ppc/gdbstub.c b/target/ppc/gdbstub.c
index 105c2f7dd13f..1252429a2ad5 100644
--- a/target/ppc/gdbstub.c
+++ b/target/ppc/gdbstub.c
@@ -87,9 +87,9 @@ static int ppc_gdb_register_len(int n)
 /*
  * We need to present the registers to gdb in the "current" memory
  * ordering.  For user-only mode we get this for free;
- * TARGET_WORDS_BIGENDIAN is set to the proper ordering for the
+ * TARGET_BIG_ENDIAN is set to the proper ordering for the
  * binary, and cannot be changed.  For system mode,
- * TARGET_WORDS_BIGENDIAN is always set, and we must check the current
+ * TARGET_BIG_ENDIAN is always set, and we must check the current
  * mode of the chip to see if we're running in little-endian.
  */
 void ppc_maybe_bswap_register(CPUPPCState *env, uint8_t *mem_buf, int len)
diff --git a/target/ppc/mem_helper.c b/target/ppc/mem_helper.c
index f1c76a7750ab..c4ff8fd632ce 100644
--- a/target/ppc/mem_helper.c
+++ b/target/ppc/mem_helper.c
@@ -32,7 +32,7 @@
 
 static inline bool needs_byteswap(const CPUPPCState *env)
 {
-#if defined(TARGET_WORDS_BIGENDIAN)
+#if TARGET_BIG_ENDIAN
   return msr_le;
 #else
   return !msr_le;
diff --git a/target/ppc/translate.c b/target/ppc/translate.c
index 408ae26173de..f14f8d7309ba 100644
--- a/target/ppc/translate.c
+++ b/target/ppc/translate.c
@@ -193,7 +193,7 @@ struct DisasContext {
 /* Return true iff byteswap is needed in a scalar memop */
 static inline bool need_byteswap(const DisasContext *ctx)
 {
-#if defined(TARGET_WORDS_BIGENDIAN)
+#if TARGET_BIG_ENDIAN
      return ctx->le_mode;
 #else
      return !ctx->le_mode;
diff --git a/target/xtensa/translate.c b/target/xtensa/translate.c
index b1491ed625e5..fc4e9d2c9a86 100644
--- a/target/xtensa/translate.c
+++ b/target/xtensa/translate.c
@@ -1471,14 +1471,14 @@ static void translate_b(DisasContext *dc, const OpcodeArg arg[],
 static void translate_bb(DisasContext *dc, const OpcodeArg arg[],
                          const uint32_t par[])
 {
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     TCGv_i32 bit = tcg_const_i32(0x80000000u);
 #else
     TCGv_i32 bit = tcg_const_i32(0x00000001u);
 #endif
     TCGv_i32 tmp = tcg_temp_new_i32();
     tcg_gen_andi_i32(tmp, arg[1].in, 0x1f);
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     tcg_gen_shr_i32(bit, bit, tmp);
 #else
     tcg_gen_shl_i32(bit, bit, tmp);
@@ -1493,7 +1493,7 @@ static void translate_bbi(DisasContext *dc, const OpcodeArg arg[],
                           const uint32_t par[])
 {
     TCGv_i32 tmp = tcg_temp_new_i32();
-#ifdef TARGET_WORDS_BIGENDIAN
+#if TARGET_BIG_ENDIAN
     tcg_gen_andi_i32(tmp, arg[0].in, 0x80000000u >> arg[1].imm);
 #else
     tcg_gen_andi_i32(tmp, arg[0].in, 0x00000001u << arg[1].imm);
diff --git a/tests/tcg/xtensa/Makefile.softmmu-target b/tests/tcg/xtensa/Makefile.softmmu-target
index 9530cac2ad95..973e55298ee4 100644
--- a/tests/tcg/xtensa/Makefile.softmmu-target
+++ b/tests/tcg/xtensa/Makefile.softmmu-target
@@ -2,7 +2,7 @@
 # Xtensa softmmu tests
 #
 
-ifneq ($(TARGET_WORDS_BIGENDIAN),y)
+ifneq ($(TARGET_BIG_ENDIAN),y)
 
 XTENSA_SRC = $(SRC_PATH)/tests/tcg/xtensa
 XTENSA_ALL = $(filter-out $(XTENSA_SRC)/linker.ld.S,$(wildcard $(XTENSA_SRC)/*.S))
-- 
2.35.1.273.ge6ebfd0e8cbb

