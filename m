Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA9B63A95E
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 14:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiK1NWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 08:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbiK1NV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 08:21:57 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B851DF0F
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 05:21:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7tTm41eyWv2/eridLflzHqj44WtUlIw8YiEb8BCLNJjXCYb04k2f/qvFUQOsABplXYIRUhIhLhkZUBwkjbzS3/EF6L5ZAZTDHObdFoY4Cai8VBUCQVzs7bzalgsHm7L0TmkMCtja2CeEJsIZy7epUD9UIW1kvWIfubY32bGREXSuFjmClc5+Yels7ogDd+UVbDAaqgriy9wofxYPPnvQpRhjQb1eytY8JwkvGsX5eJAfjBRqETpeBnoTHqBJXqzfStzvCKVSyXs9O5xaqLzIVEv8hzrJWuNDR4UMfOnoDwuEIwUeUZ+S70TPunK2v6A38wsan139G9nS7ctFn5ySA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rJGghi78wEIgFy24EYM0CQUkwyiGpbNBcnxIpV8QW8=;
 b=nWRemH/L+nPhxrPRiZP/wIT6L+FeEbX90RoanGKeU+kjZ5SfjbTlRBswDWgWiDCCPiYLoWly5aRunbtdVzDKJkjcGptayGNChFUnMAdWR3qEMD18IGlQrdT2v58ROnWpENAaT0beVWowU2X2SYwpuj0dQbvUKXvsT9StLl9sHmrixnjsgucseN8XNYQmXzgLiNQcFkIQrrlc7lX6ZS6AM804XecbnYBf4hqTdAuvXIHKzrUPhncYknV3cNa8Ki/WJKMV2EHQpY3ZPbNZyhs6zSMReCTG1RgpDDTwue/HiVLdW/lE7HUcT7GrbPjBiS8buf5kn7smhbfdbVPbCjyIVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rJGghi78wEIgFy24EYM0CQUkwyiGpbNBcnxIpV8QW8=;
 b=oA5ej3otimPhB2/Zr8u40BVZ6BH+fUvogojGPN+XivSYAY4HNRzsiv+ccbVGugocA0QKK8GYIzM//kqkbtx2gGbHaofeS6RizcC7et0zPsXBeRxbH095Qq0XXxJcL1WzpVSNzTLuEkaKKJpLmlYtIakvbDshzlbv9PGkDbvxZ0jRc3Cyg7QH7H3locppbMFmcGHQ4VHSFXf9mcOqgRrmG4AUCZl4JYUzB3kzBqx0ReieRTxoqQ3vJIkILrM+yUi+NU9w2GqARmpQVdwmN5QzCh0Uye1vG/B5bTKYJaoHoKnVqJ+OyVH03542MWmfko1zOqSPVAX33+aKQTYrtmFNSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5866.namprd12.prod.outlook.com (2603:10b6:8:65::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Mon, 28 Nov 2022 13:21:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 13:21:39 +0000
Date:   Mon, 28 Nov 2022 09:21:37 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>
Subject: Re: [PATCH] vfio/iova_bitmap: refactor iova_bitmap_set() to better
 handle page boundaries
Message-ID: <Y4S14fhmJkOHhMa9@nvidia.com>
References: <20221125172956.19975-1-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125172956.19975-1-joao.m.martins@oracle.com>
X-ClientProxiedBy: BL0PR02CA0062.namprd02.prod.outlook.com
 (2603:10b6:207:3d::39) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5866:EE_
