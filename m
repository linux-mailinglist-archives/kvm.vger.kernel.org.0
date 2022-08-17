Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA23E5973B9
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240720AbiHQQHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240699AbiHQQHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:07:35 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD0B9C1CC
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:07:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAiC8AsAbQyM4Oq+NNeeudDPdFDXAc1xffap/PRuoVrE50hIyoeni8JOrcpKBZCSb4BCg/GecwKBq+GRbymuSJesJ1EhydqYzUsduD8Xkl0ERRNh8SEtwBXdsxX3TK1iRzRtAxelj2Lo7hThIyLTbfCsrPS52vsLS/fLB/AW7IH9Kvfv2L+k6YQh5HbTemVJwCtG1JhTD/cYytQaY3wNsbOhz1tw5lAg/oDfBMzbYkbPK4sPWn+d2pLSggH5fnLsyeYO9ja7UIvPhuy6UlB8aFy+kDrdDmwx7EmTd7ZfSW0DNP67aSOjgRRgMhmfWewlV5ocz9YI2LWnMJK7ycX1Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0kSmOb3QaINiHQhDrGf+qWp0b0WrbLRys6QBYRUQjyc=;
 b=Nyiqe6PnEi5BVlxQipLYfJFXB0E8gl8eaUpqf+BhuwRKybAvVbtFMOenkUxd6x8JajLaHt6eu/LwDnpP/01oCSWY1+CuLL8i6TZBsENjMMad4rKu4n3GmFUcspXGbVDyYvWyEZ6ykfLAkAZRwAoqgAeKb4RCuPdedhCPyVFnLmEhGLjus9BWUSwApupz2urkxrmEasf26Ac8Y6EaqLrWzHPzP28bBsmy0JBdZl9Y2CeVk541Q+pssdQMig6UgZDRGEwVQIEsEFK5mf45R4cLGn6oAI4MTmzVOLDB6LPba5ai/jN6INd+KZcTWfFulBlcNGr9Gc3dNPqtUr6rJstOyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0kSmOb3QaINiHQhDrGf+qWp0b0WrbLRys6QBYRUQjyc=;
 b=TKrtXRnYYmwOKnT6tPiyjyt8oYbhfitrLl5rhPbaxZOI7wZD9PKrEvOA6fXDQHY87WKDERbn63GxDi6JQsMdHG3I4wpJG/As8YcXHGCAQT5vpR9kphfRukOGDGGYeI1KmEvhzMyq8goGI0oB7Mvsg9LqbtLxeyoD/nirQt20d2nl6uMjV9daRJvsGFftDqbbTrXXCsx1NGyH4J49u3MPNA8Cxq+rIhPfLLpQdPaI4OmWbJBFzhyECNMIWGH981TFfynYKoQUpiIYAGRonu/EV9YDwQupEpFmg9239GOSDbIaDn5VaxhWZrKvfW3I2X7JZLBWkCjQ17XQWzMT2J7fTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR1201MB0216.namprd12.prod.outlook.com (2603:10b6:910:18::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Wed, 17 Aug
 2022 16:07:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 16:07:27 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: [PATCH 3/8] vfio-pci: Re-indent what was vfio_pci_core_ioctl()
Date:   Wed, 17 Aug 2022 13:07:20 -0300
Message-Id: <3-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::18) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f029f784-8db3-43a9-673d-08da806a93d4
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0216:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QF3KS3i6ifAm9VDcwnjXSSMxcRnnHP40w2ZEkxr3Mnw1phGTpdRC0NQhnLfyUXb12W+i4N2KnUUvTkvDh3k07LJC8ZSTBt6XLbiIXcSbOIgUnGAQmIdOE6CXjXUmF2j9fm1/YykV97p/XQmtB9XVUyxk9p4Dyez5Y/i5AErmgw6TTVcHNbvcH9Of3+z2LOFzQlxnnOAri9PRuEDTjd31oRwVaFlmje9GLOAvKbqzyNOINEXvu4OlJEtwaz/J/PvHro/RKdKFgojcYB+XdBb1087lMXzvAXpWPH/NKahKVQr8Ntn9ky/0E+DfxyWpU4HxC+92aFE1kuR+1dKOcrEXoill1k3Cr4GP7iy/7eiAIsPih3nbGFTffZF+FqzdkDCfSNnuXD1GMIPNUlUFOZUFP/9Ih90u7Gukk5exx5J7slQuQVcADoHmaEfbnPJRUILdIBdmPxuTP8gpHWwTPJyKo26m4PyA8UCfbN6IYutjb7LY2RO+wcOyN/A/jVmXTIqa4+z8yICd6KnZNm1+gAV5VS8k2FTzZcr31lCqZtqwxldqiQGtv8+rlykChluUZCiLYVjccUz3ZoJXgj2LqA4zYdnPeNj0FBnXH/ci0YevMKGagGHKkYA5kmgjAwd24UOXh/WYVnoDz7+FQR0X0cdTTQoXT9EdOVO3yjFr5W9e48AQHNHKFveURwspYJ1tkyCzWkvCL7v09KSUxLzCiKNrT/jnp62GMTymEXgiPwETZ4cBDzRW9gFHyRTNBngavUN4ILspbwLScXkvPI69MogcU2oT1nTHqnNNfJ4fQoQd9SE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(41300700001)(6506007)(6666004)(6486002)(26005)(66476007)(2906002)(478600001)(8676002)(66556008)(110136005)(36756003)(86362001)(316002)(6512007)(38100700002)(186003)(5660300002)(2616005)(30864003)(8936002)(66946007)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VcLZfbMtd5vNluvxFuEQzngkt2RNvSiPCzrpgHXcXI3Pz05JSAyyySGevCgC?=
 =?us-ascii?Q?1Pc8UfQFuOfuQaXFlPNMzA+1WTc2shNoiqzCiBoEOjWZ9ZlrIBM79mmwhTvu?=
 =?us-ascii?Q?1obvcYc4KL54oXKL/5I+DHJx/EJY+VIEtK3KydtAsZS2MzyUHlQKbbzHOJf5?=
 =?us-ascii?Q?Z1Vf9zlEwlfNRoXm8/3gaFfud4GdyBuYnNyuTYKGQWR11UTuNHNL2yry1LW5?=
 =?us-ascii?Q?63+sRVnRA2rBvIyd5Tsy7mf/xPO0KcW6cjYYrtURVaL33L/vMcmcBzTWtINm?=
 =?us-ascii?Q?b82sGflHwKM1ndebJZhCp3F5nh8rEJlF2hZ3tZyYHUQ1NZFr+dyoqgp3M1bK?=
 =?us-ascii?Q?YC4wIF4oVqQ93CXPdx6Jogv8Te0VV2B8NOUaSi5YFrX+pZUTXeircOPLjrIX?=
 =?us-ascii?Q?JgIzDuHOiEJhjkinCaXSC1en3VPRIts/TPM1bO4GaT37Drudsbvo7+l38Soy?=
 =?us-ascii?Q?aCWbFTKOqwGgWqTucTOml4TGwWKvr45VdWmYpopL3fEgqvJmT1f8HV/yAZIj?=
 =?us-ascii?Q?IfcK1seByD7PD4B2pC0owKWwPXxVSLYKUAA3474be9/SJeZmDhm2bw1K3oMA?=
 =?us-ascii?Q?U/R2tFLnaFfd0ewMyjryMk54P326mTdxJkv+pTJ45JWzXCbg8pzh+imvQJEW?=
 =?us-ascii?Q?lNhvBep+Vntj7RXHdgnWjbUreoYvwYBTgbbMJHjtT7fxWm56thdF4Sp00rY2?=
 =?us-ascii?Q?JkvHonvdvsXjaQAitj5CHheKZOIQcqCyBicjz6Elurw2Hg4koQN/qMUz5o5j?=
 =?us-ascii?Q?3lZCDE6fT1aPk6rsMs/loSmxbp2QR/hmiMuPkuYDEtereW5nCzkz+DipNqde?=
 =?us-ascii?Q?3bQBtrq2dmMGNRHf9us6QsprYS1IFlhCkuEr+i4IqTvrbK8wegFTGlsIUgi9?=
 =?us-ascii?Q?/DkFL0RzJjCjLElg9AvZ3x6hujzmOWWIIuSuoBMXEvfqWbadolyci5UeJTJb?=
 =?us-ascii?Q?YD29qV5EZSDtPae9eUBF0NYkrRT+8fSVVnfVcsXZZAitl4v9umhZYe+S4SZK?=
 =?us-ascii?Q?JwMWveLxTXnCJZtyeIU22l6dSg58/SCajdQbrcxylb+iYdcvndWJLAL6JM14?=
 =?us-ascii?Q?ScAxBU6kZed/D6jOy0qqu7+uqMXp+VkyvogO2OwlERYLVHV909TvH3nRQg58?=
 =?us-ascii?Q?/Ajs7K5Hncjba9p5MP5NBx+Zg0m4MfU45mHjRr4vGDf7aMYyVCUtvasJjhBl?=
 =?us-ascii?Q?rtH5CcWAc4Z08JQlvm2COMOktheTQEVrhAPesWJlGbVqoncbR2YQudwSzfcK?=
 =?us-ascii?Q?gXGBqSMvVc92/f7WuuJn6b4vRqdXJF3fBU67yb7n+pr0FErRGT6ihy/lWDld?=
 =?us-ascii?Q?2pnfIN0rDwehZMEGjmULDaPQGa6kbF76OWYyUL32k08JcXMis68RXCiE0Ja6?=
 =?us-ascii?Q?wRqJHRw+LsyBY1+7nv/R+kmDhP0OzaKMMIBJ37+F7fezalW0/VF6H4JjP0MG?=
 =?us-ascii?Q?MRO2Hhf2h6lKtoO1dUFIsUlye6JSfWv47W/z/Mfu4nIsV7VV8i4bKBkXrkl/?=
 =?us-ascii?Q?1zdHIbau3wta9XeKZoap6m//h5EWKwYVLtAEFhmXBfBuj3huI/TFmxdn4oG0?=
 =?us-ascii?Q?FgmyFBLEmOkcCxZK8q4avqzea9iECLTuPqMRTs0X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f029f784-8db3-43a9-673d-08da806a93d4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:07:26.3124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2U5WzHAoGh/XlLNRWwYeX6kxSZi+sa59xAkCkVBQwy7y44kR1PtJKwgjZOQSAeF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0216
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Done mechanically with:

 $ git clang-format-14 -i --lines 675:1210 drivers/vfio/pci/vfio_pci_core.c

