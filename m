Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE631A8001
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391100AbgDNOkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:40:42 -0400
Received: from foss.arm.com ([217.140.110.172]:57196 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391071AbgDNOk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 10:40:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4B3B1396;
        Tue, 14 Apr 2020 07:40:14 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0715E3F73D;
        Tue, 14 Apr 2020 07:40:13 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 15/18] Don't ignore errors registering a device, ioport or mmio emulation
Date:   Tue, 14 Apr 2020 15:39:43 +0100
Message-Id: <20200414143946.1521-16-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414143946.1521-1-alexandru.elisei@arm.com>
References: <20200414143946.1521-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An error returned by device__register, kvm__register_mmio and
ioport__register means that the device will
not be emulated properly. Annotate the functions with __must_check, so we
get a compiler warning when this error is ignored.

And fix several instances where the caller returns 0 even if the function
failed.

Also make sure the ioport emulation code uses ioport_remove consistently.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/ioport.c          |  3 +-
 hw/i8042.c            | 12 ++++++--
 hw/vesa.c             |  4 ++-
 include/kvm/devices.h |  3 +-
 include/kvm/ioport.h  |  6 ++--
 include/kvm/kvm.h     |  6 ++--
 ioport.c              | 25 ++++++++--------
 mips/kvm.c            |  3 +-
 powerpc/ioport.c      |  3 +-
 virtio/mmio.c         | 13 +++++++--
 x86/ioport.c          | 66 ++++++++++++++++++++++++++++++++-----------
 11 files changed, 101 insertions(+), 43 deletions(-)

diff --git a/arm/ioport.c b/arm/ioport.c
index bdd30b6fe812..2f0feb9ab69f 100644
--- a/arm/ioport.c
+++ b/arm/ioport.c
@@ -1,8 +1,9 @@
 #include "kvm/ioport.h"
 #include "kvm/irq.h"
 
-void ioport__setup_arch(struct kvm *kvm)
+int ioport__setup_arch(struct kvm *kvm)
 {
+	return 0;
 }
 
 void ioport__map_irq(u8 *irq)
diff --git a/hw/i8042.c b/hw/i8042.c
index 2d8c96e9c7e6..37a99a2dc6b8 100644
--- a/hw/i8042.c
+++ b/hw/i8042.c
@@ -349,10 +349,18 @@ static struct ioport_operations kbd_ops = {
 
 int kbd__init(struct kvm *kvm)
 {
+	int r;
+
 	kbd_reset();
 	state.kvm = kvm;
-	ioport__register(kvm, I8042_DATA_REG, &kbd_ops, 2, NULL);
-	ioport__register(kvm, I8042_COMMAND_REG, &kbd_ops, 2, NULL);
+	r = ioport__register(kvm, I8042_DATA_REG, &kbd_ops, 2, NULL);
+	if (r < 0)
+		return r;
+	r = ioport__register(kvm, I8042_COMMAND_REG, &kbd_ops, 2, NULL);
+	if (r < 0) {
+		ioport__unregister(kvm, I8042_DATA_REG);
+		return r;
+	}
 
 	return 0;
 }
diff --git a/hw/vesa.c b/hw/vesa.c
index ce3d43c38356..5646a5af9672 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -70,7 +70,9 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 
 	vesa_base_addr			= (u16)r;
 	vesa_pci_device.bar[0]		= cpu_to_le32(vesa_base_addr | PCI_BASE_ADDRESS_SPACE_IO);
-	device__register(&vesa_device);
+	r = device__register(&vesa_device);
+	if (r < 0)
+		return ERR_PTR(r);
 
 	mem = mmap(NULL, VESA_MEM_SIZE, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
 	if (mem == MAP_FAILED)
diff --git a/include/kvm/devices.h b/include/kvm/devices.h
index 405f19521977..e445db6f56b1 100644
--- a/include/kvm/devices.h
+++ b/include/kvm/devices.h
@@ -3,6 +3,7 @@
 
 #include <linux/rbtree.h>
 #include <linux/types.h>
+#include <linux/compiler.h>
 
 enum device_bus_type {
 	DEVICE_BUS_PCI,
@@ -18,7 +19,7 @@ struct device_header {
 	struct rb_node		node;
 };
 
-int device__register(struct device_header *dev);
+int __must_check device__register(struct device_header *dev);
 void device__unregister(struct device_header *dev);
 struct device_header *device__find_dev(enum device_bus_type bus_type,
 				       u8 dev_num);
diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
index 8c86b7151f25..62a719327e3f 100644
--- a/include/kvm/ioport.h
+++ b/include/kvm/ioport.h
@@ -33,11 +33,11 @@ struct ioport_operations {
 							    enum irq_type));
 };
 
-void ioport__setup_arch(struct kvm *kvm);
+int ioport__setup_arch(struct kvm *kvm);
 void ioport__map_irq(u8 *irq);
 
-int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops,
-			int count, void *param);
+int __must_check ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops,
+				  int count, void *param);
 int ioport__unregister(struct kvm *kvm, u16 port);
 int ioport__init(struct kvm *kvm);
 int ioport__exit(struct kvm *kvm);
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index c6dc6ef72d11..50119a8672eb 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -128,9 +128,9 @@ static inline int kvm__reserve_mem(struct kvm *kvm, u64 guest_phys, u64 size)
 				 KVM_MEM_TYPE_RESERVED);
 }
 
