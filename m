Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332346379E2
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 14:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiKXNYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 08:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiKXNYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 08:24:51 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E331B8FF84
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 05:24:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GOcMAiYfA7q0WkN08o05bLrjmrG8mk+RQoS+wCDcjimUsflDtWs2A9+GiZEha59qSKw5bEyj9uvr1Y7//jhGcWHfQXH2abgrR7FQ6ytIeVuu2cOhkhmlwNfFonwCoNPPZsbYXYlxnyR7F/oP4hDzooIat5xUQNt8svGLUlEI7BNo848I41S5QwYRfFYPP8p9vCrbfjD0w3RecMvM53SeuzFavPbp+takFlvC/r3Rmy8G+Sja6uPZIOj0V5WNKGYwjW91+kBob5mvanOkXBnl9njEMaaTx7QmpIR7hsIgFqy7ocGYPbI/cYvsO11y/sEjgz5IixbEhb34btW+PLTfFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDeDVzbTZYg1xWT8/uyA346ktmlmNma0cEeQO4s0iBo=;
 b=Ct5c36QoAO+/K3zgrc6IDt4119llqrD7fhdzvnedruaSbuav4RbxLGteBftyYQVxMeU5ePCUK0aVV1bclL40tSbqCe+FvmTXTN3fv2sCmaxWJTE/crmQt9FhGcYwpWLw7Re7EUZB2php0VK0mUZHcoYVJWMoSnHlmFiaiJ/cAKoRpe29KU98DkqfyFMTxPGebOIElG452iCs6aTtJJEZRCNTq19zeCj5snbs2jjJCosXD4F48Uj92wwN6Rlr9KEYVXVdh053ZE0yt2Hzj1RCedj/YhQLQZUvwqWYRGGLBSfAsmx7lgouVwXL3J01nzBQ9ct2h8X/8luJgMHhhAgaRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FDeDVzbTZYg1xWT8/uyA346ktmlmNma0cEeQO4s0iBo=;
 b=kllXTz/LzmM6aZ+oC+vxlGNk5Xy1fV426Lz8y+P8TY++erXIfWLTlkTghySmsWwbmC/LU4cBpUEHP3cYzIwLjd/OqGc9CqSdqO32eDQnSsDmmiT6TNTeKz7kFEal/8V+GQ1MeB4TqzfKH1PZRVThgnXf8MMbz6bxiPsGxiB79YFmslDZ90HHepviRkxW0c4mI9pz2SCFzO6ySF6tog5dUqCGTXYlgX/S4l0IUNyOgWVPg7b0G71XCoktemlP2+NlgYmxM7TLdChpwHF/5voza4bzCJr8pq1AVzUDSR9m9d9W0IUr6wd6gKch2+vc6PpmY1BO0E7Whc73L/f91BKkvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB7549.namprd12.prod.outlook.com (2603:10b6:8:10f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 13:24:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 13:24:49 +0000
Date:   Thu, 24 Nov 2022 09:24:48 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yang, Lixiao" <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "He, Yu" <yu.he@intel.com>
Subject: Re: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts
 to vfio_main.c
Message-ID: <Y39woNI1WEvuHwZs@nvidia.com>
References: <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <20221117131451.7d884cdc.alex.williamson@redhat.com>
 <Y3embh+09Fqu26wJ@nvidia.com>
 <20221118133646.7c6421e7.alex.williamson@redhat.com>
 <Y3wtAPTqKJLxBRBg@nvidia.com>
 <20221122103456.7a97ac9b.alex.williamson@redhat.com>
 <Y30JxWOvo1oa2Y3y@nvidia.com>
 <BN9PR11MB5276B441E6C1412CFE5BBA978C0C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y35MhFBXyV4yzmF6@nvidia.com>
 <BN9PR11MB52767EC6DD8C2B81D78481028C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52767EC6DD8C2B81D78481028C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR01CA0010.prod.exchangelabs.com (2603:10b6:208:10c::23)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB7549:EE_
X-MS-Office365-Filtering-Correlation-Id: 49be2879-2559-4776-c05c-08dace1f432b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hgaT5mtBgIYMrC/EiHjSWVxOAsB6a5vyPV/DBYZqOY0SO3how7Uk0AcLJgQzkjMKbbYQ2WS99AvBiBu8acxlC4g2ik8pawDqUBabDZCaeFkr31vTcgcP8Z0Duo3qCm5UtUwnTNWUOjuhPf3smiO6oh8fzAdkL6W1Q102VOwikSDDSx+DVDbIJ2MnuWTqxnhG0RViGOVqwWvXpJ8mRbw/LCPn8kZCYlL6tBCMC1W4GZuYz2IgLRxbOSXqPJnOPHfo2N+yWfr+FoUFTwhoQIyYO6gnX34ahZMFOV18t3asSmIJTJOwumnWK3Fe3UX4TDfgOi6UltlhZ+Q0GgpPElN1bKrwHlTx9sbCf4Kofymf1V29NgKxpv9z3LciZ4X+SKvMN1+c59woCw+jc2d8ixABrnLHHTkXzoRaQZXOpYLqnN23hMS1n16FENWTjVlVH7WWaDePXHmtqnMfjl7Bq9f4tBwM0/Bvll/yDlc+KT5rxWTqP/mwg+I9kpXYKUiDOCPCVqGD4xz9pzclJixAmIBiQcWCrBfRiW9YmLSTltI1r5BxHmZQj6ezhy+aGP7F3AIkwlCv4wgWcG52ZceurU/Lgzno6CHZuLXyvBufJjZUGbVlsrfJdp1um4c5axnNxf4AL7A+sB4816EtdzsUVYvUvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199015)(316002)(6486002)(36756003)(54906003)(6916009)(83380400001)(478600001)(6506007)(6512007)(26005)(86362001)(38100700002)(186003)(2616005)(7416002)(5660300002)(4744005)(41300700001)(8936002)(2906002)(66946007)(8676002)(66556008)(4326008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kkD/cKuSib0Y3fopz6NumcGY6yiTuYsMhuXd9HIDQy9vnGCdkj0d2iW/WkXG?=
 =?us-ascii?Q?xWVofphjRLjBqgg4Vit8HlqbEqJ26kPk30rX5PeSL6EJGpVEra1FzK8biZRq?=
 =?us-ascii?Q?NsQUbhpS9OAHgrErQzgSBDsqH90SmHwyR3ss0xLUMaoMSTthCx0CXL7TClCV?=
 =?us-ascii?Q?5kIPmIWXotFIm3zUmceSymgqZHD7J5zS5pPJoPHYpeL19TgbfDgbi9BazwBh?=
 =?us-ascii?Q?QHH6Vy9vQzmtt1ra/nCeFtBevnz6wsJQiyGGxtmMjrxlCnwvThvVI7Bc+A3i?=
 =?us-ascii?Q?OFb3g6Q9kINRIw1orjK8n23pboXs6RQZfG0ou9jsV+tFiboKeX0Yr/5dJm4U?=
 =?us-ascii?Q?bCZkPlCgmLWcJ49nBMKeUSmxXB20/FXnBINptLEe5rGLwseP1WYDRnawgiXo?=
 =?us-ascii?Q?bvfOnxWHp5jTHNJHJ7DMnmBxZMD40fsEuvdVpwxalp1QezIMRzQph970BMzI?=
 =?us-ascii?Q?Q9bwW7rR+T4Gay9J+YPzTz3gA0uTm3Wk/C0L7kmPhZpWoAD6EAXR3ahi9c9j?=
 =?us-ascii?Q?ZQ5QoPYmLVuGc6QAD1H9yDo4LanIryS6GEt4U6pNJcl/toV8wpn9GgMdxXHt?=
 =?us-ascii?Q?Bx9TF1ZlNxuaKVA2Pbe0/fd1JtjDLWBe57Dbb8MpPjq2AWQnkOvNDz3/LcsY?=
 =?us-ascii?Q?TiNVIMimVd8f1ZvJa07BYTfseUFE263oFqvi4jMv5UurO6JBtnUtJ5+RDlT9?=
 =?us-ascii?Q?G6vLwhZKTU6FJHJTWYTpAdCvCzR9atVNvhu+7alzg/wrViYwNLtnmoEOL88R?=
 =?us-ascii?Q?oVQSHCkvK+gCbPrSV89yyJDJrGZ5WwN56fvelaToA0pl7ZMLC39NAiFrfk1h?=
 =?us-ascii?Q?RzkVETRgQPI6JE2Xq4l64we5XOQXAZDP9CYAWBFY3QTsXK6ZOWVPlBysvpGe?=
 =?us-ascii?Q?OI1hpOUT39ONBMEV6rmGDXlSq3nNj/yDl5HKvz/97+eaX96ZV2QtG5r3qLDu?=
 =?us-ascii?Q?a2e+/Pe99X2vSMQ1pCeQ5+lmCp2p/5FSEV1LwvgQGvcgT+OrHEeQWKNSDFfV?=
 =?us-ascii?Q?WIV482SBBOmRRuT1gRFoxAMf88AtE9av4PW7Q2uNogIHmEpSVNYLsKApfzTT?=
 =?us-ascii?Q?GeZLpp95BLMUVbF5rHmiIE5h3jaeeZ2/xqOPrL6yHqoqLBu2IhQDGkyu8OVg?=
 =?us-ascii?Q?3yNT6nqIogIFccn4AaZQYDjqSE3l7bSQovaKCONUom36rmPYgyXcoqU5Gzzo?=
 =?us-ascii?Q?BW6kvzS9FWs5SC/Oo3OZuTbA63kXeCFzf2QHdgU9HZbY6Bb2BdynvWHH/fG9?=
 =?us-ascii?Q?nFhPVEpDxJzsBWOJ1zQgvoXKlBV2PXFhgQvK5SHDuzuo05abAat9+mk2tB7P?=
 =?us-ascii?Q?3vXISiosfVBfWqcddWNeHmzmjWePPPd0x9IGb+kRVqykXAtSXvgm6AcbEpdQ?=
 =?us-ascii?Q?ZkHQOAESGslHNQwmXW2agTWNesvTUCO/E1Tktj1E6bDY4iDFvHA+lzNXty3K?=
 =?us-ascii?Q?R8w7bqDLEhNEc8hYxMM2gCAkYk364+ROIpcTWcy5l0s6fFYb0edaz96yd5vl?=
 =?us-ascii?Q?HHxhx1n0VR11XghX0jqgTR7sThD3uNxuLt/HqgZyppDr0bub3uehCOBAYfO0?=
 =?us-ascii?Q?EjyJfq5cjJXilwCQIIA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49be2879-2559-4776-c05c-08dace1f432b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 13:24:49.3688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RQMQbiBuF1aKAq9zP3NLuW1wcadVHsSM0CKVXLMCzsyQO1lEyBzjB4bOBpUO7EUg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7549
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022 at 05:30:00AM +0000, Tian, Kevin wrote:

> what'd be the practice to push other vfio apps to do such conversion?

If you are operating a custom hypervisor environment there is security
and maintenance value in minimizing the kernel code enabled.

So eg needing iommufd turned on to run qemu and vfio but also needing
vfio container & group turned on to run dpdk as part of the OVS is not
desirable compared to just updating dpdk.

Jason
