Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527675A46D4
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 12:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiH2KKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 06:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiH2KKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 06:10:10 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2068.outbound.protection.outlook.com [40.107.212.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B7663D0;
        Mon, 29 Aug 2022 03:10:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyUHgqfFSVeX1J8VC/P6BFFXB13YVHTvdXUwA7q8Hv72Gdf5gP2cCtZJD7U0/yK2oaC0Rkx9pGyNs6O23IsJS5UO030+PDr9Ct3PFZQPUpEuiEt4kdHqgvxDn6OeCHDhXg17dgR9rXUZvrIgF63NLQnHiS6zEsTkeg1lKaSWivYj+YGvM+57ADZxzkdBnDvoIXwqY0Gtbi5wa2Z24gnEuiCyXQqoP6KPG3LhFLTdDALm11Sb7HcPY33Fq8LWJpqgHT5hl1ph9NX3zvBOdBPXiCEdVxOguy10EEg/XVrxUOH/VeHQww/yjRFgBnPqiucluGCYd7ZFvZWT7yY9wF0y8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GAu3xcWGgzkvSilv3WWelZnCfuOZEVIzuB/OeMv+Zv8=;
 b=i0EmETw8MFCScwZyRFQqEiF6GiTo2J+wqZwiH5vGcbRruzxzLiVfqiUcOKqvOY9ZdZiYtPKEePlRt8J9F15ofZXZDdGzg8m4fPpue+kLDMTqrReI5kkycyWRga3+dU/DKrtnd+InsH9nx5nkHTQVmawSSLHv6CJ5CMOnl3MCHmbu7QFFXuzIiW9ph8vDthfWEJxOkhfwZDo6dacyMYoVPWNHfJGI9gtp17NdN+Ay+5LAvkBSfM6vU/21jzTKA8r64z5YMEVJmvKDq2ddVJkSyL4C6YmcQXUadU5TgJ8PGBARuYT3/T5VUy7tRv9Ah5U6A/NnA9W74XP/CFeVP/BM5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GAu3xcWGgzkvSilv3WWelZnCfuOZEVIzuB/OeMv+Zv8=;
 b=tVqeiPCvaIysbzjk/gEqv/aGfVh5TVlTz6K1vx/49l910/ZF0QsHqwfSaOvWjKRfKoja4lw5FYUWAMChHCpl0sZnVI2P6M3yq143e7rwpICYIXbs37b65PCoqdMe6nZb7kO52705+d2IMBMcjoK12jQWjsZq8RHMo/RlXOJp0qU=
Received: from BYAPR04CA0023.namprd04.prod.outlook.com (2603:10b6:a03:40::36)
 by SN7PR12MB6689.namprd12.prod.outlook.com (2603:10b6:806:273::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Mon, 29 Aug
 2022 10:09:58 +0000
Received: from CO1PEPF00001A64.namprd05.prod.outlook.com
 (2603:10b6:a03:40:cafe::7f) by BYAPR04CA0023.outlook.office365.com
 (2603:10b6:a03:40::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Mon, 29 Aug 2022 10:09:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A64.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5588.7 via Frontend Transport; Mon, 29 Aug 2022 10:09:57 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 29 Aug
 2022 05:09:50 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>, <mail@maciej.szmigiero.name>
Subject: [PATCHv4 2/8] KVM: SVM: Add VNMI bit definition
Date:   Mon, 29 Aug 2022 15:38:44 +0530
Message-ID: <20220829100850.1474-3-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220829100850.1474-1-santosh.shukla@amd.com>
References: <20220829100850.1474-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4bc9b0f-a117-4e11-0981-08da89a6a0b0
X-MS-TrafficTypeDiagnostic: SN7PR12MB6689:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xW496eBmalKV83pC+gpzOLMujkbN63Gk3Y8jLGxKMFJWmJWUIQWKFiPxJxoK7oS0Ju4/1/4gReIrSjmHS/fkjlhhattfLPM3AEiLWKlHl9VaVUHpKbi2KQ9eN8p35BUAPzJSei05EdAjUosBl4QTRjy8t1GPJhdUrLnfHkZwlcP9qAh8U6iPwY1UqOcma3iiJ4q51MrXNRrCUt64UrzlK8MknOihh1UwDv8X6FZhvz+EIED199gXxoMcQ8uJljRo9VGXJXCOmsDYyIqR6IDxJa57ikEGixV6nnYFo5ZlE3mzVeIAMbxx66ZEjZXudj5e4nrC1tRLhh2a7JsHP8x5LcDhpryBM64sLoHdVXQfOu7GcvDhsmphnoVLl+nDVgHM8hZgJncUxSlnMZXJqMDDYBIGmVCRO3SCA0nDA/oq34ERZXIIcBH9rzXhpTORIoL5lIBIViZmcZFS0tYnNQ4qeRm2emlgQYpBqnDjbEKyVwyqqwVPzijpautCO1XUWsxEWhvppYmtMqNTazKzF1XYDul0tZz6mTqkPyOF4gH1r5ir6cKISPMxfKjD7R7FPHINs4zumfNHCYsuHQQU73KY8KzS4NmU4sZsOGw7E+2l2rM5j8HXUhlsQ8s4EgkDHEBnuBNTRoM91reyv4HBbbVE+sc+XS27Q4OZL22vxT8SiG8wSsL6+ZPN2vSjzMCP9oSRoHekTAwnX4NvYTXoqjJ8xbpkuytnv1oFrnJkjgLePWgc6D/fWzFq/bh5tGV9KPdeszSo4ToqrpWspkH4BLuiOC+CIOIrIFyHrQkRfWaT4EWk/EZGv8M4YrwqEw6CGYaF
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(396003)(376002)(46966006)(36840700001)(40470700004)(336012)(16526019)(1076003)(47076005)(186003)(426003)(2616005)(26005)(41300700001)(6666004)(7696005)(36860700001)(44832011)(8936002)(8676002)(4326008)(40480700001)(5660300002)(82310400005)(40460700003)(2906002)(478600001)(70586007)(54906003)(70206006)(6916009)(82740400003)(316002)(356005)(81166007)(36756003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 10:09:57.7939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4bc9b0f-a117-4e11-0981-08da89a6a0b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A64.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6689
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
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
index f3813dbacb9f..38db96121c32 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -229,6 +229,8 @@ module_param(dump_invalid_vmcb, bool, 0644);
 bool intercept_smi = true;
 module_param(intercept_smi, bool, 0444);
 
+bool vnmi = true;
+module_param(vnmi, bool, 0444);
 
 static bool svm_gp_erratum_intercept = true;
 
@@ -5063,6 +5065,10 @@ static __init int svm_hardware_setup(void)
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

