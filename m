Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D6A63C941
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbiK2UaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbiK2U35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:29:57 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D13963B97
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:29:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rb43X7FzzfBggUfF1DqvpPf3AxTGDXvZdFuxpj/ByNuXdEVFv2X5KQiAhCixTKDTVIGOWyia6IKxy3LK4O/BLx5bNrZB9nr2jb2S+cb92rb+7RFtqBekjwqnJ6Z1lEHzqt1MaDlESJwy8cvvoiFEblYegZz3/Kaq5YPamBXTIl+Bt2LhwQdoADJOczsOL4wMVl/3Rzim2XMOHTSrHblNSWwjhEBmB7fj+V4+vPxaSNWU+SUFmBoH5O3JCjZuhUfVH2YLd4Vt9ukxr9eZ6POnd74RY8HsyMptFq95PrbMtU/N/310wMUMGvW4SvT1lMmu/jD7L5N4f0havnCCliCf4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+NTJNKoCSKbDRQaTbdce6HfwYbSAKvDi6EQHainO3mE=;
 b=L80RXk9ElshP2SorNHJfp0hGKULefz4899WL03aWW7vTrQaLH9FCjR99WVeY9lBp72xYpPGELH3FMhoI04hzUrs/CnEmOCsUFYA/nkWPKfad+ogURVqd3J0rlJGjUc3VbIT/ZceS5/YR7UXHf78CJts1jdLBGMDq5FjPgHajrZaATL9eTUYBWGMk7w21lrqrRWACdVadyvLehZV6l7sI2aW5o1iXaEA/1vxBS6EeueaDq95l1EDzEUV7iKSUqsLWV9IBZQKSJxlT+UCUPp6gCd8/t3eEIaAOEDZmFRKetHQtejJ7b/rG38R6cLybYsITBl6hyVLgoP+1NLDbkMbSsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NTJNKoCSKbDRQaTbdce6HfwYbSAKvDi6EQHainO3mE=;
 b=lXfrAvwv3oIu/jWzHjEkUfSBIuC6Zi/BnZV6/Q8+hlp3mG6OQgTkLPeV2BoduXqeeGRTuVhPOHHhnVapyGPMm85rMXm8KBz0dJWqraqFNqQggsnruknlhMkXJwByNXXyShdyFv3tyy+GOtt9LrRmFeSo+HXEtKibmprVTI71Pid0ctKYGqgfhobPhaP+inuXYm6u1vLyhk85BwU8K6MgxGQSGnlsoY8B3V1amXNPctd1v86A0OUNVTp06+ZI82WPcOCgviPkyGue5nhdNqa1HisJZJgCFAJQ1maayuTBqkj+MTQg/YmkZLS8IzSiy1mm/9vK+hBwBw3y8ouKzrIb/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6796.namprd12.prod.outlook.com (2603:10b6:510:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:48 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v6 09/19] iommufd: Algorithms for PFN storage
