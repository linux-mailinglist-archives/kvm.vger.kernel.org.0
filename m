Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F1C5FCC2C
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiJLUkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiJLUkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:40:02 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E67846DB2;
        Wed, 12 Oct 2022 13:39:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdBJVNznU61oGf+nrCelG5gsTkxTi+Wkt2powbSL3XSZA2DGEVaXJj14DPjr2DPeO4AHaFW4xv+kme8gMyyNBoVS7WG2OVdoLdjhPDTmhbjsHh+KtBJI0/z7iUHPJ63t2iN1FabwKPJGw6mu0if+y/4aMyL9uPBrUHQ7hW0fvFtOv+e1Lx7ni5f+bxPtagB9OHXXpa2SOCMmpcLqweMLQwkNWVDNZd+FBwCS+gTrEGltnot5tsXZKChFZrgYFJJh/MyKgUjJ6r5DZOb54Ed/O2w0z/EmQsbSvg6+ljmxifLnP5nj0LeVxvJN4NIq8RivCdGopSF1XYVGiPyg89BLJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tCaTMiFcosaToXMxM2YR9+g98xZMYjVyHXgWOVbvcI8=;
 b=IEGWGWxDmskScmmRYEeAjDYf/rzNax9Pr8w/QZcl1JMIVuNO+GWU9DxskuMJfsTnpgwxXlmtCC7VxkSxGF1j9sFvX8oJMNmJuYEF3pv+e+hx2FwkPFlF9me0s6Soj9H/8IhYjwTCRLBetzYepEwjRIIXNpYL8ado3Zgc9HFOUp6Vr5xo7tNTbNUnzZYd8S0i5uxoZ6UrNTIDGRiIKrijGypXJd9rYwUyQ9AwzeC42YeUFa6bXFysI19jvV1GgRX+LDpnuZi0JcMbyHJiwvDF0Z4SJBHpzTe+Rnajt2hpE9dlJuidldWAPtGBrjkYa1KiXTHmXzaC/nzIRMWp354Xrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCaTMiFcosaToXMxM2YR9+g98xZMYjVyHXgWOVbvcI8=;
 b=Tn2EiViBwOKnMjzy3MUTxwVDuey77/jpwOXInZI2FR/pPqDxuw4lh3L1yKel1D4Yn7aN//PVNqkpZGUf8QgFKgB1Ylo3MY85EPNcb2mSGC/hcxYHBHpaPLt0t/KNwfCoNyLeXMDSXGHh2VZHGSoZx3Mrbe5ueIgTsqGD5AWRinM=
Received: from DM6PR13CA0067.namprd13.prod.outlook.com (2603:10b6:5:134::44)
 by DM4PR12MB5102.namprd12.prod.outlook.com (2603:10b6:5:391::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Wed, 12 Oct
 2022 20:39:52 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::c7) by DM6PR13CA0067.outlook.office365.com
 (2603:10b6:5:134::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.20 via Frontend
 Transport; Wed, 12 Oct 2022 20:39:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Wed, 12 Oct 2022 20:39:52 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 12 Oct
 2022 15:39:51 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Subject: [RFC PATCH 4/7] KVM: x86: SVM: Pass through shadow stack MSRs
Date:   Wed, 12 Oct 2022 20:39:07 +0000
Message-ID: <20221012203910.204793-5-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221012203910.204793-1-john.allen@amd.com>
References: <20221012203910.204793-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT060:EE_|DM4PR12MB5102:EE_
X-MS-Office365-Filtering-Correlation-Id: d3a9528b-032f-44a6-e046-08daac91e9ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QmK/pzW+y2zLR4uvQbrFPMv5xGXsJjRhqUhbyNhE16orYLofewqcTiIh5Dp4cojV+Ue91fs1fIZQiNt0j4Yb1amUjGTEYytBf8HmsGxT3ND98q4oFBQKotGYSAGerANKCFmGlUzl/+zS+H9jkiw8dghQH5dTKW+DmjVfyKGDixPB9PjHmADjt6sQwYP7AlTCZCN7BS/6wGRLDrLBxOr+KbFGZ55qJzQIhi9rEcsy6YKXkDumkpd6Jsc8umrpRRr4+19LzoPDgmun/LETjJGzno5u10EU5RlVfcyJGbeDSmzI8dvi9g8lPpn3bjHYfcpC3tEvTtJ1qeyqynZIxiU9U5bc/0YtS84rOnzBrTwzIP+m4hyHaa5ZQdiou4YH74MlrYLE7CEDQ+A6JHaDU+K8H5cEEa37K8Va8qQz7iaEtySYC4CT4d3Cdcx1nwEXrwTP/1xqKk9gfKC5fWGa/cqgE0FwcF/YfevFtsX24pu4W8S2n/rxGil+7Z/JYJkyoaKPUSaFfXJYFRQvTHJ9hWKEYQiPmieOzmDc/y35Hn/cHFOPuqsxZgQrqaF9El0zMrOW4YRUiPYo7PynPeLpa2YLRVFNGBHBUstopiTXvTA0v9TcZywQ56rSzIamb6LhniOMulylCzdRtH/2hRTFj68i/0lvoJtGYrl0no2fAR28/g9e4HJUOrIg4wD9fVEWNGR5L03CSLesSETtkbO5vWw34pujJ7RVdhw8LpvcTJHcED97TO61mMXlj66dNsIti5jNPljylvFoDvG4xjUWFjR9+iQjibhColKr9fW/4b99Ouu2kTs/V/j+vQdliPMX+hje
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199015)(46966006)(40470700004)(36840700001)(83380400001)(36756003)(86362001)(41300700001)(5660300002)(36860700001)(82740400003)(426003)(47076005)(2616005)(336012)(186003)(1076003)(16526019)(81166007)(356005)(8676002)(6666004)(7696005)(26005)(70206006)(70586007)(316002)(54906003)(6916009)(478600001)(8936002)(82310400005)(44832011)(2906002)(4326008)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 20:39:52.0481
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a9528b-032f-44a6-e046-08daac91e9ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5102
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If kvm supports shadow stack, pass through shadow stack MSRs to improve
guest performance.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 411c815d2d91..f40d3df2c1be 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -134,6 +134,13 @@ static const struct svm_direct_access_msrs {
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
 
@@ -1174,6 +1181,16 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
 	}
+
+	if (kvm_cet_user_supported() && guest_cpuid_has(vcpu, X86_FEATURE_SHSTK)) {
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_U_CET, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_S_CET, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_INT_SSP_TAB, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL0_SSP, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL1_SSP, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL2_SSP, 1, 1);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL3_SSP, 1, 1);
+	}
 }
 
 static void init_vmcb(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a7686bf6900..c1c3e090ff9d 100644
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
2.34.3

