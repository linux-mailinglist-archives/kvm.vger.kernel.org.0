Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB148514934
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 14:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359098AbiD2M1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 08:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359107AbiD2M1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 08:27:14 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ECEC8BF5
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 05:23:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exbGd1Gw6XGY9KKkhbVz1IK16f6ALHJCGerkeUgAwi8rqt8i3kCZ6Ho1fRqgmmpdfqfT+u3y0n8DFTJ4XU9ig7Cz9V7UoYP8gZmi88o3ytNdeAb8jQ9sn4YJy3SkOcKTohlErFb8dd9sItxAgG3zwsT/k2tiHxVa2LfiQJbjeZnwfomMY6TPHeZIAqVo51ppSaxt05CegRMtyFVaqG5p00L/xLvlzkSCm+6l3QNRLHjX9qeHCS4LwGoaWsrbYnGZe3y8m9LdLzytyrAQ96PpHSh2A6wtU1juRVxRGgm7t6kY4FJ8g3ankZN/UmO2b1lyqorphguqn88ZT3z/tJO0uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=532xII3xXD14iEmVoW4YfRSqk2SnTRrnV+GeOM7yLV4=;
 b=BSS+a139qazOIfKCMMt9K8v0wymkr2Lbne/n1h8ozIo98hnCsEgwuFrZIkPf/CzdTWaARbvCwynQ7WsKkZXWOajqcq40Q05OfLq7Vg+ymuUwHCGXO0rJLmvARx17VvL/TQJZQA9Q3/ESSnPD03A2d4GIfX8JvAnzGnyvt6Kn4CqZCwDL62zYg+VPKIOyIc61BBkJGKAUM1lGW4cfrKZlejvCP2UkZ7CmmgL/OILdS1L9+sIZqdNNu25Ns8N+778MzfBGgjZKRjX9tK9yBAfdSFpaDGqb3gcsxnkJnk+ta5NLRDmsqau0SptfDR7e4PleMTnGwmC9bE4OFeWE8HhDCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=532xII3xXD14iEmVoW4YfRSqk2SnTRrnV+GeOM7yLV4=;
 b=ETgWPrn1o6tQI3SMPF6mOYr5v8QpXhLNYPO1QX0296EiPnkl8TtdxL0ncIp4huzuCy7weMkTZcckItRZTkgnqBPuoNrhRgVMPmRqG10XNUuQxFqPawKTbbQc8fVjBl8BxEc6D+hxk02Tm4sckZ81lA79WWtzsKQG9cY7XH7PnRj0C/h0ASkMPfSUIqWdnY3P+AjVqC81B9W1B/NHLMaTA3tVc32kQlC5FdRRmTo7/rSAqM0wHF+kdAtsOVq4YrssqiElO3DpOPkNldZ9QEcl3KToVq/oOav+WnIGwhJ8R00qyBjG6Rsyy8VANAMCI4P1rIIakPnQSawc+ts/M/apyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB3699.namprd12.prod.outlook.com (2603:10b6:a03:195::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Fri, 29 Apr
 2022 12:23:54 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 12:23:54 +0000
Date:   Fri, 29 Apr 2022 09:23:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
Message-ID: <20220429122352.GU8364@nvidia.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-16-joao.m.martins@oracle.com>
 <BN9PR11MB5276AEDA199F2BC7F13035B98CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f37924f3-ee44-4579-e4e2-251bb0557bfc@oracle.com>
 <a0331f20-9cf4-708e-a30d-6198dadd1b23@arm.com>
 <e1c92dad-c672-51c6-5acc-1a50218347ff@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1c92dad-c672-51c6-5acc-1a50218347ff@oracle.com>
X-ClientProxiedBy: MN2PR01CA0005.prod.exchangelabs.com (2603:10b6:208:10c::18)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1eab137-9972-4315-c43d-08da29db2034
X-MS-TrafficTypeDiagnostic: BY5PR12MB3699:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3699C4CD66D707DD9666869EC2FC9@BY5PR12MB3699.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WGedcsO5tBoe3ZpoeX0KgkN8/EjP8ZpZX9FQnxsIiXLPwUqDI67VvNS2qL4zwbeYGWHNe5f0/RIRmPctM3difGDrjm1uky+3A63UFPwGoTD4foniL1cYNMpZmnzudj+3hHYPiqUEjIX0Ah7mFDmA+h/d7x5xQW82kTEnrZ/XPBAZ7aqB16vXTmTNDitMjSzTEJ0SsMt0qiTI6g6BxFFsJCl/zgvZI9iA9d1shXCtQTkmpc21ymBmcgsTS+vMVkmjOhrhAPWDvfiS2dvxZTnCu+mk6/24tFb0nE2oWMGeLAKfg5RHDqum/YN9NkXbwzN7I4trDyWomIT2VcgKEesVGn+AA7lC1N0+3feJF9HqRMjT2m3y3SSzjxb0V3pl447ui/Wg8+MycJo6pLHeqgvkGINiXbWb/GedHynTeWudkXYdv0Y+qrbdMh2rnWW8IArPbZvJp9Xb0ObbrjmtHS4M5SdjsUWM7wTyDnXxuCNLgaxrrv+JU45c6PICkKSZMCOpHWlFznfaNG+yxUPYh4F5ttE9rooxiP3C1/aqP59+xFeZT12yADzWfuuClvEAmpyOc2y1cWFc2XhF0rPWd7PRZf3pj5cbwq1v9ktE1awK2gJ7PGpObPBGY7CP4ApRrfbaz4ewBbzBHN33RRx5Pm31W4eYqfjDBx9Cd59cQBqtFGLTO60jl5d6VGsCMduDTpbz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(1076003)(4744005)(7416002)(186003)(2616005)(66946007)(66556008)(86362001)(5660300002)(2906002)(4326008)(8676002)(66476007)(6506007)(6486002)(26005)(6512007)(33656002)(508600001)(38100700002)(54906003)(6916009)(36756003)(316002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vZHoI1wDFND6L57ekLsycBaTHnOBP13TPm9ktfzdjbIDhyMLB0ENMlQhgjmk?=
 =?us-ascii?Q?U6XIoqCvCVLR/5CVTyVsHEJcpuy+m4OvWFey6EfPmHDk2ivu/OQMYf59c7pZ?=
 =?us-ascii?Q?1LvewAASJ2g5Qt2rDjgugsv4EkDbMxmHUMUu7GYEtd91zl9GzXvgz3UInHYv?=
 =?us-ascii?Q?E9HJq7cHG2JD0p42h0MIp925r+htMEKYIOdvdd718LPtI033XPK4aftyqwHz?=
 =?us-ascii?Q?DgM4x6A2iuJAg1tmwWm1T8YUWomO7cCspsxjMXzHjP0y88Hh7b5mWFfXX3lm?=
 =?us-ascii?Q?JAT5yzYvAp2yadgP1aGVCD6MfvQT0cVtcjvwKWozJOO/uw018/WXBJ4B602W?=
 =?us-ascii?Q?b5WsllH3Pmb8GSr0EgK5RPMZ/r80rEPBvobmpvQcH9Hf68/1mDhni/xGGVK4?=
 =?us-ascii?Q?3xHAWu0C+hdQvKbE3gQNeMqI+nnKnz1dAtfxXppM/ZsArgCl0CzJW+TCDM4X?=
 =?us-ascii?Q?S4nYyXohEwTY1EaXGlwEmQEGwoEAASjrLbLR8SOagHSZitzscp96s3AJp96j?=
 =?us-ascii?Q?Ra+dVIpHHPxnONdxCHV+GJ+2XUx7u1yZwfX2bkD6jNeTQggUP5IHk4d3zCej?=
 =?us-ascii?Q?rkJz0OEfvb731MWBgYyKEcy5NxBsp6/43JEcuS2kpN4TVC9dqK9p/7fhA0f7?=
 =?us-ascii?Q?hIpnY6RfRUaizMz35rSNRdRSERLnOCo3FC5MGHVGLGOjTrj4rgU5UYnnSPlL?=
 =?us-ascii?Q?F0JRpi46yiqpPRe73YBbwxMagbMVFEbCRlNoDpLZzlmsGDMyPFApTdcffW2L?=
 =?us-ascii?Q?eSRZiykI5bwJWpv6DYRZAer8T4TsuAPDb4KMEGsU2beFtIM0c7+9GT+UxShZ?=
 =?us-ascii?Q?q+13b3yamrgc2lIJP8jS7SK3uftS3xeAmqQU6sXK6VpVCt74KmHc2GT2cgQA?=
 =?us-ascii?Q?xnCEPbuYwss1CM+hTlFWtTV57y9MJX+Mz2fZyrLC2r45DwrHrEcKuv3kgca0?=
 =?us-ascii?Q?0bePaV34hvVgkBhgGtC30XS+DaMpVLUs2xyWle1kXjwTVo3F3DUVIGWi9hDu?=
 =?us-ascii?Q?i9iGhVl9KGjC9+j+lwkkVLO/dog7mrn+V2o7IPomYppXfOf+HKWECIkE5twP?=
 =?us-ascii?Q?p82ll7Rnpo8M3475mB+J3YKwIuw7Aaf9cjZxi7M/jscnEL6eFy8Ip984O7lX?=
 =?us-ascii?Q?vv0KsPXXdAhxO79II9oxaZKVRr6dSjfeA+P646U5O8On/4G5WU1BmABpSz97?=
 =?us-ascii?Q?a8BzZoxYbDvUhym2NciUw1Mu7etF/YA70sp/VA4Sma0xHSkTBs1bjXWMpLF5?=
 =?us-ascii?Q?uxib4LdfZvqXs7VZBUP0d+xzNg14a5dVTT29Xrmp3AVpEK3JT/Znp8ijDRaA?=
 =?us-ascii?Q?v5KMnFBV94dbfn0ulilqPh2D/QSkTuvOasK6wJ4BaF0kFsnXNG/sNTjCawFW?=
 =?us-ascii?Q?uFegsXf9jVThsMwBP3VlFL37qD9KU6srj62sWRviTadCIGbdMRKXMHbA5JAT?=
 =?us-ascii?Q?cOI6YQy+AMhkkMiItPaKmkU24mpavHyeXsg5JQbKU8ZA7Mm8UpzuVbV6x6tT?=
 =?us-ascii?Q?kqnI/BSMBLVxgK8+bArbIxGWQ1fIj0jhCp0bfTwr/P1cLe+2EbQpeISk4BHl?=
 =?us-ascii?Q?R6I6AHicx962ku6wnsZM0AaBpLEXDzvVxVAZYwgdyHjq9258Brgk0EkSY+UU?=
 =?us-ascii?Q?0QZz7qF0WUniEvLN90yZ2hnl3utsjKSvjqhJ+kHaxLdVk4fxR0xMKb/SwFTO?=
 =?us-ascii?Q?D0dO8g6uohY6XeAASLcp8Kn6MW4uoi+wOkY3pHnvmiHH8uCoCSCgadowHG/T?=
 =?us-ascii?Q?xWEMSPiU9A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1eab137-9972-4315-c43d-08da29db2034
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 12:23:54.2502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9VP8dDwAjD+EdzBKjzmaKY/luzxwWL6Z1n3JkDLQ7RAz623S//NY/hfbcepHHbT/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3699
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 01:06:06PM +0100, Joao Martins wrote:

> > TBH I'd be inclined to just enable DBM unconditionally in 
> > arm_smmu_domain_finalise() if the SMMU supports it. Trying to toggle it 
> > dynamically (especially on a live domain) seems more trouble that it's 
> > worth.
> 
> Hmmm, but then it would strip userland/VMM from any sort of control (contrary
> to what we can do on the CPU/KVM side). e.g. the first time you do
> GET_DIRTY_IOVA it would return all dirtied IOVAs since the beginning
> of guest time, as opposed to those only after you enabled dirty-tracking.

It just means that on SMMU the start tracking op clears all the dirty
bits.

I also suppose you'd also want to install the IOPTEs as dirty to
avoid a performance regression writing out new dirties for cases where
we don't dirty track? And then the start tracking op will switch this
so map creates non-dirty IOPTEs?

Jason
