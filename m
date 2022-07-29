Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBB7585491
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 19:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbiG2Rej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 13:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiG2Reh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 13:34:37 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1682F88752;
        Fri, 29 Jul 2022 10:34:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bBQOXxowL4IURDxMnLHlBrNXFlnrfJCe7zf4lrPMzL+ouxsvgUo1MJWI/10PiQAH3vbnFLjEoaXoPKKLUdZezEuULfQA5TkcIw/nkuaZxVUmaN/RNoOnzJyy/qxAZGxju1RBPkyDsCXaDU2QegE55mBPQDGmy9uAa4nvKKLmILzFbjJGSwUbSEaxc0b4HEbsBFDg7cW3WB05fYDt4cn6Eelv9kxX5rgew04Ejbwsrovr+YSDtdXWu/JzoOa1PYBie4z5NtplkDwQjb/w5WczSh5ZBq9XnXkJ497mNfsx+Ion3HK0PHkUpiz5upvoN/gbs5vNyK7ahJmOzksnuM/C2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lLTMy9d1KzuOSTKTPPyJ9SvA1FZAap6HnwaG4duhuk=;
 b=d3eu7YkzJ5Abevi1G/XlqpzX1p+k9J49s8DLZUis5s3T8CBmrpou/h1VUkgsa6ayk0ggnRuU+8t5Y8/3MEVcrjH1cl2g9nkxIq5ikQ7lAnGYRxgpdlgzCt8OIb56p3wPWLKN/aKKvHz/bjRy5H8ZXuPvW1pLwx+nwijCu0sCFvU+nHlprxJbdOCSHmjFl56etRtz71I0J8dQNjRDpmpAVZvbTOglF9fQoaZDMXrpSKu4d/+z8qj/lP7Nm/UoMQUM1C3+oxIm0EJiasRp6PjHva+Tg0eOzbGqAi+c++nvr6Y7UWiEE9PmR/zxGjIjDXZ4Ks/JQE+FQ7+HLlh9EmMI2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lLTMy9d1KzuOSTKTPPyJ9SvA1FZAap6HnwaG4duhuk=;
 b=LP/YSNDiwGAWZGSvAbMG1HBY+71DXhZy8xjjnxdyfqQh+ME9khjgtR3H+CbGbRfu0fBCU+Opgx/Ky5Zdgr5LgbYmb5yZTgPrsEIMmcldkV9U1JhfwrjvYosQNGRQFgP+E1hGsoAdzVo6DqHjCy6++xKNordGuM3SGnkAewXONwyx4OTR4VKRrxT0/B/i3ExELsZhtcIW54sT+yUy87m4dIx07xYs8hy3cn/0cWNvjtRbnjkBf5ltukoWVjPA23sTrIvjTZJMygVJCfh9IzhXBi1uWM94YlzWVDK1v6PS8Gt/+wxTLN0gi1ebCVapMwC1RGqK/sZz/bAwc/6f/tZqyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB6561.namprd12.prod.outlook.com (2603:10b6:510:213::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Fri, 29 Jul
 2022 17:34:35 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58%8]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 17:34:35 +0000
Date:   Fri, 29 Jul 2022 14:34:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     joro@8bytes.org, will@kernel.org, marcan@marcan.st,
        sven@svenpeter.dev, robin.murphy@arm.com, robdclark@gmail.com,
        baolu.lu@linux.intel.com, orsonzhai@gmail.com,
        baolin.wang7@gmail.com, zhang.lyra@gmail.com,
        jean-philippe@linaro.org, alex.williamson@redhat.com,
        kevin.tian@intel.com, suravee.suthikulpanit@amd.com,
        alyssa@rosenzweig.io, dwmw2@infradead.org, mjrosato@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, thierry.reding@gmail.com,
        vdumpa@nvidia.com, jonathanh@nvidia.com, cohuck@redhat.com,
        thunder.leizhen@huawei.com, christophe.jaillet@wanadoo.fr,
        chenxiang66@hisilicon.com, john.garry@huawei.com,
        yangyingliang@huawei.com, iommu@lists.linux-foundation.org,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 4/5] vfio/iommu_type1: Clean up update_dirty_scope in
 detach_group()
