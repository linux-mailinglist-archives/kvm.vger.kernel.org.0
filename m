Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C625B3E6E
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 20:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiIISAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 14:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiIIR7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 13:59:44 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D28181449E7
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 10:58:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE84615DB;
        Fri,  9 Sep 2022 10:58:15 -0700 (PDT)
Received: from [10.57.15.197] (unknown [10.57.15.197])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60E333F73D;
        Fri,  9 Sep 2022 10:58:07 -0700 (PDT)
Message-ID: <e0ff6dc1-91b3-2e41-212c-c83a2bf2b3a8@arm.com>
Date:   Fri, 9 Sep 2022 18:57:59 +0100
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
 <38bac59a-808d-5e91-227a-a3a06633c091@arm.com> <Yxs+1s+MPENLTUpG@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <Yxs+1s+MPENLTUpG@nvidia.com>
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

On 2022-09-09 14:25, Jason Gunthorpe wrote:
> On Fri, Sep 09, 2022 at 10:05:58AM +0100, Robin Murphy wrote:
>> On 2022-09-08 22:43, Jason Gunthorpe wrote:
>>> On Thu, Sep 08, 2022 at 10:27:06PM +0100, Robin Murphy wrote:
>>>
>>>> Oh, because s390 is using iommu_get_domain_for_dev() in its release_device
>>>> callback, which needs to dereference the group to work, and the current
>>>> domain may also be a non-default one which we can't prevent from
>>>> disappearing racily, that was why :(
>>>
>>> Hum, the issue there is the use of device->iommu_group - but that just
>>> means I didn't split properly. How about this incremental:
>>
>> That did cross my mind, but it's a bit grim.
> 
> Actually, also in my morning, I think it may not even be necessary.
> 
> Keep in mind the start of the series fixes VFIO.
> 
> The bug that S390 is trying to fix is that VFIO didn't put back the
> group ownership, it just left its own iommu_domain attached and called
> release().
> 
> But now, at least for single device groups, VFIO will put owenership
> back and zdev->s390_domain == NULL when we get to release_device()
> 
>> That then only leaves the issue that that domain may still become
>> invalid at any point after the group mutex has been dropped.
> 
> So that is this race:
> 
>          CPU0                         CPU1
>     iommu_release_device(a)
>        __iommu_group_remove_device(a)
> 			         iommu_device_use_default_domain(b)
>                                   iommu_domain_free(domain)
>                                   iommu_release_device(b)
>                                        ops->release_device(b)
>        ops->release_device(a)
>          // Boom, a is still attached to domain :(
> 
> I can't think of how to solve this other than holding the group mutex
> across release_device. See below.

I see a few possibilities:

- Backtrack slightly on its removal, and instead repurpose detach_dev
into a specialised domain cleanup callback, called before or during
iommu_group_remove_device(), with the group mutex held.

- Drivers that hold any kind of internal per-device references to
domains - which is generally the root of this issue in the first place -
can implement proper reference counting, so even if a domain is "freed"
with a device still attached as above, it doesn't actually go away until
release_device(a) cleans up the final dangling reference. I suggested
the core doing this generically, but on reflection I think it's actually
a lot more straightforward as a driver-internal thing.

- Drivers that basically just keep a list of devices in the domain and
need to do a list_del() in release_device, can also list_del_init() any
still-attached devices in domain_free, with a simple per-instance or
global lock to serialise the two.

>>> And to your other question, the reason I split the function is because
>>> I couldn't really say WTF iommu_group_remove_device() was supposed to
>>> do. The __ version make ssense as part of the remove_device, due to
>>> the sequencing with ops->release()
>>>
>>> But the other one doesn't have that. So I want to put in a:
>>>
>>>      WARN_ON(group->blocking_domain || group->default_domain);
>>>
>>> Because calling it after those domains are allocated looks broken to
>>> me.
>>
>> I might be misunderstanding, but that sounds backwards - if a real device is
>> being hotplugged out, we absolutely expect that to happen *after* its
>> default domain has been set up.
> 
> See below for what I mean
> 
> iommu_group_remove_device() doesn't work as an API because it has no
> way to tell the device to stop using the domain we are about to free.
> 
> So it should assert that there is no domain to worry about. For the
> vfio and power case there is no domain because they don't use iommu
> drivers

Ah, I see it now - if we think it's a usage error for any current API
user to allow a device to be removed while still attached to a non-
default domain, then we can just throw our hands up at that, and
mitigate for the default domain case that we *can* control. I'm not 100%
convinced there might not be some niche non-uAPI case for skipping a
detach because you know you're tearing down your device and domain at the
same time, but I'm inclined to agree that we can worry about that if and
when it does ever come up.

If so, I reckon it should be about as as easy as this (untested).

Cheers,
Robin.

----->8-----
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 9fbe5d067473..760d9bd3ad66 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -396,17 +396,25 @@ int iommu_probe_device(struct device *dev)
  void iommu_release_device(struct device *dev)
  {
  	const struct iommu_ops *ops;
+	struct iommu_group *group;
  
  	if (!dev->iommu)
  		return;
  
  	iommu_device_unlink(dev->iommu->iommu_dev, dev);
  
+	/*
+	 * Some drivers track a device's current domain internally and may
+	 * dereference it to clean up in release_device. If a default domain
+	 * exists, hold a reference to ensure it stays around long enough.
+	 */
+	group = iommu_group_get(dev);
+	iommu_group_remove_device(dev);
  	ops = dev_iommu_ops(dev);
  	if (ops->release_device)
  		ops->release_device(dev);
  
-	iommu_group_remove_device(dev);
+	iommu_group_put(group);
  	module_put(ops->owner);
  	dev_iommu_free(dev);
  }
@@ -1022,6 +1030,14 @@ void iommu_group_remove_device(struct device *dev)
  	dev_info(dev, "Removing from iommu group %d\n", group->id);
  
  	mutex_lock(&group->mutex);
+	if (WARN_ON(group->domain != group->default_domain &&
+		    group->domain != group->blocking_domain)) {
+		if (group->default_domain)
+			__iommu_attach_device(group->default_domain, dev);
+		else
+			__iommu_detach_device(group->domain, dev);
+	}
+
  	list_for_each_entry(tmp_device, &group->devices, list) {
  		if (tmp_device->dev == dev) {
  			device = tmp_device;
