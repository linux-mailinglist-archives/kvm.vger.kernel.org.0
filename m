Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE81F5B2612
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 20:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbiIHSpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 14:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiIHSpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 14:45:22 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0F963F2A
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 11:45:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoO06UL3zrWOqbGoZwHhMc9KC/1grdzLUlgbWp3PcT1JFZm0OwqkZfLhJEFQsxEYgxqCoUBMdL0E8qKjFlcYmWIlFmekMQrZ9wHbUBw2fjMSgS1/agpsVUmh8C6S3j9sZOmrqFVdeDFk3LGu3y8+mU06dqo9RT8LwmGxrARjZOVPyQUaF8o7LPEHQXKkLpOp6gKF4EJi4rDpKTzTaLaCgzv0QvVX4IlYbucHcMc2JNnWJJZYbiIz/jZ90H1ROEfLzewdV2zlxp5TUEjT8ZIUPhHXrwrtKXT7b22B5XMQbToEjhI6sBHoESSp4PdI9epXDKQW8EzHBZNIb3RqB7u2rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGSxrDWuWea4mZUgF5uTy39GVDVk3X69gWT9+hjlxb0=;
 b=OxLT+o9yTSCXD5H31RhAlFfhCmybVDmBwe+UKeADLG87HmnSsY6rtgf3WubCX5K4xuzdTAgzlAUwT6AmRh7HenB78J25W/7NfzSUdTJ6174OzClAg1EO3dLpIEjS2aIhso8j7etUhEt4QYO1uScuSBJ3tl4lU/2RGlLzzr9t/5vv9ErSYpUMGlY4X/Z3kvKUY63U+jMPHBBC/7U6+1NR6Yk3MElUBAg+j/BeFug3bw5R+B7Z6KvkRXhYhorx63mDYj2v+5nH+0WozO3o7Aj0bHMhYB02ZzZQfvSnkQloVa9v8BFJX7YROk0RPQp6rl4Y4VxK+NE9xQfCWZSakCMZag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGSxrDWuWea4mZUgF5uTy39GVDVk3X69gWT9+hjlxb0=;
 b=OivFbSOyOXj7T6gwGhWPZuZIDboioHIY/AbmoP1aKOM9z5i5QMjA/yrA3srhPbBfeR2rG0S0XruUf4h6/u6BjxqlafefWkMmcFRM0v7q85OQadfkxiNSIETs7keu/7uq9zsYx14/Uvio5DkG+6s2tk7oktY6sSsncdIMrFfaybrayyT8jCXK8IVOmqq9CBiyjcrPBAcTzusbsMO1VeenQodWxnAmzmIA8sZSp7JcJ5TrNf5OxxORx4swEWzmASRngaDbrJF6el/h0RScjM7eyXZxLUhvnDrlg+Fr7CPRcaLZKq6iNMSjMDeC1KNRR9yCHXKmOnjb+PnkM3QiJ2uCBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY5PR12MB6429.namprd12.prod.outlook.com (2603:10b6:930:3b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Thu, 8 Sep
 2022 18:45:08 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Thu, 8 Sep 2022
 18:45:08 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 0/4] Fix splats releated to using the iommu_group after destroying devices
