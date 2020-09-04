Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A8125E0FB
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 19:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgIDRiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 13:38:08 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:49872 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbgIDRiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 13:38:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599241078; x=1630777078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r/ToL4pElbxPdyhMOFoiLdoIDOKKVPpemQExiSHgjig=;
  b=PZi4nwkF9KDXfKR3q+2F4oekcwQTvq81mqv/il8vPt+ekUiJCD7dWX35
   tCWyst7ztlJH5YCBztUI9z4i6VdsQJFHmRk9HO80e20rRyBV1kA+Dmn/G
   uBVXK7G0qMRwQWlmyyCVK4QS19bP9FSUHvcm8GE5p4Od23FO8tFx8YHhm
   o=;
X-IronPort-AV: E=Sophos;i="5.76,390,1592870400"; 
   d="scan'208";a="52178803"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 04 Sep 2020 17:37:57 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 1879DA0629;
        Fri,  4 Sep 2020 17:37:54 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.85) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Sep 2020 17:37:45 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "David Duncan" <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Karen Noel" <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v8 02/18] nitro_enclaves: Define the PCI device interface
Date:   Fri, 4 Sep 2020 20:37:02 +0300
Message-ID: <20200904173718.64857-3-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200904173718.64857-1-andraprs@amazon.com>
References: <20200904173718.64857-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D13UWB001.ant.amazon.com (10.43.161.156) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Nitro Enclaves (NE) driver communicates with a new PCI device, that
is exposed to a virtual machine (VM) and handles commands meant for
handling enclaves lifetime e.g. creation, termination, setting memory
regions. The communication with the PCI device is handled using a MMIO
space and MSI-X interrupts.

This device communicates with the hypervisor on the host, where the VM
that spawned the enclave itself runs, e.g. to launch a VM that is used
for the enclave.

Define the MMIO space of the NE PCI device, the commands that are
provided by this device. Add an internal data structure used as private
data for the PCI device driver and the function for the PCI device
command requests handling.

Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
Signed-off-by: Alexandru Ciobotaru <alcioa@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
Changelog

v7 -> v8

* No changes.

v6 -> v7

* Update the documentation to include references to the NE PCI device id
  and MMIO bar.

v5 -> v6

* Update documentation to kernel-doc format.

v4 -> v5

* Add a TODO for including flags in the request to the NE PCI device to
  set a memory region for an enclave. It is not used for now.

v3 -> v4

* Remove the "packed" attribute and include padding in the NE data
  structures.

v2 -> v3

* Remove the GPL additional wording as SPDX-License-Identifier is
  already in place.

v1 -> v2

