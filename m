Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9914E3466FD
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhCWR40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:56:26 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:36673
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231346AbhCWRzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:55:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNzg0+deYmfPwb4gcYuRRRi1s+1TD1dd8tD1uECer0hBrHB+PoU2yniYk0FiCiuPkNoadO8b7a1DlAIeDNH2t3lLcmxq9HwIGzbxrSEgw+kWtGAVPuNKGSc1ZvfwQd9AdDSSfBuTa2Zd7gKEhQdSK+0HSbPp8b0S1ELNT9QtzJBvkR/VIZpfuh2Y37/VingBWMrjABEH5plm9wWjsaV2OmfgFMo0ep0+Hmpz36M39h7Cdqt2rk4P/8KFequTHZ6MCo8DJvxShvsje8leJDRHArmx235lu6gV+1rbgU3midhK8Ay5T3eAgGQR5Wx9hmAPUVfXGxLZVidO/vWEflzyRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9FBnjMLFzAP/yExmLNlHOzDYDAey6bBAxCyU9pQQbA=;
 b=MYydW4uf6EEjK7cbSzng7iOk61NPVzx4WIkocfVRODfAS32B+8fegKe/nFZQyZ+Fa0sHU2BfU7zLv20sJ1ZtuKHqSLuFys1Gl2c6l2ARuZmfZw7mw2AyzQ33NI2IJYDsQfY8Q8Ah62MESA/E94gsEp4UPOaF3TA0gMi4E8ELGolL+VAwybMxTQ0ssGMnvDa/QiTOcQYoCgQyUwp+sP+7YzCe6lPJNWFRwwQ6meJixxmThDKS2TsojygqBjGSAKXKx43BRmvziJR3njeBLcFslw/Pz9mFQa9vnMnZYDtRSiTF3L4ovM6dI18z0ZdlYBss93wA7xAAvTJR9KkfQl9Jpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9FBnjMLFzAP/yExmLNlHOzDYDAey6bBAxCyU9pQQbA=;
 b=dV5fAeF0k3AkYgc3imd8nIJQHZ7Df+KqDz2cJbdGVEjwrn0XEpgFaaw5tO78iVRqMbiKT8/BqMmCL29m8Wchblym4vajMs8ACmMauCtaBMit1Oi/w3xg3TUmasljK7TDFvGMTARosND/oS55Ib/jezsHQngGXbPh2G8oMnhwiks5ksp2g4zcSB/nS3F3vf0q2ZfB15oEDmD4EnrQuKFEF+wGgKop0v10qY8dA6YCyO/NaZARJn2EooBuJJJAcAhkjRwMkeSga68mJth//g2Ajdv6LzOYWxG/5rPOOQ69HYHHQyKhVaJZSgvJDgWGLFMklBlyB4S2WH59SEltRaB9yw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4943.namprd12.prod.outlook.com (2603:10b6:5:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 17:55:45 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:55:45 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 11/18] vfio/mdev: Add mdev/mtype_get_type_group_id()
