Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E73B2A3BED
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 06:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgKCF27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 00:28:59 -0500
Received: from mga12.intel.com ([192.55.52.136]:40366 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgKCF27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 00:28:59 -0500
IronPort-SDR: icOpANO+CrjDdp1Mb+tKGQbFdft6tuY43dwSdDa+aKrvJADvNWUbOFduwRzUmdNggDWe0r9K2v
 n2XMbquxjflw==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="148282611"
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="148282611"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 21:28:59 -0800
IronPort-SDR: RDhRvVovQrB2WmyVPN9C3DGOD+0DTYEeV85cbZ6D+ifryHL2iUZD9eku3p2W4KWpCtDjNG/NZs
 4ml2Ftc5gAGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="426194676"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 02 Nov 2020 21:28:56 -0800
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Zeng, Xin" <xin.zeng@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 5/5] vfio/type1: Use mdev bus iommu_ops for IOMMU
 callbacks
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <20201030045809.957927-1-baolu.lu@linux.intel.com>
 <20201030045809.957927-6-baolu.lu@linux.intel.com>
 <MWHPR11MB1645DEBE7C0E7A61D22081DD8C150@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201030150625.2dc5fb9b@w520.home>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <5802fc4a-7dc0-eda7-4e7c-809bcec6bd90@linux.intel.com>
Date:   Tue, 3 Nov 2020 13:22:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201030150625.2dc5fb9b@w520.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 10/31/20 5:06 AM, Alex Williamson wrote:
> On Fri, 30 Oct 2020 06:16:28 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
>>> From: Lu Baolu <baolu.lu@linux.intel.com>
>>> Sent: Friday, October 30, 2020 12:58 PM
>>>
>>> With the IOMMU driver registering iommu_ops for the mdev_bus, the
>>> IOMMU
>>> operations on an mdev could be done in the same way as any normal device
>>> (for example, PCI/PCIe). There's no need to distinguish an mdev from
>>> others for iommu operations. Remove the unnecessary code.
>>
>> This is really a nice cleanup as the output of this change! :)
> 
> It's easy to remove a bunch of code when the result is breaking
> everyone else.  Please share with me how SR-IOV backed mdevs continue
> to work on AMD platforms, or how they might work on ARM platforms, when
> siov_iommu_ops (VT-d only) becomes the one and only provider of
> iommu_ops on the mdev bus.  Hard NAK on this series.  Thanks,

I focused too much on a feature and forgot about university. I should
apologize for this. Sorry about it!

Back to the original intention of this series. The aux domain was
allocated in vfio/mdev, but it's also needed by the vDCM component of a
device driver for mediated callbacks. Currently vfio/mdev or iommu core
has no support for this.

We had a proposal when we first did aux-domain support. But was not
discussed since there was no consumer at that time.

https://lore.kernel.org/linux-iommu/20181105073408.21815-7-baolu.lu@linux.intel.com/

Does it look good to you? I can send patches of such solution for
discussion if you think it's a right way.

Extending the iommu core for subdevice passthrough support sounds an
interesting topic, but it will take much time before we reach a
consensus. It sounds a good topic for the next year's LPC/MC :-).

Best regards,
baolu
