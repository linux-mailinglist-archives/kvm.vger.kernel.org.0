Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEF65AF29B
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 19:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238979AbiIFR3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 13:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238824AbiIFR2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 13:28:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EDD28E1F;
        Tue,  6 Sep 2022 10:20:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbwGQOCSIus0vzkRyLoW2z05U5T1RbuG2FURV75ArmaE8+DcnGUQK0e4gHS8ZeKpdqvpkenWKSrn/mO25yJOwSSCdymyqsvDhuKMxyqNQy1qnPyOtzHLjYDwOn1lRs7liDInn7c18Clbz2WU088hn96hpqt5hczw5KwE2NPbK9GoqGfEpOJ3gfXKOJFaQYLmD5H5+HYmWlGFDSNcyddQRSTNAoJLI1edvXrgeQTzQw3efD92OttwyabWclZ3mGZIbPvkvy+uppzKCr09NngiGu0tMgNH0DQwmGb3TX0//owMu/yubtex1utW8yeM6te6soCOxnX3b/F39kkSg9UIUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQfwqLFjqgORzyBtqQOAjaqIZGfR8U/89RmluvjoYe8=;
 b=TLs2votRiIOGY+j/gUZPe7PrmTpxuR3twDyT1A4Hh/yMeWGwoKDKThP/JWRBrPB/Kq5r2B1d8B263ihtlN8WByZCfNzls2IxP4aNpi5hA/LNFLbuYRM9cVQ0gTezhKobayWCo+IcCl0KQHbtQwt4RhwqGeXZlwxxy8t38Zjt/hQXgMPY1IKGSMFtbfvYORiuuiMMfD1XT/n8wY0l0bWKHurntXi+ujGntYc+LY0V0FKCLnR3bqqouzpO+BAgvEVm4pr1MUhHKPjwGhEGnJP3J1UbX1M11nAOgeIv/PAhCxH6+2r6LyziFERfiqWY1XOJfqfWy/WXRsmePakd4UR20g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQfwqLFjqgORzyBtqQOAjaqIZGfR8U/89RmluvjoYe8=;
 b=DSLzTZhhkLGbsXX8KlYQO8UDl+xeX+3lFWgVvMx38caJUVerOzEkmzBKjJOeTmcpIhGEx0YRZx16+gOrQfZw5/sMIBPLnjntJTXkd9EXQZtwVDEd4eU1F2Y4IYM4FvuDecGOa/gfPXfQ/FnXiNKMSlY819VWBpGdtX91uSHFFK8gQf3Rww5648q6D+JQQRQImB6Qs3VT78LNQoVXsYW/WPQK3d0Y55aSeEefkLdfXHG6sY3Y0CbrJ2+fjqk5L6xrhXxMvrgI0qlV2Ikbom91+wjVDVuISGm4llNPsk19dVSk6PfKo4TtsmC484TNRc8TRcmfYDMAGlmMNMxXi+eSuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Tue, 6 Sep
 2022 17:20:36 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 17:20:36 +0000
Date:   Tue, 6 Sep 2022 14:20:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        eric.auger@redhat.com, alex.williamson@redhat.com,
        cohuck@redhat.com, puneet.gupta@amd.com,
        song.bao.hua@hisilicon.com, mchehab+huawei@kernel.org,
        maz@kernel.org, f.fainelli@gmail.com, jeffrey.l.hugo@gmail.com,
        saravanak@google.com, Michael.Srba@seznam.cz, mani@kernel.org,
        yishaih@nvidia.com, robin.murphy@arm.com, will@kernel.org,
        joro@8bytes.org, masahiroy@kernel.org, ndesaulniers@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kvm@vger.kernel.org, okaya@kernel.org, harpreet.anand@amd.com,
        nikhil.agarwal@amd.com, michal.simek@amd.com,
        aleksandar.radovanovic@amd.com, git@amd.com
