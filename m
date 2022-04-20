Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9D650905E
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 21:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381769AbiDTT0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 15:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381764AbiDTT0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 15:26:07 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2070.outbound.protection.outlook.com [40.107.102.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52463424BF
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 12:23:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6biPazQvtfOCyBfTDVk2o7uEcrX2YCU/SPd1Y7OvfUCK+kMw2uzE02pqJbBY7S8UxtisDPf9yYTe4cFJajKvO2VFfY2Wwzoewctbj2qZ0foGemqeh4yRXWOrmyPz5yNR7tDoOFPEHzehYLxA0pET3rxwNQMc11iB5edH48EUtxo65f5zEnkiukAmdTRYVUYP8W5EoRCne76OVjOjdemf8RBLeVq9FmT1P6JBYXOknAyy4hvURasUTQ0pWUXYCICHUjgL4gFlNHqlSLaQe6mykNtC6MlnIKGlU84iaOthZr20I3M4Q5UmR3H8Z5+WAzXNL1AQJ/pp7cSOOxxPfdZ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=039dlDF4xOBIrNO6BimXWmwlz4m6tv4rP/nmsVn1s9c=;
 b=USU0hr+7UucSfaRbR3BYiuXXlEu1rhW3RCoUEURu/SfzjRyMvatlDh/iXsyahhnp1CIAyEXorHDyAbfipSqYI8Ly18Eo1YK9a+/9Pux62jg6n6KuMGDnWZGzDbAT3yW4aa/M0m07FTi1p0RP2LWWtbxP4NADrKfdaQvWNaok0RNhobc9xKyGCdSM/ZklLP32C1rEf2THiljXgAoZlMFmtuZfOzxdC2f6hlO+pYLHIYnf3P6D73DKB9hxomQa6vvBAjhNeWxUB9NOTgXqg3jgsD4C+uG/TBd8cj1S1rcAdWngekzkIYRaBZUvb7YwGdFlob77K71fZQH18in7Nwq2QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=039dlDF4xOBIrNO6BimXWmwlz4m6tv4rP/nmsVn1s9c=;
 b=lZvwP5Mr0IrsVnXY95qZWy3+igJ16TpNuNXphp3Ax9Qzyq/Er0WjlOH6TCCEbs89KpXyD4/13eE3sg6S78JRTbMvqqgWbKSjh6CzVHX2X4irymvfLBRCwifhIBXXX7sK97QeB0bs562F2EhzBb3+BoeFtuyhgzBCFGtCgh4nbyDMWF5N7HxRCeAiTiHzcG+uod+1u7MyRuGUMyXAVq84Mmq07SYIJYur1se6vwlZXzK9bGw9KwzQg4CIMuCM1/I0QgonhV93RacKYZFuT0Ysvbf8z2kxXuBD40sbN8k4xkFcAHgaW/cndawNafjW9zGkjCH2RPE1no+v4k5wcw/4Qg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB4679.namprd12.prod.outlook.com (2603:10b6:4:a2::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 20 Apr
 2022 19:23:18 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.014; Wed, 20 Apr 2022
 19:23:18 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2 1/8] kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into functions
Date:   Wed, 20 Apr 2022 16:23:10 -0300
Message-Id: <1-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:208:236::6) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93511acf-9106-4dda-aaf9-08da2303398f
X-MS-TrafficTypeDiagnostic: DM5PR12MB4679:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB46795E61203491ED87891C78C2F59@DM5PR12MB4679.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oF89w1TLolCXw1Wzcz7N3VvtUIR/viS16wSDa4yxsf5gBevOlnlTtCbs3fcCcqTyueEODWXWxN2qUn9QG5XcubsHWOwAxX0bAAnUBdZ88isUZZLqlV0/kmd8IcOx05aUieyn+7/kg4iRVtUmgoIeBX4z3SCzmI54i8HrsO0+3jdjzXzjQOylO0VYniSjfPw/n6w2y4A7SKgMQ/ahiiC4OfFUSmEoTyUJIx4AFqHKaC68XJmVypXd83nmwrUWIpvWuqhGdN0/BzlaJFZJAmhVDWS5JyK/zO5+UvOiQRtRTjoI7tkpeLZmbBRinJ6bRMtjKlOQugGw0eNAgCVCYXXriK2vpUnEBcZS8yKDHC5c2LpYGgynuntgDvzDHu8akV5i2ms3Y7a5E9TCxmf3I49FD8MR5EjWsBT3ZbavYiG3o0LhH7LOCPcAEAJCzXswQ3BhREguSGF27CghpyGhdTO/gJf+c7TScQkJcyxPEeeB6Mdq0lOH9aw2TAS8DpKRz3kRGVlxk4W/J+uUCt/lazG33yzc0Ju1XLUhUh0boJw4vicoNWGCPVqP2sS6CF4mTu9AFISOH7+rkn/Ml8S1vfL5hXSkp2IXYC+RsnnFgHm94RXxFOOPyPc1h0IoKE+pC46s9AqpHyxkVLdw8WY98wMnvW3cVtqqWjBjH0wLqDEGGeEw18Dh/aB2UPj3Ju9d3BLg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(86362001)(5660300002)(83380400001)(6486002)(36756003)(4326008)(2616005)(186003)(8676002)(8936002)(2906002)(66556008)(6506007)(66476007)(6512007)(6666004)(26005)(38100700002)(110136005)(54906003)(66946007)(316002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zvuibC7lJfaaBH5hnFpBSGHJL20wD3szly1rNoa9JcEFckDH6DMyoUeCR59k?=
 =?us-ascii?Q?QI3BcchSzNEzlWRnblaEfGv7kx3cN7re4SH9N5O6RvxwikqrBI0CINqmVaWS?=
 =?us-ascii?Q?Qxbj0ogH6+Hq9uL/xtsL8Ry6miwTljjBnzfTfbQ5AI3+6CFWIN+D7fC5nVSm?=
 =?us-ascii?Q?Mh+0TDpFl5ndj5UWWxf0T9fWhkuRSXojvm8KinihpWOoVsZwjVVf0biIn3Tu?=
 =?us-ascii?Q?3PO4kXr4c/hyDGf+AAzO3p4H4Vl/5roKpTvQzWQMuUO8Bi6ZfH5nOkb9wrfE?=
 =?us-ascii?Q?I+68aAgiOcgFgDwEdL85eM5elnYxCxKHfLcjDngSoIABgGJmSiIQi4OfOv7e?=
 =?us-ascii?Q?Ha4yPy0QEpdDtoZ0mHCiuDpy0rwZAmIyBJzdjkSQ0OCijQw7o4iPgrzXrIRq?=
 =?us-ascii?Q?Z+Cdi7Rx+ZirUZKTH5/s4hGbdBB7Sn7KaAFvze92/De8DtZHf0/FELu3n5SH?=
 =?us-ascii?Q?R/VpzQBvzLGZ0zGWlcpa2L8sFXP3qJgI9vaeMuQmJOQEzLDLsrlEWhm92WDM?=
 =?us-ascii?Q?qH0v59AOkwXIyV2KWb8jma+zoDr6TVSyWQZLTE4kJedomL4/UkENVQCql6Sv?=
 =?us-ascii?Q?mY0JUgV3Bt51IkF7Mb6zUrQn6a8VFGjXud3DnbdSmCQLSC1wQVZTnUaFZuBo?=
 =?us-ascii?Q?JEqbCq/jXqcNgKdGRK9Ru5z5xeSOalvA/rlmnDnfxfpR1mvPxTMuapIoc377?=
 =?us-ascii?Q?YccrSjVAvJ3sMiD6MBDRJXkJZLyeFxRI75KvJbFQy1LxtepSh6OKxa2fZmMd?=
 =?us-ascii?Q?d1hVEqONaPVMIU2awgcCkzzk/vHggyc6u0yLEb3tJjKGSgk9uiasU5rICz6T?=
 =?us-ascii?Q?fXvLAY1zvFK3c9hWW7kmpE9HB1RZOXLNXgor58/CN4HypAoQS2tMWHZayR9x?=
 =?us-ascii?Q?MS8KyL8lFX7hJSHyukCaA/GauAKRq74FTvScsGn3tAGgxuYcQM3r/Vti0bjc?=
 =?us-ascii?Q?NbXt6cC5iUrl2v97Q11C5X9n7K4kfY0pGsMAR/+iwdVikTruTPIl2yRsXtPU?=
 =?us-ascii?Q?O7lyQNoyRsN4yafKcLcFTq8aqPDZv3fkcivt+O7qZATUQ7+/BBscqRwwxrGx?=
 =?us-ascii?Q?gD9h+3QRMweDVjBurA0yWGXiGcqIzuUsXUaNlp27ZmEpaIIQbF3iw9AXJRVJ?=
 =?us-ascii?Q?XJu2vk6ScjK7W3UqtpIwX5CsCtGWQMeNDYJdoctBYA1vDOnUMirF7u7LkhYf?=
 =?us-ascii?Q?q5mJ8Td5Lz9uCrO+EemexgcyHpgUikKJvItOTjRnd5oMHwGV2LkRxn2y0gV2?=
 =?us-ascii?Q?KNJv29yURiWcPxk37WTApf5vsArYpXerhmywxR0Zlw2Tj/UUaYCrgdHsvtiq?=
 =?us-ascii?Q?VZ6REMAUMA5NTapDHeajnr7rTpHj7Qcg1cigca8yF+RNpQoa1vBqoVkUvirW?=
 =?us-ascii?Q?lcS6Hokf+d9xll5HOAY/pxn0rR+1g2uG9eCHE91BTdqwPjbJ4niUH5+f9GFO?=
 =?us-ascii?Q?CQy8sgnufB16l9SGJOHavfbXmJd2pmswDeFICKk96YdbzFhA7rzHj9mmeBJE?=
 =?us-ascii?Q?0mMBaAVaq+inzgKp/75bkpcNjqFaEFvtFPE4892hDO48NXUT2ccAsJawgcCa?=
 =?us-ascii?Q?jRACyCXmsjxerJDHfY/R9k89GOFGOF1Nqq3o2XtJaWCF4CUfOA1htHrwYKlU?=
 =?us-ascii?Q?bm2cZ/ksFpX/OvZTABshQPqI+I3FkumIIbnUAtKub3svXo/JTjRDVsGCRFZj?=
 =?us-ascii?Q?2uskZ2X1/DAdybqn9i7idppBQ1g75/7cwK9K+i0mh7PF1EhFzkOBSSTNnQOM?=
 =?us-ascii?Q?F9/WW6M0Pg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93511acf-9106-4dda-aaf9-08da2303398f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 19:23:18.5968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yzl62jM6uDdEZQXAzwTMMOCR/ARbRgkNk7neCuSE4j4yUVVhqPueqktpfBwdIVlb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB4679
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make it easier to read and change in following patches.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 virt/kvm/vfio.c | 271 ++++++++++++++++++++++++++----------------------
 1 file changed, 146 insertions(+), 125 deletions(-)

This is best viewed with 'git show -b'

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 8fcbc50221c2d2..a1167ab7a2246f 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -181,149 +181,170 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
 	mutex_unlock(&kv->lock);
 }
 
