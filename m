Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BEF5A300E
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 21:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243808AbiHZTeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 15:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiHZTeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 15:34:12 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A32E0969;
        Fri, 26 Aug 2022 12:34:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+Ya5DOMeCrvMNfkuYcx8e7nKRPnLctMzCGqBsy+atvTO/4D/x7Q2e+XIe9fXv1quw9FwCY9h8GkoTpnaUOZeodFwdfpOErAvmON4ycwNJ/gTLL5Sz78TFPiuwaOiEbZGU+0BwVeulsM5oU+FQ7ezQp4Z3PoNs2+02uIh3CnHJ5rvpWTDta6++ujZgbrb2QiobNWdnWgN5cD4v3ughrLngyShvW9uDOPykhMMsJkU4Q5nnMf38Vsa3yRHla+9PojyxuOcE8RfpAIQ4SYz/wrmQZZWItC47aOu8xKA3XHXokNMtnCQ88UFvvCWmm2jlEH/0ApHujcY93EWebSVXPppg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jUULXkMkkaHiLs140eO40la1EEb6DlV0T639QbuzlsM=;
 b=DFmGiYMfHE2lge+5u0Xs4kde+H9OE7B6mVsyEdhBXSCIgxomMF46xXr/ESejCBDOERHP7ThXIoHqezahMepSvERXQ24KGCl9Wo4X5FgYMmG+NiCxx3MuGX6AnzDqEIjaVbAD1nIAT9a9j2wE6tgkYcziwqF/tpey9kMj+I/afy7DngJGL7F1AqA6pMTD/dC11Vc0dW/wAfmhjsLcyZXWw0IR0du6pbmtIF2wfHMwrCcJx4gJsq5uY6lFd+ORcw/nAlMVVAiwSCfO+J6f8L/DM8DOm82nOmb8MqvSEqDha9HYuV5jRqwFOnHoIf+nD/lBLOfG1JS30gjwjE5dg2Z9gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUULXkMkkaHiLs140eO40la1EEb6DlV0T639QbuzlsM=;
 b=lZP6eqECXnowk1BxlIyHhWBrgTTXqVDwKGyZs+GjrLizCX8dyp7nxajLg/v8vnI1Ik8Xu5ew8vpBPPuYoIjkyrSeRqbBvgn4Xa1iHF2+FLSWCbEJrGttr4KE1n/L+Jo/qOavPvgkYOTC9QCyThLO9csOmYLOpuqhzpSSRbeuMrzPy0y4tkUPiHVX6+5dfaF+hlb1MV9p+v2MHcpI5pIE1DjVwh/4NTfNk+UvrtXtG2ozVsVJfmnzCo0UQ4X8F1o5Kf33onbSaj2yw12xH9Znb5UBf5iMYDg8/ZnwTZ/vBI3R5qlEwwthCHMBqoL6lg7gEhLAocCvcPBNGPmy0FMqZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1803.namprd12.prod.outlook.com (2603:10b6:3:10d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Fri, 26 Aug
 2022 19:34:04 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 19:34:04 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 2/3] vfio/pci: Rename vfio_pci_register_dev_region()
