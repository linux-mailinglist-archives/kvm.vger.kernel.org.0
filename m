Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DD15175D6
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 19:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386672AbiEBRfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 13:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352196AbiEBRfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 13:35:12 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEEB2AE0
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 10:31:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L91XIhmYw9r5ivX0nZgsIyzgHS9KB9tEhNIr196yJxJ/elFgRylD05cOfIlGsOHkLCerpwxHYo/QhJP73eiebShj9gz0lYYCOrM37+NNo85Ydqq6W2un5WiV90hH5O9SK8qEIr/nuAftAPY0/cb+rwb1qKKGDmPWHz4MdE9czE5crT98NTxfIWrhF0dNS5jX1Z1AB0P/j8JrQsj3sGCX7Bo3yrS8t7O/fKT+BsS+ZDAHGofyPoPBMallN7xcp1/f3Kbxz7o+606/YsO45QF+NMOb226TURgcL+DkCtkWOeKD0RKRJ3ACdQSZrQ5gPIeTUI07fSzybqqHmoK7y/MKpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rX3j7rOWSWO7c4hbUYMNBvD/GJno+vvgfbHyrqgd16w=;
 b=mt5N5Ec4lfk9ZtaAGm9hp8Oab+k6RzvvhmCs/DGoxt1E8J6XjaGyx/7XYwugzE2TWKi4PofW8DFXGfd8lBsg/DNrINwOqnMRUEoMtF5UVvHEyOGyTHrFZkv4z55b4UaQFHnUu5HZMzy426kw1/RRN2zZxL6uaQ/sQ5rh1gGDc1an2wCKWsn0Qk+Mh4iemYJXzRxSzBdmjsZb4+zkom04lrFGuDsuS/trGAMoB9R+j4+8bKwuopU3hcbZyladmigGvdFlFc+EA/cEeli3FGNKZ+L65Dj/0pzS3oW1TVxyTlOrkYpcCja0nbOL+Kt9FFYI3EdCPFDBboTMwutsZbsEtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rX3j7rOWSWO7c4hbUYMNBvD/GJno+vvgfbHyrqgd16w=;
 b=ldzaEqzjrzNsqSp0FUvd1umzAxWOtAToOfJu1G4QVsgCJXWCD2Mwg0esQ7fKuQdLRr1GMQTF2Ixv0Ysj0rCOjEKIjwlUkKdM+nOI8Nu1MpqxEDZ7xrNCyokEaBiXMscmAlDJ/DQtxj8SUqDgmd8BRvBPl0r1X68qI5ock3+yROOjvNPPIVzmFAiWjrv7p5GRSQkPj+r9KsF0YgXyt8oU11Rk7TraKCyMyMpwaUtUAifCNUG2aHbHjeRt0YhsHwWdHq77p/fEMY+goEMLdy9ngj+/nI2F4PZD1gnOVRAiMVSSBLwChdeirXV4DM1++syPtZ3ZGkvewYGL1OdkNiHByA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5458.namprd12.prod.outlook.com (2603:10b6:5:35b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 17:31:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 17:31:40 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: [PATCH v3 5/7] drm/i915/gvt: Change from vfio_group_(un)pin_pages to vfio_(un)pin_pages
Date:   Mon,  2 May 2022 14:31:35 -0300
Message-Id: <5-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::11) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 026e049a-080e-408f-e90e-08da2c619cf9
X-MS-TrafficTypeDiagnostic: CO6PR12MB5458:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB545858452737FE29A1A02B4CC2C19@CO6PR12MB5458.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wrg+/G5WbV7kvYvgZdd8HvKTxtHRUKF7r3qKNPpZdIwvFf8ys7IxfPNKqQLGsrJPiNkggK9s0UYK/axTECTpQ3irDkf/ah95I9vD6cNYg7sJx67NU/lJcP1Zg/kjKbSi+cbDYiiZY3k6uubTiYAkZvNyzd5hWrCqAVw84BbiyfvVhbdqdU2e36YptgsNFonHbM1oNfwRqVAh/K4LYFIvjNLyLEVqpUfsz9lpljZoixtjtTyKK+RxixUUCnSu9kk4QxX0aFOMHvyIb9IyIAYaJc9tV4BUcwNrhNEJdmEIRWYfdYS7hZ1LIaJr35KWvMRI6QMNw1d+0jG+VXa0vCc7bh43JE2g6el9xR25dUNsbzFBWzif2asbIUMXzJSLGn+a9VnGYzixAe3oMnsF8xvXEeUdmv00fUzuaWEv5VGlAKgqNm1FVdSikx0T4zBmWCEfNDB/P2tcin2sHHSd7yifir96RloUbH5vy9p/oBSqa2Fmi9vT2RIn0yVLQxrHaZdbDYOMv2BRLRVVJ7kVRAlE67qYUdEFbnCwNJwdX3BQs0/919W8k/YLinsHA6loZ9lSpA+7UyBv81f5iBz7ZDhlUt5BVYeUAcoA+NU/dJl/9gR8EwsEWtif1nY0zGtWf1pUmuTM4sGWpd3nXDEkPW/GaoLClvwquhDTt5Vyc6+0rOEhkkTAvOvcndBaRloRSkmyiRL87v534zdmNwaUKHLTYsptjnE/SAlpq3Gd43E6Iws=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(109986005)(6486002)(508600001)(2616005)(86362001)(6512007)(26005)(6506007)(38100700002)(6666004)(316002)(66476007)(2906002)(66946007)(66556008)(186003)(36756003)(5660300002)(8936002)(54906003)(4326008)(83380400001)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WOigoFJ2xSaEYHyQ5VZ8FPJtL9XYnVvGJ5RK30CDeMMh0OSEapGjZCAUzTEh?=
 =?us-ascii?Q?pqmtyTiMilniNkMeiQbCICj6LGJmQCdgOYH/j5AjuB7BADpCAnvOQggIQtQc?=
 =?us-ascii?Q?MA0RpaYhCtpDdU9BjUY69lsC7ZjaA6n6gitZnyEOfjJHV+maMWgC26x3ltwq?=
 =?us-ascii?Q?8H595GBQolUOV1w+GBQLcaovtK1WSqFJsgCEpRJhvgUIehW5FcGdJOD2XyWG?=
 =?us-ascii?Q?xmHv5aNx4VyIKZEL1LlJ0RJP0fNYnYeWjnkFApLprGw979fm3WTQYCqXwtCs?=
 =?us-ascii?Q?EvGeM4gcGor0C+BbPQnKfMthee+RbYmh/vOI//xZOoZuldlxsT0m+KgFueMT?=
 =?us-ascii?Q?3tX304Cg7r2jXp7/myxGClXnMRNYy09u9XKPnA2NXJBFtOBSWLSTjYwfCXee?=
 =?us-ascii?Q?Rk3yiCMn8ago83k8pePuPoZpA0SYwxcnX9te1uwXM9YDYY9zhNh+HsQ6mO1d?=
 =?us-ascii?Q?NLW3/Qi8POkqQ8/kv7eqaoLQXaEyFt/bCnU72ZSXrVoTXveNYYb97G9xfFu1?=
 =?us-ascii?Q?vHP8mhVbWbnEAOiddgoGQgtcnN1wio+q8U0m6fh/G4GUdEo6nOSj0NAZpzr9?=
 =?us-ascii?Q?k313kSPeccnZOQp6ZvG1cC8yn2dHa9Gr68l7Yhp1awMKgZ2O+iNCNEAXjZaD?=
 =?us-ascii?Q?QM/LWmTxb/xi/7+bJVf44W9De7woBODxmlzLyFGvf5Y+Bea9l66Soe8KcTYT?=
 =?us-ascii?Q?hKpA7yV08zpehbRhCOtDG6dEBCCAKJEouZLHg30snEP6XeXBtL7mHtmW5cZG?=
 =?us-ascii?Q?2uq7A1dThwfj4ScPQJWOuN1RhI728KCSFQfmBpQ2Il/BoMnHqE8mrw1YWLcY?=
 =?us-ascii?Q?gfwmPCyzC9cjZ7U1v9ULHflCHxIL56GqirWpCTErlDvWeQGSuPOYm/dE7kcy?=
 =?us-ascii?Q?4wZekjcKT/A4glZZzocl+YlB5AOGY04emURV3qehcNnAqePMX+SqYctYbzRA?=
 =?us-ascii?Q?+kMS/4LWG9JhJu4uunX0r0NARQ/BYkWNQy/Cl8LQeyapRmV+Op0D5jt0AIK3?=
 =?us-ascii?Q?ZmJPfAoCUv38VVu0mwg8gG1gVzdgeHtoRTNcgPELgaVY8H+b1zS4HgJDCwjn?=
 =?us-ascii?Q?kD4gh9ZLyT5uwduDquz2cxLjuTqWIkE1vqPoRkH6A42bayWkbzP4fMY0pR+p?=
 =?us-ascii?Q?STT0Q8ggi6jRZZyWHdgEz3Z5Ypy3a/Prlk1z/WWXSan05KAY1R1JYtAMQyQu?=
 =?us-ascii?Q?pFP3DOYYD+8ksAqyxHqq61ceZ4r8CilCterObA8xZOyCkKaPkYxF/OIQIRNO?=
 =?us-ascii?Q?3PiK4Vw37PIrCYnI6Il8htZn2YZtwmEyLj+yeDdLfpACfcgVX8m1A6K+G+CL?=
 =?us-ascii?Q?6mxO2PixjqMymr/jLpS1M+e6GcC/94ZbN9SBFsxUFBM/EEBsAoPs3slPwecy?=
 =?us-ascii?Q?72fNXk0c2LGUt0QCxRaAJdOwgjtRewDqiHg0lXC0mtU7br4NwhS9nkUuvcT4?=
 =?us-ascii?Q?SZ3vpB0ZTiBRBjonH1sohxuSUwvTWKyyLyT9RJ/asJDJvZKf529+1LKuTcwt?=
 =?us-ascii?Q?dEhkcKHS1gz8jpCaLwKHH8np2oUJSQNfjKEuBPoJe1JjmCT9TiyGA6gl7izE?=
 =?us-ascii?Q?H5nZNFGP+u241hd8zbynOQMWMJUYy5rCfzokvmN+TTdUZKY+tJ7UzgoveLCy?=
 =?us-ascii?Q?jnXD9Y8nsIDX/b1GJA4U0Wb7tTSPL4PT13cz6qX3Oo7qNH6+tCZ/bMZ2eNDx?=
 =?us-ascii?Q?OpSlqnkQJFW4o02j4VNq7yNSpcqeEJ4yLhWneVqcmE2UkH0xYOlawdZZRCMb?=
 =?us-ascii?Q?1bSZgFwokw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 026e049a-080e-408f-e90e-08da2c619cf9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 17:31:38.4669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7BggOxdsL/U8ESgeWqcTWtDf5ir48yWZNIpaRzV4ezJp/a/5vY+8VPFFWsmZ7Pt
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

