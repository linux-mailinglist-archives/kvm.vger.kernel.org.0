Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98A17CEB0A
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 00:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjJRWQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 18:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJRWQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 18:16:38 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC81C111
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 15:16:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JY9Z52FmgIhFW1wy0R0fgbY39Mvcoj4/qNG8r20iQICPWVkbrHJ/lBsZO6YWJRR9DdGtli6yFT44qGgA5+JhrTUrHJYU+INoCVM/h/OjauDbiYxPy2HUhynaRkk8Gm6Tw4eClzriyiIgx6LIdIppDZtUWObsHR4sVxs/wxSU7stqaWV+v9kalQguowi5cjhk7Qte3Hm1XcE63ayAXoWlihypJheS4+DTB0dorWyfg7kAOq3QrMomr4dNN54/To47knFKhpuz3NEbU3qZsRrvnfgYHR2rwTc4CSlpII1p4OQNhuTmMcAMLsGdT1Jsw9o5WvmEzDyddpiWeIbC/tKLxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Map1Wr18jcakVyQUT7YcPQwQW+/UYLaZNa6hZ4Khd4Y=;
 b=WMDkGXDsuh4Jo9UmSdGFRhjVZ6R+YEB3ZMpC1TBKcrl5BlhJBoxMsqJlZdCZSdepQFqEgwPKG3ApVhmEp2iRFWpTuFZcuxXCL1AT9MftfoAwnj0BS3V5Wm3wi4UOvFsDnErI5cYqu2xYmnRx1DIjtlXnGcQYMEeEzf4aASHjLpmyWM+C9mdiomsFgTVbYSoW5WZVYuCOj6NFq8ftPO6YjEiRRZtHCkvND03XsQ7vF8ZkQCifpiHzkMtjlayPGM68QWlWyl5H2vW3rC7D0EcUMccGR+05EgpakZoPxu276bjjkPv4Wj3AAVcI5nuT1AJ/n8qn9cS2rQg5iTaIVcp7OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Map1Wr18jcakVyQUT7YcPQwQW+/UYLaZNa6hZ4Khd4Y=;
 b=r4iDAXZsaDe3LdnjZ802v50eDysHS5XI6leGTjt1JoxDPebZqxFiROYrX/zQ72LXqid9/bWhTQz/avXdCGowN8KVJdNkvocOBiwVjnGYYWyQ9IDSwmPu56zF0tZ0lgnnaRvFj96izzWzZSFBp2pNcoblfe4N2GbhGE/3XnHlcmcSBX4tPHVQtDdoq7aPKM5AbRlTPrv6CSmeh9bQqUsPus4LjEsmiqpY5euk/zm1MkvmXzYeIjb1NFk32WmyXhcb1/S8214iTwVuT/rjXM/accVswl4SJKiVvDLWcQGoVeRnqVVsb0nXCz/L5k78FGM1d9bS/qX2qRaJBoq4hA5K0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6136.namprd12.prod.outlook.com (2603:10b6:8:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 22:16:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 22:16:31 +0000
Date:   Wed, 18 Oct 2023 19:16:28 -0300
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
        kvm@vger.kernel.org, Brett Creeley <brett.creeley@amd.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH v4 03/18] iommufd/iova_bitmap: Move symbols to IOMMUFD
 namespace
