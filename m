Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF6542C323
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbhJMOaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:30:02 -0400
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:8800
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235412AbhJMO35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:29:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jslPzk4zBO53DKLt26sKWkk/wIxNHq7Nd5CosIInEaFqsWaXT2T3LQ5Mu2q0keiaTmUY4yYYRWOCY0lU/ZzeSmTzo+5VBV4j16W7gNj6TwW1Nq3Z1RvFROXwVneHVeN9fmolGXc2WmXArpprtb8zsAPvKeQ5aaTiq7txc7xyr3+PtK66AnWg6NoBqVHXc1pYrm/NPsJb20QOlf3WjpmOiK0ypME3YjGZRVj+g2UqBIjs4N1YJX3jBLn5W+h/a3suNfz3K4govsQw+P9kOjrtTWAjeVa+cEoibCIIhnDoc0dAz52xj+fyDx4LmBc075LWmcyp/BAsnnPG1m06zFB6Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElwjP5TANw3ceRfKtGVI4ZwiUq4cpg5Rko8qEJaCgLo=;
 b=eblU06falj1qdGwZ1sfFaSY4AbLLSqha1CmgbJcoH5Wl0LE+Uox0NgszUFriMVkANACWnWKciVx1irNggDNMoloYQ5s9LloZTob+8p74UHTsWK4nW1v2wyVqZ4H8S7deHw9TYcVprN8UbkXT7oVDJQhfzzfOvO4K9RassMeJHAqFCjIzT1gVDi2HBioV/YfCiEIKpyCCSsiReWPg+8e2TLAJ8g/f94r9aI0560EXOJm8a6nvSpc/5M/Ivz3x7h61q6OvNPi73tnPS26O2BehNtwqcfhSm/hTeEhEvfGkClpRgn4V06s9VRkk4hmbTRbnYSyH/GeO12/Ei5R6TeAPQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElwjP5TANw3ceRfKtGVI4ZwiUq4cpg5Rko8qEJaCgLo=;
 b=QP8beC5MDY3VegoIuIzJiHRxChilbnL5BpFTQ1DSZ8sQIKNwsMVZJ1VieXmkK4w5Ifs88aUGA5iePf3Ppy9RNmvnT7jDFilj6wq07/E162k5TMeuRDtJA0IGFNKob/LYXSWXgxtZ0RgR9YDJVRsG9ZLTrDBFYaLtiaVvpMw7UBJVwpSBNdBkszAlsSIdG7bo4yNoJvBGM+hwkQh6gPW3AFmUhZTqxZpDQW7nmpF3BGaKr5K4dLujMu426zCW631YVIC907sXAUXiNQDtXN8wC0emmFpaj9Z0bqsM0oUcHPEREbVjds7+PfZYDrFINTQrI0ONT7cwrTTnucN3wNHRZw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5287.namprd12.prod.outlook.com (2603:10b6:208:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 13 Oct
 2021 14:27:52 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 14:27:52 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v2 3/5] vfio: Don't leak a group reference if the group already exists
