Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEDC5EF832
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 16:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbiI2O7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 10:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235789AbiI2O7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 10:59:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCB8149793
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 07:59:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGkOT4koaeHsgY/akWb55gZhkPxA9kwfVulbdyTyVrL0sQ/CmwqFiBF1RxaGlVlvgQYeOecFvMltEdrDgkqtDnQG27zTYSZCRom+fEzau2SSB7h82UB+jpfewApMBKzS6SlGuPq0dt1Xi1wcLLjMgIixQ20sltf2o4J5MxfRDLE4oyHex8pvSdcEPg80hzg5PJEGq5vFcozmciFZ+WBB6VcCNEAkEAPK3viMih8UayQ0WizMRKFeTYnQbqUjLDssuk+eXwfap9sSUU9+lm4aLggx1NgQZ0ve4BLazqP6aSC7Kv/T8EhZM64O3ydO8D5kq877muFmintV96PgFocHAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eynq03dWRJcj/2hoKDOULvHOugc+MBIdpZL2y+sS2FA=;
 b=b7BsUD/ZLf1ms9NdgBij+KVh4BvaGQwwlipBA+EpPdgBuefjqMl80F3BmOj7AUwJ2Rlxh9DlQHoN65+xHtDWGEqdOiGSF5fVuxunPmQl43HDSSQA4Uu4fTZp71XqzULsDjp8+YPC+LdLMIdrfWwZt7gci4g4Q3ZJWPV/1JicS86C3bKgzaRgj1QGr/4N1eUX4ZmDXvqd0CeK3weAkvu0K9Mg/1WAZP7049hTF+jHLtjamBPEZ114JDIx7clHvQ5PCXXZT6ZgjR0E/LTFZmAyXLOhkXCxx5ff1PhQxKpeHZWG3Q/J1+IahZsfjNjbC/UGp1eoiYzOEhkLW8aYQDUV7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eynq03dWRJcj/2hoKDOULvHOugc+MBIdpZL2y+sS2FA=;
 b=gyyOyqtYMqI9zELJBvz6b/bvB5XLUnU6caRIkj/20NlVk6A2m0DjEoD8Xiw89zaBiupIT3OwpdEkAa4IYllx1Z1rWDHd+fnhoLCWW7qKqDY/EjuAh4nYcj9Y503tQNNbBGx/GhlwzaBniMB7NuQF5dmul6v+dMa+iQynO525RVVmJrVRZ/g3c1F/NiIaWzmmaFxvn4uY/Y/MpugXL2QXdnyu+1I2YUQ+g4PALoiOvYqTT7n9xwjVw3zknLwuYfKJZgkpyOZ048TRF7PMGQ1mbSIHMRdTdR/SbYrQs4S/4XUrlVq8GVg6IOn20Yq/fIXPzIoMLJRMxA1iA+nvz4SCfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS0PR12MB6389.namprd12.prod.outlook.com (2603:10b6:8:cf::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17; Thu, 29 Sep 2022 14:59:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c%5]) with mapi id 15.20.5676.019; Thu, 29 Sep 2022
 14:59:27 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 2/2] vfio: Change vfio_group->group_rwsem to a mutex
