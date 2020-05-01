Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAAE1C20AE
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 00:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgEAWci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 18:32:38 -0400
Received: from mga06.intel.com ([134.134.136.31]:10101 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726973AbgEAWci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 18:32:38 -0400
IronPort-SDR: 6XhZMxwOSrHnnVV+pXaZzoh111Ac1a3Fbrxa02BKsw9ff8RikcZJyGGMryLo0Yg+Zby1PzciCn
 37BotaS1XHew==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 15:32:36 -0700
IronPort-SDR: h0HDG6WOzMAx9Acn3e9Yz1/5hX+L6Tr04sNiBrKkZCQp2bg2OM3da5SAXcNd1kQG999b8gqGSy
 xxtLW+ogCo9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,341,1583222400"; 
   d="scan'208";a="248657143"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.251.135.85]) ([10.251.135.85])
  by fmsmga007.fm.intel.com with ESMTP; 01 May 2020 15:32:35 -0700
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        maz@kernel.org, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <d6b3c133-ac19-21af-b7a7-b9e7166b8166@linux.intel.com>
 <20200423194447.GF13640@mellanox.com>
From:   "Dey, Megha" <megha.dey@linux.intel.com>
Message-ID: <30dadd7a-bac2-d658-c2e4-77592de6118d@linux.intel.com>
Date:   Fri, 1 May 2020 15:32:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423194447.GF13640@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/23/2020 12:44 PM, Jason Gunthorpe wrote:
>>>> The mdev utilizes Interrupt Message Store or IMS[3] instead of MSIX for
>>>> interrupts for the guest. This preserves MSIX for host usages and also allows a
>>>> significantly larger number of interrupt vectors for guest usage.
>>>
>>> I never did get a reply to my earlier remarks on the IMS patches.
>>>
>>> The concept of a device specific addr/data table format for MSI is not
>>> Intel specific. This should be general code. We have a device that can
>>> use this kind of kernel capability today.
>>
>> I am sorry if I did not address your comments earlier.
> 
> It appears noboy from Intel bothered to answer anyone else on that RFC
> thread:
> 
> https://lore.kernel.org/lkml/1568338328-22458-1-git-send-email-megha.dey@linux.intel.com/
> 
> However, it seems kind of moot as I see now that this verion of IMS
> bears almost no resemblance to the original RFC.

hmm yeah, we changed most of the code after getting a lot of feedback 
from you and folks at plumbers. But yes, I should have replied to all 
the feedback, lesson learnt :)

> 
> That said, the similiarity to platform-msi was striking, does this new
> version harmonize with that?

yes!
> 
>> The present IMS code is quite generic, most of the code is in the drivers/
>> folder. We basically introduce 2 APIS: allocate and free IMS interrupts and
>> a IMS IRQ domain to allocate these interrupts from. These APIs are
>> architecture agnostic.
>>
>> We also introduce a new IMS IRQ domain which is architecture specific. This
>> is because IMS generates interrupts only in the remappable format, hence
>> interrupt remapping should be enabled for IMS. Currently, the interrupt
>> remapping code is only available for Intel and AMD and I don’t see anything
>> for ARM.
> 
> I don't understand these remarks though - IMS is simply the mapping of
> a MemWr addr/data pair to a Linux IRQ number? Why does this intersect
> with remapping?
> 

 From your comments so far, I think your requirement is a subset of what 
IMS is trying to do.

What you want:
have a dynamic means of allocating platform-msi interrupts

On top of this IMS has a requirement that all of the interrupts should 
be remapped.

So we can have tiered code: generic dynamic platform-msi infrastructure
and add the IMS specific bits (Intel specific) on top of this.

The generic code will have no reference to IMS.

> AFAIK, any platform that supports MSI today should have the inherent
> HW capability to support IMS.
> 
>> Also, could you give more details on the device that could use IMS? Do you
>> have some driver code already? We could then see if and how the current IMS
>> code could be made more generic.
> 
> We have several devices of interest, our NICs have very flexible PCI,
> so it is no problem to take the MemWR addr/data from someplace other
> than the MSI tables.
> 
> For this we want to have some way to allocate Linux IRQs dynamically
> and get a addr/data pair to trigger them.
> 
> Our NIC devices are also linked to our ARM SOC family, so I'd expect
> our ARM's to also be able to provide these APIs as the platform.

cool, so I will hope that you can test out the generic APIs from the ARM 
side!
> 
> Jason
> 
