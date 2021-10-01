Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA9A41F82C
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 01:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhJAXYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 19:24:17 -0400
Received: from mail-dm3nam07on2074.outbound.protection.outlook.com ([40.107.95.74]:12768
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231297AbhJAXYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 19:24:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcpJetRYwzCcJK+VrvYpO/6hc8/L/XgRwx2CuQZcxoyVcy9Hb4ZsZKoH5lVt1Oyx3cLfm8hl8FqA+/ah9XXS6JpkghB6D6xRVI5tL5wwFPXlA/WEkeToYhwaIxv9vdnKVR82Jkz+mrzG2FeKSTnHXMF7lxZwFGAyHIDvmgWBNEVVX8CMJjB9eugRCzlKWwKxYkX1BbRaXQ4Ruy2CQird+PL73t8L/y8gJb6c9cL0JibioljUZdU3HU8HVTjQ0hC/CKJNo+k2jpSJXKhUU7HPB+Lh9kgIK6lMo9bIUDIEfmJtYl1s7DzNeMlZ5cc8UK5AnmIh9wkAAaYUs6J1sw8L+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S6RWU+eQ5TBd2+plkb7uxti7DHs2QFJ8GR5DGC8VGwY=;
 b=XNh8l46sSHwCj+oKP34yTBapY9RHwKll9VPT/a3G+EiVKgSpJg+qCBfWKjc0xwkUcpys4UxhccfmNXMFGhNtJXw6tjcMARxs3Y0S9jiNmoXb47f+Wp+t/yPWnDPwEh7MTuO4fuJptI/JErPxv3zkOQYHdAnrirTELjt4zK9pXc0jzyFllNGpsZnqNG6qZZiZjsspKcyWyPZm7s6j3ltjKBil7Q1Q0sXsrwbvoZJCiw7xIyY1ts35Ot3VBT7vDGBHAzplMAnjOD68d0VTAyNuKLn9IGrlhU2GVWOJMnhLhu8vxX5EOa0vWn7BzwfdJCcoyUKgSYpp2H8clEycRRTT+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S6RWU+eQ5TBd2+plkb7uxti7DHs2QFJ8GR5DGC8VGwY=;
 b=erj8fZFFAmbCduhh0QWzWCqYTrbSthVnuZtA39RclL4pNwbIxNyC2Im/We0vHhxWzKvi7RvGT/T9Hz5DWuFf8WXsPPE1wjSBMdrxrRyv6plMyrmiOwsiCnK4HGJWMRIYu9fccg9NVl4oyQ2wyD8YasctOJHTRu8eeFCfd6o9gnZSSBMpj9yBtRG4dIJCT22RgTZtC0TtkgoFXAVVy1Zr+PA8rmWQFO/LRpuOtqyrhEuS4vHREuD6HsvchWUu2LQIHgCQ6rcaoDPUYeGtQ4wbRoM7yHYNe8SPCMiexwZ0RLkWoOzNH7CENS1T7f7nsrPz0EuMUO034FOwqFUgURWg4g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Fri, 1 Oct
 2021 23:22:27 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.019; Fri, 1 Oct 2021
 23:22:26 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH 4/5] vfio: Use a refcount_t instead of a kref in the vfio_group
