Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EF6345FFC
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 14:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhCWNnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 09:43:19 -0400
Received: from mail-bn8nam08on2074.outbound.protection.outlook.com ([40.107.100.74]:21985
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231464AbhCWNmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 09:42:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/pAN5d0dJyA+WeTKZS2CXwquSjjiTAZeFw5CqUJcJJkJtpY0HQ2gEUQcHNhtErb48aOw3Hbt9xuxKK+HCjFmv3E2zQ69x00e6mszByzAswqSFZ7bIoZ12hlCu+T1jvuywHKUH0TA4La03K/PFL+++mHM/FgXjqevo6xG7uTWIF8wWBjd6lJTaCLFQ/M4T31QGHwaTSor6gpaHfAtCSQ7XpkkW+9bJUHrVHMjPgOhzdZDiKIdQAPYMTenUd+4OAOt5n7F+AY2b0Hvhg9IOfLGox2tH5j7j2sCBU6tFu1lL6LNnff92ZTbCrlbMmy4v7Zwhbawxb7U76joDC8TWXS1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhxwkP7c19LOlWhzQ3VZM9VrkerVDpKfAVdvwTEOBd4=;
 b=ah5z5HLVrMa2ZjDm0YTBkcEny9tYAaB2IWI0RO8sDasQ1kYWpTI+RFy3QMN4L/9/+AowigYohQ9Hm2U3iLI9EvfQZOds9FhLtfpATRK+q7J3Hpf8Do+r0JgMWbGwM3kqLAFVlHmmc9U4tTROge6fpg0U8AnHNBJuXs2mmPWjFqzQ7ej4dM0E4yC/KOm4zjDBGW184e+OE6ENy8cCH1sGDCehGqltBk+GJHm3zmek6+pACN57PmAtbv0nDzVjHKFVIxKZ+kVyraCeSIr9/yPSzwp1unLJeWWGxoZMCpgJ8L/44A6PUz5VnY+3ASKnAmugZg0+PhYqt6a944ohREV/zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhxwkP7c19LOlWhzQ3VZM9VrkerVDpKfAVdvwTEOBd4=;
 b=P1stG7fs7XsWH1Mm7oztirRpgxZHNQrY1/Pfg5bRDnROo5b7UJc+Wb3KQtGyNqWbiGTMJSHBbrBPuUZZlmauQt25mYD9CGjOypUbnNutbuRZgIRTjIL82J+7JHtaEk7oARMFO3khSr1OesaFEP678mn4kMq5tsz2zeef5fVGrS5EOiTuLavAmZGxh6jD24jWWhfWrYxTK4z+q2gC0wBtZFmmL4gHavkZgnqgKRPwQnOLgiibtQ45TKO/tHZC/Hmrl3tEx5z8u/M7HvOM2Pzigq1bh3Q2QX4Flw+udPpaIo22owuLTU4N2efgH8e3Sv5U89qqq8CWbzD+eUqClR2RgA==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4620.namprd12.prod.outlook.com (2603:10b6:5:76::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Tue, 23 Mar
 2021 13:42:49 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 13:42:49 +0000
Date:   Tue, 23 Mar 2021 10:42:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <20210323134247.GC2356281@nvidia.com>
References: <20210319092341.14bb179a@omen.home.shazbot.org>
 <20210319161722.GY2356281@nvidia.com>
 <20210319162033.GA18218@lst.de>
 <20210319162848.GZ2356281@nvidia.com>
 <20210319163449.GA19186@lst.de>
 <20210319113642.4a9b0be1@omen.home.shazbot.org>
 <20210319200749.GB2356281@nvidia.com>
 <20210322151125.GA1051@lst.de>
 <20210322164411.GV2356281@nvidia.com>
 <20210323131709.GA1982@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323131709.GA1982@lst.de>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YTXPR0101CA0014.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTXPR0101CA0014.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24 via Frontend Transport; Tue, 23 Mar 2021 13:42:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOhJ1-001WHz-0b; Tue, 23 Mar 2021 10:42:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92b0ab43-6ebd-4616-b25f-08d8ee018bf6
X-MS-TrafficTypeDiagnostic: DM6PR12MB4620:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4620ED7EE0B2282575B3F77FC2649@DM6PR12MB4620.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 92xCLbgxgANwQKr5yqBlKITrj3F9uir+FxZCttj2lTavLI7iRj7sdrjxqo1w2tb7qLNJeXUyPYVxBUBB7NGB1VRXFMiPWac3/kh7f2CDI1akFj0TnhKLqCQKz5audkkWGZcqxDZ5RfAuDZ8Cl9slYO0U87TySovAfmkljzj2UeBhcebx3xIPmU4/dKfQwFoN5jz4HKFm12c0+qq+QQvBZnSTE0t/5faCJZkFirp7fmw5LMQGdz8z/ImWPr+Q8LaG4tKvR5W2B2p+PKTOv8S6KW7jDtIvpwXu/tum25LQVL2/CV/aXffble2abDVUW2C02a3We6MVW8crw9nQTc01lJWpbAohs06Cpw6JMkZsReKL6impn3lce9qr6MpuT4cZey4jcZDe8iWicJpviPWPAjgGZ1XgkKivJqbms6rS3MfC318RhwSZDjEPpuVff0ntF3fpS6gfCI0ECasVdZYLW7Hi+q3+AR/V5T7P3T7xxum2vYHdECcnSCr9+MwBurEFmJUKQ7J1dsbntn2uKGuRw9W4HjUYkomQbwZ/3HLQUCLpvOgVFpeK2pdvFbFDOIFS3r301bGLKAU5tMMhdOqNClhtmNls1IgQ9aE+a3ZlJuSaGAjB9CF5n+9ka8dV0aaT+16Y1M3fUPNeCjiXW7mz772XdYbhnmSQdE7J2RbCuBw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(1076003)(316002)(86362001)(38100700001)(8676002)(2906002)(426003)(36756003)(4326008)(33656002)(5660300002)(83380400001)(8936002)(66946007)(9746002)(478600001)(9786002)(186003)(26005)(54906003)(6916009)(66556008)(2616005)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kxIp76Gr3WbnMxPuCPLlWmZVrV5hz5NHqxa7x1Q2plmoHJ+7eA+cgm9eWQJn?=
 =?us-ascii?Q?zZ+eV1Tu0n6nzz15Wzca2TwnU4v07XsVcBlaX4DZBdI7VlGWoCCAmSWBtMw+?=
 =?us-ascii?Q?5+wuje2InoQkgCrchFKfPK7HyMP0x1DAHnYjpHFSyC2wturtNGto4E39aLlx?=
 =?us-ascii?Q?T19YGsWM8qs+xNBtA65yxN6aP6ou6E9fenNiz4RVDEUaU+2hoZuytwrF+voM?=
 =?us-ascii?Q?FhK11fI6SLTCROWQhqT1Y4O7ssBqyD0VyRLvTBQvt4NVbDxqY+P0VS1eh3tI?=
 =?us-ascii?Q?436zUqF6nYHC/3G1dOUcxdf9NK72cw7qcBT/uVj6O7pG77nZNL79ZZZxMdOf?=
 =?us-ascii?Q?TWylOhOMy9J4WfE+UrjahWrLk4swbmfDQgHoVBa6AqPrcRJd/X28kzWZn7Nu?=
 =?us-ascii?Q?WRsVQNKKDij/irWscsFvT3vSSXhIZoDAiylfLeZmIXBQX9BVmRt89J7STuWs?=
 =?us-ascii?Q?BPCKxtLqmpVlDjSoJuVWQR2r6OEBfZOe4mmAmt8/+Wfvuz7NeSM6Iwv3PTsz?=
 =?us-ascii?Q?gEUI6OwN8410Znxto5hJXXldZbw0Gl1rUe1szAewjmg6FcGyHwdRenhYJXTj?=
 =?us-ascii?Q?Zf6anEcIuHVs1U01v/27FIxfzk7j0+0Sr6PvMd7KytX3v7TB4/xVquHvp7n3?=
 =?us-ascii?Q?Th4xkq7ZY1gpn25aq2aQg9LAAStxF97mZEI4j2t6vyJEfIdeiWzax3MMEw3k?=
 =?us-ascii?Q?hpyWj/6ZmLhtmkbQdK87fOZ1dl/Kd0NgVkRyun6UQQBUx+FstwXaZyHbyaue?=
 =?us-ascii?Q?eceff+4ijIq9704db/Bh5egeLG38Ci0ltJwiD2ac9WqhIA3GBAzTzfr4a7DZ?=
 =?us-ascii?Q?uLrj7J4cdwpQ3yCySxkU4r0QgToWnv1ht2w5pXfxIyGplN08L5PhxPsn5AdP?=
 =?us-ascii?Q?TpZzgXfjEQnDG4FH2khvK4/LBttQNt33KUgYU0fUR4ixy3a5qyX5LLji4O9Z?=
 =?us-ascii?Q?yCYdgWuTwXtiybRtb/ZkZCRQs/6K6QafZsmNWPL4Xf8XJZQOyMs9co1rC8+s?=
 =?us-ascii?Q?wAOd06OCACq/4WiH7G/U3v1Erze2YqNefRjlIfm3aDZMLzWHwnzXCoUKIpJl?=
 =?us-ascii?Q?ER1QPYr5dbSNfScCblvOz7G/qW+7apUX9ZqyhvyUakgRobNWEkdevIzhXQcx?=
 =?us-ascii?Q?Ky1vDJs/IgTVRWR6PPBkFN4PuTsKiCJor0wdoo48scLWFRWNbdmmSstBJ3ca?=
 =?us-ascii?Q?yaZ6wHnLW9PY6tz/R6U30/YS8H+1MXIDc6tN3J/0F0ObP8TIY4bryQlXGKop?=
 =?us-ascii?Q?AmI7PFu5si+cM/K6aH9xR1AMd+z41/Woq36XV96R9jQFAPxSePa2jBNlx2Uk?=
 =?us-ascii?Q?nTLz01QlLergEci6rRyrODQl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b0ab43-6ebd-4616-b25f-08d8ee018bf6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 13:42:48.9090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lpDv6ygBL/qrHhYwmSXBFfg4NBE5yYqe1sbtP6AdDREszNzvbCwCphTmrSuBS9t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4620
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 02:17:09PM +0100, Christoph Hellwig wrote:
> On Mon, Mar 22, 2021 at 01:44:11PM -0300, Jason Gunthorpe wrote:
> > This isn't quite the scenario that needs solving. Lets go back to
> > Max's V1 posting:
> > 
> > The mlx5_vfio_pci.c pci_driver matches this:
> > 
> > +	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1042,
> > +			 PCI_VENDOR_ID_MELLANOX, PCI_ANY_ID) }, /* Virtio SNAP controllers */
> > 
> > This overlaps with the match table in
> > drivers/virtio/virtio_pci_common.c:
> > 
> >         { PCI_DEVICE(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
> > 
> > So, if we do as you propose we have to add something mellanox specific
> > to virtio_pci_common which seems to me to just repeating this whole
> > problem except in more drivers.
> 
> Oh, yikes.  

This is why I keep saying it is a VFIO driver - it has no relation to
the normal kernel drivers on the hypervisor. Even loading a normal
kernel driver and switching to a VFIO mode would be unacceptably
slow/disruptive.

The goal is to go directly to a VFIO mode driver with PCI driver auto
probing disabled to avoid attaching a regular driver. Big servers will
have 1000's of these things.

> > The general thing that that is happening is people are adding VM
> > migration capability to existing standard PCI interfaces like VFIO,
> > NVMe, etc
> 
> Well, if a migration capability is added to virtio (or NVMe) it should
> be standardized and not vendor specific.

It would be nice, but it would be a challenging standard to write.

I think the industry is still in the pre-standards mode of trying to
even figure out how this stuff should work.

IMHO PCI sig needs to tackle a big part of this as we can't embed any
migration controls in the VF itself, it has to be secure for only
hypervisor use.

What we've got now is a Linux standard in VFIO where the uAPI to
manage migration is multi-vendor and we want to plug drivers into
that.

If in a few years the industry also develops HW standards then I
imagine using the same mechanism to plug in these standards based
implementation.

Jason
