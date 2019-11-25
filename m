Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59BFB108BC1
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 11:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfKYKcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 05:32:35 -0500
Received: from foss.arm.com ([217.140.110.172]:47698 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbfKYKce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 05:32:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8280955D;
        Mon, 25 Nov 2019 02:32:33 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 95E773F52E;
        Mon, 25 Nov 2019 02:32:32 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 03/16] Remove pci-shmem device
Date:   Mon, 25 Nov 2019 10:30:20 +0000
Message-Id: <20191125103033.22694-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191125103033.22694-1-alexandru.elisei@arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pci-shmem emulated device ("ivshmem") was created by QEMU for
cross-VM data sharing. The only Linux driver that uses this device is
the Android Virtual System on a Chip staging driver, which also mentions
a character device driver implemented on top of shmem, which was removed
from Linux.

On the kvmtool side, the only commits touching the pci-shmem device
since it was introduced in 2012 were made when refactoring various
kvmtool subsystems. Let's remove the maintenance burden on the kvmtool
maintainers and remove this unused device.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile                |   1 -
 builtin-run.c           |   5 -
 hw/pci-shmem.c          | 400 ----------------------------------------
 include/kvm/pci-shmem.h |  32 ----
 4 files changed, 438 deletions(-)
 delete mode 100644 hw/pci-shmem.c
 delete mode 100644 include/kvm/pci-shmem.h

diff --git a/Makefile b/Makefile
index 6d6880dd4f8a..99c6a9e24d72 100644
--- a/Makefile
+++ b/Makefile
@@ -99,7 +99,6 @@ OBJS	+= util/read-write.o
 OBJS	+= util/util.o
 OBJS	+= virtio/9p.o
 OBJS	+= virtio/9p-pdu.o
-OBJS	+= hw/pci-shmem.o
 OBJS	+= kvm-ipc.o
 OBJS	+= builtin-sandbox.o
 OBJS	+= virtio/mmio.o
diff --git a/builtin-run.c b/builtin-run.c
index f8dc6c7229b0..9cb8c75300eb 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -31,7 +31,6 @@
 #include "kvm/sdl.h"
 #include "kvm/vnc.h"
 #include "kvm/guest_compat.h"
-#include "kvm/pci-shmem.h"
 #include "kvm/kvm-ipc.h"
 #include "kvm/builtin-debug.h"
 
@@ -99,10 +98,6 @@ void kvm_run_set_wrapper_sandbox(void)
 	OPT_INTEGER('c', "cpus", &(cfg)->nrcpus, "Number of CPUs"),	\
 	OPT_U64('m', "mem", &(cfg)->ram_size, "Virtual machine memory"	\
 		" size in MiB."),					\
-	OPT_CALLBACK('\0', "shmem", NULL,				\
-		     "[pci:]<addr>:<size>[:handle=<handle>][:create]",	\
-		     "Share host shmem with guest via pci device",	\
-		     shmem_parser, NULL),				\
 	OPT_CALLBACK('d', "disk", kvm, "image or rootfs_dir", "Disk "	\
 			" image or rootfs directory", img_name_parser,	\
 			kvm),						\
