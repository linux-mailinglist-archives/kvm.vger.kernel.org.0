Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B6B397FF4
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 06:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhFBEE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 00:04:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:17203 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhFBEEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 00:04:55 -0400
IronPort-SDR: g7XK89bJVYoVDnoQYXUtv+YRMEkWhflcae+ihNedlMDrqjSVEcF3UBwQdoIOXOSS29yjM/jC8u
 EeypsEyYUUjg==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="267570812"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="267570812"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 21:03:11 -0700
IronPort-SDR: V9eBiB+ZDFfyGl+fsz0VEAaNwG6svY2fMybzF6dlHd6Z7lfZQxaLPC0XaesqnjDvvIOCAY1gD5
 /jNmg8dQnM8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="633093086"
Received: from allen-box.sh.intel.com (HELO [10.239.159.105]) ([10.239.159.105])
  by fmsmga006.fm.intel.com with ESMTP; 01 Jun 2021 21:03:06 -0700
Cc:     baolu.lu@linux.intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
 <786295f7-b154-cf28-3f4c-434426e897d3@linux.intel.com>
 <20210601172652.GK1002214@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <99c765d2-5fd3-002c-7c7a-408a17433068@linux.intel.com>
Date:   Wed, 2 Jun 2021 12:01:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210601172652.GK1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/21 1:26 AM, Jason Gunthorpe wrote:
> On Tue, Jun 01, 2021 at 07:09:21PM +0800, Lu Baolu wrote:
> 
>> This version only covers 1) and 4). Do you think we need to support 2),
>> 3) and beyond?
> 
> Yes aboslutely. The API should be flexable enough to specify the
> creation of all future page table formats we'd want to have and all HW
> specific details on those formats.

OK, stay in the same line.

>> If so, it seems that we need some in-kernel helpers and uAPIs to
>> support pre-installing a page table to IOASID.
> 
> Not sure what this means..

Sorry that I didn't make this clear.

Let me bring back the page table types in my eyes.

  1) IOMMU format page table (a.k.a. iommu_domain)
  2) user application CPU page table (SVA for example)
  3) KVM EPT (future option)
  4) VM guest managed page table (nesting mode)

Each type of page table should be able to be associated with its IOASID.
We have BIND protocol for 4); We explicitly allocate an iommu_domain for
1). But we don't have a clear definition for 2) 3) and others. I think
it's necessary to clearly define a time point and kAPI name between
IOASID_ALLOC and IOASID_ATTACH, so that other modules have the
opportunity to associate their page table with the allocated IOASID
before attaching the page table to the real IOMMU hardware.

I/O page fault handling is similar. The provider of the page table
should take the responsibility to handle the possible page faults.

Could this answer the question of "I'm still confused why drivers need
fault handlers at all?" in below thread?

https://lore.kernel.org/linux-iommu/PH0PR12MB54811863B392C644E5365446DC3E9@PH0PR12MB5481.namprd12.prod.outlook.com/T/#m15def9e8b236dfcf97e21c8e9f8a58da214e3691

> 
>>  From this point of view an IOASID is actually not just a variant of
>> iommu_domain, but an I/O page table representation in a broader
>> sense.
> 
> Yes, and things need to evolve in a staged way. The ioctl API should
> have room for this growth but you need to start out with some
> constrained enough to actually implement then figure out how to grow
> from there

Yes, agreed. I just think about it from the perspective of a design
document.

Best regards,
baolu
