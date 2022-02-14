Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD174B5081
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 13:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353465AbiBNMpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 07:45:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233510AbiBNMpa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 07:45:30 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E7C4B41E;
        Mon, 14 Feb 2022 04:45:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UN9BvCsjSnAPTAjrfK5SHGRp6YrixgTU2+341H6u1g8lPtbqRbqiCmFdgv+6Zf4xk1mF5juvJyS6QHCpEsFjRDgFe8DMQaTIxX7FR+fhN926Dd/r+7uty+iCbggfOrK9JVpcLB/Ro8Gk66vSkwGuG5mnfWllIdvvdSi3DiY67BrbbughfI0gj9AAh1yYKpISaeBSktEMVZqlF0gFerGarMLj3BLKPoGxQIEEbxX+GerHsUXnlYTfckBMuO7Lb0vf0pSUAJU2NB/kOhugtncT+DQRyDKz6lhJw1nAk+Gfk7zLyRwnEbAfgvWJYKyUuCBTMvj6OUgogsuFRNAzeKACfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dtardRRXKgeCe9/IjvnQyrMmgH6Tv+1wKy/HlxbqTso=;
 b=nulmP7g4GX+VVKcfXy3l4HX0Kq+HwyN6Y3w6v047zNeHTZc1vRkUN3DAWE4Y0v5/v0ySxRUSg6d+EcrvfV0bx/WDDh4s7gXJC4SwQ4N8IrV4G8qEQ16ZDhn2IirdGkLNvt0Tv7LODNb7x27YJVC337PXCn8Nj4q1wAZmcXTg/hgs4OZw+etCbRojLWmClJKroe7K2ZNPIw7w0eR7nOSXcoXLkA2BidjLDAUM/5Qp8TSANUxUxgCnltwnbCP0wW+oU3OT0pAlKUEqGUF4X8LciSdRNUkQ57h2rXYAwlkLjhcNWCxrnpfppOnMAy9ZD/K0qbD7lRXPZVmG4i2t00ONMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dtardRRXKgeCe9/IjvnQyrMmgH6Tv+1wKy/HlxbqTso=;
 b=bzD0H+HF97JWelLs73Hc4zd7piysfp+lYtyXYSjJVG5RQLuW6B8Nkf89aYD/RTZQ27Yyw/PBo/vl9Rxxoy7kpgcsb59tTgYkwnRmYzvO3hmDmz5cKLyWzXJN5BzX675wS+LUXtRIKurxTEMU5IaRl0ghK/hJaQ2pUgtVwL7rFMbrgROFuU7G6kCiOZYuzl8KkBnkN8t9rIpHc2Qs0VAoEmJNskGMyAdo1zcN+BnMh74B7P7O1rfqBKdLbubK5xBv1tgolaAYV/RBW3sH8fIDPeccNAkJESES+KHORpo/WNLHvZErf/2H6bPMTGdn132aONd/ES/W6xZ0OPNCtpFMzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1594.namprd12.prod.outlook.com (2603:10b6:4:e::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.15; Mon, 14 Feb 2022 12:45:20 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 12:45:20 +0000
Date:   Mon, 14 Feb 2022 08:45:18 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v1 1/8] iommu: Add iommu_group_replace_domain()
Message-ID: <20220214124518.GU4160@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-2-baolu.lu@linux.intel.com>
 <43f2fc07-19ea-53a4-af86-a9192a950c96@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43f2fc07-19ea-53a4-af86-a9192a950c96@arm.com>
