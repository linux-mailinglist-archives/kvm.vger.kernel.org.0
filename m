Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F133B304F
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 15:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhFXNpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 09:45:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:58487 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229995AbhFXNpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 09:45:06 -0400
IronPort-SDR: nn2MIhyhL5NW5Z3V+3vCPOP44a8ipYAGb/z5z9Lji5smoldhBVlA/M2MmhonH9tj5pcQg6UQ1i
 6apbTg/OyHhw==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="187849764"
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="187849764"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 06:42:45 -0700
IronPort-SDR: YVydjBX0YkVAhLh+YMD18XTmbFpHR21zKnhNrxE0oaEHiBi9/M3tMpJYUok7tlhXE14j+MwZ07
 jTfscbHMjaxA==
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="487758610"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.211.177]) ([10.254.211.177])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 06:42:38 -0700
Cc:     baolu.lu@linux.intel.com, Jason Gunthorpe <jgg@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
To:     David Gibson <david@gibson.dropbear.id.au>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org> <20210609123919.GA1002214@nvidia.com>
 <14d884a8-13bc-b2ba-7020-94b219e3e2d9@linux.intel.com>
 <YMrcLcTL+cUKd1a5@yekko>
 <b9c48526-8b8f-ff9e-4ece-4a39f476e3b7@linux.intel.com>
 <YNQEClb1nptFBIRB@yekko>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <b77b9ffc-166e-3019-0328-59d20a437fd5@linux.intel.com>
Date:   Thu, 24 Jun 2021 21:42:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YNQEClb1nptFBIRB@yekko>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/6/24 12:03, David Gibson wrote:
> On Fri, Jun 18, 2021 at 01:21:47PM +0800, Lu Baolu wrote:
>> Hi David,
>>
>> On 6/17/21 1:22 PM, David Gibson wrote:
>>>> The iommu_group can guarantee the isolation among different physical
>>>> devices (represented by RIDs). But when it comes to sub-devices (ex. mdev or
>>>> vDPA devices represented by RID + SSID), we have to rely on the
>>>> device driver for isolation. The devices which are able to generate sub-
>>>> devices should either use their own on-device mechanisms or use the
>>>> platform features like Intel Scalable IOV to isolate the sub-devices.
>>> This seems like a misunderstanding of groups.  Groups are not tied to
>>> any PCI meaning.  Groups are the smallest unit of isolation, no matter
>>> what is providing that isolation.
>>>
>>> If mdevs are isolated from each other by clever software, even though
>>> they're on the same PCI device they are in different groups from each
>>> other*by definition*.  They are also in a different group from their
>>> parent device (however the mdevs only exist when mdev driver is
>>> active, which implies that the parent device's group is owned by the
>>> kernel).
>>
>> You are right. This is also my understanding of an "isolation group".
>>
>> But, as I understand it, iommu_group is only the isolation group visible
>> to IOMMU. When we talk about sub-devices (sw-mdev or mdev w/ pasid),
>> only the device and device driver knows the details of isolation, hence
>> iommu_group could not be extended to cover them. The device drivers
>> should define their own isolation groups.
> So, "iommu group" isn't a perfect name.  It came about because
> originally the main mechanism for isolation was the IOMMU, so it was
> typically the IOMMU's capabilities that determined if devices were
> isolated.  However it was always known that there could be other
> reasons for failure of isolation.  To simplify the model we decided
> that we'd put things into the same group if they were non-isolated for
> any reason.

Yes.

> 
> The kernel has no notion of "isolation group" as distinct from "iommu
> group".  What are called iommu groups in the kernel now*are*
> "isolation groups" and that was always the intention - it's just not a
> great name.

Fair enough.

> 
>> Otherwise, the device driver has to fake an iommu_group and add hacky
>> code to link the related IOMMU elements (iommu device, domain, group
>> etc.) together. Actually this is part of the problem that this proposal
>> tries to solve.
> Yeah, that's not ideal.
> 
>>>> Under above conditions, different sub-device from a same RID device
>>>> could be able to use different IOASID. This seems to means that we can't
>>>> support mixed mode where, for example, two RIDs share an iommu_group and
>>>> one (or both) of them have sub-devices.
>>> That doesn't necessarily follow.  mdevs which can be successfully
>>> isolated by their mdev driver are in a different group from their
>>> parent device, and therefore need not be affected by whether the
>>> parent device shares a group with some other physical device.  They
>>> *might*   be, but that's up to the mdev driver to determine based on
>>> what it can safely isolate.
>>>
>> If we understand it as multiple levels of isolation, can we classify the
>> devices into the following categories?
>>
>> 1) Legacy devices
>>     - devices without device-level isolation
>>     - multiple devices could sit in a single iommu_group
>>     - only a single I/O address space could be bound to IOMMU
> I'm not really clear on what that last statement means.

I mean a single iommu_domain should be used by all devices sharing a
single iommu_group.

> 
>> 2) Modern devices
>>     - devices capable of device-level isolation
> This will*typically*  be true of modern devices, but I don't think we
> can really make it a hard API distinction.  Legacy or buggy bridges
> can force modern devices into the same group as each other.  Modern
> devices are not immune from bugs which would force lack of isolation
> (e.g. forgotten debug registers on function 0 which affect other
> functions).
> 

Yes.

I am thinking whether it's feasible to change "bind/attach a device to
an IOASID" to "bind/attach an isolated unit to an IOASID". An isolated
unit could be

1) an iommu_ group including single or multiple devices;
2) a physical device which have a 1-device iommu group + device ID
    (PASID/subStreamID) which represents an isolated subdevice inside the
    physical one.
3) anything that we might have in the future.

A handler which represents the connection between device and iommu is
returned on any successful binding. This handler could be used to
GET_INFO and attach/detach after binding.

Best regards,
baolu
