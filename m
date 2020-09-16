Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B2226B987
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 03:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgIPBwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 21:52:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:50797 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgIPBwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 21:52:46 -0400
IronPort-SDR: druaA/N8E+y9JnzbBFXGWgbaCTYgbVWaPGubR3pGOCVnTpVT9KBhPxTPj/tFVf8Z6r2MtRTxyS
 fsU9txGOXg3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="138884672"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="138884672"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 18:52:46 -0700
IronPort-SDR: 1R/NaYdPsO3TrrR1z78pfO9jQWIFtldu73K8T0iaNzIRTFYl7QoOYpEdXMPim1jBUmRyOhoFz2
 i0WzoOOOdiNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="409394276"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 15 Sep 2020 18:52:42 -0700
Cc:     baolu.lu@linux.intel.com, "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, eric.auger@redhat.com,
        joro@8bytes.org, kevin.tian@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
To:     "Jacob Pan (Jun)" <jacob.jun.pan@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20200914163354.GG904879@nvidia.com>
 <20200914105857.3f88a271@x1.home> <20200914174121.GI904879@nvidia.com>
 <20200914122328.0a262a7b@x1.home> <20200914190057.GM904879@nvidia.com>
 <20200914224438.GA65940@otc-nc-03> <20200915113341.GW904879@nvidia.com>
 <20200915181154.GA70770@otc-nc-03> <20200915184510.GB1573713@nvidia.com>
 <20200915150851.76436ca1@jacob-builder> <20200915235126.GK1573713@nvidia.com>
 <20200915171319.00003f59@linux.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <9dd60896-0d3c-6d46-cf26-9195df78210f@linux.intel.com>
Date:   Wed, 16 Sep 2020 09:46:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200915171319.00003f59@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/16/20 8:22 AM, Jacob Pan (Jun) wrote:
>> If user space wants to bind page tables, create the PASID with
>> /dev/sva, use ioctls there to setup the page table the way it wants,
>> then pass the now configured PASID to a driver that can use it.
>>
> Are we talking about bare metal SVA? If so, I don't see the need for
> userspace to know there is a PASID. All user space need is that my
> current mm is bound to a device by the driver. So it can be a one-step
> process for user instead of two.
> 
>> Driver does not do page table binding. Do not duplicate all the
>> control plane uAPI in every driver.
>>
>> PASID managment and binding is seperated from the driver(s) that are
>> using the PASID.
>>
> Why separate? Drivers need to be involved in PASID life cycle
> management. For example, when tearing down a PASID, the driver needs to
> stop DMA, IOMMU driver needs to unbind, etc. If driver is the control
> point, then things are just in order. I am referring to bare metal SVA.
> 
> For guest SVA, I agree that binding is separate from PASID allocation.
> Could you review this doc. in terms of life cycle?
> https://lkml.org/lkml/2020/8/22/13
> 
> My point is that /dev/sda has no value for bare metal SVA, we are just
> talking about if guest SVA UAPIs can be consolidated. Or am I missing
> something?
> 

Not only bare metal SVA, but also subdevice passthrough (Intel Scalable
IOV and ARM SubStream ID) also consumes PASID which has nothing to do
with user space, hence the /dev/sva is unsuited.

Best regards,
baolu
