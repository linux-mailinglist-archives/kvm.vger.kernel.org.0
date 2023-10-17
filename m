Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6637CC99C
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 19:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343878AbjJQRNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 13:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbjJQRNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 13:13:49 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2085.outbound.protection.outlook.com [40.107.102.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187C4AB
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 10:13:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Quigo3pM/RJeu8YM6UKKpCJ0Q03zQxsGsk6W7MBmg3iMq9pJGdnQDKxfs2sH3hXgPUYthtL4T/aHp3/WJNZgLjP8fBr17WqGKSd9R1nB2zienkXjLymGl7DwlL5I3m7YQpz1o/CV6hPUbATXr7QQ/oIGdsAKRtPPNpKNeJ7s6c3gzx9jku+xi4pNpRmw3qThVyGd8Ll3fSZLZCANO6W1qkgSjn5yieaiCV06x8Yj83eoUn56x58d2sjrxHtb6JOB8HAccmRUeIz+/QZ+TTxGvXx144Ysd+VjHyBIHxfKIvOF/jGYDsiViMrwIXnGOHMFHTfUgwRvqvKpFTb7Qtx77w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fthBAnMfNspI2pESSRos2OrDU6QEusCH/ZD10hc3Dfs=;
 b=Vs6Ji7Dm5BtALcNLZqs1sT6HchPaObPBK014+k8arN1upVUPHlG3iMcl+tLQilTCznZMq9wPScd2qOqYD614+S5P2hIm+EWzTabyr/Ah2W/gVh69oPvytn0eyCj5j0sY5rgnKQu5QRw3IO7tl1R0ownGnemHgu1+BuiG3Fx2aGq8duBE6dV8s3U5bzG6tsnXq3BKWYJTou2dZ5F39hiUTW1jI152yp2xSprA+9uiPJV3wrtxyzVpI7rWMPdgti26nvFeahq8xn5WpgJCEt/lXjIjvbxxfbFdaBi6YDUNImBUHiy55RMOa+IRJChDb/Bq3m1rXMLGX0BqiUKQwEaAKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fthBAnMfNspI2pESSRos2OrDU6QEusCH/ZD10hc3Dfs=;
 b=pnPJOyVLU3o7OgRxnvoFbMbMxAp+o+KFqLZxilLuYNLT0xmN25SDPIdz9Gt52hyK8zmS9VtZGEe24bIrEkUjkf57uHaJibY8r0qyF2Hp6BlyMA1EXG+57UJHMBxikMCw17ZsADejVnOtTHvDfJ9v7ekDa5oC+IQO0vABPTUjBsnOe0tpYNqUmAtmcJfHO8q5SNQ2avYMQwpN8ldR9omkJdQ6cQY9yY2ZdY3j3nviQ05x0cJJLM650mTJUBeRL1Y6r6fXtGdmT/OejsjPoHRtKIQZoYUNIMgCzi2gc+2M2oSkbZ++8NcmSKq0DEaFQ98G7bzLiTdABTUn+elBTLDAlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB7625.namprd12.prod.outlook.com (2603:10b6:208:439::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Tue, 17 Oct
 2023 17:13:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 17:13:45 +0000
Date:   Tue, 17 Oct 2023 14:13:43 -0300
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
Subject: Re: [PATCH v3 07/19] iommufd: Dirty tracking data support
Message-ID: <20231017171343.GM3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-8-joao.m.martins@oracle.com>
 <f7487df9-4e5e-4063-a9e4-7139de63718e@oracle.com>
 <8688b543-6214-4c55-a0c6-6ecab06179c6@oracle.com>
 <20231017152924.GD3952@nvidia.com>
 <df105d06-e21b-4472-ba1e-49e79f2c0fd4@oracle.com>
 <20231017160151.GI3952@nvidia.com>
 <765e01f2-c0c5-4d6b-885a-e368e415f8f2@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <765e01f2-c0c5-4d6b-885a-e368e415f8f2@oracle.com>
X-ClientProxiedBy: MN2PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:208:d4::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB7625:EE_
X-MS-Office365-Filtering-Correlation-Id: eb557056-8ede-4563-69e1-08dbcf346b42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DOx3wDkgxldrtsLeEvnj8NFrDKedJBtGBSK4I5eVhwxe9npqsIBZmvXp0zw0XdsfYBxKsH6Qy4d6TVLPTyaL3j6DXyMCBZPmjA2eqYCD35i7ukWvO8QknBgMomzTxcY5XNnrvVEYuJUpUVjtOHjEukZgkRD3AFXMT7HxQTp9pacPuC05FUNexMF8jfnmNahXfdBoLCM+GKcjSoE3815zVtoDN8CLy9TAmcSAP8YhQDKJBuKeTgcnT02snkfIpGp1vApOv5SzcuUyMa4cS7IYO5yrdWRQcpwTEprqL4Ed1W7KboajJlzlAvduusyv9gwJk4iugQx1QrGcbmO5DrEUmOEFM5U6KgSiLnKTUViV6UnbXaI/Kzt/AZsklCTAa4gxuqys++PpAOMLMr1ARcc7P8dx62ECFQJMwZVgK7bgyjGff0rUHoGKgwp9/xNjfvcMqN4YN+aaJ2X8M+HmrrKmw1OiAhw9iW6Yik3SV4LaidBsvTlmnCPRBKAz+usrjvmozvvUQg4B/vhHqSrQgdq99vza2o0tH82ZvHPVldvyuStLUJRlT38YKd9KtbJPhe9mcICjhaHthjhWtWuTQCM8zgU8UvcMrS5ftNRafSxKuws=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(366004)(396003)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(6512007)(26005)(2616005)(1076003)(6506007)(7416002)(8936002)(316002)(4744005)(41300700001)(4326008)(5660300002)(66556008)(6486002)(2906002)(478600001)(8676002)(66946007)(54906003)(6916009)(66476007)(38100700002)(33656002)(86362001)(36756003)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MInveJB2jO5J4GNweuDsLmhwX+ZCGMaOt7e4jQQrs2RLmuTyLK27fECA60/X?=
 =?us-ascii?Q?3YVGvNU9LXnoJ5N0YHKYacA1Ghtr8Oou8obcQQSFM0NpPKEhpZDzvMQK4KNX?=
 =?us-ascii?Q?/vJRk8OzNuoxCQZEJ4+xfqGy4MLRV3PcJ1Z/CUUBVuADNVHwEvImP7ePS+dl?=
 =?us-ascii?Q?35S6cmdWl8dZgw/U5At8X5XmNi96bd80aM2HZdNMPGie1xVhq1ch1oX5e+gg?=
 =?us-ascii?Q?G6SIQgn0OCebPdrUzqW4JjKc+6XJ5dL8kAJTv5BJzzrLoZ5jYVHrVgFUR0tA?=
 =?us-ascii?Q?Jm12mUNErgC3ebjUL2MbaS3bE48mTmgprsCO8hQnpgksVCQ3XqLIsOvFbAkq?=
 =?us-ascii?Q?fU5fjR+qCj5NyUVL2DIwHpitCsYnxKmgoPVN0+8LZk/qgHYOGP00aWvSeqsj?=
 =?us-ascii?Q?zJfBP/hQreBF9Iv7PqGV8F1dn6FGR7asroz9HuVcFoPZV/0c/lCMFIPT3mCm?=
 =?us-ascii?Q?axC1VpiuFdYpXlFhr2oN7QNuGkq8E4HNDHg3gUx/cLvNJN56GoZO24yiI94y?=
 =?us-ascii?Q?dsISJ+REhB2AfUO4ub48nn9YQEjj2Sj7UgNpS/GltFX7zFPa4iDgoZ/3x3F7?=
 =?us-ascii?Q?f5NtHnGDHn/+ulDzngrv/SSGsMfZp1ueGfASNXApYWpG1DWywdxoRNz3Fy9m?=
 =?us-ascii?Q?QNuSk+JTA6W5PBF/y6BPqKxiHe9PAxXNkAPHAtqHk6+E2s4U3uMuP9b2rXKw?=
 =?us-ascii?Q?8KkDi9mefmnVa/RBOL5OLCPEW8tYo6lBoS0k+vQTJ5poWGQxmdV/cT6cPr+f?=
 =?us-ascii?Q?XPIXgVQiMelS9Rr6/V8L10QLBVqjG+qxAuKrp3bdFMWGn+MdSSDGxDCCSH4G?=
 =?us-ascii?Q?P9AV58nQXyoIqUopou3dd1/e7LmXckL5Rv2YwNKGkSIwUn2+AgTag3cKYEkL?=
 =?us-ascii?Q?qKfyGlCYgW1zgRHgkI7WJNz3Y+IqbnolVGyrmCidSLXcbwRFsSjwCvmdAE4o?=
 =?us-ascii?Q?JnCITV1MAEJwV6V6scZ7hg5iBmtihmHBrutaqPRBBREEkBps/UxUMQW5Q0Cl?=
 =?us-ascii?Q?R+chgyBkFEYiSrVrtg96gBW8O0Kw0SPSjat/GgAp14T8AwkLARYJaQ7/JgxT?=
 =?us-ascii?Q?Wew1ZvQYr2VL/euT2mdJ4F/0v7E0QVAOayTMbq4XoO6AaUlJiLs6g+BXrhZ4?=
 =?us-ascii?Q?JmKDSvSH4IukNGF42cWTIYxqY/aoLckloUmC3tF6cffEK9k6Hf4hTLDzp07O?=
 =?us-ascii?Q?pZKhcLbEnAvQgxdOz0tKUYhjD4d52hH6vNEdej6YjHzLYB7bL283VrBvatLG?=
 =?us-ascii?Q?yt0T2vFQziOBfIC/VBW0/LS2DJhoAdEjYuWsGsAeMxhuA2zjN7IYScIB50E+?=
 =?us-ascii?Q?GK5CJ7e7Gl7F76begeB4T2kza1iEYDKLMCi8PGcBkm6m/islg6z//TgfwwPp?=
 =?us-ascii?Q?Fy7JKydcNS6QjvctSJmdwLRiSYgSFZhMFddQUQMKOHvLTBfDbQioYRiXS0dF?=
 =?us-ascii?Q?oqykUrdcfQjXzm4uaWg0Vq7RdwlmqI62xEZno1fkaOp/j8iRC9SPlekCEt8y?=
 =?us-ascii?Q?uYPOREpgza9JwWHDYuBrIdNZ+BAGsaVcvAi2V0TZlwXPIFHciSXAD3UbJKmN?=
 =?us-ascii?Q?pdQEaVDa1DrSg/dwnJgMmXMxYNM5KexoqmZbSojc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb557056-8ede-4563-69e1-08dbcf346b42
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 17:13:44.9190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQXWB34z/dztlOu1cQwxevKJiEHG2JAo1vnQN9EtzyQ1X6x8LIqB/BWniKtWrG6/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7625
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 05:51:49PM +0100, Joao Martins wrote:
 
> Perhaps that could be rewritten as e.g.
> 
> 	ret = -EINVAL;
> 	iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova) {
> 		// do iommu_read_and_clear_dirty();
> 	}
> 
> 	// else fail.
> 
> Though OTOH, the places you wrote as to fail are skipped instead.

Yeah, if consolidating the areas isn't important (it probably isn't)
then this is the better API

It does check all the same things: iopt_area_contig_done() will fail

Jason