Date:   Tue, 29 Nov 2022 16:29:32 -0400
Message-Id: <9-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:334::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6796:EE_
X-MS-Office365-Filtering-Correlation-Id: 55ac6dfa-7bc3-4f87-c64b-08dad24873e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HajPg8KH6XU7/33EjYNBIwxS19BDCOKSWDE2RYxElJiVAGd91h4+hXouJP2GIALUxO/F6qjorLboJ7eJJOiSTYhf3xSO/uOAxlcmwfCfuCDGmr/FmF1v8xTuDFZRbI0gd+QmXBnbCYKYAMz6+++vb97tLO8zaRtPPppSYCBU07pJw+jsFmIG1awREPFu+Ao3VlmabulzWgwqVWWAlhSY0C8tHOlqZaGc7dYiE2wwE8PkZsKlR67uJk+yAqtu3/3XPDxDpKPDs6VPQ2jPAaLopYvsNPouOBNAfoOqn8Fq8+VRoCWUf6KrsQ7Bb8qCmCnO+ujUfHPReOKfBTYmUN7tSXR5ETBqZlZI+1eC9DWk3fZzr/gxm005+ZOYUULcvx5HzziNryA6+hxroBrLRqgBjH38Cwfmm6TulWFgFbZ9h9SY/j//IQfEb80LGEh+hsM8qJPPxKjdBaoes5IBl6MCxTYc1EGrlJc5FwbaWQjFxsvdEkUGadvEh+/7c737h9CR14UxPnLkm2vMf3BpdVzj7QTwrnhQmT6KtdXeIrVmmmkVbqM2D8bl9qJViH8EXdar92jl4ro7M9v+4fGwiA7royHOb+Ftd1qb84twco3wvscLtnBYLm2vLoXxFbaTMrVC+F9c1mxbY2+DpiECY/F7fdmWKoAC0Bhs/wTy423Bi7SiS5r0ehGe0BOGnC/OC/psHM50EFxvV78lnPv0oP/hgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(451199015)(109986013)(2616005)(186003)(54906003)(316002)(6486002)(36756003)(86362001)(38100700002)(26005)(83380400001)(6666004)(6506007)(6512007)(30864003)(478600001)(7416002)(8676002)(41300700001)(2906002)(8936002)(66946007)(66476007)(66556008)(5660300002)(4326008)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eKVD8ytqPNx32rcdwCW80Brh/+KbVMPrIeL+O7QYjhNpCNP3rrPOhQWAvo69?=
 =?us-ascii?Q?JOwU1hEYPf+x7GU9V5QY7p5YLo1T6Yxn65G3ei1B76aeSbCZbqORSNFIS+gK?=
 =?us-ascii?Q?njqf5U1RqMOp8lHlI2xeSvQDG700eVteR5zmOPuK2B+ZyjVw0/DfDV8aBFBc?=
 =?us-ascii?Q?duMcDaxhiBio30Ruxs4DsbxqsadtcyNL2tcHWw6/aNRS+bLoOZviznew3zPu?=
 =?us-ascii?Q?wBi0RZ2LwjoYD7k//YdFaiK5Rvi2vX6hJ1WJ8uSmRpIaMI22q7fpb7JnJ0fi?=
 =?us-ascii?Q?Rrk0o+TGHRuCcV/4uhuiIAOthAxcdQRCxBoxfvEp9ofiCFzqwLdP8bBa6d+0?=
 =?us-ascii?Q?RWRrneH+el7WvHKu+qFg3ct9VzhQg/csL1tzY4Izcd28CfMqzjvm+8H2sUTY?=
 =?us-ascii?Q?FUSAaCYdpeDxrDGQeP5hnRLB513mf+tPPCYQLLObGXkgsG6andBLq751Hw8y?=
 =?us-ascii?Q?NIfsDRAlaM/3KmrQiOXvGG2yixjf/xg4N2cTdoGlbFjonkv7OCf9wlYeWESc?=
 =?us-ascii?Q?4Q4+CXIMQcECaO6DqXZsQ0jzJq8Vk4cfKC/nO4SRRuKbiMqFoNGaxqTOBUid?=
 =?us-ascii?Q?kEkQf2bpoLAyWK1ssmQVPfUHzvydRUDGCvUiDiGY655qW98cNKU6rWEnT5jc?=
 =?us-ascii?Q?NbJbzLJ2Ko7ovlZ+F4Hw1W3tA8qFXPZ4eFnT4LKqMdfwJcGnnntxWOAdb5Xr?=
 =?us-ascii?Q?XtM3ZY7CKig+naRJ71EskrvCWszDv5Ehe9giwht6cUaJ0xpbWGM1qbFxw7gb?=
 =?us-ascii?Q?hnB20XuH3+ILr/4C3QMOIYdfwDww9ANo1+axHsB1ziPTCufOTr0s7gdEd+9r?=
 =?us-ascii?Q?aMavT/eSGz0u6M38Sw6/w51PHoNeb8+/AxU8axKZ37KDZUxTTpAiAWLDN1A3?=
 =?us-ascii?Q?TiuCHCh/rKfvR5lJYLjAQYVDnKpNZKH9BYRbi4/HtoCeNLdteD1pyVS1A8/X?=
 =?us-ascii?Q?/gX1DJ283lisPVZHAvYZWGNWVf2PyJPvnJsAA7RHIDYfiL/4wePDJn0Ho/Db?=
 =?us-ascii?Q?LCUbrri/YrcwPdPirj2hqpW6gy+lcj9rUCM/u7mMfMSdcg0QaNe5eT5cbaKO?=
 =?us-ascii?Q?r/NjR7tF/tbaz+QE13oSl5/HzOA6oJ1ql+itDHcv6GXiSy5ptmbz7KPLjWsw?=
 =?us-ascii?Q?60nzJrmuZdH7TKMnEpGp8heRdq0zLw+BkXpZ8rlZ0YcuKbLzvwedL36aPVGA?=
 =?us-ascii?Q?sgV/RqWVmwqDkZTEDjJj6R1m5oA6Unph+nuK0h5bISCYaCDF695ZWVpeTkVp?=
 =?us-ascii?Q?YtV/QDEAsKqJviw2G23N9iv7SFwVe2OhhjkEmAC0WqOdEJF7qvE+TChNcXyd?=
 =?us-ascii?Q?eHYye4kwVJPa2eK77lzVT4GvWqDdkcE/2/tJ8Jzjd0i0MAFCgnON8JFM3YV2?=
 =?us-ascii?Q?mXjiv2RnemOuvLlq2o52czd0yuTPnJpfdLVeCRrKpWJ6Ztx4rCroCHvjoGRc?=
 =?us-ascii?Q?FuArt767VdiR8i+j6/L+Xh0s45bSyJ0Leynu64VeXneuX4c+nPef2KzIh/3m?=
 =?us-ascii?Q?MZ8fc12VsFwMqH30JKR6x6eSyTXiqkbKrI5rVc2G7kjWARRKXSMacVtlqwBF?=
 =?us-ascii?Q?hi0TqjcOwVWnRoIz30CRrKVABrRY9L7n9loYMuVm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55ac6dfa-7bc3-4f87-c64b-08dad24873e0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:45.6666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /5NkkKh/yugHmSpH7dh6rhG5LJiTz1iaMAH7MdbfxotYKpZFhSGrMG2HnjZlvfmK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6796
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

The iopt_pages which represents a logical linear list of full PFNs held in
different storage tiers. Each area points to a slice of exactly one
iopt_pages, and each iopt_pages can have multiple areas and accesses.

The three storage tiers are managed to meet these objectives:

 - If no iommu_domain or in-kerenel access exists then minimal memory
   should be consumed by iomufd
 - If a page has been pinned then an iopt_pages will not pin it again
 - If an in-kernel access exists then the xarray must provide the backing
   storage to avoid allocations on domain removals
 - Otherwise any iommu_domain will be used for storage

In a common configuration with only an iommu_domain the iopt_pages does
not allocate significant memory itself.

The external interface for pages has several logical operations:

  iopt_area_fill_domain() will load the PFNs from storage into a single
  domain. This is used when attaching a new domain to an existing IOAS.

  iopt_area_fill_domains() will load the PFNs from storage into multiple
  domains. This is used when creating a new IOVA map in an existing IOAS

  iopt_pages_add_access() creates an iopt_pages_access that tracks an
  in-kernel access of PFNs. This is some external driver that might be
  accessing the IOVA using the CPU, or programming PFNs with the DMA
  API. ie a VFIO mdev.

  iopt_pages_rw_access() directly perform a memcpy on the PFNs, without
  the overhead of iopt_pages_add_access()

  iopt_pages_fill_xarray() will load PFNs into the xarray and return a
  'struct page *' array. It is used by iopt_pages_access's to extract PFNs
  for in-kernel use. iopt_pages_fill_from_xarray() is a fast path when it
  is known the xarray is already filled.

