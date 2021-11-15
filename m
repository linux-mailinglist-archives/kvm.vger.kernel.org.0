Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01926450229
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 11:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237342AbhKOKRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 05:17:22 -0500
Received: from foss.arm.com ([217.140.110.172]:53322 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237132AbhKOKRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 05:17:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A61B61063;
        Mon, 15 Nov 2021 02:14:20 -0800 (PST)
Received: from e120937-lin.home (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 628BB3F70D;
        Mon, 15 Nov 2021 02:14:19 -0800 (PST)
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     andre.przywara@arm.com, sudeep.holla@arm.com,
        alexandru.elisei@arm.com, james.morse@arm.com,
        Cristian Marussi <cristian.marussi@arm.com>
Subject: [RFC PATCH kvmtool 1/2] virtio: Add support for VirtIO SCMI Device
Date:   Mon, 15 Nov 2021 10:14:00 +0000
Message-Id: <20211115101401.21685-2-cristian.marussi@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211115101401.21685-1-cristian.marussi@arm.com>
References: <20211115101401.21685-1-cristian.marussi@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for emulation of a VirtIO SCMI Device as per specification
at: https://github.com/oasis-tcs/virtio-spec/blob/master/virtio-scmi.tex.

As per VirtIO specification, an SCMI Device represents an SCMI platform
backend providing SCMI services to SCMI agents (like the OSPM guest Kernel
running an SCMI stack): the SCMI virtio transport layer in the guest
represents the VirtIO frontend driver.

In such a scenario it is not advisable/feasible to implement the real SCMI
platform backend (i.e. the SCMI Server FW stack) in the hypervisor, so the
VirtIO SCMI device emulated by kvmtool has been implemented really to act
as a proxy device, relaying SCMI messages back and forth from the internal
virtqueues to a userspace application reachable through Unix sockets.

When a VirtIO SCMI device emulation is requested (using new --scmi option),
a few needed additional SCMI-related FDT entries are generated to support
enumeration of all known SCMI standard protocols.
Further options let configure the emulated SCMI device behaviour and/or
additional SCMI custom protocols to include in the base DT.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
---
 Makefile                                 |   1 +
 arm/fdt.c                                |   4 +
 arm/include/arm-common/kvm-config-arch.h |  19 +-
 arm/include/arm-common/scmi.h            |   6 +
 include/kvm/virtio-pci-dev.h             |   2 +
 include/kvm/virtio-scmi.h                |   9 +
 include/linux/virtio_ids.h               |   1 +
 include/linux/virtio_scmi.h              |  43 ++
 virtio/scmi.c                            | 656 +++++++++++++++++++++++
 9 files changed, 740 insertions(+), 1 deletion(-)
 create mode 100644 arm/include/arm-common/scmi.h
 create mode 100644 include/kvm/virtio-scmi.h
 create mode 100644 include/linux/virtio_scmi.h
 create mode 100644 virtio/scmi.c

diff --git a/Makefile b/Makefile
index bb7ad3e..5b73286 100644
--- a/Makefile
+++ b/Makefile
@@ -102,6 +102,7 @@ OBJS	+= virtio/9p-pdu.o
 OBJS	+= kvm-ipc.o
 OBJS	+= builtin-sandbox.o
 OBJS	+= virtio/mmio.o
+OBJS	+= virtio/scmi.o
 
 # Translate uname -m into ARCH string
 ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
diff --git a/arm/fdt.c b/arm/fdt.c
index 635de7f..c2dfdae 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -6,6 +6,7 @@
 
 #include "arm-common/gic.h"
 #include "arm-common/pci.h"
+#include "arm-common/scmi.h"
 
 #include <stdbool.h>
 
@@ -222,6 +223,9 @@ static int setup_fdt(struct kvm *kvm)
 		fdt_stdout_path = NULL;
 	}
 
+	if (kvm->cfg.arch.scmi)
+		scmi__generate_fdt_nodes(fdt);
+
 	/* Finalise. */
 	_FDT(fdt_end_node(fdt));
 	_FDT(fdt_finish(fdt));
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 5734c46..b850c01 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -12,6 +12,11 @@ struct kvm_config_arch {
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
+	bool		scmi;
+	bool		scmi_no_p2a;
+	const char	*scmi_cmdq;
+	const char	*scmi_evtq;
+	const char	*scmi_custom_protos;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
@@ -33,6 +38,18 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset);
 		     "Type of interrupt controller to emulate in the guest",	\
 		     irqchip_parser, NULL),					\
 	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
