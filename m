Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EF7509063
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 21:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381788AbiDTT0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 15:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381760AbiDTT0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 15:26:13 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CB045AED
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 12:23:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSKimlfPXeCWCTtYmx/mFTTda16kkMTSjh4gsd8TXokF1ZlSQj+GPlp4Uc7ABif64dd74wIKqAauzBrUIPxuj5nmBhW8QzAxVyjOrYBxXbRnBNr8re72S4tJGERoY9pP0b4jSPenYIn5IVAZkUfC7GLtIE5WzNDIN9IlQBn5crh6ccJINZ6l9rQCrt6zJ/1itokK3gl5qfSaFXKsoj5jO3v5dSl9BxHTH2RdYxl9SHRqB3deL3z6tJuKGGR60GkPqvuFKoq/rWI71yLcDQGrW/+WmsE5YrGPJ/8Ak6DBV+KqPyT3qz4bCicYj0ainuqdu3m6aNY9PqMQBX20t4QKow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sw0tlOPVjKyCw7QL852cDybyT7Whvv1AnaS7edjuJng=;
 b=UbF0ZGQ27Bv48snuXqA8Fxq1CSjBA3hNhWCZTFW42yIpN0bWobnvdifiqeSIWmWGbBhRAKxWslatycMiLMAjJ9z5Ih9sLSpbTwMEoPoEzPS21sIdpnJWgF1mDGASJmlLCp/Lsig89uYTsDGKSdTsN/s2pf8axBLRbJ//q5h9cJ+HDJwKvpobpdAhUKpnYNF+SPHfc5b/xjh0pUFKGfRKAEJrMV+HCjm8ElJi+cuYCm/6pXw0R5ev0o8vamBq7sSPyN4TS6XGZdyZllKMUYqGaoLARGh+TY8lyMYRIxEV3ymw8775Oz1jeG3TucmEA7FQQkAsAI1xMBSHASY0RrVVug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sw0tlOPVjKyCw7QL852cDybyT7Whvv1AnaS7edjuJng=;
 b=lnu99vC31d9sLOMzDTTsSzeLdZqiQlDQGcdtJUVPbyEtse0IOe4SfrKNv0JURXuZIuEljTqvpfa0Pc4njdgIys9lDQ0R+aOz4fKFXPqUp9OMagkLPrTD/qtKGQs9g3mb23yMacYgVEtPjqtAzR/c75FLcjXFb80M1hsWUHWLLr+SplgTAB7eill6DKEyZM3kzbmc39JG6+BnCxd76QNDXMTkYxdFttfPrrsnFFAp5W2sUV2EKK68zMFUciuBbTmaYcUd8h5dU9wkwJqTwHNwSeY4kyTt4XQL1JvUozw6RmcmsOVEzy+8MExhbI6ZXF10hm8FFuHBtUEM/yHPPgiCQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4131.namprd12.prod.outlook.com (2603:10b6:a03:212::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Wed, 20 Apr
 2022 19:23:22 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.014; Wed, 20 Apr 2022
 19:23:22 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2 3/8] vfio: Change vfio_external_user_iommu_id() to vfio_file_iommu_group()
