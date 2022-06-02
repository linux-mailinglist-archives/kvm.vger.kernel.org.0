Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8604553BAAD
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 16:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbiFBO1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 10:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235869AbiFBO1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 10:27:15 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0806DC20F;
        Thu,  2 Jun 2022 07:27:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzcFg6koYpWaw4tIwwzDMpADDt+6hd6prDxdLpU8Os0zG715hbginzhUOUCfjRKtyb27GedxjVTLFtfoX6cMQVnTnbDvvUj+VDBO0wR5L4ZntZdCygwa3GlrQMIwTDJHNhcRLqdBPB8zryUegCi4q3ctYIVcKR8KHkxBFZq5uEWYIeYDgh9M4Wm4PFY9XVrYCRnLwWUCZfj5fx0UYNNT+PCdSBh5pJ0+57gqrSDfd5ZsUPXfZsww9JNgWP/Hknm/h4fbLtLPL1Z18Lxfl+/7ZXX9klvgUkCsr0m95x3BoE2xF/mK71vZ5cWw5h7vhCD+arPFiPZ+h4cbLObgNs0wSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEzWo35Wjsm5XLf86tMH/3ciVr4DeVDeyt/AhwY6QQ4=;
 b=DyAe8N2XRb9DNY2PE8XAu1C83BNvilKNZHdRf3Wy1jyvPh0klbNz4sqi31F1+ET+0IdbmtiFNQFU6JSbclwDgn5ZTDwz9/ySmqPqwCOqZ/XdfZ9Oi734rTA4/ZKJ+pXD6KQanIVkxf/MRtdCBwmN9DnYScBO8PNxBa7RuhVT1pL9Ftlg/ZXZ1h+YqoSF5YlkaXvKAglKCpOlFQoJbekjpgDizH895Tya5F5VPO6qz/04PqWnL3moWTWgIxuaQwtp8bQ2y5J6opnczckcG9AO7o8g9YktXJ2dTGXbv2c+HZJgrqt+D5lXuSTu+0oltGDqB2K8Wz8AuPy9JHJqbfLnDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bEzWo35Wjsm5XLf86tMH/3ciVr4DeVDeyt/AhwY6QQ4=;
 b=Z6OZAT+HP4i8vF7SYqCcO0nt4gE7sASCQavuwySkCTWzFodjBPlALCyJTI2IACyGFwy+HDILgTd6kOPjuWVsSMZ1Gufn/e4wmM1EjjwCcIcaVsETSgxxDwj9xnDmWYd7um2dONqjLKmaGuNn9DKrsmHcVpF3TqG5Zlj5OtPcuao=
Received: from BN8PR15CA0050.namprd15.prod.outlook.com (2603:10b6:408:80::27)
 by LV2PR12MB5895.namprd12.prod.outlook.com (2603:10b6:408:173::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Thu, 2 Jun
 2022 14:27:10 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::6c) by BN8PR15CA0050.outlook.office365.com
 (2603:10b6:408:80::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13 via Frontend
 Transport; Thu, 2 Jun 2022 14:27:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 14:27:10 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 2 Jun
 2022 09:27:07 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCH 2/7] KVM: SVM: Add VNMI bit definition
