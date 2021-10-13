Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B066642C326
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbhJMOaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:30:05 -0400
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:8800
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235933AbhJMOaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:30:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJExGNhGT9b2aMB16I71xwf3W22EVAfUNl9KP5HVVSVUDRZt3cshU1QJW1pQ7WmDnjpWmWR2ELZ4FsVCiGb7pNkqBI8pdsXi/SJT7Wf1Vb6sgH6ddmZ/Qa23ZVQn30NVQNkNUkRGZ2zZO9HTKXl76UlZbbmSfqk9+GN+mTYUafC3qCTlHnbvoNlJGiP7jTiskh9b6OWlCyzm08xHENzhNNjmgbnNkVrokzU7F109M8Od2txyigxnk6muOfR4TbCzoyOjl1+GL+mFcjjvHWUhGKTD02wCweTI2MHKe/t/qUn0uM/vNFM+oi8mCIfjL3Pth/PJzbaOoLisOPCyXkE2dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQQup2nYdhO5QI0x1ZNHggRi4dO8tQm4LqSjXz0AJ4g=;
 b=ZUaR0k5Nn5q0vs22GKcK1l0QqRlsAm6JvYJDpMg0Xr6WSyZ3kS/wUNTNH++vmOmySUw4EPTQ+V3oJntOSt4BpptSg4yjjUO7DnIFXZKm/myUSqVbYIqwH2MrTAInpbLAYDq1aLnCZ5wBHymrY16ELM11S3u07hgq70VDiTT9jjpQYpgvWsWqj5tqufTH1AkWOBZVIZx4sAxYmmwocPh00GAXXtxRzB7S2QCMQ5JeLF6ioZ4wF+v34Hym2xAabklA1hxt73wnvrlJUUgvDwBysRiaaGFmZXVv0blZdCI2NHF3OYKwiRBUCZIBJR86qtYZYsFC4T57KOEvkoSUKPnF+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQQup2nYdhO5QI0x1ZNHggRi4dO8tQm4LqSjXz0AJ4g=;
 b=RdvoNt2Un76+egN0MGtcf5xqNnWhZ10ZzxQkbMcc0jONo2MnOZqU6naukTYhrWinCsHiL+XF2RO5qZNQ5PQlLuD6PmNa79V/9kHY6vPbriP4jvmP1jUZZPUsB77gn6KdMuN9pvvZO40UuR4YvKI74MQQb1in2kdSFSBsWYpPYDyGmVJI12PAkHeNi9FbCSzbrGbQ+1wuR/3/f13kpLuWgODS/arCbaR1jBYs7CFllpIdZACFrqu0w9Ivk5mUPmf6pqRbONIVeBweOf1qxw/akCrZbuouzKVEyoNnzplMjdjRMH8z9c8QIK3PO586wJt8HpqOjkrtRQiCCFece6lpFA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5287.namprd12.prod.outlook.com (2603:10b6:208:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 13 Oct
 2021 14:27:53 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 14:27:53 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v2 1/5] vfio: Delete vfio_get/put_group from vfio_iommu_group_notifier()
