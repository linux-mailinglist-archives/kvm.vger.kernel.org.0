Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634DB73E4E5
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjFZQYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjFZQYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:24:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C642135;
        Mon, 26 Jun 2023 09:23:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfPso+YU91VDXkorR0hNeosx0U7UHoqhDHAycwjCQZ8sayxGJAw4cU0714Ci7vcHhBTuWhV4B6fF5cDBlvrcMuwmvIQLFiI+b8LkzHun7hGOVvDpJhENTtuxXuXKVJ/kZkk3ThefeOU6rcrzS2UtLM4BvNo5c1ObNM10TtLEbMW69mJsf8N2qx95zZvttSV6imH2FGGENhr+iLYxj7S0l9YrMbUel/z871FfOXBsfXJsBa2MDpiQz8S92ZDmhSzvF7HDhVfeTfez5gLevo+V3hf4eStqoYpbFdLULv3MNcLQGFL/v+TaIPcGMVjc3t/wssv5w2M9n03y7fy/PMkwtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j30aBMAcZxJzYSgJm+44A+2jO2EztXvfs0/DogpcmGA=;
 b=T73EgjhUbseD/6MkbFIi6jtJOW0oD4IgvxKaqZ+zcZz3p6fb1Z0e6eOHX8RC84RBeA4sSEoafckunBfczSWebxiO359NOwrccS3ERz8vg9DskISAiIHhEKuq8GOfynUkIkCOx7LlyOYITbWsLPafJbyXb4K3h0qF/0+w10F7QQo0DfH/YNO+lVpoMJpFq1cxQjguFkl83SP1yBoKu7UzVkkmTgMvEqB5uZ8/S0p7Mp3C1NWJglyeW7Iiz1+ZOC8G7xR+n8GECDrCbWLWXZ+72gjfMDqTYaow3G6iqvaMsSsDKoSbv/15oWuOHOtwcmIajwDPSqLdaYNFX4IUw3IEgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j30aBMAcZxJzYSgJm+44A+2jO2EztXvfs0/DogpcmGA=;
 b=pr1MyVnMj1sQb+Tj3HCVsnJdJ9Wkd5tz8hjqA6D+99c2JoBFBj8U4qb8IAswbo/DFJPbwekGy9Zk+uyf8yVX80IT1MRyQ56nx0iiiJZFSjdqtjg9W29a1pYr6FZlTNmq5IDLY4hNjLzPLxf2ZQz0HBOW3wJtdPTYg5KIKjCsLN/rPu/W3LR9KUhwcniRrOjQZ5svhgY+xGQnHDsAYGxdaC7DIv2IPWVtPHQKvIntBGQcL+BvnBxQsJ2kOO9mCPYcKYtWn0n55QUqht2f4P5XVp8pNDIijZiGMqTm51muFcmhaZoA6drnO0rIw0hYfEu4yqfQmDoxNuJuYAOO4vc0/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6749.namprd12.prod.outlook.com (2603:10b6:806:255::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Mon, 26 Jun
 2023 16:23:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Mon, 26 Jun 2023
 16:23:09 +0000
Date:   Mon, 26 Jun 2023 13:23:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZJm7a1BpeLmQQ5Mj@nvidia.com>
References: <20230622030720.19652-1-ankita@nvidia.com>
 <ZJWdbbNESp1+6GVN@nvidia.com>
 <20230626100629.3c318922.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626100629.3c318922.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6749:EE_
X-MS-Office365-Filtering-Correlation-Id: c60d3d96-6572-49c8-9de9-08db7661a11c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 23jXYxiN3it1/RUbzOS6+DwC42UDjqY01tcxpABMUVadPLxjRmiie1og+wXs+nIdALBuYE2qkWuDVFfjts1znmgHU2ZddMHDrqeBNvPpIzMqgPJ6bCwB41/AsUyvbjVcwOONt835cvha2FwQfBw4eHEAi387wx3utPzRAoqoRdrFwJNo6io9xAJlMDktSQyC7nLeG0FPAWGd/0lhFBqK+wO5KtEPPKK7nxHjzToVy9tjJdtZQmFz4CAHY6Z5go3aZEpc4u5qtuEFMotHWArz2Z92bpkTL/nnKJ+rygTRRJl1n6sRv7nKSRoqCU6sV5Q/xFKwgbH/C5ZIB68UM6g1/vi2ENdiZb16iY8UTTDge+iENDxuCXjYAYRA2/1kq/0patmYxHIz0URvqsW1s9fUJ9LvYeRbW7uzPR7YM+4q/uwH4HTqR168vULW6BgyPlS0jgwqimpMx12CERxUk9CDnnmo3JEdRAKEzJ0ef8MfJGJwEddcP/nSlx8UtshXo+/p4JupmVVeLFT84mlftxzo/Rb677MDb5SXhuFfV5AoQGFV0P9eWsdnQc/Tvz7LZRsp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199021)(86362001)(38100700002)(36756003)(41300700001)(6486002)(66476007)(4326008)(316002)(66946007)(66556008)(2616005)(8676002)(6512007)(6506007)(186003)(8936002)(6916009)(26005)(2906002)(4744005)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vrHCWhM+9ZxIplgL2we/T6vnvSPwNxjRXbgcbhAtrqQEBj3KqfiWhy9VfHpW?=
 =?us-ascii?Q?zsjO6k+4jGovT6P244D8cZH+32Or3C6+8QqbTxwwexoRTfycHfj4nKgcatlp?=
 =?us-ascii?Q?XIhkVCjhKvyVz6LrSveBdwEVV6gxdTJaEsttFqey5cx3Y1BbLwcOE3JphbfO?=
 =?us-ascii?Q?hCaiBHyHjjtXhkOeqEOrQ2VaEdXViOjWn5aoiKeibLy2efgecpgDKd7MSPYd?=
 =?us-ascii?Q?8ro/+pyeJFC1AFxiuDCyZXclXKkU9cM8jN1ab6f6L2n0bETSoh9HmlhhrLi2?=
 =?us-ascii?Q?OxkL8fHEPZPcSguFTOBVh6hqRaC8maJGQ0xGFzNI4rgDS9i2cB2gUM0sGdV5?=
 =?us-ascii?Q?LJ3Gmj9+M3mNBr2smQm6BTCBm7r8+Jy3SAOHN/Gcb2QJhkrPBzl7tdmAdsgL?=
 =?us-ascii?Q?Qd76GpcZXPDZ3AyuZYREecndWtjCavuefB2QeCAP9b7+kikk/lQFcwsU3I0u?=
 =?us-ascii?Q?TbQDkCdr6Pq6uo9PwseGZj6OlTIPfd/13kgt8t2/2dtBrWtRcsAKAbezHitP?=
 =?us-ascii?Q?emFC5HJDhmfl5jkkP0RqojeF1wtq1fjvjpQ8szWKqx7rYFBJhE/Ku9O/1yyc?=
 =?us-ascii?Q?UKYfU8/jwbddo1QAN769+AmYJ1mKWP951K9DuhS6OkXd4xKfpGed1NH2/HjO?=
 =?us-ascii?Q?bKItTAe15AisT0sKe1P2O6NMqiaRGNgjk077Vf6o4RC8DegeyyyX3PEV5NrB?=
 =?us-ascii?Q?lm6+HwvlHD4hWRJKcdkyFpp0T1sXBjPy04kkAVw0/C8DDspPZCvCY5DVHQQG?=
 =?us-ascii?Q?yLlfGiFvtdOGSi3Sw6E5oXF9L64WF9lsu9mUpUr2eybe8rbCpkA3TEZ8Uann?=
 =?us-ascii?Q?YNBeBAXf82Q0kUPI59nHHoH4O9Z1e621v8y9PeA0VEw1wH749jnzOm7MZg+g?=
 =?us-ascii?Q?TZn70AIc/a6TEhLamLSbz/1hvAU3Cmz1bYhP4lrXgODWxNP0xcYrowg7/lk3?=
 =?us-ascii?Q?6Dydlza+EHGpkHv88U4RPyhRtzORu52yuDJO+ghLsshn75me8h4uT7yaic8X?=
 =?us-ascii?Q?ULvf5UJQkMfUxTgQGFDee/UztJq332fMmG6VHzyaXcq38T4+RgrRoI0Shxs6?=
 =?us-ascii?Q?b6J52o3jTvGH1bSXf4xoSecqX+a+tELBZOsQMBLPzb0z1cAQvC2TB06pRBHj?=
 =?us-ascii?Q?EFpuuE2sNNgs2aWyMtUGyZg/Uoin0Tktv0YW55kxiIcB7UtTfpdFUWGmiotZ?=
 =?us-ascii?Q?Qn8h6MEnnXgT+xLUhBAeE66h9gvlEnzhIIDp6ZpmLo4O0buyL+fE5cDe4xZO?=
 =?us-ascii?Q?LiB7OPuQvvbXgDh4xk6q1iHefyTJ7GwbRmHM2EFvSiVJEWYuhF1e7jd2cHH3?=
 =?us-ascii?Q?5GWYLJa4s1wyKtIPiVXkZMbGLogcMHXIj2hVNUbyEvrGjvIkPDhqH4mBNSaz?=
 =?us-ascii?Q?rWQyFQ0p1jOPcG9H4QWgiWW2ecwDZZ9FZDdiAjYLVga/aR/6DB8rpkGERL32?=
 =?us-ascii?Q?8iNbA/YAqEJau+f0u5zctm4Ls0Y+83eqY/F/hvI6t3capz4zo9yUrkNyRRA4?=
 =?us-ascii?Q?7Z5A+FIr6xFpLJLPZc56knkt7eTEtD3Eb9sjyw2+6xD8Q1jL4xazhsHvzxM2?=
 =?us-ascii?Q?owIDYgcr/dbOibGTiUjiUade0jxh+UGXwPV3RolD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c60d3d96-6572-49c8-9de9-08db7661a11c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 16:23:09.1590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7iPeZ9bh+fXdEKXIOvxHNbFv8p4qgSX2E2r1cF+TuVQbHs8Nk4lEsS7cUypeBnO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6749
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023 at 10:06:29AM -0600, Alex Williamson wrote:
> On Fri, 23 Jun 2023 10:26:05 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Jun 21, 2023 at 08:07:20PM -0700, ankita@nvidia.com wrote:
> > > +			if (caps.size) {
> > > +				info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> > > +				if (info.argsz < sizeof(info) + caps.size) {
> > > +					info.argsz = sizeof(info) + caps.size;
> > > +					info.cap_offset = 0;  
> > 
> > Shouldn't this be an error if we can't fit the caps into the response?
> > Silently discarding the caps seems wrong..
> 
> It's required for backwards compatibility.  If a userspace doesn't
> support the info ioctl capabilities chain, it gets the basic
> information successfully, while an enlightened userspace makes use of
> the flags to know that a capability chain is available but unreported
> due to an insufficient buffer size, with the required size being
> provided in the return structure.

Hum, maybe this part should be pushed into the cap helpers..

Jason
