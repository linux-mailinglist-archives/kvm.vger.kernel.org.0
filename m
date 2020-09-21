Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529882723B0
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 14:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgIUMUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 08:20:20 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:27965 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgIUMUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 08:20:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600690819; x=1632226819;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ogJSBGusQnN1GW7X8QV9mGHvJwccmegYQ7HYkN1KaYw=;
  b=b5SYT5na2qL8H2RA26Oo+x67/h3+i00kR5O1SxNWJbwPjFaCQqFCI1i+
   nhAjn1AGXPLXDqwR9fH3BftayfCtnl2PwelpsRsuKRETTBJyK2CgNwThb
   pRTDKSuK2DixvUG8VvvTXugPY4Q/7hNyBXs7irue0sRDb7WqPzNMjN7GK
   Y=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="77922095"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 21 Sep 2020 12:20:16 +0000
Received: from EX13D16EUB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 529562822C2;
        Mon, 21 Sep 2020 12:20:14 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.71) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 12:20:03 +0000
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
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v10 12/18] nitro_enclaves: Add logic for starting an enclave
Date:   Mon, 21 Sep 2020 15:17:26 +0300
Message-ID: <20200921121732.44291-13-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200921121732.44291-1-andraprs@amazon.com>
References: <20200921121732.44291-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.71]
X-ClientProxiedBy: EX13D06UWC001.ant.amazon.com (10.43.162.91) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After all the enclave resources are set, the enclave is ready for
beginning to run.

Add ioctl command logic for starting an enclave after all its resources,
memory regions and CPUs, have been set.

The enclave start information includes the local channel addressing -
vsock CID - and the flags associated with the enclave.

Changelog

v9 -> v10

* Update commit message to include the changelog before the SoB tag(s).

v8 -> v9

* Use the ne_devs data structure to get the refs for the NE PCI device.

v7 -> v8

* Add check for invalid enclave CID value e.g. well-known CIDs and
  parent VM CID.
* Add custom error code for incorrect flag in enclave start info and
  invalid enclave CID.

v6 -> v7

* Update the naming and add more comments to make more clear the logic
  of handling full CPU cores and dedicating them to the enclave.

v5 -> v6

* Check for invalid enclave start flags.
* Update documentation to kernel-doc format.

v4 -> v5

* Add early exit on enclave start ioctl function call error.
* Move sanity checks in the enclave start ioctl function, outside of the
  switch-case block.
* Remove log on copy_from_user() / copy_to_user() failure.

v3 -> v4

* Use dev_err instead of custom NE log pattern.
* Update the naming for the ioctl command from metadata to info.
* Check for minimum enclave memory size.

v2 -> v3

* Remove the WARN_ON calls.
* Update static calls sanity checks.

v1 -> v2

* Add log pattern for NE.
* Check if enclave state is init when starting an enclave.
* Remove the BUG_ON calls.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 157 ++++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index f2252f67302c..dd4752b99ece 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1002,6 +1002,79 @@ static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
 	return rc;
 }
 
