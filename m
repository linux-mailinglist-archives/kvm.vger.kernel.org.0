Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B1C5B3306
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 11:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbiIIJGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 05:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiIIJGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 05:06:12 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60BD3578A4
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 02:06:06 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DEAA15DB;
        Fri,  9 Sep 2022 02:06:12 -0700 (PDT)
Received: from [10.57.15.197] (unknown [10.57.15.197])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8D503F73D;
        Fri,  9 Sep 2022 02:06:03 -0700 (PDT)
Message-ID: <38bac59a-808d-5e91-227a-a3a06633c091@arm.com>
Date:   Fri, 9 Sep 2022 10:05:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4/4] iommu: Fix ordering of iommu_release_device()
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Qian Cai <cai@lca.pw>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
References: <4-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
 <87b7041e-bc8d-500c-7167-04190e3795a9@arm.com>
 <ada74e00-77e1-770b-f0b7-a4c43a86c06f@arm.com> <YxpiBEbGHECGGq5Q@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <YxpiBEbGHECGGq5Q@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-08 22:43, Jason Gunthorpe wrote:
> On Thu, Sep 08, 2022 at 10:27:06PM +0100, Robin Murphy wrote:
> 
>> Oh, because s390 is using iommu_get_domain_for_dev() in its release_device
>> callback, which needs to dereference the group to work, and the current
>> domain may also be a non-default one which we can't prevent from
>> disappearing racily, that was why :(
> 
> Hum, the issue there is the use of device->iommu_group - but that just
> means I didn't split properly. How about this incremental:

That did cross my mind, but it's a bit grim. In the light of the 
morning, I'm not sure s390 actually *needs* the group anyway - AFAICS if 
iommu_group_remove_device() has been processed first, that will have 
synchronised against any concurrent attach/detach, so zdev->s390_domain 
can be assumed to be up to date and used directly without the round trip 
through iommu_get_domain_for_dev(). That then only leaves the issue that 
that domain may still become invalid at any point after the group mutex 
has been dropped.

> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index c451bf715182ac..99ef799f3fe6b5 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -351,6 +351,7 @@ void iommu_release_device(struct device *dev)
>   	 * them until the have been detached. release_device() is expected to
>   	 * detach all domains connected to the dev.
>   	 */
> +	dev->iommu_group = NULL;
>   	kobject_put(group->devices_kobj);
>   
>   	module_put(ops->owner);
> @@ -980,7 +981,6 @@ static void __iommu_group_remove_device(struct device *dev)
>   
>   	kfree(device->name);
>   	kfree(device);
> -	dev->iommu_group = NULL;
>   }
>   
>   /**
> @@ -995,6 +995,7 @@ void iommu_group_remove_device(struct device *dev)
>   	struct iommu_group *group = dev->iommu_group;
>   
>   	__iommu_group_remove_device(dev);
> +	dev->iommu_group = NULL;
>   	kobject_put(group->devices_kobj);
>   }
>   EXPORT_SYMBOL_GPL(iommu_group_remove_device);
> 
> To me it makes sense that the driver should be able to continue to
> query the iommu_group during release anyhow..

I'm not so sure, release shouldn't be depending on a group since there 
may never have been one anyway. Perhaps the answer is an extra 
pre-release step to balance probe_finalize?

> And to your other question, the reason I split the function is because
> I couldn't really say WTF iommu_group_remove_device() was supposed to
> do. The __ version make ssense as part of the remove_device, due to
> the sequencing with ops->release()
> 
> But the other one doesn't have that. So I want to put in a:
> 
>     WARN_ON(group->blocking_domain || group->default_domain);
> 
> Because calling it after those domains are allocated looks broken to
> me.

I might be misunderstanding, but that sounds backwards - if a real 
device is being hotplugged out, we absolutely expect that to happen 
*after* its default domain has been set up. The external callers are 
using fake groups where default domains aren't relevant, and I have no 
idea what PAMU is doing but it's been doing it for long enough that it 
most likely isn't a problem. Thus wherever that check would be it would 
seem either wrong or unnecessary.

Thanks,
Robin.
