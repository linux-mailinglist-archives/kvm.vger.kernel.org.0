Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FF05E6BA7
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiIVTUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiIVTUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:20:37 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909B3AA4D4
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:20:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEAY9bdh6Eg4yBklRlQgZ3mGZa4AeguVTQDuiSl7Aw+kVRnvlSfWZLKHG2za6CERxEwK8LYAQnKb7+2fv8PrH5Ud7htrcUERm5XW76GghJgtIc2LkmVp96iEv0m9lZrNd52Szdrqude1PHLSxsQZBVzQsaqJp1NwWi3oqBuBEXhqsU7KHgDuPcR1laNKTHX6wU5t78AfN+/kiSVf4w3Ady7BwQna9CLjpxmo8zpCL888b1FAFbY5E1mefa4mZGRTzA9h+5/ehEtprpmtBXC5bWK/J0EiiDSM11mTQyUw5f3XkdZ9kp7j2O/XBwc5uR4MffiCRgDIW+WITmFyLZlw5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4TqVU91YxeCX2nfLVECvEbawYhqBuE84gZ563NACA7U=;
 b=HxtaFcXzgU90MpYAngwXoqz5+jFTUAEmPeF3EpwC3/YsVD90En/Z7y829xzVq5WRkEupTbPxy1d8tCtKBFyZsHlaHrQ5LusGLGhVtZS7F2Mf7TISasbB/ZPVFJ7FD7mIhtZNhmkUCNpPqy8yEjbRqoRkmZHVSey2InA6RajrLKY8CQrOqavgn41Kp+1/zAPkBbKO3nfF4E3aTzFgOOZLyqUsfSThT3KRlv6dmnqx9Dn5X6UWpW8AVsl+y8Wy6nzUTWHIb8N2P40xiaX7d3B/zvlaPqTUcP8KQ9n6XumJJ3OT+Zcmyjsy+59Ba6QNptIGhcj5gkZMkv0xSdQJI4pevA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TqVU91YxeCX2nfLVECvEbawYhqBuE84gZ563NACA7U=;
 b=IgMVlbHyz9zaUu5cJk/6JDadAeZMTWUXSE3HLbwsMBymC7sIq2Ux0i/0kovvwmDQJ14OUbI7nj1HKqpSc4EbWt27yo0I1pRCJeRQgT0WmIRLMQLDNuY12oADtYdIAu9A11SgpAL7Ihuw/haHOnStiUUfxkkoDXVrzLDNIZxfe2ObUhBrT+x8LuxkGvk4ug9IgouoCulBIK1FivveL6yRcBkwJs/wb4lU7MM5m0WK0+YQblQY6WgaptsmVBSeron4PpKgWA0hcd61NIfCHRlfogCsSrdQm4fSmnMprNbLaMMpfuOnCcScY+CGbCKJys6aLq1aFEJXkc8+MQ1I2qjDeQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5456.namprd12.prod.outlook.com (2603:10b6:a03:3ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 19:20:29 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 19:20:29 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v3 3/8] vfio: Split the container logic into vfio_container_attach_group()
