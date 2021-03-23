Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412B53464B6
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhCWQPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:38 -0400
Received: from mail-mw2nam10on2048.outbound.protection.outlook.com ([40.107.94.48]:9569
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233144AbhCWQPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLba+vfTJZXRaoECPefM+/+1cIWSjO2PF6mT7WwL8Jfrgmqm3BXbQk+8+9DSqcyCQhCYmr8Ypm/IzAkR8v/bcYOsoPq/DnAov4jWBLDO9SKdN7H2PaGTzCLuxMFPzTdI1dv3ysVFGX6X3rVGJXMWeTyHqLdUiKwt15n372LLGRu1U50SQOKkuNxpRUJW1NMDvxt9llgz0jD7GNfaVI6NLV88v3dYML29Cnj34PYGyxQ08q2cFKqqJ5761wGhSU1e/NHsWG6xz7cAdb/ijPiOfY5WMSOo8qvaSb5FUQlkRgNYJjgkcLxmiZCMgJ/uAwlAPVWADbfMA9V4+WYzyjVA9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBn0P1KzS0KeguBazW8G31BWuQQTBc6PsBlBz9t2yMg=;
 b=YYBd7HqKubbLA6+dprBAh+ZjSuYWHXIFsR5uFb+xqwzLjZCt4qII/m+q0hEzfWWtgt8kOHcMbbABkHgkINXh7KFotqR6L20JsE/sreca8K5OfXnVz9a53BsP+xTTzd1HX9wJ9qj/Pg3UAOqggsbjDEqb475RpzBjhYOB6B9EQ06GdbiCeXd5llOEDoYmegPYPPcNerQ84idtLkzog+Rw9Nmu6kzIMTWdpI3e3RZwu2k42k2EHvGgzW2rCaWXefa0+FhTmxuThE9sEhbRyZBzhXXBw97sEdjwfJDHaRsRNJsNofvTXYlvqRRZiOiM8WLG2PaqYx6YSD0rlKC0GQie2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBn0P1KzS0KeguBazW8G31BWuQQTBc6PsBlBz9t2yMg=;
 b=Xjy++pW/U7ZkL1bdy0PI2XnCgcWB+ri1txEKpcNIXzyreRYyYDUiD8qJl4rf3hpyRoVBRxHB3K5HQ0e230achOzaDr5Ef8mNSB2uO0FUdLaqZR0GVQRop63b11Y+nrHWowRLW6Jnux3F32dratcZzyX9IGxTF0oBtxT7uQkWQ5D4keRF33XEEDA2Zjpru72/Ta/wP4K86Bb8lJwPoQyfATD6RZfDWTOQ3kBkAxFl8IvSa6KBYQ1xrTTffSE5EcmWtlLPGptbKbjx40rbT70SGNxmFSB9ayuoqPZ/TFu8Ig09FnQ/p7kQ6GFahytz6NViV8bmvRI+3CK7fqQ/S8Hv+Q==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2440.namprd12.prod.outlook.com (2603:10b6:4:b6::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 23 Mar
 2021 16:15:09 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:09 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v3 02/14] vfio: Simplify the lifetime logic for vfio_device
Date:   Tue, 23 Mar 2021 13:14:54 -0300
Message-Id: <2-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL1PR13CA0195.namprd13.prod.outlook.com
 (2603:10b6:208:2be::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0195.namprd13.prod.outlook.com (2603:10b6:208:2be::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Tue, 23 Mar 2021 16:15:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aCS-CP; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da5c743d-4a97-443e-9cfd-08d8ee16d38a
X-MS-TrafficTypeDiagnostic: DM5PR12MB2440:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB244074B104FC95A9F68AFA8BC2649@DM5PR12MB2440.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O7RJZz8z8d2Huq+BeXib54hC8LU2YevTEnKHpMBpy8AbjLT4zmbJYe5cKvPHniJ0YWRDKps99N+tb4AhnfhUdA8baQHBHem1IAbQonY26c8ucp4mFVrsA5xQKma2MpQOzyS8deVNNHbymDhOGur8jBYQSw4rSOmeZztyTqtW0G+aZqGiXvG2D6T+kmH9FGhC/yS8PLAFk+rRI7B6l3lINZNY7vBJROLBtLyTlGs6LYfZXzzNOWdmEQE25FzdP1ldNc7r0iFO+++Wd/98NDRNPuU/BC+sWVpPitgGbhzjDeJc0ratVscfBi1Fe9CvuRiICd2Dqz0nxP0WnL4pfSwW4RPYfqIWVIkr3+lBMPB2zncR8xkZnbwZ7ODR4JvJHqfjyv9JaRCS0kCmVL+b/t8K7utGvUUmgcvDrCjvRXW4HsuCe06m4r7IqJxprvmxNqnS6VmTVnWehrSehszoMuUWALUOueoO5RaVr373uKGpw+oO2MP5Qp94Xs6VeIqaSsJH1wjRij1lG9aTwRcHQQLRZUEppRKmxB/7KamFiVw1WVHevEEebjGtSMrh4zlDaaA9I0OS97WE53NdFAniWY1yP0cAh/7EZhLcDQ4LfN26T7+i8pkM8tHLO2Hmjt1Vv0ixL7qYKy6Ik41kVWXm2oPn6jbwT9epwDlQGeta9sh8dd+44miMXgPSYAwb27R44c7S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(66476007)(66556008)(186003)(36756003)(6666004)(86362001)(38100700001)(66946007)(4326008)(107886003)(8936002)(54906003)(9746002)(26005)(478600001)(426003)(8676002)(9786002)(83380400001)(2906002)(316002)(5660300002)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Hg1nsSTUZNQ+aew2t7U0KGs775RXYs8M5UiZ5GyGSJb9TcqkewL8WHf6WNf1?=
 =?us-ascii?Q?ODKhdEHRglMgJVzwX3aeIY0z1DzOtXLQBFoGH2i/WFVEw2IZs00n0yMie0cI?=
 =?us-ascii?Q?rumXsKhx+uciG6h1omqH+7k9nekuzVVjSBEhJKH+qePX/GEQgeWqywesleOc?=
 =?us-ascii?Q?5GnHOgj8aTvI7szBhK+ZvRpwbsM8VYFaOfp4y99oyytJIGe/j1bMohUlEhke?=
 =?us-ascii?Q?CbVppfdvY4d+IIrVTvFGpK9wcIK3nY4HxIVx7FmpSzaHCxU4hCBhddxZNFLL?=
 =?us-ascii?Q?o5atqhro4JmdK51vp1zQjyFzFKxPrs0BFxiqNrQOekGvHgIyXLqeJcomxfv3?=
 =?us-ascii?Q?dnW7/FmBLP/siOESl1KAPWHbU2XYzUAIolEJAd6eMCpxqWsMJ6qu6JsJrFmC?=
 =?us-ascii?Q?BwK4l5UjtZ5uOBC8czoRcJ1/jwmxVtkp5V4qkeIWab+/VtHobwfeBZOivaC3?=
 =?us-ascii?Q?7iWvEvAD4igLxsO7Am0nMxwvYmjfJ45oXTJWoxeL28yg/sZ3ZqWmt8Mzmaqc?=
 =?us-ascii?Q?2KpQwQ8z5SHzgBbX73L94HPG5BSKbDYV7CFbBHLpeQOge8Q5ZzlGjWd/5PC0?=
 =?us-ascii?Q?ilBI/QGIOjjWXVp7jBqZMarXlsqYXI63DfATjJnwmT96/uULTeCwVFLuVnnW?=
 =?us-ascii?Q?ND7gidi3zkD6JR5V81oYgov2chRG/iJCcBamKIvZGO0JEaEsdIAE8LFuqK7o?=
 =?us-ascii?Q?cwoMFobyaXRyvDNCwlmc3ohCZzL4E8WhzgKPfe1U7L0rCRBPmRsnHW9uzU4I?=
 =?us-ascii?Q?6Od+wMqg6W3T5Dwtjpn9Vb/ixN7De0iXju4FSkMS+viYFEIUKA2u3mT6iFWe?=
 =?us-ascii?Q?TzZn2hRrxvj2ZxC/uOShoqZHiZ2fH69e+U5RxEJOcDzG22nxtCwyRJc/YXaO?=
 =?us-ascii?Q?wfDu81YYtHy3jUS/Zv1dpwL/bncx7RBJR8f/c0q1Ost2F/8RcaXd19sel2fP?=
 =?us-ascii?Q?EdauPPbA+1qNgTcwGgB940zoEmJBKaJmlZapu2ZP8qAL+lL201vJxHyngtHg?=
 =?us-ascii?Q?bPGU92IaS48EkTB1rl3bA54IDOIe1SLjei1/comAPBR4BzhBLNUl5zj9gtbp?=
 =?us-ascii?Q?xou5YGil389Cd/2kyLeOCbYlm2vA6faGsQgzJ1JpnypCzSXZDupHw32EUhLx?=
 =?us-ascii?Q?7WofqTMsQi9DblhrJPaA60hcAxZAIjfQTCjwBzjsH7lC9UmUnBoB0agxdbGl?=
 =?us-ascii?Q?P9Ot449QuExVuHL5DLnb95iCdpAJDDuyFfQEVoXTaChJodkJC449QUu4Z5G8?=
 =?us-ascii?Q?ajJQ5fhhykf7R45HfBBzsgpKf4MQ8/dGclSKS3D7Nyhq+eIPuPQKs7vPonAG?=
 =?us-ascii?Q?JTROJQKIVXF5eEFpm5VJ+BvN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da5c743d-4a97-443e-9cfd-08d8ee16d38a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:08.2440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kC2rFQ/jjsXWlIIL0g+Y/C+JDBS7Xl3z46V9HSTKcSKsXzBmKgm2ZixYoi/JIGIQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2440
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_device is using a 'sleep until all refs go to zero' pattern for
its lifetime, but it is indirectly coded by repeatedly scanning the group
list waiting for the device to be removed on its own.

Switch this around to be a direct representation, use a refcount to count
the number of places that are blocking destruction and sleep directly on a
completion until that counter goes to zero. kfree the device after other
accesses have been excluded in vfio_del_group_dev(). This is a fairly
common Linux idiom.

Due to this we can now remove kref_put_mutex(), which is very rarely used
in the kernel. Here it is being used to prevent a zero ref device from
being seen in the group list. Instead allow the zero ref device to
continue to exist in the device_list and use refcount_inc_not_zero() to
exclude it once refs go to zero.

This patch is organized so the next patch will be able to alter the API to
allow drivers to provide the kfree.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 79 ++++++++++++++-------------------------------
 1 file changed, 25 insertions(+), 54 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 15d8e678e5563a..32660e8a69ae20 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -46,7 +46,6 @@ static struct vfio {
 	struct mutex			group_lock;
 	struct cdev			group_cdev;
 	dev_t				group_devt;
-	wait_queue_head_t		release_q;
 } vfio;
 
 struct vfio_iommu_driver {
@@ -91,7 +90,8 @@ struct vfio_group {
 };
 
 struct vfio_device {
-	struct kref			kref;
+	refcount_t			refcount;
+	struct completion		comp;
 	struct device			*dev;
 	const struct vfio_device_ops	*ops;
 	struct vfio_group		*group;
@@ -544,7 +544,8 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
 	if (!device)
 		return ERR_PTR(-ENOMEM);
 
-	kref_init(&device->kref);
+	refcount_set(&device->refcount, 1);
+	init_completion(&device->comp);
 	device->dev = dev;
 	/* Our reference on group is moved to the device */
 	device->group = group;
@@ -560,35 +561,17 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
 	return device;
 }
 
-static void vfio_device_release(struct kref *kref)
-{
-	struct vfio_device *device = container_of(kref,
-						  struct vfio_device, kref);
-	struct vfio_group *group = device->group;
-
-	list_del(&device->group_next);
-	group->dev_counter--;
-	mutex_unlock(&group->device_lock);
-
-	dev_set_drvdata(device->dev, NULL);
-
-	kfree(device);
-
-	/* vfio_del_group_dev may be waiting for this device */
-	wake_up(&vfio.release_q);
-}
-
 /* Device reference always implies a group reference */
 void vfio_device_put(struct vfio_device *device)
 {
-	struct vfio_group *group = device->group;
-	kref_put_mutex(&device->kref, vfio_device_release, &group->device_lock);
+	if (refcount_dec_and_test(&device->refcount))
+		complete(&device->comp);
 }
 EXPORT_SYMBOL_GPL(vfio_device_put);
 
-static void vfio_device_get(struct vfio_device *device)
+static bool vfio_device_try_get(struct vfio_device *device)
 {
-	kref_get(&device->kref);
+	return refcount_inc_not_zero(&device->refcount);
 }
 
 static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
@@ -598,8 +581,7 @@ static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
 
 	mutex_lock(&group->device_lock);
 	list_for_each_entry(device, &group->device_list, group_next) {
-		if (device->dev == dev) {
-			vfio_device_get(device);
+		if (device->dev == dev && vfio_device_try_get(device)) {
 			mutex_unlock(&group->device_lock);
 			return device;
 		}
@@ -883,9 +865,8 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 			ret = !strcmp(dev_name(it->dev), buf);
 		}
 
-		if (ret) {
+		if (ret && vfio_device_try_get(it)) {
 			device = it;
-			vfio_device_get(device);
 			break;
 		}
 	}
@@ -908,13 +889,13 @@ EXPORT_SYMBOL_GPL(vfio_device_data);
  * removed.  Open file descriptors for the device... */
 void *vfio_del_group_dev(struct device *dev)
 {
-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct vfio_device *device = dev_get_drvdata(dev);
 	struct vfio_group *group = device->group;
 	void *device_data = device->device_data;
 	struct vfio_unbound_dev *unbound;
 	unsigned int i = 0;
 	bool interrupted = false;
+	long rc;
 
 	/*
 	 * When the device is removed from the group, the group suddenly
@@ -935,32 +916,18 @@ void *vfio_del_group_dev(struct device *dev)
 	WARN_ON(!unbound);
 
 	vfio_device_put(device);
-
-	/*
-	 * If the device is still present in the group after the above
-	 * 'put', then it is in use and we need to request it from the
-	 * bus driver.  The driver may in turn need to request the
-	 * device from the user.  We send the request on an arbitrary
-	 * interval with counter to allow the driver to take escalating
-	 * measures to release the device if it has the ability to do so.
-	 */
-	add_wait_queue(&vfio.release_q, &wait);
-
-	do {
-		device = vfio_group_get_device(group, dev);
-		if (!device)
-			break;
-
+	rc = try_wait_for_completion(&device->comp);
+	while (rc <= 0) {
 		if (device->ops->request)
 			device->ops->request(device_data, i++);
 
-		vfio_device_put(device);
-
 		if (interrupted) {
-			wait_woken(&wait, TASK_UNINTERRUPTIBLE, HZ * 10);
+			rc = wait_for_completion_timeout(&device->comp,
+							 HZ * 10);
 		} else {
-			wait_woken(&wait, TASK_INTERRUPTIBLE, HZ * 10);
-			if (signal_pending(current)) {
+			rc = wait_for_completion_interruptible_timeout(
+				&device->comp, HZ * 10);
+			if (rc < 0) {
 				interrupted = true;
 				dev_warn(dev,
 					 "Device is currently in use, task"
@@ -969,10 +936,13 @@ void *vfio_del_group_dev(struct device *dev)
 					 current->comm, task_pid_nr(current));
 			}
 		}
+	}
 
-	} while (1);
+	mutex_lock(&group->device_lock);
+	list_del(&device->group_next);
+	group->dev_counter--;
+	mutex_unlock(&group->device_lock);
 
-	remove_wait_queue(&vfio.release_q, &wait);
 	/*
 	 * In order to support multiple devices per group, devices can be
 	 * plucked from the group while other devices in the group are still
@@ -992,6 +962,8 @@ void *vfio_del_group_dev(struct device *dev)
 
 	/* Matches the get in vfio_group_create_device() */
 	vfio_group_put(group);
+	dev_set_drvdata(dev, NULL);
+	kfree(device);
 
 	return device_data;
 }
@@ -2362,7 +2334,6 @@ static int __init vfio_init(void)
 	mutex_init(&vfio.iommu_drivers_lock);
 	INIT_LIST_HEAD(&vfio.group_list);
 	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
-	init_waitqueue_head(&vfio.release_q);
 
 	ret = misc_register(&vfio_dev);
 	if (ret) {
-- 
2.31.0

