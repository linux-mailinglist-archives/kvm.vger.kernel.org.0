Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092C35A731C
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 03:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiHaBCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 21:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiHaBCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 21:02:10 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752F76EF18
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 18:02:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fW6DS1Cpz13Yzh1kAWfpTS/7F2Qw4XiL9sEkAjmsXOJE1YFr8wmp/WiSRLhUQT74ciGoTmlTHSirkJ0mDoVYi84ocO5IaKqwHKBAda2t3yH+zRyQ6PHqQYvBYm+tsX+h6McSYIoh34RnHdGy7WdfAM6y6cAD4wFlFxW/nzB7sFnTpActtQDFS69smEVqf5xGJ/rkfEScmCWouqDPL3MliIaAB0zCEOb5Z9siDFV/C3n2WPdXuFd7AHldaaSfGIJLkFLNEjiBJfWxhww2N/PaZG8iN8gzcAD+KKjvAtOn9wIe5AqtIFTCKRAewoLSyRnPU7RcbDSOh2+QilkR4zttAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roAiH3vcc7Gp7wrZ9iZT9Pg7/grKIV11j84F7mgJ90w=;
 b=bKNnVzB71wAmCxPj3CCDVtmkK5Azmv03KYRAVrbArhN9krFmhltN+UYzGHVT3GFia9aW8sH+45S2DIFaIRYAx5eluWorkKUG1nHntLiIAiqBrzigUq7ceBkVjN4rCwraPH3gj7ECqjzASCtpSlmSOcZ3YFaNwwQA6n62rzEE9idsP+cgU5B4+kkzPrupIRii9xMogM9jmcysf7NwisVsH8xUgDIzfeEYdyJZFlePgkr5eV8vbJoQSKAobQfjp8Qan7YZIns4pkPw8hk3oGi5YuqmNYoHtLwiEa9d2oqeg6OP2VC1d79oOKQuzQo/XT00tzgEMo0RLAta/8t2+m+RjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roAiH3vcc7Gp7wrZ9iZT9Pg7/grKIV11j84F7mgJ90w=;
 b=HKZRqUFyWGSxA0LN8LJjDyaVV1lIolWwt2/b2UynY8KtPe3NmEXiiYkJbdbLHeOmjD3oxG3hrFFFIYZMUbEA0Yc2qtcemcmIj4LFlu0h8S2/ZDma+aZIXAUIyt318PoMkYPjHEXH6wpTxQ3oBoLG7O7xM3VIKZez8gFtBAFIeFI+zYLDHy0hzbb/LFR0WMFrup4e95RcNZJU5U3y1tDzMnlHDzvU8SGVMzT27XIF8w6mnLQuIn4RL/8lK2o+sgClcqlo9caK25Cpfk7II4aBl0hRNtKWWrlZ97dVU0kNKjZItTqY8H3e9JApV6c0QYpCat6FXqqlaPCBpHXnf7SsUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5410.namprd12.prod.outlook.com (2603:10b6:5:35b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 31 Aug
 2022 01:02:06 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 01:02:06 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: [PATCH 7/8] vfio: Split the register_device ops call into functions
Date:   Tue, 30 Aug 2022 22:02:01 -0300
Message-Id: <7-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0307.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f45c2f0-49b2-4368-8cce-08da8aec6ae8
X-MS-TrafficTypeDiagnostic: CO6PR12MB5410:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DyNbIbqORQKEQQZr1x/2VnBHXBv38P7/kwsJ1eUpkofKmaZTS9XxmgtnrbR7d++PB3whWw3CR9it2W56zYTlVLGfiOgyapXL0d0URQRDrUrZMYMzRgK+KVrg8RImXOaspvsOFCMmp+QNkgIbT9hDamC5Tv6CgBIvD30D7MEcrh6tbQI2TaMp2zGHXSgjlQ3h8a4ZDuMN5/iQXDeqXdfHrRThYXSmSUEepnZAPfGaTg/WXiSroEIH6J4yBdUmwjIHyecZNWYM5fgdsuFp1l3pKqdieWg2izRlMyFlrRvngfbKQ3jXC5zrzFhQ1vsLAmnjNTeVwoo8y2aCvdxj4SYa7Y0Dui8jiiwb/AyHFzdvvwzd3IqBWGNnop+77z+nV5lO16dWhi80Tdty5/RD8/CuQ8a6eRLEeGLWBcFIbexXknHDh5Ep2b5fqYNLdTcNdvxkrv8oqXJfHsgY1IDuhShov/bAYYchRMo54KUq4h8Rb9dPjSiNCss1lAK37XDsyn49LYVJ88Elx4pnfFCbRbkvEAkvAzKVCwrpv3ne7vlAcwLAkMJwMw6SbD74D4+sIJ3ZfGroxEXGBDejF3QP+j0C2saDuTfvdqQrHuAIsgVi5dFqyyfDOAOzPZU91auAXwEuY5SmNhaI2U2MoNwppcCcAnXlhp6ywdSI2DDRTb093jqgnFSMV0F/TjZ0gZQB1bZFZpBhR5ma8WaVis22j8iyuUcmbX5P7yOo37bCcSeBWG1NAQQbFVdBtefijEgmbxU0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(6486002)(316002)(110136005)(66556008)(66476007)(66946007)(8676002)(86362001)(36756003)(5660300002)(8936002)(478600001)(41300700001)(26005)(2616005)(6506007)(2906002)(6512007)(6666004)(38100700002)(83380400001)(186003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cACxFbcdd5ctFD7yojoAfaQDW65cx08vfa3aGSpT2czN1tL5yGnoPtGZslT6?=
 =?us-ascii?Q?17LOcM3xSMftnhI5XvDlV1hJCkx18Be/ReC+f0Ji7JR5Dq0Q6wYn4aunayMd?=
 =?us-ascii?Q?+5H4TZUs14/C1HWMfHvIazHKjHz766qRGjsh8oer3gK8w3e2L5mRW/IjgjM8?=
 =?us-ascii?Q?LwNmwiPPWkOU3DXw1Q6sLXzcJSyFpFCBcV3U8v/vhXbZTRrvnWPGd+RP6ts5?=
 =?us-ascii?Q?QsR2vP0x/SHyGVDuLYDkzwquYMLQyN3xa95TVeGlcdFGLh8qZtSCpmLdfwgr?=
 =?us-ascii?Q?J1xFt1wC7cIsHckABOHVMHztzKQD71QR+5M53AK+t+CgRwES3Y1NYi6rnrfT?=
 =?us-ascii?Q?piuRD/EeW1Vvudlj5BrbaAGnuG5Gt9jmOg/OCQoGhE0p+02ik6FCWXyUtvEp?=
 =?us-ascii?Q?KIt3cM7pv0ES8cFqY+I89+MjRlPpgSwhEwt13YO4gI+nzu9JgYGvVicJW995?=
 =?us-ascii?Q?VI4jqe+Ta9oTAfAyiv7hi6XG74/vFkFiv3uHKoJaZIjP0GNX4Jb7Hyre+2EC?=
 =?us-ascii?Q?fPMDcIUI6zM694dG4KV9XS7NNYDdEMGeEb5OA431weXbZ/95CcUTwL3XQQWu?=
 =?us-ascii?Q?lFAJg+nwGV1Sruy7XrTuk/U7MJQHiqLVAUZrxM8wXHBdLHLHJJio8TdkZeOb?=
 =?us-ascii?Q?yu+fTSrDzK+iFhnArvGwKz/UK4s0skDdAZZCOUN8I1dNuwhNmoYnc0npaNag?=
 =?us-ascii?Q?uAvCre7DCMX+iXAIC7thEsS1xJk96XLXtiMSSrdz2T7pPY0Vu54iaoBuprCH?=
 =?us-ascii?Q?eFun3W1msWJ1ZTI120RxwVdYcv69x+rEZCV7RAkWXUpZE4Wh+CR/V3BBfA+z?=
 =?us-ascii?Q?ziJIlMDFFqKnXcRfS5GDv27aXy0CLPGuJehE1IN/J3iY/f4YzFBy3iw4tyOW?=
 =?us-ascii?Q?BO+Kt9yJoGY9WH6JO2s7q0hwoUCQ90NMhqLRrp9CyYBSTdeEY7H1pkkUwYc3?=
 =?us-ascii?Q?HvRjSup3LLE6S+dwFXqTKQPnoa1Tu6wC5VahG4QthBqnvn5rMbIHmrvAByYn?=
 =?us-ascii?Q?0lu5aa24TkKgpXcFTdHJSAR+kqaAKvoH/7V7aFru0lJcT7y2Ng3rQxw+CDaI?=
 =?us-ascii?Q?/qdJM5yCYs2yZ4geDATNVwUrXdfkGN9iOuKJMF9lgBTqr9BIfCd08cOj9djP?=
 =?us-ascii?Q?sQKXf6bmIUYrQz2kl7k7MidKpHpPqURBDadAKbiV5HW7e89qWIxtzKQ5C79u?=
 =?us-ascii?Q?6rTwt8tY2Vm3/BBPxMw7eZsua++ZXdXl+pN44hOQ47muYePR4Y1WJtHtzoaq?=
 =?us-ascii?Q?7nvPjY6C7MXijK0h7yTHmGByNNCjwyQECDXhmZB9EyjamO8+l80UTbPz0r2Q?=
 =?us-ascii?Q?+Cv0xjABimd68WesPVizsSlnLDTu4wu4wV2DLg2jYT2ra6swnmnTQbAcjAYs?=
 =?us-ascii?Q?9711DrKZ/KksYpPmrfn4bBQsKf2HzX9EJBuI7q7EU83CMuK92Dx2/OOaH54q?=
 =?us-ascii?Q?mzJcHwmrQKUbPGsc8vE84d9zTRztGeIaV6VkhPQ4oOKaNieDNsK062dUDFIC?=
 =?us-ascii?Q?aKYXfDHC8fFnU1K3BPx4j2030/pru3Tamn7SbMtnKa/+OA64pzoqsvjADdDu?=
 =?us-ascii?Q?6x9zFRWjPyv9O6DBUCAKLHvmEpUNFyW4zFvQMSNA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f45c2f0-49b2-4368-8cce-08da8aec6ae8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 01:02:03.7824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PiPtIHILOxlDlrPTBHts2yxrIZF6p1m54asDUNpzdL9eLgbdz69jM7GQIUjB0i8j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5410
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a container item.

A following patch will move the vfio_container functions to their own .c
file.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index e1a424d243351a..cf4b5418f497a9 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1110,9 +1110,28 @@ static void vfio_device_unassign_container(struct vfio_device *device)
 	up_write(&device->group->group_rwsem);
 }
 
+static void vfio_container_register_device(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->register_device)
+		iommu_driver->ops->register_device(
+			device->group->container->iommu_data, device);
+}
+
+static void vfio_container_unregister_device(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->unregister_device)
+		iommu_driver->ops->unregister_device(
+			device->group->container->iommu_data, device);
+}
+
 static struct file *vfio_device_open(struct vfio_device *device)
 {
-	struct vfio_iommu_driver *iommu_driver;
 	struct file *filep;
 	int ret;
 
@@ -1143,12 +1162,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 			if (ret)
 				goto err_undo_count;
 		}
