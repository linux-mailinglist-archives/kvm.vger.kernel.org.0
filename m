Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3635C7C88F5
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 17:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbjJMPn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 11:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjJMPnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 11:43:55 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF64BBB
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 08:43:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rnug+KEKQOAPLjHMNpwqyDDtZENa1IWUZ/RyYb+LmvG3VfUYFETAHKKyoCrsrC/b7Ozo3HvHdVVviC7nr4GwzSNBREEHvuVp9JKDevGcARmUYs28Y8SLst6knMb4u1aW5LCXHGpEd1GoKcOct7hBLgmcMOZJT7lbfBYQBbInkoSEOyy/NuSco84yhV4d5qagc2xMX1xCxbDhQAirEOJUmPEaAXR8go9sptVBes6aRgxqgeoGWO0NePSK+fYtJXpJyuXrcvwqIRqmNJTLWQLhcAm9vayfNejMi/U2Rgvtm3MBOyRHrQE0+CsEyT84x2CjQVKvb3SgpPJm5VURWHE4wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COqL35sJ14Z2OuSvRBBW6KCkbo9oKS7pWV950daWNLo=;
 b=HxYhdwIrGugBVDecfvnw41qb4Yj8QaOYOLrU4QMOqTrN26ApDYfYJ5YhF/BJJRHjFeD2itFlnjsUFmKPdMsZ2mqzGNAJV/LdAN8U6kUQlT52OLxptUB+a7GcGYobe2ouast4z9+rv6ICKDRav3PRqld8rSnsx6mZhoPDNwlrGL7d34ypU1d/FoGZyyVAWMxyB9t/HXlPV0IbrD9TdXCwCyZZPT3GWKgRr44s5JYu9OP0W9kXewAOWBBNxJVtqjjFjL11KhKXe9wPmof3qDfH30hmwQnhuxKegOdjpE6FYrNb+yymIwEUxn3MPCnVVtQaJ3EZNZwe6Xug8JCmjR6tgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COqL35sJ14Z2OuSvRBBW6KCkbo9oKS7pWV950daWNLo=;
 b=tB+3Mspk9JxiTXfMpUBmSAsw0sua5hXfrpYGcmE3tUgestxT6I654AvvjYonbrKvP8D32QjSQ/h1E5F3RXUTE8064szilN+K3cWXrGI98LQgrTQTZDdzExjmvXsfT1iacdJpXmcjlqx0yOfn4o97smyN2mp3OoeZfN/UjJO1X70dp/rRQCxvHRxI5E7PjJvyLmOjLo9BGVOUBGT7DIoZg+Gx+en8qIpw1JzslUy8hBi9Tdjz5v7lJZ2ajxP2UvUWuNzA2omi+JoLGKy604/wPN4JsaijP2DC8SDw4AJNh6Xk0qBLPL7+N+AkDnUPoyEiQuktvcNCRIwxDgfn4qpTqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW5PR12MB5650.namprd12.prod.outlook.com (2603:10b6:303:19e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Fri, 13 Oct
 2023 15:43:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 15:43:51 +0000
Date:   Fri, 13 Oct 2023 12:43:49 -0300
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
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 01/19] vfio/iova_bitmap: Export more API symbols
Message-ID: <20231013154349.GW3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-2-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230923012511.10379-2-joao.m.martins@oracle.com>
X-ClientProxiedBy: MN2PR10CA0030.namprd10.prod.outlook.com
 (2603:10b6:208:120::43) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW5PR12MB5650:EE_
