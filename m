Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FCB355C6C
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244951AbhDFTlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:41:11 -0400
Received: from mail-bn8nam11on2061.outbound.protection.outlook.com ([40.107.236.61]:28513
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244900AbhDFTlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:41:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEIdr4HjyjyCMjPQoMngwnNN1jeHh9Pn8Ri1Z/BllJ6ZUPiAKxPHEDjTn92x2yXjIlBMBHNI5STq1ipu8ujaXfRbB1OPsYGEMxyWqWEhhVIKOgYWqolF2MeHPJr7dAtmsrDNO4hV8YBrQU47ToanoTyHpAUMCybX0mhmSVkLdnhvmFbUufduTuxaT/fccd1JspmIeMo4MxL0aRR4vZ7aHeYIEUvmUqhMWl/vbQ6IpQKJP6SVzM/24NiA2bR2qYHw9Q4xr3Aul7reEYEth0sV6ZZwH+aYVimh8BUzv5M3C+MTRn/Ra+aEsKLHVm4VOORGdOM+j1x5MspQs+fv1Mfceg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFfOLtysUKX8PIQOEis5KrnOR9QGQJ2cl4hV2Lh8w2Q=;
 b=n8/T3OY/x68/voKw1rsNg5oK/ye5cGW8QEfTl4Ijw8GLKrerUeCWjtwZK3JP13fSdKkRliQgxh/JoUvU9MalK3RcX0nia2xCFJnn7YMoUDYa33MSC6rLjvLIKyVS8E6UqqWFIAAGmI1BSvfm4g0NGLwTK8bXCHElmtQy0AoH9YoFLwPhotcwM+f8s/lkMLeFJ3L5aEHkE2t1YI9RYARoCrMewoRRnXF2/wVOw+khqXILtZsdYKJIs8AMCGjoXhGu3q73TbD46eFlc1ZP/qODE35uyn8vEQqIBOmZF/PHhvZ1IA4mE4c8dF/A3VASYiggAyYxN7raW1l9nybLDcaZaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFfOLtysUKX8PIQOEis5KrnOR9QGQJ2cl4hV2Lh8w2Q=;
 b=CvnXXOlCg1AutoSxoi1YwoKjkktlu76imSApb5mE3NlUnWASCn3SxIgt1NNNrXIE+rTcrZN1zFaDCGNBdvO7tKGJ0jlF8Wim+isRDJxzxs+UPXHbQtpE2XobJqVhlaTFf0Fg6Y6j+171bIeZ5jMuPhnB2syHgCtYrCdBJ5x93D0V/rADQvIC+vmvRZECNMisNPghP6JrejBoE2nHYKFD3nywfJqZoBdWHWJcL12uic9e3S4Fyp/h8tDdcKtiiOg1nOSOH14u0e6AzXlFDeCYSF0WldErbmKifzDehYOqdWvW1/pZOGa/c1JZCXBLk05P9lnWGwfAnBxjambgFPiQ3w==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 19:40:51 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 19:40:51 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 11/18] vfio/mdev: Add mdev/mtype_get_type_group_id()