-int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool coalesce,
-		       void (*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr),
-			void *ptr);
+int __must_check kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool coalesce,
+				    void (*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr),
+				    void *ptr);
 bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr);
 void kvm__reboot(struct kvm *kvm);
 void kvm__pause(struct kvm *kvm);
diff --git a/ioport.c b/ioport.c
index a72e4035881a..cb778ed8d757 100644
--- a/ioport.c
+++ b/ioport.c
@@ -73,7 +73,7 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 	entry = ioport_search(&ioport_tree, port);
 	if (entry) {
 		pr_warning("ioport re-registered: %x", port);
-		rb_int_erase(&ioport_tree, &entry->node);
+		ioport_remove(&ioport_tree, entry);
 	}
 
 	entry = malloc(sizeof(*entry));
@@ -91,16 +91,21 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 	};
 
 	r = ioport_insert(&ioport_tree, entry);
-	if (r < 0) {
-		free(entry);
-		br_write_unlock(kvm);
-		return r;
-	}
-
-	device__register(&entry->dev_hdr);
+	if (r < 0)
+		goto out_free;
+	r = device__register(&entry->dev_hdr);
+	if (r < 0)
+		goto out_remove;
 	br_write_unlock(kvm);
 
 	return port;
+
+out_remove:
+	ioport_remove(&ioport_tree, entry);
+out_free:
+	free(entry);
+	br_write_unlock(kvm);
+	return r;
 }
 
 int ioport__unregister(struct kvm *kvm, u16 port)
@@ -196,9 +201,7 @@ out:
 
 int ioport__init(struct kvm *kvm)
 {
-	ioport__setup_arch(kvm);
-
-	return 0;
+	return ioport__setup_arch(kvm);
 }
 dev_base_init(ioport__init);
 
diff --git a/mips/kvm.c b/mips/kvm.c
index 211770da0d85..26355930d3b6 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -100,8 +100,9 @@ void kvm__irq_trigger(struct kvm *kvm, int irq)
 		die_perror("KVM_IRQ_LINE ioctl");
 }
 
-void ioport__setup_arch(struct kvm *kvm)
+int ioport__setup_arch(struct kvm *kvm)
 {
+	return 0;
 }
 
 bool kvm__arch_cpu_supports_vm(void)
diff --git a/powerpc/ioport.c b/powerpc/ioport.c
index 58dc625c54fe..0c188b61a51a 100644
--- a/powerpc/ioport.c
+++ b/powerpc/ioport.c
@@ -12,9 +12,10 @@
 
 #include <stdlib.h>
 
