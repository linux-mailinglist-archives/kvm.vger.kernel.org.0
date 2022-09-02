Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC1B5AB91C
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 22:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiIBT75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 15:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiIBT7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:59:44 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5984729C9A
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:59:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGcZbQZoqOgpWIO4CgbcK7FG5yBTPu9jQDks+1l75umCkRBmmxkhqzl53TbDSSpRsxZHb5/n8PhPYhZeV7o8FLwGMiRkwfLGSxV8hdevOQvVqvUYdoZ1+HsBpemHqHA57viWEtwuLTcANcPBaNZBljsCE4ZKKYEJGaIUX11krm61ExbESn7LA3Q/w8a+931kDeQ57hcPYNQlrJECdPmR4dhIJam56B27O86SOKA9MLnXzpjHsgAGFm6IGyrSF8enJpKE9gkMJ9og9eniK4FBOMBh5GlQx2cj8DX5gXc6VDJ+xhNoia9KLPWJjFNppi5btjMn9mIH8c+8P9Isf+jKjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AeRVYLyGgJjrBTXMAAKfv3LMr4DmMYWlfc5OvmOg+18=;
 b=nJbkPBERYVRJTxaysyyDC+ZVsH0Jd7GXRmoK+CHeYaNEpv2r7TqVqL5h/fkLDXwRpj6oYw9QbPgjBIxaIjuC0UCsKGZMn/rVnLRAGpl7GlNJldpfRSX7VTHsMMWtHyf6EQvgR6jXyRD5o4dlislhcSTMaKIv7ePprDYhLTHgPROGhNhwmwsXxq5WBNu6axg/kUe9iLuJnzcdVUYLvm+nB8GA4UydllKAQDLxSGTuGpY0O4dAQPSwVP38iBUcZekdPu+yhldOBKJJiFCe3BPLGENuH30p9J2MyCdW5KIbeuP866MSghMxcy+M/tQns+2CLyPTD+cYG62hVjfQGtaZPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeRVYLyGgJjrBTXMAAKfv3LMr4DmMYWlfc5OvmOg+18=;
 b=bLBa5DGY1N/eqMy4wC4ZnifvSMzRg3748grB6ey0sDBs2VExXDQ8HWGutGo5mZe+FmcBcUf2nlFLXgGNa+NvSpBwB6QEbJnvNVqRCHJMbdYtqlH8Y+SsguL4uAHdM4BMnD0xRltqajnn8eGqzyNOjp+32hYkpvvKbRH2TC2R1cutctJJ2KhYbUjFfB46cPQ+yLhw/O7UnEGfnANAAmZjqsE7NA3ZfT2PkZgX5QaFZQwI2n9ibb7ZXlfsHGRTJHkOHjmMM/8xpQinV8G9QWo0ZupSeUL81S3WBCXHOPwjyLIA2Ev4LYY82XfeJt/eU70SLLQA4i0Rda9FhUVH6cN+qQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB6883.namprd12.prod.outlook.com (2603:10b6:510:1b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 19:59:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.016; Fri, 2 Sep 2022
 19:59:37 +0000
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
Subject: [PATCH RFC v2 01/13] interval-tree: Add a utility to iterate over spans in an interval tree
Date:   Fri,  2 Sep 2022 16:59:17 -0300
Message-Id: <1-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0117.namprd03.prod.outlook.com
 (2603:10b6:208:32a::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f39d287-a11d-4e95-efea-08da8d1da71a
X-MS-TrafficTypeDiagnostic: PH7PR12MB6883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kHtqtxfQM8fK0MSxVNPODtxc6ibl5jJpUgo8/gDKdwJotb4tyuNlDB9fjty+ijKdDBSWYiaK6f9TZL1jXgH98lXvzvJCd1G6GzxAl2KiPdzWo6WeSMWweJuAiB34rx6a1ph4lQeYeybRsjWlgS6VtKJvs+2uuTTO8hPQPrVVB3tAYGMF7skWG5hViIq2/xMIUaBZrSgcG3XV1+UKzkuMruvpV/K9nt52JBEj2U+Y/h5hKM4e1stwd/HRLP2IB7mbb5E2Egd9wu/UyOr5VFi7/AuWeZe3TQxMrP36zXZiphd1NsmbJ/dvFSIXUZZlWK2Va4Ei95dpABRv/uc1SoJP9a4URo4JQphDbAcvn1v3i6anpNLPyPGN/BX2boXFhS1FyOvYV962DmFqeQS8LrruFDSSexvmsusPjfnskz75bfwSWyEs/IGJadFY9PPcJSLgt+XI6zI1mtZ/xM4+NxLmmGL3Txfr7oi1kzjJmzGvSvVvk6DGz7ysbWpkKwckzMZaBKqo2RkfBLOlMaTYT1IMGvE21Ijw/YZolIafNpmy4Xyy6nnd0JyyHhOcQlwgm3Wq+T1y9n6XS4mc8zeVPP5vYLc0qXO6dzV7XiFUI21bqZKlLObOsg0SGVPgld3wdO7F5VF66iVIL2m5Hq2r8v8AKUAladBl3ZrtwjpWx61vbou+F7GMSY6DrG+J64JcdO8Gkmy6ecepfMg8H8opTPqGuB6OxdRDBbUurxn5rXyD2XNxMM8DJVd4nmyzcg1fYRtAFI9TgmNbwp1U22XQMfsi6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(6666004)(4326008)(66946007)(66476007)(66556008)(316002)(7416002)(54906003)(6506007)(26005)(478600001)(109986005)(6512007)(41300700001)(6486002)(38100700002)(86362001)(8676002)(186003)(2616005)(2906002)(5660300002)(8936002)(36756003)(83380400001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EXJfdz9mAh/NR8AS6VUbTu58dXVIKFZfgJXfCDX6sq1iobqT/q7B2+onsM2N?=
 =?us-ascii?Q?nCFkBkxH0ff39R2t6vpahi/bwwUAYpHRmIkvk1gvbLa6CHvaJ/CbnnYZr9Bi?=
 =?us-ascii?Q?4piVhRgZEJbuoujELLP3UIbeR7++mJnxp70fC4/u1brgzmwK+gN7782Aclrv?=
 =?us-ascii?Q?YsAjyKeBWx6LV2ryccXqhs6N8Yk5LMCUTWf3cssU+JvX03Mvmm0179CRZ9jz?=
 =?us-ascii?Q?aCRS1hOWGUODCkkiOktf8mZKyeEz/wSSeKF9TQTWExBrjs4d1Yi9r2jhs1G4?=
 =?us-ascii?Q?pTt/WalT2wdwZeGVhMsY45O3DtY1uYrafTOD2ZLb4XUlQ+n/qpqQ414HlU1l?=
 =?us-ascii?Q?tsx6Kuxh8cZ8CRwwsDY2nlO1cfXAETSwfVmsDtAZkrGplkb8n2xYmQykFuGR?=
 =?us-ascii?Q?nvCJ1a+wEqnNmkZZNnNcjt21ruNRcSKeNimGGV/7ATJm8nZJ3O0TZS422KyF?=
 =?us-ascii?Q?vuDhLQ8veg5xkEkN+0Sc7ToSmayw2mDlBl2brjIji/klG5o39H3mlEbMnVGH?=
 =?us-ascii?Q?noMdUZc+1wuBrcuzbVDapYY2oH6k9lJZazlaUDECF9FfW7KGJgMPTqni6daI?=
 =?us-ascii?Q?UCpOqbHum9sO30j0VpzTGaY51LzeUb4+ywPzNgoyVGk8KZeuCLchWoZDjFYm?=
 =?us-ascii?Q?WlJC+8J7JEjFWthtw27Acm50DAzu8whc4tcPPyRw6xONScV09d7bY3ckE8cC?=
 =?us-ascii?Q?/gzFMY3uG9DImEY/lEzndBS0/p3L8x7H1c17zJI5cZSPvReBoz0OqPBEf9Ao?=
 =?us-ascii?Q?Gl31DuOrrADLVMwuMoXJgR8LCb0QCa+Mb83sy4SE4Mgv2k5kf/EQUn5SWiul?=
 =?us-ascii?Q?rsbDrV/QpKBsRtHSDsQ3nHKNVoj/5TK43lIEMkGU46TE+Sx0rzoCg3whG5Dp?=
 =?us-ascii?Q?bZQ8z1Eyaw9k7BkMekFPI1aQ9TUgeRQGx4U78SQ6Ol3p4JFHZJ/U3FbJ2XVy?=
 =?us-ascii?Q?9Q3mcJG8HiDSdlVbGEud+uRlPQxLh3FUwDIeHlbIwX4go/wqLf8/nfs8WdId?=
 =?us-ascii?Q?uZs6z+W/Ff5XNaYdcsuIqywr+HnxVk04PW7dClZcm2CG74txxkMW0Gjlfr+f?=
 =?us-ascii?Q?fNJ9znin+MZO2cvZVBacK6l+67I+lUDSwu5xQhkoRiGsLqzw+3ga1s4TjI0K?=
 =?us-ascii?Q?LrXDjiQ5C2toisa3ZzstMnQpNJlb/l2tc0eTZVEgsHuyh4guqxVASWT6mYo9?=
 =?us-ascii?Q?B+CzaIbY6xF9pt6yYmORRrRKrW/o0nFnrmlmQDda5zw/iucAa3PvfUhxubsT?=
 =?us-ascii?Q?120TSWFOhDZHMvdn3nIRJEXYyfBxAFnh15OwM9icU+OWYdZ8cNdO755FwlHr?=
 =?us-ascii?Q?cVZImIuSo6aJ+pbE5lfTc8NpfXb0PVSbvh1IegggzLoPREdDr6jv/F1Nvpfx?=
 =?us-ascii?Q?iRvms1dFxlhhrQNKzyZWM7yrQ/7SuqD3TuDbPPo2WxUQouBL0JQoEKF6LYxV?=
 =?us-ascii?Q?4YfdUyz5YMqOIAKE6pIroOBy+MIaa8PT9eKqleghWKlUva1we11pHHBqpOqP?=
 =?us-ascii?Q?MsKWLJeulJsNH1QYuMYTVdtUyX+9y++tKjvvKc3wV3roDCL6zGzvIw2LFr4t?=
 =?us-ascii?Q?Tq3A81eCuCNPRSu68i/SBiUUNFw0tQW9Msqfo46v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f39d287-a11d-4e95-efea-08da8d1da71a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 19:59:32.5505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d5gpiG+WgZnDVhrBI8g7Xjqlvj33122xELVlCk60f5mQRimKgaiZYjcjxJW4pTGd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6883
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

The span iterator travels over the indexes of the interval_tree, not the
nodes, and classifies spans of indexes as either 'used' or 'hole'.

'used' spans are fully covered by nodes in the tree and 'hole' spans have
no node intersecting the span.

This is done greedily such that spans are maximally sized and every
iteration step switches between used/hole.

As an example a trivial allocator can be written as:

	for (interval_tree_span_iter_first(&span, itree, 0, ULONG_MAX);
	     !interval_tree_span_iter_done(&span);
	     interval_tree_span_iter_next(&span))
		if (span.is_hole &&
		    span.last_hole - span.start_hole >= allocation_size - 1)
			return span.start_hole;

With all the tricky boundary conditions handled by the library code.

The following iommufd patches have several algorithms for two of its
overlapping node interval trees that are significantly simplified with
this kind of iteration primitive. As it seems generally useful, put it
into lib/.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .clang-format                 |  1 +
 include/linux/interval_tree.h | 47 +++++++++++++++++
 lib/interval_tree.c           | 98 +++++++++++++++++++++++++++++++++++
 3 files changed, 146 insertions(+)

diff --git a/.clang-format b/.clang-format
index 1247d54f9e49fa..96d07786dcfb46 100644
--- a/.clang-format
+++ b/.clang-format
@@ -440,6 +440,7 @@ ForEachMacros:
   - 'inet_lhash2_for_each_icsk'
   - 'inet_lhash2_for_each_icsk_continue'
   - 'inet_lhash2_for_each_icsk_rcu'
+  - 'interval_tree_for_each_span'
   - 'intlist__for_each_entry'
   - 'intlist__for_each_entry_safe'
   - 'kcore_copy__for_each_phdr'
diff --git a/include/linux/interval_tree.h b/include/linux/interval_tree.h
index 288c26f50732d7..d52915d451177b 100644
--- a/include/linux/interval_tree.h
+++ b/include/linux/interval_tree.h
@@ -27,4 +27,51 @@ extern struct interval_tree_node *
 interval_tree_iter_next(struct interval_tree_node *node,
 			unsigned long start, unsigned long last);
 
+/*
+ * This iterator travels over spans in an interval tree. It does not return
+ * nodes but classifies each span as either a hole, where no nodes intersect, or
+ * a used, which is fully covered by nodes. Each iteration step toggles between
+ * hole and used until the entire range is covered. The returned spans always
+ * fully cover the requested range.
+ *
+ * The iterator is greedy, it always returns the largest hole or used possible,
+ * consolidating all consecutive nodes.
+ *
+ * Only is_hole, start_hole/used and last_hole/used are part of the external
+ * interface.
+ */
+struct interval_tree_span_iter {
+	struct interval_tree_node *nodes[2];
+	unsigned long first_index;
+	unsigned long last_index;
+	union {
+		unsigned long start_hole;
+		unsigned long start_used;
+	};
+	union {
+		unsigned long last_hole;
+		unsigned long last_used;
+	};
+	/* 0 == used, 1 == is_hole, -1 == done iteration */
+	int is_hole;
+};
+
+void interval_tree_span_iter_first(struct interval_tree_span_iter *state,
+				   struct rb_root_cached *itree,
+				   unsigned long first_index,
+				   unsigned long last_index);
+void interval_tree_span_iter_next(struct interval_tree_span_iter *state);
+
+static inline bool
+interval_tree_span_iter_done(struct interval_tree_span_iter *state)
+{
+	return state->is_hole == -1;
+}
+
+#define interval_tree_for_each_span(span, itree, first_index, last_index)      \
+	for (interval_tree_span_iter_first(span, itree,                        \
+					   first_index, last_index);           \
+	     !interval_tree_span_iter_done(span);                              \
+	     interval_tree_span_iter_next(span))
+
 #endif	/* _LINUX_INTERVAL_TREE_H */
diff --git a/lib/interval_tree.c b/lib/interval_tree.c
index 593ce56ece5050..5dff0da020923f 100644
--- a/lib/interval_tree.c
+++ b/lib/interval_tree.c
@@ -15,3 +15,101 @@ EXPORT_SYMBOL_GPL(interval_tree_insert);
 EXPORT_SYMBOL_GPL(interval_tree_remove);
 EXPORT_SYMBOL_GPL(interval_tree_iter_first);
 EXPORT_SYMBOL_GPL(interval_tree_iter_next);
+
+static void
+interval_tree_span_iter_next_gap(struct interval_tree_span_iter *state)
+{
+	struct interval_tree_node *cur = state->nodes[1];
+
+	/*
+	 * Roll nodes[1] into nodes[0] by advancing nodes[1] to the end of a
+	 * contiguous span of nodes. This makes nodes[0]->last the end of that
+	 * contiguous span of valid indexes that started at the original
+	 * nodes[1]->start. nodes[1] is now the next node and a hole is between
+	 * nodes[0] and [1].
+	 */
+	state->nodes[0] = cur;
+	do {
+		if (cur->last > state->nodes[0]->last)
+			state->nodes[0] = cur;
+		cur = interval_tree_iter_next(cur, state->first_index,
+					      state->last_index);
+	} while (cur && (state->nodes[0]->last >= cur->start ||
+			 state->nodes[0]->last + 1 == cur->start));
+	state->nodes[1] = cur;
+}
+
+void interval_tree_span_iter_first(struct interval_tree_span_iter *iter,
+				   struct rb_root_cached *itree,
+				   unsigned long first_index,
+				   unsigned long last_index)
+{
+	iter->first_index = first_index;
+	iter->last_index = last_index;
+	iter->nodes[0] = NULL;
+	iter->nodes[1] =
+		interval_tree_iter_first(itree, first_index, last_index);
+	if (!iter->nodes[1]) {
+		/* No nodes intersect the span, whole span is hole */
+		iter->start_hole = first_index;
+		iter->last_hole = last_index;
+		iter->is_hole = 1;
+		return;
+	}
+	if (iter->nodes[1]->start > first_index) {
+		/* Leading hole on first iteration */
+		iter->start_hole = first_index;
+		iter->last_hole = iter->nodes[1]->start - 1;
+		iter->is_hole = 1;
+		interval_tree_span_iter_next_gap(iter);
+		return;
+	}
+
+	/* Starting inside a used */
+	iter->start_used = first_index;
+	iter->is_hole = 0;
+	interval_tree_span_iter_next_gap(iter);
+	iter->last_used = iter->nodes[0]->last;
+	if (iter->last_used >= last_index) {
+		iter->last_used = last_index;
+		iter->nodes[0] = NULL;
+		iter->nodes[1] = NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(interval_tree_span_iter_first);
+
+void interval_tree_span_iter_next(struct interval_tree_span_iter *iter)
+{
+	if (!iter->nodes[0] && !iter->nodes[1]) {
+		iter->is_hole = -1;
+		return;
+	}
+
+	if (iter->is_hole) {
+		iter->start_used = iter->last_hole + 1;
+		iter->last_used = iter->nodes[0]->last;
+		if (iter->last_used >= iter->last_index) {
+			iter->last_used = iter->last_index;
+			iter->nodes[0] = NULL;
+			iter->nodes[1] = NULL;
+		}
+		iter->is_hole = 0;
+		return;
+	}
+
+	if (!iter->nodes[1]) {
+		/* Trailing hole */
+		iter->start_hole = iter->nodes[0]->last + 1;
+		iter->last_hole = iter->last_index;
+		iter->nodes[0] = NULL;
+		iter->is_hole = 1;
+		return;
+	}
+
+	/* must have both nodes[0] and [1], interior hole */
+	iter->start_hole = iter->nodes[0]->last + 1;
+	iter->last_hole = iter->nodes[1]->start - 1;
+	iter->is_hole = 1;
+	interval_tree_span_iter_next_gap(iter);
+}
+EXPORT_SYMBOL_GPL(interval_tree_span_iter_next);
-- 
2.37.3

