Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F004E7C4089
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 22:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbjJJUDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 16:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjJJUDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 16:03:02 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B4A93;
        Tue, 10 Oct 2023 13:03:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awK26XF2I0eIup0OdBSIaqUE+r/Yv/WTzOes7p3EurFBJn3f9SQFsHlklsdMcdt+Un0EXf06fP0TRrRtZPrO0cTMDilVU1YSwky3tVRh3Ra6oqaQJkg9ioNOnqrk7YdBRN9/X/EYsvfyb4z17PRM3S4wRUnWAItLI9hbPzBeuchXMOB3/bdUEh2ddTa4VHF7CeHSErfDS3Y1W8OvGu5e0rqqaBgwODnsH+yFlK39IuEFrNsTTUHLml6I0xvRbpjl++AdMCFHLeu566UsrerJwxKSZpecNVjbdWjsHFK3zmYQkw6Jz7/m4pk7HnU2KA5gUj69Ct0Znw4vG3UPC3cQyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QhMVG40k16QnEOd5TZV+P9T38+kg056v8RcfN3Ut5eU=;
 b=T7XByjHVlmSfRpcgFzH3LCrsMIfK0BlQPry71W27o9f2e/zIYwpiExDQn2LEQcsqMn4QGFEqm55N/HNImdZzNKmu7vASLBvIHIf4K9E97BWGzruTsh5IRU7HXPqfI7+jfndxXlU8A9poh1weW/ACd1ieEuesqaahDwWnC3pYpzV7LVjW9BXkMacJJ/7vPzQEPCpEwrrLj5oNXPAgkDMTuqXAW0w0sJCI53W2mjJJj+dZrsF0+uZOWRcG4cPA6df52H+4yYUztgmfmhkuvynuOSbKPaVcoPZAIEpuVbfhg1lC3EPCtYUEHXxHjZLcBLB4qBWACwhr6WY2v6O1b6oWVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhMVG40k16QnEOd5TZV+P9T38+kg056v8RcfN3Ut5eU=;
 b=AjKv1jxcHYl/ko0bLwMMiYe0TmkkaPCavdybeh8tNaTuosZCbkoJaPZlDnhkqC5pggeg6Ej6rFq5U+eq4fMdj7slorI1QrcXp9nPOSp/4mhlN7XiUsEyRv4xDHPXvEZeBpZbYqIEOzG7Nv5ezq9+KMxuvUH9K/YP01ANbn8G2Z4=
Received: from DM6PR07CA0084.namprd07.prod.outlook.com (2603:10b6:5:337::17)
 by DM4PR12MB6397.namprd12.prod.outlook.com (2603:10b6:8:b4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Tue, 10 Oct
 2023 20:02:57 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:5:337:cafe::ce) by DM6PR07CA0084.outlook.office365.com
 (2603:10b6:5:337::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38 via Frontend
 Transport; Tue, 10 Oct 2023 20:02:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Tue, 10 Oct 2023 20:02:57 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 10 Oct
 2023 15:02:54 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [PATCH 1/9] KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
Date:   Tue, 10 Oct 2023 20:02:12 +0000
Message-ID: <20231010200220.897953-2-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231010200220.897953-1-john.allen@amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|DM4PR12MB6397:EE_
X-MS-Office365-Filtering-Correlation-Id: f71ba29a-0737-43ba-b501-08dbc9cbe5f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CismyJklKxIOBoF4AW3SxZLHGggE+w5V9qPuusxoJKagNB/KiqKWAUVzzOqV/F4yJw+kJEmPtXdSd7VF0HI+KYjgbjE17mfuV5GEogOjnKLq7UIhpCtWzSktyawejkfnITGDWmNf3Ogk90/FpDCKEsepHRGIBGPJk03vL/SF62PEGKc2bJUZiECfi9EK6JiThxEYJkNseQ2hra2NohKRdW0xfHC2ITVEPXz8WX00MkDu83tUUjSh3lyKEiAZO2lhZ5JWLAYEiedQfwXJGwbQ8GzRyyo7WeZKSV/gpb21FRSP+bfmMF+2Jkj7bPv9c74DVC3HNeQwQrdrkU/SFwDlguyLGQA4/IfWD0xnIhecgHbCCqGkV8ue4ngCLFzg7he8lIqNR7jBHFidM5QWArycIHAquepn4GErKDrhfYDp8VWNmEnojNrRbJxD0ODfjVaKQSzeHsZdE2Ac1v0XIYMI9cx2RCF+R0deV7YWuS+wYwSPqBUEhVC5ZlIpySVU171o1YQFJ8pTTnFfmnPgiFzdydBNx/T4nd++ETxkSJH12OCPyP1bh64T7z/x8PDTkYsEWpT0TmDMNGqk/O+k01Mm2Q/W2i1N/HBiN5MJz/aUazXLe5xkpZYGx1vAsZvPEAMaVnT9niiMN7Pcsf15GJQ+MsknrCrHOV5vJWLzMtdlkaEIieUqyJzCNK5qAIHLKA5cClbIMyVUNirmSX+hdPRbkMygH7Yy7oUmyL+jvefawsQqvwsPVYhUCxL3rgzNhvRZQAB49QpVtPDXnPgJXbKGcA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(136003)(396003)(376002)(230922051799003)(64100799003)(451199024)(1800799009)(82310400011)(186009)(36840700001)(40470700004)(46966006)(83380400001)(16526019)(426003)(26005)(2616005)(81166007)(1076003)(336012)(40460700003)(86362001)(36756003)(82740400003)(40480700001)(356005)(8936002)(6666004)(4326008)(478600001)(44832011)(2906002)(8676002)(5660300002)(47076005)(7696005)(36860700001)(6916009)(41300700001)(70206006)(316002)(70586007)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 20:02:57.5774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f71ba29a-0737-43ba-b501-08dbc9cbe5f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6397
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
 arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f283eb47f6ac..6a0d225311bc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2859,6 +2859,15 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (guest_cpuid_is_intel(vcpu))
 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
+	case MSR_IA32_S_CET:
+		msr_info->data = svm->vmcb->save.s_cet;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		msr_info->data = svm->vmcb->save.isst_addr;
+		break;
+	case MSR_KVM_SSP:
+		msr_info->data = svm->vmcb->save.ssp;
+		break;
 	case MSR_TSC_AUX:
 		msr_info->data = svm->tsc_aux;
 		break;
@@ -3085,6 +3094,15 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->vmcb01.ptr->save.sysenter_esp = (u32)data;
 		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
 		break;
+	case MSR_IA32_S_CET:
+		svm->vmcb->save.s_cet = data;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		svm->vmcb->save.isst_addr = data;
+		break;
+	case MSR_KVM_SSP:
+		svm->vmcb->save.ssp = data;
+		break;
 	case MSR_TSC_AUX:
 		/*
 		 * TSC_AUX is usually changed only during boot and never read
-- 
2.40.1