Use the existing vfio_device versions of vfio_(un)pin_pages(). There is no
reason to use a group interface here, kvmgt has easy access to a
vfio_device.

Delete kvmgt_vdev::vfio_group since these calls were the last users.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/gpu/drm/i915/gvt/gvt.h   |  1 -
 drivers/gpu/drm/i915/gvt/kvmgt.c | 27 ++++++---------------------
 2 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index 5a28ee965b7f3e..2af4c83e733c6c 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -231,7 +231,6 @@ struct intel_vgpu {
 	struct kvm *kvm;
 	struct work_struct release_work;
 	atomic_t released;
-	struct vfio_group *vfio_group;
 
 	struct kvm_page_track_notifier_node track_node;
 #define NR_BKT (1 << 18)
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 1cec4f1fdfaced..7655ffa97d5116 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -243,7 +243,7 @@ static void gvt_unpin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
 	for (npage = 0; npage < total_pages; npage++) {
 		unsigned long cur_gfn = gfn + npage;
 
-		ret = vfio_group_unpin_pages(vgpu->vfio_group, &cur_gfn, 1);
+		ret = vfio_unpin_pages(&vgpu->vfio_device, &cur_gfn, 1);
 		drm_WARN_ON(&i915->drm, ret != 1);
 	}
 }
