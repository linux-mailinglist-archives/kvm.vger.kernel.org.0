Return-Path: <kvm+bounces-65792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EE45FCB6D7E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 19:02:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 05158301AD10
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 18:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7858D313E2C;
	Thu, 11 Dec 2025 18:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RjX8XVyU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87956217F53;
	Thu, 11 Dec 2025 18:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765476122; cv=none; b=BXE+yStB7SqceTVN6Qqgpc+pLPpb9WxEJC3t6AkWuY44ARK4YWaB8D+a+BgsaV6e2/cjWlXG86ksX24ZrowfGIjP960zqwVFlfFQRWp5nN18FCkXfQjweDTlYr73fOjqAbpGjJjQEnC2uQP5qWc3VnryOdHEUt6SCAs9RM+vN9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765476122; c=relaxed/simple;
	bh=uk5WQ3B1iU1NHQheAAnDPKaw49fb/f75Ub7ecFM/KdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HqEWt9dss8q8jPLQKtnroczTLdGZwAvOI48M9P++Ph48uNMZ2kWwTa0U7mqj4cCi8Q1v0AdJ4Zsf5q7VJFYmbPCY2GFtzk72zOQLF3HL1GxevsYqFrVOy05jCkYl0rLmyKQPM1GyrbWSo88dvmHTZoPhUsocr4vE27d2KEhgmIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RjX8XVyU; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765476121; x=1797012121;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uk5WQ3B1iU1NHQheAAnDPKaw49fb/f75Ub7ecFM/KdU=;
  b=RjX8XVyUH2h8ZTM38CZPfsylgng4gq60ti40ICv+IseoL38xOpZU2/ma
   Yet4icVUgliG/QClXAd91QIrBaqiMrSo5Ox/hB5EIJXEq62ZhsyPNfMzB
   iccqocyzL1Jrs19gfDvyNI6Agxh/gK1Rx8CkYpILcoq2iaZRCYlcJWE0s
   rDszO9BS5CeuqoanTvKE6fI5APFDXqpQvdjybhak+ftL4jKimKAB0rEZQ
   RMFCRMuqdDUbFsFpax746ZhgOcs+lXVYzQIeVd8B2QqqbAa8beuPnZI1a
   w0sy/H6x8KBN6dD4KZrUAlfuQwYHxwD/BI9/eLIzVzixbCDP8EDP7PYOj
   Q==;
X-CSE-ConnectionGUID: P3vQB6u9RmSh0quvCySHVg==
X-CSE-MsgGUID: bXNrGzeIQ2aJwD6qeeRctQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="67351816"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="67351816"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 10:02:00 -0800
X-CSE-ConnectionGUID: MW0SZtleTxSNoMngB5NjKA==
X-CSE-MsgGUID: HX5ZZRF6TIyYpukbylSg3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="196762205"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.218]) ([10.125.109.218])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 10:01:57 -0800
Message-ID: <8ba6095f-00fa-4393-9c28-1b55927bf39d@intel.com>
Date: Thu, 11 Dec 2025 11:01:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 07/15] vfio/cxl: expose CXL region to the userspace via a
 new VFIO device region
To: Manish Honap <mhonap@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson
 <alwilliamson@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>,
 "alejandro.lucero-palau@amd.com" <alejandro.lucero-palau@amd.com>,
 "dave@stgolabs.net" <dave@stgolabs.net>,
 "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
 "alison.schofield@intel.com" <alison.schofield@intel.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
 "kevin.tian@intel.com" <kevin.tian@intel.com>
Cc: Neo Jia <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>,
 "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>,
 Krishnakant Jaju <kjaju@nvidia.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
 <20251209165019.2643142-8-mhonap@nvidia.com>
 <9f2d5327-6d23-4d4a-aede-f6161a59f086@intel.com>
 <SN7PR12MB7855D917BD75B3F865DC746DBDA1A@SN7PR12MB7855.namprd12.prod.outlook.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <SN7PR12MB7855D917BD75B3F865DC746DBDA1A@SN7PR12MB7855.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/11/25 10:31 AM, Manish Honap wrote:
