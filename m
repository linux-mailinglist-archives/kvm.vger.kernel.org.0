Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6F6369D26
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 01:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhDWXIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 19:08:52 -0400
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:31841
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229520AbhDWXIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 19:08:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFSxtASCm9SLGoB/5OFul5QfQBi7U3/NB7qwPpfWtAbNBf53dCWV+/XO8ar8/E2A/qCF3N89kv/CG8heOXCyppw+r5X2bXqTA3XtwJrBm9CwAQ2b26ujiguch8x/2/FRJdkevaV+JCvs+LHlvPm5BdvelnXeuEBGAs74R+CvEbhy+kF08Bkec69AzgUxnUjv/hxKhKagDPGrWL4sENsEjhhCghupylsCos4mbhuc71wtKbRAD8YJOUwD68yXVp6YgghZShyoO9XYJAeetuWYSgoRmtHS7WlaY61v4hwmjbP64zCKfCWA4IDs2FrPQP1Dwr6spVZWXGBsj0rphMv1xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfBa6ULEMCbL/YGVCK2Bc+JO9Km6s19XApwMHcONNGk=;
 b=MlJIOaZI7lhAmHlRZc8E92iR93+Xbm+WvjYdJklmAsL9Z4PvbmT3bPztutXvo31vQ539D/HUtwj+1/zpU2M4oJ1a/8y5CVmoi4ISmaGoeLh9IOLkyAVtWup1Kk52g6ndmky3ll0K9ptS5urDAQlVsEFBuAnhELgmQWkWnSdEK1+gS9WGbQ86sDMc5UzZlIwNUWIe/6ksHDwe9qHINl3+CFQLNmnKaHzTo45qcyrZbDLzbJXjKs8xhzOy/8Iq1M/XzYuYmHjWSN5NDhJen9BzvqA65Ss0AR6TGtAspRJdVznCaAccwpjcmgrxsFFP1t4CdPCS+rF+suly4U8h0r7t0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfBa6ULEMCbL/YGVCK2Bc+JO9Km6s19XApwMHcONNGk=;
 b=KyEPJSZOZq8xH8GLSruA7+StNQIPcIfro+JmvDczHIYb8i2sv5Qtl3XCGcUkDI9TbyeifmhP2sEz8usZ02RMpr+W3Qp5F1Vrys+Sbv2Dr/HDY34FwzyqEFCyK2upP38jXPOHS1PdriWaPkkLeKMnhNNbf/oTzb8WfYrC7qSRVRe2Qhb/P4dqdn6VAwJgrpRO4RZZJ1YHN4zJgxQfrRezmUBCNsZYOSfCMra+l/bWDHV8IT59tlV3NtosxQBcfKQto/C8JHY9Tcwf3XeOs0Ued29E8CRG+IP/ulCuhotu6L07SStNBYgL8dEPVINSAVoRROzelc0rygiKvC9iVnpm6Q==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0204.namprd12.prod.outlook.com (2603:10b6:4:51::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 23:08:13 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 23:08:13 +0000
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
Subject: [PATCH 09/12] vfio/mdev: Remove mdev_parent_ops dev_attr_groups
Date:   Fri, 23 Apr 2021 20:03:06 -0300
Message-Id: <9-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:208:23b::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR11CA0018.namprd11.prod.outlook.com (2603:10b6:208:23b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Fri, 23 Apr 2021 23:08:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1la4pK-00CHzy-BC; Fri, 23 Apr 2021 20:03:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc6c8b8c-4932-4ef0-ab2c-08d906acab7b
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0204:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB02042CBC93E7D702F88DFAEBC2459@DM5PR1201MB0204.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZuzJbEM/s25bHyO9bDuArcHX4KL5NFEPnVMwb5OnHjHpdBTgSOsuiqs8pGo6MHPiHkZHPvRcwzVy3MuXO3pi5Lzgs3071F02tIqpguDw83urA9GiVOCqwLG+chH/KTd61XvERTP5FdRa22zwDaSZABJtTAo9XhHCmFXn8G2WDXaf/B/f8oktDPt2OBP9VS/HZ+nICtuuLm/OC9YspsxNG/YJE1+T1NLJSExK9dlrfdTrE49f33SkddQsWywjpi7853WfvNPpVF6YaBYUVyfG9hIPYLKQAAuOghttaabUY6oPsXcFEEjL15BFHYy4pAv/qybAwQINU0en81PGo7BZN5g8CJ7H+ZyMJ+KrAUWF4Hf/AxhuzfefT/sytyLX4KirNURLkW6XvmH4ETn500FE+mDXS/nUoYhdAS68Iy3e5I/mlFsnaQMG/nIjZR/1EY264Vl/lOSaZuBja8EQCkse6OcwzfLmWau3HhDVw5wZFF9+dZ4m/YTb7IQFJJo6v1cFURidv5VN1fep5aHKmBXE18YqHcI96jj0wXPZEGzPo4a7PS/AuSblSnjYV0/kbBX4/j765epa6hPZ/WbqtYOWdMxQr5Wxaj/oqtzczpyLhUp9AOb+8vIB6VPrcbcPj6xa59Rv6BXzBsGaC4lUNsflTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(38100700002)(86362001)(8676002)(478600001)(6666004)(316002)(54906003)(8936002)(9746002)(9786002)(110136005)(2616005)(36756003)(26005)(5660300002)(66946007)(66476007)(6636002)(66556008)(186003)(83380400001)(4326008)(426003)(107886003)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?J8scp3klLZBJ/qEkU2E3jBTJDMDYI1yTgA1rsj20F7qRBWbF7j5W6TVscw6y?=
 =?us-ascii?Q?3zfKHtphe+Is6XaFvEPIKTO3qJEZ+3eCKV14UqBaj+Az8oTAdoUf8dzJGuH7?=
 =?us-ascii?Q?28lM0E8dm70xRWx2Sbjn2W0Nwxec8HOHIVMUnXAFk6+T0IPWoAjSsTFcBvu8?=
 =?us-ascii?Q?8XHogI8t+ljkyKyAUwUM2fDEJ1iNpI2DU7lpWI6KU9/npMaV7xP1Eky5xIaq?=
 =?us-ascii?Q?1Wah7Rb51gmSUFCcDMtgprHf26tFZopbY2shlT8c8EK4Cvv4I5u11iJaJEd5?=
 =?us-ascii?Q?oIjXFR6BD2IIM9+PVSvp6hllrqDxBRbdgmdSc8XW7VCeVAJsbqIme9onuXWN?=
 =?us-ascii?Q?kqEg451r9Oe+dLx2e8A0CbldLElPGXBd74t0mn5QCAeEsXODM2MF9gI3SlaD?=
 =?us-ascii?Q?jj7/te4RCa1vIE4197l8vW7m+GKqbZTDCAlQOb6sGO4t5t9RtcU116kWZiVm?=
 =?us-ascii?Q?SvzYW1H3oVGogK3TYcKLeYcSPyufEUqy+l2wMQgRLw7AXiTvb3xIhw9KLKtV?=
 =?us-ascii?Q?TBkXSmWi2KoMreRmc9eNqO9N7FoblCuBOIOd091uow8yaZO1RIuDlOSDKOl8?=
 =?us-ascii?Q?8ntEfXM1Z6D50/Gl8DnidS4uNoMjc2TPg8/Wosw7JPGi8VMlzCz4sdEyKbHF?=
 =?us-ascii?Q?m/k0NO43ZRQZ25xffX3KG0Ex4KYSz1pjEUdYSdZZq5H3IySuuRZsxdaM8aym?=
 =?us-ascii?Q?xvJ8j5F57gTbyABFEiooQB/F1YDnnm0y+AqcdkayF62YbVicHAOJx//rGulN?=
 =?us-ascii?Q?Mmx6Y7DqktmJ7Pw8Ku4SAUnlKGQKD+bMy7IkiS7EGW0uBsN+cKctBCe0zuhj?=
 =?us-ascii?Q?FchZJ1u+pxH7caDJr8leclBPcTbqHvwrYRqUYvO6545Eb7BWj9eKrjO6Cjyo?=
 =?us-ascii?Q?vgmtnt8NNfk3K6xBXVg6jCiFmIPNpXKWipEWYUBzrlX3ut37pVUTweiDtD+W?=
 =?us-ascii?Q?DaWYmKq8xo/l31Qysik2ok/SCLwaxsPOMHMg7R24SWg8F12pfck+KTZAQVgq?=
 =?us-ascii?Q?NlHMMejTFri4daQJ+yvmchCzKetkjdNx0oF2wmBFizM7M9zZJdCW4A0g3bBY?=
 =?us-ascii?Q?ZI8BNCRg2pPY6a5OShNFelLTJAIPjXFyeJFOIlmRh9/IeXJcMhO5v2DueB0j?=
 =?us-ascii?Q?oVj8/0NMLgZrReN9iOFOjlAiXxAi2CP1FOKiJvN/BI30s+PFE6Hel+0YNlhA?=
 =?us-ascii?Q?r9QQtWgm0DitHRLO9I0jGneOw69Ws6z9nOdHM3M9dvovEfTrQG0L8aOfXyKG?=
 =?us-ascii?Q?IlVK89xFJ5HSV+66udlFyBPLzbAKMGOXQ/6A1hxEUKRnWxcukual0wTOhoDz?=
 =?us-ascii?Q?I/JRsy9coq4UTg679cUR9C7g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc6c8b8c-4932-4ef0-ab2c-08d906acab7b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 23:08:13.2625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9qVm3iHwHrXekaE3pafAPQrKP71hXntseah6mvHV7e3Zi3lsj/AmVSccObnQOTo9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0204
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is only used by one sample to print a fixed string that is pointless.

In general, having a device driver attach sysfs attributes to the parent
is horrific. This should never happen, and always leads to some kind of
liftime bug as it become very difficult for the sysfs attribute to go back
to any data owned by the device driver.

Remove the general mechanism to create this abuse.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_sysfs.c | 12 ++----------
 include/linux/mdev.h           |  2 --
 samples/vfio-mdev/mtty.c       | 30 +-----------------------------
 3 files changed, 3 insertions(+), 41 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index f5cf1931c54e48..66eef08833a4ef 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -197,7 +197,6 @@ void parent_remove_sysfs_files(struct mdev_parent *parent)
 		remove_mdev_supported_type(type);
 	}
 
-	sysfs_remove_groups(&parent->dev->kobj, parent->ops->dev_attr_groups);
 	kset_unregister(parent->mdev_types_kset);
 }
 
