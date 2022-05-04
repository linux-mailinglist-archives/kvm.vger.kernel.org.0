Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9A851AD6A
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343627AbiEDTFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357086AbiEDTF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:05:29 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2089.outbound.protection.outlook.com [40.107.212.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD9C2DAA7
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:01:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dak6m6w33XvOG+Xd4CJEnS5p4yikBlbQMKKxAs+Tdap654u3v5EFtO9IltrgoLXY2f1SOdCaAUapR/2sWxstFvKf9uhNyIhODps4LUEWyFsadDAR+c1F1IJfJAmkTxSUjVBds0OGp+cu8tQci+IDSfqAatXcs0ms5pZvSLjfgVqtUl26e2q//C2VvLVMwtV1zGllxlwg2ExlNOxi0F2Fv48vsx68rtXE6K0ZrukzSxfOjK8XD+CHxc9/ySf6i5QlNIGs2HwweJGqjZK8LMiBKEAcizvAOJqIMicusl+8cR81xqvbixqh/R8bY9aqmN0kimRmCVLqrlsCoPY5oUjrOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MM8MDHhriYOQBQ1eZG9bIyFbYzct4JVsR1Fc5AUzHes=;
 b=cpLo7RpFIn5uP2LVQXLP5aqrB1M8GFf8gPvR1zlngX+M6SueYLkfHGsunb4OfyZhtdGDvQL7RLTVEm/JOjT/YnXGbNhdm87swTFm+sejRHOviZ1kJg0KDhGOCFaE3tFQ1FcVLP82bBFLoDCqq+MRGeqbobZrTeYm/pJICBv3yx7w3/yRcftiHeV1gofUrWwjudFrJ29y/4WxohFV+bRZ5SlilQh27af9mQ8yosyHNQwiW1hn0QEK+zv/5RMrvM9zIEkxMjxjxqm9KJsuewJCkKdj534y3izLfF8BwAlIQPpIOk6unkoDiRd9qvc2QWzqIgLlKGCQEz1T82NkdmBAmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MM8MDHhriYOQBQ1eZG9bIyFbYzct4JVsR1Fc5AUzHes=;
 b=WN58bS8I+5Jaiid58+Ws/r3EDT/UfGyx7aTKwbBQeUVoAdZ+tGoKSP5MXl9t3JNS9CDg900L8RrTwYvmhHUoZViCA6ket3OdSwelkmDZDaIHEfJILhwmJu25Is21nbSI1Za1IdX2DUcOlgPnytV7CTz5wpt3m+LAJMGjevuJ4Wkp60JBQ3xwQy4EmCLslDeejwlmmxJ4A9bYHY/6piCJgp/ZC7B7UNTMLf+lGkwj28/mYyufrFi8Gc39FEUvoYTd15AH4Vl2DRb4gmGqPj7BVA/xl23P9hAZkFVWBCzLi7Zkw4H04Y0CkQAGXnDcFZKs0q6JPqzygEjRPFm2xv0ONQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 19:01:50 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 19:01:50 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH v3 1/2] vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in drvdata
Date:   Wed,  4 May 2022 16:01:47 -0300
Message-Id: <1-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
In-Reply-To: <0-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0103.namprd02.prod.outlook.com
 (2603:10b6:208:51::44) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de4eb91e-9f55-4f5a-8718-08da2e008b23
