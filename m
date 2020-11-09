Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DBA2AC86F
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbgKIW2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:28:02 -0500
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:21697
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731878AbgKIW2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:28:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmkmCdxfQ7fgZ96CTmEIt7oRRqtQZT5EZz07QVEtyp1dXRd1MtF/eXrR3fUgSWuuDGSqlQbspHsQ2/iMYGtXwKH5XuQwTXIMHz/t20mlHeZyHo+CP4TE5CLLIMfoxHv6ctf4fGwQts/owkDsTurq7TdmzXS9bYVCd5leHtAsLAokA+hoQUxqHd89kZPikrUsE3ZfJGnYiD1otpGJyIim5Y0bgdq+aYzVFgvJzOrKLyXP9cAIrRBzkUXx7bBhOGWL5MK26YOdesi4ywPXKMIJKU3YLz0E5Cv4Jt2jWmj2Evd6ih5MTnyWwaCQGGJIkP6e7fzYuYtHKn56X1apk/tPvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qc4ddLWHfEZnsgbOq54osUdNdKRMmtrcQdIIXdx2oH0=;
 b=lrBUG/CAax40CoRDaduMJWT/FioVXmXwS5l2uDKAcTmpYLynhBMa5ihdZUAVlaEOInj/T01h1Y3z3ChWFZ1wP2KjEww5lmEGNnLOzn60T9Gb7UBzcx+LZu+11JJq2ha0Q6PC+t+OXXfQmgLs3MeFtmXd5Eap+YnVpEOQaJ/OL8raJwwxx2jYigEcAtTzQSXI/ZATZyiF6md5WgFcM0TfHVif4KyxtOTq83bIszE9jEiTWd94GGyinOI1Be3M37mh6mJ/zfB4+Ndd0emexo+jzx0RZP6QWKN8zcIygnJmfNTTX9UAWSS2mddeSqXWz9/aOPFv/lFhauB7qLXvJpVo3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qc4ddLWHfEZnsgbOq54osUdNdKRMmtrcQdIIXdx2oH0=;
 b=0vORDQ8ALwz1fGg+9mBRb8bKyxvxIUDyX+2si6MhSUNuX7EcVxBrhsppty9g0vXCSF1rsmUckHDkHTrUQJ/K7NBUWcyc8iHXb45tEnJ7UG3jT7naF718gD0hxcm9wdomDtZtYQHR4kN4n92vHhSvV3+AppUbETpG37PpXUMVAYU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:27:59 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:27:59 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 13/34] KVM: SVM: Create trace events for VMGEXIT processing
Date:   Mon,  9 Nov 2020 16:25:39 -0600
Message-Id: <297f61fb8e48c625a2e2a9f548dc250b2e3f82f7.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR02CA0121.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::23) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR02CA0121.namprd02.prod.outlook.com (2603:10b6:5:1b4::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:27:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5310856e-df0c-4597-4e9c-08d884feb66b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40581D2744899AF623DE2676ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O08ER6Ww4xsWI3WffUQu/tyAVlnNKCSvhY+02jsgnRkKQ8O0h7+wE/77gAD1/Sri+E8jWPEs0bbeU12VAoLCc8iN4UZx1XGLkPEsXpcTlnXWY3iGwfDU5KSnNJ1MYLne+5dQP7RqjUhPb5oT/sqTAjdMuNb1Nc9FMY+aVkFsRk0aZma/I57uuwk1Wt2wADMcrPHuRryZvPQsPQQUuR2JmIggnMndkiN8PSOlQDjM8f+TFWlm+6whnl0HTxAFxa5mb8/D1pg2/4FKyy81imIZiuG0Cf7QpZoNmgTn0kCz8L8DLk2k8ObtKDCxyNGXJVfu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CZ4c3sRZKdGlM/Vq4iTwyngzowcQQyrJyJpW2CmgiGzXc1M5mt/nFj4iNd1iKNeWg9mfTR9kORUCfOlljrZdyAYO7CVbh+jXPW4cYvdM5PXhDaTUO3IMWU0Wb42FCA2LnQV56g3YnsJaRjf4H+KEtQn28kn97sX6rrCkcC/Cv3t04yMTotDzphLG6H30D9sgDVHsditBP0w+oKKxS9Ol9l6BntyOy72uxwlBlkiCbVquRZyuFaBI/St793BJgPEGpfLysQPbZqy/EmFzpqaXj0bBpVJlD2LzbhOjuwPpWDGIUOIYKOhB+BxYQ6L/I7CldtKZYrtyOldv5pVC/ZVT/tPd3qjywaI0Ht9HAWnt72JP/FZAijZcLHXUZOtbeUS2cYkXlwMJHDXjo1uXvoo+TJs9H1PBdNcUMr7PPTW+6WUTXZ6jtoa4dTT4uzkbME3j6PgiTQCXgCsCBYwV1qMvE1vmkbuONfIJVUuX4rtXj8hlreo5T2Xil8nhG/neGyDigURsW1Afmtj/Io+t55k923dA7vyfeGg4noPUZ335frdDZh+zVZVPQB8JGfBdxclRrEiiYhuOOMEQ1ARLiD79eiv30dLFJiY3pZog3UmxiCuiJcj1iCW8Rvtoege0jnJahYuoxJwWI1AD2a8cXoQCyw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5310856e-df0c-4597-4e9c-08d884feb66b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:27:59.1759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Je9DSS5KK8ADYPXvoO9+1Oh1g27Up8dtI+YA5cNbByln8tIqcBurho+84SgxTd7iBnfDyKCxrPOxxcglLYWxdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add trace events for entry to and exit from VMGEXIT processing. The vCPU
id and the exit reason will be common for the trace events. The exit info
fields will represent the input and output values for the entry and exit
events, respectively.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c |  6 +++++
 arch/x86/kvm/trace.h   | 53 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     |  2 ++
 3 files changed, 61 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 50afe9af4209..6128ac9dd5e2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -14,11 +14,13 @@
 #include <linux/psp-sev.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/trace_events.h>
 #include <asm/processor.h>
 
 #include "x86.h"
 #include "svm.h"
 #include "cpuid.h"
+#include "trace.h"
 
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -1461,6 +1463,8 @@ static void pre_sev_es_run(struct vcpu_svm *svm)
 	if (!svm->ghcb)
 		return;
 
+	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->ghcb);
+
 	sev_es_sync_to_ghcb(svm);
 
 	kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
