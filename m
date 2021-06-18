Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC003AC2D4
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 07:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhFRFZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 01:25:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:45541 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229671AbhFRFZb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 01:25:31 -0400
IronPort-SDR: b6Dn0RQZ0m6w/AcA8NgjB7mB4bDHPV8tntR4/T4NHh+qCmA5BelsV3deAH4VZsVd8emJ+AftWL
 TpfDqa+JtXKg==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="186190427"
X-IronPort-AV: E=Sophos;i="5.83,283,1616482800"; 
   d="scan'208";a="186190427"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 22:23:21 -0700
IronPort-SDR: 4NGXo4KjN3kz+xI8wopVyXJfV6B9U5dgiyrFssRbBVsZnBC+5BLY00MKKQNFZOy06EeRcJ8FJr
 9RnOGfuyridQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,283,1616482800"; 
   d="scan'208";a="555469079"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 17 Jun 2021 22:23:16 -0700
Cc:     baolu.lu@linux.intel.com, Jason Gunthorpe <jgg@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Plan for /dev/ioasid RFC v2
To:     David Gibson <david@gibson.dropbear.id.au>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org> <20210609123919.GA1002214@nvidia.com>
 <14d884a8-13bc-b2ba-7020-94b219e3e2d9@linux.intel.com>
 <YMrcLcTL+cUKd1a5@yekko>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <b9c48526-8b8f-ff9e-4ece-4a39f476e3b7@linux.intel.com>
Date:   Fri, 18 Jun 2021 13:21:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YMrcLcTL+cUKd1a5@yekko>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

On 6/17/21 1:22 PM, David Gibson wrote:
>> The iommu_group can guarantee the isolation among different physical
>> devices (represented by RIDs). But when it comes to sub-devices (ex. mdev or
>> vDPA devices represented by RID + SSID), we have to rely on the
>> device driver for isolation. The devices which are able to generate sub-
>> devices should either use their own on-device mechanisms or use the
>> platform features like Intel Scalable IOV to isolate the sub-devices.
> This seems like a misunderstanding of groups.  Groups are not tied to
> any PCI meaning.  Groups are the smallest unit of isolation, no matter
> what is providing that isolation.
> 
> If mdevs are isolated from each other by clever software, even though
> they're on the same PCI device they are in different groups from each
> other*by definition*.  They are also in a different group from their
> parent device (however the mdevs only exist when mdev driver is
> active, which implies that the parent device's group is owned by the
> kernel).


You are right. This is also my understanding of an "isolation group".

But, as I understand it, iommu_group is only the isolation group visible
to IOMMU. When we talk about sub-devices (sw-mdev or mdev w/ pasid),
only the device and device driver knows the details of isolation, hence
iommu_group could not be extended to cover them. The device drivers
should define their own isolation groups.

Otherwise, the device driver has to fake an iommu_group and add hacky
code to link the related IOMMU elements (iommu device, domain, group
etc.) together. Actually this is part of the problem that this proposal
tries to solve.

> 
>> Under above conditions, different sub-device from a same RID device
>> could be able to use different IOASID. This seems to means that we can't
>> support mixed mode where, for example, two RIDs share an iommu_group and
>> one (or both) of them have sub-devices.
> That doesn't necessarily follow.  mdevs which can be successfully
> isolated by their mdev driver are in a different group from their
> parent device, and therefore need not be affected by whether the
> parent device shares a group with some other physical device.  They
> *might*  be, but that's up to the mdev driver to determine based on
> what it can safely isolate.
> 

If we understand it as multiple levels of isolation, can we classify the
devices into the following categories?

1) Legacy devices
    - devices without device-level isolation
    - multiple devices could sit in a single iommu_group
    - only a single I/O address space could be bound to IOMMU

2) Modern devices
    - devices capable of device-level isolation
    - able to have subdevices
    - self-isolated, hence not share iommu_group with others
    - multiple I/O address spaces could be bound to IOMMU

For 1), all devices in an iommu_group should be bound to a single
IOASID; The isolation is guaranteed by an iommu_group.

For 2) a single device could be bound to multiple IOASIDs with each sub-
device corresponding to an IOASID. The isolation of each subdevice is
guaranteed by the device driver.

Best regards,
baolu

