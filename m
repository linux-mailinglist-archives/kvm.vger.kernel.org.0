Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4017E52956C
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349375AbiEPXmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348883AbiEPXld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:41:33 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4877019293
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:41:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2meh9+OZbFmSP5C9lRxKWxRoTDnzXukEQO1Vbsg/TkrZFBeLkkvRHC5S3TUMR2ZcG18R03PStYUAcQ2m3K9H/CY30B4zcsuf7o7p0v8VR1Ewh4ta2x02qq+r2lW4MqUNGbWe6gMERyjkAHF3F+/e8zydMTQpx4yseSsqND6LHK7g9cArzNTQ4pQkDsIzc2naxJBgpFBQpwbqZpGRv8b/0G6PXpK94x9jUd6sg/MClO+9Ruj+ncWWWjfZGDCllfzOmSwa0LHazlah6KQwUxE1nScghATNr3x2h43Y9p134qfAZUi13JyB9KmvkmUtW2GiIWELYdg91GFlLifsw74Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIekNo3frixrNw6KPRre+elcl2/SOnn0zlHwiDAUfaA=;
 b=BU4coKi13An8eP6Wjtnge4uGPw5nRs1OifX90b9IN51/snT1BAuII4qn8oufhZGyH/JBpI5NwB3S53RlV9/J//8yTZcxyGhdcKWuaFjtBxPem2TAzelEUVgLSipnpytrCJXhTDgYnwhGm9aQhvEkTPvfIOQfOq+YB0KvVNL/26cAMyUg3ssD2uIw7dp3s2D8uADV0DOpdiUIXPTaD0XRfM/UQoeE2+sry6KIfdj7kH84cdg130ws8Eb2QrbpDT5p+HlqAdHTmBkt4k5/WKdU1wfJKOpoksY5U/hN4rzmB6ZlYbb3O76zqw4k1CXQgtS61AxXYPR7/Ntq0yTQRV4p9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIekNo3frixrNw6KPRre+elcl2/SOnn0zlHwiDAUfaA=;
 b=qN+KbjYDGU8QkeowJYZNLNJ62LfhtGnh2Gt1zi0MQRxs6yJyJKhNn0mZKh2gsbt5a54IxsfWV6DgYCZAIcVIZ+fCz0fkZ+z+8HwBPWxFecgLHHYeXo9pkArSGqHIqZTgGXuFkFTrsFP3PZZ/OiiawkCZTAeDPvYTQuc+LUgWXEMmYq2+zsSFnBWRUax8oWDBA7/Bj+pTaGzoE+hbwOxSFA1SNIW3JCRLW2VM2oRRLW5lID+IW/7oK9lkuVfnymLmkdtT92NKA6+mOIEdBEEzmsTkjuRKsDY1tQ098o8WzkDvRO+bsQoZ4jufINrXuBUKJ73Vmy1UNBlgMkFqv66wgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Mon, 16 May
 2022 23:41:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 23:41:27 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v2 3/6] vfio: Split up vfio_group_get_device_fd()