Date:   Wed, 20 Apr 2022 16:23:12 -0300
Message-Id: <3-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0147.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aede5d1a-60ac-44f7-a96c-08da23033a25
X-MS-TrafficTypeDiagnostic: BY5PR12MB4131:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB41315AB8F40D515B3A2A14D1C2F59@BY5PR12MB4131.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wUhn8lrwQOAdLCOEztoXH1uh2dQxNv/rMaKC5DJI/TJuybz9bghmIEAyI7uZ6qDEQu90HgaiWF4t5BNm2yf/oYk7rgTn+nZ7ciKxEfjI+mQvyoPlakWpMy/96BeNddtkDfedHUjdcWNsSYbUM0ao0gVD8rtqDSh/YoRGXWBAQF3gYhsYJmx5NNsGWfu403S90Rvq/Rs8/Db4H7gbobqvQX8fNiLf8UmN6KWScsyStcb16xKUkisbTPU07YzXSx9Edf6qxIwQN1woZr2baX2fTd+6+iGVW4KpQf9ZD/7A3xZBZJwP9GJCzqCus/VU6VP/Zp4j4GFd1IUSEOMzmVZ9uESN8JxybbKPdq3pkdw2zc7E9wBAe7XsyTjxn+0Janh6clc7UVPsGW74T16IrZdtuX5q7JrjgjcCFJQ4mEBI/HOqHxbkj5cZhYj+KrCHqfwniEOZz77gPVLKU/jsBztLYEIclZm1+1a/+0hug1O4dBBxu/7EEmrFFjA4FfEiLJLNmHMT4y+a3wAIo3xudl3+F/LcELE6an9oEAfqAMyMRFHkV41584w01hkNHhn3PAd98qsya+ONsxTkHf8bU/dSfMGf2BP9Z9uXhaOEuor3UMgbnPqFC8P9XTr18TAQtjDBCX1HZj5GSTLk06PpVLecDmjZpn/LhcDZfgK9qKRuWNSFt+NUZzrL+v2FDXG2mRKc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(38100700002)(6512007)(36756003)(6506007)(66946007)(2616005)(186003)(6666004)(66476007)(8676002)(66556008)(8936002)(316002)(4326008)(5660300002)(86362001)(83380400001)(110136005)(54906003)(508600001)(6486002)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Gmf46IlB99YR6WyPJgP+1XqPRsrWqYNREouhEleaZ8wUZsJFEKKbPoEgOku?=
 =?us-ascii?Q?eRJ7TT+VP0iWkuHqr00LbNJAGfzEN6j/Aw/uW1IHNKxQ8nAo6/ByaZTlMPe6?=
 =?us-ascii?Q?7ymG4Ig/H4IhRHUgi9UH74Lm8bbKNCFahnVRj9n25X72A3lDKx+O/d1dF0OS?=
 =?us-ascii?Q?63728DDXLWSUiCKcblBGEIgOPZ2fjgbHKCJsmc1UhvRHZBePcS0ku+Xbn13t?=
 =?us-ascii?Q?Qf3lFG41/QO1o8AjMuZWzvZnGCkRl1CXY+a/mm7/cG/VR2q4OXvHk0GEtNQO?=
 =?us-ascii?Q?J0luwGZaJ0L8NDACt6GmhJEKmohBI6lIH3BSwzysOXIuFwPz0KZg/nHba8J9?=
 =?us-ascii?Q?gPwZTN999L4Fy5QPc07F2hu8g+WMbqOw0uU9Y4RvyuoY/LFsrrmU54kuDFYw?=
 =?us-ascii?Q?A5bJ2AEfLoYvhO3AaHLkdeVL//0sxCFCH1EwX4DCXOqfVBrD0RNc3a6XJOo8?=
 =?us-ascii?Q?4I7y/aGHRenqhepytR+aYPFz83OGuHg0deIQbBOiCEulJx06NIElgHp0vPGz?=
 =?us-ascii?Q?J0o5r8S0HitlvGAHpgXvABxxlDXxK5umRk1q6apRMBr4Igbf5f/h1cVvYKZ/?=
 =?us-ascii?Q?p7ILs5BG55h//UJ7/VoLhqJ0hC8jGCNp2kYeYGlT0S4Ah0pBqMoAIj1MESRk?=
 =?us-ascii?Q?SvgN7xJvG+l7QOQJov8DaLAQGFycrUYxO/DmJNEPGodmlhoZbjq/hpSoDnPU?=
 =?us-ascii?Q?XCkBy0fyD4qTgd/PnUSTdTsKAf6eQxRI2bY9/Fc28MSkKVvF3qeVcNDvTUGl?=
 =?us-ascii?Q?k2xMMovJYlaKVa4WCs8ZOzULzMjAruf8WgYb+2tqtx9bONX2ld3zfmf5I6au?=
 =?us-ascii?Q?TplZ3kkZpIlRBOn0ldnkB4HxekSBqtwzk8gr9/Lf60rBcB9KqdDpYsrfHgbp?=
 =?us-ascii?Q?r9sKe+o45KlPv8Qfuh7SQ3PGtS6aGeK02+QwweCcXp4vvU/bsRaW9kZdCk2g?=
 =?us-ascii?Q?IetMPL0yCmsb/DLCRq1hNIon9IPsLDrfzHNuioQwqOAkggzsKbsUlEGr3lVA?=
 =?us-ascii?Q?NgRf8Ayr2JDCzVT7vnOpJZ7r2tEQ+qrwzSjgYKwFTSajr+bsATqcOnaLRN86?=
 =?us-ascii?Q?ZcSub65woE6eKXcH/fIKQR1A66w3uKWl9T5OJDmm60Qs6BDxIfctdf33NIU9?=
 =?us-ascii?Q?+if20SIfQnbr+J6oL/ieLYVtqRYNeiI2Jr2+30QuKMVH/ntjKjA+SP1D5PKm?=
 =?us-ascii?Q?meJGGnXoyZ9FkhTxgL1Cfhu93785h/QrjIx993dVgTkoGK4n5EDzR/NNZOGr?=
 =?us-ascii?Q?x8RjaPsdI5eayB6hULlll+Ut8JPsnVfNnduQ8ODu3oX0XYPArxJJSqDxD2Ss?=
 =?us-ascii?Q?1m399RB70/ElKCTDY+nIfuK/IkXBI6c6+x884kfxze1zAoc7ooCNWnQl5HwD?=
 =?us-ascii?Q?ZfOEN3foYL1zaTluykhr2EyahV63zbnsgikQK6Q+RcCEzv0gf8ht6mco5Dlg?=
 =?us-ascii?Q?hNxO5HSuTMnnPO10kOyG0XfR4P2WJ6EAeEGvzOVqVy5u3BmRl/WMY7er6oCl?=
 =?us-ascii?Q?J4CdGsDWfK2LhqjTVIm1hSV23Kdv3VbIB5eBpHkDG/PKkYnjYcTwMCNNYnoJ?=
 =?us-ascii?Q?BVaC/PZfhrwXXuyqEDAA0boKnCusG40mK2XNjuau/PXKquumhQMM3uHnpkCq?=
 =?us-ascii?Q?EdMCG+gxbV54nujPuoSuxp5e+CeRvGLtbfJBwbAl3xd3oj7BuuQfPF/NK/g5?=
 =?us-ascii?Q?/EP5po2Srl2sFFzklHlqukDIfhE6jRg0+4O8LTmUeJh+yUS746qZOX9S2toU?=
 =?us-ascii?Q?l7gXrpcF1A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aede5d1a-60ac-44f7-a96c-08da23033a25
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 19:23:19.5173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /hQcjjBgL/rPB+GVjb2p3rmvUTwM+eaSZRqwLf6K/bFGNwfglGTpzZvsM/JoY9Qt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4131
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only user wants to get a pointer to the struct iommu_group associated
with the VFIO group file being used. Instead of returning the group ID
then searching sysfs for that string just directly return the iommu_group
pointer already held by the vfio_group struct.

