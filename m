Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83755A8766
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 22:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbiHaUQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 16:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiHaUQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 16:16:13 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46977E5894
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 13:16:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3FPN/ADbR2pIyX54Dd0uPQulyw7g/C0HybH+hNh1V9d+641QH3kU3VLnklsIP7k4utLUUY0EuzifpxGPx2ocw0Vv2MwRgndRVrFtUuKnBW9+gNBcVMndUhYWmfHb58p/9ex5yh29OAU4EG0RpD3+RB9AI4z2emiCz5DuA8oyqp60O3N9E2uhN1Gax++cxMIjh6i3PFIz6fioSFi+CpdQpW97qhNj6IoquYl1Q5otGYNBrvSqOoFQdPwkd/JnHh5W4QtdF6YgUL5iqlQ83QzB0K1E8xipzrbQJWnEOiQuzJSyfFnr9cNa5Gl922t50JEhWGrJxUGcBl8O4rt1W/ihg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xd2vWpZnyDMR+JH5YqO5OQ13owuQ5Cf/cfAib4sIdEg=;
 b=Yk07tkjYQdbQNPiTKGKL/N6yVjetBdJUrhe1n9XRkfoD6DluQB9qlyPsdI37wX7Nz8IPCGmpXmNCuTvrtxmW/fvS0CHHVmXyr1gIzi3g3/rNr2mK4RzgIprNqaKR+jMkkTyNQv8tBGeAP1rbk4Pdk573JV31tOHdWvt1qz9OIVKr9VtRUXxQXulOtFsOjoIegMZjCt+V0I7YdLIlPFPC7kQPktzbc1m5gSRb7rrLWTg63KwMsbWPsS/Xf4t6/Gu08o3KxrqP5iLA1fDQZncc72yFPRBXMpBR3sySRdXZQukn/Jyg9cJLnFrEvMO8WenPi7x5Usp9HcBpgJsebWVpZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xd2vWpZnyDMR+JH5YqO5OQ13owuQ5Cf/cfAib4sIdEg=;
 b=DoLTB1JKMkOaccLI/L09rlAYPgsr7BuUUNSmcGC20gb5adgheUzWCMhHk8fHLmGLSlWqD0vwOTzAgsBKHGqlM0Fi8gSk+RfdeprOxFUE37dhwdoXL1CRN3umtca0ortuA0GUfmeo0jUcYxdfhUrfr0NaqY6wu1NCQrrnVJOnwZczd2CgBO+jjuuGrXesj3V4V2bBnic6Kf76kbQZftvctpKOKHUznJN9PuLUvah+sacdvCP1eM3yKaADLyyp8zzFiABSuQ6FXcSSI6k0azCxxquTCvfSzKWe2e3RABpSthYcIKjttL/SZ0VhUvhUkOpA0Fx5Cd7qpf2vM0IEBrr6sA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by SJ1PR12MB6316.namprd12.prod.outlook.com (2603:10b6:a03:455::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 20:16:07 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 20:16:07 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 4/8] vfio-pci: Replace 'void __user *' with proper types in the ioctl functions
