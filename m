Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC8F41F82A
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 01:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhJAXYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 19:24:15 -0400
Received: from mail-dm3nam07on2074.outbound.protection.outlook.com ([40.107.95.74]:12768
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231325AbhJAXYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 19:24:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFN4A8fJ3SKz5yP4WgjDS36XfQOEN4ilxDWlvC5/xjSHKK3dnOlaBxhMd3XjSAvJEBiQ+S4IRpP1yS6TwOmzWjeFbD75hLvcdsIqGH1vTVUigIasXuCdw7oobsohqOA5V4oMZxeB4shnzUrKFIqhobukLLhzHSfWevKTfm83VcO1uzJ7OsqLr8GP4Y+MxutJetmp5J7SDlDk5RA22KRirWz/0n6aEMlANAMHfwo0OddeKJYVIt3GngPDIxG/V/0q5rv8BbBGVHXvxdt/ey0p7qwj7/WPGP4ZNZu8/VboyLlN+EhlXizqip8AiOojxnc8w+KuskcsvOvZ6Zx8Gu8ycQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H6jgdoNSqq3x38UbG+DWyV5He3W7Pe11C2XIqvF6ZiY=;
 b=I8jLi7vzIxPnydIdsRAI9ej/2vhPQDg9b6zsAQ/gY86+IhyCC9wmlLz06iX2z1LeJ1s9cJ1ZtUH6NWp94HSR+fYfuo9tMj+z/kt/yYYyUNoMuJfr8qGFTPEcuhptpEiLY00LLLrBIBj4Y5pxnanFBo9klKpZM4eoOyEus7DHZv3W9167mLUkRJfp3K/Mtlr4Hw4fNfcAZdlJuQBMuXk9H3Zvwe29dWKYuVsPBIieuROU7rZf86Spz1VZMZXh/Y4sF4WmzMHqHdL/LgZRSWswHPVazDPa+XJRjA1k2OgmL813yPvcvQUyFMi74t3qfudLvbXxzENBQHRnyV8K3EnEsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6jgdoNSqq3x38UbG+DWyV5He3W7Pe11C2XIqvF6ZiY=;
 b=kqf7m7eF6nEkE/gh1unCFkdthBpfz/ycM9fvhZ22vgTBtmL/vemS8y9kkJ0Z7Qida/XodhuN5EtGPX6gH0frZPSMqHPwtBMSplbShxdjIgtJu/xSPdLr+Reyd8sqjO6sB0CQ3bB8yP3BtdUTfEUCZ5OajnUJIgYPESRMwc+nLC18lei5LcBb846F1QBPvW5t0y0MBERdWae4U+kiZomxHvhKoG3KXZbKg3Q+FvK1FUSCSRu05+0lMPHMYRNhMcNgIKXAvWnmKPwz5xA5fUwTB8V42I47CCju4tu59cZlnctKbYy06vTEXivDqJ+MI1hUVWYjHnR2/f/RfIMGkzZ3tg==
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
 23:22:26 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH 3/5] vfio: Don't leak a group reference if the group already exists
