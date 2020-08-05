Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2914C23C8D9
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 11:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgHEJNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 05:13:34 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:17102 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbgHEJMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 05:12:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596618750; x=1628154750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NUSLJ/LscJTjt7Uvmx0YHo3mWKI+9w+utRXYOcw7kdU=;
  b=HLyjHkqHjmjkE+m5rluHkZvooxcNC6fE1vQyRLZeD0bi+S5Ut3Pkh+Tt
   Co+rH7RzJeBI9OaiT3+9DuogzLzjKvYHJPlzeJn2z1r1H4nCQSo5socsO
   bst7iXjoPLA+3t1Ir6N0J2aHkgpav39jXKFsV5TQ4tsjDqP8HZR/cEoxi
   A=;
IronPort-SDR: aKMdfv/dZVZXMKPkkL6teu30Dve91A3Kl5Lj6F+G4Q+uIloCNugg7yOFQ7b4yyE+R/i4TbW0Dx
 t2xxKPthFa0w==
X-IronPort-AV: E=Sophos;i="5.75,436,1589241600"; 
   d="scan'208";a="57530936"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 05 Aug 2020 09:12:30 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 663AD2217B3;
        Wed,  5 Aug 2020 09:12:29 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:12:28 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.248) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 Aug 2020 09:12:18 +0000
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
Subject: [PATCH v6 11/18] nitro_enclaves: Add logic for setting an enclave memory region
Date:   Wed, 5 Aug 2020 12:10:10 +0300
Message-ID: <20200805091017.86203-12-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200805091017.86203-1-andraprs@amazon.com>
References: <20200805091017.86203-1-andraprs@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.248]
X-ClientProxiedBy: EX13D37UWA003.ant.amazon.com (10.43.160.25) To
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

The enclave memory regions need to be from the same NUMA node as the
enclave CPUs.

Add ioctl command logic for setting user space memory region for an
enclave.

Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
---
Changelog

v5 -> v6

* Check for max number of pages allocated for the internal data
  structure for pages.
* Check for invalid memory region flags.
* Check for aligned physical memory regions.
* Update documentation to kernel-doc format.
* Check for duplicate user space memory regions.
* Use directly put_page() instead of unpin_user_pages(), to match the
  get_user_pages() calls.

v4 -> v5

* Add early exit on set memory region ioctl function call error.
* Remove log on copy_from_user() failure.
* Exit without unpinning the pages on NE PCI dev request failure as
  memory regions from the user space range may have already been added.
* Add check for the memory region user space address to be 2 MiB
  aligned.
* Update logic to not have a hardcoded check for 2 MiB memory regions.

v3 -> v4

* Check enclave memory regions are from the same NUMA node as the
  enclave CPUs.
* Use dev_err instead of custom NE log pattern.
* Update the NE ioctl call to match the decoupling from the KVM API.

v2 -> v3

* Remove the WARN_ON calls.
* Update static calls sanity checks.
* Update kzfree() calls to kfree().

v1 -> v2

* Add log pattern for NE.
* Update goto labels to match their purpose.
* Remove the BUG_ON calls.
* Check if enclave max memory regions is reached when setting an enclave
  memory region.
* Check if enclave state is init when setting an enclave memory region.
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 285 ++++++++++++++++++++++
 1 file changed, 285 insertions(+)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 850e5e0ce0e9..88536a415246 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -568,6 +568,258 @@ static int ne_add_vcpu_ioctl(struct ne_enclave *ne_enclave, u32 vcpu_id)
 	return 0;
 }
 
