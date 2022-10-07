Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749705F796A
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 16:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiJGOEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 10:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiJGOEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 10:04:48 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3B817A9C
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 07:04:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mur00gwUi8Spnyk59cGBRBKeFH3FvrK5PMWingK+u3E76EJf0WEcjLgXc1hxlSc+RPhhntq5+c+aMrpeaXk9XkW7DDNNuEi/RRufGWizAkuTALumWfP9fjCbrdPeiFRuJjMNFOpDcdl+SLpPzgFs1kpQHdLsM8BazSlSuFSFa0bZcYLMNI2gIveEVHgN7lWZT2g81MjTFblk2kxu7HovhWmeSJxdkplXTeclN0E7ZWk2PHgBcZdE/aEq6FcUv//9ofB590S9FBJ7RBoIocw2PovYgEY73heEntb6V/UZRIgnNZQbKY59B8IsxBt/m/RSsfiRIGwnV2ui7eTArznZTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUcEactj0bVdW832OV0/q1koo+da6RW648kvHAfbCT4=;
 b=epH3xMW7BiYX1olnr37qxM+sqYxVLSZ9zDPlLen3GYJPk2xXIgwABiEFzMkPC8UErqLo0WEVqOuGs0liCHAX8X4eKTtV/VnWQkeI473e0PWxn+/dbuR3zBujyavo4G3/+pfs+5irUoHMG75r93BIO3SqEgaWLC52pjaI9jGTB+fgo11zxvAPsTZgiMS9oCmQfV6oUigzVTbekc1ROFHRh/bN4hehtuTPt97ZIrGIPMzxmW36YVaA3QBu3U3V4mhmSUHA5Nno6kCTj3exxbBXpVcKIjbCeaVbrIJ6JFI9rWTlArFQ7fs8d/ldoimbedwlxFEetAuTNVpvxFkA3cumSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUcEactj0bVdW832OV0/q1koo+da6RW648kvHAfbCT4=;
 b=WjiF1RZaMzyWWa1yzpWH5jlpxw5NHunlwi6SdReKFjzXmmONPNebAsNlh8Aci5Biu3Ih0L9WhY3JEDMAvpm9WOMneHhnqCjiiIzv3EeLLKJVqgCvcpAwbbVT+xhKEfXn9HXm3fdpkzUcqDAOR5Jj2B5xMxellTuzHM2+KivB9tsLRR0XBVJMP8X+Xn9Cg9ZYut4viW2EqCvnHEnYP7vDMsKVRs4jazR1x5DCIETfOuralO6Il7khjkF/Jo/rFTlVyggDySH3v7Jk0ppcXr2Ou6MfNUp8p8tIRQCgVH9Ze4aQbYKqdvj0TCw2LMlRwIHTfvaKkv8hCXoaULjoO+CQVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Fri, 7 Oct
 2022 14:04:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Fri, 7 Oct 2022
 14:04:44 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2 1/3] vfio: Add vfio_file_is_group()
