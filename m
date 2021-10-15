Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E562242EFD7
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 13:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhJOLnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 07:43:07 -0400
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:17792
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235368AbhJOLnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 07:43:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGUc6XQ6S49jpOLla3aQlF7w4QyhIMJiBpxtuQ9vvgJjpBrRZjMpeqWPM6/Ml786jQxIlR8f5ofxE7w599NbKtMzbDhCtSXrIkA6EjObEUQNKgyMWsLxs/XnQIw3JPFjuDSd/2BbCzwjV3OYCj4o6aifhABhL14VUiL9zI00sUIXloK61nRbsLdhQNaWvoIDAnTdWqwXHpz+La/+jDYKPY73l/eK1zK5TwaTem60h0Rl+8QAh5MkuRcx/4IPSe2tn1NwKZYbZgZGDbN21N4T/pGOo4OZZ5uhQpjLp02DnPFp7gP9J/Iq3NVe+OERvMhKbcAE3QwxfIuCpXfLlx9vRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDhDKH9alsJpGT4NYthric2HS4BBX89KvF5hKuYXEDs=;
 b=XduyOqMH2IROesRHBx4/HugyHFxlic3jptBJgPURVa4B2u2UkNU2RI7ysxFAsKbn9uExlWzWX8nLpQEQFIWVyDDhoaIAgnTztwLrhXL+A1haqWJlGnQowTwgT4Je2RA4JcuuqUvIVcyLM+AdwRGXfbsstGajVf5LxVnQ5Vf1eIBPF//ZpuyFd7LGAvr+MRBgJudFYtTY+yEuqww+9NTdvyH3X3TOdsRiZ26CKAIzO/+4nI2DJsQclAWopTG89fWtKmKlIzGvVvsSVJ6+b0647ipE/RkyXssIe9XTwS4TwOy+LZrW26FssD+ZXEiS9jjj6Q6ZAwQAqPqQv166/JiQCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDhDKH9alsJpGT4NYthric2HS4BBX89KvF5hKuYXEDs=;
 b=renvJM/Gv8tnhLVpppbPpocHlkaUMBMso+/+u/U4NgC25DFxsRWixSQ/P5cAl0CUn+vS1MqBwkMn/4NCYmZmUEMzafCCl/ZxjQ4A43q0ZFNLvpHnq6UKgsUgqKRIMGN8r/GAYFdT+cHEraf2bx2k0dYE+fzbjM9KmslszZyZJOJugnre6ZWidauD3qy/qbQpW5y64Zy1WA90XUTiFypVc5AO1YINHbnhZZUYZMc7EkCOIU/Y+42VYyg8AHUrKZyayrDYSATc6e/PqD8MRmTSw/moIjtmCARUfT8e8ML3tDiS7LKbVEfwavHuSky96mDEP6naua/BQuIIP9i+Ft4kcw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5208.namprd12.prod.outlook.com (2603:10b6:208:311::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 11:40:56 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 11:40:55 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v3 1/5] vfio: Delete vfio_get/put_group from vfio_iommu_group_notifier()