@@ -266,8 +266,8 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
 		unsigned long cur_gfn = gfn + npage;
 		unsigned long pfn;
 
-		ret = vfio_group_pin_pages(vgpu->vfio_group, &cur_gfn, 1,
-					   IOMMU_READ | IOMMU_WRITE, &pfn);
+		ret = vfio_pin_pages(&vgpu->vfio_device, &cur_gfn, 1,
+				     IOMMU_READ | IOMMU_WRITE, &pfn);
 		if (ret != 1) {
 			gvt_vgpu_err("vfio_pin_pages failed for gfn 0x%lx, ret %d\n",
 				     cur_gfn, ret);
@@ -804,7 +804,6 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 	struct intel_vgpu *vgpu = vfio_dev_to_vgpu(vfio_dev);
 	unsigned long events;
 	int ret;
-	struct vfio_group *vfio_group;
 
 	vgpu->iommu_notifier.notifier_call = intel_vgpu_iommu_notifier;
 	vgpu->group_notifier.notifier_call = intel_vgpu_group_notifier;
@@ -827,28 +826,19 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 		goto undo_iommu;
 	}
 
-	vfio_group =
-		vfio_group_get_external_user_from_dev(vgpu->vfio_device.dev);
-	if (IS_ERR_OR_NULL(vfio_group)) {
-		ret = !vfio_group ? -EFAULT : PTR_ERR(vfio_group);
-		gvt_vgpu_err("vfio_group_get_external_user_from_dev failed\n");
-		goto undo_register;
-	}
-	vgpu->vfio_group = vfio_group;
-
 	ret = -EEXIST;
 	if (vgpu->attached)
-		goto undo_group;
+		goto undo_register;
 
 	ret = -ESRCH;
 	if (!vgpu->kvm || vgpu->kvm->mm != current->mm) {
 		gvt_vgpu_err("KVM is required to use Intel vGPU\n");
-		goto undo_group;
+		goto undo_register;
 	}
 
 	ret = -EEXIST;
 	if (__kvmgt_vgpu_exist(vgpu))
-		goto undo_group;
+		goto undo_register;
 
 	vgpu->attached = true;
 	kvm_get_kvm(vgpu->kvm);
@@ -868,10 +858,6 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 	atomic_set(&vgpu->released, 0);
 	return 0;
 
-undo_group:
-	vfio_group_put_external_user(vgpu->vfio_group);
-	vgpu->vfio_group = NULL;
-
 undo_register:
 	vfio_unregister_notifier(vfio_dev, VFIO_GROUP_NOTIFY,
 				 &vgpu->group_notifier);
@@ -925,7 +911,6 @@ static void __intel_vgpu_release(struct intel_vgpu *vgpu)
 	gvt_cache_destroy(vgpu);
 
 	intel_vgpu_release_msi_eventfd_ctx(vgpu);
-	vfio_group_put_external_user(vgpu->vfio_group);
 
 	vgpu->kvm = NULL;
 	vgpu->attached = false;
-- 
2.36.0

