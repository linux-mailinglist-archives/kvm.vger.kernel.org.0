Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565AA77FDAA
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 20:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354264AbjHQSTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 14:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353986AbjHQSTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 14:19:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D202D73;
        Thu, 17 Aug 2023 11:19:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgfCK0+HsUIwKW7TrODEZZpjIvlSrOoOl2zQ17UK5MPaA73D21aaKIyG6QKrZ76Mcvs/MJpjEA/CGFW0HK/SIMmIrSm0tYosFXgdqstac0m+zVooGFzfSH8d3nVnmB9WuMMooADaUrUnlV4m+Bj/4Y7+p8BF3/2endZqz7cN0In79tvYHnxtKrhTNGzoSThTmtTOcGjA+DgdVKRbI/huIPV1ZgKOB3Aqy25wGl7i3yRcG7ymVVLUOYQ/qqr/X/u1uAu6SRtdFyGk7ge6WmZV5K3vDuCc1vTLofHmbKI9hcKjNJ0rlHLeam8fqjfo9sAAXhDPemUjuZytFbCuBXckHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g15sc15CoRCkRsRPHaaIt3oO09gAZ3I7EIGksz3qt9E=;
 b=igdjjHWv4aOq4hff4o3T6BkuSZo/z2LalJhLS2StUaIw70hUJgD4Qvxtf6RvuLV5un1K9xiTSpROklhtrM0A/axDjLCDK+WoKJksnY5cKcxNmF/GZMmlmscg5LC0FJvFqeu1Y0DVG7IKALY3CgoWKv1wBTuTKGl2isDIzyFlYvY6eO/KoRF64i4Aye2FfZZPuySb9D4mCxCItMVsrOf8tLiMGqp0xK6FdJ92gBxRpz+HUOV31nyfI2acfM2KqFyimJ+e4Hl0XaGY8QJUTCv4+gRqhd01pflucGqDOVdlAPlt7pOU82kz+n+iYfG8JXwERzzZWMladOacz/m9QYucMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g15sc15CoRCkRsRPHaaIt3oO09gAZ3I7EIGksz3qt9E=;
 b=Zl5+cQ6u2R4//3BscLZeAmlhlbAjZBTPu98ChW4LfXX3JEYQqtSkuZKemRGyZSjgaLokFlISh5KwpQzqm5arI4PJ6beWh7Q6W28A1sjrlqYwbJWiQZlT1cwOCRwozmZ9sNv5qBgmaGEjbGxO8azua+fOdYACdKVQMs8PeR+yCVM=
Received: from SA1P222CA0028.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::30)
 by DM6PR12MB4282.namprd12.prod.outlook.com (2603:10b6:5:223::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 18:19:15 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:806:22c:cafe::ff) by SA1P222CA0028.outlook.office365.com
 (2603:10b6:806:22c::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.33 via Frontend
 Transport; Thu, 17 Aug 2023 18:19:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6699.14 via Frontend Transport; Thu, 17 Aug 2023 18:19:15 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 17 Aug
 2023 13:18:55 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v3 3/8] KVM: x86: SVM: Pass through shadow stack MSRs
Date:   Thu, 17 Aug 2023 18:18:15 +0000
Message-ID: <20230817181820.15315-4-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230817181820.15315-1-john.allen@amd.com>
References: <20230817181820.15315-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|DM6PR12MB4282:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cfbe9fd-061a-450c-30f0-08db9f4e7700
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Z8kpsRiXLcd/9ulLdOg95wj0Rkqq7lBFGknHbygG3/QTOZJRxjm/9l3mJ6tq4UmV/2qajiLxXJyof+eTxdvphWaXUFo9hb+qmWDiV8V0IYT227nykQzEOStkavrCB+Y4RsMN4tdXGcnmvxfkp7UkA9IUKd+sLiiaL115XUO34R5OtJhIwK/79SeYNnPdCKTYFrJq+Ein9mNNiSWYNZ6bHT3Rm0xw4AtYpHSem23mtljVq2zFohuSEfCAxKRzWqIq+HKLrE9tY2/AUjIFRVU0KOCEcD1yWWPFsPV1SgwFxOPhA8r9+apIm9iVRR94hwmGloamfl2YCkIAxJ7fNA80VAF3XCrBhQ5F/Qt1yYJdWh3CgtH9MVgkAdzA2xXvHZ/fmHumnmDnC+ORovt32j+WRUQRWbl3x1Faa9kciqUzAYXkIKlOSVUdvbIEOHpJ6yeEINj++AtmMDIwEFQ9gtGaU05zxUAA4Ba+PyRFZhz2j1AyrxuMKD2RXVEQUnc1elzNHe4/E/kic0Kz1ZPW02xxbpvPf+nperAME/SWaAt35WX+Cso5Yg6Wo1LAKkA62QsmNGqZQLIIw9R2VOHp1wh5RI156lye2gH5DfMD5rPQXUQEPOkyUFLjDE78pjzodzLQGLhP+m1nlP7tK56N7SGL3oLg1NgkDzb+8ftidDimuqKji8HYyeLJtUdg2nFuSO2nss6XVOyZ5klIzivZx4eWO63pA89j0RONXXuPyD0oInFSE+nCIiWZly1CXvhB01Su0w8Q7k+Mfaq3Lq1DXQHfw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(396003)(376002)(346002)(82310400011)(1800799009)(451199024)(186009)(46966006)(40470700004)(36840700001)(40480700001)(83380400001)(40460700003)(54906003)(316002)(6916009)(70206006)(70586007)(478600001)(356005)(82740400003)(81166007)(2906002)(41300700001)(5660300002)(8676002)(4326008)(8936002)(36860700001)(47076005)(426003)(7696005)(6666004)(1076003)(26005)(336012)(16526019)(2616005)(44832011)(86362001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 18:19:15.5198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cfbe9fd-061a-450c-30f0-08db9f4e7700
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4282
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If kvm supports shadow stack, pass through shadow stack MSRs to improve
guest performance.

Signed-off-by: John Allen <john.allen@amd.com>
---
v3:
  - Conditionally pass through MSRs depending on both host and guest
    shadow stack support.
---
 arch/x86/kvm/svm/svm.c | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1ac5b51c3f2c..dd67f435cd33 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -140,6 +140,13 @@ static const struct svm_direct_access_msrs {
 	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
+	{ .index = MSR_IA32_U_CET,                      .always = false },
+	{ .index = MSR_IA32_S_CET,                      .always = false },
+	{ .index = MSR_IA32_INT_SSP_TAB,                .always = false },
+	{ .index = MSR_IA32_PL0_SSP,                    .always = false },
+	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
+	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
+	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
@@ -1205,6 +1212,25 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
 	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		bool shstk_enabled = guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_U_CET,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_S_CET,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_INT_SSP_TAB,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL0_SSP,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL1_SSP,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL2_SSP,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL3_SSP,
+				     shstk_enabled, shstk_enabled);
+	}
 }
 
 static void init_vmcb(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 800ca1776b59..f824dde86e96 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -29,7 +29,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	46
+#define MAX_DIRECT_ACCESS_MSRS	53
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.39.1