X-MS-Office365-Filtering-Correlation-Id: 0db43c21-3808-43db-174c-08dbcc0332b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k1kznY7PwlMMm2BM5Gcp7z05tCL67M264SSNa3SrOWR6nyJFUdT45yugexptoQLFFRWCia7WxLe021ECgw0izIVoFThA+6qMPH0Gbr5OJwG94VpR0n4vSjh7e40LHuky0s1KON7Gls96GCt8YvVgc8HTqvVEZhR9jKPvglNe7xjN6NdBboqoDFdm6BMUxk0QpUKdVbajtQeK/+SOyeANDpc8izIVrUuRPUWVvj1hvIa8lGmYZQfTV3xn2mPWV0XLaenPrhlaq3rj4B7h5e+17imHNQNNSa3hUxljr6R42Y+PXYE4z00WNqdBSlzv0Tp7OLHnBsl5et3JdyRHOGyoWfww2S1S9E5yQ/WhUb0jdiqo1K1llXqHhsY7pjvrIcXlHxRleoHTf2/ufnMcmMm1kGt/uTecpHkx77nDDj+Swe0fDNgQgK7KbQTmVBe+m9FpopMHfPCqN6cPCMvlhEMUdnXqNSHPAgiEwfNlc0AmrUVW9wI01uGL59leBfjU5OpgQYkxASU1G83K0a9nK8yZCnBaLpuaLwjnLgQteKMK8j3NFpCCG0QIze2xqhTepMke
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(376002)(346002)(39860400002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(33656002)(1076003)(6512007)(6506007)(6486002)(2616005)(66476007)(8936002)(4744005)(2906002)(4326008)(54906003)(316002)(5660300002)(66946007)(7416002)(41300700001)(6916009)(8676002)(26005)(36756003)(86362001)(478600001)(38100700002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p0p3VTYRwy92c7ayViRHcCec1AM8u/+5VKPRklxlIqN1Dpw6ygJzfRj71wa0?=
 =?us-ascii?Q?SYTP7LdG2AaziX4E51WrF9Z6aYwHVMjKjnhVeqxMTZyoC4GgS/efnuMMxK4y?=
 =?us-ascii?Q?GDkiKDfhS7BkJvg+Tdgqo0frQ0+4F+4Ukhe4zKsDgikoSNwXagGAabYWOLJY?=
 =?us-ascii?Q?XXosZi+FbEgnNuRLkRxIu6QIpKRTuO/ar7pR37J4BNUScnAhJaxdlz8jQhT4?=
 =?us-ascii?Q?emLsKhF83FeJxcL1XYQCyHNaGQGHp4TutDCPoQYjLXXea1UADzMRzDa7Y2i1?=
 =?us-ascii?Q?DcegflAFwoi/PNl0JzJQADEy8QhenOwLuf1QYU+A7DSqwgRXeqOgwjCj6C6l?=
 =?us-ascii?Q?VrZNeiXlAWMg0zoB3NbgvcrgM0W+cat+XT0kF5elpbikiudZpT8XHgbFJcX9?=
 =?us-ascii?Q?gBw4BHdk+hGHXtdtxnSBv6BEGbuZUqNW9OZxK9jAbcQ2o72ZWGyX8oJwZGvN?=
 =?us-ascii?Q?KAspXqAwXVo1RGkxhqNQHY3LRl/9my9eR/m/Grw9iC/cEmqbR6LiCEqvcfws?=
 =?us-ascii?Q?miKaCkm1qcGjqAaGx54H/rPW4THludJb4jXrwh9Retd7jnxeqEEKkq+Sm0KB?=
 =?us-ascii?Q?T+likE4/r36AlL39qYtajlGDKDTjtF5+G0HXaPZuHKY5wAq0zgThbX6Rpf6r?=
 =?us-ascii?Q?YlCg4NT+Bwchix6zNi9V/UizsqiPyco2aY8tRmZGkaHmomISkm3U80lBqUKT?=
 =?us-ascii?Q?oq2CVrQ+wLQzekHhE0j15VIriqTBT//nPkhV1KJ9ajenbiRm9zcdnMP6FlK9?=
 =?us-ascii?Q?KrXORFRdU3/ieH13q0WiOH7RINQm+ZuCQ7OG7NMA+iKW8lRZmE0Obf3NYlDt?=
 =?us-ascii?Q?mYyA1p5FrWy/G8FjkQuXwdpxeYCXOPVaAcc/0NH9XVcp1xSCEPwfYKPRBRiN?=
 =?us-ascii?Q?TSc1gzqQjm/oAEKjw2QYd8SIlew7d1pNveT34y6TLeOvNNMNWBuiAJKvLt9J?=
 =?us-ascii?Q?JY/hNT09BS8Ivu20m18BDSHxy7dIuQCJLPu65ch/OsAu2kd5uBoxvLIGgBMq?=
 =?us-ascii?Q?41WZgy9EpZ8gzJSRooBEXjCZBBjPzwMKUp1KBGpg7J2+fOAFOLdgdbOJ5BW0?=
 =?us-ascii?Q?PJqPD/ncooE/5ODSz66cPtsbA4JT9jcolUK9iHyo7DaUsQxiX0+94XK8TIBB?=
 =?us-ascii?Q?cXwewqAhzCjxMHtw605WZyzIV2RcjJVtKPgPafd0ZSF/TCWXG8l7OJmfRk//?=
 =?us-ascii?Q?1RFIjUX0z2bB1tAULo/FFFgJVk86w1EGzIYj7IJyCNmJDsNQ+Nld5Op5pu7N?=
 =?us-ascii?Q?XlTB9LQdIen9IyMkOjCzMH9oFhFFPB116BF3BfeGi2br2e5j9NO9dKqk/fO1?=
 =?us-ascii?Q?2uKT6U1iedH+uoxtuFS/KXlLc1U0t85mwIhqRBJ14wqfeMf+nczXLpDGy0f4?=
 =?us-ascii?Q?Nyiv7Uu51BOlgA0hmJ8IeBu1hd630RdjfrdHyb85RvBinQvQhISfkeXlarrz?=
 =?us-ascii?Q?zoZpkmRpLfOaD4zscr0dCIjyMaqoEIHaI56XB3H9BASgGYvDq80FQgc1gAck?=
 =?us-ascii?Q?W+gM3QRk06SxPFNQmW7sjattZkqtWRQDZomjzKEhWuISQ1hL9buMekU4Q249?=
 =?us-ascii?Q?bE4IiJChU79n/xXw4M7baVIwCQR6zpdtwFJiua1A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db43c21-3808-43db-174c-08dbcc0332b3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 15:43:51.2262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xWKC+2mNMbwSBWzn10O1mEBMzpOByfCno4ZIaD/I3efmcfc95nWyOY/ybfi0cdBF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5650
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 23, 2023 at 02:24:53AM +0100, Joao Martins wrote:
> In preparation to move iova_bitmap into iommufd, export the rest of API
> symbols that will be used in what could be used by modules, namely:
> 
> 	iova_bitmap_alloc
> 	iova_bitmap_free
> 	iova_bitmap_for_each
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/vfio/iova_bitmap.c | 3 +++
>  1 file changed, 3 insertions(+)

All iommufd symbols should be exported more like:

drivers/iommu/iommufd/device.c:EXPORT_SYMBOL_NS_GPL(iommufd_device_replace, IOMMUFD);

Including these. So please fix them all here too

Jason
