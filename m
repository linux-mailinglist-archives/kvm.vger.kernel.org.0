Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3744451CDD1
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 02:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387524AbiEFA3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 20:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238494AbiEFA2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 20:28:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1D05DBCE
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 17:25:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7MEbNPs4495td8mp0VfWxCch4gwQJKu7NWTefDGQo32h6mJ2lY01eI/pA4ZY2IM8wHz+2qW1nbmUhgNzF7u/gPO+O3+cjLPO1k9bhQ9WAyRZl2Q9BJSGcMKRkWwA6vmR7VMdZl+ocZ5JhKw3zNeT9sSTLhXhnEitluulojshvQLLVAuIUHd2ymd359AuGy9rJ9sezeEUZz4It92NeEkXgu7+OGMgD/KLHGMf4GadILf1XBRGRleQ3N8njHX0dj5wmg9XTEK8jV2+SJQ1lj3TPjB7H9K4p8DgDGzAlPh2eLLIv34n9uhM65+8lzTpQpSc1sLuhN8SCPLnK76vApdSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pH9NSRHJCmHKbd/RepaEbuyo4nRMqQ9RZsGrwt5EAxU=;
 b=esVppEm+ZTeoOh5j4D7bp/QPtEUsJzlpyfgzD6epfjUIAfXaUX0pzefxUrTVkgJ5wgFBnPs/uH2eDWWG6Yyw+7U1d6ct0iEunxGYkyNEzo504KG4EO3bYDo54Z5WQaBokKLQ6abdjYG1fMK/zbph8E4ozxhZ9b8P9GXe1fLhjnrWsKarp/Iwziv3e40G8dUuoX9aWaZe9Tnu9dUMlY6eL8IiLOZqjT3X41RNOdUn2Qy2UxFAdy8eEND34jN1uZZBYBCzh7onZj+h59ADE7vbObqeFu2GXXLguuykBM1nJ2EIZP+cX8tOq7HXA4XBbKpmLpyGSV3Q+8xJJlthKwP8Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pH9NSRHJCmHKbd/RepaEbuyo4nRMqQ9RZsGrwt5EAxU=;
 b=Q+6qyxW2tp92DAOqF4VH/ONJ5ssswM2slHeKD2IntbsxjyXAlO6wjvowqf8lX/Mf5JL+GqTj1Stlhb8q/XAZQcC1VdIe5XIUgMaC3IhdG0yYJ6ZqqmxHHsnkiGgIWyXNfN0Za9eoP5IQEn4HtT13dbZZNbKQw20rVqtdw22oMSEE1uUODkmxmVB+lQsR6Jkt0QC50QBjd9FZfbFLFvsfqZip7ii/vcyhNMj12WQIXgpn7RhhArpN4NWBR6X3ITxy/7L9QPIu8MiCt3Jd2AgDhD2mzsST1xWnC6bFer+qUfXaJVOI6FAYWejUU2GhsxE/lUbpKibtIej5PQCKZDupKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5025.namprd12.prod.outlook.com (2603:10b6:610:d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 00:25:08 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 00:25:08 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3/6] vfio: Split up vfio_group_get_device_fd()