Date:   Tue,  6 Apr 2021 16:40:34 -0300
Message-Id: <11-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0296.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::31) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0296.namprd13.prod.outlook.com (2603:10b6:208:2bc::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Tue, 6 Apr 2021 19:40:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ4-001mXW-8g; Tue, 06 Apr 2021 16:40:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38d6b32b-ba1a-46fd-751b-08d8f933e00d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4235:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42352209899450CAED041B41C2769@DM6PR12MB4235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:146;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hltK18RrOPbergo0xSqnhNUDK2/hDO2Nq61DSS6cN2GgTS+FuPUzpLT8irGu4WeKRo78n0jGNmoTMb9EWmrCt/OSTOswYCM/08kYVWNjKG9F8+fTabe/2bABHW9obzOyOP3A/Pq7fcYhlhvVVhzbN7v8WE6lVAVWbhAMBhKXj5+P3saizh11NBY7oz1vZeVSDD5sS7SiVs0yoDXh2aKa/N6Uof9AImmJPWPLU5h3a4A/LR+qWcII4JwjYSscJoNph5AcTnMT/T4Q/UsHQyjiPtXHLLtJp/mQg21dmR2/tzKB2dB8HKNgO1J17CCGGQG7Be7Tmh2V0UocCpRHSIcKZIiRCh0wMptpepvfpMvBYbDY3D/mrQUG5Gh1NuGxhIHyGae3Z4UUkHgNUfOMaMt+O1UhowwpyQ6j1lVCsTj1TebB8yUAfENTm6YmSmgpHRs3/zZjxjKaCmy8ZL62QAGMiZnY53WtbIrWs4MKX69DlhfpSZVrGYBaUgOl5JS4nurGeWwoeQVotGxXQ6c4+BGMf1lLiJNIUm3Nq0XIAjFwxe9wQMh632C34yAZ0CrKUfeWrqlk5NnhOMJqcyOnoCHPLZGJW3A1OjIH1cVBgONwp3uzLReXDaJVeoCy6wT9HYbc4ipk0Veu8k2tIdyD9OiPBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(478600001)(54906003)(8676002)(2906002)(86362001)(66556008)(6636002)(83380400001)(6666004)(5660300002)(38100700001)(8936002)(2616005)(66476007)(316002)(426003)(110136005)(107886003)(36756003)(26005)(9786002)(9746002)(186003)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RWWpmTB6wZsXpqV3a2T0Yy+v1SyHu4drWyTCLKpGwO/OiMWl87/aIl5dzA4Y?=
 =?us-ascii?Q?cOPmVZXFXO8PqL6jLIsxNThiIlWwFbEFxrE1H8tSFCGX01x/ubHQ3RQw2ieC?=
 =?us-ascii?Q?hXvtbQuWR6wBaCdVvbDEDQ60Ujm6E6KolvRQFF7FV6dPVZGE3sc8rHZp4fsm?=
 =?us-ascii?Q?mNBJZQB3TXsebPRGYzMpYxvu6D5CuNsfTiPqprro+DgwBb4bCctfUgsWLw9a?=
 =?us-ascii?Q?KMO7SMt2kQh88kHNCuuiBGfhCO1Lx1YVHYIWK8rTeymrsyk5Z1ETX9iSbyrc?=
 =?us-ascii?Q?mX4ov/TkC9pj2xpH7rNUCIHldsP1evW3aSpR7A9RDjxR1sjpEoqm/R0lxaDz?=
 =?us-ascii?Q?OgCRDPtKBcGoEuy2GdUdk/xPMHb6+V+G/EHNZOSf72QarY5x+CxW0oYffwIi?=
 =?us-ascii?Q?qgLmuWPK6/z9P/2KvOVXLTGinlBwAtIjWDiP+kErgAWX1pAWziXaSVw85h/V?=
 =?us-ascii?Q?6r4yH7XgfQzjKOMpw/8zy+aoJNFkeUcO7dMn8kN8HgiUc37FIim5eDR2MqRp?=
 =?us-ascii?Q?gShWOwHMirVIeV/lsYH9sq/QdlXfDtg9bHcozkdgfaYetOm7oMWaTSfE0zFe?=
 =?us-ascii?Q?DideH23KbZmmaxPthTdydIhtxRDy+GYuWPG2G+HOKoF/Y1+01IDmRAmvyFIh?=
 =?us-ascii?Q?V5lBjnVTmlN6mgf21UKRf/sNzdVV5Q+Z2Ai8JiFK3ngHNmDOjbwqOpvgjcsF?=
 =?us-ascii?Q?kBFFhSPr8zd0U+Eo07kbk3HsoiWzpFC2brxr1cT2YOwOQxdiRAMBqnWx2WAo?=
 =?us-ascii?Q?RvIZe58ajpEimWqbnbcOLNt6R0dqz/ku3F93rRenccqN0yOsZg2giqrYM5bo?=
 =?us-ascii?Q?8TVXX+Tc8kgxGmewEAI12ziZUomJi0Aiy09bEfzEXMQ+fLK9UUu4YcmBdN5F?=
 =?us-ascii?Q?+gx6MR5IK3LjmBPKc/cU0cGzmWx+pDv4VYH1eZ8AZyfZDqX7EcU4Mgv1ZZvy?=
 =?us-ascii?Q?Pps8cLNR8LJvT5RmAMsjqKjyXHIRbMN3XkFnl2EPsv9N0gvDzBdNe8F5Nbpg?=
 =?us-ascii?Q?Lft6jqLVfVV6oJUg5MMMkAfqPtU2dyewUw1iSy6osLLLWhXYHPQoyzSlpHS0?=
 =?us-ascii?Q?c3xIa5fweiyEwJVf8X/+hY/GV/l7SMXDceIdhZvS2d1M2vm+jzsUrCfAoyDm?=
 =?us-ascii?Q?nEGltu2NKvh7EaKxunehN6W3IXVTIs8MFa+jRw7v5J9/dHIsA2fXPkqFa/ND?=
 =?us-ascii?Q?0XG4jjnfuuOLFOvz8PkVdUDXG7LZDMbhwezw6Sp5uW4sE29kWeCqNLiBd89P?=
 =?us-ascii?Q?boy2SJjVmh4+QQXJRqJ9lgrwRfnA9huR0jsSTrG8OiKkyMCBLMB7ZxZ+VoPo?=
 =?us-ascii?Q?/KLcle9l04EfXMn4t5aX7OeerZl120VM9qh18JryRMTLgQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38d6b32b-ba1a-46fd-751b-08d8f933e00d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:40:47.6808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gx25yH/JHNuR8PC+Sa4gORFKDNK2j0rnHpZcisujurHJFhxjhA/GdtNRytJ5WqQL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235
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

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c    | 20 ++++++++++++++++++++
 drivers/vfio/mdev/mdev_private.h |  2 +-
 drivers/vfio/mdev/mdev_sysfs.c   | 15 +++++++++------
 include/linux/mdev.h             |  3 +++
 4 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 2a20bdaf614214..5ae06f951a0998 100644
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
index 8c169d12ba7dbb..712fbc78b12e2d 100644
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
2.31.1

