Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A556A5B19E7
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 12:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiIHK0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 06:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiIHK0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 06:26:09 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C9968A7D0;
        Thu,  8 Sep 2022 03:26:08 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94A8D14BF;
        Thu,  8 Sep 2022 03:26:14 -0700 (PDT)
Received: from [10.57.15.197] (unknown [10.57.15.197])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D059C3F71A;
        Thu,  8 Sep 2022 03:25:52 -0700 (PDT)
Message-ID: <7ef259b2-121e-643e-49c2-0b65923d392d@arm.com>
Date:   Thu, 8 Sep 2022 11:25:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
        alex.williamson@redhat.com, suravee.suthikulpanit@amd.com,
        marcan@marcan.st, sven@svenpeter.dev, alyssa@rosenzweig.io,
        robdclark@gmail.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        orsonzhai@gmail.com, baolin.wang@linux.alibaba.com,
        zhang.lyra@gmail.com, thierry.reding@gmail.com, vdumpa@nvidia.com,
        jonathanh@nvidia.com, jean-philippe@linaro.org, cohuck@redhat.com,
        tglx@linutronix.de, shameerali.kolothum.thodi@huawei.com,
        thunder.leizhen@huawei.com, christophe.jaillet@wanadoo.fr,
        yangyingliang@huawei.com, jon@solid-run.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        kevin.tian@intel.com
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com> <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com> <9f91f187-2767-13f9-68a2-a5458b888f00@arm.com>
 <YxjOPo5FFqu2vE/g@nvidia.com> <0b466705-3a17-1bbc-7ef2-5adadc22d1ae@arm.com>
 <Yxk6sR4JiAAn3Jf5@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <Yxk6sR4JiAAn3Jf5@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-08 01:43, Jason Gunthorpe wrote:
> On Wed, Sep 07, 2022 at 08:41:13PM +0100, Robin Murphy wrote:
> 
>>>> FWIW, we're now very close to being able to validate dev->iommu against
>>>> where the domain came from in core code, and so short-circuit ->attach_dev
>>>> entirely if they don't match.
>>>
>>> I don't think this is a long term direction. We have systems now with
>>> a number of SMMU blocks and we really are going to see a need that
>>> they share the iommu_domains so we don't have unncessary overheads
>>> from duplicated io page table memory.
>>>
>>> So ultimately I'd expect to pass the iommu_domain to the driver and
>>> the driver will decide if the page table memory it represents is
>>> compatible or not. Restricting to only the same iommu instance isn't
>>> good..
>>
>> Who said IOMMU instance?
> 
> Ah, I completely misunderstood what 'dev->iommu' was referring too, OK
> I see.
> 
>> Again, not what I was suggesting. In fact the nature of iommu_attach_group()
>> already rules out bogus devices getting this far, so all a driver currently
>> has to worry about is compatibility of a device that it definitely probed
>> with a domain that it definitely allocated. Therefore, from a caller's point
>> of view, if attaching to an existing domain returns -EINVAL, try another
>> domain; multiple different existing domains can be tried, and may also
>> return -EINVAL for the same or different reasons; the final attempt is to
>> allocate a fresh domain and attach to that, which should always be nominally
>> valid and *never* return -EINVAL. If any attempt returns any other error,
>> bail out down the usual "this should have worked but something went wrong"
>> path. Even if any driver did have a nonsensical "nothing went wrong, I just
>> can't attach my device to any of my domains" case, I don't think it would
>> really need distinguishing from any other general error anyway.
> 
> The algorithm you described is exactly what this series does, it just
> used EMEDIUMTYPE instead of EINVAL. Changing it to EINVAL is not a
> fundamental problem, just a bit more work.
> 
> Looking at Nicolin's series there is a bunch of existing errnos that
> would still need converting, ie EXDEV, EBUSY, EOPNOTSUPP, EFAULT, and
> ENXIO are all returned as codes for 'domain incompatible with device'
> in various drivers. So the patch would still look much the same, just
> changing them to EINVAL instead of EMEDIUMTYPE.
> 
> That leaves the question of the remaining EINVAL's that Nicolin did
> not convert to EMEDIUMTYPE.
> 
> eg in the AMD driver:
> 
> 	if (!check_device(dev))
> 		return -EINVAL;
> 
> 	iommu = rlookup_amd_iommu(dev);
> 	if (!iommu)
> 		return -EINVAL;
> 
> These are all cases of 'something is really wrong with the device or
> iommu, everything will fail'. Other drivers are using ENODEV for this
> already, so we'd probably have an additional patch changing various
> places like that to ENODEV.
> 
> This mixture of error codes is the basic reason why a new code was
> used, because none of the existing codes are used with any
> consistency.
> 
> But OK, I'm on board, lets use more common errnos with specific
> meaning, that can be documented in a comment someplace:
>   ENOMEM - out of memory
>   ENODEV - no domain can attach, device or iommu is messed up
>   EINVAL - the domain is incompatible with the device
>   <others> - Same behavior as ENODEV, use is discouraged.
> 
> I think achieving consistency of error codes is a generally desirable
> goal, it makes the error code actually useful.
> 
> Joerg this is a good bit of work, will you be OK with it?
> 
>> Thus as long as we can maintain that basic guarantee that attaching
>> a group to a newly allocated domain can only ever fail for resource
>> allocation reasons and not some spurious "incompatibility", then we
>> don't need any obscure trickery, and a single, clear, error code is
>> in fact enough to say all that needs to be said.
> 
> As above, this is not the case, drivers do seem to have error paths
> that are unconditional on the domain. Perhaps they are just protective
> assertions and never happen.

Right, that's the gist of what I was getting at - I think it's worth 
putting in the effort to audit and fix the drivers so that that *can* be 
the case, then we can have a meaningful error API with standard codes 
effectively for free, rather than just sighing at the existing mess and 
building a slightly esoteric special case on top.

Case in point, the AMD checks quoted above are pointless, since it 
checks the same things in ->probe_device, and if that fails then the 
device won't get a group so there's no way for it to even reach 
->attach_dev any more. I'm sure there's a *lot* of cruft that can be 
cleared out now that per-device and per-domain ops give us this kind of 
inherent robustness.

Cheers,
Robin.

> Regardless, it doesn't matter. If they return ENODEV or EINVAL the
> VFIO side algorithm will continue to work fine, it just does alot more
> work if EINVAL is permanently returned.
> 
> Thanks,
> Jason
