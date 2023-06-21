Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B5073936D
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjFUX4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjFUX4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:56:17 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2081.outbound.protection.outlook.com [40.107.212.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE4D1BF9;
        Wed, 21 Jun 2023 16:56:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z90loEt/J/SzYvoAOvlnQyOw6KwxisBGnmF8VzUCLmqGA/o95CleIau7pdU8LlOfixZ8qTFd2fZAf9Rh2ntt+4t+SdBZivgQG9nS6UiuRLiczoYs2jpdpxjo+HTjKMjoK4dI4f3Wg4hQWsg9jG0OwXuZDBWbD7OPXlGkv+kpboqBSYjg0MDhRLLm2ifi3TuAimvIUuaQowmjPQA9sbtdrswQ9p+j4rH4L7Gzcxw/QbvjeI/W9fnW0szjEKA7uxEyPTSz7AgveUUYbtuZjsHwFcQX7J/X+EIxaqNGFGE8MVrzwOSvw+omFtH8B00Sz/HJStaTWhwEmGH0ai4DPpxXEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opL4/QhswK9hoboF9zUynw6Y50TRvS1CdR+6bH2e+kE=;
 b=WrwjPVJ3wbCL494Hz+9kk3x/4HMLiSaboXrwKKNVRgf3ddHMt8gcYlszmUVEdMNVDMRUhnW2eBKJjJ5fBC2h+PrV8rNx4x9KQjso/w2CXY6TItKXwwazd1BT1f01e7w1AhEekdLFqhD+L+GZ1cJHNZyjCrmDW5w9il1bClF7wshsRx3c0bfy4TS5rE8nWkp0u22oh7Ze71s5Ql5uA+cWEgIiyeoRB10DLLcbSRpovx/OlJzaUcKTvFEXLU1q6e5/wmk7Tp5kJROhxsdV6XBbzV3j/CP/7TuCsrPRcC0n6JQNZ+BbvSwRyDIt0IbhFwtjIJXnToqhErpXV8NbydSnZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opL4/QhswK9hoboF9zUynw6Y50TRvS1CdR+6bH2e+kE=;
 b=uErT5tbhrZdn0qu0+xH8yuhyW/ixtdKXI5AYl/AY+oNTUwK722LYVhXElWwbnWKkfGhieBLLbZUAjCe4rz1PUMjPZjll+zRuKJGOjZIUsTUboK2UUqeY5fe3QpIg8oGRqeWzQdhQyQtUuQ1lgguOrN4unEi/Lfx9XwqUYyZlMsE=
Received: from CY5PR15CA0035.namprd15.prod.outlook.com (2603:10b6:930:1b::22)
 by CY5PR12MB6227.namprd12.prod.outlook.com (2603:10b6:930:21::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 23:55:57 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:1b:cafe::ff) by CY5PR15CA0035.outlook.office365.com
 (2603:10b6:930:1b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.21 via Frontend Transport; Wed, 21 Jun 2023 23:55:57 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:56 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <iommu@lists.linux.dev>,
        <kvm@vger.kernel.org>
CC:     <joro@8bytes.org>, <robin.murphy@arm.com>, <yi.l.liu@intel.com>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <nicolinc@nvidia.com>, <baolu.lu@linux.intel.com>,
        <eric.auger@redhat.com>, <pandoh@google.com>,
        <kumaranand@google.com>, <jon.grimm@amd.com>,
        <santosh.shukla@amd.com>, <vasant.hegde@amd.com>,
        <jay.chen@amd.com>, <joseph.chung@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 15/21] iommu/amd: Introduce vIOMMU vminit and vmdestroy ioctl
Date:   Wed, 21 Jun 2023 18:55:02 -0500
Message-ID: <20230621235508.113949-16-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
References: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|CY5PR12MB6227:EE_
X-MS-Office365-Filtering-Correlation-Id: cbf2ec24-0f7d-40a0-fabb-08db72b30ed5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zNAboEXd2bsyD3s3CDBqGoVMAdHLGpltkD6QjkC+e2iFF94T9JP6e+5DMv3yGDpyQCBkJYICUS5tFJOkM1eweAPypdzkjVDi+dUh7vmfWxioCgTn9T3J6l/bRlB23Z3JYEe+DR5qEcfXGkp27z9xcCTETldyYO9ELm6quaPwTwpjD2aVm9Ael+4O3DvdTeMUXDdH2IVFn9z0e/pAnJsgMYntXRk9+HghKKwqdEZUSoMh6BSZQYjKjOZxaimCu/pqdz2L8sPbjAEnL4UgCBEmEYcUaP3McP9yiKr606BFhBLZTdHgZ+d0Co4zhjILKsNbWrdbSSLnhnMJEz9y8t4duLItBrRJ8wlMYX+MFsY29+13CHOq+g62WjocEqZB5kuszrh122psQjFDDQ5GFHHOkQ+7yBAYlyaGBPrHXgeGG8A4yybvxPNxCnSyp3NtcgSvWp83njGTR5aM0Va2npyQtfsgQ6Mtz0ANlM5d7Di4eymmhJd7CPb3BcmrCT3bQxXLJyUlHBVh15lHfFMx0/Jdpu0je9Y6VtNzNb+LSqcasxI++pZfUuMtlf1UzY100gxGbvwbPWig2NXu43jxkkQ0H5uWeC43bHaxhNkTHUtYrP2mMOeovPb9+qTjFvAl8T+mmSY3qZPLhpNlZoOL32+vFQ6bZsLpvto8ZlDLokKj62iPhhOBOSQxSGsyEP2Xsc5ibpBf9T0Nr2AckYbbOUv8kCaWxGLdQ0tPmQHZtxNBTAR/Th6LYNSL4uuW7PUJqXLdHfGfnmZ2A++coVLXr2qybw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(83380400001)(426003)(336012)(1076003)(186003)(16526019)(26005)(2616005)(110136005)(54906003)(70206006)(7696005)(478600001)(70586007)(36756003)(86362001)(316002)(82740400003)(4326008)(81166007)(356005)(47076005)(36860700001)(6666004)(5660300002)(44832011)(7416002)(8676002)(41300700001)(8936002)(40460700003)(2906002)(40480700001)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:57.5580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbf2ec24-0f7d-40a0-fabb-08db72b30ed5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6227
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These ioctl interfaces are called when QEMU initialize and destroy VMs.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/amd_iommu.h |   2 +
 drivers/iommu/amd/iommu.c     |   4 +-
 drivers/iommu/amd/viommu.c    | 294 ++++++++++++++++++++++++++++++++++
 3 files changed, 298 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index a65d22384ab8..fccae07e8c9f 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -85,6 +85,8 @@ extern int amd_iommu_flush_tlb(struct iommu_domain *dom, u32 pasid);
 extern int amd_iommu_domain_set_gcr3(struct iommu_domain *dom, u32 pasid,
 				     unsigned long cr3);
 extern int amd_iommu_domain_clear_gcr3(struct iommu_domain *dom, u32 pasid);
+extern void amd_iommu_iotlb_sync(struct iommu_domain *domain,
+				 struct iommu_iotlb_gather *gather);
 
 extern void amd_iommu_build_efr(u64 *efr, u64 *efr2);
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b5c62bc8249c..f22b2a5a8bfc 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2447,8 +2447,8 @@ static void amd_iommu_flush_iotlb_all(struct iommu_domain *domain)
 	spin_unlock_irqrestore(&dom->lock, flags);
 }
 
