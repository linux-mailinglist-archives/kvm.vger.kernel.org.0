Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F6A501B3E
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 20:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344758AbiDNSsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 14:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243792AbiDNSsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 14:48:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F037DDBD19
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:46:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hL8vN1IVVx2I/iMwr5Mjfk83OuRQsQRHFCJM2wUVa5kjnvgxazEx637dbJt2npAgGyuUduaSYpYt+YT0lORIl1Fb3V8yiRkxgc8Dab14UhF15w8oeiFIdprGGRFwmRi0h6FJCmIAm+JHWdBCG+DWf2X0D0HAtNbqfaZPUCUYi92h+SoHWYqac0mmbBUONry4B7aCffNkS0Saijm7JghbFJTghivn0dmdLeSrrA4BPn45igBFaGt316lnDcgMEOVlwTZP2m4ZjYNbnFlYjGxEiVfRrmY27dGGNMFaqOgYd0IJFGdfPZB+O7mjvnxKH2Jz65o2zfbr0aR77m/qWhFgPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wD3PR8nXG8xboi9+HtgVwnkCapHVD1Z+eBp6VEY7N8Y=;
 b=ZeH/b1VJm7JGwVfMUvIhoSJ2PXMT/o5kmHjIGYTBxYmoaJiXJzj+Xi9cAME3h6EHnVgZeIYqIsR0HpVE/ZtgUyeFCiwtytV6xH1UrtqByyK9qLVSPF6dpOWKmYlf9GonPxuvA9GxjSR4DsqpCeE7upO916uOBWZeBL30LxSURNjo1O55gp/P2R5HqcQEd1fbdpDre1GONNZCmMkt4pqxPuUvP0DDkmFImcAOQ9vOrJ1m/+PuVULqsg/sEs2L4JsfktCgJxyOczMu3LrhO4W44TDyd+gaQH0tD+MrvuQcRw9+Dj/A/y/FTmUa9lpQSOLceU1KG5tej8LHorBb0qGvNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wD3PR8nXG8xboi9+HtgVwnkCapHVD1Z+eBp6VEY7N8Y=;
 b=iLL0XdofCncukcO4OimxIhDmVtfz5fP6KIdgp/NH4zxvLl5zjJFlWMPdpoxyghRbmAP69zCpAor4o/drzCeFh0OhKlGT1EbC3qZeMaR+hFY5rQGqNu5MFx0yDN5ykRJUBpXhQuFxcUDyjVlMqGQGvwOBUnOaSjTr9dmPQ8TI1Vr4E9lpn8zm4f4pkWyhwM1Wyqk7IaaFWDDQCjnBgRBnIPP6VRAiSFHw3v38wWOYbeelYCoibdT+KVeOYeBogCE4x0TE6/44Yk1rHoy+55hLRrz2jItoYb93HsrIPOnFFeiYn/JNpUU9IyqFrtBbUCj4Albb36yane21oq/lK6Tq4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5350.namprd12.prod.outlook.com (2603:10b6:208:31d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 18:46:12 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 18:46:12 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH 05/10] vfio: Move vfio_external_user_iommu_id() to vfio_file_ops
