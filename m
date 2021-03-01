Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EE7327F5D
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 14:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbhCANYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 08:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbhCANX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 08:23:59 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFDFC061756
        for <kvm@vger.kernel.org>; Mon,  1 Mar 2021 05:23:18 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id p21so25417286lfu.11
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 05:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KbNn16NW2voIZnb30QSq1tkvME8A5PE6xaA6lY++9bM=;
        b=Mcb9Sel/Cij671Jq3Mp6O1ajs8csB043sivwyFBDKNS4fY2ti2iYcoe/poPnGqaCbn
         +xyG86Jebl+2OR2EJgCHyxZllJuZgWi9ZiJY21LNajSuUlpwsDNpCQ5Q9QAFYv0sEjpr
         c4HBLuTtsJAZGJUlPTWSF9ki/ekzTIkvvQwL6N1NFTgEnLNXC1hm6BC4Vy3TguUsXvJH
         Ubi9/0DNbGe4lDqGfnp7Rau7IqjryIrr1EcqOhHIUUEDONibp5zBaNctPQGwgGYJp9oQ
         s6LxzN+jN9Cyg2ygWqlsV32MZF1Aiz4dK8nx1boFp0PzPob9rzKpVvd8AYajXxwtqKSy
         BG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KbNn16NW2voIZnb30QSq1tkvME8A5PE6xaA6lY++9bM=;
        b=mPFPoC8ss1iFoIXqZkENGNI8qBEzWIKvefDLAKm2FUpXJKpTIkqUVYPL7o1FTIxW72
         CNJzPD6ok245A/SB0In3YITBgYkr7RAFCrhRwaL+oYQ/10VUsPuT5iOclsFrd5XQcOCE
         /hMqn1Twil38tbMbw/OESoDQ9B3i+d73RoNOwfF8JzU3hiPZmPf1Jcd5RfOmxShCawHO
         TUv8yS4SIBo8VbjWsjnFFKP9RTgixYktPEP9GXazA5vWp7ijM380vMlpDwYEMtihaxmk
         wD3sqo6CnaRscRo2vnvXyZplzCG/W1Ha0KYXStje+NG0IkM5NxHDc9RM16qs8/10/+g+
         6ylQ==
X-Gm-Message-State: AOAM530M9SfD1DhD4aooUZA/69bcTN6hMja0f1Tiu0sKcUnP5iPeRWZf
        JcE63tXqmQdKMvklwfLUwW4=
X-Google-Smtp-Source: ABdhPJy5AUaM9OlJQciR8h4OFDb96hBCTYCCzbhLuie3Bf1IQqD3idGVjViOAwhytBIVbXlTFy8lgQ==
X-Received: by 2002:ac2:420b:: with SMTP id y11mr9462077lfh.215.1614604997409;
        Mon, 01 Mar 2021 05:23:17 -0800 (PST)
