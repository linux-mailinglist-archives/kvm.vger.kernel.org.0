Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E57B5973B3
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240819AbiHQQHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240731AbiHQQHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:07:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFE8402C8
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:07:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKk5PqgjaJtVrZU6Eod/AgcharslUJZQdQH71mcTtRCPdx1ArMqRl49LPdSQdo5BI/E1lHV2VgFso7IlpUnuYU1LROqWRK2L1mqAi68DNTZYV9DvMCV/y3m7x2cFn4Dt5F//NzhAbu8/V3iUxJMmqhoN86lCstgpACO7UJ0cFX7i8YFyYvTG5lwgFa8bNuwuQ6euA/t1wsoQ9SSGJ9HW1f6WDHvcTxbvsnmeWpZcROClNUK8ROmGeKM042qI6u9mSTjKq7kyBS1j4aqwL0qE8Yl0fAuKwLDdv1TCYjnp4fVCsWKSr4WZeS77ofeA57SsmTYWei3WakHkrGPGH1mEOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=no2yqzYJXokMeG131Dho5VFjKDKTSyCHlp6AVKaxGdw=;
 b=mT1mgjqcjGqSOPFVLGd/f9VfuSIWDCGlekbQt0EcptpUYktG5DqXETZ8umsJwruntQXSP2yUjReGDq70je+CA4Sf8of4VNN3Cuez6a7ZMavrpBwqCemr9Qi/H2+kEZiQTExqao5gg2Hxm5+D+U7zccEBJS26ODXIxsGJ7k/1hZ5XTNTpmqtKYjobDIJAeVWHQnTYguhYZGtSu6O9WS/XYlWY1TaU2bnR4x+N8d+WmTyxRPYpGYGR65kz+blH/POjFG5eQCd7/yHuPfTTwiMOGvm+9wRWc38EuTFshToDHbSGSuoLtJW8KQDRqV4n1/L5whJYdvHZi494TiPT9LVsng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=no2yqzYJXokMeG131Dho5VFjKDKTSyCHlp6AVKaxGdw=;
 b=hEi10DJVB7LWTJLe23JlJsplViM9GjKhbtcAxHbitEU2I+oH53Jq8o1ryrvLQWwUGl/kYdLGW4AkhCrRPx/QqVfM0a40L6CuZDA7//a6FNDZKDelJOOCJaIYT64PKM1p4VNWZ1lYSm6nfCkF6BwEcUfmmceF8qeI6Oj95pRGd1FR2LtBOAGtC7ndTGGlZ63pOiXQZtuK5deu5nYbLO8lae/0u7/QOnK2ep4l5RLeSvvDB7f+2h9DX+2kyQIwSp5cnhfd2xyNYkxzVl6L/PQSf8ksc49paT+kT1PM+RcmY9eJEA/yYyCXzo6u8pad8qJZKZPnWuVnQ1f6Tt4KJ40RSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR1201MB0216.namprd12.prod.outlook.com (2603:10b6:910:18::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Wed, 17 Aug
 2022 16:07:30 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 16:07:30 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: [PATCH 2/8] vfio-pci: Break up vfio_pci_core_ioctl() into one function per ioctl
