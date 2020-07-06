Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC1C2155C6
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 12:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgGFKrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 06:47:08 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:23852 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbgGFKrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 06:47:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1594032426; x=1625568426;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=mngr/DCNG1zQgPe4uz33ML7KchEuJI/oFtw5XXaQ5bI=;
  b=vgZKQghShw3BEN/84o7Vpbk6AbmBTaG+mQneM1JyNWWXMSjtU3Kq9H8U
   pGqeI4FjW2GLAFLDlLYLlepOAxcuCLqmBS8zL9APNZJ5Q5FpqE+Jm2/SR
   PN3rBvY3gZEPHJQdN2i9O4IyUK1ztIfetyNyFWy13h13ddpyeNV3nUaBK
   c=;
IronPort-SDR: ibx+QrhuD3wA/1gKbt2iK64wHshbX34Ug3vdF6uJdvVGk2gbzJGTkCSh8fLI69LrEoNC1ar5g6
 7MxrkNP5d/cA==
X-IronPort-AV: E=Sophos;i="5.75,318,1589241600"; 
   d="scan'208";a="49373822"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 06 Jul 2020 10:47:00 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id DC3D6A205C;
        Mon,  6 Jul 2020 10:46:57 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 10:46:57 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.85) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 10:46:51 +0000
Subject: Re: [PATCH v4 11/18] nitro_enclaves: Add logic for enclave memory
 region set
To:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-12-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <798dbb9f-0fe4-9fd9-2e64-f6f2bc740abf@amazon.de>
Date:   Mon, 6 Jul 2020 12:46:39 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-12-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D16UWB003.ant.amazon.com (10.43.161.194) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
> Another resource that is being set for an enclave is memory. User space
> memory regions, that need to be backed by contiguous memory regions,
> are associated with the enclave.
> =

> One solution for allocating / reserving contiguous memory regions, that
> is used for integration, is hugetlbfs. The user space process that is
> associated with the enclave passes to the driver these memory regions.
> =

> The enclave memory regions need to be from the same NUMA node as the
> enclave CPUs.
> =

> Add ioctl command logic for setting user space memory region for an
> enclave.
> =

> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> =

> v3 -> v4
> =

> * Check enclave memory regions are from the same NUMA node as the
>    enclave CPUs.
> * Use dev_err instead of custom NE log pattern.
> * Update the NE ioctl call to match the decoupling from the KVM API.
> =

> v2 -> v3
> =

> * Remove the WARN_ON calls.
> * Update static calls sanity checks.
> * Update kzfree() calls to kfree().
> =

> v1 -> v2
> =

> * Add log pattern for NE.
> * Update goto labels to match their purpose.
> * Remove the BUG_ON calls.
> * Check if enclave max memory regions is reached when setting an enclave
>    memory region.
> * Check if enclave state is init when setting an enclave memory region.
> ---
>   drivers/virt/nitro_enclaves/ne_misc_dev.c | 257 ++++++++++++++++++++++
>   1 file changed, 257 insertions(+)
> =

> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nit=
ro_enclaves/ne_misc_dev.c
> index cfdefa52ed2a..17ccb6cdbd75 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -476,6 +476,233 @@ static int ne_create_vcpu_ioctl(struct ne_enclave *=
ne_enclave, u32 vcpu_id)
>   	return rc;
>   }
>   =

