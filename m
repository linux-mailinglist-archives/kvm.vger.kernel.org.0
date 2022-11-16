Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F206162CC43
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiKPVHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239095AbiKPVGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:06:51 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918596AEE2
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:05:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQyZf/wAtFx6L03G8aBSqEFHzqfMZl9UtUICV1ZzU44dwtOPUlbuJlpcyb/xy3TvFU5XNnEfZphU7c0k+LxePar7vTh7K+uyAZpTFI7nvDsM2btOU8K8FesR6pRRVoY0hRUm0LAZonHNbJZ66hYjOSL4tz9GBIKA/CZ3uB8LuIZ7whnZReOG/rJ/3YLPrA5RyGQsyAgSx/to09sScUEKzS8zX7LeKrg60aMq5vEfiIYCUJqiuTBG7HN3VQEoUM3C0m1bemoatTZijFuVSE4MNiYKu3ZAvbVXUQVI1P3F6JbPJJ8CLGKqMUtXMTNGURzXaC5K4H4otBDBxejR4JPAxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNfjN9ANLsl+gbdsByuZhQQBvCtdd69b58/PoYxc/mM=;
 b=TCpgMIRNTcqL5TXfagwDLm4xU+rQeToFAZRPaTecq3LppKyzuG65IqbCSwzXogzdP4YLIgFfk/t4kKL/ojbvLInK+uuPoFwqgphkRmNaEETwaOi782hdJGKpHWq9iQ/oOX++I0NlOM1+RyUgX1B7RMgGDsI+h++ae+LN/C6YM5L7L3RFuPaTJWQO8entqqelHy2Du1wdjXuuzo9wFYCBVH4C+EgXHNVSbCFPOEy0tY5kArDoGYOkuxOWqEM1/PQl6sMmg2nsBwOrDHKEWXmgtOGBeBv9K1rS+QcRo+zBY5gyBxaDGhqNsst2banFFINJlCmxRXO/Q1qoBs4rerZm3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNfjN9ANLsl+gbdsByuZhQQBvCtdd69b58/PoYxc/mM=;
 b=L3Acpp6Ky0oOp0RmcRvFKhECiLZCeT7B+XCVII2c20waB+2POHb3m4/1zDCz4/kRjY6GOvhr3ymP3vPYeRF32HWgObZeXzYyEOp+82kDKuM4HAqf0RHUATD2QTxUycUD8tH8MW2+naXE5XjoqK+eoFbydKPstjASo6TpTqAQ9NhM2NLQbWRyrzJfVI97NfUVad0BOK7VD2NBDWXJaQiVqrHhIEto1/yO8KO5PiGn45VqT16wfk9pRnBKCtyedBsW2SM3e4UQcyQ8P1wHeSQfwk9z0FmRPwoBvbpj5pkA51ubilW9YCJPlqYTqMslKRXCKZK6XeCoyUy3UBCL/UPu7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 21:05:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 21:05:43 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v3 06/11] vfio-iommufd: Allow iommufd to be used in place of a container fd
