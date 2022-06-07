Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C5D53F5A4
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 07:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiFGFtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 01:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiFGFtA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 01:49:00 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A53BBA99B;
        Mon,  6 Jun 2022 22:48:56 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 197A068BFE; Tue,  7 Jun 2022 07:48:53 +0200 (CEST)
Date:   Tue, 7 Jun 2022 07:48:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 2/8] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
Message-ID: <20220607054852.GA8680@lst.de>
References: <20220603063328.3715-1-hch@lst.de> <20220603063328.3715-3-hch@lst.de> <71e7d9a8-1005-0458-b8cd-147ccc6430d7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71e7d9a8-1005-0458-b8cd-147ccc6430d7@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 07, 2022 at 12:52:30AM +0530, Kirti Wankhede wrote:
> By removing this list, there is no way to know if parent device is 
> registered repeatedly? What will happen if same parent device is registered 
> twice? will it fail somewhere else?

The driver core will warn if you double register a device.

>>   probe'd to then it should call::
>>   -	extern int  mdev_register_device(struct device *dev,
>> -	                                 struct mdev_driver *mdev_driver);
>> +	int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
>> +			struct mdev_driver *mdev_driver);
>>
>
> No need to change API name as it still registers 'struct device *dev', it 
> could be 'mdev_register_device' but with new argument list.

I think the name name is a lot more clear, as device is really overused.
Especially as this is not a mdev_device, which are registered
elsewhere..

>>   -	mdev_unregister_device(i915->drm.dev);
>> +	mdev_unregister_parent(&i915->vgpu.parent);
>
> Ideally, parent should be member of gvt. There could be multiple vgpus 
> created on one physical device. Intel folks would be better reviewer 
> though.

i915->vgpu is not for a single VGPU, but all VGPU related core
support.

>> -	struct mdev_parent *parent;
>>   	char *env_string = "MDEV_STATE=registered";
>>   	char *envp[] = { env_string, NULL };
>> +	int ret;
>>     	/* check for mandatory ops */
>>   	if (!mdev_driver->supported_type_groups)
>>   		return -EINVAL;
>>   -	dev = get_device(dev);
>> -	if (!dev)
>> -		return -EINVAL;
>> -
>
> Why not held device here? What if some driver miss behave where it 
> registers device to mdev, but unloads without unregistering from mdev?

Then that driver is buggy.  We don't add extra reference to slightly
paper over buggy code elsewhere in the kernel either.