X-MS-Office365-Filtering-Correlation-Id: df38ae05-4c5c-4a6a-9f49-08dad1437b61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QjPL4qD0tlcprBAmqBqdd1tz3MHgs0BrKRYG9wZV/IRUxoVp6KqOjQpbVMtscf5MswjABSZXtqkSw1E5xg9BueUEKV6jJQG5N1ltO7oRgxQa40AKaEIxt0vSHNOemDWQYuSavAu8eWn3teVlAEDIUoMImi28Iy2Y2dEq/zPgH0Qc2m8HmC3APtpI2aYz6KI++nVuiGMMi0tJj38CtByM2PHgZ5pT4Xg/nHWzAZCzqI0KUOyyN1+gJFd3al/q6yHL5YbX/5FUkpv1+lg58SU3gzqd+zDhq4xwXTgJzdUPecY/ryQRIFvTGvnuZbnJLg9rY0Ih5y6C89s7X8vWxpeeycE91SLo0OolcHbfAJKPb9oVzr9MaCF82VyrLioXnAaga/SbJSUev1/WAz6QiFtB8dC0wI3SaJk2SQpkRNxglShy8KMD4L1OJibwpQpG+/7wGly0EtcYNCqriZSNO/n+FNvmc+t1plO9VDcYRmr+J1EHKWfruW8XCdn+Upf36drOTJJynEDkbc49w94rMGdmqQlkG4aIKjrmr1lvISJLa5STd5edx3V2LUEuLcDj/VSe8xFqJBp/FavRaVLVZaUwJGDJPhdCbY9ozAEvpcehDOax9iGDXoi2Gro181Olx7P4c21/LqVtfEQaadl2hddnbRSH2xNr2qhfJv5ZEaNSCOPL5lGqvk6PSr15xPcdT2YC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(66556008)(2906002)(38100700002)(66476007)(66946007)(26005)(107886003)(5660300002)(83380400001)(316002)(8936002)(41300700001)(6506007)(6512007)(6916009)(8676002)(478600001)(4326008)(186003)(86362001)(2616005)(6486002)(36756003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IwJ8vdxSwn7gUOld3T/ccE4nS5WVv/ypEgHEi1YAfi05/n6+4x0lMH34hhVD?=
 =?us-ascii?Q?ERxt51s7QlFl3CYMWpPCOlvVtLt5S8Jz6T1egqEv7ZZvr+prDgk+GliifxV4?=
 =?us-ascii?Q?qL9O0vrDaSUm4KYXWg/ZiW79cLUlp7Qm/rMTHSZwHWVyJRypmZhXbFnTZuL0?=
 =?us-ascii?Q?CwaKYB5CAybbUvROtOvknOMKFmtMks3jhBkz6f8cQRokfv0ftRk0lrpqydgO?=
 =?us-ascii?Q?nInRNsOqLk3Y9EZwFW+nGybXMZz6AIgUjHsirnWxMJ0BhKWkQ3n2fZrWfdU0?=
 =?us-ascii?Q?fEZx1BgQcJqnMdQsN9ZCCWn3U7E1ggOBbPel+DIGlIKVZqUvxHnt3TaTRS2F?=
 =?us-ascii?Q?e9EcCDyd/RRVCeFgDd/7C7OwrDVWUGgbxGWcFJ7VfMmi2qzJXla+GmgNzMrU?=
 =?us-ascii?Q?YZHTBMYueXG0CucCY37QLbWSxmsTuf8Ho73OXnjWTeh3r/qs6+vg3X+JoTT1?=
 =?us-ascii?Q?sIO3icdtvnJzdNX8TdXq6f3/bAnKzzzRp4EgXdMPUj5cqc8h84QI2PXByiwl?=
 =?us-ascii?Q?GKf27dc8Z/vTeMxgqdIRt9aYaWz9Xr+i1Yv2FvVNOeaRl7Ez2QGgOHwJU9XR?=
 =?us-ascii?Q?yOUkG5arOCFXq700t5qCpcJ4PYaHg/7fRIZi7dDmW/TUTt5G0ggaFf1R52v/?=
 =?us-ascii?Q?gTCZpygXxLfGfUnojqz1LGe/Vieu7kjQhjvjJ+ucwHX6W+EM1x+5xhh6Yugs?=
 =?us-ascii?Q?bPWt2RX3/nKtsJxi9jKPxdJoTVytULP3Wk7XjNI/NB0sellC5xUqudi5Ssfg?=
 =?us-ascii?Q?6zmDytJgjekoKuSo1cpnMQ5NEGxMjZmz1Ick7CLoLdl0zeb8XoZUzKihLWIM?=
 =?us-ascii?Q?fAkIEwyLMbOfZF4Sr3Xxjjnwam29epH6HUmu3o7GfnUdunhgU4g4PthxPklt?=
 =?us-ascii?Q?EBJ4oMBs/0N7BDisVg5tmdIGUKxH8PFsLyuHSxjnTnIg6/7fjM03BW59622j?=
 =?us-ascii?Q?44PpA2+iOjnxAPj2V5752IAod9+Yi69UoYUtp4WzhxX/T19UpwGGjRdD4A/f?=
 =?us-ascii?Q?zLUlBXN1WJtIxuKybyAmt5b11HmgPX2OqdHFFbWwYKwUBPBtqSWXTeaCA6tl?=
 =?us-ascii?Q?4C44i3H6aAKGC6LBdjTtvimrK9scHZwuCvcfOpT44zlqBg41tY/H1KAnjSwy?=
 =?us-ascii?Q?BGieMiwgsMa13t1Ntaqd20JK27fwl1fmKIxkMxbBzA9iSB6NC/gWBiCh8qkH?=
 =?us-ascii?Q?ZH8VUelA26W7L5tA77JaKUOR7X6Mf9MjGcveqiULT45sCiWQX5gCZx/gXMXE?=
 =?us-ascii?Q?h1DbLCgPef1uqYSQ+Z+1jkImZyoMWATWCWKRJG+kT9RPTe/n/8htbjraRvFR?=
 =?us-ascii?Q?+MRiLwpEhgBEHu8931OEpi+7W7Bi7j5SIk9c+kNjO8/vTVjTN4xZZcRkLxhF?=
 =?us-ascii?Q?fyrMyjL2GkcJpGERw6Ph0L63A0CFs9zUg8Yoy5YYcmeWDHtO8aC2hpcKdguk?=
 =?us-ascii?Q?x8KHxIqlLa9KZoeA17sjSqAx4FnautqLRUUsUVms7AfcCcRvB4/1TFbR4as/?=
 =?us-ascii?Q?+gIfpxRDI8JlQms5tV0Zmm3hk3p/fBEj0rReCaonCRnBpuKXHipcVjb1IEdn?=
 =?us-ascii?Q?DpZM2+HvSlqwU5k89nk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df38ae05-4c5c-4a6a-9f49-08dad1437b61
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 13:21:39.0605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 67P3UYAaZCS2G21L/0jxG6OjYkU56ppSFB7hIKb4b3UiFvWexJIaokm5WMnYMwxN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5866
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 25, 2022 at 05:29:56PM +0000, Joao Martins wrote:
> Commit f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
> had fixed the unaligned bitmaps by capping the remaining iterable set at
> the start of the bitmap. Although, that mistakenly worked around
> iova_bitmap_set() incorrectly setting bits across page boundary.
> 
> Fix this by reworking the loop inside iova_bitmap_set() to iterate over a
> range of bits to set (cur_bit .. last_bit) which may span different pinned
> pages, thus updating @page_idx and @offset as it sets the bits. The
> previous cap to the first page is now adjusted to be always accounted
> rather than when there's only a non-zero pgoff.
> 
> While at it, make @page_idx , @offset and @nbits to be unsigned int given
> that it won't be more than 512 and 4096 respectively (even a bigger
> PAGE_SIZE or a smaller struct page size won't make this bigger than the
> above 32-bit max). Also, delete the stale kdoc on Return type.
> 
> Cc: Avihai Horon <avihaih@nvidia.com>
> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
> It passes my tests but to be extra sure: Avihai could you take this
> patch a spin in your rig/tests as well? Thanks!
> ---
>  drivers/vfio/iova_bitmap.c | 30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
