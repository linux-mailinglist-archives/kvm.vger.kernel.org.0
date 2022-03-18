Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38264DDFE9
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239642AbiCRR3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239635AbiCRR3L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:29:11 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290F72A4F90
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:27:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jo925Xbhhk6UeMNyw+XxsdZq+KTp8PwtxCzyZ+T5yqHbg1dJfp62+A9vb3fGUAQqiYjOfp6FYVEMCHQS2zK5jNybA+cx2cEwLIp1Z4SqvuM0xVlRVJIx06Ux5LsRnxMNoB590yN2s5qD0NBr34XParWv1aJd7F8ZSqnPcuaDfl3c3cBxjaF5JNqujWV3dRlj4nC2/R3IL0Tt3hDKzsaAMiOHoZvU1EHMX6IWpj0EetWychvStdyUaP2mmtZGefexRjQezgMiUGfAQTHAQas7oag+32p3wD227J18+zKRummlshvu36CmCi7NzIKGMNN92QA6i7JH+0X5QGEPL63Pig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tHJpxBxS1tDt2/b4xwa2I38aOIUUrnxck433Ya4GsB8=;
 b=VtbeSVrAtZVkS+2cJXuDs8I8SmdYVDnNXtMzFfK66HniyHY6UywLxaNhpZ5DgBrEqgHWon0zK8NG7/UcIcejEC1W0KPh5dBKK32PxVwOI7qalYO4scsjoVMGEUql8MwUhv2EmCu7lVtcsd/wZcN1E31kXrcqQv1UIztP4DtzM4X2fAZT+XHApGbQLf5VD0Tx8+eeft5E5GM0mnOAxARGbeHQ2UX/7cmQGnjJ95MysUNJSH6QnMhGXETk9vpa5z1w9KLryFcgfW/91mPILJRMkgU4UrMXrcEfq8BkkOEln+6rNpyDbqetlugjZJyGy1rQFClFe7x3y6HGicPPYA0/Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHJpxBxS1tDt2/b4xwa2I38aOIUUrnxck433Ya4GsB8=;
 b=sqh24Ata/qjWpp4JS0evYhVgLG+YQwmBQmSX0fIubHzvU4o6U1U3F7VzCX+V6JbAhHa24BUIhU9VpSqHpNopiwyo3p0XnVhy8rL8ekyJRiAOgZLWos9hE8BLhqmkhf3BCiGZc00nYvNJJyNj+3m31ACT4161B96ze08mbuHrINRPVZ4MCuXidoEQGenqXuX6g96uv0cyh9BDJIQ3Cs+sJpZjiThG6bHANjvLK8evM/RbEa0YMzaZ9thbCLQJc3D/0bnVhd1wF4lEmWvxFiqRmf0rX+M8Rmei5+ivz4Mcm5mhQ4tfP2WKKQCTZ2Bu4XwFIW7ecBi0vWKXuj6bg6i4Mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3951.namprd12.prod.outlook.com (2603:10b6:208:16b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 17:27:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 17:27:42 +0000
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
Subject: [PATCH RFC 12/12] iommufd: Add a selftest
Date:   Fri, 18 Mar 2022 14:27:37 -0300
Message-Id: <12-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0023.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::36) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c67c8b1d-aae0-4f0c-be17-08da09049a00
X-MS-TrafficTypeDiagnostic: MN2PR12MB3951:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB395132C072C3B2FEBCE511E2C2139@MN2PR12MB3951.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fCjbNhE97TOoZXLJygD9gYB3foeTlpXPd3qGgSC4sjHRBT4sUieIkPfdAu1hDQ2gbdsRUitFQ2VtiQGxHvfWoDjcBBjmcz6HZw7vR5V8pKhmGqo+Yj/Z7WZ4iJACjV3XxZXmjinkdz9p2yTEFww+aoGis3794BxsZKwz0QVX8eXbIKF0+ipzn7sWJJhpSF+tQo9s2Qssb3ZglRx1Z7QHRMGYYtaAR/W+hjT2PbYvcz5qHcmVU4mThfYn99dS7tKccs3Qn+hzjxKJsaUG7vrwhR+XaJw1M91rWo7HmVFVOwQ2ElGWhqnFBrpXyQE0vnSWq+W6GZnXxTkCv+izqMUfYzHKIsud4MSWBD4qzTstAWIyanv8V++lLlvWPpfYfqVFwbrl6AO64gy9izd6gWq2+7OVsNvwdIrQPHovr7wH/Y+We21ZBUM6EuWJb3XiNiVnKtp7UT+hjxXNZcNkt1RHJ69Tc+H4Wmc1iwHX+YhesEpMknNpsi0JlSrD4k6TyVyf70KTlGLAKoLe7VSf30PPBQMyLT0iB2/70SPmICJ0y1hnQ5n/itsCEjKUUUBqoqU6E3pKdnURum4suRKLFMni3xFeeiKwkux2SlWQDfdnewLGbQLiu6HgQUR2tmVMWLqXMS4QxQbW0gXQwtVQEb43oxE1raRxO8Rd5BUtyaouKfubR4dlOhvrNFhJ/KdUEeap
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(83380400001)(7416002)(4326008)(2906002)(86362001)(508600001)(8676002)(6512007)(6506007)(6666004)(5660300002)(8936002)(109986005)(66946007)(26005)(66476007)(186003)(316002)(66556008)(2616005)(36756003)(38100700002)(6486002)(54906003)(266003)(579004)(559001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uJzkmm/BJX/eduUdxE02EBdEy1WFQX1I8lEYDf0DnhYWHlQpkmMSqRFGaVs7?=
 =?us-ascii?Q?4W+157R8LZmV/MzkRYj4NP1TV/zmOS40AcigzO5ePdrDEpKpcO+3ATPPJGt8?=
 =?us-ascii?Q?/kry7uKFBhAMqZhvRTuhXFLrLFhi3TPGiH23YQI59ygbj4oU7yRTuNeua35i?=
 =?us-ascii?Q?INJF6JnX4MkXxhEf7GODmxRb6XnGM5MUdGzj7LoQo21rulDPQ23Pk1K1SwR6?=
 =?us-ascii?Q?9K9CLors05TatcQJV34Sc+ioKJ/6fy+2SQC/59Lmg/3U4LcZ34ou+wf5zgkj?=
 =?us-ascii?Q?zZoVgUaiLyvGp/Ja4ekcFQA1OfsmQ8fQT5p8vrlZZSyDbIEDVG8GufP/T1Xs?=
 =?us-ascii?Q?V52Lw/oOF43UzC8v4zmvQBfHdF6LmN54NLe6RLolfvKr4rq2/K4mb2nZiudz?=
 =?us-ascii?Q?vkiO27L+Thv19M3mqHguOwEnozcjYnWYuQLwAaeKAIpRsT8sj3jiFl1Q23W1?=
 =?us-ascii?Q?9YSY9ElcEKfb2jvN/W+snuGdoH+EisTWSUBPEWgDvcMR+fiH4+YROHU71xhD?=
 =?us-ascii?Q?CGdHlYlsza3cg9z6P4etx1lKN3P4tL+gF0tM+yXqFSG8uBIJi2ANUOxTxnLT?=
 =?us-ascii?Q?TPVIbRpCOc1gvSJlJtdRfB/d2Ym9RMCWvh7QtYUsLge34ZMGhr1fbzOmRxYw?=
 =?us-ascii?Q?FL5K/REp2+CSb2F4FiBOE12m5MQe/twO2RJM7I8bOGpdyzHLGdSnC98dt/wO?=
 =?us-ascii?Q?WhTTyjf6n7NuMStWoMhM96IQdX/bpE3q2lPj3tlJebrd//RakW+WbG5wSOVE?=
 =?us-ascii?Q?8llWdMHe4QjLf9/UDS/W1Qe92/6dLamcoBuis7jja7jbkY0iApzYh+H2aIdZ?=
 =?us-ascii?Q?i4BkZHR0CxHeMKQouP0tsF0NaP9/CUqB9fZwbmOoXrZSO3u0pRrT/Bwp21Ou?=
 =?us-ascii?Q?0rQ5s1M0gXYuBjbvdatJEtxsMaZnsRy9tWgUp3FJ5mi0gbY+Hu8ehd9MyTEz?=
 =?us-ascii?Q?KNLlwLeAuuvn7MEedWujYpP402Q5vLqQ9LlluU4S73HaJUjY5miwghBaLw4c?=
 =?us-ascii?Q?zEpDNvn0CFMYd1G/zpXIlcne4ZGWx0Wg4eo0YuY2e+KeXMSuNVV3JwU2+l84?=
 =?us-ascii?Q?jcvbCt3o1CGVbXDstE+RUpOLt4D2nV/wnTv4JwDtJgw/DVQvMQQLGZy9CO38?=
 =?us-ascii?Q?LNtPLLxRL1QuUnc6h/b3hpt+/K58Zc/7QL72m6oUME3zNYVhICWsKvJdIMsV?=
 =?us-ascii?Q?/zZIt6CfA5fqu2hq+QKKlNzOzbtaGNSUBI0AMwwPKCAF3RfHQ0zLlXI4G7sc?=
 =?us-ascii?Q?+JqEJrx7QpL220R04bjePbw6Uojy5OoKcD9wPR708+nMZ5prOVkqrGQMmwrP?=
 =?us-ascii?Q?qgkgc3chDHvSQqxvXXPv8XZYVQ29bRY6LrVaiU0sE0CWFdiwRwoEruB5wZ7z?=
 =?us-ascii?Q?GMGpORM0uoWXFvNCREMvGWRDuImaPgoxDKylfNa/yqIsiSCft60b5CW9qmSj?=
 =?us-ascii?Q?uAUPpDEi6dFuEEg8Ax4XMqrX0FNykq4D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c67c8b1d-aae0-4f0c-be17-08da09049a00
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:27:39.8042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YKe7kO+/BanWak/ONwgp8MQaUYEohTlDfBjDP45pNdZ5/7Y9f713tS0inK0wbxXF
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

Cover the essential functionality of the iommufd with a directed
test. This aims to achieve reasonable functional coverage using the
in-kernel self test framework.

It provides a mock for the iommu_domain that allows it to run without any
HW and the mocking provides a way to directly validate that the PFNs
loaded into the iommu_domain are correct.

The mock also simulates the rare case of PAGE_SIZE > iommu page size as
the mock will typically operate at a 2K iommu page size. This allows
exercising all of the calculations to support this mismatch.

This allows achieving high coverage of the corner cases in the iopt_pages.

However, it is an unusually invasive config option to enable all of
this. The config option should never be enabled in a production kernel.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/Kconfig            |    9 +
 drivers/iommu/iommufd/Makefile           |    2 +
 drivers/iommu/iommufd/iommufd_private.h  |    9 +
 drivers/iommu/iommufd/iommufd_test.h     |   65 ++
 drivers/iommu/iommufd/main.c             |   12 +
 drivers/iommu/iommufd/pages.c            |    4 +
 drivers/iommu/iommufd/selftest.c         |  495 +++++++++
 tools/testing/selftests/Makefile         |    1 +
 tools/testing/selftests/iommu/.gitignore |    2 +
 tools/testing/selftests/iommu/Makefile   |   11 +
 tools/testing/selftests/iommu/config     |    2 +
 tools/testing/selftests/iommu/iommufd.c  | 1225 ++++++++++++++++++++++
 12 files changed, 1837 insertions(+)
 create mode 100644 drivers/iommu/iommufd/iommufd_test.h
 create mode 100644 drivers/iommu/iommufd/selftest.c
 create mode 100644 tools/testing/selftests/iommu/.gitignore
 create mode 100644 tools/testing/selftests/iommu/Makefile
 create mode 100644 tools/testing/selftests/iommu/config
 create mode 100644 tools/testing/selftests/iommu/iommufd.c

diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index fddd453bb0e764..9b41fde7c839c5 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -11,3 +11,12 @@ config IOMMUFD
 	  This would commonly be used in combination with VFIO.
 
 	  If you don't know what to do here, say N.
+
+config IOMMUFD_TEST
+	bool "IOMMU Userspace API Test support"
+	depends on IOMMUFD
+	depends on RUNTIME_TESTING_MENU
+	default n
+	help
+	  This is dangerous, do not enable unless running
+	  tools/testing/selftests/iommu
diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index 2fdff04000b326..8aeba81800c512 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -8,4 +8,6 @@ iommufd-y := \
 	pages.o \
 	vfio_compat.o
 
+iommufd-$(CONFIG_IOMMUFD_TEST) += selftest.o
+
 obj-$(CONFIG_IOMMUFD) += iommufd.o
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 31628591591c17..6f11470c8ea677 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -102,6 +102,9 @@ enum iommufd_object_type {
 	IOMMUFD_OBJ_NONE,
 	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
 	IOMMUFD_OBJ_DEVICE,
+#ifdef CONFIG_IOMMUFD_TEST
+	IOMMUFD_OBJ_SELFTEST,
+#endif
 	IOMMUFD_OBJ_HW_PAGETABLE,
 	IOMMUFD_OBJ_IOAS,
 	IOMMUFD_OBJ_MAX,
@@ -219,4 +222,10 @@ void iommufd_hw_pagetable_destroy(struct iommufd_object *obj);
 
 void iommufd_device_destroy(struct iommufd_object *obj);
 
+#ifdef CONFIG_IOMMUFD_TEST
+int iommufd_test(struct iommufd_ucmd *ucmd);
+void iommufd_selftest_destroy(struct iommufd_object *obj);
+extern size_t iommufd_test_memory_limit;
+#endif
+
 #endif
diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
new file mode 100644
index 00000000000000..d22ef484af1a90
--- /dev/null
+++ b/drivers/iommu/iommufd/iommufd_test.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES.
+ */
+#ifndef _UAPI_IOMMUFD_TEST_H
+#define _UAPI_IOMMUFD_TEST_H
+
+#include <linux/types.h>
+#include <linux/iommufd.h>
+
+enum {
+	IOMMU_TEST_OP_ADD_RESERVED,
+	IOMMU_TEST_OP_MOCK_DOMAIN,
+	IOMMU_TEST_OP_MD_CHECK_MAP,
+	IOMMU_TEST_OP_MD_CHECK_REFS,
+	IOMMU_TEST_OP_ACCESS_PAGES,
+	IOMMU_TEST_OP_SET_TEMP_MEMORY_LIMIT,
+};
+
+enum {
+	MOCK_APERTURE_START = 1UL << 24,
+	MOCK_APERTURE_LAST = (1UL << 31) - 1,
+};
+
+enum {
+	MOCK_FLAGS_ACCESS_WRITE = 1 << 0,
+};
+
+struct iommu_test_cmd {
+	__u32 size;
+	__u32 op;
+	__u32 id;
+	union {
+		struct {
+			__u32 device_id;
+		} mock_domain;
+		struct {
+			__aligned_u64 start;
+			__aligned_u64 length;
+		} add_reserved;
+		struct {
+			__aligned_u64 iova;
+			__aligned_u64 length;
+			__aligned_u64 uptr;
+		} check_map;
+		struct {
+			__aligned_u64 length;
+			__aligned_u64 uptr;
+			__u32 refs;
+		} check_refs;
+		struct {
+			__u32 flags;
+			__u32 out_access_id;
+			__aligned_u64 iova;
+			__aligned_u64 length;
+			__aligned_u64 uptr;
+		} access_pages;
+		struct {
+			__u32 limit;
+		} memory_limit;
+	};
+	__u32 last;
+};
+#define IOMMU_TEST_CMD _IO(IOMMUFD_TYPE, IOMMUFD_CMD_BASE + 32)
+
+#endif
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index f746fcff8145cb..8c820bb90caa72 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -24,6 +24,7 @@
 #include <uapi/linux/iommufd.h>
 
 #include "iommufd_private.h"
+#include "iommufd_test.h"
 
 struct iommufd_object_ops {
 	void (*destroy)(struct iommufd_object *obj);
@@ -191,6 +192,9 @@ union ucmd_buffer {
 	struct iommu_ioas_map map;
 	struct iommu_ioas_unmap unmap;
 	struct iommu_destroy destroy;
+#ifdef CONFIG_IOMMUFD_TEST
+	struct iommu_test_cmd test;
+#endif
 };
 
 struct iommufd_ioctl_op {
@@ -223,6 +227,9 @@ static struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 length),
 	IOCTL_OP(IOMMU_VFIO_IOAS, iommufd_vfio_ioas, struct iommu_vfio_ioas,
 		 __reserved),
+#ifdef CONFIG_IOMMUFD_TEST
+	IOCTL_OP(IOMMU_TEST_CMD, iommufd_test, struct iommu_test_cmd, last),
+#endif
 };
 
 static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
@@ -299,6 +306,11 @@ static struct iommufd_object_ops iommufd_object_ops[] = {
 	[IOMMUFD_OBJ_HW_PAGETABLE] = {
 		.destroy = iommufd_hw_pagetable_destroy,
 	},
+#ifdef CONFIG_IOMMUFD_TEST
+	[IOMMUFD_OBJ_SELFTEST] = {
+		.destroy = iommufd_selftest_destroy,
+	},
+#endif
 };
 
 static struct miscdevice iommu_misc_dev = {
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 8e6a8cc8b20ad1..3fd39e0201f542 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -48,7 +48,11 @@
 
 #include "io_pagetable.h"
 
+#ifndef CONFIG_IOMMUFD_TEST
 #define TEMP_MEMORY_LIMIT 65536
+#else
+#define TEMP_MEMORY_LIMIT iommufd_test_memory_limit
+#endif
 #define BATCH_BACKUP_SIZE 32
 
 /*
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
new file mode 100644
index 00000000000000..a665719b493ec5
--- /dev/null
+++ b/drivers/iommu/iommufd/selftest.c
@@ -0,0 +1,495 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES.
+ *
+ * Kernel side components to support tools/testing/selftests/iommu
+ */
+#include <linux/slab.h>
+#include <linux/iommu.h>
+#include <linux/xarray.h>
+
+#include "iommufd_private.h"
+#include "iommufd_test.h"
+
+size_t iommufd_test_memory_limit = 65536;
+
+enum {
+	MOCK_IO_PAGE_SIZE = PAGE_SIZE / 2,
+
+	/*
+	 * Like a real page table alignment requires the low bits of the address
+	 * to be zero. xarray also requires the high bit to be zero, so we store
+	 * the pfns shifted. The upper bits are used for metadata.
+	 */
+	MOCK_PFN_MASK = ULONG_MAX / MOCK_IO_PAGE_SIZE,
+
+	_MOCK_PFN_START = MOCK_PFN_MASK + 1,
+	MOCK_PFN_START_IOVA = _MOCK_PFN_START,
+	MOCK_PFN_LAST_IOVA = _MOCK_PFN_START,
+};
+
+struct mock_iommu_domain {
+	struct iommu_domain domain;
+	struct xarray pfns;
+};
+
+enum selftest_obj_type {
+	TYPE_ACCESS,
+	TYPE_IDEV,
+};
+
+struct selftest_obj {
+	struct iommufd_object obj;
+	enum selftest_obj_type type;
+
+	union {
+		struct {
+			struct iommufd_ioas *ioas;
+			unsigned long iova;
+			size_t length;
+		} access;
+		struct {
+			struct iommufd_hw_pagetable *hwpt;
+			struct iommufd_ctx *ictx;
+		} idev;
+	};
+};
+
+static struct iommu_domain *mock_domain_alloc(unsigned int iommu_domain_type)
+{
+	struct mock_iommu_domain *mock;
+
+	if (WARN_ON(iommu_domain_type != IOMMU_DOMAIN_UNMANAGED))
+		return NULL;
+
+	mock = kzalloc(sizeof(*mock), GFP_KERNEL);
+	if (!mock)
+		return NULL;
+	mock->domain.geometry.aperture_start = MOCK_APERTURE_START;
+	mock->domain.geometry.aperture_end = MOCK_APERTURE_LAST;
+	mock->domain.pgsize_bitmap = MOCK_IO_PAGE_SIZE;
+	xa_init(&mock->pfns);
+	return &mock->domain;
+}
+
+static void mock_domain_free(struct iommu_domain *domain)
+{
+	struct mock_iommu_domain *mock =
+		container_of(domain, struct mock_iommu_domain, domain);
+
+	WARN_ON(!xa_empty(&mock->pfns));
+	kfree(mock);
+}
+
+static int mock_domain_map_pages(struct iommu_domain *domain,
+				 unsigned long iova, phys_addr_t paddr,
+				 size_t pgsize, size_t pgcount, int prot,
+				 gfp_t gfp, size_t *mapped)
+{
+	struct mock_iommu_domain *mock =
+		container_of(domain, struct mock_iommu_domain, domain);
+	unsigned long flags = MOCK_PFN_START_IOVA;
+
+	WARN_ON(iova % MOCK_IO_PAGE_SIZE);
+	WARN_ON(pgsize % MOCK_IO_PAGE_SIZE);
+	for (; pgcount; pgcount--) {
+		size_t cur;
+
+		for (cur = 0; cur != pgsize; cur += MOCK_IO_PAGE_SIZE) {
+			void *old;
+
+			if (pgcount == 1 && cur + MOCK_IO_PAGE_SIZE == pgsize)
+				flags = MOCK_PFN_LAST_IOVA;
+			old = xa_store(&mock->pfns, iova / MOCK_IO_PAGE_SIZE,
+				       xa_mk_value((paddr / MOCK_IO_PAGE_SIZE) | flags),
+				       GFP_KERNEL);
+			if (xa_is_err(old))
+				return xa_err(old);
+			WARN_ON(old);
+			iova += MOCK_IO_PAGE_SIZE;
+			paddr += MOCK_IO_PAGE_SIZE;
+			*mapped += MOCK_IO_PAGE_SIZE;
+			flags = 0;
+		}
+	}
+	return 0;
+}
+
+static size_t mock_domain_unmap_pages(struct iommu_domain *domain,
+				      unsigned long iova, size_t pgsize,
+				      size_t pgcount,
+				      struct iommu_iotlb_gather *iotlb_gather)
+{
+	struct mock_iommu_domain *mock =
+		container_of(domain, struct mock_iommu_domain, domain);
+	bool first = true;
+	size_t ret = 0;
+	void *ent;
+
+	WARN_ON(iova % MOCK_IO_PAGE_SIZE);
+	WARN_ON(pgsize % MOCK_IO_PAGE_SIZE);
+
+	for (; pgcount; pgcount--) {
+		size_t cur;
+
+		for (cur = 0; cur != pgsize; cur += MOCK_IO_PAGE_SIZE) {
+			ent = xa_erase(&mock->pfns, iova / MOCK_IO_PAGE_SIZE);
+			WARN_ON(!ent);
+			/*
+			 * iommufd generates unmaps that must be a strict
+			 * superset of the map's performend So every starting
+			 * IOVA should have been an iova passed to map, and the
+			 *
+			 * First IOVA must be present and have been a first IOVA
+			 * passed to map_pages
+			 */
+			if (first) {
+				WARN_ON(!(xa_to_value(ent) &
+					  MOCK_PFN_START_IOVA));
+				first = false;
+			}
+			if (pgcount == 1 && cur + MOCK_IO_PAGE_SIZE == pgsize)
+				WARN_ON(!(xa_to_value(ent) &
+					  MOCK_PFN_LAST_IOVA));
+
+			iova += MOCK_IO_PAGE_SIZE;
+			ret += MOCK_IO_PAGE_SIZE;
+		}
+	}
+	return ret;
+}
+
+static phys_addr_t mock_domain_iova_to_phys(struct iommu_domain *domain,
+					    dma_addr_t iova)
+{
+	struct mock_iommu_domain *mock =
+		container_of(domain, struct mock_iommu_domain, domain);
+	void *ent;
+
+	WARN_ON(iova % MOCK_IO_PAGE_SIZE);
+	ent = xa_load(&mock->pfns, iova / MOCK_IO_PAGE_SIZE);
+	WARN_ON(!ent);
+	return (xa_to_value(ent) & MOCK_PFN_MASK) * MOCK_IO_PAGE_SIZE;
+}
+
+static const struct iommu_ops mock_ops = {
+	.owner = THIS_MODULE,
+	.pgsize_bitmap = MOCK_IO_PAGE_SIZE,
+	.domain_alloc = mock_domain_alloc,
+	.default_domain_ops =
+		&(struct iommu_domain_ops){
+			.free = mock_domain_free,
+			.map_pages = mock_domain_map_pages,
+			.unmap_pages = mock_domain_unmap_pages,
+			.iova_to_phys = mock_domain_iova_to_phys,
+		},
+};
+
+static inline struct iommufd_hw_pagetable *
+get_md_pagetable(struct iommufd_ucmd *ucmd, u32 mockpt_id,
+		 struct mock_iommu_domain **mock)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	struct iommufd_object *obj;
+
+	obj = iommufd_get_object(ucmd->ictx, mockpt_id,
+				 IOMMUFD_OBJ_HW_PAGETABLE);
+	if (IS_ERR(obj))
+		return ERR_CAST(obj);
+	hwpt = container_of(obj, struct iommufd_hw_pagetable, obj);
+	if (hwpt->domain->ops != mock_ops.default_domain_ops) {
+		return ERR_PTR(-EINVAL);
+		iommufd_put_object(&hwpt->obj);
+	}
+	*mock = container_of(hwpt->domain, struct mock_iommu_domain, domain);
+	return hwpt;
+}
+
+/* Create an hw_pagetable with the mock domain so we can test the domain ops */
+static int iommufd_test_mock_domain(struct iommufd_ucmd *ucmd,
+				    struct iommu_test_cmd *cmd)
+{
+	struct bus_type mock_bus = { .iommu_ops = &mock_ops };
+	struct device mock_dev = { .bus = &mock_bus };
+	struct iommufd_hw_pagetable *hwpt;
+	struct selftest_obj *sobj;
+	int rc;
+
+	sobj = iommufd_object_alloc(ucmd->ictx, sobj, IOMMUFD_OBJ_SELFTEST);
+	if (IS_ERR(sobj))
+		return PTR_ERR(sobj);
+	sobj->idev.ictx = ucmd->ictx;
+	sobj->type = TYPE_IDEV;
+
+	hwpt = iommufd_hw_pagetable_from_id(ucmd->ictx, cmd->id, &mock_dev);
+	if (IS_ERR(hwpt)) {
+		rc = PTR_ERR(hwpt);
+		goto out_sobj;
+	}
+	if (WARN_ON(refcount_read(&hwpt->obj.users) != 2)) {
+		rc = -EINVAL;
+		goto out_hwpt;
+	}
+	sobj->idev.hwpt = hwpt;
+
+	/* Creating a real iommufd_device is too hard, fake one */
+	rc = iopt_table_add_domain(&hwpt->ioas->iopt, hwpt->domain);
+	if (rc)
+		goto out_hwpt;
+
+	/* Convert auto domain to user created */
+	list_del_init(&hwpt->auto_domains_item);
+	cmd->id = hwpt->obj.id;
+	cmd->mock_domain.device_id = sobj->obj.id;
+	iommufd_object_finalize(ucmd->ictx, &sobj->obj);
+	return iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+
+out_hwpt:
+	iommufd_hw_pagetable_put(ucmd->ictx, hwpt);
+out_sobj:
+	iommufd_object_abort(ucmd->ictx, &sobj->obj);
+	return rc;
+}
+
+/* Add an additional reserved IOVA to the IOAS */
+static int iommufd_test_add_reserved(struct iommufd_ucmd *ucmd,
+				     unsigned int mockpt_id,
+				     unsigned long start, size_t length)
+{
+	struct iommufd_ioas *ioas;
+	int rc;
+
+	ioas = iommufd_get_ioas(ucmd, mockpt_id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+	down_write(&ioas->iopt.iova_rwsem);
+	rc = iopt_reserve_iova(&ioas->iopt, start, start + length - 1, NULL);
+	up_write(&ioas->iopt.iova_rwsem);
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+/* Check that every pfn under each iova matches the pfn under a user VA */
+static int iommufd_test_md_check_pa(struct iommufd_ucmd *ucmd,
+				    unsigned int mockpt_id, unsigned long iova,
+				    size_t length, void __user *uptr)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	struct mock_iommu_domain *mock;
+	int rc;
+
+	if (iova % MOCK_IO_PAGE_SIZE || length % MOCK_IO_PAGE_SIZE ||
+	    (uintptr_t)uptr % MOCK_IO_PAGE_SIZE)
+		return -EINVAL;
+
+	hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	for (; length; length -= MOCK_IO_PAGE_SIZE) {
+		struct page *pages[1];
+		unsigned long pfn;
+		long npages;
+		void *ent;
+
+		npages = get_user_pages_fast((uintptr_t)uptr & PAGE_MASK, 1, 0,
+					     pages);
+		if (npages < 0) {
+			rc = npages;
+			goto out_put;
+		}
+		if (WARN_ON(npages != 1)) {
+			rc = -EFAULT;
+			goto out_put;
+		}
+		pfn = page_to_pfn(pages[0]);
+		put_page(pages[0]);
+
+		ent = xa_load(&mock->pfns, iova / MOCK_IO_PAGE_SIZE);
+		if (!ent ||
+		    (xa_to_value(ent) & MOCK_PFN_MASK) * MOCK_IO_PAGE_SIZE !=
+			    pfn * PAGE_SIZE + ((uintptr_t)uptr % PAGE_SIZE)) {
+			rc = -EINVAL;
+			goto out_put;
+		}
+		iova += MOCK_IO_PAGE_SIZE;
+		uptr += MOCK_IO_PAGE_SIZE;
+	}
+	rc = 0;
+
+out_put:
+	iommufd_put_object(&hwpt->obj);
+	return rc;
+}
+
+/* Check that the page ref count matches, to look for missing pin/unpins */
+static int iommufd_test_md_check_refs(struct iommufd_ucmd *ucmd,
+				      void __user *uptr, size_t length,
+				      unsigned int refs)
+{
+	if (length % PAGE_SIZE || (uintptr_t)uptr % PAGE_SIZE)
+		return -EINVAL;
+
+	for (; length; length -= PAGE_SIZE) {
+		struct page *pages[1];
+		long npages;
+
+		npages = get_user_pages_fast((uintptr_t)uptr, 1, 0, pages);
+		if (npages < 0)
+			return npages;
+		if (WARN_ON(npages != 1))
+			return -EFAULT;
+		if (!PageCompound(pages[0])) {
+			unsigned int count;
+
+			count = page_ref_count(pages[0]);
+			if (count / GUP_PIN_COUNTING_BIAS != refs) {
+				put_page(pages[0]);
+				return -EIO;
+			}
+		}
+		put_page(pages[0]);
+		uptr += PAGE_SIZE;
+	}
+	return 0;
+}
+
+/* Check that the pages in a page array match the pages in the user VA */
+static int iommufd_test_check_pages(void __user *uptr, struct page **pages,
+				    size_t npages)
+{
+	for (; npages; npages--) {
+		struct page *tmp_pages[1];
+		long rc;
+
+		rc = get_user_pages_fast((uintptr_t)uptr, 1, 0, tmp_pages);
+		if (rc < 0)
+			return rc;
+		if (WARN_ON(rc != 1))
+			return -EFAULT;
+		put_page(tmp_pages[0]);
+		if (tmp_pages[0] != *pages)
+			return -EBADE;
+		pages++;
+		uptr += PAGE_SIZE;
+	}
+	return 0;
+}
+
+/* Test iopt_access_pages() by checking it returns the correct pages */
+static int iommufd_test_access_pages(struct iommufd_ucmd *ucmd,
+				     unsigned int ioas_id, unsigned long iova,
+				     size_t length, void __user *uptr,
+				     u32 flags)
+{
+	struct iommu_test_cmd *cmd = ucmd->cmd;
+	struct selftest_obj *sobj;
+	struct page **pages;
+	size_t npages;
+	int rc;
+
+	if (flags & ~MOCK_FLAGS_ACCESS_WRITE)
+		return -EOPNOTSUPP;
+
+	sobj = iommufd_object_alloc(ucmd->ictx, sobj, IOMMUFD_OBJ_SELFTEST);
+	if (IS_ERR(sobj))
+		return PTR_ERR(sobj);
+	sobj->type = TYPE_ACCESS;
+
+	npages = (ALIGN(iova + length, PAGE_SIZE) -
+		  ALIGN_DOWN(iova, PAGE_SIZE)) /
+		 PAGE_SIZE;
+	pages = kvcalloc(npages, sizeof(*pages), GFP_KERNEL);
+	if (!pages) {
+		rc = -ENOMEM;
+		goto out_abort;
+	}
+
+	sobj->access.ioas = iommufd_get_ioas(ucmd, ioas_id);
+	if (IS_ERR(sobj->access.ioas)) {
+		rc = PTR_ERR(sobj->access.ioas);
+		goto out_free;
+	}
+
+	sobj->access.iova = iova;
+	sobj->access.length = length;
+	rc = iopt_access_pages(&sobj->access.ioas->iopt, iova, length, pages,
+			       flags & MOCK_FLAGS_ACCESS_WRITE);
+	if (rc)
+		goto out_put;
+
+	rc = iommufd_test_check_pages(
+		uptr - (iova - ALIGN_DOWN(iova, PAGE_SIZE)), pages, npages);
+	if (rc)
+		goto out_unaccess;
+
+	cmd->access_pages.out_access_id = sobj->obj.id;
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+	if (rc)
+		goto out_unaccess;
+
+	iommufd_object_finalize(ucmd->ictx, &sobj->obj);
+	iommufd_put_object_keep_user(&sobj->access.ioas->obj);
+	kvfree(pages);
+	return 0;
+out_unaccess:
+	iopt_unaccess_pages(&sobj->access.ioas->iopt, iova, length);
+out_put:
+	iommufd_put_object(&sobj->access.ioas->obj);
+out_free:
+	kvfree(pages);
+out_abort:
+	iommufd_object_abort(ucmd->ictx, &sobj->obj);
+	return rc;
+}
+
+void iommufd_selftest_destroy(struct iommufd_object *obj)
+{
+	struct selftest_obj *sobj = container_of(obj, struct selftest_obj, obj);
+
+	switch (sobj->type) {
+	case TYPE_IDEV:
+		iopt_table_remove_domain(&sobj->idev.hwpt->ioas->iopt,
+					 sobj->idev.hwpt->domain);
+		iommufd_hw_pagetable_put(sobj->idev.ictx, sobj->idev.hwpt);
+		break;
+	case TYPE_ACCESS:
+		iopt_unaccess_pages(&sobj->access.ioas->iopt,
+				    sobj->access.iova, sobj->access.length);
+		refcount_dec(&sobj->access.ioas->obj.users);
+		break;
+	}
+}
+
+int iommufd_test(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_test_cmd *cmd = ucmd->cmd;
+
+	switch (cmd->op) {
+	case IOMMU_TEST_OP_ADD_RESERVED:
+		return iommufd_test_add_reserved(ucmd, cmd->id,
+						 cmd->add_reserved.start,
+						 cmd->add_reserved.length);
+	case IOMMU_TEST_OP_MOCK_DOMAIN:
+		return iommufd_test_mock_domain(ucmd, cmd);
+	case IOMMU_TEST_OP_MD_CHECK_MAP:
+		return iommufd_test_md_check_pa(
+			ucmd, cmd->id, cmd->check_map.iova,
+			cmd->check_map.length,
+			u64_to_user_ptr(cmd->check_map.uptr));
+	case IOMMU_TEST_OP_MD_CHECK_REFS:
+		return iommufd_test_md_check_refs(
+			ucmd, u64_to_user_ptr(cmd->check_refs.uptr),
+			cmd->check_refs.length, cmd->check_refs.refs);
+	case IOMMU_TEST_OP_ACCESS_PAGES:
+		return iommufd_test_access_pages(
+			ucmd, cmd->id, cmd->access_pages.iova,
+			cmd->access_pages.length,
+			u64_to_user_ptr(cmd->access_pages.uptr),
+			cmd->access_pages.flags);
+	case IOMMU_TEST_OP_SET_TEMP_MEMORY_LIMIT:
+		iommufd_test_memory_limit = cmd->memory_limit.limit;
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index d08fe4cfe81152..5533a3b2e8af51 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -21,6 +21,7 @@ TARGETS += ftrace
 TARGETS += futex
 TARGETS += gpio
 TARGETS += intel_pstate
+TARGETS += iommu
 TARGETS += ipc
 TARGETS += ir
 TARGETS += kcmp
diff --git a/tools/testing/selftests/iommu/.gitignore b/tools/testing/selftests/iommu/.gitignore
new file mode 100644
index 00000000000000..c6bd07e7ff59b3
--- /dev/null
+++ b/tools/testing/selftests/iommu/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+/iommufd
diff --git a/tools/testing/selftests/iommu/Makefile b/tools/testing/selftests/iommu/Makefile
new file mode 100644
index 00000000000000..7bc38b3beaeb20
--- /dev/null
+++ b/tools/testing/selftests/iommu/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+CFLAGS += -Wall -O2 -Wno-unused-function
+CFLAGS += -I../../../../include/uapi/
+CFLAGS += -I../../../../include/
+
+CFLAGS += -D_GNU_SOURCE
+
+TEST_GEN_PROGS :=
+TEST_GEN_PROGS += iommufd
+
+include ../lib.mk
diff --git a/tools/testing/selftests/iommu/config b/tools/testing/selftests/iommu/config
new file mode 100644
index 00000000000000..6c4f901d6fed3c
--- /dev/null
+++ b/tools/testing/selftests/iommu/config
@@ -0,0 +1,2 @@
+CONFIG_IOMMUFD
+CONFIG_IOMMUFD_TEST
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
new file mode 100644
index 00000000000000..5c47d706ed9449
--- /dev/null
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -0,0 +1,1225 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES */
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/fcntl.h>
+#include <sys/ioctl.h>
+#include <assert.h>
+#include <stddef.h>
+
+#include "../kselftest_harness.h"
+
+#define __EXPORTED_HEADERS__
+#include <linux/iommufd.h>
+#include <linux/vfio.h>
+#include "../../../../drivers/iommu/iommufd/iommufd_test.h"
+
+static void *buffer;
+
+static unsigned long PAGE_SIZE;
+static unsigned long HUGEPAGE_SIZE;
+static unsigned long BUFFER_SIZE;
+
+#define MOCK_PAGE_SIZE (PAGE_SIZE / 2)
+
+static unsigned long get_huge_page_size(void)
+{
+	char buf[80];
+	int ret;
+	int fd;
+
+	fd = open("/sys/kernel/mm/transparent_hugepage/hpage_pmd_size",
+		  O_RDONLY);
+	if (fd < 0)
+		return 2 * 1024 * 1024;
+
+	ret = read(fd, buf, sizeof(buf));
+	close(fd);
+	if (ret <= 0 || ret == sizeof(buf))
+		return 2 * 1024 * 1024;
+	buf[ret] = 0;
+	return strtoul(buf, NULL, 10);
+}
+
+static __attribute__((constructor)) void setup_sizes(void)
+{
+	int rc;
+
+	PAGE_SIZE = sysconf(_SC_PAGE_SIZE);
+	HUGEPAGE_SIZE = get_huge_page_size();
+
+	BUFFER_SIZE = PAGE_SIZE * 16;
+	rc = posix_memalign(&buffer, HUGEPAGE_SIZE, BUFFER_SIZE);
+	assert(rc || buffer || (uintptr_t)buffer % HUGEPAGE_SIZE == 0);
+}
+
+/*
+ * Have the kernel check the refcount on pages. I don't know why a freshly
+ * mmap'd anon non-compound page starts out with a ref of 3
+ */
+#define check_refs(_ptr, _length, _refs)                                       \
+	({                                                                     \
+		struct iommu_test_cmd test_cmd = {                             \
+			.size = sizeof(test_cmd),                              \
+			.op = IOMMU_TEST_OP_MD_CHECK_REFS,                     \
+			.check_refs = { .length = _length,                     \
+					.uptr = (uintptr_t)(_ptr),             \
+					.refs = _refs },                       \
+		};                                                             \
+		ASSERT_EQ(0,                                                   \
+			  ioctl(self->fd,                                      \
+				_IOMMU_TEST_CMD(IOMMU_TEST_OP_MD_CHECK_REFS),  \
+				&test_cmd));                                   \
+	})
+
+/* Hack to make assertions more readable */
+#define _IOMMU_TEST_CMD(x) IOMMU_TEST_CMD
+
+#define EXPECT_ERRNO(expected_errno, cmd)                                      \
+	({                                                                     \
+		ASSERT_EQ(-1, cmd);                                            \
+		EXPECT_EQ(expected_errno, errno);                              \
+	})
+
+FIXTURE(iommufd) {
+	int fd;
+};
+
+FIXTURE_SETUP(iommufd) {
+	self->fd = open("/dev/iommu", O_RDWR);
+	ASSERT_NE(-1, self->fd);
+}
+
+FIXTURE_TEARDOWN(iommufd) {
+	ASSERT_EQ(0, close(self->fd));
+}
+
+TEST_F(iommufd, simple_close)
+{
+}
+
+TEST_F(iommufd, cmd_fail)
+{
+	struct iommu_destroy cmd = { .size = sizeof(cmd), .id = 0 };
+
+	/* object id is invalid */
+	EXPECT_ERRNO(ENOENT, ioctl(self->fd, IOMMU_DESTROY, &cmd));
+	/* Bad pointer */
+	EXPECT_ERRNO(EFAULT, ioctl(self->fd, IOMMU_DESTROY, NULL));
+	/* Unknown ioctl */
+	EXPECT_ERRNO(ENOTTY,
+		     ioctl(self->fd, _IO(IOMMUFD_TYPE, IOMMUFD_CMD_BASE - 1),
+			   &cmd));
+}
+
+TEST_F(iommufd, cmd_ex_fail)
+{
+	struct {
+		struct iommu_destroy cmd;
+		__u64 future;
+	} cmd = { .cmd = { .size = sizeof(cmd), .id = 0 } };
+
+	/* object id is invalid and command is longer */
+	EXPECT_ERRNO(ENOENT, ioctl(self->fd, IOMMU_DESTROY, &cmd));
+	/* future area is non-zero */
+	cmd.future = 1;
+	EXPECT_ERRNO(E2BIG, ioctl(self->fd, IOMMU_DESTROY, &cmd));
+	/* Original command "works" */
+	cmd.cmd.size = sizeof(cmd.cmd);
+	EXPECT_ERRNO(ENOENT, ioctl(self->fd, IOMMU_DESTROY, &cmd));
+	/* Short command fails */
+	cmd.cmd.size = sizeof(cmd.cmd) - 1;
+	EXPECT_ERRNO(EOPNOTSUPP, ioctl(self->fd, IOMMU_DESTROY, &cmd));
+}
+
+FIXTURE(iommufd_ioas) {
+	int fd;
+	uint32_t ioas_id;
+	uint32_t domain_id;
+	uint64_t base_iova;
+};
+
+FIXTURE_VARIANT(iommufd_ioas) {
+	unsigned int mock_domains;
+	unsigned int memory_limit;
+};
+
+FIXTURE_SETUP(iommufd_ioas) {
+	struct iommu_test_cmd memlimit_cmd = {
+		.size = sizeof(memlimit_cmd),
+		.op = IOMMU_TEST_OP_SET_TEMP_MEMORY_LIMIT,
+		.memory_limit = {.limit = variant->memory_limit},
+	};
+	struct iommu_ioas_alloc alloc_cmd = {
+		.size = sizeof(alloc_cmd),
+	};
+	unsigned int i;
+
+	if (!variant->memory_limit)
+		memlimit_cmd.memory_limit.limit = 65536;
+
+	self->fd = open("/dev/iommu", O_RDWR);
+	ASSERT_NE(-1, self->fd);
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_ALLOC, &alloc_cmd));
+	ASSERT_NE(0, alloc_cmd.out_ioas_id);
+	self->ioas_id = alloc_cmd.out_ioas_id;
+
+	ASSERT_EQ(0, ioctl(self->fd,
+			   _IOMMU_TEST_CMD(IOMMU_TEST_OP_SET_TEMP_MEMORY_LIMIT),
+			   &memlimit_cmd));
+
+	for (i = 0; i != variant->mock_domains; i++) {
+		struct iommu_test_cmd test_cmd = {
+			.size = sizeof(test_cmd),
+			.op = IOMMU_TEST_OP_MOCK_DOMAIN,
+			.id = self->ioas_id,
+		};
+
+		ASSERT_EQ(0, ioctl(self->fd,
+				   _IOMMU_TEST_CMD(IOMMU_TEST_OP_MOCK_DOMAIN),
+				   &test_cmd));
+		EXPECT_NE(0, test_cmd.id);
+		self->domain_id = test_cmd.id;
+		self->base_iova = MOCK_APERTURE_START;
+	}
+}
+
+FIXTURE_TEARDOWN(iommufd_ioas) {
+	struct iommu_test_cmd memlimit_cmd = {
+		.size = sizeof(memlimit_cmd),
+		.op = IOMMU_TEST_OP_SET_TEMP_MEMORY_LIMIT,
+		.memory_limit = {.limit = 65536},
+	};
+
+	ASSERT_EQ(0, ioctl(self->fd,
+			   _IOMMU_TEST_CMD(IOMMU_TEST_OP_SET_TEMP_MEMORY_LIMIT),
+			   &memlimit_cmd));
+	ASSERT_EQ(0, close(self->fd));
+
+	self->fd = open("/dev/iommu", O_RDWR);
+	ASSERT_NE(-1, self->fd);
+	check_refs(buffer, BUFFER_SIZE, 0);
+	ASSERT_EQ(0, close(self->fd));
+}
+
+FIXTURE_VARIANT_ADD(iommufd_ioas, no_domain) {
+};
+
+FIXTURE_VARIANT_ADD(iommufd_ioas, mock_domain) {
+	.mock_domains = 1,
+};
+
+FIXTURE_VARIANT_ADD(iommufd_ioas, two_mock_domain) {
+	.mock_domains = 2,
+};
+
+FIXTURE_VARIANT_ADD(iommufd_ioas, mock_domain_limit) {
+	.mock_domains = 1,
+	.memory_limit = 16,
+};
+
+TEST_F(iommufd_ioas, ioas_auto_destroy)
+{
+}
+
+TEST_F(iommufd_ioas, ioas_destroy)
+{
+	struct iommu_destroy destroy_cmd = {
+		.size = sizeof(destroy_cmd),
+		.id = self->ioas_id,
+	};
+
+	if (self->domain_id) {
+		/* IOAS cannot be freed while a domain is on it */
+		EXPECT_ERRNO(EBUSY,
+			     ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+	} else {
+		/* Can allocate and manually free an IOAS table */
+		ASSERT_EQ(0, ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+	}
+}
+
+TEST_F(iommufd_ioas, ioas_area_destroy)
+{
+	struct iommu_destroy destroy_cmd = {
+		.size = sizeof(destroy_cmd),
+		.id = self->ioas_id,
+	};
+	struct iommu_ioas_map map_cmd = {
+		.size = sizeof(map_cmd),
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
+		.ioas_id = self->ioas_id,
+		.user_va = (uintptr_t)buffer,
+		.length = PAGE_SIZE,
+		.iova = self->base_iova,
+	};
+
+	/* Adding an area does not change ability to destroy */
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	if (self->domain_id)
+		EXPECT_ERRNO(EBUSY,
+			     ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+	else
+		ASSERT_EQ(0, ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+}
+
+TEST_F(iommufd_ioas, ioas_area_auto_destroy)
+{
+	struct iommu_ioas_map map_cmd = {
+		.size = sizeof(map_cmd),
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
+		.ioas_id = self->ioas_id,
+		.user_va = (uintptr_t)buffer,
+		.length = PAGE_SIZE,
+	};
+	int i;
+
+	/* Can allocate and automatically free an IOAS table with many areas */
+	for (i = 0; i != 10; i++) {
+		map_cmd.iova = self->base_iova + i * PAGE_SIZE;
+		ASSERT_EQ(0,
+			  ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	}
+}
+
+TEST_F(iommufd_ioas, area)
+{
+	struct iommu_ioas_map map_cmd = {
+		.size = sizeof(map_cmd),
+		.ioas_id = self->ioas_id,
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
+		.length = PAGE_SIZE,
+		.user_va = (uintptr_t)buffer,
+	};
+	struct iommu_ioas_unmap unmap_cmd = {
+		.size = sizeof(unmap_cmd),
+		.ioas_id = self->ioas_id,
+		.length = PAGE_SIZE,
+	};
+	int i;
+
+	/* Unmap fails if nothing is mapped */
+	for (i = 0; i != 10; i++) {
+		unmap_cmd.iova = i * PAGE_SIZE;
+		EXPECT_ERRNO(ENOENT, ioctl(self->fd, IOMMU_IOAS_UNMAP,
+					   &unmap_cmd));
+	}
+
+	/* Unmap works */
+	for (i = 0; i != 10; i++) {
+		map_cmd.iova = self->base_iova + i * PAGE_SIZE;
+		ASSERT_EQ(0,
+			  ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	}
+	for (i = 0; i != 10; i++) {
+		unmap_cmd.iova = self->base_iova + i * PAGE_SIZE;
+		ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_UNMAP,
+				   &unmap_cmd));
+	}
+
+	/* Split fails */
+	map_cmd.length = PAGE_SIZE * 2;
+	map_cmd.iova = self->base_iova + 16 * PAGE_SIZE;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	unmap_cmd.iova = self->base_iova + 16 * PAGE_SIZE;
+	EXPECT_ERRNO(ENOENT,
+		     ioctl(self->fd, IOMMU_IOAS_UNMAP, &unmap_cmd));
+	unmap_cmd.iova = self->base_iova + 17 * PAGE_SIZE;
+	EXPECT_ERRNO(ENOENT,
+		     ioctl(self->fd, IOMMU_IOAS_UNMAP, &unmap_cmd));
+
+	/* Over map fails */
+	map_cmd.length = PAGE_SIZE * 2;
+	map_cmd.iova = self->base_iova + 16 * PAGE_SIZE;
+	EXPECT_ERRNO(EADDRINUSE,
+		     ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	map_cmd.length = PAGE_SIZE;
+	map_cmd.iova = self->base_iova + 16 * PAGE_SIZE;
+	EXPECT_ERRNO(EADDRINUSE,
+		     ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	map_cmd.length = PAGE_SIZE;
+	map_cmd.iova = self->base_iova + 17 * PAGE_SIZE;
+	EXPECT_ERRNO(EADDRINUSE,
+		     ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	map_cmd.length = PAGE_SIZE * 2;
+	map_cmd.iova = self->base_iova + 15 * PAGE_SIZE;
+	EXPECT_ERRNO(EADDRINUSE,
+		     ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	map_cmd.length = PAGE_SIZE * 3;
+	map_cmd.iova = self->base_iova + 15 * PAGE_SIZE;
+	EXPECT_ERRNO(EADDRINUSE,
+		     ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+
+	/* unmap all works */
+	unmap_cmd.iova = 0;
+	unmap_cmd.length = UINT64_MAX;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_UNMAP, &unmap_cmd));
+}
+
+TEST_F(iommufd_ioas, area_auto_iova)
+{
+	struct iommu_test_cmd test_cmd = {
+		.size = sizeof(test_cmd),
+		.op = IOMMU_TEST_OP_ADD_RESERVED,
+		.id = self->ioas_id,
+		.add_reserved = { .start = PAGE_SIZE * 4,
+				  .length = PAGE_SIZE * 100 },
+	};
+	struct iommu_ioas_map map_cmd = {
+		.size = sizeof(map_cmd),
+		.ioas_id = self->ioas_id,
+		.length = PAGE_SIZE,
+		.user_va = (uintptr_t)buffer,
+	};
+	struct iommu_ioas_unmap unmap_cmd = {
+		.size = sizeof(unmap_cmd),
+		.ioas_id = self->ioas_id,
+		.length = PAGE_SIZE,
+	};
+	uint64_t iovas[10];
+	int i;
+
+	/* Simple 4k pages */
+	for (i = 0; i != 10; i++) {
+		ASSERT_EQ(0,
+			  ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+		iovas[i] = map_cmd.iova;
+	}
+	for (i = 0; i != 10; i++) {
+		unmap_cmd.iova = iovas[i];
+		ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_UNMAP,
+				   &unmap_cmd));
+	}
+
+	/* Kernel automatically aligns IOVAs properly */
+	if (self->domain_id)
+		map_cmd.user_va = (uintptr_t)buffer;
+	else
+		map_cmd.user_va = 1UL << 31;
+	for (i = 0; i != 10; i++) {
+		map_cmd.length = PAGE_SIZE * (i + 1);
+		ASSERT_EQ(0,
+			  ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+		iovas[i] = map_cmd.iova;
+		EXPECT_EQ(0, map_cmd.iova % (1UL << (ffs(map_cmd.length)-1)));
+	}
+	for (i = 0; i != 10; i++) {
+		unmap_cmd.length = PAGE_SIZE * (i + 1);
+		unmap_cmd.iova = iovas[i];
+		ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_UNMAP,
+				   &unmap_cmd));
+	}
+
+	/* Avoids a reserved region */
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ADD_RESERVED),
+			&test_cmd));
+	for (i = 0; i != 10; i++) {
+		map_cmd.length = PAGE_SIZE * (i + 1);
+		ASSERT_EQ(0,
+			  ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+		iovas[i] = map_cmd.iova;
+		EXPECT_EQ(0, map_cmd.iova % (1UL << (ffs(map_cmd.length)-1)));
+		EXPECT_EQ(false,
+			  map_cmd.iova > test_cmd.add_reserved.start &&
+				  map_cmd.iova <
+					  test_cmd.add_reserved.start +
+						  test_cmd.add_reserved.length);
+	}
+	for (i = 0; i != 10; i++) {
+		unmap_cmd.length = PAGE_SIZE * (i + 1);
+		unmap_cmd.iova = iovas[i];
+		ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_UNMAP,
+				   &unmap_cmd));
+	}
+}
+
+TEST_F(iommufd_ioas, copy_area)
+{
+	struct iommu_ioas_map map_cmd = {
+		.size = sizeof(map_cmd),
+		.ioas_id = self->ioas_id,
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
+		.length = PAGE_SIZE,
+		.user_va = (uintptr_t)buffer,
+	};
+	struct iommu_ioas_copy copy_cmd = {
+		.size = sizeof(copy_cmd),
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
+		.dst_ioas_id = self->ioas_id,
+		.src_ioas_id = self->ioas_id,
+		.length = PAGE_SIZE,
+	};
+	struct iommu_ioas_alloc alloc_cmd = {
+		.size = sizeof(alloc_cmd),
+	};
+
+	map_cmd.iova = self->base_iova;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+
+	/* Copy inside a single IOAS */
+	copy_cmd.src_iova = self->base_iova;
+	copy_cmd.dst_iova = self->base_iova + PAGE_SIZE;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_COPY, &copy_cmd));
+
+	/* Copy between IOAS's */
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_ALLOC, &alloc_cmd));
+	ASSERT_NE(0, alloc_cmd.out_ioas_id);
+	copy_cmd.src_iova = self->base_iova;
+	copy_cmd.dst_iova = 0;
+	copy_cmd.dst_ioas_id = alloc_cmd.out_ioas_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_COPY, &copy_cmd));
+}
+
+TEST_F(iommufd_ioas, iova_ranges)
+{
+	struct iommu_test_cmd test_cmd = {
+		.size = sizeof(test_cmd),
+		.op = IOMMU_TEST_OP_ADD_RESERVED,
+		.id = self->ioas_id,
+		.add_reserved = { .start = PAGE_SIZE, .length = PAGE_SIZE },
+	};
+	struct iommu_ioas_iova_ranges *cmd = (void *)buffer;
+
+	*cmd = (struct iommu_ioas_iova_ranges){
+		.size = BUFFER_SIZE,
+		.ioas_id = self->ioas_id,
+	};
+
+	/* Range can be read */
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_IOVA_RANGES, cmd));
+	EXPECT_EQ(1, cmd->out_num_iovas);
+	if (!self->domain_id) {
+		EXPECT_EQ(0, cmd->out_valid_iovas[0].start);
+		EXPECT_EQ(SIZE_MAX, cmd->out_valid_iovas[0].last);
+	} else {
+		EXPECT_EQ(MOCK_APERTURE_START, cmd->out_valid_iovas[0].start);
+		EXPECT_EQ(MOCK_APERTURE_LAST, cmd->out_valid_iovas[0].last);
+	}
+	memset(cmd->out_valid_iovas, 0,
+	       sizeof(cmd->out_valid_iovas[0]) * cmd->out_num_iovas);
+
+	/* Buffer too small */
+	cmd->size = sizeof(*cmd);
+	EXPECT_ERRNO(EMSGSIZE,
+		     ioctl(self->fd, IOMMU_IOAS_IOVA_RANGES, cmd));
+	EXPECT_EQ(1, cmd->out_num_iovas);
+	EXPECT_EQ(0, cmd->out_valid_iovas[0].start);
+	EXPECT_EQ(0, cmd->out_valid_iovas[0].last);
+
+	/* 2 ranges */
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ADD_RESERVED),
+			&test_cmd));
+	cmd->size = BUFFER_SIZE;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_IOVA_RANGES, cmd));
+	if (!self->domain_id) {
+		EXPECT_EQ(2, cmd->out_num_iovas);
+		EXPECT_EQ(0, cmd->out_valid_iovas[0].start);
+		EXPECT_EQ(PAGE_SIZE - 1, cmd->out_valid_iovas[0].last);
+		EXPECT_EQ(PAGE_SIZE * 2, cmd->out_valid_iovas[1].start);
+		EXPECT_EQ(SIZE_MAX, cmd->out_valid_iovas[1].last);
+	} else {
+		EXPECT_EQ(1, cmd->out_num_iovas);
+		EXPECT_EQ(MOCK_APERTURE_START, cmd->out_valid_iovas[0].start);
+		EXPECT_EQ(MOCK_APERTURE_LAST, cmd->out_valid_iovas[0].last);
+	}
+	memset(cmd->out_valid_iovas, 0,
+	       sizeof(cmd->out_valid_iovas[0]) * cmd->out_num_iovas);
+
+	/* Buffer too small */
+	cmd->size = sizeof(*cmd) + sizeof(cmd->out_valid_iovas[0]);
+	if (!self->domain_id) {
+		EXPECT_ERRNO(EMSGSIZE,
+			     ioctl(self->fd, IOMMU_IOAS_IOVA_RANGES, cmd));
+		EXPECT_EQ(2, cmd->out_num_iovas);
+		EXPECT_EQ(0, cmd->out_valid_iovas[0].start);
+		EXPECT_EQ(PAGE_SIZE - 1, cmd->out_valid_iovas[0].last);
+	} else {
+		ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_IOVA_RANGES, cmd));
+		EXPECT_EQ(1, cmd->out_num_iovas);
+		EXPECT_EQ(MOCK_APERTURE_START, cmd->out_valid_iovas[0].start);
+		EXPECT_EQ(MOCK_APERTURE_LAST, cmd->out_valid_iovas[0].last);
+	}
+	EXPECT_EQ(0, cmd->out_valid_iovas[1].start);
+	EXPECT_EQ(0, cmd->out_valid_iovas[1].last);
+}
+
+TEST_F(iommufd_ioas, access)
+{
+	struct iommu_ioas_map map_cmd = {
+		.size = sizeof(map_cmd),
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
+		.ioas_id = self->ioas_id,
+		.user_va = (uintptr_t)buffer,
+		.length = BUFFER_SIZE,
+		.iova = MOCK_APERTURE_START,
+	};
+	struct iommu_test_cmd access_cmd = {
+		.size = sizeof(access_cmd),
+		.op = IOMMU_TEST_OP_ACCESS_PAGES,
+		.id = self->ioas_id,
+		.access_pages = { .iova = MOCK_APERTURE_START,
+				  .length = BUFFER_SIZE,
+				  .uptr = (uintptr_t)buffer },
+	};
+	struct iommu_test_cmd mock_cmd = {
+		.size = sizeof(mock_cmd),
+		.op = IOMMU_TEST_OP_MOCK_DOMAIN,
+		.id = self->ioas_id,
+	};
+	struct iommu_test_cmd check_map_cmd = {
+		.size = sizeof(check_map_cmd),
+		.op = IOMMU_TEST_OP_MD_CHECK_MAP,
+		.check_map = { .iova = MOCK_APERTURE_START,
+			       .length = BUFFER_SIZE,
+			       .uptr = (uintptr_t)buffer },
+	};
+	struct iommu_destroy destroy_cmd = { .size = sizeof(destroy_cmd) };
+	uint32_t id;
+
+	/* Single map/unmap */
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
+			&access_cmd));
+	destroy_cmd.id = access_cmd.access_pages.out_access_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+
+	/* Double user */
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
+			&access_cmd));
+	id = access_cmd.access_pages.out_access_id;
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
+			&access_cmd));
+	destroy_cmd.id = access_cmd.access_pages.out_access_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+	destroy_cmd.id = id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+
+	/* Add/remove a domain with a user */
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
+			&access_cmd));
+	ASSERT_EQ(0, ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_MOCK_DOMAIN),
+			   &mock_cmd));
+	check_map_cmd.id = mock_cmd.id;
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_MD_CHECK_MAP),
+			&check_map_cmd));
+	destroy_cmd.id = mock_cmd.mock_domain.device_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+	destroy_cmd.id = mock_cmd.id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+	destroy_cmd.id = access_cmd.access_pages.out_access_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+}
+
+FIXTURE(iommufd_mock_domain) {
+	int fd;
+	uint32_t ioas_id;
+	uint32_t domain_id;
+	uint32_t domain_ids[2];
+	int mmap_flags;
+	size_t mmap_buf_size;
+};
+
+FIXTURE_VARIANT(iommufd_mock_domain) {
+	unsigned int mock_domains;
+	bool hugepages;
+};
+
+FIXTURE_SETUP(iommufd_mock_domain)
+{
+	struct iommu_ioas_alloc alloc_cmd = {
+		.size = sizeof(alloc_cmd),
+	};
+	struct iommu_test_cmd test_cmd = {
+		.size = sizeof(test_cmd),
+		.op = IOMMU_TEST_OP_MOCK_DOMAIN,
+	};
+	unsigned int i;
+
+	self->fd = open("/dev/iommu", O_RDWR);
+	ASSERT_NE(-1, self->fd);
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_ALLOC, &alloc_cmd));
+	ASSERT_NE(0, alloc_cmd.out_ioas_id);
+	self->ioas_id = alloc_cmd.out_ioas_id;
+
+	ASSERT_GE(ARRAY_SIZE(self->domain_ids), variant->mock_domains);
+
+	for (i = 0; i != variant->mock_domains; i++) {
+		test_cmd.id = self->ioas_id;
+		ASSERT_EQ(0, ioctl(self->fd,
+				   _IOMMU_TEST_CMD(IOMMU_TEST_OP_MOCK_DOMAIN),
+				   &test_cmd));
+		EXPECT_NE(0, test_cmd.id);
+		self->domain_ids[i] = test_cmd.id;
+	}
+	self->domain_id = self->domain_ids[0];
+
+	self->mmap_flags = MAP_SHARED | MAP_ANONYMOUS;
+	self->mmap_buf_size = PAGE_SIZE * 8;
+	if (variant->hugepages) {
+		/*
+		 * MAP_POPULATE will cause the kernel to fail mmap if THPs are
+		 * not available.
+		 */
+		self->mmap_flags |= MAP_HUGETLB | MAP_POPULATE;
+		self->mmap_buf_size = HUGEPAGE_SIZE * 2;
+	}
+}
+
+FIXTURE_TEARDOWN(iommufd_mock_domain) {
+	ASSERT_EQ(0, close(self->fd));
+
+	self->fd = open("/dev/iommu", O_RDWR);
+	ASSERT_NE(-1, self->fd);
+	check_refs(buffer, BUFFER_SIZE, 0);
+	ASSERT_EQ(0, close(self->fd));
+}
+
+FIXTURE_VARIANT_ADD(iommufd_mock_domain, one_domain) {
+	.mock_domains = 1,
+	.hugepages = false,
+};
+
+FIXTURE_VARIANT_ADD(iommufd_mock_domain, two_domains) {
+	.mock_domains = 2,
+	.hugepages = false,
+};
+
+FIXTURE_VARIANT_ADD(iommufd_mock_domain, one_domain_hugepage) {
+	.mock_domains = 1,
+	.hugepages = true,
+};
+
+FIXTURE_VARIANT_ADD(iommufd_mock_domain, two_domains_hugepage) {
+	.mock_domains = 2,
+	.hugepages = true,
+};
+
+/* Have the kernel check that the user pages made it to the iommu_domain */
+#define check_mock_iova(_ptr, _iova, _length)                                  \
+	({                                                                     \
+		struct iommu_test_cmd check_map_cmd = {                        \
+			.size = sizeof(check_map_cmd),                         \
+			.op = IOMMU_TEST_OP_MD_CHECK_MAP,                      \
+			.id = self->domain_id,                                 \
+			.check_map = { .iova = _iova,                          \
+				       .length = _length,                      \
+				       .uptr = (uintptr_t)(_ptr) },            \
+		};                                                             \
+		ASSERT_EQ(0,                                                   \
+			  ioctl(self->fd,                                      \
+				_IOMMU_TEST_CMD(IOMMU_TEST_OP_MD_CHECK_MAP),   \
+				&check_map_cmd));                              \
+		if (self->domain_ids[1]) {                                     \
+			check_map_cmd.id = self->domain_ids[1];                \
+			ASSERT_EQ(0,                                           \
+				  ioctl(self->fd,                              \
+					_IOMMU_TEST_CMD(                       \
+						IOMMU_TEST_OP_MD_CHECK_MAP),   \
+					&check_map_cmd));                      \
+		}                                                              \
+	})
+
+TEST_F(iommufd_mock_domain, basic)
+{
+	struct iommu_ioas_map map_cmd = {
+		.size = sizeof(map_cmd),
+		.ioas_id = self->ioas_id,
+	};
+	struct iommu_ioas_unmap unmap_cmd = {
+		.size = sizeof(unmap_cmd),
+		.ioas_id = self->ioas_id,
+	};
+	size_t buf_size = self->mmap_buf_size;
+	uint8_t *buf;
+
+	/* Simple one page map */
+	map_cmd.user_va = (uintptr_t)buffer;
+	map_cmd.length = PAGE_SIZE;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	check_mock_iova(buffer, map_cmd.iova, map_cmd.length);
+
+	buf = mmap(0, buf_size, PROT_READ | PROT_WRITE, self->mmap_flags, -1,
+		   0);
+	ASSERT_NE(MAP_FAILED, buf);
+
+	/* EFAULT half way through mapping */
+	ASSERT_EQ(0, munmap(buf + buf_size / 2, buf_size / 2));
+	map_cmd.user_va = (uintptr_t)buf;
+	map_cmd.length = buf_size;
+	EXPECT_ERRNO(EFAULT,
+		     ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+
+	/* EFAULT on first page */
+	ASSERT_EQ(0, munmap(buf, buf_size / 2));
+	EXPECT_ERRNO(EFAULT,
+		     ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+}
+
+TEST_F(iommufd_mock_domain, all_aligns)
+{
+	struct iommu_ioas_map map_cmd = {
+		.size = sizeof(map_cmd),
+		.ioas_id = self->ioas_id,
+	};
+	struct iommu_ioas_unmap unmap_cmd = {
+		.size = sizeof(unmap_cmd),
+		.ioas_id = self->ioas_id,
+	};
+	size_t test_step =
+		variant->hugepages ? (self->mmap_buf_size / 16) : MOCK_PAGE_SIZE;
+	size_t buf_size = self->mmap_buf_size;
+	unsigned int start;
+	unsigned int end;
+	uint8_t *buf;
+
+	buf = mmap(0, buf_size, PROT_READ | PROT_WRITE, self->mmap_flags, -1, 0);
+	ASSERT_NE(MAP_FAILED, buf);
+	check_refs(buf, buf_size, 0);
+
+	/*
+	 * Map every combination of page size and alignment within a big region,
+	 * less for hugepage case as it takes so long to finish.
+	 */
+	for (start = 0; start < buf_size; start += test_step) {
+		map_cmd.user_va = (uintptr_t)buf + start;
+		if (variant->hugepages)
+			end = buf_size;
+		else
+			end = start + MOCK_PAGE_SIZE;
+		for (; end < buf_size; end += MOCK_PAGE_SIZE) {
+			map_cmd.length = end - start;
+			ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_MAP,
+					   &map_cmd));
+			check_mock_iova(buf + start, map_cmd.iova,
+					map_cmd.length);
+			check_refs(buf + start / PAGE_SIZE * PAGE_SIZE,
+				   end / PAGE_SIZE * PAGE_SIZE -
+					   start / PAGE_SIZE * PAGE_SIZE,
+				   1);
+
+			unmap_cmd.iova = map_cmd.iova;
+			unmap_cmd.length = end - start;
+			ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_UNMAP,
+					   &unmap_cmd));
+		}
+	}
+	check_refs(buf, buf_size, 0);
+	ASSERT_EQ(0, munmap(buf, buf_size));
+}
+
+TEST_F(iommufd_mock_domain, all_aligns_copy)
+{
+	struct iommu_ioas_map map_cmd = {
+		.size = sizeof(map_cmd),
+		.ioas_id = self->ioas_id,
+	};
+	struct iommu_ioas_unmap unmap_cmd = {
+		.size = sizeof(unmap_cmd),
+		.ioas_id = self->ioas_id,
+	};
+	struct iommu_test_cmd add_mock_pt = {
+		.size = sizeof(add_mock_pt),
+		.op = IOMMU_TEST_OP_MOCK_DOMAIN,
+	};
+	struct iommu_destroy destroy_cmd = {
+		.size = sizeof(destroy_cmd),
+	};
+	size_t test_step =
+		variant->hugepages ? self->mmap_buf_size / 16 : MOCK_PAGE_SIZE;
+	size_t buf_size = self->mmap_buf_size;
+	unsigned int start;
+	unsigned int end;
+	uint8_t *buf;
+
+	buf = mmap(0, buf_size, PROT_READ | PROT_WRITE, self->mmap_flags, -1, 0);
+	ASSERT_NE(MAP_FAILED, buf);
+	check_refs(buf, buf_size, 0);
+
+	/*
+	 * Map every combination of page size and alignment within a big region,
+	 * less for hugepage case as it takes so long to finish.
+	 */
+	for (start = 0; start < buf_size; start += test_step) {
+		map_cmd.user_va = (uintptr_t)buf + start;
+		if (variant->hugepages)
+			end = buf_size;
+		else
+			end = start + MOCK_PAGE_SIZE;
+		for (; end < buf_size; end += MOCK_PAGE_SIZE) {
+			unsigned int old_id;
+
+			map_cmd.length = end - start;
+			ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_MAP,
+					   &map_cmd));
+
+			/* Add and destroy a domain while the area exists */
+			add_mock_pt.id = self->ioas_id;
+			ASSERT_EQ(0, ioctl(self->fd,
+					   _IOMMU_TEST_CMD(
+						   IOMMU_TEST_OP_MOCK_DOMAIN),
+					   &add_mock_pt));
+			old_id = self->domain_ids[1];
+			self->domain_ids[1] = add_mock_pt.id;
+
+			check_mock_iova(buf + start, map_cmd.iova,
+					map_cmd.length);
+			check_refs(buf + start / PAGE_SIZE * PAGE_SIZE,
+				   end / PAGE_SIZE * PAGE_SIZE -
+					   start / PAGE_SIZE * PAGE_SIZE,
+				   1);
+
+			destroy_cmd.id = add_mock_pt.mock_domain.device_id;
+			ASSERT_EQ(0,
+				  ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+			destroy_cmd.id = add_mock_pt.id;
+			ASSERT_EQ(0,
+				  ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+			self->domain_ids[1] = old_id;
+
+			unmap_cmd.iova = map_cmd.iova;
+			unmap_cmd.length = end - start;
+			ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_UNMAP,
+					   &unmap_cmd));
+		}
+	}
+	check_refs(buf, buf_size, 0);
+	ASSERT_EQ(0, munmap(buf, buf_size));
+}
+
+TEST_F(iommufd_mock_domain, user_copy)
+{
+	struct iommu_ioas_alloc alloc_cmd = {
+		.size = sizeof(alloc_cmd),
+	};
+	struct iommu_ioas_map map_cmd = {
+		.size = sizeof(map_cmd),
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
+		.ioas_id = self->ioas_id,
+		.user_va = (uintptr_t)buffer,
+		.length = BUFFER_SIZE,
+		.iova = MOCK_APERTURE_START,
+	};
+	struct iommu_test_cmd access_cmd = {
+		.size = sizeof(access_cmd),
+		.op = IOMMU_TEST_OP_ACCESS_PAGES,
+		.id = self->ioas_id,
+		.access_pages = { .iova = MOCK_APERTURE_START,
+				  .length = BUFFER_SIZE,
+				  .uptr = (uintptr_t)buffer },
+	};
+	struct iommu_ioas_copy copy_cmd = {
+		.size = sizeof(copy_cmd),
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
+		.dst_ioas_id = self->ioas_id,
+		.src_iova = MOCK_APERTURE_START,
+		.dst_iova = MOCK_APERTURE_START,
+		.length = BUFFER_SIZE,
+	};
+	struct iommu_destroy destroy_cmd = { .size = sizeof(destroy_cmd) };
+
+	/* Pin the pages in an IOAS with no domains then copy to an IOAS with domains */
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_ALLOC, &alloc_cmd));
+	map_cmd.ioas_id = alloc_cmd.out_ioas_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	access_cmd.id = alloc_cmd.out_ioas_id;
+
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
+			&access_cmd));
+	copy_cmd.src_ioas_id = alloc_cmd.out_ioas_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_COPY, &copy_cmd));
+	check_mock_iova(buffer, map_cmd.iova, BUFFER_SIZE);
+
+	destroy_cmd.id = access_cmd.access_pages.out_access_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+	destroy_cmd.id = alloc_cmd.out_ioas_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_DESTROY, &destroy_cmd));
+}
+
+FIXTURE(vfio_compat_nodev) {
+	int fd;
+};
+
+FIXTURE_SETUP(vfio_compat_nodev) {
+	self->fd = open("/dev/iommu", O_RDWR);
+	ASSERT_NE(-1, self->fd);
+}
+
+FIXTURE_TEARDOWN(vfio_compat_nodev) {
+	ASSERT_EQ(0, close(self->fd));
+}
+
+TEST_F(vfio_compat_nodev, simple_ioctls)
+{
+	ASSERT_EQ(VFIO_API_VERSION, ioctl(self->fd, VFIO_GET_API_VERSION));
+	ASSERT_EQ(1, ioctl(self->fd, VFIO_CHECK_EXTENSION, VFIO_TYPE1v2_IOMMU));
+}
+
+TEST_F(vfio_compat_nodev, unmap_cmd)
+{
+	struct vfio_iommu_type1_dma_unmap unmap_cmd = {
+		.iova = MOCK_APERTURE_START,
+		.size = PAGE_SIZE,
+	};
+
+	unmap_cmd.argsz = 1;
+	EXPECT_ERRNO(EINVAL, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
+
+	unmap_cmd.argsz = sizeof(unmap_cmd);
+	unmap_cmd.flags = 1 << 31;
+	EXPECT_ERRNO(EINVAL, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
+
+	unmap_cmd.flags = 0;
+	EXPECT_ERRNO(ENODEV, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
+}
+
+TEST_F(vfio_compat_nodev, map_cmd)
+{
+	struct vfio_iommu_type1_dma_map map_cmd = {
+		.iova = MOCK_APERTURE_START,
+		.size = PAGE_SIZE,
+		.vaddr = (__u64)buffer,
+	};
+
+	map_cmd.argsz = 1;
+	EXPECT_ERRNO(EINVAL, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
+
+	map_cmd.argsz = sizeof(map_cmd);
+	map_cmd.flags = 1 << 31;
+	EXPECT_ERRNO(EINVAL, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
+
+	/* Requires a domain to be attached */
+	map_cmd.flags = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE;
+	EXPECT_ERRNO(ENODEV, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
+}
+
+TEST_F(vfio_compat_nodev, info_cmd)
+{
+	struct vfio_iommu_type1_info info_cmd = {};
+
+	/* Invalid argsz */
+	info_cmd.argsz = 1;
+	EXPECT_ERRNO(EINVAL, ioctl(self->fd, VFIO_IOMMU_GET_INFO, &info_cmd));
+
+	info_cmd.argsz = sizeof(info_cmd);
+	EXPECT_ERRNO(ENODEV, ioctl(self->fd, VFIO_IOMMU_GET_INFO, &info_cmd));
+}
+
+TEST_F(vfio_compat_nodev, set_iommu_cmd)
+{
+	/* Requires a domain to be attached */
+	EXPECT_ERRNO(ENODEV, ioctl(self->fd, VFIO_SET_IOMMU, VFIO_TYPE1v2_IOMMU));
+}
+
+TEST_F(vfio_compat_nodev, vfio_ioas)
+{
+	struct iommu_ioas_alloc alloc_cmd = {
+		.size = sizeof(alloc_cmd),
+	};
+	struct iommu_vfio_ioas vfio_ioas_cmd = {
+		.size = sizeof(vfio_ioas_cmd),
+		.op = IOMMU_VFIO_IOAS_GET,
+	};
+
+	/* ENODEV if there is no compat ioas */
+	EXPECT_ERRNO(ENODEV, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
+
+	/* Invalid id for set */
+	vfio_ioas_cmd.op = IOMMU_VFIO_IOAS_SET;
+	EXPECT_ERRNO(ENOENT, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
+
+	/* Valid id for set*/
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_ALLOC, &alloc_cmd));
+	vfio_ioas_cmd.ioas_id = alloc_cmd.out_ioas_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
+
+	/* Same id comes back from get */
+	vfio_ioas_cmd.op = IOMMU_VFIO_IOAS_GET;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
+	ASSERT_EQ(alloc_cmd.out_ioas_id, vfio_ioas_cmd.ioas_id);
+
+	/* Clear works */
+	vfio_ioas_cmd.op = IOMMU_VFIO_IOAS_CLEAR;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
+	vfio_ioas_cmd.op = IOMMU_VFIO_IOAS_GET;
+	EXPECT_ERRNO(ENODEV, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
+}
+
+FIXTURE(vfio_compat_mock_domain) {
+	int fd;
+	uint32_t ioas_id;
+};
+
+FIXTURE_SETUP(vfio_compat_mock_domain) {
+	struct iommu_ioas_alloc alloc_cmd = {
+		.size = sizeof(alloc_cmd),
+	};
+	struct iommu_test_cmd test_cmd = {
+		.size = sizeof(test_cmd),
+		.op = IOMMU_TEST_OP_MOCK_DOMAIN,
+	};
+	struct iommu_vfio_ioas vfio_ioas_cmd = {
+		.size = sizeof(vfio_ioas_cmd),
+		.op = IOMMU_VFIO_IOAS_SET,
+	};
+
+	self->fd = open("/dev/iommu", O_RDWR);
+	ASSERT_NE(-1, self->fd);
+
+	/* Create what VFIO would consider a group */
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_ALLOC, &alloc_cmd));
+	ASSERT_NE(0, alloc_cmd.out_ioas_id);
+	self->ioas_id = alloc_cmd.out_ioas_id;
+	test_cmd.id = self->ioas_id;
+	ASSERT_EQ(0, ioctl(self->fd,
+			   _IOMMU_TEST_CMD(IOMMU_TEST_OP_MOCK_DOMAIN),
+			   &test_cmd));
+	EXPECT_NE(0, test_cmd.id);
+
+	/* Attach it to the vfio compat */
+	vfio_ioas_cmd.ioas_id = self->ioas_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
+	ASSERT_EQ(0, ioctl(self->fd, VFIO_SET_IOMMU, VFIO_TYPE1v2_IOMMU));
+}
+
+FIXTURE_TEARDOWN(vfio_compat_mock_domain) {
+	ASSERT_EQ(0, close(self->fd));
+
+	self->fd = open("/dev/iommu", O_RDWR);
+	ASSERT_NE(-1, self->fd);
+	check_refs(buffer, BUFFER_SIZE, 0);
+	ASSERT_EQ(0, close(self->fd));
+}
+
+TEST_F(vfio_compat_mock_domain, simple_close)
+{
+}
+
+/*
+ * Execute an ioctl command stored in buffer and check that the result does not
+ * overflow memory.
+ */
+static bool is_filled(const void *buf, uint8_t c, size_t len)
+{
+	const uint8_t *cbuf = buf;
+
+	for (; len; cbuf++, len--)
+		if (*cbuf != c)
+			return false;
+	return true;
+}
+
+#define ioctl_check_buf(fd, cmd)                                               \
+	({                                                                     \
+		size_t _cmd_len = *(__u32 *)buffer;                            \
+									       \
+		memset(buffer + _cmd_len, 0xAA, BUFFER_SIZE - _cmd_len);       \
+		ASSERT_EQ(0, ioctl(fd, cmd, buffer));                          \
+		ASSERT_EQ(true, is_filled(buffer + _cmd_len, 0xAA,             \
+					  BUFFER_SIZE - _cmd_len));            \
+	})
+
+static void check_vfio_info_cap_chain(struct __test_metadata *_metadata,
+				      struct vfio_iommu_type1_info *info_cmd)
+{
+	const struct vfio_info_cap_header *cap;
+
+	ASSERT_GE(info_cmd->argsz, info_cmd->cap_offset + sizeof(*cap));
+	cap = buffer + info_cmd->cap_offset;
+	while (true) {
+		size_t cap_size;
+
+		if (cap->next)
+			cap_size = (buffer + cap->next) - (void *)cap;
+		else
+			cap_size = (buffer + info_cmd->argsz) - (void *)cap;
+
+		switch (cap->id) {
+		case VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE: {
+			struct vfio_iommu_type1_info_cap_iova_range *data =
+				(void *)cap;
+
+			ASSERT_EQ(1, data->header.version);
+			ASSERT_EQ(1, data->nr_iovas);
+			EXPECT_EQ(MOCK_APERTURE_START,
+				  data->iova_ranges[0].start);
+			EXPECT_EQ(MOCK_APERTURE_LAST,
+				  data->iova_ranges[0].end);
+			break;
+		}
+		case VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL: {
+			struct vfio_iommu_type1_info_dma_avail *data =
+				(void *)cap;
+
+			ASSERT_EQ(1, data->header.version);
+			ASSERT_EQ(sizeof(*data), cap_size);
+			break;
+		}
+		default:
+			ASSERT_EQ(false, true);
+			break;
+		}
+		if (!cap->next)
+			break;
+
+		ASSERT_GE(info_cmd->argsz, cap->next + sizeof(*cap));
+		ASSERT_GE(buffer + cap->next, (void *)cap);
+		cap = buffer + cap->next;
+	}
+}
+
+TEST_F(vfio_compat_mock_domain, get_info)
+{
+	struct vfio_iommu_type1_info *info_cmd = buffer;
+	unsigned int i;
+	size_t caplen;
+
+	/* Pre-cap ABI */
+	*info_cmd = (struct vfio_iommu_type1_info){
+		.argsz = offsetof(struct vfio_iommu_type1_info, cap_offset),
+	};
+	ioctl_check_buf(self->fd, VFIO_IOMMU_GET_INFO);
+	ASSERT_NE(0, info_cmd->iova_pgsizes);
+	ASSERT_EQ(VFIO_IOMMU_INFO_PGSIZES | VFIO_IOMMU_INFO_CAPS,
+		  info_cmd->flags);
+
+	/* Read the cap chain size */
+	*info_cmd = (struct vfio_iommu_type1_info){
+		.argsz = sizeof(*info_cmd),
+	};
+	ioctl_check_buf(self->fd, VFIO_IOMMU_GET_INFO);
+	ASSERT_NE(0, info_cmd->iova_pgsizes);
+	ASSERT_EQ(VFIO_IOMMU_INFO_PGSIZES | VFIO_IOMMU_INFO_CAPS,
+		  info_cmd->flags);
+	ASSERT_EQ(0, info_cmd->cap_offset);
+	ASSERT_LT(sizeof(*info_cmd), info_cmd->argsz);
+
+	/* Read the caps, kernel should never create a corrupted caps */
+	caplen = info_cmd->argsz;
+	for (i = sizeof(*info_cmd); i < caplen; i++) {
+		*info_cmd = (struct vfio_iommu_type1_info){
+			.argsz = i,
+		};
+		ioctl_check_buf(self->fd, VFIO_IOMMU_GET_INFO);
+		ASSERT_EQ(VFIO_IOMMU_INFO_PGSIZES | VFIO_IOMMU_INFO_CAPS,
+			  info_cmd->flags);
+		if (!info_cmd->cap_offset)
+			continue;
+		check_vfio_info_cap_chain(_metadata, info_cmd);
+	}
+}
+
+/* FIXME use fault injection to test memory failure paths */
+/* FIXME test VFIO_IOMMU_MAP_DMA */
+/* FIXME test VFIO_IOMMU_UNMAP_DMA */
+/* FIXME test 2k iova alignment */
+
+TEST_HARNESS_MAIN
-- 
2.35.1

