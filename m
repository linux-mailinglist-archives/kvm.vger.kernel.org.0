Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCDE42EFD5
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 13:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbhJOLnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 07:43:04 -0400
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:17792
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232456AbhJOLnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 07:43:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZlQucdHm2U4OOlcC/fNTIN9T5D9nv0+YyGqgTfhVu3wXZRlx013om8bZRpR6wRv+lZ22+btIaMhcGXkuti2V+XNVx7VaYFcfNS48eeujoormxm21Pg0ERpj+jVUslJLvm48iUCn1yilZ1LGVGaYhAFbrBcTn5U5D4FtY0m6AHQiSnkWdpQSmla7JxB1RC4mvQ3F02SLWiF+sUerTjHxwSVX88jk9EKGCtW/em++W6OZHO+K3PUFOVp6JJCtw1Lornmb7OqjvCyRH8h6VfLpWxYES5ckLe4JgYeOp1JurwX79BE5ALdf+JalS7ihBrUVgaufiCeVxtfID4KuTqd16g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wGmKCYrL7wWpmvK9S/XUodbWLcpli+XIu3G86VGLiYs=;
 b=iM1PGJOqwWkjOJ/pV3glaM1mygv9iGOER01/Vi9JWcYYvDZqcO48w7Sf6iHe1ZF7SuDbstB4L/QQrRqjmBPXK+s2v9RVWeOkO6e3GYsEKzK68132Wpo0xpIP0Djl4OJY8cMIDmD2dcBCx69SagJ67QriOqNa2h75m/YCm24MtQIy42qvInmsdnuRpj51Jiulq4fMMS29dAlkv/7A4P1pFBWf+b+mwr/NFOJ/1pgLN0QEOQkUGRdiH2BuU9gqXUwf/edeBckr3DYRyjF+cNBnRjJ5bUM+FBWNcMznTE2FoV8tGIiUv5EcYt3vZul6RQVRGLn95nlzvfdfpjNWb5KyEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wGmKCYrL7wWpmvK9S/XUodbWLcpli+XIu3G86VGLiYs=;
 b=C1YeWA4yIrzuW5i7Hc4p9lnxgNxHSlCm6qPNd/8Jtubn1a/npV3lZ59NxnHuvbGxDMLlhm5pstfm94CeyHX7VBRIaaI3phOk/19aM4SL7liMV5hnnS/CoPjgmCKEBlC+nD07HkVR/goVoU+nu7zB2R+S/BGiLwm2pOix+rsDdrZ9FF4PlCycuKSd05n6mYCkXVqg9b8XpmqsQAnUvz9hGb+VsGNw7P0v3Uyn4/kzqC+1K3B4yOpiMxQQfL2DoRYnRLS2Lo/27CFIFuk6Iihd03BMXiRIcCFAKHfxDuTk++sNrJFgR41HzYl3aKLKkcmk5Zy0CxabzZjGgmdstMvOBQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5208.namprd12.prod.outlook.com (2603:10b6:208:311::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 11:40:55 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 11:40:55 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v3 3/5] vfio: Don't leak a group reference if the group already exists