@@ -213,17 +212,10 @@ int parent_create_sysfs_files(struct mdev_parent *parent)
 
 	INIT_LIST_HEAD(&parent->type_list);
 
-	ret = sysfs_create_groups(&parent->dev->kobj,
-				  parent->ops->dev_attr_groups);
-	if (ret)
-		goto create_err;
-
 	ret = add_mdev_supported_type_groups(parent);
 	if (ret)
-		sysfs_remove_groups(&parent->dev->kobj,
-				    parent->ops->dev_attr_groups);
-	else
-		return ret;
+		goto create_err;
+	return 0;
 
 create_err:
 	kset_unregister(parent->mdev_types_kset);
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index ea48c401e4fa63..fd9fe1dcf0e230 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -57,7 +57,6 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
  *
  * @owner:		The module owner.
  * @device_driver:	Which device driver to probe() on newly created devices
- * @dev_attr_groups:	Attributes of the parent device.
  * @mdev_attr_groups:	Attributes of the mediated device.
  * @supported_type_groups: Attributes to define supported types. It is mandatory
  *			to provide supported types.
@@ -67,7 +66,6 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
 struct mdev_parent_ops {
 	struct module   *owner;
 	struct mdev_driver *device_driver;
-	const struct attribute_group **dev_attr_groups;
 	const struct attribute_group **mdev_attr_groups;
 	struct attribute_group **supported_type_groups;
 };
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index d2a168420b775d..31eec76bc553ce 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -1207,38 +1207,11 @@ static void mtty_close(struct vfio_device *mdev)
 	pr_info("%s\n", __func__);
 }
 
