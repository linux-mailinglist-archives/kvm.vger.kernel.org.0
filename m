Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A1B1B2F63
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbgDUSnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:43:42 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:40638 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729542AbgDUSnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587494620; x=1619030620;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iD6hK6n6rAHjJ0UFqEld6zc7icpNZCFSfqUcIfc6BKo=;
  b=rnaNfQAcXNYBAJ5dfSJVVVntDsLokBEEy1Q8NEBPDqhhCxli4d1kjBzD
   gHkCiPR8jd38E9nITd3c8jpbYE9T+WhfKos+wFEu7nGSp6y1j8OteQHKk
   qrf6jaNVG+QSmfGBNjc/TTg+bhvacilCLA+5LEJHWZe0ktIyARLyGLYVH
   g=;
IronPort-SDR: AU4ETh7LHYmR+zEG/Q4H1XhmDw2ir1b3ozvvWnRHSZtg7sB37NkyzlzfvpE1H/LOjR13+g3FzC
 +cvjKAbAppKA==
X-IronPort-AV: E=Sophos;i="5.72,411,1580774400"; 
   d="scan'208";a="26702307"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 21 Apr 2020 18:43:39 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id EEF19A2392;
        Tue, 21 Apr 2020 18:43:37 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:43:37 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.217) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:43:28 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v1 10/15] nitro_enclaves: Add logic for enclave memory region set
Date:   Tue, 21 Apr 2020 21:41:45 +0300
Message-ID: <20200421184150.68011-11-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200421184150.68011-1-andraprs@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.217]
X-ClientProxiedBy: EX13D17UWC002.ant.amazon.com (10.43.162.61) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Another resource that is being set for an enclave is memory. User space
memory regions, that needs to be backed by contiguous memory regions,
are associated with the enclave.

One solution for allocating / reserving contiguous memory regions, that
is used for integration, is hugetlbfs. The user space process that is
associated with the enclave passes to the driver these memory regions.

Add ioctl command logic for setting user space memory region for an
enclave.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
 .../virt/amazon/nitro_enclaves/ne_misc_dev.c  | 242 ++++++++++++++++++
 1 file changed, 242 insertions(+)

diff --git a/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c b/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
index c9acdfd63daf..0bd283f73a87 100644
--- a/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
@@ -233,6 +233,228 @@ static int ne_create_vcpu_ioctl(struct ne_enclave *ne_enclave, u32 vcpu_id)
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
+	BUG_ON(!ne_enclave);
+
+	if (WARN_ON(!mem_region))
+		return -EINVAL;
+
+	if (mem_region->slot > ne_enclave->max_mem_regions) {
+		pr_err_ratelimited("Mem slot higher than max mem regions\n");
+
+		return -EINVAL;
+	}
+
+	if ((mem_region->memory_size % MIN_MEM_REGION_SIZE) != 0) {
+		pr_err_ratelimited("Mem region size not multiple of 2 MiB\n");
+
+		return -EINVAL;
+	}
+
+	if ((mem_region->userspace_addr & (MIN_MEM_REGION_SIZE - 1)) ||
+	    !access_ok((void __user *)(unsigned long)mem_region->userspace_addr,
+		       mem_region->memory_size)) {
+		pr_err_ratelimited("Invalid user space addr range\n");
+
+		return -EINVAL;
+	}
+
+	if ((mem_region->guest_phys_addr + mem_region->memory_size) <
+	    mem_region->guest_phys_addr) {
+		pr_err_ratelimited("Invalid guest phys addr range\n");
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
+	BUG_ON(!ne_enclave);
+	BUG_ON(!ne_enclave->pdev);
+
+	if (WARN_ON(!mem_region))
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
+			pr_err_ratelimited("Failure in gup [rc=%d]\n", rc);
+
+			unpin_user_pages(ne_mem_region->pages, nr_pinned_pages);
+
+			goto err_get_user_pages;
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
+			pr_err_ratelimited("The page isn't a hugetlbfs page\n");
+
+			goto err_phys_pages_check;
+		}
+
+		if (huge_page_size(page_hstate(ne_mem_region->pages[i])) !=
+		    MIN_MEM_REGION_SIZE) {
+			pr_err_ratelimited("The page size isn't 2 MiB\n");
+
+			goto err_phys_pages_check;
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
+			pr_err_ratelimited("Failure in slot add mem [rc=%d]\n",
+					   rc);
+
+			goto err_slot_add_mem;
+		}
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
+err_slot_add_mem:
+err_phys_pages_check:
+	unpin_user_pages(ne_mem_region->pages, ne_mem_region->nr_pages);
+err_get_user_pages:
+	kzfree(phys_contig_mem_regions);
+	kzfree(ne_mem_region->pages);
+	kzfree(ne_mem_region);
+	return rc;
+}
+
 static int ne_enclave_open(struct inode *node, struct file *file)
 {
 	return 0;
@@ -279,6 +501,26 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
 		return rc;
 	}
 
+	case KVM_SET_USER_MEMORY_REGION: {
+		struct kvm_userspace_memory_region mem_region = {};
+		int rc = -EINVAL;
+
+		if (copy_from_user(&mem_region, (void *)arg,
+				   sizeof(mem_region))) {
+			pr_err_ratelimited("Failure in copy from user\n");
+
+			return -EFAULT;
+		}
+
+		mutex_lock(&ne_enclave->enclave_info_mutex);
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

