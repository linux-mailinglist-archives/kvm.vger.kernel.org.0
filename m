Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B478736AC9
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 13:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbjFTLTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 07:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbjFTLTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 07:19:01 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB3C1BB;
        Tue, 20 Jun 2023 04:18:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AATQCT3ll81huiDaO87gP/XHY2DzC2C4mLTQDO3YQ3hkPLmfT+YkqS0yK9G4cfZdUutpj8iAKOsPJFcGtslBG/Ss5FgyHYQjYRYzPSsPMkJ5UNNi5U3dvFBQ1VfoRWOc0wSqF8Dyf6e4hZ6yPXzkZkA17aOIwGJS2HoprueD0INekN24zRbLw8HrrV92XoaNTAXLcW8AgA8qeikn5nWfltwcbMDW/B2IIjR0qDtBIrzNfvRL1dHHyDDGldIatqYyuvr3qSZJNH91SGyjGBn1edmfPMMs0d085Hoc1Oyqu26TLzKBzCt7cf+xt2KwKb82qEDPQ40uzY3Po52M9Z4y0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/e0bTkDCD0Y+LOaOaHhTnpes+cYQD6GyaWR/vS3xWs=;
 b=hD/IaQWNov0LmEo4TAWsURkf3fZC2sxqU8Gh38sEClVPjMn1z0rjP3Pr9NjQ/vMCy3gF6Ni8um1m9D+ZkvS8hhtRVAD6QXNFtIRnh3el3AJZS9kKcpFzji9R/dZtubugu+hLWKJ1Owaw4IUjJeILe11yfzwddzAOhXHr8j5SjtdAzqarMkE+bIMtw/dQGrfXcqrBzc5ITHqF9goOWHytWg4lPdI9IE4N8vbY0xHXYMpsOnFDPrrgjD2Ts1GSVKCTgAoFPHrPR0YWKRqhf+aEvyk9GYM7LUFnPhNUuT7hnv0Pcif+HGxiTpEgMzIzngPPz26PYzaDHQEqe0ZaHsSapQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/e0bTkDCD0Y+LOaOaHhTnpes+cYQD6GyaWR/vS3xWs=;
 b=CpUa9AIkqq8UaEk7jySy/ssna4YcJb9OqkSXUAOv9x6GZDv+MAeIkE41iDoRTi9dZHpE9Z37QILfFc972RzrrfHHRA4Twkiz1TysQ33LXWGtjumN78LDpERR95WdXaYsnjuu0jQNZA+jc1D1ky4EuwxMuUWj+oyaWikfl/fyXJMrynYLtbRftR5/6qNaC0Co14bmhMpE/uM7nl3tb1MoQq7N6LefZ8/mU+RY7j9x+87cvDhFAyFEJ9Xq7uOvNJvIVRSZjSnCW8xa9Tyv76Hfa/IZvR03Ku2yhsBy6etgBvjFX4yvwJkVJqEAQQ0zmu8XN7vCE1m7aRca6pS8GZve1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by IA1PR12MB9031.namprd12.prod.outlook.com (2603:10b6:208:3f9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 11:18:56 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4854:668:e67e:b61d]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4854:668:e67e:b61d%3]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 11:18:56 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc:     Robin Murphy <robin.murphy@arm.com>, will@kernel.org,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        nicolinc@nvidia.com, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        zhi.wang.linux@gmail.com, Sean Christopherson <seanjc@google.com>,
        Alistair Popple <apopple@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [RFC PATCH 1/2] mm_notifiers: Rename invalidate_range notifier
Date:   Tue, 20 Jun 2023 21:18:25 +1000
Message-Id: <2c36a9347461c2c4792f18af18c55badd06c657b.1687259597.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.063f3dc2100ae7cbe3a6527689589646ea787216.1687259597.git-series.apopple@nvidia.com>
References: <cover.063f3dc2100ae7cbe3a6527689589646ea787216.1687259597.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY6PR01CA0123.ausprd01.prod.outlook.com
 (2603:10c6:10:1b8::8) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|IA1PR12MB9031:EE_