And manually reflow the multi-line comments clang-format doesn't fix.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 711 +++++++++++++++----------------
 1 file changed, 349 insertions(+), 362 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6094f237552b35..a0a855a52bbf1d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -693,309 +693,300 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 				   void __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_device_info, num_irqs);
-		struct vfio_device_info info;
-		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
-		unsigned long capsz;
-		int ret;
+	struct vfio_device_info info;
+	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+	unsigned long capsz;
+	int ret;
 
-		/* For backward compatibility, cannot require this */
-		capsz = offsetofend(struct vfio_iommu_type1_info, cap_offset);
+	/* For backward compatibility, cannot require this */
+	capsz = offsetofend(struct vfio_iommu_type1_info, cap_offset);
 
-		if (copy_from_user(&info, (void __user *)arg, minsz))
-			return -EFAULT;
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
 
-		if (info.argsz < minsz)
-			return -EINVAL;
+	if (info.argsz < minsz)
+		return -EINVAL;
 
-		if (info.argsz >= capsz) {
-			minsz = capsz;
-			info.cap_offset = 0;
-		}
+	if (info.argsz >= capsz) {
+		minsz = capsz;
+		info.cap_offset = 0;
+	}
 
-		info.flags = VFIO_DEVICE_FLAGS_PCI;
+	info.flags = VFIO_DEVICE_FLAGS_PCI;
 
