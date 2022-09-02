Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB4E5AB920
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 22:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiIBUAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 16:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiIBT7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:59:49 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5EF2F3BC
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:59:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1is4ZsctryPocb4iLe7OgmUSyOdvW0Lwbr/CHUcc3WjkDxrjcgcKjQMAGG1PB6TNTg26g+Ut5H+E+QueOtlZu+h3mTefZ5Rrofv/g+iGh2AdTHKvZyvjmcAYZNz1B7B2ZXvGAovGKIti4vrjLE1MRsM8egpPZF9/gflhRbVgY/mcrn22uqbShYeR7oVdQsy0TN3lYjMgHc7d0pf1fjDwI5XIGvF40MzjsugReoQHnXR6pzwm7iepvwWgl5u9F8lWEwhefFTzUj2swAJGA+LFU8ZWcYQTzOuMXihIgOG7kOU1+4rtGgtMRU5aAkGwIgoj4qlhFSc7lQcIDf0PaTm6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQAW2l0fAIN3ZWyMFHNs3Xu6nHDr4oFFNWRK5RaOa4M=;
 b=A8Sl21YoWVmFKocCmZohk3uuoDOJNswBsRykvOqzQwZGcV9xPYOo5jh99tl0B4U4SqmoQ3HMuSIBjMerZr34sFS/+5yxLRr7DnuvFdG1KT/34zxYpx1FFLRSXTsYgC7qWrnPfbhLvdBWJt0Snq0cE/HM3w5WGNoGrkH822OXgISbzhSYDuKGeRuxRN37aO5T0EQTtF6uyE3ToY1Hl1hvc7wlM3XpdYCcrhBdDXF1BKJ13/Vd0sVPCzEygl8k4K/OXxEMD1IQYhu4edgLPb5gwE4fcwXsB0wF7dreT/YILu0dHNmtO/m00i6gNNPv5/8NfD4+XAVgQNvR21e5AXcgmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQAW2l0fAIN3ZWyMFHNs3Xu6nHDr4oFFNWRK5RaOa4M=;
 b=T15VMMwy6YdPzutD6JHdFFfklsUxpNR9xLSOtTuSPjCXr6G8yFkcErxhMEy/1llai5ne8xrJxN6tk17BhqqvR712jBh1M+w39HBDzyUziUrFr1SDZEMZrVu1f3KSnA3Ua7eiYMCSuJ7A1Qt1C6OqoE2WLzs1zw9wrIy1vmT+ZIWlS8/VssF/DNbt8hEmON6fVmyuyNemliLIzIbY0Et+VxXvxLVfyMj4Os74Vc86Xi3AIodL203AmdNziSqp7KnEUo69Ilt+T5kH/tkt6L/U6n7Tli1nTOMx1FNeBq4VLo70KTRK8zEcloP4b+ekCicE21BSvd2s9Ocy1Ztl8MRGfA==
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
 19:59:36 +0000
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
Subject: [PATCH RFC v2 13/13] iommufd: Add a selftest
Date:   Fri,  2 Sep 2022 16:59:29 -0300
Message-Id: <13-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0031.namprd19.prod.outlook.com
 (2603:10b6:208:178::44) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6874ebd5-f262-4293-b9fb-08da8d1da6c2
