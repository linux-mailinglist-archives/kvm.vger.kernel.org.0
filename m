Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119FB2D642A
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392643AbgLJRxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:53:00 -0500
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:37494
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404084AbgLJRMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:12:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmsm0G9ubvaf8KcXhzJlaVp1rYDiFVsjJ/ocn4P+gddb4eWG3EvIEJuVuJfYh9bU3cgSX8WJWMRqP7FMOF/ISdi+IasZi25ZIr+DwWkdf5P/JF84j6DkmMUSTgpFhFHE4qThuE1qL6PWVoY2jN8sKc3jOUbyRAHjUwEZPvykvKnDMDxz4rM5TmuQHnhnE1c8oy4YXDc1jrNNLABcI7e5tI/d/AGpdKWzCobW/UUk/0JUbPeHiNLs0yal7x9Q5Uz8a5g5jk+FAYooBamskpZenIXpz/M7aR6hFHoqz52rgBzEi6OsEaNUOCMW0tMnnfc9/ptXz6d/D+KS7fV7CLt6JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQBOjEstY8Di5CYgkGzWr+hnLpGjJq9ZYa0v9l9Zj4o=;
 b=mIf236rP6gtMiE78b+RoOiGsZbXiF44SuE6WS8GpnsOeDqzABe3b/PqsbxOBLDx9GoKvzbZRhgosVXp1YgNj1k0Nb7QKSIj2amMSSoZwNWG1O9cWiQTAfUGvdYuLPFqbhQfb3eVwlgio2ranGlu6mHAYymJGVzMXQr0IS9yfX/J6vEc9EbnSobCY/Ni+l15x1gUYLyMVf+subco0GfY/D9dHrVvbnVM0CoOItKmPgRTsIQCoKh2mCZpoDoh6MQR9rSqsYdKxnMOBF6IrqYhopds620CUq4ovG/Y6HjmwSENEFTbGL6Fl9lnfzYRxJ5otsOq0/C2wpZsqG6ShhdPEEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQBOjEstY8Di5CYgkGzWr+hnLpGjJq9ZYa0v9l9Zj4o=;
 b=MMZHVfwsv1Lpt/muPHpI/YKb/T8qapF7CDFmuzTIwvNS5r2N6W8womydAmVpZSXLT6t4U3PFSsiYeHwhUj4eVPIJpGWbQ66m9oviC0URJDQQK5ScduEzhy53Y/NqeL347QKWeIclyaZLhyNf/QK1dm8ZtY3Gltr51vJ2Z5aTWkc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0168.namprd12.prod.outlook.com (2603:10b6:910:1d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22; Thu, 10 Dec
 2020 17:12:13 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:12:13 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 13/34] KVM: SVM: Create trace events for VMGEXIT processing