-		if (vdev->reset_works)
-			info.flags |= VFIO_DEVICE_FLAGS_RESET;
+	if (vdev->reset_works)
+		info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
-		info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
-		info.num_irqs = VFIO_PCI_NUM_IRQS;
+	info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
+	info.num_irqs = VFIO_PCI_NUM_IRQS;
 
-		ret = vfio_pci_info_zdev_add_caps(vdev, &caps);
-		if (ret && ret != -ENODEV) {
-			pci_warn(vdev->pdev, "Failed to setup zPCI info capabilities\n");
-			return ret;
-		}
+	ret = vfio_pci_info_zdev_add_caps(vdev, &caps);
+	if (ret && ret != -ENODEV) {
+		pci_warn(vdev->pdev,
+			 "Failed to setup zPCI info capabilities\n");
+		return ret;
+	}
 
-		if (caps.size) {
-			info.flags |= VFIO_DEVICE_FLAGS_CAPS;
-			if (info.argsz < sizeof(info) + caps.size) {
-				info.argsz = sizeof(info) + caps.size;
-			} else {
-				vfio_info_cap_shift(&caps, sizeof(info));
-				if (copy_to_user((void __user *)arg +
-						  sizeof(info), caps.buf,
-						  caps.size)) {
-					kfree(caps.buf);
-					return -EFAULT;
-				}
-				info.cap_offset = sizeof(info);
+	if (caps.size) {
+		info.flags |= VFIO_DEVICE_FLAGS_CAPS;
+		if (info.argsz < sizeof(info) + caps.size) {
+			info.argsz = sizeof(info) + caps.size;
+		} else {
+			vfio_info_cap_shift(&caps, sizeof(info));
+			if (copy_to_user((void __user *)arg + sizeof(info),
+					 caps.buf, caps.size)) {
+				kfree(caps.buf);
+				return -EFAULT;
 			}
-
-			kfree(caps.buf);
+			info.cap_offset = sizeof(info);
 		}
 
-		return copy_to_user((void __user *)arg, &info, minsz) ?
-			-EFAULT : 0;
+		kfree(caps.buf);
+	}
+
+	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 }
 
 static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 					  void __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
-		struct pci_dev *pdev = vdev->pdev;
-		struct vfio_region_info info;
-		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
-		int i, ret;
+	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_region_info info;
+	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+	int i, ret;
 
-		if (copy_from_user(&info, (void __user *)arg, minsz))
-			return -EFAULT;
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
 
-		if (info.argsz < minsz)
-			return -EINVAL;
+	if (info.argsz < minsz)
+		return -EINVAL;
 
-		switch (info.index) {
-		case VFIO_PCI_CONFIG_REGION_INDEX:
-			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-			info.size = pdev->cfg_size;
-			info.flags = VFIO_REGION_INFO_FLAG_READ |
-				     VFIO_REGION_INFO_FLAG_WRITE;
+	switch (info.index) {
+	case VFIO_PCI_CONFIG_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = pdev->cfg_size;
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+			     VFIO_REGION_INFO_FLAG_WRITE;
+		break;
+	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = pci_resource_len(pdev, info.index);
+		if (!info.size) {
+			info.flags = 0;
 			break;
-		case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
-			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-			info.size = pci_resource_len(pdev, info.index);
-			if (!info.size) {
-				info.flags = 0;
-				break;
-			}
+		}
 
-			info.flags = VFIO_REGION_INFO_FLAG_READ |
-				     VFIO_REGION_INFO_FLAG_WRITE;
-			if (vdev->bar_mmap_supported[info.index]) {
-				info.flags |= VFIO_REGION_INFO_FLAG_MMAP;
-				if (info.index == vdev->msix_bar) {
-					ret = msix_mmappable_cap(vdev, &caps);
-					if (ret)
-						return ret;
-				}
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+			     VFIO_REGION_INFO_FLAG_WRITE;
+		if (vdev->bar_mmap_supported[info.index]) {
+			info.flags |= VFIO_REGION_INFO_FLAG_MMAP;
+			if (info.index == vdev->msix_bar) {
+				ret = msix_mmappable_cap(vdev, &caps);
+				if (ret)
+					return ret;
 			}
+		}
 
-			break;
-		case VFIO_PCI_ROM_REGION_INDEX:
-		{
-			void __iomem *io;
-			size_t size;
-			u16 cmd;
+		break;
+	case VFIO_PCI_ROM_REGION_INDEX: {
+		void __iomem *io;
+		size_t size;
+		u16 cmd;
+
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.flags = 0;
+
+		/* Report the BAR size, not the ROM size */
+		info.size = pci_resource_len(pdev, info.index);
+		if (!info.size) {
+			/* Shadow ROMs appear as PCI option ROMs */
+			if (pdev->resource[PCI_ROM_RESOURCE].flags &
+			    IORESOURCE_ROM_SHADOW)
+				info.size = 0x20000;
+			else
+				break;
+		}
 
-			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-			info.flags = 0;
+		/*
+		 * Is it really there?  Enable memory decode for implicit access
+		 * in pci_map_rom().
+		 */
+		cmd = vfio_pci_memory_lock_and_enable(vdev);
+		io = pci_map_rom(pdev, &size);
+		if (io) {
+			info.flags = VFIO_REGION_INFO_FLAG_READ;
+			pci_unmap_rom(pdev, io);
+		} else {
+			info.size = 0;
+		}
+		vfio_pci_memory_unlock_and_restore(vdev, cmd);
 
-			/* Report the BAR size, not the ROM size */
-			info.size = pci_resource_len(pdev, info.index);
-			if (!info.size) {
-				/* Shadow ROMs appear as PCI option ROMs */
-				if (pdev->resource[PCI_ROM_RESOURCE].flags &
-							IORESOURCE_ROM_SHADOW)
-					info.size = 0x20000;
-				else
-					break;
-			}
+		break;
+	}
+	case VFIO_PCI_VGA_REGION_INDEX:
+		if (!vdev->has_vga)
+			return -EINVAL;
 
-			/*
-			 * Is it really there?  Enable memory decode for
-			 * implicit access in pci_map_rom().
-			 */
-			cmd = vfio_pci_memory_lock_and_enable(vdev);
-			io = pci_map_rom(pdev, &size);
-			if (io) {
-				info.flags = VFIO_REGION_INFO_FLAG_READ;
-				pci_unmap_rom(pdev, io);
-			} else {
-				info.size = 0;
-			}
-			vfio_pci_memory_unlock_and_restore(vdev, cmd);
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = 0xc0000;
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+			     VFIO_REGION_INFO_FLAG_WRITE;
 
-			break;
-		}
-		case VFIO_PCI_VGA_REGION_INDEX:
-			if (!vdev->has_vga)
-				return -EINVAL;
+		break;
+	default: {
+		struct vfio_region_info_cap_type cap_type = {
+			.header.id = VFIO_REGION_INFO_CAP_TYPE,
+			.header.version = 1
+		};
 
-			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-			info.size = 0xc0000;
-			info.flags = VFIO_REGION_INFO_FLAG_READ |
-				     VFIO_REGION_INFO_FLAG_WRITE;
-
-			break;
-		default:
-		{
-			struct vfio_region_info_cap_type cap_type = {
-					.header.id = VFIO_REGION_INFO_CAP_TYPE,
-					.header.version = 1 };
+		if (info.index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
+			return -EINVAL;
+		info.index = array_index_nospec(
+			info.index, VFIO_PCI_NUM_REGIONS + vdev->num_regions);
 
-			if (info.index >=
-			    VFIO_PCI_NUM_REGIONS + vdev->num_regions)
-				return -EINVAL;
-			info.index = array_index_nospec(info.index,
-							VFIO_PCI_NUM_REGIONS +
-							vdev->num_regions);
+		i = info.index - VFIO_PCI_NUM_REGIONS;
 
-			i = info.index - VFIO_PCI_NUM_REGIONS;
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = vdev->region[i].size;
+		info.flags = vdev->region[i].flags;
 
-			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-			info.size = vdev->region[i].size;
-			info.flags = vdev->region[i].flags;
+		cap_type.type = vdev->region[i].type;
+		cap_type.subtype = vdev->region[i].subtype;
 
-			cap_type.type = vdev->region[i].type;
-			cap_type.subtype = vdev->region[i].subtype;
+		ret = vfio_info_add_capability(&caps, &cap_type.header,
+					       sizeof(cap_type));
+		if (ret)
+			return ret;
 
-			ret = vfio_info_add_capability(&caps, &cap_type.header,
-						       sizeof(cap_type));
+		if (vdev->region[i].ops->add_capability) {
+			ret = vdev->region[i].ops->add_capability(
+				vdev, &vdev->region[i], &caps);
 			if (ret)
 				return ret;
-
-			if (vdev->region[i].ops->add_capability) {
-				ret = vdev->region[i].ops->add_capability(vdev,
-						&vdev->region[i], &caps);
-				if (ret)
-					return ret;
-			}
-		}
 		}
+	}
+	}
 
-		if (caps.size) {
-			info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
-			if (info.argsz < sizeof(info) + caps.size) {
-				info.argsz = sizeof(info) + caps.size;
-				info.cap_offset = 0;
-			} else {
-				vfio_info_cap_shift(&caps, sizeof(info));
-				if (copy_to_user((void __user *)arg +
-						  sizeof(info), caps.buf,
-						  caps.size)) {
-					kfree(caps.buf);
-					return -EFAULT;
-				}
-				info.cap_offset = sizeof(info);
+	if (caps.size) {
+		info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
+		if (info.argsz < sizeof(info) + caps.size) {
+			info.argsz = sizeof(info) + caps.size;
+			info.cap_offset = 0;
+		} else {
+			vfio_info_cap_shift(&caps, sizeof(info));
+			if (copy_to_user((void __user *)arg + sizeof(info),
+					 caps.buf, caps.size)) {
+				kfree(caps.buf);
+				return -EFAULT;
 			}
-
-			kfree(caps.buf);
+			info.cap_offset = sizeof(info);
 		}
 
-		return copy_to_user((void __user *)arg, &info, minsz) ?
-			-EFAULT : 0;
+		kfree(caps.buf);
+	}
+
+	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 }
 
 static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 				       void __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_irq_info, count);
-		struct vfio_irq_info info;
+	struct vfio_irq_info info;
 
-		if (copy_from_user(&info, (void __user *)arg, minsz))
-			return -EFAULT;
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
 
-		if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
-			return -EINVAL;
+	if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
+		return -EINVAL;
 
-		switch (info.index) {
-		case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
-		case VFIO_PCI_REQ_IRQ_INDEX:
+	switch (info.index) {
+	case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
+	case VFIO_PCI_REQ_IRQ_INDEX:
+		break;
+	case VFIO_PCI_ERR_IRQ_INDEX:
+		if (pci_is_pcie(vdev->pdev))
 			break;
-		case VFIO_PCI_ERR_IRQ_INDEX:
-			if (pci_is_pcie(vdev->pdev))
-				break;
-			fallthrough;
-		default:
-			return -EINVAL;
-		}
+		fallthrough;
+	default:
+		return -EINVAL;
+	}
 
-		info.flags = VFIO_IRQ_INFO_EVENTFD;
+	info.flags = VFIO_IRQ_INFO_EVENTFD;
 
-		info.count = vfio_pci_get_irq_count(vdev, info.index);
+	info.count = vfio_pci_get_irq_count(vdev, info.index);
 
-		if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
-			info.flags |= (VFIO_IRQ_INFO_MASKABLE |
-				       VFIO_IRQ_INFO_AUTOMASKED);
-		else
-			info.flags |= VFIO_IRQ_INFO_NORESIZE;
+	if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
+		info.flags |=
+			(VFIO_IRQ_INFO_MASKABLE | VFIO_IRQ_INFO_AUTOMASKED);
+	else
+		info.flags |= VFIO_IRQ_INFO_NORESIZE;
 
-		return copy_to_user((void __user *)arg, &info, minsz) ?
-			-EFAULT : 0;
+	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 }
 
 static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 				   void __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_irq_set, count);
-		struct vfio_irq_set hdr;
-		u8 *data = NULL;
-		int max, ret = 0;
-		size_t data_size = 0;
+	struct vfio_irq_set hdr;
+	u8 *data = NULL;
+	int max, ret = 0;
+	size_t data_size = 0;
 
-		if (copy_from_user(&hdr, (void __user *)arg, minsz))
-			return -EFAULT;
+	if (copy_from_user(&hdr, (void __user *)arg, minsz))
+		return -EFAULT;
 
-		max = vfio_pci_get_irq_count(vdev, hdr.index);
+	max = vfio_pci_get_irq_count(vdev, hdr.index);
 
-		ret = vfio_set_irqs_validate_and_prepare(&hdr, max,
-						 VFIO_PCI_NUM_IRQS, &data_size);
-		if (ret)
-			return ret;
+	ret = vfio_set_irqs_validate_and_prepare(&hdr, max, VFIO_PCI_NUM_IRQS,
+						 &data_size);
+	if (ret)
+		return ret;
 
-		if (data_size) {
-			data = memdup_user((void __user *)(arg + minsz),
-					    data_size);
-			if (IS_ERR(data))
-				return PTR_ERR(data);
-		}
+	if (data_size) {
+		data = memdup_user((void __user *)(arg + minsz), data_size);
+		if (IS_ERR(data))
+			return PTR_ERR(data);
+	}
 
-		mutex_lock(&vdev->igate);
+	mutex_lock(&vdev->igate);
 
-		ret = vfio_pci_set_irqs_ioctl(vdev, hdr.flags, hdr.index,
-					      hdr.start, hdr.count, data);
+	ret = vfio_pci_set_irqs_ioctl(vdev, hdr.flags, hdr.index, hdr.start,
+				      hdr.count, data);
 
-		mutex_unlock(&vdev->igate);
-		kfree(data);
+	mutex_unlock(&vdev->igate);
+	kfree(data);
 
-		return ret;
+	return ret;
 }
 
 static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
 				void __user *arg)
 {
-		int ret;
+	int ret;
 
-		if (!vdev->reset_works)
-			return -EINVAL;
+	if (!vdev->reset_works)
+		return -EINVAL;
 
-		vfio_pci_zap_and_down_write_memory_lock(vdev);
+	vfio_pci_zap_and_down_write_memory_lock(vdev);
 
-		/*
-		 * This function can be invoked while the power state is non-D0.
-		 * If pci_try_reset_function() has been called while the power
-		 * state is non-D0, then pci_try_reset_function() will
-		 * internally set the power state to D0 without vfio driver
-		 * involvement. For the devices which have NoSoftRst-, the
-		 * reset function can cause the PCI config space reset without
-		 * restoring the original state (saved locally in
-		 * 'vdev->pm_save').
-		 */
-		vfio_pci_set_power_state(vdev, PCI_D0);
+	/*
+	 * This function can be invoked while the power state is non-D0. If
+	 * pci_try_reset_function() has been called while the power state is
+	 * non-D0, then pci_try_reset_function() will internally set the power
+	 * state to D0 without vfio driver involvement. For the devices which
+	 * have NoSoftRst-, the reset function can cause the PCI config space
+	 * reset without restoring the original state (saved locally in
+	 * 'vdev->pm_save').
+	 */
+	vfio_pci_set_power_state(vdev, PCI_D0);
 
-		ret = pci_try_reset_function(vdev->pdev);
-		up_write(&vdev->memory_lock);
+	ret = pci_try_reset_function(vdev->pdev);
+	up_write(&vdev->memory_lock);
 
-		return ret;
+	return ret;
 }
 
 static int