Date:   Wed, 13 Oct 2021 11:27:46 -0300
Message-Id: <1-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0048.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT3PR01CA0048.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:82::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 14:27:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mafEU-00EVF8-6Q; Wed, 13 Oct 2021 11:27:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 809f8126-0add-448e-f27b-08d98e55a46e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5287:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5287E22EDDA43E36AE599184C2B79@BL1PR12MB5287.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nHUzLsXp/iE/YX3fswh+3LQSeJ9OMoUVWzf7JilaRfJXMc/nqEfN9yoWs5F9xRIEQCsP537JPSr/TS63zIwjaLCNFfmJ+KsFgRrLWgS5aOCrrxOJ4YDWSfAWGj1E8ZF/S29oPvtRh5vEy///+R3SIrX6BCcdZIOEnEave2m/3yOIaWhyewL53g0s0/DFZETiwvrWVzGZeb0st6+3577E1rgZrc8T9/n7S/O/HZiZPDdMnS+95hDyKQ1gSE8iLkSZh3kFKFxIc99IKjoitXO3QvSxPwEiPxSEaPWMDNARX7014xdqmYeJw20PaB9bU6rxFC98Au1OBKyhmfpLZV4Mi7/a6FgqJorCncJKsw1BR4FwqEISN3cv8Y/LpvUpnsZvvYhuUsSekJullqS29op+2IxTtU6dD6hV63h0VZRYuM/2VxaV3FpRMUozRYvV+qe3G8u7CmQT77MafDtKI7e8pcclhLVt1dueLL3+z7i9wqTLksJ4x21wqZSIBTf+4zvagZCav+++YF7MTVKVFyALipy9/xM7OjfsG9gS+ow50hUebxn9vN0tBHg8WawgbUDH7smXdDykaKMnVipXBhkb7EYewCuOP05c0HNDOZLe7xhBNvPIkn3uM3PkbVKVm95sbAgenA3yO63+FSwglTUUOqNsZNjZrn44j3tVB//qZ9BUYyW6GF35YdIGJ3K8lS01Q6uj3yLMBFZyLl1k7TbzOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(83380400001)(86362001)(186003)(9746002)(316002)(2906002)(9786002)(508600001)(66556008)(36756003)(8936002)(426003)(66476007)(110136005)(4326008)(2616005)(6666004)(54906003)(66946007)(38100700002)(8676002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YvZz/taCNS2NuIjYls4MLcdJjPslt+BdJmsPtDjjsn6iYAWRd+YJAyh7rIRv?=
 =?us-ascii?Q?OzX4isO5/VxGf+ofLUK5kyzgHiKN2MCcAzKokPvxpaQ8wA/wRfTgI3ObYpEa?=
 =?us-ascii?Q?ZMcA3T5jwudsINx5Qy1AF09iSW0yIirpTHSDSrtIzJs2RprAk7NsXYbptBg4?=
 =?us-ascii?Q?m2xGNjUJaDKUgaVVZleTZHKVfJhHyfWlyZtkGiVagSx4Eb2cLUp2y1kpUWU8?=
 =?us-ascii?Q?aaI465u6/xaaHYRR95Sldt8nwhiqWm5rk3IntNeCyFRoJIq/zIJ1BdLJpKl3?=
 =?us-ascii?Q?kXGl6jk8kiSnuy93V9L8uCA2KISoh9M//VOGRGlIU3mFWNBBt5D0f1noLnZr?=
 =?us-ascii?Q?9qqLF40ZULKT3StI1e3+JSV3AvsGZJ7NKGFOCJBnSgck7EBIt0VHRe+M4Lw8?=
 =?us-ascii?Q?rXDSfxz4pRbZKrFXuNbnIsyytonJHnEaB6spIDdMuvKhXxYOWerq3NJAX0TF?=
 =?us-ascii?Q?yrcNyC6JjPbx398K1DNqxFzafrCWpe6M45wlt67Uy9H4bnGgP9+fmbK7E7/7?=
 =?us-ascii?Q?buDur1QKZNeUDH4vAcQ1a8WHh2y6x3vOjpQ+9MKlCH8uk+of+HhYtKEbOsB6?=
 =?us-ascii?Q?45gxAiAUW18/pLyrLcuA45FPjSvJCHtWgvWCeAc2pTZiuY5JcoMQ5SOdXYXw?=
 =?us-ascii?Q?RJMgN5bP60x7j+X7UbwH8DwsGMikyiR7Fof8eI0qzgWzwlXm779GqKcy6wXy?=
 =?us-ascii?Q?O//LN2MLDES0st5s8PYUUmDd+V+HA0dtKwSGjpYIyG4TSeeMW40cexUyswsn?=
 =?us-ascii?Q?3APt1rqey9ceDAQBttw6N3vUxdDKTRGCW5U7Lom3lCAKI78qTKvjsWQaU5S9?=
 =?us-ascii?Q?/qJRAS3+NvpV5HzoGoEEQwcKyZEOFyWrPv9MB+JMnNcgmWoWrtuanpQF96xX?=
 =?us-ascii?Q?p2r0Ya6uJmG5aLqv5pXSguUuIaDDWPN1n/HIomWEURIa4kMj70QrFgbdDFRN?=
 =?us-ascii?Q?JhdujIJwFYBvBcELr4rDPKFJRupavMPho3qc2c7gcSlFKA9nw8CgeY5jRfnJ?=
 =?us-ascii?Q?eF9cRHdVjbRk6H0+N4IedZ1/pJeb9JyzLUXxB31AcTQ2nJrTfEXYtBkND5V5?=
 =?us-ascii?Q?DypoQYwCqQdmsJwHKw+f4aVKZd9Dlk6q9wrEpjKBxlrQOLsL7hEteNCMPhx6?=
 =?us-ascii?Q?W4+3IUgbpBvul8WEYTnfDFiKdIxGzmGyc68Sr2vbY98Upr29DX55qKwwDZhS?=
 =?us-ascii?Q?vHr+fMikorQdHLYa4QY1aCud5OfwO7+H9Zb2T0rEI+A8Ak81tpqoIRFGgeNw?=
 =?us-ascii?Q?1EfgSAV1Ee/AW1NnaR8aOzNvMTLZG8EfR9WveVoB57+If9oEL0+WkE4nvnRm?=
 =?us-ascii?Q?FxZTisSgyZX2wCajJG2PS7Rb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 809f8126-0add-448e-f27b-08d98e55a46e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 14:27:53.3467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/JZ9FNl30NaAaLI/9dBKnJYHHFRlzpeD/5fsceKTkhzRWXDHrdWIyqKA43qffVa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5287
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

