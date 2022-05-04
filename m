Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1D351AD9E
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377495AbiEDTSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245642AbiEDTSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:18:31 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46162488A9
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:14:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z3lGDnZqMYP56Sy0EHV0Box14nMbMcUuqZ8Fu5FNDMHEOwQrr6JsAmbVpJeC9nEI4XKtUyZl9yw9Hkg/bQXkqbYLyMgnmhn3j8vvWcimT/k5e/pGvpy5uGTFEAF9WabqktB+uTSSBG0KdvjCfqlthT8OsV33lxE20rBO63k2yUsuC8/0RgX5KZ+RvVef3dwdwetRCa6vn7v8i9Y9XwhFq+xyKl/RpLtiFgxAWIXGXm9jorEg6Z8FQgCY9MVNRK2QdmNgqgSh1ltmCAM7TKke6ILZjeWD6KxDQ7mMqhrb96Q2XUMac1ly9wqNDojZjhXkJ5X50o+XKKOg7f6j7zbuLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9MHnATk8UoNVduil0ALDtnxykYFMHe5yQvdvGoUnU8=;
 b=eJJeFBupH7ZaocqcSp0pRt52i8IZEPNA3++j51mRRi2dzzrTBlUNFqJNG9YKVD+umlibHq47HFIkb6wpsH6MXWT3JvWyZmVw/5/gunyP0zsPTpOe+4AWbie6PEPuTehmAsh2x78tCoWa4W98q928HyKONkfF5GVOYTwf6Ty0U1HVhGTfa+0ParRpw4tEzMFEgtRJCeZjcjkjO3lnhW81m8vCIzVNGF4XYd38ABMe2u+k9z0uYRrRqSR2g3Wapm19kNXzzVUuL6higlCRP7BT4/2EFTjyMTnptVGYX/qOjKwHJs63EVE6rL5NaC502SgLAhDbdiXuGEAqJeIvw9LwOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9MHnATk8UoNVduil0ALDtnxykYFMHe5yQvdvGoUnU8=;
 b=ljC9dpxe4UjCuPx4ekbEu3xyBFFZV8wVapaUFyYEiRv6G25DZcGBqnEfEGdUtrJg254IWfLdjmQuhtBMoAU+Yhsws7ZGO3FhZZ2PY0RqSeMoBHSAzXOIkpPCZ4IcVAXukwMeCR3dkig7hf81siFOVejX0vsiYD9ccGPpNzSkS+R//WJMywbCoruXZPQ+NkifVtlu2ZU/RcL87RGELxBB1asY13wtqBEjDhgqJ/k8804fxOAx9EhchFO5/32Ay6DtS7RFlx8V0QyQ2agZ0PsM6GNUgoGWwNPzAfBb7mjy+WGRZxVcq4Q6TY3FhMNuy28i0iyHGRVmjpG4XP53HL9PfQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1419.namprd12.prod.outlook.com (2603:10b6:3:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 19:14:49 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 19:14:49 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v3 7/8] kvm/vfio: Remove vfio_group from kvm