As an iopt_pages can be referred to in slices by many areas and accesses
it uses interval trees to keep track of which storage tiers currently hold
the PFNs. On a page-by-page basis any request for a PFN will be satisfied
from one of the storage tiers and the PFN copied to target domain/array.

Unfill actions are similar, on a page by page basis domains are unmapped,
xarray entries freed or struct pages fully put back.

Significant complexity is required to fully optimize all of these data
motions. The implementation calculates the largest consecutive range of
same-storage indexes and operates in blocks. The accumulation of PFNs
always generates the largest contiguous PFN range possible to optimize and
this gathering can cross storage tier boundaries. For cases like 'fill
domains' care is taken to avoid duplicated work and PFNs are read once and
pushed into all domains.

The map/unmap interaction with the iommu_domain always works in contiguous
PFN blocks. The implementation does not require or benefit from any
split/merge optimization in the iommu_domain driver.

This design suggests several possible improvements in the IOMMU API that
would greatly help performance, particularly a way for the driver to map
and read the pfns lists instead of working with one driver call per page
to read, and one driver call per contiguous range to store.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/io_pagetable.h |  74 +++
 drivers/iommu/iommufd/pages.c        | 843 +++++++++++++++++++++++++++
 2 files changed, 917 insertions(+)

diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index b74bf01ffc52c2..a2b724175057b0 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -49,6 +49,15 @@ struct iopt_area {
 	unsigned int num_accesses;
 };
 
+int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages);
+void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages);
+
+int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain);
+void iopt_area_unfill_domain(struct iopt_area *area, struct iopt_pages *pages,
+			     struct iommu_domain *domain);
+void iopt_area_unmap_domain(struct iopt_area *area,
+			    struct iommu_domain *domain);
+
 static inline unsigned long iopt_area_index(struct iopt_area *area)
 {
 	return area->pages_node.start;
@@ -69,6 +78,39 @@ static inline unsigned long iopt_area_last_iova(struct iopt_area *area)
 	return area->node.last;
 }
 
