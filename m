Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF0341F82D
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 01:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhJAXYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 19:24:18 -0400
Received: from mail-dm3nam07on2074.outbound.protection.outlook.com ([40.107.95.74]:12768
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231265AbhJAXYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 19:24:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKQi6teFPoUx9fL+0m8aVVbsKxolVtDzjaQYW6xBBIA2nUBP+l6tU3b+kfHgoATal341BdSx19djto4RopnrQfLHs0+JHTpkjV27+yCCOQnCTZhYA3DW5/O4MKRDFRm4+saGMeTtGTVkXBmpGeQKi8boD+kmdYLagjvmCaRJKxqSSz1w335ZcHd4a17vWncpRlIJokhHlzXwxevasE90Wqemlb/vyYvfEDCuZHUVBP5bIQ98KYBMb5gv5MiLo+jQxMPHrnR7/cfsQJPGnwWB10ujl04Xy0FuJWXNzFcUntz7LwYw2BHY1nigxu98SjS6pdy68N+VeTRh4F4Sg75P8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hGClyLnADWgL2XQM/2YLYg6rG6pwOSwx072meSq11iU=;
 b=eAlOT5hXJuxt0sITDCxo0/46B/ZszQrC9jcJw47trc3v7e2lCgE3Ubcj4Te1wQ1R8nADOIuxPhtaf+3lWgkR3l7CrpbzWrauJDR0w/vtcGhILaGric9nZaEUjWEZN/6374/bbH+ErxzXGBXDhAGNRc9X+VMb9mlraQ4F0j8hcFwt5fub+NZURzRnEA/4afFsScndiVy6KqEfcW7KleDhI/uoOQvAo5hws9ToYG6zeR5vE9AJyco8PGsXg8POD1qso8joW4b+IZgcL24nmsHbcOiJR7Mg3Hiw91sDxU0sfT/xBadTUxvpFFB33Wq8A+gBnDFAYFPuRa8WPL6xx5rvKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGClyLnADWgL2XQM/2YLYg6rG6pwOSwx072meSq11iU=;
 b=qC4NyvjGRxxumGHwr5TNJ+z5SBr9uWKx9tsIwVBwgYmQZfefs9j5rlJkHZw05gOAmvK50SX5FgFOKIX6BbuQzeOvBggvw5AFbIHoKYn7DxXzQl1bLF545ZrmKQFRXQ+KAdoalYZ1+v7OeJ9k2sbxyY8uPFuCTtXj1MrdJqVes0R/gG4npbZfyx8ZFEz9H+fv+0KeTBIAy1vwczipx+ciXeLbReMIbOGDURMUFlOsX6ybwu2BQzlIlHTAltiCIePZf1BGrQdpwsDh3ACTGS/iYUgZ9rffJS/FX81VUuocKIqyJK1DFitgRRqg8NM36vvAV+sxqMu2QUtfxYJ0eWWpKA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Fri, 1 Oct
 2021 23:22:26 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.019; Fri, 1 Oct 2021
 23:22:25 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH 1/5] vfio: Delete vfio_get/put_group from vfio_iommu_group_notifier()
