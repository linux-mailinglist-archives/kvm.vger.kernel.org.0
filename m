Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1B15A731D
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 03:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiHaBCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 21:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiHaBCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 21:02:11 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471966F265
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 18:02:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eIekHfA7b4m6azRxtcxTiF6/juvV9odkdiKpWVgc518Iat4g0jDCxnywWAKD4zjJON0rneEPickufr+y9avjsGn3ZnmejfnnLs4kEkAbE7ZwLnnpQfdxuTSyT1Z3iS8ck7FziXCtog0lTOyHnte32mOF9JbX8LaHp0gimKiP9pzenCQ36FYegAZ4igyBmFuRAfYaZ92i9/JnsCJ/K14ZewmtOZ1KIb0kPhYPLak5gHe2hg8bL/bHiFYy3TwSZ3D+8iQ6DNnPQEA+ti1FzikE9i48SskaQ/9J579IrAbKPVyjoCQ1vzqSsWQJFUHHCAGqlbpczIh85tn72iOYxmZbnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=07RH721Cu/41OICQ+qEYDuhmoL13POnLjf0GJsNJAXI=;
 b=ki9//29XlXmoJMDlAinpCQU61atqv0wuS67HtVDy2zBt6RNruSVwj+DvmwspocLQRx2WKrFeqitVB1lejy8JgkJoFHqZnmlxMQAiix31razExfg10BuHaDrVWsb2bKeetrYHYzjW9g+oZiIbFYUd/uG0oQAZ8vG1eUVI4Q5MXn9K4wW2YRpogI5qSSt9SNUklL4j5UIT1HLZbWu59mnc997piO7wDDxm+J1f79tWkEsa/N0j2IlAcBFp/RBDkyRGiydN/orN+35Kys6ShvMRZqSmuA32ozvq31G54CXSPAmUaesUfsUpTMMFq/23p0QVsOza8pwT3HYSxHMnz3tLqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07RH721Cu/41OICQ+qEYDuhmoL13POnLjf0GJsNJAXI=;
 b=XkrYXesDPu5J8IFhAHPWxmWRR7TA3bVWraK8Z1YV0X2t+lN27T5HdKtIbqzNfBlN/uE9pGY7YTIjtBdzK+0aBUW/LPzNhlHB89c+KArJRu25k5WXtHnbW2y3/QzPNspY8KqIAJtBluQQQmtCM9tO2rUXTf4CYoJTYdryVwNmfonzKc+gUWGQWaqR5T6eZoqOaH5xQR+A5HTiKNjVazDIfo0s8EKyR8TJWJ8aMiTAgdbbfirQD/CDfIM4Gr56ff/rzkild7c+H9ymR99XhEjpV+L2MPhd77js0Zc8xX6vdCTP29ljuCyuTRkUS414SjPMvxfn4y7hEVjw0Cd2Vc1KBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5410.namprd12.prod.outlook.com (2603:10b6:5:35b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 31 Aug
 2022 01:02:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 01:02:07 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: [PATCH 3/8] vfio: Split the container logic into vfio_container_attach_group()
Date:   Tue, 30 Aug 2022 22:01:57 -0300
Message-Id: <3-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0092.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0cdeb1c-726c-4df6-2ad9-08da8aec6b05
X-MS-TrafficTypeDiagnostic: CO6PR12MB5410:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T527E1Xv2jvwWmeRrSALCVzVYl0Kq8q6szSsXGDdgU8Oarfi0fO225hMmMw8mm12lNlwqUVTs3STcFotYV+AKtzxALXEdrV8U/YccvBZh9/miQP6IU1P8xulnErLCRKcYR4O2If9eZF5ocR69vZ7g9lKydqzhyipR3ywPzFoPeXawkPDQy+ZX0zGoRrc/gM4GIuF0IQeom0KHzm3xh2yU92o9pTK59+jAHVhSNVqPX9ue6gSDfHwFLGgA2ERqr+Cx5+vctU7Cq8m2sGd3SqbOyafmCk7WmrT6A5doAhvYJaxlJoTaOS2xXjKGlbqohAiO7U8bgNy/nufwQ3mh03eWNhkrik3t4/ahn5rGDcfMM+YXXztPx2RO2ce6tg0JRWml3okaHV4yKrWuMH8DRHbGQLtWXYKqnpjp10gNRERayhl5MiuFJB84GI4vvXMDnkbkY2gmqDujt1ub+uutwHIbnDiNgvGLwQbOH/QYSM9xXWHVt2Fl3NMiF0007ldsEwMDJGzS5l8Y1OJn8l5cnzRsV2cLpqEbEMyUAkxbZM7nWdGcLwDauj95O3Lank5KFlNzLJCrBr51DXrpsJYd9mjWWxlSDnxHWp7iPIhIWnObdwIkp6mpEDQQXxIsweZ/phTYYKVrAifBJjqzqxQrGC33JR71g5GBd6S7lhpTCaMNmERGVZfyXoLVzfQi08X6X5hxiuSdkr0HzZmntZK061JAQnF7UtHMp8QzEdF3lO/kpjdD7R3ZhFz+OwuSYto9EN2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(6486002)(316002)(110136005)(66556008)(66476007)(66946007)(8676002)(86362001)(36756003)(5660300002)(8936002)(478600001)(41300700001)(26005)(2616005)(6506007)(2906002)(6512007)(6666004)(38100700002)(83380400001)(186003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1gBsFWdxslOGQ+okUlctqQ/1LUNMvLdp68A4ch9+0GnkyZrmrjiH5fhyQqrB?=
 =?us-ascii?Q?eiDFk1SGAtkAmyPe38DybrecZ2Tf15iaM6Z4AGzJO0D+viVybMdqUb0KCMyh?=
 =?us-ascii?Q?pqH1aKM19n4WI4pw2PzUjsaE11kbps4sJDmAQbTXfE+3rlY35Wo0YQaS7g2f?=
 =?us-ascii?Q?NXk5P2KfbEV9SRlrsS4cRDcmqcgksJ5TgNYkCfh9Xc1Bom/pJX4fpQZEY+ss?=
 =?us-ascii?Q?OFxsgRN1E0s7rym/FLkonKYQRqgZMk2L8zv/0JfW1NFNXTjZ5WPCShJY5vUO?=
 =?us-ascii?Q?dLXxheo+dnZTVudEtZyf97KxCI6X3DGqUxhIay6vihf8AjhfjczsAZoN1Tlc?=
 =?us-ascii?Q?Cgv9FLCOLW5z7JmyU9DZDyQ233yA2yix2VCRImgGCXwj4rK66UPmQxGaCIiE?=
 =?us-ascii?Q?dGJX55TDUnxzAdBm/ihq/oMBW5kcU/Had+Ux6d2h9+OG7MEBcYt2gIonwTtd?=
 =?us-ascii?Q?LAOrQtToY5pFDhDTKc5x1JYczib5CBmF4YXqs77EzRzliSH7lZXdoVmENv50?=
 =?us-ascii?Q?LaemvLq0e7uVKGur7alsC1J4yzSEfmlfFja25ojLepV6A1Va3dGoTPpXqOet?=
 =?us-ascii?Q?ZS5fYuLH8nSKY8WDgZA+hpjUmrN0YfD7U/xDlEjXlmfpXOMLBcf0EPMko4+1?=
 =?us-ascii?Q?wH0DL4ge3NzFqddGzUUfG3He2Yw2kd5zlfP1Dl3sj3ti3CPIy8H/67UoKc7+?=
 =?us-ascii?Q?S5Vr1DzAC+25ZJzYNGfcbS2WOkRGge1XuAy/KaSHFLzRGFvaHmL1H1m8GfRW?=
 =?us-ascii?Q?bNcofgsH4nUUPJM0R1qT1RI4i+EcStrC46niWMlybYgT8V1T/HM5eac/ZW7L?=
 =?us-ascii?Q?jg52JF9MwX1qrg9tqGzo8rbncN4PoxY2zJmjm+7fcMX6JOOkvnpfRWDPver0?=
 =?us-ascii?Q?tUxhW8INMW+5uLsEY1F/ljfisEr0GalGPmRJBE34/3dAS1MA3OjwOR7ImoCr?=
 =?us-ascii?Q?omhBxcrebLZQoOCRNERBecVslQ+DYtKkEOHrU7ZNBUE3vOr/1E/BHufUrDPT?=
 =?us-ascii?Q?GojmY8r/WxVfr26lAXD7KSHjJ0XZfhinlPsXuCZZ4H0l9PwdDL5XAt7aIpVT?=
 =?us-ascii?Q?d6GgLIdTzq4z1u2WJoc3WYa5pjoqD8q483j8SceJvPempTo/WBeZt1Q600um?=
 =?us-ascii?Q?gvy6EOQeAIbQb4kDuPejXx1f0sqDV3u3CBkT675HGuz2dCSfcK72SmFW41yS?=
 =?us-ascii?Q?xu9MmqwA1UWwLb++WH1O9GPISXRMfFP/utwtJ83W67ZXC8yufWcI8HojHDMi?=
 =?us-ascii?Q?zQuszZdKtFPuL7j/ggghlYlZwinxKeIN2rMw2/yMcmFt5u/nwqPZGA05yG86?=
 =?us-ascii?Q?naYuxjtOEmW8xcDueh+WQSV14bZFC+CZolX6Lm3/84QbweyeahsrpYJ9RsGn?=
 =?us-ascii?Q?Wrcrq37t0jnZhaxa4r3Zv51lhRkqvVYnNLef7JW8VE1RDwwIP5uGFkHsVQEI?=
 =?us-ascii?Q?PwK4S5ZVGZRH0L1AXmdu2nP2vO6QXN/Ti+h6tzRXF5ZKaCxbtIg1yO9M6RrW?=
 =?us-ascii?Q?Xn2GAJdjBy5EQ+xu0/Fdi0IKjoTu592v7K7K/u02iIH5jqRDSjyl31eHDWm3?=
 =?us-ascii?Q?idG92/QZbZ4Skyvxr7nNpCmKDprGAxHYbSPF8fQC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0cdeb1c-726c-4df6-2ad9-08da8aec6b05
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 01:02:03.9855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TwHZoUQmODss2xKS2Qk48bNsTdN+sIlXZVIkBIb28tYKNG6uYJOuclss/iOrBRvG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5410
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 78 ++++++++++++++++++++++++----------------
 1 file changed, 48 insertions(+), 30 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index e145c87f208f3a..1108ba53fe5c28 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -981,40 +981,29 @@ static int vfio_group_ioctl_unset_container(struct vfio_group *group)
 	return 0;
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
+static int vfio_container_attach_group(struct vfio_group *group,
+				       struct vfio_container *container)
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
 
@@ -1026,7 +1015,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 	}
 
 	if (group->type == VFIO_IOMMU) {
-		ret = iommu_group_claim_dma_owner(group->iommu_group, f.file);
+		ret = iommu_group_claim_dma_owner(group->iommu_group, group);
 		if (ret)
 			goto out_unlock_container;
 	}
@@ -1054,9 +1043,38 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 
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
+		ret = vfio_container_attach_group(group, container);
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
2.37.2

