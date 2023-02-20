Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808BA69D352
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbjBTSxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbjBTSxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:53:01 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE42D1F5D5;
        Mon, 20 Feb 2023 10:52:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdHW4U+TYdBoR1NKRGdLaZEiN/0pMr2upaJJxo09Ffl9PgpmZnoIof9T8sL30VNozDrQiso/Gvmghj2glvTERsW4b/WDAFWE9A6E3LNan0gDlAvPTGGwi665iOGVoPuV5kz0XlfAS02rcl/MBpuvxXmI7o+hXWtMxU6AbZB5ai9r9PWtgOaDGKHMdVQ+QnJkEcbPg4SQCf5lOCSITPNALHuoxIuJwUPfNVl4y2czB4WJ70XpEBPAKO20AAD9jjcwEQL8XRw4Gj1Id8vmnaNCvyp129dLOi8qyg8II9AgTLrOpwQ9cp9QLZI8nCnTc2MhbxBk/N+cFnrm2RLhhmMiFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pK6F+pvFORzmpnS48WkfqKT9Msdt2eLtlnHN8hpVCdw=;
 b=JqN2ucfZTa+5uqcPuJKe4eAFCCF0jS5a8n2r6ZnwkLufjL+iBMWoSJGP8aH+dIir3sh5bQf+ExxQy7QcRVH4FEXTzMBDaGcoIhnb/8kQwkP4gmNxjva6/dMTAqhGZRkiHNg3q5xGzfim5If7LasViu8XrLQBkC8aoSsh0x05PDsQDhUS+JdvQdaM4YUf6nLopmxvpBfrKf4aOjnqANJmdHWTizj8ia9rZS9wLZroPoSzS3okNWCyvzG3gfz7ccUbpRFPMRoVHAifPyyZkb1LOjhMrPQ599XYFrk4nNMwjvxrx4KEtjk45Ny6pnUGNjfmhcG/MjiZUBCSXLswiTPyVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pK6F+pvFORzmpnS48WkfqKT9Msdt2eLtlnHN8hpVCdw=;
 b=sRnSYHgcMD9peg+NPPUlZOxLJ8Rasutg0+ECBG10haIfLQxCMevj/VLYBgbdcOZ+5LRhrKDgc7AIhIth5co2QKW1tVuUKZaizaA1eqdASOhOIEqKg5PFHFmcC8tM/DuMEPLhEHdJJEODhA37PP3AZLC6IDnoITWp6iywi+0Tu+M=
Received: from DS7PR05CA0048.namprd05.prod.outlook.com (2603:10b6:8:2f::19) by
 CY8PR12MB7683.namprd12.prod.outlook.com (2603:10b6:930:86::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.19; Mon, 20 Feb 2023 18:51:14 +0000
Received: from DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::e9) by DS7PR05CA0048.outlook.office365.com
 (2603:10b6:8:2f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.16 via Frontend
 Transport; Mon, 20 Feb 2023 18:51:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT098.mail.protection.outlook.com (10.13.173.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.21 via Frontend Transport; Mon, 20 Feb 2023 18:51:14 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:51:13 -0600
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
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 30/56] KVM: SVM: Provide the Hypervisor Feature support VMGEXIT
Date:   Mon, 20 Feb 2023 12:38:21 -0600
Message-ID: <20230220183847.59159-31-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT098:EE_|CY8PR12MB7683:EE_
X-MS-Office365-Filtering-Correlation-Id: 27061840-6531-409e-7a37-08db1373713b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ihBvJMNj23d4gRAJHW+CDN2Q9f0LLMQFvjksOcwdXg8Ilb5ts2oe7CHAsINweQkyjfS72GgTltG91q8tsyyJI93lMvNDNsHYkLrVwnMoDKsajR1AxR0eXtuJ6ObRvsbmtXQHYJEKmdjEWJLdv7DWFzpItvBxP+U1hSmBo5uZBr7t4Jjs6KXnwOOguk5CwodrZkcnMsaQ9eTGA9fBQbTy9w3qvFuGYABYiuyvTp1XYFTRy8sdnUpcjvTrBH79tGaes16F1uwV1fIKVPmNABA6kc0TJhVepIM/VkFm2ZXor8ju3NnLFjgmaJVUGjFHUI/A9+/ISz9N1gT05PnytX+zP2fVoWE6BABJ9Bkyd4mMDZpNh77tPQNhnpxF514QvXLMqt1WIr+YAFfaI4O86VkJH0OsLpA+qDs6XzUkJm7UxWvg7AWmdeyBoFSNJekot5lUtWbpSocFznAwzNTCoVS8yVrN6kiY5rT3GKzUVO3rshPK8B5brYxD8sP7LiGdYpKxMJN7V+IoD1YxrhbYYZBffx+GAv1CfnXJyzQNeFIBP4P2Yifsssbtw9PPtuvImji6fklK7RIsBjNPC/BgZU9ntzItiyyUksRDEDK4gPikpj+FqKeL/uQY6mG1zneb3CEsTR8QkAQNd0a1F41JtVVUECF8WZA1riq7+Kp1bWGVsG04Jl8wiAhGKvPpR83khrpFfxxEYccozmooCkxwLk3LEBX/VQQvjJGuLTjc9RIirLk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199018)(36840700001)(46966006)(40470700004)(82740400003)(44832011)(81166007)(36860700001)(5660300002)(7406005)(86362001)(82310400005)(2906002)(7416002)(356005)(40460700003)(36756003)(478600001)(336012)(47076005)(186003)(16526019)(26005)(40480700001)(426003)(70586007)(316002)(54906003)(83380400001)(70206006)(8676002)(1076003)(2616005)(6916009)(6666004)(41300700001)(4326008)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:51:14.3697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27061840-6531-409e-7a37-08db1373713b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7683
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  2 ++
 arch/x86/kvm/svm/sev.c            | 14 ++++++++++++++
 arch/x86/kvm/svm/svm.h            |  3 ++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index e15548d88f2a..539de6b93420 100644
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
index 05eda0940e22..c1f0d4898ce3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2675,6 +2675,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FEATURES:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -2941,6 +2942,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
 
@@ -3065,6 +3073,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_HV_FEATURES: {
+		ghcb_set_sw_exit_info_2(ghcb, GHCB_HV_FT_SUPPORTED);
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f4848e6aba28..c249c360fe36 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -662,9 +662,10 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FT_SUPPORTED	0
 
 extern unsigned int max_sev_asid;
 
-- 
2.25.1