Date:   Fri, 26 Aug 2022 16:34:02 -0300
Message-Id: <2-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
In-Reply-To: <0-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0040.namprd02.prod.outlook.com
 (2603:10b6:207:3d::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a8e9436-3876-43f0-bb3a-08da8799ef3a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1803:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YoSibgeOPtgvS/4E1kj8pyaXdMjnTfSdtxn0NA14H0rPjrBZNBhsHHG6CANqtKsctz4g6vm5ePLnUW/gbFh5VxFRbKZQp574m1PgF1sicBFqDUF8l7H2qJxYxZ/stV0NWDIbIGXWENuG1A1IwhYBK8upzN+LFTlGdAdH8NOf9McU8iLlgKlz1jmsBNgkRrqNdKg9rra5GowTaV1Ob9YmdjsEtStQFfJC+D4D7HncKQCXmbSDBEJMf9wM/RJ9Dbf1Qdd4Og98xVSCj0Mc2R5DQ71EVkpZc4dvWj9hLYjTV9gPYYsHsqTsw91IrJeWzge7k38LJuQdKp65cZy204lkIguWj4eTx9S1/Hy3NxC3YJbd/CrVbv0BHgberH27L7+DHqGK5Bow35XrWM7KbWQV1EV7ZNizXDPOQSdyZrYl85MkkiKig4bGBAexcgSt1FhQ6H1yxwlgwiwj1cPpvwcEE+AfPTUa6sAuYGVkkSlxrSUunUWQFc3mwscD72UEh2q0IOgVlOBW5vWiX933GmoMik/ayosYgwBjWNQimhgMHopkhUjFDX+z4tVDje4BfMUBJ7okiwbf7xdFCOX9Zi/VRwAa0porVfrzBQpmtmSrXUtPIFBvxr1Ctxk/cH0AGdZg7+7y+kfeZnMQUul4rXoWvIFEPkkHgxJ1HOw67lfhpOtydRBm3XBRzWWMXClhiiVeflTJyuxZ/nZbNae94TnIF+N5MAgBQryrWZlX5LiYlgkwKYoZo/Ew7T1E5ojLbgHd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(8936002)(83380400001)(2906002)(478600001)(2616005)(6486002)(5660300002)(36756003)(66476007)(316002)(38100700002)(8676002)(66556008)(86362001)(110136005)(6512007)(186003)(41300700001)(26005)(66946007)(6506007)(4326008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PtmpEnIO1iHUtKmWIXjsFHoqbfdexwWhVg05qYCs7fN2B9H4xlqYz/2c/9NG?=
 =?us-ascii?Q?3JTmE2b7f9nXmfExX4XG/RCcTd2cFMCj7SqMJ+wCCVPDZ03xmimcQNqVT/kK?=
 =?us-ascii?Q?qGBCkNJZoOb9A5pr0p9AkY2lmyT1FPNtFAKLOP+kv82aDLFZMn9NrkPAOnP8?=
 =?us-ascii?Q?4iP6uodqxY3Gg3QFKYCEBWNCn9nBRNBOZCKp+WD/1EQCA+rKCVVTHhGsUPOr?=
 =?us-ascii?Q?ucA26aS5cveLkPK9DLDMtMs3Px8V+urs44Y49LHjCS3Kzg/wo4gGJ1un7Fak?=
 =?us-ascii?Q?V+Q3o/z9xYp11UKrjVWvmFADOUz0RQz56tUQfsvUO+28btrCMc9J6IoDl4Nh?=
 =?us-ascii?Q?OUJDP0o/cArQeSrMJoyTysqPy1aTjabz04ntWkqtmEw0t0jKwmJMcGuloipU?=
 =?us-ascii?Q?J16hFP+9m2rn48W4i16g+1GmTzHLFDv/FbMjK0tbUmwkttoC7zKhWLABtXFM?=
 =?us-ascii?Q?fcoQfTyA5yMpH47ivrtT3x6w8m9RBRu4TIKPSV591iidiYukRRV98DZdHsut?=
 =?us-ascii?Q?4WhQuAaCiGDt4HhS67s497kepeWwgDXTs9dqFGGuSk8KHkGLcfEIaZ4U/yl/?=
 =?us-ascii?Q?EbD5qa/X9XD9OoaTuBas0U1V9gTc1+MdCXW+Cr2UK594peVMVEaTIcJTslpr?=
 =?us-ascii?Q?k0PABA/BsYjcQop73aS/7sBgY/IOpzSgE4SKvkIetzmURuZMgLoSj1MdqXoS?=
 =?us-ascii?Q?FJakBngwjuCGg+pD/Tk3wwGXuwclQk6u2fEgUhNXT2wdubYZsOKQHm00QiUK?=
 =?us-ascii?Q?CpQ7PLg5sVgrWbL6ayyAnxW2GQ0djySm8VGqQMvP5ah1dpgHQf9vyRmRxaAz?=
 =?us-ascii?Q?zwhnmaMbv0FwTLvFS2zA8bSsAErcAR3zfS3PKK/dGTNZw4evQk4+2ztCoqYV?=
 =?us-ascii?Q?s0T5FRqJCZYt7Lt0TwQ1EFi7IyrlXKLTlpZ0M16CZPUKO8b8GTLjHPY25LTM?=
 =?us-ascii?Q?A/v51vqXVAAuHAM9Iv3qGR3BOJvHtgMdXHMh8jM0vxMvNyJ+OR7tLmPLXS0p?=
 =?us-ascii?Q?ZapK7Sy4AhmWMZNbGg6yv95D2D2OD10eg518mdf05Wkun/vMLg4m963/gCsq?=
 =?us-ascii?Q?IpG7S162P6SYvr6uiFVmqOZ8uO9iuk4gTwufx9nDy/omZ/d+1lPdGFS+PX69?=
 =?us-ascii?Q?T0lyVLXm+XWF8CtV7COSdX4k43IDRlFkDN16OMy2tL/usqgFJKrehP3xyUbR?=
 =?us-ascii?Q?VHZWj0z4FLRv5Ve8gy5VG/oQ4itqA8I4PkQyFqwsB0531z84CKWVzdnnI4lY?=
 =?us-ascii?Q?8jhXRQZiToHvI4oWlcZaEJYa4oAKpL9PGl1W5MGytwYF9UQIGlz5ihdDQ+U8?=
 =?us-ascii?Q?sOUIQ2zwB111yyM6jcJ77fB3mtCKpKEsa/q5/M0v4zaKW2h5mId+UJ2odFy2?=
 =?us-ascii?Q?vDf34rjdWYfpLOJRkj5LoaK50odWWR9Dvt8Z9owslRoVNBxq7dIGY7dHGX1H?=
 =?us-ascii?Q?Bw4RdR47NloP7AuHsvdgTUkgKGaTnXpT/+Y0YOss77Vq76q6l4SN+RE3LrQa?=
 =?us-ascii?Q?HtgnsrSsXmBvTWtkibPmGFpdfWe5dGJdUj6dYRXcO8Bc+WreJj5dYu5WJYOn?=
 =?us-ascii?Q?fm6N/Qz3rU7/NyqjKujq2ZbmSKW75MNqOvKJyo0r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a8e9436-3876-43f0-bb3a-08da8799ef3a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 19:34:04.2364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3n/dDuM/cnZssilf6ryiKWe2OPhknq7ocl4g1J0k8TrthkFPYo9Rvtwzu1BBZ7YL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1803
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As this is part of the vfio_pci_core component it should be called
vfio_pci_core_register_dev_region() like everything else exported from
this module.

Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 10 +++++-----
 drivers/vfio/pci/vfio_pci_igd.c  |  6 +++---
 include/linux/vfio_pci_core.h    |  8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 04180a0836cc90..84279b6941bc2a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -662,10 +662,10 @@ static int msix_mmappable_cap(struct vfio_pci_core_device *vdev,
 	return vfio_info_add_capability(caps, &header, sizeof(header));
 }
 
-int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
-				 unsigned int type, unsigned int subtype,
-				 const struct vfio_pci_regops *ops,
-				 size_t size, u32 flags, void *data)
+int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
+				      unsigned int type, unsigned int subtype,
+				      const struct vfio_pci_regops *ops,
+				      size_t size, u32 flags, void *data)
 {
 	struct vfio_pci_region *region;
 
@@ -687,7 +687,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
+EXPORT_SYMBOL_GPL(vfio_pci_core_register_dev_region);
 
 long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		unsigned long arg)
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 8177e9a1da3bfd..5e6ca592695485 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -257,7 +257,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_core_device *vdev)
 		}
 	}
 