Date:   Mon, 16 May 2022 20:41:19 -0300
Message-Id: <3-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0200.namprd13.prod.outlook.com
 (2603:10b6:208:2be::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56925367-f7a0-4132-3bbb-08da379596f7
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB38328663F6576B534BEFD2B4C2CF9@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cj0g2stWlJgXdzFQ0OGPJGx4Wd0bIpy3d7IaTrji4JzCsqgr4n4fMGJkYOTNgt2S0j7w6W835cCu0C+kdw4ELeACdt+y+ghOBCs56I5YksEdVsxI2bIktQ9/fzJBPIMQuTdGW4+M79O46ViWyfj2flcFtIuwM234UOGxFgIJzn29vS+C50sSLirh8HtwF0B/ENkiM1ub1d0x7KVa8bI7exYJsmltikF9JFNYmY/SxIurdOh380d52NI7tEmJKres88QaMUo7fisKNaDI/fAAFRKHp82Bmj9IpJz1ONoKpwbUZKMroQYTaAb4nNYRH24TwmgQcpAmbC72v7rh0pWDpYyDzVxMTmSVPJiAvP7bzl6teKcu3g/DdQhI2Jk1kI5axXNRxJKPr98ue8Ufv9h9oZ+JdTNrKUa+fIEZiV5w3xj6s4JmZjUEi16kyVJtxpM5kg0WFUsq0Pfb/RmwsfAz5zl852BXG7Ytdsky/CRubJVcuvhszqGHQeLO6tG+p57EdO4yLB2GDi281tFaylzhMdygCBUbazYtnrU3ePudTBPmNR2ewZWZS8DABVox7N4H3X0X/WxhrmcWsgIVHlDQMIbX41Dkyx0Z5TjagKCsWNDMLX4pXL/6TwDKd35dGDqDcjSF3cTnpQQ4WYTYuOq1idItpzKLewlVAWHIuoBsGTimKX4+PsCjY9kSm+91eRLOm53bxwg4EXTlWDh39VxFHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(5660300002)(66946007)(110136005)(54906003)(316002)(66556008)(66476007)(2906002)(8936002)(4326008)(6506007)(86362001)(107886003)(26005)(2616005)(6512007)(36756003)(83380400001)(186003)(8676002)(6666004)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zB+zX0mK/eLb0cCv4U2dY7tnOoxUq1Bq9jIFgvdRTWPdg21/hBAQu+60dd7Z?=
 =?us-ascii?Q?EV3il7coZ4dn4e3uNuZefy7qwQwYaDeUd1EGwaaSxCH2d/8109u2Xwf2ewqo?=
 =?us-ascii?Q?kRT5JNfi5Kp78xHgWBJHuql8uRVoLZtB6zyKq1Wn6yGOBRV3rGnar72QOCFB?=
 =?us-ascii?Q?j4ncO8lNwimsXnfNxZLfRzd27rZlor5MTQeu6FVTpBau6OX9CaFCQqCNsUKx?=
 =?us-ascii?Q?JlparVzMqWdc8ygesmbqhvbAX8+kydyWutl8oKDJMbIMRIo/F/PFD0wXwicb?=
 =?us-ascii?Q?6/oeJqzpYReUP8oNtYNWwloGfMrp+GIVqp5MnAuA4X38RixrVXfjzn1NSfxX?=
 =?us-ascii?Q?XcZfrdHwDyS+hMIkN7G4A6vQtT2da1FigjPShW0jhI5YQ9c5188rJDCLRtnk?=
 =?us-ascii?Q?csbK/sgjHtoqCFg/FkozVetjXJAESBdbMWTl/PWhKGe4LuBbWfT1jR82nGKl?=
 =?us-ascii?Q?0XIqulGEeqayt7SUd9gpdPGcqCsa0wA6rpPaK+QZOnGUwoobqCYZ8nYxgdab?=
 =?us-ascii?Q?QcI/sJbJ+arCxc3pwYtbDKYm7iOzWC8vAwWCxZe85Ij7M5Uy087bhsIcWkX9?=
 =?us-ascii?Q?0kaxvLLEsDaqLsUqFKh+uqUB1vnzBs6nuB+Z6c0ad7Dlddic79nRRrYCZcSe?=
 =?us-ascii?Q?vt45pa8umeOamuJdfUmQUL/v7yKWCua2ASVdYz0yqEltDBQRsfktCGXXS08I?=
 =?us-ascii?Q?EXoh08yhaP3IJuuMDMLR4EK0i4y/YM2/gx81KoCkbXb8ueCBkpoj1Qzt9TOj?=
 =?us-ascii?Q?u/ABzOXkGMJNIX8Y5GLD2pCSZDzVo3lQinGx2Qui7XR98wHK5xPLfG4wxOU4?=
 =?us-ascii?Q?e9U4Pk6LFChGA4/pdgCps1o1EXM5frBwAR/HHf0UPV7eiC0GEJpttFkYQpSm?=
 =?us-ascii?Q?Vdl1poSkaq1VAnT7pDyn9Tn/kiyZDTk0skr85uZb67VsV+cuGoBHujSmPfNG?=
 =?us-ascii?Q?0s5lUsIEINvXreAfNiAwt0q2ZxCXf1ag+VWZAO0AojqGIgimVgPxsGpCecU8?=
 =?us-ascii?Q?mWVGxI+vjo7BE8DgV75ekYQF+XSP6+xuf76b7I61Fwpr0QFQrgUxZKBnymYy?=
 =?us-ascii?Q?ZDZnwBZYK/jFh3bDCgg0h13F0nLXAATrCi7iIxOma8drvFLdajVaKm9K73sL?=
 =?us-ascii?Q?n2aQoRB9KuIP2aVKEAu2RO8/xPGrPwlxOYL6qbNn5HITWCZUbATLMcxEn4+a?=
 =?us-ascii?Q?ES4rkCKMcWqfvUMlB45xaS/eKMKnfc3wTHDNTh6J4vq1pCvscQC+4UE7FMJG?=
 =?us-ascii?Q?3MmuXf1wd9M1RZwRWaW1OmX0PfzvXkl93IWcz2PzdXPyFs4JG3kGzX3cCNHz?=
 =?us-ascii?Q?1qy1Qhz0meNhLgSAabclIqXKhJaLcMLcjbIblBSIZnovgiFf7uO1trCJTMMJ?=
 =?us-ascii?Q?1zh4wJXrLcX9UVPI95pzlzzPXXJxzQin0clLpq0PUQmbIRV7kLjYm0Dtr504?=
 =?us-ascii?Q?YFkjbZtmXXcsaO0d0ubZXlV68uDux1xrKN4ut/cFxAE6TqQDAZUrIC5FOkJZ?=
 =?us-ascii?Q?23sxRqSfhtN8wgh2UDf2ZW5R1UtO74s8PwaAZ/87l2Wfc9abKJDhtdrZ0TTL?=
 =?us-ascii?Q?FREw8eQYk1cnd051+Hgbly6wFNJ12bk00j6IHgmus1NdEQn6+mjUCR3IjkzX?=
 =?us-ascii?Q?N/Y5xI+EmJiG1ms+tnvRj/SwjHAcOs7t8AVotnAApGy9Zt93v+qiLz7WdmKk?=
 =?us-ascii?Q?8dYUxBndRwIzwIMcAacBJGiR/p9zyWgQpq+5dXNRDG5PaR7/iAENeOqC0fjM?=
 =?us-ascii?Q?+RYUVCNWKQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56925367-f7a0-4132-3bbb-08da379596f7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 23:41:24.9879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlhIveuOrd7ZbGAbu7OW4atZjf1HHx/FzrRq/1MOMfzY4mISl07gA6lK7VGx9eu8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3832
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The split follows the pairing with the destroy functions:

 - vfio_group_get_device_fd() destroyed by close()

 - vfio_device_open() destroyed by vfio_device_fops_release()

 - vfio_device_assign_container() destroyed by
   vfio_group_try_dissolve_container()

The next patch will put a lock around vfio_device_assign_container().

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 79 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 56 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 12d4b3efd4639e..21db0e8d0d4004 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1064,12 +1064,9 @@ static bool vfio_assert_device_open(struct vfio_device *device)
 	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
 }
 
