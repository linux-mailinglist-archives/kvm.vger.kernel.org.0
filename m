Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3745E47CC0E
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 05:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242315AbhLVEWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 23:22:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:35737 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232658AbhLVEWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 23:22:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640146961; x=1671682961;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Cyl3EnNuBUB+YdjCSptEMAFJt9rmebRqepgSebgdx4Q=;
  b=LtVgxlrocd0EMvyq+oCmRBTDZTP9+aOyjHav4HhYp3VnPIs8MiKtGJWp
   rLFxhAqqfnpuvnWFAYqn3Z3aR+UXC7mXeQpbS4iQWtVrbk/iEXqMWAmKS
   DFm0diAF5oj9C0rXxpq1vMZnttTAj+jRQDcwSU90TAIfYuMI3qPwO9oI4
   PMZfhGTlYIfCjSBGn1ZkgfgW+cv+EOa7V+BAUGVmayd1s4feRarkY5Ej2
   JpEv8yO7g1g2625OT6uGUaAtCo3EZLfS4dCN0Uho5KYpXCY10PcKzm0JF
   H46gsMNRgTBjTiHPIstzbzWn3dlLeNejKrW4L70zNa97X1e1VJqEV8uMW
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="238078551"
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="238078551"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 20:22:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="664154927"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 21 Dec 2021 20:22:34 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/13] iommu: Add iommu_at[de]tach_device_shared() for
 multi-device groups
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-8-baolu.lu@linux.intel.com>
 <dd797dcd-251a-1980-ca64-bb38e67a526f@arm.com>
 <20211221184609.GF1432915@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <ced7f89a-8857-a8bb-be06-aaaabb4cdf09@linux.intel.com>
Date:   Wed, 22 Dec 2021 12:22:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211221184609.GF1432915@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/22/21 2:46 AM, Jason Gunthorpe wrote:
>> It's worth taking a step back and realising that overall, this is really
>> just a more generalised and finer-grained extension of what 426a273834ea
>> already did for non-group-aware code, so it makes little sense*not*  to
>> integrate it into the existing interfaces.
> This is taking 426a to it's logical conclusion and*removing*  the
> group API from the drivers entirely. This is desirable because drivers
> cannot do anything sane with the group.
> 
> The drivers have struct devices, and so we provide APIs that work in
> terms of struct devices to cover both driver use cases today, and do
> so more safely than what is already implemented.
> 
> Do not mix up VFIO with the driver interface, these are different
> things. It is better VFIO stay on its own and not complicate the
> driver world.

Per Joerg's previous comments:

https://lore.kernel.org/linux-iommu/20211119150612.jhsvsbzisvux2lga@8bytes.org/

The commit 426a273834ea came only in order to disallow attaching a
single device within a group to a different iommu_domain. So it's
reasonable to improve the existing iommu_attach/detach_device() to cover
all cases. How about below code? Did I miss anything?

int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
{
         struct iommu_group *group;
         int ret = 0;

         group = iommu_group_get(dev);
         if (!group)
                 return -ENODEV;

         mutex_lock(&group->mutex);
         if (group->attach_cnt) {
                 if (group->domain != domain) {
                         ret = -EBUSY;
                         goto unlock_out;
                 }
         } else {
                 ret = __iommu_attach_group(domain, group);
                 if (ret)
                         goto unlock_out;
         }

         group->attach_cnt++;
unlock_out:
         mutex_unlock(&group->mutex);
         iommu_group_put(group);

         return ret;
}
EXPORT_SYMBOL_GPL(iommu_attach_device);

void iommu_detach_device_shared(struct iommu_domain *domain, struct 
device *dev)
{
         struct iommu_group *group;

         group = iommu_group_get(dev);
         if (WARN_ON(!group))
                 return;

         mutex_lock(&group->mutex);
         if (WARN_ON(!group->attach_cnt || group->domain != domain)
                 goto unlock_out;

         if (--group->attach_cnt == 0)
                 __iommu_detach_group(domain, group);

unlock_out:
         mutex_unlock(&group->mutex);
         iommu_group_put(group);
}
EXPORT_SYMBOL_GPL(iommu_detach_device);

Best regards,
baolu
