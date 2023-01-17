Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28E666DA99
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 11:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbjAQKIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 05:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbjAQKIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 05:08:38 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166642DE45;
        Tue, 17 Jan 2023 02:08:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMgpebInUd6BKcW50Oaxz1ZdZQIcmyNZTvQN52+dfA6rVd6oSmZSAh7UKlzoRVx49LUrVQcp40b0atJ4I/9jDp44k1ubMwlayd+3Z7qAa0fQ04PqpjZP48ipHcCOp7LeHKLS3AoCNDQk4i00lzxq5m4X3psqZH0juZZtD6zr+gzAhC+tTaXZ/vJAOFB/9gg0ntTHkFkE2oeFivacJYn3Q7EwK5viEvsuRhcQWMaOzyTTBnYahYvbjW/42YIedA+Txdm+wZgx2+30T1IBQLP8mOcnN03Q+prMC6BHzYK+WyllnBUUM0bSE/DOn40udd99UeTAh4KB4TmhCYO/2su4bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=364Y0Tn4vWEFu3Lz8Rz9DEx5PLzJloKI1hF4jmspYFc=;
 b=Oz/m2/Pd05h9wzWyK/b4Yf0zsMlNlzfATrJAt2CbbEZJNGsh9SunvpuYXm4dOrIDSauWNDeMEp76QmXAyVSp0N2WcghwkSBs8PbxrHaT7nRvsinLA+wcMTV3BdsawflecI4ERD+BcTkpdh2ei5gz1i6wLKQhVZhkqA2y4HgGn5OMzd1xL/QcPrqUj4Fh2gdQUgJJCwr3CgFKkLjpQ9DxyZQm3Cff8pxQ2tZQ/UFbCTBp0B9diqSWxCPTGpY1n0u7EZT2zXp1rPXWw8VWFxtrBnwJ6DZL0X3tUTPcZ1NqQY2gWw8yURFlEPeM5mXansFLxRRoAXyqEUgDS1Q6vLaWXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=364Y0Tn4vWEFu3Lz8Rz9DEx5PLzJloKI1hF4jmspYFc=;
 b=fxCNwU1zSA4BO45VC381TlF8h/fz2g0NmxoHjGP/FTPx4/0rVXrAtSVXOfBtzI0pc2+clt9NbQQBJFm7UpUDX8fqyceNYYYtCcksRHe8LIiYABXxhQOm4/7Qtqr4ail2PNp9cdvGpzx0+lfZ+xgQuGu0/hVvu8kBAhK+0Fx+2Yk=
