Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA14553BEC6
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbiFBT30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbiFBT3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:29:23 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075991834E;
        Thu,  2 Jun 2022 12:29:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Is/CqN2UzWfShJF8IsYDzGnG5+Sd1HHTe2zaOz5EZTTMP/gnKGpnmkXGk9+YYaYSt9EWIS0GseMpZDmQb7Xxui5/2in/5J79jg+6y1tD1vIZvUcq/XhuBBBeMA42sWLZBr/6GSvMVCGjEqhS666tl0fUXjUERHY85MxbiAC5RKTowKHCr5jy2VQh6HBOqNjMXIhGnuB2VslIytHJ+Ks8KUHHM8POCwjyg8Co1uaTtcWz/nfIyemy7pduoinTakakgU9GJ5PfwP3YwPOGK1SpKZtSP6MIRdgkjGHslIiLW3RshpkGLV/XTPFSTP1783xsicDdloJlrM3KVfCClodKMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDt3+RX1oxcsxRNtVdC4+EKZbYaqfjeez0Tdcu/49iQ=;
 b=Dt+yLPBjPGoApMxTgLO7YgdRKAOScAkTVlQmx1xlfWMbDDIygsCn4tjvYnEpWK5VfiudF0E9Qv60tk//2d/ai6Wns5Hm17f28vneOa37jG87zxU6+rxYysL8XAwE6ucIdltbP0Ub38TRxRkSXKzuokjL4gjWIYeYXLS0rB7yuopjJAS0EyNmDuVbsAADGPie1Pq9dj6CwbT3pvdZ6CviEmHQiMNzWPP7+2j6ArPwUR3hSYV/6LKiLMTmEob6OeuDBNOdipJBJo9crsQexVUVUUPsnMBFkMBMRypYvtKd8QbAJtIqjJmLZ0ybyySkIAd5QB9hvlE24rUDmknW972aDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDt3+RX1oxcsxRNtVdC4+EKZbYaqfjeez0Tdcu/49iQ=;
 b=LXNbm/NLnjJUa7K8PgVcgU1njeomlyxTv5aY8ja6U58T2DcCjiDb4jN69AZqqPlpjiXd2MGxrmQqrKXKuOoyFqYHHdl+f9mSrhBvj7eBnciiRKShQRILXxERv/snyAT8A+DdJl47udruazpsr/wR4PsAx0cIjPQFuE5n+DDu3YZ8yHBXNt/p/5jDQdxYBs9y3PFh2nU+gb14L33LqNbqVQ+sw+FMQg83CAeL/a8YNJKQS5eRdnKrm3B2nLvVDZZkyslKdLwIV/mwhwj9iBNHQ5XwE0m/EcMIDOOySflYIkCxul1ZeQkaLqEP8QnYXhJ5QGPlkqsnKizXMcECrPmgEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB3795.namprd12.prod.outlook.com (2603:10b6:a03:1a9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 19:29:20 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 19:29:20 +0000
Date:   Thu, 2 Jun 2022 16:29:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Subject: Re: [PATCH v1 00/18] VFIO ccw/mdev rework
Message-ID: <20220602192918.GL3936592@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-1-farman@linux.ibm.com>
X-ClientProxiedBy: BL1P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e623d114-e23c-4d98-62a1-08da44ce30e0
X-MS-TrafficTypeDiagnostic: BY5PR12MB3795:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3795DC4ED2B56DEC6469E45DC2DE9@BY5PR12MB3795.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99FpYBZT1tbF1752SpBMy10CKoy6ayrdzZXCaoFqF63S3WSyKecBJLjLzML4gpItWVhwdny8fD4UcW6gdfABiNZ/LAi9tfoMT44U96HKlxArJac+0FAmvf7gE2txKK85EO+c7+zXy3dE7JdJd8u54lnXk1SvQEaYl24Eqx5GsegxeEDQTo30bbgGH8Zf4s1Orc+y/6/knNReWbehmaggdnHSxaVnRoP5KtFhL6Ot3WpiFnDLbrHVqMbkdqYG2rjPTP/lHl3MdWMD8LUo0kyU8P0JIwu4/e9IfwB2BtIfusIJLR7HMc1poN0lt40MZTbGxLA4aCU0NuxNPDI3gJQkRi0k5cL8dHkxAtwYlcLjFbUPLErlnbT88ah1dd42fpN7S1BawqFFQsulpvc40YRKrkaoZNPntq5l8rIE+JKiug4F7BlInBH8r0i2t9KwOp3mTFg/hAv1pW3zLkdEEk4wqAieAwr/2f5ajr/sjWlugQdynyw/XSG4weRISSKUsWoj5KT6uPxYUkU5vezI4035J6hP9Lq+u34DWC+rQPOcCH1ASJwtK8nvTgMei5t14RVxcqJonTH52bkLRuscoe+LQRKA4cyZwvEpZ8zo3Q4wLY+4babrd4PoLZKUqVDyIpr/i3G/73IOeFri4ycVNBabGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(2906002)(8936002)(86362001)(1076003)(38100700002)(26005)(33656002)(508600001)(5660300002)(6486002)(7416002)(2616005)(6506007)(66946007)(6512007)(66556008)(66476007)(8676002)(316002)(4326008)(36756003)(54906003)(6916009)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3nFy1+TW6G3TNNJsA2AWxPNC0rCH9Gf0nq5AL5AWHXLAaH2vPIv3lfCvs6BQ?=
 =?us-ascii?Q?neRCMuVg7E4wmGWsYi4kufGbOPXenBxTgIbRJ0jcA3uqOGycySWnqY5vJKcI?=
 =?us-ascii?Q?MKPPuJ04+WdFW/XW6WkR58cfK4dvu1CLf3HMMy547OzmYmDj7BVXfjwxB2lF?=
 =?us-ascii?Q?6NTVBMAHJbQJxXkzxV1amlDfHHDMxnyQQGXyUUen0ZzI5m+VsBeqgTg7st23?=
 =?us-ascii?Q?OVYTIEXU307v7Ams+v3b2zxBG7BQLlWJLakzH4qc7vSVRa9FqC8ZtPmNt2sb?=
 =?us-ascii?Q?79fyPrwnzzomyphHrWTlfTSzYMjJN2imKwMHZ6/EBTFungN0NyJRqQqZIlV4?=
 =?us-ascii?Q?2g407S4QJvntk5hCEoJuGjz7bomXCgIDp98Lp1OPG7+OtuG8NOGvmuKvpn1q?=
 =?us-ascii?Q?Hv+S8mT5+GFvDwRG/BvtfI6cYpZ0BMEZfVLjj6gjzfGSL6tKCAT/6Gx6cb7l?=
 =?us-ascii?Q?dEIHoNVWDOGuP07tRfkFcm3JbGh/xKj++K4aOlgWwvkxEXr2hMFLHzxOSZdI?=
 =?us-ascii?Q?yBZKSr64lBZXX8LKs9sdlZWHMi/nMaXHNdNdV+GDCX2ktBqWa492MsVhSAdV?=
 =?us-ascii?Q?oelpA4o0gQHQKqLgqFLyPwBxC5VfN/+6vMuJXfOSP1bidksAlLObNfV7EtdD?=
 =?us-ascii?Q?CKif89+CajVOQMGcvqAL87aH9Ki1p5BlGZ6XDc7f9ySWiBUAZi477RiagHSp?=
 =?us-ascii?Q?g3hG3DaTD+gIpSMBKfyufGfj6UxxQ6GQOe2RWqHDiheSpZ39bxduBVu4lsZh?=
 =?us-ascii?Q?7NtPj7jBa8z2YewI4MRjmX0aRSHI/IPOzNQnvNOBXNGRgqYVhgeIv1mTku1Y?=
 =?us-ascii?Q?RcPmNYU4e0S328MTIWi7BpAzI9s94695MqEf4hjdDRFxktbCtlbMKnC9gQ1W?=
 =?us-ascii?Q?0ixDEKH1rfiE0lQlGciS7gFM3ijRHJczvl34HO/pgbA5cEOTPIvJo+lVsqOx?=
 =?us-ascii?Q?Ahf3hqoDgbDo/g8mBSA7GFEyf0MKxlvM7w40jisPsxE7KJGZjfD+mk7jaWV4?=
 =?us-ascii?Q?rl7yoNItElP/ZUYe3Kt6KJ43bA5nEKYNAAVZo1FStaNu/qeyuNObCPmTiu6o?=
 =?us-ascii?Q?WrhqBOdhcgLlv4Ql+eymAlhJe737ENJupLmMdOlLH5HD3DXgPrh5yYIpJJzT?=
 =?us-ascii?Q?CFNj5zOjY0dvVpq0o9y3Ap9udu2FSeHTs3ZZ+Qu8mkAKJzWliA3kMWTIkxXL?=
 =?us-ascii?Q?ENIh8LHcpVGujIOVDxPnWsEfDo5DQZ0I4CiX39vBYVG7YtCetbFAd3gHD0nd?=
 =?us-ascii?Q?8QypmauOfPZjkxltktkOF+VsLP6Ns3h2LvSeIrhZpK8NX05WgBgT+UYdPfpd?=
 =?us-ascii?Q?tZa+bQ2T/YkhVT02tsRQWIeYMl9MCHTtNbp57rUhjA5eOWvCoRlA0EKXaEdo?=
 =?us-ascii?Q?Z+vezX3mFHr8PgrW6ximesZ8bqWVIA/HsnfUpoKkeBBjxiFE2BTbAJE3drGq?=
 =?us-ascii?Q?aoT29/0uD/GYGwlEVCDssh9MngxQWmKVjcd3CM7iF4860cdiWHTyDNA4Q4Bf?=
 =?us-ascii?Q?004SlT0DRuDliO0P3RkU+NgElnqAzJMJy/LM4G3NgxEyrcX6NiOegcPjB1Kn?=
 =?us-ascii?Q?Rv7IaoyulfB8+DRsznntRB0NOqB9Iaa91jrQvzvENrU8AxUG7G2ARlHdmZ2r?=
 =?us-ascii?Q?1BkDG+Mr82ChpIhZASso6YrL+qmEZqCM+9p80lontQeD4/y3KMYe86IF0gcu?=
 =?us-ascii?Q?u72KEikxGJ6Q8eO7ucv0Ye7u4vgpqWhLFGzUe4eunqHtD+90Eu63wl/2ACuH?=
 =?us-ascii?Q?QqHrqdUchA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e623d114-e23c-4d98-62a1-08da44ce30e0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 19:29:20.1403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUPPFNrKSYyeLIPIK1HJHMH4KFGaPTAxL0Zrn6V3zHC4JLSzUk1Ue1JJvmpkM82Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3795
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:30PM +0200, Eric Farman wrote:
> Last autumn, Jason Gunthorpe proposed some rework of vfio-ccw [1],
> to better fit with the new mdev API (thank you!). Part of that
> series was pulled for kernel 5.16 [2], but the complexities of
> the remaining patches got them hung up behind other work.
> 
> This series attempts to dust off and complete that, with the
> goal of untangling the lifecycle of a s390 subchannel when
> bound to vfio-ccw instead of the usual io_subchannel driver.
> 
> Patches 1-8 are inspired by and/or split out from that series,
> in order to be consumable on their own (backports, etc.).
> 
> Patches 9-12 handle the goal of making the FSM complete,
> and synchronizing the subchannel's life with that of the mdev.
> (This was the goal of patch 5 of the larger series [3].)
> 
> Patches 13-14 are pulled directly from the earlier series.
> As these patches hit some other of the consumers of vfio,
> those on CC who are unfamiliar with vfio-ccw probably only
> care about these. :)
> 
> Patches 15-18 links the lifecycle of the vfio_ccw_private struct
> with the mdev via a vfio reference. (Patch 17 was also pulled
> directly from the earlier series.)
> 
> In the end, the subchannel probe/remove callbacks from the css
> driver simply register/unregister with vfio-mdev. The communication
> with the subchannel is delayed until the mdev routines, which
> handles all the vfio-related memory and subchannel enablement.
> There's no longer a configuration where the mdev is closed while
> the subchannel remains enabled, since that's weird.

This all looks great thanks!

I would like this to go through the VFIO tree once you repost it on v5.19-rc1

> @Jason: I carried the S-o-b/r-b tags on patches 13, 14, and 17,
> as they were cherry-picked straight from your v3.
> If you'd prefer your S-o-b on others, please let me know.

It is OK, you did a lot of work splitting things up

Thanks,
Jason
