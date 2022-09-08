Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9836A5B260E
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 20:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbiIHSpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 14:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiIHSpO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 14:45:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553AC54C90
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 11:45:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eiMZ/jL7NA9JsqogwTo1xXLFVytp8E/WnYmpF+1evUVNF2a0LbXh9ipWq7FrH/EUxFlvZRkr+NsjHWUrhgEMQZ1DohQ8ORFSLEN/WPhq62I1HwHmRpibB6JV7LeX/Q7onDqYkb57bh+P1gJmfQtPnCceXjCTV0GqQtU+W+WjRMrT0V9duJzKWfDXuhqnwJHkv7ZHRU0Ic5/ICoGoNUXVJFVy41PxVOxOQ9JFsdL2WK7I3ZNHzT4175hmhes+x8UnLoDhiwSajHSlTqDv3+UlAfS0oHpfQFhZ4OsZk6YxOgdYQJ6BftutKEb1z72mzRE5VtrnKZt0EgicD8UDosrq7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Kj+ITZRuppA/CYx9bXizwEUhbPS8jVlxVBRNufZKdc=;
 b=OGB3CE9R+wfu2mOOZ2IxzcfIoYcxi03TJ35rb0Sh/fa+PPbZP0mBd4GRYY5K0EuI8S+95w2OgUOBf0YnX5NYC/qMAa30yjmoW/CAJ/hDDw14qP2W+lsnMEdqLOj3O/mdXyWC6p9iloeToZuJAIF3kAYsJTz/JIkG8d1vTAtYZNSy+YvmQfWx2DoGxIXUeqJCCye/sRJNmjMP7tlFZOLqMqcEer6MxETa/yodo25TgNq2cLhtrMNUmau7xrxgBZpZiUCb8gOHE3Ewmwk8XNvyLPm5OjM515OgwDCKkqYZkHnX2j8Sy8FOpRgwU5lO503J9chEUIAHOtxDjvykBShisg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Kj+ITZRuppA/CYx9bXizwEUhbPS8jVlxVBRNufZKdc=;
 b=SxxTb9evGFFHbbHW5XE2bA5bZhaeO1x9cBtPz6AkI850uyFYUNlMQv/kcXzw5PfH1RFsx4gz5z4KJHOlzQ6SqI6RnLAbvtcnnCp/bgIXm3HP5ERIfSAne15sXiAJO/zS3GBZuRTGzZYqzpsF919KjqAcEFEYGuSr4sx1Lk94Btqs8v9NzNFe9qRlVhcM54EV/3fUcxuzMJXLKkXC9rIOKW1xXJfgy7Im5G8tO1ZCrnMPL5hps9pmdMsrq2DUts5bnt83BbH3xoCmR51iIQiyID+kUS7HL2Y64VKQwprVMzpbqrPYeTKRcmhQH1vWGynMg8rPldnpV/09G8lzzXL/GA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY5PR12MB6429.namprd12.prod.outlook.com (2603:10b6:930:3b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Thu, 8 Sep
 2022 18:45:02 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Thu, 8 Sep 2022
 18:45:02 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 1/4] vfio: Simplify vfio_create_group()
