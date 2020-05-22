Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318411DDFEA
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 08:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgEVGby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 02:31:54 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:20749 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbgEVGby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 02:31:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590129112; x=1621665112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Eh/w7fDQ/t+3heysDB45hgJsudaZbKHb1B4FFyT3Zhg=;
  b=shbGxIFeEEdvFzbC2n/0HyzNsqdfzc1a2DGOrTy0tS2Qca4RYh7HV5+8
   Df5555fppNjrGYVODsVxnDMuStnVJ71dQZhumBK5mma9ZC3mhzsgni0Gj
   DK6kkWNJfPuzer9tcpNcsMCC1Fn7tQOxRlF7YSO0irF2s5hqw7+M1+XmC
   A=;
IronPort-SDR: 8aunz0jmc81HQlFOfh6ASnGvzm/UCtnhSZ+HPYIBkRCPrXfwF4ENwawF0TtCILGUfBCI8RJcqL
 atSYFoKHsypA==
X-IronPort-AV: E=Sophos;i="5.73,420,1583193600"; 
   d="scan'208";a="31775489"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 May 2020 06:31:51 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 8AABA284788;
        Fri, 22 May 2020 06:31:49 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:31:49 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 06:31:40 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Martin Pohlack" <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v2 11/18] nitro_enclaves: Add logic for enclave memory region set
Date:   Fri, 22 May 2020 09:29:39 +0300
Message-ID: <20200522062946.28973-12-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200522062946.28973-1-andraprs@amazon.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D27UWA001.ant.amazon.com (10.43.160.19) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Another resource that is being set for an enclave is memory. User space
memory regions, that need to be backed by contiguous memory regions,
are associated with the enclave.

One solution for allocating / reserving contiguous memory regions, that
is used for integration, is hugetlbfs. The user space process that is
associated with the enclave passes to the driver these memory regions.

Add ioctl command logic for setting user space memory region for an
enclave.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 256 ++++++++++++++++++++++
 1 file changed, 256 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 936c9ce19213..a5c6185613b9 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -240,6 +240,234 @@ static int ne_create_vcpu_ioctl(struct ne_enclave *ne_enclave, u32 vcpu_id)
 	return rc;
 }
 
