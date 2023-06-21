Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8650473936C
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjFUX5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjFUX4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:56:44 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFE21FCF;
        Wed, 21 Jun 2023 16:56:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXu1LWIXOQiD38SKsv/WHaeN+pafma22OPQZhwK8jwC/5h5/LwayU7F2pNSmz4q8zEcPgLV9JZrdveZvcyIG6BFPDUrH9rIVM+iVan8kMm/TZ+MIdMt8bMJqPNVs1JITOg3UKK5S9t4EIz4rLlkH26uhqbVb+taFVj55CRMGjcFAFF2jq3M/Vs/UOJKhL3xSofK/wBh3TeZo51ywiwgygxAbpabcarHkp0TerHelEO1no1usLzlqe1v/LFPLO0sla8PMm9+pBEZP4ZdU6miRhBYXDg8Mscm3iYQXvjMBLqesgkGyQ5uOe99QyDodj4SIRQnHq+JeFw8GThOzNas5PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I/VvDHsJmf9dnALNK7qOxaQqho6s79GG+SmVZtCnGxg=;
 b=P6QR6HpFRw+o5Wcl4eG8nkecyf7LINT/ymSmFHO1jBf0z6EIx5B0XocoRGh/dhSkxqbM6PbHc/J1BdfEb3cvcW6SHvgxTXlyQWxetWIl35Al6a6RDz2tZ65hNriAoW1xeIi460BroXqZq6BAgsEFFsh4PBfeX4UT+Icelua1QcvxQoChfavLEmDW17CELVF3OPYMQ8zr3QcHcPIEcy+MeIgPfmEWwqsWEOaZ+PEE+PxTpj1jvt+UtmAINqSGX/PZiJQ/dXYi8E8wShFCRpcVAPoGlRYUIqW0jULaChbqDTqj1BJin10ckUIAFR4MwZJWgrZc448QsUecfIQPDwtvZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/VvDHsJmf9dnALNK7qOxaQqho6s79GG+SmVZtCnGxg=;
 b=HWNqZFUZ18WbQb4neTpzRlbW/DifoVynX+eywl5dxjEZpFnAF6eptVryxjxt0CGlX4R4rIhFVR+5+hl47LMfPtaooIQXPK+5qoENJUPumxMBhcLw2QCalVpg47hKbtnrl9fWNgzUqrU1y6918GxcOi0QXMC3rUGD0gH4pU8gjcM=
Received: from CYZPR10CA0006.namprd10.prod.outlook.com (2603:10b6:930:8a::12)
 by SJ2PR12MB7920.namprd12.prod.outlook.com (2603:10b6:a03:4c6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Wed, 21 Jun
 2023 23:56:03 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:930:8a:cafe::bd) by CYZPR10CA0006.outlook.office365.com
 (2603:10b6:930:8a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24 via Frontend
 Transport; Wed, 21 Jun 2023 23:56:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.24 via Frontend Transport; Wed, 21 Jun 2023 23:56:02 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:55:58 -0500
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
Subject: [RFC PATCH 17/21] iommu/amd: Introduce vIOMMU ioctl for updating domain mapping
Date:   Wed, 21 Jun 2023 18:55:04 -0500
Message-ID: <20230621235508.113949-18-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|SJ2PR12MB7920:EE_
X-MS-Office365-Filtering-Correlation-Id: 587bf228-48bd-4c05-18f3-08db72b311f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QISvJwkL6Vsyd6Ew5uZsOVaBxKih8X/elzhodu/UZqxZyH7uHwy1Jx54v+EPJMNYjvgt6rzBaglYhABNuKhPQNkexJtvEp4b8lYSz0yi6QcrnQbYfJRUrDJXZ+4+Juu0B7XHBczPywHvFz6Ax7hMn6nsUQ7LwBVOSlEEW6UKZ/DQmVKUDIWEh1xLPdkTU4WL98i+qiL8ofCluWT//0AKxNkB+kEcuMQppJO6tEWU4vYE/zWDEjVAaWkaxITyW+7pGsuHy2PHOrZm/4eXgBsvYGoN7OHlOsA1CpheYLOSMYGqunU0UGd5ZZCj3HBjIpQNkZVvALpF9+zXFJS2QneO9gnd42G9FK40cbDqjNJ7ylV7ZepbDIhsIcMNPYu94ZzIy8JWI6B1LJfft2jSkbGW/qMdCtViEuFS/cttpMe73EqG7XS9N21Ed1qcyP5WmOO26ARD8tvz3r7Wv/RXk5+CYKjQ2BSTJ69gC/zBG/UoYhxnkMZzz6b755nNWjhZL0hjhef8TXcLwmeYDYrsMEeZQQ2PsV6HJmiV0c3x+9dM1FxA+1u9blhGEOJDDqrX5Y10nmn1vFrATB6J1wmlj63RjdxU9YDgvV1tiRnd4CXX7ySEcS2rJivX3+A7kIbANLX42CaxaUyO/OA9/5RxkvnRC2uOMdHkgCbDXHPBPVlXXR99APzCFde42Zq6u3UbbXjVOYb1zFd86KBHGOcCEAn+bNxtFiuvAuMz717m2hSz+kR4XVobvR/YG9oviEDfPfC+26umxKEyuuALKZO/Q1fUkQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(110136005)(47076005)(44832011)(2906002)(82310400005)(36756003)(36860700001)(70206006)(83380400001)(81166007)(426003)(336012)(7416002)(86362001)(356005)(82740400003)(5660300002)(186003)(41300700001)(16526019)(8936002)(8676002)(26005)(2616005)(316002)(6666004)(7696005)(4326008)(478600001)(40460700003)(70586007)(54906003)(1076003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:56:02.8173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 587bf228-48bd-4c05-18f3-08db72b311f6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7920
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
domain ID mappings.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/viommu.c | 95 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/drivers/iommu/amd/viommu.c b/drivers/iommu/amd/viommu.c
index f6f0056c7fe6..1bcb895cffbf 100644
--- a/drivers/iommu/amd/viommu.c
+++ b/drivers/iommu/amd/viommu.c
@@ -520,6 +520,101 @@ int amd_viommu_iommu_destroy(struct amd_viommu_iommu_info *data)
 }
 EXPORT_SYMBOL(amd_viommu_iommu_destroy);
 