X-MS-TrafficTypeDiagnostic: PH7PR12MB6883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VT/LhazVpbb16J2opWK4V41x1ie9O4/f3tXG350qzqSm9+EF0/l6WmJ/4nhL/BD7lvwOg2mSaHa8JYM4x9mveVjAXH2aaVZENTpjVew8jY7RdRfF1+1qyGg+z+4uAod/XWg2b/I9QK7oyftomB/E09qHBSRv3/6vLHLbBt8qjGoytPSGdS5FohJtzvNOcSY7htIEBiPWGIVk6zuqpAEm6VhBUzDZAM5aQxenb/Ws1/N8LPhktySri1Kr8xVub/mcDgyB4vwiD+v+uusqU8jFjiUTDhlLseTs3YFHBjEpKaluIsjYF8WB1USZ8RfuEPXU3MHuuOs1OLHsi5w5ich0ehD8+TwWCMwjz7isXEdyuHSemCGfJEHPTgFMY9yjN9uNa1/GZbPDyvslwSNrMZfeRfkXAhAHTuyJR1fBK3a/oSUS73gaVKuKBjukP7cm3YF7W0/pqlch3c+DlnH2pOnkQZ83ar62JXL2mjZJpVcdWrqMikO0RTVbRPTa5gp//2LPvfwarBjm3l9LfdRejJpmDxdJ5QHMZIuCu0R1EFsFAE++E+3UvJFb7bSj2F30+Z2jBms5OnFC3EzzbkLIX1Wvzp4j0C9tsPOU7dHJWbM+13W49dNy52o89I9JEnk6kLr15PrDCavWzmt+vdDb+MV/wJKlztvuiodHXC8DThtzgetr7PxDLuH8Miq5079RIzapOY4nrNh89lackqUpdowGRNgKjaSvC/4YQ+2WjWS9lrodtj1uhk38ScgXivsfoUYj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(6666004)(4326008)(30864003)(66946007)(66476007)(66556008)(316002)(7416002)(54906003)(6506007)(26005)(478600001)(109986005)(6512007)(41300700001)(6486002)(38100700002)(86362001)(8676002)(186003)(2616005)(2906002)(5660300002)(8936002)(36756003)(83380400001)(266003)(579004)(559001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eyn9zIbCFqvq+tHB9DcbaV16kz35+zgxt40xl+Z8k16oYlQ/6yvJe1c4m43v?=
 =?us-ascii?Q?KaQt0bk/zTl+82fAFyn38xAYuh8g0vYry4q5mwBNwGbmRQrGPO/DpQ892X7r?=
 =?us-ascii?Q?3keFiiUiE2bMTrlHKfaaullGns6c4drIwXDKTa4abmfIpvnS1x6ehQUikhLI?=
 =?us-ascii?Q?OZk3NV/SGWZoD9m0JKPeo57HE+FENE9NGbyLG10ZKGsrTsN6LCFMcxGgZCM2?=
 =?us-ascii?Q?KsgSklYUth6r+5LDTcDotjl4XRHzf1kcyvGarirRTMGFpbw7korPfpwJRXLW?=
 =?us-ascii?Q?xnfty0jNVHOaibTiJWycIMfXqx2qIihtJ2r0FkPzExu76TWJJ8tvwVSYDhJr?=
 =?us-ascii?Q?xYKB3bHrGcUtm5R63xjsv+eof4B/51N1Fgs1EIGrRIW7crDO9+K3eKE0B19+?=
 =?us-ascii?Q?VEYO4jD7gMCDFEibhS7bhK08p/+fPWgkAW8Lxz1nQdbSSBxSyMP+Vd3uOr9L?=
 =?us-ascii?Q?jwYjqdzWxfpAlRVyqOVK2Q3QIZZ9PgWNfiwoeL0SDEzmJnQ3EtDTHXhbqGbh?=
 =?us-ascii?Q?wGk9j4mDKdEpDal9IgKBt91/zt0IRJY8Nl3AS4+4PBDmCecPAsoolbCbZ0Jj?=
 =?us-ascii?Q?jOeUwf3EdVRJGomsgtpzc0Kfa+ZIsvIhL7TQyxdqV1Z5z9AhqVhVCckzNVfv?=
 =?us-ascii?Q?krh+nT7e/Ta10MeIaU02vIb1uC2zkfc8JMVRRu+8M6dNBpb9qS8pY36kTre8?=
 =?us-ascii?Q?Cgabqy7dq6dt2ITRzwK5vYcCUmoa2BJCW57QMuk1vuVt4ZH3W0IrndtKNFhd?=
 =?us-ascii?Q?OwfSBi5OAtTpUoKlRFIfmkZPzf/583fmLf6iMTxCMnB5p+cIe+cFrlwpAPKV?=
 =?us-ascii?Q?vTf0eKedjsfkGKMYtm9g7tpcd0ry33+145s8p3feWuzVqMBtnAFIAMHQGwAC?=
 =?us-ascii?Q?dbADok+VIiIJzKE9zVGRvxK+NOadQCyZT2B67uTkP27ywXkDm+EycR3ccfVq?=
 =?us-ascii?Q?isw6EjbVoA4Q4Ri+jnKketufDEGUT1buhKmfdJciWKUI9WPUp+YDCdbiPx5S?=
 =?us-ascii?Q?eF+MAal7qVXEaVCWKRjSKGUsDMgYP+eeKm0+hLNJmVFY0i7REM9DI/OjAEaL?=
 =?us-ascii?Q?X8psqWaon376ZyH81Rzil8NjYf6A4Uc0d0QLP7lZeE7ATEcxfZpR/t+BqUue?=
 =?us-ascii?Q?gOvYWLHRq2xRz7ZIIXE25rtoIBDbUSxCT1UQ+hB+yaqX7Cxr4OSKe1/M8sML?=
 =?us-ascii?Q?ndQvnTVeddDFZVBm2m/tSU5/uxBynpg+o/5DrPYz+WUBsTxo9xJdS3ux80Oh?=
 =?us-ascii?Q?gF9rdj0Y9PwLOrsse0V+VwMdwZ7V/wCO6L+Tj+RJJwGNnIPFRktOGSg+jdV1?=
 =?us-ascii?Q?IDa+fxrOYwBfyPKW3HF+FWggd0tDYb8Qt9yTqlngQt7FzqNxN1+wWYTz5imy?=
 =?us-ascii?Q?wxPl5Bcz8zPnxfvdJE4MrWOb8tMh5xpInvIjsIBEX0vk2itDTDyiev+w6bIB?=
 =?us-ascii?Q?1rvezVKWY762BjacoOCC45sSPXtIJdljzsgLT4cduLrE3e/coQQjlMApeBIB?=
 =?us-ascii?Q?pN4x5E8x874QYuTnOqkI6lxpU9hSnvDP1paYhYrWmrg0/H6SFFthW93F7B0p?=
 =?us-ascii?Q?P2/oTMHtWZs/UJfiMv7iyMt7dN2aLKcJLly/hRRh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6874ebd5-f262-4293-b9fb-08da8d1da6c2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 19:59:32.0193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TrYSlb7SU1Nw7/VauPDnG8PNGdMVJIC0nkBLg0sD7OtVNHIlE8qbTgVlIcq2x6u6
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
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/Kconfig            |    9 +
 drivers/iommu/iommufd/Makefile           |    2 +
 drivers/iommu/iommufd/device.c           |   61 +
 drivers/iommu/iommufd/iommufd_private.h  |   21 +
 drivers/iommu/iommufd/iommufd_test.h     |   74 ++
 drivers/iommu/iommufd/main.c             |   12 +
 drivers/iommu/iommufd/pages.c            |    4 +
 drivers/iommu/iommufd/selftest.c         |  626 ++++++++++
 tools/testing/selftests/Makefile         |    1 +
 tools/testing/selftests/iommu/.gitignore |    2 +
 tools/testing/selftests/iommu/Makefile   |   11 +
 tools/testing/selftests/iommu/config     |    2 +
 tools/testing/selftests/iommu/iommufd.c  | 1396 ++++++++++++++++++++++
 13 files changed, 2221 insertions(+)
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
diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index d34bdbcb84a40d..7e6ddf82f34cb9 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -517,3 +517,64 @@ int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
 	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(iommufd_access_rw);
