Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221D04F82CC
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344609AbiDGP0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344613AbiDGPZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:25:57 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2072.outbound.protection.outlook.com [40.107.100.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11558217984
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:23:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dg3cBdiQCDh5WvWmZa014lOJFm6m6y0otozkEJEBwXNUte9HIhtr46XBMhXxJ9yNaIwNnzVi2LJSvZ8dfJmhkVhfRRmatqKZR/AtmF1FxnUavSPmJzUA5Gh87mD4OYeTv7VN6Xz48Jzz2EphhFIBDwf4Pi/lvlRg97B11GWFLuZSNswGQ3u3xVsg/Ofa3V5zyTzGY9SwAwLuyXU5BBV2W1ahnRNaYZtIqJz6A5xR/Au+SE5xRx0xVyv53nTA8m0S9QQ//A0TSaVddX3dT/Ode4iJx6NrGfBbACkfstQ7STqCKXbEN8zZw9x/jwQ4cbS7U1y3wDwEIP/xJzaq23v8oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSr56/78CZWofxM5sl89INWslKmsLm9oE3hXmYMZxiY=;
 b=O4t3MataWfGXOyXE5lqBMEWdr/eXosabLthCZbrVltZ4pseOu/qy6CFDWqEF9qg/jxaqZypH00XnYmbh2hnnoFEpfCDBbyCZzu7qBWUClTyDHHX0tLgvhsfiWiBm8Jx5bBz/5OgZC8VBQR7O71N+eaA/YWTeFhvRv19bGaRJUxPxuvbDaiNxj5NZCwYSGGB2rZqK1uRyS1AYcSyERgWqdCGA1gmST6GpJOOEMx5yu/yx6CZ//ASe+Et16RHmrV404xSWD8L8iUcbRQiXvsZzdIm2PXd0rL8g1UoDvW2dYP1LzSdvCaev6V6tYUfFqPZjzCcElkkOO7T8+wy3NjeQVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSr56/78CZWofxM5sl89INWslKmsLm9oE3hXmYMZxiY=;
 b=bBPKQUpyF9xu5pFod0r1u0J3FmXI2Yoa0CwWoreYAlrTk/lHVmVU+niRHohUu+lVDPErGcki+tyTw7IrP/tdaV3KcabARdvKv6nCwArl6Zzm6EodfSjn5eDAPQiEYiJHpDsUyI6qm4coJV70ZzdDURwjtVS6qIe7yibNzLjeBWRBQeG7mu0zdAZbzvN/s06AS1JK/Vtjo3igOq4eMeFbPeqiNBx4Y5BrGqHWu1yY8Zt+sf1jOUyTdMjzJ3MKI8d5OtLs4urBZcJBwUwK6+GhJb+moBE/UYWcyd05ao8ysYemYf2ozwSRbz8y7q5BPMYXHNSNLEsVXcYQu03djgriiQ==
Received: from MN0PR12MB5740.namprd12.prod.outlook.com (2603:10b6:208:373::10)
 by BYAPR12MB3239.namprd12.prod.outlook.com (2603:10b6:a03:137::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 15:23:50 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN0PR12MB5740.namprd12.prod.outlook.com (2603:10b6:208:373::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 15:23:49 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 15:23:49 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH v2 1/4] iommu: Introduce the domain op enforce_cache_coherency()
Date:   Thu,  7 Apr 2022 12:23:44 -0300
Message-Id: <1-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
In-Reply-To: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:610:cc::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea97f698-b07a-42da-feba-08da18aa9d51
X-MS-TrafficTypeDiagnostic: MN0PR12MB5740:EE_|BYAPR12MB3239:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB5740A6273577E24B14E22D1AC2E69@MN0PR12MB5740.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4vuhx9RyLIZZIYJ2X3M75svE16UnvmTMeEQnZBDoouqWduI2NTTXEpWoZR6ZOLS38PGGS4klm03107/LBoZbqRmrJ+4B5HJ3VVNAUuFujpNt0KScI7szkIv/R0GIKgol7s91tkfYqSRNuP8Rd25kVlioaELDCQXzGCTVRE1Z4GG9XWePY4Z3kCaYF7Y6OjYZ1GqnG9b3XwSEej4ZGUT22MJht+tQRK9mJ1SrQDzl+NcAclhVuSw3D7KCF0fLXNh+cgFwE8OqVHj5C5im8REeWpjfHoIJCdlZVo+CvuEyZ2XfVyk8t5jmlusdnO5jY5m+wMHmtAlMSSXM3kvsFVNBXG8k9ZdRozq3EhmA8FinRSaxC2kfCxLOTUcNgbO8JmISBWMTpf5Pl8AGa80fKqKHBgMoWiEqzLusexrpd8WVofkwLTk7zt1wdbZNS4rLr3Ru6iMI9hwILZiaHaCBL1LRyDOU4ofisl7VaUDYPp7PY1wgWBT2IVXwwo4i3KPjZROrLJxjJgxGErjyNTxNrZ2QYuKfl0upZGKS79Sl2o8hReV2QTM536P3Amzko4HrIjKuwDWu5nmOO4csUMRIufTc77K1qwrF7YFHA+cCIYNKVxAXfFtranMqxkO6KN84L6hyu8g6JusO1WPA8fV/n1pfx32I/rIRd2FonC8JahcSYP8PDx+h1xWvWgrUDzk8V6Og
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5740.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6666004)(86362001)(186003)(2906002)(508600001)(38100700002)(26005)(83380400001)(6512007)(6506007)(36756003)(8676002)(4326008)(66946007)(6486002)(66556008)(66476007)(5660300002)(7416002)(54906003)(8936002)(110136005)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CjHg0rznFdSuu29GB6kb6EXrLFxhttelGM8Ake/4Re0pgq15/33MhnWUvSBZ?=
 =?us-ascii?Q?o8kdNyno1oW5vtuM9ZjDG2eRRH4wbGirT3eBv23oD8RCjw6SEEbDV+jBcEJ2?=
 =?us-ascii?Q?BdcDtv5kpyBDw7XQ01AWEvlSGrXORzcbkGzOCr+6DebPvEtRFSWsdBw5HGnX?=
 =?us-ascii?Q?49Ail3OJqsSXkTec7cJACe5UVNJd8835I1IzlriFQTZSCs3RG6bN0UwGexw5?=
 =?us-ascii?Q?NisnwmBm88UPi+rt1vB7YYLBmPnmL/gM7BYKm1z6bWbgvbwlG52nnt6fMYiP?=
 =?us-ascii?Q?xVaxrAVjvBNP+2hNZz1RJDgPLepK/LFiMK8Ke62Q803BS/wmENfhocJH40F7?=
 =?us-ascii?Q?oJyXt2E0La5tvH0Fx7Z8nFMsCHPMzBRBA6hBP+M+Ug3soZ5VU3Wu/SadzDdp?=
 =?us-ascii?Q?vYzGYmxKvig+WcICVIobywhNU0QTIsDjkA2dWS2vpHByzDaB6lQUFj5hpfcz?=
 =?us-ascii?Q?sRwVqBXV3VgVciEjvQ4qu8j57v0fwDs/lXZDYeipMYePUb9dnc74CWHjeMUK?=
 =?us-ascii?Q?X3Av4aGoV9sGsqhc4ZdUby5XssVusboMLp0F4U2YgCVeJDJP5oy+3ybwVUms?=
 =?us-ascii?Q?LaUh4uUcjMMSb8yaSXEK8WNjCjUoHY1aaHfLDIyKViQjAKWagPzPQ6trc7YV?=
 =?us-ascii?Q?QEHEGJW6+pCTCLHjXeuJtZwYxw0md/e5J8IIApItqcLQngXyzlzSKfE3yIIg?=
 =?us-ascii?Q?mLNIPtSBPx9LC2w6MJ1QBN2eIaVJR3OhlqinS2uU44GSAHSJW1u2OW3ABu2f?=
 =?us-ascii?Q?2xLEiEG21BS4NoCrl24XwTWoJMeIK7SX2US9KuaykS5ce/FWJiyfKb4SKNMM?=
 =?us-ascii?Q?RBllXg/JWqIvNDM3BZqj6wxvSNIGy4i6y1VZdx9YoVd33cO13JopBQe02wsF?=
 =?us-ascii?Q?5RP9IA0/7Pw+UeA+HVDeGI2+sAh/WU5x/DpuNlFZUzDdFQTsXNERzvtdMysh?=
 =?us-ascii?Q?gwqPbNd33SNfCgYNmZaLq+RmTJ7PPs+MsWuVKP+iOiS7HBxp3BHN+dw3XZNO?=
 =?us-ascii?Q?f+9T7J/X4cG+CWahhietVjtPVBQXJNpgUDP/XLQC4wmWkIp9ZAjfDP5jP2IO?=
 =?us-ascii?Q?VZd6f1l54y+gVP3yOZ1SNrI/suZb46pRZIiuswu9m7AXLuNkoiYpXr8cePNK?=
 =?us-ascii?Q?srducqT2I1c3EAiMsdutQOjljjf2rt4zeO8VDmeXlSFasa5k6/+U9tb8fvnF?=
 =?us-ascii?Q?oAax6H3axPUG24Qfxluqdr9/ZVG+VW734LETkxheFHIY5sY3QQ9ZHZu+91a+?=
 =?us-ascii?Q?cTOZnMoUxsJlOwMvQxA9kI6qZrDrcX2I8x9ers3d12K6icoeEs4cjAc0R6y7?=
 =?us-ascii?Q?dG04S3OvY9MhgvZ8B2aJTVpoLMvVf2RIF81g2aeO76aJyWLzxf+EZdOPajp2?=
 =?us-ascii?Q?YSFAs4Bb9Aiwj069XNiaoXW7p9Q9jqKxBVbsVXh4uNG8Z0/Qy4wcBfF8gY+c?=
 =?us-ascii?Q?CICFPWQHM8FYyTI8UYJrqknWJOFTY5o1Z4BiFpAxL7bNOu/DSyAvQ0f+jVN4?=
 =?us-ascii?Q?IIQ0nRTOw2NiourgLMzuszxgGGid3AYU/WqzqZtUJ6ni6g0IDMS8nJVLb/Ds?=
 =?us-ascii?Q?kmTt630omEftxH9WDh8mYfCVpkddfLw+O02SGGsZwVcaGfoK+dhWd8gUhA2z?=
 =?us-ascii?Q?EP6sfbcvedntG9mW71/IFCyrje7WcerqAYGiQqTJHGwK7GsH3Tn1GRGWlFbp?=
 =?us-ascii?Q?ANQGX1qH33AV4bxxrdhSX/6i4LYKaiE1nn7aReAbEa2E5D9gO8ltKZxmeH9B?=
 =?us-ascii?Q?fwon53iJSg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea97f698-b07a-42da-feba-08da18aa9d51
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 15:23:49.0499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yakn5ZXZ1+wZm4OfzvGr2Wa8rp+myQUNHw6cso4HmFXCjQeu8FdmlFtjZRMjMMOB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3239
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This new mechanism will replace using IOMMU_CAP_CACHE_COHERENCY and
IOMMU_CACHE to control the no-snoop blocking behavior of the IOMMU.

Currently only Intel and AMD IOMMUs are known to support this
feature. They both implement it as an IOPTE bit, that when set, will cause
PCIe TLPs to that IOVA with the no-snoop bit set to be treated as though
the no-snoop bit was clear.

The new API is triggered by calling enforce_cache_coherency() before
mapping any IOVA to the domain which globally switches on no-snoop
blocking. This allows other implementations that might block no-snoop
globally and outside the IOPTE - AMD also documents such a HW capability.

Leave AMD out of sync with Intel and have it block no-snoop even for
in-kernel users. This can be trivially resolved in a follow up patch.

Only VFIO will call this new API.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c   |  7 +++++++
 drivers/iommu/intel/iommu.c | 14 +++++++++++++-
 include/linux/intel-iommu.h |  1 +
 include/linux/iommu.h       |  4 ++++
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a1ada7bff44e61..e500b487eb3429 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2271,6 +2271,12 @@ static int amd_iommu_def_domain_type(struct device *dev)
 	return 0;
 }
 