-static ssize_t
-sample_mtty_dev_show(struct device *dev, struct device_attribute *attr,
-		     char *buf)
-{
-	return sprintf(buf, "This is phy device\n");
-}
-
-static DEVICE_ATTR_RO(sample_mtty_dev);
-
-static struct attribute *mtty_dev_attrs[] = {
-	&dev_attr_sample_mtty_dev.attr,
-	NULL,
-};
-
-static const struct attribute_group mtty_dev_group = {
-	.name  = "mtty_dev",
-	.attrs = mtty_dev_attrs,
-};
-
-static const struct attribute_group *mtty_dev_groups[] = {
-	&mtty_dev_group,
-	NULL,
-};
-
 static ssize_t
 sample_mdev_dev_show(struct device *dev, struct device_attribute *attr,
 		     char *buf)
 {
-	if (mdev_from_dev(dev))
-		return sprintf(buf, "This is MDEV %s\n", dev_name(dev));
-
-	return sprintf(buf, "\n");
+	return sprintf(buf, "This is MDEV %s\n", dev_name(dev));
 }
 
 static DEVICE_ATTR_RO(sample_mdev_dev);
@@ -1340,7 +1313,6 @@ static struct mdev_driver mtty_driver = {
 static const struct mdev_parent_ops mdev_fops = {
 	.owner                  = THIS_MODULE,
 	.device_driver		= &mtty_driver,
-	.dev_attr_groups        = mtty_dev_groups,
 	.supported_type_groups  = mdev_type_groups,
 };
 
-- 
2.31.1