Date:   Wed, 17 Aug 2022 13:07:19 -0300
Message-Id: <2-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:208:236::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca88584e-1621-4045-17fe-08da806a945a
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0216:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 77ihcviOVFzTAzHWiWctgGHxT7M8vtJdIddu+1cFiesSjFMFhlySI6L9xX7Tv1uEWunbMWo7J8jjEc330H8Y03p5hYi/t7x6v+CSdI32a84NWlhVP4OxhkRW1zzRhlWgU+xPfwqzz3exr3KAGiXpqY3MRsWfmOz6+79YGECG5hHx62UxMtdf+1KG4vC0pBlzmCjwrpoDLYTH8vnoiDU4iOSaATik8FKiBjinCi/nY80y7rnnmu3sxIrLjtgYv3LrL7q/1u2RR65Xyv0Hl40Is6af70Er0aR7fnGCz6D3T16KQOPid9S16ZSigtaBAad0+2v1CxxVjv+mQdMBT3r/igPzd7V2bmthgsdX+Xx1HuegOqj9ooGqtJqeXphhemDZvPqlwspUmIGD6WbauXSi/NHdyTkEtVN7kvk0qBOH0y471Kj/xf9QnuiBNyPaYYBsGhx/4W6DDzAX+MqLfORMCfITlck7W+HynGkGF1/3/w0nvMDCIogr9DSLIkpy/hS99B08T4qUfoSVOH24aRyF9aSMoOJit5qxKU+1tBGfSETaY0nmcaJ1ExYreij5KRSfxhMrJsEgafiwpBg+jLCRMHQoPZ84iGRO6RINAtBybNrQ8zelzdF015IzAbaRtZpBu3yJzY/LLgWGJ4wof/xrtmtc/DlsxCmCUShKmHmephBmIH6Xc95jwZ/bJOqF13qwWWTrJjTFYj9Vr/EpLscE4R1UWND06Dy+nWacrqYXBn5ci+u1t1mMCA8Py+mZSuyXyMvG02Ky32HJAF/hJQpSoundvMlciBOJs5tCy3QY840=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(41300700001)(6506007)(6666004)(6486002)(26005)(66476007)(2906002)(478600001)(8676002)(66556008)(110136005)(36756003)(86362001)(316002)(6512007)(38100700002)(186003)(5660300002)(2616005)(8936002)(66946007)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uIAO2sADa7xENCLaDuUYaULlkrsvWiAWCI6WvhfgRBskcW8Fu8pbysVtMwvY?=
 =?us-ascii?Q?M83EAWY1B+Uo7L8Akx2NSdbcyYI+oiWU9qcURg2nLklm4l+O58YD7T0Rk2C/?=
 =?us-ascii?Q?MpLaTvqzovGlwNhRxHj4NG2zc2WKNQrts97RBGn+GgYzRCnEkbZ7NPmzERal?=
 =?us-ascii?Q?PiBYGBA1aH5ee2EmwpWGEq5o3g1rxGb2z4VFQXnpXOzlYL3e6i201O1CISGQ?=
 =?us-ascii?Q?FffX0VBqs1ULYEU//43mpLJMiMld19Em8IaF28/QQy+zGKiDtEb326fPRZ+q?=
 =?us-ascii?Q?hy8GgJBqe/MGwbC+V8WxiSRb8eAW2C4GoNe7MNFYlkjA9GkYSzXP4UPDvS5P?=
 =?us-ascii?Q?eBnuXoem+EmozjtkseD0PnlizvHx2MM9T357hAdMjFbQ6syRmfy74snBivVF?=
 =?us-ascii?Q?6tLQr6liTwkXzQ/dss7ZBV5YZ78exSxUp2pGVZYK/54O+zkn9DEyr5PAi9K6?=
 =?us-ascii?Q?jWe2QnzzyCP5TyVUaIMMGnmR86jcRrlHZRrwOIQUor0BziyLxHIQ+wQuRlgW?=
 =?us-ascii?Q?7u5kRmJYtjxCUrsFvsk4vIZvVnakOjI0V/VclPyHLx1bDrUMmajbFuCotnYg?=
 =?us-ascii?Q?jt1A/33v6G4P7NhgdVKuglfVm9DweKNc/6iEqkxfAsn2ZBhceHtGGphreuqz?=
 =?us-ascii?Q?gJnchnhRICv34NmmZDA/8AjjT/HiNCnlMx4Zevp7LrwJEmFKrf8813zl1Q1D?=
 =?us-ascii?Q?AHH/Fqr9vDWUdkGxzF9bDwsU+jO8ZFx7ZdN3T4fj42AiTpcPLf1uocm25xFt?=
 =?us-ascii?Q?xfAirYGt2LnAwaViVz+bSRJOfF4n/ukE3EmI15eCQqE1ReYw2N4TUIP0n/7q?=
 =?us-ascii?Q?1uF4W3BOVYt3/X1nlgbTOX+34WEIKt6dRF2gEFpcBLqEBVDm+e0TW92em9tD?=
 =?us-ascii?Q?cJezpuNcu07VGQKiCWeztY/Ghd7S059iw0woSaMhHy0xl0IMBSIqAIkfZi/i?=
 =?us-ascii?Q?oKWR/L8dc4ojApefxQHjFothLB8zwFm4uNqoh/eOVSDqBWN0D+SmPiYONj5B?=
 =?us-ascii?Q?gQYIVQr/QallhJxQg8a6bcC8Zt6+HL13a3Er6z97aelHAfqWm+82CHi/Tyy7?=
 =?us-ascii?Q?vl7+4QK32JiQDJd/+AFuE7HW3ZnuZHh42eXeb1qHXmCfWQbmoDKEzUdQ9VrZ?=
 =?us-ascii?Q?2b7ujs1LInaZXv8gAu9BxeJH12R11tk+G95sRzLl264ctrmOF2dZvR808OH2?=
 =?us-ascii?Q?ogd9LpYcO3EoAVq0YgkiuAPKNGBa4Y2egiNDIM0yFFK5PqA0UjN/XyMW7Szd?=
 =?us-ascii?Q?B2GBRlawjUDUjWo0w2K7DnDzp2c56u63NERf1HbCrKcI7yHF2U9v5aOIhFvI?=
 =?us-ascii?Q?DAuFb/8OxOTWGEkCyEcC2esC/2OBkMzwmwRqh2+DRubFVgOntSAonSRVbPgD?=
 =?us-ascii?Q?Xn38pjzwCfbTNXBxNFtPoCLxHn9e+cENPMHyVOuGlfqFJZlj67eJ2+mCaoQv?=
 =?us-ascii?Q?xk6V1PWWA8DoTAcR3+FxoLFn9QNVZNV5pV+9B6UmQsZqomRfmc/kgTXUM0go?=
 =?us-ascii?Q?LfC5uNeFVq4AHhVn1SXti2TrueI2eOi2APOrI7f9vKBeea3ldzc1rRuLGaSl?=
 =?us-ascii?Q?f4a9+Xs5SRLP33EZaPXPKT3lxrOorRkrI5BmPgc+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca88584e-1621-4045-17fe-08da806a945a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:07:27.1260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dXKmXV79E+7Z+HsnTTkngzO0Ln8rbyGJ0fnrV7ksdEAS7dcuL4C91SH2jRqMZvk6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0216
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

