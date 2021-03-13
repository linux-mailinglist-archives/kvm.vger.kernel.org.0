Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91720339A9D
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhCMA4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:56:36 -0500
Received: from mail-dm6nam12on2081.outbound.protection.outlook.com ([40.107.243.81]:44481
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232389AbhCMA4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:56:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aSJeFkY7/02wxwWxFfh0TPaqiQZJkUpC9yYDgKCxyVzgUWz2+0H9/s2O2LnCtKRVYiqhYPfgF1wR7XnTbHA5O8thBpeLsKG/o8ncmn/TyM9ymtKKYVaJqnFeNmzqqyZlgw8ZSTEfBZuLWCWFj9Bi/olHB6CLS8CaSPm5PlfQ7pVoCgOe8Qvz9zHi/B9mb1T/9uc/+WGZY0pHDkSzGcfWY2I+H/7IMxPmtUcnvs6OdUeO25MqB4SIbb36Anh6NnNxDPy+t/iB6T2ereJb4n98FKeXu2/15os85DXWiMeLjxF6xocN9ASWjo+Uj/rtulP9u99Q8tkZI2okauoumBIw7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Om19ByP/I6xPGMjGFR4lv9LcCo/CEmmV9LX/26rOUP4=;
 b=INhLPsJN5OcfRMEFrQBUzRwbSLTbTs+Mp3hy3b3uIqdIeFrLcfXOGAJJ5OxFG/3YxQLQlHaH3PnO/En6sEZH3vthHLq871M6CCScYC7buvBjvPxVz2HIUJc4lnYUlhZIvHBG9vruYGFbAf8qE4cUh/pg4wr367k21F70KJ+VQae+WxnxVCg6khHrhCQM2GUYh4/n37o6IkCAhvtczr4dKLbdPotd02RK2S3UJ06J9npNjrsBywn11DYIxOsiirY4p9RsiaftP/Fq/yfUpT6ejePsEBTgiy5Zz3ikVaOb14GbJMcM9mUvcNTdWs8Clw07/4tzJKJoqJKxi3Vqw2jYww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Om19ByP/I6xPGMjGFR4lv9LcCo/CEmmV9LX/26rOUP4=;
 b=UxKAD4GVyjFbbPz1TMymoCp+1P3JAsK5ibgTDWexT2XESqLv39AdN5B+2PqaKEUM+CNz49KX16jNZavDM4DfdDKGFFj6RJgcx4l8oSMk/oaF12y9dI7vu3XEcHqdV1ifDZCoEEtHj25W0GELA+n8AWYUqzpX0qDNAcnVwRAhNKv6C0p9npTrp5UD5Ot3wBrbBn19afubECemXxhsY6/I/tp5Lcg0xhE6EY4cbvQJwOyLPzP2QDCfz+cbZKYWDqtH08NR9dN36K90Bg7Ifl29uAQL9Uq6y2TXwAu9XRVAuB3yRbezclce7grewaAIUeZgLq18WANK1bpnN5ONIqqPnA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2940.namprd12.prod.outlook.com (2603:10b6:5:15f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Sat, 13 Mar
 2021 00:56:15 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 00:56:15 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 02/14] vfio: Simplify the lifetime logic for vfio_device
Date:   Fri, 12 Mar 2021 20:55:54 -0400
Message-Id: <2-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR06CA0009.namprd06.prod.outlook.com
 (2603:10b6:208:23d::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR06CA0009.namprd06.prod.outlook.com (2603:10b6:208:23d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Sat, 13 Mar 2021 00:56:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZa-00EMAo-Pi; Fri, 12 Mar 2021 20:56:06 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6ba012a-e2fa-4b9b-6497-08d8e5bacc04
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB29403DB8C95065383FA3A051C26E9@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0haoW+UMDLa8s3EzW8CzbKCoXqNWl9w4kloWRDn6KyTwx+OEzKvU+cycExdMPHn1y97Z4uOqPBSnfFKQ0NhBqb2W3wQBKMpF0uIzzEeHBEIgT2bZ8gLYL6p4BMcEqIDPOF+KjHgmiU/as9xfJMclILWAGfwZ5JoUZuOyp7jxEtEx/IOymPx/BBcwqFsquaQyOMoh+fpQCtl8fORD7w7P+edK/1rMakxdXj4GkqNJZeNIzQ/0UGGc23F8bxw0kNmXxhpFBQCtFwHdboT3324X7UAWRb/P4t0Nxvv10tC57mtJrCBJbWtd2Runbu9HGH3ODkL4ogsQsRg819OHojujZAijJfEAjBpFDB60+4DLkcpKL9EJ2+yU7OUHoNIAPVNFdeVvy69O74AeINoeWkpcHFc07l61Hi+39e9DKZU9ApmXWOR7kZIgxHszUhFF3OpJf6ILx+uov6e1nOo3pT10f/NDcSrfO5WKFX6Ye/vVuQxR+So2sk5mRr9I2s6rXmwLYSVRq9zxss32dV7ddSgAc0TGxV/qShpu0xZ78W1KDnu2BQp0qwy59Khk5tCu86TemZT/PBVQH/IlDzc6Tx+v3tvZ29wi6J4D2/uMrhwrxQk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(9746002)(9786002)(8676002)(6666004)(4326008)(107886003)(54906003)(8936002)(5660300002)(36756003)(316002)(110136005)(83380400001)(66946007)(66556008)(186003)(26005)(66476007)(478600001)(2906002)(426003)(86362001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TyxzxR/AvtjgkoIc4SWalRdgg6zXhtvo3qcfHz04Pt21f4lfbttXS7O2Wmer?=
 =?us-ascii?Q?oaEkeByjhlvMxealSIsJI8eF4UhhT/3pMAbzIDpoRuWl9E0RXNZVwasWxPmY?=
 =?us-ascii?Q?d5u3pxhDv8nd7IbblRvmaw50OJm0U4yBwJygyRcMgmqFkLhkZIpKFhOo+Xx3?=
 =?us-ascii?Q?xA2ZlQdTLCwIvY9K+z76+OtmEJ8gov63VXWImd3p+QVrPqar5MlM5x1rPOmu?=
 =?us-ascii?Q?XuscTYXycLY0D/XEZNs5TU6lje2O4C1f5INlbLCD406oM5hlymPNSvSKk3OY?=
 =?us-ascii?Q?dsh4+120jf2B2dsgeEeBQjAnPUgP7zC7ANVRwapoMfY/Bfwpk2NMBMCyAd/0?=
 =?us-ascii?Q?2fcc4X17OeWMLj8kvjnv2+3QbLoFOLm/Ob81tabzFP34oyBpfLKIaaSN+hV1?=
 =?us-ascii?Q?561oZjDG3ommpVhgl730rZAx9oBNRB4Hsftsg6EwPW6yE53mcOtTHfgP4CdV?=
 =?us-ascii?Q?6HFo/DYjn+ie75aXin/JWjIlGHVA8lukjmObDg76hywvqwuZmk3W+oiJpor1?=
 =?us-ascii?Q?26KU3A2zwRUCfZOzhB5M8terRmd2AiNRsUPaaZA4gpkr73EYRqRTcq1KOvpI?=
 =?us-ascii?Q?yWFqGUnUruqfuEF6ebyi4dcgFM1oYk8X+aaX2vVUO/E3f4lDGhBul6rZSOuU?=
 =?us-ascii?Q?7EZUnt7spdjPBAcSfw0DtoUIeB3BxdIawU3L88/kdYhGcKbe0krfdNwZiIYq?=
 =?us-ascii?Q?On5SMUmwuLYRAyBSUn52QU6nxN61T/zs7WMKsThMjAs6uyN5MU9pGNMBngkO?=
 =?us-ascii?Q?ClBDpqeJIw9QTO6B8l2ruWmub3mieJQdbqAgKQ/4+JguQtnjgMZy/p6d7pMx?=
 =?us-ascii?Q?TjBsJGOS2UzT8gxH7y1O2RQxL0ACUjGEMtHnscIhj71OmHy7yZtS2tzauOgA?=
 =?us-ascii?Q?cxFFuWM3ej1gYB90lbmNuBOlMyhGnJbnO5jTzFZnlnS6sNzlJbreGDp/kfGW?=
 =?us-ascii?Q?36sccN0Avyxgz7NTVM9FijpwU6PQx20OOZePXt+P/SMRqpr/f1cewvXcA39L?=
 =?us-ascii?Q?CRUB7o/8T+dep2qSzS6VfJkOGruVDotzerIbLQ82UgYAt570rO4E6FdMWH4j?=
 =?us-ascii?Q?DyZeS0sA6JliI6iffPsWtxPbrLKRg4KD9nWgoTLJDzs8rwwEqVzeYyBfdGKJ?=
 =?us-ascii?Q?o3F+4UbmqVN5+HAguqPUTJrkxKLVm1ykPJH+lFZZchbKxGM36Q8UTCqz8Ioo?=
 =?us-ascii?Q?L55/53lEACv5HYn9KewOlHpN/1L9W4Eqs1ogFP5GODmub6rYFhL+gvcKvIeW?=
 =?us-ascii?Q?SQZeV6VUAzc/1T1vL5yFawkoI4a09ehffS8I5Ogxj0sDERGzjmlLsoUrEuhn?=
 =?us-ascii?Q?4i+d+W80tq2sUhk6b+L4Nmlz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6ba012a-e2fa-4b9b-6497-08d8e5bacc04
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 00:56:12.7290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZhCfuELoDBTTz8k5XcNtChuW+6ZVERgv2LlW8GL0xSsuWC6vS0xsPnXpHv/O1Cw1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
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
2.30.2