+/**
+ * ne_sanity_check_user_mem_region() - Sanity check the user space memory
+ *				       region received during the set user
+ *				       memory region ioctl call.
+ * @ne_enclave :	Private data associated with the current enclave.
+ * @mem_region :	User space memory region to be sanity checked.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_sanity_check_user_mem_region(struct ne_enclave *ne_enclave,
+	struct ne_user_memory_region mem_region)
+{
+	struct ne_mem_region *ne_mem_region = NULL;
+
+	if (ne_enclave->mm != current->mm)
+		return -EIO;
+
+	if (mem_region.memory_size & (NE_MIN_MEM_REGION_SIZE - 1)) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "User space memory size is not multiple of 2 MiB\n");
+
+		return -NE_ERR_INVALID_MEM_REGION_SIZE;
+	}
+
+	if (!IS_ALIGNED(mem_region.userspace_addr, NE_MIN_MEM_REGION_SIZE)) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "User space address is not 2 MiB aligned\n");
+
+		return -NE_ERR_UNALIGNED_MEM_REGION_ADDR;
+	}
+
+	if ((mem_region.userspace_addr & (NE_MIN_MEM_REGION_SIZE - 1)) ||
+	    !access_ok((void __user *)(unsigned long)mem_region.userspace_addr,
+		       mem_region.memory_size)) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Invalid user space address range\n");
+
+		return -NE_ERR_INVALID_MEM_REGION_ADDR;
+	}
+
+	list_for_each_entry(ne_mem_region, &ne_enclave->mem_regions_list,
+			    mem_region_list_entry) {
+		u64 memory_size = ne_mem_region->memory_size;
+		u64 userspace_addr = ne_mem_region->userspace_addr;
+
+		if (userspace_addr <= mem_region.userspace_addr &&
+		    mem_region.userspace_addr < (userspace_addr + memory_size)) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "User space memory region already used\n");
+
+			return -NE_ERR_MEM_REGION_ALREADY_USED;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ne_set_user_memory_region_ioctl() - Add user space memory region to the slot
+ *				       associated with the current enclave.
+ * @ne_enclave :	Private data associated with the current enclave.
+ * @mem_region :	User space memory region to be associated with the given slot.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
+	struct ne_user_memory_region mem_region)
+{
+	long gup_rc = 0;
+	unsigned long i = 0;
+	unsigned long max_nr_pages = 0;
+	unsigned long memory_size = 0;
+	struct ne_mem_region *ne_mem_region = NULL;
+	unsigned long nr_phys_contig_mem_regions = 0;
+	struct page **phys_contig_mem_regions = NULL;
+	int rc = -EINVAL;
+
+	rc = ne_sanity_check_user_mem_region(ne_enclave, mem_region);
+	if (rc < 0)
+		return rc;
+
+	ne_mem_region = kzalloc(sizeof(*ne_mem_region), GFP_KERNEL);
+	if (!ne_mem_region)
+		return -ENOMEM;
+
+	max_nr_pages = mem_region.memory_size / NE_MIN_MEM_REGION_SIZE;
+
+	ne_mem_region->pages = kcalloc(max_nr_pages, sizeof(*ne_mem_region->pages),
+				       GFP_KERNEL);
+	if (!ne_mem_region->pages) {
+		rc = -ENOMEM;
+
+		goto free_mem_region;
+	}
+
+	phys_contig_mem_regions = kcalloc(max_nr_pages, sizeof(*phys_contig_mem_regions),
+					  GFP_KERNEL);
+	if (!phys_contig_mem_regions) {
+		rc = -ENOMEM;
+
+		goto free_mem_region;
+	}
+
+	do {
+		i = ne_mem_region->nr_pages;
+
+		if (i == max_nr_pages) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Reached max nr of pages in the pages data struct\n");
+
+			rc = -ENOMEM;
+
+			goto put_pages;
+		}
+
+		gup_rc = get_user_pages(mem_region.userspace_addr + memory_size, 1, FOLL_GET,
+					ne_mem_region->pages + i, NULL);
+		if (gup_rc < 0) {
+			rc = gup_rc;
+
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Error in get user pages [rc=%d]\n", rc);
+
+			goto put_pages;
+		}
+
+		if (!PageHuge(ne_mem_region->pages[i])) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Not a hugetlbfs page\n");
+
+			rc = -NE_ERR_MEM_NOT_HUGE_PAGE;
+
+			goto put_pages;
+		}
+
+		if (ne_enclave->numa_node != page_to_nid(ne_mem_region->pages[i])) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Page is not from NUMA node %d\n",
+					    ne_enclave->numa_node);
+
+			rc = -NE_ERR_MEM_DIFFERENT_NUMA_NODE;
+
+			goto put_pages;
+		}
+
+		/*
+		 * TODO: Update once handled non-contiguous memory regions
+		 * received from user space or contiguous physical memory regions
+		 * larger than 2 MiB e.g. 8 MiB.
+		 */
+		phys_contig_mem_regions[i] = ne_mem_region->pages[i];
+
+		memory_size += page_size(ne_mem_region->pages[i]);
+
+		ne_mem_region->nr_pages++;
+	} while (memory_size < mem_region.memory_size);
+
+	/*
+	 * TODO: Update once handled non-contiguous memory regions received
+	 * from user space or contiguous physical memory regions larger than
+	 * 2 MiB e.g. 8 MiB.
+	 */
+	nr_phys_contig_mem_regions = ne_mem_region->nr_pages;
+
+	if ((ne_enclave->nr_mem_regions + nr_phys_contig_mem_regions) >
+	    ne_enclave->max_mem_regions) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Reached max memory regions %lld\n",
+				    ne_enclave->max_mem_regions);
+
+		rc = -NE_ERR_MEM_MAX_REGIONS;
+
+		goto put_pages;
+	}
+
+	for (i = 0; i < nr_phys_contig_mem_regions; i++) {
+		u64 phys_region_addr = page_to_phys(phys_contig_mem_regions[i]);
+		u64 phys_region_size = page_size(phys_contig_mem_regions[i]);
+
+		if (phys_region_size & (NE_MIN_MEM_REGION_SIZE - 1)) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Physical mem region size is not multiple of 2 MiB\n");
+
+			rc = -EINVAL;
+
+			goto put_pages;
+		}
+
+		if (!IS_ALIGNED(phys_region_addr, NE_MIN_MEM_REGION_SIZE)) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Physical mem region address is not 2 MiB aligned\n");
+
+			rc = -EINVAL;
+
+			goto put_pages;
+		}
+	}
+
+	ne_mem_region->memory_size = mem_region.memory_size;
+	ne_mem_region->userspace_addr = mem_region.userspace_addr;
+
+	list_add(&ne_mem_region->mem_region_list_entry, &ne_enclave->mem_regions_list);
+
+	for (i = 0; i < nr_phys_contig_mem_regions; i++) {
+		struct ne_pci_dev_cmd_reply cmd_reply = {};
+		struct slot_add_mem_req slot_add_mem_req = {};
+
+		slot_add_mem_req.slot_uid = ne_enclave->slot_uid;
+		slot_add_mem_req.paddr = page_to_phys(phys_contig_mem_regions[i]);
+		slot_add_mem_req.size = page_size(phys_contig_mem_regions[i]);
+
+		rc = ne_do_request(ne_enclave->pdev, SLOT_ADD_MEM,
+				   &slot_add_mem_req, sizeof(slot_add_mem_req),
+				   &cmd_reply, sizeof(cmd_reply));
+		if (rc < 0) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Error in slot add mem [rc=%d]\n", rc);
+
+			kfree(phys_contig_mem_regions);
+
+			/*
+			 * Exit here without put pages as memory regions may
+			 * already been added.
+			 */
+			return rc;
+		}
+
+		ne_enclave->mem_size += slot_add_mem_req.size;
+		ne_enclave->nr_mem_regions++;
+	}
+
+	kfree(phys_contig_mem_regions);
+
+	return 0;
+
+put_pages:
+	for (i = 0; i < ne_mem_region->nr_pages; i++)
+		put_page(ne_mem_region->pages[i]);
+free_mem_region:
+	kfree(phys_contig_mem_regions);
+	kfree(ne_mem_region->pages);
+	kfree(ne_mem_region);
+
+	return rc;
+}
+
 /**
  * ne_enclave_ioctl() - Ioctl function provided by the enclave file.
  * @file:	File associated with this ioctl function.
@@ -682,6 +934,39 @@ static long ne_enclave_ioctl(struct file *file, unsigned int cmd, unsigned long
 		return 0;
 	}
 
+	case NE_SET_USER_MEMORY_REGION: {
+		struct ne_user_memory_region mem_region = {};
+		int rc = -EINVAL;
+
+		if (copy_from_user(&mem_region, (void __user *)arg, sizeof(mem_region)))
+			return -EFAULT;
+
+		if (mem_region.flags >= NE_MEMORY_REGION_MAX_FLAG_VAL)
+			return -EINVAL;
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
+		rc = ne_set_user_memory_region_ioctl(ne_enclave, mem_region);
+		if (rc < 0) {
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return rc;
+		}
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
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

