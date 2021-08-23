Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1955B3F4C8A
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 16:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhHWOmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 10:42:51 -0400
Received: from mail-bn8nam11on2063.outbound.protection.outlook.com ([40.107.236.63]:39776
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229726AbhHWOmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 10:42:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/Mzbh1uTI2CaSJ9FUt1rlP4LPwOc4RU5I3CCP9x+iS1xCW93LqluYAyqCCBMd1+plTI01ILuMG+aZWDY7jroJEuUuatfjTRp1fLvEYo0VHwFUShttPw6USl0mOvIJp/Ot3/B46wbt2KrqpyebmhMb0/hO45WxzpNoaapvTft4uc7TVfSvR2IiGnpHaFF3ulP0YP87pVvbFaqiRRjnbsA7YtlaT09191k68z+rcC/RUTHwELPKmvhr0utL1wmXoVTKgN5njesj6ix9hyVdPnfbgqXLl6+q/Di2PU/8WvAVy6+Tsn5/CpeDsQnv38/L4QAMusRVxXFXZHyGrYVMI8uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahumLjAQq4No95QtKo4P95cZq5HJPb4awCcaEVyXzEc=;
 b=LVQAYG0GtB7P36Mz3F8oQ75xq/SGoF24cbYZJ0ndWXJCbMhEl2eDg7NHSHlL1Cnr35Yvxv+J3ozTT4Mr6Goc+vEJpQTxfNUTUEec3J/2ujqcXnOEIvA0mqI/3d+8YhxdFiNNQRJdFl4hj2tNwHXYljhOqFeb73FvU/ui8WxyaS5WEeOwbWZFkA9hMT689gb+W7h+UAtXgll/mzibrKwO4ICRPn3IyEP+0j53H0BexzvWpwjN+DS20014aJ1fVHXmsbE1OEDzmDiIkN2AqLCsrMS2S5gmmvMb32+Bbwc40XHS8gaEkmcMpKgrO2mgYGR8AtU3s3qB49NFR+q9NV5C+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahumLjAQq4No95QtKo4P95cZq5HJPb4awCcaEVyXzEc=;
 b=VlBN7B0v7fUMyPvnyOaoBn+BCrj8yq/9ahX9xTQOMUgwaj7pAYVaH7UIHKLA6WpPzCUK5MKqTUCK3HXLWmQvF3g/r0yjDKGfe5H62JYCeoLXqA4SjcHC51Z6hwy/nzBOYz2OjskXPTVHyWlMhTyMqOwdoPhN69UUgjQSHSJGytSpfBVfk/pbLoNfMTONsWW4DLKDMoJ1IMRehRjNaKRJRnCo7Tob0jCCDAUMQNcql6h9IaZXsJw1IwODTHqqQUvTjj8YdS4FEr9rNrbmTJYVbHWbiODr6JLCSBaFTPtcyAFwDxETQz91nrnIeouCr1ixz2XmpwEWYdxQxh8gKBT2uQ==
Authentication-Results: de.ibm.com; dkim=none (message not signed)
 header.d=none;de.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5125.namprd12.prod.outlook.com (2603:10b6:208:309::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Mon, 23 Aug
 2021 14:42:05 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 14:42:05 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: [PATCH v4] vfio/ap_ops: Convert to use vfio_register_group_dev()
Date:   Mon, 23 Aug 2021 11:42:04 -0300
Message-Id: <0-v4-0203a4ab0596+f7-vfio_ap_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0446.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0446.namprd13.prod.outlook.com (2603:10b6:208:2c3::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.5 via Frontend Transport; Mon, 23 Aug 2021 14:42:05 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIB9I-003hJY-EH; Mon, 23 Aug 2021 11:42:04 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e41d139a-4542-4d1e-9c0f-08d966442d2f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5125:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5125BC1701DA103CC3606FAEC2C49@BL1PR12MB5125.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:232;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gSqAksusxQ6/6qJdTDUEFCPCNvi5gjqJMslprmsZ3C1EJKcBnLRwhQt++jOXzuM5p0JPf01UGzw6Zt7hCNA6qiDcV/531hWhVo4bgUJPpz98EQ3oSJGF/BKmZgXvAUoDdibUi/WPU1FKojmBpku7QEr7VZxkPM9SxU1tt3Ml6HFV1ETseZdvezJcvzuqiYrq04RL/lEuziBlzGJZjL7DdeFzG5eYQxoQ1VJnQ+PTA22DYPIg4FYHPCXRickJ++eZJn04oO0mhD7mLEIdgmPqqZh+cmhATCGXzNb9E1h8gkUd3bjePMEoFPdKNGb44tir0QrXSPR1mHcuulTwf2tvbuzQfYuhet8o3Nk58Bwl2gvqdpzRPGcYnjxL42IUiMX+p/XUDbREgPv+/aKrkCkPARS5lbFwrNdzpgl/mTDsjn5T9GYfmdgtuwMVbx06fsKEhMkcMZW+N55hXCx3NcMcls6ZxP51dN2RcVsDYd4N1IKz9HaTPv4kea13oq7uPDQDzx0DX2KaaytilRzsYR67wJumd4hc50Yu3FgHXC24pIjB3Xuuow1i7l/hWKaU6Z6XEflllEGFjzUFAZQ0HpekhYh1SlceRzV/s+n+U22v+S06N8M9JUSkpcB0Rvird9ltMqEQFZpdPJ04UBQohmv8o2xrxuX+ERER/xpdIT1W1p9C7Enob7Ie9AdDPN9JOoTL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(83380400001)(110136005)(66476007)(36756003)(316002)(54906003)(186003)(426003)(38100700002)(2906002)(86362001)(2616005)(30864003)(4326008)(9786002)(9746002)(5660300002)(8936002)(8676002)(478600001)(26005)(66556008)(66946007)(7416002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6vMIRwe8RwbrEXMNGzb/+P7BaPM1LWMEd2Y4m90EPjcFu1e/vtw9i+KC/P0h?=
 =?us-ascii?Q?6JZVGYIzi+DOm3w5SbH6XYYXQk7nr5oRSPyyviIBtpX6jg1RJPhaCiqaTKu5?=
 =?us-ascii?Q?vA8t6gJ18T0SGJBIYLtVcH8SDSUqM/IhA0ktuqxjxnO902XGKGLJUgov1GRY?=
 =?us-ascii?Q?KEB3T97CSK4GmDVkKq/iaspUyG0M0/sPwoQj8po2C3tEa/1b1ogQ2KX8yihN?=
 =?us-ascii?Q?oIRwE9VQ1gsm7MGRatujszQGfgHKBKUAIjGJreprFLE3i6uDOKPLPbPmKqpE?=
 =?us-ascii?Q?RdH7fY4cEjI848f31T+e6mqXGyBCevSOsVQxn2sE+gRXsvqrofJXU+R6B83r?=
 =?us-ascii?Q?O7zNK0VZxqPSvIpGJWIwLCryJDoxV54uuggCZTHyTBDpqtFwLRDkxI7QsJts?=
 =?us-ascii?Q?p4HoECfiTLIfDAy/rbrsUe4gLVCxktg5DtLOgfDz9MJI55EDQMm22hvMv6Ns?=
 =?us-ascii?Q?xs3bMkCu01XEycKggEmKcAIExFsu6wgFBa4wSIJ3z6BojPHrMgJ0EjI9k3Tk?=
 =?us-ascii?Q?gaGiEmtKUtyKl9ViPDqBSFmHHllFgTRsp+W1ws/7oaxQTUEXoMbkfh7FGkkO?=
 =?us-ascii?Q?IFtlk/0DCuZst0BXGkXcC2UBdPsdh7onzS9QDR+xh9CkgHMl3GTSHFcEqERi?=
 =?us-ascii?Q?RMxxBz2k3bZv1NYsM7CmOcKEPbIXsAeTJpLwh+PdJsvd7FKFj4bRkdXceN3t?=
 =?us-ascii?Q?hVKLzaxCm04iwCMmLFklm5hykKzuGlcgLzEd26/SqfkJv2vhXPoDpJJbBhzw?=
 =?us-ascii?Q?j0fvrUx3UR15qogRRgFwnbuqPs3XvTZye5F+5NOLkn2eyhY7KnMjx+wfDmCh?=
 =?us-ascii?Q?xmbd1kBx/imSgiqdClU5ofjvuojGR1sYQ/Cnkmnmr7/+sWrg70SDBF8Pubyx?=
 =?us-ascii?Q?jf0cou+B5ogsUoVg1IjMFcm3K11svu13+JSZSPmsfy+jQNt07rL0hpKM8LbB?=
 =?us-ascii?Q?uySBlRxliJRO51OM5rubWnw6fdZpi0qKHXQRzTkEpe0jCfGpzYjm5c78KA5m?=
 =?us-ascii?Q?syBo54Is8xJACvdarir7CnfUbBbjfkDG2uCfsmR4BfAGd7UeUG/MqUykNAAG?=
 =?us-ascii?Q?iYBdB/5rAw1NRmo3XaAZ75b6UCjfbP4ndyHQEWlo7fLV5OGRUvGYyN9vdHK4?=
 =?us-ascii?Q?f2pC7THOBumtPAUnsMemY5oAdMlaO3KnN3P8AZn+BuE03pCP8iZvK46suJR2?=
 =?us-ascii?Q?arhO+G89Fc/Z04VK15XTBuasLDXFBjdilFqXc6lufEbBoy+w2Wq1hk2gc9Hf?=
 =?us-ascii?Q?60RxKNvIPk+D5pMoIgS2fsRJF6XmjywqedElJVE7cBiQk8zJbnG6jhHZ4bL6?=
 =?us-ascii?Q?35xW6EefmXwDZm2EjZvvjcvH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e41d139a-4542-4d1e-9c0f-08d966442d2f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 14:42:05.3352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQCJAHOkTbVrL38li7eruvtpTyyygK615+jVvHLGfzXVxYVepXRUtReq0T1vcPC/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is straightforward conversion, the ap_matrix_mdev is actually serving
as the vfio_device and we can replace all the mdev_get_drvdata()'s with a
simple container_of() or a dev_get_drvdata() for sysfs paths.

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 155 +++++++++++++++-----------
 drivers/s390/crypto/vfio_ap_private.h |   2 +
 2 files changed, 91 insertions(+), 66 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index cee5626fe0a4ef..ca2ee1f6736a64 100644
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
+		goto err_dec_available;
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
+err_dec_available:
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

base-commit: eb24c1007e6852e024dc33b0dd9617b8500a1291
-- 
2.32.0

