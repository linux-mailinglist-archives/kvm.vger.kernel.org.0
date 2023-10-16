Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933DF7CA99E
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbjJPNfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbjJPNfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:35:12 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD82134;
        Mon, 16 Oct 2023 06:35:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biTCQeeeEbCa8G9YHtphd5jyCPv9k5KZnrbkvnyx3+zqz0l/8KYNFxd++Nmf1kmov5KicE6N3hJOb3tNgR+oUm6WIPxYCS5nnst06uTk0NdX5G+9lvxKIl0utIrHyooWmm8GXwqVKYDVbvPIiTS1TcWiMtUy/3zC6ijRh4pTgbIXjszxHPNT4nFPVR1ctUaMYhSez0sEwBa50Z0bHllEQYMF+rzdPq95OKHIZf0N1SLgkf0gZBabZOUg4YeFmcP3k4xaMoXVMUKozlVH/21NF7D9LOPZuEx0d00TSqkPqENGu3cAjWdOl4YVzgIVC5CBfGSOQ5did7YMq1fs6cqb2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4RrXZlIvfGDBBifiC396TqziXB7qceYDwH3mF86alNY=;
 b=j923pFthXTaAEjuQ7u+bEhyPqNgHubXTA6ji3Sh5C9nkwmFjyhW0GGAy239v9ivVuV1vHKn0Z42MD0QDQx+eyzx1Ggo0v5DSwwBGkOJD+DZSH33Eshh4KS4zPwkyvE0J16UNgwgQ0wEOf40famIYfN7Q4F5J3miU7eMuAKCJH4TPqPXDFdmkQvu6DijY214CrKU+Ylhw8sUQ3KnwrFvODuFkPMAS7841zOtbTTPmUuQJTAclSGpKSEFqI0GKW8j4TN1cmSN4625rn/gaXQq83ofgMb/7pKl+OYM91SL7hzlgtr6upr4+U4tko9330Ip6YOxHHJSVJYB6gYijfBw4lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RrXZlIvfGDBBifiC396TqziXB7qceYDwH3mF86alNY=;
 b=5HD2mmZZs6AL1xBA68EY7Z1L1XG5lbVuY9WkoYO+/tE6BK/5LuzSArO3Zaaa29WL9AjYjf4tNTq2QRtd9UOwEvZdkrcOzT/MH8hKJxltO9pEF4gtc56vIaLnimm6PIFbCX2Oycs+MMxogD5DETXMjnG+P+775kx55KEdqJa19NU=
Received: from SJ0PR03CA0026.namprd03.prod.outlook.com (2603:10b6:a03:33a::31)
 by CY8PR12MB7587.namprd12.prod.outlook.com (2603:10b6:930:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:35:07 +0000
Received: from MWH0EPF000989EA.namprd02.prod.outlook.com
 (2603:10b6:a03:33a:cafe::2c) by SJ0PR03CA0026.outlook.office365.com
 (2603:10b6:a03:33a::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.47 via Frontend
 Transport; Mon, 16 Oct 2023 13:35:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989EA.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:35:06 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:35:03 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 22/50] KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
Date:   Mon, 16 Oct 2023 08:27:51 -0500
Message-ID: <20231016132819.1002933-23-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EA:EE_|CY8PR12MB7587:EE_
X-MS-Office365-Filtering-Correlation-Id: bcf3b2a8-e7a2-4d30-5360-08dbce4cb5f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 43bZGeIWh4pS92moqTSgzAOgkeBILxAwBnRMrN5fEjrRQD75vpDqjNa1/TcLwkD+4BaMkyIMQ5xQrqXM6ceV/Lv7MTEci43qIVcsIlaW/fKaM9RPohFx3N1q1F5knQsm8O1B8LZ1pNW/n8l7Khp80fDmx6pEI1lO6iI3zybK/UHZOzLqKTLbLNp/pdBab8b+48bj8D6l0Vy0+2UG1op1IMDdD7nPvpy0tpVN1lj1xRfKPFSPOp35VDJBaqj0eifYnD7rRLGd5C4raybrCbvikTj0GCBIgQeVAT2bokMIo3UznHwcGxyNOGAclNA4sKAJnUiH0iJQM3j+eih4L5Yp2po1Jw7bgLL/RKvhzTBBmrRBbVOqLKQx5azUEnsQpWl6JrHXJrFlYKkUaOSaHxlyCOhVAe/s3JGiLD8DStW5p5rBxqKC6Ae+gUdPWPk0vKkod9vZDxO8JtE01SLOEyLKVWzJsxLhEC8pSsJgTtrbKYlYCEJPEWgnTHBtRGv9Z2ktzlWXjaDywwZhN8HTP3ffqc1LXaFrdOJ6U+Y9NH2+oYnU7eXGxyxuYtQHNM1FqpzcIkoPtykU2c10UDzuZv/20HxJfolBrATMWGJQnU8lJ4D/pVTpBCPcin7AqULU5E1NTWEtEoyuWaZ9f8pp6fDdFKZMTQ4fFnfbRodHdqOfHpiMYmbedcylIS6DKqMi6nUfpbAYESvekC6wRvs6mkLVGI8rrBpVWwjKQiQaVstExg3BtF5SycOsuTckVLbYQfVdc3x5llJGwZett4fUvzmw0A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(39860400002)(346002)(376002)(230922051799003)(1800799009)(451199024)(82310400011)(186009)(64100799003)(40470700004)(46966006)(36840700001)(40480700001)(5660300002)(44832011)(40460700003)(6666004)(2906002)(1076003)(26005)(36756003)(2616005)(426003)(336012)(83380400001)(16526019)(82740400003)(356005)(81166007)(86362001)(36860700001)(47076005)(7416002)(7406005)(478600001)(41300700001)(6916009)(316002)(54906003)(70586007)(70206006)(4326008)(8936002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:35:06.7044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcf3b2a8-e7a2-4d30-5360-08dbce4cb5f2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989EA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7587
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of the GHCB specification introduced advertisement of features
that are supported by the Hypervisor.

Now that KVM supports version 2 of the GHCB specification, bump the
maximum supported protocol version.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev-common.h |  2 ++
 arch/x86/kvm/svm/sev.c            | 14 ++++++++++++++
 arch/x86/kvm/svm/svm.h            |  3 ++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 57ced29264ce..9ba88973a187 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -101,6 +101,8 @@ enum psc_op {
 /* GHCB Hypervisor Feature Request/Response */
 #define GHCB_MSR_HV_FT_REQ		0x080
 #define GHCB_MSR_HV_FT_RESP		0x081
+#define GHCB_MSR_HV_FT_POS		12
+#define GHCB_MSR_HV_FT_MASK		GENMASK_ULL(51, 0)
 #define GHCB_MSR_HV_FT_RESP_VAL(v)			\
 	/* GHCBData[63:12] */				\
 	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4f895a7201ed..088b32657f46 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2568,6 +2568,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FEATURES:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -2828,6 +2829,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_MASK,
 				  GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_HV_FT_REQ: {
+		set_ghcb_msr_bits(svm, GHCB_HV_FT_SUPPORTED,
+				  GHCB_MSR_HV_FT_MASK, GHCB_MSR_HV_FT_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
+				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2952,6 +2960,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_HV_FEATURES: {
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_HV_FT_SUPPORTED);
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b74231511493..c13070d00910 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -663,9 +663,10 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
 
 extern unsigned int max_sev_asid;
 
-- 
2.25.1

