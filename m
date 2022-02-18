Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F0C4BAF14
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 02:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbiBRBJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 20:09:38 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiBRBJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 20:09:36 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2883BA47;
        Thu, 17 Feb 2022 17:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645146561; x=1676682561;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i/uHlQnpqnYhs2UtoI5OgAOBiOeNbQTVCxOGakFU9Us=;
  b=WDxa2hw2LT1oLushOA1x/8uZB+xePo/ogmkmdhsTBGzd1DDh4odVYxxO
   7zB0NHw7aapm/ZlMSRe2xCVU4+am1gWUHJArBxwIfLuKrOCWvzZ14TmsN
   IkPqxaE4XvzotLDA2AU+KrkT+MP5JIOXqYmKQnZfBzd4+l8YSZ+w8b/KH
   shkq21xb8dNqsJ4thM5z6eGAFkiU6KBOncXz6LU5NidQJcVAv6CkCjF24
   /5qNrnUa5BVEHkkd551yJXJJ1FfdSIuDHwu0xypENRWRgoVcgRvJgtRgw
   7J241EHXwj1S20B2om/hTogaQo6gRw1GiaxUPb751H8moIzRZl3pBB6YC
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="238423700"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="238423700"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 17:09:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="682271178"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 17 Feb 2022 17:09:13 -0800
Message-ID: <cbfa96be-74a7-92f5-620a-2d820c7f55d8@linux.intel.com>
Date:   Fri, 18 Feb 2022 09:07:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
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
Subject: Re: [PATCH v5 00/14] Fix BUG_ON in vfio_iommu_group_notifier()
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/4/22 9:56 AM, Lu Baolu wrote:
> Hi folks,
> 
> The iommu group is the minimal isolation boundary for DMA. Devices in
> a group can access each other's MMIO registers via peer to peer DMA
> and also need share the same I/O address space.
> 
> Once the I/O address space is assigned to user control it is no longer
> available to the dma_map* API, which effectively makes the DMA API
> non-working.
> 
> Second, userspace can use DMA initiated by a device that it controls
> to access the MMIO spaces of other devices in the group. This allows
> userspace to indirectly attack any kernel owned device and it's driver.
> 
> Therefore groups must either be entirely under kernel control or
> userspace control, never a mixture. Unfortunately some systems have
> problems with the granularity of groups and there are a couple of
> important exceptions:
> 
>   - pci_stub allows the admin to block driver binding on a device and
>     make it permanently shared with userspace. Since PCI stub does not
>     do DMA it is safe, however the admin must understand that using
>     pci_stub allows userspace to attack whatever device it was bound
>     it.
> 
>   - PCI bridges are sometimes included in groups. Typically PCI bridges
>     do not use DMA, and generally do not have MMIO regions.
> 
> Generally any device that does not have any MMIO registers is a
> possible candidate for an exception.
> 
> Currently vfio adopts a workaround to detect violations of the above
> restrictions by monitoring the driver core BOUND event, and hardwiring
> the above exceptions. Since there is no way for vfio to reject driver
> binding at this point, BUG_ON() is triggered if a violation is
> captured (kernel driver BOUND event on a group which already has some
> devices assigned to userspace). Aside from the bad user experience
> this opens a way for root userspace to crash the kernel, even in high
> integrity configurations, by manipulating the module binding and
> triggering the BUG_ON.
> 
> This series solves this problem by making the user/kernel ownership a
> core concept at the IOMMU layer. The driver core enforces kernel
> ownership while drivers are bound and violations now result in a error
> codes during probe, not BUG_ON failures.
> 
> Patch partitions:
>    [PATCH 1-7]: Detect DMA ownership conflicts during driver binding;
>    [PATCH 8-10]: Add security context management for assigned devices;
>    [PATCH 11-14]: Various cleanups.
> 
> This is also part one of three initial series for IOMMUFD:
>   * Move IOMMU Group security into the iommu layer
>   - Generic IOMMUFD implementation
>   - VFIO ability to consume IOMMUFD

Thank you very much for your comments. A new version of this series has
been posted here:

https://lore.kernel.org/linux-iommu/20220218005521.172832-1-baolu.lu@linux.intel.com/

Best regards,
baolu
