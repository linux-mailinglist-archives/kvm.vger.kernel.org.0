Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8404DDFEB
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239633AbiCRR3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239629AbiCRR3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:29:08 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E7F1D763C
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:27:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AB7h/6bb0mNZE440XOJWhCSuyKzQBdi8PZPmibs1b+3BQ7BCCpFy82gOM+3u+6Nn4DXzfEfa9Q9YrffPCS+oAsXwZXomsiLZi3V1RDnFgF5lhy9VsWAC19BGfc7APclB1qsPk0unNDw0O0XcoaC6z8LMdxGELBtfgLZBe8wpZWcxgSpqU3GwPKEdCepousDtJAR421/31cECPwTN9lbvmLgu7xZKgiYKUfzTJWdDnzP9hKlaHfxgliBintQvOcyicvPytSSZGye39VxjqR7TaXuwnqhV/XE5BuCmIA52YGwjeGOKlqGGrgV3MkAaf05FvpZ+YPffeM2Vd/QPrN9upg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M6c2qZhXtjYPkbxz5Q3ZORnWiUXQNTRTlwsNAzW1bLM=;
 b=YmISfO49MvYWpeO44h4xNvj949+rA0LvpzZNAPQFQydAD2pSZxlo6xh0p8On92LLUizTfoBRrc8TSsG+/KXu8HzlcVLbyO+WRIU4zC3S5ZKqhHE7HkpTPPqPXkgU3Ypt70gpl2Bg7xGAEPHAGYx6ExbtLlqQxzl1fWDP2rtFwHrF4qwATt6xDmeSFrspZ80Wo2011ai5EwhshX/4bVNNCJA2dUCXniSwoeQLFu8gqZPOkX8jMPDD72dJ36mKtGcybGWu0IwrojpitmAHusRSa9hJ2u9+H/imKyCouQz4skrksV7uH9b7dZCsVo+zEvONUWijwIWX7c4p0l4AzNotHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M6c2qZhXtjYPkbxz5Q3ZORnWiUXQNTRTlwsNAzW1bLM=;
 b=GbsGyL6DdhQzrbpJDVpDUkdMQX1Mn68uox4QP9f0ug4D4MY0yY5GABGQ5nYD5PWNzK3Rw60oU1A4lpJmHAZM5Gs7koLnp1jbZYpseg/2+fck1bMxeeLA68NNIrcO09GYhRuBPfRCGQCpTd5d5c8QdeHddRgJ0JAp87AfCeu92ZrOUOv1dcsgwhTVuOtS5xeVbBbzh1Qd2lzaRvsPj949i5Cz4GZ8vYZ22SwGgKQanEyJzdA2iJizszYgXKvTlk9KirDCW8/8OhpruSZkNyOIeAwunJF9aT6/e85msss3+JCLWz/uccCfYzvb8UXMbmbhzRuSXMTHOwwgdNBI3TfkQg==
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
Subject: [PATCH RFC 05/12] iommufd: PFN handling for iopt_pages
Date:   Fri, 18 Mar 2022 14:27:30 -0300
Message-Id: <5-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0064.namprd19.prod.outlook.com
 (2603:10b6:208:19b::41) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5751c02b-88b6-4bc5-2f87-08da090499df