It already has a safe lifetime due to the struct file kref, the vfio_group
and thus the iommu_group cannot be destroyed while the group file is open.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  | 21 ++++++++++++++-------
 include/linux/vfio.h |  2 +-
 virt/kvm/vfio.c      | 37 ++++++++++++-------------------------
 3 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index a4555014bd1e72..3444d36714e933 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1919,10 +1919,7 @@ static const struct file_operations vfio_device_fops = {
  * increments the container user counter to prevent
  * the VFIO group from disposal before KVM exits.
  *
- * 3. The external user calls vfio_external_user_iommu_id()
- * to know an IOMMU ID.
- *
- * 4. When the external KVM finishes, it calls
+ * 3. When the external KVM finishes, it calls
  * vfio_group_put_external_user() to release the VFIO group.
  * This call decrements the container user counter.
  */
@@ -2001,11 +1998,21 @@ bool vfio_external_group_match_file(struct vfio_group *test_group,
 }
 EXPORT_SYMBOL_GPL(vfio_external_group_match_file);
 
-int vfio_external_user_iommu_id(struct vfio_group *group)
+/**
+ * vfio_file_iommu_group - Return the struct iommu_group for the vfio group file
+ * @file: VFIO group file
+ *
+ * The returned iommu_group is valid as long as a ref is held on the file.
+ */
+struct iommu_group *vfio_file_iommu_group(struct file *file)
 {
-	return iommu_group_id(group->iommu_group);
+	struct vfio_group *group = file->private_data;
+
+	if (file->f_op != &vfio_group_fops)
+		return NULL;
+	return group->iommu_group;
 }
-EXPORT_SYMBOL_GPL(vfio_external_user_iommu_id);
+EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
 
 long vfio_external_check_extension(struct vfio_group *group, unsigned long arg)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 66dda06ec42d1b..8b53fd9920d24a 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -144,7 +144,7 @@ extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
 								*dev);
 extern bool vfio_external_group_match_file(struct vfio_group *group,
 					   struct file *filep);