X-MS-TrafficTypeDiagnostic: MN2PR12MB4270:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4270664EEDF4BEA9BB411574C2C39@MN2PR12MB4270.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VzvjEvVQpyXoCw0OeoyNeoA2DxFQRMhnnEwayl0RwkQmMwkpiCAWs4h4v/GdwYR3zgeMf1zFYCHhcQsW3NbqKQLtDcH8wwagRWGNMZh8ztG99xpCy8M+ni+eVLVJqvWkHFZ3jxZUgXLN87HlI3UNeXTJIlN8fZolNIt8HSSO5Jqd3R75KacjyHsX0jYRBy4BaOS/GsiCXAzbO0Xg2VXV5Rq5focHfy1vhgnX0dOw1Z/q+sf1Dpg6lFlNvI5fWif3HexQrVdCfz+mwxJHFWL480koTUZjpg6LnfX/ff0za0thrVlml0PKcJMZ/Gg2y9mVqo6AM4Qbzoa3hjqA+Qh5kTgg+7moGUtLaDJrY+vpGIPoxs6hiIJd3ixmjpST5UnMAFtO9yuyCcoxZ/ONg6lIrdBTaINdJD1+PFogGC61HrmhN7WVwkmZVmMADrbS2bxDR6LST8rLgSKItUfXJ8R5d0BkVo7GKoHLOvsCYKR0aH+ydWWJW48ZAfdLDApkC6AFXiGeoA9UpDyT3jxl+/ZMO64s4pX1GD/W5jVcRtdPRNyJBmYhhOk09D6HnDoXwU6tLE5ZAcO/X8QJA1oMy+OQxbMIxyDCiOA8elx2nILiHh5cRtQ5LBGlgjYJlZECraMAAtb3TI0bESx81sP6Jcthzp7YaiC1cOCGQQg/CRhW/S4atQAEim9ID+39lryCgf8taeiNW6EsWwEJYITJLcs3ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6666004)(36756003)(6506007)(8676002)(508600001)(6486002)(26005)(38100700002)(66946007)(4326008)(6512007)(66476007)(66556008)(86362001)(107886003)(8936002)(316002)(5660300002)(186003)(6636002)(110136005)(83380400001)(2616005)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jIrY/kOskog9dUCxKXZRn6HdtacI3J3eV3+c2FMxM2o/vBtTK88JEydSJVWh?=
 =?us-ascii?Q?8WBI2Yi76mjP/eWpqb3+z1PU7Z7GT+azhV7m2Le3G9oBdVv3MO8MG/ppcpyb?=
 =?us-ascii?Q?6iy/wT/xeux8d4qE4hxTDViquz14dsN0ktmsG4D3eEdIdOBkREQWs1nD3hCZ?=
 =?us-ascii?Q?D27/LAqkE4818NPV9puu5Tb0C3aXKF4UDGuyx7DrmVyHbyOijJ2+JgvmiANl?=
 =?us-ascii?Q?IS9NwVSU9QVi+FlAHFp7q5dwWImOLEsiRU+6VczEgezjDhM0Kg4Abpc6qfxr?=
 =?us-ascii?Q?yHXRWZZIsOww6uN1+hPL0HrnS+EpwbQ8NLA8DpFqVOOydLqqMBAv7u/ORuqx?=
 =?us-ascii?Q?7ba5R+hGGOrALsoFntxPPiVWFTPRuJ/qb0hs8pWvfRQD6qgnguoioFe8EPU5?=
 =?us-ascii?Q?4s77lNAwHlrgzEFf+C7lRrPZiemTw4HB2FWyfdU2QZCF/TpOSOs9t9DOe1IT?=
 =?us-ascii?Q?MXRMpV7felm7pzmrbS4I0XXlcB+xCW1Bgync68xMbqnhILbl+tDZE9EdQ3oQ?=
 =?us-ascii?Q?cYZKB+77RYBs8/gY0l016GdX8Jq1Vk2gswd05gl8kIN7cKLTVZYaKV7Drkhv?=
 =?us-ascii?Q?2SKB9flfH8vpammI8dX3Py2m3w7Lay6PPpBJ4SG1vNV28WcEIzAXdefP+dVl?=
 =?us-ascii?Q?LIfrw/Cfuqt9jq78wSXiXPvPQRe5dx/PLsBf9ZHeD3clawhpDDXQ4BhEDgW6?=
 =?us-ascii?Q?MmW5R0vtjC/4QDJhmlqe4kLlT9yWUV2eVNJa/F/MAygOGncqT12kzRz92js5?=
 =?us-ascii?Q?1YZkv4bCqN0yyDBXJbD5jRR6FKpZmZIJ29yNOpzb2MSxUJzZQIUJhIPkwFBe?=
 =?us-ascii?Q?OyxUTHykFB0ykQf1xrMzFiShDnqG3ebHmxgUeyJbahDZ12J5q5EeJ7xxPsK9?=
 =?us-ascii?Q?mLAKYPqfVK3ko6tVvOuP01/m9WaiDJz58b+GhVzH5H3aKTwFZWTm6YekbIqc?=
 =?us-ascii?Q?v1k9spRVxDLRJJ0Jp3f/cEL4VyC5hPgKg3UmhJJXyXumj/1K5wR5YU8FyyyE?=
 =?us-ascii?Q?hnEEOEQTqPhJ6dcBI+Z3Ilhfk/Q9eP1OGyk9Z6IsZ0HU8aNLjS2g343k20T/?=
 =?us-ascii?Q?eu4PRHOzi9ke4HWOVIIlMsJ0mQOmA3/RKFuqvkz600gWI/fLmxtBn0C1afNB?=
 =?us-ascii?Q?ISat0EEOQA3RJ5X2zjPa9fmUWRcx8Vh+IFWRr2/SD7wk5Zx/3SvN3Yc5VZ8d?=
 =?us-ascii?Q?3rffPxlkbzIB1llVBVg2tvk8eUf7+e3qLDqOfkiWtILgtmMN8DOQqRIJntAD?=
 =?us-ascii?Q?7cmuSuyDnCCvwOBTbqsLrKBjTLONHYuKpig20Jf2A8fyiDcXuJguurWBIUAG?=
 =?us-ascii?Q?7dAK9ODRX2aH4/BDAiCQe9uKIYf8jeOD7vEGygByVrKCawK3kYqTedAVIiH7?=
 =?us-ascii?Q?DOKMP3J79Y8xgQPg9icYYtmp8jECjxXpdMeRGtcosgTwsYOyvWAd66R9RTFr?=
 =?us-ascii?Q?s+6f1eZRAGB3vz5buqFwPfZasE7fLZIuxmxWeAGdLTRxyePFpm9Pwq39AsLG?=
 =?us-ascii?Q?bqC8zVQD0tJYERRQ8qlkESvvpQF0VwXj0G08Q1xj8N5KALeLqIvaCEniwN3v?=
 =?us-ascii?Q?rSRTz/Y945eape11blSoSf3sTJJ7+cK8RVPYdbGwTwXP0iwOlMoGZ+KsDAqB?=
 =?us-ascii?Q?KzrC7gtI7k0fSzsqkxnaCYb830sS/IAm27UjSHxI+LaBrFuDchEbS/CeLVUU?=
 =?us-ascii?Q?xIOJSww9aszdCgaVDA7T65oidPFPRf2DY+RnlSgwdlIMycf91+FcHYUpkrEx?=
 =?us-ascii?Q?2XXx1acCvg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de4eb91e-9f55-4f5a-8718-08da2e008b23
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 19:01:50.1053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aqPMRrVxUjZ6uk96iQv0t9x4k+ZXpwn2z+iMrBIffRpSp764rsthmjtaJfaM1ZSl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Having a consistent pointer in the drvdata will allow the next patch to
make use of the drvdata from some of the core code helpers.

