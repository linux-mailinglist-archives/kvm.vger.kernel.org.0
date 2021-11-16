Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA0945262E
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 03:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350906AbhKPCCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 21:02:37 -0500
Received: from mga06.intel.com ([134.134.136.31]:2819 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347758AbhKPCAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 21:00:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="294420382"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="294420382"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 17:57:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="494266192"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga007.jf.intel.com with ESMTP; 15 Nov 2021 17:57:15 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        rafael@kernel.org, Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20211115203848.GA1586192@bhelgaas>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <6a2e3d54-8c7f-0367-081b-5448d93f5ca5@linux.intel.com>
Date:   Tue, 16 Nov 2021 09:52:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211115203848.GA1586192@bhelgaas>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bjorn,

On 11/16/21 4:38 AM, Bjorn Helgaas wrote:
> On Mon, Nov 15, 2021 at 10:05:42AM +0800, Lu Baolu wrote:
>>  From the perspective of who is initiating the device to do DMA, device
>> DMA could be divided into the following types:
>>
>>          DMA_OWNER_KERNEL: kernel device driver intiates the DMA
>>          DMA_OWNER_USER: userspace device driver intiates the DMA
> 
> s/intiates/initiates/ (twice)

Yes.

> 
> As your first sentence suggests, the driver doesn't actually
> *initiate* the DMA in either case.  One of the drivers programs the
> device, and the *device* initiates the DMA.

You are right. I could rephrase it as:

"From the perspective of who is controlling the device to do DMA ..."

> 
>> DMA_OWNER_KERNEL and DMA_OWNER_USER are exclusive for all devices in
>> same iommu group as an iommu group is the smallest granularity of device
>> isolation and protection that the IOMMU subsystem can guarantee.
> 
> I think this basically says DMA_OWNER_KERNEL and DMA_OWNER_USER are
> attributes of the iommu_group (not an individual device), and it
> applies to all devices in the iommu_group.  Below, you allude to the
> fact that the interfaces are per-device.  It's not clear to me why you
> made a per-device interface instead of a per-group interface.

Yes, the attributes are of the iommu_group. We have both per-device and
per-iommu_group interfaces. The former is for device drivers and the
latter is only for vfio who has an iommu_group based iommu abstract.

>> This
>> extends the iommu core to enforce this exclusion when devices are
>> assigned to userspace.
>>
>> Basically two new interfaces are provided:
>>
>>          int iommu_device_set_dma_owner(struct device *dev,
>>                  enum iommu_dma_owner mode, struct file *user_file);
>>          void iommu_device_release_dma_owner(struct device *dev,
>>                  enum iommu_dma_owner mode);
>>
>> Although above interfaces are per-device, DMA owner is tracked per group
>> under the hood. An iommu group cannot have both DMA_OWNER_KERNEL
>> and DMA_OWNER_USER set at the same time. Violation of this assumption
>> fails iommu_device_set_dma_owner().
>>
>> Kernel driver which does DMA have DMA_OWNER_KENREL automatically
>> set/released in the driver binding process (see next patch).
> 
> s/DMA_OWNER_KENREL/DMA_OWNER_KERNEL/

Yes. Sorry for the typo.

> 
>> Kernel driver which doesn't do DMA should not set the owner type (via a
>> new suppress flag in next patch). Device bound to such driver is considered
>> same as a driver-less device which is compatible to all owner types.
>>
>> Userspace driver framework (e.g. vfio) should set DMA_OWNER_USER for
>> a device before the userspace is allowed to access it, plus a fd pointer to
>> mark the user identity so a single group cannot be operated by multiple
>> users simultaneously. Vice versa, the owner type should be released after
>> the user access permission is withdrawn.

Best regards,
baolu