500 lines is a bit long for a single function, move the bodies of each
ioctl into separate functions and leave behind a switch statement to
dispatch them. This patch just adds the function declarations and does not
fix the indenting. The next patch will restore the indenting.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 97 ++++++++++++++++++++++----------
 1 file changed, 68 insertions(+), 29 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 04180a0836cc90..6094f237552b35 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -689,21 +689,15 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
 
-long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
-		unsigned long arg)
+static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
+				   void __user *arg)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(core_vdev, struct vfio_pci_core_device, vdev);
-	unsigned long minsz;
-
-	if (cmd == VFIO_DEVICE_GET_INFO) {
+	unsigned long minsz = offsetofend(struct vfio_device_info, num_irqs);
 		struct vfio_device_info info;
 		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
 		unsigned long capsz;
 		int ret;
 
-		minsz = offsetofend(struct vfio_device_info, num_irqs);
-
 		/* For backward compatibility, cannot require this */
 		capsz = offsetofend(struct vfio_iommu_type1_info, cap_offset);
 
@@ -752,15 +746,17 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
+}
 
-	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
+static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
+					  void __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
 		struct pci_dev *pdev = vdev->pdev;
 		struct vfio_region_info info;
 		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
 		int i, ret;
 
-		minsz = offsetofend(struct vfio_region_info, offset);
-
 		if (copy_from_user(&info, (void __user *)arg, minsz))
 			return -EFAULT;
 
@@ -897,12 +893,14 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
+}
 
-	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
+static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
+				       void __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_irq_info, count);
 		struct vfio_irq_info info;
 
-		minsz = offsetofend(struct vfio_irq_info, count);
-
 		if (copy_from_user(&info, (void __user *)arg, minsz))
 			return -EFAULT;
 
@@ -933,15 +931,17 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
+}
 
-	} else if (cmd == VFIO_DEVICE_SET_IRQS) {
+static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
+				   void __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_irq_set, count);
 		struct vfio_irq_set hdr;
 		u8 *data = NULL;
 		int max, ret = 0;
 		size_t data_size = 0;
 
