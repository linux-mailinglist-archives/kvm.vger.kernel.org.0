Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6576469A1C
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 16:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346005AbhLFPFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 10:05:38 -0500
Received: from mail-mw2nam12on2046.outbound.protection.outlook.com ([40.107.244.46]:32032
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345516AbhLFPFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 10:05:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrFVi/opBMznh7gRr7hZHA3eg4IEXrcTeUnjuXuh/eEtsOB0Bw510xizEUKIsu7DztIzOHZQ+cB0uXjrYFSXJW0NYuIEhHymAtkASRE6geBDOE11wk3+Uhaaj/oLegQ2REId4S/DyoeGsZMHgv22yyjGC3Zvhbsp8BkkvpyMH1wfAwYsDTpsWkUdLlqHyFeF3Jve/e7RyBZWfNmOocDFk3MrsvtLsuz0p8Zc3LBHx0Sxt5qPUOc7FszH7IU2JiPeWhdWurzxxq2Db9lwiNZs8h4Qfg7kZwMauxivgUgu/XMkoysBwu1fn20YcsGiaGjWeprxaEV2hu4d0vZ1XgZ3FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8+gpxAAe4skIGULiL5Wl0v2Q7CmELt/yRAssx17EQ4=;
 b=nL92d++S6q8MX+joVqayiNm3fbB9PDV2yo7nN6qaLmhReryHVeQ4I2N1WJ3dcWVJ1shFMbDkiEFbkriDA3gvlYcobJaaxIHNd5YlA9AHaxhNC/FQzUBZe4lzjEOxMU+hjslOecTtRwlFl2d9NyrdHvodRyqkE6EgjKV4+XgSHiZNOaaQiZwcGlwEBMTr2lzPibXiqXFGHXuSnHWjJNgi95I5h/QBzcjjdvKVerKWV7/+K1/uX41b1CU0eJlxIrQwu3IPzy57CnmugrRd6LabUf7hyqTYGkZt3fjtOwrNCHRKF/ZvGE1ypM8Q41Lft4pSCE/wi7tYlL0glOwLetOhQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8+gpxAAe4skIGULiL5Wl0v2Q7CmELt/yRAssx17EQ4=;
 b=ZACmabtYzTmP9uDlDrfELDH7Thp/FQGRs4OKv1w+M46nXt4UljucaJEteWqFOPlizP3tG4tL9M/h1iwpvHHRF/j2//Qfrv/Hl2S3QnH+mLkGvUWJxJ2igANC2PsKB8H3DDUBTRb8/isJWBLZH6mXNtG0lDSwMLjSiJvW9M5+jY8f2i+saSmYTS+tPKzsXiEWB73+iRQ1o3YOyl8ST6sqI8Lv1en8Hx1TL635mEiioSGY3X+N23tY6I5voUv5jTCG2+ClQIXZgcTMppa0PeaD0FTFmqIipKYqKDD38hon/r2v8pT97nl6faTmGh/7ZJPRdmlFuW14pE2Aoky9IaZeig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5363.namprd12.prod.outlook.com (2603:10b6:208:317::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Mon, 6 Dec
 2021 15:01:46 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 15:01:45 +0000
Date:   Mon, 6 Dec 2021 11:01:44 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/18] iommu: Add device dma ownership set/release
 interfaces
Message-ID: <20211206150144.GC4670@nvidia.com>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-2-baolu.lu@linux.intel.com>
 <Ya4Ru/GtILJYzI6j@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya4Ru/GtILJYzI6j@8bytes.org>