Message-ID: <YuQaKpvsJICiFC6N@nvidia.com>
References: <20220701214455.14992-1-nicolinc@nvidia.com>
 <20220701214455.14992-5-nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701214455.14992-5-nicolinc@nvidia.com>
X-ClientProxiedBy: MN2PR19CA0006.namprd19.prod.outlook.com
 (2603:10b6:208:178::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5357f70d-8bab-4b1e-72b8-08da71889aba
X-MS-TrafficTypeDiagnostic: PH7PR12MB6561:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BaAMyycpgs/2MwT7wcuKhMnFN9J6lqDo7K0rPXm7Anp84Ms8AqF6JyUXsHRN1zO6I2saXCrFk7Y6EK2lQVZyTz4TuFPTP7JwkBbFdxS0ziXe/M9t+fxjCwMxZXJHkOuddpj/tB4BXPek0f5y6agPJhkW3os06jP1EPa3ZPQjUw0QlakUakTVsZRC7ku3dcY6p4k4BjBY1StOp6vUdCK0TfX5TF+/rAGeDAmUVa7+r1q2GhrD8pgg3zn1fVPQ68OPtmSTO0KafzirFI/eLj5TKQKaNw1NA/t9fatqoch4zxvG2kl+DY6Dmjamns6+SeigjKWx28rz4Q4QnBCe85LKrOf4EmFNMd2CVFG0nql9vcWCEhAp7BTF+VdaNt4BdUU6VHTw2kvsPkwgbIuqXXRol33d8Ap287h3Ir0BKe8e062gYK9f3x4qbRC2kkozgiGAL3lCou2IJWUrqsoYM/KufiSPC1d881Jp9jwZCeMdIvC4t7YsXE+vjIsACPfj/BZxh1e1hx1vCI8RAGAiU0SZu/PizILLm5xmBq45vsRMtVkAsnkllkRFrlxIsaTWCtEJv3d+QUYfmckyEa+dwzdd5nNfIT1MvDI5ae4ZCurvAI8zh0IS98EpUTAyi30RQjiE8edlbv3+ijZKc6/uYUvr5gRHFNq/i6NOYtyzvb9R5mVmxpN8iLLjTExI6ooyq+h3IrFL2yZDuc1QSpqW/PrMcXLBMbbqedclEuYPxPBf2EuqABtfHJLdesVqusWuryFRNzyCuLJm+kjUpRTXx5EPKun1YkzSzCZRkJI3d75WZOA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(38100700002)(7406005)(8936002)(6862004)(7416002)(478600001)(66556008)(41300700001)(83380400001)(8676002)(6486002)(4326008)(66476007)(316002)(5660300002)(66946007)(2616005)(186003)(37006003)(6506007)(6636002)(26005)(6512007)(2906002)(4744005)(86362001)(36756003)(15650500001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xXLNeQHkwQQiP1+1Id5h0g+0mDMyy/BXnES1k1FMrrppQHQ0pbwggdd6HNK5?=
 =?us-ascii?Q?9gi4/evoEnauivSYSp9fMCt0/9wkI3dWvDDE3+FJgQP3ozUjsNMsA4gDaO1f?=
 =?us-ascii?Q?ED0PQTy2C98AYrIkLWXvvyqfD53pXVuZostHU75APt00N3a6T2AFnXtZ5eLN?=
 =?us-ascii?Q?f6hJ9NCgMUObFaR0YRxjQXK+Yn9AToOYpgaz5D+6ssyNG7FlfOkD1AZaLjTn?=
 =?us-ascii?Q?U0p5B2mCQ/s5a6DnXR1heRGvzCKR8B+wsFy++L6Qz3EEQuNf2158QNhlcbUU?=
 =?us-ascii?Q?6T0NqZHV3TEHA6vU0i45zT49lekpZzzyVuGzo/cP13BWuwVOjLA44x2TQNNn?=
 =?us-ascii?Q?bQ6hvcYXP8BVWF93S8CXgYraVt5YRMiymP30u7vW7EbaWnSloIh+pQ9p6a4S?=
 =?us-ascii?Q?sbdWbGHIFtmC3NVBvmxEpedCRsoD33jar9D3jL+86p2ey6WBYnOTOn4a3vw3?=
 =?us-ascii?Q?PTu9044Q2ZnmcQuBzB08Ep1x4BdAcrLHUPRf+ctxI+DqxQ9/F42uxWkIS6pl?=
 =?us-ascii?Q?i6hXg9FS28m7+g4iagwJa6Tgl2DZYDW42iZbefNpPxHG1f1XbUOUchRNoDUn?=
 =?us-ascii?Q?LJSEAhyZhjsQiHHeBy8pSn+t8Oy+KysdrAKeJ8u3Cf1POAVNr7oSqzS9zX8Q?=
 =?us-ascii?Q?srlS6TxcTgc3aqqsCjjjRNbLdr4CqeH1k9wql7bNdHq8CTGa7wK6F1kFBdeQ?=
 =?us-ascii?Q?Aub9d5YT9Vj8LWFpM7F2LVT1q6aiDeBBeKlZ2+Tm3a7Rf9yNN07eSTX4akSO?=
 =?us-ascii?Q?mLoZmq3tYhmkF00d0GXm+QWykTN/7tcYNMJT1+I68KjKWkUm4lt/9VxOmK++?=
 =?us-ascii?Q?MDMMRsbLgdPCr9dTK3DqXDa/TPy0e8yleIkz6TGE1FsZJHQ9BxRpMrwwSzPV?=
 =?us-ascii?Q?C5aFjDygb/PGHHDB+8wxQqN1HAxuZ2qw04yl9KrhQIifFQMVW1hG0xEtvPpm?=
 =?us-ascii?Q?JXsbATPUodsZFk4DY9oLOh84tLQ3Ona5TvOsH44QlnEPBwSNdQbPgGeQ7XIO?=
 =?us-ascii?Q?4xcS0OffvpPc+yldMjwDQFUit8OlK+7t3hqxwWu3/9ORuvAHzUW/tz7l5J67?=
 =?us-ascii?Q?OohSOagBmbTJKzEyxjXb+hIhyBkt1+MVgZ4yVqXQJ9EbUCpKePdMsL4fpme7?=
 =?us-ascii?Q?kMNqXhGbsP6/PBzrdWdthmpIiHKBHNkse9hLDGmm/G6suD8+FuiPn/nrdjct?=
 =?us-ascii?Q?X+8vuhbR35jkZnUmmopF5KAGW2h+GIynACbKrdl6YhgxYzhDIQwVdkbXPLk5?=
 =?us-ascii?Q?bSfEW+u8TXl56rxFd4I8BXys6N6B2gIglc+2Dl9K+Uw1he9MQO6BMuDMIWyl?=
 =?us-ascii?Q?lcEAOAOMn0sg8RknsYdZCQnLxJgx3lQK/p6o5OXIc3aCVfnsb/5Mtp8UsWh9?=
 =?us-ascii?Q?imHNJ21qGHqjB/SaOokZOXYwIqopXk006ApuEVa3kruT3+TcuX7YY0xUKvDM?=
 =?us-ascii?Q?jT+fjxhT2vtQfoYov7K90mVpUs7+wPiirrucsfRJQV73GWjWNH0Rln629Tgx?=
 =?us-ascii?Q?ezMKN1RW3PV5RrK0oPSIM75SYv0gLSFbpmmskWiaH2KYThp8+b0+T9dRy0JQ?=
 =?us-ascii?Q?YzgxgYgtC61yaXTZpt+sd7JEfz84cbw395z2obzr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5357f70d-8bab-4b1e-72b8-08da71889aba
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 17:34:35.2997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fcB1P6ULHGUPXY/teWBOHMMkBAWNQFaieoYSroe5OZ+zyChEM3bfeHZsukLrhA0P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6561
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 01, 2022 at 02:44:54PM -0700, Nicolin Chen wrote:
> All devices in emulated_iommu_groups have pinned_page_dirty_scope
> set, so the update_dirty_scope in the first list_for_each_entry
> is always false. Clean it up, and move the "if update_dirty_scope"
> part from the detach_group_done routine to the domain_list part.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 27 ++++++++++++---------------
>  1 file changed, 12 insertions(+), 15 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
