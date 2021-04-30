Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358D836FF60
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 19:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhD3RUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 13:20:00 -0400
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com ([40.107.244.77]:49504
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229990AbhD3RT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 13:19:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4JEcp1QpuljSC8cm9f/Hbd6Ucesa7BLGFvh7NS+XXY6uw8tyz6WtCs1eNrxMaJfI5j/1CjEZ0NmcTPOt2ZRP9p2VggsCQEbndK/WluAriktLz6+zL1tlBTadkvwucoKkXgEUUhNR12rtLq1EA9AkNzBGvaw7iRYB0fXZIEgPmVgsy+wDuXXdTJ+53BhIixVN51wwD7pJSwW9uiw3c9QfzYgcx517gFIcGr+/ZyzSm55fEbQSwWchku17WDLbudPalynlum2lHfcGnj/+SNng6mAzPj2W0ssnVQ0yr2CZuVwpRvGjvOD0NkCEXsMhs+jlBhxe78Q0UbgVPf2bEWqnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lfwm/swUR44PMw1uX9MaPu2Q19UWNQycB2g8tznkQ80=;
 b=n/820dLKCGcj79iaOKcDBqMzRQB78W1TYzibTdY/Fh02OV9YnEFDoo3Rqig7riFktxlY+T8TKL02UL/xjX8dI/cdXAviSKZd/r9sVsiPTb1SuYioBWVRLXETNCrYq+IgItWJtTQocr80l6LvYA3QknyY9fGNqbV/KlLUie2E/SvEWgWPOrqZL2dn53Ct4H8DUOZejU/RqyfgaeYsqYeKOXR7jDdkvZEuM3TI7RR+b/fxjV/SN3iPFGGMXbcPWFATzK04sWXGPDg6tSIRNERuBKdDIHkX7IsQA9ccMfl7oNA4trXB+1/zRvlABsRL28NQP47gIidEKBVJ7D/NLLDBLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lfwm/swUR44PMw1uX9MaPu2Q19UWNQycB2g8tznkQ80=;
 b=fouJOIGh2XiGn8dE7YhUIHu022pTP+NQ+//oGmTdw/yV4aPS9sxWMD4ytjjmma4TGviSOyGTWwtPDJO/g1Td2F37tFmfplW+VW8ZmDzcVlm72SB4uYc0tfynlXXrLOL0tW0t9lwrDSwy4Z2XxFuu4L3+npQMsRjYdH1LvhZ055BPdXioGW2l0LqQvmbwPNWB2L9VUY8mDbEH6NRi+lGlYETuqxSAw05dGO5BgP8r4WEQhBigWW8x16G30x+6yriixzkDXSE1XWRdJ2fzn5IN3ivyhr5qiG+dIolTdMnon7jlhGlgwYA/+JBxTKmOif06DvsMAY9lAg01pm6R6pPNfg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3929.namprd12.prod.outlook.com (2603:10b6:5:148::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Fri, 30 Apr
 2021 17:19:10 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 17:19:09 +0000
Date:   Fri, 30 Apr 2021 14:19:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 07/13] vfio/ccw: Convert to use
 vfio_register_group_dev()
