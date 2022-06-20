Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495E75527AF
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346609AbiFTXIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345739AbiFTXH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:07:56 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7149B23BEB;
        Mon, 20 Jun 2022 16:06:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVhZV3r2fgl0gRYGDQNHRb2iYEJfWD/vWhzaLIkeI0huz1dXhX2fcsHAXUXZw9uo8nE7Ab47ICt9MSRF8fqbJe6gb3FUhxzW0icJN8cd50NjFdOqfiCD81HQaxQhPWCszdFj/pGtb2TmKuAF/OirzdmY4MQ81SQlCX2NXW4GzGQndx/ig03XwoaPUSs6XuxfPLwdl6fjMUAae1YPiCKp8XZBbN2/atWB1GW+BwZzDA/mpE2JAGdkEIzpb4EWponJ1Dm1t2sFscGq/k/GnQyf4KEZpVbk1WYwFtY2c1NLgDZW54zmHB5QGV9BE5lUW+YIEDzlvfeKovTUXBGRidH6/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gRNldrZ62q/dbiU8EB7pwK/9hQjFTKYoEkcuqsV4KLA=;
 b=RsBsJpv9pNLwkKPT3tRGgMhhWwGuC1nOWWhFu+qQ5Rb5xuZvYVlK43jczfgyLP+Opq/tuVKBPl4w86TrkijHd1vjoACS97JWcezWm+yF/cZal4AIBZo47tEOKYIknwvD7RpP4TPUd2fC9X9JmClSB6+8dIxJX9H89PGMet9kZoIIA75Lws7G2qUsBur6Ox2Zf+3jazGkpaeY+Cx67a6lqO27IYxs7Os+7ZvkZXAYxj5Mv+z2UCWG8yCwMyZAOtNCR7G+6lVAslepkU9o9323wzv5xuHXWOVHREszGtUICC6MZfqw63vce7MPt9KT+wHwLYqvSIv9Z2DZTOfn6q9yDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRNldrZ62q/dbiU8EB7pwK/9hQjFTKYoEkcuqsV4KLA=;
 b=CtDB7DjlHuHzgpsm+Bfp+hka23DWGcUYeFD33HEq+UuDRpL+e+M2hULZNUrA+d3RtYcgGpWZXgWbQb8ch7Bvi+K4QYK7aNvadhUIqpoXGbYnnMcqX6W9Il7pRa3/b9ruvgDAcfqku9OtmrBFnbpIgr4JJBPRN0WJoTww0eCTYc0=
Received: from BY3PR10CA0008.namprd10.prod.outlook.com (2603:10b6:a03:255::13)
 by DM6PR12MB3881.namprd12.prod.outlook.com (2603:10b6:5:148::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Mon, 20 Jun
 2022 23:06:48 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:255:cafe::ca) by BY3PR10CA0008.outlook.office365.com
 (2603:10b6:a03:255::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19 via Frontend
 Transport; Mon, 20 Jun 2022 23:06:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:06:47 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:06:45 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 20/49] KVM: SVM: Provide the Hypervisor Feature support VMGEXIT
Date:   Mon, 20 Jun 2022 23:06:37 +0000
Message-ID: <2aae6a4456858af4cd45bf2d8a2843f114b8e200.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 760845bf-f7cc-4ad6-f4db-08da53118d8c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3881:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3881D1A3F1E483F638C70E498EB09@DM6PR12MB3881.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Su2e99hT9FSuskmNU5JDtrXyAAbMbGzBHuPBh6ITrmtE9MWkgw7Fb6K0Y/O88sL16fUHbM4A9yGrMiXEML2Oc7ImTs0BHN+C6KeIPDr5Pp+fvI0IupiztKNaXi/gAOin/qVZWJ4/sHLqhGq07YEPCJlcTtptj7VqJsElhuqd6NO7JmG8c1dwvMqDt4nK99ffs86lm9WhkS03beRC0pPZ/eW2TKm59LW4aYzk6X+qVGU69861VreYOnHUV79YypYsMm34zTclYfvJzbR2hXmrflcE+ftJv6f/Vz8UoyPFrOXTwhvnIYNBbu6XDZbtKukSml0M8osAK6ofjOYTLfOwDRTgB2EwQudJA6RRxcJiLQTsMTxf/88wvDtkcPE7e6UyXl7wu087QCw7KNOQPGWp+7RQRwC8BJrP6kdG6RRveZppBTOjiVl1XXXgEiCr+okuDCDkyQQRZ/7L2igHexsWcsTeiXi5XI+33dPi22Atb3kaBoXIAqaNEOecKDIxqCqykeLS0uNJkWLtYc/VUhJpewwVkZXLqEBGZFbMB6Mc8ythhAaQ2SoJaQ+zaWVfYvmIFFiecuKxdbUqNkwB7wlH+rarmyFia5DJ/cpBDSGbsbbb85Qe5wIbV9GWG0Lfq1WWNFqC0eSXisuZxsLmjKdGGe5reCkS5NgncHLHa2sAyWw90EpSNkCA9CYnfTYmR/pD8Kol+ul6tR6cAf+6G9wYVKUQOPRYiBIvJVpJ07IGICU4E2yEG17EWqfg539u5r/2vocoGQ46NhxkdlzKxcSNYQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(376002)(136003)(36840700001)(40470700004)(46966006)(26005)(7696005)(2906002)(356005)(82740400003)(86362001)(316002)(70586007)(6666004)(110136005)(82310400005)(54906003)(70206006)(8676002)(4326008)(7406005)(36756003)(478600001)(5660300002)(40480700001)(81166007)(7416002)(47076005)(16526019)(186003)(426003)(336012)(40460700003)(41300700001)(2616005)(8936002)(83380400001)(36860700001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:06:47.9627
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 760845bf-f7cc-4ad6-f4db-08da53118d8c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3881
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index a1318236acd2..b49c370d5ae9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2480,6 +2480,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FEATURES:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -2746,6 +2747,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
 
@@ -2871,6 +2879,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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
index 9f7eb1f18893..1f4a8bd09c9e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -629,9 +629,10 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FT_SUPPORTED	0
 
 extern unsigned int max_sev_asid;
 
-- 
2.25.1