Date:   Thu, 29 Sep 2022 11:59:25 -0300
Message-Id: <2-v1-917e3647f123+b1a-vfio_group_users_jgg@nvidia.com>
In-Reply-To: <0-v1-917e3647f123+b1a-vfio_group_users_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0177.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DS0PR12MB6389:EE_
X-MS-Office365-Filtering-Correlation-Id: 27e75313-2d49-4a6b-5a80-08daa22b3427
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w6kHSLo7wv9d/RAvsTKR7VvaTzeZQTWbMMABhS4/E3fGq9SZcoTLk38BQ7zGnVLrKQnoQPN447vIhTrSsKKj+2U+TfaJefWd5BvliwljdIif45esW53XWfZqSvXhW0+AA94rO71r0uq0bVd53vaf3avHE2y7dS/k+rObJTqlx6IDlORVw0LicW8+c1QKgZV4Sow3tVwT3ssPFblZnNeTL1VDENu5+egqvfKLRYu5uMjVXAJRi7CJ4CjIzqJJr3lfDnSvXmq2NzPuFcgkAAjfqlxEAZw0qkl/j9mxqPko/jqCsFY9/+3dSmk46AIX+hjEw/hIQsUaLMHRY9YLa+W2mAxT62un54Eb6Pub/RCYY7tjtE7bWe2AIT94neB3Hd0txcmy7A9y8WqaRKQjJAenCO1vBf9K2v46lR+NrDO4zsP4bsZldM0VbQCAkgdv0YW5KCxDJJwcUCJEeCmy/EB6HsrcAiMsy2CZ6xq7Tl+vzK+yZiPlmonEfiCEIsa0HPpOopdTlhL3w7zMf9Qx/PvvoToXmOPLOP+/upe1eMC/17Ji4PDA/Ty+UaWUxezxO3Kr/GbRyIwYUl3q7hhBQ3CyDy81xsXIhHROMdkq7KZN3i3blqYMJMr72QK9esAIIbvpGMvp2QKWIvxjTjcpvcbrNOYezmR7ZsmISWNh0VkHfdSaqPpwQYTgmBGHtdFhydYFmIjBi0c6//Y08a3sgFgShNhPzlnaVL9OEnYWDkuQ05qG/Wj0XhcRVJCj/z3zGJYa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199015)(6506007)(478600001)(110136005)(6486002)(26005)(316002)(38100700002)(86362001)(2616005)(186003)(83380400001)(6512007)(2906002)(8936002)(66476007)(41300700001)(36756003)(8676002)(66556008)(66946007)(5660300002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KkyOC/YvPozgjP7B1rT8viunvURQOCGUO64q6qk5G9X15M8zpMk6uXbuGJ2x?=
 =?us-ascii?Q?dhb40korAyvjhrLCW1HoEpnrQzJj14ric8ySitrUnkuL5+h9qtpn0TJljTNE?=
 =?us-ascii?Q?DGKTACIGWUh/Pids/LMMZiv8uvb6fMnrqBxCy36cKCDpUG+nZGku+dYTRd2k?=
 =?us-ascii?Q?iROf9wR2Vwt+D+ywwhOVAA1EXez6baPNbDqHqHBrRG09l52mTImLAFPmrY9i?=
 =?us-ascii?Q?zjgt+pO6y6y5cJo8cK8foOEEv3HyP1vDPIwUY4ymGCEm9h1x3tOm9nxBFW6T?=
 =?us-ascii?Q?2eqzj01bGtt/S3S2gjPTJ4qLqBmetsdorjhkBXxkQGf14CSoJHwG7F6V2Ty+?=
 =?us-ascii?Q?+2U/YL47XJabFjkSae04MThhWw7uhFDU0SwMRICtmJuUBRGYkONijKQyHJ5A?=
 =?us-ascii?Q?U7AeTAxGIyCH1IKq2X7XWXrjpwQ1m7wXAR6QQ7uF7ZWRjmnb69rMB97yf8Qb?=
 =?us-ascii?Q?G0aj6LacG+B4QKEudaGbKL9I7xFZHs0ywvrHMMMdTi2iER4gHVgVc7kkMnp/?=
 =?us-ascii?Q?G9bEnN2y8jSIrtWkWulqQ1FE11H1MJu03mNscEl7y3Sh81f+BAUnJWUhApNq?=
 =?us-ascii?Q?6ghZ32SvakhYQ0nPxCeVeame44OosmRXKdoizXx7qS3z00eta6+HOu6Vwk8m?=
 =?us-ascii?Q?vG4Og3wcE6CpwFAZ8VkGA/ij20mecyTxjJyEglOkl3tky9vsuPSOUP6NQEsA?=
 =?us-ascii?Q?L0whTFhL9vKkR84JrDfxgEcPz3fNHiCg44judwodBsmFKlRa45fIRJ+9GUBB?=
 =?us-ascii?Q?7LXqjia5E9l00C+nD7SF3q8J2Em68mdRIOipJwBL6x4DSw4qOGJJbZL5eoqq?=
 =?us-ascii?Q?nB/D/WW45q8JFXnyRJJHCOSFiCtAXr02S7ILd1DBYRhVVdDCTNP32x9qiXwY?=
 =?us-ascii?Q?45LtApWIyOxA378OP1DMUUe1Hz2FHraAidvEglGeXhXahMaM6YbODhol4de4?=
 =?us-ascii?Q?6tO0Wjxv0QDFHjX0F7hp7axyk5mlxhVUVynm+dZZ9p5ix1FMAQt75t2JiwEJ?=
 =?us-ascii?Q?EDt1JEOpz0r5V/gWNIS4ClC51Yq5YB+LdU8XysBzgowLcTdF+pohoDFxvxqi?=
 =?us-ascii?Q?S+EOsjy579ZqJy8RNY17fbMSJGoHavG1TuN7EBwywCD4xRzCtOMtJja77ztZ?=
 =?us-ascii?Q?Uq2fyYrhaiVlZKkj0YiW9VwUFpVY3Ee8kOyX548JYhfqrERx50lpQketv1z/?=
 =?us-ascii?Q?I/BX8KcSJpX+AMjHszilbOAjqPfn6k+F/APhMmhDYI4bUd7hSOFuzaiFqx2z?=
 =?us-ascii?Q?y2XV5HPMTPAZtPLSYh+M919mabyJAK2m1onB75fyrFzLz6W7c1LLDADJfQJZ?=
 =?us-ascii?Q?OKl9bzggNB2lsfB069crVwx5FSry+hOF4KBqifE3ik76enO2uRTirfeLLyj9?=
 =?us-ascii?Q?gP4EJyz+k4kqp5//Y2+F+hn+FIR9/eG9Wq9LAb8ASU5C2lJ/XKdG0+hj1xt4?=
 =?us-ascii?Q?n/7KFCS7ZpdQKsoc0xSixZKFj9/MDnG4Lx/6lWCNlnnEQUUY3Pkx5UrR8tCr?=
 =?us-ascii?Q?J2smmfgAYy498IFTH/jcH/kyo5Ix6H/2HKJC3vgOrMlisfhYCmljLZrXZRd6?=
 =?us-ascii?Q?R+m5R8CvScvehXnNxCk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e75313-2d49-4a6b-5a80-08daa22b3427
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 14:59:27.0040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oLObUV5uYSGStVGr7VA7HydCvbUoAqutbUT7ZG3M0wovKfJwvN9eSsGTMKmovq8F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6389
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These days not much is using the read side:
 - device first open
 - ioctl_get_status
 - device FD release
 - check enforced_coherent