Date:   Tue, 23 Mar 2021 14:55:28 -0300
Message-Id: <11-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BLAPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:208:32b::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BLAPR03CA0009.namprd03.prod.outlook.com (2603:10b6:208:32b::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 17:55:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001ch4-Kr; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 241cac25-3bfe-4334-5351-08d8ee24e035
X-MS-TrafficTypeDiagnostic: DM6PR12MB4943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB49431ADEF24831F76F00DDD0C2649@DM6PR12MB4943.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:146;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /w9MN2Xgq4xU6W6SdR5K8k+HGwSx709F42BkLmRzA+Y+8D7RxoJc9qp3PZXf8T672Koq3HB0apkZ6AysNLH7Tba1Xb+HGOFpYzO1UdMgim6dhrMmql2zttCf3Z2UYd8yJNerRBPxHyIkOxi7z6XTYVnv50JhMjSeI2OfVm2YCTYzVbnYN2y+bUBnQCifVy/1rGqawKrRZXAScM17wrntBx1FaBShjz7D5ZQerRht5oeHUS6X+rQaZOsGNGNIHr/w/+B34jpzp9GY9vkg5hcTeWww5xPs8GKsOKgiVcGrqn3kaDomZ6MrnenvU9N3gABRQxqLTFqornQ3PU9BZoXSJTcedKjVpF9X/JL/WNDlRSf4nE8+pm2I2w6iwGjk1eCNIBNuE2BvwTmUM1yt5yl/WzU5i4lV7G2g+sNFPRGXwI/xGMmfXy8KP1tIDcX/Uw2eoeKOUdBje6kDKfqYIL94Ix9yIWGCo6DHPebANsCTnJ1HhS/rYe9xMMz+FTAk3GjQkklYIrhEM5MUX5iTtIyGwCBDAlLpCsaDwjDsU/eFCFqfiB2nZfOCikm6ZpdNoAFCHSlMbffbn32tiy98PlhYObq46PDtVqeGa+a6wUdBMz16qfSuUDppnd70ufHNEUyJ6rE3D+9wSSqE0qA9JMxD8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(66476007)(186003)(107886003)(6666004)(8936002)(110136005)(36756003)(426003)(86362001)(54906003)(83380400001)(2616005)(38100700001)(66946007)(5660300002)(478600001)(9746002)(66556008)(8676002)(4326008)(2906002)(26005)(316002)(9786002)(6636002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pNrj5QrilV7zkBUHZ1A9P7wbkDKTCRWjAil5Va7j+KS0LSDahN7JpPLJQ3Xm?=
 =?us-ascii?Q?yVJ2hFKNZi1nZ6dOQxzojjWcMwp6UCz3blJeCuk7ntpeCTGX/t/LKM9Kmv7g?=
 =?us-ascii?Q?Ji20R6OTPfmAqd4U/XQNo7gv3XoNnKIjEMBMMlV/a+9yT7s2+PAwZwUHTuSY?=
 =?us-ascii?Q?ighijS0qkXvww5bBKtrEFn5UJpb+H9L4HJu803UYus0aMTLP/TuDZCjmtQN7?=
 =?us-ascii?Q?RLhBmubV52AB17LUOcqxSGHS9SSbut5Z93oRatL2w6ffzF28JVWoxI4XVyzV?=
 =?us-ascii?Q?E0jvSKcqsznRUXUFvXmKdQhk6wcVd+zZI4SZjeNlkt+6h9zuGFyBEApyaTbi?=
 =?us-ascii?Q?3slfMPkekkkYXJANT5Km2fTpwgT8PcKl2cIqoN6SDozcQ18STdtzHlAlDQUA?=
 =?us-ascii?Q?ClX3ZMuKDeW3GdSu6VWsSSeF6y+6G+IkT9q5qmvhSKNMxaMfTdK2exxI9g2J?=
 =?us-ascii?Q?La4qACxRV+tSD5H42S2Ei0xrtGWBRhQ5pKT7lDKNXOjh9kWCxYJGc7i7/6sI?=
 =?us-ascii?Q?RZxqAFqsPYhLBM9DWtaXJrmmv7qi0rHl2vpsQEIB9WA2/tvOAiD/IP3IBmB/?=
 =?us-ascii?Q?bPFGZqGMxXBg7wJgDLPuWCf0LdNKE0hCwLiFevyOeV7HiyRvLywirjsP/31r?=
 =?us-ascii?Q?UoBWTl+KvLIHL/zbCqGMwMDSRshLg27r8CWGUHhMuDEbQbXf41bQigPFXrUk?=
 =?us-ascii?Q?7//jRR4Rdz4gytNg6N0i4N+Vhryq8xjIgkogmRZJyLgW5MulAZ8DiqxK9q99?=
 =?us-ascii?Q?J+CGGB5+FN1/s/P5RHefsEcn3a2+lAIEuZ05D8MU02GtUpy+yJoibNgmPx0B?=
 =?us-ascii?Q?h6cRUMKc/sD4RS0A1AX6IBquY8ic8me2sVEPVe/5fuUYRhgqggQAJvhIK0tp?=
 =?us-ascii?Q?2yPiASFAOz0b/u0XXvsjId4za9pO8gB2M4gOevmsAzkqshRnkQ7yXubeCIVP?=
 =?us-ascii?Q?602LSvGS/PgjmS8AStaCvQ6YnGxvi8mtNNMwdWWFCYBXkxMQ/NS9MKJoYzx9?=
 =?us-ascii?Q?vldS6Rumsj/TcP0nUMc9Nnvuaau8s068/MNd9ErPjzgFAKzCqHs1b86iVUze?=
 =?us-ascii?Q?y2lo4uem14ZoOHBwbEuupDSlhp4tzwafvHQSpmKS+yBC8tk2ChokH0CXw1NN?=
 =?us-ascii?Q?cw2r+Y2pumg/S5g+czf9ks1p4fr1q/z/BR+t+JrcmCYtTXRvYVJqEzPiPMKz?=
 =?us-ascii?Q?d8wp2exfUlYTa6+XspU08yBrivcdPpvjHw13luhlCOdx/faIBSG2jgldgt3y?=
 =?us-ascii?Q?Vmoi55n0e7pwQLYJ2Ze7G0zgeqmFuZUDIhy86X6LMLkL0f22uqJuByBWv1NJ?=
 =?us-ascii?Q?o7lm8MhiNkbiHuOZt+K7jYCO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 241cac25-3bfe-4334-5351-08d8ee24e035
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:55:42.2458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fo/pI1puB5VYVvbJyPAHgQ1qMuEkTDRi4c10XoO/oA32VYX4gZSPDYFnpzAPH+Ip
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4943
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This returns the index in the supported_type_groups array that is
associated with the mdev_type attached to the struct mdev_device or its
containing struct kobject.

Each mdev_device can be spawned from exactly one mdev_type, which in turn
originates from exactly one supported_type_group.

Drivers are using weird string calculations to try and get back to this
index, providing a direct access to the index removes a bunch of wonky
driver code.

mdev_type->group can be deleted as the group is obtained using the
type_group_id.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c    | 20 ++++++++++++++++++++
 drivers/vfio/mdev/mdev_private.h |  2 +-
 drivers/vfio/mdev/mdev_sysfs.c   | 15 +++++++++------
 include/linux/mdev.h             |  3 +++
 4 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 493df3da451339..3ba5e9464b4d20 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -33,6 +33,26 @@ struct device *mdev_parent_dev(struct mdev_device *mdev)
 }
 EXPORT_SYMBOL(mdev_parent_dev);
 
+/*
+ * Return the index in supported_type_groups that this mdev_device was created
+ * from.
+ */
+unsigned int mdev_get_type_group_id(struct mdev_device *mdev)
+{
+	return mdev->type->type_group_id;
+}
+EXPORT_SYMBOL(mdev_get_type_group_id);
+
+/*
+ * Used in mdev_type_attribute sysfs functions to return the index in the
+ * supported_type_groups that the sysfs is called from.
+ */
+unsigned int mtype_get_type_group_id(struct kobject *mtype_kobj)
+{
+	return container_of(mtype_kobj, struct mdev_type, kobj)->type_group_id;
+}
+EXPORT_SYMBOL(mtype_get_type_group_id);
+
 /* Should be called holding parent_list_lock */
 static struct mdev_parent *__find_parent_device(struct device *dev)
 {
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 10eccc35782c4d..a656cfe0346c33 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -29,7 +29,7 @@ struct mdev_type {
 	struct kobject *devices_kobj;
 	struct mdev_parent *parent;
 	struct list_head next;
-	struct attribute_group *group;
+	unsigned int type_group_id;
 };
 
 #define to_mdev_type_attr(_attr)	\
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index d43775bd0ba340..91ecccdc2f2ec6 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -92,9 +92,11 @@ static struct kobj_type mdev_type_ktype = {
 };
 
 static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
-						 struct attribute_group *group)
+						 unsigned int type_group_id)
 {
 	struct mdev_type *type;
+	struct attribute_group *group =
+		parent->ops->supported_type_groups[type_group_id];
 	int ret;
 
 	if (!group->name) {
@@ -110,6 +112,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 	type->parent = parent;
 	/* Pairs with the put in mdev_type_release() */
 	mdev_get_parent(parent);
+	type->type_group_id = type_group_id;
 
 	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
 				   "%s-%s", dev_driver_string(parent->dev),
@@ -135,8 +138,6 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 		ret = -ENOMEM;
 		goto attrs_failed;
 	}
-
-	type->group = group;
 	return type;
 
 attrs_failed:
@@ -151,8 +152,11 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 
 static void remove_mdev_supported_type(struct mdev_type *type)
 {
+	struct attribute_group *group =
+		type->parent->ops->supported_type_groups[type->type_group_id];
+
 	sysfs_remove_files(&type->kobj,
-			   (const struct attribute **)type->group->attrs);
+			   (const struct attribute **)group->attrs);
 	kobject_put(type->devices_kobj);
 	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
 	kobject_del(&type->kobj);
@@ -166,8 +170,7 @@ static int add_mdev_supported_type_groups(struct mdev_parent *parent)
 	for (i = 0; parent->ops->supported_type_groups[i]; i++) {
 		struct mdev_type *type;
 
-		type = add_mdev_supported_type(parent,
-					parent->ops->supported_type_groups[i]);
+		type = add_mdev_supported_type(parent, i);
 		if (IS_ERR(type)) {
 			struct mdev_type *ltype, *tmp;
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index fb582adda28a9b..41e91936522394 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -46,6 +46,9 @@ static inline struct device *mdev_get_iommu_device(struct mdev_device *mdev)
 	return mdev->iommu_device;
 }
 
+unsigned int mdev_get_type_group_id(struct mdev_device *mdev);
+unsigned int mtype_get_type_group_id(struct kobject *mtype_kobj);
+
 /**
  * struct mdev_parent_ops - Structure to be registered for each parent device to
  * register the device to mdev module.
-- 
2.31.0

