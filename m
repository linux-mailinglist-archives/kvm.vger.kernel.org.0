Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1257098C6
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 15:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjESNyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 09:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjESNyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 09:54:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6E1107
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 06:54:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fovKBxI3Uugs4q2qfHs5e+ceMJ6Jkj7vkJ6CeXcxdopZBvwkDCYpRqNOo8u7BUVYp9vA5ApJ4Ic14Fry2wGlALe854FndwemW3w38Adb+et9fuFTlN25J4PRuec6f+UucB80dqAmdowO3M6bU1oTm7CUC5u2O6XSzdJIdpnoeVQPneypApwoW1t6Plu3qPgHwq0gJ5rBC9fHtPpc0KQaDmN7zL+VG76JbH1gDJ58fyd9szfBWYEyJOSwVgNDAiXs4S+uchD8vSF7IFUWRfyM3uDrKS2BMFW34RZz54jK6NoReJ9jCuAKymnhxPJRcMhmUeVVPwhW489PE0JrIbOHIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1UfBWzY/Emhnp/pmJYRQhvR7CJbaZjdQKAJ6cp2wTg=;
 b=MVWiwQ2GokwR+u8k57GgxrqRy/u7Yla19i37PGlsL3PwX3i1xsosG3THQRUwYeEz3YCL0RGAsfczOAfHULqXzvu7Vh8xAY+unEohgieRA+hPWdWCXmHyJOJ0Qn4g8trS47ftUFwXJSnurFWZrUV/bHYSXA1M4hoDiUMtzfO3VHbQDM2UI1aEs533LutdQyq8cVAU7bRk8bJlAAzaNkWyLTUlt2ScPOYjf+nKfc/BSS3daNuOgXYUROVPXyihidq1LftxMJvDBszRtr/mceNXjPIeMkVo9swBvnSswHemOuMzVVPz7PblMtgNWqwWplOxnaAVJDQgEWzSSYjs7DJCkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1UfBWzY/Emhnp/pmJYRQhvR7CJbaZjdQKAJ6cp2wTg=;
 b=tqr5bGfHMufY2NB6TOalIyxSMVkTdA/Mz1ir7NU2Quj7tEWy0A9DcW6s4o4pfIJkeXLHb88QRV1lktveMrqAP4x5dBM+Oh6zwISsbvXcBTejr9KgnrjyWDJ1LS1tSUj7mW+qZpGPGFc9gmRTSJb5ajd02bChfIMDy9Q8zAzUemxLr8j0ovl961mcFYo407xq+MO+k5XRBGcCMkbPtPd0r0bmRzvZevNjqYLPOKADEDQMHC1c6mYngvF5j3pXr4Ej5v2ZpfRx1v3Eo0IhlUhD+GX9kAwLmxP7bQTuDxUrMVJj4iYvjf2enacQGdfH4xpg71goAhBIE9meExqwMH/U8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ1PR12MB6289.namprd12.prod.outlook.com (2603:10b6:a03:458::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 13:54:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:54:14 +0000
Date:   Fri, 19 May 2023 10:54:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFCv2 15/24] iommufd: Add a flag to skip clearing of
 IOPTE dirty
