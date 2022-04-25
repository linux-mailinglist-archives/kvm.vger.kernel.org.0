Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80ECE50EC64
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 01:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbiDYXER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 19:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbiDYXEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 19:04:15 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B118E3FBFE
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 16:01:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7tBagZRcPmWaAjc0Grtg8tnC5XKXB+VbnUUF0jMK9QzRHH7X628OWk7RxczaJQYOqS57vHh96/JEjdecG+ZMne1sh/MG/l///ZHZFAC4IMkO8TkEhpJXppfbbNhwhwXxBQpe3QkP5uoa3FZbG6V0+XXljnKjLjICNmRQ4gMa5UOeS/lxW7An0xpoyj8lqbyYMyFghE3RxFtjpJghBr12NarDHdVInoJbjBqZXcDZjPEy8t4d56m/GbNfoD9WUeRBVkvM0/3puRf5iX/PFsFAk4iY3uy8KAJjD3UX7XEtbSZoZ0BqqIadtOXJlLHktcS2FaU+MqCdHqAjrYEasGt5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lizNeie3zOHmArkx0hSmwjMh3dHMCWT41TJ6Iwgu0GQ=;
 b=JoajWHJ13r9c3HeeVvlxSfjRCJU5FFDGP0DwBOXzmj4gS+pLa27lmx3+FqCDGIOyLjPeBobonewJyCcLFsr75Wvap5FEZaeUdREjbBIDm/OpSizBLKTnEbyPGcCFGHHGdhiO0YkcSi4rbFlPyGIERZbR2/x1SgMcOiszBOSnEia7WB07IDZ9y5D60caH32nSnOlK5aIROZwBs9hj09aos3l6/uwbAXE9nh9/Oz9XeKHO+5aX7InohDONpOePEwOg+b28cOWb2c3dIrh3BQpZ1aOiZ39aGo1tGwLXhwVifmzLY+avmHfYCclIDgVAo3kV4FfGjvyWXWVTrId2sb5HMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lizNeie3zOHmArkx0hSmwjMh3dHMCWT41TJ6Iwgu0GQ=;
 b=KGygtrnAczCq7tkuvRefj+V4CeXyRFOF59Q8DoKxmjStZew8zGGK2zNRI5ubRIfL3HzSKGT3D/0X4cOZ3UA/x/mNj6JTzhgeh2ppbZqZFYLZMSLk+iJPsYSPmyT5vlHZNH19EVX1XX1bb3hVBQl8Zqo9KHhDclpyJevQvduAndtBvlYijv0bcrL3jeoQFpNBGfkkYocCbHE60toYKwM4IWxM5zOW0wkh7Dn22OUKExrs2D8FEKolr+A3uP1W+x+7spFM5fTOFmZPSlP9ySVgUJeRwLN3eodS3Dkhdm7xI2Akg1SYaRaUonebSU38CTsLCyudkgzrPt+wAvwX0P8wCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4503.namprd12.prod.outlook.com (2603:10b6:208:264::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 23:01:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 23:01:07 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH] vfio/pci: Remove vfio_device_get_from_dev()
