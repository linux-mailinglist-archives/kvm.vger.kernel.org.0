Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E3C64D0BA
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiLNUJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiLNUIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:08:55 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDFD389C2;
        Wed, 14 Dec 2022 12:01:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=et/pSCXO1Pu7zUui0Dt88nBwf8QcIBM0mH7v1AL/XONJc26rvBcDEzKpTmk+4ppNhb4lhnSFmtd3ROCDdr0AMYRs4czsdEIejZbl+f+erE+lgTxWLMR8WxJL1eshOD1k4BmAkuZajdscsAc06lyb2pJ1zQi8Wz7ivrCVOHGTXEzVwNvUCwhF4I4u1A9dzQs34hEFHa7DYyccxfdKcxUMOz9sl7v/J73jkHAngWEzTB5ghZGoDLy7kFmvwz0yZkqV6RtE+HRR15bAsGMjxFempjQ/YNhF1KtuaZzgvuNfC9j5nqzSm/OBMcSHKXZGoDSTVG0yJSknQnMd5r5pscIPcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GlVqa2qmkaaiQMe4N6o7Bdn+VWWRYcbCRi5kfE+AEcs=;
 b=VOFO1kFg9cIn1nbmsYnyptDGWujJMbH9CddmAWGDCzTNHashUJP63+E0IIkzon0S9h/sth0Laz6IMSjAoXMypNJ5LxKQhtZTkavGXaKBQjV6cszccK+dL21I3zLL9hCfA+Vxa8PnIzlw0kwNTGo1zvSfx9hUBu8pCvdcdYWW9q0OgShHTjL0Ul6NTdV9Nfe7PG7VLKCcoD5DcGdMvDeeM+7JbEahpIZOxLRMv35tqSp4ByiMxjyZ5Vg9KsPT3x0LRm2BbU6Us29WmwyC1tv/dEF5MX9n8hgNX77CpHqDgu3LLNpreN3faAdTKiSwusp+duPJlWBF8K++sDKMq0tcoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GlVqa2qmkaaiQMe4N6o7Bdn+VWWRYcbCRi5kfE+AEcs=;
 b=y2yuMNXdA8MtNSwuQ+OFJ6s+1acdCDTG8U1Ve+cHOduen30yoNZAlsOhM7PIVvsalhclr+xgju3bljR1NSFgSX9eXVg9s8ZF0xu2XBERtknFNNzflA1eiePWtoPcdenG26TvIHc18w++L+D6DWM2sxtygZgl6rTi/RoXyt9cEdI=
Received: from DS7PR05CA0094.namprd05.prod.outlook.com (2603:10b6:8:56::11) by
 MN0PR12MB6223.namprd12.prod.outlook.com (2603:10b6:208:3c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:01:27 +0000
Received: from CY4PEPF0000C971.namprd02.prod.outlook.com
 (2603:10b6:8:56:cafe::cd) by DS7PR05CA0094.outlook.office365.com
 (2603:10b6:8:56::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.6 via Frontend
 Transport; Wed, 14 Dec 2022 20:01:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C971.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 20:01:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:01:25 -0600
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
Subject: [PATCH RFC v7 47/64] KVM: SVM: Add support to handle MSR based Page State Change VMGEXIT
Date:   Wed, 14 Dec 2022 13:40:39 -0600
Message-ID: <20221214194056.161492-48-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C971:EE_|MN0PR12MB6223:EE_
X-MS-Office365-Filtering-Correlation-Id: 8663c683-ff99-467f-5989-08dade0dfbdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZveNpknXwjrnDQoLsSKWEAhz/NYf2kdEvJ1IE3GEcX8Hf8i0u8He+dteQrFLohtLbQztcQVYbyppdEUF79rupi20ct4PlotG4MQxaFaUCXeAfLPKoHfZ+fJ5S8Osw9b63Q/Q7KWAhQAMSTLf0c/QTw9vr2h5xmHX+QJ6ln2ax0hVmgw392Jz5erztSez7g8OAS+AW0gJYrBhgAV6YFJVnKjxKmUloq4QtGiXDKwkTcIAcrh0t3L/MA3g36LG+iqyJMz0EIij0Fhg1qqepZRVv+aYnNkhxsotn0udiwWSzG2JGkK6J7OspFsWfTs36O2z44NDnRpuOuxmS4Gzl6o/p9H/7JgDwSpIw6mkIA/ru0BRTefqvwqsk0OqdXa3revYQP7Wh9ky9YjUafq751G4tnT3+hNoRoI6GdiiYv/pWfIah0uUK0j/O5iSSko8u3+l2C77FcPB1PnsXy66cyRncxANdbsev7cD898kUrhUTR7b/IQXxg45KxcLbI9ATWhMahL/jhcrxA9x9sBAD5xlE9rRMNTuw219IFa3sJOfbTrSkYAJpqbK3Iik+wYuMpHpEvLxAXYvNSqM6g9bilC38FC/PRtEn4Rp0VtcfMOetQu8/UJJInxzqvKX49F+jLff882RdyFYAPjXAy7UbA1eSM+iT7X+Jcpi6aoqoIlyO+A1SCisQnrj9zWps1nJXJWRwFNxcLZM7WwZm1APylQr+Sn4nI1HEqGjaPtcb9zsxRE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(36756003)(40460700003)(316002)(44832011)(8676002)(7406005)(8936002)(7416002)(41300700001)(5660300002)(16526019)(426003)(47076005)(356005)(70586007)(2616005)(186003)(70206006)(336012)(82310400005)(1076003)(4326008)(83380400001)(26005)(40480700001)(36860700001)(54906003)(6916009)(478600001)(86362001)(6666004)(82740400003)(81166007)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:01:26.6912
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8663c683-ff99-467f-5989-08dade0dfbdf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C971.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6223
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
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
index d7b467b620aa..d7988629073b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -29,6 +29,7 @@
 #include "svm_ops.h"
 #include "cpuid.h"
 #include "trace.h"
+#include "mmu.h"
 
 #ifndef CONFIG_KVM_AMD_SEV
 /*
@@ -3350,6 +3351,23 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
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
@@ -3450,6 +3468,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
index 732f9cbbadb5..08dd1ef7e136 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13481,6 +13481,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_snp_psc);
 
 static int __init kvm_x86_init(void)
 {
-- 
2.25.1

