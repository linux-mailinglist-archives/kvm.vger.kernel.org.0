Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C91C4DDFE7
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239624AbiCRR3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239613AbiCRR3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:29:05 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585461D7624
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:27:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvdtT5veeKB9K7Xxl46BEnFsAirW8cXyEJUvJH4NpqFX51CBGikKffjjd1jnl144gCQB/bPSl+WFzaUWPOdGt5MRPMRTiFodLo7IXYeR8+BAQBKnIM0Cc/x/UmZmqOlTrql1fDhl/+oz0lp2hRCu4fx+Q6nMkiXu97uBF0OxV+R6ZixubccRctzIBsot+UiqCPeZlLt5k46evRJ5NhY+zsu/v0FF9VmKfaAjxwkXhGsURObkevBeBD8zG0Vh80SOMHEQGd1lX5mqebo+xFdr4Gs8LfxDi0I9TuRRxpmPeqwlERqibb8NEaQSgZwxOnRzUrfzbfTJSjM5e5IGOUDXAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bqlkb2PSxtqKZOydzs2JIEOWy3w4o3YH4y7fwLO/xsA=;
 b=jjemnXGR0Lnhw8m0dcrhkVmPWH+eX6qIcbiiutqnQr6dCoXEcXgZ7z3EoSpjL4s1gOU3k3mggzsr2JZy2iEb01diKbMhjmbyyUsMGQ2JnoWlVj+fUalEcRQR79AWEV69VpiaHQrBBQubxKDHGo1IDbAl3sS7voZDXwLbtN+EPjEg7tlnk/IFZ4gt4fobcEy6dBmJdfZ0cBjjYRA+kH/3SGqh0jpXdQAQElu6tlYHNPVioiP+ipjAieFq9r8XP0PbqbL/HeaEtIwtVV+YMzBIiCpZVYbINrqIj/Mta7eENNs5IGKUnFiOA6zFey6vD+Ho08HHCk/FDskkARH+t9zNIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqlkb2PSxtqKZOydzs2JIEOWy3w4o3YH4y7fwLO/xsA=;
 b=SrrMbieNOSdBqp/gZLa4bZGyQxgqpo6J4TCbYge9fsqquAxJ6uFp97UM+p0a7ijjcKP7GXtQznPMcpCACRglZSSn4Pm2WzcpuRckQIXZJtbZSrIwlyXh3vqzBB7CslluhA4vKgWWJ74IJZmyl3lZ8xJkEEjGUOB5yJ5QCzDrZ5f8VkjyQG8bBthwvAwm2WT+5VPbtci0KjcGcwESVbwoVgAAdoOJqdyeovuA+WKptpLHaBBzKCVrj/3zinB45t/Z7OCMQkO/0CVJoEaqqGc1VcDhbnuECS4xaDsP9JnKAx0OrJNYsEP6qJDS/qQ+qNECEsY8UsBuP+jvigoVsX3jnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3951.namprd12.prod.outlook.com (2603:10b6:208:16b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 17:27:41 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 17:27:41 +0000
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
Subject: [PATCH RFC 07/12] iommufd: Data structure to provide IOVA to PFN mapping
Date:   Fri, 18 Mar 2022 14:27:32 -0300
Message-Id: <7-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0063.namprd19.prod.outlook.com
 (2603:10b6:208:19b::40) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5427f27-41a1-42a2-7fc2-08da090499ce
X-MS-TrafficTypeDiagnostic: MN2PR12MB3951:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB39510491AB2A01015683AF0FC2139@MN2PR12MB3951.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7KCIx+nth6DtfKalgRoK3mLkDjwH5p48s40pK9cHcyVTfoM5g9OpSqaAwTTEgl3BiPvFuQFd7QAdsJq5ZwhhHR26CJHFaYAs4cUyX+tGlQGFy1H+zwxweHcUy0zvCfgdksl4HnB0PH6SbrogwGTTxzqdzi7+t0ZHTi7Kn9/U8ICKaA6R03F0t8zivhJUyEY75KiUs1mqs83w/3sOZlfj3bQj3bylMAX0GrD9qiI5dS3ecLD22RYZatcoXxSED311pltva39UUJq32Uh6CR2WOgpiwpFn+oBrgBrGzo3MI19hwFwbhWkml5uT6miG1QUEkzO8qnldyg1NewWsyYRuoq6Sge9gWgB9mtjkWCpaAvdrSM55GJePVpktiD+oial5S2tuC02ZbRv14DkRSyKIHdgyQ9+hQnCph4m1iAgZsQDAYFHKIBbH8WiT1P9SxU7XTo6PPXg2AJ1jTUymbpx9mSCZSETRIh6toX1akmf/xCVnd4IFWRMxG8V5bP8NST6Xv5wPF2ewPl6+J6rIxDhd7csmzlXrugXB4cMU4ft2OfLFILtemjStFb6z5lAJM1a7Hix9Z5BKLup94Z9HzOYFVV/85QW+PKtM8rYIh3TufWsSgdCKR34g8oE9vaX74526SPpbxDsXogs9O6tFbINavKw0q7KL1CK2V1QyAoSomi6upLUX1qPWlbWfN+gkgJc3aIm9UXFhtNN4cJzAx8cO0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(83380400001)(7416002)(4326008)(2906002)(86362001)(508600001)(8676002)(6512007)(6506007)(6666004)(5660300002)(8936002)(109986005)(66946007)(26005)(66476007)(186003)(316002)(66556008)(2616005)(36756003)(38100700002)(6486002)(54906003)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IlmPkWcYugldH3cC/9z0oTLRMXWx+7Stx9uVah1EI3cAD4ymnC0aOOUudmtK?=
 =?us-ascii?Q?tC1WcPHmourq3rFigrUJeN2Dl9eg0ur6O9JhgjGTtswf+Ca5OdeY47F1tAr0?=
 =?us-ascii?Q?M3OoXVp40TYQr1lhX74pv4VSTubYVfUWp6nEKcbYOHpw1d3zxk81ODTtXDQf?=
 =?us-ascii?Q?ssspmP91ABKvL+AqGIbYvSoXydANJdzclPP2uCrDzUlqso9yS3jP7/59/YfP?=
 =?us-ascii?Q?lzXepnxExfl/IhfbhGNwjUPwRmMSqV6WZrjdpF4YCmbdqSEwvdLpaxdH5hSe?=
 =?us-ascii?Q?gEvQCj/wsV1ZhcMgKr+0plprEBv09cOMb6vfKT1pEuKsbOBVuFa92JyRiDmf?=
 =?us-ascii?Q?WM0XZa5/sTKbC8Wa5/2Rhbszo7zznjic+q9E72tHCO9p6S/LlhOv7ViUCuJL?=
 =?us-ascii?Q?UmmEtAswHgzWIz46psH1z6i+yqRYi1dJ2LJEfjhIS4qK5Qdi4xs2XTEmlaa8?=
 =?us-ascii?Q?ymxSb+IGSeYLOkDKxRq2mCrkWcymtR6oa9doOGIZ9EvkiLSISzlKSK6TXu4b?=
 =?us-ascii?Q?wfCkZekqum/qLm8e2FNtLSU3eiD1j+a3ZZsSs0YZBZe6o3xdLy07MgtWtzT8?=
 =?us-ascii?Q?/HcvqnJRSSwUQne1gP6v4wwmDBwtpogj/xqYKg+yMHzKph+Pp9Pq0kwiAAta?=
 =?us-ascii?Q?2mplVilH0CapQ9KU8Ea+7BsogHY4tb0B9Youu4AEoFNQ6HSiVuUwdcJyFeT/?=
 =?us-ascii?Q?auPgCMon6knlixt1PA8RTjSUV7roIc/DUoucUDedrThNOnsFIcLexSMOK22e?=
 =?us-ascii?Q?7cYS/UGfQUZIqhOnnC9BLudRvb04q/5ypDuee4lQcwRS2GmG1hzEAexhsjRv?=
 =?us-ascii?Q?iqJ0C9GrzxfkzxB1eEWm0CG1FcEwS8KsLJpSFFo3FsjCaTVhzn/4RCP6aUbs?=
 =?us-ascii?Q?ROHNW34t+KcQKDBC5o1T6obDXvH6Q8BqQ8oPTuKNGlS63k5Pxq42jWT4dn9c?=
 =?us-ascii?Q?BAUqsA6yORnlqUgO+S1cirX5DtruoYTQh6LrCqIdk6/x1p9XQL/VkhdDtl1d?=
 =?us-ascii?Q?SwYwDZHsPmJ1RDVf5xpqKBosVjjc9UMo4CVorEGEx1GNNhRrqB0TlIr3nZ68?=
 =?us-ascii?Q?+c+W+CKRw6yWWlQ2y+ovZ1mVUJcSztUonvH4BZwfZ4bCUHsP5N3/IXfVTp+O?=
 =?us-ascii?Q?scgJS/jNBhM1KQOznmBWRozj3lfRd8YHiffoU/OB14f80Ca/4ABYBZbJmC+d?=
 =?us-ascii?Q?P9t0mVrFBI61uVVrpr3/gWIHJ0ZAa+Hf8rb63vguYUR9dzedgmPWuvdkg8Ja?=
 =?us-ascii?Q?KM6UyH+Ytkz0WOXZHhncMlMF4ziJ1mfOYzXHWuARc+wU/8e6IRCXn7qRtXJc?=
 =?us-ascii?Q?+ygGq5U31V3drPv5nwOlXXtuxEM7w3fjpd+fb9AHgi4JOek2Vd9smQ3Sh+W3?=
 =?us-ascii?Q?zMo3P1OUrurpb63NU4wYca3rTAhOCldCv0X3CtGVkDMOwaGDnZXC3ZKDhtS/?=
 =?us-ascii?Q?xot5s7DjFh0wUFKhFOp3M6E5XWSOybWq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5427f27-41a1-42a2-7fc2-08da090499ce
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:27:39.3824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2sL4d/lGERvHuqiUt6tXxxg33Ua52tCTNNcMKEGt+HX90t0hi+BaW3MDna2DR0zM
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

This is the remainder of the IOAS data structure. Provide an object called
an io_pagetable that is composed of iopt_areas pointing at iopt_pages,
along with a list of iommu_domains that mirror the IOVA to PFN map.

At the top this is a simple interval tree of iopt_areas indicating the map
of IOVA to iopt_pages. An xarray keeps track of a list of domains. Based
on the attached domains there is a minimum alignment for areas (which may
be smaller than PAGE_SIZE) and an interval tree of reserved IOVA that
can't be mapped.

The concept of a 'user' refers to something like a VFIO mdev that is
accessing the IOVA and using a 'struct page *' for CPU based access.

Externally an API is provided that matches the requirements of the IOCTL
interface for map/unmap and domain attachment.

The API provides a 'copy' primitive to establish a new IOVA map in a
different IOAS from an existing mapping.

This is designed to support a pre-registration flow where userspace would
setup an dummy IOAS with no domains, map in memory and then establish a
user to pin all PFNs into the xarray.

Copy can then be used to create new IOVA mappings in a different IOAS,
with iommu_domains attached. Upon copy the PFNs will be read out of the
xarray and mapped into the iommu_domains, avoiding any pin_user_pages()
overheads.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |   1 +
 drivers/iommu/iommufd/io_pagetable.c    | 890 ++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h |  35 +
 3 files changed, 926 insertions(+)
 create mode 100644 drivers/iommu/iommufd/io_pagetable.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index 05a0e91e30afad..b66a8c47ff55ec 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 iommufd-y := \
+	io_pagetable.o \
 	main.o \
 	pages.o
 
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
new file mode 100644
index 00000000000000..f9f3b06946bfb9
--- /dev/null
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -0,0 +1,890 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES.
+ *
+ * The io_pagetable is the top of datastructure that maps IOVA's to PFNs. The
+ * PFNs can be placed into an iommu_domain, or returned to the caller as a page
+ * list for access by an in-kernel user.
+ *
+ * The datastructure uses the iopt_pages to optimize the storage of the PFNs
+ * between the domains and xarray.
+ */
+#include <linux/lockdep.h>
+#include <linux/iommu.h>
+#include <linux/sched/mm.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+
+#include "io_pagetable.h"
+
+static unsigned long iopt_area_iova_to_index(struct iopt_area *area,
+					     unsigned long iova)
+{
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(iova < iopt_area_iova(area) ||
+			iova > iopt_area_last_iova(area));
+	return (iova - (iopt_area_iova(area) & PAGE_MASK)) / PAGE_SIZE;
+}
+
+static struct iopt_area *iopt_find_exact_area(struct io_pagetable *iopt,
+					      unsigned long iova,
+					      unsigned long last_iova)
+{
+	struct iopt_area *area;
+
+	area = iopt_area_iter_first(iopt, iova, last_iova);
+	if (!area || !area->pages || iopt_area_iova(area) != iova ||
+	    iopt_area_last_iova(area) != last_iova)
+		return NULL;
+	return area;
+}
+
+static bool __alloc_iova_check_hole(struct interval_tree_span_iter *span,
+				    unsigned long length,
+				    unsigned long iova_alignment,
+				    unsigned long page_offset)
+{
+	if (!span->is_hole || span->last_hole - span->start_hole < length - 1)
+		return false;
+
+	span->start_hole =
+		ALIGN(span->start_hole, iova_alignment) | page_offset;
+	if (span->start_hole > span->last_hole ||
+	    span->last_hole - span->start_hole < length - 1)
+		return false;
+	return true;
+}
+
+/*
+ * Automatically find a block of IOVA that is not being used and not reserved.
+ * Does not return a 0 IOVA even if it is valid.
+ */
+static int iopt_alloc_iova(struct io_pagetable *iopt, unsigned long *iova,
+			   unsigned long uptr, unsigned long length)
+{
+	struct interval_tree_span_iter reserved_span;
+	unsigned long page_offset = uptr % PAGE_SIZE;
+	struct interval_tree_span_iter area_span;
+	unsigned long iova_alignment;
+
+	lockdep_assert_held(&iopt->iova_rwsem);
+
+	/* Protect roundup_pow-of_two() from overflow */
+	if (length == 0 || length >= ULONG_MAX / 2)
+		return -EOVERFLOW;
+
+	/*
+	 * Keep alignment present in the uptr when building the IOVA, this
+	 * increases the chance we can map a THP.
+	 */
+	if (!uptr)
+		iova_alignment = roundup_pow_of_two(length);
+	else
+		iova_alignment =
+			min_t(unsigned long, roundup_pow_of_two(length),
+			      1UL << __ffs64(uptr));
+
+	if (iova_alignment < iopt->iova_alignment)
+		return -EINVAL;
+	for (interval_tree_span_iter_first(&area_span, &iopt->area_itree,
+					   PAGE_SIZE, ULONG_MAX - PAGE_SIZE);
+	     !interval_tree_span_iter_done(&area_span);
+	     interval_tree_span_iter_next(&area_span)) {
+		if (!__alloc_iova_check_hole(&area_span, length, iova_alignment,
+					     page_offset))
+			continue;
+
+		for (interval_tree_span_iter_first(
+			     &reserved_span, &iopt->reserved_iova_itree,
+			     area_span.start_hole, area_span.last_hole);
+		     !interval_tree_span_iter_done(&reserved_span);
+		     interval_tree_span_iter_next(&reserved_span)) {
+			if (!__alloc_iova_check_hole(&reserved_span, length,
+						     iova_alignment,
+						     page_offset))
+				continue;
+
+			*iova = reserved_span.start_hole;
+			return 0;
+		}
+	}
+	return -ENOSPC;
+}
+
+/*
+ * The area takes a slice of the pages from start_bytes to start_byte + length
+ */
+static struct iopt_area *
+iopt_alloc_area(struct io_pagetable *iopt, struct iopt_pages *pages,
+		unsigned long iova, unsigned long start_byte,
+		unsigned long length, int iommu_prot, unsigned int flags)
+{
+	struct iopt_area *area;
+	int rc;
+
+	area = kzalloc(sizeof(*area), GFP_KERNEL);
+	if (!area)
+		return ERR_PTR(-ENOMEM);
+
+	area->iopt = iopt;
+	area->iommu_prot = iommu_prot;
+	area->page_offset = start_byte % PAGE_SIZE;
+	area->pages_node.start = start_byte / PAGE_SIZE;
+	if (check_add_overflow(start_byte, length - 1, &area->pages_node.last))
+		return ERR_PTR(-EOVERFLOW);
+	area->pages_node.last = area->pages_node.last / PAGE_SIZE;
+	if (WARN_ON(area->pages_node.last >= pages->npages))
+		return ERR_PTR(-EOVERFLOW);
+
+	down_write(&iopt->iova_rwsem);
+	if (flags & IOPT_ALLOC_IOVA) {
+		rc = iopt_alloc_iova(iopt, &iova,
+				     (uintptr_t)pages->uptr + start_byte,
+				     length);
+		if (rc)
+			goto out_unlock;
+	}
+
+	if (check_add_overflow(iova, length - 1, &area->node.last)) {
+		rc = -EOVERFLOW;
+		goto out_unlock;
+	}
+
+	if (!(flags & IOPT_ALLOC_IOVA)) {
+		if ((iova & (iopt->iova_alignment - 1)) ||
+		    (length & (iopt->iova_alignment - 1)) || !length) {
+			rc = -EINVAL;
+			goto out_unlock;
+		}
+
+		/* No reserved IOVA intersects the range */
+		if (interval_tree_iter_first(&iopt->reserved_iova_itree, iova,
+					     area->node.last)) {
+			rc = -ENOENT;
+			goto out_unlock;
+		}
+
+		/* Check that there is not already a mapping in the range */
+		if (iopt_area_iter_first(iopt, iova, area->node.last)) {
+			rc = -EADDRINUSE;
+			goto out_unlock;
+		}
+	}
+
+	/*
+	 * The area is inserted with a NULL pages indicating it is not fully
+	 * initialized yet.
+	 */
+	area->node.start = iova;
+	interval_tree_insert(&area->node, &area->iopt->area_itree);
+	up_write(&iopt->iova_rwsem);
+	return area;
+
+out_unlock:
+	up_write(&iopt->iova_rwsem);
+	kfree(area);
+	return ERR_PTR(rc);
+}
+
+static void iopt_abort_area(struct iopt_area *area)
+{
+	down_write(&area->iopt->iova_rwsem);
+	interval_tree_remove(&area->node, &area->iopt->area_itree);
+	up_write(&area->iopt->iova_rwsem);
+	kfree(area);
+}
+
+static int iopt_finalize_area(struct iopt_area *area, struct iopt_pages *pages)
+{
+	int rc;
+
+	down_read(&area->iopt->domains_rwsem);
+	rc = iopt_area_fill_domains(area, pages);
+	if (!rc) {
+		/*
+		 * area->pages must be set inside the domains_rwsem to ensure
+		 * any newly added domains will get filled. Moves the reference
+		 * in from the caller
+		 */
+		down_write(&area->iopt->iova_rwsem);
+		area->pages = pages;
+		up_write(&area->iopt->iova_rwsem);
+	}
+	up_read(&area->iopt->domains_rwsem);
+	return rc;
+}
+
+int iopt_map_pages(struct io_pagetable *iopt, struct iopt_pages *pages,
+		   unsigned long *dst_iova, unsigned long start_bytes,
+		   unsigned long length, int iommu_prot, unsigned int flags)
+{
+	struct iopt_area *area;
+	int rc;
+
+	if ((iommu_prot & IOMMU_WRITE) && !pages->writable)
+		return -EPERM;
+
+	area = iopt_alloc_area(iopt, pages, *dst_iova, start_bytes, length,
+			       iommu_prot, flags);
+	if (IS_ERR(area))
+		return PTR_ERR(area);
+	*dst_iova = iopt_area_iova(area);
+
+	rc = iopt_finalize_area(area, pages);
+	if (rc) {
+		iopt_abort_area(area);
+		return rc;
+	}
+	return 0;
+}
+
+/**
+ * iopt_map_user_pages() - Map a user VA to an iova in the io page table
+ * @iopt: io_pagetable to act on
+ * @iova: If IOPT_ALLOC_IOVA is set this is unused on input and contains
+ *        the chosen iova on output. Otherwise is the iova to map to on input
+ * @uptr: User VA to map
+ * @length: Number of bytes to map
+ * @iommu_prot: Combination of IOMMU_READ/WRITE/etc bits for the mapping
+ * @flags: IOPT_ALLOC_IOVA or zero
+ *
+ * iova, uptr, and length must be aligned to iova_alignment. For domain backed
+ * page tables this will pin the pages and load them into the domain at iova.
+ * For non-domain page tables this will only setup a lazy reference and the
+ * caller must use iopt_access_pages() to touch them.
+ *
+ * iopt_unmap_iova() must be called to undo this before the io_pagetable can be
+ * destroyed.
+ */
+int iopt_map_user_pages(struct io_pagetable *iopt, unsigned long *iova,
+			void __user *uptr, unsigned long length, int iommu_prot,
+			unsigned int flags)
+{
+	struct iopt_pages *pages;
+	int rc;
+
+	pages = iopt_alloc_pages(uptr, length, iommu_prot & IOMMU_WRITE);
+	if (IS_ERR(pages))
+		return PTR_ERR(pages);
+
+	rc = iopt_map_pages(iopt, pages, iova, uptr - pages->uptr, length,
+			    iommu_prot, flags);
+	if (rc) {
+		iopt_put_pages(pages);
+		return rc;
+	}
+	return 0;
+}
+
+struct iopt_pages *iopt_get_pages(struct io_pagetable *iopt, unsigned long iova,
+				  unsigned long *start_byte,
+				  unsigned long length)
+{
+	unsigned long iova_end;
+	struct iopt_pages *pages;
+	struct iopt_area *area;
+
+	if (check_add_overflow(iova, length - 1, &iova_end))
+		return ERR_PTR(-EOVERFLOW);
+
+	down_read(&iopt->iova_rwsem);
+	area = iopt_find_exact_area(iopt, iova, iova_end);
+	if (!area) {
+		up_read(&iopt->iova_rwsem);
+		return ERR_PTR(-ENOENT);
+	}
+	pages = area->pages;
+	*start_byte = area->page_offset + iopt_area_index(area) * PAGE_SIZE;
+	kref_get(&pages->kref);
+	up_read(&iopt->iova_rwsem);
+
+	return pages;
+}
+
+static int __iopt_unmap_iova(struct io_pagetable *iopt, struct iopt_area *area,
+			     struct iopt_pages *pages)
+{
+	/* Drivers have to unpin on notification. */
+	if (WARN_ON(atomic_read(&area->num_users)))
+		return -EBUSY;
+
+	iopt_area_unfill_domains(area, pages);
+	WARN_ON(atomic_read(&area->num_users));
+	iopt_abort_area(area);
+	iopt_put_pages(pages);
+	return 0;
+}
+
+/**
+ * iopt_unmap_iova() - Remove a range of iova
+ * @iopt: io_pagetable to act on
+ * @iova: Starting iova to unmap
+ * @length: Number of bytes to unmap
+ *
+ * The requested range must exactly match an existing range.
+ * Splitting/truncating IOVA mappings is not allowed.
+ */
+int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
+		    unsigned long length)
+{
+	struct iopt_pages *pages;
+	struct iopt_area *area;
+	unsigned long iova_end;
+	int rc;
+
+	if (!length)
+		return -EINVAL;
+
+	if (check_add_overflow(iova, length - 1, &iova_end))
+		return -EOVERFLOW;
+
+	down_read(&iopt->domains_rwsem);
+	down_write(&iopt->iova_rwsem);
+	area = iopt_find_exact_area(iopt, iova, iova_end);
+	if (!area) {
+		up_write(&iopt->iova_rwsem);
+		up_read(&iopt->domains_rwsem);
+		return -ENOENT;
+	}
+	pages = area->pages;
+	area->pages = NULL;
+	up_write(&iopt->iova_rwsem);
+
+	rc = __iopt_unmap_iova(iopt, area, pages);
+	up_read(&iopt->domains_rwsem);
+	return rc;
+}
+
+int iopt_unmap_all(struct io_pagetable *iopt)
+{
+	struct iopt_area *area;
+	int rc;
+
+	down_read(&iopt->domains_rwsem);
+	down_write(&iopt->iova_rwsem);
+	while ((area = iopt_area_iter_first(iopt, 0, ULONG_MAX))) {
+		struct iopt_pages *pages;
+
+		/* Userspace should not race unmap all and map */
+		if (!area->pages) {
+			rc = -EBUSY;
+			goto out_unlock_iova;
+		}
+		pages = area->pages;
+		area->pages = NULL;
+		up_write(&iopt->iova_rwsem);
+
+		rc = __iopt_unmap_iova(iopt, area, pages);
+		if (rc)
+			goto out_unlock_domains;
+
+		down_write(&iopt->iova_rwsem);
+	}
+	rc = 0;
+
+out_unlock_iova:
+	up_write(&iopt->iova_rwsem);
+out_unlock_domains:
+	up_read(&iopt->domains_rwsem);
+	return rc;
+}
+
+/**
+ * iopt_access_pages() - Return a list of pages under the iova
+ * @iopt: io_pagetable to act on
+ * @iova: Starting IOVA
+ * @length: Number of bytes to access
+ * @out_pages: Output page list
+ * @write: True if access is for writing
+ *
+ * Reads @npages starting at iova and returns the struct page * pointers. These
+ * can be kmap'd by the caller for CPU access.
+ *
+ * The caller must perform iopt_unaccess_pages() when done to balance this.
+ *
+ * iova can be unaligned from PAGE_SIZE. The first returned byte starts at
+ * page_to_phys(out_pages[0]) + (iova % PAGE_SIZE). The caller promises not to
+ * touch memory outside the requested iova slice.
+ *
+ * FIXME: callers that need a DMA mapping via a sgl should create another
+ * interface to build the SGL efficiently
+ */
+int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
+		      unsigned long length, struct page **out_pages, bool write)
+{
+	unsigned long cur_iova = iova;
+	unsigned long last_iova;
+	struct iopt_area *area;
+	int rc;
+
+	if (!length)
+		return -EINVAL;
+	if (check_add_overflow(iova, length - 1, &last_iova))
+		return -EOVERFLOW;
+
+	down_read(&iopt->iova_rwsem);
+	for (area = iopt_area_iter_first(iopt, iova, last_iova); area;
+	     area = iopt_area_iter_next(area, iova, last_iova)) {
+		unsigned long last = min(last_iova, iopt_area_last_iova(area));
+		unsigned long last_index;
+		unsigned long index;
+
+		/* Need contiguous areas in the access */
+		if (iopt_area_iova(area) < cur_iova || !area->pages) {
+			rc = -EINVAL;
+			goto out_remove;
+		}
+
+		index = iopt_area_iova_to_index(area, cur_iova);
+		last_index = iopt_area_iova_to_index(area, last);
+		rc = iopt_pages_add_user(area->pages, index, last_index,
+					 out_pages, write);
+		if (rc)
+			goto out_remove;
+		if (last == last_iova)
+			break;
+		/*
+		 * Can't cross areas that are not aligned to the system page
+		 * size with this API.
+		 */
+		if (cur_iova % PAGE_SIZE) {
+			rc = -EINVAL;
+			goto out_remove;
+		}
+		cur_iova = last + 1;
+		out_pages += last_index - index;
+		atomic_inc(&area->num_users);
+	}
+
+	up_read(&iopt->iova_rwsem);
+	return 0;
+
+out_remove:
+	if (cur_iova != iova)
+		iopt_unaccess_pages(iopt, iova, cur_iova - iova);
+	up_read(&iopt->iova_rwsem);
+	return rc;
+}
+
+/**
+ * iopt_unaccess_pages() - Undo iopt_access_pages
+ * @iopt: io_pagetable to act on
+ * @iova: Starting IOVA
+ * @length:- Number of bytes to access
+ *
+ * Return the struct page's. The caller must stop accessing them before calling
+ * this. The iova/length must exactly match the one provided to access_pages.
+ */
+void iopt_unaccess_pages(struct io_pagetable *iopt, unsigned long iova,
+			 size_t length)
+{
+	unsigned long cur_iova = iova;
+	unsigned long last_iova;
+	struct iopt_area *area;
+
+	if (WARN_ON(!length) ||
+	    WARN_ON(check_add_overflow(iova, length - 1, &last_iova)))
+		return;
+
+	down_read(&iopt->iova_rwsem);
+	for (area = iopt_area_iter_first(iopt, iova, last_iova); area;
+	     area = iopt_area_iter_next(area, iova, last_iova)) {
+		unsigned long last = min(last_iova, iopt_area_last_iova(area));
+		int num_users;
+
+		iopt_pages_remove_user(area->pages,
+				       iopt_area_iova_to_index(area, cur_iova),
+				       iopt_area_iova_to_index(area, last));
+		if (last == last_iova)
+			break;
+		cur_iova = last + 1;
+		num_users = atomic_dec_return(&area->num_users);
+		WARN_ON(num_users < 0);
+	}
+	up_read(&iopt->iova_rwsem);
+}
+
+struct iopt_reserved_iova {
+	struct interval_tree_node node;
+	void *owner;
+};
+
+int iopt_reserve_iova(struct io_pagetable *iopt, unsigned long start,
+		      unsigned long last, void *owner)
+{
+	struct iopt_reserved_iova *reserved;
+
+	lockdep_assert_held_write(&iopt->iova_rwsem);
+
+	if (iopt_area_iter_first(iopt, start, last))
+		return -EADDRINUSE;
+
+	reserved = kzalloc(sizeof(*reserved), GFP_KERNEL);
+	if (!reserved)
+		return -ENOMEM;
+	reserved->node.start = start;
+	reserved->node.last = last;
+	reserved->owner = owner;
+	interval_tree_insert(&reserved->node, &iopt->reserved_iova_itree);
+	return 0;
+}
+
+void iopt_remove_reserved_iova(struct io_pagetable *iopt, void *owner)
+{
+
+	struct interval_tree_node *node;
+
+	for (node = interval_tree_iter_first(&iopt->reserved_iova_itree, 0,
+					     ULONG_MAX);
+	     node;) {
+		struct iopt_reserved_iova *reserved =
+			container_of(node, struct iopt_reserved_iova, node);
+
+		node = interval_tree_iter_next(node, 0, ULONG_MAX);
+
+		if (reserved->owner == owner) {
+			interval_tree_remove(&reserved->node,
+					     &iopt->reserved_iova_itree);
+			kfree(reserved);
+		}
+	}
+}
+
+int iopt_init_table(struct io_pagetable *iopt)
+{
+	init_rwsem(&iopt->iova_rwsem);
+	init_rwsem(&iopt->domains_rwsem);
+	iopt->area_itree = RB_ROOT_CACHED;
+	iopt->reserved_iova_itree = RB_ROOT_CACHED;
+	xa_init(&iopt->domains);
+
+	/*
+	 * iopt's start as SW tables that can use the entire size_t IOVA space
+	 * due to the use of size_t in the APIs. They have no alignment
+	 * restriction.
+	 */
+	iopt->iova_alignment = 1;
+
+	return 0;
+}
+
+void iopt_destroy_table(struct io_pagetable *iopt)
+{
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		iopt_remove_reserved_iova(iopt, NULL);
+	WARN_ON(!RB_EMPTY_ROOT(&iopt->reserved_iova_itree.rb_root));
+	WARN_ON(!xa_empty(&iopt->domains));
+	WARN_ON(!RB_EMPTY_ROOT(&iopt->area_itree.rb_root));
+}
+
+/**
+ * iopt_unfill_domain() - Unfill a domain with PFNs
+ * @iopt: io_pagetable to act on
+ * @domain: domain to unfill
+ *
+ * This is used when removing a domain from the iopt. Every area in the iopt
+ * will be unmapped from the domain. The domain must already be removed from the
+ * domains xarray.
+ */
+static void iopt_unfill_domain(struct io_pagetable *iopt,
+			       struct iommu_domain *domain)
+{
+	struct iopt_area *area;
+
+	lockdep_assert_held(&iopt->iova_rwsem);
+	lockdep_assert_held_write(&iopt->domains_rwsem);
+
+	/*
+	 * Some other domain is holding all the pfns still, rapidly unmap this
+	 * domain.
+	 */
+	if (iopt->next_domain_id != 0) {
+		/* Pick an arbitrary remaining domain to act as storage */
+		struct iommu_domain *storage_domain =
+			xa_load(&iopt->domains, 0);
+
+		for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
+		     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
+			struct iopt_pages *pages = area->pages;
+
+			if (WARN_ON(!pages))
+				continue;
+
+			mutex_lock(&pages->mutex);
+			if (area->storage_domain != domain) {
+				mutex_unlock(&pages->mutex);
+				continue;
+			}
+			area->storage_domain = storage_domain;
+			mutex_unlock(&pages->mutex);
+		}
+
+
+		iopt_unmap_domain(iopt, domain);
+		return;
+	}
+
+	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
+	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
+		struct iopt_pages *pages = area->pages;
+
+		if (WARN_ON(!pages))
+			continue;
+
+		mutex_lock(&pages->mutex);
+		interval_tree_remove(&area->pages_node,
+				     &area->pages->domains_itree);
+		WARN_ON(area->storage_domain != domain);
+		area->storage_domain = NULL;
+		iopt_area_unfill_domain(area, pages, domain);
+		mutex_unlock(&pages->mutex);
+	}
+}
+
+/**
+ * iopt_fill_domain() - Fill a domain with PFNs
+ * @iopt: io_pagetable to act on
+ * @domain: domain to fill
+ *
+ * Fill the domain with PFNs from every area in the iopt. On failure the domain
+ * is left unchanged.
+ */
+static int iopt_fill_domain(struct io_pagetable *iopt,
+			    struct iommu_domain *domain)
+{
+	struct iopt_area *end_area;
+	struct iopt_area *area;
+	int rc;
+
+	lockdep_assert_held(&iopt->iova_rwsem);
+	lockdep_assert_held_write(&iopt->domains_rwsem);
+
+	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
+	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
+		struct iopt_pages *pages = area->pages;
+
+		if (WARN_ON(!pages))
+			continue;
+
+		mutex_lock(&pages->mutex);
+		rc = iopt_area_fill_domain(area, domain);
+		if (rc) {
+			mutex_unlock(&pages->mutex);
+			goto out_unfill;
+		}
+		if (!area->storage_domain) {
+			WARN_ON(iopt->next_domain_id != 0);
+			area->storage_domain = domain;
+			interval_tree_insert(&area->pages_node,
+					     &pages->domains_itree);
+		}
+		mutex_unlock(&pages->mutex);
+	}
+	return 0;
+
+out_unfill:
+	end_area = area;
+	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
+	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
+		struct iopt_pages *pages = area->pages;
+
+		if (area == end_area)
+			break;
+		if (WARN_ON(!pages))
+			continue;
+		mutex_lock(&pages->mutex);
+		if (iopt->next_domain_id == 0) {
+			interval_tree_remove(&area->pages_node,
+					     &pages->domains_itree);
+			area->storage_domain = NULL;
+		}
+		iopt_area_unfill_domain(area, pages, domain);
+		mutex_unlock(&pages->mutex);
+	}
+	return rc;
+}
+
+/* All existing area's conform to an increased page size */
+static int iopt_check_iova_alignment(struct io_pagetable *iopt,
+				     unsigned long new_iova_alignment)
+{
+	struct iopt_area *area;
+
+	lockdep_assert_held(&iopt->iova_rwsem);
+
+	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
+	     area = iopt_area_iter_next(area, 0, ULONG_MAX))
+		if ((iopt_area_iova(area) % new_iova_alignment) ||
+		    (iopt_area_length(area) % new_iova_alignment))
+			return -EADDRINUSE;
+	return 0;
+}
+
+int iopt_table_add_domain(struct io_pagetable *iopt,
+			  struct iommu_domain *domain)
+{
+	const struct iommu_domain_geometry *geometry = &domain->geometry;
+	struct iommu_domain *iter_domain;
+	unsigned int new_iova_alignment;
+	unsigned long index;
+	int rc;
+
+	down_write(&iopt->domains_rwsem);
+	down_write(&iopt->iova_rwsem);
+
+	xa_for_each (&iopt->domains, index, iter_domain) {
+		if (WARN_ON(iter_domain == domain)) {
+			rc = -EEXIST;
+			goto out_unlock;
+		}
+	}
+
+	/*
+	 * The io page size drives the iova_alignment. Internally the iopt_pages
+	 * works in PAGE_SIZE units and we adjust when mapping sub-PAGE_SIZE
+	 * objects into the iommu_domain.
+	 *
+	 * A iommu_domain must always be able to accept PAGE_SIZE to be
+	 * compatible as we can't guarantee higher contiguity.
+	 */
+	new_iova_alignment =
+		max_t(unsigned long, 1UL << __ffs(domain->pgsize_bitmap),
+		      iopt->iova_alignment);
+	if (new_iova_alignment > PAGE_SIZE) {
+		rc = -EINVAL;
+		goto out_unlock;
+	}
+	if (new_iova_alignment != iopt->iova_alignment) {
+		rc = iopt_check_iova_alignment(iopt, new_iova_alignment);
+		if (rc)
+			goto out_unlock;
+	}
+
+	/* No area exists that is outside the allowed domain aperture */
+	if (geometry->aperture_start != 0) {
+		rc = iopt_reserve_iova(iopt, 0, geometry->aperture_start - 1,
+				       domain);
+		if (rc)
+			goto out_reserved;
+	}
+	if (geometry->aperture_end != ULONG_MAX) {
+		rc = iopt_reserve_iova(iopt, geometry->aperture_end + 1,
+				       ULONG_MAX, domain);
+		if (rc)
+			goto out_reserved;
+	}
+
+	rc = xa_reserve(&iopt->domains, iopt->next_domain_id, GFP_KERNEL);
+	if (rc)
+		goto out_reserved;
+
+	rc = iopt_fill_domain(iopt, domain);
+	if (rc)
+		goto out_release;
+
+	iopt->iova_alignment = new_iova_alignment;
+	xa_store(&iopt->domains, iopt->next_domain_id, domain, GFP_KERNEL);
+	iopt->next_domain_id++;
+	up_write(&iopt->iova_rwsem);
+	up_write(&iopt->domains_rwsem);
+	return 0;
+out_release:
+	xa_release(&iopt->domains, iopt->next_domain_id);
+out_reserved:
+	iopt_remove_reserved_iova(iopt, domain);
+out_unlock:
+	up_write(&iopt->iova_rwsem);
+	up_write(&iopt->domains_rwsem);
+	return rc;
+}
+
+void iopt_table_remove_domain(struct io_pagetable *iopt,
+			      struct iommu_domain *domain)
+{
+	struct iommu_domain *iter_domain = NULL;
+	unsigned long new_iova_alignment;
+	unsigned long index;
+
+	down_write(&iopt->domains_rwsem);
+	down_write(&iopt->iova_rwsem);
+
+	xa_for_each (&iopt->domains, index, iter_domain)
+		if (iter_domain == domain)
+			break;
+	if (WARN_ON(iter_domain != domain) || index >= iopt->next_domain_id)
+		goto out_unlock;
+
+	/*
+	 * Compress the xarray to keep it linear by swapping the entry to erase
+	 * with the tail entry and shrinking the tail.
+	 */
+	iopt->next_domain_id--;
+	iter_domain = xa_erase(&iopt->domains, iopt->next_domain_id);
+	if (index != iopt->next_domain_id)
+		xa_store(&iopt->domains, index, iter_domain, GFP_KERNEL);
+
+	iopt_unfill_domain(iopt, domain);
+	iopt_remove_reserved_iova(iopt, domain);
+
+	/* Recalculate the iova alignment without the domain */
+	new_iova_alignment = 1;
+	xa_for_each (&iopt->domains, index, iter_domain)
+		new_iova_alignment = max_t(unsigned long,
+					   1UL << __ffs(domain->pgsize_bitmap),
+					   new_iova_alignment);
+	if (!WARN_ON(new_iova_alignment > iopt->iova_alignment))
+		iopt->iova_alignment = new_iova_alignment;
+
+out_unlock:
+	up_write(&iopt->iova_rwsem);
+	up_write(&iopt->domains_rwsem);
+}
+
+/* Narrow the valid_iova_itree to include reserved ranges from a group. */
+int iopt_table_enforce_group_resv_regions(struct io_pagetable *iopt,
+					  struct iommu_group *group,
+					  phys_addr_t *sw_msi_start)
+{
+	struct iommu_resv_region *resv;
+	struct iommu_resv_region *tmp;
+	LIST_HEAD(group_resv_regions);
+	int rc;
+
+	down_write(&iopt->iova_rwsem);
+	rc = iommu_get_group_resv_regions(group, &group_resv_regions);
+	if (rc)
+		goto out_unlock;
+
+	list_for_each_entry (resv, &group_resv_regions, list) {
+		if (resv->type == IOMMU_RESV_DIRECT_RELAXABLE)
+			continue;
+
+		/*
+		 * The presence of any 'real' MSI regions should take precedence
+		 * over the software-managed one if the IOMMU driver happens to
+		 * advertise both types.
+		 */
+		if (sw_msi_start && resv->type == IOMMU_RESV_MSI) {
+			*sw_msi_start = 0;
+			sw_msi_start = NULL;
+		}
+		if (sw_msi_start && resv->type == IOMMU_RESV_SW_MSI)
+			*sw_msi_start = resv->start;
+
+		rc = iopt_reserve_iova(iopt, resv->start,
+				       resv->length - 1 + resv->start, group);
+		if (rc)
+			goto out_reserved;
+	}
+	rc = 0;
+	goto out_free_resv;
+
+out_reserved:
+	iopt_remove_reserved_iova(iopt, group);
+out_free_resv:
+	list_for_each_entry_safe (resv, tmp, &group_resv_regions, list)
+		kfree(resv);
+out_unlock:
+	up_write(&iopt->iova_rwsem);
+	return rc;
+}
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 2f1301d39bba7c..bcf08e61bc87e9 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -9,6 +9,9 @@
 #include <linux/refcount.h>
 #include <linux/uaccess.h>
 