Message-ID: <ZGd/he0eQtLM+mfe@nvidia.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-16-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518204650.14541-16-joao.m.martins@oracle.com>
X-ClientProxiedBy: BL0PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:2d::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ1PR12MB6289:EE_
X-MS-Office365-Filtering-Correlation-Id: 4222883f-fd0a-4636-383e-08db5870881e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vWD4K5/9vLQo1yjxdeOtYn1CI2GSgm6rH+9mVYq3zRXtlVdxIDJVyixwvtdm7/26AyzP3vZat0TQ+LdDArCSm125eFfA8hF+Qff2p4SE2jM25A+bMXfftdh5dJkWemOp/NMZ6ZcyUDpq2RryNajWvyPgByTJFeaoQUKlNJXnsSKJFH49uY6ukyKHDR3xTr0o4FdhKS+JYQ2IVegT35t4mtHiAyRS3AVXLNI8QtDNjSPKEcmvoQuRdRnor6tdzCST9FnmX/TqVi7aXS2Dz8LTBCp3ErUKMxMwy9iIWH4L52L1hpd8bjnYQikJZVKstAROsXzFOhkslnKdBY1H75OWUCDseoyV0c/2eLy4OkY8bXHZQEMpurmSvZItbKjsj3huDq5P0nIfi1J9qexRFol1z1wwZFtzAFljSrSOGqCkLsrjiIIWFW0x6t55/1SYCbF8EcnNcU+1SMYYFrxpgd5k9zLCBHvAd3CFVQP8YgBuxhWd69P2OZw5VR16HfehKq0Py3mWgCYNftlAajy4SskuZAxuBcTag9dDoJSDpnchFw5/UJkde0jn6c6iI3AaN3B0Ru3HnuXTTG7zn+xq2pU0XWZD+l8rRJbEe+JfAESdwMmJ70eTYJT5B8jPdkIQITaQXgL2hbjraF6BJb78eAm1Cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(39860400002)(346002)(136003)(451199021)(26005)(6512007)(6506007)(966005)(2616005)(83380400001)(36756003)(86362001)(186003)(38100700002)(6486002)(54906003)(7416002)(478600001)(316002)(2906002)(8936002)(4326008)(8676002)(6916009)(41300700001)(5660300002)(66476007)(66946007)(66556008)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oWu6MxGvM+SRFkSoK5hF1yQHxZNquxGaYyuSDcrKzoUG4TNn8SOA7kYevWFp?=
 =?us-ascii?Q?DVKAt9xRZMnKxhR1vRuUx6ESFPwn5ZoGQylX3WqWuin4kD1ZsOVdrcoCo0CS?=
 =?us-ascii?Q?1rt+KR7zM1nlm80DBML9V5rrQlGVe3F8vwoUKxec1tVV0cvw5NrfjRaPeTb+?=
 =?us-ascii?Q?ub78JNwPNV/DlEOQfl3/Nilt8gQGOeq945Q+IK3nW9B/pPYLKBoHGbMZBH77?=
 =?us-ascii?Q?g0ZjzYTIsry6gNLCl3SmRObcv5MWALCfinx/GhybD5npS2FhF5vuCek0GvEy?=
 =?us-ascii?Q?Rw9FGRtWpB2YF3AxAhvZlKZbEASE5szkGglC5Cu7dA5mV+fB2thV7ocII+yf?=
 =?us-ascii?Q?GdIT60M1hrmeq3uuZChQZTP12tvT8g3x3MLFTIsUcErEk9dNGfULVZ5V3hHy?=
 =?us-ascii?Q?cAaQabC+vOUtFdWZeI2tRTBLjNYGFh/3YW1oLfYj9KXKOch8FizZh3BWYXRL?=
 =?us-ascii?Q?sPAmH4/X6QX3fqxFSkRlQruIHjt67HTwV1oEEX6QHjSBNonivp7+tJNyRhco?=
 =?us-ascii?Q?+zIZ8PZKfZXDxLa3ZUtOZ3NIcaP2jZKfNz+tOw53QNNBBZvEXv04gPwYBw49?=
 =?us-ascii?Q?j1ur8ATrs4UYwTZhFkW+W5E2ppgdid53jPvn+i5oOtQabfaNZOTnIJ9OJK+l?=
 =?us-ascii?Q?T90kwUpnfZE3k21IzVslrDkTfIxsF8y2At/dBR0/86nFz2rNTVRQn3JtWbZK?=
 =?us-ascii?Q?hGmhiHHAVjOA+ymEEhVVdt8COeWBQQg7K8p7w2tyUOwVTeAzeAah8QVCvLLB?=
 =?us-ascii?Q?EOmsqPrMCwMMPaclz0wwoz7pZO7y+FLrbLy58b+TYAFjeawgQVUrQq/QRSVc?=
 =?us-ascii?Q?XnyLx70RO7EoIozAqVcNFuuz+NG4meB4xBBO/KijKlwUNQ6HwGem6dRWNyih?=
 =?us-ascii?Q?O8WC9UBXJqon7uvfn0KC11TnPy5iwgmXgFEdXom3TxBmDCnHNKdzYcKLHm5M?=
 =?us-ascii?Q?sfSKmVbX97kPtr7t6jeLJY6PospnWXWyYqR7BSAwPe9HXAHJv2K/QIONC9/C?=
 =?us-ascii?Q?u+xR1x1i6ZjNWrE22kNsj8Ud5fqai+CeDpzFwgBWQrfwhie5prPa4feurdip?=
 =?us-ascii?Q?wltP5LcghXDZbjm8XHUERs0+BGrP2XoN+0fPUvPFSFuaGwbOuqdA50tzBDhB?=
 =?us-ascii?Q?rgzNrphrmXzkTmZMRQiCpQzWTRre2t5HkU6JaqRjbAZMMqO38u8mHELkQf6/?=
 =?us-ascii?Q?24lELZWIzYFMkwiViUsDhjZ8SZh2adwzGy3g/P1SS4gXnrTxt3AZLWhlQ4SK?=
 =?us-ascii?Q?7cIUjT3o30J7qz+aaGQMl7PF9WxGHHHvyPTu6H7wdY+ll681Hx5FNVS7yuqO?=
 =?us-ascii?Q?6cgOZuQvg/7p7EnaMz1A5U4ea4VytWLL6mgBq1jFU0ZBXPao49fkhLtlDSBd?=
 =?us-ascii?Q?2eizgbwm9YoDuIJSIY/UAJ5sylhbbnlE9M3Y7Xy3XVlwZ+DxcSbM4DgxTDRK?=
 =?us-ascii?Q?rrfdBbedIw+2M/NtPhYHLZ54AeDMBi9R2GJbpowQZJFsZ+cGxDwv31g8LBSB?=
 =?us-ascii?Q?+vKMpr1rssqk+xeBUGJTKqlQehZB3pr7upukesmIMEdgfe8CLGRwgsY5qizJ?=
 =?us-ascii?Q?KgqddeTWk5d+yh1TGlsiQnaOT9dKUxiJywuPKyJ2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4222883f-fd0a-4636-383e-08db5870881e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:54:14.8083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JolaFolbkekv56f30xp7Iqt/ukKDngwui222L+DBRxX8Cwl9pyp9eY89MfuMf/cp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6289
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 18, 2023 at 09:46:41PM +0100, Joao Martins wrote:
> VFIO has an operation where you an unmap an IOVA while returning a bitmap
> with the dirty data. In reality the operation doesn't quite query the IO
> pagetables that the the PTE was dirty or not, but it marks as dirty in the
> bitmap anything that was mapped all in one operation.
> 
> In IOMMUFD this equivalent can be done in two operations by querying with
> GET_DIRTY_IOVA followed by UNMAP_IOVA. However, this would incur two TLB
> flushes given that after clearing dirty bits IOMMU implementations require
> invalidating their IOTLB, plus another invalidation needed for the UNMAP.
> To allow dirty bits to be queried faster, we add a flag
> (IOMMU_GET_DIRTY_IOVA_NO_CLEAR) that requests to not clear the dirty bits
> from the PTE (but just reading them), under the expectation that the next
> operation is the unmap. An alternative is to unmap and just perpectually
> mark as dirty as that's the same behaviour as today. So here equivalent
> functionally can be provided, and if real dirty info is required we
> amortize the cost while querying.
> 
> There's still a race against DMA where in theory the unmap of the IOVA
> (when the guest invalidates the IOTLB via emulated iommu) would race
> against the VF performing DMA on the same IOVA being invalidated which
> would be marking the PTE as dirty but losing the update in the
> unmap-related IOTLB flush. The way to actually prevent the race would be to
> write-protect the IOPTE, then query dirty bits and flush the IOTLB in the
> unmap after.  However, this remains an issue that is so far theoretically
> possible, but lacks an use case or whether the race is relevant in the
> first place that justifies such complexity.
> 
> Link:
> https://lore.kernel.org/linux-iommu/20220502185239.GR8364@nvidia.com/

I think you should clip the explanation from the email into the commit
message - eg that we are accepting to resolve this race as throwing
away the DMA and it doesn't matter if it hit physical DRAM or not, the
VM can't tell if we threw it away because the DMA was blocked or
because we failed to copy the DRAM.

Jason
