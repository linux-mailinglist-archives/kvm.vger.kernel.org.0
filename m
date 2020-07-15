Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59005221555
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 21:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgGOTq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 15:46:29 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:5318 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgGOTqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 15:46:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594842381; x=1626378381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GEI2urm980GaJ1XePmpk1eAHnLHBFeD7rFchtFKK6p8=;
  b=aNMRHLA2i0mGrIbXhz/2ZbpPVZtLsZzl0gSI08eyJRrKLbn9lG96q6qf
   6yVIqfL6SAWA/ixsfscZrf35tS2sTYm7b5OfbGO4wmGlUpL/nvJMrl2s8
   r4XhpRD1DaEG/+nsrPoyYGDW7UaLzXO9J3EwGqzWjEGBWEdkX6KYfP8BH
   Q=;
IronPort-SDR: wZIrdnLWtDtUCvAM7uwiSjajSUPqBzvq2BL/tWkcy59ikKiH+5Para3rHFhzdmIBM9xQBdfPDl
 LR4iRcDxPf+A==
X-IronPort-AV: E=Sophos;i="5.75,356,1589241600"; 
   d="scan'208";a="43560239"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 15 Jul 2020 19:46:18 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 581CCA180C;
        Wed, 15 Jul 2020 19:46:17 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:46:16 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.214) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 19:45:56 +0000
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
Subject: [PATCH v5 01/18] nitro_enclaves: Add ioctl interface definition
Date:   Wed, 15 Jul 2020 22:45:23 +0300
Message-ID: <20200715194540.45532-2-andraprs@amazon.com>
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

The Nitro Enclaves driver handles the enclave lifetime management. This
includes enclave creation, termination and setting up its resources such
as memory and CPU.

An enclave runs alongside the VM that spawned it. It is abstracted as a
process running in the VM that launched it. The process interacts with
the NE driver, that exposes an ioctl interface for creating an enclave
and setting up its resources.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
Changelog

v4 -> v5

* Add more details about the ioctl calls usage e.g. error codes, file
  descriptors used.
* Update the ioctl to set an enclave vCPU to not return a file
  descriptor.
* Add specific NE error codes.

v3 -> v4

* Decouple NE ioctl interface from KVM API.
* Add NE API version and the corresponding ioctl call.
* Add enclave / image load flags options.

v2 -> v3

* Remove the GPL additional wording as SPDX-License-Identifier is
  already in place.

v1 -> v2

* Add ioctl for getting enclave image load metadata.
* Update NE_ENCLAVE_START ioctl name to NE_START_ENCLAVE.
* Add entry in Documentation/userspace-api/ioctl/ioctl-number.rst for NE
  ioctls.
* Update NE ioctls definition based on the updated ioctl range for major
  and minor.
---
 .../userspace-api/ioctl/ioctl-number.rst      |   5 +-
 include/linux/nitro_enclaves.h                |  11 +
 include/uapi/linux/nitro_enclaves.h           | 244 ++++++++++++++++++
 3 files changed, 259 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/nitro_enclaves.h
 create mode 100644 include/uapi/linux/nitro_enclaves.h

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 59472cd6a11d..783440c6719b 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -328,8 +328,11 @@ Code  Seq#    Include File                                           Comments
 0xAC  00-1F  linux/raw.h
 0xAD  00                                                             Netfilter device in development:
                                                                      <mailto:rusty@rustcorp.com.au>
-0xAE  all    linux/kvm.h                                             Kernel-based Virtual Machine
+0xAE  00-1F  linux/kvm.h                                             Kernel-based Virtual Machine
                                                                      <mailto:kvm@vger.kernel.org>
+0xAE  40-FF  linux/kvm.h                                             Kernel-based Virtual Machine
+                                                                     <mailto:kvm@vger.kernel.org>
+0xAE  20-3F  linux/nitro_enclaves.h                                  Nitro Enclaves
 0xAF  00-1F  linux/fsl_hypervisor.h                                  Freescale hypervisor
 0xB0  all                                                            RATIO devices in development:
                                                                      <mailto:vgo@ratio.de>
