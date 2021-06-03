Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBACA39A142
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFCMmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:42:24 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:25568
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229994AbhFCMmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:42:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UApN7oxGEEJGmC4xxKHwKq4WTOFCobrK+/zPmknmyfEZTbLbAccRIipuufaOoCcNFmagpa/nfQAZNwbErrGSdKe9YO8HTujLd+Q4LO026/w5L0DOctb1khxo26fJn1NMUjn+EHGp7k4s9j3GOKZB2sxl7OgTxl2Bqhib+sJQUAqmwPXNoZyg4k5dX06n6nyjhOuqWqrf/bbhkXOvveEKm7siuQ16FDzzu6OZtZQPnronR6OSQioTwChL3EXwL4U/nHFGsPHvIzd7ajEcjiiviwXgs38JrV81HLS44J1lJiXq1n6GT8bbty7kE7axYQKQVnnGLreUBZMrGv6iZYyemA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GArRFvb6qxrZlIgtI7dfHbOzQ1FaWL7a/m3kBuy5g2k=;
 b=Qomy/BCNVnVizieSDJ3JBdKDOwIMl/8zP42sORJZBHW/JMuhAsP7w+wvj31HZQbRxSfWxNZyhYnvaxswoIrlIqHcgpdwLsmB4VFMkf/PLRjjb5kyCBgRr6K+GtVRCxkVlNZFcZlSQSp2B4lYHEld9f9mErgut48AZ34FJqFJVHIv1Y9CCywbJz2WRcau6GtA6VyryJGm3E4XcAFgl8aWNZGIeEz8zf66u5RDpxodZDeo+gc5wdN2hxKzsceFOjHm+6q63fFc86AZgHr9W+kjKYgq//Zgg9BUckPL8BfLZdpZsjF/uSWLpEkh3u8RGXYNSvbRr+Hd6c60Ql7FoO1x/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GArRFvb6qxrZlIgtI7dfHbOzQ1FaWL7a/m3kBuy5g2k=;
 b=OZhlczRXKNc7ELke5rC/ktaaN5WTOJ+M0wRRR9UKM9JxjWvy7vI9+lKJ1kL+DQdQaKRZ3nt69I/mDlE+vZfMM3iW8GnIxzD7CbalHxjv+UqfKnPcmwQLg+pIApC8dRF+72Yho519DEUU9BpNTxMWmxOldlNwJGD/qQJLQKmc+1/LfovevIbLo+7OI13UNn8VcZskAunQzKRWrF3If6O8vDY5dvUmJX46PnboBMXDerTMiWcLkypdbFk94ooKlLGCMmFtqzPtNcNawoGwvNzQ15k/i211sa77Lpu9A/NrUnHJ878f6Rvzz/Xlc5WDeXqjdDLPPrwUkyODWfwsmfzsuA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5363.namprd12.prod.outlook.com (2603:10b6:208:317::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 12:40:37 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Thu, 3 Jun 2021
 12:40:37 +0000
Date:   Thu, 3 Jun 2021 09:40:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210603124036.GU1002214@nvidia.com>
References: <20210602111117.026d4a26.alex.williamson@redhat.com>
 <20210602173510.GE1002214@nvidia.com>
 <20210602120111.5e5bcf93.alex.williamson@redhat.com>
 <20210602180925.GH1002214@nvidia.com>
 <20210602130053.615db578.alex.williamson@redhat.com>
 <20210602195404.GI1002214@nvidia.com>
 <20210602143734.72fb4fa4.alex.williamson@redhat.com>
 <20210602224536.GJ1002214@nvidia.com>
 <20210602205054.3505c9c3.alex.williamson@redhat.com>
 <MWHPR11MB1886DC8ECF5D56FE485D13D58C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886DC8ECF5D56FE485D13D58C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR02CA0037.namprd02.prod.outlook.com
 (2603:10b6:207:3d::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR02CA0037.namprd02.prod.outlook.com (2603:10b6:207:3d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Thu, 3 Jun 2021 12:40:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lomeK-0014tg-EE; Thu, 03 Jun 2021 09:40:36 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30114161-4256-4950-b911-08d9268cc9c3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB536324CE1F3FA6E154DB9BB5C23C9@BL1PR12MB5363.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RVOKB+VvJY2a/8Zf/1vW8b032/AaGmd4HUmsjKlly6FX95KT8RNb5Iub3V975KizfnCxvoOzQseoaFcWI2JUkjnktm48dXMHXiueAJF4HIAEUH79FPHvpXd3LNgIgRnoSTjpq7UZkI0uYcZ+Y9ATiVz9qw9H+vrpIEYSxxUsl7Ch8jvFKuLOtAm++0nJsicG8nfBvMTWUwRhDxfuLWlJbjH7fxxZOPVvitscIS7bzPT5wsQvAsJrXxbmIToaVa36hvZFE7fwlSBsP+SC0YKuvB82L45fmMQoQfpBhBCyfR2puIKoB7ZYXOKaPTaJ4qb++yQpBvd2HB+mzhY7ZF7O6UBw/t6mpiXWIhNaeuwKH57nrT1zdp+F5r8fPe3Xxi1Qk0FLMj5qo7Y474L1FCjAvdZvozAz8bOk4msOUcvGC5ex6cAUHLZjgxCasDjixEdkLDghRMCOAW4xacTiKhuqsUGnSLiVfTlkz4HVBFNLayvn0haUEDbaDwmRH04fqOAb6y600bH29jlIM2lv0ZKGDek/6s0WP3hPIrfGdTdJPkO/dYRFJhVNanFDnEckxkxeAbGozxBebdbJD5CHCdl+Cgy/aO8Hsr3u22diEnI7D9E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(366004)(136003)(346002)(396003)(9746002)(8676002)(8936002)(9786002)(66476007)(36756003)(66946007)(2616005)(6916009)(426003)(86362001)(5660300002)(83380400001)(66556008)(478600001)(4326008)(1076003)(2906002)(38100700002)(33656002)(186003)(26005)(7416002)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YZdnZq8Xpi4btXc9KAfyLyuoyV1XX7dAa9OVECaUV8r8yXLcz6bgw0Cc3hkC?=
 =?us-ascii?Q?ypT/JISRfugP9NO6mmScWUXlu1YBE51czRc0/ETQIT8KZJS0erIlyoxHtxjC?=
 =?us-ascii?Q?V3s3B0oHJnjX76TNNbEyJziP5fG47AEzx7+p7k+BLo5yqz64yqTBIBUB5CmE?=
 =?us-ascii?Q?95eNZCWJxSw96VyaCD26wHyj5vk40lWscYkDy6bX0dJ040wkYhWYMAAJDDt7?=
 =?us-ascii?Q?OHCf0hstVOBf0INic+R4aUYxIwnua9TMxS2SKvcyd106uQbGk92fJr9aiSB7?=
 =?us-ascii?Q?i74QNyp9/HckbFotb6GBV8OP9Dm0SjyhrjCz6iuXlZAPuegnFGrUHSArgAFg?=
 =?us-ascii?Q?n5g/u1bKt1HXTS5YVs4rYU1dRiABh1wx3BCf4cGuCGgJ/UFzCGTGeQ7toMXX?=
 =?us-ascii?Q?axoXHZVMEvCA7dgVa/aYmlSVy2+36lnQOghbqoCFoZbDDURcR6VgXtk2XWU3?=
 =?us-ascii?Q?pPmLNS7LL3a/Vc+PoxlTcwaTjgEnWrxirvdpXkkb9cYqTvhB5RFqR/VHWLF3?=
 =?us-ascii?Q?jo0Av+mL8sZm+JUpOeSOlLL3IOkCzV8W95aGytS+KNIGFHX6/a6sBU9jH4qK?=
 =?us-ascii?Q?3vugSzMQSCIRXpwBVuwkMVKXIR9zuI6HDYzRiDEd8wSPsb1Zm9hODR5LJHTj?=
 =?us-ascii?Q?F3zpUVomxKNNPTddbc5BZpwlJTCInda2nRUjnt+ejCkESjfH8YDpyosL/Ryu?=
 =?us-ascii?Q?kKm5hwYI+7LmLhRUg+jtmq5d1uhU/DulFb2Z11sEw9nqAanbMXTCcp3xFMk+?=
 =?us-ascii?Q?mhjzSwxNbjCg3ZPPCNicb4z5BOHRUSeyYqrGRBOEfK94oiM+WguMcC5T5tx/?=
 =?us-ascii?Q?Rql7GAJVFfCl5MCXcncZkO9qNEuSjasM6oXxi16106drWer4w3eADi9dEaDm?=
 =?us-ascii?Q?wteeA4iRgclNxl9JKAqAZtig8N9kR6yN/OBB4dcbqWQmTWcoI1195jvugJuv?=
 =?us-ascii?Q?vhviRgA9IL2KxYpgEj9jcoL/ako08KXR9vBxyd7fe2L6MqwdvXfck2JU35xw?=
 =?us-ascii?Q?MAFZo2sPLUW3vF4VWB0Y5RYJ/mJqDZKFYWddRFCMB6fk78T2muoWN14ySsvU?=
 =?us-ascii?Q?OBjkytbY52u5cSxNRU+bKdid7Q/vKdZg6ZpN7CyETvVU641ItuFk5h1IMqJo?=
 =?us-ascii?Q?YGkSB+tlwCf7FDwxytjITOxbPG5ctXz5R1zjHG4E/pIMHmB4icV4OUoLAVIR?=
 =?us-ascii?Q?Dyky6Ee050CL363p7BDbxKWO5qNB6WWRXRxxRTG6GgQxh3qnaPcNzxAiodIN?=
 =?us-ascii?Q?yLlRN6/HeIQjdK4MR6gUQXpAtz2bVrGRaJ4G+nTMJg6bcdfYqiu0GGTq5qgC?=
 =?us-ascii?Q?zoX3UWhgxFKhYw10jMRtr6SY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30114161-4256-4950-b911-08d9268cc9c3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 12:40:37.3154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jY9GE5IAfmndnKsZTxi/if4ATFQjXMQISOgpciP/UcO6rany+/0GbaBplSIZqXQt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5363
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 03:22:27AM +0000, Tian, Kevin wrote:
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, June 3, 2021 10:51 AM
> > 
> > On Wed, 2 Jun 2021 19:45:36 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > > On Wed, Jun 02, 2021 at 02:37:34PM -0600, Alex Williamson wrote:
> > >
> > > > Right.  I don't follow where you're jumping to relaying DMA_PTE_SNP
> > > > from the guest page table... what page table?
> > >
> > > I see my confusion now, the phrasing in your earlier remark led me
> > > think this was about allowing the no-snoop performance enhancement in
> > > some restricted way.
> > >
> > > It is really about blocking no-snoop 100% of the time and then
> > > disabling the dangerous wbinvd when the block is successful.
> > >
> > > Didn't closely read the kvm code :\
> > >
> > > If it was about allowing the optimization then I'd expect the guest to
> > > enable no-snoopable regions via it's vIOMMU and realize them to the
> > > hypervisor and plumb the whole thing through. Hence my remark about
> > > the guest page tables..
> > >
> > > So really the test is just 'were we able to block it' ?
> > 
> > Yup.  Do we really still consider that there's some performance benefit
> > to be had by enabling a device to use no-snoop?  This seems largely a
> > legacy thing.
> 
> Yes, there is indeed performance benefit for device to use no-snoop,
> e.g. 8K display and some imaging processing path, etc. The problem is
> that the IOMMU for such devices is typically a different one from the
> default IOMMU for most devices. This special IOMMU may not have
> the ability of enforcing snoop on no-snoop PCI traffic then this fact
> must be understood by KVM to do proper mtrr/pat/wbinvd virtualization 
> for such devices to work correctly.

Or stated another way:

We in Linux don't have a way to control if the VFIO IO page table will
be snoop or no snoop from userspace so Intel has forced the platform's
IOMMU path for the integrated GPU to be unable to enforce snoop, thus
"solving" the problem.

I don't think that is sustainable in the oveall ecosystem though.

'qemu --allow-no-snoop' makes more sense to me

> When discussing I/O page fault support in another thread, the consensus
> is that an device handle will be registered (by user) or allocated (return
> to user) in /dev/ioasid when binding the device to ioasid fd. From this 
> angle we can register {ioasid_fd, device_handle} to KVM and then call 
> something like ioasidfd_device_is_coherent() to get the property. 
> Anyway the coherency is a per-device property which is not changed 
> by how many I/O page tables are attached to it.

It is not device specific, it is driver specific

As I said before, the question is if the IOASID itself can enforce
snoop, or not. AND if the device will issue no-snoop or not.

Devices that are hard wired to never issue no-snoop are safe even with
an IOASID that cannot enforce snoop. AFAIK really only GPUs use this
feature. Eg I would be comfortable to say mlx5 never uses the no-snoop
TLP flag.

Only the vfio_driver could know this.

Jason