-static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
+static int vfio_device_assign_container(struct vfio_device *device)
 {
-	struct vfio_device *device;
-	struct file *filep;
-	int fdno;
-	int ret = 0;
+	struct vfio_group *group = device->group;
 
 	if (0 == atomic_read(&group->container_users) ||
 	    !group->container->iommu_driver)
@@ -1078,13 +1075,22 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
-	device = vfio_device_get_from_name(group, buf);
-	if (IS_ERR(device))
-		return PTR_ERR(device);
+	atomic_inc(&group->container_users);
+	return 0;
+}
+
+static struct file *vfio_device_open(struct vfio_device *device)
+{
+	struct file *filep;
+	int ret;
+
+	ret = vfio_device_assign_container(device);
+	if (ret)
+		return ERR_PTR(ret);
 
 	if (!try_module_get(device->dev->driver->owner)) {
 		ret = -ENODEV;
-		goto err_device_put;
+		goto err_unassign_container;
 	}
 
 	mutex_lock(&device->dev_set->lock);
@@ -1100,15 +1106,11 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	 * We can't use anon_inode_getfd() because we need to modify
 	 * the f_mode flags directly to allow more than just ioctls
 	 */
-	fdno = ret = get_unused_fd_flags(O_CLOEXEC);
-	if (ret < 0)
-		goto err_close_device;
-
 	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
 				   device, O_RDWR);
 	if (IS_ERR(filep)) {
 		ret = PTR_ERR(filep);
-		goto err_fd;
+		goto err_close_device;
 	}
 
 	/*
@@ -1118,17 +1120,15 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	 */
 	filep->f_mode |= (FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
 
-	atomic_inc(&group->container_users);
-
-	fd_install(fdno, filep);
-
-	if (group->type == VFIO_NO_IOMMU)
+	if (device->group->type == VFIO_NO_IOMMU)
 		dev_warn(device->dev, "vfio-noiommu device opened by user "
 			 "(%s:%d)\n", current->comm, task_pid_nr(current));
-	return fdno;
+	/*
+	 * On success the ref of device is moved to the file and
+	 * put in vfio_device_fops_release()
+	 */
+	return filep;
 
-err_fd:
-	put_unused_fd(fdno);
 err_close_device:
 	mutex_lock(&device->dev_set->lock);
 	if (device->open_count == 1 && device->ops->close_device)
@@ -1137,7 +1137,40 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	device->open_count--;
 	mutex_unlock(&device->dev_set->lock);
 	module_put(device->dev->driver->owner);
-err_device_put:
+err_unassign_container:
+	vfio_group_try_dissolve_container(device->group);
+	return ERR_PTR(ret);
+}
+
+static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
+{
+	struct vfio_device *device;
+	struct file *filep;
+	int fdno;
+	int ret;
+
+	device = vfio_device_get_from_name(group, buf);
+	if (IS_ERR(device))
+		return PTR_ERR(device);
+
+	fdno = get_unused_fd_flags(O_CLOEXEC);
+	if (fdno < 0) {
+		ret = fdno;
+		goto err_put_device;
+	}
+
+	filep = vfio_device_open(device);
+	if (IS_ERR(filep)) {
+		ret = PTR_ERR(filep);
+		goto err_put_fdno;
+	}
+
+	fd_install(fdno, filep);
+	return fdno;
+
+err_put_fdno:
+	put_unused_fd(fdno);
+err_put_device:
 	vfio_device_put(device);
 	return ret;
 }
-- 
2.36.0

