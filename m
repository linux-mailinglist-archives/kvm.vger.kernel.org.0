Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45047369D04
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 01:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbhDWXEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 19:04:01 -0400
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:47680
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232501AbhDWXDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 19:03:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=If0g8m8i2nzPmKnPkg0Vlq6lnKTIZMgdNeXW4b7AVtFEqwrb5sHqBl7kUR7JLBkVx0KZSkeMquu4VbQg1XVY37OXGOSZxt+sL0aZuTfQ1dVtjovtTtEg8vBgSBYzWNOYdnOEp/puNHjxrXw5sGi9N0RCV99pfB6C/6Diq6wQ6BIM7Q4SWLQV5ajFwbqxf/aL6g+PMDiVxQ9xde0+KRONt95B6xFSfDnqE5PDBpWsf5qvbxy9WO0DGj7NQM1UDu93+6qraycjcf0ch/RlZB40+xS+Mw0SwQOB3TmzvL1IfLC/nudFsAa1iYjpbwg90xKibG5Ano2WigCCJYvkbIcH/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDPOXKOfIOdInGCyLGIap09VVsl3GRFLLYQvJ8e6GbM=;
 b=RAw5xSyubg7Rb+aFXWXmDe/3pgn1tQOmxvsiGW4KpfIwl2Gt6+XxL8wZnD4PEc1f6Q+A+Qdpl86VS82obPhfZS5pbKPoWwfoH/26zNRa9yQkmw2zrnicriCvUTnorAQowPrhx5jt2H4G5Rr5lW9TKo3mH927LQVyUce4dcn+SJnHcyFpL76XdAnLP5vvUkUmoGvBmtREiHlWm6VotkbDzcUUcpWUeXiEzxG65crPOJhL9UDfeH3G5KQlmEbMYOzQ1YpYu0WK8H3JEbLNEhl3Wvt91TcgzfSqi18bXBeHDmBLnYiG9uoEMCd7xVe2qRiBpX6B5JE2Dm3TZjoyptxDIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDPOXKOfIOdInGCyLGIap09VVsl3GRFLLYQvJ8e6GbM=;
 b=fssvyGXVDkzMLtQ4HpbR4hAjVelyCyOhgOTS4hWWjx7unzbSlaZhC1VNdvx/OLWOnOp9pHdbunERBvQXUpvrBhSX0G/AayUVxLDPr2+PtO4axQsH5FuTWzSC7snpnvc1JjGTDrbMlbE7Qx1Srfix0ezvNKgi04CQijEJegZISZ3777fm1MSnsJSV4gQs1l36uVZgacushbjS7B5lhmb9zu1q8fsmF2JB0PaajWYM5vYxW5FiOy1HIkWS1/awcL4Ri4b/pJ0vuNgtBv6o4VtVavFfCClquSegkqLNYwF/8Yz0S1/oFILZbZBvXsGgf2SRCzb7zd7YWJST3cp5CVZ7PA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3513.namprd12.prod.outlook.com (2603:10b6:5:18a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Fri, 23 Apr
 2021 23:03:13 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 23:03:13 +0000
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
Subject: [PATCH 11/12] vfio/mdev: Use the driver core to create the 'remove' file
Date:   Fri, 23 Apr 2021 20:03:08 -0300
Message-Id: <11-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR07CA0013.namprd07.prod.outlook.com (2603:10b6:208:1a0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 23:03:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1la4pK-00CI06-DL; Fri, 23 Apr 2021 20:03:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b55872ec-71bf-4b55-ab70-08d906abf7c1
X-MS-TrafficTypeDiagnostic: DM6PR12MB3513:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3513F55DEB310FDC8DA7D82BC2459@DM6PR12MB3513.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ml/j6m8secfjF9y+GRR/3d/6eFef0UlUwhrwdqxhMR9DbtDf7V5PIV03m83eYuG2I1irPfyQJwZfpJKApe6kulK9NZwtBQVqMOcLh1eC6VE+uENFHkmAYxf30JFuhmv4XQCP5rzjwQzPakeIWizSPsGPtCidgi53Khuu5eialEn/czvNJEQWcAs9C/HasYzEbX2lbnecoN157dxurJnDwaGpUF2YjAKMxmLbtapsEtTTy//pXGS3qggvR8eXVoEb6i2NeAyO11h6wCRQj+8yktdBqQquigXTgoFWBPE0yhcCAL7ZBFIHD8VKMYO85YK/FtJj/7mG49tOAtgWyzMre7ELNEZdIJ8P3WNibuoUCUDGnctBgeX+TCXjOoaRdIE+kq47tCZnBU6IGUkb1H9lkQDl/uAcPugTm6GDZv5776zXtGb1hyRgkipJBueMRdloG/MtWiQQthJx95YKhsebbNXjTjy4f7+rYAvm2Y/Ku93on8caiN0soFSXL0KO7hPdJ8DvPI13i0YI+aollDd6d4kHunCQfV9FhUWCklc4LZlowaotVvBNFyELj3UmWsH4CwdsFA/vPtDvZPMgmjHj0mEvI/mbPFVUrWwGR92G8iE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(36756003)(66556008)(26005)(66476007)(107886003)(426003)(8936002)(83380400001)(9786002)(5660300002)(186003)(86362001)(9746002)(54906003)(38100700002)(2616005)(316002)(8676002)(6636002)(2906002)(4326008)(110136005)(66946007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZpQFhQqSTOt59WWuXxuJi22DyF0+oCF58skHlp5baI9B0oOcaRo+KIFmE/sY?=
 =?us-ascii?Q?8xFTTitmVxdOcKWAU1Cg2TeiczzGlp6TFppEAOMmxzcwqMjEx5oKpfvRsvx5?=
 =?us-ascii?Q?x0hZdAUUII8JwyLwtE+vLEMVZcDa0MGpZoj4MpcZXnJ8hIhYlfIFXU8fqlHV?=
 =?us-ascii?Q?U32zeYAWFJRbZ/lz53EdnSSHzZ03Ee/c9kelRnHLkEq/80RsAgzETpxLNlW3?=
 =?us-ascii?Q?8g6mjzo/apeaArcpJmr+T2WZtJH8mDHhFOJo5+GLWjwX2to8e9NAexpuoePC?=
 =?us-ascii?Q?MTBg2CFclwpIxdqEBxiSFhzwT8TZeZHGzisdzgx7+AckqUUa/bT7EWJms01H?=
 =?us-ascii?Q?/e9+Y6wASh2RgvYT8jYN5q9tzhSXv9fme95R+7xNfJKGClF/nEyA76bQUiCm?=
 =?us-ascii?Q?FrlF/iR/yK3oEisPQJxhLYhYnruxnupqZkL/mwpl39Qh1xiP5TFi3P9uGT0M?=
 =?us-ascii?Q?vOq3JWZA1lShdc6cNeOO9fVurxz+LIAhtuHj5U0DMVJd+EWLWOLIY8yBMs4F?=
 =?us-ascii?Q?U2Kn4U4QBA/fhK/XNlNwcwKzZYO2qKqjKNlxtX5ah7iVxzQ5TiR6J3cX6wYQ?=
 =?us-ascii?Q?ZKyMvrYV0ULQjEGi8tjdXyUaO21QqQ1gfziGvqxzO7E0v8B/S3PdyFYtAcaT?=
 =?us-ascii?Q?QlOi6zwSFEZG4HA/RCZpV1tr0vJkv2gcQkctTknnLH0le3vojttF4Rtttf5I?=
 =?us-ascii?Q?85ghMebcey5CAeTIAQ0IIgUp7aPB9xSaV7Fe8rO+lVjhdaanydrsrJAorpPw?=
 =?us-ascii?Q?E8MJNyqRwPGsbQLZSjXv5y/gJ6pha8RYQdA9Lc4bznWk5cTH9WVzlcWhyDvm?=
 =?us-ascii?Q?5u4yj54qUApByqL3BfoKIQtfvqIWpGst21PTtEKVv6Ku8mGgIa/7OMcLS8Gm?=
 =?us-ascii?Q?xDZb86EM1dIhL5zsdCx5LMrQtcPT+XjgceIioFZBAj4MUw6t8Q63d8c4wWnd?=
 =?us-ascii?Q?KEe28MK7v7uOjcIxi6N0VKtAOqhTQFwzAhfxBCOtnygnlq+TQAbwH8386ODW?=
 =?us-ascii?Q?SEIpkp80uHlzXif1tkl6sbSIhHVdrw8o+58h2fS0knYU0qTm735sFZB5oxdA?=
 =?us-ascii?Q?c/IXkXh1Yo3DO5k7ypQRN2pDNCnDRL9hFD6WL8O4U9SkjHVz/B9sB7s+V2q0?=
 =?us-ascii?Q?EA+xb4NiqDA70OdI52rAYpQvc+KCaHO8g884OPI3wHbTr09CdzyRx2wYejgo?=
 =?us-ascii?Q?6hcfVn8vOM4vRy34/XhKRhvl04MzW+Bwv8R9EHof/hX2kkJmHwKeH/jT3dm6?=
 =?us-ascii?Q?tfFXX/z0j/CKzZfDF+WpVFaF7KyzV888zTNCXKi+Yyt6jdAy3I1+Ya9RpbdU?=
 =?us-ascii?Q?xVGHlm46qIoVfA5u3ubM/Ol5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b55872ec-71bf-4b55-ab70-08d906abf7c1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 23:03:11.7123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a5iNyxVVGNFC+AlRbGVheP4s0Pqmnx2xevOE9eRLT2v89SaVdRcdTZs9XgE3J3gS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3513
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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c    |  1 +
 drivers/vfio/mdev/mdev_private.h |  2 ++
 drivers/vfio/mdev/mdev_sysfs.c   | 19 ++++++++++---------
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 7e918241de10cc..93d0955ba993f9 100644
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

