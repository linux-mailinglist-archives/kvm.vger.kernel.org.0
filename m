Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019036BBB25
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjCORoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbjCORnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:43:52 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6F617CCF
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:45 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id p13-20020a05600c358d00b003ed346d4522so1589519wmq.2
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 10:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678902224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=elWTENHvE0PgCEqrOZpYTQtTUayrgelSMhbbtb8XlwE=;
        b=Pfp6tF196su9NdqN3TA2CgK8rDfq5ov7CErbXNO9fzl/iZVocGWthzx8FwZj0KThDC
         +Q6guOn8dIfd68YZFWmJT23Ot0vJ2KQ8G/nI4zVbtG6zslU/wiwXS34SHwehbY/N6j5i
         SeE0CfvVVBdv5I2pO7p+EdUMedOZGr12Muf0Jy9XTw/6i6b/SLz/qDYFRDAqce2lfD9x
         VAYEJ3g2nQH7HyaPO0nfCrh28ro7S75naxsrHJXVFTVY/ORH7hprzXug98tdVjqnqzVk
         jYVAh8KW2BZTa9yfl/bIcbbXzPMh73vd4bs/H8IkMWVWG+S8yhHYcwQ18/EoDCNudy+8
         j+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678902224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=elWTENHvE0PgCEqrOZpYTQtTUayrgelSMhbbtb8XlwE=;
        b=ZVY2XzHrzF0erqVtyYwrHlYLgxEQV2RycQnax2I6PtTWQ3z1g0EGJ2bFqMmkO7eXsk
         fAjgcdaFUTO+Ob7cM7CmEA4TirLc0K+ScdpWtIJ9Za74XMKulZW0PuHXzNPxB5jMIEnN
         XMKp1MLMnhMK8zh7oh1rd9krnpplzlrJKy7kuDyB/AFL9PHUVBuyRYl238c6BSjmfdHT
         XlZqWXjC+t8UZ7/C/ow8+m3gDNDllo2gPxcC48IM1+eUADdaxp2I+y8+XWEMoWxTbo5j
         jBQQArfMJ4nihX++IAS+eaUC0ZdeWVjjs0Qd86ZEIVwtiAbu+iuYfvbT6+qSSfF8u7RJ
         rSIg==
X-Gm-Message-State: AO0yUKU+c8bbDuChsi+hyvOTovJmD/bpuHDw+aLsmZ4INPcIekmL4JWK
        CGZe7YOJy+Uh67UWIuxP8GAthg==
X-Google-Smtp-Source: AK7set9ZQybZk4Go0qTy+YNljs85ZvpXJrcb/R8FPgyADbxRrSkfcRIVvq9yn/fpXD6ZHI+68CUTBg==
X-Received: by 2002:a05:600c:4f8e:b0:3e2:662:ade6 with SMTP id n14-20020a05600c4f8e00b003e20662ade6mr18136267wmq.26.1678902223887;
        Wed, 15 Mar 2023 10:43:43 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id k26-20020a7bc31a000000b003eb596cbc54sm2691862wmj.0.2023.03.15.10.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 10:43:43 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 213951FFBD;
        Wed, 15 Mar 2023 17:43:43 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Akihiko Odaki <akihiko.odaki@gmail.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        qemu-riscv@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Wu <wuhaotsh@google.com>, Cleber Rosa <crosa@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, qemu-ppc@nongnu.org,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stafford Horne <shorne@gmail.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Thomas Huth <huth@tuxfamily.org>,
        Vijai Kumar K <vijai@behindbytes.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Song Gao <gaosong@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Niek Linnenbank <nieklinnenbank@gmail.com>,
        Greg Kurz <groug@kaod.org>, Laurent Vivier <laurent@vivier.eu>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-block@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>, qemu-s390x@nongnu.org,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Bandan Das <bsd@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Paul Durrant <paul@xen.org>, Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 14/32] *: Add missing includes of qemu/error-report.h
Date:   Wed, 15 Mar 2023 17:43:13 +0000
Message-Id: <20230315174331.2959-15-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315174331.2959-1-alex.bennee@linaro.org>
References: <20230315174331.2959-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Richard Henderson <richard.henderson@linaro.org>

