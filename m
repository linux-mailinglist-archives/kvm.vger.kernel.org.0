Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF635FCC28
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJLUj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiJLUjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:39:55 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B051DA77;
        Wed, 12 Oct 2022 13:39:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OX8dqll8CHfCj2xDPWYiAAefftNktV53JkXD0ZKxb+92uWmFw1JKo6MAyh9fjS0VyErJ1xNk2LXN1lb3yOB+Dfcf7Fyd3dV+BXLwazaDaP7QRiVY4cKGlBDEUPfEYFQTtu8JBYc9VduvZU+V1bWUe9Rl1efsAgTlQzZbBCfC4+ep9E0vo6inrU414aES7iBxjlOosNAxU4hUln17o6jG/bzdDMHzLpcnYY9pMQO9V31J7IowBLlWVl9LreQhvidlnON5eKqB692D0JN+ccGb0KpeHgVFmiRxx1c1r43JdFpD1EmCYNM4yppu4Ueffp78k9U1x5/YTONT99wkaP0IgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dt+dj9LbZqFlvZOOZzYyuwKJKe/4XVZf+scBZUKDHbk=;
 b=gkexMMoiujsvhQCBgSdcQlgZwG32OG7PE8nYc9jSfW+LHFEt2+KIRdfPKOeNA+UgID8HlaEG8stY3aTYDr2TqkfMTaXMBPo0uAaPQpiilO8wn+XnFHw+4KhPxaViiu96Fr2wEDxt7X8g33wwa1AHRx9qEc63O8yXewuafvfFBIWm5sCIyBQ8DNLmDZpqSAzJeOxfVJqaqbEWsuRDk+yrhX2+cM+p8l0Boti03p7+odXPs+UJdtP67OvkbZVds8Ytzh8xl3zPCTsx5DCsKHFOejkioFrhC1jJem/NlmeqaLjmvc2S/1d6goSSdTTLSuKOfZ7zhBWo6vFcyLv17oMAEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dt+dj9LbZqFlvZOOZzYyuwKJKe/4XVZf+scBZUKDHbk=;
 b=ejDIMZ0Oqua6tN3+p/bd67iiycGjCrkzlk1LeukxQ3ymECsJZ6bWtNAhwwLZ0AKdl/tWL/aICwztEeDRAgr2LsXHjok7bC2u9B18jvATmjdzEZ/XEaAP0Lzr5hFArr/cA5NMYjKeJRWthWQZDhi5is3teeZX543u4GK7Fr4Hp0c=
