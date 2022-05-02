Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912BD5175D3
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 19:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386668AbiEBRfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 13:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348252AbiEBRfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 13:35:10 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07516268
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 10:31:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rs/g1Y4rIF+Z31aVmUQT5BfBHWH2HUUDUT13iR4fXMnQseV0O9LnhgzAyvoJ2tcmmWCOgmbu8ztzksbnYwl24FL1I7YG0U5C1HHK2u/c1n4+oJEJqq4ipCbbhWujqAgydWPxaWm8ADSLp+BhZHamqrUMhICnUPlt7OWvdaes40pykSewGNFL+yj9eMeT8/xtOM0ykQRjGlQ3Sr1se4PPr7kwk4FOmeaTDCg5mbMzKwrqLVkwt259IGqS+KlokzNU/7zBD7pOxAZzv9gg4nwHRbKLa0U3YBkDx5wYhcJBaaFDKpyfdLcIFk4k+87ccSx/V90AJgYOJWkxrtOS5zoHfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhKOFvPBOr57GR3wpx0tt61S6YsPM0lONuG7hz9QHl0=;
 b=oDkZM+qE3uD/G41gIvhcfRofSs2FyRsXzulDSmWZeYzRBzivfgmjRWV7fK/Vr2jt4aWF0pdVMAJFycJBDD9NjdF+OCuAnqb0wsuCHzMNysTDr81xyNIcMSvc2tIOjl/qvs69n4CgQoQucM76XfQ/BhCHe9uLo2/kyQqMfJWa/zeHhrg6adkiCs/WqUKjQ+vw4y12BN2nEi5v9BeQsOEt4hTyD+f8Oo7JyFfYTVRShkzIkwC2lTAGKIdxX0n9sFNa2dWunRF8LwiRS0uOXlW3bhwjWKqbRnPb6PpbFcTlwiffkwPG7yw39+oL0QWUcwBAncko3pKKnlfpFrqklpQ0Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhKOFvPBOr57GR3wpx0tt61S6YsPM0lONuG7hz9QHl0=;
 b=o48yLoW487gHsGjEUfyxnSD+8/mDy1GTGsdAbFe5NNTibx7fSwAOogprBQFZeR+r93Bnradd7YLFs5p2IzIEDQFfnQeDCg+4IhIv54vusupL/4nE6A+5fK5m+IyrY7OAVBdk1Zg1M2mFzLs28Ty+WLB7ZxPuYcb14I+BQ0ju4H+OdqD6wZYEeGN/O5ejaPPeMLrlHjigIGvgt94clAG97yyMGA2w7v/sfqXzT/h1yY9LQDqHC2rbcKd0YJF4964Xp9bf4RsvVnEGCFGhKOAyR3qlpg3ICpIlUF6FC4Ebpg0iOl6cpGdQO//O1xM/BW6IV/z1P56owhK1hc5O0TqB1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5458.namprd12.prod.outlook.com (2603:10b6:5:35b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 17:31:39 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 17:31:39 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: [PATCH v3 1/7] vfio: Make vfio_(un)register_notifier accept a vfio_device
