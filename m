Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D56B5A8769
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 22:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbiHaUQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 16:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiHaUQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 16:16:15 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2088.outbound.protection.outlook.com [40.107.101.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37744E5894
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 13:16:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGwFzVy0Af6pWKHeQktT4f71bB27v8zX1CIClrDV9ESPUVRuISMb0EokZwJZTlUdxQ6eP3ECTXwiyJn2eEv4ff/ZOEHIEflUtD93o5ESGMrrVgTgZWJp1jynxxWZj9nso8KDJJ6inl1U0eFcptra5LCZMj8FLS+crdPVG5novagjGOmNje0DAFIt+jDsxAIL6a7JC6Wh/jHLNJG9oyXx0dlNSpV1it7+LQjJMOxPUV+1e/v0p2UtgqzMSUOSwxPIav7/SoBYAZf70LFn56YiWI0Q9u77pMIXQ0Lzzhccoxdg41DETc/B0F903PBUP3y8e/gu8AebjDBkkQDzzr4hgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioqmLK2L3TktQDTIxeQejNK4mrAkPBKGr/XsJ48vgH0=;
 b=D6HVQEPlG0cqNB9ClKPFohWG+mcQlSmXBnwg3ahqabwKm8NsPSqtfhG/q0PqSUJpAQW+78uf7WYcY8SJL1nw1JnaS0u0pNVrlmslISe5bMs0suH7GKF7IzBJiJU+/n/mrF/+2twGm66WYj6NZxd0QCuQYKdP1zdMItWn1YVtBnwd3nC/6e63YQ22KzGdZbDb5B/N4fAz+3xit1peX/uoLPbRUUNqJj4k3y9TDyu2r+/wBaqjgBges92F/c634FUrf0W75uWx/SuVimw71E8UCpQ/ANp7j78d3vYTFIW80IzEt6vaem2sMnEQBzjuvq4MQHzfT2pV/lbc46gU8vtzHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioqmLK2L3TktQDTIxeQejNK4mrAkPBKGr/XsJ48vgH0=;
 b=BSDjA+8CCdtNNILWi70d3n0//WurLq5fK/7iZLSZck1Alj5YrICNK2Lcy4fQkccoesg2qBPIdKGNensentV+OGiO/dDIiiEIABm0Ew1v9xINE772t+jMxRs+E9WdmG7uZqhVmtrJ0PNlwaVP8aKMTN721e0bkR5CqO+4OKrCVR4e6MmrPyeGY1EpspDMaDTKr+1NJA+gucfA7mk6RK5o1AIQ7rc6GzHlqpgt7/YZWr0JiD29j3SlInbQ/wZnM0+NOZ6EQpwkSVu8cbDyM1oQLBMAnp4U64FVBZbLqNtzf8qWAGzxKcoW6lC2/slOaxPx+DInlpgDOD4JT7DhacYIBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by SJ1PR12MB6316.namprd12.prod.outlook.com (2603:10b6:a03:455::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 20:16:09 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 20:16:09 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 8/8] vfio: Split VFIO_GROUP_GET_STATUS into a function
Date:   Wed, 31 Aug 2022 17:16:03 -0300
Message-Id: <8-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0147.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::32) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4713b2da-577e-4c0c-b089-08da8b8da282
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6316:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aBjoJQTRa1Lj2FWDEYK/YDxV81xb7twqe7CheswQMbF5Mbxce7GJnkAl3Xs3biPPUzxTguVNTcIMWEsdqKAL4zSm9uz3QmCoqHpEebiv3wA87R+xK+z5iAhIB9w9uFFwUVfxzIwm/jxDBi7nx3CGKhtt34IRd8jGuDlnXYaDHlAiarWM8WpVcWrw32CUY1R2nLKmH9AhR5U9z1qX1FYbIjvIM7udWRTTzMGkhcMIzyGHK1a9dIrLkjKGU0RA9076pKb6E/dWzwwliwoCuZTzcKNTo90T1DMn+gwJvXverTsH+F3qFe1b7oGIHBtgWWvJiYboiRAl8b1Sun63nxgRILmDvrpMt4RutIMpvr1QqihXwq/QM3Zl41ZVqzj6lc5JYtJScSJrEF+NvMVR+rHBQ7WSFEFD656eJzzk5DSL5M18DYYoGqRebAonAjHVooByHcmQQjp/76v/J1rNVP7usGVtZpwHERq0QxUIrOWUcHPgWmaYFO3dkdsZtUoTlIsrRjPoUFhq+vurGF+uLfXtaJ3JWUDcptR8AUOp57HrnA3p9MDPSEbxfKChKJj4r/eDkQZM3exeNN6sbeDxhYvUQeCL5am79+bh5zX31zNLp2O3TtvWf4Eo49ZFfyV0EL4NCOx+MiBnwfCIyS/1VXRJgTqu2r5JmOniChQGyIgC1TlgqBSy9Edtf2BRle35MAXo3cCHJ12obm22G18BhHektwAHLUlPqQcEQP0mdUEt7306+8VXuDO5Ny/m6lGBetS7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(186003)(5660300002)(110136005)(478600001)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(6486002)(86362001)(36756003)(8936002)(41300700001)(2616005)(6666004)(38100700002)(2906002)(6506007)(83380400001)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7yckVvzJhzmnhOLf3qTgxEOrqknr8CJTcdBI9vCdK0Rzq/Sxjt2Mdv8vZAxX?=
 =?us-ascii?Q?b4bzWUEk5k6b514kWg+9kWW7mNkMcws2hRLbUBeeEy8yN0SbxzlZ12hvrusK?=
 =?us-ascii?Q?Rfj7sAKFTGA9qKDh/JhdgHZPY7oM+ixTI54q5zeshIuMk3shOBqvBP3M+vpN?=
 =?us-ascii?Q?qkhnxFVJWKa/z9J3RpDb8Lqzg2US4rXyhzkq4uwaSKIIu7OAHc5BYxJI3Fbd?=
 =?us-ascii?Q?OEq1X7ivBtXPUU6iVy8V4gBvKfyWU/QM1u/vEcoY4wzGBnDYIkOmiotrd0Ej?=
 =?us-ascii?Q?5ebTh3StPLfsAM56n6iWduHW2uJU0ZFye03BTKhXPJQ4xM9tYB9rBh8WKm0G?=
 =?us-ascii?Q?qby1PfTyFCWbCUbQJ0m1MUFrvQvsFRzwsBlCXLTBnxMFrVTSpxGVpn7QOUtB?=
 =?us-ascii?Q?bPQXoYeaINAExn1w80obDx8Fv0j6pzcjKq1Z3CZg/3Ug3v1ybtOZsS1KFh9/?=
 =?us-ascii?Q?x3jeJDrFitAhLb1OxSQcgxfQTphCm6OwYaXXApamfX9N4QPa25oZ84TxLjkP?=
 =?us-ascii?Q?85CPMgKMHTPXn1MpAZDn42keKqLaXY+F0qrlM3urweOj6PDLxFv3fghQjSyF?=
 =?us-ascii?Q?Y3JwUhkyYmR9E/t9czAdXL7P8mDbfpN10nMv+iJXafqelRpR/op3kkyfenUm?=
 =?us-ascii?Q?0eE1jPCc2NA9Vqq/pf7Wn3JQwNtQk/PIk5ebyXnL8BprMIjvf/SHh2kq77qj?=
 =?us-ascii?Q?F3b25mD0g0x4jhOVlGOs+42sGpx/tbbZ4WJ4Etn/f1+HADcs3O8lz64jlFc1?=
 =?us-ascii?Q?NLqghPQSgMBLQ5oYUvuQieetrDNOXzZ636Sf2hARPUj16Ei1wxgvLiQG01pZ?=
 =?us-ascii?Q?A2G7YhSdCpqPxWytwh3oBgUWdIyxRdSjKN0L90fOUumGILAl9yuweCIrp/Aq?=
 =?us-ascii?Q?e1ESpVfDnL6R7vHAfIRPN2nfoh1o39Pbk+sDxxc+5IPUemvHOeRQe8DO7RJL?=
 =?us-ascii?Q?a4wUsiLikaM0RfK4DBAOH8CK03yHu8+OwVQbpDL+8gZixlLWKduR0TD6zX/+?=
 =?us-ascii?Q?ePoTqzIYcRkJp3Y7+RqgoDODEQFjstrCq7zpTE/tnlixwd+XHePW1+Tn3r6j?=
 =?us-ascii?Q?gINIgBeTKV7cLkTHNVr2JDDgJHPbL4dokh/7obK95ruQATVQ+ezrnBf/pUdS?=
 =?us-ascii?Q?SpRBoYaaBPZCjaaowIrzftXLV4VQenzOkPbsTrAVR6C7xrKWTnuLlX0rt7Uh?=
 =?us-ascii?Q?xUGx55JDLjuGIQvmyOjpBnV19KUjbXPUG9wLq/3C5ggoyk9o8NvXLGWBqObf?=
 =?us-ascii?Q?JIQ+q3Uvtp+lqna7x1JxK3RYL4Qt8yLw49J6nTQT/4Oj6PawKAwOpyu9bej0?=
 =?us-ascii?Q?MNRCwFOASLHiO8a9Rx1hQa54fHOZzpNBElhdkDQ++lbTkAtlkc44uWnbnoZv?=
 =?us-ascii?Q?jhnjmqukxT4VZMBt4KY0epzvHIAXT7rS5M5nDZJmVbO0IJeafBuV/WUOMAXc?=
 =?us-ascii?Q?lYDCzbE1oeC3+oNarTPloFJbdlDYiJM2wT7G99Yh5DfTinZR6j8NKO/2fhgv?=
 =?us-ascii?Q?7LbkZ9iOEFHF0KDSCP2s4R/FcUYWhrH4jXhZk3B9iSxcs77uWe8chgPkfEps?=
 =?us-ascii?Q?ZxgPP/aKpwhAORVNlV6Tpl4kVE1nK+NdcqqH1ESP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4713b2da-577e-4c0c-b089-08da8b8da282
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 20:16:06.1969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ahuvy41TGWaKMRivcQjMWk++nG1wekt9cjTjSYRwKdS8oIKxp6cNGll4236Sj6t6
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