+/*
+ * Program the DomID via VFCTRL registers
+ * This function will be called during VM init via VFIO.
+ */
+static void set_domain_mapping(struct amd_iommu *iommu, u16 guestId, u16 hDomId, u16 gDomId)
+{
+	u64 val, tmp1, tmp2;
+	u8 __iomem *vfctrl = VIOMMU_VFCTRL_MMIO_BASE(iommu, guestId);
+
+	pr_debug("%s: iommu_id=%#x, gid=%#x, dom_id=%#x, gdom_id=%#x, val=%#llx\n",
+		 __func__, pci_dev_id(iommu->dev), guestId, hDomId, gDomId, val);
+
+	tmp1 = gDomId;
+	tmp1 = ((tmp1 & 0xFFFFULL) << 46);
+	tmp2 = hDomId;
+	tmp2 = ((tmp2 & 0xFFFFULL) << 14);
+	val = tmp1 | tmp2 | 0x8000000000000001UL;
+	writeq(val, vfctrl + VIOMMU_VFCTRL_GUEST_DID_MAP_CONTROL1_OFFSET);
+	wbinvd_on_all_cpus();
+}
+
+u64 get_domain_mapping(struct amd_iommu *iommu, u16 gid, u16 gdom_id)
+{
+	void *addr;
+	u64 offset, val;
+	struct amd_iommu_vminfo *vminfo;
+
+	vminfo = get_vminfo(iommu, gid);
+	if (!vminfo)
+		return -EINVAL;
+
+	addr = vminfo->domid_table;
+	offset = gdom_id << 3;
+	val = *((u64 *)(addr + offset));
+
+	return val;
+}
+
+void dump_domain_mapping(struct amd_iommu *iommu, u16 gid, u16 gdom_id)
+{
+	void *addr;
+	u64 offset, val;
+	struct amd_iommu_vminfo *vminfo;
+
+	vminfo = get_vminfo(iommu, gid);
+	if (!vminfo)
+		return;
+
+	addr = vminfo->domid_table;
+	offset = gdom_id << 3;
+	val = *((u64 *)(addr + offset));
+
+	pr_debug("%s: offset=%#llx(val=%#llx)\n", __func__,
+		(unsigned long long)offset,
+		(unsigned long long)val);
+}
+
+static u16 viommu_get_hdev_id(struct amd_iommu *iommu, u16 guestId, u16 gdev_id)
+{
+	struct amd_iommu_vminfo *vminfo;
+	void *addr;
+	u64 offset;
+
+	vminfo = get_vminfo(iommu, guestId);
+	if (!vminfo)
+		return -1;
+
+	addr = vminfo->devid_table;
+	offset = gdev_id << 4;
+	return (*((u64 *)(addr + offset)) >> 24) & 0xFFFF;
+}
+
+int amd_viommu_domain_update(struct amd_viommu_dom_info *data, bool is_set)
+{
+	u16 hdom_id, hdev_id;
+	int gid = data->gid;
+	struct amd_iommu *iommu = get_amd_iommu_from_devid(data->iommu_id);
+	struct dev_table_entry *dev_table = get_dev_table(iommu);
+
+	if (!iommu)
+		return -ENODEV;
+
+	hdev_id = viommu_get_hdev_id(iommu, gid, data->gdev_id);
+	hdom_id = dev_table[hdev_id].data[1] & 0xFFFFULL;
+
+	if (is_set) {
+		set_domain_mapping(iommu, gid, hdom_id, data->gdom_id);
+		dump_domain_mapping(iommu, 0, data->gdom_id);
+	} else
+		clear_domain_mapping(iommu, gid, hdom_id, data->gdom_id);
+
+	return 0;
+}
+EXPORT_SYMBOL(amd_viommu_domain_update);
+
 static void set_dte_viommu(struct amd_iommu *iommu, u16 hDevId, u16 gid, u16 gDevId)
 {
 	u64 tmp, dte;
-- 
2.34.1