This had been pulled in via qemu/plugin.h from hw/core/cpu.h,
but that will be removed.

Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230310195252.210956-5-richard.henderson@linaro.org>
[AJB: add various additional cases shown by CI]
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 accel/accel-softmmu.c          | 2 +-
 block/monitor/block-hmp-cmds.c | 1 +
 dump/dump.c                    | 1 +
 dump/win_dump.c                | 1 +
 gdbstub/gdbstub.c              | 1 +
 hw/arm/collie.c                | 2 ++
 hw/arm/cubieboard.c            | 1 +
 hw/arm/musicpal.c              | 2 ++
 hw/arm/npcm7xx_boards.c        | 2 ++
 hw/arm/nseries.c               | 2 ++
 hw/arm/omap_sx1.c              | 2 ++
 hw/arm/orangepi.c              | 1 +
 hw/arm/palm.c                  | 2 ++
 hw/core/loader.c               | 1 +
 hw/core/machine-smp.c          | 2 ++
 hw/i386/kvm/xen_xenstore.c     | 1 +
 hw/i386/sgx.c                  | 1 +
 hw/intc/apic.c                 | 1 +
 hw/loongarch/acpi-build.c      | 1 +
 hw/loongarch/virt.c            | 2 ++
 hw/m68k/next-cube.c            | 1 +
 hw/m68k/q800.c                 | 1 +
 hw/m68k/virt.c                 | 1 +
 hw/mem/memory-device.c         | 1 +
 hw/mem/sparse-mem.c            | 1 +
 hw/openrisc/boot.c             | 1 +
 hw/ppc/spapr_softmmu.c         | 2 ++
 hw/riscv/opentitan.c           | 1 +
 hw/riscv/shakti_c.c            | 1 +
 hw/riscv/virt-acpi-build.c     | 1 +
 hw/vfio/display.c              | 1 +
 hw/vfio/igd.c                  | 1 +
 hw/vfio/migration.c            | 1 +
 linux-user/elfload.c           | 1 +
 migration/dirtyrate.c          | 1 +
 migration/exec.c               | 1 +
 target/i386/cpu.c              | 1 +
 target/i386/host-cpu.c         | 1 +
 target/i386/sev.c              | 1 +
 target/i386/whpx/whpx-apic.c   | 1 +
 target/mips/cpu.c              | 1 +
 target/s390x/cpu-sysemu.c      | 1 +
 target/s390x/cpu_models.c      | 1 +
 target/s390x/diag.c            | 2 ++
 ui/cocoa.m                     | 1 +
 45 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/accel/accel-softmmu.c b/accel/accel-softmmu.c
index f9cdafb148..9c804ba9e3 100644
--- a/accel/accel-softmmu.c
+++ b/accel/accel-softmmu.c
@@ -27,7 +27,7 @@
 #include "qemu/accel.h"
 #include "hw/boards.h"
 #include "sysemu/cpus.h"
-
+#include "qemu/error-report.h"
 #include "accel-softmmu.h"
 
 int accel_init_machine(AccelState *accel, MachineState *ms)
diff --git a/block/monitor/block-hmp-cmds.c b/block/monitor/block-hmp-cmds.c
index 6aa5f1be0c..2846083546 100644
--- a/block/monitor/block-hmp-cmds.c
+++ b/block/monitor/block-hmp-cmds.c
@@ -48,6 +48,7 @@
 #include "qemu/option.h"
 #include "qemu/sockets.h"
 #include "qemu/cutils.h"
+#include "qemu/error-report.h"
 #include "sysemu/sysemu.h"
 #include "monitor/monitor.h"
 #include "monitor/hmp.h"
diff --git a/dump/dump.c b/dump/dump.c
index 544d5bce3a..1f1a6edcab 100644
--- a/dump/dump.c
+++ b/dump/dump.c
@@ -24,6 +24,7 @@
 #include "qapi/qapi-commands-dump.h"
 #include "qapi/qapi-events-dump.h"
 #include "qapi/qmp/qerror.h"
+#include "qemu/error-report.h"
 #include "qemu/main-loop.h"
 #include "hw/misc/vmcoreinfo.h"
 #include "migration/blocker.h"
diff --git a/dump/win_dump.c b/dump/win_dump.c
index 0152f7330a..b7bfaff379 100644
--- a/dump/win_dump.c
+++ b/dump/win_dump.c
@@ -11,6 +11,7 @@
 #include "qemu/osdep.h"
 #include "sysemu/dump.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "qapi/qmp/qerror.h"
 #include "exec/cpu-defs.h"
 #include "hw/core/cpu.h"
