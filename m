Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CAE399B09
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 08:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhFCGxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 02:53:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:18651 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhFCGxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 02:53:11 -0400
IronPort-SDR: a4pSFPjknW+FX6nynFovD9AEU4BLU+jxRh/KKrLJXLudaXenzFZY5zzop2wVW3FZJxduqqxb0D
 xLkLB3hFGlmA==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="191090553"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="191090553"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 23:51:26 -0700
IronPort-SDR: 3vUZ5TeuGZxxfh6ulpxTYfX9fSHdBUpI4kW9u8qn89MnNIc6zr2G/2jkVM+gNfeqamv9P3xQEy
 hTXdL4MsDSvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="633593787"
Received: from allen-box.sh.intel.com (HELO [10.239.159.105]) ([10.239.159.105])
  by fmsmga006.fm.intel.com with ESMTP; 02 Jun 2021 23:51:22 -0700
Cc:     baolu.lu@linux.intel.com, Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     David Gibson <david@gibson.dropbear.id.au>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
 <786295f7-b154-cf28-3f4c-434426e897d3@linux.intel.com>
 <YLhupAfUWWiVMDVU@yekko>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <e2dc8e4d-1f62-36d5-b303-18c82b6a6770@linux.intel.com>
Date:   Thu, 3 Jun 2021 14:50:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YLhupAfUWWiVMDVU@yekko>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

On 6/3/21 1:54 PM, David Gibson wrote:
> On Tue, Jun 01, 2021 at 07:09:21PM +0800, Lu Baolu wrote:
>> Hi Jason,
>>
>> On 2021/5/29 7:36, Jason Gunthorpe wrote:
>>>> /*
>>>>     * Bind an user-managed I/O page table with the IOMMU
>>>>     *
>>>>     * Because user page table is untrusted, IOASID nesting must be enabled
>>>>     * for this ioasid so the kernel can enforce its DMA isolation policy
>>>>     * through the parent ioasid.
>>>>     *
>>>>     * Pgtable binding protocol is different from DMA mapping. The latter
>>>>     * has the I/O page table constructed by the kernel and updated
>>>>     * according to user MAP/UNMAP commands. With pgtable binding the
>>>>     * whole page table is created and updated by userspace, thus different
>>>>     * set of commands are required (bind, iotlb invalidation, page fault, etc.).
>>>>     *
>>>>     * Because the page table is directly walked by the IOMMU, the user
>>>>     * must  use a format compatible to the underlying hardware. It can
>>>>     * check the format information through IOASID_GET_INFO.
>>>>     *
>>>>     * The page table is bound to the IOMMU according to the routing
>>>>     * information of each attached device under the specified IOASID. The
>>>>     * routing information (RID and optional PASID) is registered when a
>>>>     * device is attached to this IOASID through VFIO uAPI.
>>>>     *
>>>>     * Input parameters:
>>>>     *	- child_ioasid;
>>>>     *	- address of the user page table;
>>>>     *	- formats (vendor, address_width, etc.);
>>>>     *
>>>>     * Return: 0 on success, -errno on failure.
>>>>     */
>>>> #define IOASID_BIND_PGTABLE		_IO(IOASID_TYPE, IOASID_BASE + 9)
>>>> #define IOASID_UNBIND_PGTABLE	_IO(IOASID_TYPE, IOASID_BASE + 10)
>>> Also feels backwards, why wouldn't we specify this, and the required
>>> page table format, during alloc time?
>>>
>> Thinking of the required page table format, perhaps we should shed more
>> light on the page table of an IOASID. So far, an IOASID might represent
>> one of the following page tables (might be more):
>>
>>   1) an IOMMU format page table (a.k.a. iommu_domain)
>>   2) a user application CPU page table (SVA for example)
>>   3) a KVM EPT (future option)
>>   4) a VM guest managed page table (nesting mode)
>>
>> This version only covers 1) and 4). Do you think we need to support 2),
> Isn't (2) the equivalent of using the using the host-managed pagetable
> then doing a giant MAP of all your user address space into it?  But
> maybe we should identify that case explicitly in case the host can
> optimize it.
> 

Conceptually, yes. Current SVA implementation just reuses the
application's cpu page table w/o map/unmap operations.

Best regards,
baolu