-
-		iommu_driver = device->group->container->iommu_driver;
-		if (iommu_driver && iommu_driver->ops->register_device)
-			iommu_driver->ops->register_device(
-				device->group->container->iommu_data, device);
-
+		vfio_container_register_device(device);
 		up_read(&device->group->group_rwsem);
 	}
 	mutex_unlock(&device->dev_set->lock);
@@ -1186,10 +1200,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	if (device->open_count == 1 && device->ops->close_device) {
 		device->ops->close_device(device);
 
-		iommu_driver = device->group->container->iommu_driver;
-		if (iommu_driver && iommu_driver->ops->unregister_device)
-			iommu_driver->ops->unregister_device(
-				device->group->container->iommu_data, device);
+		vfio_container_unregister_device(device);
 	}
 err_undo_count:
 	up_read(&device->group->group_rwsem);
@@ -1368,7 +1379,6 @@ static const struct file_operations vfio_group_fops = {
 static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device *device = filep->private_data;
-	struct vfio_iommu_driver *iommu_driver;
 
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
@@ -1376,10 +1386,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	if (device->open_count == 1 && device->ops->close_device)
 		device->ops->close_device(device);
 
-	iommu_driver = device->group->container->iommu_driver;
-	if (iommu_driver && iommu_driver->ops->unregister_device)
-		iommu_driver->ops->unregister_device(
-			device->group->container->iommu_data, device);
+	vfio_container_unregister_device(device);
 	up_read(&device->group->group_rwsem);
 	device->open_count--;
 	if (device->open_count == 0)
-- 
2.37.2