+/**
+ * ne_sanity_check_user_mem_region - Sanity check the userspace memory
+ * region received during the set user memory region ioctl call.
+ *
+ * This function gets called with the ne_enclave mutex held.
+ *
+ * @ne_enclave: private data associated with the current enclave.
+ * @mem_region: user space memory region to be sanity checked.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_sanity_check_user_mem_region(struct ne_enclave *ne_enclave,
+	struct kvm_userspace_memory_region *mem_region)
+{
+	if (WARN_ON(!ne_enclave))
+		return -EINVAL;
+
+	if (!mem_region)
+		return -EINVAL;
+
+	if ((mem_region->memory_size % MIN_MEM_REGION_SIZE) != 0) {
+		pr_err_ratelimited(NE "Mem size not multiple of 2 MiB\n");
+
+		return -EINVAL;
+	}
+
+	if ((mem_region->userspace_addr & (MIN_MEM_REGION_SIZE - 1)) ||
+	    !access_ok((void __user *)(unsigned long)mem_region->userspace_addr,
+		       mem_region->memory_size)) {
+		pr_err_ratelimited(NE "Invalid user space addr range\n");
+
+		return -EINVAL;
+	}
+
+	if ((mem_region->guest_phys_addr + mem_region->memory_size) <
+	    mem_region->guest_phys_addr) {
+		pr_err_ratelimited(NE "Invalid guest phys addr range\n");
+
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * ne_set_user_memory_region_ioctl - Add user space memory region to the slot
+ * associated with the current enclave.
+ *
+ * This function gets called with the ne_enclave mutex held.
+ *
+ * @ne_enclave: private data associated with the current enclave.
+ * @mem_region: user space memory region to be associated with the given slot.
+ *
+ * @returns: 0 on success, negative return value on failure.
+ */
+static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
+	struct kvm_userspace_memory_region *mem_region)
+{
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	long gup_rc = 0;
+	unsigned long i = 0;
+	struct ne_mem_region *ne_mem_region = NULL;
+	unsigned long nr_phys_contig_mem_regions = 0;
+	unsigned long nr_pinned_pages = 0;
+	struct page **phys_contig_mem_regions = NULL;
+	int rc = -EINVAL;
+	struct slot_add_mem_req slot_add_mem_req = {};
+
+	if (WARN_ON(!ne_enclave) || WARN_ON(!ne_enclave->pdev))
+		return -EINVAL;
+
+	if (!mem_region)
+		return -EINVAL;
+
+	if (ne_enclave->mm != current->mm)
+		return -EIO;
+
+	rc = ne_sanity_check_user_mem_region(ne_enclave, mem_region);
+	if (rc < 0)
+		return rc;
+
+	ne_mem_region = kzalloc(sizeof(*ne_mem_region), GFP_KERNEL);
+	if (!ne_mem_region)
+		return -ENOMEM;
+
+	/*
+	 * TODO: Update nr_pages value to handle contiguous virtual address
+	 * ranges mapped to non-contiguous physical regions. Hugetlbfs can give
+	 * 2 MiB / 1 GiB contiguous physical regions.
+	 */
+	ne_mem_region->nr_pages = mem_region->memory_size / MIN_MEM_REGION_SIZE;
+
+	ne_mem_region->pages = kcalloc(ne_mem_region->nr_pages,
+				       sizeof(*ne_mem_region->pages),
+				       GFP_KERNEL);
+	if (!ne_mem_region->pages) {
+		kzfree(ne_mem_region);
+
+		return -ENOMEM;
+	}
+
+	phys_contig_mem_regions = kcalloc(ne_mem_region->nr_pages,
+					  sizeof(*phys_contig_mem_regions),
+					  GFP_KERNEL);
+	if (!phys_contig_mem_regions) {
+		kzfree(ne_mem_region->pages);
+		kzfree(ne_mem_region);
+
+		return -ENOMEM;
+	}
+
+	/*
+	 * TODO: Handle non-contiguous memory regions received from user space.
+	 * Hugetlbfs can give 2 MiB / 1 GiB contiguous physical regions. The
+	 * virtual address space can be seen as contiguous, although it is
+	 * mapped underneath to 2 MiB / 1 GiB physical regions e.g. 8 MiB
+	 * virtual address space mapped to 4 physically contiguous regions of 2
+	 * MiB.
+	 */
+	do {
+		unsigned long tmp_nr_pages = ne_mem_region->nr_pages -
+			nr_pinned_pages;
+		struct page **tmp_pages = ne_mem_region->pages +
+			nr_pinned_pages;
+		u64 tmp_userspace_addr = mem_region->userspace_addr +
+			nr_pinned_pages * MIN_MEM_REGION_SIZE;
+
+		gup_rc = get_user_pages(tmp_userspace_addr, tmp_nr_pages,
+					FOLL_GET, tmp_pages, NULL);
+		if (gup_rc < 0) {
+			rc = gup_rc;
+
+			pr_err_ratelimited(NE "Error in gup [rc=%d]\n", rc);
+
+			unpin_user_pages(ne_mem_region->pages, nr_pinned_pages);
+
+			goto free_mem_region;
+		}
+
+		nr_pinned_pages += gup_rc;
+
+	} while (nr_pinned_pages < ne_mem_region->nr_pages);
+
+	/*
+	 * TODO: Update checks once physically contiguous regions are collected
+	 * based on the user space address and get_user_pages() results.
+	 */
+	for (i = 0; i < ne_mem_region->nr_pages; i++) {
+		if (!PageHuge(ne_mem_region->pages[i])) {
+			pr_err_ratelimited(NE "Not a hugetlbfs page\n");
+
+			goto unpin_pages;
+		}
+
+		if (huge_page_size(page_hstate(ne_mem_region->pages[i])) !=
+		    MIN_MEM_REGION_SIZE) {
+			pr_err_ratelimited(NE "The page size isn't 2 MiB\n");
+
+			goto unpin_pages;
+		}
+
+		/*
+		 * TODO: Update once handled non-contiguous memory regions
+		 * received from user space.
+		 */
+		phys_contig_mem_regions[i] = ne_mem_region->pages[i];
+	}
+
+	/*
+	 * TODO: Update once handled non-contiguous memory regions received
+	 * from user space.
+	 */
+	nr_phys_contig_mem_regions = ne_mem_region->nr_pages;
+
+	if ((ne_enclave->nr_mem_regions + nr_phys_contig_mem_regions) >
+	    ne_enclave->max_mem_regions) {
+		pr_err_ratelimited(NE "Reached max memory regions %lld\n",
+				   ne_enclave->max_mem_regions);
+
+		goto unpin_pages;
+	}
+
+	for (i = 0; i < nr_phys_contig_mem_regions; i++) {
+		u64 phys_addr = page_to_phys(phys_contig_mem_regions[i]);
+
+		slot_add_mem_req.slot_uid = ne_enclave->slot_uid;
+		slot_add_mem_req.paddr = phys_addr;
+		/*
+		 * TODO: Update memory size of physical contiguous memory
+		 * region, in case of non-contiguous memory regions received
+		 * from user space.
+		 */
+		slot_add_mem_req.size = MIN_MEM_REGION_SIZE;
+
+		rc = ne_do_request(ne_enclave->pdev, SLOT_ADD_MEM,
+				   &slot_add_mem_req, sizeof(slot_add_mem_req),
+				   &cmd_reply, sizeof(cmd_reply));
+		if (rc < 0) {
+			pr_err_ratelimited(NE "Error in slot add mem [rc=%d]\n",
+					   rc);
+
+			/* TODO: Only unpin memory regions not added. */
+			goto unpin_pages;
+		}
+
+		ne_enclave->nr_mem_regions++;
+
+		memset(&slot_add_mem_req, 0, sizeof(slot_add_mem_req));
+		memset(&cmd_reply, 0, sizeof(cmd_reply));
+	}
+
+	list_add(&ne_mem_region->mem_region_list_entry,
+		 &ne_enclave->mem_regions_list);
+
+	kzfree(phys_contig_mem_regions);
+
+	return 0;
+
+unpin_pages:
+	unpin_user_pages(ne_mem_region->pages, ne_mem_region->nr_pages);
+free_mem_region:
+	kzfree(phys_contig_mem_regions);
+	kzfree(ne_mem_region->pages);
+	kzfree(ne_mem_region);
+
+	return rc;
+}
+
 static int ne_enclave_open(struct inode *node, struct file *file)
 {
 	return 0;
@@ -319,6 +547,34 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
 		return 0;
 	}
 
+	case KVM_SET_USER_MEMORY_REGION: {
+		struct kvm_userspace_memory_region mem_region = {};
+		int rc = -EINVAL;
+
+		if (copy_from_user(&mem_region, (void *)arg,
+				   sizeof(mem_region))) {
+			pr_err_ratelimited(NE "Error in copy from user\n");
+
+			return -EFAULT;
+		}
+
+		mutex_lock(&ne_enclave->enclave_info_mutex);
+
+		if (ne_enclave->state != NE_STATE_INIT) {
+			pr_err_ratelimited(NE "Enclave isn't in init state\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -EINVAL;
+		}
+
+		rc = ne_set_user_memory_region_ioctl(ne_enclave, &mem_region);
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		return rc;
+	}
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

