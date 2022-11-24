Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E09637C25
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 15:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiKXO4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 09:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKXO4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 09:56:33 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2088.outbound.protection.outlook.com [40.107.102.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFE86F833
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 06:56:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNPl3X/qQ1fDpMywuxgUKalzGTW4Sa948dofnXB2t3LE+A2MIKGF5f+ET/cRxPi9RdZJkqAiVr0SFt4QJ0re4tc/jO0/9Yk1PAKbvJxCOKPfzZznHYBJqjOcGOu4IrlmvNSR5k7yDuA/8lDcrS4AbJnxG4z+j0xGeGeL8KnT4nXyza01hLMOJr4RMpo2grFF5iBWmsDOdso8davmBxCwS0XeAZLlnYwGNnj6gpRTcstaOXRiVaBexV09s8RqizgFTOM5verVcmD0lA146E2wSUHythgXymqy0FT5fMzzDdACteUDnkFtFolZcJQX8Z1dTZVg5y+REo6TJMmeO3ingw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TK4BGonupQuSoylg8swKp0tveOj8rU+EgYxn3enVwZs=;
 b=kh9uQ02MkjvyATcw13pnEZqkydAInHdGJ+23Kym04pxxKbSpo0aBFCQcE12e/r/2LI/UFshbW44dwi+WAZKn7hm/KYQlcN1yP8Vibw6A8gIwFuEm+8xpXuKjDXmznt6/V1gx+UyI4UZ7soySvyfEOy03OG6Hg64QAULS0D1OgVLg1ka66qAaz8cyulCNx/vDOyuU9yoMo4UAb7UUUQgvdgwtxvIOA7bFqXMmBy5InV3B7xF9v43etoE4eRGot9YU6pTcgwidk5cpPoi/fRV76eUa+fL+S9WHdD9zscghjcom57a5a8gneTTWVYc5Rn64gKD+gzVz+9xEJVjv17lr2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TK4BGonupQuSoylg8swKp0tveOj8rU+EgYxn3enVwZs=;
 b=tJ+gdLl2WEAPMnCTjjT5jnJtmRmfeBB3KRZQRcuWolZ4Ocz5k1505HssWmcOw3XjFrc3YeVYHeHxdoOAvGu5Vn+Z/QDepiXZgkvsrQElardwOdr/+ObvzUobZa+t3GzE/VaaYb4aTW/QEcB9MqPBnqqTk7W6EjgONM96hi1ZBV23+UsgmAkhsSA2+NDwZApD36sjbmTPO4+ATIIFo5batDkLbofHR5eTS1GngVh6f8tmIWg0ozP3eNqYm/VwEbCFMIyNW0sGdjrMfetcdnJoK+ONcooP0gMe/uvw4pPmPLB6dyx4ud8O7P0nU6wCFDuQQ7k6XXh1yhhMyQAAw4zK+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5103.namprd12.prod.outlook.com (2603:10b6:5:392::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 14:56:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 14:56:30 +0000
Date:   Thu, 24 Nov 2022 10:56:29 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        eric.auger@redhat.com, cohuck@redhat.com, nicolinc@nvidia.com,
        yi.y.sun@linux.intel.com, chao.p.peng@linux.intel.com,
        mjrosato@linux.ibm.com, kvm@vger.kernel.org
Subject: Re: [RFC v2 08/11] vfio: Refactor vfio_device_first_open() and
 _last_close()
Message-ID: <Y3+GHbf4EkvyqukE@nvidia.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-9-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124122702.26507-9-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0299.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5103:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fa94e43-030e-4af6-bdf0-08dace2c122b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: if5/2UgedeufQgbIKapPEy9ZQCUuGsDy3qRYYISyR0d5QQSl2xfdQh5zTEJZ+9jJsvWJgYs3ZN5yK0KnotRPIv0SKgexC6eAhyKkfUlGFvAmFCiGlI/MoD+VPKYdU9RREw2khoj+TTFqt9PA8SyPlRBNjtnDjdwm7KFos2MyPe4ralTRYB+nuACXG2QYpy7UtUcxNLzUVJkbm0imc7VP3RDCFG1iuMOCvP/SVb4Pl8iXSZvw9gCC7mZNA7EErCgy9oIrEYNitYToW8d7CNiKld7xesTAfOZCP6N1Pg0ZVOc0Hkf/ty3gzz1q2Ti9i202X3FJVsuZuAwhhKXSxiWoTYa1L1IcjVD9L1Sdqw4Dg0t0r0G0+WTGE8wZSIOtTf8SrgyKxFRF//92tqsCdZJw4vFCD4b+Rj9rF9u5vOSy7TkS3QzX/ujJdFArwp85YyQAYclTAK0SvkW47ifgESqYymq3MDLrbKXhrtIejL81jmQz+w6TnF+PtUnSVbOO4cfTskravC7Poiy4e3NhFkAMY9pCAxXp7eGtVNwwEOrB4vc/XEslnDHQUFzaHKr1KAIh9Sa/MP09Z3h2azCap8HSJWT522SeeAv18eDxhQ5rinRK7/dsgksQcu/0VVI67LKEe9lVjl+tgf134r17b5tm074jNoa7D53QBEKYoHHpOgaX+nZWEFD+y8jSTvXjIoPY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199015)(36756003)(86362001)(6486002)(6506007)(6916009)(26005)(6512007)(5660300002)(478600001)(66946007)(8936002)(4326008)(41300700001)(316002)(8676002)(66476007)(66556008)(2906002)(38100700002)(186003)(2616005)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tmMEJMBMeINVcp7vd6fib8O/J3Yuu28TVrhPfXmgnd/f9Qqu8Ut8rzBFCSgO?=
 =?us-ascii?Q?2tjrI2qnW0FoKwAfjp2pvkJeo2oRz8xUignlHIHTlcte2znKsLtvDonaWXqH?=
 =?us-ascii?Q?Sg2TrShGdOy1e07dO6W1ofju3O2rQX47n7i7YA/E+qFAllLYzYlLlAIj9TKg?=
 =?us-ascii?Q?wmBs+cMSZROkLh0Gk78o/MaM8iXQ7o92Iav9yVp8gdDi9c+QiaCkKHjSLUrg?=
 =?us-ascii?Q?/ybHQ9UUPNZCihr2bAriC3zSZwwxWnNleBHUMjBCFuWV58WBtfOCrPkFtaFz?=
 =?us-ascii?Q?CG+gCDB9NKDY3jlXFLvpp8qC2hKCO3z4qUOJO0CMxhBMWgZc1w4QDvsj9/4c?=
 =?us-ascii?Q?3wr/EKKVm/nPZLqFGoUXTukqwY6QEz4pU0/EXWIi3bY72nUFWT3qVPTCcRIc?=
 =?us-ascii?Q?f2ArgOtWqD5mZ1p7Wyv1ot68L2gpSa//k7+NqenZhIlhy7adKHRgLTENcpwi?=
 =?us-ascii?Q?3dr3FZuCHY5znsO0SWFRW1lvImN8txlXuEhJNXgl4CLTCNIlCZcliW8hYDLi?=
 =?us-ascii?Q?LYEqf7IuiH3o8dAQV8P6sCdjUAy7AJ7bO6tcF6nXBwM2tyYggfivJyfeHbb+?=
 =?us-ascii?Q?QIeFCSFdxbTGxwN450eVYEKrQeCJPXoqAC/xngb5D5R10jfsfy/Wm5k6ZK0M?=
 =?us-ascii?Q?j1i0AL39VspRzsBlZfz/30q4iAbBhHoYBLgqgIiI7jUTsslm6aQsVNLH1rCs?=
 =?us-ascii?Q?DspDXuttSKB/r+EU0ScwVGPSur1jM3vlNT0MASYJw2drmVtwovnWIey3B0Zf?=
 =?us-ascii?Q?vwo0JL1s/uGOW0gDzI4vm78rICMPbcY2blmzehXpTIdE5QAmlicuZduRaLYX?=
 =?us-ascii?Q?lXVoEaNTIXBa64pqtAKB+rsAG5EneTOqNrjI7zSfqj2oI7mHK+F2rTHp46hu?=
 =?us-ascii?Q?ig6WZ7BQ6S4NAy73FmIOoEkSnsIC6G56P+773ri80t2O3qM5W5pZD8zwWHYW?=
 =?us-ascii?Q?tPaeqQ0OLwpUiA1PDtvqT6ubJj0AtnXlDvG/ZexQj3zi0/FRs8Z/KyYQuwhz?=
 =?us-ascii?Q?8vA7OSUhtvSBpCaRJMluu1UMYKgpGB9+buYxe3fBICqdnwCipv/KUH2yAjAa?=
 =?us-ascii?Q?wVuloHCmQ5FDcWzlj5sKx/z+UdePQBD1lTF/fGRz0d/NxgWaYl59Dlvi97qa?=
 =?us-ascii?Q?VyMamkyF+0Ljh4Em7UzOwu3skXJ2xLEr+yfR9wKKr3IdAkRrSmp+PHpeo/8r?=
 =?us-ascii?Q?/eXJVIs6HZHVjs2bzKmaTxx3QjGfRDacK80lZiPjBCxLK7bUiy1V3B1iTAbY?=
 =?us-ascii?Q?pHUiTMsOSnD9MU53BEbjHQ4Vmts/KuuXB+rli1cFE34vKg3x0xcxYkNb8XRy?=
 =?us-ascii?Q?3baxxfzTZpZCe6Qku+SHLSdUTjd7IU/qJjywWPAyURvD1N5kCLsytXXXplJm?=
 =?us-ascii?Q?DcQGfZTTBUKVyaUGHEy9OgkSUQWXyi1Y+K3BzEtvamob6Otca5TuTBjM+Gl9?=
 =?us-ascii?Q?vgplZnn7rP5o968Fz7TeErNdQZBMBCEj8RpFqahX57uRO0goTdKc30Z2mlRB?=
 =?us-ascii?Q?upYeXIYAmVphY9JIhkUt0Nu5dj2z5GtfgKHLEDPgJGs/zHSDnOOy1OeE1zML?=
 =?us-ascii?Q?sZml5whs8yGJPBTJiAQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fa94e43-030e-4af6-bdf0-08dace2c122b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 14:56:30.6293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HzC51jOm96S1rslIY0ZTEQr2fC7/yCnbEikZrM0RMo6qrItKLRmavKv4egM/fiy2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5103
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022 at 04:26:59AM -0800, Yi Liu wrote:
> +	kvm = vfio_device_get_group_kvm(device);
> +	if (!kvm) {
> +		ret = -EINVAL;
> +		goto err_unuse_iommu;
> +	}

A null kvm is not an error.

And looking at this along with following cdev patch, I think this
organization is cleaner. Make it so the caller of the vfio_device_open
does most of the group/device differences. We already have different
call chains. keep the iommfd code in vfio_main.c's functions.

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 3a69839c65ff75..9b511055150cec 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -609,61 +609,32 @@ void vfio_device_group_unregister(struct vfio_device *device)
 
 int vfio_device_group_use_iommu(struct vfio_device *device)
 {
+	struct vfio_group *group = device->group;
 	int ret = 0;
 
-	/*
-	 * Here we pass the KVM pointer with the group under the lock.  If the
-	 * device driver will use it, it must obtain a reference and release it
-	 * during close_device.
-	 */
-	mutex_lock(&device->group->group_lock);
-	if (!vfio_group_has_iommu(device->group)) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
+	lockdep_assert_held(&group->group_lock);
 
-	if (device->group->container) {
-		ret = vfio_group_use_container(device->group);
-		if (ret)
-			goto out_unlock;
-		vfio_device_container_register(device);
-	} else if (device->group->iommufd) {
-		ret = vfio_iommufd_bind(device, device->group->iommufd);
-	}
+	if (WARN_ON(!group->container))
+		return -EINVAL;
 
-out_unlock:
-	mutex_unlock(&device->group->group_lock);
-	return ret;
+	ret = vfio_group_use_container(group);
+	if (ret)
+		return ret;
+	vfio_device_container_register(device);
+	return 0;
 }
 
 void vfio_device_group_unuse_iommu(struct vfio_device *device)
-{
-	mutex_lock(&device->group->group_lock);
-	if (device->group->container) {
-		vfio_device_container_unregister(device);
-		vfio_group_unuse_container(device->group);
-	} else if (device->group->iommufd) {
-		vfio_iommufd_unbind(device);
-	}
-	mutex_unlock(&device->group->group_lock);
-}
-
-struct kvm *vfio_device_get_group_kvm(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
 
-	mutex_lock(&group->group_lock);
-	if (!group->kvm) {
-		mutex_unlock(&group->group_lock);
-		return NULL;
-	}
-	/* group_lock is released in the vfio_group_put_kvm() */
-	return group->kvm;
-}
+	lockdep_assert_held(&group->group_lock);
 
-void vfio_device_put_group_kvm(struct vfio_device *device)
-{
-	mutex_unlock(&device->group->group_lock);
+	if (WARN_ON(!group->container))
+		return;
+
+	vfio_device_container_unregister(device);
+	vfio_group_unuse_container(group);
 }
 
 /**
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 3108e92a5cb20b..f9386a34d584e2 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -364,9 +364,9 @@ static bool vfio_assert_device_open(struct vfio_device *device)
 	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
 }
 
-static int vfio_device_first_open(struct vfio_device *device)
+static int vfio_device_first_open(struct vfio_device *device,
+				  struct iommufd_ctx *iommufd, struct kvm *kvm)
 {
-	struct kvm *kvm;
 	int ret;
 
 	lockdep_assert_held(&device->dev_set->lock);
@@ -374,54 +374,56 @@ static int vfio_device_first_open(struct vfio_device *device)
 	if (!try_module_get(device->dev->driver->owner))
 		return -ENODEV;
 
-	ret = vfio_device_group_use_iommu(device);
+	if (iommufd)
+		ret = vfio_iommufd_bind(device, iommufd);
+	else
+		ret = vfio_device_group_use_iommu(device);
 	if (ret)
 		goto err_module_put;
 
-	kvm = vfio_device_get_group_kvm(device);
-	if (!kvm) {
-		ret = -EINVAL;
-		goto err_unuse_iommu;
-	}
-
 	device->kvm = kvm;
 	if (device->ops->open_device) {
 		ret = device->ops->open_device(device);
 		if (ret)
-			goto err_container;
+			goto err_unuse_iommu;
 	}
-	vfio_device_put_group_kvm(device);
 	return 0;
 
-err_container:
-	device->kvm = NULL;
-	vfio_device_put_group_kvm(device);
 err_unuse_iommu:
-	vfio_device_group_unuse_iommu(device);
+	if (iommufd)
+		vfio_iommufd_unbind(device);
+	else
+		vfio_device_group_unuse_iommu(device);
 err_module_put:
 	module_put(device->dev->driver->owner);
+	device->kvm = NULL;
 	return ret;
 }
 
-static void vfio_device_last_close(struct vfio_device *device)
+static void vfio_device_last_close(struct vfio_device *device,
+				   struct iommufd_ctx *iommufd)
 {
 	lockdep_assert_held(&device->dev_set->lock);
 
 	if (device->ops->close_device)
 		device->ops->close_device(device);
 	device->kvm = NULL;
-	vfio_device_group_unuse_iommu(device);
+	if (iommufd)
+		vfio_iommufd_unbind(device);
+	else
+		vfio_device_group_unuse_iommu(device);
 	module_put(device->dev->driver->owner);
 }
 
-static int vfio_device_open(struct vfio_device *device)
+static int vfio_device_open(struct vfio_device *device,
+			    struct iommufd_ctx *iommufd, struct kvm *kvm)
 {
 	int ret = 0;
 
 	mutex_lock(&device->dev_set->lock);
 	device->open_count++;
 	if (device->open_count == 1) {
-		ret = vfio_device_first_open(device);
+		ret = vfio_device_first_open(device, iommufd, kvm);
 		if (ret)
 			device->open_count--;
 	}
@@ -430,22 +432,53 @@ static int vfio_device_open(struct vfio_device *device)
 	return ret;
 }
 
-static void vfio_device_close(struct vfio_device *device)
+static void vfio_device_close(struct vfio_device *device,
+			      struct iommufd_ctx *iommufd)
 {
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
 	if (device->open_count == 1)
-		vfio_device_last_close(device);
+		vfio_device_last_close(device, iommufd);
 	device->open_count--;
 	mutex_unlock(&device->dev_set->lock);
 }
 
+static int vfio_device_group_open(struct vfio_device *device)
+{
+	int ret;
+
+	mutex_lock(&device->group->group_lock);
+	if (!vfio_group_has_iommu(device->group)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/*
+	 * Here we pass the KVM pointer with the group under the lock.  If the
+	 * device driver will use it, it must obtain a reference and release it
+	 * during close_device.
+	 */
+	ret = vfio_device_open(device, device->group->iommufd,
+			       device->group->kvm);
+
+out_unlock:
+	mutex_unlock(&device->group->group_lock);
+	return ret;
+}
+
+void vfio_device_close_group(struct vfio_device *device)
+{
+	mutex_lock(&device->group->group_lock);
+	vfio_device_close(device, device->group->iommufd);
+	mutex_unlock(&device->group->group_lock);
+}
+
 struct file *vfio_device_open_file(struct vfio_device *device)
 {
 	struct file *filep;
 	int ret;
 
-	ret = vfio_device_open(device);
+	ret = vfio_device_group_open(device);
 	if (ret)
 		goto err_out;
 
@@ -474,7 +507,7 @@ struct file *vfio_device_open_file(struct vfio_device *device)
 	return filep;
 
 err_close_device:
-	vfio_device_close(device);
+	vfio_device_group_close(device), device->group->iommufd;
 err_out:
 	return ERR_PTR(ret);
 }
@@ -519,7 +552,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device *device = filep->private_data;
 
-	vfio_device_close(device);
+	vfio_device_close_group(device);
 
 	vfio_device_put_registration(device);
 
