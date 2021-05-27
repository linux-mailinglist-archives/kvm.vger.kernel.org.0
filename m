Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C683923EA
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 02:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhE0A4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 20:56:20 -0400
Received: from mail-mw2nam12on2083.outbound.protection.outlook.com ([40.107.244.83]:60087
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232692AbhE0A4U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 20:56:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iv6Ad+uDkVJZDjK5enZR7SNZIrqY6Zg/Vv31I0tM4IFlf7EMWqQr5+AI7BpQ7VAec/9NJJcE9ce/FdVXb8URDyi81oFMKy0uUvEuQcDtI3EKSbnke81Osr4a+za68FkLtmzg4TteqrtLCrqWl3V74CAgdj69Gc3UWlEn1PAWYlhW8BxfVsSkHiLcHvr+6pv2Bn4UzTkkj8jt7tJAfHqSXfct8RaO6v6eH7UvjhlC3pvx/eiiJ0Hn6OnenTLgejh0SD8berEJ3hbmkvMX0CvsurWX9ltYzE/Fgp8+7n5/46SsiSJaEVZV+pd5/s25jrANvO7ZqRCky7ttytxlxz0gsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ja/VIpaSI4TSAXk+JEUvwMu80q7fdlOp/W1206XuCvA=;
 b=bD4OYiASpqPoEPaU7tccrCGDF4iiuubKWSWUU7KwLg57ORkyU2aA1Bqz4WXSfXvb0pFIUU6uA8vL45bFHP6CNI2vi+24FZaHh5T0ApFLgfQC91KB29W5UKRQBN7LldTGvQOKhRTE9FqlWdZZTbc9MqSc5LcwnDvUbK59IGLvaX5K/DAyZe4Tcgw51sEoyJbTVzLYGGXi7ny67lheRfp0Ae6bTkzcvAGjJ/UZK2Yj4Tv9GB29Ua9Mq/8AbOpbuvFsDu9RB8qe/FxhWaG4ue2wGmJiFrW2t4y1Do3SbWW3SY1U9ovDVSVJv/rcsPsWX3ZvwMNv4CH50qyGBEigZT+zfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ja/VIpaSI4TSAXk+JEUvwMu80q7fdlOp/W1206XuCvA=;
 b=ZeswwNLWzooEv5RzsHQe9jl6/TlqWiQmhEnNcariQNYo8g2GcKXU/D7bGNKDTcufsn5MsER5JiV+fO7+yY8ZSmA1mH51aonN+LbBSGajV2BAhKKxs6w7KAsYHEFcPiFHseu/xpcGxzgjPMXIfqkPgsQUNaV0mh6YmQwktik0r9zGhmoi7DETgmxAe4xm94xxMsbH76Bs05oa22/LMYkmva4XveAoDQ+pJwDSZY7WWwlLxP36HpK/Y/eadZ7gzwrTPWC79t/APtbX7WN3kxPuJcHTRIYF5C1RNAxEWYdeZRfOu5pEx5JGFL4c7b8/JoEPLIpe5HcRk3Pv4kWM6w8S7Q==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5554.namprd12.prod.outlook.com (2603:10b6:208:1cd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 27 May
 2021 00:54:45 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.020; Thu, 27 May 2021
 00:54:45 +0000
Date:   Wed, 26 May 2021 21:54:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 15/20] vfio/mdev: idxd: ims domain setup for the vdcm
Message-ID: <20210527005444.GV1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164283796.261970.11020270418798826121.stgit@djiang5-desk3.ch.intel.com>
 <20210523235023.GL1002214@nvidia.com>
 <29cec5cd-3f23-f947-4545-f507b3f70988@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29cec5cd-3f23-f947-4545-f507b3f70988@intel.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YT1PR01CA0016.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::29)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0016.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27 via Frontend Transport; Thu, 27 May 2021 00:54:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lm4IO-00FOQC-4L; Wed, 26 May 2021 21:54:44 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cf74d2f-5fc6-4476-7902-08d920aa0566
