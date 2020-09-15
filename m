Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D446026A278
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 11:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgIOJoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 05:44:12 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:46823 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbgIOJoG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 05:44:06 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U90piu2_1600163042;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0U90piu2_1600163042)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Sep 2020 17:44:02 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Will Deacon <will@kernel.org>,
        "G . Campana" <gcampana+kvm@quarkslab.com>, kvm@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH kvmtool] virtio: add support for vsock
Date:   Tue, 15 Sep 2020 17:44:02 +0800
Message-Id: <20200915094402.107988-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "run" command accepts a new option (--vsock <cid>) which specify the
guest CID. For instance:

  $ lkvm run --kernel ./bzImage --disk test --vsock 3

One can easily test by: https://github.com/stefanha/nc-vsock.

In the guest:

  # modprobe vsock
  # nc-vsock -l 1234

In the host:

  # modprobe vhost_vsock
  # nc-vsock 3 1234

This patch comes from the early submission of G. Campana. On this basis,
I fixed the compilation errors and runtime crashes. Thanks for the work
done by G. Campana.
https://patchwork.kernel.org/patch/9542313/

Signed-off-by: G. Campana <gcampana+kvm@quarkslab.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 Makefile                     |   1 +
 builtin-run.c                |   2 +
 include/kvm/kvm-config.h     |   1 +
 include/kvm/virtio-pci-dev.h |   2 +
 include/kvm/virtio-vsock.h   |   9 +
 include/linux/vhost.h        |  53 ++++++
 include/linux/virtio_ids.h   |   1 +
 include/linux/virtio_vsock.h |  94 ++++++++++
 virtio/vsock.c               | 340 +++++++++++++++++++++++++++++++++++
 9 files changed, 503 insertions(+)
 create mode 100644 include/kvm/virtio-vsock.h
 create mode 100644 include/linux/virtio_vsock.h
 create mode 100644 virtio/vsock.c

diff --git a/Makefile b/Makefile
index 35bb118..5839a12 100644
--- a/Makefile
+++ b/Makefile
@@ -74,6 +74,7 @@ OBJS	+= virtio/net.o
 OBJS	+= virtio/rng.o
 OBJS    += virtio/balloon.o
 OBJS	+= virtio/pci.o
+OBJS	+= virtio/vsock.o
 OBJS	+= disk/blk.o
 OBJS	+= disk/qcow.o
 OBJS	+= disk/raw.o
diff --git a/builtin-run.c b/builtin-run.c
index c23e7a2..7f93b9d 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -113,6 +113,8 @@ void kvm_run_set_wrapper_sandbox(void)
 		     " guest", virtio_9p_rootdir_parser, kvm),		\
 	OPT_STRING('\0', "console", &(cfg)->console, "serial, virtio or"\
 			" hv", "Console to use"),			\
