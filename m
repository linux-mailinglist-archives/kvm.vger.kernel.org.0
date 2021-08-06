Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8343E2FE9
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 21:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244101AbhHFTve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 15:51:34 -0400
Received: from mail-sn1anam02on2075.outbound.protection.outlook.com ([40.107.96.75]:43590
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232086AbhHFTve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 15:51:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KcFDQNLM3xbg6W6gd/iZkO71WazeggtDAxNPnFobzFhT+ram/7JZ5TkwzKtBgeYyTkxwQFlfzTDIRV2gwHK+abE4My7HoyGdSKbAaQxmMbP+dJqALBjrocIXmQaGbfXKP/i+sgrASRC6dxCz0BLn475Ak08+un0xtGEhq8yPNcAfhq+V8Kj5nCsPB4vaqUyqrcqUz/bGo3fq/3/ySoxrK5cidqqq3aJIxIzS0B9lT8xmB0sT4U2vVsQpoUhUsl/HDQGhmds6YiiBC8cdfBa9Zjgw6QilhEDHlSDAQuCpylYNXiWDK5eKcujle2UC8hA6ySUmlrVKwb6LoUpWsqjn/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ewg+seSyNHxAnKe4jvv9KnLbv1KtI8SxZ+EO/rMyi9w=;
 b=ZHcoitkgjLKcj2V6l6xr3fC+7+IRbrhKiuEgn0djHRA+Ru1x9KQNv4PWrtYzzIxymSjlkyNLEIkroZl1fT8LH60x/OY6Q+fzdmYwC2UUVLM/8GLmfQnvCXncBPw0TTojRurN+S7iAmgi5uFgf5skwS891ENuri5v/M77SnU2wyMnitFhXu9njo7+0rhEZNWf5ohjP1iVxL+pwXxkiawE1UVPm3524VBF5kEjyMClyAyvYAGbhz34Ra72dEJgr1wgZft0d5REkdL981KAAhHeoXI9kpXBhN1ZNLo2OxdPoAF0bfJhJl0ugYmn0xwD+VFb5rZjjq8kxylQIi1CFb1jxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ewg+seSyNHxAnKe4jvv9KnLbv1KtI8SxZ+EO/rMyi9w=;
 b=okKu7j8SaY06dRFXBmyBcNH4i6XcCgkQERj/paV/yAmK1QR1gKwX8njQ6RAxtDwwC9WJXenc4eZvCRNDQPeWV9jOtZJ+O23NGu8zZa/IpbokFv/NLUDNTrOxm4jU2WZdGr/TYb2D/Gqqg6R6LroIIVR79rnMg9ZZJ9eUws/STZxLg4SZPR/dtLyjEGwr0DZw7HclRV9Rdis9+JQVED2lA2fuu4309bbqfMLCv36CYPC4Eto0x0+NFAju5tBvwXvBwlwRPUxdhqD6N7wWt9fXbvMWQhQeFXgRKZjD2/u1zI102KkP0B8wdZ5C03CzGD4gAq8p2Z4SvydtBNHeUeQ2Hw==
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5555.namprd12.prod.outlook.com (2603:10b6:208:1c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.18; Fri, 6 Aug
 2021 19:51:16 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%7]) with mapi id 15.20.4394.020; Fri, 6 Aug 2021
 19:51:16 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: [PATCH v3] vfio/ap_ops: Convert to use vfio_register_group_dev()
