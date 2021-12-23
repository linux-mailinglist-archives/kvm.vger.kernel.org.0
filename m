Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCD947DED0
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 06:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346473AbhLWFx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 00:53:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:11564 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346414AbhLWFx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 00:53:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640238838; x=1671774838;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=EJjYJ7Cr3tVFw0Vr+JPuTIrLmmS8N/v/trBre9WGS+g=;
  b=IBRMxlJ95SyNFKIrWz5aZP6SrjF8LT6R0jZwjdETiqQ+JwIhB1B/+Do9
   8JWKKT/1IlqBUr+c7AzSwEXxCCyjSe8uFoVR7yZMFHXS4nsYkDpZTaEFi
   WcH1P+iWz64Qlf+I8CAnz0KPfDdDLM7YqXxzTAFXvDr/XQYEkzPUbWs5k
   JjNupeEOTKGqjQ4I7yXa6CYLaMtX+0pM4joi22Pwwrzlh6i/cKLm4JdRa
   kO/LAxbTGyeozraLMsdM8tlKI70qpeewwm4xiNvp6XTRHuunPzBP21KX6
   WWW2TH9KyQp4xyFnKSxy3SuAqRqURpW7gSYCfmGkxYWIzB0LT33Yhu39w
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="264971130"
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="264971130"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 21:53:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="664485716"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 22 Dec 2021 21:53:48 -0800
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
 <aebbd9c7-a239-0f89-972b-a9059e8b218b@arm.com>
 <20211223005712.GA1779224@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <fea0fc91-ac4c-dfe4-f491-5f906bea08bd@linux.intel.com>
Date:   Thu, 23 Dec 2021 13:53:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211223005712.GA1779224@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robin and Jason,

On 12/23/21 8:57 AM, Jason Gunthorpe wrote:
> On Wed, Dec 22, 2021 at 08:26:34PM +0000, Robin Murphy wrote:
>> On 21/12/2021 6:46 pm, Jason Gunthorpe wrote:
>>> On Tue, Dec 21, 2021 at 04:50:56PM +0000, Robin Murphy wrote:
>>>
>>>> this proposal is the worst of both worlds, in that drivers still have to be
>>>> just as aware of groups in order to know whether to call the _shared
>>>> interface or not, except it's now entirely implicit and non-obvious.
>>>
>>> Drivers are not aware of groups, where did you see that?
>>
>> `git grep iommu_attach_group -- :^drivers/iommu :^include`
>>
>> Did I really have to explain that?
> 
> Well, yes you did, because it shows you haven't understood my
> question. After this series we deleted all those calls (though Lu, we
> missed one of the tegra ones in staging, let's get it for the next
> posting)

Yes, I will.

> 
> So, after this series, where do you see drivers being aware of groups?
> If things are missed lets expect to fix them.
> 
>>> If the driver uses multiple struct devices and intends to connect them
>>> all to the same domain then it uses the _shared variant. The only
>>> difference between the two is the _shared varient lacks some of the
>>> protections against driver abuse of the API.
>>
>> You've lost me again; how are those intentions any different? Attaching one
>> device to a private domain is a literal subset of attaching more than one
>> device to a private domain.
> 
> Yes it is a subset, but drivers will malfunction if they are not
> designed to have multi-attachment and wrongly get it, and there is
> only one driver that does actually need this.
> 
> I maintain a big driver subsystem and have learned that grepability of
> the driver mess for special cases is quite a good thing to
> have. Forcing drivers to mark in code when they do something weird is
> an advantage, even if it causes some small API redundancy.
> 
> However, if you really feel strongly this should really be one API
> with the _shared implementation I won't argue it any further.
> 
>> So then we have the iommu_attach_group() interface for new code (and still
>> nobody has got round to updating the old code to it yet), for which
>> the
> 
> This series is going in the direction of eliminating
> iommu_attach_group() as part of the driver
> interface. iommu_attach_group() is repurposed to only be useful for
> VFIO.

