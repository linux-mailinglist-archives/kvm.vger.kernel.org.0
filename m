Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043015BF252
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiIUAmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiIUAms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:42:48 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D0952FC2
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:42:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIx7CtgsiO96wRxSuHiKgVAcc37uG0krbCV644lh8xn2PjTwLQu9obqi7cmdjEkMC6NOBslieuTvkpADNbaoy5oFMMtI/fxkmmMRr58N5uiWIMcGJcMd7iM1zFfKr2ZLOEV6h4lb+2w8B5+ZMKPpC68/J4Qr0NaP0Q2kOAAaFBmt1dtSGE4B2ZggPDN4D+cGO0XcX2uHMgpfdcYonD6p42T4XGZHMUPP0MhUwyp5Dn/cS0EnuwSqiTEMt3QmNa8piCd7SrCJPkRBIVxz2h5GjsuoUvbANErAjFwwADMN4Sv69wXIbHsGe/h5ntxF5+2kCjmr788dCF8op/YM91+3Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zElgfeNQff9PrH8OYTpMGdrRnSTAsLb/Ihqk1vjEohs=;
 b=WnI8rADPvLPnBEuiWJQZyzvT1msB9o9qpDUA13qH/WALkA+XbPCUoBA1kQzsEO+N1a8c06xXDSskWeRO9j6e64PENdpbaG7V+3kR/8KSj2TZ6EE8UZ0rqmZdp/S98XXMealaNUfuurJEJZMne8SpLCzS4miGA4sUlbqE7hAu4RwPIYbE6bmQcxyJjda2z0Cx9idZTYxWgjqB0fdvGjbjBPaWHQb0+plPYTYxLao6lnaJi1RzVxiNJFGm5Zw0OGLWMCmQ/U2bB1SC/DCVtbZAOMYx5m9kXi1q56VrlEoJT4QLFUL643ZMYXmKj5lY/HbEs/kxTxL1sj8jdC3vTk2hcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zElgfeNQff9PrH8OYTpMGdrRnSTAsLb/Ihqk1vjEohs=;
 b=Zd00u7lgKgmX/05C1mVZ+iGrfkrBMKJXy3P3IUaD4G/5IGo06u5APrhQCIx3UJDud0wegCooP/+5zli2z7goWiBn7N4lm0UNSubOtm8BoCVTCBWrJg30/h4Fz6KGEjLPXfl1rmSHJw9qrE8qWbPv7prv+oixObr/HN84j6TeX6bY7Y5nLCP2OUY9s4MHi9PUggfs617CpvehWUGAlCmBqZyLgmrGu0BxR+tKMYA2iZmPsoMoEji22AZQ5yXl33R2iRAKaCFQkWFWtPDl0Mrgi7lEWswEt9jW0yh0JipuZQmIqCxw87HyvcX2FMwCw08TZz7fVSdrWtWtFP+GyimQpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by CH0PR12MB5313.namprd12.prod.outlook.com (2603:10b6:610:d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 00:42:40 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 00:42:40 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 3/8] vfio: Split the container logic into vfio_container_attach_group()