> +/**
> + * ne_sanity_check_user_mem_region - Sanity check the userspace memory
> + * region received during the set user memory region ioctl call.
> + *
> + * This function gets called with the ne_enclave mutex held.
> + *
> + * @ne_enclave: private data associated with the current enclave.
> + * @mem_region: user space memory region to be sanity checked.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_sanity_check_user_mem_region(struct ne_enclave *ne_enclave,
> +	struct ne_user_memory_region *mem_region)
> +{
> +	if (ne_enclave->mm !=3D current->mm)
> +		return -EIO;
> +
> +	if ((mem_region->memory_size % NE_MIN_MEM_REGION_SIZE) !=3D 0) {
> +		dev_err_ratelimited(ne_misc_dev.this_device,
> +				    "Mem size not multiple of 2 MiB\n");
> +
> +		return -EINVAL;

Can we make this an error that gets propagated to user space explicitly? =

I'd rather have a clear error return value of this function than a =

random message in dmesg.

> +	}
> +
> +	if ((mem_region->userspace_addr & (NE_MIN_MEM_REGION_SIZE - 1)) ||

This logic already relies on the fact that NE_MIN_MEM_REGION_SIZE is a =

power of two. Can you do the same above on the memory_size check?

> +	    !access_ok((void __user *)(unsigned long)mem_region->userspace_addr,
> +		       mem_region->memory_size)) {
> +		dev_err_ratelimited(ne_misc_dev.this_device,
> +				    "Invalid user space addr range\n");
> +
> +		return -EINVAL;

Same comment again. Return different errors for different conditions, so =

that user space has a chance to print proper errors to its users.

Also, don't we have to check alignment of userspace_addr as well?

> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * ne_set_user_memory_region_ioctl - Add user space memory region to the=
 slot
> + * associated with the current enclave.
> + *
> + * This function gets called with the ne_enclave mutex held.
> + *
> + * @ne_enclave: private data associated with the current enclave.
> + * @mem_region: user space memory region to be associated with the given=
 slot.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
> +	struct ne_user_memory_region *mem_region)
> +{
> +	struct ne_pci_dev_cmd_reply cmd_reply =3D {};
> +	long gup_rc =3D 0;
> +	unsigned long i =3D 0;
> +	struct ne_mem_region *ne_mem_region =3D NULL;
> +	unsigned long nr_phys_contig_mem_regions =3D 0;
> +	unsigned long nr_pinned_pages =3D 0;
> +	struct page **phys_contig_mem_regions =3D NULL;
> +	int rc =3D -EINVAL;
> +	struct slot_add_mem_req slot_add_mem_req =3D {};
> +
> +	rc =3D ne_sanity_check_user_mem_region(ne_enclave, mem_region);
> +	if (rc < 0)
> +		return rc;
> +
> +	ne_mem_region =3D kzalloc(sizeof(*ne_mem_region), GFP_KERNEL);
> +	if (!ne_mem_region)
> +		return -ENOMEM;
> +
> +	/*
> +	 * TODO: Update nr_pages value to handle contiguous virtual address
> +	 * ranges mapped to non-contiguous physical regions. Hugetlbfs can give
> +	 * 2 MiB / 1 GiB contiguous physical regions.
> +	 */
> +	ne_mem_region->nr_pages =3D mem_region->memory_size /
> +		NE_MIN_MEM_REGION_SIZE;
> +
> +	ne_mem_region->pages =3D kcalloc(ne_mem_region->nr_pages,
> +				       sizeof(*ne_mem_region->pages),
> +				       GFP_KERNEL);
> +	if (!ne_mem_region->pages) {
> +		kfree(ne_mem_region);
> +
> +		return -ENOMEM;

kfree(NULL) is a nop, so you can just set rc and goto free_mem_region =

here and below.

> +	}
> +
> +	phys_contig_mem_regions =3D kcalloc(ne_mem_region->nr_pages,
> +					  sizeof(*phys_contig_mem_regions),
> +					  GFP_KERNEL);
> +	if (!phys_contig_mem_regions) {
> +		kfree(ne_mem_region->pages);
> +		kfree(ne_mem_region);
> +
> +		return -ENOMEM;
> +	}
> +
> +	/*
> +	 * TODO: Handle non-contiguous memory regions received from user space.
> +	 * Hugetlbfs can give 2 MiB / 1 GiB contiguous physical regions. The
> +	 * virtual address space can be seen as contiguous, although it is
> +	 * mapped underneath to 2 MiB / 1 GiB physical regions e.g. 8 MiB
> +	 * virtual address space mapped to 4 physically contiguous regions of 2
> +	 * MiB.
> +	 */
> +	do {
> +		unsigned long tmp_nr_pages =3D ne_mem_region->nr_pages -
> +			nr_pinned_pages;
> +		struct page **tmp_pages =3D ne_mem_region->pages +
> +			nr_pinned_pages;
> +		u64 tmp_userspace_addr =3D mem_region->userspace_addr +
> +			nr_pinned_pages * NE_MIN_MEM_REGION_SIZE;
> +
> +		gup_rc =3D get_user_pages(tmp_userspace_addr, tmp_nr_pages,
> +					FOLL_GET, tmp_pages, NULL);
> +		if (gup_rc < 0) {
> +			rc =3D gup_rc;
> +
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Error in gup [rc=3D%d]\n", rc);
> +
> +			unpin_user_pages(ne_mem_region->pages, nr_pinned_pages);
> +
> +			goto free_mem_region;
> +		}
> +
> +		nr_pinned_pages +=3D gup_rc;
> +
> +	} while (nr_pinned_pages < ne_mem_region->nr_pages);

Can this deadlock the kernel? Shouldn't we rather return an error when =

we can't pin all pages?

> +
> +	/*
> +	 * TODO: Update checks once physically contiguous regions are collected
> +	 * based on the user space address and get_user_pages() results.
> +	 */
> +	for (i =3D 0; i < ne_mem_region->nr_pages; i++) {
> +		if (!PageHuge(ne_mem_region->pages[i])) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Not a hugetlbfs page\n");
> +
> +			goto unpin_pages;
> +		}
> +
> +		if (huge_page_size(page_hstate(ne_mem_region->pages[i])) !=3D
> +		    NE_MIN_MEM_REGION_SIZE) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Page size isn't 2 MiB\n");