Date:   Mon, 25 Apr 2022 20:01:06 -0300
Message-Id: <0-v1-7f2292e6b2ba+44839-vfio_get_from_dev_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0008.namprd16.prod.outlook.com
 (2603:10b6:208:134::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6a32acc-3714-41b1-134e-08da270f7b7e
X-MS-TrafficTypeDiagnostic: MN2PR12MB4503:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4503AD3E514F391B91C1BB1EC2F89@MN2PR12MB4503.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZVH6wQq75R6gUfvXyQwh7zOtkAbBi1I5engZHl9q3qUtIchOEd5F0E2nQ5iflg9KGmfw4qm3Fy42Cic+I4ID4HwmOySYD/+r/5QtsynewhsEN6oK8s1sohNxTAcc45T7u/kc+jOVABxGxj9gH+wtCxe21pIFuhOlwVq0UlsMYj5QMvbSuxPBLhpkKiZIgUzaq1hKimNkY09iwhKA9gHeV5m9Ca11/LIeQnbYHjb5k2zl66jPy+vjF1VATgo0NHQi6OxDwqZfuCx3a+L2g+QQ3wyM1dDDo9D2NXmb4yBpb1b3FWPuS1H0+YMjVmvHRBWcDTMxJ3uVMzAI8x+LL0Es160lyZRmVohFMYb7P1TjALmbs5X5wo+/EFznBO0Hi4Mv6KfjnnrmGjuTcyyyTa2CVy1bTkgtgiGTMw3JmWia/V/oRyJR+AyaBx1zLvXLp+R9k6Am7wconEyzoTTsaBac2u7jNr/pfaqk1/jmFfTuHyLvQosAXNSFb5UT1ufV2nj6L81aYKZOFWIxowDZmER/VNIpHNcQe4OWFw8QA4oAMb/vkFoKxLcGxPVs68VjQXFjsj6ZnMIM+Jx87CqAdQeajlUB/QWoe7OtUzUwpP/307Y4l2Hso6Q9LRjivQrwIyjcmjeMPIp8bpSrHqA4UjNlC/2/+/trfPaG54h5+o9WdX/hZJNaFcXg854f0fFOt8v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(86362001)(2616005)(6512007)(38100700002)(26005)(6506007)(6486002)(2906002)(83380400001)(66476007)(66556008)(8676002)(8936002)(508600001)(66946007)(36756003)(316002)(186003)(110136005)(6636002)(5660300002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X+X4qHPKPHuq5MigTirImsyv6LSIbrJFQ7hiqmIA6PKHKqiPwphpPeR0R3ZY?=
 =?us-ascii?Q?nPmVec3Jv0zQ5i0kk1ul0m11FQ0MF03O8llx3RsNjVHerVhvvRCsl1zbQlyM?=
 =?us-ascii?Q?UU9uizcaraNZKFv+0NK2krhbIWzqgTLONVzhagWJ1IY1wNPdsfLs3vKVW7dl?=
 =?us-ascii?Q?Z4E28EbKkTnniYU8JqAJ0dL4FqXZeH0pQi7hhjk0o6OzurJco7dVkr6Ouyzu?=
 =?us-ascii?Q?OkBnf90FhefRpRfeuL7WupJd4ihcUNefEsHtvLm+HGPYlu1beMapLirBt9vU?=
 =?us-ascii?Q?BDYD/e+lqVn2IJP/cFjAGIw5E/ff7Lj4krrcO3Ua+abCCQr1/ukJhrGzBzte?=
 =?us-ascii?Q?OXtvT/3I3K0KvNLf1QaQR/SLp8PrjqUvBaA7jcKysMhrzUVI47I6dXUB1V/n?=
 =?us-ascii?Q?5oFwo1TaFcoQJGsi/StVbFqdkEGTf2nGrGnFyWl4JiVvue6k+D3Km1hlFirE?=
 =?us-ascii?Q?kSyeX1iW0WzYBMcT0Tzpx8GyUMId+YMre7BGbD1g9NDuxmfCr2dvPe/0IXkd?=
 =?us-ascii?Q?WiXX6z7MbeBevqNNyTIS6tNK85onWl4THHWH5VR6lZK/0hlIkN2g2WSN81oe?=
 =?us-ascii?Q?gcNoAFUU7TWaOfHhIO86U1SyvH+7kJl8ALwPayciyEO99P+QZwIwAo7hcoIs?=
 =?us-ascii?Q?It58WTOcDWATrD76bjcZmP4+fgDD5aUr9OJkkILbGGYru+ssNupWjDJI2/xh?=
 =?us-ascii?Q?N5YTd7EUR9zpypJI2Q5WNR6IeO/FoqqYGKQsuuj/YMhif5bqbi6NwOMg88HV?=
 =?us-ascii?Q?AHRN6UKncJkQmhQXJ/yPfsUn8QKtca0gW3TbEXLeN0zCnzkB0qIzLAKKu7Ex?=
 =?us-ascii?Q?914sQI2ApiQt+9dZK7DFMBd5FlQV0tk0i8hkcGZn1KIiAFuqvZuvA+ofVSqz?=
 =?us-ascii?Q?LYLDmM6PgD218Oyi4zpy6RXTtm3SC7GLitbNTj5vgzcZtDsloLBMuuKKQYN6?=
 =?us-ascii?Q?0Ch3Kmi7PF14ffMwnbuyx0HkGh+sQhIxIxOew3qt9mIKl4FruK/QpeD1CL69?=
 =?us-ascii?Q?cVCaYgGIOKrO19baX0SETZmSY8FT82BxBK/AD8Q9K+RnE7W0OQtDygYcRket?=
 =?us-ascii?Q?cz2lH+rrwQAsOmX7hlhYvaVneVuxzqoXPdv+a0LiSO34ZpjClObqmMJNVsFN?=
 =?us-ascii?Q?bq/MdYdGC0mAfonn+UM12Jei77M3mXh6HDjBRigtYre16BiU4vauf8PRo5Gg?=
 =?us-ascii?Q?eM61JjW56p6fXPI5J7rb709A3rPUG5vyWF1HL3rlax/JM4EYElpQCwRjn/LR?=
 =?us-ascii?Q?a0zSG+A9UuMRdyq5iOgC3/BOAI3feNpeEZXuqfQ3egcBC2xWfQbuN20VelKa?=
 =?us-ascii?Q?ykX3b+ztGwhSTCEr/E67y3Tzv4zmywui2GW6qpccPaTxdRzZarsmKrtflSdN?=
 =?us-ascii?Q?ITu3AEcGkw+3QAh8chpKXX+HdxAvcf8pxp0NRYkUZpcypfq6LEpDcDsJYA7J?=
 =?us-ascii?Q?1I6LL1SuokHefQjrGSOq2YdjH21JffRq2WPJJ1xrtDkdpLglCmAt5vr1Y3Bg?=
 =?us-ascii?Q?Fa7sxBW1EwrTvB+zBoFv5ovZlSq4sSlqizYAorlwClHnacNcvT+7iPMmeTzz?=
 =?us-ascii?Q?sUPt6eHcQvGxeyJNFs3NyjLtim3IPiHcKfeARXm4l5e1RobHYO6EvXMrP0uJ?=
 =?us-ascii?Q?w52pwY6Hxj5AVK3qY1PCx7MCUngWXZZ2CIUuFDCFHg+moaeGs+OOPuEAyfFD?=
 =?us-ascii?Q?P/YVQgUBsVRnacb4j7FM915Jnzg5wPDzm5TbGoXx5F+GdWeRQ3ySejVsxyP4?=
 =?us-ascii?Q?I75BI3VykQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a32acc-3714-41b1-134e-08da270f7b7e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 23:01:07.7605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZp1HVMW4wGn2uxptuZtNVmUg8OEpyAiCUGdQPqzUgmmqLvK2slZ5UCSKOHN0JS6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4503
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The last user of this function is in PCI callbacks that want to convert
their struct pci_dev to a vfio_device. Instead of searching use the
vfio_device available trivially through the drvdata.

When a callback in the device_driver is called, the caller must hold the
device_lock() on dev. The purpose of the device_lock is to prevent
remove() from being called (see __device_release_driver), and allow the
driver to safely interact with its drvdata without races.

The PCI core correctly follows this and holds the device_lock() when
calling error_detected (see report_error_detected) and
sriov_configure (see sriov_numvfs_store).

Further, since the drvdata holds a positive refcount on the vfio_device
any access of the drvdata, under the driver_lock, from a driver callback
needs no further protection or refcounting.

Thus the remark in the vfio_device_get_from_dev() comment does not apply
here, VFIO PCI drivers all call vfio_unregister_group_dev() from their
remove callbacks under the driver lock and cannot race with the remaining
callers.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 12 +++++-
 drivers/vfio/pci/mlx5/main.c                  | 10 ++++-
 drivers/vfio/pci/vfio_pci.c                   | 18 +++++++-
 drivers/vfio/pci/vfio_pci_core.c              | 42 ++++---------------
 drivers/vfio/vfio.c                           | 26 +-----------
 include/linux/vfio.h                          |  2 -
 include/linux/vfio_pci_core.h                 |  9 ++--
 7 files changed, 50 insertions(+), 69 deletions(-)

This depends on the gvt rework from Christoph.

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 767b5d47631a49..14bf85ff6cbe96 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1305,9 +1305,19 @@ static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
 
+static pci_ers_result_t hisi_acc_aer_err_detected(struct pci_dev *pdev,
+						  pci_channel_state_t state)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev =
+		dev_get_drvdata(&pdev->dev);
+
+	return vfio_pci_core_aer_err_detected(&hisi_acc_vdev->core_device,
+					      state);
+}
+
 static const struct pci_error_handlers hisi_acc_vf_err_handlers = {
 	.reset_done = hisi_acc_vf_pci_aer_reset_done,
-	.error_detected = vfio_pci_core_aer_err_detected,
+	.error_detected = hisi_acc_aer_err_detected,
 };
 
 static struct pci_driver hisi_acc_vfio_pci_driver = {
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index bbec5d288fee97..fbba1d52a4cf64 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -643,9 +643,17 @@ static const struct pci_device_id mlx5vf_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, mlx5vf_pci_table);
 
+static pci_ers_result_t mlx5vf_pci_aer_err_detected(struct pci_dev *pdev,
+						    pci_channel_state_t state)
+{
+	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+
+	return vfio_pci_core_aer_err_detected(&mvdev->core_device, state);
+}
+
 static const struct pci_error_handlers mlx5vf_err_handlers = {
 	.reset_done = mlx5vf_pci_aer_reset_done,
-	.error_detected = vfio_pci_core_aer_err_detected,
+	.error_detected = mlx5vf_pci_aer_err_detected,
 };
 
 static struct pci_driver mlx5vf_pci_driver = {
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 2b047469e02fee..6045aaf64f5a40 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -174,10 +174,12 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 
 static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+
 	if (!enable_sriov)
 		return -ENOENT;
 
-	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
+	return vfio_pci_core_sriov_configure(vdev, nr_virtfn);
 }
 
 static const struct pci_device_id vfio_pci_table[] = {
@@ -187,13 +189,25 @@ static const struct pci_device_id vfio_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, vfio_pci_table);
 
+static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
+						  pci_channel_state_t state)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+
+	return vfio_pci_core_aer_err_detected(vdev, state);
+}
+
+static const struct pci_error_handlers vfio_pci_err_handlers = {
+	.error_detected = vfio_pci_aer_err_detected,
+};
+
 static struct pci_driver vfio_pci_driver = {
 	.name			= "vfio-pci",
 	.id_table		= vfio_pci_table,
 	.probe			= vfio_pci_probe,
 	.remove			= vfio_pci_remove,
 	.sriov_configure	= vfio_pci_sriov_configure,
-	.err_handler		= &vfio_pci_core_err_handlers,
+	.err_handler		= &vfio_pci_err_handlers,
 };
 
 static void __init vfio_pci_fill_ids(void)
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 06b6f3594a1316..9778d713f546d2 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1890,9 +1890,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
 
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
-	struct pci_dev *pdev = vdev->pdev;
-
-	vfio_pci_core_sriov_configure(pdev, 0);
+	vfio_pci_core_sriov_configure(vdev, 0);
 
 	vfio_unregister_group_dev(&vdev->vdev);
 