+
+#ifdef CONFIG_IOMMUFD_TEST
+/*
+ * Creating a real iommufd_device is too hard, bypass creating a iommufd_device
+ * and go directly to attaching a domain.
+ */
+struct iommufd_hw_pagetable *
+iommufd_device_selftest_attach(struct iommufd_ctx *ictx,
+			       struct iommufd_ioas *ioas,
+			       struct device *mock_dev)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	int rc;
+
+	hwpt = iommufd_hw_pagetable_alloc(ictx, ioas, mock_dev);
+	if (IS_ERR(hwpt))
+		return hwpt;
+
+	rc = iopt_table_add_domain(&hwpt->ioas->iopt, hwpt->domain);
+	if (rc)
+		goto out_hwpt;
+
+	refcount_inc(&hwpt->obj.users);
+	iommufd_object_finalize(ictx, &hwpt->obj);
+	return hwpt;
+
+out_hwpt:
+	iommufd_object_abort_and_destroy(ictx, &hwpt->obj);
+	return ERR_PTR(rc);
+}
+
+void iommufd_device_selftest_detach(struct iommufd_ctx *ictx,
+				    struct iommufd_hw_pagetable *hwpt)
+{
+	iopt_table_remove_domain(&hwpt->ioas->iopt, hwpt->domain);
+	refcount_dec(&hwpt->obj.users);
+}
+
+unsigned int iommufd_access_selfest_id(struct iommufd_access *access_pub)
+{
+	struct iommufd_access_priv *access =
+		container_of(access_pub, struct iommufd_access_priv, pub);
+
+	return access->obj.id;
+}
+
+void *iommufd_access_selftest_get(struct iommufd_ctx *ictx,
+				  unsigned int access_id,
+				  struct iommufd_object **out_obj)
+{
+	struct iommufd_object *access_obj;
+
+	access_obj =
+		iommufd_get_object(ictx, access_id, IOMMUFD_OBJ_ACCESS);
+	if (IS_ERR(access_obj))
+		return ERR_CAST(access_obj);
+	*out_obj = access_obj;
+	return container_of(access_obj, struct iommufd_access_priv, obj)->data;
+}
+
+#endif
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index d87227cc08a47d..0b414b6a00f061 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -103,6 +103,9 @@ enum iommufd_object_type {
 	IOMMUFD_OBJ_HW_PAGETABLE,
 	IOMMUFD_OBJ_IOAS,
 	IOMMUFD_OBJ_ACCESS,
+#ifdef CONFIG_IOMMUFD_TEST
+	IOMMUFD_OBJ_SELFTEST,
+#endif
 };
 
 /* Base struct for all objects with a userspace ID handle. */
@@ -242,4 +245,22 @@ void iommufd_hw_pagetable_destroy(struct iommufd_object *obj);
 void iommufd_device_destroy(struct iommufd_object *obj);
 
 void iommufd_access_destroy_object(struct iommufd_object *obj);
+
+#ifdef CONFIG_IOMMUFD_TEST
+struct iommufd_access;
+struct iommufd_hw_pagetable *
+iommufd_device_selftest_attach(struct iommufd_ctx *ictx,
+			       struct iommufd_ioas *ioas,
+			       struct device *mock_dev);
+void iommufd_device_selftest_detach(struct iommufd_ctx *ictx,
+				    struct iommufd_hw_pagetable *hwpt);
+unsigned int iommufd_access_selfest_id(struct iommufd_access *access_pub);
+void *iommufd_access_selftest_get(struct iommufd_ctx *ictx,
+				  unsigned int access_id,
+				  struct iommufd_object **out_obj);
+int iommufd_test(struct iommufd_ucmd *ucmd);
+void iommufd_selftest_destroy(struct iommufd_object *obj);
+extern size_t iommufd_test_memory_limit;
+#endif
+
 #endif
diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
new file mode 100644
index 00000000000000..485f44394dbe9b
--- /dev/null
+++ b/drivers/iommu/iommufd/iommufd_test.h
@@ -0,0 +1,74 @@
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
+	IOMMU_TEST_OP_CREATE_ACCESS,
+	IOMMU_TEST_OP_DESTROY_ACCESS,
+	IOMMU_TEST_OP_DESTROY_ACCESS_ITEM,
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
+			__u32 out_access_id;
+		} create_access;
+		struct {
+			__u32 flags;
+			__u32 out_access_item_id;
+			__aligned_u64 iova;
+			__aligned_u64 length;
+			__aligned_u64 uptr;
+		} access_pages;
+		struct {
+			__u32 access_item_id;
+		} destroy_access_item;
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
index 549d6a4c8f5575..1097e5f07f8eb9 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -25,6 +25,7 @@
 #include <linux/iommufd.h>
 
 #include "iommufd_private.h"
+#include "iommufd_test.h"
 
 struct iommufd_object_ops {
 	void (*destroy)(struct iommufd_object *obj);
@@ -211,6 +212,9 @@ union ucmd_buffer {
 	struct iommu_ioas_iova_ranges iova_ranges;
 	struct iommu_ioas_map map;
 	struct iommu_ioas_unmap unmap;
+#ifdef CONFIG_IOMMUFD_TEST
+	struct iommu_test_cmd test;
+#endif
 };
 
 struct iommufd_ioctl_op {
@@ -245,6 +249,9 @@ static struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 length),
 	IOCTL_OP(IOMMU_VFIO_IOAS, iommufd_vfio_ioas, struct iommu_vfio_ioas,
 		 __reserved),
+#ifdef CONFIG_IOMMUFD_TEST
+	IOCTL_OP(IOMMU_TEST_CMD, iommufd_test, struct iommu_test_cmd, last),
+#endif
 };
 
 static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
