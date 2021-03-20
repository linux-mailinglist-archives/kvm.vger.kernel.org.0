Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC243429B0
	for <lists+kvm@lfdr.de>; Sat, 20 Mar 2021 02:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCTBpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 21:45:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:43732 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhCTBpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 21:45:17 -0400
IronPort-SDR: Lz/LpxC7e0d1jAPkbWAU2spIsZLvNWRkKUvzn93d+abforymElgq+2XRts5GfQnBPEovh+asVc
 UrA3ZOQKEt4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="187648941"
X-IronPort-AV: E=Sophos;i="5.81,263,1610438400"; 
   d="scan'208";a="187648941"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 18:45:16 -0700
IronPort-SDR: 5lfyrfVrckDT5ZZHgzNpYWp2DkrpJQhnxaL5wEvszF0JgOFLCb+B97qxxsCB5iUoOc3NNW1j4N
 6hrC2Z26QGbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,263,1610438400"; 
   d="scan'208";a="434474330"
Received: from allen-box.sh.intel.com (HELO [10.239.159.128]) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 19 Mar 2021 18:45:11 -0700
Cc:     baolu.lu@linux.intel.com, Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
To:     Keqian Zhu <zhukeqian1@huawei.com>,
        Shenming Lu <lushenming@huawei.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210129155730.3a1d49c5@omen.home.shazbot.org>
 <MWHPR11MB188684B42632FD0B9B5CA1C08CB69@MWHPR11MB1886.namprd11.prod.outlook.com>
 <47bf7612-4fb0-c0bb-fa19-24c4e3d01d3f@huawei.com>
 <MWHPR11MB1886C71A751B48EF626CAC938CB39@MWHPR11MB1886.namprd11.prod.outlook.com>
 <4f904b23-e434-d42b-15a9-a410f3b4edb9@huawei.com>
 <MWHPR11MB188656845973A662A7E96BDA8C699@MWHPR11MB1886.namprd11.prod.outlook.com>
 <c152f419-acc4-ee33-dab1-ff0f9baf2f24@huawei.com>
 <a535a91a-3af7-b43d-8399-01255a070f2b@linux.intel.com>
 <4327b3ac-858d-30d0-9fe4-bd4ccc0fbd40@huawei.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <993b34b0-a68e-87eb-854d-ce926db8702b@linux.intel.com>
Date:   Sat, 20 Mar 2021 09:35:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4327b3ac-858d-30d0-9fe4-bd4ccc0fbd40@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/19/21 9:30 AM, Keqian Zhu wrote:
> Hi Baolu,
> 
> On 2021/3/19 8:33, Lu Baolu wrote:
>> On 3/18/21 7:53 PM, Shenming Lu wrote:
>>> On 2021/3/18 17:07, Tian, Kevin wrote:
>>>>> From: Shenming Lu<lushenming@huawei.com>
>>>>> Sent: Thursday, March 18, 2021 3:53 PM
>>>>>
>>>>> On 2021/2/4 14:52, Tian, Kevin wrote:>>> In reality, many
>>>>>>>> devices allow I/O faulting only in selective contexts. However, there
>>>>>>>> is no standard way (e.g. PCISIG) for the device to report whether
>>>>>>>> arbitrary I/O fault is allowed. Then we may have to maintain device
>>>>>>>> specific knowledge in software, e.g. in an opt-in table to list devices
>>>>>>>> which allows arbitrary faults. For devices which only support selective
>>>>>>>> faulting, a mediator (either through vendor extensions on vfio-pci-core
>>>>>>>> or a mdev wrapper) might be necessary to help lock down non-faultable
>>>>>>>> mappings and then enable faulting on the rest mappings.
>>>>>>> For devices which only support selective faulting, they could tell it to the
>>>>>>> IOMMU driver and let it filter out non-faultable faults? Do I get it wrong?
>>>>>> Not exactly to IOMMU driver. There is already a vfio_pin_pages() for
>>>>>> selectively page-pinning. The matter is that 'they' imply some device
>>>>>> specific logic to decide which pages must be pinned and such knowledge
>>>>>> is outside of VFIO.
>>>>>>
>>>>>>   From enabling p.o.v we could possibly do it in phased approach. First
>>>>>> handles devices which tolerate arbitrary DMA faults, and then extends
>>>>>> to devices with selective-faulting. The former is simpler, but with one
>>>>>> main open whether we want to maintain such device IDs in a static
>>>>>> table in VFIO or rely on some hints from other components (e.g. PF
>>>>>> driver in VF assignment case). Let's see how Alex thinks about it.
>>>>> Hi Kevin,
>>>>>
>>>>> You mentioned selective-faulting some time ago. I still have some doubt
>>>>> about it:
>>>>> There is already a vfio_pin_pages() which is used for limiting the IOMMU
>>>>> group dirty scope to pinned pages, could it also be used for indicating
>>>>> the faultable scope is limited to the pinned pages and the rest mappings
>>>>> is non-faultable that should be pinned and mapped immediately? But it
>>>>> seems to be a little weird and not exactly to what you meant... I will
>>>>> be grateful if you can help to explain further.:-)
>>>>>
>>>> The opposite, i.e. the vendor driver uses vfio_pin_pages to lock down
>>>> pages that are not faultable (based on its specific knowledge) and then
>>>> the rest memory becomes faultable.
>>> Ahh...
>>> Thus, from the perspective of VFIO IOMMU, if IOPF enabled for such device,
>>> only the page faults within the pinned range are valid in the registered
>>> iommu fault handler...
>> Isn't it opposite? The pinned pages will never generate any page faults.
>> I might miss some contexts here.
> It seems that vfio_pin_pages() just pin some pages and record the pinned scope to pfn_list of vfio_dma.
> No mapping is established, so we still has page faults.

Make sense. Thanks a lot for the explanation.

> 
> IIUC, vfio_pin_pages() is used to
> 1. pin pages for non-iommu backed devices.
> 2. mark dirty scope for non-iommu backed devices and iommu backed devices.

Best regards,
baolu
