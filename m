Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93B563C944
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbiK2UaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235978AbiK2U3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:29:55 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6109763CEE
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:29:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYB1On/9LQL58dlOM0ArINpEsaJIfggRAJWifmcPTlv1Pw4Rt4hVCXo7wv3hki8bXA1dD7MwQ5OVsG3dLdA7txIkpiXXr2M0H47S14sqVA6729QvF+EPPfHZ2SaKYOrHVbZq0txL78YJ1Ej8kuu7+KsG0SpdcYscaJpHutZOE+AkJvP8eabC4YRTDgpcprX06olFYhw1+AmwrbqcVf10vl7+e9vHfNG+fB5c51T5/urP7YU9tpmUPYUvvN7Mb322ugU1LFt3Rcz2clHR19iz8tDaasr+XDoQN9q/s3VpEfmphdEAX5UjDXsjzqOCi8AtKrDEUK9Du6FhZIHWeUyN2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qMnPQiK+jGRb+4WeBJC6aPSoXK2luhd+fUOBicg3C2U=;
 b=dnmFioLPe6aBfK1EHVKh5iBlX0X/F7/gRsloZrUD2szVIsizXkD74pFdHbC+C1v2Kr3+P2WGsLSMDFWiLHlHv3dFVRbsl+eywK7tvaFPxsas1G1Yo0VE5FsgA0lEp6QWuSDoH6fBqzBDJkO9Cgp/BWA5VE4JLsuxuMJjTVOHUBJKNQ1rzvV7WSHDKbEqb2nAsx4tUAzYxC04hnrXytjqowubucomUqbOvJS6Nixl8D7qmHtAKpaN5GhJWXzcv0BhD2fmsyx9vT5vql2LxKUDZ9+9EAqDM7KF1UExSE88modB9QP5JIxv50WztHwceMXvAit6ye0x+LvlQOElWT+ciQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMnPQiK+jGRb+4WeBJC6aPSoXK2luhd+fUOBicg3C2U=;
 b=PpaqMgx0DOS4Ae4gVYCzcvy8ahh2c7W5Co+lbtB6oG4LY3j1GhMKdJYqYP+eyJidu5/tbIRkCNHEbm+k8u6w6iBUiDiWHLGwcVEymF6KKzTZRN9nePp2idJlfiYguc62B7V4rLolPZZOnqCEWOAdElBg8/AmdK3/QxifIA5rbRqQHC+06JuKMM+a4WqSGroBS5iSl3lwcQ04+mTBnJGAwsKvoejmuPn54t65S1o+Bd4tViHedFpfV+Csu2rc6RgQJ9xIdSgZUl9cecmQR9qNCt0o4d1BwzlzrUID4xwyLFC8A9ePnfgLvvjlwlLV23EN4h0UIgaogwztlYO0MiRoaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6796.namprd12.prod.outlook.com (2603:10b6:510:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:48 +0000
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
Subject: [PATCH v6 13/19] iommufd: Add kAPI toward external drivers for physical devices
Date:   Tue, 29 Nov 2022 16:29:36 -0400
Message-Id: <13-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6796:EE_
X-MS-Office365-Filtering-Correlation-Id: cf99bc7e-bb4d-4f2f-13a6-08dad24873ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c8LaGAX8TzbFnAUGiwZ5JVrpp3BVd6rXW3XUOCd4CadScFWpR4iSLrLovyJ7KxDUGL92UZPOd0+juoAzaIhZFJOFCQI6NLxx/iwI3YQ5toENAwlmtjm8+GNKh7YFCMXSOo7EhjbWw3SyPVuaEk2qkXkDEbTX6r7T/n10AgxPmlD3bdgFMME9yWArYthelFREqFFPyW9RWdo7iZXXRwnbhP3/ufJLMQq0xh317yLPx56ksPfG6KHcDz7uPAKo50tOaNR9GBW+RK6npoXh9QYLinlEzxbf1J94DkRTxtnkeIx0QZsKFU18e4HegC/4irlulG+waAmSLmRfOc+7oKbpWkkS1WfOziW2ZGKUhtKtmHcf7Vp9ewcdP/NRctry4e/0Y8XJxXf7bbS41HRruMC/fqfVM+WZspiS5sWxELfMFiVHyQ6MUfx2KcxgVlzaZyGvgks5062jd4DsefO0BeY/BIYBtkshfi1OTAsCvUGdcyQ5V2vgncCx03zquyF23OYDuQK2H7SsdPfiDXoKhFr1tNm3nuhhmI6w/gQBzwEhK4oA1KFf4F8Hd+27kXvVFsLTP7zzSWL/uwCB5uk+EPNSmgzX26+M3HMcYsCteYiyq6f1r3vcOesUrgHU245JOazAjXRwT8RApapdsUyFsxV2p3hiZpITOILr+k8wjJL3yHLuN6KD1mIo8h2q1Tihb+1a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(451199015)(109986013)(2616005)(186003)(66899015)(54906003)(316002)(6486002)(36756003)(86362001)(38100700002)(26005)(83380400001)(6666004)(6506007)(6512007)(30864003)(478600001)(7416002)(8676002)(41300700001)(2906002)(8936002)(66946007)(66476007)(66556008)(5660300002)(4326008)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XJGUa2h/10Ev4IDSieolt+zJ5ced0bDfAMBGI7a1PatCnERI4v9nNoiZJ5nV?=
 =?us-ascii?Q?54cquw0XPGTTbn7B+lWeBPJYanDkeJEt5wG/jQ6Dk5/Zlo9s/zl5Q1i38f+F?=
 =?us-ascii?Q?Ig3Dou3rynEUtRmlgFOZRxr0etRPV+8E3jmXoeLxA9PB2Et17Kv5i+gK8wPM?=
 =?us-ascii?Q?8z6GDQimJxNTOXGZU7w8dPRCx3jhA3Yc+oiqXhYSqCBYcOIDv3+wx5goMzVy?=
 =?us-ascii?Q?yXcLAsnA53xfOJiQ626eW2ngudfyYwmBnHcOaO7f0DNkW9DL1nfRJjb6KrN1?=
 =?us-ascii?Q?m72dAPpK/Jy0Kkl3cf6W/HoWzFrpBNqFWKWyYRPZoiWzG8NP85mYgw1VNutM?=
 =?us-ascii?Q?a491G80xfkCULjdRP6x9QCUdHsIA7XiXvQccGU0birL6SXDQUSThBj20EwVf?=
 =?us-ascii?Q?PPzw/GTVaq9DpO7ql2AYeWSk9F0APah07CR88gkKGqOhFDgCpzogF2yErJnv?=
 =?us-ascii?Q?ItJPj2pqwUKzf0wkgVp/HZ6XYN30HbLsoZyFaIB6CT6SAtgdRUyYm9958gpc?=
 =?us-ascii?Q?dBmPKZZYot+ZXhCXx2QKbargMoDAMKqvZuqH1RfItbZ5XXfEm7ZVT4IHoWUq?=
 =?us-ascii?Q?JlySrz5NiOKvi157f/DAYhZ0NWm451WzdHs2eR8BC/hQYV4AbLMDKUKgBcrB?=
 =?us-ascii?Q?d5x2kbQVVPhz9fSRK36MX0qt6dIu9sLI7GpaMncS3iOsquj6mRS/ab9IbUEN?=
 =?us-ascii?Q?tI9yzrLO3yoiAbu8r6SwOmCVRUz2bdrJbyaEsApM34/WQRBPX0UQv+dlauqL?=
 =?us-ascii?Q?S6OGZwBxjB8EofNQSoCei87xlGVJ9ePqd+kFYJ+HXPt4OPt0k5CAJLl3c/mw?=
 =?us-ascii?Q?g64uftczOuS09A2kHIBqFYC1e3Oz4QWze6zEpOo2/NYKYfJFtWjnxrpbz0NO?=
 =?us-ascii?Q?HWuFBKZlfGM1Mm/MoKAy8DggRruupUva5o3imTdrrwa+y4gUxmSg6NiWYSub?=
 =?us-ascii?Q?v1bPNIkai3stFBU8CBbW6WRtRiDr8Jp8ux1UsmMevoiQptreCkyep/NZX32i?=
 =?us-ascii?Q?SWq35gzEfHTl0o87C0CQSbp9uapVfvlnU2eX2ZdXj99gpy+5jee/Z6lZu2qx?=
 =?us-ascii?Q?+375gMi+QR6GxfKJw6avkqxgNrWjzVhqHfWzRiKB4TuEo0AQjmG2Ix7DEVTo?=
 =?us-ascii?Q?eP986VVzUUrUOHOLEd7cvw67aXbCCO8YQhoZgTyzXN+lk1VSlf/4Aed+QoNI?=
 =?us-ascii?Q?Qe4kcTILnpURSnnn8YsVPAzUP/mcX79oLhC6NPncovZ7D5Dh6PUG2+yO3nIk?=
 =?us-ascii?Q?R7pHCZsSCqy7fLQe6ki2tqxEQ2Q2K+8KYJuVv7Srh1zaNFlRdD2Yu9H11xoS?=
 =?us-ascii?Q?iY47/6nmZBhjjwMzMVSH4qTMbWTCTnBmHU2DialSHMrfseKQdxWflTdWEKTF?=
 =?us-ascii?Q?lE5EeggR8XdtVbNgwLaoqSj0JBe6tgtHuuns+z/qruoWroDJkggz/H+t3vfv?=
 =?us-ascii?Q?gso/UXCUD6/xum3MBNuG/uuuUVdEnGBJQOTDG9wXHiUOO9EZYF9Z3ehdiECB?=
 =?us-ascii?Q?9enCHoGtfVkzqUCPUd5+iRdZdCLipI5nSgwGWE+XWXky/8PTSPfjVHuJtVAZ?=
 =?us-ascii?Q?BP7Tx5n28h2VcrdABCHtLDcBGr723X1G3f/s0Gy5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf99bc7e-bb4d-4f2f-13a6-08dad24873ef
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:45.5873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /HYqhPJ0bWRryBEcFIzqITigahYtk3SDJ130+zVbyGN1KfREwPhW5fXugu9dNkhh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6796
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

Add the four functions external drivers need to connect physical DMA to
the IOMMUFD:

iommufd_device_bind() / iommufd_device_unbind()
  Register the device with iommufd and establish security isolation.

iommufd_device_attach() / iommufd_device_detach()
  Connect a bound device to a page table

Binding a device creates a device object ID in the uAPI, however the
generic API does not yet provide any IOCTLs to manipulate them.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |   1 +
 drivers/iommu/iommufd/device.c          | 419 ++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h |   5 +
 drivers/iommu/iommufd/main.c            |   3 +
 include/linux/iommufd.h                 |   9 +
 5 files changed, 437 insertions(+)
 create mode 100644 drivers/iommu/iommufd/device.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index e13e971aa28c60..ca28a135b9675f 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 iommufd-y := \
+	device.o \
 	hw_pagetable.o \
 	io_pagetable.o \
 	ioas.o \
diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
new file mode 100644
index 00000000000000..67cd00b4d92650
--- /dev/null
+++ b/drivers/iommu/iommufd/device.c
@@ -0,0 +1,419 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ */
+#include <linux/iommufd.h>
+#include <linux/slab.h>
+#include <linux/iommu.h>
+#include <linux/irqdomain.h>
+
+#include "iommufd_private.h"
+
+static bool allow_unsafe_interrupts;
+module_param(allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(
+	allow_unsafe_interrupts,
+	"Allow IOMMUFD to bind to devices even if the platform cannot isolate "
+	"the MSI interrupt window. Enabling this is a security weakness.");
+
+/*
+ * A iommufd_device object represents the binding relationship between a
+ * consuming driver and the iommufd. These objects are created/destroyed by
+ * external drivers, not by userspace.
+ */
+struct iommufd_device {
+	struct iommufd_object obj;
+	struct iommufd_ctx *ictx;
+	struct iommufd_hw_pagetable *hwpt;
+	/* Head at iommufd_hw_pagetable::devices */
+	struct list_head devices_item;
+	/* always the physical device */
+	struct device *dev;
+	struct iommu_group *group;
+	bool enforce_cache_coherency;
+};
+
+void iommufd_device_destroy(struct iommufd_object *obj)
+{
+	struct iommufd_device *idev =
+		container_of(obj, struct iommufd_device, obj);
+
+	iommu_device_release_dma_owner(idev->dev);
+	iommu_group_put(idev->group);
+	iommufd_ctx_put(idev->ictx);
+}
+
+/**
+ * iommufd_device_bind - Bind a physical device to an iommu fd
+ * @ictx: iommufd file descriptor
+ * @dev: Pointer to a physical device struct
+ * @id: Output ID number to return to userspace for this device
+ *
+ * A successful bind establishes an ownership over the device and returns
+ * struct iommufd_device pointer, otherwise returns error pointer.
+ *
+ * A driver using this API must set driver_managed_dma and must not touch
+ * the device until this routine succeeds and establishes ownership.
+ *
+ * Binding a PCI device places the entire RID under iommufd control.
+ *
+ * The caller must undo this with iommufd_device_unbind()
+ */
+struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
+					   struct device *dev, u32 *id)
+{
+	struct iommufd_device *idev;
+	struct iommu_group *group;
+	int rc;
+
+	/*
+	 * iommufd always sets IOMMU_CACHE because we offer no way for userspace
+	 * to restore cache coherency.
+	 */
+	if (!device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY))
+		return ERR_PTR(-EINVAL);
+
+	group = iommu_group_get(dev);
+	if (!group)
+		return ERR_PTR(-ENODEV);
+
+	rc = iommu_device_claim_dma_owner(dev, ictx);
+	if (rc)
+		goto out_group_put;
+
+	idev = iommufd_object_alloc(ictx, idev, IOMMUFD_OBJ_DEVICE);
+	if (IS_ERR(idev)) {
+		rc = PTR_ERR(idev);
+		goto out_release_owner;
+	}
+	idev->ictx = ictx;
+	iommufd_ctx_get(ictx);
+	idev->dev = dev;
+	idev->enforce_cache_coherency =
+		device_iommu_capable(dev, IOMMU_CAP_ENFORCE_CACHE_COHERENCY);
+	/* The calling driver is a user until iommufd_device_unbind() */
+	refcount_inc(&idev->obj.users);
+	/* group refcount moves into iommufd_device */
+	idev->group = group;
+
+	/*
+	 * If the caller fails after this success it must call
+	 * iommufd_unbind_device() which is safe since we hold this refcount.
+	 * This also means the device is a leaf in the graph and no other object
+	 * can take a reference on it.
+	 */
+	iommufd_object_finalize(ictx, &idev->obj);
+	*id = idev->obj.id;
+	return idev;
+
+out_release_owner:
+	iommu_device_release_dma_owner(dev);
+out_group_put:
+	iommu_group_put(group);
+	return ERR_PTR(rc);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_bind, IOMMUFD);
+
+/**
+ * iommufd_device_unbind - Undo iommufd_device_bind()
+ * @idev: Device returned by iommufd_device_bind()
+ *
+ * Release the device from iommufd control. The DMA ownership will return back
+ * to unowned with DMA controlled by the DMA API. This invalidates the
+ * iommufd_device pointer, other APIs that consume it must not be called
+ * concurrently.
+ */
+void iommufd_device_unbind(struct iommufd_device *idev)
+{
+	bool was_destroyed;
+
+	was_destroyed = iommufd_object_destroy_user(idev->ictx, &idev->obj);
+	WARN_ON(!was_destroyed);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind, IOMMUFD);
+
+static int iommufd_device_setup_msi(struct iommufd_device *idev,
+				    struct iommufd_hw_pagetable *hwpt,
+				    phys_addr_t sw_msi_start)
+{
+	int rc;
+
+	/*
+	 * IOMMU_CAP_INTR_REMAP means that the platform is isolating MSI, and it
+	 * creates the MSI window by default in the iommu domain. Nothing
+	 * further to do.
+	 */
+	if (device_iommu_capable(idev->dev, IOMMU_CAP_INTR_REMAP))
+		return 0;
+
+	/*
+	 * On ARM systems that set the global IRQ_DOMAIN_FLAG_MSI_REMAP every
+	 * allocated iommu_domain will block interrupts by default and this
+	 * special flow is needed to turn them back on. iommu_dma_prepare_msi()
+	 * will install pages into our domain after request_irq() to make this
+	 * work.
+	 *
+	 * FIXME: This is conceptually broken for iommufd since we want to allow
+	 * userspace to change the domains, eg switch from an identity IOAS to a
+	 * DMA IOAS. There is currently no way to create a MSI window that
+	 * matches what the IRQ layer actually expects in a newly created
+	 * domain.
+	 */
+	if (irq_domain_check_msi_remap()) {
+		if (WARN_ON(!sw_msi_start))
+			return -EPERM;
+		/*
+		 * iommu_get_msi_cookie() can only be called once per domain,
+		 * it returns -EBUSY on later calls.
+		 */
+		if (hwpt->msi_cookie)
+			return 0;
+		rc = iommu_get_msi_cookie(hwpt->domain, sw_msi_start);
+		if (rc)
+			return rc;
+		hwpt->msi_cookie = true;
+		return 0;
+	}
+
+	/*
+	 * Otherwise the platform has a MSI window that is not isolated. For
+	 * historical compat with VFIO allow a module parameter to ignore the
+	 * insecurity.
+	 */
+	if (!allow_unsafe_interrupts)
+		return -EPERM;
+
+	dev_warn(
+		idev->dev,
+		"MSI interrupt window cannot be isolated by the IOMMU, this platform is insecure. Use the \"allow_unsafe_interrupts\" module parameter to override\n");
+	return 0;
+}
+
+static bool iommufd_hw_pagetable_has_group(struct iommufd_hw_pagetable *hwpt,
+					   struct iommu_group *group)
+{
+	struct iommufd_device *cur_dev;
+
+	list_for_each_entry(cur_dev, &hwpt->devices, devices_item)
+		if (cur_dev->group == group)
+			return true;
+	return false;
+}
+
+static int iommufd_device_do_attach(struct iommufd_device *idev,
+				    struct iommufd_hw_pagetable *hwpt)
+{
+	phys_addr_t sw_msi_start = 0;
+	int rc;
+
+	mutex_lock(&hwpt->devices_lock);
+
+	/*
+	 * Try to upgrade the domain we have, it is an iommu driver bug to
+	 * report IOMMU_CAP_ENFORCE_CACHE_COHERENCY but fail
+	 * enforce_cache_coherency when there are no devices attached to the
+	 * domain.
+	 */
+	if (idev->enforce_cache_coherency && !hwpt->enforce_cache_coherency) {
+		if (hwpt->domain->ops->enforce_cache_coherency)
+			hwpt->enforce_cache_coherency =
+				hwpt->domain->ops->enforce_cache_coherency(
+					hwpt->domain);
+		if (!hwpt->enforce_cache_coherency) {
+			WARN_ON(list_empty(&hwpt->devices));
+			rc = -EINVAL;
+			goto out_unlock;
+		}
+	}
+
+	rc = iopt_table_enforce_group_resv_regions(&hwpt->ioas->iopt, idev->dev,
+						   idev->group, &sw_msi_start);
+	if (rc)
+		goto out_unlock;
+
+	rc = iommufd_device_setup_msi(idev, hwpt, sw_msi_start);
+	if (rc)
+		goto out_iova;
+
+	/*
+	 * FIXME: Hack around missing a device-centric iommu api, only attach to
+	 * the group once for the first device that is in the group.
+	 */
+	if (!iommufd_hw_pagetable_has_group(hwpt, idev->group)) {
+		rc = iommu_attach_group(hwpt->domain, idev->group);
+		if (rc)
+			goto out_iova;
+
+		if (list_empty(&hwpt->devices)) {
+			rc = iopt_table_add_domain(&hwpt->ioas->iopt,
+						   hwpt->domain);
+			if (rc)
+				goto out_detach;
+		}
+	}
+
+	idev->hwpt = hwpt;
+	refcount_inc(&hwpt->obj.users);
+	list_add(&idev->devices_item, &hwpt->devices);
+	mutex_unlock(&hwpt->devices_lock);
+	return 0;
+
+out_detach:
+	iommu_detach_group(hwpt->domain, idev->group);
+out_iova:
+	iopt_remove_reserved_iova(&hwpt->ioas->iopt, idev->dev);
+out_unlock:
+	mutex_unlock(&hwpt->devices_lock);
+	return rc;
+}
+
+/*
+ * When automatically managing the domains we search for a compatible domain in
+ * the iopt and if one is found use it, otherwise create a new domain.
+ * Automatic domain selection will never pick a manually created domain.
+ */
+static int iommufd_device_auto_get_domain(struct iommufd_device *idev,
+					  struct iommufd_ioas *ioas)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	int rc;
+
+	/*
+	 * There is no differentiation when domains are allocated, so any domain
+	 * that is willing to attach to the device is interchangeable with any
+	 * other.
+	 */
+	mutex_lock(&ioas->mutex);
+	list_for_each_entry(hwpt, &ioas->hwpt_list, hwpt_item) {
+		if (!hwpt->auto_domain)
+			continue;
+
+		rc = iommufd_device_do_attach(idev, hwpt);
+
+		/*
+		 * -EINVAL means the domain is incompatible with the device.
+		 * Other error codes should propagate to userspace as failure.
+		 * Success means the domain is attached.
+		 */
+		if (rc == -EINVAL)
+			continue;
+		goto out_unlock;
+	}
+
+	hwpt = iommufd_hw_pagetable_alloc(idev->ictx, ioas, idev->dev);
+	if (IS_ERR(hwpt)) {
+		rc = PTR_ERR(hwpt);
+		goto out_unlock;
+	}
+	hwpt->auto_domain = true;
+
+	rc = iommufd_device_do_attach(idev, hwpt);
+	if (rc)
+		goto out_abort;
+	list_add_tail(&hwpt->hwpt_item, &ioas->hwpt_list);
+
+	mutex_unlock(&ioas->mutex);
+	iommufd_object_finalize(idev->ictx, &hwpt->obj);
+	return 0;
+
+out_abort:
+	iommufd_object_abort_and_destroy(idev->ictx, &hwpt->obj);
+out_unlock:
+	mutex_unlock(&ioas->mutex);
+	return rc;
+}
+
+/**
+ * iommufd_device_attach - Connect a device from an iommu_domain
+ * @idev: device to attach
+ * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HW_PAGETABLE
+ *         Output the IOMMUFD_OBJ_HW_PAGETABLE ID
+ *
+ * This connects the device to an iommu_domain, either automatically or manually
+ * selected. Once this completes the device could do DMA.
+ *
+ * The caller should return the resulting pt_id back to userspace.
+ * This function is undone by calling iommufd_device_detach().
+ */
+int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id)
+{
+	struct iommufd_object *pt_obj;
+	int rc;
+
+	pt_obj = iommufd_get_object(idev->ictx, *pt_id, IOMMUFD_OBJ_ANY);
+	if (IS_ERR(pt_obj))
+		return PTR_ERR(pt_obj);
+
+	switch (pt_obj->type) {
+	case IOMMUFD_OBJ_HW_PAGETABLE: {
+		struct iommufd_hw_pagetable *hwpt =
+			container_of(pt_obj, struct iommufd_hw_pagetable, obj);
+
+		rc = iommufd_device_do_attach(idev, hwpt);
+		if (rc)
+			goto out_put_pt_obj;
+
+		mutex_lock(&hwpt->ioas->mutex);
+		list_add_tail(&hwpt->hwpt_item, &hwpt->ioas->hwpt_list);
+		mutex_unlock(&hwpt->ioas->mutex);
+		break;
+	}
+	case IOMMUFD_OBJ_IOAS: {
+		struct iommufd_ioas *ioas =
+			container_of(pt_obj, struct iommufd_ioas, obj);
+
+		rc = iommufd_device_auto_get_domain(idev, ioas);
+		if (rc)
+			goto out_put_pt_obj;
+		break;
+	}
+	default:
+		rc = -EINVAL;
+		goto out_put_pt_obj;
+	}
+
+	refcount_inc(&idev->obj.users);
+	*pt_id = idev->hwpt->obj.id;
+	rc = 0;
+
+out_put_pt_obj:
+	iommufd_put_object(pt_obj);
+	return rc;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_attach, IOMMUFD);
+
+/**
+ * iommufd_device_detach - Disconnect a device to an iommu_domain
+ * @idev: device to detach
+ *
+ * Undo iommufd_device_attach(). This disconnects the idev from the previously
+ * attached pt_id. The device returns back to a blocked DMA translation.
+ */
+void iommufd_device_detach(struct iommufd_device *idev)
+{
+	struct iommufd_hw_pagetable *hwpt = idev->hwpt;
+
+	mutex_lock(&hwpt->ioas->mutex);
+	mutex_lock(&hwpt->devices_lock);
+	list_del(&idev->devices_item);
+	if (!iommufd_hw_pagetable_has_group(hwpt, idev->group)) {
+		if (list_empty(&hwpt->devices)) {
+			iopt_table_remove_domain(&hwpt->ioas->iopt,
+						 hwpt->domain);
+			list_del(&hwpt->hwpt_item);
+		}
+		iommu_detach_group(hwpt->domain, idev->group);
+	}
+	iopt_remove_reserved_iova(&hwpt->ioas->iopt, idev->dev);
+	mutex_unlock(&hwpt->devices_lock);
+	mutex_unlock(&hwpt->ioas->mutex);
+
+	if (hwpt->auto_domain)
+		iommufd_object_destroy_user(idev->ictx, &hwpt->obj);
+	else
+		refcount_dec(&hwpt->obj.users);
+
+	idev->hwpt = NULL;
+
+	refcount_dec(&idev->obj.users);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_detach, IOMMUFD);
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 6b0448702a956d..72a0c805be2335 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -103,6 +103,7 @@ static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
 enum iommufd_object_type {
 	IOMMUFD_OBJ_NONE,
 	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
+	IOMMUFD_OBJ_DEVICE,
 	IOMMUFD_OBJ_HW_PAGETABLE,
 	IOMMUFD_OBJ_IOAS,
 };