diff --git a/gdbstub/gdbstub.c b/gdbstub/gdbstub.c
index d9e9bf9294..2a66371aa5 100644
--- a/gdbstub/gdbstub.c
+++ b/gdbstub/gdbstub.c
@@ -27,6 +27,7 @@
 #include "qemu/ctype.h"
 #include "qemu/cutils.h"
 #include "qemu/module.h"
+#include "qemu/error-report.h"
 #include "trace.h"
 #include "exec/gdbstub.h"
 #include "gdbstub/syscalls.h"
diff --git a/hw/arm/collie.c b/hw/arm/collie.c
index 9edff59370..a0ad1b8dc7 100644
--- a/hw/arm/collie.c
+++ b/hw/arm/collie.c
@@ -19,6 +19,8 @@
 #include "exec/address-spaces.h"
 #include "cpu.h"
 #include "qom/object.h"
+#include "qemu/error-report.h"
+
 
 #define RAM_SIZE            (512 * MiB)
 #define FLASH_SIZE          (32 * MiB)
diff --git a/hw/arm/cubieboard.c b/hw/arm/cubieboard.c
index 71a7df1508..8c7fa91529 100644
--- a/hw/arm/cubieboard.c
+++ b/hw/arm/cubieboard.c
@@ -17,6 +17,7 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "hw/boards.h"
 #include "hw/qdev-properties.h"
 #include "hw/arm/allwinner-a10.h"
diff --git a/hw/arm/musicpal.c b/hw/arm/musicpal.c
index 06d9add7c7..c9010b2ffb 100644
--- a/hw/arm/musicpal.c
+++ b/hw/arm/musicpal.c
@@ -37,6 +37,8 @@
 #include "qemu/cutils.h"
 #include "qom/object.h"
 #include "hw/net/mv88w8618_eth.h"
+#include "qemu/error-report.h"
+
 
 #define MP_MISC_BASE            0x80002000
 #define MP_MISC_SIZE            0x00001000
diff --git a/hw/arm/npcm7xx_boards.c b/hw/arm/npcm7xx_boards.c
index 9b31207a06..2aef579aac 100644
--- a/hw/arm/npcm7xx_boards.c
+++ b/hw/arm/npcm7xx_boards.c
@@ -30,6 +30,8 @@
 #include "sysemu/blockdev.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/block-backend.h"
+#include "qemu/error-report.h"
+
 
 #define NPCM7XX_POWER_ON_STRAPS_DEFAULT (           \
         NPCM7XX_PWRON_STRAP_SPI0F18 |               \
diff --git a/hw/arm/nseries.c b/hw/arm/nseries.c
index c9df063a08..9e49e9e177 100644
--- a/hw/arm/nseries.c
+++ b/hw/arm/nseries.c
@@ -45,6 +45,8 @@
 #include "hw/loader.h"
 #include "hw/sysbus.h"
 #include "qemu/log.h"
