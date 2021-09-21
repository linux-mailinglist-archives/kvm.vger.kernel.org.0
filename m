Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B6A4139D7
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 20:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhIUSQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 14:16:21 -0400
Received: from mail-dm6nam11on2080.outbound.protection.outlook.com ([40.107.223.80]:13217
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232465AbhIUSQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 14:16:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6Ba3xMKYTGe3j0xhJ94cS1Z0jCy0VUuUyDJ7jhU8qy9Z116GWwFQTi503mNLvPbi3QAQeKvk2wEovUGjc6at+nWruZ+RyoOqKM7F/CShHHUI4W5PgUjOoaBm7LruxSPn6K+RH/iscGIJ59AEAzYCsYqPvNYGzlP//jLtThHEg1BOVNc6IULmTTQwSnbh5/WPpZbHBFMspL34j1cbsm4NzNx8hP9oeTUZZXEL6x1jETXMdiSOjQVfGhG5EZerYQpC/HVOpPMKIdct2MjZeSwUl1K2Sq+44hbfL+EMq9EtkMD1NvvHTKF/EoPJj+qrAWdjQXFqSF+3LemIpzycZs7bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=B7eOnOE1zer9H3RTtVACkTXlYjm2KkDrCxNS6v5SHG8=;
 b=YQPl/KL+mBHqzcuQ1mgcVF+e8/hSTS9jjoqyn6TmU2BHjd5KVZGNpeaVCJnK6XajsHzQidLNwIN2pTj+8yf7o+9uA26HZjtGfoYuP7HIIAsEqWB3++yOOtb5d2e0I8kmpsoKuKOSh6eyKj5j/KMC70K692agDtIu8s+eYQ/zmsA/062tpFV/Bpo/RJEufWclCOLFiA5e4HgEd6fUrzMRQlpoGCjPBTaWoWKvs1i2Fpg5l/kaoPIGBAeZnZMHmZMN2q/8oY4zrVAmxU5Ha+iA/gGdHIXfbiW99sdcEr9JkJVpUbuMZqgkP7Jlll5counhnPlXPS5GtGde5SBiF225Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7eOnOE1zer9H3RTtVACkTXlYjm2KkDrCxNS6v5SHG8=;
 b=fiJdipoxaB9psBlzIpxet3nlIsYWZKUPb26dL9GfjT8G5ccXKXH/YPPqWdN6dKclLGCus5yyuzULNttPZ4Qaw1I+fzs9Wt7EqclnU35HE2CR8LPxp0jQQauMKmQAOzFDav7r1g0/79wlKLvQZc3hqEMB8oV1GOU5ka9+dFHAQD88nhnNQ7uIDMu3zqVP31mHATEjvEAg+AtOihhaizmWEcagW53yiTBg2Y0+gc7WuAkvI+Qx6aQsr9KfCL61nOImIJaYMNfAzx0j8PtZM0XfWpJlU+fKJoBkWz6OFRb4NdGGqC0tkYTulQBQUSA5r5TY9ZUyz9HI8FF50xv/0vEfWw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5538.namprd12.prod.outlook.com (2603:10b6:208:1c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 18:14:50 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 18:14:50 +0000
Date:   Tue, 21 Sep 2021 15:14:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 16/20] vfio/type1: Export symbols for dma [un]map code
 sharing
Message-ID: <20210921181448.GA327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-17-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-17-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:208:fc::38) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR02CA0025.namprd02.prod.outlook.com (2603:10b6:208:fc::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 18:14:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mSkI4-003Xav-70; Tue, 21 Sep 2021 15:14:48 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc05f923-e110-40a1-38d9-08d97d2bb369
X-MS-TrafficTypeDiagnostic: BL0PR12MB5538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5538329E076B4F4A4D984083C2A19@BL0PR12MB5538.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L0PjB5TQ/VjW2svakaT5jqEQ7CzBMmAePAQRKz91+UJOxw8IPeEUb6U8QEEDbiC4PcdEFgQ0lvGjNu40KtiuhRwyo7FhChcy/PBVGfZjfnWifKmuW6DlroYxsZWFROfXyTvlFsYQTmOd00jpgnHoJNwK7eTH6TkSQJ04ZNapp3+aBGNINxQBIEC6oJNXHl/td1vQSC7aMM5CAhVEwub0jgIWUoYtIOeYaqSO5dlZcUHU2DIELJU5b5ydgfFy6hU5lgIWzH4XLOlahY4nfy0lpt24SxDeTLJDyBR+yyuqa+Kl6AllNkYiofKnMvE6BNwCKGW27a1XPb1StyNndjKJVTb4DJiBtYXqx+xGWZLdYaW2PstzjCrvAEp0xoOg3z/ebBdl4O79SwNwBVs/P7SAsMpj755/U7ksYItlmB9XXGcDegHKvqYXMfXNlWxtoOV3xhFOV9HCQu8pSEFfx0adWCni4GFAsp1Ooi9KjZGGBoQ2exfR+ILI4QuwPKBVlbAgx/C+2ccLYnZdOIvPOg/GCdflUGWzJcu3NdHNemtl2C2cZy9kayKuqFFAfR8cdQT9Ai5+9LZRVFc99G3AQKMycc3Rsg3c9wFx7Z+XxdIx2Ws7ItHEutYSkBDswm7h4o4cehkP4YffaTA7n9s7XCbVP+P4M4phRBhwlVgg64XfXDX6EECjcelxi0YGn+vaRfxs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(7416002)(66946007)(107886003)(426003)(8676002)(2906002)(6916009)(33656002)(36756003)(9746002)(8936002)(4326008)(9786002)(186003)(83380400001)(38100700002)(66556008)(86362001)(508600001)(26005)(316002)(1076003)(5660300002)(66476007)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yj+smsLV5bIdOm+bFURN31lvkuto3yZ2LL4yGHeoGAU7JwYK4AqjYu5f0lEi?=
 =?us-ascii?Q?AtqJQ7M6pgCvtKMxHQFYQpldUpR0BtFe5s+GabaCitQfbVfoRn65vUs9ttW1?=
 =?us-ascii?Q?uYmzUIMvJQoKud3ltPdkZroUWUAU2N5I5drjxjQbb+0aYx9D+zKD603w7z2D?=
 =?us-ascii?Q?q/NAZ5f/UuHnFUHm7yVZq3UAlZEVx8PMIGSayk06Vd2j/u36fegHdl2EaXRg?=
 =?us-ascii?Q?u+xSriS87S7q7M+MgxM/2B9uJCjrgT/+UrCHArcJQtwjT4Hbb9ZMKCLgxSxD?=
 =?us-ascii?Q?+CRZXB47rzSiDtDPGzDQ6lNzqAL1/Q+lZWGgScMQ0gNKkXLPbg3ECTRGebXK?=
 =?us-ascii?Q?QZokx/inrbHBTqX9hnoMrLk57KhtGv6vm76yc/O7oxvPkZ18dX1wPkA0X5ms?=
 =?us-ascii?Q?+rdrktXV3LJhcEIV+qu1RGJRxua3bwUHgxW30qs+jX3KO9OHRj9yIyolVEcX?=
 =?us-ascii?Q?9wVq1MjcYchjJ6VeHvq1/ZXTFY5KQFJ9t42gsm/RuvB2V7Ai6PxqpnzcUB5T?=
 =?us-ascii?Q?/S3uPzaXXh/7xObg03kD2BS/UB3O6zNKu9UIOQbgpJN15kq2fqDrzUqhdYbU?=
 =?us-ascii?Q?tDV8ydVrR6rZbX2gjzE8E9++l+nGswAC5UiwFUejkOQTbWDAybhvGGCYly1f?=
 =?us-ascii?Q?cRl1yX2/SSVy6h/5ndIdJ+VAM5RD7edG7PnsTtbOswPhiEF4WMtV+ujkvKDi?=
 =?us-ascii?Q?fsTgVGYK73YiMqqQZ5HERrkcEe8Tn/xxeHifZkDOQlrPnSbSTZ9eUGw0gRZi?=
 =?us-ascii?Q?xSuso13enjwGlnHYt2W8924d1bU4hVtnCck0Uq/9UwvPKL7ZJOWB3VgGIj+2?=
 =?us-ascii?Q?g4D6IyycIAUF6hnmzzhO921HyNJehUolxzh7h5GGNzyvBkc4JdIIw/iFUvR2?=
 =?us-ascii?Q?m9CNPU8hA4dJ+WjBTYMu5wa94CNiNKozuP7bg9a35imL9Ai3qJhUQoo9i6g4?=
 =?us-ascii?Q?5/z2tf5jDVzW68uwx6GXle39G1ZmbAPxhop4eQ2J0KR90jAhkHLGk8uU8j4G?=
 =?us-ascii?Q?BSDYSmYYNe5OkKd1TDHJDbFgFZZKOPd1svj5cB/YJLJdrCS/hhPnCYoCnnIb?=
 =?us-ascii?Q?j4Q5RyUBLHo3rGBaCjWHABTKZ8OHnDU7xo3Wrl0Gdp7rSpHudegGkmBGgsv1?=
 =?us-ascii?Q?5o8Bo52jBv/4uPu8Wo4IjHamCnNRxk2WSmq35niK4iKDU+IIZwX69PZe5C34?=
 =?us-ascii?Q?0ubdgIZ5iV0ArtHRaJSjICFCHeXZeavBYlkfzIBxHu3qRh5gLVF9kb17WODY?=
 =?us-ascii?Q?r9fldEvofAqUn2LShh0hON2TwHiP7tITb4YjprSTGTsMNhMXIXsAi1zem/nq?=
 =?us-ascii?Q?yGp0LbccbYYUb8volaJnfHX/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc05f923-e110-40a1-38d9-08d97d2bb369
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 18:14:50.1448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aPNPXEe05aq/uj3L8EscYw5jod/flg0H97q78+qnioWQXgU1T6XI2X62Ow1iJpib
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5538
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:38:44PM +0800, Liu Yi L wrote:
> [HACK. will fix in v2]
> 
> There are two options to impelement vfio type1v2 mapping semantics in
> /dev/iommu.
> 
> One is to duplicate the related code from vfio as the starting point,
> and then merge with vfio type1 at a later time. However vfio_iommu_type1.c
> has over 3000LOC with ~80% related to dma management logic, including:

I can't really see a way forward like this. I think some scheme to
move the vfio datastructure is going to be necessary.

> - the dma map/unmap metadata management
> - page pinning, and related accounting
> - iova range reporting
> - dirty bitmap retrieving
> - dynamic vaddr update, etc.

All of this needs to be part of the iommufd anyhow..

> The alternative is to consolidate type1v2 logic in /dev/iommu immediately,
> which requires converting vfio_iommu_type1 to be a shim driver. 

Another choice is the the datastructure coulde move and the two
drivers could share its code and continue to exist more independently

Jason
