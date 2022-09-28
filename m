Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE005EE051
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 17:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbiI1P1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 11:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbiI1P0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 11:26:42 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F3E5FDCA
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 08:26:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKsV9dwOMGSh9uwkAVr/o6GbWqi3XW9ziYx6Bt+D2O99a2eU2VOcyGlp5Q+TUcAueHEhdzaTGAbiv9MACHS2isgKmA3H3871mWw5gjzZ8hsQWvBPtXDKAdJEApMCKyLDs5DuywmVQxmwdDGtGrn4rtVhDV7l/v67UHvWyvGfpp/Z2rtWFQ5GkWPoIiomT8qTdFMMlVQ0Sqob9KXREd+8v8LRLTi6eLARBr8I8pXjGyA4mYW+8bSwl9we1dXij9dL0CUAqA56WRdW2iHc9/Pjt+T6YcdvA1Gb/H38KShke9SdheA8CNCAUhgtCMBCMGr341iZVMfpF30JORvCCj5emg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acql0A6+ZuXV/x7O7u+LQohHzOatkHk8SGXSwZK5Vxw=;
 b=Lvf4yS+rYSW1z7gb6WfY6Uk7risZQkds5097OIvGO0gimH9SGFnRBzPuq42dm+4kZ0Yqjm3OnP0FCCeXGDIInRkHSMkRvfKSemfS9BiTYnk1aq+rM6MQTQPbi0s9eMjuq9Wa+bvHIGit8jI3+GcTu8smedStScCm52s81aqCF1bLiggtx2rbDuLMyMdLojGMx80MNSaUqeAM9qMO7o+O1hDaREeodaYrOJoECKlsXTbt754vDOp6ZXJpzdPL1o/3qkK0n8NAXUCAiFY4EsmhK1WEczyfx4gH4hheMMn7OjakWaVaDtFmy1ZwPd1EZFlY9nbJuMK1+ggPGzbs0HTUpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acql0A6+ZuXV/x7O7u+LQohHzOatkHk8SGXSwZK5Vxw=;
 b=tgdbROsIjzTFrnZ2ybKxm3K/Fmc42vWeDjs/1k1A4LgcgpR6QtwSuC6Xwk+PtALwDJK6S6rXjMvrQmul+oTGTp4THaJAGhA6HSuLUlIhraExvJ06kTwBqySRLSRQRnt1YKqYbP0ToUAR6AtynbtQq5FNBpTRorHX1vBWLbr2HFkOAJGdZzxYp2o6zPryJ3CuVik6UJ6TQUccUVxsFxO/Fh9JumNHEEIuQRGYVPUCBPHbJlHp/oLHQxeLqF45ysDqzMGnlzY6FOHXxIh3iMmBadmBSrejv1pt5BArqPTtG9IbfsxVrOjvsVkObl6ngQMoFX5Xn+yVy/eyeCP0nTPP4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by IA1PR12MB6282.namprd12.prod.outlook.com (2603:10b6:208:3e6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Wed, 28 Sep
 2022 15:26:16 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c%5]) with mapi id 15.20.5676.018; Wed, 28 Sep 2022
 15:26:16 +0000