None of this is performance, so just make it into a normal mutex.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/container.c | 10 ++++-----
 drivers/vfio/vfio.h      |  2 +-
 drivers/vfio/vfio_main.c | 47 ++++++++++++++++++++--------------------
 3 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index db7c071ee3de1a..d74164abbf401d 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -430,7 +430,7 @@ int vfio_container_attach_group(struct vfio_container *container,
 	struct vfio_iommu_driver *driver;
 	int ret = 0;
 
-	lockdep_assert_held_write(&group->group_rwsem);
+	lockdep_assert_held(&group->group_lock);
 
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
@@ -481,7 +481,7 @@ void vfio_group_detach_container(struct vfio_group *group)
 	struct vfio_container *container = group->container;
 	struct vfio_iommu_driver *driver;
 
-	lockdep_assert_held_write(&group->group_rwsem);
+	lockdep_assert_held(&group->group_lock);
 	WARN_ON(group->container_users != 1);
 
 	down_write(&container->group_lock);
@@ -515,7 +515,7 @@ int vfio_device_assign_container(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
 
-	lockdep_assert_held_write(&group->group_rwsem);
+	lockdep_assert_held(&group->group_lock);
 
 	if (!group->container || !group->container->iommu_driver ||
 	    WARN_ON(!group->container_users))
@@ -531,11 +531,11 @@ int vfio_device_assign_container(struct vfio_device *device)
 
 void vfio_device_unassign_container(struct vfio_device *device)
 {
-	down_write(&device->group->group_rwsem);
+	mutex_lock(&device->group->group_lock);
 	WARN_ON(device->group->container_users <= 1);
 	device->group->container_users--;
 	fput(device->group->opened_file);
-	up_write(&device->group->group_rwsem);
+	mutex_unlock(&device->group->group_lock);
 }
 
 /*
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 78b362a9250113..4a1bac1359a952 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -56,7 +56,7 @@ struct vfio_group {
 	struct list_head		vfio_next;
 	struct list_head		container_next;
 	enum vfio_group_type		type;
-	struct rw_semaphore		group_rwsem;
+	struct mutex			group_lock;
 	struct kvm			*kvm;
 	struct file			*opened_file;
 	struct swait_queue_head		opened_file_wait;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 57a7576a96a61b..9207e6c0e3cb26 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -158,6 +158,7 @@ static void vfio_group_release(struct device *dev)
 	struct vfio_group *group = container_of(dev, struct vfio_group, dev);
 
 	mutex_destroy(&group->device_lock);
+	mutex_destroy(&group->group_lock);
 	iommu_group_put(group->iommu_group);
 	ida_free(&vfio.group_ida, MINOR(group->dev.devt));
 	kfree(group);
@@ -187,7 +188,7 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 	group->cdev.owner = THIS_MODULE;
 
 	refcount_set(&group->drivers, 1);
-	init_rwsem(&group->group_rwsem);
+	mutex_init(&group->group_lock);
 	init_swait_queue_head(&group->opened_file_wait);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
@@ -665,7 +666,7 @@ static int vfio_group_ioctl_unset_container(struct vfio_group *group)
 {
 	int ret = 0;
 
-	down_write(&group->group_rwsem);
+	mutex_lock(&group->group_lock);
 	if (!group->container) {
 		ret = -EINVAL;
 		goto out_unlock;
@@ -677,7 +678,7 @@ static int vfio_group_ioctl_unset_container(struct vfio_group *group)
 	vfio_group_detach_container(group);
 
 out_unlock:
-	up_write(&group->group_rwsem);
+	mutex_unlock(&group->group_lock);
 	return ret;
 }
 
@@ -696,7 +697,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 	if (!f.file)
 		return -EBADF;
 
-	down_write(&group->group_rwsem);
+	mutex_lock(&group->group_lock);
 	if (group->container || WARN_ON(group->container_users)) {
 		ret = -EINVAL;
 		goto out_unlock;
@@ -709,7 +710,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 	}
 
 out_unlock:
-	up_write(&group->group_rwsem);
+	mutex_unlock(&group->group_lock);
 	fdput(f);
 	return ret;
 }
@@ -727,9 +728,9 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	struct file *filep;
 	int ret;
 
-	down_write(&device->group->group_rwsem);
+	mutex_lock(&device->group->group_lock);
 	ret = vfio_device_assign_container(device);
-	up_write(&device->group->group_rwsem);
+	mutex_unlock(&device->group->group_lock);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -746,7 +747,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 		 * lock.  If the device driver will use it, it must obtain a
 		 * reference and release it during close_device.
 		 */
-		down_read(&device->group->group_rwsem);
+		mutex_lock(&device->group->group_lock);
 		device->kvm = device->group->kvm;
 
 		if (device->ops->open_device) {
@@ -755,7 +756,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 				goto err_undo_count;
 		}
 		vfio_device_container_register(device);
-		up_read(&device->group->group_rwsem);
+		mutex_unlock(&device->group->group_lock);
 	}
 	mutex_unlock(&device->dev_set->lock);
 
@@ -788,14 +789,14 @@ static struct file *vfio_device_open(struct vfio_device *device)
 
 err_close_device:
 	mutex_lock(&device->dev_set->lock);
-	down_read(&device->group->group_rwsem);
+	mutex_lock(&device->group->group_lock);
 	if (device->open_count == 1 && device->ops->close_device) {
 		device->ops->close_device(device);
 
 		vfio_device_container_unregister(device);
 	}
 err_undo_count:
-	up_read(&device->group->group_rwsem);
+	mutex_unlock(&device->group->group_lock);
 	device->open_count--;
 	if (device->open_count == 0 && device->kvm)
 		device->kvm = NULL;
@@ -860,13 +861,13 @@ static int vfio_group_ioctl_get_status(struct vfio_group *group,
 
 	status.flags = 0;
 
-	down_read(&group->group_rwsem);
+	mutex_lock(&group->group_lock);
 	if (group->container)
 		status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
 				VFIO_GROUP_FLAGS_VIABLE;
 	else if (!iommu_group_dma_owner_claimed(group->iommu_group))
 		status.flags |= VFIO_GROUP_FLAGS_VIABLE;
-	up_read(&group->group_rwsem);
+	mutex_unlock(&group->group_lock);
 
 	if (copy_to_user(arg, &status, minsz))
 		return -EFAULT;
@@ -899,7 +900,7 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 		container_of(inode->i_cdev, struct vfio_group, cdev);
 	int ret;
 
-	down_write(&group->group_rwsem);
+	mutex_lock(&group->group_lock);
 
 	/*
 	 * drivers can be zero if this races with vfio_device_remove_group(), it
@@ -926,7 +927,7 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 	filep->private_data = group;
 	ret = 0;
 out_unlock:
-	up_write(&group->group_rwsem);
+	mutex_unlock(&group->group_lock);
 	return ret;
 }
 
@@ -936,7 +937,7 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 
 	filep->private_data = NULL;
 
-	down_write(&group->group_rwsem);
+	mutex_lock(&group->group_lock);
 	/*
 	 * Device FDs hold a group file reference, therefore the group release
 	 * is only called when there are no open devices.
@@ -945,7 +946,7 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 	if (group->container)
 		vfio_group_detach_container(group);
 	group->opened_file = NULL;
-	up_write(&group->group_rwsem);
+	mutex_unlock(&group->group_lock);
 	swake_up_one(&group->opened_file_wait);
 
 	return 0;
@@ -1001,12 +1002,12 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
-	down_read(&device->group->group_rwsem);
+	mutex_lock(&device->group->group_lock);
 	if (device->open_count == 1 && device->ops->close_device)
 		device->ops->close_device(device);
 
 	vfio_device_container_unregister(device);
-	up_read(&device->group->group_rwsem);
+	mutex_unlock(&device->group->group_lock);
 	device->open_count--;
 	if (device->open_count == 0)
 		device->kvm = NULL;
@@ -1580,7 +1581,7 @@ bool vfio_file_enforced_coherent(struct file *file)
 	if (file->f_op != &vfio_group_fops)
 		return true;
 
-	down_read(&group->group_rwsem);
+	mutex_lock(&group->group_lock);
 	if (group->container) {
 		ret = vfio_container_ioctl_check_extension(group->container,
 							   VFIO_DMA_CC_IOMMU);
@@ -1592,7 +1593,7 @@ bool vfio_file_enforced_coherent(struct file *file)
 		 */
 		ret = true;
 	}
-	up_read(&group->group_rwsem);
+	mutex_unlock(&group->group_lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
@@ -1612,9 +1613,9 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 	if (file->f_op != &vfio_group_fops)
 		return;
 
-	down_write(&group->group_rwsem);
+	mutex_lock(&group->group_lock);
 	group->kvm = kvm;
-	up_write(&group->group_rwsem);
+	mutex_unlock(&group->group_lock);
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
-- 
2.37.3