diff --git a/include/linux/nitro_enclaves.h b/include/linux/nitro_enclaves.h
new file mode 100644
index 000000000000..d91ef2bfdf47
--- /dev/null
+++ b/include/linux/nitro_enclaves.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ */
+
+#ifndef _LINUX_NITRO_ENCLAVES_H_
+#define _LINUX_NITRO_ENCLAVES_H_
+
+#include <uapi/linux/nitro_enclaves.h>
+
+#endif /* _LINUX_NITRO_ENCLAVES_H_ */
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
new file mode 100644
index 000000000000..cf1192f6e923
--- /dev/null
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -0,0 +1,244 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ */
+
+#ifndef _UAPI_LINUX_NITRO_ENCLAVES_H_
+#define _UAPI_LINUX_NITRO_ENCLAVES_H_
+
+#include <linux/types.h>
+
+/* Nitro Enclaves (NE) Kernel Driver Interface */
+
+#define NE_API_VERSION (1)
+
+/**
+ * The command is used to get the version of the NE API. This way the user space
+ * processes can be aware of the feature sets provided by the NE kernel driver.
+ *
+ * The NE API version is returned as result of this ioctl call.
+ *
+ * The ioctl can be invoked on the /dev/nitro_enclaves fd, independent of
+ * enclaves already created / started or not.
+ *
+ * No errors are returned.
+ */
+#define NE_GET_API_VERSION _IO(0xAE, 0x20)
+
+/**
+ * The command is used to create a slot that is associated with an enclave VM.
+ * Memory and vCPUs are then set for the slot mapped to an enclave.
+ *
+ * The generated unique slot id is an output parameter. An enclave file
+ * descriptor is returned as result of this ioctl call. The enclave fd can be
+ * further used with ioctl calls to set vCPUs and memory regions, then start
+ * the enclave.
+ *
+ * The ioctl can be invoked on the /dev/nitro_enclaves fd, before setting any
+ * resources, such as memory and vCPUs, for an enclave.
+ *
+ * A NE CPU pool has be set before calling this function. The pool can be set
+ * after the NE driver load, using /sys/module/nitro_enclaves/parameters/ne_cpus.
+ * Its format is the following:
+ * https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html#cpu-lists
+ *
+ * CPU 0 and its siblings have to remain available for the primary / parent VM,
+ * so they cannot be set for enclaves. Full CPU core(s), from the same NUMA
+ * node, need(s) be included in the CPU pool.
+ *
+ * The returned errors are:
+ * * -EFAULT - copy_to_user() failure.
+ * * -ENOMEM - memory allocation failure for internal bookkeeping variables.
+ * * -NE_ERR_NO_CPUS_AVAIL_IN_POOL - no NE CPU pool set / no CPUs available in the pool.
+ * * Error codes from get_unused_fd_flags() and anon_inode_getfile().
+ * * Error codes from the NE PCI device request.
+ */
+#define NE_CREATE_VM _IOR(0xAE, 0x21, __u64)
+
+/**
+ * The command is used to set a vCPU for an enclave. The vCPU can be auto-chosen
+ * from the NE CPU pool or it can be set by the caller, with the note that it
+ * needs to be available in the NE CPU pool. Full CPU core(s), from the same
+ * NUMA node, need(s) to be associated with an enclave.
+ *
+ * The vCPU id is an input / output parameter. If its value is 0, then a CPU is
+ * chosen from the enclave CPU pool and returned via this parameter.
+ *
+ * The ioctl can be invoked on the enclave fd, before an enclave is started.
+ *
+ * The returned errors are:
+ * * -EFAULT - copy_from_user() / copy_to_user() failure.
+ * * -ENOMEM - memory allocation failure for internal bookkeeping variables.
+ * * -EIO - current task mm is not the same as the one that created the enclave.
+ * * -NE_ERR_NO_CPUS_AVAIL_IN_POOL - no CPUs available in the NE CPU pool.
+ * * -NE_ERR_VCPU_ALREADY_USED - the provided vCPU is already used.
+ * * -NE_ERR_VCPU_NOT_IN_POOL - the provided vCPU is not available in the NE CPU pool.
+ * * -NE_ERR_INVALID_CPU_CORE - the core id of the provided vCPU is invalid / out of range.
+ * * -NE_ERR_NOT_IN_INIT_STATE - the enclave is not in init state (init = before being started).
+ * * -NE_ERR_INVALID_VCPU - the provided vCPU is out the available CPUs range.
+ * * Error codes from the NE PCI device request.
+ */
+#define NE_ADD_VCPU _IOWR(0xAE, 0x22, __u32)
+
+/**
+ * The command is used to get information needed for in-memory enclave image
+ * loading e.g. offset in enclave memory to start placing the enclave image.
+ *
+ * The image load info is an input / output parameter. It includes info provided
+ * by the caller - flags - and returns the offset in enclave memory where to
+ * start placing the enclave image.
+ *
+ * The ioctl can be invoked on the enclave fd, before an enclave is started.
+ *
+ * The returned errors are:
+ * * -EFAULT - copy_from_user() / copy_to_user() failure.
+ * * -NE_ERR_NOT_IN_INIT_STATE - the enclave is not in init state (init = before being started).
+ */
+#define NE_GET_IMAGE_LOAD_INFO _IOWR(0xAE, 0x23, struct ne_image_load_info)
+
+/**
+ * The command is used to set a memory region for an enclave, given the
+ * allocated memory from the userspace. Enclave memory needs to be from the
+ * same NUMA node as the enclave CPUs.
+ *
+ * The user memory region is an input parameter. It includes info provided
+ * by the caller - flags, memory size and userspace address.
+ *
+ * The ioctl can be invoked on the enclave fd, before an enclave is started.
+ *
+ * The returned errors are:
+ * * -EFAULT - copy_from_user() failure.
+ * * -ENOMEM - memory allocation failure for internal bookkeeping variables.
+ * * -EIO - current task mm is not the same as the one that created the enclave.
+ * * -NE_ERR_NOT_IN_INIT_STATE - the enclave is not in init state (init = before being started).
+ * * -NE_ERR_INVALID_MEM_REGION_SIZE - the memory size of the region is not multiple of 2 MiB.
+ * * -NE_ERR_INVALID_MEM_REGION_ADDR - invalid user space address given.
+ * * -NE_ERR_UNALIGNED_MEM_REGION_ADDR - unaligned user space address given.
+ * * -NE_ERR_MEM_NOT_HUGE_PAGE - the memory regions is not backed by huge pages.
+ * * -NE_ERR_MEM_DIFF_NUMA_NODE - the memory region is not from the same NUMA node as the CPUs.
+ * * -NE_ERR_MEM_MAX_REGIONS - the number of memory regions set for the enclave reached maximum.
+ * * Error codes from get_user_pages().
+ * * Error codes from the NE PCI device request.
+ */
+#define NE_SET_USER_MEMORY_REGION _IOW(0xAE, 0x24, struct ne_user_memory_region)
+
+/**
+ * The command is used to trigger enclave start after the enclave resources,
+ * such as memory and CPU, have been set.
+ *
+ * The enclave start info is an input / output parameter. It includes info
+ * provided by the caller - enclave cid and flags - and returns the cid (if
+ * input cid is 0).
+ *
+ * The ioctl can be invoked on the enclave fd, after an enclave slot is created
+ * and resources, such as memory and vCPUs are set for an enclave.
+ *
+ * The returned errors are:
+ * * -EFAULT - copy_from_user() / copy_to_user() failure.
+ * * -NE_ERR_NOT_IN_INIT_STATE - the enclave is not in init state (init = before being started).
+ * * -NE_ERR_NO_MEM_REGIONS_ADDED / -NE_ERR_NO_VCPUS_ADDED - no CPUs / memory regions are set.
+ * * -NE_ERR_FULL_CORES_NOT_USED - full core(s) not set for the enclave.
+ * * -NE_ERR_ENCLAVE_MEM_MIN_SIZE - enclave memory is less than minimum memory size (64 MiB).
+ * * Error codes from the NE PCI device request.
+ */
+#define NE_START_ENCLAVE _IOWR(0xAE, 0x25, struct ne_enclave_start_info)
+
+/* NE specific error codes */
+
+/* The provided vCPU is already used. */
+#define NE_ERR_VCPU_ALREADY_USED (512)
+/* The provided vCPU is not available in the NE CPU pool. */
+#define NE_ERR_VCPU_NOT_IN_POOL (513)
+/* The core id of the provided vCPU is invalid / out of range of the NE CPU pool. */
+#define NE_ERR_INVALID_CPU_CORE (514)
+/* The user space memory region size is not multiple of 2 MiB. */
+#define NE_ERR_INVALID_MEM_REGION_SIZE (515)
+/* The user space memory region address range is invalid. */
+#define NE_ERR_INVALID_MEM_REGION_ADDR (516)
+/* The user space memory region address is not aligned. */
+#define NE_ERR_UNALIGNED_MEM_REGION_ADDR (517)
+/* The user space memory region is not backed by contiguous physical huge page(s). */
+#define NE_ERR_MEM_NOT_HUGE_PAGE (518)
+/* The user space memory region is backed by pages from different NUMA nodes than the CPUs. */
+#define NE_ERR_MEM_DIFF_NUMA_NODE (519)
+/* The supported max memory regions per enclaves has been reached. */
+#define NE_ERR_MEM_MAX_REGIONS (520)
+/* The command to start an enclave is triggered and no memory regions are added. */
+#define NE_ERR_NO_MEM_REGIONS_ADDED (521)
+/* The command to start an enclave is triggered and no vcpus are added. */
+#define NE_ERR_NO_VCPUS_ADDED (522)
+/* The enclave memory size is lower than the minimum supported. */
+#define NE_ERR_ENCLAVE_MEM_MIN_SIZE (523)
+/* The command to start an enclave is triggered and full CPU cores are not set. */
+#define NE_ERR_FULL_CORES_NOT_USED (524)
+/* The enclave is not in init state when setting resources or triggering start. */
+#define NE_ERR_NOT_IN_INIT_STATE (525)
+/* The provided vCPU is out of range of the available CPUs. */
+#define NE_ERR_INVALID_VCPU (526)
+/* The command to create an enclave is triggered and no CPUs are available in the pool. */
+#define NE_ERR_NO_CPUS_AVAIL_IN_POOL (527)
+
+/* Image load info flags */
+
+/* Enclave Image Format (EIF) */
+#define NE_EIF_IMAGE (0x01)
+
+/* Info necessary for in-memory enclave image loading (in / out). */
+struct ne_image_load_info {
+	/**
+	 * Flags to determine the enclave image type (e.g. Enclave Image Format
+	 * - EIF) (in).
+	 */
+	__u64 flags;
+
+	/**
+	 * Offset in enclave memory where to start placing the enclave image
+	 * (out).
+	 */
+	__u64 memory_offset;
+};
+
+/* User memory region flags */
+
+/* Memory region for enclave general usage. */
+#define NE_DEFAULT_MEMORY_REGION (0x00)
+
+/* Memory region to be set for an enclave (in). */
+struct ne_user_memory_region {
+	/**
+	 * Flags to determine the usage for the memory region (in).
+	 */
+	__u64 flags;
+
+	/**
+	 * The size, in bytes, of the memory region to be set for an enclave
+	 * (in).
+	 */
+	__u64 memory_size;
+
+	/**
+	 * The start of the userspace allocated memory of the memory region to
+	 * set for an enclave (in).
+	 */
+	__u64 userspace_addr;
+};
+
+/* Enclave start info flags */
+
+/* Start enclave in debug mode. */
+#define NE_ENCLAVE_DEBUG_MODE (0x01)
+
+/* Setup info necessary for enclave start (in / out). */
+struct ne_enclave_start_info {
+	/* Flags for the enclave to start with (e.g. debug mode) (in). */
+	__u64 flags;
+
+	/**
+	 * Context ID (CID) for the enclave vsock device. If 0 as input, the
+	 * CID is autogenerated by the hypervisor and returned back as output
+	 * by the driver (in / out).
+	 */
+	__u64 enclave_cid;
+};
+
+#endif /* _UAPI_LINUX_NITRO_ENCLAVES_H_ */
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