-static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
+static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 {
 	struct kvm_vfio *kv = dev->private;
 	struct vfio_group *vfio_group;
 	struct kvm_vfio_group *kvg;
-	int32_t __user *argp = (int32_t __user *)(unsigned long)arg;
 	struct fd f;
-	int32_t fd;
 	int ret;
 
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	vfio_group = kvm_vfio_group_get_external_user(f.file);
+	fdput(f);
+
+	if (IS_ERR(vfio_group))
+		return PTR_ERR(vfio_group);
+
+	mutex_lock(&kv->lock);
+
+	list_for_each_entry(kvg, &kv->group_list, node) {
+		if (kvg->vfio_group == vfio_group) {
+			ret = -EEXIST;
+			goto err_unlock;
+		}
+	}
+
+	kvg = kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
+	if (!kvg) {
+		ret = -ENOMEM;
+		goto err_unlock;
+	}
+
+	list_add_tail(&kvg->node, &kv->group_list);
+	kvg->vfio_group = vfio_group;
+
+	kvm_arch_start_assignment(dev->kvm);
+
+	mutex_unlock(&kv->lock);
+
+	kvm_vfio_group_set_kvm(vfio_group, dev->kvm);
+	kvm_vfio_update_coherency(dev);
+
+	return 0;
+err_unlock:
+	mutex_unlock(&kv->lock);
+	kvm_vfio_group_put_external_user(vfio_group);
+	return ret;
+}
+
+static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
+{
+	struct kvm_vfio *kv = dev->private;
+	struct kvm_vfio_group *kvg;
+	struct fd f;
+	int ret;
+
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	ret = -ENOENT;
+
+	mutex_lock(&kv->lock);
+
+	list_for_each_entry(kvg, &kv->group_list, node) {
+		if (!kvm_vfio_external_group_match_file(kvg->vfio_group,
+							f.file))
+			continue;
+
+		list_del(&kvg->node);
+		kvm_arch_end_assignment(dev->kvm);
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
+#endif
+		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
+		kvm_vfio_group_put_external_user(kvg->vfio_group);
+		kfree(kvg);
+		ret = 0;
+		break;
+	}
+
+	mutex_unlock(&kv->lock);
+
+	fdput(f);
+
+	kvm_vfio_update_coherency(dev);
+
+	return ret;
+}
+
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
+					void __user *arg)
+{
+	struct kvm_vfio_spapr_tce param;
+	struct kvm_vfio *kv = dev->private;
+	struct vfio_group *vfio_group;
+	struct kvm_vfio_group *kvg;
+	struct fd f;
+	struct iommu_group *grp;
+	int ret;
+
+	if (copy_from_user(&param, arg, sizeof(struct kvm_vfio_spapr_tce)))
+		return -EFAULT;
+
+	f = fdget(param.groupfd);
+	if (!f.file)
+		return -EBADF;
+
+	vfio_group = kvm_vfio_group_get_external_user(f.file);
+	fdput(f);
+
+	if (IS_ERR(vfio_group))
+		return PTR_ERR(vfio_group);
+
+	grp = kvm_vfio_group_get_iommu_group(vfio_group);
+	if (WARN_ON_ONCE(!grp)) {
+		ret = -EIO;
+		goto err_put_external;
+	}
+
+	ret = -ENOENT;
+
+	mutex_lock(&kv->lock);
+
+	list_for_each_entry(kvg, &kv->group_list, node) {
+		if (kvg->vfio_group != vfio_group)
+			continue;
+
+		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
+						       grp);
+		break;
+	}
+
+	mutex_unlock(&kv->lock);
+
+	iommu_group_put(grp);
+err_put_external:
+	kvm_vfio_group_put_external_user(vfio_group);
+	return ret;
+}
+#endif
+
+static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
+{
+	int32_t __user *argp = (int32_t __user *)(unsigned long)arg;
+	int32_t fd;
+
 	switch (attr) {
 	case KVM_DEV_VFIO_GROUP_ADD:
 		if (get_user(fd, argp))
 			return -EFAULT;
-
-		f = fdget(fd);
-		if (!f.file)
-			return -EBADF;
-
-		vfio_group = kvm_vfio_group_get_external_user(f.file);
-		fdput(f);
-
-		if (IS_ERR(vfio_group))
-			return PTR_ERR(vfio_group);
-
-		mutex_lock(&kv->lock);
-
-		list_for_each_entry(kvg, &kv->group_list, node) {
-			if (kvg->vfio_group == vfio_group) {
-				mutex_unlock(&kv->lock);
-				kvm_vfio_group_put_external_user(vfio_group);
-				return -EEXIST;
-			}
-		}
-
-		kvg = kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
-		if (!kvg) {
-			mutex_unlock(&kv->lock);
-			kvm_vfio_group_put_external_user(vfio_group);
-			return -ENOMEM;
-		}
-
-		list_add_tail(&kvg->node, &kv->group_list);
-		kvg->vfio_group = vfio_group;
-
-		kvm_arch_start_assignment(dev->kvm);
-
-		mutex_unlock(&kv->lock);
-
-		kvm_vfio_group_set_kvm(vfio_group, dev->kvm);
-
-		kvm_vfio_update_coherency(dev);
-
-		return 0;
+		return kvm_vfio_group_add(dev, fd);
 
 	case KVM_DEV_VFIO_GROUP_DEL:
 		if (get_user(fd, argp))
 			return -EFAULT;
+		return kvm_vfio_group_del(dev, fd);
 
-		f = fdget(fd);
-		if (!f.file)
-			return -EBADF;
-
-		ret = -ENOENT;
-
-		mutex_lock(&kv->lock);
-
-		list_for_each_entry(kvg, &kv->group_list, node) {
-			if (!kvm_vfio_external_group_match_file(kvg->vfio_group,
-								f.file))
-				continue;
-
-			list_del(&kvg->node);
-			kvm_arch_end_assignment(dev->kvm);
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-			kvm_spapr_tce_release_vfio_group(dev->kvm,
-							 kvg->vfio_group);
+	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
+		return kvm_vfio_group_set_spapr_tce(dev, (void __user *)arg);
 #endif
-			kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
-			kvm_vfio_group_put_external_user(kvg->vfio_group);
-			kfree(kvg);
-			ret = 0;
-			break;
-		}
-
-		mutex_unlock(&kv->lock);
-
-		fdput(f);
-
-		kvm_vfio_update_coherency(dev);
-
-		return ret;
-
-#ifdef CONFIG_SPAPR_TCE_IOMMU
-	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE: {
-		struct kvm_vfio_spapr_tce param;
-		struct kvm_vfio *kv = dev->private;
-		struct vfio_group *vfio_group;
-		struct kvm_vfio_group *kvg;
-		struct fd f;
-		struct iommu_group *grp;
-
-		if (copy_from_user(&param, (void __user *)arg,
-				sizeof(struct kvm_vfio_spapr_tce)))
-			return -EFAULT;
-
-		f = fdget(param.groupfd);
-		if (!f.file)
-			return -EBADF;
-
-		vfio_group = kvm_vfio_group_get_external_user(f.file);
-		fdput(f);
-
-		if (IS_ERR(vfio_group))
-			return PTR_ERR(vfio_group);
-
-		grp = kvm_vfio_group_get_iommu_group(vfio_group);
-		if (WARN_ON_ONCE(!grp)) {
-			kvm_vfio_group_put_external_user(vfio_group);
-			return -EIO;
-		}
-
-		ret = -ENOENT;
-
-		mutex_lock(&kv->lock);
-
-		list_for_each_entry(kvg, &kv->group_list, node) {
-			if (kvg->vfio_group != vfio_group)
-				continue;
-
-			ret = kvm_spapr_tce_attach_iommu_group(dev->kvm,
-					param.tablefd, grp);
-			break;
-		}
-
-		mutex_unlock(&kv->lock);
-
-		iommu_group_put(grp);
-		kvm_vfio_group_put_external_user(vfio_group);
-
-		return ret;
-	}
-#endif /* CONFIG_SPAPR_TCE_IOMMU */
 	}
 
 	return -ENXIO;
-- 
2.36.0

