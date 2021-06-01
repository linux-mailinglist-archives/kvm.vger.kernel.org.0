Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FC739721F
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 13:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhFALLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 07:11:11 -0400
Received: from mga17.intel.com ([192.55.52.151]:55270 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhFALLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 07:11:10 -0400
IronPort-SDR: pkC2Q//r7MY75tw/5TDmjOxbO+z4PmHrn1GS5EnsMI4pRunlWQMJtfdhzOyf1uXXD2z6LP2Qlb
 TESWM8Hz9PJw==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="183884743"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="183884743"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 04:09:28 -0700
IronPort-SDR: WZDegxNp3wP/q9jDqwvfXA6qZogcEqh5JoBYq/igauYkrmanJiiBAFQsG4FtYSwyipOd9u7o5j
 CsavuhDtdc4g==
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="479239460"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.213.9]) ([10.254.213.9])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 04:09:24 -0700
Cc:     baolu.lu@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
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
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <786295f7-b154-cf28-3f4c-434426e897d3@linux.intel.com>
Date:   Tue, 1 Jun 2021 19:09:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210528233649.GB3816344@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 2021/5/29 7:36, Jason Gunthorpe wrote:
>> /*
>>    * Bind an user-managed I/O page table with the IOMMU
>>    *
>>    * Because user page table is untrusted, IOASID nesting must be enabled
>>    * for this ioasid so the kernel can enforce its DMA isolation policy
>>    * through the parent ioasid.
>>    *
>>    * Pgtable binding protocol is different from DMA mapping. The latter
>>    * has the I/O page table constructed by the kernel and updated
>>    * according to user MAP/UNMAP commands. With pgtable binding the
>>    * whole page table is created and updated by userspace, thus different
>>    * set of commands are required (bind, iotlb invalidation, page fault, etc.).
>>    *
>>    * Because the page table is directly walked by the IOMMU, the user
>>    * must  use a format compatible to the underlying hardware. It can
>>    * check the format information through IOASID_GET_INFO.
>>    *
>>    * The page table is bound to the IOMMU according to the routing
>>    * information of each attached device under the specified IOASID. The
>>    * routing information (RID and optional PASID) is registered when a
>>    * device is attached to this IOASID through VFIO uAPI.
>>    *
>>    * Input parameters:
>>    *	- child_ioasid;
>>    *	- address of the user page table;
>>    *	- formats (vendor, address_width, etc.);
>>    *
>>    * Return: 0 on success, -errno on failure.
>>    */
>> #define IOASID_BIND_PGTABLE		_IO(IOASID_TYPE, IOASID_BASE + 9)
>> #define IOASID_UNBIND_PGTABLE	_IO(IOASID_TYPE, IOASID_BASE + 10)
> Also feels backwards, why wouldn't we specify this, and the required
> page table format, during alloc time?
> 

Thinking of the required page table format, perhaps we should shed more
light on the page table of an IOASID. So far, an IOASID might represent
one of the following page tables (might be more):

  1) an IOMMU format page table (a.k.a. iommu_domain)
  2) a user application CPU page table (SVA for example)
  3) a KVM EPT (future option)
  4) a VM guest managed page table (nesting mode)

This version only covers 1) and 4). Do you think we need to support 2),
3) and beyond? If so, it seems that we need some in-kernel helpers and
uAPIs to support pre-installing a page table to IOASID. From this point
of view an IOASID is actually not just a variant of iommu_domain, but an
I/O page table representation in a broader sense.

Best regards,
baolu