-	ret = vfio_pci_register_dev_region(vdev,
+	ret = vfio_pci_core_register_dev_region(vdev,
 		PCI_VENDOR_ID_INTEL | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
 		VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION, &vfio_pci_igd_regops,
 		size, VFIO_REGION_INFO_FLAG_READ, opregionvbt);
@@ -402,7 +402,7 @@ static int vfio_pci_igd_cfg_init(struct vfio_pci_core_device *vdev)
 		return -EINVAL;
 	}
 
-	ret = vfio_pci_register_dev_region(vdev,
+	ret = vfio_pci_core_register_dev_region(vdev,
 		PCI_VENDOR_ID_INTEL | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
 		VFIO_REGION_SUBTYPE_INTEL_IGD_HOST_CFG,
 		&vfio_pci_igd_cfg_regops, host_bridge->cfg_size,
@@ -422,7 +422,7 @@ static int vfio_pci_igd_cfg_init(struct vfio_pci_core_device *vdev)
 		return -EINVAL;
 	}
 
-	ret = vfio_pci_register_dev_region(vdev,
+	ret = vfio_pci_core_register_dev_region(vdev,
 		PCI_VENDOR_ID_INTEL | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
 		VFIO_REGION_SUBTYPE_INTEL_IGD_LPC_CFG,
 		&vfio_pci_igd_cfg_regops, lpc_bridge->cfg_size,
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 9d18b832e61a0d..e5cf0d3313a694 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -96,10 +96,10 @@ struct vfio_pci_core_device {
 };
 
 /* Will be exported for vfio pci drivers usage */
-int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
-				 unsigned int type, unsigned int subtype,
-				 const struct vfio_pci_regops *ops,
-				 size_t size, u32 flags, void *data);
+int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
+				      unsigned int type, unsigned int subtype,
+				      const struct vfio_pci_regops *ops,
+				      size_t size, u32 flags, void *data);
 void vfio_pci_core_set_params(bool nointxmask, bool is_disable_vga,
 			      bool is_disable_idle_d3);
 void vfio_pci_core_close_device(struct vfio_device *core_vdev);
-- 
2.37.2