+static bool amd_iommu_enforce_cache_coherency(struct iommu_domain *domain)
+{
+	/* IOMMU_PTE_FC is always set */
+	return true;
+}
+
 const struct iommu_ops amd_iommu_ops = {
 	.capable = amd_iommu_capable,
 	.domain_alloc = amd_iommu_domain_alloc,
@@ -2293,6 +2299,7 @@ const struct iommu_ops amd_iommu_ops = {
 		.flush_iotlb_all = amd_iommu_flush_iotlb_all,
 		.iotlb_sync	= amd_iommu_iotlb_sync,
 		.free		= amd_iommu_domain_free,
+		.enforce_cache_coherency = amd_iommu_enforce_cache_coherency,
 	}
 };
 
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index df5c62ecf942b8..f08611a6cc4799 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4422,7 +4422,8 @@ static int intel_iommu_map(struct iommu_domain *domain,
 		prot |= DMA_PTE_READ;
 	if (iommu_prot & IOMMU_WRITE)
 		prot |= DMA_PTE_WRITE;
-	if ((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping)
+	if (((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping) ||
+	    dmar_domain->enforce_no_snoop)
 		prot |= DMA_PTE_SNP;
 
 	max_addr = iova + size;
@@ -4545,6 +4546,16 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 	return phys;
 }
 
+static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+
+	if (!dmar_domain->iommu_snooping)
+		return false;
+	dmar_domain->enforce_no_snoop = true;
+	return true;
+}
+
 static bool intel_iommu_capable(enum iommu_cap cap)
 {
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
@@ -4898,6 +4909,7 @@ const struct iommu_ops intel_iommu_ops = {
 		.iotlb_sync		= intel_iommu_tlb_sync,
 		.iova_to_phys		= intel_iommu_iova_to_phys,
 		.free			= intel_iommu_domain_free,
+		.enforce_cache_coherency = intel_iommu_enforce_cache_coherency,
 	}
 };
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 2f9891cb3d0014..1f930c0c225d94 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -540,6 +540,7 @@ struct dmar_domain {
 	u8 has_iotlb_device: 1;
 	u8 iommu_coherency: 1;		/* indicate coherency of iommu access */
 	u8 iommu_snooping: 1;		/* indicate snooping control feature */
+	u8 enforce_no_snoop : 1;        /* Create IOPTEs with snoop control */
 
 	struct list_head devices;	/* all devices' list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9208eca4b0d1ac..fe4f24c469c373 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -272,6 +272,9 @@ struct iommu_ops {
  * @iotlb_sync: Flush all queued ranges from the hardware TLBs and empty flush
  *            queue
  * @iova_to_phys: translate iova to physical address
+ * @enforce_cache_coherency: Prevent any kind of DMA from bypassing IOMMU_CACHE,
+ *                           including no-snoop TLPs on PCIe or other platform
+ *                           specific mechanisms.
  * @enable_nesting: Enable nesting
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @free: Release the domain after use.
@@ -300,6 +303,7 @@ struct iommu_domain_ops {
 	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
 				    dma_addr_t iova);
 
+	bool (*enforce_cache_coherency)(struct iommu_domain *domain);
 	int (*enable_nesting)(struct iommu_domain *domain);
 	int (*set_pgtable_quirks)(struct iommu_domain *domain,
 				  unsigned long quirks);
-- 
2.35.1

