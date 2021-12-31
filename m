Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4873848215B
	for <lists+kvm@lfdr.de>; Fri, 31 Dec 2021 02:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242535AbhLaB6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 20:58:53 -0500
Received: from mga07.intel.com ([134.134.136.100]:20260 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhLaB6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 20:58:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640915932; x=1672451932;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=5DUIS3fYDXtA8WzqPnxiZ6jJAXuU/rSnDLDZK5j56bA=;
  b=mIuKVIkEPjHCGEh5mu16SS6FQJ85IAmbWulyiyHJhOscm+2JUtbH3lOx
   D594wIiMjGz3atlBQOf9gDZhbX3JyifUYFWo0cI+Z9Eebki2kE/w8pEW5
   Clw20mzVKcz3KpludUVxxUGn2hcsNLkyi1fYAurUBCi9FlIn4XTXqShr7
   WAH7s85xUz/IvA7qHX1oBEcItqnTxcWSaNnpL3nCDoXIDKFHK8tQwai2Y
   cgaH/TJLT+0fla2xHG3qHgZZk6Gn2FyLymWf+Ln9jbDulU6M73DKQA28u
   o8EaiAYE1Fu+KO2IuWtELZDzalJM+1ab/NlcvVlo0WOdAb5fgTfpRjPV5
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10213"; a="305119217"
X-IronPort-AV: E=Sophos;i="5.88,250,1635231600"; 
   d="scan'208";a="305119217"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2021 17:58:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,250,1635231600"; 
   d="scan'208";a="524583164"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 30 Dec 2021 17:58:43 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v4 03/13] PCI: pci_stub: Suppress kernel DMA ownership
 auto-claiming
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Bjorn Helgaas <helgaas@kernel.org>
References: <568b6d1d-69df-98ad-a864-dd031bedd081@linux.intel.com>
 <20211230222414.GA1805873@bhelgaas> <20211231004019.GH1779224@nvidia.com>
 <5eb8650c-432f-bf06-c63d-6320199ef894@linux.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <9daec0aa-b58f-93b3-c8bb-b67ec6d84596@linux.intel.com>
Date:   Fri, 31 Dec 2021 09:58:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <5eb8650c-432f-bf06-c63d-6320199ef894@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/31/21 9:10 AM, Lu Baolu wrote:
> 
> On 12/31/21 8:40 AM, Jason Gunthorpe wrote:
>> On Thu, Dec 30, 2021 at 04:24:14PM -0600, Bjorn Helgaas wrote:
>>
>>> I was speculating that maybe the DMA ownership claiming must be done
>>> *before* the driver's .probe() method?
>>
>> This is correct.
>>
>>> If DMA ownership could be claimed by the .probe() method, we
>>> wouldn't need the new flag in struct device_driver.
>>
>> The other requirement is that every existing driver must claim
>> ownership, so pushing this into the device driver's probe op would
>> require revising almost every driver in Linux...
>>
>> In effect the new flag indicates if the driver will do the DMA
>> ownership claim in it's probe, or should use the default claim the
>> core code does.
>>
>> In almost every case a driver should do a claim. A driver like
>> pci-stub, or a bridge, that doesn't actually operate MMIO on the
>> device would be the exception.
> 
> We still need to call iommu_device_use_dma_api() in bus dma_configure()
> callback. But we can call iommu_device_unuse_dma_api() in the .probe()
> of vfio (and vfio-approved) drivers, so that we don't need the new flag
> anymore.

Oh, wait. I didn't think about the hot-plug case. If we call
iommu_device_use_dma_api() in bus dma_configure() anyway, we can't bind
any (no matter vfio or none-vfio) driver to a device if it's group has
already been assigned to user space. It seems that we can't omit this
flag.

Best regards,
baolu
