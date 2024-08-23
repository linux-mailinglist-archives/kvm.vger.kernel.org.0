Return-Path: <kvm+bounces-24910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07CA095CDE7
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:31:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B36F028766D
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C57FF4430;
	Fri, 23 Aug 2024 13:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pm90g5FT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBABB185E7B;
	Fri, 23 Aug 2024 13:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419860; cv=fail; b=tpuSRyXFpMQc40atQEcFqKYySMM7Xf52c+QQxCSzgd5lpRSdZJadJH3Fh69/3oSmRd72ElB61KYpm1D/RRiNMgQ+7trnNLvRFfiK+EGjtJ2CVPzKVXydPoDP925FyBPFt4QFMKt9bXl93trp+icIq1xyumC2gHu3TaZi9ocpv20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419860; c=relaxed/simple;
	bh=1PdVvqTTQiawto8WRPUw4+MVMTiaBL3dtz7IyHNMjWs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D9NoGVXQpVMZz+6uaRn35Vihu5C+PVrIS8LRPWw3LHADqi44HnM/ct+kqa8/yvDUEp0NWiJVqlnRWIVVZj3QE4ff3yWdX0KcdGMtb6+BzmO20exC4oG4jMZpXCi/fvyKAa1I41I0dSeySVz7WUnSnlXg3NJkvqXdnh0euhzLve4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pm90g5FT; arc=fail smtp.client-ip=40.107.243.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v4CM8LG8omuYyBu0UJZW9oyZLVE9ndGsgJTkOskWdAuWHrMxx/jjeiAr0CHMkkxqBhdLDjSlIiV3k2NvwI4KhcvUUK8+sNfrtYAr9Z7iKiWL6eupdjVuLD2XGTf+1gqmeFrHh2VA8rDp+FFDlTneIEpy5b/ip2F/JOsOG94A6wPOVzNIyvCNSZ0djt5JQLgg1NBzvaX0N8CXR8eli9dp9aOwR21gnncXjmS4yFl9fyho/W6seKOHjI33MV4bwBzKes543TvJwYeCKhicc/UNnhK9kSFDNj78AOB7CnMZd3OJvlzKuaqVv1vzo3FJ9gD9Gd5tYVgsFVtiJPj9RQ5+SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=751M99Ode88aicLdMFZcQLcGHZcQ8RoMhlZwSfgzg7g=;
 b=RDIt2eV9vmG6NrrFfsdGiosfQNoaguT3gKfIbXYqyekafXwbGMpngsVvbU5iDBMlCu6sMrQQwCHQMuzilhiNUSACLmvAZAPzwYIMPnPhFdCrYBpce6g/+bnIgKfnz1XBpwZCVXa5K2y6dUzWueFl+CXurq1uSjkAGBrs6HE9iqBie9yotHOT+W1epIJP8VOXZzbRwCDgQuIWgHBY/9evVSSSIv45F1HTnMlHuCYu4H7E4YoZUsgVsU8n/PXaOG3CFXVt08PP9bE/nZXDdaJtlKY9qdeBcmTx1vsqHNSUzqNiekN2OHsYSTpJ6cHbx6uAJSYZPWN5BlmPa5TfiTXjDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=751M99Ode88aicLdMFZcQLcGHZcQ8RoMhlZwSfgzg7g=;
 b=pm90g5FT2eZcKAPEvMrCmQ3938CyPyHV7qILjYAJ4wtu5lsiQ6kOMFjGTjl2cn6JbtUSckUGrmB8ND3H3fns15qLlbE1JNt6Y+9ln5WTR/bZ04R6heisdS8+ZTH0A1MoyWX+IoT+YNTcyNAxWzRId7TQ2SboDXsb5KuuaJJAwzs=