Date:   Tue, 20 Sep 2022 21:42:31 -0300
Message-Id: <3-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:208:236::7) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4181:EE_|CH0PR12MB5313:EE_
X-MS-Office365-Filtering-Correlation-Id: 14cc7abe-e25d-4a51-da82-08da9b6a2f16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gy0q5emZTVlRsGo83Guv29eq2qcVMIzKdiA0yos9vWC+2omOi0sgNS9py6DszT2lKFivK5/lZeqMDlJ2of8VOSzy1CNxtPPhlxDHvzHKe1sIgu0KSPMTHv8/KX90YQnAhgJkaqOiJQ8IBmgCItKaRCDgJzRhTU4g5S3Y2Z4jLjXvA+GAo0Jy8coSGYwv3B27fGlJFtd+YcOuzGUwsZm85STsML0EakK48oYMIzGuGEOi+6ofIZOvbCtLQjCiZfqmdiE0vzMRLnISVGk0ZoK/r7DkJBNv/ZwxCwHKNbmb5fgkUf2y/RX9hBOuLzMMtezkCD9+xHH/BXX1f53NH0mlgJVhFZ2/lH2Nc8ZzgoO4Ckj1gwrn4e6cxCVbOImKiwcZ/22wOAkYzEMATmQ15OSLJZhJ+LiTI8DBIXOfm39GNOCROc+VMjanWt2ohTryxM8p9p2wRb3WpQgbF0sLQH3xHS4SMqVTYhx90c+96YW32SbeLmMtMym3DtjPtBUwlUhsLhJdm5Jcgpgytb+kz/yErNJDLvsD5dII9MZEZZiWMV15elKkLUV/HviKTQoqL5FHNUr+wsVy6i/FvvcSZVpqj44B6HMmoO41IXh1YfaVVFOspyueGY7AW1ZQFtMeSnIk8WFAwp/ZzXIlmS1xW1Ej7z1iuR7KiBlReMCyeaqHDTukPb4yikYgVvGuube23GshMywcRq4TCzeeu7F7tkzBEdwXkmRzbjY31ylGrpiTaFJvTfyR9jCk5OaJ5O04c6zs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199015)(6666004)(478600001)(6486002)(41300700001)(8936002)(86362001)(5660300002)(316002)(8676002)(110136005)(66556008)(66476007)(4326008)(66946007)(38100700002)(2616005)(186003)(6506007)(6512007)(26005)(83380400001)(36756003)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LetHRTEecaKr7DdiIc/w0VkPqV2YL6ZD43GJd+A3zSlSZ3i5LIdXAjaNRBP2?=
 =?us-ascii?Q?9QtXWyA3k4eECMdc6rmgN5GoWFiodQc5k+mFqe4b+M0Mp42U28a5nnfWaDtF?=
 =?us-ascii?Q?emoed7M0acDaH/rLqaa5iYpb3hDOdGV6ch86ZU9RLBOnqYwgRT0Lf/YeLwBO?=
 =?us-ascii?Q?1PKreCyOSaV7cGutwQuhYRRS6ETlNuenug8ovtnbnEsSz72CCd6nm8shdG3q?=
 =?us-ascii?Q?zZrvPKccqjqct+Q7efDPsJOwjECu1OWohnI5dAlCkWH08O00HuQLLiQP+VgQ?=
 =?us-ascii?Q?R/lbP4UsELATzolpLXNLQ6qa3GykfYQh87sQ0s6ub5879n/FB/sa29EP5Pwe?=
 =?us-ascii?Q?hL4wlm6FIQNISKsl99pqw0miMy4f4iUf0ri+6CliLZlg5C32Y+wZsFo4hQS7?=
 =?us-ascii?Q?KOMhB9E3uby+6Bfr5l45lwEVCzNlnC7IMWj3Z1SpV3m9cxVTcuOcUMMQayKg?=
 =?us-ascii?Q?jcvFV4nPL6O76UXj6goZ2/Fj9HqFeiNoFF90WzalSTFUMsYMkwJRuLd09+Wm?=
 =?us-ascii?Q?ktCPriLNPjAPPf6EuHjYaGgExYdEUMWwEBTnyMje/JACtwLXvFZ3fq+u9c/i?=
 =?us-ascii?Q?DFGK7U/kMiIN8W8togvLjXC0gR2+BmIylQTE15tmaPCRrmNndmvlLCxLSeZd?=
 =?us-ascii?Q?aVFuf2dxbdwYrBUhXx1sCoN03U/Jw4u2WqHs/uUjU3Huk27oFxxwB+4VWpU4?=
 =?us-ascii?Q?d432TDgBgRtjGyQxJccWTr0wSIKUB5LKWSy+nKjYeTRXrVOrhpj18LwqKFoz?=
 =?us-ascii?Q?UdrJT9X/oSgwDe9oB24G697EJ9bwScLPdPDnn4+ZlNjgRJhHV/zMwv057wZu?=
 =?us-ascii?Q?ArmfhrckuWAcAqd66+Lv5hDamjoScwN2lG9TyzdZYTXw0wGFEDA3IfYtIb7S?=
 =?us-ascii?Q?fwX/8+DXQvDPy0iA5sN8sbavQAmmeDncas9ckbQzXpUzclqWjwTTocT4GDZZ?=
 =?us-ascii?Q?qOgKPKxYiVAinBx+iVNZD4kpRPIbelGlJckqSAlqwG4ihGWmibrSYswTb8KC?=
 =?us-ascii?Q?JfSstcc7w3Cmc+dL8mEGG9UnBNikmKfqR1757wX15vn4STOFgKn6LB9TWWIo?=
 =?us-ascii?Q?y2TmjnL4rKzhLdb1ltseWe9UJfrrm5FnYteEHjEVz9QXwpnnoe+yh1hJy4bN?=
 =?us-ascii?Q?OcL5Sag2CLz5D/B5bOuo+EIUff2IO/GSJaz7cjeEI+bHNV0DrmvnmOKMYnM8?=
 =?us-ascii?Q?rDQqTcvZHglSYSgxx2Hj/jIjSqLClvfsICKmWyQu+Rx9ALlFXg3awdno5GCx?=
 =?us-ascii?Q?TN6U3cC+Q/jwIBtYoMuZKjINQJP/t+zdVoCQTH168bGucHh0ZaX8grqDpRol?=
 =?us-ascii?Q?2kL1uK8J48Av7C/ydu/BVtAXR9uoJ1ETxRFSiUjQzNjavROWlEl21IA0ZMdo?=
 =?us-ascii?Q?LV/YViO3W2j581cMDeBe3pGNi9wb5u5q7B/Ux9h+a3QF08EjbyDVE1HYpPC+?=
 =?us-ascii?Q?P4oBEkUfoKgpSwn/+fTP6culGCOozALuuGhxBVNnsmfVAeRsICH/D06G1jcg?=
 =?us-ascii?Q?OSmobGkd3OnBTAFb7rJvOg/jr10jZ1EQ0ZbuiO0KvzA345Lq8uNGH09D2VsG?=
 =?us-ascii?Q?hUkYwa2JKQ1r5C3bnHzTW6+e9XtQfk15UAmKReFi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14cc7abe-e25d-4a51-da82-08da9b6a2f16
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 00:42:38.5993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HlVZXXmr8hxEGOMBEVEuK0Esu/47Y1t9JgDfIL/Qutv4Z6nuhhr5EI+PmuUZw73x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5313
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This splits up the ioctl of vfio_group_ioctl_set_container() so it
determines the type of file then invokes a type specific attachment
function. Future patches will add iommufd to this function as an
alternative type.