Received: from DM6PR06CA0071.namprd06.prod.outlook.com (2603:10b6:5:54::48) by
 BY5PR12MB4967.namprd12.prod.outlook.com (2603:10b6:a03:1de::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.21; Wed, 12 Oct 2022 20:39:46 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::e8) by DM6PR06CA0071.outlook.office365.com
 (2603:10b6:5:54::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21 via Frontend
 Transport; Wed, 12 Oct 2022 20:39:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Wed, 12 Oct 2022 20:39:46 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 12 Oct
 2022 15:39:45 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Subject: [RFC PATCH 2/7] KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
Date:   Wed, 12 Oct 2022 20:39:05 +0000
Message-ID: <20221012203910.204793-3-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT056:EE_|BY5PR12MB4967:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ebb1bb1-51a6-4994-f04d-08daac91e667
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zw6tB0HFT9Le6GMuoxiwNr4c6S9z57fgaIrIiYitRFDnsgWPilXdp4pWzcNg38CuEiCzgs39fOqFV7L8Ebfe3JeV/RAQ/Ob3dHeX8tfl9iKBhvfCaOPg8V7cSVvDWTv+0P9Ms4S6uryB7qPYoffK4nn5qB8ht+z30zdQX91dVPABxqMurO74c6j/FIKMFEWo9hkq+lDbJBYpxk6CtsmlvsC5jLl2LzlUdybuzAIZTTgWezc2glleke7qgA0sMDS8XFlbfl8Mi81mTZ9j95UjyM30vJ2/YhIZLlFpXCwJa7ENj8o7b6/XkuYYCr0Y0mfmHKrTRLA/mubRcn+YPXB6iVztLWKcFjibOdXIUpScqFsLbtXI/039INlG0apLkFlBfgEfWS9aUAvR6YihI3yZxbhfPbM+40HBsYzrBy65medaf6m7ZTUImmkvcCe9CVHDcoDeh4dINg2b4p12CB92xZPB18K8gJWyagP+ykPPNMcyoNHu7s5mPyZ5h5BE8l5v246aOO9rpapXo4njpdc/hF7JtWH8Yqt+luGkEJFaK0pR0e7g1yhrTciwl5B0GGM2XX/YYXqmIZQ5KU03t4uXYQUbuSMeHbJMPOTiBrE+DP2pA5eS3mPM8zpwxxJt1q6m8TRfj8OrQU6ODTFkhRwZoukhKDPjmwwmW5V6AQhy6HJAXVAKHhkeGCa9e1jC5aD/+1CTDI/5Ge/LBJLn44Xro5uFc5i4YfeB+oa8+W9floXjzF5+80+ran1OTkNPPOFslFNW2XPGt8kpFkeyj1c/PcpduF3Vwz0p36HBlVgYu2iBHd2ab1Wq9gqm0AP1OK4MDswGtJeNmPRH8AL4nnsuuw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199015)(36840700001)(40470700004)(46966006)(356005)(40460700003)(81166007)(26005)(36860700001)(82740400003)(47076005)(40480700001)(86362001)(6916009)(316002)(54906003)(8676002)(36756003)(8936002)(44832011)(82310400005)(336012)(41300700001)(2906002)(70206006)(70586007)(4326008)(426003)(83380400001)(2616005)(7696005)(478600001)(5660300002)(16526019)(6666004)(186003)(1076003)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 20:39:46.1528
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ebb1bb1-51a6-4994-f04d-08daac91e667
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4967
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set up interception of shadow stack MSRs. In the event that shadow stack
is unsupported on the host or the MSRs are otherwise inaccessible, the
interception code will return an error. In certain circumstances such as
host initiated MSR reads or writes, the interception code will get or
set the requested MSR value.

Signed-off-by: John Allen <john.allen@amd.com>
---
Adapted from: https://lore.kernel.org/all/20220616084643.19564-13-weijiang.yang@intel.com/
---
 arch/x86/kvm/svm/svm.c | 58 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f3813dbacb9f..1f31a991c745 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2764,6 +2764,31 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (guest_cpuid_is_intel(vcpu))
 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
+	case MSR_IA32_S_CET:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		msr_info->data = svm->vmcb->save.s_cet;
+		break;
+	case MSR_IA32_U_CET:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		kvm_get_xsave_msr(msr_info);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		msr_info->data = svm->vmcb->save.isst_addr;
+		break;
+	case MSR_KVM_GUEST_SSP:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		msr_info->data = svm->vmcb->save.ssp;
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		kvm_get_xsave_msr(msr_info);
+		break;
 	case MSR_TSC_AUX:
 		msr_info->data = svm->tsc_aux;
 		break;
@@ -2995,6 +3020,39 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->vmcb01.ptr->save.sysenter_esp = (u32)data;
 		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
 		break;
+	case MSR_IA32_S_CET:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr))
+			return 1;
+		svm->vmcb->save.s_cet = data;
+		break;
+	case MSR_IA32_U_CET:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr))
+			return 1;
+		kvm_set_xsave_msr(msr);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr))
+			return 1;
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
+		svm->vmcb->save.isst_addr = data;
+		break;
+	case MSR_KVM_GUEST_SSP:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr))
+			return 1;
+		/* SSP MSR values should be a 4-byte aligned canonical addresses */
+		if ((data & GENMASK(1, 0)) || is_noncanonical_address(data, vcpu))
+			return 1;
+		svm->vmcb->save.ssp = data;
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr))
+			return 1;
+		/* SSP MSR values should be a 4-byte aligned canonical addresses */
+		if ((data & GENMASK(1, 0)) || is_noncanonical_address(data, vcpu))
+			return 1;
+		kvm_set_xsave_msr(msr);
+		break;
 	case MSR_TSC_AUX:
 		/*
 		 * TSC_AUX is usually changed only during boot and never read
-- 
2.34.3

