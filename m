Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579AC53F5A7
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 07:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbiFGFu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 01:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiFGFuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 01:50:55 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E775BA99B;
        Mon,  6 Jun 2022 22:50:54 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B4A7F68AFE; Tue,  7 Jun 2022 07:50:50 +0200 (CEST)
Date:   Tue, 7 Jun 2022 07:50:50 +0200
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
Subject: Re: [PATCH 3/8] vfio/mdev: simplify mdev_type handling
Message-ID: <20220607055050.GB8680@lst.de>
References: <20220603063328.3715-1-hch@lst.de> <20220603063328.3715-4-hch@lst.de> <86df429e-9f01-7a91-c420-bb1130b4d343@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86df429e-9f01-7a91-c420-bb1130b4d343@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 07, 2022 at 12:52:49AM +0530, Kirti Wankhede wrote:
>>   	void (*remove)(struct mdev_device *dev);
>> -	struct attribute_group **supported_type_groups;
>>   	struct device_driver driver;
>>   };
>
> mdev_type should be part of mdev_parent, separating it from mdev_parent 
> could result in more errors while using mdev framework.

Why?

> Similarly it should 
> be added as part of mdev_register_device. Below adding types is separated 
> from mdev_register_device which is more error prone.

How so?

> What if driver 
> registering to mdev doesn't add mdev_types? - mdev framework is un-usable 
> in that case.

Yes, so it is if you don't add it to the supported_type_groups field
in the current kernel.  Basic programmer error, and trivially caught.

> We had kept it together with mdev registration so that 
> mdev_types should be mandatory to be defined by driver during registration. 
> How would you mandate mdev_type by such separation?

I would not.  Registering a parent without types is perfectly valid from
the code correctness perspective.  It just isn't very useful.  Just
like say creating a kobject without attributes in the device model.