-		minsz = offsetofend(struct vfio_irq_set, count);
-
 		if (copy_from_user(&hdr, (void __user *)arg, minsz))
 			return -EFAULT;
 
@@ -968,8 +968,11 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		kfree(data);
 
 		return ret;
+}
 
-	} else if (cmd == VFIO_DEVICE_RESET) {
+static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
+				void __user *arg)
+{
 		int ret;
 
 		if (!vdev->reset_works)
@@ -993,16 +996,20 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		up_write(&vdev->memory_lock);
 
 		return ret;
+}
 
-	} else if (cmd == VFIO_DEVICE_GET_PCI_HOT_RESET_INFO) {
+static int
+vfio_pci_ioctl_get_pci_hot_reset_info(struct vfio_pci_core_device *vdev,
+				      void __user *arg)
+{
+	unsigned long minsz =
+		offsetofend(struct vfio_pci_hot_reset_info, count);
 		struct vfio_pci_hot_reset_info hdr;
 		struct vfio_pci_fill_info fill = { 0 };
 		struct vfio_pci_dependent_device *devices = NULL;
 		bool slot = false;
 		int ret = 0;
 
-		minsz = offsetofend(struct vfio_pci_hot_reset_info, count);
-
 		if (copy_from_user(&hdr, (void __user *)arg, minsz))
 			return -EFAULT;
 
@@ -1066,8 +1073,12 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		kfree(devices);
 		return ret;
+}
 
-	} else if (cmd == VFIO_DEVICE_PCI_HOT_RESET) {
+static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
+					void __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
 		struct vfio_pci_hot_reset hdr;
 		int32_t *group_fds;
 		struct file **files;
@@ -1075,8 +1086,6 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		bool slot = false;
 		int file_idx, count = 0, ret = 0;
 
-		minsz = offsetofend(struct vfio_pci_hot_reset, count);
-
 		if (copy_from_user(&hdr, (void __user *)arg, minsz))
 			return -EFAULT;
 
@@ -1160,12 +1169,15 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		kfree(files);
 		return ret;
-	} else if (cmd == VFIO_DEVICE_IOEVENTFD) {
+}
+
+static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
+				    void __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_device_ioeventfd, fd);
 		struct vfio_device_ioeventfd ioeventfd;
 		int count;
 
-		minsz = offsetofend(struct vfio_device_ioeventfd, fd);
-
 		if (copy_from_user(&ioeventfd, (void __user *)arg, minsz))
 			return -EFAULT;
 
@@ -1182,8 +1194,35 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		return vfio_pci_ioeventfd(vdev, ioeventfd.offset,
 					  ioeventfd.data, count, ioeventfd.fd);
+}
+
+long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+			 unsigned long arg)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	void __user *uarg = (void __user *)arg;
+
+	switch (cmd) {
+	case VFIO_DEVICE_GET_INFO:
+		return vfio_pci_ioctl_get_info(vdev, uarg);
+	case VFIO_DEVICE_GET_IRQ_INFO:
+		return vfio_pci_ioctl_get_irq_info(vdev, uarg);
+	case VFIO_DEVICE_GET_PCI_HOT_RESET_INFO:
+		return vfio_pci_ioctl_get_pci_hot_reset_info(vdev, uarg);
+	case VFIO_DEVICE_GET_REGION_INFO:
+		return vfio_pci_ioctl_get_region_info(vdev, uarg);
+	case VFIO_DEVICE_IOEVENTFD:
+		return vfio_pci_ioctl_ioeventfd(vdev, uarg);
+	case VFIO_DEVICE_PCI_HOT_RESET:
+		return vfio_pci_ioctl_pci_hot_reset(vdev, uarg);
+	case VFIO_DEVICE_RESET:
+		return vfio_pci_ioctl_reset(vdev, uarg);
+	case VFIO_DEVICE_SET_IRQS:
+		return vfio_pci_ioctl_set_irqs(vdev, uarg);
+	default:
+		return -ENOTTY;
 	}
-	return -ENOTTY;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
-- 
2.37.2