+/**
+ * ne_start_enclave_ioctl() - Trigger enclave start after the enclave resources,
+ *			      such as memory and CPU, have been set.
+ * @ne_enclave :		Private data associated with the current enclave.
+ * @enclave_start_info :	Enclave info that includes enclave cid and flags.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_start_enclave_ioctl(struct ne_enclave *ne_enclave,
+	struct ne_enclave_start_info *enclave_start_info)
+{
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	unsigned int cpu = 0;
+	struct enclave_start_req enclave_start_req = {};
+	unsigned int i = 0;
+	struct pci_dev *pdev = ne_devs.ne_pci_dev->pdev;
+	int rc = -EINVAL;
+
+	if (!ne_enclave->nr_mem_regions) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Enclave has no mem regions\n");
+
+		return -NE_ERR_NO_MEM_REGIONS_ADDED;
+	}
+
+	if (ne_enclave->mem_size < NE_MIN_ENCLAVE_MEM_SIZE) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Enclave memory is less than %ld\n",
+				    NE_MIN_ENCLAVE_MEM_SIZE);
+
+		return -NE_ERR_ENCLAVE_MEM_MIN_SIZE;
+	}
+
+	if (!ne_enclave->nr_vcpus) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Enclave has no vCPUs\n");
+
+		return -NE_ERR_NO_VCPUS_ADDED;
+	}
+
+	for (i = 0; i < ne_enclave->nr_parent_vm_cores; i++)
+		for_each_cpu(cpu, ne_enclave->threads_per_core[i])
+			if (!cpumask_test_cpu(cpu, ne_enclave->vcpu_ids)) {
+				dev_err_ratelimited(ne_misc_dev.this_device,
+						    "Full CPU cores not used\n");
+
+				return -NE_ERR_FULL_CORES_NOT_USED;
+			}
+
+	enclave_start_req.enclave_cid = enclave_start_info->enclave_cid;
+	enclave_start_req.flags = enclave_start_info->flags;
+	enclave_start_req.slot_uid = ne_enclave->slot_uid;
+
+	rc = ne_do_request(pdev, ENCLAVE_START,
+			   &enclave_start_req, sizeof(enclave_start_req),
+			   &cmd_reply, sizeof(cmd_reply));
+	if (rc < 0) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Error in enclave start [rc=%d]\n", rc);
+
+		return rc;
+	}
+
+	ne_enclave->state = NE_STATE_RUNNING;
+
+	enclave_start_info->enclave_cid = cmd_reply.enclave_cid;
+
+	return 0;
+}
+
 /**
  * ne_enclave_ioctl() - Ioctl function provided by the enclave file.
  * @file:	File associated with this ioctl function.
@@ -1160,6 +1233,90 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd, unsigned long
 		return 0;
 	}
 
+	case NE_START_ENCLAVE: {
+		struct ne_enclave_start_info enclave_start_info = {};
+		int rc = -EINVAL;
+
+		if (copy_from_user(&enclave_start_info, (void __user *)arg,
+				   sizeof(enclave_start_info)))
+			return -EFAULT;
+
+		if (enclave_start_info.flags >= NE_ENCLAVE_START_MAX_FLAG_VAL) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Incorrect flag in enclave start info\n");
+
+			return -NE_ERR_INVALID_FLAG_VALUE;
+		}
+
+		/*
+		 * Do not use well-known CIDs - 0, 1, 2 - for enclaves.
+		 * VMADDR_CID_ANY = -1U
+		 * VMADDR_CID_HYPERVISOR = 0
+		 * VMADDR_CID_LOCAL = 1
+		 * VMADDR_CID_HOST = 2
+		 * Note: 0 is used as a placeholder to auto-generate an enclave CID.
+		 * http://man7.org/linux/man-pages/man7/vsock.7.html
+		 */
+		if (enclave_start_info.enclave_cid > 0 &&
+		    enclave_start_info.enclave_cid <= VMADDR_CID_HOST) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Well-known CID value, not to be used for enclaves\n");
+
+			return -NE_ERR_INVALID_ENCLAVE_CID;
+		}
+
+		if (enclave_start_info.enclave_cid == U32_MAX) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Well-known CID value, not to be used for enclaves\n");
+
+			return -NE_ERR_INVALID_ENCLAVE_CID;
+		}
+
+		/*
+		 * Do not use the CID of the primary / parent VM for enclaves.
+		 */
+		if (enclave_start_info.enclave_cid == NE_PARENT_VM_CID) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "CID of the parent VM, not to be used for enclaves\n");
+
+			return -NE_ERR_INVALID_ENCLAVE_CID;
+		}
+
+		/* 64-bit CIDs are not yet supported for the vsock device. */
+		if (enclave_start_info.enclave_cid > U32_MAX) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "64-bit CIDs not yet supported for the vsock device\n");
+
+			return -NE_ERR_INVALID_ENCLAVE_CID;
+		}
+
+		mutex_lock(&ne_enclave->enclave_info_mutex);
+
+		if (ne_enclave->state != NE_STATE_INIT) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Enclave is not in init state\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -NE_ERR_NOT_IN_INIT_STATE;
+		}
+
+		rc = ne_start_enclave_ioctl(ne_enclave, &enclave_start_info);
+		if (rc < 0) {
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return rc;
+		}
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		if (copy_to_user((void __user *)arg, &enclave_start_info,
+				 sizeof(enclave_start_info)))
+			return -EFAULT;
+
+		return 0;
+	}
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