+	OPT_U64('\0', "vsock", &(cfg)->vsock_cid,			\
+			"Guest virtio socket CID"),			\
 	OPT_STRING('\0', "dev", &(cfg)->dev, "device_file",		\
 			"KVM device file"),				\
 	OPT_CALLBACK('\0', "tty", NULL, "tty id",			\
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index f4a8b83..8b6c151 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -26,6 +26,7 @@ struct kvm_config {
 	u8  image_count;
 	u8 num_net_devices;
 	u8 num_vfio_devices;
+	u64 vsock_cid;
 	bool virtio_rng;
 	int active_console;
 	int debug_iodelay;
diff --git a/include/kvm/virtio-pci-dev.h b/include/kvm/virtio-pci-dev.h
index 48ae018..7bf35cd 100644
--- a/include/kvm/virtio-pci-dev.h
+++ b/include/kvm/virtio-pci-dev.h
@@ -15,6 +15,7 @@
 #define PCI_DEVICE_ID_VIRTIO_BLN		0x1005
 #define PCI_DEVICE_ID_VIRTIO_SCSI		0x1008
 #define PCI_DEVICE_ID_VIRTIO_9P			0x1009
+#define PCI_DEVICE_ID_VIRTIO_VSOCK		0x1012
 #define PCI_DEVICE_ID_VESA			0x2000
 #define PCI_DEVICE_ID_PCI_SHMEM			0x0001
 
@@ -34,5 +35,6 @@
 #define PCI_CLASS_RNG				0xff0000
 #define PCI_CLASS_BLN				0xff0000
 #define PCI_CLASS_9P				0xff0000
+#define PCI_CLASS_VSOCK				0xff0000
 
 #endif /* VIRTIO_PCI_DEV_H_ */
diff --git a/include/kvm/virtio-vsock.h b/include/kvm/virtio-vsock.h
new file mode 100644
index 0000000..e145e64
--- /dev/null
+++ b/include/kvm/virtio-vsock.h
@@ -0,0 +1,9 @@
+#ifndef KVM__VSOCK_VIRTIO_H
+#define KVM__VSOCK_VIRTIO_H
+
+struct kvm;
+
+int virtio_vsock_init(struct kvm *kvm);
+int virtio_vsock_exit(struct kvm *kvm);
+
+#endif /* KVM__VSOCK_VIRTIO_H */
diff --git a/include/linux/vhost.h b/include/linux/vhost.h
index bb6a5b4..56b7ab5 100644
--- a/include/linux/vhost.h
+++ b/include/linux/vhost.h
@@ -47,6 +47,32 @@ struct vhost_vring_addr {
 	__u64 log_guest_addr;
 };
 
+/* no alignment requirement */
+struct vhost_iotlb_msg {
+	__u64 iova;
+	__u64 size;
+	__u64 uaddr;
+#define VHOST_ACCESS_RO      0x1
+#define VHOST_ACCESS_WO      0x2
+#define VHOST_ACCESS_RW      0x3
+	__u8 perm;
+#define VHOST_IOTLB_MISS           1
+#define VHOST_IOTLB_UPDATE         2
+#define VHOST_IOTLB_INVALIDATE     3
+#define VHOST_IOTLB_ACCESS_FAIL    4
+	__u8 type;
+};
+
+#define VHOST_IOTLB_MSG 0x1
+
+struct vhost_msg {
+	int type;
+	union {
+		struct vhost_iotlb_msg iotlb;
+		__u8 padding[64];
+	};
+};
+
 struct vhost_memory_region {
 	__u64 guest_phys_addr;
 	__u64 memory_size; /* bytes */
@@ -103,6 +129,20 @@ struct vhost_memory {
 /* Get accessor: reads index, writes value in num */
 #define VHOST_GET_VRING_BASE _IOWR(VHOST_VIRTIO, 0x12, struct vhost_vring_state)
 
+/* Set the vring byte order in num. Valid values are VHOST_VRING_LITTLE_ENDIAN
+ * or VHOST_VRING_BIG_ENDIAN (other values return -EINVAL).
+ * The byte order cannot be changed while the device is active: trying to do so
+ * returns -EBUSY.
+ * This is a legacy only API that is simply ignored when VIRTIO_F_VERSION_1 is
+ * set.
+ * Not all kernel configurations support this ioctl, but all configurations that
+ * support SET also support GET.
+ */
+#define VHOST_VRING_LITTLE_ENDIAN 0
+#define VHOST_VRING_BIG_ENDIAN 1
+#define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
+#define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
+
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
 
@@ -112,6 +152,12 @@ struct vhost_memory {
 #define VHOST_SET_VRING_CALL _IOW(VHOST_VIRTIO, 0x21, struct vhost_vring_file)
 /* Set eventfd to signal an error */
 #define VHOST_SET_VRING_ERR _IOW(VHOST_VIRTIO, 0x22, struct vhost_vring_file)
+/* Set busy loop timeout (in us) */
+#define VHOST_SET_VRING_BUSYLOOP_TIMEOUT _IOW(VHOST_VIRTIO, 0x23,	\
+					 struct vhost_vring_state)
+/* Get busy loop timeout (in us) */
+#define VHOST_GET_VRING_BUSYLOOP_TIMEOUT _IOW(VHOST_VIRTIO, 0x24,	\
+					 struct vhost_vring_state)
 
 /* VHOST_NET specific defines */
 
@@ -126,6 +172,8 @@ struct vhost_memory {
 #define VHOST_F_LOG_ALL 26
 /* vhost-net should add virtio_net_hdr for RX, and strip for TX packets. */
 #define VHOST_NET_F_VIRTIO_NET_HDR 27
+/* Vhost have device IOTLB */
+#define VHOST_F_DEVICE_IOTLB 63
 
 /* VHOST_SCSI specific definitions */
 
@@ -155,4 +203,9 @@ struct vhost_scsi_target {
 #define VHOST_SCSI_SET_EVENTS_MISSED _IOW(VHOST_VIRTIO, 0x43, __u32)
 #define VHOST_SCSI_GET_EVENTS_MISSED _IOW(VHOST_VIRTIO, 0x44, __u32)
 
+/* VHOST_VSOCK specific defines */
+
+#define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
+#define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
+
 #endif
diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
index 5f60aa4..7de80eb 100644
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@ -40,5 +40,6 @@
 #define VIRTIO_ID_RPROC_SERIAL 11 /* virtio remoteproc serial link */
 #define VIRTIO_ID_CAIF	       12 /* Virtio caif */
 #define VIRTIO_ID_INPUT        18 /* virtio input */
+#define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
new file mode 100644
index 0000000..20b453e
--- /dev/null
+++ b/include/linux/virtio_vsock.h
@@ -0,0 +1,94 @@
+/*
+ * This header, excluding the #ifdef __KERNEL__ part, is BSD licensed so
+ * anyone can use the definitions to implement compatible drivers/servers:
+ *
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS''
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ *
+ * Copyright (C) Red Hat, Inc., 2013-2015
+ * Copyright (C) Asias He <asias@redhat.com>, 2013
+ * Copyright (C) Stefan Hajnoczi <stefanha@redhat.com>, 2015
+ */
+
+#ifndef _LINUX_VIRTIO_VSOCK_H
+#define _LINUX_VIRTIO_VSOCK_H
+
+#include <linux/types.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+
+struct virtio_vsock_config {
+	__le64 guest_cid;
+} __attribute__((packed));
+
+enum virtio_vsock_event_id {
+	VIRTIO_VSOCK_EVENT_TRANSPORT_RESET = 0,
+};
+
+struct virtio_vsock_event {
+	__le32 id;
+} __attribute__((packed));
+
+struct virtio_vsock_hdr {
+	__le64	src_cid;
+	__le64	dst_cid;
+	__le32	src_port;
+	__le32	dst_port;
+	__le32	len;
+	__le16	type;		/* enum virtio_vsock_type */
+	__le16	op;		/* enum virtio_vsock_op */
+	__le32	flags;
+	__le32	buf_alloc;
+	__le32	fwd_cnt;
+} __attribute__((packed));
+
+enum virtio_vsock_type {
+	VIRTIO_VSOCK_TYPE_STREAM = 1,
+};
+
+enum virtio_vsock_op {
+	VIRTIO_VSOCK_OP_INVALID = 0,
+
+	/* Connect operations */
+	VIRTIO_VSOCK_OP_REQUEST = 1,
+	VIRTIO_VSOCK_OP_RESPONSE = 2,
+	VIRTIO_VSOCK_OP_RST = 3,
+	VIRTIO_VSOCK_OP_SHUTDOWN = 4,
+
+	/* To send payload */
+	VIRTIO_VSOCK_OP_RW = 5,
+
+	/* Tell the peer our credit info */
+	VIRTIO_VSOCK_OP_CREDIT_UPDATE = 6,
+	/* Request the peer to send the credit info to us */
+	VIRTIO_VSOCK_OP_CREDIT_REQUEST = 7,
+};
+
+/* VIRTIO_VSOCK_OP_SHUTDOWN flags values */
+enum virtio_vsock_shutdown {
+	VIRTIO_VSOCK_SHUTDOWN_RCV = 1,
+	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
+};
+
+#endif /* _LINUX_VIRTIO_VSOCK_H */
diff --git a/virtio/vsock.c b/virtio/vsock.c
new file mode 100644
index 0000000..5b99838
--- /dev/null
+++ b/virtio/vsock.c
@@ -0,0 +1,340 @@
+#include "kvm/virtio-vsock.h"
+#include "kvm/virtio-pci-dev.h"
+#include "kvm/kvm.h"
+#include "kvm/pci.h"
+#include "kvm/ioeventfd.h"
+#include "kvm/guest_compat.h"
+#include "kvm/virtio-pci.h"
+#include "kvm/virtio.h"
+
+#include <linux/kernel.h>
+#include <linux/virtio_vsock.h>
+#include <linux/vhost.h>
+
+#define VIRTIO_VSOCK_QUEUE_SIZE		128
+
+static LIST_HEAD(vdevs);
+static int compat_id = -1;
+
+enum {
+	VSOCK_VQ_RX     = 0, /* for host to guest data */
+	VSOCK_VQ_TX     = 1, /* for guest to host data */
+	VSOCK_VQ_EVENT  = 2,
+	VSOCK_VQ_MAX    = 3,
+};
+
+struct vsock_dev {
+	struct virt_queue		vqs[VSOCK_VQ_MAX];
+	struct virtio_vsock_config	config;
+	u32				features;
+	int				vhost_fd;
+	struct virtio_device		vdev;
+	struct list_head		list;
+	struct kvm			*kvm;
+	bool				started;
+};
+
+static u8 *get_config(struct kvm *kvm, void *dev)
+{
+	struct vsock_dev *vdev = dev;
+
+	return ((u8 *)(&vdev->config));
+}
+
+static u32 get_host_features(struct kvm *kvm, void *dev)
+{
+	return 1UL << VIRTIO_RING_F_EVENT_IDX
+		| 1UL << VIRTIO_RING_F_INDIRECT_DESC;
+}
+
+static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
+{
+	struct vsock_dev *vdev = dev;
+
+	vdev->features = features;
+}
+
+static bool is_event_vq(u32 vq)
+{
+	return vq == VSOCK_VQ_EVENT;
+}
+
+static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
+		   u32 pfn)
+{
+	struct vhost_vring_state state = { .index = vq };
+	struct vhost_vring_addr addr;
+	struct vsock_dev *vdev = dev;
+	struct virt_queue *queue;
+	void *p;
+	int r;
+
+	compat__remove_message(compat_id);
+
+	queue		= &vdev->vqs[vq];
+	queue->pfn	= pfn;
+	p		= virtio_get_vq(kvm, queue->pfn, page_size);
+
+	vring_init(&queue->vring, VIRTIO_VSOCK_QUEUE_SIZE, p, align);
+	virtio_init_device_vq(&vdev->vdev, queue);
+
+	if (vdev->vhost_fd == -1)
+		return 0;
+
+	if (is_event_vq(vq))
+		return 0;
+
+	state.num = queue->vring.num;
+	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_NUM, &state);
+	if (r < 0)
+		die_perror("VHOST_SET_VRING_NUM failed");
+
+	state.num = 0;
+	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_BASE, &state);
+	if (r < 0)
+		die_perror("VHOST_SET_VRING_BASE failed");
+
+	addr = (struct vhost_vring_addr) {
+		.index = vq,
+		.desc_user_addr = (u64)(unsigned long)queue->vring.desc,
+		.avail_user_addr = (u64)(unsigned long)queue->vring.avail,
+		.used_user_addr = (u64)(unsigned long)queue->vring.used,
+	};
+
+	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_ADDR, &addr);
+	if (r < 0)
+		die_perror("VHOST_SET_VRING_ADDR failed");
+
+	return 0;
+}
+
+static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
+{
+	struct vsock_dev *vdev = dev;
+	struct vhost_vring_file file = {
+		.index	= vq,
+		.fd	= efd,
+	};
+	int r;
+
+	if (is_event_vq(vq))
+		return;
+
+	if (vdev->vhost_fd == -1)
+		return;
+
+	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_KICK, &file);
+	if (r < 0)
+		die_perror("VHOST_SET_VRING_KICK failed");
+}
+
+static void notify_status(struct kvm *kvm, void *dev, u32 status)
+{
+	struct vsock_dev *vdev = dev;
+	int r, start;
+
+	start = !!(status & VIRTIO_CONFIG_S_DRIVER_OK);
+	if (vdev->started == start)
+		return;
+
+	r = ioctl(vdev->vhost_fd, VHOST_VSOCK_SET_RUNNING, &start);
+	if (r != 0)
+		die("VHOST_VSOCK_SET_RUNNING failed %d", errno);
+
+	vdev->started = start;
+}
+
+static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	return 0;
+}
+
+static struct virt_queue *get_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	struct vsock_dev *vdev = dev;
+
+	return &vdev->vqs[vq];
+}
+
+static int get_size_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	return VIRTIO_VSOCK_QUEUE_SIZE;
+}
+
+static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
+{
+	return size;
+}
+
+static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
+{
+	struct vhost_vring_file file;
+	struct vsock_dev *vdev = dev;
+	struct kvm_irqfd irq;
+	int r;
+
+	if (vdev->vhost_fd == -1)
+		return;
+
+	if (is_event_vq(vq))
+		return;
+
+	irq = (struct kvm_irqfd) {
+		.gsi	= gsi,
+		.fd	= eventfd(0, 0),
+	};
+	file = (struct vhost_vring_file) {
+		.index	= vq,
+		.fd	= irq.fd,
+	};
+
+	r = ioctl(kvm->vm_fd, KVM_IRQFD, &irq);
+	if (r < 0)
+		die_perror("KVM_IRQFD failed");
+
+	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_CALL, &file);
+	if (r < 0)
+		die_perror("VHOST_SET_VRING_CALL failed");
+}
+
+static int get_vq_count(struct kvm *kvm, void *dev)
+{
+	return VSOCK_VQ_MAX;
+}
+
+static struct virtio_ops vsock_dev_virtio_ops = {
+	.get_config		= get_config,
+	.get_host_features	= get_host_features,
+	.set_guest_features	= set_guest_features,
+	.init_vq		= init_vq,
+	.get_vq			= get_vq,
+	.get_size_vq		= get_size_vq,
+	.set_size_vq		= set_size_vq,
+	.notify_vq_eventfd	= notify_vq_eventfd,
+	.notify_status		= notify_status,
+	.notify_vq_gsi		= notify_vq_gsi,
+	.notify_vq		= notify_vq,
+	.get_vq_count		= get_vq_count,
+};
+
+static void virtio_vhost_vsock_init(struct kvm *kvm, struct vsock_dev *vdev)
+{
+	struct kvm_mem_bank *bank;
+	struct vhost_memory *mem;
+	u64 features;
+	int r, i;
+
+	vdev->vhost_fd = open("/dev/vhost-vsock", O_RDWR);
+	if (vdev->vhost_fd < 0)
+		die_perror("Failed opening vhost-vsock device");
+
+	mem = calloc(1, sizeof(*mem) + sizeof(struct vhost_memory_region));
+	if (mem == NULL)
+		die("Failed allocating memory for vhost memory map");
+
+	i = 0;
+	list_for_each_entry(bank, &kvm->mem_banks, list) {
+		mem->regions[i] = (struct vhost_memory_region) {
+			.guest_phys_addr = bank->guest_phys_addr,
+			.memory_size	 = bank->size,
+			.userspace_addr	 = (unsigned long)bank->host_addr,
+		};
+		i++;
+	}
+	mem->nregions = i;
+
+	r = ioctl(vdev->vhost_fd, VHOST_SET_OWNER);
+	if (r != 0)
+		die_perror("VHOST_SET_OWNER failed");
+
+	r = ioctl(vdev->vhost_fd, VHOST_SET_MEM_TABLE, mem);
+	if (r != 0)
+		die_perror("VHOST_SET_MEM_TABLE failed");
+
+	r = ioctl(vdev->vhost_fd, VHOST_GET_FEATURES, &features);
+	if (r != 0)
+		die_perror("VHOST_GET_FEATURES failed");
+
+	r = ioctl(vdev->vhost_fd, VHOST_SET_FEATURES, &features);
+	if (r != 0)
+		die_perror("VHOST_SET_FEATURES failed");
+
+	r = ioctl(vdev->vhost_fd, VHOST_VSOCK_SET_GUEST_CID, &vdev->config.guest_cid);
+	if (r != 0)
+		die_perror("VHOST_VSOCK_SET_GUEST_CID failed");
+
+	vdev->vdev.use_vhost = true;
+
+	free(mem);
+}
+
+static int virtio_vsock_init_one(struct kvm *kvm, u64 guest_cid)
+{
+	struct vsock_dev *vdev;
+	int r;
+
+	vdev = calloc(1, sizeof(struct vsock_dev));
+	if (vdev == NULL)
+		return -ENOMEM;
+
+	*vdev = (struct vsock_dev) {
+		.config	= (struct virtio_vsock_config) {
+			.guest_cid	= guest_cid,
+		},
+		.vhost_fd		= -1,
+		.kvm			= kvm,
+	};
+
+	list_add_tail(&vdev->list, &vdevs);
+
+	r = virtio_init(kvm, vdev, &vdev->vdev, &vsock_dev_virtio_ops,
+		    VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_VSOCK,
+		    VIRTIO_ID_VSOCK, PCI_CLASS_VSOCK);
+	if (r < 0)
+	    return r;
+
+	virtio_vhost_vsock_init(kvm, vdev);
+
+	if (compat_id == -1)
+		compat_id = virtio_compat_add_message("virtio-vsock", "CONFIG_VIRTIO_VSOCK");
+
+	return 0;
+}
+
+static int virtio_vsock_exit_one(struct kvm *kvm, struct vsock_dev *vdev)
+{
+	list_del(&vdev->list);
+	free(vdev);
+
+	return 0;
+}
+
+int virtio_vsock_init(struct kvm *kvm)
+{
+	int r;
+
+	if (kvm->cfg.vsock_cid == 0)
+		return 0;
+
+	r = virtio_vsock_init_one(kvm, kvm->cfg.vsock_cid);
+	if (r < 0)
+		goto cleanup;
+
+	return 0;
+cleanup:
+	return virtio_vsock_exit(kvm);
+}
+virtio_dev_init(virtio_vsock_init);
+
+int virtio_vsock_exit(struct kvm *kvm)
+{
+	while (!list_empty(&vdevs)) {
+		struct vsock_dev *vdev;
+
+		vdev = list_first_entry(&vdevs, struct vsock_dev, list);
+		virtio_vsock_exit_one(kvm, vdev);
+	}
+
+	return 0;
+}
+virtio_dev_exit(virtio_vsock_exit);
-- 
2.19.1.3.ge56e4f7