X-MS-Office365-Filtering-Correlation-Id: eea7e5f2-ed79-4998-ea76-08db71802328
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y6EQyNOApQEtQqo1SjyOTM2Do83AAhHgHSWuV1lrDkMu0opEXXWSqq5fMWPb+yqgZc/Kkes+BVzhqfkyKz6SiwdRl/na6hOwCJMpELsGJYbGeNMdhvNT9pPR56ttKH3sq2qblGPIBotS63+U5Ltm0sSaA4lMmERhtn0EyWuskBpJHKv8Ab45VZDkdsmrf5CcEo3sKW+zr57e7WT1lGgZ/4siXJfzRMBJOEwpFgdRY/hzPK4Mqb1YOHXhaE4p31ZXji1VS1kGF9o6Fa/ydKJKEulZVCEI+N12gVmMObjLbCq0bGE3wyz1tb9s+boZ3TleBur3QYf1piNpF/HTE44SABDniXeyPkNzyU4LQvDbjQzPOAhre+UU5OjWOIBjwsS2WmssJGOlHcH6yikyGGlbCY3sGyoE6btMleCPsUajpmJHyTnk3R0x7rsgG8vPRsL/ngzd7voUlyj01BgRAYj5rIsi4ESPD2rtIn27KKPALy/Czcfphwppv29SRA6Z6WwCF5GvMWsOKmh9pyVrkq2OuNFyzjuET7ZdPfhNsxGzOYMmZs11/BNW7kAXWX1mPpeI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199021)(8676002)(8936002)(66946007)(186003)(66556008)(66476007)(5660300002)(54906003)(4326008)(26005)(6666004)(6486002)(316002)(478600001)(41300700001)(36756003)(6506007)(6512007)(38100700002)(107886003)(7416002)(30864003)(86362001)(2906002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qICIjKazd5ee9rF/29Ljd+/xCJkD9HxumNO504iwLalDg6djXk7AkuaZLTAn?=
 =?us-ascii?Q?hJhqfHyeoYugz5dPvLS45xb6fLV2MQZSP/bl5lDj7KsdMUh4aFP5gBlsSOGp?=
 =?us-ascii?Q?1qGgADvCcA9Gc0ot8hPDwgOOhuVNvmy+ko/LuFItlHgBkDVqUlJtBdBA/d3Y?=
 =?us-ascii?Q?zCa1KYHOQotjazdFmF0woQ5l+nDOs7aHXyMOISsS7GszkY0U+yoqKpbUjTHH?=
 =?us-ascii?Q?8s9HfJQn9W7ldsQhyJmFRvQ3I/OUttCpD/TQoXZ/wfZaiZ5Uxo4EZ9KT7ghi?=
 =?us-ascii?Q?Gd5q7/xByB3mSo9ysSh/o/s5KptVUhwRTs4HwC+8lTgQSGOZ9o6HsypRCXme?=
 =?us-ascii?Q?7wxfgekydw+s9gyARUiQMa/4FVq0ytXu0ig0mmV2Z3u/2GLg9oKQB6qK9X/9?=
 =?us-ascii?Q?FMJhu9ymj+3tvzSjxR0uiPL4DfPquSr9MiIUaB/R2XuipLlgjVlanyzh5hpb?=
 =?us-ascii?Q?1svXl6U2susdlS6qns3SvXZJaZCHfkp+jkWIk5noIySHv2O46umOHHdgsMVo?=
 =?us-ascii?Q?bvzbDnSNZjPT1HL+Fo4UHyRDjaFMQ/yLAbU6Dl25CqPV+e4qizsbFeScmx50?=
 =?us-ascii?Q?AqRrHbMynP3gG2GA5+KiXAyjGCL9zCbC2F4GA02dyM6lWbSbzqbJzjjwbh90?=
 =?us-ascii?Q?fPrrsMwbbqmInAOxYW0Khw6N4dvbwk8Jn/e19PkwNgV5Fk/zw7F63S3Okcru?=
 =?us-ascii?Q?0VxUgt8BYkrH23dphmAfB7azEm1gc/G62h8gnrqVezPC4nVr8chRm3froS1G?=
 =?us-ascii?Q?9Ft55XwycAuEvlFcHhs38ExqFH3UoE5VMZEcQKA+DOzhKq3SJUTcjruGDU8S?=
 =?us-ascii?Q?ttBKV9QlCOPppb3w7hiG8Dn6OwrDddp5ECwFQTS+PZnH2HkleZYZdQ+do3MV?=
 =?us-ascii?Q?yUFi5uAoSJFd161B/8amhuE9H1LXJwqsVLTIHuAUySzUXpR0OHye/eLb/eTb?=
 =?us-ascii?Q?RpgbxQDV9xbVGKSpThohMoWhNO+Y1Z/MZhZrzp8OdCHRHvVvrAMLbDxJip4m?=
 =?us-ascii?Q?X0UrNDWaQ94wSrY7z3vNLC62QP5jj09bhwLQ9xqyus0MZhsH/KJY0+D69ujo?=
 =?us-ascii?Q?lgBBU+bC5d/iXKhz3Ee2QcTj7++3pUPvpG2tiALBDf/g3K5mjcvtaQOhHhvJ?=
 =?us-ascii?Q?4EZwoxOCiK/m9wA78boKXIfpdF+gTgyydn+6MYn7uEdUueS6egYeRbNBiqhM?=
 =?us-ascii?Q?a89izlOTPP4aq+F4HAc2WQOHN/Jv89ZVaGm38inGkrD95gWcWsOg3AFJY7o8?=
 =?us-ascii?Q?Iky4qNrSOpY8PtYJAf7N31AbS0cvMhTnWnlV++bBGvNN9lHkb/IID0KG9ygX?=
 =?us-ascii?Q?l/j1sEVsiJ4KnkzA3A/x9MSp5bx8zyB55a+352dXnChxeYAoDqaX0+457Zf6?=
 =?us-ascii?Q?vh5Qjk0O1hxfKAVQ7iWU7xmfIbKovRWtBO2FvcN7sUaG+EJ7CqdEMUxfDPj+?=
 =?us-ascii?Q?dYrQ2ClTJx+AEVUxDQtvSUWrk826jqKY5fCpgxOmtd3BnoofzFxI2Wc+h3Q5?=
 =?us-ascii?Q?Bd1/45EM+zXoxetQg+0LYtlzF83/8zZwp9WxYW9B+mdizqZBBYhQyniiSv/5?=
 =?us-ascii?Q?CmzDN5X9GidWuoHUhGZnW5xSriIHcOhRAqAnvt9i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eea7e5f2-ed79-4998-ea76-08db71802328
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 11:18:56.5416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: omAQ+hpj6PfagFY9bNDhD2RIlv6+I3lM2zQNwZaig8u4vNtjIfAksc9ztWgCw6DIFo6cn7gLw7YwCo2/lZFK1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9031
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

There are two main use cases for mmu notifiers. One is by KVM which
uses mmu_notifier_invalidate_range_start()/end() to manage a software
TLB.

The other is to manage hardware TLBs which need to use the
invalidate_range() callback because HW can establish new TLB entries
at any time. Hence using start/end() can lead to memory corruption as
these callbacks happen too soon/late during page unmap.

mmu notifier users should therefore either use the start()/end()
callbacks or the invalidate_range() callbacks. To make this usage
clearer rename the invalidate_range() callback to
invalidate_secondary_tlbs() and update documention.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu_v2.c                    | 10 +--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 13 ++--
 drivers/iommu/intel/svm.c                       |  8 +--
 drivers/misc/ocxl/link.c                        |  8 +--
 include/asm-generic/tlb.h                       |  2 +-
 include/linux/mmu_notifier.h                    | 55 +++++++++---------
 mm/huge_memory.c                                |  4 +-
 mm/hugetlb.c                                    | 10 +--
 mm/mmu_notifier.c                               | 52 ++++++++++-------
 mm/rmap.c                                       | 42 +++++++-------
 10 files changed, 110 insertions(+), 94 deletions(-)

diff --git a/drivers/iommu/amd/iommu_v2.c b/drivers/iommu/amd/iommu_v2.c
index 864e4ff..8029e86 100644
--- a/drivers/iommu/amd/iommu_v2.c
+++ b/drivers/iommu/amd/iommu_v2.c
@@ -355,9 +355,9 @@ static struct pasid_state *mn_to_state(struct mmu_notifier *mn)
 	return container_of(mn, struct pasid_state, mn);
 }
 
