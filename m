Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6456E73934F
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjFUX5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjFUX5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:57:05 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E807B212F;
        Wed, 21 Jun 2023 16:56:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AnzCNY2o5YhQSbNvVTww+NalEP1SJOEf1FOJFZBZN+bAudjNepcx4ZUpCgCgn1zSTfZfRlykCylJVN3X2CaWMNqa7xFTPBKJcofg50ofa97RDCrxkr2Im4Y7UiUuDMYQ0SnEZFPxMk+oetwZ5ncT9YcSAwtCrecGuNfSJeMLmeRDALkr7isxR6ouO4bgszs8PrW3B7Q2XH11UEWbrmRF8g+j+pqCcu7SQSQYJIyoe03s54C95sZWIDUcHa9LIxqn3vH1OnvrnHeGvgBXa8BVQwxqFiOyli6riM+v4is1nA2a5t1yJqO+lQ//cYzYgxUwxZ9+9Gp4YnJipzyqne+HEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VAczIqgFx2hTWhMkvPvyOwJLCXkcxgD6pD3uo9Cwn4M=;
 b=oMEzv4voc7C2d0bERutFdb2qxT/bPKqzkNgWiqIemUuRKLeD1bp/91slnDKFna7pUCKcO9V8/kqycqVvetqOYM5+4cE+GCvwbNii6dE3UylkZSPKS+OCL0OGruUSDUu1499MFh+4sxUSU2V2YYlvLQ+PYnB4Tv9pAd9fYycSMsT/ZMqHbQLRzEJWKFSXJkSCjRJAsySbe1IPUpcePmy7oB7Vv3WeTk3eSYlq9PIlUEwMmf9XRA0Pe7HJe6V1nLyfJIdiSPz3UvLp7aFSU95EBaPUMddJnJjo59Ora68THAkl+K5hGHQ6I05fja7amtfKMpJLjT+FWoorxXUoD/crbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAczIqgFx2hTWhMkvPvyOwJLCXkcxgD6pD3uo9Cwn4M=;
 b=PsfvQwVcE3beBn5VRhM3bIN7jTTIDz8gy6JIyI/qCHsZih5MEYDZ/0Hf8UtD+jEurxvi/wFD/8Hiiub6hrkc2K+UfzE5PZK3UTjbmpD8FUn/cxuOXY7Z8nSvxMuyyTHINgeJQRCjHWkP8yBEUVQPmgkgnq1KQ/0K3u+PbA3KzcA=
Received: from CYZPR10CA0021.namprd10.prod.outlook.com (2603:10b6:930:8a::14)
 by DM4PR12MB5842.namprd12.prod.outlook.com (2603:10b6:8:65::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Wed, 21 Jun
 2023 23:56:07 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:930:8a:cafe::2d) by CYZPR10CA0021.outlook.office365.com
 (2603:10b6:930:8a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23 via Frontend
 Transport; Wed, 21 Jun 2023 23:56:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.24 via Frontend Transport; Wed, 21 Jun 2023 23:56:06 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:56:01 -0500
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
Subject: [RFC PATCH 20/21] iommu/amd: Introduce vIOMMU ioctl for setting up guest CR3
Date:   Wed, 21 Jun 2023 18:55:07 -0500
Message-ID: <20230621235508.113949-21-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|DM4PR12MB5842:EE_
X-MS-Office365-Filtering-Correlation-Id: d10155f6-2187-4aa4-72af-08db72b31458
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kZfYj/q2zEDQK2d3y2sSW7Fql3fozr/we5OP/QrgnTVvStpGVU3W9kRq5A6ZkPr3V4kdWT69lnf7WxF3YVeAUftSvs4xvYkLT1c0rrmq12VbsRRO8OvwAJzyr9vWfsSsdzukI2CO4w/5Q2gVAhFkr5PiJtig4cT+w1fvnzulYfeq5ta+KZe57khjDaOSVO9iKpKHqppYXGYM87RKc3aevjy/dWy9a2WG6bYzALUjiP324nv0Dw2uWSM/LB3GALVvad1YG1UK4bilQbLt5RYvkhBNyHjNRUdcmFwvkIIN0cZWvoZcjdQBsGCWYFCZQJ6I5znYfb2Mpxj6yiiormnMf/SkkARexS7YUgHFU0GbNxoi6ySDL/jiTYb4YN9e+np8g8b8TC5JyQrHhF37zj0cZzWpFe3NCySNHR4E4QTB/DZTdBj8QW6FKmD+2OV1X29h3sc4yMIckhTH9QjpR4xbqdkVqdzgZyxSNPJVaZ9cOaGtlApEkxj0eUW96jnEfHPzTUTQxwqmbVMGghi9vbvgdCbqj7UKnJuj5B2j/3iDn05rQzEAJi9UhQ1o990CUP+SK18cwO65Wmjfg6cjBbOMj07xIUdMwph72zMVShUtigjuJjFzwKUuBrOcLm1payWQYm/9xuZpvk5LtK8Z5QDx4yixVrYb/p4HNRHo6MwF5roGh6izZ4+Nk9DMAuBejQB97s7PrS4wF/WyL0ro8IFbnlfZQshbJMm2OHr05KW+AVgyIoiB14ndYw+Pew1PLobHQ855hKroxNO1abLEfqMaNw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199021)(36840700001)(40470700004)(46966006)(478600001)(36756003)(16526019)(1076003)(26005)(186003)(40460700003)(40480700001)(2906002)(7696005)(316002)(44832011)(41300700001)(82310400005)(356005)(8936002)(81166007)(5660300002)(8676002)(7416002)(86362001)(82740400003)(110136005)(426003)(336012)(54906003)(83380400001)(2616005)(47076005)(4326008)(70206006)(70586007)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:56:06.8016
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d10155f6-2187-4aa4-72af-08db72b31458
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5842
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

