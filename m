Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F26B42EFD6
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 13:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhJOLnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 07:43:06 -0400
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:17792
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235362AbhJOLnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 07:43:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNSEom4GNBEOqe/kNIbFxRa0XsFUYQDjkl6/ODu9BeKg/2n3XtJ8O8wI+CzIoBXKPtsG0po409qRzwvcDCpzcjpvtdgaYGsiX8HcDxuiGwZVa/IJsbKF6RBjo38L5fDMrkCAV70oD6oJ85j/ESZpmb2VwaJZSdYQlVsNUq6VD6sM2deuwui9MTajFwRUkzNrrWv44eApGkNmolbXgBtB9LyuXRIVhcLB+agDJmWn7/Mh7pECN54YgjNV2dOqpmgkBYXILXXZxz8helBLB31E9rYVSle66ajOlKiKa5PHS0rPEqMXQ6jB7y+qseawr5g7dlo1paZXf/O4qMYYuP2Hjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezXvN704jPzVDJ54OuVKb3u9LevIgfumt1V/U08xKBo=;
 b=UU2MniXSuUK0GfsebI01E9YCWv9X9/qWgJRBcRfo0Ktf1vvPWyxy95z+bWN/sqYcUEJVtAp4ypXvKmaoOi38BLkERAekwDn+PH74RxfOPTe+TdWjv+0I6oMt/OKzr+8Yuyr0iM4FH5BlUvOChjRk6YtgyeUUfsn6ysuiSo1W76oo/czsloc2AJoj0OZkpS/oU7dgLss6xLVP9ggh0f3awz1y6UzPqfoNtKj0704fy23nDi+HbEbJdMjZJEYqv/IZxICVeCrJ54gGJQ40GiobC9GPmngAB2dSQMJqfu4tuAJD9ksg81Nsf/hpxzM4z+sjZi7pCr8jvv5dGWyXoPDiVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezXvN704jPzVDJ54OuVKb3u9LevIgfumt1V/U08xKBo=;
 b=c2buIbdicmP4Qo+HBKnzoSiPVzcO9mCkGzlYZUOhERTa6LNI+w2fuIIsi7UFURw1x9K56fyk919q2QXv4+lsF04MSGKRg5MrNUaORoqWoV9+tYxclgg/S6WeRQ7ne78IOG7VAz1DIZ3/+9hgn7sH/SZZW/unepeMexXG8ykJs51L10APT4Pk+CscR3CH6+oWHRjYmlQgus7VazBdblf6+Wwj9xtc6S5tS3fTVL0CDV6TknrMpRKDMQCUTcN2axD+olQwaWsaW6DCywYq+RydNM7mgx+eK77wh7tDhnWQw+GVirG/Rapqj+/SgyWKQjQYl1YWatglnpBAiozbP04JAA==
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
Subject: [PATCH v3 4/5] vfio: Use a refcount_t instead of a kref in the vfio_group
Date:   Fri, 15 Oct 2021 08:40:53 -0300
Message-Id: <4-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:208:fc::36) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR02CA0023.namprd02.prod.outlook.com (2603:10b6:208:fc::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 11:40:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mbLa2-00FJUL-7z; Fri, 15 Oct 2021 08:40:54 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11c1034a-51ed-471c-a377-08d98fd0a5eb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5208:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5208F5437D5F5E04DB547D4AC2B99@BL1PR12MB5208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l5+h2Wwq1mvJPwXM40HuhP4CPM+edwRgzutSdHHPVxm908XZIJozU/PsThf/VlJiA4sBHfMhXnvSNn8oLnet/xgttqmjpaMUHVVbCzTBRUkvtnzbzg3MBuWJ/RYSYTsuRv6cPyMG5RK+2tzKPvmSoy/7W1gyHCCiZB86iyEM07V4oyx0m9UADF/yY1uMhoZOCWQuqSFN7yejUjkRMomyRgPyR65FRAZGKSNDY2jMZ6O4nWWZ7OHejK93MhG+spRqswSLUQsWqWy/iNmcyROXJF7S6QbW6O5lpJSMezYg28saqsjs9jZRlm1zXFEK844WkbxSnVVYMz95xZfTTjrMYu8GAGHXlcKr7Z+78vb7zQbxNYRTA80K4stpg54+NhfOyUwdi5mwhT25kJ0KEfmX4dz5MaPGqff2IGkqG6hSa1mQoTDIUNF89M2pCCl3xImhL1SmWl/DedW32QDTz5vqqp7UhzOw22SLlUlnBxrP1wPqbGB1EQ+hE1PfA3oVO4NxSm+XtD+NNvJzzmW2iNA7wiSlrpeOm1acyH+pePrUgPUCTPyMQtWonnA4LWR7bXJVuWIxxu7hwcxCeXtB9eNOLJUs2lyyXoJF+74D1TPoIGVNWsW/RdWqF5kTopppr3YcT7KKJMBtvwuwwZRJu3zEXVPSDXO7SuOjVBt2HPhss6GBD+a22LLMnPmTaF5gpHAH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66556008)(38100700002)(5660300002)(8676002)(66476007)(2616005)(83380400001)(4326008)(2906002)(426003)(36756003)(508600001)(86362001)(186003)(316002)(110136005)(26005)(9746002)(9786002)(8936002)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S77FQswZceXIt0fU+7j4Bmntc+CyEZQnFOoPSUY4kHv1qJ9feW7CUaVDKFBR?=
 =?us-ascii?Q?gf1vKqJriaiI/zq0P5jY5MVnwFVg6HLV3R7iQbFKslDG51fApflxMwNt43jn?=
 =?us-ascii?Q?yfRpM3n5is/xRAFbn+CWCrI50D1KH1wdqt4qfmSOD8r+QNe2V2o5F7Ix/8ys?=
 =?us-ascii?Q?/xopLxfX3x+hdw9aVc9+1rq8ScNx5YhhPU97inJnxHS2Yt7YS3ZQ14lUmCAM?=
 =?us-ascii?Q?m296Zcy9Qdx14nEyaaW1kCmDYL5qCIBR6LW1EqJinsyBAOwt8reneFJYFjXi?=
 =?us-ascii?Q?jP84Fxe0UCN3XM/xtcqyh1qWCy4XP25aC27vuq0ETuozFOBu5qXQ5UT7ykN2?=
 =?us-ascii?Q?fxEBmQQFK5u+stnTMonSsyRogPnsHnJtfG2YzItA3lASaP3DmSgzrN15UOOX?=
 =?us-ascii?Q?SB1qQhdfb7jkys/rIh05loXflznI+Lhcf6Zu05pTCtawAY0wi4okm59AA3IO?=
 =?us-ascii?Q?xhUpAfo0tFKzgKFW6P/IdqQrdHcx4l6gufUGCHNLFDZeziIM7ujlQg+b5uHw?=
 =?us-ascii?Q?Wp2pUD9cKud2qwc9FyMYpSoW3kTJOQkjzAsuwAlBU1+jN9B2bIw31gaPGwBz?=
 =?us-ascii?Q?eto3Yf7BWxnl151oTbl009UNc3OI8fPWe3Szb81IA6SQnPl1bXslFKb5p0gv?=
 =?us-ascii?Q?c/osZre2FKF/05oRbUWznTOIDsYrm3FdamJIxIa6gElhh3+g9FmePuMP7zu4?=
 =?us-ascii?Q?ZpvRj7mUhOGwsGLGmxwFBXspD3LGZ5VN05YcDn+GoK8oEe17ylguFuCU51p/?=
 =?us-ascii?Q?oPjMpXMQaam2g38+TGHwjFcmXZcfuq2fyxmbsmEG0PrKx+FO8khTXYCAXMqa?=
 =?us-ascii?Q?36zL9OOLl7LiWlStG94olMu/6RaQZUw1qCv3MDJOIHtSfEbthfYTOieC4HFQ?=
 =?us-ascii?Q?1KGqNg+zLWyckrGK6YuxS1gWud4lLjliSqTmuvkWboO8kDFtR6fQRcqPXUW0?=
 =?us-ascii?Q?J1588IdaNwXIFkkginXixJzMOJu2Wptb/hurONNpS1TUFjm1KICSZd/iCF8B?=
 =?us-ascii?Q?/5iZxBEGMy+Gv98hGGjLhdBksFaiUr3uiY9XZ9A5fqDMPQ9fc82X3oH0ATSD?=
 =?us-ascii?Q?hvid1k+0FhMSn1ExTydSTDAmEQFfgaIPURQVNjJbqe1HCUNqwrMwB65bOKY3?=
 =?us-ascii?Q?e2O47CK+OdpEJd+x+8fVViw/OFI17bXoQTG/+8j3fZ8NJV0Pfpsu+nqigS0X?=
 =?us-ascii?Q?4c9WntUS5IFxRJEAu1EedXwewo7SSmqnUBw2ewjooxMv6qZPyzua7H9Rk/WJ?=
 =?us-ascii?Q?3N3tmGSii2mcoQHMjj5s64PK75aqcxKU5/ciZC/99b53oom3M5FRgCEatVkc?=
 =?us-ascii?Q?7UG+X7JV85qnK3qhMKMfwaX7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c1034a-51ed-471c-a377-08d98fd0a5eb
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 11:40:55.0543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RFlhtUKOOBsFetDFvdQljLGzD9brZlQWr4YS4YXl8lrqLVhqkDW78tMHELoTr9k9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5208
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 4abb2e5e196536..e313fa030b9185 100644
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
@@ -1657,6 +1651,9 @@ struct vfio_group *vfio_group_get_external_user(struct file *filep)
 	if (ret)
 		return ERR_PTR(ret);
 
+	/*
+	 * Since the caller holds the fget on the file group->users must be >= 1
+	 */
 	vfio_group_get(group);
 
 	return group;
-- 
2.33.0

