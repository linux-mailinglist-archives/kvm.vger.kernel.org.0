Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FC73428FA
	for <lists+kvm@lfdr.de>; Sat, 20 Mar 2021 00:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhCSXAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 19:00:17 -0400
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:56928
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229512AbhCSW7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 18:59:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dy0bhouVdjPd0QnlfyZ7gew5kpoAOUch8drVIU2Da57+ZswHHy7BZwPQPWdECJeMcAY80lIBNWTZDrkKjbjn4Cw/WqKzarN29tJpY+wn8oPGR1xoAvPhSVp9XRiqPSjXEVvvYZUMP2KMYIioWNmzcEYGB1DEr2hjmVozCFFe5giCWAZiQIxGp6BTEXnmzqReR7T2vaymUaAckOstWKh5BNrpzfEPh9HrzBatWLPP/sgMOQLZhgCz9R4YZ+R9sEKgLaTGHc0vMWxneCAsoj9FhwGyrPQ52wr+A/CNs1NZ4ZNaSqZrZblm9Ea47Vwh2VOcv6FbyO5NiLEgktdSMLuOFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAIMleYMB1xEiavq/CFYJlubwRkTp5suB4yjs1lLH5Y=;
 b=bmvDpc02fbKyWsywp39mQTFMcSEiZPRJTWBO2ABAbank7+HI9BuUIY1Lpd/eAUTWo8fBuZ3xAZSwFSq80le/eS12WQAXY0I3pjc9vsUroppOtS4bklvBGAHla1jleCbcwsupnKlF9nzCKMxs5/HJBElNmVfkY5gxtQvHtLzWTE/Gefg51AKQqmjCyr86d11JNWwdq9KX8cpUl/mIWFaOEtPYNWWEB5oSliAh6fb/WH8uK4Dgus9eYyGpWTC0nAoys/sQ25gwsgJ+ZtOxZy5PmI312GUc1MYIR++DadUh8IS9Yof3BdjU4KdMucC+IJqo15nr0Gi4ivSLOwwqBbIszw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAIMleYMB1xEiavq/CFYJlubwRkTp5suB4yjs1lLH5Y=;
 b=TRO0++LN16XWoN7MILc3EGtI39dQpkhxnpP6MAduMBMfV8DmIdKpJ5l41ThkjPezPsNFE1RRLvxK8AVKP2PtwrxX2HROOtotE1rDbDyvgufP3r6wPz1QL711dXwlq1ItxMzDps+8Ego+TJvfCrhkbJv8tfsOcc/tj+g51gs+nxF5v6Y0W+nfpk4BwTKvlMjok/+DtmDVQKotArqp8wf/jIEPNsz4T8Ww3jNgtk7miIdPC31zspxpZoSbNqdZ/yvgb4AqsVdwq6ltGxHz1IAVjAYPJ3hWP2rJ74FN5C1spD+oOrx1O7FEWkccMhyYeEXlOaWRPM/Yem1PitcLBCUpXw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3308.namprd12.prod.outlook.com (2603:10b6:5:182::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 19 Mar
 2021 22:59:45 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 22:59:45 +0000
Date:   Fri, 19 Mar 2021 19:59:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210319225943.GH2356281@nvidia.com>
References: <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
 <20210319092341.14bb179a@omen.home.shazbot.org>
 <20210319161722.GY2356281@nvidia.com>
 <20210319162033.GA18218@lst.de>
 <20210319162848.GZ2356281@nvidia.com>
 <20210319163449.GA19186@lst.de>
 <20210319113642.4a9b0be1@omen.home.shazbot.org>
 <20210319200749.GB2356281@nvidia.com>
 <20210319150809.31bcd292@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319150809.31bcd292@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAPR03CA0099.namprd03.prod.outlook.com
 (2603:10b6:208:32a::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0099.namprd03.prod.outlook.com (2603:10b6:208:32a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 22:59:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lNO5n-00HUZK-Hc; Fri, 19 Mar 2021 19:59:43 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2df2bd67-e048-48ae-7cb8-08d8eb2ab051
X-MS-TrafficTypeDiagnostic: DM6PR12MB3308:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3308F48008BD2CB97199D94BC2689@DM6PR12MB3308.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H1SbTQ/MSaHc+S9U1Ni8CzjkDuAEOGr7zrBN2XEYbMOVfCP/bS9wSwz07yGpcCGgRZzJAbKfG3r3aGzaJq3KGDYPDOSjcqHWlDbti8me5eE9et2O4nLcbUmKmhYZWRAcNvl1N/wVvm1eiZCR11Y6/nah9PXzk1sdXIc8FbcpF0Qy0tQfmTi93T+jzoxuWUmpDkDtQNYoWjqoDzYg/iti2rsMX22ncHWwjvogYdJwPzWJzvpBtzqpLN76T1gBmcV0NUu7hAWAA0MyjfjbVnxZ8PuJVueUojjqZQkqGpowWS6cwiCIksVsLe9jkbsvkTC3kZ2QOWoRYUMyywCLTHesktk1oCgasr/cv2khLd5qafi0mgeAZzx1ZQFQnuv4M3WaPPKbTsjnkPtAuiV8XEBKysM4sgqzjLwr8xynz5NTbHv1kFAO2BNFuRHSjz3k3n4xBTJY5d9SJXRwuT8gbibC9TlHicwSiLGkT4JDTB2m0lIvMW77+47xQ+pYWBuKJ5V/4uJuO4g/AAYwbqgvzE147AZay9BjdrITt+egOgRPK+PRK57aRcfVuo8+P70tgpQDdq2jPiCeIVVzCHUFYkxBlQv+C17Yc/t/4hov+TGx88tTqNTp8yGJAlVC6Kw+5w+8+OAxMvbjfeY90/4HZXoB8WcPN2lTl+TTU7szmgTZcXLAEPDTnQJvq2ZQ2cFQrV+x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(6916009)(478600001)(4326008)(26005)(1076003)(5660300002)(2616005)(9746002)(66946007)(36756003)(186003)(2906002)(33656002)(8676002)(8936002)(316002)(9786002)(66476007)(54906003)(86362001)(83380400001)(426003)(38100700001)(66556008)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vaxpk8hL1PuzOhuDYk1k2WnR/NKCviOTFIgPp/tlqB3S4j8pgHZUdtWYo1Wm?=
 =?us-ascii?Q?cOy3r5/iGoY9hw2Pj7Fa7ItqPu1nDX9SXBi9qMSPYRq2H9UsuiiJvaXdLNci?=
 =?us-ascii?Q?eqVdmNNXgaDwX7PTEUmLclbxM7TiFmQrwm6OydTSphwZEIn+lqqcJWDb2HBF?=
 =?us-ascii?Q?sVSP3HJPqrj60ndTNNvVsj2g80EEWwLoucw5EstHppE1XvimYba/LasInm0i?=
 =?us-ascii?Q?9DFr9hzDuCasIeUhEDUXbmVwu7sWyNlfXWg8T/BMBPY02pAmoOkSbM5dGDLH?=
 =?us-ascii?Q?GfcYGYI28zUP1TXm+VHxkRELTxG5JFlCzq9iYWpl0YyDBpzFoUCi14MpFnd6?=
 =?us-ascii?Q?19Y9KOWES7eoIzcSxXGp7riHptHXwoGFRQ6THxYKHxt6K2QLOjpi3bgCMlGF?=
 =?us-ascii?Q?drGCuL+J8ZHLjLQyUiZsT5hoI4ym0VaeDktif5hC4P4GxHqrDt+JksAx+WV9?=
 =?us-ascii?Q?0UdRrASWdWvVn3J3JOQinphvBn4Wx9/nHDF+wWpfk8XoCSi3MGduwI/H5mJD?=
 =?us-ascii?Q?9l1eRO/sz3A/Tv33rKULRflGWvuoDqa8gOoo7A90Pw6sBx1UB47vlnXqi9t3?=
 =?us-ascii?Q?ojiAuitNsZ8D4Abp54vk5FEsh2jqbBhufBLe3Y5WGcWttqkyahZmUWb8e6rN?=
 =?us-ascii?Q?R3E0DNMlWDLrdPt25uy7Aipfy5LN7lLZpeN80rvW2oXXtypLNsRlPjsy2IPq?=
 =?us-ascii?Q?KMks+FhuuTogZ5gkN6A11VzZCdZYI71xEcrb6de/5opQ1E+e4BMtsJBk1HaX?=
 =?us-ascii?Q?bAWoUdeorGncMMyuu4eyKzO+Xjniw1QjO47USk0iC3O8cJ32DKFVhQJAkbiO?=
 =?us-ascii?Q?EATmyak7M/ucDutY3hAyEJK8PmAUdb8kNP4X+HLoEOI1eMhbp8n+XEn0qt9v?=
 =?us-ascii?Q?kaAe7e+Uq0zxx18DSZ7FH7e8KlUxiJ32jEXXbuWSoRMWk+nEvcjjWS8F4Arj?=
 =?us-ascii?Q?dFuXhRLdbi3S25DydANViNBiehjaF+D+7XtRdBfFHpUDleJ6YvJE7BQSqVgP?=
 =?us-ascii?Q?qh7DrVN2Dt8fkdimHycHWRRdVjsVI7DZ9jXmoeBehAkn41qLZ4NS+aFTL+TB?=
 =?us-ascii?Q?JUwB6FEAbvmE6vdea7WRPDn2eWk9sHRoNSXv0yIkEg2ieDEa4UHDgK31v3vn?=
 =?us-ascii?Q?EAT2iGTnGLITlo9OtxPEVDOREtVYVIg2AmgYaimpiOS77d4LK/ytF4nw6o24?=
 =?us-ascii?Q?++6KaEpDCXt/8xblVuqjqzxXS3ds66usjWNFISKu0dO/i4s88NWeNEprToq1?=
 =?us-ascii?Q?XQ3aslZcPF0g0LBva849FEyR23CO39DfmCMmatJGqNRo0IZ+AqZ7e6BwpchL?=
 =?us-ascii?Q?L5HuT5KDDG/CLEfcdfJCiiYfe7prm7NgFQoNPNO2OTu35A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df2bd67-e048-48ae-7cb8-08d8eb2ab051
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 22:59:45.5637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TbyRi2HhKjKMPvE4e2rYlla2kGIncUpWM2caQD41BUKX3KuwT96Sena3PMd0Kz5D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3308
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 03:08:09PM -0600, Alex Williamson wrote:
> On Fri, 19 Mar 2021 17:07:49 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Fri, Mar 19, 2021 at 11:36:42AM -0600, Alex Williamson wrote:
> > > On Fri, 19 Mar 2021 17:34:49 +0100
> > > Christoph Hellwig <hch@lst.de> wrote:
> > >   
> > > > On Fri, Mar 19, 2021 at 01:28:48PM -0300, Jason Gunthorpe wrote:  
> > > > > The wrinkle I don't yet have an easy answer to is how to load vfio_pci
> > > > > as a universal "default" within the driver core lazy bind scheme and
> > > > > still have working module autoloading... I'm hoping to get some
> > > > > research into this..    
> > > 
> > > What about using MODULE_SOFTDEP("pre: ...") in the vfio-pci base
> > > driver, which would load all the known variants in order to influence
> > > the match, and therefore probe ordering?  
> > 
> > The way the driver core works is to first match against the already
> > loaded driver list, then trigger an event for module loading and when
> > new drivers are registered they bind to unbound devices.
> 
> The former is based on id_tables, the latter on MODULE_DEVICE_TABLE, we
> don't have either of those.

Well, today we don't, but Max here adds id_table's to the special
devices and a MODULE_DEVICE_TABLE would come too if we do the flavours
thing below.

My starting thinking is that everything should have these tables and
they should work properly..

> As noted to Christoph, the cases where we want a vfio driver to
> bind to anything automatically is the exception.

I agree vfio should not automatically claim devices, but once vfio is
told to claim a device everything from there after should be
automatic.

> > One answer is to have userspace udev have the "hook" here and when a
> > vfio flavour mod alias is requested on a PCI device it swaps in
> > vfio_pci if it can't find an alternative.
> > 
> > The dream would be a system with no vfio modules loaded could do some
> > 
> >  echo "vfio" > /sys/bus/pci/xxx/driver_flavour
> > 
> > And a module would be loaded and a struct vfio_device is created for
> > that device. Very easy for the user.
> 
> This is like switching a device to a parallel universe where we do
> want vfio drivers to bind automatically to devices.

Yes.

If we do this I'd probably suggest that driver_override be bumped down
to some user compat and 'vfio > driver_override' would just set the
flavour.

As-is driver_override seems dangerous as overriding the matching table
could surely allow root userspace to crash the machine. In situations
with trusted boot/signed modules this shouldn't be.

> > > If we coupled that with wildcard support in driver_override, ex.
> > > "vfio_pci*", and used consistent module naming, I think we'd only need
> > > to teach userspace about this wildcard and binding to a specific module
> > > would come for free.  
> > 
> > What would the wildcard do?
> 
> It allows a driver_override to match more than one driver, not too
> dissimilar to your driver_flavor above.  In this case it would match
> all driver names starting with "vfio_pci".  For example if we had:
> 
> softdep vfio-pci pre: vfio-pci-foo vfio-pci-bar
>
> Then we'd pre-seed the condition that drivers foo and bar precede the
> base vfio-pci driver, each will match the device to the driver and have
> an opportunity in their probe function to either claim or skip the
> device.  Userspace could also set and exact driver_override, for
> example if they want to force using the base vfio-pci driver or go
> directly to a specific variant.

Okay, I see. The problem is that this makes 'vfio-pci' monolithic, in
normal situations it will load *everything*.

While that might not seem too bad with these simple drivers, at least
the mlx5 migration driver will have a large dependency tree and pull
in lots of other modules. Even Max's sample from v1 pulls in mlx5_core.ko
and a bunch of other stuff in its orbit.

This is why I want to try for fine grained autoloading first. It
really is the elegant solution if we can work it out.

> > Open coding a match table in probe() and returning failure feels hacky
> > to me.
> 
> How's it any different than Max's get_foo_vfio_pci_driver() that calls
> pci_match_id() with an internal match table?  

Well, I think that is hacky too - but it is hacky only to service user
space compatability so lets put that aside

> It seems a better fit for the existing use cases, for example the
> IGD variant can use a single line table to exclude all except Intel
> VGA class devices in its probe callback, then test availability of
> the extra regions we'd expose, otherwise return -ENODEV.

I don't think we should over-focus on these two firmware triggered
examples. I looked at the Intel GPU driver and it already only reads
the firmware thing for certain PCI ID's, we can absolutely generate a
narrow match table for it. Same is true for the NVIDIA GPU.

The fact this is hard or whatever is beside the point - future drivers
in this scheme should have exact match tables. 

The mlx5 sample is a good example, as it matches a very narrow NVMe
device that is properly labeled with a subvendor ID. It does not match
every NVMe device and then run code to figure it out. I think this is
the right thing to do as it is the only thing that would give us fine
grained module loading.

Even so, I'm not *so* worried about "over matching" - if IGD or the
nvidia stuff load on a wide set of devices then they can just not
enable their extended stuff. It wastes some kernel memory, but it is
OK.

And if some driver *really* gets stuck here the true answer is to
improve the driver core match capability.

> devices in the deny-list and non-endpoint devices.  Many drivers
> clearly place implicit trust in their id_table, others don't.  In the
> case of meta drivers, I think it's fair to make use of the latter
> approach.

Well, AFAIK, the driver core doesn't have a 'try probe, if it fails
then try another driver' approach. One device, one driver. Am I
missing something?

I would prefer not to propose to Greg such a radical change to how
driver loading works..

I also think the softdep/implicit loading/ordering will not be
welcomed, it feels weird to me.

> > We should NOT be avoiding the standard infrastructure for matching
> > drivers to devices by re-implementing it poorly.
> 
> I take some blame for the request_module() behavior of vfio-platform,
> but I think we're on the same page that we don't want to turn
> vfio-pci

Okay, that's good, we can explore the driver core side and see what
could work to decide if we can do fine-grained loading or not.

The question is now how to stage all this work? It is too big to do
all in one shot - can we reform Max's series into something mergable
without the driver core part? For instance removing the
pci_device_driver and dedicated modules and only doing the compat
path? It would look the same from userspace, but the internals would
be split to a library mode.

The patch to add in the device driver would then be small enough to go
along with future driver core changes, and if it fails we still have
several fallback plans to use the librarizided version,.

> into a nexus for loading variant drivers.  Whatever solution we use for
> vfio-pci might translate to replacing that vfio-platform behavior.  

Yes, I'd want to see this too. It shows it is a general enough
idea. Greg has been big on asking for lots of users for driver core
changes, so it is good we have more things.

Thanks,
Jason