X-MS-TrafficTypeDiagnostic: MN2PR12MB3951:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB39511128DDBBBAFCAFDEB9E8C2139@MN2PR12MB3951.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lKHSWsVV4d291y5e95UXRFgJ9QYjHaOZFXu6WQL/1rIr97fK1jCphV4ZRHh12Ft5Yq8KAlR51rIMeL9UtS2K9RPpIjgcbx0LVZrFEX6Uulfke2TbDOIvOY1InPD1o7RwvAwskGP1HYgZSySYbziAruxJQmQNX4uGav1qe3uHjZQYP28fJx6pblGgZyi2jBzDbJwama1YnIYwqdjpQatYaWdAhKhRhRXBHPl8Y2AMWuhY2aiKnO7Rh4n97UfXvd/GxnEbfDNoRJtF1Nh4LvLVsxHfD6Pl/h0L1xjqE29kqAb1zIbVlCu2Hg9zfyEPOldgfTkIgVTvo65qfniUPzujPaQiamK9bdyF/OQiIRlRfyLdJUipXPDfQ8uPlWimAxaNzeyParMSYrAekd+0/X+ouLDw+nDYzO+wNlZG0hgmHpw7CXp5PsMtwDL4VXSg+d0vmaVeJkz9JINsSus6YWBPptynml7fEIihR7js6w/d96coQ5vJwZouJ5aFl8RX9Agl6zkS4k+/0Iye0izR8SSpirucBMHrFdpBhwTZKtGNkucaJTSdVK8MMHLBCMLNF8h9yRAuX7xAgk0P5vl3TIuIDDBIyjhKCaqDyqXguyquEqDZn1NrG3O9RN8u+cdVEM2PpLb/ZT8i+laWfBGLm3wvPqaODKemsoaw68PXkmDBg8nubqh9QvOt71B3jxIL6r5u0J3ItrNUpUFmYPr86DEnHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(83380400001)(7416002)(4326008)(2906002)(86362001)(508600001)(8676002)(6512007)(6506007)(6666004)(5660300002)(8936002)(109986005)(66946007)(26005)(66476007)(186003)(316002)(66556008)(2616005)(36756003)(38100700002)(6486002)(54906003)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GNvNQLs5xbt1BD9/KA88wpSqqW7ex2yqkRRTLZ1cO+i0h0nIKkh8se5iSIcA?=
 =?us-ascii?Q?N/bUGRFzZ5tjqvINGpKmiUvQeuQsT0u27OJXSFf6F+ESTUwYuUFmNmcehtfq?=
 =?us-ascii?Q?th3lE6HvQ5xheHZrW15QPtZhi/MxvuSrA8gPOYEoboTBKvp4oEmbD4hHvJuB?=
 =?us-ascii?Q?UFZmQuyu9oZXfyr+6cZPy3UV466CSpUtuZbzAhMKiAagCOUdwwksEUoPF5GI?=
 =?us-ascii?Q?jCdPk48fqrJeknGpZcYosL4zJlGt4Ihp/RL+B20AS8/AgK7dgiBLp97hqU7i?=
 =?us-ascii?Q?CLYQwWf+oi1e7Wo4wb7kwawEIkMctBGN5LSNXjMv/NZVxiZTgQ7vuJABY0Qm?=
 =?us-ascii?Q?o/hv7tPSEPbPZyoQDvE7MQmk+JfXZgs98miocFaCfFUV6MM5K2YsVjvfqTST?=
 =?us-ascii?Q?muiDleMDebye96i/nMGwQpZm3W321WytyAJBznwXUVBra5c5hOY5v9eOpYAP?=
 =?us-ascii?Q?6O4ni9XVEfbJF6wSo+viQjHa5KKRwI19wIgKG6nVmZdmKzRY3JKfY3d+wsue?=
 =?us-ascii?Q?YAQifopMI016Fn8cBBxIYlca6dRF5NGsr9J9OENSl/vHseogiaxI+sej5yqd?=
 =?us-ascii?Q?M/KR6QUBVVBovoSFzt6v+K3/NKbEqlZGrm/evsnM/8UksVhhrj0sr76wtElR?=
 =?us-ascii?Q?MXDUBgPrRbuVkn4OsGLGkhMZ6ZQpkz14zOQAMd33+evtvtZmX1SjePDXDDwn?=
 =?us-ascii?Q?ioAAPyceNgPsGTz6NjSfGnsWBig+OwV6VF++P5JWejk6Sz+nLea30HxnVajT?=
 =?us-ascii?Q?tZEhLlAGLQYXkFhp11RkZk49EMkMSdp5U/P0Oq5zBBepmS4+zmbayZljf9DA?=
 =?us-ascii?Q?mUhOu8dNj7UAjejDpGP0b4Ra1BWy3VBLCO8X64xnrG232VKYJCrtxQYsxOy1?=
 =?us-ascii?Q?9TmCKWJPIq1gtVdEU9RRORx/8usYEyQWKXfQWiKr2ela7aUHOuFcC0OxPIHL?=
 =?us-ascii?Q?fU80NglV/49ahQTkAwo3HE935pi60fnY4K9AuPGvvVcZt5fbLQfhHWIcimQ8?=
 =?us-ascii?Q?UujjZ/6KKvHhQUwrgJPcNuOdqthdOx4jzMw5OT5zNq2I62AhebZ4v6LlDvS0?=
 =?us-ascii?Q?vaDI/LyN3KP1h7sgy+vRiBjmRWDePStzuKMODB2Eiot5jfnctj3Wnw+AaxQn?=
 =?us-ascii?Q?3oCLITruKrqgJUuGXhF2PuErpFeyiJDbidfipnuuzDbjW4dFdogUYMbnVaUI?=
 =?us-ascii?Q?j3P/kFAZvfrS5uIsN9jzmIGGTxdmzQLYphaT9Kbg+fnxONCRnXU/bbFNtWZ2?=
 =?us-ascii?Q?A/kwM5PZOh9bKA5oXpDKpa7WhnXA9eccL0djqLrOb+Z7qtnaZYxitdcMqOEm?=
 =?us-ascii?Q?k7hErZhFU6dytCa3vnRPoS9lmAuGEtBco0XUEm9Ak0UM60dacbOyH/wbcHmM?=
 =?us-ascii?Q?9oNtN8N2pBvfcU5QycOvDtTjvpfj5fVa23bSrD5pXiatbmBd1y6uSj/fWucW?=
 =?us-ascii?Q?sJZmmK/uAS5HRgVVsSGLYzAJ9E9GM1Ws?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5751c02b-88b6-4bc5-2f87-08da090499df
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:27:39.4605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +9wQtHrc/CQkLf/e0/4VDIVvKvLaZaxQHT/D/AbOW7hhj/QlTiyWGGA3Mt97D3aT
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

The top of the data structure provides an IO Address Space (IOAS) that is
similar to a VFIO container. The IOAS allows map/unmap of memory into
ranges of IOVA called iopt_areas. Domains and in-kernel users (like VFIO
mdevs) can be attached to the IOAS to access the PFNs that those IOVA
areas cover.