-		"Address where firmware should be loaded"),
+		"Address where firmware should be loaded"),			\
+	OPT_BOOLEAN('\0', "scmi", &(cfg)->scmi,					\
+		    "Create a VirtIO SCMI proxy Device with default config"),	\
+	OPT_BOOLEAN('\0', "scmi-no-p2a", &(cfg)->scmi_no_p2a,			\
+		    "Disable P2A Support in emulated SCMI Device"),		\
+	OPT_STRING('\0', "scmi-cmdq", &(cfg)->scmi_cmdq,			\
+		   "unix socket pathname",					\
+		   "Default cmdq pathname is /var/run/scmi_ospm_vq0.sock"),	\
+	OPT_STRING('\0', "scmi-evtq", &(cfg)->scmi_evtq,			\
+		   "unix socket pathname",					\
+		   "Default eventq pathname is /var/run/scmi_ospm_vq1.sock"),	\
+	OPT_STRING('\0', "scmi-custom-protos", &(cfg)->scmi_custom_protos,	\
+		   "0x66,32,0x77,...", "Additional custom protos"),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm/include/arm-common/scmi.h b/arm/include/arm-common/scmi.h
new file mode 100644
index 0000000..b3010ad
--- /dev/null
+++ b/arm/include/arm-common/scmi.h
@@ -0,0 +1,6 @@
+#ifndef ARM_COMMON__SCMI_H
+#define ARM_COMMON__SCMI_H
+
+void scmi__generate_fdt_nodes(void *fdt);
+
+#endif /* ARM_COMMON__SCMI_H */
diff --git a/include/kvm/virtio-pci-dev.h b/include/kvm/virtio-pci-dev.h
index 7bf35cd..ef32af3 100644
--- a/include/kvm/virtio-pci-dev.h
+++ b/include/kvm/virtio-pci-dev.h
@@ -16,6 +16,7 @@
 #define PCI_DEVICE_ID_VIRTIO_SCSI		0x1008
 #define PCI_DEVICE_ID_VIRTIO_9P			0x1009
 #define PCI_DEVICE_ID_VIRTIO_VSOCK		0x1012
+#define PCI_DEVICE_ID_VIRTIO_SCMI		0x1013
 #define PCI_DEVICE_ID_VESA			0x2000
 #define PCI_DEVICE_ID_PCI_SHMEM			0x0001
 
@@ -36,5 +37,6 @@
 #define PCI_CLASS_BLN				0xff0000
 #define PCI_CLASS_9P				0xff0000
 #define PCI_CLASS_VSOCK				0xff0000
+#define PCI_CLASS_SCMI				0xff0000
 
 #endif /* VIRTIO_PCI_DEV_H_ */
diff --git a/include/kvm/virtio-scmi.h b/include/kvm/virtio-scmi.h
new file mode 100644
index 0000000..6355f5e
--- /dev/null
+++ b/include/kvm/virtio-scmi.h
@@ -0,0 +1,9 @@
+#ifndef KVM__SCMI_VIRTIO_H
+#define KVM__SCMI_VIRTIO_H
+
+struct kvm;
+
+int virtio_scmi__init(struct kvm *kvm);
+int virtio_scmi__exit(struct kvm *kvm);
+
+#endif /* KVM__SCMI_VIRTIO_H */
diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
index 7de80eb..16efdf6 100644
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@ -41,5 +41,6 @@
 #define VIRTIO_ID_CAIF	       12 /* Virtio caif */
 #define VIRTIO_ID_INPUT        18 /* virtio input */
 #define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
