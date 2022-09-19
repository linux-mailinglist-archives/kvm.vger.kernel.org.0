Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4CB5BD825
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 01:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiISXTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 19:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiISXTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 19:19:05 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8925073B
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 16:19:00 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id go34so2242123ejc.2
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 16:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=18L1CetNQZRcWgrF+bLfFklTWcjPuzsdD8LCMjAGf1E=;
        b=V5XT6ePhglxVVnzO7wTKlIaCCViZpN/zYqMG+wnd7lcxvsQ6bFt9WuDSwUs61yQfOq
         pOOrLokv5qVrEanQf1jerp+JQbj02Jx+4/DTXLbk4VGzNoVT9LMVzK0PC7mepLvnFIDH
         zNU2Iq8+Tt8hwKBJJHRAekFsH64zOK5KDx2DOj+3xLFeQHbqLBayBI84MwLSLyDfmRzn
         Bn02SXOCet8dJvaSko0kLZJJa9dUhgUekK1verWyRQXlYweUX2DfajwnVTkn8xSB6xdY
         xhTzjewc6CjRhf/YtZTPMPm/29EOtiCPc87CrZipbkfmhngf1laAFdu+hBwMKfqzao83
         81vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=18L1CetNQZRcWgrF+bLfFklTWcjPuzsdD8LCMjAGf1E=;
        b=H3Rfh/v564ByjR4YeDXCCEtQbs1uRbmg0G14tiTGMl8Umlxy8zxcbcG/SaC6vBsnGw
         /fLP7zGA5DUaaj2pEyLZEgnyuOpEZdXgv/iF7a6f7odGxK62r9mtDh8Na155rHKxyvgO
         N009j4CM0xO/1x16v/btESv1DXE5XuP+unVieRAlAmELtbURO6b/5KvS0PGN/6bA/xRz
         V76kh1Th+8oJlw3ajbmp3FIAxllpCC1FYhLOie6z/ZrTk/kmZPDmqRZDkV83l9RKXHeY
         KrsSXRUVzbnp1lRvy+q1lCgjW1CBNmbuhipCMOQ+L9zsoKzzCCehe7OiyQea4djZXDE8
         v23g==
X-Gm-Message-State: ACrzQf2jNzJVK1qi95NEtp69Yk3px3+OLNP474Lqi3gcEJ5KR85qW7Se
        8LyyQ8eMM0bE93TxLQdLVys=
X-Google-Smtp-Source: AMsMyM4eJjU/NOUzNOFcRv5on/MypRLn/EbDnZquypCWBAyuQiQwWxxTAmP7wvB5d1YGt/EQ80NS8w==
X-Received: by 2002:a17:907:2e0b:b0:77f:5fd8:8712 with SMTP id ig11-20020a1709072e0b00b0077f5fd88712mr13751388ejc.575.1663629539177;
        Mon, 19 Sep 2022 16:18:59 -0700 (PDT)
Received: from localhost.localdomain (dynamic-078-054-077-055.78.54.pool.telefonica.de. [78.54.77.55])
        by smtp.gmail.com with ESMTPSA id rn24-20020a170906d93800b00780f6071b5dsm4800926ejb.188.2022.09.19.16.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 16:18:58 -0700 (PDT)
From:   Bernhard Beschow <shentey@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bandan Das <bsd@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Sergio Lopez <slp@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Cameron Esfahani <dirty@apple.com>,
        Michael Rolnik <mrolnik@gmail.com>,
        Song Gao <gaosong@loongson.cn>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Greg Kurz <groug@kaod.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Peter Xu <peterx@redhat.com>, Joel Stanley <joel@jms.id.au>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, haxm-team@intel.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, qemu-block@nongnu.org,
        Eduardo Habkost <eduardo@habkost.net>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        qemu-ppc@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Helge Deller <deller@gmx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        qemu-riscv@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Alexander Graf <agraf@csgraf.de>,
        Thomas Huth <thuth@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Eric Farman <farman@linux.ibm.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Alexander Bulekov <alxndr@bu.edu>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        xen-devel@lists.xenproject.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        John Snow <jsnow@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Alistair Francis <alistair@alistair23.me>,
        Jason Herne <jjherne@linux.ibm.com>,
        Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH 7/9] hw/sysbus: Introduce dedicated struct SysBusState for TYPE_SYSTEM_BUS
