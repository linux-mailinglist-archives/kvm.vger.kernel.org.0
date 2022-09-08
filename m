Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A08E5B281D
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 23:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiIHVGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 17:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiIHVGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 17:06:09 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4906CF2D69
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 14:06:07 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76350153B;
        Thu,  8 Sep 2022 14:06:13 -0700 (PDT)
Received: from [10.57.15.197] (unknown [10.57.15.197])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 38B933F7B4;
        Thu,  8 Sep 2022 14:06:04 -0700 (PDT)
Message-ID: <87b7041e-bc8d-500c-7167-04190e3795a9@arm.com>
Date:   Thu, 8 Sep 2022 22:05:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4/4] iommu: Fix ordering of iommu_release_device()
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
References: <4-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
Content-Language: en-GB
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <4-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
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

On 2022-09-08 19:45, Jason Gunthorpe wrote:
> default domains created a situation where the device is always connected
> to a domain of some kind. When the device is idle it is connected to one
> of the two pre-existing domains in the group, blocking_domain or
> default_domain. In this way we have a continuous assertion of what state
> the transation is in.
> 
> When this is all destructed then we need to remove all the devices from
> their domains via the ops->release_device() call before the domain can be
> freed. This is the bug recognized in commit 9ac8545199a1 ("iommu: Fix
> use-after-free in iommu_release_device").
> 
> However, we must also stop any concurrent access to the iommu driver for
> this device before we destroy it. This is done by:
> 
>   1) Drivers only using the iommu API while they have a device driver
>      attached to the device. This directly prevents release from happening.
> 
>   2) Removing the device from the group list so any lingering group
>      references no longer refer to the device. This is done by
>      iommu_group_remove_device()
> 
> Since iommu_group_remove_device() has been moved this breaks #2 and
> triggers an WARN when VFIO races group activities with the release of the
> device:
> 
>     iommu driver failed to attach the default/blocking domain
>     WARNING: CPU: 0 PID: 5082 at drivers/iommu/iommu.c:1961 iommu_detach_group+0x6c/0x80
>     Modules linked in: macvtap macvlan tap vfio_pci vfio_pci_core irqbypass vfio_virqfd kvm nft_fib_inet nft_fib_ipv4 nft_fib_ipv6>
>     CPU: 0 PID: 5082 Comm: qemu-system-s39 Tainted: G        W          6.0.0-rc3 #5
>     Hardware name: IBM 3931 A01 782 (LPAR)
>     Krnl PSW : 0704c00180000000 000000095bb10d28 (iommu_detach_group+0x70/0x80)
> 	      R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
>     Krnl GPRS: 0000000000000001 0000000900000027 0000000000000039 000000095c97ffe0
> 	      00000000fffeffff 00000009fc290000 00000000af1fda50 00000000af590b58
> 	      00000000af1fdaf0 0000000135c7a320 0000000135e52258 0000000135e52200
> 	      00000000a29e8000 00000000af590b40 000000095bb10d24 0000038004b13c98
>     Krnl Code: 000000095bb10d18: c020003d56fc        larl    %r2,000000095c2bbb10
> 			  000000095bb10d1e: c0e50019d901        brasl   %r14,000000095be4bf20
> 			 #000000095bb10d24: af000000            mc      0,0
> 			 >000000095bb10d28: b904002a            lgr     %r2,%r10
> 			  000000095bb10d2c: ebaff0a00004        lmg     %r10,%r15,160(%r15)
> 			  000000095bb10d32: c0f4001aa867        brcl    15,000000095be65e00
> 			  000000095bb10d38: c004002168e0        brcl    0,000000095bf3def8
> 			  000000095bb10d3e: eb6ff0480024        stmg    %r6,%r15,72(%r15)
>     Call Trace:
>      [<000000095bb10d28>] iommu_detach_group+0x70/0x80
>     ([<000000095bb10d24>] iommu_detach_group+0x6c/0x80)
>      [<000003ff80243b0e>] vfio_iommu_type1_detach_group+0x136/0x6c8 [vfio_iommu_type1]
>      [<000003ff80137780>] __vfio_group_unset_container+0x58/0x158 [vfio]
>      [<000003ff80138a16>] vfio_group_fops_unl_ioctl+0x1b6/0x210 [vfio]
>     pci 0004:00:00.0: Removing from iommu group 4
>      [<000000095b5b62e8>] __s390x_sys_ioctl+0xc0/0x100
>      [<000000095be5d3b4>] __do_syscall+0x1d4/0x200
>      [<000000095be6c072>] system_call+0x82/0xb0
>     Last Breaking-Event-Address:
>      [<000000095be4bf80>] __warn_printk+0x60/0x68
> 
> So, put things in the right order:
>   - Remove the device from the group's list
>   - Release the device from the iommu driver to drop all domain references
>   - Free the domains
> 
> This is done by splitting out the kobject_put(), which triggers
> iommu_group_release(), from the rest of iommu_group_remove_device() and
> placing it after release is called.