Date:   Fri,  1 Oct 2021 20:22:22 -0300
Message-Id: <3-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0421.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::6) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0421.namprd13.prod.outlook.com (2603:10b6:208:2c3::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Fri, 1 Oct 2021 23:22:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mWRrE-009Z5b-9E; Fri, 01 Oct 2021 20:22:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b11d84b5-e48a-4344-463d-08d98532543c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-Microsoft-Antispam-PRVS: <BL1PR12MB536201351DFAFA584A48EE7BC2AB9@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +rT9JH7BICVmBWqA6UHvle5HuE7skLHMiiNJzn/teNudJZWZSw0Zp1cUwwiwHlzJZg8jsD2OAAzkWBdC8OZnn3UXkTawaHDNsC6ieiIvgtvFbaw1eXkxrQk3l0CUX6E3+z0Fk3uKimqLIxTSovNTAu+PyRCp0JMyyjBRgg4TtXRGF5R0oQYqvyDtQzabCoVGb2oSoBcnnv+Ve4lDj+0WFHmyQcgt1Eaeovf+iTdWaXEzuAXDdyM4igSQLwxn3DGm9iGMy5ao55WKoUvSeXQ2uHM5GSXZhXSmVS9eFIWKDWTq8e/9vf6gHYsj5ANpJmc+BdJoM9012Rz0SVUiGiqQy0i0YGuc2a6ueiYmEWRxvQazN0bOQouw4NaoptEuRP8iGW2Nov9KQ4LnsPePN+1vMG5CW5dvasnkBHuX3ZZj9iSLpXop7+hcHmfAv12bPuv3pONnEL2dVr/cfCVF6l+INedddh10XXzf8Up3zYEOcbhTFq2SKM8TyYJGhhsPMzAaB/c1K9kQAqGckJxoIIav0N+xWRBkwaqP2LLmaST6PWv+Ah3nI6qwFCObjyplPa1GEbYfR7K1iwIlw6Nxnf5AAhbR9WJ77sLpwwmTP8VYq7sY60CjVv7aqQcLnqdhekwNOBjtCCNPaCsrS86lLl/PWxDBqNms4UNKdF8912IsyJMByJ5/9yxKT40vHaRyepoK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(9786002)(2616005)(5660300002)(426003)(38100700002)(4326008)(186003)(54906003)(26005)(9746002)(86362001)(66556008)(508600001)(66476007)(83380400001)(8676002)(36756003)(2906002)(8936002)(316002)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cg3+9M5d+2r/ant5yQ+hZjwDht4BqQFw4QngFd4LYSPkjD7xwKu1P9zmOe7Q?=
 =?us-ascii?Q?B5KMrMaMM7bu6dPeqzXoaS02ZFSyTIYOGekWzs24sHYgeBGC7KF0d3zsiN5l?=
 =?us-ascii?Q?TXOfzHu/6gCQyt/HxBBNZYGWx5aoQND5y6NVhd9beSlitMA6TUcVb4o26ZZs?=
 =?us-ascii?Q?ympLNE7m0cF7YcUTtkWm2DM/SRpiUlzyHF0Pn/2fVK56vgYiyo8vdlvRwjmV?=
 =?us-ascii?Q?e0gnsu3f47+Uut64ECP6qbd6QfYYxNPjTABEOOK1Hze3cScvNzRY15rstQUB?=
 =?us-ascii?Q?l+CxxFTb974NGVHKDeg2l5+oYrUGGN4tOensppbDGFcuwZnAXPmIki2YTSiP?=
 =?us-ascii?Q?rlge5fxpsF09I/yuyIecBWYHo3jU+CA7ch/TZ2qy0a1HBmkC4S1okwbN/cBi?=
 =?us-ascii?Q?6smowiOJjsKdYqKdEbuKzbtbKYJa1R/gpZnJiHhOkb1D2Wwj6+87bolt6nzx?=
 =?us-ascii?Q?pETrlBXkKE5NHQ4ARBw4JiDRj5jjiEs8RiezDgZcDm956Z20mVSpdyvcAGUb?=
 =?us-ascii?Q?/9Sqb5lekxWjr17/5zWEzzLYtN/Qc87cybs/EP9iagVJk/5kOBkaKGtrTUps?=
 =?us-ascii?Q?79vYioveqGNOnll6wxxJJ5DBMgu2eXIsSCQd+I5swZb/ambRpBf/cIyB48vc?=
 =?us-ascii?Q?I4jVNLkiGdaHSmdtCVQWsQHx6StSk/NWHsI69M26oLgvO2PhzfJ1jCDzDcBZ?=
 =?us-ascii?Q?lF0l0FUtL4Lly1fzHWwoiyIgGWJ5pans9PYR0/6X23kx+SF5o8ag2L9zuZsK?=
 =?us-ascii?Q?R7eWVsRENLfLh9MI8KUnCzwGPM1jyWmWjBlfUprxTZQCGLeoO8or9BSGtl6D?=
 =?us-ascii?Q?XQqVuRqybqCbJv0xboSye/J2D8y1qIeiIsCFAxayuuQln5gy3KfaxPPWZSfs?=
 =?us-ascii?Q?FoQgczCbsOGSPeUONiF5mDhaHHlKd0uOkirLXlcGKnELJKTmBeAmCIQZ+qaf?=
 =?us-ascii?Q?7uT+5mVWJtB0srQuH2tsxY17Jox+xaMRjAMBP0wU5TlOSYEoo70wTTCsz1TK?=
 =?us-ascii?Q?ivHuAW4+R53JMEEOAPQ8992vPhX5akKVUFjy/k8Nl97CKh4aD6HNV2OoL42O?=
 =?us-ascii?Q?e3xIbXivj2rXf+Dz8NFh4xfSmuCbUSsZtEx11IRY9Wk3Oi/ArRj+I2dM4ySg?=
 =?us-ascii?Q?YE9+hVRlouCrP9bSzYjB4b7ZLtcik7Be1cMR4Lolt8IYWPvid1EZjtL+RKeK?=
 =?us-ascii?Q?l9cNCfk3EYvC1y6kqD2qviYSWT0+YzrkJlWJvkrjrpyN5AAXIGeUzH7EhJzi?=
 =?us-ascii?Q?FANiTOivPCUdWejfQkYyjK0gIUG+jmBhigIo+B9m35ggy6iHsleTOTyEGkJJ?=
 =?us-ascii?Q?TrK+q7tyyVxttvs5lZmjmLtosJQIMObnCsdhgqBFEH7VQw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b11d84b5-e48a-4344-463d-08d98532543c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 23:22:26.0150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oN8OxyWpVA7Nbeyf8YDoRXunoIbNzd15C7ib/nWshbnvG4LvSRPC01an34FGvvl2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
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
 drivers/vfio/vfio.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 1cb12033b02240..bf233943dc992f 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -338,6 +338,7 @@ static void vfio_group_unlock_and_free(struct vfio_group *group)
 		list_del(&unbound->unbound_next);
 		kfree(unbound);
 	}
