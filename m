Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8FC5AB919
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 22:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiIBT7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 15:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiIBT7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:59:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF0F25E86
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:59:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDQERX0FqGmL7XblRaDKO/xVVoowsysHrpweMa8AtrrWEiIyOMSMfoKc0jhqxcBM5cgBeSlJ5GeeRhOFLj8KH4jpg4reL36F1qcRfiEC/Er2UuuaFS/N2zPr/pW0I65Q5ivevnhfiAnC/GlwADFyXphhuD0SomppG25yf8P+WPwBLsbVuDy6ScAtergQf3oguY9uedbKyX/B9X4C8iuQw10YmW/i5uEpSa7AO3sM6WcEkAivwcdhhXvgyChYL+RYNlOOY0eEMaVmcvu9tQlwhbRt8c0wyFFfESaFxC+abFAAFvShfdlsIqvUjE2vek/t5IP+RD2VyFEH5fEiTvdhRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zlEZ9xDiN0NLuQX4qVrdmSDfmM2aDrq8j4z5PRwlSH0=;
 b=l1LrGVceFAqKF6KIWoWA8zg6kPJKdpWeoiq9sIneZy4iJeQFrnuZlw07y5LSfMgYXYyokKav1ZgM6kIoBvkPU16Y+6jSjQLx497LBrSq1e09FyzNrWwSTOch1XU8iA3KrIaDrgLlqbAbmv2O0mkbXvUTRc/99/VmlR5WHaPUy3aD5iMFnC5j9E0KP5gCxkDv/AvE/1lOb+diAUXtcv31fXVV9lbUpY9Lb0I9ARJGi5LYj8Yq/aZKglVaJoISJvG7RyroRKYJqT+S1UzLG/DOYFfMB1GcyTLrusVPchYur0qnVnpbpiRso2ZKRDwGr909Bzg2wRw6vfoXsL8twEc1+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zlEZ9xDiN0NLuQX4qVrdmSDfmM2aDrq8j4z5PRwlSH0=;
 b=TKXnoOiD1TZNIlJa0M7HMF0B+8HgnuXhpMu0nDhVqDL/jlY27Q8Roi7/FCjDvVszUogBqMojCTMOEIFQ7ArcojUWAR5sQ+IXcFIFyk+BszEzxjV9FUJlCuwICaD1JozY7vImdziOshJDIpxZYIYOP8wvFmLw8MvmIoFiPxoB2YO/kFAyLIM76Q1x8jXM9jqrvjeWH40P7y0MeoiA9aqx4PP9LzUUk5LKPXPN17hAo9hEwrfuHeUIQPiA5O2gH/wYdSzhA3qzxQnHoMzto6osl2mLmSXVpM7ypMrYFPoWzLq4zNNe6o0EHwldFvtUQDfT9BYrROhF43vRN1kUsmrWbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB6883.namprd12.prod.outlook.com (2603:10b6:510:1b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 19:59:35 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.016; Fri, 2 Sep 2022
 19:59:34 +0000
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
Subject: [PATCH RFC v2 07/13] iommufd: Data structure to provide IOVA to PFN mapping
Date:   Fri,  2 Sep 2022 16:59:23 -0300
Message-Id: <7-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:208:32a::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf2a4fee-cc29-4104-1023-08da8d1da674
X-MS-TrafficTypeDiagnostic: PH7PR12MB6883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A3bBwTmfcYG8d0sMkrsDMwDByxwDkwpcRsscuOnzG3YxTBJhR93jQvJY9a9V46mPH77AHuWublaJS8gGmu426waqyuEjPDvUZNOlnqQGgzRqttRYg7lVn8L7Y8qta904TMksdx7tOB5/YOGQQ3tlPAWOHIAK8tL4PgJq1BFUHS0qfYQO2e5NMTCBeL2HvXJJ/i6qyJrY6q1WR9eP3i0c8hwRQP1zInJWsP+2yBXDsDCDXVbt4FBiSbKhpQYcMto9M0ns1nKUZb8m1khdBPDk3V3TEdMsm/xat2i+uHUHHPpp+VfkE7FONssoZUxy2nZv1nRGISBswYtter8wghr54oANqe/BPr48JaaZnKRgdyBW1Y2DzFeXU5cxNI9f05c/w6N+MKqDaluz5Z4W9PZrLNk3IlhCgOvb+LGiiXKC6BkPRmv4iz/NthLlBR4KkLjZNwG6G4jMcPIpI7vJBRyEpKwDhI3cj/6+XxDBGlCXkl9PnVmDsuv/dO4DHU3hGWab+xhp17wRif4o4ml0LE3Prg6hvlZbC8v41nzcwlJI+ZwkXuYet23rw8OWFLyai9pjtscoOhwcZFgNY9fyxnAG6p8IbwIXb+NuLQb23v0vvoRNk3owM1M54QitHW+JmZWAsjcPiGduk7ehvXqhjw5PRWUlQIZ9YvbGXj7uGR9dsbCGdmCWTtu4L8cJy7IRZOAayQ0v3ZVDi8HiRvD6EEz3h5AoQ5PdQe7mLwpt1MuPUKh3lKlPcDken91kR4ntqKL2Lka9ep0tIY54QBzlCNPLcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(6666004)(4326008)(30864003)(66946007)(66476007)(66556008)(316002)(7416002)(54906003)(6506007)(26005)(478600001)(109986005)(6512007)(41300700001)(6486002)(38100700002)(86362001)(8676002)(186003)(2616005)(2906002)(5660300002)(8936002)(36756003)(83380400001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NmmXhN1rs+E7s9Jdx5L9kUUiJ8kDl2E/7XM+LgrWribKnp6tAy34B4f9gBrf?=
 =?us-ascii?Q?jX0/GI06rqD3Bmj3lxI1oCnNSne3z2iKmlQZIwe1LnoARzVwq6gmA789OToc?=
 =?us-ascii?Q?zBTt0iGSV3+W/9f61ivw8OG+evzj2xqcpnmjdDHdMjRynO8L9eRAUv59++r9?=
 =?us-ascii?Q?6slFFMt/2hnhUA2U713Mwi13ErK4ONXYIbxTIug59U5m2ZrnUzgySFZx5OIG?=
 =?us-ascii?Q?pIp6u+z/HLzwOd/EuzIpDygGk+t/nrl12B+dt3FMxvvXzWW2LU1/H7D9x3xB?=
 =?us-ascii?Q?pMYP96gNRUSTTcehgbF8U/NhIptFEZEqheH+7MyrpYQmH0mX2+k/F7VT8K3/?=
 =?us-ascii?Q?Ibz4fTUGH0NXeGd+d8RV1B838O6wNE2WdOF3W8DNLF2MGvv0vHrNvluZDoc6?=
 =?us-ascii?Q?vSa15wCk1T2lyqsg7P1VshpblB/DLYzd7pW/1gso4ls0wH/iDxlVs5dZxDMM?=
 =?us-ascii?Q?dF+PD5yAMJu5LHfYFeioRbXzJHb0DvUj7BkS7Bd3SFKw0OpqQTm6dnyjyJFQ?=
 =?us-ascii?Q?W/snjalPqnlJsj1auEWh1mwWVjYhimLlnjgOmLKNuQ4z6ueHx+Q6yegxFgXA?=
 =?us-ascii?Q?ScI2JrIzggLx5jPT3jX2ZnZHnmjKie/v3kyvIt0UqqwhR96FW6TL0Od+EL7G?=
 =?us-ascii?Q?7UTu+ljtjI//Y3gJQnJbOR4zwyWPj04v7jVGksSRKQ8vsEiN+SE2L0bUctEF?=
 =?us-ascii?Q?I7bfz8DfPAUQRgfv56ccENy2yahMM/uN32LqgiIuKppCvNGQl9DzlZ2taQC7?=
 =?us-ascii?Q?G8dp1LYXeeLzIo+b9qIVvMQehivgH4lGyk1yxyecPJqrmfANCSsYvKRPp2BR?=
 =?us-ascii?Q?oWi8jIgnLq00R1nmEEvMknC0uqpZUYJnOaYDPYanoP3CAw0QIMjdsATRA5o9?=
 =?us-ascii?Q?9OO7FzY5eM729W3bcPRO3M8oANJlVgwYetAY/W3++yhzG2QhQ7CxxwU7/qOt?=
 =?us-ascii?Q?U2Wps0GWpQgJvfhXo6W9/UihYilrdsumNPjePvhUzS899SN5fWmM5S/qKqMz?=
 =?us-ascii?Q?WW9yzYeiiidZYgdhdHg2RKz4Kl1Gkqzd+Ir/7WhU9s6BuhOWjwFwwxx7ucun?=
 =?us-ascii?Q?Y1dpqvx42Akj1S/FYHsFNct82/Fc1YOz3tKVTs/j2ozlNyoBdxiRfEqx8v5d?=
 =?us-ascii?Q?dxrHkN8ov1wNRhaVqyRn4hTLDHvrxLB14RUgk4bwSJ9nrHkOqQRYM/qb1u0q?=
 =?us-ascii?Q?FFikg1zEGAfIvxzgWk3keSnPyLDp7zGMATjXhSLjQdCQPdNJON3JLFuVLqAF?=
 =?us-ascii?Q?mplAs541sZaGmgXtDltqaNlJi2KHiarv8VoyrntcfPvlnLreo85UVthHIc2v?=
 =?us-ascii?Q?vA4ZnpfS2UDA9eFPRA91el2v6O1oIo6LcZYm0VkQdtWqjHj+jygwDk4xfvbS?=
 =?us-ascii?Q?TX9WpFPrYtShj06Wft8IgXQAwh+C7QD+eoMQhXczetqXQDCIoSYDciMkNhwJ?=
 =?us-ascii?Q?uqZkjbYkgeZKPspLxaya+d8lObHOC6XLMFn8DvQa4X/9zZ8Gw+uI2EV2VQP0?=
 =?us-ascii?Q?auiVEGR77nlmze5wF346gsPcvr664AKCGH9gc6Hwh0/SvU3QQh4J2tWRJmrr?=
 =?us-ascii?Q?wsKTAAo2jfl6d8ireUXsO/GstIj2p8J60hHiXcrT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf2a4fee-cc29-4104-1023-08da8d1da674
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 19:59:31.4882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mdOXfhT4U1fz/lw8fufecT6Ww1w0jEhFJ29O0oHq7eaFJxU+8HxmG6fK6eIxhLX7
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

This is the remainder of the IOAS data structure. Provide an object called
an io_pagetable that is composed of iopt_areas pointing at iopt_pages,
along with a list of iommu_domains that mirror the IOVA to PFN map.

At the top this is a simple interval tree of iopt_areas indicating the map
of IOVA to iopt_pages. An xarray keeps track of a list of domains. Based
on the attached domains there is a minimum alignment for areas (which may
be smaller than PAGE_SIZE), an interval tree of reserved IOVA that can't
be mapped and an IOVA of allowed IOVA that can always be mappable.

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
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |   1 +
 drivers/iommu/iommufd/io_pagetable.c    | 981 ++++++++++++++++++++++++
 drivers/iommu/iommufd/io_pagetable.h    |  12 +
 drivers/iommu/iommufd/iommufd_private.h |  33 +
 include/linux/iommufd.h                 |   8 +
 5 files changed, 1035 insertions(+)
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
index 00000000000000..7434bc8b393bbd
--- /dev/null
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -0,0 +1,981 @@
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
+#include <linux/iommufd.h>
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
+	return (iova - (iopt_area_iova(area) - area->page_offset)) / PAGE_SIZE;
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
+	span->start_hole = ALIGN(span->start_hole, iova_alignment) |
+			   page_offset;
+	if (span->start_hole > span->last_hole ||
+	    span->last_hole - span->start_hole < length - 1)
+		return false;
+	return true;
+}
+
+static bool __alloc_iova_check_used(struct interval_tree_span_iter *span,
+				    unsigned long length,
+				    unsigned long iova_alignment,
+				    unsigned long page_offset)
+{
+	if (span->is_hole || span->last_used - span->start_used < length - 1)
+		return false;
+
+	span->start_used = ALIGN(span->start_used, iova_alignment) |
+			   page_offset;
+	if (span->start_used > span->last_used ||
+	    span->last_used - span->start_used < length - 1)
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
+	struct interval_tree_span_iter allowed_span;
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
+
+	interval_tree_for_each_span(&allowed_span, &iopt->allowed_itree,
+				    PAGE_SIZE, ULONG_MAX - PAGE_SIZE) {
+		if (RB_EMPTY_ROOT(&iopt->allowed_itree.rb_root)) {
+			allowed_span.start_used = PAGE_SIZE;
+			allowed_span.last_used = ULONG_MAX - PAGE_SIZE;
+			allowed_span.is_hole = false;
+		}
+
+		if (!__alloc_iova_check_used(&allowed_span, length,
+					     iova_alignment, page_offset))
+			continue;
+
+		interval_tree_for_each_span(&area_span, &iopt->area_itree,
+					    allowed_span.start_used,
+					    allowed_span.last_used) {
+			if (!__alloc_iova_check_hole(&area_span, length,
+						     iova_alignment,
+						     page_offset))
+				continue;
+
+			interval_tree_for_each_span(&reserved_span,
+						    &iopt->reserved_itree,
+						    area_span.start_used,
+						    area_span.last_used) {
+				if (!__alloc_iova_check_hole(
+					    &reserved_span, length,
+					    iova_alignment, page_offset))
+					continue;
+
+				*iova = reserved_span.start_hole;
+				return 0;
+			}
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
+	area = kzalloc(sizeof(*area), GFP_KERNEL_ACCOUNT);
+	if (!area)
+		return ERR_PTR(-ENOMEM);
+
+	area->iopt = iopt;
+	area->iommu_prot = iommu_prot;
+	area->page_offset = start_byte % PAGE_SIZE;
+	area->pages_node.start = start_byte / PAGE_SIZE;
+	if (check_add_overflow(start_byte, length - 1,
+			       &area->pages_node.last)) {
+		rc = -EOVERFLOW;
+		goto out_free;
+	}
+	area->pages_node.last = area->pages_node.last / PAGE_SIZE;
+	if (WARN_ON(area->pages_node.last >= pages->npages)) {
+		rc = -EOVERFLOW;
+		goto out_free;
+	}
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
+		if (iopt_reserved_iter_first(iopt, iova, area->node.last)) {
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
+out_free:
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
+static int iopt_unmap_iova_range(struct io_pagetable *iopt, unsigned long start,
+				 unsigned long end, unsigned long *unmapped)
+{
+	struct iopt_area *area;
+	unsigned long unmapped_bytes = 0;
+	int rc = -ENOENT;
+
+	/*
+	 * The domains_rwsem must be held in read mode any time any area->pages
+	 * is NULL. This prevents domain attach/detatch from running
+	 * concurrently with cleaning up the area.
+	 */
+	down_read(&iopt->domains_rwsem);
+	down_write(&iopt->iova_rwsem);
+	while ((area = iopt_area_iter_first(iopt, start, end))) {
+		unsigned long area_last = iopt_area_last_iova(area);
+		unsigned long area_first = iopt_area_iova(area);
+		struct iopt_pages *pages;
+
+		/* Userspace should not race map/unmap's of the same area */
+		if (!area->pages) {
+			rc = -EBUSY;
+			goto out_unlock_iova;
+		}
+
+		if (area_first < start || area_last > end) {
+			rc = -ENOENT;
+			goto out_unlock_iova;
+		}
+
+		/*
+		 * num_users writers must hold the iova_rwsem too, so we can
+		 * safely read it under the write side of the iovam_rwsem
+		 * without the pages->mutex.
+		 */
+		if (area->num_users) {
+			start = area_first;
+			area->prevent_users = true;
+			up_write(&iopt->iova_rwsem);
+			up_read(&iopt->domains_rwsem);
+			/* Later patch calls back to drivers to unmap */
+			return -EBUSY;
+		}
+
+		pages = area->pages;
+		area->pages = NULL;
+		up_write(&iopt->iova_rwsem);
+
+		iopt_area_unfill_domains(area, pages);
+		iopt_abort_area(area);
+		iopt_put_pages(pages);
+
+		unmapped_bytes += area_last - area_first + 1;
+
+		down_write(&iopt->iova_rwsem);
+	}
+	if (unmapped_bytes)
+		rc = 0;
+
+out_unlock_iova:
+	up_write(&iopt->iova_rwsem);
+	up_read(&iopt->domains_rwsem);
+	if (unmapped)
+		*unmapped = unmapped_bytes;
+	return rc;
+}
+
+/**
+ * iopt_unmap_iova() - Remove a range of iova
+ * @iopt: io_pagetable to act on
+ * @iova: Starting iova to unmap
+ * @length: Number of bytes to unmap
+ * @unmapped: Return number of bytes unmapped
+ *
+ * The requested range must be a superset of existing ranges.
+ * Splitting/truncating IOVA mappings is not allowed.
+ */
+int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
+		    unsigned long length, unsigned long *unmapped)
+{
+	unsigned long iova_end;
+
+	if (!length)
+		return -EINVAL;
+
+	if (check_add_overflow(iova, length - 1, &iova_end))
+		return -EOVERFLOW;
+
+	return iopt_unmap_iova_range(iopt, iova, iova_end, unmapped);
+}
+
+int iopt_unmap_all(struct io_pagetable *iopt, unsigned long *unmapped)
+{
+	return iopt_unmap_iova_range(iopt, 0, ULONG_MAX, unmapped);
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
+ * Reads @length bytes starting at iova and returns the struct page * pointers.
+ * These can be kmap'd by the caller for CPU access.
+ *
+ * The caller must perform iopt_unaccess_pages() when done to balance this.
+ *
+ * iova can be unaligned from PAGE_SIZE. The first returned byte starts at
+ * page_to_phys(out_pages[0]) + (iova % PAGE_SIZE). The caller promises not to
+ * touch memory outside the requested iova slice.
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
+		if (iopt_area_iova(area) > cur_iova || !area->pages ||
+		    area->prevent_users) {
+			rc = -EINVAL;
+			goto out_remove;
+		}
+
+		index = iopt_area_iova_to_index(area, cur_iova);
+		last_index = iopt_area_iova_to_index(area, last);
+
+		/*
+		 * The API can only return aligned pages, so the starting point
+		 * must be at a page boundary.
+		 */
+		if ((cur_iova - (iopt_area_iova(area) - area->page_offset)) %
+		    PAGE_SIZE) {
+			rc = -EINVAL;
+			goto out_remove;
+		}
+
+		/*
+		 * and an interior ending point must be at a page boundary
+		 */
+		if (last != last_iova &&
+		    (iopt_area_last_iova(area) - cur_iova + 1) % PAGE_SIZE) {
+			rc = -EINVAL;
+			goto out_remove;
+		}
+
+		mutex_lock(&area->pages->mutex);
+		rc = iopt_pages_add_user(area->pages, index, last_index,
+					 out_pages, write);
+		if (rc) {
+			mutex_unlock(&area->pages->mutex);
+			goto out_remove;
+		}
+		area->num_users++;
+		mutex_unlock(&area->pages->mutex);
+		if (last == last_iova)
+			break;
+		cur_iova = last + 1;
+		out_pages += last_index - index;
+	}
+	if (cur_iova != last_iova)
+		goto out_remove;
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
+EXPORT_SYMBOL_GPL(iopt_access_pages);
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
+			 unsigned long length)
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
+
+		iopt_pages_remove_user(area,
+				       iopt_area_iova_to_index(area, cur_iova),
+				       iopt_area_iova_to_index(area, last));
+		if (last == last_iova)
+			break;
+		cur_iova = last + 1;
+	}
+	up_read(&iopt->iova_rwsem);
+}
+EXPORT_SYMBOL_GPL(iopt_unaccess_pages);
+
+/* The caller must always free all the nodes in the allowed_iova rb_root. */
+int iopt_set_allow_iova(struct io_pagetable *iopt,
+			struct rb_root_cached *allowed_iova)
+{
+	struct iopt_allowed *allowed;
+
+	down_write(&iopt->iova_rwsem);
+	swap(*allowed_iova, iopt->allowed_itree);
+
+	for (allowed = iopt_allowed_iter_first(iopt, 0, ULONG_MAX); allowed;
+	     allowed = iopt_allowed_iter_next(allowed, 0, ULONG_MAX)) {
+		if (iopt_reserved_iter_first(iopt, allowed->node.start,
+					     allowed->node.last)) {
+			swap(*allowed_iova, iopt->allowed_itree);
+			up_write(&iopt->iova_rwsem);
+			return -EADDRINUSE;
+		}
+	}
+	up_write(&iopt->iova_rwsem);
+	return 0;
+}
+
+int iopt_reserve_iova(struct io_pagetable *iopt, unsigned long start,
+		      unsigned long last, void *owner)
+{
+	struct iopt_reserved *reserved;
+
+	lockdep_assert_held_write(&iopt->iova_rwsem);
+
+	if (iopt_area_iter_first(iopt, start, last) ||
+	    iopt_allowed_iter_first(iopt, start, last))
+		return -EADDRINUSE;
+
+	reserved = kzalloc(sizeof(*reserved), GFP_KERNEL_ACCOUNT);
+	if (!reserved)
+		return -ENOMEM;
+	reserved->node.start = start;
+	reserved->node.last = last;
+	reserved->owner = owner;
+	interval_tree_insert(&reserved->node, &iopt->reserved_itree);
+	return 0;
+}
+
+static void __iopt_remove_reserved_iova(struct io_pagetable *iopt, void *owner)
+{
+	struct iopt_reserved *reserved, *next;
+
+	lockdep_assert_held_write(&iopt->iova_rwsem);
+
+	for (reserved = iopt_reserved_iter_first(iopt, 0, ULONG_MAX);
+	     reserved; reserved = next) {
+		next = iopt_reserved_iter_next(reserved, 0, ULONG_MAX);
+
+		if (reserved->owner == owner) {
+			interval_tree_remove(&reserved->node,
+					     &iopt->reserved_itree);
+			kfree(reserved);
+		}
+	}
+}
+
+void iopt_remove_reserved_iova(struct io_pagetable *iopt, void *owner)
+{
+	down_write(&iopt->iova_rwsem);
+	__iopt_remove_reserved_iova(iopt, owner);
+	up_write(&iopt->iova_rwsem);
+}
+
+int iopt_init_table(struct io_pagetable *iopt)
+{
+	init_rwsem(&iopt->iova_rwsem);
+	init_rwsem(&iopt->domains_rwsem);
+	iopt->area_itree = RB_ROOT_CACHED;
+	iopt->allowed_itree = RB_ROOT_CACHED;
+	iopt->reserved_itree = RB_ROOT_CACHED;
+	xa_init_flags(&iopt->domains, XA_FLAGS_ACCOUNT);
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
+	struct interval_tree_node *node;
+
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		iopt_remove_reserved_iova(iopt, NULL);
+
+	while ((node = interval_tree_iter_first(&iopt->allowed_itree, 0,
+						ULONG_MAX))) {
+		interval_tree_remove(node, &iopt->allowed_itree);
+		kfree(container_of(node, struct iopt_allowed, node));
+	}
+
+	WARN_ON(!RB_EMPTY_ROOT(&iopt->reserved_itree.rb_root));
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
+			if (!pages)
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
+		if (!pages)
+			continue;
+
+		mutex_lock(&pages->mutex);
+		interval_tree_remove(&area->pages_node,
+				     &pages->domains_itree);
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
+		if (!pages)
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
+		if (!pages)
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
+	__iopt_remove_reserved_iova(iopt, domain);
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
+	__iopt_remove_reserved_iova(iopt, domain);
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
+	__iopt_remove_reserved_iova(iopt, group);
+out_free_resv:
+	list_for_each_entry_safe (resv, tmp, &group_resv_regions, list)
+		kfree(resv);
+out_unlock:
+	up_write(&iopt->iova_rwsem);
+	return rc;
+}
diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index fe3be8dd38240e..7fe5a700239012 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -46,9 +46,19 @@ struct iopt_area {
 	unsigned int page_offset;
 	/* IOMMU_READ, IOMMU_WRITE, etc */
 	int iommu_prot;
+	bool prevent_users : 1;
 	unsigned int num_users;
 };
 
+struct iopt_allowed {
+	struct interval_tree_node node;
+};
+
+struct iopt_reserved {
+	struct interval_tree_node node;
+	void *owner;
+};
+
 int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages);
 void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages);
 