Date:   Wed, 31 Aug 2022 17:15:59 -0300
Message-Id: <4-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:5:100::48) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9d540ee-6ae5-4f9d-a019-08da8b8da219
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6316:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eqDCqPky9VfO9fRoReeESUta477wXeXjYIRUp3XMJaYEIpORwVw80gkujgZT+QXSho7p2jWEj5BRAScel5CUns8uS/D8v1WV1hyid9rrjOsWUWhlAuhtnW3n5AEQvDrY1Ft7Q4iNxeEF9FKhdc/dEtyrgCjd/Zc7K1NEGdRbVwDPbIjIJFKpjuEGD7ETzMeDOGV0IFouXygg+6SwIcyHI0n+NoD/fbWB2msi7d0GUU0ZW5zRDPCsfkg5m0+m8btvPHDkBdvpFfIOoyYZsOsq3ijpiqb31xSZNXds0dalAjYWypiZHtiPWEyw03QVYlWG8TIZJ3TtfydUzI7fFobWELjIslXRhYyknycanOTrLBCh+kGfTrGJ2k1f1nok+rM0RDjvpNEcV3x+HgRg0qy5IzAoXKdsvNhh5EFWuRUGRxMbkovxjn8cO1zUmLOpGTyByrtHBOQGZkh7wSCxoXUZ4Rq1rxRNWKGJ79pfgBh/YyBfXHhlCH1IwjNaN88ERy552BIv6jPAFP+CjF0jYcp0Lk84g653+r49MNIdAybCnO+Q/Qz1nCNehoNV59gbITwaIDkni2PTWk9wplHLZpiRBhsRDlHFW0r75XYDIbcim3KLahN0Rru2SLrrvDXr5vnJ9OhPmu6xghlntkMxkkLlvquFRCPoANjOZUajQNjHbAQBXZEI5RRXsH76o95PvyWr6ujK6kxVq5b1Uu/f3Tir2m8qeLEv6oU7IXv3m0vpsZYTdkqQ5A1tHALVUqXJLoD3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(186003)(5660300002)(110136005)(478600001)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(6486002)(86362001)(36756003)(8936002)(41300700001)(2616005)(6666004)(38100700002)(2906002)(6506007)(83380400001)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KEAFQnhZYqnXAjmokXJ701GuAkUVhAupNOKW2CGL93SRDIiTqTFVbLfCVQ1c?=
 =?us-ascii?Q?dJ0zrFb4m+8PgXTtP6WrCZcStNl0z8XWXuOIvJZsC0qMhHbt2eor/vWKZ8/S?=
 =?us-ascii?Q?JBkMqJpRfFBdCff3RJL0n2kefQdsIgdmfRVSIyv2mC3rc2nztro2BJv9tY6Q?=
 =?us-ascii?Q?dAURPCbJYtuGBcqNFEGkJdSxKtsv6gAP4XUrzxnae1tVnEzyskni9YXFTTk1?=
 =?us-ascii?Q?orpuguvP5BexX4NgA0c7yXub70jF5Jzbmn8x1XSt6Mexwcc7NCAW2bZtW3Gt?=
 =?us-ascii?Q?6U1/hPbjsz/TbYmng/GXn5yjthapY4Myz6FBnu0TgaBn24SxkIIZrsJyuySN?=
 =?us-ascii?Q?T+pXiC2WcyiZ9y+xHlyxYxmQb5KKCY9obNwOSWLwOjx8FN8K3ok7KCb7003/?=
 =?us-ascii?Q?9Z9C7Zts0/k0Z9cMgCb70Oy1cNoa3waX0EFdKzXLyLJUyT72kHA3pP2QAO9L?=
 =?us-ascii?Q?tA4zujNFkTmq31EudVjeZu6hQfZKD44yUndFJJwx6sOIlQOYA4Dj/BZT5et0?=
 =?us-ascii?Q?D+ajOfcGCqJYrAhwtSczn0Od/O6jVDq8QhD4QaoaQxYQ5Na2K4huL96DSySK?=
 =?us-ascii?Q?kRNEmiO0LNuFDVcPbo6LyBFNMMFA7/zAN7bUdd+fpRb0zcRqbE5VPoN1M9Tx?=
 =?us-ascii?Q?z5y8svK5hYTdzy6Au6AvRFF3FxbCtFR337lnlPksc4VO5oMZi+JbZWwrVE5l?=
 =?us-ascii?Q?8ED5PhxpVMi6cDvjXJmASRueDBK8MpODX6w8aMGpb4ZdShEYaLVewqWiK3oh?=
 =?us-ascii?Q?zEawkPFMUDk3GMhF/waV/CRmvb+9t8r13GhM27OXfvdvLq+spdOzV/USglil?=
 =?us-ascii?Q?7gnxcgAXXWxodiJRnlRZpAVOneesAlUJHGw2gRpt2zn6EQz8Mwfp2pdqJP8G?=
 =?us-ascii?Q?efS5Hz9aoZuC0N9XQC950h/L1CuU6GRyk8aG6xyTff3KFxcN3ZpC/faQIRcT?=
 =?us-ascii?Q?9NokN18kdRvup1W23a6yNVOqhsmaPF7sMMRa1hrSEOY+CdgqHWzmsywx21tl?=
 =?us-ascii?Q?9WGBLiHrlqj5/cQ/uljp0kYitNkgwlYT6Q8MTDH0coBvsrsIfb5zaCspcAXC?=
 =?us-ascii?Q?wr1PRobkFlTPeCv41tLUDWNN0tzh7RzS2KTTKOr/1mKWIU3Sg7SfR8+qKB0s?=
 =?us-ascii?Q?sgWdholO25l0bSQalyLLBL3KLFxwlARxDkcmqLiG4uEuTxi8i4ukz2epSrxf?=
 =?us-ascii?Q?Km8Ku1XcmZNITwqrXrD3Bj2MT32WyOYKcv/TGX02+20x8J+59Z/z0Ox/A032?=
 =?us-ascii?Q?FThNKlUj/G1rxwkq3hcy3z/AVlOtMfRxERpG1vSVfKcUvimidvXjsdnQCrH+?=
 =?us-ascii?Q?LfUmz6/YAulFkApBv2adKoIrZZpGvkaq018bjqY6AQ2h4ZSsvIvHtlWbpDuz?=
 =?us-ascii?Q?+F3xqQgdDqTHC7k63l/O08Ztp4lJlfrs3XPYW6r5JhlCysF6S7bwKT/VOAOb?=
 =?us-ascii?Q?KhokYhUjFqHa+SnxVoY5ISQkkXm4tW3cXhoUHX89i5CnsnnoH40WH17XBH5c?=
 =?us-ascii?Q?tJfKR33+ghDOmXjkog09IA2KW2oUnkOu5fIRz/g0VfQC7uyZ/w1Q076EwOvz?=
 =?us-ascii?Q?4E6eUfw9RGng6sINPheXqlfRHt2hTLixZw+H5qFe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9d540ee-6ae5-4f9d-a019-08da8b8da219
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 20:16:05.4927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2WsWLU8gf0xhVdMc6jPwTy6BBcQEVB4swT92N0ZOKyG8+Y343IuvxFqkYsUO7FrP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This makes the code clearer and replaces a few places trying to access a
flex array with an actual flex array.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 58 +++++++++++++++-----------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 8bff8ab5e807b9..9273f1ffd0ddd0 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -690,7 +690,7 @@ int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 EXPORT_SYMBOL_GPL(vfio_pci_core_register_dev_region);
 
 static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