X-ClientProxiedBy: BL0PR01CA0011.prod.exchangelabs.com (2603:10b6:208:71::24)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 608d45b6-290e-4749-6164-08d9efb7dc2c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1594:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1594FE09CAB57E5F44062744C2339@DM5PR12MB1594.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uhhDTIYx2dHWX8YywQQkdiWXYaq58VeAIjTldPJ1gEkgfjIhcN4MeUVgJT7AVL0PQ+wlAnSF3sG2lvpA6Nk9zdIkbEJz/QaTgn9NtXz0C1iz4HLPPXOt33K3gVN6Y3t4Z9YmofrtRl4NW/JIFrU7HzhGQ4QnCUvUVMVMjKCPT9nfPycZe33Lm5mqOohxfaHUe/6uJcs+Gl2skdfmxuKXqD9DnJxZCj85QufnJIt+L0zuOptLPNxTvxQfRYmpg3bjDIfB+fj1QVWO1HqYu5cBMM4kkaO5hDu9HhpdfnqA+vCFqouhqHjZbVT+J+YS3pAS58AolMDNIDNa0do8NHXjV0XBD+Z5HZIYut0zxXlpcSu3cJ2cWZ/gqPZTPhMRxRtDP+e5xSTWTdDs1gREU47MjgLJV/wyUX4fdW8qiuD9ZKtfiMMZXk3oTeTKltUI3zaK3qdW2g/N44932gZTiLZVsF3O9LQiJ38lXZIER4g5FN3mW4zO8I0aUETyeh4p6ri4W5kHTzxG+wsvSEgKYJtqeCSWHBa24rcTLdMVCwwHIYlSASqzH/UjMn6LB7m4bVdny6xa/nT16qdpskWU2rwcQD2q/o0H08Kc3iXrFSVwzN4Sz7peGDs1pSXMb2Retu1Pbpj5MnGK7GnANvmzm3uvR6spqbfdAt/RDT4LaDxITOlRH64PwuZMa6wv5vMxOMvWG708b1uIUDRdAhXf5dhuCLN9LLdWJFVyyEuVG8HpoKU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(966005)(508600001)(4326008)(6506007)(186003)(66476007)(7416002)(36756003)(66946007)(66556008)(6486002)(8676002)(33656002)(83380400001)(5660300002)(54906003)(6916009)(2906002)(6512007)(316002)(26005)(1076003)(2616005)(86362001)(38100700002)(53546011)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OfwFlmdjOo/9Dinmk84pjtzz4qIKYXQ9kVBdGE++l21T9w4ztJH6oW2T9rSy?=
 =?us-ascii?Q?WJJUrhKspOzAGbMHhFQBO2ra++mS2iYwO5EOO+zrX6BMbFB74K9zpyUUjaD3?=
 =?us-ascii?Q?g2i7TvRz9ThinOHZRwr5g63vKGaya2B6/ISmf38Bw54x48cRlUHMpwY1cAE+?=
 =?us-ascii?Q?aeKgJQTz7XURfdYT028gFTzJdHk+s2KbFraAxZBse442FKpPL2ll9v2Uonj/?=
 =?us-ascii?Q?uq00qocmp1f8QqwyD2XoAGcdAeFLw2FU2UQKPqHzhEHuFCWdqYI1gQ87n89M?=
 =?us-ascii?Q?xy3gxByf1OMAFVswfuJJp+ByF25Bf8GPyrIYdgKT9+yZGCaYM/Bm/iNMov5h?=
 =?us-ascii?Q?rM3Rx7uHgDAeI1E6FAX9Ut30unwG/BSgXbIcFo5OSYnaf1B0gBsWiIrifrTk?=
 =?us-ascii?Q?qrObPBhBrexYXakfQkCWE2EU4zbzDgj8zJM8Aspv25POoYYJYRD/EsEImlxR?=
 =?us-ascii?Q?4cE506xGhHqIsU22BKISWxrUYVQsleKJdwrghfBoSqqmLT1N8QgGbUKCvYVI?=
 =?us-ascii?Q?eo+9stQjqWe+jJ4+HJmGQqjhILHaTONUfy+KuuNSjtBpHtBAuxJ3EqEPM3U/?=
 =?us-ascii?Q?9tHRY7YGOsMPuBZcGihtQQlOXtMuFqj1hLmSrovWUrc4esQywTqD8uoGWe4b?=
 =?us-ascii?Q?ANe8cYg4Y3PutA4tifiKcq/FuPUuVMBrMw+IPcs0desbHzAfgjLU1bdc+B2y?=
 =?us-ascii?Q?Yv86+EMz/q0iK6uxOmA2vAxXwSkCUTiP/pnCXBsYt01T4rv8kRWLf3FWtOoe?=
 =?us-ascii?Q?NYzXHFRxEpM660VhxquCBsn+rCmc4GZF1fN3JCmG5B2eOoZoyd7hc4rd+WEa?=
 =?us-ascii?Q?Io3NusV6ixLF8zL08dr/xm1hWZaP0QB3KHdew+lQO/xoONo2lzuOpwZexHRR?=
 =?us-ascii?Q?1v/nBEg3AmuhH/XHKeeHbAsHYkvkpOWIMosxd1l96giireWdYYeKDVcuZhVu?=
 =?us-ascii?Q?105Xelr0XTSAeaYqc5VlXx2xEgnXi2uq+r/cpfsqC8HTSzbCjbAoS/v9273W?=
 =?us-ascii?Q?AfmCJol3q0lYSJxI7mTsMZhqLTbZo3NofHNTNQhZxx1J2M4xhpnf6sXiwwOu?=
 =?us-ascii?Q?/840rOzK48+fvg7zN4jaQ9ZT1FoPKgTUEBnRCxQdVYvPgPwrCnt0h1QprZJj?=
 =?us-ascii?Q?kGQP89b+Eqnq64JILaJ9Q/wFquCeJjlshed0z54K5e0mXCwKE9igRakx3MgD?=
 =?us-ascii?Q?ZXADpCZrCfty3Q09PpLaeK/SN5SJ4Anw3ir6lcj2X7QOkW9Q5bjoMOuPfAJM?=
 =?us-ascii?Q?HNUJjxHjuh5hlQF+VGk8SUqbGqSUkW5EuyBerS5hZhGnrglN3pooAuR6bJ6s?=
 =?us-ascii?Q?YwCX/bWt2WXXJ1jpHxl14YqnfZNTUkgBTiSphq8HfM6CgC+PZDaPuCFW6duv?=
 =?us-ascii?Q?Rz2hWazPqAH8ygl9us12Wm942wT8h8t0MqQKy/mUThQjiXLOve6jsBFziCec?=
 =?us-ascii?Q?neU1rfvPt1aChWNhG406u4in6xLXown7/7dcsbP0kIU7H6o+Mo0Dbxgaz3sk?=
 =?us-ascii?Q?a4TRpFIYmIZHsK/AmbUYYhR9lbo62ivffJy3kfvtUT5W431pZsaOHVTtz/N6?=
 =?us-ascii?Q?iYcHumnV6qpOH3HE/Kw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 608d45b6-290e-4749-6164-08d9efb7dc2c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 12:45:20.4241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XTV1GEGPhCLnkg07wfovayEI6RB/5t5k0RUvggaO8975iw+73adManUZX5Gj7xDD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1594
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 12:09:36PM +0000, Robin Murphy wrote:
> On 2022-01-06 02:20, Lu Baolu wrote:
> > Expose an interface to replace the domain of an iommu group for frameworks
> > like vfio which claims the ownership of the whole iommu group.
> 
> But if the underlying point is the new expectation that
> iommu_{attach,detach}_device() operate on the device's whole group where
> relevant, why should we invent some special mechanism for VFIO to be
> needlessly inconsistent?
> 
> I said before that it's trivial for VFIO to resolve a suitable device if it
> needs to; by now I've actually written the patch ;)
> 
> https://gitlab.arm.com/linux-arm/linux-rm/-/commit/9f37d8c17c9b606abc96e1f1001c0b97c8b93ed5

Er, how does locking work there? What keeps busdev from being
concurrently unplugged? How can iommu_group_get() be safely called on
this pointer?

All of the above only works normally inside a probe/remove context
where the driver core is blocking concurrent unplug and descruction.

I think I said this last time you brought it up that lifetime was the
challenge with this idea.

Jason