@@ -109,6 +119,8 @@ static inline size_t iopt_area_length(struct iopt_area *area)
 	}
 
 __make_iopt_iter(area)
+__make_iopt_iter(allowed)
+__make_iopt_iter(reserved)
 
 /*
  * This holds a pinned page list for multiple areas of IO address space. The
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 47a824897bc222..560ab06fbc3366 100644
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
@@ -30,8 +33,38 @@ struct io_pagetable {
 	struct rb_root_cached allowed_itree;
 	/* IOVA that cannot be allocated, struct iopt_reserved */
 	struct rb_root_cached reserved_itree;
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
+		    unsigned long length, unsigned long *unmapped);
+int iopt_unmap_all(struct io_pagetable *iopt, unsigned long *unmapped);
+
+int iopt_table_add_domain(struct io_pagetable *iopt,
+			  struct iommu_domain *domain);
+void iopt_table_remove_domain(struct io_pagetable *iopt,
+			      struct iommu_domain *domain);
+int iopt_table_enforce_group_resv_regions(struct io_pagetable *iopt,
+					  struct iommu_group *group,
+					  phys_addr_t *sw_msi_start);
+int iopt_set_allow_iova(struct io_pagetable *iopt,
+			struct rb_root_cached *allowed_iova);
+int iopt_reserve_iova(struct io_pagetable *iopt, unsigned long start,
+		      unsigned long last, void *owner);
+void iopt_remove_reserved_iova(struct io_pagetable *iopt, void *owner);
+
 struct iommufd_ctx {
 	struct file *file;
 	struct xarray objects;
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index c8bbed542e923c..9c6ec4d66b4a92 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -10,9 +10,17 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 
+struct page;
 struct iommufd_ctx;
+struct io_pagetable;
 struct file;
 
+int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
+		      unsigned long length, struct page **out_pages,
+		      bool write);
+void iopt_unaccess_pages(struct io_pagetable *iopt, unsigned long iova,
+			 unsigned long length);
+
 void iommufd_ctx_get(struct iommufd_ctx *ictx);
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
-- 
2.37.3

