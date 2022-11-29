Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814B463C968
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbiK2Udi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236571AbiK2UdV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:33:21 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D1664562
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:33:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fU0di29TCkw0NlD4zf4WkOM2LGMhQ8yK6PUQTkbgbSVMcP2jtVc3K+tCBZZPNNbohBxMT9Sio2aUB6HofgVjbrjnBqoJmAAMciQg8tmtswY3VIBPG3iV/kGFAJNLzTIJrJg+YHAm0HK0hAPTBhQ5xg2ceOkk95a2gZoe06XSuR9PjRKZSH4DmnJsTaWWHa7vraBVnrDwP2LmdJwWC5dcepBBA1NcUNuo4W3arUThMu8z8cD9o9yQizZY5rCkS/3a9FT1C2r928DFhLzCuYb8ms60Jgxm99qlkwlL2biNUPmiNOIJXkntpsZDEqzlCygM3INbUPCaHtm1GmU2HcmEBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iF6fDDTrtLyplGync26Eot+w5ARiSh+9QqO3BHGsNUA=;
 b=Pd3eE1+MMWKGWvKklSv11xRSTiUzP/zG9HF/ei8vy2KsZYGdJ+7gaaqsPoqa06jcBg8zE4SqSTLgigMU7r3IPSv60Psv087rXn2CBmPOgfQydJQ3m3TKaPUtTR9TwdlijBQLCdxMvybCyXfWnmLyqvfo5dQ3zGwjFz6XyFqcxgMJ3O6C1SvPPo7FhBX+WfjjDDFZr6sy7y2/Y/NkbBbs19uQaA5gto6bGGlUGBF5EsGzUIyubXxbZmIQX8WJmxXSIhaXpGSGIyFMLaOjzhacw75TtPqQvMcvC/ZQ24zwGa6elhf5NtocIN1zB+z6VqMGgy1cBRt5EkqG4aaE6lwBtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iF6fDDTrtLyplGync26Eot+w5ARiSh+9QqO3BHGsNUA=;
 b=ucDLBUUIJatrefwiqNzZwQaGDPehRNv4p9GCH1cvz99XUYmhpz0zmSFffPrnNscsGsmYpFzNGFr9a6uC0JZh36Y6aIDLY/Lsl9HIs9JCOyt4FNpd/zM2Qvlnl/h1j4XmY1qSYZl8JarXP5G6GUpvU40FoXdXz4ABbXMmFr6lKW7orJiA/8zyLfeC/0FYIfeFiii1PCrvh+ww9UOE1H+DEogZvYH6Nr438Dp61LDBqpszSkea4uX4FdHThQeCnO3xEGwhdYcU0FcJywwOL6BlMakJxCA/u+4QfdT+Hj8HLaGlF6EMJTa1Uw+51L63D0hnD9eqvjOboeEfbqRpSs6YLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:32:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:32:02 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v4 04/10] vfio: Use IOMMU_CAP_ENFORCE_CACHE_COHERENCY for vfio_file_enforced_coherent()
