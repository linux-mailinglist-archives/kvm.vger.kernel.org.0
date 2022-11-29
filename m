Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F8F63C938
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbiK2U3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235210AbiK2U3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:29:49 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D8463B91
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:29:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUq4tzpGgOc5QbLSHdkvZF+4IAy7WB3yMvA7atY0q7DqUZCcQcDx9DK26oQYrsB5X348n6kh/B2z0rc+++1loIqJPTK32sMds6itbWSpVqbQ+LUyMBOioxazRg3i0LYdmracB616XowhAQa1vL0vQ/v6LlfUevILywFQfg0Alsw3vGl9yfR5v0jyNYIYIYHFDdfJjpK/aIfm3vZ37xYNPXO862kjoQnYQ6xQBpjXODch+uSEdxSY0oe67NR4fP27acAIZEudrzDNjAOWnXwf07M49uDV8AHr9B67EkIfRjO/txcvKfZU8Ct/eJ2vLO1DR81X7x2mBtQWmVU+rpHuFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nferIdE5hEyQVrK+uXaRn9YN26fsfcsmwb7nmE0obQ4=;
 b=cjkJKCzBcZTsmBW78MdIOWh9ZiETOkvJWCgtcGkv5w48nedEXSPSKLuoxyuRa8ZqXdydR8sG+6Fr43F35Zv/hxRV3fVN3OVzVhpKjfQ46gAKKMxs3a/PKRNyZxTlUxCn1rMGnt8jrC+m9BXcAP4cWtSq2kgHnS+AdLgyHI+tfs4YkiptoiIm4YEsUMOopmsoSNSZj1awJASzRN9HDC3fO7CItrOZDBQUaA11pq8e0eX9+jrmAcupWAZiMkFkx7K4M9WUqklle93fqaLUPmiAWpnxub6ZrogA0MJs/+qSxfo2PlGtKnpfSCuUX0DGgc++wioYSx69z5XXkWn+f792HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nferIdE5hEyQVrK+uXaRn9YN26fsfcsmwb7nmE0obQ4=;
 b=iCEWpLrp3PFZt7lN/DC0V2B7GYB7tsXYKybHvPMdD9zPKD7hUiyHomj1BAjViQTH/YQ22RQ9+DuTp/lHPbTiUocppRWCU1Uy69MVWgmuWOK22fR4qFXTO1rCMGjynWLAepK1U422fbhWY8BORBtKXvQRORwtNySHebdcE+ZeDW/CzGMu71kRZgVAtHZQ6rKxnpjvsTuBzkflcyFy6VApRHcehbl1aeELTgy5Y3yBDc2SkZqUGhaGjmTK+EjQDc+s4/jBIDF9uPk7eF+1Z2vqokvlhH9mKho9cQ/qLbbPrt6bXAWrrz8+p0e+qZywxOOeQC36sK3czYTsyb56ThfV5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:45 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v6 03/19] interval-tree: Add a utility to iterate over spans in an interval tree