+struct iommu_domain;
+struct iommu_group;
+
 /*
  * The IOVA to PFN map. The mapper automatically copies the PFNs into multiple
  * domains and permits sharing of PFNs between io_pagetable instances. This
@@ -27,8 +30,40 @@ struct io_pagetable {
 	struct rw_semaphore iova_rwsem;
 	struct rb_root_cached area_itree;
 	struct rb_root_cached reserved_iova_itree;
+	unsigned long iova_alignment;
 };
 
+int iopt_init_table(struct io_pagetable *iopt);
+void iopt_destroy_table(struct io_pagetable *iopt);
+struct iopt_pages *iopt_get_pages(struct io_pagetable *iopt, unsigned long iova,
+				  unsigned long *start_byte,
+				  unsigned long length);
+enum { IOPT_ALLOC_IOVA = 1 << 0 };
+int iopt_map_user_pages(struct io_pagetable *iopt, unsigned long *iova,
+			void __user *uptr, unsigned long length, int iommu_prot,
+			unsigned int flags);
+int iopt_map_pages(struct io_pagetable *iopt, struct iopt_pages *pages,
+		   unsigned long *dst_iova, unsigned long start_byte,
+		   unsigned long length, int iommu_prot, unsigned int flags);
+int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
+		    unsigned long length);
+int iopt_unmap_all(struct io_pagetable *iopt);
+
+int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
+		      unsigned long npages, struct page **out_pages, bool write);
+void iopt_unaccess_pages(struct io_pagetable *iopt, unsigned long iova,
+			 size_t npages);
+int iopt_table_add_domain(struct io_pagetable *iopt,
+			  struct iommu_domain *domain);
+void iopt_table_remove_domain(struct io_pagetable *iopt,
+			      struct iommu_domain *domain);
+int iopt_table_enforce_group_resv_regions(struct io_pagetable *iopt,
+					  struct iommu_group *group,
+					  phys_addr_t *sw_msi_start);
+int iopt_reserve_iova(struct io_pagetable *iopt, unsigned long start,
+		      unsigned long last, void *owner);
+void iopt_remove_reserved_iova(struct io_pagetable *iopt, void *owner);
+
 struct iommufd_ctx {
 	struct file *filp;
 	struct xarray objects;
-- 
2.35.1