This is the last sizable implementation in vfio_group_fops_unl_ioctl(),
move it to a function so vfio_group_fops_unl_ioctl() is emptied out.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 61 ++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 0bb75416acfc49..eb714a484662fc 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1236,52 +1236,51 @@ static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
 	return ret;
 }
 
+static int vfio_group_ioctl_get_status(struct vfio_group *group,
+				       struct vfio_group_status __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_group_status, flags);
+	struct vfio_group_status status;
+
+	if (copy_from_user(&status, arg, minsz))
+		return -EFAULT;
+
+	if (status.argsz < minsz)
+		return -EINVAL;
+
+	status.flags = 0;
+
+	down_read(&group->group_rwsem);
+	if (group->container)
+		status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
+				VFIO_GROUP_FLAGS_VIABLE;
+	else if (!iommu_group_dma_owner_claimed(group->iommu_group))
+		status.flags |= VFIO_GROUP_FLAGS_VIABLE;
+	up_read(&group->group_rwsem);
+
+	if (copy_to_user(arg, &status, minsz))
+		return -EFAULT;
+	return 0;
+}
+
 static long vfio_group_fops_unl_ioctl(struct file *filep,
 				      unsigned int cmd, unsigned long arg)
 {
 	struct vfio_group *group = filep->private_data;
 	void __user *uarg = (void __user *)arg;
-	long ret = -ENOTTY;
 
 	switch (cmd) {
 	case VFIO_GROUP_GET_DEVICE_FD:
 		return vfio_group_ioctl_get_device_fd(group, uarg);
 	case VFIO_GROUP_GET_STATUS:
-	{
-		struct vfio_group_status status;
-		unsigned long minsz;
-
-		minsz = offsetofend(struct vfio_group_status, flags);
-
-		if (copy_from_user(&status, (void __user *)arg, minsz))
-			return -EFAULT;
-
-		if (status.argsz < minsz)
-			return -EINVAL;
-
-		status.flags = 0;
-
-		down_read(&group->group_rwsem);
-		if (group->container)
-			status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
-					VFIO_GROUP_FLAGS_VIABLE;
-		else if (!iommu_group_dma_owner_claimed(group->iommu_group))
-			status.flags |= VFIO_GROUP_FLAGS_VIABLE;
-		up_read(&group->group_rwsem);
-
-		if (copy_to_user((void __user *)arg, &status, minsz))
-			return -EFAULT;
-
-		ret = 0;
-		break;
-	}
+		return vfio_group_ioctl_get_status(group, uarg);
 	case VFIO_GROUP_SET_CONTAINER:
 		return vfio_group_ioctl_set_container(group, uarg);
 	case VFIO_GROUP_UNSET_CONTAINER:
 		return vfio_group_ioctl_unset_container(group);
+	default:
+		return -ENOTTY;
 	}
-
-	return ret;
 }
 
 static int vfio_group_fops_open(struct inode *inode, struct file *filep)
-- 
2.37.2