We can also remove iommu_attach_group() in VFIO because it is
essentially equivalent to

	iommu_group_for_each_dev(group, iommu_attach_device(dev))

> 
>> properly, or iommu_attach_group() with a potentially better interface and
>> actual safety. The former is still more prevalent (and the interface
>> argument compelling), so if we put the new implementation behind that, with
>> the one tweak of having it set DMA_OWNER_PRIVATE_DOMAIN automatically, kill
>> off iommu_attach_group() by converting its couple of users,
> 
> This is what we did, iommu_attach_device() & _shared() are to be the
> only interface for the drivers, and we killed off the
> iommu_attach_group() couple of users except VFIO (the miss of
> drivers/staging excepted)
> 
>> and not only have we solved the VFIO problem but we've also finally
>> updated all the legacy code for free! Of course you can have a
>> separate version for VFIO to attach with
>> DMA_OWNER_PRIVATE_DOMAIN_USER if you like, although I still fail to
>> understand the necessity of the distinction.
> 
> And the seperate version for VFIO is called 'iommu_attach_group()'.
> 
> Lu, it is probably a good idea to add an assertion here that the group
> is in DMA_OWNER_PRIVATE_DOMAIN_USER to make it clear that
> iommu_attach_group() is only for VFIO.
> 
> VFIO has a special requirement that it be able to do:
> 
> +       ret = iommu_group_set_dma_owner(group->iommu_group,
> +                                       DMA_OWNER_PRIVATE_DOMAIN_USER, f.file);
> 
> Without having a iommu_domain to attach.
> 
> This is because of the giant special case that PPC made of VFIO's
> IOMMU code. PPC (aka vfio_iommu_spapr_tce.c) requires the group
> isolation that iommu_group_set_dma_owner() provides, but does not
> actually have an iommu_domain and can not/does not call
> iommu_attach_group().
> 
> Fixing this is a whole other giant adventure I'm hoping David will
> help me unwind next year..
> 
> This series solves this problem by using the two step sequence of
> iommu_group_set_dma_owner()/iommu_attach_group() and conceptually
> redefining how iommu_attach_group() works to require the external
> caller to have done the iommu_group_set_dma_owner() for it. This is
> why the series has three APIs, because the VFIO special one assumes
> external iommu_group_set_dma_owner(). It just happens that is exactly
> the same code as iommu_attach_group() today.
> 
> As for why does DMA_OWNER_PRIVATE_DOMAIN_USER exist? VFIO doesn't have
> an iommu_domain at this point but it still needs the iommu core to
> detatch the default domain. This is what the _USER does.

There is also a contract that after the USER ownership is claimed the
device could be accessed by userspace through the MMIO registers. So,
a device could be accessible by userspace before a user-space I/O
address is attached.

> 
> Soo..
> 
> There is another way to organize this and perhaps it does make more
> sense. I will try to sketch briefly in email, try to imagine the
> gaps..
> 
> API family (== compares to this series):
> 
>     iommu_device_use_dma_api(dev);
>       == iommu_device_set_dma_owner(dev, DMA_OWNER_DMA_API, NULL);
> 
>     iommu_group_set_dma_owner(group, file);
>       == iommu_device_set_dma_owner(dev, DMA_OWNER_PRIVATE_DOMAIN_USER,
>                                     file);
>       Always detaches all domains from the group

I hope we can drop all group variant APIs as we already have the per-
device interfaces, just iterate all device in the group and call the
device API.