+	iommu_group_put(group->iommu_group);
 	kfree(group);
 }
 
@@ -389,6 +390,8 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	atomic_set(&group->opened, 0);
 	init_waitqueue_head(&group->container_q);
 	group->iommu_group = iommu_group;
+	/* put in vfio_group_unlock_and_free() */
+	iommu_group_ref_get(iommu_group);
 	group->type = type;
 	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
 
@@ -396,8 +399,8 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 
 	ret = iommu_group_register_notifier(iommu_group, &group->nb);
 	if (ret) {
-		kfree(group);
-		return ERR_PTR(ret);
+		group = ERR_PTR(ret);
+		goto err_put_group;
 	}
 
 	mutex_lock(&vfio.group_lock);
@@ -432,6 +435,9 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 
 	mutex_unlock(&vfio.group_lock);
 
+err_put_group:
+	iommu_group_put(iommu_group);
+	kfree(group);
 	return group;
 }
 
@@ -439,7 +445,6 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 static void vfio_group_release(struct kref *kref)
 {
 	struct vfio_group *group = container_of(kref, struct vfio_group, kref);
-	struct iommu_group *iommu_group = group->iommu_group;
 
 	WARN_ON(!list_empty(&group->device_list));
 	WARN_ON(atomic_read(&group->container_users));
@@ -449,7 +454,6 @@ static void vfio_group_release(struct kref *kref)
 	list_del(&group->vfio_next);
 	vfio_free_group_minor(group->minor);
 	vfio_group_unlock_and_free(group);
-	iommu_group_put(iommu_group);
 }
 
 static void vfio_group_put(struct vfio_group *group)
@@ -734,7 +738,7 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
 		ret = PTR_ERR(group);
 		goto out_remove_device;
 	}
-
+	iommu_group_put(iommu_group);
 	return group;
 
 out_remove_device:
@@ -776,10 +780,6 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 
 	/* a newly created vfio_group keeps the reference. */
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