Date:   Fri,  7 Oct 2022 11:04:39 -0300
Message-Id: <1-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
In-Reply-To: <0-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0103.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: fdc9ac91-f11b-4ace-42e8-08daa86ce224
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kOI00PdZYrFHLgopY4s6tReJacGrcsl0pG73+Nk6nM8qoAiflLDgK69gQaDdpYeInqHMN41IbBfCQ1H7hVb/hfGebNX2bvFA+DrgDuiMCYMTiQzJy7+vJdcTiiBPcFP8GqSBEU1xCIagKiGQS109WgzZPWvGol59yuBDY4m9U3cpXBNLZQO2zLvI5nz1jhpBSnuLrjAxYBmaxmxUFrXlZaMda0rSAyWxli0vD1RTp+wWp1pisZmBarM6+fcTM1ZRnzpMUGpBi3db+emDEA7TOGQ63thaUQCSegKUTnAFa6CeHmYrkv9XUWH/1gIGSRUlh2clV2kiM2dpu1jcmFDoiTbF32g0X0SzDluFpM0J0vJDklEql05F/OsodhmCF2D6ZxnMkQUjHrm5JH1EaiQru0O6pgIyx1XoDHsjB296+kSzx6KM1h8Zp70iy7IyzpaM4nOQRbNZIBZymoKVfyilDZu1c6p02PvQHl42c0LwIpvL9GzGuFmtmjRZ/H6CC2xeo+VcdpJXsplxKwxLUeP2qAhCE4PsKsHJVuxngO8saeE6nRtOIC55jr4vVcmfD4VMt06UoIWSglqDuOxdyFJz8xF/fWQgC2S3MVJwgMETtCFrf/VUh7tj3sCFO2pCN+e2AmJ1HAMMghpChVzqlz/ANLj+/MHKjWAgW/yCSg5fxlj1My79QA/g/Rsuw6YJju+aBhl6ncnls4/Q9oPr8KkwvWeX9ZQFZboDuFhoan8Ii4qDL4tBSjn9plsDKy99/jsw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199015)(110136005)(316002)(5660300002)(54906003)(7416002)(36756003)(6666004)(66946007)(4326008)(66476007)(66556008)(41300700001)(6506007)(26005)(2616005)(6512007)(186003)(8676002)(2906002)(8936002)(38100700002)(83380400001)(478600001)(86362001)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3RwiXGviPisorLDbm7VWXlQ0dOIGeTkeBCCBmmcWN1henJUFgWPmz+Nez/O1?=
 =?us-ascii?Q?dsatFgXxoU0vYNotnM8+332EfQMswDbhWaU6BjFzVbxJm9A19RVF26mGcjFy?=
 =?us-ascii?Q?CRyI/pY2PFqYHvJryBq/pd76YHXWtshXXFa0yUFQyXoBPMIj/7BZFwOSkF77?=
 =?us-ascii?Q?AvhCDjYW8RmYm4cOIe3Fync446NbrIOUKa6tYH3G5vKnXSm7dqhdTGJSLgW/?=
 =?us-ascii?Q?9Vkb8rv/3UyDcvenWXZW6Oxrb9q1L5Gi2Rd52Su5KTchHRvUp6kwk2pqEK+g?=
 =?us-ascii?Q?iMHp1ePHA2ZGtNNM8gLwPPWLSmnRDJwBtt+/X0nMMEprm4yLJc/OAeVtR1Dd?=
 =?us-ascii?Q?p/FEP+LPRhga9445McK+x1h8ixf6tGPuAdXpP4mPG9Ywz/8E72GQHRwt6qO2?=
 =?us-ascii?Q?0IJJ8lMVBLdD1j2LhtwP6tyJTXn4ndmUuUohxtNns6wckKzNSSbgg72r6TB/?=
 =?us-ascii?Q?vBnXbYsL21N7xChNHJlxV/AvyDzNKKYZ6m5PmfmjENJ7EeM/svP221Bu6kbr?=
 =?us-ascii?Q?ksWAOKKuANqhnt0MKum2zPMEKzJHiCPeG+l7I/Zvq5jalXsYnyKGjYp1qczr?=
 =?us-ascii?Q?zp1QMqFRoy5N3D9AcbNCbrdW1+RMpHLLGZnhV7EmxE5gYyTPQVBnRcFF12qV?=
 =?us-ascii?Q?oWPTha+RQ1zZddT1y31Fr4aZHd0eBDuRDtSV3O1/0U1IMEm4JuEUiFiBkhP+?=
 =?us-ascii?Q?RQndopZBD0i2Iuu3VQJN9H1mxAOG5HwQVGU5+lOebaKphy25EnW37yOUKRAW?=
 =?us-ascii?Q?c8d0MO3/elvQtcT09xPMEi41UTdAIVDu50HVbZA98kF/MMREc9au8RG69V+z?=
 =?us-ascii?Q?IUnO+rfJ1cM6/7nxFmFGtaZzM9WEAsiKO569aPz5s14fCwg2TezNH0oBx2E2?=
 =?us-ascii?Q?/6TZaaP2cm0En2Hvna0vgEN+xv8anGZCVHUpxrdp6cA4Svn7+WGQyPaUs6em?=
 =?us-ascii?Q?ucE+hdreyGty15ZW35cfNS5/PoFt2JyRIrZ1wy7XKtksT44vHbtOIqM01svZ?=
 =?us-ascii?Q?XD4lALH5SZOwTFfgi6Pan7E6AixUilvjGwI0p+ocHpN56Oz6hmHXNp7kkrzC?=
 =?us-ascii?Q?sJSc6NZnbLxwtrzWQ1rhXM4NLutYEH7jcdZy+yyXOTjronWFkOysou41toly?=
 =?us-ascii?Q?NS86SQr8mlK70qa/NcDLu9+ffJNk5pBRxIn2K1cmCHxUiZiqpTlJ9h6KcvpY?=
 =?us-ascii?Q?bwW++KJM1N03RZzhUsSCKmL00qSG0nuImylo5trHl2Grcxmw4XkcQ6+Adneb?=
 =?us-ascii?Q?W/4Zc2f3GhHQ9CYyvDpuC6/EJI/MpPW5oCDq7TvPFR1zCWd9xvTA+molhvfx?=
 =?us-ascii?Q?y3UwBXTTwXc88OQNYTuh1gyDDkV6Bf3gGPf37X3Iua7dmgvpRCgb86m1fv5o?=
 =?us-ascii?Q?NL3pt0JHgLOvCggr61OBrITusxF3I0zWCjOTq7491/o6xiV9++hDtGOkKO8e?=
 =?us-ascii?Q?xqUGIPZyFxhskfY5Y43h731Zn4LjGyHIoScwciae8SKGdvIS5pm2osO4lPul?=
 =?us-ascii?Q?TH0I1Z3jZghztAxifjRZy0EhX6fnI8v3e5o8YPl7ayHMEdfKl1mYmCqic1Vk?=
 =?us-ascii?Q?qqrRrrMIOKtMz9gp0eWiyx2zJ9KGTwa1jBOgBON9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc9ac91-f11b-4ace-42e8-08daa86ce224
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 14:04:43.1714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wngVRtYKAiJHFrM2/mkAZ5WXJoMYHgK8KSRlkRxeNZgb34DrPEA3n67FaB6b3jB/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This replaces uses of vfio_file_iommu_group() which were only detecting if
the file is a VFIO file with no interest in the actual group.

