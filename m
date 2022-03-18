Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BE14DDFE5
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiCRR3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239630AbiCRR3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:29:08 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0B72A4F85
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:27:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bU60KWXPeGf+7oW7jSpkLlpafGPphyfLc+s86XRk2UCJFEFx/dN0LXEIaW6SFkoYNNV50K9cfv6tW+gkh5YbZoe+hLvewOGs0+3R+31XV1H+OxjT9C7L18ZheaJq/H5MfscIxGxTHh9QcW3irSpQ66BhcvnnrCY9LJVQYq1cLhcR1zHxGFBO25uimduKqqlldUEnyXjd4UCJxZsaCIcOEH1lc5phUpmTZDIIYC5K2di5X7ojji6AJpy3xydSW9fRVEUzaAK6t5KYssDpZYVTadBHC7l86LHcUJQNkLUrvTtV8bYncx1qUObZsCaiHYP2TlWqeDKzbkxHJSI7cVAdzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8yLLEBbBOWMliWes7bwgbB3hkYda8vmMWRXQ1hDJkJA=;
 b=fT3shWh0UhqRbH//U01engVIEjVltMu+IMag6fZCaYtj0Z/QWMpGRuoRYJR+tV+VnjIselN2Et/eSRSS6k3RSqc8jrnrB/sfFdDrGZL8ZvwFkDso0Z+PF6X/mAXN7pk4Oez0oQWgfKNFJeF4uWnhQqPC/t30qyCPnB9oepStwjcECNaOAMOAmiuTyBOW9R1vVwqDZoYSRFDtjWe7MKuOuZda+orGB/LWcm0j9WWNp7J+MBW7r+pEF+zpsH1hlRU+/zgNGG15LdHJ9LS/jRBS+5c4UH8NFDywzvFhZ1nYMwJdZyLVLMNuLJ8t49PPXfQU7i+kGPeEKSfoxSFy/pXY+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yLLEBbBOWMliWes7bwgbB3hkYda8vmMWRXQ1hDJkJA=;
 b=aItWsYNrXyIwWS/fvbzV2DM0GHzuPg6XPzAZlw8FbZpgN18X9jesPdqlFnE1xwScQCawW9bOJOgyiAqCg8Ak9mhuGaBohPVr6+tRQX0WF3vuR1UjX/hDU1KqcQnAQeK9XQKjt9YLB3vHmu0oohe6GYb+UeIGnztrZ9KiE9MyRxxIddvI83xFQILSja12bxXuFSZKsLBo1FWvs3mVsim+nVYEikH8GsncBQLN1oP1vKMp+WVLCTg7WzKMAWmH4vzjHG+uCMD529l/KfiPiyovDTsj4CDJ0oeYqGxQ9NJ6ffCuNZxsoMhbUPBbecSo+IPllXf4ZvMfZGGxTWvjBJStpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3951.namprd12.prod.outlook.com (2603:10b6:208:16b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 17:27:43 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 17:27:43 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be usable for iommufd
Date:   Fri, 18 Mar 2022 14:27:29 -0300
Message-Id: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0222.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1635b9d3-f7a0-452e-2802-08da09049a73
X-MS-TrafficTypeDiagnostic: MN2PR12MB3951:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3951D231CBE60B36D6F0BA92C2139@MN2PR12MB3951.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SG8U2pQwyEPwsXMnYwnAsjMgUkcGp2DTWTGydEc5HZtM2vi2c6n8Rpe+p9GrqU9aNJMkuCJ+TjO7tJZCtSpbJRh75slxkdcxsZERsRZ2Qe0gzRcaSSlizhFgVJQ7toHvemHfnxNThRILSSAGlYGXGqUgWG1gkY0V6ATtltVCT2wl6DKhNFlkNoszuSY429V8itLcOo3CW7NlN7Qqg59RoWHN3wNC9VQ6npZVKM/KRhcJJt2M7co9Epi0vA8RHOeBlFVN14Xu9vQcBdo4BX32Mcp6F5LBFqcNt0yzikrdaFc60MoeUbYm64UaYG8UGo1/z8PS6UPgU87rMGV9G8T0+xrFzP7xcw8Xk4j8g2ekpiDeTYQXneJH0Ep+6kStXLMcyhHmuOQqsaQddFn19hwMyRQ6+c4NrPx/iG8qe7t8PXcK7TOJ+RYLkxyavW6aEHirbyEOoZwO9LLV0ayI7OLbepJZqB3RUbLP/gflE3cDvVtLladXaQ+Tt0Z9ZVM+w8quAWbqr1ZMajTw2ErwC1DTSpmVyIA2146MvGhJ7/o36WiEdYUoO4nXNPgQ2ykr3q1cipJm2EfPjNvL7AnJrxy47EE6leEQmdlttL5RAvFK52cGGN03c9ZfGM5mIHTxvU2w74NZdiMA9i85qX152fRNyo6KwzY1xGngs8YSavPf4clsGd80vkxjYxo21ybHlNlpLKbNlRn758Z408n628GN6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(7416002)(4326008)(2906002)(86362001)(508600001)(8676002)(6512007)(6506007)(6666004)(5660300002)(8936002)(109986005)(66946007)(26005)(66476007)(186003)(316002)(66556008)(2616005)(36756003)(38100700002)(6486002)(54906003)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S2yhHRj0f6P1CUo2fSoLvXo11IFr4DMNN71inpv6buePjayjaoDyymA8uS8K?=
 =?us-ascii?Q?O68MBezijp/OxcIN+h8MI1X8F1VdagiM9qfr5Jr8HOWbTg3NNCpylneABgfS?=
 =?us-ascii?Q?jpNcxsszrIm1PADVPwWRjVaLu5/5bzVQ0zrGgOFVcx9urefSb3OvGZXDVL7s?=
 =?us-ascii?Q?IErWHVVpMzcISSyTfWZOZYW6k3ewTwLaUrDpjbWROI1UX7driGiuUbHbvPRr?=
 =?us-ascii?Q?AsADiIvW2w69+UeoceCyB/3NQBhEY+rbJ0FCRnB+v9KAcJVRQBa5js+iMkzA?=
 =?us-ascii?Q?ZlaEvXcf71X7aCzegvg51ciIbRD/Cyt+aQ2pL3dHy+j39lGE25ql7mZzLQO/?=
 =?us-ascii?Q?tyOzVQPtXWkMPysDM0HPCZzgeTOIed2kpTzp9umXbrvd7QZfOarUCe+u2XQz?=
 =?us-ascii?Q?/xAKkARsunKOvp6H+OjPu9xgsjKMDrW35RhVnURtsSG/SjBXRmf3Db0H62Bk?=
 =?us-ascii?Q?/LXN1WxZbkDoKjNGeJ/FEINhJsx617uhmMHP7MhFx6cXbUCtp5YFzsQnmHPY?=
 =?us-ascii?Q?gBFc08AK+pe35pNIZ8X6670sMU6QIWpAuSbKBoIm1GiNVDDb+EUlcXTA79k2?=
 =?us-ascii?Q?USs2FmW66skeIkIiE+Y0IIaMv2AxPaKGbN9zerRlV7VEuWYd73poMuyxyg4Z?=
 =?us-ascii?Q?uhuLDFeaI/JMt8ybxBfQJC2cZNG5A7Fp8O9xqpTQw/T83n3mEosGxjGbCART?=
 =?us-ascii?Q?+PWZxYmt7QCbY2m5arqfQXhs1eJEPR4SVNwi6ZfCkjV7atPFmaVNdzMdOWq5?=
 =?us-ascii?Q?WqWoC/zjFBi54L0dn4sDj+orZjrdiXRdzSI7urNQE/fmHgeAPCchOtnBUGbI?=
 =?us-ascii?Q?AIlmkXeqvCk71sG+VvRvtSe8MgIDO8b6G3lhggwbLGEJb09fWO+igV6xVa5S?=
 =?us-ascii?Q?J1NMGpVMtbCrG5mIYnnyXb56jpeLicMkaN1MHtKjhn1+8v7APE0/L1ecKxE+?=
 =?us-ascii?Q?UtB2+7f2rVOzFY5FGNN//uFNJK+VHvGqVt5qoSxiGPaJcmNZJF9pZjmblZ1+?=
 =?us-ascii?Q?B9kKMSPtNWUc88Jm6ySiiV0SYN2bWnbUE3gJeCJmwM1pYXAV9x/a+M2FLZnd?=
 =?us-ascii?Q?IyQB0m1/TEre4dhbZSzuPOqzB4g8SxdRQrZuhAMlkjPCXPKa88S7FbQ8D1HB?=
 =?us-ascii?Q?P6GiDV+ARDBF5q2aWa0RMiQwJeMBpj8rAaZwS1nIow6psXO6LKOzVsMictcv?=
 =?us-ascii?Q?0NqUu/JH7S0GSgQk4vWtH/CTFeFLihE635uvvPH+Emka6/zDmQMrvzoxkCff?=
 =?us-ascii?Q?tljs6O3G1YC0/KQP6XlNNYNK7+4OxiIiL98lEhSok4HOFAX1hB4p9BJmpBQV?=
 =?us-ascii?Q?ErCVlrOBhSzeKaMnh4KqJBF+Kj+7IcOP4wal7w1dtPX/I24bY08WI+V2MKsj?=
 =?us-ascii?Q?guv9xhQ3JKJgBetZ8Thfzfzdfv1gtEnx1oqtpg2dWaAlHfm7Txm46Ns75ld+?=
 =?us-ascii?Q?TmvWrQuEvvA8SZJo9K0F+uZj9gKRskqF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1635b9d3-f7a0-452e-2802-08da09049a73
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:27:40.3666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C0ElHAne2/uvwNxXc1zyaJLrmZqu/IWeDmq+AkrXvqD/oNqznDHFKABLjK6Y0llu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3951
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Following the pattern of io_uring, perf, skb, and bpf iommfd will use
user->locked_vm for accounting pinned pages. Ensure the value is included
in the struct and export free_uid() as iommufd is modular.

user->locked_vm is the correct accounting to use for ulimit because it is
per-user, and the ulimit is not supposed to be per-process. Other
places (vfio, vdpa and infiniband) have used mm->pinned_vm and/or
mm->locked_vm for accounting pinned pages, but this is only per-process
and inconsistent with the majority of the kernel.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/sched/user.h | 2 +-
 kernel/user.c              | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index 00ed419dd46413..c47dae71dad3c8 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -24,7 +24,7 @@ struct user_struct {
 	kuid_t uid;
 
 #if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
-    defined(CONFIG_NET) || defined(CONFIG_IO_URING)
+    defined(CONFIG_NET) || defined(CONFIG_IO_URING) || IS_ENABLED(CONFIG_IOMMUFD)
 	atomic_long_t locked_vm;
 #endif
 #ifdef CONFIG_WATCH_QUEUE
diff --git a/kernel/user.c b/kernel/user.c
index e2cf8c22b539a7..d667debeafd609 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -185,6 +185,7 @@ void free_uid(struct user_struct *up)
 	if (refcount_dec_and_lock_irqsave(&up->__count, &uidhash_lock, &flags))
 		free_user(up, flags);
 }
+EXPORT_SYMBOL_GPL(free_uid);
 
 struct user_struct *alloc_uid(kuid_t uid)
 {
-- 
2.35.1