A following patch will move the vfio_container functions to their own .c
file.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 78 ++++++++++++++++++++++++----------------
 1 file changed, 48 insertions(+), 30 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index eb2fefb1227e9d..aa6d872b105757 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -987,40 +987,29 @@ static int vfio_group_ioctl_unset_container(struct vfio_group *group)
 	return ret;
 }
 
-static int vfio_group_ioctl_set_container(struct vfio_group *group,
-					  int __user *arg)
+static struct vfio_container *vfio_container_from_file(struct file *file)
 {
-	struct fd f;
 	struct vfio_container *container;
-	struct vfio_iommu_driver *driver;
-	int container_fd;
-	int ret = 0;
-
-	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
-	if (get_user(container_fd, arg))
-		return -EFAULT;
-	if (container_fd < 0)
-		return -EINVAL;
-	f = fdget(container_fd);
-	if (!f.file)
-		return -EBADF;
 
 	/* Sanity check, is this really our fd? */
-	if (f.file->f_op != &vfio_fops) {
-		ret = -EINVAL;
-		goto out_fdput;
-	}
-	container = f.file->private_data;
+	if (file->f_op != &vfio_fops)
+		return NULL;
+
+	container = file->private_data;
 	WARN_ON(!container); /* fget ensures we don't race vfio_release */
+	return container;
+}
 
-	down_write(&group->group_rwsem);
+static int vfio_container_attach_group(struct vfio_container *container,
+				       struct vfio_group *group)
+{
+	struct vfio_iommu_driver *driver;
+	int ret = 0;
 
-	if (group->container || WARN_ON(group->container_users)) {
-		ret = -EINVAL;
-		goto out_unlock_group;
-	}
+	lockdep_assert_held_write(&group->group_rwsem);
+
+	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
+		return -EPERM;
 
 	down_write(&container->group_lock);
 
@@ -1032,7 +1021,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 	}
 
 	if (group->type == VFIO_IOMMU) {
-		ret = iommu_group_claim_dma_owner(group->iommu_group, f.file);
+		ret = iommu_group_claim_dma_owner(group->iommu_group, group);
 		if (ret)
 			goto out_unlock_container;
 	}
@@ -1060,9 +1049,38 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 
 out_unlock_container:
 	up_write(&container->group_lock);
-out_unlock_group:
+	return ret;
+}
+
+static int vfio_group_ioctl_set_container(struct vfio_group *group,
+					  int __user *arg)
+{
+	struct vfio_container *container;
+	struct fd f;
+	int ret;
+	int fd;
+
+	if (get_user(fd, arg))
+		return -EFAULT;
+
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	down_write(&group->group_rwsem);
+	if (group->container || WARN_ON(group->container_users)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+	container = vfio_container_from_file(f.file);
+	ret = -EINVAL;
+	if (container) {
+		ret = vfio_container_attach_group(container, group);
+		goto out_unlock;
+	}
+
+out_unlock:
 	up_write(&group->group_rwsem);
-out_fdput:
 	fdput(f);
 	return ret;
 }
-- 
2.37.3

