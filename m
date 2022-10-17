Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844A660167A
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 20:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiJQSio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 14:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiJQSil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 14:38:41 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE62072B70
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:38:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlGnutFFYqFcwlLtIDBHZ7kfBcnfrqLQuNlYMbcltbUq7zPPpTCHBEag4LpomMJU2AOP8anmQ4yKYsafubr4ypIe5yE8I1q62nrPXTk2gfVjWvWi4s4C1CSknTWGyWEtDlq9jlAEKDRKPKbHrcfFPAhCjStmwJia2TvA3/sTejn8FbDkPgqT8Y9X2+gbnT384pcLwqcDRgYx7Vcc8Ca2142DshY5r0AchSz0Yzz19OpVRlfNFkdOS30O4JnQ7sJXJNf3mN8Ro5X+SrweXgU+iFsunsLyTEFK6kuehVRmKWS/MGmwD+DCPiGaB9fUgjYYLPy2/GcD/Nm8tpA2WxG/Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmnOqlYICPCmAzE9NnZx3nqYYZxpsBMsbeSjayipXgI=;
 b=j8TrJDQWtMRriQr2s2P/+R/cgt5nrA2Ew3BT3Hh3EOVaNS5kHXkTPf3d01bwckiGyNoo2AB+NTMKnWnVvSkaDcS7kZHqXjW0LlZ8QK2ysbCMoFDIXCZC8uUCjFvbqTW6wp/0h+EgIXLjXhMHObYpl6YF7dbuS7WAl7QTAG2vpHAd+vuZmwOZV5vKF8K1Tthecw9KgZpDRn9oQP3ghbdOhuLZ20gNlFybSutwBtSfHeGnRSiOuzIwus2M49XUB9sj+oCgQonAHUb9Rt8e0r8ifm9KqEH6eN/mkizjS/Gww9MZ/ZMDnQ6OzKGooTeMmQYXBTRpPO4Dhdu1HvttGUHDiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmnOqlYICPCmAzE9NnZx3nqYYZxpsBMsbeSjayipXgI=;
 b=ZDZj5y2S0DwQ9UVAyaOoR60HeWA4b/mJsawGp7ibzfGenxRrIHlzKlPkvDUkMEE39WM0bOmhnnlBky2Pvdmukw8xespUKdNpelnN/+V/kXbrgYTT8GE95Qi1UJrLS8JSPbtbLaoANewDedBTtOd8G+2b8UIaajbc26olz+Gs2utN+BG+r+gfGiRCbrOiTsIHqBClANHKg4FH/MRDt2hq8k2uCM1Sv1VQx9QnMLRUFugEZ0zCnQcggqFkPq0tQmBdnD7mAGOKQLxiFSmHgDdMo4dCVOY+AcxmH0uAVKBUWH/d1zLyp7PXrZU0ceC1d1VUvdwW4cEDM1XlBdRR/S9zYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7161.namprd12.prod.outlook.com (2603:10b6:510:200::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Mon, 17 Oct
 2022 18:38:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 18:38:36 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 1/5] vfio/pci: Move all the SPAPR PCI specific logic to vfio_pci_core.ko