iommu_group_register_notifier()/iommu_group_unregister_notifier() are
built using a blocking_notifier_chain which integrates a rwsem. The
notifier function cannot be running outside its registration.

When considering how the notifier function interacts with create/destroy
of the group there are two fringe cases, the notifier starts before
list_add(&vfio.group_list) and the notifier runs after the kref
becomes 0.

Prior to vfio_create_group() unlocking and returning we have
   container_users == 0
   device_list == empty
And this cannot change until the mutex is unlocked.

After the kref goes to zero we must also have
   container_users == 0
   device_list == empty

Both are required because they are balanced operations and a 0 kref means
some caller became unbalanced. Add the missing assertion that
container_users must be zero as well.

These two facts are important because when checking each operation we see:

- IOMMU_GROUP_NOTIFY_ADD_DEVICE
   Empty device_list avoids the WARN_ON in vfio_group_nb_add_dev()
   0 container_users ends the call
- IOMMU_GROUP_NOTIFY_BOUND_DRIVER
   0 container_users ends the call

Finally, we have IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER, which only deletes
items from the unbound list. During creation this list is empty, during
kref == 0 nothing can read this list, and it will be freed soon.

Since the vfio_group_release() doesn't hold the appropriate lock to
manipulate the unbound_list and could race with the notifier, move the
cleanup to directly before the kfree.

This allows deleting all of the deferred group put code.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 100 +++++++-------------------------------------
 1 file changed, 15 insertions(+), 85 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 08b27b64f0f935..4ce7e9fe43af95 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -324,12 +324,16 @@ static void vfio_container_put(struct vfio_container *container)
 
 static void vfio_group_unlock_and_free(struct vfio_group *group)
 {
+	struct vfio_unbound_dev *unbound, *tmp;
+
 	mutex_unlock(&vfio.group_lock);
-	/*
-	 * Unregister outside of lock.  A spurious callback is harmless now
-	 * that the group is no longer in vfio.group_list.
-	 */
 	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
+
+	list_for_each_entry_safe(unbound, tmp,
+				 &group->unbound_list, unbound_next) {
+		list_del(&unbound->unbound_next);
+		kfree(unbound);
+	}
 	kfree(group);
 }
 
@@ -360,14 +364,6 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
 
 	group->nb.notifier_call = vfio_iommu_group_notifier;
