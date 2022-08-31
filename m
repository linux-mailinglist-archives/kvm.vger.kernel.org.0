Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585985A8765
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 22:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiHaUQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 16:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbiHaUQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 16:16:12 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2088.outbound.protection.outlook.com [40.107.101.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E972DF644
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 13:16:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUmrduJLZ5tThghzSJIFvGh91uEZRi9PN1UdaqzNWLbK134/w+qGd7x4Yq+RHDFH5TF+ByvgkhRyrvqNbBgZjZzkvH2JjG144FS/Yrw4rcOeLvd/VSUUmSL2Ch9C3D+8eVxKb+ECGevwWkrEr2PKR2MgoNcI9fQvOWC8DYxpKTEUSxAk816rlwLqI1PtOqjEWEGG6nScO19BpXEJC+E3DGDPHgeqIeN7RnXW61BtyULffnDGnTld6nmp7n3Sl7ipQqUJb/iwUpAZD+O1ieW7mJ8mTbHpg5mmkVeZMF7eMYTPblNbBMn66J52KV+6WfveOFWI6GmxfdcNt10R+eyZkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZhagPHWbCDsJlUHwhlYyi/fYTL+PJ19JzNNsd50eRI=;
 b=SPf+aJgnKbNWpTdTKho7RI2lHnmZlycEjCCj4e7TD4F7iKgV8s7WUzp3Hy7bp4cuHVVgsRs0gWOncnkwMK/LVJbcsncxQvBZvBRB1aaIFduPWSFdWk9M8WFsyOyXMuNH7W6tfmhEBeq/70X5MKHJkTENONQdzSECPKLeO+sjzzsH/6mvG50HljT0S3pRhBnC10NkuvfiC0IC27YP5hsItHb5LBQKfIXmfFLv1AhDunIwphLMp8I/XY/lXAoObieTlgs/ylockKaAgI2bLf5zSyGnfk58eZzXA0KcNmuIY8+qtkciTL2ggoPycoyBxc37/QtPp50zlO2jm5cBgfwYaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZhagPHWbCDsJlUHwhlYyi/fYTL+PJ19JzNNsd50eRI=;
 b=tj88xiof/akG1ULdO5RE/3HV7bXy6aeLYPHCC3shnhBkhrpBi8btlPoqgN1uvMq8SN1I1tHsP5u69w+J7cLRCUAjkimDCPgwpfLe82botm6a5BjtlVzLn6gYf1EhDO3P97nAjfz2cG3dyPuOwt6DLJuA6YWkDygU5kpJ7QD/jkzJawF5BDYoLtupf09jUy0xGW4YabO1iJ21bVov7/B+GrgogQo9IwsmAXrmIiv6eLVzypZrOOPO3830Ths1p2CyxzMsSaq2VopywYQjf0Q524/qgKF/2DB0EpcyhpsfQionUaTRFGKUgO5WwewBwEggEVy73PV1V6qj1qh1qXJeRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by SJ1PR12MB6316.namprd12.prod.outlook.com (2603:10b6:a03:455::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 20:16:06 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 20:16:05 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 6/8] vfio: Fold VFIO_GROUP_SET_CONTAINER into vfio_group_set_container()
Date:   Wed, 31 Aug 2022 17:16:01 -0300
Message-Id: <6-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0257.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::22) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f5c2c14-4d39-4d98-7c3d-08da8b8da1f3
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6316:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5b+a/vG1DMFJsoEamoc39FbYnk71eNj9mIR2YViG/WvgabsxZBarW1FBJPtkYN5c48xmcrDWU3csRnmazgyjX4/gOKmpyHTMCQlb6+oZoc7a0eoa/hex8ix2ZGjBrU0wM48zrJpQ41c6zj+wdaZ2KdrhAa2JYI0pvymePeyvHFgpG4yHepV/9dVTdXo3x04RRj7ArYs/Wo7vqfERfGqi/kpaHhhrtlGCV7o16n9VqDIp9RPjU0oSn5/p/zJavsCTfIjxx1ksQbcGcLOW6NqeXO78uOEh7TyPqa6CsmtL4ivF4A9eIcTmbfQVK18WgmbKQetUKKhQDUl6OLhusdpCFTlu8IIcM4iIBiA46WOOCeInnzcwRpAlUIUGWShD8DesXJ5mswKpTDLknQPotQR/47bZ+rIjp6QNEXoPCDpQFoscFIYB8Qn1YtOMIaB2tnnoCr2BtnqyMmdIGClmOTrOypm6FQsLaGYXw73ZKQGBhOkPqxo6NDOy+wQY1C/Gz7VLNkI0/mLPYA/okz+JIMyReNKHpDCgS1ZIWFum8HmhPM7+sN1w1oel+W4MGNtbWhKKY9TzQVKhsOq8S2O4vhyfDYM6+mylKzs7XsR64YXbpO63+tJDifDVfet8fVYCyOIGLGY7GAZcU+CT7/kAFBBXEpyYSqwU5egeFKfXpiFcaNmbThORv+0Y9DvZ+JXNnoa8KwzkhIUj5cvXhYWai0PEmJsSeItnUy+MkzoAe9oj26XVvXZpJtlcjB0BkVykRzD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(186003)(5660300002)(110136005)(478600001)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(6486002)(86362001)(36756003)(8936002)(41300700001)(2616005)(6666004)(38100700002)(2906002)(6506007)(83380400001)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XgkZk996nYZEumR0q/d91gE6KQFoHPrpBVNzM3Myd2hZbEU5eu2sdz8ezZHO?=
 =?us-ascii?Q?LCYu+0JyggnqxvIV5npf096o4WEaGovuOfA6sgL47sh8KmnJxwhu5r/LlYz3?=
 =?us-ascii?Q?h2pJkwaoMnSzUlmxZA5oN3iX198luziJ/FBK3G9TiJh8QhKHdiMySKWxVWTg?=
 =?us-ascii?Q?YQvfnfabgPE9Jxu5jFaDQzk0TiRQM9YBiYsLgx5ukU2MZ0CV6jig2+UmLW9Y?=
 =?us-ascii?Q?pOrauj9QUyoNNRz45wDAFQyIHzg1CDDncHOOViHsIrMIC2kjQ6mo7y1QRzV2?=
 =?us-ascii?Q?fu0LMKzoId7hXL+wYOcZeqaoSvfs9JsXcJ7zSDF4ueTkbyxqkhIGZShW19sS?=
 =?us-ascii?Q?ICsUmAv28pFCz4AvdrYQcEKujy+bukYRcsMpsD6qJZkYHJ8ep4LSAzXeU/m8?=
 =?us-ascii?Q?MbQK01WY7ml4z6YUIp32yHY5DmQPVfjOe9GuQZgk4FYiZ9Hi3hDBo7gfyUP9?=
 =?us-ascii?Q?XxkNVCsLtpLHsNguW7zi26yzC8wUncVUMxNKGU2TfuFD/S7A7IHnzR3sgGCG?=
 =?us-ascii?Q?sglOPNeA/4DYz9I8zpUMtwlo9t1OWHlvviANHp2SO2rGDO6t34Hw7de4tPkL?=
 =?us-ascii?Q?v5Grc6GjS9ai1++lkhE4fT1pRPMD3cHaC0qqD7DZvo6ocGJibDVy5FwQtxyv?=
 =?us-ascii?Q?jw0bibAerD0FVtXYjd35b3tPyiOpYgzwGSNfvcnBefyCsDwuphN3/JOIBi/I?=
 =?us-ascii?Q?BTR6QIXDLHAIO5N6fCH92vModKhhmB02DEgXTdciOpqgdr312EaNL24DdZqx?=
 =?us-ascii?Q?tFyyRPrWpZ6fWcleXcAUM6qnwnZnqYsG1o9QiPpdYXUV8/2MELzQDe7w5Epv?=
 =?us-ascii?Q?FlsOm4nZz+a8Eh+q/kw6x2UMK71twMgpDIsLmofypTMTdsrc2XZ3vD5xfC/w?=
 =?us-ascii?Q?BPACYUPjXKeHLy7l2WeDOS7AaLGfgPJa215bOksnwd1aE5h2rcLnxnQV7/P+?=
 =?us-ascii?Q?fGzpx3hIkmd8BxQOcV846t3iha7nvP1wYLtZGhtyX2QZrDgAJphdL4OdG624?=
 =?us-ascii?Q?6pZREKjbS9cGeQsvWD7DOTPVft8djqDcYAod23w/Ce2ixX6D2zfsDZqMZKcN?=
 =?us-ascii?Q?AUNyGYgPuIZ8fVbpmaU+RZHv0O77TddqdZOlF+tmKWRT/4kfavYhy1aIqaSL?=
 =?us-ascii?Q?jAJic47r6yeS3TzIKLrkJpnjbCe4gUUvbX7gEmlIVi4thcwnSl0gjSSKfjSW?=
 =?us-ascii?Q?7mw2TGR3OhxdXdGQ9joS2LAwlnioGkqsLoBlcXZEcQ0zJpmuyMJ4VEFaaxE5?=
 =?us-ascii?Q?iWKQ+L6eR6B7noGecfr7lNtKZMYvqc+Ki50YmK4cckWlz7Nmw40tsQYpIp2G?=
 =?us-ascii?Q?rcxmi6GnIJIU22triSZVK/Bdlg4KeO0xkukAuJZdU6UZUp7blnj8+/vbHqbK?=
 =?us-ascii?Q?CDF8PPwTZC9bZm10lVK4ZZOWK5u6Sfy9g5706CIOC6wkw+DyU3Bp2LA9OrP4?=
 =?us-ascii?Q?agokReZarzj1CAtwzLNsjIS1DKvn1T2ylv9nL2vFwRoN5/CsVodlYCkQ6O0p?=
 =?us-ascii?Q?buZ9FIOBZjzxVkBCzHlHErrZStVUbLszp33HRCZ1J0Ut6hiC3+dEIY1mt9ps?=
 =?us-ascii?Q?rxWldPQDUXlFFPdlp7VR5wrLcUsvL/MVksyYAEJg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f5c2c14-4d39-4d98-7c3d-08da8b8da1f3
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 20:16:05.1178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /A7x6P5v6CV4CUWgc28a9dfXM8v1puYwdPJsyfnKnEDW2gK9fmQqXT7XoQIa/k0d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No reason to split it up like this, just have one function to process the
ioctl. Move the lock into the function as well to avoid having a lockdep
annotation.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 51 +++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 3afef45b8d1a26..17c44ee81f9fea 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -980,47 +980,54 @@ static int vfio_group_unset_container(struct vfio_group *group)
 	return 0;
 }
 