@@ -345,6 +352,11 @@ static struct iommufd_object_ops iommufd_object_ops[] = {
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
index 91db42dd6aaeaa..59a55f0a35b2af 100644
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
index 00000000000000..e9c178048a1284
--- /dev/null
+++ b/drivers/iommu/iommufd/selftest.c
@@ -0,0 +1,626 @@
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
+	TYPE_IDEV,
+};
+
+struct selftest_obj {
+	struct iommufd_object obj;
+	enum selftest_obj_type type;
+
+	union {
+		struct {
+			struct iommufd_hw_pagetable *hwpt;
+			struct iommufd_ctx *ictx;
+			struct device mock_dev;
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
+	static struct bus_type mock_bus = { .iommu_ops = &mock_ops };
+	struct iommufd_hw_pagetable *hwpt;
+	struct selftest_obj *sobj;
+	struct iommufd_ioas *ioas;
+	int rc;
+
+	ioas = iommufd_get_ioas(ucmd, cmd->id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	sobj = iommufd_object_alloc(ucmd->ictx, sobj, IOMMUFD_OBJ_SELFTEST);
+	if (IS_ERR(sobj)) {
+		rc = PTR_ERR(sobj);
+		goto out_ioas;
+	}
+	sobj->idev.ictx = ucmd->ictx;
+	sobj->type = TYPE_IDEV;
+	sobj->idev.mock_dev.bus = &mock_bus;
+
+	hwpt = iommufd_device_selftest_attach(ucmd->ictx, ioas,
+					      &sobj->idev.mock_dev);
+	if (IS_ERR(hwpt)) {
+		rc = PTR_ERR(hwpt);
+		goto out_sobj;
+	}
+	sobj->idev.hwpt = hwpt;
+
+	cmd->id = hwpt->obj.id;
+	cmd->mock_domain.device_id = sobj->obj.id;
+	iommufd_object_finalize(ucmd->ictx, &sobj->obj);
+	iommufd_put_object(&ioas->obj);
+	return iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+
+out_sobj:
+	iommufd_object_abort(ucmd->ictx, &sobj->obj);
+out_ioas:
+	iommufd_put_object(&ioas->obj);
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
+struct selftest_access {
+	struct iommufd_access *access;
+	spinlock_t lock;
+	struct list_head items;
+	unsigned int next_id;
+	bool destroying;
+};
+
+struct selftest_access_item {
+	struct list_head items_elm;
+	unsigned long iova;
+	unsigned long iova_end;
+	size_t length;
+	unsigned int id;
+};
+
+static void iommufd_test_access_unmap(void *data, unsigned long iova,
+				      unsigned long length)
+{
+	struct selftest_access *staccess = data;
+	struct selftest_access_item *item;
+	unsigned long iova_end = iova + length - 1;
+
+	spin_lock(&staccess->lock);
+	list_for_each_entry(item, &staccess->items, items_elm) {
+		if (iova <= item->iova_end && iova_end >= item->iova) {
+			list_del(&item->items_elm);
+			spin_unlock(&staccess->lock);
+			iommufd_access_unpin_pages(staccess->access, item->iova,
+						   item->length);
+			kfree(item);
+			return;
+		}
+	}
+	spin_unlock(&staccess->lock);
+}
+
+static struct iommufd_access_ops selftest_access_ops = {
+	.unmap = iommufd_test_access_unmap,
+};
+
+static int iommufd_test_create_access(struct iommufd_ucmd *ucmd,
+				      unsigned int ioas_id)
+{
+	struct iommu_test_cmd *cmd = ucmd->cmd;
+	struct selftest_access *staccess;
+	int rc;
+
+	staccess = kzalloc(sizeof(*staccess), GFP_KERNEL_ACCOUNT);
+	if (!staccess)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&staccess->items);
+	spin_lock_init(&staccess->lock);
+
+	staccess->access = iommufd_access_create(
+		ucmd->ictx, ioas_id, &selftest_access_ops, staccess);
+	if (IS_ERR(staccess->access)) {
+		rc = PTR_ERR(staccess->access);
+		goto out_free;
+	}
+	cmd->create_access.out_access_id =
+		iommufd_access_selfest_id(staccess->access);
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+	if (rc)
+		goto out_destroy;
+
+	return 0;
+
+out_destroy:
+	iommufd_access_destroy(staccess->access);
+out_free:
+	kfree(staccess);
+	return rc;
+}
+
+static int iommufd_test_destroy_access(struct iommufd_ucmd *ucmd,
+				       unsigned int access_id)
+{
+	struct selftest_access *staccess;
+	struct iommufd_object *access_obj;
+
+	staccess =
+		iommufd_access_selftest_get(ucmd->ictx, access_id, &access_obj);
+	if (IS_ERR(staccess))
+		return PTR_ERR(staccess);
+	iommufd_put_object(access_obj);
+
+	spin_lock(&staccess->lock);
+	if (!list_empty(&staccess->items) || staccess->destroying) {
+		spin_unlock(&staccess->lock);
+		return -EBUSY;
+	}
+	staccess->destroying = true;
+	spin_unlock(&staccess->lock);
+
+	/* FIXME: this holds a reference on the object even after the fd is closed */
+	iommufd_access_destroy(staccess->access);
+	kfree(staccess);
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
+static int iommufd_test_access_pages(struct iommufd_ucmd *ucmd,
+				     unsigned int access_id, unsigned long iova,
+				     size_t length, void __user *uptr,
+				     u32 flags)
+{
+	struct iommu_test_cmd *cmd = ucmd->cmd;
+	struct iommufd_object *access_obj;
+	struct selftest_access_item *item;
+	struct selftest_access *staccess;
+	struct page **pages;
+	size_t npages;
+	int rc;
+
+	if (flags & ~MOCK_FLAGS_ACCESS_WRITE)
+		return -EOPNOTSUPP;
+
+	staccess =
+		iommufd_access_selftest_get(ucmd->ictx, access_id, &access_obj);
+	if (IS_ERR(staccess))
+		return PTR_ERR(staccess);
+
+	npages = (ALIGN(iova + length, PAGE_SIZE) -
+		  ALIGN_DOWN(iova, PAGE_SIZE)) /
+		 PAGE_SIZE;
+	pages = kvcalloc(npages, sizeof(*pages), GFP_KERNEL_ACCOUNT);
+	if (!pages) {
+		rc = -ENOMEM;
+		goto out_put;
+	}
+
+	rc = iommufd_access_pin_pages(staccess->access, iova, length, pages,
+				      flags & MOCK_FLAGS_ACCESS_WRITE);
+	if (rc)
+		goto out_free_pages;
+
+	rc = iommufd_test_check_pages(
+		uptr - (iova - ALIGN_DOWN(iova, PAGE_SIZE)), pages, npages);
+	if (rc)
+		goto out_unaccess;
+
+	item = kzalloc(sizeof(*item), GFP_KERNEL_ACCOUNT);
+	if (!item) {
+		rc = -ENOMEM;
+		goto out_unaccess;
+	}
+
+	item->iova = iova;
+	item->length = length;
+	spin_lock(&staccess->lock);
+	item->id = staccess->next_id++;
+	list_add_tail(&item->items_elm, &staccess->items);
+	spin_unlock(&staccess->lock);
+
+	cmd->access_pages.out_access_item_id = item->id;
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+	if (rc)
+		goto out_free_item;
+	goto out_free_pages;
+
+out_free_item:
+	spin_lock(&staccess->lock);
+	list_del(&item->items_elm);
+	spin_unlock(&staccess->lock);
+	kfree(item);
+out_unaccess:
+	iommufd_access_unpin_pages(staccess->access, iova, length);
+out_free_pages:
+	kvfree(pages);
+out_put:
+	iommufd_put_object(access_obj);
+	return rc;
+}
+
+static int iommufd_test_access_item_destroy(struct iommufd_ucmd *ucmd,
+					    unsigned int access_id,
+					    unsigned int item_id)
+{
+	struct iommufd_object *access_obj;
+	struct selftest_access_item *item;
+	struct selftest_access *staccess;
+
+	staccess =
+		iommufd_access_selftest_get(ucmd->ictx, access_id, &access_obj);
+	if (IS_ERR(staccess))
+		return PTR_ERR(staccess);
+
+	spin_lock(&staccess->lock);
+	list_for_each_entry(item, &staccess->items, items_elm) {
+		if (item->id == item_id) {
+			list_del(&item->items_elm);
+			spin_unlock(&staccess->lock);
+			iommufd_access_unpin_pages(staccess->access, item->iova,
+						   item->length);
+			kfree(item);
+			iommufd_put_object(access_obj);
+			return 0;
+		}
+	}
+	spin_unlock(&staccess->lock);
+	iommufd_put_object(access_obj);
+	return -ENOENT;
+}
+
+void iommufd_selftest_destroy(struct iommufd_object *obj)
+{
+	struct selftest_obj *sobj = container_of(obj, struct selftest_obj, obj);
+
+	switch (sobj->type) {
+	case TYPE_IDEV:
+		iommufd_device_selftest_detach(sobj->idev.ictx,
+					       sobj->idev.hwpt);
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
+	case IOMMU_TEST_OP_CREATE_ACCESS:
+		return iommufd_test_create_access(ucmd, cmd->id);
+	case IOMMU_TEST_OP_DESTROY_ACCESS:
+		return iommufd_test_destroy_access(ucmd, cmd->id);
+	case IOMMU_TEST_OP_ACCESS_PAGES:
+		return iommufd_test_access_pages(
+			ucmd, cmd->id, cmd->access_pages.iova,
+			cmd->access_pages.length,
+			u64_to_user_ptr(cmd->access_pages.uptr),
+			cmd->access_pages.flags);
+	case IOMMU_TEST_OP_DESTROY_ACCESS_ITEM:
+		return iommufd_test_access_item_destroy(
+			ucmd, cmd->id, cmd->destroy_access_item.access_item_id);
+	case IOMMU_TEST_OP_SET_TEMP_MEMORY_LIMIT:
+		iommufd_test_memory_limit = cmd->memory_limit.limit;
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index c2064a35688b08..58a8520542410b 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -25,6 +25,7 @@ TARGETS += ftrace
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
index 00000000000000..9aea459ba183ec
--- /dev/null
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -0,0 +1,1396 @@
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
+/* Hack to make assertions more readable */
+#define _IOMMU_TEST_CMD(x) IOMMU_TEST_CMD
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
+static int _test_cmd_create_access(int fd, unsigned int ioas_id,
+				   __u32 *access_id)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd),
+		.op = IOMMU_TEST_OP_CREATE_ACCESS,
+		.id = ioas_id,
+	};
+	int ret;
+
+	ret = ioctl(fd, IOMMU_TEST_CMD, &cmd);
+	if (ret)
+		return ret;
+	*access_id = cmd.create_access.out_access_id;
+	return 0;
+}
+#define test_cmd_create_access(ioas_id, access_id) \
+	ASSERT_EQ(0, _test_cmd_create_access(self->fd, ioas_id, access_id))
+
+static int _test_cmd_destroy_access(int fd, unsigned int access_id)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd),
+		.op = IOMMU_TEST_OP_DESTROY_ACCESS,
+		.id = access_id,
+	};
+	return ioctl(fd, IOMMU_TEST_CMD, &cmd);
+}
+#define test_cmd_destroy_access(access_id) \
+	ASSERT_EQ(0, _test_cmd_destroy_access(self->fd, access_id))
+
+static int _test_cmd_destroy_access_item(int fd, unsigned int access_id,
+					 unsigned int access_item_id)
+{
+	struct iommu_test_cmd cmd = {
+		.size = sizeof(cmd),
+		.op = IOMMU_TEST_OP_DESTROY_ACCESS_ITEM,
+		.id = access_id,
+		.destroy_access_item = { .access_item_id = access_item_id },
+	};
+	return ioctl(fd, IOMMU_TEST_CMD, &cmd);
+}
+#define test_cmd_destroy_access_item(access_id, access_item_id)         \
+	ASSERT_EQ(0, _test_cmd_destroy_access_item(self->fd, access_id, \
+						   access_item_id))
+
+static int _test_ioctl_destroy(int fd, unsigned int id)
+{
+	struct iommu_destroy cmd = {
+		.size = sizeof(cmd),
+		.id = id,
+	};
+	return ioctl(fd, IOMMU_DESTROY, &cmd);
+}
+#define test_ioctl_destroy(id) \
+	ASSERT_EQ(0, _test_ioctl_destroy(self->fd, id))
+
+static int _test_ioctl_ioas_alloc(int fd, __u32 *id)
+{
+	struct iommu_ioas_alloc cmd = {
+		.size = sizeof(cmd),
+	};
+	int ret;
+
+	ret = ioctl(fd, IOMMU_IOAS_ALLOC, &cmd);
+	if (ret)
+		return ret;
+	*id = cmd.out_ioas_id;
+	return 0;
+}
+#define test_ioctl_ioas_alloc(id)                                   \
+	({                                                          \
+		ASSERT_EQ(0, _test_ioctl_ioas_alloc(self->fd, id)); \
+		ASSERT_NE(0, *(id));                                \
+	})
+
+static void teardown_iommufd(int fd, struct __test_metadata *_metadata)
+{
+	struct iommu_test_cmd test_cmd = {
+		.size = sizeof(test_cmd),
+		.op = IOMMU_TEST_OP_MD_CHECK_REFS,
+		.check_refs = { .length = BUFFER_SIZE,
+				.uptr = (uintptr_t)buffer },
+	};
+
+	EXPECT_EQ(0, close(fd));
+
+	fd = open("/dev/iommu", O_RDWR);
+	EXPECT_NE(-1, fd);
+	EXPECT_EQ(0, ioctl(fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_MD_CHECK_REFS),
+			   &test_cmd));
+	EXPECT_EQ(0, close(fd));
+}
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
+	teardown_iommufd(self->fd, _metadata);
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
+	unsigned int i;
+
+	if (!variant->memory_limit)
+		memlimit_cmd.memory_limit.limit = 65536;
+
+	self->fd = open("/dev/iommu", O_RDWR);
+	ASSERT_NE(-1, self->fd);
+	test_ioctl_ioas_alloc(&self->ioas_id);
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
+	EXPECT_EQ(0, ioctl(self->fd,
+			   _IOMMU_TEST_CMD(IOMMU_TEST_OP_SET_TEMP_MEMORY_LIMIT),
+			   &memlimit_cmd));
+	teardown_iommufd(self->fd, _metadata);
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
+		test_ioctl_destroy(self->ioas_id);
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
+		test_ioctl_destroy(self->ioas_id);
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
+TEST_F(iommufd_ioas, unmap_fully_contained_areas)
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
+	/* Give no_domain some space to rewind base_iova */
+	self->base_iova += 4 * PAGE_SIZE;
+
+	for (i = 0; i != 4; i++) {
+		map_cmd.iova = self->base_iova + i * 16 * PAGE_SIZE;
+		map_cmd.length = 8 * PAGE_SIZE;
+		ASSERT_EQ(0,
+			  ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	}
+
+	/* Unmap not fully contained area doesn't work */
+	unmap_cmd.iova = self->base_iova - 4 * PAGE_SIZE;
+	unmap_cmd.length = 8 * PAGE_SIZE;
+	EXPECT_ERRNO(ENOENT,
+		     ioctl(self->fd, IOMMU_IOAS_UNMAP, &unmap_cmd));
+
+	unmap_cmd.iova = self->base_iova + 3 * 16 * PAGE_SIZE + 8 * PAGE_SIZE - 4 * PAGE_SIZE;
+	unmap_cmd.length = 8 * PAGE_SIZE;
+	EXPECT_ERRNO(ENOENT,
+		     ioctl(self->fd, IOMMU_IOAS_UNMAP, &unmap_cmd));
+
+	/* Unmap fully contained areas works */
+	unmap_cmd.iova = self->base_iova - 4 * PAGE_SIZE;
+	unmap_cmd.length = 3 * 16 * PAGE_SIZE + 8 * PAGE_SIZE + 4 * PAGE_SIZE;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_UNMAP, &unmap_cmd));
+	ASSERT_EQ(32 * PAGE_SIZE, unmap_cmd.length);
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
+	struct iommu_iova_range ranges[1] = {};
+	struct iommu_ioas_allow_iovas allow_cmd = {
+		.size = sizeof(allow_cmd),
+		.ioas_id = self->ioas_id,
+		.num_iovas = 1,
+		.allowed_iovas = (uintptr_t)ranges,
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
+
+	/* Allowed region intersects with a reserved region */
+	ranges[0].start = PAGE_SIZE;
+	ranges[0].last = PAGE_SIZE * 600;
+	EXPECT_ERRNO(EADDRINUSE,
+		     ioctl(self->fd, IOMMU_IOAS_ALLOW_IOVAS, &allow_cmd));
+
+	/* Allocate from an allowed region */
+	if (self->domain_id) {
+		ranges[0].start =  MOCK_APERTURE_START + PAGE_SIZE;
+		ranges[0].last = MOCK_APERTURE_START + PAGE_SIZE * 600 - 1;
+	} else {
+		ranges[0].start = PAGE_SIZE * 200;
+		ranges[0].last = PAGE_SIZE * 600 - 1;
+	}
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_ALLOW_IOVAS, &allow_cmd));
+	for (i = 0; i != 10; i++) {
+		map_cmd.length = PAGE_SIZE * (i + 1);
+		ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+		iovas[i] = map_cmd.iova;
+		EXPECT_EQ(0, map_cmd.iova % (1UL << (ffs(map_cmd.length)-1)));
+		EXPECT_EQ(true, map_cmd.iova >= ranges[0].start);
+		EXPECT_EQ(true, map_cmd.iova <= ranges[0].last);
+		EXPECT_EQ(true,
+			  map_cmd.iova + map_cmd.length > ranges[0].start);
+		EXPECT_EQ(true,
+			  map_cmd.iova + map_cmd.length <= ranges[0].last + 1);
+	}
+	for (i = 0; i != 10; i++) {
+		unmap_cmd.length = PAGE_SIZE * (i + 1);
+		unmap_cmd.iova = iovas[i];
+		ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_UNMAP, &unmap_cmd));
+	}
+}
+
+TEST_F(iommufd_ioas, area_allowed)
+{
+	struct iommu_test_cmd test_cmd = {
+		.size = sizeof(test_cmd),
+		.op = IOMMU_TEST_OP_ADD_RESERVED,
+		.id = self->ioas_id,
+		.add_reserved = { .start = PAGE_SIZE * 4,
+				  .length = PAGE_SIZE * 100 },
+	};
+	struct iommu_iova_range ranges[1] = {};
+	struct iommu_ioas_allow_iovas allow_cmd = {
+		.size = sizeof(allow_cmd),
+		.ioas_id = self->ioas_id,
+		.num_iovas = 1,
+		.allowed_iovas = (uintptr_t)ranges,
+	};
+
+	/* Reserved intersects an allowed */
+	allow_cmd.num_iovas = 1;
+	ranges[0].start = self->base_iova;
+	ranges[0].last = ranges[0].start + PAGE_SIZE * 600;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_ALLOW_IOVAS, &allow_cmd));
+	test_cmd.add_reserved.start = ranges[0].start + PAGE_SIZE;
+	test_cmd.add_reserved.length = PAGE_SIZE;
+	EXPECT_ERRNO(EADDRINUSE,
+		     ioctl(self->fd,
+			   _IOMMU_TEST_CMD(IOMMU_TEST_OP_ADD_RESERVED),
+			   &test_cmd));
+	allow_cmd.num_iovas = 0;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_ALLOW_IOVAS, &allow_cmd));
+
+	/* Allowed intersects a reserved */
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ADD_RESERVED),
+			&test_cmd));
+	allow_cmd.num_iovas = 1;
+	ranges[0].start = self->base_iova;
+	ranges[0].last = ranges[0].start + PAGE_SIZE * 600;
+	EXPECT_ERRNO(EADDRINUSE,
+		     ioctl(self->fd, IOMMU_IOAS_ALLOW_IOVAS, &allow_cmd));
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
+	copy_cmd.src_iova = self->base_iova;
+	copy_cmd.dst_iova = 0;
+	test_ioctl_ioas_alloc(&copy_cmd.dst_ioas_id);
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
+	uint32_t access_item_id;
+
+	test_cmd_create_access(self->ioas_id, &access_cmd.id);
+
+	/* Single map/unmap */
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
+			&access_cmd));
+	test_cmd_destroy_access_item(
+		access_cmd.id, access_cmd.access_pages.out_access_item_id);
+
+	/* Double user */
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
+			&access_cmd));
+	access_item_id = access_cmd.access_pages.out_access_item_id;
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
+			&access_cmd));
+	test_cmd_destroy_access_item(
+		access_cmd.id, access_cmd.access_pages.out_access_item_id);
+	test_cmd_destroy_access_item(access_cmd.id, access_item_id);
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
+
+	test_ioctl_destroy(mock_cmd.mock_domain.device_id);
+	test_ioctl_destroy(mock_cmd.id);
+	test_cmd_destroy_access_item(
+		access_cmd.id, access_cmd.access_pages.out_access_item_id);
+	test_cmd_destroy_access(access_cmd.id);
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
+	struct iommu_test_cmd test_cmd = {
+		.size = sizeof(test_cmd),
+		.op = IOMMU_TEST_OP_MOCK_DOMAIN,
+	};
+	unsigned int i;
+
+	self->fd = open("/dev/iommu", O_RDWR);
+	ASSERT_NE(-1, self->fd);
+	test_ioctl_ioas_alloc(&self->ioas_id);
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
+	teardown_iommufd(self->fd, _metadata);
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
+			test_ioctl_destroy(add_mock_pt.mock_domain.device_id);
+			test_ioctl_destroy(add_mock_pt.id)
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
+
+	/* Pin the pages in an IOAS with no domains then copy to an IOAS with domains */
+	test_ioctl_ioas_alloc(&map_cmd.ioas_id);
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_MAP, &map_cmd));
+
+	test_cmd_create_access(map_cmd.ioas_id, &access_cmd.id);
+
+	ASSERT_EQ(0,
+		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
+			&access_cmd));
+	copy_cmd.src_ioas_id = map_cmd.ioas_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_COPY, &copy_cmd));
+	check_mock_iova(buffer, map_cmd.iova, BUFFER_SIZE);
+
+	test_cmd_destroy_access_item(
+		access_cmd.id, access_cmd.access_pages.out_access_item_id);
+	test_cmd_destroy_access(access_cmd.id)
+	test_ioctl_destroy(map_cmd.ioas_id);
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
+	teardown_iommufd(self->fd, _metadata);
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
+	struct iommu_vfio_ioas vfio_ioas_cmd = {
+		.size = sizeof(vfio_ioas_cmd),
+		.op = IOMMU_VFIO_IOAS_GET,
+	};
+	__u32 ioas_id;
+
+	/* ENODEV if there is no compat ioas */
+	EXPECT_ERRNO(ENODEV, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
+
+	/* Invalid id for set */
+	vfio_ioas_cmd.op = IOMMU_VFIO_IOAS_SET;
+	EXPECT_ERRNO(ENOENT, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
+
+	/* Valid id for set*/
+	test_ioctl_ioas_alloc(&ioas_id);
+	vfio_ioas_cmd.ioas_id = ioas_id;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
+
+	/* Same id comes back from get */
+	vfio_ioas_cmd.op = IOMMU_VFIO_IOAS_GET;
+	ASSERT_EQ(0, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
+	ASSERT_EQ(ioas_id, vfio_ioas_cmd.ioas_id);
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
+	test_ioctl_ioas_alloc(&self->ioas_id);
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
+	teardown_iommufd(self->fd, _metadata);
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
+/* FIXME cover boundary cases for iopt_access_pages()  */
+
+TEST_HARNESS_MAIN
-- 
2.37.3