Date:   Fri, 15 Oct 2021 08:40:52 -0300
Message-Id: <3-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:208:fc::38) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR02CA0025.namprd02.prod.outlook.com (2603:10b6:208:fc::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Fri, 15 Oct 2021 11:40:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mbLa2-00FJUH-6s; Fri, 15 Oct 2021 08:40:54 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1754a52-fd0a-48a7-a9df-08d98fd0a5e9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5208:
X-Microsoft-Antispam-PRVS: <BL1PR12MB520899BDA2BE6D3A84973947C2B99@BL1PR12MB5208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jt6lLiKfCeEGD+H2INm9US5+vws3UjKMSf/ZbDjxXpWHNr6/Y3zwrlPNhcaFitTf9a0YOL3iYquxRkhLuE6zOmzr7gmsqvqZghOpuSJJ9cyJaBDvxIKBRW2MGuUwqBdaRJZhqbsKx86OJ/VwGgfxA/znsEYTRrwOd20x0cp0CNOJ17Rd9JrewrGz5FDdCI5lHVUjKxQ1jMFOi26uRt8//69PBAr/iRA3KSoGUhiO4i1I5nwC7jDS4B+Jw5WNOz3rmN46mFgUn9FO6bhLIwcqGmRXFOkzW1fr16DKzP4Sqb2ZMEHykMUMJu2Qgcjezz6fZLo723yIiZDwybv4b7WU6ZpopOJlOBNH7UgR6Vbf94q0vSiEaV0UKmh+RD66IgVdKSgxqEH6zTLTebNu87F/35vTFZPd8ImJpsuYKh6bUaRFaXCeY1hUeN6TxtHlFXRBsyQ7KEicOYw4gaXyleWcSzs2RbOc3UcOJ2QMe7wRxdY0f0kVMcktFjTfGqY/+ahXcZF6FcpJjRqojOENk1+0xVsXSszuSzO+5NBqjitQZUetF0rfYKeMV7XG9JWEjUPl3r0AGa54x+Hgvnz4fBzq3POAeItH7MFWBEKbSyo9En9c5TppIptjB5mYHaziQWviaF6uOH/33fcZj838+8fWm2tM2/StUKtW3UA3vyGKiyAVfNo2GkxPQWE7U8UfvAfK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66556008)(38100700002)(5660300002)(8676002)(66476007)(2616005)(83380400001)(4326008)(2906002)(426003)(36756003)(508600001)(86362001)(186003)(316002)(110136005)(26005)(9746002)(9786002)(8936002)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k4qkEAGPXtDRNO3PkPCpNmxqBUKLLnvm9rWh/AoogIzDXGMtC2q1R5apIzEv?=
 =?us-ascii?Q?3rNP1lMGh+g73mV2pH16e1onWbU8lxaX3qXvNwJHiMemCbP8xj3ulBNjI5q+?=
 =?us-ascii?Q?5rkG35bnx1C1DJ0iaQb3lPY1Lp8DZ/r5OzXa1pIK7TOn793evfHBRZ94x09l?=
 =?us-ascii?Q?8X+2O1ESPWkrLCXi8JmOleB1XprkdVQiqk8Yxk4MsdXLBUruXoaydoRqiRGo?=
 =?us-ascii?Q?DJpMAsugoDtQcTX25i48sG/5SfegQ63tLwFZzymAGa1EB/SL60Cg7+Z/0dBw?=
 =?us-ascii?Q?dCU3QCdX5VE3jhRKWo+TA1o2VotzVkZmfNdvf+UVAoEeRDANmrsRyUfu8Thn?=
 =?us-ascii?Q?wlOpZpuKIHOks0eqyGjE1NOg1jor4rpJB1Ft/+XYfpwyEejaWYj1STBBHv/n?=
 =?us-ascii?Q?9D0ASyW6LTk4sh5CCvLyaLQsJi2DOWgWkN0dRQvnf8tZr/o7P4jNEWHhEvJS?=
 =?us-ascii?Q?OcVsXfrcGyybJQ298YPkg2J6XD3FczGhhQFxT9P0CQdDZBp0s99FY8sk4sB7?=
 =?us-ascii?Q?4g4Rm8h8Q7kvLavbMlRW3qBTNDZ1vU1lmrINpZhQRJod4p2lqvRI0OvS/7sG?=
 =?us-ascii?Q?8oed11Gx2/9pwAERRDhjyoj/mmJzzjqiXbbLi8GReByL5jiIZ9XK+8RhdDhd?=
 =?us-ascii?Q?5RfgoZqgL2USlcdAIqAyDV6uYu0kcygqwCK54M69HE6SoarihOITuBnHwwI1?=
 =?us-ascii?Q?u+QtRUUN0dDNf79bKEM5Kj9of1fNdB9JOTgZ5ImDjAUAX3O5fKgw2F65UHev?=
 =?us-ascii?Q?QWvkwfV2dJePj+scHgGOTEN72l265W5CBFNnE3+t4lU65P0Rtbk+Lfzoj4Ov?=
 =?us-ascii?Q?hr/3z7zk9skKf3GEuR8F37xBKS8gCCimez7kFmi+SnxnZoCrW9fVFFBk7vJb?=
 =?us-ascii?Q?mBj4vkIxkzBVSwyDq45kDKlijp2aQHV/QIfIQGF4kdgD79Wm65fwDq5gy0+c?=
 =?us-ascii?Q?QmueALagzDTFc9Js3XlsrDW8o+ORDSY9DXQKaVVLMgf+9MfWolUarzSLIcGZ?=
 =?us-ascii?Q?I2ckJxR7Azz+IFaUh+KI8eTmwc6WXhZedPYp7yyzGEPdpKba1BIT3Od2krId?=
 =?us-ascii?Q?8yp0jRjPHHbtmkqHNPmKv0cEMwS6SpX9XV6RzKSvkVTwy5ARz1sbJxqSm+QV?=
 =?us-ascii?Q?93i2NH2sSCDhn4gqKsC6i7Gd2XUCodAP/crMtN/Pe/NPalX981DaJZ3vn2yS?=
 =?us-ascii?Q?9wv3jt8rE3gKRK7UT848cCG6Oh+fyiS+WKU06F0Af7Iw23k3UK9mkLxDTva4?=
 =?us-ascii?Q?fbEcv5LcFSxS6xGYN0YB9mTjOrLMrIw6u+cF0iMEgUP3gjfujBV4tGCdCa2w?=
 =?us-ascii?Q?dB0CoUyPScDtFdV8ytjtUoAT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1754a52-fd0a-48a7-a9df-08d98fd0a5e9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 11:40:55.0443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZazhcobjkuzbxAk/seQEr/zWhPUwSRziScX9Hi8mZMccur0kUDaEywtKeT26ocbv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5208
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If vfio_create_group() searches the group list and returns an already
existing group it does not put back the iommu_group reference that the
caller passed in.

Change the semantic of vfio_create_group() to not move the reference in
from the caller, but instead obtain a new reference inside and leave the
caller's reference alone. The two callers must now call iommu_group_put().

This is an unlikely race as the only caller that could hit it has already
searched the group list before attempting to create the group.

Fixes: cba3345cc494 ("vfio: VFIO core")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 513fb5a4c102db..4abb2e5e196536 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -334,6 +334,7 @@ static void vfio_group_unlock_and_free(struct vfio_group *group)
 		list_del(&unbound->unbound_next);
 		kfree(unbound);
 	}