@@ -1004,196 +995,192 @@ vfio_pci_ioctl_get_pci_hot_reset_info(struct vfio_pci_core_device *vdev,
 {
 	unsigned long minsz =
 		offsetofend(struct vfio_pci_hot_reset_info, count);
-		struct vfio_pci_hot_reset_info hdr;
-		struct vfio_pci_fill_info fill = { 0 };
-		struct vfio_pci_dependent_device *devices = NULL;
-		bool slot = false;
-		int ret = 0;
+	struct vfio_pci_hot_reset_info hdr;
+	struct vfio_pci_fill_info fill = { 0 };
+	struct vfio_pci_dependent_device *devices = NULL;
+	bool slot = false;
+	int ret = 0;
 
-		if (copy_from_user(&hdr, (void __user *)arg, minsz))
-			return -EFAULT;
+	if (copy_from_user(&hdr, (void __user *)arg, minsz))
+		return -EFAULT;
 
-		if (hdr.argsz < minsz)
-			return -EINVAL;
+	if (hdr.argsz < minsz)
+		return -EINVAL;
 
-		hdr.flags = 0;
+	hdr.flags = 0;
 
-		/* Can we do a slot or bus reset or neither? */
-		if (!pci_probe_reset_slot(vdev->pdev->slot))
-			slot = true;
-		else if (pci_probe_reset_bus(vdev->pdev->bus))
-			return -ENODEV;
+	/* Can we do a slot or bus reset or neither? */
+	if (!pci_probe_reset_slot(vdev->pdev->slot))
+		slot = true;
+	else if (pci_probe_reset_bus(vdev->pdev->bus))
+		return -ENODEV;
 
-		/* How many devices are affected? */
-		ret = vfio_pci_for_each_slot_or_bus(vdev->pdev,
-						    vfio_pci_count_devs,
-						    &fill.max, slot);
-		if (ret)
-			return ret;
+	/* How many devices are affected? */
+	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
+					    &fill.max, slot);
+	if (ret)
+		return ret;
 
-		WARN_ON(!fill.max); /* Should always be at least one */
+	WARN_ON(!fill.max); /* Should always be at least one */
 
-		/*
-		 * If there's enough space, fill it now, otherwise return
-		 * -ENOSPC and the number of devices affected.
-		 */
-		if (hdr.argsz < sizeof(hdr) + (fill.max * sizeof(*devices))) {
-			ret = -ENOSPC;
-			hdr.count = fill.max;
-			goto reset_info_exit;
-		}
+	/*
+	 * If there's enough space, fill it now, otherwise return -ENOSPC and
+	 * the number of devices affected.
+	 */
+	if (hdr.argsz < sizeof(hdr) + (fill.max * sizeof(*devices))) {
+		ret = -ENOSPC;
+		hdr.count = fill.max;
+		goto reset_info_exit;
+	}
 
-		devices = kcalloc(fill.max, sizeof(*devices), GFP_KERNEL);
-		if (!devices)
-			return -ENOMEM;
+	devices = kcalloc(fill.max, sizeof(*devices), GFP_KERNEL);
+	if (!devices)
+		return -ENOMEM;
 
-		fill.devices = devices;
+	fill.devices = devices;
 
-		ret = vfio_pci_for_each_slot_or_bus(vdev->pdev,
-						    vfio_pci_fill_devs,
-						    &fill, slot);
+	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_fill_devs,
+					    &fill, slot);
 