* Update path naming to drivers/virt/nitro_enclaves.
* Update NE_ENABLE_OFF / NE_ENABLE_ON defines.
---
 drivers/virt/nitro_enclaves/ne_pci_dev.h | 327 +++++++++++++++++++++++
 1 file changed, 327 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/ne_pci_dev.h

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
new file mode 100644
index 000000000000..336fa344d630
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -0,0 +1,327 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ */
+
+#ifndef _NE_PCI_DEV_H_
+#define _NE_PCI_DEV_H_
+
+#include <linux/atomic.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/wait.h>
+
+/**
+ * DOC: Nitro Enclaves (NE) PCI device
+ */
+
+/**
+ * PCI_DEVICE_ID_NE - Nitro Enclaves PCI device id.
+ */
+#define PCI_DEVICE_ID_NE	(0xe4c1)
+/**
+ * PCI_BAR_NE - Nitro Enclaves PCI device MMIO BAR.
+ */
+#define PCI_BAR_NE		(0x03)
+
+/**
+ * DOC: Device registers in the NE PCI device MMIO BAR
+ */
+
+/**
+ * NE_ENABLE - (1 byte) Register to notify the device that the driver is using
+ *	       it (Read/Write).
+ */
+#define NE_ENABLE		(0x0000)
+#define NE_ENABLE_OFF		(0x00)
+#define NE_ENABLE_ON		(0x01)
+
+/**
+ * NE_VERSION - (2 bytes) Register to select the device run-time version
+ *		(Read/Write).
+ */
+#define NE_VERSION		(0x0002)
+#define NE_VERSION_MAX		(0x0001)
+
+/**
+ * NE_COMMAND - (4 bytes) Register to notify the device what command was
+ *		requested (Write-Only).
+ */
+#define NE_COMMAND		(0x0004)
+
+/**
+ * NE_EVTCNT - (4 bytes) Register to notify the driver that a reply or a device
+ *	       event is available (Read-Only):
+ *	       - Lower half  - command reply counter
+ *	       - Higher half - out-of-band device event counter
+ */
+#define NE_EVTCNT		(0x000c)
+#define NE_EVTCNT_REPLY_SHIFT	(0)
+#define NE_EVTCNT_REPLY_MASK	(0x0000ffff)
+#define NE_EVTCNT_REPLY(cnt)	(((cnt) & NE_EVTCNT_REPLY_MASK) >> \
+				NE_EVTCNT_REPLY_SHIFT)
+#define NE_EVTCNT_EVENT_SHIFT	(16)
+#define NE_EVTCNT_EVENT_MASK	(0xffff0000)
+#define NE_EVTCNT_EVENT(cnt)	(((cnt) & NE_EVTCNT_EVENT_MASK) >> \
+				NE_EVTCNT_EVENT_SHIFT)
+
+/**
+ * NE_SEND_DATA - (240 bytes) Buffer for sending the command request payload
+ *		  (Read/Write).
+ */
+#define NE_SEND_DATA		(0x0010)
+
+/**
+ * NE_RECV_DATA - (240 bytes) Buffer for receiving the command reply payload
+ *		  (Read-Only).
+ */
+#define NE_RECV_DATA		(0x0100)
+
+/**
+ * DOC: Device MMIO buffer sizes
+ */
+
+/**
+ * NE_SEND_DATA_SIZE / NE_RECV_DATA_SIZE - 240 bytes for send / recv buffer.
+ */
+#define NE_SEND_DATA_SIZE	(240)
+#define NE_RECV_DATA_SIZE	(240)
+
+/**
+ * DOC: MSI-X interrupt vectors
+ */
+
+/**
+ * NE_VEC_REPLY - MSI-X vector used for command reply notification.
+ */
+#define NE_VEC_REPLY		(0)
+
+/**
+ * NE_VEC_EVENT - MSI-X vector used for out-of-band events e.g. enclave crash.
+ */
+#define NE_VEC_EVENT		(1)
+
+/**
+ * enum ne_pci_dev_cmd_type - Device command types.
+ * @INVALID_CMD:		Invalid command.
+ * @ENCLAVE_START:		Start an enclave, after setting its resources.
+ * @ENCLAVE_GET_SLOT:		Get the slot uid of an enclave.
+ * @ENCLAVE_STOP:		Terminate an enclave.
+ * @SLOT_ALLOC :		Allocate a slot for an enclave.
+ * @SLOT_FREE:			Free the slot allocated for an enclave
+ * @SLOT_ADD_MEM:		Add a memory region to an enclave slot.
+ * @SLOT_ADD_VCPU:		Add a vCPU to an enclave slot.
+ * @SLOT_COUNT :		Get the number of allocated slots.
+ * @NEXT_SLOT:			Get the next slot in the list of allocated slots.
+ * @SLOT_INFO:			Get the info for a slot e.g. slot uid, vCPUs count.
+ * @SLOT_ADD_BULK_VCPUS:	Add a number of vCPUs, not providing CPU ids.
+ * @MAX_CMD:			A gatekeeper for max possible command type.
+ */
+enum ne_pci_dev_cmd_type {
+	INVALID_CMD = 0,
+	ENCLAVE_START = 1,
+	ENCLAVE_GET_SLOT = 2,
+	ENCLAVE_STOP = 3,
+	SLOT_ALLOC = 4,
+	SLOT_FREE = 5,
+	SLOT_ADD_MEM = 6,
+	SLOT_ADD_VCPU = 7,
+	SLOT_COUNT = 8,
+	NEXT_SLOT = 9,
+	SLOT_INFO = 10,
+	SLOT_ADD_BULK_VCPUS = 11,
+	MAX_CMD,
+};
+
+/**
+ * DOC: Device commands - payload structure for requests and replies.
+ */
+
+/**
+ * struct enclave_start_req - ENCLAVE_START request.
+ * @slot_uid:		Slot unique id mapped to the enclave to start.
+ * @enclave_cid:	Context ID (CID) for the enclave vsock device.
+ *			If 0, CID is autogenerated.
+ * @flags:		Flags for the enclave to start with (e.g. debug mode).
+ */
+struct enclave_start_req {
+	u64	slot_uid;
+	u64	enclave_cid;
+	u64	flags;
+};
+
+/**
+ * struct enclave_get_slot_req - ENCLAVE_GET_SLOT request.
+ * @enclave_cid:	Context ID (CID) for the enclave vsock device.
+ */
+struct enclave_get_slot_req {
+	u64	enclave_cid;
+};
+
+/**
+ * struct enclave_stop_req - ENCLAVE_STOP request.
+ * @slot_uid:	Slot unique id mapped to the enclave to stop.
+ */
+struct enclave_stop_req {
+	u64	slot_uid;
+};
+
+/**
+ * struct slot_alloc_req - SLOT_ALLOC request.
+ * @unused:	In order to avoid weird sizeof edge cases.
+ */
+struct slot_alloc_req {
+	u8	unused;
+};
+
+/**
+ * struct slot_free_req - SLOT_FREE request.
+ * @slot_uid:	Slot unique id mapped to the slot to free.
+ */
+struct slot_free_req {
+	u64	slot_uid;
+};
+
+/* TODO: Add flags field to the request to add memory region. */
+/**
+ * struct slot_add_mem_req - SLOT_ADD_MEM request.
+ * @slot_uid:	Slot unique id mapped to the slot to add the memory region to.
+ * @paddr:	Physical address of the memory region to add to the slot.
+ * @size:	Memory size, in bytes, of the memory region to add to the slot.
+ */
+struct slot_add_mem_req {
+	u64	slot_uid;
+	u64	paddr;
+	u64	size;
+};
+
+/**
+ * struct slot_add_vcpu_req - SLOT_ADD_VCPU request.
+ * @slot_uid:	Slot unique id mapped to the slot to add the vCPU to.
+ * @vcpu_id:	vCPU ID of the CPU to add to the enclave.
+ * @padding:	Padding for the overall data structure.
+ */
+struct slot_add_vcpu_req {
+	u64	slot_uid;
+	u32	vcpu_id;
+	u8	padding[4];
+};
+
+/**
+ * struct slot_count_req - SLOT_COUNT request.
+ * @unused:	In order to avoid weird sizeof edge cases.
+ */
+struct slot_count_req {
+	u8	unused;
+};
+
+/**
+ * struct next_slot_req - NEXT_SLOT request.
+ * @slot_uid:	Slot unique id of the next slot in the iteration.
+ */
+struct next_slot_req {
+	u64	slot_uid;
+};
+
+/**
+ * struct slot_info_req - SLOT_INFO request.
+ * @slot_uid:	Slot unique id mapped to the slot to get information about.
+ */
+struct slot_info_req {
+	u64	slot_uid;
+};
+
+/**
+ * struct slot_add_bulk_vcpus_req - SLOT_ADD_BULK_VCPUS request.
+ * @slot_uid:	Slot unique id mapped to the slot to add vCPUs to.
+ * @nr_vcpus:	Number of vCPUs to add to the slot.
+ */
+struct slot_add_bulk_vcpus_req {
+	u64	slot_uid;
+	u64	nr_vcpus;
+};
+
+/**
+ * struct ne_pci_dev_cmd_reply - NE PCI device command reply.
+ * @rc :		Return code of the logic that processed the request.
+ * @padding0:		Padding for the overall data structure.
+ * @slot_uid:		Valid for all commands except SLOT_COUNT.
+ * @enclave_cid:	Valid for ENCLAVE_START command.
+ * @slot_count :	Valid for SLOT_COUNT command.
+ * @mem_regions:	Valid for SLOT_ALLOC and SLOT_INFO commands.
+ * @mem_size:		Valid for SLOT_INFO command.
+ * @nr_vcpus:		Valid for SLOT_INFO command.
+ * @flags:		Valid for SLOT_INFO command.
+ * @state:		Valid for SLOT_INFO command.
+ * @padding1:		Padding for the overall data structure.
+ */
+struct ne_pci_dev_cmd_reply {
+	s32	rc;
+	u8	padding0[4];
+	u64	slot_uid;
+	u64	enclave_cid;
+	u64	slot_count;
+	u64	mem_regions;
+	u64	mem_size;
+	u64	nr_vcpus;
+	u64	flags;
+	u16	state;
+	u8	padding1[6];
+};
+
+/**
+ * struct ne_pci_dev - Nitro Enclaves (NE) PCI device.
+ * @cmd_reply_avail:		Variable set if a reply has been sent by the
+ *				PCI device.
+ * @cmd_reply_wait_q:		Wait queue for handling command reply from the
+ *				PCI device.
+ * @enclaves_list:		List of the enclaves managed by the PCI device.
+ * @enclaves_list_mutex:	Mutex for accessing the list of enclaves.
+ * @event_wq:			Work queue for handling out-of-band events
+ *				triggered by the Nitro Hypervisor which require
+ *				enclave state scanning and propagation to the
+ *				enclave process.
+ * @iomem_base :		MMIO region of the PCI device.
+ * @notify_work:		Work item for every received out-of-band event.
+ * @pci_dev_mutex:		Mutex for accessing the PCI device MMIO space.
+ * @pdev:			PCI device data structure.
+ */
+struct ne_pci_dev {
+	atomic_t		cmd_reply_avail;
+	wait_queue_head_t	cmd_reply_wait_q;
+	struct list_head	enclaves_list;
+	struct mutex		enclaves_list_mutex;
+	struct workqueue_struct	*event_wq;
+	void __iomem		*iomem_base;
+	struct work_struct	notify_work;
+	struct mutex		pci_dev_mutex;
+	struct pci_dev		*pdev;
+};
+
+/**
+ * ne_do_request() - Submit command request to the PCI device based on the command
+ *		     type and retrieve the associated reply.
+ * @pdev:		PCI device to send the command to and receive the reply from.
+ * @cmd_type:		Command type of the request sent to the PCI device.
+ * @cmd_request:	Command request payload.
+ * @cmd_request_size:	Size of the command request payload.
+ * @cmd_reply:		Command reply payload.
+ * @cmd_reply_size:	Size of the command reply payload.
+ *
+ * Context: Process context. This function uses the ne_pci_dev mutex to handle
+ *	    one command at a time.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+int ne_do_request(struct pci_dev *pdev, enum ne_pci_dev_cmd_type cmd_type,
+		  void *cmd_request, size_t cmd_request_size,
+		  struct ne_pci_dev_cmd_reply *cmd_reply,
+		  size_t cmd_reply_size);
+
+/* Nitro Enclaves (NE) PCI device driver */
+extern struct pci_driver ne_pci_driver;
+
+#endif /* _NE_PCI_DEV_H_ */
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