+#define VIRTIO_ID_SCMI         32 /* virtio SCMI */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
diff --git a/include/linux/virtio_scmi.h b/include/linux/virtio_scmi.h
new file mode 100644
index 0000000..d4f1ebc
--- /dev/null
+++ b/include/linux/virtio_scmi.h
@@ -0,0 +1,43 @@
+#ifndef _LINUX_VIRTIO_SCMI_H
+#define _LINUX_VIRTIO_SCMI_H
+/* This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
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
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE. */
+#include <linux/types.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+
+/* The feature bitmap for virtio net */
+/* Device implements some SCMI notifications, or delayed responses. */
+#define VIRTIO_SCMI_F_P2A_CHANNELS	0
+/* Device implements any SCMI statistics shared memory region */
+#define VIRTIO_SCMI_F_SHARED_MEMORY	1
+
+/* Virtqueues */
+#define VIRTIO_SCMI_VQ_TX		0 /* cmdq */
+#define VIRTIO_SCMI_VQ_RX		1 /* eventq */
+#define VIRTIO_SCMI_VQ_MAX_CNT		2
+
+#endif /* _LINUX_VIRTIO_SCMI_H */
diff --git a/virtio/scmi.c b/virtio/scmi.c
new file mode 100644
index 0000000..b7570e1
--- /dev/null
+++ b/virtio/scmi.c
@@ -0,0 +1,656 @@
+#include "kvm/mutex.h"
+#include "kvm/util.h"
+#include "kvm/kvm.h"
+#include "kvm/fdt.h"
+#include "kvm/pci.h"
+#include "kvm/virtio-pci-dev.h"
+#include "kvm/virtio-scmi.h"
+#include "kvm/virtio.h"
+
+#include <linux/bitops.h>
+#include <linux/virtio_ring.h>
+#include <linux/virtio_scmi.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/types.h>
+
+#include <poll.h>
+#include <pthread.h>
+#include <sys/eventfd.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <sys/uio.h>
+
+#include "arm-common/scmi.h"
+
+#define VIRTIO_SCMI_QUEUE_SZ	32
+#define SCMI_DEFAULT_CMDQ_SOCK	"/var/run/scmi_ospm_vq0.sock"
+#define SCMI_DEFAULT_EVTQ_SOCK	"/var/run/scmi_ospm_vq1.sock"
+#define SCMI_MAX_MSG_SZ		512
+
+/* Skip BASE protocol since it does not need a DT entry */
+enum {
+	SCMI_PROTOCOL_FIRST = 0x11,
+	SCMI_PROTOCOL_POWER = SCMI_PROTOCOL_FIRST,
+	SCMI_PROTOCOL_SYSPOWER,
+	SCMI_PROTOCOL_PERFORMANCE,
+	SCMI_PROTOCOL_CLOCK,
+	SCMI_PROTOCOL_SENSOR,
+	SCMI_PROTOCOL_RESET,
+	SCMI_PROTOCOL_VOLTAGE,
+	SCMI_PROTOCOL_LAST,
+	SCMI_PROTOCOL_MAX = 255
+};
+
+enum {
+	SCMI_FD_GUEST_VQUEUE,
+	SCMI_FD_HOST_SOCKET,
+	SCMI_FD_MAX
+};
+
+enum {
+	IOV_DESC_IDX,
+	IOV_GUEST_REQ,
+	IOV_HOST_NOTIF = IOV_GUEST_REQ,
+	IOV_HOST_REPLY,
+	IOVS_MAX
+};
+
+struct scmi_vqueue_msg {
+	struct scmi_vqueue	*s;
+	struct iovec		iovs[IOVS_MAX];
+	u16			out, in, head;
+	int			len;
+	struct list_head	list;
+};
+
+struct scmi_vqueue {
+	int			idx;
+	const char		*name;
+	const char		*sockname;
+	int			set_size;
+	struct virt_queue	q;
+	pthread_t		worker;
+	int			efd;
+	int			sfd;
+	struct pollfd		pfds[SCMI_FD_MAX];
+	struct scmi_vqueue_msg	msg[VIRTIO_SCMI_QUEUE_SZ];
+	struct list_head	free_mesg;
+	struct scmi_dev		*sdev;
+	struct mutex		mtx;
+};
+
+struct scmi_dev {
+	struct virtio_device	vdev;
+	u32			supported_vqs;
+	struct scmi_vqueue	s[VIRTIO_SCMI_VQ_MAX_CNT];
+	struct kvm		*kvm;
+};
+
+#define	SCMI_PROTOS_SZ		(BITS_TO_LONGS(SCMI_PROTOCOL_MAX + 1) * sizeof(long))
+static unsigned long		scmi_protos[SCMI_PROTOS_SZ];
+
+/* Only one SCMI device supported */
+struct scmi_dev			scmi_dev;
+
+#ifdef CONFIG_HAS_LIBFDT
+void scmi__generate_fdt_nodes(void *fdt)
+{
+	int pnum;
+
+	_FDT(fdt_begin_node(fdt, "firmware"));
+
+	_FDT(fdt_begin_node(fdt, "scmi"));
+	_FDT(fdt_property_string(fdt, "compatible", "arm,scmi-virtio"));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 0x0));
+
+	for (pnum = SCMI_PROTOCOL_FIRST; pnum < SCMI_PROTOCOL_MAX + 1; pnum++) {
+		if (test_bit(pnum, scmi_protos)) {
+			char pnode_name[16];
+
+			snprintf(pnode_name, 16, "protocol@%02x", pnum);
+			_FDT(fdt_begin_node(fdt, pnode_name));
+			_FDT(fdt_property_cell(fdt, "reg", pnum));
+			/* Fill in additional required props for standard protocols */
+			if (pnum < SCMI_PROTOCOL_LAST) {
+				switch (pnum) {
+				case SCMI_PROTOCOL_POWER:
+					_FDT(fdt_property_cell(fdt,
+							       "#power-domain-cells",
+							       0x1));
+					break;
+				case SCMI_PROTOCOL_PERFORMANCE:
+				case SCMI_PROTOCOL_CLOCK:
+					_FDT(fdt_property_cell(fdt,
+							       "#clock-cells", 0x1));
+					break;
+				case SCMI_PROTOCOL_SENSOR:
+					_FDT(fdt_property_cell(fdt,
+							       "#thermal-sensor-cells",
+							       0x1));
+					break;
+				case SCMI_PROTOCOL_RESET:
+					_FDT(fdt_property_cell(fdt,
+							       "#reset-cells",
+							       0x1));
+					break;
+				default:
+					break;
+				}
+			}
+			_FDT(fdt_end_node(fdt));
+		}
+	}
+	_FDT(fdt_end_node(fdt));
+
+	_FDT(fdt_end_node(fdt));
+}
+#else
+void scmi__generate_fdt_nodes(void *fdt)
+{
+	die("Unable to generate device tree nodes without libfdt\n");
+}
+#endif
+
+static u32 get_host_features(struct kvm *kvm, void *dev)
+{
+	struct scmi_dev *sdev = dev;
+
+	return (sdev->supported_vqs == VIRTIO_SCMI_VQ_MAX_CNT) ?
+		1UL << VIRTIO_SCMI_F_P2A_CHANNELS : 0UL;
+}
+
+static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
+{
+	struct scmi_dev *sdev = dev;
+
+	if (!(sdev->vdev.features & (1UL << VIRTIO_SCMI_F_P2A_CHANNELS))) {
+		pr_warning("Notifications and delayed responses disabled.\n");
+		sdev->supported_vqs = 1;
+	}
+}
+
+static void notify_status(struct kvm *kvm, void *dev, u32 status)
+{
+	pr_debug("Status -> %d\n", status);
+}
+
+static int scmi_do_traffic_from_guest(struct scmi_vqueue *s)
+{
+	int r;
+	u16 head;
+	u64 data;
+
+	r = read(s->efd, &data, sizeof(u64));
+	if (r < 0)
+		return r;
+
+	while (virt_queue__available(&s->q)) {
+		struct scmi_vqueue_msg *msg;
+
+		head = virt_queue__pop(&s->q);
+		if (head >= VIRTIO_SCMI_QUEUE_SZ)
+			die("Unplausible head:%d for VQ:%d - last:%d  num:%d\n",
+			    head, s->idx, s->q.last_avail_idx, s->q.vring.num);
+
+		msg = &s->msg[head];
+		msg->head = virt_queue__get_head_iov(&msg->s->q,
+						     &msg->iovs[IOV_GUEST_REQ],
+						     &msg->out, &msg->in,
+						     head, s->sdev->kvm);
+
+		pr_debug("==>>FROM VQ[%d]: MSG[%d] ->  IN:%d  OUT:%d\n",
+			 s->idx, msg->head, msg->in, msg->out);
+
+		if (s->idx == VIRTIO_SCMI_VQ_TX) {
+			pr_debug("====>>>>ROUTING CMD_REQ[%d]:: IOV_LEN[%d]:%zd  IOV_BASE:%p\n",
+				 msg->head, IOV_GUEST_REQ,
+				 msg->iovs[IOV_GUEST_REQ].iov_len,
+				 msg->iovs[IOV_GUEST_REQ].iov_base);
+			/*
+			 * Send the SCMI command-request payload, extracted from
+			 * the received vqueue buffer, to the host, where FW
+			 * emulation lives.
+			 *
+			 * Note that, while routing such requests to the host,
+			 * the SCMI payload is pre-pended with a 16bit integer
+			 * value (msg->iovs[IOV_DESC_IDX]) representing the
+			 * descriptor index of the buffer which contained the
+			 * originating SCMI request; the host will then reply
+			 * accordingly pre-pending the same index to its reply
+			 * payload.
+			 * This is needed to fill in the received replies into
+			 * the same buffers used to send the requests, as
+			 * required by SCMI VirtIO Device specification, since
+			 * there could be multiple in-flight requests and order
+			 * is not guaranteed either.
+			 */
+			writev(s->sfd, msg->iovs, 2);
+		} else {
+			pr_debug("====>>>>RX EMPTY MSG::head:%d   --  IOV_LEN:%zd  IOV_BASE:%p\n",
+				 msg->head, msg->iovs[IOV_GUEST_REQ].iov_len,
+				 msg->iovs[IOV_GUEST_REQ].iov_base);
+
+			/*
+			 * Buffers received from the Guest on the RX vqueue are
+			 * plain simple empty buffers made available by the
+			 * Guest to be used to send notifications and delayed
+			 * reponses...just keep them in a free list.
+			 */
+			list_add_tail(&msg->list, &s->free_mesg);
+		}
+	}
+
+	return 0;
+}
+
+static struct scmi_vqueue_msg *scmi_retrieve_host_v0_msg(struct scmi_vqueue *s)
+{
+	u16 desc_idx;
+	int len;
+	char buf[SCMI_MAX_MSG_SZ];
+	struct scmi_vqueue_msg *msg;
+	struct iovec iovs[2] = {
+		{
+			.iov_base = &desc_idx,
+			.iov_len = sizeof(desc_idx),
+		},
+		{
+			.iov_base = buf,
+			.iov_len  = sizeof(buf),
+		}
+	};
+
+	/* Read the reply including the leading descriptor index */
+	len = readv(s->sfd, iovs, 2);
+	if (len < (int)iovs[0].iov_len || desc_idx >= VIRTIO_SCMI_QUEUE_SZ)
+		return NULL;
+
+	/* Pick vqueue message to use for the reply using the descriptor index */
+	msg = &s->msg[desc_idx];
+	if (!msg)
+		return NULL;
+
+	/* Copy the reply to the final buffer and adjust the length */
+	msg->len = len - iovs[0].iov_len;
+	memcpy(msg->iovs[IOV_HOST_REPLY].iov_base, iovs[1].iov_base, msg->len);
+
+	pr_debug("===>>>SOCK VQ[%d]:: INJECTING CMD_REPLY -> msg_idx:%d  -- IOV_LEN[%d]:%zd\n",
+		 s->idx, msg->head, IOV_HOST_REPLY,
+		 msg->iovs[IOV_HOST_REPLY].iov_len);
+
+	return msg;
+}
+
+static struct scmi_vqueue_msg *scmi_retrieve_host_v1_msg(struct scmi_vqueue *s)
+{
+	int len;
+	struct scmi_vqueue_msg *msg;
+
+	msg = list_first_entry(&s->free_mesg, struct scmi_vqueue_msg, list);
+	if (!msg)
+		return NULL;
+	list_del(&msg->list);
+
+	/* Read directly into proper vqueue iovs anyway */
+	len = read(s->sfd, msg->iovs[IOV_HOST_NOTIF].iov_base,
+		   msg->iovs[IOV_HOST_NOTIF].iov_len);
+	if (len < 0) {
+		list_add(&msg->list, &s->free_mesg);
+		return NULL;
+	}
+
+	msg->len = len;
+
+	pr_debug("===>>>SOCK VQ[%d]:: INJECTING NOTIF/DRESP -> msg_idx:%d  -- IOV_LEN[%d]:%zd\n",
+		 s->idx, msg->head, IOV_HOST_NOTIF,
+		 msg->iovs[IOV_HOST_NOTIF].iov_len);
+
+	return msg;
+}
+
+static int scmi_do_traffic_from_host(struct scmi_vqueue *s)
+{
+	struct scmi_vqueue_msg *msg;
+
+	if (s->idx == VIRTIO_SCMI_VQ_TX)
+		msg = scmi_retrieve_host_v0_msg(s);
+	else
+		msg = scmi_retrieve_host_v1_msg(s);
+
+	if (!msg) {
+		pr_debug("RX un-expected Host mesg on VQ:%d.\n", s->idx);
+		return -1;
+	}
+
+	pr_debug("===>>>SOCK VQ[%d]:: Filled %s -> msg_idx:%d - len:%d\n",
+		 s->idx, s->idx == VIRTIO_SCMI_VQ_TX ? "CMD_REPLY" : "NOTIF/DRESP",
+		 msg->head, msg->len);
+
+	mutex_lock(&s->mtx);
+	virt_queue__set_used_elem(&msg->s->q, msg->head, msg->len);
+	mutex_unlock(&s->mtx);
+	if (virtio_queue__should_signal(&msg->s->q))
+		msg->s->sdev->vdev.ops->signal_vq(msg->s->sdev->kvm,
+						  &msg->s->sdev->vdev,
+						  msg->s->idx);
+
+	return 0;
+}
+
+static int virtio_scmi_initialize_host_connection(struct scmi_vqueue *s)
+{
+	int ret;
+	struct sockaddr_un addr;
+
+	memset(&addr, 0, sizeof(struct sockaddr_un));
+	addr.sun_family = AF_UNIX;
+	strncpy(addr.sun_path, s->sockname, sizeof(addr.sun_path) - 1);
+
+	/* Loop waiting for connection to Host SCMI Emulation server */
+	do {
+		s->sfd = socket(AF_UNIX, SOCK_SEQPACKET | SOCK_NONBLOCK, 0);
+		if (s->sfd < 0)
+			return -errno;
+
+		ret = connect(s->sfd, (const struct sockaddr *)&addr,
+			      sizeof(struct sockaddr_un));
+		if (ret) {
+			close(s->sfd);
+			sleep(1);
+		}
+	} while (ret);
+
+	s->pfds[SCMI_FD_HOST_SOCKET].fd = s->sfd;
+	s->pfds[SCMI_FD_HOST_SOCKET].events = POLLIN;
+
+	pr_debug("VQ%d:: Host connection OK.\n", s->idx);
+
+	return 0;
+}
+
+/**
+ * One thread is spawned for each configured vqueue; it is in charge to
+ * handle traffic from both directions:
+ *  - SCMI command requests or available buffers coming out from Guest vqueues:
+ *    thread is kicked via an eventfd when such traffic is received.
+ *  - SCMI replies/notifications injected back by the Host userspace FW
+ *    emulation through a UNIX SOCK_SEQPACKET.
+ *
+ *  Re-establish host connection when it drops, bail out, instead, if internal
+ *  connection on eventfd is lost.
+ */
+static void *virtio_scmi_traffic_thread(void *data)
+{
+	int ret, dir;
+	bool retry = true;
+	struct scmi_vqueue *s = data;
+
+	kvm__set_thread_name(s->name);
+
+	/*
+	 * An eventfd is used by notify_vq to kick the thread when something
+	 * is received from the Guest vqueues.
+	 */
+	s->pfds[SCMI_FD_GUEST_VQUEUE].fd = s->efd;
+	s->pfds[SCMI_FD_GUEST_VQUEUE].events = POLLIN;
+
+	do {
+		bool alive;
+
+		pr_debug("VQ%d:: Establishing Host connection @%s\n",
+			 s->idx, s->sockname);
+		ret = virtio_scmi_initialize_host_connection(s);
+		if (ret) {
+			pr_err("VQ%d:: Host unreachable.\n", s->idx);
+			return NULL;
+		}
+
+		alive = true;
+		while (alive) {
+			int r;
+
+			r = poll(s->pfds, SCMI_FD_MAX, -1);
+			if (r < 0) {
+				pr_err("Polling failed on %s worker.\n",
+				       s->name);
+				retry = false;
+				break;
+			}
+
+			for (dir = 0; dir < SCMI_FD_MAX; dir++) {
+				if (s->pfds[dir].revents & (POLLERR | POLLHUP)) {
+					alive = false;
+					/* Give up if guest connection is lost */
+					if (dir == SCMI_FD_GUEST_VQUEUE)
+						retry = false;
+					pr_debug("VQ%d:: %s connection lost suddendly !\n",
+						 s->idx,
+						 dir == SCMI_FD_GUEST_VQUEUE ? "Guest" : "Host");
+					break;
+				} else if (s->pfds[dir].revents & POLLIN) {
+					if (dir == SCMI_FD_GUEST_VQUEUE)
+						scmi_do_traffic_from_guest(s);
+					else
+						scmi_do_traffic_from_host(s);
+				}
+			}
+		}
+		close(s->sfd);
+	} while (retry);
+
+	return NULL;
+}
+
+static void scmi_vqueue_messages_init(struct scmi_vqueue *s)
+{
+	int i;
+
+	for (i = 0; i < VIRTIO_SCMI_QUEUE_SZ; i++) {
+		struct scmi_vqueue_msg *msg = &s->msg[i];
+
+		msg->s = s;
+		msg->iovs[IOV_DESC_IDX].iov_base = &msg->head;
+		msg->iovs[IOV_DESC_IDX].iov_len = sizeof(msg->head);
+	}
+}
+
+/**
+ * VirtIO SCMI Device defines two possible virtqueues:
+ *
+ * - cmdq - VIRTIO_SCMI_VQ_TX:
+ * This vqueue receives guest-initiated commands requests, which are relayed to
+ * the emulated SCMI server by the "virtio-scmi-cmdq" worker thread: SCMI
+ * synchronous command replies to such requests, coming back from the same
+ * emulation layer, are sent back to the guest using this very same vqueue and
+ * a dedicated response buffer used for reception.
+ *
+ * - eventq - VIRTIO_SCMI_VQ_RX:
+ * This vqueue is reserved to send host-initiated SCMI DelayedResponses and
+ * Notifications to the guest. It is preloaded with all available messages by
+ * SCMI VirtIO guest frontend at startup.
+ * It is handled by the dedicated "virtio-scmi-eventq" worker thread.
+ */
+static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 page_size, u32 align,
+		   u32 pfn)
+{
+	struct scmi_dev *sdev = dev;
+	struct scmi_vqueue *s;
+	void *p;
+
+	if (WARN_ON(vq >= sdev->supported_vqs))
+		return -EINVAL;
+
+	s = &sdev->s[vq];
+	s->q.pfn = pfn;
+	p = virtio_get_vq(kvm, s->q.pfn, page_size);
+	s->set_size = s->set_size ?: VIRTIO_SCMI_QUEUE_SZ;
+	vring_init(&s->q.vring, s->set_size, p, align);
+
+	s->idx = vq;
+	if (s->idx == VIRTIO_SCMI_VQ_TX) {
+		s->name = "virtio-scmi-cmdq";
+		s->sockname = kvm->cfg.arch.scmi_cmdq ?: SCMI_DEFAULT_CMDQ_SOCK;
+	} else {
+		s->name = "virtio-scmi-eventq";
+		s->sockname = kvm->cfg.arch.scmi_evtq ?: SCMI_DEFAULT_EVTQ_SOCK;
+	}
+	s->sdev = sdev;
+	INIT_LIST_HEAD(&s->free_mesg);
+	mutex_init(&s->mtx);
+	scmi_vqueue_messages_init(s);
+
+	/* An eventfd used to ping the worker thread when guest kicks */
+	s->efd = eventfd(0, EFD_NONBLOCK);
+	if (s->efd < 0)
+		return -errno;
+
+	if (pthread_create(&s->worker, NULL, virtio_scmi_traffic_thread, s)) {
+		pr_err("VQ%d thread creation failed.\n", vq);
+		close(s->efd);
+		return -errno;
+	}
+
+	/* Enable vdev at last once all is setup */
+	virtio_init_device_vq(&sdev->vdev, &s->q);
+	pr_debug("VQ%d traffic thread spawned.\n", vq);
+
+	return 0;
+}
+
+static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	struct scmi_dev *sdev = dev;
+
+	pr_debug("Exit VQ%d\n", vq);
+
+	if (WARN_ON(vq >= sdev->supported_vqs))
+		return;
+
+	/* Terminate worker threads at first */
+	pthread_cancel(sdev->s[vq].worker);
+	pthread_join(sdev->s[vq].worker, NULL);
+	close(sdev->s[vq].efd);
+	close(sdev->s[vq].sfd);
+}
+
+static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	int r;
+	struct scmi_dev *sdev = dev;
+	u64 data = 1;
+
+	/* Kick threads */
+	r = write(sdev->s[vq].efd, &data, sizeof(data));
+	if (r < 0)
+		return r;
+
+	return 0;
+}
+
+static struct virt_queue *get_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	struct scmi_dev *sdev = dev;
+
+	if (WARN_ON(vq >= sdev->supported_vqs))
+		return NULL;
+
+	return &sdev->s[vq].q;
+}
+
+static int get_size_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	struct scmi_dev *sdev = dev;
+
+	if (WARN_ON(vq >= sdev->supported_vqs))
+		return -EINVAL;
+
+	return sdev->s[vq].set_size ?: VIRTIO_SCMI_QUEUE_SZ;
+}
+
+static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
+{
+	struct scmi_dev *sdev = dev;
+
+	if (WARN_ON(vq >= sdev->supported_vqs || size > VIRTIO_SCMI_QUEUE_SZ))
+		return -EINVAL;
+
+	sdev->s[vq].set_size = size;
+
+	return 0;
+}
+
+static int get_vq_count(struct kvm *kvm, void *dev)
+{
+	struct scmi_dev *sdev = dev;
+
+	return sdev->supported_vqs;
+}
+
+static struct virtio_ops scmi_dev_virtio_ops = {
+	.get_host_features	= get_host_features,
+	.set_guest_features	= set_guest_features,
+	.get_vq_count		= get_vq_count,
+	.init_vq		= init_vq,
+	.exit_vq		= exit_vq,
+	.notify_status		= notify_status,
+	.notify_vq		= notify_vq,
+	.get_vq			= get_vq,
+	.get_size_vq		= get_size_vq,
+	.set_size_vq		= set_size_vq,
+};
+
+static void scmi_parse_custom_protocols(const char *protos)
+{
+	char *buf = NULL, *cur = NULL;
+
+	buf = strdup(protos);
+	if (!buf)
+		die("Failed to allocate virtio memory buffer");
+
+	cur = strtok(buf, ",");
+	while (cur) {
+		unsigned long val;
+
+		val = strtoul(cur, NULL, 0);
+		if (val < SCMI_PROTOCOL_FIRST || val > SCMI_PROTOCOL_MAX) {
+			pr_warning("Ignoring malformed protos string: %s", cur);
+			break;
+		}
+		set_bit((int)val, scmi_protos);
+		cur = strtok(NULL, ",");
+	}
+	free(buf);
+}
+
+int virtio_scmi__init(struct kvm *kvm)
+{
+	int r;
+
+	if (!kvm->cfg.arch.scmi)
+		return 0;
+
+	scmi_dev.supported_vqs = !kvm->cfg.arch.scmi_no_p2a ? 2 : 1;
+	scmi_dev.kvm = kvm;
+
+	/* Fill known standard protocols */
+	for (r = SCMI_PROTOCOL_FIRST; r < SCMI_PROTOCOL_LAST; r++)
+		set_bit(r, scmi_protos);
+	/* Add any additional user configured protocol */
+	if (kvm->cfg.arch.scmi_custom_protos)
+		scmi_parse_custom_protocols(kvm->cfg.arch.scmi_custom_protos);
+
+	r = virtio_init(kvm, &scmi_dev, &scmi_dev.vdev, &scmi_dev_virtio_ops,
+			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_SCMI,
+			VIRTIO_ID_SCMI, PCI_CLASS_SCMI);
+
+	return r;
+}
+virtio_dev_init(virtio_scmi__init);
+
+int virtio_scmi__exit(struct kvm *kvm)
+{
+	return 0;
+}
+virtio_dev_exit(virtio_scmi__exit);
-- 
2.17.1