Date:   Thu, 14 Apr 2022 15:46:04 -0300
Message-Id: <5-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:207:3d::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9018770-4872-45d5-433d-08da1e470ba1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5350:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB535031C7AA66F35D26FF68D4C2EF9@BL1PR12MB5350.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cAx5X8qz8VzGo6B6LA62+0bpAqsBBe425auHYdoZqYqIUykm8KPNoaoyLfVYzlrnWJRSFAWiy1YYTHb5UUY+2W4G6vCUiWIbkhs+QwZr2n5+aupfDiI99fZDn9iXe+kI9Q68ugtWst/thf+hoQ0RipfPm7TxNr1Pw2aJ47Vzwq+LuS3d+4eFGuNFYujFtGoaZFZq5NewkoRNFEO28+fpj3vZ7p1fvse+s21xixVK5g1sHH0c1ACdr8qLU+flsGhpvzNZTJrmK0TPX/gC0pKK31nwFIlkbpaeXeT+raPB7w6q2qfztiz6bFo9wt3Z2mH9MNhhc1QjCXseQGtbFS9ccNCFF5uzbzHLoD85Jw/aOTmYI1/xKhtSzRjRGoVaTIbIk+rbRRQX5or2+LOpl/b/4y+tc+gX9wMQewu0UJOFM1Sr96pkan8mZ3rgcK83YVFUx3EGrTKEmlUPjXBVwkqmwoLtsGC6dpmv3c9DrRgKVHbwKTAygBOV0vlFmU8wWHqZoZ77uJkhfUSln5xB7UmlFKiMe7p3Os2P8eiV5ePhh86DJIc/P9QtPsmyXNMOfafxAW8coJ6faL/DpKmgzIeSCABk+UteUtDdafi3md1BzmUt8VjIPubnyy7GhDPRxkvYLUJvlXIflXIduFTwYmdUBLsPaAXXkisCytaQNjP0le2sztbYOzrFYhZkViRBe8Sk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(186003)(38100700002)(83380400001)(110136005)(66946007)(66476007)(66556008)(8936002)(4326008)(8676002)(316002)(5660300002)(54906003)(26005)(6506007)(6512007)(6666004)(36756003)(2906002)(508600001)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bByDAfBRB/wQOLVLHtwSqzyuT+A/ltSIDENZFyi2Fj8mB/8dJYOXQ+CFDwHq?=
 =?us-ascii?Q?8AHt+NXPg46A3/Hoqq5OWcm45vZ7TkdUSVKzneOhCugjn063c6NxCXQGdcfY?=
 =?us-ascii?Q?V/7I1Fb3lrce//kxzPtHNwZMdSU2tsMHRBMixLX5fUqAfgt43oia2JyFEb5R?=
 =?us-ascii?Q?/+DvjbkW5xUla1D+i82XpEJhksoK+5V9ZFSp/HOOYTpZMRX4SgTfNjVgmx6T?=
 =?us-ascii?Q?BcjqEo3pz6zwTo17HyKQajSfepbZQxo9ghVA6BZJHF4Wsz8d/bU1mr8M0T/k?=
 =?us-ascii?Q?YJ2XdDPhpgcFXmQPvBvZKnWOR+0eV3pukJCDHxtZpqHmuBw5DiyFB8p/IckZ?=
 =?us-ascii?Q?p57jtU3dy9VjKHcI4bRv1gsNDl1vAQ1gp5KVNtKo/UXWHm1d6xeyUgOHiTBT?=
 =?us-ascii?Q?6/fuXHlgKCCOSbT3Pah7Y0g50kciA+YEvFJ1xfX6gG3uNsvAiKb3YWVGgk/p?=
 =?us-ascii?Q?oLM5owk1HBEq8CLEMRwun2CrMExT1bQsC1u6z3T8mbQdfB982OTn+BLZZ1MS?=
 =?us-ascii?Q?f3/UWguCzjQtr6zE4wwqZqCcChFvoGuebGAjmIvml14Bks/nphCA66rYa/LS?=
 =?us-ascii?Q?vUsC923N53QkrGApsySoh7an+JTrqc87+vwdRp5u2a+tLBHp/kY7hEm07tI9?=
 =?us-ascii?Q?LnjZH34WURf7zf9iWhmGG80sN7oYMdWpVTd1T+L2C0nmCVso+AN00l7fxZgg?=
 =?us-ascii?Q?QTyGiJ2NfpghgmVqHGLmb0gkM8F69byqEY2TwBtW4FsRsAmxPHopZZx3+KBl?=
 =?us-ascii?Q?i3rHNmU9wSLg6U+B3THD864Dd16ym2GlJLmBLt3HW7u5o8e6iDU8gutC3Cnw?=
 =?us-ascii?Q?9JyA5En45Pb+YQZ5COusHy0UMBe7zBFsgJ8CAna+QFN6+EhY1U7V6/sJadfB?=
 =?us-ascii?Q?w4FXAiis+FpeOGJa83apkVzzZrM/DfngZPOUc3JhUxltRWnLd+nEsT6xOXIw?=
 =?us-ascii?Q?iZ+HVD3Hy7kmXk2VTNooin9QGXmAkqSiRT5T39eXpC9ifyhYHWMUQzZt8SRj?=
 =?us-ascii?Q?d2gYFRLbZUuGMQeAOmyuxGYZ1UhAo8WOJGdGe6ZdGem2zSStoHwAZr1uyTQ4?=
 =?us-ascii?Q?R5ikF3k7zIZ3aacltTJGWzAwleoDOO9ftbpIGQq4MjFTnPnxAyWtRJqzB6GW?=
 =?us-ascii?Q?fCAD8ulTk9Ez0mXwX4Gt6u+6xclFHaOcg4+oNrJL9gqcpvcogYJYmL2nl6TU?=
 =?us-ascii?Q?TOzhAt7Ldv6xf4BYtDHCaublarVoWTN1wGrKhN0Q+Zui4mp6LHDsZclSandp?=
 =?us-ascii?Q?iqG2MIkJTOA4mEG9F+HvM2HLp/mkqc5xU2IqXm/NqZ+Pcr6nFm8R0+V4jcjt?=
 =?us-ascii?Q?LwjCBkQpNqY8EnyFsxX1IN0w6MElZ5VEbjSgg6eN4E0vZlBbzwip5S07wEMK?=
 =?us-ascii?Q?1VNLpJ25GfrZ71HS2h6YLVDv90aTwpEYr5WCjVKpJCsLdMBiXHdG4zFoAIJJ?=
 =?us-ascii?Q?Zc9NyM91DyIbIhsr83aW7f4xSaIqdfKm3mVSFbKTo7h2SNWRazDfFDQQE6iD?=
 =?us-ascii?Q?iyeJxnNsPBrgOh4KOMHQFY0Fi12nGVggf2QVhgrMjU94/yiFJJmF9dz7tXmm?=
 =?us-ascii?Q?RE5H/L36rUWlyfZH++YgLpsw9fRSJLDPDzzi1CW170c3yffY801liel6Fc0s?=
 =?us-ascii?Q?xcQwuiEupHuOO0WGIKoYRryYrKCNge7c1wPfGclPgY6wVLkzc0ynHtxYqSoN?=
 =?us-ascii?Q?P/cCgk7pd2p0G9ptCvqvmU+O9EghOu/jY/G0EiXURMRsD6T3qcpULPNhIPK5?=
 =?us-ascii?Q?mxuL4h5NXg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9018770-4872-45d5-433d-08da1e470ba1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 18:46:11.5787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qSjkzDpmMzWBehOV6Ok/n3JtuVi5luAHvpgLFJndTCovdpGa8HFaRXF5Z/2TLHW0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5350
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only user wants to get a pointer to the struct iommu_group associated
with the VFIO file being used. Instead of returning the group ID then
searching sysfs for that string just directly return the iommu_group
pointer already held by the vfio_group struct.