Date:   Mon,  2 May 2022 14:31:31 -0300
Message-Id: <1-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:207:3d::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bf891b4-730a-49b0-511a-08da2c619cbe
X-MS-TrafficTypeDiagnostic: CO6PR12MB5458:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB545853FA881B198E67EE59FBC2C19@CO6PR12MB5458.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yW3aUvfG/Bb6zCK7htv95z0tYxmKTz4B6sNUL4rd0IcdK3ns2CLt+ppop/0iIpqnOV2ykoTBZTCoHQ7EmXMLyeEWoICm8oprJxtpRYG4wuNG6MLK1aMXT3y3Ej2IDvuKLF/bsTxC+MCS8g51Nh2gPmbts1wxcL4o/o93NaQGMDDDDUUVaXDmV55TF6WpX5iAQBMJXkufnbfZgrXxcDv2O/POSo+DLDtGTsIUcdOluUQLjiVPq1Wa/IIxDsAWH6LNJpQmYZ1Nl5I2c5zFB79+6mibIL8XBdp5DD16IIwd7xvivgmV9T68Uf57kThfW/IGDWB/3f6uZ5ngm8L9qdpNnR5alEvSUIjoM9zQAGNv0wNYbW3aU3kzK0HquVxjdr+ygimp9EvQFRLhNQrmDbNbi1GKxIib0EmVWvRL6AjO/WU4pAAZSBsXm/VT3TlpMcDPDqudQCsQnVPmkEIEUFM7sQt6LflaVCghQbvcVdxHZnuc7uy59T56RfB/6cGl4U28CUlSSz2uXjyNDiSwAcYUe6PgpSt5ktdIPZHqzO/iiBhOvLuvXv8gGP7W34t7cmEd6txJc5PzEygYyrUsfYP3MyZCf3kfg6kxREWMeEshJtIff9JntJHkeXWmD10/9igsS3CrgpnXs6CmKErt5ZrwKudbsmzwhRQMRN/bho8jMkCOqY8LGswLH6xnGC1UI4wdoh7jS8mc3pfOwQrinoFZAIwrxY8lNPX64TxnGrEsPMk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(109986005)(6486002)(508600001)(2616005)(86362001)(6512007)(26005)(6506007)(38100700002)(6666004)(316002)(66476007)(2906002)(66946007)(66556008)(186003)(36756003)(5660300002)(8936002)(54906003)(4326008)(83380400001)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jncrx2KeKtNh0a2E+BJx9IZB7vwxuAkagEW/118DzGgTCrZUS2vZKy1xu1S2?=
 =?us-ascii?Q?mw6I+bmkoxoErAXvN9I4L2PRPz70EJYeDxzKhrYe3ALePcwwdBrtPg4fMyGi?=
 =?us-ascii?Q?qyfAHFQsnRKdVyykTRA8jWFmq+sqTiHNTcU4c+j3RgkK40ZmI3PD8aZ+DBBK?=
 =?us-ascii?Q?Ht1i44IZ+h/2xNA0ZtTww5gYoM6Pnuc6MjLsJ+Q4XGJ/0SmnkD9DANqDQIZy?=
 =?us-ascii?Q?sIDZdSFSTRPkuMVhAy1en/kCd8Ty4JHdyi0b8bHcgQz+hOA9s04o8SZS1252?=
 =?us-ascii?Q?W9+rCtbPDPkKBaDrKe+iS5IXn/K4C3iBnzpLRh1MWb37y32A40QsGuvQiQ32?=
 =?us-ascii?Q?6vsMP89Zxb+RExDHN+dDGBY+0LETRgXSlDnG3uE85Lgu4xsBp+KjXWtrlxLY?=
 =?us-ascii?Q?vfQE1KcgKvEddl4BXRSLV8QvJB7NTITtaiWCFEBY9/gaSS5PhdUKvpMeQBeD?=
 =?us-ascii?Q?VgJOAafUCfrX7p4halIw/3a6iGXHEgKgMYIt5AuxwiilaHwRLmB4jP8buYTj?=
 =?us-ascii?Q?r9pnEPT3BgtjRkxSt6x6E8PCuqUiRQX9gSE89jTxDPd+VdUcx9GgNSeIyhtl?=
 =?us-ascii?Q?CBrTyjY7xtgG2UkrCxPivs/FDGJ6jwuiu63Uit19w5axsfKt1B7Ppr0jqeSO?=
 =?us-ascii?Q?n8nfZ5OCnMrEDKxSsrjlUSrqrCqesFq67b6etDwSnKWl4ZuFIUJerKZkw0Fj?=
 =?us-ascii?Q?An15Xd8HS6ftJAX4bzi6jFq41GxPIzPML7ciq1Ahz2kk1V0Nz0jBsWh/+AkH?=
 =?us-ascii?Q?fUXy/gc0I83b8amHCwYwAEhdlIwLleHGcXX7HtD1nkQ/kuuEVN+dTYuJ7mKL?=
 =?us-ascii?Q?zYXF/zzNwp/NqBIB6jPIJaheEINaJPlbQalh/d+ylXSJrhEwpXTLENZsr+c/?=
 =?us-ascii?Q?ijk08nZmHyRN/WafbT83ejzC0bn3wZjHrXfdamXC/VZX3Q5hNMezhnRyF+FQ?=
 =?us-ascii?Q?6Hzlo0DOjYDkKwqQtB3Mq1z9mNOJO9tSXX4+bVS7LPOs3klWuYJkaX6wqSPH?=
 =?us-ascii?Q?yH8/IeN1CFVV5awj56/uDh44eYX/WdBeC4wpnpuLZkyIfP4mymO2lcph9iAJ?=
 =?us-ascii?Q?wNRhjBcZD7nfhnd83M91CagQTkrQCN7hNfTkWo2Ys9FbWyj/hvVgNW/F2oTk?=
 =?us-ascii?Q?DIyY3NOR5e7G7wQcJf1rxxZSVKtbQTDcgMnKtzBwZlEauJmpFl/g0AdlMl8h?=
 =?us-ascii?Q?XaXJUTHze8jVtafJqvc3POm8p2FD4ZBht9RedZtd5Z62tDeIBD9flTcUHn57?=
 =?us-ascii?Q?rr9+NDUhdwP3xOPMyV1OaezeaKqHymfTpvcNkpVnGFnV9xgxlitBFVp7vBeK?=
 =?us-ascii?Q?EGdh/bEzYA6QHTOGjSn+H9MSzFw9l1YBVo+9Y/eWKJLeYDjeF0ZFK2/GDEYD?=
 =?us-ascii?Q?qkeEu8/EVysae9a/eS2AaibXoZsc8VCCvNQh/XybGG6kc45iGjcG3XZY2gBt?=
 =?us-ascii?Q?5xkbp8PZSgOv+i3iaTdBl5BoMAvhDfvdUWUMgG2U+kjZZJs2B7cvInra31ow?=
 =?us-ascii?Q?idNFvaOY4M1Fy5o0aDuufRxpM9hX6fRQfdTN5FTG6JwwViyX5BFZEZotwz8n?=
 =?us-ascii?Q?KCbFHSocM6tXmDKeJCrDxDs8+Il/lIZBEMdFvvWvbeh8rXu7VPpejIgymwh0?=
 =?us-ascii?Q?yBi1v5K+4hqBu3STC06uWvpOhRrWnAl+MuJaQTy7ZLOssS5To65c2qEwGZKs?=
 =?us-ascii?Q?jCqwTo6lqDZoWR7H91v7hUMYk2KvYHqlAqPqua/DoLj8NymurUYzsgldJK+C?=
 =?us-ascii?Q?KgCvafTfzw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf891b4-730a-49b0-511a-08da2c619cbe
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 17:31:38.1389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fLEUGzveikM3Slp/20IGtkMQW3okJzHyIZvkm/htZ2IjdNptGplF9UtHwLIK3bjg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5458
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All callers have a struct vfio_device trivially available, pass it in
directly and avoid calling the expensive vfio_group_get_from_dev().