Use a WARN_ON inside vfio_pci_core_enable() to detect drivers that miss
this.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 14 +++++++++++---
 drivers/vfio/pci/mlx5/main.c                   | 14 +++++++++++---
 drivers/vfio/pci/vfio_pci_core.c               |  4 ++++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 767b5d47631a49..665691967a030c 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -337,6 +337,14 @@ static int vf_qm_cache_wb(struct hisi_qm *qm)
 	return 0;
 }
 
+static struct hisi_acc_vf_core_device *hssi_acc_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct hisi_acc_vf_core_device,
+			    core_device);
+}
+
 static void vf_qm_fun_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 			    struct hisi_qm *qm)
 {
@@ -962,7 +970,7 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
 
 static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
 
 	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
 				VFIO_MIGRATION_STOP_COPY)
@@ -1278,7 +1286,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 	if (ret)
 		goto out_free;
 
-	dev_set_drvdata(&pdev->dev, hisi_acc_vdev);
+	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
 	return 0;
 
 out_free:
@@ -1289,7 +1297,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 
 static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
 	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index bbec5d288fee97..3391f965abd9f0 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -39,6 +39,14 @@ struct mlx5vf_pci_core_device {
 	struct mlx5_vf_migration_file *saving_migf;
 };
 
+static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct mlx5vf_pci_core_device,
+			    core_device);
+}
+
 static struct page *
 mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
 			  unsigned long offset)
@@ -505,7 +513,7 @@ static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
 
 static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
 {
-	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
 
 	if (!mvdev->migrate_cap)
 		return;
@@ -618,7 +626,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto out_free;
 
-	dev_set_drvdata(&pdev->dev, mvdev);
+	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
 	return 0;
 
 out_free:
@@ -629,7 +637,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 
 static void mlx5vf_pci_remove(struct pci_dev *pdev)
 {
-	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&mvdev->core_device);
 	vfio_pci_core_uninit_device(&mvdev->core_device);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 06b6f3594a1316..53ad39d617653d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -262,6 +262,10 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	u16 cmd;
 	u8 msix_pos;
 
+	/* Drivers must set the vfio_pci_core_device to their drvdata */
+	if (WARN_ON(vdev != dev_get_drvdata(&vdev->pdev->dev)))
+		return -EINVAL;
+
 	vfio_pci_set_power_state(vdev, PCI_D0);
 
 	/* Don't allow our initial saved state to include busmaster */
-- 
2.36.0

