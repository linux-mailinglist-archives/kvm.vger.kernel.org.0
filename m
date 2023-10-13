Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F239D7C899A
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbjJMQEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbjJMQEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:04:13 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964A8BB
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:04:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQZUiBaNaObfcY50SOf8sCgdeM0SrEVCxBGUx0VzlQAjFEtLvTi/k5WVPpup5o0yOPgD3a26CigvxGuf2QAd22hkXFhgO16sVA58MraWBkvFM0GGYp3rg85pkEpcXmHBv8gDvRZ6ejfUtaGY1QICiz24RXdKfWD6o4aAzzMv8LIDIccRfqmEFbVflfu8kXnrkxRKAqhWU5fyaDtpyCwJ2p4E2LXsMi79aidK9vJXHqycjt0ddxen/GvIChUXGQ/EQCV+StVaAtdvsMzgWl0Pn/1slE4lorsP4EcKxF6jx4bKViDxWTynPijGQBbdUWC/v2RVjCNTx8ezfDU5KO+btQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Y0JYbhdqh9y6wQgUDD5rUtkkxQzhSvYqLka4tk4974=;
 b=oPaSYmdHfRzeq7I5CyzKSUg0V/xtJX/+14P4SBq2/ArwZ7P/eGhSoljZ8PopkSNwRdhiY/xvQQzh4G+4tz+ItjLn42F+urDODCdHp6dzlAJCnwSm2V5DR2CdJReBHl/ZljJc3dEQopfUrfGjeCj+cb08YGn6USouK6AF6mUUQSk18IedsyjgQP9VHqBb27USQq1QxUmDTfshGAz79a1wXmbB+6nWQU7iZfkxY5rlsso3bKapXqm8Eop1K5FyXnSORYlirGVRE2ayhCAPVZ6jILs9gpcB3yZJkliWjyekeApS3t69lxamh09z+l9hP1WtA7WfMiXikJ+vkzbguiLm6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Y0JYbhdqh9y6wQgUDD5rUtkkxQzhSvYqLka4tk4974=;
 b=XS1sxjrTcQ/I8qIwmJBNdDE/RHk7I8YOH0//iJEcyxj9BvesXX4+wwLBHJa9PH1y9o2ofNLzdOjrZi10xI/zFm98SdBsVW5cxe4QK88Y8ti5rwkjmWQ9T/OXZOKtcv73gc6MsDqUsp2iqodKM4w8GB2Xu30ChShY+UD/N3IWhx+6qCKD3zSTv9Wm+kLDSe9T9Vf0ZQjKeDRcFvOO4tZG2okPcnLEzzi/jCPm6vpSm0w4KImcKB+jTMLMqPnhuSTN3b+qovu35CQQbtDI6FFmXwDA3oasGtSE6FBcT1o3cTRysfEwAJs1NFvFeaenmbpcOkChdZAruCAatZ1JIiUlRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB8430.namprd12.prod.outlook.com (2603:10b6:510:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Fri, 13 Oct
 2023 16:04:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 16:04:10 +0000
Date:   Fri, 13 Oct 2023 13:04:09 -0300
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
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Message-ID: <20231013160409.GB3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-3-joao.m.martins@oracle.com>
 <20231013154821.GX3952@nvidia.com>
 <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
