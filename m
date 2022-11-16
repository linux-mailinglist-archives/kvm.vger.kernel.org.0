Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6564C62CC45
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239175AbiKPVHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbiKPVGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:06:39 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BA0429A5
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:05:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mz+G/mgePChaGH+M7MBOwQYP5MCTheX55lxE/fnLCvI3ZOfazaIKgkRdiM3LTO8SGWSb5+BYHQiIHlzPuxneWkkyhvcgUlzjXt5ibZscnYzxJOpLJA9P4iudejwMCs9lYHyFzTgYaxn5vS2pCM63cPQj838o8ytxGWzmXzMN4Ixf2+OuMkA8/5bKTS3TDYFKRdqWjOx2e5t/Sb3ioa22OFEOy3MVabI1z1xWHaSizwzbD/4+Nzdaf2L03I82SmYWNd3Ei1JaS0S+YtTVt2OA0R5/VYVc+RuTZVsHsdWHKylEJcWx+xO44fiJBUaDE7evFDU56WyNOQHDMjn2iil+qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d6ixHOb2uTNaEtQnsc97Dw0pUYU7ZkSmj7l0+M3vawo=;
 b=UMLxB9G90VHChUkOe5irBGMD9YPdiiX7/OLGzbow233kotQVI2Rffz0zvsX1r7haZUkAIeCW9R4KizcySkNHNyS+1i9jEyFEJ3v1xbgQLIFuKCBO51ErpHcLdgU8dCCRpzXKtiVLwWo2uFIIXhnUsNUiG46/5X2Q2hM9j7mjhOOaruihsUiNCf922k5OjuQbE2OJTH/7qmWJZ12XKRO2B/n4p9ss7/ZoEynrbXBJ4+mn4xy6YkPbVSRNA2VpFiJBq5hwYUq9ZUJxxTdGKvhWgaC4nPAJY5HzNv7nTBICApMiregpdkDWIZhe+k4Mqfgi/3nhOwb9qnRZIPhgxce96Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6ixHOb2uTNaEtQnsc97Dw0pUYU7ZkSmj7l0+M3vawo=;
 b=p7ELBWeL5Fa6asPNZcPJlQXQR6jgsgRsY+Qw/6CKzcrMyDTIw9h3/x2qTGXoytUokGiVIoWjR4KDCkDkuq5OjXLXQ4jTmepPr9b5fZVf/zwX02pjzGAj4bILa4r1xukrjeJXHWpJ0w/eZbGOc8fNpDH6ibctEkRZ5HG1ftXg8KPY9hl+aPY+aoeEQ0v0Y1+xjclNu4q6k1fBYTVUQ9iefm+kBVHbcuipBbQRG44KAGxSgujZfmxS23+ybAa6mwIvu8wUP8HWz3jshMx+fGRxo36rzM/6IKl1hs1UO1izroIzcc1meWJlpKZvaSqrg3JCZOqfFBC6Gj8AfAdNNhMGFA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 21:05:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 21:05:37 +0000
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
Subject: [PATCH v3 05/11] vfio: Use IOMMU_CAP_ENFORCE_CACHE_COHERENCY for vfio_file_enforced_coherent()
Date:   Wed, 16 Nov 2022 17:05:30 -0400
Message-Id: <5-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0011.namprd20.prod.outlook.com
 (2603:10b6:208:e8::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: b049ba2f-34eb-4712-91ce-08dac8164fa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sg6eV0ScYIfuUqsYcpAyZc3aoCu320qDtKLISkDs7MKL+tyFC3V5ki9p8rEAD2h/6sc58gecbql3is6cCYW902V46z4tgkzX9yDEd92gu1TMGN6E5m/R83WO156dYL8zK55HQ3rAOlgIMhCByomm2Mk55S6m3GzyQTuOL3gEqNBAq935U0Ee3l0FzfI6YTrSej518QYsxerW3sjTf5ZctUlNeI4BLgbyt4987qZuGqZeuC6BR0uvBxshzhOxu4UyecPvwsASRWORuS9KbsniDThNPjm0cXwslOEZmQ//hxHaI4CM7e789baOeWpfXcWUrD4KNnRwdUvNVD/NNk0/W6eTGqKELMpaXiQq+FuGl+gEWQjyJElBjLixuwNrH878x3fekR7tVZAOEU3HfZrdc7voppSqjQJk53sMRuBNdgUegPSNUD2eRTo4jzRg2BCsmeUFOJiYOYzUBfeU9PudY5UqdEu4zE5+5hdVBCgNuewcnaRFBuWHx6FkI0Gs32Byfja8S7+poXj/lsEMD0rVyXouWFSgACR7LukCGzfqm60PJIJDfAPOa25UzB7Xe6MYAmn4LUulzak4QAErly4d+U3uxJIuUZKLJZmyOcK2EqxL6rBLWle8q1pFopo+m1aadRunmkgpfwgW83H2tQY7UMfY+VmfF4bzCIwTmp2QtiZ5jxg2XOisVoHg49Fj3Z1c4z7CZG3dqca8xZYMUrS1ZfHV6ijbpSov85zrfW1GNxlHeTlSkVUzlKr6Qr59tweDnwC4p/tj24g3Qka7yaEoGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(109986013)(86362001)(36756003)(38100700002)(54906003)(316002)(6506007)(6486002)(478600001)(2906002)(5660300002)(7416002)(186003)(2616005)(6666004)(8936002)(66556008)(4326008)(66476007)(66946007)(83380400001)(6512007)(41300700001)(26005)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oRywdY65QZn05/vItvA0riLq7JqVQrXD3XzwTMA3uFODGykdfMjyLQhPdQBW?=
 =?us-ascii?Q?MBHQHcfG2XGM2I5zA39VcvpXZ8snw8jSA1Xtg6DI9rBskgHREf77GYd3FxJC?=
 =?us-ascii?Q?WqxVRTpRxd7EpmM2Dds0+nnn+vCEr+T2YwTL5c8jrblF5shng0qn+MdcQro4?=
 =?us-ascii?Q?AxRPk9cHlQk2sg8gEeLDJ5YZj3V+6+l5InC3NzSEJlZBRu6Xhb8SzvVCkJJJ?=
 =?us-ascii?Q?YRqYAQbUzANQgl6eZO56V0n0vn0GafLJzX7zMAeOrUWZhJD8YKZ2ZnNOdX5B?=
 =?us-ascii?Q?RF3X39FxZNJPQz9sBWBw3b88m35nD7d8rd80XuCb7g0dLHy6s/oGmxSPUdGR?=
 =?us-ascii?Q?AEMxZHHmIOdDRSYI1y0Jo5k3pzn4eIlAjptzumxIJyyGx/eGQ7aR8dOX49PB?=
 =?us-ascii?Q?nAMUXaSopntq0wtodQaB0fGcPtxlUBdKyj23cFc/oPaYWuBqrNocSI2URWWf?=
 =?us-ascii?Q?xXAHUDR7XZqgGLvvbt4+Q+kgoMTY5o7l3vmNwKlIpK2M4k7lf/vPwtdRTTkR?=
 =?us-ascii?Q?Zw/qVOl7VwVQ+cZ1FThg29w/sSQTdWP2ALXEXxryw0EIynq6h/8RD2E8XPR4?=
 =?us-ascii?Q?ApyhW0juxFQcAczL9DnlKFLW5WDvIf60VC8x5nxagz2bhRCdLsMrdkSmA/if?=
 =?us-ascii?Q?I0o5h3CW7QeafV2vlqxT74qQ+9//OX+yGZhz03P05gmX2Wc/60IkiEcQkfqZ?=
 =?us-ascii?Q?8ZNerUlbtGLiP5pXYukLYekJ8xqVmf956OcmFy5xdpucIRn6VS34F+ueTqYr?=
 =?us-ascii?Q?SNX231K4JN2mooeOSJxLYlr0uDNExxXWIBM/p2UpGJFFdyzVRhiQhdDW2wfX?=
 =?us-ascii?Q?FEdqyXqmIQ6LKjHE57EjjQyAPHQV1zoFlFRJOy3vE2lsOahj3srHZblBznCS?=
 =?us-ascii?Q?4cKyWsi4H3qtJQYvtp+1jzI6Zl/E4UEw5t++1XFBxk9zkKTWppsVKOdMKcMh?=
 =?us-ascii?Q?5z/M5tyq/mPz4Q5/cVF8qOKhfdYT2gYmgkby0mLR/IC4dc7G7LEhhVodKUOu?=
 =?us-ascii?Q?s804g7IAXGk9O5Vs5fBTwEn9u3/ljr+3dM73XD/BevGvtjXiiuLbSwlta/wx?=
 =?us-ascii?Q?hiO/DC9i+JgA9QFNlhrnGlufdyFbvUOUWNgjd6jrU5thBgog7x9HC0pXZl8V?=
 =?us-ascii?Q?8xRzwowU6akuaeJPpHgnI7xy7jjFviiU7QmIR2Jq3e/iEPJP2ugOtK8MmWEu?=
 =?us-ascii?Q?zkh/E6iPMlNXJqBuP9+bGV1bxqDAw6NSeZQ8ey2N5kjPdRBrjT/w4GMSkhLk?=
 =?us-ascii?Q?5zQnt3ZxLuq8QAbDzuIEKxJ1ppAAxH8T7vbw68UBEM5yiTziibSPMtrAaqEN?=
 =?us-ascii?Q?zi7WmMfO9uGGvEHtiODQAv1UILhQE28tCKLGEGSzpfgQxyMF/gh+iSDd4jba?=
 =?us-ascii?Q?fhDP46HmSKp0neMwwRI7TM5B4zVHt1HrZB4bnAxrAdGv9IDdct8cRD9sG+p9?=
 =?us-ascii?Q?PHWLMOSX9DqphMWLKrsw5vlGeaYRoWP5X41w5I9jjLj7l59zQS73ZqxGN8Of?=
 =?us-ascii?Q?kKbBb1OAZ7iwoHdPeGokUFiAQjDyeuA4DZCTl/Cs3l3ZQOfBmAd2Ko9Wh1G8?=
 =?us-ascii?Q?1io4dcSs1GiAMxN/XK8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b049ba2f-34eb-4712-91ce-08dac8164fa0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:05:37.8680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tQBGioPVHNPH+mT0PNJJ1r0acyQBi/o8PStyJUOc9Uo9Qyi+yXQMiBHsdNH489HK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609
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
index 54e5a8e0834ccb..247590334e14b0 100644
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
index e1fec1db6a3c93..5c0e810f8b4d08 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1625,24 +1625,27 @@ EXPORT_SYMBOL_GPL(vfio_file_is_group);
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