X-MS-TrafficTypeDiagnostic: BL0PR12MB5554:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5554F789CFE2E4A61A2ABC26C2239@BL0PR12MB5554.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:478;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/KOmqQ4jFqrTU4Za+N4bb6Czs0tAP+PlAhryljEzpNVIHg1j3/GhKHgXwSEez8wOz7jOC8AvaB0H1OwiOHykFvwFvmwuK0O3mtvR47iRxk5+Ms80cuZ2dXmcBDqGtW0cGMupB7TuDb7lFHuxY4opAzNZQ+/ytkXYiZ762yIL7vuW7XMuKz49ZFZFEkNewNqGSR93isOL9vDQfLg0ivT8gx74NoEvN4DN/yZqMmse4L2gCzH0vcJekrVRtRJL8nAg8F2B0UyBqSghdXcg19KLglNZNoh2z4J/CUS258b8HKZt8f9j2pCYgd/6rZsJoAR0DXfxTguHyQSSC76XQbbo4yC/k3sj3h6BsMUxrX4t+tZrGu+EpyGXIpOjIqf7YJs/oQg0+Cuqa/QyQ1F/E8n3yC/aOxQcdFWlanoC5468SDNo9hxHul4MZ8zhCmvvl/smQikNsuTIseA2wERxD5ehbi+aIKtiPDojfNJ4XmiHL36phLYsOSAqWf+7HnUAH74mKOvveAnRIs0xGDyzCthPjpgcdR/P9hWp9PedEWI1MvpM9xzd/XrrqivhsVkcFrv21ZVn//R1W9Z2bl/ujQpB3hfqYhYAPzGBlKVKENYgCg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(426003)(86362001)(2616005)(66946007)(66556008)(186003)(33656002)(1076003)(53546011)(5660300002)(7416002)(9786002)(316002)(9746002)(8676002)(8936002)(4326008)(6916009)(2906002)(26005)(38100700002)(36756003)(66476007)(478600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?E4fF0o4eV3LHMl3gUlvNJyBjJvbJk4ypMxSX9VvtJYYNlzjgjhQhYQIkRVLN?=
 =?us-ascii?Q?s3QSnhAloT0KS1IsNzvWL0kgmv1pdHZaJLM4NzCFa758MwsqeuR2a4jXhQWi?=
 =?us-ascii?Q?zsT7UOAUattFRIgAzGgoCYM4jSqGBqsuiDUep+pcc2j5Dv32hQfqQLkkD9zV?=
 =?us-ascii?Q?DgZG2ojhnqIhXJNN/jXMNGJVcn85wEfpehHpnb4vRVi0HA9QB3nd1vwIVKgB?=
 =?us-ascii?Q?iaGkJtSjVgk4sgFb0LXn3Dkn2ccfsOqkMAK+IdQjwwZS2G/wqfmOfbuRFlHD?=
 =?us-ascii?Q?pb2y06Z2FIVwDBcmK844zLTdWVzxkold94DJovZQK0Y+GYYNbHwu/2Ug+GnY?=
 =?us-ascii?Q?IXMRw2pUam42ZRMHtHpEKy8KnZa61Tiums6ymDJGeKntWVLnbrE+FJ0SP4pR?=
 =?us-ascii?Q?yTEtu4jSXFpGXV7oCIP5bsJS2vakClmrpK4dC9gAkEJ/yDPhdw+WvcIKfcQm?=
 =?us-ascii?Q?Cu+xC++IHlgsyeJRvbB3UtkL4qhZ3D+ajThG5DES/rJaIJANHgHN1dS0CkOU?=
 =?us-ascii?Q?hHEqxQfqkicMijFsKUsBOMbTPnJ3mQsCgOog54g2EOMKmlHVhpEdqR64jZ38?=
 =?us-ascii?Q?gQG1/s8t7/R1EEd9ak26jAZ7H5HFda+Zf9mNUSqiWslcE9qzICukgB0YrHvj?=
 =?us-ascii?Q?jMLykVe9gSz9r/VUvRYQROIye0ZLrH7GKsSh0gtDeWa4QwQ036sBquzL+mZ2?=
 =?us-ascii?Q?iEl+NXGAXRadpIxHY9ASj5O0buV43g34BEiTk0vM5L17PkUKem/RGgoWUWtD?=
 =?us-ascii?Q?JelYmnH/bW0L/CLHwQ8zR2CZ7QHWUy63b1JKt5F60EZD50vVgjLUYje6oVGi?=
 =?us-ascii?Q?p9bg6PH1ynfiZhwQyFklQBN4deE0zQJktQUFPcdYlQsHUpf2Pcw3MFZxBBZa?=
 =?us-ascii?Q?Jjkx6y1cd8OZN5oQ2WM6u1wR5KEb/rQkADWHaPA/+vdzX2dsFRUQBbXnXWJS?=
 =?us-ascii?Q?eQrbAp++4PijFNsAiQVus5uigehPKCbjTD/d155h3ltMMw9tXW+SSP2dvZgy?=
 =?us-ascii?Q?btdwPxIA9HV2+MQs7KP0h+un4Gwi3ikRAkJtyoMux3gjmqomjP06Ql3lPZiT?=
 =?us-ascii?Q?VX9qegmJXg716oVmmbTrQN88NqU5q2fPR6DU0YnSq+8d3HW1DO0DdZa/6421?=
 =?us-ascii?Q?7VnsOvI7YIIqhhpqnF9ZeL3DW7X2SfhuTSWycIji+NglZ0NwvonEHoqHAN7a?=
 =?us-ascii?Q?X4giHgL1pbPGUF31OrRviuLyMq0AcPoFLWmnGf6WIEv1iLtOp0jYGpryCara?=
 =?us-ascii?Q?yOFJvCvggm1J6yDjv0vEPtKwarSTFSetVGsszW7qjvuoF6xzr5Wy4D57pp9f?=
 =?us-ascii?Q?gAZVA2jTr/Bu8HM9YP+WgbiT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf74d2f-5fc6-4476-7902-08d920aa0566
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 00:54:45.8160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5W9me2EFK39IW0VDQth85HPHxOqLQjDJGl/jo+UpVA0XkCkJ0Fog8qP68gMk0wCj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5554
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 05:22:22PM -0700, Dave Jiang wrote:
> 
> On 5/23/2021 4:50 PM, Jason Gunthorpe wrote:
> > On Fri, May 21, 2021 at 05:20:37PM -0700, Dave Jiang wrote:
> > > @@ -77,8 +80,18 @@ int idxd_mdev_host_init(struct idxd_device *idxd, struct mdev_driver *drv)
> > >   		return rc;
> > >   	}
> > > +	ims_info.max_slots = idxd->ims_size;
> > > +	ims_info.slots = idxd->reg_base + idxd->ims_offset;
> > > +	idxd->ims_domain = pci_ims_array_create_msi_irq_domain(idxd->pdev, &ims_info);
> > > +	if (!idxd->ims_domain) {
> > > +		dev_warn(dev, "Fail to acquire IMS domain\n");
> > > +		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
> > > +		return -ENODEV;
> > > +	}
> > I'm quite surprised that every mdev doesn't create its own ims_domain
> > in its probe function.
> > 
> > This places a global total limit on the # of vectors which makes me
> > ask what was the point of using IMS in the first place ?
> > 
> > The entire idea for IMS was to make the whole allocation system fully
> > dynamic based on demand.
> 
> Hi Jason, thank you for the review of the series.
> 
> My understanding is that the driver creates a single IMS domain for the
> device and provides the address base and IMS numbers for the domain based on
> device IMS resources. So the IMS region needs to be contiguous. Each mdev
> can call msi_domain_alloc_irqs() and acquire the number of IMS vectors it
> desires and the DEV MSI core code will keep track of which vectors are being
> used. This allows the mdev devices to dynamically allocate based on demand.
> If the driver allocates a domain per mdev, it'll needs to do internal
> accounting of the base and vector numbers for each of those domains that the
> MSI core already provides. Isn't that what we are trying to avoid? As mdevs
> come and go, that partitioning will become fragmented.

I suppose it depends entirely on how the HW works.

If the HW has a fixed number of interrupt vectors organized in a
single table then by all means allocate a single domain that spans the
entire fixed HW vector space. But then why do we have a ims_size
variable here??

However, that really begs the question of why the HW is using IMS at
all? I'd expect needing 2x-10x the max MSI-X vector size before
reaching for IMS.

So does IDXD really have like a 4k - 40k entry linear IMS vector table
to wrap a shared domain around?

Basically, that isn't really "scalable" it is just "bigger".

Fully scalable would be for every mdev to point to its own 2k entry
IMS table that is allocated on the fly. Every mdev gets a domain and
every domain is fully utilized by the mdev in emulating
MSI-X. Basically for a device like idxd every PASID would have to map
to a IMS vector table array.

I suppose that was not what was done?

Jason