It already has a safe lifetime due to the struct file kref.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  | 20 ++++++++-----
 include/linux/vfio.h |  2 +-
 virt/kvm/vfio.c      | 68 ++++++--------------------------------------
 3 files changed, 22 insertions(+), 68 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 93508f6a8beda5..4d62de69705573 100644
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
@@ -2001,11 +1998,19 @@ bool vfio_external_group_match_file(struct vfio_group *test_group,
 }
 EXPORT_SYMBOL_GPL(vfio_external_group_match_file);
 
-int vfio_external_user_iommu_id(struct vfio_group *group)
+/**
+ * vfio_file_iommu_group - Return the struct iommu_group for the vfio file
+ * @filep: VFIO file
+ *
+ * The returned iommu_group is valid as long as a ref is held on the filep.
+ * VFIO files always have an iommu_group, so this cannot fail.
+ */
+static struct iommu_group *vfio_file_iommu_group(struct file *filep)
 {
-	return iommu_group_id(group->iommu_group);
+	struct vfio_group *group = filep->private_data;
+
+	return group->iommu_group;
 }
-EXPORT_SYMBOL_GPL(vfio_external_user_iommu_id);
 
 long vfio_external_check_extension(struct vfio_group *group, unsigned long arg)
 {
@@ -2014,6 +2019,7 @@ long vfio_external_check_extension(struct vfio_group *group, unsigned long arg)
 EXPORT_SYMBOL_GPL(vfio_external_check_extension);
 
 static const struct vfio_file_ops vfio_file_group_ops = {
+	.get_iommu_group = vfio_file_iommu_group,
 };
 
 /**
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 409bbf817206cc..e5ca7d5a0f1584 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -139,6 +139,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
  * External user API
  */
 struct vfio_file_ops {
+	struct iommu_group *(*get_iommu_group)(struct file *filep);
 };
 extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
@@ -146,7 +147,6 @@ extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
 								*dev);
 extern bool vfio_external_group_match_file(struct vfio_group *group,
 					   struct file *filep);