+	iommu_group_put(group->iommu_group);
 	kfree(group);
 }
 
@@ -385,12 +386,15 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	atomic_set(&group->opened, 0);
 	init_waitqueue_head(&group->container_q);
 	group->iommu_group = iommu_group;
+	/* put in vfio_group_unlock_and_free() */
+	iommu_group_ref_get(iommu_group);
 	group->type = type;
 	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
 
 	group->nb.notifier_call = vfio_iommu_group_notifier;
 	ret = iommu_group_register_notifier(iommu_group, &group->nb);
 	if (ret) {
+		iommu_group_put(iommu_group);
 		kfree(group);
 		return ERR_PTR(ret);
 	}
@@ -426,7 +430,6 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	list_add(&group->vfio_next, &vfio.group_list);
 
 	mutex_unlock(&vfio.group_lock);
-
 	return group;
 }
 
@@ -434,7 +437,6 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 static void vfio_group_release(struct kref *kref)
 {
 	struct vfio_group *group = container_of(kref, struct vfio_group, kref);
-	struct iommu_group *iommu_group = group->iommu_group;
 
 	/*
 	 * These data structures all have paired operations that can only be
@@ -450,7 +452,6 @@ static void vfio_group_release(struct kref *kref)
 	list_del(&group->vfio_next);
 	vfio_free_group_minor(group->minor);
 	vfio_group_unlock_and_free(group);
-	iommu_group_put(iommu_group);
 }
 
 static void vfio_group_put(struct vfio_group *group)
@@ -735,7 +736,7 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
 		ret = PTR_ERR(group);
 		goto out_remove_device;
 	}
-
+	iommu_group_put(iommu_group);
 	return group;
 
 out_remove_device:
@@ -770,18 +771,11 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	if (!iommu_group)
 		return ERR_PTR(-EINVAL);
 
-	/* a found vfio_group already holds a reference to the iommu_group */
 	group = vfio_group_get_from_iommu(iommu_group);
-	if (group)
-		goto out_put;
+	if (!group)
+		group = vfio_create_group(iommu_group, VFIO_IOMMU);
 
-	/* a newly created vfio_group keeps the reference. */
-	group = vfio_create_group(iommu_group, VFIO_IOMMU);
-	if (IS_ERR(group))
-		goto out_put;
-	return group;
-
-out_put:
+	/* The vfio_group holds a reference to the iommu_group */
 	iommu_group_put(iommu_group);
 	return group;
 }
-- 
2.33.0