Date:   Wed, 16 Nov 2022 17:05:31 -0400
Message-Id: <6-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0018.namprd19.prod.outlook.com
 (2603:10b6:208:178::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 75dfc8f3-3e60-4d07-0df4-08dac8165013
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WXXZwILaQW2qlJ9doMXF4FzvKNiEPFPVuVvaKaoNtBU6mkxbUKbmydeeUisdIIU88NzvnHK9iGjBVo6sUy4EXCUufDZEWoG8csXYwVzrhU7qESTEQBSMkCMO6xsrjxf7KW9lN/hH9iJB9MwCbSTMaoZlj+IfQN/upqJG/YzWxNP3EPeaDAS4xA5kYR08FnZEEhVtAYW0bupVjBZ5kaWpqq+fBseJeRaYhBSm9csVDDyAEfsKRZwOGcFsRI7/fXr9ag+31i7HF5k5TFA/GDpPoDIYOzmQv9FoCtnxZvNCoXU1x6O72w1nY7tu0tGRiVW9BwMVe1BWRiViOfFybNzyHgmw2ks9XJS2ykiLyWamxdXMELrYlbk3VY5lIbDEOUeD5/BdDduwdzwfdNVQlWK4mmq9d6I5cyK+VJQHO/0O8TSNNHSWjYX9SJHAblAOxc3n7Phw9VpR9qVpOKqpj3Oio39w9svekYzZTSIh44C4qnIyVAQXWzRbfuxOu2QIufBuK+eagdq84nUgcb8pXY1Oty6QFxALS02XKXwjt95HA5rSgg3JQMTq8WrmpfZLHWrOgHDrRY+otE8nwAzfEUjgyoPuCSAhRnki7cjFZ5wlsRt04NgHnHyFn4MN1E/62gSZn2p52xPBHbX+IUy5717stydVgHcap8spEU/CcW8m60J6ACfmoG25YX8Djq88UZngk7G3u6KHygrln/rxa42vd8KOkaVRswoG4nE32aCUBtzD+O0JevvFaaxQQ3I1Q59v6ewGGN4UQOkiZuf9vjZjLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(109986013)(86362001)(36756003)(38100700002)(54906003)(316002)(6506007)(6486002)(478600001)(2906002)(5660300002)(7416002)(186003)(2616005)(6666004)(8936002)(66556008)(4326008)(66476007)(66946007)(83380400001)(6512007)(41300700001)(26005)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?14+c2icw5GdYyHda2B8uUdOFw27zVl2kxuWsI5ky/sGF/O9s0gMeJbRbU5DR?=
 =?us-ascii?Q?wcvvwYlKmigqJYS/QMw/RfcE4vsiQmVx5IqmVqM2n/RjrwdfAMj+yGtBdGjQ?=
 =?us-ascii?Q?TXjyU1ZiXy/i8pK5QyFKfF80kcpQD2sWy3nRqdkdcl7TRG25jP/IaHJFvpXO?=
 =?us-ascii?Q?xHGzsnOA4sA4CpOWRLjkIeBZ2e9ZHfwYPqnoGeEJcinSapL8W3d9ZgxulWBp?=
 =?us-ascii?Q?JUj8F2f5SHOQhnRCYBux4sC4AIftSFpkGg7mTNQs6VPJb2hzMPulpaQTyclo?=
 =?us-ascii?Q?JM1e3NvrEngB+N7YCflcz3QBQREVadifn3BibWG67VoJWfg9+AH0ODsh/CHV?=
 =?us-ascii?Q?xV1ERHvIc0P51xtsaVq9B1o41fIR200trQLuo156Cz8YF14klDTk0QCnrOuE?=
 =?us-ascii?Q?o7WDV+KqgNcaJMJPLDJxbhQo6Fc7ly64nIaZjntN/VYs9wTuLkcYUoEh1FWL?=
 =?us-ascii?Q?m4rQ4lK2SPn547GRfyo+RiEHDukQFDoK4IN8RYLkP488pgx9+nxpbBW/4Z0i?=
 =?us-ascii?Q?Ru7FvC4nFvbvg+C3uOIBX9XSlWFb9WrnBH98kH7Z/iefVY6YmgrDlSkyyD6t?=
 =?us-ascii?Q?U6hpWphUODaFmGt0UaewUbdaFgiOvRAAZYXwik5WepRyhHPJtGlawcDUJSlx?=
 =?us-ascii?Q?VEb5ngMKHRCKCXxSQcxK3GW/9BUCxnbH3Lrxq91bHcgBqVCoxorhFAI4ScF/?=
 =?us-ascii?Q?+7xty9VOUclZOxNpEvyR+AsJhpAsbv+x/sPSocVa1sz8Mi3rMYn99aPODl2y?=
 =?us-ascii?Q?iTWAs9DVy3Qz5pARjCsmh+Kf22ZIwmRHk9BcA/2uufVgs+uOd9GjT22bsOhO?=
 =?us-ascii?Q?+Xo4p6S3NX6f2t8IYOI+RuGYo8n+o7DzR5Pmj37JReuPZEGHrBhG2Umj7+iB?=
 =?us-ascii?Q?66/nM/f5IEwnHizpaQ7/GMApI6qfYgSwe0ANBA9KCFWhI491DF2kDMQKUziw?=
 =?us-ascii?Q?i2jJq3QjOWDtgGQbYNgTxSx7GMGRFAXPzPLUXO6ueT6ofUEDBlE9gV9BLPBl?=
 =?us-ascii?Q?OoWp8KRH9NQPkoYioEqLEq4IHBR+ZenH0E0rYXYaoLjZP2jFexU/qg3RU2ou?=
 =?us-ascii?Q?DFy4GfkEAk3/uH6FEQvB2aztSyEI2a4Em3Pk8k7w7zFAeXrbj50A5Yf32+70?=
 =?us-ascii?Q?M4oJzpXWm4ozQGElJ3slWg4xrhPBA9ZbA754KedwtbYpI3X6Sp0EfE2XKkgb?=
 =?us-ascii?Q?Y6JtCr3tY5k+NulzOyJGj/rdNUqwNrR2Xiw4lKKAHZO+zBweJoBAKrhFshB5?=
 =?us-ascii?Q?wI9kCGxaOtrg4vSqeE5qYeH4WWfwy5A/PJC696n4mk/cfTiC+iUnDlt5YOyn?=
 =?us-ascii?Q?v1LJIToPmL3Y51ZVEDr6rP/14ocDs2K++xQGzUXhVCkY9mbogMHjX0FO0eI1?=
 =?us-ascii?Q?bJZBRnSy04S/2HsiStT7CNsZm/1VucptanWpWtmw32Oh3IWbJm1oVqiaOoEY?=
 =?us-ascii?Q?5J6km0z/bAA8ISXC1BKb+CcXyS8ghe/TT0KmXN7F+GnHlBObB0SXsaH60uGG?=
 =?us-ascii?Q?OiQD/fJ0GyJfOFNDSRBJF5YRt+3RlX5Et+zehXtamJefjN6rXrfi9vWIRpuA?=
 =?us-ascii?Q?GT2Anvvn7PFVZLSjcwY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75dfc8f3-3e60-4d07-0df4-08dac8165013
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:05:38.6795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z80meAqX5zhc7K0HbDdtaXmRt/xXi+r5oNLxSmp8I03BvseQKqMB0RNrrS2ebpcX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609
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

This makes VFIO_GROUP_SET_CONTAINER accept both a vfio container FD and an
iommufd.

In iommufd mode an IOAS will exist after the SET_CONTAINER, but it will
not be attached to any groups.

For VFIO this means that the VFIO_GROUP_GET_STATUS and
VFIO_GROUP_FLAGS_VIABLE works subtly differently. With the container FD
the iommu_group_claim_dma_owner() is done during SET_CONTAINER but for
IOMMUFD this is done during VFIO_GROUP_GET_DEVICE_FD. Meaning that
VFIO_GROUP_FLAGS_VIABLE could be set but GET_DEVICE_FD will fail due to
viability.

As GET_DEVICE_FD can fail for many reasons already this is not expected to
be a meaningful difference.

Reorganize the tests for if the group has an assigned container or iommu
into a vfio_group_has_iommu() function and consolidate all the duplicated
WARN_ON's etc related to this.

Call container functions only if a container is actually present on the
group.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Kconfig     |  1 +
 drivers/vfio/container.c |  7 +++-
 drivers/vfio/vfio.h      |  2 +
 drivers/vfio/vfio_main.c | 86 +++++++++++++++++++++++++++++++++-------
 4 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 86c381ceb9a1e9..1118d322eec97d 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -2,6 +2,7 @@
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	select IOMMU_API
+	depends on IOMMUFD || !IOMMUFD
 	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
 	select INTERVAL_TREE
 	help
diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index d97747dfb05d02..8772dad6808539 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -516,8 +516,11 @@ int vfio_group_use_container(struct vfio_group *group)
 {
 	lockdep_assert_held(&group->group_lock);
 
-	if (!group->container || !group->container->iommu_driver ||
-	    WARN_ON(!group->container_users))
+	/*
+	 * The container fd has been assigned with VFIO_GROUP_SET_CONTAINER but
+	 * VFIO_SET_IOMMU hasn't been done yet.
+	 */
+	if (!group->container->iommu_driver)
 		return -EINVAL;
 
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 247590334e14b0..985e13d52989ca 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -10,6 +10,7 @@
 #include <linux/cdev.h>
 #include <linux/module.h>
 
+struct iommufd_ctx;
 struct iommu_group;
 struct vfio_device;
 struct vfio_container;
@@ -60,6 +61,7 @@ struct vfio_group {
 	struct kvm			*kvm;
 	struct file			*opened_file;
 	struct blocking_notifier_head	notifier;
+	struct iommufd_ctx		*iommufd;
 };
 
 /* events for the backend driver notify callback */
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5c0e810f8b4d08..8c124290ce9f0d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -35,6 +35,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/interval_tree.h>
 #include <linux/iova_bitmap.h>
+#include <linux/iommufd.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -665,6 +666,16 @@ EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 /*
  * VFIO Group fd, /dev/vfio/$GROUP
  */
+static bool vfio_group_has_iommu(struct vfio_group *group)
+{
+	lockdep_assert_held(&group->group_lock);
+	if (!group->container)
+		WARN_ON(group->container_users);
+	else
+		WARN_ON(!group->container_users);
+	return group->container || group->iommufd;
+}
+
 /*
  * VFIO_GROUP_UNSET_CONTAINER should fail if there are other users or
  * if there was no container to unset.  Since the ioctl is called on
@@ -676,15 +687,21 @@ static int vfio_group_ioctl_unset_container(struct vfio_group *group)
 	int ret = 0;
 
 	mutex_lock(&group->group_lock);
-	if (!group->container) {
+	if (!vfio_group_has_iommu(group)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
-	if (group->container_users != 1) {
-		ret = -EBUSY;
-		goto out_unlock;
+	if (group->container) {
+		if (group->container_users != 1) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+		vfio_group_detach_container(group);
+	}
+	if (group->iommufd) {
+		iommufd_ctx_put(group->iommufd);
+		group->iommufd = NULL;
 	}
-	vfio_group_detach_container(group);
 
 out_unlock:
 	mutex_unlock(&group->group_lock);
@@ -695,6 +712,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 					  int __user *arg)
 {
 	struct vfio_container *container;
+	struct iommufd_ctx *iommufd;
 	struct fd f;
 	int ret;
 	int fd;
@@ -707,7 +725,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 		return -EBADF;
 
 	mutex_lock(&group->group_lock);
-	if (group->container || WARN_ON(group->container_users)) {
+	if (vfio_group_has_iommu(group)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -717,12 +735,28 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 	}
 
 	container = vfio_container_from_file(f.file);
-	ret = -EINVAL;
 	if (container) {
 		ret = vfio_container_attach_group(container, group);
 		goto out_unlock;
 	}
 
+	iommufd = iommufd_ctx_from_file(f.file);
+	if (!IS_ERR(iommufd)) {
+		u32 ioas_id;
+
+		ret = iommufd_vfio_compat_ioas_id(iommufd, &ioas_id);
+		if (ret) {
+			iommufd_ctx_put(group->iommufd);
+			goto out_unlock;
+		}
+
+		group->iommufd = iommufd;
+		goto out_unlock;
+	}
+
+	/* The FD passed is not recognized. */
+	ret = -EBADFD;
+
 out_unlock:
 	mutex_unlock(&group->group_lock);
 	fdput(f);
@@ -752,9 +786,16 @@ static int vfio_device_first_open(struct vfio_device *device)
 	 * during close_device.
 	 */
 	mutex_lock(&device->group->group_lock);
-	ret = vfio_group_use_container(device->group);
-	if (ret)
+	if (!vfio_group_has_iommu(device->group)) {
+		ret = -EINVAL;
 		goto err_module_put;
+	}
+
+	if (device->group->container) {
+		ret = vfio_group_use_container(device->group);
+		if (ret)
+			goto err_module_put;
+	}
 
 	device->kvm = device->group->kvm;
 	if (device->ops->open_device) {
@@ -762,13 +803,15 @@ static int vfio_device_first_open(struct vfio_device *device)
 		if (ret)
 			goto err_container;
 	}
-	vfio_device_container_register(device);
+	if (device->group->container)
+		vfio_device_container_register(device);
 	mutex_unlock(&device->group->group_lock);
 	return 0;
 
 err_container:
 	device->kvm = NULL;
-	vfio_group_unuse_container(device->group);
+	if (device->group->container)
+		vfio_group_unuse_container(device->group);
 err_module_put:
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
@@ -780,11 +823,13 @@ static void vfio_device_last_close(struct vfio_device *device)
 	lockdep_assert_held(&device->dev_set->lock);
 
 	mutex_lock(&device->group->group_lock);
-	vfio_device_container_unregister(device);
+	if (device->group->container)
+		vfio_device_container_unregister(device);
 	if (device->ops->close_device)
 		device->ops->close_device(device);
 	device->kvm = NULL;
-	vfio_group_unuse_container(device->group);
+	if (device->group->container)
+		vfio_group_unuse_container(device->group);
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
 }
@@ -900,7 +945,14 @@ static int vfio_group_ioctl_get_status(struct vfio_group *group,
 		return -ENODEV;
 	}
 
-	if (group->container)
+	/*
+	 * With the container FD the iommu_group_claim_dma_owner() is done
+	 * during SET_CONTAINER but for IOMMFD this is done during
+	 * VFIO_GROUP_GET_DEVICE_FD. Meaning that with iommufd
+	 * VFIO_GROUP_FLAGS_VIABLE could be set but GET_DEVICE_FD will fail due
+	 * to viability.
+	 */
+	if (group->container || group->iommufd)
 		status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
 				VFIO_GROUP_FLAGS_VIABLE;
 	else if (!iommu_group_dma_owner_claimed(group->iommu_group))
@@ -983,6 +1035,10 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 	WARN_ON(group->notifier.head);
 	if (group->container)
 		vfio_group_detach_container(group);
+	if (group->iommufd) {
+		iommufd_ctx_put(group->iommufd);
+		group->iommufd = NULL;
+	}
 	group->opened_file = NULL;
 	mutex_unlock(&group->group_lock);
 	return 0;
@@ -1881,6 +1937,8 @@ static void __exit vfio_cleanup(void)
 module_init(vfio_init);
 module_exit(vfio_cleanup);
 
+MODULE_IMPORT_NS(IOMMUFD);
+MODULE_IMPORT_NS(IOMMUFD_VFIO);
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
2.38.1