Acked-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c  | 24 ++++++++++++------------
 drivers/s390/cio/vfio_ccw_ops.c   |  7 +++----
 drivers/s390/crypto/vfio_ap_ops.c | 14 +++++++-------
 drivers/vfio/vfio.c               | 25 +++++++------------------
 include/linux/vfio.h              |  4 ++--
 5 files changed, 31 insertions(+), 43 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 0787ba5c301f5e..1cec4f1fdfaced 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -810,8 +810,8 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 	vgpu->group_notifier.notifier_call = intel_vgpu_group_notifier;
 
 	events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
-	ret = vfio_register_notifier(vfio_dev->dev, VFIO_IOMMU_NOTIFY, &events,
-				&vgpu->iommu_notifier);
+	ret = vfio_register_notifier(vfio_dev, VFIO_IOMMU_NOTIFY, &events,
+				     &vgpu->iommu_notifier);
 	if (ret != 0) {
 		gvt_vgpu_err("vfio_register_notifier for iommu failed: %d\n",
 			ret);
@@ -819,8 +819,8 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 	}
 
 	events = VFIO_GROUP_NOTIFY_SET_KVM;
-	ret = vfio_register_notifier(vfio_dev->dev, VFIO_GROUP_NOTIFY, &events,
-				&vgpu->group_notifier);
+	ret = vfio_register_notifier(vfio_dev, VFIO_GROUP_NOTIFY, &events,
+				     &vgpu->group_notifier);
 	if (ret != 0) {
 		gvt_vgpu_err("vfio_register_notifier for group failed: %d\n",
 			ret);
@@ -873,12 +873,12 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 	vgpu->vfio_group = NULL;
 
 undo_register:
-	vfio_unregister_notifier(vfio_dev->dev, VFIO_GROUP_NOTIFY,
-					&vgpu->group_notifier);
+	vfio_unregister_notifier(vfio_dev, VFIO_GROUP_NOTIFY,
+				 &vgpu->group_notifier);
 
 undo_iommu:
-	vfio_unregister_notifier(vfio_dev->dev, VFIO_IOMMU_NOTIFY,
-					&vgpu->iommu_notifier);
+	vfio_unregister_notifier(vfio_dev, VFIO_IOMMU_NOTIFY,
+				 &vgpu->iommu_notifier);
 out:
 	return ret;
 }