Date:   Thu, 22 Sep 2022 16:20:21 -0300
Message-Id: <3-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5456:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a1b48c7-d906-42a0-feb0-08da9ccf8172
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PiDVnSPKpm3vcNqxy2WwH/5rLfQ6XXj2gDrDOBrzH5aUZXv+qCFHDZXRu6DqBcH94GMThmMIP8f8z/9ke3/cNFdvsW+mBZnguoRFXh0h7xLEfXZtreWYNjgL1wWStPONAJLHN6r16EGOEtHJMZ7vrcPPrFwxvWz1xOgmU5U+ZODrIgee0iyrSz+aR5xksd52qk79SxCFW+XuE/BTrvAFSKC2tdOzsj2HMm8zoqZPLxQXzrveJN685oKcF/4u9t9tWazsId6u8fPMaaw0fqgxhJOOvAY51w1LQDj0RqJUs7SEQp1Bd4PCX3JnFFxPWTgsdKIqja/8s8gcTmOIWgVJZ4MHbli70OYsOMMJu2YVsiwHUf7kSrFkpRMbKctSNx9+JufB8GAq035f5dN+thUMEPUUAkIwtTIGOc3hSr+NoX3S4eqV23OoavlTNy+7pRkjwriSrMLFq8vp3saWc/YKiPCT6G5i8crU405jC3n3Wm9SmV/AblF7se2f17URmckbOso2STgEL29mA55ih1fMIjg6lLsvaio9q8OsBGj/LaxCPLhk/1WaseW0pzstmS1K0V76O2//H+fawgJsNRNygWPZzvhvPf7mteN4fDZ+cRN3aKT9Qyy7EX8mG0nv5r9TVQl0B0BVGNCcruP64srZLsMGhVqh4fJYojmpoHgvNpHSZJ10ZU18XajDdjgjGhkjdJKN8Dg8cy/FPpUo2USptlB61Y6e1aO0MMz8WNAnptmcA0KGWHRqfVffdJ9QcQGZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199015)(6506007)(6666004)(26005)(6512007)(86362001)(4326008)(8676002)(66476007)(66556008)(38100700002)(110136005)(66946007)(41300700001)(36756003)(83380400001)(2616005)(6486002)(478600001)(2906002)(316002)(5660300002)(186003)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZMhM3Oios57tMVdvBiDsdhb3zwVWsqJvjSV7UB02Mbv8xIaDfkWLQaCi3QvY?=
 =?us-ascii?Q?q+GPqw7Wpi/lX2hmMt67fGo9ohy4rBWv/YXPhLOOgX5VJ1uAKKwvIADcOIA+?=
 =?us-ascii?Q?hbyiRRXRGnpxZ3qMYC85bQaVL+8bsSUtClMuvEi6EibMSZcMxJdADeLNRc26?=
 =?us-ascii?Q?6GOhTTsDmur5ad2508JqpiSCG+wiZj9Hfe5/+1HbEdwtgIe/BW8Lngg80mip?=
 =?us-ascii?Q?1x2KDCVyjZJvLyHXth8PmMkRwoPJMkzyPNnmEPEEACcGe4XoabK/F+7uYmlF?=
 =?us-ascii?Q?ybc54ywmVXbvys9WvdV/PnanioWdZaq7k7a8u8Zuoh6LNXKasGH6VbjCN0pf?=
 =?us-ascii?Q?ndee3tcZ7KFgI++n6IdfmGVHebI/L6Q9/DgUXUuNRmAnIseEbiqfu4S6t2wu?=
 =?us-ascii?Q?lyW5mqy1AM77d23NzYDCQJTK2BQJb12Bn0vtRDuDuI52c2MPZt1lZDcSGlY/?=
 =?us-ascii?Q?TLrJJ/QuJXW/vhenpoDVjnZsH5AJfwBL4fOHLk76QHwtJ0Wi2o4bSR122X0m?=
 =?us-ascii?Q?cLTvh9S83qQDxNIh2vCrnxAafWTRipD0nq7CwujYwjHu9F9xd+HgW/8cybJI?=
 =?us-ascii?Q?hpfjTFYtNGRjgryagVfATB2woJnPBLu3ahhZ0+FznxGkFHLt1xBQDrYOCgY1?=
 =?us-ascii?Q?hOluZVqxPNLssRLGRjryB6kvVyz531GL2cw4/LWuyik6QrfxBZRIOUuK0S5j?=
 =?us-ascii?Q?33DgiqjCy205qMKjnQdliUnaIkTYALLBp7o3263+FFvIiyOa7CjFg+Gt0FJY?=
 =?us-ascii?Q?flR80e4zbymQ3fUNpEvRGpq98+b97k9y+vqXwrb2zbHnd6ySjf7i+LyJ0WuD?=
 =?us-ascii?Q?IDut51/3kfpIqitZgO+XSDV6mh/O5X69euZyhSyzRKuqVRlit4L9pJqZ+XTI?=
 =?us-ascii?Q?2FJ0+STzyyKpobUlo0f+MzbQP7Y7aPwsfDBl1iVn58WOpmg46N2WKd9+RJ4o?=
 =?us-ascii?Q?watuhywrOgUrKqpcxzAfq1fTTXsy3WM2yVaG+86LTAjZIbyGF8++3uEWSNA+?=
 =?us-ascii?Q?Opag67DfdDpz3Jz2k3VhLctJJiNoPw34JstPqKvYV8gxf/TfLEIpaqyM4oBh?=
 =?us-ascii?Q?uW8YUI1a8TG+xfpEQbfbTI3kLah8xqeTlzi4SSFFspT1ROSbzM0xdz68JbBd?=
 =?us-ascii?Q?zX0IVhLjBtfObFxUkWesq6Lb+XZ0NH/pltpwI/v/RPwhJyIU1XhylDx3XXwd?=
 =?us-ascii?Q?y5jrkub2Tuic+mLPFQPmMY4B42lJXX6LKC6NHvB3FCOB5G6KkDLBsXQmO4T1?=
 =?us-ascii?Q?UmBZuBSpeaKNUy1sIDLfqNy84tk9ejCDCwWdHjj1RVNpP8nIrj8RymvC7AxB?=
 =?us-ascii?Q?xCa0mbfgn2OsvzR7JQ8zTGJM5L1wNfE2kDyFWBuhDx/zeQlnznst3sFtv/B+?=
 =?us-ascii?Q?+nIX6WNn6CqFOdshiZSTZqgg8ex+SIJt2erNF9tRSmjjAJDRsVZ8OI0KoAhT?=
 =?us-ascii?Q?ecYLalnRpHS9JNDUwRCmE2EtaHZ6vAcCsnkhShrqKkwEjoclFZ6S+pLG3f8j?=
 =?us-ascii?Q?umBgeu5NtJes0w6tLLq9nrydE3rGhB1xcXKqUb9/OSE4GfiLSQTVDRcdln1K?=
 =?us-ascii?Q?svtS5AK+6rYwMaPP66MmUGwu15jaO83uAaKsaJlQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a1b48c7-d906-42a0-feb0-08da9ccf8172
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 19:20:27.1712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLIdzH7AeYVAiC8T/7bfK/72OFOf3J/kIhBaEtWrkxYM6wJcpOeTK961XzKIhFJv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5456
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
index 3d8813125358a4..879c5d27c71276 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1097,40 +1097,29 @@ static int vfio_group_ioctl_unset_container(struct vfio_group *group)
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
 
@@ -1142,7 +1131,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 	}
 
 	if (group->type == VFIO_IOMMU) {
-		ret = iommu_group_claim_dma_owner(group->iommu_group, f.file);
+		ret = iommu_group_claim_dma_owner(group->iommu_group, group);
 		if (ret)
 			goto out_unlock_container;
 	}
@@ -1170,9 +1159,38 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 
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