Date:   Wed, 28 Sep 2022 12:26:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Qian Cai <cai@lca.pw>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Message-ID: <YzRnlqw/U7xDhL7P@nvidia.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <BN9PR11MB5276ED36A2F498D37A18DCF38C549@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276ED36A2F498D37A18DCF38C549@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:208:236::6) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|IA1PR12MB6282:EE_
X-MS-Office365-Filtering-Correlation-Id: af9bbcb9-e615-4ab8-8857-08daa165c8ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EK4Ug0Oc5e0sJEJsKQnSx1zUir90AN2mbKud/Ioo0EYoH7vYX+5GhkIC7Xx2xfh9s6UX/sgHIROW2SD4WQcCV3dzLLUy6Lu93GJI9oPdkzAS5kbadgKWv2wfBwlSUfNNChHARbIOzKB8WW1RtbDZPX+TnHtDd0o8eHA5oSVGIKIG0HE0G6hXDFks05axZAbO0cJu1NWUysMhEKegJicjqt/ygkNTiKjPTya5htlIja7q88ciXXkt0S5a0LO2LS6X1H17JCiPlXF8tVvl2nUayXFSjyiqh2UbEJJYe7VU9Q5GNc3ilXFAd4JDVPW0fZciD+JsN6Iqzn7htz9G6TVgd3/kiH41/l1mfs8W3hBfAix6ixZbGJbAlv+XHmmZ86MfxZ4NWv+WlwW25+iK6P898ezEI8UbYbAFt3kHREigI5mV+6WirX7si4/pwqUU+alX6XhXkW5vlYDQ2kbGHOhJ4+82CHJJxYeVhRFEm4tpZ5gJBmqjuogUdlW1trR60WmAyja5wAT/9RnvTN4Vy/A0QLXrSFmfKcYHemP+lYICg/D25U5FMQaFtzKIUbX70zP/pjeIH81+hkPwPRvtBxofVexTAmTMzCRgDdZ80xKmQF52AueWW1Xyrea0JfY9i+5mIzxtX8nCDmZB19II2HECKFbr5qRyc7AHFRSb5Jb2ai1gNl6HSsK6jVYDIIuH/Z6pj3w6nFkum+r4zKBmV6iYWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199015)(2906002)(5660300002)(4326008)(38100700002)(36756003)(41300700001)(66476007)(66556008)(66946007)(8676002)(6486002)(54906003)(6916009)(8936002)(478600001)(316002)(2616005)(186003)(86362001)(6506007)(26005)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xRRzDAtleuv1pjuKhua5wUw7sEv5Alrfab7QMiB3jrtqYGcQc+qGzZL7/9WV?=
 =?us-ascii?Q?cvAd8l/kEenyStEVGgxFPa2o9vZ03IcrNnbX9B2mVW2iVBSvZkqHmP7qgUDl?=
 =?us-ascii?Q?8JQWlzVRRdm8oP3lfD1XzZsLt+wlIsSEjwSugtLz/M+P+j72CxFRLXi+bwhe?=
 =?us-ascii?Q?8FWFAAVeRKTrrh0KLu952a1O1kqdDCjDXZylwp8F8i7oGzjNczstDYnzXynk?=
 =?us-ascii?Q?26qERDqRHrxrmkdhAFeKRIEMoWnN2JhHmfFcbOPMpy/YVlYjpgdJDH9LYoxy?=
 =?us-ascii?Q?7Y7+Q3j5uGjWIxSPjWgi6FvFMiJeakHvHiKzXkkB/32yzQS0UQEL6BjZ9BC5?=
 =?us-ascii?Q?pOSnxkz8dz9l/dr7BzpxBwmnEUBGTaoV4X/Hs2CKdHYgOn5G9O2WYrCywNfr?=
 =?us-ascii?Q?bwKHtPkYW0dRywjo98w1EAvjBmaYu9uKDMLLK52O2JcQe7TS1BEGZOcFeCI6?=
 =?us-ascii?Q?o6TIzNl0i6eK0tsC3RBqmFvYzndkrsmi3PErxX9n4KRw5ePO9kXf++cyA+iO?=
 =?us-ascii?Q?1C9LDj0kGpAAFcBjBdnBrCgupS1njXpuhNFU65klS1zcbaoxWr/LaNkcPNkw?=
 =?us-ascii?Q?5+3HwHqqB55W7WHjm3qUie+F+i5g7p8ijGx2RjipCOPs/RxqMLoO6Y86R6iz?=
 =?us-ascii?Q?Gr1FgneJnprBHuYmdPFCcaBo1V0mXj1JITXW3GCYnZcAmBzI9NAANOyWx4fm?=
 =?us-ascii?Q?rIY/yl1fpLMku1KYx06oJnb4os0Sy0UZeLkEiw3ORYMJOhDc2HRW/sdSGr/D?=
 =?us-ascii?Q?KERHyKES0ZT/JIFzCkGAeOyMhc0FlRTeSXKUHh1r+VlPlnwKRHTcyDuFCeCq?=
 =?us-ascii?Q?FODygVHDX75uQ/ZXMwV8UcaUiHGEgVoVrfZk723LAt3KuejfpfKBw8RWZI6U?=
 =?us-ascii?Q?GZrfMVvZl01PnZwskXDy0nRVZWeZO8cN9mIUYY9o8ev1fd9CzYrJhp+FcrUB?=
 =?us-ascii?Q?kBmTTQbgWJhm6WBmGi32hIu0uK7bHzKElFZ6VhiHQCqAAyY6xf/unlEs7uAD?=
 =?us-ascii?Q?GrFFiyUWhb3OvrJAfG9ZldV7exP759/fKT7LDgLhFBA21t53ciXztItHZ5+x?=
 =?us-ascii?Q?jFIcq5Kb/Np0KgsQcJDF7OH28G6xamE2hYPgroZnPMFjiDj4q3sOfz7N/Sj6?=
 =?us-ascii?Q?jEDmOqMbs2SR7W8uf8pGbxBhsQnt06UXgbdHcYd3HlPVgerk434hheHldHaS?=
 =?us-ascii?Q?bioN6N+7oUIDkwIFTqKdhhUP6y3o9hxNfL6ny/wSCWEi2/ISVsUIowlsRDHV?=
 =?us-ascii?Q?P0TMsQsbwTRDXW/yYpV7ayUs3ZOA/1SGv479D+ew0zEv2Rz8bxETxu0ayFXV?=
 =?us-ascii?Q?NMDeQ3SutkK2+nRXv0t/tcO4V5w273Qzr2mChRMKqTjMQhpi8pBjbHF3PvbP?=
 =?us-ascii?Q?ftr7BVt1h6iv7pnr1Wigf0Q0/sKA4/QOA5Ki2URRaKnTDvHRUWMiB2QE3bl0?=
 =?us-ascii?Q?p63jUxY/5NLy/sPDAHh8OeX7+qklMkW1V3ne9oHGw5lg6CCIqQ5pEHSWsn9h?=
 =?us-ascii?Q?RW3pz+he0E+c2dzXDAG8pOA2TlYYwXP4pMHzmAoNrJm2dTgBUZk+Q3P0RynR?=
 =?us-ascii?Q?NxTck64M4UIzcOLdKN0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af9bbcb9-e615-4ab8-8857-08daa165c8ec
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 15:26:16.3402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ajuuR222UnxY+4M3abkbQT4OGSz18tBK4NnSQmDWsD+hpT9fGN9ZzJi5JTN4tUsB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6282
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 28, 2022 at 03:51:01AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, September 23, 2022 8:06 AM
> >
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 56fab31f8e0ff8..039e3208d286fa 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -41,7 +41,15 @@ enum vfio_group_type {
> >  struct vfio_group {
> >  	struct device 			dev;
> >  	struct cdev			cdev;
> > +	/*
> > +	 * When drivers is non-zero a driver is attached to the struct device
> > +	 * that provided the iommu_group and thus the iommu_group is a
> > valid
> > +	 * pointer. When drivers is 0 the driver is being detached. Once users
> > +	 * reaches 0 then the iommu_group is invalid.
> > +	 */
> > +	refcount_t			drivers;
> 
> While I agree all this patch is doing, the notation of 'drivers' here sounds
> a bit confusing IMHO.

Maybe, I picked it because we recently had a num_devices here that was
a different thing. "drivers" comes from the idea that it is the number
of drivers that have called 'register' on the group. This also happens
to be the number of vfio_devices of course.

> >  	refcount_t			users;
> > +	struct completion		users_comp;
> 
> Now the only place poking 'users' is when a group is opened/closed,
> while group->opened_file already plays the guard role. From this
> angle 'users' sounds redundant now?

Oh interesting. I did try to get rid of that thing, but I was thinking
to make it "disassociate" so we didn't have to sleep at all, but SPAPR
messed that up.. It is a good followup patch

So like this:

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 039e3208d286fa..78b362a9250113 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -48,8 +48,6 @@ struct vfio_group {
 	 * reaches 0 then the iommu_group is invalid.
 	 */
 	refcount_t			drivers;
-	refcount_t			users;
-	struct completion		users_comp;
 	unsigned int			container_users;
 	struct iommu_group		*iommu_group;
 	struct vfio_container		*container;
@@ -61,6 +59,7 @@ struct vfio_group {
 	struct rw_semaphore		group_rwsem;
 	struct kvm			*kvm;
 	struct file			*opened_file;
+	struct swait_queue_head		opened_file_wait;
 	struct blocking_notifier_head	notifier;
 };
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f19171cad9a25f..57a7576a96a61b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -186,10 +186,9 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 	cdev_init(&group->cdev, &vfio_group_fops);
 	group->cdev.owner = THIS_MODULE;
 
-	refcount_set(&group->users, 1);
 	refcount_set(&group->drivers, 1);
-	init_completion(&group->users_comp);
 	init_rwsem(&group->group_rwsem);
+	init_swait_queue_head(&group->opened_file_wait);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
 	group->iommu_group = iommu_group;
@@ -245,12 +244,6 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	return ret;
 }
 
-static void vfio_group_put(struct vfio_group *group)
-{
-	if (refcount_dec_and_test(&group->users))
-		complete(&group->users_comp);
-}
-
 static void vfio_device_remove_group(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
@@ -270,10 +263,6 @@ static void vfio_device_remove_group(struct vfio_device *device)
 	 * cdev_device_add() will fail due to the name aready existing.
 	 */
 	cdev_device_del(&group->cdev, &group->dev);
-	mutex_unlock(&vfio.group_lock);
-
-	/* Matches the get from vfio_group_alloc() */
-	vfio_group_put(group);
 
 	/*
 	 * Before we allow the last driver in the group to be unplugged the
@@ -281,7 +270,13 @@ static void vfio_device_remove_group(struct vfio_device *device)
 	 * is because the group->iommu_group pointer should only be used so long
 	 * as a device driver is attached to a device in the group.
 	 */
-	wait_for_completion(&group->users_comp);
+	while (group->opened_file) {
+		mutex_unlock(&vfio.group_lock);
+		swait_event_idle_exclusive(group->opened_file_wait,
+					   !group->opened_file);
+		mutex_lock(&vfio.group_lock);
+	}
+	mutex_unlock(&vfio.group_lock);
 
 	/*
 	 * These data structures all have paired operations that can only be
@@ -906,15 +901,18 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 
 	down_write(&group->group_rwsem);
 
-	/* users can be zero if this races with vfio_device_remove_group() */
-	if (!refcount_inc_not_zero(&group->users)) {
+	/*
+	 * drivers can be zero if this races with vfio_device_remove_group(), it
+	 * will be stable at 0 under the group rwsem
+	 */
+	if (refcount_read(&group->drivers) == 0) {
 		ret = -ENODEV;
-		goto err_unlock;
+		goto out_unlock;
 	}
 
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO)) {
 		ret = -EPERM;
-		goto err_put;
+		goto out_unlock;
 	}
 
 	/*
@@ -922,16 +920,12 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 	 */
 	if (group->opened_file) {
 		ret = -EBUSY;
-		goto err_put;
+		goto out_unlock;
 	}
 	group->opened_file = filep;
 	filep->private_data = group;
-
-	up_write(&group->group_rwsem);
-	return 0;
-err_put:
-	vfio_group_put(group);
-err_unlock:
+	ret = 0;
+out_unlock:
 	up_write(&group->group_rwsem);
 	return ret;
 }
@@ -952,8 +946,7 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 		vfio_group_detach_container(group);
 	group->opened_file = NULL;
 	up_write(&group->group_rwsem);
-
-	vfio_group_put(group);
+	swake_up_one(&group->opened_file_wait);
 
 	return 0;
 }
