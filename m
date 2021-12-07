Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AC046BC97
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 14:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbhLGNeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 08:34:01 -0500
Received: from mail-bn7nam10on2076.outbound.protection.outlook.com ([40.107.92.76]:20993
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232505AbhLGNeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 08:34:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDhRqe9OAqqDi1vUmdsY5MaR9ZyIKoPgSq1AAXr2rOWRrOhkBWFzp1T3BlAJMUUGq/Yk+jWYrpY7URqwP2GhXz7RjI93DSaMUuu9Seg/bN+te8TNgD6DxtRTfEntPp7Zqxl4zBaRWUqkXoNoTSlF0xozWwH4Yah9tgzuiubPqxx4z9cg+ZLbTHf2HXqkDhK80xqObUrAOZ4z3nHPNCm4NdpdyWzByqB5O4dQBMXqU5zn9dA5YkQ8noSyqq30rN+WjqAjaOekr9qGfjmwvDKCr01ljdmu6El/GPape0LxVaGwCF1ufEYimDLJx+gDzs2zgp+eHuJK0kuYi9PAFFT4ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gm+IrkEw0+t8KnKQEusg5zIr/+5xQSJPo0xcyyCTv2g=;
 b=MfGp79QeORRiyP8UKXjm7HVc6VvsbFepNMYS24kvsE8WVnGHIEI7I526FBJjbVftuHCIpEH8eclV2N15DFh1hFM5o0CGpOMdbvaFqgvBy1reeD2y7z1jrRR9m3RAQAG78j56o2IN/GRhF4HM70Q7Tkr76xjlCW2JpI5v/ET4MMOEJHfZChqWn0pjAsOnB68Nk6bf2kClqm43qtGTvQhA099u9qZT2xH7t6zLtg/As8Tk4ZeGLZTyeJofVXXc4PJAw6AYsr3atFrFBWrhsqU3Lbqq7tJ980xK2DqHJFvkiKQJssHs7EoJ+qWAavsKu9G99vSz2gWFd0VqEC7aIUMBVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gm+IrkEw0+t8KnKQEusg5zIr/+5xQSJPo0xcyyCTv2g=;
 b=Jx5VzOiD1arjDZih2+XWOtm9zkuA4pI88uEPAUMmApqJ2LB/6FWd6KuocBKXfhzk3HM6FHmqWWonZlC6EKZaSVOhQo9A+Pc+kwa33jgzGrnhmp2mm8tUh9QzA+ZHZb3eSX30oq6ZwWwLr2gCIXr7CIisVVUrivZSbVDvb4xnwNdfnWSlAscDHw2DZRXdrcxq0EchkhokJCypiMgUou7o/Dmpy/231tEGqSVpIJhl3+7lIk+SfVWXTOkUKu3vgjT8b0Hss6CYEI/cQaipBgLZ2xfndXVe7Ba0Aqenc4CsUprqVq3mYfszHu+FuXkA69FXLgpyYUAWe4lKqh6YJJD8Jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5223.namprd12.prod.outlook.com (2603:10b6:208:315::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Tue, 7 Dec
 2021 13:30:29 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 13:30:29 +0000
Date:   Tue, 7 Dec 2021 09:30:28 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
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
Subject: Re: [PATCH v3 04/18] driver core: platform: Add driver dma ownership
 management
Message-ID: <20211207133028.GB6385@nvidia.com>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-5-baolu.lu@linux.intel.com>
 <Ya4f662Af+8kE2F/@infradead.org>
 <20211206150647.GE4670@nvidia.com>
 <56a63776-48ca-0d6e-c25c-016dc016e0d5@linux.intel.com>
 <20211207131627.GA6385@nvidia.com>
 <Ya9gsMmQnVdQ0hyj@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya9gsMmQnVdQ0hyj@infradead.org>
X-ClientProxiedBy: BL1PR13CA0355.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0355.namprd13.prod.outlook.com (2603:10b6:208:2c6::30) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 13:30:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1muaY8-0002Ze-3p; Tue, 07 Dec 2021 09:30:28 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 282a0511-14bf-4b4e-3c24-08d9b985bc49
X-MS-TrafficTypeDiagnostic: BL1PR12MB5223:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB522340679FE18A956B04B939C26E9@BL1PR12MB5223.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3J6WRNz6Py4N9JH45NEwZCEo9UWjVh3jAfVJpBij9HqDJn8Wj0xCJtShOkNHFlBLuetokj+K0cT4mQ4y3q6iF66UW91L7ELC2tKfv0sipvhI1Rrf9rEUIbzwyrL9X6xoArtwzRPt9troAC8hGLHSlIgL/KyqGBaQAov9K+4XKu7Sd6o4qqx28+6AmnWj5tJvBEZeG+cLBxoM1Nu99/2SzK5hDpoVuGvgdvqotbxqbr2ntveSLFyDZgBrdP3mL16h/pX9JTK1FoMFTr/6Nu3HH096PSGPPGv4IlcX/FfYqHbLJ0sAjuPAnviT3F9Z/ddbslgInyNfCKXANOw1JVKYpJiSHO4rvsBJGQ3neO4iLcgsTEJ7gfL92q4xGPqlBnhCmLpPgXa+SzvVpY9Jt5O3ApJaPoEWZ3b+uUk/b14+zgVr1n90N6SqC7WF9xFr8K1x8hzbqwBuM1ssvK5v6aN3dB0YUkmBJlfpkvLwyllc/ltHNZhV1wC8ard4XBG/GZS/naYTW0KcSkYltZj5jgWUt6XSaN6WYPGG+YAtYvHAfD4PK8B8c/vH5elJWEjlzfrtWZt/z/wK329IgZb8XswS3pNig8nPcL8M6KJl0oaw8w7k5HlaVwizo0pQrMqzq9GuQDY2OkzTimWWg9jZnLX28A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(9746002)(8936002)(4744005)(9786002)(83380400001)(54906003)(36756003)(8676002)(426003)(508600001)(7416002)(1076003)(2616005)(33656002)(26005)(6916009)(2906002)(66946007)(38100700002)(186003)(4326008)(5660300002)(66556008)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4JcYfwAPfcl4HhBPO/G8ufZEEVQubApl5WspBcXSBUKKZ5/AWDklBrACVSG+?=
 =?us-ascii?Q?M+azLDJVb3UaWWn1fRhrbTlokEZUN/XENJLvruGfKSWvjVtKMWGAssQW1gDv?=
 =?us-ascii?Q?cM+ZYsJ5j9tT38ZLTXUlvfnCG6Whm0oXg1ubMA8KKumMvvh9isGtEo4mY91L?=
 =?us-ascii?Q?dQH6VkQAS9YCnRzqFb38fDpiGGNHAns5ReEPstQ37NMh3LBnjEoPNd7VE+OF?=
 =?us-ascii?Q?Je+GvRRvEccSvhk2hjUqHjDyoCweRCQVGGSt5xr8q1ndGmdTeZwzaE3eBDUI?=
 =?us-ascii?Q?+6qP40OLzQ7Ei6DpsVUScmnJJygF2LxeagsBxoIHK9gd2/qvOQVv89p2KfA1?=
 =?us-ascii?Q?+UwrGVh4z/I603Pe2bLpiXP/uNluCJ47+0MjaFG89NeKsa/+MkvCncg1azJz?=
 =?us-ascii?Q?9aozEiXzyGJ2QUETNaaDsdokb1AXc4Reyipbnz6kWry5KXqJxPpQWiaulSgL?=
 =?us-ascii?Q?SzefnxlumO6ni3+xqpMT0GD7GI/cpbGbULfFJFbvEoahHoDVeTUAKs+RFEYd?=
 =?us-ascii?Q?bBGI8qzpnpFDwclyIHYDTmrYfIxwt1ac0x1IsJJ8utket64Qv7muPDQs9xMd?=
 =?us-ascii?Q?8z495Vpy60xi34+kjeeG+5co2ip2AvUG0T5Me++xi/rYmuR5AR5GNxA7XfWi?=
 =?us-ascii?Q?BFDNwJ/xYxG4he042HU7fIyMyGf9L4tcnIyBWCFprphmIATTSzANoD3Bac5K?=
 =?us-ascii?Q?JfTfaf3vUikb+z5kc9GcIfKDC47DmENAOsZ81/Mtu2bCVT8GADRJJqIc5kJw?=
 =?us-ascii?Q?aw6ED++Hhp4rBxJtXlsgQl2o/YeGric8F1zkTVu9y+ytXFFN/y0IARzanbwr?=
 =?us-ascii?Q?infX/yHYHUu+WVRLHChur0VBcOldTtG1Y2QY95TBQ1gdBxos7UrOrraZTv02?=
 =?us-ascii?Q?lYegaam6tpHZa0dsHPi3rlbcPHCwE8VJt0XV1XAQ5SSjMgmxW5LsztkOBZ+Y?=
 =?us-ascii?Q?DwshEAMZCHnXe7YaUCH8F2LsQ4jiItydWktxiJqqM+HHCGWL+sFeLHbuwrfJ?=
 =?us-ascii?Q?sLe2JMlhWcKLXxm5XB05HQiTILuwbxp4WrSS3pquH5vXiPhxUOnN7z0WXbEW?=
 =?us-ascii?Q?wRy2YP/NAGkVEIP2nil7fT8efRMkJbeWSJNgit568l4SXVWc6OxtHL7IkJed?=
 =?us-ascii?Q?028EMUdULpjpDbUk+DQfNn7W92vrXrskGqOqOg6DhZkOWF3C+AjVi4eEzEgl?=
 =?us-ascii?Q?+ERMC2QGRA494QnOiJrd5A2iyaEMbrHZMCTrTS5I8TOk7udFFjSM2+RQaPP4?=
 =?us-ascii?Q?UJwe2x9iqlZSWXJtWFsIXQHylsH/lvfLOZfedqXRYFxvwjUIGTDLcOLpIhwq?=
 =?us-ascii?Q?emEOsPwVrnOgNPjoTgQYsY3Jp/06kbdRL4aKj3fLNfm8yqMPk599DEuQ4KkR?=
 =?us-ascii?Q?e1/3o8MMOcSQDQAXl1lgkR4A3tPB3cQos2gN3ypKUZb5+A7nFmHS8l8lAUAA?=
 =?us-ascii?Q?mvJH5y6IF8nwII7vWblWwdxfFsqVetAPB3z+9z4k+uakMDjc5Sq+PH35G9hY?=
 =?us-ascii?Q?yx6+/ouYYh+4VImD0wrlIrJTGsjrMcEGlUikidIoTXmhQAu9Fzjlhehx63kZ?=
 =?us-ascii?Q?T+XpqWN82O/GC+J6Enc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 282a0511-14bf-4b4e-3c24-08d9b985bc49
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 13:30:29.2696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oead6dE0r6hAqyEnvQaB42yhGjaXRdk8rSW9RIPC3jtLzO3lzIz8lIXZiwCrhVkE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5223
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07, 2021 at 05:25:04AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 07, 2021 at 09:16:27AM -0400, Jason Gunthorpe wrote:
> > Yes, the suggestion was to put everything that 'if' inside a function
> > and then of course a matching undo function.
> 
> Can't we simplify things even more?  Do away with the DMA API owner
> entirely, and instead in iommu_group_set_dma_owner iterate over all
> devices in a group and check that they all have the no_dma_api flag
> set (plus a similar check on group join).  With that most of the
> boilerplate code goes away entirely in favor of a little more work at
> iommu_group_set_dma_owner time.

Robin suggested something like this already.

The locking doesn't work out, we can't nest device_lock()'s safely
without ABBA deadlocks, and can't touch the dev->driver without the
device_lock.

Jason