diff --git a/hw/pci-shmem.c b/hw/pci-shmem.c
deleted file mode 100644
index f92bc75544d7..000000000000
--- a/hw/pci-shmem.c
+++ /dev/null
@@ -1,400 +0,0 @@
-#include "kvm/devices.h"
-#include "kvm/pci-shmem.h"
-#include "kvm/virtio-pci-dev.h"
-#include "kvm/irq.h"
-#include "kvm/kvm.h"
-#include "kvm/pci.h"
-#include "kvm/util.h"
-#include "kvm/ioport.h"
-#include "kvm/ioeventfd.h"
-
-#include <linux/kvm.h>
-#include <linux/byteorder.h>
-#include <sys/ioctl.h>
-#include <fcntl.h>
-#include <sys/mman.h>
-
-#define MB_SHIFT (20)
-#define KB_SHIFT (10)
-#define GB_SHIFT (30)
-
-static struct pci_device_header pci_shmem_pci_device = {
-	.vendor_id	= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
-	.device_id	= cpu_to_le16(0x1110),
-	.header_type	= PCI_HEADER_TYPE_NORMAL,
-	.class[2]	= 0xFF,	/* misc pci device */
-	.status		= cpu_to_le16(PCI_STATUS_CAP_LIST),
-	.capabilities	= (void *)&pci_shmem_pci_device.msix - (void *)&pci_shmem_pci_device,
-	.msix.cap	= PCI_CAP_ID_MSIX,
-	.msix.ctrl	= cpu_to_le16(1),
-	.msix.table_offset = cpu_to_le32(1),		/* Use BAR 1 */
-	.msix.pba_offset = cpu_to_le32(0x1001),		/* Use BAR 1 */
-};
-
-static struct device_header pci_shmem_device = {
-	.bus_type	= DEVICE_BUS_PCI,
-	.data		= &pci_shmem_pci_device,
-};
-
-/* registers for the Inter-VM shared memory device */
-enum ivshmem_registers {
-	INTRMASK = 0,
-	INTRSTATUS = 4,
-	IVPOSITION = 8,
-	DOORBELL = 12,
-};
-
-static struct shmem_info *shmem_region;
-static u16 ivshmem_registers;
-static int local_fd;
-static u32 local_id;
-static u64 msix_block;
-static u64 msix_pba;
-static struct msix_table msix_table[2];
-
-int pci_shmem__register_mem(struct shmem_info *si)
-{
-	if (!shmem_region) {
-		shmem_region = si;
-	} else {
-		pr_warning("only single shmem currently avail. ignoring.\n");
-		free(si);
-	}
-	return 0;
-}
-
-static bool shmem_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	u16 offset = port - ivshmem_registers;
-
-	switch (offset) {
-	case INTRMASK:
-		break;
-	case INTRSTATUS:
-		break;
-	case IVPOSITION:
-		ioport__write32(data, local_id);
-		break;
-	case DOORBELL:
-		break;
-	};
-
-	return true;
-}
-
-static bool shmem_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	u16 offset = port - ivshmem_registers;
-
-	switch (offset) {
-	case INTRMASK:
-		break;
-	case INTRSTATUS:
-		break;
-	case IVPOSITION:
-		break;
-	case DOORBELL:
-		break;
-	};
-
-	return true;
-}
-
-static struct ioport_operations shmem_pci__io_ops = {
-	.io_in	= shmem_pci__io_in,
-	.io_out	= shmem_pci__io_out,
-};
-
-static void callback_mmio_msix(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr)
-{
-	void *mem;
-
-	if (addr - msix_block < 0x1000)
-		mem = &msix_table;
-	else
-		mem = &msix_pba;
-
-	if (is_write)
-		memcpy(mem + addr - msix_block, data, len);
-	else
-		memcpy(data, mem + addr - msix_block, len);
-}
-
-/*
- * Return an irqfd which can be used by other guests to signal this guest
- * whenever they need to poke it
- */
-int pci_shmem__get_local_irqfd(struct kvm *kvm)
-{
-	int fd, gsi, r;
-
-	if (local_fd == 0) {
-		fd = eventfd(0, 0);
-		if (fd < 0)
-			return fd;
-
-		if (pci_shmem_pci_device.msix.ctrl & cpu_to_le16(PCI_MSIX_FLAGS_ENABLE)) {
-			gsi = irq__add_msix_route(kvm, &msix_table[0].msg,
-						  pci_shmem_device.dev_num << 3);
-			if (gsi < 0)
-				return gsi;
-		} else {
-			gsi = pci_shmem_pci_device.irq_line;
-		}
-
-		r = irq__add_irqfd(kvm, gsi, fd, -1);
-		if (r < 0)
-			return r;
-
-		local_fd = fd;
-	}
-
-	return local_fd;
-}
-
-/*
- * Connect a new client to ivshmem by adding the appropriate datamatch
- * to the DOORBELL
- */
-int pci_shmem__add_client(struct kvm *kvm, u32 id, int fd)
-{
-	struct kvm_ioeventfd ioevent;
-
-	ioevent = (struct kvm_ioeventfd) {
-		.addr		= ivshmem_registers + DOORBELL,
-		.len		= sizeof(u32),
-		.datamatch	= id,
-		.fd		= fd,
-		.flags		= KVM_IOEVENTFD_FLAG_PIO | KVM_IOEVENTFD_FLAG_DATAMATCH,
-	};
-
-	return ioctl(kvm->vm_fd, KVM_IOEVENTFD, &ioevent);
-}
-
-/*
- * Remove a client connected to ivshmem by removing the appropriate datamatch
- * from the DOORBELL
- */
-int pci_shmem__remove_client(struct kvm *kvm, u32 id)
-{
-	struct kvm_ioeventfd ioevent;
-
-	ioevent = (struct kvm_ioeventfd) {
-		.addr		= ivshmem_registers + DOORBELL,
-		.len		= sizeof(u32),
-		.datamatch	= id,
-		.flags		= KVM_IOEVENTFD_FLAG_PIO
-				| KVM_IOEVENTFD_FLAG_DATAMATCH
-				| KVM_IOEVENTFD_FLAG_DEASSIGN,
-	};
-
-	return ioctl(kvm->vm_fd, KVM_IOEVENTFD, &ioevent);
-}
-
-static void *setup_shmem(const char *key, size_t len, int creating)
-{
-	int fd;
-	int rtn;
-	void *mem;
-	int flag = O_RDWR;
-
-	if (creating)
-		flag |= O_CREAT;
-
-	fd = shm_open(key, flag, S_IRUSR | S_IWUSR);
-	if (fd < 0) {
-		pr_warning("Failed to open shared memory file %s\n", key);
-		return NULL;
-	}
-
-	if (creating) {
-		rtn = ftruncate(fd, (off_t) len);
-		if (rtn < 0)
-			pr_warning("Can't ftruncate(fd,%zu)\n", len);
-	}
-	mem = mmap(NULL, len,
-		   PROT_READ | PROT_WRITE, MAP_SHARED | MAP_NORESERVE, fd, 0);
-	if (mem == MAP_FAILED) {
-		pr_warning("Failed to mmap shared memory file");
-		mem = NULL;
-	}
-	close(fd);
-
-	return mem;
-}
-
-int shmem_parser(const struct option *opt, const char *arg, int unset)
-{
-	const u64 default_size = SHMEM_DEFAULT_SIZE;
-	const u64 default_phys_addr = SHMEM_DEFAULT_ADDR;
-	const char *default_handle = SHMEM_DEFAULT_HANDLE;
-	struct shmem_info *si = malloc(sizeof(struct shmem_info));
-	u64 phys_addr;
-	u64 size;
-	char *handle = NULL;
-	int create = 0;
-	const char *p = arg;
-	char *next;
-	int base = 10;
-	int verbose = 0;
-
-	const int skip_pci = strlen("pci:");
-	if (verbose)
-		pr_info("shmem_parser(%p,%s,%d)", opt, arg, unset);
-	/* parse out optional addr family */
-	if (strcasestr(p, "pci:")) {
-		p += skip_pci;
-	} else if (strcasestr(p, "mem:")) {
-		die("I can't add to E820 map yet.\n");
-	}
-	/* parse out physical addr */
-	base = 10;
-	if (strcasestr(p, "0x"))
-		base = 16;
-	phys_addr = strtoll(p, &next, base);
-	if (next == p && phys_addr == 0) {
-		pr_info("shmem: no physical addr specified, using default.");
-		phys_addr = default_phys_addr;
-	}
-	if (*next != ':' && *next != '\0')
-		die("shmem: unexpected chars after phys addr.\n");
-	if (*next == '\0')
-		p = next;
-	else
-		p = next + 1;
-	/* parse out size */
-	base = 10;
-	if (strcasestr(p, "0x"))
-		base = 16;
-	size = strtoll(p, &next, base);
-	if (next == p && size == 0) {
-		pr_info("shmem: no size specified, using default.");
-		size = default_size;
-	}
-	/* look for [KMGkmg][Bb]*  uses base 2. */
-	int skip_B = 0;
-	if (strspn(next, "KMGkmg")) {	/* might have a prefix */
-		if (*(next + 1) == 'B' || *(next + 1) == 'b')
-			skip_B = 1;
-		switch (*next) {
-		case 'K':
-		case 'k':
-			size = size << KB_SHIFT;
-			break;
-		case 'M':
-		case 'm':
-			size = size << MB_SHIFT;
-			break;
-		case 'G':
-		case 'g':
-			size = size << GB_SHIFT;
-			break;
-		default:
-			die("shmem: bug in detecting size prefix.");
-			break;
-		}
-		next += 1 + skip_B;
-	}
-	if (*next != ':' && *next != '\0') {
-		die("shmem: unexpected chars after phys size. <%c><%c>\n",
-		    *next, *p);
-	}
-	if (*next == '\0')
-		p = next;
-	else
-		p = next + 1;
-	/* parse out optional shmem handle */
-	const int skip_handle = strlen("handle=");
-	next = strcasestr(p, "handle=");
-	if (*p && next) {
-		if (p != next)
-			die("unexpected chars before handle\n");
-		p += skip_handle;
-		next = strchrnul(p, ':');
-		if (next - p) {
-			handle = malloc(next - p + 1);
-			strncpy(handle, p, next - p);
-			handle[next - p] = '\0';	/* just in case. */
-		}
-		if (*next == '\0')
-			p = next;
-		else
-			p = next + 1;
-	}
-	/* parse optional create flag to see if we should create shm seg. */
-	if (*p && strcasestr(p, "create")) {
-		create = 1;
-		p += strlen("create");
-	}
-	if (*p != '\0')
-		die("shmem: unexpected trailing chars\n");
-	if (handle == NULL) {
-		handle = malloc(strlen(default_handle) + 1);
-		strcpy(handle, default_handle);
-	}
-	if (verbose) {
-		pr_info("shmem: phys_addr = %llx",
-			(unsigned long long)phys_addr);
-		pr_info("shmem: size      = %llx", (unsigned long long)size);
-		pr_info("shmem: handle    = %s", handle);
-		pr_info("shmem: create    = %d", create);
-	}
-
-	si->phys_addr = phys_addr;
-	si->size = size;
-	si->handle = handle;
-	si->create = create;
-	pci_shmem__register_mem(si);	/* ownership of si, etc. passed on. */
-	return 0;
-}
-
-int pci_shmem__init(struct kvm *kvm)
-{
-	char *mem;
-	int r;
-
-	if (shmem_region == NULL)
-		return 0;
-
-	/* Register MMIO space for MSI-X */
-	r = ioport__register(kvm, IOPORT_EMPTY, &shmem_pci__io_ops, IOPORT_SIZE, NULL);
-	if (r < 0)
-		return r;
-	ivshmem_registers = (u16)r;
-
-	msix_block = pci_get_io_space_block(0x1010);
-	kvm__register_mmio(kvm, msix_block, 0x1010, false, callback_mmio_msix, NULL);
-
-	/*
-	 * This registers 3 BARs:
-	 *
-	 * 0 - ivshmem registers
-	 * 1 - MSI-X MMIO space
-	 * 2 - Shared memory block
-	 */
-	pci_shmem_pci_device.bar[0] = cpu_to_le32(ivshmem_registers | PCI_BASE_ADDRESS_SPACE_IO);
-	pci_shmem_pci_device.bar_size[0] = shmem_region->size;
-	pci_shmem_pci_device.bar[1] = cpu_to_le32(msix_block | PCI_BASE_ADDRESS_SPACE_MEMORY);
-	pci_shmem_pci_device.bar_size[1] = 0x1010;
-	pci_shmem_pci_device.bar[2] = cpu_to_le32(shmem_region->phys_addr | PCI_BASE_ADDRESS_SPACE_MEMORY);
-	pci_shmem_pci_device.bar_size[2] = shmem_region->size;
-
-	device__register(&pci_shmem_device);
-
-	/* Open shared memory and plug it into the guest */
-	mem = setup_shmem(shmem_region->handle, shmem_region->size,
-				shmem_region->create);
-	if (mem == NULL)
-		return -EINVAL;
-
-	kvm__register_dev_mem(kvm, shmem_region->phys_addr, shmem_region->size,
-			      mem);
-	return 0;
-}
-dev_init(pci_shmem__init);
-
-int pci_shmem__exit(struct kvm *kvm)
-{
-	return 0;
-}
-dev_exit(pci_shmem__exit);
diff --git a/include/kvm/pci-shmem.h b/include/kvm/pci-shmem.h
deleted file mode 100644
index 6cff2b85bfd3..000000000000
--- a/include/kvm/pci-shmem.h
+++ /dev/null
@@ -1,32 +0,0 @@
-#ifndef KVM__PCI_SHMEM_H
-#define KVM__PCI_SHMEM_H
-
-#include <linux/types.h>
-#include <linux/list.h>
-
-#include "kvm/parse-options.h"
-
-#define SHMEM_DEFAULT_SIZE (16 << MB_SHIFT)
-#define SHMEM_DEFAULT_ADDR (0xc8000000)
-#define SHMEM_DEFAULT_HANDLE "/kvm_shmem"
-
-struct kvm;
-struct shmem_info;
-
-struct shmem_info {
-	u64 phys_addr;
-	u64 size;
-	char *handle;
-	int create;
-};
-
-int pci_shmem__init(struct kvm *kvm);
-int pci_shmem__exit(struct kvm *kvm);
-int pci_shmem__register_mem(struct shmem_info *si);
-int shmem_parser(const struct option *opt, const char *arg, int unset);
-
-int pci_shmem__get_local_irqfd(struct kvm *kvm);
-int pci_shmem__add_client(struct kvm *kvm, u32 id, int fd);
-int pci_shmem__remove_client(struct kvm *kvm, u32 id);
-
-#endif
-- 
2.20.1

