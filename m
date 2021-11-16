Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CB0452A54
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 07:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238174AbhKPGJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 01:09:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:3868 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232933AbhKPGIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 01:08:36 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="294448235"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="294448235"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 22:05:34 -0800
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="454327607"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.215.107]) ([10.254.215.107])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 22:05:29 -0800
Message-ID: <c7add816-853a-c31d-6425-464512a2de61@linux.intel.com>
Date:   Tue, 16 Nov 2021 14:05:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
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
References: <20211115221747.GA1587608@bhelgaas>
Content-Language: en-US
Subject: Re: [PATCH 03/11] PCI: pci_stub: Suppress kernel DMA ownership
 auto-claiming
In-Reply-To: <20211115221747.GA1587608@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bjorn,

On 11/16/21 6:17 AM, Bjorn Helgaas wrote:
> On Mon, Nov 15, 2021 at 10:05:44AM +0800, Lu Baolu wrote:
>> pci_stub allows the admin to block driver binding on a device and make
>> it permanently shared with userspace. Since pci_stub does not do DMA,
>> it is safe. However the admin must understand that using pci_stub allows
>> userspace to attack whatever device it was bound to.
> This commit log doesn't say what the patch does.  I think it tells us
> something about what pci-stub*already*  does ("allows admin to block
> driver binding") and something about why that is safe ("does not do
> DMA").

Yes, you are right. This patch is to keep the pci_stub's existing use
case ("allows admin to block driver binding") after moving the viable
check from the vfio to iommu layer (done by this series).

About "safe" (should not be part of this description), there are two
sides from my understanding:

#1) The pci_stub driver itself doesn't control the device to do any DMA.
     So it won't interfere the user space through device DMA.

#2) The pci_stub driver doesn't access the PCI bar and doesn't build any
     device driver state around any value in the bar. So other devices
     in the same iommu group (assigned to user space) have no means to
     change the kernel driver consistency via p2p access.
> 
> But it doesn't say what this patch changes.  Based on the subject
> line, I expected something like:
> 
>    As of ("<commit subject>"), <some function>() marks the iommu_group
>    as containing only devices with kernel drivers that manage DMA.
> 
>    Avoid this default behavior for pci-stub because it does not program
>    any DMA itself.  This allows <some desirable behavior>.
> 

Sure. I will rephrase the description like above.

Best regards,
baolu
