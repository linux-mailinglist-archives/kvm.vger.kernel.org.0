Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1F160F2A5
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 10:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbiJ0IkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 04:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbiJ0IkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 04:40:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B159B84E5F;
        Thu, 27 Oct 2022 01:39:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HucugRErDmGbFrhp6mi4t5FIiWEddmjMsaZdBONF5Rr+tBqXsZx7g2d5oA+a7BX+0OP1OsBW4eSECAOFjazjDbZtN0RvHffl4pp7ia3ck/6QWfj4+ehuUIMhLeW+VDu/x2XetV3cZiTepJDKwtNjqMHaCzygT/oJQdhnk+QE9JJjQGkqCU1yjMJHREtbKf9Pbh9MMgj5o5PN0JBxQHQyqBPsCThVZ0OOvWvvKQl3qHvBOoBM/72Fh0NbwHLkBJ4Hh84/sR+ATqa8gqqA82v5ntwiPn/PsasXFP1BfacUpU95/jcvysp/m6LEjvMErYMniEjsQ3Llpn4OEKMu4vfNiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MnC38vomXNvO6akJJnf1NmMBHxuNASuvEk9xAE0ePJY=;
 b=NTqjgbeKq4fBILoOYnVigtH0HYZpbfzQFvvsjLS/QuEODm7ahmLZ1xKn/9MIX7bgVAma/q0yQOYddt1bx59e+OFLd3fmGDeeT2M1RxojGFwJ2hfAxC935ffK4AH9hjqwjzLJEai7d4fDaVMPV9+6+P5nEYI3B5yTxksqdDrwpKL2Fn+wtWKRgQLrH5qDe+cB0FF6a36x6ll5Vf8HixDvc/cfuxP/bODYiVJZlkn6175Cpzf+wc5A57et0onvlfmY70XovW8Ev1BEV3ADyY9IXEl/uhnOp1Syj7w/Dl9LBUNl9oE+yNboh3HacIaWDJqDOy/W1hRll3ygHS3h1/U+/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnC38vomXNvO6akJJnf1NmMBHxuNASuvEk9xAE0ePJY=;
 b=VED+YRlj1kh31kiI3gjJlcBEVepmftPZnznDfnCLm5nOX8WmzshCXRexHjBfBqQqTwArqsPbEB8aVdhbqzc498kXJQi123f+M1nCtAGXUGqoH8AK44c4y3mYBBCZDVERNbUOvkwVdmAzqO5sKq10ibdeHlVkbhTYtN57cFvLa9Q=
Received: from BN9PR03CA0329.namprd03.prod.outlook.com (2603:10b6:408:112::34)
 by DS0PR12MB6390.namprd12.prod.outlook.com (2603:10b6:8:ce::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Thu, 27 Oct 2022 08:39:56 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::28) by BN9PR03CA0329.outlook.office365.com
 (2603:10b6:408:112::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.29 via Frontend
 Transport; Thu, 27 Oct 2022 08:39:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 27 Oct 2022 08:39:56 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 03:39:50 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv5 2/8] KVM: SVM: Add VNMI bit definition
Date:   Thu, 27 Oct 2022 14:08:25 +0530
Message-ID: <20221027083831.2985-3-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221027083831.2985-1-santosh.shukla@amd.com>
References: <20221027083831.2985-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT037:EE_|DS0PR12MB6390:EE_
X-MS-Office365-Filtering-Correlation-Id: 51d43434-708a-4b8e-70ce-08dab7f6d37a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Kybb9WKflyFffHy/crcMdHak5mSAtW6qjmizWjp7l48cZ6k0Jd3Kk4sXPgrSuibRwAxnQdbuTC+5708RxtaEJsScC7mEgsEuGifjOW2euYyH3oYbvuFx4NHCfH3cQuC8ENM94C2bC9fOP+d4MImPGf4bsSl7xJAwcaP1SG50YtjqX86ZJWW4RNz5EZp8yUSUBdxvuP0ZYtbrGxxad+fjPLeOM0S64nfypmroNQ/3Kr5JP2lWRvcofIkPquKa1Gh4PBfkGjB1vk5Oyq+txJDz952zo2/c9QyYdzoSQeXJKq5MCn8aHA5xnfsTX5DO4wKDCC5d6mb8AMYyzOX9uJfkDzh3VZOMo25xsG2F+wMCQfP3qzHWyQPyeyDeaaKc2Z6TxUAI4MoKD+dcd9HGvLFgbSQmgWq8p7zYQEzBy8UXe7YWwMl7RqIqdF5/xilRSDHApojRGpZ3dMOAekEJ32TO4zp2wCvPQeQRhSXQ93Xl2LYlq9hPO+wiwJ3tbGlCatFWnOh4GFY1DlpuvD5Dbn3gBd7C5VjFJsK+x8Fdr2DpsV15KDMan3XlFjlyUh0ehaCp5uhNnHSPm4MMKX5dFM0Ldewt0+musylXj6fUIPT3KoPBVsO678I3Bs3cASSssQ74jLminTh1DmmA99rYWDFtjzG0GqSkA0MbOksE1myDGVjqu/JzvG01FIh456LLW86uXwXW0tduR15QXlMCrG6L0GvnsgKJIKDzyxwnuteDcaC+yynDyISfCqg7S/dFvG/mNFSPn2SyL4uIxq4H+TCakpaJhwkPJRIaa8hIpOnPrvh2uWwFgHfHJdPXoclqq37
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199015)(40470700004)(46966006)(36840700001)(6666004)(82740400003)(2616005)(26005)(186003)(1076003)(16526019)(36860700001)(316002)(4326008)(40480700001)(110136005)(5660300002)(36756003)(44832011)(86362001)(70586007)(54906003)(41300700001)(8676002)(8936002)(70206006)(82310400005)(356005)(81166007)(40460700003)(47076005)(426003)(7696005)(478600001)(336012)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 08:39:56.3732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51d43434-708a-4b8e-70ce-08dab7f6d37a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6390
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v5:
 - Renamed s/X86_FEATURE_V_NMI/X86_FEATURE_AMD_VNMI

 arch/x86/include/asm/svm.h | 7 +++++++
 arch/x86/kvm/svm/svm.c     | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 0361626841bc..73bf97e04fe3 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -198,6 +198,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define X2APIC_MODE_SHIFT 30
 #define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
 
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
index 58f0077d9357..b759f650fe2d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -229,6 +229,8 @@ module_param(dump_invalid_vmcb, bool, 0644);
 bool intercept_smi = true;
 module_param(intercept_smi, bool, 0444);
 
+bool vnmi = true;
+module_param(vnmi, bool, 0444);
 
 static bool svm_gp_erratum_intercept = true;
 
@@ -5054,6 +5056,10 @@ static __init int svm_hardware_setup(void)
 		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
 	}
 
+	vnmi = vnmi && boot_cpu_has(X86_FEATURE_AMD_VNMI);
+	if (vnmi)
+		pr_info("Virtual NMI enabled\n");
+
 	if (vls) {
 		if (!npt_enabled ||
 		    !boot_cpu_has(X86_FEATURE_V_VMSAVE_VMLOAD) ||
-- 
2.25.1