Date:   Tue, 29 Nov 2022 16:31:49 -0400
Message-Id: <4-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0028.namprd08.prod.outlook.com
 (2603:10b6:a03:100::41) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: 304f9c4e-5c44-4f17-b177-08dad248c392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +gTkrol6nKTTQowTsH4s2KQ1jWcvibSEKORAGrWKgYu95jW6uhXZcZYMwju+ZciW5TaAZjbKiRtCw3e6QIP7Mb7jReYJYo/m6KDG6tYBYOJ8bf16P2qJe7whXYOBGln7fFE2HAymMEq6HO9wD9tG/63dhr5NYdCEAf4TVvuj6fHo9ysmge0ENkeGqbFMKErdOJN6BATXKERXApTgCLWfU+r01/vZnbDb+hjuOml7sKiK9wPLhPtme0eJIzhNKdg+ffJec/eYi293WJ+7tcvAjGAlXZRd7He5E81H5tc77PzTzAk/iY3QMx2c8o/EapI+O5hRMWx0nevNM+bjer4KtzYXMNs9sVo5DWkhdwfOwx0wUC2bn5KGOkQVl/0mRwNGTZ5ylMQqicV9jLXZyJx6yHC7GzPJ/sSoq/tP5Ilqu4Sw9/H2sE/GZczAn6k7Ey+8p5lOz/6ulDkx8bfD8Y72oPnAkmilNbJQ45QyqH84AlyLaNR/kqohuDAQQIOvbcreAZyI+u+eM33E+1DEQ3Uk5gZ78zoVkuR4HmMx2g3ZiFYchU8egp5xwYMO3GClTt810zF9PwBmrJXhBaBXjyK+ItjjRWpYq9YPS4FoBKoCkFBYDkJpL6Fm5D5x6f6GXRQ5Bc3wPF09d0S37i9DlOL77+n5EalsyE29xOGlQud0LyLLz/PJkluTtbWkL9K+yupaofCkDo3DLVkazZxD3eSgHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(109986013)(451199015)(5660300002)(66946007)(7416002)(38100700002)(54906003)(186003)(6512007)(316002)(8936002)(36756003)(4326008)(8676002)(6666004)(66556008)(26005)(66476007)(6506007)(2616005)(41300700001)(86362001)(478600001)(6486002)(2906002)(83380400001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H2EVSXu/YyP2VgpmonOqVNBPayO9bUq/iHuTOctu93/K29YYkrwkyVnkE2D3?=
 =?us-ascii?Q?o7n5W8PSmhSTB6SoLgpNt29pTSRGq0dWy8Yo+GRiUc7vknwKNwWy2Uk/vNSq?=
 =?us-ascii?Q?MFFae4Q+BhRghMYpPnJCr+wAS5suH8Px3wK8oU+ofcwka0ekIK4xvk9mV5uy?=
 =?us-ascii?Q?puJZw2PqjzSz7Cx8PU+7fBGQQpa+Ya3ogfYx4GM+DFsSqwpAjIFuqkaoeKvk?=
 =?us-ascii?Q?6TNy/zr1qZjXDLlvApNuJIhibrFQiOCt9EMuSyeVVWlUHVgbJt/voskpRGEZ?=
 =?us-ascii?Q?bK1zTxhGkza0NRbPNbDTydaeFCMhzhRI9JGWqQm5LZTASlUaMz0wK31NfE7V?=
 =?us-ascii?Q?efiSBL5z7ntOyAKorLti1d/Azh6y5UumWzYmGjdI2byhO+1h+G9taeHExhF7?=
 =?us-ascii?Q?1JBPD9D2C2o+9Ky/c4QYe7H2+7/Vu7c3kAnyl1VU2XBqsbRZJHyJ0pP1HjrA?=
 =?us-ascii?Q?dvrhx0BMqBtVQchwU6B/cNW6z2TRl1hm1G2Uu/HJiJe51PXCtw2NGOypuggk?=
 =?us-ascii?Q?Fcseqw33GHTcEMjACi2LzAt/+LNoRpK5AFc9hliH2lJrnUIi+pZy4cFcCdoY?=
 =?us-ascii?Q?ZcnpRZhTC0XZ60Qms1YA8cWAkTGSqNAmOKFlzFyqfVtRUyT8V4/xWrg4dULY?=
 =?us-ascii?Q?1Vl9AB1mZ/1gqgyfO6Dilly5Fvk+VALnn+hR8Vt9LxOSOwN4wrPR0sx81JqA?=
 =?us-ascii?Q?05nGhAfFaWGMHeQcbJS67wLPuONe9hUgwNNW9FvJIC39fVgiEQjn/U7jXAdz?=
 =?us-ascii?Q?gDsJzQrMi5Ab4Pk0Qx3a8OhGanb7T7ydHZjx7DYmK/+29Kio5ec6mrAWatsm?=
 =?us-ascii?Q?Bq7wheGfsSQ1YXqLaNbT0LYR4/WDVBBNNnMDZ2dKohqhYb09o9vqHV6h4EeJ?=
 =?us-ascii?Q?tox0Yrrrk+iJ2nK0X2ijIAqFLYp3/HG0cy5yJRwJLRX/P6v5lIDKIIgYCNki?=
 =?us-ascii?Q?gA2NYxfAA5bukEK17AqtpTco1kNP7BT6G1u3kgxNTZW6c8aHermmLu8LXJCF?=
 =?us-ascii?Q?NF6CXkQ7bjYZDXp55zj0wyKNMATnoWNy45e6uT9rdm7ImuWMyiFCf0Uzitp7?=
 =?us-ascii?Q?B0x1k8W3mDwaFLJNOYNNFznYlPbqAAL+04t33uKhaGC2PPlzpbI4l8jElg9/?=
 =?us-ascii?Q?s4HZQs1IzWeD3YFitU5DeB5bvG1nEL6dX5LAbFvJp/YZeVxEXWu92ppi0ZI3?=
 =?us-ascii?Q?f1KEMQtJvYOWj170i7hwX48t/xHNF/Ugk2+F8Ow9SGZ7nOYsZ+8frCPUmHfH?=
 =?us-ascii?Q?1EpdxXCT3BWyxRIdZSL4HfZBsLqDnv+i2NUxBWBA1LNi7m07PsWh5djEnoeU?=
 =?us-ascii?Q?24OZanA49bKASl5/WFoIKoRbN++MXhbCOfMETzVYL7Bzp4SOMOSRgeGCLd1n?=
 =?us-ascii?Q?v3NNlBz6EYRgivaIlwzewSE8I7YPguB21VjmwaIXoUUan5yV6TGse/bzutUf?=
 =?us-ascii?Q?mDqDmidDJOCboJcpiaK/WmD6ajmjMnmlQ2le35b/V360F8ymTaACdl/54KmE?=
 =?us-ascii?Q?l2wCwV2+Pdb/yiFTFCGsc6e65phNWzQkzt3hSs0FKJ/OGuYSmhhfVGInbPua?=
 =?us-ascii?Q?svnLutoI+lt8v0iiobb76s/74gMsjUS+MYVdlEzw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 304f9c4e-5c44-4f17-b177-08dad248c392
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:31:58.8870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G62BXZyvKQ1PRJ+0cqxBjD1rLGidt3U+vclQC/Dy4+MYU5P1rpM1ZXMhLYhVPloz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5688
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

iommufd doesn't establish the iommu_domains until after the device FD is
opened, even if the container has been set. This design is part of moving
away from the group centric iommu APIs.

This is fine, except that the normal sequence of establishing the kvm
wbinvd won't work:

   group = open("/dev/vfio/XX")
   ioctl(group, VFIO_GROUP_SET_CONTAINER)
   ioctl(kvm, KVM_DEV_VFIO_GROUP_ADD)
   ioctl(group, VFIO_GROUP_GET_DEVICE_FD)

As the domains don't start existing until GET_DEVICE_FD. Further,
GET_DEVICE_FD requires that KVM_DEV_VFIO_GROUP_ADD already be done as that
is what sets the group->kvm and thus device->kvm for the driver to use
during open.

Now that we have device centric cap ops and the new
IOMMU_CAP_ENFORCE_CACHE_COHERENCY we know what the iommu_domain will be
capable of without having to create it. Use this to compute
vfio_file_enforced_coherent() and resolve the ordering problems.

VFIO always tries to upgrade domains to enforce cache coherency, it never
attaches a device that supports enforce cache coherency to a less capable
domain, so the cap test is a sufficient proxy for the ultimate
outcome. iommufd also ensures that devices that set the cap will be
connected to enforcing domains.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/container.c |  5 +++--
 drivers/vfio/vfio.h      |  2 --
 drivers/vfio/vfio_main.c | 29 ++++++++++++++++-------------
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index 499777930b08fa..d97747dfb05d02 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -188,8 +188,9 @@ void vfio_device_container_unregister(struct vfio_device *device)
 			device->group->container->iommu_data, device);
 }
 
