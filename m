Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E2641F829
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 01:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhJAXYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 19:24:14 -0400
Received: from mail-dm3nam07on2074.outbound.protection.outlook.com ([40.107.95.74]:3872
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231265AbhJAXYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 19:24:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETEfXtscka92AforI77Mgcg2UGmgc8jWG2I3cZawRCJ8yx/S5bSuGtdrRKrUpy9w++niYzPYhcE50Yl2xkq++eysfHrVtDBsTHdZRvHTSV/IsngO2TA01uK4Ku94VOUip4R5uXYn2TEOE2TT8TVKIbV5SVLkRzsn2Jvt4f978fA74uIybtqSdHMa8Tv8hK8aJTPfjZcJa9NW7A4x3OpTGlqnH4cvsE1T5xGgmFS3fPR0bTlJVb1k+pvvyJEs2Ssq8jMy2XSg0A1LOskIsOMNt+OBt0hYfziV2KJ/K4xBZMeOknE1wwokO8t086X20seMkoDOuej5G1cOycZtbu7RNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Qm1Sw6motFuVsVFkUJMIdKxfkNos7B4o9xY2NIWNj8=;
 b=T7Lcpb62+TQlA1Hp4Xavx7fsyYa6DWQ2CCz4GMMzJ3Qblmet26kRNga4mQihXBhmizjZKgyCMjMlco7ZktbuDlMFPhzjmNqMDakeezmv3qe6evGsGR6CZ/9NZV3fU67c8W+oe4BrjLW3mJfpwqww0Crvxbes8SfSTM2s41kogQthBn+PkbH0OBuJruVKCWvz+E/1M/upYqjGrw6NhEJoQSWqiizsp/HtusfoOVJz91sZYGluhORxqHwhsBYDXQjjU3Ca3XQ1ScsfDqU8VQ3F4YoLJ8BU/RJ74ctiizYf171fIiEG9rK5EUgecZMuoB8/JfEoaVANq3D8qKAxDhiHxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Qm1Sw6motFuVsVFkUJMIdKxfkNos7B4o9xY2NIWNj8=;
 b=UKnTv2CPWm0N3vIC1WBt1NszRODEQPcvsooYVTDxBWVk/rIGY0wl7w6UJdOk2QRjc5ErCWMrlGsahsmnYyoWCntMz91VdaCa3NVxY+lJ6P7RcFHMb2nfxNrVvmARPFZt2F/A58By+pnByZ67zxjUCD9XfT7zx81qrSYLABBE9KfBCiDgcgCaSSGR+gO9kBacMtC1OedhHplMhzJ3+32YcnjeVyOv0WNWoWIaYmtJwkxHGaF5tFAEz6g8sIE83j+sHklXpcjmL4xOJG7g2EnIfGcAMeh+Hem3PcFvUPNyX+zi0DSDfvIzUcsTlbos1migDXvxlB3wc4Csq/Qbe2QLKA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Fri, 1 Oct
 2021 23:22:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.019; Fri, 1 Oct 2021
 23:22:25 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH 2/5] vfio: Do not open code the group list search in vfio_create_group()
