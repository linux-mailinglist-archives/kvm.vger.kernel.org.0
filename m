Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940C5739356
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjFUX5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjFUX5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:57:05 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA6C2121;
        Wed, 21 Jun 2023 16:56:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMO7RVt1aYIN2AtV4Hq7RVWcEPvWZNZT1+L021AwpAIQ412AMNUIUsAw4l4x7O9Qy3Gt5Oidf5uDXA0z0UQZYEJNefo4uGI9dOQNwAXb1ksqhO7UFPDtMbAqW25U2izdaRhGK3uX36WAhUUQ0Frg+eXtFDpSOtoSPelh4RPkk/UgEaXWJ5qGekCEvlnJfGnZXINsEdaQPjzjkYpA8mF5GPbun0bj1hkz5tmS/YVtr1V+zpz5oOjejithYFCcWX4+hcEuGcSMTwPCG+o/xpDhETNacd4btdbR0/0BTUXwsKSp2GqIVsC0dW1D26G8vcSYR0e7wNYSBYET7EI8kNVahQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ieHhxeGQrpKO5YoYf2E5ByWC0tKJRrqhHcmw9fCwYhs=;
 b=QCGFJnBUzsiAHWfc2ojY6OrR7wzJ9Cl8X6f46x4n83jUeZ2FH5wCH5E6zz9lRxQqE2YEpxBC2hOmzyFcpOBSdw7WOCPrqHoyKVG3hRu84llexJ95TzSux2KXsjMSvGa9l9qDjDk+QMYBpRFdWnBWY0b2BAKV3VfeM/NA2+CzD/E8shIZf9OzxcWcxZb8f97fl8QyYHmMBncMAJv6tY1wpwYOqvAtZpDfywtuw2Y+GIlRoJBUpr97+wpVyC1Rpg8ezMrxU4QfAGHKoidK60cbaNSgCDKs0hASeQyubM1KGrOe+X5z69rECZEqufy50+MtU+X9DVh4fx+TC+jZRx9Qbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieHhxeGQrpKO5YoYf2E5ByWC0tKJRrqhHcmw9fCwYhs=;
 b=sHCuqlgrNiiqrTrl3mMZMYLmWcFn0wXfGgdEqkxzWKhoHVkNtj/sIuK1wRCBhsgykiYV9BuEPMWNOWsaeOjOFV0ZgOb65LiFJq58XbGi1AxP/Ub9G0y6qB28AM3EC25rEOqR9Lw1RcnKl3rKpe/7SuT5h/0upbUiWE7tq1eQjI8=