> 
> 
>> -----Original Message-----
>> From: Dave Jiang <dave.jiang@intel.com>
>> Sent: 11 December 2025 21:36
>> To: Manish Honap <mhonap@nvidia.com>; Aniket Agashe
>> <aniketa@nvidia.com>; Ankit Agrawal <ankita@nvidia.com>; Alex Williamson
>> <alwilliamson@nvidia.com>; Vikram Sethi <vsethi@nvidia.com>; Jason
>> Gunthorpe <jgg@nvidia.com>; Matt Ochs <mochs@nvidia.com>; Shameer
>> Kolothum <skolothumtho@nvidia.com>; alejandro.lucero-palau@amd.com;
>> dave@stgolabs.net; jonathan.cameron@huawei.com;
>> alison.schofield@intel.com; vishal.l.verma@intel.com;
>> ira.weiny@intel.com; dan.j.williams@intel.com; jgg@ziepe.ca; Yishai
>> Hadas <yishaih@nvidia.com>; kevin.tian@intel.com
>> Cc: Neo Jia <cjia@nvidia.com>; Kirti Wankhede <kwankhede@nvidia.com>;
>> Tarun Gupta (SW-GPU) <targupta@nvidia.com>; Zhi Wang <zhiw@nvidia.com>;
>> Krishnakant Jaju <kjaju@nvidia.com>; linux-kernel@vger.kernel.org;
>> linux-cxl@vger.kernel.org; kvm@vger.kernel.org
>> Subject: Re: [RFC v2 07/15] vfio/cxl: expose CXL region to the userspace
>> via a new VFIO device region
>>
>> External email: Use caution opening links or attachments
>>
>>
>> On 12/9/25 9:50 AM, mhonap@nvidia.com wrote:
>>> From: Manish Honap <mhonap@nvidia.com>
>>>
>>> To directly access the device memory, a CXL region is required.
>>> Creating a CXL region requires to configure HDM decoders on the path
>>> to map the access of HPA level by level and evetually hit the DPA in
>>> the CXL topology.
>>>
>>> For the userspace, e.g. QEMU, to access the CXL region, the region is
>>> required to be exposed via VFIO interfaces.
>>>
>>> Introduce a new VFIO device region and region ops to expose the
>>> created CXL region when initialize the device in the vfio-cxl-core.
>>> Introduce a new sub region type for the userspace to identify a CXL
>> region.
>>>
>>> Co-developed-by: Zhi Wang <zhiw@nvidia.com>
>>> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
>>> Signed-off-by: Manish Honap <mhonap@nvidia.com>
>>> ---
>>>  drivers/vfio/pci/vfio_cxl_core.c | 122
>> +++++++++++++++++++++++++++++++
>>>  drivers/vfio/pci/vfio_pci_core.c |   3 +-
>>>  include/linux/vfio_pci_core.h    |   5 ++
>>>  include/uapi/linux/vfio.h        |   4 +
>>>  4 files changed, 133 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/vfio/pci/vfio_cxl_core.c
>>> b/drivers/vfio/pci/vfio_cxl_core.c
>>> index cf53720c0cb7..35d95de47fa8 100644
>>> --- a/drivers/vfio/pci/vfio_cxl_core.c
>>> +++ b/drivers/vfio/pci/vfio_cxl_core.c
>>> @@ -231,6 +231,128 @@ void vfio_cxl_core_destroy_cxl_region(struct
>>> vfio_cxl_core_device *cxl)  }
>>> EXPORT_SYMBOL_GPL(vfio_cxl_core_destroy_cxl_region);
>>>
>>> +static int vfio_cxl_region_mmap(struct vfio_pci_core_device *pci,
>>> +                             struct vfio_pci_region *region,
>>> +                             struct vm_area_struct *vma) {
>>> +     struct vfio_cxl_region *cxl_region = region->data;
>>> +     u64 req_len, pgoff, req_start, end;
>>> +     int ret;
>>> +
>>> +     if (!(region->flags & VFIO_REGION_INFO_FLAG_MMAP))
>>> +             return -EINVAL;
>>> +
>>> +     if (!(region->flags & VFIO_REGION_INFO_FLAG_READ) &&
>>> +         (vma->vm_flags & VM_READ))
>>> +             return -EPERM;
>>> +
>>> +     if (!(region->flags & VFIO_REGION_INFO_FLAG_WRITE) &&
>>> +         (vma->vm_flags & VM_WRITE))
>>> +             return -EPERM;
>>> +
>>> +     pgoff = vma->vm_pgoff &
>>> +             ((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>>> +
>>> +     if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
>>> +         check_add_overflow(PHYS_PFN(cxl_region->addr), pgoff,
>> &req_start) ||
>>> +         check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
>>> +             return -EOVERFLOW;
>>> +
>>> +     if (end > cxl_region->size)
>>> +             return -EINVAL;
>>> +
>>> +     if (cxl_region->noncached)
>>> +             vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>>> +     vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
>>> +
>>> +     vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
>>> +                  VM_DONTEXPAND | VM_DONTDUMP);
>>> +
>>> +     ret = remap_pfn_range(vma, vma->vm_start, req_start,
>>> +                           req_len, vma->vm_page_prot);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     vma->vm_pgoff = req_start;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static ssize_t vfio_cxl_region_rw(struct vfio_pci_core_device
>> *core_dev,
>>> +                               char __user *buf, size_t count, loff_t
>> *ppos,
>>> +                               bool iswrite) {
>>> +     unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) -
>> VFIO_PCI_NUM_REGIONS;
>>> +     struct vfio_cxl_region *cxl_region = core_dev->region[i].data;
>>> +     loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>>> +
>>> +     if (!count)
>>> +             return 0;
>>> +
>>> +     return vfio_pci_core_do_io_rw(core_dev, false,
>>> +                                   cxl_region->vaddr,
>>> +                                   (char __user *)buf, pos, count,
>>> +                                   0, 0, iswrite); }
>>> +
>>> +static void vfio_cxl_region_release(struct vfio_pci_core_device
>> *vdev,
>>> +                                 struct vfio_pci_region *region) { }
>>> +
>>> +static const struct vfio_pci_regops vfio_cxl_regops = {
>>> +     .rw             = vfio_cxl_region_rw,
>>> +     .mmap           = vfio_cxl_region_mmap,
>>> +     .release        = vfio_cxl_region_release,
>>> +};
>>> +
>>> +int vfio_cxl_core_register_cxl_region(struct vfio_cxl_core_device
>>> +*cxl) {
>>> +     struct vfio_pci_core_device *pci = &cxl->pci_core;
>>> +     struct vfio_cxl *cxl_core = cxl->cxl_core;
>>> +     u32 flags;
>>> +     int ret;
>>> +
>>> +     if (WARN_ON(!cxl_core->region.region || cxl_core->region.vaddr))
>>> +             return -EEXIST;
>>> +
>>> +     cxl_core->region.vaddr = ioremap(cxl_core->region.addr,
>> cxl_core->region.size);
>>> +     if (!cxl_core->region.addr)
>>
>> I think you are wanting to check cxl_core->region.vaddr here right?
> 
> Yes, you are correct. I will update this check.
> 
>>
>> Also, what is the ioremap'd region for?
> 
> It is to handle read/write operations when QEMU performs I/O on the VFIO CXL device region via the read()/write() syscalls.

For the CXL device region, for the most part the operations are done via the region being mmap()'d by qemu right? I understand read/write to BAR0 MMIO. What specific operations are done via read/write to the region? It may be worth mentioning in the commit log. 

> 
>>
>> DJ