This ioctl interface sets up guest CR3 (gCR3) table, which
is defined by guest IOMMU driver. It also enables nested
I/O page translation in the host.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/amd_iommu.h |  12 ++++
 drivers/iommu/amd/iommu.c     | 107 ++++++++++++++++++++++++++++++++++
 drivers/iommu/amd/viommu.c    |  36 ++++++++++++
 include/linux/iommu.h         |   1 +
 include/uapi/linux/iommufd.h  |  20 +++++++
 5 files changed, 176 insertions(+)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index fccae07e8c9f..463cd59127b7 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -84,6 +84,18 @@ extern void amd_iommu_domain_flush_tlb_pde(struct protection_domain *domain);
 extern int amd_iommu_flush_tlb(struct iommu_domain *dom, u32 pasid);
 extern int amd_iommu_domain_set_gcr3(struct iommu_domain *dom, u32 pasid,
 				     unsigned long cr3);
+extern int amd_viommu_user_gcr3_update(const void *user_data,
+				       struct iommu_domain *udom);
+extern int amd_iommu_setup_gcr3_table(struct amd_iommu *iommu,
+				      struct pci_dev *pdev,
+				      struct iommu_domain *dom,
+				      struct iommu_domain *udom,
+				      int pasids, bool giov);
+extern int amd_iommu_user_set_gcr3(struct amd_iommu *iommu,
+				   struct iommu_domain *dom,
+				   struct iommu_domain *udom,
+				   struct pci_dev *pdev, u32 pasid,
+				   unsigned long cr3);
 extern int amd_iommu_domain_clear_gcr3(struct iommu_domain *dom, u32 pasid);
 extern void amd_iommu_iotlb_sync(struct iommu_domain *domain,
 				 struct iommu_iotlb_gather *gather);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index f22b2a5a8bfc..bff53977f8f7 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -80,6 +80,8 @@ struct kmem_cache *amd_iommu_irq_cache;
 
 static void detach_device(struct device *dev);
 static int domain_enable_v2(struct protection_domain *domain, int pasids, bool giov);
