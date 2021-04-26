Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB7236BA77
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 22:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241787AbhDZUBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 16:01:09 -0400
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:3982
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241741AbhDZUBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 16:01:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAdk0N/w60rua6nUqiyYvhACQ/LZVKG6+RDiA6uSL8wNAJLuFv/pWI1BRT8/V9q+e+M05hZ2ESAc3Yrpo0DAMw2zL3Y5ygCqMZDmxE/5ykbwag2HIHLnVbME7yoJSotqgK0eVfmsN/dVafQCNTCBC2YHY3C3pUfDwrLSYwNsUrb0Wq6MGytkj7mqZBqMHhFhsSmc35lKHsSW+fWeNP4XS4QRn58Vv+InZM/IZ/2iIA/wVXsrzL5XHC5yy+NHL4xZaAjG01OXURjneSyZjzFoXZftoKGDEGSG1/c4pbE7P5WXeUC4y8iG+4+jJSQ+PUejhr968y4shpjsCr3Qz6Uvfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+Z4dTi3Z/EAr7+nWs6UlI6AlA3va5v5ZjSREaY3vf8=;
 b=D1ybEdf6d8hO9R2t6yHTb57vQ6pTFj/ESgIx+HJ9TNmZdptcPkpBlkO1Mhh7dpDm5ORMSvtcAg5Jin5nO9ig6agzbZTvlG9arOlCtK+EkhLxThRtKCtGv1yzqJNveeyQJH2pHWckLRmgdtCzm34k+Jg7mr+67ZSV2E/WtIyQimNPhxM3dRigcP9bSLWN4ErwcgGgSlfhmNF/eyYUeGBKtJmAaLJ3TcQW5tHWpclBqWfwDpwcSFuMS2W0fJsjMO6koZjJLDOiHyr2N7snQm6Hvc32qw6aycIDfl2/7YtLVLYqNdoC+FfybUwhIWl7iDXPQBgNm1m7582uNhoSnQoSDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+Z4dTi3Z/EAr7+nWs6UlI6AlA3va5v5ZjSREaY3vf8=;
 b=bHe4WasjaL3BgJfWOakxkIStoVD8VLWUSt+n41uPHwft4TvWGVjU9+Ylo0l7MaBpTNgOpGX5qMR0NLJ5V+FzkD9QQtGloFXNa5YQGhQEym13jwLmkW5yyslFx52yheLfc+3uUGhL6dVOTGnIZyWYimrQXz8AUaGKdCreJZvDuDzIohJeRNs5T3M7LRmE+chZzXABJsDNoWOCboA77EqbCqry0xifT0e5UbUu9GE3SpJ0GlTeG+cH2l64tLPs11yK2G2g3GGLFe2zeQNgCzieZWiVsRnlCKXyvGy6amnN5PLBF+BqW8kTgKv7THf43vATsbcm3teLOPGKZsDXIWW8ug==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1659.namprd12.prod.outlook.com (2603:10b6:4:11::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Mon, 26 Apr
 2021 20:00:21 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 20:00:21 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 12/13] vfio/mdev: Use the driver core to create the 'remove' file