-		/*
-		 * If a device was removed between counting and filling,
-		 * we may come up short of fill.max.  If a device was
-		 * added, we'll have a return of -EAGAIN above.
-		 */
-		if (!ret)
-			hdr.count = fill.cur;
+	/*
+	 * If a device was removed between counting and filling, we may come up
+	 * short of fill.max.  If a device was added, we'll have a return of
+	 * -EAGAIN above.
+	 */
+	if (!ret)
+		hdr.count = fill.cur;
 
 reset_info_exit:
-		if (copy_to_user((void __user *)arg, &hdr, minsz))
-			ret = -EFAULT;
+	if (copy_to_user((void __user *)arg, &hdr, minsz))
+		ret = -EFAULT;
 
-		if (!ret) {
-			if (copy_to_user((void __user *)(arg + minsz), devices,
-					 hdr.count * sizeof(*devices)))
-				ret = -EFAULT;
-		}
+	if (!ret) {
+		if (copy_to_user((void __user *)(arg + minsz), devices,
+				 hdr.count * sizeof(*devices)))
+			ret = -EFAULT;
+	}
 
-		kfree(devices);
-		return ret;
+	kfree(devices);
+	return ret;
 }
 
 static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 					void __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
-		struct vfio_pci_hot_reset hdr;
-		int32_t *group_fds;
-		struct file **files;
-		struct vfio_pci_group_info info;
-		bool slot = false;
-		int file_idx, count = 0, ret = 0;
-
-		if (copy_from_user(&hdr, (void __user *)arg, minsz))
-			return -EFAULT;
+	struct vfio_pci_hot_reset hdr;
+	int32_t *group_fds;
+	struct file **files;
+	struct vfio_pci_group_info info;
+	bool slot = false;
+	int file_idx, count = 0, ret = 0;
 
