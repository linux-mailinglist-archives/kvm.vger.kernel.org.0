Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD75536E255
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 02:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhD2ABJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 20:01:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:8654 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhD2ABI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 20:01:08 -0400
IronPort-SDR: R9Teo7qiT1QGRXP2WOdMnyxk2PAMcGM5+G1vSz2GTRZNysK2XaTZycNCCzfrpLP7MIikv8y++b
 PGhMO0i0OoZw==
X-IronPort-AV: E=McAfee;i="6200,9189,9968"; a="176362821"
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="scan'208";a="176362821"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 17:00:21 -0700
IronPort-SDR: 1SV6xk77Vj3XV30uTFi+P2seGWKIo6/wjlaf+wTQ2PHlM2/yXbvIzJ35gAejznpBpLFjNRxm+Y
 kdgqnA7Q4n3g==
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="scan'208";a="605084138"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.209.130.122]) ([10.209.130.122])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 17:00:19 -0700
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com> <20210428060300.GA4092@lst.de>
 <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com>
 <20210428124153.GA28566@lst.de> <20210428140005.GS1370958@nvidia.com>
 <CAPcyv4hnjX-HtoG08dPbPxJPeJyvnO-WaJosoY1aSRqm5oo14Q@mail.gmail.com>
 <20210428233856.GY1370958@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <bda5a770-9c0d-9a52-e8f5-78f07c3e7ef1@intel.com>
Date:   Wed, 28 Apr 2021 17:00:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210428233856.GY1370958@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/28/2021 4:38 PM, Jason Gunthorpe wrote:
> On Wed, Apr 28, 2021 at 12:58:29PM -0700, Dan Williams wrote:
>> On Wed, Apr 28, 2021 at 7:00 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>>> On Wed, Apr 28, 2021 at 02:41:53PM +0200, Christoph Hellwig wrote:
>>>> On Wed, Apr 28, 2021 at 12:56:21AM -0700, Dan Williams wrote:
>>>>>> I still think this going the wrong way.  Why can't we enhance the core
>>>>>> driver code with a version of device_bind_driver() that does call into
>>>>>> ->probe?  That probably seems like a better model for those existing
>>>>>> direct users of device_bind_driver or device_attach with a pre-set
>>>>>> ->drv anyway.
>>>>> Wouldn't that just be "export device_driver_attach()" so that drivers
>>>>> can implement their own custom bind implementation?
>>>> That looks like it might be all that is needed.
>>> I thought about doing it like that, it is generally a good idea,
>>> however, if I add new API surface to the driver core I really want to
>>> get rid of device_bind_driver(), or at least most of its users.
>> I might be missing where you are going with this comment, but
>> device_driver_attach() isn't a drop-in replacement for
>> device_bind_driver().
> Many of the places calling device_bind_driver() are wonky things
> like this:
>
>          dev->dev.driver = &drv->link.driver;
>          if (pnp_bus_type.probe(&dev->dev))
>                  goto err_out;
>          if (device_bind_driver(&dev->dev))
>                  goto err_out;
>
> So device_driver_attach() does replace that - with some differences.
>
> Notable is that bind_driver requires the driver_lock but driver_attach
> gets it internally. However, as far as I can tell, none of the
> bind_driver callers do get it, so huh.
>
> Aside from the driver_lock there are lots of small subtle differences
> that are probably not important unless they are for some very complex
> reason. :\
>
> Of the callers:
>    drivers/input/serio/serio.c
>      This definitely doesn't have the device_lock
>      It uses connect instead of probe and for some reason uses its own
>      mutex instead of the device_lock. Murky.
>
>    drivers/input/gameport/gameport.c
>      This looks alot like serio, same comments
>
>    drivers/net/phy/phy_device.c
>      device_driver_attach() is better, looks unlikely that
>      device_lock is properly held here. Little unclear on what
>      the bus is and if bus->probe will be OK
>
>    drivers/net/wireless/mac80211_hwsim.c
>      Definitely does not hold the driver lock, the class and the driver
>      have NULL probes so this could be changed
>
>    drivers/pnp/card.c
>      device_driver_attach() is better, very unlikely that a random
>      device pulled from a linked list has the driver_lock held
>
>    drivers/usb/core/driver.c
>      This comment says the caller must have the device lock, but it
>      doesn't call probe, and when I look at cdc_ether.c I wonder
>      where the device_lock is hidden? Murky.
>
> Basically, there is some mess here, and eliminating
> device_bind_driver() for device_driver_attach() is quite a reasonable
> cleanup. But hard, complex enough it needs testing each patch.
>
> The other driver self bind scenario is to directly assign driver
> before device_add, but I have a hard time finding those cases in the
> tree with grep.
>
>> If this export prevented a new device_bind_driver() user, I think
>> that's a net positive, because device_bind_driver() seems an odd way
>> to implement bus code to me.
> Yes, I looked into why it is like this and concluded it is just very
> very old.
>   
>> I have an ulterior motive / additional use case in mind here which is
>> the work-in-progress cleanup of the DSA driver. It uses the driver
>> model to assign an engine to different use cases via driver binding.
>> However, it currently has a custom bind implementation that does not
>> operate like a typical /sys/bus/$bus/drivers interface. If
>> device_driver_attach() was exported then some DSA compat code could
>> model the current way while also allowing a transition path to the
>> right way. As is I was telling Dave that the compat code would need to
>> be built-in because I don't think fixing a DSA device-model problem is
>> enough justification on its own to ask for a device_driver_attach()
>> export.
> Can you make and test a DSA patch? If we have two concrete things and
> I can sketch two more out of the above that should meet Greg's "need 4
> things" general thinking for driver core API changes.

Working on it. Having device_driver_attach() exported will definitely 
make things easier on my side. Thanks for doing the heavy lifting.


>
> But I still would like to keep this going while we wait for acks, you
> know how long that can take...
>
> Jason