Date:   Thu,  8 Sep 2022 15:44:58 -0300
Message-Id: <1-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
In-Reply-To: <0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0075.namprd02.prod.outlook.com
 (2603:10b6:208:51::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|CY5PR12MB6429:EE_
X-MS-Office365-Filtering-Correlation-Id: 58e27391-96d6-457d-80a2-08da91ca3d1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Stk4ACapCPbqWdtxxGdhz0TiMwqumTiJKm9okwTDAsNlu+vWl0BXP/9DUuMQkfJuqukBPTbePFePP0S/L2XuW99rJFrBrgijV6AZve69S8rSYR+i2d5CfyCrvRUVn4X+VWK7HS4z8dPsiiNEqJiFPu9XWQ0vJAVNREMnLNZtR5LX6x0CzZSaX4ju5W0M4FPbdHxPc+scbYKOs6e/Pa7jT4KjS4KrmfvrttUiTTyz6wwHDA0thDVnJWudPhm53oAQXqF1hH/IZxf1F6ht7TRMo2Ud8liVvrS5Q/NqpGMouecMVJO98nSj1/vu0Mou4LUVMl9C1BqTQzXkjmQ7oGnrcy0MmiLxlNKnf3ba7ixI9o2w0IbztSzr0f+ClI7SfMNPJEy8NUmJl6vlqsFyo1XQHmnQWVrFAMm/gBmqY9BQj7czpvKzW0rH/Gbsqx7i2hUB+k+gbTRgqQpWQ2xmnG13PADec277/oHXShrirYyGg5od1f4Lpu4f8u2Gz6FZ1V3Dt4gSdn0qo1iAb3Qg1U04gzZKr3UcVhW546oXV6JLgdJU6f3kr0ulNY0biTdccxT5Von8hhds+1210TB2IoSSiizh0mKsxXrJKmFVvGk8saatYf2W3KrYThryZiseiFLW79f1nflAiqlO7GT+oZin3PBUWpUpOZKJAC+zHj3J1/CHkOJA2iBH3Dl2fNU07sW3aW38fLTXBIvmNoPBA8HXbJiPGVJISWzJA+w/7QOWtJA3TJjWwy+RdfmB7gHKUvsd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(38100700002)(4326008)(66556008)(316002)(8676002)(66476007)(66946007)(110136005)(54906003)(41300700001)(8936002)(83380400001)(7416002)(5660300002)(2906002)(6512007)(186003)(2616005)(6506007)(478600001)(6486002)(36756003)(26005)(86362001)(6666004)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2hClV7/D7WkN1A3OAJ39zMRL1cK8QTlLT0hsTSEiDgSJtx8dQMHE7mANSbvQ?=
 =?us-ascii?Q?CxeLIQsaLmKrGSfATwcv61z14VfprlBlyk5JBILHisrowODfzp4nGXb1uaLh?=
 =?us-ascii?Q?IUjIyU4lMwoAGu9R8jgaiW+6HwMnUsiJ2gyzDl8UCJz22kCwYp1+Ol77tZ17?=
 =?us-ascii?Q?CMnFr5Nlh7bMhK2hm69SL/AGBIC/bqVl5Dv6y0AgpAv8dhvZwqpvymTfdxAY?=
 =?us-ascii?Q?NQJ8qjUuKI5kjrPKG7bn55zILIWnoiTRQG64dapyeig6QG0TwODPqlp1BZW8?=
 =?us-ascii?Q?YXOx/cBEB5rPEoiVPADdcM/iOZBy1/ztS11IH+FlzEgt2FP03NSh1lnaWxSZ?=
 =?us-ascii?Q?1/BnhXoU9WCGM/36zuRiWV63BHFAkcTrikpPezn5L3mpkVSZfNosHeNsZn+0?=
 =?us-ascii?Q?u32wLG92fZG4mvGGAO6Ic/BP9RC5bMcNlAGTdFuk09/0gi+iEQ08V1KR6Bzn?=
 =?us-ascii?Q?moSDl/DVA9Zf11CvewGSkcTD7YxheuFjEDlNI8gPwlMI6kZdGIgiQiEJ0hST?=
 =?us-ascii?Q?qpDryh0KPHm4U/+1fHF+vdFH903WEvKmVSVduB9ljvtK+moY2jG3xzMMhDDn?=
 =?us-ascii?Q?V/h3+xqEfI3HV5q92WsYCB6+AcyL6EPl6TTUa1QIvrYQhna3WBF0rBkf41jm?=
 =?us-ascii?Q?Ly9nCufCIVp2tpb5LUCaz+5wiOMlO4TDr2nhIbMpSuZkuxGhW6J0Jllfjzlw?=
 =?us-ascii?Q?/BDgalE10SToUhlAtu+wflcSYTRqe030qViLoNKUkG3BCXwqw0A8jLUGyYQN?=
 =?us-ascii?Q?aFAWTvqMbt1Bny1ZiL5WZZYZV/njXYB+tzVzSAAYH4JFyT6n3dZIy6tDYnm8?=
 =?us-ascii?Q?ydhT8MNYk/dzbvL4GQiKrsCMKS1WEZGalZZ9oGWIpObWIwSvb27JtS3GI7dw?=
 =?us-ascii?Q?slGpJn9O9WNR9dO9Z6B5OWF2C+8iom6R2oKyYLPsNuh7RXNtOVwMVKX5vUPO?=
 =?us-ascii?Q?JScq7fxxS8XQQR6zEMaC6sZCFMnaxms1ddbDwtEs2ptH8NLByi0HUGEPr7k7?=
 =?us-ascii?Q?DlvrYow5TkNnEbsvdyqckf3+rrvXzJdvAQysbAX2Sz0HkJeJQG5l9QPDcMLM?=
 =?us-ascii?Q?ZKxxLVlcgZNVYIwmuvSE2yELg9Qmc4ykNTc0Qr/1CJWMgwv9sJaHaGpEQPbg?=
 =?us-ascii?Q?LXW+P4a83I8rqinKzGW1EIlGrH+wIazU9PPmCrIdcm4Cu2BFCMJ/amz7kXtz?=
 =?us-ascii?Q?AS+GdWgSPzVOy4K0rasbFPVtvVfIPau203UKdTL+Gx67XpQCkRLVt2dFMrh5?=
 =?us-ascii?Q?zpFrxvAA29wwNOurzYKZTbi9yEC8lLHXyDgROTnwnZ0bdBN3heJZhHv5lA6E?=
 =?us-ascii?Q?impX1O+5oDqBb9qy9WjEINYWgRvO3GZ0jGVs3JQp3m28m5XMR1lJJdhm6XAu?=
 =?us-ascii?Q?xYcKkKH+Lq7irLL0Qep+1KpGbdI3amF0DNPAABpqECarNhGAOsle80O8CZwY?=
 =?us-ascii?Q?oLsHzqDdAV+vHoYw7HtPQv2uWP1e2OKnowL7L1QrStfU8ifeCJbS9jd18qKq?=
 =?us-ascii?Q?R5nRo4XElJS2kKVcj9j2qWQv3P5ObhF0fpR0IvTQruvZxNU/CF1H1g2Fc2FV?=
 =?us-ascii?Q?Ok60hqeEu3mQJgai2ZkrR9dTE4h/DqdjsEsd6Iiw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e27391-96d6-457d-80a2-08da91ca3d1b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:45:02.3011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4wncoz6UDYsChUPZjolLboNAEVc+Bv58NrQ2l82vCucprGekQ1jAEwuAxcDgxob5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6429
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio.group_lock is now only used to serialize vfio_group creation
and destruction, we don't need a micro-optimization of searching,
unlocking, then allocating and searching again. Just hold the lock
the whole time.

Rename the function to 'vfio_get_group()' to reflect that it doesn't
always create something.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 48 ++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 77264d836d5200..4ab13808b536e1 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -319,17 +319,6 @@ __vfio_group_get_from_iommu(struct iommu_group *iommu_group)
 	return NULL;
 }
 