Date:   Fri,  6 Aug 2021 16:51:15 -0300
Message-Id: <0-v3-9f48485c5e22+3cb9-vfio_ap_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0129.namprd03.prod.outlook.com
 (2603:10b6:208:32e::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0129.namprd03.prod.outlook.com (2603:10b6:208:32e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Fri, 6 Aug 2021 19:51:15 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mC5sB-00F8Sm-6O; Fri, 06 Aug 2021 16:51:15 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7c478c3-70f9-460e-7971-08d959138d43
X-MS-TrafficTypeDiagnostic: BL0PR12MB5555:
X-Microsoft-Antispam-PRVS: <BL0PR12MB5555443B4B13FFF343D60BFDC2F39@BL0PR12MB5555.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:386;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SuLGUI9+oDzPhlQTjAAxke7GotswoUDPKB/He70mkeauP6JNpyYOvHt0Km6tJWoof3+SpOlOS+Y5vi/o8D8uuhwaRdHT3YTeq5vtbQupz3JXurvbQWiEagFrLSySuXiir1JTU030hpsy1wjOwWUh7FOYvUSzQHsD7qRXVl7COJQOAHHSQbTlNh+2TlAKygIQvMITQRKe3N8FS8qeUR/ehxcY3ao5wQ5qqZBTvj6MZqBVXSCfCuMMZUPTAI3OfYkRgDz9CRcQds3ODtfDuO8C326VkhDRIWcOylOm+C3KOwDi4lamuo48IgtnSVeFlN7IFBGG1Tz9f0OvcbShX2ppQRHmc1K+WLREs3mN5zN5G+AU62I17wRqzW7DjPCy1+obx0YBvTtCpHHqRLMsQe1iA+fDkcobytwkuk4pj83t5A/ZD16n4znkJyquANgj5gDZOWzhldcGdw8v7nv8UFktM67q2CImDI2b9CRyvvXsEO9XNUv/gsJZ5wJE5BMATk8lgewF5r95XPPG0sy+PPZPoq/JWdkKGMheqUQoZvjU64ZxRFXn5KFBHCGh2b3i+JQE+3ZtizlfjQHJG1tM7AAjYWyeJ3iUBZH5jHT9jFMuvYZPv+kaJcKrylTZLxv/OYbeZCgDdsTZISDqxVQ4PTUqrZzDMXDmhL6PY1NNQOG1TT96yjVd2U7JjtbD3aSodrGGQuAYzPrwCsInXfGiuNCMwKiNZLQG8tv8pWnJpgRLO/U6pFrbKBL5ZBAWb+1w7OJAm4GkFXMPkEVLwI9q26g+5zwIkX0j3+dEg9UON6LZT0IeKUib/Sh1954FXVJCIM8u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(426003)(86362001)(966005)(7416002)(54906003)(110136005)(66946007)(316002)(8676002)(66476007)(2616005)(66556008)(4326008)(186003)(9746002)(30864003)(26005)(83380400001)(2906002)(5660300002)(38100700002)(478600001)(8936002)(9786002)(36756003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BqXDyNzSiwtsWU2CejGJR86eG9rfoOarwpnaDGk1LtzZB44BL2+o8WmfG65g?=
 =?us-ascii?Q?vkZfL/oizzAhWL801NXg++a053y9DG31Bb8R7YFI/71ZJ/76le2E9pUycnTL?=
 =?us-ascii?Q?SBGrIQX43vMrND5iX/X59VxSr09y3hKvLIAizZoz5AlCqVslVRnnU3R9+qCt?=
 =?us-ascii?Q?nSjkX49N5vOkl1tK7S6ohw1O5n4BAImiNaxlhxIaqgNBkELI0xRa5W2hQL15?=
 =?us-ascii?Q?NDr8mxB+pRjSqp1TGowLl646Iy8PIOrZFW+2kSc5+vYAV4RG6dWUBjcfacj4?=
 =?us-ascii?Q?gnAbrXrDSNihIKo2OqqGY4yOs4Z9GNfX/WnTMZTYrXCRImou8aM4r3dlZVaw?=
 =?us-ascii?Q?LIHzk2iUh98vLVxxvFyOLgp6edPpH1WmsgK6kktNkhe6xiL0XG2ZGAnHghL/?=
 =?us-ascii?Q?lV3wRB0enxmHAJV/ozUFeiX7lgsGW+QnI7A8ZsBY/PakKrfba5D5LI7xK14L?=
 =?us-ascii?Q?VZCDH7Zw+yKMFir4QOyYUbwXWLuusUJcDMIrxecRV/MiZe7AuT6mfouABpwT?=
 =?us-ascii?Q?XzEhW7tW4n55MuxoLvkHLtLssslPQqxVKf8+gQ+eGP1on7q7L60B8IzH2UKI?=
 =?us-ascii?Q?pe5zNpDOSp4MG4SfvIWN5+My9izIpg70GJBzzqN92HR2P58cMKLzbwdcO4Al?=
 =?us-ascii?Q?GpICtqtgf24+pzuL2NSN2OAUvaj3KG6nMEafy5jln98RO4KagBcv2Hw/e/9V?=
 =?us-ascii?Q?BPy6R6+YgYPAsn+pevwGVVaPDs+DsMCPt91G/Iq5PE6E9p/uDiGBgLwyOtnr?=
 =?us-ascii?Q?Otl9I5kjrNN//OJA6zZNK09SSncnB3D0wPX71ORFVxEYjYkeQLWXGpd3lWH7?=
 =?us-ascii?Q?xC8eyt+zfp7K5HaB2tbkczEii7MSVNAly7I/hJLla/d4gxr8jZIK3tdJ4Uho?=
 =?us-ascii?Q?h0n9c61CToXD2O5Gho3yKkG58KtYnulnsnEBtfshZlA5K1tP1zszkywuaRdg?=
 =?us-ascii?Q?7qwtd5bmiIGeifgR3aIBl+EhOeaMOgEwbImb9nbR+2xw9T2CNvazoNJIpqK8?=
 =?us-ascii?Q?ET/a+N2SkFB0xiDIvZ2AskA1Ja67jHYK4uIwGZ35cyaUH1w8y50z8ybsFB00?=
 =?us-ascii?Q?i2mdJoysj2/RxWet9xgkc5z1D9tmz+BKIv4jumsx7Ab+RhgEP+F26ycMPUYw?=
 =?us-ascii?Q?SMGVg2CSLNBs20YZ+Du2WJBXm0BOrVXY7ZCg/mvjf7cxUJiIZb99wlbGCyLT?=
 =?us-ascii?Q?PKXkK0MBfxuEe8A7/hbywyEvUNa2xE5E+vOEJJyMQS5jyKS6O6FOt+ueKzPC?=
 =?us-ascii?Q?xuE+VaUlyLQPntrOmQRfI9BjT1Xn6gV1EcDijbvZfTO8fkfb1KWDdpno41Az?=
 =?us-ascii?Q?ngnXA63GMVvDUyR9Azb/NZzS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c478c3-70f9-460e-7971-08d959138d43
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 19:51:16.1245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l2U2K/G+cOLfBX1H11HdsGOZTo6kWa98/QhZ47ZuwCfhYrLHPNUuyKGDkDvICek3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5555
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is straightforward conversion, the ap_matrix_mdev is actually serving as
the vfio_device and we can replace all the mdev_get_drvdata()'s with a
simple container_of() or a dev_get_drvdata() for sysfs paths.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 155 +++++++++++++++-----------
 drivers/s390/crypto/vfio_ap_private.h |   2 +
 2 files changed, 91 insertions(+), 66 deletions(-)

Alex,

This is after the reflck series and should thus go to the vfio tree. Thanks

v3:
 - Rebase ontop of the reflk patch series
 - Remove module get/put
 - Update commit message
v2: https://lore.kernel.org/linux-s390/6-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com/
v1: https://lore.kernel.org/linux-s390/6-v1-d88406ed308e+418-vfio3_jgg@nvidia.com/

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index cee5626fe0a4ef..0828c188babedf 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -24,8 +24,9 @@
 #define VFIO_AP_MDEV_TYPE_HWVIRT "passthrough"
 #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
 
-static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
+static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
+static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
 
 static int match_apqn(struct device *dev, const void *data)
 {
@@ -335,45 +336,59 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
-static int vfio_ap_mdev_create(struct mdev_device *mdev)
+static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev;
+	int ret;
 
 	if ((atomic_dec_if_positive(&matrix_dev->available_instances) < 0))
 		return -EPERM;
 
 	matrix_mdev = kzalloc(sizeof(*matrix_mdev), GFP_KERNEL);
 	if (!matrix_mdev) {
-		atomic_inc(&matrix_dev->available_instances);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_atomic;
 	}
+	vfio_init_group_dev(&matrix_mdev->vdev, &mdev->dev,
+			    &vfio_ap_matrix_dev_ops);
 
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
 	init_waitqueue_head(&matrix_mdev->wait_for_kvm);
-	mdev_set_drvdata(mdev, matrix_mdev);
 	matrix_mdev->pqap_hook.hook = handle_pqap;
 	matrix_mdev->pqap_hook.owner = THIS_MODULE;
 	mutex_lock(&matrix_dev->lock);
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
 	mutex_unlock(&matrix_dev->lock);
 
+	ret = vfio_register_group_dev(&matrix_mdev->vdev);
+	if (ret)
+		goto err_list;
+	dev_set_drvdata(&mdev->dev, matrix_mdev);
 	return 0;
+
+err_list:
+	mutex_lock(&matrix_dev->lock);
+	list_del(&matrix_mdev->node);
+	mutex_unlock(&matrix_dev->lock);
+	kfree(matrix_mdev);
+err_atomic:
+	atomic_inc(&matrix_dev->available_instances);
+	return ret;
 }
 
-static int vfio_ap_mdev_remove(struct mdev_device *mdev)
+static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 {
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(&mdev->dev);
+
+	vfio_unregister_group_dev(&matrix_mdev->vdev);
 
 	mutex_lock(&matrix_dev->lock);
-	vfio_ap_mdev_reset_queues(mdev);
+	vfio_ap_mdev_reset_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
 	kfree(matrix_mdev);
-	mdev_set_drvdata(mdev, NULL);
 	atomic_inc(&matrix_dev->available_instances);
 	mutex_unlock(&matrix_dev->lock);
-
-	return 0;
 }
 
 static ssize_t name_show(struct mdev_type *mtype,
@@ -615,8 +630,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 {
 	int ret;
 	unsigned long apid;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
 	mutex_lock(&matrix_dev->lock);
 
@@ -688,8 +702,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 {
 	int ret;
 	unsigned long apid;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
 	mutex_lock(&matrix_dev->lock);
 
@@ -777,8 +790,7 @@ static ssize_t assign_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long apqi;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
 	mutex_lock(&matrix_dev->lock);
@@ -846,8 +858,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long apqi;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
 	mutex_lock(&matrix_dev->lock);
 
@@ -900,8 +911,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long id;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
 	mutex_lock(&matrix_dev->lock);
 
@@ -958,8 +968,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long domid;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
 	mutex_lock(&matrix_dev->lock);
@@ -997,8 +1006,7 @@ static ssize_t control_domains_show(struct device *dev,
 	int nchars = 0;
 	int n;
 	char *bufpos = buf;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_domid = matrix_mdev->matrix.adm_max;
 
 	mutex_lock(&matrix_dev->lock);
@@ -1016,8 +1024,7 @@ static DEVICE_ATTR_RO(control_domains);
 static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	char *bufpos = buf;
 	unsigned long apid;
 	unsigned long apqi;
@@ -1191,7 +1198,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 		mutex_unlock(&matrix_dev->lock);
 		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
 		mutex_lock(&matrix_dev->lock);
-		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
+		vfio_ap_mdev_reset_queues(matrix_mdev);
 		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
 		kvm_put_kvm(matrix_mdev->kvm);
 		matrix_mdev->kvm = NULL;
@@ -1288,13 +1295,12 @@ int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
 	return ret;
 }
 
-static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
+static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev)
 {
 	int ret;
 	int rc = 0;
 	unsigned long apid, apqi;
 	struct vfio_ap_queue *q;
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
 	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
 			     matrix_mdev->matrix.apm_max + 1) {
@@ -1315,52 +1321,48 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 	return rc;
 }
 
-static int vfio_ap_mdev_open_device(struct mdev_device *mdev)
+static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
 {
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev =
+		container_of(vdev, struct ap_matrix_mdev, vdev);
 	unsigned long events;
 	int ret;
 
-
-	if (!try_module_get(THIS_MODULE))
-		return -ENODEV;
-
 	matrix_mdev->group_notifier.notifier_call = vfio_ap_mdev_group_notifier;
 	events = VFIO_GROUP_NOTIFY_SET_KVM;
 
-	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
+	ret = vfio_register_notifier(vdev->dev, VFIO_GROUP_NOTIFY,
 				     &events, &matrix_mdev->group_notifier);
-	if (ret) {
-		module_put(THIS_MODULE);
+	if (ret)
 		return ret;
-	}
 
 	matrix_mdev->iommu_notifier.notifier_call = vfio_ap_mdev_iommu_notifier;
 	events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
-	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
+	ret = vfio_register_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
 				     &events, &matrix_mdev->iommu_notifier);
-	if (!ret)
-		return ret;
+	if (ret)
+		goto out_unregister_group;
+	return 0;
 
-	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
+out_unregister_group:
+	vfio_unregister_notifier(vdev->dev, VFIO_GROUP_NOTIFY,
 				 &matrix_mdev->group_notifier);
-	module_put(THIS_MODULE);
 	return ret;
 }
 
-static void vfio_ap_mdev_close_device(struct mdev_device *mdev)
+static void vfio_ap_mdev_close_device(struct vfio_device *vdev)
 {
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev =
+		container_of(vdev, struct ap_matrix_mdev, vdev);
 
 	mutex_lock(&matrix_dev->lock);
 	vfio_ap_mdev_unset_kvm(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
-	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
+	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
 				 &matrix_mdev->iommu_notifier);
-	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
+	vfio_unregister_notifier(vdev->dev, VFIO_GROUP_NOTIFY,
 				 &matrix_mdev->group_notifier);
-	module_put(THIS_MODULE);
 }
 
 static int vfio_ap_mdev_get_device_info(unsigned long arg)
@@ -1383,11 +1385,12 @@ static int vfio_ap_mdev_get_device_info(unsigned long arg)
 	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 }
 
-static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
+static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 				    unsigned int cmd, unsigned long arg)
 {
+	struct ap_matrix_mdev *matrix_mdev =
+		container_of(vdev, struct ap_matrix_mdev, vdev);
 	int ret;
-	struct ap_matrix_mdev *matrix_mdev;
 
 	mutex_lock(&matrix_dev->lock);
 	switch (cmd) {
@@ -1395,12 +1398,6 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 		ret = vfio_ap_mdev_get_device_info(arg);
 		break;
 	case VFIO_DEVICE_RESET:
-		matrix_mdev = mdev_get_drvdata(mdev);
-		if (WARN(!matrix_mdev, "Driver data missing from mdev!!")) {
-			ret = -EINVAL;
-			break;
-		}
-
 		/*
 		 * If the KVM pointer is in the process of being set, wait until
 		 * the process has completed.
@@ -1410,7 +1407,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 			       mutex_unlock(&matrix_dev->lock),
 			       mutex_lock(&matrix_dev->lock));
 
-		ret = vfio_ap_mdev_reset_queues(mdev);
+		ret = vfio_ap_mdev_reset_queues(matrix_mdev);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
@@ -1421,25 +1418,51 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 	return ret;
 }
 
+static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
+	.open_device = vfio_ap_mdev_open_device,
+	.close_device = vfio_ap_mdev_close_device,
+	.ioctl = vfio_ap_mdev_ioctl,
+};
+
+static struct mdev_driver vfio_ap_matrix_driver = {
+	.driver = {
+		.name = "vfio_ap_mdev",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+		.dev_groups = vfio_ap_mdev_attr_groups,
+	},
+	.probe = vfio_ap_mdev_probe,
+	.remove = vfio_ap_mdev_remove,
+};
+
 static const struct mdev_parent_ops vfio_ap_matrix_ops = {
 	.owner			= THIS_MODULE,
+	.device_driver		= &vfio_ap_matrix_driver,
 	.supported_type_groups	= vfio_ap_mdev_type_groups,
-	.mdev_attr_groups	= vfio_ap_mdev_attr_groups,
-	.create			= vfio_ap_mdev_create,
-	.remove			= vfio_ap_mdev_remove,
-	.open_device		= vfio_ap_mdev_open_device,
-	.close_device		= vfio_ap_mdev_close_device,
-	.ioctl			= vfio_ap_mdev_ioctl,
 };
 
 int vfio_ap_mdev_register(void)
 {
+	int ret;
+
 	atomic_set(&matrix_dev->available_instances, MAX_ZDEV_ENTRIES_EXT);
 
-	return mdev_register_device(&matrix_dev->device, &vfio_ap_matrix_ops);
+	ret = mdev_register_driver(&vfio_ap_matrix_driver);
+	if (ret)
+		return ret;
+
+	ret = mdev_register_device(&matrix_dev->device, &vfio_ap_matrix_ops);
+	if (ret)
+		goto err_driver;
+	return 0;
+
+err_driver:
+	mdev_unregister_driver(&vfio_ap_matrix_driver);
+	return ret;
 }
 
 void vfio_ap_mdev_unregister(void)
 {
 	mdev_unregister_device(&matrix_dev->device);
+	mdev_unregister_driver(&vfio_ap_matrix_driver);
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index f82a6396acae7a..5746a00a7696a1 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/kvm_host.h>
+#include <linux/vfio.h>
 
 #include "ap_bus.h"
 
@@ -79,6 +80,7 @@ struct ap_matrix {
  * @kvm:	the struct holding guest's state
  */
 struct ap_matrix_mdev {
+	struct vfio_device vdev;
 	struct list_head node;
 	struct ap_matrix matrix;
 	struct notifier_block group_notifier;

base-commit: f34c4bf75b04b722c4671b3350c6093ba5f98ffa
-- 
2.32.0