The only remaning user of vfio_file_iommu_group() is in KVM for the SPAPR
stuff. It passes the iommu_group into the arch code through kvm for some
reason.

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c |  2 +-
 drivers/vfio/vfio_main.c         | 16 +++++++++++++++-
 include/linux/vfio.h             |  1 +
 virt/kvm/vfio.c                  | 20 ++++++++++++++++++--
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 59a28251bb0b97..badc9d828cac20 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1313,7 +1313,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 		}
 
 		/* Ensure the FD is a vfio group FD.*/
-		if (!vfio_file_iommu_group(file)) {
+		if (!vfio_file_is_group(file)) {
 			fput(file);
 			ret = -EINVAL;
 			break;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 9207e6c0e3cb26..9f830d0a25b7a9 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1553,17 +1553,31 @@ static const struct file_operations vfio_device_fops = {
  * @file: VFIO group file
  *
  * The returned iommu_group is valid as long as a ref is held on the file.
+ * This function is deprecated, only the SPAPR path in kvm should call it.
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file)
 {
 	struct vfio_group *group = file->private_data;
 
-	if (file->f_op != &vfio_group_fops)
+	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
+		return NULL;
+
+	if (!vfio_file_is_group(file))
 		return NULL;
 	return group->iommu_group;
 }
 EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
 
+/**
+ * vfio_file_is_group - True if the file is usable with VFIO aPIS
+ * @file: VFIO group file
+ */
+bool vfio_file_is_group(struct file *file)
+{
+	return file->f_op == &vfio_group_fops;
+}
+EXPORT_SYMBOL_GPL(vfio_file_is_group);
+
 /**
  * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
  *        is always CPU cache coherent
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ee399a768070d0..e7cebeb875dd1a 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -199,6 +199,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
  * External user API
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file);
+bool vfio_file_is_group(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index ce1b01d02c5197..54aec3b0559c70 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -61,6 +61,23 @@ static bool kvm_vfio_file_enforced_coherent(struct file *file)
 	return ret;
 }
 
+static bool kvm_vfio_file_is_group(struct file *file)
+{
+	bool (*fn)(struct file *file);
+	bool ret;
+
+	fn = symbol_get(vfio_file_is_group);
+	if (!fn)
+		return false;
+
+	ret = fn(file);
+
+	symbol_put(vfio_file_is_group);
+
+	return ret;
+}
+
+#ifdef CONFIG_SPAPR_TCE_IOMMU
 static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 {
 	struct iommu_group *(*fn)(struct file *file);
@@ -77,7 +94,6 @@ static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 	return ret;
 }
 
-#ifdef CONFIG_SPAPR_TCE_IOMMU
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
 					     struct kvm_vfio_group *kvg)
 {
@@ -136,7 +152,7 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 		return -EBADF;
 
 	/* Ensure the FD is a vfio group FD.*/
-	if (!kvm_vfio_file_iommu_group(filp)) {
+	if (!kvm_vfio_file_is_group(filp)) {
 		ret = -EINVAL;
 		goto err_fput;
 	}
-- 
2.38.0