+#include "qemu/error-report.h"
+
 
 /* Nokia N8x0 support */
 struct n800_s {
diff --git a/hw/arm/omap_sx1.c b/hw/arm/omap_sx1.c
index e721292079..4bf1579f8c 100644
--- a/hw/arm/omap_sx1.c
+++ b/hw/arm/omap_sx1.c
@@ -37,6 +37,8 @@
 #include "exec/address-spaces.h"
 #include "cpu.h"
 #include "qemu/cutils.h"
+#include "qemu/error-report.h"
+
 
 /*****************************************************************************/
 /* Siemens SX1 Cellphone V1 */
diff --git a/hw/arm/orangepi.c b/hw/arm/orangepi.c
index 3ace474870..10653361ed 100644
--- a/hw/arm/orangepi.c
+++ b/hw/arm/orangepi.c
@@ -21,6 +21,7 @@
 #include "qemu/units.h"
 #include "exec/address-spaces.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "hw/boards.h"
 #include "hw/qdev-properties.h"
 #include "hw/arm/allwinner-h3.h"
diff --git a/hw/arm/palm.c b/hw/arm/palm.c
index 1457f10c83..17c11ac4ce 100644
--- a/hw/arm/palm.c
+++ b/hw/arm/palm.c
@@ -32,6 +32,8 @@
 #include "cpu.h"
 #include "qemu/cutils.h"
 #include "qom/object.h"
+#include "qemu/error-report.h"
+
 
 static uint64_t static_read(void *opaque, hwaddr offset, unsigned size)
 {
diff --git a/hw/core/loader.c b/hw/core/loader.c
index cd53235fed..11be97fe1b 100644
--- a/hw/core/loader.c
+++ b/hw/core/loader.c
@@ -44,6 +44,7 @@
 
 #include "qemu/osdep.h"
 #include "qemu/datadir.h"
+#include "qemu/error-report.h"
 #include "qapi/error.h"
 #include "qapi/qapi-commands-machine.h"
 #include "qapi/type-helpers.h"
diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index c3dab007da..89fe0cda42 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -20,6 +20,8 @@
 #include "qemu/osdep.h"
 #include "hw/boards.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
+
 
 /*
  * Report information of a machine's supported CPU topology hierarchy.
diff --git a/hw/i386/kvm/xen_xenstore.c b/hw/i386/kvm/xen_xenstore.c
index 2cadafd56a..900679af8a 100644
--- a/hw/i386/kvm/xen_xenstore.c
+++ b/hw/i386/kvm/xen_xenstore.c
@@ -15,6 +15,7 @@
 #include "qemu/module.h"
 #include "qemu/main-loop.h"
 #include "qemu/cutils.h"
+#include "qemu/error-report.h"
 #include "qapi/error.h"
 #include "qom/object.h"
 #include "migration/vmstate.h"
diff --git a/hw/i386/sgx.c b/hw/i386/sgx.c
index db004d17a6..70305547d4 100644
--- a/hw/i386/sgx.c
+++ b/hw/i386/sgx.c
@@ -18,6 +18,7 @@
 #include "monitor/monitor.h"
 #include "monitor/hmp-target.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "qapi/qapi-commands-misc-target.h"
 #include "exec/address-spaces.h"
 #include "sysemu/hw_accel.h"
diff --git a/hw/intc/apic.c b/hw/intc/apic.c
index 0ff060f721..20b5a94073 100644
--- a/hw/intc/apic.c
+++ b/hw/intc/apic.c
@@ -18,6 +18,7 @@
  */
 #include "qemu/osdep.h"
 #include "qemu/thread.h"
+#include "qemu/error-report.h"
 #include "hw/i386/apic_internal.h"
 #include "hw/i386/apic.h"
 #include "hw/intc/ioapic.h"
diff --git a/hw/loongarch/acpi-build.c b/hw/loongarch/acpi-build.c
index 6cb2472d33..8e3ce07367 100644
--- a/hw/loongarch/acpi-build.c
+++ b/hw/loongarch/acpi-build.c
@@ -7,6 +7,7 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "qemu/bitmap.h"
 #include "hw/pci/pci.h"
 #include "hw/core/cpu.h"
diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
index 38ef7cc49f..b702c3f51e 100644
--- a/hw/loongarch/virt.c
+++ b/hw/loongarch/virt.c
@@ -44,6 +44,8 @@
 #include "sysemu/tpm.h"
 #include "sysemu/block-backend.h"
 #include "hw/block/flash.h"
+#include "qemu/error-report.h"
+
 
 static void virt_flash_create(LoongArchMachineState *lams)
 {
diff --git a/hw/m68k/next-cube.c b/hw/m68k/next-cube.c
index e0d4a94f9d..ce8ee50b9e 100644
--- a/hw/m68k/next-cube.c
+++ b/hw/m68k/next-cube.c
@@ -24,6 +24,7 @@
 #include "hw/block/fdc.h"
 #include "hw/qdev-properties.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "ui/console.h"
 #include "target/m68k/cpu.h"
 #include "migration/vmstate.h"
diff --git a/hw/m68k/q800.c b/hw/m68k/q800.c
index 9d52ca6613..b35ecafbc7 100644
--- a/hw/m68k/q800.c
+++ b/hw/m68k/q800.c
@@ -45,6 +45,7 @@
 #include "hw/block/swim.h"
 #include "net/net.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "sysemu/qtest.h"
 #include "sysemu/runstate.h"
 #include "sysemu/reset.h"
diff --git a/hw/m68k/virt.c b/hw/m68k/virt.c
index 4cb5beef1a..754b9bdfcc 100644
--- a/hw/m68k/virt.c
+++ b/hw/m68k/virt.c
@@ -23,6 +23,7 @@
 #include "bootinfo.h"
 #include "net/net.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "sysemu/qtest.h"
 #include "sysemu/runstate.h"
 #include "sysemu/reset.h"
diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index d9f8301711..1636db9679 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -10,6 +10,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
 #include "hw/mem/memory-device.h"
 #include "qapi/error.h"
 #include "hw/boards.h"
diff --git a/hw/mem/sparse-mem.c b/hw/mem/sparse-mem.c
index 72f038d47d..6e8f4f84fb 100644
--- a/hw/mem/sparse-mem.c
+++ b/hw/mem/sparse-mem.c
@@ -11,6 +11,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
 
 #include "hw/qdev-properties.h"
 #include "hw/sysbus.h"
diff --git a/hw/openrisc/boot.c b/hw/openrisc/boot.c
index 007e80cd5a..55475aa6d6 100644
--- a/hw/openrisc/boot.c
+++ b/hw/openrisc/boot.c
@@ -15,6 +15,7 @@
 #include "sysemu/device_tree.h"
 #include "sysemu/qtest.h"
 #include "sysemu/reset.h"
+#include "qemu/error-report.h"
 
 #include <libfdt.h>
 
diff --git a/hw/ppc/spapr_softmmu.c b/hw/ppc/spapr_softmmu.c
index 5170a33369..278666317e 100644
--- a/hw/ppc/spapr_softmmu.c
+++ b/hw/ppc/spapr_softmmu.c
@@ -1,12 +1,14 @@
 #include "qemu/osdep.h"
 #include "qemu/cutils.h"
 #include "qemu/memalign.h"
+#include "qemu/error-report.h"
 #include "cpu.h"
 #include "helper_regs.h"
 #include "hw/ppc/spapr.h"
 #include "mmu-hash64.h"
 #include "mmu-book3s-v3.h"
 
+
 static inline bool valid_ptex(PowerPCCPU *cpu, target_ulong ptex)
 {
     /*
diff --git a/hw/riscv/opentitan.c b/hw/riscv/opentitan.c
index b06944d382..bc678766e7 100644
--- a/hw/riscv/opentitan.c
+++ b/hw/riscv/opentitan.c
@@ -22,6 +22,7 @@
 #include "qemu/cutils.h"
 #include "hw/riscv/opentitan.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "hw/boards.h"
 #include "hw/misc/unimp.h"
 #include "hw/riscv/boot.h"
diff --git a/hw/riscv/shakti_c.c b/hw/riscv/shakti_c.c
index e43cc9445c..12ea74b032 100644
--- a/hw/riscv/shakti_c.c
+++ b/hw/riscv/shakti_c.c
@@ -20,6 +20,7 @@
 #include "hw/boards.h"
 #include "hw/riscv/shakti_c.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "hw/intc/sifive_plic.h"
 #include "hw/intc/riscv_aclint.h"
 #include "sysemu/sysemu.h"
diff --git a/hw/riscv/virt-acpi-build.c b/hw/riscv/virt-acpi-build.c
index 82da0a238c..7331248f59 100644
--- a/hw/riscv/virt-acpi-build.c
+++ b/hw/riscv/virt-acpi-build.c
@@ -29,6 +29,7 @@
 #include "hw/acpi/aml-build.h"
 #include "hw/acpi/utils.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "sysemu/reset.h"
 #include "migration/vmstate.h"
 #include "hw/riscv/virt.h"
diff --git a/hw/vfio/display.c b/hw/vfio/display.c
index 78f4d82c1c..bec864f482 100644
--- a/hw/vfio/display.c
+++ b/hw/vfio/display.c
@@ -14,6 +14,7 @@
 #include <linux/vfio.h>
 #include <sys/ioctl.h>
 
+#include "qemu/error-report.h"
 #include "hw/display/edid.h"
 #include "ui/console.h"
 #include "qapi/error.h"
diff --git a/hw/vfio/igd.c b/hw/vfio/igd.c
index afe3fe7efc..b31ee79c60 100644
--- a/hw/vfio/igd.c
+++ b/hw/vfio/igd.c
@@ -12,6 +12,7 @@
 
 #include "qemu/osdep.h"
 #include "qemu/units.h"
+#include "qemu/error-report.h"
 #include "qapi/error.h"
 #include "hw/hw.h"
 #include "hw/nvram/fw_cfg.h"
diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
index 1a1a8659c8..6b58dddb88 100644
--- a/hw/vfio/migration.c
+++ b/hw/vfio/migration.c
@@ -11,6 +11,7 @@
 #include "qemu/main-loop.h"
 #include "qemu/cutils.h"
 #include "qemu/units.h"
+#include "qemu/error-report.h"
 #include <linux/vfio.h>
 #include <sys/ioctl.h>
 
diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index 150d1d4503..1dbc1f0f9b 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -18,6 +18,7 @@
 #include "qemu/units.h"
 #include "qemu/selfmap.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "target_signal.h"
 #include "accel/tcg/debuginfo.h"
 
diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index 575d48c397..180ba38c7a 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -11,6 +11,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
 #include <zlib.h>
 #include "qapi/error.h"
 #include "cpu.h"
diff --git a/migration/exec.c b/migration/exec.c
index 38604d73a6..2bf882bbe1 100644
--- a/migration/exec.c
+++ b/migration/exec.c
@@ -18,6 +18,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
 #include "channel.h"
 #include "exec.h"
 #include "migration.h"
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index cab1e2a957..6576287e5b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -29,6 +29,7 @@
 #include "kvm/kvm_i386.h"
 #include "sev.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "qapi/qapi-visit-machine.h"
 #include "qapi/qmp/qerror.h"
 #include "standard-headers/asm-x86/kvm_para.h"
diff --git a/target/i386/host-cpu.c b/target/i386/host-cpu.c
index 10f8aba86e..92ecb7254b 100644
--- a/target/i386/host-cpu.c
+++ b/target/i386/host-cpu.c
@@ -11,6 +11,7 @@
 #include "cpu.h"
 #include "host-cpu.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "sysemu/sysemu.h"
 
 /* Note: Only safe for use on x86(-64) hosts */
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 0ec970496e..859e06f6ad 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -23,6 +23,7 @@
 #include "qemu/base64.h"
 #include "qemu/module.h"
 #include "qemu/uuid.h"
+#include "qemu/error-report.h"
 #include "crypto/hash.h"
 #include "sysemu/kvm.h"
 #include "sev.h"
diff --git a/target/i386/whpx/whpx-apic.c b/target/i386/whpx/whpx-apic.c
index c15df35ad6..8710e37567 100644
--- a/target/i386/whpx/whpx-apic.c
+++ b/target/i386/whpx/whpx-apic.c
@@ -11,6 +11,7 @@
  * See the COPYING file in the top-level directory.
  */
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
 #include "cpu.h"
 #include "hw/i386/apic_internal.h"
 #include "hw/i386/apic-msidef.h"
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 543da911e3..01e0fbe10d 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -21,6 +21,7 @@
 #include "qemu/osdep.h"
 #include "qemu/cutils.h"
 #include "qemu/qemu-print.h"
+#include "qemu/error-report.h"
 #include "qapi/error.h"
 #include "cpu.h"
 #include "internal.h"
diff --git a/target/s390x/cpu-sysemu.c b/target/s390x/cpu-sysemu.c
index 948e4bd3e0..97d6c760a8 100644
--- a/target/s390x/cpu-sysemu.c
+++ b/target/s390x/cpu-sysemu.c
@@ -21,6 +21,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
 #include "qapi/error.h"
 #include "cpu.h"
 #include "s390x-internal.h"
diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
index 065ec6d66c..457b5cb10c 100644
--- a/target/s390x/cpu_models.c
+++ b/target/s390x/cpu_models.c
@@ -17,6 +17,7 @@
 #include "sysemu/kvm.h"
 #include "sysemu/tcg.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "qapi/visitor.h"
 #include "qemu/module.h"
 #include "qemu/hw-version.h"
diff --git a/target/s390x/diag.c b/target/s390x/diag.c
index 76b01dcd68..e5f0df19e7 100644
--- a/target/s390x/diag.c
+++ b/target/s390x/diag.c
@@ -22,6 +22,8 @@
 #include "hw/s390x/pv.h"
 #include "sysemu/kvm.h"
 #include "kvm/kvm_s390x.h"
+#include "qemu/error-report.h"
+
 
 int handle_diag_288(CPUS390XState *env, uint64_t r1, uint64_t r3)
 {
diff --git a/ui/cocoa.m b/ui/cocoa.m
index 985a0f5069..168170a8a6 100644
--- a/ui/cocoa.m
+++ b/ui/cocoa.m
@@ -46,6 +46,7 @@
 #include "qemu/cutils.h"
 #include "qemu/main-loop.h"
 #include "qemu/module.h"
+#include "qemu/error-report.h"
 #include <Carbon/Carbon.h>
 #include "hw/core/cpu.h"
 
-- 
2.39.2

