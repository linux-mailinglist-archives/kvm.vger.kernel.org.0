Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8BE33310D
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 22:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhCIVjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 16:39:08 -0500
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:49607
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231800AbhCIVi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 16:38:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4YkKX7LgG/Z+7RqEJpiz7QFe1tZqSov20IJEBjdyZCUwTgpQeb+97knwB83WVPIO5tZtCQLqDMTWucu6ezslFm2gAa5RR33s6ozaUpRy8b78S++RViouIq+zhAkqWGNMgQouR4kAdoCfn8vIGV9vSEgeNq9c3NoSnNjmpir9KebKCIcQDn0vHg3ckBqZ7jTtannU8+tIvqknVDhOHVkCrQLyUTfGhME3gmO2/mbeXgHC0oA1DRbNXakwKt9orinqt55frgKngvxOsEzJzSwfato5Fkr+xDE69dX72SAHyRk1Im+KUj+kC6vSdmlsQ4UpOOHRHeZnmiGorIMiuDlwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZpCFJ7cCp6ZAqV2j9vkC6lIDX4134nSQAyR4xJGRzw=;
 b=OkFgMEpBqFRx0mxEtQ+YsvK6StXM9yq3hKaCFLYY0Se3YA9hcziKUJGXzDpV8672CDWl1xMu/5CORgDw5dR9S3jiizIAnCUb4CZrfff3tJuWzrFUYl0Trt3V+GhPSH+Vx9whHSih+826yGLwwzRrNZqsAr3iA3oSa5ihVHFBevtSZiG5UjRSt9fq5/SEoM+j93PacMFUfcKD2h87tLqoniQVg7FIq0WTqQpoajeJNDWvoBej8D3L2TV4fzZd4huWfdX7BbfHUgd1JnDPl0/HjdSgVYbZW+41S+t3fonNF/xfGUFYcFL6FJJSpqZw31D1bKN9a66GYfT4xg9E/uxgLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZpCFJ7cCp6ZAqV2j9vkC6lIDX4134nSQAyR4xJGRzw=;
 b=e6aHmOf59BUo7VJeNDsIG66OmV4XYnkalWVlcrwV/0t7hxWPfyYlJ/LDysPQs6vLcOzydLa7gM0hs6YmfLsY/xxq8DyooJ1tIRYdBBMYJtxKCWIyCkjZXQq07ChfFnTh/aoBNSOosxzfnXh+7ossfoo1veA9VpjY7hVGlmnYshSS64FDmW/plBMMi2aboNzZAsr1+UWhHZr4UlIfBld9Uk+le+lhF6tbUuFaN3Mm0c0ZwVEZ9kMgFVHtIw/0k3EUrLtJdbr4iPgu7XHqFXK+epWlJzPzvNE8W9Hdg6tKotlJVDjgtcFYXHXVqC/xU9lL0nsas+nwylq+x1YeBfy7yg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2489.namprd12.prod.outlook.com (2603:10b6:3:e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 21:38:55 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 21:38:55 +0000
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
Subject: [PATCH 01/10] vfio: Simplify the lifetime logic for vfio_device
Date:   Tue,  9 Mar 2021 17:38:43 -0400
Message-Id: <1-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR20CA0010.namprd20.prod.outlook.com
 (2603:10b6:208:e8::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0010.namprd20.prod.outlook.com (2603:10b6:208:e8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 21:38:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJk44-00AVIa-M1; Tue, 09 Mar 2021 17:38:52 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69dc1eec-6450-4876-d7f7-08d8e343bc70
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2489:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB24890C8905E11D12FF61CE78C2929@DM5PR1201MB2489.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R30bNbO3gL67xSg38wlTqNoHgE5ZoIpRIPoPxCpWXspA+2/dbPfTP8Tu2KJJk6lZfJOLQyh1ALMsMZSsaeO8nEHYuZeVRq7V00lSxH44BtzLPtzIRjPrPnzDPJmG0xfWI7KG/8AwWQ/mlbNErTa9EasjOOqhZ2svuiwJ/DKAKlunUu2LZUCOqcUaatHxn5epMJVJOOhlhPJKK1YvT2Bg2lTWGiqHIHP8sixbnn5CofIZtTEqIGj0PVI0OXyTbIBwq/hbI67ne0WJsoHiRjiv41K3DDSbQ/fgfSdwXi7vsYh0LkazBB+I5HQVsn59qM/C2xFtknHtmfQHllJ50i8vhZ9WdivTIbES6YFU3djB0gJLJgB628mTi5BCc9pwjTfrjloiStXrLu1cRWr780qQ0svAGcDVKCwRBEEPqrXa8JpACPfijSmP7eHgU7HrsTU9f0DmmBjauQK47K8pijlHOpIbYHepwlmeBs0o5TggjK+bbA65rNPakwWHloKNORX4GHMcgEcYAzIAbkUSCwKXCOS3YGTzoxNFxfDwXZ5ztk9ncnWRz79WCFUK2F0Bhc3W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(6666004)(26005)(36756003)(316002)(5660300002)(4326008)(478600001)(54906003)(110136005)(9746002)(426003)(66556008)(66476007)(2616005)(9786002)(8936002)(86362001)(186003)(2906002)(8676002)(107886003)(83380400001)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?I5N7wTkM6m8XN/0hS3Q5g48kRtDmjYHX23/2lWvZ7AEidrvjo8pMIplls/k+?=
 =?us-ascii?Q?6x3GLD5RVpizohAH1lYkQ9+Q2rDoWGmeMUStJW3Mh0y+q6E/FhzmWS56jV9l?=
 =?us-ascii?Q?fgcW+cHd0QKKcmMbWWRtX4jIaE8Q4r1D4Qif5gyDQ2XQREuE/D6PFmkRAeT1?=
 =?us-ascii?Q?bE/VctlAay21RJmETDuspC3zwelIeypmyQus6wvvkRDLtMym2kKa57XkqqQ5?=
 =?us-ascii?Q?2UhhUxBwJ9ZfLwObO5CBIpmLy4rVJ0f5SinIPNNpVBnbwVKYjWubvCUWVXhR?=
 =?us-ascii?Q?dOR5+jy1avzOhyfCkjAToe6jxxx2IdTqy4vhow//m1qo9jVxSHrzeKBPvLCR?=
 =?us-ascii?Q?mn7zPGeTRMxbcY9AfCrhFWk2OgvfoVoSyygndadkr/z8J8ZWTxiIEbOjef6/?=
 =?us-ascii?Q?fHTuMsOTmexM3Qfz/cmkD04RqM1529MeK5V4R7i8+QkJXBSSu37jMfFeeSUg?=
 =?us-ascii?Q?IP0MASXSHa0uN7oACunxw5gr4x5YEGP4fWyzK9QY5dFw83envY8nASTKlkva?=
 =?us-ascii?Q?syuMjrcvmmm0/hRthuvaXP5+LFKTBkda0Z5GBW5eW8SaFRZr30uBWnZUC416?=
 =?us-ascii?Q?7waTJq74xvZky/ENVYF3IxGeCt0/ooIgSQcageWstdj2BFN3fuJJVdre3btf?=
 =?us-ascii?Q?AOirg3vZiInLVE1KEfjvaUZkETD9Ix2SFSKtvFZCL9o30Hmsh78u9JU8c4Z5?=
 =?us-ascii?Q?zZhjLpNb1j+83itz23PrqF5l67oROLRqv+7UHMm8qWMIu/Mc7C5EvIJqfBQ+?=
 =?us-ascii?Q?GpYADMi7peT94CBy7InmUWWHGvGPgXQgnZus+J0oLqgrFUYS4N5DKP5kPyBp?=
 =?us-ascii?Q?Y4GdUAFgr6kbsW+Ypg9+0TP1AO0bW7g21Cf14me4CLEqjWqSxgE2aYHJVzDG?=
 =?us-ascii?Q?4IuddD6IOA+D84xKfJhh6E+hJ4YOb4r7VHJ7Trb0ZDEB6nJaP2TcoAQG3Wnc?=
 =?us-ascii?Q?qK291Mf37tnRasl1zk028yAXOypGfDZ8Mfsx1TEIrsdb5GNyWmp0QdPyWFJM?=
 =?us-ascii?Q?PGjT3b3uBsm1yYGx1V5sytLEZiUoeqLUuTCt9gxnl2kD0bXihPCGtmLMNKEr?=
 =?us-ascii?Q?LFz37ek0NimvJ5TondgG64s5c1pz5RCZ6TdhJF7VGalMtWMcjulK/K3eqDH6?=
 =?us-ascii?Q?CmuYMFPkP8LNUVJ57tVHPaN4X/KBOXGoDFLoVTIJFkkU251N4MRqa1yh0y/R?=
 =?us-ascii?Q?5ywTWJUjSibQbTrep2NvC/i238/+0Q9pOmerxoJj1f5GYFxon+YRTEjGKbMs?=
 =?us-ascii?Q?7/DlZkKDw758OmbaEbw1YAWM+Kh7NFG7GAND7LG73fK6qFYdlUuAGKm3G+vd?=
 =?us-ascii?Q?uDFx3EgseN8h/w42WbULqK6PA+weWc9pF1VMg8T/tc0j9Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69dc1eec-6450-4876-d7f7-08d8e343bc70
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 21:38:54.2148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E3Abc73AoLpGfuxOMXqr0NoOD3GippI3m83bJXlfyuUkKtUwvejs6t2izmyuSL2V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2489
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

This simplifies a couple of things:

- kref_put_mutex() is very rarely used in the kernel. Here it is being
  used to prevent a zero ref device from being seen in the group
  list. Instead allow the zero ref device to continue to exist in the
  device_list and use refcount_inc_not_zero() to exclude it once refs go
  to zero.

- get/putting the group while get/putting the device. The device already
  holds a reference to the group, set during vfio_group_create_device(),
  there is no need for extra reference traffic. Cleanly have the balancing
  group put in vfio_del_group_dev() before the kfree().

Clearly communicated lifetime rules are essential before we can embed the
struct vfio_device in other structures. This patch is organized so the
next patch will be able to alter the API to allow drivers to provide the
kfree.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 93 +++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 63 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 38779e6fd80cb4..04e24248e77f50 100644
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
@@ -544,14 +544,18 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
 	if (!device)
 		return ERR_PTR(-ENOMEM);
 
-	kref_init(&device->kref);
+	refcount_set(&device->refcount, 1);
+	init_completion(&device->comp);
 	device->dev = dev;
 	device->group = group;
 	device->ops = ops;
 	device->device_data = device_data;
 	dev_set_drvdata(dev, device);
 
-	/* No need to get group_lock, caller has group reference */
+	/*
+	 * No need to get group_lock, caller has group reference, matching put
+	 * is in vfio_del_group_dev()
+	 */
 	vfio_group_get(group);
 
 	mutex_lock(&group->device_lock);
@@ -562,37 +566,17 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
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
-	vfio_group_put(group);
+	if (refcount_dec_and_test(&device->refcount))
+		complete(&device->comp);
 }
 EXPORT_SYMBOL_GPL(vfio_device_put);
 
-static void vfio_device_get(struct vfio_device *device)
+static bool vfio_device_try_get(struct vfio_device *device)
 {
-	vfio_group_get(device->group);
-	kref_get(&device->kref);
+	return refcount_inc_not_zero(&device->refcount);
 }
 
 static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
@@ -602,8 +586,7 @@ static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
 
 	mutex_lock(&group->device_lock);
 	list_for_each_entry(device, &group->device_list, group_next) {
-		if (device->dev == dev) {
-			vfio_device_get(device);
+		if (device->dev == dev && vfio_device_try_get(device)) {
 			mutex_unlock(&group->device_lock);
 			return device;
 		}
@@ -895,9 +878,8 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 			ret = !strcmp(dev_name(it->dev), buf);
 		}
 
-		if (ret) {
+		if (ret && vfio_device_try_get(it)) {
 			device = it;
-			vfio_device_get(device);
 			break;
 		}
 	}
@@ -920,19 +902,13 @@ EXPORT_SYMBOL_GPL(vfio_device_data);
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
-
-	/*
-	 * The group exists so long as we have a device reference.  Get
-	 * a group reference and use it to scan for the device going away.
-	 */
-	vfio_group_get(group);
+	long rc;
 
 	/*
 	 * When the device is removed from the group, the group suddenly
@@ -953,32 +929,18 @@ void *vfio_del_group_dev(struct device *dev)
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
@@ -987,10 +949,13 @@ void *vfio_del_group_dev(struct device *dev)
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
@@ -1008,7 +973,10 @@ void *vfio_del_group_dev(struct device *dev)
 	if (list_empty(&group->device_list))
 		wait_event(group->container_q, !group->container);
 
+	/* Matches the get in vfio_group_create_device() */
 	vfio_group_put(group);
+	dev_set_drvdata(dev, NULL);
+	kfree(device);
 
 	return device_data;
 }
@@ -2379,7 +2347,6 @@ static int __init vfio_init(void)
 	mutex_init(&vfio.iommu_drivers_lock);
 	INIT_LIST_HEAD(&vfio.group_list);
 	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
-	init_waitqueue_head(&vfio.release_q);
 
 	ret = misc_register(&vfio_dev);
 	if (ret) {
-- 
2.30.1