-static void mn_invalidate_range(struct mmu_notifier *mn,
-				struct mm_struct *mm,
-				unsigned long start, unsigned long end)
+static void mn_invalidate_secondary_tlbs(struct mmu_notifier *mn,
+					struct mm_struct *mm,
+					unsigned long start, unsigned long end)
 {
 	struct pasid_state *pasid_state;
 	struct device_state *dev_state;
@@ -391,8 +391,8 @@ static void mn_release(struct mmu_notifier *mn, struct mm_struct *mm)
 }
 
 static const struct mmu_notifier_ops iommu_mn = {
-	.release		= mn_release,
-	.invalidate_range       = mn_invalidate_range,
+	.release			= mn_release,
+	.invalidate_secondary_tlbs	= mn_invalidate_secondary_tlbs,
 };
 
 static void set_pri_tag_status(struct pasid_state *pasid_state,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index a5a63b1..bf86d9a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -186,9 +186,10 @@ static void arm_smmu_free_shared_cd(struct arm_smmu_ctx_desc *cd)
 	}
 }
 
-static void arm_smmu_mm_invalidate_range(struct mmu_notifier *mn,
-					 struct mm_struct *mm,
-					 unsigned long start, unsigned long end)
+static void arm_smmu_mm_invalidate_secondary_tlbs(struct mmu_notifier *mn,
+						struct mm_struct *mm,
+						unsigned long start,
+						unsigned long end)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
@@ -237,9 +238,9 @@ static void arm_smmu_mmu_notifier_free(struct mmu_notifier *mn)
 }
 
 static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