@@ -1904,18 +1902,10 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
-pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
-						pci_channel_state_t state)
+pci_ers_result_t
+vfio_pci_core_aer_err_detected(struct vfio_pci_core_device *vdev,
+			       pci_channel_state_t state)
 {
-	struct vfio_pci_core_device *vdev;
-	struct vfio_device *device;
-
-	device = vfio_device_get_from_dev(&pdev->dev);
-	if (device == NULL)
-		return PCI_ERS_RESULT_DISCONNECT;
-
-	vdev = container_of(device, struct vfio_pci_core_device, vdev);
-
 	mutex_lock(&vdev->igate);
 
 	if (vdev->err_trigger)
@@ -1923,26 +1913,18 @@ pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 
 	mutex_unlock(&vdev->igate);
 
-	vfio_device_put(device);
-
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_aer_err_detected);
 
-int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
+int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
+				  int nr_virtfn)
 {
-	struct vfio_pci_core_device *vdev;
-	struct vfio_device *device;
+	struct pci_dev *pdev = vdev->pdev;
 	int ret = 0;
 
 	device_lock_assert(&pdev->dev);
 
-	device = vfio_device_get_from_dev(&pdev->dev);
-	if (!device)
-		return -ENODEV;
-
-	vdev = container_of(device, struct vfio_pci_core_device, vdev);
-
 	if (nr_virtfn) {
 		mutex_lock(&vfio_pci_sriov_pfs_mutex);
 		/*
@@ -1960,8 +1942,7 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 		ret = pci_enable_sriov(pdev, nr_virtfn);
 		if (ret)
 			goto out_del;
-		ret = nr_virtfn;
-		goto out_put;
+		return ret;
 	}
 
 	pci_disable_sriov(pdev);
@@ -1971,17 +1952,10 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 	list_del_init(&vdev->sriov_pfs_item);
 out_unlock:
 	mutex_unlock(&vfio_pci_sriov_pfs_mutex);
-out_put:
-	vfio_device_put(device);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
-const struct pci_error_handlers vfio_pci_core_err_handlers = {
-	.error_detected = vfio_pci_core_aer_err_detected,
-};
-EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
-
 static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 			       struct vfio_pci_group_info *groups)
 {
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index a4555014bd1e72..74e4197105904e 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -492,12 +492,11 @@ static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
  * Device objects - create, release, get, put, search
  */
 /* Device reference always implies a group reference */
-void vfio_device_put(struct vfio_device *device)
+static void vfio_device_put(struct vfio_device *device)
 {
 	if (refcount_dec_and_test(&device->refcount))
 		complete(&device->comp);
 }
-EXPORT_SYMBOL_GPL(vfio_device_put);
 
 static bool vfio_device_try_get(struct vfio_device *device)
 {
@@ -831,29 +830,6 @@ int vfio_register_emulated_iommu_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_register_emulated_iommu_dev);
 
-/*
- * Get a reference to the vfio_device for a device.  Even if the
- * caller thinks they own the device, they could be racing with a
- * release call path, so we can't trust drvdata for the shortcut.
- * Go the long way around, from the iommu_group to the vfio_group
- * to the vfio_device.
- */
-struct vfio_device *vfio_device_get_from_dev(struct device *dev)
-{
-	struct vfio_group *group;
-	struct vfio_device *device;
-
-	group = vfio_group_get_from_dev(dev);
-	if (!group)
-		return NULL;
-
-	device = vfio_group_get_device(group, dev);
-	vfio_group_put(group);
-
-	return device;
-}
-EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
-
 static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 						     char *buf)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 66dda06ec42d1b..ae06731d947bf7 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -125,8 +125,6 @@ void vfio_uninit_group_dev(struct vfio_device *device);
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
-extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
-extern void vfio_device_put(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 48f2dd3c568c83..a0978ce126395c 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -227,8 +227,8 @@ void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev);
-int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
-extern const struct pci_error_handlers vfio_pci_core_err_handlers;
+int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
+				  int nr_virtfn);
 long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		unsigned long arg);
 int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
@@ -243,8 +243,9 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
-pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
-						pci_channel_state_t state);
+pci_ers_result_t
+vfio_pci_core_aer_err_detected(struct vfio_pci_core_device *vdev,
+			       pci_channel_state_t state);
 
 static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 {

base-commit: 1d0b96c15ee71167d8020446b608a0ed6a70d4b3
-- 
2.36.0

