Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44180739345
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjFUX4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjFUX4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:56:17 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2AF1BFA;
        Wed, 21 Jun 2023 16:56:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVTurVIAoleTdXv0R+OilOUHI/vr6boJS+SjmkHDrFVhwQO257zZoYqo51dbJnPN6SPy9Uz2yEL/57V/BP0cw1e0rjyxYXKCzZ4ZlApdLxpQr8Aymos/Xvf/xy7DwQQdpkr51xk8wdEz77PS8QW/X1F5IFs/6AfU/uDeGZU2/H/IERXtoO9v+K+BCUYFsKAxkVa+BaQ7+D56y6DUOevbLQYbGoynMV4vsOo3jb3XbHuILeXrEOO7Axflt0DSHgQFaRmIvfH2czwzCXjuc1vfFCv11qhvK9TfGRSygbf5NbR8hQcbJYs10/K6EP1QgeJ/LbiwrrQ8XiYHzF/IhT1foQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RuhQRGzbi7lBRXFwlEjVeymmrd3P+hgmDTsczuRKx8g=;
 b=HuRrjnfeC9yw56tBZ0Wo5AttsXYAlZDrzBkzlq81rsGlgbxUbJ0DIuM3RusTgbsxuKh+Ta1azZ36VXERRq5zMSUg6E8xqW9B0QKuxnBc/nKgwsobZzAp1lmaTHdpqVkYJODdVQRlDjwvgEVktp/Qpancq3ulCwjw/ioxcNuGrx+F4SqUqLU4fA0bfGNNzpAyb3OJqQ0JaM8Hc3AfjVHgMSuOLcjQ2+vicBWoT+WQnsAR0nyahjAceRS/vIHIYN7ivgDOv5onJ6l4uWp70hlrrwNuYlb1XjiFrPQsGWq9o5Fnp8UgUjt/ODbXcuZ/5y4/tTMRBKjQMNepxiC5+o5mvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RuhQRGzbi7lBRXFwlEjVeymmrd3P+hgmDTsczuRKx8g=;
 b=xXJ2mRGmKDnSa15ejkK6hFVzmLhOnmOHN2JzxRWFXqX9tldJ9l9mSaB8MLVy7PqyswHdAGe4JpyhPxmxzr+Iy7EFWun/3x6jugQv7VVljDIbxtM7Y3tqMaMJR9pn9g4cyiSFuGUF47NOMcuDOQw29ZvZi+ikXoQWODalD+aOJ3M=
