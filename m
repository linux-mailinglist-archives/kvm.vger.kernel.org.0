Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CF862CC40
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239112AbiKPVHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239265AbiKPVHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:07:00 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45FE6B220
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:05:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpGUUZBJUSINHRhAkihpUtOdHxRqqj3xbtNLA0AfBYP1EMfqslvz4fR+gc7TFE9FbqouyQGKF0ocgYWwSLtZvDPIiGSg6EkozmBL2/+CMWf/hlxdCF4s6IA3D3GwAdm20t0XzYjCwSCp+lUEAXafm4S96+C1dAb3/vrSqz8V9hyaw++KQxoYoUtSbx5I3GYSPW36G/ZtYxnASNSRXoJx3v0wbOMcUl02gegjajJVkg9CReMM+fovQ/gt+emRmKptZ7O15/mr9I8EefE98EIIlJA40h2j/gvm3uEJ6MpwromH5CvfJTeWmvXqISL/HOzaes9EweTKlpfEvCED1A4sVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aNXg2AABRxcJSYbY2k2DdJqS6gRhPl/USuFdIcRKX20=;
 b=W1LkMIwd0hJ/2jR+o1UuFFAgbnuyZ248BNH6ZtI3iI6j7mpbj9dojzfpTWxZ7wF4Sb66d5u35iJBtAliprZB4vSupjRSLwDEsjAIAQyvaPDG3QfVZtLmF5XZnTIJ3HdAR37SYbdRr35Bs2iolpixe+1PdPVSqL8PitMLHqlOY0mKaOvFRWln0oyLuLzWeC1FxjVDHRDMDftBSvDg7zMxi4WAevZaaksLSz+TtQv6rsowrpEWYx4P95Ir8uXyokQ0q1QyBnnRKkHCdIcIhRIBtcvoRHGpOJsIgrTb59KmPhfX/zzoOLJKPYDE7FolCXyeWstCccNnBVA3aU2r+o1gVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNXg2AABRxcJSYbY2k2DdJqS6gRhPl/USuFdIcRKX20=;
 b=hM3xQlKToDJ9Gd4sNBup4rrfOibcApFkA72uAB0yUnpSlDb1FP9PMO6j5wUSIhy443GMR9DG6hiOOpdGK5KX2Ed9SDVwmKSOxi+WNJyvrfp4Lq5hVZ6Tkj2RUsmH7WYe2E3eJedcDVHxKhwMbeeC7CZFUHr9tTlwYsB0e/+lHOG1C8XZtcNJb76eFKz4RH/9cQ4DCcTSywZU66WA1cNc/2IIr1F6Igb9M10sMBQVOAZjFNtGy1vX6ndIwLc8t0CSqjNfazsw19xilOQMb3UjXL2R7BO2mLfLm5ZYNn0Q2q8+aRxbaNBMppNFiw2HvHiang2zrGYvad+dwqs0t6pH4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 21:05:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 21:05:45 +0000
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
Subject: [PATCH v3 10/11] vfio: Make vfio_container optionally compiled
Date:   Wed, 16 Nov 2022 17:05:35 -0400
Message-Id: <10-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0019.namprd19.prod.outlook.com
 (2603:10b6:208:178::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b14a676-e19d-4dab-01ca-08dac816508f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VbEXQfdorzAYh9yc9gOPfBu7Tn9dXvR+cke3gPeL+gF8Nnxy6AApe1e+yRpM7S3Vy7+nsw2Ipe9bzR4+YmkCfBeFG3WNntbh4yI1Ia/AMm6U6/DyIZbz0uaoaUuyN3niKaXIsZOOPQpaYf/SPbKuhCeyxGeoiBgG8o7U88MZkAK3fl5S762ERoOwAx7u+iQNF+32w9mwk0JyJ3VdQNPGR8OcSC48aRXzyRAsuahiTK44vBBLOQcFQe+jsoMXmuvKzKd+gTNrZR9Evbd9G+V6Bxx0gBjuXeeHSWcl1/QL+P3jc9FPoQfQHZEn43XPqoTuIlrCvSYK9rXNfPMMkb4LCiWu/vvHuicrrVzh9jJNC94McZoh5j1sEv9UQUKOuWT1OlIp/MVzr6GXtzIGDPJKB00VFysv3qf3LawehLjrr/ZEscTB9GvTgtTnn9kJHy9J13zfEw5RRdvjaodLT4r7JY/8UYgf4fMeo2VYfvZVnBFZvYdvaWEtadTb1Kenj/mCjOHnTJ6R2coj0Hqq0hTOHrKftQFrLZh/lDXS+gn8ZSM5iw0zZ3UgyBse7s/Xmx9kUrQSh8yWWPcMZP+IILXqoxnnehKGzIs77aZJM3EIycK1aMjOR+qXsE4AjsFFuodwp+aSBf7IgjI9rUtZN50uEMSfYn1/XKc9/twOMHCj1HMegTgNBf+gfmzAwvSlyy5btBo7ulDBXjHKekyLrcOjKvxbPB8rgYa3VAn7kim5TvH+/LVuNkNLGrNZQ1repeer
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(109986013)(86362001)(36756003)(38100700002)(54906003)(316002)(6506007)(6486002)(478600001)(2906002)(5660300002)(7416002)(186003)(2616005)(6666004)(8936002)(66556008)(4326008)(66476007)(66946007)(83380400001)(6512007)(41300700001)(26005)(8676002)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qKRoXv7D/S21WVCstrpSg19AmnZ2uJkjEaGt38ODS6EbBPW5pNkDcURxOzDc?=
 =?us-ascii?Q?RGqZmanyMI6Tt6tYAUtNq5FN4G1uMPkb4nYKXWlqIqFaw9oM7TTK1PhfZWal?=
 =?us-ascii?Q?B0u1f7puT8Mo7xQ/9EVGzmQ1LQSz3P/Od1Z1ZKAZoRg+096y9UWd0ipZsoSL?=
 =?us-ascii?Q?6V0K4r86hs0TH+oknjx2lZowfhHx7073W1Yig9+8tZI56DYmQUWqfFCY5bOS?=
 =?us-ascii?Q?V97xwJ52z5eJzuZggCL2ZxEMJniiDEujW03zfT/qAVzFDBgUCxwJx1UBKonh?=
 =?us-ascii?Q?MwBHE0rxRnddSYbdfeZ/8oANV/OMV7DTdzEJIeb0CU7453YhQ8Ui7RWUxdjM?=
 =?us-ascii?Q?K8AsVYKX0hN9wAFymBEe9SbrMoCaJr+vuYGafPLT5irUzxHiX7U8pxGNiEVB?=
 =?us-ascii?Q?V/IorKtMnk9OXEQAjoowhvnuG84HT6hKYzfVft5t1zQbNGJMgYlXlo125+/n?=
 =?us-ascii?Q?97sSBVx57LFlXDkgDr0L3QS/HZ3qCjpyDFr+7DK3YDyA1GVsbUyIGj+4k2Xr?=
 =?us-ascii?Q?Cpvub8yFDkLVkzvJ0vhPWZOHH2tONNctCUANFSQ6HiQzk7dvabBW/vfueNme?=
 =?us-ascii?Q?vLlUln+Oe+ztSJMimqEXsyJ5KQLLBmR1zRS1Qz3rekWeYkWG4DD3P/fj0qqH?=
 =?us-ascii?Q?fgVZwgBRd9RMisBufNfNQgVHG/nLB0Yhbo7OaESPCnPg3MZaVfKpKsbJoRhV?=
 =?us-ascii?Q?64cbvRIkB/Jb1srv+Wj8Mk2X0Yg4eqr5+qPgW07NuWG1MLFmckDidN3cHHaA?=
 =?us-ascii?Q?Dqt3BW8qxSfQpU37l2v0ICdTHHdDkguItHGP6oogn647Aidza3I1EQh/eHmp?=
 =?us-ascii?Q?53bd1n0LE2Xgo0OeRcbXCeyghiQP6Byc25t91ZXlleRGwpNw7A4jBy6demNL?=
 =?us-ascii?Q?UZjrkmW/nXar+VtpkV2aBZwq7ENuOBCIyMP70ni2HsVTduCxPoNXgjN+NfSc?=
 =?us-ascii?Q?BzUIEiC3mMcAbiPRiz/aM8CsSQ0DXenSjbHeftkGhiriFai611xRCWGRzsi7?=
 =?us-ascii?Q?F5OZWTENCW5j9jVpHrr4im6vChT1UB4xBO8mLmAA/x/RgrqwDeR0xWMXHqA0?=
 =?us-ascii?Q?wPOqnzBaMZDbkt8eq831FLhz/shzf8o0jsQVzstf8ofv1C4nYAlyRw2Y+LCj?=
 =?us-ascii?Q?hUeSOW6QORISRPr8WhtAWj2iWDwTJlApcOJO4MkKegOQtemR+KlDS1gzdUNS?=
 =?us-ascii?Q?pMheH1DtcT6jaPDZave5zd3wJ+/5kv500tNnLZjeDZubgbGdMmhCVZl2yRT5?=
 =?us-ascii?Q?3sv20/k0T0s3uYFf9VQtQvKYb1zG85W3pTQ9SI9HSzUp4jgumoL3IrzVhcLv?=
 =?us-ascii?Q?EjPqXaiFHiZWhop6vFmwGCvsi4xlaldYqdWuokk8FYGYawwRq6T63Q/FEmfY?=
 =?us-ascii?Q?AUWrigtE66Mar7I37jpKSfgijCyrYsHf8Pjc67z4Op+KhS0c1RZhPErahJ20?=
 =?us-ascii?Q?A89g+HC31PJVMXLvVzkUDI+EXpVkCLBqgcOaRnF/znnHbnkqrUxzY/rC3yUV?=
 =?us-ascii?Q?+qANhTvXUbPHF6iOzwsI31Iemmnlj3wLWtXHs/Fo6CeTspid4Z5enKEJYV5b?=
 =?us-ascii?Q?QHmuGecGNx+pDmkyUsc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b14a676-e19d-4dab-01ca-08dac816508f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:05:39.4137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V4Xsy3T37wg1xfTZG1BxiMSvcDWDWlMB569iFicOoocoCZrOvsCHC2siXFK1+wKF
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

Add a kconfig CONFIG_VFIO_CONTAINER that controls compiling the container
code. If 'n' then only iommufd will provide the container service. All the
support for vfio iommu drivers, including type1, will not be built.

This allows a compilation check that no inappropriate dependencies between
the device/group and container have been created.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Kconfig  | 35 +++++++++++++++--------
 drivers/vfio/Makefile |  4 +--
 drivers/vfio/vfio.h   | 65 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 1118d322eec97d..286c1663bd7564 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -3,8 +3,8 @@ menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	select IOMMU_API
 	depends on IOMMUFD || !IOMMUFD
-	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
 	select INTERVAL_TREE
+	select VFIO_CONTAINER if IOMMUFD=n
 	help
 	  VFIO provides a framework for secure userspace device drivers.
 	  See Documentation/driver-api/vfio.rst for more details.
@@ -12,6 +12,18 @@ menuconfig VFIO
 	  If you don't know what to do here, say N.
 
 if VFIO
+config VFIO_CONTAINER
+	bool "Support for the VFIO container /dev/vfio/vfio"
+	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
+	default y
+	help
+	  The VFIO container is the classic interface to VFIO for establishing
+	  IOMMU mappings. If N is selected here then IOMMUFD must be used to
+	  manage the mappings.
+
+	  Unless testing IOMMUFD say Y here.
+
+if VFIO_CONTAINER
 config VFIO_IOMMU_TYPE1
 	tristate
 	default n
@@ -21,16 +33,6 @@ config VFIO_IOMMU_SPAPR_TCE
 	depends on SPAPR_TCE_IOMMU
 	default VFIO
 
-config VFIO_SPAPR_EEH
-	tristate
-	depends on EEH && VFIO_IOMMU_SPAPR_TCE
-	default VFIO
-
-config VFIO_VIRQFD
-	tristate
-	select EVENTFD
-	default n
-
 config VFIO_NOIOMMU
 	bool "VFIO No-IOMMU support"
 	help
@@ -44,6 +46,17 @@ config VFIO_NOIOMMU
 	  this mode since there is no IOMMU to provide DMA translation.
 
 	  If you don't know what to do here, say N.
+endif
+
+config VFIO_SPAPR_EEH
+	tristate
+	depends on EEH && VFIO_IOMMU_SPAPR_TCE
+	default VFIO
+
+config VFIO_VIRQFD
+	tristate
+	select EVENTFD
+	default n
 
 source "drivers/vfio/pci/Kconfig"
 source "drivers/vfio/platform/Kconfig"
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 3863922529ef20..b953517dc70f99 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -4,9 +4,9 @@ vfio_virqfd-y := virqfd.o
 obj-$(CONFIG_VFIO) += vfio.o
 
 vfio-y += vfio_main.o \
-	  iova_bitmap.o \
-	  container.o
+	  iova_bitmap.o
 vfio-$(CONFIG_IOMMUFD) += iommufd.o
+vfio-$(CONFIG_VFIO_CONTAINER) += container.o
 
 obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index d57a08afb5cf5c..3378714a746274 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -55,7 +55,9 @@ struct vfio_group {
 	struct list_head		device_list;
 	struct mutex			device_lock;
 	struct list_head		vfio_next;
+#if IS_ENABLED(CONFIG_VFIO_CONTAINER)
 	struct list_head		container_next;
+#endif
 	enum vfio_group_type		type;
 	struct mutex			group_lock;
 	struct kvm			*kvm;
@@ -64,6 +66,7 @@ struct vfio_group {
 	struct iommufd_ctx		*iommufd;
 };
 
+#if IS_ENABLED(CONFIG_VFIO_CONTAINER)
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {
 	VFIO_IOMMU_CONTAINER_CLOSE = 0,
@@ -129,6 +132,68 @@ int vfio_container_dma_rw(struct vfio_container *container, dma_addr_t iova,
 
 int __init vfio_container_init(void);
 void vfio_container_cleanup(void);
+#else
+static inline struct vfio_container *
+vfio_container_from_file(struct file *filep)
+{
+	return NULL;
+}
+
+static inline int vfio_group_use_container(struct vfio_group *group)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void vfio_group_unuse_container(struct vfio_group *group)
+{
+}
+
+static inline int vfio_container_attach_group(struct vfio_container *container,
+					      struct vfio_group *group)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void vfio_group_detach_container(struct vfio_group *group)
+{
+}
+
+static inline void vfio_device_container_register(struct vfio_device *device)
+{
+}
+
+static inline void vfio_device_container_unregister(struct vfio_device *device)
+{
+}
+
+static inline int vfio_container_pin_pages(struct vfio_container *container,
+					   struct iommu_group *iommu_group,
+					   dma_addr_t iova, int npage, int prot,
+					   struct page **pages)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void vfio_container_unpin_pages(struct vfio_container *container,
+					      dma_addr_t iova, int npage)
+{
+}
+
+static inline int vfio_container_dma_rw(struct vfio_container *container,
+					dma_addr_t iova, void *data, size_t len,
+					bool write)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int vfio_container_init(void)
+{
+	return 0;
+}
+static inline void vfio_container_cleanup(void)
+{
+}
+#endif
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
 int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
-- 
2.38.1

