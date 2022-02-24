Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9CDF4C21DD
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 03:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiBXCwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 21:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiBXCwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 21:52:02 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3214023740B;
        Wed, 23 Feb 2022 18:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645671093; x=1677207093;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q8NuIg6u4n/AovpFHzIDVu3x9nClaeDa6GNC+Dzc7zA=;
  b=NZMQ/dNWhZDjekiADp6BryIRHvpwXrsT8rvIQn4WgWxWQ+KxPG8G7Dda
   s9nsgKbnMFxrfFAYUtftP/nMsvwCn27k7J1j4JrLKx4jafPwLI4fu7V+5
   O/rQ0EbXUVSRWwUNnhAe9OjeYyQx54J5xCYv6Qt4KdU7OKa0ksmp0tDcP
   iMePIy+zNUfrAoWO4ZNazVx9ff0/67Qq/OuU8GHOEUVl8vqJkBmzZmzCY
   adW+4ICgOVZpSUOx0DIxcblFYiK5XaOaHFj1PYeS7cSgHB6/eqsrih1K1
   i9FO8YJmNB/aI5AxlG5FGp/1e77DFLESh8yTbF6y9/pZ2NgRa3eycAfQ3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="239531323"
X-IronPort-AV: E=Sophos;i="5.88,392,1635231600"; 
   d="scan'208";a="239531323"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 18:51:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,392,1635231600"; 
   d="scan'208";a="684127489"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2022 18:51:26 -0800
Message-ID: <ca45b5db-69f2-b93d-745b-348463f1cb3c@linux.intel.com>
Date:   Thu, 24 Feb 2022 10:49:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v6 10/11] vfio: Remove iommu group notifier
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-11-baolu.lu@linux.intel.com>
 <20220223145339.57ed632e.alex.williamson@redhat.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <20220223145339.57ed632e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 2/24/22 5:53 AM, Alex Williamson wrote:
> On Fri, 18 Feb 2022 08:55:20 +0800
> Lu Baolu <baolu.lu@linux.intel.com> wrote:
> 
>> The iommu core and driver core have been enhanced to avoid unsafe driver
>> binding to a live group after iommu_group_set_dma_owner(PRIVATE_USER)
>> has been called. There's no need to register iommu group notifier. This
>> removes the iommu group notifer which contains BUG_ON() and WARN().
>>
>> The commit 5f096b14d421b ("vfio: Whitelist PCI bridges") allowed all
>> pcieport drivers to be bound with devices while the group is assigned to
>> user space. This is not always safe. For example, The shpchp_core driver
>> relies on the PCI MMIO access for the controller functionality. With its
>> downstream devices assigned to the userspace, the MMIO might be changed
>> through user initiated P2P accesses without any notification. This might
>> break the kernel driver integrity and lead to some unpredictable
>> consequences. As the result, currently we only allow the portdrv driver.
>>
>> For any bridge driver, in order to avoiding default kernel DMA ownership
>> claiming, we should consider:
>>
>>   1) Does the bridge driver use DMA? Calling pci_set_master() or
>>      a dma_map_* API is a sure indicate the driver is doing DMA
>>
>>   2) If the bridge driver uses MMIO, is it tolerant to hostile
>>      userspace also touching the same MMIO registers via P2P DMA
>>      attacks?
>>
>> Conservatively if the driver maps an MMIO region at all, we can say that
>> it fails the test.
> 
> IIUC, there's a chance we're going to break user configurations if
> they're assigning devices from a group containing a bridge that uses a
> driver other than pcieport.  The recommendation to such an affected user
> would be that the previously allowed host bridge driver was unsafe for
> this use case and to continue to enable assignment of devices within
> that group, the driver should be unbound from the bridge device or
> replaced with the pci-stub driver.  Is that right?

Yes. You are right.

Another possible solution (for long term) is to re-audit the bridge
driver code and set the .device_managed_dma field on the premise that
the driver doesn't violate above potential hazards.

> 
> Unfortunately I also think a bisect of such a breakage wouldn't land
> here, I think it was actually broken in "vfio: Set DMA ownership for
> VFIO" since that's where vfio starts to make use of
> iommu_group_claim_dma_owner() which should fail due to
> pci_dma_configure() calling iommu_device_use_default_domain() for
> any driver not identifying itself as driver_managed_dma.

Yes. Great point. Thank you!

> 
> If that's correct, can we leave a breadcrumb in the correct commit log
> indicating why this potential breakage is intentional and how the
> bridge driver might be reconfigured to continue to allow assignment from
> within the group more safely?  Thanks,

Sure. I will add below in the commit message of "vfio: Set DMA ownership 
for VFIO":

"
This change disallows some unsafe bridge drivers to bind to non-ACS
bridges while devices under them are assigned to user space. This is an
intentional enhancement and possibly breaks some existing
configurations. The recommendation to such an affected user would be
that the previously allowed host bridge driver was unsafe for this use
case and to continue to enable assignment of devices within that group,
the driver should be unbound from the bridge device or replaced with the
pci-stub driver.

For any bridge driver, we consider it unsafe if it satisfies any of the
following conditions:

   1) The bridge driver uses DMA. Calling pci_set_master() or calling any
      kernel DMA API (dma_map_*() and etc.) is an indicate that the
      driver is doing DMA.

   2) If the bridge driver uses MMIO, it should be tolerant to hostile
      userspace also touching the same MMIO registers via P2P DMA
      attacks.

If the bridge driver turns out to be a safe one, it could be used as
before by setting the driver's .driver_managed_dma field, just like what
we have done in the pcieport driver.
"

Best regards,
baolu