Date:   Tue, 20 Sep 2022 01:17:18 +0200
Message-Id: <20220919231720.163121-8-shentey@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220919231720.163121-1-shentey@gmail.com>
References: <20220919231720.163121-1-shentey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With this out of the way, in the next step, SysBusState gains attributes
for its memory and address recouces.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 hw/core/sysbus.c              | 4 ++--
 include/hw/boards.h           | 3 ++-
 include/hw/misc/macio/macio.h | 2 +-
 include/hw/sysbus.h           | 8 ++++++--
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/hw/core/sysbus.c b/hw/core/sysbus.c
index 16a9b4d7a0..1100f3ad6c 100644
--- a/hw/core/sysbus.c
+++ b/hw/core/sysbus.c
@@ -84,7 +84,7 @@ static void system_bus_class_init(ObjectClass *klass, void *data)
 static const TypeInfo system_bus_info = {
     .name = TYPE_SYSTEM_BUS,
     .parent = TYPE_BUS,
-    .instance_size = sizeof(BusState),
+    .instance_size = sizeof(SysBusState),
     .class_init = system_bus_class_init,
 };
 
@@ -343,7 +343,7 @@ BusState *sysbus_get_default(void)
         return NULL;
     }
 
-    return &current_machine->main_system_bus;
+    return &current_machine->main_system_bus.parent_obj;
 }
 
 static void sysbus_register_types(void)
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 7af940102d..63a4f990ea 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -11,6 +11,7 @@
 #include "qemu/module.h"
 #include "qom/object.h"
 #include "hw/core/cpu.h"
+#include "hw/sysbus.h"
 
 #define TYPE_MACHINE_SUFFIX "-machine"
 
@@ -346,7 +347,7 @@ struct MachineState {
      */
     MemoryRegion *ram;
     DeviceMemoryState *device_memory;
-    BusState main_system_bus;
+    SysBusState main_system_bus;
 
     ram_addr_t ram_size;
     ram_addr_t maxram_size;
diff --git a/include/hw/misc/macio/macio.h b/include/hw/misc/macio/macio.h
index 6c05f3bfd2..0944be587f 100644
--- a/include/hw/misc/macio/macio.h
+++ b/include/hw/misc/macio/macio.h
@@ -44,7 +44,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(MacIOBusState, MACIO_BUS)
 
 struct MacIOBusState {
     /*< private >*/
-    BusState parent_obj;
+    SysBusState parent_obj;
 };
 
 /* MacIO IDE */
diff --git a/include/hw/sysbus.h b/include/hw/sysbus.h
index 3564b7b6a2..5bb3b88501 100644
--- a/include/hw/sysbus.h
+++ b/include/hw/sysbus.h
@@ -11,9 +11,13 @@
 #define QDEV_MAX_PIO 32
 
 #define TYPE_SYSTEM_BUS "System"
-DECLARE_INSTANCE_CHECKER(BusState, SYSTEM_BUS,
-                         TYPE_SYSTEM_BUS)
+OBJECT_DECLARE_SIMPLE_TYPE(SysBusState, SYSTEM_BUS)
 
+struct SysBusState {
+    /*< private >*/
+    BusState parent_obj;
+    /*< public >*/
+};
 
 #define TYPE_SYS_BUS_DEVICE "sys-bus-device"
 OBJECT_DECLARE_TYPE(SysBusDevice, SysBusDeviceClass,
-- 
2.37.3

