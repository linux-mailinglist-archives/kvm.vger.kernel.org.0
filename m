Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB11C69D384
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjBTS6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbjBTS6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:58:11 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2061d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::61d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366ED2196A;
        Mon, 20 Feb 2023 10:57:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+tSWxncI5QjIemmHL8V6b1wiJ82mlW3qYQncKyTUIJmiaKoSfBruT1yYqJqqucPtGAPTlmBJMJPIEArZxGUAdktNpQgUm3fOwMCksjdjO89HE0g9A9k6EdY6LIDvPwkHJJGn5uxDsLDYX8ROrNJTxTsNlELhjf6f+gFI13IBb1oadVXRRJwagtBdL53Bp/KS4WBoCFF5x4H4JirVzaBDW4rAqq1GdZ1xwDz1Lc3lk8U1qL5I5KiNOrp4z6+s29lkFAphMLePxoaMza7U8pVuTkOb1XXQIoXZuAJCT+rKJIdLw/TQA8K6tQ1o+HKr62KVcjB5lHsTYZn3SJcoKhZkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/oTnKs+99hfYPNpv6B5e7Bf0gJ60+2+o6y89UaJhRi0=;
 b=T1000cryZUO7UVqURtpp8yHpMdqCd5iO7Rd16ubE9CppmJ9Q4PsiCK9yvwKmwVAN6KlxJQVoBMxNKQpEzD/hvmnGDQXmgA4K51m7FKzDY/jjNQCii0J9RieQrQQ0NFGz99L70LCteGhF6YjsVJ1biUGDcvV1oNCzZZd6oeI9yPbOtax9UkerBDHK8DtyH894BsBSIRw8pL9cSXNtLDe6UTS1JNVCZdhuagnsp434b1ETuEkk9fq+XvVEd7oHElJq/dv4NN9IwzolpwLeIzZTTfzU+r898XwBbv1H5ztcYlMDXMvjRmnRFPPm8LoAl3QUBc7acEkZq2qOXvfblX8Lsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oTnKs+99hfYPNpv6B5e7Bf0gJ60+2+o6y89UaJhRi0=;
 b=SYA80Vcy3OQ2J70pquhjzMmSoHrUuVAHKBOMqvOjOLU38xdQ540CsORrGYw+pA2dYKoYgQ8EGV08OjvZkj1exEWEkVdKHzdA7DalEOdnJiKw4qCZTox2eneUtFJl8CCHqdmdeTWaPyharScoc9XuOZSLroKy5MI7VNsTOoRMBoU=
Received: from MN2PR14CA0009.namprd14.prod.outlook.com (2603:10b6:208:23e::14)
 by PH0PR12MB7960.namprd12.prod.outlook.com (2603:10b6:510:287::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 18:56:13 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:23e:cafe::6b) by MN2PR14CA0009.outlook.office365.com
 (2603:10b6:208:23e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:56:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:56:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:56:07 -0600
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
Subject: [PATCH RFC v8 42/56] KVM: SVM: Add support to handle Page State Change VMGEXIT
Date:   Mon, 20 Feb 2023 12:38:33 -0600
Message-ID: <20230220183847.59159-43-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|PH0PR12MB7960:EE_
X-MS-Office365-Filtering-Correlation-Id: c0a16c03-50c3-46aa-4f8b-08db13742331
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zXiZRPF0W4XDM4q3RnB7OD7rElj42Oz11iFGYErcPpQP2JOqW2HPabKdDhDsgWFy1H+m4zhVfhdeTmfyQBNwlZldemr/KpdZr2ReUcyCC0n+Pk3zVpgKd1UBdkCtAsYKlXQO2Z+2ffbl2rcTxyJEWLanBXaN4+XFhEgdJc+2bGbw5EgTdn0qnAGQjZ20JSpU7AE+1v2kYAnnubMo2hOCLwybDky5/A3bHQwy0IjbSf5K5Jji48qiorQvx40NojUgG5aa7PxkCENF18ZZEkOHI/WqeuPmTGpfxPTRJmJd6cYL93KrQqXcKoOSnigEJsgprnfC+gnIyepOGfDJBEMFLoHrogYbMCNOVNaVqgDzAP9JeMdjYCy7ELhTTTs9zDxVK4gjpgU8ovYySN7DE+l3DuyEHQjpdO4p2NCIyqpuDCumDz+OyDRzivblOfel9A79o8b9lwdgj/Ov51DT84JFUADI6JySVlmnB/3N/UWjov/x7SUxAGE7bmBskwuAKXuSsJcmtebN5t7sNVbKB/mVgSfG0fD9t8kOpSeF91X+xc/f6o0VJmPzKAkM6G0b8aqx7BhanPUDxiaLgwjz0kxynU4icK7wqDd0Y9rVtnVWCdeTI09RzT/c1HKexd/3aI5D6E3m2wu8tsyYQDjj/SkdFp1rlDgB2ceNjNzDj+ARW336aBNmKBvIAfNZWPVPbeid9qrAQasinPi5F1goRoK4gw/J58oXj3DLpy/fbKt7Hzw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(40470700004)(46966006)(36840700001)(66899018)(26005)(186003)(8676002)(6916009)(4326008)(40480700001)(7416002)(36756003)(7406005)(8936002)(316002)(83380400001)(70586007)(2616005)(70206006)(16526019)(6666004)(1076003)(5660300002)(336012)(478600001)(47076005)(40460700003)(54906003)(426003)(356005)(41300700001)(44832011)(86362001)(82740400003)(82310400005)(81166007)(36860700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:56:10.7187
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a16c03-50c3-46aa-4f8b-08db13742331
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7960
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
 arch/x86/kvm/svm/sev.c            | 20 ++++++++++++++++++++
 2 files changed, 27 insertions(+)

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
index a1a2686dde7b..102966c43e28 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3152,6 +3152,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
+	case SVM_VMGEXIT_PSC:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3363,6 +3364,19 @@ static int snp_complete_psc_msr_protocol(struct kvm_vcpu *vcpu)
 	return 1; /* resume */
 }
 
+/*
+ * TODO: need to process the GHCB contents and report the proper error code
+ * instead of assuming success.
+ */
+static int snp_complete_psc(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 0);
+
+	return 1;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3606,6 +3620,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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