Subject: Re: [RFC PATCH v3 6/7] vfio/cdx: add support for CDX bus
Message-ID: <YxeBYiBXMLvIIRAX@nvidia.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-7-nipun.gupta@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906134801.4079497-7-nipun.gupta@amd.com>
X-ClientProxiedBy: MN2PR08CA0007.namprd08.prod.outlook.com
 (2603:10b6:208:239::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89ed2129-a727-4644-caf1-08da902c1ca5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /xzd0sDkfugs+r9QP0KHa0ypXDrP/IJliT64pt/H6Qiv2iQwppBozirmzWN5wbnhRhgrekNAwpsrBApQ/wwMkvOfUj7dhW9sKPCSi8FXV7Go94f38vaPiW9sd2gsAQuNOrKV1dQiZk5I9lFSJBWVAhfWoQMn39VqvUU9SSBPQ7KnKeqlstyPgbOgP7J2DamaJedyt/CAr+5/ubsbToH8nDjzdoAr9/6H2gc4CGl2Fmkin2MQVByoqcuFj65B8/BqtXpsSPEul14Rx1y9ZRYZaklFGuhAH9/lb7+J9YKabn83ZcOTmMP32jEBwPGlu9vAyMYSzKZjhBDYdKxXzd4P+xGqWP2ZgLOZxaS4odbF2jpp29Aqw05rI1IT2GnZ3q3VezUWBRbfVtIDhpsxvpbWcZU2zzoJojGI5JJdnTpgdpStnJ9KtnWdwGs2qybg1hEQJaObeh4WFEKjPyJi+O4VFUOOePsssL8put6KYyvaeu9TK/6x2UEMt+FUYg2wBUND2Bb2fq9KNaZ8Cf3u40La/OMmsCmOTdyjwWAEXKBZZLrNaT+G7VzJfxaUgP5aRHZRhbaOkh5WHTjEmr95m2GkF3rGPC836wqo3U1RkWNzOG1rsiTavn1WhglYpNg4ocXBVkHVFeq0CLQN0zexmT93XteMyCHgz01nPuyQVIih/cMLbh9l/QTdA5ygSIzKwbGzDr3j4JHFW82U/VR42OtsSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(86362001)(66556008)(8676002)(4326008)(66476007)(66946007)(36756003)(38100700002)(6486002)(26005)(6506007)(478600001)(41300700001)(316002)(6916009)(2906002)(186003)(4744005)(6512007)(5660300002)(8936002)(2616005)(7416002)(7406005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rw71Vy7J2/Zjotr5nDjOQGNszmEceZVo/KqcvB9LK3ecaZUiV3dOoQl/xlsR?=
 =?us-ascii?Q?x1emC6NajgOrMQ1LFHNBiMcdzZBzRQZP3owa67FeifyUCa2sI0ZRN+RBosW9?=
 =?us-ascii?Q?9TJr7NCggJQh2mCW7Ki4Ir6k1AfzgdjkCTUNubzdew2klIHR6WEnWa7DrvRi?=
 =?us-ascii?Q?6TDYTJTuqrztmGirjLVs6kAEyswEUb6p9jLqReqJ55oaOyAhLvpQtfd2B9PB?=
 =?us-ascii?Q?hT/Ou3dY9pxVnMmoEGMl5A+2tif7Ai0LuS74EI7GSA0BghwEyDfQc4dCVf+Z?=
 =?us-ascii?Q?0YItNdZoKqbiXXcU8t7nGFzI9QK4CJlLZsUOTRWFhy4WooYCkztwHGCu4iSq?=
 =?us-ascii?Q?PlnKN8DbUvgTZoRYs/9u8BSH3yLJU3U6Iakv/SQV/ZREom+I6OuyZnnh8p4y?=
 =?us-ascii?Q?BcaYj6ZVW9eIPvmG+IPS/xmhfwOsNuu/tAXuBv1DuW83fy3ge3hzXZHkdpp1?=
 =?us-ascii?Q?wQSPV8vWnWhBaqNHB40o7DY34Lr5lmvtfvp5LaIa3+X8D0m6SgPSmvJDph9R?=
 =?us-ascii?Q?Rm/rhGusrrM3RqNGps8/uiiVAvn1BpPDHJa/wlO3W8DACXrRpXqNJ6MOx368?=
 =?us-ascii?Q?RHbuWOU0GboVN2wjuBpmZkK/k0NG/HtDTniUozFhyn5dPvPFl3weDDLPUObS?=
 =?us-ascii?Q?A9EfIxVvtu52A+KEVqTFnTmAqE5martolamExQ4XDSVzVI2HJ2wYSjH4N8Pk?=
 =?us-ascii?Q?a6OPcF7/UMTyjJUGeluwt265VqLdT6L929h8j5YnUPbUy3GbLxQF6inaiax2?=
 =?us-ascii?Q?diy7m5mkFhzzjf+h+XhVf7cgNxqrQwg3iYndiSO5Ia7AvASuGnVeqrRE9ch/?=
 =?us-ascii?Q?CDYegMLUoAukWiYsMgmEWP3mUJXlVFULGVlGPj0YzdCrgjiU1v5gQDpC4pIY?=
 =?us-ascii?Q?937oUpl3IcB2I4VpAfgqUCfCQzqbncg7X2Lm1jcR9G1HfXKBqpC4Aa8LDFCr?=
 =?us-ascii?Q?DNMwgl9OFqDS/AN4X4YsaqJ0een+wKEtPFnj1OD5iwL69+EY/jgEwb0DErY0?=
 =?us-ascii?Q?iDFClKN82Ot0Q/lBRh6EPiha3l65jlkqreD5Xc9PtrQYBA3rbjeyZ8Av/mCB?=
 =?us-ascii?Q?eDhAMB/t09G3jOJsuYpBzxoBIOWAXj0Mm6Q+yCrYsB5/cSV9gKjzoeM2zFq1?=
 =?us-ascii?Q?Nm0bSiVDP6zGoLlhxI2YdFom3+ORU0NPG43ulUF7w1HocsJy0OUMh+JMPvtd?=
 =?us-ascii?Q?MZlt+N1DOZA1mCr0R65RJ2T6vVYGu6grvxzze6qsl95bundzZns7hVZGSbZI?=
 =?us-ascii?Q?/gArEYWGl7QnkFTx4EYhhWFwZf6YUXKlAX+czOBU0pU8KvdQD31L8aeq5wAK?=
 =?us-ascii?Q?mT3H2bVaKXCRaM1lQ+6ZYxzee34p8JjjvrvAHyn17rYbg21twanwSVXrUo2I?=
 =?us-ascii?Q?pq80kwtuDRXu8a9tOCeHCM3XCrMUa5qlDV/KnJ/fdDDia3oTFDMo8B0PD9Us?=
 =?us-ascii?Q?+UvqfwjdwUVI0kW9eY7SfEXdfaVG/ql5ApsXxPy3qcwosaYu7ijqjlrIkrlm?=
 =?us-ascii?Q?ct8hOZS/E0NYsHKAqzj8ENDvfxsY3sk2c5bX4GQ9NRBvmLRNXVd7EcA239KX?=
 =?us-ascii?Q?RJJENNp134QzGccS17uyZGzgkF5Zlj5HkN8yDZff?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ed2129-a727-4644-caf1-08da902c1ca5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 17:20:36.3059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MH5TaI1/+pTzM0ivWUsqtrT+IOZoS8b80USpcOC9iJuqUy9pZnRpZpeodxvniZQl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5995
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 07:18:00PM +0530, Nipun Gupta wrote:
> vfio-cdx driver enables IOCTLs for user space to query
> MMIO regions for CDX devices and mmap them. This change
> also adds support for reset of CDX devices.
> 
> This change adds the VFIO CDX driver and enables the following
> ioctls for CDX devices:
>  - VFIO_DEVICE_GET_INFO:
>  - VFIO_DEVICE_GET_REGION_INFO
>  - VFIO_DEVICE_RESET

For non-RFC posting please post VFIO separately after getting the base
bus merged.

I think you will need to get some work done to consolidate some of
this duplicated code that was cut & pasted here..

Jason
