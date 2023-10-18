Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B954E7CEB80
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 00:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjJRWzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 18:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJRWzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 18:55:00 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2083.outbound.protection.outlook.com [40.107.102.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A06113
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 15:54:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNNpX7wMem32RPKh0piyDkxLBbgja5/Dmc0ekJI3js6tR9ns8g/tDRBQau3HSVA37vteMSmPPcN1UeAWnc3+mLjjEmhABh3Rj+Rt0oC0ht/spJoMnTVLTZUIB9nW7M9Ey9lZjVBUeNVnYXuZB9kG699C+j3U/PK+uwknCg9VkoPL/o0bN6TkW+Kp10ax+wd44y7Wkf8r/FhiHdVfughfFKbTyeCNi8iuPHovUC+sTNKB7kM12mEGNvhZLMjCfc3uyEnwXGp4q8Hrfop1EYCmxSQrZ6rdqifS58uzCPBYW7H2daqORZ9V4UyLvi6p8m1h/VIwV2oGg3maP4I2WvdAZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4tw5i/Q+SC+JzML5G0NMkPGxDhxA/xIGiS+RRdw8iwA=;
 b=CfbgSo4UB71QIaohirJmbNFtbGDt9qtjKH1JWeATS6ceu8O8zhuPanokDTxG2jUqKpnVR4SgXoMNwLzp6uxq7FsbN3oYXBLI9ltJuz5wsXP9RzSXhZp/ELkO7A5Bw/dqrhm3yyC3Qov0xlEQ9N2eBfTEK90/+XPNMNJ2Ez1C69oTtmCUZGeil21M7BMSE3DsEqkhR/bnGKHCBEEMVFF1SKgujpxH5J7WOxfJ9p3xrXDF5hBcRS412apx7bX+i3W7dADz44PvalNNb/3DKh1/8PwFQadQOKMk2XFu2zOtR2/8ulEP4xF7i4MzpailnB2RE4VHIJimf5FCxPbkOwoYbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4tw5i/Q+SC+JzML5G0NMkPGxDhxA/xIGiS+RRdw8iwA=;
 b=G28U696a6ncBVrYW1CI1ic6fmDVj6ONxdl3vZt9T5X4Z376Wc2gubqv5Qp5+lBatYrg9RVD2C2poyP42Cu8GA0ZZP1jLmKsOE/LTPdiTmiSzrw1XwJVk5e6NCCnE1DI1Nj1r32RsS0GSAph/H9ldfFsJL39bhokylsiHNyN/Ae32i6vd7hxx2SHuckYMEvnJbVerTZc8nisVaOCnQVj9OXBP8U0LSUX8zO4B/2bh51DeSt1SsXHlSRHAmcU2ZiQ0u0CMDRGUCnECRdVosCxvI/VFP4wWxH+49v4hYajA7RO60YEJBpmhXGMA07F26s4/qKoBkXNSPwHBIVr97MaE0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM3PR12MB9351.namprd12.prod.outlook.com (2603:10b6:8:1ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.40; Wed, 18 Oct
 2023 22:54:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 22:54:55 +0000
Date:   Wed, 18 Oct 2023 19:54:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 09/18] iommufd: Add a flag to skip clearing of IOPTE
 dirty
Message-ID: <20231018225453.GN3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-10-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018202715.69734-10-joao.m.martins@oracle.com>
X-ClientProxiedBy: BN9PR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:408:fc::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM3PR12MB9351:EE_
X-MS-Office365-Filtering-Correlation-Id: 51895b35-d634-47de-f519-08dbd02d3ec4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNjhenpoUbZGrISFFKMaObWK3h2Xscg+mlBWUPSZmWH0/Dgu2UmWFRhnJYckcWhTqvVBaLOxlwPwR97ZZn+02D9oyuWemyTgLjVF+0M9Do+OKXPshZeIUmgLh0uYL9fmdxdPVVk52rBIdQhJiqm1P6ihzNxD2Wnl/258FlyC0Zqr+z0JaS2on0hZIZffKAokuQHCLS+R7VAbUaKcqJE1gBor1WXSD0mnf0g1uT14dBhiao9cV+uzZQREItznTGvteaW2Dlh/fgLoNt3yBX7h/hN+kphj5y7RvqnZnApf1SeyY98+2vEWxHqKZZG0LDM7K7jKNg8du50kKiHqgwsL0dEDV0JEzVlYgKoteO38maWbBST5OW99nF0UnWNAo4aOq37gHCBNxIOPmfQn11ql0fx5YBIZlknEhyQZQn5fO+vNO7N4gTIVUyFhNJAwxkAHFyMS0PZnvBAekL7mBa0cpf7ny3yMMIm1HMsEgZL+56Hdh84/jaNvrrB1dCfBw0KIHP2c353iJVsVIdQeky9ZrZ7wtHJIiHUM4DkzDjb4LigXEiyk87R5X3+QV2/vyikMGqWvVQnH0QRwfCvhyDuiRODnySMq/YVf00umfyfVVf0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(39860400002)(346002)(366004)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(38100700002)(8936002)(36756003)(33656002)(83380400001)(1076003)(2616005)(26005)(4326008)(8676002)(6486002)(7416002)(5660300002)(478600001)(66556008)(66476007)(54906003)(6916009)(316002)(6506007)(6512007)(41300700001)(2906002)(66946007)(86362001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cKw16DZdfa2iCXN7D7G21mRyYLKwAx9l/Vup4CtYaSlFE/ZJF8gWqtmVQqhY?=
 =?us-ascii?Q?octO0MNxdybiEU+RHq47VfOBQl09RxZUvbKYrEPiFD6xI9TDjk5Sc1kHTQzr?=
 =?us-ascii?Q?3Zdo3k7i73yeyensjAm/qECNs5dlsOJLHm8XGwy5zoEDBmSVm3uIhhUr+mJa?=
 =?us-ascii?Q?jPAkaHMmNjyReXhkjL4f+ekLYFx2T9r3m2OwC/CNAZUG8r8THeI5UShB7z4C?=
 =?us-ascii?Q?CfB4xKiUhJ5xA7hNY5RyVIoJCo78515d2vzvy5dhWbGXyarTNAxu6/AlP+Y+?=
 =?us-ascii?Q?61IOsdHCM9rdC7JNJTe0ywspMjNMYzh19jGYfJVK/gFDQy4m3bgGVnMyWd4k?=
 =?us-ascii?Q?KQTA3PXPAiA3626Gv9HibvT/okcjzzDyZez0JCjxeMfaO83yndVHTGb8buPf?=
 =?us-ascii?Q?2PS15xAFxVQW7+3BaGpX7GSBwW1oea+ZvfBFPLalUobZl+c713DwxmHs9e7V?=
 =?us-ascii?Q?D1xl9e62T6bCOhtyfD/Q19A0tzoMcNjHtxgsWuihVpHVwrE0aYaTgl5Jp+f7?=
 =?us-ascii?Q?wuL0OMjrA0YbLivO01ZXPHtzSlPL4y73Hv9RXESxVZqimdhcupOp1id5xruS?=
 =?us-ascii?Q?rf1RksYddfaQ8hQaTvE6VwKZLYzYl71Za0yrTsobmmCigrST6WecOqW28m7t?=
 =?us-ascii?Q?229KEAYRbcFY1dLvfkzM1w8V73O4ZlUOF4CD25Oqt1WB9FpOsHpGHxlC5nqg?=
 =?us-ascii?Q?RO98mI+7ef3LvT1i2OvhS5NW6s+PLO2mIEgkDQVcshIOuz29Gu7GogF/7XaF?=
 =?us-ascii?Q?BLiCSwBRYKqKxu2XgmZKOqzVdVyhDHP6VRbuULy5tQ13ubHTdXftfjmFUgZm?=
 =?us-ascii?Q?RS4/M1Qvn5zd9RsUXPDHFawJh6Li6YrlzXC7G5hpBXLr4PmbhUTV5Fk3D7GO?=
 =?us-ascii?Q?eER9jPO/1NiOs1A0g470oKTyVr14fBkNX22rErj385bhOCB0wtJiMKvBKUoo?=
 =?us-ascii?Q?jwFTFmqDS79gxHpgzn8TeQnnxJpRJUZYBUzdOK7cneOLoAZEuhsa4VrxACjy?=
 =?us-ascii?Q?I1i2zEJ73RGFVY4sukOXaLyZNWuNRAzHvTttqFsnoWPMdIdODPocbe2NytqJ?=
 =?us-ascii?Q?FjTt8ZsAbAogpV57QbSxkSFGZpYTdnDxEu022msg7v8QJqKyivjACY22/nkS?=
 =?us-ascii?Q?RLDmxRS7nhzLSQ6AXepG5wcZREAEIvr/hyx4O6KWiNj0v+IutQYUMvFsQc4r?=
 =?us-ascii?Q?71baokLbsJVYhxOp1Xd0c99kV7E9fJUQHALEz9crmKHkXlcaeO8Zvxrkhw6u?=
 =?us-ascii?Q?rLs6pEmdngfpl9fv6yECmzDF7I8UKQdQFBvlUWeoDV7HthcRuvASyYKYqQOj?=
 =?us-ascii?Q?j3IfgqHk9ocyT2nKCquCVrgrkHf8N4W4NVatly9ewPETHa2NCPJQRn0c50Uz?=
 =?us-ascii?Q?PVujwQNqyb6BKj2tdLucCZGrm93EK90QnWPU+evipbATiz63Z3hsig5WuDO8?=
 =?us-ascii?Q?DddomYmMZMMkVD/nsw141Ym/hpniY5VeCejafKqDRGEuFRHZddh2PAd5SUk0?=
 =?us-ascii?Q?i8875fmCUcEC7SAieXxFI3c6oH6TUtQzSLrPhdHLygrUt2RVjzlwfocShski?=
 =?us-ascii?Q?pxoeLLB9nBXlOs2e+YuhXz50t0snzvmTXbcYYMKB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51895b35-d634-47de-f519-08dbd02d3ec4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 22:54:54.9390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8ZiYCLaXqRAYDjw7+X/RfY8lxByyBy7Tn4GH1N8uqlWB1Q42fPQgGd4ZHAkLQGj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9351
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 09:27:06PM +0100, Joao Martins wrote:
> VFIO has an operation where it unmaps an IOVA while returning a bitmap with
> the dirty data. In reality the operation doesn't quite query the IO
> pagetables that the PTE was dirty or not. Instead it marks as dirty on
> anything that was mapped, and doing so in one syscall.
> 
> In IOMMUFD the equivalent is done in two operations by querying with
> GET_DIRTY_IOVA followed by UNMAP_IOVA. However, this would incur two TLB
> flushes given that after clearing dirty bits IOMMU implementations require
> invalidating their IOTLB, plus another invalidation needed for the UNMAP.
> To allow dirty bits to be queried faster, add a flag
> (IOMMU_GET_DIRTY_IOVA_NO_CLEAR) that requests to not clear the dirty bits
> from the PTE (but just reading them), under the expectation that the next
> operation is the unmap. An alternative is to unmap and just perpectually
> mark as dirty as that's the same behaviour as today. So here equivalent
> functionally can be provided with unmap alone, and if real dirty info is
> required it will amortize the cost while querying.

It seems fine, but I wonder is it really worthwhile? Did you measure
this? I suppose it is during the critical outage window

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
