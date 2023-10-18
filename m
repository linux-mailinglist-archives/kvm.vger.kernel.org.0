Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C137CEB87
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 00:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjJRW66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 18:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbjJRW6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 18:58:54 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95ED113
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 15:58:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFrsfaGJsjNXO8+mE2G++MSFvGRrhcq6HLqrtoYvyyoQG4xec9VQfPFk4O3BdldZL02wzSvIKQHCiaGthB/8EUHLmsEWYDiz/FXyQBDTPrHB2RZsSfflKcBAdy23ghJpThZK+XctuDhWjLAhluhoLgPsDPzZZB3REgA6QPy00XMifjsF91obQaBKuHRZ0zq0wk7X2VEbdww3U+UzgCGrC4m3vflayXZSlfxiMU5gDndk4QdMBC+LbqpTchF1b43SDY/vB9kBUvj3ZHHrq6J3gDf/coPH0lnCBN80aIsK6qCwToEMAVqdCmig8otQFi0Vglu3bpMkGhmmyUJq6HZD/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLiAxS4LmxO7JKzATKvbC6/wGPJDXwRzQ3bjVfJYigU=;
 b=DXZNb0fUmWQrw/mI14D/4mPDF9wjGMq7ibxB4nzW8IBf0CLzXR35o4/oGFmFmdrBhtgp6CONngfxbKs1UFrQMNA/PZQtwtc1UrN2lHcPki24p36yU7a7lHDXwxYCi3T5dOGovuRLJXymiS72XaSJzS7yVbe9KZlZ6JvJVVZP4NfwQ2x64+ADaSHB3o64O0AdzI2t5EraGKdIn2sLTg4AKcZqjltuR1dLSmbMgEsjw/n0J0zdTrJaL7lI5Z0MS2miT81grqZCPXgjYJgcD5Mv3W0fhRclBQ+8SWcfFozCrgyyczPXvGEBBjSv+mfr65BSEKryHiBR1Hx9hKG1Geh75A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLiAxS4LmxO7JKzATKvbC6/wGPJDXwRzQ3bjVfJYigU=;
 b=et1pjv4IbBNXX4RaLytymI+YICrCuaDV3eiqNSMxwp4xlyLPR6JlLhZhF+g6ZkZay4GFsEEEPbO0PYfUUlDNJDIOK3Q/SfI2GkR8sWzTJVBhEuYUqKmJQQDcwOE3ovYdyVJyxzmgu801UhQTJNG2U5g9NKQRj1mMmFOEW2IeNVh67zj39HVgbvPqUcXprD5up83CM6CnCwPvO8BNqvrU+PwdDYtqx7h9KqaCVwY7spKiLE+jQQOLgP/VPrrTBXAqLBWDWvwziRVQjJBOPagtXJB/5C7dYsK1lVs45ssQ1+hEFSyATErZHQ4K5PXYCYD33tEI6ohVU2NF4gIM+FeNfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4972.namprd12.prod.outlook.com (2603:10b6:610:69::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Wed, 18 Oct
 2023 22:58:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 22:58:48 +0000
Date:   Wed, 18 Oct 2023 19:58:47 -0300
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
Subject: Re: [PATCH v4 10/18] iommu/amd: Add domain_alloc_user based domain
 allocation
Message-ID: <20231018225847.GO3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-11-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018202715.69734-11-joao.m.martins@oracle.com>
X-ClientProxiedBy: BN9PR03CA0457.namprd03.prod.outlook.com
 (2603:10b6:408:139::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4972:EE_
X-MS-Office365-Filtering-Correlation-Id: 00e5e8b8-056a-4acd-deb1-08dbd02dca39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZcScjPn3xwriZj7XPi7YW8EjDOcw+pNfDi1Rp1mZvbQrHR72lfdeFdUvVkWHMg5JJwfeNp0Wg+BX7W4pD2fVxjsuWQN0NHvNbKmud1tbLIht5bXm6TO90dYUlSvqPNkA56XJBBN9rfvvwQlrAqf8Q1MjoR9O0Nx598CwDebI83ZAynoDBBuVSixJWdtMCiablMJN2heyvvrpMP3gjZvx5w+wgIszhFeu6vmlRd3uVD0hRlUr7km28u2nq937X46xABRz4wPPgsc4SSZbq59t6YCYritFvkJ7jcQ9SD8NcNCml36uWcaRoUTa0omg2qIyVguxELx8+mu13evWpcbWmxWObpzshMempt8rGDsFNSkRujLyveaATMqX8p2EgNBS9x9Atl8cVbVZTb+rhdgfmeEMS8NJlF51dWLy3eX7GmchrOiclmpjhb4AhteM2xWMw+PObjSD2jtCv/Fx/9lH8D23N4LrK5uliXa0u0OOqxTgowMYC2OBFvCNs/Tu7KfSaf5BAPTMSF1a/3w+tCV0D/k07vtUq6Yb4vhOxG5vk+K2iWoufiEt16Q7j3ZeErlV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(396003)(366004)(376002)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(41300700001)(478600001)(66476007)(66556008)(6916009)(66946007)(6486002)(26005)(1076003)(6512007)(316002)(6506007)(2616005)(5660300002)(4326008)(8936002)(8676002)(2906002)(7416002)(33656002)(36756003)(54906003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ok0tpEzhtvPrn7/dA06ylr5rqg650keW7xAacAkhNMAPAg4I+MYT103yc0E5?=
 =?us-ascii?Q?mbowxYs27Ow/+K87i8w6mOmt6F5behlA0L6sHJI6DogY8CQC3ZcAKyZcEJIz?=
 =?us-ascii?Q?ouBLPcI13CUNIRhWlxMMt09PbwM2rnC53cTh1g9RK/lqUGo6r42NyDJrGg+Z?=
 =?us-ascii?Q?+JPTD6A9vHEsew90MDGj2KH0ui2GjtKJXc2BFdBK2iXE2Lm69jva+c1tgBy0?=
 =?us-ascii?Q?OHoA9m3glM4KFqBaz+7AAUdOesGN9ThDbd6wcfT0jWr+6E3oB+AWIv17LBLF?=
 =?us-ascii?Q?nzlYVa1Jgy1GBVwpx5QbVc2SKzFyA6hAnmo16aNLlUEUIl5u8+2YJ36imuMj?=
 =?us-ascii?Q?d6gPKel6Rts+RozUS+xuWsO2vCS0PA2U+G5sD0oVB3HHIrTSaqBrtoBzsrmm?=
 =?us-ascii?Q?7/BmIrpH1tluRmGozHXkBk5ATkc2HB1FYWt3mKLdZOT9RJa+2GXQp47PxNxq?=
 =?us-ascii?Q?MaUcDFJ7hO6cn7yWfbMOzeL+4UFuJQ5WQZJ28qA//KFc+m9bkuDgmjr9Kgyp?=
 =?us-ascii?Q?NAJ+Al30T0VeSS6XkSUB3zz48lreLP2sjoMF9rBe2jjJi7luEca6y7RN5ItL?=
 =?us-ascii?Q?RiGhlgAiAd4uZ5XVs3Fdc2aUihV9DhfuXnA1wKypsg2Rea7cgH1F9c+jheow?=
 =?us-ascii?Q?PHs6hc7ln/rnIKqGVP46zt9OgLQ5xUEJOOLVqgQrKmgjL9exs1+EaBSOy0iS?=
 =?us-ascii?Q?QTneJ8BOYiH8+lDYDfqBVYikkstePXRUKhMcsheustUtbyTyYiTk4pnUAgta?=
 =?us-ascii?Q?j7bB49oC+Dodc+kUEr7tCssPuWwnTVDbTZ8kFCw3aPLw3UDD4N7GojWICuoP?=
 =?us-ascii?Q?QllKb+qOjbx4E53/EKpSkB3/VGa6dbFbN9RVfS32W61YVR0tLUjWUthgn16w?=
 =?us-ascii?Q?VYekqF0WvlJngOnXr/X7NVnr4u/1nK0dnZNITGBXJwozqqMpW6i7kljB4hPB?=
 =?us-ascii?Q?UQG9VX71E8jbjXmGNw+HvHxmu8O9fe6F2CVMX/BRMpAL/GgryFCqB68PIK0D?=
 =?us-ascii?Q?YLyNc1BNTD9m38skLOeLkT40BD66weeQ7mJyHS/Vd/WAy1IJS1wGkgv2CCHu?=
 =?us-ascii?Q?w67F05Y9Bx/6MDmMj0duvp00OrqHk75Mc96umbzxqXXOP2rGfI5dwn+6KMKn?=
 =?us-ascii?Q?2CmybxIydrJif8qZiNSmQRxP8nOYpyNg6NORenYVcQXI2KRi8K9OS4QVMt64?=
 =?us-ascii?Q?FbXXbxTj2diF9ZIUQMw9lekeatvwI1nsJLV1j3v5GcXqDcuAIKJLN/mhw8xw?=
 =?us-ascii?Q?ITdnC4phfpMlcm+WIevLTp7Sja3jK+GV4rMqJt09EFp7DoiqBRSifP2sBqA4?=
 =?us-ascii?Q?BrjIqlpYfqkFYfYprUKnVEfHsjAH3ydr5T/zDBa51aUaXbU1FwQCDsngg5Lg?=
 =?us-ascii?Q?b1wUjNyOjWP9e5pxCkfT10deL8OGwJhutEwFIsP+c8QQd1EW874AgfvossFr?=
 =?us-ascii?Q?VkT8mAIJslhtNRDTmoyafQPciZ80ygNa+S6pmsWgr5CJL5AqAnUgL9HTfKUX?=
 =?us-ascii?Q?qWmSIMyaGkSxL80//gz+BEtTo9/1rpJTw0mt5gH1/bOIgiKLl20WZ/Hhtb7/?=
 =?us-ascii?Q?yT4BUXgPY4FIOmF2M0/NmH4i5h1ZDoDlUS861pdQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e5e8b8-056a-4acd-deb1-08dbd02dca39
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 22:58:48.9137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +KII9Rve8zi+xdV2P8cx5NQfJ815cLs55O5Twc6XNJr78kpSEBiLRXgJ+6u+wV+y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4972
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 09:27:07PM +0100, Joao Martins wrote:
> -static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
> +static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
> +						  struct device *dev,
> +						  u32 flags)
>  {
>  	struct protection_domain *domain;
> +	struct amd_iommu *iommu = NULL;
> +
> +	if (dev) {
> +		iommu = rlookup_amd_iommu(dev);
> +		if (!iommu)
> +			return ERR_PTR(-ENODEV);
> +	}
>  
>  	/*
>  	 * Since DTE[Mode]=0 is prohibited on SNP-enabled system,
>  	 * default to use IOMMU_DOMAIN_DMA[_FQ].
>  	 */
>  	if (amd_iommu_snp_en && (type == IOMMU_DOMAIN_IDENTITY))
> -		return NULL;
> +		return ERR_PTR(-EINVAL);
>  
>  	domain = protection_domain_alloc(type);
>  	if (!domain)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  
>  	domain->domain.geometry.aperture_start = 0;
>  	domain->domain.geometry.aperture_end   = dma_max_address();
>  	domain->domain.geometry.force_aperture = true;
>  
> +	if (iommu) {
> +		domain->domain.type = type;
> +		domain->domain.pgsize_bitmap =
> +			iommu->iommu.ops->pgsize_bitmap;
> +		domain->domain.ops =
> +			iommu->iommu.ops->default_domain_ops;
> +	}
> +
>  	return &domain->domain;
>  }

In the end this is probably not enough refactoring, but this driver
needs so much work we should just wait till the already written series
get merged.

eg domain_alloc_paging should just invoke domain_alloc_user with some
null arguments if the driver is constructed this way

> +static struct iommu_domain *amd_iommu_domain_alloc_user(struct device *dev,
> +							u32 flags)
> +{
> +	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
> +
> +	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT)
> +		return ERR_PTR(-EOPNOTSUPP);

This should be written as a list of flags the driver *supports* not
that it rejects

if (flags)
	return ERR_PTR(-EOPNOTSUPP);

Jason
