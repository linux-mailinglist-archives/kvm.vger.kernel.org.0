Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2929168436
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 17:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgBUQzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 11:55:42 -0500
Received: from foss.arm.com ([217.140.110.172]:43668 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbgBUQzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 11:55:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D533E31B;
        Fri, 21 Feb 2020 08:55:41 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BEB13F68F;
        Fri, 21 Feb 2020 08:55:40 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Subject: [PATCH kvmtool v3] Add emulation for CFI compatible flash memory
Date:   Fri, 21 Feb 2020 16:55:32 +0000
Message-Id: <20200221165532.90618-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Raphael Gault <raphael.gault@arm.com>

The EDK II UEFI firmware implementation requires some storage for the EFI
variables, which is typically some flash storage.
Since this is already supported on the EDK II side, we add a CFI flash
emulation to kvmtool.
This is backed by a file, specified via the --flash or -F command line
option. Any flash writes done by the guest will immediately be reflected
into this file (kvmtool mmap's the file).
The flash will be limited to the nearest power-of-2 size, so only the
first 2 MB of a 3 MB file will be used.

This implements a CFI flash using the "Intel/Sharp extended command
set", as specified in:
- JEDEC JESD68.01
- JEDEC JEP137B
- Intel Application Note 646
Some gaps in those specs have been filled by looking at real devices and
other implementations (QEMU, Linux kernel driver).

At the moment this relies on DT to advertise the base address of the
flash memory (mapped into the MMIO address space) and is only enabled
for ARM/ARM64. The emulation itself is architecture agnostic, though.

This is one missing piece toward a working UEFI boot with kvmtool on
ARM guests, the other is to provide writable PCI BARs, which is WIP.

Signed-off-by: Raphael Gault <raphael.gault@arm.com>
[Andre: rewriting and fixing]
Signed-off-by: Andre Przywra <andre.przywara@arm.com>
---
Hi,

an update fixing Alexandru's review comments (many thanks for those!)
The biggest change code-wise is the split of the MMIO handler into three
different functions. Another significant change is the rounding *down* of
the present flash file size to the nearest power-of-two, to match flash
hardware chips and Linux' expectations.

Cheers,
Andre

Changelog v2 .. v3:
- Breaking MMIO handling into three separate functions.
- Assing the flash base address in the memory map, but stay at 32 MB for now.
  The MMIO area has been moved up to 48 MB, to never overlap with the
  flash.
- Impose a limit of 16 MB for the flash size, mostly to fit into the
  (for now) fixed memory map.
- Trim flash size down to nearest power-of-2, to match hardware.
- Announce forced flash size trimming.
- Rework the CFI query table slightly, to add the addresses as array
  indicies.
- Fix error handling when creating the flash device.
- Fix pow2_size implementation for 0 and 1 as input values.
- Fix write buffer size handling.
- Improve some comments.

Changelog v1 .. v2:
- Add locking for MMIO handling.
- Fold flash read into handler.
- Move pow2_size() into generic header.
- Spell out flash base address.

 Makefile                          |   6 +
 arm/include/arm-common/kvm-arch.h |   8 +-
 builtin-run.c                     |   2 +
 hw/cfi_flash.c                    | 576 ++++++++++++++++++++++++++++++
 include/kvm/kvm-config.h          |   1 +
 include/kvm/util.h                |   8 +
 6 files changed, 599 insertions(+), 2 deletions(-)
 create mode 100644 hw/cfi_flash.c

diff --git a/Makefile b/Makefile
index 3862112c..7ed6fb5e 100644
--- a/Makefile
+++ b/Makefile
@@ -170,6 +170,7 @@ ifeq ($(ARCH), arm)
 	CFLAGS		+= -march=armv7-a
 
 	ARCH_WANT_LIBFDT := y
+	ARCH_HAS_FLASH_MEM := y
 endif
 
 # ARM64
@@ -182,6 +183,7 @@ ifeq ($(ARCH), arm64)
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
 	ARCH_WANT_LIBFDT := y
+	ARCH_HAS_FLASH_MEM := y
 endif
 
 ifeq ($(ARCH),mips)
@@ -261,6 +263,10 @@ ifeq (y,$(ARCH_HAS_FRAMEBUFFER))
 	endif
 endif
 
+ifeq (y,$(ARCH_HAS_FLASH_MEM))
+	OBJS	+= hw/cfi_flash.o
+endif
+
 ifeq ($(call try-build,$(SOURCE_ZLIB),$(CFLAGS),$(LDFLAGS) -lz),y)
 	CFLAGS_DYNOPT	+= -DCONFIG_HAS_ZLIB
 	LIBS_DYNOPT	+= -lz
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index b9d486d5..d84e50cd 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -8,7 +8,8 @@
 #include "arm-common/gic.h"
 
 #define ARM_IOPORT_AREA		_AC(0x0000000000000000, UL)
-#define ARM_MMIO_AREA		_AC(0x0000000000010000, UL)
+#define ARM_FLASH_AREA		_AC(0x0000000002000000, UL)
+#define ARM_MMIO_AREA		_AC(0x0000000003000000, UL)
 #define ARM_AXI_AREA		_AC(0x0000000040000000, UL)
 #define ARM_MEMORY_AREA		_AC(0x0000000080000000, UL)
 
@@ -21,7 +22,10 @@
 #define ARM_GIC_DIST_SIZE	0x10000
 #define ARM_GIC_CPUI_SIZE	0x20000
 
-#define ARM_IOPORT_SIZE		(ARM_MMIO_AREA - ARM_IOPORT_AREA)
+#define KVM_FLASH_MMIO_BASE	ARM_FLASH_AREA
+#define KVM_FLASH_MAX_SIZE	(ARM_MMIO_AREA - ARM_FLASH_AREA)
+
+#define ARM_IOPORT_SIZE		(1U << 16)
 #define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - (ARM_MMIO_AREA + ARM_GIC_SIZE))
 #define ARM_PCI_CFG_SIZE	(1ULL << 24)
 #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
diff --git a/builtin-run.c b/builtin-run.c
index f8dc6c72..df8c6741 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -138,6 +138,8 @@ void kvm_run_set_wrapper_sandbox(void)
 			"Kernel command line arguments"),		\
 	OPT_STRING('f', "firmware", &(cfg)->firmware_filename, "firmware",\
 			"Firmware image to boot in virtual machine"),	\
+	OPT_STRING('F', "flash", &(cfg)->flash_filename, "flash",\
+			"Flash image to present to virtual machine"),	\
 									\
 	OPT_GROUP("Networking options:"),				\
 	OPT_CALLBACK_DEFAULT('n', "network", NULL, "network params",	\
diff --git a/hw/cfi_flash.c b/hw/cfi_flash.c
new file mode 100644
index 00000000..f66257c6
--- /dev/null
+++ b/hw/cfi_flash.c
@@ -0,0 +1,576 @@
+#include <stdbool.h>
+#include <stdlib.h>
+#include <string.h>
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/sizes.h>
+#include <linux/types.h>
+
+#include "kvm/kvm.h"
+#include "kvm/kvm-arch.h"
+#include "kvm/devices.h"
+#include "kvm/fdt.h"
+#include "kvm/mutex.h"
+#include "kvm/util.h"
+
+/* The EDK2 driver hardcodes two 16-bit chips on a 32-bit bus. */
+#define CFI_NR_FLASH_CHIPS			2
+
+/* We always emulate a 32 bit bus width. */
+#define CFI_BUS_WIDTH				4
+
+/* The *effective* size of an erase block (over all chips) */
+#define FLASH_BLOCK_SIZE			SZ_64K
+
+#define PROGRAM_BUFF_SIZE_BITS			7
+#define PROGRAM_BUFF_SIZE			(1U << PROGRAM_BUFF_SIZE_BITS)
+
+/* CFI commands */
+#define CFI_CMD_LOCK_BLOCK			0x01
+#define CFI_CMD_ALTERNATE_WORD_PROGRAM_SETUP	0x10
+#define CFI_CMD_BLOCK_ERASE_SETUP		0x20
+#define CFI_CMD_WORD_PROGRAM_SETUP		0x40
+#define CFI_CMD_CLEAR_STATUS_REGISTER		0x50
+#define CFI_CMD_LOCK_BLOCK_SETUP		0x60
+#define CFI_CMD_READ_STATUS_REGISTER		0x70
+#define CFI_CMD_READ_JEDEC			0x90
+#define CFI_CMD_READ_CFI_QUERY			0x98
+#define CFI_CMD_BUFFERED_PROGRAM_CONFIRM	0xd0
+#define CFI_CMD_BLOCK_ERASE_CONFIRM		0xd0
+#define CFI_CMD_UNLOCK_BLOCK			0xd0
+#define CFI_CMD_BUFFERED_PROGRAM_SETUP		0xe8
+#define CFI_CMD_READ_ARRAY			0xff
+
+/*
+ * CFI query table contents, as far as it is constant.
+ */
+#define CFI_GEOM_OFFSET				0x27
+static u8 cfi_query_table[] = {
+		/* CFI query identification string */
+	[0x10] = 'Q', 'R', 'Y',		/* ID string */
+	0x01, 0x00,		/* primary command set: Intel/Sharp extended */
+	0x31, 0x00,		/* address of primary extended query table */
+	0x00, 0x00,		/* alternative command set: unused */
+	0x00, 0x00,		/* address of alternative extended query table*/
+		/* system interface information */
+	[0x1b] = 0x45,			/* minimum Vcc voltage: 4.5V */
+	0x55,			/* maximum Vcc voltage: 5.5V */
+	0x00,			/* minimum Vpp voltage: 0.0V (unused) */
+	0x00,			/* maximum Vpp voltage: 0.0V *(unused) */
+	0x01,			/* timeout for single word program: 2 us */
+	0x01,			/* timeout for multi-byte program: 2 us */
+	0x01,			/* timeout for block erase: 2 ms */
+	0x00,			/* timeout for full chip erase: not supported */
+	0x00,			/* max timeout for single word program: 1x */
+	0x00,			/* max timeout for mulit-byte program: 1x */
+	0x00,			/* max timeout for block erase: 1x */
+	0x00,			/* max timeout for chip erase: not supported */
+		/* flash geometry information */
+	[0x27] = 0x00,		/* size in power-of-2 bytes, filled later */
+	0x05, 0x00,		/* interface description: 32 and 16 bits */
+	PROGRAM_BUFF_SIZE_BITS + 1 - CFI_NR_FLASH_CHIPS, 0x00,
+				/* number of bytes in write buffer */
+	0x01,			/* one erase block region */
+	0x00, 0x00, 0x00, 0x00, /* number and size of erase blocks, filled */
+		/* Intel primary algorithm extended query table */
+	[0x31] = 'P', 'R', 'I',
+	'1', '0',		/* version 1.0 */
+	0xa0, 0x00, 0x00, 0x00, /* optional features: instant lock & pm-read */
+	0x00,			/* no functions after suspend */
+	0x01, 0x00,		/* only lock bit supported */
+	0x50,			/* best Vcc value: 5.0V */
+	0x00,			/* best Vpp value: 0.0V (unused) */
+	0x01,			/* number of protection register fields */
+	0x00, 0x00, 0x00, 0x00,	/* protection field 1 description */
+};
+
+
+/*
+ * Those states represent a subset of the CFI flash state machine.
+ */
+enum cfi_flash_state {
+	READY,
+	LOCK_SETUP,
+	WP_SETUP,
+	BP_SETUP,
+	BP_LOAD,
+	ERASE_SETUP,
+};
+
+/*
+ * The device can be in several **Read** modes.
+ * We don't implement the asynchronous burst mode.
+ */
+enum cfi_read_mode {
+	READ_ARRAY,
+	READ_STATUS,
+	READ_DEVICE_ID,
+	READ_QUERY,
+};
+
+struct cfi_flash_device {
+	struct device_header	dev_hdr;
+	/* Protects the CFI state machine variables in this data structure. */
+	struct mutex		mutex;
+	u64			base_addr;
+	u32			size;
+
+	void			*flash_memory;
+	u8			program_buffer[PROGRAM_BUFF_SIZE];
+	unsigned long		*lock_bm;
+	u64			last_address;
+	unsigned int		buff_written;
+	unsigned int		program_length;
+
+	enum cfi_flash_state	state;
+	enum cfi_read_mode	read_mode;
+	u16			rcr;
+	u8			sr;
+};
+
+static int nr_erase_blocks(struct cfi_flash_device *sfdev)
+{
+	return sfdev->size / FLASH_BLOCK_SIZE;
+}
+
+/*
+ * CFI queries always deal with one byte of information, possibly mirrored
+ * to other bytes on the bus. This is dealt with in the callers.
+ * The address provided is the one for 8-bit addressing, and would need to
+ * be adjusted for wider accesses.
+ */
+static u8 read_cfi(struct cfi_flash_device *sfdev, u64 addr)
+{
+	if (addr < 0x10)		/* CFI information starts at 0x10 */
+		return 0;
+
+	if (addr > sizeof(cfi_query_table)) {
+		pr_debug("CFI query read access beyond the end of table");
+		return 0;
+	}
+
+	/* Fixup dynamic information in the geometry part of the table. */
+	switch (addr) {
+	case CFI_GEOM_OFFSET:		/* device size in bytes, power of two */
+		return pow2_size(sfdev->size / CFI_NR_FLASH_CHIPS);
+	case CFI_GEOM_OFFSET + 6:	/* number of erase blocks, minus one */
+		return (nr_erase_blocks(sfdev) - 1) & 0xff;
+	case CFI_GEOM_OFFSET + 7:
+		return (nr_erase_blocks(sfdev) - 1) >> 8;
+	case CFI_GEOM_OFFSET + 8:	/* erase block size, in units of 256 */
+		return ((FLASH_BLOCK_SIZE / 256 ) / CFI_NR_FLASH_CHIPS) & 0xff;
+	case CFI_GEOM_OFFSET + 9:
+		return ((FLASH_BLOCK_SIZE / 256 ) / CFI_NR_FLASH_CHIPS) >> 8;
+	}
+
+	return cfi_query_table[addr];
+}
+
+static bool block_is_locked(struct cfi_flash_device *sfdev, u64 addr)
+{
+	int block_nr = addr / FLASH_BLOCK_SIZE;
+
+	return test_bit(block_nr, sfdev->lock_bm);
+}
+
+#define DEV_ID_MASK 0x7ff
+static u16 read_dev_id(struct cfi_flash_device *sfdev, u64 addr)
+{
+	switch ((addr & DEV_ID_MASK) / CFI_BUS_WIDTH) {
+	case 0x0:				/* vendor ID */
+		return 0x0000;
+	case 0x1:				/* device ID */
+		return 0xffff;
+	case 0x2:
+		return block_is_locked(sfdev, addr & ~DEV_ID_MASK);
+	case 0x5:
+		return sfdev->rcr;
+	default:			/* Ignore the other entries. */
+		return 0;
+	}
+}
+
+static void lock_block(struct cfi_flash_device *sfdev, u64 addr, bool lock)
+{
+	int block_nr = addr / FLASH_BLOCK_SIZE;
+
+	if (lock)
+		set_bit(block_nr, sfdev->lock_bm);
+	else
+		clear_bit(block_nr, sfdev->lock_bm);
+}
+
+static void word_program(struct cfi_flash_device *sfdev,
+			 u64 addr, void *data, int len)
+{
+	if (block_is_locked(sfdev, addr)) {
+		sfdev->sr |= 0x12;
+		return;
+	}
+
+	memcpy(sfdev->flash_memory + addr, data, len);
+}
+
+/* Reset the program buffer state to prepare for follow-up writes. */
+static void buffer_setup(struct cfi_flash_device *sfdev)
+{
+	memset(sfdev->program_buffer, 0, sizeof(sfdev->program_buffer));
+	sfdev->last_address = ~0ULL;
+	sfdev->buff_written = 0;
+}
+
+static bool buffer_program(struct cfi_flash_device *sfdev,
+			   u64 addr, void *buffer, int len)
+{
+	unsigned int buf_addr;
+
+	if (sfdev->buff_written >= sfdev->program_length)
+		return false;
+
+	/*
+	 * The first word written into the buffer after the setup command
+	 * happens to be the base address for the buffer.
+	 * All subsequent writes need to be within this address and this
+	 * address plus the buffer size, so keep this value around.
+	 */
+	if (sfdev->last_address == ~0ULL)
+		sfdev->last_address = addr;
+
+	if (addr < sfdev->last_address)
+		return false;
+	buf_addr = addr - sfdev->last_address;
+	if (buf_addr >= PROGRAM_BUFF_SIZE)
+		return false;
+
+	memcpy(sfdev->program_buffer + buf_addr, buffer, len);
+	sfdev->buff_written += len;
+
+	return true;
+}
+
+static void buffer_confirm(struct cfi_flash_device *sfdev)
+{
+	if (block_is_locked(sfdev, sfdev->last_address)) {
+		sfdev->sr |= 0x12;
+		return;
+	}
+	memcpy(sfdev->flash_memory + sfdev->last_address,
+	       sfdev->program_buffer, sfdev->buff_written);
+}
+
+static void block_erase_confirm(struct cfi_flash_device *sfdev, u64 addr)
+{
+	if (block_is_locked(sfdev, addr)) {
+		sfdev->sr |= 0x12;
+		return;
+	}
+
+	memset(sfdev->flash_memory + addr, 0xFF, FLASH_BLOCK_SIZE);
+}
+
+static void cfi_flash_read(struct cfi_flash_device *sfdev,
+			   u64 faddr, u8 *data, u32 len)
+{
+	u16 cfi_value = 0;
+
+	switch (sfdev->read_mode) {
+	case READ_ARRAY:
+		/* just copy the requested bytes from the array */
+		memcpy(data, sfdev->flash_memory + faddr, len);
+		return;
+	case READ_STATUS:
+		cfi_value = sfdev->sr;
+		break;
+	case READ_DEVICE_ID:
+		cfi_value = read_dev_id(sfdev, faddr);
+		break;
+	case READ_QUERY:
+		cfi_value = read_cfi(sfdev, faddr / CFI_BUS_WIDTH);
+		break;
+	}
+	switch (len) {
+	case 1:
+		*data = cfi_value;
+		break;
+	case 8: memset(data + 4, 0, 4);
+		/* fall-through */
+	case 4:
+		if (CFI_NR_FLASH_CHIPS == 2)
+			memcpy(data + 2, &cfi_value, 2);
+		else
+			memset(data + 2, 0, 2);
+		/* fall-through */
+	case 2:
+		memcpy(data, &cfi_value, 2);
+		break;
+	default:
+		pr_debug("CFI flash: illegal access length %d for read mode %d",
+			 len, sfdev->read_mode);
+		break;
+	}
+}
+
+/*
+ * Any writes happening in "READY" state don't actually write to the memory,
+ * but are really treated as commands to advance the state machine and select
+ * the next action.
+ * Change the state and modes according to the value written. The address
+ * that value is written to does not matter and is ignored.
+ */
+static void cfi_flash_write_ready(struct cfi_flash_device *sfdev, u8 command)
+{
+	switch (command) {
+	case CFI_CMD_READ_JEDEC:
+		sfdev->read_mode = READ_DEVICE_ID;
+		break;
+	case CFI_CMD_READ_STATUS_REGISTER:
+		sfdev->read_mode = READ_STATUS;
+		break;
+	case CFI_CMD_READ_CFI_QUERY:
+		sfdev->read_mode = READ_QUERY;
+		break;
+	case CFI_CMD_CLEAR_STATUS_REGISTER:
+		sfdev->sr = 0x80;
+		break;
+	case CFI_CMD_WORD_PROGRAM_SETUP:
+	case CFI_CMD_ALTERNATE_WORD_PROGRAM_SETUP:
+		sfdev->state = WP_SETUP;
+		sfdev->read_mode = READ_STATUS;
+		break;
+	case CFI_CMD_LOCK_BLOCK_SETUP:
+		sfdev->state = LOCK_SETUP;
+		break;
+	case CFI_CMD_BLOCK_ERASE_SETUP:
+		sfdev->state = ERASE_SETUP;
+		sfdev->read_mode = READ_STATUS;
+		break;
+	case CFI_CMD_BUFFERED_PROGRAM_SETUP:
+		buffer_setup(sfdev);
+		sfdev->state = BP_SETUP;
+		sfdev->read_mode = READ_STATUS;
+		break;
+	case CFI_CMD_BUFFERED_PROGRAM_CONFIRM:
+		pr_debug("CFI flash: unexpected confirm command 0xD0");
+		break;
+	default:
+		pr_debug("CFI flash: unknown command 0x%x", command);
+		/* fall-through */
+	case CFI_CMD_READ_ARRAY:
+		sfdev->read_mode = READ_ARRAY;
+		break;
+	}
+}
+
+static void cfi_flash_write(struct cfi_flash_device *sfdev, u16 command,
+			    u64 faddr, u8 *data, u32 len)
+{
+	switch (sfdev->state) {
+	case READY:
+		cfi_flash_write_ready(sfdev, command & 0xff);
+		return;
+	case LOCK_SETUP:
+		switch (command & 0xff) {
+		case CFI_CMD_LOCK_BLOCK:
+			lock_block(sfdev, faddr, true);
+			sfdev->read_mode = READ_STATUS;
+			break;
+		case CFI_CMD_UNLOCK_BLOCK:
+			lock_block(sfdev, faddr, false);
+			sfdev->read_mode = READ_STATUS;
+			break;
+		default:
+			sfdev->sr |= 0x30;
+			break;
+		}
+		sfdev->state = READY;
+		break;
+
+	case WP_SETUP:
+		word_program(sfdev, faddr, data, len);
+		sfdev->read_mode = READ_STATUS;
+		sfdev->state = READY;
+		break;
+
+	case BP_LOAD:
+		if (buffer_program(sfdev, faddr, data, len))
+			break;
+
+		if ((command & 0xFF) == CFI_CMD_BUFFERED_PROGRAM_CONFIRM) {
+			buffer_confirm(sfdev);
+			sfdev->read_mode = READ_STATUS;
+		} else {
+			pr_debug("CFI flash: BP_LOAD: expected CONFIRM(0xd0), got 0x%x @ 0x%llx",
+				 command, faddr);
+			sfdev->sr |= 0x10;
+		}
+		sfdev->state = READY;
+		break;
+
+	case BP_SETUP:
+		sfdev->program_length = (command + 1) * CFI_BUS_WIDTH;
+		if (sfdev->program_length > PROGRAM_BUFF_SIZE)
+			sfdev->program_length = PROGRAM_BUFF_SIZE;
+		sfdev->state = BP_LOAD;
+		sfdev->read_mode = READ_STATUS;
+		break;
+
+	case ERASE_SETUP:
+		if ((command & 0xff) == CFI_CMD_BLOCK_ERASE_CONFIRM)
+			block_erase_confirm(sfdev, faddr);
+		else
+			sfdev->sr |= 0x30;
+
+		sfdev->state = READY;
+		sfdev->read_mode = READ_STATUS;
+		break;
+	}
+}
+
+static void cfi_flash_mmio(struct kvm_cpu *vcpu,
+			   u64 addr, u8 *data, u32 len, u8 is_write,
+			   void *context)
+{
+	struct cfi_flash_device *sfdev = context;
+	u64 faddr = addr - sfdev->base_addr;
+	u32 value;
+
+	if (!is_write) {
+		mutex_lock(&sfdev->mutex);
+
+		cfi_flash_read(sfdev, faddr, data, len);
+
+		mutex_unlock(&sfdev->mutex);
+
+		return;
+	}
+
+	if (len > 4) {
+		pr_info("CFI flash: MMIO %d-bit write access not supported",
+			 len * 8);
+		return;
+	}
+
+	memcpy(&value, data, len);
+
+	mutex_lock(&sfdev->mutex);
+
+	cfi_flash_write(sfdev, value & 0xffff, faddr, data, len);
+
+	mutex_unlock(&sfdev->mutex);
+}
+
+#ifdef CONFIG_HAS_LIBFDT
+static void generate_cfi_flash_fdt_node(void *fdt,
+					struct device_header *dev_hdr,
+					void (*generate_irq_prop)(void *fdt,
+								  u8 irq,
+								enum irq_type))
+{
+	struct cfi_flash_device *sfdev;
+	u64 reg_prop[2];
+
+	sfdev = container_of(dev_hdr, struct cfi_flash_device, dev_hdr);
+	reg_prop[0] = cpu_to_fdt64(sfdev->base_addr);
+	reg_prop[1] = cpu_to_fdt64(sfdev->size);
+
+	_FDT(fdt_begin_node(fdt, "flash"));
+	_FDT(fdt_property_cell(fdt, "bank-width", CFI_BUS_WIDTH));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 0x1));
+	_FDT(fdt_property_string(fdt, "compatible", "cfi-flash"));
+	_FDT(fdt_property_string(fdt, "label", "System-firmware"));
+	_FDT(fdt_property(fdt, "reg", &reg_prop, sizeof(reg_prop)));
+	_FDT(fdt_end_node(fdt));
+}
+#else
+#define generate_cfi_flash_fdt_node NULL
+#endif
+
+static struct cfi_flash_device *create_flash_device_file(struct kvm *kvm,
+							 const char *filename)
+{
+	struct cfi_flash_device *sfdev;
+	struct stat statbuf;
+	unsigned int value;
+	int ret;
+	int fd;
+
+	fd = open(filename, O_RDWR);
+	if (fd < 0)
+		return ERR_PTR(-errno);
+	if (fstat(fd, &statbuf) < 0) {
+		close(fd);
+		return ERR_PTR(-errno);
+	}
+
+	sfdev = malloc(sizeof(struct cfi_flash_device));
+	if (!sfdev) {
+		close(fd);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	sfdev->size = statbuf.st_size;
+	/* Round down to nearest power-of-2 size value. */
+	sfdev->size = 1U << (pow2_size(sfdev->size + 1) - 1);
+	if (sfdev->size > KVM_FLASH_MAX_SIZE)
+		sfdev->size = KVM_FLASH_MAX_SIZE;
+	if (sfdev->size < statbuf.st_size)
+		pr_info("Trimmed flash size down to %d bytes\n", sfdev->size);
+	sfdev->flash_memory = mmap(NULL, sfdev->size,
+				   PROT_READ | PROT_WRITE, MAP_SHARED,
+				   fd, 0);
+	if (sfdev->flash_memory == MAP_FAILED) {
+		ret = -errno;
+		goto out_err;
+	}
+	sfdev->base_addr = KVM_FLASH_MMIO_BASE;
+	sfdev->state = READY;
+	sfdev->read_mode = READ_ARRAY;
+	sfdev->sr = 0x80;
+	sfdev->rcr = 0xbfcf;
+
+	value = roundup(nr_erase_blocks(sfdev), BITS_PER_LONG) / 8;
+	sfdev->lock_bm = malloc(value);
+	memset(sfdev->lock_bm, 0, value);
+
+	sfdev->dev_hdr.bus_type = DEVICE_BUS_MMIO;
+	sfdev->dev_hdr.data = generate_cfi_flash_fdt_node;
+	mutex_init(&sfdev->mutex);
+	ret = device__register(&sfdev->dev_hdr);
+	if (ret)
+		goto out_unmap;
+
+	ret = kvm__register_mmio(kvm,
+				 sfdev->base_addr, sfdev->size,
+				 false, cfi_flash_mmio, sfdev);
+	if (ret) {
+		device__unregister(&sfdev->dev_hdr);
+		goto out_unmap;
+	}
+
+	return sfdev;
+
+out_unmap:
+	munmap(sfdev->flash_memory, sfdev->size);
+
+out_err:
+	close(fd);
+	free(sfdev);
+
+	return ERR_PTR(ret);
+}
+
+static int flash__init(struct kvm *kvm)
+{
+	struct cfi_flash_device *sfdev;
+
+	if (!kvm->cfg.flash_filename)
+		return 0;
+
+	sfdev = create_flash_device_file(kvm, kvm->cfg.flash_filename);
+	if (IS_ERR(sfdev))
+		return PTR_ERR(sfdev);
+
+	return 0;
+}
+dev_init(flash__init);
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index a052b0bc..f4a8b831 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -35,6 +35,7 @@ struct kvm_config {
 	const char *vmlinux_filename;
 	const char *initrd_filename;
 	const char *firmware_filename;
+	const char *flash_filename;
 	const char *console;
 	const char *dev;
 	const char *network;
diff --git a/include/kvm/util.h b/include/kvm/util.h
index 4ca7aa93..021369b4 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -104,6 +104,14 @@ static inline unsigned long roundup_pow_of_two(unsigned long x)
 	return x ? 1UL << fls_long(x - 1) : 0;
 }
 
+static inline int pow2_size(unsigned long x)
+{
+	if (x <= 1)
+		return x;
+
+	return sizeof(x) * 8 - __builtin_clzl(x - 1);
+}
+
 struct kvm;
 void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
-- 
2.17.1