Date:   Wed, 13 Oct 2021 11:27:48 -0300
Message-Id: <3-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YTOPR0101CA0048.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:14::25) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YTOPR0101CA0048.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:14::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19 via Frontend Transport; Wed, 13 Oct 2021 14:27:51 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mafEU-00EVFG-8K; Wed, 13 Oct 2021 11:27:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7486f55a-eb2c-4c23-4469-08d98e55a387
X-MS-TrafficTypeDiagnostic: BL1PR12MB5287:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5287B7B9311BF13AAC4ECAA9C2B79@BL1PR12MB5287.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A9cjUy0mANdEJAeYd7bQCfrRlMw2VGFp7maba2HffPH74NDVygNpeHbDMEvzgqhWbZlynD1IUanOUwdOOuznrJeqCxdwoJAMqNBL0Sjk6VWjZ2+BiRIWV1td6Vyzqsz83I6wdbpXLe949VJ46W0WVxPjWrdj2hMUhW2P1BKpSG53rA2kC11ntOUP2m7d9Yide0BBQ2nb9IiA0ZujTXfc3ztQVKMgNOEkMk/pi+sPCJLYLmeyPOrBlk8M5k+SRArsQx18+BhruIqeceK8sr+TggAuA9a4RAuI6rsTAf2g1nvm7uvt2gvqq18Nf8ZXIJ/9ToVU/TUgMexuZBGOag9m6auybDVkRoYP39jN0sADHlc8XBeyajbWXxcbIgVstB2bo+889U4kR4tw8AHSuCVbaCF4ALDp2iVnL/DppfAfq5Ibo+OAyK6LXw6RNkOQZqtE3tslqwvE8Fb9lI2PkpKFbyLED8HnlXMxdbSCUg86zwZjUWrNIKqZ2Eyf6/imJ6jG0z8ILyRDrp2GmC0s1OSps0IP9u5rYbDmVfySk5eEmTbONbTxbwR/Ca44++p3DFKnMG1LWiy2MKawPkAcSXRF4J1EFmtQRyKCm6/p5RW5adtXTQrUHur35Smi2CRkkIPZDglvPuLZ6lTtRpcIcKsvuQYtavaNmul3eoco64sBQFZF3vGsHiG7coqQ2bHEtf9T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(83380400001)(86362001)(186003)(9746002)(316002)(2906002)(9786002)(508600001)(66556008)(36756003)(8936002)(426003)(66476007)(110136005)(4326008)(2616005)(54906003)(66946007)(38100700002)(8676002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ehX5vzGWp7QW7K2D+M3wPOQbg/v8hZMwqiRdCwL5Ju4+/zXGYYozxP0yIdMe?=
 =?us-ascii?Q?OUTFk4qdAIkaIx+ISTR9bv9s+TNG+BnCD+0Kb7N65FrCa9C5WaC8yxVgFXLX?=
 =?us-ascii?Q?kC/bHFmwTrRdvAPTce92UKlO8gnlYeY7Cw+mJGCQijIdCJEuke9cpUyIRH4q?=
 =?us-ascii?Q?7ucpLqE9hZH7gicMfnkt7EPQ5RrD/EfMWNKoQQtXWTYuFYkC/Ob67nLlDP9H?=
 =?us-ascii?Q?nrYlNw18hU3gYdMCt2H5fFNpTIYKC96sEnOeeB/itjAQnaLAC8sziXQYetUc?=
 =?us-ascii?Q?GqDs6VQAvKWf91iAUxQs5yq3Zmri8uM0jww23PEsr4wRECFu6jfLS9lf5Tu8?=
 =?us-ascii?Q?objAL4lrSQw4INYBFCS+xIQXFCF96ctUouKMkIO1viBqdZUv2nfjXgC68qU0?=
 =?us-ascii?Q?xWxYCMwiufb9+c2O4QPwmSZ7SveErhOwRw4OhXJngjh1u9LbsSkuR+z+ma6r?=
 =?us-ascii?Q?6N94V3pvswngCnvIp4NSUKeIB0VVZ1oRd+mSmxXQUoTzCp6Mws8gZF2YTN39?=
 =?us-ascii?Q?LL1DBR1YGSqgHAPMwKfS8szNQZFXnYRZCMNV1w1SP49yj+n6yPg1vvkIvzU+?=
 =?us-ascii?Q?jWdmTxgA3CevhS0xRA8uTDQkZotn/593Q/KPygiZap9EclhQyUwb0fiKgMqk?=
 =?us-ascii?Q?GcumjE2thZMw4r/6bYnPxUGB1vDks9tMTkH3cmaEjANeGcEafFWS0G+PDw8O?=
 =?us-ascii?Q?7JN1QROWG4L9soKpTBstZQ3vy1lhomjw64KDDT5FQBDb2ozADuXK3PQDt0ef?=
 =?us-ascii?Q?1RIPbtFbwL1ibKSF64ekO5L61ZQ6AWL/fyEPkbJPLZz+X6oQOi9Mpy7Mj93X?=
 =?us-ascii?Q?kK/2tfIkt6Lh5NlpjjHfCBL1qGuOlLFAY7hrgx65GYRAIi4b2qhf+PoCgFLt?=
 =?us-ascii?Q?KHwUn13u/kErx9BtHkRdM0t0k91E+kW5DsmMCR7kXZFANGz3ambpf4IdKlS8?=
 =?us-ascii?Q?RLG0bVtDHssjEaGLpkZQYTsfGGVvQurAtNbn/aGJiJo0G9V2X1v1dTd4QZXA?=
 =?us-ascii?Q?r6K08kvaTxbCBQwx9EKSMAGQhhmDDGFkvyWxXcFAm7VOkKoljdAL3bLfI23t?=
 =?us-ascii?Q?v3RncfDz0Omx/8x0SnFhGmGNQU8Lt8/lAr9xHdLKpbTb/4AAaUQ+kwdGuPHs?=
 =?us-ascii?Q?qR1r+z3uO9jRqT5sN91GY2z1pD2WW+rn59V4/RVwztZOokRmvRZEYCBjSImz?=
 =?us-ascii?Q?D+n9tytpxpmW6Pp8pnNvbYugNHbi09EQ1CF6inlvhf2VUnyaTWcFNUtfDxhk?=
 =?us-ascii?Q?5qIbX6t6Q6nz5aaInzWWi4YYgSgnIQf+Mi2PWQtf0v9H9Z9CkbutuKNdWFmA?=
 =?us-ascii?Q?HZlAiaWRCZTwzbvix5Klxtoc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7486f55a-eb2c-4c23-4469-08d98e55a387
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 14:27:51.9936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XkMU9+QkrL/et6ekDfMLk0kYnx0FmgSYyqQx3Am0eRe1JjvLoXkuoF0ZtawKA+pG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5287
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
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 513fb5a4c102db..fd39eae9516ff6 100644
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
@@ -775,12 +776,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	if (group)
 		goto out_put;
 
-	/* a newly created vfio_group keeps the reference. */
 	group = vfio_create_group(iommu_group, VFIO_IOMMU);
-	if (IS_ERR(group))
-		goto out_put;
-	return group;
-
 out_put:
 	iommu_group_put(iommu_group);
 	return group;
-- 
2.33.0

