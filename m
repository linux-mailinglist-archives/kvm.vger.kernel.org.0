Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA83273934A
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjFUX5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjFUX4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:56:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D6C1FF1;
        Wed, 21 Jun 2023 16:56:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/2kAoU7DJhIOZ8tUC35VVmxqhH4PSpFRA1nys+iYvGROb8GSav3tfCzhGScDwojgct72JI+lkyZq1NjNv8KXwv2zo+zQ1hLnWhUjxe2kOPHJNGTjR0ya+mAV14UJLGglf1gTCw+Too2ZsnrAp0XCIVi+5wbehR+VASe5Eg09cq+hFHYylRAnmR8t/3Ho5P/OVx4puYmnHuWHI1NIEHEEHRzVj0RDyF5heNwVLKfxOj2gHU9CmN68QDG8SNART+cXQ8b+3YxLwGQVnwHmBK/AdT2zcdB0exIzK/eDCAtPblkh51UFxajPPU80QDnJ5LDkMuukZ1HbAP76Ygcvq/bsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nIFai9SvDltThSc5w+t701fPid1b+Bnhu1xgFf/9xf0=;
 b=HTEGm/H3WAx/0KvQ4csgKg6hG2vUXNgxxaR91eI9jC9TVxkwtd541CFlAGdLYogesXjUnOHr2iGv33qoyBONSD4QB2Zt/v83xuUA09Es/J8Xvn6dRQtZO8uy/AxG9W3ZgJEh81gDFuC7LxppKNCChFBD0tvxJoOn+/nad+caGgwCEk4N4Uf9IWODHkxtuiL7XCStKyONm37mvJxDL72KYk0M5GTZIk6Dd/EoCYyj1YEfjMmU7NnJ4LwzhVXRBCGSmHtUyQIyYBKgjxlgHB+lcxnCdbGGraOZCKCjevsywXky6xtwhevohHaInPWDnIZM8pmuqTwA9fXfpz1fNsdo4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIFai9SvDltThSc5w+t701fPid1b+Bnhu1xgFf/9xf0=;
 b=nwziml1cx+IRmizYygzPqpZ3EqRuVLZfVNK/XBPuKnZZzCeQKV/495opJzBT/npTQQUUIHLbhruZS+3RWaIdEkEAHEx4WxffxtG22q3B9/iz2CE0c3e33XYIpCK3S4Knw11ZFPmPQn8fR46p4f0Vz/2fj6E7PlV6A0zHAx2/D2U=