Date:   Fri,  1 Oct 2021 20:22:21 -0300
Message-Id: <2-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0429.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0429.namprd13.prod.outlook.com (2603:10b6:208:2c3::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7 via Frontend Transport; Fri, 1 Oct 2021 23:22:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mWRrE-009Z5X-8K; Fri, 01 Oct 2021 20:22:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81c51e3f-7363-497d-1450-08d9853253c6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5362A1BC222A98B5ABD42BBCC2AB9@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LnQBtzhlOIysao/+XS4F+FXhEsQ5G69AurqhiBdbSJx4nhCE+mc+aYkMiLRbcUDdbXtn+YK1VpyhOyOhFN/xE9RC/fZzElEJF8sjBq4FwFwh+GtvMMZdQHHBaLCr/eOOMmDcdFEKTcfPx1oDVlHE0Ufr4Ufg68nSP8eweagGw/05bgeaxRNsXQh3uPtOjjoBg4QSRihQ7R5CS46I+bomnGTKevol3HmQc7fr/I2r8oIyMQi+CGyDGrQ15W8IJoPY4JJpMeE/8pTUkaleKI5L95bnB/iJjYLiWqeBUvYDvor3lqlD+VrQjlpfrTkjxtEHXrNbgcJVYrvD3/5RIvzUIW6xKBQgQSmsUaM69NUrTpwfKpMs61hKsyPOigN/+P9YSIc4MVhwja6MY11ApHzRUsx9f/SMEalCOi/tY4TS8oTn/UucdWe4y+tyZqB5rr6e4OsGv+HFem2hU7oT3CXXPZjil2RGvD6K0/TKW6cBQSQW5MAdHA7HTxS+hKVQMx9tAY7Y4PkuQyUQ8DBCpHZ8ECnxiyZl3ZOaN4HU+LXHEz1HNT6sJm3TuyWg0GJtlq3WxiMb/dimmxg7vkGp7YL+FnsvTIiAftvnfyRlFI2U7YvHtwNJI+oAf5bthoiHvQn6N9bhR5N3aVFmkHbcQ7AaGmBitv6IVxwnEI2OixWu7ORUtY/jz+qjGn6pC836xDnp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(9786002)(2616005)(5660300002)(426003)(38100700002)(4326008)(186003)(6666004)(54906003)(26005)(9746002)(86362001)(66556008)(508600001)(66476007)(83380400001)(8676002)(36756003)(2906002)(8936002)(316002)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M/+AVYogYHk+isFf2L4mibUokPGMe4nRjJZmRmJb9DaGw32uh0W1RRMCpuNB?=
 =?us-ascii?Q?q+CoK7zbFlVy1JvWB+x+iiNxgsioGQdrURjsTbHXqeXM5vlHcf/LAb2dsyPC?=
 =?us-ascii?Q?wbtIttA2c8DurkTUAuiiZEESt9iFKUM23W1orOnVoQ1mLwARPCsfkF0iZ2J+?=
 =?us-ascii?Q?yRkdL4H4l9iXALapWWfh/FyqqbFDMnlCQY7LYDEFK5SNHMAHwA39LmaqtWXr?=
 =?us-ascii?Q?mF2GNK5aCiOTQXMNCPeKEd30sjifFbqWTefi898/bcMHexGnWegjzOcYdgxs?=
 =?us-ascii?Q?XOctFZ3k6rfKBepteBN/W1NdMDdP+iezlfxMif7y0WtXtLhR/bJghY+vAQ/7?=
 =?us-ascii?Q?AHB5bFTY4Y2AyjLIguRELZ1JAoX5KZf2XiP75JoCGNnV11awhiD+TV5MaB1w?=
 =?us-ascii?Q?XWMvzNU3g6xXw4zowM+W7amM6MIXRj/nl7SBq0pouzwAeSkQIolTpPAYzsk/?=
 =?us-ascii?Q?8zTgk7ZHfgj3R80ipTlslXoSwYfaU7Z4yNiNfUw3d4qmLFE15zqXFNr785CV?=
 =?us-ascii?Q?wW0UaoWbhGF6mGXp7AqHjJ1Rfy9Qz4e6rmsQpvh769DThsIglBbovGOwpxeC?=
 =?us-ascii?Q?1Ca4NAELYs7ohDKaQ7Gv3/F2hyd+Vg39O7haIqqJpywIFA8grfYTn3XLbgw/?=
 =?us-ascii?Q?9C4TvPIEN69YrqDG+6DfiHGsAIwxChzOzWDmqkYbeknKXFKnOe+Jep6m1ohH?=
 =?us-ascii?Q?QQnaY/NeC1E8YJDgeQUkDLuV2YWNAAWPcHMhyjFTGu1iGD4YnTjmPiyMCcwU?=
 =?us-ascii?Q?f2xHxmYlDujZyzm9h9Lh2/jJGqUqhjCrGO9QK9Q4X42c28CJtYlcpTlZJIb4?=
 =?us-ascii?Q?wYDOS3qMQcqWwWbApweNG7zUJQAAtE8c25pcy7yHDM1sTB4rf39+kEP5GAeP?=
 =?us-ascii?Q?rkbS/hqsWlu/KRC2JaMyhiCiIE90mpUbGvNESNPUJmRRHoJY0ms/TH9SLrXv?=
 =?us-ascii?Q?Ion3Awvq6QtnGw9udYWzI/IWhCaaRYSmFa898ha/YgqRZdkbvNsra/Ef+PH5?=
 =?us-ascii?Q?u9AFpBNBHF0+4poBcP8PNxDqJNvG/j47VbBkaAdDEI7kd7xvlyoNu2Lf4Yh1?=
 =?us-ascii?Q?VmCyRUoK6ro8Rhw0RYdiDQhfZZ+dMbx8BpBFvenBGNJwXPk+TJFkFxf2hu28?=
 =?us-ascii?Q?cK4zeeojTfx61FpyvaYVrIinuFWFDML6TxF9RApN3zKkcKPUnJWAqlSUYju7?=
 =?us-ascii?Q?EPhmLINvNZ5huy6rckLCS5xiiVM08ynzpfDUzTnplOrt7egR1DCh/ILHPi2F?=
 =?us-ascii?Q?xoNhxvzkFVvAyHegtpudrAUEY8HnBCdJ/9hlTLZVLLNU+WINTubM3XYh0B2G?=
 =?us-ascii?Q?MGSBsRqu3zOtJBrQFgXjtcKmXRJeKqEhf7Q+YrEC3uvj/g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c51e3f-7363-497d-1450-08d9853253c6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 23:22:25.2414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6DbyINJvOXFPdZUmGijdCNL70aF6RIgC3e1yaGPxacpkRggntpfGY0L4I4Anee8H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split vfio_group_get_from_iommu() into __vfio_group_get_from_iommu() so
that vfio_create_group() can call it to consolidate this duplicated code.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 55 ++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 32a53cb3598524..1cb12033b02240 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -344,10 +344,35 @@ static void vfio_group_unlock_and_free(struct vfio_group *group)
 /**
  * Group objects - create, release, get, put, search
  */
+static struct vfio_group *
+__vfio_group_get_from_iommu(struct iommu_group *iommu_group)
+{
+	struct vfio_group *group;
+
+	list_for_each_entry(group, &vfio.group_list, vfio_next) {
+		if (group->iommu_group == iommu_group) {
+			vfio_group_get(group);
+			return group;
+		}
+	}
+	return NULL;
+}
+
+static struct vfio_group *
+vfio_group_get_from_iommu(struct iommu_group *iommu_group)
+{
+	struct vfio_group *group;
+
+	mutex_lock(&vfio.group_lock);
+	group = __vfio_group_get_from_iommu(iommu_group);
+	mutex_unlock(&vfio.group_lock);
+	return group;
+}
+
 static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 		enum vfio_group_type type)
 {
-	struct vfio_group *group, *tmp;
+	struct vfio_group *group, *existing_group;
 	struct device *dev;
 	int ret, minor;
 
@@ -378,12 +403,10 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	mutex_lock(&vfio.group_lock);
 
 	/* Did we race creating this group? */
-	list_for_each_entry(tmp, &vfio.group_list, vfio_next) {
-		if (tmp->iommu_group == iommu_group) {
-			vfio_group_get(tmp);
-			vfio_group_unlock_and_free(group);
-			return tmp;
-		}
+	existing_group = __vfio_group_get_from_iommu(iommu_group);
+	if (existing_group) {
+		vfio_group_unlock_and_free(group);
+		return existing_group;
 	}
 
 	minor = vfio_alloc_group_minor(group);
@@ -440,24 +463,6 @@ static void vfio_group_get(struct vfio_group *group)
 	kref_get(&group->kref);
 }
 
-static
-struct vfio_group *vfio_group_get_from_iommu(struct iommu_group *iommu_group)
-{
-	struct vfio_group *group;
-
-	mutex_lock(&vfio.group_lock);
-	list_for_each_entry(group, &vfio.group_list, vfio_next) {
-		if (group->iommu_group == iommu_group) {
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
 static struct vfio_group *vfio_group_get_from_minor(int minor)
 {
 	struct vfio_group *group;
-- 
2.33.0