Date:   Fri, 15 Oct 2021 08:40:50 -0300
Message-Id: <1-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:208:329::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0065.namprd03.prod.outlook.com (2603:10b6:208:329::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Fri, 15 Oct 2021 11:40:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mbLa2-00FJU8-55; Fri, 15 Oct 2021 08:40:54 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 665c5d9d-8b3e-41d8-9561-08d98fd0a675
X-MS-TrafficTypeDiagnostic: BL1PR12MB5208:
X-Microsoft-Antispam-PRVS: <BL1PR12MB520825A873CBD72CA80EA8C1C2B99@BL1PR12MB5208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R5g/WDWIHV1yJ7W16RBKtPrHBJpMFoq1b4WyTvwp19+3TpE1BReuZsH4VZrZ9k98gA+2sSJ0BZyDTyyE6iZ+AF3BrJy1+auD0g2yWONx+JT/e+kXZYGIZqjU6+Wy29zAzSrS43XiIRVokfn0ScuwXQHjqon6wqL3epUWBABhgj17U60Uf9c38Ch1V9gQeBI/J1xYY0co3zAByPVx9oX6rYQpv6pRgfuWfGp1QJpPYrrHOaUQMMKMt/SGDTKDrTUPg94lYRLitHcbx/ZWsJnYLC5FM1BKIUG6mhGx/AwSAIgAvOyTjO8yDRto8pgLw5nUaOXUHiIdh8rAQp6lrxRwGxcZBauoWzkywc3PGLvavr/AcZ0z5ReUeRlIXfbMJ7GBjFdIBLVH0FK4suFe1tp6ZOLQDfPODiogk4soRlDIdXfSyP2luY0Q4OC1hBIOz3J9Q3JBpznJTtaKIpzxXeplnpAiBn83nQ0BrLcGEww3nsoA9FA2pCCEMSCCZPThkqWz696ihrUyeu46bNfqyEjdllmiJ3fJdZCq5J3r6UyeyaL+Lq68YTB9S0Ia3pDytkEQZEPq02mdS4JAAlScRET/uZqTMCDP/dyj7g+enR2aDOJ68kBqPOVS5QtvqU1L5zqPxg2611jAlyZy4LmnvbXyRzniRyW3U2qwx59VAAmYmwBXrXbLoooKHizxv8sskni7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66556008)(38100700002)(5660300002)(8676002)(66476007)(2616005)(83380400001)(4326008)(2906002)(426003)(36756003)(508600001)(6666004)(86362001)(186003)(316002)(110136005)(26005)(9746002)(9786002)(8936002)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jJm/U6s5Q4wwvRHmV74VjH3mjGeUz12ALdqAISIU5IHXHLiEGWtloCexZFGl?=
 =?us-ascii?Q?00TnzS+SC9PIF05MIhxDtYms74www395vPtTigT+q4swNEPic5uD4Vsu56o2?=
 =?us-ascii?Q?yXcTOgM5W2ae3TbgHngYc5JzL/6jUPMBEZ20WdGnwnyXtHUFOD/aEmWL0DbB?=
 =?us-ascii?Q?dB78E+RciKDqFWnj8oTSGcJQ0vZ8HXFlRk4ZgEgWGI9MwDCzWzOovIe96NrD?=
 =?us-ascii?Q?+tGciSh5vMMF7B9Sel+RnlgW44UB6Fziwi8Nd7t0dl4OZ2xGSlfmHoIUveTK?=
 =?us-ascii?Q?MpRCLb2Ji6UJcl76icCVUm1TnLkaEEz6B2xd9ow87NOviBouNZZ6Ltxu0Qxq?=
 =?us-ascii?Q?IL6A/S9o7ZnY0+3akUA6GM5PvvDY9sDwqCSywSFD4lOt54x9GEEE/+CcyEJq?=
 =?us-ascii?Q?sh05xluqlxPg0k5CLVLekaK01JR2k17oBk0Wz3loedMy3qx7NSGykS4PkYcv?=
 =?us-ascii?Q?uROkhzn1YxDJwFWg/H2EYB0Z1i5GBHbh2foBMoLvFSU9cmCwQHOcipcAdO5q?=
 =?us-ascii?Q?yHhgmq1QdkcZ/JIMM0dkMfEK1OtZGRHM3xKbbIAve/8H6fScdm0hv4sE4u49?=
 =?us-ascii?Q?zhiyz60tkv8VCXYmShE5nb1/hfkU3l0cfaCvvZiIeTvCmzSMVVBXWm/6KBlg?=
 =?us-ascii?Q?QEQlLKgyOK07OcZ7mmUpKdLJZ0fWu6IDcb5tjsMgddL38PJXthmz8djelPzl?=
 =?us-ascii?Q?OhQfaUhTHke+mPgUUyeYssqOE/E/LuJhfeDxtGT2aFxZ1Fyfo6unnxQCZn0r?=
 =?us-ascii?Q?b5NGHyW6fGKxzejPldrytqYVMO9Jx9OgNu7y8MfxSphujUFgirL+f56ao8u0?=
 =?us-ascii?Q?UD9+jyoQREMC6w9Z6cQ+Gc60yYR7kNve6PdxCE/Dv1qb0BpZKhDpjPNf1oJl?=
 =?us-ascii?Q?P4tv6IW6yWbF28GBSNBRDENHtNRr+2K3RPfQYeAG+v+dDKzRRg5E2C+Ii13R?=
 =?us-ascii?Q?fhQakJ5JEtSzQ2gb+5BBG+UApGc3740jeE3vDkDBLwYCjYgkxfNjG8tVJR5Z?=
 =?us-ascii?Q?PbVBJYyao6x655bTKS3RZe4F2mkO4ineADP1b7YDu9c7nT/DqiLauQSpeiCW?=
 =?us-ascii?Q?HBmk0JXwcNP6kemisNMGHgwWI4XMRDEzLF9WRRTy3FYtTmNyuMmja2NltiPI?=
 =?us-ascii?Q?Q3GZmvkfkw4khDTbjw6jeqclgUAITSChDlDdKRsACbgZJy1ksCoDT3ViuiV/?=
 =?us-ascii?Q?B6WQ3Nl1NZoR4W7OH7Bdw+J7hGZSFMYrlzqYNwCsn+7Y/wyJKR7cOdOwGdhB?=
 =?us-ascii?Q?KeIb+C108Dqxj/jpJhHK5+kS6LNjRXZcgQMC+I9HNY1JiXXEgBIA6EBYSEir?=
 =?us-ascii?Q?Pw5nKAyPbGyf2vn2n/XNMnMw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 665c5d9d-8b3e-41d8-9561-08d98fd0a675
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 11:40:55.9484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQxd8GdysoRmh1jiMLciPS/iD9q6eXYbI6Uq/JGQvyCZdyvpWWRZAmKD3pagNFe6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5208
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