-				   void __user *arg)
+				   struct vfio_device_info __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_device_info, num_irqs);
 	struct vfio_device_info info;
@@ -701,7 +701,7 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 	/* For backward compatibility, cannot require this */
 	capsz = offsetofend(struct vfio_iommu_type1_info, cap_offset);
 
-	if (copy_from_user(&info, (void __user *)arg, minsz))
+	if (copy_from_user(&info, arg, minsz))
 		return -EFAULT;
 
 	if (info.argsz < minsz)
@@ -733,22 +733,21 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 			info.argsz = sizeof(info) + caps.size;
 		} else {
 			vfio_info_cap_shift(&caps, sizeof(info));
-			if (copy_to_user((void __user *)arg + sizeof(info),
-					 caps.buf, caps.size)) {
+			if (copy_to_user(arg + 1, caps.buf, caps.size)) {
 				kfree(caps.buf);
 				return -EFAULT;
 			}
-			info.cap_offset = sizeof(info);
+			info.cap_offset = sizeof(*arg);
 		}
 
 		kfree(caps.buf);
 	}
 
-	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
 }
 
 static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
-					  void __user *arg)
+					  struct vfio_region_info __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
 	struct pci_dev *pdev = vdev->pdev;
@@ -756,7 +755,7 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
 	int i, ret;
 
-	if (copy_from_user(&info, (void __user *)arg, minsz))
+	if (copy_from_user(&info, arg, minsz))
 		return -EFAULT;
 
 	if (info.argsz < minsz)
@@ -875,27 +874,26 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 			info.cap_offset = 0;
 		} else {
 			vfio_info_cap_shift(&caps, sizeof(info));
-			if (copy_to_user((void __user *)arg + sizeof(info),
-					 caps.buf, caps.size)) {
+			if (copy_to_user(arg + 1, caps.buf, caps.size)) {
 				kfree(caps.buf);
 				return -EFAULT;
 			}
-			info.cap_offset = sizeof(info);
+			info.cap_offset = sizeof(*arg);
 		}
 
 		kfree(caps.buf);
 	}
 
-	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
 }
 
 static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
-				       void __user *arg)
+				       struct vfio_irq_info __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_irq_info, count);
 	struct vfio_irq_info info;
 