Date:   Tue, 29 Nov 2022 16:29:26 -0400
Message-Id: <3-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:a03:74::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fe62383-186b-491b-e11a-08dad2487396
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tuali8LpGapLljwLag3xyZ69leErKp7mOB6PLcG2pZGB57zkVvv0Yskg6SdRdTbmomG3adOsnqkpSwM0tMmDGTtJAnXqStqA+mwAomAStg1SKOJ0G58DtP5AJaT1vFOY9zcHoYbsIPN/RDXTcH/d/lnXc4sC42FzsDO10cvvCKb48TzgIpgGxIUVke9w0Bz7Wry1Qv6CW7aMvfeTXMpYR7CRZvDVTPjApMQa3hkshd7OouN9c9Rp4b/VqsKJX0C+QICTEcvb3SuDqZLtIpdHTmT6DlQQailCbeskmg0edeS4273z6YPTTqVVSyJ4dlGc2ni3Th+5iwadL7frHwitJYUM9iHwCGrks/2DK9vruel2lYsW80F4Y8ZYm8yz4b2yVvj4bBFHTDFoOFC7WOFy5DPMmvq2EnINhHXlBMH+qUuP1Tqkx433AESupukVBOEdTXpkuHDYIeXXoCYFfEMtpGVXQ+QbA7EIaIBLVJNQTYgJbphQMWuPl3qrxIqq3GTFmxA/dMYsxugelGnpcv6SMIfF2TSCmZkOltE7eEuSmEM8axWHutGhUm142taPyuzRcPFtW+TexgfQExo7vmUyvfpbB2d6nSASod5oVifml1Ar/IquIIZA52bD/fkfC4r5bnGlwBXfoocCX9WAxHYnslfBGudjPzCDYJ0BcbI9KXBZVvq+6/iMjq+dsub2ZJSDnjY/XqxbR2uywxmfrWfUhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(109986013)(36756003)(86362001)(54906003)(6486002)(316002)(478600001)(2906002)(66476007)(66556008)(66946007)(4326008)(8936002)(7416002)(41300700001)(8676002)(5660300002)(83380400001)(38100700002)(26005)(6506007)(6666004)(6512007)(186003)(2616005)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8/LmXXAb5+NTep6CfNUkN/Y+Njq3PWuDCDfusohU16RVKkcq8fDjczPa6tjZ?=
 =?us-ascii?Q?AF1lrx1xlXsNkBjxh4MvTAki4ZCW4sE5a7/mQ/ATN4QeDs1e+wxBgumr94iv?=
 =?us-ascii?Q?HDEsLyCxhcMeJ4Q5CE83jAfgPbGOmNJXNl80O6rIJqx3hLpZoJcSwpls1j+x?=
 =?us-ascii?Q?tnXbNd54P1LNqmXNadakEOFQ2EHe4pKk+Nd+gSQtZtnZqicuyJGoNCF7zBw5?=
 =?us-ascii?Q?WEB/pQHol+O/JGf+iVmqm5UtRE7utoKxQGLvtIvLRPRAbuOoTYRSK9xQaOLm?=
 =?us-ascii?Q?vGqYusmiPam21iYblWrKPn7ziJ4a0C4UMnOT5lWfcw3a2+DfDPCg+wrM9NqD?=
 =?us-ascii?Q?LYAbCmbDNjPhaLp74TwdYVlBkl6TZ5D/lN3evrTHhXWQdjqy4i9OQcHEeQNS?=
 =?us-ascii?Q?VTv4ew977IHmBJ9T7yEfYIRfqzMNBg7Le3saOxtONF5tn5fVcDk1umEmHcPJ?=
 =?us-ascii?Q?JGcy+YGI20r1zlcclCWYMz/wOR4LfAUx2Ec7AwqBe8eTpfvaseGmPH46mNYD?=
 =?us-ascii?Q?6vPt7i3gYzfj/N31uRB9V/J7+oWaeMMe1JcNeftYImmhZTmx73j8rWKpuwL2?=
 =?us-ascii?Q?i2l00wcQQwCtBgoISQkOkaBV6yMj3O8u9cYsmU5KqHO+mQZNTV43k84IOfGR?=
 =?us-ascii?Q?thzAZGF7FTkj9tO7hwDgemhCgobfItrgje3su1n3Xb01DHXKHL2mjpC8mlqJ?=
 =?us-ascii?Q?cF/DlzC5FOxXUcEMTdXgn2lzDEw4eKKF2TyiedS8DEaN2doyU6mzny4ZQVsO?=
 =?us-ascii?Q?q2yAnnzk85/Lqx7uQLwtoAI8EVTbRCbBGBBMttnFxsDdMpU7oOJHYzxi7KFP?=
 =?us-ascii?Q?qxx9F56CMOLSuITQV8IAvPLqv+O8sDDFAwAD+WqDIi8Mc/f47T2RKqVNvpxj?=
 =?us-ascii?Q?2wWMz3Nq0XDmlpz9gAYG7iU65DlUa111NbztbLTtiXe/uGtcjWsrGhWUy3wi?=
 =?us-ascii?Q?Qqaj9EX1dgAQ4kHYRn6eLTxR4aPD3uzhTRcv/yfvclRv5JhzQ9bIdvydCbP6?=
 =?us-ascii?Q?FKr6NRKvY207172rHMUdZneLe7S3KoM76+aIvwTbaP3hfcfzW4HLLmVslbIR?=
 =?us-ascii?Q?IWs6VbFalVN49QTImCN7Y0sXqdHziaoKo3kLkrnJlcaebaHfy+Wi/M0jHR+Y?=
 =?us-ascii?Q?ad//zzEyN/qsWCWkzl9gQjHtl8YhJy+P9U7iPXp6J6pvG0CUdx/4w2vSKG4c?=
 =?us-ascii?Q?+wms+6tFGsyllMZawzUkoWcR252nLPFylwTX3GRMVcEsojj65iuhc4tpdHs1?=
 =?us-ascii?Q?IhODcE0DrY5ema9yDTplfFJteGcdCNrNsT+mde91j147SOiSK337zdH8YGGS?=
 =?us-ascii?Q?VK41AjA3KZu1n6dB+FnkU2tFI4cN+s0uAq8BEAHBgLc+fjsgf6WRmcTAbJYg?=
 =?us-ascii?Q?PzvFJ65tkWRk1ZPeiqmkcSMnoi2PCvF8FFRt24bjyAxu5Y73rpgYMz2KQeVC?=
 =?us-ascii?Q?QZ4gz1aPwTwlGb47Zv0zpMHdr5nPa/dgw0y/+3ot9uO8OQGY9jOgD+DhzGz3?=
 =?us-ascii?Q?XHsYk8Xuhro1j4OrDTXh5K0b/Cdl3/tNHJcYcQ0pS74E8d4PKgVtwPLbPFJk?=
 =?us-ascii?Q?/FDKkRI8Fn6MTB0YkhSwarD0CD0RLEGhQYVwBkqO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe62383-186b-491b-e11a-08dad2487396
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:44.9154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vbaAEVH+EgoCX2E7hT8ol0e0NuRKXaiZy/WT7mezNHmjzBy66e/pJfXMbxIp4+GU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6059
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

