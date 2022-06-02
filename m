Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F3653BE3F
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 20:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238279AbiFBSzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 14:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236523AbiFBSzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 14:55:41 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFE4228F61;
        Thu,  2 Jun 2022 11:55:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABwYvxGJ9ZRLP7LCYHx8l9nwhvTl9nmRkdA1mKnxdmGQr+hnXsOdxWGOo0nQm20XyZt4tbTmiHhfJJWiwTUTYMEwSXpmqSfSLEmrjNH2mSWruy5AyHOGscDjfD0YxbNwZbzBWSx8OsFQVp4d4jjpuY5Ckw6HT1NWmnqzm0/5Nze2n/Xr9Mc3krYh3HZzD65cZaDYUDDggPzsqw1PakzNfjYUL0l+szG9cxWaBkOMC4FZouuy8XOrgqtmh+Up/dH7UUMF3xGqc2kt59WU03xCpjw79tH8XQYOruC0LumbyPFp3dTHMTMgin6zGEfnUk647MNMcX+s32cACdVYKPcQ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mzo8xggRku4R5PhLoM+Ud/EkQix263EeKuq3UaGeQcU=;
 b=lrbG440yVTljTuE+ni36kZI/OmIYCbTgen/8T2dOinRNWdcoJnGec+fVo+rruWmoSBO9ytSUVRTyfQ9CaSkRkH2/MVt+8ZWyMuP8Ojx4k+FXpsFUyJcKHJBiYIUj1P+gH351u8KYt2gyPTKBQNSNPE/m+g48Xfz2sOZnRxHPcsFW4wiGj9GROwB7aCrBA6g4knhL5ws39gHLdJuqF347V4dTg9X1qT0+9Q1MrxPp3J8MoAvFsE6GFAKksBUTyyTZWadc3LURT1JYSnCwZSUaZQ8UNp92VTJln+sHlYuXVjlHJoC9mImdBhsi3Mz3Be586mC9qRITU1UuA3PCsMHeXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mzo8xggRku4R5PhLoM+Ud/EkQix263EeKuq3UaGeQcU=;
 b=btOO1PrPKVpKDNYsBoptAuppPS3obsbIeZPEGUmluSH6WGI1FytgAa1eBRGbDrSwlGTbc7lMEkGTR91L4IN5ZbmxnIB5OwZBK+zRjtFL9JQnkVrKuFAnCnO3eRx1QvxSMFZcpcwqRcp1hdyGEUV7AviEBYaa2yVyLY1C18eEjbXldOeo/WEysBXaFNnhFdHcrJ2yD8h6ndsv+rj09jZ60cJiyHl4xyXYLfRz6o4JRcSUBLpUTyahz1fwmTI37pb/hTw2MfmGX8Pubb/wn2nMJWNItxn+5Cly+OA/UIMcvEYWKXyAYzk3Xfb0cg8iSxMb8yYQbBnHhDUmewwVPeAvhA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR1201MB2499.namprd12.prod.outlook.com (2603:10b6:404:b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Thu, 2 Jun
 2022 18:55:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 18:55:37 +0000
Date:   Thu, 2 Jun 2022 15:55:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Michael Kawano <mkawano@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v1 01/18] vfio/ccw: Remove UUID from s390 debug log
Message-ID: <20220602185536.GY1343366@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-2-farman@linux.ibm.com>
X-ClientProxiedBy: MN2PR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:208:fc::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9c80352-2bd6-46bd-c854-08da44c97b13
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2499:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2499890506B9CDDA80E3CC2EC2DE9@BN6PR1201MB2499.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nnfmf7SHGwUZ0A8j/Rs8oVbKOU+DatPqr/a9jCkvCu+DIhApUU5zIfDV6EbVo8NupO56fiqQodgbDHFrTYhBIunc5C8gBTYV4ihnSuSsATB518EIDABuxRc9qF6Ke6GHGGyqEQuksq3LQg0kFyvJmvBMLaYoy+yRRatpKr9/d2izPSNzi4iNFcbICYCd2hmbuWDQqOP9jSmYO/OcQAF6+YXcUC0LirbjrdV08rNc5NY7gtPO1fiP+4OwOatkWJF6+BdguH+R3LQinBVxHTIZNWh9hDx+Ig3uIw0dJipHt6iWWzI8PsJ37dkZ2tjtXtoJPP9tJxZozzOGkuC9b9Xc0Et9Qt4//6TZ+O4L9xWSNk6+hTn0s6BSPJ0PEteTJGV7tF5CMePPH/kkn6Zm+gU1/gQLIp2qFTlQ614bOLX1LN+mrVC7nvmTXyeqfiyeNlfXOPW9C80rKp0meL+D1SF6gOfiI631h1/W6zcLYAcPN1HEyWW50DjaISaXdzGK0Gh9Ml9eLDAYFz8MeBxU7fvAjhaBPgOXPcd5A5PSnKyhPTn0txr9Bv+jTiKOlIOUeW52EqoyqmzwvGuX+IDf8A6quZ9xZoyv2xv0z8PGabFqxdm76xwaq75LaxOXCKNTCqayZwwkNLNb1pxWWzRGLt8OWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6486002)(8936002)(2616005)(83380400001)(66946007)(4326008)(33656002)(66476007)(66556008)(316002)(86362001)(107886003)(26005)(8676002)(6506007)(38100700002)(6512007)(186003)(5660300002)(2906002)(4744005)(508600001)(36756003)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GRv4kjATKV6KRwq7ivM0ulpyp0//oABS6coc4HNPYljgLE4XKRX0JvSgd5is?=
 =?us-ascii?Q?iOl/S+7KS6rVkzLTePvjQdJB7VrKzipI+lHUQ9ri8fyctndXMrPgEIUpQkLH?=
 =?us-ascii?Q?7mkHQnNI2E7k+eY6vmsex165ip1dY3bu1qjLwF4DOekA8NqDzPDW4LdnYYJY?=
 =?us-ascii?Q?kuxYZfgsagwBZuGzDh4RfRzBxN5I3CcWleSCtQyLGgBxMgjDgEO9NKW8tyKa?=
 =?us-ascii?Q?L52riOSey5xRgecgYIwaQpgPuFrg/FJpeMww0g1eQuyykUFmrXJYQjHUG38Q?=
 =?us-ascii?Q?pCxKoC7kwxa5rf5x8M8Nt6CGaLnhzbHv7IODsKaDgNOrV8YrwCc1KuKrAVuu?=
 =?us-ascii?Q?mj1saMF6U6KpeSMjkrWB+v1Wv36CBQrXzowsFg8wrW7nBvzMqHxPRhUauEEw?=
 =?us-ascii?Q?+e5IEzJSB4qMtSObXXW9Zw9DJdI52nQbVFYQoAART6JaZmiEkRkTAc5CEDci?=
 =?us-ascii?Q?d/7YWheBXUeHVbtDvetqRFO226K2y5My+2oxYRv+q5bSKJW+5mvbix5BVJvb?=
 =?us-ascii?Q?mIki70KakrEdzWGgRoxdujXwJ4NL7TpXJxRooI/qDwSMtUWptg5ZSc8LZv6A?=
 =?us-ascii?Q?DT5G69fws8jKVyvgSpg6Xt02hE5q/ksqLv5FukOVGvU4GeHwcISQ+e4tHjl2?=
 =?us-ascii?Q?MSC4ZiMBTaqKceI7TTpY5lsAxveMPiWPuDOW0dyX4iBqcJNCPDmFkIGwdZNL?=
 =?us-ascii?Q?XCxjsRgzNOi6QAzDG2DMNJKSgQ1arNU1jzcfLzh4vgRK4TXSbnUAFb461Ne2?=
 =?us-ascii?Q?1XLhU9V9FKJ+xVKjP+SmBiKs0KakSPSBFA5wFFG7dE+EX2+fIN77Ixea9B6o?=
 =?us-ascii?Q?nlg+0sreSWUsJkM2kom83h6bKGZGzvZTWjIZVFR6exlyUiPFXatpZvIEwWCr?=
 =?us-ascii?Q?YmJjk9EU7NQwxBa3Lfq0SZ1Nvvb0jBi/0aJq+uIRRssd3YNsnC/gjucmr/K1?=
 =?us-ascii?Q?lzNn4B0tBotDo/CUBmW5bxqja1FTiZwjkoiBgKb12/Ot7Gak78AGkbG7Y7LP?=
 =?us-ascii?Q?cmDyYo3yUjw+NffIImAT1qU9oiRJvGmL0IiPWlW3AKtfIYBb2fdSxEomx9/8?=
 =?us-ascii?Q?NKUwSqx/7DS5POi5jTY8LTxRfPR9P0uL6u7fRSN+XLcr7uFShyzTtZwM2yKp?=
 =?us-ascii?Q?gszxA3tte2RroBr7hnjMwSpyZjt0WYX14CVn8pTvEChjkjjDwivys98jbU3r?=
 =?us-ascii?Q?tmzkNtunA2VSvjVoC5zz50PZnPNF/7LbdY8zJzgnJ8KSnSIFy0DUtHJ4HKHu?=
 =?us-ascii?Q?i/JStGiPu4HCUYAOxq5e8ZX4vLD24OoGHtLzFmR2liutx1fOk12AHeIsbu4t?=
 =?us-ascii?Q?ItEAKjRNDPSkTHHht6p3hLcTMuJqdMxHI04Xz4yGJTsLA1mIOV6xGQdka3vf?=
 =?us-ascii?Q?nJBzJsnk0uWmUKxtb6WBNBss8n8Ktwug7rEZ/jV/brmZwYYQbLUC+78m95DZ?=
 =?us-ascii?Q?tsZNTadJRvTMLQ87MOUBKYdhEJWhtXCHKvr15/IivyDYZQ1pyNcYCT85D47i?=
 =?us-ascii?Q?hEYwXzvbCAebhSOrJBK4SAhj3c6eMs7e/gREs3hBQw7EkrT81aZth8/P2OKr?=
 =?us-ascii?Q?p5mKfSEzhXjHSZJDA5JYCM3d/zDGt5F5A0ecuiXYJH6XziOsrV6SJo3xCRUg?=
 =?us-ascii?Q?cPROGnUpxDqCFMiF/80N505EAp5mJAbYHiWDtRKSv9GC+ppJhAliaNDrsYcz?=
 =?us-ascii?Q?bjPfYc2XF1snDcOWaJo572a5Q2zAp+3DgCxMzj20MfpB9dmSjMt9G5R0pxM+?=
 =?us-ascii?Q?Z704ApiPDQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9c80352-2bd6-46bd-c854-08da44c97b13
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 18:55:37.1449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3VCqPlRyEOQ59r/a3seT6/McayBGGxOb47Xlvce0Yd/pZWpN9KTWThUWR94Mlt9u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2499
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:31PM +0200, Eric Farman wrote:
> From: Michael Kawano <mkawano@linux.ibm.com>
> 
> As vfio-ccw devices are created/destroyed, the uuid of the associated
> mdevs that are recorded in $S390DBF/vfio_ccw_msg/sprintf get lost as
> they are created using pointers passed by reference.
> 
> This is a deliberate design point of s390dbf, but it leaves the uuid
> in these traces less than useful. Since the subchannels are more
> constant, and are mapped 1:1 with the mdevs, the associated mdev can
> be discerned by looking at the device configuration (e.g., mdevctl)
> and places, such as kernel messages, where it is statically stored.

I don't quite understand these two paragraphs, but the change looks OK

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