Date:   Thu,  8 Sep 2022 15:44:57 -0300
Message-Id: <0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:36e::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|CY5PR12MB6429:EE_
X-MS-Office365-Filtering-Correlation-Id: 294d8d09-bf07-46fa-c29f-08da91ca3da5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MNxcRtA4HWDhIDAmBJLCykvnKb3Ggr4zPAZALOAf9FyP8rZEtJZtoNvY4rNLiCt7SvEaBo23LKaCt7Avib2m8luVWska780q6JnbVQOePmxMzmcooTI6eYe0G2u8SezS/ccNSuxcLzImJyrGfkZE88LdM+uFI1z4jPKy15rO5RWKBw4tzO6yad5a4+S25C1vYjpykTqF+oPNVqGTN3aq+7B8l9PQipkE0MVbhIHmd4z4fepjxCuCw1AFrYoWvD241nZ/deOB3JvKOSp/3WZPN0N6KT6HJurA6Uub+h7Zi3JxQNSTKTIT+0axqL0p+S4b2MWs0OdwVv6akWsP80xjI801z+GYJ1D2XwRfFb4yxyFfH+IGFBZvcTaWBQbZLvVvu9QmcMuCANrbzC2YUKkz9f9S3VO0wZHa06lyUJBa61hhPdU9Uvev9YcrOB8/nuFVzjElsn3Ofu5TMCzMHN24XJou7MyDkf27NznNfdO2u2Oijo71vNLqILWVtkshmr2R6fmcuOCuPmiyI3nFn6JGlW41D17RhNvd/KAd0EcBuZe42TWRngo8tjdUJUauZ/qkXuG9LYIz677RKsCbqVLjodUDg5uWTJElMWAUxoUjj5qheIB+aUN/bYn+CkyV9tdrCNEDJDTh+NJrB4p/OAGsi+LnkfaPJRMRjIGyHVNHiq+tLb7AV4uK/ap/q5Z5d5cn1vg8gqn/ZM816jcAHbgPPYf7PBDWoAY+dsCRvxv7hjsTKdn7cjbTY0ciHdBZI2XKl4am3IX4lpuhV6GTK6ia0dZspaX9tYomnuIzhWXHOgRUSaReG6ab98bjNgBUghsc8iNxy8EYPcLhS5FFWNxndA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(38100700002)(4326008)(66556008)(316002)(8676002)(66476007)(66946007)(110136005)(54906003)(41300700001)(8936002)(83380400001)(7416002)(5660300002)(2906002)(6512007)(186003)(2616005)(6506007)(478600001)(6486002)(36756003)(26005)(966005)(86362001)(6666004)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+bK+wqTn5cPNExHv3dlGa3eRH8PW7MshM2KLbMb5B2AF1ifqTSzyJPVmO9ru?=
 =?us-ascii?Q?Ft7bZSTx9YNSCA0vR7NtKQfhjoAKP4ybQO1S+ptV69RhY+/HYsHeCulWqgAn?=
 =?us-ascii?Q?W+O/J8bfFLpoIOSf+vAzd6s0Jl3t1f2BlaGIgwX/WuMLjoSZLxWhRblNRe75?=
 =?us-ascii?Q?bRDvwBXGqi7G046bjC8AitOsu3czzzW2eEkcx3CEfe/N08261R41IHt9HBdx?=
 =?us-ascii?Q?BirO/VPb+SF3NPbu6lGJvXpgNYica2o5yj5CKzOPApjak9VykvXVBBEylpma?=
 =?us-ascii?Q?Xp4bA6KyWL8ZZnwfMfehF0IOvttG4l2eWgeS9JMBLVLR0ps0NCerEtZ7p9PP?=
 =?us-ascii?Q?YzC79wtVzuukx5Bk6BYSFRaTIzpATI2y5R7f4K9EC2KPFlaPpk6aJ+yTyxLn?=
 =?us-ascii?Q?fqNY9NvvyHhzoCUm0w0WOUsSC67izuYs2wUu+Y99gfRqQ2iBi2yYtniu1HBC?=
 =?us-ascii?Q?7t0JB23Y4h1ceC1y94y5gaXsJCbIFxOLKt5jMtRLbu5lveeKCwvuiQPHLdAO?=
 =?us-ascii?Q?4Ec7+72/WIswxYy/aAIYRGI5jO4PuJjpC58AY0CdGPE7zzZWOeLyN/IsMVYk?=
 =?us-ascii?Q?ii7k776vVJishGLX1OPYCLIPYgWwWdVrpj1TUzmF+IXJaH7bNdw8nWh8aN5f?=
 =?us-ascii?Q?wPr2MZWz2ADZjK06QD9JbNmrwEK+MffeeTPipeRoF28+m1H/zI75mj2kHJrG?=
 =?us-ascii?Q?3pnKEvupBQMbKhLB94nLrZm9G0ekE6LLx/pItZmz14rfDVbgfAOb9PRUVmYi?=
 =?us-ascii?Q?lCISWdyenZwM2wwbVa38Nvkzmtu4yeaItlccTSPveqbWkGizuKvOKf1VSEdb?=
 =?us-ascii?Q?NispRQI6V7FJZn+7kEJVhRdMJTJPShz9elHEqU3xW5vofDowkp0iGZohodcV?=
 =?us-ascii?Q?W0GOVsIbpUOo1TwiaQtuZyLzOqldl0goP1tTAoGS2PmfyDo/3GNAYKWYmfNa?=
 =?us-ascii?Q?yfhDIANWeydO3NP+bsVbgxeMubPPithZa2uZh90Lh6mVfP9XUlueBT++G08g?=
 =?us-ascii?Q?2WzOxE6rvxKOIr/9Kn1psVLQPMCoPfXDLNlJ8GDAuv9Kob0/zN8XeUp4wEtE?=
 =?us-ascii?Q?JAuu7vCZYVWCb90VbcLjwgnHMGarFrxmgXa4sdinJJ3HLEaCZWWbhXdkCoBZ?=
 =?us-ascii?Q?z4r6G/ug1jdpS/zI63NZN5FVcB8rKKWs1VBGwkxtP/HTCueEh2Gjif3zMezQ?=
 =?us-ascii?Q?M/sJYLn2GVBmcoU68tmkfzspE0f8RxbYUq1oUQYB2whdm+Qzzf3w7o9YY319?=
 =?us-ascii?Q?Wg2kvR3v9dZsBkfueC1VtrURRQMS7bBrZY9tg3z0dEHvE4wSyzw2Z1ky5KiM?=
 =?us-ascii?Q?yCyuNpx7hNwwMwTFln3REOfyePWj9oU3xlTHFlRjH1GnqdoPrHtZN0Y+a1v5?=
 =?us-ascii?Q?807Gt4ooRb600LEUEZDNj2ACeN4oN7P8JfxpjqjhbHJXi4cRJSyrNI1fS5u8?=
 =?us-ascii?Q?mKAiHNkEsDDN3zOK4eWKVev/QdxFufFPe/LShaQOFO76R80oOiNnH/yI7NBp?=
 =?us-ascii?Q?ACCnvRrDiaiEyALjYZ70FdrutyprLtiKrB4MllJ8Lp/+Y5nSNyp5k4tXybpW?=
 =?us-ascii?Q?L5l2ghTrqSi2gl1ZVj/z3YSsT/n8438P6WsfIdEZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294d8d09-bf07-46fa-c29f-08da91ca3da5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:45:03.1447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZHh2YIhfimWXMkrChFlk8qLACUMxHx2sKN1/DPvihdnBlB0mYPf/Pdi1yU9fM6lQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6429
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The basic issue is that the iommu_group is being used by VFIO after all
the device drivers have been removed.

In part this is caused by bad logic inside the iommu core that doesn't
sequence removing the device from the group properly, and in another part
this is bad logic in VFIO continuing to use device->iommu_group after all
VFIO device drivers have been removed.

Fix both situations. Either fix alone should fix the bug reported, but
both together bring a nice robust design to this area.

This is a followup from this thread:

https://lore.kernel.org/kvm/20220831201236.77595-1-mjrosato@linux.ibm.com/

Matthew confirmed an earlier version of the series solved the issue, it
would be best if he would test this as well to confirm the various changes
are still OK.

The iommu patch is independent of the other patches, it can go through the
iommu rc tree.

Jason Gunthorpe (4):
  vfio: Simplify vfio_create_group()
  vfio: Move the sanity check of the group to vfio_create_group()
  vfio: Follow a strict lifetime for struct iommu_group *
  iommu: Fix ordering of iommu_release_device()

 drivers/iommu/iommu.c    |  36 ++++++--
 drivers/vfio/vfio_main.c | 172 +++++++++++++++++++++------------------
 2 files changed, 120 insertions(+), 88 deletions(-)


base-commit: 245898eb9275ce31942cff95d0bdc7412ad3d589
-- 
2.37.3