Date:   Fri,  1 Oct 2021 20:22:23 -0300
Message-Id: <4-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0042.namprd15.prod.outlook.com
 (2603:10b6:208:237::11) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR15CA0042.namprd15.prod.outlook.com (2603:10b6:208:237::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Fri, 1 Oct 2021 23:22:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mWRrE-009Z5f-A6; Fri, 01 Oct 2021 20:22:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7980ca5a-304d-42e9-3aa0-08d9853254b3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5362880E8BBA108D2FB3BA3CC2AB9@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FT+dzutWIAxSw1qjUTggHdHtePVlcBvN2KZGGpUqJ64sKtZCYmSHQW4B1ZU+ekX7boxVWSPZFWWszhWjtA/Bp42Vng/+7h3qXFh3F1GXTrlhS0bVFxCb4d7iuySyUmAdM7VpVBeWRersm+fqD1IUEkDsMiMCT+Uc/52BNbrKPn/TQUEcahrjxneF+HxYqtGVW6Skg/G1W97DBOFxL/MhGEnK6/rGyWnRiOGciiQea/s+8zSsTzN68RxHbrtoHUXjo4YdLVjLIgl/C0kvkHG+hlDxpMiH/dEv/zuG39462JK2rk79WEZ+0fH3njAZQsKxYIIAZc5HFy2EjKAHl2ukbzbnv1sBazN4qmaYw7889dgEPIV8zY2sU2PCy7l/N67ubu+hs1FsELf/lyvVpkIjAFLFs+I+SiUxPHWwhHBOwoEWZBhI6GM4FF3gduHN5aHGs5+SLIaf+07rgz8k3BKeViCjvPNKxXnn+XEEkKjIAhWzZ6NYBYOkWacb9P2sNjtFzDdxTHZNlnG4gIWdnJTCLFVF/1DZRkFaLoZ2qsU4MWFbkuctrR9f7A+wS6fITJCcsHQ9fy4R+6hClvn3kwEHTTlM+fFnSXob4VFD7xxLwNCngYyse8BabT0veBwLNnzmXLCrhsY0UhU1M31xMuU3Tekp+ACRAZsaIXv6VmJ397Q90p0+Vmw3zhHm4qahCjEaUB+pwJxcnQ6jX3km6rgxIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(9786002)(2616005)(5660300002)(426003)(38100700002)(4326008)(186003)(54906003)(26005)(9746002)(86362001)(66556008)(508600001)(66476007)(83380400001)(8676002)(36756003)(2906002)(8936002)(316002)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wfgdIS4dGthZlBZ2/XO2SRPv+2ClJ1fTo4D4RRXibhAnTyKDm2SZBRiaKOOh?=
 =?us-ascii?Q?2ePEUHimlPR9gq7Cs/3RrFQh6jyanbgxPlINx8m19tLzYtk0Drqk8SWmsFQ8?=
 =?us-ascii?Q?/tuk8XRBk82SawSoGdDc/nCpcSXg8RdoWjR6ncwgZuB1RUl2jeZMRfccDsqM?=
 =?us-ascii?Q?fglT28zuAVlb7qot8vS9HRBG6X1MoalbGpSUjacZI221UKBMKYQfBoF38GZT?=
 =?us-ascii?Q?g4hMvPmBJ9fhcQ/4SMxCywnIeGI5l0LD8BsmB59ndgr4GL/Kz+Kwd45cpPZc?=
 =?us-ascii?Q?/I87W+mPtUylRiWpKfcdpkHr4ex8am6rCj3CesjWu99KxkqEAgZYiQWXC1tr?=
 =?us-ascii?Q?TDltFHAS1Th8vXH2JfmWMYQ/Y8RadKuf+fdi2H1/UOkp3ZaP88vQ+avF9tv7?=
 =?us-ascii?Q?KTonu4DaPcOrxrjnHHsRSZI2DZj9Kj/vuIVa/+HfpOClFoLuu6YyEC8MfEub?=
 =?us-ascii?Q?8FA30ICpb+ivO4TDTM9vWcgdTYxXORUwW2rT30jHYSWT4I8rtop9TJDxsRW1?=
 =?us-ascii?Q?dPBmHb1oH64Uo6QFe2fzz6UmhY/FRz6R5CKtCjPsvWCKrAut+hxnpg24vcIX?=
 =?us-ascii?Q?oRJKWjzYWMWfSNoRz1jvCOfWrQbvEC4k1oN5BjLBP6tnF+VNSrO2QVeN2Z2J?=
 =?us-ascii?Q?DN4TUChzNXlvLBeB60WmyZELztr+lv7wrL5a8nIWu8Ai1WO6R+yy7rQoLP2A?=
 =?us-ascii?Q?bfF2hKdUWr0Z1OFli8L2QRnL8bOFMVM3A6qpEUgexXlypsuVrhiC8SSDx+Dz?=
 =?us-ascii?Q?5PLceJgDYOe3UlQQlDJB01J+AtCshhz6Xol+7tb2ovhckekLuAtoOJZx3KKC?=
 =?us-ascii?Q?Ac8IblCEwwrw5xzoIEbSWRQ1Y3piF1VeCZj9Vs/utgskhg+UUBdCgIFPUvrh?=
 =?us-ascii?Q?vYKQt49OqMUPOq0kgF3Zggf3tQKRO5LMVxqAJWBeP5Jk83q0dMxSXEpAjCq+?=
 =?us-ascii?Q?U3U1hI1xmFObGCJvRYIVZs/VstZkRnhT4gvsmnVZxYV2fm23xqIIwh1sTEja?=
 =?us-ascii?Q?b01Nl41hTCUbtwt8mkVnmo2PkvmX8q8Hy9srznEQzQEPK9FDU987QlOIcFA1?=
 =?us-ascii?Q?oiQBcz5o/5Xr00UbKakT3NYdIXmG1X1n6I2DiJedrKdj3KULrDg36gJcc1LM?=
 =?us-ascii?Q?h726Ytjh7Tm6BxvqEr/xYScyeZKEUykCBX+9+yJ7zYpn0jeT1iCO8WgprG2I?=
 =?us-ascii?Q?mc+5FHAX0ZGXEBABHHZqNGcDHvyHun/jSvieR2lA0m97Z+Cm4ZaI59gML9hl?=
 =?us-ascii?Q?S7AWA/42uk6RNtHiuwmCDpuwRRqdPAS3Geax4ynmhqaD912WIK4WziAuBp+X?=
 =?us-ascii?Q?38kWoAdM4i3qnwu9OrK5ifTS/5+L2vZ3GmpkRxeRYrF95g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7980ca5a-304d-42e9-3aa0-08d9853254b3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 23:22:26.8852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXpQN1O+MbSgl/CPImS/+c85ltNq2ipk3SoJzPlhDg3fLsxK2z3Ai8JndI6eclsf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next patch adds a struct device to the struct vfio_group, and it is
confusing/bad practice to have two krefs in the same struct. This kref is
controlling the period when the vfio_group is registered in sysfs, and
visible in the internal lookup. Switch it to a refcount_t instead.

The refcount_dec_and_mutex_lock() is still required because we need
atomicity of the list searches and sysfs presence.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index bf233943dc992f..dbe7edd88ce35c 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -69,7 +69,7 @@ struct vfio_unbound_dev {
 };
 
 struct vfio_group {
-	struct kref			kref;
+	refcount_t users;
 	int				minor;
 	atomic_t			container_users;
 	struct iommu_group		*iommu_group;
@@ -381,7 +381,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	if (!group)
 		return ERR_PTR(-ENOMEM);
 
-	kref_init(&group->kref);
+	refcount_set(&group->users, 1);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
 	INIT_LIST_HEAD(&group->unbound_list);
@@ -441,10 +441,10 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	return group;
 }
 
-/* called with vfio.group_lock held */
-static void vfio_group_release(struct kref *kref)
+static void vfio_group_put(struct vfio_group *group)
 {
-	struct vfio_group *group = container_of(kref, struct vfio_group, kref);
+	if (!refcount_dec_and_mutex_lock(&group->users, &vfio.group_lock))
+		return;
 
 	WARN_ON(!list_empty(&group->device_list));
 	WARN_ON(atomic_read(&group->container_users));
@@ -456,15 +456,9 @@ static void vfio_group_release(struct kref *kref)
 	vfio_group_unlock_and_free(group);
 }
 
-static void vfio_group_put(struct vfio_group *group)
-{
-	kref_put_mutex(&group->kref, vfio_group_release, &vfio.group_lock);
-}
-
-/* Assume group_lock or group reference is held */
 static void vfio_group_get(struct vfio_group *group)
 {
-	kref_get(&group->kref);
+	refcount_inc(&group->users);
 }
 
 static struct vfio_group *vfio_group_get_from_minor(int minor)
@@ -1662,6 +1656,7 @@ struct vfio_group *vfio_group_get_external_user(struct file *filep)
 	if (ret)
 		return ERR_PTR(ret);
 
+	/* Since the caller holds the fget on the file users must be >= 1 */
 	vfio_group_get(group);
 
 	return group;
-- 
2.33.0