Date:   Mon, 17 Oct 2022 15:38:29 -0300
Message-Id: <1-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR10CA0010.namprd10.prod.outlook.com
 (2603:10b6:208:120::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7161:EE_
X-MS-Office365-Filtering-Correlation-Id: bdb09dd4-ead3-4389-b2e8-08dab06ecc4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B86mGf8RXTAy6l4Oa1f9vUbGuYMLKEscv1tIxchqJpEptBNvaigRoR4z80LEge6YEc8fD6UiJcOYQ7/TmPqLVNHs78m37fFQQs77hm3IaA8d83gFkTxJcV9veOf0xFE7WBPtvxQ18faHpJW/dm+ECjGgSsnbf5sQI6vwwzBPFfgIfaY2+YcFWCqDN3Pl8IkBa576/1ffoBaZ8XiOfPSmPI77G9K0V6jHhjH+QQXThuyQIAFW2+EJF6cCxme3V/YrP97R9b15M+JPiQB3zteUidYuUTSqDxuHjjEjign9cKRy8IdmoRe42aUKtGT72PIDU4aCNszoAx0C6sBL+n97oS+hfJboOOOPtcXsX1LNW3ov2grEKx5xGnk7AXakK2Ib2kH5T48cDo2Mj41fpQlgztE2YantGk4qhrcV/fx37J90iVxGWagoUifv6IbLMVZ/Sc4CbfEvyG3TOuNaehOOc3GqUt4i7uu2w0zWXikm0K9xmgljFAKMz4HZTMaUZdBK0IzaUeMPxZ3eCHshMjNN83MAlV/YelcFmapMgzDcRTRmfc2yV51M3/4NUjpQadC1bEMAiL0gu8HaDDzEuyvAZ9EO1NwMirk8d7ZYU0LnlvgklCdyfp2Di6byjn11sG/TsjZoacxQHCUj+iF+cAJA1JaYSHNR6uUlgiTOlIT2wIftrifQ6Fq52IJkPRDorCSjYL9Bc4Wc5Hp0vaGYogb0BhAmkfryGN408wLpoK5KcwcMsaR62Q2PP3F6EDjrQh46
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(316002)(110136005)(186003)(36756003)(2616005)(6506007)(2906002)(8936002)(26005)(86362001)(41300700001)(83380400001)(6512007)(6666004)(66946007)(66556008)(66476007)(5660300002)(8676002)(6486002)(478600001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+uTOz0TUKEpeBIRPcpBj6VxjUAH+R9Ph6cmg4si2iBBiLVaOFVWryO9odg7c?=
 =?us-ascii?Q?XnF0RweqjURronkAwqKsqecwzXmXsOmCDhSj6Y5diQDhAQVmeGxGSW7vOwMk?=
 =?us-ascii?Q?xU7MTIafo6XkSphu8Ld1w4MFPpiqOs6f08ChID+k5ubvLEeW9wxgiHYzM6PW?=
 =?us-ascii?Q?YMeQwV7gvm+lKlH/ccsb5ka3J0PsQ3ZAIev0p5YEZw1cCfPNh4hlT3eCoZXY?=
 =?us-ascii?Q?EcL3qaDJB4fSx7cEPfMVpHeb4s8EKhEc6L/DnqZsV2k5ZY/ZYxU2fMfEtzYS?=
 =?us-ascii?Q?VD55ZjtSEIHySJJCFsHLGsIsIvEV9sry7/tak9nrZqebUqg2os3D/cSv3gGM?=
 =?us-ascii?Q?iFisTCbsb7vy+wZp6ZFc8SUgXQsJxCtWaV96APNi03IIFikUEqNJMLKKexK4?=
 =?us-ascii?Q?EKWNZ7h3vlz4Xy5PWszFwXqOj0lTszy5iODvRHc5I557cIXFtlmk9+/sh/ii?=
 =?us-ascii?Q?9AkTPw83I3vuJdC3b4i+xNx/V6itDJJSfK1gOfmF0Osrudes39zYuMOOUJJe?=
 =?us-ascii?Q?QGGgZM/DA1RSFAZpLQaFAIppkhWnWWVc/9wQyZkEs1gwS4vjVodkVCokdcko?=
 =?us-ascii?Q?8mzX0OvhXltYpYknYY2qRkQzf2Gwgl9ctvbtmyyNIpJx2avY+to9uxltfYfo?=
 =?us-ascii?Q?uWxLDl2TBXHQYHGMAlkmWGAMHBa4uBgX03XF6Ts5X1oQNcrmzrtab+H3yRR7?=
 =?us-ascii?Q?lqNnmlVsCN08aGUvMD4co6FN3eW1qxceINTNZnD0tO1bDiKvLepgefe8vtig?=
 =?us-ascii?Q?rV/+kq9vHFqcsO5yduC1Of5kBUxS2fREKuS1VATIQTSUJ8+sL0h9xBN1aTEg?=
 =?us-ascii?Q?qW2efSXNEiNsS06hWe1YcJNyM9Nb0UaPL5BwXiUXxmSpTbj7y2WyCbLQ5XsR?=
 =?us-ascii?Q?pSJ3oyVqrBZB54gHHSw5u7EyJrpfRWG+m396Z5i3x77JLQwsHkdzrJK7ALo2?=
 =?us-ascii?Q?5d6of85I1Ds7v1BokLvJmcCMjwpNzHjRu6l1IzqhzUVjn/Kdo8a7D23B/YVP?=
 =?us-ascii?Q?xj6q64QLWrP7Mf4U2Gp9hAc/yRk7uTw9OfIOCKap3ZpUdiAhKz2op4rv+Hwy?=
 =?us-ascii?Q?WjTBC4YonwccEdYJSI3iarBklPHwX00OvvtB/aA3ytNvuvg+xwnTeCF7NWH3?=
 =?us-ascii?Q?opWIeUXjc3yRbjRBVId3GqoKEGxqEdnM59pEgAt8+ZfYuj97w7OCkiZPC3wO?=
 =?us-ascii?Q?vfA1cTcCU/Er33TXrgngQYgiYfU12A3/D6Cects6RFoXM3k4KMkS5v7jSOtV?=
 =?us-ascii?Q?ljM9Y+fVnyMA8AWgKnEQ40FkGN69//UCV6X6Ht7Tw5f8PbIxYLjwM9A0gxoZ?=
 =?us-ascii?Q?eVsp4KudqDnm9llkaY1CDAH48BhwGX2IaZeOq2YsSl22UrhNygsRauh4A4N3?=
 =?us-ascii?Q?JdOCA1XZzjPsGe3AaG9KF6GPPJX0nSgT4zpRIKhbHrJszjCmpQPhohyRuNMw?=
 =?us-ascii?Q?DdahOBqCRk1s5NMrms5lBKRaHByZV5ODoGLnRpdYC8EB8kiDLwL0V2DkWUiH?=
 =?us-ascii?Q?a8UgihNGxLPEIjMh5qyszdAsvaYfTOSXM3tWFlCtmD8WlVdowsCG8dyLIUa0?=
 =?us-ascii?Q?svh2Fp3btfXNeqjx/cY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb09dd4-ead3-4389-b2e8-08dab06ecc4c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 18:38:34.9003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9s0RCnQAsX4O5Tgpx0yg9cPybJWdX7kGP8wCBA6DNe774/E/Q6t2DUl6APIghjoD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7161
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_spapr_pci_eeh_open/release() functions are one line wrappers
around an arch function. Just call them directly and move them into
vfio_pci_priv.h. This eliminates some weird exported symbols that don't
need to exist.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 11 +++++++++--
 drivers/vfio/pci/vfio_pci_priv.h |  1 -
 drivers/vfio/vfio_spapr_eeh.c    | 13 -------------
 include/linux/vfio.h             | 11 -----------
 4 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index badc9d828cac20..c8b8a7a03eae7e 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -27,6 +27,9 @@
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
+#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+#include <asm/eeh.h>
+#endif
 
 #include "vfio_pci_priv.h"
 
@@ -686,7 +689,9 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 		vdev->sriov_pf_core_dev->vf_token->users--;
 		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
 	}
-	vfio_spapr_pci_eeh_release(vdev->pdev);
+#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+	eeh_dev_release(vdev->pdev);
+#endif
 	vfio_pci_core_disable(vdev);
 
 	mutex_lock(&vdev->igate);
@@ -705,7 +710,9 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
 	vfio_pci_probe_mmaps(vdev);
-	vfio_spapr_pci_eeh_open(vdev->pdev);
+#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+	eeh_dev_open(vdev->pdev);
+#endif
 
 	if (vdev->sriov_pf_core_dev) {
 		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 5e4fa69aee16c1..13c0858eb5df28 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -100,5 +100,4 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 {
 	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
 }
-
 #endif
diff --git a/drivers/vfio/vfio_spapr_eeh.c b/drivers/vfio/vfio_spapr_eeh.c
index 67f55ac1d459cc..c9d102aafbcd11 100644
--- a/drivers/vfio/vfio_spapr_eeh.c
+++ b/drivers/vfio/vfio_spapr_eeh.c
@@ -15,19 +15,6 @@
 #define DRIVER_AUTHOR	"Gavin Shan, IBM Corporation"
 #define DRIVER_DESC	"VFIO IOMMU SPAPR EEH"
 
-/* We might build address mapping here for "fast" path later */
-void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
-{
-	eeh_dev_open(pdev);
-}
-EXPORT_SYMBOL_GPL(vfio_spapr_pci_eeh_open);
-
-void vfio_spapr_pci_eeh_release(struct pci_dev *pdev)
-{
-	eeh_dev_release(pdev);
-}
-EXPORT_SYMBOL_GPL(vfio_spapr_pci_eeh_release);
-
 long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 				unsigned int cmd, unsigned long arg)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e7cebeb875dd1a..e8a5a9cdb9067f 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -231,21 +231,10 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr,
 				       int num_irqs, int max_irq_type,
 				       size_t *data_size);
 
-struct pci_dev;
 #if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
-void vfio_spapr_pci_eeh_open(struct pci_dev *pdev);
-void vfio_spapr_pci_eeh_release(struct pci_dev *pdev);
 long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group, unsigned int cmd,
 				unsigned long arg);
 #else
-static inline void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
-{
-}
-
-static inline void vfio_spapr_pci_eeh_release(struct pci_dev *pdev)
-{
-}
-
 static inline long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 					      unsigned int cmd,
 					      unsigned long arg)
-- 
2.38.0