-	.invalidate_range	= arm_smmu_mm_invalidate_range,
-	.release		= arm_smmu_mm_release,
-	.free_notifier		= arm_smmu_mmu_notifier_free,
+	.invalidate_secondary_tlbs	= arm_smmu_mm_invalidate_secondary_tlbs,
+	.release			= arm_smmu_mm_release,
+	.free_notifier			= arm_smmu_mmu_notifier_free,
 };
 
 /* Allocate or get existing MMU notifier for this {domain, mm} pair */
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index e95b339..0617793 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -219,9 +219,9 @@ static void intel_flush_svm_range(struct intel_svm *svm, unsigned long address,
 }
 
 /* Pages have been freed at this point */
-static void intel_invalidate_range(struct mmu_notifier *mn,
-				   struct mm_struct *mm,
-				   unsigned long start, unsigned long end)
+static void intel_invalidate_secondary_tlbs(struct mmu_notifier *mn,
+					struct mm_struct *mm,
+					unsigned long start, unsigned long end)
 {
 	struct intel_svm *svm = container_of(mn, struct intel_svm, notifier);
 
@@ -256,7 +256,7 @@ static void intel_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 
 static const struct mmu_notifier_ops intel_mmuops = {
 	.release = intel_mm_release,
-	.invalidate_range = intel_invalidate_range,
+	.invalidate_secondary_tlbs = intel_invalidate_secondary_tlbs,
 };
 
 static DEFINE_MUTEX(pasid_mutex);
diff --git a/drivers/misc/ocxl/link.c b/drivers/misc/ocxl/link.c
index 4cf4c55..25712fa 100644
--- a/drivers/misc/ocxl/link.c
+++ b/drivers/misc/ocxl/link.c
@@ -491,9 +491,9 @@ void ocxl_link_release(struct pci_dev *dev, void *link_handle)
 }
 EXPORT_SYMBOL_GPL(ocxl_link_release);
 