-		if (hdr.argsz < minsz || hdr.flags)
-			return -EINVAL;
+	if (copy_from_user(&hdr, (void __user *)arg, minsz))
+		return -EFAULT;
 
-		/* Can we do a slot or bus reset or neither? */
-		if (!pci_probe_reset_slot(vdev->pdev->slot))
-			slot = true;
-		else if (pci_probe_reset_bus(vdev->pdev->bus))
-			return -ENODEV;
+	if (hdr.argsz < minsz || hdr.flags)
+		return -EINVAL;
 
-		/*
-		 * We can't let userspace give us an arbitrarily large
-		 * buffer to copy, so verify how many we think there
-		 * could be.  Note groups can have multiple devices so
-		 * one group per device is the max.
-		 */
-		ret = vfio_pci_for_each_slot_or_bus(vdev->pdev,
-						    vfio_pci_count_devs,
-						    &count, slot);
-		if (ret)
-			return ret;
+	/* Can we do a slot or bus reset or neither? */
+	if (!pci_probe_reset_slot(vdev->pdev->slot))
+		slot = true;
+	else if (pci_probe_reset_bus(vdev->pdev->bus))
+		return -ENODEV;
 
-		/* Somewhere between 1 and count is OK */
-		if (!hdr.count || hdr.count > count)
-			return -EINVAL;
+	/*
+	 * We can't let userspace give us an arbitrarily large buffer to copy,
+	 * so verify how many we think there could be.  Note groups can have
+	 * multiple devices so one group per device is the max.
+	 */
+	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
+					    &count, slot);
+	if (ret)
+		return ret;
 