+static inline size_t iopt_area_length(struct iopt_area *area)
+{
+	return (area->node.last - area->node.start) + 1;
+}
+
+#define __make_iopt_iter(name)                                                 \
+	static inline struct iopt_##name *iopt_##name##_iter_first(            \
+		struct io_pagetable *iopt, unsigned long start,                \
+		unsigned long last)                                            \
+	{                                                                      \
+		struct interval_tree_node *node;                               \
+									       \
+		lockdep_assert_held(&iopt->iova_rwsem);                        \
+		node = interval_tree_iter_first(&iopt->name##_itree, start,    \
+						last);                         \
+		if (!node)                                                     \
+			return NULL;                                           \
+		return container_of(node, struct iopt_##name, node);           \
+	}                                                                      \
+	static inline struct iopt_##name *iopt_##name##_iter_next(             \
+		struct iopt_##name *last_node, unsigned long start,            \
+		unsigned long last)                                            \
+	{                                                                      \
+		struct interval_tree_node *node;                               \
+									       \
+		node = interval_tree_iter_next(&last_node->node, start, last); \
+		if (!node)                                                     \
+			return NULL;                                           \
+		return container_of(node, struct iopt_##name, node);           \
+	}
+
+__make_iopt_iter(area)
+
 enum {
 	IOPT_PAGES_ACCOUNT_NONE = 0,
 	IOPT_PAGES_ACCOUNT_USER = 1,
@@ -106,4 +148,36 @@ struct iopt_pages {
 	struct rb_root_cached domains_itree;
 };
 
+struct iopt_pages *iopt_alloc_pages(void __user *uptr, unsigned long length,
+				    bool writable);
+void iopt_release_pages(struct kref *kref);
+static inline void iopt_put_pages(struct iopt_pages *pages)
+{
+	kref_put(&pages->kref, iopt_release_pages);
+}
+
+void iopt_pages_fill_from_xarray(struct iopt_pages *pages, unsigned long start,
+				 unsigned long last, struct page **out_pages);
+int iopt_pages_fill_xarray(struct iopt_pages *pages, unsigned long start,
+			   unsigned long last, struct page **out_pages);
+void iopt_pages_unfill_xarray(struct iopt_pages *pages, unsigned long start,
+			      unsigned long last);
+
+int iopt_area_add_access(struct iopt_area *area, unsigned long start,
+			 unsigned long last, struct page **out_pages,
+			 unsigned int flags);
+void iopt_area_remove_access(struct iopt_area *area, unsigned long start,
+			    unsigned long last);
+int iopt_pages_rw_access(struct iopt_pages *pages, unsigned long start_byte,
+			 void *data, unsigned long length, unsigned int flags);
+
+/*
+ * Each interval represents an active iopt_access_pages(), it acts as an
+ * interval lock that keeps the PFNs pinned and stored in the xarray.
+ */
+struct iopt_pages_access {
+	struct interval_tree_node node;
+	unsigned int users;
+};
+
 #endif
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index ebca78e743c6f3..bafeee9d73e8ae 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -212,6 +212,18 @@ static void iommu_unmap_nofail(struct iommu_domain *domain, unsigned long iova,
 	WARN_ON(ret != size);
 }
 
+static void iopt_area_unmap_domain_range(struct iopt_area *area,
+					 struct iommu_domain *domain,
+					 unsigned long start_index,
+					 unsigned long last_index)
+{
+	unsigned long start_iova = iopt_area_index_to_iova(area, start_index);
+
+	iommu_unmap_nofail(domain, start_iova,
+			   iopt_area_index_to_iova_last(area, last_index) -
+				   start_iova + 1);
+}
+
 static struct iopt_area *iopt_pages_find_domain_area(struct iopt_pages *pages,
 						     unsigned long index)
 {
@@ -1064,3 +1076,834 @@ static int pfn_reader_first(struct pfn_reader *pfns, struct iopt_pages *pages,
 	}
 	return 0;
 }
+
+struct iopt_pages *iopt_alloc_pages(void __user *uptr, unsigned long length,
+				    bool writable)
+{
+	struct iopt_pages *pages;
+
+	/*
+	 * The iommu API uses size_t as the length, and protect the DIV_ROUND_UP
+	 * below from overflow
+	 */
+	if (length > SIZE_MAX - PAGE_SIZE || length == 0)
+		return ERR_PTR(-EINVAL);
+
+	pages = kzalloc(sizeof(*pages), GFP_KERNEL_ACCOUNT);
+	if (!pages)
+		return ERR_PTR(-ENOMEM);
+
+	kref_init(&pages->kref);
+	xa_init_flags(&pages->pinned_pfns, XA_FLAGS_ACCOUNT);
+	mutex_init(&pages->mutex);
+	pages->source_mm = current->mm;
+	mmgrab(pages->source_mm);
+	pages->uptr = (void __user *)ALIGN_DOWN((uintptr_t)uptr, PAGE_SIZE);
+	pages->npages = DIV_ROUND_UP(length + (uptr - pages->uptr), PAGE_SIZE);
+	pages->access_itree = RB_ROOT_CACHED;
+	pages->domains_itree = RB_ROOT_CACHED;
+	pages->writable = writable;
+	if (capable(CAP_IPC_LOCK))
+		pages->account_mode = IOPT_PAGES_ACCOUNT_NONE;
+	else
+		pages->account_mode = IOPT_PAGES_ACCOUNT_USER;
+	pages->source_task = current->group_leader;
+	get_task_struct(current->group_leader);
+	pages->source_user = get_uid(current_user());
+	return pages;
+}
+
+void iopt_release_pages(struct kref *kref)
+{
+	struct iopt_pages *pages = container_of(kref, struct iopt_pages, kref);
+
+	WARN_ON(!RB_EMPTY_ROOT(&pages->access_itree.rb_root));
+	WARN_ON(!RB_EMPTY_ROOT(&pages->domains_itree.rb_root));
+	WARN_ON(pages->npinned);
+	WARN_ON(!xa_empty(&pages->pinned_pfns));
+	mmdrop(pages->source_mm);
+	mutex_destroy(&pages->mutex);
+	put_task_struct(pages->source_task);
+	free_uid(pages->source_user);
+	kfree(pages);
+}
+
+static void
+iopt_area_unpin_domain(struct pfn_batch *batch, struct iopt_area *area,
+		       struct iopt_pages *pages, struct iommu_domain *domain,
+		       unsigned long start_index, unsigned long last_index,
+		       unsigned long *unmapped_end_index,
+		       unsigned long real_last_index)
+{
+	while (start_index <= last_index) {
+		unsigned long batch_last_index;
+
+		if (*unmapped_end_index <= last_index) {
+			unsigned long start =
+				max(start_index, *unmapped_end_index);
+
+			batch_from_domain(batch, domain, area, start,
+					  last_index);
+			batch_last_index = start + batch->total_pfns - 1;
+		} else {
+			batch_last_index = last_index;
+		}
+
+		/*
+		 * unmaps must always 'cut' at a place where the pfns are not
+		 * contiguous to pair with the maps that always install
+		 * contiguous pages. Thus, if we have to stop unpinning in the
+		 * middle of the domains we need to keep reading pfns until we
+		 * find a cut point to do the unmap. The pfns we read are
+		 * carried over and either skipped or integrated into the next
+		 * batch.
+		 */
+		if (batch_last_index == last_index &&
+		    last_index != real_last_index)
+			batch_from_domain_continue(batch, domain, area,
+						   last_index + 1,
+						   real_last_index);
+
+		if (*unmapped_end_index <= batch_last_index) {
+			iopt_area_unmap_domain_range(
+				area, domain, *unmapped_end_index,
+				start_index + batch->total_pfns - 1);
+			*unmapped_end_index = start_index + batch->total_pfns;
+		}
+
+		/* unpin must follow unmap */
+		batch_unpin(batch, pages, 0,
+			    batch_last_index - start_index + 1);
+		start_index = batch_last_index + 1;
+
+		batch_clear_carry(batch,
+				  *unmapped_end_index - batch_last_index - 1);
+	}
+}
+
+static void __iopt_area_unfill_domain(struct iopt_area *area,
+				      struct iopt_pages *pages,
+				      struct iommu_domain *domain,
+				      unsigned long last_index)
+{
+	struct interval_tree_double_span_iter span;
+	unsigned long start_index = iopt_area_index(area);
+	unsigned long unmapped_end_index = start_index;
+	u64 backup[BATCH_BACKUP_SIZE];
+	struct pfn_batch batch;
+
+	lockdep_assert_held(&pages->mutex);
+
+	/*
+	 * For security we must not unpin something that is still DMA mapped,
+	 * so this must unmap any IOVA before we go ahead and unpin the pages.
+	 * This creates a complexity where we need to skip over unpinning pages
+	 * held in the xarray, but continue to unmap from the domain.
+	 *
+	 * The domain unmap cannot stop in the middle of a contiguous range of
+	 * PFNs. To solve this problem the unpinning step will read ahead to the
+	 * end of any contiguous span, unmap that whole span, and then only
+	 * unpin the leading part that does not have any accesses. The residual
+	 * PFNs that were unmapped but not unpinned are called a "carry" in the
+	 * batch as they are moved to the front of the PFN list and continue on
+	 * to the next iteration(s).
+	 */
+	batch_init_backup(&batch, last_index + 1, backup, sizeof(backup));
+	interval_tree_for_each_double_span(&span, &pages->domains_itree,
+					   &pages->access_itree, start_index,
+					   last_index) {
+		if (span.is_used) {
+			batch_skip_carry(&batch,
+					 span.last_used - span.start_used + 1);
+			continue;
+		}
+		iopt_area_unpin_domain(&batch, area, pages, domain,
+				       span.start_hole, span.last_hole,
+				       &unmapped_end_index, last_index);
+	}
+	/*
+	 * If the range ends in a access then we do the residual unmap without
+	 * any unpins.
+	 */
+	if (unmapped_end_index != last_index + 1)
+		iopt_area_unmap_domain_range(area, domain, unmapped_end_index,
+					     last_index);
+	WARN_ON(batch.total_pfns);
+	batch_destroy(&batch, backup);
+	update_unpinned(pages);
+}
+
+static void iopt_area_unfill_partial_domain(struct iopt_area *area,
+					    struct iopt_pages *pages,
+					    struct iommu_domain *domain,
+					    unsigned long end_index)
+{
+	if (end_index != iopt_area_index(area))
+		__iopt_area_unfill_domain(area, pages, domain, end_index - 1);
+}
+
+/**
+ * iopt_area_unmap_domain() - Unmap without unpinning PFNs in a domain
+ * @area: The IOVA range to unmap
+ * @domain: The domain to unmap
+ *
+ * The caller must know that unpinning is not required, usually because there
+ * are other domains in the iopt.
+ */
+void iopt_area_unmap_domain(struct iopt_area *area, struct iommu_domain *domain)
+{
+	iommu_unmap_nofail(domain, iopt_area_iova(area),
+			   iopt_area_length(area));
+}
+
+/**
+ * iopt_area_unfill_domain() - Unmap and unpin PFNs in a domain
+ * @area: IOVA area to use
+ * @pages: page supplier for the area (area->pages is NULL)
+ * @domain: Domain to unmap from
+ *
+ * The domain should be removed from the domains_itree before calling. The
+ * domain will always be unmapped, but the PFNs may not be unpinned if there are
+ * still accesses.
+ */
+void iopt_area_unfill_domain(struct iopt_area *area, struct iopt_pages *pages,
+			     struct iommu_domain *domain)
+{
+	__iopt_area_unfill_domain(area, pages, domain,
+				  iopt_area_last_index(area));
+}
+
+/**
+ * iopt_area_fill_domain() - Map PFNs from the area into a domain
+ * @area: IOVA area to use
+ * @domain: Domain to load PFNs into
+ *
+ * Read the pfns from the area's underlying iopt_pages and map them into the
+ * given domain. Called when attaching a new domain to an io_pagetable.
+ */
+int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
+{
+	unsigned long done_end_index;
+	struct pfn_reader pfns;
+	int rc;
+
+	lockdep_assert_held(&area->pages->mutex);
+
+	rc = pfn_reader_first(&pfns, area->pages, iopt_area_index(area),
+			      iopt_area_last_index(area));
+	if (rc)
+		return rc;
+
+	while (!pfn_reader_done(&pfns)) {
+		done_end_index = pfns.batch_start_index;
+		rc = batch_to_domain(&pfns.batch, domain, area,
+				     pfns.batch_start_index);
+		if (rc)
+			goto out_unmap;
+		done_end_index = pfns.batch_end_index;
+
+		rc = pfn_reader_next(&pfns);
+		if (rc)
+			goto out_unmap;
+	}
+
+	rc = pfn_reader_update_pinned(&pfns);
+	if (rc)
+		goto out_unmap;
+	goto out_destroy;
+
+out_unmap:
+	pfn_reader_release_pins(&pfns);
+	iopt_area_unfill_partial_domain(area, area->pages, domain,
+					done_end_index);
+out_destroy:
+	pfn_reader_destroy(&pfns);
+	return rc;
+}
+
+/**
+ * iopt_area_fill_domains() - Install PFNs into the area's domains
+ * @area: The area to act on
+ * @pages: The pages associated with the area (area->pages is NULL)
+ *
+ * Called during area creation. The area is freshly created and not inserted in
+ * the domains_itree yet. PFNs are read and loaded into every domain held in the
+ * area's io_pagetable and the area is installed in the domains_itree.
+ *
+ * On failure all domains are left unchanged.
+ */
+int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
+{
+	unsigned long done_first_end_index;
+	unsigned long done_all_end_index;
+	struct iommu_domain *domain;
+	unsigned long unmap_index;
+	struct pfn_reader pfns;
+	unsigned long index;
+	int rc;
+
+	lockdep_assert_held(&area->iopt->domains_rwsem);
+
+	if (xa_empty(&area->iopt->domains))
+		return 0;
+
+	mutex_lock(&pages->mutex);
+	rc = pfn_reader_first(&pfns, pages, iopt_area_index(area),
+			      iopt_area_last_index(area));
+	if (rc)
+		goto out_unlock;
+
+	while (!pfn_reader_done(&pfns)) {
+		done_first_end_index = pfns.batch_end_index;
+		done_all_end_index = pfns.batch_start_index;
+		xa_for_each(&area->iopt->domains, index, domain) {
+			rc = batch_to_domain(&pfns.batch, domain, area,
+					     pfns.batch_start_index);
+			if (rc)
+				goto out_unmap;
+		}
+		done_all_end_index = done_first_end_index;
+
+		rc = pfn_reader_next(&pfns);
+		if (rc)
+			goto out_unmap;
+	}
+	rc = pfn_reader_update_pinned(&pfns);
+	if (rc)
+		goto out_unmap;
+
+	area->storage_domain = xa_load(&area->iopt->domains, 0);
+	interval_tree_insert(&area->pages_node, &pages->domains_itree);
+	goto out_destroy;
+
+out_unmap:
+	pfn_reader_release_pins(&pfns);
+	xa_for_each(&area->iopt->domains, unmap_index, domain) {
+		unsigned long end_index;
+
+		if (unmap_index < index)
+			end_index = done_first_end_index;
+		else
+			end_index = done_all_end_index;
+
+		/*
+		 * The area is not yet part of the domains_itree so we have to
+		 * manage the unpinning specially. The last domain does the
+		 * unpin, every other domain is just unmapped.
+		 */
+		if (unmap_index != area->iopt->next_domain_id - 1) {
+			if (end_index != iopt_area_index(area))
+				iopt_area_unmap_domain_range(
+					area, domain, iopt_area_index(area),
+					end_index - 1);
+		} else {
+			iopt_area_unfill_partial_domain(area, pages, domain,
+							end_index);
+		}
+	}
+out_destroy:
+	pfn_reader_destroy(&pfns);
+out_unlock:
+	mutex_unlock(&pages->mutex);
+	return rc;
+}
+
+/**
+ * iopt_area_unfill_domains() - unmap PFNs from the area's domains
+ * @area: The area to act on
+ * @pages: The pages associated with the area (area->pages is NULL)
+ *
+ * Called during area destruction. This unmaps the iova's covered by all the
+ * area's domains and releases the PFNs.
+ */
+void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages)
+{
+	struct io_pagetable *iopt = area->iopt;
+	struct iommu_domain *domain;
+	unsigned long index;
+
+	lockdep_assert_held(&iopt->domains_rwsem);
+
+	mutex_lock(&pages->mutex);
+	if (!area->storage_domain)
+		goto out_unlock;
+
+	xa_for_each(&iopt->domains, index, domain)
+		if (domain != area->storage_domain)
+			iopt_area_unmap_domain_range(
+				area, domain, iopt_area_index(area),
+				iopt_area_last_index(area));
+
+	interval_tree_remove(&area->pages_node, &pages->domains_itree);
+	iopt_area_unfill_domain(area, pages, area->storage_domain);
+	area->storage_domain = NULL;
+out_unlock:
+	mutex_unlock(&pages->mutex);
+}
+
+static void iopt_pages_unpin_xarray(struct pfn_batch *batch,
+				    struct iopt_pages *pages,
+				    unsigned long start_index,
+				    unsigned long end_index)
+{
+	while (start_index <= end_index) {
+		batch_from_xarray_clear(batch, &pages->pinned_pfns, start_index,
+					end_index);
+		batch_unpin(batch, pages, 0, batch->total_pfns);
+		start_index += batch->total_pfns;
+		batch_clear(batch);
+	}
+}
+
+/**
+ * iopt_pages_unfill_xarray() - Update the xarry after removing an access
+ * @pages: The pages to act on
+ * @start_index: Starting PFN index
+ * @last_index: Last PFN index
+ *
+ * Called when an iopt_pages_access is removed, removes pages from the itree.
+ * The access should already be removed from the access_itree.
+ */
+void iopt_pages_unfill_xarray(struct iopt_pages *pages,
+			      unsigned long start_index,
+			      unsigned long last_index)
+{
+	struct interval_tree_double_span_iter span;
+	u64 backup[BATCH_BACKUP_SIZE];
+	struct pfn_batch batch;
+	bool batch_inited = false;
+
+	lockdep_assert_held(&pages->mutex);
+
+	interval_tree_for_each_double_span(&span, &pages->access_itree,
+					   &pages->domains_itree, start_index,
+					   last_index) {
+		if (!span.is_used) {
+			if (!batch_inited) {
+				batch_init_backup(&batch,
+						  last_index - start_index + 1,
+						  backup, sizeof(backup));
+				batch_inited = true;
+			}
+			iopt_pages_unpin_xarray(&batch, pages, span.start_hole,
+						span.last_hole);
+		} else if (span.is_used == 2) {
+			/* Covered by a domain */
+			clear_xarray(&pages->pinned_pfns, span.start_used,
+				     span.last_used);
+		}
+		/* Otherwise covered by an existing access */
+	}
+	if (batch_inited)
+		batch_destroy(&batch, backup);
+	update_unpinned(pages);
+}
+
+/**
+ * iopt_pages_fill_from_xarray() - Fast path for reading PFNs
+ * @pages: The pages to act on
+ * @start_index: The first page index in the range
+ * @last_index: The last page index in the range
+ * @out_pages: The output array to return the pages
+ *
+ * This can be called if the caller is holding a refcount on an
+ * iopt_pages_access that is known to have already been filled. It quickly reads
+ * the pages directly from the xarray.
+ *
+ * This is part of the SW iommu interface to read pages for in-kernel use.
+ */
+void iopt_pages_fill_from_xarray(struct iopt_pages *pages,
+				 unsigned long start_index,
+				 unsigned long last_index,
+				 struct page **out_pages)
+{
+	XA_STATE(xas, &pages->pinned_pfns, start_index);
+	void *entry;
+
+	rcu_read_lock();
+	while (start_index <= last_index) {
+		entry = xas_next(&xas);
+		if (xas_retry(&xas, entry))
+			continue;
+		WARN_ON(!xa_is_value(entry));
+		*(out_pages++) = pfn_to_page(xa_to_value(entry));
+		start_index++;
+	}
+	rcu_read_unlock();
+}
+
+static int iopt_pages_fill_from_domain(struct iopt_pages *pages,
+				       unsigned long start_index,
+				       unsigned long last_index,
+				       struct page **out_pages)
+{
+	while (start_index != last_index + 1) {
+		unsigned long domain_last;
+		struct iopt_area *area;
+
+		area = iopt_pages_find_domain_area(pages, start_index);
+		if (WARN_ON(!area))
+			return -EINVAL;
+
+		domain_last = min(iopt_area_last_index(area), last_index);
+		out_pages = raw_pages_from_domain(area->storage_domain, area,
+						  start_index, domain_last,
+						  out_pages);
+		start_index = domain_last + 1;
+	}
+	return 0;
+}
+
+static int iopt_pages_fill_from_mm(struct iopt_pages *pages,
+				   struct pfn_reader_user *user,
+				   unsigned long start_index,
+				   unsigned long last_index,
+				   struct page **out_pages)
+{
+	unsigned long cur_index = start_index;
+	int rc;
+
+	while (cur_index != last_index + 1) {
+		user->upages = out_pages + (cur_index - start_index);
+		rc = pfn_reader_user_pin(user, pages, cur_index, last_index);
+		if (rc)
+			goto out_unpin;
+		cur_index = user->upages_end;
+	}
+	return 0;
+
+out_unpin:
+	if (start_index != cur_index)
+		iopt_pages_err_unpin(pages, start_index, cur_index - 1,
+				     out_pages);
+	return rc;
+}
+
+/**
+ * iopt_pages_fill_xarray() - Read PFNs
+ * @pages: The pages to act on
+ * @start_index: The first page index in the range
+ * @last_index: The last page index in the range
+ * @out_pages: The output array to return the pages, may be NULL
+ *
+ * This populates the xarray and returns the pages in out_pages. As the slow
+ * path this is able to copy pages from other storage tiers into the xarray.
+ *
+ * On failure the xarray is left unchanged.
+ *
+ * This is part of the SW iommu interface to read pages for in-kernel use.
+ */
+int iopt_pages_fill_xarray(struct iopt_pages *pages, unsigned long start_index,
+			   unsigned long last_index, struct page **out_pages)
+{
+	struct interval_tree_double_span_iter span;
+	unsigned long xa_end = start_index;
+	struct pfn_reader_user user;
+	int rc;
+
+	lockdep_assert_held(&pages->mutex);
+
+	pfn_reader_user_init(&user, pages);
+	user.upages_len = (last_index - start_index + 1) * sizeof(*out_pages);
+	interval_tree_for_each_double_span(&span, &pages->access_itree,
+					   &pages->domains_itree, start_index,
+					   last_index) {
+		struct page **cur_pages;
+
+		if (span.is_used == 1) {
+			cur_pages = out_pages + (span.start_used - start_index);
+			iopt_pages_fill_from_xarray(pages, span.start_used,
+						    span.last_used, cur_pages);
+			continue;
+		}
+
+		if (span.is_used == 2) {
+			cur_pages = out_pages + (span.start_used - start_index);
+			iopt_pages_fill_from_domain(pages, span.start_used,
+						    span.last_used, cur_pages);
+			rc = pages_to_xarray(&pages->pinned_pfns,
+					     span.start_used, span.last_used,
+					     cur_pages);
+			if (rc)
+				goto out_clean_xa;
+			xa_end = span.last_used + 1;
+			continue;
+		}
+
+		/* hole */
+		cur_pages = out_pages + (span.start_hole - start_index);
+		rc = iopt_pages_fill_from_mm(pages, &user, span.start_hole,
+					     span.last_hole, cur_pages);
+		if (rc)
+			goto out_clean_xa;
+		rc = pages_to_xarray(&pages->pinned_pfns, span.start_hole,
+				     span.last_hole, cur_pages);
+		if (rc) {
+			iopt_pages_err_unpin(pages, span.start_hole,
+					     span.last_hole, cur_pages);
+			goto out_clean_xa;
+		}
+		xa_end = span.last_hole + 1;
+	}
+	rc = pfn_reader_user_update_pinned(&user, pages);
+	if (rc)
+		goto out_clean_xa;
+	user.upages = NULL;
+	pfn_reader_user_destroy(&user, pages);
+	return 0;
+
+out_clean_xa:
+	if (start_index != xa_end)
+		iopt_pages_unfill_xarray(pages, start_index, xa_end - 1);
+	user.upages = NULL;
+	pfn_reader_user_destroy(&user, pages);
+	return rc;
+}
+
+/*
+ * This uses the pfn_reader instead of taking a shortcut by using the mm. It can
+ * do every scenario and is fully consistent with what an iommu_domain would
+ * see.
+ */
+static int iopt_pages_rw_slow(struct iopt_pages *pages,
+			      unsigned long start_index,
+			      unsigned long last_index, unsigned long offset,
+			      void *data, unsigned long length,
+			      unsigned int flags)
+{
+	struct pfn_reader pfns;
+	int rc;
+
+	mutex_lock(&pages->mutex);
+
+	rc = pfn_reader_first(&pfns, pages, start_index, last_index);
+	if (rc)
+		goto out_unlock;
+
+	while (!pfn_reader_done(&pfns)) {
+		unsigned long done;
+
+		done = batch_rw(&pfns.batch, data, offset, length, flags);
+		data += done;
+		length -= done;
+		offset = 0;
+		pfn_reader_unpin(&pfns);
+
+		rc = pfn_reader_next(&pfns);
+		if (rc)
+			goto out_destroy;
+	}
+	if (WARN_ON(length != 0))
+		rc = -EINVAL;
+out_destroy:
+	pfn_reader_destroy(&pfns);
+out_unlock:
+	mutex_unlock(&pages->mutex);
+	return rc;
+}
+
+/*
+ * A medium speed path that still allows DMA inconsistencies, but doesn't do any
+ * memory allocations or interval tree searches.
+ */
+static int iopt_pages_rw_page(struct iopt_pages *pages, unsigned long index,
+			      unsigned long offset, void *data,
+			      unsigned long length, unsigned int flags)
+{
+	struct page *page = NULL;
+	int rc;
+
+	if (!mmget_not_zero(pages->source_mm))
+		return iopt_pages_rw_slow(pages, index, index, offset, data,
+					  length, flags);
+
+	mmap_read_lock(pages->source_mm);
+	rc = pin_user_pages_remote(
+		pages->source_mm, (uintptr_t)(pages->uptr + index * PAGE_SIZE),
+		1, (flags & IOMMUFD_ACCESS_RW_WRITE) ? FOLL_WRITE : 0, &page,
+		NULL, NULL);
+	mmap_read_unlock(pages->source_mm);
+	if (rc != 1) {
+		if (WARN_ON(rc >= 0))
+			rc = -EINVAL;
+		goto out_mmput;
+	}
+	copy_data_page(page, data, offset, length, flags);
+	unpin_user_page(page);
+	rc = 0;
+
+out_mmput:
+	mmput(pages->source_mm);
+	return rc;
+}
+
+/**
+ * iopt_pages_rw_access - Copy to/from a linear slice of the pages
+ * @pages: pages to act on
+ * @start_byte: First byte of pages to copy to/from
+ * @data: Kernel buffer to get/put the data
+ * @length: Number of bytes to copy
+ * @flags: IOMMUFD_ACCESS_RW_* flags
+ *
+ * This will find each page in the range, kmap it and then memcpy to/from
+ * the given kernel buffer.
+ */
+int iopt_pages_rw_access(struct iopt_pages *pages, unsigned long start_byte,
+			 void *data, unsigned long length, unsigned int flags)
+{
+	unsigned long start_index = start_byte / PAGE_SIZE;
+	unsigned long last_index = (start_byte + length - 1) / PAGE_SIZE;
+	bool change_mm = current->mm != pages->source_mm;
+	int rc = 0;
+
+	if ((flags & IOMMUFD_ACCESS_RW_WRITE) && !pages->writable)
+		return -EPERM;
+
+	if (!(flags & IOMMUFD_ACCESS_RW_KTHREAD) && change_mm) {
+		if (start_index == last_index)
+			return iopt_pages_rw_page(pages, start_index,
+						  start_byte % PAGE_SIZE, data,
+						  length, flags);
+		return iopt_pages_rw_slow(pages, start_index, last_index,
+					  start_byte % PAGE_SIZE, data, length,
+					  flags);
+	}
+
+	/*
+	 * Try to copy using copy_to_user(). We do this as a fast path and
+	 * ignore any pinning inconsistencies, unlike a real DMA path.
+	 */
+	if (change_mm) {
+		if (!mmget_not_zero(pages->source_mm))
+			return iopt_pages_rw_slow(pages, start_index,
+						  last_index,
+						  start_byte % PAGE_SIZE, data,
+						  length, flags);
+		kthread_use_mm(pages->source_mm);
+	}
+
+	if (flags & IOMMUFD_ACCESS_RW_WRITE) {
+		if (copy_to_user(pages->uptr + start_byte, data, length))
+			rc = -EFAULT;
+	} else {
+		if (copy_from_user(data, pages->uptr + start_byte, length))
+			rc = -EFAULT;
+	}
+
+	if (change_mm) {
+		kthread_unuse_mm(pages->source_mm);
+		mmput(pages->source_mm);
+	}
+
+	return rc;
+}
+
+static struct iopt_pages_access *
+iopt_pages_get_exact_access(struct iopt_pages *pages, unsigned long index,
+			    unsigned long last)
+{
+	struct interval_tree_node *node;
+
+	lockdep_assert_held(&pages->mutex);
+
+	/* There can be overlapping ranges in this interval tree */
+	for (node = interval_tree_iter_first(&pages->access_itree, index, last);
+	     node; node = interval_tree_iter_next(node, index, last))
+		if (node->start == index && node->last == last)
+			return container_of(node, struct iopt_pages_access,
+					    node);
+	return NULL;
+}
+
+/**
+ * iopt_area_add_access() - Record an in-knerel access for PFNs
+ * @area: The source of PFNs
+ * @start_index: First page index
+ * @last_index: Inclusive last page index
+ * @out_pages: Output list of struct page's representing the PFNs
+ * @flags: IOMMUFD_ACCESS_RW_* flags
+ *
+ * Record that an in-kernel access will be accessing the pages, ensure they are
+ * pinned, and return the PFNs as a simple list of 'struct page *'.
+ *
+ * This should be undone through a matching call to iopt_area_remove_access()
+ */
+int iopt_area_add_access(struct iopt_area *area, unsigned long start_index,
+			  unsigned long last_index, struct page **out_pages,
+			  unsigned int flags)
+{
+	struct iopt_pages *pages = area->pages;
+	struct iopt_pages_access *access;
+	int rc;
+
+	if ((flags & IOMMUFD_ACCESS_RW_WRITE) && !pages->writable)
+		return -EPERM;
+
+	mutex_lock(&pages->mutex);
+	access = iopt_pages_get_exact_access(pages, start_index, last_index);
+	if (access) {
+		area->num_accesses++;
+		access->users++;
+		iopt_pages_fill_from_xarray(pages, start_index, last_index,
+					    out_pages);
+		mutex_unlock(&pages->mutex);
+		return 0;
+	}
+
+	access = kzalloc(sizeof(*access), GFP_KERNEL_ACCOUNT);
+	if (!access) {
+		rc = -ENOMEM;
+		goto err_unlock;
+	}
+
+	rc = iopt_pages_fill_xarray(pages, start_index, last_index, out_pages);
+	if (rc)
+		goto err_free;
+
+	access->node.start = start_index;
+	access->node.last = last_index;
+	access->users = 1;
+	area->num_accesses++;
+	interval_tree_insert(&access->node, &pages->access_itree);
+	mutex_unlock(&pages->mutex);
+	return 0;
+
+err_free:
+	kfree(access);
+err_unlock:
+	mutex_unlock(&pages->mutex);
+	return rc;
+}
+
+/**
+ * iopt_area_remove_access() - Release an in-kernel access for PFNs
+ * @area: The source of PFNs
+ * @start_index: First page index
+ * @last_index: Inclusive last page index
+ *
+ * Undo iopt_area_add_access() and unpin the pages if necessary. The caller
+ * must stop using the PFNs before calling this.
+ */
+void iopt_area_remove_access(struct iopt_area *area, unsigned long start_index,
+			     unsigned long last_index)
+{
+	struct iopt_pages *pages = area->pages;
+	struct iopt_pages_access *access;
+
+	mutex_lock(&pages->mutex);
+	access = iopt_pages_get_exact_access(pages, start_index, last_index);
+	if (WARN_ON(!access))
+		goto out_unlock;
+
+	WARN_ON(area->num_accesses == 0 || access->users == 0);
+	area->num_accesses--;
+	access->users--;
+	if (access->users)
+		goto out_unlock;
+
+	interval_tree_remove(&access->node, &pages->access_itree);
+	iopt_pages_unfill_xarray(pages, start_index, last_index);
+	kfree(access);
+out_unlock:
+	mutex_unlock(&pages->mutex);
+}
-- 
2.38.1

