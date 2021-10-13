Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F1F42C325
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbhJMOaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:30:04 -0400
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:8800
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235769AbhJMOaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:30:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iyB9Z7WlgXDoxneV5esKC6pvjQwrjVY8pW0V/GD1TnUoXk23XfPot8P3sbcCelO3hdd5g2Jp7sc8fr7RRR1hvpLSfs8dPJQ96CaI5rgfltiP9XH6NtFpn5+YpBNMEg66iWMzYIeMPDqk17BkRhLQ50K72OkogEpH9PnpimBsKXxQuGPkpGqqyuKfGoCTgsbhidsgzIu6HeJoV5hszk0BNzr4eVM54H1vYNMhdghHdvIxbJKZ5IOIUeuPQ1X1gNhY5WuiuJBgL+NuSSg0XuRfdCoookuGhFPq+ueFS/5OmchqjtRClRV60R277VjTryMMgOQyL+g2OlwEv+imwQXTjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYrTaoNX4/ZrjdZ60xLJVxio2OHaWJNnMoGkjiPgbHU=;
 b=QEjFsMW7GpuL5SgRYo9jusSKxhcmI+gU5fxko/rw3dVeqweBl3eQB38N6i4LfInmcPZ2r7U2nIiq9HFFe0b+8d9NyKlz+70FwSypo7r4NqTAuTYztui7EMnq8xqkyeG9nBFeShqsUNQ4m6ueKTJP+B8HCGyrFUOHqeboYUEDI7iCqozrO0iUYM6t7Z0KO9NAW36UQL1NwEDKTmXJSC7EDGiDNiDO+zzVYKOVrCcJykn+bhfayaf3fRp2uFtSQ2jE9RWuTNmc/r4V5snzyVlIcwHFS2SK8Nsv+T2/mp6HZ1WBEE5JMmIVJ1mtIg1lSDdU4hNlHFtOeHO1VQhLg9W0bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYrTaoNX4/ZrjdZ60xLJVxio2OHaWJNnMoGkjiPgbHU=;
 b=BZgSk76qZUALnTgOFyAXMv3S5H+k5SCGZM9fqbKqbHHuZlF53BFyi62OwXD9qzKS1Uxv+ksQspTMyp1RapWAqGh0sFXBYHCUESmVrEj6kBr8OrMl8OI2D34golb+ozIHzGgYMuvHncVQoFW9aPaICQogghZW0uyk6E5GLVht6eQ/mEKxwQ7N9uOtlH2uIdM9lAKEbnFM74ROBPbweH02LODDwaG+SDznPnugzbOw547beqzr5bemGtt9meKw7ZnXVAPLxJrymAeV16tQmE+APuzyrPBb7tzZJj8evVo+jFyWc2IkjJYCnXGz/b1XHQSVEqtfVvc/we4fz/m/BY41Eg==
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
Subject: [PATCH v2 4/5] vfio: Use a refcount_t instead of a kref in the vfio_group
Date:   Wed, 13 Oct 2021 11:27:49 -0300
Message-Id: <4-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0057.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::27) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT3PR01CA0057.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:82::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Wed, 13 Oct 2021 14:27:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mafEU-00EVFK-9I; Wed, 13 Oct 2021 11:27:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23d1b693-c562-4cae-5514-08d98e55a43e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5287:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5287F0F59E1DF3350FE34802C2B79@BL1PR12MB5287.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yKsd/FauFK/wQnFA+wyO/ja0ptlL/NPQo/6XREVha2Q75Bunp74PaLRZU7LDkOSjmaAPozu69p+kCgyw4lPRPbkhyFr+cpqBHD7ENXp06hMFZcyDUzYuScY7G0VH/eE+0gkJS+qI2ReOAjZZ1NpKmoZOL71z+bHTkxfynnD/uBY7ryE3RFBnvC3kcoqKr1WsGWKRmyLSmYpfZ+HnC1pgkhyKRYCW+IYHXrREe6TQS4QqHXz31vt0bSshbcK5UP4krPH2cYaUEUccEeKNuqxnVzr9OxqG3sRoXxoo5t66qNM+gxsG5+RnQuLFU9/mHOzdcXalBG2XpiH/QVYoZ6iIHGnA/GT/mCTZ5zudCT2F3GKSJDmqrTB1hR6CfQ4V7FKlhZ4S6akkJ8J40VOuRuLVZ8GEvsxZgraDJrDIBu5sLRRyHgCFfv63LRzIB1C/q8EYgdbjbVE2KpbCGt2cpl68/3gC7Yeyf0lvV9QcJ7Ybt0iy+aIRtlzstusVtQhzM8/qlWPCJISsYmXZQ7ySDi98trnC5WOxLgk8D8J0frIRrfJLtodAdcKRTliGMnWlMV9/bGSQOxHX77fHgqKQJGJXVLOTDV5kpH3UldXsHEivoHAQtcIs2G0q4OBAc6lcuFCCloltzCX9PhKSB3Y+4CdWIbGGdMGonD63B46FsbZRXSWgJG6HJdgKX1YwrDCwH30lnimO6eDZ1IcH4+xth0VRjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(83380400001)(86362001)(186003)(9746002)(316002)(2906002)(9786002)(508600001)(66556008)(36756003)(8936002)(426003)(66476007)(110136005)(4326008)(2616005)(54906003)(66946007)(38100700002)(8676002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hdKlKzQLYSNA7/dcUGfdDU8dChfiPMzGq4L1LB3+oHm14VKefQAaSl7VFB0V?=
 =?us-ascii?Q?C6yRPAzIDRY4pqIeOhYTRpdCJ1l3FxnBsP00YWX14mirIZ91p8dpOZwDqewF?=
 =?us-ascii?Q?ukTdOHZe2reIlGTalGFrcT4j+tXBSXXm21p4mqZjn/ZN7XNlePCCAqvPXcm1?=
 =?us-ascii?Q?s/1mnx+W7mJZLShTowEoY/lZQfVvGwgABYEEhITlFb/n0CE2NN5j8g3uKAWu?=
 =?us-ascii?Q?sp7G1xeDp0IvUTxj1j+1SIUcw0dvIXa/ijUsaE4alUSzrO+Eu7d11GoWnXUY?=
 =?us-ascii?Q?XUaeco5l0jg2ph/BxiuoBAL+RYACalCyW8cvtCFNpScSZaXNsDKitHvgdHSY?=
 =?us-ascii?Q?omESxsOBpJIoJLaipM8L6Pb2umUJGaEWdd8kwexFDlS/rMW1+SU53Z7zSIku?=
 =?us-ascii?Q?IwpBvxPdkGfJu718goJNh/LGOSoRbsm1njukXHL7I8XYA0mlFLW5P4nt0hXG?=
 =?us-ascii?Q?HOdjjDuZSfJ5NhREnYTf4WLoVdgUmPS+sEscHK0A0zjqj3L+XOWzc3WOu90O?=
 =?us-ascii?Q?bFNQaqQiJRNt0Z66xbjqybNovYd/IfJF1HdNCsH3NhaNb7/QH3kB/Exdy8YI?=
 =?us-ascii?Q?VPztXlQhH2qaGmEJoc/uSYS/oefDWIzIbKIrOJnIDM66Fq3ZQOQ+AZM0Bosi?=
 =?us-ascii?Q?S7FI4lAsriNCSk5/gIYbPRnLcECdzhASIDBFM+cws7w6ta1t4xbweXYdy3JM?=
 =?us-ascii?Q?KPKdy6HMVdVX0uf1/pLOrA7Z2foDJQAlzpWz/CpLha3T89N77KxUzJmTOarG?=
 =?us-ascii?Q?yMwWQoVQVQM9bH0K9is847GFboekEtXvwQC+CjNKmBdNMYkV3DuQFj5J1dZx?=
 =?us-ascii?Q?AboNP+kdN/ANhcMgpAAamjJ8HILALwAUEd/U1+qmtHENnOyG14Tj2pXPC0fC?=
 =?us-ascii?Q?eM8o+927FwQw4a+kEVVqRZ/ydosoxdfWsQceQf/b+PvGKwV1rm+LhTovCRY2?=
 =?us-ascii?Q?oL4hiAgjZBjn8Umi//FHozMyVcAs38npwx1A1TOUwrFBtFyTjn6Gwfefzp71?=
 =?us-ascii?Q?whs5RjdAV4/KKjba/ibHFU8cWQ05re9TnC6dtmdZyE4wiGPtGo76apZoMhc9?=
 =?us-ascii?Q?TocVd1fKWRLLwoPQAxsLe2mBCL2463ZZ8Q1FsYeH/+SHfPwj3LD4xZ2Tqqjt?=
 =?us-ascii?Q?YYsItyPhvm+19gheJ9qR6A88/RlG+6BucowvOjbZNpgIRnsKxfajDwBupMln?=
 =?us-ascii?Q?/HzD6/6v25ahN/089G8gXECPiqYrVLU7s17W2rcFwJIFAely3AJRhin869wH?=
 =?us-ascii?Q?A2R4RXncE/x16RBdgVR7BlxnOH4iA/YFfD6kAK1FaeAZ3k7V8CN5Uyx/EhtJ?=
 =?us-ascii?Q?7EAgqg8tABmvaQxtlgrZ3ngm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d1b693-c562-4cae-5514-08d98e55a43e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 14:27:53.0350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0NWh64n16T99Gkgp7AZM+brGjIIHN/2R32Yp95DjaHSNdLmqjfm3GIQljQQEBFVv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5287
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next patch adds a struct device to the struct vfio_group, and it is
confusing/bad practice to have two krefs in the same struct. This kref is
controlling the period when the vfio_group is registered in sysfs, and
visible in the internal lookup. Switch it to a refcount_t instead.

The refcount_dec_and_mutex_lock() is still required because we need
atomicity of the list searches and sysfs presence.

Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index fd39eae9516ff6..60fabd4252ac66 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -69,7 +69,7 @@ struct vfio_unbound_dev {
 };
 
 struct vfio_group {
-	struct kref			kref;
+	refcount_t			users;
 	int				minor;
 	atomic_t			container_users;
 	struct iommu_group		*iommu_group;
@@ -377,7 +377,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	if (!group)
 		return ERR_PTR(-ENOMEM);
 
-	kref_init(&group->kref);
+	refcount_set(&group->users, 1);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
 	INIT_LIST_HEAD(&group->unbound_list);
@@ -433,10 +433,10 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	return group;
 }
 
-/* called with vfio.group_lock held */
-static void vfio_group_release(struct kref *kref)
+static void vfio_group_put(struct vfio_group *group)
 {
-	struct vfio_group *group = container_of(kref, struct vfio_group, kref);
+	if (!refcount_dec_and_mutex_lock(&group->users, &vfio.group_lock))
+		return;
 
 	/*
 	 * These data structures all have paired operations that can only be
@@ -454,15 +454,9 @@ static void vfio_group_release(struct kref *kref)
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
@@ -1659,6 +1653,9 @@ struct vfio_group *vfio_group_get_external_user(struct file *filep)
 	if (ret)
 		return ERR_PTR(ret);
 
+	/*
+	 * Since the caller holds the fget on the file group->users must be >= 1
+	 */
 	vfio_group_get(group);
 
 	return group;
-- 
2.33.0