-		group_fds = kcalloc(hdr.count, sizeof(*group_fds), GFP_KERNEL);
-		files = kcalloc(hdr.count, sizeof(*files), GFP_KERNEL);
-		if (!group_fds || !files) {
-			kfree(group_fds);
-			kfree(files);
-			return -ENOMEM;
-		}
+	/* Somewhere between 1 and count is OK */
+	if (!hdr.count || hdr.count > count)
+		return -EINVAL;
 
-		if (copy_from_user(group_fds, (void __user *)(arg + minsz),
-				   hdr.count * sizeof(*group_fds))) {
-			kfree(group_fds);
-			kfree(files);
-			return -EFAULT;
-		}
+	group_fds = kcalloc(hdr.count, sizeof(*group_fds), GFP_KERNEL);
+	files = kcalloc(hdr.count, sizeof(*files), GFP_KERNEL);
+	if (!group_fds || !files) {
+		kfree(group_fds);
+		kfree(files);
+		return -ENOMEM;
+	}
 
-		/*
-		 * For each group_fd, get the group through the vfio external
-		 * user interface and store the group and iommu ID.  This
-		 * ensures the group is held across the reset.
-		 */
-		for (file_idx = 0; file_idx < hdr.count; file_idx++) {
-			struct file *file = fget(group_fds[file_idx]);
+	if (copy_from_user(group_fds, (void __user *)(arg + minsz),
+			   hdr.count * sizeof(*group_fds))) {
+		kfree(group_fds);
+		kfree(files);
+		return -EFAULT;
+	}
 
-			if (!file) {
-				ret = -EBADF;
-				break;
-			}
+	/*
+	 * For each group_fd, get the group through the vfio external user
+	 * interface and store the group and iommu ID.  This ensures the group
+	 * is held across the reset.
+	 */
+	for (file_idx = 0; file_idx < hdr.count; file_idx++) {
+		struct file *file = fget(group_fds[file_idx]);
 
-			/* Ensure the FD is a vfio group FD.*/
-			if (!vfio_file_iommu_group(file)) {
-				fput(file);
-				ret = -EINVAL;
-				break;
-			}
+		if (!file) {
+			ret = -EBADF;
+			break;
+		}
 
-			files[file_idx] = file;
+		/* Ensure the FD is a vfio group FD.*/
+		if (!vfio_file_iommu_group(file)) {
+			fput(file);
+			ret = -EINVAL;
+			break;
 		}
 
-		kfree(group_fds);
+		files[file_idx] = file;
+	}
 
-		/* release reference to groups on error */
-		if (ret)
-			goto hot_reset_release;
+	kfree(group_fds);
+
+	/* release reference to groups on error */
+	if (ret)
+		goto hot_reset_release;
 
-		info.count = hdr.count;
-		info.files = files;
+	info.count = hdr.count;
+	info.files = files;
 
-		ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
+	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
 
 hot_reset_release:
-		for (file_idx--; file_idx >= 0; file_idx--)
-			fput(files[file_idx]);
+	for (file_idx--; file_idx >= 0; file_idx--)
+		fput(files[file_idx]);
 
-		kfree(files);
-		return ret;
+	kfree(files);
+	return ret;
 }
 
 static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
 				    void __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_device_ioeventfd, fd);