-extern int vfio_external_user_iommu_id(struct vfio_group *group);
+extern struct iommu_group *vfio_file_iommu_group(struct file *file);
 extern long vfio_external_check_extension(struct vfio_group *group,
 					  unsigned long arg);
 
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 07ee54a62b560d..1655d3aebd16b4 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -108,43 +108,31 @@ static bool kvm_vfio_group_is_coherent(struct vfio_group *vfio_group)
 }
 
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-static int kvm_vfio_external_user_iommu_id(struct vfio_group *vfio_group)
+static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 {
-	int (*fn)(struct vfio_group *);
-	int ret = -EINVAL;
+	struct iommu_group *(*fn)(struct file *file);
+	struct iommu_group *ret;
 
-	fn = symbol_get(vfio_external_user_iommu_id);
+	fn = symbol_get(vfio_file_iommu_group);
 	if (!fn)
-		return ret;
+		return NULL;
 
-	ret = fn(vfio_group);
+	ret = fn(file);
 
-	symbol_put(vfio_external_user_iommu_id);
+	symbol_put(vfio_file_iommu_group);
 
 	return ret;
 }
 
-static struct iommu_group *kvm_vfio_group_get_iommu_group(
-		struct vfio_group *group)
-{
-	int group_id = kvm_vfio_external_user_iommu_id(group);
-
-	if (group_id < 0)
-		return NULL;
-
-	return iommu_group_get_by_id(group_id);
-}
-
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
-		struct vfio_group *vfio_group)
+					     struct kvm_vfio_group *kvg)
 {
-	struct iommu_group *grp = kvm_vfio_group_get_iommu_group(vfio_group);
+	struct iommu_group *grp = kvm_vfio_file_iommu_group(kvg->file);
 
 	if (WARN_ON_ONCE(!grp))
 		return;
 
 	kvm_spapr_tce_release_iommu_group(kvm, grp);
-	iommu_group_put(grp);
 }
 #endif
 
@@ -258,7 +246,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 		list_del(&kvg->node);
 		kvm_arch_end_assignment(dev->kvm);
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
+		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 #endif
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
@@ -304,7 +292,7 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 		if (kvg->file != f.file)
 			continue;
 
-		grp = kvm_vfio_group_get_iommu_group(kvg->vfio_group);
+		grp = kvm_vfio_file_iommu_group(kvg->file);
 		if (WARN_ON_ONCE(!grp)) {
 			ret = -EIO;
 			goto err_fdput;
@@ -312,7 +300,6 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 
 		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
 						       grp);
-		iommu_group_put(grp);
 		break;
 	}
 
@@ -386,7 +373,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 
 	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
+		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 #endif
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
-- 
2.36.0