Date:   Thu,  5 May 2022 21:25:03 -0300
Message-Id: <3-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0027.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::37) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 241c44b4-b2fd-4c27-745f-08da2ef6dfd9
X-MS-TrafficTypeDiagnostic: CH0PR12MB5025:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB50254D4065AFC96FBFE2EB54C2C59@CH0PR12MB5025.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pwp4f5KvLqUSE7fDnWUqnd+VhA+/1fpJfPZVLtTroPcHGYtdpWSlXQgWp9Tneyll4O/027gqWxA+g+5z7eYD+piRO9oK0RwAptakIsaQWnVQXI1cGlqWEikiLPfE3ml7oJclz5xVv7ffn0VNMHNf+QKlAMWLhvqo3oOkyCxOsPYN7USGw4X2vNW5uzcY30pK0kMou9vG6IDBIoh79+jdLbe4fKvph90q1sGeCFpTcAJ8LelDY/coI0hl1UlAtxHMhD5KA2zIt/rAvjXT2sCwrKOVcP21t5/WLtS+TpmQblsZgnu7VZqOvdbLi9DwZagao+o6CZ1bf3oi2fRLlL6JQC2EIJx39w8eQy/kscy0bQ0ROjYNSNWeYeLVn3iSgUjPCV+hsuuIE/ovq9uaGcsyaprPx09FPDq4Ba+FqiMlLC8yb4Yxg9+M6ptKAjgemNtSkpP4eLC6IeoThYgNWuShD9JwK+jqGr4PAZFDnYn9Kekjv0oY3BpQ1cwFeXbM8dEw+NXP4AGLB32lXHn2cAYTXZxTMXEduLtjTDV83nruT04dGdhIcIr+2J3nWCivcDypeWFtgZmeZn1Dxf4I47F6I2sRf4eRmRBc/57SPdbaomJqtVmbHmDk8qJsJrdzaIOGVzdPdTSR8CWSL2LDk5xaaAgIU/z+xO2O45j2PuyRPcenzqr0BwEycRdDYPVmcZSv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(54906003)(110136005)(38100700002)(316002)(2616005)(6506007)(66476007)(66556008)(8676002)(4326008)(66946007)(8936002)(2906002)(83380400001)(6666004)(508600001)(36756003)(86362001)(26005)(6512007)(6486002)(5660300002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bzQvkcTuEJrGSsTxrTO3dB9HKCw1JXY/RIge+w2ZjINjlKJrDWfGXBphcksX?=
 =?us-ascii?Q?ABl9dMLNhzjqfhINmqIrOWGDQZ54MT9aohkUhtf0Yco3T+VPONSo7t7VTnc3?=
 =?us-ascii?Q?iNz2cYIdJShYCqLaDDpfq393Pqqdmi3Emd7ohAB21kGe88/6Nb6tGIoAtqXf?=
 =?us-ascii?Q?v5TcfeKPGqQAkDxD5ixIrTc+tt7NyXVye+SkTnjgbQsmj7hLYEcR0klGT8Kv?=
 =?us-ascii?Q?A1JimGMQPqfh8qKFoTbr+t7JMjPKrMbsh27g3I6IE34FtiNFp3V8A0Za5Ovq?=
 =?us-ascii?Q?Ce8m2Zmj/pQByWTwNcq6TnTffm7qO6cYxfALZALWnctOVK//ztPPS0NidLZi?=
 =?us-ascii?Q?+nNjJGv6t1jVgrjoGmbYYD3pPEtTrPunPcSpMF4ft+sJcKs+FLMaOaQEOMXZ?=
 =?us-ascii?Q?NbxbfZgaB47KZvsvpPIo3nO0LtBhkrqlSvl0oY7Z0JTKxJXPVFtSLdU0wh1Y?=
 =?us-ascii?Q?BgllrEbcDtjjjT5SHTzxaypTIJHhiVXvRyCEMO8unWWumonS2r0eVeHomAmr?=
 =?us-ascii?Q?2ztL4Viuw6pLLSsCpBllX9CUyKQX0izdh1Kp1Bmgcuc3oncguplokjMT9Wu0?=
 =?us-ascii?Q?RqTtwIXY9oLmv9D6sQNrafVaymkhRSq1f5QCtAXuzxA+e7hZY1M6eXPybCxN?=
 =?us-ascii?Q?/2U7DgFTNeij5j3kUCDHUQRHkZgb2BmNr5fBd63HqFjIjIRUB32GTFdt9ufW?=
 =?us-ascii?Q?9IOLHPcg8kdvFxPSCKEejG6KTlJl5SelSAKQ5oqw1JTD6EF0kCUFTsYIK+Qe?=
 =?us-ascii?Q?ac616L2i0CWZobf1PGPRfxe+FlUk5dW3G19EE3lgSfxNohl42wULkLOoZwmA?=
 =?us-ascii?Q?8mhsu6iyYm2r3z4QrCFO6WbYbRo4IzOVk9bE6d4gsd3tLshJXvyrdv02IrM0?=
 =?us-ascii?Q?CxOTv3Tc5XbVftXN+MmJJZwwIO5iLgH8NtptUW1JeEhVA4IiqKyScwAFRimi?=
 =?us-ascii?Q?WL2e+bSl0o02vCsW+G+6dFA/c5qZfoDr/WvxBbkZJ32HhtpbgNi2lXtpL4Gb?=
 =?us-ascii?Q?cGgBrAG1CyYmmHj1cAsVBfz2r1KYMiDeKnwtxLtQM+SSNqW09L22UfFbb98l?=
 =?us-ascii?Q?qd688jKVHgUc4728q/ss+9elhNXrTn1dTVpmpvK+UV2Ei2B3YTaBhltr+56d?=
 =?us-ascii?Q?/b6R3n/oEhBc9Gli+rI6QZj6U598IPkQGMLjOweozWsGFJYyM4zYEGnnI/0e?=
 =?us-ascii?Q?9qz6nXnLUiEe/INtKMLODgaRS7RMzdH5TeppJfNd4V06dirTJUg3VR2CiOMV?=
 =?us-ascii?Q?ggTv7Hd8dAcZuibZT38iEzNxC8Jc4Rboi8zUOMg69iUqNonUsiTQOSrIbG4n?=
 =?us-ascii?Q?cP0Z7NgG5rNGDfcfnjgALbMmCSaX4y5rN4Uhw3fNDAZyvYTqT6l34rPc30db?=
 =?us-ascii?Q?0YcvvGF1ALgXOD9EYO6aYJ2rqWXyPOn/sD0ORnlVa8YvlKwxz7zHxGLHQB7W?=
 =?us-ascii?Q?ToIZ+vFXEO4dDNFzU0ii32gmY4S5kiR2UxipFmc4UKwpZ7iK9MgGfIRHp4Wl?=
 =?us-ascii?Q?+izwG+3jwxfniRmoeombHLia1Krz8z3hE2crTkYrudnHjyl4qIuf6hh+Bn0C?=
 =?us-ascii?Q?bjFR3/s8iQZq90VJNnUmt1pLO4XHmLGY2ml/9hJBzYXubMXAClwmu9uQFFpi?=
 =?us-ascii?Q?ZhRKgWxXl9vX/q/vfa9uxKEb1LRzTN4USWYFGxQDks5+cMt1k6j9TwejXZ8G?=
 =?us-ascii?Q?i0gzFByr8Qa3aCfGqLDUbAYNwlXVvjEx+OZRMUFbRNUSorKMB6WBsq8FTG4V?=
 =?us-ascii?Q?QSBKLKz/mA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 241c44b4-b2fd-4c27-745f-08da2ef6dfd9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 00:25:07.9686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PSQKD5belQRR8pG/ir5AHUWX15X9WP17QDg93R5jrKds7XO2laLSdI0OIZCWkIO7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5025
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 89 +++++++++++++++++++++++++++++++--------------
 1 file changed, 62 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index a5584131648765..d8d14e528ab795 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1084,27 +1084,38 @@ static bool vfio_assert_device_open(struct vfio_device *device)
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
 		return -EINVAL;
 
-	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
-		return -EPERM;
+	if (group->type == VFIO_NO_IOMMU) {
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+		dev_warn(device->dev,
+			 "vfio-noiommu device opened by user (%s:%d)\n",
+			 current->comm, task_pid_nr(current));
+	}
 
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
@@ -1120,15 +1131,11 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
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
@@ -1138,17 +1145,12 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	 */
 	filep->f_mode |= (FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
 
-	atomic_inc(&group->container_users);
+	/*
+	 * On success the ref of device is moved to the file and
+	 * put in vfio_device_fops_release()
+	 */
+	return filep;
 
-	fd_install(fdno, filep);
-
-	if (group->type == VFIO_NO_IOMMU)
-		dev_warn(device->dev, "vfio-noiommu device opened by user "
-			 "(%s:%d)\n", current->comm, task_pid_nr(current));
-	return fdno;
-
-err_fd:
-	put_unused_fd(fdno);
 err_close_device:
 	mutex_lock(&device->dev_set->lock);
 	if (device->open_count == 1 && device->ops->close_device)
@@ -1157,7 +1159,40 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
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

