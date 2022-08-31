Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3AC5A8768
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 22:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiHaUQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 16:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiHaUQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 16:16:14 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2088.outbound.protection.outlook.com [40.107.101.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEB4E58A2
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 13:16:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XzMMLdX3CqffnsqAn7nGQgcsvcCSuUmkzI8JsuCkvZXZzBoUBwN/VxlY5vgry3SHKNpyreLfJJc6uM0ossKV1zlSdDDNZw3/1fxFSlmmxjEhROr3Ua3oZVHAQLsXvGhKsB04TlZ3u/74w7nw3glTKI2CKxeT/704VIY9M3t1mOSm3Ciqb3wU16+w6YNqC4F9HL/K89BBe3ww+jOWH0f21C2SegbDfubhFaA4qoeVzdgSxNxwofkkscqBTtiZV4TAqKqDVMKwvBAIEjGabBOYZTeVRmAyOsMSV/D6et/2wrBE4AER6SNPa08vQUIYR+pH8uI4CflptJ/HLl4kCHdimw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POhumK55o3vMgyYg0MsAGYQmQ6zvj9SwZ21F85jpYN4=;
 b=R4fat12zC8vCK/6aJK600EVCLhzxSFkxpfI846ZGcNarBCyhFeswCkC+ONNVLzl6SOVjNflVzrhfbuiPknJXDTXU12zN1vLwSD56vzgVixP3mLlGCoRWD7aapn1Y1yYy3+TkMW8Fao1gvynUzBeXmdOHNj6b13kxpSSMYUNg9EyXiLbwb11Rm+WelXbJUTfsuQsdznYr2CgNgfdT2EQfOfRZo/UGw/jKjjjUU7x3FCkX6oYqS3tmEFwtRYswauytvu4YaAwCos58xINFY+sxEFBjmlUwHQ9LPsyCm7uFMzzn5ssuiIHb2kfnFU/gpjVxfbqtEw3EIy/K1lBJ5CwK4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POhumK55o3vMgyYg0MsAGYQmQ6zvj9SwZ21F85jpYN4=;
 b=CIldpUJAhVDUE5y54KjXQ53hXxX6/kR15VJIEc6iLJIorliH+bYFVYed245oJBsjohDq4FCIMfvQ9iPgZyFGYjXl2EUALkmYxbU6Kk3RBjao9GfzkiEauRzKfyqOV6941qlDpYAy7gRXRjHizIetO35ugUcp7UNgE7T1KoZd1ix7N24GJ7fvmOsiikrOa/AueGLqROZoFhxQeUCJogJjoW9+fMO5Kb2Cuex6xlnyOXSx7sujI4aQfOYs3oAHNX/SZzNX6xjcRat5Xc4QwutaWrMOQAblblPUSYY60dqcBjPfbrjz/z4zksN2JcdRy54+Q6X+cknfWZV8A60rdURoUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by SJ1PR12MB6316.namprd12.prod.outlook.com (2603:10b6:a03:455::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 20:16:08 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 20:16:08 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 3/8] vfio-pci: Re-indent what was vfio_pci_core_ioctl()
Date:   Wed, 31 Aug 2022 17:15:58 -0300
Message-Id: <3-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0205.namprd03.prod.outlook.com
 (2603:10b6:408:f9::30) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c44dbd4b-e9c8-4321-2914-08da8b8da223
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6316:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2gJ8Yv0OlnqLocwSKN4CVtHuUbUHSI/lYXh1Zbq2Fx4OSuM6eyBhB4XZIbrTZ/3rQYcFXscGCiHhfn9cYDypOzq/OyA7BxS8ZcTx8j7SWrQwBOPByZJ8JGixDzuRSBTR89zzyfc/jMhNRATbE7NojwfrPTN2XXYiQ2aq9b92yxf3el/na++zgHmWfOBuVsGffxOFhGk66DSvAdEAn+xacNNeHjd9Tl8M32Wih+n7+PEBQT3Ol9YDNoS9RJ4tuWV0RhKnelm/5k8799LF0aBCJUAnM92NFH/HD9wtc7p/LCUAnx1OQcRYTnfVegHnpE3Op9eng+kqYmMk1OQEefL8O306vaNqGRI+gchJcPyCdGwSZF3MinU/58R0BNcmS4PQCiVT4BrZ5t55xwsxH0WtLWJjlDJwYdDb7a+qsh+RCxTpmriEYsNURKfS1I0mr69ElaYlOkWhlUviF3g5gYuD4T+RY7hv76O7wGGpyasmANztcJGXqnIviz+zU0QI2P5WjrNhVxcoAP0Iq+IV0x+fCUR3OV6Dm+1v2tvW/VsOMpoWJVaX8aeiKMdOBl24NM/ZY8EidvDXlpcEFCk2NSWZ5fuaTJ5chbxmVpJTvjqsq3+8R37qz3tn2UAZ97agoan9a5gJJx7df1jvqvig4MpZPiaaisy0w6Ijaf4e3hFqAZQAuUyD8usVCxqcvxOzXAh+Pf14YtYilz9P3HG38lvE75nHvi2g73vUdih2cxLFNkqwrt6ZmtJRcWaxLYC0CMdn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(186003)(5660300002)(110136005)(478600001)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(6486002)(86362001)(36756003)(8936002)(41300700001)(30864003)(2616005)(6666004)(38100700002)(2906002)(6506007)(83380400001)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Pdbi3BN33ZEcHL/irfWcRdPYJzru50oGyXZPZUM1+MnWaxVVdFeV0EwKA5b?=
 =?us-ascii?Q?rL8mokgqHlyqzppPhVM14CmKpG1rizJl+zRVJLmaVhbugTNx5yaOpiOuJ42d?=
 =?us-ascii?Q?VtREM0qQZG1MXYhywkCfBoanVzFSnpBC9xa5Dtf3tfu6QAYv7V3U8dZ6z1PJ?=
 =?us-ascii?Q?kXHB96C+gqonlbz/rRyIVQZtuZmqKJQluV4mdyJ+8HTcU7ESE2N77yCYXDI9?=
 =?us-ascii?Q?DAEoddZ0LMBxGnINsXCv01csUDsHyJeufDaI7nfhY94nV3wx+Va+TDOfUL6X?=
 =?us-ascii?Q?FreFQHtZcgbW5e4MHU6Byrf1Bl9LYnqIb4ZUry/Ny64+g0JS8+0yBnNo+aby?=
 =?us-ascii?Q?0xxGVcwuviko6QbgnVGmiKFG/6Cmrq/7NWDi6hyEoCEYckGtriAD1jECSe+V?=
 =?us-ascii?Q?VzmoDf6rF9pHGIy+THtypkndD4FYeZ+qBDBQjm71liN7aaCG1p5UZeehGenD?=
 =?us-ascii?Q?RjZ6mjw4IZDcXV6RnM9VxCAgq87PpZpVsKj794AbkUDSqJ4n9edO7lGaj37w?=
 =?us-ascii?Q?KEsJXkwXv4esb1ceEZxNqbV2d9h/DXP1ZYsepuH/WhPLIDYpDBLtcb5i9LxJ?=
 =?us-ascii?Q?dnJrd/nly1Rmno4TPdOaJcd82sKkQcg9InZoCetxkUQ+POFAFdglTp0H+WQd?=
 =?us-ascii?Q?jJBQdp6G4rtLLdUDCCfN29T9KqfzS8lnJH60taqgdWVA+W2TJnj3asHcVbGO?=
 =?us-ascii?Q?5yInY0rJvH64r81zJh4Dwr8qdw2wNRr/cYLQKHC0+wSuFlJJ+EVMVB0TDgWj?=
 =?us-ascii?Q?/E+nALTldDF2wPJ2FcdI2FGkZKUQLy8MNnLgWd6VD+HnfwI4GQS9iS5O2Cnu?=
 =?us-ascii?Q?sXyDk0X0zORxQ5Jpss6PzyzKZJNYil7AvpTwKPItdYWrvdFHzL5mZquDG9zm?=
 =?us-ascii?Q?OXcPGvARn755xrgcJWgp4FGOtxZGu8nuT8b57QjIaxaN36Iuec+sGMWmWDxf?=
 =?us-ascii?Q?lXOjK7u2TgJa1Wec4q7KpReyjtKL9V8Z+aenQY5VUOU2yAYIwohedjUorG89?=
 =?us-ascii?Q?VlyLfXK14ujjm+4A2oLA2CDOFX5IDbRXsWZT8SAHtRXuhnEQhMgUf7Na0Zbq?=
 =?us-ascii?Q?8C7S2imNeLlzIIpXVt+kRyZnI8JQ4hMy8u5ctMsgtSzM49T/1KpTLMklPTHn?=
 =?us-ascii?Q?ZgNbbx7RuCQdpXSwV82GQIRTe9v15lZtwxOfCTE9pRZpTv5OG52E08d4MWXe?=
 =?us-ascii?Q?h8In3QLXODL+TN7dl8oJYQI6y9MpG++LsT6jbhQQKuW8L7T6lHKDfHOHcC3k?=
 =?us-ascii?Q?XXAIGjdZWD7uhiXRYx04te5Rw2ZB3rnI1eoE5qVWri+LPSm2qH96Rw89LK0P?=
 =?us-ascii?Q?eOhjie1W081b952A15BYwnrDTnhes/RfQ1G0fO33QyDo0EfPIvhWSnFE8CL0?=
 =?us-ascii?Q?/2KwgfCfFrNrxZkZejan/jB9opkoI5ljg807E3xYgFFg9yGRtqleISl+k3GV?=
 =?us-ascii?Q?QXmelby5+Zmv4fHBYk59UTrbbQGeLY47hpnahNBhC8S+P/tcAXWCK9IWdpoz?=
 =?us-ascii?Q?OIhO9fNs3p/ZnhyQ8ST58gbHLCpa7d86AEAAMTFaxvxVZ1g9aMuZGnxOEl5a?=
 =?us-ascii?Q?Qdyi9O4qbBnU+ZQO3X3BJDpQHBm3WDDN2kVeIiiZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c44dbd4b-e9c8-4321-2914-08da8b8da223
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 20:16:05.5564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ps4TyN4amIsWqopNovLRseTFuTaifuOXMVEoG/wzRPXaWz5/T/m0g4gbps2Bv5Q5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Done mechanically with:

 $ git clang-format-14 -i --lines 675:1210 drivers/vfio/pci/vfio_pci_core.c

And manually reflow the multi-line comments clang-format doesn't fix.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 711 +++++++++++++++----------------
 1 file changed, 349 insertions(+), 362 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 85b9720e77d284..8bff8ab5e807b9 100644
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

