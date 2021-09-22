Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C0C414923
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235889AbhIVMmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:42:08 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:33376
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235227AbhIVMmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:42:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oc1X90R9oJAeE6Oy0+e1y4pcf/03F0/TkJE18EmZ7tIrqwSeEDOC6yKsXDBUuPSoh+NJ4uVyAKQ1wx/ftTmFvdJr+kIdv7dhbruNLh0akRlXsTKcfFgXm7itV9/KHJGMe5/f9pcwuqBJiGuGmjKHWJkxTxXMhFMsSqwK9fsUPmlmH7Or9GbFrsklB3ARkFeOE59IgvlN4LoaQMnuMqo5Q0rV5nHbVu2UUON7X60V+jvVyCQUMqKoJrw0AQtFUlQNKG4Z0e122+ZJ7wF1R755eNelIyP3yT8gbhK0Ww9vXFPmmLhKhu8KgqI1NNvo71Krd4R0J4lov8Jz+UXXlph9Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=15Afu4pfnmjNPL+BvIty9qXfcL6eVAO0WoyiNEI/vmE=;
 b=WpCpgFEzjeSiCdPf4QiZWED0k6Km+HuSzZAJnARCe+/vQgaoS6TibgKOS4mk9wigjGjv6Ar79OSPzC+Lz6AG/qGfeOlZRJDVgZ6j8tt+uiVpo3hVSTm3SMUi3eBohkCcxUrKko0DhLuBcmMlxjVVOL+VIA4UZxLq5fRzulF/huaKDxJ/cIqlwet2y+bGe7itBclp5dZbKS2t9ezhiotqKQ7gXVYaO932/8aOi80z5lGbKGxGBeDccYuH+bhlFSxz0UVgHDQ76N2YX6Kkf9IF1ptJSJQbnpoRhpZnNCqJSLQqXF6qWZJeBHapf7oqdUTv6aAOmOHtvd6b3Qw1Tcc8AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15Afu4pfnmjNPL+BvIty9qXfcL6eVAO0WoyiNEI/vmE=;
 b=tZZF+hRY6p6ZsMHO4+OpJZHboVIyWAXuXdQ8YpiK1yBiD/dyPN6eHFqvk0r1+9zEns1WVHImH5pbalW5xpTcO00mfu23fq0SoPcB1TNelC/aohUFozahyUO4146dg4fGu0Kctz0kmjKBVFeloeJuZN5wxwDfulLdeuezfbJTfh8XAo9+lkXMW3dg+YTUvqWq+pDol+lKVfU5ltxlg8TCa0PzBy40gInjl5pKVZdDwxXV/btA+TZSAGDBUhOrrcUV42RXr3IQNeNpL1/pqCI8jCW9hdymP1Ecrtx7JRUAVWQtfoYy1Etw3ucrLicQCIK6LWKAMAadU6WcS3mO4d2vqg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5094.namprd12.prod.outlook.com (2603:10b6:208:312::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 12:40:36 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 12:40:36 +0000
Date:   Wed, 22 Sep 2021 09:40:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
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
Subject: Re: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Message-ID: <20210922124034.GJ327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-2-yi.l.liu@intel.com>
 <20210921154138.GM327412@nvidia.com>
 <BN9PR11MB543344B31D1AC7C8BC054E268CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB543344B31D1AC7C8BC054E268CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:208:c0::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR05CA0008.namprd05.prod.outlook.com (2603:10b6:208:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Wed, 22 Sep 2021 12:40:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mT1YA-003wxW-N8; Wed, 22 Sep 2021 09:40:34 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b5f2dae-1a51-4050-0dd4-08d97dc62cf1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5094C6BE5329CE79659B9BB8C2A29@BL1PR12MB5094.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MoO1Ru3omjSROsIcmANMlCMo/1NitmFjKN+cha8ZxVYohiviIRVBBNy/qaYF74Hmdw0tv24zCf0ByJjfbcy3zl6mdQ3AdhZurbGG9EmolUgzfXhvYoHQA+cvXGPuT+USMCD1ANzSAunH/O3ladTdOidIOpA59jt2VAqvkxRaEPHSQgxn0TqJGrvqrjOextAe1y+222Upl25nMTH4QYtilbhqVXOaPLm38HggzpnPTrdBqhvWAVrImyeTmn6XhMd57gO823AlkGr/TQ2OQWWV3+AwYprx/WZjp4D8YiLi+V7NydKEwI4sH6fS1XUlMqgoUD2AQRdirqrd4mMHGG37zmH6xf8g+fAUf2gkDkUi727MlnfY9PDlOdfqiN1RSWpNr/pX2i0ZVANHX+gvd6OBEUpz+KaW97r+6uWCDRmacDOOgCEZoZwin2iZWvW2UPgiBfWWA8vh4OLyi7byKJPkjBUjkrr+Ma6lByKlEgImoZxArcUJEzxqPmMk/iQCrqMKlVzHLI30uqLUSfbOxFXghM+uoGXukMma8NK3VGNWmLotNO8s/4YiAAmnYnIKobNXJli10lI56ypPsNrX2XkYxleL/N3deOwHS5jVhgp092LX0iHe0lA4gwM05bltGfPUryCJ0xWSKmR1aQ8vvTdlqyzvMdDFjMfkmP9snnuDO+vgMyvYms4utSt5Pe8z/cbR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(186003)(8936002)(33656002)(426003)(8676002)(86362001)(38100700002)(107886003)(2906002)(36756003)(83380400001)(5660300002)(6916009)(66556008)(66946007)(54906003)(1076003)(9786002)(4326008)(316002)(66476007)(2616005)(508600001)(7416002)(26005)(9746002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ajea1bpqQK5FzXQ5sRIbh1UwxTxp+rTw9Wb5Lj/TmR88J7KXID6X0LReQcvs?=
 =?us-ascii?Q?TXOaSf5DxhgzQtVb+UBUuAqVI8tn+FpCRSOq1B+36cFSTHLcu+IH00AjKoL+?=
 =?us-ascii?Q?7Ltg6n8n/GUwIJVFmzdEvtLNyOMK159Cpb8bR5InRxC34NHHuYmSlVZoQdC2?=
 =?us-ascii?Q?hMndtXWRchZD18GznXUvXFb6ECQT0RDrYi9HToJIFZo+MmOOVgS54QBhAhlR?=
 =?us-ascii?Q?I9hBD+YuffNZzIDgaD0Y043Q4jasKClCO01C+JFb1zjKjSTBLMNzXR9PdQnP?=
 =?us-ascii?Q?3Zil0m3AE5LU1mhYn7znBL1lquVeZ6mSguUbbBshlY/7Z4e/aBREWtHNQeiC?=
 =?us-ascii?Q?xV0OuHb5ya9IgKuovMhRT36X2bQbaCPpNOojHQjo7QHQWhPjNU6YN0s1E4jc?=
 =?us-ascii?Q?YkZhEZssn5uu5D2akf9j/y1R4Sq6UviGcJjdIVyKrzpV9Zwp3W9qc8Znxvfi?=
 =?us-ascii?Q?lKAWGv/vtBlfBE5FrkKSDHx2z31J6lPi/4mTI2AGbWqwuCQeHDxYganzEiRB?=
 =?us-ascii?Q?EYh0RlsHyIzpoYaaZ14j0sr8ucZRmD/tcs3wb+Nh3J3XUqvpRw6+KAWrZPrO?=
 =?us-ascii?Q?Z5H0mYd1tM8bE7yDLAWf3R7pZIS5Vt3oK53ltZvJWxj58d6Fmvx8Oa5yxrwz?=
 =?us-ascii?Q?sP62MmX/V4rO13or0+CG7ImYWUWmu6NhgJAu0t2RCb2qsIIWcMpsW3ObiURl?=
 =?us-ascii?Q?gWIeTf0grWXNwiMCs7M3qrYNkPPLhTwqUG9Zl8Mn5Rnc9QmTKrJYz+MYMyCL?=
 =?us-ascii?Q?vbo3+UdcfwKySizzzL/b4Ua26b7XyBs11c7w6MixnGo4WPboNltD/+0rJ22l?=
 =?us-ascii?Q?mJCMpZ3fJ863B0Ket/t/cJ28rYA6jDHLaTny9PmF2bHYosryFfOh9/LtTJND?=
 =?us-ascii?Q?x737qvpAM/BUXmADgtHW6SB96ea8ZhoUWe661w3DPfm33PAFQJd28kIPjESO?=
 =?us-ascii?Q?CwaRTXY1HJjSZPIcUiiz7NjxvWyTFA6wnguWLxkA6ucvGkVn1VTRP+qF0VQA?=
 =?us-ascii?Q?nOoH7qWixvYfVS+erURnThADNL1GLq9fPvQiKJ+80HrVU3zhaIiEWAKZNd7j?=
 =?us-ascii?Q?SrA9zudEKpyy+i2VhsubKliOeCYTEWzoG3gN5WsY/ZggPs2u40tpq486SqHU?=
 =?us-ascii?Q?Vvd5zamyYLPbXpQ2Z/77iT1QxtZu32X2LO/aG2ZMr+q9lWDiAAhuRMcXWkOC?=
 =?us-ascii?Q?Dv/j3NdQNejzByOrHSjMczvTE97WcM6wGOxDoCNHLGu8FW9XdppHzFLZuYMb?=
 =?us-ascii?Q?sC6DRr4P2M4npP5bGzyJ44nBFP9P9YbI+D4ZQBvkwT7JI2QunB97jpVlIGmT?=
 =?us-ascii?Q?KgTgeAnFRuOwRoqCFxJnGvnM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b5f2dae-1a51-4050-0dd4-08d97dc62cf1
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 12:40:36.3883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8sIViDw3kufhnrluBok88hS+5QTGOT5OghRKffyrEkwk9grxrgRbi5eCH5ETAQ9I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 01:51:03AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, September 21, 2021 11:42 PM
> > 
> >  - Delete the iommufd_ctx->lock. Use RCU to protect load, erase/alloc does
> >    not need locking (order it properly too, it is in the wrong order), and
> >    don't check for duplicate devices or dev_cookie duplication, that
> >    is user error and is harmless to the kernel.
> > 
> 
> I'm confused here. yes it's user error, but we check so many user errors
> and then return -EINVAL, -EBUSY, etc. Why is this one special?

Because it is expensive to calculate and forces a complicated locking
scheme into the kernel. Without this check you don't need the locking
that spans so much code, and simple RCU becomes acceptable.

Jason
