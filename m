Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9136864D08D
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiLNUBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiLNT72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:59:28 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD61C2BB12;
        Wed, 14 Dec 2022 11:56:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOQCV37goZZCAOTG9koypOxO5JfZ7m2k/sSCYkcb4e3ggQq/xi+X6FzIWWSjowHdCcxE1OolhM271qtxAqpxpif3BC5sAbHf0H9HH+RMHvlzORjPSEEpD1gWqmOFsjagO1LXUUsUpy9f53eybiTWXRo2wiowsS3MbjoZXsRsKHGc5OaLb3hm11w343/yrNTBz7DneGgzbjWva6sQOV3g03GLSBQuQynwL3ghNbUrWynciMHAt64MdBuvroLfDAT+MfVJRyxsSuFXJvtU6+y66sAKqKnk5/CjSbxEHu/Pl/q0iOUo9UjypcDgamxhXKineotqXoU443QsoY4YNsBLVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3Ryree9hpK7wmsj8Cmnp5OW6S0cIpM4e4m1hjfhEpw=;
 b=Jh0K9ol7GcTMsYdDeH1ViSaipL4eVGi7nF/Ky7MULlenhph/4rr9ye/VavxKhzS9IX69FiimiBxp+OAxjYIfnwnav7WkUUlU2kgquz3apf67dhts+Hn2fYBM4sKinO3V5FKVaby18ZrrgkF/lpmff5IfgfosOPjQBDp1vXulU4SUioJAkWfkBg/wW2Y7ZhEtoxR2GCOJolzi4EwMod+h0eJWs1I0YwK5LpbZgCqbmen3Id8vKSOhWph0ikuE/f2TVa3gMK+d+Y0Xi5LHW70eYMgaHY4v7p6LbK6LhVZ6s5LdlZWSt73MV6neYJLnieLn3wSdHvfnT0AN6pLy8jGw+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3Ryree9hpK7wmsj8Cmnp5OW6S0cIpM4e4m1hjfhEpw=;
 b=Jbr58qUqG8ReQtJFf78Pa5npdAXdqxCr5rHBCorOV4BWJNvEqm2nURKA6XyCvYQX9O6j7NjrcaLpqxc8bUSu9tABPuVPj6sDE4Q54jNx7/qswm6a5BPIO5tGlJUfpW6eIQYnmc13ILyXOYe9VnqF0lFKLt7tUFBU9Q/g3lR8xQI=
Received: from MW4PR03CA0350.namprd03.prod.outlook.com (2603:10b6:303:dc::25)
 by DS7PR12MB5791.namprd12.prod.outlook.com (2603:10b6:8:76::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:56:33 +0000
Received: from CO1NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::c) by MW4PR03CA0350.outlook.office365.com
 (2603:10b6:303:dc::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:56:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT079.mail.protection.outlook.com (10.13.175.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 19:56:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:56:31 -0600
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
Subject: [PATCH RFC v7 34/64] KVM: SVM: Provide the Hypervisor Feature support VMGEXIT
Date:   Wed, 14 Dec 2022 13:40:26 -0600
Message-ID: <20221214194056.161492-35-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT079:EE_|DS7PR12MB5791:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f41c332-1e03-4a2a-de9e-08dade0d4cc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X9TGCmotSEQWS7JgXPr55j/UvtgVE/sOQYryrLs8BzQ+DQsvo8UjjWH1AuuOoUKze/L2tVehcsRjAdvyjBsfIL5WGZk/vIcUIAubZpPuSoHv4U2K4uIS2MFuBYNy3L8FQevq3lWnQFiQpalS+WhEed8Ie/zumaIf0HnGeo5i5zVbL4Q7aEHB0KlEZcaSoCMaKKXChRHDLSKhXPi2Ag0CSh2APNgwOuklqKahR84a+tUjD7Bx3BhFHab0DqXkKgOQgn/SzWUeCozPNUGYgzlAoHn0sbivcxJPoqJ8GZLPWX/LlnOJkQC3h6GqPqyRSjJUFbc0d40Qq44X9Ll93ZoeNCrrc2Q8MquNjkr4SEX+SBOOO+gHzRRvpWiLKktevVyzUxJ/cWmIu0DT94mYTPgPzXA243eHPKG0BdfklMNPTEtUGwbeQdEyvS002STdk66nWe8lGDhSfcQ3Al732ehqDXTxjyKTbbJQQFrp0MFd4mmYKNQlyFjvbRv6MOaM5YdFcWLXfpYAw+eVfqspOnCln90R36LXzab02fYWZffjAo45CX3rNAzM8xace6SAYvrVKVns/3JWPuwv6YPULmjo+SuoJs2I2uxUtsDOEz6VI6kvrFDQW6TG36bdw+V6BJ8HUMpbQV0VKu45bbLuDg1ORGK5dRNfXk248j6xh57B1jPGp5DVQWXb8++xCW/+2hAifzNs1P7IaYh/QDCK/83qdZsbTQhMh23kWzpR0tRFQFw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199015)(46966006)(40470700004)(36840700001)(82310400005)(36756003)(86362001)(40460700003)(8676002)(4326008)(316002)(70586007)(356005)(82740400003)(81166007)(36860700001)(26005)(426003)(336012)(54906003)(2906002)(44832011)(83380400001)(16526019)(40480700001)(6666004)(7416002)(70206006)(478600001)(7406005)(186003)(6916009)(8936002)(1076003)(2616005)(5660300002)(41300700001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:56:32.8761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f41c332-1e03-4a2a-de9e-08dade0d4cc5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5791
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
index 244c58bd3de7..82ff96b4f04a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2667,6 +2667,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FEATURES:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -2933,6 +2934,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
 
@@ -3057,6 +3065,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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
index cb9da04e745a..1f3098dff3d5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -654,9 +654,10 @@ void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FT_SUPPORTED	0
 
 extern unsigned int max_sev_asid;
 
-- 
2.25.1

