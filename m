Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4A841E3A4
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 00:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345795AbhI3WKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 18:10:10 -0400
Received: from mail-dm3nam07on2089.outbound.protection.outlook.com ([40.107.95.89]:20288
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245132AbhI3WKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 18:10:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8t9dKOUwzXwbtWXuU/vqXK2a5WUBJzsegTLlBvRoB3XTFk+B2INDzvMqpRJpQ6NnhPqB/fVCsucOcbykz4v1ouUFG0xOvU4BMGwD9yDRaa8iGBEgM3xbjDyyuDxDf0t+Z10T6D+x0ZGDEj6cWCu2n17VXtYfEwP5qrwX9f9TFk5GdoZ/iPrvHH/EFhMbDTfQ+33t6FGNSYrVgZ3TIvz4qecGEKWUlQxXNBQSl5RYQ49hEGkrcRcfHBunwVt3OYaUiJHvjVaSD0RpCqWqf+SsLZ5iOGB6KzromjAY5RkqGD00gJJOFICZ8/hdarLWQIHu4eIvGLHYDOU6v5KEbvUHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3uyD4Ff0OSsv6edYmNGdaHx7H1A2AQMtXF8tHjsQEUs=;
 b=fcPLyKHL65/zLMEoe3n38bOGE4xwbpIEX503k+Oj8CmnUWDD90O7Izgo4iOwgfY8s0ZjncdfRy37oHq4gwgRPrdJTQKl9AviaDrhJmOmBee4d5VE3oycbqTkAG1f/TpSNTn+IKVGl4vwbMzWqDkGJm6Dj+wII3xPFclp2f8gIak4BbnL5dnS7uRZ4wlvLqT9m83x1Nlf+t542BiE9KnHagconm3c8jSdn6r+cYuJwyrLHWCuBBN4zL9wVvqR8lT2j4P4gL8t30EtL1E/4tQoRQ1FYC1/vfFn0tAn05BcQncPWm3LO0DxiyuT8io8uNFPhJ8dRE4vNspjLN0PUvcXLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3uyD4Ff0OSsv6edYmNGdaHx7H1A2AQMtXF8tHjsQEUs=;
 b=j1ucfU4B6TqHQpiuYvQhutZ8v65UCN2KN4syubVQc6y012YCRecFz7usFahmVJMJuwSDt/rKHqGmALCK7/F3VJzKo4aAJ0eRvXVqqgICf/exkqRTt6QII4dGw42+Dcsff9jCklhyoJk0lXxGin/2pllCxSTh9FHWMOFYU4SkKCzqf+rcAkrPWKf12mgl6mP/81Ei/fXeYesVUsZsZmLxCg4u5LSdt4q9E4RDbrHkLiISYHYp0yGejM7zpB3bzR9Z6jqaEjcMOj1gWAnv6AurVbliMjxCyhtfinJJ0STZhA7uCUEkL4auwUpO1jfz4YsIgUgrYwk4tCJ7DE8NmeEnKQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5223.namprd12.prod.outlook.com (2603:10b6:208:315::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 22:08:24 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 22:08:24 +0000
Date:   Thu, 30 Sep 2021 19:08:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Lu, Baolu" <baolu.lu@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <20210930220822.GG964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YUxTvCt1mYDntO8z@myrica>
 <20210923112716.GE964074@nvidia.com>
 <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923122220.GL964074@nvidia.com>
 <BN9PR11MB5433F33CB7CFBCD41BE2F5C68CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433F33CB7CFBCD41BE2F5C68CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR07CA0029.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::39) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR07CA0029.namprd07.prod.outlook.com (2603:10b6:208:1a0::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Thu, 30 Sep 2021 22:08:23 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mW4E2-008DI0-Sm; Thu, 30 Sep 2021 19:08:22 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bbac8bb-0a19-476f-8973-08d9845ed251
X-MS-TrafficTypeDiagnostic: BL1PR12MB5223:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5223145604DE896BC3CCDD67C2AA9@BL1PR12MB5223.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TkHrtYd4+Iwla1bVf/4E5abCTmQqhx+TvAvX5CiAG0Tuf3YTcZdyb9DR8ijMGql6bsdJao/bSGfnAEAd3jf9EcLH/popySDmzdB//rWPSpu11qgc0Z8KXExIOmBhUSqZ7nngfMMkP0qJdmqNMMBUDxaWKgmEPeuyzMPP0ndCi3wv7Rspl1qibGMHu6yvht5JgVhJ1B+1AsPkkkJIeUcFzWep9F+lQh856sYYHxaflz3phP8liSSAH3XEqTM8XJaSWU11BNWsFn1pTUSF+fbzbhvVOAL3vmfANBL78MVgpjH+68GdP715DKhSxEwE8U5lpG4NQIgWHo5ggMREp5zYRDWLJSZZg4+fCMBaxcEsRGYAmqr0raDd2QBfPwirvWtt+a/M/Oc+CiI1MK4CNW2hXZz2F1fLIwR7xOuAvEKyY0pUfmt0qhlolxY6rOvr8cUGNugdZ8lHobqx8GoFWHrb/apguTwcaWXfQ16ghNOp7AXhkq4rfqKoYQePblJpNwftFkVkVlC/rbtE/7GYZt+IezURThenz5OqXIVdccRr1A7TNLeiR5NcFShhVTgdtcYNobf3CwFxhyPRAy0TAO/TY9esE/N7enuDSVP3/VFkIEBPD9T3+qJ46SMO2OI+wX7Y1ioRrrFcp8cQWZYQ6L2d0zOVhms9IMDD8w27frqxxZ2Ranf4c7D0LYyOYFv/Q8DchMVQahwnt7LlCfw/pJ2SRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(5660300002)(316002)(83380400001)(1076003)(7416002)(2906002)(38100700002)(54906003)(66556008)(66476007)(36756003)(26005)(8676002)(6916009)(186003)(86362001)(9746002)(33656002)(8936002)(4326008)(426003)(508600001)(2616005)(9786002)(66946007)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?huhA6NyoZNr1q5faQSouxgjumTqP4iWRUWNlQ6Ac/wuP71ZBZEdVDQgf1hlJ?=
 =?us-ascii?Q?Qpbz+ZjxYhxWgCcbMS5yj2C1ru/yT0owT6Ll2A3//heLpKyrLqKQMkjtFWN8?=
 =?us-ascii?Q?+aw7TjdM3do+BGKg8vHuEi5GGUe/8A6+joozfcrO7rPZNdhEE3r9pf15CZ4W?=
 =?us-ascii?Q?Z52Zl7h1jPJnGDVjU/TwU90lC/Au1t+Ab3dHN6e2a+gn+2s+vuocieRQcQQ4?=
 =?us-ascii?Q?4wuz2lklUA4oE6xlO/OLmrDvTRCWhK9W8U9Dp55VXgEQLzk1ead89B4d7NX7?=
 =?us-ascii?Q?ggi6PjZ0+QCiGD6GBBRkCyt3dMoPULj/Eqq9VYEAfJwWOE3h2BR3fRCoHbfG?=
 =?us-ascii?Q?fW1ZcxLfM9JcaCZfAyukMA9Wqyurmx2qFF7JKjV/2bMmg+JVP4qg+afaQDhQ?=
 =?us-ascii?Q?r16bNXVrqndW8O6tFLH2GqBCBffdL+dxJbPyxl42woNcRMXv1eTb5zIRY3pP?=
 =?us-ascii?Q?fi64aXBEVobI6ad6Wtsw2jFG3Oba2WQoRUJE9+tBc7oY4iYY5wO0M4B3MYBF?=
 =?us-ascii?Q?1AXveexOdcn983bMtWo154L0sZQjb7zK2WBH614JX10KawP7WLI/hIvOCdfI?=
 =?us-ascii?Q?zt6zsLxCKvw+B4TD3x4P8Cs6sIxADR2144ynsOiKbtuzk7OfsloZloZbGbcs?=
 =?us-ascii?Q?xZIBXUAz2GobRK6dnXea/En63xpWmXasSl4cYN7xoLl9eMNR6+qZ5sPDJinr?=
 =?us-ascii?Q?7fU0/EsUTDqOJXlbWCn8UfHfcuDjw31B6ttZ8S6Jwkman48JtPA1w/4b8rPC?=
 =?us-ascii?Q?5uex8zfSBg4KFErXdtnrRyX1gmdtvHDJPS4IDYm4k4YKEPaoXqfGaxo80Klv?=
 =?us-ascii?Q?buifk2o4Ray7JMu4Wn5I6CipJkNZnaR3KEACnUD0LoCauURxd5IdSinsi5QR?=
 =?us-ascii?Q?8QjSMWHvdvgZULtTrKegKenNVw1+MVnOZxeUmb8vdyDePS1XPiP6W8XExUm2?=
 =?us-ascii?Q?CYQe9mVSziuUWhhEzab96C22SPW7DoRcwFP0tqeIwtzRCtMGC2NGf2YdgVGe?=
 =?us-ascii?Q?WNsJ//GdY0aThhzJyOEJFemSUj+BEyYrNREAA2WskwnPY8wUdXBl+2kWuhw1?=
 =?us-ascii?Q?E8e5Dg4co8iS/0Bn5XBO1SBCv/dhCnpoed8hcBDSlWwJY4XbWSGZOFiXCShe?=
 =?us-ascii?Q?c/cCAcjPYnA1Nt5PLqaUMJQbpdtOsxecH8Mw4bqIzDJsx47uPJDDdqt8CQj6?=
 =?us-ascii?Q?LbA4VAhkZVMMPS0IhskgqvUgqWj2bjKVqxFzcQulzSG4SEDU/jhHMhnP/bua?=
 =?us-ascii?Q?jSDUB7/adR9ECrQIfITcf7fK20RUjgs9qM5a+K9stcinQd3WZS/zFfuHpFZ7?=
 =?us-ascii?Q?g5hHK0fwqv/qscgSchpqQfuf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bbac8bb-0a19-476f-8973-08d9845ed251
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 22:08:24.3412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zmZu0OkRqtyfRiuAKUaTtb37dctGIm9NFs8l4DeDOt1r+910l9lmmTkGK8M1T9ap
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5223
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 08:49:03AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, September 23, 2021 8:22 PM
> > 
> > > > These are different things and need different bits. Since the ARM path
> > > > has a lot more code supporting it, I'd suggest Intel should change
> > > > their code to use IOMMU_BLOCK_NO_SNOOP and abandon
> > IOMMU_CACHE.
> > >
> > > I didn't fully get this point. The end result is same, i.e. making the DMA
> > > cache-coherent when IOMMU_CACHE is set. Or if you help define the
> > > behavior of IOMMU_CACHE, what will you define now?
> > 
> > It is clearly specifying how the kernel API works:
> > 
> >  !IOMMU_CACHE
> >    must call arch cache flushers
> >  IOMMU_CACHE -
> >    do not call arch cache flushers
> >  IOMMU_CACHE|IOMMU_BLOCK_NO_SNOOP -
> >    dot not arch cache flushers, and ignore the no snoop bit.
> 
> Who will set IOMMU_BLOCK_NO_SNOOP?

Basically only qemu due to specialized x86 hypervisor knowledge.

The only purpose of this attribute is to support a specific
virtualization use case where a whole bunch of stuff is broken
together:
 - the cache maintenance instructions are not available to a guest
 - the guest isn't aware that the instructions don't work and tells
   the device to issue no-snoop TLPs
 - The device ignores the 'disable no-snoop' flag in the PCIe config
   space

Thus things become broken.

Jason