+static int __set_gcr3(struct protection_domain *domain, u32 pasid,
+		      unsigned long cr3);
 
 /****************************************************************************
  *
@@ -2525,10 +2527,43 @@ static void *amd_iommu_hw_info(struct device *dev, u32 *length)
 	return hwinfo;
 }
 
+static struct iommu_domain *
+amd_iommu_domain_alloc_user(struct device *dev,
+			    enum iommu_hwpt_type hwpt_type,
+			    struct iommu_domain *parent,
+			    const union iommu_domain_user_data *user_data)
+{
+	int ret;
+	struct iommu_domain *dom = iommu_domain_alloc(dev->bus);
+
+	if (!dom || !parent)
+		return dom;
+
+	/*
+	 * The parent is not null only when external driver calls IOMMUFD kAPI
+	 * to create IOMMUFD_OBJ_HW_PAGETABLE to attach a bound device to IOAS.
+	 * This is for nested (v2) page table.
+	 *
+	 * TODO: Currently, only support nested table w/ 1 pasid for GIOV use case.
+	 *       Add support for multiple pasids.
+	 */
+	dom->type = IOMMU_DOMAIN_NESTED;
+
+	ret = amd_viommu_user_gcr3_update(user_data, dom);
+	if (ret)
+		goto err_out;
+
+	return dom;
+err_out:
+	iommu_domain_free(dom);
+	return NULL;
+}
+
 const struct iommu_ops amd_iommu_ops = {
 	.capable		= amd_iommu_capable,
 	.hw_info		= amd_iommu_hw_info,
 	.domain_alloc		= amd_iommu_domain_alloc,
+	.domain_alloc_user	= amd_iommu_domain_alloc_user,
 	.probe_device		= amd_iommu_probe_device,
 	.release_device		= amd_iommu_release_device,
 	.probe_finalize		= amd_iommu_probe_finalize,
@@ -2537,6 +2572,7 @@ const struct iommu_ops amd_iommu_ops = {
 	.is_attach_deferred	= amd_iommu_is_attach_deferred,
 	.pgsize_bitmap		= AMD_IOMMU_PGSIZES,
 	.def_domain_type	= amd_iommu_def_domain_type,
+	.hw_info_type		= IOMMU_HW_INFO_TYPE_AMD,
 	.default_domain_ops	= &(const struct iommu_domain_ops) {
 		.attach_dev	= amd_iommu_attach_device,
 		.map_pages	= amd_iommu_map_pages,
@@ -2639,6 +2675,77 @@ int amd_iommu_domain_enable_v2(struct iommu_domain *dom, int pasids, bool giov)
 }
 EXPORT_SYMBOL(amd_iommu_domain_enable_v2);
 
+int amd_iommu_setup_gcr3_table(struct amd_iommu *iommu, struct pci_dev *pdev,
+			       struct iommu_domain *dom,
+			       struct iommu_domain *udom,
+			       int pasids, bool giov)
+{
+	int levels;
+	struct protection_domain *pdom = to_pdomain(dom);
+	struct protection_domain *updom = to_pdomain(udom);
+	struct iommu_dev_data *dev_data = dev_iommu_priv_get(&pdev->dev);
+
+	if (updom->gcr3_tbl)
+		return -EINVAL;
+
+	/* Number of GCR3 table levels required */
+	for (levels = 0; (pasids - 1) & ~0x1ff; pasids >>= 9)
+		levels += 1;
+
+	if (levels > amd_iommu_max_glx_val)
+		return -EINVAL;
+
+	updom->gcr3_tbl = (void *)get_zeroed_page(GFP_ATOMIC);
+	if (updom->gcr3_tbl == NULL)
+		return -ENOMEM;
+
+	updom->glx = levels;
+	updom->flags |= PD_IOMMUV2_MASK;
+	if (giov)
+		updom->flags |= PD_GIOV_MASK;
+
+	set_dte_entry(iommu, dev_data->devid, pdom, updom,
+		      updom->gcr3_tbl,
+		      dev_data->ats.enabled, false);
+	clone_aliases(iommu, dev_data->dev);
+
+	iommu_flush_dte(iommu, dev_data->devid);
+	iommu_completion_wait(iommu);
+	return 0;
+}
+
+/*
+ * Note: For vIOMMU, the guest could be using different
+ *       GCR3 table for each VFIO pass-through device.
+ *       Therefore, we need to per-device GCR3 table.
+ */
+int amd_iommu_user_set_gcr3(struct amd_iommu *iommu,
+			    struct iommu_domain *dom,
+			    struct iommu_domain *udom,
+			    struct pci_dev *pdev, u32 pasid,
+			    unsigned long cr3)
+{
+	struct iommu_dev_data *dev_data = dev_iommu_priv_get(&pdev->dev);
+	struct protection_domain *domain = to_pdomain(dom);
+	struct protection_domain *udomain = to_pdomain(udom);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&domain->lock, flags);
+	spin_lock_irqsave(&udomain->lock, flags);
+
+	ret = __set_gcr3(udomain, pasid, cr3);
+	if (!ret) {
+		device_flush_dte(dev_data);
+		iommu_completion_wait(iommu);
+	}
+
+	spin_unlock_irqrestore(&udomain->lock, flags);
+	spin_unlock_irqrestore(&domain->lock, flags);
+
+	return ret;
+}
+
 static int __flush_pasid(struct protection_domain *domain, u32 pasid,
 			 u64 address, bool size)
 {
diff --git a/drivers/iommu/amd/viommu.c b/drivers/iommu/amd/viommu.c
index 1bd4282384c4..8ce3ee3d6bf5 100644
--- a/drivers/iommu/amd/viommu.c
+++ b/drivers/iommu/amd/viommu.c
@@ -1072,3 +1072,39 @@ int amd_viommu_cmdbuf_update(struct amd_viommu_cmdbuf_data *data)
 	return -EINVAL;
 }
 EXPORT_SYMBOL(amd_viommu_cmdbuf_update);
+
+int amd_viommu_user_gcr3_update(const void *user_data, struct iommu_domain *udom)
+{
+	int ret;
+	struct pci_dev *pdev;
+	unsigned long npinned;
+	struct page *pages[2];
+	struct iommu_domain *dom;
+	struct iommu_hwpt_amd_v2 *hwpt = (struct iommu_hwpt_amd_v2 *)user_data;
+	struct amd_iommu *iommu = get_amd_iommu_from_devid(hwpt->iommu_id);
+	u16 hdev_id = viommu_get_hdev_id(iommu, hwpt->gid, hwpt->gdev_id);
+
+	pr_debug("%s: gid=%u, hdev_id=%#x, gcr3_va=%#llx\n",
+		 __func__, hwpt->gid, hdev_id, (unsigned long long) hwpt->gcr3_va);
+
+	npinned = get_user_pages_fast(hwpt->gcr3_va, 1, FOLL_WRITE, pages);
+	if (!npinned) {
+		pr_err("Failure locking grc3 page (%#llx).\n", hwpt->gcr3_va);
+		return -EINVAL;
+	}
+
+	/* Allocate gcr3 table */
+	pdev = pci_get_domain_bus_and_slot(0, PCI_BUS_NUM(hdev_id),
+					   hdev_id & 0xff);
+	dom = iommu_get_domain_for_dev(&pdev->dev);
+	if (!dom)
+		return -EINVAL;
+
+	/* TODO: Only support 1 pasid (zero) for now */
+	ret = amd_iommu_setup_gcr3_table(iommu, pdev, dom, udom, 1,
+					 iommu_feature(iommu, FEATURE_GIOSUP));
+	if (ret)
+		pr_err("%s: Fail to enable gcr3 (devid=%#x)\n", __func__, pci_dev_id(pdev));
+
+	return amd_iommu_user_set_gcr3(iommu, dom, udom, pdev, 0, hwpt->gcr3);
+}
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 4116f12d5f97..9239cd01d77c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -236,6 +236,7 @@ union iommu_domain_user_data {
 #endif
 	struct iommu_hwpt_vtd_s1 vtd;
 	struct iommu_hwpt_arm_smmuv3 smmuv3;
+	struct iommu_hwpt_amd_v2 amdv2;
 };
 
 /**
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index f8ea9faf6770..4147171429e1 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -408,6 +408,23 @@ struct iommu_hwpt_arm_smmuv3 {
 	__aligned_u64 out_event_uptr;
 };
 
+/**
+ * struct iommu_hwpt_amd_v2 - AMD IOMMU specific user-managed
+ *                            v2 I/O page table data
+ * @gcr3: GCR3 guest physical ddress
+ * @gcr3_va: GCR3 host virtual address
+ * @gid: Guest ID
+ * @iommu_id: IOMMU host device ID
+ * @gdev_id: Guest device ID
+ */
+struct iommu_hwpt_amd_v2 {
+	__u64 gcr3;
+	__u64 gcr3_va;
+	__u32 gid;
+	__u32 iommu_id;
+	__u16 gdev_id;
+};
+
 /**
  * enum iommu_hwpt_type - IOMMU HWPT Type
  * @IOMMU_HWPT_TYPE_DEFAULT: default
@@ -418,6 +435,7 @@ enum iommu_hwpt_type {
 	IOMMU_HWPT_TYPE_DEFAULT,
 	IOMMU_HWPT_TYPE_VTD_S1,
 	IOMMU_HWPT_TYPE_ARM_SMMUV3,
+	IOMMU_HWPT_TYPE_AMD_V2,
 };
 
 /**
@@ -523,11 +541,13 @@ struct iommu_hw_info_amd {
  * enum iommu_hw_info_type - IOMMU Hardware Info Types
  * @IOMMU_HW_INFO_TYPE_INTEL_VTD: Intel VT-d iommu info type
  * @IOMMU_HW_INFO_TYPE_ARM_SMMUV3: ARM SMMUv3 iommu info type
+ * @IOMMU_HW_INFO_TYPE_AMD: AMD IOMMU info type
  */
 enum iommu_hw_info_type {
 	IOMMU_HW_INFO_TYPE_NONE,
 	IOMMU_HW_INFO_TYPE_INTEL_VTD,
 	IOMMU_HW_INFO_TYPE_ARM_SMMUV3,
+	IOMMU_HW_INFO_TYPE_AMD,
 };
 
 /**
-- 
2.34.1

