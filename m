Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A074669D38E
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbjBTS6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbjBTS6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:58:43 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2076.outbound.protection.outlook.com [40.107.95.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BC04C21;
        Mon, 20 Feb 2023 10:58:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oty/0k97/2sXklFEt4E1qbfNT6u0BPJjIU+E7gs++s2hInTN7R0mkDVEp58EeZcyL0sVjifIGCAjji/GRbMxVlx+v+Bno80eQ4i4dZuMOIBHSdiILKeboweGpxNXltH9PVSAS/3jYSwNkN1wQWYNk+VNWsvT0fIaAPFYgrH/Gyi6vReqlPe//k6PyNDXE/chzFhyPK/PCz8DzZowW4yXkxmuBk56iLRd9riFghqSC3nxbFckXQFfRy1XO9ouMKWi5LIhNxqoCC3Wd13G4tO/bE6UkMcuvLpvh1VBirahG/LiWjVNBqnPWzf4TRYpLNh9lD9z1l0ldt1yVLDEJkj3rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwBov8mAFc4rrnqr1KAE9hELe45EaYrVBKIRrG+aCxU=;
 b=f6d0XajbeCngJgkKn3r3FOQ/FiW1lNhJwt2YbdEdP4Be6EoPq3nw2KCcRh7yxpSwvlsXj45cjOEKb/56JZs2wSk4rHi6+VvlABH7sLgzNnt7YX1R3id8f36EjMUv9MxIcRwQHHd9kHN5Gr/EgHl3sDiK0iTI27DELU+hsKauE7tmIyj9WejquLgH4ZmhhjWjkr1rvVFGb3gHe9CxPhOmpNiWhi5HgnUvdSwAs6fR4b26tbERYRMGfihbvJYCavYgGPIfnfkVIAP8rBwV3S+qRp7wBOmoan1+WS9F383FJCIXQ8e3rBLxbmOFoveBODALOpVetO7+GKAsS7VtmxtsLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwBov8mAFc4rrnqr1KAE9hELe45EaYrVBKIRrG+aCxU=;
 b=ljOVuFjzzYASCrCea6lweTMywjNu1/hFlgobFFsIvGZwqTLvjQ9ONJQUqFrdcuwykHLBsiCj1TCAMlsbGoga4wp54VUP5SSCXKtP13WpRE9O7FDu2CHvYqieTzdCCdaiItPH5xJR0tQ6vxPrj5850Rv1AoRaUfWb47G9TAna9B4=
Received: from MN2PR14CA0024.namprd14.prod.outlook.com (2603:10b6:208:23e::29)
 by BL1PR12MB5063.namprd12.prod.outlook.com (2603:10b6:208:31a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:55:47 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:23e:cafe::98) by MN2PR14CA0024.outlook.office365.com
 (2603:10b6:208:23e::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:55:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:55:47 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:55:46 -0600
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
Subject: [PATCH RFC v8 41/56] KVM: SVM: Add support to handle MSR based Page State Change VMGEXIT
Date:   Mon, 20 Feb 2023 12:38:32 -0600
Message-ID: <20230220183847.59159-42-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|BL1PR12MB5063:EE_
X-MS-Office365-Filtering-Correlation-Id: fbf6540a-1c30-43b7-58a6-08db137413d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c62kbVw9zE4fIBkaCtccrEtX1RIli5gtFwVktJlGxRK9FSy7BFui0tXfp3Zt//aetJlfvNzu0aSuWqnMlshiDgi5s00EuLkPvyKVQZFzZylNQE9oSVo23T8GZ07ehwn2e6PQDJzSyf8/qE5+m8NhI5YExSdUEyQs26JDVsnu7ETwL+Zmh1J82hZsgiI7AxFmXnFWqOLIfMsfpsxECob79aOsuUHcn1gnuRsLu7J8sl3A8hdhQHS7ybds+/tTLvkPNUxLFBYGlVgzDRXNot9c+YaCBQvSWSqG+x1/zbvLj6ubwXfXUhquoEmxWwn9kTH4n7kkn4NY1MZpY7RKA69cdUatKcXeTXWSI9O1crgeJxBbeQS5V5y/7e3jgwCE2DNJpYdbVpqrkbMRm+d8joZJP75htmtjqwCj2CCNSEbC4rcYIPlS5eJMWVKUrU4kA4ykhVv1metnhDjg4zOcuMlorhVqoV+rYwnbSub/Kz6f9mZV1QJH38NOc/6+WT+EuGSdjSnV/rQvl4syFV1VAEhy/TU9mOtAQdo3ufElFkp89HkryFygm7SPP6DT5sveTP4PH7suKxLFqgZM5INKaecNNjJDyY4puJWxN4EfzNu8COAxsOVh9zOh2pPey2vV2XKMivvRgVwEMaKOseo5EJb0CL46PH1jditgMABNvKJbP4PIf91wgJxHBVR8yTmYqh4cTVL9T76kiXUo238w8URqBcHDXo8VwA4HDq0M6w+Inuo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199018)(36840700001)(40470700004)(46966006)(82740400003)(81166007)(82310400005)(36756003)(356005)(36860700001)(16526019)(40460700003)(40480700001)(6666004)(26005)(186003)(70586007)(1076003)(70206006)(4326008)(336012)(2616005)(478600001)(54906003)(316002)(2906002)(8676002)(6916009)(83380400001)(5660300002)(7406005)(8936002)(44832011)(86362001)(7416002)(41300700001)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:55:47.1715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf6540a-1c30-43b7-58a6-08db137413d3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5063
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_FILL_THIS_FORM_SHORT autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change MSR protocol
as defined in the GHCB specification.

Forward these requests to userspace via KVM_EXIT_VMGEXIT so the VMM can
issue the KVM ioctls to update the page state accordingly.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev-common.h |  9 ++++++++
 arch/x86/kvm/svm/sev.c            | 25 +++++++++++++++++++++++
 arch/x86/kvm/trace.h              | 34 +++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                |  1 +
 4 files changed, 69 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 0a9055cdfae2..ee38f7408470 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -93,6 +93,10 @@ enum psc_op {
 };
 
 #define GHCB_MSR_PSC_REQ		0x014
+#define GHCB_MSR_PSC_GFN_POS		12
+#define GHCB_MSR_PSC_GFN_MASK		GENMASK_ULL(39, 0)
+#define GHCB_MSR_PSC_OP_POS		52
+#define GHCB_MSR_PSC_OP_MASK		0xf
 #define GHCB_MSR_PSC_REQ_GFN(gfn, op)			\
 	/* GHCBData[55:52] */				\
 	(((u64)((op) & 0xf) << 52) |			\
@@ -102,6 +106,11 @@ enum psc_op {
 	GHCB_MSR_PSC_REQ)
 
 #define GHCB_MSR_PSC_RESP		0x015
+#define GHCB_MSR_PSC_ERROR_POS		32
+#define GHCB_MSR_PSC_ERROR_MASK		GENMASK_ULL(31, 0)
+#define GHCB_MSR_PSC_ERROR		GENMASK_ULL(31, 0)
+#define GHCB_MSR_PSC_RSVD_POS		12
+#define GHCB_MSR_PSC_RSVD_MASK		GENMASK_ULL(19, 0)
 #define GHCB_MSR_PSC_RESP_VAL(val)			\
 	/* GHCBData[63:32] */				\
 	(((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2613311f4fcc..a1a2686dde7b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -30,6 +30,7 @@
 #include "svm_ops.h"
 #include "cpuid.h"
 #include "trace.h"
+#include "mmu.h"
 
 #ifndef CONFIG_KVM_AMD_SEV
 /*
@@ -3345,6 +3346,23 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+/*
+ * TODO: need to get the value set by userspace in vcpu->run->vmgexit.ghcb_msr
+ * and process that here accordingly.
+ */
+static int snp_complete_psc_msr_protocol(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	set_ghcb_msr_bits(svm, 0,
+			  GHCB_MSR_PSC_ERROR_MASK, GHCB_MSR_PSC_ERROR_POS);
+
+	set_ghcb_msr_bits(svm, 0, GHCB_MSR_PSC_RSVD_MASK, GHCB_MSR_PSC_RSVD_POS);
+	set_ghcb_msr_bits(svm, GHCB_MSR_PSC_RESP, GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+
+	return 1; /* resume */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3445,6 +3463,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PSC_REQ:
+		vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
+		vcpu->run->vmgexit.ghcb_msr = control->ghcb_gpa;
+		vcpu->arch.complete_userspace_io = snp_complete_psc_msr_protocol;
+
+		ret = -1;
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 83843379813e..65861d2d086c 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -7,6 +7,7 @@
 #include <asm/svm.h>
 #include <asm/clocksource.h>
 #include <asm/pvclock-abi.h>
+#include <asm/sev-common.h>
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
@@ -1831,6 +1832,39 @@ TRACE_EVENT(kvm_vmgexit_msr_protocol_exit,
 		  __entry->vcpu_id, __entry->ghcb_gpa, __entry->result)
 );
 
+/*
+ * Tracepoint for the SEV-SNP page state change processing
+ */
+#define psc_operation					\
+	{SNP_PAGE_STATE_PRIVATE, "private"},		\
+	{SNP_PAGE_STATE_SHARED,  "shared"}		\
+
+TRACE_EVENT(kvm_snp_psc,
+	TP_PROTO(unsigned int vcpu_id, u64 pfn, u64 gpa, u8 op, int level),
+	TP_ARGS(vcpu_id, pfn, gpa, op, level),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(u64, pfn)
+		__field(u64, gpa)
+		__field(u8, op)
+		__field(int, level)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu_id;
+		__entry->pfn = pfn;
+		__entry->gpa = gpa;
+		__entry->op = op;
+		__entry->level = level;
+	),
+
+	TP_printk("vcpu %u, pfn %llx, gpa %llx, op %s, level %d",
+		  __entry->vcpu_id, __entry->pfn, __entry->gpa,
+		  __print_symbolic(__entry->op, psc_operation),
+		  __entry->level)
+);
+
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 268c3d16894d..0154fc7a28c1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13515,6 +13515,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_snp_psc);
 
 static int __init kvm_x86_init(void)
 {
-- 
2.25.1