Received: from CY8PR11CA0046.namprd11.prod.outlook.com (2603:10b6:930:4a::6)
 by BL1PR12MB5127.namprd12.prod.outlook.com (2603:10b6:208:31b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Wed, 21 Jun
 2023 23:55:59 +0000
Received: from CY4PEPF0000E9D1.namprd03.prod.outlook.com
 (2603:10b6:930:4a:cafe::c4) by CY8PR11CA0046.outlook.office365.com
 (2603:10b6:930:4a::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23 via Frontend
 Transport; Wed, 21 Jun 2023 23:55:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D1.mail.protection.outlook.com (10.167.241.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.23 via Frontend Transport; Wed, 21 Jun 2023 23:55:58 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:57 -0500
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
Subject: [RFC PATCH 16/21] iommu/amd: Introduce vIOMMU ioctl for updating device mapping table
Date:   Wed, 21 Jun 2023 18:55:03 -0500
Message-ID: <20230621235508.113949-17-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D1:EE_|BL1PR12MB5127:EE_
X-MS-Office365-Filtering-Correlation-Id: def41212-f7b6-4b3a-ecbe-08db72b30f7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z26dcwE+uIJSfxzi+AN7yEXhrF3IhSX7ILeOHg3L+cQiyWc8s+l/43BJMYfMe3ROH8J0wtDZDkSVcaMVvcSFHJvpoDeDajkhPGHUTdnfZYoF+YQxgxciMqfR4hrjAIpUb6D0d2/fsGkc0X1cZsgcVac7z4sJ7U3LL6imxGiSRQIjibvAOs2/xJduu7R8jRYD6zgfla7ZJvGMXEy+MKmb3b1wiRadk4giSrq+6mNLGbu2Euld1MGRebYO813qFqGqaIlq0z2xYYumGsXwEVALnsiR45axAIAMkBwDz5fq3U89sbaV5ncCRdUy/Npn+0buKBJYdjOa196QHJZtffv6Vu2lETO7/+AqzDrIVMH7/BcLsa8DoBomOIOprcMgqVjzgMiHVmanq2HDtKNbrj8aga5Knb5QeRjvd8RHTg4ITDI4zzeX+V1XjX4zOWvxIiKM0ODjdwAG5wkrLEvkw481InonvRHFwmovh7QI+usUBmVtHqm/LwZLkl53Szy+SIr440rde62r41el/gxbB1EYs4Qd7NGw1Cqg+dy4aY05u8AR6v/lxJNxYVnXvtnoJd5OFREvWnrC9ndSra0LXe7FLsgeDliaYJk401Sa3a2uXUikjyb90nRUCKtg9G8T/kz7P27Z+Q8kIgHOXDPkGzg2wAL6NQn5G85636522Y3reU1dwzleCpw1jGzjBHBk4gZpbD09uAft2it/GpFfM9Vi3XAXis9+qhwnOPOQVk5ckwkC1Q9CPj3PgEKksLj9c9NWnDttrqsyFaDXOjLwgb3e2g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199021)(40470700004)(46966006)(36840700001)(82310400005)(36860700001)(36756003)(70206006)(40460700003)(356005)(5660300002)(44832011)(7416002)(8676002)(41300700001)(86362001)(8936002)(4326008)(316002)(40480700001)(70586007)(82740400003)(81166007)(47076005)(1076003)(478600001)(26005)(16526019)(426003)(2906002)(2616005)(186003)(83380400001)(6666004)(336012)(7696005)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:55:58.6717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: def41212-f7b6-4b3a-ecbe-08db72b30f7f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5127
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

These ioctl interfaces are used for updating device host-to-guest
device ID mappings.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/viommu.c | 130 +++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

diff --git a/drivers/iommu/amd/viommu.c b/drivers/iommu/amd/viommu.c
index 2bafa5102ffa..f6f0056c7fe6 100644
--- a/drivers/iommu/amd/viommu.c
+++ b/drivers/iommu/amd/viommu.c
@@ -519,3 +519,133 @@ int amd_viommu_iommu_destroy(struct amd_viommu_iommu_info *data)
 
 }
 EXPORT_SYMBOL(amd_viommu_iommu_destroy);
+
+static void set_dte_viommu(struct amd_iommu *iommu, u16 hDevId, u16 gid, u16 gDevId)
+{
+	u64 tmp, dte;
+	struct dev_table_entry *dev_table = get_dev_table(iommu);
+
+	// vImuEn
+	dte = dev_table[hDevId].data[3];
+	dte |= (1ULL << DTE_VIOMMU_EN_SHIFT);
+
+	// GDeviceID
+	tmp = gDevId & DTE_VIOMMU_GUESTID_MASK;
+	dte |= (tmp << DTE_VIOMMU_GUESTID_SHIFT);
+
+	// GuestID
+	tmp = gid & DTE_VIOMMU_GUESTID_MASK;
+	dte |= (tmp << DTE_VIOMMU_GDEVICEID_SHIFT);
+
+	dev_table[hDevId].data[3] = dte;
+
+	dte = dev_table[hDevId].data[0];
+	dte |= DTE_FLAG_GV;
+	dev_table[hDevId].data[0] = dte;
+
+	iommu_flush_dte(iommu, hDevId);
+}
+
+void dump_device_mapping(struct amd_iommu *iommu, u16 guestId, u16 gdev_id)
+{
+	void *addr;
+	u64 offset, val;
+	struct amd_iommu_vminfo *vminfo;
+
+	vminfo = get_vminfo(iommu, guestId);
+	if (!vminfo)
+		return;
+
+	addr = vminfo->devid_table;
+	offset = gdev_id << 4;
+	val = *((u64 *)(addr + offset));
+
+	pr_debug("%s: guestId=%#x, gdev_id=%#x, base=%#llx, offset=%#llx(val=%#llx)\n", __func__,
+		 guestId, gdev_id, (unsigned long long)iommu_virt_to_phys(vminfo->devid_table),
+		 (unsigned long long)offset, (unsigned long long)val);
+}
+
+/*
+ * Program the DevID via VFCTRL registers
+ * This function will be called during VM init via VFIO.
+ */
+static void set_device_mapping(struct amd_iommu *iommu, u16 hDevId,
+			       u16 guestId, u16 queueId, u16 gDevId)
+{
+	u64 val, tmp1, tmp2;
+	u8 __iomem *vfctrl;
+
+	pr_debug("%s: iommu_id=%#x, gid=%#x, hDevId=%#x, gDevId=%#x\n",
+		__func__, pci_dev_id(iommu->dev), guestId, hDevId, gDevId);
+
+	set_dte_viommu(iommu, hDevId, guestId, gDevId);
+
+	tmp1 = gDevId;
+	tmp1 = ((tmp1 & 0xFFFFULL) << 46);
+	tmp2 = hDevId;
+	tmp2 = ((tmp2 & 0xFFFFULL) << 14);
+	val = tmp1 | tmp2 | 0x8000000000000001ULL;
+	vfctrl = VIOMMU_VFCTRL_MMIO_BASE(iommu, guestId);
+	writeq(val, vfctrl + VIOMMU_VFCTRL_GUEST_DID_MAP_CONTROL0_OFFSET);
+	wbinvd_on_all_cpus();
+
+	tmp1 = hDevId;
+	val = ((tmp1 & 0xFFFFULL) << 16);
+	writeq(val, vfctrl + VIOMMU_VFCTRL_GUEST_MISC_CONTROL_OFFSET);
+}
+
+static void clear_dte_viommu(struct amd_iommu *iommu, u16 hDevId)
+{
+	struct dev_table_entry *dev_table = get_dev_table(iommu);
+	u64 dte = dev_table[hDevId].data[3];
+
+	dte &= ~(1ULL << DTE_VIOMMU_EN_SHIFT);
+	dte &= ~(0xFFFFULL << DTE_VIOMMU_GUESTID_SHIFT);
+	dte &= ~(0xFFFFULL << DTE_VIOMMU_GDEVICEID_SHIFT);
+
+	dev_table[hDevId].data[3] = dte;
+
+	dte = dev_table[hDevId].data[0];
+	dte &= ~DTE_FLAG_GV;
+	dev_table[hDevId].data[0] = dte;
+
+	iommu_flush_dte(iommu, hDevId);
+}
+
+int amd_viommu_device_update(struct amd_viommu_dev_info *data, bool is_set)
+{
+	struct pci_dev *pdev;
+	struct iommu_domain *dom;
+	int gid = data->gid;
+	struct amd_iommu *iommu = get_amd_iommu_from_devid(data->iommu_id);
+
+	if (!iommu)
+		return -ENODEV;
+
+	clear_dte_viommu(iommu, data->hdev_id);
+
+	if (is_set) {
+		set_device_mapping(iommu, data->hdev_id, gid,
+				   data->queue_id, data->gdev_id);
+
+		pdev = pci_get_domain_bus_and_slot(0, PCI_BUS_NUM(data->hdev_id),
+						   data->hdev_id & 0xff);
+		dom = iommu_get_domain_for_dev(&pdev->dev);
+		if (!dom) {
+			pr_err("%s: Domain not found (devid=%#x)\n",
+			       __func__, pci_dev_id(pdev));
+			return -EINVAL;
+		}
+
+		/* TODO: Only support pasid 0 for now */
+		amd_iommu_flush_tlb(dom, 0);
+		dump_device_mapping(iommu, gid, data->gdev_id);
+
+	} else {
+		clear_device_mapping(iommu, data->hdev_id, gid,
+				     data->queue_id, data->gdev_id);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(amd_viommu_device_update);
-- 
2.34.1

