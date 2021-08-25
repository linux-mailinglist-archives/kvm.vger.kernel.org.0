Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F103F7547
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 14:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240372AbhHYMq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 08:46:27 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:17452
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229873AbhHYMq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 08:46:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aihaggzLRN654neyqDZ98qkklFnrLlM59L1JhdU05HFn2e4MLyRAOQA2Xl1ooqZOkyBX8RZiNVvTcNSo9UsKg3ouOxIJHBIXxm3M/PBaipnI1bc62s1iUbuJJ4OFoRXAvW6uBoVgtUzLyhF+rQ2cCLYAH62bwk+pFtbQzdUxN7Wpzc9gOe9cXp/txbPaR7kyQxjkeUgRuyZw/uE0UFHDvLzFX27iVxKzbH3JowAdDnI/LwNqgUvyBnfCQiBHnCtdQUr1GCgU3Kr4Oxa89pdlIuZfai+E2hvbdrJja5UzyrZMK+sKU+qBodiXcQH/6KYzParneMplP+H4VmFHbe6jBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CjEJVAODQXvJDNcdNwismXoxn9pIh5qEzZBZ9+qNfs=;
 b=g/KRKuXACzlLQn26Afl866EzSNkZCneWTP6oqNKRRC3UjSwU2GjdwUDjYpRtbDqMMCvxleIdZ1aBESViJzyOjkvbTVSLZcNp2DBWlEBlrRoeJJaLyXGBeRr5K4h0PmkpVDvK19nuYnbXy2zdCp2tlXm1Uu+yl/E+KVfD7sbQR/Tltm3gTcsfXEIF3L5jOpAkXUjGS9hbsrhjOSk607ormiXOHqCpG/Ehv5gfedalL+J6Nb0xr7jdKYwDVqR1nc/wfrKhOX8iyruvG3Y5r7lt6HIhustVd2cOPttjf2CmYngYoVJquGjXxXkFY8RSnOU4XqiEtyqz1/owtgoZr36LMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CjEJVAODQXvJDNcdNwismXoxn9pIh5qEzZBZ9+qNfs=;
 b=rDpJIiBXZxNgVIEwm6NNFBjSvRhC36xn2xxcCa4U+2y/lUM56XgE0yMgFEC/omBK/DaihgTdyZyp8mT961BIZ27q6pLb1gkFqNvnQkjw0ctgedd7yi45S8Fkic0Vv6l2EHAsF2qXzR/FWRRPJAs20hAGw2vy30sK653n0pu/HAZZWk7wgdg9a2xYB0U49AEgAzkyTeADrJmqq2wavcyZkvLNbmwDPVEczfMdkubMaX5kfQ+FcCIpBh1J0q2IU8NGEdJxlG88Z5ok5NyJ9UoP/fGvpJ3cIZWe/z17DLv9xxVmd1PJ0Nv9qt8g9ylTGNJyFc0DRCwHyYEd8OA+zTI+ew==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 25 Aug
 2021 12:45:39 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 12:45:39 +0000
Date:   Wed, 25 Aug 2021 09:45:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 07/14] vfio: simplify iommu group allocation for mediated
 devices
Message-ID: <20210825124538.GB1162709@nvidia.com>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-8-hch@lst.de>
 <20210825001916.GN543798@ziepe.ca>
 <20210825053237.GB26806@lst.de>
 <20210825122144.GV543798@ziepe.ca>
 <20210825122400.GA16194@lst.de>
 <20210825123454.GW543798@ziepe.ca>
 <20210825123742.GA17251@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825123742.GA17251@lst.de>