-static int vfio_group_set_container(struct vfio_group *group, int container_fd)
+static int vfio_group_ioctl_set_container(struct vfio_group *group,
+					  int __user *arg)
 {
 	struct fd f;
 	struct vfio_container *container;
 	struct vfio_iommu_driver *driver;
+	int container_fd;
 	int ret = 0;
 
-	lockdep_assert_held_write(&group->group_rwsem);
-
-	if (group->container || WARN_ON(group->container_users))
-		return -EINVAL;
-
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
+	if (get_user(container_fd, arg))
+		return -EFAULT;
+	if (container_fd < 0)
+		return -EINVAL;
 	f = fdget(container_fd);
 	if (!f.file)
 		return -EBADF;
 
 	/* Sanity check, is this really our fd? */
 	if (f.file->f_op != &vfio_fops) {
-		fdput(f);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_fdput;
 	}
-
 	container = f.file->private_data;
 	WARN_ON(!container); /* fget ensures we don't race vfio_release */
 
+	down_write(&group->group_rwsem);
+
+	if (group->container || WARN_ON(group->container_users)) {
+		ret = -EINVAL;
+		goto out_unlock_group;
+	}
+
 	down_write(&container->group_lock);
 
 	/* Real groups and fake groups cannot mix */
 	if (!list_empty(&container->group_list) &&
 	    container->noiommu != (group->type == VFIO_NO_IOMMU)) {
 		ret = -EPERM;
-		goto unlock_out;
+		goto out_unlock_container;
 	}
 
 	if (group->type == VFIO_IOMMU) {
 		ret = iommu_group_claim_dma_owner(group->iommu_group, f.file);
 		if (ret)
-			goto unlock_out;
+			goto out_unlock_container;
 	}
 
 	driver = container->iommu_driver;
@@ -1032,7 +1039,7 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 			if (group->type == VFIO_IOMMU)
 				iommu_group_release_dma_owner(
 					group->iommu_group);
-			goto unlock_out;
+			goto out_unlock_container;
 		}
 	}
 
@@ -1044,8 +1051,11 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	/* Get a reference on the container and mark a user within the group */
 	vfio_container_get(container);
 
-unlock_out:
+out_unlock_container:
 	up_write(&container->group_lock);
+out_unlock_group:
+	up_write(&group->group_rwsem);
+out_fdput:
 	fdput(f);
 	return ret;
 }
@@ -1258,20 +1268,7 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 		break;
 	}
 	case VFIO_GROUP_SET_CONTAINER:
-	{
-		int fd;
-
-		if (get_user(fd, (int __user *)arg))
-			return -EFAULT;
-
-		if (fd < 0)
-			return -EINVAL;
-
-		down_write(&group->group_rwsem);
-		ret = vfio_group_set_container(group, fd);
-		up_write(&group->group_rwsem);
-		break;
-	}
+		return vfio_group_ioctl_set_container(group, uarg);
 	case VFIO_GROUP_UNSET_CONTAINER:
 		down_write(&group->group_rwsem);
 		ret = vfio_group_unset_container(group);
-- 
2.37.2