-static struct vfio_group *
-vfio_group_get_from_iommu(struct iommu_group *iommu_group)
-{
-	struct vfio_group *group;
-
-	mutex_lock(&vfio.group_lock);
-	group = __vfio_group_get_from_iommu(iommu_group);
-	mutex_unlock(&vfio.group_lock);
-	return group;
-}
-
 static void vfio_group_release(struct device *dev)
 {
 	struct vfio_group *group = container_of(dev, struct vfio_group, dev);
@@ -376,16 +365,26 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 	return group;
 }
 
-static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
-		enum vfio_group_type type)
+/*
+ * Return a struct vfio_group * for the given iommu_group. If no vfio_group
+ * already exists then create a new one.
+ */
+static struct vfio_group *vfio_get_group(struct iommu_group *iommu_group,
+					 enum vfio_group_type type)
 {
 	struct vfio_group *group;
 	struct vfio_group *ret;
 	int err;
 
-	group = vfio_group_alloc(iommu_group, type);
-	if (IS_ERR(group))
-		return group;
+	mutex_lock(&vfio.group_lock);
+
+	ret = __vfio_group_get_from_iommu(iommu_group);
+	if (ret)
+		goto err_unlock;
+
+	group = ret = vfio_group_alloc(iommu_group, type);
+	if (IS_ERR(ret))
+		goto err_unlock;
 
 	err = dev_set_name(&group->dev, "%s%d",
 			   group->type == VFIO_NO_IOMMU ? "noiommu-" : "",
@@ -395,13 +394,6 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 		goto err_put;
 	}
 
-	mutex_lock(&vfio.group_lock);
-
-	/* Did we race creating this group? */
-	ret = __vfio_group_get_from_iommu(iommu_group);
-	if (ret)
-		goto err_unlock;
-
 	err = cdev_device_add(&group->cdev, &group->dev);
 	if (err) {
 		ret = ERR_PTR(err);
@@ -413,10 +405,10 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	mutex_unlock(&vfio.group_lock);
 	return group;
 
-err_unlock:
-	mutex_unlock(&vfio.group_lock);
 err_put:
 	put_device(&group->dev);
+err_unlock:
+	mutex_unlock(&vfio.group_lock);
 	return ret;
 }
 
@@ -514,7 +506,7 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
 	if (ret)
 		goto out_put_group;
 
-	group = vfio_create_group(iommu_group, type);
+	group = vfio_get_group(iommu_group, type);
 	if (IS_ERR(group)) {
 		ret = PTR_ERR(group);
 		goto out_remove_device;
@@ -564,9 +556,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	group = vfio_group_get_from_iommu(iommu_group);
-	if (!group)
-		group = vfio_create_group(iommu_group, VFIO_IOMMU);
+	group = vfio_get_group(iommu_group, VFIO_IOMMU);
 
 	/* The vfio_group holds a reference to the iommu_group */
 	iommu_group_put(iommu_group);
-- 
2.37.3