Why is a huge page size of >2MB a problem? Can't we just make =

huge_page_size() the ne mem slot size?

> +
> +			goto unpin_pages;
> +		}
> +
> +		if (ne_enclave->numa_node !=3D
> +		    page_to_nid(ne_mem_region->pages[i])) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Page isn't from NUMA node %d\n",
> +					    ne_enclave->numa_node);
> +
> +			goto unpin_pages;

Is there a way to give user space hints on *why* things are going wrong?

> +		}
> +
> +		/*
> +		 * TODO: Update once handled non-contiguous memory regions
> +		 * received from user space.
> +		 */
> +		phys_contig_mem_regions[i] =3D ne_mem_region->pages[i];
> +	}
> +
> +	/*
> +	 * TODO: Update once handled non-contiguous memory regions received
> +	 * from user space.
> +	 */
> +	nr_phys_contig_mem_regions =3D ne_mem_region->nr_pages;
> +
> +	if ((ne_enclave->nr_mem_regions + nr_phys_contig_mem_regions) >
> +	    ne_enclave->max_mem_regions) {
> +		dev_err_ratelimited(ne_misc_dev.this_device,
> +				    "Reached max memory regions %lld\n",
> +				    ne_enclave->max_mem_regions);
> +
> +		goto unpin_pages;
> +	}
> +
> +	for (i =3D 0; i < nr_phys_contig_mem_regions; i++) {
> +		u64 phys_addr =3D page_to_phys(phys_contig_mem_regions[i]);
> +
> +		slot_add_mem_req.slot_uid =3D ne_enclave->slot_uid;
> +		slot_add_mem_req.paddr =3D phys_addr;
> +		/*
> +		 * TODO: Update memory size of physical contiguous memory
> +		 * region, in case of non-contiguous memory regions received
> +		 * from user space.
> +		 */
> +		slot_add_mem_req.size =3D NE_MIN_MEM_REGION_SIZE;

Yeah, for now, just make it huge_page_size()! :)

> +
> +		rc =3D ne_do_request(ne_enclave->pdev, SLOT_ADD_MEM,
> +				   &slot_add_mem_req, sizeof(slot_add_mem_req),
> +				   &cmd_reply, sizeof(cmd_reply));
> +		if (rc < 0) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Error in slot add mem [rc=3D%d]\n",
> +					    rc);
> +
> +			/* TODO: Only unpin memory regions not added. */

Are we sure we're not creating an unusable system here?

> +			goto unpin_pages;
> +		}
> +
> +		ne_enclave->mem_size +=3D slot_add_mem_req.size;
> +		ne_enclave->nr_mem_regions++;
> +
> +		memset(&slot_add_mem_req, 0, sizeof(slot_add_mem_req));
> +		memset(&cmd_reply, 0, sizeof(cmd_reply));

If you define the variables in the for loop scope, you don't need to =

manually zero them again.


Alex

> +	}
> +
> +	list_add(&ne_mem_region->mem_region_list_entry,
> +		 &ne_enclave->mem_regions_list);
> +
> +	kfree(phys_contig_mem_regions);
> +
> +	return 0;
> +
> +unpin_pages:
> +	unpin_user_pages(ne_mem_region->pages, ne_mem_region->nr_pages);
> +free_mem_region:
> +	kfree(phys_contig_mem_regions);
> +	kfree(ne_mem_region->pages);
> +	kfree(ne_mem_region);
> +
> +	return rc;
> +}
> +
>   static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
>   			     unsigned long arg)
>   {
> @@ -561,6 +788,36 @@ static long ne_enclave_ioctl(struct file *file, unsi=
gned int cmd,
>   		return 0;
>   	}
>   =

> +	case NE_SET_USER_MEMORY_REGION: {
> +		struct ne_user_memory_region mem_region =3D {};
> +		int rc =3D -EINVAL;
> +
> +		if (copy_from_user(&mem_region, (void *)arg,
> +				   sizeof(mem_region))) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Error in copy from user\n");
> +
> +			return -EFAULT;
> +		}
> +
> +		mutex_lock(&ne_enclave->enclave_info_mutex);
> +
> +		if (ne_enclave->state !=3D NE_STATE_INIT) {
> +			dev_err_ratelimited(ne_misc_dev.this_device,
> +					    "Enclave isn't in init state\n");
> +
> +			mutex_unlock(&ne_enclave->enclave_info_mutex);
> +
> +			return -EINVAL;
> +		}
> +
> +		rc =3D ne_set_user_memory_region_ioctl(ne_enclave, &mem_region);
> +
> +		mutex_unlock(&ne_enclave->enclave_info_mutex);
> +
> +		return rc;
> +	}
> +
>   	default:
>   		return -ENOTTY;
>   	}
> =




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