Received: from DM6PR13CA0028.namprd13.prod.outlook.com (2603:10b6:5:bc::41) by
 CH3PR12MB9026.namprd12.prod.outlook.com (2603:10b6:610:125::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Fri, 23 Aug
 2024 13:30:53 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:5:bc:cafe::fa) by DM6PR13CA0028.outlook.office365.com
 (2603:10b6:5:bc::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23 via Frontend
 Transport; Fri, 23 Aug 2024 13:30:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:30:52 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:30:46 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Date: Fri, 23 Aug 2024 23:21:26 +1000
Message-ID: <20240823132137.336874-13-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|CH3PR12MB9026:EE_
X-MS-Office365-Filtering-Correlation-Id: b6d15ce0-f018-4ae4-f3b6-08dcc377cf69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VUypz3XUQHluMCuYeJYYurKBWQkfFAB4Z4MdBVY8ZldKs9GLrVgj4Uy/C2kt?=
 =?us-ascii?Q?RyQUiHb/ak08knUKx83zmaUNtQvn/4JSy7qXDSzkae2yjcu7Pj9tZGGKNVIc?=
 =?us-ascii?Q?hjZtxgZ81wDDKOMzeXz0CF5s6QBJTpqeNtTiTJaFPM9GD+9T+8gbkrXN+9ek?=
 =?us-ascii?Q?dv3mKYPpgn4ys5+eCreDkvEW14FtpDpBVLo3f3solPKVRBt4G9hywIwB/PUy?=
 =?us-ascii?Q?SbxO/wEx0HqTCZKZl6OcqD+igSy3tDaACCdjIJmhMaypB+S4/nn8tyeqFKcj?=
 =?us-ascii?Q?DRXVsQ3/ucl9FziaSSMMzXZe3FJiPsLE5HGoRhgmnoYj1hXrQkcD/91WV9Zz?=
 =?us-ascii?Q?/apil2+aui9Mqv3PFN+TYd90kkb2q1pAV86Dr/xirTYaRLU//DgGc7iMYtiG?=
 =?us-ascii?Q?Uj5h9Y93uuRFsYzscK2wsmr0ebjWi7bwGvJZJLyjh/iGNvXFkopxzfHNjik3?=
 =?us-ascii?Q?+LvFi3/cWXqzLs7k7N1QLxf2kBViOzrS5zk40yvrWIxM118Cm5tZijbkRDbg?=
 =?us-ascii?Q?qCWty3b9mggtFnazJgSRMb7nxFNf9YV2MYDBw5wVR606h/ynIBttoct7qjsn?=
 =?us-ascii?Q?8+1Zsg39OD5xhk2Uv2UfLURJrDWzXijWr2yOQ/3taSAQ5nMuFcV3/9cI1+lu?=
 =?us-ascii?Q?Vo71qwa/LPOCJWjMuXMroj1KXzQm8LwPs21VemDtwvVeS2HU5Ud9mzB/JVBp?=
 =?us-ascii?Q?ZBbXhqG0QOgHxAw2k7zyMa1BHsY8GZbsK4OxLJqU05Fq3CSvxcqnjzQagHBx?=
 =?us-ascii?Q?6EoarQB7TCgVLFT+/iGij9ygSpJQlGf8tPg/qzL+e2gvOiyIVAWtNMr2zqy3?=
 =?us-ascii?Q?E7FyteMzr/EBr3TBU61c2rIuUFdUa10S2FXqGgjsbqV7JxhVYdAYa2v7dnhW?=
 =?us-ascii?Q?iGJzXiz9kZoz3qHxvqTsvW5kXaS/n/9jUen6NHnRpHxRbwHybMo3WF/bajq/?=
 =?us-ascii?Q?5YBdFz31PmYr/3U2k1RkEw/AazA+GH7SeAVbKuq/LhyHKTqqYZdNP/fHrmL4?=
 =?us-ascii?Q?CxOHcRtuX9e4QKb4DQWYIH0wZhNtNnq1Y+o35pGoflXiPaASQBKYSqaE8TG3?=
 =?us-ascii?Q?CtvCTzHh844rnYlOL7D5icU6mcmWn1WF/0MbHS0Oya208WgXTXonegxZi0IA?=
 =?us-ascii?Q?xCs8lfvFVHJFujs9pbMpGVvYFmH5/xgZOGJdEAqgjOweA861U5eBA9NfbEJt?=
 =?us-ascii?Q?JVwsp1+IqqlXRITAuOHb2wgDfq5c0VZB/Mb+S2Dmz0/OU7dcWVCJt5WKiJDr?=
 =?us-ascii?Q?wkm7QayvrbfWrwpUWQ5+BKW5DhsYjhM2LlvFBvLjkCWato3B5DVL/BE50p2z?=
 =?us-ascii?Q?Gq3Mfuo4AnIjJw43CRtTszh/2RUu9FHp+MC7whEwAoMduOKuUA5dT5EznU86?=
 =?us-ascii?Q?4GlroOfxPESEf1L5XZ94JVWsSP6lybP/xzbmNkELP0IkUgitXn0Sp8IIFq06?=
 =?us-ascii?Q?A9DPGENCDR2ZEoH0pvwBsmypFFd/9vGK?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:30:52.7025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d15ce0-f018-4ae4-f3b6-08dcc377cf69
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9026

IOMMUFD calls get_user_pages() for every mapping which will allocate
shared memory instead of using private memory managed by the KVM and
MEMFD.

Add support for IOMMUFD fd to the VFIO KVM device's KVM_DEV_VFIO_FILE API
similar to already existing VFIO device and VFIO group fds.
This addition registers the KVM in IOMMUFD with a callback to get a pfn
for guest private memory for mapping it later in the IOMMU.
No callback for free as it is generic folio_put() for now.

The aforementioned callback uses uptr to calculate the offset into
the KVM memory slot and find private backing pfn, copies
kvm_gmem_get_pfn() pretty much.

This relies on private pages to be pinned beforehand.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/iommu/iommufd/io_pagetable.h    |  3 +
 drivers/iommu/iommufd/iommufd_private.h |  4 +
 include/linux/iommufd.h                 |  6 ++
 include/linux/kvm_host.h                | 66 ++++++++++++++
 drivers/iommu/iommufd/io_pagetable.c    |  2 +
 drivers/iommu/iommufd/main.c            | 21 +++++
 drivers/iommu/iommufd/pages.c           | 94 +++++++++++++++++---
 virt/kvm/guest_memfd.c                  | 40 +++++++++
 virt/kvm/vfio.c                         | 58 ++++++++++--
 9 files changed, 275 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index 0ec3509b7e33..fc9239fc94c0 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -204,6 +204,9 @@ struct iopt_pages {
 	struct rb_root_cached access_itree;
 	/* Of iopt_area::pages_node */
 	struct rb_root_cached domains_itree;
+
+	struct kvm *kvm;
+	gmem_pin_t gmem_pin;
 };
 
 struct iopt_pages *iopt_alloc_pages(void __user *uptr, unsigned long length,
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 92efe30a8f0d..bd5573ddcd9c 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -10,6 +10,7 @@
 #include <linux/uaccess.h>
 #include <linux/iommu.h>
 #include <linux/iova_bitmap.h>
+#include <linux/iommufd.h>
 #include <uapi/linux/iommufd.h>
 #include "../iommu-priv.h"
 
@@ -28,6 +29,9 @@ struct iommufd_ctx {
 	/* Compatibility with VFIO no iommu */
 	u8 no_iommu_mode;
 	struct iommufd_ioas *vfio_ioas;
+
+	struct kvm *kvm;
+	gmem_pin_t gmem_pin;
 };
 
 /*
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index ffc3a949f837..a990f604c044 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/err.h>
+#include <linux/kvm_types.h>
 
 struct device;
 struct iommufd_device;
@@ -57,6 +58,11 @@ void iommufd_ctx_get(struct iommufd_ctx *ictx);
 #if IS_ENABLED(CONFIG_IOMMUFD)
 struct iommufd_ctx *iommufd_ctx_from_file(struct file *file);
 struct iommufd_ctx *iommufd_ctx_from_fd(int fd);
+bool iommufd_file_is_valid(struct file *file);
+typedef int (*gmem_pin_t)(struct kvm *kvm, void __user *uptr, gfn_t *gfn,
+			  kvm_pfn_t *pfn, int *max_order);
+void iommufd_file_set_kvm(struct file *file, struct kvm *kvm,
+			  gmem_pin_t gmem_pin);
 void iommufd_ctx_put(struct iommufd_ctx *ictx);
 bool iommufd_ctx_has_group(struct iommufd_ctx *ictx, struct iommu_group *group);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fdb331b3e0d3..a09a346ba3ca 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1297,6 +1297,7 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
+struct kvm_memory_slot *uptr_to_memslot(struct kvm *kvm, void __user *uptr);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
@@ -1713,6 +1714,22 @@ try_get_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 		return NULL;
 }
 
+static inline struct kvm_memory_slot *
+try_get_memslot_uptr(struct kvm_memory_slot *slot, void __user *uptr)
+{
+	unsigned long base_upn;
+	unsigned long upn = (unsigned long) uptr >> PAGE_SHIFT;
+
+	if (!slot)
+		return NULL;
+
+	base_upn = slot->userspace_addr >> PAGE_SHIFT;
+	if (upn >= base_upn && upn < base_upn + slot->npages)
+		return slot;
+	else
+		return NULL;
+}
+
 /*
  * Returns a pointer to the memslot that contains gfn. Otherwise returns NULL.
  *
@@ -1741,6 +1758,22 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, bool approx)
 	return approx ? slot : NULL;
 }
 
+static inline struct kvm_memory_slot *
+search_memslots_uptr(struct kvm_memslots *slots, void __user *uptr)
+{
+	unsigned long upn = (unsigned long) uptr >> PAGE_SHIFT;
+	struct kvm_memslot_iter iter;
+
+	kvm_for_each_memslot_in_gfn_range(&iter, slots, 0, 512ULL * SZ_1T) {
+		struct kvm_memory_slot *slot = iter.slot;
+		unsigned long base_upn = slot->userspace_addr >> PAGE_SHIFT;
+
+		if (upn >= base_upn && upn < base_upn + slot->npages)
+			return slot;
+	}
+	return NULL;
+}
+
 static inline struct kvm_memory_slot *
 ____gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn, bool approx)
 {
@@ -1760,6 +1793,25 @@ ____gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn, bool approx)
 	return NULL;
 }
 
+static inline struct kvm_memory_slot *
+____uptr_to_memslot(struct kvm_memslots *slots, void __user *uptr)
+{
+	struct kvm_memory_slot *slot;
+
+	slot = (struct kvm_memory_slot *)atomic_long_read(&slots->last_used_slot);
+	slot = try_get_memslot_uptr(slot, uptr);
+	if (slot)
+		return slot;
+
+	slot = search_memslots_uptr(slots, uptr);
+	if (slot) {
+		atomic_long_set(&slots->last_used_slot, (unsigned long)slot);
+		return slot;
+	}
+
+	return NULL;
+}
+
 /*
  * __gfn_to_memslot() and its descendants are here to allow arch code to inline
  * the lookups in hot paths.  gfn_to_memslot() itself isn't here as an inline
@@ -1771,6 +1823,12 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 	return ____gfn_to_memslot(slots, gfn, false);
 }
 
+static inline struct kvm_memory_slot *
+__uptr_to_memslot(struct kvm_memslots *slots, void __user *uptr)
+{
+	return ____uptr_to_memslot(slots, uptr);
+}
+
 static inline unsigned long
 __gfn_to_hva_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
@@ -2446,6 +2504,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+int kvm_gmem_uptr_to_pfn(struct kvm *kvm, void __user *uptr, gfn_t *gfn,
+			 kvm_pfn_t *pfn, int *max_order);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2454,6 +2514,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+static inline int kvm_gmem_uptr_to_pfn(struct kvm *kvm, void __user *uptr, gfn_t *gfn,
+				       kvm_pfn_t *pfn, int *max_order)
+{
+	KVM_BUG_ON(1, kvm);
+	return -EIO;
+}
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 05fd9d3abf1b..aa7584d4a2b8 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -412,6 +412,8 @@ int iopt_map_user_pages(struct iommufd_ctx *ictx, struct io_pagetable *iopt,
 		elm.pages->account_mode = IOPT_PAGES_ACCOUNT_MM;
 	elm.start_byte = uptr - elm.pages->uptr;
 	elm.length = length;
+	elm.pages->kvm = ictx->kvm;
+	elm.pages->gmem_pin = ictx->gmem_pin;
 	list_add(&elm.next, &pages_list);
 
 	rc = iopt_map_pages(iopt, &pages_list, length, iova, iommu_prot, flags);
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 83bbd7c5d160..b6039f7c1cce 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -17,6 +17,7 @@
 #include <linux/bug.h>
 #include <uapi/linux/iommufd.h>
 #include <linux/iommufd.h>
+#include <linux/kvm_host.h>
 
 #include "io_pagetable.h"
 #include "iommufd_private.h"
@@ -488,6 +489,26 @@ struct iommufd_ctx *iommufd_ctx_from_fd(int fd)
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_ctx_from_fd, IOMMUFD);
 
+bool iommufd_file_is_valid(struct file *file)
+{
+	return file->f_op == &iommufd_fops;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_file_is_valid, IOMMUFD);
+
+void iommufd_file_set_kvm(struct file *file, struct kvm *kvm, gmem_pin_t gmem_pin)
+{
+	struct iommufd_ctx *ictx = iommufd_ctx_from_file(file);
+
+	if (WARN_ON(!ictx))
+		return;
+
+	ictx->kvm = kvm;
+	ictx->gmem_pin = gmem_pin;
+
+	iommufd_ctx_put(ictx);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_file_set_kvm, IOMMUFD);
+
 /**
  * iommufd_ctx_put - Put back a reference
  * @ictx: Context to put back
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 117f644a0c5b..d85b6969d9ea 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -52,6 +52,8 @@
 #include <linux/highmem.h>
 #include <linux/kthread.h>
 #include <linux/iommufd.h>
+#include <linux/kvm_host.h>
+#include <linux/pagemap.h>
 
 #include "io_pagetable.h"
 #include "double_span.h"
@@ -622,6 +624,33 @@ static void batch_from_pages(struct pfn_batch *batch, struct page **pages,
 			break;
 }
 
+static void memfd_unpin_user_page_range_dirty_lock(struct page *page,
+						   unsigned long npages,
+						   bool make_dirty)
+{
+	unsigned long i, nr;
+
+	for (i = 0; i < npages; i += nr) {
+		struct page *next = nth_page(page, i);
+		struct folio *folio = page_folio(next);
+
+		if (folio_test_large(folio))
+			nr = min_t(unsigned int, npages - i,
+				   folio_nr_pages(folio) -
+				   folio_page_idx(folio, next));
+		else
+			nr = 1;
+
+		if (make_dirty && !folio_test_dirty(folio)) {
+			// FIXME: do we need this? private memory does not swap
+			folio_lock(folio);
+			folio_mark_dirty(folio);
+			folio_unlock(folio);
+		}
+		folio_put(folio);
+	}
+}
+
 static void batch_unpin(struct pfn_batch *batch, struct iopt_pages *pages,
 			unsigned int first_page_off, size_t npages)
 {
@@ -638,9 +667,14 @@ static void batch_unpin(struct pfn_batch *batch, struct iopt_pages *pages,
 		size_t to_unpin = min_t(size_t, npages,
 					batch->npfns[cur] - first_page_off);
 
-		unpin_user_page_range_dirty_lock(
-			pfn_to_page(batch->pfns[cur] + first_page_off),
-			to_unpin, pages->writable);
+		if (pages->kvm)
+			memfd_unpin_user_page_range_dirty_lock(
+				pfn_to_page(batch->pfns[cur] + first_page_off),
+				to_unpin, pages->writable);
+		else
+			unpin_user_page_range_dirty_lock(
+				pfn_to_page(batch->pfns[cur] + first_page_off),
+				to_unpin, pages->writable);
 		iopt_pages_sub_npinned(pages, to_unpin);
 		cur++;
 		first_page_off = 0;
@@ -777,17 +811,51 @@ static int pfn_reader_user_pin(struct pfn_reader_user *user,
 		return -EFAULT;
 
 	uptr = (uintptr_t)(pages->uptr + start_index * PAGE_SIZE);
-	if (!remote_mm)
-		rc = pin_user_pages_fast(uptr, npages, user->gup_flags,
-					 user->upages);
-	else {
-		if (!user->locked) {
-			mmap_read_lock(pages->source_mm);
-			user->locked = 1;
+
+	if (pages->kvm) {
+		if (WARN_ON(!pages->gmem_pin))
+			return -EFAULT;
+
+		rc = 0;
+		for (unsigned long i = 0; i < npages; ++i, uptr += PAGE_SIZE) {
+			gfn_t gfn = 0;
+			kvm_pfn_t pfn = 0;
+			int max_order = 0, rc1;
+
+			rc1 = pages->gmem_pin(pages->kvm, (void *) uptr,
+					      &gfn, &pfn, &max_order);
+			if (rc1 == -EINVAL && i == 0) {
+				pr_err_once("Must be vfio mmio at gfn=%llx pfn=%llx, skipping\n",
+					    gfn, pfn);
+				goto the_usual;
+			}
+
+			if (rc1) {
+				pr_err("%s: %d %ld %lx -> %lx\n", __func__,
+				       rc1, i, (unsigned long) uptr, (unsigned long) pfn);
+				rc = rc1;
+				break;
+			}
+
+			user->upages[i] = pfn_to_page(pfn);
+		}
+
+		if (!rc)
+			rc = npages;
+	} else {
+the_usual:
+		if (!remote_mm) {
+			rc = pin_user_pages_fast(uptr, npages, user->gup_flags,
+						 user->upages);
+		} else {
+			if (!user->locked) {
+				mmap_read_lock(pages->source_mm);
+				user->locked = 1;
+			}
+			rc = pin_user_pages_remote(pages->source_mm, uptr, npages,
+						   user->gup_flags, user->upages,
+						   &user->locked);
 		}
-		rc = pin_user_pages_remote(pages->source_mm, uptr, npages,
-					   user->gup_flags, user->upages,
-					   &user->locked);
 	}
 	if (rc <= 0) {
 		if (WARN_ON(!rc))
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index e930014b4bdc..07ff561208fd 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -659,6 +659,46 @@ __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 	return folio;
 }
 
+int kvm_gmem_uptr_to_pfn(struct kvm *kvm, void __user *uptr, gfn_t *gfn,
+			 kvm_pfn_t *pfn, int *max_order)
+{
+	struct kvm_memory_slot *slot = __uptr_to_memslot(kvm_memslots(kvm),
+							 uptr);
+	bool is_prepared = false;
+	unsigned long upn_off;
+	struct folio *folio;
+	struct file *file;
+	int r;
+
+	if (!slot)
+		return -EFAULT;
+
+	file = kvm_gmem_get_file(slot);
+	if (!file)
+		return -EFAULT;
+
+	upn_off = ((unsigned long) uptr - slot->userspace_addr) >> PAGE_SHIFT;
+	*gfn = slot->base_gfn + upn_off;
+
+	folio = __kvm_gmem_get_pfn(file, slot, *gfn, pfn, &is_prepared, max_order, true);
+	if (IS_ERR(folio)) {
+		r = PTR_ERR(folio);
+		goto out;
+	}
+
+	if (!is_prepared)
+		r = kvm_gmem_prepare_folio(kvm, slot, *gfn, folio);
+
+	folio_unlock(folio);
+	if (r < 0)
+		folio_put(folio);
+
+out:
+	fput(file);
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_uptr_to_pfn);
+
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index a4e9db212adc..7c1d859a58e8 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -16,6 +16,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/tsm.h>
+#include <linux/iommufd.h>
 #include "vfio.h"
 
 #ifdef CONFIG_SPAPR_TCE_IOMMU
@@ -25,6 +26,7 @@
 struct kvm_vfio_file {
 	struct list_head node;
 	struct file *file;
+	bool is_iommufd;
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 	struct iommu_group *iommu_group;
 #endif
@@ -87,6 +89,36 @@ static bool kvm_vfio_file_is_valid(struct file *file)
 	return ret;
 }
 
+static bool kvm_iommufd_file_is_valid(struct file *file)
+{
+	bool (*fn)(struct file *file);
+	bool ret;
+
+	fn = symbol_get(iommufd_file_is_valid);
+	if (!fn)
+		return false;
+
+	ret = fn(file);
+
+	symbol_put(iommufd_file_is_valid);
+
+	return ret;
+}
+
+static void kvm_iommufd_file_set_kvm(struct file *file, struct kvm *kvm,
+				     gmem_pin_t gmem_pin)
+{
+	void (*fn)(struct file *file, struct kvm *kvm, gmem_pin_t gmem_pin);
+
+	fn = symbol_get(iommufd_file_set_kvm);
+	if (!fn)
+		return;
+
+	fn(file, kvm, gmem_pin);
+
+	symbol_put(iommufd_file_set_kvm);
+}
+
 static struct vfio_device *kvm_vfio_file_device(struct file *file)
 {
 	struct vfio_device *(*fn)(struct file *file);
@@ -167,7 +199,7 @@ static int kvm_vfio_file_add(struct kvm_device *dev, unsigned int fd)
 {
 	struct kvm_vfio *kv = dev->private;
 	struct kvm_vfio_file *kvf;
-	struct file *filp;
+	struct file *filp = NULL;
 	int ret = 0;
 
 	filp = fget(fd);
@@ -175,7 +207,7 @@ static int kvm_vfio_file_add(struct kvm_device *dev, unsigned int fd)
 		return -EBADF;
 
 	/* Ensure the FD is a vfio FD. */
-	if (!kvm_vfio_file_is_valid(filp)) {
+	if (!kvm_vfio_file_is_valid(filp) && !kvm_iommufd_file_is_valid(filp)) {
 		ret = -EINVAL;
 		goto out_fput;
 	}
@@ -196,11 +228,18 @@ static int kvm_vfio_file_add(struct kvm_device *dev, unsigned int fd)
 	}
 
 	kvf->file = get_file(filp);
+
 	list_add_tail(&kvf->node, &kv->file_list);
 
 	kvm_arch_start_assignment(dev->kvm);
-	kvm_vfio_file_set_kvm(kvf->file, dev->kvm);
-	kvm_vfio_update_coherency(dev);
+	kvf->is_iommufd = kvm_iommufd_file_is_valid(filp);
+
+	if (kvf->is_iommufd) {
+		kvm_iommufd_file_set_kvm(kvf->file, dev->kvm, kvm_gmem_uptr_to_pfn);
+	} else {
+		kvm_vfio_file_set_kvm(kvf->file, dev->kvm);
+		kvm_vfio_update_coherency(dev);
+	}
 
 out_unlock:
 	mutex_unlock(&kv->lock);
@@ -233,7 +272,11 @@ static int kvm_vfio_file_del(struct kvm_device *dev, unsigned int fd)
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvf);
 #endif
-		kvm_vfio_file_set_kvm(kvf->file, NULL);
+		if (kvf->is_iommufd)
+			kvm_iommufd_file_set_kvm(kvf->file, NULL, NULL);
+		else
+			kvm_vfio_file_set_kvm(kvf->file, NULL);
+
 		fput(kvf->file);
 		kfree(kvf);
 		ret = 0;
@@ -476,7 +519,10 @@ static void kvm_vfio_release(struct kvm_device *dev)
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvf);
 #endif
-		kvm_vfio_file_set_kvm(kvf->file, NULL);
+		if (kvf->is_iommufd)
+			kvm_iommufd_file_set_kvm(kvf->file, NULL, NULL);
+		else
+			kvm_vfio_file_set_kvm(kvf->file, NULL);
 		fput(kvf->file);
 		list_del(&kvf->node);
 		kfree(kvf);
-- 
2.45.2