X-ClientProxiedBy: BL0PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:91::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR05CA0020.namprd05.prod.outlook.com (2603:10b6:208:91::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.10 via Frontend Transport; Wed, 25 Aug 2021 12:45:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIsHi-004swu-1E; Wed, 25 Aug 2021 09:45:38 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bef31e2-c7cf-4817-12eb-08d967c63de7
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50623055FA85A1B306F45285C2C69@BL1PR12MB5062.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jcCuGSRoRpH/b4ikE+CsJDMFZDEhC5qb8S5LMgd+3jG21bjzGmutG/68UFV7u30RJZlyQmI/kiJmC4VmkKrajI3E/ofgEP5++b0cxtKr+7MUhC+1ZyPkdRNhiOI5txO7JpHMnROV9B843RIdIC77hh/HRfvkUCtKCpcxffiMv05k+R6asMru6CqF962DZurhjnaK9AHYNcbliwNa/3n2QeU2i327qf6qfR4sAMGiofVDQFSGaLfldNZP4whrsJQq6qjm1WFBFaYWNU/G7c1vmOqebE1mAAD5m6xIotGy6C/mJESBaizHhF2WktA2T3NgxqJmHfr8R/uyn6JsY6IxXxxDDDLhauVKjar/S1YSLv4oK6FsbR0J9hBpXmV2k3KInxvFvFDnYzNZmvCsAqBkX3JQHZCVBKuX7dhm4u4yBPvjmM8X+IfXfoUHVDc3Xa+rrKZzoVF0Dj2nHXZcRI1YQBbTap3IzORllEVBCrsOICeslaNhEdz6OWex0AZa/bXE2RaR0XUKZmgP/xcu2LExbosBNMIntMbtgWcEnmy63UKlulzYVri3E5iEGQUhJWXUzFmo3mZgi9YDDH4rT+e52Y7uxquICZVz6cCZPLsjfN4bfLhg9QtoaYkFMzfIHUWA4qk8QAvVu/MjYdGNnVXrHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(316002)(8676002)(4326008)(2906002)(6916009)(36756003)(54906003)(2616005)(9746002)(478600001)(86362001)(8936002)(33656002)(1076003)(38100700002)(426003)(26005)(5660300002)(66556008)(66476007)(66946007)(186003)(83380400001)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FBBit03zNqvje3PkkNkZ4dz1kCdb8PEbeP8vBimtmQ60XT9sy48kjAlGc8bx?=
 =?us-ascii?Q?M9ImzKCi3cLjrjvPavScfAEu5DGph5f7jG9ZcQrMo3CceBw/3IpHWU48IM8L?=
 =?us-ascii?Q?4mcf38sDenjpaCcWz/I7XhDJ/7o24/GXYwnwXgjVUOj4cfI1ZKvJgC/I/nLy?=
 =?us-ascii?Q?WWIskX2T3JO7Md7WSHlm2Vjz/sF2hVgRlCLA07+UnD73FfP/1rLmjNCq/JN5?=
 =?us-ascii?Q?6A0nrlw27NCtka5IhbZAx73Cxn/3dHmPekp1xDFcHbJLK+I5eIymwnEYfeaB?=
 =?us-ascii?Q?KKo9KA5Vz5EaMBkKTVqDJEMMrsWjBbmbQcX7XXifmI7SZ4Bzo1lBkBeoQb3v?=
 =?us-ascii?Q?wBEByRqDZLlXPyUh6axR0XX7WKiSbP7TUKu8uUU3eVA9XmxCNcdV8W1tAEZ6?=
 =?us-ascii?Q?mGwVdWEB6zBwIeKZIc/OZusnnrBbh3bjA4ZWVFcVo/jAxlMGYiyPUSG6A+CT?=
 =?us-ascii?Q?dpxm0qwb2lBMcUDngWzKeYhob0sNs1BBAZyecdbTEDwC/Y5dxN3KLtvMBNp1?=
 =?us-ascii?Q?KmTtVE1eGuXr46XY+H8K6K7sJK9vaYgTb4eEpzb9okh/hdFhE3rAAq1oBh8u?=
 =?us-ascii?Q?iGSEG+HY9M1NNXQ+gycm7f+7jRsLOvKX+w6681bktrXk+s8gilbA4Vk6W04e?=
 =?us-ascii?Q?0nnn0jUigvqpMiJ/N4ytRkbP19ztfFAEEXUtflj3nSIaZyul53hnAhLVxmVG?=
 =?us-ascii?Q?6FHT5mE32CdMb48HFhyyGAIasArPJtoBbu2LIr+otc9zdad0n/yZKXni9lFp?=
 =?us-ascii?Q?rcTOcMSLhpuw3oGvJOLR9R4c5HiCWNhyTZvSrJhJ5viZ3OkS5kNuhxWd0pmY?=
 =?us-ascii?Q?VMeqzZyOSfwB+TC4WLVZzg9iPi1EBBHsZ2ftHG82qDHt8RNxayR/8K8U5vvU?=
 =?us-ascii?Q?7MrXFb9IWuKiAZfkyX5S8Gx7Vz6NFB2GHAKLKlhiVICz/DK8oe0feijvdym5?=
 =?us-ascii?Q?ZpQ/k7X8FV/gJMk2QomUrItFuq3JWoERo1t8ibfEt0RvvUqSuPW9wJMi4o8u?=
 =?us-ascii?Q?BeCUKUj3EtrbnmHHsAPlQGXi95ybkGevdaYUYPTkIY/6AaDxQrra0mBQuiKh?=
 =?us-ascii?Q?MulJrHzbUxaZiibwwgLm2meOneAu0Onc8U5p8ry6jPQhamQkdK8m41sQhJ+8?=
 =?us-ascii?Q?ckCI+wEEmI0+jSBPI4jmVh6COSXY1FCqkbA9LhMnDB6/+8mbv0IaSuA/W7Hq?=
 =?us-ascii?Q?JLS7k4RoPDV/1MOaxerRS1Qdgu15mFWu5F106lNlwbAsWW8IQeQG6nAGxJtV?=
 =?us-ascii?Q?RAKH1Y7jKwTgGxbbbP59aggMFeSjYMO8lg1FGVKZWNhLfXXSE1/fKm/TiS4P?=
 =?us-ascii?Q?Ip/86gWyp8Oq1KEluEnC7gS5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bef31e2-c7cf-4817-12eb-08d967c63de7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 12:45:39.6205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NwcQ1ChCn4ZUFnYmwp4A4KXelqU1sWqRdBl9iW/CYjDezr90LEM6zEahLpEXPkdX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 02:37:42PM +0200, Christoph Hellwig wrote:
> On Wed, Aug 25, 2021 at 09:34:54AM -0300, Jason Gunthorpe wrote:
> > On Wed, Aug 25, 2021 at 02:24:00PM +0200, Christoph Hellwig wrote:
> > > On Wed, Aug 25, 2021 at 09:21:44AM -0300, Jason Gunthorpe wrote:
> > > > This feature is about creating a device that is not connected to a HW
> > > > IO page table (at least by the VFIO iommu code) but the IO page table
> > > > is held in software and accessed by the VFIO driver through the pin
> > > > API.
> > > > 
> > > > virtual_iommu is somewhat overloaded with the idea of a vIOMMU created
> > > > by qemu and stuffed into a guest..
> > > > 
> > > > "domainless" might work but I also find it confusing that the iommu
> > > > code uses the word domain to refer to a HW IO page table :\
> > > > 
> > > > Maybe "sw io page table" ?
> > > 
> > > Or simply emulated?  At least looking at i915 there is very little
> > > direct connection to the actual hardware, and while I don't understand
> > > them fully the s390 driver look similar.  And the samples are completely
> > > faked up anyway.
> > 
> > Emulated IO page table works for me!
> 
> Hmm, that is a full sentence for the comment that needs to be added.
> Are you fine with just s/mediated/emulated/ for the symbol names or
> do you want something more specific?

I think so, in context of a group or iommu function it kind of makes
sense emulated would refer to the page table/dma process

The driver entry point can have the extra words
 vfio_register_emulated_dma_dev()

Seems to read well?

Jason