@@ -907,13 +907,13 @@ static void __intel_vgpu_release(struct intel_vgpu *vgpu)
 
 	intel_gvt_release_vgpu(vgpu);
 
-	ret = vfio_unregister_notifier(vgpu->vfio_device.dev, VFIO_IOMMU_NOTIFY,
-					&vgpu->iommu_notifier);
+	ret = vfio_unregister_notifier(&vgpu->vfio_device, VFIO_IOMMU_NOTIFY,
+				       &vgpu->iommu_notifier);
 	drm_WARN(&i915->drm, ret,
 		 "vfio_unregister_notifier for iommu failed: %d\n", ret);
 
-	ret = vfio_unregister_notifier(vgpu->vfio_device.dev, VFIO_GROUP_NOTIFY,
-					&vgpu->group_notifier);
+	ret = vfio_unregister_notifier(&vgpu->vfio_device, VFIO_GROUP_NOTIFY,
+				       &vgpu->group_notifier);
 	drm_WARN(&i915->drm, ret,
 		 "vfio_unregister_notifier for group failed: %d\n", ret);
 
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index c4d60cdbf247bf..b49e2e9db2dc6f 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -183,7 +183,7 @@ static int vfio_ccw_mdev_open_device(struct vfio_device *vdev)
 
 	private->nb.notifier_call = vfio_ccw_mdev_notifier;
 
-	ret = vfio_register_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
+	ret = vfio_register_notifier(vdev, VFIO_IOMMU_NOTIFY,
 				     &events, &private->nb);
 	if (ret)
 		return ret;
@@ -204,8 +204,7 @@ static int vfio_ccw_mdev_open_device(struct vfio_device *vdev)
 
 out_unregister:
 	vfio_ccw_unregister_dev_regions(private);
-	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
-				 &private->nb);
+	vfio_unregister_notifier(vdev, VFIO_IOMMU_NOTIFY, &private->nb);
 	return ret;
 }
 
@@ -223,7 +222,7 @@ static void vfio_ccw_mdev_close_device(struct vfio_device *vdev)
 
 	cp_free(&private->cp);
 	vfio_ccw_unregister_dev_regions(private);
-	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY, &private->nb);
+	vfio_unregister_notifier(vdev, VFIO_IOMMU_NOTIFY, &private->nb);
 }
 
 static ssize_t vfio_ccw_mdev_read_io_region(struct vfio_ccw_private *private,
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index ee0a3bf8f476ca..bfa7ee6ef532d9 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1406,21 +1406,21 @@ static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
 	matrix_mdev->group_notifier.notifier_call = vfio_ap_mdev_group_notifier;
 	events = VFIO_GROUP_NOTIFY_SET_KVM;
 
-	ret = vfio_register_notifier(vdev->dev, VFIO_GROUP_NOTIFY,
-				     &events, &matrix_mdev->group_notifier);
+	ret = vfio_register_notifier(vdev, VFIO_GROUP_NOTIFY, &events,
+				     &matrix_mdev->group_notifier);
 	if (ret)
 		return ret;
 
 	matrix_mdev->iommu_notifier.notifier_call = vfio_ap_mdev_iommu_notifier;
 	events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
-	ret = vfio_register_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
-				     &events, &matrix_mdev->iommu_notifier);
+	ret = vfio_register_notifier(vdev, VFIO_IOMMU_NOTIFY, &events,
+				     &matrix_mdev->iommu_notifier);
 	if (ret)
 		goto out_unregister_group;
 	return 0;
 
 out_unregister_group:
-	vfio_unregister_notifier(vdev->dev, VFIO_GROUP_NOTIFY,
+	vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
 				 &matrix_mdev->group_notifier);
 	return ret;
 }
@@ -1430,9 +1430,9 @@ static void vfio_ap_mdev_close_device(struct vfio_device *vdev)
 	struct ap_matrix_mdev *matrix_mdev =
 		container_of(vdev, struct ap_matrix_mdev, vdev);
 
-	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
+	vfio_unregister_notifier(vdev, VFIO_IOMMU_NOTIFY,
 				 &matrix_mdev->iommu_notifier);
-	vfio_unregister_notifier(vdev->dev, VFIO_GROUP_NOTIFY,
+	vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
 				 &matrix_mdev->group_notifier);
 	vfio_ap_mdev_unset_kvm(matrix_mdev);
 }
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 0c766384cee0f8..13494c1e497405 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2269,19 +2269,15 @@ static int vfio_unregister_group_notifier(struct vfio_group *group,
 	return ret;
 }
 
-int vfio_register_notifier(struct device *dev, enum vfio_notify_type type,
+int vfio_register_notifier(struct vfio_device *dev, enum vfio_notify_type type,
 			   unsigned long *events, struct notifier_block *nb)
 {
-	struct vfio_group *group;
+	struct vfio_group *group = dev->group;
 	int ret;
 
-	if (!dev || !nb || !events || (*events == 0))
+	if (!nb || !events || (*events == 0))
 		return -EINVAL;
 
-	group = vfio_group_get_from_dev(dev);
-	if (!group)
-		return -ENODEV;
-
 	switch (type) {
 	case VFIO_IOMMU_NOTIFY:
 		ret = vfio_register_iommu_notifier(group, events, nb);
@@ -2292,25 +2288,20 @@ int vfio_register_notifier(struct device *dev, enum vfio_notify_type type,
 	default:
 		ret = -EINVAL;
 	}
-
-	vfio_group_put(group);
 	return ret;
 }
 EXPORT_SYMBOL(vfio_register_notifier);
 
-int vfio_unregister_notifier(struct device *dev, enum vfio_notify_type type,
+int vfio_unregister_notifier(struct vfio_device *dev,
+			     enum vfio_notify_type type,
 			     struct notifier_block *nb)
 {
-	struct vfio_group *group;
+	struct vfio_group *group = dev->group;
 	int ret;
 
-	if (!dev || !nb)
+	if (!nb)
 		return -EINVAL;
 
-	group = vfio_group_get_from_dev(dev);
-	if (!group)
-		return -ENODEV;
-
 	switch (type) {
 	case VFIO_IOMMU_NOTIFY:
 		ret = vfio_unregister_iommu_notifier(group, nb);
@@ -2321,8 +2312,6 @@ int vfio_unregister_notifier(struct device *dev, enum vfio_notify_type type,
 	default:
 		ret = -EINVAL;
 	}
-
-	vfio_group_put(group);
 	return ret;
 }
 EXPORT_SYMBOL(vfio_unregister_notifier);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 66dda06ec42d1b..748ec0e0293aea 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -178,11 +178,11 @@ enum vfio_notify_type {
 /* events for VFIO_GROUP_NOTIFY */
 #define VFIO_GROUP_NOTIFY_SET_KVM	BIT(0)
 
-extern int vfio_register_notifier(struct device *dev,
+extern int vfio_register_notifier(struct vfio_device *dev,
 				  enum vfio_notify_type type,
 				  unsigned long *required_events,
 				  struct notifier_block *nb);
-extern int vfio_unregister_notifier(struct device *dev,
+extern int vfio_unregister_notifier(struct vfio_device *dev,
 				    enum vfio_notify_type type,
 				    struct notifier_block *nb);
 
-- 
2.36.0