Received: from localhost.localdomain (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id w26sm2291420lfr.186.2021.03.01.05.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 05:23:17 -0800 (PST)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, Elena Afanasova <eafanasova@gmail.com>
Subject: [PATCH RFC] hw/misc/pc-testdev: add support for ioregionfd testing
Date:   Mon,  1 Mar 2021 16:16:28 +0300
Message-Id: <20210301131628.5211-1-eafanasova@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
---
 hw/misc/pc-testdev.c      | 74 +++++++++++++++++++++++++++++++++++++++
 include/sysemu/kvm.h      |  4 +--
 linux-headers/linux/kvm.h | 24 +++++++++++++
 3 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/hw/misc/pc-testdev.c b/hw/misc/pc-testdev.c
index e389651869..38355923ca 100644
--- a/hw/misc/pc-testdev.c
+++ b/hw/misc/pc-testdev.c
@@ -40,6 +40,9 @@
 #include "hw/irq.h"
 #include "hw/isa/isa.h"
 #include "qom/object.h"
+#include "sysemu/kvm.h"
+#include <linux/kvm.h>
+#include "hw/qdev-properties.h"
 
 #define IOMEM_LEN    0x10000
 
@@ -53,6 +56,15 @@ struct PCTestdev {
     MemoryRegion iomem;
     uint32_t ioport_data;
     char iomem_buf[IOMEM_LEN];
+
+    uint64_t guest_paddr;
+    uint64_t memory_size;
+    char *read_fifo;
+    char *write_fifo;
+    bool posted_writes;
+    bool pio;
+    int rfd;
+    int wfd;
 };
 
 #define TYPE_TESTDEV "pc-testdev"
@@ -169,6 +181,9 @@ static const MemoryRegionOps test_iomem_ops = {
 
 static void testdev_realizefn(DeviceState *d, Error **errp)
 {
+    struct kvm_ioregion ioreg;
+    int flags = 0;
+
     ISADevice *isa = ISA_DEVICE(d);
     PCTestdev *dev = TESTDEV(d);
     MemoryRegion *mem = isa_address_space(isa);
@@ -191,14 +206,73 @@ static void testdev_realizefn(DeviceState *d, Error **errp)
     memory_region_add_subregion(io,  0xe8,       &dev->ioport_byte);
     memory_region_add_subregion(io,  0x2000,     &dev->irq);
     memory_region_add_subregion(mem, 0xff000000, &dev->iomem);
+
+    if (!dev->guest_paddr || !dev->write_fifo) {
+        return;
+    }
+
+    dev->wfd = open(dev->write_fifo, O_WRONLY);
+    if (dev->wfd < 0) {
+        error_report("failed to open write fifo %s", dev->write_fifo);
+        return;
+    }
+
+    if (dev->read_fifo) {
+        dev->rfd = open(dev->read_fifo, O_RDONLY);
+        if (dev->rfd < 0) {
+            error_report("failed to open read fifo %s", dev->read_fifo);
+            close(dev->wfd);
+            return;
+        }
+    }
+
+    flags |= dev->pio ? KVM_IOREGION_PIO : 0;
+    flags |= dev->posted_writes ? KVM_IOREGION_POSTED_WRITES : 0;
+    ioreg.guest_paddr = dev->guest_paddr;
+    ioreg.memory_size = dev->memory_size;
+    ioreg.write_fd = dev->wfd;
+    ioreg.read_fd = dev->rfd;
+    ioreg.flags = flags;
+    kvm_vm_ioctl(kvm_state, KVM_SET_IOREGION, &ioreg);
+}
+
+static void testdev_unrealizefn(DeviceState *d)
+{
+    struct kvm_ioregion ioreg;
+    PCTestdev *dev = TESTDEV(d);
+
+    if (!dev->guest_paddr || !dev->write_fifo) {
+        return;
+    }
+
+    ioreg.guest_paddr = dev->guest_paddr;
+    ioreg.memory_size = dev->memory_size;
+    ioreg.flags = KVM_IOREGION_DEASSIGN;
+    kvm_vm_ioctl(kvm_state, KVM_SET_IOREGION, &ioreg);
+    close(dev->wfd);
+    if (dev->rfd > 0) {
+        close(dev->rfd);
+    }
 }
 
+static Property ioregionfd_properties[] = {
+    DEFINE_PROP_UINT64("addr", PCTestdev, guest_paddr, 0),
+    DEFINE_PROP_UINT64("size", PCTestdev, memory_size, 0),
+    DEFINE_PROP_STRING("rfifo", PCTestdev, read_fifo),
+    DEFINE_PROP_STRING("wfifo", PCTestdev, write_fifo),
+    DEFINE_PROP_BOOL("pio", PCTestdev, pio, false),
+    DEFINE_PROP_BOOL("pw", PCTestdev, posted_writes, false),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
 static void testdev_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(klass);
 
     set_bit(DEVICE_CATEGORY_MISC, dc->categories);
     dc->realize = testdev_realizefn;
+    dc->unrealize = testdev_unrealizefn;
+    device_class_set_props(dc, ioregionfd_properties);
 }
 
 static const TypeInfo testdev_info = {
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 687c598be9..d68728764a 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -234,6 +234,8 @@ int kvm_has_intx_set_mask(void);
 bool kvm_arm_supports_user_irq(void);
 
 
+int kvm_vm_ioctl(KVMState *s, int type, ...);
+
 #ifdef NEED_CPU_H
 #include "cpu.h"
 
@@ -257,8 +259,6 @@ void phys_mem_set_alloc(void *(*alloc)(size_t, uint64_t *align, bool shared));
 
 int kvm_ioctl(KVMState *s, int type, ...);
 
-int kvm_vm_ioctl(KVMState *s, int type, ...);
-
 int kvm_vcpu_ioctl(CPUState *cpu, int type, ...);
 
 /**
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 020b62a619..c426fa1e56 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -733,6 +733,29 @@ struct kvm_ioeventfd {
 	__u8  pad[36];
 };
 
+enum {
+	kvm_ioregion_flag_nr_pio,
+	kvm_ioregion_flag_nr_posted_writes,
+	kvm_ioregion_flag_nr_deassign,
+	kvm_ioregion_flag_nr_max,
+};
+
+#define KVM_IOREGION_PIO (1 << kvm_ioregion_flag_nr_pio)
+#define KVM_IOREGION_POSTED_WRITES (1 << kvm_ioregion_flag_nr_posted_writes)
+#define KVM_IOREGION_DEASSIGN (1 << kvm_ioregion_flag_nr_deassign)
+
+#define KVM_IOREGION_VALID_FLAG_MASK ((1 << kvm_ioregion_flag_nr_max) - 1)
+
+struct kvm_ioregion {
+	__u64 guest_paddr; /* guest physical address */
+	__u64 memory_size; /* bytes */
+	__u64 user_data;
+	__s32 read_fd;
+	__s32 write_fd;
+	__u32 flags;
+	__u8  pad[28];
+};
+
 #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
@@ -1311,6 +1334,7 @@ struct kvm_vfio_spapr_tce {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
+#define KVM_SET_IOREGION          _IOW(KVMIO,  0x49, struct kvm_ioregion)
 
 /* enable ucontrol for s390 */
 struct kvm_s390_ucas_mapping {
-- 
2.25.1