Message-ID: <20210430171908.GD1370958@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428190949.4360afb7.cohuck@redhat.com>
 <20210428172008.GV1370958@nvidia.com>
 <20210429135855.443b7a1b.cohuck@redhat.com>
 <20210429181347.GA3414759@nvidia.com>
 <20210430143140.378904bf.cohuck@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430143140.378904bf.cohuck@redhat.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH0PR03CA0155.namprd03.prod.outlook.com
 (2603:10b6:610:ce::10) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0155.namprd03.prod.outlook.com (2603:10b6:610:ce::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 17:19:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lcWnE-00F0Lk-0q; Fri, 30 Apr 2021 14:19:08 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7f6f839-292f-4ead-05be-08d90bfc10fb
X-MS-TrafficTypeDiagnostic: DM6PR12MB3929:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB39292EA0B79E5F92A63AE8BEC25E9@DM6PR12MB3929.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v6YewbGWB9NfLAd/70yH23ZO4xpZDFibL+d9/NAuOVr4OhJVhwAzB0pkMJK3tfmaAMe+Fjh7AYiZd7aEVw7vp9RZ05f5CHoG/xQvjaGit7LOi/GYlw1No9Whc4uIPpT0nPrU1lCgiymYAYpEnMsPrR+ijPoyagMDZxJvC6TCpuEgbnXx59bmGQCYzSA6exKkZLcKCTetvMye5hY7KdVksvmRSpjDxsgEC1B0wANKTmDbSrZDtt5PLsxK0uSaVR//xBAiIg/DR1u9k7w/IpvH4DwL8h0AcYH49KkybhfRFZ5NhBL47INM+8ubA/RI4+h3G1K7wWLRZpS9JoeKh3lsHN9LyDrbTMI2p9Esa1hTPzVnlpCr+N0Ij30PTBrNlh4a9GpT2t/eHavfWyvksr+A+2DHCSD85+eOo9Bb809owlMi25QFmC6rRCnOW9FkeNI5rm25wJaq97hhNzYVT5qtjkeFE1o31SsrMqeklBM/k4O1+DBKDdENfOtzycVgfRRnmDwIFzHmANKwsTY8h+Q1u4QnDTxQ0KivT3KtO4wOO0e0UKFdohUWkYBDK3wgMSZb96GIKEEh8qvCmY89cWGxY+n8fsFpzCGkx+V3gX13hfE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(9786002)(7416002)(107886003)(316002)(9746002)(83380400001)(478600001)(54906003)(86362001)(36756003)(5660300002)(8676002)(66556008)(6916009)(4326008)(2906002)(26005)(66476007)(33656002)(1076003)(8936002)(2616005)(426003)(186003)(38100700002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6HEAcfpBqJ1Pd/b17Mij5hlMiS2V0fl9IT9yQoZ91U2HL6Gk54J1hYhtTCIm?=
 =?us-ascii?Q?dWbGPXRQgkjeVV+0EyNeCUxIj7dXZ//y9vSpydK5OfjfifczThwGxwHLEimO?=
 =?us-ascii?Q?RSetg93LW82sRm75u3HAjdskskIHqqRJP4MIZ7OrXYM7NRCu/KvqXPKv/pyP?=
 =?us-ascii?Q?NoWMF4/DNrTdYefz+VAkhveGo8TLsXKTy8Cj/1DEk56sTRHte4OzqkayqYvB?=
 =?us-ascii?Q?h0LQpu7opYdulViKh2eEVJSJQFHnDN5y4CT0Vh58s3KN3D7ywDYUQZ+oo1h9?=
 =?us-ascii?Q?znou57FibDjKyyxhphZhuiMgE4IF+j+6VpFZ8R4NiQDlCs57H6DwX/WtBqv2?=
 =?us-ascii?Q?NGCzXnDitkFc/HplPS8mh7gzNTTEK7eB/EZGiMOd/BNMulo3AtB91YWsHQSN?=
 =?us-ascii?Q?dgOnFCuSQ77hrpjqmVzQvNP/N+OHIoDpUFm0SO0gDAFGLmhXxCOLWYaOqAmd?=
 =?us-ascii?Q?AsXz4WP7wI8dguHjIXbKNHxTbFDad6dd9E3KVtXjlkhMSFzjBQn/ZQjP4gPm?=
 =?us-ascii?Q?Pb/BCcmLzQ7ClVuvAtNmtl7N+TekFq53JoxWDkrQHfYvM5p5HoIAbITmIhKA?=
 =?us-ascii?Q?aS69807PjKM43Ygh9kCcJKsEIWRBt6kPp2UlJkctoApWlLHqR9SNKyBjvJhU?=
 =?us-ascii?Q?DdvnCv0MN8OsAZl5vgZmxbbAO+mnO7T14Lo+3ikQbJOf2mF0VPkdoIzKndb0?=
 =?us-ascii?Q?ibE0u1LMfbcE7tXT0KQz9kW7lvM/yEDws06wAu7igG+ttHoWaXYuUBEBP87O?=
 =?us-ascii?Q?tlVMAPZ1aGgU4VxiP4I5T40mWeebecW2kX6ZtyINWjktnVXCkWwIS6vwEoJ0?=
 =?us-ascii?Q?Tg3ps7Gj1G2M8Zbxckb02UCoYGFj+5TfyoOofcOzvo/kxel1m4YYyjzlR16P?=
 =?us-ascii?Q?cMGQU06KIBi2bu5eHXwLXHaZPVP733db4a4615+933tf8+ahPxAeBMc/YsDV?=
 =?us-ascii?Q?P4rlgiRpvMkpTfy3KArtHciUg8ICFdrwBopjdEQ62S/SrGwbKxzSQjGCrsmc?=
 =?us-ascii?Q?jJsSfEyxMI3+JUEkziPtbSzxdV6Lfe8FgtEddnFdgADne2ir3Zl0RxH7Ujrz?=
 =?us-ascii?Q?SHtx0Lxlfqzz/SmRXXuQI219w/zZTorwIAqfqu4d7LpElH9WoYBxrzGxZwdS?=
 =?us-ascii?Q?TAEWVMPVMvPl2f6TmaTY0OcjfsZH/8IWERA+xIYUfCtRQBS1eLBOjhWIjVy9?=
 =?us-ascii?Q?MBRCAety561m+cwEqdlOiFx85i7LhuxS++l4q/fTu3jdgoQs4QNEllZobi+P?=
 =?us-ascii?Q?tIOiNvoG7vJCiyVv+Y/v3OXI7uPApzaCrBvcMrDr1JxCKr242dBo0YggGojV?=
 =?us-ascii?Q?2HvJICZ2HLdBwgzbSbEUO3y+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7f6f839-292f-4ead-05be-08d90bfc10fb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 17:19:09.7034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xxps9Fuo1N7uDP1/fWi7g1r6ZU6iowtA00U6a+k/1wYFFvjJIasjyUMAgkElJuRG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3929
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 02:31:40PM +0200, Cornelia Huck wrote:
> On Thu, 29 Apr 2021 15:13:47 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Thu, Apr 29, 2021 at 01:58:55PM +0200, Cornelia Huck wrote:
> > 
> > > > This seems like one of these cases where using the mdev GUID API
> > > > was not a great fit. The ccs_driver should have just directly
> > > > created a vfio_device and not gone into the mdev guid lifecycle
> > > > world.  
> > > 
> > > I don't remember much of the discussion back then, but I don't think
> > > the explicit generation of devices was the part we needed, but rather
> > > some other kind of mediation -- probably iommu related, as subchannels
> > > don't have that concept on their own. Anyway, too late to change now.  
> > 
> > The mdev part does three significant things:
> >  - Provide a lifecycle model based on sysfs and the GUIDs
> >  - Hackily inject itself into the VFIO IOMMU code as a special case
> >  - Force the creation of a unique iommu group as the group FD is
> >    mandatory to get the device FD.
> > 
> > This is why PASID is such a mess for mdev because it requires even
> > more special hacky stuff to link up the dummy IOMMU but still operate
> > within the iommu group of the parent device.
> > 
> > I can see an alternative arrangement using the /dev/ioasid idea that
> > is a lot less hacky and does not force the mdev guid lifecycle on
> > everyone that wants to create vfio_device.
> 
> I have not followed that discussion -- do you have a summary or a
> pointer?

I think it is still evolving, I'm hoping Intel can draft some RFC
soonish

Basically, I'd imagine to put the mdev driver itself directly in
charge of how the iommu is operated. When the driver is commanded to
connect to an ioasid (which is sort of like a VFIO container) it can
tell drivers/iommu exactly what it wants, be it a PASID in a physical
iommu device or a simple SW "page table" like the current mdevs use.

This would replace all the round about stuff to try and get other
components to setup things the way they hope the mdev driver needs.

> > All the checks for !private need some kind of locking. The driver core
> > model is that the 'struct device_driver' callbacks are all called
> > under the device_lock (this prevents the driver unbinding during the
> > callback). I didn't check if ccs does this or not..
> 
> probe/remove/shutdown are basically a forward of the callbacks at the
> bus level.

These are all covered by device_lock

> The css bus should make sure that we serialize
> irq/sch_event/chp_event with probe/remove.

Hum it doesn't look OK, like here:

css_process_crw()
  css_evaluate_subchannel()
   sch = bus_find_device()
      -- So we have a refcount on the struct device
   css_evaluate_known_subchannel() {
	if (sch->driver) {
		if (sch->driver->sch_event)
			ret = sch->driver->sch_event(sch, slow);
   }

But the above call and touches to sch->driver (which is really just
sch->dev.driver) are unlocked and racy.

I would hold the device_lock() over all touches to sch->driver outside
of a driver core callback.

Jason