-	if (copy_from_user(&info, (void __user *)arg, minsz))
+	if (copy_from_user(&info, arg, minsz))
 		return -EFAULT;
 
 	if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
@@ -923,11 +921,11 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 	else
 		info.flags |= VFIO_IRQ_INFO_NORESIZE;
 
-	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
 }
 
 static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
-				   void __user *arg)
+				   struct vfio_irq_set __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_irq_set, count);
 	struct vfio_irq_set hdr;
@@ -935,7 +933,7 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 	int max, ret = 0;
 	size_t data_size = 0;
 
-	if (copy_from_user(&hdr, (void __user *)arg, minsz))
+	if (copy_from_user(&hdr, arg, minsz))
 		return -EFAULT;
 
 	max = vfio_pci_get_irq_count(vdev, hdr.index);
@@ -946,7 +944,7 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 		return ret;
 
 	if (data_size) {
-		data = memdup_user((void __user *)(arg + minsz), data_size);
+		data = memdup_user(&arg->data, data_size);
 		if (IS_ERR(data))
 			return PTR_ERR(data);
 	}
@@ -989,9 +987,9 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
-static int
-vfio_pci_ioctl_get_pci_hot_reset_info(struct vfio_pci_core_device *vdev,
-				      void __user *arg)
+static int vfio_pci_ioctl_get_pci_hot_reset_info(
+	struct vfio_pci_core_device *vdev,
+	struct vfio_pci_hot_reset_info __user *arg)
 {
 	unsigned long minsz =
 		offsetofend(struct vfio_pci_hot_reset_info, count);
@@ -1001,7 +999,7 @@ vfio_pci_ioctl_get_pci_hot_reset_info(struct vfio_pci_core_device *vdev,
 	bool slot = false;
 	int ret = 0;
 
-	if (copy_from_user(&hdr, (void __user *)arg, minsz))
+	if (copy_from_user(&hdr, arg, minsz))
 		return -EFAULT;
 
 	if (hdr.argsz < minsz)
@@ -1051,11 +1049,11 @@ vfio_pci_ioctl_get_pci_hot_reset_info(struct vfio_pci_core_device *vdev,
 		hdr.count = fill.cur;
 
 reset_info_exit:
-	if (copy_to_user((void __user *)arg, &hdr, minsz))
+	if (copy_to_user(arg, &hdr, minsz))
 		ret = -EFAULT;
 
 	if (!ret) {
-		if (copy_to_user((void __user *)(arg + minsz), devices,
+		if (copy_to_user(&arg->devices, devices,
 				 hdr.count * sizeof(*devices)))
 			ret = -EFAULT;
 	}
@@ -1065,7 +1063,7 @@ vfio_pci_ioctl_get_pci_hot_reset_info(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
-					void __user *arg)
+					struct vfio_pci_hot_reset __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
 	struct vfio_pci_hot_reset hdr;
@@ -1075,7 +1073,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	bool slot = false;
 	int file_idx, count = 0, ret = 0;
 
-	if (copy_from_user(&hdr, (void __user *)arg, minsz))
+	if (copy_from_user(&hdr, arg, minsz))
 		return -EFAULT;
 
 	if (hdr.argsz < minsz || hdr.flags)
@@ -1109,7 +1107,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 		return -ENOMEM;
 	}
 
-	if (copy_from_user(group_fds, (void __user *)(arg + minsz),
+	if (copy_from_user(group_fds, arg->group_fds,
 			   hdr.count * sizeof(*group_fds))) {
 		kfree(group_fds);
 		kfree(files);
@@ -1159,13 +1157,13 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
-				    void __user *arg)
+				    struct vfio_device_ioeventfd __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_device_ioeventfd, fd);
 	struct vfio_device_ioeventfd ioeventfd;
 	int count;
 
-	if (copy_from_user(&ioeventfd, (void __user *)arg, minsz))
+	if (copy_from_user(&ioeventfd, arg, minsz))
 		return -EFAULT;
 
 	if (ioeventfd.argsz < minsz)
@@ -1214,7 +1212,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
 
 static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
-				       void __user *arg, size_t argsz)
+				       uuid_t __user *arg, size_t argsz)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(device, struct vfio_pci_core_device, vdev);
-- 
2.37.2