The following iommufd patches have several algorithms for its overlapping
node interval trees that are significantly simplified with this kind of
iteration primitive. As it seems generally useful, put it into lib/.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .clang-format                 |   1 +
 include/linux/interval_tree.h |  58 +++++++++++++++
 lib/Kconfig                   |   4 ++
 lib/interval_tree.c           | 132 ++++++++++++++++++++++++++++++++++
 4 files changed, 195 insertions(+)

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
index 288c26f50732d7..2b8026a3990645 100644
--- a/include/linux/interval_tree.h
+++ b/include/linux/interval_tree.h
@@ -27,4 +27,62 @@ extern struct interval_tree_node *
 interval_tree_iter_next(struct interval_tree_node *node,
 			unsigned long start, unsigned long last);
 
+/**
+ * struct interval_tree_span_iter - Find used and unused spans.
+ * @start_hole: Start of an interval for a hole when is_hole == 1
+ * @last_hole: Inclusive end of an interval for a hole when is_hole == 1
+ * @start_used: Start of a used interval when is_hole == 0
+ * @last_used: Inclusive end of a used interval when is_hole == 0
+ * @is_hole: 0 == used, 1 == is_hole, -1 == done iteration
+ *
+ * This iterator travels over spans in an interval tree. It does not return
+ * nodes but classifies each span as either a hole, where no nodes intersect, or
+ * a used, which is fully covered by nodes. Each iteration step toggles between
+ * hole and used until the entire range is covered. The returned spans always
+ * fully cover the requested range.
+ *
+ * The iterator is greedy, it always returns the largest hole or used possible,
+ * consolidating all consecutive nodes.
+ *
+ * Use interval_tree_span_iter_done() to detect end of iteration.
+ */
+struct interval_tree_span_iter {
+	/* private: not for use by the caller */
+	struct interval_tree_node *nodes[2];
+	unsigned long first_index;
+	unsigned long last_index;
+
+	/* public: */
+	union {
+		unsigned long start_hole;
+		unsigned long start_used;
+	};
+	union {
+		unsigned long last_hole;
+		unsigned long last_used;
+	};
+	int is_hole;
+};
+
+void interval_tree_span_iter_first(struct interval_tree_span_iter *state,
+				   struct rb_root_cached *itree,
+				   unsigned long first_index,
+				   unsigned long last_index);
+void interval_tree_span_iter_advance(struct interval_tree_span_iter *iter,
+				     struct rb_root_cached *itree,
+				     unsigned long new_index);
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
diff --git a/lib/Kconfig b/lib/Kconfig
index 9bbf8a4b2108e6..c6c323fd251721 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -479,6 +479,10 @@ config INTERVAL_TREE
 
 	  for more information.
 
+config INTERVAL_TREE_SPAN_ITER
+	bool
+	depends on INTERVAL_TREE
+
 config XARRAY_MULTI
 	bool
 	help
diff --git a/lib/interval_tree.c b/lib/interval_tree.c
index 593ce56ece5050..3412737ff365ec 100644
--- a/lib/interval_tree.c
+++ b/lib/interval_tree.c
@@ -15,3 +15,135 @@ EXPORT_SYMBOL_GPL(interval_tree_insert);
 EXPORT_SYMBOL_GPL(interval_tree_remove);
 EXPORT_SYMBOL_GPL(interval_tree_iter_first);
 EXPORT_SYMBOL_GPL(interval_tree_iter_next);
+
+#ifdef CONFIG_INTERVAL_TREE_SPAN_ITER
+/*
+ * Roll nodes[1] into nodes[0] by advancing nodes[1] to the end of a contiguous
+ * span of nodes. This makes nodes[0]->last the end of that contiguous used span
+ * indexes that started at the original nodes[1]->start. nodes[1] is now the
+ * first node starting the next used span. A hole span is between nodes[0]->last
+ * and nodes[1]->start. nodes[1] must be !NULL.
+ */
+static void
+interval_tree_span_iter_next_gap(struct interval_tree_span_iter *state)
+{
+	struct interval_tree_node *cur = state->nodes[1];
+
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
+
+/*
+ * Advance the iterator index to a specific position. The returned used/hole is
+ * updated to start at new_index. This is faster than calling
+ * interval_tree_span_iter_first() as it can avoid full searches in several
+ * cases where the iterator is already set.
+ */
+void interval_tree_span_iter_advance(struct interval_tree_span_iter *iter,
+				     struct rb_root_cached *itree,
+				     unsigned long new_index)
+{
+	if (iter->is_hole == -1)
+		return;
+
+	iter->first_index = new_index;
+	if (new_index > iter->last_index) {
+		iter->is_hole = -1;
+		return;
+	}
+
+	/* Rely on the union aliasing hole/used */
+	if (iter->start_hole <= new_index && new_index <= iter->last_hole) {
+		iter->start_hole = new_index;
+		return;
+	}
+	if (new_index == iter->last_hole + 1)
+		interval_tree_span_iter_next(iter);
+	else
+		interval_tree_span_iter_first(iter, itree, new_index,
+					      iter->last_index);
+}
+EXPORT_SYMBOL_GPL(interval_tree_span_iter_advance);
+#endif
-- 
2.38.1

