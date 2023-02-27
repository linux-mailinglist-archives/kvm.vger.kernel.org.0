Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEA66A4A38
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 19:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjB0SrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 13:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjB0SrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 13:47:16 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0E01CF67;
        Mon, 27 Feb 2023 10:47:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4ZfUhO136C8ZgnacT+fkJMXkIKNfxwnX/ysNlpHNvHk23vyMTtwn/P5+qi8HQZaQQDch5AXl1wJdhSgUsKWQo1GOQkQrYFX1rEzBTxGkZWr0M666C3IrJuw4fiRAPmAsK4rvhqu6LbujONOdfwnHzZWp9s2OpDGPsd5I6j7hBQxeDUb5v6Dd2xErqdZhsb6SOMKWw9aBFWFnRuP1ZZZ4O/aj4ZAOHpaaxEKAPdG9KvNRGIs+SoD4nszHRJciUmppfmFQNbtJROpG2rEkmpluMkjZqQHWW4f75Cu3m1ESupIdsHHMKcumHbuBaXJzb9du9XZM7xHkacmTf2GL70y7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fdFzaPdM0zwX5UJEHX4k3M4+cfWKOx0iH6TzrTtLZsE=;
 b=XIjgnrXhXgW0md7IAF68mvWhrU4XHuIQvUEZykODZp1xyNO0XGwd+W9Z5zjn9ZMDCrm3QuJuFaROJcyOe/qSttz+eX6Q2tfeLxsN2cP4iS0YXA+Q9FmpAMyJDDPIcxtqEj9F9lZOcq2hPws/EV1rBMRhooLvAO2YDuF8kwCY3LGSreadyNg0b7yVbShcsx0x5Y59Zl0U8J0fboQh4c+ksaKNxeVUoG1GZJnl723vj42QfcIDG+7GqwQTFqdnM+yFtcvwRBZtyDRZaFpzv/QwpSbZ3e0OYpTgWqYbnNrRHf0tvjgscjC2v+u3N+X+EF3UoWu4vIsNR36pGHs8EV7usQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdFzaPdM0zwX5UJEHX4k3M4+cfWKOx0iH6TzrTtLZsE=;
 b=WxtSuMJEu/hE9KG93V9qzlcn6i5bK5uFjy8qDZj/DcAjwXcaNftEZHlVSkasoNDCzI981w7kjeLgf+P86uPxec+nA24Nr227GSM6HRXfDFu1r6lcSgcxs8BsLYXzOIhMMDBfCdLpgAgIGvbmTf/AxT9rmyAlnfihOrdlJzF+0k9LjWhDML1kid0T+1AB7vV+T0OoJyxSZFD4wthXBx/WgxzkBKxSimgXrQo3eVH4Rql8EtyBblBrT+dlHnWEeJR61iXVNGM8oFN3cHQOSL0SzKFN0s5aEjR+HmKX4Xg8E/b9MiTR/gXfZyx+OfirIgUiezx0tlJh61FBZiUlNL6Zhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8263.namprd12.prod.outlook.com (2603:10b6:208:3f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Mon, 27 Feb
 2023 18:47:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:47:14 +0000
Date:   Mon, 27 Feb 2023 14:47:12 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v5 04/19] kvm/vfio: Rename kvm_vfio_group to prepare for
 accepting vfio device fd