Date:   Mon, 26 Apr 2021 17:00:14 -0300
Message-Id: <12-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR14CA0014.namprd14.prod.outlook.com
 (2603:10b6:208:23e::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR14CA0014.namprd14.prod.outlook.com (2603:10b6:208:23e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Mon, 26 Apr 2021 20:00:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lb7Oy-00DFZj-6J; Mon, 26 Apr 2021 17:00:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a50a912-85b2-453e-16d8-08d908edea92
X-MS-TrafficTypeDiagnostic: DM5PR12MB1659:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB16593B582E66F63BB9E4DBB7C2429@DM5PR12MB1659.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fTxKyEt3+T0nGwaAiiB4a3dDp7mUTJak6UEigLXK1uxeOe66Hp0VYgbaLVo5ds6+O865Ti8m9atVSPm6eERcebBmLueh9Jq7uG8wXoC73SH0t62vCDOxwdAF1o0nu1rgGqwAuMEb1clJKJj99kYKn5d3GnnJvtFLBxk187W9UUl52BgRMoqa+Jlqtzafa671c32dKtZVKioGm5ruTpbYrn+gu39IuEWc8SkibGT0foaWYHu56WXMG7WSol7zkpMp3HtIBkKgVx5WkqKmEaE7BuaxMAKkWg7d+qV+6AYFWjWxPRxO5nBM6UmfZD1ZIu2ixzY+xm7CccIheJs9XGMa3CzEzh5XMNhEHwYsCIJJryjp7yUlUZu+nBwaEiHOFpguuuw1PMI9e/tHDjEvlybNE1Cv0enbEig7ZYSxesUa/YaAUPQrYrLYCITcNbE+mGb1DMJxdkQ3f5zZLHtpD/prc6LDbS6pjxY/FP4LbemZEIySHj2L1uU5h/6jwdfu4iL6gKWhHtHizBxT46Jdjw3vg+E51zhQym2W5QMLyY3ngZ/pQuBtNfJZQiBw8j7axa4lOhzgDLrcSNihOKXT3aqFjrQvXMEkIsr8OUfoKlFxtHg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(66946007)(36756003)(66556008)(66476007)(8676002)(2906002)(86362001)(6636002)(2616005)(8936002)(478600001)(426003)(83380400001)(5660300002)(4326008)(38100700002)(9786002)(107886003)(110136005)(9746002)(186003)(316002)(54906003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5RqBgjAd7oVWR0WyWb2BKccfg2g2en7JIiQlA+gAeYHhL/IONkn9Zne0CMdK?=
 =?us-ascii?Q?613U3rPxm3UF3mzg0uxJ9zgsbczgn7r2kea8hP36fhim9Mkm6xiqtcdtKecO?=
 =?us-ascii?Q?JCGHb0mtXhlUgbzEA5Ee+xEuCNqleeZ6plU4K3JkEFrzz4OaOZcyeIe8JzCW?=
 =?us-ascii?Q?kpByLaC/D9xiexOPjBTrAa3IboIUwEFGLOeM4LTmQorAkps2iPEae1zJUlDx?=
 =?us-ascii?Q?4ty3IOZM/l/AggmrNSSDZKpFa30iy++HHTUFzQf+3VyukI0SyX8toCLfjbwh?=
 =?us-ascii?Q?/cTdJs+YqMRjvPzHxJmEEW2jPYJzeYEw3WHyWPCJG54O/l+vX4uJX/pHxS17?=
 =?us-ascii?Q?kJ3OzcM103GqdNy/ATe7dc1xT9CcUSPCmg+t4Z5c4fQkqgyXrztUmjJs3JPG?=
 =?us-ascii?Q?u6/WwX1a4IM4gBhYFZ7N/hPMoTt0NcYq1fE3sXtfMfxaot46hNaxpodI0GAd?=
 =?us-ascii?Q?UHJUH4T6yEChcD1EnTFZK5uVhkfzEtWQljLlFPjhv5oV6mMK1LJMsv3zsFIm?=
 =?us-ascii?Q?quSXg7zv76ms9EQAvDaJ/pKjzBb5MqkH5RAxj/MWq8tVJWLFS0ZvfJmnQGXu?=
 =?us-ascii?Q?kMhFn0JrPVyypj5XmBVqQYi5+RgtIgIvMcYmGcV4FCHBBqXUudmuonsvEbZW?=
 =?us-ascii?Q?3rnotITPQhQ3PnoP9pgQQlVqQV4hd/LF4J+8RnnMME4gjN0zFSiLQePzrrHX?=
 =?us-ascii?Q?0r4Ju4aQurbxPwqY0Gd4wfVmOeUiul8KM0utESW/KAeFTnGN8uMWPjwqsotm?=
 =?us-ascii?Q?3y9tpsv9LW8qV4+w/lWXvkAwiYt2AI1Kq5krW1vx/VAt0Ka0mh6DmCVL04NT?=
 =?us-ascii?Q?OXRoY6Lc6DQukMzb4K2sjpqFkjrl/lNtkzn/tQfTuD8f6tiKQ7Qk7tccPw3M?=
 =?us-ascii?Q?lDb1PlAKRL3NZoRofXgIYbM8VnTlFW/U91ruQq1jUFkUk8Yhv28YmfsvtxJn?=
 =?us-ascii?Q?5ggO3+0KdDXOiJYmYU6xPczUSM1UATJlERVAqvkxli1guMqix2jGUwM6Orf1?=
 =?us-ascii?Q?7aRGvC8m3KISuODBZrUZu/JR5PwqS3y/v42EfdFO14RcUCvDEFhfHmykbPAa?=
 =?us-ascii?Q?W2jDdaZKUcoIFrq94BySyvPX5CZGYrtpKm9Y6J1NloNSVRGbjYlPpNwM3pEQ?=
 =?us-ascii?Q?89Mx0Kkd6zw7CmotN03ibHF6VzSUPKqKOA1ag8QNg2k4zisIRXflKztBsPu6?=
 =?us-ascii?Q?05bPuzdXEBJYRZv7xSVV+Ax2AMDs/QAN7CaDsAp9Is879OVEdAkjLPURkrrh?=
 =?us-ascii?Q?GDS6cBBlVIVrGzsMvWU9hYtNMWZ6/W0j/DLvUVpOQhhH8C1CXs1XvvTNXOBN?=
 =?us-ascii?Q?cKQK8F5YP8u6Gk1jnB2VJ1Fp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a50a912-85b2-453e-16d8-08d908edea92
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 20:00:18.7218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3UfbVt7LROMPytxUSWRbFynmmWhQ9usZ5DspmNFYabvaw5U/Gd2S0i8H5MmRam6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1659
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The device creator is supposed to use the dev.groups value to add sysfs
files before device_add is called, not call sysfs_create_files() after
device_add() returns. This creates a race with uevent delivery where the
extra attribute will not be visible.

This was being done because the groups had been co-opted by the mdev
driver, now that prior patches have moved the driver's groups to the
struct device_driver the dev.group is properly free for use here.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c    |  1 +
 drivers/vfio/mdev/mdev_private.h |  2 ++
 drivers/vfio/mdev/mdev_sysfs.c   | 19 ++++++++++---------
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index cd1ab9fe299445..a61685d8844d44 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -302,6 +302,7 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 	mdev->dev.parent  = parent->dev;
 	mdev->dev.bus = &mdev_bus_type;
 	mdev->dev.release = mdev_device_release;
+	mdev->dev.groups = mdev_device_groups;
 	mdev->type = type;
 	/* Pairs with the put in mdev_device_release() */
 	kobject_get(&type->kobj);
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 839567d059a07d..c6944d3eaf78fa 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -32,6 +32,8 @@ struct mdev_type {
 	unsigned int type_group_id;
 };
 
+extern const struct attribute_group *mdev_device_groups[];
+
 #define to_mdev_type_attr(_attr)	\
 	container_of(_attr, struct mdev_type_attribute, attr)
 #define to_mdev_type(_kobj)		\
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 5a3873d1a275ae..0ccfeb3dda2455 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -244,11 +244,20 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR_WO(remove);
 
-static const struct attribute *mdev_device_attrs[] = {
+static struct attribute *mdev_device_attrs[] = {
 	&dev_attr_remove.attr,
 	NULL,
 };
 
+static const struct attribute_group mdev_device_group = {
+	.attrs = mdev_device_attrs,
+};
+
+const struct attribute_group *mdev_device_groups[] = {
+	&mdev_device_group,
+	NULL
+};
+
 int mdev_create_sysfs_files(struct mdev_device *mdev)
 {
 	struct mdev_type *type = mdev->type;
@@ -262,15 +271,8 @@ int mdev_create_sysfs_files(struct mdev_device *mdev)
 	ret = sysfs_create_link(kobj, &type->kobj, "mdev_type");
 	if (ret)
 		goto type_link_failed;
-
-	ret = sysfs_create_files(kobj, mdev_device_attrs);
-	if (ret)
-		goto create_files_failed;
-
 	return ret;
 
-create_files_failed:
-	sysfs_remove_link(kobj, "mdev_type");
 type_link_failed:
 	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev->dev));
 	return ret;
@@ -280,7 +282,6 @@ void mdev_remove_sysfs_files(struct mdev_device *mdev)
 {
 	struct kobject *kobj = &mdev->dev.kobj;
 
-	sysfs_remove_files(kobj, mdev_device_attrs);
 	sysfs_remove_link(kobj, "mdev_type");
 	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev->dev));
 }
-- 
2.31.1