-		struct vfio_device_ioeventfd ioeventfd;
-		int count;
+	struct vfio_device_ioeventfd ioeventfd;
+	int count;
 
-		if (copy_from_user(&ioeventfd, (void __user *)arg, minsz))
-			return -EFAULT;
+	if (copy_from_user(&ioeventfd, (void __user *)arg, minsz))
+		return -EFAULT;
 
-		if (ioeventfd.argsz < minsz)
-			return -EINVAL;
+	if (ioeventfd.argsz < minsz)
+		return -EINVAL;
 
-		if (ioeventfd.flags & ~VFIO_DEVICE_IOEVENTFD_SIZE_MASK)
-			return -EINVAL;
+	if (ioeventfd.flags & ~VFIO_DEVICE_IOEVENTFD_SIZE_MASK)
+		return -EINVAL;
 
-		count = ioeventfd.flags & VFIO_DEVICE_IOEVENTFD_SIZE_MASK;
+	count = ioeventfd.flags & VFIO_DEVICE_IOEVENTFD_SIZE_MASK;
 
-		if (hweight8(count) != 1 || ioeventfd.fd < -1)
-			return -EINVAL;
+	if (hweight8(count) != 1 || ioeventfd.fd < -1)
+		return -EINVAL;
 
-		return vfio_pci_ioeventfd(vdev, ioeventfd.offset,
-					  ioeventfd.data, count, ioeventfd.fd);
+	return vfio_pci_ioeventfd(vdev, ioeventfd.offset, ioeventfd.data, count,
+				  ioeventfd.fd);
 }
 
 long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
-- 
2.37.2