@@ -229,6 +230,8 @@ struct iommufd_hw_pagetable {
 	struct iommufd_ioas *ioas;
 	struct iommu_domain *domain;
 	bool auto_domain : 1;
+	bool enforce_cache_coherency : 1;
+	bool msi_cookie : 1;
 	/* Head at iommufd_ioas::hwpt_list */
 	struct list_head hwpt_item;
 	struct mutex devices_lock;
@@ -240,6 +243,8 @@ iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 			   struct device *dev);
 void iommufd_hw_pagetable_destroy(struct iommufd_object *obj);
 
+void iommufd_device_destroy(struct iommufd_object *obj);
+
 struct iommufd_access {
 	unsigned long iova_alignment;
 	u32 iopt_access_list_id;
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index ac6580a7b70660..fe98912bab0e02 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -357,6 +357,9 @@ void iommufd_ctx_put(struct iommufd_ctx *ictx)
 EXPORT_SYMBOL_NS_GPL(iommufd_ctx_put, IOMMUFD);
 
 static const struct iommufd_object_ops iommufd_object_ops[] = {
+	[IOMMUFD_OBJ_DEVICE] = {
+		.destroy = iommufd_device_destroy,
+	},
 	[IOMMUFD_OBJ_IOAS] = {
 		.destroy = iommufd_ioas_destroy,
 	},
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 26e09d539737bb..185dff3eb32f16 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -9,10 +9,19 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/err.h>
+#include <linux/device.h>
 
+struct iommufd_device;
 struct iommufd_ctx;
 struct file;
 
+struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
+					   struct device *dev, u32 *id);
+void iommufd_device_unbind(struct iommufd_device *idev);
+
+int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
+void iommufd_device_detach(struct iommufd_device *idev);
+
 enum {
 	IOMMUFD_ACCESS_RW_READ = 0,
 	IOMMUFD_ACCESS_RW_WRITE = 1 << 0,
-- 
2.38.1

