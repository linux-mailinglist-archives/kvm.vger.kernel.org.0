Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828035973C7
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240621AbiHQQHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240680AbiHQQHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:07:31 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331C64DF36
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:07:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPnLaiYszc3h82djO1BW/Vq6MPQtvtJXDxZoCGslFyRzfzFb3M/GhqXFFP8EQtTfLwsNoh1n7lcvDtXXesGOADFN89zEzPNUXET6CC+THNyKwI91tkvP+n0EngcvlwN0PO15cVAmce50fQRcUxyrGxcAG45zBBAnbw3IyimLTUkMZFBSAddqJ4Y1O3Sx+DaPYmAtMGgHXZiKdYaYnidaiTP42U1mX7BExKLOAsZkEimYsmQUsYVw9rqyUjHSDapW21Tc+PE+m6UL/Prju4Za8Jn/IPmvLPh+JtH7/J/Fzi0yykvJWwLJnT823Ydwd+mGRAZ3vv1ZWJTJPrGW2BZEIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PiB42TKK6sjXeV+/WWPIcy7avpfxgoZZr8u8Av2auYU=;
 b=jg7M1HdLArdD4JrLSCqxbX/i6lh3EhtEz2I7iMYPS4xMToU/TySPE9lI1PshgKj61EogGuo3NhKdTB8R6u7SlM6MzNYY89xucx2tkh4YNghoEz+VC1ll5hZ6+EPpqexsTVEnlwdFoRgrw64bj5ZlP7EjXBuPdzNNe+OTvzRL2XH4IN9rYKDHRtO6vmPjDUKQ4xeM8UOHuXVoBqN7i0eElglPNwJmLWuPtvdaqXvfa1htUbg1RNCG3at4zNZ3eXxhNQQPmQ8x9UT8nUs7ePBpGKwk0Fq34LAdnHGU3DVq5272+wo/UVcRXGg+BPgd+lmwYc8rixWlsLwSlfLJXo+Qzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiB42TKK6sjXeV+/WWPIcy7avpfxgoZZr8u8Av2auYU=;
 b=k2XoYVhX+rjARmiy8P7HUv03EMRyGUaWRgqv2oaJcjqYtlz5GndP96e9XkofUWl7Z3Q/wRzYNdrgX9+Ou9S07oHesZ41t13Ga3mYbBoWDGWHMDjhvkzM8YYQ4RAAb6WvgjHI2lqPKE/ehyeUomeCwASzQhGMjUmeQBhaG5FDLG3a1YBGfvgiPvOxBieOcv9/A+Hm2o7/Tv0Px5sl9zgP9YLIBMh2PUP9hvKemk7rXf4d5+z1T/pG42ZuCdfPYe/EIiYpuy2FMN9qszXYeRyHLb8HSq9HIIffCFVJSmvnfslPa/pUzIsjPcp8WS9JS0ZeZQpBjlRG7gtg12XK53/ntA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by LV2PR12MB5941.namprd12.prod.outlook.com (2603:10b6:408:172::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Wed, 17 Aug
 2022 16:07:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 16:07:26 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: [PATCH 8/8] vfio: Split VFIO_GROUP_GET_STATUS into a function
Date:   Wed, 17 Aug 2022 13:07:25 -0300
Message-Id: <8-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0054.prod.exchangelabs.com
 (2603:10b6:208:25::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e070f167-4bba-4c58-8fbd-08da806a93db
X-MS-TrafficTypeDiagnostic: LV2PR12MB5941:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3RA+emm/pFVXPVpYY/8kBFO6uf1NxgtjwcDRuFMu1OBKlo3PJvob/bWMCnKBcfWl6teYlE/s0QEbyyU2NZSAymmG3IaOEB7daUQvwPfNnA8toLp8/MmERZfUedzzwdDnodlyGbwLlLIOjkKuEGNawDblLUTrPZyge0fSCd01Sm00yOMf0phyrglEnQWqcGA3IF7F/oXm8mtKOkeRLQDMIlHg3+d/Ro6CV7tTxhsN15K0Yukule2F0Yi/3IJFP0iOOezQy2PC0cGW/GZju+oLTT6lpPWa29O8CyXgEPVwE4rgpSxaz2Qhr9oNp4o+RWUWUGmgyVF2h/pxObsPnQecNt/b8xToZBNaDgzmVP0+TRmwl7NS3KISJ66Oa+vpqTPDzEWJ3tzeJwoSIDL+TsVNh7c4NkawB791SXdwso0YcjVTCCYFrfv+iOQkomIpgjHn7g4U7AJ3w1whi2jhnt0TDbpFFhpvI5akvLVbGWODbkkjd+SO7BOfvWIImUr/zit5hfdiJfnHPweBhFt12x3C51JTi7IZuIK1Mn9Yo98PjmsZs/q5kuoZLio+d/j03Lr+h1SKYrsAZgotMDNgcxqX4FL7+vlS+OAa23K8nFA6Ve5BWv5gJhxCagx4lYx7IYHrVBx/Q+Mz+vwjBtpuDYZRs0tCjhKdT5+WHakT4fqMnpc/SlnbP7/4LdHRhccdSWUAPHFj8gKkAgUeUHrzCRMMzFBhsZEYmk7cbsQ3724RVV8+WIsXkqa0j9EUA9ijobWhHmLxMwAXPlklaleHahdMItlFn3gYrLJUwJNgypUuALQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(2616005)(186003)(38100700002)(83380400001)(8936002)(5660300002)(66946007)(66556008)(66476007)(2906002)(6486002)(478600001)(6512007)(6506007)(26005)(41300700001)(316002)(110136005)(8676002)(86362001)(36756003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jLldXYd1CJfTeUICyyRNsPDkcfDIPDZzj1NyjoBKnDDVMIDhoeSjoJvBuFql?=
 =?us-ascii?Q?OEIjTodun+E2y32EZISEJSQgCg1MGd7H9eiR2c5UnDZTsORjFcCbiFz64tKk?=
 =?us-ascii?Q?YsmFLN3DuBYjjoOQ6dms380JbTZ0QB1s5f1B7I5KkHSGcif0oQMqBVRzC94F?=
 =?us-ascii?Q?PLptZdCEFLd2WElthg9pB1Qtc27Z/HNXnN5TKxBMAv5bhKHuWcRF2ETiZQ5u?=
 =?us-ascii?Q?tAKnfS2l/wMb8IKXpLzn2WS8Bcfl8HGgcsnjPnZOuun4VnDJaNmufgZ6ht7K?=
 =?us-ascii?Q?5T8PNLIU5e6iHwRgPtBf5rZefgnH9RNUzQAHOyIzYzFXHaw13+Adz0m4p1jJ?=
 =?us-ascii?Q?kjl4sBWyYwp3fi1iGzYlev/NSbX6Prc9ZjSYjqXBagQqU6XySQyhzSDAEdQw?=
 =?us-ascii?Q?8pUIouUqX1J6+CrGNOH6zf4AyP0KnlE2ptZeYVYX6I6fwooFR/LnXQBtOiv6?=
 =?us-ascii?Q?UlhckDSdiOoNmaKHqgCW83T/bJWoDJwN+nk30fw75/khl8Hlu8AMjd5uEW1s?=
 =?us-ascii?Q?+c6S81gkSCRo78/9cZ7OWdwuAiXENObkD+t1AihW3tRfB3Uw2FmPXBFY5TC6?=
 =?us-ascii?Q?QgYrGX1AjGO3ZX1oTs7sHBlzC/kTWNgaZh2bESjAit8dHJiLekeQAPaIbo/t?=
 =?us-ascii?Q?2cbiI6qAcK5fIEEdKKhUIhNoSAmGkp/PQvCC57bM+yqEj8okB6rBDwcnU9lf?=
 =?us-ascii?Q?lqRp8KX3T19bs+FGZ1iLj8r1mmti599F9Gg8Uuh65BP/FAO6+vYKXHeRUILR?=
 =?us-ascii?Q?71pp/jMrnJ3iKNmNGisA9R9S7A9zMC2MoP6de6KIUdUOFxNJlMMaIrxCvFez?=
 =?us-ascii?Q?3hEqhRIVKiEibyYaRprua69uLz43/S7HSF6lr+zlci0uZJ1J8bBm91d/O/At?=
 =?us-ascii?Q?KBuNAAXnrfqYsKraDa5oFxTHp1H5CkEvVXNF0t+YRY8XoTJlZfR15+2cooho?=
 =?us-ascii?Q?GNSTidX6eJ5NN9YaHPO3j0PNU3F/QvGGxwPgzjs+BRhivy+5Hh+fdrwFvhiQ?=
 =?us-ascii?Q?6UroKWyTBoW23PWu1i4s3BxudbCPKBiJZcmsllXFYZQynNSdiMa62BjtxsTt?=
 =?us-ascii?Q?BdM1i5T5GT8Yp6zQUcNgaP/sHPYBRY2JsehyFkz5TFywfre18ClVHX5cHl80?=
 =?us-ascii?Q?fFXzZwb9w7230Xj6R2NWKDbknUrydOzFikjp8JvIShwCONeu5nRd7L/pzJK+?=
 =?us-ascii?Q?PBO5MbU6Zco4byWjFogUO+tpnFtEzumFVyRGh/OP4yuPR6eVvxk1WtW4P0qz?=
 =?us-ascii?Q?MlPeqDWUGi+54AEFDU3SU2gtwhpZJY0Y9HglYpeGtrx/OAh1mQJxxV+RTCEG?=
 =?us-ascii?Q?sSP8CbJ9E4vwT03AO3z+tTZrsNoU6Uii2EXfn4Jc8XTvxdgv19jiNoMCOrdD?=
 =?us-ascii?Q?o5PMUxk3hgbtkc9XIgdv/+wAnoZ/sBS5UgNo335RsF5gKBMjmm3SuvsVfT1K?=
 =?us-ascii?Q?nkjWRacnw7CLEEyGJ+W1zzlDvqptCJGqI1rV1pYz7QdX16cFEHpKctAI9nvF?=
 =?us-ascii?Q?UgeSDpoFI6795q9VTMio5zT0AB56/KDeszS6oYb8iG5sYxtqon+l7BQED3mO?=
 =?us-ascii?Q?LNfFVqbc7+Tn5PPCiBmBmjOCSYvFfAMTctKOoal0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e070f167-4bba-4c58-8fbd-08da806a93db
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:07:26.2812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KzYeFe6/CJRW1VW60Nzdxu32WfIiTV+TLI3IW8K9OY17vUviG6gT8JJFmVKNPqtC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5941
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the last sizable implementation in vfio_group_fops_unl_ioctl(),
move it to a function so vfio_group_fops_unl_ioctl() is emptied out.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 55 ++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 78957f45c37a34..6f96e6d07a5e98 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1227,6 +1227,32 @@ static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
 	vfio_device_put(device);
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
 
 static long vfio_group_fops_unl_ioctl(struct file *filep,
 				      unsigned int cmd, unsigned long arg)
@@ -1239,34 +1265,7 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
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
 		return  vfio_group_ioctl_set_container(group, uarg);
 	case VFIO_GROUP_UNSET_CONTAINER:
-- 
2.37.2

