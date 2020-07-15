Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F888221553
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 21:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgGOTqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 15:46:24 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:52582 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgGOTqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 15:46:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594842382; x=1626378382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ISqy6L6ND3ZKlEgvbrSe2KYtqSvPHvFuWxdqmaME2T8=;
  b=U9UNksuM46NrewXkr0XAEib0PiF/+3lfZj77/0co17KqxJ/9evAnhtA0
   Y801mAwTEA8bRoU2GHoz0dXzboMx3vthM5cduxOAfWR6E57cRT8lwdeXn
   OBxKEJLTOgM//bKcbsjHLSfKc4JTaiUPKkxOCcyPJbxpRlaGEJ5CE0bJW
   M=;
IronPort-SDR: BanSBBgrP0slXu05xw1qDT/obpiqX4oPamdTU1x9/N5pQRjgpCiYhWjTjolMCT36BOZg+Bcp5K
 25SMn0FXQUyA==
X-IronPort-AV: E=Sophos;i="5.75,356,1589241600"; 
   d="scan'208";a="51929243"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 15 Jul 2020 19:46:19 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 12280A28BB;
        Wed, 15 Jul 2020 19:46:18 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:46:17 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.214) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:46:07 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
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
        Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Alexander Graf <graf@amazon.com>
Subject: [PATCH v5 02/18] nitro_enclaves: Define the PCI device interface
Date:   Wed, 15 Jul 2020 22:45:24 +0300
Message-ID: <20200715194540.45532-3-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200715194540.45532-1-andraprs@amazon.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.214]
X-ClientProxiedBy: EX13D46UWB002.ant.amazon.com (10.43.161.70) To
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
 drivers/virt/nitro_enclaves/ne_pci_dev.h | 265 +++++++++++++++++++++++
 1 file changed, 265 insertions(+)
 create mode 100644 drivers/virt/nitro_enclaves/ne_pci_dev.h

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
new file mode 100644
index 000000000000..a3a3fab7a04a
--- /dev/null
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -0,0 +1,265 @@
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
+/* Nitro Enclaves (NE) PCI device identifier */
+
+#define PCI_DEVICE_ID_NE (0xe4c1)
+#define PCI_BAR_NE (0x03)
+
+/* Device registers */
+
+/**
+ * (1 byte) Register to notify the device that the driver is using it
+ * (Read/Write).
+ */
+#define NE_ENABLE (0x0000)
+#define NE_ENABLE_OFF (0x00)
+#define NE_ENABLE_ON (0x01)
+
+/* (2 bytes) Register to select the device run-time version (Read/Write). */
+#define NE_VERSION (0x0002)
+#define NE_VERSION_MAX (0x0001)
+
+/**
+ * (4 bytes) Register to notify the device what command was requested
+ * (Write-Only).
+ */
+#define NE_COMMAND (0x0004)
+
+/**
+ * (4 bytes) Register to notify the driver that a reply or a device event
+ * is available (Read-Only):
+ * - Lower half  - command reply counter
+ * - Higher half - out-of-band device event counter
+ */
+#define NE_EVTCNT (0x000c)
+#define NE_EVTCNT_REPLY_SHIFT (0)
+#define NE_EVTCNT_REPLY_MASK (0x0000ffff)
+#define NE_EVTCNT_REPLY(cnt) (((cnt) & NE_EVTCNT_REPLY_MASK) >> \
+			      NE_EVTCNT_REPLY_SHIFT)
+#define NE_EVTCNT_EVENT_SHIFT (16)
+#define NE_EVTCNT_EVENT_MASK (0xffff0000)
+#define NE_EVTCNT_EVENT(cnt) (((cnt) & NE_EVTCNT_EVENT_MASK) >> \
+			      NE_EVTCNT_EVENT_SHIFT)
+
+/* (240 bytes) Buffer for sending the command request payload (Read/Write). */
+#define NE_SEND_DATA (0x0010)
+
+/* (240 bytes) Buffer for receiving the command reply payload (Read-Only). */
+#define NE_RECV_DATA (0x0100)
+
+/* Device MMIO buffer sizes */
+
+/* 240 bytes for send / recv buffer. */
+#define NE_SEND_DATA_SIZE (240)
+#define NE_RECV_DATA_SIZE (240)
+
+/* MSI-X interrupt vectors */
+
+/* MSI-X vector used for command reply notification. */
+#define NE_VEC_REPLY (0)
+
+/* MSI-X vector used for out-of-band events e.g. enclave crash. */
+#define NE_VEC_EVENT (1)
+
+/* Device command types. */
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
+/* Device commands - payload structure for requests and replies. */
+
+struct enclave_start_req {
+	/* Slot unique id mapped to the enclave to start. */
+	u64 slot_uid;
+
+	/**
+	 * Context ID (CID) for the enclave vsock device.
+	 * If 0, CID is autogenerated.
+	 */
+	u64 enclave_cid;
+
+	/* Flags for the enclave to start with (e.g. debug mode). */
+	u64 flags;
+};
+
+struct enclave_get_slot_req {
+	/* Context ID (CID) for the enclave vsock device. */
+	u64 enclave_cid;
+};
+
+struct enclave_stop_req {
+	/* Slot unique id mapped to the enclave to stop. */
+	u64 slot_uid;
+};
+
+struct slot_alloc_req {
+	/* In order to avoid weird sizeof edge cases. */
+	u8 unused;
+};
+
+struct slot_free_req {
+	/* Slot unique id mapped to the slot to free. */
+	u64 slot_uid;
+};
+
+/* TODO: Add flags field to the request to add memory region. */
+struct slot_add_mem_req {
+	/* Slot unique id mapped to the slot to add the memory region to. */
+	u64 slot_uid;
+
+	/* Physical address of the memory region to add to the slot. */
+	u64 paddr;
+
+	/* Memory size, in bytes, of the memory region to add to the slot. */
+	u64 size;
+};
+
+struct slot_add_vcpu_req {
+	/* Slot unique id mapped to the slot to add the vCPU to. */
+	u64 slot_uid;
+
+	/* vCPU ID of the CPU to add to the enclave. */
+	u32 vcpu_id;
+
+	u8 padding[4];
+};
+
+struct slot_count_req {
+	/* In order to avoid weird sizeof edge cases. */
+	u8 unused;
+};
+
+struct next_slot_req {
+	/* Slot unique id of the next slot in the iteration. */
+	u64 slot_uid;
+};
+
+struct slot_info_req {
+	/* Slot unique id mapped to the slot to get information about. */
+	u64 slot_uid;
+};
+
+struct slot_add_bulk_vcpus_req {
+	/* Slot unique id mapped to the slot to add vCPUs to. */
+	u64 slot_uid;
+
+	/* Number of vCPUs to add to the slot. */
+	u64 nr_vcpus;
+};
+
+struct ne_pci_dev_cmd_reply {
+	/* Return code of the functionality that processed the request. */
+	s32 rc;
+
+	u8 padding0[4];
+
+	/* Valid for all commands except SLOT_COUNT. */
+	u64 slot_uid;
+
+	/* Valid for ENCLAVE_START command. */
+	u64 enclave_cid;
+
+	/* Valid for SLOT_COUNT command. */
+	u64 slot_count;
+
+	/* Valid for SLOT_ALLOC and SLOT_INFO commands. */
+	u64 mem_regions;
+
+	/* Valid for SLOT_INFO command. */
+	u64 mem_size;
+
+	/* Valid for SLOT_INFO command. */
+	u64 nr_vcpus;
+
+	/* Valid for SLOT_INFO command. */
+	u64 flags;
+
+	/* Valid for SLOT_INFO command. */
+	u16 state;
+
+	u8 padding1[6];
+};
+
+/* Nitro Enclaves (NE) PCI device. */
+struct ne_pci_dev {
+	/* Variable set if a reply has been sent by the PCI device. */
+	atomic_t cmd_reply_avail;
+
+	/* Wait queue for handling command reply from the PCI device. */
+	wait_queue_head_t cmd_reply_wait_q;
+
+	/* List of the enclaves managed by the PCI device. */
+	struct list_head enclaves_list;
+
+	/* Mutex for accessing the list of enclaves. */
+	struct mutex enclaves_list_mutex;
+
+	/**
+	 * Work queue for handling out-of-band events triggered by the Nitro
+	 * Hypervisor which require enclave state scanning and propagation to
+	 * the enclave process.
+	 */
+	struct workqueue_struct *event_wq;
+
+	/* MMIO region of the PCI device. */
+	void __iomem *iomem_base;
+
+	/* Work item for every received out-of-band event. */
+	struct work_struct notify_work;
+
+	/* Mutex for accessing the PCI device MMIO space. */
+	struct mutex pci_dev_mutex;
+
+	/* PCI device data structure. */
+	struct pci_dev *pdev;
+};
+
+/**
+ * ne_do_request - Submit command request to the PCI device based on the command
+ * type and retrieve the associated reply.
+ *
+ * This function uses the ne_pci_dev mutex to handle one command at a time.
+ *
+ * @pdev: PCI device to send the command to and receive the reply from.
+ * @cmd_type: command type of the request sent to the PCI device.
+ * @cmd_request: command request payload.
+ * @cmd_request_size: size of the command request payload.
+ * @cmd_reply: command reply payload.
+ * @cmd_reply_size: size of the command reply payload.
+ *
+ * @returns: 0 on success, negative return value on failure.
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