> 
>     iommu_attach_device(domain, dev)
>       == as is in this patch
>       dev and domain are 1:1
> 
>     iommu_attach_device_shared(domain, dev)
>       == as is in this patch
>       dev and domain are N:1
>       * could just be the same as iommu_attach_device
> 
>     iommu_replace_group_domain(group, old_domain, new_domain)
>       Makes group point at new_domain. new_domain can be NULL.
> 
>     iommu_device_unuse_dma_api(dev)
>      == iommu_device_release_dma_owner() in this patch
> 
>     iommu_group_release_dma_owner(group)
>      == iommu_detatch_group() && iommu_group_release_dma_owner()
> 
> VFIO would use the sequence:
> 
>     iommu_group_set_dma_owner(group, file);
>     iommu_replace_group_domain(group, NULL, domain_1);
>     iommu_replace_group_domain(group, domain_1, domain_2);
>     iommu_group_release_dma_owner(group);
> 
> Simple devices would use
> 
>     iommu_attach_device(domain, dev);
>     iommu_detatch_device(domain, dev);
> 
> Tegra would use:
> 
>     iommu_attach_device_shared(domain, dev);
>     iommu_detatch_device_shared(domain, dev);
>     // Or not, if people agree we should not mark this
> 
> DMA API would have the driver core dma_configure do:
>     iommu_device_use_dma_api(dev);
>     dev->driver->probe()
>     iommu_device_unuse_dma_api(dev);
> 
> It is more APIs overall, but perhaps they have a much clearer
> purpose.
> 
> I think it would be clear why iommu_group_set_dma_owner(), which
> actually does detatch, is not the same thing as iommu_attach_device().

iommu_device_set_dma_owner() will eventually call
iommu_group_set_dma_owner(). I didn't get why
iommu_group_set_dma_owner() is special and need to keep.

> 
> I'm not sure if this entirely eliminates
> DMA_OWNER_PRIVATE_DOMAIN_USER, or not, but at least it isn't in the
> API.
> 
> Is it better?

Perhaps I missed anything. I have a simpler idea. We only need to have
below interfaces:

	iommu_device_set_dma_owner(dev, owner);
	iommu_device_release_dma_owner(dev, owner);
	iommu_attach_device(domain, dev, owner);
	iommu_detach_device(domain, dev);

All existing drivers calling iommu_attach_device() remain unchanged
since we already have singleton group enforcement. We only need to add
a default owner type.

For multiple-device group, like drm/tegra, the drivers should claim the
PRIVATE_DOMAIN ownership and call iommu_attach_device(domain, dev,
PRIVATE_DOMAIN) explicitly.

The new iommu_attach_device(domain, dev, owner) is a mix of the existing
iommu_attach_device() and the new iommu_attach_device_shared(). That
means,
	if (group_is_singleton(group))
		__iommu_atttach_device(domain, dev)
	else
		__iommu_attach_device_shared(domain, dev, owner)

The group variant interfaces will be deprecated and replace with the
device ones.

Sorry if I missed anything.

> 
>> What VFIO wants is (conceptually[1]) "attach this device to my domain,
>> provided it and any other devices in its group are managed by a driver I
>> approve of."
> 
> Yes, sure, "conceptually". But, there are troublesome details.
> 
>> VFIO will also need a struct device anyway, because once I get back from my
>> holiday in the new year I need to start working with Simon on evolving the
>> rest of the API away from bus->iommu_ops to dev->iommu so we can finally
>> support IOMMU drivers coexisting[2].
> 
> For VFIO it would be much easier to get the ops from the struct
> iommu_group (eg via iommu_group->default_domain->ops, or whatever).
> 
>> Indeed I agree with that second point, I'm just increasingly baffled how
>> it's not clear to you that there is only one fundamental use-case here.
>> Perhaps I'm too familiar with the history to objectively see how unclear the
>> current state of things might be :/
> 
> I think it is because you are just not familiar with the dark corners
> of VFIO.
> 
> VFIO has a special case, I outlined above.
> 
>>> This is taking 426a to it's logical conclusion and *removing* the
>>> group API from the drivers entirely. This is desirable because drivers
>>> cannot do anything sane with the group.
>>
>> I am in complete agreement with that (to the point of also not liking patch
>> #6).
> 
> Unfortunately patch #6 is only because of VFIO needing to use the
> group as a handle.
> 
> Jason
> 

Best regards,
baolu