So simple... now how did I fail to think of that? :)

> Fixes: 9ac8545199a1 ("iommu: Fix use-after-free in iommu_release_device")
> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 36 +++++++++++++++++++++++++++---------
>   1 file changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 780fb70715770d..c451bf715182ac 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -90,6 +90,7 @@ static int iommu_create_device_direct_mappings(struct iommu_group *group,
>   static struct iommu_group *iommu_group_get_for_dev(struct device *dev);
>   static ssize_t iommu_group_store_type(struct iommu_group *group,
>   				      const char *buf, size_t count);
> +static void __iommu_group_remove_device(struct device *dev);
>   
>   #define IOMMU_GROUP_ATTR(_name, _mode, _show, _store)		\
>   struct iommu_group_attribute iommu_group_attr_##_name =		\
> @@ -330,6 +331,7 @@ int iommu_probe_device(struct device *dev)
>   
>   void iommu_release_device(struct device *dev)
>   {
> +	struct iommu_group *group = dev->iommu_group;
>   	const struct iommu_ops *ops;
>   
>   	if (!dev->iommu)
> @@ -337,11 +339,20 @@ void iommu_release_device(struct device *dev)
>   
>   	iommu_device_unlink(dev->iommu->iommu_dev, dev);
>   

In fact, now that you've made it obvious, could we not simply do an 
extra kobject_get() here before calling regular 
iommu_group_remove_device(), and avoid having to split that up at all? 
That should delay any default domain teardown just as definitively as 
holding the original reference for longer, no?

Thanks,
Robin.

> +	__iommu_group_remove_device(dev);
>   	ops = dev_iommu_ops(dev);
>   	if (ops->release_device)
>   		ops->release_device(dev);
>   
> -	iommu_group_remove_device(dev);
> +	/*
> +	 * This will eventually call iommu_group_release() which will free the
> +	 * iommu_domains. Up until the release_device() above the iommu_domains
> +	 * may still have been associated with the device, and we cannot free
> +	 * them until the have been detached. release_device() is expected to
> +	 * detach all domains connected to the dev.
> +	 */
> +	kobject_put(group->devices_kobj);
> +
>   	module_put(ops->owner);
>   	dev_iommu_free(dev);
>   }
> @@ -939,14 +950,7 @@ int iommu_group_add_device(struct iommu_group *group, struct device *dev)
>   }
>   EXPORT_SYMBOL_GPL(iommu_group_add_device);
>   
> -/**
> - * iommu_group_remove_device - remove a device from it's current group
> - * @dev: device to be removed
> - *
> - * This function is called by an iommu driver to remove the device from
> - * it's current group.  This decrements the iommu group reference count.
> - */
> -void iommu_group_remove_device(struct device *dev)
> +static void __iommu_group_remove_device(struct device *dev)
>   {
>   	struct iommu_group *group = dev->iommu_group;
>   	struct group_device *tmp_device, *device = NULL;
> @@ -977,6 +981,20 @@ void iommu_group_remove_device(struct device *dev)
>   	kfree(device->name);
>   	kfree(device);
>   	dev->iommu_group = NULL;
> +}
> +
> +/**
> + * iommu_group_remove_device - remove a device from it's current group
> + * @dev: device to be removed
> + *
> + * This function is called by an iommu driver to remove the device from
> + * it's current group.  This decrements the iommu group reference count.
> + */
> +void iommu_group_remove_device(struct device *dev)
> +{
> +	struct iommu_group *group = dev->iommu_group;
> +
> +	__iommu_group_remove_device(dev);
>   	kobject_put(group->devices_kobj);
>   }
>   EXPORT_SYMBOL_GPL(iommu_group_remove_device);