Date:   Fri,  1 Oct 2021 20:22:20 -0300
Message-Id: <1-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0444.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0444.namprd13.prod.outlook.com (2603:10b6:208:2c3::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Fri, 1 Oct 2021 23:22:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mWRrE-009Z5T-7S; Fri, 01 Oct 2021 20:22:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69e3ea1b-fa37-44bb-ea72-08d9853253cc
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-Microsoft-Antispam-PRVS: <BL1PR12MB536292837013F650743D83A0C2AB9@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EMM9J4U8NHO9f5CxaQwXwQZlza+ta7f5Fth7jSHyRlJ4aWHgaHaKziL0hPCJAeuyhiki2D1z6TUqSZdUkGKnSFZ8bVrOAUSdLlzZBMB8uqhomyTZgYatqxIVn0m23qakFNWNp5/Qpz7wgz4daDBoyRVi8QC0AFQ9O00IftQxWgyfYWmJToN4h4gUAfprUZgL6J+rnf+WY1byrECL/6E9QyPuq3ql3xTeXGEkZ4Ten+xpNq+hdIe2TiliVtH/2ZFwo7MYe+mfa+TYPTTQqFoZCqxjDKTnIe438LlNcEwHxR7H2/Id4XP/Lx5yqTe1i2M37rLhxVbQBvMxKzqDAgzCtXEge23kf7vNG076HKH2YPXjlGJ6Fm/zTLXHJoIsQiPFYjkN8EL43fc1C1DMALwEUwaUaw3uIsocHTkD56m+Rf0ONxFKHSUiPwyZvUXWfhMZQ85Iab/dorua+MThH4VO6FS53tkLFLqKwuzzifhxwPDbl490pvQtNzkrLcBqpixp5K4/gdXjl7csO/EEH68HeeOEwFATh4lR1slvFdqhBhASzduPJ5wmhuSBBMM1FyZ4PaXunQCtwxUvy085nm7y1u78Fa+eD7RoI3I6YadiCKCeNBk7mHfXJQpuF5fT10t7Qiu6FystQHQfIZDmDqVlxLm0T4TOuacNzYf9X/Xhh/cxFdNQMRex470tTd8uf7z6hXKe8zcYqNJAeN4FY4NECw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(9786002)(2616005)(5660300002)(426003)(38100700002)(4326008)(186003)(6666004)(54906003)(26005)(9746002)(86362001)(66556008)(508600001)(66476007)(83380400001)(8676002)(36756003)(2906002)(8936002)(316002)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RVWhQjM47oV4YjyEwxNwYxmBoEBzjMMIPDykbLT2H6t7T2qMs7aPWCPA/2pw?=
 =?us-ascii?Q?4clRV6uoEoWEHF1ocwMfqL9jAwE21A5q8Dry59JWz/+5k1GkFgsRleDzELNl?=
 =?us-ascii?Q?S9gS1GIt4TGSk7GkQmPhp05RbKZjv6DZ0cmSUjqP7L4PvoKkuJ17Hwq4aW8G?=
 =?us-ascii?Q?fDX0BufTrM+zwrqUhxS3lBfH4egaKsDQC9J/tCCUiyEKBi5uW2usZC8b1OfY?=
 =?us-ascii?Q?3c/Q3ucxN/69orrU/3tirEt2jBNj2kzHpmyUaqJ21XymIs1/9c2E0dNCHXFF?=
 =?us-ascii?Q?xj+Q8cAG+4Lu3K2D29BgcmWO2CwnPuNzDFecaUa497jRrvrGaIBqD3N7Sim3?=
 =?us-ascii?Q?qBZsLECuKUUTzmsxdKFfBPpLYzEFHgb3HITZ2No9586AffSWaTa0RkKpJVKf?=
 =?us-ascii?Q?waVY1NDACpCW0mfdqdJN1JJBh79zk88OgS51LuQ6FXwhVFiyaohPMYwC9dfo?=
 =?us-ascii?Q?tFUIO408EZu7QPstHL8CaUFIDeZS+ynySPG5rdwcLpN4JDdPUIz6JxDXee+x?=
 =?us-ascii?Q?Wx4FxFM3J1qZaR/1j/2VQIR6TPzky1gNAfp9BdjO/VrkOfZE3lea17OgMpZd?=
 =?us-ascii?Q?4b8a7YPS+rcgXUEahX9nCWKpEO+DcHoGg/rT7ybUdb9+SuZlQry5Y5pNzYCe?=
 =?us-ascii?Q?VM/EUNVz9lHAfWlAGm7jGTTHM1m3G2TaCN681eX9chWaQFhxSEQ+4h+22ish?=
 =?us-ascii?Q?gufa9oDq+0YB8HOYAZqKTXM3Y9kxaDVd2nL3TNTo2MFl+54M+H3WZpzJSVr/?=
 =?us-ascii?Q?h82FrnalGAoolLxvet6cbhMNm9tPJxFTdpd0M61lSdZ2sG6JGDRRO9bwMDdx?=
 =?us-ascii?Q?nDlicTPhudWwjytPKiFHGH432g/RBMsTjRWd+paqg07xwhNllg8e1GXahLkL?=
 =?us-ascii?Q?hEy31bt0WGleSA5Y1uaSTbTBHTVoZWuFNHccpMomm04mrNe+DC4Ff/ICqfN3?=
 =?us-ascii?Q?AGi099IfFKl6bYbHHUj+ldOn8Mxs1sUEovzZNBW3ON9ssh7sB1Nf4pmAsK7s?=
 =?us-ascii?Q?zjP2Reb+JBajQ9WI91cpUY3nNyrbwNyWppquh9nCaM8EFuM2OX1bCZBBkDwC?=
 =?us-ascii?Q?baIDYCItjoKSNeRhKl9MKZLGNBK/F+B0020zgz50LJilEi206JPi5T5tnkJl?=
 =?us-ascii?Q?HVSL/Q5+DpBkIr5oBpNKbH44FGR28RcZM8fMlkda/GMLVmIxzjNUVrCN6M1m?=
 =?us-ascii?Q?oei1too9Z4aBN8NjYZm6zhSRBnVcBwsoK0oJL7RwKZWt9FKMHkAZetP02nBl?=
 =?us-ascii?Q?rMvOAWzVJskDLNexqkieHbNGi7ouLSWvycbxscCMqvJ8iRFHMKyZ3wm71nH3?=
 =?us-ascii?Q?pZ+8KBXocJFkKoINJnicte+BLUGR56ZTk3pizvqbjTb9Ag=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e3ea1b-fa37-44bb-ea72-08d9853253cc
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 23:22:25.2563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26dwmzxl4zJHrZ+FM+Gjmtr0K8cE0AfmGJNkZU+c2oQnKifoAg45qrfNpsu9txwq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 89 +++++----------------------------------------
 1 file changed, 9 insertions(+), 80 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 08b27b64f0f935..32a53cb3598524 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -324,12 +324,20 @@ static void vfio_container_put(struct vfio_container *container)
 
 static void vfio_group_unlock_and_free(struct vfio_group *group)
 {
+	struct vfio_unbound_dev *unbound, *tmp;
+
 	mutex_unlock(&vfio.group_lock);
 	/*
 	 * Unregister outside of lock.  A spurious callback is harmless now
 	 * that the group is no longer in vfio.group_list.
 	 */
 	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
+
+	list_for_each_entry_safe(unbound, tmp,
+				 &group->unbound_list, unbound_next) {
+		list_del(&unbound->unbound_next);
+		kfree(unbound);
+	}
 	kfree(group);
 }
 
@@ -361,13 +369,6 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 
 	group->nb.notifier_call = vfio_iommu_group_notifier;
 
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
@@ -415,18 +416,12 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 static void vfio_group_release(struct kref *kref)
 {
 	struct vfio_group *group = container_of(kref, struct vfio_group, kref);
-	struct vfio_unbound_dev *unbound, *tmp;
 	struct iommu_group *iommu_group = group->iommu_group;
 
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
@@ -439,61 +434,12 @@ static void vfio_group_put(struct vfio_group *group)
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
@@ -691,14 +637,6 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
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
@@ -749,15 +687,6 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
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

