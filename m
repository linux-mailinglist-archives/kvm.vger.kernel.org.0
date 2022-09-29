Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCE75EF848
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 17:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbiI2PFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 11:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235415AbiI2PFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 11:05:13 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE75758B7E
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:05:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dS1Qogbax0aZrrxr+7R3TOsvgcGeKs9HhkRkrGqqOR5uWS0A7P55ydAF1IpurpOaBk+jOQMnR6e2JVxG1/6hgJhaSPyNI+KGoV9iz5pFJi60vAIPY0IIn6FkRYPfK8U9NaZ2qbZB+XXuihMDMjNui8SWVjhcFaHt0X4j+l4lLm5YsUBigANJICKbTlWgRa/DlZ7kS/BbzTEgb06wqT/jJdFrjlJfOUcjtIKF535Jvm57UlQd1zRIT4YMgl9rsGSUM7mqNWaekrrAsvd1qq8mZV3TZ6LT4wgsHN/8B0/+A46KYUOMAueuP06SauUedfuxcnq87u7WtJyc4ww7QkRIDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aO9XhXJ8gvwOHJILQIXTLfZHlxeRa88Ch43D8LgAtlU=;
 b=ZkRYOnHtEAT2ybCPRdSQFslwhUZKm+btyeIGQ/v3oUJB1cmy6pn2grJYGjNzS8CL+pssyVdbrW+51smPao3rar2DopqihabS1A0EGkG2LPJ6gsU7jkNGuF8dqgp+ArUeSbUVIu3nN9h8TxL2ZSlGUP3dC4gTwZ7m8jWnDrz/2ENvbrT4Bbe16qwafKZMVm8Ml0mdyF1gGxxFFk1HhtIF8XRO8JqXe9wpC3zxo/0NgvB505BfS9naOaD5XmDqJ/8jq+IV/t8oOGScH+5P8ccy+E5Ihqvs33lzfzS0YuwXHJh4khVNKyBYTaLLuRX0GT7NdLcYLCL1i//AnJ1wNhHp6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aO9XhXJ8gvwOHJILQIXTLfZHlxeRa88Ch43D8LgAtlU=;
 b=uPTwzyupdyyv+lNEFAqaZmx1S/ELgWov/iLg8c65GHbJWOx6cX1FWAmCYf8TJM1Q05mMKUtnEGUbXg+X2trJz71ovT+e/pHylacCt2UTUU4IUMob/g/CULBNYwqB5WVKdX0AImdUSqmv7uVQ5c6ve0L5kgL0PZ7VsI+vGXi8VmzfMq+IzJfaTLjEBJQiurVeb3ZEmrz46luGhUj9/xv+daIgGACny/8vA3l9vPxkEiAxj1r7DfbZ2at06mFACAIEbDS4DzrOMR5O4eDrlrX/0U8k6ZeAAvj/44iW/rTD2A9U2+HsohTckjCAbT/8AK4AufFw21BxaoMUeOQoyT+uoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH0PR12MB5645.namprd12.prod.outlook.com (2603:10b6:510:140::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Thu, 29 Sep
 2022 15:05:01 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c%5]) with mapi id 15.20.5676.019; Thu, 29 Sep 2022
 15:05:01 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 1/4] vfio/pci: Move all the SPAPR PCI specific logic to vfio_pci_core.ko
