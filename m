Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62EB5B0AE1
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 19:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIGRAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 13:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiIGRAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 13:00:50 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280AF6DF94;
        Wed,  7 Sep 2022 10:00:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D89rM5rWpE4zhHmgEVTtELZIpAvMqQITX2RWKjK7CyCNpil112x5/lT+yVyktg39yoXLOsgN9lFJbulghLoPT1fGrl9vyURZTjDC2eA7621wggN+FXgwHHRzXZoOMG3jPpHYctJVmxrkjaUaUwh2sga3kkylvRo737mw1056C+sT4QN3Y1dFs2cMIBcUjBQEpKqdNYuixQF3KLAtbAkFaGCOUmn1NEnA9+g3WevtDXkoQxTa5qLcLFQcNB2VqyZm2C4cfJm8LZdXHPLcuT7HXJfuHUbZKFA92YjQD/PG7ZOnTZ4zyssHCGa24X8JN1fjDWtOjv5qWDsB+HGDfIOB1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67mePsprQvQ5+lKyoGBOCwAN7WVSaRKEs+i5P5X54Us=;
 b=h26ZpZM0QJqDyrzcbROHKz9fyPQ7yKR1GXoXMiiIHY5bjLlfxGjKmgsT3zjJNn6SZioq0M72sE4DQUzAfzFj8cPn5c6Ovf6+AhzKdH99KS8nveJKHQSiRne9PXJC9UDnNqKVtKtHciOQV8/FLGNskf+P6HZKhZsDkN5g2QXxsTE8dfTMRFb6hcXQcojfY3gR9UID3NHbDFCL/Ed7plpv96NWNPpv/r1020Jjid8cg6TA3BgZrQq4VdzeFXrIQkUWmM4fULKQfIrh2CXp9Wp7PngadAgUsXOAPZ+KtqaYdd/YNactlnY6/SmcYG2ASLbf2w6AtH5dB1ftHmDX8myyXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67mePsprQvQ5+lKyoGBOCwAN7WVSaRKEs+i5P5X54Us=;
 b=oalH/y67bvj7FpagBgaItjghHWFE/IOjwf1FyUBL3YCJr41HfgCH/I/Gxy1E4Mt7Co/zLRiSTTTSUpSG+ezWuReMwAbsC0sLR8AaIcv+bDR2UvbB2oSXr/DzW6A+73kkEi0fBI4umhkxEcdSyb/SW9yXS1r6nJf/O6wUs3TmeWjEpAAW2/uulhM2glq2Pelu+2j2ZSrl3UoNgEMghPxX4CvTEfRs8xxnDxS1BO5NCN7KrpEh0L6oCfI/4WQKuSPzk+cWDj06C14dbbFwn2KTsNKvtYoWbZU2nCTTcx7j0+Pe0sJFpb1FJ6A3CfWHeV61QgkIsoNxJfNyG5y7bpRZZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4340.namprd12.prod.outlook.com (2603:10b6:5:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 7 Sep
 2022 17:00:47 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 17:00:47 +0000
Date:   Wed, 7 Sep 2022 14:00:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Nicolin Chen <nicolinc@nvidia.com>,
        will@kernel.org, alex.williamson@redhat.com,
        suravee.suthikulpanit@amd.com, marcan@marcan.st,
        sven@svenpeter.dev, alyssa@rosenzweig.io, robdclark@gmail.com,
        dwmw2@infradead.org, baolu.lu@linux.intel.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        orsonzhai@gmail.com, baolin.wang@linux.alibaba.com,
        zhang.lyra@gmail.com, thierry.reding@gmail.com, vdumpa@nvidia.com,
        jonathanh@nvidia.com, jean-philippe@linaro.org, cohuck@redhat.com,
        tglx@linutronix.de, shameerali.kolothum.thodi@huawei.com,
        thunder.leizhen@huawei.com, christophe.jaillet@wanadoo.fr,
        yangyingliang@huawei.com, jon@solid-run.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        kevin.tian@intel.com
Subject: Re: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <YxjOPo5FFqu2vE/g@nvidia.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com>
 <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com>
 <9f91f187-2767-13f9-68a2-a5458b888f00@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f91f187-2767-13f9-68a2-a5458b888f00@arm.com>
X-ClientProxiedBy: BL1PR13CA0357.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 168e2feb-1700-4911-17bf-08da90f28280
X-MS-TrafficTypeDiagnostic: DM6PR12MB4340:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CUlGrHzTEOVUjuZDV8dSn3PtHeEPWvp6Hf9DqaOIxtAWp63RrejBWDGoBdEtXHjAEMb0A9l5KggZUzhRS+QOR4DmUz/SQC4aIiFgOz8WKYtG9lga1kC1LGs02a3GN+4ceYOOn0WPqrKC5heAIVmUzjmefLHzRT0Bdr+QBhyabBhn4oKPTUblmnjcMEgqWpPJfFGSFCQId0IDxCb/ltYzEitNQDfSPw/U5gN5BiPFQChw9QHbPql1PghATqFnG3A9nkLQVyBOAivInSynQmFWwNJm19NdaRqUF0rqq0GeMq4uSTwtgkJgtyy7ggARRotpgLlwLg4HbIiUk39/VjrCrmmrKPRIcy+VkgIpq87Ee1IVhuzxxS5+pR3Qx0nd7TYSZKSPK6AfxwL/5qOeI00k1WZuuFzFGZhIEEaJZM8iwTZqcz0BVbz3j5J3UPA/EsmcezNMnS1Dg3ok0+6PgEU0YKtuVDI0jJXvryGlRX/3NLxjAtY79bWDvSmQYUtYGVjeaS6sz7s3l8bazXjKUr7hh1D/+UROeg2dgkytP7li6RowyDNQCc/gRzI/Jp/pX9iy+qklkth1FVXSZBW1DrjAqkzi+DR1KLWIehDVRmtZ0quDtw/5r1E6Ad1+/4ZMpP2XNOuBq8Et+2JBHMzaXoVZtoELK0ZzKyZmed3vzsAmm5quclTJUMfJg8kAhpUl5efD8eNZM4iyn3f3YwBxbWppGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(36756003)(316002)(83380400001)(5660300002)(8936002)(6916009)(54906003)(2906002)(4326008)(8676002)(7416002)(7406005)(66476007)(66556008)(66946007)(478600001)(41300700001)(26005)(6486002)(53546011)(2616005)(186003)(38100700002)(6506007)(86362001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9172dxcnzHGphmgoDTd4I40KFJfYUdupgzQHsKn7UqMLYZLH9DWXJW1RQMT7?=
 =?us-ascii?Q?0v2LBOnjyFIQJ3LadL+pUUdUBPU47iY2Va7sFu55CluA/npkcImsyiqG/Fiu?=
 =?us-ascii?Q?zdUuksewZKd7EHDxfzFsHyzw02AmlmhM7sUaWl3DdFEdhpenUl6rid8wD4+v?=
 =?us-ascii?Q?2dzaxwNmfjKuqCCL/8h4k43wuYalNLOs7hYqlB/cPAmGtHN3yUDO3N1TAhMM?=
 =?us-ascii?Q?zyYYs0dKwMAVirj8Z2BzLahFjWZvrJD7J8QbEIVf8PbUdPUXIRJd/i9Gupjy?=
 =?us-ascii?Q?c3hw6Ax/SgvEg8PSDWfNb8xsU5Ou8FWsmymno8c8gSypGTVPvONFSeaofwMx?=
 =?us-ascii?Q?QcExbtiLjKcZLeORI9korMHLCY70AEiMfE422Z5zJ4d7ZUVMAXbapNUhHZJG?=
 =?us-ascii?Q?EIA0Gu34BDxHLoY4puZzO56tQHckGmPOUQd9G7kHze+cAaCHMRniOLpes53h?=
 =?us-ascii?Q?D2Tdx3b1k783LLZ6nQdRWm32q5V2SSuC6ol89BAF7iFABYYKO7cfoHKAvQH5?=
 =?us-ascii?Q?sN9ZSSb14MwTksL44vhMG+O+bBIZ7eZlpKpdeESd+WBPo/c4eFoQLA3yGGp0?=
 =?us-ascii?Q?ZI3FBkgCMFnCGjhnsMevNXZC945FENOF0Wr9h85UFPNMiNBe2Oww/0b1ReFt?=
 =?us-ascii?Q?wVykEbKwdGrEaowFgIrAXh8TwPPgS+d5ErzW17Gsa+39mtiNxvHeSORETlIc?=
 =?us-ascii?Q?+osJMeXJxf7EoCkpcBC8nob7t7l8ZZSVNR1hvVG+grzqkvZb3AS2hL5tk+Uo?=
 =?us-ascii?Q?hvQYmZwf+UnQ6w8ogoylTsl6CvkJi/IiyAAbNH4txZNbCCm7NkbRjGyGgfru?=
 =?us-ascii?Q?P6z67/LE8Js/V5qRhc2ba25SHW38ghl5EfB+1K71LY5Waqwh520dRFOMdMlE?=
 =?us-ascii?Q?j1cEUuhNBpT9YcbKUSr33FlH1Pb8uWfkg3NAzLGzsGyJwtNXZBqh1o47s3lC?=
 =?us-ascii?Q?fQm4AqAUSE2kKHqehZ1CSQGqeuQSbImoXW/jWRtel1bhbz2NHmkuiJmG62lo?=
 =?us-ascii?Q?FDCYQyV4mUeVtBYLeY4qdqXJUN71T2172+ZTBNNRnUQPNt0vjrH4+fKr/STr?=
 =?us-ascii?Q?QSWjQznebPSPkhfwGtoZ2WfkgwT063UZ32qilJA5w3icEJO2d/IIwfz/nyt5?=
 =?us-ascii?Q?Mx+IqoghMD6FA7Ojgy5/iW+hicyocF/ZQESGDkJPz+ddM1w/C76/CuOf+j9X?=
 =?us-ascii?Q?c8ilO83CRJRkp/AbQVjtas/UfzvNPyx//A2Fo7xQlmjLI7rePenm9otFrXlg?=
 =?us-ascii?Q?213yrvxXr/PwNledRL/ehIfFYYqaE2Tyyix8TQMVM4KMtiuIBZ2ZqyYkg/gp?=
 =?us-ascii?Q?XZbEmdk36sx00ki1uxb5+AdpUl9UC9PpSbPcD/YU8qY0GxN/y1FOqiywJCkb?=
 =?us-ascii?Q?Tjt1OeJi9PQPsBWpMk+bX2Z82zTAv/NWbLmmsStFNOY5nSInFTyoXy+akH85?=
 =?us-ascii?Q?bjrqRAlyqVk47Jq65h8RnRHOuM46TI/F22dqqvipClpSr6dOXS9o+bBsfjPf?=
 =?us-ascii?Q?1pEpLeio6wLImLs8E3dATYVYSQhRfxZ68chMoITQkfXxRaCPwZxdhSzL3+Ir?=
 =?us-ascii?Q?Q/u8E3M0a3lYIol+oQt8s1V+x9OPDb0DBnP91FLk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 168e2feb-1700-4911-17bf-08da90f28280
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 17:00:47.3983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vQllXeBf3ThOaaWLFKJxHIArr2easmy8oJrdfYycivvtwNjA5ZimnyJ24etTzP7H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4340
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022 at 03:23:09PM +0100, Robin Murphy wrote:
> On 2022-09-07 14:47, Jason Gunthorpe wrote:
> > On Wed, Sep 07, 2022 at 02:41:54PM +0200, Joerg Roedel wrote:
> > > On Mon, Aug 15, 2022 at 11:14:33AM -0700, Nicolin Chen wrote:
> > > > Provide a dedicated errno from the IOMMU driver during attach that the
> > > > reason attached failed is because of domain incompatability. EMEDIUMTYPE
> > > > is chosen because it is never used within the iommu subsystem today and
> > > > evokes a sense that the 'medium' aka the domain is incompatible.
> > > 
> > > I am not a fan of re-using EMEDIUMTYPE or any other special value. What
> > > is needed here in EINVAL, but with a way to tell the caller which of the
> > > function parameters is actually invalid.
> > 
> > Using errnos to indicate the nature of failure is a well established
> > unix practice, it is why we have hundreds of error codes and don't
> > just return -EINVAL for everything.
> > 
> > What don't you like about it?
> > 
> > Would you be happier if we wrote it like
> > 
> >   #define IOMMU_EINCOMPATIBLE_DEVICE xx
> > 
> > Which tells "which of the function parameters is actually invalid" ?
> 
> FWIW, we're now very close to being able to validate dev->iommu against
> where the domain came from in core code, and so short-circuit ->attach_dev
> entirely if they don't match. 

I don't think this is a long term direction. We have systems now with
a number of SMMU blocks and we really are going to see a need that
they share the iommu_domains so we don't have unncessary overheads
from duplicated io page table memory.

So ultimately I'd expect to pass the iommu_domain to the driver and
the driver will decide if the page table memory it represents is
compatible or not. Restricting to only the same iommu instance isn't
good..

> At that point -EINVAL at the driver callback level could be assumed
> to refer to the domain argument, while anything else could be taken
> as something going unexpectedly wrong when the attach may otherwise
> have worked. I've forgotten if we actually had a valid case anywhere
> for "this is my device but even if you retry with a different domain
> it's still never going to work", but I think we wouldn't actually
> need that anyway - it should be clear enough to a caller that if
> attaching to an existing domain fails, then allocating a fresh
> domain and attaching also fails, that's the point to give up.

The point was to have clear error handling, we either have permenent
errors or 'this domain will never work with this device error'.

If we treat all error as temporary and just retry randomly it can
create a mess. For instance we might fail to attach to a perfectly
compatible domain due to ENOMEM or something and then go on to
successfully a create a new 2nd domain, just due to races.

We can certainly code the try everything then allocate scheme, it is
just much more fragile than having definitive error codes.

Jason
