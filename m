Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D970A63C96C
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbiK2Udl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236225AbiK2UdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:33:22 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21D869305
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:33:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6SgF01WAzls8aVAcuZ9XVLRU9ymXGDeSlk0HCLzWNoIsrxTdRLecUJh5qqugwNaYpTbYQCi5pXTXAVMYNMz6CqOq6LLgOYX85rSs+GaOrjN8t+Lw4hPOdXB+M5ihARP0ylO9AIa1bSP5PjGV8Nm7OZv6qMC7By8mYZyGW/idCd8lyePzeQLCYgE/y8RzgIOEu766eN3UxLT1grerXEyozdLKpUZDrrBGYoelHUS6xl0NYEpV1kjGFNrCUciHtssxJHHBmuxDP7BNxaewYFUKXwIDhclS7zq8Xm9fTxiJXGFLwK6k2gRQsBu8GO2JsxPmjVwzPvuPIaMZofOQXxufw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kseaj8/9dOqCJVmrmN/BRcfi1L8vtPFnU2VYYfafvGU=;
 b=RO+BUy+n2UD+x1Z64Cwe+GyVd1lcmrd6l0zeiorNGlGKSfnBgX2QUN3/jfHLt36R8ecPGq9jzF9KngCZJ/gWFske/IwyPuLnvF9sqYKW680JIk8UNfb0/n5XqNwvGp1bORVC8PJJxBqbq+1z0mA+KRGA7ASIZ7Er88uU4I7cljsYcQefjA9Lh5nNIx9g/ayEE6lC1ooGc5ANAMH/iURcNdeM6Za/WAzuvrG+JGn1zEwLDXxHXMOXSya/hF73d5b4S5TRNGEuIZ8PVGM5hoKH+60GaMsxgQU5QkFmF8NcmooO/EHufTS6BwCkh3/sBLtgeIXah45FZJUlE2sRhmEc/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kseaj8/9dOqCJVmrmN/BRcfi1L8vtPFnU2VYYfafvGU=;
 b=cCwMlZ9GSWd5M3EzVJeKROr/ublbfisutm4I2E4Um1hFglktjU/602N/wTSd8Nu+mM6xc2GlF6KGUwnwEsmaaL14gFB30q+CD7HKdP8Lo2i5ayzRQPI1RhRIGzhGP/rMb7B0ewXNPFHs9YmYBJyc2/KOx7mBTUJz7fZnYDsfnXW7qynegYYMGTR+GIBzmPAtg4UvWW3DcQdw0b12i13UhSKGMWBq8D8w4ryT3vfrJU9ik08ecpHx2CoMHEcobWjBt2Jt9FxAjcfo/cVoTmwElhnUllPfKCE6HCziqJ9rhT0ymUiiG4f67wd/Zxr5GvSsd9wzQpOfbvLtUHwwDsgU8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:32:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:32:03 +0000
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
Subject: [PATCH v4 05/10] vfio-iommufd: Allow iommufd to be used in place of a container fd
Date:   Tue, 29 Nov 2022 16:31:50 -0400
Message-Id: <5-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e9aea2a-39cc-4882-9fb7-08dad248c37f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EqEjZYDULGLvwI6nnA7ceDDDGYtMx1DpP95h9DKekNvgtsGO0dyoIftTDQeqSIQoIBy0XpheTq3Fo4zWi6+v0HioaX8l+RLOIpo2zCIb6eiJ+/d86cwXk2IDvwSS13rVX+vdPM2dRzYCvOkUPHqz7yy1iMrWDIwli9nhK1i4RA75yKq9GFWUbHv9G4Y3B/pDpZRAXGk0Qtuehg5Xd5BG42P4jIbcW+DJheZBpdLkwkHG6M1wcW7YM91eJELs2/AT6dq5niYXKkx2hDzcnttl/ljcJRW/NMAx4izIXu3xYubhv7NAYPOQOP+ghTiHB2qyOVErwPmBkn2D/gm+4/xMq2dhDsDQC5odm1ESuSlAUDjMTAzA8Ca/OUQsRds5vj2ctgeR4TAiuLCsVxvOfALwrQ8gDM7PsB1+udkLOhYF3lfJepwuebCHpOEO2VG9XAmycWRFmGXPikYj0iMMcWtHtZuStkM99T4m33yrU9dVOMF5YkhxOhh+5qat7L/Y19CondHiTHr42ej1X7uwK8WEwn/BEtcbxr2GuyEJ6DvbyjRFiJiQEQ8BOX/521nkuL1pz6fOr+B5mLSpHffo/KTAhxjOQw8f/1zhkdKih/FuFdTbpKwubLcMIwH3mkvsq0yguubJ045mA+RRQ6hQvS2k1db2afwbHjERI7AX3tLQ15o/PV+72bwJqkuP18TOHHvzzosREODNpJT8AK8Rn1xlbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(109986013)(451199015)(5660300002)(66946007)(7416002)(38100700002)(54906003)(186003)(6512007)(316002)(8936002)(36756003)(4326008)(8676002)(6666004)(66556008)(26005)(66476007)(6506007)(2616005)(41300700001)(86362001)(478600001)(6486002)(2906002)(83380400001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DTKkbqlDxBKhlUM6n3rcfNVpSc5C+K4AGUqd+/SclnwD/DxqVa/3FCGl67G6?=
 =?us-ascii?Q?G/KC+cinpouHcTZQ97k9e8s8s9CtEOyL+pM3n0oWXej5VuJFRIwgKgPHAdRr?=
 =?us-ascii?Q?jm9RhA8/iuye6Wa2kYx2M0AbQOCPvRfpLnjQgnQ5/pu5mud8XgEHotMGx2xZ?=
 =?us-ascii?Q?EbazGyp2bVR+T5PlU6vEkTdkJayIDXFa4VXqSDvFHqmxZyzXbeXFyD9nx9eT?=
 =?us-ascii?Q?ug2QP5dBrW5ffp8tMMznSHtzJ3FtYktIuq1/9KjpXnLL8Znpw1QGrFZGZR/w?=
 =?us-ascii?Q?tGqohnlnEGoYsMQbaF92IaP0o89K1ImVbI0jDXVm86kvMYSdvi1nLaZDBf7U?=
 =?us-ascii?Q?BOIeUn7dzsDBX8AjAOI9tEraJIItZFEyOHrEgFqOtP9mlJkpN7XTGucKfW62?=
 =?us-ascii?Q?sRRAvPqPL5wlY/UWRrgLXrULL3kg/mxlZY7TjmnaWVMgTvDpX66omkU1vYj1?=
 =?us-ascii?Q?WGNxrNaGZYDRey7YL4ulGTJcbBWu4XSzMQIMZAXwEn98njK+Gf4nwuIthpC5?=
 =?us-ascii?Q?7QBtOUiON94zlyFsWPKJhtevY6kBKdnr+sD4NCWyK7T1WeMMnvMe3laG+Vi+?=
 =?us-ascii?Q?W95MOhDuYN6gCxK5P39y1GeysRH7ykFdpkmQZcZPvzMB/ngqvkKooDq0psMg?=
 =?us-ascii?Q?f6S75Ykiy62hawoh0MuLMyiP143jja+TysqjKyURWw1p9r+Ghf5M2RS9f6Dt?=
 =?us-ascii?Q?MHD3vwPV5EZEV/mfrFaWVoh6sRn8OxxEg1NBpcANb5ZYtkUqvrD9wBpz1vNp?=
 =?us-ascii?Q?gOWdbvnIsy/Owe8oLdt8XUMQXnbFP76j44W8FHq53I/GhD96cVGLLbU9Wyml?=
 =?us-ascii?Q?2GIlozxj5bJoAY5TjcIiB3bbqwc6l+WnvD90LWkoe6ISfF35/r7tVSNDCV2B?=
 =?us-ascii?Q?jeWdqeydqGqqKpnr5UU2KM4jdnl3Jdy0Ly0jcYCdK1DnPCqgTa767JGWhjP1?=
 =?us-ascii?Q?37w2XDWknMQT2LrQljbQlWPxoAixXf/3oicboMZLh0Vzq2253PdstQ+HxqTV?=
 =?us-ascii?Q?IecAujKfZM9WtAArqpjDg7kKbJL8uvC5es21Bbpf861U/08szZ/ZBvtCKKAZ?=
 =?us-ascii?Q?xIEnF//V3PXVZxEO+tMT5Riv3I7V8sN8L6Rg+ELNfatWlhdRJttQFTPaIH2g?=
 =?us-ascii?Q?/FAJYvBIVCAqfAWNlo6oGxe6OikL9M4WFfqdhfF68Z34nPDnlap8ydtyi+I7?=
 =?us-ascii?Q?Cx0R0qdklH4gizEKrzfmCIsgnDmhkQyQCs8ZpzWmE5ytz6GTIEL9O3wRrYid?=
 =?us-ascii?Q?T3icEvi8i2COBqWoMvxQKMh3OBd/gwSWMrJmAATfI4IiG69rNosRdoam8s4o?=
 =?us-ascii?Q?KSkh5XQN+JPMRf/c20phfGqL0nBbhyPwf89CmTcyK0iKslpSdOPMOFQ3xhnW?=
 =?us-ascii?Q?uMCFmpbXoGPrVguLp/N0oOP9xMWHS9pbB+qS25umda92LmYxzxuMzK8EYhaJ?=
 =?us-ascii?Q?I/UMDgpcJ60NdIbbj03nYAOE4EGFCqxXvuvuXkehQXZ938nPkUi4hnsngszt?=
 =?us-ascii?Q?mEv4kN+GmEiSZcVbDPlfjwZeS6eftoYFh/smCi/rIzr5HrdQoT7bgTwG8457?=
 =?us-ascii?Q?M6J3Y6sBl2CaTMsRTSHOSHCgn7gaJztdVz8utLJ2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e9aea2a-39cc-4882-9fb7-08dad248c37f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:31:58.9963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8V23CsUIYaLLlUQs43lQWRxDT/n24sUicTCXsrPD5jAyIgrP82KLqOJC+7/efXoM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5688
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
 drivers/vfio/vfio_main.c | 88 +++++++++++++++++++++++++++++++++-------
 4 files changed, 82 insertions(+), 16 deletions(-)

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
index 73156125870427..a9dd0615266cb9 100644
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
index 77d6c0ba6a8302..f11157d056e6cc 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -35,6 +35,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/interval_tree.h>
 #include <linux/iova_bitmap.h>
+#include <linux/iommufd.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -662,6 +663,18 @@ EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 /*
  * VFIO Group fd, /dev/vfio/$GROUP
  */
+static bool vfio_group_has_iommu(struct vfio_group *group)
+{
+	lockdep_assert_held(&group->group_lock);
+	/*
+	 * There can only be users if there is a container, and if there is a
+	 * container there must be users.
+	 */
+	WARN_ON(!group->container != !group->container_users);
+
+	return group->container || group->iommufd;
+}
+
 /*
  * VFIO_GROUP_UNSET_CONTAINER should fail if there are other users or
  * if there was no container to unset.  Since the ioctl is called on
@@ -673,15 +686,21 @@ static int vfio_group_ioctl_unset_container(struct vfio_group *group)
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
@@ -692,6 +711,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 					  int __user *arg)
 {
 	struct vfio_container *container;
+	struct iommufd_ctx *iommufd;
 	struct fd f;
 	int ret;
 	int fd;
@@ -704,7 +724,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 		return -EBADF;
 
 	mutex_lock(&group->group_lock);
-	if (group->container || WARN_ON(group->container_users)) {
+	if (vfio_group_has_iommu(group)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -714,12 +734,28 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
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
@@ -749,9 +785,16 @@ static int vfio_device_first_open(struct vfio_device *device)
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
@@ -759,13 +802,15 @@ static int vfio_device_first_open(struct vfio_device *device)
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
@@ -777,11 +822,13 @@ static void vfio_device_last_close(struct vfio_device *device)
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
@@ -897,7 +944,14 @@ static int vfio_group_ioctl_get_status(struct vfio_group *group,
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
+	if (vfio_group_has_iommu(group))
 		status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
 				VFIO_GROUP_FLAGS_VIABLE;
 	else if (!iommu_group_dma_owner_claimed(group->iommu_group))
@@ -980,6 +1034,10 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
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
@@ -1878,6 +1936,8 @@ static void __exit vfio_cleanup(void)
 module_init(vfio_init);
 module_exit(vfio_cleanup);
 
+MODULE_IMPORT_NS(IOMMUFD);
+MODULE_IMPORT_NS(IOMMUFD_VFIO);
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
2.38.1

