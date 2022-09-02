Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B385AB918
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 22:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiIBT7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 15:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiIBT7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:59:39 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDFD26ADF
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:59:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMVxXqom9Gl/pHD56FshK0CdZV68czv84QufvhCJq9l0G+F2VjlO3x2wSWQGUBKUss/gTDa/uKhrN9x/I/hVgkGJ7k3/o6o8ZUGbiCw77ygx9ZJEnF5Yn1jibrc+3FpOkyeW3uxBN5JIIR9PsdR3Duql9aNouzwXB/iDr4ytXqrbC5oj3CQ+C3M9FTv6YGAEAp8zBYV1wb+pH5UcbHbdiPuPEi0DIqi7WvqdGuUy5i9vSJ+J8TMf2IaoWPJ0YJri22botS/q12SI0ssPlsE0FvTHNQ2tne3yj+lMF1Ojf0MQDYLe+M89viBqkv/S//0FvPH+FqIshnM21ixfZJttWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3/CWIRK18SlwJJRn48yuxkp+rlDOOBWxmQs7W1i4MHU=;
 b=iYyh2Aiczn009chu55V+slfizAmuf/B6MqA5mj8OBu6AtZr09cNCTUw8mtVCfKqU9lKEm+e3Zw1x4mxwr3xyiHiCXy3YqlEWeih/Z8yUyStGVECYCjJN6Oz0BQ6eKFf7Cm8NHN1JhYpKFYd/0Oo3lFBlPR9jqgs4wsWzhLniB0u9i1QsCmez7GDHG1XW6L13svnP8YgJvgwwO+mjrfKC8FRwWQ8+O+dq7kbXdA7q3QYaoMuCg+xNMEgNygBzlmIyDsKSsTEnEKgocE1+KCOn5ObxbLzpsdqqckdQbHcvVzdJpJWTou8gFQgW5DLXhDOqBKhYABmQCXCovHxX3VWqxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/CWIRK18SlwJJRn48yuxkp+rlDOOBWxmQs7W1i4MHU=;
 b=OiEQxOADpPcc5TY0nRtW5VzAvbiaXCAYv3EWMVwPVyAwB/9STHkQH4VsK6pY75klRxvSOXF7fTEexwsba0sqwkPhDqNzA6sYEhUHOTwxIwICbsupTr0bpwI71/a+OlSBVOPDKhNWVA5skNR8hhaicLmXbhkEUAA6MXxiesZN1Ug/kLSVxa0NcHoyO+gjgvB0TisiL2pLjBSKS8koSFPcsIQIdva+Hi7MkWNzbI2iMI/dKzSSyS9DtmOYjy57gNqyz7W9AoKFZI2nTUs+JI0stkDg9w6I25nwgSa1DfXvockF+oZuwE4H8sOnie3W4qPAhrpmDCPBlNnSwkFjCjIaZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6566.namprd12.prod.outlook.com (2603:10b6:8:8d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 19:59:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.016; Fri, 2 Sep 2022
 19:59:31 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
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
Subject: [PATCH RFC v2 04/13] kernel/user: Allow user::locked_vm to be usable for iommufd
Date:   Fri,  2 Sep 2022 16:59:20 -0300
Message-Id: <4-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0195.namprd13.prod.outlook.com
 (2603:10b6:208:2be::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2aba5d40-3dc3-4400-bd18-08da8d1da5d6
X-MS-TrafficTypeDiagnostic: DM4PR12MB6566:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 77UcuoQ+zDHO83U9nBOis9JwNulii9rJw6B2Uw17ZhrIZ8EQqiGYSOAKLV8ONxLHnqC0SBheO3VLxw7RvlNN1Q97wC+fy0l5QnuKY3Z0suFhasELzAtuWTvezIUz2rqDdEXTnbY5suSyvxENMJxVk9c6D7xmB6JKo91aXji9z6XSjHEgQ21strd6qEcWR+YlQvMjT3Ntwq+hAFpPXKiBZMVwISy/pXQ+pVgWkkOImaOMFCNJyFAhXAMd6G1eZXOXp/OtUuREHAa9iP+5Ikc9NFJN0I4EAmjcazHxeLJmqn64gaHX/sTzUe32CB3NH2u4d+IiNJHVykC1u0UIRSdbu2ubnM2s185pQXVHtOdjiCzpko3O7XtfxRkXIMCFuiW+VvaIWqC/xDxw/YXMrEZYW1ipR2p7j2r3Ogw54a/PMaAkzJH+AdpaqXmcUtHXRjWvnopvedoszk0ZbFyVTAzjLIFVjCQ6EmSEQ3RPH94WMVHnojpaLlGPZYfkKNYjfTh/LZjT7JCMXpwb0g9XDuMZ1WHruZ+cPMUwsyfIaOocqZ/8LB7URhzofV2MKVqCz/mErDoeOQs7pq68KUX+RHk1zYpep1otSkPQVVksOjUetSwHNYCkz13UeAhhGA3amIC6DFcKFIIoYDTc72mCzYbsLcFfDnaj9E1KzSyzOPKYWTYQRDqv9oVQp2JnaJkIgm1AeRsuUU9vOzlRpQryzxKrPUn3Job3YwQ0f4vIEwbYlvfU8H6UV7rJefyuHjQWpMWGQviJo3H6hoXh7M4NM9FOtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(5660300002)(109986005)(6506007)(36756003)(83380400001)(41300700001)(8936002)(6666004)(6486002)(478600001)(2906002)(38100700002)(66476007)(8676002)(66946007)(66556008)(4326008)(86362001)(54906003)(7416002)(26005)(6512007)(186003)(2616005)(316002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6nQn9OyClkfC4mN5ijb85xkATYRNF84iJwWBaltws/J4HMVUloie8XenQEa7?=
 =?us-ascii?Q?f51iMnOx/VtIXwz9l+azN0uRk1h1E5SgDsibpOBsXxFUaSQUqjeUf4REpUbI?=
 =?us-ascii?Q?7E6UVNAI9fQ1525CdI15J4StwOuscGWMOY2qltiiS0YYhx8PiOWfkGrRAs9k?=
 =?us-ascii?Q?LQppj/Z0kBIWevRtFFgRO7uT2Bvr9YyRYTMojfMAFNW/COFVPAbB3Pfkbkeh?=
 =?us-ascii?Q?D4gZhyuU7d2Ys881GYO72Z18sjiVgIBDTkomaG/j+E+QnOdQ6uiNx9Nva69d?=
 =?us-ascii?Q?7kh9nFKigOILFHfNH4j9KRhk1cY6gsV5Y1BkR5MMpViW8klhDT3sugkK1hSx?=
 =?us-ascii?Q?9fmbzqQGH2j7+a49+a5Q1ocaV5OQayO5oxUp3Bh+mWsVuTCtVCZWlr5yfe38?=
 =?us-ascii?Q?BRc05G9fpP0GdtT0YX7Hs2bfzxnZOJh0xxk7D/pa4zkUn8piTr79lrEpqr3q?=
 =?us-ascii?Q?TDvNznD0SI9N8EeCucs0zRmvcEG4rVQtoR75IE6kwy/AMLk+LoQg+4id8Oy9?=
 =?us-ascii?Q?bbzbJ/nyEoKpyhxDQSwqQCkrzATlACqdlLo2Eh8WXxSqldbVLUn8jk5P9ycY?=
 =?us-ascii?Q?PQyVt7EpwgPHbLsrrYnIzoLdqf5GsY2owxIwtb6TfGitWVwp+XLCKZZKBOSp?=
 =?us-ascii?Q?c2cTaDOjt8sz2THIf2y6277eXtfhJFROLYfm55QYw8J6E1kazCNS+LcDQ+FJ?=
 =?us-ascii?Q?q7yMrASpi+vXoa17aYfpNUdqwLGWMNJob7lmMS4IgfJwsFZJcRsmRgzr0NqA?=
 =?us-ascii?Q?K1iGVm4FKKofsgviYHKxM3jsFcWLpKuc4QnQpdpuYogaZesp7ZijItUfbCV9?=
 =?us-ascii?Q?+s3FYKxrkP046zxPpfRs0dMc/XA05l+P+lA08NqExeTo5fBsq9kLiLKd9yYd?=
 =?us-ascii?Q?OKTSArhduv04TsWsoW6hvnDRKq/2M07T0CxtMWpBY+pNeBLECZ9gbV5QYYb2?=
 =?us-ascii?Q?kee1CEIzEpCBAi7NcUKS7I/XFUtgdfSTQuacplDwdX3UprQEknEitJ5XXHL4?=
 =?us-ascii?Q?ItQtxF3QccBIlzhi8LHqbVLIfKI6wU/QuGYIegv21vLzFAT3K6a6/qs0ViWk?=
 =?us-ascii?Q?V/C7M9IOX3F95sA3yqE8X0rfTnX1rKqN29sXln8Mgy4bRlRwOHpq+pBObLnl?=
 =?us-ascii?Q?QLNznJWgRoOX1zNlWFXOKgXoQCoxXu1gbkEDtazH409Ybtz19/ljZKAkfbOY?=
 =?us-ascii?Q?pWhp9gj9ys0F7PUA24RSezQ78NF66RCTa4UYbpTuxPbKtD/GpHqTcYE1ysJp?=
 =?us-ascii?Q?J670KBP1iSay9zDhJYdLmrLDZETgbkB6+YJ/IlBHtXonejqVWzOH6P+/6Pqb?=
 =?us-ascii?Q?vXtSycgcDEuuVisxlQL0QyI6rrIUwWK9CmTkzjID4PPbk5eJFtGD/WZh197Y?=
 =?us-ascii?Q?w9VMB6zs6LScrzSoyYh8L2z4tFrIVrdOq+btPuwtKXwRPGSUKALrt7wFxYcz?=
 =?us-ascii?Q?SuO1Q+rj6BbtmFircN51s6P3X2n8R33qOdrvCBc6C6TGzwF68QEh7QKchd+o?=
 =?us-ascii?Q?G38h5Dw3sOY09tJaq6yjxtAaswvXvvErEBF+mVP4YbpZOx7rUmE5CYkD7KML?=
 =?us-ascii?Q?9B2Ycbvb1Wu89cbfrRb99F6awR6QZsvToKihHCWE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aba5d40-3dc3-4400-bd18-08da8d1da5d6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 19:59:30.3772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lyVbeOe9h3Tv4Fn45hlaOLaHS4Ko2kq+jM/EodOgfcKS6ZeCmeOmh6xkwvaZtp07
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6566
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
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
index f054d0360a7533..4cc52698e214e2 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -25,7 +25,7 @@ struct user_struct {
 
 #if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
 	defined(CONFIG_NET) || defined(CONFIG_IO_URING) || \
-	defined(CONFIG_VFIO_PCI_ZDEV_KVM)
+	defined(CONFIG_VFIO_PCI_ZDEV_KVM) || IS_ENABLED(CONFIG_IOMMUFD)
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
2.37.3

