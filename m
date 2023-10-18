Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59137CEB69
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 00:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjJRWjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 18:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjJRWjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 18:39:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC88AB
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 15:39:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9Y+rv9VkLcSiP0vzVGuztidDJatOQVtyaSn7cDaEEVJXnhCi6JJU3/aZbyAICGceIUdP2utNzsh3ll/yz+lgLqxnl72OuIe4PMeqsj2sUQKtt8hz23YIZ19aEQMbiJpOtYACGDB1NaOFIkPPj7qyl/zqaAmVcT0zKCbzE66hsiE2i/iPJvga/MGxZmhCapTyXhdDFR//JqxyhN7S9mWbOZB3ZPz4kckPsKe46uQn81jnZs4rYVeljmrGA7HQzwpt1yfF6Xcu2ELBKLopvuWEip5VP2/DRyIzVCrZ9f99Tfdj6zHC7al35FgtXufv8GWwOEw4EikDOYVG0u4A7gqYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NfwaL3dHHOcoqqFKWWDuN9yFc/1mC5PFMVmw68wAKoA=;
 b=G/bcX8hgJULJw/Yx8saxYwjbxOXRW8zP9Mv4igsMig2huT+e0NP9hgzSFZspZPPuD1hDHFcITcS8t0D9ug8tHkkk8vKfk7Z0BNns/PevOH+NnuvP5kYy4VrURSoOoKRs4lgQkufwpx+neivv/E3KGEbHl/5dD31/z6gfqIFZ/Tv4ZW5LisXUQzGFB5/5PlhOxX1yQrg42RLYqlJp4s8KkqEgl7+rPl0oGoY7g1ZUhUerh2n7VH72GOSCDipsq1wkuSxr83kOKDbgc4coz+fns0Qul8IW3sgRYS8ET3nOL4jTTaPwMRp4JTBdabHWHumH3YJg7fA5tLDAxT7mdKEmjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfwaL3dHHOcoqqFKWWDuN9yFc/1mC5PFMVmw68wAKoA=;
 b=g7/LMqU/mg8kaomaxOFvlC4lGf7Aq+TLqievbJJHzDbXwuTIqjRH8SdW+Eg9B6Mq5rurtBkc3SU613Sb5eTUIDGyr2uGW3/Ob3k55khAfueWFF7p4O0xX7bfaTMLjH6GPmbX565LGok7TUvwh9MezIHHhiwmhr+mgm+X7FEUPE9KCpnCNvDg+ywBmVc64/ABz1RFDOWksfFSO30lxWcBh35rC5h2eou8EHTkqtwbrcx5RRCPKNVBMZ7D2QZ4Xe4kR9fCi4AH890ZncUpeXB4BjsXk0DzzJ/BgxgqwPxxAzmgpbjhDVQ0dZXQh5xDpxIwF3IRpqyn9VpdIfXgpdywzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6460.namprd12.prod.outlook.com (2603:10b6:208:3a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 22:39:17 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 22:39:17 +0000
Date:   Wed, 18 Oct 2023 19:39:15 -0300
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
Subject: Re: [PATCH v4 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Message-ID: <20231018223915.GL3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-8-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018202715.69734-8-joao.m.martins@oracle.com>
X-ClientProxiedBy: BLAPR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:208:36e::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6460:EE_
X-MS-Office365-Filtering-Correlation-Id: 88e3b347-8a7c-45c1-4915-08dbd02b1007
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LhxLIIHCFUHFd91A2y6IvtTpHdmd0oSfe6NvJXAGlIFxe6SEvv8ivTywoXPiPCsCt5LvLeILbcgnJxD4Frp09UB56oCwR89CwMQfr/rbZPl65bsAx1JmfqRQkrSyY/9dlZWzo2WrxgoYSd2OQQ18G950HP+i5bfxLYsbO6YRaiw/6k/BXhwVYqjMV2iktqCPXdcD5/C7f7xHeWAOiUu2AFP4XUDym8x/xgKD8CzRxDzuVJwWjiPLDY3CaS6zdOYKGqhJ5oXcUGe2yHupkt76Feed32Q/h+ET4/l3QtIY1x2FURLSvaJrR2e6r2fop+aPK9cRHKaT80sKstXiDql/3NEBuc15Y4sSJpLmti3JfEqSl1gU66/IwzKeR8Cz+RFmC6TLOrPk3BLWKDXMqKHgIXFnw5PoQ0Zndc4N9KfVdiZXbY2lWFQhPtzFh/lY9aOuHHRcaHdYGP2MxAEGqgt3Er4czL3xlS35ASi5pdDnERlW427BVGBPm4KcLJMabQxMAqSvYuUP4FxZQOErqvSzX4x82YUERRJoB3tLZyzd33ZUROWEG8v4hWcjF4hQEDn8kylUDP2Rp5jML+IxJ+KQ+R8HtwoL1tU6yavCFy52KRw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(376002)(39860400002)(136003)(396003)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(38100700002)(5660300002)(1076003)(2616005)(36756003)(6512007)(2906002)(86362001)(6916009)(66556008)(66476007)(41300700001)(316002)(66946007)(7416002)(4326008)(8676002)(8936002)(54906003)(478600001)(6506007)(6486002)(33656002)(26005)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?urcTuAEdfitA4dz0JJZ330T8TXX2tUfIxKvXlZRgaxm7RbONlapn7tYfcaOa?=
 =?us-ascii?Q?/5B/vHG0oHCpvyBH8cb0SM4uQZ+h5u7IwXjieQgaI2jWxg1yxqNERAv6D0ao?=
 =?us-ascii?Q?5wBE/HC/vb/AhEJr+FPyWFOEUneNLAkw0l6WX+XO0OgjyQinkcg5Te7wg9nx?=
 =?us-ascii?Q?NPQQ4Jaz1zdTE7tlqwgy3Cgy5VqKX8mDllKYK48iVOWKYqAwyFQgyb2fcOex?=
 =?us-ascii?Q?HqGBOjNCLi+3ebTL9i9OjiMiyhKa9nViknAVRv8tc5Mzj79VhYEr7RSnCxzc?=
 =?us-ascii?Q?X3TVKf8HLjFkMl/+KGK02Zj25JxgSmuNDuHOyWQxr3hMwkKbHjpLjtj6NhA4?=
 =?us-ascii?Q?Q1kdSqwXpsfShZoQ54x9i1QQ7xs2cNU0AMGc7zzhigkn7OBWnxRZN7PC3zz9?=
 =?us-ascii?Q?rRdkCar8/GIlBqgzPJjBCf3FSROm+yZJ3QfM6eKfjNfBaGa4vMYIjE22lpvt?=
 =?us-ascii?Q?G9PCeIkoZF5pcF4dib/2oh31/faZMMgGxd7cOIxZbejKC2/otImS7rJA8mJu?=
 =?us-ascii?Q?n4T+mw6lUySKvqTcMS6f4AImvUqYrOUNY5C0ihga4drcrwUe1DKjUCrLuNQZ?=
 =?us-ascii?Q?eyh8wcV/H5i4yi455OLQJfQ9EFr3lvg6x1louUQKBMVMGteKF3CVh/gf3hB1?=
 =?us-ascii?Q?XJuZjj3B4Zqk8EJhpa4C+Vf+s0AZM/ZiUgU3nCkjJT4fDBTSKCAc1XRF+54d?=
 =?us-ascii?Q?kDd4TvxjdoolwruhuHetKEPX12LQMIlNmo3Kk4upN2vYh6m6binj2sRY5dsQ?=
 =?us-ascii?Q?VqVs1lJhlTqxUJKGO52eEH28ZvWBTHNNu7ROYGY4jUP71utb1ybAseFE9RKk?=
 =?us-ascii?Q?YB3TFx9MoxbZU0yqbEFCO5MjhS7gH5Opth67ff8pBHMv9pyEmcJkYzR+FLfH?=
 =?us-ascii?Q?wdIAKpqVnoPHj3RBRm/nwtDFzQuePa73aer0p7I74MR3cOUzG7p/iLNrPB8+?=
 =?us-ascii?Q?IHILrex+0luITtCOhfjsjOm6O8FmnIAKWeHKn2F2NJcjiCeElXsP/eb/zVTN?=
 =?us-ascii?Q?5ozmqdL+mR6SVP0/pxN5i/R5+E3YmYqARv/Izp+YVPG/r3ucZbxxOIIFAmaE?=
 =?us-ascii?Q?RpIHLODtELi+by7iSj/hgOuUYQ/xcLkgt1JrOBdkkX6Kwdy41IZ+lAaB/9Xq?=
 =?us-ascii?Q?MtCqORAboSJbHCF8Wac4q+MmuS1HPz6W6L118BPrj484pqP956geQIndxAxt?=
 =?us-ascii?Q?umvpGzyKx77Qf2oM9MwYtX6vm49nmm/rS+UCP+mM9FivNp/D8hTX6c8YdbfQ?=
 =?us-ascii?Q?aGD/Ah6z4MgqgSmbAjOA2dhIIco/cm9YOfbEGPjSYaeJlzsQrMehZxRiLnLZ?=
 =?us-ascii?Q?WfOWLiz5obesySK6FFxbjBqgpgwK7D0md8PcHnzw41J6E6xfX0jSED5NWdIu?=
 =?us-ascii?Q?vcM+GhuyAwuF5nNJUolB4cz7nklYYCb0uzAFUAY44ewHmsluacAsFKMo5DP0?=
 =?us-ascii?Q?emm7mZUThCyjyHB98urlA4hjlpLlWJa7mFpmamZbxkY9xGwuEd/+qchOHWaD?=
 =?us-ascii?Q?Dq9PAs4Y1pWZHqqbWBNXI5xmpc31dxOl2xqTh81yIoqDWUiGlzpUqlPT7uGr?=
 =?us-ascii?Q?uDJSSndZR+5a9QQszgPGku82lEBsLfJTFmpI7lQR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88e3b347-8a7c-45c1-4915-08dbd02b1007
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 22:39:17.5192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z+XqLf4WMtjVq1/347mlnHEhU5LNTByrneCP2BsSSj88e0CjB2Ti6Uy1ESHtsfhm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6460
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 09:27:04PM +0100, Joao Martins wrote:

> +int iommufd_check_iova_range(struct iommufd_ioas *ioas,
> +			     struct iommu_hwpt_get_dirty_iova *bitmap)
> +{
> +	unsigned long pgshift, npages;
> +	size_t iommu_pgsize;
> +	int rc = -EINVAL;
> +
> +	pgshift = __ffs(bitmap->page_size);
> +	npages = bitmap->length >> pgshift;

npages = bitmap->length / bitmap->page_size;

? (if page_size is a bitmask it is badly named)

> +static int __iommu_read_and_clear_dirty(struct iova_bitmap *bitmap,
> +					unsigned long iova, size_t length,
> +					void *opaque)
> +{
> +	struct iopt_area *area;
> +	struct iopt_area_contig_iter iter;
> +	struct iova_bitmap_fn_arg *arg = opaque;
> +	struct iommu_domain *domain = arg->domain;
> +	struct iommu_dirty_bitmap *dirty = arg->dirty;
> +	const struct iommu_dirty_ops *ops = domain->dirty_ops;
> +	unsigned long last_iova = iova + length - 1;
> +	int ret = -EINVAL;
> +
> +	iopt_for_each_contig_area(&iter, area, arg->iopt, iova, last_iova) {
> +		unsigned long last = min(last_iova, iopt_area_last_iova(area));
> +
> +		ret = ops->read_and_clear_dirty(domain, iter.cur_iova,
> +						last - iter.cur_iova + 1,
> +						0, dirty);

This seems like a lot of stuff going on with ret..

> +		if (ret)

return ret

> +			break;
> +	}
> +
> +	if (!iopt_area_contig_done(&iter))
> +		ret = -EINVAL;

return  -EINVAL

> +
> +	return ret;

return 0;

And remove the -EINVAL. iopt_area_contig_done() captures the case
where the iova range is not fully contained by areas, even the case
where there are no areas.

But otherwise

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