-extern int vfio_external_user_iommu_id(struct vfio_group *group);
 extern long vfio_external_check_extension(struct vfio_group *group,
 					  unsigned long arg);
 const struct vfio_file_ops *vfio_file_get_ops(struct file *filep);
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 254d8c18378163..743e4870fa1825 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -118,47 +118,14 @@ static bool kvm_vfio_group_is_coherent(struct vfio_group *vfio_group)
 	return ret > 0;
 }
 
-static int kvm_vfio_external_user_iommu_id(struct vfio_group *vfio_group)
-{
-	int (*fn)(struct vfio_group *);
-	int ret = -EINVAL;
-
-	fn = symbol_get(vfio_external_user_iommu_id);
-	if (!fn)
-		return ret;
-
-	ret = fn(vfio_group);
-
-	symbol_put(vfio_external_user_iommu_id);
-
-	return ret;
-}
-
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
-	struct iommu_group *grp;
-
 	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
 		return;
 
-	grp = kvm_vfio_group_get_iommu_group(vfio_group);
-	if (WARN_ON_ONCE(!grp))
-		return;
-
-	kvm_spapr_tce_release_iommu_group(kvm, grp);
-	iommu_group_put(grp);
+	kvm_spapr_tce_release_iommu_group(kvm,
+					  kvg->ops->get_iommu_group(kvg->filp));
 }
 
 /*
@@ -283,7 +250,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 
 		list_del(&kvg->node);
 		kvm_arch_end_assignment(dev->kvm);
-		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
+		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->filp);
@@ -306,10 +273,8 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 {
 	struct kvm_vfio_spapr_tce param;
 	struct kvm_vfio *kv = dev->private;
-	struct vfio_group *vfio_group;
 	struct kvm_vfio_group *kvg;
 	struct fd f;
-	struct iommu_group *grp;
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
@@ -322,18 +287,6 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 	if (!f.file)
 		return -EBADF;
 
-	vfio_group = kvm_vfio_group_get_external_user(f.file);
-	if (IS_ERR(vfio_group)) {
-		ret = PTR_ERR(vfio_group);
-		goto err_fdput;
-	}
-
-	grp = kvm_vfio_group_get_iommu_group(vfio_group);
-	if (WARN_ON_ONCE(!grp)) {
-		ret = -EIO;
-		goto err_put_external;
-	}
-
 	ret = -ENOENT;
 
 	mutex_lock(&kv->lock);
@@ -341,18 +294,13 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 	list_for_each_entry(kvg, &kv->group_list, node) {
 		if (kvg->filp != f.file)
 			continue;
-
-		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
-						       grp);
+		ret = kvm_spapr_tce_attach_iommu_group(
+			dev->kvm, param.tablefd,
+			kvg->ops->get_iommu_group(kvg->filp));
 		break;
 	}
 
 	mutex_unlock(&kv->lock);
-
-	iommu_group_put(grp);
-err_put_external:
-	kvm_vfio_group_put_external_user(vfio_group);
-err_fdput:
 	fdput(f);
 	return ret;
 }
@@ -418,7 +366,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 	struct kvm_vfio_group *kvg, *tmp;
 
 	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
-		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
+		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->filp);
-- 
2.35.1