Date:   Wed,  4 May 2022 16:14:45 -0300
Message-Id: <7-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0234.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ba3684e-4043-4063-02d9-08da2e025b20
X-MS-TrafficTypeDiagnostic: DM5PR12MB1419:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1419383981962F555AA4BDA8C2C39@DM5PR12MB1419.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OmVRGAD+IlkgrvVEjSM7+MgqqiAyVZ/oHO2AbcOmwlKtRJLs8TO28icdQ4LsoSdYl5LTvY7c/dr3XgrFDSrZo+YN2gF0D+e+KrHj4eFBgNEJknOCFUDT70H90nNoHBZWTp3vQD5hImb0k9K0yf92I7f6xWknamdzsztu8p1t+6sfb8PWnMJDdwr7CzjF7LmxphmtuaFfE0q8ca3goxRRQe+Fv6jI5SfZI9WSMplz99glw7lelemC2cZKew12yarRi7uGmPbe1l7Gdjqz2nwMmkhkijVW25tTy/79Jwl5HSNh44h2xCqPsCs1jAIli0V58uKP4vRKe/A+NpjAcBfwmoYnjais+ZIP5j6JOJxQ90wxWxVKGDLS+p+0fw0IE5EU2IP34w/Dntiz+FKapjoZ56V/+KTlf03XljOyrys0xq1ada/p5ppjpaxID/jSrCJYMCzQK4CQqHkVvJ3CRvSHKl5x7hdFMYLRa7otVk+pQ2FyzwCF+BWUBea3B86ntsjZxmUAOAYJjW9wTC8mObTjtD/B7/YL/mGAnofAHgawnvEs07i0qF46VHNa9v87F+cc0aZYoF6oz+VSnUlR7bgkjRaTcOoG9OwD8OVa9BAI5TR2BcZuxuLrSUK1Ess50YOACkf+X9mJ6fvQfIGuZ9aBc/ZC/Zi5XPDVBJG1FCMvOrce8Rlq+PSZQSF9gpqHiKYWi0a+4BCxyELDaaETX27YmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(8676002)(4326008)(66556008)(66476007)(66946007)(8936002)(110136005)(54906003)(5660300002)(6512007)(86362001)(508600001)(316002)(2906002)(2616005)(6486002)(83380400001)(36756003)(6666004)(186003)(26005)(6506007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?obgjK6qcWHDOnXQ2c2h5nlU/T4phH3VUtO122N8xFfqUGe33xVWDkMxL2uFD?=
 =?us-ascii?Q?eLN4L4Jb008EwiL05hbqvT1TKkF+8bDoIC71ktHfNQT/zoc+9eLNHsbpjqJg?=
 =?us-ascii?Q?pAK5cpGiKxP0nVYPa+Mcyn2yce6oz6kJ3OvUmC6EHjZh5mprP/dt5vzDAgew?=
 =?us-ascii?Q?LhyqTNwmOVnf1mJQjuRsTXqCWerfOwrtG7w1EFrPZHTZRLWlYERADHXAh4kv?=
 =?us-ascii?Q?0NPIrQbCVprKSRB9gqY/1T0jDxs3CAqQwilk64so72ZUDSdCY76eXGrnw+h/?=
 =?us-ascii?Q?M+fJ73914gc9hOwOcjI3EYQZsQylDbdY4Mz2W32icW1rhLwO2b1i1P8dA4UH?=
 =?us-ascii?Q?i1MULGAoyT8VaPcyuAoui6apweZQwBlPr+tRpNLVLzEkvDg4nORdiKN0mgyA?=
 =?us-ascii?Q?VGWmKsYN82gqDEvR+NUkle+32xy08dg6UX4rg2kQcUiUarYcoj02nXMLpmlg?=
 =?us-ascii?Q?sJ6eAQL2nT0edmOHGI+5yXsfYRfP7dizl8VfcztzFPbe8BAEZLKwZ+3NJm+Z?=
 =?us-ascii?Q?5f8AdJPUgM6JtWWxwm+GXdmxrn8LTpIZPW8m7qCtoq60Gi7SlcchyHOp420c?=
 =?us-ascii?Q?7MDj28WMvk2/0/oM+aLWc57rad//OUo8h+dLbbvzU0A7wU0+cfi3jCzLMpJC?=
 =?us-ascii?Q?hZ/rGCZhDYS/eThwgqluCiFFqMHmkOJCTYgCIz+0fptvgmEzy3HoJrSiOzo3?=
 =?us-ascii?Q?2kDKaG7RVkuUxlsowlPr+T7D7VKzrH6MkqkNxa9QxMSFHCVM10pYDqDVzpG0?=
 =?us-ascii?Q?vZMNLb/zpuKLIKahlYGjGKX0XIRcP3DU/lxRYEq/09EyioXYHILLRRihrxtR?=
 =?us-ascii?Q?5Vuh3KuP6lo3PMG3uhStziTlzMqAFxqfPZdErPRQd/SS6I5ldZXZ5MmWGTYQ?=
 =?us-ascii?Q?YSWP2UcrYvo45XxpWMLq3mY+pITiQCd8YX/z085RvCKo8S1cHjqpSVndQXb+?=
 =?us-ascii?Q?ILmMx2CTQd4mckzi0e+WQYyMdO3Z5z9KczLHLU98rnKKDjDNA4U1VbGU5hBQ?=
 =?us-ascii?Q?40rLN0Y77P4Ra9xrRyf5vhrvtxbCieD6QsooEeU4B8Sbnbh+AyfBceDIenD2?=
 =?us-ascii?Q?9LXS1WWK1ua8NEgVBT72s0p8eKizRSyMZHHAUFP/gkr7IoLmtkdUqiXSkKZe?=
 =?us-ascii?Q?t8pJqemjfu+iBLfgIjTw4p1htKHgcD5gxKR/25ZE0JaQmBcnN/RyBLZhrCLf?=
 =?us-ascii?Q?t4p01L+be3S8mMg5DQtYU+7C9gNo65hMLcOuK3Nctxzy1m9urLuWwDcJX7Jo?=
 =?us-ascii?Q?AyVlLE+AWhpEBESfKFYH8EuXEzQlvq+9HMX8djHRsdLgPg+8k07eotKa5JvT?=
 =?us-ascii?Q?sWBLWiQyYAetZhvXh3od7IkseJllB89xFe2W8IaEB+pCwLdJlrESKTQjxBaG?=
 =?us-ascii?Q?OUoklXa/H4itPWlqasLrnJFMcZ6HRJT0IEDEoj6ANkJQHMlwmIGHL7U08/U+?=
 =?us-ascii?Q?Y4oGnVC0V+kETWWatMSt8rwvSadaYgmKvKV+vTdjF/rzFMEP8PfbuJllLtP1?=
 =?us-ascii?Q?kSXsipdEOkK8HHosrIOk5r5uolNsocUzwe82ywe3Z8wH3NM20pH0hhFFf/kl?=
 =?us-ascii?Q?YlG2pyNSbe86N449SsFKohXFxH+1TFRExAIjv4+BBp1TEKJexYQROwXLw/dI?=
 =?us-ascii?Q?HfnCBbwecEgQEDLsxkFUEgvjnTxoIMx3WzYW1qMiMyptAaxnQyNOkkUi4Y9U?=
 =?us-ascii?Q?MSwBJ4Fr3qru1gXKYEMBcMppstMjPeqj1XMBLJG2V0DVyuNkTDOvYr4QI4Iy?=
 =?us-ascii?Q?tRvhE/24Vg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba3684e-4043-4063-02d9-08da2e025b20
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 19:14:48.1076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3X6sUSNxCUXCFGQ/YVx9Or8GinvzwBU2MjqlxwQwPIqLdvIQH5ycla7RxQKKmV9i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1419
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

None of the VFIO APIs take in the vfio_group anymore, so we can remove it
completely.

This has a subtle side effect on the enforced coherency tracking. The
vfio_group_get_external_user() was holding on to the container_users which
would prevent the iommu_domain and thus the enforced coherency value from
changing while the group is registered with kvm.

It changes the security proof slightly into 'user must hold a group FD
that has a device that cannot enforce DMA coherence'. As opening the group
FD, not attaching the container, is the privileged operation this doesn't
change the security properties much.

On the flip side it paves the way to changing the iommu_domain/container
attached to a group at runtime which is something that will be required to
support nested translation.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>i
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 virt/kvm/vfio.c | 51 ++++++++-----------------------------------------
 1 file changed, 8 insertions(+), 43 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index b4e1bc22b7c5c7..8f9f7fffb96a1f 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -24,7 +24,6 @@
 struct kvm_vfio_group {
 	struct list_head node;
 	struct file *file;
-	struct vfio_group *vfio_group;
 };
 
 struct kvm_vfio {
@@ -33,35 +32,6 @@ struct kvm_vfio {
 	bool noncoherent;
 };
 
-static struct vfio_group *kvm_vfio_group_get_external_user(struct file *filep)
-{
-	struct vfio_group *vfio_group;
-	struct vfio_group *(*fn)(struct file *);
-
-	fn = symbol_get(vfio_group_get_external_user);
-	if (!fn)
-		return ERR_PTR(-EINVAL);
-
-	vfio_group = fn(filep);
-
-	symbol_put(vfio_group_get_external_user);
-
-	return vfio_group;
-}
-
-static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
-{
-	void (*fn)(struct vfio_group *);
-
-	fn = symbol_get(vfio_group_put_external_user);
-	if (!fn)
-		return;
-
-	fn(vfio_group);
-
-	symbol_put(vfio_group_put_external_user);
-}
-
 static void kvm_vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 {
 	void (*fn)(struct file *file, struct kvm *kvm);
@@ -91,7 +61,6 @@ static bool kvm_vfio_file_enforced_coherent(struct file *file)
 	return ret;
 }
 
-#ifdef CONFIG_SPAPR_TCE_IOMMU
 static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 {
 	struct iommu_group *(*fn)(struct file *file);
@@ -108,6 +77,7 @@ static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 	return ret;
 }
 
+#ifdef CONFIG_SPAPR_TCE_IOMMU
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
 					     struct kvm_vfio_group *kvg)
 {
@@ -157,7 +127,6 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
 static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 {
 	struct kvm_vfio *kv = dev->private;
-	struct vfio_group *vfio_group;
 	struct kvm_vfio_group *kvg;
 	struct file *filp;
 	int ret;
@@ -166,6 +135,12 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	if (!filp)
 		return -EBADF;
 
+	/* Ensure the FD is a vfio group FD.*/
+	if (!kvm_vfio_file_iommu_group(filp)) {
+		ret = -EINVAL;
+		goto err_fput;
+	}
+
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
@@ -181,15 +156,8 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 		goto err_unlock;
 	}
 
-	vfio_group = kvm_vfio_group_get_external_user(filp);
-	if (IS_ERR(vfio_group)) {
-		ret = PTR_ERR(vfio_group);
-		goto err_free;
-	}
-
 	kvg->file = filp;
 	list_add_tail(&kvg->node, &kv->group_list);
-	kvg->vfio_group = vfio_group;
 
 	kvm_arch_start_assignment(dev->kvm);
 
@@ -199,10 +167,9 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	kvm_vfio_update_coherency(dev);
 
 	return 0;
-err_free:
-	kfree(kvg);
 err_unlock:
 	mutex_unlock(&kv->lock);
+err_fput:
 	fput(filp);
 	return ret;
 }
@@ -232,7 +199,6 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 #endif
 		kvm_vfio_file_set_kvm(kvg->file, NULL);
-		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->file);
 		kfree(kvg);
 		ret = 0;
@@ -361,7 +327,6 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 #endif
 		kvm_vfio_file_set_kvm(kvg->file, NULL);
-		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->file);
 		list_del(&kvg->node);
 		kfree(kvg);
-- 
2.36.0