-static void amd_iommu_iotlb_sync(struct iommu_domain *domain,
-				 struct iommu_iotlb_gather *gather)
+void amd_iommu_iotlb_sync(struct iommu_domain *domain,
+			  struct iommu_iotlb_gather *gather)
 {
 	struct protection_domain *dom = to_pdomain(domain);
 	unsigned long flags;
diff --git a/drivers/iommu/amd/viommu.c b/drivers/iommu/amd/viommu.c
index 18036d03c747..2bafa5102ffa 100644
--- a/drivers/iommu/amd/viommu.c
+++ b/drivers/iommu/amd/viommu.c
@@ -12,6 +12,7 @@
 
 #include <linux/fs.h>
 #include <linux/cdev.h>
+#include <linux/hashtable.h>
 #include <linux/ioctl.h>
 #include <linux/iommufd.h>
 #include <linux/mem_encrypt.h>
@@ -28,8 +29,25 @@
 #define SET_CTRL_BITS(reg, bit1, bit2, msk) \
 	((((reg) >> (bit1)) & (ULL(msk))) << (bit2))
 
+#define VIOMMU_MAX_GDEVID	0xFFFF
+#define VIOMMU_MAX_GDOMID	0xFFFF
+
+#define VIOMMU_GID_HASH_BITS	16
+static DEFINE_HASHTABLE(viommu_gid_hash, VIOMMU_GID_HASH_BITS);
+static DEFINE_SPINLOCK(viommu_gid_hash_lock);
+static u32 viommu_next_gid;
+static bool next_viommu_gid_wrapped;
+
 LIST_HEAD(viommu_devid_map);
 
+struct amd_iommu_vminfo {
+	u16 gid;
+	bool init;
+	struct hlist_node hnode;
+	u64 *devid_table;
+	u64 *domid_table;
+};
+
 struct amd_iommu *get_amd_iommu_from_devid(u16 devid)
 {
 	struct amd_iommu *iommu;
@@ -138,6 +156,50 @@ static void *alloc_private_region(struct amd_iommu *iommu,
 	return NULL;
 }
 
+static int alloc_private_vm_region(struct amd_iommu *iommu, u64 **entry,
+				   u64 base, size_t size, u16 guestId)
+{
+	int ret;
+	u64 addr = base + (guestId * size);
+
+	*entry = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, get_order(size));
+
+	ret = set_memory_uc((unsigned long)*entry, size >> PAGE_SHIFT);
+	if (ret)
+		return ret;
+
+	pr_debug("%s: entry=%#llx(%#llx), addr=%#llx\n", __func__,
+		 (unsigned long  long)*entry, iommu_virt_to_phys(*entry), addr);
+
+	ret = amd_iommu_v1_map_pages(&iommu->viommu_pdom->iop.iop.ops, addr,
+				     iommu_virt_to_phys(*entry), PAGE_SIZE, (size / PAGE_SIZE),
+				     IOMMU_PROT_IR | IOMMU_PROT_IW, GFP_KERNEL, NULL);
+
+	return ret;
+}
+
+static void free_private_vm_region(struct amd_iommu *iommu, u64 **entry,
+					u64 base, size_t size, u16 guestId)
+{
+	size_t ret;
+	struct iommu_iotlb_gather gather;
+	u64 addr = base + (guestId * size);
+
+	pr_debug("entry=%#llx(%#llx), addr=%#llx\n",
+		 (unsigned long  long)*entry,
+		 iommu_virt_to_phys(*entry), addr);
+
+	if (!iommu || iommu->viommu_pdom)
+		return;
+	ret = amd_iommu_v1_unmap_pages(&iommu->viommu_pdom->iop.iop.ops,
+				       addr, PAGE_SIZE, (size / PAGE_SIZE), &gather);
+	if (ret)
+		amd_iommu_iotlb_sync(&iommu->viommu_pdom->domain, &gather);
+
+	free_pages((unsigned long)*entry, get_order(size));
+	*entry = NULL;
+}
+
 static int viommu_private_space_init(struct amd_iommu *iommu)
 {
 	u64 pte_root = 0;
@@ -225,3 +287,235 @@ int __init iommu_init_viommu(struct amd_iommu *iommu)
 	amd_iommu_viommu = false;
 	return ret;
 }
+
+static void viommu_uninit_one(struct amd_iommu *iommu, struct amd_iommu_vminfo *vminfo, u16 guestId)
+{
+	free_private_vm_region(iommu, &vminfo->devid_table,
+			       VIOMMU_DEVID_MAPPING_BASE,
+			       VIOMMU_DEVID_MAPPING_ENTRY_SIZE,
+			       guestId);
+	free_private_vm_region(iommu, &vminfo->domid_table,
+			       VIOMMU_DOMID_MAPPING_BASE,
+			       VIOMMU_DOMID_MAPPING_ENTRY_SIZE,
+			       guestId);
+}
+
+/*
+ * Clear the DevID via VFCTRL registers
+ * This function will be called during VM destroy via VFIO.
+ */
+static void clear_device_mapping(struct amd_iommu *iommu, u16 hDevId, u16 guestId,
+				 u16 queueId, u16 gDevId)
+{
+	u64 val, tmp1, tmp2;
+	u8 __iomem *vfctrl;
+
+	/*
+	 * Clear the DevID in VFCTRL registers
+	 */
+	tmp1 = gDevId;
+	tmp1 = ((tmp1 & 0xFFFFULL) << 46);
+	tmp2 = hDevId;
+	tmp2 = ((tmp2 & 0xFFFFULL) << 14);
+	val = tmp1 | tmp2 | 0x8000000000000001ULL;
+	vfctrl = VIOMMU_VFCTRL_MMIO_BASE(iommu, guestId);
+	writeq(val, vfctrl + VIOMMU_VFCTRL_GUEST_DID_MAP_CONTROL0_OFFSET);
+}
+
+/*
+ * Clear the DomID via VFCTRL registers
+ * This function will be called during VM destroy via VFIO.
+ */
+static void clear_domain_mapping(struct amd_iommu *iommu, u16 hDomId, u16 guestId, u16 gDomId)
+{
+	u64 val, tmp1, tmp2;
+	u8 __iomem *vfctrl = VIOMMU_VFCTRL_MMIO_BASE(iommu, guestId);
+
+	tmp1 = gDomId;
+	tmp1 = ((tmp1 & 0xFFFFULL) << 46);
+	tmp2 = hDomId;
+	tmp2 = ((tmp2 & 0xFFFFULL) << 14);
+	val = tmp1 | tmp2 | 0x8000000000000001UL;
+	writeq(val, vfctrl + VIOMMU_VFCTRL_GUEST_DID_MAP_CONTROL1_OFFSET);
+}
+
+static void viommu_clear_mapping(struct amd_iommu *iommu, u16 guestId)
+{
+	int i;
+
+	for (i = 0; i <= VIOMMU_MAX_GDEVID; i++)
+		clear_device_mapping(iommu, 0, guestId, 0, i);
+
+	for (i = 0; i <= VIOMMU_MAX_GDOMID; i++)
+		clear_domain_mapping(iommu, 0, guestId, i);
+}
+
+static void viommu_clear_dirty_status_mask(struct amd_iommu *iommu, unsigned int gid)
+{
+	u32 offset, index, bits;
+	u64 *group, val;
+
+	if (gid >= 256 * 256)
+		return;
+
+	group = (u64 *)(iommu->cmdbuf_dirty_mask +
+		(((gid & 0xFF) << 4) | (((gid >> 13) & 0x7) << 2)));
+	offset = (gid >> 8) & 0x1F;
+	index = offset >> 6;
+	bits = offset & 0x3F;
+
+	val = READ_ONCE(group[index]);
+	val &= ~(1ULL << bits);
+	WRITE_ONCE(group[index], val);
+}
+
+/*
+ * Allocate pages for the following regions:
+ * - Guest MMIO
+ * - DeviceID/DomainId Mapping Table
+ * - Cmd buffer
+ * - Event/PRR (A/B) logs
+ */
+static int viommu_init_one(struct amd_iommu *iommu, struct amd_iommu_vminfo *vminfo)
+{
+	int ret;
+
+	ret = alloc_private_vm_region(iommu, &vminfo->devid_table,
+				      VIOMMU_DEVID_MAPPING_BASE,
+				      VIOMMU_DEVID_MAPPING_ENTRY_SIZE,
+				      vminfo->gid);
+	if (ret)
+		goto err_out;
+
+	ret = alloc_private_vm_region(iommu, &vminfo->domid_table,
+				      VIOMMU_DOMID_MAPPING_BASE,
+				      VIOMMU_DOMID_MAPPING_ENTRY_SIZE,
+				      vminfo->gid);
+	if (ret)
+		goto err_out;
+
+	viommu_clear_mapping(iommu, vminfo->gid);
+	viommu_clear_dirty_status_mask(iommu, vminfo->gid);
+
+	return 0;
+err_out:
+	viommu_uninit_one(iommu, vminfo, vminfo->gid);
+	return -ENOMEM;
+}
+
+int viommu_gid_alloc(struct amd_iommu *iommu, struct amd_iommu_vminfo *vminfo)
+{
+	u32 gid;
+	struct amd_iommu_vminfo *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&viommu_gid_hash_lock, flags);
+again:
+	gid = viommu_next_gid = (viommu_next_gid + 1) & 0xFFFF;
+
+	if (gid == 0) { /* id is 1-based, zero is not allowed */
+		next_viommu_gid_wrapped = 1;
+		goto again;
+	}
+	/* Is it still in use? Only possible if wrapped at least once */
+	if (next_viommu_gid_wrapped) {
+		hash_for_each_possible(viommu_gid_hash, tmp, hnode, gid) {
+			if (tmp->gid == gid)
+				goto again;
+		}
+	}
+
+	pr_debug("%s: gid=%u\n", __func__, gid);
+	vminfo->gid = gid;
+	hash_add(viommu_gid_hash, &vminfo->hnode, vminfo->gid);
+	spin_unlock_irqrestore(&viommu_gid_hash_lock, flags);
+	return 0;
+}
+
+static void viommu_gid_free(struct amd_iommu *iommu,
+			    struct amd_iommu_vminfo *vminfo)
+{
+	unsigned long flags;
+
+	pr_debug("%s: gid=%u\n", __func__, vminfo->gid);
+	spin_lock_irqsave(&viommu_gid_hash_lock, flags);
+	hash_del(&vminfo->hnode);
+	spin_unlock_irqrestore(&viommu_gid_hash_lock, flags);
+}
+
+struct amd_iommu_vminfo *get_vminfo(struct amd_iommu *iommu, int gid)
+{
+	unsigned long flags;
+	struct amd_iommu_vminfo *tmp, *ptr = NULL;
+
+	spin_lock_irqsave(&viommu_gid_hash_lock, flags);
+	hash_for_each_possible(viommu_gid_hash, tmp, hnode, gid) {
+		if (tmp->gid == gid) {
+			ptr = tmp;
+			break;
+		}
+	}
+	if (!ptr)
+		pr_debug("%s : gid=%u not found\n", __func__, gid);
+	spin_unlock_irqrestore(&viommu_gid_hash_lock, flags);
+	return ptr;
+}
+
+int amd_viommu_iommu_init(struct amd_viommu_iommu_info *data)
+{
+	int ret;
+	struct amd_iommu_vminfo *vminfo;
+	unsigned int iommu_id = data->iommu_id;
+	struct amd_iommu *iommu = get_amd_iommu_from_devid(iommu_id);
+
+	if (!iommu)
+		return -ENODEV;
+
+	vminfo = kzalloc(sizeof(*vminfo), GFP_KERNEL);
+	if (!vminfo)
+		return -ENOMEM;
+
+	ret = viommu_gid_alloc(iommu, vminfo);
+	if (ret)
+		goto err_out;
+
+	ret = viommu_init_one(iommu, vminfo);
+	if (ret)
+		goto err_out;
+
+	vminfo->init = true;
+	data->gid = vminfo->gid;
+	pr_debug("%s: iommu_id=%#x, gid=%#x\n", __func__,
+		pci_dev_id(iommu->dev), vminfo->gid);
+
+	return ret;
+
+err_out:
+	viommu_gid_free(iommu, vminfo);
+	kfree(vminfo);
+	return ret;
+}
+EXPORT_SYMBOL(amd_viommu_iommu_init);
+
+int amd_viommu_iommu_destroy(struct amd_viommu_iommu_info *data)
+{
+	unsigned int gid = data->gid;
+	struct amd_iommu_vminfo *vminfo;
+	unsigned int iommu_id = data->iommu_id;
+	struct amd_iommu *iommu = get_amd_iommu_from_devid(iommu_id);
+
+	if (!iommu)
+		return -ENODEV;
+
+	vminfo = get_vminfo(iommu, gid);
+	if (!vminfo)
+		return -EINVAL;
+
+	viommu_uninit_one(iommu, vminfo, gid);
+
+	if (vminfo->init)
+		vminfo->init = false;
+	return 0;
+
+}
+EXPORT_SYMBOL(amd_viommu_iommu_destroy);
-- 
2.34.1