Received: from DM6PR01CA0017.prod.exchangelabs.com (2603:10b6:5:296::22) by
 PH7PR12MB6394.namprd12.prod.outlook.com (2603:10b6:510:1fe::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 17 Jan
 2023 10:08:34 +0000
Received: from DM6NAM11FT070.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::f5) by DM6PR01CA0017.outlook.office365.com
 (2603:10b6:5:296::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Tue, 17 Jan 2023 10:08:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT070.mail.protection.outlook.com (10.13.173.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Tue, 17 Jan 2023 10:08:34 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 17 Jan
 2023 04:08:32 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <seanjc@google.com>, <alejandro.j.jimenez@oracle.com>,
        <mlevitsk@redhat.com>, <pbonzini@redhat.com>, <jon.grimm@amd.com>,
        <vasant.hegde@amd.com>, <kishon.vijayabraham@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] KVM: SVM: Modify AVIC GATag to support max number of 512 vCPUs
Date:   Tue, 17 Jan 2023 04:08:21 -0600
Message-ID: <20230117100821.10116-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT070:EE_|PH7PR12MB6394:EE_
X-MS-Office365-Filtering-Correlation-Id: 725c395e-4498-4e94-4841-08daf872cb3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yBF5H9shXHi2YS52+rDtiHq4fGRi1eZrPlh/08uwq7rJ0wMLVvbjb9f1dc5BHTAM59mXNkMnsdjmw5LDkXM6gnufJ6wh6GN1xKrljotKnFuFWHLeZ+LX1TzF93rekpM/SaWZxuxyW5uOw5Aq1/dChIXmbUcSZ9VHKIjQ1SeQrGmodSgvEyq6/NsHoF18g27uZCy4ud24f9m4uYpAHPbbdCXfNOyXUS7z5vb0fcZgfOjzAt90P5zJr/rT4ipHm+/BIzcGxC2cii5PisVZzNQDWG27EZef2otG7w/BTOtFQ0mM3PvYtluONWDwyg5w3wYA98kKDGrLxWC2dnGbVvMc1NufHMjtAEBQnmQFTFlf7nmq6PrBewX4+Yu8yJEGBti3dDMoUv6V10GbI1AjK6eVuZSx/wZRbtOW9wHc0k6IpI8K10GJXO3J6StyIT9FpXt8rkqL6m7NM3Q1aZWzWyqgyLOA6H2ex5I8xhNUQNzPh0/qdDK1ieX6gmBvyiTlYP8LdVNqR1GCteelcHF/KpKDJpN3XNnLNiNQ2q++RKjki81g0IDAKuUR9A9/ffqSB1gxkY8RGCf4hQsozTQYeoNxdLZcTjXnB9HLYvtooXVE11y3Bmr/f4VI1QW5jHyrazB2b4eJFv13lXw+qmQcfP/POoMR1X25B1LO3B2JJ53LgkSCpyAXDCFu3nr4lhLXfLd81WfySprhojjgydmP0+gmnJx82r8gW/aY+DbZuFP4zCM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199015)(36840700001)(40470700004)(46966006)(36756003)(356005)(8676002)(70206006)(70586007)(110136005)(4326008)(83380400001)(54906003)(41300700001)(40460700003)(82740400003)(86362001)(36860700001)(7696005)(26005)(186003)(6666004)(81166007)(316002)(478600001)(1076003)(44832011)(2906002)(426003)(5660300002)(8936002)(40480700001)(2616005)(82310400005)(336012)(16526019)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 10:08:34.5407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 725c395e-4498-4e94-4841-08daf872cb3c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT070.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6394
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AVIC GATag is managed by the SVM driver, and is used by the IOMMU driver
to program the AMD IOMMU IRTE to provide reference back to SVM in case
the IOMMU cannot inject interrupt to the non-running vCPU. In such case,
the IOMMU hardware notify the IOMMU driver by creating GALog entry with
the corresponded GATag. The IOMMU driver processes the GALog entry and
notifies SVM to schedule in the target vCPU.

Currently, SVM uses 8-bit vCPU ID and 24-bit VM ID to encode 32-bit GATag.
Since x2AVIC supports upto 512 vCPUs, it requires to use at least 9-bit
vCPU ID.

Therefore, modify the GATag enconding to use the number of bits required
to support the maximum vCPUs.

Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h | 3 ++-
 arch/x86/kvm/svm/avic.c    | 9 ++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 0361626841bc..6738faf155e4 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -256,7 +256,8 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
 };
 
-#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
+#define AVIC_PHYSICAL_MAX_INDEX_BITS	9
+#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(AVIC_PHYSICAL_MAX_INDEX_BITS, 0)
 
 /*
  * For AVIC, the max index allowed for physical APIC ID
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index dd0e41d454a7..b1f8f51bbbd9 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -28,16 +28,15 @@
 #include "svm.h"
 
 /* AVIC GATAG is encoded using VM and VCPU IDs */
-#define AVIC_VCPU_ID_BITS		8
-#define AVIC_VCPU_ID_MASK		((1 << AVIC_VCPU_ID_BITS) - 1)
+#define AVIC_VCPU_ID_MASK		((1 << AVIC_PHYSICAL_MAX_INDEX_BITS) - 1)
 
-#define AVIC_VM_ID_BITS			24
+#define AVIC_VM_ID_BITS			(32 - AVIC_PHYSICAL_MAX_INDEX_BITS)
 #define AVIC_VM_ID_NR			(1 << AVIC_VM_ID_BITS)
 #define AVIC_VM_ID_MASK			((1 << AVIC_VM_ID_BITS) - 1)
 
-#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_VCPU_ID_BITS) | \
+#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_PHYSICAL_MAX_INDEX_BITS) | \
 						(y & AVIC_VCPU_ID_MASK))
-#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
+#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_PHYSICAL_MAX_INDEX_BITS) & AVIC_VM_ID_MASK)
 #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
 
 static bool force_avic;
-- 
2.34.1