Message-ID: <20231018221628.GH3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-4-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018202715.69734-4-joao.m.martins@oracle.com>
X-ClientProxiedBy: BY3PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:a03:255::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: dbfabc43-e122-481b-79d0-08dbd027e194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QiCE6eXjVN5Az8xlMMhxqXE21hm6n/EgL/XnEPXYCp0ydKsmFpRwTxWCLYksPVkCLj0gR0PW+bHm8Uh936lOnoKEcj8+FXYQ2B9zv7HcLGRw9JQDFcbMvWvRyEdwMrAEvOiYAmqlyvNo0WjXpFJ8qvdOZkP/j4B2arqb/WvGFFzXh7QrFdek38WDeNSxbMn3XDlwe0ptLEb19sFK8AhMFjuWB6e3ViGXYlHeHkIPQgQ+k5GR05DsTEiX4iQGEte6GxoGW2pWgc1qixCDTqptrAyUwE7owgdJ8vHmvPNv5U3Cz+tACF7VekGjhOU5fAn+4s0l3q47m45Z+GZ3cyD0wyskbka3vzO5aTHHp6Pmfk9XCa2jcfV9UDaN2Zxx3QF82FYRYmSoKnt796SfokJcVquAetVcPR7EZzBzAvC8uXg5U9g9O/7MyuRCOeLzyD+tqvqrVGkc1hktJ3J9EvSSni8/Nd5ZN85nZJu/VYO9SVHJDao5oJ1OJHoWlHacjIMlM23LjeKa5ebf2ncYctqb3N8OFVHG7YElzGv4lXALxssmK8+P+e0kdrBGEI2ISWxV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(39860400002)(396003)(366004)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(36756003)(6486002)(478600001)(66556008)(6916009)(41300700001)(7416002)(66476007)(316002)(4326008)(8676002)(8936002)(66946007)(54906003)(5660300002)(6506007)(86362001)(38100700002)(6512007)(1076003)(26005)(2906002)(6666004)(83380400001)(4744005)(107886003)(33656002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8t51MILXojkNxAcroEw9Y74GbMsQQwca1IFU+s3asyXBGlwW3WuwwU/qCzr2?=
 =?us-ascii?Q?WrbrdONEVOHUQFMBQ+03KJ0G9EO5uhxlDCZ0Jiagh80QWSEzKm1G2jFMWn2v?=
 =?us-ascii?Q?esA0lEI1lX95VRUwN/jY2GyX/w3Kynsk0+a73O9rclrLWZraJrZjL1/HFOTG?=
 =?us-ascii?Q?7C2+2oLNlNJvtof+syRHwL4tsgx7A0XYdI3lvDaWd/BKVQNII8xGxApC7V9Z?=
 =?us-ascii?Q?PfbOxA1B/5At2XFb03g1mxjvcd9MOViW/RStDHs6bPrITjBTPSFA4+4aFXQ3?=
 =?us-ascii?Q?s0v2lAs1ZJGzHRIY7sNU9Pe9pJpN0Ty5xrcx4JfCxkvn8enLYStytcQ7yLZw?=
 =?us-ascii?Q?eDw0I3sYuQUd5NHTKoJM9Z8+2EAK/ORH+di1v2DH7cnyFg8xuvq0k0xOmyrJ?=
 =?us-ascii?Q?WSNTYm61cbH0dpioEsB0Ru9BD8CFsGJrYFaiRJ7GfNwO6VQVu4Y3o3SvRkNu?=
 =?us-ascii?Q?uQDx0HoobpOY8YunibbWkH3BFIFS38Dx2VY9gRHzewk28prgGqJan2afRVUW?=
 =?us-ascii?Q?naGvox+NWa6PgqPak3DclPxV1SOQm+NUGQ2rpadgRNyEm0INHk1Oe6sPjtTa?=
 =?us-ascii?Q?FCTqSmgM15USlsnuxibQhOOoqHoBBpk3UAkCjvECu/HGB7CNI8MsvciqBXAz?=
 =?us-ascii?Q?PHSUnxX1mA/9TWQGEvyEO6MlfmPWpCcYVNlKzdnvLLZ+11taJdZy9abbV6BB?=
 =?us-ascii?Q?01Hxzsfxgx2amvyTJ/JmxgwJP1FZM72rlHofmSOrI2MUw+/TZpXfsJbZ7VMt?=
 =?us-ascii?Q?mhwtvPnrgL5bMopQDNjfd+xxKN/B3Ysa0SyLeQuVsouKBCsDY67c1L1W5U4z?=
 =?us-ascii?Q?lMqE3iRQ/Sy77a+zFDpGc0b2hrAtD8veAbXR6wzteyjrpZIJRdDH5bz91Z8P?=
 =?us-ascii?Q?uk5FHfCdiPWxq2KxTzP/WnxNpNK+iPDhQKxEh/u68OG2qMDZ/48t+hqBRfv/?=
 =?us-ascii?Q?U2EkFGlW5Sc32X2SgNWNX/HgUzDGu8elkTwEkF7FlAFz8zA84bywTIi+GHpV?=
 =?us-ascii?Q?bznM5b72LK9YYldFG5B3pVXNqwkZjoQa53jPvevndR7A43udI6RvHnmoWPZK?=
 =?us-ascii?Q?Jze7fqEYMIG60jPAs4TNd2Vbr5j0knwQ3khFSY6TRpcB8gZUB6Nk2Ei6oy30?=
 =?us-ascii?Q?qiZ8Pzn+iiWEdlQxoo061vFpKnnDgtZyo1/z4ONDnZEawKZ0xd5hQKtQ1kh1?=
 =?us-ascii?Q?Ki9O7H9OK/D+hgp0x8UmYV1L/x79IZPL9daK0OEwuLFNYIG0NDlcTOqgVo0l?=
 =?us-ascii?Q?yGIdo6EUoqpiysKjWsr3U1PG3nMd/6xCmGEAk766vIBz3AoU1F2Nt2t82Ve1?=
 =?us-ascii?Q?UgEi185N6GLgcOy0WBSiuU2ItzmVNJIadSgp+Qxw9TiXQHP0bHlW2t9Jy2z2?=
 =?us-ascii?Q?iQY8lu6GFhK9JQcdGTVPgzZoPj7eoE/UHPild8pfgm9qEkCdUHv4zMdg8jJ9?=
 =?us-ascii?Q?KL4rid/ug3PQeRDVBUQITCDaNOsFugHFlg/B9AnKPpK8r+Q3K1hxeqVg4Z3j?=
 =?us-ascii?Q?fMHiD8/lWLYe4WIqAHswz5/XTzFiFftr6Lp2QWgFyOzwUiSaNr6LhmIriXFS?=
 =?us-ascii?Q?e/3hUvJUuzU147rby9TGse7mPVn+Z5zDj6fqZ0Ut?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbfabc43-e122-481b-79d0-08dbd027e194
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 22:16:31.1148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IDjR3C2XGm1sO3p6cKgIdURe6EAycw8x317+lFBBo4eY04/XE4r4YLFhiAQKYoJ9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6136
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 09:27:00PM +0100, Joao Martins wrote:
> Have the IOVA bitmap exported symbols adhere to the IOMMUFD symbol
> export convention i.e. using the IOMMUFD namespace. In doing so,
> import the namespace in the current users. This means VFIO and the
> vfio-pci drivers that use iova_bitmap_set().
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/iommufd/iova_bitmap.c | 8 ++++----
>  drivers/vfio/pci/mlx5/main.c        | 1 +
>  drivers/vfio/pci/pds/pci_drv.c      | 1 +
>  drivers/vfio/vfio_main.c            | 1 +
>  4 files changed, 7 insertions(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
