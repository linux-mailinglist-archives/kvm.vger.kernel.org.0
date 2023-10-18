Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3887CEB9C
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 01:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjJRXLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 19:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjJRXLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 19:11:18 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2070.outbound.protection.outlook.com [40.107.102.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FA6115
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 16:11:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cav/ssohuHsc4mQDx7hDYF6lviMWgChiBglTB/owvQhp5KZFBJG6u733qh0q7kMIKfFALt92b6iPooir5mPCmOyo3uyHCh2/PAWq3T2CUYj3dBS+Avs9/bVt0W877ELy14V429URP9UIjAz6vMpW9Qs6PTVdxKVvIcdShrF/VzwXg3DrFo0ebY+NIwBTSi6dynqU57gpghf0z4MbhJNX5/MOo8/WSfwAz8kNS3NKsP3Y7zy6z6npgoNkhaOsA0CwOb41FQlM8CNiDaWBtVY3XBwvfhM6MlPYFOlWubyAz/lDJxN54QPNA8FEHUDkY16z1jeYCgQLmC+ap94EVF9+Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NfYrtimpuCh6B06ErzTevA8Mr94RcszxPKEWwsPefY=;
 b=eCFM9/QZ91xAkMhO432Z9R5Y/4mzcLS2Srmq1vcVSDkNtptu+lDV3KgQe35cKhXsJ5K8qeb4JZdhenSL3SGrpK0ZP4zqAoMWau+eGUrCPdGa9L093cpf45wHh7w9PhR5WKLq5VaiothI6HFAvkszn0032vrqHbbtajuU8uYMeTLeOFuVDZv6LDWRzUYBqrwuucNOxr3BJGIAm3ixG+b1H4iJKZh1U6X5nF9HqXaazE40ojp8BO59G8VUnJYKqiQHhmGXczK+zb7/0EokKNMVDqzu6IuWURLDFg6gk+ermVkfgjdhlvBxAOm0bSVnbv2upHpvYFIJbeormPD1QpAKFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NfYrtimpuCh6B06ErzTevA8Mr94RcszxPKEWwsPefY=;
 b=koLYHcI9ec1pRWj2afqOh+HHv5reb6gIB+xZuynY5n8cxfsbM8nw9oZPn9j/Fhw9fX6P+gUAEurICihazG4/KcZfDFdpEGxa8PjfGW9lnWFX3YU1yG4DY4C5md4FyiJIQ6BsHW4PZKXbortkmFIB9Wm6f8ir+JuHT+nA2NVERA/lPskdPBDDeE7QvYz34XIf+v0Ie8V2v1iL3V66mbKfCNKQ4R/6K5YZy5zxUPR/NDpWOIelBMnjStO+LPIL3Mr9EMajU6FDg42SOZvBS9cSrXxbGpe4xkQ2Daloxfyjcn1gpqsN4eP2tBOJSvq+vBvES+msU/q6yB5JhzGEsS1Q7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB8723.namprd12.prod.outlook.com (2603:10b6:806:385::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 23:11:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 23:11:13 +0000
Date:   Wed, 18 Oct 2023 20:11:11 -0300
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
Subject: Re: [PATCH v4 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Message-ID: <20231018231111.GP3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-12-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018202715.69734-12-joao.m.martins@oracle.com>
X-ClientProxiedBy: BN1PR14CA0017.namprd14.prod.outlook.com
 (2603:10b6:408:e3::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB8723:EE_
X-MS-Office365-Filtering-Correlation-Id: abcdcd78-54f1-4147-5ebf-08dbd02f85eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7U3iTqnjTIER3a63fJG5+lcr1kWpKEUVR64OEPzGaXDG6gGud8/b3AMoKUb8TT0kM7YKBO+OO0STxSbdUZBpTuXejhYnG+jdVB1eIKXbxak115blHA37a9/91JkUt7oBUxy8dv13MktyOjTcHtk2XoppRInwXvHd8vrP5DBFgnQuPclAUWhIcyKlUpxVZXwXvwsI0bICtVu5gYzh5E5rm+5F6tf8tAlz8Cxh+XuPSV1dgkUu7hkV8EyLwXDj1nKxfWYYsF66LE7+DnFrWRsCtA+v/UeRnzj6twAh96B0r9jNVuz+XlNMb5pI8nHQd5z3VDZA8JGDfmyFX2fXx07z3dncHtYdnRjt0KGVzvmJFE4fLFbF8a2JHwzoKVjk5TnziTnafErXi5Q+25Bfj1SlgKK7eESwIUjhUkiQ9pbFowBubh/BV6GnZlLEXlkbu+jsk4a49yEI0gFYMhSKQg369fnreiod3i2qRaADrJVsVY+U678D7spVcUSuycaq5NhAYQ+XZBwBCk9M1Mregkf2lARVeSa0Wfbh6Rr+i5i5mKGijxc/O+bYb0AtU6Dgoim4JULz7fgOF9PWZgI6SyFcbcCo4zqUYCqNuDg6Y0XOuHI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(396003)(376002)(136003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(86362001)(36756003)(33656002)(26005)(2906002)(6486002)(6506007)(41300700001)(478600001)(38100700002)(66476007)(1076003)(2616005)(5660300002)(6916009)(8936002)(316002)(54906003)(66946007)(8676002)(66556008)(4744005)(7416002)(4326008)(6512007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WbVCoKU+Y+Q+XvzeyxZBX7vFMetThmUDbEXxL2qwi1J46ktxRwXo4KBA/j+t?=
 =?us-ascii?Q?ftNHsRVLJy/YYPpkTHmSDzFNrQCb+g6ByYe8aHh2fJtV1IKg1ZRwoh8Sy12w?=
 =?us-ascii?Q?dJMMVGbGJZ7lrlCIXqclo+V2CDme/ugA7uHPl+np6FBSMtRR7CCEjpzhaJcf?=
 =?us-ascii?Q?a3PO6oZ0L7bRV1D0KiecCEEPJcrPvBpiPyh7z0ScQ7YwjdUBgpcPQAvO6Q8Q?=
 =?us-ascii?Q?UEb2VmL2sB5ezSyoBL1NUGsH8gROmrQDVkB49MhecQ33I1saZwmEwDzihWF/?=
 =?us-ascii?Q?ispFmzz2YPf9A5nahfPYqA48eFd5iIjfKir/YRHvFy2SMhTANsqOxKSsGF9/?=
 =?us-ascii?Q?Rp2e/28CpeGjmvFhPovOIUycG7U4sG9meXS9r6Re3Y8zejAfKtOiVOS4PJkj?=
 =?us-ascii?Q?Xu7/W5DQk6AFwS8YcYQosElDr3fIqP5rnSFTXxrdV+hd7KVPsdUBWR54Ug4x?=
 =?us-ascii?Q?nTmMOq8adjjghToOtu6edrjcUvBO4QOwyuLlNK4Ax+bE6Ybq7lBmiwGE5YKV?=
 =?us-ascii?Q?q0Tv3WFABlcVd9RqwtNLWYCT5tsKtVcP+t7SBI+wCnZMtf13+/DanRyTK/iB?=
 =?us-ascii?Q?iBl2Q9+KQ9D9xuNBQioOgJf7R4/qtPvJbwWMW3r53uqcgo9Hn4wgITtIyHdv?=
 =?us-ascii?Q?TpuE2Hp5imByXVlXh7YcppnmILSa9IxJyEPnhd6CLza0eIz469SuKQSdwakp?=
 =?us-ascii?Q?ud7vxlJ7WP2b1pzze4WxNdqykYgKAM2ZnO2oon89oUrWHNH8HTzn/Ct2OfyR?=
 =?us-ascii?Q?LygVsIVmBJl5fCe1WpRrbtVXlvKEC3rtejVwOJsurIpigcQcugz3WKGBCMCV?=
 =?us-ascii?Q?7bvbY28fGgdf+lqfo7ICIvcETl4gZ6Zv2iFQ9IHqNlthmzS/p4ICKymAeswV?=
 =?us-ascii?Q?HrBlhQqvf1juiEcyOW95KIi9wP3HpgF3N+NRLt6LCEwfgKO9nvVaS1SmQ/2w?=
 =?us-ascii?Q?BlI17lOu0dIKPD3EXrwc8x5eg05X7SCMAWk9hEMg94OUjXZaIczRHjAcbYb0?=
 =?us-ascii?Q?bZCH2BA6KDTEqS8PKDNHP9ogVLT4PzzyV3xAlb1vgv+oIpjDUVSnT8uTMqtf?=
 =?us-ascii?Q?Ti2JdHJVhZJOn9GfeSKgxINjbfsWgauw6uyw+h61/balrsGXJESG/ZGknNFF?=
 =?us-ascii?Q?Q7XCQpl7O7gu7FY2Kjcrx8hiPIhgtr3HRF14kiPOjf/tw5ruaJyYm5Gy8b9s?=
 =?us-ascii?Q?MAPZ5PIcN/HmmcPYxzgiB1CaxW8R6lUrrdmD4+L3IaYstrNp1IFfZZOyQVh8?=
 =?us-ascii?Q?Av0l1+fbhBjIzNk2jToNpGhk4TtU5W7pb4AThCRtR2YN6YBmRDaUlzaRvyqT?=
 =?us-ascii?Q?KDQwvjOUSEpVtiOmtaFgVbvpaVuzZyC5Gg+RNzBT4n0c8IKXSTZECPiL9Cq7?=
 =?us-ascii?Q?961rwt+xMJfUeE8exM8jGkqL9bOx5TlSstgGY1Dw3VPQX8HnHHZ5zL/jiAn2?=
 =?us-ascii?Q?GshVC92OzHrC0033268Ki96u+NNa39ycMyYbCfzcH+kCXn/49IyLuI3wxjGx?=
 =?us-ascii?Q?RoyIVjBSpa6vTJrRFuMcFlD1277J0HTlKztBp0kE5u/ypBcIscafdoy2SUFx?=
 =?us-ascii?Q?3l/dwV9jX7qJNDZRd6s0+9P/azO6U2VelCbk0TIW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abcdcd78-54f1-4147-5ebf-08dbd02f85eb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 23:11:13.2875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2HLe2gfGCRrb+TZIlx1Rad22VJhN40uxTLua+9oYAIoOkasFMAbIjJ9KA6Mkp4u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8723
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 09:27:08PM +0100, Joao Martins wrote:
> +static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
> +					 unsigned long iova, size_t size,
> +					 unsigned long flags,
> +					 struct iommu_dirty_bitmap *dirty)
> +{
> +	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
> +	unsigned long end = iova + size - 1;
> +
> +	do {
> +		unsigned long pgsize = 0;
> +		u64 *ptep, pte;
> +
> +		ptep = fetch_pte(pgtable, iova, &pgsize);
> +		if (ptep)
> +			pte = READ_ONCE(*ptep);

It is fine for now, but this is so slow for something that is such a
fast path. We are optimizing away a TLB invalidation but leaving
this???

It is a radix tree, you walk trees by retaining your position at each
level as you go (eg in a function per-level call chain or something)
then ++ is cheap. Re-searching the entire tree every time is madness.

Jason
