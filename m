Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865796FD472
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbjEJDgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbjEJDff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:35:35 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC656593;
        Tue,  9 May 2023 20:34:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdLQSOc/PKEiOTcDmtfJlW95E8pzf3k3trX4sTbps25QzS7dXN7E4DMzkdGASz4eultX3Q7b8KbyBDDWfiX2yX1yHra2MT/4ErsKjHM7SkbI2RvwApo7Te2gHv1cgy6Kx8wfo7aZhhaZeJ8S5z4B7pGGXwV8+A4ztJ3JW+cXCincRO4KbqFPwuJGXxWncsS5IOlJtpIOPFyK4x37vBDf3m4GNn6bqpMJPr5j4iEgwQJ+kaRPdwglqikN3mmvZBJYh4tRFgHkiThxSmAKO1ekmulaZUABJqh1sTIS+8zGsBE7Fjnq23hg6BYSq37sWrERea8hxS03LTqES3lrdTpQJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sk58qbv9dLfH8MVN5qR9ZuRzKUxQ2e8g0y0e7qDp7X4=;
 b=MffbsOBm1cgyO1B29qvu82gEZ0inpxkToChKFEgqMbxYNq63bB94wB9nkJJAQQrQ3+iWAkZ+Ho2FSfjEauBtN7Ux/GSzbvZjsamEnEiTCB0utpqHbEjxpV0IwsRmHlRDxQ4+c+7SVbsSjBagE16YOOXRCMLWiNt9H0DqnEE9O+LQ2FIEAIQLk3Z7zxfy1sZNrUMF5FC+HSnTn9qhJicA6KHLUlWhh01JM0VppBiUISxQ9Gk2mrQ1nJyEPumg/x5wbur6HhjSebWFB83mUhW6uVEiCDvaBvjF2b0Hd2J1fM53/Pu8T5iO1yXDTGjYvtN67G1+39WWKbY3XBcO/5NAaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sk58qbv9dLfH8MVN5qR9ZuRzKUxQ2e8g0y0e7qDp7X4=;
 b=ObDzgKO8Ih91D1trajBTlgzLUB3wo9AMPqxZZLDdXU1KcjweqCOFsuUNr7oZhBprl9z3eI8UmTXezFu7B84Ven01Wjav2BcUImgeW92rOsP1Rvjb+3nmrxoVWEAKcMldqXDYWCVpdzi19feOvRWFHl1Fj5lwvMyasYH+qNivv7dlGC+6tCmeQhIOBYmdadyyUWOQHveWrOvKrEZwQ6VNuvh2KcOIE3cJPOIJ1oE3fY7o9v4oFCyPmlcSiHtvINTAyL0EAEpkVb+uLEnO2PanFqfe5U9zrSdy2Z6Tr3LiEgK6pFKawp5CmnqlYoKs10taZMTGqyB2YJ6YVMc8y8AZuA==
