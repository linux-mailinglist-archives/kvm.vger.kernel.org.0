Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EFF63C969
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbiK2Uda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236549AbiK2UdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:33:20 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F62263CC5
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:33:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOJfMJS/tPI/00vJO5HfAPs9Q8UggsT/wRx3i7xTIbe+rvy6c0gE74EHQDPm9Dc3HQ6wbVqeSCIYBZ5S9tJw/R0KeENYyjfjnwSzSoPjITbh1In7EedBGy4fN/BU9mWd6iiZ+CzQgVWUXZKw0JDZpDedlyMxdJJznzcziktjwVa+GkTYvX5AlfNR5mMMeZrBPhOFj+XTnj50DCRq3i3iIBphHoVfMGWvS1X82FDCQZNAm+kumR0gRyqKQR7uSJgvN9lutPNuoHF3iAO22rjEh4Mk9y9fb1rXwET27dRfi558n3fx/gPCjkTJlZP7PlQ4ruI4PsNSJFJnTBDvQHI0gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GR5RFMOWlqY4XxZSJOi677+vckDJcBybW4lYCEKuwHc=;
 b=eLJg9j1E23jaQX1YyNcyfSHszeAslU46uDERANtl8hsMS2Y6qGIXETDu0jEOaeCM+8qJTPbtQaywh4ftDgeuh5miIBpW85lf+Za74eHTeAsWCPOV/w0C0eBxpYezLBn+f8Wb2VCC3zrdpvIRcjvvCRL6UMrI7POf5SFE05Ep3kT8F/2g36KdXytpeEWKY3GiIw7TO7nlKMwAID0Py/i2MaTMH7iaXgcWlegfdTs5i5FnUAW8jp1iqt4f/dgLIAymkBGClIGGccc/hXOmm8pcgIJd50XeRBH+0BjtRrKy7HNQcySFkSgiGGR/oQeNSiGermi2KeU3S0GirxGL24qZRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GR5RFMOWlqY4XxZSJOi677+vckDJcBybW4lYCEKuwHc=;
 b=LaYodLUeM2C5oVCIPYTbX9pm5SHml/oUtP1TqNW3JrIpCmzHYTlunbYpV3vJaDfKVkijhOvSKI+tfK1y7zHGQKEiXDqJNMgfRL4djHRXP/jgJtEMbuLH6+tt8bdyJL/Hm6lXn7EW6wQ2hn3XivO71R9QebNLqfGAP0/Nu9fJhQRLF1UPGbnQ/XF/8sx4MCNx4FDR38A+JSl/QGMBTuZOZpthdrzI2Ef7/SBPrtoFISib1Dhs2cMXJxwzaKeFJHac20ka4Jifz2iF5fKlt8RueNJJ5MCnMfJyGA8LezKbfB0VeOHam+DP1V9KHzGt/DzuvKAlJCbfYtEivLgY/I3SEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:32:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:32:01 +0000
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
Subject: [PATCH v4 03/10] vfio: Rename vfio_device_assign/unassign_container()
Date:   Tue, 29 Nov 2022 16:31:48 -0400
Message-Id: <3-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0057.namprd08.prod.outlook.com
 (2603:10b6:a03:117::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: fc571974-a3b5-4080-16b1-08dad248c376
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NrVHX5npJ8MzY4wuQsq+tKtvTBhlYz6q+QXqxrNVcS3xvWJ9ocWNr/aqoFGKD3gCyKOaosuNjghlp+BdYQhlm+wIIKE7AgrM6rSGgPoXR+yXJWQBemlr9Jk4Ad+vsT4ofiJXRF98wPmqpl1bOv9t3lSg8EPTUFwh8J73BIItLm8RzIeDCqlDz4Nnybk4tao3HEKWrc6Qvr3wl9Hr/LhI+YaJE26mAFGr4gKQPJcNQfiy/ULLLaiI11z5Tqi9FtcbMriXlxWCDWx6xoqosUENKlCAdC5LZhu6G5FjAbBp+R+yEsuE1Nu+O47yf4ND16QQNmEKty3wSP4gMMDKTito8/Ex2By47CqZal4K3rJe7O8brwPUDXf4aGH55Y2NBH+mVWlbSnJqsoBiR24SZfpNWKaE18TcwVHFO9gRGQD2aqMjRVhknJPLULm988M01ApacS8pUdcs3N5EvN95fHEWl7VlExwE6zEjbnGF0qCiPnDn1Dlz9M8xROKYdF0PXSRvjw7Nr2wc9aY12GgyZRBSl/FOiTsZyYjxoTG8RSeK51xeOdhN3zR1y3FwxUxSWTyIZOizqkDaOuHOvrho8YKC6zgVPGEfDGhcNN+uPZVbWKz/J27N4wedqrgKHh/iEofl1X2YqxrARzaCIwlzmhqFfEuHXZUowUsFoFKmx5M2xcBjmHICPjv33InHaCnSvhVn4+j+UCeeDrlam3K5f8cIig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(109986013)(451199015)(5660300002)(66946007)(7416002)(38100700002)(54906003)(186003)(6512007)(316002)(8936002)(36756003)(4326008)(8676002)(6666004)(66556008)(26005)(66476007)(6506007)(2616005)(41300700001)(86362001)(478600001)(6486002)(2906002)(83380400001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CCtvHQk3goirj592KjC1sxeq41TY4GDnxJ3K0TcWz2M57TS6YHhkRcep2GXZ?=
 =?us-ascii?Q?yL8q4Y+VIMhCZR8r5yFYIu6hBjMU7PMoKC532a50xocO+ucAP3OUlAD1Lx3o?=
 =?us-ascii?Q?J4fGnMG6jFg3EOuEZ47aCZYt65UA+SjqTw2p/w5//pqR559ydjdfsgP3fy+I?=
 =?us-ascii?Q?5Hu8WVbd2ZwhBBTV+mdQv7ByA1jL87tWVbPqX7YVqNPon3hAWoiCI5FnXL43?=
 =?us-ascii?Q?jZu8uoLQcrELGI3HOIEhT/n9gWLdty04LFdk3ErpiPfBkg4AlbzJSP6oam1z?=
 =?us-ascii?Q?GBLd81IcfZu3Pq9e7cYkldItD3na6hFQY7xU6aTDyfRgFN0uHN1BB9Ry4kLL?=
 =?us-ascii?Q?I+2u4zXM5fFZsUZGm/yqXUq2VLkDSVwIXWmAkwBiKvkY8LidBBP/hE6B9LxP?=
 =?us-ascii?Q?ci5U+OugoVGUg6q4l1bfOR4YaUkNRdoriVxVCZAyZFbjLKrggJg65WbEhzOZ?=
 =?us-ascii?Q?OxF+UrYl0PYqSp2Ng9QTh0qDzkW6lsOD7G4ZXRzkw+O/cFuweWLEZUnkXL5n?=
 =?us-ascii?Q?Cp/s1HlZBBKgwezjxYSI/fvV0z8EGGY7gVqaXPtTh28jGs6wbBt/qWkldoxt?=
 =?us-ascii?Q?H0UsL3tQsbKrUv2vvc+EbZGWFgQh+fCOMy+fjKhcoeboeXEPTRMVxML+Wa4Q?=
 =?us-ascii?Q?zNpWLLzloqdzXA2E39aX9SfpKCRNPP28lCEHap1m1v/FFCDZbpknTo8zXgyi?=
 =?us-ascii?Q?Z8Tv8YNvaKQDgSkgXibgokfxJna1/GcYGsdHLvQWeQRr8rwvbhAaN13lPzr6?=
 =?us-ascii?Q?VOAwjWG7IVkVM5PoK4EEWkZ7xEB6PJYqM6P9p7JlkUv0KmEKogbsgN44QVok?=
 =?us-ascii?Q?G+/hPG77XRShqhZRBJOjCsBW958XfxdUDF95wLZ4dTG2BXkeUmtQ/2u0fBQc?=
 =?us-ascii?Q?I0FKCMrKUiebNrHxia9uR134GZwtDp1erGPor/m3e1m4F2tmbaPNA2PFN02Q?=
 =?us-ascii?Q?17GlS4DLEC0zKFlvh8grmzRtXxMZ5pvKc236wDi3+dOhMlo8p9/lCfKNjVjY?=
 =?us-ascii?Q?HtGY7wLXw20Qb0f9lxRa6mbv+KK2Zr9v56we6VwlcjGVoOd+olBJ8SZwNN76?=
 =?us-ascii?Q?Tz7tAjZOQRKE6/SxY+Qslb9pwlxVkEOWJeLWfaCHSTAZjzw67CQBe/0H3Ok6?=
 =?us-ascii?Q?srNH6C5izWXCYQuDF1q9jNcUNkxQ75Lu//BuYo7YywUhWmd7HlmGnSaAI3tP?=
 =?us-ascii?Q?uXLLP9wEo1sR0TsBa8lEmzrK/rq6nQ1exLA+w0q6LI1dojqhyKbFx+BQVIp7?=
 =?us-ascii?Q?Q0yfJjotN515IBrVrDMVLF4jxFE0Kc32ex3o+xVBNHdtp9B4y23iQYDnAcdZ?=
 =?us-ascii?Q?8e8OyEQh3UT9B5/LXEJrys6+gcM4Jj44mjqnWNk2Fp3ukFvaKbT0ssYpBu2O?=
 =?us-ascii?Q?hM4ETZ1KHl/9g/0x1LBZjDO+bP0rGRj9cAILpxIUCC5q5Go4oco7w+f2ypFR?=
 =?us-ascii?Q?JoLhRhIJf+n7jyDwsU3d19nu0oBiQ9WaBH6wRIAb5jWK+KMXcrQFWvNOTBdt?=
 =?us-ascii?Q?fQMNQ2hG0D1AElQi4DEAlzNkPNYVAkXpiQQSlQ2j4geHsBdx0Y3V7Wp6RI3k?=
 =?us-ascii?Q?ZagmrB5gsmY1+lwuqQeZD6voBxvoGsINbwm7v3M/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc571974-a3b5-4080-16b1-08dad248c376
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:31:58.6839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GpACl2/fPz/ysLytkUXa0Op8rzD/rdEREimz0fzZL8Uu9tjx1kAhIiYmFrR0p12D
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

These functions don't really assign anything anymore, they just increment
some refcounts and do a sanity check. Call them
vfio_group_[un]use_container()

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/container.c | 14 ++++++--------
 drivers/vfio/vfio.h      |  4 ++--
 drivers/vfio/vfio_main.c |  6 +++---
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index dd79a66ec62cad..499777930b08fa 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -511,10 +511,8 @@ void vfio_group_detach_container(struct vfio_group *group)
 	vfio_container_put(container);
 }
 
-int vfio_device_assign_container(struct vfio_device *device)
+int vfio_group_use_container(struct vfio_group *group)
 {
-	struct vfio_group *group = device->group;
-
 	lockdep_assert_held(&group->group_lock);
 
 	if (!group->container || !group->container->iommu_driver ||
@@ -529,13 +527,13 @@ int vfio_device_assign_container(struct vfio_device *device)
 	return 0;
 }
 
-void vfio_device_unassign_container(struct vfio_device *device)
+void vfio_group_unuse_container(struct vfio_group *group)
 {
-	lockdep_assert_held_write(&device->group->group_lock);
+	lockdep_assert_held(&group->group_lock);
 
-	WARN_ON(device->group->container_users <= 1);
-	device->group->container_users--;
-	fput(device->group->opened_file);
+	WARN_ON(group->container_users <= 1);
+	group->container_users--;
+	fput(group->opened_file);
 }
 
 /*
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index bcad54bbab08c4..f95f4925b83bbd 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -112,8 +112,8 @@ void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 bool vfio_assert_device_open(struct vfio_device *device);
 
 struct vfio_container *vfio_container_from_file(struct file *filep);
-int vfio_device_assign_container(struct vfio_device *device);
-void vfio_device_unassign_container(struct vfio_device *device);
+int vfio_group_use_container(struct vfio_group *group);
+void vfio_group_unuse_container(struct vfio_group *group);
 int vfio_container_attach_group(struct vfio_container *container,
 				struct vfio_group *group);
 void vfio_group_detach_container(struct vfio_group *group);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 717c7f404feeea..8c2dcb481ae10b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -749,7 +749,7 @@ static int vfio_device_first_open(struct vfio_device *device)
 	 * during close_device.
 	 */
 	mutex_lock(&device->group->group_lock);
-	ret = vfio_device_assign_container(device);
+	ret = vfio_group_use_container(device->group);
 	if (ret)
 		goto err_module_put;
 
@@ -765,7 +765,7 @@ static int vfio_device_first_open(struct vfio_device *device)
 
 err_container:
 	device->kvm = NULL;
-	vfio_device_unassign_container(device);
+	vfio_group_unuse_container(device->group);
 err_module_put:
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
@@ -781,7 +781,7 @@ static void vfio_device_last_close(struct vfio_device *device)
 	if (device->ops->close_device)
 		device->ops->close_device(device);
 	device->kvm = NULL;
-	vfio_device_unassign_container(device);
+	vfio_group_unuse_container(device->group);
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
 }
-- 
2.38.1