-long vfio_container_ioctl_check_extension(struct vfio_container *container,
-					  unsigned long arg)
+static long
+vfio_container_ioctl_check_extension(struct vfio_container *container,
+				     unsigned long arg)
 {
 	struct vfio_iommu_driver *driver;
 	long ret = 0;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index f95f4925b83bbd..73156125870427 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -119,8 +119,6 @@ int vfio_container_attach_group(struct vfio_container *container,
 void vfio_group_detach_container(struct vfio_group *group);
 void vfio_device_container_register(struct vfio_device *device);
 void vfio_device_container_unregister(struct vfio_device *device);
-long vfio_container_ioctl_check_extension(struct vfio_container *container,
-					  unsigned long arg);
 int __init vfio_container_init(void);
 void vfio_container_cleanup(void);
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 8c2dcb481ae10b..77d6c0ba6a8302 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1622,24 +1622,27 @@ EXPORT_SYMBOL_GPL(vfio_file_is_group);
 bool vfio_file_enforced_coherent(struct file *file)
 {
 	struct vfio_group *group = file->private_data;
-	bool ret;
+	struct vfio_device *device;
+	bool ret = true;
 
 	if (!vfio_file_is_group(file))
 		return true;
 
-	mutex_lock(&group->group_lock);
-	if (group->container) {
-		ret = vfio_container_ioctl_check_extension(group->container,
-							   VFIO_DMA_CC_IOMMU);
-	} else {
-		/*
-		 * Since the coherency state is determined only once a container
-		 * is attached the user must do so before they can prove they
-		 * have permission.
-		 */
-		ret = true;
+	/*
+	 * If the device does not have IOMMU_CAP_ENFORCE_CACHE_COHERENCY then
+	 * any domain later attached to it will also not support it. If the cap
+	 * is set then the iommu_domain eventually attached to the device/group
+	 * must use a domain with enforce_cache_coherency().
+	 */
+	mutex_lock(&group->device_lock);
+	list_for_each_entry(device, &group->device_list, group_next) {
+		if (!device_iommu_capable(device->dev,
+					  IOMMU_CAP_ENFORCE_CACHE_COHERENCY)) {
+			ret = false;
+			break;
+		}
 	}
-	mutex_unlock(&group->group_lock);
+	mutex_unlock(&group->device_lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
-- 
2.38.1