Date:   Thu, 29 Sep 2022 12:04:55 -0300
Message-Id: <1-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0003.namprd20.prod.outlook.com
 (2603:10b6:208:e8::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|PH0PR12MB5645:EE_
X-MS-Office365-Filtering-Correlation-Id: b4ab48da-355c-426a-a7c5-08daa22bfb36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D9+DJdsypA+SXQMeNc17hfJuawquNiFYRBK7AaKHW+pPpiQHYbsb5GBJMwx1JBlFjS4JH7FPTvP0Vxpnx9XT84/y0H0psVwQ1eIOLsdR0HyP96RYj2ZMhX3YkEF6v6uT32RdGZlN0bx28QmW3OWtKEQlpDRDAi52/O/rV+crwTl7xszUZHzEFHrUTWXb6O50J9JIhw8qCtpawrU9VD0g3SCeWv3HOoi8DoS7TL/uOAiU7yR6fKOUqAaeP8OQFv8exYpImLwAYl95AYPuvuVr2BEE9lL3r09uI5Z7GYR8axQqH6q4vnuVeFAtXLxUZVICVP/TJYmi1DB0MPHdved7AEg1zyVctbo52aVe68t3626Qdm6gF+G+QH5DtBxkbJhA7dIVwEItF5osdsoJpJpi6FvNnLlN1Ve9ZZ21Tsk/vHCBG1831ZSo82FV7Cyee/As8a7GFuegd/Ixfh2gbH79dw+RzNZu/YlG3QCPCRPGAbeTWUJHsCv2pBv0zypvZTSmU2oG/w0Lq7R6FtXIuNAd2GAyCxvdpV1OjlmCDNG6XvQ8zmN3oB6I0iM04I9LUEQr4+P8WCAiNajU//S7MKGF3x6xamgSMpiOS0HXUslJqx6UVfFNCfYvvUbkJdVCQvMYUCVk7R93vzB5pE/4plm3ayqaa60OdMXPLrdkFSGizkskVqOFV20TCTRyFZuIOv/6UzZ/i44A7tP39OYptpUbzZuedw38BOy9DHGoM8obmU3hlt73E+bOfM1MG3MOBfwO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(8676002)(83380400001)(186003)(38100700002)(2616005)(6512007)(2906002)(41300700001)(8936002)(5660300002)(6486002)(478600001)(26005)(6506007)(6666004)(66476007)(66556008)(316002)(66946007)(110136005)(36756003)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?exK4I5mE/PVWpcJVtuqlb9WX/9trotgH7bBluwISp3TwioQgX3Z9oco1EUAJ?=
 =?us-ascii?Q?52zBlpOXS805psstVzvHraAto7QQjjOBzoSQf9ZbibCSm+Sh1imKY0ttuw6+?=
 =?us-ascii?Q?OyK0JGeOpScnDcgyo/6YNXcJyDKk64KLFvxNjRYnHkOLuVZKFR2wVYSEJ0em?=
 =?us-ascii?Q?c/2inkwWnGGWeh7WIHWyy0GNoVHWtnfltG52iC951TcWh1lKuDp+VF2U1aP0?=
 =?us-ascii?Q?Nqnw/zw0lk2ew2shDA2ioFPDUg8JN7VOgptBgPe3u7FT45Zz391LKUBO3H9Z?=
 =?us-ascii?Q?wgee9QvP6Qdw3Uy8zEct3aBZo1Rtt4/x6A956c71lwf0w2fMFitH9+fwPSIE?=
 =?us-ascii?Q?+8sLL5Kc2Mbe/A79qwHGosM45CLIdfQdHYn46uY3yjgrcrLPP/LpA2mYPpT0?=
 =?us-ascii?Q?U3q+csa0zg8MPsCVRtPmyIVASu2tWCxpZY3iOIQzm8YYp9U3O0kp8Z+rTSPR?=
 =?us-ascii?Q?/PPHf4GfbZc1JGjJ2JsdYrj1WCM3nxo4HkG/RoAZtSm84MNw7QkYdwJcT9mL?=
 =?us-ascii?Q?5TSYkqI92wRo2JCLcOEM2hJTeOUgZ5K5YENgsgmu7tTONN4YSXZ34eMbTMiW?=
 =?us-ascii?Q?p3MUIz2OBn57PLwOQStSBNMzMtk35C3KRe+9HHZ5GHK2gam8MqhJK3mH1k7u?=
 =?us-ascii?Q?wpoNgRc/w/b98EhNVZm2CsS5Ik/KGaY38DCDudl99wOAHE8PrAQICaBatuSF?=
 =?us-ascii?Q?VcfX4zv9Sn7X/oDqo0kUvLTcctv/9Em7HM11kohuwMUo3Hu2AeZtSxScZITv?=
 =?us-ascii?Q?suTv+6YBuu+QuvDoipcXzAJVCfM8XWPLCT8lP8lQRXpnVxMvAs9pFqqZLloj?=
 =?us-ascii?Q?jiatrnlRq/Pv7JC1WP5YeSZ+mCK24+xeOnlrNd9jTVGf+bEHbT2zmVla47jE?=
 =?us-ascii?Q?JDcwq826BT4Xk6YlzlZm9UgFubt9qwZ1X7/6KoeYgM3b6DXWMCc3cWkGsxKw?=
 =?us-ascii?Q?R1H7OSCInNbWsqGppKPbL5eCDDosR7YasOdENyixd50xx0p06FYgjF59rbBQ?=
 =?us-ascii?Q?kNl6fGBR2parKZujsyVcOSnKFtQEZb2PTygQr3FSVe1U2VEDz++JC0sRFN36?=
 =?us-ascii?Q?e93ISPilosi9K9uzaFZUwW13vTjxQUsXeHzxjj2SQ3I8DilQFsIjlhpyKtJ+?=
 =?us-ascii?Q?LiS94rthIM5QQ5P6mU8YToIBLG+0NKLJxrEmI1C10PlKsuFLrgEhXYMkz6K1?=
 =?us-ascii?Q?CmJqi6Yng9jY1IzUZSft+jNYlUBztLN/PuIcm88s1ZLsG1tXenfDZdEHlm82?=
 =?us-ascii?Q?LJvd/MoeV+WncJt7cuTFJ7A7Nz6tCIWIHVBnYyRjq+ULKOMkcD3r7BsN19NY?=
 =?us-ascii?Q?ZxIxznaptY6MMelUCYdrhb4GwDCpS4rqAIlX1g9KbKeEpmTREIsZ8rpM7nUk?=
 =?us-ascii?Q?U8ld547zFM5MkvIqIItP2ZGtuwrxJJr+pMXqXEmXv/EtwnlcjdBfWu/hO3i8?=
 =?us-ascii?Q?3mIANBHfJRVbSBZ8viClFIBh4riHTNovFX6MWwL5/rKDjn4+i7vPwQaEr8pf?=
 =?us-ascii?Q?3oZk2iNjqijS5WQnIzEhg33NgKYA5aHHCLu/HsfszTgXjyTl1oWabqWHN+nb?=
 =?us-ascii?Q?VHOT+OJKhApGRAc2/Ps=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4ab48da-355c-426a-a7c5-08daa22bfb36
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 15:05:00.9709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJ6MlZFO9O1unN7ccBJo5kBNqDR5I6j75GBvic+Vzmq4gDnhDBEHMDaYV1Kdnsmw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5645
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_spapr_pci_eeh_open/release() functions are one line wrappers
around an arch function. Just make them static inline and move them into
vfio_pci_priv.h. This eliminates some weird exported symbols that don't
need to exist.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_priv.h | 21 +++++++++++++++++++++
 drivers/vfio/vfio_spapr_eeh.c    | 13 -------------
 include/linux/vfio.h             | 11 -----------
 3 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 5e4fa69aee16c1..24d93b2ac9f52b 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -101,4 +101,25 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
 }
 
+#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+#include <asm/eeh.h>
+static inline void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
+{
+	eeh_dev_open(pdev);
+}
+
+static inline void vfio_spapr_pci_eeh_release(struct pci_dev *pdev)
+{
+	eeh_dev_release(pdev);
+}
+#else
+static inline void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
+{
+}
+
+static inline void vfio_spapr_pci_eeh_release(struct pci_dev *pdev)
+{
+}
+#endif
+
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
index ee399a768070d0..b0557e46b777a2 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -230,21 +230,10 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr,
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
2.37.3