-
-	/*
-	 * blocking notifiers acquire a rwsem around registering and hold
-	 * it around callback.  Therefore, need to register outside of
-	 * vfio.group_lock to avoid A-B/B-A contention.  Our callback won't
-	 * do anything unless it can find the group in vfio.group_list, so
-	 * no harm in registering early.
-	 */
 	ret = iommu_group_register_notifier(iommu_group, &group->nb);
 	if (ret) {
 		kfree(group);
@@ -415,18 +411,18 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 static void vfio_group_release(struct kref *kref)
 {
 	struct vfio_group *group = container_of(kref, struct vfio_group, kref);
-	struct vfio_unbound_dev *unbound, *tmp;
 	struct iommu_group *iommu_group = group->iommu_group;
 
+	/*
+	 * These data structures all have paired operations that can only be
+	 * undone when the caller holds a live reference on the group. Since all
+	 * pairs must be undone these WARN_ON's indicate some caller did not
+	 * properly hold the group reference.
+	 */
 	WARN_ON(!list_empty(&group->device_list));
+	WARN_ON(atomic_read(&group->container_users));
 	WARN_ON(group->notifier.head);
 
-	list_for_each_entry_safe(unbound, tmp,
-				 &group->unbound_list, unbound_next) {
-		list_del(&unbound->unbound_next);
-		kfree(unbound);
-	}
-
 	device_destroy(vfio.class, MKDEV(MAJOR(vfio.group_devt), group->minor));
 	list_del(&group->vfio_next);
 	vfio_free_group_minor(group->minor);
@@ -439,61 +435,12 @@ static void vfio_group_put(struct vfio_group *group)
 	kref_put_mutex(&group->kref, vfio_group_release, &vfio.group_lock);
 }
 
-struct vfio_group_put_work {
-	struct work_struct work;
-	struct vfio_group *group;
-};
-
-static void vfio_group_put_bg(struct work_struct *work)
-{
-	struct vfio_group_put_work *do_work;
-
-	do_work = container_of(work, struct vfio_group_put_work, work);
-
-	vfio_group_put(do_work->group);
-	kfree(do_work);
-}
-
-static void vfio_group_schedule_put(struct vfio_group *group)
-{
-	struct vfio_group_put_work *do_work;
-
-	do_work = kmalloc(sizeof(*do_work), GFP_KERNEL);
-	if (WARN_ON(!do_work))
-		return;
-
-	INIT_WORK(&do_work->work, vfio_group_put_bg);
-	do_work->group = group;
-	schedule_work(&do_work->work);
-}
-
 /* Assume group_lock or group reference is held */
 static void vfio_group_get(struct vfio_group *group)
 {
 	kref_get(&group->kref);
 }
 
-/*
- * Not really a try as we will sleep for mutex, but we need to make
- * sure the group pointer is valid under lock and get a reference.
- */
-static struct vfio_group *vfio_group_try_get(struct vfio_group *group)
-{
-	struct vfio_group *target = group;
-
-	mutex_lock(&vfio.group_lock);
-	list_for_each_entry(group, &vfio.group_list, vfio_next) {
-		if (group == target) {
-			vfio_group_get(group);
-			mutex_unlock(&vfio.group_lock);
-			return group;
-		}
-	}
-	mutex_unlock(&vfio.group_lock);
-
-	return NULL;
-}
-
 static
 struct vfio_group *vfio_group_get_from_iommu(struct iommu_group *iommu_group)
 {
@@ -691,14 +638,6 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 	struct device *dev = data;
 	struct vfio_unbound_dev *unbound;
 
-	/*
-	 * Need to go through a group_lock lookup to get a reference or we
-	 * risk racing a group being removed.  Ignore spurious notifies.
-	 */
-	group = vfio_group_try_get(group);
-	if (!group)
-		return NOTIFY_OK;
-
 	switch (action) {
 	case IOMMU_GROUP_NOTIFY_ADD_DEVICE:
 		vfio_group_nb_add_dev(group, dev);
@@ -749,15 +688,6 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 		mutex_unlock(&group->unbound_lock);
 		break;
 	}
-
-	/*
-	 * If we're the last reference to the group, the group will be
-	 * released, which includes unregistering the iommu group notifier.
-	 * We hold a read-lock on that notifier list, unregistering needs
-	 * a write-lock... deadlock.  Release our reference asynchronously
-	 * to avoid that situation.
-	 */
-	vfio_group_schedule_put(group);
 	return NOTIFY_OK;
 }
 
-- 
2.33.0

