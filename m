Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6E036E238
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 01:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhD1Xjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 19:39:47 -0400
Received: from mail-mw2nam08on2080.outbound.protection.outlook.com ([40.107.101.80]:21952
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229488AbhD1Xjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 19:39:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5u44PPs54awtC7qAf/LwKgbSvoDUce6bP8nCBLAkItC5kieW9WVbElelUpX9hlm5nOOGMiiG9K7Jtp5ROsXcwfodfypqbM2HNL49U2VDDRDsadkc56Lj7+P2/fgNy9V/yAW0b83C1jrANz1TQT30se2Gy//PU2WrMf6H0N7DCf82yKPbvcIScEC0Zs4AKhs4EpYIVWTOB6snbQv5WHOEsylrmmXXxlVwWJ35+AYJBXQ4qIqoT0vRlc/gXVYeMRHP9rmpe25PeyvFsfOHDJRUEY0MQwtvRXBdmbG6hsAHVbXEeiSOYJiMDa4XvgQX0zzKBMQYs4e99OerOUb3TI3jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5axHsHELx1QWKoBCGtYBCE1ASzGgd+4jhnFvi5YlM7Y=;
 b=QFlvQVQV9jc2zTEAPfeej1NeKBrmtov9rh+0XdRKa2TfIVVEtKM7OuV+2vfsqrYT6myXfUxUKrMy2SxHjaOhgBRNJpUVFxRaX4YKyWFmK6GTPQJ1ql5hsbPUpjVcDNn1gSKYVsbR54eam48SM9+oHu4jQYXwT+tBGRG3Eu+RjXHwqHpyYUsU6zv9zkPmCx/scVcriVqTOk5eDMLSf8jgnRhshc9J6+uZibRCKXyT+Jr9IAUszDkgxVwQj4+Atl5WYKCfz568f7xe6m3uVcEqJm/HyrsXdqC8pKq+HrPG1jsugtleiKsasfIalEoqjSwoHoZwQOlQW4VkJJVaq8NI8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5axHsHELx1QWKoBCGtYBCE1ASzGgd+4jhnFvi5YlM7Y=;
 b=LZbsK1rcTDWWun7zHHsMMGGEom+/rWI/1YR0vEJsXa2zmJpginOdRK+gEAV4UvHbLADrehaT1o1j8smmHyLgXs70wFubJ+/VQFDbVO5P+s5gRI+DK3QexQEvtxhVP+RfwrEwRzID3nEGLXB5VbpR6+HdQlmeYXWPz1y5FjaIGdUxKcjVvAi/6Hs5GHd6r8cywe6bfiPFMRVYQfakDVpxAYPArIOKCoc2fLc7AGeW+OPpOmNEIUjabMGvxH0NDAKkOMuR4CiD5IKruPxdHVgifcDsLHujKHYXSbZIsLneFvg7SvrecD/SVcZB5zJaxtFWXDqWTZwL3gzm9zorZkvjuA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4010.namprd12.prod.outlook.com (2603:10b6:5:1ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Wed, 28 Apr
 2021 23:38:58 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 23:38:58 +0000
Date:   Wed, 28 Apr 2021 20:38:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>, dave.jiang@intel.com
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
Message-ID: <20210428233856.GY1370958@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428060300.GA4092@lst.de>
 <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com>
 <20210428124153.GA28566@lst.de>
 <20210428140005.GS1370958@nvidia.com>
 <CAPcyv4hnjX-HtoG08dPbPxJPeJyvnO-WaJosoY1aSRqm5oo14Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hnjX-HtoG08dPbPxJPeJyvnO-WaJosoY1aSRqm5oo14Q@mail.gmail.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR20CA0022.namprd20.prod.outlook.com
 (2603:10b6:610:58::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR20CA0022.namprd20.prod.outlook.com (2603:10b6:610:58::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 23:38:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lbtlg-00EBBp-Sf; Wed, 28 Apr 2021 20:38:56 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cf7876b-58d8-444f-9015-08d90a9ecb82
X-MS-TrafficTypeDiagnostic: DM6PR12MB4010:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4010B43D325637AEAFE2C22BC2409@DM6PR12MB4010.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MJ1zKHGcgoloTXbNo0u+AWxgWkN70JpBrVRJ43TMBrIPQl9z9nt1ncTkqj9pVqYxvUveZ7vRAMiyrZqR9XPGeM/stP33xdJi6q7+aHSXcPed/W4gNkAMJrZ9lq7jUy/jFGJ0kN7cJDrMYSCFIfVqpYCZp0uGG2A5F0xXYkKFVfbiiosANIAPOeClpDVCelaHcUoPPhJpspWiZqXicGqEww+ccogp9oabJVWPN13HaCRSAL/kbUZX8NFPaTR1P9iG8At5EUT2F/xVPqUctQnznymVPrB02pDiQ6z9b1SIqgTGGBjYYvaV27bzW0tKvTjPu+Q7lWupzkbdaRRqRnpEwloefEjPKOERiYWla7tc7D/xAwR9/MIeIIjpSLFfC00ZLsJjwB6TZl00WShc3cQC5fzNrSSpehyMqjZuk3AJ/jRjoIqzP6I8hU3AIaLLHHnPZUVsB3MaBdNgva8MOLOnbUE//urBW4OKyD8U6nmKC+jReRCYcKZhEokRnGhqUiwJGA3xpse6SXWRT0FeXBZFI2o1bn6igty0DAdUo9FU6LcKbUik6O7Wx44eM/DrbPJcyKJyRszSu9K+pZvEuiZMEakanshozfygqfTQt5UKY54=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(8936002)(2906002)(1076003)(33656002)(5660300002)(478600001)(426003)(8676002)(2616005)(316002)(38100700002)(53546011)(6916009)(54906003)(66946007)(66556008)(66476007)(186003)(86362001)(83380400001)(9746002)(36756003)(26005)(4326008)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eLYJwVKyq5Yx3yowVFIH/2VqakSLElwO/Kau2lMq0ZAwu6cTHR0T1DEC506v?=
 =?us-ascii?Q?oHmKRChlTrUW3oUHgK2ej6og9dl7yAnfFFtvQiHN+N432tU3b+cGx9ICwlb9?=
 =?us-ascii?Q?hqAJC39f6BwtXC3bbzWj/aypEDucc/MA3JOU/Tzkkvppv5ppuceVJZRvRTUE?=
 =?us-ascii?Q?t2WN6t5DN3mZH/WH1g6laloAOGko6hPvo0Dr3rD1hN5YKF+QOtOmna5FhkJB?=
 =?us-ascii?Q?MkYCuDJUcUuDRKkeqvRhMZBVsmFmEPxkx4+7ghntjuK1CuaYhNWf1ihFQFOb?=
 =?us-ascii?Q?dLVLQpJSmk4CSVVd/rLjQclf/UiK7jAvYK2i1Gz5S52lCvrHH8q6KqJEo1Rm?=
 =?us-ascii?Q?SGRXKcRr+ZH6tCiRKg8Q0l6H75xJD3br+U2E7MDJn6jvaYQV9zzVCONVOb4X?=
 =?us-ascii?Q?7Bt5JrilfR7oxYz+oUKutTs7gvTorYrayJpK7Didd9SE0/eKAl9TFc1Us74T?=
 =?us-ascii?Q?cPC9+mUW5Oz+OXMeNNZM4sGywgfgDUxeO6qFn15s+FW6OyFDjvrbC+9jDtcc?=
 =?us-ascii?Q?M3c8AKqKIz5VMb01UFMsbmEY5GJ5gncmPgrZgVFHx8x1c00bJWS3yHHtq45a?=
 =?us-ascii?Q?pBnO4tVveEwEx3yywmmn5363up488vBx2wxXZwSxM1XMcs4DoAKlRQt/Ck3N?=
 =?us-ascii?Q?3yx3wQZXafZvIJT5aCnjpKiSQRmX/CLaeGbmGJF0rAST81sOwVKCY+u3KHmF?=
 =?us-ascii?Q?coe/E1XWNrWSeV/9i8QDww3VJc2uHGXD4s0fv6NNLpD8Yv4u3a0dkqgdokow?=
 =?us-ascii?Q?1oivfsrTjE/d0H/vBd5cYyNTQt6qSSym6znuqX7cZl+zft5OIOmQ2eQIZ138?=
 =?us-ascii?Q?eo6KybspT88STHTS9HMsDZVRgnlc8UIsuArbab11cvkcdb1j9SscCoOqXEDU?=
 =?us-ascii?Q?fbFQcJhB4ARymIJM7zmbvlNEoPOtbqkfUvg/WlcUvfFd1PbzsnBIIc+wbXAE?=
 =?us-ascii?Q?xKysnL/U+8NRMTV0tZiqFY9NEPDO67grw/Hk+/K7ElJFw9HVXHZFh5pAYgWB?=
 =?us-ascii?Q?tcZ0QGCJXD1kzc/xSCb+dlPjK/LqaVphSETcuiV5yRVUux2h1DJu1CH27Sfw?=
 =?us-ascii?Q?mAD5NERi6Gn/D8H+oywxgHMRgkusYAIZtI44kkU0u4hv7jESTiHdnnkqYSLE?=
 =?us-ascii?Q?dOYIeQaMbXt83pTFIC2c2cq4EVRbkYh0oyJMBsk5CWXzNS2j92xGvTdSgFbE?=
 =?us-ascii?Q?ALiEGGXWKhaYtc8XibTt5v2Ih9LD5iFNozjt677k/pQx0ktIjYDzvGO7+QNZ?=
 =?us-ascii?Q?YgPOCOCFWJ4mleBjOQLpT4BlsB4XwFucA3MpKxyuMnqFbsZhk9xCDpgXGqPI?=
 =?us-ascii?Q?O1HMZM8/EEP65doyupHq5k5e?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf7876b-58d8-444f-9015-08d90a9ecb82
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 23:38:58.6866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pY2Q+zEw+nrdn/iCEB8SIG54OFLgZiFkQvase4pSt6XA/jhUiN9XJTzD6rId5IyG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4010
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 12:58:29PM -0700, Dan Williams wrote:
> On Wed, Apr 28, 2021 at 7:00 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Wed, Apr 28, 2021 at 02:41:53PM +0200, Christoph Hellwig wrote:
> > > On Wed, Apr 28, 2021 at 12:56:21AM -0700, Dan Williams wrote:
> > > > > I still think this going the wrong way.  Why can't we enhance the core
> > > > > driver code with a version of device_bind_driver() that does call into
> > > > > ->probe?  That probably seems like a better model for those existing
> > > > > direct users of device_bind_driver or device_attach with a pre-set
> > > > > ->drv anyway.
> > > >
> > > > Wouldn't that just be "export device_driver_attach()" so that drivers
> > > > can implement their own custom bind implementation?
> > >
> > > That looks like it might be all that is needed.
> >
> > I thought about doing it like that, it is generally a good idea,
> > however, if I add new API surface to the driver core I really want to
> > get rid of device_bind_driver(), or at least most of its users.
> 
> I might be missing where you are going with this comment, but
> device_driver_attach() isn't a drop-in replacement for
> device_bind_driver().

Many of the places calling device_bind_driver() are wonky things
like this:

        dev->dev.driver = &drv->link.driver;
        if (pnp_bus_type.probe(&dev->dev))
                goto err_out;
        if (device_bind_driver(&dev->dev))
                goto err_out;

So device_driver_attach() does replace that - with some differences.

Notable is that bind_driver requires the driver_lock but driver_attach
gets it internally. However, as far as I can tell, none of the
bind_driver callers do get it, so huh.

Aside from the driver_lock there are lots of small subtle differences
that are probably not important unless they are for some very complex
reason. :\

Of the callers:
  drivers/input/serio/serio.c
    This definitely doesn't have the device_lock
    It uses connect instead of probe and for some reason uses its own
    mutex instead of the device_lock. Murky.

  drivers/input/gameport/gameport.c
    This looks alot like serio, same comments

  drivers/net/phy/phy_device.c
    device_driver_attach() is better, looks unlikely that
    device_lock is properly held here. Little unclear on what
    the bus is and if bus->probe will be OK

  drivers/net/wireless/mac80211_hwsim.c
    Definitely does not hold the driver lock, the class and the driver
    have NULL probes so this could be changed

  drivers/pnp/card.c
    device_driver_attach() is better, very unlikely that a random
    device pulled from a linked list has the driver_lock held

  drivers/usb/core/driver.c
    This comment says the caller must have the device lock, but it
    doesn't call probe, and when I look at cdc_ether.c I wonder
    where the device_lock is hidden? Murky.

Basically, there is some mess here, and eliminating
device_bind_driver() for device_driver_attach() is quite a reasonable
cleanup. But hard, complex enough it needs testing each patch.

The other driver self bind scenario is to directly assign driver
before device_add, but I have a hard time finding those cases in the
tree with grep.

> If this export prevented a new device_bind_driver() user, I think
> that's a net positive, because device_bind_driver() seems an odd way
> to implement bus code to me.

Yes, I looked into why it is like this and concluded it is just very
very old.
 
> I have an ulterior motive / additional use case in mind here which is
> the work-in-progress cleanup of the DSA driver. It uses the driver
> model to assign an engine to different use cases via driver binding.
> However, it currently has a custom bind implementation that does not
> operate like a typical /sys/bus/$bus/drivers interface. If
> device_driver_attach() was exported then some DSA compat code could
> model the current way while also allowing a transition path to the
> right way. As is I was telling Dave that the compat code would need to
> be built-in because I don't think fixing a DSA device-model problem is
> enough justification on its own to ask for a device_driver_attach()
> export.

Can you make and test a DSA patch? If we have two concrete things and
I can sketch two more out of the above that should meet Greg's "need 4
things" general thinking for driver core API changes.

But I still would like to keep this going while we wait for acks, you
know how long that can take...

Jason