-static void invalidate_range(struct mmu_notifier *mn,
-			     struct mm_struct *mm,
-			     unsigned long start, unsigned long end)
+static void invalidate_secondary_tlbs(struct mmu_notifier *mn,
+				struct mm_struct *mm,
+				unsigned long start, unsigned long end)
 {
 	struct pe_data *pe_data = container_of(mn, struct pe_data, mmu_notifier);
 	struct ocxl_link *link = pe_data->link;
@@ -509,7 +509,7 @@ static void invalidate_range(struct mmu_notifier *mn,
 }
 
 static const struct mmu_notifier_ops ocxl_mmu_notifier_ops = {
-	.invalidate_range = invalidate_range,
+	.invalidate_secondary_tlbs = invalidate_secondary_tlbs,
 };
 
 static u64 calculate_cfg_state(bool kernel)
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index b466172..48c81b9 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -456,7 +456,7 @@ static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
 		return;
 
 	tlb_flush(tlb);
-	mmu_notifier_invalidate_range(tlb->mm, tlb->start, tlb->end);
+	mmu_notifier_invalidate_secondary_tlbs(tlb->mm, tlb->start, tlb->end);
 	__tlb_reset_range(tlb);
 }
 
diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 64a3e05..f335c3d 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -187,27 +187,28 @@ struct mmu_notifier_ops {
 				     const struct mmu_notifier_range *range);
 
 	/*
-	 * invalidate_range() is either called between
-	 * invalidate_range_start() and invalidate_range_end() when the
-	 * VM has to free pages that where unmapped, but before the
-	 * pages are actually freed, or outside of _start()/_end() when
-	 * a (remote) TLB is necessary.
+	 * invalidate_secondary_tlbs() is used to manage a non-CPU TLB which
+	 * shares page-tables with the CPU. The invalidate_range_start()/end()
+	 * callbacks should not be implemented as invalidate_secondary_tlbs()
+	 * already catches the points in time when an external TLB needs to be
+	 * flushed.
 	 *
-	 * If invalidate_range() is used to manage a non-CPU TLB with
-	 * shared page-tables, it not necessary to implement the
-	 * invalidate_range_start()/end() notifiers, as
-	 * invalidate_range() already catches the points in time when an
-	 * external TLB range needs to be flushed. For more in depth
-	 * discussion on this see Documentation/mm/mmu_notifier.rst
+	 * This requires invalidate_secondary_tlbs() to be called while holding
+	 * the ptl spin-lock and therefore this callback is not allowed to
+	 * sleep.
 	 *
-	 * Note that this function might be called with just a sub-range
-	 * of what was passed to invalidate_range_start()/end(), if
-	 * called between those functions.
+	 * This callback is called whenever a PTE is downgraded (for example
+	 * when write permission is revoked or a present PTE is set to
+	 * invalid/non-present). It is assumed that any secondary TLB has the
+	 * same rules for when invalidations are required as the main CPU
+	 * architecture so much like for CPU TLB invalidation it is up to
+	 * architecture code to call this if invalidations are required in other
+	 * situations (for example permission upgrades).
 	 */