Date:   Thu, 2 Jun 2022 19:56:15 +0530
Message-ID: <20220602142620.3196-3-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220602142620.3196-1-santosh.shukla@amd.com>
References: <20220602142620.3196-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db31a468-3007-4ba3-f8e0-08da44a3faf9
X-MS-TrafficTypeDiagnostic: LV2PR12MB5895:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB5895052AE9966A660544309C87DE9@LV2PR12MB5895.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SrXi+oNDcwlkPJiUZgQQkqa+drXCm/o1U500GU2Iw0mG8mUcOPUZZYfgOE6yNimwOnifeIRsyPVrVE1vuONBL9+I2onq2BgI+nx02HkRyAe9QSA0F6cPrQaJ/+j+nUSi+yyz4RMdf4VyXSPYk569fr+9x/dr/mRGQJnlzJF58B7Hw8ZR20OdZJFEvbO8fb2VKAHHB7LI9oJRTlMLoD5U/RJDMjs5raJtmfWp9UWlX1UTUgAhy7Hl0/wx+C0N7zbCgpEPMQXif/0jyNZTaFqpng6dWxIAW1tHCfWTRLHxj/0YT9OAelQoXfHS4HUfYPSYlYKDBFNPlx/NMjs7+faawxKXidn7X0hTjok1g6C3HexmUGs/2hYWiAVubAiw0H+6vE6VAqejXCrtl514jIWsMuzWmL7ZxWr3V05M6xgfH+VxJPnOM40pbtREABNmjQVxAR5pJK7jfYMPp21MErkUtT+tbHUQLQH17NZEEsXAgveipKPCPN1U6kKRWo9F9bEUN9q5Gsldozx01wWScMrna93Sh2+wkrTQ3+EpfCZ1voJ9HaKU27OqOjA2H1yD2dvZ+MpYDXvtn0ifbdnQOPEqP2Psc/huqYrD6WPLgTC/gJ3/2gqyCbCpm95i6dV+U2zVeh/KHKWj3TBSKUPFcBtLKvp1++knqqI5fNUnjkXXQB/2G7z4dBYW1ZDtoI0ifofXamWyrQiYe6BrLwqClAjShA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(70586007)(44832011)(36860700001)(70206006)(5660300002)(26005)(82310400005)(336012)(426003)(1076003)(47076005)(2616005)(16526019)(186003)(86362001)(316002)(508600001)(8936002)(8676002)(4326008)(6916009)(54906003)(81166007)(40460700003)(36756003)(7696005)(356005)(6666004)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 14:27:10.6765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db31a468-3007-4ba3-f8e0-08da44a3faf9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5895
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VNMI exposes 3 capability bits (V_NMI, V_NMI_MASK, and V_NMI_ENABLE) to
virtualize NMI and NMI_MASK, Those capability bits are part of
VMCB::intr_ctrl -
V_NMI(11) - Indicates whether a virtual NMI is pending in the guest.
V_NMI_MASK(12) - Indicates whether virtual NMI is masked in the guest.
V_NMI_ENABLE(26) - Enables the NMI virtualization feature for the guest.

When Hypervisor wants to inject NMI, it will set V_NMI bit, Processor
will clear the V_NMI bit and Set the V_NMI_MASK which means the Guest is
handling NMI, After the guest handled the NMI, The processor will clear
the V_NMI_MASK on the successful completion of IRET instruction Or if
VMEXIT occurs while delivering the virtual NMI.

To enable the VNMI capability, Hypervisor need to program
V_NMI_ENABLE bit 1.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/include/asm/svm.h | 7 +++++++
 arch/x86/kvm/svm/svm.c     | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1b07fba11704..22d918555df0 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -195,6 +195,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_ENABLE_SHIFT 31
 #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
 
+#define V_NMI_PENDING_SHIFT 11
+#define V_NMI_PENDING (1 << V_NMI_PENDING_SHIFT)
+#define V_NMI_MASK_SHIFT 12
+#define V_NMI_MASK (1 << V_NMI_MASK_SHIFT)
+#define V_NMI_ENABLE_SHIFT 26
+#define V_NMI_ENABLE (1 << V_NMI_ENABLE_SHIFT)
+
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 200045f71df0..860f28c668bd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -198,6 +198,8 @@ module_param(dump_invalid_vmcb, bool, 0644);
 bool intercept_smi = true;
 module_param(intercept_smi, bool, 0444);
 
+static bool vnmi;
+module_param(vnmi, bool, 0444);
 
 static bool svm_gp_erratum_intercept = true;
 
@@ -4930,6 +4932,10 @@ static __init int svm_hardware_setup(void)
 		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
 	}
 
+	vnmi = vnmi && boot_cpu_has(X86_FEATURE_V_NMI);
+	if (vnmi)
+		pr_info("V_NMI enabled\n");
+
 	if (vls) {
 		if (!npt_enabled ||
 		    !boot_cpu_has(X86_FEATURE_V_VMSAVE_VMLOAD) ||
-- 
2.25.1

