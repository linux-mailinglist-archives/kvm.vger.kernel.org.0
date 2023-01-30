Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECD0680F13
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 14:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbjA3Ndb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 08:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235814AbjA3Nd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 08:33:29 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E649A10243;
        Mon, 30 Jan 2023 05:33:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSTNRBviEZ3lssLD3bMuswt496lPBoP4yk4AOtiWWrY13lXzQ7cHr6dUo+OcCAGPDMpRo9fUZSaEigHKZrVH5sGh2wt9zPrmZDlEbB95I6A1VkvYdbxGG/oqYTYUVSJGITTNhWb9jrwQgY+Ul3WsL+g3PD/tQwDROpetsOnkEL9fTUJw68oQEAGSiyGGpPrREzL627/WFdCjWPtJXelW51ZpHBRJl7UlsX7WTYXW+HIUCw4Sl6rS9TjHuDdVZNOxq/XAl0YNwjnWL1H0qJ0qgKJu1Srxe2KfLEldk7fHDSxuFTLoLFrH7iK2oVCmB21atm8qV+kYiYC0cFCLMU0wPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAhhV107UB0VuF+f/fGJNsIJGFV+V2cjcq1Mwehnpb0=;
 b=EKKhIHQnWGAWxwv34NLZIxnPNG6nLpfaP/kbH9JRGnAgMpsxG12Ez8DVyQAvmYgpRnnh1oSxzYaWbKtO4agWXo9z4BvE/DhuL3CzgsCfdWxdlMK3cJLiVa3kY836qzujOUOBYBU0ltzuJ4lyibB1f3c79ph2tOMgPUpM431n12ubj40nOf3DyrkoMHt9ngfl0DhTb5EX1t7JFwy93FgH4Kgr6/hPbnyzddgse/9ff3XD6KTlXw49q/eGaaeKNma1QOgt4cyfhMUrU4rsLvLLMgQ9+PONXqd0HXb0/M0M2VXBEzNWIrcCkJMW6WSDmFnuEsioeWb/BLhR1a6vVmd9IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAhhV107UB0VuF+f/fGJNsIJGFV+V2cjcq1Mwehnpb0=;
 b=KRgEbvN5YMX3eiMFMoF4xzNtI1Tzvq1MkEPEHVVHMU+MOii94mFTAq/KSv623rXKOpZH7WP5xv9MJ3kZ+D0IiPy39W7BpqMLRcZ4dPUtCClSHbAPZQOlA82V0cdsn38qxhssMUAEGMybjsVsiBTBxBt4TsUUwyXkmpd+/u0fxfOHq6KzEKzo8F9yyVKt4Y7U5bwQXnOh+sazadINF1i7zYuLc7wmzKxR1aTzyqERnfFMToWsVg6AcofjqBkSdiomoGJlTYmu4dtb23+/X1M2iVuME9Ny5aUA7sxXJxDz4Y76dVOs4kw9+8L3GcJOSmT9QYPxcg86/N3xBjSD/pIiLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB5798.namprd12.prod.outlook.com (2603:10b6:408:17a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 13:33:27 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6043.033; Mon, 30 Jan 2023
 13:33:26 +0000
Date:   Mon, 30 Jan 2023 09:33:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "agross@kernel.org" <agross@kernel.org>,
        "andersson@kernel.org" <andersson@kernel.org>,
        "konrad.dybcio@linaro.org" <konrad.dybcio@linaro.org>,
        "yong.wu@mediatek.com" <yong.wu@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/4] iommu: Add a broken_unmanaged_domain flag in
 iommu_ops
Message-ID: <Y9fHJSTIP6zXAStX@nvidia.com>
References: <cover.1674849118.git.nicolinc@nvidia.com>
 <0875479d24a53670e17db8a11945664a6bb4a25b.1674849118.git.nicolinc@nvidia.com>
 <dfad6d75-6f4d-99ef-1c6a-4bf397dcaa13@arm.com>
 <Y9RkG2dejdXptUTB@nvidia.com>
 <BN9PR11MB5276C9BDCCA7FB295C25BC738CD29@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276C9BDCCA7FB295C25BC738CD29@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:208:36e::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB5798:EE_
