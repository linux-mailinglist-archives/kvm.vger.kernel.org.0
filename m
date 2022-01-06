Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B00485F8F
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbiAFENW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:13:22 -0500
Received: from mga05.intel.com ([192.55.52.43]:24432 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232336AbiAFENW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:13:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641442402; x=1672978402;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=BPPq4Hy0QzoEWhfAavsXwLKXm6OXAgY5VvZzVitwyEM=;
  b=NxUsfKuULM6x1H6eZh/lLrRja8Pd4HWLBuyiFklaJ1kCvFgyZjFAathL
   Q6SMC4DMebADFW+4KBp9Xt5dXwsTApip2BkEkRH4Qf6XxbNoKf+clBssn
   XQZdTI6MIeUgziXv/08oE6bJzc/ALLRr94qITz5P8zbcotRe5rycYOtK6
   viR7X2jLgMrvOhPTQIVoyL2tvnQwI69eNV83K3ue33IzscdABLgZHCI6N
   JjhzMwwY4JfSQCVwzMCpO721qLFHM7J9OxrNDsGnjFuCAqdVVhsMvYyfx
   xkZEBEoKXqpjp2Go3A24YpV27Nus42VRwow7u44YmPn95MO2APnxBxOcu
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="328934820"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="328934820"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 20:13:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526821695"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 20:13:14 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v5 09/14] PCI: portdrv: Suppress kernel DMA ownership
 auto-claiming
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20220104170631.GA99771@bhelgaas>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <039bbcf3-ccc6-f3b0-172e-9caa0866bb9e@linux.intel.com>
Date:   Thu, 6 Jan 2022 12:12:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220104170631.GA99771@bhelgaas>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bjorn,

On 1/5/22 1:06 AM, Bjorn Helgaas wrote:
> On Tue, Jan 04, 2022 at 09:56:39AM +0800, Lu Baolu wrote:
>> If a switch lacks ACS P2P Request Redirect, a device below the switch can
>> bypass the IOMMU and DMA directly to other devices below the switch, so
>> all the downstream devices must be in the same IOMMU group as the switch
>> itself.
> Help me think through what's going on here.  IIUC, we put devices in
> the same IOMMU group when they can interfere with each other in any
> way (DMA, config access, etc).
> 
> (We said "DMA" above, but I guess this would also apply to config
> requests, right?)

I am not sure whether devices could interfere each other through config
space access. The IOMMU hardware only protects and isolates DMA
accesses, so that userspace could control DMA directly. The config
accesses will always be intercepted by VFIO. Hence, I don't see a
problem.

> 
> *This*  patch doesn't check for any ACS features.  Can you connect the
> dots for me?  I guess the presence or absence of P2P Request Redirect
> determines the size of the IOMMU group.  And the following says

It's done in iommu core (drivers/iommu/iommu.c):

/*
  * Use standard PCI bus topology, isolation features, and DMA alias quirks
  * to find or create an IOMMU group for a device.
  */
struct iommu_group *pci_device_group(struct device *dev)


> something about what is allowed in the group?  And .no_kernel_api_dma
> allows an exception to the general rule?
> 

Yes.

>> The pci_dma_configure() marks the iommu_group as containing only devices
>> with kernel drivers that manage DMA. Avoid this default behavior for the
>> portdrv driver in order for compatibility with the current vfio policy.
> I assume "IOMMU group" means the same as "iommu_group"; maybe we can
> use one of them consistently?

Sure.

Best regards,
baolu
