Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936565F7D97
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 21:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJGTBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 15:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJGTBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 15:01:21 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411F41055B
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 12:01:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=art6yryepjwFShB3ZE34RbYkpJSyE5rBvOBr9mEoKbY4cS2hRtH48okpJMv3ZLJH8IVvwxpxHSkp/c4q8IuWQ80Av+9dwxGZbd8BZMa8lsYRrT585r1C6Jp9ZJYSAMXTyAHw+eqwcKV1GYoMCZolQVgOSroB0FjrYg6jQLsdpN3f95G/2T9YRDhuiKuLV/B9s74kpDBEgVSOTBF0HLQqsc5f66HprSH0Bflga99cpZWPeHu7LBBWRPAOiH+uywB7M2HGElHRU2kCRQt9pHsuyubWZjMoN2yTcXMUXP4DToyRejqWjexN+6GhDv4ws3tmE+KEJGpUMPyvTehTVkqMAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t3ka00m7lWdwa/05sB89TAiQ/MFq3gHNtorChGXMXW0=;
 b=KE6dQgYamQXoQS/7DfG4LaQtjIvtVQDL2S/DVRbUMlbsfioostHYSMGbrRZqteabUK+R73evajfNzqmcFgu2GXwEvNs3MuzZxQQ7kZopAdk9GgTZ21rb+iojKIDnMjwMEBIoRxJlSXY4NT3UgCQPQI6f6E4TQuDZQDgIncEAdgHi+8osMzjQQNE2Ra1UQ7e7ZQaL5xOOyuGeaC/bDBzeqFiRzFoVK/Ykfdfckaph9ftDthbbz3SdepN4DzQYy8mdzUH8DLaEEqKN/kcuOuRRqT3fnlPUmNvP7ON0w6/3gh/HkMRwLkTgMbrSFRBTmsIw730oqe8f18bOoa9e26OJug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3ka00m7lWdwa/05sB89TAiQ/MFq3gHNtorChGXMXW0=;
 b=KahXE6w7G27m3rJfGT5TiPpPo9nPgN/GftjO+hFW2DggoeOFERq8nXxWL3qIbQ0WLb5m7MTeA4qoNrORrtwTKJv7O6Z9ucAL1qaiPBR510A13FIXPll21rUz81uG9ro8VR3w+WT9QfPsbbVOFWmrxywEtA+knq2dMobvPlASLMVEYFlchEOl/H613izZNIPHxL49NU7BFBmc9yg1h/aZlWBxQLmnPjsZKgaV2880YUVzxHrx7O4nLO1wLUh8PRHA3qzPP93uJ+hou8b0I2d4IF2FGWA7757ggRSy8abr2T/B6wKkmRBMf8jr2hQwlwSSbvEA/LYG6ig0XJcM2Au0kA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5878.namprd12.prod.outlook.com (2603:10b6:510:1d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.30; Fri, 7 Oct
 2022 19:01:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Fri, 7 Oct 2022
 19:01:17 +0000
Date:   Fri, 7 Oct 2022 16:01:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH] vfio: More vfio_file_is_group() use cases
Message-ID: <Y0B3fD9wMEx5V73H@nvidia.com>
References: <166516896843.1215571.5378890510536477434.stgit@omen>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166516896843.1215571.5378890510536477434.stgit@omen>
X-ClientProxiedBy: BL1PR13CA0306.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5878:EE_
X-MS-Office365-Filtering-Correlation-Id: 071a3d13-dead-422c-0332-08daa8965070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jxd0iyi7YM5Shz5XF6ebyeESNBKGWvVXi03ViFkZAh1FXyshjLitvzp1jeMxGN01ibZYoonBTp417IHz/yu+pBX50lR2UtYDcpm/t5kglPM1wryfCBNEd8kcPhDSSHjpVVVirgLH8LFW5oaWViaGdGpkTQY1KkqxaDYZo1CaFYuJzyR0rPan6sMuzhQku9bcp13MvipIJHUPDLy2mhYI2giQ7oGxQOay0qEi7Z6lUlfvG5t715LsxZRB9n6M+Dz2m8hu+gHIZKdGr/eTPiL1XeS/Kg6O/t3m4S/gdR37I3Ooig8r7u19sX0VKDNLdryFRAVnXYQvhFBk3VEwXjbLC/U2Sy5MMT4bCX2MwChoyT4cZjCgv0/lRSkGIL4HNnAH+qL+hgj3ag1a7HgfhpsZH8gO5FMA3c11Ar7PuQ9uBzb9J36vaVa94HxBM7yT3vvgzETqpYXdArBvS4EnMnXJ/TVBICT5IesTHRGq7FPjmOMnXK4oe5V2A+ciMvmzxJztX1LKRS22mS6ly/WkPOQnR/ahzvQYGs8GhUzuusFxXHWju5DKn0G8GimwDzYBh2TRB3Gow6xHxXFdiyeUFElCIhWNClVE1V700GJxfrlhX4+7UGP+xXVCbT7evv29zPGSMlPalDw00uH1ablVyxB7qnGVbkIu7Puocsr4QMjeUBUVuAAh2oZQAuqoX/F180TRivcVxT0EeQJ6KQw9eOnV86Brx/naOsowoOVaxF6F/+2Z6VqVUkMM/2VApJ7FTwGyb4D/8rWWmfCDvD7rThGn0g7PvS31ZEmCuFl93qb8UKM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199015)(66946007)(6486002)(478600001)(966005)(5660300002)(6506007)(2616005)(186003)(6512007)(6916009)(66476007)(36756003)(8936002)(8676002)(4326008)(26005)(316002)(66556008)(2906002)(41300700001)(86362001)(4744005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XlN8AqluYVYY5qJiS4duWbPFysXU6WXiiP0pa3MiOqHHBO1I1Yj/kriMG5bc?=
 =?us-ascii?Q?bpTsUZIEicj8Lfc484hElJFqOLSzUOM+5mD8yu981DXI0gb0BzYtk5wby3L9?=
 =?us-ascii?Q?DUYnvzRf7t0elsC+DxOOX3y4PR5Ea89Hka0d+oIlijialvwBb4mkAVbuwPhj?=
 =?us-ascii?Q?123MYIm+s4QDgQqhC2eZwT//JxTHm6npEUXvUcRnc2gBRmRVEskybsvSXlZt?=
 =?us-ascii?Q?hVrpZkNobAc9hgPiyDhFZarx16+iW1eFSfigHNaMXjhJY0x/hBH5xmDYE5fq?=
 =?us-ascii?Q?5ga2Mp6uF3PQSnh9GmTUVhVcAHI9p673hEJC41eZi/n5Aj4+TjkCx20FB2ix?=
 =?us-ascii?Q?bW6RhkoSIgAu+AbH0iWinlCbXtNTQG6NYWrIiv2eNNYv3p/uqvC8rNJZC0Av?=
 =?us-ascii?Q?O299QM8u/XMUcxJBKMAbwOYL+RuqwG1FyYpA8uiGJVF5eOREvad/g+8gV5m/?=
 =?us-ascii?Q?GFgEAO3Qgc+KNfyEv77j0a8lUk2bgR9C+dTXqMj+Ed1KLTX2n44UcF0OR+Q9?=
 =?us-ascii?Q?zoB8xAAw/mfHIUKoEDASxDULTyAwhL3IzjHtTQTQlO5sboSYUYbmNDXZlORi?=
 =?us-ascii?Q?Ng7r4w1rwNSryMFDCQeGkQePS2c8VS8vYHwpD/r7Ig5RkQ+CXbh9KjBJQp5k?=
 =?us-ascii?Q?s7zYdXkmQn/bVRuvJ50nVUdTPRp5DLEsCkrrKtGS31ehsJP8o/2DpkTAs6/a?=
 =?us-ascii?Q?qkGwy27qehdszEZ0Ra6ZXDRk+NYTczE9vz8lHf+4kA1kVWYFAF3M/yaNJhuQ?=
 =?us-ascii?Q?gIHebIO7970147mpG2efF5UZOkyq+/HPMNjCQVhUfFMl3TrzVwSWB9y0z1CL?=
 =?us-ascii?Q?m8y8lbf7NV3s46V9qlGb0s/V9OyQVVtQ1LIhTEyzIvMuMQ+ghydWuZ571eR3?=
 =?us-ascii?Q?SQCbaymE2WG0D76mIznuI/Gp1IRKhKKvhz/eNYya7NmC2rXsfFOFn3lHUshl?=
 =?us-ascii?Q?JPlwTkyciEhTBOoRnfzhN3dsnfSlFHJxdLGZkBJW4A9IkYWRacmuU4XwUd/r?=
 =?us-ascii?Q?IJ5Uz/cRkuttnCkBMczXRm6xHIuZoOZPIZpxXsk3xB72Jm8Lk7tJqoEsWGSz?=
 =?us-ascii?Q?lbxLAyrX1vqzyNXGVE5DQ/Wt1JHMlXeeR+S73DzSy8pYa1fZilhQXAhiLvBP?=
 =?us-ascii?Q?Yoa2F9rkJWa5+aJiTcuxrzSyt+juFgk/a80NHiyu7QU/Y+j7Bv1b0Ze4PIR0?=
 =?us-ascii?Q?NzjOEA2dxgQvZ5nb9q40NuFFtuqgt1yKrsg11GAVJoR86G/CgDUngXhuQAZb?=
 =?us-ascii?Q?O0XrinolC18PFWQBQVAt9x6MU16qIT2MZJ+PiFEx0OGgLyRZnE4jdRxuQGr/?=
 =?us-ascii?Q?MGWWabEOpzxWHgmyTkxNGNOinbTv+FJ8sbsXyyi66tt5xNZ0BlZ8C6IpLezd?=
 =?us-ascii?Q?hyg6aTfwCelCAnkwy0cViF7hxI336M932+I1B306PKVAJj88eA5gzkFV2Xar?=
 =?us-ascii?Q?65aADlEbu0ECwYQacuLa32qELQgQHoYB0MUZj3d2qVGUW9yvG4WhyRpzV2+7?=
 =?us-ascii?Q?rLvSXhsdh9+7zApZDGJmlqHP6WN1MKZV0Zu+Rs6+tpgd8yyLEvzOerjtsO51?=
 =?us-ascii?Q?QB1wQ7OqB4ere0lgTdo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 071a3d13-dead-422c-0332-08daa8965070
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 19:01:17.5987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /4L1NYu4pXj0unEzjv1KDLi5lHYc2OWDEQ+RIrsz5F4aYUXkV8aEWfZ7+A+vnz0B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5878
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 07, 2022 at 12:57:14PM -0600, Alex Williamson wrote:
> Replace further open coded tests with helper.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> Applies on https://lore.kernel.org/all/0-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com/

Yes, makes sense

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