Received: from MN2PR11CA0019.namprd11.prod.outlook.com (2603:10b6:208:23b::24)
 by DM6PR12MB5024.namprd12.prod.outlook.com (2603:10b6:5:20a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 03:34:43 +0000
Received: from BL02EPF000145BB.namprd05.prod.outlook.com
 (2603:10b6:208:23b:cafe::47) by MN2PR11CA0019.outlook.office365.com
 (2603:10b6:208:23b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18 via Frontend
 Transport; Wed, 10 May 2023 03:34:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000145BB.mail.protection.outlook.com (10.167.241.211) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.20 via Frontend Transport; Wed, 10 May 2023 03:34:42 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:29 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:29 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:28 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 17/17] iommu/arm-smmu-v3: Add arm_smmu_cache_invalidate_user
Date:   Tue, 9 May 2023 20:33:37 -0700
Message-ID: <6bacfc7213e9934f81bdc06a47bf58816f87e63b.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145BB:EE_|DM6PR12MB5024:EE_
X-MS-Office365-Filtering-Correlation-Id: 66d67722-64d8-4f0c-10d7-08db51077e44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z5EqzkAFqFmx+s2uh1V1n1NOC/qgzFJvOHBMx0lpyiMwNa5Y7WNU9TIlizm8+tzTaMiErLJJjdRv8PKipaOvzApBABO73mPye8emK9fen1Cw5R8AugnAozcDs8WdY5yIawKSPSV2yWH3tE17WhSTEJG5nuX4rsOmzDhWKV1At/Nr0J46Z3omQhUiJ2/uzdtTyXZHDAzGRPY220RoV7cNIrPUwah2+R5NEB61woe9xwCIPWLbjJikuGVjYj3Vf2TTVnS+WUNnWe9q6AuyZ7AlE/iGItcPN1g+zlwdoRKIGXWqeMzuCkbcWlblWPnxeh3gVLFcqCP2/Tn8xK0cFO5e+CBzBycR3HmBbFmXKNQVIbcrU5ecc6z1VqIKikUhBryTuqcPzhJ1YySNM536Y+pUBKCR+8g0qcvVuK8gjMMhswub5CiODrEhewJT2neI02/aZy3VuLEXqNXwD6FplbwNNo7ip83QCWObhT6tK9PtxguDdisAC98j7o0MSLHGbdjpg56cxqudvDhELOMdI/oktUp4gN7PRsdhH1Pdm5UmAoZWZ6zD1dLpH7noQD+uZ7/go5MB3mfcPMIfXuVWKuGxMozAgQGKJ4r1+FATpA/Vmu2mFf0O5VpXU+KtRsNYu3KxjG6pYJzjz1RJcBZLQLHmANW/QsJLLHSuEMOfFHOkN9xvWpUhDKJTHHcOdWnB9BEP58kk+cK8TKu3+mkKKD+wyA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199021)(40470700004)(36840700001)(46966006)(26005)(7696005)(40480700001)(336012)(426003)(36860700001)(2616005)(36756003)(86362001)(356005)(82310400005)(186003)(40460700003)(82740400003)(47076005)(83380400001)(110136005)(41300700001)(54906003)(4326008)(2906002)(7636003)(5660300002)(8676002)(478600001)(8936002)(316002)(7416002)(70586007)(70206006)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:42.6193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d67722-64d8-4f0c-10d7-08db51077e44
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145BB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5024
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

Add arm_smmu_cache_invalidate_user() function for user space to invalidate
TLB entries and Context Descriptors, since either an IO page table entrie
or a Context Descriptor in the user space is still cached by the hardware.

The input user_data is defined in struct iommu_hwpt_invalidate_arm_smmuv3,
which contains the essential info of the command queue of the guest OS. It
will be read by the host kernel to have a direct access to the guest queue
to fetch all invalidation commands. Those commands should be also fixed at
the SID and VMID fields by replacing with the correct physical values.

Co-developed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 113 ++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3902dd8cfcfa..124f63fe52e1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2994,10 +2994,123 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	arm_smmu_sva_remove_dev_pasid(domain, dev, pasid);
 }
 
