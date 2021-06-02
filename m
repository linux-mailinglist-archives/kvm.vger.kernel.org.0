Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16C1398FAE
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 18:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhFBQLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 12:11:01 -0400
Received: from mail-bn8nam11on2075.outbound.protection.outlook.com ([40.107.236.75]:61583
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229607AbhFBQLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 12:11:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bjr8fsBaKTaXIHvy5Jr+JCg5UztaNiGYLRxVNKzX/5wuZDIG0is8mroELBl5eMGMaDJ/mqp3OLvQJqAeN8Y/vj44knOyAN7fPObVUvLOf3bYzHNooCEz80MjxUgJBHrNc72nSEayU3WtT6H5y/fvYvaLgaRhfX04GAw+IvzUOSXY6kOznEEN5/Axzkn1I4in7amsEush6FZKPhICDOcnp/zRrpWS+d92876ZfogqWzSuX6inAv7XJSDSeu7aPEDV8Pl5v4ZXR7mH2Z6T8jrJfu1CnwvPrVgaKQiWQUzAKIm/vjrPdLYyGNAP5FePLjNa6ZTZCv6kqgApnGg1vMo+Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DZUcJETZTMB2YsThIvbkWzSxqEpXLOy7Ked7yedHAo=;
 b=e0qoL0WJ88t21UQg6NbsIEAbAHkTGcdMI4giynNv6LQL9FlwKF2E/zoR6mxM+Pke6v/Vr1biBZggYOkdLzE+8Nasb6+6XvcV4PMeVFTJ1KMH1r3WTPsZDavC23m3jiGPbQulqd7HrZ2PPLBaotc1FduJHcRsFfm2iNTGsGwrXQk3UdYTfL50iISp9PLD+ElnhryPb6vv1UXhy+4zT8cV2uhoeXyZ80S39+bq9yao5wNY0SDnEesRaAunDWbRPoeGN3At+86c551+6CtuX1+pclSOD4sApWep/3J417DjC+voIA3wde8D6jxWj542JDKNGt/rjPXDinklRwNj2ePNEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DZUcJETZTMB2YsThIvbkWzSxqEpXLOy7Ked7yedHAo=;
 b=S8pRudzJeL6o0ld0awSGGZsjUaFos0xwVQAdvWR0XlPYHmat3Az7uuUVAjYhOTrE1qCcHyuZRFAh/CmPn7waX5kT7la0lD+q1ox3Ah0o+/29SeVfSgfb8JtLTd5NQE6k6mopjqIF8UWsLK1mq6RL/GJJFvUxePeobN/HRdnR0aXvi5k405wdgo5xI1B/WT9BLWDPASvdM192ke02EsQS/4aeRCOOKdgnvSbfKNaZ1GlyP6/hXLdrTnvGwhKgZj0U6ktb84kWwgRSVkj1fY5GkKs4GOTOvdlssaK5/vHbHli2T6j3WWGnnCp8NSXVqML4fosum4rLzoL3yuJSdt/Phg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5270.namprd12.prod.outlook.com (2603:10b6:208:31e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 2 Jun
 2021 16:09:16 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 16:09:16 +0000
Date:   Wed, 2 Jun 2021 13:09:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210602160914.GX1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528173538.GA3816344@nvidia.com>
 <MWHPR11MB18866C362840EA2D45A402188C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601174229.GP1002214@nvidia.com>
 <MWHPR11MB1886283575628D7A2F4BFFAB8C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886283575628D7A2F4BFFAB8C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:208:329::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0085.namprd03.prod.outlook.com (2603:10b6:208:329::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 16:09:15 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loTQg-000HMz-T0; Wed, 02 Jun 2021 13:09:14 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abbc93c5-ab7f-42e3-021a-08d925e0c524
X-MS-TrafficTypeDiagnostic: BL1PR12MB5270:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB527006F18218F9F4630581E0C23D9@BL1PR12MB5270.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nfiKosBQ7M29WBWEWFNvDAIEIpPNMFk75otlTga3WZWse/aHIFlnSQkgxGB4WstsB7WQRvMiS+IbFHHt/ZpQcOafrAggByHOvViTIGd61aU0BE6CNrFY84pxplXBApVJNBFIq6DShxWjkBMxCnlGQP9G1A66c/9IsXwreOQLl4PlXDo5xs4rmsx+gQyWqTufOdmOx+NsoxI6mtUwaCBYjSHwAOjf4ZvZy9pGd0iEIpHdD6c3k2/2obetnzUZCYrkVDx+8EkvIYX5qxnHlvTU12sQYF6oVUFgxQMIkQwcnIjU9avcHRoNT92R8iwQgBEYjLCkCL6VpR+wlj8wHMMRI86+SUfLis6KgcbMDNQyuP/5HzZ3Cf/DLtxcEXbpO0mTPIzo2dtfFsQ9NccPR89Fm4wLSZHuXUjSZzf7mlbrBg+Tcps2WaIZT3AT5M5iAMp429T50tbcBlFhdVdaPReJlC6kMSekqrAkeqDCfZqoxTePkg3QE3V1ayDiNLVM4g54pNX1FJxgQyc6AAgFBeFdovxosTmaB86YNFAvbPYc8IM6iWkJ2gbiD+4kl/UllrmBLqPqFYVebA1lgJdx8mib6DecBE4LO/CiWXUkVAn9T+8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(39850400004)(346002)(376002)(2616005)(8676002)(36756003)(8936002)(478600001)(54906003)(83380400001)(1076003)(9786002)(9746002)(38100700002)(5660300002)(66556008)(66946007)(66476007)(2906002)(4326008)(316002)(86362001)(426003)(186003)(6916009)(33656002)(26005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9Z4jkD/IBlSGuzNHYEyHfyc/kXmUCoXDM5z0rxkobYPdlVp00tQWMuQr/69P?=
 =?us-ascii?Q?lflb7Na2TCXpDbdAT87w4GGKiHKRCY/5LUN8DE5c3ZXTMEQ6y6d8483cytjH?=
 =?us-ascii?Q?cR6sGCjpbsXl/quYlVpcP0/eYHbqgt4TiGTcfFAndPFOsCiSLGWQ/q7GVLsB?=
 =?us-ascii?Q?xZjX2H2SI8pHpP42lm8T4wgIhmegblStWgj/CwW9WigLbjt3Re0NNJFVKsxB?=
 =?us-ascii?Q?yVXTgma4uLISy2LEIDrZTtHw5MntPj2HGR5aB/8JDxu0LByRG8/eetUDS6wL?=
 =?us-ascii?Q?+H7pGcpueL77yWn5RkeqiDkRCqVqlej8whlR0uy2Mb2LPFAZQ4LZAlVJQjbJ?=
 =?us-ascii?Q?hl9Qg2dy7K8U2nzr5Zy3YuZhswY2kts7xP/Q9fnVwEwdilE8dkPHECCakIAH?=
 =?us-ascii?Q?pUcVnK0EpVlpvw52kZTSDvbnHctzRLd0tQ6IdCC73Ue/PFRqac2ZXhjEzgOH?=
 =?us-ascii?Q?c3SE7ppQ7b1sg+RnwhAgguwcxFDRANXr2lNCkCojXtfodKr8JykMSKHwNGfX?=
 =?us-ascii?Q?WKD1BpeJSMn+n0ZgHAW1XNtDdEK3QEQhvOFqKiJWiH1Je32y7Lho5bRKHEE5?=
 =?us-ascii?Q?Q+dYGF1Wq43S9wVWXhU0+RD7XX+0QdUgzmPZW/ajFkmuOeP/mW45LUkdmGth?=
 =?us-ascii?Q?WANzQdy7x4JSdXupExaZ5k5yUzulu1Z14MD58NxMIZ+Lfu2gsz9tVlUvPGsL?=
 =?us-ascii?Q?MKv4TqBR3mVRjyRENpKmSunn85bIdNLvOwphbeTN3juuoOjV0lyTTMceTERz?=
 =?us-ascii?Q?wntQgPMkqFacesisqlLQCPQmGEO4Wa0yIcdx+u09Ll0pAE/Eh01X5uLqIk0R?=
 =?us-ascii?Q?7PolZi8MyekXGAzHnFJ7yIBBjDRI3DWRLUbTwss/JyeOAFCcyN5JXHQ1t1OG?=
 =?us-ascii?Q?DuXfePaaEWXTyD814gLRCEflLPkoX3BtXN36zoQ/f9wJzSG5GY4RdiZVqOIC?=
 =?us-ascii?Q?bsxl0c3zL9vCFY+0yh0QOPSBQYzL8y8YfdBxz/01WjqRUIqf4u0ofltZtYh+?=
 =?us-ascii?Q?U9yS5CN2ytfzmervPiDwUfxxrWk7Ni18JpK8L49PfBP5andJjcE6Iuu+Wa6a?=
 =?us-ascii?Q?2G2o0UICTTE5BDsRUTafLOZNlBTobKyKfELfz9A31t9i/bqoH6gdVNWOFbAk?=
 =?us-ascii?Q?TkbnJ5RM+l+8leQXOHCtYIByLbIQMW/yRQg+RPKNY+tlUGZ5pmbEZ5hnvgXS?=
 =?us-ascii?Q?f80jrsfl9GHu0Y51J99Eu7gS9XIBLKX/1g0LfNiOt88PGb6dRo2+JaFiEG/E?=
 =?us-ascii?Q?zcB4CAZvPo3DZ4woXpJCz8FAYQUGrGVbS6nEnvzSWRXQ9nOxUd+BN6DoQrvF?=
 =?us-ascii?Q?PJ0zIpwUkTPX1YMChakc60eQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abbc93c5-ab7f-42e3-021a-08d925e0c524
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 16:09:16.1572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 04effg+f8XMym+qU9MXqIODPQoCoKn5ZrOdCSKqFkVnF1zGcLklw7cN6/eoMlMac
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5270
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 01:33:22AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, June 2, 2021 1:42 AM
> > 
> > On Tue, Jun 01, 2021 at 08:10:14AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Saturday, May 29, 2021 1:36 AM
> > > >
> > > > On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
> > > >
> > > > > IOASID nesting can be implemented in two ways: hardware nesting and
> > > > > software nesting. With hardware support the child and parent I/O page
> > > > > tables are walked consecutively by the IOMMU to form a nested
> > translation.
> > > > > When it's implemented in software, the ioasid driver is responsible for
> > > > > merging the two-level mappings into a single-level shadow I/O page
> > table.
> > > > > Software nesting requires both child/parent page tables operated
> > through
> > > > > the dma mapping protocol, so any change in either level can be
> > captured
> > > > > by the kernel to update the corresponding shadow mapping.
> > > >
> > > > Why? A SW emulation could do this synchronization during invalidation
> > > > processing if invalidation contained an IOVA range.
> > >
> > > In this proposal we differentiate between host-managed and user-
> > > managed I/O page tables. If host-managed, the user is expected to use
> > > map/unmap cmd explicitly upon any change required on the page table.
> > > If user-managed, the user first binds its page table to the IOMMU and
> > > then use invalidation cmd to flush iotlb when necessary (e.g. typically
> > > not required when changing a PTE from non-present to present).
> > >
> > > We expect user to use map+unmap and bind+invalidate respectively
> > > instead of mixing them together. Following this policy, map+unmap
> > > must be used in both levels for software nesting, so changes in either
> > > level are captured timely to synchronize the shadow mapping.
> > 
> > map+unmap or bind+invalidate is a policy of the IOASID itself set when
> > it is created. If you put two different types in a tree then each IOASID
> > must continue to use its own operation mode.
> > 
> > I don't see a reason to force all IOASIDs in a tree to be consistent??
> 
> only for software nesting. With hardware support the parent uses map
> while the child uses bind.
> 
> Yes, the policy is specified per IOASID. But if the policy violates the
> requirement in a specific nesting mode, then nesting should fail.

I don't get it.

If the IOASID is a page table then it is bind/invalidate. SW or not SW
doesn't matter at all.

> > 
> > A software emulated two level page table where the leaf level is a
> > bound page table in guest memory should continue to use
> > bind/invalidate to maintain the guest page table IOASID even though it
> > is a SW construct.
> 
> with software nesting the leaf should be a host-managed page table
> (or metadata). A bind/invalidate protocol doesn't require the user
> to notify the kernel of every page table change. 

The purpose of invalidate is to inform the implementation that the
page table has changed so it can flush the caches. If the page table
is changed and invalidation is not issued then then the implementation
is free to ignore the changes.

In this way the SW mode is the same as a HW mode with an infinite
cache.

The collaposed shadow page table is really just a cache.

Jason