Received: from CY8PR11CA0048.namprd11.prod.outlook.com (2603:10b6:930:4a::26)
 by CY8PR12MB7148.namprd12.prod.outlook.com (2603:10b6:930:5c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Wed, 21 Jun
 2023 23:56:07 +0000
Received: from CY4PEPF0000E9D1.namprd03.prod.outlook.com
 (2603:10b6:930:4a:cafe::19) by CY8PR11CA0048.outlook.office365.com
 (2603:10b6:930:4a::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23 via Frontend
 Transport; Wed, 21 Jun 2023 23:56:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D1.mail.protection.outlook.com (10.167.241.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.23 via Frontend Transport; Wed, 21 Jun 2023 23:56:05 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:56:00 -0500
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
Subject: [RFC PATCH 19/21] iommu/amd: Introduce vIOMMU ioctl for handling command buffer mapping
Date:   Wed, 21 Jun 2023 18:55:06 -0500
Message-ID: <20230621235508.113949-20-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D1:EE_|CY8PR12MB7148:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a5cdd97-f8c3-4eb0-45c3-08db72b313a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ShpCa1PHCT+XWRo14zCD3j+C9Gtwrk7rMGbrKrSkCWT580XDL5UrbNZRZaJ4QJ8sCiqBsfNbNv7GRlJHSHJInC0OpdbzAuk1oGVVHWa28QK+coX8NxssdeCWv65WbVuVBCZjQ93M1FwzZzgNoOvRaQDv6U62Bl+NAh7u5b4gIIB6XPkMoXMYu826IRjLmFWdC00JQ2wr6D3RExKVMPy644hgJ7tnm/eQKp3n0ez1Wf1TmmOPQJIyY23QNcjuOHZUtPC57RjDdUzwun/qjDuEHDX8Rv4UkMms+PSIHTKJ7TXN9KOq3syXHUPGlcL1TMGojYelQqvxDZiOPfxfHUvt9Q7ilAAkPpWThw/NEWkiOTnWEMejLs35qoOBTPoas6mPbsZeZ8bMKptOZqIpiSfosfKOk0MtUl83a4O9ruEn3kvV5enfoqf/gyY7VI6hijeiibpG3OAYKEDIT09Ek1xEtnQ/FBB6zNNT9AV5390XBKvjGtCI7B1FutpQmp+YPhifvudO410E7D+bbhUtikIp/YAfu2ojT5gifsOHgXUDo3d1JYVGnVjUHn7H2mvRfG2Ya1OOd6qhRZvbHXJM3LVM8qdElfqKr3BuQ9SN9+V0fnuK8bsaTRBWnGryksQaOqZ/e7JI/X814SOEj+wOhQ/W1V1AjDAdj5qKBtq03HyJUC22teODA1ifCx0hN711P1rclQNy2HTJ582Uyo+f6sQ1MTupg07xl8cFSre2kiiIEyD+oLlofK3rTSSb4msbmdHiwtwDvTHOUtiPio4w41TRRQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(36860700001)(82310400005)(40460700003)(81166007)(36756003)(70206006)(356005)(44832011)(5660300002)(7416002)(8676002)(41300700001)(40480700001)(86362001)(4326008)(8936002)(70586007)(316002)(82740400003)(426003)(47076005)(1076003)(26005)(16526019)(186003)(2906002)(7696005)(54906003)(110136005)(2616005)(478600001)(83380400001)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:56:05.6405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5cdd97-f8c3-4eb0-45c3-08db72b313a7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7148
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

This ioctl interface is used for handling vIOMMU command buffer mapping.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/amd_iommu_types.h |  1 +
 drivers/iommu/amd/viommu.c          | 78 +++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 5cb5a709b31b..dd3c79e454d8 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -261,6 +261,7 @@
 #define CMD_BUFFER_SIZE    8192
 #define CMD_BUFFER_UNINITIALIZED 1
 #define CMD_BUFFER_ENTRIES 512
+#define CMD_BUFFER_MAXSIZE 0x80000
 #define MMIO_CMD_SIZE_SHIFT 56
 #define MMIO_CMD_SIZE_512 (0x9ULL << MMIO_CMD_SIZE_SHIFT)
 
diff --git a/drivers/iommu/amd/viommu.c b/drivers/iommu/amd/viommu.c
index 9ddbdbec4a75..1bd4282384c4 100644
--- a/drivers/iommu/amd/viommu.c
+++ b/drivers/iommu/amd/viommu.c
@@ -994,3 +994,81 @@ int amd_viommu_guest_mmio_write(struct amd_viommu_mmio_data *data)
 	return 0;
 }
 EXPORT_SYMBOL(amd_viommu_guest_mmio_write);
+
+static void viommu_cmdbuf_free(struct protection_domain *dom, struct io_pgtable_ops *ops,
+				   unsigned long iova, struct page **pages, unsigned long npages)
+{
+	int i;
+	unsigned long flags;
+	unsigned long tmp = iova;
+
+	spin_lock_irqsave(&dom->lock, flags);
+	for (i = 0; i < npages; i++, tmp += PAGE_SIZE) {
+		amd_iommu_v1_unmap_pages(ops, tmp, PAGE_SIZE, 1, NULL);
+		/*
+		 * Flush domain TLB(s) and wait for completion. Any Device-Table
+		 * Updates and flushing already happened in
+		 * increase_address_space().
+		 */
+		amd_iommu_domain_flush_tlb_pde(dom);
+		amd_iommu_domain_flush_complete(dom);
+
+		unpin_user_pages(&pages[i], 1);
+	}
+	spin_unlock_irqrestore(&dom->lock, flags);
+}
+
+int amd_viommu_cmdbuf_update(struct amd_viommu_cmdbuf_data *data)
+{
+	int i, numpg = data->cmdbuf_size >> PAGE_SHIFT;
+	struct amd_iommu *iommu = get_amd_iommu_from_devid(data->iommu_id);
+	struct amd_iommu_vminfo *vminfo;
+	unsigned int gid = data->gid;
+	struct page **pages;
+	unsigned long npages = 0;
+	unsigned long iova;
+	unsigned long hva = data->hva;
+
+	pages = kcalloc(numpg, sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	vminfo = get_vminfo(iommu, gid);
+	if (!vminfo)
+		return -EINVAL;
+
+	/*
+	 * Setup vIOMMU guest command buffer in IOMMU Private Address (IPA) space
+	 * for the specified GID.
+	 */
+	for (i = 0 ; i < numpg; i++, hva += (0x1000 * i)) {
+		int ret;
+		u64 phys;
+
+		if (get_user_pages_fast(hva, 1, FOLL_WRITE, &pages[i]) != 1) {
+			pr_err("%s: Failure locking page:%#lx.\n", __func__, hva);
+			goto err_out;
+		}
+
+		phys = __sme_set(page_to_pfn(pages[i]) << PAGE_SHIFT);
+		iova = VIOMMU_GUEST_CMDBUF_BASE + (i * PAGE_SIZE) + (gid * CMD_BUFFER_MAXSIZE);
+
+		pr_debug("%s: iova=%#lx, phys=%#llx\n", __func__, iova, phys);
+		ret = amd_iommu_v1_map_pages(&iommu->viommu_pdom->iop.iop.ops,
+					     iova, phys, PAGE_SIZE, 1,
+					     IOMMU_PROT_IR | IOMMU_PROT_IW,
+					     GFP_KERNEL, NULL);
+		if (ret) {
+			pr_err("%s: Failure to map page iova:%#lx, phys=%#llx\n",
+			       __func__, iova, phys);
+			goto err_out;
+		}
+		npages++;
+	}
+	return 0;
+err_out:
+	viommu_cmdbuf_free(iommu->viommu_pdom, &iommu->viommu_pdom->iop.iop.ops,
+			   iova, pages, npages);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(amd_viommu_cmdbuf_update);
-- 
2.34.1