The IO Address Space (IOAS) datastructure is composed of:
 - struct io_pagetable holding the IOVA map
 - struct iopt_areas representing populated portions of IOVA
 - struct iopt_pages representing the storage of PFNs
 - struct iommu_domain representing the IO page table in the system IOMMU
 - struct iopt_pages_user representing in-kernel users of PFNs (ie VFIO
   mdevs)
 - struct xarray pinned_pfns holding a list of pages pinned by in-kernel
   users

This patch introduces the lowest part of the datastructure - the movement
of PFNs in a tiered storage scheme:
 1) iopt_pages::pinned_pfns xarray
 2) An iommu_domain
 3) The origin of the PFNs, i.e. the userspace pointer

PFN have to be copied between all combinations of tiers, depending on the
configuration.

The interface is an iterator called a 'pfn_reader' which determines which
tier each PFN is stored and loads it into a list of PFNs held in a struct
pfn_batch.

Each step of the iterator will fill up the pfn_batch, then the caller can
use the pfn_batch to send the PFNs to the required destination. Repeating
this loop will read all the PFNs in an IOVA range.

The pfn_reader and pfn_batch also keep track of the pinned page accounting.

While PFNs are always stored and accessed as full PAGE_SIZE units the
iommu_domain tier can store with a sub-page offset/length to support
IOMMUs with a smaller IOPTE size than PAGE_SIZE.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |   3 +-
 drivers/iommu/iommufd/io_pagetable.h    | 101 ++++
 drivers/iommu/iommufd/iommufd_private.h |  20 +
 drivers/iommu/iommufd/pages.c           | 723 ++++++++++++++++++++++++
 4 files changed, 846 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/iommufd/io_pagetable.h
 create mode 100644 drivers/iommu/iommufd/pages.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index a07a8cffe937c6..05a0e91e30afad 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 iommufd-y := \
-	main.o
+	main.o \
+	pages.o
 
 obj-$(CONFIG_IOMMUFD) += iommufd.o
diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
new file mode 100644
index 00000000000000..94ca8712722d31
--- /dev/null
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -0,0 +1,101 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES.
+ *
+ */
+#ifndef __IO_PAGETABLE_H
+#define __IO_PAGETABLE_H
+
+#include <linux/interval_tree.h>
+#include <linux/mutex.h>
+#include <linux/kref.h>
+#include <linux/xarray.h>
+
+#include "iommufd_private.h"
+
+struct iommu_domain;
+
+/*
+ * Each io_pagetable is composed of intervals of areas which cover regions of
+ * the iova that are backed by something. iova not covered by areas is not
+ * populated in the page table. Each area is fully populated with pages.
+ *
+ * iovas are in byte units, but must be iopt->iova_alignment aligned.
+ *
+ * pages can be NULL, this means some other thread is still working on setting
+ * up the area. When observed under the write side of the domain_rwsem a NULL
+ * pages must mean no domains are filled.
+ *
+ * storage_domain points at an arbitrary iommu_domain that is holding the PFNs
+ * for this area. It is locked by the pages->mutex. This simplifies the locking
+ * as the pages code can rely on the storage_domain without having to get the
+ * iopt->domains_rwsem.
+ *
+ * The io_pagetable::iova_rwsem protects node
+ * The iopt_pages::mutex protects pages_node
+ * iopt and immu_prot are immutable
+ */
+struct iopt_area {
+	struct interval_tree_node node;
+	struct interval_tree_node pages_node;
+	/* How many bytes into the first page the area starts */
+	unsigned int page_offset;
+	struct io_pagetable *iopt;
+	struct iopt_pages *pages;
+	struct iommu_domain *storage_domain;
+	/* IOMMU_READ, IOMMU_WRITE, etc */
+	int iommu_prot;
+	atomic_t num_users;
+};
+
+static inline unsigned long iopt_area_index(struct iopt_area *area)
+{
+	return area->pages_node.start;
+}
+
+static inline unsigned long iopt_area_last_index(struct iopt_area *area)
+{
+	return area->pages_node.last;
+}
+
+static inline unsigned long iopt_area_iova(struct iopt_area *area)
+{
+	return area->node.start;
+}
+
+static inline unsigned long iopt_area_last_iova(struct iopt_area *area)
+{
+	return area->node.last;
+}
+
+/*
+ * This holds a pinned page list for multiple areas of IO address space. The
+ * pages always originate from a linear chunk of userspace VA. Multiple
+ * io_pagetable's, through their iopt_area's, can share a single iopt_pages
+ * which avoids multi-pinning and double accounting of page consumption.
+ *
+ * indexes in this structure are measured in PAGE_SIZE units, are 0 based from
+ * the start of the uptr and extend to npages. pages are pinned dynamically
+ * according to the intervals in the users_itree and domains_itree, npages
+ * records the current number of pages pinned.
+ */
+struct iopt_pages {
+	struct kref kref;
+	struct mutex mutex;
+	size_t npages;
+	size_t npinned;
+	size_t last_npinned;
+	struct task_struct *source_task;
+	struct mm_struct *source_mm;
+	struct user_struct *source_user;
+	void __user *uptr;
+	bool writable:1;
+	bool has_cap_ipc_lock:1;
+
+	struct xarray pinned_pfns;
+	/* Of iopt_pages_user::node */
+	struct rb_root_cached users_itree;
+	/* Of iopt_area::pages_node */
+	struct rb_root_cached domains_itree;
+};
+
+#endif
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 2d0bba3965be1a..2f1301d39bba7c 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -9,6 +9,26 @@
 #include <linux/refcount.h>
 #include <linux/uaccess.h>
 