Message-ID: <Y/z6sBgkwylhOa2Z@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-5-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-5-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR08CA0030.namprd08.prod.outlook.com
 (2603:10b6:208:239::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8263:EE_
X-MS-Office365-Filtering-Correlation-Id: a5e056f2-4e7d-439d-2afe-08db18f30ac8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g7L2izimTJZXDgaHQi0Apl+cthaERJt3xVBjKo1jnQAzteU11aM2wwQOED+gKgfuEykdzuxxqWz0SPGAfBCekM3tqaXvB3GD4KLg+Xiugw2u+Bw5H1N1VHglBbqu0mlo/auf1Z2JZuF4xrn6SpeaG2eF0YQ7K/6FqXQwuyYoZRYWrsMUh+19kJ4b0rji2kE0ERY0jA1oKHpqGIXQwqdsx1Dx4j6Q0ojcY1DgcRKVBTgGbgBsxz2Dco2xVL/x+YUO7lioRcH2nn+9N+hBZgY4P8s0ZUXNfisLVWi1tE7ljqXAqUJ9nLKxmynanqaDdh43u8rPqIm84kh6Ljr09+HgEd9xDxFL8bRFdN3fPYdtJsIrcGYdzTT7jcsOHNNuP60SuHT0o60e/OMQIg5MdPwMvhTjivVvcHDBV4fLDoEbh37wnoIhJaNkzoKoO74ZD2xWb77MqUlkNSQbsmMRvTLsHKSbAGDyjVbS9Hhy9887iGpBP5IgG3h8AjSnLzZFgjNhnzbjbNP0SDgpCisHzH4OXShKHnhv5/taBUbGBW9W/Zys3fQgNX1Jtsg3B1THzk93ggvroSfNT3NbafqG9JTg+vg3pTCtfz8IT/0lRX0+g7pzMdt88MoejsqYMqGsACxtSJ3dLueXA432eMMh1qLLVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199018)(4326008)(83380400001)(2616005)(38100700002)(8936002)(4744005)(7416002)(6512007)(41300700001)(2906002)(5660300002)(6506007)(26005)(186003)(316002)(86362001)(478600001)(6916009)(6486002)(8676002)(66946007)(66476007)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yjgsvJAji8m01HRV4rbyGAPl2z+cFMDSz0Jqu/jIrLHQBk5rIHVHeFCdVt3v?=
 =?us-ascii?Q?5Ef/KT7pqyUH8mjLuKtzj/cXMseeedqAix1sXYnMXH5ZP5I1w71fGGV+dTIC?=
 =?us-ascii?Q?iBWOBDGlWJGOvekNVIrKRbRLFL21Ej1P7n5hucO3FHuXcjsXTksmlBsVfWY4?=
 =?us-ascii?Q?Uim8gBzSPTvxRO/xq1uetfhmPQHTgd8bON1FsqoPMrubPzRe4RbS1SPr4z8B?=
 =?us-ascii?Q?BItBX+TbjjFAcVtCoiZqnMd21aUftX3UD54QO7wHPFcPAByDHaP45aTJlXnU?=
 =?us-ascii?Q?Ke55reVgxJLVmBJkExi7xhg1MnTHInMCk7xtwRaX3GMjh/tUQ3KG1AoPotGU?=
 =?us-ascii?Q?uq2tGhJpVi93AgYZdtfSK5Fro3a7TT8ZyZDiNsXxhCywZ4WEfPgWpNqnCZ7j?=
 =?us-ascii?Q?EttmfEw2Udfxl2h7XRwKLBYsmvovS4y/cveczpZGJRjt2w9bacq5Oz3fVLH9?=
 =?us-ascii?Q?V9rhsqMLzuL7bijl9P//vN0AdcflqJAHsWh4Qv4SZXvEwI8UcpqpBVATNOMg?=
 =?us-ascii?Q?pxZgz+et8ZycYyKRV0y6HE/fQwKTnhgnlny1pKJyHxw5slDyVHcE9KNvGyBG?=
 =?us-ascii?Q?zkB/F2LysOlPAjagbimYjLu5up+AhSkT2L/DgM5zHN0Ah8esHBKEMEB679b8?=
 =?us-ascii?Q?R8WVAiy4wrhPgzxpUiXGYF/+gymLZG6gkNpw/AAdBtqP09kHJO2GG1gCgKVp?=
 =?us-ascii?Q?xGwLOxY8HbNCejiv5CLbsFxC9emcn5AprG+cR/icUFAWbaUoBIpD2UVIhZQ0?=
 =?us-ascii?Q?U0zKJcqQ81nLUlYjuN1Q0E8A0ui/hpIkD+k+UAx7r0mWk45K+gxa47caP5oE?=
 =?us-ascii?Q?RmoGOGW0uZVy7uUm37j7BSpbZsRFXlswe+ZulmYEJ9kUaxTM7upTxzBjT59b?=
 =?us-ascii?Q?S/4XTXduYZ9LtcAnbZLBwhqo4BsAladxnXZzxDTWhz1gBxffQ/PFMyf+t/kj?=
 =?us-ascii?Q?i3ca5gTK9vZf6UPJKCBlSJ3fTfTZuxTpOQZr7AJdu+DtAUpajEfPrdZC1gHe?=
 =?us-ascii?Q?rundgR1aayx7jtdELEuOk+wDJMoHZzI18s1f5cs3tFTfvsJx4AfPEbpnr2Fj?=
 =?us-ascii?Q?EUNoTty4hHIBMSpgDd86rT+MF6TuOWTuUF7am7EQd6BenfNBSd8kPIC5zW3i?=
 =?us-ascii?Q?kT9YXAOUEmTHvDXoDcFUSxT5u6EXygZfZT9Bp+h52tLzdlIK69vW3Cf5YbC3?=
 =?us-ascii?Q?h93J8M44Z674xMraQNBUImdBt/AQkbB4F5M1jsbeqEzZtMVUCa+/OrCsXACc?=
 =?us-ascii?Q?aOztAtEjokmUH+URiLkNpxZ3ZuD8YJdYu4IDlmX003UnJ22qSgqsZYgqA73O?=
 =?us-ascii?Q?I0A4PAQqAFJXz9c8E4i6VIc6cg3J7R50lv/iWA5bGpjABCrmW6MPz98YwHZH?=
 =?us-ascii?Q?GbjHj/jzp2fbgWMk6NzlUo+qLpD56IiHpjVJ0W9FuQQyJiGWebhH4XenuS+/?=
 =?us-ascii?Q?QGmEaWHzMAs01udHyubzuT9AcMDLIHIwm40odEk1JPk2Q14MonjqaRmIbKLS?=
 =?us-ascii?Q?JrOLHrmDKCUGPOcviOPfohsJfT1L886E3qer4KJLmBC3pUr/6vDhoRl11TXH?=
 =?us-ascii?Q?I8szUyMqUEFy04G4k7yv6BYi1zyh3Cb0ED+anYV+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5e056f2-4e7d-439d-2afe-08db18f30ac8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:47:14.1941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h44H/fUhyNHx0Vvg0j90U4p1KHqda6xqFqZgazn9wnSezCIFc/EFShw1wA4eqJF0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8263
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:20AM -0800, Yi Liu wrote:
> Meanwhile, rename related helpers. No functional change is intended.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  virt/kvm/vfio.c | 115 ++++++++++++++++++++++++------------------------
>  1 file changed, 58 insertions(+), 57 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