X-MS-Office365-Filtering-Correlation-Id: 708418db-0ec4-4df0-0723-08db02c6913b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9MBjK1/eh6UghslJ1smQ+6bTcxDHJa709skUAgG0C89Uoj/lkoC/n0mBzphTzeMdQ0RboeCz3CwEUJmWJn5zy4bvBlSCKM5asRIzSJt+lvsbZVdpJbHL8QOOF7khebDAJk/1ljFzYsDzTccXLRUv+aX+nTggAFKV/zY0oO08OR0m7fya7tUCqFFu7YyFkV7yI0xUp5j6ec76O7XmwwyVP029ZQlwUugOq3FmOb/bsMmdWg79QOMOKnSYJN0EcEizTM0Z1u3FPPSdgWE3U6rmDk9ikJhKP9S/rvdoaly6+ynJYQZg4276n7jGAdatEH9oCVYMWq0YJEX2N8RcbDjdGwhCQDaewGKsWVHAVeeHsfx/bS/ETT/Nn/HgqCsp8POHSnaquJ1/3i0S9xfjgxXKtxqhBRq7JiDS//9Ju2ZOuHYCTIlbuBLsZKWUPo9ZFPQHjpKQ3h3ZcKUxD2rigcKsL1SCfJBDvPgcDgzFZh59fzpifS+A2M/kE9rLV7YS7G/ny7TaU2ZO2uXxzAGs/r6LuMWal9jdBCAiNwX3MsuSnkZz6xkeOA5aJ6fK1HhiL6oZae6uS4AHsSYHCGGB1qTk+R8ZwB8HSdM4RP6dIsA0X9DkkdXFrN+iPs5ysiT31foyHBemrAscWy7FBT4p0sBnBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199018)(83380400001)(7416002)(4744005)(86362001)(2616005)(38100700002)(2906002)(36756003)(6506007)(6512007)(26005)(186003)(478600001)(6486002)(8676002)(6916009)(8936002)(66476007)(41300700001)(4326008)(66556008)(54906003)(5660300002)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3hcGwMgHWQU8pSEuUfzxLqe86woHr7bO7HXzYWcbCM4RHq17p1N3WEYSeo2J?=
 =?us-ascii?Q?c+oPphXJv/UJWPQhMT/uNold8T/+WbE+SgCYWdeE9X5uzf4gXYj9gVlmApfR?=
 =?us-ascii?Q?9KO3l4eTMUpcq6/tVXj6HkF82nPadraaePwK5iOzMTInuQIGyCkA6l3VrlJn?=
 =?us-ascii?Q?gC5jYqgXIjbDzOQdN4CwZcaOXZB6V4x9une7FGBkPqkvkEF3+anoWl3GIm7z?=
 =?us-ascii?Q?zC7bjDM5zu7j/EAT3/VEOALawr8WbuaAJYKSv5HlHXcUYblW8D9DPkxZucuE?=
 =?us-ascii?Q?tZiKmQrFNnA3Qqp1zL+EKscf44u5IvfOwJIHUBP3MhE95ibWbPLI7/73ystH?=
 =?us-ascii?Q?mltSeRrJQjQFWNoK40B3m4ZO7IB4X02+BhEogS+JcWidZA8s7pLRHAT1u3x/?=
 =?us-ascii?Q?oOhvBrvagyiyzdm98ZgbKgMRio1euYnWLUnuDTbzS+tnjzZW1J2dzxad3Xi6?=
 =?us-ascii?Q?yrZqEpQ1pMXO3tDWWhnfFG0bA7s7CbVbQE7oSy1yZHbj5BSFwbR++MBZcqun?=
 =?us-ascii?Q?VYnQN8KTyqxq9nX9CilB1og68BzG6MDjqtJrKEdcJ2avFcNj0tqt7fBr0t4m?=
 =?us-ascii?Q?aY/sERSjWthX+XRQwUAu3rK5A0SuzDVByrRYnRiBk8H4xw0ZhPIRPdd2qvnk?=
 =?us-ascii?Q?5A11765AGtlnrgsHOoCdlDapXN1GwzTwDNg+9It6RJSIvBymNbc+DJzoW2fi?=
 =?us-ascii?Q?EKAQ9me5bEFgZw+aX2rp1ZWZjbTezBQCRQnEyT8kRVcV/8GXZ0L2kepjPEKM?=
 =?us-ascii?Q?4KSZKyBwXTOChbNY4z2z8763WiEz8v/85YzIi5oYsJcJR1I7tXs0XMnz7ZR5?=
 =?us-ascii?Q?aFWHXZ/86yIr8Vud3VxeG1SHyjoM0nTvAC7T1T01kg58bl6QLbZmWqlno1jR?=
 =?us-ascii?Q?eqYHyf69b1X+B+uaYZWMKivMX3TEH2eO1O77IHdsFmENLQaG6+/BitewKiK1?=
 =?us-ascii?Q?y3YnQBCZ8+mhl/NRP3CTZd+5Djng2AGlcG9KvTs7Z7B6hUyczdomp72Tdoye?=
 =?us-ascii?Q?xty67GkY1DnK9/Y95H/M+Jc1L+Yo928DhQ4ksoQisZum7EVIQseMxexIkJ3b?=
 =?us-ascii?Q?TOsIy8wwyQNtzD9+4H7w/+mAyELcmaiYXQk5FIWnpGclL8RrFV3+AIjRYMMi?=
 =?us-ascii?Q?A0XZ2Gzv9OcSUHhzcwvl4gSpesM+5X0ROhKggYye9GPu5i4W813CL9v+2maH?=
 =?us-ascii?Q?fKt9wUh0lgnIWF4QSnXFe3tT5ykODvBi3XNUzn3wJaoE0YMY+7aFU+tsahpH?=
 =?us-ascii?Q?IIL01dYEB6t/nQkNGgbSRdee0cToAtSsxnNlXU2Ig0WHoJwGijUvnu+eNxb/?=
 =?us-ascii?Q?Aksa+fRrqePh/ap2dg/r9K8wkQiTwdPvV4T4j1xSVw5i/hF3rtyAcZCaj4fK?=
 =?us-ascii?Q?8CbRiiYZY03f0m+tAC2VXDha41tmtEaoVBRItw3dNprQ0q9QHsrR6J76DN1M?=
 =?us-ascii?Q?kAfIz6M27n7a+9jMktWZPRTnw2M0ooLg3Q+s48P5MAuTVsJCynY996Q/5Q5t?=
 =?us-ascii?Q?rOCthiUvKw4+dzoPWRZMpKGIYntK3Ja6kGHFPN0R8nPug+BY77SlJ5re+kC/?=
 =?us-ascii?Q?x46eT6NFBBau+wUOwWw4ZQo4lQhUInvPUzTKfhI+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 708418db-0ec4-4df0-0723-08db02c6913b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 13:33:26.8603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rBw0xrVgrjHNAHXIa6XlhtTB1Bs/nu3PMCB1bU8K4kohUHwEFY+gHPzi1Bjm9HO1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5798
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 29, 2023 at 08:11:48AM +0000, Tian, Kevin wrote:

> " I'd also question sprd-iommu, which hardly has a generally-useful
> domain size, and has only just recently gained the ability to unmap
> anything successfully."

So long as it has a correct kernel API and exposes the right (small)
aperture then it is OK.

The device will not be useful for qemu, but it would run some dpdk
configurations just fine.

All the VFIO world is not VMs.

> > @@ -4761,6 +4759,7 @@ static void intel_iommu_remove_dev_pasid(struct
> > device *dev, ioasid_t pasid)
> >  }
> > 
> >  const struct iommu_ops intel_iommu_ops = {
> > +	.use_dma_iommu		= true,
> 
> missed:
> +	.allow_dma_fq			= true,

Yep

Jason