Received: from CY8PR11CA0037.namprd11.prod.outlook.com (2603:10b6:930:4a::29)
 by SJ0PR12MB5502.namprd12.prod.outlook.com (2603:10b6:a03:300::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 23:56:05 +0000
Received: from CY4PEPF0000E9D1.namprd03.prod.outlook.com
 (2603:10b6:930:4a:cafe::f0) by CY8PR11CA0037.outlook.office365.com
 (2603:10b6:930:4a::29) with Microsoft SMTP Server (version=TLS1_2,
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
 2023 18:55:59 -0500
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
Subject: [RFC PATCH 18/21] iommu/amd: Introduce vIOMMU ioctl for handling guest MMIO accesses
Date:   Wed, 21 Jun 2023 18:55:05 -0500
Message-ID: <20230621235508.113949-19-suravee.suthikulpanit@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D1:EE_|SJ0PR12MB5502:EE_
X-MS-Office365-Filtering-Correlation-Id: f86a63b5-5a58-47bc-4a1d-08db72b3134a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+eWQbLq+6h6zLu+oY8IsTrRLo8EMykWEEYXSkK7D4iQvlOwsG9N1DaEflok9CLNoCKgWJgFQVEAV1RLjNBEEJjoZji4aGhj/8mupl1pMqZa04hM+L6HGtY9ghjNcHxAo81TN9xIBrp5TzSTMRsMrQ/aElUt/2Q+2MyE9QhmweLN5ha5Mqwu/aW+3hOOEAYatJ+mQ2iSfmHZsXoOWIHO+shRWIh4wxg0zwQqh5j/nN0/mH6l+ySzfAiYi6GIUjz6biEtXnTkqXWPyT611QCZVIyWpK93DWCo5oQ0HlPJ89kd1QZVVVTj1K1xUYZ/4oRKUTkYk9+j3/+CCe6URTYxGErgGQakNN3AXWdvKwl2E3VSq3lBr2xcN3gnQsNvuLQLRlqBChccJJgK/njVVMmnaRJmsG5ySGInCfYxSl2PkFd2Oe9LUQdBWUFgJGsOBPcah8z5to2ck1QUhTNAugcY3vGDkdqY5QQ8SX3Nm6md/pvxVETac1xSwD1qWKFvsyMGaXy7Vf8Cq7Ys/Nuh9mHJx9siOIIqGrqxh8hTsKH5h+MIrf/HnHJr/Ij+EQu/qFYyQboKGY/XPoRHxp6VqtlgQVKaHc39f4xAjvOw0TaHOpXyyQ0ByKAnVhjic10P1lnBtDDBjuyzlsPAAB7FvGesO+7yRe2uPQzYxA8vI3yJSZe45/Y2TRV92tf1ZU0lNyK+81rWsMIWrvdZUM1bMMXPR/NUJ3ZfRO5E49qVjoqAj2OlCgOAsjfkQVSiBVcYdafLiWW08I4eVqNi1XIFHbdQMQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(376002)(136003)(451199021)(36840700001)(46966006)(40470700004)(7696005)(6666004)(478600001)(36860700001)(82310400005)(36756003)(47076005)(16526019)(83380400001)(426003)(336012)(2616005)(86362001)(186003)(81166007)(40480700001)(356005)(82740400003)(1076003)(40460700003)(26005)(8936002)(8676002)(41300700001)(7416002)(44832011)(5660300002)(2906002)(110136005)(54906003)(316002)(70586007)(70206006)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:56:05.0311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f86a63b5-5a58-47bc-4a1d-08db72b3134a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5502
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

This ioctl interface is used for handling guest MMIO read / write
to IOMMU MMIO registers.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/viommu.c | 250 +++++++++++++++++++++++++++++++++++++
 1 file changed, 250 insertions(+)

diff --git a/drivers/iommu/amd/viommu.c b/drivers/iommu/amd/viommu.c
index 1bcb895cffbf..9ddbdbec4a75 100644
--- a/drivers/iommu/amd/viommu.c
+++ b/drivers/iommu/amd/viommu.c
@@ -744,3 +744,253 @@ int amd_viommu_device_update(struct amd_viommu_dev_info *data, bool is_set)
 	return 0;
 }
 EXPORT_SYMBOL(amd_viommu_device_update);
+
+int amd_viommu_guest_mmio_read(struct amd_viommu_mmio_data *data)
+{
+	u8 __iomem *vfctrl, *vf;
+	u64 val, tmp = 0;
+	int gid = data->gid;
+	struct amd_iommu *iommu = get_amd_iommu_from_devid(data->iommu_id);
+
+	if (!iommu)
+		return -ENODEV;
+
+	vf = VIOMMU_VF_MMIO_BASE(iommu, gid);
+	vfctrl = VIOMMU_VFCTRL_MMIO_BASE(iommu, gid);
+
+	switch (data->offset) {
+	case MMIO_CONTROL_OFFSET:
+	{
+		/* VFCTRL offset 20h */
+		val = readq(vfctrl + 0x20);
+		tmp |= SET_CTRL_BITS(val, 8, CONTROL_CMDBUF_EN, 1); // [12]
+		tmp |= SET_CTRL_BITS(val, 9, CONTROL_COMWAIT_EN, 1); // [4]
+
+		/* VFCTRL offset 28h */
+		val = readq(vfctrl + 0x28);
+		tmp |= SET_CTRL_BITS(val, 8, CONTROL_EVT_LOG_EN, 1); // [2]
+		tmp |= SET_CTRL_BITS(val, 9, CONTROL_EVT_INT_EN, 1); // [3]
+		tmp |= SET_CTRL_BITS(val, 10, CONTROL_DUALEVTLOG_EN, 3); // [33:32]
+
+		/* VFCTRL offset 30h */
+		val = readq(vfctrl + 0x30);
+		tmp |= SET_CTRL_BITS(val, 8, CONTROL_PPRLOG_EN, 1); // [13]
+		tmp |= SET_CTRL_BITS(val, 9, CONTROL_PPRINT_EN, 1); // [14]
+		tmp |= SET_CTRL_BITS(val, 10, CONTROL_PPR_EN, 1); // [15]
+		tmp |= SET_CTRL_BITS(val, 11, CONTROL_DUALPPRLOG_EN, 3); // [31:30]
+		tmp |= SET_CTRL_BITS(val, 13, CONTROL_PPR_AUTO_RSP_EN, 1); // [39]
+		tmp |= SET_CTRL_BITS(val, 14, CONTROL_BLKSTOPMRK_EN, 1); // [41]
+		tmp |= SET_CTRL_BITS(val, 15, CONTROL_PPR_AUTO_RSP_AON, 1); // [42]
+
+		data->value = tmp;
+		break;
+	}
+	case MMIO_CMD_BUF_OFFSET:
+	{
+		val = readq(vfctrl + 0x20);
+		/* CmdLen [59:56] */
+		tmp |= SET_CTRL_BITS(val, 0, 56, 0xF);
+		data->value = tmp;
+		break;
+	}
+	case MMIO_EVT_BUF_OFFSET:
+	{
+		val = readq(vfctrl + 0x28);
+		/* EventLen [59:56] */
+		tmp |= SET_CTRL_BITS(val, 0, 56, 0xF);
+		data->value = tmp;
+		break;
+	}
+	case MMIO_EVTB_LOG_OFFSET:
+	{
+		val = readq(vfctrl + 0x28);
+		/* EventLenB [59:56] */
+		tmp |= SET_CTRL_BITS(val, 4, 56, 0xF);
+		data->value = tmp;
+		break;
+	}
+	case MMIO_PPR_LOG_OFFSET:
+	{
+		val = readq(vfctrl + 0x30);
+		/* PPRLogLen [59:56] */
+		tmp |= SET_CTRL_BITS(val, 0, 56, 0xF);
+		data->value = tmp;
+		break;
+	}
+	case MMIO_PPRB_LOG_OFFSET:
+	{
+		val = readq(vfctrl + 0x30);
+		/* PPRLogLenB [59:56] */
+		tmp |= SET_CTRL_BITS(val, 4, 56, 0xF);
+		data->value |= tmp;
+		break;
+	}
+	case MMIO_CMD_HEAD_OFFSET:
+	{
+		val = readq(vf + 0x0);
+		data->value = (val & 0x7FFF0);
+		break;
+	}
+	case MMIO_CMD_TAIL_OFFSET:
+	{
+		val = readq(vf + 0x8);
+		data->value = (val & 0x7FFF0);
+		break;
+	}
+	case MMIO_EXT_FEATURES:
+	{
+		amd_iommu_build_efr(&data->value, NULL);
+		break;
+	}
+	default:
+		break;
+	}
+
+	pr_debug("%s: iommu_id=%#x, gid=%u, offset=%#x, value=%#llx, mmio_size=%u, is_write=%u\n",
+		 __func__, data->iommu_id, gid, data->offset,
+		 data->value, data->mmio_size, data->is_write);
+	return 0;
+}
+EXPORT_SYMBOL(amd_viommu_guest_mmio_read);
+
+/* Note:
+ * This function maps the guest MMIO write to AMD IOMMU MMIO registers
+ * into vIOMMU VFCTRL register bits.
+ */
+int amd_viommu_guest_mmio_write(struct amd_viommu_mmio_data *data)
+{
+	u8 __iomem *vfctrl, *vf;
+	int gid = data->gid;
+	u64 val, tmp, ctrl = data->value;
+	struct amd_iommu *iommu = get_amd_iommu_from_devid(data->iommu_id);
+
+	if (!iommu)
+		return -ENODEV;
+
+	pr_debug("%s: iommu_id=%#x, gid=%u, offset=%#x, value=%#llx, mmio_size=%u, is_write=%u\n",
+		 __func__, data->iommu_id, gid, data->offset,
+		 ctrl, data->mmio_size, data->is_write);
+
+	vf = VIOMMU_VF_MMIO_BASE(iommu, gid);
+	vfctrl = VIOMMU_VFCTRL_MMIO_BASE(iommu, gid);
+
+	switch (data->offset) {
+	case MMIO_CONTROL_OFFSET:
+	{
+		/* VFCTRL offset 20h */
+		val = readq(vfctrl + 0x20);
+		val &= ~(0x3ULL << 8);
+		tmp = GET_CTRL_BITS(ctrl, CONTROL_CMDBUF_EN, 1); // [12]
+		val |= (tmp << 8);
+		tmp = GET_CTRL_BITS(ctrl, CONTROL_COMWAIT_EN, 1); // [4]
+		val |= (tmp << 9);
+		writeq(val, vfctrl + 0x20);
+
+		/* VFCTRL offset 28h */
+		val = readq(vfctrl + 0x28);
+		val &= ~(0xFULL << 8);
+		tmp = GET_CTRL_BITS(ctrl, CONTROL_EVT_LOG_EN, 1); // [2]
+		val |= (tmp << 8);
+		tmp = GET_CTRL_BITS(ctrl, CONTROL_EVT_INT_EN, 1); // [3]
+		val |= (tmp << 9);
+		tmp = GET_CTRL_BITS(ctrl, CONTROL_DUALEVTLOG_EN, 3); // [33:32]
+		val |= (tmp << 10);
+		writeq(val, vfctrl + 0x28);
+
+		/* VFCTRL offset 30h */
+		val = readq(vfctrl + 0x30);
+		val &= ~(0xFFULL << 8);
+		tmp = GET_CTRL_BITS(ctrl, CONTROL_PPRLOG_EN, 1); // [13]
+		val |= (tmp << 8);
+		tmp = GET_CTRL_BITS(ctrl, CONTROL_PPRINT_EN, 1); // [14]
+		val |= (tmp << 9);
+		tmp = GET_CTRL_BITS(ctrl, CONTROL_PPR_EN, 1); // [15]
+		val |= (tmp << 10);
+		tmp = GET_CTRL_BITS(ctrl, CONTROL_DUALPPRLOG_EN, 3); // [31:30]
+		val |= (tmp << 11);
+		tmp = GET_CTRL_BITS(ctrl, CONTROL_PPR_AUTO_RSP_EN, 1); // [39]
+		val |= (tmp << 13);
+		tmp = GET_CTRL_BITS(ctrl, CONTROL_BLKSTOPMRK_EN, 1); // [41]
+		val |= (tmp << 14);
+		tmp = GET_CTRL_BITS(ctrl, CONTROL_PPR_AUTO_RSP_AON, 1); // [42]
+		val |= (tmp << 15);
+		writeq(val, vfctrl + 0x30);
+		break;
+	}
+	case MMIO_CMD_BUF_OFFSET:
+	{
+		val = readq(vfctrl + 0x20);
+		val &= ~(0xFULL);
+		/* CmdLen [59:56] */
+		tmp = GET_CTRL_BITS(ctrl, 56, 0xF);
+		val |= tmp;
+		writeq(val, vfctrl + 0x20);
+		break;
+	}
+	case MMIO_EVT_BUF_OFFSET:
+	{
+		val = readq(vfctrl + 0x28);
+		val &= ~(0xFULL);
+		/* EventLen [59:56] */
+		tmp = GET_CTRL_BITS(ctrl, 56, 0xF);
+		val |= tmp;
+		writeq(val, vfctrl + 0x28);
+		break;
+	}
+	case MMIO_EVTB_LOG_OFFSET:
+	{
+		val = readq(vfctrl + 0x28);
+		val &= ~(0xF0ULL);
+		/* EventLenB [59:56] */
+		tmp = GET_CTRL_BITS(ctrl, 56, 0xF);
+		val |= (tmp << 4);
+		writeq(val, vfctrl + 0x28);
+		break;
+	}
+	case MMIO_PPR_LOG_OFFSET:
+	{
+		val = readq(vfctrl + 0x30);
+		val &= ~(0xFULL);
+		/* PPRLogLen [59:56] */
+		tmp = GET_CTRL_BITS(ctrl, 56, 0xF);
+		val |= tmp;
+		writeq(val, vfctrl + 0x30);
+		break;
+	}
+	case MMIO_PPRB_LOG_OFFSET:
+	{
+		val = readq(vfctrl + 0x30);
+		val &= ~(0xF0ULL);
+		/* PPRLogLenB [59:56] */
+		tmp = GET_CTRL_BITS(ctrl, 56, 0xF);
+		val |= (tmp << 4);
+		writeq(val, vfctrl + 0x30);
+		break;
+	}
+	case MMIO_CMD_HEAD_OFFSET:
+	{
+		val = readq(vf + 0x0);
+		val &= ~(0x7FFFULL << 4);
+		tmp = GET_CTRL_BITS(ctrl, 4, 0x7FFF);
+		val |= (tmp << 4);
+		writeq(val, vf + 0x0);
+		break;
+	}
+	case MMIO_CMD_TAIL_OFFSET:
+	{
+		val = readq(vf + 0x8);
+		val &= ~(0x7FFFULL << 4);
+		tmp = GET_CTRL_BITS(ctrl, 4, 0x7FFF);
+		val |= (tmp << 4);
+		writeq(val, vf + 0x8);
+		break;
+	}
+	default:
+		break;
+	}
+
+	pr_debug("%s: offset=%#x, val=%#llx, ctrl=%#llx\n",
+		 __func__, data->offset, val, ctrl);
+	return 0;
+}
+EXPORT_SYMBOL(amd_viommu_guest_mmio_write);
-- 
2.34.1