-	void (*invalidate_range)(struct mmu_notifier *subscription,
-				 struct mm_struct *mm,
-				 unsigned long start,
-				 unsigned long end);
+	void (*invalidate_secondary_tlbs)(struct mmu_notifier *subscription,
+					struct mm_struct *mm,
+					unsigned long start,
+					unsigned long end);
 
 	/*
 	 * These callbacks are used with the get/put interface to manage the
@@ -397,8 +398,8 @@ extern void __mmu_notifier_change_pte(struct mm_struct *mm,
 extern int __mmu_notifier_invalidate_range_start(struct mmu_notifier_range *r);
 extern void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *r,
 				  bool only_end);
-extern void __mmu_notifier_invalidate_range(struct mm_struct *mm,
-				  unsigned long start, unsigned long end);
+extern void __mmu_notifier_invalidate_secondary_tlbs(struct mm_struct *mm,
+					unsigned long start, unsigned long end);
 extern bool
 mmu_notifier_range_update_to_read_only(const struct mmu_notifier_range *range);
 
@@ -491,11 +492,11 @@ mmu_notifier_invalidate_range_only_end(struct mmu_notifier_range *range)
 		__mmu_notifier_invalidate_range_end(range, true);
 }
 
-static inline void mmu_notifier_invalidate_range(struct mm_struct *mm,
-				  unsigned long start, unsigned long end)
+static inline void mmu_notifier_invalidate_secondary_tlbs(struct mm_struct *mm,
+					unsigned long start, unsigned long end)
 {
 	if (mm_has_notifiers(mm))
-		__mmu_notifier_invalidate_range(mm, start, end);
+		__mmu_notifier_invalidate_secondary_tlbs(mm, start, end);
 }
 
 static inline void mmu_notifier_subscriptions_init(struct mm_struct *mm)
@@ -589,7 +590,7 @@ static inline void mmu_notifier_range_init_owner(
 	pte_t ___pte;							\
 									\
 	___pte = ptep_clear_flush(__vma, __address, __ptep);		\
-	mmu_notifier_invalidate_range(___mm, ___addr,			\
+	mmu_notifier_invalidate_secondary_tlbs(___mm, ___addr,		\
 					___addr + PAGE_SIZE);		\
 									\
 	___pte;								\
@@ -602,7 +603,7 @@ static inline void mmu_notifier_range_init_owner(
 	pmd_t ___pmd;							\
 									\
 	___pmd = pmdp_huge_clear_flush(__vma, __haddr, __pmd);		\
-	mmu_notifier_invalidate_range(___mm, ___haddr,			\
+	mmu_notifier_invalidate_secondary_tlbs(___mm, ___haddr,		\
 				      ___haddr + HPAGE_PMD_SIZE);	\
 									\
 	___pmd;								\
@@ -615,7 +616,7 @@ static inline void mmu_notifier_range_init_owner(
 	pud_t ___pud;							\
 									\
 	___pud = pudp_huge_clear_flush(__vma, __haddr, __pud);		\
-	mmu_notifier_invalidate_range(___mm, ___haddr,			\
+	mmu_notifier_invalidate_secondary_tlbs(___mm, ___haddr,		\
 				      ___haddr + HPAGE_PUD_SIZE);	\
 									\
 	___pud;								\
@@ -716,7 +717,7 @@ mmu_notifier_invalidate_range_only_end(struct mmu_notifier_range *range)
 {
 }
 
-static inline void mmu_notifier_invalidate_range(struct mm_struct *mm,
+static inline void mmu_notifier_invalidate_secondary_tlbs(struct mm_struct *mm,
 				  unsigned long start, unsigned long end)
 {
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e94fe29..8d4fafd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2124,8 +2124,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	if (is_huge_zero_pmd(*pmd)) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
-		 * mmu_notifier_invalidate_range() see comments below inside
-		 * __split_huge_pmd() ?
+		 * mmu_notifier_invalidate_secondary_tlbs() see comments below
+		 * inside __split_huge_pmd() ?
 		 *
 		 * We are going from a zero huge page write protected to zero
 		 * small page also write protected so it does not seems useful
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d765744..4bd0fb5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5690,7 +5690,8 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
 
 		/* Break COW or unshare */
 		huge_ptep_clear_flush(vma, haddr, ptep);
-		mmu_notifier_invalidate_range(mm, range.start, range.end);
+		mmu_notifier_invalidate_secondary_tlbs(mm, range.start,
+						range.end);
 		page_remove_rmap(&old_folio->page, vma, true);
 		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
 		if (huge_pte_uffd_wp(pte))
@@ -6822,8 +6823,9 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 	else
 		flush_hugetlb_tlb_range(vma, start, end);
 	/*
-	 * No need to call mmu_notifier_invalidate_range() we are downgrading
-	 * page table protection not changing it to point to a new page.
+	 * No need to call mmu_notifier_invalidate_secondary_tlbs() we are
+	 * downgrading page table protection not changing it to point to a new
+	 * page.
 	 *
 	 * See Documentation/mm/mmu_notifier.rst
 	 */
@@ -7462,7 +7464,7 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
 	hugetlb_vma_unlock_write(vma);
 	/*
-	 * No need to call mmu_notifier_invalidate_range(), see
+	 * No need to call mmu_notifier_invalidate_secondary_tlbs(), see
 	 * Documentation/mm/mmu_notifier.rst.
 	 */
 	mmu_notifier_invalidate_range_end(&range);
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 50c0dde..2b62bd9 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -207,7 +207,7 @@ mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
 	 *    spin_lock
 	 *     seq = ++subscriptions->invalidate_seq
 	 *    spin_unlock
