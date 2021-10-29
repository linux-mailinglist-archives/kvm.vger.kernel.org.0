Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEDC43FC93
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 14:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhJ2Mra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 08:47:30 -0400
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:36555
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231792AbhJ2MrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 08:47:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcm65KIwwV4AU+9hCsFW5aUcoNj4AE5v3pKQ+qNNThCmYY2Put0t93zDcjZSuFG0rN1D235OsqwdCnGpTwXyX2qfd5cZ58deMH1hsZquvRGiGpo2BfVnu3kesH1ccv59Bq0nVVD1i/VpS8+4Jm6psX70Ek+0vCxy1A6c6i/nE5Dp0IY1ZSBliimE34/pr5TL0BTVUJqa7hSJSTFK9jTd/6gsBfiW3rlfKZBDJVYKYl/MDi8P1mXXjo/sj9O/HFzMpT3wN8W8ifGhMML66QI4h70J5e/jyiQdJnRrqZJBJMTkd9TYpQeefYSn8JVuL430hwDnfGVJbW0u2JWe0JrVig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qnk0xEp4YArqZwFVKdS34i4OLTlfweZv3UstK1nUZTg=;
 b=GUWNSC4mSztJMl36MuaVI/w+6LKokVgZ+pSeh+qtjywd4SnT6tbvBbQp7Qp14p/HKF2NVla6k2khwNlwRKBwE3U7AwZURLUn8UIBRQHLJm7ktOLzJex3zQ9NWjaZyjPexLcDC3XIUji5tSQWjkwooqD2yWl4MKcuM6oyhmIhQJHQ0vHMyO5+OkwnZJiB1XeA+b5z9ZHAUuZzoLPDYEDo0De+ogSRkvgXDwK9gibUF3PVegBRqKvDez559/JfhMsGP/WUFLkp6pDKv078PEgApJjHQycDkG1Rl3C6ouK0Q1SI1gbMDnSQV7NjmzXEW+EUTxIrv5hfe5u1l8btF3BV5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qnk0xEp4YArqZwFVKdS34i4OLTlfweZv3UstK1nUZTg=;
 b=imVIvT/Xlykj6rf23+opzVIDQhpM+RbDAMtqpkEEXJD24KFcUEHqGJ+r0+YJ0aCfHACXv90lFciLee6IJcuBB3SWJpCFa9yWlWbeejPALbn8v5qjAJT3b9ONb2IFey1pJLsK2oOxcCWch+Moy04Q4aQiS85Uy8OBDJa1wQ8q9f5QtBH7H6ZayxdEKa3smDekM8r9xuTZ7KtJWAFnluXDvMU3cQWeidIy50pyR5LdBFjqEUmMKXd+YXjmePafi7T7nLqUPOv6mR9TKrc5lOebrvDPVs09fkJzBgt9tkKPHHS69Ia/mqOWzAYIuWQURm5/59bq1cBg4WW31iNmtaPR7A==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5288.namprd12.prod.outlook.com (2603:10b6:208:314::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Fri, 29 Oct
 2021 12:44:54 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 12:44:54 +0000
Date:   Fri, 29 Oct 2021 09:44:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        hch@lst.de, jasowang@redhat.com, joro@8bytes.org,
        jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@linux.intel.com, jun.j.tian@intel.com, hao.wu@intel.com,
        dave.jiang@intel.com, jacob.jun.pan@linux.intel.com,
        kwankhede@nvidia.com, robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        nicolinc@nvidia.com
Subject: Re: [RFC 20/20] Doc: Add documentation for /dev/iommu
Message-ID: <20211029124452.GW2744544@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-21-yi.l.liu@intel.com>
 <YXs9IwqYHvUUXePO@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXs9IwqYHvUUXePO@yekko>
X-ClientProxiedBy: YTOPR0101CA0046.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:14::23) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YTOPR0101CA0046.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:14::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Fri, 29 Oct 2021 12:44:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mgRFc-003S1H-MB; Fri, 29 Oct 2021 09:44:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d41d750-81fb-4edb-b981-08d99ad9e80e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5288:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52888B4382B277F09F6561CCC2879@BL1PR12MB5288.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g4pmQiYIhYh3mqVfmnW57QL549msHjh3hfvBKA/HICz1Jqa41ytjRtbz3qE9yiQFFvgaO8RKYb3nYje77WZUBXWlp49ZfLxIy+SoqAr61okEg9Bho7lF7zOzDIGvMKyO1B0rAMNnTSFxujgnlzWm9i4u35WRN7BoNypX6nYtUZmhE2K9lw4BGVND+oBMfjLdWNnLvZwUSVVu7fMeW6jOAvHjqhSvbKfhzDuBJBNOz7wgFYEyyuTLJuaX/PqmCHkDoL+T5szxkGDWm6g5QHKZSTfZ3/kl2b297YDb7/i9zJSKLSF4vFGo3cFWAd9gjJnggedbmEAzYnWcqgoJXz8UTjkBVahQyF0uyFelPN9qgWHZZB+g2jUkLCSlEj87n7IAE4MwY+a3Xo9iiaMXXwqNh6HXnj9PxI5jVC+tei9oZvWcRyIiMV8BfdxEZrMj89IakzE37T+JwJsmBc7Le9UPOZQm2f7oLbwnnz2ijHz7qP3bZNm0d3hjZ5rYxOAW37m55funyOT+OG5ugjvA9LZG2C/tPhzI99lZhNLzWJvCXSJNafNmuS8wHJoSJSN2Z4m7xU9wnI//be3bjFfE6u/8he/c61GW0+iyBO+gAsrS8soaDWz9ary3My/DnLE/7arg/GX5MTK26s+d+gMOxMgw5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(5660300002)(8936002)(316002)(4326008)(86362001)(33656002)(26005)(8676002)(66946007)(4744005)(36756003)(9746002)(9786002)(186003)(66476007)(38100700002)(107886003)(83380400001)(426003)(7416002)(508600001)(6916009)(2616005)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cx9bd1RUVR6B6gzOX3YC0H6trKkQeIhIOPZMGy22qOT2Z7LOmCTi4P75Hqg5?=
 =?us-ascii?Q?GN9ftXMoBd6w06PQkD4TvBqpT0uYe7EOnpoqfEbcydMGY8JC2jQ9SxBO/CpZ?=
 =?us-ascii?Q?AbdYBGgJXtKbeDucV1SqJESeN82wfMIUe+xp0nrQ2fzCx/r89pGUCFSsKAdd?=
 =?us-ascii?Q?uFei0GgfLlMik9RnzanVUs/qmoK0PXOxA1lSEectiJx3+7EiOJFhrY9EI5QJ?=
 =?us-ascii?Q?Ao6tavHOopYbf78ew3EN77wLLe+TWZgrESDJoWizJ88e2WrZFabZvaIZx3SO?=
 =?us-ascii?Q?JDRsdCZhsId9EenhQbsEEouzA7+nH8NyGl0RN8vlxY/hR6q6Sc1VMurS3J+A?=
 =?us-ascii?Q?UZNmBlVU7uXYe65agJgGxFzd5KUtdHq3UJzK+AE5IiDTMBjiynegarzSrAo1?=
 =?us-ascii?Q?/kRp+jWCq7BtVeWvCV0OIokfGfCBl1yvklm0aWLvACxOqnbVsQjwWrlM50y6?=
 =?us-ascii?Q?gR9Yzvr19b6YknQ8DVztsUAyvFm4USqSMAfB1eqc9ldbPJoU8s7EIA0mjR4+?=
 =?us-ascii?Q?OE63jwQFBxQnmTfuAYNqhJve5YC9m1hhuXfreW+0sVZFLrXdunLsbF4cZF4x?=
 =?us-ascii?Q?HUO9yAvMXywztKXvEMBbeJA9+z8RHzVyVf+CNE/RKyRuDnCOXDWalnVhoW0G?=
 =?us-ascii?Q?Yz6b0SAkTF3LGQ5/HJQj3ZIwpDkLmiFowzAbqkU9xYTleojhurHdj0QqV/5I?=
 =?us-ascii?Q?OR1u10jeQWi8ziHGBfYz85T7Q14/7XY4opxaNbEoU0saumruluGd4TxsqriM?=
 =?us-ascii?Q?xVS3k9Bxm9GnnxhIeGXIb2ThR2L3rhoRHAySRTGlYN5Wm0sIlJxhQPirWkJb?=
 =?us-ascii?Q?Y2r/RdOwpUiXsFtjuX7JH+oZcN4G1wBdoEQ4skHBezZz46RB82BUtL7CHnGX?=
 =?us-ascii?Q?ygD2Bx661QS7lfvYZIC80Jjhe+u5B7QTacfqEWFieF4AkMxkNhHBGVw68WOL?=
 =?us-ascii?Q?rEnX9Htc9Lx89hxiEhhsc5wt6w92hMM0Xnj146+GuCwobG43CWP0MAG7cbNb?=
 =?us-ascii?Q?l/XTO74nhQrMEvyTa3/s3DUqIwBCetHRuVRbpXiT1oj6g62CJt+8j/6y3d1Z?=
 =?us-ascii?Q?Kx4AITNl4wITVAkdXnVv8Fx5FFl1QU3vMGf0kkujoWKTkOzok8ZRlm3IVz3z?=
 =?us-ascii?Q?aPjVBe91n2hwall1Krn23eJUtR9HWIjMiYxrI1FyGgcPc3SXvRWCZivlhIAy?=
 =?us-ascii?Q?7XvEKsUxP+OWkuKy6ddb2mChg1lNCbuchw7JWNYupBbmpmwKJz+Q1JUIGWOF?=
 =?us-ascii?Q?/4e4L0wDyszFxuQcu5mEFYIAxnCHI4ZFnF5kvrE6kuCsbpdcxZSxVj0tkmYC?=
 =?us-ascii?Q?XK1CU02vZ0ZA3K1fOG5E06/BkPRJiMgIVCCpEmYyT5lBfpiycuAlYerTwBPC?=
 =?us-ascii?Q?hV3pheicupg2web1hL3km9E6TLH1+dgex7fienvijSakBlY7o9LfId/eeGx7?=
 =?us-ascii?Q?LYW9N93Pz3m12V3iHawWzGEVotwsYtm/mzfSiwZF1hv8v6oaJpR4DtWm74HV?=
 =?us-ascii?Q?AkKZosk9jadiEIfMkEo2vbJkpzYSdkl8YIlWiyEd6csKpYUx5fYy1bDPs1eM?=
 =?us-ascii?Q?DZxO5ctAXJpqk+Bswi8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d41d750-81fb-4edb-b981-08d99ad9e80e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 12:44:54.3855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pj8naDd3dda/DY+F+z+qUZ4Jiv8bmq6BG9TYA8/Zv/pe5Q4Pyz/UP4PVTHL7AIrv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5288
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 29, 2021 at 11:15:31AM +1100, David Gibson wrote:

> > +Device must be bound to an iommufd before the attach operation can
> > +be conducted. The binding operation builds the connection between
> > +the devicefd (opened via device-passthrough framework) and IOMMUFD.
> > +IOMMU-protected security context is esbliashed when the binding
> > +operation is completed.
> 
> This can't be quite right.  You can't establish a safe security
> context until all devices in the groun are bound, but you can only
> bind them one at a time.

When any device is bound the entire group is implicitly adopted to
this iommufd and the whole group enters a safe-for-userspace state.

It is symmetrical with the kernel side which is also device focused,
when any struct device is bound to a kernel driver the entire group is
implicitly adopted to kernel mode.

Lu should send a patch series soon that harmonize how this works, it
is a very nice cleanup.

Jason