+static int arm_smmu_fix_user_cmd(struct arm_smmu_domain *smmu_domain, u64 *cmd)
+{
+	struct arm_smmu_stream *stream;
+
+	switch (*cmd & CMDQ_0_OP) {
+	case CMDQ_OP_TLBI_NSNH_ALL:
+		*cmd &= ~CMDQ_0_OP;
+		*cmd |= CMDQ_OP_TLBI_NH_ALL;
+		fallthrough;
+	case CMDQ_OP_TLBI_NH_VA:
+	case CMDQ_OP_TLBI_NH_VAA:
+	case CMDQ_OP_TLBI_NH_ALL:
+	case CMDQ_OP_TLBI_NH_ASID:
+		*cmd &= ~CMDQ_TLBI_0_VMID;
+		*cmd |= FIELD_PREP(CMDQ_TLBI_0_VMID,
+				   smmu_domain->s2->s2_cfg.vmid);
+		break;
+	case CMDQ_OP_ATC_INV:
+	case CMDQ_OP_CFGI_CD:
+	case CMDQ_OP_CFGI_CD_ALL:
+		xa_lock(&smmu_domain->smmu->streams_user);
+		stream = xa_load(&smmu_domain->smmu->streams_user,
+				 FIELD_GET(CMDQ_CFGI_0_SID, *cmd));
+		xa_unlock(&smmu_domain->smmu->streams_user);
+		if (!stream)
+			return -ENODEV;
+		*cmd &= ~CMDQ_CFGI_0_SID;
+		*cmd |= FIELD_PREP(CMDQ_CFGI_0_SID, stream->id);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	pr_debug("Fixed user CMD: %016llx : %016llx\n", cmd[1], cmd[0]);
+
+	return 0;
+}
+
+static int arm_smmu_cache_invalidate_user(struct iommu_domain *domain,
+					   void *user_data)
+{
+	const u32 cons_err = FIELD_PREP(CMDQ_CONS_ERR, CMDQ_ERR_CERROR_ILL_IDX);
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct iommu_hwpt_invalidate_arm_smmuv3 *inv = user_data;
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_queue q = {
+		.llq = {
+			.prod = inv->cmdq_prod,
+			.max_n_shift = inv->cmdq_log2size,
+		},
+		.base = u64_to_user_ptr(inv->cmdq_uptr),
+		.ent_dwords = inv->cmdq_entry_size / sizeof(u64),
+	};
+	unsigned int nents = 1 << q.llq.max_n_shift;
+	void __user *cons_uptr;
+	int ncmds, i = 0;
+	u32 prod, cons;
+	u64 *cmds;
+	int ret;
+
+	if (!smmu || !smmu_domain->s2 || domain->type != IOMMU_DOMAIN_NESTED)
+		return -EINVAL;
+	if (q.ent_dwords != CMDQ_ENT_DWORDS)
+		return -EINVAL;
+	WARN_ON(q.llq.max_n_shift > smmu->cmdq.q.llq.max_n_shift);
+
+	cons_uptr = u64_to_user_ptr(inv->cmdq_cons_uptr);
+	if (copy_from_user(&q.llq.cons, cons_uptr, sizeof(u32)))
+		return -EFAULT;
+	if (queue_empty(&q.llq))
+		return -EINVAL;
+
+	prod = Q_IDX(&q.llq, q.llq.prod);
+	cons = Q_IDX(&q.llq, q.llq.cons);
+	if (Q_WRP(&q.llq, q.llq.prod) == Q_WRP(&q.llq, q.llq.cons))
+		ncmds = prod - cons;
+	else
+		ncmds = nents - cons + prod;
+	cmds = kcalloc(ncmds, inv->cmdq_entry_size, GFP_KERNEL);
+	if (!cmds)
+		return -ENOMEM;
+
+	do {
+		u64 *cmd = &cmds[i * CMDQ_ENT_DWORDS];
+
+		ret = copy_from_user(cmd, Q_ENT(&q, q.llq.cons),
+				     inv->cmdq_entry_size);
+		if (ret) {
+			ret = -EFAULT;
+			goto out_free_cmds;
+		}
+
+		ret = arm_smmu_fix_user_cmd(smmu_domain, cmd);
+		if (ret && ret != -EOPNOTSUPP) {
+			q.llq.cons |= cons_err;
+			goto out_copy_cons;
+		}
+		if (!ret)
+			i++;
+		queue_inc_cons(&q.llq);
+	} while (!queue_empty(&q.llq));
+
+	ret = arm_smmu_cmdq_issue_cmdlist(smmu, cmds, i, true);
+out_copy_cons:
+	if (copy_to_user(cons_uptr, &q.llq.cons, sizeof(u32)))
+		ret = -EFAULT;
+out_free_cmds:
+	kfree(cmds);
+	return ret;
+}
+
 static const struct iommu_domain_ops arm_smmu_nested_domain_ops = {
 	.attach_dev		= arm_smmu_attach_dev,
 	.free			= arm_smmu_domain_free,
 	.get_msi_mapping_domain	= arm_smmu_get_msi_mapping_domain,
+	.cache_invalidate_user	= arm_smmu_cache_invalidate_user,
+	.cache_invalidate_user_data_len =
+		sizeof(struct iommu_hwpt_invalidate_arm_smmuv3),
 };
 
 /**
-- 
2.40.1