-	 *     op->invalidate_range():
+	 *     op->invalidate_secondary_tlbs():
 	 *       user_lock
 	 *        mmu_interval_set_seq()
 	 *         interval_sub->invalidate_seq = seq
@@ -560,23 +560,23 @@ mn_hlist_invalidate_end(struct mmu_notifier_subscriptions *subscriptions,
 	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
 		/*
-		 * Call invalidate_range here too to avoid the need for the
-		 * subsystem of having to register an invalidate_range_end
-		 * call-back when there is invalidate_range already. Usually a
-		 * subsystem registers either invalidate_range_start()/end() or
-		 * invalidate_range(), so this will be no additional overhead
-		 * (besides the pointer check).
+		 * Subsystems should register either invalidate_secondary_tlbs()
+		 * or invalidate_range_start()/end() callbacks.
 		 *
-		 * We skip call to invalidate_range() if we know it is safe ie
-		 * call site use mmu_notifier_invalidate_range_only_end() which
-		 * is safe to do when we know that a call to invalidate_range()
-		 * already happen under page table lock.
+		 * We call invalidate_secondary_tlbs() here so that subsystems
+		 * can use larger range based invalidations. In some cases
+		 * though invalidate_secondary_tlbs() needs to be called while
+		 * holding the page table lock. In that case call sites use
+		 * mmu_notifier_invalidate_range_only_end() and we know it is
+		 * safe to skip secondary TLB invalidation as it will have
+		 * already been done.
 		 */
-		if (!only_end && subscription->ops->invalidate_range)
-			subscription->ops->invalidate_range(subscription,
-							    range->mm,
-							    range->start,
-							    range->end);
+		if (!only_end && subscription->ops->invalidate_secondary_tlbs)
+			subscription->ops->invalidate_secondary_tlbs(
+				subscription,
+				range->mm,
+				range->start,
+				range->end);
 		if (subscription->ops->invalidate_range_end) {
 			if (!mmu_notifier_range_blockable(range))
 				non_block_start();
@@ -604,8 +604,8 @@ void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *range,
 	lock_map_release(&__mmu_notifier_invalidate_range_start_map);
 }
 
-void __mmu_notifier_invalidate_range(struct mm_struct *mm,
-				  unsigned long start, unsigned long end)
+void __mmu_notifier_invalidate_secondary_tlbs(struct mm_struct *mm,
+					unsigned long start, unsigned long end)
 {
 	struct mmu_notifier *subscription;
 	int id;
@@ -614,9 +614,10 @@ void __mmu_notifier_invalidate_range(struct mm_struct *mm,
 	hlist_for_each_entry_rcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
-		if (subscription->ops->invalidate_range)
-			subscription->ops->invalidate_range(subscription, mm,
-							    start, end);
+		if (subscription->ops->invalidate_secondary_tlbs)
+			subscription->ops->invalidate_secondary_tlbs(
+				subscription, mm,
+				start, end);
 	}
 	srcu_read_unlock(&srcu, id);
 }
@@ -635,6 +636,15 @@ int __mmu_notifier_register(struct mmu_notifier *subscription,
 	mmap_assert_write_locked(mm);
 	BUG_ON(atomic_read(&mm->mm_users) <= 0);
 
+	/*
+	 * Subsystems should only register for invalidate_secondary_tlbs() or
+	 * invalidate_range_start()/end() callbacks, not both.
+	 */
+	if (WARN_ON_ONCE(subscription->ops->invalidate_secondary_tlbs &&
+				(subscription->ops->invalidate_range_start ||
+				subscription->ops->invalidate_range_end)))
+		return -EINVAL;
+
 	if (!mm->notifier_subscriptions) {
 		/*
 		 * kmalloc cannot be called under mm_take_all_locks(), but we
diff --git a/mm/rmap.c b/mm/rmap.c
index ae2b817..e26357a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -991,9 +991,9 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
 		}
 
 		/*
-		 * No need to call mmu_notifier_invalidate_range() as we are
-		 * downgrading page table protection not changing it to point
-		 * to a new page.
+		 * No need to call mmu_notifier_invalidate_secondary_tlbs() as
+		 * we are downgrading page table protection not changing it to
+		 * point to a new page.
 		 *
 		 * See Documentation/mm/mmu_notifier.rst
 		 */
@@ -1554,8 +1554,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 					hugetlb_vma_unlock_write(vma);
 					flush_tlb_range(vma,
 						range.start, range.end);
-					mmu_notifier_invalidate_range(mm,
-						range.start, range.end);
+					mmu_notifier_invalidate_secondary_tlbs(
+						mm, range.start, range.end);
 					/*
 					 * The ref count of the PMD page was
 					 * dropped which is part of the way map
@@ -1629,7 +1629,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(&folio->page));
 			/* We have to invalidate as we cleared the pte */
-			mmu_notifier_invalidate_range(mm, address,
+			mmu_notifier_invalidate_secondary_tlbs(mm, address,
 						      address + PAGE_SIZE);
 		} else if (folio_test_anon(folio)) {
 			swp_entry_t entry = { .val = page_private(subpage) };
@@ -1643,7 +1643,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				WARN_ON_ONCE(1);
 				ret = false;
 				/* We have to invalidate as we cleared the pte */
-				mmu_notifier_invalidate_range(mm, address,
+				mmu_notifier_invalidate_secondary_tlbs(mm,
+							address,
 							address + PAGE_SIZE);
 				page_vma_mapped_walk_done(&pvmw);
 				break;
@@ -1676,8 +1677,9 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				if (ref_count == 1 + map_count &&
 				    !folio_test_dirty(folio)) {
 					/* Invalidate as we cleared the pte */
-					mmu_notifier_invalidate_range(mm,
-						address, address + PAGE_SIZE);
+					mmu_notifier_invalidate_secondary_tlbs(
+						mm, address,
+						address + PAGE_SIZE);
 					dec_mm_counter(mm, MM_ANONPAGES);
 					goto discard;
 				}
@@ -1733,7 +1735,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				swp_pte = pte_swp_mkuffd_wp(swp_pte);
 			set_pte_at(mm, address, pvmw.pte, swp_pte);
 			/* Invalidate as we cleared the pte */
-			mmu_notifier_invalidate_range(mm, address,
+			mmu_notifier_invalidate_secondary_tlbs(mm, address,
 						      address + PAGE_SIZE);
 		} else {
 			/*
@@ -1751,9 +1753,9 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 discard:
 		/*
-		 * No need to call mmu_notifier_invalidate_range() it has be
-		 * done above for all cases requiring it to happen under page
-		 * table lock before mmu_notifier_invalidate_range_end()
+		 * No need to call mmu_notifier_invalidate_secondary_tlbs() it
+		 * has be done above for all cases requiring it to happen under
+		 * page table lock before mmu_notifier_invalidate_range_end()
 		 *
 		 * See Documentation/mm/mmu_notifier.rst
 		 */
@@ -1935,8 +1937,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 					hugetlb_vma_unlock_write(vma);
 					flush_tlb_range(vma,
 						range.start, range.end);
-					mmu_notifier_invalidate_range(mm,
-						range.start, range.end);
+					mmu_notifier_invalidate_secondary_tlbs(
+						mm, range.start, range.end);
 
 					/*
 					 * The ref count of the PMD page was
@@ -2042,8 +2044,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(&folio->page));
 			/* We have to invalidate as we cleared the pte */
-			mmu_notifier_invalidate_range(mm, address,
-						      address + PAGE_SIZE);
+			mmu_notifier_invalidate_secondary_tlbs(mm, address,
+							address + PAGE_SIZE);
 		} else {
 			swp_entry_t entry;
 			pte_t swp_pte;
@@ -2108,9 +2110,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		/*
-		 * No need to call mmu_notifier_invalidate_range() it has be
-		 * done above for all cases requiring it to happen under page
-		 * table lock before mmu_notifier_invalidate_range_end()
+		 * No need to call mmu_notifier_invalidate_secondary_tlbs() it
+		 * has be done above for all cases requiring it to happen under
+		 * page table lock before mmu_notifier_invalidate_range_end()
 		 *
 		 * See Documentation/mm/mmu_notifier.rst
 		 */
-- 
git-series 0.9.1