X-ClientProxiedBy: MN2PR08CA0002.namprd08.prod.outlook.com
 (2603:10b6:208:239::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB8430:EE_
X-MS-Office365-Filtering-Correlation-Id: ef7627e0-52b2-4096-25ca-08dbcc06092a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GYxAL7o8ksRexDIPtHaajkrqkS89bBbDbs2/Zx004VB0ZbqPPL9pon1mR+F3242nI8rAmFgkWEBUfNVYTpxwfDP/P9LIVZyvOh9jF+aSXSLGG13EwoP1Lkzf0iF2PmKpd3dsS9SJeO0xlaVk9xGy5UbqLp9UQqf+5DW4W/ROXjqe8XmzMmmiTOZSPqF5K7Q+mL50NXQxopilcvszkrW3fn730EYENsLn5WONzFR3CbiQsbsci9yTWG4+1ZL7FWuk07S+d9R8pdlNIlAogYvE+owRVMjQdly2m8DWIbQQbs/mhhU+GoAKSxFsd3ZNx2CI3RjhzWPD0hCZHZPIsEv0OnuEpljogOTsYpSqi85l5hKpdUbtJJUC+/zx6UUvjcYhWJVa8X1v0Qzr5+S9knmyoeIg1x2v3yKslOC7jDyfM6GOmI8JS2oZFsjoYA1OJdBcGSqe7hI4xJis42ObNNkqCVfoNgGeQeD7vPzQhC97JEPYcWJ2S77G7wWkaBOcNGNxWNyxubfmeZkSOzb3uzUYarBG487evDcPOfi9kDjcCZWwwus8dZZbXWud/SF/cHuY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(396003)(136003)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(6512007)(6506007)(1076003)(33656002)(26005)(2616005)(36756003)(86362001)(478600001)(8676002)(4326008)(8936002)(5660300002)(316002)(66476007)(66556008)(66946007)(6916009)(54906003)(41300700001)(6486002)(38100700002)(2906002)(7416002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?drJKeoQb8tM0reW1JAIF8OdRPYPRRI/dIgwKpwTVJl8fL2tIgtye92Vgq8YI?=
 =?us-ascii?Q?DPw/zMvvYMEXe1aS2sJGibomTYD21poHwYgeo3VHVaA8UMrj2Ri9m0S2ilXU?=
 =?us-ascii?Q?7rV1t/XbJ1LAfDymOTbYk6QqiodYg9fZ5HgxC/Mb6GzusgEIa8fi07xt4Aqd?=
 =?us-ascii?Q?Le0eWkvtWfx+/SHYAK5IWdXjrMw5ypuqPHqMii5wcQyvc29i2eZpIBZg5enu?=
 =?us-ascii?Q?vS7LI7ZU5W68+pLueD5Pig0cxIpEBE9n2x9Sr7qU7cAr89lmr6sUwJquwFmG?=
 =?us-ascii?Q?+5K0QDuO+yn8h1diKn/NxmjYJHT7woIWkPW4VTM17Eufh7QIMPYw/xFJD8C+?=
 =?us-ascii?Q?Te5bYIay89mKEVYkfrnUjtDQYCSrs0Gc5gm91wbpabNdNX21yi16z3S/rlM2?=
 =?us-ascii?Q?ZGuHzsci/Xb5wqZ7v5eO6qv6U+YwY5ic5ODsgmYJHMJpU6Esc1nXIYlGeSuu?=
 =?us-ascii?Q?bVNld+esPWHfrDtyjfle2RORH+x9ndV4ahiqoMQK/FxFcKGhPQDwoRiXoLBd?=
 =?us-ascii?Q?DHKb1V4kddHlelqlU1gaTbCaokWvLPHIXokY/4zLyNmUbdEx/GFcin33Buef?=
 =?us-ascii?Q?lwhcbAe63iiajEKXNsYYdzexBIReceh3fHlMHF9GBW1C+olIjyY3bdkSA33f?=
 =?us-ascii?Q?gMSmsRknFkxp+W6m+eSQQgrip5MEO0aNYtDvVDXup854ro67mQwKPanNqq7E?=
 =?us-ascii?Q?xQYEVxK9ah5lBvYQCHC9qsQACmvMJCUVZRyuoVZYLP7qZvE28/q7q/1N9KZc?=
 =?us-ascii?Q?lNQPxN0aA+V3/z+lRS5NnWKjOZRLf+AiBqKKJnJIfGKtwngDUGlITAZk5DTp?=
 =?us-ascii?Q?b/5gQOu9gYaMHa+CM6oUdfN3yuOX86X+pcV2hwI1mwTXO3yB4qQZ0gWqh6Tr?=
 =?us-ascii?Q?Zyd515LJsxm09YTbphcJtpUljFoYTuAsdOJkh0S1WpjpVYbMXt80XkJPZbFL?=
 =?us-ascii?Q?0LBkD5l/yQfdORvrjbW4YHc28rnUVBqKC9P8wVXE5SK40tmU1udLMUaJKRx+?=
 =?us-ascii?Q?Z3Kh80ybOX4ZLe/1wLYwfVm6j+sWrkQrmMpquWy4KiZtf3AXMIn341sYf/jw?=
 =?us-ascii?Q?69WPvgKrQnxSqXLYjvC2kBRHrnrMMPdfRakFx7MCi1rNOI12wF+AaxLp/AuS?=
 =?us-ascii?Q?ejMW3CaIBQIy5kd7v6elxK/n/qRa/xPjZ0FZj+bBQkF25WBYfqgkgnxpWzKx?=
 =?us-ascii?Q?3BZNY/TLV55wAxHfNKaxWF8GIHcDA/uYi6KbkD9ALMP4n3MVBDYawfKcF6yz?=
 =?us-ascii?Q?9tBDrmL8J8CeoyhezoG+oV+k/wMhiVVJkFm7RBm2DGeRgFWHdHxF3A1Ws1KF?=
 =?us-ascii?Q?V5Tix4NIKA7/Bv9DuffRm1Vb0pIN4OU2HliMV0Q04NqpgCYgZTOeNGkB8qM5?=
 =?us-ascii?Q?d1VS0tV0GqxZhm9kv9vLa+p9k77OFU5Kie4yx9v89b1rOphdPtkd9x8lsGvA?=
 =?us-ascii?Q?4LLvmUKardiqIUI8XF7FqDze5l4+NMzIc1Bb/7TgVrMiqyHVHpsT4yuLOrgu?=
 =?us-ascii?Q?0x5DRq6cKcaGVnuw0lW4Njy97DBwAi8TCMMDb1XyufULw9Qm2TQsiEYxbhOw?=
 =?us-ascii?Q?UGbQ12gNyDP61igkkjKXbRZZd+s8/QUciH6kXZ02?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef7627e0-52b2-4096-25ca-08dbcc06092a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:04:09.9770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/0QuQcPUJIomu6TrTPsZwGGo53MJs6HRzEIkVKGcxXjmtN42759vanXNyWy8M5Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8430
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023 at 05:00:14PM +0100, Joao Martins wrote:

> > Later when the iommu drivers need it make some
> > CONFIG_IOMMUFD_DRIVER_SUPPORT to build another module (that will be
> > built in) and make the drivers that need it select it so it becomes
> > built in.
> 
> That's a good idea; you want me to do this (CONFIG_IOMMUFD_DRIVER_SUPPORT) in
> the context of this series, or as a follow-up (assuming I make it depend on
> iommufd as you suggested earlier) ?

I think it needs to be in this series, maybe as the next patch since
io pagetable code starts to use it?

Jason