-void ioport__setup_arch(struct kvm *kvm)
+int ioport__setup_arch(struct kvm *kvm)
 {
 	/* PPC has no legacy ioports to set up */
+	return 0;
 }
 
 void ioport__map_irq(u8 *irq)
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 03cecc366292..5537c39367d6 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -292,13 +292,16 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		     int device_id, int subsys_id, int class)
 {
 	struct virtio_mmio *vmmio = vdev->virtio;
+	int r;
 
 	vmmio->addr	= virtio_mmio_get_io_space_block(VIRTIO_MMIO_IO_SIZE);
 	vmmio->kvm	= kvm;
 	vmmio->dev	= dev;
 
-	kvm__register_mmio(kvm, vmmio->addr, VIRTIO_MMIO_IO_SIZE,
-			   false, virtio_mmio_mmio_callback, vdev);
+	r = kvm__register_mmio(kvm, vmmio->addr, VIRTIO_MMIO_IO_SIZE,
+			       false, virtio_mmio_mmio_callback, vdev);
+	if (r < 0)
+		return r;
 
 	vmmio->hdr = (struct virtio_mmio_hdr) {
 		.magic		= {'v', 'i', 'r', 't'},
@@ -313,7 +316,11 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		.data		= generate_virtio_mmio_fdt_node,
 	};
 
-	device__register(&vmmio->dev_hdr);
+	r = device__register(&vmmio->dev_hdr);
+	if (r < 0) {
+		kvm__deregister_mmio(kvm, vmmio->addr);
+		return r;
+	}
 
 	/*
 	 * Instantiate guest virtio-mmio devices using kernel command line
diff --git a/x86/ioport.c b/x86/ioport.c
index 8572c758ed4f..7ad7b8f3f497 100644
--- a/x86/ioport.c
+++ b/x86/ioport.c
@@ -69,50 +69,84 @@ void ioport__map_irq(u8 *irq)
 {
 }
 
-void ioport__setup_arch(struct kvm *kvm)
+int ioport__setup_arch(struct kvm *kvm)
 {
+	int r;
+
 	/* Legacy ioport setup */
 
 	/* 0000 - 001F - DMA1 controller */
-	ioport__register(kvm, 0x0000, &dummy_read_write_ioport_ops, 32, NULL);
+	r = ioport__register(kvm, 0x0000, &dummy_read_write_ioport_ops, 32, NULL);
+	if (r < 0)
+		return r;
 
 	/* 0x0020 - 0x003F - 8259A PIC 1 */
-	ioport__register(kvm, 0x0020, &dummy_read_write_ioport_ops, 2, NULL);
+	r = ioport__register(kvm, 0x0020, &dummy_read_write_ioport_ops, 2, NULL);
+	if (r < 0)
+		return r;
 
 	/* PORT 0040-005F - PIT - PROGRAMMABLE INTERVAL TIMER (8253, 8254) */
-	ioport__register(kvm, 0x0040, &dummy_read_write_ioport_ops, 4, NULL);
+	r = ioport__register(kvm, 0x0040, &dummy_read_write_ioport_ops, 4, NULL);
+	if (r < 0)
+		return r;
 
 	/* 0092 - PS/2 system control port A */
-	ioport__register(kvm, 0x0092, &ps2_control_a_ops, 1, NULL);
+	r = ioport__register(kvm, 0x0092, &ps2_control_a_ops, 1, NULL);
+	if (r < 0)
+		return r;
 
 	/* 0x00A0 - 0x00AF - 8259A PIC 2 */
-	ioport__register(kvm, 0x00A0, &dummy_read_write_ioport_ops, 2, NULL);
+	r = ioport__register(kvm, 0x00A0, &dummy_read_write_ioport_ops, 2, NULL);
+	if (r < 0)
+		return r;
 
 	/* 00C0 - 001F - DMA2 controller */
-	ioport__register(kvm, 0x00C0, &dummy_read_write_ioport_ops, 32, NULL);
+	r = ioport__register(kvm, 0x00C0, &dummy_read_write_ioport_ops, 32, NULL);
+	if (r < 0)
+		return r;
 
 	/* PORT 00E0-00EF are 'motherboard specific' so we use them for our
 	   internal debugging purposes.  */
-	ioport__register(kvm, IOPORT_DBG, &debug_ops, 1, NULL);
+	r = ioport__register(kvm, IOPORT_DBG, &debug_ops, 1, NULL);
+	if (r < 0)
+		return r;
 
 	/* PORT 00ED - DUMMY PORT FOR DELAY??? */
-	ioport__register(kvm, 0x00ED, &dummy_write_only_ioport_ops, 1, NULL);
+	r = ioport__register(kvm, 0x00ED, &dummy_write_only_ioport_ops, 1, NULL);
+	if (r < 0)
+		return r;
 
 	/* 0x00F0 - 0x00FF - Math co-processor */
-	ioport__register(kvm, 0x00F0, &dummy_write_only_ioport_ops, 2, NULL);
+	r = ioport__register(kvm, 0x00F0, &dummy_write_only_ioport_ops, 2, NULL);
+	if (r < 0)
+		return r;
 
 	/* PORT 0278-027A - PARALLEL PRINTER PORT (usually LPT1, sometimes LPT2) */
-	ioport__register(kvm, 0x0278, &dummy_read_write_ioport_ops, 3, NULL);
+	r = ioport__register(kvm, 0x0278, &dummy_read_write_ioport_ops, 3, NULL);
+	if (r < 0)
+		return r;
 
 	/* PORT 0378-037A - PARALLEL PRINTER PORT (usually LPT2, sometimes LPT3) */
-	ioport__register(kvm, 0x0378, &dummy_read_write_ioport_ops, 3, NULL);
+	r = ioport__register(kvm, 0x0378, &dummy_read_write_ioport_ops, 3, NULL);
+	if (r < 0)
+		return r;
 
 	/* PORT 03D4-03D5 - COLOR VIDEO - CRT CONTROL REGISTERS */
-	ioport__register(kvm, 0x03D4, &dummy_read_write_ioport_ops, 1, NULL);
-	ioport__register(kvm, 0x03D5, &dummy_write_only_ioport_ops, 1, NULL);
+	r = ioport__register(kvm, 0x03D4, &dummy_read_write_ioport_ops, 1, NULL);
+	if (r < 0)
+		return r;
+	r = ioport__register(kvm, 0x03D5, &dummy_write_only_ioport_ops, 1, NULL);
+	if (r < 0)
+		return r;
 
-	ioport__register(kvm, 0x402, &seabios_debug_ops, 1, NULL);
+	r = ioport__register(kvm, 0x402, &seabios_debug_ops, 1, NULL);
+	if (r < 0)
+		return r;
 
 	/* 0510 - QEMU BIOS configuration register */
-	ioport__register(kvm, 0x510, &dummy_read_write_ioport_ops, 2, NULL);
+	r = ioport__register(kvm, 0x510, &dummy_read_write_ioport_ops, 2, NULL);
+	if (r < 0)
+		return r;
+
+	return 0;
 }
-- 
2.20.1