X-ClientProxiedBy: BL0PR1501CA0010.namprd15.prod.outlook.com
 (2603:10b6:207:17::23) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR1501CA0010.namprd15.prod.outlook.com (2603:10b6:207:17::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 15:01:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1muFUu-008x0E-IR; Mon, 06 Dec 2021 11:01:44 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 538ccb59-5399-4de0-3143-08d9b8c9521d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5363:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB53639C4841077590DEC27ECFC26D9@BL1PR12MB5363.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5jXCUZRrYRTMjQkZZKjmyAR6ItW5M9XlY8Z41TJ+ExceP8c19rxMjLApoAXGDFehT136P4BjGPSKLq4PPJxPAZzwOLQ8XLIN8LjkiJH5yXQGzbq9ijnXi9JW7MTsSbDB0wmXhD/rZE6KqLr/bTpLnQ2Vl1BQ3UJj1J/QLJYeWfrm61GqKSwxzSnMBlwaUbuqVOJO6rhQ/+NHkbiwUXOBhXyl1ejUDyOs82Toy0BS8JDPohwCWBMbwBTQeCCMHhGwBnHU6r6IjIu9clX7OWta9LOHRnDNa+I07LyEtyR8HP7dG3+xomHmxl+se1tJlX078tc4ffiNEAJy+XB9giO7oVLuS/xcQyRVR3LJQelFSQ87ncW3c7Hvfon5sWKlPramiy39mJRgmorYx6x0bH01bvXITydweXyrMvLiwh1DEJGzRz5OvfIFVd99AoKTNTSed6+dNqNyiNZuUdMio0PMfeWq0nUTziCfMZT+bK9ppClTayKqrAiEbOgAx5Ws/jUjoWf3+Sbaoi9IfmSnT2Qpu16JN0y3uNCYdCjcnS3bEZ8gHAuzYkCd6K3yNx02Mw5VXWXDHCoqpBuiLn7LvP0+Bm7qSJ3+QOkiBKR2UrINT6XOi4C1XUsmZriOoARvMl+4nIaYDWTdSrUOTeeUz4/DJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(7416002)(66946007)(83380400001)(38100700002)(36756003)(66476007)(4326008)(508600001)(5660300002)(26005)(316002)(66556008)(33656002)(9746002)(8936002)(426003)(2906002)(6916009)(8676002)(54906003)(86362001)(9786002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c3HXNekfLMv7o1OuI+oIuHO8ZgQSxRraa+Bjh0B7G8PJ/meqzDZTRHdgVj5i?=
 =?us-ascii?Q?cxuqFs0PmFE3nVaNYA5lmnXRJNDs2HSeMbuEOJQkPEozfO3HwdysGmr6knrg?=
 =?us-ascii?Q?XAcKkkDqAXuRu9hX8eMAAwK+2N8akeztO/3hzclqu68pKNTiKHYmybWwfhoy?=
 =?us-ascii?Q?wPjEANEj4gjG5aS1jkilwSD1+ccE6AskceUdqAKEzX14wuRIcfGuoPspmavV?=
 =?us-ascii?Q?r/QbQO/tPePCPkGvsmNy9IurfsIeywRcapdm4FDIRjdHzWXbQtjvUfSRJmwH?=
 =?us-ascii?Q?uSR/PnKpV7cR8/ZwvYqe7wH9tbikpfVH5wCb90pShnh+BRgK+iYno0K+EUtG?=
 =?us-ascii?Q?671aE3ZVWBI7Dl2yMrTOyD4Rf0ncP1KIe+KiCbboZjPoewLc03mY4ojMgIrc?=
 =?us-ascii?Q?gheNIaNVZp4pIbfxPKiwUKwraQEwC5YI7gCis68vYEvGPOQFxGO439MXa6Bx?=
 =?us-ascii?Q?ooMAcn+Rbf4eWVy7K6NibhqVLEjcgCqDVL406w4BgdG9tJkdqVciNxedUxOx?=
 =?us-ascii?Q?p11UlWU3IEcZVq/1ji63gLF8sXQWDCqYo9koVogDKYJZZyHGJYyeJ69XAsCy?=
 =?us-ascii?Q?+b5Ph3S3msvJGu66Ji8j/xl9uz/NdHGrgod9kf8XDl6vV6EJj5bFmPBqgUNl?=
 =?us-ascii?Q?agrQsYlu52UKl81LhYI1+IJm4JK0SQxqZlCH5bfEvA0Bt760Ew3CKVOMt/Ey?=
 =?us-ascii?Q?PRZfspxYBnZliIpGmMIB+qOSnTyk8M5sZzRage4xOfBmbMUb9osXaq48Cd8A?=
 =?us-ascii?Q?2kuuCjiH/pkvapYaY9dFfi0CeT5l5azneOGq2z+vpVTrwLFBgPqtXtngrfLb?=
 =?us-ascii?Q?rJuvSvdoffvrzxnTdAE5mstBZwQxjlagHctT5dflgS/E/Io/AUUF/Mb8hssl?=
 =?us-ascii?Q?d/vokkW821P4Cwtm2HRUa/KqLhIHMUerZIvnT74lYxwyGbUF788j+NDWbGuq?=
 =?us-ascii?Q?i8TBF5mV2FlAjYLM5rWQ/MQLn63RTdYnz7GE2y43YvIQmCFQkVKv0yaaNUgs?=
 =?us-ascii?Q?OYPBtZxNrWGFZ+Y5CaovI7wRqWTVF0c7/352ZlS1bWPqlzjk2rVl6LwiCG7m?=
 =?us-ascii?Q?9AzcZOJjZKRNmEKVx6XkcEgL1W6jSjQ6RHJM2MU3CxsozV1L8DjAxmEUHkWs?=
 =?us-ascii?Q?N7ZI3Z5XorMOPj4+UM3XiNlex5RtX+G/CUPnTMx49fQ4M18W9fEUlG4uGKh/?=
 =?us-ascii?Q?/HPQjrwlWjVa8n7DZHffw8hWeE8281Dsqq+XzjyAJrRTvaxbVYEiTOi17CLK?=
 =?us-ascii?Q?2FdxCn6e6p29uwPP+vAMSLqODW9evBvp5f1qhbPXFrfZSJZYTIrJUtb/+X28?=
 =?us-ascii?Q?l55fuxN49TSfrAp8tQLRcjqXnwWcvrbyRFDceokPk031+VWhmSkXlz0uhMC3?=
 =?us-ascii?Q?B/ltWCbJGZgGyJAGaXPCl67r2GJE5m7ktCltgF/aluKsw7viEFq2QGeJGEXh?=
 =?us-ascii?Q?7gruxyaGTnN+w3h410S8IEtfMJUXiy6J6FwH6LMhdYzDAyJK7FkpiEOQZuvg?=
 =?us-ascii?Q?D8TYnHPxfbbvdUa+wk1vF1Jr0Taa3Y9efqKAmfoG2IUK25sDHxnt5wFlyR4c?=
 =?us-ascii?Q?x3ISsR+3N910j7ygYRo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 538ccb59-5399-4de0-3143-08d9b8c9521d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 15:01:45.8041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cDDjj9nugJ8ufPu1198pNhzzwjFCJGF3FyFv79pu7YcJfmJcatc5r3F47MU6cN5b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5363
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 02:35:55PM +0100, Joerg Roedel wrote:
> On Mon, Dec 06, 2021 at 09:58:46AM +0800, Lu Baolu wrote:
> > >From the perspective of who is initiating the device to do DMA, device
> > DMA could be divided into the following types:
> > 
> >         DMA_OWNER_DMA_API: Device DMAs are initiated by a kernel driver
> > 			through the kernel DMA API.
> >         DMA_OWNER_PRIVATE_DOMAIN: Device DMAs are initiated by a kernel
> > 			driver with its own PRIVATE domain.
> > 	DMA_OWNER_PRIVATE_DOMAIN_USER: Device DMAs are initiated by
> > 			userspace.
> 
> I have looked at the other iommu patches in this series, but I still
> don't quite get what the difference in the code flow is between
> DMA_OWNER_PRIVATE_DOMAIN and DMA_OWNER_PRIVATE_DOMAIN_USER. What are the
> differences in the iommu core behavior based on this setting?

USER causes the IOMMU code to spend extra work to never assign the
default domain. Lu, it would be good to update the comment with this
detail

Once in USER mode the domain is always a /dev/null domain or a domain
controlled by userspace. Never a domain pointing at kernel memory.

> >         int iommu_device_set_dma_owner(struct device *dev,
> >                 enum iommu_dma_owner type, void *owner_cookie);
> >         void iommu_device_release_dma_owner(struct device *dev,
> >                 enum iommu_dma_owner type);
> 
> It the owner is a group-wide setting, it should be called with the group
> instead of the device. I have seen the group-specific funcitons are
> added later, but that leaves the question why the device-specific ones
> are needed at all.

We should not be exposing group interfaces to drivers. Drivers are
device centric, they have struct devices, they should not be touching
the group. Figuring out how to relate a device to a group is the job
of the IOMMU code.

This series deletes the only use of the group interface from normal
drivers (tegra)

The device interfaces are the primary interface, the group interface
was added only to support VFIO and only because VFIO has made the
group part of it's uAPI.

> >  struct group_device {
> > @@ -621,6 +624,7 @@ struct iommu_group *iommu_group_alloc(void)
> >  	INIT_LIST_HEAD(&group->devices);
> >  	INIT_LIST_HEAD(&group->entry);
> >  	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
> > +	group->dma_owner = DMA_OWNER_NONE;
> 
> 
> DMA_OWNER_NONE is also questionable. All devices are always in one
> domain, and the default domain is always the one used for DMA-API, so
> why isn't the initial value DMA_OWNER_DMA_API?

'NONE' means the group is in the default domain but no driver is bound
and thus DMA isn't being used. Seeing NONE is the only condition when
it is OK to change the domain.

This could be reworked to instead rely on the refcount == 0 as the
signal to know it is OK to change the domain and then we never have
NONE at all. Lu?

Jason