Date:   Thu, 10 Dec 2020 11:09:48 -0600
Message-Id: <25357dca49a38372e8f483753fb0c1c2a70a6898.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR14CA0008.namprd14.prod.outlook.com
 (2603:10b6:610:60::18) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR14CA0008.namprd14.prod.outlook.com (2603:10b6:610:60::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:12:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ad14ba8-81a5-4f04-bdf0-08d89d2ebcbb
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0168:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0168B7B9865A4B4DEC8A4CF4ECCB0@CY4PR1201MB0168.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zwd+8+WEQQ4kv2hYPDnUNg0k9yKBhPn5Y8AFONS03wZsBnoWwsu6a/ntOfD/Sh4U/UJS1yquwHU4SIvQHL/yTT/KkyAhhSVcn/0IcT9z5raEIjItQAPnKzgl9uBCMaJl4naZXTt0bRFNaMalcAgFT3cUb2axfJuVpu9lXi8xGfnWSqb8QBjNN/efqjRw7IxMVCrSVoKPKqCE7T8mFTeUnadnlKF3y4rEx3FaOgizSqToeOZvkA9cPV1r39954bSjuNqOj7+STlV4RNYwsGdZ/G/1rTKzF410Va65m4tqjnTlBpt76MryncQlaEnzllPvnxUa7wjkg1qqnyq0QqS6l9gdqOXM6XNWsKEyjvRJem5pVGcHaPFL8R9p+KwYvq72
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(36756003)(8676002)(6486002)(4326008)(66476007)(86362001)(7416002)(66946007)(7696005)(54906003)(6666004)(26005)(16526019)(34490700003)(66556008)(8936002)(83380400001)(186003)(2906002)(2616005)(52116002)(956004)(508600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?b4erJJ9temJs000Gw/blBz6wVZ1SYZOlhHDAIP0L6oq8GZL6CZLqPdY3tN7F?=
 =?us-ascii?Q?wUjgaavFtyr5rnu/HeroXSRRkTUYZY8Qzn7dGsWs/pLJMRvp2KdGR7Gya4+G?=
 =?us-ascii?Q?9bbnsB3uGNH2ipwpcSE6M81+lssPyAUZ7vA1S1LmIYgHyMhRG6OeGHY4pTAB?=
 =?us-ascii?Q?mhUi/JOo3if28A5fxXFUOfoBdSkJ+Lsb2NyXZOxgX9z6J8OuwpBwGuuNZJTh?=
 =?us-ascii?Q?sryzzeMEOstevW9hI1DGpRDZi8CWOKpmH0nB0kVzvOww52ycSrj6wVmi2u7N?=
 =?us-ascii?Q?Hg9hmZYKS7WzHdyOrp5P6KMJa43YCYM2CJ5f5FqwIlfisizpDBwFzdKp9xAu?=
 =?us-ascii?Q?BTni311NqTvCKK7iZrC+LrlnTg+hGLbh4KDsAErDY/Zh+vyMXSz9nqt3yJzL?=
 =?us-ascii?Q?2DYWUp9KVrEEIhh69m1Uc6GnzcZHEfUiLsAarLHsuBcrwAvpuIUwnvjnioZ+?=
 =?us-ascii?Q?6JY03Pn9KEnF0KW6alKC4IZ+bsttfVJQmsxg/1eUnnzC2ekWVeHBrxLfuFrF?=
 =?us-ascii?Q?ApVC7UZ9Og45Pq7Stdx1kWElq1ztCMi2a7gcV0qnCfpFuZm0NlnXxdWixe4z?=
 =?us-ascii?Q?4KAkEt9wRL+frL8zjrgKff9QOTWZR4uq3k45msQbLZHbXvYJ12h4u8B1kLjY?=
 =?us-ascii?Q?+x5QuFPr35C4iX4mYZXNyJmFnPh8SUCwAK9H5YCVQrVVeEztAaTx4d5tFNwz?=
 =?us-ascii?Q?9ProMwN+JLT1ar7kHzGP8LlyH7fFwVBXdq7bfmaWQiDrXThGFqKZ8ZXrBkGc?=
 =?us-ascii?Q?+NP+GSsf1rwUmtmNnesmjOr2EssUSBAWnk/es22BfYGYVrzHA3xHEbDdsSDc?=
 =?us-ascii?Q?HwODYUd6CdusfnOq28MPdG5NrHJ6L0xA9GkKyhFWeEIK9aC7MwpgOwj8ZmFs?=
 =?us-ascii?Q?Z2+vSPwV8ax4IJq/J9wr8jkZnm8h13MSpuhYtgql/YW9x96iF2BUk6r4jZBw?=
 =?us-ascii?Q?BqmLJNMu9giv5szOC3A2sIQE0Miucajia8h3zdWE7iXreqqLZmlMD4S/yAD3?=
 =?us-ascii?Q?sZsX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:12:13.2642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad14ba8-81a5-4f04-bdf0-08d89d2ebcbb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bK9m1S89Nze8BFK1VSE6j01ncVU6DrSOz5kpc6QigWF1wG1OtTNckHOz3yKp3mZSXQDbPCCm8GrTgVKmshbQEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0168
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
index 54e6894b26d2..da473c6b725e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -15,10 +15,12 @@
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/processor.h>
+#include <linux/trace_events.h>
 
 #include "x86.h"
 #include "svm.h"
 #include "cpuid.h"
+#include "trace.h"
 
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -1464,6 +1466,8 @@ static void pre_sev_es_run(struct vcpu_svm *svm)
 	if (!svm->ghcb)
 		return;
 
+	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->ghcb);
+
 	sev_es_sync_to_ghcb(svm);
 
 	kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
@@ -1528,6 +1532,8 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
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
index de0e35083df5..d89736066b39 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11321,3 +11321,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
-- 
2.28.0