@@ -1525,6 +1529,8 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 	svm->ghcb = svm->ghcb_map.hva;
 	ghcb = svm->ghcb_map.hva;
 
+	trace_kvm_vmgexit_enter(svm->vcpu.vcpu_id, ghcb);
+
 	exit_code = ghcb_get_sw_exit_code(ghcb);
 
 	ret = sev_es_validate_vmgexit(svm);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index aef960f90f26..7da931a511c9 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1578,6 +1578,59 @@ TRACE_EVENT(kvm_hv_syndbg_get_msr,
 		  __entry->vcpu_id, __entry->vp_index, __entry->msr,
 		  __entry->data)
 );
+
+/*
+ * Tracepoint for the start of VMGEXIT processing
+ */
+TRACE_EVENT(kvm_vmgexit_enter,
+	TP_PROTO(unsigned int vcpu_id, struct ghcb *ghcb),
+	TP_ARGS(vcpu_id, ghcb),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, vcpu_id)
+		__field(u64, exit_reason)
+		__field(u64, info1)
+		__field(u64, info2)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id     = vcpu_id;
+		__entry->exit_reason = ghcb->save.sw_exit_code;
+		__entry->info1       = ghcb->save.sw_exit_info_1;
+		__entry->info2       = ghcb->save.sw_exit_info_2;
+	),
+
+	TP_printk("vcpu %u, exit_reason %llx, exit_info1 %llx, exit_info2 %llx",
+		  __entry->vcpu_id, __entry->exit_reason,
+		  __entry->info1, __entry->info2)
+);
+
+/*
+ * Tracepoint for the end of VMGEXIT processing
+ */
+TRACE_EVENT(kvm_vmgexit_exit,
+	TP_PROTO(unsigned int vcpu_id, struct ghcb *ghcb),
+	TP_ARGS(vcpu_id, ghcb),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, vcpu_id)
+		__field(u64, exit_reason)
+		__field(u64, info1)
+		__field(u64, info2)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id     = vcpu_id;
+		__entry->exit_reason = ghcb->save.sw_exit_code;
+		__entry->info1       = ghcb->save.sw_exit_info_1;
+		__entry->info2       = ghcb->save.sw_exit_info_2;
+	),
+
+	TP_printk("vcpu %u, exit_reason %llx, exit_info1 %llx, exit_info2 %llx",
+		  __entry->vcpu_id, __entry->exit_reason,
+		  __entry->info1, __entry->info2)
+);
+
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 569fbdb4ee87..1f60e4ffbbda 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11288,3 +11288,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
-- 
2.28.0