+/*
+ * The IOVA to PFN map. The mapper automatically copies the PFNs into multiple
+ * domains and permits sharing of PFNs between io_pagetable instances. This
+ * supports both a design where IOAS's are 1:1 with a domain (eg because the
+ * domain is HW customized), or where the IOAS is 1:N with multiple generic
+ * domains.  The io_pagetable holds an interval tree of iopt_areas which point
+ * to shared iopt_pages which hold the pfns mapped to the page table.
+ *
+ * The locking order is domains_rwsem -> iova_rwsem -> pages::mutex
+ */
+struct io_pagetable {
+	struct rw_semaphore domains_rwsem;
+	struct xarray domains;
+	unsigned int next_domain_id;
+
+	struct rw_semaphore iova_rwsem;
+	struct rb_root_cached area_itree;
+	struct rb_root_cached reserved_iova_itree;
+};
+
 struct iommufd_ctx {
 	struct file *filp;
 	struct xarray objects;
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
new file mode 100644
index 00000000000000..a75e1c73527920
--- /dev/null
+++ b/drivers/iommu/iommufd/pages.c
@@ -0,0 +1,723 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES.
+ *
+ * The iopt_pages is the center of the storage and motion of PFNs. Each
+ * iopt_pages represents a logical linear array of full PFNs. The array is 0
+ * based and has npages in it. Accessors use 'index' to refer to the entry in
+ * this logical array, regardless of its storage location.
+ *
+ * PFNs are stored in a tiered scheme:
+ *  1) iopt_pages::pinned_pfns xarray
+ *  2) An iommu_domain
+ *  3) The origin of the PFNs, i.e. the userspace pointer
+ *
+ * PFN have to be copied between all combinations of tiers, depending on the
+ * configuration.
+ *
+ * When a PFN is taken out of the userspace pointer it is pinned exactly once.
+ * The storage locations of the PFN's index are tracked in the two interval
+ * trees. If no interval includes the index then it is not pinned.
+ *
+ * If users_itree includes the PFN's index then an in-kernel user has requested
+ * the page. The PFN is stored in the xarray so other requestors can continue to
+ * find it.
+ *
+ * If the domains_itree includes the PFN's index then an iommu_domain is storing
+ * the PFN and it can be read back using iommu_iova_to_phys(). To avoid
+ * duplicating storage the xarray is not used if only iommu_domains are using
+ * the PFN's index.
+ *
+ * As a general principle this is designed so that destroy never fails. This
+ * means removing an iommu_domain or releasing a in-kernel user will not fail
+ * due to insufficient memory. In practice this means some cases have to hold
+ * PFNs in the xarray even though they are also being stored in an iommu_domain.
+ *
+ * While the iopt_pages can use an iommu_domain as storage, it does not have an
+ * IOVA itself. Instead the iopt_area represents a range of IOVA and uses the
+ * iopt_pages as the PFN provider. Multiple iopt_areas can share the iopt_pages
+ * and reference their own slice of the PFN array, with sub page granularity.
+ *
+ * In this file the term 'last' indicates an inclusive and closed interval, eg
+ * [0,0] refers to a single PFN. 'end' means an open range, eg [0,0) refers to
+ * no PFNs.
+ */
+#include <linux/overflow.h>
+#include <linux/slab.h>
+#include <linux/iommu.h>
+#include <linux/sched/mm.h>
+
+#include "io_pagetable.h"
+
+#define TEMP_MEMORY_LIMIT 65536
+#define BATCH_BACKUP_SIZE 32
+
+/*
+ * More memory makes pin_user_pages() and the batching more efficient, but as
+ * this is only a performance optimization don't try too hard to get it. A 64k
+ * allocation can hold about 26M of 4k pages and 13G of 2M pages in an
+ * pfn_batch. Various destroy paths cannot fail and provide a small amount of
+ * stack memory as a backup contingency. If backup_len is given this cannot
+ * fail.
+ */
+static void *temp_kmalloc(size_t *size, void *backup, size_t backup_len)
+{
+	void *res;
+
+	if (*size < backup_len)
+		return backup;
+	*size = min_t(size_t, *size, TEMP_MEMORY_LIMIT);
+	res = kmalloc(*size, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
+	if (res)
+		return res;
+	*size = PAGE_SIZE;
+	if (backup_len) {
+		res = kmalloc(*size, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
+		if (res)
+			return res;
+		*size = backup_len;
+		return backup;
+	}
+	return kmalloc(*size, GFP_KERNEL);
+}
+
+static void iopt_pages_add_npinned(struct iopt_pages *pages, size_t npages)
+{
+	int rc;
+
+	rc = check_add_overflow(pages->npinned, npages, &pages->npinned);
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(rc || pages->npinned > pages->npages);
+}
+
+static void iopt_pages_sub_npinned(struct iopt_pages *pages, size_t npages)
+{
+	int rc;
+
+	rc = check_sub_overflow(pages->npinned, npages, &pages->npinned);
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(rc || pages->npinned > pages->npages);
+}
+
+/*
+ * index is the number of PAGE_SIZE units from the start of the area's
+ * iopt_pages. If the iova is sub page-size then the area has an iova that
+ * covers a portion of the first and last pages in the range.
+ */
+static unsigned long iopt_area_index_to_iova(struct iopt_area *area,
+					     unsigned long index)
+{
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(index < iopt_area_index(area) ||
+			index > iopt_area_last_index(area));
+	index -= iopt_area_index(area);
+	if (index == 0)
+		return iopt_area_iova(area);
+	return iopt_area_iova(area) - area->page_offset + index * PAGE_SIZE;
+}
+
+static unsigned long iopt_area_index_to_iova_last(struct iopt_area *area,
+						  unsigned long index)
+{
+	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+		WARN_ON(index < iopt_area_index(area) ||
+			index > iopt_area_last_index(area));
+	if (index == iopt_area_last_index(area))
+		return iopt_area_last_iova(area);
+	return iopt_area_iova(area) - area->page_offset +
+	       (index - iopt_area_index(area) + 1) * PAGE_SIZE - 1;
+}
+
+static void iommu_unmap_nofail(struct iommu_domain *domain, unsigned long iova,
+			       size_t size)
+{
+	size_t ret;
+
+	ret = iommu_unmap(domain, iova, size);
+	/*
+	 * It is a logic error in this code or a driver bug if the IOMMU unmaps
+	 * something other than exactly as requested.
+	 */
+	WARN_ON(ret != size);
+}
+
+static struct iopt_area *iopt_pages_find_domain_area(struct iopt_pages *pages,
+						     unsigned long index)
+{
+	struct interval_tree_node *node;
+
+	node = interval_tree_iter_first(&pages->domains_itree, index, index);
+	if (!node)
+		return NULL;
+	return container_of(node, struct iopt_area, pages_node);
+}
+
+/*
+ * A simple datastructure to hold a vector of PFNs, optimized for contiguous
+ * PFNs. This is used as a temporary holding memory for shuttling pfns from one
+ * place to another. Generally everything is made more efficient if operations
+ * work on the largest possible grouping of pfns. eg fewer lock/unlock cycles,
+ * better cache locality, etc
+ */
+struct pfn_batch {
+	unsigned long *pfns;
+	u16 *npfns;
+	unsigned int array_size;
+	unsigned int end;
+	unsigned int total_pfns;
+};
+
+static void batch_clear(struct pfn_batch *batch)
+{
+	batch->total_pfns = 0;
+	batch->end = 0;
+	batch->pfns[0] = 0;
+	batch->npfns[0] = 0;
+}
+
+static int __batch_init(struct pfn_batch *batch, size_t max_pages, void *backup,
+			size_t backup_len)
+{
+	const size_t elmsz = sizeof(*batch->pfns) + sizeof(*batch->npfns);
+	size_t size = max_pages * elmsz;
+
+	batch->pfns = temp_kmalloc(&size, backup, backup_len);
+	if (!batch->pfns)
+		return -ENOMEM;
+	batch->array_size = size / elmsz;
+	batch->npfns = (u16 *)(batch->pfns + batch->array_size);
+	batch_clear(batch);
+	return 0;
+}
+
+static int batch_init(struct pfn_batch *batch, size_t max_pages)
+{
+	return __batch_init(batch, max_pages, NULL, 0);
+}
+
+static void batch_init_backup(struct pfn_batch *batch, size_t max_pages,
+			      void *backup, size_t backup_len)
+{
+	__batch_init(batch, max_pages, backup, backup_len);
+}
+
+static void batch_destroy(struct pfn_batch *batch, void *backup)
+{
+	if (batch->pfns != backup)
+		kfree(batch->pfns);
+}
+
+/* true if the pfn could be added, false otherwise */
+static bool batch_add_pfn(struct pfn_batch *batch, unsigned long pfn)
+{
+	/* FIXME: U16 is too small */
+	if (batch->end &&
+	    pfn == batch->pfns[batch->end - 1] + batch->npfns[batch->end - 1] &&
+	    batch->npfns[batch->end - 1] != U16_MAX) {
+		batch->npfns[batch->end - 1]++;
+		batch->total_pfns++;
+		return true;
+	}
+	if (batch->end == batch->array_size)
+		return false;
+	batch->total_pfns++;
+	batch->pfns[batch->end] = pfn;
+	batch->npfns[batch->end] = 1;
+	batch->end++;
+	return true;
+}
+
+/*
+ * Fill the batch with pfns from the domain. When the batch is full, or it
+ * reaches last_index, the function will return. The caller should use
+ * batch->total_pfns to determine the starting point for the next iteration.
+ */
+static void batch_from_domain(struct pfn_batch *batch,
+			      struct iommu_domain *domain,
+			      struct iopt_area *area, unsigned long index,
+			      unsigned long last_index)
+{
+	unsigned int page_offset = 0;
+	unsigned long iova;
+	phys_addr_t phys;
+
+	batch_clear(batch);
+	iova = iopt_area_index_to_iova(area, index);
+	if (index == iopt_area_index(area))
+		page_offset = area->page_offset;
+	while (index <= last_index) {
+		/*
+		 * This is pretty slow, it would be nice to get the page size
+		 * back from the driver, or have the driver directly fill the
+		 * batch.
+		 */
+		phys = iommu_iova_to_phys(domain, iova) - page_offset;
+		if (!batch_add_pfn(batch, PHYS_PFN(phys)))
+			return;
+		iova += PAGE_SIZE - page_offset;
+		page_offset = 0;
+		index++;
+	}
+}
+
+static int batch_to_domain(struct pfn_batch *batch, struct iommu_domain *domain,
+			   struct iopt_area *area, unsigned long start_index)
+{
+	unsigned long last_iova = iopt_area_last_iova(area);
+	unsigned int page_offset = 0;
+	unsigned long start_iova;
+	unsigned long next_iova;
+	unsigned int cur = 0;
+	unsigned long iova;
+	int rc;
+
+	/* The first index might be a partial page */
+	if (start_index == iopt_area_index(area))
+		page_offset = area->page_offset;
+	next_iova = iova = start_iova =
+		iopt_area_index_to_iova(area, start_index);
+	while (cur < batch->end) {
+		next_iova = min(last_iova + 1,
+				next_iova + batch->npfns[cur] * PAGE_SIZE -
+					page_offset);
+		rc = iommu_map(domain, iova,
+			       PFN_PHYS(batch->pfns[cur]) + page_offset,
+			       next_iova - iova, area->iommu_prot);
+		if (rc)
+			goto out_unmap;
+		iova = next_iova;
+		page_offset = 0;
+		cur++;
+	}
+	return 0;
+out_unmap:
+	if (start_iova != iova)
+		iommu_unmap_nofail(domain, start_iova, iova - start_iova);
+	return rc;
+}
+
+static void batch_from_xarray(struct pfn_batch *batch, struct xarray *xa,
+			      unsigned long start_index,
+			      unsigned long last_index)
+{
+	XA_STATE(xas, xa, start_index);
+	void *entry;
+
+	rcu_read_lock();
+	while (true) {
+		entry = xas_next(&xas);
+		if (xas_retry(&xas, entry))
+			continue;
+		WARN_ON(!xa_is_value(entry));
+		if (!batch_add_pfn(batch, xa_to_value(entry)) ||
+		    start_index == last_index)
+			break;
+		start_index++;
+	}
+	rcu_read_unlock();
+}
+
+static void clear_xarray(struct xarray *xa, unsigned long index,
+			 unsigned long last)
+{
+	XA_STATE(xas, xa, index);
+	void *entry;
+
+	xas_lock(&xas);
+	xas_for_each (&xas, entry, last)
+		xas_store(&xas, NULL);
+	xas_unlock(&xas);
+}
+
+static int batch_to_xarray(struct pfn_batch *batch, struct xarray *xa,
+			   unsigned long start_index)
+{
+	XA_STATE(xas, xa, start_index);
+	unsigned int npage = 0;
+	unsigned int cur = 0;
+
+	do {
+		xas_lock(&xas);
+		while (cur < batch->end) {
+			void *old;
+
+			old = xas_store(&xas,
+					xa_mk_value(batch->pfns[cur] + npage));
+			if (xas_error(&xas))
+				break;
+			WARN_ON(old);
+			npage++;
+			if (npage == batch->npfns[cur]) {
+				npage = 0;
+				cur++;
+			}
+			xas_next(&xas);
+		}
+		xas_unlock(&xas);
+	} while (xas_nomem(&xas, GFP_KERNEL));
+
+	if (xas_error(&xas)) {
+		if (xas.xa_index != start_index)
+			clear_xarray(xa, start_index, xas.xa_index - 1);
+		return xas_error(&xas);
+	}
+	return 0;
+}
+
+static void batch_to_pages(struct pfn_batch *batch, struct page **pages)
+{
+	unsigned int npage = 0;
+	unsigned int cur = 0;
+
+	while (cur < batch->end) {
+		*pages++ = pfn_to_page(batch->pfns[cur] + npage);
+		npage++;
+		if (npage == batch->npfns[cur]) {
+			npage = 0;
+			cur++;
+		}
+	}
+}
+
+static void batch_from_pages(struct pfn_batch *batch, struct page **pages,
+			     size_t npages)
+{
+	struct page **end = pages + npages;
+
+	for (; pages != end; pages++)
+		if (!batch_add_pfn(batch, page_to_pfn(*pages)))
+			break;
+}
+
+static void batch_unpin(struct pfn_batch *batch, struct iopt_pages *pages,
+			unsigned int offset, size_t npages)
+{
+	unsigned int cur = 0;
+
+	while (offset) {
+		if (batch->npfns[cur] > offset)
+			break;
+		offset -= batch->npfns[cur];
+		cur++;
+	}
+
+	while (npages) {
+		size_t to_unpin =
+			min_t(size_t, npages, batch->npfns[cur] - offset);
+
+		unpin_user_page_range_dirty_lock(
+			pfn_to_page(batch->pfns[cur] + offset), to_unpin,
+			pages->writable);
+		iopt_pages_sub_npinned(pages, to_unpin);
+		cur++;
+		offset = 0;
+		npages -= to_unpin;
+	}
+}
+
+/*
+ * PFNs are stored in three places, in order of preference:
+ * - The iopt_pages xarray. This is only populated if there is a
+ *   iopt_pages_user
+ * - The iommu_domain under an area
+ * - The original PFN source, ie pages->source_mm
+ *
+ * This iterator reads the pfns optimizing to load according to the
+ * above order.
+ */
+struct pfn_reader {
+	struct iopt_pages *pages;
+	struct interval_tree_span_iter span;
+	struct pfn_batch batch;
+	unsigned long batch_start_index;
+	unsigned long batch_end_index;
+	unsigned long last_index;
+
+	struct page **upages;
+	size_t upages_len;
+	unsigned long upages_start;
+	unsigned long upages_end;
+
+	unsigned int gup_flags;
+};
+
+static void update_unpinned(struct iopt_pages *pages)
+{
+	unsigned long npages = pages->last_npinned - pages->npinned;
+
+	lockdep_assert_held(&pages->mutex);
+
+	if (pages->has_cap_ipc_lock) {
+		pages->last_npinned = pages->npinned;
+		return;
+	}
+
+	if (WARN_ON(pages->npinned > pages->last_npinned) ||
+	    WARN_ON(atomic_long_read(&pages->source_user->locked_vm) < npages))
+		return;
+	atomic_long_sub(npages, &pages->source_user->locked_vm);
+	atomic64_sub(npages, &pages->source_mm->pinned_vm);
+	pages->last_npinned = pages->npinned;
+}
+
+/*
+ * Changes in the number of pages pinned is done after the pages have been read
+ * and processed. If the user lacked the limit then the error unwind will unpin
+ * everything that was just pinned.
+ */
+static int update_pinned(struct iopt_pages *pages)
+{
+	unsigned long lock_limit;
+	unsigned long cur_pages;
+	unsigned long new_pages;
+	unsigned long npages;
+
+	lockdep_assert_held(&pages->mutex);
+
+	if (pages->has_cap_ipc_lock) {
+		pages->last_npinned = pages->npinned;
+		return 0;
+	}
+
+	if (pages->npinned == pages->last_npinned)
+		return 0;
+
+	if (pages->npinned < pages->last_npinned) {
+		update_unpinned(pages);
+		return 0;
+	}
+
+	lock_limit =
+		task_rlimit(pages->source_task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	npages = pages->npinned - pages->last_npinned;
+	do {
+		cur_pages = atomic_long_read(&pages->source_user->locked_vm);
+		new_pages = cur_pages + npages;
+		if (new_pages > lock_limit)
+			return -ENOMEM;
+	} while (atomic_long_cmpxchg(&pages->source_user->locked_vm, cur_pages,
+				     new_pages) != cur_pages);
+	atomic64_add(npages, &pages->source_mm->pinned_vm);
+	pages->last_npinned = pages->npinned;
+	return 0;
+}
+
+static int pfn_reader_pin_pages(struct pfn_reader *pfns)
+{
+	struct iopt_pages *pages = pfns->pages;
+	unsigned long npages;
+	long rc;
+
+	if (!pfns->upages) {
+		/* All undone in iopt_pfn_reader_destroy */
+		pfns->upages_len =
+			(pfns->last_index - pfns->batch_end_index + 1) *
+			sizeof(*pfns->upages);
+		pfns->upages = temp_kmalloc(&pfns->upages_len, NULL, 0);
+		if (!pfns->upages)
+			return -ENOMEM;
+
+		if (!mmget_not_zero(pages->source_mm)) {
+			kfree(pfns->upages);
+			pfns->upages = NULL;
+			return -EINVAL;
+		}
+		mmap_read_lock(pages->source_mm);
+	}
+
+	npages = min_t(unsigned long,
+		       pfns->span.last_hole - pfns->batch_end_index + 1,
+		       pfns->upages_len / sizeof(*pfns->upages));
+
+	/* FIXME use pin_user_pages_fast() if current == source_mm */
+	rc = pin_user_pages_remote(
+		pages->source_mm,
+		(uintptr_t)(pages->uptr + pfns->batch_end_index * PAGE_SIZE),
+		npages, pfns->gup_flags, pfns->upages, NULL, NULL);
+	if (rc < 0)
+		return rc;
+	if (WARN_ON(!rc))
+		return -EFAULT;
+	iopt_pages_add_npinned(pages, rc);
+	pfns->upages_start = pfns->batch_end_index;
+	pfns->upages_end = pfns->batch_end_index + rc;
+	return 0;
+}
+
+/*
+ * The batch can contain a mixture of pages that are still in use and pages that
+ * need to be unpinned. Unpin only pages that are not held anywhere else.
+ */
+static void iopt_pages_unpin(struct iopt_pages *pages, struct pfn_batch *batch,
+			     unsigned long index, unsigned long last)
+{
+	struct interval_tree_span_iter user_span;
+	struct interval_tree_span_iter area_span;
+
+	lockdep_assert_held(&pages->mutex);
+
+	for (interval_tree_span_iter_first(&user_span, &pages->users_itree, 0,
+					   last);
+	     !interval_tree_span_iter_done(&user_span);
+	     interval_tree_span_iter_next(&user_span)) {
+		if (!user_span.is_hole)
+			continue;
+
+		for (interval_tree_span_iter_first(
+			     &area_span, &pages->domains_itree,
+			     user_span.start_hole, user_span.last_hole);
+		     !interval_tree_span_iter_done(&area_span);
+		     interval_tree_span_iter_next(&area_span)) {
+			if (!area_span.is_hole)
+				continue;
+
+			batch_unpin(batch, pages, area_span.start_hole - index,
+				    area_span.last_hole - area_span.start_hole +
+					    1);
+		}
+	}
+}
+
+/* Process a single span in the users_itree */
+static int pfn_reader_fill_span(struct pfn_reader *pfns)
+{
+	struct interval_tree_span_iter *span = &pfns->span;
+	struct iopt_area *area;
+	int rc;
+
+	if (!span->is_hole) {
+		batch_from_xarray(&pfns->batch, &pfns->pages->pinned_pfns,
+				  pfns->batch_end_index, span->last_used);
+		return 0;
+	}
+
+	/* FIXME: This should consider the entire hole remaining */
+	area = iopt_pages_find_domain_area(pfns->pages, pfns->batch_end_index);
+	if (area) {
+		unsigned int last_index;
+
+		last_index = min(iopt_area_last_index(area), span->last_hole);
+		/* The storage_domain cannot change without the pages mutex */
+		batch_from_domain(&pfns->batch, area->storage_domain, area,
+				  pfns->batch_end_index, last_index);
+		return 0;
+	}
+
+	if (pfns->batch_end_index >= pfns->upages_end) {
+		rc = pfn_reader_pin_pages(pfns);
+		if (rc)
+			return rc;
+	}
+
+	batch_from_pages(&pfns->batch,
+			 pfns->upages +
+				 (pfns->batch_end_index - pfns->upages_start),
+			 pfns->upages_end - pfns->batch_end_index);
+	return 0;
+}
+
+static bool pfn_reader_done(struct pfn_reader *pfns)
+{
+	return pfns->batch_start_index == pfns->last_index + 1;
+}
+
+static int pfn_reader_next(struct pfn_reader *pfns)
+{
+	int rc;
+
+	batch_clear(&pfns->batch);
+	pfns->batch_start_index = pfns->batch_end_index;
+	while (pfns->batch_end_index != pfns->last_index + 1) {
+		rc = pfn_reader_fill_span(pfns);
+		if (rc)
+			return rc;
+		pfns->batch_end_index =
+			pfns->batch_start_index + pfns->batch.total_pfns;
+		if (pfns->batch_end_index != pfns->span.last_used + 1)
+			return 0;
+		interval_tree_span_iter_next(&pfns->span);
+	}
+	return 0;
+}
+
+/*
+ * Adjust the pfn_reader to start at an externally determined hole span in the
+ * users_itree.
+ */
+static int pfn_reader_seek_hole(struct pfn_reader *pfns,
+				struct interval_tree_span_iter *span)
+{
+	pfns->batch_start_index = span->start_hole;
+	pfns->batch_end_index = span->start_hole;
+	pfns->last_index = span->last_hole;
+	pfns->span = *span;
+	return pfn_reader_next(pfns);
+}
+
+static int pfn_reader_init(struct pfn_reader *pfns, struct iopt_pages *pages,
+			   unsigned long index, unsigned long last)
+{
+	int rc;
+
+	lockdep_assert_held(&pages->mutex);
+
+	rc = batch_init(&pfns->batch, last - index + 1);
+	if (rc)
+		return rc;
+	pfns->pages = pages;
+	pfns->batch_start_index = index;
+	pfns->batch_end_index = index;
+	pfns->last_index = last;
+	pfns->upages = NULL;
+	pfns->upages_start = 0;
+	pfns->upages_end = 0;
+	interval_tree_span_iter_first(&pfns->span, &pages->users_itree, index,
+				      last);
+
+	if (pages->writable) {
+		pfns->gup_flags = FOLL_LONGTERM | FOLL_WRITE;
+	} else {
+		/* Still need to break COWs on read */
+		pfns->gup_flags = FOLL_LONGTERM | FOLL_FORCE | FOLL_WRITE;
+	}
+	return 0;
+}
+
+static void pfn_reader_destroy(struct pfn_reader *pfns)
+{
+	if (pfns->upages) {
+		size_t npages = pfns->upages_end - pfns->batch_end_index;
+
+		mmap_read_unlock(pfns->pages->source_mm);
+		mmput(pfns->pages->source_mm);
+
+		/* Any pages not transferred to the batch are just unpinned */
+		unpin_user_pages(pfns->upages + (pfns->batch_end_index -
+						 pfns->upages_start),
+				 npages);
+		kfree(pfns->upages);
+		pfns->upages = NULL;
+	}
+
+	if (pfns->batch_start_index != pfns->batch_end_index)
+		iopt_pages_unpin(pfns->pages, &pfns->batch,
+				 pfns->batch_start_index,
+				 pfns->batch_end_index - 1);
+	batch_destroy(&pfns->batch, NULL);
+	WARN_ON(pfns->pages->last_npinned != pfns->pages->npinned);
+}
+
+static int pfn_reader_first(struct pfn_reader *pfns, struct iopt_pages *pages,
+			    unsigned long index, unsigned long last)
+{
+	int rc;
+
+	rc = pfn_reader_init(pfns, pages, index, last);
+	if (rc)
+		return rc;
+	rc = pfn_reader_next(pfns);
+	if (rc) {
+		pfn_reader_destroy(pfns);
+		return rc;
+	}
+	return 0;
+}
-- 
2.35.1

