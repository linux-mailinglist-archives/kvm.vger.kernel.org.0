Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E6464D0BD
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiLNUJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiLNUJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:09:17 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2040.outbound.protection.outlook.com [40.107.101.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DC13B9C9;
        Wed, 14 Dec 2022 12:01:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9tShW/mbNybmPxfm6mLgcjWi41B1iMGwE67JibC7sn6nqJ5rJKC33d44BWRhCQFKsjVPGs/PF1+NrBd9oGkuza3LIL4djo76Edoaa5CpJSc+z0dVdnycbrU0ZcjpmPe2lZOxK+lXpLlaZRrTvyl0UsRZ//0jqxZdoiN58oCRXrRjmPvG4NJQKevBxowAk1liWknbocv0+HcOnAIbINVGDvB4Y9+HOzQKuiDLSvNINZFppipEXiXiGz51xez5YTwp4Dj8IiZdsUHgLVKlNA9N5C5QBDyLSIl3puMIG3NJ1/2IhQ/8X1jVGyKMU9QOWjQA/d41Sck7kwPNZXb03dsJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kFUIUAb0hyW9i3i+pIzOyi+dQb0DpLo0gJKM8xz7HE=;
 b=O5QbqDM+MOzIWMbsUfFFFjjVqykGwEk1sX9p30oP0n0qgOE+B9FhNsNdFf0LTQ++gUiG9HirNHWuJTP/RpytJBs2eInEe3OUeAuw8RxnVLoR+SnR9poKr5p8ircjSHnTb8XNlY5Se7f3PfzXWapqmghOU7P1R0f3GE83EAffMen7R7OsZ0kZhAzTkfMvTOe7APvhsjw5oH5dFB9iLeu/SsPTv5iF2a7eycp0WJYkUu88zQqhh1evYSWpYOQeGCYF+wRVDLK3bfwLfaTQGf7dLx7fSvCRvUWZ/qAG3lDMbQV3hxQ7NwXGI4vK6stXer3yghXR4Vhv3fnne/VXsxwrVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kFUIUAb0hyW9i3i+pIzOyi+dQb0DpLo0gJKM8xz7HE=;
 b=gwC+03GNXitbim1DNmZ6+6VIvEUIuoOhKdt6/xKosp42ppJSBUVWD6wzpVzkjtiH3jxCECcVAaF0O+avISsaig1ZgOty6Rrt6rIPRjpJZGYeKyjE1amtbxctaDCxdS4byJ/wRseYWWuMkuv4kNzqLmTgQZIJ8HpPzLkyRxq6UIc=
Received: from DM6PR18CA0017.namprd18.prod.outlook.com (2603:10b6:5:15b::30)
 by DS0PR12MB8199.namprd12.prod.outlook.com (2603:10b6:8:de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:01:47 +0000
Received: from CY4PEPF0000C96F.namprd02.prod.outlook.com
 (2603:10b6:5:15b:cafe::79) by DM6PR18CA0017.outlook.office365.com
 (2603:10b6:5:15b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:01:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96F.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.8 via Frontend Transport; Wed, 14 Dec 2022 20:01:47 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:01:46 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 48/64] KVM: SVM: Add support to handle Page State Change VMGEXIT
Date:   Wed, 14 Dec 2022 13:40:40 -0600
Message-ID: <20221214194056.161492-49-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96F:EE_|DS0PR12MB8199:EE_
X-MS-Office365-Filtering-Correlation-Id: ed048386-2c81-4f8b-3cf3-08dade0e0866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y1keZEAKZfOkN9afkJYpKHOnOz+AMze9tGVi52NefP4qJ1V3nX+h8oEnhwfjdqTy3lHvWofSG8O5M5hjMVJoakEQSLuIHXVsfi2pclsbo+XLQ9POexkv/wo1EEOkbw3XU6Ukl40SMzsrw1HKfSIR8HZdA+dsnFObTmTP+W5+QdmR1F3CciVy+aeJu2wai+hTWXuMkJY4vWfEz6VXARPHOaf7EnjCc1LxBuJDssongzU5cNHPR44IZHqCrFFstj/vK3kqINP+wc9+QbQhkks1krL0JD2wNrHqALhsQmdD5bF2Av992JhwCxbj8mzZ0yKVdfNRuSoZ3rmsXzNUWEVLvRT/wteRG3tUGYMQV+rffSYiKChXqguXqJHgMgGZ8HPgDz17xl5Nyv+iiL60SXhRJY1hCnwPWdFjO2FkofAsuFpF9edEb1SRzUff/lxd1NS0xz6lfpjoC/fdCDepmKbScz0dX1drRQcVQrzPK22ySCRyqzOmQu4RE17MdfGoZCvMbg2IMEjiFhJgCQ96RybCiv2KvoNQZHohk98RVW7lvq6Tf4XpuM9xH3xh67buwMVlSGUqYKJdahRuig3uDXdrKJOx7GjFnSK5HjQn9dNGGrngkJ3UlhOdgxtBGqF2/09PdcRmUVHEAEVPBHF58z+RAAI43YGiuS/hyJ4XP/xz3ftURKcVShSAeXR0udkIutXB6x3cdjJYlXxzaWbOjKaRfkwSjWcN+zE1wrs24WqV7MQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199015)(46966006)(36840700001)(40470700004)(356005)(7406005)(82740400003)(2906002)(81166007)(7416002)(36860700001)(5660300002)(86362001)(44832011)(478600001)(41300700001)(40460700003)(40480700001)(6666004)(70586007)(4326008)(8676002)(26005)(83380400001)(426003)(82310400005)(186003)(8936002)(47076005)(16526019)(316002)(1076003)(2616005)(70206006)(54906003)(66899015)(336012)(6916009)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:01:47.7078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed048386-2c81-4f8b-3cf3-08dade0e0866
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8199
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change NAE event
as defined in the GHCB specification version 2.

Forward these requests to userspace as KVM_EXIT_VMGEXITs, similar to how
it is done for requests that don't use a GHCB page.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev-common.h |  7 +++++++
 arch/x86/kvm/svm/sev.c            | 18 ++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index ee38f7408470..1b111cde8c82 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -130,6 +130,13 @@ enum psc_op {
 /* SNP Page State Change NAE event */
 #define VMGEXIT_PSC_MAX_ENTRY		253
 
+/* The page state change hdr structure in not valid */
+#define PSC_INVALID_HDR			1
+/* The hdr.cur_entry or hdr.end_entry is not valid */
+#define PSC_INVALID_ENTRY		2
+/* Page state change encountered undefined error */
+#define PSC_UNDEF_ERR			3
+
 struct psc_hdr {
 	u16 cur_entry;
 	u16 end_entry;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d7988629073b..abe6444bf5d4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3164,6 +3164,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
+	case SVM_VMGEXIT_PSC:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3368,6 +3369,17 @@ static int snp_complete_psc_msr_protocol(struct kvm_vcpu *vcpu)
 	return 1; /* resume */
 }
 
+/*
+ * TODO: need to process the GHCB contents and report the proper error code
+ * instead of assuming success.
+ */
+static int snp_complete_psc(struct kvm_vcpu *vcpu)
+{
+	svm_set_ghcb_sw_exit_info_2(vcpu, 0);
+
+	return 1;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3595,6 +3607,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_PSC:
+		/* Let userspace handling allocating/deallocating backing pages. */
+		vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
+		vcpu->run->vmgexit.ghcb_msr = ghcb_gpa;
+		vcpu->arch.complete_userspace_io = snp_complete_psc;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.25.1

